DEFINT A-Z
DECLARE FUNCTION getstring$ (row%, col%, text$, length%)
DECLARE SUB armorstats ()
DECLARE SUB beginstats ()
DECLARE SUB box (y1%, x1%, y2%, x2%)
DECLARE SUB center (row%, text$)
DECLARE SUB getinputs ()
DECLARE SUB restoregame ()
TYPE handtype
 typ AS INTEGER
 num AS INTEGER
END TYPE
TYPE playertype
 char   AS STRING * 10
 nam    AS STRING * 12
 gender AS STRING * 6
 rhand  AS handtype
 lhand  AS handtype
 Head   AS INTEGER
 body   AS INTEGER
 arms   AS INTEGER
 feet   AS INTEGER
 str    AS INTEGER
 agi    AS INTEGER
 intl   AS INTEGER
 sta    AS INTEGER
 cha    AS INTEGER
END TYPE
 OPTION BASE 1
 DIM SHARED player(4) AS playertype
 DIM map(16, 10, 8, 8)
 DIM SHARED square(0 TO 200, 16) AS LONG
 ON ERROR GOTO screenerror
 CLS
 SCREEN 12
 SCREEN 0
 WIDTH 80, 25
 ON ERROR GOTO unexpect
 KEY 15, CHR$(0) + CHR$(69)
 KEY(15) ON
 DEF SEG = 0
 x = PEEK(1047)
 IF (x AND 32) = 32 THEN POKE 1047, x XOR 32
 DEF SEG
 restoregame
 getinputs
 beginstats
 KEY(15) OFF
 DEF SEG = 0
 POKE 1047, x
 DEF SEG
 CLS
 END
screenerror: PRINT "You must have a VGA adapter to play DARK.BAS.": END
unexpect: PRINT "Unexpected error.  Ending Program.": END

SUB beginstats
  player(1).body = 1
  player(1).rhand.num = 1
  player(1).rhand.typ = 1
  SELECT CASE RTRIM$(player(1).char)
  CASE "Knight"
    player(1).str = 5
    player(1).agi = 4
    player(1).sta = 6
    player(1).intl = 2
  CASE "Thief"
    player(1).str = 2
    player(1).agi = 6
    player(1).sta = 3
    player(1).intl = 3
    player(1).cha = 3
  CASE "Fighter"
    player(1).str = 5
    player(1).agi = 4
    player(1).sta = 6
    player(1).intl = 2
  CASE "Wh. Mage"
    player(1).agi = 3
    player(1).sta = 2
    player(1).intl = 7
    player(1).cha = 5
  CASE "Bl. Mage"
    player(1).agi = 3
    player(1).sta = 3
    player(1).intl = 8
    player(1).cha = 3
  END SELECT
  IF RTRIM$(player(1).gender) = "Male" THEN
    player(1).str = player(1).str + 2
  ELSE
    player(1).intl = player(1).intl + 1
    player(1).cha = player(1).cha + 2
  END IF
END SUB

SUB box (y1, x1, y2, x2)
 x = x2 - x1
 LOCATE y1, x1
 PRINT CHR$(201); STRING$(x - 1, CHR$(205)); CHR$(187);
 FOR y = y1 + 1 TO y2 - 1
  LOCATE y, x1
  PRINT CHR$(186); SPACE$(x - 1); CHR$(186)
 NEXT
 LOCATE y2, x1
 PRINT CHR$(200); STRING$(x - 1, CHR$(205)); CHR$(188);
END SUB

SUB center (x, a$)
 LOCATE x, 40 - INT(LEN(a$) / 2)
 PRINT a$
END SUB

SUB drawman (x, y)
  SELECT CASE RTRIM$(player(1).char)
  CASE "Knight"
    LINE (x + 7, y + 2)-(x + 8, y + 2), 7
    LINE (x + 6, y + 3)-(x + 9, y + 4), 15, B
    LINE (x + 7, y + 3)-(x + 8, y + 3), 0
    LINE (x + 4, y + 5)-(x + 11, y + 5), 7
    LINE (x + 4, y + 6)-(x + 3, y + 8), 15
    LINE (x + 5, y + 6)-(x + 4, y + 8), 15
    LINE (x + 2, y + 2)-(x + 2, y + 6), 15
    LINE (x + 1, y + 7)-(x + 3, y + 7), 9
    LINE (x + 2, y + 8)-(x + 2, y + 9), 9
    LINE (x + 10, y + 6)-(x + 14, y + 8), 12, BF
    PSET (x + 11, y + 6), 15: PSET (x + 13, y + 6), 0
    LINE (x + 11, y + 9)-(x + 13, y + 9), 12
    PSET (x + 12, y + 10), 12: PSET (x + 10, y + 13), 15
    LINE (x + 6, y + 8)-(x + 9, y + 8), 15
    LINE (x + 6, y + 6)-(x + 9, y + 7), 8, BF
    LINE (x + 7, y + 6)-(x + 8, y + 6), 7
    LINE (x + 6, y + 9)-(x + 6, y + 12), 15
    LINE (x + 5, y + 13)-(x + 7, y + 13), 15
    LINE (x + 7, y + 9)-(x + 7, y + 13), 7
    LINE (x + 8, y + 9)-(x + 8, y + 13), 8
    LINE (x + 9, y + 9)-(x + 9, y + 13), 15
  CASE "Thief"
    LINE (x + 7, y + 1)-(x + 8, y + 1), 2
    LINE (x + 6, y + 2)-(x + 9, y + 2), 12
    PSET (x + 6, y + 3), 2: PSET (x + 9, y + 3), 2
    LINE (x + 7, y + 3)-(x + 8, y + 3), 1
    LINE (x + 6, y + 4)-(x + 9, y + 4), 12
    LINE (x + 5, y + 5)-(x + 10, y + 5), 6
    LINE (x + 7, y + 5)-(x + 8, y + 5), 12
    LINE (x + 6, y + 6)-(x + 9, y + 8), 7, BF
    LINE (x + 5, y + 6)-(x + 4, y + 8), 6
    LINE (x + 6, y + 6)-(x + 5, y + 8), 6
    LINE (x + 4, y + 8)-(x + 4, y + 9), 9
    LINE (x + 4, y + 5)-(x + 4, y + 7), 10
    LINE (x + 10, y + 5)-(x + 12, y + 7), 6
    LINE (x + 10, y + 6)-(x + 12, y + 8), 6
    PSET (x + 9, y + 8), 0: PSET (x + 8, y + 6), 12
    LINE (x + 6, y + 9)-(x + 6, y + 13), 6
    LINE (x + 7, y + 9)-(x + 7, y + 13), 4
    PSET (x + 8, y + 13), 4: PSET (x + 12, y + 13), 4
    LINE (x + 8, y + 9)-(x + 10, y + 13), 6
    LINE (x + 9, y + 9)-(x + 11, y + 13), 4
  CASE "Fighter"
    LINE (x + 7, y + 1)-(x + 8, y + 1), 6
    LINE (x + 6, y + 2)-(x + 9, y + 2), 6
    PSET (x + 6, y + 3), 6: PSET (x + 9, y + 3), 6
    LINE (x + 7, y + 3)-(x + 8, y + 3), 2
    LINE (x + 4, y + 4)-(x + 11, y + 4), 6
    LINE (x + 5, y + 5)-(x + 3, y + 7), 6
    LINE (x + 3, y + 6)-(x + 4, y + 5), 6
    PSET (x + 2, y + 7), 2: PSET (x + 13, y + 7), 2
    LINE (x + 10, y + 5)-(x + 12, y + 7), 6
    LINE (x + 11, y + 5)-(x + 12, y + 6), 6
    LINE (x + 6, y + 5)-(x + 9, y + 9), 6, BF
    LINE (x + 6, y + 5)-(x + 9, y + 8), 4
    LINE (x + 8, y + 5)-(x + 9, y + 6), 4
    LINE (x + 6, y + 7)-(x + 7, y + 8), 4
    LINE (x + 6, y + 9)-(x + 6, y + 11), 4
    LINE (x + 5, y + 12)-(x + 5, y + 13), 4
    PSET (x + 8, y + 9), 4: PSET (x + 12, y + 13), 2
    LINE (x + 10, y + 10)-(x + 10, y + 11), 4
    LINE (x + 11, y + 12)-(x + 11, y + 13), 4
    LINE (x + 5, y + 10)-(x + 5, y + 11), 6
    LINE (x + 4, y + 12)-(x + 4, y + 13), 6
    LINE (x + 6, y + 8)-(x + 9, y + 8), 2
    LINE (x + 9, y + 10)-(x + 9, y + 11), 6
    LINE (x + 10, y + 12)-(x + 10, y + 13), 6
    PSET (x + 3, y + 13), 2
  CASE "Wh. Mage"
    LINE (x + 7, y + 2)-(x + 8, y + 2), 15
    LINE (x + 6, y + 3)-(x + 9, y + 3), 15
    LINE (x + 6, y + 4)-(x + 9, y + 4), 15
    LINE (x + 7, y + 3)-(x + 8, y + 3), 9
    LINE (x + 6, y + 5)-(x + 9, y + 5), 7
    LINE (x + 5, y + 6)-(x + 4, y + 7), 15
    LINE (x + 6, y + 6)-(x + 4, y + 8), 15
    LINE (x + 3, y + 6)-(x + 3, y + 12), 6
    PSET (x + 3, y + 5), 10: PSET (x + 4, y + 5), 14
    LINE (x + 3, y + 4)-(x + 2, y + 5), 14
    LINE (x + 9, y + 6)-(x + 11, y + 8), 15
    LINE (x + 10, y + 6)-(x + 12, y + 8), 15
    PSET (x + 12, y + 9), 10: PSET (x + 13, y + 9), 9
    LINE (x + 11, y + 9)-(x + 12, y + 10), 9
    LINE (x + 7, y + 6)-(x + 6, y + 7), 7
    LINE (x + 8, y + 6)-(x + 9, y + 7), 7
    LINE (x + 7, y + 7)-(x + 8, y + 7), 15
    LINE (x + 6, y + 8)-(x + 9, y + 12), 15, BF
    LINE (x + 9, y + 9)-(x + 9, y + 10), 7
    LINE (x + 10, y + 11)-(x + 10, y + 12), 7
  CASE "Bl. Mage"
    LINE (x + 7, y + 2)-(x + 8, y + 2), 0
    LINE (x + 6, y + 3)-(x + 9, y + 4), 0, B
    LINE (x + 7, y + 3)-(x + 8, y + 3), 3
    LINE (x + 5, y + 6)-(x + 4, y + 7), 0
    LINE (x + 6, y + 6)-(x + 4, y + 8), 0
    LINE (x + 3, y + 6)-(x + 3, y + 12), 7
    PSET (x + 3, y + 5), 9: PSET (x + 4, y + 5), 10
    LINE (x + 2, y + 5)-(x + 3, y + 4), 10
    LINE (x + 6, y + 5)-(x + 9, y + 5), 8
    LINE (x + 9, y + 6)-(x + 11, y + 8), 0
    LINE (x + 10, y + 6)-(x + 11, y + 7), 0
    LINE (x + 12, y + 8)-(x + 12, y + 9), 12
    LINE (x + 12, y + 5)-(x + 12, y + 7), 9
    LINE (x + 7, y + 6)-(x + 6, y + 7), 8
    LINE (x + 8, y + 6)-(x + 9, y + 7), 8
    LINE (x + 7, y + 7)-(x + 8, y + 7), 0
    LINE (x + 6, y + 8)-(x + 9, y + 12), 0, BF
    LINE (x + 9, y + 9)-(x + 9, y + 10), 8
    LINE (x + 10, y + 11)-(x + 10, y + 12), 8
  END SELECT
END SUB

SUB getinputs
 DIM char(4 TO 9) AS STRING * 10
 char(4) = "Fighter   "
 char(5) = "Thief     "
 char(6) = "Warrior   "
 char(7) = "White Mage"
 char(8) = "Black Mage"
 char(9) = "Blue Mage "
 CLS
 COLOR 9
 center 4, char(4)
 COLOR 14
 FOR x = 5 TO 9
  center (x), char(x)
 NEXT
 COLOR 15
 center 2, "CHOOSE YOUR CHARACTER"
 row = 4
 DO
  center 12, "              "
  DO
   DO: kbd$ = INKEY$: LOOP UNTIL kbd$ <> ""
   COLOR 14
   center row, char(row)
   SELECT CASE kbd$
   CASE CHR$(0) + "H"
    row = row - 1
    IF row = 3 THEN row = 9
   CASE CHR$(0) + "P"
    row = row + 1
    IF row = 10 THEN row = 4
   END SELECT
   COLOR 9
   center row, char(row)
  LOOP UNTIL kbd$ = CHR$(13)
  player(1).char = char(row)
  COLOR 10
  center 12, " ale or  emale"
  COLOR 9
  LOCATE 12, 33: PRINT "M"
  LOCATE 12, 41: PRINT "F"
  DO
   kbd$ = UCASE$(INKEY$)
  LOOP UNTIL kbd$ = "M" OR kbd$ = "F" OR kbd$ = CHR$(27)
 LOOP UNTIL kbd$ <> CHR$(27)
 SELECT CASE kbd$
 CASE "M": player(1).gender = "Male"
 CASE "F": player(1).gender = "Female"
 END SELECT
 center 13, player(1).gender
 COLOR 15
 box 15, 26, 17, 52
 player(1).nam = getstring(16, 28, "Your name? ", 12)
END SUB

FUNCTION getstring$ (row, col, text$, length)
 LOCATE row, col: PRINT text$; "_"; SPACE$(length)
 DO
  kbd$ = INKEY$
  SELECT CASE kbd$
  CASE " " TO "}": IF LEN(a$) < length THEN a$ = a$ + kbd$
  CASE CHR$(8)
   IF LEN(a$) > 0 THEN a$ = LEFT$(a$, LEN(a$) - 1)
   LOCATE row, col + LEN(text$): PRINT a$; "_ "
  CASE CHR$(13)
   IF LEN(RTRIM$(LTRIM$(a$))) > 0 THEN EXIT DO
   LOCATE row, col + LEN(text$): PRINT SPACE$(LEN(a$) + 1)
   a$ = ""
  END SELECT
  LOCATE row, col + LEN(text$): PRINT a$; "_"
 LOOP
 LOCATE row, col + LEN(text$) + LEN(a$): PRINT " "
 getstring$ = a$
END FUNCTION

SUB restoregame
 
END SUB

