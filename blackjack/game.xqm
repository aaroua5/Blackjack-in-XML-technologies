xquery version "3.0";


module namespace blackjack-game = "blackjack/Game";
import module namespace helper = "blackjack/helper" at "helper.xqm";
import module namespace blackjack-player = "blackjack/Player" at "player.xqm";
import module namespace blackjack-card = "blackjack/Cards" at "cards.xqm";




declare variable $blackjack-game:casino := db:open("bj")/casino;

(:~
 :this function return the Game using the ID and searches it in our casino
 : @gameID the game Id
 : @return the whole module of that Game
:)
declare function blackjack-game:getGame($gameID) as element(blackjack){
    $blackjack-game:casino/blackjack[@id = $gameID]
};
(:~
 : this function return our Casino
 : @return the casino model
:)



declare function blackjack-game:getCasino() as element(casino){
        $blackjack-game:casino
};
(:~
 : this function create a new Game by calling the method createNewGame
 : @maxBet      the maximum Bet of the Game
 : @minBet      the minimum Bet of the Game
 : @return      the newly created Game
:)
declare  function blackjack-game:createGame($maxBet as xs:integer, $minBet as xs:integer, $playerNames as xs:string+, $balances as xs:string+){
   let $game := blackjack-game:createNewGame($maxBet,$minBet,$playerNames,$balances)

            return ($game)
};

(:~
 : This function insert the user as a new player using his name
 : @gameID      the ID of the game in which the player will be inserted to
 : @playerName  the name of the User
 : @balance     the balance of the User
 : @id          the user's ID
 : @tableSeat   his Seat on the Game should be between 1 and 5, -1 if he is waiting and watching
 : @return      update the Game
:)

declare %updating function blackjack-game:insertNewPlayer($gameID as xs:string, $playerName as xs:string, $balance as xs:string,$id as xs:integer , $tableSeat as xs:integer){
                let $casino := blackjack-game:getCasino()
                let $game := blackjack-game:getGame($gameID)
                return(

                            let $player := blackjack-player:newPlayer($playerName,$casino/users/player[$playerName = name]/totalmonney,$id,$tableSeat)
                            return(
                                    if($tableSeat < 0) then(
                                                insert node $player into $game/waitPlayers

                                    ) else(
                                            insert node $player into $game/players
                                    )
                            )

                )
};






(:~
 : this function is called when the user want to join the game , it checks if there is freeSeat it will insert
 : the player . Otherweise it will add in the Waiting list and give him a  -1 as a tableSeat . Finnaly
 : it will delete the player from the Lobby List
 : @gameID      the ID of the Game to be joined to
 : @playerName  the name of the player
 : @balance     the balance of the player
 : @return      Update the Game model
:)


declare %updating function blackjack-game:join($gameID as xs:string , $playerName as xs:string, $balance as xs:string){

            let $game :=blackjack-game:getGame($gameID)
            let $casino := blackjack-game:getCasino()
            let $id := $casino/users/player[name = $playerName]/@id
            (:this tableSeat will be changed to count the case  if one joins and one player is already out:)
            let $tableSeat := $game/freeSeats/seat[fn:position() = 1]

            return (
                             if(fn:count($game/players/player[name = $playerName]) > 0 or $balance <$game/minBet) then(

                             ) else (

                                      if(fn:count($game/freeSeats/seat) = 0 or $game/step !='bet') then(

                                                blackjack-game:insertNewPlayer($gameID,$playerName,$balance,$id,-1),
                                                delete node $casino/lobbys/lobby[id = $id]

                                      )  else (
                                                blackjack-game:insertNewPlayer($gameID,$playerName,$balance,$id,$tableSeat),
                                                delete node $tableSeat ,
                                                delete node $casino/lobbys/lobby[id = $id],
                                                replace node $game/events with  <events><event id='0'><message>{$playerName} joined the Game!</message></event></events>
                                      )

                             )
            )
};


(:~
 : this function insert the new Game into the casino model
 :@newGame  the newly created and generated game
 :@return   Update the casino model
:)
declare %updating function blackjack-game:insertGame($newGame as element(blackjack)){
      insert node $newGame  into $blackjack-game:casino,
      replace value of node blackjack-game:getCasino()/numberOfGames with blackjack-game:getCasino()/numberOfGames + 1
};

(:~
 : this function generate a new  Game by creating the players Element and generating the game Deck
 :@maxBet       the maximum Bet of the game
 :@minBet       the minumum Bet of the game
 :@playerNames  the player of names to be added to the game
 :@balance      the balances of the player
 :@return       returns the generated game model
:)

declare function blackjack-game:createNewGame($maxBet as xs:integer, $minBet as xs:integer, $playerNames as xs:string+ , $balances as xs:string+) as element(blackjack) {
        let $id:=helper:generateID()
        let $casino := blackjack-game:getCasino()
        let $players := <players>
                {
                     for $p in $playerNames count $i
                     where $p != ""
                     return(
                            blackjack-player:newPlayer($p, $balances[$i] cast as xs:int,$i,$i)
                     )
                }
                </players>
            return
                      <blackjack id ="{$id}"  counter="{$casino/numberOfGames}">
                          <step>bet</step>
                          <maxBet>{$maxBet}</maxBet>
                          <minBet>{$minBet}</minBet>
                          <playerTurn>1</playerTurn>
                          <events>
                            <event>
                                <message>
                                    welcome
                                </message>
                            </event>
                             <event>
                                <message>
                                    to blackjack
                                </message>
                             </event>
                          </events>
                          <dealer id = "0">
                                <name>dealer</name>
                                <cards></cards>
                           </dealer>
                          {$players}
                          <waitPlayers></waitPlayers>
                        {blackjack-card:shuffleCards()}
                            <freeSeats>
                                <seat>1</seat>
                                <seat>2</seat>
                                <seat>3</seat>
                                <seat>4</seat>
                                <seat>5</seat>
                            </freeSeats>

                            <loosers/>

                      </blackjack>
 };

(:~
 : this function is called when cards have to be served ,ie: the game has to start.
 : @gameID      the ID of the game to start
 : @return      update the game Model by adding cards to players
:)


declare %updating function blackjack-game:startGame($gameID as xs:string){
    let $game :=blackjack-game:getGame($gameID)
    let $card := $game/cards/card[fn:position()=1]
    let $random :=helper:randomNumber(40)
    let $randomWithPlayers := $random + fn:count($game/players/player)
    let $numberOfCards := fn:count($game/cards/card)
    return(     replace value of node $game/step with "play",
                replace value of node $game/playerTurn with 1,
                insert node $game/cards/card[fn:position()=$random] into $game/dealer/cards,
                delete node $game/cards/card[fn:position()=$random],
                for $p in $game/players/player count $i
                     return(
                            insert node $game/cards/card[fn:position()=($random + $i) mod $numberOfCards] into $p/cards,
                            delete node $game/cards/card[fn:position()=($random +$i) mod  $numberOfCards]
                     ),
                insert node $game/cards/card[fn:position()=$randomWithPlayers mod $numberOfCards] into $game/dealer/cards,
                delete node $game/cards/card[fn:position()=$randomWithPlayers mod $numberOfCards],
                for $p in $game/players/player count $i
                              return(
                                    insert node $game/cards/card[fn:position()=($randomWithPlayers + $i) mod $numberOfCards] into $p/cards,
                                    delete node $game/cards/card[fn:position()=($randomWithPlayers +$i) mod  $numberOfCards]
                              )
            )
};



(:~
 : this function checkScores after each round , if there is no player left, then it will change the state of
 : the game or step to gameOver
 : @gameID      the ID of the Game
 : @return      Update the game model
:)

declare %updating function blackjack-game:checkScores($gameID as xs:string){
        let $game := blackjack-game:getGame($gameID)
        let $nonBankruptPlayers := for $p in $game/players/player
                                    where $p/totalmonney > $game/minBet
                                    return $p
         return(
                if(fn:count($nonBankruptPlayers)= 0 ) then(
                    replace value of node $game/step with "gameOver"
                )
         )

};



(:~
 : this function is called to calculate the Sum of cards before the game starts
 : @gameID      The ID of the game
 : @return      Update the game Model
:)

declare %updating function blackjack-game:initliazeSum($gameID as xs:string){
            let $game := blackjack-game:getGame($gameID)
            for $p in $game/players/player
                return(
                      insert node <totalSumCards> {blackjack-card:calculateCurrentCardValue($game,$p,0)}</totalSumCards> into $p
                )

};

(:~
 :this function checks Recursively how many the Dealer has to draw Card in order to reach 17 or higher
 : @gameID the ID of the game
 : @sum the sum if the dealer widthreaw $limit cards
 : @limit how menny Cards have to be widthrawn so far
:)

declare  function blackjack-game:dealerTurnHelper($gameID as xs:string,$sum ,$limit){
    let $game := blackjack-game:getGame($gameID)

    return(
                if($sum <= 16) then(
                        let $newAmount := blackjack-card:calculateDealerValues($game,$game/dealer,$limit+1)
                        return(
                                blackjack-game:dealerTurnHelper($gameID,$newAmount,$limit + 1)
                        )
                )
                else(
                                $limit
                )
    )
};

(:~
 : this function let the dealer widthraw the Cards in order to reach 17 or higher
 :@gameID  the game ID
 :@return  update the game model
:)

declare %updating function blackjack-game:dealerTurn($gameID as xs:string){
               let $game := blackjack-game:getGame($gameID)

               let $amountOFCardsOfDealer := blackjack-card:calculateCurrentCardValue($game, $game/dealer,0)

               let $amountOFCardsToDraw := blackjack-game:dealerTurnHelper($gameID,$amountOFCardsOfDealer,0) cast as xs:integer
               return(


                      for $i in 1 to $amountOFCardsToDraw
                      return(
                                delete node $game/cards/card[fn:position() = $i],
                                insert node  $game/cards/card[fn:position()= $i] into $game/dealer/cards
                      ),
                      replace value of node $game/step with "roundOver"

               )
};

(:~
 :this function check the winings of the players. Depends on the situation it give Monney or take Monney , Update
 : the points the user has so fat , and change his status if he is a looser
 :@gameID the ID of the Game
 :@return update the model
:)

declare %updating function blackjack-game:checkWinnings($gameID as xs:string){
            let $game := blackjack-game:getGame($gameID)
            let $casino := blackjack-game:getCasino()
            let $amountOfCardsOfDealer := blackjack-card:calculateCurrentCardValue($game, $game/dealer,0)
            return( replace value of node $game/playerTurn with 1,
                    for $p in $game/players/player
                    return(
                                if($amountOfCardsOfDealer > 21 ) then(
                                       if($p/status != 'loser') then(
                                            if($p/status = 'blackjack') then(
                                                    replace value of node $p/totalmonney with $p/totalmonney + 2.5 *$p/currentBet,
                                                    replace value of node $casino/users/player[@id = $p/@id]/totalmonney with $casino/users/player[@id = $p/@id]/totalmonney + 2.5 * $p/currentBet,
                                                    replace value of node $casino/users/player[@id = $p/@id]/points with $casino/users/player[@id = $p/@id]/points + 1.5 * $p/currentBet
                                            )  else (
                                                    if($p/status!= 'surrendered') then(
                                                        replace value of node $p/totalmonney with $p/totalmonney + 3 * $p/currentBet,
                                                        replace value of node $casino/users/player[@id = $p/@id]/totalmonney with $casino/users/player[@id = $p/@id]/totalmonney + 3 * $p/currentBet,
                                                        replace value of node $casino/users/player[@id = $p/@id]/points with $casino/users/player[@id = $p/@id]/points + 2 *$p/currentBet,
                                                        replace value of node $p/status with 'winner'
                                                    )
                                            )
                                       ) else(
                                                        replace value of node $casino/users/player[@id = $p/@id]/points with $casino/users/player[@id = $p/@id]/points - 1 * $p/currentBet

                                       )

                                ) else (
                                            if($p/status != 'loser') then(
                                                if($p/status = 'blackjack') then(
                                                         replace value of node $p/totalmonney with $p/totalmonney +2.5 *$p/currentBet,
                                                         replace value of node $casino/users/player[@id = $p/@id]/totalmonney with $casino/users/player[@id = $p/@id]/totalmonney + 2.5 * $p/currentBet,
                                                         replace value of node $casino/users/player[@id = $p/@id]/points with $casino/users/player[@id = $p/@id]/points + 1.5 * $p/currentBet
                                                    ) else (
                                                        if($p/status != 'surrendered') then(
                                                                let $amountOfPlayerCards := blackjack-card:calculateCurrentCardValue($game,$p,0)
                                                                return(
                                                                        if($amountOfPlayerCards >= $amountOfCardsOfDealer) then(
                                                                            replace value of node $p/totalmonney with $p/totalmonney + 2 * $p/currentBet,
                                                                            replace value of node $casino/users/player[@id = $p/@id]/totalmonney with $casino/users/player[@id = $p/@id]/totalmonney + 2 * $p/currentBet,
                                                                            replace value of node $casino/users/player[@id = $p/@id]/points with $casino/users/player[@id = $p/@id]/points + 1 * $p/currentBet,
                                                                            replace value of node $p/status with 'winner'
                                                                        )   else (
                                                                            replace value of node $p/status with 'loser',
                                                                            replace value of node $casino/users/player[@id = $p/@id]/points with $casino/users/player[@id = $p/@id]/points - 1 * $p/currentBet
                                                                        )
                                                                )


                                                        )


                                                    )


                                            ) else(
                                                         replace value of node $casino/users/player[@id = $p/@id]/points with ( $casino/users/player[@id = $p/@id]/points - 1 * $p/currentBet)
                                            )

                                )

                    )
            )

};




(:~
 : this function generate Event messages to give to each player  using his ID
 : @gameID the id of the Game
 : @return update the events of the game

:)

 declare %updating function blackjack-game:updateEvents($gameID as xs:string){
            let $game := blackjack-game:getGame($gameID)

               let $finalEvents:=
                    for $p in $game/players/player
                        return(
                               <event id ="{$p/@id}">
                                 <message>
                                    {
                                        if(blackjack-card:calculateCurrentCardValue($game,$game/dealer,0) > 21) then(
                                            if($p/status = 'blackjack') then(
                                                    fn:concat("You won ",1.5 *$p/currentBet,"$")
                                            ),
                                            if($p/status = 'surrendered') then(
                                                fn:concat("You surrendered and lost ",0.5*$p/currentBet,"$")
                                            ) ,
                                            if($p/status ='winner') then(
                                                    fn:concat("You won ",2*$p/currentBet,"$")
                                            ),
                                            if($p/status ='loser') then(
                                                fn:concat("You lost ", $p/currentBet,"$")
                                            )


                                        ) else(

                                                 if($p/status = 'blackjack') then(
                                                        fn:concat("You won ",1.5 *$p/currentBet,"$")
                                                ),
                                                if($p/status = 'surrendered') then(
                                                    fn:concat("You surrendered and lost ",0.5*$p/currentBet,"$")
                                                ) ,
                                                if($p/status ='winner') then(
                                                        fn:concat("You won ",1*$p/currentBet,"$")
                                                ),
                                                if($p/status ='loser') then(
                                                    fn:concat("You lost ", $p/currentBet,"$")
                                                )
                                        )


                                    }


                                 </message>


                               </event>

                        )

              return(
                replace  node $game/events with <events>{$finalEvents}</events>
              )


 };












(:~
 : this function give a waitng Player a seat if there is one available
 : @gameID the ID of the game
 : @return update the game model and it's players
:)

declare %updating function blackjack-game:updateSeats($gameID as xs:string) {
        let $game := blackjack-game:getGame($gameID)
         let $emptySeats := for $seat in $game/freeSeats/seat
                            return $seat

         let $numberOfWaitingPlayers := fn:count($game/waitPlayers/player)

         return( if(fn:count($emptySeats) > 0) then(
                        if($numberOfWaitingPlayers =  0 ) then(

                        ) else(
                                let $emptySeat := $emptySeats[fn:position() = 1 ]
                                let $player := $game/waitPlayers/player[fn:position() = 1]
                                return(
                                        blackjack-player:insertPlayer($gameID, $player,$emptySeat),
                                        delete node $player,
                                        delete node $emptySeat
                                )

                        )
                ) else(

                )
         )
};
(:~
 : this function is called when a user clicks a new round  . it change the players variables like currentBet ,
 : dealer's and player's cards and update the free seats
 :@gameID the ID of the game
 :@return update the game model
:)


declare %updating function blackjack-game:newRound($gameID as xs:string){
        let $game := blackjack-game:getGame($gameID)
        let $nonEmptyPlayers:= for $p in $game/players/player
                                where $p/totalmonney >= $game/minBet
                                return $p
        let $emptyPlayersEvents := <events>
                                 { for $p in $game/players/player
                                   where $p/totalmonney = 0
                                   return(
                                        <event id ='0'><message>{fn:concat($p/name," is bankrupt!")}</message></event>
                                   )

            }
                                  </events>


        return(
                replace node $game/events with $emptyPlayersEvents,

                replace value of node $game/step with "bet",

                replace value of node $game/dealer/cards with <cards></cards>,

                 for $p in $game/players/player
                 where $p/totalmonney < $game/minBet
                 return(
                         delete node $p,
                         insert node $p into $game/loosers,
                         insert node <seat>{$p/tableSeat cast as xs:integer}</seat> into $game/freeSeats
                 ),

                 for $p in $nonEmptyPlayers count $i
                 return(
                        replace value of node $p/cards with <cards></cards>,
                        delete node $p/totalSumCards,
                        replace value of node $p/currentBet with 0,
                        replace value of node $p/status with "free"
                 ),
                 replace node $game/cards with <cards>{blackjack-card:shuffleCards()/*}</cards>

        )
};

(:~
 : this function is used to add  a new User to the casino . It checks first if the User already exists , if so
 : then a new User will be created with a new ID but with the same amount of monney and points
 : @playerName      the name of the player
 : @balance         the balance of the player
 : @id              the ID  of the User
 : @numberOfUsers   the number Of Users
:)

declare %updating function blackjack-game:addUser($playerName as xs:string,$balance as xs:string ,$id as xs:integer,$numberOfUsers as xs:integer){
        if($id = $numberOfUsers) then(
                if(blackjack-game:getCasino()/users/player[$playerName =name]) then(

                   insert node blackjack-player:newUser($playerName, blackjack-game:getCasino()/users/player[$playerName = name]/totalmonney,blackjack-game:getCasino()/users/player[$playerName = name]/points,  $numberOfUsers) into blackjack-game:getCasino()/users,

                   insert node <lobby><id>{$numberOfUsers}</id></lobby> into blackjack-game:getCasino()/lobbys,

                   delete node blackjack-game:getCasino()/users/player[$playerName = name]

                ) else(

                   insert node blackjack-player:newUser($playerName, $balance cast as xs:integer, 0, $id ) into blackjack-game:getCasino()/users,

                   insert node <lobby><id>{$id}</id></lobby> into blackjack-game:getCasino()/lobbys

                )
        )

};
