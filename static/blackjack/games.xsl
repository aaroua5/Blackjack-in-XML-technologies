<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:param name="playerName"/>
    <xsl:param name="balance"/>
    <xsl:template match="casino">

        <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="100%" height="100%" viewBox="0, 0, 1800, 900">
            <xsl:variable name="playerID" select="users/player[name = $playerName]/@id"/>
            <defs>

                <linearGradient id="goldGradient" x1="0" y1="0" x2="1" y2="1"> <!-- Gold gradient used for the stroke of the buttons and tables -->
                    <stop offset="5%" stop-color="#efcf76"></stop>
                    <stop offset="33%" stop-color="#fcdd7a"></stop>
                    <stop offset="66%" stop-color="#cfba65"></stop>
                    <stop offset="100%" stop-color="#988058"></stop>
                </linearGradient>

                <filter id="inner-glow"> <!-- Filter used for the inner glow effect of the buttons -->
                    <feFlood flood-color="#09846F"/>
                    <feComposite in2="SourceAlpha" operator="out"/>
                    <feGaussianBlur stdDeviation="1" result="blur"/>
                    <feComposite operator="atop" in2="SourceGraphic"/>
                </filter>

                <g id="background" >  <!-- Background of the page -->
                    <svg width="100%" height="100%">
                        <rect x="0"  y="0" width="100%" height="100%" fill="#0F2822" />
                    </svg>
                </g>

                <g id="leader board"> <!-- Leader board table -->
                    <svg x="-499" y="45">
                        <svg id="table" width="100%" height="100%" viewBox="0 0 100 100"> <!-- Leader board table design -->
                            <rect x="30" y="4" width="49" height="79" rx="2" ry="2" fill="#095584" stroke-width="0.5" stroke="url(#goldGradient)"/>

                            <!-- Title zone -->
                            <rect x="33" y="7" width="43" height="6" rx="2" ry="2" fill="#043b5c"/>
                            <text x="54.5" y="3.5" dy="2em" fill="#fbda79" font-size="4" text-anchor="middle">✯ LEADERBOARD ✯</text>

                            <!-- Players zone -->
                            <rect x="33" y="18" width="43" height="6" rx="2" ry="2" fill="#07486e"/>

                            <rect x="33" y="26" width="43" height="6" rx="2" ry="2" fill="#07486e"/>

                            <rect x="33" y="34" width="43" height="6" rx="2" ry="2" fill="#07486e"/>

                            <rect x="33" y="42" width="43" height="6" rx="2" ry="2" fill="#07486e"/>

                            <rect x="33" y="50" width="43" height="6" rx="2" ry="2" fill="#07486e"/>

                            <rect x="33" y="58" width="43" height="6" rx="2" ry="2" fill="#07486e"/>

                            <rect x="33" y="66" width="43" height="6" rx="2" ry="2" fill="#07486e"/>

                            <rect x="33" y="74" width="43" height="6" rx="2" ry="2" fill="#07486e"/>

                        </svg>

                        <!-- Display of the top 8 players -->
                        <svg id="players" width="100%" height="100%" viewBox="0 0 100 100">
                            <text y="14.5" fill="white" font-size="4" >
                                <xsl:for-each select="users/player">
                                    <xsl:sort select="points"  order="descending" data-type="number" />

                                    <xsl:if test=" not(position() > 8)">
                                        <tspan x="35" dy="2em"><xsl:value-of select="name"></xsl:value-of> </tspan>
                                        <xsl:if test="position() != last()" >
                                            <tspan  x="75" fill="#2282bd" text-anchor="end">
                                                <xsl:value-of select="round(points -0.5)"/> ✯
                                            </tspan>
                                        </xsl:if>
                                        <xsl:if test="position() = last()" >
                                            <tspan  x="74" fill="#2282bd" text-anchor="end">
                                                <xsl:value-of select="round(points -0.5)"/> ✯
                                            </tspan>
                                        </xsl:if>
                                    </xsl:if>
                                </xsl:for-each>
                            </text>
                        </svg>

                    </svg>
                </g>

                <g id="games table"> <!-- Games table -->
                    <svg x="450" y="45">
                        <svg id="table" width="100%" height="100%" viewBox="0 0 100 100"> <!-- Games table design -->
                            <rect x="30" y="4" width="49" height="79" rx="2" ry="2" fill="#09846F" stroke-width="0.5" stroke="url(#goldGradient)"/>

                            <!-- Title zone -->
                            <rect x="33" y="7" width="43" height="6" rx="2" ry="2" fill="#035c4b"/>
                            <text x="54.5" y="3.5" dy="2em" fill="#fbda79" font-size="4" text-anchor="middle">GAMES</text>

                            <!-- Players zone -->
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

                            <rect x="33" y="66" width="34" height="6" rx="2" ry="2" fill="#076e5c"/>
                            <circle cx="73" cy="69" r="3" fill="#076e5c"></circle>

                            <rect x="33" y="74" width="34" height="6" rx="2" ry="2" fill="#076e5c"/>
                            <circle cx="73" cy="77" r="3" fill="#076e5c"></circle>
                        </svg>

                        <!-- Display of the created games -->
                        <svg id="games" width="100%" height="100%" viewBox="0 0 100 100">
                            <text y="14.5" fill="white" font-size="4" >
                                <xsl:for-each select="blackjack">
                                    <xsl:variable name="counter" select="position()"/>
                                    <tspan x="35" dy="2em">Game <xsl:value-of select="./@counter"/></tspan>
                                    <tspan  x="60" fill="#109c84"><xsl:value-of select="count(players/player)"/>/5</tspan>
                                </xsl:for-each>
                            </text>

                            <!-- Display of the triangle shape for each created game. It is used for the join button -->
                            <xsl:if test="count(blackjack) > 0" >
                                <path transform="translate(70.6 23.9) rotate(-90) scale(1.4)"
                                      d="M 1 1 L 3 1 L 2 3 z"
                                      fill="#014034"
                                />
                            </xsl:if>
                            <xsl:if test="count(blackjack) > 1" >
                                <path transform="translate(70.6 31.9) rotate(-90) scale(1.4)"
                                      d="M 1 1 L 3 1 L 2 3 z"
                                      fill="#014034"
                                />
                            </xsl:if>
                            <xsl:if test="count(blackjack) > 2" >
                                <path transform="translate(70.6 39.9) rotate(-90) scale(1.4)"
                                      d="M 1 1 L 3 1 L 2 3 z"
                                      fill="#014034"
                                />
                            </xsl:if>
                            <xsl:if test="count(blackjack) > 3" >
                                <path transform="translate(70.6 47.9) rotate(-90) scale(1.4)"
                                      d="M 1 1 L 3 1 L 2 3 z"
                                      fill="#014034"
                                />
                            </xsl:if>
                            <xsl:if test="count(blackjack) > 4" >
                                <path transform="translate(70.6 55.9) rotate(-90) scale(1.4)"
                                      d="M 1 1 L 3 1 L 2 3 z"
                                      fill="#014034"
                                />
                            </xsl:if>
                            <xsl:if test="count(blackjack) > 5" >
                                <path transform="translate(70.6 63.9) rotate(-90) scale(1.4)"
                                      d="M 1 1 L 3 1 L 2 3 z"
                                      fill="#014034"
                                />
                            </xsl:if>
                            <xsl:if test="count(blackjack) > 6" >
                                <path transform="translate(70.6 71.9) rotate(-90) scale(1.4)"
                                      d="M 1 1 L 3 1 L 2 3 z"
                                      fill="#014034"
                                />
                            </xsl:if>
                            <xsl:if test="count(blackjack) > 7" >
                                <path transform="translate(70.6 79.9) rotate(-90) scale(1.4)"
                                      d="M 1 1 L 3 1 L 2 3 z"
                                      fill="#014034"
                                />
                            </xsl:if>

                        </svg>

                    </svg>
                </g>

                <!-- Display of the text containing: Player name, balance and score -->
                <g id="message">
                    <svg id="table" width="100%" height="100%" viewBox="0 0 100 100">
                        <text x="35" y="27" fill="white" font-size="4">
                            <tspan text-anchor="middle">
                                <tspan x="50" dy="2em">Good luck, </tspan>
                                <tspan fill="#fbda79"><xsl:value-of select="$playerName"/></tspan>
                                <!-- calls the player name -->
                            </tspan>
                            <tspan text-anchor="middle">
                                <tspan  x="50" fill="white" dy="1.5em">Balance: </tspan>
                                <tspan fill="#fbda79" text-anchor="middle">$<xsl:value-of select=" round(users/player[name = $playerName]/totalmonney -0.5)"/></tspan>
                                <!-- calls the balance of the player -->
                            </tspan>
                            <tspan text-anchor="middle">
                                <tspan  x="50" fill="white" dy="1.5em">Score: </tspan>
                                <tspan fill="#fbda79" text-anchor="middle"><xsl:value-of select=" round(users/player[name = $playerName]/points - 0.5)"/> ✯</tspan>
                                <!-- calls the score of the player -->
                            </tspan>
                        </text>
                    </svg>
                </g>

                <!-- Button design -->
                <svg id="buttons" width="100%" height="100%" viewBox="0 0 100 100">

                    <!-- New Game button. Shows only if there are less than 8 games -->
                    <xsl:if test="not(count(blackjack) > 7)">
                        <svg id="new game" x="0" y="0">
                            <rect x="40.75" y="55" width="18.5" height="8" rx="2" ry="2" fill="#091b17" stroke-width="0.5" stroke="url(#goldGradient)"/>
                            <text x="50" y="59" font-family="Arial" font-size="3" text-anchor="middle" alignment-baseline="central"
                                  fill="#EFCB68">NEW GAME</text>
                        </svg>
                    </xsl:if>

                    <!-- Random game button. Shows only if there are more than one game -->
                    <xsl:if test="count(blackjack) > 0">
                        <svg id="random game" x="0" y="0">
                            <rect x="37.75" y="66" width="24.5" height="8" rx="2" ry="2" fill="#091b17" stroke-width="0.5" stroke="url(#goldGradient)"/>
                            <text x="50" y="70" font-family="Arial" font-size="3" text-anchor="middle" alignment-baseline="central"
                                  fill="#EFCB68">RANDOM GAME</text>
                        </svg>
                    </xsl:if>

                    <!-- Exit button -->
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

            </defs>

            <use href="#background" width="100%" height="100%"/>
            <use href="#games table" width="100%" height="100%"/>
            <use href="#leader board" width="100%" height="100%"/>
            <use href="#message" width="100%" height="100%"/>
            <use href="#buttons" width="100%" height="100%"/>

            <!-- Buttons: -->

            <!-- New game button -->
            <xsl:if test="not(count(blackjack) > 7)">
                <foreignObject x="45.2%" y="54.7%" width="100%" height="100%" >
                    <form xmlns="http://www.w3.org/1999/xhtml" action="/bj/newGame" method="POST" id="formMenu" style="display: inline;" target ="hiddenFrame" >
                        <button type="submit" form="formMenu" value="Submit" style="height:77px; width:170px; border-radius: 20px;  background-color: Transparent;"></button>
                    </form>
                </foreignObject>
            </xsl:if>

            <!-- Random game button -->
            <xsl:if test="count(blackjack) > 0">
                <foreignObject x="43.8%" y="65.7%" width="100%" height="100%" >
                    <form xmlns="http://www.w3.org/1999/xhtml" action="/bj/random/{$playerName}/{$balance}" method="post" id="formRandom" style="display: inline;"  target="hiddenFrame">
                        <button type="submit" form="formRandom" value="Submit" style="height:77px; width:225px; border-radius: 20px; border: none; background-color: Transparent; outline:none;"></button>
                    </form>
                </foreignObject>
            </xsl:if>

            <!-- Join Game 1 button -->
            <xsl:if test="blackjack[position() = 1]">
                <xsl:variable name="id" select="blackjack[position() = 1]/@id"/>
                <foreignObject x="85%" y="26.3%"  width="100%" height="100%">
                    <form xmlns="http://www.w3.org/1999/xhtml" action="/bj/join/{$id}/{$playerName}/{$balance}" method="POST" id="formjoin1" style="display: inline;" target="hiddenFrame" >
                        <button type="submit" form="formjoin1" value="Submit" style="height:54px; width:54px; border-radius: 27px; border: none; background-color: Transparent; outline:none;"></button>
                    </form>
                </foreignObject>
            </xsl:if>

            <!-- Join Game 2 button -->
            <xsl:if test="blackjack[position() = 2]">
                <xsl:variable name="id" select="blackjack[position() = 2]/@id"/>
                <foreignObject x="85%" y="34.3%"  width="100%" height="100%">
                    <form xmlns="http://www.w3.org/1999/xhtml" action="/bj/join/{$id}/{$playerName}/{$balance}" method="POST" id="formjoin2" style="display: inline;"  target="hiddenFrame">
                        <button type="submit" form="formjoin2" value="Submit" style="height:54px; width:54px; border-radius: 27px; border: none; background-color: Transparent; outline:none;"></button>
                    </form>
                </foreignObject>
            </xsl:if>

            <!-- Join Game 3 button -->
            <xsl:if test="blackjack[position() = 3]">
                <xsl:variable name="id" select="blackjack[position() = 3]/@id"/>
                <foreignObject x="85%" y="42.3%"  width="100%" height="100%">
                    <form xmlns="http://www.w3.org/1999/xhtml" action="/bj/join/{$id}/{$playerName}/{$balance}" method="POST" id="formjoin3" style="display: inline;" target="hiddenFrame" >
                        <button type="submit" form="formjoin3" value="Submit" style="height:54px; width:54px; border-radius: 27px; border: none; background-color: Transparent; outline:none;"></button>
                    </form>
                </foreignObject>
            </xsl:if>

            <!-- Join Game 4 button -->
            <xsl:if test="blackjack[position() = 4]">
                <xsl:variable name="id" select="blackjack[position() = 4]/@id"/>
                <foreignObject x="85%" y="50.3%"  width="100%" height="100%">
                    <form xmlns="http://www.w3.org/1999/xhtml" action="/bj/join/{$id}/{$playerName}/{$balance}" method="POST" id="formjoin4" style="display: inline;"  target="hiddenFrame">
                        <button type="submit" form="formjoin4" value="Submit" style="height:54px; width:54px; border-radius: 27px; border: none; background-color: Transparent; outline:none;"></button>
                    </form>
                </foreignObject>
            </xsl:if>

            <!-- Join Game 5 button -->
            <xsl:if test="blackjack[position() = 5]">
                <xsl:variable name="id" select="blackjack[position() = 5]/@id"/>
                <foreignObject x="85%" y="58.3%"  width="100%" height="100%">
                    <form xmlns="http://www.w3.org/1999/xhtml" action="/bj/join/{$id}/{$playerName}/{$balance}" method="POST" id="formjoin5" style="display: inline;" target="hiddenFrame" >
                        <button type="submit" form="formjoin5" value="Submit" style="height:54px; width:54px; border-radius: 27px; border: none; background-color: Transparent; outline:none;"></button>
                    </form>
                </foreignObject>
            </xsl:if>

            <!-- Join Game 6 button -->
            <xsl:if test="blackjack[position() = 6]">
                <xsl:variable name="id" select="blackjack[position() = 6]/@id"/>
                <foreignObject x="85%" y="66.3%"  width="100%" height="100%">
                    <form xmlns="http://www.w3.org/1999/xhtml" action="/bj/join/{$id}/{$playerName}/{$balance}" method="POST" id="formjoin6" style="display: inline;" target="hiddenFrame">
                        <button type="submit" form="formjoin6" value="Submit" style="height:54px; width:54px; border-radius: 27px; border: none; background-color: Transparent; outline:none;"></button>
                    </form>
                </foreignObject>
            </xsl:if>

            <!-- Join Game 7 button -->
            <xsl:if test="blackjack[position() = 7]">
                <xsl:variable name="id" select="blackjack[position() = 7]/@id"/>
                <foreignObject x="85%" y="74.3%"  width="100%" height="100%">
                    <form xmlns="http://www.w3.org/1999/xhtml" action="/bj/join/{$id}/{$playerName}/{$balance}" method="POST" id="formjoin7" style="display: inline;" target="hiddenFrame">
                        <button type="submit" form="formjoin7" value="Submit" style="height:54px; width:54px; border-radius: 27px; border: none; background-color: Transparent; outline:none;"></button>
                    </form>
                </foreignObject>
            </xsl:if>

            <!-- Join Game 8 button -->
            <xsl:if test="blackjack[position() = 8]">
                <xsl:variable name="id" select="blackjack[position() = 8]/@id"/>
                <foreignObject x="85%" y="82.3%"  width="100%" height="100%">
                    <form xmlns="http://www.w3.org/1999/xhtml" action="/bj/join/{$id}/{$playerName}/{$balance}" method="POST" id="formjoin8" style="display: inline;" target="hiddenFrame">
                        <button type="submit" form="formjoin8" value="Submit" style="height:54px; width:54px; border-radius: 27px; border: none; background-color: Transparent; outline:none;"></button>
                    </form>
                </foreignObject>
            </xsl:if>

            <!-- Exit button -->
            <xsl:variable name="counter" select="position()"/>
            <foreignObject x="95.85%" y="2.5%"  width="100%" height="100%">
                <form xmlns="http://www.w3.org/1999/xhtml" action="/bj/menu/{$playerID}" method="get" id="formExit" style="display: inline;">
                    <button   type="submit" form="formExit" value="Submit" style="height:54px; width:54px; border-radius: 27px; border: none; background-color: Transparent; outline:none;"></button>
                </form>
            </foreignObject>

        </svg>

    </xsl:template>

</xsl:stylesheet>
