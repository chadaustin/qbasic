'
'                         Q B a s i c   N i b b l e s
'
'                   Copyright (C) Microsoft Corporation 1990
'
' Nibbles is a game for one or two players.  Navigate your snakes
' around the game board trying to eat up numbers while avoiding
' running into walls or other snakes.  The more numbers you eat up,
' the more points you gain and the longer your snake becomes.
'
' To run this game, press Shift+F5.
'
' To exit QBasic, press Alt, F, X.
'
' To get help on a BASIC keyword, move the cursor to the keyword and press
' F1 or click the right mouse button.
'

DEFINT A-Z

TYPE snakeBody
 row AS INTEGER
 col AS INTEGER
END TYPE

TYPE snaketype
 head      AS INTEGER
 length    AS INTEGER
 row       AS INTEGER
 col       AS INTEGER
 direction AS INTEGER
 lives     AS INTEGER
 score     AS INTEGER
 scolor    AS INTEGER
 alive     AS INTEGER
END TYPE

TYPE arenaType
 realRow AS INTEGER
 acolor  AS INTEGER
 sister  AS INTEGER
END TYPE

DECLARE SUB SpacePause (text$)
DECLARE SUB PrintScore (NumPlayers%, score1%, score2%, lives1%, lives2%)
DECLARE SUB Intro ()
DECLARE SUB GetInputs (NumPlayers, speed, diff$, monitor$)
DECLARE SUB DrawScreen ()
DECLARE SUB PlayNibbles (NumPlayers, speed, diff$)
DECLARE SUB Set (row, col, acolor)
DECLARE SUB Center (row, text$)
DECLARE SUB DoIntro ()
DECLARE SUB Initialize ()
DECLARE SUB SparklePause ()
DECLARE SUB Level (WhatToDO, sammy() AS snaketype)
DECLARE SUB InitColors ()
DECLARE SUB EraseSnake (snake() AS ANY, snakeBod() AS ANY, snakeNum%)
DECLARE FUNCTION StillWantsToPlay ()
DECLARE FUNCTION PointIsThere (row, col, backColor)

 DIM SHARED arena(1 TO 50, 1 TO 80) AS arenaType
 DIM SHARED curLevel, colorTable(1 TO 6)

 RANDOMIZE TIMER
 GOSUB ClearKeyLocks
 Intro
 GetInputs NumPlayers, speed, diff$, monitor$
 GOSUB SetColors
 DrawScreen
 DO
  PlayNibbles NumPlayers, speed, diff$
 LOOP WHILE StillWantsToPlay
 GOSUB RestoreKeyLocks
 COLOR 15, 0
 CLS
 END

ClearKeyLocks:
 DEF SEG = 0
 KeyFlags = PEEK(1047)
 POKE 1047, &H0
 DEF SEG
RETURN

RestoreKeyLocks:
 DEF SEG = 0
 POKE 1047, KeyFlags
 DEF SEG
RETURN

SetColors:
 IF monitor$ = "M" THEN RESTORE mono ELSE RESTORE normal
 FOR x = 1 TO 6
  READ colorTable(x)
 NEXT
RETURN

mono: DATA 15, 7, 7, 0, 15, 0
normal: DATA 14, 13, 12, 1, 15, 4

SUB Center (row, text$)
 LOCATE row, 41 - LEN(text$) / 2
 PRINT text$;
END SUB

SUB DrawScreen
 VIEW PRINT
 COLOR colorTable(1), colorTable(4)
 CLS
 Center 1, "Nibbles!"
 Center 11, "Initializing Playing Field..."
 FOR row = 1 TO 50
  FOR col = 1 TO 80
   arena(row, col).realRow = INT((row + 1) / 2)
   arena(row, col).sister = (row MOD 2) * 2 - 1
  NEXT
 NEXT
END SUB

SUB EraseSnake (snake() AS snaketype, snakeBod() AS snakeBody, snakeNum)
 FOR x = 0 TO 9
  FOR y = snake(snakeNum).length - x TO 0 STEP -10
   tail = (snake(snakeNum).head + 1000 - y) MOD 1000
   Set snakeBod(tail, snakeNum).row, snakeBod(tail, snakeNum).col, colorTable(4)
  NEXT
 NEXT
END SUB

SUB GetInputs (NumPlayers, speed, diff$, monitor$)
 COLOR 7, 0
 CLS
 DO
  LOCATE 5, 47: PRINT SPACE$(34);
  LOCATE 5, 20
  INPUT "How many players (1 or 2)"; a$
 LOOP UNTIL VAL(a$) = 1 OR VAL(a$) = 2
 NumPlayers = VAL(a$)
 LOCATE 8, 21: PRINT "Skill level (1 to 100)"
 LOCATE 9, 22: PRINT "1   = Novice"
 LOCATE 10, 22: PRINT "90  = Expert"
 LOCATE 11, 22: PRINT "100 = Twiddle Fingers"
 LOCATE 12, 15: PRINT "(Computer speed may affect your skill level)"
 DO
  LOCATE 8, 44: PRINT SPACE$(35);
  LOCATE 8, 43
  INPUT a$
 LOOP UNTIL VAL(a$) >= 1 AND VAL(a$) <= 100
 speed = (100 - VAL(a$)) * 2 + 1
 DO
  LOCATE 15, 56: PRINT SPACE$(25);
  LOCATE 15, 15
  INPUT "Increase game speed during play (Y or N)"; diff$
  diff$ = UCASE$(diff$)
 LOOP UNTIL diff$ = "Y" OR diff$ = "N"
 DO
  LOCATE 17, 46: PRINT SPACE$(34);
  LOCATE 17, 17
  INPUT "Monochrome or color monitor (M or C)"; monitor$
  monitor$ = UCASE$(monitor$)
 LOOP UNTIL monitor$ = "M" OR monitor$ = "C"
 startTime# = TIMER
 FOR i# = 1 TO 1000: NEXT
 stopTime# = TIMER
 speed = speed * .5 / (stopTime# - startTime#)
END SUB

SUB InitColors
 FOR row = 1 TO 50
  FOR col = 1 TO 80
   arena(row, col).acolor = colorTable(4)
  NEXT
 NEXT
 CLS
 FOR col = 1 TO 80
  Set 3, col, colorTable(3)
  Set 50, col, colorTable(3)
 NEXT
 FOR row = 4 TO 49
  Set row, 1, colorTable(3)
  Set row, 80, colorTable(3)
 NEXT
END SUB

SUB Intro
 SCREEN 0
 WIDTH 80, 25
 COLOR 15, 0
 CLS
 Center 4, "Q B a s i c   N i b b l e s"
 COLOR 7
 Center 6, "Copyright (C) Microsoft Corporation 1990"
 Center 8, "Nibbles is a game for one or two players.  Navigate your snakes"
 Center 9, "around the game board trying to eat up numbers while avoiding"
 Center 10, "running into walls or other snakes.  The more numbers you eat up,"
 Center 11, "the more points you gain and the longer your snake becomes."
 Center 13, " Game Controls "
 Center 15, "  General             Player 1               Player 2    "
 Center 16, "                        (Up)                   (Up)      "
 Center 17, "P - Pause                " + CHR$(24) + "                      W       "
 Center 18, "                     (Left) " + CHR$(27) + "   " + CHR$(26) + " (Right)   (Left) A   D (Right)  "
 Center 19, "                         " + CHR$(25) + "                      S       "
 Center 20, "                       (Down)                 (Down)     "
 Center 24, "Press any key to continue"
 PLAY "MBT160O1L8CDEDCDL4ECC"
 SparklePause
END SUB

SUB Level (WhatToDO, sammy() AS snaketype) STATIC
 SELECT CASE (WhatToDO)
 CASE 1: curLevel = 1
 CASE 3: curLevel = curLevel + 1
 END SELECT
 sammy(1).head = 1
 sammy(1).length = 2
 sammy(1).alive = 1
 sammy(2).head = 1
 sammy(2).length = 2
 sammy(2).alive = 1
 InitColors
 SELECT CASE curLevel
 CASE 1
  sammy(1).row = 25: sammy(2).row = 25
  sammy(1).col = 50: sammy(2).col = 30
  sammy(1).direction = 4: sammy(2).direction = 3
 CASE 2
  FOR x = 20 TO 60
   Set 25, x, colorTable(3)
  NEXT
  sammy(1).row = 7: sammy(2).row = 43
  sammy(1).col = 60: sammy(2).col = 20
  sammy(1).direction = 3: sammy(2).direction = 4
 CASE 3
  FOR x = 10 TO 40
   Set x, 20, colorTable(3)
   Set x, 60, colorTable(3)
  NEXT
  sammy(1).row = 25: sammy(2).row = 25
  sammy(1).col = 50: sammy(2).col = 30
  sammy(1).direction = 1: sammy(2).direction = 2
 CASE 4
  FOR x = 4 TO 30
   Set x, 20, colorTable(3)
   Set 53 - x, 60, colorTable(3)
  NEXT
  FOR x = 2 TO 40
   Set 38, x, colorTable(3)
   Set 15, 81 - x, colorTable(3)
  NEXT
  sammy(1).row = 7: sammy(2).row = 43
  sammy(1).col = 60: sammy(2).col = 20
  sammy(1).direction = 3: sammy(2).direction = 4
 CASE 5
  FOR x = 13 TO 39
   Set x, 21, colorTable(3)
   Set x, 59, colorTable(3)
  NEXT
  FOR x = 23 TO 57
   Set 11, x, colorTable(3)
   Set 41, x, colorTable(3)
  NEXT
  sammy(1).row = 25: sammy(2).row = 25
  sammy(1).col = 50: sammy(2).col = 30
  sammy(1).direction = 1: sammy(2).direction = 2
 CASE 6
  FOR x = 4 TO 49
   IF x > 30 OR x < 23 THEN
    FOR y = 1 TO 7
     Set x, y * 10, colorTable(3)
    NEXT
   END IF
  NEXT
  sammy(1).row = 7: sammy(2).row = 43
  sammy(1).col = 65: sammy(2).col = 15
  sammy(1).direction = 2: sammy(2).direction = 1
 CASE 7
  FOR x = 4 TO 49 STEP 2
   Set x, 40, colorTable(3)
  NEXT
  sammy(1).row = 7: sammy(2).row = 43
  sammy(1).col = 65: sammy(2).col = 15
  sammy(1).direction = 2: sammy(2).direction = 1
 CASE 8
  FOR x = 4 TO 40
   Set x, 10, colorTable(3)
   Set 53 - x, 20, colorTable(3)
   Set x, 30, colorTable(3)
   Set 53 - x, 40, colorTable(3)
   Set x, 50, colorTable(3)
   Set 53 - x, 60, colorTable(3)
   Set x, 70, colorTable(3)
  NEXT
  sammy(1).row = 7: sammy(2).row = 43
  sammy(1).col = 65: sammy(2).col = 15
  sammy(1).direction = 2: sammy(2).direction = 1
 CASE 9
  FOR x = 6 TO 47
   Set x, x, colorTable(3)
   Set x, x + 28, colorTable(3)
  NEXT
  sammy(1).row = 40: sammy(2).row = 15
  sammy(1).col = 75: sammy(2).col = 5
  sammy(1).direction = 1: sammy(2).direction = 2
 CASE ELSE
  FOR x = 4 TO 49 STEP 2
   Set x, 10, colorTable(3)
   Set x + 1, 20, colorTable(3)
   Set x, 30, colorTable(3)
   Set x + 1, 40, colorTable(3)
   Set x, 50, colorTable(3)
   Set x + 1, 60, colorTable(3)
   Set x, 70, colorTable(3)
  NEXT
  sammy(1).row = 7: sammy(2).row = 43
  sammy(1).col = 65: sammy(2).col = 15
  sammy(1).direction = 2: sammy(2).direction = 1
 END SELECT
END SUB

SUB PlayNibbles (NumPlayers, speed, diff$)
 DIM sammyBody(1000 - 1, 1 TO 2) AS snakeBody
 DIM sammy(1 TO 2) AS snaketype
 sammy(1).lives = 5
 sammy(1).score = 0
 sammy(1).scolor = colorTable(1)
 sammy(2).lives = 5
 sammy(2).score = 0
 sammy(2).scolor = colorTable(2)
 Level 1, sammy()
 startRow1 = sammy(1).row: startCol1 = sammy(1).col
 startRow2 = sammy(2).row: startCol2 = sammy(2).col
 curSpeed = speed
 SpacePause "     Level" + STR$(curLevel) + ",  Push Space"
 gameOver = 0
 DO
  IF NumPlayers = 1 THEN sammy(2).row = 0
  number = 1
  nonum = 1
  playerDied = 0
  PrintScore NumPlayers, sammy(1).score, sammy(2).score, sammy(1).lives, sammy(2).lives
  PLAY "T160O1>L20CDEDCDL10ECC"
  DO
   IF nonum = 1 THEN
    DO
     numberRow = INT(RND(1) * 47 + 3)
     NumberCol = INT(RND(1) * 78 + 2)
     sisterRow = numberRow + arena(numberRow, NumberCol).sister
    LOOP UNTIL PointIsThere(numberRow, NumberCol, colorTable(4)) = 0 AND PointIsThere(sisterRow, NumberCol, colorTable(4)) = 0
    numberRow = arena(numberRow, NumberCol).realRow
    nonum = 0
    COLOR colorTable(1), colorTable(4)
    LOCATE numberRow, NumberCol
    PRINT RIGHT$(STR$(number), 1);
    count = 0
   END IF
   FOR a# = 1 TO curSpeed:  NEXT
   kbd$ = INKEY$
   SELECT CASE kbd$
    CASE "w", "W": IF sammy(2).direction <> 2 THEN sammy(2).direction = 1
    CASE "s", "S": IF sammy(2).direction <> 1 THEN sammy(2).direction = 2
    CASE "a", "A": IF sammy(2).direction <> 4 THEN sammy(2).direction = 3
    CASE "d", "D": IF sammy(2).direction <> 3 THEN sammy(2).direction = 4
    CASE CHR$(0) + "H": IF sammy(1).direction <> 2 THEN sammy(1).direction = 1
    CASE CHR$(0) + "P": IF sammy(1).direction <> 1 THEN sammy(1).direction = 2
    CASE CHR$(0) + "K": IF sammy(1).direction <> 4 THEN sammy(1).direction = 3
    CASE CHR$(0) + "M": IF sammy(1).direction <> 3 THEN sammy(1).direction = 4
    CASE "p", "P": SpacePause " Game Paused ... Push Space  "
    CASE ELSE
   END SELECT
   FOR x = 1 TO NumPlayers
    SELECT CASE sammy(x).direction
     CASE 1: sammy(x).row = sammy(x).row - 1
     CASE 2: sammy(x).row = sammy(x).row + 1
     CASE 3: sammy(x).col = sammy(x).col - 1
     CASE 4: sammy(x).col = sammy(x).col + 1
    END SELECT
    IF numberRow = INT((sammy(x).row + 1) / 2) AND NumberCol = sammy(x).col THEN
     PLAY "MBO0L16>CCCE"
     IF sammy(x).length < (1000 - 30) THEN sammy(x).length = sammy(x).length + number * 4
     sammy(x).score = sammy(x).score + number
     PrintScore NumPlayers, sammy(1).score, sammy(2).score, sammy(1).lives, sammy(2).lives
     number = number + 1
     IF number = 10 THEN
      EraseSnake sammy(), sammyBody(), 1
      EraseSnake sammy(), sammyBody(), 2
      LOCATE numberRow, NumberCol: PRINT " "
      Level 3, sammy()
      PrintScore NumPlayers, sammy(1).score, sammy(2).score, sammy(1).lives, sammy(2).lives
      SpacePause "     Level" + STR$(curLevel) + ",  Push Space"
      IF NumPlayers = 1 THEN sammy(2).row = 0
      number = 1
      IF diff$ = "P" THEN speed = speed - 10: curSpeed = speed
     END IF
     nonum = 1
     IF curSpeed < 1 THEN curSpeed = 1
    END IF
   NEXT
   FOR x = 1 TO NumPlayers
    IF PointIsThere(sammy(x).row, sammy(x).col, colorTable(4)) OR (sammy(1).row = sammy(2).row AND sammy(1).col = sammy(2).col) THEN
     PLAY "MBO0L32EFGEFDC"
     COLOR , colorTable(4)
     LOCATE numberRow, NumberCol
     PRINT " "
     playerDied = 1
     sammy(x).alive = 0
     sammy(x).lives = sammy(x).lives - 1
    ELSE
     sammy(x).head = (sammy(x).head + 1) MOD 1000
     sammyBody(sammy(x).head, x).row = sammy(x).row
     sammyBody(sammy(x).head, x).col = sammy(x).col
     tail = (sammy(x).head + 1000 - sammy(x).length) MOD 1000
     Set sammyBody(tail, x).row, sammyBody(tail, x).col, colorTable(4)
     sammyBody(tail, x).row = 0
     Set sammy(x).row, sammy(x).col, sammy(x).scolor
    END IF
   NEXT
  LOOP UNTIL playerDied
  FOR x = 1 TO NumPlayers
   EraseSnake sammy(), sammyBody(), x
   IF sammy(x).alive = 0 THEN
    sammy(x).score = sammy(x).score - 10
    PrintScore NumPlayers, sammy(1).score, sammy(2).score, sammy(1).lives, sammy(2).lives
    IF x = 1 THEN SpacePause " Sammy Dies! Push Space! --->" ELSE SpacePause " <---- Jake Dies! Push Space "
   END IF
  NEXT
  Level 2, sammy()
  PrintScore NumPlayers, sammy(1).score, sammy(2).score, sammy(1).lives, sammy(2).lives
 LOOP UNTIL sammy(1).lives = 0 OR sammy(2).lives = 0
END SUB

FUNCTION PointIsThere (row, col, acolor)
 IF row <> 0 THEN IF arena(row, col).acolor <> acolor THEN PointIsThere = 1 ELSE PointIsThere = 0
END FUNCTION

SUB PrintScore (NumPlayers, score1, score2, lives1, lives2)
 COLOR 15, colorTable(4)
 IF NumPlayers = 2 THEN
  LOCATE 1, 1
  PRINT USING "#,###,#00  Lives: #  <--JAKE"; score2; lives2
 END IF
 LOCATE 1, 49
 PRINT USING "SAMMY-->  Lives: #     #,###,#00"; lives1; score1
END SUB

SUB Set (row, col, acolor)
 IF row <> 0 THEN
  arena(row, col).acolor = acolor
  realRow = arena(row, col).realRow
  topFlag = arena(row, col).sister + 1 / 2
  sisterRow = row + arena(row, col).sister
  sisterColor = arena(sisterRow, col).acolor
  LOCATE realRow, col
  IF acolor = sisterColor THEN
   COLOR acolor, acolor
   PRINT CHR$(219);
  ELSE
   IF topFlag THEN
    IF acolor > 7 THEN
     COLOR acolor, sisterColor
     PRINT CHR$(223);
    ELSE
     COLOR sisterColor, acolor
     PRINT CHR$(220);
    END IF
   ELSE
    IF acolor > 7 THEN
     COLOR acolor, sisterColor
     PRINT CHR$(220);
    ELSE
     COLOR sisterColor, acolor
     PRINT CHR$(223);
    END IF
   END IF
  END IF
 END IF
END SUB

SUB SpacePause (text$)
 COLOR colorTable(5), colorTable(6)
 Center 11, "€ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ€"
 Center 12, "€ " + LEFT$(text$ + SPACE$(29), 29) + " €"
 Center 13, "€‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹€"
 WHILE INKEY$ <> "": WEND
 WHILE INKEY$ <> " ": WEND
 COLOR 15, colorTable(4)
 FOR x = 21 TO 26            ' Restore the screen background
  FOR y = 24 TO 56
   Set x, y, arena(x, y).acolor
  NEXT
 NEXT
END SUB

SUB SparklePause
 COLOR 4, 0
 a$ = "*    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    "
 WHILE INKEY$ <> "": WEND
 WHILE INKEY$ = ""
  FOR x = 1 TO 5
   LOCATE 1, 1                             'print horizontal sparkles
   PRINT MID$(a$, x, 80);
   LOCATE 22, 1
   PRINT MID$(a$, 6 - x, 80);
   FOR y = 2 TO 21                         'Print Vertical sparkles
    IF (x + y) MOD 5 = 1 THEN
     LOCATE y, 80
     PRINT "*";
     LOCATE 23 - y, 1
     PRINT "*";
    ELSE
     LOCATE y, 80
     PRINT " ";
     LOCATE 23 - y, 1
     PRINT " ";
    END IF
   NEXT
  NEXT
 WEND
END SUB

FUNCTION StillWantsToPlay
 COLOR colorTable(5), colorTable(6)
 Center 10, "€ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ€"
 Center 11, "€       G A M E   O V E R       €"
 Center 12, "€                               €"
 Center 13, "€      Play Again?   (Y/N)      €"
 Center 14, "€‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹€"
 WHILE INKEY$ <> "": WEND
 DO
  kbd$ = UCASE$(INKEY$)
 LOOP UNTIL kbd$ = "Y" OR kbd$ = "N"
 COLOR 15, colorTable(4)
 Center 10, "                                 "
 Center 11, "                                 "
 Center 12, "                                 "
 Center 13, "                                 "
 Center 14, "                                 "
 IF kbd$ = "Y" THEN
  StillWantsToPlay = 1
 ELSE
  StillWantsToPlay = 0
  COLOR 7, 0
  CLS
 END IF
END FUNCTION

