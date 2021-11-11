' Chad Austin
' Triangular Fractal
' 5-18-96
' Written in MS-DOS QBasic

SCREEN 12
WINDOW (0, 0)-(1, 1)
DO
 DO
  SELECT CASE RND
   CASE IS > 2 / 3
    x = x / 2
    y = y / 2
   CASE IS > 1 / 3
    x = .5 * (.5 + x)
    y = .5 * (1 + y)
   CASE ELSE
    x = .5 * (1 + x)
    y = .5 * y
  END SELECT
 LOOP UNTIL POINT(x, y) = 0
 PSET (x, y)
LOOP UNTIL INKEY$ <> ""
CLS

