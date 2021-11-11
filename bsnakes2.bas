'
'                               BATTLE SNAKES
'                                 Ver  2.0   
'                              By: Chad Austin
'
'       Battle Snakes is a game in which two snakes try to kill the other
' by trapping it with its body or distract it into hitting a wall.  There
' are eight different battle fields, or arenas, to fight in.  The snake that
' kills the other the most wins.
'
'
'
' Hit [ALT], F, X to exit QBasic
'
' Hit [SHIFT]-[F5] to play "Battle Snakes"
'
'
'
'
DEFINT A-Z
DECLARE FUNCTION GetInt% (row%, col%, lo%, hi%)
DECLARE SUB Center (row%, text$)
DECLARE SUB EndGame (KeyFlags%)
DECLARE SUB GetArena ()
DECLARE SUB GetInputs ()
DECLARE SUB Intro ()
DECLARE SUB PlayBattle (KeyFlags%)
TYPE PlayerType
 col    AS INTEGER
 row    AS INTEGER
 dir    AS INTEGER
 dead   AS INTEGER
 points AS INTEGER
END TYPE
 RANDOMIZE TIMER
 DIM SHARED player(1 TO 2) AS PlayerType
 DIM SHARED Speed!, Round, Arena, Inc$, MaxCol
 ON ERROR GOTO ScreenError
 SCREEN 1
 SCREEN 0
 WIDTH 80, 25
 ON ERROR GOTO 0
 DEF SEG = 0
 KeyFlags = PEEK(1047)
 IF KeyFlags AND 32 THEN POKE 1047, KeyFlags XOR 32
 DEF SEG
 KEY 15, CHR$(0) + CHR$(69)
 KEY(15) ON
 Intro
 GetInputs
 PlayBattle KeyFlags
 EndGame KeyFlags
ScreenError:
 CLS
 PRINT "You must have a CGA, EGA, VGA, or MCGA adapter to play Battle Snakes II."
 END

SUB Center (row, text$)
 LOCATE row, (MaxCol / 2) - INT(LEN(text$) / 2)
 PRINT text$
END SUB

SUB EndGame (KeyFlags)
 LINE (37, 78)-(273, 105), 3, B
 LINE (38, 79)-(272, 104), 0, BF
 Center 11, "Player #1 had" + STR$(player(1).points) + " point(s)!!!!"
 Center 12, "Player #2 had" + STR$(player(2).points) + " point(s)!!!!"
 SELECT CASE player(1).points
 CASE IS > player(2).points
  Center 13, "Player #1 wins!!!!!"
 CASE IS < player(2).points
  Center 13, "Player #2 wins!!!!!"
 CASE IS = player(2).points
  Center 13, "The players tied!!!"
 END SELECT
 x! = TIMER
 WHILE TIMER - x! < .5: WEND
 WHILE INKEY$ <> "": WEND
 WHILE INKEY$ = "": WEND
 DEF SEG = 0
 POKE 1047, KeyFlags
 DEF SEG
 SCREEN 0, 1
 COLOR 7, 0, 0
 WIDTH 80, 25
 END
END SUB

SUB GetArena
 CLS
 SELECT CASE Arena
 CASE 1
  player(1).col = 50
  player(1).row = 98
  player(1).dir = 1
  player(2).col = 109
  player(2).row = 98
  player(2).dir = 1
  LINE (0, 0)-(319, 199), 3, B
  LINE (1, 1)-(318, 198), 3, B
 CASE 2
  player(1).col = 4
  player(1).row = 98
  player(1).dir = 1
  player(2).col = 155
  player(2).row = 1
  player(2).dir = 2
  LINE (0, 0)-(319, 199), 3, B
  LINE (1, 1)-(318, 198), 3, B
  FOR x = 2 TO 40 STEP 2
   LINE (160, x * 2)-(161, x * 2 + 1), 3, B
  NEXT
  FOR x = 60 TO 100 STEP 2
   LINE (160, x * 2)-(161, x * 2 + 1), 3, B
  NEXT
 CASE 3
  player(1).col = 1
  player(1).row = 1
  player(1).dir = 4
  player(2).col = 158
  player(2).row = 98
  player(2).dir = 3
  LINE (0, 0)-(319, 199), 3, B
  LINE (1, 1)-(318, 198), 3, B
  FOR z = 1 TO 300
   x = RND * 155 + 2
   y = RND * 95 + 2
   LINE (x * 2, y * 2)-(x * 2 + 1, y * 2 + 1), 3, B
  NEXT
 CASE 4
  player(1).col = 1
  player(1).row = 50
  player(1).dir = 4
  player(2).col = 158
  player(2).row = 50
  player(2).dir = 3
  LINE (0, 0)-(319, 199), 3, B
  LINE (1, 1)-(318, 198), 3, B
  LINE (50, 100)-(139, 101), 3, B
  LINE (180, 100)-(269, 101), 3, B
  LINE (160, 24)-(161, 83), 3, B
  LINE (160, 118)-(161, 183), 3, B
 CASE 5
  player(1).col = 2
  player(1).row = 1
  player(1).dir = 2
  player(2).col = 157
  player(2).row = 1
  player(2).dir = 2
  LINE (0, 0)-(319, 199), 3, B
  LINE (1, 1)-(318, 198), 3, B
  FOR x = 20 TO 140 STEP 40
   LINE (x * 2, 2)-(x * 2 + 1, 151), 3, B
  NEXT
  FOR x = 40 TO 120 STEP 40
   LINE (x * 2, 55)-(x * 2 + 1, 198), 3, B
  NEXT
 CASE 6
  player(1).col = 2
  player(1).row = 2
  player(1).dir = 4
  player(2).col = 49
  player(2).row = 24
  player(2).dir = 3
  LINE (2, 2)-(101, 51), 3, B
  LINE (3, 3)-(100, 50), 3, B
 CASE 7
  player(1).col = 1
  player(1).row = 1
  player(1).dir = 2
  player(2).col = 158
  player(2).row = 98
  player(2).dir = 1
  LINE (0, 0)-(319, 199), 3, B
  LINE (1, 1)-(318, 198), 3, B
  FOR x = 20 TO 160 STEP 40
   FOR y = 2 TO 98 STEP 2
    LINE (x * 2, y * 2)-(x * 2 + 1, y * 2 + 1), 3, B
   NEXT
  NEXT
  FOR x = 40 TO 140 STEP 40
   FOR y = 1 TO 99 STEP 2
    LINE (x * 2, y * 2)-(x * 2 + 1, y * 2 + 1), 3, B
   NEXT
  NEXT
 CASE 8
  player(1).col = 1
  player(1).row = 1
  player(1).dir = 2
  player(2).col = 158
  player(2).row = 98
  player(2).dir = 1
  LINE (0, 0)-(59, 59), 3, B
  LINE (1, 1)-(58, 58), 3, B
  LINE (58, 50)-(59, 57), 0, B
  LINE (319, 199)-(260, 140), 3, B
  LINE (318, 198)-(261, 141), 3, B
  LINE (260, 142)-(261, 149), 0, B
  LINE (259, 150)-(58, 151), 3, B
  LINE (58, 151)-(59, 59), 3, B
  LINE (260, 139)-(261, 51), 3, B
  LINE (261, 50)-(58, 51), 3, B
  FOR z = 1 TO 200
   x = RND * 100 + 30
   y = RND * 49 + 26
   LINE (x * 2, y * 2)-(x * 2 + 1, y * 2 + 1), 3, B
  NEXT
 END SELECT
END SUB

SUB GetInputs
 CLS
 Center 2, "Game Speed: _  "
 Center 3, "1     50     99"
 Center 4, "Slow-------Fast"
 DO
  kbd$ = INKEY$
  SELECT CASE kbd$
  CASE "0" TO "9": IF LEN(num$) < 2 THEN num$ = num$ + kbd$
  CASE CHR$(8): IF LEN(num$) THEN num$ = LEFT$(num$, LEN(num$) - 1)
  CASE CHR$(13)
   Speed! = VAL(num$)
   IF Speed! AND Speed! < 100 THEN
    LOCATE 2, 45 + LEN(num$): PRINT " "
    EXIT DO
   END IF
   num$ = ""
  END SELECT
  LOCATE 2, 45: PRINT num$ + "_  "
 LOOP
 Speed! = 100 - Speed!
 Center 7, "Increase game speed during play? (Y/N)  "
 WHILE Inc$ <> "Y" AND Inc$ <> "N"
  Inc$ = UCASE$(INKEY$)
 WEND
 LOCATE 7, 59: PRINT Inc$
 Center 10, "Rounds of Combat:   "
 Center 22, "Hit [+] or [-] to change the number of rounds."
 Round = 1
 DO
  kbd$ = INKEY$
  SELECT CASE kbd$
  CASE "+", "=": IF Round < 99 THEN Round = Round + 1
  CASE "-", "_": IF Round > 1 THEN Round = Round - 1
  END SELECT
  LOCATE 10, 48: PRINT USING "##"; Round
 LOOP UNTIL kbd$ = CHR$(13)
 Center 22, SPACE$(46)
 Center 13, "Choose arena (1-8):"
 DO
  Arena = VAL(INKEY$)
 LOOP UNTIL Arena > 0 AND Arena < 9
 LOCATE 13, 50: PRINT Arena
END SUB

SUB Intro
 MaxCol = 80
 COLOR 14
 Center 2, "Battle Snakes"
 COLOR 10
 Center 3, "Ver 2.0"
 COLOR 9
 Center 4, "By Chad Austin"
 COLOR 15
 Center 7, "    Battle Snakes is a game in which two snakes attempt to kill each"
 Center 8, "other by cutting the other one off or scaring it into a wall.  There"
 Center 9, "are eight different arenas, each one having different wall positions"
 Center 10, "and different boundaries.                                           "
 COLOR 3
 Center 12, "General Controls     Player 1              Player 2      "
 COLOR 15
 Center 14, "   P - Pause           (Up)                  (Up)        "
 Center 15, "   Q - Quit             W                               "
 Center 16, "               (Left) A   D (Right)  (Left)     (Right)"
 Center 17, "                        S                               "
 Center 18, "                      (Down)                (Down)       "
 Center 23, "Hit any key to continue"
 WHILE INKEY$ = "": WEND
END SUB

SUB PlayBattle (KeyFlags)
 DIM B&(235)
 MaxCol = 40
 SCREEN 1
 s! = TIMER
 DO
  x = x + 1
 LOOP UNTIL TIMER - s! >= .5
 Speed! = Speed! * x / 150
 FOR a = 1 TO Round
  player(1).dead = 0
  player(2).dead = 0
  GetArena
  GET (60, 86)-(248, 97), B&
  LINE (60, 86)-(248, 97), 3, B
  LINE (61, 87)-(247, 96), 0, BF
  Center 12, "Hit any key to continue"
  WHILE INKEY$ = "": WEND
  PUT (60, 86), B&, PSET
  WHILE player(1).dead = 0 AND player(2).dead = 0
   FOR x# = 1 TO Speed!: NEXT
   FOR x = 1 TO 2
    LINE (player(x).col * 2, player(x).row * 2)-(player(x).col * 2 + 1, player(x).row * 2 + 1), x, B
   NEXT
   IF player(1).row = player(2).row AND player(1).col = player(2).col THEN
    player(1).dead = 1
    player(2).dead = 1
   END IF
   kbd$ = INKEY$
   SELECT CASE UCASE$(kbd$)
   CASE CHR$(0) + "H": IF player(2).dir <> 2 THEN player(2).dir = 1
   CASE CHR$(0) + "P": IF player(2).dir <> 1 THEN player(2).dir = 2
   CASE CHR$(0) + "K": IF player(2).dir <> 4 THEN player(2).dir = 3
   CASE CHR$(0) + "M": IF player(2).dir <> 3 THEN player(2).dir = 4
   CASE "W": IF player(1).dir <> 2 THEN player(1).dir = 1
   CASE "S": IF player(1).dir <> 1 THEN player(1).dir = 2
   CASE "A": IF player(1).dir <> 4 THEN player(1).dir = 3
   CASE "D": IF player(1).dir <> 3 THEN player(1).dir = 4
   CASE "P"
    GET (62, 86)-(248, 105), B&
    LINE (62, 86)-(248, 105), 3, B
    LINE (63, 87)-(247, 104), 0, BF
    Center 12, "Game paused"
    Center 13, "Hit any key to continue"
    WHILE INKEY$ = "": WEND
    PUT (62, 86), B&, PSET
   CASE "Q"
    GET (78, 86)-(232, 97), B&
    LINE (78, 86)-(232, 97), 3, B
    LINE (79, 87)-(231, 96), 0, BF
    Center 12, "Are you sure? (Y/N)"
    WHILE kbd$ <> "Y" AND kbd$ <> "N"
     kbd$ = UCASE$(INKEY$)
    WEND
    IF kbd$ = "Y" THEN EndGame KeyFlags
    PUT (78, 86), B&, PSET
   END SELECT
   FOR x = 1 TO 2
    SELECT CASE player(x).dir
    CASE 1: player(x).row = player(x).row - 1
    CASE 2: player(x).row = player(x).row + 1
    CASE 3: player(x).col = player(x).col - 1
    CASE 4: player(x).col = player(x).col + 1
    END SELECT
   NEXT
   IF POINT(player(2).col * 2, player(2).row * 2) <> 0 THEN player(2).dead = 1
   IF POINT(player(1).col * 2, player(1).row * 2) <> 0 THEN player(1).dead = 1
  WEND
  PLAY "L32N5N3N1N4N2"
  player(2).points = player(2).points + player(1).dead
  player(1).points = player(1).points + player(2).dead
  LINE (78, 86)-(232, 105), 3, B
  LINE (79, 87)-(231, 104), 0, BF
  IF player(1).dead AND player(2).dead THEN Center 12, "Both players died!!" ELSE Center 12, ("Player #" + LTRIM$(STR$(ABS(player(1).dead IMP player(2).dead))) + " wins!!")
  WHILE INKEY$ <> "": WEND
  WHILE INKEY$ = "": WEND
  IF a <> Round THEN
   Center 13, "Choose arena (1-8)"
   DO
    Arena = VAL(INKEY$)
   LOOP UNTIL Arena > 0 AND Arena < 9
  END IF
  IF Inc$ = "Y" THEN Speed! = Speed! * .9
 NEXT
END SUB

