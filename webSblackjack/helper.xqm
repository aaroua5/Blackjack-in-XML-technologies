xquery version "3.0";
module namespace helper = "blackjack/helper";
declare namespace uuid = "java:java.util.UUID";
declare namespace math = "java:java.lang.Math";
import module namespace blackjack-player = "blackjack/Player" at "player.xqm";
import module namespace blackjack-card = "blackjack/Cards" at "cards.xqm";






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




