DEFINT A-Z
DECLARE FUNCTION getstring$ (x%, y%, a$, z%)
DECLARE FUNCTION query$ (x%, y%, a$)
DECLARE SUB center (x%, a$)
DECLARE SUB makemap ()
DECLARE SUB message (x%, y%, a$)
DECLARE SUB movecursor (x%, y%)
DECLARE SUB programmain ()
TYPE terrtype
 col   AS INTEGER
 row   AS INTEGER
 water AS INTEGER
END TYPE
 DIM SHARED terr(1 TO 99) AS terrtype, pnt&(11900), adj(1 TO 99, 1 TO 99)
 DIM SHARED ready(1 TO 99), pointr&(18), mode(1 TO 2), curfile
 DIM SHARED pass AS STRING * 10, col, row, spd, fast
 ON ERROR GOTO screenerror
 SCREEN 9, , 1, 1
 SCREEN 9, , 0, 0
 OPEN "castpass.dat" FOR RANDOM AS #1
 IF EOF(1) = 0 THEN
  FOR x = 1 TO 10
   GET #1, , y
   IF EOF(1) THEN pass = "": EXIT FOR
   a$ = a$ + CHR$(y)
  NEXT
  pass = a$
 ELSE pass = ""
 END IF
 CLOSE
 FOR x = 0 TO 18
  READ pointr&(x)
 NEXT
 PRINT "Checking files"
 PRINT "Please wait. . ."
 PRINT " 0% Completed"
 ON ERROR GOTO finish
 FOR x = 1 TO 99
  ready(x) = 1
  OPEN "castmap." + LTRIM$(STR$(x)) FOR INPUT AS #1
  CLOSE
  IF x MOD 8 = 0 THEN LOCATE 3: PRINT USING "##% Completed"; x
 NEXT
 FOR x = 1 TO 99
  IF ready(x) = 0 THEN
   curfile = x
   EXIT FOR
  END IF
 NEXT
 ON ERROR GOTO 0
 programmain
screenerror:
 PRINT "An EGA 64K+ or VGA monitor is needed to use the Map Making Utility."
 END
finish: ready(x) = 0
RESUME NEXT
DATA 589833, 524296, 524296, 524296, 524296, 524296, 524296, 0, 0, -2132573981
DATA -2132573981, 0, 0, 524296, 524296, 524296, 524296, 524296, 524296

SUB center (x, a$)
 LOCATE x, INT(40 - LEN(a$) / 2)
 PRINT a$
END SUB

FUNCTION getstring$ (x, y, a$, z)
 LOCATE x, y: PRINT a$; "_ "
 DO
  DO
   kbd$ = INKEY$
  LOOP UNTIL kbd$ <> ""
  SELECT CASE kbd$
  CASE " " TO "}": IF LEN(b$) < z * 8 + 2 THEN b$ = b$ + kbd$
  CASE CHR$(8), CHR$(0) + "K": IF LEN(b$) > 0 THEN b$ = LEFT$(b$, LEN(b$) - 1)
  CASE CHR$(13)
   LOCATE x, y + LEN(b$) + LEN(a$): PRINT " "
   EXIT DO
  END SELECT
  LOCATE x, y + LEN(a$)
  IF z THEN PRINT STRING$(LEN(b$), "*") + "_ " ELSE PRINT b$; "_ "
 LOOP
 getstring$ = b$
END FUNCTION

SUB makemap
 cfile = curfile
 SCREEN , , 1, 0
 CLS
 SCREEN , , 1, 1
 CLS
 IF mode(2) = 1 THEN
  center 1, "Existing Maps"
  FOR x = 1 TO 99
   IF ready(x) THEN PRINT STR$(x);
  NEXT
  x = CSRLIN + 2
  LOCATE x, 1
  DO
   file = VAL(getstring$(x, 1, "Edit which map? (Enter to abort) ", 0))
   IF file > 0 AND file < 100 THEN IF ready(file) THEN done = 1
   IF file = 0 THEN file = 100
  LOOP UNTIL file = 100 OR done
  done = 0
 END IF
 IF file <> 100 THEN
  IF file THEN
   PRINT "Loading file, please wait. . ."
   OPEN "castmap." + LTRIM$(STR$(file)) FOR BINARY AS #1
   IF EOF(1) = 0 THEN
    DIM s AS STRING * 5
    GET #1, , s
    IF EOF(1) = 0 THEN
     FOR x = 0 TO 11900
      GET #1, , pnt&(x)
      IF EOF(1) THEN a = 1: EXIT FOR
     NEXT
    ELSE a = 1
    END IF
   ELSE a = 1
   END IF
   IF a = 1 THEN
    PRINT "CASTMAP."; LTRIM$(STR$(file)); " corrupted"
    WHILE INKEY$ = "": WEND
    CLOSE
    EXIT SUB
   END IF
   CLS
   PUT (0, 0), pnt&, PSET
   GET #1, , maxterr
   FOR x = 1 TO maxterr
    GET #1, , terr(x).col
    GET #1, , terr(x).row
   NEXT
   CLOSE
   cfile = file
  ELSE LINE (0, 0)-(399, 237), 15, BF
  END IF
  VIEW PRINT 18 TO 25
  CLS 2
  VIEW PRINT
  COLOR 9
  LOCATE 2, 53: PRINT "CASTLES III"
  LOCATE , 53: PRINT "MAP MAKER"
  COLOR 15
  center 18, " Controls "
  center 19, "Arrow keys - move cursor      Q, ESC - quit         "
  center 20, "Back Space - clear dot        F - toggle fast cursor"
  center 21, "Spacebar - dot                E - erase             "
  center 22, "Enter - done                  L - line              "
  col = 200
  row = 119
  PUT (col - 4, row - 4), pointr&
  fast = 1
  DO
   DO
    COLOR 15
    LOCATE 6, 53: PRINT "Stage #"; LTRIM$(STR$(create + 1))
    IF create = 1 THEN
     LOCATE 8, 52: PRINT maxterr;
     IF maxterr = 1 THEN PRINT "territory  " ELSE PRINT "territories"
    ELSE
     IF ln = 2 THEN COLOR 15 ELSE COLOR 8
     LOCATE 14, 53: PRINT "ERASER"
     IF ln = 1 THEN COLOR 15 ELSE COLOR 8
     LOCATE 15, 53: PRINT "LINE"
    END IF
    IF fast THEN COLOR 15 ELSE COLOR 8
    LOCATE 16, 53: PRINT "FAST"
    x! = TIMER
    DO
     kbd$ = UCASE$(INKEY$)
    LOOP UNTIL kbd$ <> "" OR TIMER - x! > .15
    SELECT CASE kbd$
    CASE CHR$(0) + "P": movecursor 0, spd
    CASE CHR$(0) + "H": movecursor 0, -spd
    CASE CHR$(0) + "M": movecursor spd, 0
    CASE CHR$(0) + "K": movecursor -spd, 0
    CASE CHR$(0) + "G": movecursor 4 - col, 0
    CASE CHR$(0) + "O": movecursor 395 - col, 0
    CASE CHR$(0) + "I": movecursor 0, 4 - row
    CASE CHR$(0) + "Q": movecursor 0, 233 - row
    CASE CHR$(8): PSET (col, row), 15
    CASE CHR$(13)
     SELECT CASE ln
     CASE 1, 2
      PUT (col - 4, row - 4), pointr&
      IF ln = 1 THEN LINE (lnc, lnr)-(col, row), 0 ELSE LINE (lnc, lnr)-(col, row), 15, BF
      ln = 0
      PUT (col - 4, row - 4), pointr&
     CASE ELSE
      COLOR 15
      PUT (col - 4, row - 4), pointr&
      IF query$(10, 53, "Done?") = "Y" THEN
       IF create = 0 THEN
        create = 1
        center 19, SPACE$(15) + "Arrow keys - move cursor" + SPACE$(15)
        center 20, SPACE$(15) + "C - create territory    " + SPACE$(15)
        center 21, SPACE$(15) + "D - delete territory    " + SPACE$(15)
        center 22, SPACE$(15) + "T - toggle fast cursor  " + SPACE$(15)
        FOR x = 1 TO maxterr
         PAINT (terr(x).col, terr(x).row), ((x - 2) MOD 13) + 2, 0
        NEXT
        PUT (col - 4, row - 4), pointr&
        LOCATE 14, 53: PRINT "      "
        LOCATE 15, 53: PRINT "    "
       ELSE
        LOCATE 16, 53: PRINT "    "
        a$ = "N"
        FOR x = 1 TO maxterr
         PAINT (terr(x).col, terr(x).row), 15, 0
        NEXT
        GET (0, 0)-(399, 237), pnt&
        IF maxterr > 6 THEN
         LOCATE 10, 53: PRINT "Is this map ready"
         a$ = query$(11, 55, "to be used? (Y/N)")
         LOCATE 10, 53: PRINT "                 "
        END IF
        OPEN "castmap." + LTRIM$(STR$(cfile)) FOR BINARY AS #1
        IF a$ = "Y" THEN b$ = "VALID": PUT #1, , b$ ELSE b$ = "     ": PUT #1, , b$
        LOCATE 8, 53: PRINT "Saving Map       "
        FOR x = 0 TO 11900
         PUT #1, , pnt&(x)
         IF x MOD 952 = 0 THEN
          LOCATE 9, 53: PRINT USING "##% Completed"; x / 119
         END IF
        NEXT
        LOCATE 8, 60: PRINT "completed"
        LOCATE 9, 53: PRINT SPACE$(13)
        PUT #1, , maxterr
        FOR x = 1 TO maxterr
         PUT #1, , terr(x).col
         PUT #1, , terr(x).row
        NEXT
        done = 1
        LOCATE 11, 53: PRINT "Map saved under"
        LOCATE 12, 53: PRINT "file CASTMAP."; LTRIM$(STR$(cfile))
        WHILE INKEY$ = "": WEND
        LOCATE 6, 53: PRINT "Stage #3"
        LOCATE 11, 53: PRINT SPACE$(15)
        LOCATE 12, 53: PRINT SPACE$(15)
        ready(cfile) = 1
        FOR x = 1 TO 99
         IF ready(x) = 0 THEN
          curfile = x
          EXIT FOR
         END IF
        NEXT
        EXIT DO
       END IF
      ELSE PUT (col - 4, row - 4), pointr&
      END IF
     END SELECT
    CASE CHR$(27), "Q"
     IF create = 0 THEN
      IF ln = 0 THEN
       IF query$(10, 53, "Exit?") = "Y" THEN EXIT SUB
      ELSE ln = 0: PSET (lnc, lnr), clr
      END IF
     ELSE
      create = 0
      PUT (col - 4, row - 4), pointr&
      FOR x = 1 TO maxterr
       PAINT (terr(x).col, terr(x).row), 15, 0
      NEXT
      center 18, " Controls "
      center 19, "Arrow keys - move cursor      Q, ESC - quit         "
      center 20, "Back Space - clear dot        F - toggle fast cursor"
      center 21, "Spacebar - dot                E - erase             "
      center 22, "Enter - done                  L - line              "
      LOCATE 8, 53: PRINT SPACE$(15)
      PUT (col - 4, row - 4), pointr&
     END IF
    CASE " ": IF create = 0 THEN IF ln = 0 THEN PSET (col, row), 0
    CASE "L"
     IF ln = 0 AND create = 0 THEN
      ln = 1
      lnc = col
      lnr = row
      clr = POINT(col, row)
      IF clr = 12 THEN PSET (col, row), 10 ELSE PSET (col, row), 12
     END IF
    CASE "C"
     IF create THEN
      IF maxterr < 99 THEN
       PUT (col - 4, row - 4), pointr&
       IF POINT(col, row) = 15 THEN
        PAINT (col, row), ((maxterr - 1) MOD 13) + 2, 0
        IF POINT(0, 0) = 15 THEN
         maxterr = maxterr + 1
         terr(maxterr).col = col
         terr(maxterr).row = row
        ELSE
         PAINT (col, row), 15, 0
         LOCATE 10, 53: PRINT "Cannot put territory"
         message 11, 53, "in water"
         LOCATE 10, 53: PRINT SPACE$(20)
        END IF
        PUT (col - 4, row - 4), pointr&
        EXIT DO
       ELSE
        PUT (col - 4, row - 4), pointr&
        message 10, 53, "Already used"
       END IF
      ELSE message 10, 53, "Too many territories"
      END IF
     END IF
    CASE "D"
     IF create THEN
      IF maxterr > 0 AND ln = 0 THEN
       PUT (col - 4, row - 4), pointr&
       PAINT (terr(maxterr).col, terr(maxterr).row), 15, 0
       maxterr = maxterr - 1
       PUT (col - 4, row - 4), pointr&
       EXIT DO
      END IF
     END IF
    CASE "F": fast = fast XOR 1
    CASE "E":
     IF ln = 0 AND create = 0 THEN
      ln = 2
      lnc = col
      lnr = row
      clr = POINT(col, row)
      IF clr = 12 THEN PSET (col, row), 10 ELSE PSET (col, row), 12
     END IF
    CASE ELSE: spd = 1
    END SELECT
   LOOP
  LOOP UNTIL done
  IF a$ = "Y" THEN
   LOCATE 8, 53: PRINT SPACE$(17)
   center 19, SPACE$(21) + "Y - yes   " + SPACE$(21)
   center 20, SPACE$(21) + "N - no    " + SPACE$(21)
   center 21, SPACE$(21) + "ESC - back" + SPACE$(21)
   center 22, SPACE$(52)
   LOCATE 8, 53: PRINT "Are these territories"
   LOCATE 9, 53: PRINT "adjacent? (Y/N)"
   x = 1
   z = 2
   done = 0
   DO
    PAINT (terr(x).col, terr(x).row), 1, 0
    DO
     PAINT (terr(z).col, terr(z).row), 2, 0
     DO
      kbd$ = UCASE$(INKEY$)
     LOOP UNTIL kbd$ = "Y" OR kbd$ = "N" OR kbd$ = CHR$(27)
     PAINT (terr(z).col, terr(z).row), 15, 0
     SELECT CASE kbd$
     CASE CHR$(27)
      IF z > 2 THEN
       PAINT (terr(x).col, terr(x).row), 15, 0
       z = z - 1
       IF z <= x THEN
        x = x - 1
        z = maxterr
       END IF
       PAINT (terr(x).col, terr(x).row), 1, 0
      END IF
     CASE "Y": adj(x, z) = 1
     CASE "N": adj(x, z) = 0
     END SELECT
     IF kbd$ = "Y" OR kbd$ = "N" THEN
      z = z + 1
      IF z = maxterr + 1 THEN
       x = x + 1
       z = x + 1
       IF x = maxterr THEN done = 1
       EXIT DO
      END IF
     END IF
    LOOP
    PAINT (terr(x - 1).col, terr(x - 1).row), 15, 0
   LOOP UNTIL done
   FOR x = 1 TO maxterr
    FOR z = 1 TO maxterr
     PUT #1, , adj(x, z)
    NEXT
   NEXT
   PAINT (0, 0), 1, 0
   LOCATE 8, 53: PRINT "Is this territory    "
   LOCATE 9, 53: PRINT "by water? (Y/N)      "
   FOR x = 1 TO maxterr
    PAINT (terr(x).col, terr(x).row), 2, 0
    DO
     kbd$ = UCASE$(INKEY$)
    LOOP UNTIL kbd$ = "Y" OR kbd$ = "N" OR kbd$ = CHR$(27)
    PAINT (terr(x).col, terr(x).row), 15, 0
    SELECT CASE kbd$
    CASE "Y": terr(x).water = 1
    CASE "N": terr(x).water = 0
    CASE CHR$(27): IF x > 1 THEN x = x - 2 ELSE x = x - 1
    END SELECT
   NEXT
   FOR x = 1 TO maxterr
    PUT #1, , terr(x).water
   NEXT
   FOR x = 1 TO 99
    IF ready(x) = 0 THEN
     curfile = x
     EXIT FOR
    END IF
   NEXT
  END IF
 END IF
 CLOSE
END SUB

SUB message (x, y, a$)
 LOCATE x, y: PRINT a$
 WHILE INKEY$ = "": WEND
 LOCATE x, y: PRINT SPACE$(LEN(a$))
END SUB

SUB movecursor (x, y)
 PUT (col - 4, row - 4), pointr&
 col = col + x
 row = row + y
 IF col < 4 THEN col = 395
 IF col > 395 THEN col = 4
 IF row < 4 THEN row = 233
 IF row > 233 THEN row = 4
 PUT (col - 4, row - 4), pointr&
 IF fast THEN
  spd = spd + 2
  IF spd > 40 THEN spd = 30
 END IF
END SUB

SUB programmain
 a$ = RTRIM$(pass)
 DIM conf AS STRING * 10
 CLS
 FOR x = 1 TO 99
  done = done + ready(x)
 NEXT
 WHILE INKEY$ <> "": WEND
 CLS
 COLOR 15
 center 3, "CASTLES III"
 center 4, "MAP MAKER"
 center 5, "Ver 3.6"
 COLOR 9
 center 6, "By: Chad Austin"
 COLOR 10
 center 8, "    This program is used for making and editing maps used in   "
 center 9, "Castles III.  You can make from six to ninety-nine territories."
 center 10, "First, you draw the boundaries.  Then, the territories are     "
 center 11, "are created.  Lastly, the status of the territories are saved. "
 COLOR 15
 DO
  leave = 0
  center 14, "Access Level #1"
  IF curfile THEN COLOR 15 ELSE COLOR 8
  center 15, "1 - Make a map     "
  COLOR 15
  center 16, "2 - Instructions   "
  center 17, "3 - Exit utility   "
  center 18, "4 - Up level       "
  DO
   mode(1) = VAL(INKEY$)
   IF mode(1) = 1 AND curfile = 0 THEN mode(1) = 0
  LOOP UNTIL mode(1) > 0 AND mode(1) < 5
  SELECT CASE mode(1)
  CASE 1
   makemap
   SCREEN , , 0, 0
  CASE 2
   SCREEN , , 1, 0
   CLS
   SCREEN , , 1, 1
   CLS
   VIEW PRINT 1 TO 25
   center 1, "Castles III Map Making Utility"
   center 3, "    To create a map, press 1 while in access level #1.  A new screen"
   center 4, "will come up.  Move the cursor with the arrow keys.  When you want  "
   center 5, "to make a dot, press spacebar.  To clear a dot, press backspace.  In"
   center 6, "this first stage of making a map, your goal is to define the        "
   center 7, "boundaries of the territories to be created in the next stage.  When"
   center 8, "you are done, press enter and Y.  The next stage of map making will "
   center 9, "begin.  Move the cursor inside of boundaries and press C.  The      "
   center 10, "territory will become colored.  If a mistake is in the boundaries of"
   center 11, "of the map, press ESC to go back to stage #1.  When done creating   "
   center 12, "territories, press enter.  The map will be stored in a file.        "
   center 13, "Stage #3 is where the data for each individual territory is found.  "
   center 14, "Answer (Y)es or (N)o to each question pertaining to the highlighted "
   center 15, "territory or territories.  The map is now finished.                 "
   center 16, "    To edit a map, press 1 while in access level #2.  The map will  "
   center 17, "loaded.  Make your changes in stages #1 and #2 and press enter.     "
   center 18, "Then, answer the questions in stage #3                              "
   center 19, "    To delete a map, press 2 while in access level #3.  Enter the   "
   center 20, "number of the map you want to delete.                               "
   center 21, "    To change or create a password, press 3 while in access         "
   center 22, "level #2.  If an old password exists, enter it.  Then enter a new   "
   center 23, "one.  To confirm spelling, enter it again.  Passwords can be ten    "
   center 24, "characters long.                                                    "
   VIEW PRINT
   WHILE INKEY$ = "": WEND
   SCREEN , , 0, 0
  CASE 3
   SCREEN 0
   WIDTH 80, 25
   CLS
   END
  CASE 4
   leave = 0
   IF pass <> "          " THEN
    a$ = getstring$(20, 30, "Enter password: ", 1)
    LOCATE 20, 30: PRINT SPACE$(32)
    IF a$ <> RTRIM$(pass) THEN message 20, 32, "Access denied": leave = 1
   END IF
   DO
    IF a$ = RTRIM$(pass) OR pass = "          " OR a THEN
     a = 0
     center 14, "Access Level #2"
     IF done THEN COLOR 15 ELSE COLOR 8
     center 15, "1 - Edit a map     "
     center 16, "2 - Delete a map   "
     COLOR 15
     center 17, "3 - Change password"
     center 18, "4 - Down level     "
     DO
      mode(2) = VAL(INKEY$)
      IF done = 0 AND (mode(2) = 1 OR mode(2) = 2) THEN mode(2) = 0
     LOOP UNTIL mode(2) > 0 AND mode(2) < 5
     SELECT CASE mode(2)
     CASE 1
      makemap
      SCREEN , , 0, 0
     CASE 2
      SCREEN , , 1, 0
      CLS
      SCREEN , , 1, 1
      DO
       CLS
       center 1, "Existing Maps"
       FOR x = 1 TO 99
        IF ready(x) THEN PRINT STR$(x);
       NEXT
       x = CSRLIN + 2
       maxterr = VAL(getstring$(x, 1, "Delete which map? (Enter to abort) ", 0))
       IF maxterr > 0 AND maxterr < 100 THEN
        IF ready(maxterr) THEN
         KILL "castmap." + LTRIM$(STR$(maxterr))
         ready(maxterr) = 0
        END IF
       END IF
       kbd$ = "N"
       IF maxterr THEN
        PRINT "Delete another? (Y/N)"
        DO
         kbd$ = UCASE$(INKEY$)
        LOOP UNTIL kbd$ = "Y" OR kbd$ = "N"
       END IF
      LOOP UNTIL kbd$ = "N"
      SCREEN , , 0, 0
      FOR x = 1 TO 99
       IF ready(x) = 0 THEN
        curfile = x
        EXIT FOR
       END IF
      NEXT
     CASE 3
      IF pass <> "          " THEN a$ = getstring$(20, 30, "Enter old password: ", 1) ELSE a$ = RTRIM$(pass)
      center 20, SPACE$(78)
      IF a$ = RTRIM$(pass) THEN
       pass = getstring(20, 30, "Enter new password: ", 1)
       center 20, SPACE$(78)
       conf = getstring(20, 30, "Confirm new password: ", 1)
       center 20, SPACE$(78)
       IF pass = conf THEN
        center 21, SPACE$(78)
        OPEN "castpass.dat" FOR RANDOM AS #1
        FOR x = 1 TO 10
         y = ASC(MID$(pass, x, 1))
         PUT #1, , y
        NEXT
        CLOSE
        a$ = RTRIM$(pass$)
       ELSE
        pass = a$
        center 21, "Password entered inconsistently"
        message 22, 29, "Password not changed"
        center 21, SPACE$(31)
        a = 1
       END IF
      ELSE message 20, 32, "Access denied": a = 1
      END IF
     END SELECT
    END IF
   LOOP UNTIL mode(2) = 4 OR leave
  END SELECT
 LOOP
END SUB

FUNCTION query$ (x, y, a$)
 COLOR 15
 LOCATE x, y: PRINT a$
 DO
  b$ = UCASE$(INKEY$)
 LOOP UNTIL b$ = "Y" OR b$ = "N"
 LOCATE x, y: PRINT SPACE$(LEN(a$))
 query$ = b$
END FUNCTION

