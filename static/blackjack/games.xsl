<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:param name="playerID"/>
    <xsl:param name="balance"/>
    <xsl:template match="casino">

        <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="100%" height="100%" viewBox="0, 0, 1800, 900">

            <defs>
                
                <linearGradient id="goldGradient" x1="0" y1="0" x2="1" y2="1">
                    <stop offset="5%" stop-color="#efcf76"></stop>
                    <stop offset="33%" stop-color="#fcdd7a"></stop>
                    <stop offset="66%" stop-color="#cfba65"></stop>
                    <stop offset="100%" stop-color="#988058"></stop>
                </linearGradient>

                <filter id="inner-glow">
                    <feFlood flood-color="#09846F"/>
                    <feComposite in2="SourceAlpha" operator="out"/>
                    <feGaussianBlur stdDeviation="1" result="blur"/>
                    <feComposite operator="atop" in2="SourceGraphic"/>
                </filter>

                <filter id="f2" x="0" y="0" width="200%" height="200%" filterUnits="userSpaceOnUse">
                    <feOffset result="offOut" in="SourceAlpha" dx="1.5" dy="1.5" />
                    <feGaussianBlur result="blurOut" in="offOut" stdDeviation="2" />
                    <feBlend in="SourceGraphic" in2="blurOut" mode="normal" />
                </filter>
                
                <g id="background" >
                    <svg width="100%" height="100%">
                        <rect x="0"  y="0" width="100%" height="100%" fill="#0F2822" />
                    </svg>
                </g>
                
                <g id="leader board">
                    <svg x="-499" y="45">
                        <svg id="table" width="100%" height="100%" viewBox="0 0 100 100">
                            <rect x="30" y="4" width="49" height="79" rx="2" ry="2" fill="#095584" stroke-width="0.5" stroke="url(#goldGradient)"/>

                            <rect x="39" y="7" width="31" height="6" rx="2" ry="2" fill="#043b5c"/>
                            <text x="54.5" y="3.3" dy="2em" fill="#fbda79" font-size="4" text-anchor="middle">TOP players are</text>

                            <rect x="33" y="18" width="43" height="6" rx="2" ry="2" fill="#07486e"/>

                            <rect x="33" y="26" width="43" height="6" rx="2" ry="2" fill="#07486e"/>

                            <rect x="33" y="34" width="43" height="6" rx="2" ry="2" fill="#07486e"/>

                            <rect x="33" y="42" width="43" height="6" rx="2" ry="2" fill="#07486e"/>

                            <rect x="33" y="50" width="43" height="6" rx="2" ry="2" fill="#07486e"/>

                            <rect x="33" y="58" width="43" height="6" rx="2" ry="2" fill="#07486e"/>

                            <rect x="33" y="66" width="43" height="6" rx="2" ry="2" fill="#07486e"/>

                            <rect x="33" y="74" width="43" height="6" rx="2" ry="2" fill="#07486e"/>

                        </svg>

                        <svg id="players" width="100%" height="100%" viewBox="0 0 100 100">
                            <text y="14.5" fill="white" font-size="4" >

                                <tspan x="35" dy="2em">Fathi</tspan>
                                <tspan  x="75" fill="#2282bd" text-anchor="end">5385 ✯</tspan>

                                <tspan x="35" dy="2em">Samir</tspan>
                                <tspan x="75" fill="#2282bd" text-anchor="end">4289 ✯</tspan>

                                <tspan x="35" dy="2em">Mounir</tspan>
                                <tspan x="75" fill="#2282bd" text-anchor="end">2900 ✯</tspan>

                                <tspan x="35" dy="2em">Karim</tspan>
                                <tspan x="75" fill="#2282bd" text-anchor="end">2700 ✯</tspan>

                                <tspan x="35" dy="2em">Abdelsmad</tspan>
                                <tspan x="75" fill="#2282bd" text-anchor="end">1426 ✯</tspan>

                                <tspan x="35" dy="2em">Mefteh</tspan>
                                <tspan x="75" fill="#2282bd" text-anchor="end">91 ✯</tspan>

                                <tspan x="35" dy="2em">Sabri</tspan>
                                <tspan x="75" fill="#2282bd" text-anchor="end">69 ✯</tspan>

                                <tspan x="35" dy="2em">Yousri</tspan>
                                <tspan x="74" fill="#2282bd" text-anchor="end">50 ✯</tspan>

                            </text>
                        </svg>
                    </svg>
                </g>

                <g id="games table">
                    <svg x="450" y="75">
                        <svg id="table" width="100%" height="100%" viewBox="0 0 100 100">
                            <rect x="30" y="1" width="49" height="67" rx="2" ry="2" fill="#09846F" stroke-width="0.5" stroke="url(#goldGradient)"/>

                            <rect x="33" y="4" width="43" height="11" rx="2" ry="2" fill="#035c4b"/>
                            <text y="0.7" fill="#fbda79" font-size="4" text-anchor="middle">
                                <tspan x="54.5" dy="2em">Create a new game or</tspan>
                                <tspan x="54.5" dy="1em">join an existing one!</tspan>
                            </text>

                            <rect x="33" y="18" width="34" height="6" rx="2" ry="2" fill="#076e5c"/>
                            <circle cx="73" cy="21" r="3" fill="#076e5c"></circle>

                            <rect x="33" y="26" width="34" height="6" rx="2" ry="2" fill="#076e5c"/>
                            <circle cx="73" cy="29" r="3" fill="#076e5c"></circle>

                            <rect x="33" y="34" width="34" height="6" rx="2" ry="2" fill="#076e5c"/>
                            <circle cx="73" cy="37" r="3" fill="#076e5c"></circle>

                            <rect x="33" y="42" width="34" height="6" rx="2" ry="2" fill="#076e5c"/>
                            <circle cx="73" cy="45" r="3" fill="#076e5c"></circle>

                            <rect x="33" y="50" width="34" height="6" rx="2" ry="2" fill="#076e5c"/>
                            <circle cx="73" cy="53" r="3" fill="#076e5c"></circle>

                            <rect x="33" y="58" width="34" height="6" rx="2" ry="2" fill="#076e5c"/>
                            <circle cx="73" cy="61" r="3" fill="#076e5c"></circle>
                        </svg>

                        <svg id="games" width="100%" height="100%" viewBox="0 0 100 100">
                            <text y="14.5" fill="white" font-size="4" >

                                <tspan x="35" dy="2em">Game 1</tspan>
                                <tspan  x="60" fill="#109c84">0P</tspan>
                                <tspan x="73.8" fill="#014034" text-anchor="middle" baseline-shift="0.2" font-size="3">▶︎</tspan>

                                <tspan x="35" dy="2em">Game 2</tspan>
                                <tspan x="60" fill="#109c84">2P</tspan>
                                <tspan x="73.8" fill="#014034" text-anchor="middle" baseline-shift="0.2" font-size="3">▶︎</tspan>

                                <tspan x="35" dy="2em">Game 3</tspan>
                                <tspan x="60" fill="#109c84">5P</tspan>
                                <tspan x="73.8" fill="#014034" text-anchor="middle" baseline-shift="0.2" font-size="3">▶︎</tspan>

                                <tspan x="35" dy="2em">Game 4</tspan>
                                <tspan x="60" fill="#109c84">3P</tspan>
                                <tspan x="73.8" fill="#014034" text-anchor="middle" baseline-shift="0.2" font-size="3">▶︎</tspan>

                                <tspan x="35" dy="2em">Game 5</tspan>
                                <tspan x="60" fill="#109c84">1P</tspan>
                                <tspan x="73.8" fill="#014034" text-anchor="middle" baseline-shift="0.2" font-size="3">▶︎</tspan>

                                <tspan x="35" dy="2em">Game 6</tspan>
                                <tspan x="60" fill="#109c84">4P</tspan>
                                <tspan x="73.8" fill="#014034" text-anchor="middle" baseline-shift="0.2" font-size="3">▶︎</tspan>

                            </text>
                        </svg>
                    </svg>
                </g>

                <g id="message">
                    <svg id="table" width="100%" height="100%" viewBox="0 0 100 100">
                        <text x="35" y="35" fill="white" font-size="4">
                            <tspan text-anchor="middle">
                                <tspan x="50" dy="2em">Good luck, </tspan>
                                <tspan fill="#fbda79">Yousri</tspan>
                            </tspan>
                            <tspan text-anchor="middle">
                                <tspan  x="50" fill="white" dy="1.5em">Balance: </tspan>
                                <tspan fill="#fbda79" text-anchor="middle">$100</tspan>
                            </tspan>
                            <tspan text-anchor="middle">
                                <tspan  x="50" fill="white" dy="1.5em">Score: </tspan>
                                <tspan fill="#fbda79" text-anchor="middle">50 ✯</tspan>
                            </tspan>
                        </text>
                    </svg>
                </g>
                
                <svg id="buttons" width="100%" height="100%" viewBox="0 0 100 100">

                    <svg id="new game" x="55" y="8">
                        <rect x="40.75" y="72" width="18.5" height="8" rx="2" ry="2" fill="#091b17" stroke-width="0.5" stroke="url(#goldGradient)"/>
                        <text x="50" y="76" font-family="Arial" font-size="3" text-anchor="middle" alignment-baseline="central"
                              fill="#EFCB68">NEW GAME</text>
                    </svg>

                    <svg id="close" x="133.5" y="-5.7" width="100%" height="100%" >
                        <g transform="scale(.56)" >
                            <circle cx="20" cy="20" r="5.4" fill="#c33931"/>
                            <circle cx="20" cy="20" r="5" fill="#f13a44"/>
                            <circle cx="20" cy="20" r="5" fill="#ee535b" clip-path="url(#cut-off-bottom)"/>
                            <rect height="8" width="2" x="19" y="16" rx="1" ry="1" fill="white" transform="rotate(45 20 20)"/>
                            <rect height="8" width="2" x="19" y="16" rx="1" ry="1" fill="white" transform="rotate(-45 20 20)"/>
                        </g>
                    </svg>

                </svg>

                <g id="buttons" >
                    <text x="30%" y="30%" color="white">
                        <tspan> <xsl:for-each select="blackjack" >
                            <xsl:value-of select="position()"/>====>
                            <xsl:value-of select="./@id"></xsl:value-of>
                        </xsl:for-each>
                        </tspan>
                    </text>
                </g>

            </defs>

            <use href="#background" width="100%" height="100%"/>
            <use href="#games table" width="100%" height="100%"/>
            <use href="#leader board" width="100%" height="100%"/>
            <use href="#message" width="100%" height="100%"/>
            <use href="#buttons" width="100%" height="100%"/>
            
            <foreignObject width="0" height="0">
                <iframe class = "hiddenFrame" xmlns = "http://www.w3.org/1999/xhtml" name="hiddenFrame"></iframe>
            </foreignObject>

            <foreignObject x="72.8%" y="79.8%" width="100%" height="100%" >
                <form xmlns="http://www.w3.org/1999/xhtml" action="/bj/newGame/" method="POST" id="formMenu" style="display: inline;" target ="hiddenFrame" >
                    <button type="submit" form="formMenu" value="Submit" style="height:77px; width:170px;
                    border-radius: 20px;">new Game</button>
                </form>
            </foreignObject>
            
            <!-- 6 Join games

            <foreignObject x="85%" y="26.3%"  width="100%" height="100%">
                <form xmlns="http://www.w3.org/1999/xhtml" action="" method="get" id="formjoin1" style="display: inline;" >
                    <button type="submit" form="formjoin1" value="Submit" style="height:54px; width:54px;
                    border-radius: 27px; border: none; background-color: Transparent; outline:none;"></button>
                </form>
            </foreignObject>

            <foreignObject x="85%" y="34.3%"  width="100%" height="100%">
                <form xmlns="http://www.w3.org/1999/xhtml" action="" method="get" id="formjoin2" style="display: inline;" >
                    <button type="submit" form="formjoin2" value="Submit" style="height:54px; width:54px;
                    border-radius: 27px; border: none; background-color: Transparent; outline:none;"></button>
                </form>
            </foreignObject>

            <foreignObject x="85%" y="42.3%"  width="100%" height="100%">
                <form xmlns="http://www.w3.org/1999/xhtml" action="" method="get" id="formjoin3" style="display: inline;" >
                    <button type="submit" form="formjoin3" value="Submit" style="height:54px; width:54px;
                    border-radius: 27px; border: none; background-color: Transparent; outline:none;"></button>
                </form>
            </foreignObject>

            <foreignObject x="85%" y="50.3%"  width="100%" height="100%">
                <form xmlns="http://www.w3.org/1999/xhtml" action="" method="get" id="formjoin4" style="display: inline;" >
                    <button type="submit" form="formjoin4" value="Submit" style="height:54px; width:54px;
                    border-radius: 27px; border: none; background-color: Transparent; outline:none;"></button>
                </form>
            </foreignObject>

            <foreignObject x="85%" y="58.3%"  width="100%" height="100%">
                <form xmlns="http://www.w3.org/1999/xhtml" action="" method="get" id="formjoin5" style="display: inline;" >
                    <button type="submit" form="formjoin5" value="Submit" style="height:54px; width:54px;
                    border-radius: 27px; border: none; background-color: Transparent; outline:none;"></button>
                </form>
            </foreignObject>

            <foreignObject x="85%" y="66.3%"  width="100%" height="100%">
                <form xmlns="http://www.w3.org/1999/xhtml" action="" method="get" id="formjoin6" style="display: inline;" >
                    <button type="submit" form="formjoin6" value="Submit" style="height:54px; width:54px;
                    border-radius: 27px; border: none; background-color: Transparent; outline:none;"></button>
                </form>
            </foreignObject>

            -->

             <xsl:variable name="counter" select="position()"/>
                <foreignObject x="60%" y="30%"  width="100%" height="100%">
                <form xmlns="http://www.w3.org/1999/xhtml" action="/bj/join/{blackjack/@id}/{$playerID}/{$balance}" method="POST" id="formjoin" style="display: inline;" target="hiddenFrame" >
                    <button type="submit" form="formjoin" value="Submit" style="height:80px; width:80px;
                    border-radius: 40px;">join game 1 </button>
                </form>
            </foreignObject>
            <foreignObject x="80%" y="30%"  width="100%" height="100%">
                <form xmlns="http://www.w3.org/1999/xhtml" action="/bj/join/{blackjack[position()= 2]/@id}/{$playerID}/{$balance}" method="POST" id="formjoin2" style="display: inline;" target="hiddenFrame">
                    <button type="submit" form="formjoin2" value="Submit" style="height:80px; width:80px;
                    border-radius: 40px;">join game 2 </button>
                </form>
            </foreignObject>
            
            <foreignObject x="95.85%" y="2.5%"  width="100%" height="100%" >
                <form xmlns="http://www.w3.org/1999/xhtml" action="" method="post" id="formExit" style="display: inline;"  target="hiddenFrame">
                    <button   type="submit" form="formExit" value="Submit" style="height:54px; width:54px;
                             border-radius: 27px; border: none; background-color: Transparent; outline:none;"></button>
                </form>
            </foreignObject>
        </svg>

    </xsl:template>


</xsl:stylesheet>
