DEFINT A-Z
DECLARE FUNCTION cut$ (x%)
DECLARE FUNCTION empty% (x%, y%)
DECLARE FUNCTION query$ (x%, y%, a$)
DECLARE SUB center (x%, a$)
DECLARE SUB default ()
DECLARE SUB dig (x%, y%)
DECLARE SUB domove ()
DECLARE SUB drawcursor (x%, y%)
DECLARE SUB drawscreen ()
DECLARE SUB endgame ()
DECLARE SUB fall ()
DECLARE SUB findmoney ()
DECLARE SUB initstats ()
DECLARE SUB intro ()
DECLARE SUB moveman (x%, y%)
DECLARE SUB playgame ()
DECLARE SUB prompt (a$)
DECLARE SUB sandstorm ()
DECLARE SUB set (x%, y%, z%, a%)
DECLARE SUB wrong (a$)
CONST oxyfilter = 3, co2filter = 4, methfilter = 5, plant = 6, light = 7
CONST hydrolysis = 8, fire = 9, flowingwater = 10, stillwater = 11
CONST hfilter = 12, airlock = 13, dirt = 14, firewood = 15, seeds = 7
CONST matches = 11, ladder = 16, rock = 17, sand = 18
'$DYNAMIC
TYPE stats
 col AS INTEGER
 row AS INTEGER
 sta AS INTEGER
 sex AS INTEGER
 money AS INTEGER
 spd AS INTEGER
 agi AS INTEGER
 str AS INTEGER
 cling AS INTEGER
END TYPE
TYPE gridstats
 typ AS INTEGER
END TYPE
 RANDOMIZE TIMER
 DIM SHARED person(1 TO 2) AS stats, grid(1 TO 25, 1 TO 21) AS gridstats
 DIM SHARED fig(32, 18) AS LONG, item(1 TO 2, 1 TO 11), people, man
 DIM SHARED box&(5000), keyflag
 ON ERROR GOTO screenerror
 SCREEN 9
 PALETTE 5, 39
 SCREEN 0
 ON ERROR GOTO fileerror
 OPEN "life_pic.dat" FOR INPUT AS #1
 CLOSE
 OPEN "life_pic.dat" FOR BINARY AS #1
 DIM a AS STRING * 5
 GET #1, , a
 IF a <> "VALID" THEN ERROR 0
 FOR x = 0 TO 18
  FOR y = 0 TO 32
   GET #1, , fig(y, x)
   IF EOF(1) THEN ERROR 0
  NEXT
 NEXT
 CLOSE
 ON ERROR GOTO unexpect
 KEY 15, CHR$(0) + CHR$(69)
 KEY(15) ON
 DEF SEG = 0
 keyflag = PEEK(1047)
 IF keyflag AND 32 THEN POKE 1047, keyflag XOR 32
 DEF SEG
 intro
 initstats
 drawscreen
 playgame
screenerror:
 default
 PRINT "An EGA 64K+ or VGA monitor is required to play Life."
 END
fileerror:
 default
 PRINT "LIFE_PIC.DAT missing or corrupted"
 END
unexpect:
 default
 PRINT "Unexpected error"
 PRINT "Ending program"
 END

REM $STATIC
SUB center (x, a$)
 LOCATE x, 40 - INT(LEN(a$) / 2)
 PRINT a$
END SUB

FUNCTION cut$ (x)
 cut$ = LTRIM$(STR$(x))
END FUNCTION

SUB default
 SCREEN 0
 CLS
 WIDTH 80, 25
END SUB

SUB dig (x, y)
 IF x THEN
  IF person(man).sta THEN
   IF grid(person(man).col + x, person(man).row).typ = dirt THEN
    grid(person(man).col + x, person(man).row).typ = nothing
    set person(man).col + x, person(man).row, grid(person(man).col, person(man).row).typ, 1
    PLAY "n5n4n3n2n1"
    person(man).sta = person(man).sta - 1
    set person(man).col, person(man).row, grid(person(man).col, person(man).row).typ, 1
    person(man).col = person(man).col + x
    set person(man).col, person(man).row, person(man).sex, 1
    fall
    findmoney
   END IF
  END IF
 ELSE
  IF person(man).sta THEN
   IF grid(person(man).col, person(man).row + y).typ = dirt THEN
    grid(person(man).col, person(man).row + y).typ = nothing
    PLAY "n5n4n3n2n1"
    person(man).sta = person(man).sta - 1
    set person(man).col, person(man).row, grid(person(man).col, person(man).row).typ, 1
    person(man).row = person(man).row + y
    set person(man).col, person(man).row, person(man).sex, 1
    person(man).cling = 1
    fall
    findmoney
   END IF
  END IF
 END IF
END SUB

SUB domove
 done = 0
 DO
  LOCATE 20, 53: PRINT "Player #"; cut$(man); "'s turn"
  prompt "Command?"
  LINE (401, 25)-(638, 249), 0, BF
  LOCATE 4, 55: PRINT "S - Save"
  LOCATE , 55: PRINT "R - Restore"
  LOCATE , 55: PRINT "Q - Quit"
  LOCATE , 55: PRINT "M - Move"
  LOCATE , 55: PRINT "I - Item"
  LOCATE , 55: PRINT "V - View"
  LOCATE , 55: PRINT "C - Climb"
  IF item(man, 1) THEN LOCATE , 55: PRINT "D - Dig"
  LOCATE , 55: PRINT "Enter - End turn"
  WHILE INKEY$ <> "": WEND
  DO
   a$ = UCASE$(INKEY$)
  LOOP UNTIL a$ = "Q" OR a$ = "M" OR a$ = CHR$(13) OR a$ = "D" AND item(man, 1) OR a$ = "V" OR a$ = "I" OR a$ = "C"
  SELECT CASE a$
   CASE "Q": IF query(21, 53, "Are you sure? (Y/N)") = "Y" THEN endgame
   CASE "M"
    LINE (401, 25)-(638, 249), 0, BF
    LOCATE 4, 55: PRINT " - Up"
    LOCATE , 55: PRINT " - Down"
    LOCATE , 55: PRINT " - Right"
    LOCATE , 55: PRINT " - Left"
    LOCATE , 55: PRINT "Enter - Done"
    DO
     prompt "Remaining movement:" + STR$(person(man).spd)
     DO: a$ = UCASE$(INKEY$): LOOP UNTIL a$ <> ""
     SELECT CASE a$
      CASE CHR$(0) + "H": moveman 0, -1
      CASE CHR$(0) + "M": moveman 1, 0
      CASE CHR$(0) + "P": moveman 0, 1
      CASE CHR$(0) + "K": moveman -1, 0
     END SELECT
    LOOP UNTIL a$ = CHR$(13)
    prompt "Command?"
   CASE CHR$(13): IF query(21, 53, "Are you sure? (Y/N)") = "Y" THEN done = 1
   CASE "D"
    LINE (401, 25)-(638, 249), 0, BF
    LOCATE 4, 55: PRINT " - Up"
    LOCATE , 55: PRINT " - Down"
    LOCATE , 55: PRINT " - Right"
    LOCATE , 55: PRINT " - Left"
    LOCATE , 55: PRINT "Enter - done"
    DO
     prompt "Remaining strength:" + STR$(person(man).sta)
     DO: a$ = UCASE$(INKEY$): LOOP UNTIL a$ <> ""
     SELECT CASE a$
      CASE CHR$(0) + "H": dig 0, -1
      CASE CHR$(0) + "M": dig 1, 0
      CASE CHR$(0) + "P": dig 0, 1
      CASE CHR$(0) + "K": dig -1, 0
     END SELECT
    LOOP UNTIL a$ = CHR$(13)
    prompt "Command?"
   CASE "V"
    GET (150, 111)-(280, 229), box&
    LINE (150, 111)-(280, 229), 15, B
    LINE (151, 112)-(279, 228), 0, BF
    LOCATE 9, 20: PRINT USING "Player #'s Stats"; man
    'LOCATE , 21: PRINT USING "Health:    ###"; person(man).hth
    LOCATE , 21: PRINT USING "Agility:    ##"; person(man).agi
    LOCATE , 21: PRINT USING "Movement:   ##"; person(man).spd
    LOCATE , 21: PRINT USING "Stamina:    ##"; person(man).str
    LOCATE , 21: PRINT USING "Strength:   ##"; person(man).sta
    'LOCATE , 21: PRINT USING "Oxygen:    ###"; person(man).oxy
    LOCATE , 21: PRINT USING "Money:    ####"; person(man).money
    WHILE INKEY$ = "": WEND
    PUT (150, 111), box&, PSET
   CASE "I"
    DO
     LINE (401, 25)-(638, 249), 0, BF
     LOCATE 4, 55: PRINT "H - Hydrogen filters:"; item(man, 2)
     LOCATE , 55: PRINT "C - CO2 filter:"; item(man, 3)
     LOCATE , 55: PRINT "M - Methane filter:"; item(man, 4)
     LOCATE , 55: PRINT "O - Oxygen filter:"; item(man, 5)
     LOCATE , 55: PRINT "L - Light:"; item(man, 6)
     LOCATE , 55: PRINT "S - Plant seeds:"; item(man, 7)
     LOCATE , 55: PRINT "W - Hydrolysis device:"; item(man, 8)
     LOCATE , 55: PRINT "A - Airlock:"; item(man, 9)
     LOCATE , 55: PRINT "F - Firewood:"; item(man, 10)
     LOCATE , 55: PRINT "T - Matches:"; item(man, 11)
     LOCATE , 55: PRINT "ESC - Done"
     DO
      a$ = UCASE$(INKEY$)
     LOOP UNTIL a$ <> ""
     SELECT CASE a$
      CASE "H"
       IF item(man, 2) THEN
        IF grid(person(man).col, person(man).row).typ = 0 THEN
         set person(man).col, person(man).row, 12, 2
         grid(person(man).col, person(man).row).typ = 12
         item(man, 2) = item(man, 2) - 1
        ELSE wrong "No space"
        END IF
       ELSE wrong "None left"
       END IF
      END SELECT
    LOOP UNTIL a$ = CHR$(27)
   CASE "C"
    z = 0
    LINE (401, 25)-(638, 249), 0, BF
    LOCATE 4, 55: PRINT " - Climb"
    LOCATE , 55: PRINT "Enter - Done"
    prompt "Remaining strength:" + STR$(person(man).sta)
    DO
     IF person(man).col < 26 AND empty(person(man).col + 1, person(man).row) = 0 OR person(man).col > 1 AND empty(person(man).col - 1, person(man).row) = 0 THEN z = 1 ELSE z = 0
     IF z THEN
      DO
       a$ = INKEY$
      LOOP UNTIL a$ = CHR$(13) OR a$ = CHR$(0) + "H"
      IF a$ = CHR$(0) + "H" THEN
       IF person(man).sta THEN
        set person(man).col, person(man).row, 0, 1
        person(man).row = person(man).row - 1
        set person(man).col, person(man).row, person(man).sex, 1
        climbed = 1
        y = 0
        FOR x = 1 TO person(man).agi
         IF CINT(RND * 2) = 0 THEN y = 1
        NEXT
        IF y = 0 THEN
         wrong "You fell!      "
         climbed = 0
         fall
        END IF
        PLAY "l32n5n4n3n2n1l64"
       END IF
      END IF
     ELSE
      IF climbed THEN
       LOCATE 4, 55: PRINT " - Move"
       LOCATE , 55: PRINT "            "
       DO
        a$ = INKEY$
       LOOP UNTIL a$ = CHR$(0) + "M" OR a$ = CHR$(0) + "K"
       IF a$ = CHR$(0) + "M" THEN
        moveman 1, 0
       ELSE
        moveman -1, 0
       END IF
      ELSE wrong "Not near wall"
      END IF
     END IF
    LOOP UNTIL a$ = CHR$(13) OR z = 0
    IF a$ = CHR$(13) AND climbed THEN person(man).cling = 1
  END SELECT
 LOOP UNTIL done
END SUB

SUB drawcursor (x, y)
 PUT ((x - 1) * 16, (y - 1) * 16), fig(0, 15), XOR
END SUB

SUB drawscreen
 SCREEN 9
 PALETTE 5, 39
 LINE (0, 32)-(399, 335), 6, BF
 LINE (400, 0)-(639, 349), 15, B
 LINE (400, 250)-(639, 250), 15
 LOCATE 2, 63: PRINT "LIFE I"
 FOR x = 1 TO 2
  set person(x).col, person(x).row, person(x).sex, 1
 NEXT
 VIEW PRINT 1 TO 25
 LOCATE 25: PRINT " Life I: A Doomed Planet   Chad Austin   Ver 1.0";
 LINE (0, 336)-(398, 349), 15, B
 LINE (203, 336)-(315, 349), 15, B
END SUB

FUNCTION empty (x, y)
 IF grid(x, y).typ <> nothing THEN
  a = 1
 END IF
 FOR z = 1 TO people
  IF person(z).col = x AND person(z).row = y THEN
   a = 1
  END IF
 NEXT
 empty = a
END FUNCTION

SUB endgame
 KEY(15) OFF
 DEF SEG = 0
 POKE 1047, x
 DEF SEG
 default
 PRINT "Thank you for playing Life."
 PRINT "Written in MS-DOS QBasic by Chad Austin."
 END
END SUB

SUB fall
 FOR x = 1 TO people
  IF person(x).cling = 0 THEN
   DO WHILE empty(person(x).col, person(x).row + 1) = 1
    x! = TIMER
    DO: LOOP UNTIL TIMER - x! > .15
    set person(x).col, person(x).row, grid(person(x).col, person(x).row).typ, 1
    person(x).row = person(x).row + 1
    set person(x).col, person(x).row, person(x).sex, 1
   LOOP
  END IF
 NEXT
END SUB

SUB findmoney
 IF CINT(RND * 5) = 0 THEN
  y = RND * 14 + 1
  person(man).money = person(man).money + y
  GET (109, 125)-(305, 154), box&
  LINE (109, 125)-(305, 154), 15, B
  LINE (110, 126)-(304, 153), 0, BF
  LOCATE 10, 16: PRINT "Player #"; cut$(man); " found $"; cut$(y); " in"
  LOCATE 11, 15: PRINT "precious metals and gems"
  x! = TIMER
  DO: LOOP UNTIL TIMER - x! > .25
  WHILE INKEY$ <> "": WEND
  WHILE INKEY$ = "": WEND
  PUT (109, 125), box&, PSET
 END IF
END SUB

SUB initstats
 FOR x = 1 TO 2
  person(x).row = 2
  person(x).col = (x - 1) * 2 + 12
  person(x).sex = x
  person(x).agi = 7
  person(x).str = 7
  person(x).money = 90 + CINT(RND * 20)
  item(x, 1) = 1
  item(x, 2) = 2
  item(x, 3) = 2
  item(x, 4) = 2
  item(x, 5) = 3
  item(x, 6) = 2
  item(x, 7) = 5
  item(x, 8) = 1
  item(x, 9) = 1
  item(x, 10) = 1
  item(x, 11) = 5
 NEXT
 people = 2
 item(1, 1) = 1
 FOR x = 1 TO 25
  FOR y = 3 TO 21
   grid(x, y).typ = 14
  NEXT
 NEXT
 PLAY "l64mb"
END SUB

SUB intro
 CLS
 COLOR 15
 center 2, "LIFE: A Doomed Planet"
 center 3, "Ver 1.0"
 center 23, "Hit any key to continue"
 COLOR 14
 center 4, "A Simulation Game"
 COLOR 9
 center 6, "By: Chad Austin"
 COLOR 7
 center 8, "    The ozone layer has deteriorated.  People are dying of"
 center 9, "hunger and disease all across the world.  A lethal plague "
 center 10, "is steadily spreading.  In other words, all humanity is   "
 center 11, "dying.  It is just you and your spouse out there.  You    "
 center 12, "must find shelter, grow a good food supply, and attract   "
 center 13, "other people.  Otherwise, death will find you. . . .      "
 WHILE INKEY$ = "": WEND
END SUB

SUB moveman (x, y)
 IF x THEN
  IF x = -1 AND person(man).col > 1 OR x = 1 AND person(man).col < 25 THEN
   IF empty(person(man).col + x, person(man).row) THEN
    IF person(man).spd THEN
     set person(man).col, person(man).row, grid(person(man).col, person(man).row).typ, 1
     person(man).col = person(man).col + x
     set person(man).col, person(man).row, person(man).sex, 1
     person(man).spd = person(man).spd - 1
     PLAY "n1"
     person(man).cling = 0
     fall
    END IF
   END IF
  END IF
 ELSE
  IF person(man).row < 26 THEN
   IF grid(person(man).col, person(man).row - y).typ = 15 THEN
    IF person(man).spd THEN
     set person(man).col, person(man).row, grid(person(man).col, person(man).row).typ, 1
     person(man).row = person(man).row + y
     set person(man).col, person(man).row, person(man).sex, 1
     person(man).spd = person(man).spd - 1
     PLAY "n1"
     fall
    END IF
   ELSE
    person(man).cling = 0
    fall
   END IF
  END IF
 END IF
END SUB

SUB playgame
 PLAY "mb"
 DO
  FOR man = 1 TO people
   person(man).spd = person(man).agi
   person(man).sta = person(man).str
   domove
  NEXT
  SELECT CASE CINT(RND)
   CASE 0: sandstorm
  END SELECT
 LOOP
END SUB

SUB prompt (a$)
 LOCATE 21, 53: PRINT a$; SPACE$(27 - LEN(a$))
END SUB

FUNCTION query$ (x, y, a$)
 LOCATE x, y: PRINT a$
 WHILE B$ <> "Y" AND B$ <> "N"
  B$ = UCASE$(INKEY$)
 WEND
 LOCATE x, y: PRINT SPACE$(LEN(a$))
 query$ = B$
END FUNCTION

SUB sandstorm
 FOR x = 1 TO 25
  y = 0
  DO WHILE empty(x, y + 1) = 0
   y = y + 1
  LOOP
  grid(x, y).typ = sand
  set x, y, sand, 1
 NEXT
END SUB

SUB set (x, y, z, a)
 SELECT CASE a
  CASE 1: PUT ((x - 1) * 16, (y - 1) * 16), fig(0, z), PSET
  CASE 2: PUT ((x - 1) * 16, (y - 1) * 16), fig(0, z), OR
 END SELECT
END SUB

SUB wrong (a$)
 DIM B&(1000)
 GET (416, 280)-(624, 295), B&
 LOCATE 21, 53: PRINT a$ + SPACE$(27 - LEN(a$))
 WHILE INKEY$ = "": WEND
 PUT (416, 280), B&, PSET
END SUB

