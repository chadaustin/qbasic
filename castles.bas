'
'                               C A S T L E S
'
'                                Version 1.2
'                             By:  Chad Austin
'
'       Castles is a game in which two to five players try to conquer the
' world by moving to empty territories, attacking occupied territories, and
' building in their own territories.  If a player attacks and destroys
' another player's home territory, then the game is over for the destroyed
' player.  After one person destroys every other player, he/she wins.
'
'
' Hit [SHIFT]+[F5] to play "Castles" again.
'
' Hit [ALT], F, X to exit QBasic.
'
'
 
' Sub Declarations
DECLARE SUB Adjacent (from, dest)
DECLARE SUB Battle ()
DECLARE SUB BeginStats ()
DECLARE SUB Center (row!, text$)
DECLARE SUB ChangeStats ()
DECLARE SUB ClearPlayer (PlayCleared)
DECLARE SUB ClearScreen ()
DECLARE SUB CreateCharacters (Num)
DECLARE SUB DoMove ()
DECLARE SUB DrawScreen ()
DECLARE SUB GetHome ()
DECLARE SUB GetInputs ()
DECLARE SUB GetMove ()
DECLARE SUB Instructions ()
DECLARE SUB Introduction ()
DECLARE SUB NoMoney ()
DECLARE SUB Purchase ()
DECLARE SUB PaintLand (pnt, we)
DECLARE SUB PlayCastles ()
DECLARE SUB PrintStats ()
DECLARE SUB RaiseHP ()
DECLARE SUB ShowEnd ()
DECLARE SUB ViewChar ()

' This type gives the players their stats
TYPE char
    alive   AS INTEGER
    attack  AS INTEGER
    axe     AS INTEGER
    bow     AS INTEGER
    clr     AS INTEGER
    ctitle  AS STRING * 8
    ictitle AS INTEGER
    country AS STRING * 10
    defense AS INTEGER
    home    AS INTEGER
    HP      AS INTEGER
    land    AS INTEGER
    move    AS INTEGER
    nam     AS STRING * 14
    p       AS INTEGER
    people  AS INTEGER
    spear   AS INTEGER
    sword   AS INTEGER
    title   AS STRING * 8
    ititle  AS INTEGER
END TYPE

' This type gives all the stats for territories
TYPE lan
    own     AS INTEGER
    attack  AS INTEGER
    defense AS INTEGER
    move    AS INTEGER
    HP      AS INTEGER
    MaxHP   AS INTEGER
    money   AS INTEGER
    castle  AS INTEGER
    fort    AS INTEGER
    town    AS INTEGER
    cannon  AS INTEGER
    dock    AS INTEGER
    ship    AS INTEGER
    soldier AS INTEGER
    knight  AS INTEGER
    cavalry AS INTEGER
    water   AS INTEGER
END TYPE

' This type gives all fighters their stats
TYPE stat
    attack  AS INTEGER
    defend  AS INTEGER
    HP      AS INTEGER
END TYPE

' Constants
CONST true = -1
CONST false = NOT true

RANDOMIZE TIMER               ' Allows all random numbers to be different

' Global Variables
DIM SHARED player(1 TO 5) AS char
DIM SHARED terr(1 TO 60) AS lan
DIM SHARED soldier(1 TO 600) AS stat
DIM SHARED knight(1 TO 300) AS stat
DIM SHARED cavalry(1 TO 200) AS stat
DIM SHARED v(1 TO 60, 1 TO 60) AS INTEGER
DIM SHARED NumPlayers, r, mo, p, pnt, ter, do$, s, work, buy$, i, moves, Num
DIM SHARED o, we, fight, frm, printer, GameOver, purc, lear

Introduction
GetInputs
BeginStats
FOR x = 1 TO NumPlayers
    o = true
    CreateCharacters x
NEXT
ViewChar
PlayCastles

SUB Adjacent (from, dest)
    IF v(from, dest) = true THEN
        mo = true
    END IF
END SUB

SUB Battle
    BattleWon = false
    BattleLost = false
    FOR atac = 1 TO 3
        FOR x% = 1 TO (RND * terr(frm).move) / 2
            attack% = (RND * terr(frm).attack) * 2
            defense% = (RND * terr(fight).defense) / 2
            HPTakenOff% = attack% - defense%
            IF HPTakenOff% > 0 THEN terr(fight).HP = terr(fight).HP - HPTakenOff%
        NEXT
        IF terr(fight).HP < 1 THEN
            BattleLost = false
            EXIT FOR
        END IF
        FOR x% = 1 TO (RND * terr(fight).move) / 2
            attack% = (RND * terr(fight).attack) * 2
            defense% = (RND * terr(frm).defense) / 2
            HPTakenOff% = attack% - defense%
            IF HPTakenOff% > 0 THEN terr(frm).HP = terr(frm).HP - HPTakenOff%
        NEXT
        IF terr(frm).HP < 1 THEN BattleLost = true
        IF terr(frm).HP < 0 THEN terr(frm).HP = 0
        IF terr(fight).HP < 0 THEN terr(fight).HP = 0
        IF BattleLost THEN EXIT FOR
    NEXT
    IF BattleLost = false THEN
        IF fight = player(terr(fight).own).home THEN ClearPlayer (terr(fight).own)
        FOR x = 1 TO terr(fight).town
            player(terr(fight).own).people = player(terr(fight).own).people - 25
        NEXT x
        FOR x = 1 TO terr(fight).knight
            player(terr(fight).own).people = player(terr(fight).own).people - 1
        NEXT x
        FOR x = 1 TO terr(fight).soldier
            player(terr(fight).own).people = player(terr(fight).own).people - 1
        NEXT x
        FOR x = 1 TO terr(fight).cavalry
            player(terr(fight).own).people = player(terr(fight).own).people - 1
        NEXT x
        IF GameOver = 0 THEN
            terr(fight).MaxHP = 0
            terr(fight).HP = 0
            terr(fight).move = 0
            terr(fight).attack = 0
            terr(fight).defense = 0
            terr(fight).move = 0
            terr(fight).castle = 0
            terr(fight).fort = 0
            terr(fight).town = 0
            terr(fight).cannon = 0
            terr(fight).dock = 0
            terr(fight).ship = 0
            terr(fight).soldier = 0
            terr(fight).knight = 0
            terr(fight).cavalry = 0
            terr(fight).money = 500
        END IF
        PRINT "The attacker won!!!"
        PaintLand fight, (player(terr(frm).own).clr)
        player(terr(fight).own).land = player(terr(fight).own).land - 1
        player(terr(frm).own).land = player(terr(frm).own).land + 1
        terr(fight).own = terr(frm).own
        WHILE INKEY$ = "": WEND
        IF GameOver = 1 THEN ShowEnd
        GameOver = 0
    ELSE
        PRINT "The battle was lost."
        WHILE INKEY$ = "": WEND
    END IF
    RaiseHP
END SUB

SUB BeginStats
    ' Player Stats
    FOR x = 1 TO NumPlayers
        player(x).axe = 3: player(x).bow = 2: player(x).ctitle = "Town"
        player(x).ictitle = 1: player(x).p = 15: player(x).spear = 2
        player(x).sword = 5: player(x).title = "General"
        player(x).ititle = 1
    NEXT
    FOR x = 1 TO NumPlayers
        player(x).alive = true
    NEXT
    ' Adjacent Territory Stats
    v(1, 2) = true: v(1, 9) = true: v(1, 10) = true: v(2, 1) = true
    v(2, 10) = true: v(2, 3) = true: v(3, 2) = true: v(3, 10) = true
    v(3, 4) = true: v(3, 6) = true: v(4, 3) = true: v(4, 6) = true
    v(4, 5) = true: v(5, 4) = true: v(5, 6) = true: v(6, 3) = true
    v(6, 4) = true: v(6, 5) = true: v(6, 7) = true: v(6, 9) = true
    v(6, 10) = true: v(7, 6) = true: v(7, 8) = true: v(7, 9) = true
    v(8, 7) = true: v(8, 9) = true: v(9, 1) = true: v(9, 6) = true
    v(9, 7) = true: v(9, 8) = true: v(9, 10) = true: v(10, 1) = true
    v(10, 2) = true: v(10, 3) = true: v(10, 6) = true: v(10, 7) = true
    v(10, 9) = true: v(11, 12) = true: v(12, 11) = true: v(12, 13) = true
    v(12, 14) = true: v(13, 12) = true: v(13, 14) = true: v(13, 14) = true
    v(14, 12) = true: v(14, 13) = true: v(13, 15) = true: v(14, 12) = true
    v(14, 13) = true: v(14, 15) = true: v(15, 13) = true: v(15, 14) = true
    v(16, 17) = true: v(16, 18) = true: v(16, 20) = true: v(17, 16) = true
    v(17, 18) = true: v(17, 19) = true: v(18, 16) = true: v(18, 17) = true
    v(18, 19) = true: v(18, 20) = true: v(19, 17) = true: v(19, 18) = true
    v(19, 20) = true: v(20, 16) = true: v(20, 18) = true: v(20, 19) = true
    v(22, 23) = true: v(22, 25) = true: v(22, 26) = true: v(23, 22) = true
    v(23, 24) = true: v(23, 26) = true: v(24, 23) = true: v(24, 26) = true
    v(24, 27) = true: v(24, 28) = true: v(25, 22) = true: v(25, 26) = true
    v(25, 29) = true: v(25, 30) = true: v(25, 31) = true: v(26, 22) = true
    v(26, 23) = true: v(26, 24) = true: v(26, 25) = true: v(26, 27) = true
    v(26, 29) = true: v(27, 24) = true: v(27, 26) = true: v(27, 28) = true
    v(27, 29) = true: v(27, 32) = true: v(27, 33) = true: v(27, 34) = true
    v(28, 24) = true: v(28, 27) = true: v(28, 34) = true: v(29, 25) = true
    v(29, 26) = true: v(29, 27) = true: v(29, 31) = true: v(29, 32) = true
    v(30, 25) = true: v(30, 31) = true: v(30, 35) = true: v(30, 36) = true
    v(31, 25) = true: v(31, 29) = true: v(31, 30) = true: v(31, 32) = true
    v(31, 36) = true: v(31, 37) = true: v(32, 27) = true: v(32, 29) = true
    v(32, 31) = true: v(32, 33) = true: v(32, 37) = true: v(32, 38) = true
    v(33, 27) = true: v(33, 32) = true: v(33, 34) = true: v(33, 38) = true
    v(33, 39) = true: v(34, 27) = true: v(34, 28) = true: v(34, 33) = true
    v(34, 39) = true: v(34, 40) = true: v(35, 30) = true: v(35, 36) = true
    v(35, 41) = true: v(36, 30) = true: v(36, 31) = true: v(36, 35) = true
    v(36, 41) = true: v(36, 37) = true: v(36, 42) = true: v(36, 43) = true
    v(36, 59) = true: v(37, 31) = true: v(37, 32) = true: v(37, 36) = true
    v(37, 38) = true: v(37, 43) = true: v(37, 44) = true: v(38, 32) = true
    v(38, 33) = true: v(38, 37) = true: v(38, 39) = true: v(38, 44) = true
    v(38, 45) = true: v(38, 46) = true: v(39, 33) = true: v(39, 34) = true
    v(39, 38) = true: v(39, 40) = true: v(39, 46) = true: v(39, 47) = true
    v(40, 34) = true: v(40, 39) = true: v(40, 47) = true: v(41, 35) = true
    v(41, 36) = true: v(41, 42) = true: v(41, 59) = true: v(42, 36) = true
    v(42, 41) = true: v(42, 43) = true: v(42, 54) = true: v(42, 58) = true
    v(42, 59) = true: v(43, 36) = true: v(43, 37) = true: v(43, 42) = true
    v(43, 44) = true: v(43, 54) = true: v(44, 37) = true: v(44, 38) = true
    v(44, 43) = true: v(44, 45) = true: v(44, 51) = true: v(44, 52) = true
    v(44, 54) = true: v(45, 38) = true: v(45, 44) = true: v(45, 46) = true
    v(45, 50) = true: v(45, 51) = true: v(46, 38) = true: v(46, 39) = true
    v(46, 45) = true: v(46, 47) = true: v(46, 49) = true: v(46, 50) = true
    v(47, 39) = true: v(47, 40) = true: v(47, 46) = true: v(47, 48) = true
    v(47, 49) = true: v(48, 47) = true: v(48, 49) = true: v(49, 46) = true
    v(49, 47) = true: v(49, 48) = true: v(49, 50) = true: v(50, 45) = true
    v(50, 46) = true: v(50, 49) = true: v(50, 51) = true: v(51, 44) = true
    v(51, 45) = true: v(51, 50) = true: v(51, 52) = true: v(51, 53) = true
    v(52, 44) = true: v(52, 51) = true: v(52, 53) = true: v(52, 54) = true
    v(52, 55) = true: v(53, 51) = true: v(53, 52) = true: v(53, 55) = true
    v(53, 56) = true: v(54, 42) = true: v(54, 43) = true: v(54, 44) = true
    v(54, 52) = true: v(54, 55) = true: v(54, 58) = true: v(55, 52) = true
    v(55, 53) = true: v(55, 54) = true: v(55, 56) = true: v(55, 57) = true
    v(55, 58) = true: v(56, 53) = true: v(56, 55) = true: v(56, 57) = true
    v(57, 55) = true: v(57, 56) = true: v(57, 58) = true: v(57, 60) = true
    v(58, 57) = true: v(58, 59) = true: v(58, 42) = true: v(58, 54) = true
    v(58, 55) = true: v(58, 60) = true: v(59, 41) = true: v(59, 42) = true
    v(59, 58) = true: v(59, 60) = true: v(60, 57) = true: v(60, 58) = true
    v(60, 59) = true
    ' Adjacent to Water
    FOR x = 1 TO 9
        terr(x).water = true
    NEXT
    FOR x = 11 TO 17
        terr(x).water = true
    NEXT
    FOR x = 19 TO 25
        terr(x).water = true
    NEXT
    terr(28).water = true
    terr(30).water = true
    terr(34).water = true
    terr(35).water = true
    terr(40).water = true
    terr(41).water = true
    FOR x = 47 TO 51
        terr(x).water = true
    NEXT x
    terr(53).water = true
    terr(56).water = true
    terr(57).water = true
    terr(59).water = true
    terr(60).water = true
END SUB

SUB Center (row, text$)
    LOCATE row, 40 - LEN(text$) / 2
    PRINT text$;
END SUB

SUB ChangeStats
    DIM ply(1 TO NumPlayers) AS char
    FOR u = 1 TO NumPlayers
        ply(u).ctitle = player(u).ctitle
        ply(u).ictitle = player(u).ictitle
        ply(u).title = player(u).title
        ply(u).ititle = player(u).ititle
    NEXT
    FOR t = 1 TO NumPlayers
        IF player(t).people < 400 AND player(t).people >= 200 THEN player(t).title = "Prince": IF player(t).ititle < 2 THEN player(t).ititle = 2
        IF player(t).people < 600 AND player(t).people >= 400 THEN player(t).title = "Duke": IF player(t).ititle < 3 THEN player(t).ititle = 3
        IF player(t).people < 800 AND player(t).people >= 600 THEN player(t).title = "King": IF player(t).ititle < 4 THEN player(t).ititle = 4
        IF player(t).people >= 800 THEN player(t).title = "Emperor": IF player(t).ititle < 5 THEN player(t).ititle = 5
        IF player(t).land < 20 AND player(t).land >= 10 THEN player(t).ctitle = "City": IF player(t).ictitle < 2 THEN player(t).ictitle = 2
        IF player(t).land < 30 AND player(t).land >= 20 THEN player(t).ctitle = "Country": IF player(t).ictitle < 3 THEN player(t).ictitle = 3
        IF player(t).land < 40 AND player(t).land >= 30 THEN player(t).ctitle = "Kingdom": IF player(t).ictitle < 4 THEN player(t).ictitle = 4
        IF player(t).land >= 40 THEN player(t).ctitle = "Empire": IF player(t).ictitle < 5 THEN player(t).ictitle = 5
    NEXT
    FOR s = 1 TO NumPlayers
        IF ply(s).ititle < player(s).ititle THEN
            LOCATE 25, 1: PRINT "Congratulations, you have gone up a level!!!!!"
            FOR fg = 1 TO 3
                PLAY "L16N24N25N27"
            NEXT
            WHILE INKEY$ = "": WEND
            o = false
            player(s).p = 3
            CreateCharacters s
            DrawScreen
            FOR ba = 1 TO NumPlayers
                FOR ab = 1 TO 60
                    IF terr(ab).own = ba THEN
                        PaintLand ab, (player(ba).clr)
                    END IF
                NEXT
            NEXT
        END IF
        IF ply(s).ictitle < player(s).ictitle THEN
            LOCATE 25, 1: PRINT "Congratulations, you have gotten more weapons!!!!!"
            FOR fg = 1 TO 3
                PLAY "L16N24n25n27"
            NEXT
            WHILE INKEY$ = "": WEND
            player(s).sword = player(s).sword + 2
            player(s).axe = player(s).axe + 2
            player(s).spear = player(s).spear + 2
            player(s).bow = player(s).bow + 2
        END IF
    NEXT
END SUB

SUB ClearPlayer (PlayCleared)
    FOR lear = 1 TO 60
        IF terr(lear).own = PlayCleared AND player(PlayCleared).home <> lear THEN
            PaintLand lear, 15
            terr(lear).own = 0
            terr(lear).MaxHP = 0
            terr(lear).move = 0
            terr(lear).attack = 0
            terr(lear).defense = 0
            terr(lear).money = 0
            terr(lear).castle = 0
            terr(lear).fort = 0
            terr(lear).town = 0
            terr(lear).cannon = 0
            terr(lear).dock = 0
            terr(lear).ship = 0
            terr(lear).soldier = 0
            terr(lear).knight = 0
            terr(lear).cavalry = 0
        END IF
    NEXT
    player(PlayCleared).alive = false
    GameOver = 0
    FOR x = 1 TO NumPlayers
        IF player(x).alive = true THEN GameOver = GameOver + 1
    NEXT x
END SUB

SUB ClearScreen
    FOR x = 20 TO 27
        LOCATE x, 1: PRINT SPACE$(81)
    NEXT
END SUB

SUB CreateCharacters (Num)
    WHILE INKEY$ <> "": WEND                ' Delete keyboard buffer
    DIM att$(1 TO 5), att(1 TO 5)
    DIM def$(1 TO 5), dfnc(1 TO 5)
    DIM HP$(1 TO 5), HP(1 TO 5)
    DIM move$(1 TO 5), move(1 TO 5)
    rtn = false
    WHILE rtn = false
        CLS
        COLOR player(Num).clr
        Center 2, player(Num).nam
        LOCATE 3, 25: PRINT "Remaining Points:"; player(Num).p
        DO
            LOCATE 5, 10: INPUT "What is your attack"; att$(Num)
            att(Num) = VAL(att$(Num))
        LOOP UNTIL att(Num) <= player(Num).p
        player(Num).p = player(Num).p - att(Num)
        LOCATE 3, 42: PRINT player(Num).p
        DO
            LOCATE 7, 10: INPUT "What is your defense"; def$(Num)
            dfnc(Num) = VAL(def$(Num))
        LOOP UNTIL dfnc(Num) <= player(Num).p
        player(Num).p = player(Num).p - dfnc(Num)
        LOCATE 3, 42: PRINT player(Num).p
        DO
            LOCATE 9, 10: INPUT "What is your hit points"; HP$(Num)
            HP(Num) = VAL(HP$(Num))
        LOOP UNTIL HP(Num) <= player(Num).p
        player(Num).p = player(Num).p - HP(Num)
        LOCATE 3, 42: PRINT player(Num).p
        DO
            LOCATE 11, 10: INPUT "What is your movement"; move$(Num)
            move(Num) = VAL(move$(Num))
        LOOP UNTIL move(Num) <= player(Num).p
        player(Num).p = player(Num).p - move(Num)
        LOCATE 3, 42: PRINT player(Num).p
        Center 23, "Are these correct? (Y/N)"
        DO
            kbd$ = INKEY$
            kbd$ = UCASE$(kbd$)
        LOOP UNTIL kbd$ = "Y" OR kbd$ = "N"
        IF kbd$ = "Y" THEN rtn = true
        FOR e = 1 TO NumPlayers
            SELECT CASE o
            CASE true: player(e).p = 15
            CASE false: player(e).p = 3
            END SELECT
        NEXT
    WEND
    player(Num).attack = player(Num).attack + att(Num)
    player(Num).defense = player(Num).defense + dfnc(Num)
    player(Num).HP = player(Num).HP + HP(Num)
    player(Num).move = player(Num).move + move(Num)
    IF o = false THEN
        terr(player(s).home).attack = terr(player(s).home).attack + player(s).attack
        terr(player(s).home).defense = terr(player(s).home).defense + player(s).defense
        terr(player(s).home).MaxHP = terr(player(s).home).MaxHP + player(s).HP
        terr(player(s).home).move = terr(player(s).home).move + player(s).move
    END IF
END SUB

SUB DoMove
    SELECT CASE do$
    CASE "m"
        DO
            ClearScreen
            DO
                LOCATE 20, 20: PRINT SPACE$(41)
                LOCATE 20, 1: INPUT "To which territory"; terri$
                ter = VAL(terri$)
            LOOP UNTIL ter < 61 AND ter > 0 OR terri$ = ""
            IF terri$ <> "" THEN
                work = false
                IF terr(ter).own = 0 THEN work = true
                IF work = false THEN LOCATE 21, 1: PRINT "That territory is already taken."
                mo = false
                FOR i = 1 TO 60
                    IF terr(i).own = r THEN
                        Adjacent i, ter
                    END IF
                    IF mo = true THEN EXIT FOR
                NEXT
                FOR i = 1 TO 60
                    IF terr(i).water = true AND terr(i).own = r AND terr(i).dock = 1 AND terr(i).ship > 0 THEN watermove = true
                NEXT
                IF watermove = true THEN
                    IF terr(ter).water = true THEN mo = true
                END IF
                IF mo = false THEN LOCATE 22, 1: PRINT "That territory is too far away."
            END IF
        LOOP UNTIL work = true AND mo = true OR terri$ = ""
        IF terri$ <> "" THEN
            terr(ter).own = r
            PaintLand ter, (player(r).clr)
            player(r).land = player(r).land + 1
            IF work = true AND mo = true THEN terr(ter).money = 500
            RaiseHP
        ELSE
            moves = moves - 1
        END IF
    CASE "b"
        ClearScreen
        DO
                LOCATE 20, 21: PRINT SPACE$(59)
                LOCATE 20, 1: INPUT "For which territory"; purc$
                purc = VAL(purc$)
                IF purc > 60 OR purc < 1 THEN EXIT DO
                IF terr(purc).own <> r THEN LOCATE 21, 1: PRINT "That territory is not owned by you.": moves = moves - 1
        LOOP UNTIL purc > 0 AND purc < 61 OR purc$ = ""
        IF purc <= 60 AND purc >= 1 THEN
            IF terr(purc).own = r THEN
                terrowned = true
            ELSE
                terrowned = false
            END IF
        END IF
        IF purc <= 60 AND purc >= 1 AND terrowned THEN
            LOCATE 21, 1: PRINT "That territory has"; terr(purc).money; "dollars left."
            Center 22, "Castle--$150    Fort--$250      Town-----$100   Cannons--$100   Dock--$100"
            Center 23, "Soldiers--$50   Knights--$100   Cavalry--$150   Ship-----$50              "
            DO
                 LOCATE 24, 25: PRINT SPACE$(55)
                 LOCATE 24, 1: INPUT "What do you want to buy"; buy$
                 buy$ = LCASE$(buy$)
            LOOP UNTIL buy$ = "castle" OR buy$ = "fort" OR buy$ = "town" OR buy$ = "cannons" OR buy$ = "dock" OR buy$ = "ship" OR buy$ = "knights" OR buy$ = "soldiers" OR buy$ = "cavalry" OR buy$ = ""
            IF buy$ <> "" THEN Purchase ELSE moves = moves - 1
        ELSE
            IF purc > 60 OR purc < 1 THEN
                LOCATE 21, 1: PRINT "No such territory!"
                moves = moves - 1
                WHILE INKEY$ = "": WEND
            END IF
        END IF
    CASE "a"
        ClearScreen
        DO
            LOCATE 20, 41: PRINT SPACE$(39)
            LOCATE 20, 1: INPUT "From which territory do you want to attack"; frm$
            frm = VAL(frm$)
            IF frm < 1 OR frm > 60 THEN EXIT DO
            IF terr(frm).own <> r THEN
                LOCATE 21, 1: PRINT "You do not own that territory!"
                WHILE INKEY$ = "": WEND
                LOCATE 21, 1: PRINT SPACE$(81)
            END IF
        LOOP UNTIL terr(frm).own = r
        IF frm >= 1 AND frm <= 60 THEN
            DO
                LOCATE 21, 36: PRINT SPACE$(44)
                LOCATE 21, 1: INPUT "Which territory do you want to attack"; fight$
                fight = VAL(fight$)
                IF fight < 1 OR fight > 60 THEN EXIT DO
            LOOP UNTIL fight > 0 AND fight < 61 AND terr(fight).own <> r AND terr(fight).own <> 0
            mo = false
            IF fight >= 1 AND fight <= 60 THEN
                Adjacent frm, fight
                IF terr(frm).dock = 1 AND terr(frm).ship > 0 AND terr(fight).water = true THEN mo = true
                IF mo = false THEN LOCATE 22, 1: PRINT "That territory is too far away."
            ELSE
                PRINT "No such territory!"
                WHILE INKEY$ = "": WEND
            END IF
            IF mo = true AND terr(frm).move > 0 AND terr(frm).attack > 0 AND terr(frm).MaxHP > 0 THEN
                Battle
            ELSE
                PRINT "You are not strong enough to attack."
                moves = moves - 1
                WHILE INKEY$ = "": WEND
            END IF
        ELSE
            PRINT "No such territory!"
            moves = moves - 1
            WHILE INKEY$ = "": WEND
        END IF
    CASE "e"
        moves = moves - 1
        ClearScreen
        DO
            LOCATE 20, 52: PRINT SPACE$(29)
            LOCATE 20, 1: INPUT "Which territory would you like to give weapons to"; weapterr$
            weapterr = VAL(weapterr$)
            IF weapterr > 60 OR weapterr < 1 THEN EXIT DO
        LOOP UNTIL terr(weapterr).own = r
        IF weapterr <= 60 AND weapterr >= 1 THEN
            DO
                LOCATE 21, 54: PRINT SPACE$(27)
                LOCATE 21, 1: INPUT "What weapon would you like to give to that territory"; weap$
            LOOP UNTIL weap$ = "sword" OR weap$ = "axe" OR weap$ = "bow" OR weap$ = "spear" OR weap$ = ""
            SELECT CASE weap$
                CASE "sword"
                    IF player(r).sword > 0 THEN
                        terr(weapterr).attack = terr(weapterr).attack + 1
                        player(r).sword = player(r).sword - 1
                        RaiseHP
                    ELSE
                        PRINT "You do not have any swords."
                    END IF
                CASE "axe"
                    IF player(r).axe > 0 THEN
                        terr(weapterr).attack = terr(weapterr).attack + 2
                        player(r).axe = player(r).axe - 1
                        RaiseHP
                    ELSE
                        PRINT "You do not have any axes."
                    END IF
                CASE "spear"
                    IF player(r).spear > 0 THEN
                        terr(weapterr).attack = terr(weapterr).attack + 2
                        terr(weapterr).move = terr(weapterr).move + 1
                        player(r).spear = player(r).spear - 1
                        RaiseHP
                    ELSE
                        PRINT "You do not have any spears."
                    END IF
                CASE "bow"
                    IF player(r).bow > 0 THEN
                        terr(weapterr).attack = terr(weapterr).attack + 1
                        terr(weapterr).move = terr(weapterr).move + 3
                        player(r).bow = player(r).bow - 1
                        RaiseHP
                    ELSE
                        PRINT "You do not have any bows."
                    END IF
            END SELECT
        ELSE
            PRINT "No such territory!"
            moves = moves - 1
        END IF
    CASE "v"
        moves = moves - 1
        ClearScreen
        DO
            LOCATE 20, 40: PRINT SPACE$(41)
            LOCATE 20, 1: INPUT "Which territory would you like to view"; viewterr$
            viewterr = VAL(viewterr$)
            IF viewterr > 60 OR viewterr < 1 THEN EXIT DO
        LOOP UNTIL terr(viewterr).own <> 0
        IF viewterr >= 1 AND viewterr <= 60 THEN
            ClearScreen
            LOCATE 20, 1: IF viewterr = player(terr(viewterr).own).home THEN PRINT "This territory is the home of player"; STR$(terr(viewterr).own); "." ELSE PRINT "This territory is owned by player"; STR$(terr(viewterr).own); "."
            LOCATE 21, 1: PRINT "# Castles:"; terr(viewterr).castle, "# Forts:"; terr(viewterr).fort, "# Towns:"; terr(viewterr).town, "# Ships:"; terr(viewterr).ship, "# Cannons:"; terr(viewterr).cannon
            LOCATE 22, 1: PRINT "Attack:"; terr(viewterr).attack, "Defense:"; terr(viewterr).defense, "Move:"; terr(viewterr).move, "Max HP:"; terr(viewterr).MaxHP, "HP:"; terr(viewterr).HP
            LOCATE 23, 1: PRINT "Soldiers:"; terr(viewterr).soldier, "Knights:"; terr(viewterr).knight, "Cavalry:"; terr(viewterr).cavalry
            LOCATE 24, 1: IF terr(viewterr).dock = 1 THEN PRINT "This territory has a dock." ELSE PRINT "This territory does not have a dock."
            WHILE INKEY$ = "": WEND
        ELSE
            PRINT "No such territory!"
            WHILE INKEY$ = "": WEND
        END IF
    CASE "c"
        ClearScreen
        DO
            LOCATE 20, 38: PRINT SPACE$(41)
            LOCATE 20, 1: INPUT "Which territory do you wish to clear"; clearterr$
            clearterr = VAL(clearterr$)
            IF clearterr > 60 OR clearterr < 1 THEN EXIT DO
        LOOP UNTIL terr(clearterr).own = r
        IF clearterr >= 1 AND clearterr <= 60 THEN
            FOR x = 1 TO terr(clearterr).town
                player(terr(clearterr).own).people = player(terr(clearterr).own).people - 25
            NEXT x
            FOR x = 1 TO terr(clearterr).knight
                player(terr(clearterr).own).people = player(terr(clearterr).own).people - 1
            NEXT x
            FOR x = 1 TO terr(clearterr).soldier
                player(terr(clearterr).own).people = player(terr(clearterr).own).people - 1
            NEXT x
            FOR x = 1 TO terr(clearterr).cavalry
                player(terr(clearterr).own).people = player(terr(clearterr).own).people - 1
            NEXT x
            terr(clearterr).MaxHP = 0
            terr(clearterr).HP = 0
            terr(clearterr).move = 0
            terr(clearterr).attack = 0
            terr(clearterr).defense = 0
            terr(clearterr).move = 0
            terr(clearterr).castle = 0
            terr(clearterr).fort = 0
            terr(clearterr).town = 0
            terr(clearterr).cannon = 0
            terr(clearterr).dock = 0
            terr(clearterr).ship = 0
            terr(clearterr).soldier = 0
            terr(clearterr).knight = 0
            terr(clearterr).cavalry = 0
            IF clearterr = player(terr(clearterr).own).home THEN terr(clearterr).money = 1000 ELSE terr(clearterr).money = 500
        ELSE
            PRINT "No such territory!"
            moves = moves - 1
            WHILE INKEY$ = "": WEND
        END IF
    END SELECT
END SUB

SUB DrawScreen
    SCREEN 12
    CLS
    LINE (0, 0)-(400, 300), 15, BF                  ' Draws Background
    COLOR 0
    ' Draws island in upper left corner
    LINE (27, 20)-(25, 25)
    LINE (25, 25)-(22, 60)
    LINE (22, 60)-(35, 100)
    LINE (35, 100)-(45, 105)
    LINE (45, 105)-(52, 103)
    LINE (52, 103)-(90, 80)
    LINE (90, 80)-(120, 80)
    LINE (120, 80)-(130, 75)
    LINE (130, 75)-(150, 15)
    LINE (150, 15)-(27, 20)
    ' Draws territories of this island
    LINE (25, 25)-(55, 35)
    LINE (55, 35)-(75, 25)
    LINE (75, 25)-(75, 18)
    LINE (55, 35)-(70, 50)
    LINE (63, 43)-(35, 53)
    LINE (35, 53)-(24, 53)
    LINE (70, 50)-(70, 70)
    LINE (70, 70)-(24, 65)
    LINE (70, 60)-(90, 80)
    LINE (50, 68)-(45, 103)
    LINE (75, 25)-(95, 40)
    LINE (95, 40)-(70, 50)
    LINE (90, 35)-(120, 17)
    LINE (108, 25)-(130, 75)
    LINE (118, 50)-(100, 80)
    ' Draws island in lower left corner
    LINE (15, 286)-(12, 272)
    LINE (12, 272)-(16, 150)
    LINE (16, 150)-(30, 138)
    LINE (30, 138)-(37, 147)
    LINE (37, 147)-(37, 190)
    LINE (37, 190)-(51, 230)
    LINE (51, 230)-(100, 265)
    LINE (100, 265)-(110, 280)
    LINE (110, 280)-(60, 290)
    LINE (60, 290)-(15, 286)
    ' Draws territories of this island
    LINE (16, 170)-(37, 165)
    LINE (16, 200)-(46, 217)
    LINE (70, 245)-(40, 287)
    LINE (55, 265)-(30, 250)
    LINE (30, 250)-(35, 212)
    ' Draws island in upper right corner
    LINE (370, 70)-(367, 100)
    LINE (367, 100)-(357, 110)
    LINE (357, 110)-(340, 95)
    LINE (340, 95)-(370, 70)
    ' Draws island in lower left corner
    CIRCLE (330, 250), 31
    ' Draws territories of this island
    LINE (306, 231)-(320, 240)
    LINE (320, 240)-(340, 240)
    LINE (340, 240)-(350, 226)
    LINE (340, 240)-(345, 260)
    LINE (345, 260)-(360, 255)
    LINE (345, 260)-(320, 260)
    LINE (320, 260)-(320, 240)
    LINE (320, 255)-(310, 274)
    ' Draws large island in the center of screen
    LINE (370, 200)-(360, 150)
    LINE (360, 150)-(347, 120)
    LINE (347, 120)-(320, 90)
    LINE (320, 90)-(350, 70)
    LINE (350, 70)-(340, 50)
    LINE (340, 50)-(300, 15)
    LINE (300, 15)-(220, 17)
    LINE (220, 17)-(170, 23)
    LINE (170, 23)-(155, 70)
    LINE (155, 70)-(130, 90)
    LINE (130, 90)-(100, 90)
    LINE (100, 90)-(50, 120)
    LINE (50, 120)-(60, 220)
    LINE (60, 220)-(120, 260)
    LINE (120, 260)-(270, 275)
    LINE (270, 275)-(267, 230)
    LINE (267, 230)-(300, 210)
    LINE (300, 210)-(370, 200)
    ' Draws territories of this island
    LINE (340, 203)-(363, 170)
    LINE (352, 186)-(300, 150)
    LINE (300, 150)-(360, 150)
    LINE (330, 150)-(347, 120)
    LINE (330, 171)-(310, 208)
    LINE (320, 190)-(270, 200)
    LINE (270, 200)-(267, 230)
    LINE (289, 195)-(260, 160)
    LINE (260, 160)-(314, 160)
    LINE (290, 160)-(260, 120)
    LINE (260, 120)-(290, 100)
    LINE (290, 100)-(305, 125)
    LINE (305, 125)-(275, 140)
    LINE (305, 125)-(335, 140)
    LINE (296, 110)-(329, 100)
    LINE (310, 104)-(290, 85)
    LINE (290, 85)-(334, 45)
    LINE (310, 65)-(270, 15)
    LINE (275, 110)-(250, 80)
    LINE (250, 80)-(290, 40)
    LINE (278, 25)-(240, 50)
    LINE (240, 50)-(215, 18)
    LINE (229, 35)-(200, 65)
    LINE (200, 65)-(250, 80)
    LINE (210, 55)-(160, 56)
    LINE (220, 71)-(190, 90)
    LINE (190, 90)-(155, 70)
    LINE (190, 90)-(265, 100)
    LINE (227, 95)-(220, 140)
    LINE (220, 140)-(268, 130)
    LINE (240, 135)-(240, 175)
    LINE (240, 175)-(273, 175)
    LINE (240, 175)-(268, 215)
    LINE (173, 82)-(165, 120)
    LINE (165, 120)-(222, 130)
    LINE (165, 120)-(120, 90)
    LINE (140, 105)-(52, 130)
    LINE (100, 117)-(120, 150)
    LINE (120, 150)-(90, 145)
    LINE (90, 145)-(55, 160)
    LINE (120, 150)-(200, 126)
    LINE (160, 138)-(240, 160)
    LINE (200, 149)-(180, 190)
    LINE (180, 190)-(256, 200)
    LINE (180, 190)-(140, 145)
    LINE (160, 167)-(115, 185)
    LINE (115, 185)-(115, 150)
    LINE (115, 185)-(170, 215)
    LINE (170, 215)-(220, 196)
    LINE (115, 165)-(57, 180)
    LINE (85, 172)-(100, 246)
    LINE (95, 213)-(150, 205)
    LINE (135, 208)-(110, 253)
    LINE (122, 231)-(200, 267)
    LINE (170, 253)-(170, 215)
    LINE (170, 230)-(220, 230)
    LINE (220, 230)-(240, 199)
    LINE (220, 230)-(246, 273)
    PAINT (1, 1), 1, 0
END SUB

SUB GetHome
    DIM g(1 TO NumPlayers)
    DIM g$(1 TO NumPlayers)
    FOR s = 1 TO NumPlayers
        test = false
        COLOR player(s).clr
        DO
            LOCATE 20, 40: PRINT SPACE$(40)
            LOCATE 20, 1: PRINT "Player"; STR$(s); ", what is your home territory";
            INPUT g$(s)
            g(s) = VAL(g$(s))
        LOOP UNTIL g(s) > 0 AND g(s) < 61
        FOR i = 1 TO s
            IF player(i).home = player(s).home AND s <> i THEN test = true
        NEXT
        IF test = true THEN s = s - 1
        IF test = false THEN PaintLand g(s), (player(s).clr)
        player(s).home = g(s)
        terr(player(s).home).own = s
        terr(player(s).home).money = 1000
        terr(player(s).home).attack = terr(player(s).home).attack + player(s).attack
        terr(player(s).home).defense = terr(player(s).home).defense + player(s).defense
        terr(player(s).home).MaxHP = terr(player(s).home).MaxHP + player(s).HP
        terr(player(s).home).move = terr(player(s).home).move + player(s).move
        terr(player(s).home).HP = terr(player(s).home).HP + player(s).HP
        player(s).land = 1
    NEXT
END SUB

SUB GetInputs
    DIM nam$(1 TO 5)
    DIM con$(1 TO 5)
    CLS
    COLOR 15
    LOCATE 3, 20: PRINT "How many players? (2-5)"
    DO
        kbd = VAL(INKEY$)
    LOOP UNTIL kbd < 6 AND kbd > 1
    LOCATE 3, 43: PRINT kbd
    NumPlayers = kbd
    go = true
    WHILE go = true
        FOR w = 1 TO 18
            LOCATE w + 4, 1: PRINT SPACE$(81)
        NEXT
        FOR x = 1 TO NumPlayers
            test = false
            DO
                LOCATE x * 2 + 3, 55: PRINT SPACE$(24)
                LOCATE x * 2 + 3, 22: PRINT "What is player"; STR$(x); "'s color (2-14)";
                INPUT x$
                player(x).clr = VAL(x$)
            LOOP UNTIL player(x).clr < 15 AND player(x).clr > 1
            FOR i = 1 TO x
                IF player(x).clr = player(i).clr AND x <> i THEN test = true
            NEXT
            IF test = true THEN x = x - 1
        NEXT
        FOR y = 1 TO NumPlayers
            COLOR player(y).clr: LOCATE y + 15, 32: PRINT "Player"; STR$(y); "'s color"
        NEXT
        COLOR 15: LOCATE 21, 25: PRINT "Are these colors okay? (Y/N)"
        DO
            kbd$ = INKEY$
            kbd$ = UCASE$(kbd$)
        LOOP UNTIL kbd$ = "Y" OR kbd$ = "N"
        IF kbd$ = "Y" THEN go = false
    WEND
    CLS
    FOR x = 1 TO NumPlayers
        COLOR player(x).clr
        test = false
        DO
            LOCATE x * 2 + 1, 1: PRINT SPACE$(80)
            LOCATE x * 2 + 1, 10: PRINT "What is player"; STR$(x); "'s name";
            INPUT nam$(x)
        LOOP UNTIL nam$(x) <> ""
        FOR i = 1 TO x
            IF nam$(x) = nam$(i) AND x <> i THEN test = true
        NEXT
        IF test = true THEN x = x - 1
        player(x).nam = nam$(x)
    NEXT
    FOR x = 1 TO NumPlayers
        COLOR player(x).clr
        test = false
        DO
            LOCATE x * 2 + 2, 1: PRINT SPACE$(80)
            LOCATE x * 2 + 2, 15: PRINT "What is player"; STR$(x); "'s country";
            INPUT con$(x)
        LOOP UNTIL con$(x) <> ""
        FOR i = 1 TO x
            IF con$(x) = con$(i) AND x <> i THEN test = true
        NEXT
        IF test = true THEN x = x - 1
        player(x).country = con$(x)
    NEXT
END SUB

SUB GetMove
    LOCATE 20, 1: PRINT RTRIM$(player(r).nam); " of "; RTRIM$(player(r).country); ", what do you do?"
    LOCATE 21, 1: PRINT "(Move/Buy/Attack/Equip a Weapon/View stats/Clear)"
    DO
        do$ = INKEY$
        do$ = LCASE$(do$)
    LOOP UNTIL do$ = "m" OR do$ = "b" OR do$ = "a" OR do$ = "e" OR do$ = "v" OR do$ = "c"
    DoMove
END SUB

SUB Instructions
    CLS : COLOR 15: LOCATE 2, 1
    PRINT "   The first thing this game will ask you for is how many players"
    PRINT "there are.  There may be two through five players.  Then you will"
    PRINT "be asked what your color is.  The following are the different colors:"
    y = 1
    FOR x = 2 TO 14
        LOCATE 5, y
        COLOR x
        PRINT x             'Shows all of the colors in a row
        y = y + 5
    NEXT
    COLOR 15: LOCATE 6, 1
    PRINT "Choose and remember your color now because you will need it later."
    PRINT "After your colors are chosen, you will be asked what the players"
    PRINT "names and countries are.  These do not matter.  Then you will create"
    PRINT "your characters.  This is a complicated process.  First, you will be"
    PRINT "asked how many attack points you want.  The higher your attack points,"
    PRINT "the stronger your attack.  Then, you will be asked how many defense"
    PRINT "points you want.  The higher your defense, the greater chance of"
    PRINT "blocking an attack.  After that, you will be asked how many HP you"
    PRINT "want.  The higher the HP, the longer you will live.  Last, you are"
    PRINT "asked how many movement points you want.  The higher the movement,"
    PRINT "the faster you travel in combat."
    PRINT "   After you create the characters, you view them.  Then a map will"
    PRINT "be drawn and you are asked what to do.  Moving helps expand your"
    PRINT "nation and building fills the territories with towns, castles, etc."
    PRINT "You should attack a country if the country you attack with is strong"
    PRINT "enough.  Viewing stats is a way to keep track of how"
    PRINT "strong your nation is."
    Center 24, "Hit Any Key to Continue"
    WHILE INKEY$ = "": WEND
END SUB

SUB Introduction
    SCREEN 0
    CLS
    COLOR 15: Center 2, "C A S T L E S"
    COLOR 9: Center 3, "Ver.  1.2"
    COLOR 13: Center 4, "Designed and Written by: Chad Austin"
    COLOR 14: PRINT
    PRINT
    PRINT
    PRINT "   Castles is a game in which two to five players try to conquer the"
    PRINT "world by moving to empty territories, attacking occupied territories, and"
    PRINT "building in their own territories.  If a player attacks and destroys"
    PRINT "another player's home territory, then the game is over for the destroyed"
    PRINT "player.  After one person destroys every other player, he/she wins."
    Center 23, "Do you want instructions? (Y/N)"
    DO
        kbd$ = INKEY$
        kbd$ = UCASE$(kbd$)
    LOOP UNTIL kbd$ = "Y" OR kbd$ = "N"
    IF kbd$ = "Y" THEN Instructions
END SUB

SUB NoMoney
    PRINT "That territory does not have enough money."
    moves = moves - 1
    WHILE INKEY$ = "": WEND
END SUB

SUB PaintLand (pnt, we)
    SELECT CASE pnt
        CASE 1: PAINT (30, 30), we, 0
        CASE 2: PAINT (40, 20), we, 0
        CASE 3: PAINT (80, 20), we, 0
        CASE 4: PAINT (120, 20), we, 0
        CASE 5: PAINT (110, 70), we, 0
        CASE 6: PAINT (100, 50), we, 0
        CASE 7: PAINT (69, 80), we, 0
        CASE 8: PAINT (45, 80), we, 0
        CASE 9: PAINT (45, 60), we, 0
        CASE 10: PAINT (61, 40), we, 0
        CASE 11: PAINT (30, 150), we, 0
        CASE 12: PAINT (30, 180), we, 0
        CASE 13: PAINT (30, 240), we, 0
        CASE 14: PAINT (60, 240), we, 0
        CASE 15: PAINT (90, 270), we, 0
        CASE 16: PAINT (310, 270), we, 0
        CASE 17: PAINT (340, 270), we, 0
        CASE 18: PAINT (340, 245), we, 0
        CASE 19: PAINT (345, 245), we, 0
        CASE 20: PAINT (317, 230), we, 0
        CASE 21: PAINT (350, 100), we, 0
        CASE 22: PAINT (200, 50), we, 0
        CASE 23: PAINT (250, 30), we, 0
        CASE 24: PAINT (290, 30), we, 0
        CASE 25: PAINT (200, 80), we, 0
        CASE 26: PAINT (250, 79), we, 0
        CASE 27: PAINT (280, 80), we, 0
        CASE 28: PAINT (300, 80), we, 0
        CASE 29: PAINT (250, 81), we, 0
        CASE 30: PAINT (155, 90), we, 0
        CASE 31: PAINT (170, 100), we, 0
        CASE 32: PAINT (250, 100), we, 0
        CASE 33: PAINT (280, 120), we, 0
        CASE 34: PAINT (310, 125), we, 0
        CASE 35: PAINT (105, 100), we, 0
        CASE 36: PAINT (150, 120), we, 0
        CASE 37: PAINT (230, 150), we, 0
        CASE 38: PAINT (250, 150), we, 0
        CASE 39: PAINT (300, 149), we, 0
        CASE 40: PAINT (350, 149), we, 0
        CASE 41: PAINT (100, 145), we, 0
        CASE 42: PAINT (130, 160), we, 0
        CASE 43: PAINT (160, 160), we, 0
        CASE 44: PAINT (200, 160), we, 0
        CASE 45: PAINT (245, 180), we, 0
        CASE 46: PAINT (290, 190), we, 0
        CASE 47: PAINT (330, 170), we, 0
        CASE 48: PAINT (350, 200), we, 0
        CASE 49: PAINT (330, 200), we, 0
        CASE 50: PAINT (270, 220), we, 0
        CASE 51: PAINT (250, 250), we, 0
        CASE 52: PAINT (220, 220), we, 0
        CASE 53: PAINT (220, 240), we, 0
        CASE 54: PAINT (160, 200), we, 0
        CASE 55: PAINT (160, 220), we, 0
        CASE 56: PAINT (160, 250), we, 0
        CASE 57: PAINT (100, 240), we, 0
        CASE 58: PAINT (100, 170), we, 0
        CASE 59: PAINT (80, 150), we, 0
        CASE 60: PAINT (80, 200), we, 0
    END SELECT
END SUB

SUB PlayCastles
    DrawScreen
    GetHome
    DO
        FOR r = 1 TO NumPlayers
            IF player(r).alive = true THEN
                FOR moves = 1 TO 3
                    PrintStats
                    ClearScreen
                    GetMove
                NEXT
            END IF
        NEXT
    LOOP
END SUB

SUB PrintStats
    ChangeStats
    COLOR player(r).clr
    LOCATE 2, 59: PRINT "Player"; r; SPACE$(10)       ' Prints character stats
    LOCATE 5, 53: PRINT "People:"; player(r).people; SPACE$(10)
    LOCATE 6, 53: PRINT "Land:"; player(r).land; SPACE$(10)
    LOCATE 7, 53: PRINT "Swords:"; player(r).sword; SPACE$(10)
    LOCATE 8, 53: PRINT "Axes:"; player(r).axe; SPACE$(10)
    LOCATE 9, 53: PRINT "Spears:"; player(r).spear; SPACE$(10)
    LOCATE 10, 53: PRINT "Bows:"; player(r).bow; SPACE$(10)
    LOCATE 11, 53: PRINT "Attack:"; player(r).attack; SPACE$(10)
    LOCATE 12, 53: PRINT "Defense:"; player(r).defense; SPACE$(10)
    LOCATE 13, 53: PRINT "HP:"; player(r).HP; SPACE$(10)
    LOCATE 14, 53: PRINT "Move:"; player(r).move; SPACE$(10)
    LOCATE 15, 53: PRINT "Title: "; player(r).title
    LOCATE 16, 53: PRINT "Country: "; player(r).ctitle
    LOCATE 17, 53: PRINT "Turns left:"; 4 - moves; SPACE$(10)
END SUB

SUB Purchase
    SELECT CASE buy$
    CASE "castle"
        IF terr(purc).money >= 150 THEN
            terr(purc).money = terr(purc).money - 150
            terr(purc).defense = terr(purc).defense + 5
            terr(purc).MaxHP = terr(purc).MaxHP + 5
            terr(purc).HP = terr(purc).HP + 5
            terr(purc).castle = terr(purc).castle + 1
        ELSE
            NoMoney
        END IF
    CASE "fort"
        IF terr(purc).money >= 250 THEN
            terr(purc).money = terr(purc).money - 250
            terr(purc).defense = terr(purc).defense + 6
            terr(purc).MaxHP = terr(purc).MaxHP + 7
            terr(purc).HP = terr(purc).HP + 7
            terr(purc).fort = terr(purc).fort + 1
        ELSE
            NoMoney
        END IF
    CASE "town"
        IF terr(purc).money >= 100 THEN
            terr(purc).money = terr(purc).money - 100
            terr(purc).defense = terr(purc).defense + 3
            terr(purc).MaxHP = terr(purc).MaxHP + 2
            terr(purc).HP = terr(purc).HP + 2
            terr(purc).town = terr(purc).town + 1
            player(r).people = player(r).people + 25
        ELSE
            NoMoney
        END IF
    CASE "cannons"
        IF terr(purc).money >= 100 THEN
            terr(purc).money = terr(purc).money - 100
            terr(purc).attack = terr(purc).attack + 5
            terr(purc).defense = terr(purc).defense + 2
            terr(purc).MaxHP = terr(purc).MaxHP + 3
            terr(purc).HP = terr(purc).HP + 3
            terr(purc).cannon = terr(purc).cannon + 1
        ELSE
            NoMoney
        END IF
    CASE "dock"
        IF terr(purc).water = true THEN
            IF terr(purc).dock = 0 THEN
                IF terr(purc).money >= 100 THEN
                    terr(purc).money = terr(purc).money - 100
                    terr(purc).defense = terr(purc).defense + 4
                    terr(purc).MaxHP = terr(purc).MaxHP + 2
                    terr(purc).HP = terr(purc).HP + 2
                    terr(purc).dock = 1
                ELSE
                    NoMoney
                END IF
            ELSE
                PRINT "One dock is enough for a territory."
                moves = moves - 1
            END IF
        ELSE
            PRINT "That territory is not by water."
            moves = moves - 1
            WHILE INKEY$ = "": WEND
        END IF
    CASE "ship"
        IF terr(purc).dock = 1 THEN
            IF terr(purc).money >= 50 THEN
                terr(purc).money = terr(purc).money - 50
                terr(purc).attack = terr(purc).attack + 5
                terr(purc).defense = terr(purc).defense + 3
                terr(purc).MaxHP = terr(purc).MaxHP + 2
                terr(purc).HP = terr(purc).HP + 2
                terr(purc).move = terr(purc).move + 7
                terr(purc).ship = terr(purc).ship + 1
            ELSE
                NoMoney
            END IF
        ELSE
            PRINT "That territory does not have a dock."
            moves = moves - 1
        END IF
    CASE "soldiers"
        IF terr(purc).money >= 50 THEN
            terr(purc).money = terr(purc).money - 50
            terr(purc).attack = terr(purc).attack + 2
            terr(purc).defense = terr(purc).defense + 2
            terr(purc).MaxHP = terr(purc).MaxHP + 7
            terr(purc).HP = terr(purc).HP + 7
            terr(purc).move = terr(purc).move + 6
            terr(purc).soldier = terr(purc).soldier + 10
            player(r).people = player(r).people + 10
        ELSE
            NoMoney
        END IF
    CASE "knights"
        IF terr(purc).money >= 100 THEN
            terr(purc).money = terr(purc).money - 100
            terr(purc).attack = terr(purc).attack + 3
            terr(purc).defense = terr(purc).defense + 3
            terr(purc).MaxHP = terr(purc).MaxHP + 8
            terr(purc).HP = terr(purc).HP + 8
            terr(purc).move = terr(purc).move + 5
            terr(purc).knight = terr(purc).knight + 10
            player(r).people = player(r).people + 10
        ELSE
            NoMoney
        END IF
    CASE "cavalry"
        IF terr(purc).money >= 150 THEN
            terr(purc).money = terr(purc).money - 150
            terr(purc).attack = terr(purc).attack + 4
            terr(purc).defense = terr(purc).defense + 3
            terr(purc).MaxHP = terr(purc).MaxHP + 12
            terr(purc).HP = terr(purc).HP + 12
            terr(purc).move = terr(purc).move + 10
            terr(purc).cavalry = terr(purc).cavalry + 10
            player(r).people = player(r).people + 10
        ELSE
            NoMoney
        END IF
    END SELECT
    RaiseHP
END SUB

SUB RaiseHP
    FOR x = 1 TO 60
        terr(x).HP = terr(x).HP + 2
        IF terr(x).HP > terr(x).MaxHP THEN terr(x).HP = terr(x).MaxHP
    NEXT x
END SUB

SUB ShowEnd
    CLS
    FOR x = 1 TO NumPlayers
        IF player(x).alive = true THEN a = x
    NEXT x
    a$ = "Player" + STR$(a) + " conquered the world with" + STR$(player(a).land) + " territories and" + STR$(player(a).people) + " people!!!"
    b$ = RTRIM$(player(a).nam) + " of " + RTRIM$(player(a).country) + " was a " + RTRIM$(player(a).title) + " ruling a " + RTRIM$(player(a).ctitle) + "."
    Center 12, a$
    Center 13, b$
    END
END SUB

SUB ViewChar
    FOR x = 1 TO NumPlayers
        CLS
        COLOR player(x).clr: LOCATE 2, 35: PRINT "Player"; x
        LOCATE 3, 2: PRINT "NAME: "; player(x).nam
        LOCATE 4, 2: PRINT "COUNTRY: "; player(x).country
        LOCATE 5, 2: PRINT "LAND: "; player(x).land
        LOCATE 6, 2: PRINT "PEOPLE: "; player(x).people
        LOCATE 3, 28: PRINT "ATTACK: "; player(x).attack
        LOCATE 4, 28: PRINT "DEFENSE: "; player(x).defense
        LOCATE 5, 28: PRINT "HIT POINTS: "; player(x).HP
        LOCATE 6, 28: PRINT "MOVE: "; player(x).move
        LOCATE 3, 64: PRINT "SWORDS: "; player(x).sword
        LOCATE 4, 64: PRINT "AXES: "; player(x).axe
        LOCATE 5, 64: PRINT "SPEARS: "; player(x).spear
        LOCATE 6, 64: PRINT "BOWS: "; player(x).bow
        LOCATE 7, 26: PRINT "You are a "; player(x).title
        LOCATE 8, 26: PRINT "You rule a "; player(x).ctitle
        WHILE INKEY$ = "": WEND
    NEXT
END SUB

