<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:param name="playerID"/>
    <xsl:template match="blackjack">
        <xsl:variable name="id" select="@id"></xsl:variable>
        <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="100%" height="100%" viewBox="0, 0, 1800, 900">

            <defs>

                <linearGradient id="goldGradient" x1="0" y1="0" x2="1" y2="1"> <!-- Gold gradient used for the stroke of the buttons -->
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

                <filter id="f2" x="0" y="0" width="200%" height="200%" filterUnits="userSpaceOnUse">
                    <feOffset result="offOut" in="SourceAlpha" dx="1.5" dy="1.5" />
                    <feGaussianBlur result="blurOut" in="offOut" stdDeviation="2" />
                    <feBlend in="SourceGraphic" in2="blurOut" mode="normal" />
                </filter>

                <g id="background" > <!-- Background of the page -->
                    <svg width="100%" height="100%">
                        <rect x="0"  y="0" width="100%" height="100%" fill="#0F2822" />
                    </svg>
                </g>

                <!-- Button design -->
                <svg id="buttons" width="100%" height="100%" viewBox="0 0 100 100">

                         <xsl:choose>      <!-- 1st case: Player lost all of his money / 2nd case: Player still got money-->

                             <!-- In this case we have one buttons: Menu -->
                             <xsl:when test="loosers/player[$playerID = @id]/totalmonney = 0">
                                 <!-- Menu button -->
                                 <rect x="40.75" y="48" width="18.5" height="8" rx="2" ry="2" fill="#091b17" stroke-width="0.5" stroke="url(#goldGradient)"/>
                                 <text x="50" y="52" font-family="Arial" font-size="3" text-anchor="middle" alignment-baseline="central"
                                       fill="#EFCB68">MENU</text>

                                 <!-- Message -->
                                 <text x="50" y="40" font-family="Arial" font-size="3" text-anchor="middle" alignment-baseline="central"
                                       fill="#EBEBEB">
                                     <tspan x="50" >GAME OVER!</tspan>
                                     <tspan x="50" dy="1.5em">You lost all of your money!</tspan>
                                 </text>
                             </xsl:when>

                             <!-- In this case we have two buttons: Lounge and Menu -->
                             <xsl:otherwise>
                                 <!-- Menu button -->
                                 <rect x="51.5" y="48" width="18.5" height="8" rx="2" ry="2" fill="#091b17" stroke-width="0.5" stroke="url(#goldGradient)"/>
                                 <text x="60.75" y="52" font-family="Arial" font-size="3" text-anchor="middle" alignment-baseline="central"
                                       fill="#EFCB68">MENU</text>

                                 <!-- Lounge button -->
                                 <rect x="30" y="48" width="18.5" height="8" rx="2" ry="2" fill="#091b17" stroke-width="0.5" stroke="url(#goldGradient)"/>
                                 <text x="39.25" y="52" font-family="Arial" font-size="3" text-anchor="middle" alignment-baseline="central"
                                       fill="#EFCB68">LOUNGE</text>

                                 <!-- Message -->
                                 <text x="50" y="43" font-family="Arial" font-size="3" text-anchor="middle" alignment-baseline="central"
                                       fill="#EBEBEB">See you soon!
                                 </text>
                             </xsl:otherwise>

                         </xsl:choose>

                </svg>


            </defs>

            <use href="#background" width="100%" height="100%"/>
            <use href="#buttons" width="100%" height="100%"/>

            <!-- Buttons: -->
            
            <!-- Hidden frame to throw away post requests -->
            <foreignObject width="0" height="0">
                <iframe class = "hiddenFrame" xmlns = "http://www.w3.org/1999/xhtml" name="hiddenFrame"></iframe>
            </foreignObject>

            <xsl:choose>

                <xsl:when test="loosers/player[$playerID = @id]/totalmonney = 0">
                    <!-- Menu button -->
                    <foreignObject x="45.3%" y="47.8%" width="100%" height="100%" >
                        <form xmlns="http://www.w3.org/1999/xhtml" action="/bj/returnToLobby/{$id}/{$playerID}" method="get" id="form1" style="display: inline;" >
                            <button type="submit" form="form1" value="Submit" style="height:76px; width:170px; border-radius: 20px; border: none;
                            background-color: Transparent; outline:none;"></button>
                        </form>
                    </foreignObject>
                </xsl:when>

                <xsl:otherwise>
      <xsl:variable name="playerName" select="loosers/player[$playerID = @id]/name"></xsl:variable>
                    <!-- Lounge button -->
                    <foreignObject x="39.9%" y="47.8%" width="100%" height="100%" >
                        <form xmlns="http://www.w3.org/1999/xhtml" action="/bj/returnToGames/{$id}/{$playerID}" method="get" id="form2" style="display: inline;"  target="hiddenFrame">
                            <button type="submit" form="form2" value="Submit" style="height:76px; width:170px; border-radius: 20px; border: none;
                            background-color: Transparent; outline:none;"></button>
                        </form>
                    </foreignObject>

                    <!-- Menu button -->
                    <foreignObject x="50.6%" y="47.8%" width="100%" height="100%" >
                        <form xmlns="http://www.w3.org/1999/xhtml" action="/bj/returnToLobby/{$id}/{$playerID}" method="get" id="form3" style="display: inline;" >
                            <button type="submit" form="form3" value="Submit" style="height:76px; width:170px; border-radius: 20px; border: none;
                            background-color: Transparent; outline:none;"></button>
                        </form>
                    </foreignObject>
                </xsl:otherwise>

            </xsl:choose>

        </svg>

    </xsl:template>

</xsl:stylesheet>
