<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:param name="playerID"/>
    <xsl:param name="balance"/>
    <xsl:template match="casino">

        <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="100%" height="100%" viewBox="0, 0, 1800, 900">

            <defs>
                <g id="background" >
                    <svg width="100%" height="100%">
                        <rect x="0"  y="0" width="100%" height="100%" fill="#0F2822" />
                    </svg>
                </g>

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
            <use href="#buttons" width="100%" height="100%"/>
            <foreignObject width="0" height="0">
                <iframe class = "hiddenFrame" xmlns = "http://www.w3.org/1999/xhtml" name="hiddenFrame"></iframe>
            </foreignObject>

            <foreignObject x="30%" y="30%" width="100%" height="100%" >
                <form xmlns="http://www.w3.org/1999/xhtml" action="/bj/newGame/" method="POST" id="formMenu" style="display: inline;" target ="hiddenFrame" >
                    <button type="submit" form="formMenu" value="Submit" style="height:80px; width:80px;
                    border-radius: 40px;">new Game</button>
                </form>
            </foreignObject>

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
        </svg>

    </xsl:template>


</xsl:stylesheet>
