xquery version "3.0";

module namespace blackjack-ws = "blackjack/WS";
import module namespace websocket = "http://basex.org/modules/Ws";

import module namespace blackjack-main = "blackjack/Main" at "blackjack-main.xqm";

declare
%ws-stomp:connect("/bj")
%updating
function blackjack-ws:stompconnect(){
update:output(trace(concat("WS client connected with id ",websocket:id())))
};

declare
%ws:close("/bj")
%updating
function blackjack-ws:stompdisconnect(){
    update:output(trace(concat("Ws client  disconnected with id ",websocket:id())))
};

declare
%ws-stomp:subscribe("/bj")
%ws:header-param("param0","{$game}")
%ws:header-param("param1", "{$playerID}")
%updating
function blackjack-ws:subscribe($game, $playerID){
websocket:set(websocket:id(),"playerID",$playerID),
websocket:set(websocket:id(),"applicationID","bj"),
update:output(trace(concat("Ws client connected with id ",ws:id(),"subscribed to game ", $game,"with playerID",$playerID)))

};


declare function blackjack-ws:getIDs(){
websocket:ids()
};

declare function blackjack-ws:get($key, $value){
websocket:get($key,$value)
};

declare  function blackjack-ws:send($data, $path){
   websocket:sendchannel(serialize($data), $path)
};
