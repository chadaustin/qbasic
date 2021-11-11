DEFINT A-Z
DECLARE SUB calcadj (x%, y%, a%, b%)
DECLARE SUB center (x%, a$)
DECLARE SUB checkturns (player%)
DECLARE SUB clearchoices ()
DECLARE SUB compmove ()
DECLARE SUB config ()
DECLARE SUB configinit (x%)
DECLARE SUB configtext ()
DECLARE SUB cvalue (a%, b%, x%, y%)
DECLARE SUB disc (x%, y%, z%, a!)
DECLARE SUB drawboard ()
DECLARE SUB endgame ()
DECLARE SUB flip (a%, b%, x%, y%, c!, clr%)
DECLARE SUB instruct ()
DECLARE SUB loaddata ()
DECLARE SUB main ()
DECLARE SUB movecursor (x%)
DECLARE SUB movesquare (x%, y%)
DECLARE SUB othello ()
DECLARE SUB selectsquare ()
'$DYNAMIC
 RANDOMIZE TIMER
 DIM SHARED grid(1 TO 8, 1 TO 8), item(6) AS STRING * 13, ready(1 TO 2), scrn
 DIM SHARED mode, scheme, invert, discstyle, opponent, row, col, choice
 DIM SHARED maxchoice, turn, done, game, vturn
 scrn = 12
 ON ERROR GOTO screen1
 SCREEN scrn
 IF scrn = 13 THEN
  ON ERROR GOTO screen2
  SCREEN scrn
  IF scrn = 9 THEN
   ON ERROR GOTO screen3
   SCREEN scrn
   IF scrn = 7 THEN
    ON ERROR GOTO screen4
    SCREEN scrn
    IF scrn = 1 THEN
     ON ERROR GOTO screen5
     SCREEN scrn
    END IF
   END IF
  END IF
 END IF
 ON ERROR GOTO unexpect
 KEY 15, CHR$(0) + CHR$(69)
 KEY(15) ON
 DEF SEG = 0
 x = PEEK(1047)
 IF x AND 32 THEN POKE 1047, x XOR 32
 DEF SEG
 loaddata
 main
 DEF SEG = 0
 POKE 1047, x
 DEF SEG
 SCREEN 0
 CLS
 COLOR 7
 PRINT "Thank you for playing Othello."
 PRINT "Written by: Chad Austin"
 END
screen1: scrn = 13
RESUME NEXT
screen2: scrn = 9
RESUME NEXT
screen3: scrn = 7
RESUME NEXT
screen4: scrn = 1
RESUME NEXT
screen5:
 PRINT "Othello requires a CGA, EGA, MCGA, or VGA adapter."
 END
unexpect:
 PRINT "Unexpected error"
 PRINT "Ending program"
 END

REM $STATIC
SUB calcadj (x, y, a, b)
 IF x > col THEN a = col + 1
 IF x < col THEN a = col - 1
 IF x = col THEN a = col
 IF y > row THEN b = row + 1
 IF y < row THEN b = row - 1
 IF y = row THEN b = row
END SUB

SUB center (x, a$)
 LOCATE x, 41 - (LEN(a$) / 2)
 PRINT a$
END SUB

SUB checkturns (player)
 ON ERROR GOTO 0
 ready(player) = 0
 FOR x = 1 TO 8
  FOR y = 1 TO 8
   IF grid(x, y) = 0 THEN
    FOR z = 1 TO 8
     a = x
     b = y
     e = 0
     c = 0
     DO
      SELECT CASE z
       CASE 1: b = b - 1
       CASE 2: a = a + 1: b = b - 1
       CASE 3: a = a + 1
       CASE 4: a = a + 1: b = b + 1
       CASE 5: b = b + 1
       CASE 6: a = a - 1: b = b + 1
       CASE 7: a = a - 1
       CASE 8: a = a - 1: b = b - 1
      END SELECT
      IF a > 0 AND a < 9 AND b > 0 AND b < 9 THEN
       IF c AND grid(a, b) = player THEN
        d = 1
        ready(player) = 1
        EXIT SUB
       ELSEIF grid(a, b) = 3 - player THEN
        c = 1
       END IF
      END IF
      IF a > 0 AND a < 9 AND b > 0 AND b < 9 THEN
       IF grid(a, b) = player OR grid(a, b) = 0 THEN e = 1
      ELSE e = 1
      END IF
     LOOP UNTIL e
    NEXT
   END IF
  NEXT
 NEXT
END SUB

SUB clearchoices
 FOR x = 0 TO 6
  IF mode = 12 OR mode = 9 THEN LOCATE 15 + x, 56 ELSE LOCATE 15 + x, 27
  PRINT SPACE$(13)
 NEXT
END SUB

SUB compmove
 DIM vdir(1 TO 8, 59), wdir(1 TO 8), vnum(1 TO 8, 59), wnum(1 TO 8), vcol(59)
 DIM vrow(59)
 turn = 2
 FOR x = 1 TO 8
  FOR y = 1 TO 8
   IF grid(x, y) = 0 THEN
    f = 0
    FOR z = 1 TO 8
     wdir(z) = 0
     h = 0
     a = x
     b = y
     c = 0
     DO
      e = 0
      SELECT CASE z
       CASE 1: b = b - 1
       CASE 2: a = a + 1: b = b - 1
       CASE 3: a = a + 1
       CASE 4: a = a + 1: b = b + 1
       CASE 5: b = b + 1
       CASE 6: a = a - 1: b = b + 1
       CASE 7: a = a - 1
       CASE 8: a = a - 1: b = b - 1
      END SELECT
      IF a > 0 AND a < 9 AND b > 0 AND b < 9 THEN
       IF grid(a, b) = 2 THEN
        IF c THEN
         e = 1
         wdir(z) = 1
         wnum(z) = h
         f = f + h
        END IF
       ELSEIF grid(a, b) = 1 THEN
        c = 1: h = h + 1
       END IF
      END IF
      d = 0
      IF a > 0 AND a < 9 AND b > 0 AND b < 9 THEN
       IF grid(a, b) = 0 OR grid(a, b) = 2 THEN d = 1
      ELSE d = 1
      END IF
     LOOP UNTIL d OR e
    NEXT
    IF f > g THEN
     num = 0
     FOR z = 1 TO 8
      vdir(z, num) = wdir(z)
      vnum(z, num) = wnum(z)
     NEXT
     g = f
     vcol(num) = x
     vrow(num) = y
    ELSEIF f = g THEN
     num = num + 1
     FOR z = 1 TO 8
      vdir(z, num) = wdir(z)
      vnum(z, num) = wnum(z)
     NEXT
     g = f
     vcol(num) = x
     vrow(num) = y
    END IF
   END IF
  NEXT
 NEXT
 num = CINT(RND * num)
 FOR z = 1 TO 8
  IF vdir(z, num) THEN
   SELECT CASE z
    CASE 1: x = vcol(num): y = vrow(num) - vnum(z, num): a = vcol(num): b = vrow(num) - 1
    CASE 2: x = vcol(num) + vnum(z, num): y = vrow(num) - vnum(z, num): a = vcol(num) + 1: b = vrow(num) - 1
    CASE 3: x = vcol(num) + vnum(z, num): y = vrow(num): a = vcol(num) + 1: b = vrow(num)
    CASE 4: x = vcol(num) + vnum(z, num): y = vrow(num) + vnum(z, num): a = vcol(num) + 1: b = vrow(num) + 1
    CASE 5: x = vcol(num): y = vrow(num) + vnum(z, num): a = vcol(num): b = vrow(num) + 1
    CASE 6: x = vcol(num) - vnum(z, num): y = vrow(num) + vnum(z, num): a = vcol(num) - 1: b = vrow(num) + 1
    CASE 7: x = vcol(num) - vnum(z, num): y = vrow(num): a = vcol(num) - 1: b = vrow(num)
    CASE 8: x = vcol(num) - vnum(z, num): y = vrow(num) - vnum(z, num): a = vcol(num) - 1: b = vrow(num) - 1
   END SELECT
   IF mode = 1 THEN disc vcol(num), vrow(num), 3, 1 ELSE disc vcol(num), vrow(num), 15, 1
   grid(vcol(num), vrow(num)) = 2
   SELECT CASE discstyle
    CASE 0
     clr = (scheme + 1) + 8 * invert
     IF mode = 1 THEN clr = 2 - invert
     IF mode = 1 THEN tclr = (2 - turn) * 3 ELSE tclr = (2 - turn) * 15
     FOR c = 0 TO 3
      flip a, b, x, y, 1 / (2 ^ c), tclr
      DO: LOOP UNTIL TIMER - x! > .15
      x! = TIMER
      flip a, b, x, y, 1 / (2 ^ c), clr
     NEXT
     IF mode = 1 THEN tclr = (turn - 1) * 3 ELSE tclr = (turn - 1) * 15
     FOR c = 3 TO 0 STEP -1
      flip a, b, x, y, 1 / (2 ^ c), tclr
      DO: LOOP UNTIL TIMER - x! > .15
      x! = TIMER
      IF c = 0 THEN
       'flip a, b, x, y, 1, tclr
       cvalue a, b, x, y
      ELSE flip a, b, x, y, 1 / (2 ^ c), clr
      END IF
     NEXT
    CASE 1
     clr = (scheme + 1) + 8 * invert
     IF mode = 1 THEN clr = 2 - invert
     IF mode = 1 THEN tclr = (2 - turn) * 3 ELSE tclr = (2 - turn) * 15
     FOR c = 0 TO 3
      flip a, b, x, y, 2 ^ c, tclr
      DO: LOOP UNTIL TIMER - x! > .15
      x! = TIMER
      flip a, b, x, y, 2 ^ c, clr
     NEXT
     IF mode = 1 THEN tclr = (turn - 1) * 3 ELSE tclr = (turn - 1) * 15
     FOR c = 3 TO 0 STEP -1
      flip a, b, x, y, 2 ^ c, tclr
      DO: LOOP UNTIL TIMER - x! > .15
      x! = TIMER
      IF c = 0 THEN
       flip a, b, x, y, 1, tclr
       cvalue a, b, x, y
      ELSE flip a, b, x, y, 2 ^ c, clr
      END IF
     NEXT
    CASE 2
     IF mode <> 13 THEN
      FOR c = 0 TO 8 STEP 8
       DO: LOOP UNTIL TIMER - x! > .15
       x! = TIMER
       IF turn = 1 THEN flip a, b, x, y, 1, 15 - c ELSE flip a, b, x, y, 1, c
      NEXT
      FOR c = 8 TO 0 STEP -8
       DO: LOOP UNTIL TIMER - x! > .15
       x! = TIMER
       IF turn = 1 THEN flip a, b, x, y, 1, c ELSE flip a, b, x, y, 1, 15 - c
      NEXT
     ELSE
      FOR c = 16 TO 31
       IF turn = 1 THEN
        flip a, b, x, y, 1, 47 - c
       ELSE
        flip a, b, x, y, 1, c
       END IF
       DO: LOOP UNTIL TIMER - x! > .025
       x! = TIMER
      NEXT
     END IF
     cvalue a, b, x, y
    CASE 3
     IF mode = 1 THEN tclr = (turn - 1) * 3 ELSE tclr = (turn - 1) * 15
     flip a, b, x, y, 1, tclr
     cvalue a, b, x, y
   END SELECT
  END IF
 NEXT
END SUB

SUB config
 choice = 0
 drawboard
 IF mode = 1 THEN
  disc 4, 4, 3, 1
  disc 5, 5, 3, 1
 ELSE
  disc 4, 4, 15, 1
  disc 5, 5, 15, 1
 END IF
 disc 4, 5, 0, 1
 disc 5, 4, 0, 1
 configtext
 DO
  kbd$ = INKEY$
  SELECT CASE kbd$
   CASE CHR$(0) + "P": movecursor 1
   CASE CHR$(0) + "H": movecursor -1
   CASE CHR$(13)
    SELECT CASE choice
     CASE 0 TO 3: configinit (choice)
     CASE 4
      invert = invert XOR 1
      drawboard
      IF mode = 1 THEN
       disc 4, 4, 3, 1
       disc 5, 5, 3, 1
      ELSE
       disc 4, 4, 15, 1
       disc 5, 5, 15, 1
      END IF
      disc 4, 5, 0, 1
      disc 5, 4, 0, 1
      configtext
     CASE 5
      OPEN "othello.cfg" FOR BINARY AS #1
      PUT #1, , scrn
      PUT #1, , mode
      PUT #1, , scheme
      PUT #1, , invert
      PUT #1, , discstyle
      PUT #1, , opponent
      CLOSE
    END SELECT
  END SELECT
 LOOP UNTIL choice = 6 AND kbd$ = CHR$(13) OR kbd$ = CHR$(27)
END SUB

SUB configinit (z)
 clearchoices
 oldchoice = choice
 choice = 0
 SELECT CASE z
  CASE 0
   maxchoice = 4
   IF scrn = 12 THEN item(0) = "VGA" ELSE item(0) = "-"
   IF scrn > 11 THEN item(1) = "MCGA" ELSE item(1) = "-"
   IF scrn > 8 THEN item(2) = "EGA (high)" ELSE item(2) = "-"
   item(3) = "EGA (low)"
   item(4) = "CGA"
   SELECT CASE mode
    CASE 12: choice = 0
    CASE 13: choice = 1
    CASE 9: choice = 2
    CASE 7: choice = 3
    CASE 1: choice = 4
   END SELECT
  CASE 1
   maxchoice = 5
   item(0) = "Blue"
   item(1) = "Green"
   item(2) = "Cyan"
   item(3) = "Red"
   item(4) = "Purple"
   item(5) = "Yellow"
   choice = scheme
  CASE 2
   maxchoice = 3
   item(0) = "Hor. Flip"
   item(1) = "Vert. Flip"
   IF mode <> 1 THEN item(2) = "Fade" ELSE item(2) = "-"
   item(3) = "Nothing"
   choice = discstyle
  CASE 3
   maxchoice = 1
   item(0) = "Human"
   item(1) = "Computer"
   choice = opponent
  CASE 4
   maxchoice = 1
   item(0) = "Yes"
   item(1) = "No"
 END SELECT
 DO WHILE LEFT$(item(choice), 1) = "-"
  choice = choice + 1
 LOOP
 IF mode <> 1 THEN COLOR 15
 FOR x = 0 TO maxchoice
  IF mode = 12 OR mode = 9 THEN LOCATE x + 15, 56 ELSE LOCATE x + 15, 27
  PRINT item(x)
 NEXT
 IF mode <> 1 THEN COLOR scheme + 9 - invert * 8
 IF mode = 12 OR mode = 9 THEN LOCATE choice + 15, 56 ELSE LOCATE choice + 15, 27
 PRINT item(choice)
 IF mode = 1 THEN LINE (208, choice * 8 + 112)-(309, choice * 8 + 119), , B
 DO
  kbd$ = INKEY$
  SELECT CASE kbd$
   CASE CHR$(0) + "P": movecursor 1
   CASE CHR$(0) + "H": movecursor -1
  END SELECT
 LOOP UNTIL kbd$ = CHR$(13) OR (kbd$ = CHR$(27) AND z < 4)
 IF kbd$ <> CHR$(27) THEN
  SELECT CASE z
   CASE 0
    SELECT CASE choice
     CASE 0: mode = 12
     CASE 1: mode = 13
     CASE 2: mode = 9
     CASE 3: mode = 7
     CASE 4: mode = 1
    END SELECT
    IF mode = 1 AND discstyle = 2 THEN discstyle = 0
   CASE 1: scheme = choice
   CASE 2
    discstyle = choice
    SELECT CASE discstyle
     CASE 0
      clr = (scheme + 1) + 8 * invert
      IF mode = 1 THEN clr = 2 - invert
      FOR x = 0 TO 3
       disc 5, 4, 0, 1 / (2 ^ x)
       disc 4, 5, 0, 1 / (2 ^ x)
       IF mode <> 1 THEN
        disc 4, 4, 15, 1 / (2 ^ x)
        disc 5, 5, 15, 1 / (2 ^ x)
       ELSE
        disc 4, 4, 3, 1 / (2 ^ x)
        disc 5, 5, 3, 1 / (2 ^ x)
       END IF
       DO: LOOP UNTIL TIMER - x! > .15
       x! = TIMER
       disc 4, 4, clr, 1 / (2 ^ x)
       disc 5, 5, clr, 1 / (2 ^ x)
       disc 4, 5, clr, 1 / (2 ^ x)
       disc 5, 4, clr, 1 / (2 ^ x)
      NEXT
      FOR x = 3 TO 0 STEP -1
       disc 4, 4, 0, 1 / (2 ^ x)
       disc 5, 5, 0, 1 / (2 ^ x)
       IF mode <> 1 THEN
        disc 4, 5, 15, 1 / (2 ^ x)
        disc 5, 4, 15, 1 / (2 ^ x)
       ELSE
        disc 4, 5, 3, 1 / (2 ^ x)
        disc 5, 4, 3, 1 / (2 ^ x)
       END IF
       DO: LOOP UNTIL TIMER - x! > .15
       x! = TIMER
       disc 4, 4, clr, 1 / (2 ^ x)
       disc 5, 5, clr, 1 / (2 ^ x)
       disc 4, 5, clr, 1 / (2 ^ x)
       disc 5, 4, clr, 1 / (2 ^ x)
      NEXT
     CASE 1
      clr = (scheme + 1) + 8 * invert
      IF mode = 1 THEN clr = 2 - invert
      FOR x = 0 TO 3
       disc 5, 4, 0, 2 ^ x
       disc 4, 5, 0, 2 ^ x
       IF mode <> 1 THEN
        disc 4, 4, 15, 2 ^ x
        disc 5, 5, 15, 2 ^ x
       ELSE
        disc 4, 4, 3, 2 ^ x
        disc 5, 5, 3, 2 ^ x
       END IF
       DO: LOOP UNTIL TIMER - x! > .15
       x! = TIMER
       disc 4, 4, clr, 2 ^ x
       disc 5, 5, clr, 2 ^ x
       disc 4, 5, clr, 2 ^ x
       disc 5, 4, clr, 2 ^ x
      NEXT
      FOR x = 3 TO 0 STEP -1
       disc 4, 4, 0, 2 ^ x
       disc 5, 5, 0, 2 ^ x
       IF mode <> 1 THEN
        disc 4, 5, 15, 2 ^ x
        disc 5, 4, 15, 2 ^ x
       ELSE
        disc 4, 5, 3, 2 ^ x
        disc 5, 4, 3, 2 ^ x
       END IF
       DO: LOOP UNTIL TIMER - x! > .15
       x! = TIMER
       disc 4, 4, clr, 2 ^ x
       disc 5, 5, clr, 2 ^ x
       disc 4, 5, clr, 2 ^ x
       disc 5, 4, clr, 2 ^ x
      NEXT
     CASE 2
      IF mode <> 13 THEN
       FOR x = 0 TO 8 STEP 8
        DO: LOOP UNTIL TIMER - x! > .15
        x! = TIMER
        disc 4, 5, x, 1
        disc 5, 4, x, 1
        disc 4, 4, 15 - x, 1
        disc 5, 5, 15 - x, 1
       NEXT
       FOR x = 8 TO 0 STEP -8
        DO: LOOP UNTIL TIMER - x! > .15
        x! = TIMER
        disc 5, 5, x, 1
        disc 4, 4, x, 1
        disc 4, 5, 15 - x, 1
        disc 5, 4, 15 - x, 1
       NEXT
      ELSE
       FOR x = 16 TO 31
        disc 4, 5, x, 1
        disc 5, 4, x, 1
        disc 4, 4, 47 - x, 1
        disc 5, 5, 47 - x, 1
        DO: LOOP UNTIL TIMER - x! > .025
        x! = TIMER
       NEXT
      END IF
    END SELECT
   CASE 3: opponent = choice
  END SELECT
 END IF
 IF z < 4 THEN
  choice = oldchoice
  drawboard
  IF mode = 1 THEN
   disc 4, 4, 3, 1
   disc 5, 5, 3, 1
  ELSE
   disc 4, 4, 15, 1
   disc 5, 5, 15, 1
  END IF
  disc 4, 5, 0, 1
  disc 5, 4, 0, 1
  configtext
 END IF
END SUB

SUB configtext
 IF scrn <> 1 THEN
  item(0) = "Graphics Mode"
  IF mode <> 1 THEN item(1) = "Color Scheme" ELSE item(1) = "-"
 ELSE
  item(0) = "-"
  item(1) = "-"
  choice = 3
 END IF
 item(2) = "Flip Style"
 item(3) = "Opponent"
 IF invert THEN item(4) = "Invert On" ELSE item(4) = "Invert Off"
 item(5) = "Save"
 item(6) = "Exit"
 maxchoice = 6
 IF mode <> 1 THEN COLOR 15
 SELECT CASE mode
  CASE 12, 9
   LOCATE 2, 60: PRINT "Configure"
   LOCATE 5, 54: PRINT "Controls:"
   LOCATE 7, 56: PRINT "Arrows - Move"
   LOCATE 8, 56: PRINT "Enter - Select"
  CASE 13, 7, 1
   LOCATE 2, 30: PRINT "Configure"
   LOCATE 5, 28: PRINT "Controls:"
   LOCATE 7, 27: PRINT "Arrows - Move"
   LOCATE 8, 27: PRINT "Enter - Select"
 END SELECT
 DO WHILE LEFT$(item(choice), 1) = "-"
  choice = choice + 1
 LOOP
 IF mode <> 1 THEN COLOR 15
 FOR x = 0 TO maxchoice
  IF mode = 12 OR mode = 9 THEN LOCATE x + 15, 56 ELSE LOCATE x + 15, 27
  PRINT item(x)
 NEXT
 IF mode <> 1 THEN COLOR scheme + 9 - invert * 8
 IF mode = 12 OR mode = 9 THEN LOCATE choice + 15, 56 ELSE LOCATE choice + 15, 27
 PRINT item(choice)
 IF mode = 1 THEN LINE (208, choice * 8 + 112)-(309, choice * 8 + 119), , B
END SUB

SUB cvalue (a, b, x, y)
 DO
  grid(a, b) = turn
  olda = a
  oldb = b
  IF a > x THEN a = a - 1
  IF a < x THEN a = a + 1
  IF b > y THEN b = b - 1
  IF b < y THEN b = b + 1
 LOOP UNTIL olda = a AND oldb = b
END SUB

SUB disc (x, y, z, a!)
 SELECT CASE mode
  CASE 12
   CIRCLE ((x - 1) * 50 + 25, (y - 1) * 50 + 25), 20, z, , , a!
   PAINT ((x - 1) * 50 + 25, (y - 1) * 50 + 25), z, z
  CASE 13, 7, 1
   a! = a! * .9
   CIRCLE ((x - 1) * 25 + 12, (y - 1) * 20 + 10), 8 - a! / 5, z, , , a!
   PAINT ((x - 1) * 25 + 12, (y - 1) * 20 + 10), z, z
  CASE 9
   a! = a! * .75
   CIRCLE ((x - 1) * 50 + 25, (y - 1) * 35 + 17), 20 - a! * 2, z, , , a!
   PAINT ((x - 1) * 50 + 25, (y - 1) * 35 + 17), z, z
 END SELECT
END SUB

SUB drawboard
 clr1 = scheme + 1
 clr2 = scheme + 9
 IF mode = 1 THEN clr1 = 2: clr2 = 1
 IF invert THEN SWAP clr1, clr2
 CLS
 SCREEN mode
 SELECT CASE mode
  CASE 12
   LINE (0, 0)-(399, 399), clr1, BF           '50x50
   FOR x = 0 TO 8
    LINE (50 * x, 0)-(50 * x + 1, 401), clr2, B
    LINE (0, 50 * x)-(399, 50 * x + 1), clr2, B
   NEXT
  CASE 13, 7, 1
   LINE (0, 0)-(199, 159), clr1, BF           '25x20
   FOR x = 0 TO 8
    LINE (25 * x, 0)-(25 * x + 1, 161), clr2, B
    LINE (0, 20 * x)-(199, 20 * x + 1), clr2, B
   NEXT
  CASE 9
   LINE (0, 0)-(399, 279), clr1, BF           '50x35
   FOR x = 0 TO 8
    LINE (50 * x, 0)-(50 * x + 1, 281), clr2, B
    LINE (0, 35 * x)-(399, 35 * x + 1), clr2, B
   NEXT
 END SELECT
END SUB

SUB endgame
 CLS
 SCREEN 0
 WIDTH 80, 25
 FOR y = 1 TO 8
  FOR z = 1 TO 8
   IF grid(y, z) = 1 THEN a = a + 1
   IF grid(y, z) = 2 THEN b = b + 1
  NEXT
 NEXT
 IF a > b THEN
  center 9, "Black wins!"
 ELSEIF b > a THEN center 10, "White wins!"
 ELSE center 10, "Tie!"
 END IF
 center 11, "Black discs:" + STR$(a)
 center 12, "White discs:" + STR$(b)
 WHILE INKEY$ <> "": WEND
 WHILE INKEY$ = "": WEND
 done = 1
 game = 0
END SUB

SUB flip (a, b, x, y, c!, clr)
 e = a
 f = b
 DO
  disc e, f, clr, (c!)
  olde = e: oldf = f
  IF x > e THEN e = e + 1
  IF x < e THEN e = e - 1
  IF y > f THEN f = f + 1
  IF y < f THEN f = f - 1
 LOOP UNTIL olde = e AND oldf = f
END SUB

SUB instruct
 CLS
 COLOR 15
 center 3, "Othello:  Instructions"
 center 6, "    The Othello game board is an 8 x 8 grid.  Two players,"
 center 7, "white and black, attempt to fill the board as much as     "
 center 8, "possible with their color discs.  When neither player can "
 center 9, "move, the game is over.  To gain control of the board,    "
 center 10, "player must flip the other player's discs.  This is called"
 center 11, "outflanking.  Outflanking occurs when a disc is placed at "
 center 12, "the end of a row of the other player's color.  This row   "
 center 13, "must be bordered at both ends of by a disc of the current "
 center 14, "player's color.  More than one row can be flipped at a    "
 center 15, "time.  If a player cannot outflank a disc, his/her turn is"
 center 16, "forfeited.  The game is over when neither player can make "
 center 17, "a move.                                                   "
 center 21, "Press any key to continue"
 WHILE INKEY$ = "": WEND
END SUB

SUB loaddata
 x = scrn
 OPEN "othello.cfg" FOR BINARY AS #1
 GET #1, , scrn
 GET #1, , mode
 GET #1, , scheme
 GET #1, , invert
 GET #1, , discstyle
 GET #1, , opponent
 CLOSE
 IF x <> scrn THEN
  mode = x
  scrn = x
 END IF
 IF mode = 1 AND discstyle = 2 THEN discstyle = 0
END SUB

SUB main
 DO
  CLS
  SCREEN 0, , 0, 0
  LOCATE , , 0
  WIDTH 80, 25
  COLOR 7
  center 4, "Ver 1.0"
  center 5, "Chad Austin"
  COLOR 10
  center 7, "    Othello is a strategy game in which two players"
  center 8, "place white and black discs on the playing board in"
  center 9, "the attempt to outflank the other player's discs.  "
  center 10, "If a player cannot outflank on their turn, they    "
  center 11, "must forfeit.  When neither player can make a move,"
  center 12, "the game is over.  The player with the highest     "
  center 13, "number of discs on the board wins.                 "
  COLOR 15
  center 18, "1) Play        "
  center 19, "2) Configure   "
  center 20, "3) Instructions"
  center 21, "4) Quit        "
  x = 1
  WHILE INKEY$ <> "": WEND
  DO
   x = x XOR 1
   COLOR (x * 7) + 8
   center 2, "Othello"
   x! = TIMER
   DO
    a = VAL(INKEY$)
   LOOP UNTIL TIMER - x! > .5 OR a AND a < 5
  LOOP UNTIL a AND a < 5
  SELECT CASE a
   CASE 1: othello
   CASE 2: config
   CASE 3: instruct
  END SELECT
 LOOP UNTIL a = 4
END SUB

SUB movecursor (x)
 IF mode <> 1 THEN
  COLOR 15
  IF mode = 12 OR mode = 9 THEN LOCATE choice + 15, 56 ELSE LOCATE choice + 15, 27
  PRINT item(choice)
  DO
   choice = choice + x
   IF choice > maxchoice THEN choice = 0
   IF choice < 0 THEN choice = maxchoice
  LOOP UNTIL LEFT$(item(choice), 1) <> "-"
  COLOR scheme + 9 - invert * 8
  IF mode = 12 OR mode = 9 THEN LOCATE choice + 15, 56 ELSE LOCATE choice + 15, 27
  PRINT item(choice)
 ELSE
  LOCATE choice + 15, 27: PRINT item(choice)
  DO
   choice = choice + x
   IF choice > maxchoice THEN choice = 0
   IF choice < 0 THEN choice = maxchoice
  LOOP UNTIL LEFT$(item(choice), 1) <> "-"
  LINE (208, choice * 8 + 112)-(309, choice * 8 + 119), 15, B
 END IF
END SUB

SUB movesquare (x, y)
 IF mode = 1 THEN clr = invert + 1 ELSE clr = scheme + 9 - invert * 8
 SELECT CASE mode
  CASE 12: LINE ((col - 1) * 50 + 1, (row - 1) * 50 + 1)-((col - 1) * 50 + 50, (row - 1) * 50 + 50), clr, B
  CASE 13, 7, 1: LINE ((col - 1) * 25 + 1, (row - 1) * 20 + 1)-((col - 1) * 25 + 25, (row - 1) * 20 + 20), clr, B
  CASE 9: LINE ((col - 1) * 50 + 1, (row - 1) * 35 + 1)-((col - 1) * 50 + 50, (row - 1) * 35 + 35), clr, B
 END SELECT
 col = col + x
 row = row + y
 IF col = 0 THEN col = 8
 IF col = 9 THEN col = 1
 IF row = 0 THEN row = 8
 IF row = 9 THEN row = 1
 IF invert = 1 THEN clr = 15 ELSE clr = 0
 SELECT CASE mode
  CASE 12: LINE ((col - 1) * 50 + 1, (row - 1) * 50 + 1)-((col - 1) * 50 + 50, (row - 1) * 50 + 50), clr, B
  CASE 13, 7, 1: LINE ((col - 1) * 25 + 1, (row - 1) * 20 + 1)-((col - 1) * 25 + 25, (row - 1) * 20 + 20), clr, B
  CASE 9: LINE ((col - 1) * 50 + 1, (row - 1) * 35 + 1)-((col - 1) * 50 + 50, (row - 1) * 35 + 35), clr, B
 END SELECT
END SUB

SUB othello
 drawboard
 IF game = 0 THEN
  IF mode = 1 THEN
   disc 4, 4, 3, 1
   disc 5, 5, 3, 1
  ELSE
   disc 4, 4, 15, 1
   disc 5, 5, 15, 1
  END IF
  disc 4, 5, 0, 1
  disc 5, 4, 0, 1
  FOR x = 1 TO 8
   FOR y = 1 TO 8
    grid(x, y) = 0
   NEXT
  NEXT
  game = 1
  grid(4, 4) = 2
  grid(5, 5) = 2
  grid(4, 5) = 1
  grid(5, 4) = 1
  vturn = 1
 ELSE
  FOR x = 1 TO 8
   FOR y = 1 TO 8
    IF mode = 1 THEN clr = (grid(x, y) - 1) * 3 ELSE clr = (grid(x, y) - 1) * 15
    IF grid(x, y) THEN disc x, y, clr, 1
   NEXT
  NEXT
 END IF
 SELECT CASE mode
  CASE 12, 9
   LOCATE 2, 60: PRINT "Othello"
   LOCATE 3, 58: PRINT "Chad Austin"
   LOCATE 5, 54: PRINT "Controls:"
   LOCATE 7, 56: PRINT "Q - Quit"
   LOCATE 8, 56: PRINT "Arrows - Move"
   LOCATE 9, 56: PRINT "Space - Select"
  CASE 13, 7, 1
   LOCATE 2, 30: PRINT "Othello"
   LOCATE 3, 28: PRINT "Chad Austin"
   LOCATE 5, 28: PRINT "Controls:"
   LOCATE 7, 27: PRINT "Q - Quit"
   LOCATE 8, 27: PRINT "Arrows - Move"
   LOCATE 9, 27: PRINT "Space - Select"
 END SELECT
 row = 1
 col = 1
 IF invert THEN
  IF mode = 1 THEN clr = 3 ELSE clr = 15
 ELSE clr = 0
 END IF
 SELECT CASE mode
  CASE 12: LINE (1, 1)-(50, 50), clr, B
  CASE 13, 7, 1: LINE (1, 1)-(25, 20), clr, B
  CASE 9: LINE (1, 1)-(50, 35), clr, B
 END SELECT
 DO
  FOR turn = vturn TO 2 - opponent
   vturn = 1
   done = 0
   IF mode = 12 OR mode = 9 THEN LOCATE 11, 56 ELSE LOCATE 11, 27
   PRINT "Working     "
   checkturns 1
   IF opponent = 0 THEN checkturns 2
   IF ready(turn) THEN
    DO
     IF mode <> 1 THEN COLOR 15
     IF mode = 12 OR mode = 9 THEN LOCATE 11, 56 ELSE LOCATE 11, 27
     IF turn = 1 THEN PRINT "Black's Turn" ELSE PRINT "White's Turn"
     DO
      kbd$ = UCASE$(INKEY$)
     LOOP UNTIL kbd$ <> ""
     SELECT CASE kbd$
      CASE CHR$(0) + "H": movesquare 0, -1
      CASE CHR$(0) + "M": movesquare 1, 0
      CASE CHR$(0) + "P": movesquare 0, 1
      CASE CHR$(0) + "K": movesquare -1, 0
      CASE CHR$(0) + "I": movesquare 1, -1
      CASE CHR$(0) + "Q": movesquare 1, 1
      CASE CHR$(0) + "O": movesquare -1, 1
      CASE CHR$(0) + "G": movesquare -1, -1
      CASE " ": selectsquare
      CASE "Q", CHR$(27)
       IF mode = 12 OR mode = 9 THEN LOCATE 13, 56 ELSE LOCATE 13, 27
       PRINT "Quit?"
       configinit 4
       IF mode = 12 OR mode = 9 THEN LOCATE 13, 56 ELSE LOCATE 13, 27
       PRINT "     "
       clearchoices
       IF choice = 0 THEN
        vturn = turn
        EXIT SUB
       END IF
     END SELECT
    LOOP UNTIL done
   END IF
   IF ready(1) = 0 AND ready(2) = 0 THEN turn = 2
  NEXT
  checkturns 2
  IF opponent AND ready(2) THEN
   IF mode = 12 OR mode = 9 THEN LOCATE 11, 56 ELSE LOCATE 11, 27
   PRINT "Computer    "
   compmove
   vturn = 1
  END IF
 LOOP WHILE ready(1) OR ready(2)
 endgame
END SUB

SUB selectsquare
 IF grid(col, row) = 0 THEN
  d = 0
  FOR z = 1 TO 8
   i = 0
   a = 0
   x = col
   y = row
   DO
    SELECT CASE z
     CASE 1: y = y - 1
     CASE 2: x = x + 1: y = y - 1
     CASE 3: x = x + 1
     CASE 4: x = x + 1: y = y + 1
     CASE 5: y = y + 1
     CASE 6: x = x - 1: y = y + 1
     CASE 7: x = x - 1
     CASE 8: x = x - 1: y = y - 1
    END SELECT
    IF y > 0 AND y < 9 AND x > 0 AND x < 9 THEN
     IF grid(x, y) = turn THEN
      IF a AND ((ABS(x - col) > 1 OR ABS(y - row) > 1)) THEN i = 1
     ELSEIF grid(x, y) = 3 - turn THEN a = 1
     END IF
    END IF
    b = 0
    IF x > 0 AND x < 9 AND y > 0 AND y < 9 THEN IF grid(x, y) = 0 OR grid(x, y) = turn THEN b = 1
   LOOP UNTIL x < 1 OR x > 8 OR y < 1 OR y > 8 OR i OR b
   IF i THEN
    d = 1
    IF mode = 1 THEN disc col, row, (turn - 1) * 3, 1 ELSE disc col, row, (turn - 1) * 15, 1
    grid(col, row) = turn
    done = 1
    IF x > col THEN x = x - 1
    IF x < col THEN x = x + 1
    IF y > row THEN y = y - 1
    IF y < row THEN y = y + 1
    SELECT CASE discstyle
     CASE 0
      clr = (scheme + 1) + 8 * invert
      IF mode = 1 THEN clr = 2 - invert
      IF mode = 1 THEN tclr = (2 - turn) * 3 ELSE tclr = (2 - turn) * 15
      FOR c = 0 TO 3
       calcadj x, y, a, b
       flip a, b, x, y, 1 / (2 ^ c), tclr
       DO: LOOP UNTIL TIMER - x! > .15
       x! = TIMER
       flip a, b, x, y, 1 / (2 ^ c), clr
      NEXT
      IF mode = 1 THEN tclr = (turn - 1) * 3 ELSE tclr = (turn - 1) * 15
      FOR c = 3 TO 0 STEP -1
       calcadj x, y, a, b
       flip a, b, x, y, 1 / (2 ^ c), tclr
       DO: LOOP UNTIL TIMER - x! > .15
       x! = TIMER
       IF c = 0 THEN
        flip a, b, x, y, 1, tclr
        calcadj x, y, a, b
        cvalue a, b, x, y
       ELSE flip a, b, x, y, 1 / (2 ^ c), clr
       END IF
      NEXT
     CASE 1
      clr = (scheme + 1) + 8 * invert
      IF mode = 1 THEN clr = 2 - invert
      IF mode = 1 THEN tclr = (2 - turn) * 3 ELSE tclr = (2 - turn) * 15
      FOR c = 0 TO 3
       calcadj x, y, a, b
       flip a, b, x, y, 2 ^ c, tclr
       DO: LOOP UNTIL TIMER - x! > .15
       x! = TIMER
       flip a, b, x, y, 2 ^ c, clr
      NEXT
      IF mode = 1 THEN tclr = (turn - 1) * 3 ELSE tclr = (turn - 1) * 15
      FOR c = 3 TO 0 STEP -1
       calcadj x, y, a, b
       flip a, b, x, y, 2 ^ c, tclr
       DO: LOOP UNTIL TIMER - x! > .15
       x! = TIMER
       IF c = 0 THEN
        flip a, b, x, y, 1, tclr
        calcadj x, y, a, b
        cvalue a, b, x, y
       ELSE flip a, b, x, y, 2 ^ c, clr
       END IF
      NEXT
     CASE 2
      calcadj x, y, a, b
      IF mode <> 13 THEN
       FOR c = 0 TO 8 STEP 8
        DO: LOOP UNTIL TIMER - x! > .15
        x! = TIMER
        IF turn = 1 THEN flip a, b, x, y, 1, 15 - c ELSE flip a, b, x, y, 1, c
       NEXT
       FOR c = 8 TO 0 STEP -8
        DO: LOOP UNTIL TIMER - x! > .15
        x! = TIMER
        IF turn = 1 THEN flip a, b, x, y, 1, c ELSE flip a, b, x, y, 1, 15 - c
       NEXT
      ELSE
       FOR c = 16 TO 31
        IF turn = 1 THEN
         flip a, b, x, y, 1, 47 - c
        ELSE
         flip a, b, x, y, 1, c
        END IF
        DO: LOOP UNTIL TIMER - x! > .025
        x! = TIMER
       NEXT
      END IF
      calcadj x, y, a, b
      flip a, b, x, y, 1, (turn - 1) * 15
      cvalue a, b, x, y
     CASE 3
      IF mode = 1 THEN tclr = (turn - 1) * 3 ELSE tclr = (turn - 1) * 15
      calcadj x, y, a, b
      flip a, b, x, y, 1, tclr
      cvalue a, b, x, y
    END SELECT
   END IF
  NEXT
  IF d = 0 THEN BEEP
 ELSE BEEP
 END IF
END SUB

