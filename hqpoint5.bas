DEFINT A-Z
DECLARE SUB Battle ()
DECLARE SUB BuyArmor ()
DECLARE SUB BuyItems ()
DECLARE SUB BuyWeapons ()
DECLARE SUB Center (row%, text$)
DECLARE SUB CharIntro ()
DECLARE SUB GetInputs ()
DECLARE SUB GetMagic ()
DECLARE SUB ItemBuy ()
DECLARE SUB Shop ()
TYPE MonsterType
 attack  AS INTEGER
 defense AS INTEGER
 BP      AS INTEGER
 gold    AS INTEGER
 speed   AS INTEGER
 nam     AS STRING * 13
END TYPE
 RANDOMIZE TIMER
 DIM SHARED monster(1 TO 14) AS MonsterType
 DIM SHARED spell(1 TO 25) AS STRING * 17
 DIM SHARED armor(1 TO 3) AS INTEGER
 DIM SHARED char AS STRING * 9
 DIM SHARED attack, ambushed, MonsterBP, diff, Mspeed
 DIM SHARED defense, gold, BP, MP, MaxBP
 DIM SHARED PH, PST, PD, HB, PR1, PR2, PSP, PR
 GetInputs
 CharIntro
 DO
  GetMagic
  FOR x = 1 TO INT(RND * diff * 2) + 1
   Battle
  NEXT
  COLOR 15
  CLS
  PRINT "You have"; gold; "gold coins."
  PRINT "Do you want to go to the store?"
  DO
   kbd$ = UCASE$(INKEY$)
  LOOP UNTIL kbd$ = "Y" OR kbd$ = "N"
  IF kbd$ = "Y" THEN Shop
 LOOP

SUB Battle
 prev = defense
 rock = 0
 monster(1).nam = "Goblin"
 monster(2).nam = "Orc"
 monster(3).nam = "Fimir"
 monster(4).nam = "Skeleton"
 monster(5).nam = "Zombie"
 monster(6).nam = "Mummy"
 monster(7).nam = "Chaos Warrior"
 monster(8).nam = "Gargoyle"
 monster(9).nam = "Elven Archer"
 monster(10).nam = "Elven Warrior"
 monster(11).nam = "Giant Wolf"
 monster(12).nam = "Ogre"
 monster(13).nam = "Shadow Dragon"
 monster(14).nam = "Zargon"
 monster(1).attack = 2
 monster(1).defense = 1
 monster(1).BP = 1
 monster(1).gold = 10
 monster(1).speed = 10
 monster(2).attack = 3
 monster(2).defense = 2
 monster(2).BP = 1
 monster(2).gold = 50
 monster(2).speed = 8
 monster(3).attack = 3
 monster(3).defense = 3
 monster(3).BP = 2
 monster(3).gold = 75
 monster(3).speed = 6
 monster(4).attack = 2
 monster(4).defense = 2
 monster(4).BP = 1
 monster(4).gold = 20
 monster(4).speed = 6
 monster(5).attack = 2
 monster(5).defense = 3
 monster(5).BP = 1
 monster(5).gold = 30
 monster(5).speed = 5
 monster(6).attack = 3
 monster(6).defense = 4
 monster(6).BP = 2
 monster(6).gold = 80
 monster(6).speed = 4
 monster(7).attack = 4
 monster(7).defense = 4
 monster(7).BP = 3
 monster(7).gold = 250
 monster(7).speed = 7
 monster(8).attack = 4
 monster(8).defense = 5
 monster(8).BP = 3
 monster(8).gold = 350
 monster(8).speed = 6
 monster(9).attack = 4
 monster(9).defense = 2
 monster(9).BP = 3
 monster(9).gold = 175
 monster(9).speed = 6
 monster(10).attack = 4
 monster(10).defense = 3
 monster(10).BP = 3
 monster(10).gold = 200
 monster(10).speed = 6
 monster(11).attack = 6
 monster(11).defense = 3
 monster(11).BP = 5
 monster(11).gold = 500
 monster(11).speed = 9
 monster(12).attack = 6
 monster(12).defense = 4
 monster(12).BP = 10
 monster(12).gold = 750
 monster(12).speed = 4
 monster(13).gold = 3000
 IF char = "ZARGON   " OR char = "SHADE    " OR char = "CHAD     " THEN
  monster(13).attack = 55
  monster(13).defense = 10
  monster(13).BP = 270
  monster(14).attack = 43
  monster(14).defense = 15
  monster(14).BP = 350
  monster(14).gold = 10000
 ELSE
  monster(13).attack = 8
  monster(13).defense = 6
  monster(13).BP = 15
  monster(14).attack = 10
  monster(14).defense = 6
  monster(14).BP = 25
 END IF
 enemy = CINT(RND * 11) + 1
 IF RND < .02 THEN enemy = 13
 IF RND < .008 THEN enemy = 14
 MBP = monster(enemy).BP
 SELECT CASE CINT(RND * 4)
 CASE 0: kbd$ = "lake"
 CASE 1: kbd$ = "forest"
 CASE 2: kbd$ = "room"
 CASE 3: kbd$ = "halls"
 CASE 4: kbd$ = "desert"
 END SELECT
 IF enemy = 13 THEN kbd$ = "Pits of Doom"
 CLS
 IF RND > .7 OR enemy = 13 THEN combat$ = "ambushed" ELSE combat$ = "attacked"
 SELECT CASE kbd$
 CASE "desert": COLOR 14
 CASE "lake": COLOR 3
 CASE "halls": COLOR 7
 CASE "forest": COLOR 2
 CASE "room": COLOR 15
 CASE "Pits of Doom": COLOR 4
 END SELECT
 PRINT "You were "; combat$; " by a "; RTRIM$(monster(enemy).nam); " in the "; kbd$; "."
 DO
  PRINT "Body Points:"; BP
  x = RND
  IF spd THEN x = x + RND
  IF x > 0 THEN
   PRINT "What do you do? (Attack/Cast a Spell/Run/Use an Item)"
   DO
    kbd$ = UCASE$(INKEY$)
   LOOP UNTIL kbd$ = "A" OR kbd$ = "C" OR kbd$ = "R" OR kbd$ = "U"
   SELECT CASE kbd$
   CASE "A"
    att = RND * attack
    dfn = RND * monster(enemy).defense
    dmg = att - dfn
    IF dmg < 0 THEN dmg = 0
    PRINT "You attack the "; RTRIM$(monster(enemy).nam); " for"; dmg; "points of damage."
    MBP = MBP - dmg
   CASE "C"
    IF char = "Barbarian" OR char = "Dwarf    " OR char = "SHADE    " THEN
     PRINT "You have no spells."
    ELSE
     PRINT "                 These are your spells:"
     FOR x = 1 TO 25
      PRINT spell(x),
      NEXT
     a = 0
     PRINT
     DO
      LINE INPUT "Which spell do you cast? "; kbd$
      kbd$ = UCASE$(kbd$)
      FOR x = 1 TO 25
       IF kbd$ = RTRIM$(spell(x)) THEN a = 1: spl = x
      NEXT
     LOOP UNTIL a OR kbd$ = ""
     SELECT CASE kbd$
     CASE "GENIE"
      x = RND * 5
      PRINT "You injure the monster for"; x; "body points."
      MBP = MBP - x
      spell(spl) = ""
     CASE "SWIFT WIND"
      fast = 1
      PRINT "Your speed is doubled for the rest of the fight."
      spell(spl) = ""
     CASE "TEMPEST"
      IF enemy < 13 THEN
       x = RND
       IF x = 1 THEN
        PRINT "The "; RTRIM$(monster(enemy).nam); " is paralyzed for the rest of the fight."
        para = 1
       ELSE PRINT "The spell failed."
       END IF
      ELSE PRINT "The spell failed."
      END IF
      spell(spl) = ""
     CASE "FIRE OF WRATH"
      x = RND
      PRINT "You injure the "; RTRIM$(monster(enemy).nam); " for"; x; "points of damage."
      spell(spl) = ""
      MBP = MBP - 2
     CASE "BALL OF FLAME"
      x = RND * 2
      PRINT "You injure the "; RTRIM$(monster(enemy).nam); " for"; x; "hit points."
      MBP = MBP - x
      spell(spl) = ""
     CASE "COURAGE"
      PRINT "Your attack is increased by two for the remainder of the fight."
      attack = attack + 2
      spell(spl) = ""
     CASE "WATER OF HEALING", "HEAL BODY"
      PRINT "You have recovered four Body Points."
      BP = BP + 4
      IF BP > MaxBP THEN BP = MaxBP
      spell(spl) = ""
     CASE "SLEEP"
      x = RND * 2
      IF x = 0 THEN
       PRINT "The spell failed."
      ELSE
       PRINT "The monster has fallen asleep."
       para = 1
      END IF
      spell(spl) = ""
     CASE "VEIL OF MIST", "PASS THROUGH ROCK"
      PRINT "You can run away without the monster seeing you."
      away = 1
      spell(spl) = ""
     CASE "ROCK SKIN"
      PRINT "Your defense is increased by one for one turn."
      rock = rock + 1
      spell(spl) = ""
     CASE "FIRE STORM"
      x = (RND * 15) + 4
      PRINT "You injure the "; RTRIM$(monster(enemy).nam); " for"; x; "hits."
      MBP = MBP - x
      spell(spl) = ""
     CASE "MIND BLAST", "CLOUD OF CHAOS"
      IF enemy < 13 THEN
       para = 1
       PRINT "The monster is paralyzed for the rest of the battle."
      ELSE PRINT "The spell failed."
      END IF
      spell(spl) = ""
     CASE "RESTORE CHAOS"
      BP = BP + 6
      PRINT "You have recovered six hit points."
      spell(spl) = ""
      IF BP > MaxBP THEN BP = MaxBP
     CASE "ESCAPE"
      done = 1
      PRINT "You vanished from the battle field."
      spell(spl) = ""
     CASE "LIGHTNING BOLT"
      x = RND * 20
      spell(spl) = ""
      PRINT "You injure the monster for"; x; "points of damage."
      MBP = MBP - x
     CASE "RUST"
      x = RND * monster(enemy).attack
      monster(enemy).attack = monster(enemy).attack - x
      PRINT "The monster's attack is decreased by"; x; "."
      spell(spl) = ""
     CASE "FEAR"
      x = RND * monster(enemy).defense
      monster(enemy).defense = monster(enemy).defense - x
      PRINT "The monster's defense is decreased by"; x; "."
      spell(spl) = ""
     CASE "DRAGON FIRE"
      MBP = MBP - 2
      PRINT "The "; RTRIM$(monster(enemy).nam); " has lost two hit points."
      spell(spl) = ""
     CASE "FLOOD"
      para = 1
      spell(spl) = ""
      PRINT "The monster is stunned."
     CASE "DRAIN"
      x = RND * 5 + 1
      PRINT "The monster has lost"; x; "hit points while you gained that many."
      BP = BP + x
      IF BP > MaxBP THEN BP = MaxBP
      MBP = MBP - x
      spell(spl) = ""
     CASE "SHADOW"
      PRINT "You have a better chance of blocking hits for the rest of the fight."
      spell(spl) = ""
      defense = defense * 2
     END SELECT
    END IF
   CASE "R"
    IF combat$ = "attacked" THEN
     speed = RND * 12
     IF char = "NINJA    " THEN speed = RND * 18
     IF char = "SHADE    " THEN speed = RND * 100
     IF fast THEN speed = RND * 24
     IF armor(3) = 2 THEN speed = speed / 2
     IF RND * monster(enemy).speed < speed OR away THEN
      PRINT "You ran away."
      done = 1
      x = monster(enemy).gold
      IF x > gold THEN x = gold
      gold = gold - x
      PRINT "You drop"; x; "gold coins."
     ELSE PRINT "You cannot run away."
     END IF
    ELSE PRINT "Because you were ambushed, you cannot run away."
    END IF
   CASE "U"
    PRINT PH; "Potions of Healing (PH)"
    PRINT PST; "Potions of Strength (PST)"
    PRINT PD; "Potions of Defense (PD)"
    PRINT HB; "Heroic Brews (HB)"
    PRINT PR1; "Potions of Restoration #1 (PR1)"
    PRINT PR2; "Potions of Restoration #2 (PR2)"
    PRINT PSP; "Potions of Speed (PSP)"
    PRINT PR; "Potions of Recall (PR)"
    DO
     LINE INPUT "Which item do you use? "; kbd$
     kbd$ = UCASE$(kbd$)
    LOOP UNTIL kbd$ = "PH" OR kbd$ = "PST" OR kbd$ = "PD" OR kbd$ = "HB" OR kbd$ = "PR1" OR kbd$ = "PR2" OR kbd$ = "PSP" OR kbd$ = "PR" OR kbd$ = ""
    SELECT CASE kbd$
    CASE "PH": IF PH THEN PH = PH - 1: BP = BP + (RND * 5) + 1: IF BP > MaxBP THEN BP = MaxBP
    CASE "PST": IF PST THEN PST = PST - 1: attack = attack + 2
    CASE "PD": IF PD THEN PD = PD - 1: defense = defense + 1
    CASE "HB": IF HB THEN HB = HB - 1: monster(enemy).defense = monster(enemy).defense * 2: attack = attack * 2
    CASE "PR1": IF PR1 THEN : PR1 = PR1 - 1: BP = BP + 5: IF BP > MaxBP THEN BP = MaxBP
    CASE "PR2": IF PR2 THEN PR2 = PR2 - 1: BP = MaxBP
    CASE "PSP": IF PSP THEN PSP = PSP - 1: spd = 1
    END SELECT
   END SELECT
  ELSE
   IF para = 0 THEN
    x = ((RND * monster(enemy).attack) - (defense * RND)) / 2
    IF x < 0 THEN x = 0
    PRINT "The "; RTRIM$(monster(enemy).nam); " attacks you for"; x; "points of damage."
    BP = BP - x
   ELSE PRINT "The "; RTRIM$(monster(enemy).nam); " is paralyzed."
   END IF
  END IF
  IF MBP < 1 THEN
   PRINT "You kill the "; RTRIM$(monster(enemy).nam); "."
   gold = gold + monster(enemy).gold
   PRINT "You have obtained"; monster(enemy).gold; "gold coins from the "; RTRIM$(monster(enemy).nam); "."
   IF CINT(RND * 30) = 0 THEN
    IF attack < 35 THEN
     PRINT "You have obtained the Magic Blade."
     attack = 23
     x! = TIMER
     WHILE TIMER - x! <= 1: WEND
     WHILE INKEY$ <> "": WEND
     WHILE INKEY$ = "": WEND
    END IF
   END IF
  END IF
  IF BP < 1 THEN
   PRINT "You are dead."
   COLOR 7
   x! = TIMER
   DO: LOOP UNTIL TIMER - x! > 1
   WHILE INKEY$ <> "": WEND
   WHILE INKEY$ = "": WEND
   END
  END IF
 LOOP UNTIL BP < 1 OR MBP < 1 OR done = 1
 IF char = "Barbarian" OR char = "Dwarf    " OR char = "Elf      " OR char = "Wizard   " AND MBP < 1 THEN
  IF monster(enemy).nam = "Shadow Dragon" THEN
   PRINT "The code to being the Shadow Dragon is SHADE."
   x! = TIMER
   WHILE TIMER - x! <= 1: WEND
   WHILE INKEY$ <> "": WEND
   WHILE INKEY$ = "": WEND
  END IF
 END IF
 IF monster(enemy).nam = "Zargon       " THEN
  IF MBP < 1 THEN
   PRINT "The code to being Zargon is ZARGON."
   PRINT "The code to being Shadow Dragon is SHADE"
   PRINT "The code to being the Ninja is NINJA"
   PRINT "The code to being Chad is CHAD"
   PRINT "Type the code when choosing your character."
   PRINT "If a code is typed incorrectly, only hit backspace and type the code again!"
   PRINT "You have obtained the Claws of Darkness, Black Mask, Ninja Gauntlets,"
   PRINT "  and the Ninja Suit."
   x! = TIMER
   WHILE TIMER - x! <= 1: WEND
   WHILE INKEY$ <> "": WEND
   WHILE INKEY$ = "": WEND
   attack = 35
   armor(1) = 2
   armor(2) = 2
   armor(3) = 3
  END IF
 END IF
 Center CSRLIN, "Hit any key to continue"
 WHILE INKEY$ = "": WEND
 defense = prev
END SUB

SUB BuyArmor
 CLS
 COLOR 9
 Center 2, "The Armory"
 Center 3, "Remaining gold:" + STR$(gold)
 PRINT
 SELECT CASE armor(1)
 CASE 1: a$ = "a Shield"
 CASE 2: a$ = "Ninja Gauntlets"
 END SELECT
 IF armor(1) THEN PRINT "You are wearing "; a$; " on your arms"
 SELECT CASE armor(2)
 CASE 1: a$ = "Helmet"
 CASE 2: a$ = "Black Mask"
 END SELECT
 IF armor(2) THEN PRINT "You are wearing a "; a$; " on your head"
 SELECT CASE armor(3)
 CASE 1: a$ = "Chainmail"
 CASE 2: a$ = "Platemail"
 CASE 3: a$ = "a Ninja Uniform"
 CASE 6: a$ = "Diamond Scales"
 END SELECT
 IF armor(3) THEN PRINT "You are wearing "; a$; " on your body"
 PRINT "Defense:"; armor(1) + armor(2) + armor(3)
 PRINT
 PRINT "(S)hield: This small piece of armor will protect you from some hits."
 PRINT "     Cost: 150 gold coins."
 PRINT
 PRINT "(H)elmet: This small helm offers little protection, but every bit of"
 PRINT "     help is needed.   Cost: 125 gold coins."
 PRINT
 PRINT "(C)hainmail: This armor is made up of small links of chain."
 PRINT "     Cost: 500 gold coins"
 PRINT
 PRINT "(P)latemail: The strongest armor of the game is solid plates of steel"
 PRINT "     joined to make armor.   Cost: 850 gold coins"
 COLOR 15
 PRINT
 PRINT "What armor do you wish to purchase? (S/H/C/P/ESC)"
 DO
  a$ = UCASE$(INKEY$)
 LOOP UNTIL a$ = "H" OR a$ = "S" OR a$ = "C" OR a$ = "P" OR a$ = CHR$(27)
 SELECT CASE a$
 CASE "H"
  IF gold > 124 THEN
   gold = gold - 125
   armor(2) = 1
   PRINT "OK"
  ELSE PRINT "Not enough gold"
  END IF
 CASE "S"
  IF attack <> 4 THEN
   IF gold > 149 THEN
    gold = gold - 150
    armor(1) = 1
    PRINT "OK"
   ELSE PRINT "Not enough gold"
   END IF
  ELSE PRINT "Cannot use with a Battle Axe"
  END IF
 CASE "C"
  IF gold > 499 THEN
   armor(3) = 1
   gold = gold - 500
   PRINT "OK"
  ELSE PRINT "Not enough gold"
  END IF
 CASE "P"
  IF gold > 849 THEN
   armor(3) = 2
   gold = gold - 850
   PRINT "OK"
  ELSE PRINT "Not enough gold"
  END IF
 END SELECT
 IF a$ <> CHR$(27) THEN WHILE INKEY$ <> "": WEND
END SUB

SUB BuyItems
 CLS
 COLOR 14
 PRINT "The Armory"
 LOCATE 2, 25: PRINT "Remaining gold:"; gold
 PRINT
 PRINT "Potion of Healing (PH): This bluish liquid can restore up to 6 Hit Points."
 PRINT "     Cost: 200 gold coins"
 PRINT "Potion of Strength (PST): This fiery potion increases your attack by two"
 PRINT "     for the rest of the fight.   Cost: 300 gold coins"
 PRINT "Potion of Defense (PD): This potion will increase your defense by one for"
 PRINT "     the rest of the battle.   Cost: 250 gold coins"
 PRINT "Heroic Brew (HB): This potion allows you to attack twice on your turn for"
 PRINT "     the rest of the fight.   Cost: 415 gold coins"
 PRINT "Potion of Restoration #1 (PR1): This healing potion will restore 5 BP."
 PRINT "     Cost: 500 gold coins"
 PRINT "Potion of Restoration #2 (PR2): This powerful potion will restore your BP"
 PRINT "     to maximum.   Cost: 800 gold coins"
 PRINT "Potion of Speed (PSP): This potion allows you to attack more for the rest"
 PRINT "     of the battle.   Cost: 500"
 DO
  LOCATE 18, 33: PRINT SPACE$(48)
  LOCATE 18: LINE INPUT "Which potion to you want to buy? "; a$
  a$ = UCASE$(a$)
 LOOP UNTIL a$ = "PH" OR a$ = "PST" OR a$ = "PD" OR a$ = "HB" OR a$ = "PR1" OR a$ = "PR2" OR a$ = "PSP" OR a$ = ""
 SELECT CASE a$
 CASE "PH"
  IF gold > 199 THEN
   gold = gold - 200
   PH = PH + 1
   PRINT "OK"
  ELSE PRINT "Not enough gold"
  END IF
 CASE "PST"
  IF gold > 299 THEN
   gold = gold - 300
   PST = PST + 1
   PRINT "OK"
  ELSE PRINT "Not enough gold"
  END IF
 CASE "PD"
  IF gold > 249 THEN
   gold = gold - 250
   PD = PD + 1
   PRINT "OK"
  ELSE PRINT "Not enough gold"
  END IF
 CASE "HB"
  IF gold > 414 THEN
   gold = gold - 415
   HB = HB + 1
   PRINT "OK"
  ELSE PRINT "Not enough gold"
  END IF
 CASE "PR1"
  IF gold > 499 THEN
   gold = gold - 500
   PR1 = PR1 + 1
   PRINT "OK"
  ELSE PRINT "Not enough gold"
  END IF
 CASE "PR2"
  IF gold > 799 THEN
   gold = gold - 800
   PR2 = PR2 + 1
   PRINT "OK"
  ELSE PRINT "Not enough gold"
  END IF
 CASE "PSP"
  IF gold > 499 THEN
   gold = gold - 500
   PSP = PSP + 1
   PRINT "OK"
  ELSE PRINT "Not enough gold"
  END IF
 CASE "PR"
  IF gold > 199 THEN
   gold = gold - 200
   PR = PR + 1
   PRINT "OK"
  ELSE PRINT "Not enough gold"
  END IF
 CASE ELSE: x = 1
 END SELECT
 IF x = 0 THEN WHILE INKEY$ <> "": WEND
END SUB

SUB BuyWeapons
 CLS
 COLOR 13
 PRINT "The Armory"
 LOCATE 2, 25: PRINT "Remaining Gold:"; gold
 SELECT CASE attack
 CASE 1: a$ = "a Dagger"
 CASE 2: a$ = "a Shortsword"
 CASE 3: a$ = "a Broadsword"
 CASE 4: a$ = "a Battle Axe"
 CASE 10: a$ = "a Shadow Blade"
 CASE 23: a$ = "a Magic Blade"
 CASE 35: a$ = "Claws of Darkness"
 END SELECT
 LOCATE 4, 1: PRINT "You have "; a$, "Attack:"; attack
 PRINT
 PRINT "(D)agger: This small knife is very weak, but can be used by anybody."
 PRINT "     Cost: 25 gold coins.  Attack: 1"
 PRINT
 PRINT "(S)hortsword: This sword is small, but is stronger than the dagger.  It"
 PRINT "     cannot be used by the Wizard.   Cost: 150 gold coins.  Attack: 2"
 PRINT
 PRINT "(B)roadsword: This large sword is very powerful and is the starting"
 PRINT "     weapon for the barbarian.  It cannot be used by the"
 PRINT "     Wizard.   Cost: 250 gold coins.  Attack: 3"
 PRINT
 PRINT "B(a)ttle Axe: This is the most powerful weapon (that can be purchased)"
 PRINT "     in the game. It can not be used by the Wizard."
 PRINT "     Cost: 450 gold coins.  Attack: 4"
 PRINT
 COLOR 15
 PRINT "What do you wish to buy? (D/S/B/A/ESC)"
 DO
  a$ = UCASE$(INKEY$)
 LOOP UNTIL a$ = "D" OR a$ = "S" OR a$ = "B" OR a$ = "A" OR a$ = CHR$(27)
 SELECT CASE a$
 CASE "D"
  IF gold > 24 THEN
   gold = gold - 25
   attack = 1
   PRINT "OK"
  ELSE PRINT "Not enough gold"
  END IF
 CASE "S"
  IF char <> "Wizard   " THEN
   IF gold > 149 THEN
    gold = gold - 150
    attack = 2
    PRINT "OK"
   ELSE PRINT "Not enough gold"
   END IF
  ELSE PRINT "Cannot use"
  END IF
 CASE "B"
  IF char <> "Wizard   " THEN
   IF gold > 249 THEN
    gold = gold - 250
    attack = 3
    PRINT "OK"
   ELSE PRINT "Not enough gold"
   END IF
  ELSE PRINT "Cannot use"
  END IF
 CASE "A"
  IF char <> "Wizard   " THEN
   IF gold > 449 THEN
    IF armor(1) <> 1 THEN
     gold = gold - 450
     attack = 4
     PRINT "OK"
    ELSE PRINT "Cannot use with a shield"
    END IF
   ELSE PRINT "Not enough gold"
   END IF
  ELSE PRINT "Cannot use"
  END IF
 END SELECT
END SUB

SUB Center (row, text$)
 LOCATE row, 40 - INT(LEN(text$) / 2)
 PRINT text$
END SUB

SUB CharIntro
 CLS
 COLOR ((RND * 13) + 2)
 defense = 2
 SELECT CASE RTRIM$(char)
 CASE "Barbarian"
  Center 6, "   You are the barbarian,   "
  Center 7, "a powerful fighter.  Many   "
  Center 8, "monsters are weaker than you"
  Center 9, "because you have the most BP"
  Center 10, "and can use every weapon.   "
  BP = 8
  MaxBP = 8
  MP = 2
  attack = 3
 CASE "Dwarf"
  Center 6, "   You are the dwarf, a small"
  Center 7, "fighting machine.  Although  "
  Center 8, "you are not as powerful as   "
  Center 9, "the barbarian, you are more  "
  Center 10, "intelligent.                 "
  BP = 7
  MaxBP = 7
  MP = 3
  attack = 2
 CASE "Elf"
  Center 6, "   You are the elf.  You can use "
  Center 7, "all of the weapons and can cast  "
  Center 8, "three different spells.  You also"
  Center 9, "have much intelligence.          "
  BP = 6
  MaxBP = 6
  MP = 4
  attack = 2
 CASE "Wizard"
  Center 6, "   You are the wizard, caster of    "
  Center 7, "many spells.  You can use only one  "
  Center 8, "weapon and no armor.  Spells are    "
  Center 9, "the only way you will survive combat"
  BP = 4
  MaxBP = 4
  MP = 4
  attack = 1
 CASE "ZARGON"
  Center 6, "You are Zargon, the evil wizard.  You rule half of the   "
  Center 7, "world and command all monsters.  You have many spells and"
  Center 8, "are the second strongest fighter.  You have a weakness,  "
  Center 9, "though.  You do not recover BP and MP after rounds of    "
  Center 10, "combat.                                                  "
  PLAY "L13O0CDEFFAG"
  BP = 80
  MaxBP = 80
  MP = 35
  attack = 23
 CASE "SHADE"
  Center 6, "You are the Shadow Dragon, a strong monster that lives   "
  Center 7, "in the depths of the earth.  You are a powerful attacker."
  PLAY "L10O1GFEDCBAO0GFEDCBA"
  BP = 100
  MaxBP = 100
  attack = 35
  armor(3) = 6
 CASE "NINJA"
  Center 6, "You are the ninja.  You know four spells and have many"
  Center 7, "weapons and armors.  You are also very fast.          "
  PLAY "L20N60N70O5ABCDEFDBEEEGN50N40N30ABCDN80N75N74N73N72N71"
  BP = 12
  MaxBP = 12
  MP = 10
  attack = 10
  armor(1) = 2
  armor(2) = 2
  armor(3) = 3
 CASE "CHAD"
  Center 6, "You are Chad, the greatest wizard of all.  He can cast every"
  Center 7, "spell and has many, many mind points.  BEWARE!!, all enemies"
  Center 8, "of Chad, he will destroy you.                               "
  PLAY "L35N10N12N13N16N75N25N65N43N25N29N80N27O3BCDGAAABBCCCCCCABCDEFGN35N34N23N12N63N43ABGAGFEDCBAN21N20N19N18N17N16N15N14N13N13N13N13N12N11N10N9N8N7N6N5N4N3N2N1"
  BP = 150
  MaxBP = 150
  MP = 100
  attack = 4
 END SELECT
 WHILE INKEY$ = "": WEND
END SUB

SUB GetInputs
 CLS
 COLOR 15
 Center 2, "H E R O Q U E S T   1 / 2"
 Center 3, "Ver. 2.0"
 COLOR 9
 Center 4, "By:  Chad Austin"
 COLOR 13
 Center 7, "CHOOSE YOUR CHARACTER"
 DIM c(9 TO 12) AS STRING * 9
 c(9) = "Barbarian"
 c(10) = "Dwarf"
 c(11) = "Elf"
 c(12) = "Wizard"
 COLOR 12
 Center 9, c(9)
 COLOR 14
 Center 10, c(10)
 Center 11, c(11)
 Center 12, c(12)
 row = 9
 DIM a AS STRING * 6
 a = ""
 DO
  COLOR 15
  kbd$ = UCASE$(INKEY$)
  SELECT CASE kbd$
  CASE CHR$(0) + "P"
   COLOR 14
   Center row, c(row)
   row = row + 1
   IF row = 13 THEN row = 9
   COLOR 12
   Center row, c(row)
  CASE CHR$(0) + "H"
   COLOR 14
   Center row, c(row)
   row = row - 1
   IF row = 8 THEN row = 12
   COLOR 12
   Center row, c(row)
  CASE CHR$(13)
   char = c(row)
   EXIT DO
  CASE "A" TO "Z"
   a = RTRIM$(a) + kbd$
   IF a = "ZARGON" OR a = "CHAD  " OR a = "NINJA " OR a = "SHADE " THEN EXIT DO
  CASE CHR$(8): a = ""
  END SELECT
 LOOP
 IF a = "ZARGON" OR a = "CHAD  " OR a = "NINJA " OR a = "SHADE " THEN char = a
 Center 15, "Difficulty:  1"
 diff = 1
 DO
  kbd$ = INKEY$
  SELECT CASE kbd$
  CASE "+", "="
   LOCATE 15, 45: PRINT "  "
   IF diff < 10 THEN diff = diff + 1
   LOCATE 15, 45: PRINT USING "##"; diff
  CASE "-", "_"
   LOCATE 15, 45: PRINT "  "
   IF diff > 1 THEN diff = diff - 1
   LOCATE 15, 45: PRINT USING "##"; diff
  END SELECT
 LOOP UNTIL kbd$ = CHR$(13)
END SUB

SUB GetMagic
 SELECT CASE RTRIM$(char)
 CASE "Wizard", "Elf"
  DIM taken(1 TO 4)
  CLS
  COLOR 15
  Center 2, " Spell Groups "
  COLOR 12: Center 4, "1) FIRE "
  COLOR 6: Center 5, "2) EARTH"
  COLOR 11: Center 6, "3) WIND "
  COLOR 9: Center 7, "4) WATER"
  COLOR 7
  Center 10, RTRIM$(char) + ", choose a spell group (1-4):"
  DO
   x = VAL(INKEY$)
  LOOP UNTIL x > 0 AND x < 5
  taken(x) = 1
  Center x + 3, SPACE$(8)
  IF char = "Wizard   " THEN
   Center 11, "Wizard, choose a spell group (1-4):"
   DO
    x = VAL(INKEY$)
    IF x > 0 AND x < 5 THEN IF taken(x) = 0 THEN done = 1
   LOOP UNTIL done
   Center x + 3, SPACE$(8)
   done = 0
   taken(x) = 1
   Center 12, "Wizard, choose a spell group (1-4):"
   DO
    x = VAL(INKEY$)
    IF x > 0 AND x < 5 THEN IF taken(x) = 0 THEN done = 1
   LOOP UNTIL done
   Center x + 3, SPACE$(8)
   done = 0
   taken(x) = 1
  END IF
  IF taken(1) THEN
   spell(1) = "BALL OF FLAME"
   spell(2) = "FIRE OF WRATH"
   spell(3) = "COURAGE"
  END IF
  IF taken(2) THEN
   spell(7) = "HEAL BODY"
   spell(8) = "PASS THROUGH ROCK"
   spell(9) = "ROCK SKIN"
  END IF
  IF taken(3) THEN
   spell(10) = "GENIE"
   spell(11) = "TEMPEST"
   spell(12) = "SWIFT WIND"
  END IF
  IF taken(4) THEN
   spell(4) = "SLEEP"
   spell(5) = "VEIL OF MIST"
   spell(6) = "WATER OF HEALING"
  END IF
 CASE "ZARGON"
  spell(1) = "FIRE STORM"
  spell(2) = "BALL OF FLAME"
  spell(3) = "MIND BLAST"
  spell(4) = "RESTORE CHAOS"
  spell(5) = "ESCAPE"
  spell(6) = "LIGHTNING BOLT"
  spell(7) = "TEMPEST"
  spell(8) = "SLEEP"
  spell(9) = "RUST"
  spell(10) = "CLOUD OF CHAOS"
  spell(11) = "FEAR"
 CASE "NINJA"
  spell(1) = "DRAGON FIRE"
  spell(2) = "FLOOD"
  spell(3) = "DRAIN"
  spell(4) = "SHADOW"
 CASE "CHAD"
  spell(1) = "BALL OF FLAME"
  spell(2) = "FIRE OF WRATH"
  spell(3) = "DRAGON FIRE"
  spell(4) = "FIRE STORM"
  spell(5) = "COURAGE"
  spell(6) = "GENIE"
  spell(7) = "SWIFT WIND"
  spell(8) = "TEMPEST"
  spell(9) = "WATER OF HEALING"
  spell(10) = "SLEEP"
  spell(11) = "VEIL OF MIST"
  spell(12) = "ROCK SKIN"
  spell(13) = "PASS THROUGH ROCK"
  spell(14) = "HEAL BODY"
  spell(15) = "MIND BLAST"
  spell(16) = "RESTORE CHAOS"
  spell(17) = "ESCAPE"
  spell(18) = "LIGHTNING BOLT"
  spell(19) = "SLEEP"
  spell(20) = "RUST"
  spell(21) = "CLOUD OF CHAOS"
  spell(22) = "FEAR"
  spell(23) = "FLOOD"
  spell(24) = "DRAIN"
  spell(25) = "SHADOW"
 END SELECT
 IF char <> "CHAD     " AND char <> "ZARGON   " AND char <> "SHADE    " THEN BP = MaxBP
END SUB

SUB Shop
 DO
  PRINT "What do you need? (Weapons/Armor/Items)"
  DO
   a$ = UCASE$(INKEY$)
  LOOP UNTIL a$ = "W" OR a$ = "A" OR a$ = "I"
  SELECT CASE a$
  CASE "W": BuyWeapons
  CASE "A": IF char <> "Wizard   " THEN BuyArmor ELSE PRINT "You cannot use any of the armor here.": WHILE INKEY$ = "": WEND
  CASE "I": BuyItems
  END SELECT
  PRINT "Buy something else? (Y/N)"
  DO
   a$ = UCASE$(INKEY$)
  LOOP UNTIL a$ = "N" OR a$ = "Y"
 LOOP UNTIL a$ = "N"
END SUB

