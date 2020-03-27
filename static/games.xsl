<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:template match="casino">

<svg width ="100%" height="100%">
         <text x="30%" y="30%">

           <tspan> <xsl:for-each select="blackjack" >
               <xsl:value-of select="position()"/>====>
                <xsl:value-of select="./@id"></xsl:value-of>

            </xsl:for-each>
           </tspan>
         </text>

        <foreignObject x="2%" y="78%" width="100%" height="100%" >
            <form xmlns="http://www.w3.org/1999/xhtml" action="/bj/initPlayer" method="get" id="formMenu" style="display: inline;" >
                <button type="submit" form="formMenu" value="Submit" style="height:80px; width:80px;
                    border-radius: 40px;">new Game</button>
            </form>
        </foreignObject>
    <foreignObject x="30%" y="30%"  width="100%" height="100%">
        <form xmlns="http://www.w3.org/1999/xhtml" action="/bj/join/{./blackjack/@id}" method="get" id="formjoin" style="display: inline;" >
            <button type="submit" form="formjoin" value="Submit" style="height:80px; width:80px;
                    border-radius: 40px;">join</button>
        </form>
    </foreignObject>


</svg>
    </xsl:template>


</xsl:stylesheet>