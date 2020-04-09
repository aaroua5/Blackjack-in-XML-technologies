xquery version "3.0";
module namespace blackjack-action = "blackjack/Action";
import module namespace helper = "blackjack/helper" at "helper.xqm";
import module namespace blackjack-game = "blackjack/Game" at "game.xqm";
import module namespace blackjack-card = "blackjack/Cards" at "cards.xqm";

declare %updating function blackjack-action:beforeBet($gameID as xs:string){
        let $game := blackjack-game:getGame($gameID)
        let $numberOfPlayers:= fn:count($game/players/player)
        return(
            if($game/playerTurn != 1 ) then(
                    replace value of node $game/playerTurn with $game/playerTurn - 1
            )

        )
};
declare %updating function blackjack-action:nextBet($gameID as xs:string){

    let $game := blackjack-game:getGame($gameID)
    let $numberOfPlayers := fn:count($game/players/player)
    let $currentBet :=  $game/players/player[fn:position()= $game/playerTurn]/currentBet
    let $currentPlayer := $game/players/player[fn:position() = $game/playerTurn]
    let $currentUser := blackjack-game:getCasino()/users/player[@id = $currentPlayer/@id]
    return(
            if($currentBet cast as xs:integer < $game/minBet ) then(
           replace node $game/events with <events><event id ="{$currentPlayer/@id}"><message> the min Bet is {$game/minBet} </message></event></events>
            )
            else (
                if($game/playerTurn = $numberOfPlayers) then(
                    update:output(web:redirect(fn:concat("/bj/startGame/",$gameID)))
                ),
                replace value of node $game/playerTurn with ($game/playerTurn +1) mod ($numberOfPlayers + 1),
                replace value of node $currentPlayer/totalmonney  with $currentPlayer/totalmonney - $currentPlayer/currentBet,
                replace value of node $currentUser/totalmonney with $currentUser/totalmonney - $currentPlayer/currentBet
            )
    )

   };

declare %updating function blackjack-action:clear($gameID as xs:string){
        let $game := blackjack-game:getGame($gameID)
        return(
            replace value of node $game/players/player[fn:position() = $game/playerTurn]/currentBet with 0
        )

};
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
                                     replace  node $game/events with <events><event id ="{$activePlayer/@id}"><message>{"you got blackjack"}</message></event></events>,
                                     delete node $game/cards/card[fn:position()=1],
                                     replace value of node $game/playerTurn with ($game/playerTurn + 1 ) mod $numberOfPlayers ,
                                                             if(($game/playerTurn +1) mod $numberOfPlayers = 0)  then(
                                                                 update:output(web:redirect(fn:concat("/bj/dealer/",$gameID)))
                                                             )

                                  )
                                  else(
                                             insert node $card into $game/players/player[fn:position()= $game/playerTurn]/cards,
                                             replace node $game/events with<events><event id ="{$activePlayer/@id}"><message> {" you lost, widthraw more than 21"}</message></event></events>,
                                             delete node $game/cards/card[fn:position()=1],
                                             replace value of node $game/players/player[fn:position()= $game/playerTurn]/status with "loser",
                                             replace value of node $game/playerTurn with ($game/playerTurn + 1 ) mod $numberOfPlayers,
                                             if(($game/playerTurn +1) mod $numberOfPlayers = 0)  then(
                                                    update:output(web:redirect(fn:concat("/bj/dealer/",$gameID)))
                                             )
                                    else()
                                   )
                            ),
                            replace value of node $game/players/player[fn:position()=$game/playerTurn]/totalSumCards with $currentCardSum

        )
};
declare %updating function blackjack-action:bet($gameID as xs:string, $betAmount as xs:integer){
        let $game := blackjack-game:getGame($gameID)
        let $activePlayer := $game/players/player[fn:position() = $game/playerTurn]
        let $numberOfplayers := fn:count($game/players/player) + 1
        return(

            if($activePlayer/currentBet + $betAmount > $activePlayer/totalmonney) then(
                replace node $game/events with <events><event id ="{$activePlayer/@id}"><message> you have only {$activePlayer/totalmonney} $ </message></event></events>
        )
        else( if($activePlayer/currentBet + $betAmount >$game/maxBet) then(
                replace node $game/events with
               <events><event id ="{$activePlayer/@id}"><message> the max Bet is {$game/maxBet} $ </message></event></events>               )

               else(
                replace value of node $activePlayer/currentBet with $activePlayer/currentBet + $betAmount,
                replace node $game/events with <events/>)
               )
        )
};

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
                                                replace  node $game/events with  <events><event id ="{$activePlayer/@id}"><message>{"you got blackjack"} </message></event></events>,
                                                replace value of node $activePlayer/status with 'blackjack',
                                                replace value of node $game/playerTurn with $nextActivePlayer ),




                        update:output(web:redirect(fn:concat("/bj/dealer/",$gameID)))                    )

                    else(
                          if(blackjack-card:calculateCurrentCardValue($game,$activePlayer,0) =21) then(
                            replace  node $game/events with  <events><event id ="{$activePlayer/@id}"><message>{"you got blackjack"} </message></event></events>,
                            replace value of node $activePlayer/status with 'blackjack',
                            replace value of node $game/playerTurn with $nextActivePlayer )

                           else(
                          replace value of node $game/playerTurn with $nextActivePlayer
                    ,     replace value of node $game/events with <events/>))
                    )

};


declare %updating function blackjack-action:double($gameID as xs:string){
                let $game :=  blackjack-game:getGame($gameID)
                let $activeplayer := $game/players/player[fn:position()= $game/playerTurn]
                let $activeUser := blackjack-game:getCasino()/users/player[@id = $activeplayer/@id]
                let $numberOfplayers := fn:count($game/players/player)
                let $card := $game/cards/card[fn:position() = 1]
                let $currentCardSum := blackjack-card:calculateCurrentCardValue($game,$activeplayer,$card/card_Value)
                return(
                        if($activeplayer/totalSumCards < 11) then(

                                if($activeplayer/totalmonney <  $activeplayer/currentBet) then(
                                      replace node $game/events with <events><event id="{$activeplayer/@id}"><message>" you cant Double down"</message></event></events>

                                ) else(
                                          delete node $card,
                                          insert node $card into $activeplayer/cards,
                                          replace value of node $game/playerTurn with ($game/playerTurn + 1 ) mod $numberOfplayers,
                                          replace value of node $activeplayer/currentBet with $activeplayer/currentBet * 2 ,
                                          replace value of node $activeplayer/totalmonney with $activeplayer/totalmonney - $activeplayer/currentBet,
                                          replace value of node $activeUser/totalmonney with $activeUser/totalmonney - $activeplayer/currentBet,
                                          replace value of node $activeplayer/totalSumCards with $currentCardSum,
                                        if($game/playerTurn = $numberOfplayers) then(
                                                update:output(web:redirect(fn:concat("/bj/dealer/",$gameID)))
                                        )
                                )

                        )
                        else (
                            replace node $game/events with <events><event id ="{$activeplayer/@id}"><message>" you cant Double down"</message></event></events>
                        )



                )

};

declare %updating function blackjack-action:surrender($gameID as xs:string){
        let $game := blackjack-game:getGame($gameID)
        let $activePlayer := $game/players/player[$game/playerTurn = fn:position()]
        let $activeUser := blackjack-game:getCasino()/users/player[@id = $activePlayer/@id]
        let $numberOfPlayers := fn:count($game/players/player)
        return(
                    if(fn:count($activePlayer/cards/card)> 2) then(
                        replace node $game/events with <events><event id="{$activePlayer/@id}"><message>" you cant surrender"</message></event></events>
                    )
                    else(
                        replace value of node $activePlayer/totalmonney with $activePlayer/totalmonney + 0.5*$activePlayer/currentBet,
                        replace value of node $activeUser/totalmonney with $activeUser/totalmonney +0.5 *$activePlayer/currentBet,
                        replace value of node $activePlayer/status with 'surrendered',
                        replace value of node $game/playerTurn with ($game/playerTurn + 1) mod($numberOfPlayers + 1),
                        for $card in $activePlayer/cards/card
                        return(
                                delete node $card , insert node $card into $game/cards
                        ),

                        if($game/playerTurn = $numberOfPlayers ) then(
                                update:output(web:redirect(fn:concat("/bj/dealer/",$gameID)))
                        )


                    )
        )
};

        declare %updating function blackjack-action:exitGame($gameID as  xs:string , $playerID as xs:integer){
                let $game := blackjack-game:getGame($gameID)
                let $player := $game/players/player[$playerID= @id]
                return(

                    if($game/step ='play') then(
                            if($game/players/player[fn:position()= fn:count($game/players/player)]/@id = $playerID) then(
                              if(fn:count($game/players/player) > 1) then(
                                update:output(web:redirect(fn:concat("/bj/dealer/",$gameID))))
                              else(
                                update:output(web:redirect(fn:concat("/bj/newRound/",$gameID)))
                              )
                            ),delete node $player,
                            insert node $player into $game/loosers,
                            insert node <seat> {$player/tableSeat cast as xs:integer} </seat> into $game/freeSeats
                    ) else(
                                if($game/step ='roundOver') then(

                                  if($game/players/player[fn:position()= fn:count($game/players/player)]/@id = $playerID) then(

                                        delete node $player,
                                        insert node $player into $game/loosers,
                                        insert node <seat> {$player/tableSeat cast as xs:integer} </seat> into $game/freeSeats

                                )
                    ) else(

                        if($game/players/player[fn:position() = fn:count($game/players/player)]/@id = $playerID ) then(

                            if(fn:count($game/players/player) > 1 ) then(
                            update:output(web:redirect(fn:concat("/bj/startGame/",$gameID)))
                        )),
                        delete node $player,
                        insert node $player into $game/loosers,
                        insert node <seat> {$player/tableSeat cast as xs:integer} </seat> into $game/freeSeats
                )
                )
                )


        };
