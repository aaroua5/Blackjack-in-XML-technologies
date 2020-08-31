xquery version "3.0";
module namespace blackjack-action = "blackjack/Action";
import module namespace helper = "blackjack/helper" at "helper.xqm";
import module namespace blackjack-game = "blackjack/Game" at "game.xqm";
import module namespace blackjack-card = "blackjack/Cards" at "cards.xqm";

(:~ this function is called when the player hits Deal and the game should move to next player based on playerTurn
 :  after clicking Deal the Bet will be deducted from his total monney
 : @gameID      The ID of the game
 : @return      Update the game model
:)

declare %updating function blackjack-action:nextBet($gameID as xs:string) {

    let $game := blackjack-game:getGame($gameID)
    let $numberOfPlayers := fn:count($game/players/player)
    let $currentBet :=  $game/players/player[fn:position()= $game/playerTurn]/currentBet
    let $currentPlayer := $game/players/player[fn:position() = $game/playerTurn]
    let $currentUser := blackjack-game:getCasino()/users/user[@id = $currentPlayer/@id]
    return(
            if($currentBet cast as xs:integer < $game/minBet ) then(
                    replace node $game/events with <events><event id ="{$currentPlayer/@id}"><message>The min Bet is {$game/minBet}$</message></event></events>
            )
            else (
                if($game/playerTurn = $numberOfPlayers) then(
                    update:output(web:redirect(fn:concat("/webSbj/startGame/",$gameID)))
                ),
                replace value of node $game/playerTurn with ($game/playerTurn +1) mod ($numberOfPlayers + 1),
                replace value of node $currentPlayer/totalmonney  with $currentPlayer/totalmonney - $currentPlayer/currentBet,
                replace value of node $currentUser/totalmonney with $currentUser/totalmonney - $currentPlayer/currentBet
            )
    )

   };

(:~
 : This function is called when the user clicks clear and want to remove his bet and make a new bet
 : @gameID          The ID of the Game
 : @return          Update the game model
 :)
declare %updating function blackjack-action:clear($gameID as xs:string){
        let $game := blackjack-game:getGame($gameID)
        return(
            replace value of node $game/players/player[fn:position() = $game/playerTurn]/currentBet with 0
        )

};
(:~
 : This function is called when the player wants to hit
 : @gameID              The ID of The Game
 : @return              Update the game model by adding a card to the current player
:)

declare  %updating function blackjack-action:hit($gameID as xs:string){
        let $game := blackjack-game:getGame($gameID)
        let $card := $game/cards/card[fn:position()=1]
        let $activePlayer := $game/players/player[$game/playerTurn = fn:position()]
        let $numberOfPlayers := fn:count($game/players/player) + 1
        (:check if the player has less than 21 :)
        let $currentCardSum := blackjack-card:calculateCurrentCardValue($game, $activePlayer,$card/card_Value)
            return (
                          for $p in $game/players/player
                                                                       where $p/status ='loser'
                                                                         return (for $card in $p/cards/card
                                                                                  return (delete node $card,
                                                                                        insert node $card into $game/cards

                                                                                         )),
                            if($currentCardSum <21) then(
                                    insert node $card into $game/players/player[fn:position() = $game/playerTurn]/cards,
                                    delete node $game/cards/card[fn:position()=1]
                            )

                            else( if($currentCardSum = 21) then(
                                     insert node $card into $game/players/player[fn:position() = $game/playerTurn]/cards,
                                     replace value of node $game/players/player[fn:position() = $game/playerTurn]/status with "blackjack",
                                     replace  node $game/events with <events><event id ="{$activePlayer/@id}"><message>{"You got blackjack!"}</message></event></events>,
                                     delete node $game/cards/card[fn:position()=1],
                                     replace value of node $game/playerTurn with ($game/playerTurn + 1 ) mod $numberOfPlayers ,
                                                             if(($game/playerTurn +1) mod $numberOfPlayers = 0)  then(
                                                                 update:output(web:redirect(fn:concat("/webSbj/dealer/",$gameID)))
                                                             )

                                  )
                                  else(
                                             insert node $card into $game/players/player[fn:position()= $game/playerTurn]/cards,
                                             replace node $game/events with<events><event id ="{$activePlayer/@id}"><message> {"You lost, widthraw more than 21"}</message></event></events>,
                                             delete node $game/cards/card[fn:position()=1],
                                             replace value of node $game/players/player[fn:position()= $game/playerTurn]/status with "loser",
                                             replace value of node $game/playerTurn with ($game/playerTurn + 1 ) mod $numberOfPlayers,
                                             if(($game/playerTurn +1) mod $numberOfPlayers = 0)  then(
                                                    update:output(web:redirect(fn:concat("/webSbj/dealer/",$gameID)))
                                             )
                                    else()
                                   )
                            ),
                            replace value of node $game/players/player[fn:position()=$game/playerTurn]/totalSumCards with $currentCardSum

        )
};

(:~ This function is called when The player wants to add a bet amount to his currentBet
 :  @gameID      The ID of The game
 :  @betAmount   The amount to be added to the current Bet
 :  @return       Update The game model
:)

declare %updating function blackjack-action:bet($gameID as xs:string, $betAmount as xs:integer){
        let $game := blackjack-game:getGame($gameID)
        let $activePlayer := $game/players/player[fn:position() = $game/playerTurn]
        let $numberOfplayers := fn:count($game/players/player) + 1
        return(

            if($activePlayer/currentBet + $betAmount > $activePlayer/totalmonney) then(
                replace node $game/events with <events><event id ="{$activePlayer/@id}"><message>You only have {$activePlayer/totalmonney}$</message></event></events>
        )
        else( if($activePlayer/currentBet + $betAmount >$game/maxBet) then(
                replace node $game/events with
               <events><event id ="{$activePlayer/@id}"><message>The max Bet is {$game/maxBet}$</message></event></events>               )

               else(
                replace value of node $activePlayer/currentBet with $activePlayer/currentBet + $betAmount,
                replace node $game/events with <events/>)
               )
        )
};
(:~
     : This function is called when the player wants to stand
 :
 : @return              Update the game model
:)
declare %updating function blackjack-action:stand($gameID as xs:string){
            let $game := blackjack-game:getGame($gameID)
            let $numberOfPlayers := fn:count($game/players/player) + 1
            let $activePlayer := $game/players/player[fn:position() = $game/playerTurn]
            let $nextActivePlayer := ($game/playerTurn + 1 ) mod $numberOfPlayers
            return(
                    for $p in $game/players/player
                                                 where $p/status ='loser'
                                                 return (for $card in $p/cards/card
                                                          return (delete node $card,
                                                                insert node $card into $game/cards

                                                                 )),
                    if($nextActivePlayer = 0 ) then(
                    if(blackjack-card:calculateCurrentCardValue($game,$activePlayer,0) =21) then(
                                                replace  node $game/events with  <events><event id ="{$activePlayer/@id}"><message>{"You got blackjack!"} </message></event></events>,
                                                replace value of node $activePlayer/status with 'blackjack',
                                                replace value of node $game/playerTurn with $nextActivePlayer ),




                        update:output(web:redirect(fn:concat("/webSbj/dealer/",$gameID)))                    )

                    else(
                          if(blackjack-card:calculateCurrentCardValue($game,$activePlayer,0) =21) then(
                            replace  node $game/events with  <events><event id ="{$activePlayer/@id}"><message>{"You got blackjack!"} </message></event></events>,
                            replace value of node $activePlayer/status with 'blackjack',
                            replace value of node $game/playerTurn with $nextActivePlayer )

                           else(
                          replace value of node $game/playerTurn with $nextActivePlayer
                    ,     replace value of node $game/events with <events/>))
                    )

};

(:~
 : This function is called when the player wants to double , it should check if he has less or more than 11 sum of cards
 : @gameID                  The ID of the game
 : @return                  Update The game model
:)

declare %updating function blackjack-action:double($gameID as xs:string){
                let $game :=  blackjack-game:getGame($gameID)
                let $activeplayer := $game/players/player[fn:position()= $game/playerTurn]
                let $activeUser := blackjack-game:getCasino()/users/user[@id = $activeplayer/@id]
                let $numberOfplayers := fn:count($game/players/player)
                let $card := $game/cards/card[fn:position() = 1]
                let $currentCardSum := blackjack-card:calculateCurrentCardValue($game,$activeplayer,$card/card_Value)
                return(
                        if($activeplayer/totalSumCards < 11) then(

                                if($activeplayer/totalmonney cast as xs:integer <  $activeplayer/currentBet) then(
                                      replace node $game/events with <events><event id="{$activeplayer/@id}"><message>You can't double down!</message></event></events>

                                ) else(
                                          delete node $card,
                                          insert node $card into $activeplayer/cards,
                                          replace value of node $game/playerTurn with ($game/playerTurn + 1 ) mod ($numberOfplayers + 1),
                                          replace value of node $activeplayer/currentBet with $activeplayer/currentBet * 2 ,
                                          replace value of node $activeplayer/totalmonney with $activeplayer/totalmonney - $activeplayer/currentBet,
                                          replace value of node $activeUser/totalmonney with $activeUser/totalmonney - $activeplayer/currentBet,
                                          replace value of node $activeplayer/totalSumCards with $currentCardSum,
                                        if($game/playerTurn = $numberOfplayers) then(
                                                update:output(web:redirect(fn:concat("/webSbj/dealer/",$gameID)))
                                        )
                                )

                        )
                        else (
                            replace node $game/events with <events><event id ="{$activeplayer/@id}"><message>"You can't double down!"</message></event></events>
                        )



                )

};

(:~
 : This function is called when The player which to surrender , only if he has 2  cards
     :  @gameID         The ID of the game
 :  @return         Update the game model
:)


declare %updating function blackjack-action:surrender($gameID as xs:string){
        let $game := blackjack-game:getGame($gameID)
        let $activePlayer := $game/players/player[$game/playerTurn = fn:position()]
        let $activeUser := blackjack-game:getCasino()/users/user[@id = $activePlayer/@id]
        let $numberOfPlayers := fn:count($game/players/player)
        return(
                    if(fn:count($activePlayer/cards/card)> 2) then(
                        replace node $game/events with <events><event id="{$activePlayer/@id}"><message>You can't surrender!</message></event></events>
                    )
                    else(
                        replace value of node $activePlayer/totalmonney with $activePlayer/totalmonney + 0.5*$activePlayer/currentBet,
                        replace value of node $activeUser/totalmonney with $activeUser/totalmonney +0.5 *$activePlayer/currentBet,
                        replace value of node $activeUser/points with $activeUser/points - 0.5 *$activePlayer/currentBet,

                        replace value of node $activePlayer/status with 'surrendered',
                        replace value of node $game/playerTurn with ($game/playerTurn + 1) mod($numberOfPlayers + 1),
                        for $card in $activePlayer/cards/card
                        return(
                                delete node $card , insert node $card into $game/cards
                        ),

                        if($game/playerTurn = $numberOfPlayers ) then(
                                update:output(web:redirect(fn:concat("/webSbj/dealer/",$gameID)))
                        )


                    )
        )
};

        (:~
         : This function is called when The player wish to exit the game , it should which state the game is in
         : @gameID              The ID of The game
         : @playerID            The ID of The player to exit

        :)

        declare %updating function blackjack-action:exitGame($gameID as  xs:string , $playerID as xs:integer){
                let $game := blackjack-game:getGame($gameID)
                let $player := $game/players/player[$playerID= @id]
                let $numberOfplayers := fn:count($game/players/player)
                let $user := blackjack-game:getCasino()/users/user[@id = $playerID]
                return(
                        if($player) then(
                                if($game/step ='bet') then(
                                        if($numberOfplayers > 1) then(
                                                if($game/players/player[fn:position() = $game/playerTurn]/@id = $playerID) then(
                                                            if($game/playerTurn = $numberOfplayers) then(
                                                                    update:output(web:redirect(fn:concat("/webSbj/startGame/",$gameID)))
                                                            )
                                                ),
                                                if($player[fn:position() < $game/playerTurn]) then(
                                                    replace value of node $game/playerTurn with $game/playerTurn - 1,
                                                    replace value of node $user/points with $user/points -$player/currentBet

                                                  )

                                        ),
                                        delete node $player,
                                        insert node $player into $game/quitters,
                                        insert node <seat>{$player/tableSeat cast as xs:integer}</seat> into $game/freeSeats

                                ),
                                if($game/step = 'play') then(
                                        if($numberOfplayers > 1) then(
                                                     if($game/players/player[fn:position() = $game/playerTurn]/@id = $playerID) then(
                                                            if($game/playerTurn = $numberOfplayers) then(
                                                                    update:output(web:redirect(fn:concat("/webSbj/dealer/",$gameID)))
                                                            )
                                                     ),
                                                       if($player[fn:position() < $game/playerTurn]) then(
                                                             replace value of node $game/playerTurn with $game/playerTurn - 1

                                                        )


                                        )  else(
                                                     update:output(web:redirect(fn:concat("/webSbj/newRound/",$gameID)))
                                           ),
                                            delete node $player,
                                            insert node $player into $game/quitters,
                                            insert node <seat>{$player/tableSeat cast as xs:integer}</seat> into $game/freeSeats,
                                            replace value of node $user/points with $user/points -$player/currentBet

                                )




                        )
                       else(
                                delete node $game/waitPlayers/player[@id = $playerID],
                                insert node $game/waitPlayers/player[@id = $playerID] into $game/quitters
                       )
                )

        };
