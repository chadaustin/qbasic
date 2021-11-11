DECLARE FUNCTION GetInt! (row!, col!, text$, low!, hi!)
DECLARE FUNCTION GetString$ (row!, col!, text$, length!)
DECLARE SUB Battle (att!, from!)
DECLARE SUB BeginStats ()
DECLARE SUB Center (row!, text$)
DECLARE SUB ChangeStats ()
DECLARE SUB ClearTerr (ter!)
DECLARE SUB ClearScreen ()
DECLARE SUB CreateChar (char!, created!)
DECLARE SUB DoMove (key$)
DECLARE SUB DrawScreen ()
DECLARE SUB GetHome ()
DECLARE SUB GetInputs ()
DECLARE SUB GetKey (key$)
DECLARE SUB Init ()
DECLARE SUB Intro ()
DECLARE SUB PaintLand (terr!, clr!)
DECLARE SUB PlayCastles ()
DECLARE SUB PrintStats ()
DECLARE SUB Purchase (site!, build$)
DECLARE SUB RaiseHP ()
DECLARE SUB RestoreGame ()
DECLARE SUB SaveGame ()
DECLARE SUB ShowEnd ()

CONST true = -1
CONST false = NOT true

TYPE PlayerType
  alive   AS INTEGER
  attack  AS INTEGER
  axe     AS INTEGER
  bow     AS INTEGER
  clr     AS INTEGER
  con     AS STRING * 12
  ctitle  AS STRING * 12
  defense AS INTEGER
  home    AS INTEGER
  HP      AS INTEGER
  land    AS INTEGER
  nam     AS STRING * 12
  nctitle AS INTEGER
  ntitle  AS INTEGER
  people  AS INTEGER
  points  AS INTEGER
  spear   AS INTEGER
  speed   AS INTEGER
  sword   AS INTEGER
  title   AS STRING * 12
END TYPE
   
TYPE TerrType
  attack   AS INTEGER
  axe      AS INTEGER
  bow      AS INTEGER
  cannon   AS INTEGER
  castle   AS INTEGER
  cavalry  AS INTEGER
  defense  AS INTEGER
  dock     AS INTEGER
  fort     AS INTEGER
  knights  AS INTEGER
  HP       AS INTEGER
  MaxHP    AS INTEGER
  men      AS INTEGER
  money    AS INTEGER
  own      AS INTEGER
  ship     AS INTEGER
  spear    AS INTEGER
  speed    AS INTEGER
  soldiers AS INTEGER
  sword    AS INTEGER
  town     AS INTEGER
  water    AS INTEGER
END TYPE

RANDOMIZE TIMER

DIM SHARED player(1 TO 6) AS PlayerType
DIM SHARED terr(70)       AS TerrType
DIM SHARED adj(70, 70)    AS INTEGER
DIM SHARED FileReady(9)   AS INTEGER
DIM SHARED NumPlayers, Planet, CurPlayer, MaxTerr, Moves
DIM SHARED Save, CurMove, PlayerNow

GOSUB CheckScreen
GOSUB CheckScreenMem
GOSUB CheckColor
GOSUB CheckFile

RestoreGame
Intro
GetInputs
Init
PlayCastles

CheckScreen:
  ON ERROR GOTO ScreenError
  SCREEN 9
  SCREEN 0
  ON ERROR GOTO 0
RETURN

ScreenError:
  Center 12, "You must have EGA color or VGA to play Castles II."
  WHILE INKEY$ = "": WEND
  END

CheckScreenMem:
  ON ERROR GOTO Not64K
  SCREEN 9, , 1
  SCREEN 9, , 0
  SCREEN 0
  ON ERROR GOTO 0
RETURN

Not64K:
  Center 12, "You must have 64K EGA adapter memory to play Castles II."
  WHILE INKEY$ = "": WEND
  END

CheckColor:
  ON ERROR GOTO ColorError
  COLOR 15
  ON ERROR GOTO 0
RETURN

ColorError:
  Center 12, "You must have more than 64K color adapter memory to play Castles II."
  WHILE INKEY$ = "": WEND
  END

CheckFile:
  ON ERROR GOTO NoFile
  FOR x = 1 TO 9
    FileReady(x) = true
    OPEN "CASTLES2." + LTRIM$(STR$(x)) FOR INPUT AS #1
    CLOSE
  NEXT
  ON ERROR GOTO 0
RETURN

NoFile:
  FileReady(x) = false
RESUME NEXT

SUB Battle (att, from)
  won = false
  lost = false
  FOR y = 1 TO 3
    FOR x = 1 TO CINT(RND * terr(from).speed)
      attack = CINT(RND * terr(from).attack / 2)
      defense = CINT(RND * terr(att).defense)
      HPtaken = attack - defense
      IF SGN(HPtaken) = -1 THEN HPtaken = 0
      terr(att).HP = terr(att).HP - HPtaken
      IF terr(att).HP <= 0 THEN
        won = true
        terr(att).HP = 0
        EXIT FOR
      END IF
    NEXT
    IF won THEN EXIT FOR
    FOR x = 1 TO CINT(RND * terr(att).speed)
      attack = CINT(RND * terr(att).attack)
      defense = CINT(RND * terr(from).defense / 2)
      HPtaken = attack - defense
      IF SGN(HPtaken) = -1 THEN HPtaken = 0
      terr(from).HP = terr(from).HP - HPtaken
      IF terr(from).HP <= 0 THEN
        lost = true
        terr(from).HP = 0
        EXIT FOR
      END IF
    NEXT
    IF lost = true THEN EXIT FOR
  NEXT
  IF won = true THEN
    PRINT "You won the battle!"
    WHILE INKEY$ <> "": WEND
    ClearTerr att
    player(terr(att).own).land = player(terr(att).own).land - 1
    player(terr(from).own).land = player(terr(from).own).land + 1
    PaintLand att, (player(terr(from).own).clr)
    IF att = player(terr(att).own).home THEN
      player(terr(att).own).alive = false
      FOR x = 1 TO MaxTerr
        IF terr(x).own = terr(att).own THEN
          IF x <> att THEN
            PaintLand x, 15
            terr(x).own = 0
            player(terr(att).own).land = player(terr(att).own).land - 1
          END IF
        END IF
      NEXT
      GameOver = 0
      FOR x = 1 TO NumPlayers
        IF player(x).alive THEN GameOver = GameOver + 1
      NEXT
      IF GameOver = 1 THEN ShowEnd
    END IF
    terr(att).own = terr(from).own
    terr(att).money = 600
  ELSE
    PRINT "You lost the battle."
    WHILE INKEY$ = "": WEND
  END IF
END SUB

SUB BeginStats
  IF Save = false THEN
    Planet = CINT(RND) + 1
    FOR x = 1 TO NumPlayers
      player(x).alive = true
      player(x).land = 1
      player(x).sword = 5
      player(x).axe = 4
      player(x).spear = 3
      player(x).bow = 2
      player(x).ntitle = 1
      player(x).nctitle = 1
    NEXT
  END IF
  SELECT CASE Planet
  CASE 1
    MaxTerr = 60
    adj(1, 2) = true: adj(1, 9) = true: adj(1, 10) = true
    adj(2, 10) = true: adj(2, 3) = true: adj(3, 10) = true
    adj(3, 4) = true: adj(3, 6) = true: adj(4, 6) = true
    adj(4, 5) = true: adj(5, 6) = true: adj(6, 7) = true: adj(6, 9) = true
    adj(6, 10) = true: adj(7, 8) = true: adj(7, 9) = true: adj(8, 9) = true
    adj(9, 10) = true: adj(11, 12) = true: adj(12, 13) = true
    adj(12, 14) = true: adj(13, 14) = true: adj(13, 15) = true
    adj(14, 15) = true: adj(16, 17) = true: adj(16, 18) = true
    adj(16, 20) = true: adj(17, 18) = true: adj(17, 19) = true
    adj(18, 19) = true: adj(18, 20) = true: adj(19, 20) = true
    adj(22, 23) = true: adj(22, 25) = true: adj(22, 26) = true
    adj(23, 24) = true: adj(23, 26) = true: adj(24, 26) = true
    adj(24, 27) = true: adj(24, 28) = true: adj(25, 26) = true
    adj(25, 29) = true: adj(25, 30) = true: adj(25, 31) = true
    adj(26, 27) = true: adj(26, 29) = true: adj(27, 28) = true
    adj(27, 29) = true: adj(27, 32) = true: adj(27, 33) = true
    adj(27, 34) = true: adj(28, 34) = true: adj(29, 31) = true
    adj(29, 32) = true: adj(30, 31) = true: adj(30, 35) = true
    adj(30, 36) = true: adj(31, 32) = true: adj(31, 36) = true
    adj(31, 37) = true: adj(32, 33) = true: adj(32, 37) = true
    adj(32, 38) = true: adj(33, 34) = true: adj(33, 38) = true
    adj(33, 39) = true: adj(34, 39) = true: adj(34, 40) = true
    adj(35, 36) = true: adj(35, 41) = true: adj(36, 41) = true
    adj(36, 37) = true: adj(36, 42) = true: adj(36, 43) = true
    adj(37, 38) = true: adj(37, 43) = true: adj(37, 44) = true
    adj(38, 39) = true: adj(38, 44) = true: adj(38, 45) = true
    adj(38, 46) = true: adj(39, 40) = true: adj(39, 46) = true
    adj(39, 47) = true: adj(40, 47) = true: adj(41, 42) = true
    adj(41, 59) = true: adj(42, 43) = true: adj(42, 54) = true
    adj(42, 58) = true: adj(42, 59) = true: adj(43, 44) = true
    adj(43, 54) = true: adj(44, 45) = true: adj(44, 51) = true
    adj(44, 52) = true: adj(44, 54) = true: adj(45, 46) = true
    adj(45, 50) = true: adj(45, 51) = true: adj(46, 47) = true
    adj(46, 49) = true: adj(46, 50) = true: adj(47, 48) = true
    adj(47, 49) = true: adj(48, 49) = true: adj(49, 50) = true
    adj(50, 51) = true: adj(51, 52) = true: adj(51, 53) = true
    adj(52, 53) = true: adj(52, 54) = true: adj(52, 55) = true
    adj(53, 55) = true: adj(53, 56) = true: adj(54, 55) = true
    adj(54, 58) = true: adj(55, 56) = true: adj(55, 57) = true
    adj(55, 58) = true: adj(56, 57) = true: adj(57, 58) = true
    adj(57, 60) = true: adj(58, 59) = true: adj(58, 60) = true
    adj(59, 60) = true
    FOR x = 1 TO 9: terr(x).water = true: NEXT
    FOR x = 11 TO 17: terr(x).water = true: NEXT
    FOR x = 19 TO 25: terr(x).water = true: NEXT
    terr(28).water = true: terr(30).water = true: terr(34).water = true
    terr(35).water = true: terr(40).water = true: terr(41).water = true
    FOR x = 47 TO 51: terr(x).water = true: NEXT
    terr(53).water = true: terr(56).water = true: terr(57).water = true
    terr(59).water = true: terr(60).water = true
  CASE 2
    MaxTerr = 70
    adj(1, 2) = true: adj(1, 9) = true: adj(2, 3) = true: adj(2, 9) = true
    adj(2, 10) = true: adj(2, 18) = true: adj(3, 4) = true: adj(3, 10) = true
    adj(3, 11) = true: adj(4, 5) = true: adj(4, 11) = true: adj(4, 12) = true
    adj(5, 6) = true: adj(5, 12) = true: adj(5, 13) = true: adj(6, 7) = true
    adj(6, 13) = true: adj(6, 14) = true: adj(6, 15) = true: adj(7, 8) = true
    adj(7, 15) = true: adj(7, 16) = true: adj(8, 16) = true
    adj(9, 17) = true: adj(9, 18) = true: adj(10, 11) = true
    adj(10, 18) = true: adj(10, 19) = true: adj(11, 12) = true
    adj(11, 19) = true: adj(12, 13) = true: adj(12, 14) = true
    adj(12, 19) = true: adj(12, 23) = true: adj(13, 14) = true
    adj(14, 15) = true: adj(15, 16) = true: adj(17, 18) = true
    adj(17, 20) = true: adj(17, 21) = true: adj(18, 19) = true
    adj(18, 21) = true: adj(18, 22) = true: adj(19, 22) = true
    adj(19, 23) = true: adj(20, 21) = true: adj(20, 24) = true
    adj(21, 22) = true: adj(21, 24) = true
    FOR x = 23 TO 26: adj(22, x) = true: NEXT
    adj(23, 26) = true: adj(24, 25) = true: adj(24, 27) = true
    FOR x = 26 TO 28: adj(25, x) = true: NEXT
    adj(27, 28) = true: adj(27, 29) = true: adj(28, 29) = true
    FOR x = 32 TO 35: adj(31, x) = true: NEXT
    adj(32, 33) = true: adj(33, 34) = true: adj(33, 37) = true
    adj(33, 38) = true: FOR x = 35 TO 38: adj(34, x) = true: NEXT
    adj(35, 36) = true: adj(36, 37) = true: adj(36, 39) = true
    adj(37, 38) = true: adj(37, 39) = true: adj(38, 39) = true
    adj(38, 40) = true: adj(39, 40) = true: adj(39, 46) = true
    adj(39, 47) = true: adj(39, 50) = true: adj(40, 41) = true
    adj(40, 46) = true: adj(41, 42) = true: adj(41, 45) = true
    adj(41, 56) = true: FOR x = 43 TO 45: adj(42, x) = true: NEXT
    adj(43, 44) = true: adj(43, 49) = true: adj(44, 45) = true
    adj(44, 48) = true: adj(44, 49) = true
    FOR x = 46 TO 48: adj(45, x) = true: NEXT
    adj(46, 47) = true: adj(47, 48) = true: adj(47, 50) = true
    adj(47, 51) = true: adj(48, 49) = true
    FOR x = 51 TO 53: adj(48, x) = true: NEXT
    adj(49, 53) = true: adj(50, 51) = true: adj(50, 54) = true
    adj(51, 52) = true: adj(51, 54) = true: adj(51, 55) = true
    adj(52, 53) = true: adj(52, 55) = true: adj(52, 56) = true
    adj(53, 56) = true: adj(53, 57) = true: adj(54, 55) = true
    adj(55, 56) = true: adj(56, 57) = true
    FOR x = 59 TO 61: adj(58, x) = true: NEXT
    adj(58, 70) = true: adj(59, 61) = true: adj(59, 63) = true
    adj(59, 70) = true: FOR x = 61 TO 63: adj(60, x) = true: NEXT
    adj(61, 63) = true: FOR x = 63 TO 66: adj(62, x) = true: NEXT
    adj(63, 64) = true: adj(64, 66) = true: adj(64, 67) = true
    adj(65, 66) = true: adj(65, 69) = true: adj(66, 67) = true
    adj(66, 69) = true: adj(67, 69) = true: adj(68, 69) = true
    FOR x = 1 TO 9: terr(x).water = true: NEXT: terr(12).water = true
    FOR x = 14 TO 17: terr(x).water = true: NEXT: terr(20).water = true
    FOR x = 23 TO 33: terr(x).water = true: NEXT: terr(35).water = true
    terr(36).water = true: FOR x = 38 TO 43: terr(x).water = true: NEXT
    terr(49).water = true: terr(50).water = true
    FOR x = 53 TO 60: terr(x).water = true: NEXT
    FOR x = 62 TO 65: terr(x).water = true: NEXT
    FOR x = 67 TO 70: terr(x).water = true: NEXT
  END SELECT
END SUB

SUB Center (row, text$)
  LOCATE row, 41 - (LEN(text$) / 2 + .5)
  PRINT text$
END SUB

SUB ChangeStats
  ClearScreen
  DIM char(1 TO NumPlayers) AS PlayerType
  FOR x = 1 TO NumPlayers
    char(x).ctitle = player(x).ctitle
    char(x).nctitle = player(x).nctitle
    char(x).title = player(x).title
    char(x).ntitle = player(x).ntitle
  NEXT
  FOR x = 1 TO NumPlayers
    IF player(x).people < 200 THEN
      player(x).title = "General"
      IF player(x).ntitle < 1 THEN player(x).ntitle = 1
    END IF
    IF player(x).people < 400 AND player(x).people >= 200 THEN
      player(x).title = "Prince"
      IF player(x).ntitle < 2 THEN player(x).ntitle = 2
    END IF
    IF player(x).people < 600 AND player(x).people >= 400 THEN
      player(x).title = "Duke"
      IF player(x).ntitle < 3 THEN player(x).ntitle = 3
    END IF
    IF player(x).people < 800 AND player(x).people >= 600 THEN
      player(x).title = "King"
      IF player(x).ntitle < 4 THEN player(x).ntitle = 4
    END IF
    IF player(x).people < 1000 AND player(x).people >= 800 THEN
      player(x).title = "Emperor"
      IF player(x).ntitle < 5 THEN player(x).ntitle = 5
    END IF
    IF player(x).people >= 1000 THEN
      player(x).title = "Czar"
      IF player(x).ntitle < 6 THEN player(x).ntitle = 6
    END IF
    IF player(x).land < 10 THEN
      player(x).ctitle = "Town"
      IF player(x).nctitle < 1 THEN player(x).nctitle = 1
    END IF
    IF player(x).land < 20 AND player(x).land >= 10 THEN
      player(x).ctitle = "City"
      IF player(x).nctitle < 2 THEN player(x).nctitle = 2
    END IF
    IF player(x).land < 30 AND player(x).land >= 20 THEN
      player(x).ctitle = "Country"
      IF player(x).nctitle < 3 THEN player(x).nctitle = 3
    END IF
    IF player(x).land < 40 AND player(x).land >= 30 THEN
      player(x).ctitle = "Kingdom"
      IF player(x).nctitle < 4 THEN player(x).nctitle = 4
    END IF
    IF player(x).land < 50 AND player(x).land >= 40 THEN
      player(x).ctitle = "Empire"
      IF player(x).nctitle < 5 THEN player(x).nctitle = 5
    END IF
    IF player(x).land >= 50 THEN
      player(x).ctitle = "Dictatorship"
      IF player(x).nctitle < 5 THEN player(x).nctitle = 6
    END IF
  NEXT
  FOR x = 1 TO NumPlayers
    IF char(x).ntitle < player(x).ntitle THEN
      Center 31, "You have gone up a level!"
      WHILE INKEY$ = "": WEND
      SCREEN , , 0, 0
      created = true
      CreateChar x, created
      SCREEN , , 1, 1
    END IF
    IF char(x).nctitle < player(x).nctitle THEN
      Center 31, "You have gotten more weapons!"
      WHILE INKEY$ = "": WEND
      player(x).sword = player(x).sword + 3
      player(x).axe = player(x).axe + 2
      player(x).spear = player(x).spear + 2
      player(x).bow = player(x).bow + 1
    END IF
  NEXT
END SUB

SUB ClearScreen
  FOR x = 31 TO 36
    LOCATE x, 1: PRINT SPACE$(81)
  NEXT
END SUB

SUB ClearTerr (ter)
  terr(ter).attack = 0
  terr(ter).defense = 0
  terr(ter).MaxHP = 0
  terr(ter).HP = 0
  terr(ter).speed = 0
  terr(ter).castle = 0
  terr(ter).fort = 0
  FOR x = 1 TO terr(ter).town
    player(terr(ter).own).people = player(terr(ter).own).people - 20
  NEXT
  terr(ter).town = 0
  terr(ter).dock = 0
  terr(ter).ship = 0
  terr(ter).cannon = 0
  FOR x = 1 TO terr(ter).men
    player(terr(ter).own).people = player(terr(ter).own).people - 1
  NEXT
  FOR x = 1 TO terr(ter).soldiers
    player(terr(ter).own).people = player(terr(ter).own).people - 1
  NEXT
  FOR x = 1 TO terr(ter).knights
    player(terr(ter).own).people = player(terr(ter).own).people - 1
  NEXT
  FOR x = 1 TO terr(ter).cavalry
    player(terr(ter).own).people = player(terr(ter).own).people - 1
  NEXT
  terr(ter).men = 0
  terr(ter).soldiers = 0
  terr(ter).knights = 0
  terr(ter).cavalry = 0
  terr(ter).sword = 0
  terr(ter).axe = 0
  terr(ter).spear = 0
  terr(ter).bow = 0
END SUB

SUB CreateChar (char, created)
  DO
    IF created THEN
      player(char).points = 4
    ELSE
      player(char).points = 22
    END IF
    CLS
    COLOR player(char).clr
    Center 2, RTRIM$(player(char).nam)
    LOCATE 3, 30: PRINT "Remaining Points:"; player(char).points; "  "
    a = GetInt(6, 30, "Attack:", 0, (player(char).points))
    player(char).points = player(char).points - a
    LOCATE 3, 30: PRINT "Remaining Points:"; player(char).points; "  "
    b = GetInt(9, 30, "Defense:", 0, (player(char).points))
    player(char).points = player(char).points - b
    LOCATE 3, 30: PRINT "Remaining Points:"; player(char).points; "  "
    c = GetInt(12, 30, "Hit Points:", 0, (player(char).points))
    player(char).points = player(char).points - c
    LOCATE 3, 30: PRINT "Remaining Points:"; player(char).points; "  "
    d = GetInt(15, 30, "Speed:", 0, (player(char).points))
    player(char).points = player(char).points - d
    LOCATE 3, 30: PRINT "Remaining Points:"; player(char).points; "  "
    Center 20, "Okay? (Y/N)"
    DO: kbd$ = UCASE$(INKEY$): LOOP UNTIL kbd$ = "Y" OR kbd$ = "N"
    IF kbd$ = "Y" THEN done = true
  LOOP UNTIL done
  player(char).attack = player(char).attack + a
  player(char).defense = player(char).defense + b
  player(char).HP = player(char).HP + c
  player(char).speed = player(char).speed + d
END SUB

SUB DoMove (key$)
  ClearScreen
  SELECT CASE key$
  CASE "A"
    from = GetInt(31, 1, "From where:", 0, MaxTerr)
    IF from THEN
      IF terr(from).own = CurPlayer THEN
        att = GetInt(32, 1, "To where:", 0, MaxTerr)
        IF att THEN
          IF terr(att).own <> 0 AND terr(att).own <> CurPlayer THEN
            ready = false
            adjacent = false
            IF adj(att, from) OR adj(from, att) THEN adjacent = true
            IF terr(from).ship AND terr(att).water THEN ready = true
            IF adjacent OR ready THEN
              Battle (att), (from)
              RaiseHP
            ELSE
              PRINT "Too far away"
              WHILE INKEY$ = "": WEND
              Moves = Moves + 1
            END IF
          ELSE
            PRINT "Cannot attack there"
            WHILE INKEY$ = "": WEND
            Moves = Moves + 1
          END IF
        ELSE
          Moves = Moves + 1
        END IF
      ELSE
        PRINT "Not owned by you"
        WHILE INKEY$ = "": WEND
        Moves = Moves + 1
      END IF
    ELSE
      Moves = Moves + 1
    END IF
  CASE "B"
    site = GetInt(31, 1, "For which territory:", 0, MaxTerr)
    IF site THEN
      IF terr(site).own = CurPlayer THEN
        Center 32, ("Money:" + STR$(terr(site).money))
        Center 33, "Fort---$100  Castle-$150  Town---$150  Dock---$100  Ship---$125  Cannon-$75"
        DO
          build$ = LCASE$(GetString(34, 1, "Build what:", 6))
        LOOP UNTIL build$ = "" OR build$ = "fort" OR build$ = "castle" OR build$ = "town" OR build$ = "dock" OR build$ = "ship" OR build$ = "cannon"
        IF build$ <> "" THEN
          Purchase (site), (build$)
          RaiseHP
        ELSE
          Moves = Moves + 1
        END IF
      ELSE
        PRINT "Not owned by you"
        WHILE INKEY$ = "": WEND
        Moves = Moves + 1
      END IF
    ELSE
      Moves = Moves + 1
    END IF
  CASE "C"
    ter = GetInt(31, 1, "Which territory:", 0, MaxTerr)
    IF ter THEN
      IF terr(ter).own = CurPlayer THEN
        ClearTerr ter
        RaiseHP
        IF player(CurPlayer).home <> ter THEN
          PaintLand ter, 15
          terr(ter).own = 0
          player(CurPlayer).land = player(CurPlayer).land - 1
          terr(ter).money = 600
        ELSE terr(ter).money = 1000
        END IF
      ELSE
        PRINT "Not owned by you"
        WHILE INKEY$ = "": WEND
        Moves = Moves + 1
      END IF
    ELSE
      Moves = Moves + 1
    END IF
  CASE "E"
    Moves = Moves + 1
    ter = GetInt(31, 1, "To where:", 0, MaxTerr)
    IF ter THEN
      IF terr(ter).own = CurPlayer THEN
        LOCATE 32, 1: PRINT "Swords:"; player(CurPlayer).sword; "  Axes:"; player(CurPlayer).axe; "  Spears:"; player(CurPlayer).spear; "  Bows:"; player(CurPlayer).bow
        DO
          weap$ = LCASE$(GetString(33, 1, "Weapon:", 6))
        LOOP UNTIL weap$ = "swords" OR weap$ = "axes" OR weap$ = "spears" OR weap$ = "bows" OR weap$ = ""
        IF weap$ <> "" THEN
          a$ = "You do not have any"
          SELECT CASE weap$
          CASE "swords"
            IF player(CurPlayer).sword > 0 THEN
              terr(ter).attack = terr(ter).attack + 1
              player(CurPlayer).sword = player(CurPlayer).sword - 1
              terr(ter).sword = terr(ter).sword + 1
            ELSE
              PRINT a$
              WHILE INKEY$ = "": WEND
            END IF
          CASE "axes"
            IF player(CurPlayer).axe > 0 THEN
              terr(ter).attack = terr(ter).attack + 2
              player(CurPlayer).axe = player(CurPlayer).axe - 1
              terr(ter).axe = terr(ter).axe + 1
            ELSE
              PRINT a$
              WHILE INKEY$ = "": WEND
            END IF
          CASE "spears"
            IF player(CurPlayer).spear > 0 THEN
              terr(ter).attack = terr(ter).attack + 3
              player(CurPlayer).spear = player(CurPlayer).spear - 1
              terr(ter).spear = terr(ter).spear + 1
            ELSE
              PRINT a$
              WHILE INKEY$ = "": WEND
            END IF
          CASE "bows"
            IF player(CurPlayer).bow > 0 THEN
              terr(ter).speed = terr(ter).speed + 1
              player(CurPlayer).bow = player(CurPlayer).bow - 1
              terr(ter).bow = terr(ter).bow + 1
            ELSE
              PRINT a$
              WHILE INKEY$ = "": WEND
            END IF
          END SELECT
        END IF
      ELSE
        PRINT "Not owned by you"
        WHILE INKEY$ = "": WEND
      END IF
    END IF
  CASE "H"
    site = GetInt(31, 1, "For which territory:", 0, MaxTerr)
    IF site THEN
      IF terr(site).own = CurPlayer THEN
        Center 32, ("Money:" + STR$(terr(site).money))
        Center 33, "Men------$25  Soldiers-$75  Knights--$100  Cavalry--$150"
        DO
          hire$ = LCASE$(GetString(34, 1, "Hire:", 8))
        LOOP UNTIL hire$ = "" OR hire$ = "men" OR hire$ = "soldiers" OR hire$ = "knights" OR hire$ = "cavalry"
        IF hire$ <> "" THEN
          player(CurPlayer).people = player(CurPlayer).people + 10
          SELECT CASE hire$
          CASE "men"
            IF terr(site).money >= 25 THEN
              terr(site).money = terr(site).money - 25
              terr(site).men = terr(site).men + 10
              terr(site).attack = terr(site).attack + 2
              terr(site).defense = terr(site).defense + 1
              terr(site).MaxHP = terr(site).MaxHP + 2
              terr(site).HP = terr(site).HP + 2
              terr(site).speed = terr(site).speed + 1
              RaiseHP
            ELSE
              PRINT "Not enough money"
              WHILE INKEY$ = "": WEND
              Moves = Moves + 1
            END IF
          CASE "soldiers"
            IF terr(site).money >= 75 THEN
              terr(site).money = terr(site).money - 75
              terr(site).soldiers = terr(site).soldiers + 10
              terr(site).attack = terr(site).attack + 4
              terr(site).defense = terr(site).defense + 3
              terr(site).MaxHP = terr(site).MaxHP + 4
              terr(site).HP = terr(site).HP + 4
              terr(site).speed = terr(site).speed + 4
              RaiseHP
            ELSE
              PRINT "Not enough money"
              WHILE INKEY$ = "": WEND
              Moves = Moves + 1
            END IF
          CASE "knights"
            IF terr(site).money >= 100 THEN
              terr(site).money = terr(site).money - 100
              terr(site).knights = terr(site).knights + 10
              terr(site).attack = terr(site).attack + 6
              terr(site).defense = terr(site).defense + 5
              terr(site).MaxHP = terr(site).MaxHP + 6
              terr(site).HP = terr(site).HP + 6
              terr(site).speed = terr(site).speed + 3
              RaiseHP
            ELSE
              PRINT "Not enough money"
              WHILE INKEY$ = "": WEND
              Moves = Moves + 1
            END IF
          CASE "cavalry"
            IF terr(site).money >= 150 THEN
              terr(site).cavalry = terr(site).cavalry + 10
              terr(site).money = terr(site).money - 150
              terr(site).attack = terr(site).attack + 8
              terr(site).defense = terr(site).defense + 7
              terr(site).MaxHP = terr(site).MaxHP + 7
              terr(site).HP = terr(site).HP + 7
              terr(site).speed = terr(site).speed + 7
              RaiseHP
            ELSE
              PRINT "Not enough money"
              WHILE INKEY$ = "": WEND
              Moves = Moves + 1
            END IF
          END SELECT
        ELSE
          Moves = Moves + 1
        END IF
      ELSE
        PRINT "Not owned by you"
        WHILE INKEY$ = "": WEND
        Moves = Moves + 1
      END IF
    ELSE
      Moves = Moves + 1
    END IF
  CASE "L"
    Moves = Moves + 1
    loca = GetInt(31, 1, "Which territory:", 0, MaxTerr)
    IF loca THEN
      PaintLand (loca), 1
      WHILE INKEY$ = "": WEND
      IF terr(loca).own <> 0 THEN c = player(terr(loca).own).clr ELSE c = 15
      PaintLand (loca), c
    END IF
  CASE "M"
    move = GetInt(31, 1, "To where:", 0, MaxTerr)
    IF move THEN
      done = false
      FOR x = 1 TO MaxTerr
        IF terr(x).own = CurPlayer THEN
          IF adj(x, move) OR adj(move, x) THEN done = true
          IF terr(x).ship > 0 AND terr(move).water THEN done = true
        END IF
      NEXT
      IF done = true THEN
        IF terr(move).own = 0 THEN
          PaintLand (move), (player(CurPlayer).clr)
          terr(move).own = CurPlayer
          terr(move).money = 600
          player(CurPlayer).land = player(CurPlayer).land + 1
          terr(move).own = CurPlayer
          RaiseHP
        ELSE
          PRINT "Already owned"
          WHILE INKEY$ = "": WEND
          Moves = Moves + 1
        END IF
      ELSE
        PRINT "Too far away"
        WHILE INKEY$ = "": WEND
        Moves = Moves + 1
      END IF
    ELSE
      Moves = Moves + 1
    END IF
  CASE "Q"
    LOCATE 31, 1: PRINT "Are you sure? (Y/N)"
    Moves = Moves + 1
    DO: kbd$ = UCASE$(INKEY$): LOOP UNTIL kbd$ = "Y" OR kbd$ = "N"
    IF kbd$ = "Y" THEN
      CLS
      END
    END IF
  CASE "R"
    from = GetInt(31, 1, "From where:", 0, MaxTerr)
    IF from THEN
      IF terr(from).own = CurPlayer THEN
        att = GetInt(32, 1, "To where:", 0, MaxTerr)
        IF att THEN
          IF terr(att).own <> 0 AND terr(att).own <> CurPlayer THEN
            adjacent = false
            IF adj(att, from) OR adj(from, att) THEN adjacent = true
            IF adjacent THEN
              RaiseHP
              terr(att).HP = terr(att).HP - CINT(RND ^ 3 * terr(from).attack)
              IF terr(att).HP < 0 THEN terr(att).HP = 0
              townsdest = CINT(RND * 2)
              IF townsdest > terr(att).town THEN townsdest = terr(att).town
              terr(att).town = terr(att).town - townsdest
              FOR x = 1 TO townsdest
                player(terr(att).own).people = player(terr(att).own).people - 20
                terr(att).money = terr(att).money + 150
                terr(att).defense = terr(att).defense - 3
                terr(att).MaxHP = terr(att).MaxHP - 5
              NEXT
              IF terr(att).HP > terr(att).MaxHP THEN terr(att).HP = terr(att).MaxHP
              fortdest = CINT(RND)
              IF fortdest > terr(att).fort THEN fortdest = terr(att).fort
              IF fortdest THEN
                terr(att).money = terr(att).money + 100
                terr(att).defense = terr(att).defense - 5
                terr(att).MaxHP = terr(att).MaxHP - 7
              END IF
              terr(att).fort = terr(att).fort - fortdest
              dockdest = CINT(RND)
              IF dockdest > terr(att).dock THEN dockdest = terr(att).dock
              IF dockdest THEN
                FOR x = 1 TO terr(att).ship
                  terr(site).money = terr(site).money + 125
                  terr(site).ship = terr(site).ship - 1
                  terr(site).attack = terr(site).attack - 4
                  terr(site).defense = terr(site).defense - 3
                  terr(site).MaxHP = terr(site).MaxHP - 4
                  terr(site).speed = terr(site).speed - 3
                NEXT
                terr(att).MaxHP = terr(att).MaxHP - 3
                terr(att).money = terr(att).money + 100
                terr(att).dock = 0
              END IF
              menDead = CINT(RND * (terr(from).men / 10))
              soldiersDead = CINT(RND * (terr(from).soldiers / 10))
              knightsDead = CINT(RND * (terr(from).knights / 10))
              cavalryDead = CINT(RND * (terr(from).cavalry / 10))
              IF menDead > terr(att).men THEN menDead = terr(att).men
              IF soldiersDead > terr(att).soldiers THEN soldiersDead = terr(att).soldiers
              IF knightsDead > terr(att).knights THEN knightsDead = terr(att).knights
              IF cavalryDead > terr(att).cavalry THEN cavalryDead = terr(att).cavalry
              FOR x = 1 TO menDead
                terr(site).money = terr(site).money + 25
                terr(site).men = terr(site).men - 10
                terr(site).attack = terr(site).attack - 2
                terr(site).defense = terr(site).defense - 1
                terr(site).MaxHP = terr(site).MaxHP - 2
                terr(site).speed = terr(site).speed - 1
              NEXT
              FOR x = 1 TO soldiersDead
                terr(site).money = terr(site).money + 75
                terr(site).soldiers = terr(site).soldiers - 10
                terr(site).attack = terr(site).attack - 4
                terr(site).defense = terr(site).defense - 3
                terr(site).MaxHP = terr(site).MaxHP - 4
                terr(site).speed = terr(site).speed - 4
              NEXT
              FOR x = 1 TO knightsDead
                terr(site).money = terr(site).money + 100
                terr(site).knights = terr(site).knights - 10
                terr(site).attack = terr(site).attack - 6
                terr(site).defense = terr(site).defense - 5
                terr(site).MaxHP = terr(site).MaxHP - 6
                terr(site).speed = terr(site).speed - 3
              NEXT
              FOR x = 1 TO cavalryDead
                terr(site).cavalry = terr(site).cavalry - 10
                terr(site).money = terr(site).money + 150
                terr(site).attack = terr(site).attack - 8
                terr(site).defense = terr(site).defense - 7
                terr(site).MaxHP = terr(site).MaxHP - 7
                terr(site).speed = terr(site).speed - 7
              NEXT
              IF terr(att).HP > terr(att).MaxHP THEN terr(att).HP = terr(att).MaxHP
            ELSE
              PRINT "Too far away"
              WHILE INKEY$ = "": WEND
              Moves = Moves + 1
            END IF
          ELSE
            PRINT "Cannot raid there"
            WHILE INKEY$ = "": WEND
            Moves = Moves + 1
          END IF
        ELSE
          Moves = Moves + 1
        END IF
      ELSE
        PRINT "Not owned by you"
        WHILE INKEY$ = "": WEND
        Moves = Moves + 1
      END IF
    ELSE
      Moves = Moves + 1
    END IF
  CASE "S"
    SaveGame
  CASE "V"
    Moves = Moves + 1
    viewterr = GetInt(31, 1, "Which territory:", 0, MaxTerr)
    IF viewterr THEN
      IF terr(viewterr).own THEN
        LOCATE 32, 1
        IF player(terr(viewterr).own).home = viewterr THEN
          PRINT "This territory is the home of player"; STR$(terr(viewterr).own); "."
        ELSE
          PRINT "This territory is owned by player"; STR$(terr(viewterr).own); "."
        END IF
        PRINT "Forts:"; terr(viewterr).fort; " Castles:"; terr(viewterr).castle; " Towns:"; terr(viewterr).town; " Docks:"; terr(viewterr).dock; " Ships:"; terr(viewterr).ship; " Cannons:"; terr(viewterr).cannon
        PRINT "Men:"; terr(viewterr).men; " Soldiers:"; terr(viewterr).soldiers; " Knights:"; terr(viewterr).knights; " Cavalry:"; terr(viewterr).cavalry; " Money:"; terr(viewterr).money
        PRINT "Swords:"; terr(viewterr).sword; " Axes:"; terr(viewterr).axe; " Spears:"; terr(viewterr).spear; " Bows:"; terr(viewterr).bow
        PRINT "Attack:"; terr(viewterr).attack; " Defense:"; terr(viewterr).defense; " Max HP:"; terr(viewterr).MaxHP; " Cur HP:"; terr(viewterr).HP; " Speed:"; terr(viewterr).speed
        WHILE INKEY$ = "": WEND
      ELSE
        PRINT "Not owned by anybody"
        WHILE INKEY$ = "": WEND
      END IF
    END IF
  CASE "W": RaiseHP
  END SELECT
END SUB

SUB DrawScreen
  CLS
  COLOR 15
  WIDTH 80, 43
  SCREEN 9, , 1, 0
  LINE (0, 0)-(399, 239), 15, BF
  COLOR 0
  SELECT CASE Planet
  CASE 1
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
  CASE 2
    LINE (20, 10)-(40, 5): LINE (40, 5)-(125, 15): LINE (125, 15)-(280, 12)
    LINE (280, 12)-(320, 25): LINE (320, 25)-(300, 50)
    LINE (300, 50)-(130, 75): LINE (130, 75)-(120, 130)
    LINE (120, 130)-(100, 150): LINE (100, 150)-(35, 140)
    LINE (35, 140)-(25, 100): LINE (25, 100)-(20, 10)
    LINE (10, 200)-(35, 230): LINE (35, 230)-(250, 220)
    LINE (250, 220)-(270, 180): LINE (270, 180)-(270, 70)
    LINE (270, 70)-(145, 85): LINE (145, 85)-(140, 120)
    LINE (140, 120)-(120, 160): LINE (120, 160)-(40, 160)
    LINE (40, 160)-(10, 200): LINE (370, 200)-(380, 100)
    LINE (380, 100)-(380, 50): LINE (380, 50)-(340, 30)
    LINE (340, 30)-(300, 100): LINE (300, 100)-(300, 230)
    LINE (300, 230)-(370, 200): LINE (21, 30)-(70, 10)
    LINE (46, 20)-(70, 40): LINE (70, 40)-(22, 35): LINE (70, 40)-(100, 30)
    LINE (100, 30)-(100, 13): LINE (85, 35)-(100, 50)
    LINE (100, 50)-(80, 60): LINE (80, 60)-(60, 55): LINE (60, 55)-(55, 40)
    LINE (60, 55)-(23, 60): LINE (41, 57)-(60, 80): LINE (60, 80)-(26, 90)
    LINE (60, 80)-(80, 60): LINE (100, 20)-(120, 33): LINE (120, 33)-(95, 45)
    LINE (110, 26)-(140, 26): LINE (140, 26)-(160, 15)
    LINE (125, 26)-(140, 50): LINE (140, 50)-(105, 40)
    LINE (140, 50)-(160, 70): LINE (130, 75)-(110, 65)
    LINE (110, 65)-(100, 50): LINE (110, 65)-(145, 57)
    LINE (120, 70)-(100, 80): LINE (100, 80)-(125, 100)
    LINE (100, 80)-(70, 70): LINE (85, 75)-(70, 100)
    LINE (70, 100)-(25, 100): LINE (70, 100)-(60, 120)
    LINE (60, 120)-(30, 115): LINE (60, 120)-(70, 145)
    LINE (65, 110)-(90, 105): LINE (90, 105)-(122, 115)
    LINE (106, 110)-(90, 148): LINE (133, 38)-(160, 34)
    LINE (160, 34)-(180, 15): LINE (170, 25)-(180, 50)
    LINE (180, 50)-(180, 67): LINE (180, 60)-(210, 30)
    LINE (210, 30)-(175, 37): LINE (198, 32)-(215, 14)
    LINE (195, 45)-(220, 60): LINE (207, 52)-(235, 25)
    LINE (235, 25)-(230, 14): LINE (221, 39)-(260, 35)
    LINE (260, 35)-(270, 54): LINE (265, 45)-(300, 20)
    LINE (282, 31)-(250, 12): LINE (42, 160)-(50, 190)
    LINE (50, 190)-(80, 160): LINE (65, 175)-(120, 185)
    LINE (120, 185)-(110, 160): LINE (92, 180)-(80, 200)
    LINE (80, 200)-(50, 190): LINE (65, 195)-(35, 200)
    LINE (35, 200)-(28, 220): LINE (80, 200)-(100, 226)
    LINE (120, 185)-(90, 210): LINE (105, 197)-(140, 200)
    LINE (130, 225)-(150, 170): LINE (150, 170)-(125, 150)
    LINE (137, 160)-(160, 130): LINE (160, 130)-(143, 100)
    LINE (153, 115)-(170, 100): LINE (170, 100)-(170, 83)
    LINE (170, 90)-(200, 130): LINE (200, 130)-(160, 130)
    LINE (190, 130)-(190, 150): LINE (190, 150)-(151, 170)
    LINE (170, 160)-(180, 190): LINE (180, 190)-(141, 195)
    LINE (160, 192)-(170, 222): LINE (185, 110)-(200, 79)
    LINE (195, 90)-(220, 110): LINE (220, 110)-(200, 130)
    LINE (210, 120)-(240, 130): LINE (240, 130)-(270, 120)
    LINE (207, 100)-(230, 90): LINE (230, 90)-(270, 90)
    LINE (245, 90)-(240, 74): LINE (225, 125)-(220, 150)
    LINE (220, 150)-(270, 155): LINE (220, 150)-(190, 150)
    LINE (208, 150)-(215, 170): LINE (215, 170)-(215, 220)
    LINE (215, 195)-(178, 180): LINE (215, 180)-(240, 185)
    LINE (240, 185)-(245, 154): LINE (240, 185)-(260, 200)
    LINE (330, 50)-(379, 55): LINE (354, 52)-(360, 90)
    LINE (358, 80)-(319, 70): LINE (337, 75)-(330, 100)
    LINE (300, 110)-(380, 84): LINE (320, 104)-(360, 120)
    LINE (360, 120)-(378, 110): LINE (340, 112)-(320, 130)
    LINE (320, 130)-(340, 150): LINE (330, 140)-(300, 150)
    LINE (340, 150)-(375, 140): LINE (362, 145)-(350, 165)
    LINE (350, 165)-(371, 180): LINE (350, 165)-(330, 180)
    LINE (330, 180)-(315, 145): LINE (330, 180)-(330, 217)
    LINE (330, 185)-(300, 190): LINE (40, 200)-(60, 228)
  CASE 3
  END SELECT
  PAINT (1, 1), 1, 0
END SUB

SUB GetHome
  FOR x = 1 TO NumPlayers
    COLOR player(x).clr
    player(x).home = GetInt(30 + x, 1, ("What is player" + STR$(x) + "'s home?"), 1, MaxTerr)
    test = false
    FOR y = 1 TO x
      IF player(x).home = player(y).home AND x <> y THEN test = true
    NEXT
    IF test = true THEN x = x - 1
    PaintLand (player(x).home), (player(x).clr)
    terr(player(x).home).money = 1000
    terr(player(x).home).attack = player(x).attack
    terr(player(x).home).defense = player(x).defense
    terr(player(x).home).speed = player(x).speed
    terr(player(x).home).MaxHP = player(x).HP
    terr(player(x).home).HP = player(x).HP
    terr(player(x).home).own = x
  NEXT
END SUB

SUB GetInputs
  CLS
  FOR x = 2 TO 14
    COLOR x
    LOCATE 2, x * 5 - 2: PRINT x
  NEXT
  DO WHILE NOT done
    FOR x = 5 TO 20
      LOCATE x, 1: PRINT SPACE$(81)
    NEXT
    COLOR 15
    Center 5, "How many players? (2-6)"
    DO
      NumPlayers = VAL(INKEY$)
    LOOP UNTIL NumPlayers >= 2 AND NumPlayers <= 6
    LOCATE 5, 52: PRINT NumPlayers
    FOR x = 1 TO NumPlayers
      a$ = "Player" + STR$(x) + "'s color (2-14):"
      player(x).clr = GetInt(x + 5, 25, a$, 2, 14)
      test = false
      FOR y = 1 TO x
        IF player(x).clr = player(y).clr AND x <> y THEN test = true
      NEXT
      IF test THEN x = x - 1
    NEXT
    FOR x = 1 TO NumPlayers
      COLOR player(x).clr
      a$ = "Player" + STR$(x) + "'s color"
      Center x + 6 + NumPlayers, a$
    NEXT
    COLOR 15
    Center NumPlayers * 2 + 8, "Okay? (Y/N)"
    DO
      kbd$ = UCASE$(INKEY$)
    LOOP UNTIL kbd$ = "Y" OR kbd$ = "N"
    IF kbd$ = "Y" THEN done = true
  LOOP
  CLS
  FOR x = 1 TO NumPlayers
    COLOR player(x).clr
    a$ = "Player" + STR$(x) + "'s name:"
    DO
      b$ = GetString$(x * 2 + 3, 25, a$, 12)
    LOOP UNTIL b$ <> ""
    player(x).nam = b$
    test = false
    FOR y = 1 TO x
      IF player(x).nam = player(y).nam AND x <> y THEN test = true
    NEXT
    IF test THEN x = x - 1
  NEXT
  FOR x = 1 TO NumPlayers
    COLOR player(x).clr
    b$ = "Player" + STR$(x) + "'s country:"
    DO
      a$ = GetString$(x * 2 + 4, 27, b$, 12)
    LOOP UNTIL a$ <> ""
    player(x).con = a$
    work = true
    FOR y = 1 TO x
      IF player(x).con = player(y).con AND x <> y THEN work = false
    NEXT
    IF NOT work THEN x = x - 1
  NEXT
END SUB

FUNCTION GetInt (row, col, text$, low, hi)
  length = LEN(LTRIM$(STR$(hi)))
  LOCATE row, col: PRINT text$ + " _" + SPACE$(length)
  DO
    DO: kbd$ = INKEY$: LOOP UNTIL kbd$ <> ""
    SELECT CASE kbd$
    CASE "0" TO "9": IF LEN(num$) < length THEN num$ = num$ + kbd$
    CASE CHR$(8)
      IF LEN(num$) >= length - 1 AND LEN(num$) > 0 THEN
        num$ = LEFT$(num$, LEN(num$) - 1)
      END IF
    CASE CHR$(13)
      num = VAL(num$)
      IF num >= low AND num <= hi THEN
        LOCATE row, col + LEN(text$) + LEN(num$) + 1: PRINT " "
        EXIT DO
      END IF
      num$ = ""
    END SELECT
    LOCATE row, col + 1 + LEN(text$): PRINT num$ + "_" + SPACE$(length)
  LOOP
  GetInt = num
END FUNCTION

SUB GetKey (key$)
  ClearScreen
  colr = player(CurPlayer).clr
  COLOR colr
  LOCATE 31, 1: PRINT RTRIM$(player(CurPlayer).nam); " of "; RTRIM$(player(CurPlayer).con); ", what is your command?"
  COLOR 15: PRINT "A"; : COLOR colr: PRINT "ttack-";
  COLOR 15: PRINT "B"; : COLOR colr: PRINT "uild-";
  COLOR 15: PRINT "C"; : COLOR colr: PRINT "lear-";
  COLOR 15: PRINT "E"; : COLOR colr: PRINT "quip-";
  COLOR 15: PRINT "H"; : COLOR colr: PRINT "ire-";
  COLOR 15: PRINT "L"; : COLOR colr: PRINT "ocate-";
  COLOR 15: PRINT "M"; : COLOR colr: PRINT "ove-";
  COLOR 15: PRINT "Q"; : COLOR colr: PRINT "uit-";
  COLOR 15: PRINT "R"; : COLOR colr: PRINT "aid-";
  COLOR 15: PRINT "S"; : COLOR colr: PRINT "ave-";
  COLOR 15: PRINT "V"; : COLOR colr: PRINT "iew-";
  COLOR 15: PRINT "W"; : COLOR colr: PRINT "ait"
  DO
    key$ = UCASE$(INKEY$)
  LOOP UNTIL key$ = "A" OR key$ = "R" OR key$ = "B" OR key$ = "H" OR key$ = "C" OR key$ = "E" OR key$ = "M" OR key$ = "S" OR key$ = "Q" OR key$ = "V" OR key$ = "L" OR key$ = "W"
END SUB

FUNCTION GetString$ (row, col, text$, length)
  LOCATE row, col: PRINT text$ + " _" + SPACE$(length)
  DO
    DO: kbd$ = INKEY$: LOOP UNTIL kbd$ <> ""
    SELECT CASE ASC(kbd$)
    CASE 32 TO 125: IF LEN(a$) < length THEN a$ = a$ + kbd$
    CASE 8: IF LEN(a$) >= 1 THEN a$ = LEFT$(a$, LEN(a$) - 1)
    CASE 13
      LOCATE row, col + LEN(text$) + LEN(a$) + 1: PRINT " "
      EXIT DO
    END SELECT
    LOCATE row, col + 1 + LEN(text$): PRINT a$ + "_" + SPACE$(length)
  LOOP
  GetString$ = a$
END FUNCTION

SUB Init
  BeginStats
  created = false
  FOR x = 1 TO NumPlayers
    CreateChar x, (created)
  NEXT
  DrawScreen
  SCREEN 9, , 1, 1
  GetHome
END SUB

SUB Intro
  Center 3, "C A S T L E S"
  Center 4, "Ver 2.0"
  COLOR RND * 4 + 2
  Center 5, "Written by: Chad Austin"
  COLOR RND * 5 + 9
  Center 7, "    Castles is a strategy game in which two through six players"
  Center 8, "attempt to take over the world by moving to new territories and"
  Center 9, "building on their land.  When a player's home territory is     "
  Center 10, "attacked and destroyed by another player, that player is dead. "
  Center 11, "When one player has destroyed all the other players, the game  "
  Center 12, "is over.                                                       "
  COLOR 15
  Center 22, "Hit any key to continue"
  WHILE INKEY$ = "": WEND
END SUB

SUB PaintLand (terr, clr)
  SELECT CASE Planet
  CASE 1
    SELECT CASE terr
    CASE 1: PAINT (30, 24), clr, 0
    CASE 2: PAINT (40, 16), clr, 0
    CASE 3: PAINT (80, 16), clr, 0
    CASE 4: PAINT (120, 16), clr, 0
    CASE 5: PAINT (110, 56), clr, 0
    CASE 6: PAINT (100, 40), clr, 0
    CASE 7: PAINT (69, 64), clr, 0
    CASE 8: PAINT (45, 64), clr, 0
    CASE 9: PAINT (45, 48), clr, 0
    CASE 10: PAINT (61, 32), clr, 0
    CASE 11: PAINT (30, 120), clr, 0
    CASE 12: PAINT (30, 144), clr, 0
    CASE 13: PAINT (30, 192), clr, 0
    CASE 14: PAINT (60, 192), clr, 0
    CASE 15: PAINT (90, 216), clr, 0
    CASE 16: PAINT (300, 200), clr, 0
    CASE 17: PAINT (340, 216), clr, 0
    CASE 18: PAINT (340, 196), clr, 0
    CASE 19: PAINT (345, 196), clr, 0
    CASE 20: PAINT (317, 184), clr, 0
    CASE 21: PAINT (350, 80), clr, 0
    CASE 22: PAINT (200, 40), clr, 0
    CASE 23: PAINT (250, 24), clr, 0
    CASE 24: PAINT (290, 24), clr, 0
    CASE 25: PAINT (200, 64), clr, 0
    CASE 26: PAINT (250, 60), clr, 0
    CASE 27: PAINT (280, 64), clr, 0
    CASE 28: PAINT (300, 64), clr, 0
    CASE 29: PAINT (250, 74), clr, 0
    CASE 30: PAINT (155, 72), clr, 0
    CASE 31: PAINT (170, 90), clr, 0
    CASE 32: PAINT (250, 90), clr, 0
    CASE 33: PAINT (280, 96), clr, 0
    CASE 34: PAINT (310, 100), clr, 0
    CASE 35: PAINT (105, 80), clr, 0
    CASE 36: PAINT (150, 96), clr, 0
    CASE 37: PAINT (230, 120), clr, 0
    CASE 38: PAINT (250, 120), clr, 0
    CASE 39: PAINT (300, 119), clr, 0
    CASE 40: PAINT (350, 119), clr, 0
    CASE 41: PAINT (100, 116), clr, 0
    CASE 42: PAINT (130, 128), clr, 0
    CASE 43: PAINT (160, 128), clr, 0
    CASE 44: PAINT (200, 128), clr, 0
    CASE 45: PAINT (245, 144), clr, 0
    CASE 46: PAINT (290, 152), clr, 0
    CASE 47: PAINT (330, 136), clr, 0
    CASE 48: PAINT (350, 160), clr, 0
    CASE 49: PAINT (330, 160), clr, 0
    CASE 50: PAINT (270, 176), clr, 0
    CASE 51: PAINT (250, 200), clr, 0
    CASE 52: PAINT (220, 176), clr, 0
    CASE 53: PAINT (220, 192), clr, 0
    CASE 54: PAINT (160, 160), clr, 0
    CASE 55: PAINT (160, 176), clr, 0
    CASE 56: PAINT (160, 200), clr, 0
    CASE 57: PAINT (100, 192), clr, 0
    CASE 58: PAINT (100, 136), clr, 0
    CASE 59: PAINT (80, 120), clr, 0
    CASE 60: PAINT (80, 160), clr, 0
    END SELECT
  CASE 2
    SELECT CASE terr
    CASE 1: PAINT (25, 25), clr, 0
    CASE 2: PAINT (60, 30), clr, 0
    CASE 3: PAINT (120, 25), clr, 0
    CASE 4: PAINT (140, 30), clr, 0
    CASE 5: PAINT (180, 30), clr, 0
    CASE 6: PAINT (220, 25), clr, 0
    CASE 7: PAINT (250, 25), clr, 0
    CASE 8: PAINT (280, 25), clr, 0
    CASE 9: PAINT (25, 35), clr, 0
    CASE 10: PAINT (90, 35), clr, 0
    CASE 11: PAINT (110, 40), clr, 0
    CASE 12: PAINT (160, 60), clr, 0
    CASE 13: PAINT (190, 45), clr, 0
    CASE 14: PAINT (200, 50), clr, 0
    CASE 15: PAINT (230, 45), clr, 0
    CASE 16: PAINT (280, 35), clr, 0
    CASE 17: PAINT (25, 50), clr, 0
    CASE 18: PAINT (65, 55), clr, 0
    CASE 19: PAINT (120, 50), clr, 0
    CASE 20: PAINT (25, 75), clr, 0
    CASE 21: PAINT (60, 75), clr, 0
    CASE 22: PAINT (100, 75), clr, 0
    CASE 23: PAINT (140, 70), clr, 0
    CASE 24: PAINT (50, 95), clr, 0
    CASE 25: PAINT (75, 95), clr, 0
    CASE 26: PAINT (120, 95), clr, 0
    CASE 27: PAINT (50, 110), clr, 0
    CASE 28: PAINT (80, 110), clr, 0
    CASE 29: PAINT (50, 140), clr, 0
    CASE 30: PAINT (100, 140), clr, 0
    CASE 31: PAINT (40, 195), clr, 0
    CASE 32: PAINT (40, 210), clr, 0
    CASE 33: PAINT (70, 210), clr, 0
    CASE 34: PAINT (70, 180), clr, 0
    CASE 35: PAINT (60, 165), clr, 0
    CASE 36: PAINT (80, 165), clr, 0
    CASE 37: PAINT (90, 200), clr, 0
    CASE 38: PAINT (100, 220), clr, 0
    CASE 39: PAINT (120, 190), clr, 0
    CASE 40: PAINT (150, 195), clr, 0
    CASE 41: PAINT (200, 190), clr, 0
    CASE 42: PAINT (240, 190), clr, 0
    CASE 43: PAINT (250, 170), clr, 0
    CASE 44: PAINT (220, 170), clr, 0
    CASE 45: PAINT (180, 170), clr, 0
    CASE 46: PAINT (150, 180), clr, 0
    CASE 47: PAINT (150, 150), clr, 0
    CASE 48: PAINT (200, 135), clr, 0
    CASE 49: PAINT (250, 140), clr, 0
    CASE 50: PAINT (140, 140), clr, 0
    CASE 51: PAINT (170, 120), clr, 0
    CASE 52: PAINT (200, 110), clr, 0
    CASE 53: PAINT (240, 110), clr, 0
    CASE 54: PAINT (160, 100), clr, 0
    CASE 55: PAINT (180, 90), clr, 0
    CASE 56: PAINT (220, 90), clr, 0
    CASE 57: PAINT (265, 80), clr, 0
    CASE 58: PAINT (340, 70), clr, 0
    CASE 59: PAINT (360, 70), clr, 0
    CASE 60: PAINT (330, 80), clr, 0
    CASE 61: PAINT (350, 80), clr, 0
    CASE 62: PAINT (330, 120), clr, 0
    CASE 63: PAINT (350, 100), clr, 0
    CASE 64: PAINT (350, 120), clr, 0
    CASE 65: PAINT (320, 170), clr, 0
    CASE 66: PAINT (330, 170), clr, 0
    CASE 67: PAINT (360, 160), clr, 0
    CASE 68: PAINT (320, 200), clr, 0
    CASE 69: PAINT (340, 200), clr, 0
    CASE 70: PAINT (340, 50), clr, 0
    END SELECT
  END SELECT
END SUB

SUB PlayCastles
  DO
    FOR CurPlayer = 1 TO NumPlayers
      IF player(CurPlayer).alive THEN
        FOR Moves = CINT(player(CurPlayer).speed / 6) + 2 TO 1 STEP -1
          IF Save THEN
            Moves = CurMove
            CurPlayer = PlayerNow
          END IF
          Save = false
          ChangeStats
          PrintStats
          GetKey key$
          DoMove (key$)
        NEXT
      END IF
    NEXT
  LOOP
END SUB

SUB PrintStats
  COLOR player(CurPlayer).clr
  LOCATE 2, 58: PRINT "Player"; CurPlayer
  LOCATE 4, 52: PRINT "People:   "; player(CurPlayer).people; SPACE$(5)
  LOCATE 5, 52: PRINT "Land:     "; player(CurPlayer).land; SPACE$(5)
  LOCATE 6, 52: PRINT "Title:     "; player(CurPlayer).title; SPACE$(5)
  LOCATE 7, 52: PRINT "Coun. Ttl: "; player(CurPlayer).ctitle; SPACE$(5)
  LOCATE 8, 52: PRINT "Home Terr."; player(CurPlayer).home; SPACE$(5)
  LOCATE 9, 52: PRINT "Attack:   "; player(CurPlayer).attack; SPACE$(5)
  LOCATE 10, 52: PRINT "Defense:  "; player(CurPlayer).defense; SPACE$(5)
  LOCATE 11, 52: PRINT "HP:       "; player(CurPlayer).HP; SPACE$(5)
  LOCATE 12, 52: PRINT "Speed:    "; player(CurPlayer).speed; SPACE$(5)
  LOCATE 13, 52: PRINT "Turns:    "; Moves; SPACE$(5)
END SUB

SUB Purchase (site, build$)
  SELECT CASE build$
  CASE "fort"
    IF terr(site).money >= 100 THEN
      terr(site).money = terr(site).money - 100
      terr(site).fort = terr(site).fort + 1
      terr(site).defense = terr(site).defense + 5
      terr(site).HP = terr(site).HP + 7
      terr(site).MaxHP = terr(site).MaxHP + 7
    ELSE
      PRINT "Not enough money"
      WHILE INKEY$ = "": WEND
      Moves = Moves + 1
    END IF
  CASE "castle"
    IF terr(site).money >= 150 THEN
      terr(site).money = terr(site).money - 150
      terr(site).castle = terr(site).castle + 1
      terr(site).defense = terr(site).defense + 8
      terr(site).MaxHP = terr(site).MaxHP + 9
      terr(site).HP = terr(site).HP + 9
    ELSE
      PRINT "Not enough money"
      WHILE INKEY$ = "": WEND
      Moves = Moves + 1
    END IF
  CASE "town"
    IF terr(site).money >= 150 THEN
      terr(site).money = terr(site).money - 150
      player(terr(site).own).people = player(terr(site).own).people + 20
      terr(site).town = terr(site).town + 1
      terr(site).defense = terr(site).defense + 3
      terr(site).MaxHP = terr(site).MaxHP + 5
      terr(site).HP = terr(site).HP + 5
    ELSE
      PRINT "Not enough money"
      WHILE INKEY$ = "": WEND
      Moves = Moves + 1
    END IF
  CASE "dock"
    IF terr(site).money >= 100 THEN
      IF terr(site).water = true THEN
        IF terr(site).dock < 1 THEN
          terr(site).money = terr(site).money - 100
          terr(site).dock = 1
          terr(site).MaxHP = terr(site).MaxHP + 3
          terr(site).HP = terr(site).HP + 3
        ELSE
          PRINT "One is enough"
          WHILE INKEY$ = "": WEND
          Moves = Moves + 1
        END IF
      ELSE
        PRINT "Must be near water"
        WHILE INKEY$ = "": WEND
        Moves = Moves + 1
      END IF
    ELSE
      PRINT "Not enough money"
      WHILE INKEY$ = "": WEND
      Moves = Moves + 1
    END IF
  CASE "ship"
    IF terr(site).money >= 125 THEN
      IF terr(site).dock = 1 THEN
        terr(site).money = terr(site).money - 125
        terr(site).ship = terr(site).ship + 1
        terr(site).attack = terr(site).attack + 4
        terr(site).defense = terr(site).defense + 3
        terr(site).MaxHP = terr(site).MaxHP + 4
        terr(site).HP = terr(site).HP + 4
        terr(site).speed = terr(site).speed + 3
      ELSE
        PRINT "Need a dock"
        WHILE INKEY$ = "": WEND
        Moves = Moves + 1
      END IF
    ELSE
      PRINT "Not enough money"
      WHILE INKEY$ = "": WEND
      Moves = Moves + 1
    END IF
  CASE "cannon"
    IF terr(site).money >= 75 THEN
      terr(site).money = terr(site).money - 75
      terr(site).cannon = terr(site).cannon + 1
      terr(site).attack = terr(site).attack + 6
      terr(site).MaxHP = terr(site).MaxHP + 4
      terr(site).HP = terr(site).HP + 4
      terr(site).speed = terr(site).speed + 1
    ELSE
      PRINT "Not enough money"
      WHILE INKEY$ = "": WEND
      Moves = Moves + 1
    END IF
  END SELECT
END SUB

SUB RaiseHP
  FOR x = 1 TO MaxTerr
    terr(x).HP = terr(x).HP + 1
    IF terr(x).HP > terr(x).MaxHP THEN terr(x).HP = terr(x).MaxHP
  NEXT
END SUB

SUB RestoreGame
  FOR x = 1 TO 9
    IF FileReady(x) THEN b$ = b$ + STR$(x)
  NEXT
  IF b$ <> "" THEN
    Center 10, "Do you wish to restore an old game?"
    DO
      kbd$ = UCASE$(INKEY$)
    LOOP UNTIL kbd$ = "Y" OR kbd$ = "N"
    IF kbd$ = "Y" THEN
      Center 12, "Restore which game? (Hit [ESC] to abort)"
      Center 13, b$
      DO
        DO: kbd$ = UCASE$(INKEY$): LOOP UNTIL kbd$ <> ""
        file = VAL(kbd$)
        IF kbd$ = CHR$(27) THEN
          file = 0
          EXIT DO
        END IF
      LOOP UNTIL file > 0 AND file < 10 AND FileReady(file)
      IF file > 0 AND FileReady(file) THEN
        Center 14, "Restoring game      "
        LOCATE 14, 44: COLOR 31: PRINT ". . ."
        OPEN "CASTLES2." + LTRIM$(STR$(file)) FOR INPUT AS #1
        INPUT #1, NumPlayers
        INPUT #1, PlayerNow
        INPUT #1, Planet
        INPUT #1, MaxTerr
        INPUT #1, CurMove
        FOR x = 1 TO MaxTerr
          INPUT #1, terr(x).attack
          INPUT #1, terr(x).axe
          INPUT #1, terr(x).bow
          INPUT #1, terr(x).cannon
          INPUT #1, terr(x).castle
          INPUT #1, terr(x).cavalry
          INPUT #1, terr(x).defense
          INPUT #1, terr(x).dock
          INPUT #1, terr(x).fort
          INPUT #1, terr(x).knights
          INPUT #1, terr(x).HP
          INPUT #1, terr(x).MaxHP
          INPUT #1, terr(x).men
          INPUT #1, terr(x).money
          INPUT #1, terr(x).own
          INPUT #1, terr(x).ship
          INPUT #1, terr(x).spear
          INPUT #1, terr(x).speed
          INPUT #1, terr(x).soldiers
          INPUT #1, terr(x).sword
          INPUT #1, terr(x).town
        NEXT
        FOR x = 1 TO NumPlayers
          INPUT #1, player(x).alive
          INPUT #1, player(x).attack
          INPUT #1, player(x).axe
          INPUT #1, player(x).bow
          INPUT #1, player(x).clr
          INPUT #1, player(x).con
          INPUT #1, player(x).ctitle
          INPUT #1, player(x).defense
          INPUT #1, player(x).home
          INPUT #1, player(x).HP
          INPUT #1, player(x).land
          INPUT #1, player(x).nam
          INPUT #1, player(x).nctitle
          INPUT #1, player(x).ntitle
          INPUT #1, player(x).people
          INPUT #1, player(x).points
          INPUT #1, player(x).spear
          INPUT #1, player(x).speed
          INPUT #1, player(x).sword
          INPUT #1, player(x).title
        NEXT
        Save = true
        CLOSE
        DrawScreen
        BeginStats
        FOR player = 1 TO NumPlayers
          FOR x = 1 TO MaxTerr
            IF terr(x).own = player THEN PaintLand x, (player(player).clr)
          NEXT
        NEXT
        SCREEN , , 1, 1
        PlayCastles
      END IF
    END IF
  END IF
  CLS
  CLOSE
END SUB

SUB SaveGame
  LOCATE 31, 1: PRINT "Choose a file (1-9, Hit ESC to abort)"
  DO
    kbd$ = INKEY$
    file = VAL(kbd$)
    IF kbd$ = CHR$(27) THEN
      file = 0
      EXIT DO
    END IF
  LOOP UNTIL file > 0 AND file <= 9
  IF file > 0 THEN
    OPEN "CASTLES2." + LTRIM$(STR$(file)) FOR OUTPUT AS #1
    PRINT #1, NumPlayers
    PRINT #1, CurPlayer
    PRINT #1, Planet
    PRINT #1, MaxTerr
    PRINT #1, Moves
    FOR x = 1 TO MaxTerr
      PRINT #1, terr(x).attack
      PRINT #1, terr(x).axe
      PRINT #1, terr(x).bow
      PRINT #1, terr(x).cannon
      PRINT #1, terr(x).castle
      PRINT #1, terr(x).cavalry
      PRINT #1, terr(x).defense
      PRINT #1, terr(x).dock
      PRINT #1, terr(x).fort
      PRINT #1, terr(x).knights
      PRINT #1, terr(x).HP
      PRINT #1, terr(x).MaxHP
      PRINT #1, terr(x).men
      PRINT #1, terr(x).money
      PRINT #1, terr(x).own
      PRINT #1, terr(x).ship
      PRINT #1, terr(x).spear
      PRINT #1, terr(x).speed
      PRINT #1, terr(x).soldiers
      PRINT #1, terr(x).sword
      PRINT #1, terr(x).town
    NEXT
    FOR x = 1 TO NumPlayers
      PRINT #1, player(x).alive
      PRINT #1, player(x).attack
      PRINT #1, player(x).axe
      PRINT #1, player(x).bow
      PRINT #1, player(x).clr
      PRINT #1, player(x).con
      PRINT #1, player(x).ctitle
      PRINT #1, player(x).defense
      PRINT #1, player(x).home
      PRINT #1, player(x).HP
      PRINT #1, player(x).land
      PRINT #1, player(x).nam
      PRINT #1, player(x).nctitle
      PRINT #1, player(x).ntitle
      PRINT #1, player(x).people
      PRINT #1, player(x).points
      PRINT #1, player(x).spear
      PRINT #1, player(x).speed
      PRINT #1, player(x).sword
      PRINT #1, player(x).title
    NEXT
    CLOSE
    PRINT "Game saved successfully"
    WHILE INKEY$ = "": WEND
  END IF
  Moves = Moves + 1
END SUB

SUB ShowEnd
  CLS
  Center 12, "Player" + STR$(CurPlayer) + " won the game with" + STR$(player(CurPlayer).people) + " people and" + STR$(player(CurPlayer).land) + " territories."
  Center 13, (RTRIM$(player(CurPlayer).nam) + " of " + RTRIM$(player(CurPlayer).con) + " was a " + RTRIM$(player(CurPlayer).title) + " of a " + RTRIM$(player(CurPlayer).ctitle) + ".")
  END
END SUB

