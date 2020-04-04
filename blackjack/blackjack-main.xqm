xquery version "3.0";


module namespace blackjack-main = "blackjack/Main";
import module namespace helper = "blackjack/helper" at "blackjack-helper.xqm";


declare variable $blackjack-main:casino := db:open("bj")/casino;


declare function blackjack-main:getGame($gameID) as element(blackjack){
    $blackjack-main:casino/blackjack[@id = $gameID]
};

declare function blackjack-main:getCasino() as element(casino){
        $blackjack-main:casino
};

declare  function blackjack-main:createGame($maxBet as xs:integer, $minBet as xs:integer, $playerNames as xs:string+, $balances as xs:string+){
   let $game := helper:createNewGame($maxBet,$minBet,$playerNames,$balances)

    return ($game)
};

declare %updating function blackjack-main:join($gameID as xs:string , $playerName as xs:string, $balance as xs:string, $id as xs:integer){

            let $game :=blackjack-main:getGame($gameID)
            (:this tableSeat will be changed to count the case  if one joins and one player is already out:)
            let $tableSeat := fn:count($game/players/player) +1
            let $player := helper:newPlayer($playerName,$balance cast as xs:integer,$id,$tableSeat)
            return ( insert node $player into blackjack-main:getCasino()/users,
                    insert node $player into $game/players,
                    replace node $game/events with  <events><event><message> {$playerName} joined the Game!</message></event></events>
            )
};

declare %updating function blackjack-main:insertGame($newGame as element(blackjack)){
      insert node $newGame  into $blackjack-main:casino
};

declare %updating function blackjack-main:startGame($gameID as xs:string){
    let $game :=blackjack-main:getGame($gameID)
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
declare %updating function blackjack-main:beforeBet($gameID as xs:string){
        let $game := blackjack-main:getGame($gameID)
        let $numberOfPlayers:= fn:count($game/players/player)
        return(
            if($game/playerTurn != 1 ) then(
                    replace value of node $game/playerTurn with $game/playerTurn - 1
            )

        )
};

declare %updating function blackjack-main:nextBet($gameID as xs:string){

    let $game := blackjack-main:getGame($gameID)
    let $numberOfPlayers := fn:count($game/players/player)
    let $currentBet :=  $game/players/player[fn:position()= $game/playerTurn]/currentBet
    return(
            if($currentBet cast as xs:integer < $game/minBet ) then(
           replace node $game/events with <events><event><message> the min Bet is {$game/minBet} </message></event></events>
            )
            else (
                if($game/playerTurn = $numberOfPlayers) then(
                    update:output(web:redirect(fn:concat("/bj/startGame/",$gameID)))
                ),
                replace value of node $game/playerTurn with ($game/playerTurn +1) mod ($numberOfPlayers + 1)
            )
    )

   };

declare %updating function blackjack-main:clear($gameID as xs:string){
        let $game := blackjack-main:getGame($gameID)
        return(
            replace value of node $game/players/player[fn:position() = $game/playerTurn]/currentBet with 0
        )

};

declare %updating function blackjack-main:checkScores($gameID as xs:string){
        let $game := blackjack-main:getGame($gameID)
        let $nonBankruptPlayers := for $p in $game/players/player
                                    where $p/totalmonney > $game/minBet
                                    return $p
         return(if(fn:count($nonBankruptPlayers)= 0 ) then(
                replace value of node $game/step with "gameOver"
         ))
};
declare  %updating function blackjack-main:hit($gameID as xs:string){
        let $game := blackjack-main:getGame($gameID)
        let $card := $game/cards/card[fn:position()=1]
        let $activePlayer := $game/players/player[$game/playerTurn = fn:position()]
        let $numberOfPlayers := fn:count($game/players/player) + 1
        (:check if the player has less than 21 :)
        let $currentCardSum := helper:calculateCurrentCardValue($game, $activePlayer,$card/card_Value)
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
                                     replace  node $game/events with <events><event><message>{fn:concat($activePlayer/name," got blackjack")}</message></event></events>,
                                     delete node $game/cards/card[fn:position()=1],
                                     replace value of node $game/playerTurn with ($game/playerTurn + 1 ) mod $numberOfPlayers ,
                                                             if(($game/playerTurn +1) mod $numberOfPlayers = 0)  then(
                                                                 update:output(web:redirect(fn:concat("/bj/dealer/",$gameID)))
                                                             )

                                  )
                                  else(
                                             insert node $card into $game/players/player[fn:position()= $game/playerTurn]/cards,
                                             replace node $game/events with<events><event><message> {fn:concat($activePlayer/name," lost, widthraw more than 21")}</message></event></events>,
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
declare %updating function blackjack-main:bet($gameID as xs:string, $betAmount as xs:integer){
        let $game := blackjack-main:getGame($gameID)
        let $activePlayer := $game/players/player[fn:position() = $game/playerTurn]
        let $numberOfplayers := fn:count($game/players/player) + 1
        return(

            if($activePlayer/currentBet + $betAmount > $activePlayer/totalmonney) then(
                replace node $game/events with <events><event><message> you have only {$activePlayer/totalmonney} $ </message></event></events>
        )
        else( if($activePlayer/currentBet + $betAmount >$game/maxBet) then(
                replace node $game/events with
               <events><event><message> the max Bet is {$game/maxBet} $ </message></event></events>               )

               else(
                replace value of node $activePlayer/currentBet with $activePlayer/currentBet + $betAmount,
                replace node $game/events with <events/>)
               )
        )
};


declare %updating function blackjack-main:initliazeSum($gameID as xs:string){
            let $game := blackjack-main:getGame($gameID)
            for $p in $game/players/player
                return(
                        insert node <totalSumCards> {helper:calculateCurrentCardValue($game,$p,0)}</totalSumCards> into $p
                )

};


declare %updating function blackjack-main:deletePlayer($gameID as xs:string){
    let $casino := blackjack-main:getCasino()
    let $game := blackjack-main:getGame($gameID)
    return(
         for $p in $game/loosers/player
            return(
                    delete node $p
            )

    )
};

declare function blackjack-main:dealerTurnHelper($gameID as xs:string,$sum ,$limit ){
    let $game := blackjack-main:getGame($gameID)

    return(
                if($sum <= 16) then(
                        let $newAmount := helper:calculateDealerValues($game,$game/dealer,$limit+1)
                        return(blackjack-main:dealerTurnHelper($gameID,$newAmount,$limit + 1))
                )
                else(
                    $limit
                )
    )
};
declare %updating function blackjack-main:dealerTurn($gameID as xs:string){
               let $game := blackjack-main:getGame($gameID)
               let $amountOFCardsOfDealer := helper:calculateCurrentCardValue($game, $game/dealer,0)

               let $amountOFCardsToDraw := blackjack-main:dealerTurnHelper($gameID,$amountOFCardsOfDealer,0) cast as xs:integer
               return(
                      for $i in 1 to $amountOFCardsToDraw
                      return(
                                delete node $game/cards/card[fn:position() = $i],
                                insert node  $game/cards/card[fn:position()= $i ] as first into $game/dealer/cards
                      )

                    )
};

declare %updating function blackjack-main:checkWinnings($gameID as xs:string){
            let $game := blackjack-main:getGame($gameID)
            let $amountOfCardsOfDealer := helper:calculateCurrentCardValue($game, $game/dealer,0)
            return( replace value of node $game/playerTurn with 1,
                    replace value of node $game/step with "roundOver",
                    for $p in $game/players/player
                        return( if(helper:calculateCurrentCardValue($game,$p,0) >21) then(
                        replace value of node $p/totalmonney with $p/totalmonney - $p/currentBet
                        )
                                else(
                                        if(helper:calculateCurrentCardValue($game,$p,0) < $amountOfCardsOfDealer ) then(
                                                replace value of node $p/totalmonney with $p/totalmonney - $p/currentBet,
                                                replace value of node $p/status with "loser"
                                         ) else (
                                                if(helper:calculateCurrentCardValue($game,$p,0) > $amountOfCardsOfDealer) then(
                                                    if(helper:calculateCurrentCardValue($game,$p,0) = 21) then(
                                                        replace value of node $p/status with "blackjack",
                                                        replace value of node $p/totalmonney with $p/totalmonney + $p/currentBet * 1.5
                                                    )
                                                    else(
                                                        replace value of node $p/totalmonney with $p/totalmonney + $p/currentBet,
                                                        replace value of node $p/status with "winner"
                                                    )
                                                )
                                         )


                                )

                        )

            )
 };

 declare %updating function blackjack-main:updateEvents($gameID as xs:string){
            let $game := blackjack-main:getGame($gameID)

               let $finalEvents:=
                    for $p in $game/players/player
                        return(
                                if ($p/status = 'loser') then(
                                     fn:concat($p/name, " lost, ",$p/currentBet," $
                                     ")
                                )
                                else(
                                    if($p/status='blackjack') then(
                                        fn:concat($p/name," won ", ($p/currentBet * (1.5)),"$")
                                    )
                                    else(
                                        fn:concat(
                                            $p/name," won ", $p/currentBet,"$"
                                        )
                                    )

                                )

                        )

              return(
                replace  node $game/events with <events><event><message>{$finalEvents}</message></event></events>
              )


 };


declare %updating function blackjack-main:stand($gameID as xs:string){
            let $game := blackjack-main:getGame($gameID)
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
                        update:output(web:redirect(fn:concat("/bj/dealer/",$gameID)))                    )

                    else(
                          if(helper:calculateCurrentCardValue($game,$activePlayer,0) =21) then(
                            replace  node $game/events with  <events><event><message>{(fn:concat($activePlayer/name," got blackjack"))} </message></event></events>,
                            replace value of node $activePlayer/status with "blackjack",
                            replace value of node $game/playerTurn with $nextActivePlayer )

                           else(
                          replace value of node $game/playerTurn with $nextActivePlayer
                    ,     replace value of node $game/events with <events/>))
                    )

};




declare %updating function blackjack-main:double($gameID as xs:string){
                let $game :=  blackjack-main:getGame($gameID)
                let $activeplayer := $game/players/player[fn:position()= $game/playerTurn]
                let $numberOfplayers := fn:count($game/players/player)
                let $card := $game/cards/card[fn:position() = 1]
                return(
                        if($activeplayer/totalSumCards < 11) then(

                                if($activeplayer/totalmonney < 2 * $activeplayer/currentBet) then(
                                      replace node $game/events with <events><event><message>" you cant Double down"</message></event></events>

                                ) else(
                                        delete node $card,
                                        insert node $card into $activeplayer/cards,
                                        replace value of node $game/playerTurn with ($game/playerTurn + 1 ) mod $numberOfplayers,
                                        replace value of node $activeplayer/currentBet with $activeplayer/currentBet * 2 ,
                                        if($game/playerTurn = $numberOfplayers) then(
                                                update:output(web:redirect(fn:concat("/bj/dealer/",$gameID)))
                                        )
                                )

                        )
                        else (
                            replace node $game/events with <events><event><message>" you cant Double down"</message></event></events>
                        )



                )

};

declare %updating function blackjack-main:surrender($gameID as xs:string){
        let $game := blackjack-main:getGame($gameID)
        let $activePlayer := $game/players/player[$game/playerTurn = fn:position()]
        let $numberOfPlayers := fn:count($game/players/player)
        return(
                    if(fn:count($activePlayer/cards/card)> 2) then(
                        replace node $game/events with <events><event><message>" you cant surrender"</message></event></events>
                    )
                    else(
                        replace value of node $activePlayer/totalmonney with $activePlayer/totalmonney - 0.5*$activePlayer/currentBet,
                        replace value of node $activePlayer/currentBet with 0,
                        for $card in $activePlayer/cards/card
                        return(
                                delete node $card , insert node $card into $game/cards
                        ),

                        if(game/playerTurn = $numberOfPlayers ) then(
                                update:output(web:redirect(fn:concat("/bj/dealer/",$gameID)))
                        )


                    )
        )
};



declare %updating function blackjack-main:newRound($gameID as xs:string){
        let $game := blackjack-main:getGame($gameID)
        let $nonEmptyPlayers:= for $p in $game/players/player
                                where $p/totalmonney >= $game/minBet
                                return $p
        let $emptyPlayersEvents := <events>
                                 { for $p in $game/players/player
                                  where $p/totalmonney = 0
                                   return(
                                        <event><message>{fn:concat($p/name," is bankrupt! ")}</message></event>
                                   )

            }
                                  </events>
        return(
                replace node $game/events with $emptyPlayersEvents,
                replace value of node $game/step with "bet",
                 replace value of node $game/dealer/cards with <cards></cards>,
                for $p in $game/players/player
                 where $p/totalmonney < $game/minBet
                 return(delete node $p,insert node $p into $game/loosers),
                 for $p in $nonEmptyPlayers count $i
                 return(
                        replace value of node $p/cards with <cards></cards>,
                        delete node $p/totalSumCards,
                        replace value of node $p/currentBet with 0,
                        replace value of node $p/status with "free"
                 ),
                 replace node $game/cards with <cards>{helper:shuffleCards()/*}</cards>

        )
};


