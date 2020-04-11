<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:param name="playerID"/>
    <xsl:template match="blackjack">


        <xsl:variable name="id" select="@id"></xsl:variable>
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

                    <text> you lost my friend</text>
                    </svg>
                </g>



                <svg id="buttons" width="100%" height="100%" viewBox="0 0 100 100">

                    <xsl:if test="step ='roundOver'">

                        <rect x="51.5" y="48" width="18.5" height="8" rx="2" ry="2" fill="#091b17" stroke-width="0.5" stroke="url(#goldGradient)"/>
                        <text x="60.75" y="52" font-family="Arial" font-size="3" text-anchor="middle" alignment-baseline="central"
                              fill="#EFCB68">MENU</text>

                        <rect x="30" y="48" width="18.5" height="8" rx="2" ry="2" fill="#091b17" stroke-width="0.5" stroke="url(#goldGradient)"/>
                        <text x="39.25" y="52" font-family="Arial" font-size="3" text-anchor="middle" alignment-baseline="central"
                              fill="#EFCB68">GAMES</text>

                        <text x="50" y="43" font-family="Arial" font-size="3" text-anchor="middle" alignment-baseline="central"
                              fill="#EBEBEB">See you soon, Yousri</text>

                    </xsl:if>

                    <xsl:if test="step ='gameOver'">

                        <rect x="40.75" y="48" width="18.5" height="8" rx="2" ry="2" fill="#091b17" stroke-width="0.5" stroke="url(#goldGradient)"/>
                        <text x="50" y="52" font-family="Arial" font-size="3" text-anchor="middle" alignment-baseline="central"
                              fill="#EFCB68">MENU</text>

                        <text x="50" y="40" font-family="Arial" font-size="3" text-anchor="middle" alignment-baseline="central"
                              fill="#EBEBEB">
                            <tspan x="50" >GAME OVER!</tspan>
                            <tspan x="50" dy="1.5em">You lost all of your money!</tspan>
                        </text>

                    </xsl:if>

                </svg>



            </defs>

            <use href="#background" width="100%" height="100%"/>
            <use href="#buttons" width="100%" height="100%"/>

            <xsl:if test="step ='roundOver'">
                <foreignObject x="39.9%" y="47.8%" width="100%" height="100%" >
                    <form xmlns="http://www.w3.org/1999/xhtml" action="/bj/newRound/{$id}" method="post" id="form1" style="display: inline;" >
                        <button type="submit" form="form1" value="Submit" style="height:76px; width:170px;
                            border-radius: 20px; border: none; background-color: Transparent; outline:none;"></button>
                    </form>
                </foreignObject>
                <foreignObject x="50.6%" y="47.8%" width="100%" height="100%" >
                    <form xmlns="http://www.w3.org/1999/xhtml" action="/bj/lobby/" method="post" id="form1" style="display: inline;" >
                        <button type="submit" form="form1" value="Submit" style="height:76px; width:170px;
                             border-radius: 20px; border: none; background-color: Transparent; outline:none;"></button>
                    </form>
                </foreignObject>
            </xsl:if>

            <!--    this only when there is no more players: all bankrupt! !-->

            <xsl:if test="step ='gameOver'">
                <foreignObject x="45.3%" y="47.8%" width="100%" height="100%" >
                    <form xmlns="http://www.w3.org/1999/xhtml" action="/bj/lobby/" method="post" id="form1" style="display: inline;" >
                        <button type="submit" form="form1" value="Submit" style="height:76px; width:170px;
                                border-radius: 20px; border: none; background-color: Transparent; outline:none;"></button>
                    </form>
                </foreignObject>
            </xsl:if>
        </svg>

    </xsl:template>

</xsl:stylesheet>
