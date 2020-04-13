xquery version "3.0";
module namespace blackjack-player = "blackjack/Player";
import module namespace helper = "blackjack/helper" at "helper.xqm";
import module namespace blackjack-game = "blackjack/Game" at "game.xqm";


declare %updating function blackjack-player:deletePlayer($gameID as xs:string){
    let $casino := blackjack-game:getCasino()
    let $game := blackjack-game:getGame($gameID)
    return(
         for $p in $game/loosers/player
            return(
                    delete node $p
            )

    )
};



declare %updating function blackjack-player:insertPlayer($gameID as xs:string, $player as element(player), $tableSeat as xs:integer){
            let $newPlayer := blackjack-player:newPlayer($player/name,$player/totalmonney,$player/@id,$tableSeat)
            let $beforePlayers := for $p in blackjack-game:getGame($gameID)/players/player
                                  where $p/tableSeat < $tableSeat
                                  return $p
             let $afterPlayers := for $p in blackjack-game:getGame($gameID)/players/player
                                   where $p /tableSeat > $tableSeat
                                   return $p
            return(

                replace node blackjack-game:getGame($gameID)/players with <players>
                        {$beforePlayers}
                        {$newPlayer}
                        {$afterPlayers}


                </players>

            )
};

declare function blackjack-player:newPlayer($name as xs:string, $balance, $id as xs:integer , $tableSeat as xs:integer) as element(player) {


    <player id = "{$id}">

        <name>{$name}</name>
        <status>free</status>
        <tableSeat>{$tableSeat}</tableSeat>
        <totalmonney>{$balance cast as xs:integer}</totalmonney>
        <currentBet>0</currentBet>
        <cards></cards>

     </player>

};
declare function blackjack-player:newUser($name as xs:string, $balance, $points , $id as xs:integer ) as element(player){
          <player id = "{$id}">

                  <name>{$name}</name>
                  <totalmonney>{if($balance < 10) then 100 else $balance cast as xs:integer}</totalmonney>
                  <points>{$points}</points>
          </player>
};


