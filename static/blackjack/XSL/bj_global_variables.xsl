<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">

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


</xsl:stylesheet>