xquery version "3.0";


module namespace blackjack-game = "blackjack/Game";
import module namespace helper = "blackjack/helper" at "helper.xqm";
import module namespace blackjack-player = "blackjack/Player" at "player.xqm";
import module namespace blackjack-card = "blackjack/Cards" at "cards.xqm";




declare variable $blackjack-game:casino := db:open("bj")/casino;


declare function blackjack-game:getGame($gameID) as element(blackjack){
    $blackjack-game:casino/blackjack[@id = $gameID]
};

declare function blackjack-game:getCasino() as element(casino){
        $blackjack-game:casino
};

declare  function blackjack-game:createGame($maxBet as xs:integer, $minBet as xs:integer, $playerNames as xs:string+, $balances as xs:string+){
   let $game := blackjack-game:createNewGame($maxBet,$minBet,$playerNames,$balances)

    return ($game)
};

declare %updating function blackjack-game:insertNewPlayer($gameID as xs:string, $playerName as xs:string, $balance as xs:string,$id as xs:integer , $tableSeat as xs:integer){
                let $casino := blackjack-game:getCasino()
                let $game := blackjack-game:getGame($gameID)
           return(
                if(fn:count($casino/users/player[$playerName = name] > 0)) then
                (
                    if($casino/users/player[$playerName = name]/totalmonney > $game/minBet) then(
                            let $player := blackjack-player:newPlayer($playerName,$casino/users/player[$playerName = name]/totalmonney,$id,$tableSeat)
                            let $user := blackjack-player:newUser($playerName,$casino/users/player[$playerName = name]/totalmonney,$casino/users/player[$playerName = name]/points,$id)
                            return(
                                    if($tableSeat < 0) then(
                                                insert node $player into $game/waitPlayers,
                                                insert node $user into $casino/users,
                                                delete node $casino/users/player[$playerName = name]
                                    ) else(
                                            insert node $player into $game/players,
                                            insert node $user into $casino/users,
                                            delete node $casino/users/player[$playerName = name]
                                    )
                            )
                    )
                  else (
                            let $player := blackjack-player:newPlayer($playerName,$balance cast as xs:integer,$id,$tableSeat)
                            let $user := blackjack-player:newUser($playerName,$balance cast as xs:integer,0,$id)
                            return(
                                  if($tableSeat < 0) then(
                                              insert node $player into $game/waitPlayers,
                                              insert node $user into $casino/users,
                                              delete node $casino/users/player[$playerName = name]
                                  ) else(
                                          insert node $player into $game/players,
                                          insert node $user into $casino/users,
                                          delete node $casino/users/player[$playerName = name]
                                  )
                          )
                  )



                )

                )
};

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


                                 replace node $game/events with  <events><event id='0'><message> {$playerName} joined the Game!</message></event></events>

                    )
                    )
            )
};

declare %updating function blackjack-game:insertGame($newGame as element(blackjack)){
      insert node $newGame  into $blackjack-game:casino,
      replace value of node blackjack-game:getCasino()/numberOfGames with blackjack-game:getCasino()/numberOfGames + 1
};

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
          welcome</message></event>
          <event> <message> to blackjack</message></event>
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
declare %updating function blackjack-game:beforeBet($gameID as xs:string){
        let $game := blackjack-game:getGame($gameID)
        let $numberOfPlayers:= fn:count($game/players/player)
        return(
            if($game/playerTurn != 1 ) then(
                    replace value of node $game/playerTurn with $game/playerTurn - 1
            )

        )
};



declare %updating function blackjack-game:checkScores($gameID as xs:string){
        let $game := blackjack-game:getGame($gameID)
        let $nonBankruptPlayers := for $p in $game/players/player
                                    where $p/totalmonney > $game/minBet
                                    return $p
         return(if(fn:count($nonBankruptPlayers)= 0 ) then(
                replace value of node $game/step with "gameOver"
         ))
};



declare %updating function blackjack-game:initliazeSum($gameID as xs:string){
            let $game := blackjack-game:getGame($gameID)
            for $p in $game/players/player
                return(
                        insert node <totalSumCards> {blackjack-card:calculateCurrentCardValue($game,$p,0)}</totalSumCards> into $p
                )

};



declare  function blackjack-game:dealerTurnHelper($gameID as xs:string,$sum ,$limit){
    let $game := blackjack-game:getGame($gameID)

    return(
                if($sum <= 16) then(
                        let $newAmount := blackjack-card:calculateDealerValues($game,$game/dealer,$limit+1)
                        return(blackjack-game:dealerTurnHelper($gameID,$newAmount,$limit + 1))
                )
                else(
                    $limit
                )
    )
};
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
                                                    fn:concat("you won ",1.5 *$p/currentBet,"$")
                                            ),
                                            if($p/status = 'surrendered') then(
                                                fn:concat(" you surrendered and lost",0.5*$p/currentBet,"$")
                                            ) ,
                                            if($p/status ='winner') then(
                                                    fn:concat(" you won ",2*$p/currentBet,"$")
                                            ),
                                            if($p/status ='loser') then(
                                                fn:concat(" you lost ", $p/currentBet,"$")
                                            )


                                        ) else(

                                                 if($p/status = 'blackjack') then(
                                                        fn:concat("you won ",1.5 *$p/currentBet,"$")
                                                ),
                                                if($p/status = 'surrendered') then(
                                                    fn:concat("you surrendered and lost",0.5*$p/currentBet,"$")
                                                ) ,
                                                if($p/status ='winner') then(
                                                        fn:concat("you won ",1*$p/currentBet,"$")
                                                ),
                                                if($p/status ='loser') then(
                                                    fn:concat("you lost ", $p/currentBet,"$")
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










declare %updating function blackjack-game:playerDisconnected($playerID as xs:integer){
    let $casino := blackjack-game:getCasino()
    for $game in $casino/blackjack
    return(
            delete node $game/players/player[@id = $playerID]
     )



};



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
                        return(blackjack-player:insertPlayer($gameID, $player,$emptySeat),delete node $player)

                )
                ) else(

                )
         )
};

declare %updating function blackjack-game:newRound($gameID as xs:string){
        let $game := blackjack-game:getGame($gameID)
        let $nonEmptyPlayers:= for $p in $game/players/player
                                where $p/totalmonney >= $game/minBet
                                return $p
        let $emptyPlayersEvents := <events>
                                 { for $p in $game/players/player
                                  where $p/totalmonney = 0
                                   return(
                                        <event id ='0'><message>{fn:concat($p/name," is bankrupt! ")}</message></event>
                                   )

            }
                                  </events>


        return(
                replace node $game/events with $emptyPlayersEvents,
                replace value of node $game/step with "bet",
                 replace value of node $game/dealer/cards with <cards></cards>,
                for $p in $game/players/player
                 where $p/totalmonney < $game/minBet
                 return(delete node $p,
                 insert node $p into $game/loosers,
                 insert node <seat>{$p/tableSeat cast as xs:integer}</seat> into $game/freeSeats),
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
