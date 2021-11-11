DEFINT A-Z
DECLARE FUNCTION GetNum% (row%, col%, text$)
DECLARE FUNCTION Query$ (row%, text$)
DECLARE SUB Center (row%, text$)
DECLARE SUB DrawScreen ()
DECLARE SUB GetInputs ()
DECLARE SUB Intro ()
DECLARE SUB PlayPong ()
DECLARE SUB ShowEnd ()
TYPE PlayerType
 dir    AS INTEGER
 row    AS SINGLE
 score  AS INTEGER
 clr    AS INTEGER
END TYPE
 RANDOMIZE TIMER
 DIM SHARED player(1 TO 2) AS PlayerType
 DIM SHARED col!, row!, dir, Speed!, games, incr$, NumPlayers, fx
 ON ERROR GOTO BadScreen
 SCREEN 0, 0
 WIDTH 80, 50
 WIDTH 80, 25
 COLOR 15
 ON ERROR GOTO UnExpect
 KEY 15, CHR$(0) + CHR$(69)
 KEY(15) ON
 DEF SEG = 0
 KeyFlags = PEEK(1047)
 IF KeyFlags AND 32 THEN POKE 1047, KeyFlags XOR 32
 DEF SEG
 Intro
 GetInputs
 PlayPong
 DEF SEG = 0
 POKE 1047, KeyFlags
 DEF SEG
 ShowEnd
BadScreen:
 CLS
 PRINT "Pong II requires a VGA adapter."
 END
UnExpect:
 CLS
 PRINT "Unexpected error"
 PRINT "Ending program"
 END

SUB Center (row, text$)
 LOCATE row, 40 - LEN(text$) / 2
 PRINT text$
END SUB

SUB DrawScreen
 WIDTH 80, 50
 COLOR 14
 LOCATE 1, 1
 PRINT STRING$(80, 219)
 LOCATE 45, 1
 PRINT STRING$(80, 219)
 COLOR , 1
 VIEW PRINT 2 TO 44
 CLS 2
 VIEW PRINT
 COLOR , 0
 FOR x = 19 TO 26
  COLOR 10
  LOCATE x, 2
  PRINT CHR$(219)
  COLOR 13
  LOCATE x, 79
  PRINT CHR$(219)
 NEXT
END SUB

SUB GetInputs
 CLS
 COLOR 7
 Center 5, "How many players? (1-2)"
 WHILE NumPlayers < 1 OR NumPlayers > 2
  NumPlayers = VAL(INKEY$)
 WEND
 LOCATE 5, 51: PRINT NumPlayers
 Center 8, "1  = Slow  "
 Center 9, "50 = Medium"
 Center 10, "99 = Fast  "
 Speed! = (99 - GetNum(7, 34, "Speed: "))
 games = GetNum(12, 27, "Play to how many points? ")
 incr$ = Query$(14, "Increase speed during play? (Y/N)")
 IF Query$(16, "Play sound? (Y/N)") = "Y" THEN fx = 1
END SUB

FUNCTION GetNum (row, col, text$)
 LOCATE row, col: PRINT text$; "_"
 DO
  kbd$ = INKEY$
  SELECT CASE kbd$
  CASE "0" TO "9"
   IF LEN(a$) < 2 THEN a$ = a$ + kbd$
  CASE CHR$(8)
   IF a$ <> "" THEN a$ = LEFT$(a$, LEN(a$) - 1)
  CASE CHR$(13)
   num = VAL(a$)
   IF num > 0 THEN EXIT DO
   a$ = ""
  END SELECT
  LOCATE row, col + LEN(text$): PRINT a$; "_  "
 LOOP
 LOCATE row, col + LEN(text$) + LEN(a$): PRINT " "
 GetNum = num
END FUNCTION

SUB Intro
 CLS
 Center 7, "Ver 2.4"
 Center 9, "Written by:  Chad Austin"
 Center 11, "Controls"
 Center 12, "General        Player #1        Player #2"
 Center 14, "P - Pause         W      -Up-           "
 Center 15, "Q - Quit          S     -Stop-          "
 Center 16, "M - Sound         X     -Down-          "
 Center 17, "                  D     -Smash-         "
 Center 19, "To smash, hit the smash key exactly"
 Center 20, "when the ball hits your paddle."
 Center 22, "Hit any key to continue"
 WHILE INKEY$ <> "": WEND
 COLOR 9
 Center 2, "€ﬂﬂ‹   ‹ﬂﬂ‹   €  €   €ﬂﬂ€"
 Center 3, "€‹‹ﬂ   €  €   €ﬂ‹€   €  ﬂ"
 Center 4, "€      €  €   €  €   € ﬂ€"
 Center 5, "€      ﬂ‹‹ﬂ   €  €   €‹‹€"
 WHILE INKEY$ <> "": WEND
 s! = TIMER
 DO
   y = y + 1
 LOOP UNTIL TIMER - s! >= .5
 DO
  x = (x + 1) MOD 4
  SELECT CASE x
  CASE 0: COLOR 9
  CASE 1, 3: COLOR 10
  CASE 2: COLOR 14
  END SELECT
  Center 2, "€ﬂﬂ‹   ‹ﬂﬂ‹   €  €   €ﬂﬂ€"
  Center 3, "€‹‹ﬂ   €  €   €ﬂ‹€   €  ﬂ"
  Center 4, "€      €  €   €  €   € ﬂ€"
  Center 5, "€      ﬂ‹‹ﬂ   €  €   €‹‹€"
  FOR x# = 1 TO y * 2
   IF INKEY$ <> "" THEN EXIT DO
  NEXT
 LOOP
END SUB

SUB PlayPong
 PLAY "mbl64"
 IF NumPlayers = 1 THEN a$ = "Computer " ELSE a$ = "Player #2"
 s! = TIMER
 DO
  x = x + 1
 LOOP UNTIL TIMER - s! >= .5
 Speed! = Speed! * x / 250
 DO
  CurSpeed! = Speed!
  player(1).row = 19
  player(2).row = 19
  player(1).dir = 0
  player(2).dir = 0
  row! = 22 + RND
  col! = 40 + RND
  dir = 29 * RND + 1
  DrawScreen
  COLOR 15
  Center 48, "Player #1 --->" + STR$(player(1).score) + SPACE$(9 - LEN(STR$(player(1).score)) - LEN(STR$(player(2).score))) + STR$(player(2).score) + " <--- " + a$
  WHILE INKEY$ <> "": WEND
  Center 47, "Hit spacebar to continue"
  WHILE INKEY$ <> " ": WEND
  Center 47, SPACE$(24)
  DO
   COLOR 15
   FOR x# = 1 TO CurSpeed!: NEXT
   kbd$ = UCASE$(INKEY$)
   SELECT CASE kbd$
   CASE "W": player(1).dir = 1
   CASE "X": player(1).dir = 2
   CASE "S": player(1).dir = 0
   CASE CHR$(0) + "H": player(2).dir = 1
   CASE CHR$(0) + "P": player(2).dir = 2
   CASE CHR$(0) + "M": player(2).dir = 0
   CASE "P"
    Center 47, "Game paused, Hit spacebar to continue"
    WHILE INKEY$ <> " ": WEND
    Center 47, SPACE$(37)
   CASE "Q"
    Center 47, "Are you sure? (Y/N)"
    DO: kbd$ = UCASE$(INKEY$): LOOP UNTIL kbd$ = "Y" OR kbd$ = "N"
    Center 47, SPACE$(19)
    IF kbd$ = "Y" THEN EXIT DO
   CASE "M"
    IF fx THEN fx = 0 ELSE fx = 1
   END SELECT
   IF NumPlayers = 1 OR CINT(row!) = 2 OR CINT(row!) = 44 OR incr$ = "Y" THEN
    IF NumPlayers = 1 THEN
     IF dir < 9 OR dir > 7 AND dir < 16 OR dir = 31 THEN
      SELECT CASE player(2).row
      CASE IS > row! - 4: player(2).dir = 1
      CASE IS < row! + 4: player(2).dir = 2
      END SELECT
     ELSE player(2).dir = 0
     END IF
    END IF
    IF CINT(row!) = 2 OR CINT(row!) = 44 THEN
     IF dir < 16 THEN dir = 16 - dir ELSE dir = 46 - dir
     IF fx THEN PLAY "L64N76N65N19"
    END IF
   END IF
   FOR x = 1 TO 2
    SELECT CASE player(x).dir
    CASE 1
     IF player(x).row > 2 THEN
      player(x).row = player(x).row - .5
      IF NumPlayers = 2 AND x = 2 OR x = 1 THEN player(x).row = player(x).row - .5
      IF player(x).row MOD 1 = 0 THEN
       LOCATE INT(player(x).row), (x - 1) * 77 + 2
       COLOR (x - 1) * 3 + 10
       PRINT CHR$(219)
       LOCATE INT(player(x).row) + 8, (x - 1) * 77 + 2
       COLOR 1
       PRINT CHR$(219)
      END IF
     ELSE player(x).dir = 0
     END IF
    CASE 2
     IF player(x).row < 37 THEN
      player(x).row = player(x).row + .5
      IF NumPlayers = 2 AND x = 2 OR x = 1 THEN player(x).row = player(x).row + .5
      IF player(x).row MOD 1 = 0 THEN
       LOCATE INT(player(x).row) + 7, (x - 1) * 77 + 2
       COLOR (x - 1) * 3 + 10
       PRINT CHR$(219)
       IF player(x).row > 2.5 THEN
        LOCATE INT(player(x).row) - 1, ((x - 1) * 77) + 2
        COLOR 1
        PRINT CHR$(219)
       END IF
      END IF
     ELSE player(x).dir = 0
     END IF
    END SELECT
   NEXT
   COLOR 1
   LOCATE CINT(row!), CINT(col!): PRINT CHR$(219)
   SELECT CASE dir
   CASE 1: col! = col! + .25: row! = row! - 1
   CASE 2: col! = col! + .5: row! = row! - 1
   CASE 3: col! = col! + .75: row! = row! - 1
   CASE 4: col! = col! + 1: row! = row! - 1
   CASE 5: col! = col! + 1: row! = row! - .75
   CASE 6: col! = col! + 1: row! = row! - .5
   CASE 7: col! = col! + 1: row! = row! - .25
   CASE 8: col! = col! + 1
   CASE 9: col! = col! + 1: row! = row! + .25
   CASE 10: col! = col! + 1: row! = row! + .5
   CASE 11: col! = col! + 1: row! = row! + .75
   CASE 12: col! = col! + 1: row! = row! + 1
   CASE 13: col! = col! + .75: row! = row! + 1
   CASE 14: col! = col! + .5: row! = row! + 1
   CASE 15: col! = col! + .25: row! = row! + 1
   CASE 16: col! = col! - .25: row! = row! + 1
   CASE 17: col! = col! - .5: row! = row! + 1
   CASE 18: col! = col! - .75: row! = row! + 1
   CASE 19: col! = col! - 1: row! = row! + 1
   CASE 20: col! = col! - 1: row! = row! + .75
   CASE 21: col! = col! - 1: row! = row! + .5
   CASE 22: col! = col! - 1: row! = row! + .25
   CASE 23: col! = col! - 1
   CASE 24: col! = col! - 1: row! = row! - .25
   CASE 25: col! = col! - 1: row! = row! - .5
   CASE 26: col! = col! - 1: row! = row! - .75
   CASE 27: col! = col! - 1: row! = row! - 1
   CASE 28: col! = col! - .75: row! = row! - 1
   CASE 29: col! = col! - .5: row! = row! - 1
   CASE 30: col! = col! - .25: row! = row! - 1
   CASE 31: col! = col! + 4.35
   CASE 32: col! = col! - 4.35
   END SELECT
   COLOR 15
   SELECT CASE CINT(col!)
   CASE 3
    IF CINT(row!) > player(1).row - 2 AND CINT(row!) <= player(1).row + 9 THEN
     IF fx THEN PLAY "n10n25n57"
     IF player(1).dir = 1 THEN dir = RND * 7 + 1
     IF player(1).dir = 2 THEN dir = RND * 7 + 8
     IF player(1).dir = 0 THEN dir = RND * 14 + 1
     IF kbd$ = "D" THEN dir = 31
     IF CINT(row!) = 2 THEN row! = 3
     IF CINT(row!) = 44 THEN row! = 43
     COLOR 1
     LOCATE CINT(row!), CINT(col!): PRINT CHR$(219)
     col! = 4
    END IF
   CASE 78
    IF CINT(row!) > player(2).row - 2 AND CINT(row!) <= player(2).row + 9 THEN
     IF fx THEN PLAY "n10n25n57"
     IF player(2).dir = 1 THEN dir = RND * 7 + 23
     IF player(2).dir = 2 THEN dir = RND * 7 + 16
     IF player(2).dir = 0 THEN dir = RND * 14 + 16
     IF NumPlayers = 1 THEN
      IF CINT(RND * 4) = 0 THEN dir = 32
     ELSE IF kbd$ = CHR$(0) + "K" THEN dir = 32
     END IF
     IF CINT(row!) = 2 THEN row! = 3
     IF CINT(row!) = 44 THEN row = 43
     COLOR 1
     LOCATE CINT(row!), CINT(col!): PRINT CHR$(219)
     col! = 77
    END IF
   CASE IS <= 1, IS >= 80
    IF fx THEN PLAY "n70n65n62n54n51n47n46n36n35n34n33n32n30n28n27n24n21n18n16n14n12n10n8n6n5n4n3n2n1"
    IF CINT(col!) <= 1 THEN
     player(2).score = player(2).score + 1
    ELSE
     player(1).score = player(1).score + 1
    END IF
    kbd$ = ""
    EXIT DO
   END SELECT
   LOCATE CINT(row!), CINT(col!): PRINT CHR$(219)
  LOOP
  IF incr$ = "Y" THEN Speed! = Speed! * .95
 LOOP UNTIL player(1).score = games OR player(2).score = games OR kbd$ = "Y"
END SUB

FUNCTION Query$ (row, text$)
 Center row, text$
 WHILE a$ <> "Y" AND a$ <> "N"
  a$ = UCASE$(INKEY$)
 WEND
 LOCATE row, 42 + INT(LEN(text$) / 2): PRINT a$
 Query$ = a$
END FUNCTION

SUB ShowEnd
 CLS
 WIDTH 80, 25
 COLOR 15
 IF player(1).score > player(2).score THEN a$ = "Player #1 won!"
 IF player(1).score < player(2).score THEN IF NumPlayers = 1 THEN a$ = "The Computer won!" ELSE a$ = "Player #2 won!"
 IF player(1).score = player(2).score THEN a$ = "Both players tied!"
 Center 12, a$
 x! = TIMER
 DO: LOOP UNTIL TIMER - x! > 1
 WHILE INKEY$ <> "": WEND
 WHILE INKEY$ = "": WEND
 COLOR 7
 END
END SUB

