xquery version "3.0";
module namespace blackjack-controller = "blackjack-controller.xqm";
import module namespace blackjack-game = "blackjack/Game" at "game.xqm";
import module namespace request = "http://exquery.org/ns/request";
import module namespace blackjack-ws ="blackjack/WS" at "blackjack-ws.xqm";
import module namespace blackjack-player = "blackjack/Player" at "player.xqm";
import module namespace blackjack-action = "blackjack/Action" at "action.xqm";
import module namespace helper = "blackjack/helper" at "helper.xqm";




declare variable $blackjack-controller:staticPath := "../static/blackjack";
declare variable $blackjack-controller:initPlayers := doc("../static/blackjack/HTML/initPlayers.html");
declare variable $blackjack-controller:lobby := doc("../static/blackjack/HTML/lobby.html");
declare variable $blackjack-controller:rules := doc("../static/blackjack//HTML/rules.html");
declare variable $blackjack-controller:about := doc("../static/blackjack/HTML/about.html");













declare
%rest:path("bj/setup")
%output:method("html")
%updating
%rest:GET
function blackjack-controller:setup(){
       let $bjModel := doc("../static/blackjack/blackjack.xml")

       let $redirectLink := "/bj/lobby"
       return(db:create("bj",$bjModel),update:output(web:redirect($redirectLink)))
};

declare
%rest:path("bj/lobby")
%output:method("html")
%rest:GET
function blackjack-controller:lobby(){
        $blackjack-controller:lobby
};


declare
%rest:path("bj/rules")
%output:method("html")
%rest:GET
function blackjack-controller:rules(){
    $blackjack-controller:rules
};


declare
%rest:path("bj/about")
%output:method("html")
%rest:GET
function blackjack-controller:about(){
    $blackjack-controller:about
};


declare
%rest:GET
%rest:path("/bj/initPlayer")
function blackjack-controller:initPlayers(){
        $blackjack-controller:initPlayers
};


declare
%rest:POST
%rest:path("/bj/form")
%output:method("html")
%updating
function blackjack-controller:handleinit(){
  let $playerNames :=
      request:parameter("playername1", "")
   let $redirectLink := fn:concat("/bj/wsInit/",$playerNames,"/",100)
   let $redirectLinkInit := "/bj/initPlayer"
   let $id := blackjack-controller:getID(blackjack-game:getCasino()/numberOfUsers,$playerNames)

    return(if($id = blackjack-game:getCasino()/numberOfUsers) then(update:output(web:redirect($redirectLink)))
            else(
                update:output(web:redirect($redirectLinkInit))
            )
          )
  };

declare
%rest:GET
%rest:path("/bj/returnToGames/{$gameID}/{$playerID}")
%updating
function blackjack-controller:returnToGames($gameID as xs:string ,$playerID as xs:integer){
        insert node <lobby><id>{$playerID}</id></lobby> into blackjack-game:getCasino()/lobbys,
        delete node blackjack-game:getGame($gameID)/quitters/player[@id =$playerID],
        update:output(web:redirect("/bj/showGames"))
};

declare
%rest:GET
%rest:path("/bj/returnToLobby/{$gameID}/{$playerID}")
%updating
function blackjack-controller:returnToLobby($gameID as xs:string , $playerID as xs:integer){

  delete node blackjack-game:getGame($gameID)/quitters/player[@id =$playerID],
        update:output(web:redirect("/bj/lobby"))
};

declare
%rest:GET
%rest:path("/bj/menu/{$playerID}")
%updating
function blackjack-controller:menu($playerID as xs:integer){
        delete node blackjack-game:getCasino()/lobbys/lobby[id = $playerID],
        update:output(web:redirect("/bj/lobby"))

};

declare
%rest:GET
%rest:path("/bj/wsInit/{$playerName}/{$balance}")
%output:method("html")
%updating
function blackjack-controller:wsInit($playerName as xs:string, $balance as xs:string){

             let $numberOfUsers := blackjack-game:getCasino()/numberOfUsers
                               let $hostname := request:hostname()
                               let $port := request:port()
                               let $address := concat($hostname,":",$port)
                               let $websocketURL := concat("ws://",$address,"/ws/bj")
                               let $getURL := concat("http://", $address, "/bj/showGames")
                               let $subscription := concat("/bj/",$numberOfUsers)
                               let $html :=
                                   <html>
                                       <head>
                                           <title>blackjack</title>
                                           <script src="/static/tictactoe/JS/jquery-3.2.1.min.js"></script>
                                           <script src="/static/tictactoe/JS/stomp.js"></script>
                                           <script src="/static/tictactoe/JS/ws-element.js"></script>
                                       </head>
                                       <body>
                                           <ws-stream id = "bj" url="{$websocketURL}" subscription = "{$subscription}" geturl = "{$getURL}" />
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
                                        where  blackjack-ws:get($wsID,"applicationID") = "bj"
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
%rest:path("/bj/showGames")
%rest:GET
function blackjack-controller:showGames(){

           let $casino := blackjack-game:getCasino()
            let $xslStyleSheet:= "games.xsl"
            let $stylesheet := doc(concat($blackjack-controller:staticPath, "/XSL/", $xslStyleSheet))
            let $wsIDs := blackjack-ws:getIDs()
            return(
                    for $wsID in $wsIDs
                  return(  let $playerID := blackjack-ws:get($wsID,"playerID")
                           where blackjack-ws:get($wsID,"applicationID") = "bj"

                            let $playerName := $casino/users/user[$playerID = @id]/name
                            let $balance := $casino/users/user[$playerID = @id]/totalmonney

                            let $map := map{"playerName":$playerName,"balance":$balance}
                            let $transformedCasino := xslt:transform($casino,$stylesheet,$map)
                            return(
                                if(fn:count($casino/lobbys[lobby = $playerID]) > 0) then(
                                        blackjack-ws:send($transformedCasino,concat("/bj/",$playerID))
                                )

                            )
                            )
            )

};



declare
%rest:POST
%rest:path("/bj/join/{$gameID}/{$playerName}/{$balance}")
%output:method("html")
%updating
function blackjack-controller:join($gameID as xs:string , $playerName as xs:string, $balance as xs:string){
       update:output(web:redirect(fn:concat("/bj/draw/",$gameID))) , blackjack-game:join($gameID, $playerName,$balance)
};

declare
%rest:POST
%rest:path("/bj/random/{$playerName}/{$balance}")
%output:method("html")
%updating
function blackjack-controller:random($playerName as xs:string, $balance as xs:string){
            let $randomNumber := helper:randomNumber(fn:count(blackjack-game:getCasino()/blackjack))
            let $gameID := blackjack-game:getCasino()/blackjack[fn:position() = $randomNumber]/@id
             return(
                update:output(web:redirect(fn:concat("/bj/draw/",$gameID))),blackjack-game:join($gameID, $playerName, $balance)
            )


};



declare
%rest:POST
%rest:path("/bj/newGame")
%output:method("html")
%updating
function blackjack-controller:newGame(){
        let $game:= blackjack-game:createGame(100,10,"","")

          let $redirectLink := "/bj/showGames"
                           return(update:output(web:redirect($redirectLink)),blackjack-game:insertGame($game))
};


declare
%rest:path("/bj/draw/{$gameID}")
%rest:GET
function blackjack-controller:draw($gameID as xs:string){
        let $wsIDs := blackjack-ws:getIDs()
        let $stylesheet := doc("../static/blackjack/XSL/blackjack.xsl")
        let $gameOverStylesheet := doc("../static/blackjack/XSL/scores.xsl")
        let $game := blackjack-game:getGame($gameID)
        let $gameIDs := for $p in $game/players/player
                        return($p/@id)
        return(
                for $wsID in $wsIDs
                where blackjack-ws:get($wsID,"applicationID") = "bj"
                let $playerID := blackjack-ws:get($wsID,"playerID")
                let $map := map {"playerID":$playerID}
                let $transformedGame := xslt:transform($game,$stylesheet,$map)
                let $endGame := xslt:transform($game,$gameOverStylesheet,$map)
                return(
                       if($game/players/player[@id = $playerID]  or $game/waitPlayers/player[@id = $playerID] ) then(
                                blackjack-ws:send($transformedGame,concat("/bj/",$playerID))
                        )
                        else (
                            if($game/quitters/player[@id= $playerID]) then(
                                blackjack-ws:send($endGame,concat("/bj/",$playerID))
                            )
                        )


                ),
                blackjack-controller:showGames()
        )
};

declare
%rest:path("/bj/bet/{$gameID}/{$betAmount}")
%rest:POST
%updating
function blackjack-controller:bet($gameID as xs:string,$betAmount as xs:integer){
    let $game := blackjack-game:getGame($gameID)
    let $redirectLink := fn:concat("/bj/draw/", $gameID)

    return(blackjack-action:bet($gameID,$betAmount),update:output(web:redirect($redirectLink))
          )
    };






declare
%rest:GET
%output:method("html")
%rest:path("/bj/checkScores/{$gameID}")
%updating
function blackjack-controller:checkScores($gameID as xs:string){
        let $redirectLink := fn:concat("/bj/drawScores/",$gameID)
        return(blackjack-game:checkScores($gameID),update:output(web:redirect($redirectLink)))
};

declare
%rest:GET
%output:method("html")
%rest:path("/bj/drawScores/{$gameID}")
function blackjack-controller:drawScores($gameID as xs:string){
            let $game := blackjack-game:getGame($gameID)
            let $xslStylesheet := "scores.xsl"
            let $title := "blackjackscores"
            return(blackjack-controller:generatePage($game, $xslStylesheet, $title))
};


declare
%rest:GET
%rest:path("/bj/newRound/{$gameID}")
%updating
function blackjack-controller:newRound($gameID){
    let $redirectLink := fn:concat("/bj/updateSeats/",$gameID)
    return(blackjack-game:newRound($gameID),update:output(web:redirect($redirectLink)))
};

declare
%rest:GET
%output:method("html")
%rest:path("/bj/updateSeats/{$gameID}")
%updating
function blackjack-controller:updateSeats($gameID as xs:string){
    let $redirectLink := fn:concat("/bj/draw/",$gameID)
    return(blackjack-game:updateSeats($gameID), update:output(web:redirect($redirectLink)))
};


declare
%rest:GET
%output:method("html")
%rest:path("/bj/initializeSum/{$gameID}")
%updating
function blackjack-controller:initializeSum($gameID as xs:string){
        let $redirectLink := fn:concat("/bj/draw/",$gameID)
        return(blackjack-game:initliazeSum($gameID),update:output(web:redirect($redirectLink)))
};




declare
%rest:POST
%rest:path("/bj/double/{$gameID}")
%updating
function blackjack-controller:double($gameID as xs:string){
        let $redirectLink := fn:concat("/bj/draw/",$gameID)
        return(blackjack-action:double($gameID),update:output(web:redirect($redirectLink)))
};



declare
%rest:GET
%rest:path("/bj/startGame/{$gameID}")
%updating
function blackjack-controller:startGame($gameID){
       let $redirectLink := fn:concat("/bj/initializeSum/", $gameID)
        return(blackjack-game:startGame($gameID),update:output(web:redirect($redirectLink)))
};


declare
%rest:POST
%output:method("html")
%rest:path("/bj/gameOver/{$gameID}")
%updating
function blackjack-controller:gameOver($gameID){
    let $redirectLink := "/bj/lobby"
    return (blackjack-player:deletePlayer($gameID),update:output(web:redirect($redirectLink)))
};

declare
%rest:POST
%output:method("html")
%rest:path("/bj/surrender/{$gameID}")
%updating
function blackjack-controller:surrender($gameID){
        let $redirectLink := fn:concat("/bj/draw/",$gameID)
        return(
                blackjack-action:surrender($gameID), update:output(web:redirect($redirectLink))
        )
};

declare
%rest:POST
%rest:path("/bj/exitGame/{$gameID}/{$playerID}")
%updating
function blackjack-controller:exitGame($gameID as xs:string,$playerID as xs:integer){

          let $redirectLink := fn:concat("/bj/draw/",$gameID)
          return(
                blackjack-action:exitGame($gameID,$playerID), update:output(web:redirect($redirectLink))
          )

};




declare
%rest:GET
%rest:path("/bj/updateEvents/{$gameID}")
%updating
function blackjack-controller:updateEvents($gameID as xs:string){
    let $redirectLink := fn:concat("/bj/draw/", $gameID)
    return(blackjack-game:updateEvents($gameID),update:output(web:redirect($redirectLink)))
};


declare
%rest:POST
%rest:path("/bj/nextBet/{$gameID}")
%updating
function blackjack-controller:nextBet($gameID as xs:string){
    let $game :=blackjack-game:getGame($gameID)
    let $startRedirectLink := fn:concat("/bj/startGame/",$gameID)
    let $redirectLink := fn:concat("/bj/draw/", $gameID)
    let $numberOfPlayers := fn:count($game/players/player)

  return(blackjack-action:nextBet($gameID), update:output(web:redirect($redirectLink)))
};
declare
%rest:POST
%rest:path("/bj/clear/{$gameID}")
%updating
function blackjack-controller:clear($gameID as xs:string){
        let $redirectLink := fn:concat("/bj/draw/", $gameID)
        return(blackjack-action:clear($gameID), update:output(web:redirect($redirectLink)))

};

declare
%rest:POST
%rest:path("/bj/hit/{$gameID}")
%updating
function blackjack-controller:hit($gameID as xs:string){
        let $redirectLink := fn:concat("/bj/draw/", $gameID)
        let $redirectDealerLink :=fn:concat("/bj/dealer/", $gameID)
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
%rest:path("/bj/dealer/{$gameID}")
%updating
function blackjack-controller:dealer($gameID as xs:string){
        let $redirectLink := fn:concat("/bj/checkWinnings/", $gameID)
        return(blackjack-game:dealerTurn($gameID),update:output(web:redirect($redirectLink)))
};

declare
%rest:GET
%rest:path("/bj/checkWinnings/{$gameID}")
%updating
function blackjack-controller:checkWinnings($gameID as xs:string){
        let $redirectLink := fn:concat("/bj/updateEvents/",$gameID)
        return(blackjack-game:checkWinnings($gameID),update:output(web:redirect($redirectLink)))
};



declare
%rest:POST
%rest:path("/bj/stand/{$gameID}")
%updating
function blackjack-controller:stand($gameID as xs:string){
          let $redirectLink := fn:concat("/bj/draw/", $gameID)
          let $dealerRedirectLink:=fn:concat("bj/dealer/",$gameID)
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



