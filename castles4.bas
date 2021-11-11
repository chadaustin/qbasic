DEFINT A-Z
DECLARE FUNCTION cut$ (x%)
DECLARE FUNCTION getint% (row%, col%, a$, L%, h%)
DECLARE SUB center (a%, a$)
DECLARE SUB distpoints (char%, points%)
DECLARE SUB getinputs ()
DECLARE SUB mainmenu ()
DECLARE SUB movecursor (total$, row%, col%, x%, y%)
DECLARE SUB startnew ()
DECLARE SUB restoregame ()
TYPE playertype
 attack AS INTEGER
 defense AS INTEGER
 clr AS INTEGER
 charisma AS INTEGER
 control AS STRING * 1
 country AS STRING * 12
 gender AS STRING * 1
 hp AS INTEGER
 nam AS STRING * 12
 points AS INTEGER
 rank AS INTEGER
 tactics AS INTEGER
END TYPE
'$DYNAMIC
 DIM SHARED player(1 TO 6) AS playertype
 DIM SHARED numplayers
 DIM SHARED ranhome AS STRING * 1
 DIM SHARED ranmap AS STRING * 1
 ON ERROR GOTO screenerror
 SCREEN 9, , 1, 1
 SCREEN 0, , 0, 0
 WIDTH 80, 25
 VIEW PRINT 1 TO 25
 LOCATE 1, 1, 0
 COLOR 15
 ON ERROR GOTO 0
 mainmenu
 CLS
 SCREEN 0
 COLOR 7
 PRINT "Thank you for playing Castles IV."
 PRINT "Castles IV was written in MS-DOS QBasic 1.0."
 PRINT
 PRINT "Begun on 5-18-96"
 PRINT "Last updated on 6-21-96"
 PRINT
 PRINT "Programmer: Chad Austin"
 WHILE INKEY$ = "": WEND
 END
screenerror:
 PRINT "Castles IV requires an EGA adapter with greater than 64K Video RAM."
 END

REM $STATIC
SUB center (a, a$)
 LOCATE a, 41 - INT(LEN(a$) / 2)
 PRINT a$
END SUB

FUNCTION cut$ (x)
 cut$ = LTRIM$(STR$(x))
END FUNCTION

SUB distpoints (char, points)
 DIM stat(4)
 player(char).points = player(char).points + points
 CLS
 COLOR player(char).clr
 LOCATE 4
 PRINT "NAME:     "; player(char).nam
 PRINT "COUNTRY:  "; player(char).country
 PRINT "GENDER:   ";
 IF player(char).gender = "M" THEN PRINT "Male" ELSE PRINT "Female"
 IF points = 4 THEN
  PRINT "NEW RANK: "
 END IF
 LOCATE 4, 30: PRINT "Attack:   "
 LOCATE 5, 30: PRINT "Defense:  "
 LOCATE 6, 30: PRINT "HP:       "
 LOCATE 7, 30: PRINT "Charisma: "
 LOCATE 8, 30: PRINT "Tactics:  "
 COLOR 15
 LOCATE 4, 28: PRINT ""
 DO
  LOCATE 2, 30: PRINT "Remaining points:"; player(char).points
  LOCATE 4, 40: PRINT player(char).attack + stat(0)
  LOCATE 5, 40: PRINT player(char).defense + stat(1)
  LOCATE 6, 40: PRINT player(char).hp + stat(2)
  LOCATE 7, 40: PRINT player(char).charisma + stat(3)
  LOCATE 8, 40: PRINT player(char).tactics + stat(4)
  DO
   kbd$ = INKEY$
  LOOP UNTIL kbd$ <> ""
  SELECT CASE kbd$
   CASE CHR$(0) + "P"
    LOCATE row + 4, 28: PRINT " "
    row = row + 1
    IF row = 5 THEN row = 0
    LOCATE row + 4, 28: PRINT ""
   CASE CHR$(0) + "H"
    LOCATE row + 4, 28: PRINT " "
    row = row - 1
    IF row = -1 THEN row = 4
    LOCATE row + 4, 28: PRINT ""
   CASE "+"
    IF player(char).points THEN
     stat(row) = stat(row) + 1
     player(char).points = player(char).points - 1
    END IF
   CASE "-"
    IF stat(row) THEN
     stat(row) = stat(row) - 1
     player(char).points = player(char).points + 1
    END IF
  END SELECT
 LOOP
END SUB

SUB getinputs
 DIM title(4) AS STRING * 7
 title(0) = "Name"
 title(1) = "Country"
 title(2) = "Color"
 title(3) = "Control"
 title(4) = "Gender"
 CLS
 numplayers = getint(1, 1, "Enter number of players (2-6): ", 2, 6)
 FOR x = 1 TO numplayers
  player(x).nam = ""
  player(x).country = ""
  player(x).clr = x + 1
  player(x).control = "H"
  player(x).gender = "M"
  COLOR x + 1
  LOCATE x + 3, 43: PRINT x + 1
  COLOR 15
  LOCATE x + 3, 56: PRINT "Human"
  LOCATE x + 3, 70: PRINT "Male"
 NEXT
 LOCATE 18: PRINT "Press Ctrl+Enter when done"
 LOCATE 3
 PRINT "Player       ";
 PRINT "Name          Country       Color         Control       Gender"
 LOCATE 4, 2: PRINT 1
 COLOR 15
 FOR x = 2 TO numplayers
  LOCATE x + 3, 2: PRINT x
 NEXT
 LOCATE 4, 14: PRINT "_"
 DO
  LOCATE 16
  SELECT CASE col
   CASE 0: PRINT "Enter your name                   "
   CASE 1: PRINT "Enter your country                "
   CASE 2: PRINT "Press + and - to change your color"
   CASE 3: PRINT "Press space to change control     "
   CASE 4: PRINT "Press space to change your gender "
  END SELECT
  COLOR 1
  LOCATE 3, col * 14 + 14: PRINT title(col)
  LOCATE row + 4, 2: PRINT row + 1
  COLOR 15
  SELECT CASE col
   CASE 0, 1: LOCATE 4 + row, col * 14 + 14: PRINT total$; "_ "
   CASE 2
    COLOR player(row + 1).clr
    LOCATE 4 + row, 44: PRINT cut$(player(row + 1).clr);
    COLOR 15
    PRINT "_ "
   CASE 3: LOCATE 4 + row, 61 + -(player(row + 1).control = "C") * 3: PRINT "_"
   CASE 4: LOCATE 4 + row, 74 + -(player(row + 1).gender = "F") * 2: PRINT "_"
  END SELECT
  DO
   kbd$ = INKEY$
  LOOP UNTIL kbd$ <> ""
  SELECT CASE col
   CASE 0, 1
    IF col = 0 THEN player(row + 1).nam = total$ ELSE player(row + 1).country = total$
    SELECT CASE kbd$
     CASE " " TO "}": IF LEN(total$) < 12 THEN total$ = total$ + kbd$
     CASE CHR$(8): IF LEN(total$) THEN total$ = LEFT$(total$, LEN(total$) - 1)
     CASE CHR$(0) + "S"
      LOCATE row + 4, col * 14 + 14: PRINT SPACE$(12)
      total$ = ""
     CASE CHR$(13), CHR$(9)
      IF col = 0 THEN
       test = 1
       player(row + 1).nam = total$
       FOR x = 1 TO numplayers
        IF (player(row + 1).nam = player(x).nam) AND (row + 1 <> x) THEN test = 0
       NEXT
      ELSE
       test = 1
       player(row + 1).country = total$
      END IF
      IF LEN(total$) <> 0 AND test THEN
       LOCATE 3, col * 14 + 14: PRINT title(col)
       LOCATE row + 4, col * 14 + 14 + LEN(total$): PRINT " "
       col = col + 1
       total$ = RTRIM$(player(row + 1).country)
      END IF
    END SELECT
   CASE 2
    SELECT CASE kbd$
     CASE "=", "+"
      DO
       player(row + 1).clr = player(row + 1).clr + 1
       IF player(row + 1).clr > 14 THEN player(row + 1).clr = 2
       notused = 1
       FOR x = 1 TO numplayers
        IF player(row + 1).clr = player(x).clr AND row + 1 <> x THEN notused = 0
       NEXT
      LOOP UNTIL notused
     CASE "-", "_"
      DO
       player(row + 1).clr = player(row + 1).clr - 1
       IF player(row + 1).clr < 2 THEN player(row + 1).clr = 14
       notused = 1
       FOR x = 1 TO numplayers
        IF player(row + 1).clr = player(x).clr AND row + 1 <> x THEN notused = 0
       NEXT
      LOOP UNTIL notused
     CASE CHR$(13), CHR$(9)
      LOCATE 4 + row, 44 + LEN(cut$(player(row + 1).clr)): PRINT " "
      LOCATE 3, 42: PRINT title(col)
      col = col + 1
    END SELECT
   CASE 3
    IF kbd$ = " " THEN
     LOCATE row + 4, 56
     IF player(row + 1).control = "H" THEN
      player(row + 1).control = "C"
      PRINT "Computer "
     ELSE
      player(row + 1).control = "H"
      PRINT "Human    "
     END IF
    ELSEIF kbd$ = CHR$(13) OR kbd$ = CHR$(9) THEN
     LOCATE 4 + row, 61 + -(player(row + 1).control = "C") * 3: PRINT " "
     LOCATE 3, col * 14 + 14: PRINT title(col)
     col = col + 1
    END IF
   CASE 4
    IF kbd$ = " " THEN
     LOCATE row + 4, 70
     IF player(row + 1).gender = "M" THEN
      player(row + 1).gender = "F"
      PRINT "Female "
     ELSE
      player(row + 1).gender = "M"
      PRINT "Male   "
     END IF
    ELSEIF kbd$ = CHR$(13) OR kbd$ = CHR$(9) THEN
     LOCATE 4 + row, 2: PRINT row + 1
     LOCATE 4 + row, 74 + -(player(row + 1).gender = "F") * 2: PRINT " "
     LOCATE 3, col * 14 + 14: PRINT title(col)
     col = 0
     row = row + 1
     IF row = numplayers THEN row = 0
     total$ = RTRIM$(player(row + 1).nam)
    END IF
  END SELECT
  IF col < 2 THEN
   LOCATE row + 4, col * 14 + 14 + LEN(total$): PRINT " "
  END IF
  SELECT CASE kbd$
   CASE CHR$(10)
    done = 1
    FOR x = 1 TO numplayers
     IF RTRIM$(player(x).nam) = "" OR RTRIM$(player(x).country) = "" THEN done = 0
    NEXT
    IF done = 0 THEN
     LOCATE 20: PRINT "Please fill in all the information"
     WHILE INKEY$ = "": WEND
     LOCATE 20: PRINT SPACE$(34)
    END IF
   CASE CHR$(0) + "H": movecursor total$, row, col, 0, -1
   CASE CHR$(0) + "M": movecursor total$, row, col, 1, 0
   CASE CHR$(0) + "P": movecursor total$, row, col, 0, 1
   CASE CHR$(0) + "K": movecursor total$, row, col, -1, 0
  END SELECT
 LOOP UNTIL done
 CLS
 PRINT
 PRINT "Home territories: User selected"
 LOCATE 10: PRINT "Press space to change"
 ranhome = "N"
 ranmap = "N"
 DO
  kbd$ = INKEY$
  IF kbd$ = " " THEN
   IF ranhome = "N" THEN
    ranhome = "Y"
    LOCATE 2, 19: PRINT "Random       "
   ELSE
    ranhome = "N"
    LOCATE 2, 19: PRINT "User selected"
   END IF
  END IF
 LOOP UNTIL kbd$ = CHR$(13)
 LOCATE 4: PRINT "Map: User selected"
 DO
  kbd$ = INKEY$
  IF kbd$ = " " THEN
   IF ranmap = "N" THEN
    ranmap = "Y"
    LOCATE 4, 6: PRINT "Random       "
   ELSE
    ranmap = "N"
    LOCATE 4, 6: PRINT "User selected"
   END IF
  END IF
 LOOP UNTIL kbd$ = CHR$(13)
END SUB

FUNCTION getint (row, col, a$, L, h)
 LOCATE row, col: PRINT a$ + "_"; SPACE$(LEN(STR$(hi)) - 1)
 DO
  DO: b$ = INKEY$: LOOP UNTIL b$ <> ""
  SELECT CASE b$
  CASE "0" TO "9"
   IF b$ <> "0" OR LEN(c$) THEN
    c$ = c$ + b$
    IF VAL(c$) > h THEN c$ = LTRIM$(STR$(h))
   END IF
  CASE CHR$(8): IF LEN(c$) > 0 THEN c$ = LEFT$(c$, LEN(c$) - 1)
  CASE CHR$(13)
   num = VAL(c$)
   IF num >= L AND num <= h THEN
    LOCATE row, col + LEN(a$) + LEN(c$): PRINT " "
    EXIT DO
   END IF
   c$ = ""
  END SELECT
  LOCATE row, col + LEN(a$): PRINT c$ + "_ "; SPACE$(LEN(STR$(hi)) - 1)
 LOOP
 getint = num
END FUNCTION

SUB mainmenu
 DO
  CLS
  COLOR 15
  center 2, "Castles IV"
  center 3, "Ver 1.0 "
  COLOR 9
  center 5, "Chad Austin"
  COLOR 12
  center 7, "    Castles is a strategy game.  Two through six players     "
  center 8, "compete to take over the world and destroy other players.    "
  center 9, "This is accomplished by building fortifications, recruiting  "
  center 10, "troops, and attacking enemy territories.  Weapons can enhance"
  center 11, "enhance the power of troops in battle.  When only one player "
  center 12, "is left, the game is over.                                   "
  COLOR 15
  center 17, "Select item:"
  LOCATE 19, 35: PRINT "Start new game"
  LOCATE 20, 35: PRINT "Restore game"
  LOCATE 21, 35: PRINT "Quit Castles IV"
  LOCATE choice + 19, 33: PRINT ""
  DO
   kbd$ = INKEY$
   SELECT CASE kbd$
    CASE CHR$(0) + "H"
     LOCATE choice + 19, 33: PRINT " "
     choice = choice - 1
     IF choice = -1 THEN choice = 2
     LOCATE choice + 19, 33: PRINT ""
    CASE CHR$(0) + "P"
     LOCATE choice + 19, 33: PRINT " "
     choice = choice + 1
     IF choice = 3 THEN choice = 0
     LOCATE choice + 19, 33: PRINT ""
    CASE CHR$(13)
     SELECT CASE choice
      CASE 0: startnew
      CASE 1: restoregame
     END SELECT
   END SELECT
  LOOP UNTIL kbd$ = CHR$(13)
 LOOP UNTIL choice = 2
END SUB

SUB movecursor (total$, row, col, x, y)
 done = 1
 FOR z = 1 TO numplayers
  IF (RTRIM$(player(z).nam) <> "") AND (player(z).nam = player(row + 1).nam) AND (z <> row + 1) THEN
   done = 0
  END IF
 NEXT
 IF (col = 0 AND done) OR col <> 0 THEN
  DIM title(4) AS STRING * 7
  title(0) = "Name"
  title(1) = "Country"
  title(2) = "Color"
  title(3) = "Control"
  title(4) = "Gender"
  LOCATE 4 + row, 2: PRINT row + 1
  LOCATE 3, col * 14 + 14: PRINT title(col)
  SELECT CASE col
   CASE 0: LOCATE row + 4, 14 + LEN(RTRIM$(player(row + 1).nam))
   CASE 1: LOCATE row + 4, 28 + LEN(RTRIM$(player(row + 1).country))
   CASE 2: LOCATE row + 4, 44 + LEN(cut$(player(row + 1).clr))
   CASE 3: LOCATE row + 4, 61 + -(player(row + 1).control = "C") * 3
   CASE 4: LOCATE row + 4, 74 + -(player(row + 1).gender = "F") * 2
  END SELECT
  PRINT " "
  row = row + y
  col = col + x
  IF row < 0 THEN row = numplayers - 1
  IF row = numplayers THEN row = 0
  IF col < 0 THEN col = 4
  IF col > 4 THEN col = 0
  IF col = 0 THEN
   total$ = RTRIM$(player(row + 1).nam)
  ELSEIF col = 1 THEN
   total$ = RTRIM$(player(row + 1).country)
  END IF
  COLOR 9
  LOCATE 4 + row, 2: PRINT row + 1
  LOCATE 3, col * 14 + 14: PRINT title(col)
  COLOR 15
 END IF
END SUB

SUB playcastles

END SUB

SUB restoregame

END SUB

SUB startnew
 getinputs

 numplayers = 2
 player(1).clr = 14
 player(1).clr = 13

 FOR x = 1 TO numplayers
  distpoints x, 22
 NEXT

END SUB

