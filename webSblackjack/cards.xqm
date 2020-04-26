xquery version "3.0";
module namespace blackjack-cards = "blackjack/Cards";
import module namespace helper = "blackjack/helper" at "helper.xqm";


(:~
 : This function shuffle Cards and return them
 : @return the shuffeled cards
:)
declare function blackjack-cards:shuffleCards() as element(cards){
    let $deck := <cards>
                {blackjack-cards:getWholeDeck()/*}
                </cards>

    let $shuffledDeck :=
            for $i in $deck/card
            order by helper:random(count($deck/card))
            return $i


     return <cards>
                {$shuffledDeck}
             </cards>

};


(:~
 : This function calculate the amount of the dealer Cards plus the first $limit cards from our deck
 : @game            the Game
 : @player          in this case is the Dealer
 : @limit           The number of cards to be withdrawn from Deck
 :@return           The number of Cards
:)
declare function blackjack-cards:calculateDealerValues($game as element(blackjack),$player as element(*),$limit) {
            let $cardsToBeAdded := for $i in 1 to $limit
                                    return(
                                        $game/cards/card[fn:position()= $i]
                                    )
            let $amountOfAcesTobeAdded := fn:count(
                                                for $card in $cardsToBeAdded
                                                where $card/card_number ='A'
                                                return $card
            )


            let $otherCardsTobeAdded := fn:sum(
                                                for $card in $cardsToBeAdded
                                                where $card/card_number != 'A'
                                                return $card/card_Value
            )
            let $amountOfAces := fn:sum(for $card in $player/cards/card
                                        where $card/card_number = 'A'
                                        return 1
                                       )+ $amountOfAcesTobeAdded

            let $amountOfOtherCards :=  fn:sum(for $card in $player/cards/card
                                               where $card/card_number != 'A'
                                               return $card/card_Value
                                               )+ $otherCardsTobeAdded

           let $sumOfAces := for $i in 0 to $amountOfAces
                                                 return  $amountOfAces + $i*10 +$amountOfOtherCards
           let $sumOfAceslessEqual:= for $i in $sumOfAces
                                      where $i <=21
                                      return $i

           return (
                                if($amountOfAces = 0) then($amountOfOtherCards)
                                else(
                                            if(fn:count($sumOfAceslessEqual) = 0) then(fn:min($sumOfAces))
                                            else(fn:max($sumOfAceslessEqual))
                                )

                  )

};



(:~
 : This function calculate the total sum of cards of The player , this function is called for example in hit ,stand ....
 : @game   The game in which the player is
 : @player      The player
 : @cardValue       The value of card to be added to deck of player
 : @return          The new total sum of cards of The player
:)
declare function blackjack-cards:calculateCurrentCardValue($game as element(blackjack),$player as element(*),$cardValue as xs:integer) {

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
                                    if(fn:count($sumOfAceslessEqual) = 0) then(fn:min($sumOfAces))
                                    else(fn:max($sumOfAceslessEqual))
                                )

                               )


};

(:~
 : @return the whole deck of our casino
:)
declare function blackjack-cards:getWholeDeck() as element(cards){
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
