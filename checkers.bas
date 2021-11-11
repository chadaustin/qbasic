DEFINT A-Z
DECLARE SUB center (x%, a$)
DECLARE SUB checkers ()
DECLARE SUB instruct ()
DECLARE SUB main ()
'$DYNAMIC
 RANDOMIZE TIMER
 ON ERROR GOTO screenerror
 SCREEN 9
 SCREEN 0, , 0, 0
 LOCATE , , 0
 WIDTH 80, 25
 COLOR 7
 ON ERROR GOTO unexpect
 KEY 15, CHR$(0) + CHR$(69)
 KEY(15) ON
 DEF SEG = 0
 x = PEEK(1047)
 IF x AND 32 THEN POKE 1047, x XOR 32
 DEF SEG
 main
 DEF SEG = 0
 POKE 1047, x
 DEF SEG
 SCREEN 0
 CLS
 COLOR 7
 PRINT "Thank you for playing Checkers."
 PRINT "Written by: Chad Austin"
 END
screenerror:
 PRINT "Checkers requires an EGA 64K+ video adapter."
 END
unexpect:
 PRINT "Unexpected error"
 PRINT "Ending program"
 END

REM $STATIC
SUB center (x, a$)
 LOCATE x, 41 - INT(LEN(a$) / 2)
 PRINT a$;
END SUB

SUB checkers

END SUB

SUB instruct

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
  center 7, "    Checkers is a strategy game in which two players "
  center 8, "try to jump and remove opposing playing pieces.  The "
  center 9, "checkers board has 64 squares, 32 of which are never "
  center 10, "used.  When a chance to jump exists, a player must   "
  center 11, "take it.  Pieces may only jump diagonally and        "
  center 12, "forward, but may jump more than once if given the    "
  center 13, "chance.  When a piece reaches the opposite end of the"
  center 14, "board, it is kinged.  This means that it can jump    "
  center 15, "forward and back.  When all of one player's pieces   "
  center 16, "are jumped, the game is over.                        "
  COLOR 15
  center 20, "1) Play     "
  center 21, "2) Configure"
  center 22, "3) Quit     "
  x = 1
  WHILE INKEY$ <> "": WEND
  DO
   x = x XOR 1
   COLOR (x * 4) + 8
   center 2, "Checkers"
   x! = TIMER
   DO
    a = VAL(INKEY$)
   LOOP UNTIL TIMER - x! > .5 OR a AND a < 5
  LOOP UNTIL a AND a < 4
  SELECT CASE a
   CASE 1: checkers
   CASE 2: instruct
  END SELECT
 LOOP UNTIL a = 3
END SUB

