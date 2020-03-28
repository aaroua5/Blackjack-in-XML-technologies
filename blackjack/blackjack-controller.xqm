xquery version "3.0";
module namespace blackjack-controller = "blackjack-controller.xqm";
import module namespace blackjack-main = "blackjack/Main" at "blackjack-main.xqm";
import module namespace request = "http://exquery.org/ns/request";



declare variable $blackjack-controller:staticPath := "../static/blackjack";
declare variable $blackjack-controller:initPlayers := doc("../static/blackjack/initPlayers.html");
declare variable $blackjack-controller:lobby := doc("../static/blackjack/lobby.html");





declare
%rest:path("bj/setup")
%output:method("xhtml")
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
%rest:path("bj/showGames")
%output:method("xhtml")
%rest:GET
function blackjack-controller:showGames(){

        let $casino := blackjack-main:getCasino()
        let $xslStyleSheet:= "games.xsl"
        return(blackjack-controller:generatePage($casino,$xslStyleSheet,"games") )
};




declare
%rest:GET
%rest:path("bj/initPlayer")
function blackjack-controller:initPlayers(){
        $blackjack-controller:initPlayers
};

declare
%rest:GET
%rest:path("bj/form")
%updating
function blackjack-controller:handleinit(){

let $maxBet := (request:parameter("maxBet"))
  let $minBet := (request:parameter("minBet"))
  let $playerNames :=
      (request:parameter("playername1", ""),
      request:parameter("playername2", ""),
      request:parameter("playername3", ""),
      request:parameter("playername4", ""),
      request:parameter("playername5", ""))
  let $balances :=
      (request:parameter("balance1", ""),
      request:parameter("balance2", ""),
      request:parameter("balance3", ""),
      request:parameter("balance4", ""),
      request:parameter("balance5", ""))

    return(blackjack-controller:start($maxBet,$minBet,$playerNames,$balances))
  };

declare
%rest:GET
%output:method("html")
%rest:path("/bj/start/{$maxBet}/{$minBet}/{$playerNames}/{$balances}")
%updating
function blackjack-controller:start($maxBet as xs:integer, $minBet as xs:integer, $playerNames as xs:string+, $balances as xs:string+){

       let $game := blackjack-main:createGame($maxBet, $minBet, $playerNames, $balances)
       let $xslStylesheet := "blackjack.xsl"
       let $title := "blackjack Lobby"
       return (update:output(web:redirect(fn:concat("/bj/draw/",$game/@id))),blackjack-main:insertGame($game))
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
%output:method("html")
%rest:path("/bj/newRound/{$gameID}")
%updating
function blackjack-controller:newRound($gameID){
    let $redirectLink := fn:concat("/bj/draw/",$gameID)
    return(blackjack-main:newRound($gameID),update:output(web:redirect($redirectLink)))
};


declare
%rest:GET
%output:method("html")
%rest:path("/bj/startGame/{$gameID}")
%updating
function blackjack-controller:startGame($gameID){
       let $redirectLink := fn:concat("/bj/draw/", $gameID)
        return(blackjack-main:startGame($gameID),update:output(web:redirect($redirectLink)))
};
declare
%rest:POST
%output:method("html")
%rest:path("/bj/gameOver/{$gameID}")
%updating
function blackjack-controller:gameOver($gameID){
    let $redirectLink := "/bj/lobby"
    return (blackjack-main:deleteGame($gameID),update:output(web:redirect($redirectLink)))
};
declare
%rest:GET
%output:method("html")
%rest:path("/bj/join/{$gameID}")
function blackjack-controller:join($gameID){
       blackjack-controller:drawGame($gameID)
};
declare
%rest:path("/bj/draw/{$gameID}")
%output:method("html")
%rest:GET

function blackjack-controller:drawGame($gameID as xs:string){

        let $game := blackjack-main:getGame($gameID)
        let $xslStylesheet := "blackjack.xsl"
        let $title := "blackjack"
        return(blackjack-controller:generatePage($game, $xslStylesheet, $title))
};


declare
%rest:POST
%rest:path("/bj/bet/{$gameID}/{$betAmount}")
%updating
function blackjack-controller:bet($gameID as xs:string,$betAmount as xs:integer){
    let $game := blackjack-main:getGame($gameID)
    let $redirectLink := fn:concat("/bj/draw/", $gameID)
    return(blackjack-main:bet($gameID, $betAmount),update:output(web:redirect($redirectLink)))
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
        let $redirectLink := fn:concat("/bj/updateEvents/", $gameID)
        return(blackjack-main:dealerTurn($gameID),update:output(web:redirect($redirectLink)))
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



