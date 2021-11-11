DEFINT A-Z
DECLARE FUNCTION choose% (a%, b%)
DECLARE FUNCTION cut$ (x%)
DECLARE FUNCTION getint% (x%, y%, a$, a%, b%)
DECLARE FUNCTION getstring$ (a%, b%, a$)
DECLARE FUNCTION getterr% (a%, b%)
DECLARE FUNCTION query$ (a%, a$)
DECLARE SUB battle (a%, b%)
DECLARE SUB beginstats ()
DECLARE SUB build (x%, y%)
DECLARE SUB center (a%, a$)
DECLARE SUB changestats (a%)
DECLARE SUB clearplayer (x%)
DECLARE SUB clearterr (a%)
DECLARE SUB createchar (a%, b%)
DECLARE SUB default ()
DECLARE SUB domove (a$)
DECLARE SUB drawscreen ()
DECLARE SUB endgame ()
DECLARE SUB equip (x%, y%)
DECLARE SUB gethome (gh%)
DECLARE SUB getinputs ()
DECLARE SUB getkey (a$)
DECLARE SUB hire (x%, y%)
DECLARE SUB intro ()
DECLARE SUB movecomp ()
DECLARE SUB paintland (a%, b%)
DECLARE SUB playcastles ()
DECLARE SUB printstats ()
DECLARE SUB raid ()
DECLARE SUB raisehp ()
DECLARE SUB restoregame ()
DECLARE SUB savegame ()
DECLARE SUB showend ()
DECLARE SUB taxpeas ()
DECLARE SUB wrong (a$)
TYPE playertype
 attack  AS INTEGER
 shield  AS INTEGER
 bow     AS INTEGER
 clr     AS INTEGER
 con     AS STRING * 12
 ctitle  AS STRING * 8
 defense AS INTEGER
 home    AS INTEGER
 hp      AS INTEGER
 land    AS INTEGER
 nam     AS STRING * 12
 nctitle AS INTEGER
 ntitle  AS INTEGER
 people  AS INTEGER
 points  AS INTEGER
 spear   AS INTEGER
 tact    AS INTEGER
 sword   AS INTEGER
 title   AS STRING * 8
 gender  AS STRING * 1
 money   AS INTEGER
END TYPE
TYPE terrtype
 attack   AS INTEGER
 shield   AS INTEGER
 bow      AS INTEGER
 cannon   AS INTEGER
 castle   AS INTEGER
 cavalry  AS INTEGER
 defense  AS INTEGER
 dock     AS INTEGER
 fort     AS INTEGER
 knights  AS INTEGER
 hp       AS INTEGER
 maxhp    AS INTEGER
 men      AS INTEGER
 own      AS INTEGER
 ship     AS INTEGER
 spear    AS INTEGER
 tact     AS INTEGER
 soldiers AS INTEGER
 sword    AS INTEGER
 town     AS INTEGER
 water    AS INTEGER
 col      AS INTEGER
 row      AS INTEGER
 size     AS INTEGER
 peasant  AS INTEGER
END TYPE
'$DYNAMIC
 RANDOMIZE TIMER
 DIM SHARED player(1 TO 7) AS playertype, terr(1 TO 99)  AS terrtype, adj(1 TO 99, 1 TO 99)
 DIM SHARED fileready(99), numplayers, planet, curplayer, maxterr, moves
 DIM SHARED save, curmove, playernow, ranhome, comp, ranplanet, attfact AS SINGLE
 ON ERROR GOTO screenerror
 SCREEN 9, , 1, 1
 SCREEN 0, , 0
 WIDTH 80, 25
 ON ERROR GOTO nofile
 FOR a = 1 TO 9
  fileready(a) = 1
  OPEN "cast3sav." + cut$(a) FOR INPUT AS #1
  CLOSE #1
 NEXT
 ON ERROR GOTO unexpect
 intro
 restoregame
 getinputs
 beginstats
 drawscreen
 IF comp THEN gethome numplayers + 1
 FOR x = 1 TO numplayers
  gethome x
 NEXT
 playcastles
screenerror:
 PRINT "You must have EGA 64K+ or VGA to play Castles II."
 END
nofile: fileready(a) = 0
RESUME NEXT
filenotfound: curmove = 0
RESUME NEXT
unexpect:
 default
 PRINT "Unexpected error"
 PRINT "Ending program"
 END

REM $STATIC
SUB battle (a, b)
 IF (terr(a).tact = 0 OR terr(a).attack = 0) AND terr(b).tact <> 0 AND terr(b).attack <> 0 THEN e = 1
 VIEW PRINT 18 TO 24
 LOCATE 20
 FOR c = 1 TO 3
  x = 0
  hptaken = 0
  FOR d = 1 TO CINT(RND * terr(b).tact) / 2
   hptaken = CINT(RND * terr(b).attack / 4) - CINT(RND * terr(a).defense / 2)
   IF SGN(hptaken) = -1 THEN hptaken = 0
   g = 0
   IF hptaken THEN
    IF player(terr(a).own).defense THEN g = RND * (player(terr(b).own).attack / player(terr(a).own).defense) ELSE g = RND * player(terr(b).own).attack
    IF g < 0 THEN g = 0
    hptaken = hptaken + g
   END IF
   terr(a).hp = terr(a).hp - hptaken
   x = x + hptaken
   IF terr(a).hp < 0 THEN
    e = 1
    terr(a).hp = 0
    EXIT FOR
   END IF
  NEXT
  PRINT "The attacker damages for"; x; "hit points."
  x! = TIMER
  DO: LOOP UNTIL TIMER - x! > 1
  x = 0
  hptaken = 0
  IF e THEN EXIT FOR
  FOR d = 1 TO CINT(RND * terr(a).tact) / 2
   hptaken = CINT(RND * terr(a).attack / 8) - CINT(RND * terr(b).defense)
   IF SGN(hptaken) = -1 THEN hptaken = 0
   g = 0
   IF hptaken THEN
    IF player(terr(b).own).defense THEN g = RND * (player(terr(b).own).attack / player(terr(b).own).defense)
    IF g < 0 THEN g = 0
    hptaken = hptaken + g
   END IF
   terr(b).hp = terr(b).hp - hptaken
   x = x + hptaken
   IF terr(b).hp < 0 THEN
    F = 1
    terr(b).hp = 0
    EXIT FOR
   END IF
  NEXT
  PRINT "The defender retaliates for"; x; "hit points."
  x! = TIMER
  DO: LOOP UNTIL TIMER - x! > 1
  IF F THEN EXIT FOR
 NEXT
 CLS 2
 VIEW PRINT
 LOCATE 18
 IF terr(b).attack THEN IF player(terr(b).own).nam = "Autokill    " AND CINT(RND * 100) <= CINT((terr(b).attack / terr(b).attack + 1) * 100) THEN e = 1
 IF e THEN
  PRINT RTRIM$(player(terr(b).own).nam); " conquers!"
  player(terr(b).own).sword = player(terr(b).own).sword + terr(a).sword
  player(terr(b).own).shield = player(terr(b).own).shield + terr(a).shield
  player(terr(b).own).spear = player(terr(b).own).spear + terr(a).spear
  player(terr(b).own).bow = player(terr(b).own).bow + terr(a).bow
  player(terr(b).own).land = player(terr(b).own).land + 1
  player(terr(a).own).land = player(terr(a).own).land - 1
  IF a = player(terr(a).own).home THEN
   FOR c = 1 TO maxterr
    IF terr(a).own = terr(c).own THEN
     player(terr(b).own).sword = player(terr(b).own).sword + terr(c).sword
     player(terr(b).own).shield = player(terr(b).own).shield + terr(c).shield
     player(terr(b).own).spear = player(terr(b).own).spear + terr(c).spear
     player(terr(b).own).bow = player(terr(b).own).bow + terr(c).bow
    END IF
   NEXT
   clearplayer terr(a).own
   IF numplayers + comp = 1 THEN
    curplayer = 1
    showend
   END IF
  ELSE clearterr a
  END IF
  paintland a, (player(terr(b).own).clr)
  terr(a).size = 12 + 3 * player(terr(b).own).ntitle
  terr(a).own = terr(b).own
  terr(a).hp = player(terr(b).own).hp
  terr(a).maxhp = player(terr(b).own).hp
  WHILE INKEY$ = "": WEND
 ELSE
  PRINT "The territory could not be taken"
  WHILE INKEY$ = "": WEND
 END IF
END SUB

SUB beginstats
 IF save = 0 THEN
  FOR b = 1 TO numplayers + comp
   player(b).land = 1
   player(b).sword = 5
   player(b).spear = 3
   player(b).bow = 2
   player(b).shield = 2
   IF player(b).nam = "Weapon Lord " THEN
    player(b).sword = 100
    player(b).shield = 40
    player(b).spear = 60
    player(b).bow = 40
   END IF
   player(b).ntitle = 1
   player(b).nctitle = 1
   IF comp = 0 OR (comp = 1 AND numplayers + comp <> b) THEN createchar b, 0
  NEXT
  IF comp THEN
   player(numplayers + comp).attack = 6
   player(numplayers + comp).defense = 6
   player(numplayers + comp).hp = 6
   player(numplayers + comp).tact = 6
  END IF
  DIM a AS STRING * 5
  ON ERROR GOTO filenotfound
  CLS
  COLOR 15
  center 11, "Checking for Existing Maps"
  center 12, "Please wait. . ."
  center 13, " 0 map(s) found"
  fileready(0) = 1
  FOR b = 1 TO 99
   curmove = 1
   OPEN "castmap." + cut$(b) FOR INPUT AS #1
   IF curmove THEN
    a = "     "
    OPEN "castmap." + cut$(b) FOR BINARY AS #2
    GET #2, , a
    CLOSE
    IF a = "VALID" THEN
     c = c + 1
     fileready(c) = b + 1
     curmove = 0
     LOCATE 13, 32: PRINT USING "##"; c
    END IF
   END IF
  NEXT
  ON ERROR GOTO unexpect
  IF ranplanet THEN
   planet = fileready(CINT(RND * c))
  ELSE
   CLS
   center 2, "Available maps:"
   LOCATE 4
   PRINT "1";
   FOR x = 1 TO c
    PRINT ", "; cut$(fileready(x));
   NEXT
   PRINT
   DO
    d = 0
    planet = getint(12, 32, "Select map: ", 1, 100)
    FOR x = 0 TO c
     IF planet = fileready(x) THEN d = 1
    NEXT
   LOOP UNTIL d
  END IF
 END IF
 IF planet = 1 THEN
  adj(1, 2) = 1: adj(1, 9) = 1: adj(1, 10) = 1: adj(2, 3) = 1: adj(2, 10) = 1
  adj(3, 4) = 1: adj(3, 6) = 1: adj(3, 10) = 1: adj(4, 5) = 1: adj(4, 6) = 1
  adj(5, 6) = 1: adj(6, 7) = 1: adj(6, 9) = 1: adj(6, 10) = 1: adj(7, 8) = 1
  adj(7, 9) = 1: adj(8, 9) = 1: adj(9, 10) = 1: adj(11, 12) = 1
  adj(12, 13) = 1: adj(12, 14) = 1: adj(13, 14) = 1: adj(13, 15) = 1
  adj(14, 15) = 1: adj(16, 17) = 1: adj(16, 18) = 1: adj(16, 20) = 1
  adj(17, 18) = 1: adj(17, 19) = 1: adj(18, 19) = 1: adj(18, 20) = 1
  adj(19, 20) = 1: adj(22, 23) = 1: adj(22, 25) = 1: adj(22, 26) = 1
  adj(23, 24) = 1: adj(23, 26) = 1: adj(24, 26) = 1: adj(24, 27) = 1
  adj(24, 28) = 1: adj(25, 26) = 1: adj(25, 29) = 1: adj(25, 30) = 1
  adj(25, 31) = 1: adj(26, 27) = 1: adj(26, 29) = 1: adj(27, 28) = 1
  adj(27, 29) = 1: adj(27, 32) = 1: adj(27, 33) = 1: adj(27, 34) = 1
  adj(28, 34) = 1: adj(29, 31) = 1: adj(29, 32) = 1: adj(30, 31) = 1
  adj(30, 35) = 1: adj(30, 36) = 1: adj(31, 32) = 1: adj(31, 36) = 1
  adj(31, 37) = 1: adj(32, 33) = 1: adj(32, 37) = 1: adj(32, 38) = 1
  adj(33, 34) = 1: adj(33, 38) = 1: adj(33, 39) = 1: adj(34, 39) = 1
  adj(34, 40) = 1: adj(35, 36) = 1: adj(35, 41) = 1: adj(36, 41) = 1
  adj(36, 37) = 1: adj(36, 42) = 1: adj(36, 43) = 1: adj(37, 38) = 1
  adj(37, 43) = 1: adj(37, 44) = 1: adj(38, 39) = 1: adj(38, 44) = 1
  adj(38, 45) = 1: adj(38, 46) = 1: adj(39, 40) = 1: adj(39, 46) = 1
  adj(39, 47) = 1: adj(40, 47) = 1: adj(41, 42) = 1: adj(41, 59) = 1
  adj(42, 43) = 1: adj(42, 54) = 1: adj(42, 58) = 1: adj(42, 59) = 1
  adj(43, 44) = 1: adj(43, 54) = 1: adj(44, 45) = 1: adj(44, 51) = 1
  adj(44, 52) = 1: adj(44, 54) = 1: adj(45, 46) = 1: adj(45, 50) = 1
  adj(45, 51) = 1: adj(46, 47) = 1: adj(46, 49) = 1: adj(46, 50) = 1
  adj(47, 48) = 1: adj(47, 49) = 1: adj(48, 49) = 1: adj(49, 50) = 1
  adj(50, 51) = 1: adj(51, 52) = 1: adj(51, 53) = 1: adj(52, 53) = 1
  adj(52, 54) = 1: adj(52, 55) = 1: adj(53, 55) = 1: adj(53, 56) = 1
  adj(54, 55) = 1: adj(54, 58) = 1: adj(55, 56) = 1: adj(55, 57) = 1
  adj(55, 58) = 1: adj(56, 57) = 1: adj(57, 58) = 1: adj(57, 60) = 1
  adj(58, 59) = 1: adj(58, 60) = 1: adj(59, 60) = 1
  terr(1).water = 1: terr(2).water = 1: terr(3).water = 1: terr(4).water = 1
  terr(5).water = 1: terr(6).water = 1: terr(7).water = 1: terr(8).water = 1
  terr(9).water = 1: terr(12).water = 1: terr(11).water = 1
  terr(13).water = 1: terr(14).water = 1: terr(15).water = 1
  terr(16).water = 1: terr(17).water = 1: terr(19).water = 1
  terr(20).water = 1: terr(21).water = 1: terr(22).water = 1
  terr(23).water = 1: terr(24).water = 1: terr(47).water = 1
  terr(25).water = 1: terr(28).water = 1: terr(30).water = 1
  terr(34).water = 1: terr(35).water = 1: terr(40).water = 1
  terr(41).water = 1: terr(48).water = 1: terr(49).water = 1
  terr(50).water = 1: terr(51).water = 1: terr(53).water = 1
  terr(56).water = 1: terr(57).water = 1: terr(59).water = 1
  terr(60).water = 1: maxterr = 60
 ELSE
  CLS
  COLOR 15
  center 12, "Loading Map Information"
  center 13, "Please wait. . . ."
  OPEN "castmap." + cut$(planet - 1) FOR BINARY AS #1
  GET #1, 47610, maxterr
  FOR b = 1 TO maxterr
   GET #1, , terr(b).col
   GET #1, , terr(b).row
  NEXT
  FOR b = 1 TO maxterr
   FOR c = 1 TO maxterr
    GET #1, , adj(b, c)
   NEXT
  NEXT
  FOR b = 1 TO maxterr
   GET #1, , terr(b).water
  NEXT
  CLOSE #1
 END IF
END SUB

SUB build (x, y)
 IF curplayer = 0 THEN PRINT "The computer built a ";
 SELECT CASE x
  CASE 1
   player(terr(y).own).money = player(terr(y).own).money - 100
   terr(y).size = terr(y).size - 3
   terr(y).fort = terr(y).fort + 1
   terr(y).defense = terr(y).defense + 5
   terr(y).hp = terr(y).hp + 7
   terr(y).maxhp = terr(y).maxhp + 7
   IF curplayer = 0 THEN PRINT "fort."
  CASE 2
   player(terr(y).own).money = player(terr(y).own).money - 150
   terr(y).castle = terr(y).castle + 1
   terr(y).defense = terr(y).defense + 8
   terr(y).maxhp = terr(y).maxhp + 9
   terr(y).hp = terr(y).hp + 9
   terr(y).size = terr(y).size - 4
   IF curplayer = 0 THEN PRINT "castle."
  CASE 3
   player(terr(y).own).money = player(terr(y).own).money - 150
   player(terr(y).own).people = player(terr(y).own).people + 10
   terr(y).town = terr(y).town + 1
   terr(y).defense = terr(y).defense + 3
   terr(y).maxhp = terr(y).maxhp + 5
   terr(y).hp = terr(y).hp + 5
   terr(y).size = terr(y).size - 3
   IF curplayer = 0 THEN PRINT "town."
  CASE 4
   player(terr(y).own).money = player(terr(y).own).money - 100
   terr(y).dock = terr(y).dock + 1
   terr(y).maxhp = terr(y).maxhp + 3
   terr(y).hp = terr(y).hp + 3
   terr(y).size = terr(y).size - 2
   IF curplayer = 0 THEN PRINT "dock."
  CASE 5
   player(terr(y).own).money = player(terr(y).own).money - 125
   terr(y).ship = terr(y).ship + 1
   terr(y).attack = terr(y).attack + 4
   terr(y).defense = terr(y).defense + 3
   terr(y).maxhp = terr(y).maxhp + 4
   terr(y).hp = terr(y).hp + 4
   terr(y).tact = terr(y).tact + 3
   IF curplayer = 0 THEN PRINT "ship."
  CASE 6
   player(terr(y).own).money = player(terr(y).own).money - 75
   terr(y).cannon = terr(y).cannon + 1
   terr(y).attack = terr(y).attack + 6
   terr(y).maxhp = terr(y).maxhp + 4
   terr(y).hp = terr(y).hp + 4
   terr(y).tact = terr(y).tact + 1
   terr(y).size = terr(y).size - 1
   IF curplayer = 0 THEN PRINT "cannon."
 END SELECT
 raisehp
END SUB

SUB center (a, a$)
 LOCATE a, 40 - (LEN(a$) / 2)
 PRINT a$
END SUB

SUB changestats (a)
 title = player(a).ntitle
 ctitle = player(a).nctitle
 SELECT CASE player(a).people
  CASE IS < 560
   IF player(a).gender = "M" THEN player(a).title = "Lord" ELSE player(a).title = "Lady"
   IF player(a).ntitle < 1 THEN player(a).ntitle = 1
  CASE 560 TO 1339
   IF player(a).gender = "M" THEN player(a).title = "Baron" ELSE player(a).title = "Baroness"
   IF player(a).ntitle < 2 THEN player(a).ntitle = 2
  CASE 1340 TO 2119
   IF player(a).gender = "M" THEN player(a).title = "Duke" ELSE player(a).title = "Duchess"
   IF player(a).ntitle < 3 THEN player(a).ntitle = 3
  CASE 2120 TO 2899
   IF player(a).gender = "M" THEN player(a).title = "King" ELSE player(a).title = "Queen"
   IF player(a).ntitle < 4 THEN player(a).ntitle = 4
  CASE 2900 TO 3679
   IF player(a).gender = "M" THEN player(a).title = "Czar" ELSE player(a).title = "Empress"
   IF player(a).ntitle < 5 THEN player(a).ntitle = 5
  CASE ELSE
   IF player(a).gender = "M" THEN player(a).title = "Emperor" ELSE player(a).title = "Czarina"
   IF player(a).ntitle < 6 THEN player(a).ntitle = 6
 END SELECT
 SELECT CASE player(a).land
  CASE IS < 6
   player(a).ctitle = "Dominion"
   IF player(a).nctitle < 1 THEN player(a).nctitle = 1
  CASE 6 TO 14
   player(a).ctitle = "Barony"
   IF player(a).nctitle < 2 THEN player(a).nctitle = 2
  CASE 15 TO 27
   player(a).ctitle = "Duchy"
   IF player(a).nctitle < 3 THEN player(a).nctitle = 3
  CASE 28 TO 40
   player(a).ctitle = "Kingdom"
   IF player(a).nctitle < 4 THEN player(a).nctitle = 4
  CASE 41 TO 55
   player(a).ctitle = "Czarship"
   IF player(a).nctitle < 5 THEN player(a).nctitle = 5
  CASE ELSE
   player(a).ctitle = "Empire"
   IF player(a).nctitle < 6 THEN player(a).nctitle = 6
 END SELECT
 COLOR player(a).clr
 IF comp AND a = numplayers + comp THEN
  IF title < player(a).ntitle THEN
   FOR b = 1 TO maxterr
    IF terr(b).own = a THEN terr(b).size = terr(b).size + 3
   NEXT
   player(a).tact = player(a).tact + 1
   player(a).hp = player(a).hp + 1
   player(a).attack = player(a).attack + 1
   player(a).defense = player(a).defense + 1
  END IF
  IF ctitle < player(a).nctitle THEN
   player(a).sword = player(a).sword + 3
   player(a).shield = player(a).shield + 1
   player(a).spear = player(a).spear + 2
   player(a).bow = player(a).bow + 1
   player(a).money = player(a).money + 400
  END IF
 ELSE
  IF title < player(a).ntitle THEN
   LINE (0, 238)-(639, 349), 0, BF
   center 19, RTRIM$(player(a).nam) + " has gone up a level!"
   center 20, "Each territory can hold more!"
   FOR b = 1 TO maxterr
    IF terr(b).own = a THEN terr(b).size = terr(b).size + 3
   NEXT
   WHILE INKEY$ = "": WEND
   SCREEN , , 1, 1
   createchar a, 1
   SCREEN , , 0, 0
   LINE (0, 238)-(639, 349), 0, BF
  END IF
  IF ctitle < player(a).nctitle THEN
   LINE (0, 238)-(639, 349), 0, BF
   center 19, "You have gotten more weapons and money!"
   WHILE INKEY$ = "": WEND
   player(a).sword = player(a).sword + 3
   player(a).shield = player(a).shield + 1
   player(a).spear = player(a).spear + 2
   player(a).bow = player(a).bow + 1
   player(a).money = player(a).money + 400
   LINE (0, 238)-(639, 349), 0, BF
  END IF
 END IF
END SUB

FUNCTION choose (b, Z)
 DIM item(1 TO 6) AS STRING * 8
 SELECT CASE b
  CASE 1
   num = 6
   item(1) = "Fort"
   item(2) = "Castle"
   item(3) = "Town"
   item(4) = "Dock"
   item(5) = "Ship"
   item(6) = "Cannon"
   row = 20
   PRINT "Money: "; STR$(player(curplayer).money), , "Empty space:"; terr(Z).size
   PRINT "Item:"
   PRINT "Cost:   100        150      150       100       125         75"
   PRINT "Size:    3          4        3         2         0          1"
  CASE 2
   num = 4
   item(1) = "Men"
   item(2) = "Soldiers"
   item(3) = "Knights"
   item(4) = "Cavalry"
   row = 20
   PRINT "Money: "; player(curplayer).money
   PRINT "Unit:"
   PRINT "Cost:   50          75        100       150"
 END SELECT
 COLOR 15
 LOCATE row, 9: PRINT item(1)
 COLOR player(curplayer).clr
 FOR x = 2 TO num
  LOCATE row, 10 * (x - 1) + 9
  PRINT item(x)
 NEXT
 a = 1
 DO
  kbd$ = UCASE$(INKEY$)
  SELECT CASE kbd$
   CASE CHR$(0) + "M"
    COLOR player(curplayer).clr
    LOCATE row, 10 * (a - 1) + 9: PRINT item(a)
    a = a + 1
    IF a > num THEN a = 1
    COLOR 15
    LOCATE row, 10 * (a - 1) + 9: PRINT item(a)
   CASE CHR$(0) + "K"
    COLOR player(curplayer).clr
    LOCATE row, 10 * (a - 1) + 9: PRINT item(a)
    a = a - 1
    IF a = 0 THEN a = num
    COLOR 15
    LOCATE row, 10 * (a - 1) + 9: PRINT item(a)
   CASE CHR$(27): EXIT FUNCTION
   CASE CHR$(13): EXIT DO
  END SELECT
 LOOP
 choose = a
 COLOR player(curplayer).clr
 SELECT CASE b
  CASE 1: LOCATE 23
  CASE 2: LOCATE 22
 END SELECT
END FUNCTION

SUB clearplayer (x)
 player(x).attack = 0
 player(x).defense = 0
 player(x).hp = 0
 player(x).tact = 0
 FOR a = 1 TO maxterr
  IF terr(a).own = x THEN
   paintland a, 15
   clearterr a
   terr(a).own = 0
  END IF
 NEXT
 FOR a = x TO numplayers + comp - 1
  player(a) = player(a + 1)
 NEXT
 IF comp THEN
  IF x = numplayers + comp THEN
   comp = 0
  ELSE
   numplayers = numplayers - 1
  END IF
 ELSE numplayers = numplayers - 1
 END IF
 FOR a = 1 TO maxterr
  IF terr(a).own > x THEN terr(a).own = terr(a).own - 1
 NEXT
 save = 1
END SUB

SUB clearterr (a)
 terr(a).attack = 0
 terr(a).defense = 0
 terr(a).maxhp = 0
 terr(a).hp = 0
 terr(a).tact = 0
 terr(a).castle = 0
 terr(a).fort = 0
 player(terr(a).own).people = player(terr(a).own).people - 10 * terr(a).town - terr(a).peasant - terr(a).men - terr(a).soldiers - terr(a).knights - terr(a).cavalry
 terr(a).peasant = 0
 terr(a).town = 0
 terr(a).dock = 0
 terr(a).ship = 0
 terr(a).cannon = 0
 terr(a).men = 0
 terr(a).soldiers = 0
 terr(a).knights = 0
 terr(a).cavalry = 0
 terr(a).sword = 0
 terr(a).shield = 0
 terr(a).spear = 0
 terr(a).bow = 0
END SUB

SUB createchar (a, b)
 IF b THEN player(a).points = player(a).points + 4 ELSE player(a).points = player(a).points + 24
 IF player(a).nam = "Ghengis Khan" THEN player(a).points = player(a).points * 2
 CLS
 DIM stat(3 TO 6)
 row = 3
 COLOR player(a).clr
 LOCATE 2
 PRINT "NAME:     "; player(a).nam
 PRINT "COUNTRY:  "; player(a).con
 PRINT "GENDER:   ";
 IF player(a).gender = "M" THEN PRINT "Male" ELSE PRINT "Female"
 PRINT "PLAYER #:"; a
 IF b THEN
  PRINT "NEW RANK: ";
  IF player(a).gender = "M" THEN
   SELECT CASE player(a).ntitle
    CASE 1: PRINT "Lord"
    CASE 2: PRINT "Baron"
    CASE 3: PRINT "Duke"
    CASE 4: PRINT "King"
    CASE 5: PRINT "Czar"
    CASE 6: PRINT "Emperor"
   END SELECT
  ELSE
   SELECT CASE player(a).ntitle
    CASE 1: PRINT "Lady"
    CASE 2: PRINT "Baroness"
    CASE 3: PRINT "Duchess"
    CASE 4: PRINT "Queen"
    CASE 5: PRINT "Czarina"
    CASE 6: PRINT "Empress"
   END SELECT
  END IF
 END IF
 COLOR player(a).clr
 LOCATE 3, 25: PRINT "Attack:"
 LOCATE 4, 25: PRINT "Defense:"
 LOCATE 5, 25: PRINT "HP:"
 LOCATE 6, 25: PRINT "Tactics:"
 COLOR 15
 LOCATE 3, 23: PRINT ""
 center 13, "Hit  and  to move the cursor"
 center 14, "Hit + and - to distribute points"
 center 15, "Hit Enter when done"
 DO
  center 1, "Remaining points:" + SPACE$(3 - LEN(STR$(player(a).points))) + STR$(player(a).points)
  LOCATE 3, 34: PRINT USING "##"; stat(3) + player(a).attack
  LOCATE 4, 34: PRINT USING "##"; stat(4) + player(a).defense
  LOCATE 5, 34: PRINT USING "##"; stat(5) + player(a).hp
  LOCATE 6, 34: PRINT USING "##"; stat(6) + player(a).tact
  DO: kbd$ = INKEY$: LOOP UNTIL kbd$ <> ""
  SELECT CASE kbd$
   CASE "=", "+"
    IF player(a).points THEN
     player(a).points = player(a).points - 1
     stat(row) = stat(row) + 1
    END IF
   CASE "-", "_"
    IF stat(row) THEN
     player(a).points = player(a).points + 1
     stat(row) = stat(row) - 1
    END IF
   CASE CHR$(0) + "P"
    LOCATE row, 23: PRINT " "
    row = row + 1
    IF row = 7 THEN row = 3
    LOCATE row, 23: PRINT ""
   CASE CHR$(0) + "H"
    LOCATE row, 23: PRINT " "
    row = row - 1
    IF row = 2 THEN row = 6
    LOCATE row, 23: PRINT ""
   CASE CHR$(13)
    IF player(a).points THEN
     center 10, "Not all points are spent"
     kbd$ = query(11, "Exit anyway? (Y/N)")
    ELSE kbd$ = "Y"
    END IF
    IF kbd$ = "Y" THEN EXIT DO
    center 10, SPACE$(25)
    center 11, SPACE$(21)
  END SELECT
 LOOP
 player(a).attack = player(a).attack + stat(3)
 player(a).defense = player(a).defense + stat(4)
 player(a).hp = player(a).hp + stat(5)
 player(a).tact = player(a).tact + stat(6)
 IF player(a).nam = "Smart Boy   " THEN player(a).tact = player(a).tact + stat(6)
 FOR x = 1 TO maxterr
  IF terr(x).own = curplayer THEN
   terr(x).maxhp = terr(x).maxhp + stat(5)
   terr(x).hp = terr(x).hp + stat(5)
  END IF
 NEXT
END SUB

FUNCTION cut$ (x)
 cut$ = LTRIM$(STR$(x))
END FUNCTION

SUB default
 SCREEN 0, , 0, 0
 CLS
 COLOR 7
END SUB

SUB domove (a$)
 LINE (0, 238)-(639, 349), 0, BF
 DIM item(1 TO 4) AS STRING * 6
 item(1) = "Sword"
 item(2) = "Spear"
 item(3) = "Bow"
 item(4) = "Shield"
 LOCATE 18
 SELECT CASE a$
  CASE "A"
   PRINT "From where: ( - Select territory, ESC - abort, Enter - done)"
   a = getterr(1, player(curplayer).clr)
   IF a THEN
    PRINT "To where: ( - Select territory, ESC - abort, Enter - done)"
    b = getterr(2, 1)
    IF b THEN
     IF (adj(b, a) OR adj(a, b)) OR (terr(a).ship > 0 AND terr(b).water) THEN c = 1
     IF c THEN
      battle b, a
      raisehp
     ELSE wrong "Too far away"
     END IF
    ELSE moves = moves + 1
    END IF
   ELSE moves = moves + 1
   END IF
  CASE "B"
   PRINT "Where: ( - Select territory, ESC - abort, Enter - done)"
   a = getterr(1, player(curplayer).clr)
   IF a THEN
    b = choose(1, a)
    SELECT CASE b
     CASE 1
      IF player(curplayer).money >= 100 THEN
       IF terr(a).size >= 3 THEN
        build b, a
       ELSE wrong "Not enough space"
       END IF
      ELSE wrong "Not enough money"
      END IF
     CASE 2
      IF player(curplayer).money >= 150 THEN
       IF terr(a).size >= 4 THEN
        build b, a
       ELSE wrong "Not enough space"
       END IF
      ELSE wrong "Not enough money"
      END IF
     CASE 3
      IF player(curplayer).money >= 150 THEN
       IF terr(a).size >= 3 THEN
        build b, a
       ELSE wrong "Not enough space"
       END IF
      ELSE wrong "Not enough money"
      END IF
     CASE 4
      IF player(curplayer).money >= 100 THEN
       IF terr(a).size >= 2 THEN
        IF terr(a).water = 1 THEN
         build b, a
        ELSE wrong "Must be near water"
        END IF
       ELSE wrong "Not enough space"
       END IF
      ELSE wrong "Not enough money"
      END IF
     CASE 5
      IF player(curplayer).money >= 125 THEN
       IF terr(a).dock > terr(a).ship THEN
        build b, a
       ELSE wrong "Need a dock"
       END IF
      ELSE wrong "Not enough money"
      END IF
     CASE 6
      IF player(curplayer).money >= 75 THEN
       IF terr(a).size >= 1 THEN
        build b, a
       ELSE wrong "Not enough space"
       END IF
      ELSE wrong "Not enough money"
      END IF
     CASE ELSE: moves = moves + 1
    END SELECT
   ELSE moves = moves + 1
   END IF
  CASE "C"
   PRINT "Which territory: ( - Select territory, ESC - abort, Enter - done)"
   a = getterr(1, player(curplayer).clr)
   IF a THEN
    player(curplayer).sword = player(curplayer).sword + terr(a).sword
    player(curplayer).shield = player(curplayer).shield + terr(a).shield
    player(curplayer).spear = player(curplayer).spear + terr(a).spear
    player(curplayer).bow = player(curplayer).bow + terr(a).bow
    clearterr a
    raisehp
    IF player(curplayer).home <> a THEN
     terr(a).size = 12 + 3 * player(terr(a).own).ntitle
     paintland a, 15
     terr(a).own = 0
     player(curplayer).land = player(curplayer).land - 1
    ELSE
     terr(a).size = 22 + 3 * player(terr(a).own).ntitle
     terr(a).attack = player(curplayer).attack
     terr(a).defense = player(curplayer).defense
     terr(a).hp = player(curplayer).hp
     terr(a).maxhp = terr(a).hp
     terr(a).tact = player(curplayer).tact
    END IF
   ELSE moves = moves + 1
   END IF
  CASE "E"
   moves = moves + 1
   PRINT "To where: ( - Select territory, ESC - abort, Enter - done)"
   a = getterr(1, player(curplayer).clr)
   IF a THEN
    PRINT " - Select weapon, Enter - Equip weapon, ESC - done"
    PRINT "Weapon: Sword     Spear     Bow       Shield";
    COLOR 15
    LOCATE 20, 9: PRINT "Sword"
    num = 1
    DO
     COLOR player(curplayer).clr
     LOCATE 21
     PRINT USING "Number:  ###       ##       ##          ##"; player(curplayer).sword; player(curplayer).spear; player(curplayer).bow; player(curplayer).shield
     DO: kbd$ = INKEY$: LOOP UNTIL kbd$ <> ""
     SELECT CASE kbd$
      CASE CHR$(13)
       SELECT CASE num
        CASE 1: IF player(curplayer).sword THEN equip 1, a
        CASE 2: IF player(curplayer).spear THEN equip 2, a
        CASE 3: IF player(curplayer).bow THEN equip 3, a
        CASE 4: IF player(curplayer).shield THEN equip 4, a
       END SELECT
      CASE CHR$(0) + "M"
       COLOR player(curplayer).clr
       LOCATE 20, 10 * num - 1: PRINT item(num)
       num = num + 1
       IF num > 4 THEN num = 1
       COLOR 15
       LOCATE 20, 10 * num - 1: PRINT item(num)
      CASE CHR$(0) + "K"
       COLOR player(curplayer).clr
       LOCATE 20, 10 * num - 1: PRINT item(num)
       num = num - 1
       IF num = 0 THEN num = 4
       COLOR 15
       LOCATE 20, 10 * num - 1: PRINT item(num)
     END SELECT
    LOOP UNTIL kbd$ = CHR$(27)
   END IF
  CASE "H"
   PRINT "Where: ( - Select territory, ESC - abort, Enter - done)"
   a = getterr(1, player(curplayer).clr)
   IF a THEN
    IF terr(a).men + terr(a).soldiers + terr(a).knights + terr(a).cavalry < (terr(a).fort + terr(a).castle) * 20 THEN
     b = choose(2, a)
     IF b THEN
      SELECT CASE b
       CASE 1
        IF player(curplayer).money >= 50 THEN
         hire b, a
         raisehp
        ELSE wrong "Not enough money"
        END IF
       CASE 2
        IF player(curplayer).money >= 75 THEN
         hire b, a
         raisehp
        ELSE wrong "Not enough money"
        END IF
       CASE 3
        IF player(curplayer).money >= 100 THEN
         hire b, a
         raisehp
        ELSE wrong "Not enough money"
        END IF
       CASE 4
        IF player(curplayer).money >= 150 THEN
         hire b, a
         raisehp
        ELSE wrong "Not enough money"
        END IF
      END SELECT
     ELSE moves = moves + 1
     END IF
    ELSE wrong "Need a fort or castle to hold troops"
    END IF
   ELSE moves = moves + 1
   END IF
  CASE "M"
   FOR a = 1 TO maxterr
    IF terr(a).own = 0 THEN a = 0: EXIT FOR
   NEXT
   IF a = 0 THEN
    c = 0
    PRINT "To where: ( - Select territory, ESC - abort, Enter - done)"
    a = getterr(0, 1)
    IF a THEN
     FOR b = 1 TO maxterr
      IF (terr(b).own = curplayer) THEN
       IF ((adj(b, a) OR adj(a, b))) THEN c = 1
       IF terr(b).ship > 0 AND terr(a).water THEN c = 1
      END IF
     NEXT
     IF c OR player(curplayer).nam = "Smart Boy   " THEN
      terr(a).size = 12 + 3 * player(curplayer).ntitle
      paintland a, player(curplayer).clr
      terr(a).own = curplayer
      terr(a).maxhp = player(curplayer).hp
      terr(a).hp = terr(a).maxhp
      player(curplayer).land = player(curplayer).land + 1
      terr(a).own = curplayer
      raisehp
     ELSE wrong "Too far away"
     END IF
    ELSE moves = moves + 1
    END IF
   ELSE wrong "No available territories"
   END IF
  CASE "N"
   moves = moves + 1
   IF numplayers < 6 THEN
    a = 0
    FOR x = 1 TO maxterr
     IF terr(x).own = 0 THEN a = 1
    NEXT
    IF a THEN
     IF query(18, "Are you sure? (Y/N)") = "Y" THEN
      numplayers = numplayers + 1
      IF comp THEN
       player(numplayers + 1) = player(numplayers)
       player(numplayers).attack = 0
       player(numplayers).defense = 0
       player(numplayers).hp = 0
       player(numplayers).tact = 0
       FOR x = 1 TO maxterr
        IF terr(x).own = numplayers THEN terr(x).own = numplayers + 1
       NEXT
      END IF
      DO
       done = 1
       LINE (0, 238)-(639, 349), 0, BF
       FOR x = 2 TO 14
        COLOR x
        LOCATE 18, (x - 2) * 4 + 1
        PRINT x
       NEXT
       FOR x = 1 TO numplayers + comp
        IF x <> numplayers THEN LOCATE 18, (player(x).clr - 2) * 4 + 2: PRINT "  "
       NEXT
       COLOR 15
       player(numplayers).clr = getint(19, 1, "Enter player #" + cut$(numplayers) + "'s color: ", 2, 14)
       IF player(numplayers).clr = 0 THEN done = 1
       FOR x = 1 TO numplayers + comp
        IF player(numplayers).clr = player(x).clr AND numplayers <> x THEN done = 0
       NEXT
      LOOP UNTIL done
      COLOR player(numplayers).clr
      DO
       done = 1
       LINE (0, 238)-(639, 349), 0, BF
       player(numplayers).nam = getstring(18, 1, "Enter player #" + cut$(numplayers) + "'s name: ")
       FOR x = 1 TO numplayers + comp
        IF player(numplayers).nam = player(x).nam AND numplayers <> x THEN done = 0
       NEXT
      LOOP UNTIL done
      player(numplayers).con = getstring(18, 1, "Enter player #" + cut$(numplayers) + "'s country: ")
      LINE (0, 238)-(639, 349), 0, BF
      LOCATE 18: PRINT "Enter player #"; cut$(numplayers); "'s gender (M/F): _"
      DO
       kbd$ = UCASE$(INKEY$)
      LOOP UNTIL kbd$ = "M" OR kbd$ = "F"
      player(numplayers).gender = kbd$
      SCREEN , , 1, 1
      createchar numplayers, 0
      SCREEN , , 0, 0
      LINE (0, 238)-(639, 349), 0, BF
      curplayerbak = curplayer
      curplayer = 0
      gethome numplayers
      curplayer = curplayerbak
      player(numplayers).sword = 5
      player(numplayers).spear = 3
      player(numplayers).bow = 2
      player(numplayers).shield = 2
      IF player(numplayers).nam = "Weapon Lord " THEN
       player(numplayers).sword = 100
       player(numplayers).shield = 40
       player(numplayers).spear = 60
       player(numplayers).bow = 40
      END IF
      player(numplayers).ntitle = 1
      player(numplayers).nctitle = 1
      player(numplayers).people = 0
      player(numplayers).land = 1
     END IF
    ELSE wrong "No room"
    END IF
   ELSE wrong "Too many players"
   END IF
  CASE "Q"
   moves = moves + 1
   IF query(18, "Are you sure? (Y/N)") = "Y" THEN endgame
  CASE "R": raid
  CASE "S": savegame
  CASE "V"
   PRINT "Which territory: ( - Select territory, Enter - done)"
   moves = moves + 1
   DO
    a = a + 1
   LOOP UNTIL terr(a).own
   paintland a, 1
   VIEW PRINT 19 TO 25
   DO
    IF b$ = "" AND b = 0 THEN
     CLS 2
     LOCATE 19
     PRINT "This territory is ";
     IF player(terr(a).own).home = a THEN
      PRINT "the home of "; RTRIM$(player(terr(a).own).nam); "."
     ELSE
      PRINT "owned by "; RTRIM$(player(terr(a).own).nam); "."
     END IF
     PRINT USING "Forts:    ###      Castles:  ###     Towns:     ###     Docks:   ###"; terr(a).fort; terr(a).castle; terr(a).town; terr(a).dock
     PRINT USING "Ships:    ###      Cannons:  ###     Peasants: ####     Men:     ###"; terr(a).ship; terr(a).cannon; terr(a).peasant; terr(a).men
     PRINT USING "Soldiers: ###      Knights:  ###     Cavalry:   ###     Swords:  ###"; terr(a).soldiers; terr(a).knights; terr(a).cavalry; terr(a).sword
     PRINT USING "Spears:   ###      Bows:     ###     Shields:   ###     Attack:  ###"; terr(a).spear; terr(a).bow; terr(a).shield; terr(a).attack
     PRINT USING "Defense:  ###      Max HP:   ###     Cur. HP:   ###     Tactics: ###"; terr(a).defense; terr(a).maxhp; terr(a).hp; terr(a).tact
     b = 1
    END IF
    WHILE INKEY$ <> "": WEND
    a! = TIMER
    DO: b$ = INKEY$: LOOP UNTIL TIMER - a! > .3 OR b$ <> ""
    SELECT CASE b$
     CASE CHR$(0) + "P", CHR$(0) + "M"
      paintland a, player(terr(a).own).clr
      DO
       a = a + 1
       IF a = maxterr + 1 THEN a = 1
      LOOP UNTIL terr(a).own
      paintland a, 1
      b = 0
     CASE CHR$(0) + "H", CHR$(0) + "K"
      paintland a, player(terr(a).own).clr
      DO
       a = a - 1
       IF a = 0 THEN a = maxterr
      LOOP UNTIL terr(a).own
      paintland a, 1
      b = 0
    END SELECT
   LOOP UNTIL b$ = CHR$(13) OR b$ = CHR$(27)
   paintland a, player(terr(a).own).clr
   VIEW PRINT
  CASE "U"
   IF query(18, "Are you sure? (Y/N)") = "Y" THEN
    clearplayer curplayer
    curplayer = curplayer - 1
    IF numplayers + comp = 1 THEN
     curplayer = 1
     showend
    END IF
   ELSE moves = moves + 1
   END IF
  CASE "W"
   FOR x = moves TO 1 STEP -1
    raisehp
   NEXT
   moves = 1
 END SELECT
 IF save = 0 THEN changestats curplayer
END SUB

SUB drawscreen
 SCREEN 9, , 1, 1
 center 11, "Drawing Map"
 center 12, "Please wait. . . ."
 IF planet = 1 THEN
  SCREEN 9, , 0, 1
  COLOR 0
  LINE (0, 0)-(399, 237), 15, BF
  LINE (27, 16)-(25, 20): LINE (25, 20)-(22, 48): LINE (22, 48)-(35, 80)
  LINE (35, 80)-(45, 84): LINE (45, 84)-(52, 82)
  LINE (52, 82)-(90, 64): LINE (90, 64)-(120, 64)
  LINE (120, 64)-(130, 60): LINE (130, 60)-(150, 12)
  LINE (150, 12)-(27, 16): LINE (25, 20)-(55, 28): LINE (55, 28)-(75, 20)
  LINE (75, 20)-(75, 14): LINE (55, 28)-(70, 40): LINE (63, 34)-(35, 42)
  LINE (35, 42)-(24, 42): LINE (70, 40)-(70, 56): LINE (70, 56)-(24, 52)
  LINE (70, 48)-(90, 64): LINE (50, 54)-(45, 82): LINE (75, 20)-(95, 32)
  LINE (95, 32)-(70, 40): LINE (90, 28)-(120, 14): LINE (108, 20)-(130, 60)
  LINE (118, 40)-(100, 64): LINE (15, 229)-(12, 218)
  LINE (12, 218)-(16, 120): LINE (16, 120)-(30, 110)
  LINE (30, 110)-(37, 118): LINE (37, 118)-(37, 152)
  LINE (37, 152)-(51, 184): LINE (51, 184)-(100, 212)
  LINE (100, 212)-(110, 224): LINE (110, 224)-(60, 232)
  LINE (60, 232)-(15, 229): LINE (16, 136)-(37, 132)
  LINE (16, 160)-(46, 174): LINE (70, 196)-(40, 230)
  LINE (55, 212)-(30, 200): LINE (30, 200)-(35, 170)
  LINE (370, 56)-(367, 80): LINE (367, 80)-(357, 88)
  LINE (357, 88)-(340, 76): LINE (340, 76)-(370, 56)
  CIRCLE (330, 200), 31: LINE (308, 185)-(320, 192)
  LINE (320, 192)-(340, 192): LINE (340, 192)-(350, 183)
  LINE (340, 192)-(345, 208): LINE (345, 208)-(360, 204)
  LINE (345, 208)-(320, 208): LINE (320, 208)-(320, 192)
  LINE (320, 204)-(310, 216): LINE (370, 160)-(360, 120)
  LINE (360, 120)-(347, 96): LINE (347, 96)-(320, 72)
  LINE (320, 72)-(350, 56): LINE (350, 56)-(340, 40)
  LINE (340, 40)-(300, 12): LINE (300, 12)-(220, 14)
  LINE (220, 14)-(170, 18): LINE (170, 18)-(155, 56)
  LINE (155, 56)-(130, 72): LINE (130, 72)-(100, 72)
  LINE (100, 72)-(50, 96): LINE (50, 96)-(60, 176)
  LINE (60, 176)-(120, 208): LINE (120, 208)-(270, 220)
  LINE (270, 220)-(267, 184): LINE (267, 184)-(300, 168)
  LINE (300, 168)-(370, 160): LINE (340, 162)-(363, 136)
  LINE (352, 149)-(300, 120): LINE (300, 120)-(360, 120)
  LINE (330, 120)-(347, 96): LINE (330, 137)-(310, 166)
  LINE (320, 152)-(270, 160): LINE (270, 160)-(267, 184)
  LINE (289, 156)-(260, 128): LINE (260, 128)-(314, 128)
  LINE (290, 128)-(260, 96): LINE (260, 96)-(290, 80)
  LINE (290, 80)-(305, 100): LINE (305, 100)-(275, 112)
  LINE (305, 100)-(335, 112): LINE (296, 88)-(329, 80)
  LINE (310, 83)-(290, 68): LINE (290, 68)-(334, 36)
  LINE (310, 52)-(270, 12): LINE (275, 88)-(250, 64)
  LINE (250, 64)-(290, 32): LINE (278, 20)-(240, 40)
  LINE (240, 40)-(215, 14): LINE (229, 28)-(200, 52)
  LINE (200, 52)-(250, 64): LINE (210, 44)-(160, 44)
  LINE (220, 57)-(190, 72): LINE (190, 72)-(155, 56)
  LINE (190, 72)-(265, 80): LINE (227, 76)-(220, 112)
  LINE (220, 112)-(268, 104): LINE (240, 108)-(240, 140)
  LINE (240, 140)-(273, 140): LINE (240, 140)-(268, 172)
  LINE (173, 66)-(165, 96): LINE (165, 96)-(222, 104)
  LINE (165, 96)-(120, 72): LINE (140, 84)-(52, 104)
  LINE (100, 94)-(120, 120): LINE (120, 120)-(90, 116)
  LINE (90, 116)-(55, 128): LINE (120, 120)-(200, 100)
  LINE (160, 110)-(240, 128): LINE (200, 119)-(180, 152)
  LINE (180, 152)-(256, 160): LINE (180, 152)-(140, 116)
  LINE (160, 134)-(115, 148): LINE (115, 148)-(115, 120)
  LINE (115, 148)-(170, 172): LINE (170, 172)-(220, 157)
  LINE (115, 132)-(57, 144): LINE (85, 138)-(100, 197)
  LINE (95, 170)-(150, 164): LINE (135, 166)-(110, 202)
  LINE (122, 185)-(200, 214): LINE (170, 172)-(170, 202)
  LINE (170, 184)-(220, 184): LINE (220, 184)-(240, 159)
  LINE (220, 184)-(246, 218)
 ELSE
  SCREEN , , 1, 1
  OPEN "castmap." + cut$(planet - 1) FOR BINARY AS #1
  DIM a&(11900)
  SEEK #1, 6
  FOR b = 0 TO 11900
   GET #1, , a&(b)
   IF b MOD 952 = 0 THEN center 13, STR$(b / 119) + "% completed "
  NEXT
  SCREEN , , 0, 1
  PUT (0, 0), a&, PSET
  CLOSE #1
 END IF
 PAINT (0, 0), 1, 0
END SUB

SUB endgame
 default
 PRINT "Thank you for playing Castles III."
 PRINT "Program written in MS-DOS QBasic by Chad Austin"
 PRINT
 END
END SUB

SUB equip (x, y)
 SELECT CASE x
  CASE 1
   terr(y).attack = terr(y).attack + 1
   player(terr(y).own).sword = player(terr(y).own).sword - 1
   terr(y).sword = terr(y).sword + 1
  CASE 2
   terr(y).attack = terr(y).attack + 1
   terr(y).defense = terr(y).defense + 1
   terr(y).tact = terr(y).tact + 1
   player(terr(y).own).spear = player(terr(y).own).spear - 1
   terr(y).spear = terr(y).spear + 1
  CASE 3
   terr(y).tact = terr(y).tact + 2
   player(terr(y).own).bow = player(terr(y).own).bow - 1
   terr(y).bow = terr(y).bow + 1
  CASE 4
   terr(y).defense = terr(y).defense + 2
   player(terr(y).own).shield = player(terr(y).own).shield - 1
   terr(y).shield = terr(y).shield + 1
 END SELECT
END SUB

SUB gethome (gh)
 SCREEN , , 0, 0
 COLOR 15
 DIM y(1 TO maxterr)
 IF comp AND gh = numplayers + 1 THEN
  a = numplayers + 1
  DO
   b = 0
   FOR x = 1 TO maxterr
    IF terr(x).water = 0 OR Z THEN
     b = b + 1
     y(b) = x
     c = 1
    END IF
   NEXT
   IF b = 0 THEN Z = 1
  LOOP UNTIL c
  player(a).home = y(CINT(RND * (b - 1)) + 1)
  player(a).money = 1000
  terr(player(a).home).attack = player(a).attack
  terr(player(a).home).defense = player(a).defense
  terr(player(a).home).tact = player(a).tact
  terr(player(a).home).maxhp = player(a).hp
  terr(player(a).home).hp = player(a).hp
  terr(player(a).home).own = a
  terr(player(a).home).size = 25
  paintland player(a).home, player(a).clr
 ELSE
  IF ranhome THEN
   b = 0
   FOR x = 1 TO maxterr
    IF terr(x).own = 0 THEN
     b = b + 1
     y(b) = x
    END IF
   NEXT
   player(gh).home = y(CINT(RND * (b - 1)) + 1)
   paintland (player(gh).home), (player(gh).clr)
  ELSE
   COLOR 15
   center 19, "Use arrow keys to select a territory"
   center 20, "Hit Enter when done"
   COLOR player(gh).clr
   center 18, SPACE$(10) + RTRIM$(player(gh).nam) + ", select your home territory          "
   player(gh).home = getterr(0, player(gh).clr)
  END IF
  player(gh).money = 1000
  IF player(gh).nam = "Money Man   " THEN player(gh).money = 2000
  terr(player(gh).home).attack = player(gh).attack
  terr(player(gh).home).defense = player(gh).defense
  terr(player(gh).home).tact = player(gh).tact
  terr(player(gh).home).maxhp = player(gh).hp
  terr(player(gh).home).hp = player(gh).hp
  terr(player(gh).home).own = gh
  terr(player(gh).home).size = 25
  paintland player(gh).home, player(gh).clr
 END IF
END SUB

SUB getinputs
 VIEW PRINT 1 TO 25
 DO
  CLS
  COLOR 15
  IF query(1, "Are home territories random? (Y/N)") = "Y" THEN ranhome = 1
  IF query(3, "Is the map random? (Y/N)") = "Y" THEN ranplanet = 1
  FOR a = 2 TO 14
   COLOR a
   LOCATE 5, a * 5 - 2: PRINT a
  NEXT
  COLOR 15
  center 7, "How many players? (1-6)"
  DO
   numplayers = VAL(INKEY$)
  LOOP UNTIL numplayers >= 1 AND numplayers <= 6
  LOCATE 7, 51: PRINT numplayers
  FOR a = 1 TO numplayers
   player(a).clr = getint(a + 7, 27, "Player" + STR$(a) + "'s color (2-14): ", 2, 14)
   b = 0
   FOR c = 1 TO a
    IF player(a).clr = player(c).clr AND a <> c THEN b = 1
   NEXT
   a = a - b
   IF b = 0 THEN LOCATE 5, player(a).clr * 5 - 1: PRINT "  "
  NEXT
  FOR a = 1 TO numplayers
   COLOR player(a).clr
   center a + 8 + numplayers, "Player" + STR$(a) + "'s color"
  NEXT
  COLOR 15
  IF numplayers > 1 THEN
   IF query(numplayers * 2 + 10, "Play versus computer? (Y/N)") = "Y" THEN comp = 1
  ELSE comp = 1
  END IF
 LOOP UNTIL query(numplayers * 2 + 12 - (numplayers = 1) * -2, "Okay with this? (Y/N)") = "Y"
 CLS
 FOR a = 1 TO numplayers
  COLOR player(a).clr
  LOCATE a * 4 + 9 - numplayers * 2, 10: PRINT "Player"; a
  DO
   DO
    player(a).nam = getstring(a * 4 + 9 - numplayers * 2, 28, "Name:    ")
   LOOP UNTIL RTRIM$(player(a).nam) <> ""
   b = 0
   FOR c = 1 TO a
    IF player(a).nam = player(c).nam AND a <> c THEN b = 1
   NEXT
  LOOP UNTIL b = 0
  DO
   player(a).con = getstring(a * 4 + 10 - numplayers * 2, 28, "Country: ")
  LOOP UNTIL RTRIM$(player(a).con) <> ""
  LOCATE a * 4 + 11 - numplayers * 2, 28: PRINT "Gender:  _ (M/F)"
  WHILE player(a).gender <> "M" AND player(a).gender <> "F"
   player(a).gender = UCASE$(INKEY$)
  WEND
  LOCATE a * 4 + 11 - numplayers * 2, 37: PRINT player(a).gender
 NEXT
 IF comp THEN
  player(numplayers + 1).nam = "The Computer"
  player(numplayers + 1).con = "Byteville"
  player(numplayers + 1).gender = "M"
  FOR x = 8 TO 14
   a = 1
   FOR y = 1 TO numplayers
    IF x = player(y).clr THEN a = 0
   NEXT
   IF a THEN player(numplayers + 1).clr = x
  NEXT
 END IF
END SUB

FUNCTION getint (x, y, a$, a, b)
 LOCATE x, y: PRINT a$; "_  "
 DO
  DO: b$ = INKEY$: LOOP UNTIL b$ <> ""
  SELECT CASE b$
   CASE "0": IF LEN(c$) THEN c$ = c$ + "0": IF VAL(c$) > b THEN c$ = cut$(b)
   CASE "1" TO "9": c$ = c$ + b$: IF VAL(c$) > b THEN c$ = cut$(b)
   CASE CHR$(8): IF LEN(c$) THEN c$ = LEFT$(c$, LEN(c$) - 1)
   CASE CHR$(13)
    e = VAL(c$)
    IF e >= a THEN
     LOCATE x, y + LEN(a$) + LEN(c$): PRINT " "
     EXIT DO
    END IF
    c$ = ""
   CASE CHR$(27)
    getint = 0
    EXIT FUNCTION
  END SELECT
  LOCATE x, y + LEN(a$): PRINT c$ + "_ "
 LOOP
 getint = e
END FUNCTION

SUB getkey (a$)
 LINE (0, 238)-(639, 349), 0, BF
 COLOR player(curplayer).clr
 LOCATE 18: PRINT RTRIM$(player(curplayer).nam); " of "; RTRIM$(player(curplayer).con); ", what is your command?"
 COLOR 15
 PRINT "A      B     C     E     H    M    N          Q    R    S     U        V    W"
 COLOR player(curplayer).clr
 LOCATE 19, 2: PRINT "ttack-"
 LOCATE 19, 9: PRINT "uild-"
 LOCATE 19, 15: PRINT "lear-"
 LOCATE 19, 21: PRINT "quip-"
 LOCATE 19, 27: PRINT "ire-"
 LOCATE 19, 32: PRINT "ove-"
 LOCATE 19, 37: PRINT "ew player-"
 LOCATE 19, 48: PRINT "uit-"
 LOCATE 19, 53: PRINT "aid-"
 LOCATE 19, 58: PRINT "ave-s"
 LOCATE 19, 64: PRINT "rrender-"
 LOCATE 19, 73: PRINT "iew-"
 LOCATE 19, 78: PRINT "ait"
 DO
  a$ = UCASE$(INKEY$)
 LOOP UNTIL a$ = "A" OR a$ = "R" OR a$ = "B" OR a$ = "H" OR a$ = "C" OR a$ = "E" OR a$ = "M" OR a$ = "S" OR a$ = "Q" OR a$ = "V" OR a$ = "W" OR a$ = "U" OR a$ = "N"
END SUB

FUNCTION getstring$ (a, b, a$)
 LOCATE a, b: PRINT a$ + "_            "
 DO
  DO: b$ = INKEY$: LOOP UNTIL b$ <> ""
  SELECT CASE b$
   CASE " " TO "}": IF LEN(c$) < 12 THEN c$ = c$ + b$
   CASE CHR$(8), CHR$(0) + "K": IF LEN(c$) > 0 THEN c$ = LEFT$(c$, LEN(c$) - 1)
   CASE CHR$(13)
    LOCATE a, b + LEN(a$) + LEN(c$): PRINT " "
    EXIT DO
  END SELECT
  LOCATE a, b + LEN(a$): PRINT c$ + "_ "
 LOOP
 getstring$ = c$
END FUNCTION

FUNCTION getterr (a, b)
 SELECT CASE a
  CASE 0
   DO
    c = c + 1
   LOOP WHILE terr(c).own
   paintland c, b
   DO
    kbd$ = INKEY$
    SELECT CASE kbd$
     CASE CHR$(0) + "P", CHR$(0) + "M"
      paintland c, 15
      DO
       c = c + 1
       IF c = maxterr + 1 THEN c = 1
      LOOP WHILE terr(c).own
      paintland c, b
     CASE CHR$(0) + "H", CHR$(0) + "K"
      paintland c, 15
      DO
       c = c - 1
       IF c = 0 THEN c = maxterr
      LOOP WHILE terr(c).own
      paintland c, b
    END SELECT
   LOOP UNTIL kbd$ = CHR$(13) OR kbd$ = CHR$(27) AND curplayer
   paintland c, 15
   IF kbd$ = CHR$(27) THEN c = 0
  CASE 1
   DO
    c = c + 1
   LOOP UNTIL terr(c).own = curplayer
   paintland c, 1
   DO
    kbd$ = INKEY$
    SELECT CASE kbd$
     CASE CHR$(0) + "P", CHR$(0) + "M"
      paintland c, b
      DO
       c = c + 1
       IF c = maxterr + 1 THEN c = 1
      LOOP UNTIL terr(c).own = curplayer
      paintland c, 1
     CASE CHR$(0) + "H", CHR$(0) + "K"
      paintland c, b
      DO
       c = c - 1
       IF c = 0 THEN c = maxterr
      LOOP UNTIL terr(c).own = curplayer
      paintland c, 1
    END SELECT
   LOOP UNTIL kbd$ = CHR$(13) OR kbd$ = CHR$(27)
   paintland c, b
   IF kbd$ = CHR$(27) THEN c = 0
  CASE 2
   DO
    c = c + 1
   LOOP UNTIL terr(c).own <> curplayer AND terr(c).own
   paintland c, b
   DO
    kbd$ = INKEY$
    SELECT CASE kbd$
     CASE CHR$(0) + "P", CHR$(0) + "M"
      paintland c, player(terr(c).own).clr
      DO
       c = c + 1
       IF c = maxterr + 1 THEN c = 1
      LOOP UNTIL terr(c).own <> curplayer AND terr(c).own
      paintland c, b
     CASE CHR$(0) + "H", CHR$(0) + "K"
      paintland c, player(terr(c).own).clr
      DO
       c = c - 1
       IF c = 0 THEN c = maxterr
      LOOP UNTIL terr(c).own <> curplayer AND terr(c).own
      paintland c, b
    END SELECT
   LOOP UNTIL kbd$ = CHR$(13) OR kbd$ = CHR$(27) AND curplayer
   paintland c, player(terr(c).own).clr
   IF kbd$ = CHR$(27) THEN c = 0
 END SELECT
 getterr = c
END FUNCTION

SUB hire (x, a)
 SELECT CASE x
  CASE 1
   player(terr(a).own).money = player(terr(a).own).money - 50
   terr(a).men = terr(a).men + 10
   terr(a).attack = terr(a).attack + 3
   terr(a).defense = terr(a).defense + 2
   terr(a).maxhp = terr(a).maxhp + 3
   terr(a).hp = terr(a).hp + 3
   terr(a).tact = terr(a).tact + 3
   player(terr(a).own).people = player(terr(a).own).people + 10
  CASE 2
   player(terr(a).own).money = player(terr(a).own).money - 75
   terr(a).soldiers = terr(a).soldiers + 10
   terr(a).attack = terr(a).attack + 3
   terr(a).defense = terr(a).defense + 2
   terr(a).maxhp = terr(a).maxhp + 4
   terr(a).hp = terr(a).hp + 4
   terr(a).tact = terr(a).tact + 4
   player(terr(a).own).people = player(terr(a).own).people + 10
  CASE 3
   player(terr(a).own).money = player(terr(a).own).money - 100
   terr(a).knights = terr(a).knights + 10
   terr(a).attack = terr(a).attack + 6
   terr(a).defense = terr(a).defense + 5
   terr(a).maxhp = terr(a).maxhp + 5
   terr(a).hp = terr(a).hp + 5
   terr(a).tact = terr(a).tact + 3
   player(terr(a).own).people = player(terr(a).own).people + 10
  CASE 4
   terr(a).cavalry = terr(a).cavalry + 10
   player(terr(a).own).money = player(terr(a).own).money - 150
   terr(a).attack = terr(a).attack + 8
   terr(a).defense = terr(a).defense + 7
   terr(a).maxhp = terr(a).maxhp + 6
   terr(a).hp = terr(a).hp + 6
   terr(a).tact = terr(a).tact + 5
   player(terr(a).own).people = player(terr(a).own).people + 10
 END SELECT
 raisehp
END SUB

SUB intro
 LOCATE , , 0
 COLOR 9
 center 5, "Written by: Chad Austin"
 COLOR 10
 center 8, "    Castles is a strategy game in which two through six players"
 center 9, "attempt to take over the world by moving to new territories and"
 center 10, "building on their land.  When a player's home territory is     "
 center 11, "attacked and destroyed by another player, that player is dead. "
 center 12, "When only one player is alive, the game is over.               "
 COLOR 15
 center 3, "CASTLES III"
 center 22, "Hit any key to continue"
 WHILE INKEY$ <> "": WEND
 WHILE INKEY$ = "": WEND
END SUB

SUB movecomp
 DIM tot(maxterr - 1)
 DIM fromt(maxterr - 1)
 LINE (0, 238)-(639, 349), 0, BF
 IF attfact = 0 THEN attfact = 1.5
 LINE (400, 0)-(639, 237), 0, BF
 COLOR player(numplayers + comp).clr
 VIEW PRINT 18 TO 24
 LOCATE 18: PRINT "The computer is moving."
 curplayer = numplayers + comp
 oldcrs = 19
 FOR moves = CINT((player(numplayers + comp).tact + 1) / 4 * RND + 2) TO 1 STEP -1
  curplayer = numplayers + comp
  VIEW PRINT
  printstats
  VIEW PRINT 18 TO 24
  LOCATE oldcrs
  a = 0
  movprf = 1
  SELECT CASE player(numplayers + comp).money
   CASE IS > 149: a = 5
   CASE IS > 124: a = 4
   CASE IS > 99: a = 3
   CASE IS > 74: a = 2
   CASE IS > 49: a = 1
  END SELECT
  IF a THEN
   FOR y = 1 TO maxterr
    IF terr(y).own = numplayers + comp THEN
     IF (terr(y).fort + terr(y).castle) * 20 > terr(y).men + terr(y).knights + terr(y).soldiers + terr(y).cavalry THEN
      PRINT "The computer hired ";
      SELECT CASE a
       CASE 5: hire 4, y: PRINT "cavalry."
       CASE 4, 3: hire 3, y: PRINT "knights."
       CASE 2: hire 2, y: PRINT "soldiers."
       CASE 1: hire 1, y: PRINT "men."
      END SELECT
      movprf = 0
      raisehp
      EXIT FOR
     END IF
    END IF
   NEXT
  END IF
  IF movprf AND a > 3 THEN
   FOR x = 1 TO maxterr
    IF terr(x).own = numplayers + comp THEN
     IF terr(x).ship < terr(x).dock THEN
      build 5, x
      PRINT "The computer built a ship."
      movprf = 0
      raisehp
      EXIT FOR
     END IF
    END IF
   NEXT
  END IF
  IF movprf THEN
   cnt = 0
   FOR x = 1 TO maxterr
    FOR y = 1 TO maxterr
     IF (adj(x, y) OR adj(y, x) OR (terr(y).water AND terr(x).ship)) AND terr(x).own = numplayers + comp AND terr(y).own <> numplayers + comp AND terr(y).own <> 0 THEN
      IF terr(x).attack + terr(x).tact > 4 THEN
       IF terr(x).attack + terr(x).defense + terr(x).hp + terr(x).tact > (terr(y).attack + terr(y).defense + terr(y).hp + terr(y).tact) * attfact THEN
        tot(cnt) = y
        fromt(cnt) = x
        cnt = cnt + 1
       END IF
      END IF
     END IF
    NEXT
   NEXT
   IF cnt THEN
    PRINT "The computer attacks."
    PRINT "Press any key to continue"
    WHILE INKEY$ <> "": WEND
    WHILE INKEY$ = "": WEND
    cnt = INT(RND * cnt)
    LINE (0, 238)-(639, 349), 0, BF
    COLOR player(numplayers + comp).clr
    LOCATE 18: PRINT "The computer attacks."
    IF player(numplayers + comp).sword THEN equip 1, fromt(cnt)
    IF player(numplayers + comp).spear THEN equip 2, fromt(cnt)
    IF player(numplayers + comp).bow THEN equip 3, fromt(cnt)
    IF player(numplayers + comp).shield THEN equip 4, fromt(cnt)
    battle tot(cnt), fromt(cnt)
    COLOR player(numplayers + comp).clr
    LINE (0, 238)-(639, 349), 0, BF
    VIEW PRINT 18 TO 24
    LOCATE 18
    PRINT "The computer is moving."
    raisehp
    movprf = 0
    attfact = 1.5
   END IF
  END IF
  cnt = 0
  IF movprf AND a - 1 > 0 THEN
   attfact = attfact - .125
   FOR y = 1 TO maxterr
    IF terr(y).own = numplayers + comp THEN
     IF terr(y).size THEN
      tot(cnt) = y
      cnt = cnt + 1
     END IF
    END IF
   NEXT
  END IF
  IF cnt THEN
   movprf = 0
   curplayer = 0
   y = tot(RND * (cnt - 1))
   SELECT CASE terr(y).size
    CASE 1: build 6, y
    CASE 2
     SELECT CASE a - 1
      CASE IS > 1: IF terr(y).water THEN build 4, y ELSE build 6, y
      CASE ELSE: build 6, y
     END SELECT
    CASE 3
     SELECT CASE a - 1
      CASE IS > 2
       SELECT CASE CINT(RND * 2)
        CASE 0: build 1, y
        CASE 1: IF terr(y).water THEN build 4, y ELSE build 1, y
        CASE 2: build 3, y
       END SELECT
      CASE IS > 1: IF terr(y).water THEN build CINT(RND * 3) + 1, y ELSE build CINT(RND * 2) + 1, y
      CASE ELSE: build 6, y
     END SELECT
    CASE IS > 3
     SELECT CASE a - 1
      CASE 1: build 6, y
      CASE 2: IF terr(y).water THEN build 4, y ELSE build 1, y
      CASE 3
       SELECT CASE CINT(RND)
        CASE 0: IF terr(y).water THEN build 4, y ELSE build 1, y
        CASE 1: build 1, y
       END SELECT
      CASE 4: IF terr(y).water THEN build CINT(RND * 3) + 1, y ELSE build CINT(RND * 2) + 1, y
     END SELECT
   END SELECT
  END IF
  cnt = 0
  IF movprf THEN
   FOR x = 1 TO maxterr
    FOR y = 1 TO maxterr
     IF terr(x).own = numplayers + comp AND terr(y).own = 0 THEN
      IF adj(x, y) OR adj(y, x) OR (terr(y).water AND terr(x).ship) THEN
       tot(cnt) = y
       cnt = cnt + 1
      END IF
     END IF
    NEXT
   NEXT
  END IF
  IF cnt THEN
   PRINT "The computer moved."
   cnt = INT(RND * cnt)
   terr(tot(cnt)).own = numplayers + comp
   terr(tot(cnt)).size = 12 + 3 * player(numplayers + comp).ntitle
   paintland tot(cnt), player(numplayers + comp).clr
   terr(tot(cnt)).maxhp = player(numplayers + comp).hp
   terr(tot(cnt)).hp = terr(tot(cnt)).maxhp
   player(numplayers + comp).land = player(numplayers + comp).land + 1
   terr(tot(cnt)).own = curplayer
   raisehp
   movprf = 0
  END IF
  IF movprf THEN
   cnt = 0
   FOR x = 1 TO maxterr
    IF terr(x).own = numplayers + 1 THEN
     tot(cnt) = x
     cnt = cnt + 1
    END IF
   NEXT
   cnt = INT(RND * cnt)
   clearterr cnt
   PRINT "The computer cleared a territory."
   attfact = attfact - .25
   raisehp
  END IF
  changestats numplayers + comp
  oldcrs = CSRLIN
  IF oldcrs < 19 THEN oldcrs = 19
 NEXT
 PRINT "Press any key to continue"
 WHILE INKEY$ <> "": WEND
 WHILE INKEY$ = "": WEND
END SUB

SUB paintland (a, b)
 IF planet = 1 THEN
  SELECT CASE a
   CASE 1: PAINT (30, 24), b, 0
   CASE 2: PAINT (40, 16), b, 0
   CASE 3: PAINT (80, 16), b, 0
   CASE 4: PAINT (120, 16), b, 0
   CASE 5: PAINT (110, 56), b, 0
   CASE 6: PAINT (100, 40), b, 0
   CASE 7: PAINT (69, 64), b, 0
   CASE 8: PAINT (45, 64), b, 0
   CASE 9: PAINT (45, 48), b, 0
   CASE 10: PAINT (61, 32), b, 0
   CASE 11: PAINT (30, 120), b, 0
   CASE 12: PAINT (30, 144), b, 0
   CASE 13: PAINT (30, 192), b, 0
   CASE 14: PAINT (60, 192), b, 0
   CASE 15: PAINT (90, 216), b, 0
   CASE 16: PAINT (300, 200), b, 0
   CASE 17: PAINT (340, 216), b, 0
   CASE 18: PAINT (340, 196), b, 0
   CASE 19: PAINT (345, 196), b, 0
   CASE 20: PAINT (317, 184), b, 0
   CASE 21: PAINT (350, 80), b, 0
   CASE 22: PAINT (200, 40), b, 0
   CASE 23: PAINT (250, 24), b, 0
   CASE 24: PAINT (290, 24), b, 0
   CASE 25: PAINT (200, 64), b, 0
   CASE 26: PAINT (250, 60), b, 0
   CASE 27: PAINT (280, 64), b, 0
   CASE 28: PAINT (300, 64), b, 0
   CASE 29: PAINT (250, 74), b, 0
   CASE 30: PAINT (155, 72), b, 0
   CASE 31: PAINT (170, 90), b, 0
   CASE 32: PAINT (250, 90), b, 0
   CASE 33: PAINT (280, 96), b, 0
   CASE 34: PAINT (310, 100), b, 0
   CASE 35: PAINT (105, 80), b, 0
   CASE 36: PAINT (150, 96), b, 0
   CASE 37: PAINT (230, 120), b, 0
   CASE 38: PAINT (250, 120), b, 0
   CASE 39: PAINT (300, 119), b, 0
   CASE 40: PAINT (350, 119), b, 0
   CASE 41: PAINT (100, 116), b, 0
   CASE 42: PAINT (130, 128), b, 0
   CASE 43: PAINT (160, 128), b, 0
   CASE 44: PAINT (200, 128), b, 0
   CASE 45: PAINT (245, 144), b, 0
   CASE 46: PAINT (290, 152), b, 0
   CASE 47: PAINT (330, 136), b, 0
   CASE 48: PAINT (350, 160), b, 0
   CASE 49: PAINT (330, 160), b, 0
   CASE 50: PAINT (270, 176), b, 0
   CASE 51: PAINT (250, 200), b, 0
   CASE 52: PAINT (220, 176), b, 0
   CASE 53: PAINT (220, 192), b, 0
   CASE 54: PAINT (160, 160), b, 0
   CASE 55: PAINT (160, 176), b, 0
   CASE 56: PAINT (160, 200), b, 0
   CASE 57: PAINT (100, 192), b, 0
   CASE 58: PAINT (100, 136), b, 0
   CASE 59: PAINT (80, 120), b, 0
   CASE 60: PAINT (80, 160), b, 0
  END SELECT
 ELSE PAINT (terr(a).col, terr(a).row), b, 0
 END IF
END SUB

SUB playcastles
 SCREEN 9, , 0, 0
 FOR a = 1 TO numplayers + comp
  changestats a
 NEXT
 DO
  curplayer = 1
  DO
   FOR moves = CINT((player(curplayer).tact + 1) / 4 * RND + 2) TO 1 STEP -1
    IF save THEN
     moves = curmove
     curplayer = playernow
     save = 0
    END IF
    printstats
    getkey key$
    domove (key$)
    IF save THEN
     moves = 1
     save = 0
    END IF
   NEXT
   curplayer = curplayer + 1
  LOOP UNTIL curplayer > numplayers
  IF comp THEN movecomp
  taxpeas
 LOOP
END SUB

SUB printstats
 LINE (400, 0)-(639, 237), 0, BF
 COLOR player(curplayer).clr
 LOCATE 2, 58: PRINT player(curplayer).nam
 LOCATE 4, 52: PRINT "People:    "; player(curplayer).people
 LOCATE , 52: PRINT "Land:      "; player(curplayer).land
 LOCATE , 52: PRINT "Title:      "; player(curplayer).title
 LOCATE , 52: PRINT "Land Title: "; player(curplayer).ctitle
 LOCATE , 52: PRINT "Attack:    "; player(curplayer).attack
 LOCATE , 52: PRINT "Defense:   "; player(curplayer).defense
 LOCATE , 52: PRINT "HP:        "; player(curplayer).hp
 LOCATE , 52: PRINT "Tactics:   "; player(curplayer).tact
 LOCATE , 52: PRINT "Turns:     "; moves
 LOCATE , 52: PRINT "Money:     "; player(curplayer).money
END SUB

FUNCTION query$ (a, a$)
 center a, a$
 WHILE b$ <> "Y" AND b$ <> "N"
  b$ = UCASE$(INKEY$)
 WEND
 LOCATE a, 41 + (LEN(a$) / 2)
 PRINT b$
 query$ = b$
END FUNCTION

SUB raid
 PRINT "From where: ( - Select territory, ESC - abort, Enter - done)"
 a = getterr(1, player(curplayer).clr)
 IF a THEN
  PRINT "To where: ( - Select territory, ESC - abort, Enter - done)"
  b = getterr(2, 1)
  IF b THEN
   IF adj(b, a) OR adj(a, b) THEN
    LINE (0, 238)-(639, 349), 0, BF
    c = RND * terr(a).attack * 2
    IF c > terr(b).hp THEN c = terr(b).hp
    LOCATE 18: PRINT "HP lowered:"; c
    terr(b).hp = terr(b).hp - c
    c = RND * terr(a).attack / 5
    IF c > terr(b).town THEN c = terr(b).town
    LOCATE 18, 40: PRINT "Towns destroyed:"; c
    terr(b).town = terr(b).town - c
    player(terr(b).own).people = player(terr(b).own).people - 10 * c
    IF terr(b).town * 100 < terr(b).peasant THEN d = terr(b).peasant - terr(b).town * 100
    terr(b).defense = terr(b).defense - 3 * c
    terr(b).maxhp = terr(b).maxhp - 5 * c
    terr(b).size = terr(b).size + 3 * c
    c = RND * (terr(a).cannon + (terr(a).men + terr(a).soldiers + terr(a).knights + terr(a).cavalry) / 10)
    IF c > terr(b).fort THEN c = terr(b).fort
    LOCATE 19: PRINT "Forts destroyed:"; c
    terr(b).fort = terr(b).fort - c
    terr(b).defense = terr(b).defense - 5 * c
    terr(b).maxhp = terr(b).maxhp - 7 * c
    terr(b).size = terr(b).size + 3 * c
    mk = 0
    sk = 0
    kk = 0
    ck = 0
    DO WHILE (terr(b).fort + terr(b).castle) * 20 < terr(b).men + terr(b).soldiers + terr(b).knights + terr(b).cavalry - mk - sk - kk - ck
     IF terr(b).men THEN
      mk = mk + 10
     ELSE
      IF terr(b).soldiers THEN
       sk = sk + 10
      ELSE
       IF terr(b).knights THEN
        kk = kk + 10
       ELSE
        IF terr(b).cavalry THEN
         ck = ck + 10
        END IF
       END IF
      END IF
     END IF
    LOOP
    c = RND * terr(a).cannon + terr(a).ship
    IF c > terr(b).dock THEN c = terr(b).dock
    terr(b).maxhp = terr(b).maxhp - 3 * c
    terr(b).dock = terr(b).dock - c
    LOCATE 19, 40: PRINT "Docks destroyed:"; c
    IF terr(b).dock < terr(b).ship THEN
     terr(b).attack = terr(b).attack - 4 * (terr(b).ship - terr(b).dock)
     terr(b).defense = terr(b).defense - 3 * (terr(b).ship - terr(b).dock)
     terr(b).maxhp = terr(b).maxhp - 4 * (terr(b).ship - terr(b).dock)
     terr(b).tact = terr(b).tact - 3 * (terr(b).ship - terr(b).dock)
     terr(b).ship = terr(b).dock
    END IF
    c = CINT(RND * ((terr(a).men + terr(a).soldiers + terr(a).knights + terr(a).cavalry) / 40)) * 10
    c = c + mk
    IF c > terr(b).men THEN c = terr(b).men
    player(terr(b).own).people = player(terr(b).own).people - c
    LOCATE 20: PRINT "Men killed:"; c
    terr(b).men = terr(b).men - c
    terr(b).attack = terr(b).attack - 3 * c / 10
    terr(b).defense = terr(b).defense - 2 * c / 10
    terr(b).maxhp = terr(b).maxhp - 3 * c / 10
    terr(b).tact = terr(b).tact - 3 * c / 10
    c = CINT(RND * ((terr(a).men + terr(a).soldiers + terr(a).knights + terr(a).cavalry) / 40)) * 10
    c = c + sk
    IF c > terr(b).soldiers THEN c = terr(b).soldiers
    player(terr(b).own).people = player(terr(b).own).people - c
    LOCATE 20, 40: PRINT "Soldiers killed:"; c
    terr(b).soldiers = terr(b).soldiers - c
    terr(b).attack = terr(b).attack - 3 * c / 10
    terr(b).defense = terr(b).defense - 2 * c / 10
    terr(b).maxhp = terr(b).maxhp - 4 * c / 10
    terr(b).tact = terr(b).tact - 4 * c / 10
    c = CINT(RND * ((terr(a).men + terr(a).soldiers + terr(a).knights + terr(a).cavalry) / 40)) * 10
    c = c + kk
    IF c > terr(b).knights THEN c = terr(b).knights
    player(terr(b).own).people = player(terr(b).own).people - c
    LOCATE 21: PRINT "Knights killed:"; c
    terr(b).knights = terr(b).knights - c
    terr(b).attack = terr(b).attack - 6 * c / 10
    terr(b).defense = terr(b).defense - 5 * c / 10
    terr(b).maxhp = terr(b).maxhp - 5 * c / 10
    terr(b).tact = terr(b).tact - 3 * c / 10
    c = CINT(RND * ((terr(a).men + terr(a).soldiers + terr(a).knights + terr(a).cavalry) / 40)) * 10
    c = c + ck
    IF c > terr(b).cavalry THEN c = terr(b).cavalry
    player(terr(b).own).people = player(terr(b).own).people - c
    LOCATE 21, 40: PRINT "Cavalry killed:"; c
    terr(b).cavalry = terr(b).cavalry - c
    terr(b).attack = terr(b).attack - ((8 * c) / 10)
    terr(b).defense = terr(b).defense - ((7 * c) / 10)
    terr(b).maxhp = terr(b).maxhp - 6 * c / 10
    terr(b).tact = terr(b).tact - 5 * c / 10
    c = CINT(RND * (terr(b).men + terr(b).soldiers + terr(b).knights + terr(b).cavalry) / 2)
    c = c + d
    IF c > terr(b).peasant THEN c = terr(b).peasant
    LOCATE 22: PRINT "Peasants killed:"; c
    player(terr(b).own).people = player(terr(b).own).people - c
    terr(b).peasant = terr(b).peasant - c
    IF terr(b).hp > terr(b).maxhp THEN terr(b).hp = terr(b).maxhp
    raisehp
    WHILE INKEY$ = "": WEND
   ELSE wrong "Too far away"
   END IF
  ELSE moves = moves + 1
  END IF
 ELSE moves = moves + 1
 END IF
END SUB

SUB raisehp
 FOR a = 1 TO maxterr
  terr(a).hp = terr(a).hp + 1
  IF terr(a).hp > terr(a).maxhp THEN terr(a).hp = terr(a).maxhp
 NEXT
END SUB

SUB restoregame
 CLS
 FOR a = 1 TO 9
  IF fileready(a) THEN a$ = a$ + STR$(a)
 NEXT
 IF LEN(a$) THEN
  IF query(10, "Restore an old game?") = "Y" THEN
   center 12, "Restore which game? (Hit ESC to abort)"
   center 13, a$
   DO
    b$ = UCASE$(INKEY$)
    b = VAL(b$)
    IF b$ = CHR$(27) THEN EXIT DO
   LOOP UNTIL b > 0 AND b < 10 AND fileready(b)
   IF b > 0 AND fileready(b) THEN
    save = b
    center 14, "Restoring game. . . ."
    OPEN "cast3sav." + cut$(b) FOR BINARY AS #1
    GET #1, , numplayers
    GET #1, , comp
    GET #1, , playernow
    GET #1, , attfact
    GET #1, , planet
    IF planet > 1 THEN
     ON ERROR GOTO filenotfound
     curmove = 1
     OPEN "castmap." + cut$(planet - 1) FOR INPUT AS #2
     IF curmove = 0 THEN
      CLS
      COLOR 7
      PRINT "Alternate map #"; cut$(planet - 1); " not found"
      END
     ELSE
      OPEN "castmap." + cut$(planet - 1) FOR BINARY AS #3
      DIM c AS STRING * 5
      GET #3, , c
      IF c <> "VALID" THEN
       CLS
       COLOR 7
       PRINT "Alternate map #"; cut$(planet - 1); " not ready"
       END
      END IF
     END IF
     CLOSE #2
     ON ERROR GOTO unexpect
    END IF
    GET #1, , maxterr
    GET #1, , curmove
    ready = 0
    IF maxterr > 5 AND maxterr < 100 THEN
     FOR a = 1 TO maxterr
      GET #1, , terr(a)
     NEXT
    ELSE ready = 1
    END IF
    IF numplayers < 7 AND numplayers > 0 THEN
     FOR a = 1 TO numplayers + comp
      GET #1, , player(a)
     NEXT
    ELSE ready = 1
    END IF
    IF EOF(1) OR ready THEN
     default
     PRINT "CAST3SAV." + cut$(b) + " is corrupt"
     WHILE INKEY$ = "": WEND
     END
    END IF
    CLOSE
    save = 1
    beginstats
    drawscreen
    FOR b = 1 TO numplayers + comp
     FOR a = 1 TO maxterr
      IF terr(a).own = b THEN paintland a, (player(b).clr)
     NEXT
    NEXT
    playcastles
   END IF
  END IF
 END IF
END SUB

SUB savegame
 LOCATE 18, 1: PRINT "Select a file (1-9, Hit ESC to abort)"
 DO
  a$ = INKEY$
  a = VAL(a$)
  IF a$ = CHR$(27) THEN EXIT DO
 LOOP UNTIL a > 0 AND a <= 9
 IF a THEN
  OPEN "cast3sav." + cut$(a) FOR BINARY AS #1
  PUT #1, , numplayers
  PUT #1, , comp
  PUT #1, , curplayer
  PUT #1, , attfact
  PUT #1, , planet
  PUT #1, , maxterr
  PUT #1, , moves
  FOR b = 1 TO maxterr
   PUT #1, , terr(b)
  NEXT
  FOR b = 1 TO numplayers + comp
   PUT #1, , player(b)
  NEXT
  x = 32767
  PUT #1, , x
  CLOSE
  PRINT "Game saved successfully"
  WHILE INKEY$ = "": WEND
 END IF
 moves = moves + 1
END SUB

SUB showend
 default
 COLOR player(curplayer).clr
 center 2, RTRIM$(player(curplayer).nam) + " won!"
 LOCATE 4, 12: PRINT "Name:       "; player(curplayer).nam
 LOCATE 4, 52: PRINT "Country:    "; player(curplayer).con
 LOCATE 5, 12: PRINT "People:    "; player(curplayer).people
 LOCATE 5, 52: PRINT "Attack:    "; player(curplayer).attack
 LOCATE 6, 12: PRINT "Land:      "; player(curplayer).land
 LOCATE 6, 52: PRINT "Defense:   "; player(curplayer).defense
 LOCATE 7, 12: PRINT "Title:      "; player(curplayer).title
 LOCATE 7, 52: PRINT "HP:        "; player(curplayer).hp
 LOCATE 8, 12: PRINT "Land Title: "; player(curplayer).ctitle
 LOCATE 8, 52: PRINT "Tactics:   "; player(curplayer).tact
 LOCATE 9, 12: PRINT "Money:     "; player(curplayer).money
 FOR a = 1 TO maxterr
  IF terr(a).own = curplayer THEN b = b + terr(a).fort: c& = c& + 100 * terr(a).fort
 NEXT
 LOCATE 9, 52: PRINT "Forts:     "; b
 b = 0
 FOR a = 1 TO maxterr
  IF terr(a).own = curplayer THEN
   b = b + terr(a).castle: c& = c& + 150 * terr(a).castle
  END IF
 NEXT
 LOCATE 10, 12: PRINT "Castles:   "; b
 b = 0
 FOR a = 1 TO maxterr
  IF terr(a).own = curplayer THEN b = b + terr(a).town: c& = c& + 150 * terr(a).town
 NEXT
 LOCATE 10, 52: PRINT "Towns:     "; b
 b = 0
 FOR a = 1 TO maxterr
  IF terr(a).own = curplayer THEN b = b + terr(a).dock: c& = c& + 100 * terr(a).dock
 NEXT
 LOCATE 11, 12: PRINT "Docks:     "; b
 b = 0
 FOR a = 1 TO maxterr
  IF terr(a).own = curplayer THEN b = b + terr(a).ship: c& = c& + 125 * terr(a).ship
 NEXT
 LOCATE 11, 52: PRINT "Ships:     "; b
 b = 0
 FOR a = 1 TO maxterr
  IF terr(a).own = curplayer THEN b = b + terr(a).cannon: c& = c& + 75 * terr(a).cannon
 NEXT
 LOCATE 12, 12: PRINT "Cannons:   "; b
 b& = 0
 FOR a = 1 TO maxterr
  IF terr(a).own = curplayer THEN b& = b& + terr(a).peasant
 NEXT
 LOCATE 12, 52: PRINT "Peasants:  "; b&
 b = 0
 FOR a = 1 TO maxterr
  IF terr(a).own = curplayer THEN b = b + terr(a).men: c& = c& + 5 * terr(a).men
 NEXT
 LOCATE 13, 12: PRINT "Men:       "; b
 b = 0
 FOR a = 1 TO maxterr
  IF terr(a).own = curplayer THEN b = b + terr(a).soldiers: c& = c& + 7.5 * terr(a).soldiers
 NEXT
 LOCATE 13, 52: PRINT "Soldiers:  "; b
 b = 0
 FOR a = 1 TO maxterr
  IF terr(a).own = curplayer THEN b = b + terr(a).knights: c& = c& + 10 * terr(a).knights
 NEXT
 LOCATE 14, 12: PRINT "Knights:   "; b
 b = 0
 FOR a = 1 TO maxterr
  IF terr(a).own = curplayer THEN b = b + terr(a).cavalry: c& = c& + 15 * terr(a).cavalry
 NEXT
 LOCATE 14, 52: PRINT "Cavalry:   "; b
 center 15, "Total Monetary Value:" + STR$(c&)
 IF CINT(RND * 5) = 0 THEN
  center 17, "You deserve to learn a secret code!"
  SELECT CASE CINT(RND * 4)
   CASE 0: center 18, "Weapon Lord"
   CASE 1: center 18, "Ghengis Khan"
   CASE 2: center 18, "Autokill"
   CASE 3: center 18, "Smart Boy"
   CASE 4: center 18, "Money Man"
  END SELECT
  center 20, "Enter above name for your"
  center 21, "name to get a special skill!"
 END IF
 center 23, "Hit Enter to continue"
 WHILE INKEY$ <> CHR$(13): WEND
 endgame
END SUB

SUB taxpeas
 VIEW PRINT
 LINE (400, 0)-(639, 237), 0, BF
 LINE (0, 238)-(639, 349), 0, BF
 COLOR 15
 LOCATE 2, 58: PRINT "TAXES"
 LOCATE 4, 52: PRINT "Name          Taxes"
 FOR a = 1 TO numplayers + comp
  COLOR player(a).clr
  LOCATE a + 4, 52: PRINT player(a).nam; "  "
  b = player(a).people + (player(a).people / 2 * RND - player(a).people / 4)
  c = RND * 40 + 400 + 30 * (player(a).ntitle + player(a).nctitle)
  IF b > c THEN b = c
  IF player(a).nam = "Money Man   " THEN b = b + 400
  LOCATE a + 4, 65: PRINT b; "    "
  player(a).money = player(a).money + b
  IF player(a).money < 100 THEN player(a).money = 100
  IF player(a).money > 30000 THEN player(a).money = 30000
 NEXT
 FOR a = 1 TO 13 - numplayers - comp
  LOCATE numplayers + comp + 4 + a, 52: PRINT SPACE$(24)
 NEXT
 WHILE INKEY$ <> "": WEND
 WHILE INKEY$ = "": WEND
 COLOR 15
 LOCATE 2, 58: PRINT "PEASANTS BORN"
 LOCATE 4, 52: PRINT "Name          Peasants"
 FOR a = 1 TO numplayers + comp
  COLOR player(a).clr
  LOCATE a + 4, 65
  b = 0
  d = 0
  FOR c = 1 TO maxterr
   IF terr(c).own = a THEN
    d = (RND * 3 + 2) * terr(c).town
    IF terr(c).peasant + d > terr(c).town * 100 THEN d = 100 * terr(c).town - terr(c).peasant
    terr(c).peasant = terr(c).peasant + d
    b = b + d
   END IF
  NEXT
  PRINT b; "        "
  player(a).people = player(a).people + b
 NEXT
 FOR a = 1 TO numplayers + comp
  changestats a
 NEXT
 WHILE INKEY$ = "": WEND
END SUB

SUB wrong (a$)
 PRINT a$
 WHILE INKEY$ = "": WEND
 moves = moves + 1
END SUB

