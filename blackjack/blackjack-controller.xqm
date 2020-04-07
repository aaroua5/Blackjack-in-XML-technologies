xquery version "3.0";
module namespace blackjack-controller = "blackjack-controller.xqm";
import module namespace blackjack-main = "blackjack/Main" at "blackjack-main.xqm";
import module namespace request = "http://exquery.org/ns/request";
import module namespace blackjack-ws ="blackjack/WS" at "blackjack-ws.xqm";




declare variable $blackjack-controller:staticPath := "../static/blackjack";
declare variable $blackjack-controller:initPlayers := doc("../static/blackjack/initPlayers.html");
declare variable $blackjack-controller:lobby := doc("../static/blackjack/lobby.html");
declare variable $blackjack-controller:initJoin := doc("../static/blackjack/initplayerJoin.html");
declare variable $blackjack-controller:Jack := doc("../static/blackjack/Jack.svg");













declare
%rest:path("bj/setup")
%output:method("html")
%updating
%rest:GET
function blackjack-controller:setup(){
       let $bjModel := (doc("../static/blackjack/blackjack.xml"),doc("../static/blackjack/Jack.svg"))

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
%rest:path("/bj/showGames/{$playerName}/{$balance}")
%output:method("xhtml")
%rest:GET
function blackjack-controller:showGames($playerName as xs:string, $balance as xs:string){

        let $casino := blackjack-main:getCasino()
        let $xslStyleSheet:= "games.xsl"
       let $stylesheet := doc(concat($blackjack-controller:staticPath, "/", $xslStyleSheet))
                              let $map := map{"playerID":$playerName,"balance":$balance}

                   let $transformed := xslt:transform($casino, $stylesheet,$map)
                   return

               <html>
                          {$transformed}

               </html>
};



declare
%rest:GET
%rest:path("/bj/initPlayer")
function blackjack-controller:initPlayers(){
        $blackjack-controller:initPlayers
};


declare
%rest:GET
%rest:path("/bj/form")
%updating
function blackjack-controller:handleinit(){
  let $playerNames :=
      request:parameter("playername1", "")
  let $balances :=
      request:parameter("balance1", "")
   let $redirectLink := fn:concat("/bj/showGames/",$playerNames,"/",$balances)
    return(update:output(web:redirect($redirectLink)))
  };

declare
%rest:POST
%rest:path("/bj/join/{$gameID}/{$playerName}/{$balance}")
%output:method("html")
%updating
function blackjack-controller:join($gameID as xs:string , $playerName as xs:string, $balance as xs:string){
                   let $numberOfUsers := fn:count(blackjack-main:getCasino()/users/player)
                   let $hostname := request:hostname()
                   let $port := request:port()
                   let $address := concat($hostname,":",$port)
                   let $websocketURL := concat("ws://",$address,"/ws/bj")
                   let $getURL := concat("http://", $address, "/bj/draw/",$gameID)
                   let $subscription := concat("/bj/",$numberOfUsers + 1)
                   let $oncloseurl := concat("http://", $address, "/bj/draw/",$gameID)
                   let $html :=
                       <html>
                           <head>
                               <title>blackjack</title>
                               <script src="/static/tictactoe/JS/jquery-3.2.1.min.js"></script>
                               <script src="/static/tictactoe/JS/stomp.js"></script>
                               <script src="/static/tictactoe/JS/ws-element.js"></script>
                           </head>
                           <body>
                               <ws-stream id = "bj" url="{$websocketURL}" subscription = "{$subscription}" geturl = "{$getURL}" oncloseurl = "{$oncloseurl}"/>
                           </body>
                       </html>

                   return(update:output($html) , blackjack-main:join($gameID, $playerName,$balance,$numberOfUsers + 1))
};



declare
%rest:POST
%rest:path("/bj/newGame/{$playerName}/{$balance}")
%output:method("html")
%updating
function blackjack-controller:newGame($playerName,$balance){
        let $game:= blackjack-main:createGame(100,10,"","")

          let $redirectLink := fn:concat("/bj/showGames/",$playerName,"/",$balance)
                           return(update:output(web:redirect($redirectLink)),blackjack-main:insertGame($game))
};


declare
%rest:path("/bj/draw/{$gameID}")
%rest:GET
function blackjack-controller:draw($gameID as xs:string){
        let $wsIDs := blackjack-ws:getIDs()
        let $stylesheet := doc("../static/blackjack/blackjack.xsl")
        let $gameOverStylesheet := doc("../static/blackjack/scores.xsl")
        let $game := blackjack-main:getGame($gameID)
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
                       if(fn:count($game/players/player[@id = $playerID]) = 1  or fn:count($game/waitPlayers/player[@id = $playerID]) = 1 ) then(
                        blackjack-ws:send($transformedGame,concat("/bj/",$playerID))
                        )
                        else (
                            if(fn:count($game/loosers/player[@id= $playerID]) = 1  ) then(
                                blackjack-ws:send($endGame,concat("/bj/",$playerID))
                            )
                        )


                )
        )
};

declare
%rest:path("/bj/bet/{$gameID}/{$betAmount}")
%rest:POST
%updating
function blackjack-controller:bet($gameID as xs:string,$betAmount as xs:integer){
    let $game := blackjack-main:getGame($gameID)
    let $redirectLink := fn:concat("/bj/draw/", $gameID)

    return(blackjack-main:bet($gameID,$betAmount),update:output(web:redirect($redirectLink))
          )
    };






declare
%rest:GET
%output:method("html")
%rest:path("/bj/checkScores/{$gameID}")
%updating
function blackjack-controller:checkScores($gameID as xs:string){
        let $redirectLink := fn:concat("/bj/drawScores/",$gameID)
        return(blackjack-main:checkScores($gameID),update:output(web:redirect($redirectLink)))
};

declare
%rest:GET
%output:method("html")
%rest:path("/bj/drawScores/{$gameID}")
function blackjack-controller:drawScores($gameID as xs:string){
            let $game := blackjack-main:getGame($gameID)
            let $xslStylesheet := "scores.xsl"
            let $title := "blackjackscores"
            return(blackjack-controller:generatePage($game, $xslStylesheet, $title))
};
declare
%rest:POST
%output:method("html")
%rest:path("/bj/beforeBet/{$gameID}")
%updating
function blackjack-controller:beforeBet($gameID as xs:string){
        let $redirectLink := fn:concat("/bj/draw/",$gameID)
        return (blackjack-main:beforeBet($gameID), update:output(web:redirect($redirectLink)))
};

declare
%rest:POST
%rest:path("/bj/newRound/{$gameID}")
%updating
function blackjack-controller:newRound($gameID){
    let $redirectLink := fn:concat("/bj/updateSeats/",$gameID)
    return(blackjack-main:newRound($gameID),update:output(web:redirect($redirectLink)))
};

declare
%rest:GET
%output:method("html")
%rest:path("/bj/updateSeats/{$gameID}")
%updating
function blackjack-controller:updateSeats($gameID as xs:string){
    let $redirectLink := fn:concat("/bj/draw/",$gameID)
    return(blackjack-main:updateSeats($gameID), update:output(web:redirect($redirectLink)))
};


declare
%rest:GET
%output:method("html")
%rest:path("/bj/initializeSum/{$gameID}")
%updating
function blackjack-controller:initializeSum($gameID as xs:string){
        let $redirectLink := fn:concat("/bj/draw/",$gameID)
        return(blackjack-main:initliazeSum($gameID),update:output(web:redirect($redirectLink)))
};




declare
%rest:POST
%rest:path("/bj/double/{$gameID}")
%updating
function blackjack-controller:double($gameID as xs:string){
        let $redirectLink := fn:concat("/bj/draw/",$gameID)
        return(blackjack-main:double($gameID),update:output(web:redirect($redirectLink)))
};



declare
%rest:GET
%rest:path("/bj/startGame/{$gameID}")
%updating
function blackjack-controller:startGame($gameID){
       let $redirectLink := fn:concat("/bj/initializeSum/", $gameID)
        return(blackjack-main:startGame($gameID),update:output(web:redirect($redirectLink)))
};


declare
%rest:POST
%output:method("html")
%rest:path("/bj/gameOver/{$gameID}")
%updating
function blackjack-controller:gameOver($gameID){
    let $redirectLink := "/bj/lobby"
    return (blackjack-main:deletePlayer($gameID),update:output(web:redirect($redirectLink)))
};

declare
%rest:POST
%output:method("html")
%rest:path("/bj/surrender/{$gameID}")
%updating
function blackjack-controller:surrender($gameID){
        let $redirectLink := fn:concat("/bj/draw/",$gameID)
        return(
                blackjack-main:surrender($gameID), update:output(web:redirect($redirectLink))
        )
};



declare
%rest:GET
%rest:path("/bj/updateEvents/{$gameID}")
%updating
function blackjack-controller:updateEvents($gameID as xs:string){
    let $redirectLink := fn:concat("/bj/draw/", $gameID)
    return(blackjack-main:updateEvents($gameID),update:output(web:redirect($redirectLink)))
};


declare
%rest:POST
%rest:path("/bj/nextBet/{$gameID}")
%updating
function blackjack-controller:nextBet($gameID as xs:string){
    let $game :=blackjack-main:getGame($gameID)
    let $startRedirectLink := fn:concat("/bj/startGame/",$gameID)
    let $redirectLink := fn:concat("/bj/draw/", $gameID)
    let $numberOfPlayers := fn:count($game/players/player)

  return(blackjack-main:nextBet($gameID), update:output(web:redirect($redirectLink)))
};
declare
%rest:POST
%rest:path("/bj/clear/{$gameID}")
%updating
function blackjack-controller:clear($gameID as xs:string){
        let $redirectLink := fn:concat("/bj/draw/", $gameID)
        return(blackjack-main:clear($gameID), update:output(web:redirect($redirectLink)))

};

declare
%rest:POST
%rest:path("/bj/hit/{$gameID}")
%updating
function blackjack-controller:hit($gameID as xs:string){
        let $redirectLink := fn:concat("/bj/draw/", $gameID)
        let $redirectDealerLink :=fn:concat("/bj/dealer/", $gameID)
        let $activePlayer := blackjack-main:getGame($gameID)/playerTurn
        return(
                if( $activePlayer > 0 ) then(
                  blackjack-main:hit($gameID),update:output(web:redirect($redirectLink))
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
        return(blackjack-main:dealerTurn($gameID),update:output(web:redirect($redirectLink)))
};

declare
%rest:GET
%rest:path("/bj/checkWinnings/{$gameID}")
%updating
function blackjack-controller:checkWinnings($gameID as xs:string){
        let $redirectLink := fn:concat("/bj/updateEvents/",$gameID)
        return(blackjack-main:checkWinnings($gameID),update:output(web:redirect($redirectLink)))
};

declare
%rest:GET
%rest:path("/bj/getJack")
%output:method("html")
function blackjack-controller:getJack(){
        <html> <head></head> <body> <object data="../static/blackjack/Jack.png"></object></body></html>
};


declare
%rest:POST
%rest:path("/bj/stand/{$gameID}")
%updating
function blackjack-controller:stand($gameID as xs:string){
          let $redirectLink := fn:concat("/bj/draw/", $gameID)
          let $dealerRedirectLink:=fn:concat("bj/dealer/",$gameID)
           let $activePlayer := blackjack-main:getGame($gameID)/playerTurn
                  return(
                          if( $activePlayer > 0 ) then(
                            blackjack-main:stand($gameID),update:output(web:redirect($redirectLink))
                          )
                          else(
                          update:output(web:redirect($dealerRedirectLink)))
                          )
};

declare function blackjack-controller:generatePage($game as element(*), $xslStylesheet as xs:string, $title as xs:string ){
    let $stylesheet := doc(concat($blackjack-controller:staticPath, "/", $xslStylesheet))
    let $transformed := xslt:transform($game, $stylesheet)
    return

<html>
           {$transformed}

</html>

};



