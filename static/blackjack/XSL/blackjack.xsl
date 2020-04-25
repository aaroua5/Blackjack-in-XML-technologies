<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:param name="Jack"/>
    <xsl:template match="blackjack">

        <xsl:variable name="hitLink" select="bj/hit"/>
        <xsl:variable name="id" select= "@id"/>
        <xsl:variable name = "activePlayer" select="./playerTurn"/>
        <xsl:param name="playerID"/>
        <xsl:variable name="gamestep" select="step"></xsl:variable>

        <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="100%" height="100%" viewBox="0, 0, 1800, 900">

            <defs>

                <!-- Radial gradient for filling the table-->
                <radialGradient id="gradTable" cx="50%" cy="50%" r="50%" fx="50%" fy="50%">
                    <stop offset="50%" stop-color="#09846F" />
                    <stop offset="95%" stop-color="#026A54" />
                </radialGradient>

                <!-- Gold gradient used mainly for the stroke of the buttons -->
                <linearGradient id="goldGradient" x1="0" y1="0" x2="1" y2="1">
                    <stop offset="5%" stop-color="#efcf76"></stop>
                    <stop offset="33%" stop-color="#fcdd7a"></stop>
                    <stop offset="66%" stop-color="#cfba65"></stop>
                    <stop offset="100%" stop-color="#988058"></stop>
                </linearGradient>

                <!-- Filter used for creating a drop shadow -->
                <filter id="f1" x="0" y="0" width="200%" height="200%" filterUnits="userSpaceOnUse">
                    <feOffset result="offOut" in="SourceAlpha" dx="4" dy="4" />
                    <feGaussianBlur result="blurOut" in="offOut" stdDeviation="10" />
                    <feBlend in="SourceGraphic" in2="blurOut" mode="normal" />
                </filter>

                <!-- Filter used for creating a drop shadow -->
                <filter id="f2" x="0" y="0" width="200%" height="200%" filterUnits="userSpaceOnUse">
                    <feOffset result="offOut" in="SourceAlpha" dx="2" dy="2" />
                    <feGaussianBlur result="blurOut" in="offOut" stdDeviation="2" />
                    <feBlend in="SourceGraphic" in2="blurOut" mode="normal" />
                </filter>

                <!-- Filter used for creating an inner shadow -->
                <filter id="inner-shadow">
                    <feFlood flood-color="black"/>
                    <feComposite in2="SourceAlpha" operator="out"/>
                    <feGaussianBlur stdDeviation="2" result="blur"/>
                    <feComposite operator="atop" in2="SourceGraphic"/>
                </filter>

                <!-- Filter used for creating an inner greenish glow -->
                <filter id="inner-glow">
                    <feFlood flood-color="#09846F"/>
                    <feComposite in2="SourceAlpha" operator="out"/>
                    <feGaussianBlur stdDeviation="1" result="blur"/>
                    <feComposite operator="atop" in2="SourceGraphic"/>
                </filter>

                <!-- Filter used for creating an outer glow -->
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

                <!-- Clip path used for creating a fake 3D effect for the chips - works by substracting two shapes -->
                <clipPath id="cut-off-bottom">
                    <circle cx="20" cy="30" r="12" />
                </clipPath>

                <!-- Clip path used for showing the white rectangles around the chips - works by substracting two shapes -->
                <clipPath id="chip-white-rectangles">
                    <rect id="up"  x="18" y="12.2" height="2" width="4" rx="0.3" ry="0.3" />
                    <rect id="upLeft"  x="18" y="12.2" height="2" width="4" rx="0.3" ry="0.3" transform ="rotate(-60 20 20)"/>
                    <rect id="downLeft"  x="18" y="12.2" height="2" width="4" rx="0.3" ry="0.3" transform ="rotate(-120 20 20)"/>
                    <rect id="down"  x="18" y="12.2" height="2" width="4" rx="0.3" ry="0.3" transform ="rotate(-180 20 20)"/>
                    <rect id="downRight"  x="18" y="12.2" height="2" width="4" rx="0.3" ry="0.3" transform ="rotate(120 20 20)"/>
                    <rect id="upRight"  x="18" y="12.2" height="2" width="4" rx="0.3" ry="0.3" transform ="rotate(60 20 20)"/>
                </clipPath>

                <!-- Background of the game -->
                <g id="background">
                    <svg width="100%" height="100%">
                        <rect x="0"  y="0" width="100%" height="100%" fill="#0F2822" />
                    </svg>
                </g>

                <!-- Table design -->
                <g id="table">

                    <!-- table where the game will take place -->
                    <svg id="table big circle" width="100%" height="100%" viewBox="0 0 100 100">

                        <circle cx="50" cy="-95" r="181" fill="#503D2D"  filter="url(#outer-glow)"/>
                        <circle cx="50" cy="-95" r="178" fill="url(#gradTable)" filter="url(#inner-shadow)"/>

                    </svg>

                    <!-- card zones in form of circles for each player -->
                    <svg id="card zones" width="100%" height="100%" viewBox="0 0 100 100">

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

                    </svg>

                    <!-- text printed on the table containing some rules of the game -->
                    <svg id="text on table" x="0" y="175" viewBox="0 0 1300 1300">
                        <!-- shapes for the banner design -->
                        <path
                                d="M1302.7,57.9c-23,50.1-69.5,78.3-119.9,96.8-5.8,2.1-11.7,4.2-17.6,6.1-7.9,2.6-9.8,1.7-10,9.9-.4,14.9,0,29.8,0,44.7,0,3.7,1.8,14.3-.2,17.9s-8.4,3.9-12.9,4.9l-43.3,8.9a2374.5,2374.5,0,0,1-332.9,42.2c-138.5,7.5-278.9.3-416.1-19.1-61.1-8.6-122-19.5-182.3-32.6-6.2-1.4-8.5-.9-10-6.6s0-16.6,0-23.5V184c0-5.5,1.9-15.7-1.3-19.7s-15.1-5.2-19.8-6.9c-6.9-2.4-13.8-5.1-20.5-7.9-13.8-5.8-27.5-12.2-40.2-20.2a250.3,250.3,0,0,1-21-14.3A188.3,188.3,0,0,1,36.6,98.5,102.3,102.3,0,0,1,24.7,84.1c-3.9-5.7-7.1-11.9-10.4-17.9-1.4-2.5-2.4-5.1-3.6-7.7s.6-3.9,3.2-4.2a15.6,15.6,0,0,1,5.7.4c15.6,4.5,31,9.4,46.6,13.6a346.5,346.5,0,0,0,35,7.7c5.3.8,5.5.7,7.6-4.2s4.3-11.4,6.5-17c3.7-9.6,6.3-22.2,11.8-30.9,2-3.1,3.8-6.4,8.6-4.9s5.6,7.3,8.3,10.6c14.1,17.4,39.6,26.7,60.1,34A714.1,714.1,0,0,0,274.5,85c12.7,3.2,25.5,6.3,38.4,9.2,5.1,1.2,10.8,1.7,15.7,3.5s4.5,1.3,5.1,6.3c1.1,11.1-2.2,23.3-2.5,34.5-.1,6.5,0,5.9,6.1,7.3,7.8,1.8,15.9,3,23.8,4.4,49.8,8.8,100,15,150.3,19.6,103.3,9.5,208,8.6,311.2-1.7,51-5.1,103.9-10.3,153.9-22.2,6.4-1.5,6.3-1.4,6.1-8.2s-.7-11.9-1.1-17.8-2.5-13.8-1.4-18.7,5.9-4.5,10.7-5.6c24.8-5.6,49.4-11.4,73.8-18.2,27-7.5,53.4-16.5,78.4-29.2,10.2-5.2,21.5-11.6,28.2-21.3,2.5-3.6,3.4-9.1,8.8-9.1s6.7,6.1,8.4,10.4c4.4,11.2,8.6,22.4,12.7,33.7,1.1,3.1,3.1,12.3,6.4,13.9s13.6-2.3,17.1-3.1c14.5-3.2,29-6.5,43.3-10.7l20-6.2C1289.7,55.2,1306.3,50,1302.7,57.9Z"
                                transform="translate(-10.5 -17.8)" fill="#0d5545"/>
                        <path
                                d="M1144.2,111.5v90.7c0,6.1,3.2,24.3-.4,28.7s-21.3,5-26.9,6.1l-29,5.9q-28.2,5.7-56.5,10.5c-78.4,13.3-157.2,22.3-236.6,28-161.4,11.5-323.5,1.9-483.2-23.1-43.3-6.8-86.2-15-129.1-24-2.7-.6-11.8-1-13.8-3.4s-.4-11.7-.4-15.1V180.3c0-22.8-.9-45.8.1-68.6,14.8,1.6,30,8.3,44.4,12.2,16.8,4.5,33.7,8.6,50.6,12.7,31,7.5,62.2,13.8,93.5,19.4a1794.8,1794.8,0,0,0,189,22.8c130.1,8.9,261.8,1.6,390.4-19.7,35.5-5.9,70.8-12.5,105.8-20.7,17.7-4.2,35.3-8.4,52.9-13.2S1127.7,114,1144.2,111.5Z"
                                transform="translate(-10.5 -17.8)" fill="#0d735f"/>
                        <path
                                d="M1289.3,62.7c-10.2,26.3-34.5,46.6-57.8,60.9a271.2,271.2,0,0,1-42.5,21.1c-6.5,2.6-13,5-19.6,7.4-2,.7-9.6,5.1-11.8,4.4s-2.3-.6-2.4-6.1c-.2-8.1,0-16.3,0-24.3,0-5.2,2-16.8-1.3-21.1s-14.8-2.4-19.2-2.5l-23.8-.9c-32.4-1.2-66.7,1.8-98.7-3.1,51.7-17,111.8-22.9,156.4-57.3,3.1-2.4,7.7-9.1,10.9-7.2s5.2,13.7,6.2,16.2c3.5,9,7.1,31.5,17.6,32.6,7,.7,16-2.6,22.8-4s13.6-2.8,20.3-4.5C1260.6,70.9,1274.9,64.7,1289.3,62.7Z"
                                transform="translate(-10.5 -17.8)" fill="#0d735f"/>
                        <path
                                d="M24.5,63.5a17.5,17.5,0,0,1,2.4.3c14,4,28,8.3,42.1,11.7,9.2,2.3,18.5,4.1,27.9,5.9,7.4,1.4,15.3,5.4,20-1.7s6.7-16.7,9.3-24.1,4.4-16.8,9-22c22.3,19,48.2,30,75.7,39.5,15,5.1,30.3,9.5,45.5,13.7,7.1,2,14.2,3.8,21.3,5.6s18.7,3,23.9,7.2c-16,2.4-33.2.4-49.3,1l-51.6,1.9c-8.5.3-16.9.7-25.4.9-6.1.2-14.1-1.9-17.2,3.9s-.3,18.2-.4,24.2c-.1,8.6-.2,17.3-.2,26-23.8-7.2-46.3-17.5-68.3-29a163.5,163.5,0,0,1-27.4-18.3A148,148,0,0,1,47.5,97.1,141.8,141.8,0,0,1,34,80.7c-3.7-5.2-6.6-10.9-9.9-16.5Z"
                                transform="translate(-10.5 -17.8)" fill="#0d735f"/>
                        <!-- Path used to display the text: INSURANCE PAYS 2 TO 1 -->
                        <path
                                id="MyPath3"
                                d="M185.6,209.6c114.6,27.7,232.3,42.7,350,48.7,134.1,6.9,269.1,2.4,402.2-15.6A1762.6,1762.6,0,0,0,1116,209.6"
                                transform="translate(-70 15) scale(1.1)" fill="none"/>
                        <text font-family="DIN Condensed" font-size="27" fill="#0d5545" letter-spacing="4">
                            <textPath href="#MyPath3" startOffset="72%">
                                INSURANCE PAYS 2 TO 1
                            </textPath>
                        </text>
                        <!-- Path used to display the text: BLACKJACK   PAYS   3   TO   2 -->
                        <path
                                id="MyPath2"
                                d="M185.6,209.6c114.6,27.7,232.3,42.7,350,48.7,134.1,6.9,269.1,2.4,402.2-15.6A1762.6,1762.6,0,0,0,1116,209.6"
                                transform="translate(-10.5 -15)" fill="none"/>
                        <text font-family="DIN Condensed" font-size="85" fill="#80A323" letter-spacing="4">
                            <textPath href="#MyPath2" startOffset="14%">
                                BLACKJACK   PAYS   3   TO   2
                            </textPath>
                        </text>
                        <!-- Path used to display the text: DEALER MUST DRAW TO 16 AND STAND ON ALL 17'S -->
                        <path
                                id="MyPath1"
                                d="M342.9,129.3c83.6,19.4,193.2,35.6,322,34.8,120.6-.8,223.9-16.2,304-34.8"
                                transform="translate(-10.5 -15)" fill="none"/>
                        <text font-family="DIN Condensed" font-size="27" fill="#0d5545" letter-spacing="4">
                            <textPath href="#MyPath1" startOffset="2%">
                                DEALER MUST DRAW TO 16 AND STAND ON ALL 17'S
                            </textPath>
                        </text>

                    </svg>

                </g>

                <g id="players">

                    <!-- name is displayed below to the card zone for each player -->
                    <svg id="player name" width="100%" height="100%" viewBox="0 0 100 100">

                        <text x="-30" y="57.5" font-family="Arial" font-size="3" fill="#80A323" text-anchor="middle"><xsl:value-of select="players/player[tableSeat= 5]/name"/></text>
                        <text x="10" y="69.5" font-family="Arial" font-size="3" fill="#80A323" text-anchor="middle"><xsl:value-of select="players/player[tableSeat= 4]/name"/></text>
                        <text x="50" y="75.5" font-family="Arial" font-size="3" fill="#80A323" text-anchor="middle"><xsl:value-of select="players/player[tableSeat= 3]/name"/></text>
                        <text x="90" y="69.5" font-family="Arial" font-size="3" fill="#80A323" text-anchor="middle"><xsl:value-of select="players/player[tableSeat= 2]/name"/></text>
                        <text x="130" y="57.5" font-family="Arial" font-size="3" fill="#80A323" text-anchor="middle"><xsl:value-of select="players/player[tableSeat= 1]/name"/></text>

                    </svg>

                    <!-- card sum is displayed in the right side of the card zone for each player -->
                    <svg id="cards sum" width="100%" height="100%" viewBox="0 0 100 100">

                        <text x="-19.7" y="42" font-family="Arial" font-size="3" fill="#EBEBEB" text-anchor="start"><xsl:value-of select="players/player[tableSeat=5]/totalSumCards"/></text>
                        <text x="20.3" y="54" font-family="Arial" font-size="3" fill="#EBEBEB" text-anchor="start"><xsl:value-of select="players/player[tableSeat=4]/totalSumCards"/></text>
                        <text x="60.3" y="60" font-family="Arial" font-size="3" fill="#EBEBEB" text-anchor="start"><xsl:value-of select="players/player[tableSeat=3]/totalSumCards"/></text>
                        <text x="100.3" y="54" font-family="Arial" font-size="3" fill="#EBEBEB" text-anchor="start"><xsl:value-of select="players/player[tableSeat=2]/totalSumCards"/></text>
                        <text x="140.3" y="42" font-family="Arial" font-size="3" fill="#EBEBEB" text-anchor="start"><xsl:value-of select="players/player[tableSeat=1]/totalSumCards"/></text>
                        <xsl:if test="step='roundOver'">
                            <text x="60.3" y="7" font-family="Arial" font-size="3" fill="#EBEBEB" text-anchor="start"><xsl:value-of select="dealer/totalSumCards"/></text>
                        </xsl:if>

                    </svg>

                    <!-- arrow pointing to the active player -->
                    <svg id="active player arrow" width="100%" height="100%" viewBox="0 0 100 100">

                        <xsl:if test="./players/player[position() = $activePlayer]/tableSeat = '5'">
                            <text x="-32" y="28" font-size="4" fill="#80A323">
                                ▼
                            </text>
                        </xsl:if>

                        <xsl:if test="./players/player[position() = $activePlayer]/tableSeat = '4'">
                            <text x="8" y="40" font-size="4" fill="#80A323">
                                ▼
                            </text>
                        </xsl:if>

                        <xsl:if test="./players/player[position() = $activePlayer]/tableSeat = '3'">
                            <text x="48" y="46" font-size="4" fill="#80A323">
                                ▼
                            </text>
                        </xsl:if>

                        <xsl:if test="./players/player[position() = $activePlayer]/tableSeat = '2'">
                            <text x="88" y="40" font-size="4" fill="#80A323">
                                ▼
                            </text>
                        </xsl:if>

                        <xsl:if test="./players/player[position() = $activePlayer]/tableSeat = '1'">
                            <text x="128" y="28" font-size="4" fill="#80A323">
                                ▼
                            </text>
                        </xsl:if>

                    </svg>

                </g>

                <!-- all buttons (except chips) -->
                <g id="buttons">

                    <!-- hit button -->
                    <svg id="hit" width="100%" height="100%" viewBox="0 0 100 100">
                        <circle cx="100" cy="91" r="6" fill="black" stroke-width="0.8" stroke="url(#goldGradient)" filter="url(#f2)"/>
                        <circle cx="100" cy="91" r="5.3" fill="#060C1A" filter="url(#inner-glow)" />
                        <text x="100" y="91" font-family="Arial" font-size="3" text-anchor="middle" alignment-baseline="central"
                              fill="#fcdd7a">HIT</text>
                    </svg>

                    <!-- stand button -->
                    <svg id="stand" width="100%" height="100%" viewBox="0 0 100 100">
                        <circle cx="120" cy="87" r="6.7" fill="black" stroke-width="0.8" stroke="url(#goldGradient)" filter="url(#f2)"/>
                        <circle cx="120" cy="87" r="6" fill="#060C1A" filter="url(#inner-glow)"/>
                        <text x="120" y="87" font-family="Arial" font-size="3" text-anchor="middle" alignment-baseline="central"
                              fill="#fcdd7a">STAND</text>
                    </svg>

                    <!-- double button -->
                    <svg id="double" width="100%" height="100%" viewBox="0 0 100 100">
                        <circle cx="140" cy="80" r="7.4" fill="black" stroke-width="0.8" stroke="url(#goldGradient)" filter="url(#f2)"/>
                        <circle cx="140" cy="80" r="6.7" fill="#060C1A" filter="url(#inner-glow)"/>
                        <text x="140" y="80" font-family="Arial" font-size="3" text-anchor="middle" alignment-baseline="central"
                              fill="#fcdd7a">DOUBLE</text>
                    </svg>

                    <!-- new round button - displayed only when the game is finished -->
                    <xsl:if test="step ='roundOver'">
                        <svg id="new round" width="100%" height="100%" viewBox="0 0 100 100">

                            <rect x="39.5" y="89" width="21" height="9" rx="2.5" ry="2.5" stroke-width="0.8" stroke="url(#goldGradient)" filter="url(#f2)"/>
                            <rect x="40" y="89.5" width="20" height="8" rx="2" ry="2" fill="#060C1A" filter="url(#inner-glow)"/>
                            <text x="50" y="93.5" font-family="Arial" font-size="3" text-anchor="middle" alignment-baseline="central"
                                  fill="#fcdd7a">NEW ROUND</text>
                        </svg>
                    </xsl:if>

                    <!-- new round button - displayed only after betting and before the player starts playing -->
                    <xsl:if test="step = 'play'">
                        <svg id="give up" width="100%" height="100%" viewBox="0 0 100 100">
                            <rect x="41.5" y="89" width="17" height="9" rx="2.5" ry="2.5" stroke-width="0.8" stroke="url(#goldGradient)" filter="url(#f2)"/>
                            <rect x="42" y="89.5" width="16" height="8" rx="2" ry="2" fill="#060C1A" filter="url(#inner-glow)"/>
                            <text x="50" y="93.5" font-family="Arial" font-size="3" text-anchor="middle" alignment-baseline="central"
                                  fill="#fcdd7a">GIVE UP</text>
                        </svg>
                    </xsl:if>

                    <!-- deal and clear buttons - displayed in the betting phase -->
                    <xsl:if test="step ='bet'">
                        <!-- deal button -->
                        <svg id="deal" width="100%" height="100%" viewBox="0 0 100 100">

                            <rect x="51.5" y="89" width="17" height="9" rx="2.5" ry="2.5" stroke-width="0.8" stroke="url(#goldGradient)" filter="url(#f2)"/>
                            <rect x="52" y="89.5" width="16" height="8" rx="2" ry="2" fill="#060C1A" filter="url(#inner-glow)"/>
                            <text x="60" y="93.5" font-family="Arial" font-size="3" text-anchor="middle" alignment-baseline="central"
                                  fill="#fcdd7a">DEAL</text>
                        </svg>

                        <!-- clear button -->
                        <svg id="clear" width="100%" height="100%" viewBox="0 0 100 100">
                            <rect x="31.5" y="89" width="17" height="9" rx="2.5" ry="2.5" stroke-width="0.8" stroke="url(#goldGradient)" filter="url(#f2)"/>
                            <rect x="32" y="89.5" width="16" height="8" rx="2" ry="2" fill="#060C1A" filter="url(#inner-glow)"/>
                            <text x="40" y="93.5" font-family="Arial" font-size="3" text-anchor="middle" alignment-baseline="central"
                                  fill="#fcdd7a">CLEAR</text>
                        </svg>
                    </xsl:if>

                    <!-- exit button - always displayed except when the game is finished -->
                    <xsl:if test="step ='play' or step='bet'">
                        <svg id="close" width="100%" height="100%" viewBox="0 0 100 100">
                            <svg x="133.5" y="-5.7" width="100%" height="100%" >
                                <g transform="scale(.56)" >
                                    <circle cx="20" cy="20" r="5.4" fill="#c33931"/>
                                    <circle cx="20" cy="20" r="5" fill="#f13a44"/>
                                    <circle cx="20" cy="20" r="5" fill="#ee535b" clip-path="url(#cut-off-bottom)"/>
                                    <rect height="8" width="2" x="19" y="16" rx="1" ry="1" fill="white" transform="rotate(45 20 20)"/>
                                    <rect height="8" width="2" x="19" y="16" rx="1" ry="1" fill="white" transform="rotate(-45 20 20)"/>
                                </g>
                            </svg>
                        </svg>
                    </xsl:if>

                </g>

                <!-- bet score for each player & chips design -->
                <g id="bet">

                    <svg id="bet score" width="100%" height="100%" viewBox="0 0 100 100">

                        <!-- text zone for displaying the bet score -->
                        <rect x="-20" y="43" width="8" height="4" rx="0.8" ry="0.8" fill="#0F2822" stroke-width="0.3" stroke="#80A323"/>
                        <rect x="20" y="55" width="8" height="4" rx="0.8" ry="0.8" fill="#0F2822" stroke-width="0.3" stroke="#80A323"/>
                        <rect x="60" y="61" width="8" height="4" rx="0.8" ry="0.8" fill="#0F2822" stroke-width="0.3" stroke="#80A323"/>
                        <rect x="100" y="55" width="8" height="4" rx="0.8" ry="0.8" fill="#0F2822" stroke-width="0.3" stroke="#80A323"/>
                        <rect x="140" y="43" width="8" height="4" rx="0.8" ry="0.8" fill="#0F2822" stroke-width="0.3" stroke="#80A323"/>

                        <!-- bet score for each player -->
                        <text x="-12.7" y="46" font-family="Arial" font-size="3" fill="#EBEBEB" text-anchor="end"> <xsl:value-of select="players/player[tableSeat = 5]/currentBet"/>$</text>
                        <text x="27.3" y="58" font-family="Arial" font-size="3" fill="#EBEBEB" text-anchor="end"> <xsl:value-of select="players/player[tableSeat = 4]/currentBet"/>$</text>
                        <text x="67.3" y="64" font-family="Arial" font-size="3" fill="#EBEBEB" text-anchor="end"><xsl:value-of select="players/player[tableSeat = 3]/currentBet"/>$</text>
                        <text x="107.3" y="58" font-family="Arial" font-size="3" fill="#EBEBEB" text-anchor="end"> <xsl:value-of select="players/player[tableSeat = 2]/currentBet"/>$</text>
                        <text x="147.3" y="46" font-family="Arial" font-size="3" fill="#EBEBEB" text-anchor="end"><xsl:value-of select="players/player[tableSeat = 1]/currentBet"/>$</text>

                    </svg>

                    <!-- all 5 chips design: 50/25/10/5/1 -->
                    <svg id="chips" width="100%" height="100%" viewBox="0 0 100 100">

                        <!-- chip design - 50 -->
                        <svg id="50" x="-5" y="79" width="100%" height="100%" >
                            <g transform="scale(.7)" >
                                <circle cx="20" cy="20" r="7" fill="#b1017d" />
                                <circle cx="20" cy="20" r="7" fill="#C92E9A" clip-path="url(#cut-off-bottom)" />
                                <circle cx="20" cy="20" r="5.4" fill="#6e0369" stroke="url(#goldGradient)" stroke-width=".2" />
                                <circle cx="20" cy="20" r="5" fill="#b1017d"  />
                                <circle cx="20" cy="20" r="5" fill="#C92E9A" clip-path="url(#cut-off-bottom)" />
                                <circle cx="20" cy="20" r="7" fill="#ffffff" clip-path="url(#chip-white-rectangles)"  />
                                <text x="20" y="20" font-family="Arial" font-size="5" text-anchor="middle" alignment-baseline="central"
                                      fill="#ffffff">50</text>
                            </g>
                        </svg>

                        <!-- chip design - 25 -->
                        <svg id="25" x="-18" y="76" width="100%" height="100%" >
                            <g transform="scale(.72)" >
                                <circle cx="20" cy="20" r="7" fill="#19ae4a" />
                                <circle cx="20" cy="20" r="7" fill="#38b561" clip-path="url(#cut-off-bottom)" />
                                <circle cx="20" cy="20" r="5.4" fill="#08772a" stroke="url(#goldGradient)" stroke-width=".2" />
                                <circle cx="20" cy="20" r="5" fill="#19ae4a"  />
                                <circle cx="20" cy="20" r="5" fill="#38b561" clip-path="url(#cut-off-bottom)" />
                                <circle cx="20" cy="20" r="7" fill="#ffffff" clip-path="url(#chip-white-rectangles)"  />
                                <text x="20" y="20" font-family="Arial" font-size="5" text-anchor="middle" alignment-baseline="central"
                                      fill="#ffffff">25</text>
                            </g>
                        </svg>

                        <!-- chip design - 10 -->
                        <svg id="10" x="-31" y="72" width="100%" height="100%" >
                            <g transform="scale(.74)" >
                                <circle cx="20" cy="20" r="7" fill="#f13a44" />
                                <circle cx="20" cy="20" r="7" fill="#ee535b" clip-path="url(#cut-off-bottom)" />
                                <circle cx="20" cy="20" r="5.4" fill="#c33931" stroke="url(#goldGradient)" stroke-width=".2" />
                                <circle cx="20" cy="20" r="5" fill="#f13a44"  />
                                <circle cx="20" cy="20" r="5" fill="#ee535b" clip-path="url(#cut-off-bottom)" />
                                <circle cx="20" cy="20" r="7" fill="#ffffff" clip-path="url(#chip-white-rectangles)"  />
                                <text x="20" y="20" font-family="Arial" font-size="5" text-anchor="middle" alignment-baseline="central"
                                      fill="#ffffff">10</text>
                            </g>
                        </svg>

                        <!-- chip design - 5 -->
                        <svg id="5" x="-44" y="67" width="100%" height="100%" >
                            <g transform="scale(.77)" >
                                <circle cx="20" cy="20" r="7" fill="#f1703b" />
                                <circle cx="20" cy="20" r="7" fill="#f18156" clip-path="url(#cut-off-bottom)" />
                                <circle cx="20" cy="20" r="5.4" fill="#bc3c17" stroke="url(#goldGradient)" stroke-width=".2" />
                                <circle cx="20" cy="20" r="5" fill="#f1703b"  />
                                <circle cx="20" cy="20" r="5" fill="#f18156" clip-path="url(#cut-off-bottom)" />
                                <circle cx="20" cy="20" r="7" fill="#ffffff" clip-path="url(#chip-white-rectangles)"  />
                                <text x="20" y="20" font-family="Arial" font-size="5" text-anchor="middle" alignment-baseline="central"
                                      fill="#ffffff">5</text>
                            </g>
                        </svg>

                        <!-- chip design - 1 -->
                        <svg id="1" x="-57" y="60" width="100%" height="100%" >
                            <g transform="scale(.81)" >
                                <circle cx="20" cy="20" r="7" fill="#febe38" />
                                <circle cx="20" cy="20" r="7" fill="#ffcb5f" clip-path="url(#cut-off-bottom)" />
                                <circle cx="20" cy="20" r="5.4" fill="#ee7005" stroke="url(#goldGradient)" stroke-width=".2" />
                                <circle cx="20" cy="20" r="5" fill="#febe38"  />
                                <circle cx="20" cy="20" r="5" fill="#ffcb5f" clip-path="url(#cut-off-bottom)" />
                                <circle cx="20" cy="20" r="7" fill="#ffffff" clip-path="url(#chip-white-rectangles)"  />
                                <text x="20" y="20" font-family="Arial" font-size="5" text-anchor="middle" alignment-baseline="central"
                                      fill="#ffffff">1</text>
                            </g>
                        </svg>

                    </svg>

                </g>

                <!-- messages, balance, player turn and stickers -->
                <g id="messages">

                    <!-- message box displayed in the top left of the screen - shows various messages -->
                    <svg id="messages box" width="100%" height="100%" viewBox="0 0 100 100">

                        <rect id="rect99" x="-47" y="3" width="53" height="5" rx="0.8" ry="0.8" fill="#0F2822" stroke-width="0.3" stroke="#80A323"/>
                        <text x="-45" y="6.5" font-family="Arial" font-size="3" fill="#EBEBEB" text-anchor="start">
                            <xsl:for-each select="./events/event">
                                <xsl:if test="@id =$playerID or @id = 0">
                                    <xsl:value-of select="message"></xsl:value-of>
                                </xsl:if>
                            </xsl:for-each>
                        </text>

                    </svg>

                    <!-- message box displayed in the top right of the screen - shows the balance of each player -->
                    <svg id="balance box" width="100%" height="100%" viewBox="0 0 100 100">

                        <xsl:if test="./players/player[@id = $playerID]">
                            <rect id="rect99" x="114" y="3" width="25" height="5" rx="0.8" ry="0.8" fill="#0F2822" stroke-width="0.3" stroke="#80A323"/>
                            <text x="116" y="6.5" font-family="Arial" font-size="3" fill="#EBEBEB" text-anchor="start">Balance:</text>
                            <text x="128.5" y="6.5" font-family="Arial" font-size="3" fill="#EBEBEB" text-anchor="start">
                                <xsl:value-of select="round(./players/player[@id = $playerID]/totalmonney - 0.5)"/>$
                            </text>
                        </xsl:if>

                    </svg>

                    <!-- message box displayed in the top next to the balance box - shows "waiting..." or "your turn!" for each player -->
                    <svg id="player turn box" width="100%" height="100%" viewBox="0 0 100 100">

                        <rect id="rect99" x="93" y="3" width="18" height="5" rx="0.8" ry="0.8" fill="#0c5544"/>
                        <xsl:if test="$playerID = players/player[$activePlayer= position()]/@id">
                            <text x="95" y="6.5" font-family="Arial" font-size="3" fill="#80A323" text-anchor="start">
                                Your turn!
                            </text>
                        </xsl:if>
                        <xsl:if test="$playerID != players/player[$activePlayer= position()]/@id">
                            <text x="95" y="6.5" font-family="Arial" font-size="3" fill="#80A323" text-anchor="start">
                                Waiting...
                            </text>
                        </xsl:if>

                    </svg>

                    <!-- stickers (animations) displayed when the player wins (normal win or blackjack), loses or surrenders -->
                    <svg id="stickers" width="100%" height="100%" viewBox="0 0 100 100">

                        <!-- sticker for the blackjack - confetti -->
                        <xsl:if test="players/player[tableSeat =5]/status = 'blackjack'">
                            <image height="20" width="20" x="-40" y="25" xlink:href="http://localhost:8984/static/blackjack/blackjack.gif"/>
                        </xsl:if>

                        <xsl:if test="players/player[tableSeat =4]/status = 'blackjack'">
                            <image height="20" width="20" x="0" y="37" xlink:href="http://localhost:8984/static/blackjack/blackjack.gif"/>
                        </xsl:if>

                        <xsl:if test="players/player[tableSeat =3]/status = 'blackjack'">
                            <image height="20" width="20" x="40" y="43" xlink:href="http://localhost:8984/static/blackjack/blackjack.gif"/>
                        </xsl:if>

                        <xsl:if test="players/player[tableSeat =2]/status = 'blackjack'">
                            <image height="20" width="20" x="80" y="37" xlink:href="http://localhost:8984/static/blackjack/blackjack.gif"/>
                        </xsl:if>

                        <xsl:if test="players/player[tableSeat = 1]/status = 'blackjack'">
                            <image height="20" width="20" x="120" y="25" xlink:href="http://localhost:8984/static/blackjack/blackjack.gif"/>
                        </xsl:if>

                        <!-- sticker for players who surrendered - white flag -->
                        <xsl:if test="players/player[tableSeat=5]/status ='surrendered'">
                            <image height="20" width="20" x="-27" y="43" xlink:href="http://localhost:8984/static/blackjack/whiteFlag.gif"/>
                        </xsl:if>

                        <xsl:if test="players/player[tableSeat=4]/status ='surrendered'">
                            <image height="20" width="20" x="13" y="55" xlink:href="http://localhost:8984/static/blackjack/whiteFlag.gif"/>
                        </xsl:if>

                        <xsl:if test="players/player[tableSeat=3]/status ='surrendered'">
                            <image height="20" width="20" x="53" y="61" xlink:href="http://localhost:8984/static/blackjack/whiteFlag.gif"/>
                        </xsl:if>

                        <xsl:if test="players/player[tableSeat=2]/status ='surrendered'">
                            <image height="20" width="20" x="93" y="55" xlink:href="http://localhost:8984/static/blackjack/whiteFlag.gif"/>
                        </xsl:if>

                        <xsl:if test="players/player[tableSeat=1]/status ='surrendered'">
                            <image height="20" width="20" x="133" y="43" xlink:href="http://localhost:8984/static/blackjack/whiteFlag.gif"/>
                        </xsl:if>

                        <!-- stickers for players who won/lost - hand clap/monster crying -->
                        <xsl:if test="players/player[tableSeat=5]">
                            <xsl:choose>
                                <xsl:when test="players/player[tableSeat=5]/status='loser'">
                                    <image height="12" width="12" x="-23" y="47" xlink:href="http://localhost:8984/static/blackjack/lost.gif"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:if test ="players/player[tableSeat=5]/status !='free' and players/player[tableSeat=5]/status !='surrendered'">
                                        <image height="12" width="12" x="-23" y="47" xlink:href="http://localhost:8984/static/blackjack/clap.webp"/>
                                    </xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>

                        <xsl:if test="players/player[tableSeat=4]">
                            <xsl:choose>
                                <xsl:when test="players/player[tableSeat=4]/status='loser'">
                                    <image height="12" width="12" x="17" y="59" xlink:href="http://localhost:8984/static/blackjack/lost.gif"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:if test="players/player[tableSeat=4]/status !='free' and players/player[tableSeat=4]/status !='surrendered'">
                                        <image height="12" width="12" x="17" y="59" xlink:href="http://localhost:8984/static/blackjack/clap.webp"/>
                                    </xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>

                        <xsl:if test="players/player[tableSeat=3]">
                            <xsl:choose>
                                <xsl:when test="players/player[tableSeat=3]/status='loser'">
                                    <image height="12" width="12" x="57" y="65" xlink:href="http://localhost:8984/static/blackjack/lost.gif"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:if test="players/player[tableSeat=3]/status !='free'and players/player[tableSeat=3]/status !='surrendered'">
                                        <image height="12" width="12" x="57" y="65" xlink:href="http://localhost:8984/static/blackjack/clap.webp"/>
                                    </xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>

                        <xsl:if test="players/player[tableSeat=2]">
                            <xsl:choose>
                                <xsl:when test="players/player[tableSeat=2]/status='loser'">
                                    <image height="12" width="12" x="97" y="59" xlink:href="http://localhost:8984/static/blackjack/lost.gif"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:if test="players/player[tableSeat=2]/status !='free' and players/player[tableSeat=2]/status !='surrendered'">
                                        <image height="12" width="12" x="97" y="59" xlink:href="http://localhost:8984/static/blackjack/clap.webp"/>
                                    </xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>

                        <xsl:if test="players/player[tableSeat=1]">
                            <xsl:choose>
                                <xsl:when test="players/player[tableSeat=1]/status='loser'">
                                    <image height="12" width="12" x="137" y="47" xlink:href="http://localhost:8984/static/blackjack/lost.gif"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:if test="players/player[tableSeat=1]/status !='free' and players/player[tableSeat=1]/status !='surrendered'">
                                        <image height="12" width="12" x="137" y="47" xlink:href="http://localhost:8984/static/blackjack/clap.webp"/>
                                    </xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>

                    </svg>

                </g>

                <!-- cards -->
                <g id="cards" transform="scale(0.5)">

                    <xsl:apply-templates select="dealer"/>
                    <xsl:apply-templates select="players/player"/>

                </g>

            </defs>

            <!-- display of all created elements -->
            <use href="#background"/>
            <use href="#table"/>
            <use href="#players"/>
            <use href="#buttons"/>
            <use href="#bet"/>
            <use href="#cards"/>
            <use href="#messages"/>


            <!-- Invisible iframe to throw away results of POST request -->
            <foreignObject width="0" height="0">
                <iframe class = "hiddenFrame" xmlns = "http://www.w3.org/1999/xhtml" name="hiddenFrame"></iframe>
            </foreignObject>

            <!-- buttons active during the betting phase -->
            <xsl:if test="step = 'bet'">

                <xsl:if test="$playerID = players/player[$activePlayer= position()]/@id">

                    <!-- chip button, value = 1 -->
                    <foreignObject x="1.8%" y="70.5%" width="100%" height="100%" >
                        <xsl:variable name="executeTurnLink" select="concat('/bj/bet/', $id,'/1')" />
                        <form xmlns="http://www.w3.org/1999/xhtml" action="{$executeTurnLink}" method="POST" id="form1" target="hiddenFrame" style="display: inline;">
                            <button type="submit" form="form1" value="Submit" style="height:102px; width:102px;
                     border-radius: 51px; border: none; background-color: Transparent; outline:none;"></button>
                        </form>
                    </foreignObject>

                    <!-- chip button, value = 5 -->
                    <foreignObject x="8%" y="77%" width="100%" height="100%" >
                        <form xmlns="http://www.w3.org/1999/xhtml" action="/bj/bet/{$id}/5"  method="POST" id="form5" style="display: inline;" target="hiddenFrame" >
                            <button type="submit" form="form5" value="Submit" style="height:98px; width:98px;
                    border-radius: 49px; border: none; background-color: Transparent; outline:none;"></button>
                        </form>
                    </foreignObject>

                    <!-- chip button, value = 10 -->
                    <foreignObject x="14.3%" y="81.6%" width="100%" height="100%" >
                        <form xmlns="http://www.w3.org/1999/xhtml" action="/bj/bet/{$id}/10"  method="POST" id="form10" style="display: inline;" target="hiddenFrame" >
                            <button type="submit" form="form10" value="Submit" style="height:94px; width:94px;
                    border-radius: 46px; border: none; background-color: Transparent; outline:none;"></button>
                        </form>
                    </foreignObject>

                    <!-- chip button, value = 25 -->
                    <foreignObject x="20.7%" y="85.3%" width="100%" height="100%" >
                        <form xmlns="http://www.w3.org/1999/xhtml" action="/bj/bet/{$id}/25" method="POST" id="form25" style="display: inline;"  target="hiddenFrame">
                            <button type="submit" form="form25" value="Submit" style="height:90px; width:90px;
                    border-radius: 45px; border: none; background-color: Transparent; outline:none;"></button>
                        </form>
                    </foreignObject>

                    <!-- chip button, value = 50 -->
                    <foreignObject x="27%" y="88%" width="100%" height="100%" >
                        <form xmlns="http://www.w3.org/1999/xhtml" action="/bj/bet/{$id}/50" method="POST" id="form50" style="display: inline;" target="hiddenFrame">
                            <button type="submit" form="form50" value="Submit" style="height:90px; width:90px;
                    border-radius: 45px; border: none; background-color: Transparent; outline:none;"></button>
                        </form>
                    </foreignObject>

                    <!-- clear button -->
                    <foreignObject x="40.5%" y="88.7%" width="100%" height="100%" >
                        <form xmlns="http://www.w3.org/1999/xhtml" action="/bj/clear/{$id}" method="post" id="formClear" style="display: inline;"  target="hiddenFrame">
                            <button type="submit" form="formClear" value="Submit" style="height:86px; width:160px;
                    border-radius: 25px; border: none; background-color: Transparent; outline:none;"></button>
                        </form>
                    </foreignObject>

                    <!-- deal button -->
                    <foreignObject x="50.5%" y="88.7%" width="100%" height="100%" >
                        <form xmlns="http://www.w3.org/1999/xhtml" action="/bj/nextBet/{$id}" method="post" id="formDeal" style="display: inline;" target="hiddenFrame" >
                            <button type="submit" form="formDeal" value="Submit" style="height:86px; width:160px;
                    border-radius: 25px; border: none; background-color: Transparent; outline:none;"></button>
                        </form>
                    </foreignObject>

                </xsl:if>

            </xsl:if>

            <!-- new round button -->
            <xsl:if test="step ='roundOver'">
                <foreignObject x="44.5%" y="88.7%" width="100%" height="100%" >
                    <form xmlns="http://www.w3.org/1999/xhtml" action="/bj/newRound/{$id}" method="get" id="formNewRound" style="display: inline;" target="hiddenFrame" >
                        <button type="submit" form="formNewRound" value="Submit" style="height:86px; width:197px;
                    border-radius: 25px; border: none; background-color: Transparent; outline:none;"></button>
                    </form>
                </foreignObject>
            </xsl:if>

            <!-- exit button -->
            <xsl:if test="step ='bet' or step='play'">
                <foreignObject x="95.85%" y="2.5%"  width="100%" height="100%" >
                    <form xmlns="http://www.w3.org/1999/xhtml" action="/bj/exitGame/{$id}/{$playerID}" method="post" id="formExit" style="display: inline;"  target="hiddenFrame">
                        <button   type="submit" form="formExit" value="Submit" style="height:54px; width:54px;
                             border-radius: 27px; border: none; background-color: Transparent; outline:none;"></button>
                    </form>
                </foreignObject>
            </xsl:if>

            <!-- buttons active during the game -->
            <xsl:if test="step ='play'">

                <xsl:if test="$playerID = players/player[$activePlayer= position()]/@id">

                    <!-- give up button -->
                    <foreignObject x="45.5%" y="88.7%" width="100%" height="100%" >
                        <form xmlns="http://www.w3.org/1999/xhtml" action="/bj/surrender/{$id}" method="POST" id="formGiveUp" style="display: inline;"  target="hiddenFrame" >
                            <button type="submit" form="formGiveUp" value="Submit" style="height:86px; width:160px;
                    border-radius: 25px; border: none; background-color: Transparent; outline:none;"></button>
                        </form>
                    </foreignObject>

                    <!-- hit button -->
                    <foreignObject x="71.9%" y="84.7%"  width="100%" height="100%" >
                        <form xmlns="http://www.w3.org/1999/xhtml" action="/bj/hit/{$id}" method="post" id="formHit" style="display: inline;"  target="hiddenFrame">
                            <button   type="submit" form="formHit" value="Submit" style="height:114px; width:114px;
                             border-radius: 57px; border: none; background-color: Transparent; outline:none;"></button>
                        </form>
                    </foreignObject>

                    <!-- stand button -->
                    <foreignObject x="81.5%" y="80%"  width="100%" height="100%" >
                        <form xmlns="http://www.w3.org/1999/xhtml" action="/bj/stand/{$id}" method="post" id="formStand" style="display: inline;" target="hiddenFrame" >
                            <button type="submit" form="formStand" value="Submit" style="height:126px; width:126px;
                            border-radius: 63px; border: none; background-color: Transparent; outline:none;"></button>
                        </form>
                    </foreignObject>

                    <!-- double button -->
                    <foreignObject x="91%" y="72.1%" width="100%" height="100%" >
                        <form xmlns="http://www.w3.org/1999/xhtml" action="/bj/double/{$id}" method="post" id="formDouble" style="display: inline;" target="hiddenFrame">
                            <button type="submit" form="formDouble" value="Submit" style="height:140px; width:140px;
                            border-radius: 70px; border: none; background-color: Transparent; outline:none;"></button>
                        </form>
                    </foreignObject>

                </xsl:if>

            </xsl:if>

        </svg>

    </xsl:template>

    <!-- dealer template -->
    <xsl:template match="dealer">

        <xsl:value-of select ="name"/>
        <xsl:variable name="totalNumberCards" select="count(./cards/card)"/>

        <!-- displays the cards for the dealer -->
        <xsl:for-each select="./cards/card">
            <xsl:variable name="counter" select="position() - 1"/>

            <svg x="{1708-($counter)*40+(($totalNumberCards)-1)*20}" y="{150 - ($counter)*15}">
                <xsl:call-template name="playerCard"/>
            </svg>

            <xsl:if test="//step !='roundOver'">
                <xsl:if test="$counter = 0">

                    <!-- flipped card pattern design -->
                    <defs>
                        <pattern id="Pattern" x="0" y="0" width="15" height="15" patternUnits="userSpaceOnUse">
                            <rect x="7.5" y="-3.75" width="7.5" height="7.5" fill="green" transform="rotate(45)"/>
                            <rect x="10.5" y="3" width="6" height="4.5" fill="orange" transform="rotate(45)"/>
                            <rect x="12" y="-6" width="3" height="4.5" fill="DarkOrange" transform="rotate(45)"/>
                            <circle cx="0" cy="0" r="6" fill="black" />
                            <circle cx="15" cy="15" r="6" fill="black" />
                        </pattern>
                    </defs>

                    <!-- flipped card - covers the 2nd card of the dealer -->
                    <svg x="1728" y="150" width="225" height="340">
                        <svg width="185" height="300">
                            <rect width="185" height="300" rx="10" ry="10" fill="white"/>
                            <rect x="5" y="5" width="175" height="290" rx="10" ry="10" fill="url(#Pattern)"/>
                        </svg>
                    </svg>

                </xsl:if>

            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <!-- player template -->
    <xsl:template match="player">
        <xsl:value-of select ="name"/>

        <xsl:value-of select="totalmonney"/>
        <xsl:variable name="totalNumberCards" select="count(./cards/card)"/>

        <!-- displays the cards for the 1st player -->
        <xsl:if test="tableSeat='1'">
            <text x="-27" y="58" font-size="4" fill="#80A323" text-anchor="end"><xsl:value-of select="currentBet"/></text>
            <xsl:for-each select="./cards/card">
                <xsl:variable name="counter" select="position() - 1"/>
                <svg x="{3146-($counter)*40+(($totalNumberCards)-1)*20}" y="{600 - ($counter)*15}">
                    <xsl:call-template name="playerCard"/>
                </svg>
            </xsl:for-each>
        </xsl:if>

        <!-- displays the cards for the 2nd player -->
        <xsl:if test="tableSeat='2'">
            <xsl:for-each select="./cards/card">
                <xsl:variable name="counter" select="position() - 1"/>
                <svg x="{2425-($counter)*40+(($totalNumberCards)-1)*20}" y="{810 - ($counter)*15}">
                    <xsl:call-template name="playerCard"/>
                </svg>
            </xsl:for-each>
        </xsl:if>

        <!-- displays the cards for the 3rd player -->
        <xsl:if test="tableSeat='3'">
            <xsl:for-each select="./cards/card">
                <xsl:variable name="counter" select="position() - 1"/>
                <svg x="{1708-($counter)*40+(($totalNumberCards)-1)*20}" y="{920 - ($counter)*15}">
                    <xsl:call-template name="playerCard"/>
                </svg>
            </xsl:for-each>
        </xsl:if>

        <!-- displays the cards for the 4th player -->
        <xsl:if test="tableSeat='4'">
            <xsl:for-each select="./cards/card">
                <xsl:variable name="counter" select="position() - 1"/>
                <svg x="{985-($counter)*40+(($totalNumberCards)-1)*20}" y="{810 - ($counter)*15}">
                    <xsl:call-template name="playerCard"/>
                </svg>
            </xsl:for-each>
        </xsl:if>

        <!-- displays the cards for the 5th player -->
        <xsl:if test="tableSeat='5'">
            <xsl:for-each select="./cards/card">
                <xsl:variable name="counter" select="position() - 1"/>
                <svg x="{265-($counter)*40+(($totalNumberCards)-1)*20}" y="{600 - ($counter)*15}">
                    <xsl:call-template name="playerCard"/>
                </svg>
            </xsl:for-each>
        </xsl:if>

    </xsl:template>
    <xsl:template name="playerCard" match="card">
        <xsl:include href="bj_global_variables.xsl" />

        <xsl:variable name="number" select="card/card_number"/>
        <xsl:variable name="color" select="color"/>

        <!-- card design, value = A -->
        <xsl:if test="card_number='A'">
            <svg width="{$cardWidthDimension}" height="{$cardHeightDimension}" filter="url(#f1)">
                <svg width="{$cardWidth}" height="{$cardHeight}">
                    <rect width="185" height="300" rx="10" ry="10" fill="white"/>
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="18" y="20" font-size ="25" fill="{$color}" >A</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)" x="-167" y="-280" font-size ="25" fill="{$color}">A</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="167" y="20" font-size ="25" fill="{$color} ">A</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)" x="-18" y="-280" font-size="25" fill="{$color}">A</text>
                    <text class="cardTexth"  x="{$cardRightPosition}%" y="{$cardDownPosition}%" dominant-baseline="middle" text-anchor="middle" font-size="18" fill="{$color}">  <xsl:value-of select="card_type"/></text>
                    <text class="cardTexth"  x="{$cardLeftPosition}%" y="{$cardDownPosition}%" dominant-baseline="middle" text-anchor="middle" font-size="18" fill="{$color}"> <xsl:value-of select="card_type"/></text>
                    <text class="cardTexth"  x="-{$cardRightPosition}%" y="{$cardTopPosition}%"  dominant-baseline="middle" text-anchor="middle" transform="scale(-1,-1)" font-size="18" fill="{$color}"> <xsl:value-of select="card_type"/></text>
                    <text class="cardTexth"  x="-{$cardLeftPosition}%" y="{$cardTopPosition}%"  dominant-baseline="middle" text-anchor="middle" transform="scale(-1,-1)" font-size="18" fill="{$color}"> <xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine2}%" y="{$HorLine6}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size="50"> <xsl:value-of select="card_type"/></text>
                </svg>
            </svg>
        </xsl:if>

        <!-- card design, value = 2 -->
        <xsl:if test="card_number='2'">
            <svg width="{$cardWidthDimension}" height="{$cardHeightDimension}" filter="url(#f1)">
                <svg width="{$cardWidth}" height="{$cardHeight}">
                    <rect width="185" height="300" rx="10" ry="10" fill="white"/>
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="18" y="20"  fill="{$color}" font-size ="25">2</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)" x="-167" y="-280"  fill="{$color}" font-size ="25">2</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="167" y="20" fill="{$color}" font-size ="25">2</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)" x="-18" y="-280"  fill="{$color}" font-size ="25" >2</text>
                    <text class="cardTexth"  x="{$cardRightPosition}%" y="{$cardDownPosition}%" dominant-baseline="middle" text-anchor="middle"  fill="{$color}" font-size ="18"><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth"  x="{$cardLeftPosition}%" y="{$cardDownPosition}%" dominant-baseline="middle" text-anchor="middle"  fill="{$color}" font-size ="18"><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth"  x="-{$cardRightPosition}%" y="{$cardTopPosition}%"  fill="{$color}" dominant-baseline="middle" text-anchor="middle" transform="scale(-1,-1)" font-size ="18"><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth"  x="-{$cardLeftPosition}%" y="{$cardTopPosition}%"  fill="{$color}" dominant-baseline="middle" text-anchor="middle" transform="scale(-1,-1)" font-size ="18"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine2}%" y="{$HorLine2}%" dominant-baseline="middle" text-anchor="middle"  fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine2}%" y="{$HorLine10}%" dominant-baseline="middle" text-anchor="middle"  fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                </svg>
            </svg>
        </xsl:if>

        <!-- card design, value = 3 -->
        <xsl:if test="card_number='3'">
            <svg width="{$cardWidthDimension}" height="{$cardHeightDimension}" filter="url(#f1)">
                <svg width="{$cardWidth}" height="{$cardHeight}">
                    <rect width="185" height="300" rx="10" ry="10" fill="white"/>
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="18" y="20" font-size ="25" fill="{$color}">3</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)" x="-167" y="-280" font-size ="25" fill="{$color}">3</text>
                    <text class="cardTexth"  x="{$cardRightPosition}%" y="{$cardDownPosition}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="18"><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth"  x="{$cardLeftPosition}%" y="{$cardDownPosition}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="18"><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth"  x="-{$cardRightPosition}%" y="{$cardTopPosition}%" fill="{$color}" dominant-baseline="middle" text-anchor="middle" transform="scale(-1,-1)" font-size ="18"><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth"  x="-{$cardLeftPosition}%" y="{$cardTopPosition}%" fill="{$color}" dominant-baseline="middle" text-anchor="middle" transform="scale(-1,-1)" font-size ="18"><xsl:value-of select="card_type"/></text>
                    <text class="cardText"  text-anchor="middle" dy="0.3em" x="167" y="20" font-size ="25" fill="{$color}" >3</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)" x="-18" y="-280" font-size ="25" fill="{$color}">3</text>
                    <text class="cardTextBig"  x="{$VerLine2}%" y="{$HorLine2}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine2}%" y="{$HorLine6}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine2}%" y="{$HorLine10}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                </svg>
            </svg>
        </xsl:if>

        <!-- card design, value = 4 -->
        <xsl:if test="card_number='4'">
            <svg width="{$cardWidthDimension}" height="{$cardHeightDimension}" filter="url(#f1)">
                <svg width="{$cardWidth}" height="{$cardHeight}">
                    <rect width="185" height="300" rx="10" ry="10" fill="white"/>
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="18" y="20" fill="{$color}" font-size ="25" >4</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)" x="-167" y="-280" fill="{$color}" font-size ="25" >4</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="167" y="20" fill="{$color}" font-size ="25" >4</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)" x="-18" y="-280" fill="{$color}" font-size ="25" >4</text>
                    <text class="cardTexth"  x="{$cardRightPosition}%" y="{$cardDownPosition}%" dominant-baseline="middle" text-anchor="middle"  fill="{$color}" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth"  x="{$cardLeftPosition}%" y="{$cardDownPosition}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="18"  ><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth"  x="-{$cardRightPosition}%" y="{$cardTopPosition}%" fill="{$color}" dominant-baseline="middle" text-anchor="middle" transform="scale(-1,-1)" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth"  x="-{$cardLeftPosition}%" y="{$cardTopPosition}%" fill="{$color}" dominant-baseline="middle" text-anchor="middle" transform="scale(-1,-1)" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig "  x="{$VerLine1}%" y="{$HorLine2}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine1}%" y="{$HorLine10}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine3}%" y="{$HorLine2}%" dominant-baseline="middle" text-anchor="middle"  fill="{$color}" font-size ="50" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine3}%" y="{$HorLine10}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50" ><xsl:value-of select="card_type"/></text>
                </svg>
            </svg>
        </xsl:if>

        <!-- card design, value = 5 -->
        <xsl:if test="card_number='5'">
            <svg width="{$cardWidthDimension}" height="{$cardHeightDimension}" filter="url(#f1)">
                <svg width="{$cardWidth}" height="{$cardHeight}">
                    <rect width="185" height="300" rx="10" ry="10" fill="white"/>
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="18" y="20" fill="{$color}" font-size ="25" >5</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)" x="-167" y="-280" fill="{$color}" font-size ="25" >5</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="167" y="20" fill="{$color}" font-size ="25" >5</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)" x="-18" y="-280" fill="{$color}" font-size ="25" >5</text>
                    <text class="cardTexth"  x="{$cardRightPosition}%" y="{$cardDownPosition}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth"  x="{$cardLeftPosition}%" y="{$cardDownPosition}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth"  x="-{$cardRightPosition}%" y="{$cardTopPosition}%" fill="{$color}" dominant-baseline="middle" text-anchor="middle" transform="scale(-1,-1)" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth"  x="-{$cardLeftPosition}%" y="{$cardTopPosition}%" fill="{$color}" dominant-baseline="middle" text-anchor="middle" transform="scale(-1,-1)" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine1}%" y="{$HorLine2}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine1}%" y="{$HorLine10}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine3}%" y="{$HorLine2}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine3}%" y="{$HorLine10}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine2}%" y="{$HorLine6}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50" ><xsl:value-of select="card_type"/></text>
                </svg>
            </svg>
        </xsl:if>

        <!-- card design, value = 6 -->
        <xsl:if test="card_number='6'">
            <svg width="{$cardWidthDimension}" height="{$cardHeightDimension}" filter="url(#f1)">
                <svg width="{$cardWidth}" height="{$cardHeight}">
                    <rect width="185" height="300" rx="10" ry="10" fill="white"/>
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="18" y="20" fill="{$color}" font-size ="25" >6</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)" x="-167" y="-280" fill="{$color}" font-size ="25" >6</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="167" y="20" fill="{$color}" font-size ="25" >6</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)" x="-18" y="-280" fill="{$color}" font-size ="25" >6</text>
                    <text class="cardTexth"  x="{$cardRightPosition}%" y="{$cardDownPosition}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth"  x="{$cardLeftPosition}%" y="{$cardDownPosition}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth"  x="-{$cardRightPosition}%" y="{$cardTopPosition}%" fill="{$color}" dominant-baseline="middle" text-anchor="middle" transform="scale(-1,-1)" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth"  x="-{$cardLeftPosition}%" y="{$cardTopPosition}%" fill="{$color}" dominant-baseline="middle" text-anchor="middle" transform="scale(-1,-1)" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine1}%" y="{$HorLine2}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine1}%" y="{$HorLine6}%" dominant-baseline="middle" text-anchor="middle"  fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine1}%" y="{$HorLine10}%" dominant-baseline="middle" text-anchor="middle"  fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine3}%" y="{$HorLine2}%" dominant-baseline="middle" text-anchor="middle"  fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine3}%" y="{$HorLine6}%" dominant-baseline="middle" text-anchor="middle"  fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine3}%" y="{$HorLine10}%" dominant-baseline="middle" text-anchor="middle"  fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                </svg>
            </svg>
        </xsl:if>

        <!-- card design, value = 7 -->
        <xsl:if test="card_number='7'">
            <svg width="{$cardWidthDimension}" height="{$cardHeightDimension}" filter="url(#f1)">
                <svg width="{$cardWidth}" height="{$cardHeight}">
                    <rect width="185" height="300" rx="10" ry="10" fill="white"/>
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="18" y="20" fill="{$color}" font-size ="25" >7</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)" x="-167" y="-280" fill="{$color}" font-size ="25" >7</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="167" y="20" fill="{$color}" font-size ="25" >7</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)" x="-18" y="-280" fill="{$color}" font-size ="25" >7</text>
                    <text class="cardTexth"  x="{$cardRightPosition}%" y="{$cardDownPosition}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth"  x="{$cardLeftPosition}%" y="{$cardDownPosition}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth"  x="-{$cardRightPosition}%" y="{$cardTopPosition}%" fill="{$color}" dominant-baseline="middle" text-anchor="middle" transform="scale(-1,-1)" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth"  x="-{$cardLeftPosition}%" y="{$cardTopPosition}%" fill="{$color}" dominant-baseline="middle" text-anchor="middle" transform="scale(-1,-1)" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine1}%" y="{$HorLine2}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine1}%" y="{$HorLine6}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine1}%" y="{$HorLine10}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine3}%" y="{$HorLine2}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine3}%" y="{$HorLine6}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine3}%" y="{$HorLine10}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine2}%" y="{$HorLine4}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                </svg>
            </svg>
        </xsl:if>

        <!-- card design, value = 8 -->
        <xsl:if test="card_number='8'">
            <svg width="{$cardWidthDimension}" height="{$cardHeightDimension}" filter="url(#f1)">
                <svg width="{$cardWidth}" height="{$cardHeight}">
                    <rect width="185" height="300" rx="10" ry="10" fill="white"/>
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="18" y="20" fill="{$color}" font-size ="25" >8</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)" x="-167" y="-280" fill="{$color}" font-size ="25" >8</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="167" y="20" fill="{$color}" font-size ="25" >8</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)" x="-18" y="-280" fill="{$color}" font-size ="25" >8</text>
                    <text class="cardTexth"  x="{$cardRightPosition}%" y="{$cardDownPosition}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth"  x="{$cardLeftPosition}%" y="{$cardDownPosition}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth"  x="-{$cardRightPosition}%" y="{$cardTopPosition}%" fill="{$color}" dominant-baseline="middle" text-anchor="middle" transform="scale(-1,-1)" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth"  x="-{$cardLeftPosition}%" y="{$cardTopPosition}%" fill="{$color}" dominant-baseline="middle" text-anchor="middle" transform="scale(-1,-1)" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine1}%" y="{$HorLine2}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine1}%" y="{$HorLine6}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine1}%" y="{$HorLine10}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine3}%" y="{$HorLine2}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine3}%" y="{$HorLine6}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine3}%" y="{$HorLine10}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine2}%" y="{$HorLine4}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine2}%" y="{$HorLine8}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                </svg>
            </svg>
        </xsl:if>

        <!-- card design, value = 9 -->
        <xsl:if test="card_number='9'">
            <svg width="{$cardWidthDimension}" height="{$cardHeightDimension}" filter="url(#f1)">
                <svg width="{$cardWidth}" height="{$cardHeight}">
                    <rect width="185" height="300" rx="10" ry="10" fill="white"/>
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="18" y="20" fill="{$color}" font-size ="25" >9</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)" x="-167" y="-280" fill="{$color}" font-size ="25" >9</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="167" y="20" fill="{$color}" font-size ="25" >9</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)" x="-18" y="-280" fill="{$color}" font-size ="25" >9</text>
                    <text class="cardTexth"  x="{$cardRightPosition}%" y="{$cardDownPosition}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth"  x="{$cardLeftPosition}%" y="{$cardDownPosition}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth"  x="-{$cardRightPosition}%" y="{$cardTopPosition}%" fill="{$color}" dominant-baseline="middle" text-anchor="middle" transform="scale(-1,-1)" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth"  x="-{$cardLeftPosition}%" y="{$cardTopPosition}%" fill="{$color}" dominant-baseline="middle" text-anchor="middle" transform="scale(-1,-1)" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine1}%" y="{$HorLine1}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine1}%" y="{$HorLine5}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine1}%" y="{$HorLine7}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine1}%" y="{$HorLine11}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine3}%" y="{$HorLine1}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine3}%" y="{$HorLine5}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine3}%" y="{$HorLine7}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine3}%" y="{$HorLine11}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine2}%" y="{$HorLine6}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                </svg>
            </svg>
        </xsl:if>

        <!-- card design, value = 10 -->
        <xsl:if test="card_number='10'">
            <svg width="{$cardWidthDimension}" height="{$cardHeightDimension}" filter="url(#f1)">
                <svg width="{$cardWidth}" height="{$cardHeight}">
                    <rect width="185" height="300" rx="10" ry="10" fill="white"/>
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="18" y="20" fill="{$color}" font-size ="25" >10</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)" x="-167" y="-280" fill="{$color}" font-size ="25" >10</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="167" y="20" fill="{$color}" font-size ="25" >10</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)" x="-18" y="-280" fill="{$color}" font-size ="25" >10</text>
                    <text class="cardTexth"  x="{$cardRightPosition}%" y="{$cardDownPosition}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth"  x="{$cardLeftPosition}%" y="{$cardDownPosition}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth"  x="-{$cardRightPosition}%" y="{$cardTopPosition}%" fill="{$color}" dominant-baseline="middle" text-anchor="middle" transform="scale(-1,-1)" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth"  x="-{$cardLeftPosition}%" y="{$cardTopPosition}%" fill="{$color}" dominant-baseline="middle" text-anchor="middle" transform="scale(-1,-1)" font-size ="18" ><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine1}%" y="{$HorLine1}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine1}%" y="{$HorLine5}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine1}%" y="{$HorLine7}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine1}%" y="{$HorLine11}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine3}%" y="{$HorLine1}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine3}%" y="{$HorLine5}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine3}%" y="{$HorLine7}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine3}%" y="{$HorLine11}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine2}%" y="{$HorLine3}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                    <text class="cardTextBig"  x="{$VerLine2}%" y="{$HorLine9}%" dominant-baseline="middle" text-anchor="middle" fill="{$color}" font-size ="50"><xsl:value-of select="card_type"/></text>
                </svg>
            </svg>
        </xsl:if>

        <!-- card design, value = J -->
        <xsl:if test="card_number='J'">
            <svg width="{$cardWidthDimension}" height="{$cardHeightDimension}" filter="url(#f1)">
                <svg width="{$cardWidth}" height="{$cardHeight}">
                    <rect width="{$cardWidth}" height="{$cardHeight}" rx="10" ry="10" fill="white"/>
                    <image width="{$cardWidth - 5}" height="{$cardHeight - 17}" y="8.5" x="2.5" href="http://localhost:8984/static/blackjack/Jack.png"/>
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="18" y="20" font-size="25"  fill="{$color}">J</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)" x="-167" y="-280" font-size="25"  fill="{$color}">J</text>
                    <text class="cardTexth"  x="154" y="65"  fill="{$color}" font-size="35"><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth"  x="3" y="65"  fill="{$color}" font-size="35"><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth"  x="-30.5" y="-235"  fill="{$color}" transform="scale(-1,-1)" font-size="35"><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth"  x="-181.5" y="-235"  fill="{$color}" transform="scale(-1,-1)" font-size="35"><xsl:value-of select="card_type"/></text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="167" y="20" font-size="25"  fill="{$color}">J</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)" x="-18" y="-280" font-size="25"  fill="{$color}">J</text>
                </svg>
            </svg>
        </xsl:if>

        <!-- card design, value = Q -->
        <xsl:if test="card_number='Q'">
            <svg width="{$cardWidthDimension}" height="{$cardHeightDimension}" filter="url(#f1)">
                <svg width="{$cardWidth}" height="{$cardHeight}" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
                    <rect width="{$cardWidth}" height="{$cardHeight}" rx="10" ry="10" fill="white"/>
                    <image width="{$cardWidth - 5}" height="{$cardHeight - 17}"      y="8.5" x="2.5" href="http://localhost:8984/static/blackjack/Queen.png"/>
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="18" y="20" font-size="25"  fill="{$color}">Q</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)" x="-167" y="-280" font-size="25"  fill="{$color}">Q</text>
                    <text class="cardTexth"  x="154" y="65"  fill="{$color}" font-size="35"><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth"  x="3" y="65"  fill="{$color}" font-size="35"><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth"  x="-30.5" y="-235"  fill="{$color}" transform="scale(-1,-1)" font-size="35"><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth"  x="-181.5" y="-235"  fill="{$color}" transform="scale(-1,-1)" font-size="35"><xsl:value-of select="card_type"/></text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="167" y="20" font-size="25"  fill="{$color}">Q</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)" x="-18" y="-280" font-size="25"  fill="{$color}">Q</text>
                </svg>
            </svg>
        </xsl:if>

        <!-- card design, value = K -->
        <xsl:if test="card_number='K'">
            <svg width="{$cardWidthDimension}" height="{$cardHeightDimension}" filter="url(#f1)">
                <svg width="{$cardWidth}" height="{$cardHeight}" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
                    <rect width="{$cardWidth}" height="{$cardHeight}" rx="10" ry="10" fill="white"/>
                    <image width="{$cardWidth - 5}" height="{$cardHeight - 17}" y="8.5" x="2.5"  href="http://localhost:8984/static/blackjack/King.png"/>
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="18" y="20" font-size="25"  fill="{$color}">K</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)" x="-167" y="-280" font-size="25"  fill="{$color}">K</text>
                    <text class="cardTexth"  x="154" y="65"  fill="{$color}" font-size="35"><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth"  x="3" y="65"  fill="{$color}" font-size="35"><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth"  x="-30.5" y="-235"  fill="{$color}" transform="scale(-1,-1)" font-size="35"><xsl:value-of select="card_type"/></text>
                    <text class="cardTexth"  x="-181.5" y="-235"  fill="{$color}" transform="scale(-1,-1)" font-size="35"><xsl:value-of select="card_type"/></text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" x="167" y="20" font-size="25"  fill="{$color}">K</text>
                    <text class="cardText" text-anchor="middle" dy="0.3em" transform="scale(-1,-1)" x="-18" y="-280" font-size="25"  fill="{$color}">K</text>
                </svg>
            </svg>
        </xsl:if>

    </xsl:template>

</xsl:stylesheet>
