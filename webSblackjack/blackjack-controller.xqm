xquery version "3.0";
module namespace blackjack-controller = "blackjack-controller.xqm";
import module namespace blackjack-game = "blackjack/Game" at "game.xqm";
import module namespace request = "http://exquery.org/ns/request";
import module namespace blackjack-ws ="blackjack/WS" at "blackjack-ws.xqm";
import module namespace blackjack-player = "blackjack/Player" at "player.xqm";
import module namespace blackjack-action = "blackjack/Action" at "action.xqm";
import module namespace helper = "blackjack/helper" at "helper.xqm";




declare variable $blackjack-controller:staticPath := "../static/webSblackjack";
declare variable $blackjack-controller:initPlayers := doc("../static/webSblackjack/HTML/initPlayers.html");
declare variable $blackjack-controller:lobby := doc("../static/webSblackjack/HTML/lobby.html");
declare variable $blackjack-controller:rules := doc("../static/webSblackjack//HTML/rules.html");
declare variable $blackjack-controller:about := doc("../static/webSblackjack/HTML/about.html");













declare
%rest:path("webSbj/setup")
%output:method("html")
%updating
%rest:GET
function blackjack-controller:setup(){
       let $bjModel := doc("../static/webSblackjack/casino.xml")

       let $redirectLink := "/webSbj/lobby"
       return(db:create("webSbj",$bjModel),update:output(web:redirect($redirectLink)))
};

declare
%rest:path("webSbj/lobby")
%output:method("html")
%rest:GET
function blackjack-controller:lobby(){
        $blackjack-controller:lobby
};


declare
%rest:path("webSbj/rules")
%output:method("html")
%rest:GET
function blackjack-controller:rules(){
    $blackjack-controller:rules
};


declare
%rest:path("webSbj/about")
%output:method("html")
%rest:GET
function blackjack-controller:about(){
    $blackjack-controller:about
};


declare
%rest:GET
%rest:path("/webSbj/initPlayer")
function blackjack-controller:initPlayers(){
        $blackjack-controller:initPlayers
};


declare
%rest:POST
%rest:path("/webSbj/form")
%output:method("html")
%updating
function blackjack-controller:handleinit(){
  let $playerNames :=
      request:parameter("playername1", "")
   let $redirectLink := fn:concat("/webSbj/wsInit/",$playerNames,"/",100)
   let $redirectLinkInit := "/webSbj/initPlayer"
   let $id := blackjack-controller:getID(blackjack-game:getCasino()/numberOfUsers,$playerNames)

    return(if($id = blackjack-game:getCasino()/numberOfUsers) then(update:output(web:redirect($redirectLink)))
            else(
                update:output(web:redirect($redirectLinkInit))
            )
          )
  };

declare
%rest:GET
%rest:path("/webSbj/returnToGames/{$gameID}/{$playerID}")
%updating
function blackjack-controller:returnToGames($gameID as xs:string ,$playerID as xs:integer){
        insert node <lounge><id>{$playerID}</id></lounge> into blackjack-game:getCasino()/lounges,
        delete node blackjack-game:getGame($gameID)/quitters/player[@id =$playerID],
        update:output(web:redirect("/webSbj/showGames"))
};

declare
%rest:GET
%rest:path("/webSbj/returnToLobby/{$gameID}/{$playerID}")
%updating
function blackjack-controller:returnToLobby($gameID as xs:string , $playerID as xs:integer){

  delete node blackjack-game:getGame($gameID)/quitters/player[@id =$playerID],
        update:output(web:redirect("/webSbj/lobby"))
};

declare
%rest:GET
%rest:path("/webSbj/menu/{$playerID}")
%updating
function blackjack-controller:menu($playerID as xs:integer){
        delete node blackjack-game:getCasino()/lounges/lounge[id = $playerID],
        update:output(web:redirect("/webSbj/lobby"))

};

declare
%rest:GET
%rest:path("/webSbj/wsInit/{$playerName}/{$balance}")
%output:method("html")
%updating
function blackjack-controller:wsInit($playerName as xs:string, $balance as xs:string){

             let $numberOfUsers := blackjack-game:getCasino()/numberOfUsers
                               let $hostname := request:hostname()
                               let $port := request:port()
                               let $address := concat($hostname,":",$port)
                               let $websocketURL := concat("ws://",$address,"/ws/webSbj")
                               let $getURL := concat("http://", $address, "/webSbj/showGames")
                               let $subscription := concat("/webSbj/",$numberOfUsers)
                               let $html :=
                                   <html>
                                       <head>
                                           <title>blackjack</title>
                                           <script src="/static/tictactoe/JS/jquery-3.2.1.min.js"></script>
                                           <script src="/static/tictactoe/JS/stomp.js"></script>
                                           <script src="/static/tictactoe/JS/ws-element.js"></script>
                                       </head>
                                       <body>
                                           <ws-stream id = "webSbj" url="{$websocketURL}" subscription = "{$subscription}" geturl = "{$getURL}" />
                                       </body>
                                   </html>

            return(update:output($html),blackjack-game:addUser($playerName , $balance,blackjack-controller:getID(blackjack-game:getCasino()/numberOfUsers,$playerName),blackjack-game:getCasino()/numberOfUsers))

}  ;



declare function blackjack-controller:getID($numberOfUsers as xs:integer, $playerName as xs:string){
            let $id := blackjack-game:getCasino()/users/user[name = $playerName]/@id
            let $wsIDs := blackjack-ws:getIDs()
            return(
                    if($id) then(
                           let $IDs:= for $wsID in $wsIDs
                                        where  blackjack-ws:get($wsID,"applicationID") = "webSbj"
                                        return(
                                                if($id = blackjack-ws:get($wsID,"playerID")) then(
                                                        $id
                                                )
                                        )
                           return(
                                    if(fn:count($IDs) > 0) then(
                                            $IDs[fn:position() =1]
                                    ) else (
                                        $numberOfUsers
                                    )
                           )
                    )   else(
                        $numberOfUsers
                    )
            )
};

declare
%rest:path("/webSbj/showGames")
%rest:GET
function blackjack-controller:showGames(){

           let $casino := blackjack-game:getCasino()
            let $xslStyleSheet:= "lounge.xsl"
            let $stylesheet := doc(concat($blackjack-controller:staticPath, "/XSL/", $xslStyleSheet))
            let $wsIDs := blackjack-ws:getIDs()
            return(
                    for $wsID in $wsIDs
                  return(  let $playerID := blackjack-ws:get($wsID,"playerID")
                           where blackjack-ws:get($wsID,"applicationID") = "webSbj"

                            let $playerName := $casino/users/user[$playerID = @id]/name
                            let $balance := $casino/users/user[$playerID = @id]/totalmonney

                            let $map := map{"playerName":$playerName,"balance":$balance}
                            let $transformedCasino := xslt:transform($casino,$stylesheet,$map)
                            return(
                                if(fn:count($casino/lounges[lounge = $playerID]) > 0) then(
                                        blackjack-ws:send($transformedCasino,concat("/webSbj/",$playerID))
                                )

                            )
                            )
            )

};



declare
%rest:POST
%rest:path("/webSbj/join/{$gameID}/{$playerName}/{$balance}")
%output:method("html")
%updating
function blackjack-controller:join($gameID as xs:string , $playerName as xs:string, $balance as xs:string){
       update:output(web:redirect(fn:concat("/webSbj/draw/",$gameID))) , blackjack-game:join($gameID, $playerName,$balance)
};

declare
%rest:POST
%rest:path("/webSbj/random/{$playerName}/{$balance}")
%output:method("html")
%updating
function blackjack-controller:random($playerName as xs:string, $balance as xs:string){
            let $randomNumber := helper:randomNumber(fn:count(blackjack-game:getCasino()/blackjack))
            let $gameID := blackjack-game:getCasino()/blackjack[fn:position() = $randomNumber]/@id
             return(
                update:output(web:redirect(fn:concat("/webSbj/draw/",$gameID))),blackjack-game:join($gameID, $playerName, $balance)
            )


};



declare
%rest:POST
%rest:path("/webSbj/newGame")
%output:method("html")
%updating
function blackjack-controller:newGame(){
        let $game:= blackjack-game:createGame(100,10,"","")

          let $redirectLink := "/webSbj/showGames"
                         return(update:output(web:redirect($redirectLink)),blackjack-game:insertGame($game))
};


declare
%rest:path("/webSbj/draw/{$gameID}")
%rest:GET
function blackjack-controller:draw($gameID as xs:string){
        let $wsIDs := blackjack-ws:getIDs()
        let $stylesheet := doc("../static/webSblackjack/XSL/blackjack.xsl")
        let $gameOverStylesheet := doc("../static/webSblackjack/XSL/endGame.xsl")
        let $game := blackjack-game:getGame($gameID)
        let $gameIDs := for $p in $game/players/player
                        return($p/@id)
        return(
                for $wsID in $wsIDs
                where blackjack-ws:get($wsID,"applicationID") = "webSbj"
                let $playerID := blackjack-ws:get($wsID,"playerID")
                let $map := map {"playerID":$playerID}
                let $transformedGame := xslt:transform($game,$stylesheet,$map)
                let $endGame := xslt:transform($game,$gameOverStylesheet,$map)
                return(
                       if($game/players/player[@id = $playerID]  or $game/waitPlayers/player[@id = $playerID] ) then(
                                blackjack-ws:send($transformedGame,concat("/webSbj/",$playerID))
                        )
                        else (
                            if($game/quitters/player[@id= $playerID]) then(
                                blackjack-ws:send($endGame,concat("/webSbj/",$playerID))
                            )
                        )
                ),
                blackjack-controller:showGames()
        )
};

declare
%rest:path("/webSbj/bet/{$gameID}/{$betAmount}")
%rest:POST
%updating
function blackjack-controller:bet($gameID as xs:string,$betAmount as xs:integer){
    let $game := blackjack-game:getGame($gameID)
    let $redirectLink := fn:concat("/webSbj/draw/", $gameID)

    return(blackjack-action:bet($gameID,$betAmount),update:output(web:redirect($redirectLink))
          )
    };







declare
%rest:GET
%rest:path("/webSbj/newRound/{$gameID}")
%updating
function blackjack-controller:newRound($gameID){
    let $redirectLink := fn:concat("/webSbj/updateSeats/",$gameID)
    return(blackjack-game:newRound($gameID),update:output(web:redirect($redirectLink)))
};

declare
%rest:GET
%output:method("html")
%rest:path("/webSbj/updateSeats/{$gameID}")
%updating
function blackjack-controller:updateSeats($gameID as xs:string){
    let $redirectLink := fn:concat("/webSbj/draw/",$gameID)
    return(blackjack-game:updateSeats($gameID), update:output(web:redirect($redirectLink)))
};


declare
%rest:GET
%output:method("html")
%rest:path("/webSbj/initializeSum/{$gameID}")
%updating
function blackjack-controller:initializeSum($gameID as xs:string){
        let $redirectLink := fn:concat("/webSbj/draw/",$gameID)
        return(blackjack-game:initliazeSum($gameID),update:output(web:redirect($redirectLink)))
};




declare
%rest:POST
%rest:path("/webSbj/double/{$gameID}")
%updating
function blackjack-controller:double($gameID as xs:string){
        let $redirectLink := fn:concat("/webSbj/draw/",$gameID)
        return(blackjack-action:double($gameID),update:output(web:redirect($redirectLink)))
};



declare
%rest:GET
%rest:path("/webSbj/startGame/{$gameID}")
%updating
function blackjack-controller:startGame($gameID){
       let $redirectLink := fn:concat("/webSbj/initializeSum/", $gameID)
        return(blackjack-game:startGame($gameID),update:output(web:redirect($redirectLink)))
};


declare
%rest:POST
%output:method("html")
%rest:path("/webSbj/gameOver/{$gameID}")
%updating
function blackjack-controller:gameOver($gameID){
    let $redirectLink := "/webSbj/lobby"
    return (blackjack-player:deletePlayer($gameID),update:output(web:redirect($redirectLink)))
};

declare
%rest:POST
%output:method("html")
%rest:path("/webSbj/surrender/{$gameID}")
%updating
function blackjack-controller:surrender($gameID){
        let $redirectLink := fn:concat("/webSbj/draw/",$gameID)
        return(
                blackjack-action:surrender($gameID), update:output(web:redirect($redirectLink))
        )
};

declare
%rest:POST
%rest:path("/webSbj/exitGame/{$gameID}/{$playerID}")
%updating
function blackjack-controller:exitGame($gameID as xs:string,$playerID as xs:integer){

          let $redirectLink := fn:concat("/webSbj/draw/",$gameID)
          return(
                blackjack-action:exitGame($gameID,$playerID), update:output(web:redirect($redirectLink))
          )

};




declare
%rest:GET
%rest:path("/webSbj/updateEvents/{$gameID}")
%updating
function blackjack-controller:updateEvents($gameID as xs:string){
    let $redirectLink := fn:concat("/webSbj/draw/", $gameID)
    return(blackjack-game:updateEvents($gameID),update:output(web:redirect($redirectLink)))
};


declare
%rest:POST
%rest:path("/webSbj/nextBet/{$gameID}")
%updating
function blackjack-controller:nextBet($gameID as xs:string){
    let $game :=blackjack-game:getGame($gameID)
    let $startRedirectLink := fn:concat("/webSbj/startGame/",$gameID)
    let $redirectLink := fn:concat("/webSbj/draw/", $gameID)
    let $numberOfPlayers := fn:count($game/players/player)

  return(blackjack-action:nextBet($gameID), update:output(web:redirect($redirectLink)))
};
declare
%rest:POST
%rest:path("/webSbj/clear/{$gameID}")
%updating
function blackjack-controller:clear($gameID as xs:string){
        let $redirectLink := fn:concat("/webSbj/draw/", $gameID)
        return(blackjack-action:clear($gameID), update:output(web:redirect($redirectLink)))

};

declare
%rest:POST
%rest:path("/webSbj/hit/{$gameID}")
%updating
function blackjack-controller:hit($gameID as xs:string){
        let $redirectLink := fn:concat("/webSbj/draw/", $gameID)
        let $redirectDealerLink :=fn:concat("/webSbj/dealer/", $gameID)
        let $activePlayer := blackjack-game:getGame($gameID)/playerTurn
        return(
                if( $activePlayer > 0 ) then(
                  blackjack-action:hit($gameID),update:output(web:redirect($redirectLink))
                )
                else(
                update:output(web:redirect($redirectDealerLink)))
                )
};


declare
%rest:GET
%rest:path("/webSbj/dealer/{$gameID}")
%updating
function blackjack-controller:dealer($gameID as xs:string){
        let $redirectLink := fn:concat("/webSbj/checkWinnings/", $gameID)
        return(blackjack-game:dealerTurn($gameID),update:output(web:redirect($redirectLink)))
};

declare
%rest:GET
%rest:path("/webSbj/checkWinnings/{$gameID}")
%updating
function blackjack-controller:checkWinnings($gameID as xs:string){
        let $redirectLink := fn:concat("/webSbj/updateEvents/",$gameID)
        return(blackjack-game:checkWinnings($gameID),update:output(web:redirect($redirectLink)))
};



declare
%rest:POST
%rest:path("/webSbj/stand/{$gameID}")
%updating
function blackjack-controller:stand($gameID as xs:string){
          let $redirectLink := fn:concat("/webSbj/draw/", $gameID)
          let $dealerRedirectLink:=fn:concat("webSbj/dealer/",$gameID)
           let $activePlayer := blackjack-game:getGame($gameID)/playerTurn
                  return(
                          if( $activePlayer > 0 ) then(
                            blackjack-action:stand($gameID),update:output(web:redirect($redirectLink))
                          )
                          else(
                          update:output(web:redirect($dealerRedirectLink)))
                          )
};

declare function blackjack-controller:generatePage($game as element(*), $xslStylesheet as xs:string, $title as xs:string ){
    let $stylesheet := doc(concat($blackjack-controller:staticPath, "/XSL/", $xslStylesheet))
    let $transformed := xslt:transform($game, $stylesheet)
    return

<html>
           {$transformed}

</html>

};



