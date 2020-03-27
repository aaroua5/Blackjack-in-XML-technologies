<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
<xsl:template match="blackjack">
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

            <g id="background2" >
                <svg width="100%" height="100%">
                    <rect x="0"  y="0" width="100%" height="100%" fill="#0F2822" />
                </svg>
            </g>

            <g id="table">
                <svg width="100%" height="100%" viewBox="0 0 100 100">

                    <rect x="25" y="20" width="50" height="50" rx="3" ry="3" fill="#09846F" stroke-width="0.5" stroke="url(#goldGradient)"
                          filter="url(#f2)"/>
                    <!--  <text x="100" y="91" font-family="Arial" font-size="3" text-anchor="middle" alignment-baseline="central"
                          fill="#fcdd7a">HIT</text> -->

                </svg>
            </g>

            <g id="score">
                <svg width="100%" height="100%" viewBox="0 0 100 100">

                    <text x ="30" y="30" fill="white" font-size="4" >
                        <tspan x="30" dy="0">Player 1: </tspan>
                        <tspan x="68" dy="0" text-anchor="end"><xsl:value-of select="./players/player[@id = 1]/totalmonney"></xsl:value-of></tspan>

                        <tspan x="30" dy="2em">Player 2: </tspan>
                        <tspan x="68" dy="0" text-anchor="end"><xsl:value-of select="./players/player[@id = 2]/totalmonney"></xsl:value-of></tspan>

                        <tspan x="30" dy="2em">Player 3: </tspan>
                        <tspan x="68" dy="0" text-anchor="end"><xsl:value-of select="./players/player[@id = 3]/totalmonney"></xsl:value-of></tspan>

                        <tspan x="30" dy="2em">Player 4: </tspan>
                        <tspan x="68" dy="0" text-anchor="end"><xsl:value-of select="./players/player[@id = 4]/totalmonney"></xsl:value-of></tspan>

                        <tspan x="30" dy="2em">Player 5: </tspan>
                        <tspan x="68" dy="0" text-anchor="end"><xsl:value-of select="./players/player[@id = 5]/totalmonney"></xsl:value-of></tspan>
                    </text>

                </svg>

                <foreignObject x="2%" y="78%" width="100%" height="100%" >
                    <form xmlns="http://www.w3.org/1999/xhtml" action="/bj/b/1" method="post" id="form1" style="display: inline;" >
                        <button type="submit" form="form1" value="Submit" style="height:80px; width:80px;
                    border-radius: 40px;">1</button>
                    </form>
                </foreignObject>
            </g>

        </defs>

        <use href="#background2" width="100%" height="100%"/>
        <use href="#table" width="100%" height="100%"/>
        <use href="#score" width="100%" height="100%"/>

    </svg>

</xsl:template>

</xsl:stylesheet>
