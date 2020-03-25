<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
<xsl:template match="blackjack">
    <svg width="100%" height="100%">
    <text x ="50" y="30"> <tspan width="30">player 1 :<xsl:value-of select="./players/player[@id = 1]/totalmonney"></xsl:value-of></tspan>
     <tspan>player 2 :<xsl:value-of select="./players/player[@id = 2]/totalmonney"></xsl:value-of></tspan>
     <tspan>player 3 :<xsl:value-of select="./players/player[@id = 3]/totalmonney"></xsl:value-of></tspan>
     <tspan>player 4 :<xsl:value-of select="./players/player[@id = 4]/totalmonney"></xsl:value-of></tspan>
     <tspan>player 5 :<xsl:value-of select="./players/player[@id = 5]/totalmonney"></xsl:value-of></tspan>

    </text>

        <foreignObject x="2%" y="78%" width="100%" height="100%" >
            <form xmlns="http://www.w3.org/1999/xhtml" action="/bj/b/1" method="post" id="form1" style="display: inline;" >
                <button type="submit" form="form1" value="Submit" style="height:80px; width:80px;
                    border-radius: 40px;">1</button>
            </form>
        </foreignObject>


    </svg>

</xsl:template>

</xsl:stylesheet>