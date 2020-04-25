xquery version "3.0";
module namespace blackjack-player = "blackjack/Player";
import module namespace helper = "blackjack/helper" at "helper.xqm";
import module namespace blackjack-game = "blackjack/Game" at "game.xqm";

(:~
 : This function deletes player from a game
 : @gameID The ID of the game , in which the player will be deleted
 : @return Update the game model
:)
declare %updating function blackjack-player:deletePlayer($gameID as xs:string){
    let $casino := blackjack-game:getCasino()
    let $game := blackjack-game:getGame($gameID)
    return(
         for $p in $game/quitters/player
            return(
                    delete node $p
            )

    )
};

(:~
 : This function inserts the player to the game and based on his tableSeat he will be placed in a certain position
 : @gameID    The ID of game, in which the player will be inserted
 : @player    the player to be inserted
 : @tableSeat The seat of the player to be inserted
 : @return    Update the model by inserting the player
:)

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

(:~
 : This function created a new Player based on his properties
 : @name            The name of  The player to be inserted
 : @balance         The balance of the player to be inserted
 : @id              the ID of The user based on name
 : @tableSeat       The player's seat
 : @return          a player node
:)
declare function blackjack-player:newPlayer($name as xs:string, $balance, $id as xs:integer , $tableSeat as xs:integer) as element(player) {


    <player id = "{$id}">

        <name>{$name}</name>
        <status>free</status>
        <tableSeat>{$tableSeat}</tableSeat>
        <totalmonney>{fn:round($balance cast as xs:double - 0.5) cast as xs:integer}</totalmonney>
        <currentBet>0</currentBet>
        <cards></cards>

     </player>

};
(:~
 : This funtion allows you to create a  new User based on his properties
 : @name                The name of the User
 : @balance             The balance of the new user
 : @points              The points of the new User
 : @id                  The id of The new User
 : @return              the new User
:)

declare function blackjack-player:newUser($name as xs:string, $balance, $points , $id as xs:integer ) as element(user){
          <user id = "{$id}">

                  <name>{$name}</name>
                  <totalmonney>{if($balance < 10) then 100  else fn:round($balance cast as xs:double - 0.5)  cast as xs:integer}</totalmonney>
                  <points>{fn:round($points cast as xs:double - 0.5) cast as xs:integer}</points>
          </user>
};


