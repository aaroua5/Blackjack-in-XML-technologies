xquery version "3.0";


module namespace blackjack-main = "blackjack/Main";
import module namespace helper = "blackjack/helper" at "blackjack-helper.xqm";


declare variable $blackjack-main:casino := db:open("bj")/casino;


declare function blackjack-main:getGame($gameID) as element(blackjack){
    $blackjack-main:casino/blackjack[@id = $gameID]
};


declare  function blackjack-main:createGame($maxBet as xs:integer, $minBet as xs:integer, $playerNames as xs:string+, $balances as xs:string+){
   let $game := helper:createNewGame($maxBet,$minBet,$playerNames,$balances)

    return ($game)
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

declare %updating function blackjack-main:nextBet($gameID as xs:string){
        let $game := blackjack-main:getGame($gameID)
        let $numberOfPlayers := fn:count($game/players/player)
        return(
            if($game/playerTurn = $numberOfPlayers) then(
              update:output(web:redirect(fn:concat("/bj/startGame/",$gameID)))
            ),
            replace value of node $game/playerTurn with ($game/playerTurn + 1 ) mod ($numberOfPlayers + 1)
        )
};

declare %updating function blackjack-main:clear($gameID as xs:string){
        let $game := blackjack-main:getGame($gameID)
        return(
            replace value of node $game/players/player[@id = $game/playerTurn]/currentBet with 0
        )

};

declare  %updating function blackjack-main:hit($gameID as xs:string){
        let $game := blackjack-main:getGame($gameID)
        let $card := $game/cards/card[fn:position()=1]
        let $activePlayer := $game/players/player[$game/playerTurn = @id]
        let $numberOfPlayers := fn:count($game/players/player) + 1
        (:check if the player has less than 21 :)
        let $currentCardSum := helper:calculateCurrentCardValue($game, $activePlayer,$card)
            return (
                          for $p in $game/players/player
                                                                       where $p/status ='loser'
                                                                         return (for $card in $p/cards/card
                                                                                  return (delete node $card,
                                                                                        insert node $card into $game/cards

                                                                                         )),
                            if($currentCardSum <21) then(
                                    insert node $card into $game/players/player[@id = $game/playerTurn]/cards,
                                    delete node $game/cards/card[fn:position()=1]
                            )

                            else( if($currentCardSum = 21) then(
                                     insert node $card into $game/players/player[@id = $game/playerTurn]/cards,
                                     replace value of node $game/players/player[@id = $game/playerTurn]/status with "blackjack",
                                     replace value of node $game/event with fn:concat($activePlayer/name," got blackjack"),
                                     delete node $game/cards/card[fn:position()=1],
                                     replace value of node $game/playerTurn with ($game/playerTurn + 1 ) mod $numberOfPlayers ,
                                                             if(($game/playerTurn +1) mod $numberOfPlayers = 0)  then(
                                                                 update:output(web:redirect(fn:concat("/bj/dealer/",$gameID)))
                                                             )

                                  )
                                  else(
                                             insert node $card into $game/players/player[@id = $game/playerTurn]/cards,
                                             replace value of node $game/event with fn:concat($activePlayer/name," lost, widthraw more than 21"),
                                             delete node $game/cards/card[fn:position()=1],
                                             replace value of node $game/players/player[@id = $game/playerTurn]/status with "loser",
                                             replace value of node $game/playerTurn with ($game/playerTurn + 1 ) mod $numberOfPlayers,
                                             if(($game/playerTurn +1) mod $numberOfPlayers = 0)  then(
                                                    update:output(web:redirect(fn:concat("/bj/dealer/",$gameID)))
                                             )
                                    else()
                                   )
                            )

        )
};
declare %updating function blackjack-main:bet($gameID as xs:string, $betAmount as xs:integer){
        let $game := blackjack-main:getGame($gameID)
        let $activePlayer := $game/players/player[@id = $game/playerTurn]
        let $numberOfplayers := fn:count($game/players/player) + 1
        return( if($activePlayer/currentBet + $betAmount > $activePlayer/totalmonney) then(
                replace value of node $game/playerTurn with ($game/playerTurn  + 1)    mod $numberOfplayers
        )
        else( if($activePlayer/currentBet + $betAmount = $activePlayer/totalmonney) then(
                replace value of node $activePlayer/currentBet with $activePlayer/currentBet + $betAmount,
                replace value of node $game/playerTurn with ($game/playerTurn  + 1)    mod $numberOfplayers
               )

               else(
                replace value of node $activePlayer/currentBet with $activePlayer/currentBet + $betAmount)
               )
        )
};

declare %updating function blackjack-main:dealerTurn($gameID as xs:string){
            let $game := blackjack-main:getGame($gameID)
            let $amountOfCardsOfDealer := helper:calculateFinalCardValue($gameID, $game/dealer)
            return( replace value of node $game/step with "GameOver",
                    for $p in $game/players/player
                        return( if(helper:calculateFinalCardValue($gameID,$p) >21) then(
                        replace value of node $p/totalmonney with $p/totalmonney - $p/currentBet
                        )
                                else(
                                        if(helper:calculateFinalCardValue($gameID,$p) < $amountOfCardsOfDealer ) then(
                                                replace value of node $p/totalmonney with $p/totalmonney - $p/currentBet
                                         )

                                )

                        ),
                     blackjack-main:updateEvents($gameID)

            )
 };

 declare %updating function blackjack-main:updateEvents($gameID as xs:string){
            let $game := blackjack-main:getGame($gameID)

               let $events:=
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
                replace value of node $game/event with $events
              )


 };


declare %updating function blackjack-main:stand($gameID as xs:string){
            let $game := blackjack-main:getGame($gameID)
            let $numberOfPlayers := fn:count($game/players/player) + 1
            let $activePlayer := ($game/playerTurn + 1 ) mod $numberOfPlayers
            return(
                    for $p in $game/players/player
                                                 where $p/status ='loser'
                                                 return (for $card in $p/cards/card
                                                          return (delete node $card,
                                                                insert node $card into $game/cards

                                                                 )),
                    if($activePlayer = 0 ) then(
                         blackjack-main:dealerTurn($gameID)
                    )

                    else(
                          replace value of node $game/playerTurn with $activePlayer )
                    ,     replace value of node $game/event with "")
};




