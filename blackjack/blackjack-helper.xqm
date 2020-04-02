xquery version "3.0";
module namespace helper = "blackjack/helper";
declare namespace uuid = "java:java.util.UUID";
declare namespace math = "java:java.lang.Math";


declare function helper:createNewGame($maxBet as xs:integer, $minBet as xs:integer, $playerNames as xs:string+ , $balances as xs:string+) as element(blackjack) {
let $id:=helper:generateID()
let $players := <players>
        {
             for $p in $playerNames count $i
             where $p != ""
             return(
             helper:newPlayer($p, $balances[$i] cast as xs:int,$i,$i)
             )
        }
        </players>
    return
    <blackjack id ="{$id}">
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
        {helper:shuffleCards()}
        <loosers/>

      </blackjack>
 };



declare function helper:shuffleCards() as element(cards){
    let $deck := <cards>
                {helper:getWholeDeck()/*}
                </cards>

    let $shuffledDeck :=
            for $i in $deck/card
            order by helper:random(count($deck/card))
            return $i


     return <cards>
                {$shuffledDeck}
             </cards>

};
(:this function calulate the sum of total cards of a  player:)
declare function helper:calculateCurrentCardValue($game as element(blackjack),$player as element(*),$cardValue as xs:integer) {

              let $amountOfAces := if($cardValue = 1) then( fn:sum(for $card in $player/cards/card
                                                             where $card/card_number = 'A'
                                                             return 1) + 1 )
                                    else(
                                        fn:sum(for $card in $player/cards/card
                                         where $card/card_number = 'A'
                                          return 1 ))


                        let $amountOfOtherCards := if($cardValue = 1 ) then( fn:sum(for $card in $player/cards/card
                                                             where $card/card_number != 'A'
                                                             return $card/card_Value )
                                                             )
                                                    else(
                                                        fn:sum(for $card in $player/cards/card
                                                         where $card/card_number != 'A'
                                                         return $card/card_Value
                                                    ) + $cardValue)

                        let $sumOfAces := for $i in 0 to $amountOfAces
                                          return  $amountOfAces + $i*10 +$amountOfOtherCards
                        let $sumOfAceslessEqual:= for $i in $sumOfAces
                                                   where $i <=21
                                                   return $i
                        return (if($amountOfAces = 0) then($amountOfOtherCards)
                                else(
                                    if(fn:count($sumOfAceslessEqual) = 0) then(22)
                                    else(fn:max($sumOfAceslessEqual))
                                )

                               )


};



declare function helper:random($number as xs:integer){
      xs:integer(ceiling(math:random() * $number))
};

(:~
 : This function uses Java function until generate-random-number
 : is generally available
 : @return     a random number in [1,$range]
 :)
declare function helper:randomNumber($range as xs:integer) as xs:integer {
    xs:integer(ceiling(Q{java:java.lang.Math}random() * $range))
};

declare function helper:generateID(){
       let $id := xs:string(uuid:randomUUID())
        return $id
};
declare function helper:getWholeDeck() as element(cards){
        <cards>
        <card>
            <card_number>A</card_number>
            <card_type>♦</card_type>
            <color>red</color>
            <card_Value>1</card_Value>
        </card>
        <card >
            <card_number>A</card_number>
            <card_type>♥</card_type>
            <color>red</color>
            <card_Value>1</card_Value>

        </card>
        <card >
            <card_number>A</card_number>
            <card_type>♠</card_type>
            <color>black</color>
             <card_Value>1</card_Value>

        </card>
        <card >
            <card_number>A</card_number>
            <card_type>♣</card_type>
            <color>black</color>
            <card_Value>1</card_Value>
        </card>
        <card >
            <card_number>2</card_number>
            <card_type>♦</card_type>
            <color>red</color>
            <card_Value>2</card_Value>
        </card>
        <card >
            <card_number>2</card_number>
            <card_type>♥</card_type>
            <color>red</color>
            <card_Value>2</card_Value>
        </card>
        <card >
            <card_number>2</card_number>
            <card_type>♠</card_type>
            <color>black</color>
            <card_Value>2</card_Value>
        </card>
        <card >
            <card_number>2</card_number>
            <card_type>♣</card_type>
            <color>black</color>
            <card_Value>2</card_Value>
        </card>
        <card >
            <card_number>3</card_number>
            <card_type>♦</card_type>
            <color>red</color>
            <card_Value>3</card_Value>
        </card>
        <card >
            <card_number>3</card_number>
            <card_type>♥</card_type>
            <color>red</color>
            <card_Value>3</card_Value>
        </card>
        <card >
            <card_number>3</card_number>
            <card_type>♠</card_type>
            <color>black</color>
            <card_Value>3</card_Value>
        </card>
        <card >
            <card_number>3</card_number>
            <card_type>♣</card_type>
            <color>black</color>
            <card_Value>3</card_Value>
        </card>
        <card >
            <card_number>4</card_number>
            <card_type>♦</card_type>
            <color>red</color>
            <card_Value>4</card_Value>
        </card>
        <card >
            <card_number>4</card_number>
            <card_type>♥</card_type>
            <color>red</color>
            <card_Value>4</card_Value>
        </card>
        <card >
            <card_number>4</card_number>
            <card_type>♠</card_type>
            <color>black</color>
            <card_Value>4</card_Value>
        </card>
        <card >
            <card_number>4</card_number>
            <card_type>♣</card_type>
            <color>black</color>
            <card_Value>4</card_Value>
        </card>
        <card >
            <card_number>5</card_number>
            <card_type>♦</card_type>
            <color>red</color>
            <card_Value>5</card_Value>
        </card>
        <card >
            <card_number>5</card_number>
            <card_type>♥</card_type>
            <color>red</color>
            <card_Value>5</card_Value>
        </card>
        <card >
            <card_number>5</card_number>
            <card_type>♠</card_type>
            <color>black</color>
            <card_Value>5</card_Value>
        </card>
        <card >
            <card_number>5</card_number>
            <card_type>♣</card_type>
            <color>black</color>
            <card_Value>5</card_Value>
        </card>
        <card >
            <card_number>6</card_number>
            <card_type>♦</card_type>
            <color>red</color>
            <card_Value>6</card_Value>
        </card>
        <card >
            <card_number>6</card_number>
            <card_type>♥</card_type>
            <color>red</color>
            <card_Value>6</card_Value>
        </card>
        <card >
            <card_number>6</card_number>
            <card_type>♠</card_type>
            <color>black</color>
            <card_Value>6</card_Value>
        </card>
        <card >
            <card_number>6</card_number>
            <card_type>♣</card_type>
            <color>black</color>
            <card_Value>6</card_Value>
        </card>
        <card >
            <card_number>7</card_number>
            <card_type>♦</card_type>
            <color>red</color>
            <card_Value>7</card_Value>
        </card>
        <card >
            <card_number>7</card_number>
            <card_type>♥</card_type>
            <color>red</color>
            <card_Value>7</card_Value>
        </card>
        <card >
            <card_number>7</card_number>
            <card_type>♠</card_type>
            <color>black</color>
            <card_Value>7</card_Value>
        </card>
        <card >
            <card_number>7</card_number>
            <card_type>♣</card_type>
            <color>black</color>
            <card_Value>7</card_Value>
        </card>
        <card >
            <card_number>8</card_number>
            <card_type>♦</card_type>
            <color>red</color>
            <card_Value>8</card_Value>
        </card>
        <card >
            <card_number>8</card_number>
            <card_type>♥</card_type>
            <color>red</color>
            <card_Value>8</card_Value>
        </card>
        <card >
            <card_number>8</card_number>
            <card_type>♠</card_type>
            <color>black</color>
            <card_Value>8</card_Value>
        </card>
        <card >
            <card_number>8</card_number>
            <card_type>♣</card_type>
            <color>black</color>
            <card_Value>8</card_Value>
        </card>
        <card >
            <card_number>9</card_number>
            <card_type>♦</card_type>
            <color>red</color>
            <card_Value>9</card_Value>
        </card>
        <card >
            <card_number>9</card_number>
            <card_type>♥</card_type>
            <color>red</color>
            <card_Value>9</card_Value>
        </card>
        <card >
            <card_number>9</card_number>
            <card_type>♠</card_type>
            <color>black</color>
            <card_Value>9</card_Value>
        </card>
        <card >
            <card_number>9</card_number>
            <card_type>♣</card_type>
            <color>black</color>
            <card_Value>9</card_Value>
        </card>
        <card >
            <card_number>10</card_number>
            <card_type>♦</card_type>
            <color>red</color>
            <card_Value>10</card_Value>
        </card>
        <card >
            <card_number>10</card_number>
            <card_type>♥</card_type>
            <color>red</color>
            <card_Value>10</card_Value>
        </card>
        <card >
            <card_number>10</card_number>
            <card_type>♠</card_type>
            <color>black</color>
            <card_Value>10</card_Value>
        </card>
        <card >
            <card_number>10</card_number>
            <card_type>♣</card_type>
            <color>black</color>
            <card_Value>10</card_Value>
        </card>
        <card >
            <card_number>J</card_number>
            <card_type>♦</card_type>
            <color>red</color>
            <card_Value>10</card_Value>
        </card>
        <card >
            <card_number>J</card_number>
            <card_type>♥</card_type>
            <color>red</color>
            <card_Value>10</card_Value>
        </card>
        <card >
            <card_number>J</card_number>
            <card_type>♠</card_type>
            <color>black</color>
            <card_Value>10</card_Value>
        </card>
        <card >
            <card_number>J</card_number>
            <card_type>♣</card_type>
            <color>black</color>
            <card_Value>10</card_Value>
        </card>
        <card >
            <card_number>Q</card_number>
            <card_type>♦</card_type>
            <color>red</color>
            <card_Value>10</card_Value>
        </card>
        <card >
            <card_number>Q</card_number>
            <card_type>♥</card_type>
            <color>red</color>
            <card_Value>10</card_Value>
        </card>
        <card >
            <card_number>Q</card_number>
            <card_type>♠</card_type>
            <color>black</color>
            <card_Value>10</card_Value>
        </card>
        <card >
            <card_number>Q</card_number>
            <card_type>♣</card_type>
            <color>black</color>
            <card_Value>10</card_Value>
        </card>
        <card >
            <card_number>K</card_number>
            <card_type>♦</card_type>
            <color>red</color>
            <card_Value>10</card_Value>
        </card>
        <card >
            <card_number>K</card_number>
            <card_type>♥</card_type>
            <color>red</color>
            <card_Value>10</card_Value>
        </card>
        <card >
            <card_number>K</card_number>
            <card_type>♠</card_type>
            <color>black</color>
            <card_Value>10</card_Value>
        </card>
        <card >
            <card_number>K</card_number>
            <card_type>♣</card_type>
            <color>black</color>
            <card_Value>10</card_Value>
        </card>
    </cards>
};


declare function helper:newPlayer($name as xs:string, $balance as xs:integer, $id as xs:integer , $tableSeat as xs:integer) as element(player) {

    <player id = "{$id}">

        <name>{$name}</name>
        <status>free</status>
        <tableSeat>{$tableSeat}</tableSeat>
        <totalmonney>{$balance}</totalmonney>
        <currentBet>0</currentBet>
        <cards></cards>

     </player>
};

