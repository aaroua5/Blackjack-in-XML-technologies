<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:template match="blackjack">

        <xsl:variable name="hitLink" select="bj/hit"/>
        <xsl:variable name="id" select= "@id"/>
        <xsl:variable name = "activePlayer" select="./playerTurn"/>

        <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="100%" height="100%" viewBox="0, 0, 1800, 900">

            <defs>

                <g id="background">
                    <svg width="100%" height="100%">
                        <rect x="0"  y="0" width="100%" height="100%" fill="#0F2822" />
                    </svg>
                </g>

                <g id="table" >
                    <radialGradient id="gradTable" cx="50%" cy="50%" r="50%" fx="50%" fy="50%">
                        <stop offset="50%" stop-color="#09846F" />
                        <stop offset="95%" stop-color="#026A54" />
                    </radialGradient>

                    <linearGradient id="goldGradient" x1="0" y1="0" x2="1" y2="1">
                        <stop offset="5%" stop-color="#efcf76"></stop>
                        <stop offset="33%" stop-color="#fcdd7a"></stop>
                        <stop offset="66%" stop-color="#cfba65"></stop>
                        <stop offset="100%" stop-color="#988058"></stop>
                    </linearGradient>

                    <svg width="100%" height="100%" viewBox="0 0 100 100">

                        <circle cx="50" cy="-95" r="181" fill="#503D2D"  filter="url(#outer-glow)"/>
                        <circle cx="50" cy="-95" r="178" fill="url(#gradTable)" filter="url(#inner-shadow)"/>
                        <circle cx="-30%" cy="45" r="8" fill="#0F2822"/>
                        <circle r="8" cx="-30" cy="45" class="external-circle" stroke-width="0.3" fill="none" stroke="#80A323"></circle>
                        <circle cx="10" cy="57" r="8" fill="#0F2822"/>
                        <circle r="8" cx="10" cy="57" class="external-circle" stroke-width="0.3" fill="none" stroke="#80A323"></circle>
                        <circle cx="50" cy="63" r="8" fill="#0F2822"/>
                        <circle r="8" cx="50" cy="63" class="external-circle" stroke-width="0.3" fill="none" stroke="#80A323"></circle>
                        <circle cx="90" cy="57" r="8" fill="#0F2822"/>
                        <circle r="8" cx="90" cy="57" class="external-circle" stroke-width="0.3" fill="none" stroke="#80A323"></circle>
                        <circle cx="130" cy="45" r="8" fill="#0F2822"/>
                        <circle r="8" cx="130" cy="45" class="external-circle" stroke-width="0.3" fill="none" stroke="#80A323"></circle>

                        <xsl:if test="playerTurn = '5'">
                            <text x="-32" y="28" font-size="4" fill="#80A323">
                                ▼
                            </text>
                        </xsl:if>

                        <xsl:if test="playerTurn = '4'">
                            <text x="8" y="40" font-size="4" fill="#80A323">
                                ▼
                            </text>
                        </xsl:if>

                        <xsl:if test="playerTurn = '3'">
                            <text x="48" y="46" font-size="4" fill="#80A323">
                                ▼
                            </text>
                        </xsl:if>

                        <xsl:if test="playerTurn = '2'">
                            <text x="88" y="40" font-size="4" fill="#80A323">
                                ▼
                            </text>
                        </xsl:if>

                        <xsl:if test="playerTurn = '1'">
                            <text x="128" y="28" font-size="4" fill="#80A323">
                                ▼
                            </text>
                        </xsl:if>

                        <svg x="-10" y="6">
                            <path id="MyPath" fill="none"
                                  d="M10 10 C 20 20, 40 20, 50 10" transform="scale(2)"/>
                            <text font-family="Liberation Sans" font-size="7.6" fill="#80A323">
                                <textPath href="#MyPath">
                                    BLACKJACK PAYS 3 TO 2
                                </textPath>
                            </text>
                        </svg>

                    </svg>

                </g>

                <g id="buttons">
                    <svg width="100%" height="100%" viewBox="0 0 100 100">
                        <circle cx="100" cy="91" r="6" fill="black" stroke-width="0.8" stroke="url(#goldGradient)" filter="url(#f2)"/>
                        <circle cx="100" cy="91" r="5.3" fill="#060C1A" filter="url(#inner-glow)" />
                        <text x="100" y="91" font-family="Arial" font-size="3" text-anchor="middle" alignment-baseline="central"
                              fill="#fcdd7a">HIT</text>

                        <circle cx="120" cy="87" r="6.7" fill="black" stroke-width="0.8" stroke="url(#goldGradient)" filter="url(#f2)"/>
                        <circle cx="120" cy="87" r="6" fill="#060C1A" filter="url(#inner-glow)"/>
                        <text x="120" y="87" font-family="Arial" font-size="3" text-anchor="middle" alignment-baseline="central"
                              fill="#fcdd7a">STAND</text>

                        <circle cx="140" cy="80" r="7.4" fill="black" stroke-width="0.8" stroke="url(#goldGradient)" filter="url(#f2)"/>
                        <circle cx="140" cy="80" r="6.7" fill="#060C1A" filter="url(#inner-glow)"/>
                        <text x="140" y="80" font-family="Arial" font-size="3" text-anchor="middle" alignment-baseline="central"
                              fill="#fcdd7a">DOUBLE</text>

                    </svg>
                </g>

                <g id="bet">
                    <svg id="bet score" width="100%" height="100%" viewBox="0 0 100 100">

                        <rect x="-34" y="54.5" width="8" height="4" rx="0.8" ry="0.8" fill="#0F2822" stroke-width="0.3" stroke="#80A323"/>
                        <rect x="6" y="66.5" width="8" height="4" rx="0.8" ry="0.8" fill="#0F2822" stroke-width="0.3" stroke="#80A323"/>
                        <rect x="46" y="72.5" width="8" height="4" rx="0.8" ry="0.8" fill="#0F2822" stroke-width="0.3" stroke="#80A323"/>
                        <rect x="86" y="66.5" width="8" height="4" rx="0.8" ry="0.8" fill="#0F2822" stroke-width="0.3" stroke="#80A323"/>
                        <rect x="126" y="54.5" width="8" height="4" rx="0.8" ry="0.8" fill="#0F2822" stroke-width="0.3" stroke="#80A323"/>

                        <text x="-26.7" y="57.5" font-family="Arial" font-size="3" fill="#EBEBEB" text-anchor="end"> <xsl:value-of select="players/player[@id = 5]/currentBet"/>$</text>
                        <text x="13.3" y="69.5" font-family="Arial" font-size="3" fill="#EBEBEB" text-anchor="end"> <xsl:value-of select="players/player[@id = 4]/currentBet"/>$</text>
                        <text x="53.3" y="75.5" font-family="Arial" font-size="3" fill="#EBEBEB" text-anchor="end"><xsl:value-of select="players/player[@id = 3]/currentBet"/>$</text>
                        <text x="93.3" y="69.5" font-family="Arial" font-size="3" fill="#EBEBEB" text-anchor="end"> <xsl:value-of select="players/player[@id = 2]/currentBet"/>$</text>
                        <text x="133.3" y="57.5" font-family="Arial" font-size="3" fill="#EBEBEB" text-anchor="end"><xsl:value-of select="players/player[@id = 1]/currentBet"/>$</text>

                    </svg>

                    <svg id="bet buttons" width="100%" height="100%" viewBox="0 0 100 100">

                        <rect x="71.5" y="89" width="9" height="9" rx="4.5" ry="4.5" stroke-width="0.8" stroke="url(#goldGradient)" filter="url(#f2)"/>
                        <rect x="72" y="89.5" width="8" height="8" rx="4" ry="4" fill="#060C1A" filter="url(#inner-glow)"/>
                        <text x="76.2" y="93.5" font-family="Arial" font-size="3" text-anchor="middle" alignment-baseline="central"
                              fill="#fcdd7a">▶</text>

                        <rect x="51.5" y="89" width="17" height="9" rx="2.5" ry="2.5" stroke-width="0.8" stroke="url(#goldGradient)" filter="url(#f2)"/>
                        <rect x="52" y="89.5" width="16" height="8" rx="2" ry="2" fill="#060C1A" filter="url(#inner-glow)"/>
                        <text x="60" y="93.5" font-family="Arial" font-size="3" text-anchor="middle" alignment-baseline="central"
                              fill="#fcdd7a">DEAL</text>

                        <rect x="31.5" y="89" width="17" height="9" rx="2.5" ry="2.5" stroke-width="0.8" stroke="url(#goldGradient)" filter="url(#f2)"/>
                        <rect x="32" y="89.5" width="16" height="8" rx="2" ry="2" fill="#060C1A" filter="url(#inner-glow)"/>
                        <text x="40" y="93.5" font-family="Arial" font-size="3" text-anchor="middle" alignment-baseline="central"
                              fill="#fcdd7a">CLEAR</text>

                        <rect x="19.5" y="89" width="9" height="9" rx="4.5" ry="4.5" stroke-width="0.8" stroke="url(#goldGradient)" filter="url(#f2)"/>
                        <rect x="20" y="89.5" width="8" height="8" rx="4" ry="4" fill="#060C1A" filter="url(#inner-glow)"/>
                        <text x="23.8" y="93.5" font-family="Arial" font-size="3" text-anchor="middle" alignment-baseline="central"
                              fill="#fcdd7a">◀</text>
                    </svg>

                    <svg id="messages" width="100%" height="100%" viewBox="0 0 100 100">

                        <rect id="rect99" x="-47" y="3" width="55" height="12" rx="0.8" ry="0.8" fill="#0F2822" stroke-width="0.3" stroke="#80A323"/>
                        <text x="-45" y="7" font-family="Arial" font-size="3" fill="#EBEBEB" text-anchor="start">
                             <xsl:value-of select="event" />
                        </text>

                    </svg>

                    <svg id="bet chips" width="100%" height="100%" viewBox="0 0 100 100">

                    </svg>

                </g>

                <g id="cards" transform="scale(0.5)">

                    <xsl:apply-templates select="dealer"/>
                    <xsl:apply-templates select="players/player"/>
                </g>
                <defs>
                    <filter id="f1" x="0" y="0" width="200%" height="200%" filterUnits="userSpaceOnUse">
                        <feOffset result="offOut" in="SourceAlpha" dx="4" dy="4" />
                        <feGaussianBlur result="blurOut" in="offOut" stdDeviation="10" />
                        <feBlend in="SourceGraphic" in2="blurOut" mode="normal" />
                    </filter>
                    <filter id="f2" x="0" y="0" width="200%" height="200%" filterUnits="userSpaceOnUse">
                        <feOffset result="offOut" in="SourceAlpha" dx="2" dy="2" />
                        <feGaussianBlur result="blurOut" in="offOut" stdDeviation="2" />
                        <feBlend in="SourceGraphic" in2="blurOut" mode="normal" />
                    </filter>
                    <filter id="inner-shadow">
                        <feFlood flood-color="black"/>
                        <feComposite in2="SourceAlpha" operator="out"/>
                        <feGaussianBlur stdDeviation="2" result="blur"/>
                        <feComposite operator="atop" in2="SourceGraphic"/>
                    </filter>
                    <filter id="inner-glow">
                        <feFlood flood-color="#09846F"/>
                        <feComposite in2="SourceAlpha" operator="out"/>
                        <feGaussianBlur stdDeviation="1" result="blur"/>
                        <feComposite operator="atop" in2="SourceGraphic"/>
                    </filter>
                    <filter id="outer-glow" height="300%" width="300%" x="-75%" y="-75%">
                        <feMorphology operator="dilate" radius="2" in="SourceAlpha" result="thicken" />
                        <feGaussianBlur in="thicken" stdDeviation="3" result="blurred" />
                        <feFlood flood-color="black" result="glowColor" />
                        <feComposite in="glowColor" in2="blurred" operator="in" result="softGlow_colored" />
                        <feMerge>
                            <feMergeNode in="softGlow_colored"/>
                            <feMergeNode in="SourceGraphic"/>
                        </feMerge>
                    </filter>
                </defs>

            </defs>
            <use href="#background" width="100%" height="100%"/>
            <use href="#table"/>
            <use href="#buttons"/>
            <use href="#bet"/>
            <use href="#messages"/>


            <xsl:if test="step = 'bet'">

                <foreignObject x="2%" y="78%" width="100%" height="100%" >
                    <form xmlns="http://www.w3.org/1999/xhtml" action="/bj/bet/{$id}/1" method="post" id="form1" style="display: inline;" >
                        <button type="submit" form="form1" value="Submit" style="height:80px; width:80px;
                    border-radius: 40px;">1</button>
                    </form>
                </foreignObject>

                <foreignObject x="8%" y="78%" width="100%" height="100%" >
                    <form xmlns="http://www.w3.org/1999/xhtml" action="/bj/bet/{$id}/5"  method="post" id="form5" style="display: inline;" >
                        <button type="submit" form="form5" value="Submit" style="height:80px; width:80px;
                    border-radius: 40px;">5</button>
                    </form>
                </foreignObject>

                <foreignObject x="14%" y="78%" width="100%" height="100%" >
                    <form xmlns="http://www.w3.org/1999/xhtml" action="/bj/bet/{$id}/10"  method="post" id="form10" style="display: inline;" >
                        <button type="submit" form="form10" value="Submit" style="height:80px; width:80px;
                    border-radius: 40px;">10</button>
                    </form>
                </foreignObject>

                <foreignObject x="20%" y="78%" width="100%" height="100%" >
                    <form xmlns="http://www.w3.org/1999/xhtml" action="/bj/bet/{$id}/25" method="post" id="form25" style="display: inline;" >
                        <button type="submit" form="form25" value="Submit" style="height:80px; width:80px;
                    border-radius: 40px;">25</button>
                    </form>
                </foreignObject>

                <foreignObject x="26%" y="78%" width="100%" height="100%" >
                    <form xmlns="http://www.w3.org/1999/xhtml" action="/bj/bet/{$id}/50" method="post" id="form50" style="display: inline;" >
                        <button type="submit" form="form50" value="Submit" style="height:80px; width:80px;
                    border-radius: 40px;">50</button>
                    </form>
                </foreignObject>

                <foreignObject x="34.5%" y="88.5%" width="100%" height="100%" >
                    <form xmlns="http://www.w3.org/1999/xhtml" action="/bj/nextBet/{$id}" method="post" id="formLeft" style="display: inline;" >
                        <button type="submit" form="formLeft" value="Submit" style="height:90px; width:90px;
                    border-radius: 45px; border: none; background-color: Transparent; outline:none;">︎︎</button>
                    </form>
                </foreignObject>

                <foreignObject x="40.5%" y="88.7%" width="100%" height="100%" >
                    <form xmlns="http://www.w3.org/1999/xhtml" action="/bj/clear/{$id}" method="post" id="formClear" style="display: inline;" >
                        <button type="submit" form="formClear" value="Submit" style="height:86px; width:160px;
                    border-radius: 25px; border: none; background-color: Transparent; outline:none;"></button>
                    </form>
                </foreignObject>

                <foreignObject x="50.5%" y="88.7%" width="100%" height="100%" >
                    <form xmlns="http://www.w3.org/1999/xhtml" action="/ttt/newDeal" method="post" id="formDeal" style="display: inline;" >
                        <button type="submit" form="formRebet" value="Submit" style="height:86px; width:160px;
                    border-radius: 25px; border: none; background-color: Transparent; outline:none;"></button>
                    </form>
                </foreignObject>

                <foreignObject x="60.5%" y="88.5%" width="100%" height="100%" >
                    <form xmlns="http://www.w3.org/1999/xhtml" action="/ttt/newRound" method="post" id="formRight" style="display: inline;" >
                        <button type="submit" form="formRight" value="Submit" style="height:90px; width:90px;
                    border-radius: 45px; border: none; background-color: Transparent; outline:none;">︎</button>
                    </form>
                </foreignObject>

            </xsl:if>


            <xsl:if test="step ='GameOver'">
                <foreignObject x="48%" y="88%" width="100%" height="100%" >
                    <form xmlns="http://www.w3.org/1999/xhtml" action="/bj/checkScores/{$id}" method="get" id="formRebet" style="display: inline;" >
                        <button type="submit" form="formRebet" value="Submit" style="height:80px; width:80px;
                    border-radius: 5px;">newRound</button>
                    </form>
                </foreignObject>
            </xsl:if>

            <foreignObject x="71.9%" y="84.7%"  width="100%" height="100%" >
                <form xmlns="http://www.w3.org/1999/xhtml" action="/bj/hit/{$id}" method="post" id="formHit" style="display: inline;" >
                    <button   type="submit" form="formHit" value="Submit" style="height:114px; width:114px;
                     border-radius: 57px; border: none; background-color: Transparent; outline:none;"></button>
                </form>
            </foreignObject>

            <foreignObject x="81.5%" y="80%"  width="100%" height="100%" >
                <form xmlns="http://www.w3.org/1999/xhtml" action="/bj/stand/{$id}" method="post" id="formStand" style="display: inline;" >
                    <button type="submit" form="formStand" value="Submit" style="height:126px; width:126px;
                    border-radius: 63px; border: none; background-color: Transparent; outline:none;"></button>
                </form>
            </foreignObject>


            <foreignObject x="91%" y="72.1%" width="100%" height="100%" >
                <form xmlns="http://www.w3.org/1999/xhtml" action="/ttt/newRound" method="post" id="formDouble" style="display: inline;" >
                    <button type="submit" form="formDouble" value="Submit" style="height:140px; width:140px;
                    border-radius: 70px; border: none; background-color: Transparent; outline:none;"></button>
                </form>
            </foreignObject>

            <use href="#cards"/>


        </svg>


    </xsl:template>

    <xsl:template match="dealer">

        <xsl:value-of select ="name"/>
        <xsl:variable name="totalNumberCards" select="count(./cards/card)"/>

        <xsl:for-each select="./cards/card">
            <xsl:variable name="counter" select="position() - 1"/>

            <svg x="{1708+(($counter)-1)*40-(($totalNumberCards)-1)*20}" y="150">
                <xsl:call-template name="playerCard"/>
            </svg>

        </xsl:for-each>
    </xsl:template>

    <xsl:template match="player">
        <xsl:value-of select ="name"/>  |||

        <xsl:value-of select="totalmonney"/>
        <xsl:variable name="totalNumberCards" select="count(./cards/card)"/>

        <xsl:if test="@id='1'">
            <text x="-27" y="58" font-size="4" fill="#80A323" text-anchor="end"><xsl:value-of select="currentBet"/></text>

            <xsl:for-each select="./cards/card">
                <xsl:variable name="counter" select="position() - 1"/>

                <svg x="{3146-($counter)*40+(($totalNumberCards)-1)*20}" y="{600 - ($counter)*15}">
                    <xsl:call-template name="playerCard"/>
                </svg>

            </xsl:for-each>

        </xsl:if>



        <xsl:if test="@id='2'">

            <xsl:for-each select="./cards/card">
                <xsl:variable name="counter" select="position() - 1"/>

                <svg x="{2425-($counter)*40+(($totalNumberCards)-1)*20}" y="{810 - ($counter)*15}">
                    <xsl:call-template name="playerCard"/>
                </svg>
            </xsl:for-each>


        </xsl:if>

        <xsl:if test="@id='3'">
            <xsl:for-each select="./cards/card">
                <xsl:variable name="counter" select="position() - 1"/>

                <svg x="{1708-($counter)*40+(($totalNumberCards)-1)*20}" y="{920 - ($counter)*15}">
                    <xsl:call-template name="playerCard"/>
                </svg>
            </xsl:for-each>

        </xsl:if>

        <xsl:if test="@id='4'">

            <xsl:for-each select="./cards/card">
                <xsl:variable name="counter" select="position() - 1"/>

                <svg x="{985-($counter)*40+(($totalNumberCards)-1)*20}" y="{810 - ($counter)*15}">
                    <xsl:call-template name="playerCard"/>
                </svg>



            </xsl:for-each>

        </xsl:if>
        <xsl:if test="@id='5'">

            <xsl:for-each select="./cards/card">

                <xsl:variable name="counter" select="position() - 1"/>

                <svg x="{265-($counter)*40+(($totalNumberCards)-1)*20}" y="{600 - ($counter)*15}">
                    <xsl:call-template name="playerCard"/>
                </svg>

            </xsl:for-each>


        </xsl:if>
    </xsl:template>
    <xsl:template name="playerCard" match="card">
        <xsl:variable name="number" select="card/card_number"/>
        <xsl:variable name="color" select="color"/>

        <xsl:if test="card_number='A'">

            <svg width="225" height="340" filter="url(#f1)">
                <svg width="185" height="300">
                    <rect width="185" height="300" rx="10" ry="10" fill="white"/>
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="18" y="20" font-size ="25" fill="{$color}" >A</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)" x="-167" y="-280" font-size ="25" fill="{$color}">A</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="167" y="20" font-size ="25" fill="{$color} ">A</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)" x="-18" y="-280" font-size="25" fill="{$color}">A</text>
                    <text class="cardTexth "  x="91%" y="18%" dominant-baseline="middle" text-anchor="middle" font-size="18" fill="{$color}">  <xsl:value-of select="card_type"/></text>
                    <text class="cardTexth "  x="9%" y="18%" dominant-baseline="middle" text-anchor="middle" font-size="18" fill="{$color}"> <xsl:value-of select="card_type"/></text>
                    <text class="cardTexth "  x="-91%" y="-82%"  dominant-baseline="middle" text-anchor="middle" transform="scale(-1,-1)" font-size="18" fill="{$color}"> <xsl:value-of select="card_type"/></text>
                    <text class="cardTexth "  x="-9%" y="-82%"  dominant-baseline="middle" text-anchor="middle" transform="scale(-1,-1)" font-size="18" fill="{$color}"> <xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="50%" y="55%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size="50"> <xsl:value-of select="card_type"/></text>
                </svg>
            </svg>

        </xsl:if>
        <xsl:if test="card_number='2'">
            <svg width="225" height="340" filter="url(#f1)">
                <svg width="185" height="300">
                    <rect width="185" height="300" rx="10" ry="10" fill="white"/>
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="18" y="20"  fill="{$color}" font-size ="25">2</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)" x="-167" y="-280"  fill="{$color}" font-size ="25">2</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="167" y="20" fill="{$color}" font-size ="25">2</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)" x="-18" y="-280"  fill="{$color}" font-size ="25" >2</text>
                    <text class="cardTexth "  x="91%" y="18%" dominant-baseline="middle" text-anchor="middle"  fill="{$color}" font-size ="18"><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth "  x="9%" y="18%" dominant-baseline="middle" text-anchor="middle"  fill="{$color}" font-size ="18"><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth "  x="-91%" y="-82%"  fill="{$color}" dominant-baseline="middle" text-anchor="middle" transform="scale(-1,-1)" font-size ="18"><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth "  x="-9%" y="-82%"  fill="{$color}" dominant-baseline="middle" text-anchor="middle" transform="scale(-1,-1)" font-size ="18"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="50%" y="30%" dominant-baseline="middle" text-anchor="middle"  fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="50%" y="80%" dominant-baseline="middle" text-anchor="middle"  fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                </svg>
            </svg>

        </xsl:if>
        <xsl:if test="card_number='3'">

            <svg width="225" height="340" filter="url(#f1)">
                <svg width="185" height="300">
                    <rect width="185" height="300" rx="10" ry="10" fill="white"/>
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="18" y="20" font-size ="25" fill="{$color}">3</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)"
                          x="-167" y="-280" font-size ="25" fill="{$color}">3</text>
                    <text class="cardTexth "  x="91%" y="18%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="18"><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth "  x="9%" y="18%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="18"><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth "  x="-91%" y="-82%" fill="{$color}" dominant-baseline="middle" text-anchor="middle" transform="scale(-1,-1)" font-size ="18"><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth "  x="-9%" y="-82%" fill="{$color}" dominant-baseline="middle" text-anchor="middle" transform="scale(-1,-1)" font-size ="18"><xsl:value-of select="card_type"/></text>
                    <text class="cardText"  text-anchor="middle" dy="0.3em" x="167" y="20" font-size ="25" fill="{$color}" >3</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)" x="-18" y="-280" font-size ="25" fill="{$color}">3</text>
                    <text class="cardTextBig "  x="50%" y="30%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="50%" y="55%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="50%" y="80%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                </svg>
            </svg>

        </xsl:if>

        <xsl:if test="card_number='4'">
            <svg width="225" height="340" filter="url(#f1)">
                <svg width="185" height="300">
                    <rect width="185" height="300" rx="10" ry="10" fill="white"/>
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="18" y="20" fill="{$color}" font-size ="25" >4</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)" x="-167" y="-280" fill="{$color}" font-size ="25" >4</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="167" y="20" fill="{$color}" font-size ="25" >4</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)" x="-18" y="-280" fill="{$color}" font-size ="25" >4</text>
                    <text class="cardTexth "  x="91%" y="18%" dominant-baseline="middle" text-anchor="middle"  fill="{$color}" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth "  x="9%" y="18%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="18"  ><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth "  x="-91%" y="-82%" fill="{$color}" dominant-baseline="middle" text-anchor="middle" transform="scale(-1,-1)" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth "  x="-9%" y="-82%" fill="{$color}" dominant-baseline="middle" text-anchor="middle" transform="scale(-1,-1)" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="33%" y="30%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="33%" y="80%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="66%" y="30%" dominant-baseline="middle" text-anchor="middle"  fill="{$color}" font-size ="50" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="66%" y="80%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50" ><xsl:value-of select="card_type"/></text>
                </svg>
            </svg>
        </xsl:if>
        <xsl:if test="card_number='5'">
            <svg width="225" height="340" filter="url(#f1)">
                <svg width="185" height="300">
                    <rect width="185" height="300" rx="10" ry="10" fill="white"/>
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="18" y="20" fill="{$color}" font-size ="25" >5</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)" x="-167" y="-280" fill="{$color}" font-size ="25" >5</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="167" y="20" fill="{$color}" font-size ="25" >5</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)" x="-18" y="-280" fill="{$color}" font-size ="25" >5</text>
                    <text class="cardTexth "  x="91%" y="18%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth "  x="9%" y="18%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth "  x="-91%" y="-82%" fill="{$color}" dominant-baseline="middle" text-anchor="middle" transform="scale(-1,-1)" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth "  x="-9%" y="-82%" fill="{$color}" dominant-baseline="middle" text-anchor="middle" transform="scale(-1,-1)" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="33%" y="30%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="33%" y="80%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="66%" y="30%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="66%" y="80%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="50%" y="55%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50" ><xsl:value-of select="card_type"/></text>
                </svg>
            </svg>
        </xsl:if>
        <xsl:if test="card_number='6'">
            <svg width="225" height="340" filter="url(#f1)">
                <svg width="185" height="300">
                    <rect width="185" height="300" rx="10" ry="10" fill="white"/>
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="18" y="20" fill="{$color}" font-size ="25" >6</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)" x="-167" y="-280" fill="{$color}" font-size ="25" >6</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="167" y="20" fill="{$color}" font-size ="25" >6</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)" x="-18" y="-280" fill="{$color}" font-size ="25" >6</text>
                    <text class="cardTexth "  x="91%" y="18%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth "  x="9%" y="18%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth "  x="-91%" y="-82%" fill="{$color}" dominant-baseline="middle" text-anchor="middle" transform="scale(-1,-1)" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth "  x="-9%" y="-82%" fill="{$color}" dominant-baseline="middle" text-anchor="middle" transform="scale(-1,-1)" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="33%" y="30%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="33%" y="55%" dominant-baseline="middle" text-anchor="middle"  fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="33%" y="80%" dominant-baseline="middle" text-anchor="middle"  fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="66%" y="30%" dominant-baseline="middle" text-anchor="middle"  fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="66%" y="55%" dominant-baseline="middle" text-anchor="middle"  fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="66%" y="80%" dominant-baseline="middle" text-anchor="middle"  fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                </svg>
            </svg>
        </xsl:if>
        <xsl:if test="card_number='7'">
            <svg width="225" height="340" filter="url(#f1)">
                <svg width="185" height="300">
                    <rect width="185" height="300" rx="10" ry="10" fill="white"/>
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="18" y="20" fill="{$color}" font-size ="25" >7</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)" x="-167" y="-280" fill="{$color}" font-size ="25" >7</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="167" y="20" fill="{$color}" font-size ="25" >7</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)" x="-18" y="-280" fill="{$color}" font-size ="25" >7</text>
                    <text class="cardTexth "  x="91%" y="18%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth "  x="9%" y="18%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth "  x="-91%" y="-82%" fill="{$color}" dominant-baseline="middle" text-anchor="middle" transform="scale(-1,-1)" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth "  x="-9%" y="-82%" fill="{$color}" dominant-baseline="middle" text-anchor="middle" transform="scale(-1,-1)" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="33%" y="30%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="33%" y="55%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="33%" y="80%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="66%" y="30%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="66%" y="55%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="66%" y="80%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="49.5%" y="42.5%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                </svg>
            </svg>
        </xsl:if>
        <xsl:if test="card_number='8'">
            <svg width="225" height="340" filter="url(#f1)">
                <svg width="185" height="300">
                    <rect width="185" height="300" rx="10" ry="10" fill="white"/>
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="18" y="20" fill="{$color}" font-size ="25" >8</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)" x="-167" y="-280" fill="{$color}" font-size ="25" >8</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="167" y="20" fill="{$color}" font-size ="25" >8</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)" x="-18" y="-280" fill="{$color}" font-size ="25" >8</text>
                    <text class="cardTexth "  x="91%" y="18%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth "  x="9%" y="18%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth "  x="-91%" y="-82%" fill="{$color}" dominant-baseline="middle" text-anchor="middle" transform="scale(-1,-1)" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth "  x="-9%" y="-82%" fill="{$color}" dominant-baseline="middle" text-anchor="middle" transform="scale(-1,-1)" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="33%" y="30%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="33%" y="55%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="33%" y="80%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="66%" y="30%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="66%" y="55%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="66%" y="80%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="49.5%" y="42.5%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="49.5%" y="67.5%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                </svg>
            </svg>
        </xsl:if>
        <xsl:if test="card_number='9'">
            <svg width="225" height="340" filter="url(#f1)">
                <svg width="185" height="300">
                    <rect width="185" height="300" rx="10" ry="10" fill="white"/>
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="18" y="20" fill="{$color}" font-size ="25" >9</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)" x="-167" y="-280" fill="{$color}" font-size ="25" >9</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="167" y="20" fill="{$color}" font-size ="25" >9</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)" x="-18" y="-280" fill="{$color}" font-size ="25" >9</text>
                    <text class="cardTexth "  x="91%" y="18%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth "  x="9%" y="18%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth "  x="-91%" y="-82%" fill="{$color}" dominant-baseline="middle" text-anchor="middle" transform="scale(-1,-1)" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth "  x="-9%" y="-82%" fill="{$color}" dominant-baseline="middle" text-anchor="middle" transform="scale(-1,-1)" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="33%" y="25%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="33%" y="45%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="33%" y="65%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="33%" y="85%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="66%" y="25%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="66%" y="45%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="66%" y="65%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="66%" y="85%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="49.5%" y="55%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                </svg>
            </svg>
        </xsl:if>
        <xsl:if test="card_number='10'">

            <svg width="225" height="340" filter="url(#f1)">
                <svg width="185" height="300">
                    <rect width="185" height="300" rx="10" ry="10" fill="white"/>
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="18" y="20" fill="{$color}" font-size ="25" >10</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)" x="-167" y="-280" fill="{$color}" font-size ="25" >10</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="167" y="20" fill="{$color}" font-size ="25" >10</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)" x="-18" y="-280" fill="{$color}" font-size ="25" >10</text>
                    <text class="cardTexth "  x="91%" y="18%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth "  x="9%" y="18%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth "  x="-91%" y="-82%" fill="{$color}" dominant-baseline="middle" text-anchor="middle" transform="scale(-1,-1)" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth "  x="-9%" y="-82%" fill="{$color}" dominant-baseline="middle" text-anchor="middle" transform="scale(-1,-1)" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="33%" y="25%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="33%" y="45%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="33%" y="65%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="33%" y="85%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="66%" y="25%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="66%" y="45%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="66%" y="65%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="66%" y="85%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="49.5%" y="35%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="49.5%" y="75%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                </svg>
            </svg>
        </xsl:if>
        <xsl:if test="card_number='J'">
            <svg width="225" height="340" filter="url(#f1)">
                <svg width="185" height="300">
                    <rect width="185" height="300" rx="10" ry="10" fill="white"/>
                    <image width="180" height="283" y="8.5" x="2.5" href="../../static/blackjack/Jack.png" />
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="18" y="20" font-size="25"  fill="{$color}">J</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)"
                          x="-167" y="-280" font-size="25"  fill="{$color}">J</text>
                    <text class="cardTexth "  x="154" y="65"  fill="{$color}" font-size="35"><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth "  x="3" y="65"  fill="{$color}" font-size="35"><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth "  x="-30.5" y="-235"  fill="{$color}" transform="scale(-1,-1)" font-size="35"><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth "  x="-181.5" y="-235"  fill="{$color}" transform="scale(-1,-1)" font-size="35"><xsl:value-of select="card_type"/></text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="167" y="20" font-size="25"  fill="{$color}">J</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)"
                          x="-18" y="-280" font-size="25"  fill="{$color}">J</text>
                </svg>
            </svg>
        </xsl:if>
        <xsl:if test="card_number='Q'">
            <svg width="225" height="340" filter="url(#f1)">
                <svg width="185" height="300">
                    <rect width="185" height="300" rx="10" ry="10" fill="white"/>
                    <image width="180" height="283" y="8.5" x="2.5" href="../../static/blackjack/Queen.png" />
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="18" y="20" font-size="25"  fill="{$color}">Q</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)"
                          x="-167" y="-280" font-size="25"  fill="{$color}">Q</text>
                    <text class="cardTexth "  x="154" y="65"  fill="{$color}" font-size="35"><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth "  x="3" y="65"  fill="{$color}" font-size="35"><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth "  x="-30.5" y="-235"  fill="{$color}" transform="scale(-1,-1)" font-size="35"><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth "  x="-181.5" y="-235"  fill="{$color}" transform="scale(-1,-1)" font-size="35"><xsl:value-of select="card_type"/></text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="167" y="20" font-size="25"  fill="{$color}">Q</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)"
                          x="-18" y="-280" font-size="25"  fill="{$color}">Q</text>
                </svg>
            </svg>
        </xsl:if>
        <xsl:if test="card_number='K'">
            <svg width="225" height="340" filter="url(#f1)">
                <svg width="185" height="300">
                    <rect width="185" height="300" rx="10" ry="10" fill="white"/>
                    <image width="180" height="283" y="8.5" x="2.5" href="../../static/blackjack/King.png" />
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="18" y="20" font-size="25"  fill="{$color}">K</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)"
                          x="-167" y="-280" font-size="25"  fill="{$color}">K</text>
                    <text class="cardTexth "  x="154" y="65"  fill="{$color}" font-size="35"><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth "  x="3" y="65"  fill="{$color}" font-size="35"><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth "  x="-30.5" y="-235"  fill="{$color}" transform="scale(-1,-1)" font-size="35"><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth "  x="-181.5" y="-235"  fill="{$color}" transform="scale(-1,-1)" font-size="35"><xsl:value-of select="card_type"/></text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="167" y="20" font-size="25"  fill="{$color}">K</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)"
                          x="-18" y="-280" font-size="25"  fill="{$color}">K</text>
                </svg>
            </svg>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>