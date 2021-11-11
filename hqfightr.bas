DEFINT A-Z
DECLARE FUNCTION Skull% (x%)
DECLARE FUNCTION White% (x%)
DECLARE SUB Battle ()
DECLARE SUB BeginStats ()
DECLARE SUB Center (row%, text$)
DECLARE SUB GetInputs ()
DECLARE SUB GetMagic ()
TYPE PlayerType
 char    AS STRING * 9
 BP      AS INTEGER
 MP      AS INTEGER
 att     AS INTEGER
 veil    AS INTEGER
 dead    AS INTEGER
 courage AS INTEGER
 slp     AS INTEGER
 rock    AS INTEGER
 tempest AS INTEGER
 wind    AS INTEGER
 MaxBP   AS INTEGER
END TYPE
 RANDOMIZE TIMER
 DIM SHARED player(1 TO 2) AS PlayerType
 DIM SHARED spell(1 TO 2, 1 TO 12) AS STRING
 DIM SHARED first
 DEF FnOpp (x)
  IF x = 1 THEN FnOpp = 2 ELSE FnOpp = 1
 END DEF
 GetInputs
 BeginStats
 GetMagic
 Battle

SUB Battle
 CLS
 DO
  FOR z = 1 TO 2
   IF player(2).BP > 0 AND first AND player(z).tempest = 0 THEN
    COLOR (z - 1) * 4 + 9
    LOCATE , 10
    PRINT RTRIM$(player(1).char); "'s BP:"; player(1).BP; SPC(20); RTRIM$(player(2).char); "'s BP:"; player(2).BP
    PRINT "What do you do, "; RTRIM$(player(z).char); "? (Attack/Cast a spell/Run)"
    DO
     kbd$ = UCASE$(INKEY$)
    LOOP UNTIL kbd$ = "A" OR kbd$ = "C" OR kbd$ = "R"
    SELECT CASE kbd$
    CASE "A"
     x = 0
     x = player(z).att
     IF player(z).courage THEN x = x + 2
     x = Skull(x)
     IF player(FnOpp(z)).rock THEN y = 3 ELSE y = 2
     y = White(y)
     dmg = x - y
     IF dmg < 0 THEN dmg = 0
     player(FnOpp(z)).BP = player(FnOpp(z)).BP - dmg
     PRINT "You injure the "; RTRIM$(player(FnOpp(z)).char); " for"; dmg; "body points."
     IF player(FnOpp(z)).rock AND dmg > 0 THEN
      player(FnOpp(z)).rock = 0
      PRINT "The "; RTRIM$(player(FnOpp(z)).char); "'s rock skin wore off."
     END IF
    CASE "C"
     x = 0
     FOR y = 1 TO 12
      IF LEN(RTRIM$(spell(z, y))) THEN x = 1
     NEXT
     IF (player(z).char = "Elf      " OR player(z).char = "Wizard   ") AND x = 1 THEN
      FOR x = 1 TO 12
       IF LEN(RTRIM$(spell(z, x))) THEN PRINT x; spell(z, x)
      NEXT
      DO
       DO
        LINE INPUT "Which spell do you cast? "; a$
        x = VAL(a$)
       LOOP UNTIL x > 0 AND x < 13
      LOOP UNTIL LEN(RTRIM$(spell(z, x)))
      SELECT CASE spell(z, x)
      CASE "BALL OF FLAME"
       y = 2 - White(2)
       PRINT "You injure the "; RTRIM$(player(FnOpp(z)).char); " for"; y; " points of damage."
       player(FnOpp(z)).BP = player(FnOpp(z)).BP - y
      CASE "FIRE OF WRATH"
       y = 1 - White(1)
       PRINT "You injure the "; RTRIM$(player(FnOpp(z)).char); " for"; y; "points of damage."
       player(FnOpp(z)).BP = player(FnOpp(z)).BP - y
      CASE "COURAGE"
       player(z).courage = 1
       PRINT "Your attack is increased by two for the rest of the fight."
      CASE "SLEEP"
       w = 0
       FOR a = 1 TO player(FnOpp(z)).MP
        y = RND * 5
        IF y = 6 THEN w = 1
       NEXT
       IF w THEN
        player(FnOpp(z)).slp = 1
        PRINT "The "; RTRIM$(player(FnOpp(z)).char); " is asleep."
       ELSE PRINT "The spell failed."
       END IF
      CASE "VEIL OF MIST", "PASS THROUGH ROCK"
       PRINT "You can run away whenever you want to."
       player(z).veil = 1
      CASE "WATER OF HEALING", "HEAL BODY"
       player(z).BP = player(z).BP + 4
       IF player(z).BP > player(z).MaxBP THEN player(z).BP = player(z).MaxBP
       PRINT "You have recovered four hit points."
      CASE "ROCK SKIN"
       PRINT "Your defense is increased by one until you lose a body point."
       player(z).rock = 1
      CASE "GENIE"
       y = Skull(5)
       player(FnOpp(z)).BP = player(FnOpp(z)).BP - y
       PRINT "You injure the "; RTRIM$(player(FnOpp(z)).char); " for"; y; "body points."
      CASE "TEMPEST"
       player(FnOpp(z)).tempest = 1
       PRINT "Your opponent is paralyzed for one turn."
      CASE "SWIFT WIND"
       player(z).wind = 1
       PRINT "On your next turn, your speed is doubled."
      END SELECT
      spell(z, x) = ""
     ELSE
      PRINT "You do not have any spells."
      z = z - 1
     END IF
    CASE "R"
     IF player(z).wind THEN x = 4 ELSE x = 2
     w = 0: v = 0
     FOR y = 1 TO x
      w = w + RND * 5
     NEXT
     IF player(FnOpp(z)).wind THEN x = 4 ELSE x = 2
     FOR y = 1 TO x
      v = v + RND * 5
     NEXT
     IF w >= v OR player(z).veil THEN
      done = 1
      PRINT "You ran away, "; RTRIM$(player(z).char); ".": END
     ELSE PRINT "You could not run away."
     END IF
     IF player(z).wind THEN player(z).wind = 0
    END SELECT
    w = 0
    IF z THEN
     FOR x = 1 TO player(z).MP
      y = RND * 5 + 1
      IF y = 6 THEN w = 1
     NEXT
     IF w AND player(z).slp THEN
      PRINT "The "; RTRIM$(player(z).char); " woke up."
      player(z).slp = 0
     ELSEIF player(z).slp THEN PRINT "The "; RTRIM$(player(z).char); " is asleep."
     END IF
    END IF
   END IF
   IF z THEN player(z).tempest = 0
   first = 1
  NEXT
 LOOP UNTIL done = 1 OR player(1).BP < 1 OR player(2).BP < 1
 IF player(1).BP < 1 THEN
  PRINT "The "; RTRIM$(player(1).char); " died."
 ELSEIF player(2).BP < 1 THEN
  PRINT "The "; RTRIM$(player(2).char); " died."
 END IF
 x! = TIMER
 WHILE TIMER - x! <= 1: WEND
 WHILE INKEY$ <> "": WEND
 WHILE INKEY$ = "": WEND
 CLS
 COLOR 7
END SUB

SUB BeginStats
 FOR x = 1 TO 2
  SELECT CASE RTRIM$(player(x).char)
  CASE "Barbarian"
   player(x).MaxBP = 8
   player(x).MP = 2
   player(x).att = 3
  CASE "Dwarf"
   player(x).MaxBP = 7
   player(x).MP = 3
   player(x).att = 2
  CASE "Elf"
   player(x).MaxBP = 6
   player(x).MP = 4
   player(x).att = 2
  CASE "Wizard"
   player(x).MaxBP = 4
   player(x).MP = 6
   player(x).att = 1
  END SELECT
  player(x).BP = player(x).MaxBP
 NEXT
END SUB

SUB Center (row, text$)
 LOCATE row, 40 - INT(LEN(text$) / 2)
 PRINT text$
END SUB

SUB GetInputs
 CLS
 COLOR 12
 Center 2, "HEROQUEST FIGHTERS"
 Center 3, "By: Chad Austin"
 COLOR 15
 Center 5, "THE FIGHTERS:"
 DIM char(7 TO 10) AS STRING * 9
 DIM taken(7 TO 10)
 char(7) = "Barbarian"
 char(8) = "Dwarf"
 char(9) = "Elf"
 char(10) = "Wizard"
 COLOR 14
 Center 8, "Dwarf    "
 Center 9, "Elf      "
 Center 10, "Wizard   "
 FOR x = 1 TO 2
  row = 7 + taken(7)
  COLOR (x - 1) * 4 + 9
  Center row, char(row)
  LOCATE 12, (x - 1) * 58 + 6
  PRINT "Player"; x
  DO
   kbd$ = INKEY$
   SELECT CASE kbd$
   CASE CHR$(0) + "H"
    COLOR 14
    Center row, char(row)
    DO
     row = row - 1
     IF row = 6 THEN row = 10
    LOOP WHILE taken(row)
    COLOR (x - 1) * 4 + 9
    Center row, char(row)
   CASE CHR$(0) + "P"
    COLOR 14
    Center row, char(row)
    DO
     row = row + 1
     IF row = 11 THEN row = 7
    LOOP WHILE taken(row)
    IF row = 11 THEN row = 7
    COLOR (x - 1) * 4 + 9
    Center row, char(row)
   END SELECT
  LOOP UNTIL kbd$ = CHR$(13)
  player(x).char = char(row)
  COLOR 15
  LOCATE 13, (x - 1) * 58 + 7
  PRINT player(x).char
  taken(row) = 1
 NEXT
 Center 17, "Who moves first?"
 COLOR 9
 Center 19, player(1).char + "    "
 COLOR 13
 Center 20, player(2).char + "    "
 COLOR 15
 x! = TIMER
 FOR y# = 1 TO 1000: NEXT
 speed = 200 / (TIMER - x!)
 DO
  FOR w = 1 TO speed
   x = RND * 9
   LOCATE 19, 44: PRINT x
  NEXT
  FOR y = 1 TO speed
   z = RND * 9
   LOCATE 20, 44: PRINT z
  NEXT
  IF x = z THEN Center 22, "Tie!"
 LOOP UNTIL x <> z
 IF x > z THEN
  Center 22, "Player #1 goes first."
  first = 1
 ELSE Center 22, "Player #2 goes first."
 END IF
 WHILE INKEY$ <> "": WEND
 WHILE INKEY$ = "": WEND
END SUB

SUB GetMagic
 CLS
 DIM taken(4)
 COLOR 15
 Center 2, " Spell Groups "
 COLOR 12: Center 4, "1) FIRE "
 COLOR 6: Center 5, "2) EARTH"
 COLOR 11: Center 6, "3) WIND "
 COLOR 9: Center 7, "4) WATER"
 COLOR 7
 y = 10
 IF player(1).char = "Wizard   " OR player(2).char = "Wizard   " THEN
  Center y, "Wizard, choose a spell group (1-4):"
  DO
   x = VAL(INKEY$)
  LOOP UNTIL x > 0 AND x < 5
  Center x + 3, SPACE$(8)
  LOCATE y, 58: PRINT x
  IF player(1).char = "Wizard   " THEN taken(x) = 1 ELSE taken(x) = 2
  y = y + 1
 END IF
 IF player(1).char = "Elf      " OR player(2).char = "Elf      " THEN
  Center y, "Elf, choose a spell group (1-4):"
  f = 0
  DO
   x = VAL(INKEY$)
   IF x > 0 AND x < 5 THEN IF taken(x) = 0 THEN f = 1
  LOOP UNTIL f
  Center x + 3, SPACE$(8)
  LOCATE y, 56: PRINT x
  IF player(1).char = "Elf      " THEN taken(x) = 1 ELSE taken(x) = 2
  y = y + 1
 END IF
 IF player(1).char = "Wizard   " OR player(2).char = "Wizard   " THEN
  Center y, "Wizard, choose a spell group (1-4):"
  f = 0
  DO
   x = VAL(INKEY$)
   IF x > 0 AND x < 5 THEN IF taken(x) = 0 THEN f = 1
  LOOP UNTIL f
  Center x + 3, SPACE$(8)
  LOCATE y, 58: PRINT x
  IF player(1).char = "Wizard   " THEN taken(x) = 1 ELSE taken(x) = 2
  y = y + 1
  Center y, "Wizard, choose a spell group (1-4):"
  f = 0
  DO
   x = VAL(INKEY$)
   IF x > 0 AND x < 5 THEN IF taken(x) = 0 THEN f = 1
  LOOP UNTIL f
  Center x + 3, SPACE$(8)
  LOCATE y, 58: PRINT x
  IF player(1).char = "Wizard   " THEN taken(x) = 1 ELSE taken(x) = 2
 END IF
 IF taken(1) THEN
  spell(taken(1), 1) = "BALL OF FLAME"
  spell(taken(1), 2) = "FIRE OF WRATH"
  spell(taken(1), 3) = "COURAGE"
 END IF
 IF taken(2) THEN
  spell(taken(2), 7) = "HEAL BODY"
  spell(taken(2), 8) = "PASS THROUGH ROCK"
  spell(taken(2), 9) = "ROCK SKIN"
 END IF
 IF taken(3) THEN
  spell(taken(3), 10) = "GENIE"
  spell(taken(3), 11) = "TEMPEST"
  spell(taken(3), 12) = "SWIFT WIND"
 END IF
 IF taken(4) THEN
  spell(taken(4), 4) = "SLEEP"
  spell(taken(4), 5) = "VEIL OF MIST"
  spell(taken(4), 6) = "WATER OF HEALING"
 END IF
END SUB

FUNCTION Skull (x)
 FOR y = 1 TO x
  IF CINT(RND) THEN z = z + 1
 NEXT
 Skull = z
END FUNCTION

FUNCTION White (x)
 FOR y = 1 TO x
  IF CINT(RND * 2) = 2 THEN z = z + 1
 NEXT
 White = z
END FUNCTION

