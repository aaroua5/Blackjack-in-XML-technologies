<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">

    <!--                                          blackjack.xsl                                        -->

    <!-- table dimensions -->
    <xsl:variable name="tableCenterX" select="50"/>
    <xsl:variable name="tableCenterY" select="-95"/>
    <xsl:variable name="tableRadius" select="178"/>

    <!-- Card zone -->
    <xsl:variable name="cardZoneX5" select="-30"/>
    <xsl:variable name="cardZoneX4" select="10"/>
    <xsl:variable name="cardZoneX3" select="50"/>
    <xsl:variable name="cardZoneX2" select="90"/>
    <xsl:variable name="cardZoneX1" select="130"/>
    <xsl:variable name="cardZoneY1and5" select="45"/>
    <xsl:variable name="cardZoneY2and4" select="57"/>
    <xsl:variable name="cardZoneY3" select="63"/>
    <xsl:variable name="cardZoneRadius" select="8"/>
    
     <!-- bet text zone dimensions -->
    <xsl:variable name="betZoneWidth" select="8"/>
    <xsl:variable name="betZoneHeight" select="4"/>
    
    <!-- Buttons -->
    <xsl:variable name="hitX" select="100"/>
    <xsl:variable name="hitY" select="91"/>
    <xsl:variable name="hitRadius" select="6"/>

    <xsl:variable name="standX" select="120"/>
    <xsl:variable name="standY" select="87"/>
    <xsl:variable name="standRadius" select="6.7"/>

    <xsl:variable name="doubleX" select="140"/>
    <xsl:variable name="doubleY" select="80"/>
    <xsl:variable name="doubleRadius" select="7.4"/>

    <xsl:variable name="newRoundX" select="39.5"/>
    <xsl:variable name="newRoundY" select="89"/>
    <xsl:variable name="newRoundWidth" select="21"/>
    <xsl:variable name="newRoundHeight" select="9"/>

    <xsl:variable name="giveUpX" select="41.5"/>
    <xsl:variable name="giveUpY" select="89"/>
    <xsl:variable name="giveUpWidth" select="17"/>
    <xsl:variable name="giveUpHeight" select="9"/>

    <xsl:variable name="dealX" select="51.5"/>
    <xsl:variable name="dealY" select="89"/>
    <xsl:variable name="dealWidth" select="17"/>
    <xsl:variable name="dealHeight" select="9"/>

    <xsl:variable name="clearX" select="31.5"/>
    <xsl:variable name="clearY" select="89"/>
    <xsl:variable name="clearWidth" select="17"/>
    <xsl:variable name="clearHeight" select="9"/>

    <xsl:variable name="exitX" select="133.5"/>
    <xsl:variable name="exitY" select="-5.7"/>
    <xsl:variable name="exitCenter" select="20"/>
    <xsl:variable name="exitRadius" select="5"/>
    
    <!-- chips -->
    <xsl:variable name="chipCenter" select="20"/>
    <xsl:variable name="chipRadius" select="5"/>
    <xsl:variable name="chip50X" select="-5"/>
    <xsl:variable name="chip50Y" select="79"/>
    <xsl:variable name="chip25X" select="-18"/>
    <xsl:variable name="chip25Y" select="76"/>
    <xsl:variable name="chip10X" select="-31"/>
    <xsl:variable name="chip10Y" select="72"/>
    <xsl:variable name="chip5X" select="-44"/>
    <xsl:variable name="chip5Y" select="67"/>
    <xsl:variable name="chip1X" select="-57"/>
    <xsl:variable name="chip1Y" select="60"/>
    
    <!-- stickers dimensions -->
    <xsl:variable name="stickerBig" select="20"/>
    <xsl:variable name="stickerSmall" select="12"/>
    
    <!-- messages - Top Left Box -->
    <xsl:variable name="LeftBoxX" select="-47"/>
    <xsl:variable name="LeftBoxY" select="3"/>
    <xsl:variable name="LeftBoxWidth" select="53"/>
    <xsl:variable name="LeftBoxHeight" select="5"/>

    <!-- messages - Balance Box -->
    <xsl:variable name="BalanceBoxX" select="114"/>
    <xsl:variable name="BalanceBoxY" select="3"/>
    <xsl:variable name="BalanceBoxWidth" select="25"/>
    <xsl:variable name="BalanceBoxHeight" select="5"/>

    <!-- messages - Your turn Box -->
    <xsl:variable name="YourTurnBoxX" select="93"/>
    <xsl:variable name="YourTurnBoxY" select="3"/>
    <xsl:variable name="YourTurnBoxWidth" select="18"/>
    <xsl:variable name="YourTurnBoxHeight" select="5"/>
    
    <!-- Card dimensions -->
    <xsl:variable name="cardWidthDimension" select="225"/>
    <xsl:variable name="cardHeightDimension" select="340"/>

    <!-- Card width and height -->
    <xsl:variable name="cardWidth" select="185"/>
    <xsl:variable name="cardHeight" select="300"/>

    <!-- Position of text in the cards' corners -->
    <xsl:variable name="cardLeftPosition" select="9"/>
    <xsl:variable name="cardRightPosition" select="91"/>
    <xsl:variable name="cardTopPosition" select="-82"/>
    <xsl:variable name="cardDownPosition" select="18"/>

    <!-- Lines of the grid inside the cards -->
    <xsl:variable name="HorLine1" select="25"/>
    <xsl:variable name="HorLine2" select="30"/>
    <xsl:variable name="HorLine3" select="35"/>
    <xsl:variable name="HorLine4" select="42.5"/>
    <xsl:variable name="HorLine5" select="45"/>
    <xsl:variable name="HorLine6" select="55"/>
    <xsl:variable name="HorLine7" select="65"/>
    <xsl:variable name="HorLine8" select="67.5"/>
    <xsl:variable name="HorLine9" select="75"/>
    <xsl:variable name="HorLine10" select="80"/>
    <xsl:variable name="HorLine11" select="85"/>

    <xsl:variable name="VerLine1" select="33"/>
    <xsl:variable name="VerLine2" select="50"/>
    <xsl:variable name="VerLine3" select="66"/>

    <!--                                             lounge.xsl                                            -->

    <!-- Table dimensions for the leader board and games -->
    <xsl:variable name="tableWidth" select="49"/>
    <xsl:variable name="tableHeight" select="79"/>
    <xsl:variable name="tablePositionX" select="30"/>
    <xsl:variable name="tablePositionY" select="4"/>

    <!-- Title zone in the table -->
    <xsl:variable name="titleZoneX" select="33"/>
    <xsl:variable name="titleZoneY" select="7"/>
    <xsl:variable name="TitleZoneWidth" select="43"/>
    <xsl:variable name="titleZoneHeight" select="6"/>
    <xsl:variable name="titleTextX" select="54.5"/>
    <xsl:variable name="titleTextY" select="3.5"/>

    <!-- First player/game zone in the table -->
    <xsl:variable name="firstRowX" select="33"/>
    <xsl:variable name="firstRowY" select="18"/>
    <xsl:variable name="zoneHeight" select="6"/>
    <xsl:variable name="playerZoneWidth" select="43"/>
    <xsl:variable name="gameZoneWidth" select="34"/>

    <!-- join button first circle -->
    <xsl:variable name="joinCircleX" select="73"/>
    <xsl:variable name="joinCircleY" select="21"/>

    <!-- text showing player name, balance and score -->
    <xsl:variable name="paragraphX" select="35"/>
    <xsl:variable name="paragraphY" select="27"/>
    <xsl:variable name="paragraphCentered" select="50"/>


</xsl:stylesheet>
