DEFINT A-Z
DECLARE FUNCTION canuse (user$, char%)
DECLARE FUNCTION getstring$ (row%, col%, text$, length%)
DECLARE SUB armorstats ()
DECLARE SUB beginstats ()
DECLARE SUB center (row%, text$)
DECLARE SUB dividepoints (x%)
DECLARE SUB drawboard ()
DECLARE SUB enemystats ()
DECLARE SUB getboard (x%, y%)
DECLARE SUB getchar ()
DECLARE SUB intro ()
DECLARE SUB playknights ()
DECLARE SUB scenter (row%, text$)
DECLARE SUB weaponstats ()
TYPE handtype
 item AS INTEGER
 num  AS INTEGER
 amnt AS INTEGER
END TYPE
TYPE immediatetype
 hitper  AS INTEGER
 dodge   AS INTEGER
 attack  AS INTEGER
 defense AS INTEGER
 magdef  AS INTEGER
 speed   AS INTEGER
 climb   AS INTEGER
 ceiling AS INTEGER
 jump    AS INTEGER
END TYPE
TYPE playertype
 nam     AS STRING * 14
 job     AS STRING * 6
 race    AS STRING * 10
 gender  AS STRING * 6
 sym     AS STRING * 1
 str     AS INTEGER
 agi     AS INTEGER
 intl    AS INTEGER
 cha     AS INTEGER
 wea     AS INTEGER
 pow     AS INTEGER
 hp      AS INTEGER
 mp      AS INTEGER
 maxhp   AS INTEGER
 maxmp   AS INTEGER
 status  AS INTEGER
 gold    AS INTEGER
 expr    AS INTEGER
 level   AS INTEGER
 climb   AS INTEGER
 ceiling AS INTEGER
 jump    AS INTEGER
 rhand   AS handtype
 lhand   AS handtype
 head    AS INTEGER
 body    AS INTEGER
 arms    AS INTEGER
 feet    AS INTEGER
 col     AS INTEGER
 row     AS INTEGER
 xscreen AS INTEGER
 yscreen AS INTEGER
 points  AS INTEGER
 imm     AS immediatetype
 sheath  AS INTEGER
END TYPE
TYPE skilltype
 att  AS INTEGER
 dfn  AS INTEGER
 sta  AS INTEGER
 spd  AS INTEGER
 dge  AS INTEGER
 hit  AS INTEGER
 clm  AS INTEGER
 jmp  AS INTEGER
 clg  AS INTEGER
 src  AS INTEGER
 lng  AS INTEGER
 mag  AS INTEGER
 chm  AS INTEGER
 cnv  AS INTEGER
 lur  AS INTEGER
 bld  AS INTEGER
 axe  AS INTEGER
 bow  AS INTEGER
 spr  AS INTEGER
 rop  AS INTEGER
 stf  AS INTEGER
 hpup AS INTEGER
 mpup AS INTEGER
 skup AS INTEGER
END TYPE
TYPE enemytype
 sym     AS STRING * 1
 nam     AS STRING * 18
 att     AS INTEGER
 hp      AS INTEGER
 speed   AS INTEGER
 goldup  AS INTEGER
 expup   AS INTEGER
 climb   AS INTEGER
 jump    AS INTEGER
 ceiling AS INTEGER
 range   AS INTEGER
 float   AS INTEGER
 charm   AS INTEGER
 dodge   AS INTEGER
 fly     AS INTEGER
 spell1  AS INTEGER
 spell2  AS INTEGER
END TYPE
TYPE weapontype
 attack AS INTEGER
 typ    AS SINGLE
 nam    AS STRING * 14
 range  AS INTEGER
 spell  AS INTEGER
 users  AS STRING * 6
END TYPE
TYPE armortype
 defense AS INTEGER
 nam     AS STRING * 17
 magdef  AS INTEGER
 users   AS STRING * 6
 typ     AS INTEGER
END TYPE
 OPTION BASE 1
 DIM SHARED player(4) AS playertype, skill(4) AS skilltype
 DIM SHARED weapon(88) AS weapontype, armor(86) AS armortype
 DIM SHARED enemy(26) AS enemytype, backpack(4, 5) AS handtype
 DIM SHARED charspell(4, 43), backclr(-1 TO 1, -1 TO 1, 40, 35)
 DIM SHARED rope(-1 TO 1, -1 TO 1, 40, 35), element(-1 TO 1, -1 TO 1, 40, 35)
 DIM SHARED speed, mode
 KEY 15, CHR$(0) + CHR$(69)
 KEY(15) ON
 DEF SEG = 0
 KeyFlags = PEEK(1047)
 IF (KeyFlags AND 32) = 32 THEN POKE 1047, KeyFlags XOR 32
 DEF SEG
 GOSUB checkdimen
 GOSUB getspeed
 intro
 getchar
 beginstats
 weaponstats
 armorstats
 enemystats
 drawboard
 playknights
 GOSUB restorenumlock
 CLS
 END
 DEF fncut$ (x) = LTRIM$(STR$(x))
checkdimen:
 ON ERROR GOTO adaptererror
 WIDTH 40, 43
 SCREEN 0, , 7, 7
 SCREEN 0, , 0, 0
 WIDTH 80, 25
 ON ERROR GOTO 0
 mode = 13
 ON ERROR GOTO screenerror
 SCREEN 13
 SCREEN 0
 ON ERROR GOTO 0
RETURN
getspeed:
 start# = TIMER
 FOR x! = 1 TO 2000: NEXT
 speed = 2000 / (TIMER - start#)
RETURN
adaptererror:
 center 12, "You need a higher screen memory adapters to play Knights and Ninjas."
 END
screenerror:
 mode = 1
 ON ERROR GOTO cgaerror
 SCREEN 1
 COLOR 4
 SCREEN 0
 ON ERROR GOTO 0
RESUME
cgaerror:
 mode = 0
RESUME
restorenumlock:
 KEY(15) OFF
 DEF SEG = 0
 IF (KeyFlags AND 32) = 32 THEN POKE 1047, KeyFlags AND 32
 DEF SEG
RETURN

SUB armorstats
  FOR x = 1 TO 26
    armor(x).typ = body
  NEXT

  armor(1).nam = "Clothes"
  armor(1).defense = 2
  armor(1).users = "all"

  armor(2).nam = "Leather Armor"
  armor(2).defense = 5
  armor(2).magdef = 1
  armor(2).users = "all"

  armor(3).nam = "Chain Mail"
  armor(3).defense = 7
  armor(3).users = "KNSAM"

  armor(4).nam = "Steel Armor"
  armor(4).defense = 10
  armor(4).users = "KAM"

  armor(5).nam = "Dark Armor"
  armor(5).defense = 12
  armor(5).magdef = 3
  armor(5).users = "KAS"

  armor(6).nam = "Silver Armor"
  armor(6).defense = 15
  armor(6).users = "KAM"

  armor(7).nam = "Golden Armor"
  armor(7).defense = 20
  armor(7).magdef = 5
  armor(7).users = "KA"

  armor(8).nam = "Knight Armor"
  armor(8).defense = 25
  armor(8).magdef = 7
  armor(8).users = "K"

  armor(9).nam = "Combat Armor"
  armor(9).defense = 27
  armor(9).users = "KNA"

  armor(10).nam = "Dragon Scales"
  armor(10).defense = 45
  armor(10).magdef = 10
  armor(10).users = "KN"
 
  armor(11).nam = "Heavy Armor"
  armor(11).defense = 50
  armor(11).users = "K"
        
  armor(12).nam = "Mystic Armor"
  armor(12).defense = 57
  armor(12).magdef = 15
  armor(12).users = "K"

  armor(13).nam = "Fire Armor"
  armor(13).defense = 35
  armor(13).magdef = 5
  armor(13).users = "KNAM"
 
  armor(14).nam = "Ice Armor"
  armor(14).defense = 35
  armor(14).magdef = 5
  armor(14).users = "KNAM"

  armor(15).nam = "Lord Armor"
  armor(15).defense = 60
  armor(15).magdef = 20
  armor(15).users = "K"

  armor(16).nam = "Agility Armor"
  armor(16).defense = 45
  armor(16).magdef = 5
  armor(16).users = "KN"

  armor(17).nam = "Ninja Armor"
  armor(17).defense = 55
  armor(17).magdef = 12
  armor(17).users = "NS"

  armor(18).nam = "Diamond Armor"
  armor(18).defense = 65
  armor(18).users = "K"

  armor(19).nam = "Spiked Armor"
  armor(19).defense = 70
  armor(19).users = "K"

  armor(20).nam = "Ultra Armor"
  armor(20).defense = 75
  armor(20).magdef = 25
  armor(20).users = "K"

  armor(21).nam = "Crystal Armor"
  armor(21).defense = 85
  armor(21).magdef = 30
  armor(21).users = "K"

  armor(22).nam = "Cloak"
  armor(22).defense = 7
  armor(22).magdef = 5
  armor(22).users = "all"

  armor(23).nam = "Mage Cloak"
  armor(23).defense = 10
  armor(23).magdef = 8
  armor(23).users = "NAMW"

  armor(24).nam = "Wizard Cloak"
  armor(24).defense = 15
  armor(24).magdef = 25
  armor(24).users = "MW"

  armor(25).nam = "Dark Cloak"
  armor(25).defense = 15
  armor(25).magdef = 15
  armor(25).users = "NS"
 
  armor(26).nam = "Grey Cloak"
  armor(26).defense = 20
  armor(26).magdef = 35
  armor(26).users = "W"
END SUB

SUB beginstats
  player(1).col = 23
  player(2).col = 24
  player(3).col = 25
  player(4).col = 26
  FOR x = 1 TO 4
    player(x).points = 75
    player(x).row = 29
  NEXT
  FOR x = 1 TO 4
    SELECT CASE RTRIM$(player(x).race)
    CASE "Human"
      player(x).str = player(x).str + 6
        skill(x).att = 3
        skill(x).dfn = 1
        skill(x).sta = 2
      player(x).agi = player(x).agi + 6
        skill(x).spd = 2
        skill(x).hit = 2
        skill(x).clm = 1
        skill(x).clg = 1
      player(x).intl = player(x).intl + 6
        skill(x).src = 2
        skill(x).lng = 3
        skill(x).mag = 1
      player(x).cha = player(x).cha + 6
        skill(x).chm = 1
        skill(x).cnv = 3
        skill(x).lur = 2
      player(x).wea = player(x).wea + 3
        skill(x).bld = 2
        skill(x).stf = 1
      player(x).pow = player(x).pow + 3
        skill(x).hpup = 1
        skill(x).mpup = 1
        skill(x).skup = 1
    CASE "Dwarf"
      player(x).str = player(x).str + 12
        skill(x).att = 6
        skill(x).dfn = 2
        skill(x).sta = 4
      player(x).agi = player(x).agi + 3
        skill(x).spd = 1
        skill(x).hit = 2
      player(x).intl = player(x).intl + 3
        skill(x).src = 1
        skill(x).lng = 2
      player(x).wea = player(x).wea + 12
        skill(x).bld = 4
        skill(x).axe = 6
        skill(x).spr = 2
    CASE "Elf"
      player(x).agi = player(x).agi + 6
        skill(x).spd = 3
        skill(x).hit = 3
      player(x).intl = player(x).intl + 9
        skill(x).src = 2
        skill(x).lng = 1
        skill(x).mag = 6
      player(x).cha = player(x).cha + 3
        skill(x).chm = 1
        skill(x).cnv = 1
        skill(x).lur = 1
      player(x).wea = player(x).wea + 6
        skill(x).bld = 2
        skill(x).bow = 2
        skill(x).stf = 2
      player(x).pow = player(x).pow + 6
        skill(x).hpup = 3
        skill(x).mpup = 2
        skill(x).skup = 1
    CASE "1/2 Dragon"
      player(x).str = player(x).str + 3
        skill(x).att = 2
        skill(x).sta = 1
      player(x).agi = player(x).agi + 9
        skill(x).spd = 3
        skill(x).hit = 4
        skill(x).clm = 1
        skill(x).clg = 1
      player(x).intl = player(x).intl + 3
        skill(x).mag = 3
      player(x).cha = player(x).cha + 3
        skill(x).chm = 1
        skill(x).cnv = 1
        skill(x).lur = 1
      player(x).wea = player(x).wea + 6
        skill(x).bld = 2
        skill(x).spr = 4
      player(x).pow = player(x).pow + 6
        skill(x).hpup = 4
        skill(x).mpup = 1
        skill(x).skup = 1
    CASE "1/2 Orc"
      player(x).str = player(x).str + 12
        skill(x).att = 6
        skill(x).dfn = 3
        skill(x).sta = 3
      player(x).agi = player(x).agi + 6
        skill(x).spd = 3
        skill(x).hit = 2
        skill(x).clm = 1
      player(x).intl = player(x).intl + 3
        skill(x).src = 2
        skill(x).lng = 1
      player(x).wea = player(x).wea + 9
        skill(x).bld = 4
        skill(x).axe = 3
        skill(x).spr = 1
        skill(x).bow = 1
    END SELECT
    skill(x).sta = skill(x).sta + 1
    skill(x).skup = skill(x).skup + 1
    SELECT CASE RTRIM$(player(x).gender)
    CASE "Male"
      player(x).str = player(x).str + 2
        skill(x).att = skill(x).att + 1
      player(x).agi = player(x).agi + 2
        skill(x).spd = skill(x).spd + 2
      player(x).intl = player(x).intl + 2
        skill(x).mag = skill(x).mag + 2
      player(x).cha = player(x).cha + 1
        skill(x).cnv = skill(x).cnv + 1
      player(x).wea = player(x).wea + 2
        skill(x).axe = skill(x).axe + 1
        skill(x).bow = skill(x).bow + 1
      player(x).pow = player(x).pow + 1
    CASE "Female"
      player(x).str = player(x).str + 1
      player(x).agi = player(x).agi + 1
        skill(x).spd = skill(x).spd + 1
      player(x).intl = player(x).intl + 2
        skill(x).mag = skill(x).mag + 2
      player(x).cha = player(x).cha + 3
        skill(x).chm = skill(x).chm + 2
        skill(x).lur = skill(x).lur + 1
      player(x).wea = player(x).wea + 1
        skill(x).rop = skill(x).rop + 1
      player(x).pow = player(x).pow + 2
        skill(x).mpup = skill(x).mpup + 1
    END SELECT
    player(x).rhand.item = wea
    player(x).rhand.num = 1
    SELECT CASE RTRIM$(player(x).job)
    CASE "Knight"
      player(x).hp = 300
      player(x).maxhp = 300
      player(x).str = player(x).str + 10
        skill(x).att = skill(x).att + 5
        skill(x).dfn = skill(x).dfn + 1
        skill(x).sta = skill(x).sta + 4
      player(x).agi = player(x).agi + 5
        skill(x).spd = skill(x).spd + 1
        skill(x).hit = skill(x).hit + 3
        skill(x).dge = skill(x).dge + 1
      player(x).intl = player(x).intl + 5
        skill(x).src = skill(x).src + 3
        skill(x).lng = skill(x).lng + 1
        skill(x).mag = skill(x).mag + 1
      player(x).wea = player(x).wea + 10
        skill(x).bld = skill(x).bld + 4
        skill(x).axe = skill(x).axe + 3
        skill(x).spr = skill(x).spr + 2
        skill(x).bow = skill(x).bow + 1
    CASE "Ninja"
      player(x).hp = 250
      player(x).maxhp = 250
      player(x).mp = 50
      player(x).maxmp = 50
      player(x).agi = player(x).agi + 15
        skill(x).spd = skill(x).spd + 4
        skill(x).hit = skill(x).hit + 5
        skill(x).dge = skill(x).dge + 2
        skill(x).clm = skill(x).clm + 2
        skill(x).jmp = skill(x).jmp + 1
        skill(x).clg = skill(x).clg + 1
      player(x).intl = player(x).intl + 5
        skill(x).src = skill(x).src + 1
        skill(x).lng = skill(x).lng + 1
        skill(x).mag = skill(x).mag + 3
      player(x).wea = player(x).wea + 5
        skill(x).bld = skill(x).bld + 3
        skill(x).spr = skill(x).spr + 2
      player(x).pow = player(x).pow + 5
        skill(x).hpup = skill(x).hpup + 2
        skill(x).mpup = skill(x).mpup + 2
        skill(x).skup = skill(x).skup + 1
    CASE "Spy"
      player(x).hp = 175
      player(x).maxhp = 175
      player(x).mp = 125
      player(x).maxmp = 125
      player(x).agi = player(x).agi + 15
        skill(x).spd = skill(x).spd + 5
        skill(x).hit = skill(x).hit + 4
        skill(x).dge = skill(x).dge + 2
        skill(x).clm = skill(x).clm + 2
        skill(x).jmp = skill(x).jmp + 1
        skill(x).clg = skill(x).clg + 1
      player(x).intl = player(x).intl + 10
        skill(x).src = skill(x).src + 2
        skill(x).lng = skill(x).lng + 1
        skill(x).mag = skill(x).mag + 7
      player(x).cha = player(x).cha + 5
        skill(x).chm = skill(x).chm + 2
        skill(x).cnv = skill(x).cnv + 2
        skill(x).lur = skill(x).lur + 1
    CASE "Archer"
      player(x).hp = 225
      player(x).maxhp = 225
      player(x).mp = 75
      player(x).maxmp = 75
      player(x).str = player(x).str + 10
        skill(x).att = skill(x).att + 4
        skill(x).dfn = skill(x).dfn + 2
        skill(x).sta = skill(x).sta + 4
      player(x).agi = player(x).agi + 5
        skill(x).spd = skill(x).spd + 2
        skill(x).hit = skill(x).hit + 2
        skill(x).clm = skill(x).clm + 1
      player(x).intl = player(x).intl + 5
        skill(x).src = skill(x).src + 1
        skill(x).lng = skill(x).lng + 1
        skill(x).mag = skill(x).mag + 3
      player(x).cha = player(x).cha + 5
        skill(x).chm = skill(x).chm + 1
        skill(x).cnv = skill(x).cnv + 2
        skill(x).lur = skill(x).lur + 2
      player(x).wea = player(x).wea + 5
        skill(x).bow = skill(x).bow + 3
        skill(x).rop = skill(x).rop + 2
    CASE "Mage"
      player(x).hp = 200
      player(x).maxhp = 200
      player(x).mp = 100
      player(x).maxmp = 100
      player(x).str = player(x).str + 5
        skill(x).att = skill(x).att + 2
        skill(x).sta = skill(x).sta + 3
      player(x).intl = player(x).intl + 10
        skill(x).src = skill(x).src + 1
        skill(x).lng = skill(x).lng + 2
        skill(x).mag = skill(x).mag + 7
      player(x).wea = player(x).wea + 5
        skill(x).bld = skill(x).bld + 2
        skill(x).stf = skill(x).stf + 3
      player(x).pow = player(x).pow + 10
        skill(x).hpup = skill(x).hpup + 5
        skill(x).mpup = skill(x).mpup + 4
        skill(x).skup = skill(x).skup + 1
    CASE "Wizard"
      player(x).hp = 125
      player(x).maxhp = 125
      player(x).mp = 175
      player(x).maxmp = 175
      player(x).intl = player(x).intl + 15
        skill(x).src = skill(x).src + 2
        skill(x).lng = skill(x).lng + 1
        skill(x).mag = skill(x).mag + 12
      player(x).pow = player(x).pow + 15
        skill(x).hpup = skill(x).hpup + 6
        skill(x).mpup = skill(x).mpup + 8
        skill(x).skup = skill(x).skup + 1
    END SELECT
    dividepoints (x)
  NEXT
END SUB

FUNCTION canuse (user$, char)
  IF UCASE$(RTRIM$(user$)) = "ALL" THEN
    canuse = 1
  ELSE
    canuse = 0
    FOR x = 1 TO LEN(RTRIM$(user$))
      IF MID$(UCASE$(RTRIM$(user$)), x, 1) = player(char).sym THEN
        canuse = 1
      END IF
    NEXT
  END IF
END FUNCTION

SUB center (row, text$)
  LOCATE row, 40 - (LEN(text$) / 2 + .5)
  PRINT text$
END SUB

SUB dividepoints (x AS INTEGER)
  DIM stat(4, 4 TO 9)
  DIM Max(4 TO 9)
  DIM help$(4 TO 9)
  DIM skillHelp$(6)
  DIM points(6)
  DIM actSkill(4 TO 9)  AS STRING
  DIM bottom(6)
  DIM maxSkill(6, 4 TO 9)
  DIM skillNum(4, 6, 4 TO 9)
  FOR a = 1 TO 6
    IF a = 2 OR a = 5 THEN bottom(a) = 9 ELSE bottom(a) = 6
  NEXT
  skillHelp$(1) = "Strength"
  skillHelp$(2) = "Agility"
  skillHelp$(3) = "Intelligence"
  skillHelp$(4) = "Charisma"
  skillHelp$(5) = "Weapons"
  skillHelp$(6) = "Power"
  DO
    Max(4) = 50 - player(x).str
    Max(5) = 60 - player(x).agi
    Max(6) = 30 - player(x).intl
    Max(7) = 25 - player(x).cha
    Max(8) = 60 - player(x).wea
    Max(9) = 40 - player(x).pow
    help$(4) = "Attack " + fncut$((skill(x).att)) + "/20, Defend " + fncut$((skill(x).dfn)) + "/20, Stamina " + fncut$((skill(x).sta)) + "/10"
    help$(5) = "Speed " + fncut$((skill(x).spd)) + "/10, Dodge " + fncut$((skill(x).dge)) + "/10, Accuracy " + fncut$((skill(x).hit)) + "/19, Climb " + fncut$((skill(x).clm)) + "/10, Jump " + fncut$((skill(x).jmp)) + "/4, Ceiling " + fncut$((skill(x).clg)) + "/7"
    help$(6) = "Search " + fncut$((skill(x).src)) + "/5, Languages " + fncut$((skill(x).lng)) + "/5, Magic " + fncut$((skill(x).mag)) + "/20"
    help$(7) = "Charm " + fncut$((skill(x).chm)) + "/5, Convince " + fncut$((skill(x).cnv)) + "/15, Lure " + fncut$((skill(x).lur)) + "/5"
    help$(8) = "Blades " + fncut$((skill(x).bld)) + "/10, Axes " + fncut$((skill(x).axe)) + "/10, Bows " + fncut$((skill(x).bow)) + "/10, Spears " + fncut$((skill(x).spr)) + "/10, Whips " + fncut$((skill(x).rop)) + "/10, Staffs " + fncut$((skill(x).stf)) + "/10"
    help$(9) = "HP up " + fncut$((skill(x).hpup)) + "/25, MP up " + fncut$((skill(x).mpup)) + "/12, Skill up " + fncut$((skill(x).skup)) + "/3"
    row = 4
    CLS
    COLOR 13
    LOCATE 4, 1: PRINT "NAME:   "; player(x).nam
    PRINT "JOB:    "; player(x).job
    PRINT "RACE:   "; player(x).race
    PRINT "GENDER: "; player(x).gender
    LOCATE 11, 1: PRINT "(Use the arrow keys to move the cursor, hit "; CHR$(34); "+"; CHR$(34); " and "; CHR$(34); "-"; CHR$(34);
    PRINT "to distribute points among the attributes.  Hit enter to finish.)"
    DO
      COLOR 15
      LOCATE 2, 30: PRINT "REMAINING POINTS:"; player(x).points
      COLOR 9
      LOCATE 4, 25: PRINT "Strength:     "; player(x).str + stat(x, 4); "/ 50       "
      LOCATE 5, 25: PRINT "Agility:      "; player(x).agi + stat(x, 5); "/ 60       "
      LOCATE 6, 25: PRINT "Intelligence: "; player(x).intl + stat(x, 6); "/ 30      "
      LOCATE 7, 25: PRINT "Charisma:     "; player(x).cha + stat(x, 7); "/ 25       "
      LOCATE 8, 25: PRINT "Weapons:      "; player(x).wea + stat(x, 8); "/ 60       "
      LOCATE 9, 25: PRINT "Power:        "; player(x).pow + stat(x, 9); "/ 40       "
      COLOR 12
      center 15, (help$(row))
      COLOR 15
      LOCATE row, 23: PRINT ""
      DO: kbd$ = INKEY$: LOOP UNTIL kbd$ <> ""
      SELECT CASE kbd$
      CASE CHR$(0) + "H"
        LOCATE row, 23: PRINT " "
        row = row - 1
        IF row = 3 THEN row = 9
        LOCATE row, 23: PRINT ""
        center 15, SPACE$(73)
      CASE CHR$(0) + "P"
        LOCATE row, 23: PRINT " "
        row = row + 1
        IF row = 10 THEN row = 4
        LOCATE row, 23: PRINT ""
        center 15, SPACE$(73)
      CASE "+", "=", CHR$(0) + "M"
        IF player(x).points > 0 AND stat(x, row) < Max(row) THEN
          stat(x, row) = stat(x, row) + 1
          player(x).points = player(x).points - 1
        END IF
      CASE "-", "_", CHR$(0) + "K"
        IF stat(x, row) > 0 THEN
          stat(x, row) = stat(x, row) - 1
          player(x).points = player(x).points + 1
        END IF
      CASE CHR$(13)
        IF player(x).points > 0 THEN
          center 17, "Not all points are spent.  Exit anyway?"
          DO: exit$ = UCASE$(INKEY$): LOOP UNTIL exit$ = "Y" OR exit$ = "N"
          IF exit$ = "Y" THEN done = 1
          center 17, "                                       "
        ELSE
          done = 1
        END IF
      END SELECT
    LOOP UNTIL done
    LOCATE row, 23: PRINT " "
    done = 0
    IF skip1 = 0 THEN
      player(x).str = player(x).str + stat(x, 4): player(x).agi = player(x).agi + stat(x, 5)
      player(x).intl = player(x).intl + stat(x, 6): player(x).cha = player(x).cha + stat(x, 7)
      player(x).wea = player(x).wea + stat(x, 8): player(x).pow = player(x).pow + stat(x, 9)
      points(1) = player(x).str - skill(x).att - skill(x).dfn - skill(x).sta
      points(2) = player(x).agi - skill(x).spd - skill(x).dge - skill(x).hit - skill(x).clm - skill(x).jmp - skill(x).clg
      points(3) = player(x).intl - skill(x).src - skill(x).lng - skill(x).mag
      points(4) = player(x).cha - skill(x).chm - skill(x).cnv - skill(x).lur
      points(5) = player(x).wea - skill(x).bld - skill(x).axe - skill(x).bow - skill(x).spr - skill(x).rop - skill(x).stf
      points(6) = player(x).pow - skill(x).hpup - skill(x).mpup - skill(x).skup
      maxSkill(1, 4) = 20 - skill(x).att: maxSkill(1, 5) = 20 - skill(x).dfn
      maxSkill(1, 6) = 10 - skill(x).sta: maxSkill(2, 4) = 10 - skill(x).spd
      maxSkill(2, 5) = 10 - skill(x).dge: maxSkill(2, 6) = 19 - skill(x).hit
      maxSkill(2, 7) = 10 - skill(x).clm: maxSkill(2, 8) = 4 - skill(x).jmp
      maxSkill(2, 9) = 7 - skill(x).clg: maxSkill(3, 4) = 5 - skill(x).src
      maxSkill(3, 5) = 5 - skill(x).lng: maxSkill(3, 6) = 20 - skill(x).mag
      maxSkill(4, 4) = 5 - skill(x).chm: maxSkill(4, 5) = 15 - skill(x).cnv
      maxSkill(4, 6) = 5 - skill(x).lur: maxSkill(5, 4) = 10 - skill(x).bld
      maxSkill(5, 5) = 10 - skill(x).axe: maxSkill(5, 6) = 10 - skill(x).bow
      maxSkill(5, 7) = 10 - skill(x).spr: maxSkill(5, 8) = 10 - skill(x).rop
      maxSkill(5, 9) = 10 - skill(x).stf: maxSkill(6, 4) = 25 - skill(x).hpup
      maxSkill(6, 5) = 12 - skill(x).mpup: maxSkill(6, 6) = 3 - skill(x).skup
      FOR z = 1 TO 6
        location = 4
        DO
          SELECT CASE z
          CASE 1
            actSkill(4) = "Attack:  " + STR$(skill(x).att + skillNum(x, 1, 4)) + " / 20               "
            actSkill(5) = "Defense: " + STR$(skill(x).dfn + skillNum(x, 1, 5)) + " / 20               "
            actSkill(6) = "Stamina: " + STR$(skill(x).sta + skillNum(x, 1, 6)) + " / 10               "
          CASE 2
            actSkill(4) = "Speed:    " + STR$(skill(x).spd + skillNum(x, 2, 4)) + " / 10              "
            actSkill(5) = "Dodge:    " + STR$(skill(x).dge + skillNum(x, 2, 5)) + " / 10              "
            actSkill(6) = "Accuracy: " + STR$(skill(x).hit + skillNum(x, 2, 6)) + " / 19              "
            actSkill(7) = "Climb:    " + STR$(skill(x).clm + skillNum(x, 2, 7)) + " / 10              "
            actSkill(8) = "Jump:     " + STR$(skill(x).jmp + skillNum(x, 2, 8)) + " / 4               "
            actSkill(9) = "Ceiling:  " + STR$(skill(x).clg + skillNum(x, 2, 9)) + " / 7               "
          CASE 3
            actSkill(4) = "Search:    " + STR$(skill(x).src + skillNum(x, 3, 4)) + " / 5              "
            actSkill(5) = "Languages: " + STR$(skill(x).lng + skillNum(x, 3, 5)) + " / 5              "
            actSkill(6) = "Magic:     " + STR$(skill(x).mag + skillNum(x, 3, 6)) + " / 20             "
          CASE 4
            actSkill(4) = "Charm:    " + STR$(skill(x).chm + skillNum(x, 4, 4)) + " / 5               "
            actSkill(5) = "Convince: " + STR$(skill(x).cnv + skillNum(x, 4, 5)) + " / 15              "
            actSkill(6) = "Lure:     " + STR$(skill(x).lur + skillNum(x, 4, 6)) + " / 5               "
          CASE 5
            actSkill(4) = "Blades: " + STR$(skill(x).bld + skillNum(x, 5, 4)) + " / 10                "
            actSkill(5) = "Axes:   " + STR$(skill(x).axe + skillNum(x, 5, 5)) + " / 10                "
            actSkill(6) = "Bows:   " + STR$(skill(x).bow + skillNum(x, 5, 6)) + " / 10                "
            actSkill(7) = "Spears: " + STR$(skill(x).spr + skillNum(x, 5, 7)) + " / 10                "
            actSkill(8) = "Whips:  " + STR$(skill(x).rop + skillNum(x, 5, 8)) + " / 10                "
            actSkill(9) = "Staffs: " + STR$(skill(x).stf + skillNum(x, 5, 9)) + " / 10                "
          CASE 6
            actSkill(4) = "HP up:    " + STR$(skill(x).hpup + skillNum(x, 6, 4)) + " / 25              "
            actSkill(5) = "MP up:    " + STR$(skill(x).mpup + skillNum(x, 6, 5)) + " / 12              "
            actSkill(6) = "Skill up: " + STR$(skill(x).skup + skillNum(x, 6, 6)) + " / 3               "
          END SELECT
          COLOR 12
          center 1, SPACE$(6) + skillHelp$(z) + SPACE$(6)
          COLOR 15
          LOCATE 2, 30: PRINT "REMAINING POINTS:"; points(z)
          center 15, SPACE$(72)
          COLOR 14
          FOR a = 4 TO 9
            LOCATE a, 25
            IF a <= bottom(z) THEN
              PRINT actSkill(a)
            ELSE
              LOCATE a, 25
              PRINT SPACE$(56)
            END IF
          NEXT
          COLOR 15
          LOCATE location, 23: PRINT ""
          DO: kbd$ = INKEY$: LOOP UNTIL kbd$ <> ""
          SELECT CASE kbd$
          CASE CHR$(0) + "H"
            LOCATE location, 23: PRINT " "
            location = location - 1
            IF location = 3 THEN location = bottom(z)
            LOCATE location, 23: PRINT ""
          CASE CHR$(0) + "P"
            LOCATE location, 23: PRINT " "
            location = location + 1
            IF location > bottom(z) THEN location = 4
            LOCATE location, 23: PRINT ""
          CASE "+", "=", CHR$(0) + "M"
            IF points(z) > 0 AND skillNum(x, z, location) < maxSkill(z, location) THEN
              skillNum(x, z, location) = skillNum(x, z, location) + 1
              points(z) = points(z) - 1
            END IF
          CASE "-", "_", CHR$(0) + "K"
            IF skillNum(x, z, location) > 0 THEN
              skillNum(x, z, location) = skillNum(x, z, location) - 1
              points(z) = points(z) + 1
            END IF
          CASE CHR$(13)
            IF points(z) > 0 THEN
              center 17, "Not all points are spent.  Exit anyway?"
              DO: exit$ = UCASE$(INKEY$): LOOP UNTIL exit$ = "Y" OR exit$ = "N"
              IF exit$ = "Y" THEN finished = 1
              center 17, "                                       "
            ELSE
              finished = 1
            END IF
          CASE CHR$(27)
            IF z = 1 THEN
              skip = 1
              EXIT FOR
            ELSE
              z = z - 2
              skip = 1
              EXIT DO
            END IF
          END SELECT
        LOOP UNTIL finished
        finished = 0
        LOCATE location, 23: PRINT " "
      NEXT
      IF skip = 0 THEN
        skill(x).att = skill(x).att + skillNum(x, 1, 4)
        skill(x).dfn = skill(x).dfn + skillNum(x, 1, 5)
        skill(x).sta = skill(x).sta + skillNum(x, 1, 6)
        skill(x).spd = skill(x).spd + skillNum(x, 2, 4)
        skill(x).dge = skill(x).dge + skillNum(x, 2, 5)
        skill(x).hit = skill(x).hit + skillNum(x, 2, 6)
        skill(x).clm = skill(x).clm + skillNum(x, 2, 7)
        skill(x).jmp = skill(x).jmp + skillNum(x, 2, 8)
        skill(x).clg = skill(x).clg + skillNum(x, 2, 9)
        skill(x).src = skill(x).src + skillNum(x, 3, 4)
        skill(x).lng = skill(x).lng + skillNum(x, 3, 5)
        skill(x).mag = skill(x).mag + skillNum(x, 3, 6)
        skill(x).chm = skill(x).chm + skillNum(x, 4, 4)
        skill(x).cnv = skill(x).cnv + skillNum(x, 4, 5)
        skill(x).lur = skill(x).lur + skillNum(x, 4, 6)
        skill(x).bld = skill(x).bld + skillNum(x, 5, 4)
        skill(x).axe = skill(x).axe + skillNum(x, 5, 5)
        skill(x).bow = skill(x).bow + skillNum(x, 5, 6)
        skill(x).spr = skill(x).spr + skillNum(x, 5, 7)
        skill(x).rop = skill(x).rop + skillNum(x, 5, 8)
        skill(x).stf = skill(x).stf + skillNum(x, 5, 9)
        skill(x).hpup = skill(x).hpup + skillNum(x, 6, 4)
        skill(x).mpup = skill(x).mpup + skillNum(x, 6, 5)
        skill(x).skup = skill(x).skup + skillNum(x, 6, 6)
        alldone = 1
      ELSE
        player(x).str = player(x).str - stat(x, 4): player(x).agi = player(x).agi - stat(x, 5)
        player(x).intl = player(x).intl - stat(x, 6): player(x).cha = player(x).cha - stat(x, 7)
        player(x).wea = player(x).wea - stat(x, 8): player(x).pow = player(x).pow - stat(x, 9)
      END IF
      skip = 0
    END IF
    skip1 = 0
  LOOP UNTIL alldone
END SUB

SUB drawboard
  WIDTH 40, 43
  SCREEN , , 7, 7
  CLS
  LOCATE 20, 11: PRINT "Initializing Screen"
  LOCATE 21, 15: PRINT "Please wait"
  SCREEN , , 0, 7
  getboard 0, 0
  FOR x = 1 TO 40
    FOR y = 1 TO 20
      LOCATE y, x
      SELECT CASE element(0, 0, x, y)
      CASE 0
        COLOR , backclr(0, 0, x, y)
        PRINT " ";
      CASE ice
        COLOR 9, backclr(0, 0, x, y)
        PRINT CHR$(177)
      CASE wood, trunk
        COLOR 6, backclr(0, 0, x, y)
        PRINT CHR$(178)
      CASE rock
        COLOR 8, backclr(0, 0, x, y)
        PRINT CHR$(219)
      CASE leaves
        COLOR 10, backclr(0, 0, x, y)
        PRINT CHR$(177)
      CASE fire
        COLOR 4, backclr(0, 0, x, y)
        PRINT CHR$(15)
      END SELECT
      LOCATE y, x
      IF rope(0, 0, x, y) = 1 THEN
        COLOR 10, backclr(0, 0, x, y)
        PRINT CHR$(179)
      END IF
    NEXT
  NEXT
  FOR x = 1 TO 4
    LOCATE player(x).row, player(x).col
    COLOR 9, backclr(0, 0, player(x).col, player(x).row)
    PRINT player(x).sym
  NEXT
  SCREEN , , 0, 0
END SUB

SUB enemystats

END SUB

SUB getboard (x, y)
  SELECT CASE x
  CASE -1
    SELECT CASE y
    CASE -1
    CASE 0
    CASE 1
    END SELECT
  CASE 0
    SELECT CASE y
    CASE -1
    CASE 0
      FOR x = 1 TO 40
        FOR y = 1 TO 20
          backclr(0, 0, x, y) = 3
        NEXT
      NEXT
      FOR x = 21 TO 40
        FOR y = 21 TO 29
          backclr(0, 0, x, y) = 3
        NEXT
      NEXT
      FOR x = 27 TO 32
        element(0, 0, x, 4) = ice
      NEXT
      FOR x = 20 TO 40
        element(0, 0, x, 30) = rock
      NEXT
      FOR x = 1 TO 20
        element(0, 0, x, 21) = rock
      NEXT
      FOR x = 22 TO 28
        element(0, 0, 20, x) = rock
      NEXT
      FOR x = 24 TO 29
        element(0, 0, 32, x) = trunk
      NEXT
      FOR x = 21 TO 23
        FOR y = 31 TO 33
          element(0, 0, y, x) = leaves
        NEXT
      NEXT
      element(0, 0, 20, 19) = ice
      element(0, 0, 21, 19) = ice
      FOR x = 20 TO 29
        rope(0, 0, 21, x) = 1
      NEXT
      element(0, 0, 20, 29) = ice
      backclr(0, 0, 20, 29) = 7
    CASE 1
    END SELECT
  CASE 1
    SELECT CASE y
    CASE -1
    CASE 0
    CASE 1
    END SELECT
  END SELECT
END SUB

SUB getchar
  DIM row(4)
  DIM taken(9)
  SCREEN 0
  WIDTH 80, 25
  COLOR 12
  center 2, "CHOOSE YOUR CHARACTERS"
  COLOR 9
  center 4, "Knight"
  center 5, "Ninja "
  center 6, "Spy   "
  center 7, "Archer"
  center 8, "Mage  "
  center 9, "Wizard"
  COLOR 10
  FOR x = 1 TO 4
    y = 4
    DO
      row(x) = y
      y = y + 1
    LOOP UNTIL taken(row(x)) = 0
    DO
      LOCATE row(x), 33: PRINT STR$(x)
      kbd$ = INKEY$
      SELECT CASE kbd$
      CASE CHR$(0) + "H", CHR$(0) + "K"
        LOCATE row(x), 34: PRINT " "
        DO
          row(x) = row(x) - 1
          IF row(x) = 3 THEN row(x) = 9
        LOOP UNTIL taken(row(x)) = 0
        LOCATE row(x), 33: PRINT STR$(x)
      CASE CHR$(0) + "P", CHR$(0) + "M"
        LOCATE row(x), 34: PRINT " "
        DO
          row(x) = row(x) + 1
          IF row(x) = 10 THEN row(x) = 4
        LOOP UNTIL taken(row(x)) = 0
        LOCATE row(x), 33: PRINT STR$(x)
      CASE CHR$(27)
        IF x > 1 THEN
          LOCATE row(x), 34: PRINT " "
          x = x - 1
          taken(row(x)) = 0
        END IF
      CASE CHR$(13)
        taken(row(x)) = 1
        SELECT CASE row(x)
        CASE 4: player(x).job = "Knight"
        CASE 5: player(x).job = "Ninja"
        CASE 6: player(x).job = "Spy"
        CASE 7: player(x).job = "Archer"
        CASE 8: player(x).job = "Mage"
        CASE 9: player(x).job = "Wizard"
        END SELECT
        player(x).sym = LEFT$(player(x).job, 1)
        center 12, (RTRIM$(player(x).job) + ", CHOOSE YOUR RACE")
        COLOR 15
        center 14, "  Human     "
        center 15, "   Dwarf     "
        center 16, "   Elf       "
        center 17, "   1/2 Dragon"
        center 18, "   1/2 Orc   "
        race = 14
        DO
          race$ = INKEY$
          SELECT CASE race$
          CASE CHR$(0) + "H", CHR$(0) + "K"
            LOCATE race, 34: PRINT " "
            race = race - 1
            IF race = 13 THEN race = 18
            LOCATE race, 34: PRINT ""
          CASE CHR$(0) + "P", CHR$(0) + "M"
            LOCATE race, 34: PRINT " "
            race = race + 1
            IF race = 19 THEN race = 14
            LOCATE race, 34: PRINT ""
          CASE CHR$(27)
            taken(row(x)) = 0
            LOCATE row(x), 35: PRINT " "
            x = x - 1
            EXIT DO
          CASE CHR$(13)
            SELECT CASE race
            CASE 14: player(x).race = "Human"
            CASE 15: player(x).race = "Dwarf"
            CASE 16: player(x).race = "Elf"
            CASE 17: player(x).race = "1/2 Dragon"
            CASE 18: player(x).race = "1/2 Orc"
            END SELECT
            COLOR 9
            center 20, " ale or Female"
            COLOR 15
            LOCATE 20, 32: PRINT "M"
            LOCATE 20, 40: PRINT "F"
            DO
              gender$ = UCASE$(INKEY$)
            LOOP UNTIL gender$ = "M" OR gender$ = "F" OR gender$ = CHR$(27)
            IF gender$ = "M" THEN
              player(x).gender = "Male"
            ELSEIF gender$ = "F" THEN
              player(x).gender = "Female"
            END IF
            center 20, "              "
            IF gender$ <> CHR$(27) THEN EXIT DO
          END SELECT
        LOOP
        FOR y = 12 TO 19
          LOCATE y, 1
          PRINT SPACE$(80)
        NEXT
        COLOR 10
        EXIT DO
      END SELECT
    LOOP
  NEXT
  COLOR 15
  FOR x = 1 TO 4
    LOCATE row(x), 25
    PRINT player(x).gender
    LOCATE row(x), 50
    PRINT player(x).race
  NEXT
  COLOR 10
  FOR x = 1 TO 4
    DO
      B$ = getstring$(14 + x, 20, RTRIM$(player(x).job) + ", what is your name?", 14)
      IF B$ = "" THEN
        IF x > 1 THEN
          LOCATE 14 + x, 1: PRINT SPACE$(81)
          x = x - 2
          EXIT DO
        END IF
      ELSE
        player(x).nam = B$
      END IF
    LOOP UNTIL B$ <> ""
  NEXT
  CLS
END SUB

FUNCTION getstring$ (row, col, text$, length)
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
  getstring$ = a$
END FUNCTION

SUB intro
  COLOR 14
  WIDTH 80, 25
  scenter 2, "KNIGHTS AND NINJAS"
  COLOR 9
  scenter 4, "          Designed by: Chad Austin          "
  COLOR 4
  scenter 5, "(With help from J. Morgan & R. Doering)"
  COLOR 15
  scenter 7, "    You and three other friends are sitting at a table in "
  scenter 8, "your house.  From outside the house, screams are heard.   "
  scenter 9, "After looking through a window, you realize the town is   "
  scenter 10, "being attacked.  The clash of steel is heard as you draw  "
  scenter 11, "your weapons.  Your adventure begins . . . .              "
  COLOR 14
  center 2, "KNIGHTS AND NINJAS"
  COLOR 9
  center 4, "Designed by: Chad Austin"
  COLOR 4
  center 5, "(With help from J. Morgan & R. Doering)"
  COLOR 15
  center 7, "    You and three other friends are sitting at a table in "
  center 8, "your house.  From outside the house, screams are heard.   "
  center 9, "After looking through a window, you realize the town is   "
  center 10, "being attacked.  The clash of steel is heard as you draw  "
  center 11, "your weapons.  Your adventure begins . . . .              "
  center 20, "Hit any key to continue"
  WHILE INKEY$ = "": WEND
  CLS
  IF mode <> 0 THEN
    SCREEN mode
    deg# = ATN(1) * 4 / 180
    IF mode = 13 THEN
      FOR x = 0 TO 5
        LINE (109 + x, 39)-(109 + x, 99), x + 16
        LINE (109 + x, 100)-(154 + x, 149), x + 16
        LINE (209 - x, 39)-(209 - x, 99), x + 16
        LINE (164 - x, 149)-(209 - x, 100), x + 16
      NEXT
      FOR x = 0 TO 4
        FOR y = 0 TO x
          PSET (159 - x + y, 154 - x), y + 16
          PSET (159 + x - y, 154 - x), y + 16
        NEXT
      NEXT
      FOR x = 0 TO 5
        CIRCLE (137, 6 + x), 45, x + 16, 239 * deg#, 301 * deg#
        CIRCLE (181, 6 + x), 45, x + 16, 239 * deg#, 301 * deg#
      NEXT
      PAINT (159, 99), 22, 21
      LINE (159, 44)-(159, 148), 18
      LINE (156, 46)-(162, 145), 18, BF
      LINE (157, 45)-(161, 146), 18, BF
      LINE (158, 147)-(160, 147), 18
      LINE (115, 85)-(203, 89), 18, BF
    END IF
    IF mode = 1 THEN
      LINE (109, 39)-(110, 99), 3, B
      LINE (208, 39)-(209, 99), 3, B
      LINE (109, 100)-(159, 149), 3
      LINE (110, 100)-(159, 150), 3
      LINE (209, 100)-(159, 149), 3
      LINE (208, 100)-(159, 150), 3
      CIRCLE (135, 7), 46, 3, 239 * deg#, 301 * deg#
      CIRCLE (183, 7), 46, 3, 239 * deg#, 301 * deg#
      CIRCLE (135, 8), 46, 3, 239 * deg#, 301 * deg#
      CIRCLE (183, 8), 46, 3, 239 * deg#, 301 * deg#
      LINE (155, 41)-(163, 146), 3, BF
      LINE (158, 147)-(160, 148), 3, B
      LINE (110, 85)-(208, 91), 3, BF
      PAINT (120, 100), 1, 3
      PAINT (200, 80), 1, 3
      PAINT (120, 80), 2, 3
      PAINT (200, 100), 2, 3
    END IF
    WHILE INKEY$ = "": WEND
  END IF
END SUB

SUB playknights
  DO
   kbd$ = INKEY$
   IF kbd$ = " " THEN EXIT DO
  LOOP
END SUB

SUB scenter (row, text$)
  STATIC kbd$
  LOCATE row, 40 - (LEN(text$) / 2 + .5)
  FOR x = 1 TO LEN(text$)
    IF kbd$ <> "" THEN EXIT SUB
    kbd$ = INKEY$
    PRINT MID$(text$, x, 1);
    FOR y = 1 TO speed: NEXT
  NEXT
  PRINT
END SUB

SUB weaponstats
  FOR x = 1 TO 26
    weapon(x).typ = 1
    IF x <> 12 AND x <> 24 THEN weapon(x).range = 1 ELSE weapon(x).range = 2
  NEXT

  weapon(1).nam = "Knife"
  weapon(1).users = "all"
  weapon(1).attack = 3
  weapon(1).range = 1
 
  weapon(2).nam = "Silver Knife"
  weapon(2).users = "all"
  weapon(2).attack = 5
  weapon(2).range = 1
  
  weapon(3).nam = "Golden Knife"
  weapon(3).users = "all"
  weapon(3).attack = 8
  weapon(3).range = 1
 
  weapon(4).nam = "Fire Knife"
  weapon(4).users = "all"
  weapon(4).attack = 7
  weapon(4).range = 1
 
  weapon(5).nam = "Ice Knife"
  weapon(5).users = "all"
  weapon(5).attack = 7
  weapon(5).range = 1
 
  weapon(6).nam = "Dagger"
  weapon(6).users = "all"
  weapon(6).attack = 5
  weapon(6).range = 1

  weapon(7).nam = "Red Knife"
  weapon(7).users = "all"
  weapon(7).attack = 12
  weapon(7).range = 1
  weapon(7).spell = 1

  weapon(8).nam = "Blue Knife"
  weapon(8).users = "all"
  weapon(8).attack = 12
  weapon(8).range = 1
  weapon(8).spell = 2

  weapon(9).nam = "Green Knife"
  weapon(9).users = "all"
  weapon(9).attack = 12
  weapon(9).range = 1
  weapon(9).spell = 6
 
  weapon(10).nam = "Steel Sword"
  weapon(10).users = "KNSAM"
  weapon(10).attack = 10
  weapon(10).range = 1
  
  weapon(11).nam = "Dark Sword"
  weapon(11).users = "KNS"
  weapon(11).attack = 18
  weapon(11).range = 1

  weapon(12).nam = "Long Sword"
  weapon(12).users = "KNSAM"
  weapon(12).attack = 10
  weapon(12).range = 2
 
  weapon(13).nam = "Silver Sword"
  weapon(13).users = "KNAM"
  weapon(13).attack = 25
  weapon(13).range = 1
  
  weapon(14).nam = "Defense Sword"
  weapon(14).users = "KN"
  weapon(14).attack = 35
  weapon(14).range = 1
  weapon(14).spell = 38
  
  weapon(15).nam = "Light Sword"
  weapon(15).users = "KA"
  weapon(15).attack = 50
  weapon(15).range = 1
  weapon(15).spell = 25
 
  weapon(16).nam = "Dragon Sword"
  weapon(16).users = "K"
  weapon(16).attack = 50
  weapon(16).range = 1
 
  weapon(17).nam = "Speed Sword"
  weapon(17).users = "KNSA"
  weapon(17).attack = 35
  weapon(17).range = 1
  weapon(17).spell = 28
 
  weapon(18).nam = "Power Sword"
  weapon(18).users = "K"
  weapon(18).attack = 40
  weapon(18).range = 1
  weapon(18).spell = 32

  weapon(19).nam = "Flame Sabre"
  weapon(19).users = "KNAM"
  weapon(19).attack = 25
  weapon(19).range = 1
  weapon(19).spell = 1

  weapon(20).nam = "Ice Blade"
  weapon(20).users = "KNAM"
  weapon(20).attack = 25
  weapon(20).range = 1
  weapon(20).spell = 2

  weapon(21).nam = "Tri-Blade"
  weapon(21).users = "KN"
  weapon(21).attack = 15
  weapon(21).range = 1
  
  weapon(22).nam = "Ancient Sword"
  weapon(22).users = "K"
  weapon(22).attack = 45
  weapon(22).range = 1
  weapon(22).spell = 30

  weapon(23).nam = "Ninja Sword"
  weapon(23).users = "KNS"
  weapon(23).attack = 45
  weapon(23).range = 1
 
  weapon(24).nam = "Samurai Sword"
  weapon(24).users = "N"
  weapon(24).attack = 65
  weapon(24).range = 2
  weapon(24).spell = 48
 
  weapon(25).nam = "Hyper Sword"
  weapon(25).users = "K"
  weapon(25).attack = 75
  weapon(25).range = 1
  weapon(25).spell = 39
 
  weapon(26).nam = "Excalibur"
  weapon(26).users = "K"
  weapon(26).attack = 125
  weapon(26).range = 1


  FOR x = 27 TO 48
    weapon(x).typ = twohand
  NEXT
  FOR x = 27 TO 37
    weapon(x).range = 1
  NEXT

  weapon(27).nam = "Iron Axe"
  weapon(27).users = "KAM"
  weapon(27).attack = 12
 
  weapon(28).nam = "Power Axe"
  weapon(28).users = "KA"
  weapon(28).attack = 15
  weapon(28).spell = 32

  weapon(29).nam = "Strength Axe"
  weapon(29).users = "KA"
  weapon(29).attack = 20
 
  weapon(30).nam = "Dark Axe"
  weapon(30).users = "K"
  weapon(30).attack = 20
  weapon(30).spell = 48

  weapon(31).nam = "Throwing Axe"
  weapon(31).users = "KA"
  weapon(31).attack = 15
  weapon(31).range = 5

  weapon(32).nam = "Dwarf Axe"
  weapon(32).users = "K"
  weapon(32).attack = 25
  weapon(32).range = 3
  
  weapon(33).nam = "Silver Axe"
  weapon(33).users = "K"
  weapon(33).attack = 30
  weapon(33).range = 2
  
  weapon(34).nam = "Golden Axe"
  weapon(34).users = "K"
  weapon(34).attack = 35

  weapon(35).nam = "Flaming Axe"
  weapon(35).users = "K"
  weapon(35).attack = 32
  weapon(35).spell = 1

  weapon(36).nam = "Frozen Axe"
  weapon(36).users = "K"
  weapon(36).attack = 32
  weapon(36).spell = 2

  weapon(37).nam = "Rusty Axe"
  weapon(37).users = "K"
  weapon(37).attack = 50
  
  weapon(38).nam = "Giant Axe"
  weapon(38).users = "K"
  weapon(38).attack = 75

  FOR x = 39 TO 48
    weapon(x).range = 2
  NEXT
 
  weapon(39).nam = "Iron Spear"
  weapon(39).users = "KNS"
  weapon(39).attack = 11
  weapon(39).range = 2

  weapon(40).nam = "Long Spear"
  weapon(40).users = "KNS"
  weapon(40).attack = 15
  weapon(40).range = 3
 
  weapon(41).nam = "Defense Spear"
  weapon(41).users = "KNS"
  weapon(41).attack = 20
  
  weapon(42).nam = "Wind Lance"
  weapon(42).users = "NS"
  weapon(42).attack = 22
                    
  weapon(43).nam = "Dark Spear"
  weapon(43).users = "KNS"
  weapon(43).attack = 28
  
  weapon(44).nam = "Samurai Spear"
  weapon(44).users = "N"
  weapon(44).attack = 35
  weapon(44).spell = 0
 
  weapon(45).nam = "Dragon Spear"
  weapon(45).users = "KN"
  weapon(45).attack = 50
  weapon(45).spell = 44

  weapon(46).nam = "Lance of Fire"
  weapon(46).users = "KNS"
  weapon(46).attack = 25
  weapon(46).spell = 3

  weapon(47).nam = "Lance of Ice"
  weapon(47).users = "KNS"
  weapon(47).attack = 25
  weapon(47).spell = 5

  weapon(48).nam = "Shiukerin"
  weapon(48).users = "N"
  weapon(48).attack = 80
  weapon(48).spell = 50

  FOR x = 49 TO 54
    weapon(x).typ = bow
  NEXT

  weapon(49).nam = "Shortbow"
  weapon(49).users = "all"
  weapon(49).attack = 5
  weapon(49).range = 10

  weapon(50).nam = "Longbow"
  weapon(50).users = "KNA"
  weapon(50).attack = 7
  weapon(50).range = 20

  weapon(51).nam = "Greatbow"
  weapon(51).users = "KNA"
  weapon(51).attack = 10
  weapon(51).range = 25

  weapon(52).nam = "Crossbow"
  weapon(52).users = "KA"
  weapon(52).attack = 20
  weapon(52).range = 50

  weapon(53).nam = "Elvenbow"
  weapon(53).users = "A"
  weapon(53).attack = 25
  weapon(53).range = 40

  weapon(54).nam = "Rapidbow"
  weapon(54).users = "A"
  weapon(54).attack = 15
  weapon(54).range = 35

  FOR x = 55 TO 65
    weapon(x).typ = arrow
  NEXT

  weapon(55).nam = "Wooden Arrow"
  weapon(55).users = "all"
  weapon(55).attack = 5
 
  weapon(56).nam = "Fire Arrow"
  weapon(56).users = "all"
  weapon(56).attack = 7
 
  weapon(57).nam = "Ice Arrow"
  weapon(57).users = "all"
  weapon(57).attack = 7

  weapon(58).nam = "Bolt Arrow"
  weapon(58).users = "all"
  weapon(58).attack = 7

  weapon(59).nam = "Dark Arrow"
  weapon(59).users = "KNSA"
  weapon(59).attack = 10

  weapon(60).nam = "Laser Arrow"
  weapon(60).users = "A"
  weapon(60).attack = 35

  weapon(61).nam = "Poison Arrow"
  weapon(61).users = "KNA"
  weapon(61).attack = 30

  weapon(62).nam = "Evasive Arrow"
  weapon(62).users = "20"
  weapon(62).attack = 5

  weapon(63).nam = "Silver Arrow"
  weapon(63).users = "KNA"
  weapon(63).attack = 25

  weapon(64).nam = "Golden Arrow"
  weapon(64).users = "KNA"
  weapon(64).attack = 40

  weapon(65).nam = "Mystic Arrow"
  weapon(65).users = "A"
  weapon(65).attack = 50

  FOR x = 66 TO 69
    weapon(x).typ = star
  NEXT

  weapon(66).nam = "Star"
  weapon(66).users = "NS"
  weapon(66).attack = 10

  weapon(67).nam = "Ninja Star"
  weapon(67).users = "NS"
  weapon(67).attack = 25

  weapon(68).nam = "Shuriken"
  weapon(68).users = "NS"
  weapon(68).attack = 40

  weapon(69).nam = "Samurai Star"
  weapon(69).users = "N"
  weapon(69).attack = 50

  FOR x = 70 TO 77
    weapon(x).typ = whip
  NEXT

  weapon(70).nam = "Mace"
  weapon(70).users = "KAM"
  weapon(70).attack = 7
  weapon(70).range = 2
 
  weapon(71).nam = "Black Mace"
  weapon(71).users = "NS"
  weapon(71).attack = 15
  weapon(71).range = 2
  weapon(71).spell = 48

  weapon(72).nam = "Spiked Mace"
  weapon(72).users = "K"
  weapon(72).attack = 25
  weapon(72).range = 2
 
  weapon(73).nam = "Charge Mace"
  weapon(73).users = "K"
  weapon(73).attack = 40
  weapon(73).range = 2
  
  weapon(74).nam = "Whip"
  weapon(74).users = "SAMW"
  weapon(74).attack = 5
  weapon(74).range = 3
  
  weapon(75).nam = "Thorn Whip"
  weapon(75).users = "AMW"
  weapon(75).attack = 10
  weapon(75).range = 3

  weapon(76).nam = "Flame Whip"
  weapon(76).users = "AMW"
  weapon(76).attack = 20
  weapon(76).range = 4
  weapon(76).spell = 1

  weapon(77).nam = "Evil Whip"
  weapon(77).users = "SW"
  weapon(77).attack = 35
  weapon(77).range = 4
  weapon(77).spell = 46

  FOR x = 78 TO 88
    weapon(x).typ = twohand
    weapon(x).range = 1
  NEXT

  weapon(78).nam = "Wooden Staff"
  weapon(78).users = "KNMW"
  weapon(78).attack = 10

  weapon(79).nam = "Holy Staff"
  weapon(79).users = "MW"
  weapon(79).attack = 15
  weapon(79).spell = 17

  weapon(80).nam = "Spiked Staff"
  weapon(80).users = "KNS"
  weapon(80).attack = 65

  weapon(81).nam = "Iron Staff"
  weapon(81).users = "KN"
  weapon(81).attack = 25
  weapon(81).range = 2

  weapon(82).nam = "Bladed Staff"
  weapon(82).users = "KNSW"
  weapon(82).attack = 40

  weapon(83).nam = "Tree Staff"
  weapon(83).users = "W"
  weapon(83).attack = 35
  weapon(83).range = 2
  weapon(83).spell = 30

  weapon(84).nam = "Fire Staff"
  weapon(84).users = "KNMW"
  weapon(84).attack = 25
  weapon(84).spell = 1

  weapon(85).nam = "Ice Staff"
  weapon(85).users = "KNMW"
  weapon(85).attack = 25
  weapon(85).spell = 2

  weapon(86).nam = "Healing Staff"
  weapon(86).users = "W"
  weapon(86).attack = 30
  weapon(86).spell = 27

  weapon(87).nam = "Charm Staff"
  weapon(87).users = "W"
  weapon(87).attack = 45
  weapon(87).spell = 9

  weapon(88).nam = "Cave Staff"
  weapon(88).users = "W"
  weapon(88).attack = 50
  weapon(88).range = 2
  weapon(88).spell = 13
END SUB

