DECLARE SUB DrawMan ()
DECLARE SUB PlayPacMan ()

CONST true = NOT 0
CONST false = NOT true
CONST right = 1
CONST left = 2
CONST up = 3
CONST down = 4

TYPE SquareType
  Wall AS STRING * 4
  Dot  AS INTEGER
END TYPE

DIM SHARED square(25, 18) AS SquareType
DIM SHARED RightOpen&(250), RightClose&(250)
DIM SHARED LeftOpen&(250), LeftClose&(250)
DIM SHARED UpOpen&(250), UpClose&(250)
DIM SHARED DownOpen&(250), DownClose&(250)
DIM SHARED deg#, level, dir, col, row, speed#

DrawMan
PlayPacMan

SUB Center (row%, text$)
  LOCATE row%, 41 - (LEN(text$) / 2 + .5)
  PRINT text$
END SUB

SUB DrawMan
  deg# = 4 * ATN(1) / 180
  SCREEN 12
  CIRCLE (100, 100), 20, 14, 45 * deg#, 315 * deg#
  CIRCLE (95, 90), 3, 14
  LINE (100, 100)-(114, 86), 14
  LINE (100, 100)-(114, 114), 14
  PAINT (90, 100), 14, 14
  GET (80, 80)-(120, 120), RightOpen&
  PUT (80, 80), RightOpen&, XOR
  CIRCLE (100, 100), 20, 14
  CIRCLE (100, 90), 3, 14
  PAINT (100, 100), 14, 14
  LINE (100, 100)-(120, 100), 0
  GET (80, 80)-(120, 120), RightClose&
  PUT (80, 80), RightClose&, XOR
  CIRCLE (100, 100), 20, 14, 225 * deg#, 135 * deg#
  CIRCLE (105, 90), 3, 14
  LINE (100, 100)-(86, 86), 14
  LINE (100, 100)-(86, 114), 14
  PAINT (110, 100), 14, 14
  GET (80, 80)-(120, 120), LeftOpen&
  PUT (80, 80), LeftOpen&, XOR
  CIRCLE (100, 100), 20, 14
  CIRCLE (100, 90), 3, 14
  PAINT (100, 100), 14, 14
  LINE (100, 100)-(80, 100), 0
  GET (80, 80)-(120, 120), LeftClose&
  PUT (80, 80), LeftClose&, XOR
  CIRCLE (100, 100), 20, 14, 135 * deg#, 45 * deg#
  CIRCLE (90, 105), 3, 14
  LINE (100, 100)-(86, 86), 14
  LINE (100, 100)-(114, 86), 14
  PAINT (100, 110), 14, 14
  GET (80, 80)-(120, 120), UpOpen&
  PUT (80, 80), UpOpen&, XOR
  CIRCLE (100, 100), 20, 14
  CIRCLE (90, 100), 3, 14
  PAINT (100, 100), 14, 14
  LINE (100, 100)-(100, 80), 0
  GET (80, 80)-(120, 120), UpClose&
  PUT (80, 80), UpClose&, XOR
  CIRCLE (100, 100), 20, 14, 315 * deg#, 225 * deg#
  CIRCLE (110, 95), 3, 14
  LINE (100, 100)-(86, 114), 14
  LINE (100, 100)-(114, 114), 14
  PAINT (100, 90), 14, 14
  GET (80, 80)-(120, 120), DownOpen&
  PUT (80, 80), DownOpen&, XOR
  CIRCLE (100, 100), 20, 14
  CIRCLE (110, 100), 3, 14
  PAINT (100, 100), 14, 14
  LINE (100, 100)-(100, 120), 0
  GET (80, 80)-(120, 120), DownClose&
  PUT (80, 80), DownClose&, XOR
END SUB

SUB PlayPacMan
  start = TIMER
  FOR x = 1 TO 500: NEXT
  speed# = 50 / (TIMER - start)
  dir = right
  col = 0
  row = 0
  FOR x% = 1 TO 5000
   PSET (RND * 625, RND * 475), 15
  NEXT
  DO
    kbd$ = INKEY$
    SELECT CASE kbd$
    CASE CHR$(0) + "M": dir = right
    CASE CHR$(0) + "K": dir = left
    CASE CHR$(0) + "H": dir = up
    CASE CHR$(0) + "P": dir = down
    END SELECT
    SELECT CASE dir
    CASE right
      IF col <= 580 THEN col = col + 15
      SELECT CASE col MOD 2
      CASE 0
        PUT (col, row), RightOpen&, PSET
        FOR x = 1 TO speed#: NEXT
        PUT (col, row), RightOpen&, XOR
      CASE 1
        PUT (col, row), RightClose&, PSET
        FOR x = 1 TO speed#: NEXT
        PUT (col, row), RightClose&, XOR
      END SELECT
    CASE left
      IF col >= 15 THEN col = col - 15
      SELECT CASE col MOD 2
      CASE 0
        PUT (col, row), LeftOpen&, PSET
        FOR x = 1 TO speed#: NEXT
        PUT (col, row), LeftOpen&, XOR
      CASE 1
        PUT (col, row), LeftClose&, PSET
        FOR x = 1 TO speed#: NEXT
        PUT (col, row), LeftClose&, XOR
      END SELECT
    CASE up
      IF row >= 15 THEN row = row - 15
      SELECT CASE row MOD 2
      CASE 0
        PUT (col, row), UpOpen&, PSET
        FOR x = 1 TO speed#: NEXT
        PUT (col, row), UpOpen&, XOR
      CASE 1
        PUT (col, row), UpClose&, PSET
        FOR x = 1 TO speed#: NEXT
        PUT (col, row), UpClose&, XOR
      END SELECT
    CASE down
      IF row <= 430 THEN row = row + 15
      SELECT CASE row MOD 2
      CASE 0
        PUT (col, row), DownOpen&, PSET
        FOR x = 1 TO speed#: NEXT
        PUT (col, row), DownOpen&, XOR
      CASE 1
        PUT (col, row), DownClose&, PSET
        FOR x = 1 TO speed#: NEXT
        PUT (col, row), DownClose&, XOR
      END SELECT
    END SELECT
  LOOP UNTIL kbd$ = CHR$(27)
END SUB

