DECLARE SUB Center (row%, text$)
DEFINT A-Z
RANDOMIZE TIMER
ON ERROR GOTO ScreenError
CLS
WIDTH 80, 25
COLOR RND * 14 + 1
Center 2, "Chad Austin's Screen Savers"
COLOR RND * 14 + 1
Center 4, "Which screen saver would you like to run? (1-5)"
DO
 a = VAL(INKEY$)
LOOP UNTIL a > 0 AND a < 6
Center 9, "  Screen Modes  "
Center 10, "CGA, EGA, VGA, MCGA = 1, 2"
Center 11, "EGA, VGA = 7, 8, 9        "
Center 12, "Monochrome EGA, VGA = 10  "
Center 13, "VGA, MCGA = 11, 13        "
Center 14, "VGA = 12                  "
DO
 LOCATE 7, 1
 LINE INPUT "Which screen mode would you like to use? (1-2, 7-13) ", scr$
 scr = VAL(scr$)
LOOP UNTIL scr > 0 AND scr < 3 OR scr > 6 AND scr < 14
SELECT CASE scr
CASE 1, 7, 13
 x = 319
 y = 199
CASE 2, 8
 x = 639
 y = 199
CASE 9, 10
 x = 639
 y = 349
CASE 11, 12
 x = 639
 y = 479
END SELECT
SELECT CASE scr
CASE 1, 10
 num = 3
CASE 2, 11
 num = 1
CASE 7, 8, 9, 12
 num = 15
CASE 13
 num = 255
END SELECT
Center 18, "Number colors =" + STR$(num + 1)
Center 19, "X Resolution  =" + STR$(x + 1)
Center 20, "Y Resolution  =" + STR$(y + 1)
WHILE INKEY$ = "": WEND
CLS
SELECT CASE a
CASE 1
 COLOR RND * 14 + 1
 Center 2, "Chad Austin's Screen Saver"
 Center 3, "February 6, 1995 A.D.   4:08 p.m."
 COLOR 15
 Center 4, "Edited on 8/27/95 at 5:42 p.m."
 COLOR RND * 14 + 1
 DO
  LOCATE 16, 10
  LINE INPUT "Size of Square (0-200) "; s$
  s = VAL(s$)
 LOOP UNTIL s < 201 AND s > -1
 COLOR RND * 14 + 1
 Center 20, "Do you want the square to be filled (Y/N)"
 WHILE f$ <> "Y" AND f$ <> "N"
  f$ = UCASE$(INKEY$)
 WEND
 SCREEN scr
 DO
  xx = RND * x
  yy = RND * y
  IF f$ = "Y" THEN
   LINE (xx - CINT(s / 2), yy - CINT(s / 2))-(xx + CINT(s / 2), yy + CINT(s / 2)), CINT(RND * num), BF
  ELSE
   LINE (xx - CINT(s / 2), yy - CINT(s / 2))-(xx + CINT(s / 2), yy + CINT(s / 2)), CINT(RND * num), B
  END IF
 LOOP UNTIL INKEY$ <> ""
CASE 2
 IF num > 2 THEN
  CLS
  COLOR RND * 14 + 1
  Center 1, "Chad Austin's Second Screen Saver"
  Center 2, "February 6, 1995 A.D.   7:21 p.m."
  Center 22, "Hit any key to continue"
  SCREEN scr
  DO
   a = a + 1
   IF a MOD 2 THEN
    COLOR CINT(RND * num)
    LINE (0, y / 2)-(x, y / 2)
    LINE (x / 2, 0)-(x / 2, y)
    LINE (0, 0)-(x, y)
    LINE (0, y)-(x, 0)
    LINE (0, y / 4)-(x, y * 3 / 4), 0
    LINE (0, y * 3 / 4)-(x, y / 4), 0
    LINE (x * 3 / 4, 0)-(x / 4, y), 0
    LINE (x / 4, 0)-(x * 3 / 4, y), 0
   ELSE
    COLOR CINT(RND * num)
    LINE (0, y / 4)-(x, y * 3 / 4)
    LINE (0, y * 3 / 4)-(x, y / 4)
    LINE (x * 3 / 4, 0)-(x / 4, y)
    LINE (x / 4, 0)-(x * 3 / 4, y)
    LINE (0, y / 2)-(x, y / 2), 0
    LINE (x / 2, 0)-(x / 2, y), 0
    LINE (0, 0)-(x, y), 0
    LINE (0, y)-(x, 0), 0
   END IF
   x! = 1
   FOR c = 1 TO 30
    CIRCLE (x / 2, y / 2), x!, num * (a MOD 4) / 4
    x! = x! * 1.25
   NEXT
  LOOP UNTIL INKEY$ <> ""
 ELSE PRINT "The current screen mode must have at least 4 colors."
 END IF
CASE 3
 CLS
 SCREEN scr
 DO
  CIRCLE (RND * x, RND * y), (RND ^ 2) * y / 2, RND * num
 LOOP UNTIL INKEY$ <> ""
CASE 4
 CLS
 DO
  LINE INPUT "What loop rate do you want (1-100000) "; l$
  l = VAL(l$)
 LOOP UNTIL l > 0 AND l < 100001
 SCREEN scr
 DO
  FOR a = 0 TO num
   LINE (0, 0)-(x, y), a, BF
   FOR z# = 1 TO l
    IF INKEY$ <> "" THEN EXIT DO
   NEXT
  NEXT
 LOOP
CASE 5
 SCREEN scr
 a = 0
 b = 0
 c = x
 d = y
 DO
  LINE (a, b)-(c, d), RND * num, B
  a = a + 1
  b = b + 1
  c = c - 1
  d = d - 1
  IF a = CINT(x / 2) + 1 THEN a = 0: c = x
  IF b = CINT(y / 2) + 1 THEN b = 0: d = y
 LOOP UNTIL INKEY$ <> ""
END SELECT
SCREEN 0
WIDTH 80, 25
COLOR 7
END
ScreenError:
 CLS
 COLOR 7
 PRINT "I'm sorry, that screen mode will not work with your adapter."
 END

SUB Center (row, text$)
 LOCATE row, 41 - (LEN(text$) / 2 + .5)
 PRINT text$
END SUB

