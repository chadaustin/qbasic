DECLARE SUB pow ()
DECLARE SUB door ()
CLS
PRINT "***********************************************"
PRINT " Welcome to Starship Trooper"
PRINT " Version 1"
PRINT " Programmed by Michael Van Waardhuizen"
PRINT " **********************************************"
INPUT ""; a$
5  CLS
   SCREEN 12
   COLOR 7
 CALL door
  SLEEP 1
  LOCATE 10, 30: PRINT "4"
    SLEEP 1
  COLOR 0: LOCATE 10, 30: PRINT "4"
  COLOR 7: LOCATE 11, 30: PRINT "3"
    SLEEP 1
   COLOR 0: LOCATE 11, 30: PRINT "3"
   COLOR 7: LOCATE 12, 30: PRINT "2"
     SLEEP 1
   COLOR 0:  LOCATE 12, 30: PRINT "2"
    COLOR 7: LOCATE 13, 30: PRINT "1"
   SLEEP 1
  SCREEN 1
  COLOR 0
  PRINT ""
  PRINT ""
  PRINT ""
  PRINT ""
  PRINT ""
  PRINT ""
  PRINT ""
  PRINT ""
  PRINT ""
  PRINT ""
  PRINT ""
  PRINT "           STARSHIP TROOPER"
6

7
  c = INT(RND * 14) + 1
  COLOR c
  PLAY "o0  ms l64 abc"
   in$ = INKEY$
   IF in$ <> "" THEN 10 ELSE 7

10 SCREEN 12
   CLS
   COLOR 7
   PRINT " Welcome to Starship Trooper. In this game you will battle aliens,"
   PRINT " explore towns, upgrade weapons, earn CREDITS,"
   PRINT " and MUCH more."
   PRINT ""
   PRINT " Press <enter>"
   COLOR 9
   INPUT ""; a$
   IF a$ = "g" THEN 30 ELSE 15
   GOTO 15

15 CLS
   COLOR 7
   PRINT " First you must start at Boot Camp. As your experience goes up"
   PRINT " you will assume higher levels of command, more power, etc."
   PRINT " More men increase your power and hit points."
   PRINT ""
   COLOR 7
   PRINT "1) Level 1 - Boot Camp - for beginners"
   PRINT "2) Level 2 - Private - done practicing? 1st mission"
   PRINT "3) Level 3 - Sergeant - harder missions, more bugs"
   PRINT "4) Level 4 - Corporal - new enemies"
   PRINT "5) Level 5 - Sergeant at Arms - in charge of squadron"
   PRINT "6) Level 6 - Leuitenent - in charge of company and ship"
   COLOR 9
   PRINT " So, Press enter!"
   INPUT ""; e$
         IF e$ = "" THEN POWER% = 15
         IF e$ = "Feelin' Groovy" THEN POWER% = 2000
         IF e$ = "" THEN SPEED% = 15
         IF e$ = "Feelin' Groovy" THEN SPEED% = 100
         IF e$ = "" THEN CREDITS% = 10
         IF e$ = "Feelin' Groovy" THEN CREDITS% = 10000
         IF e$ = "" THEN CHAR% = 1
         IF e$ = "Feelin' Groovy" THEN CHAR% = 7
         IF e$ = "" THEN men% = 0
         IF e$ = "Feelin' Groovy" THEN men% = 10
         IF e$ = "" THEN WEPON$ = "FirePills"
         IF e$ = "Feelin' Groovy" THEN WEPON$ = "DragonFire"
         IF e$ = "" THEN HITPTS% = 35
         IF e$ = "Feelin' Groovy" THEN HITPTS% = 9999
         IF e$ = "" THEN XP% = 0
         IF e$ = "Feelin' Groovy" THEN XP% = 0
         IF e$ = "" THEN GOTO 20
         IF e$ = "Feelin' Groovy" THEN GOTO 20
         GOTO 15

20 CLS
   COLOR 7
   PRINT "Class Number:"; CHAR%; "         "
   PRINT "Hit Points:"; HITPTS%; "         "
   PRINT "Power level:"; POWER%; "         "
   PRINT "Experience:"; XP%; "               "
   PRINT "Speed level:"; SPEED%; "         "
   PRINT "Weapon:"; WEPON$; "      "
   PRINT "CREDITS:"; CREDITS%; "                 "
   PRINT "MEN:"; men%; "           "
   COLOR 9
   PRINT " These are your Stats"
   INPUT zz$
         GOTO 21

21 COLOR 7
   PRINT " OK. Would you like the background story of Starship Trooper?"
   INPUT "y,n"; a$
     IF a$ = "n" THEN 25
     IF a$ = "y" THEN 22
     CLS
     GOTO 21

22 CLS
   COLOR 7
   PRINT " -------------- Starship Trooper -------------------"
   PRINT ""
   PRINT "Earth, the future "
   PRINT "You join the Military on your 18th birthday to help pay "
   PRINT "for University and a better job and life. No wars are happening "
   PRINT "so it seems like a no risk deal. When you finish a hellish "
   PRINT "year of Boot camp you are in the middle of a full scale war! "
   PRINT "You have three years left in your term, fighting alien bugs, "
   PRINT "which are a 6 foot cross between ants and spiders, and skinnies, "
   PRINT "tall skinny humanoids."
   PRINT " GOOD LUCK..........."
   COLOR 9
   INPUT zz$
   GOTO 25

25  CLS
    COLOR 7
    PRINT " Good, then let's begin."
    PRINT " As the adventure opens, you are on earth with two friends "
    PRINT " awaiting your next mission."
    COLOR 7
    PRINT " Good Luck! Press enter to continue!"
    INPUT zz$
    GOTO 30

30 CLS
   VIEW SCREEN (320, 20)-(620, 440), , 1
   CALL pow
   IF a$ <> "Feelin' Groovy" THEN men% = 2
   COLOR 4
   PRINT "--------------------------"
   COLOR 7
   PRINT "Class Number:"; CHAR%; "         "
   PRINT "Hit Points:"; HITPTS%; "         "
   PRINT "Power level:"; POWER%; "          "
   PRINT "Experience:"; XP%; "               "
   PRINT "Speed level:"; SPEED%; "          "
   PRINT " Weapon:"; WEPON$; "      "
   PRINT "CREDITS:"; CREDITS%; "              "
   PRINT "MEN:"; men%; "                  "
   COLOR 4
   PRINT "--------------------------"
   COLOR 7
   PRINT " British Columbia, Canada."
   COLOR 7
   PRINT " You are in the city of Vancouver."
   PRINT " The town is large and the buildings"
   PRINT " look relatively new. The people"
   PRINT " greet you as they pass and they"
   PRINT " stop to talk here and there with"
   PRINT " their nieghbors. Looking out from the"
   PRINT " town, you can see the faint outline of"
   PRINT " mountains AND a small river that"
   PRINT " flows from it. "
   PRINT ""
   COLOR 9
   PRINT " You can visit a bar, or return to "
   PRINT " the base. "
   PRINT " (b)ar      "
   PRINT " (r)eturn to ship     (q)uit"
   INPUT ""; a$
         IF a$ = "b" THEN 35
         IF a$ = "r" THEN 250
         IF a$ = "q" THEN 9999
         CLS
         GOTO 30



35 CALL pow
   COLOR 4
   PRINT "--------------------------"
   COLOR 7
   PRINT "Class Number:"; CHAR%; "         "
   PRINT "Hit Points:"; HITPTS%; "         "
   PRINT "Power level:"; POWER%; "          "
   PRINT "Experience:"; XP%; "               "
   PRINT "Speed level:"; SPEED%; "          "
   PRINT " Weapon:"; WEPON$; "      "
   PRINT "CREDITS:"; CREDITS%; "              "
   PRINT "MEN:"; men%; "                  "
   COLOR 4
   PRINT "--------------------------"
  
   COLOR 7
   PRINT " Welcome to The Rusty Nail"
   COLOR 7
   PRINT " As you walk in, the smells of the"
   PRINT " place overwhelm you. You can smell the"
   PRINT " distant smell of bread baking AND beer"
   PRINT " brewing. The bartender tips his hat to"
   PRINT " you as you enter the dimly lit pub. You"
   PRINT " look around. There is a small table of men"
   PRINT " playing a game for CREDITS. There are some"
   PRINT " people talking in several corners of the pub."
   PRINT " The customers greet you with a smile."
   COLOR 9
   PRINT " Here's what you may do here."
   PRINT " (e)xit pub   (g)amble    (c)hat"
   INPUT "e,g,c?"; a$
         IF a$ = "e" THEN 30
         IF a$ = "g" THEN 37
         IF a$ = "c" THEN 48
         CLS
         GOTO 35

37 CLS
   COLOR 4
   PRINT "--------------------------"
   COLOR 7
   PRINT "Class Number:"; CHAR%; "         "
   PRINT "Hit Points:"; HITPTS%; "         "
   PRINT "Power level:"; POWER%; "          "
   PRINT "Experience:"; XP%; "               "
   PRINT "Speed level:"; SPEED%; "          "
   PRINT " Weapon:"; WEPON$; "      "
   PRINT "CREDITS:"; CREDITS%; "              "
   PRINT "MEN:"; men%; "                  "
   COLOR 4
   PRINT "--------------------------"
  
   COLOR 7
   PRINT " You walk up to the gambling table."
   PRINT " The man sitting at the head of table invites you to play."
   PRINT " You take a seat. The men introduce themselves and then."
   PRINT " they tell you it's 5 CREDITS per round to play thier game."
   PRINT " They ask if you wish to play."
   PRINT ""
   COLOR 9
   PRINT " (a)sk about rules  (p)lay  (l)eave table"
   INPUT "a,p,l"; a$
        IF a$ = "l" THEN 35
        IF a$ = "a" THEN 38
        IF a$ = "p" THEN 40
        CLS
        GOTO 37

38 CLS
   COLOR 4
   PRINT "--------------------------"
   COLOR 7
   PRINT "Class Number:"; CHAR%; "         "
   PRINT "Hit Points:"; HITPTS%; "         "
   PRINT "Power level:"; POWER%; "          "
   PRINT "Experience:"; XP%; "               "
   PRINT "Speed level:"; SPEED%; "          "
   PRINT " Weapon:"; WEPON$; "      "
   PRINT "CREDITS:"; CREDITS%; "              "
   PRINT "MEN:"; men%; "                  "
   COLOR 4
   PRINT "--------------------------"
  
   COLOR 7
   PRINT " They tell you the rules:"
   COLOR 7
   PRINT " 1) You put down 5 CREDITS on the table."
   PRINT " 2) The person at the head of the table thinks of a number."
   PRINT " 3) If you guess it right, you get everyone's CREDITS at the table!"
   PRINT "    If your wrong, someone else get's your money."
   PRINT ""
   PRINT " You thank them for the rules."
   COLOR 9
   INPUT zz$
   GOTO 37

40 CLS
   COLOR 4
   PRINT "--------------------------"
   COLOR 7
   PRINT "Class Number:"; CHAR%; "         "
   PRINT "Hit Points:"; HITPTS%; "         "
   PRINT "Power level:"; POWER%; "          "
   PRINT "Experience:"; XP%; "               "
   PRINT "Speed level:"; SPEED%; "          "
   PRINT " Weapon:"; WEPON$; "      "
   PRINT "CREDITS:"; CREDITS%; "              "
   PRINT "MEN:"; men%; "                  "
   COLOR 4
   PRINT "--------------------------"
  
   COLOR 7
   PRINT " You are ready to play. You put down five CREDITS on the table."
   CREDITS% = CREDITS% - 5
   PRINT " The master of the table has the number written on a card."
   PRINT " He tells you to guess it. The number is 1 through 5."
   PRINT ""
   COLOR 9
   x = INT(RND * 5) + 1
   INPUT "Your guess"; a
         IF a = x THEN 42 ELSE 41
         CLS
         GOTO 40

41 CLS
   COLOR 4
   PRINT "--------------------------"
   COLOR 7
   PRINT "Class Number:"; CHAR%; "         "
   PRINT "Hit Points:"; HITPTS%; "         "
   PRINT "Power level:"; POWER%; "          "
   PRINT "Experience:"; XP%; "               "
   PRINT "Speed level:"; SPEED%; "          "
   PRINT " Weapon:"; WEPON$; "      "
   PRINT "CREDITS:"; CREDITS%; "              "
   PRINT "MEN:"; men%; "                  "
   COLOR 4
   PRINT "--------------------------"
  
   COLOR 7
   PRINT " Oh, no! The number was wrong."
   PRINT " The cheery group laughs it off and encourages you to play again."
   PRINT " You decline and leave the table. They tell you to come back"
   PRINT " anytime."
   PRINT ""
   COLOR 9
   INPUT zz$
   GOTO 35

42 CLS
   COLOR 4
   PRINT "--------------------------"
   COLOR 7
   PRINT "Class Number:"; CHAR%; "         "
   PRINT "Power level:"; POWER%; "          "
   PRINT "Experience:"; XP%; "               "
   PRINT "Speed level:"; SPEED%; "          "
   PRINT " Weapon:"; WEPON$; "      "
   PRINT "CREDITS:"; CREDITS%; "              "
   PRINT "MEN:"; men%; "                  "
   COLOR 4
   PRINT "--------------------------"
  
   COLOR 7
   PRINT " That number is correct! You collect 30 CREDITS!"
   CREDITS% = CREDITS% + 30
   PRINT " The men hand you thier money and congratulate you."
   PRINT " You tell them you must leave for now, but will be back."
   PRINT " They tell you to come back soon."
   PRINT ""
   COLOR 9
   INPUT zz$
   GOTO 35

48 CLS
   CALL pow
   COLOR 4
   PRINT "--------------------------"
   COLOR 7
   PRINT "Class Number:"; CHAR%; "         "
   PRINT "Power level:"; POWER%; "          "
   PRINT "Experience:"; XP%; "               "
   PRINT "Speed level:"; SPEED%; "          "
   PRINT " Weapon:"; WEPON$; "      "
   PRINT "CREDITS:"; CREDITS%; "              "
   PRINT "MEN:"; men%; "                  "
   COLOR 4
   PRINT "--------------------------"
  
   COLOR 7
   PRINT " You walk over to a group of men..."
   PRINT " You talk to an old man who tells you that the sailors are very"
   PRINT " dangerous and should be avoided. He is the only one in"
   PRINT " the group who is not drunk. You leave the others alone."
   PRINT " You thank the old man and leave the group."
   PRINT ""
   COLOR 9
   INPUT zz$
   GOTO 35




100 CLS
   COLOR 4
   PRINT "--------------------------"
   COLOR 7
   PRINT "Class Number:"; CHAR%; "         "
   PRINT "Hit Points:"; HITPTS%; "         "
   PRINT "Power level:"; POWER%; "          "
   PRINT "Experience:"; XP%; "               "
   PRINT "Speed level:"; SPEED%; "          "
   PRINT " Weapon:"; WEPON$; "      "
   PRINT "CREDITS:"; CREDITS%; "              "
   PRINT "MEN:"; men%; "                  "
   COLOR 4
   PRINT "--------------------------"
   
    COLOR 7
    PRINT " MILITARY WEAPON DEPOT."
    COLOR 4
    PRINT ""
    PRINT " You may purchase a variety of weapons here."
    PRINT " Here is a list of items and prices."
    COLOR 7
    PRINT " Fire Pills     -  15 CREDITS"
    PRINT " Gyroscopes     -  10 CREDITS"
    PRINT " H.E.Bombs      -  20 CREDITS"
    PRINT " Flamer         -  30 CREDITS"
    PRINT " Armor L1       -  40 CREDITS"
    PRINT " Rockets        -  50 credits "
    PRINT " Servos         -  50 credits"
    COLOR 9
    PRINT " (p)urchase an item     (l)earn about an item"
    PRINT " (e)xit the shop"
    INPUT "p,e,l?"; a$
      IF a$ = "p" THEN 110
      IF a$ = "l" THEN 105
      IF a$ = "e" THEN 301
      CLS
      GOTO 100

105 CLS
   COLOR 4
   PRINT "--------------------------"
   COLOR 7
   PRINT "Class Number:"; CHAR%; "         "
   PRINT "Hit Points:"; HITPTS%; "         "
   PRINT "Power level:"; POWER%; "          "
   PRINT "Experience:"; XP%; "               "
   PRINT "Speed level:"; SPEED%; "          "
   PRINT " Weapon:"; WEPON$; "      "
   PRINT "CREDITS:"; CREDITS%; "              "
   PRINT "MEN:"; men%; "                  "
   COLOR 4
   PRINT "--------------------------"
   
    COLOR 7
    PRINT " Item and description listing..."
    COLOR 4
    PRINT " Fire Pills   - adds 2 power "
    PRINT " Gyroscopes   - adds 3 speed to your character"
    PRINT " H.E.Bombs    - 20 power "
    PRINT " Flamer       - 25 power "
    PRINT " Rockets      - 35 power "
    PRINT " Servos       - adds 5 speed"
    INPUT zz$
    GOTO 100

110 CLS
   COLOR 4
   PRINT "--------------------------"
   COLOR 7
   PRINT "Class Number:"; CHAR%; "         "
   PRINT "Hit Points:"; HITPTS%; "         "
   PRINT "Power level:"; POWER%; "          "
   PRINT "Experience:"; XP%; "               "
   PRINT "Speed level:"; SPEED%; "          "
   PRINT " Weapon:"; WEPON$; "      "
   PRINT "CREDITS:"; CREDITS%; "              "
   PRINT "MEN:"; men%; "                  "
   COLOR 4
   PRINT "--------------------------"
   
    COLOR 7
    PRINT " Purchase a weapon or item."
    COLOR 7
    PRINT " (f)ire pills"
    PRINT " (g)yros"
    PRINT " (H)E. bombs"
    PRINT " (fl)amer"
    PRINT " (r)ockets"
    PRINT " (s)ervos"
    COLOR 4
    PRINT " (n) don't purchase anything"
    COLOR 9
    INPUT ""; a$
      IF a$ = "f" THEN 115
      IF a$ = "g" THEN 120
      IF a$ = "H" THEN 125
      IF a$ = "fl" THEN 130
      IF a$ = "n" THEN 100
      IF a$ = "r" THEN 116
      IF a$ = "s" THEN 123
      CLS
      GOTO 110

115 CLS
   COLOR 4
   PRINT "--------------------------"
   COLOR 7
   PRINT "Class Number:"; CHAR%; "         "
   PRINT "Hit Points:"; HITPTS%; "         "
   PRINT "Power level:"; POWER%; "          "
   PRINT "Experience:"; XP%; "               "
   PRINT "Speed level:"; SPEED%; "          "
   PRINT " Weapon:"; WEPON$; "      "
   PRINT "CREDITS:"; CREDITS%; "              "
   PRINT "MEN:"; men%; "                  "
   COLOR 4
   PRINT "--------------------------"
   
    COLOR 7
    IF CREDITS% <= 14 THEN 140
    PRINT " You have purchased fire pills!"
    CREDITS% = CREDITS% - 15
    POWER% = POWER% + 2
    PRINT ""
    PRINT " You have spent 15 CREDITS and gained 2 power..."
    INPUT zz$
    GOTO 100

116 CLS
   COLOR 4
   PRINT "--------------------------"
   COLOR 7
   PRINT "Class Number:"; CHAR%; "         "
   PRINT "Hit Points:"; HITPTS%; "         "
   PRINT "Power level:"; POWER%; "          "
   PRINT "Experience:"; XP%; "               "
   PRINT "Speed level:"; SPEED%; "          "
   PRINT " Weapon:"; WEPON$; "      "
   PRINT "CREDITS:"; CREDITS%; "              "
   PRINT "MEN:"; men%; "                  "
   COLOR 4
   PRINT "--------------------------"
   
    COLOR 7
    IF WEPON$ = "Rokets" THEN 135
    IF CREDITS% <= 49 THEN 140
    PRINT " You have purchased rockets!"
    CREDITS% = CREDITS% - 50
    POWER% = 35
    WEPON$ = "Rokets"
    PRINT ""
    PRINT " You have spent 50 CREDITS and gained 35 power..."
    INPUT zz$
    GOTO 100

120 CLS
   COLOR 4
   PRINT "--------------------------"
   COLOR 7
   PRINT "Class Number:"; CHAR%; "         "
   PRINT "Hit Points:"; HITPTS%; "         "
   PRINT "Power level:"; POWER%; "          "
   PRINT "Experience:"; XP%; "               "
   PRINT "Speed level:"; SPEED%; "          "
   PRINT " Weapon:"; WEPON$; "      "
   PRINT "CREDITS:"; CREDITS%; "              "
   PRINT "MEN:"; men%; "                  "
   COLOR 4
   PRINT "--------------------------"
   
    COLOR 7
    IF CREDITS% <= 9 THEN 140
    PRINT " You have purchased gyroscope upgrades!"
    CREDITS% = CREDITS% - 10
    SPEED% = SPEED% + 15
    PRINT ""
    PRINT " You have spent 10 CREDITS and gained 15 speed..."
    INPUT zz$
    GOTO 100

123 CLS
   COLOR 4
   PRINT "--------------------------"
   COLOR 7
   PRINT "Class Number:"; CHAR%; "         "
   PRINT "Hit Points:"; HITPTS%; "         "
   PRINT "Power level:"; POWER%; "          "
   PRINT "Experience:"; XP%; "               "
   PRINT "Speed level:"; SPEED%; "          "
   PRINT " Weapon:"; WEPON$; "      "
   PRINT "CREDITS:"; CREDITS%; "              "
   PRINT "MEN:"; men%; "                  "
   COLOR 4
   PRINT "--------------------------"
   
    COLOR 7
    IF CREDITS% <= 49 THEN 140
    PRINT " You have purchased servo upgrades!"
    CREDITS% = CREDITS% - 50
    SPEED% = SPEED% + 10
    POWER% = POWER% + 10
    PRINT ""
    PRINT " You have spent 50 CREDITS and gained 10 powerand 10 speed..."
    INPUT zz$
    GOTO 100

125 CLS
   COLOR 4
   PRINT "--------------------------"
   COLOR 7
   PRINT "Class Number:"; CHAR%; "         "
   PRINT "Hit Points:"; HITPTS%; "         "
   PRINT "Power level:"; POWER%; "          "
   PRINT "Experience:"; XP%; "               "
   PRINT "Speed level:"; SPEED%; "          "
   PRINT " Weapon:"; WEPON$; "      "
   PRINT "CREDITS:"; CREDITS%; "              "
   PRINT "MEN:"; men%; "                  "
   COLOR 4
   PRINT "--------------------------"
   
    COLOR 7
    IF WEPON$ = "HE" THEN 135
    IF CREDITS% <= 19 THEN 140
    PRINT " You have purchased H.E. bombs!"
    CREDITS% = CREDITS% - 20
    POWER% = 20
    WEPON$ = "HE"
    INPUT zz$
    GOTO 100

130 CLS
   COLOR 4
   PRINT "--------------------------"
   COLOR 7
   PRINT "Class Number:"; CHAR%; "         "
   PRINT "Hit Points:"; HITPTS%; "         "
   PRINT "Power level:"; POWER%; "          "
   PRINT "Experience:"; XP%; "               "
   PRINT "Speed level:"; SPEED%; "          "
   PRINT " Weapon:"; WEPON$; "      "
   PRINT "CREDITS:"; CREDITS%; "              "
   PRINT "MEN:"; men%; "                  "
   COLOR 4
   PRINT "--------------------------"
   
    COLOR 7
    IF WEPON$ = "flamer" THEN 135
    IF CREDITS% <= 29 THEN 140
    PRINT " You have purchased the flamer!"
    CREDITS% = CREDITS% - 30
    POWER% = 25
    WEPON$ = "flamer"
    PRINT " You have gained 25 power and spent 30 CREDITS..."
    INPUT zz$
    GOTO 100

135 CLS
    COLOR 4
    PRINT " You already have this!"
    INPUT zz$
    GOTO 100


140 CLS
   COLOR 4
   PRINT "--------------------------"
   COLOR 7
   PRINT "Class Number:"; CHAR%; "         "
   PRINT "Hit Points:"; HITPTS%; "         "
   PRINT "Power level:"; POWER%; "          "
   PRINT "Experience:"; XP%; "               "
   PRINT "Speed level:"; SPEED%; "          "
   PRINT " Weapon:"; WEPON$; "      "
   PRINT "CREDITS:"; CREDITS%; "              "
   PRINT "MEN:"; men%; "                  "
   COLOR 4
   PRINT "--------------------------"
   
    COLOR 4
    PRINT " You do not have enough money for this item."
    PRINT " Try again when you have enough CREDITS..."
    INPUT zz$
    GOTO 100




250 CLS
   COLOR 4
   PRINT "--------------------------"
   COLOR 7
   PRINT "Class Number:"; CHAR%; "         "
   PRINT "Hit Points:"; HITPTS%; "         "
   PRINT "Power level:"; POWER%; "          "
   PRINT "Experience:"; XP%; "               "
   PRINT "Speed level:"; SPEED%; "          "
   PRINT " Weapon:"; WEPON$; "      "
   PRINT "CREDITS:"; CREDITS%; "              "
   PRINT "MEN:"; men%; "                  "
   COLOR 4
   PRINT "--------------------------"
   
    COLOR 7
    PRINT " You walk to the bus terminal."
    COLOR 7
    PRINT ""
    PRINT " The bus back to the Military Docking zone costs 10 credits."
    PRINT " Do you have it? Don't lie..."
    COLOR 9
    INPUT "y or n?"; a$
       IF a$ = "n" THEN 255
       IF a$ = "y" THEN 265
       CLS
       GOTO 250

255 CLS
   COLOR 4
   PRINT "--------------------------"
   COLOR 7
   PRINT "Class Number:"; CHAR%; "         "
   PRINT "Hit Points:"; HITPTS%; "         "
   PRINT "Power level:"; POWER%; "          "
   PRINT "Experience:"; XP%; "               "
   PRINT "Speed level:"; SPEED%; "          "
   PRINT " Weapon:"; WEPON$; "      "
   PRINT "CREDITS:"; CREDITS%; "              "
   PRINT "MEN:"; men%; "                  "
   COLOR 4
   PRINT "--------------------------"
   
    COLOR 7
    PRINT " You tell the guard that you don't have the fee."
    PRINT ""
    PRINT " He tells you to "
    PRINT " try gambling in the pub."
    PRINT " He let's you back into the town."
    INPUT zz$
    GOTO 30

265 CLS
   COLOR 4
   PRINT "--------------------------"
   COLOR 7
   PRINT "Class Number:"; CHAR%; "         "
   PRINT "Hit Points:"; HITPTS%; "         "
   PRINT "Power level:"; POWER%; "          "
   PRINT "Experience:"; XP%; "               "
   PRINT "Speed level:"; SPEED%; "          "
   PRINT " Weapon:"; WEPON$; "      "
   PRINT "CREDITS:"; CREDITS%; "              "
   PRINT "MEN:"; men%; "                  "
   COLOR 4
   PRINT "--------------------------"
   
    COLOR 7
    PRINT " You reach into your wallet."
    PRINT " You tell the guard that you have the fee..."
    INPUT zz$
    IF CREDITS% < 10 THEN 270
    IF CREDITS% >= 10 THEN 280
    CLS
    GOTO 265

270 CLS
   COLOR 4
   PRINT "--------------------------"
   COLOR 7
   PRINT "Class Number:"; CHAR%; "         "
   PRINT "Hit Points:"; HITPTS%; "         "
   PRINT "Power level:"; POWER%; "          "
   PRINT "Experience:"; XP%; "               "
   PRINT "Speed level:"; SPEED%; "          "
   PRINT " Weapon:"; WEPON$; "      "
   PRINT "CREDITS:"; CREDITS%; "              "
   PRINT "MEN:"; men%; "                  "
   COLOR 4
   PRINT "--------------------------"
   
    COLOR 4
    PRINT " The guard warns you about lying and then puts you back into"
    PRINT " the town. He tells you NOT to lie again."
    PRINT " He also adds liars shall be executed!"
    INPUT zz$
    GOTO 30

280 CLS
    COLOR 4
    PRINT "--------------------------"
    COLOR 7
    PRINT "Class Number:"; CHAR%; "         "
    PRINT "Hit Points:"; HITPTS%; "         "
    PRINT "Power level:"; POWER%; "          "
    PRINT "Experience:"; XP%; "               "
    PRINT "Speed level:"; SPEED%; "          "
    PRINT " Weapon:"; WEPON$; "      "
    PRINT "CREDITS:"; CREDITS%; "              "
    PRINT "MEN:"; men%; "                  "
    COLOR 4
    PRINT "--------------------------"
    GOTO 300

300 CLS
    CREDITS% = CREDITS% - 10
   COLOR 4
   PRINT "--------------------------"
   COLOR 7
   PRINT "Class Number:"; CHAR%; "         "
   PRINT "Hit Points:"; HITPTS%; "         "
   PRINT "Power level:"; POWER%; "          "
   PRINT "Experience:"; XP%; "               "
   PRINT "Speed level:"; SPEED%; "          "
   PRINT " Weapon:"; WEPON$; "      "
   PRINT "CREDITS:"; CREDITS%; "              "
   PRINT "MEN:"; men%; "                  "
   COLOR 4
   PRINT "--------------------------"
   GOTO 2000
301 CLS
         IF a$ = "Feelin' Groovy" THEN 302
         IF XP% >= 15 THEN CHAR% = 2
         IF XP% >= 25 THEN CHAR% = 3
         IF XP% >= 40 THEN CHAR% = 4
         IF XP% >= 80 THEN CHAR% = 5
         IF XP% >= 140 THEN CHAR% = 6
         men% = 0
         IF CHAR% = 2 THEN men% = 0
         IF CHAR% = 3 THEN men% = 0
         IF CHAR% = 4 THEN men% = 0
         IF CHAR% = 5 THEN men% = 20
         IF CHAR% = 6 THEN men% = 60
         IF CHAR% = 1 THEN HITPTS% = 35
         IF CHAR% = 2 THEN HITPTS% = 60
         IF CHAR% = 3 THEN HITPTS% = 100
         IF CHAR% = 4 THEN HITPTS% = 175
         IF CHAR% = 5 THEN HITPTS% = 175
         IF CHAR% = 6 THEN HITPTS% = 175
         COLOR 4
   PRINT "--------------------------"
302   COLOR 7
   PRINT "Class Number:"; CHAR%; "         "
   PRINT "Hit Points:"; HITPTS%; "         "
   PRINT "Power level:"; POWER%; "          "
   PRINT "Experience:"; XP%; "               "
   PRINT "Speed level:"; SPEED%; "          "
   PRINT " Weapon:"; WEPON$; "      "
   PRINT "CREDITS:"; CREDITS%; "              "
   PRINT "MEN:"; men%; "                  "
   COLOR 4
   PRINT "--------------------------"
    COLOR 7
    PRINT " You are back on the ship."
    PRINT " You can go to the ship weapon depot, go to town,"
    PRINT "or do the next mission."
    COLOR 9
    PRINT " (w)eapon depot      (m)ission     (t)own   "
    INPUT ""; a$
    IF a$ = "w" THEN 100
    IF a$ = "m" THEN 2003
    IF a$ = "t" THEN 520
    GOTO 301

400 CLS
    men% = 2
    COLOR 4
    PRINT "--------------------------"
    COLOR 7
    PRINT "Class number"; CHAR%; "              "
    PRINT "Hit Points:"; HITPTS%; "         "
    PRINT "Power level:"; POWER%; "          "
    PRINT "Experience:"; XP%; "               "
    PRINT "Speed level:"; SPEED%; "          "
   PRINT " Weapon:"; WEPON$; "      "
   PRINT "CREDITS:"; CREDITS%; "              "
   PRINT "MEN:"; men%; "                  "
   COLOR 4
   PRINT "--------------------------"
   COLOR 7
   PRINT " Venice, Italy."
   COLOR 7
   PRINT " You are in the city of Venice."
   PRINT " The town is large and the buildings look"
   PRINT " old and gothic. The people ignore you as they pass"
   PRINT " and they stop to talk with each other in rapid italian"
   PRINT " that means next to nothing to you. In the distance you see"
   PRINT " the faint outline of mountains above rolling foothills and"
   PRINT " a miriad of rivers which flow from them. "
   PRINT ""
   COLOR 9
   PRINT " You can visit a cafe, or return to "
   PRINT " the base. "
   PRINT " (b)ar      "
   PRINT " (r)eturn to ship     (q)uit"
   INPUT ""; a$
         IF a$ = "b" THEN 410
         IF a$ = "r" THEN 440
         IF a$ = "q" THEN 9999
         CLS
         GOTO 400



410 CLS
   COLOR 4
   PRINT "--------------------------"
   COLOR 7
   PRINT "Class Number:"; CHAR%; "         "
   PRINT "Hit Points:"; HITPTS%; "         "
   PRINT "Power level:"; POWER%; "          "
   PRINT "Experience:"; XP%; "               "
   PRINT "Speed level:"; SPEED%; "          "
   PRINT " Weapon:"; WEPON$; "      "
   PRINT "CREDITS:"; CREDITS%; "              "
   PRINT "MEN:"; men%; "                  "
   COLOR 4
   PRINT "--------------------------"
 
   COLOR 7
   PRINT " Welcome to Cafe au lait."
   COLOR 7
   PRINT " You wade through the sidewalk cafe and enter the stone"
   PRINT " building. The interior is poorly lit but has charactor."
   PRINT " You can smell rich coffee's, esspresso, cappochino..."
   PRINT " There is a small table in the corner with a fat, white haired"
   PRINT " gentleman in a black suit, reclining and enjoying a coffee."
   PRINT " Two large Italians are standing on either side of him."
   COLOR 9
   PRINT " Here's what you may do here."
   PRINT " (e)xit pub   (g)amble    (c)hat    (s)it at the corner table "
   PRINT "                                          with the man."
   INPUT "e,g,c?"; a$
         IF a$ = "e" THEN 400
         IF a$ = "g" THEN 420
         IF a$ = "c" THEN 430
         IF a$ = "s" THEN 470
         CLS
         GOTO 410

420 CLS
   COLOR 4
   PRINT "--------------------------"
   COLOR 7
   PRINT "Class Number:"; CHAR%; "         "
   PRINT "Hit Points:"; HITPTS%; "         "
   PRINT "Power level:"; POWER%; "          "
   PRINT "Experience:"; XP%; "               "
   PRINT "Speed level:"; SPEED%; "          "
   PRINT " Weapon:"; WEPON$; "      "
   PRINT "CREDITS:"; CREDITS%; "              "
   PRINT "MEN:"; men%; "                  "
   COLOR 4
   PRINT "--------------------------"
 
   COLOR 7
   PRINT " You walk up to the gambling table."
   PRINT " The man sitting at the head of table invites you to play."
   PRINT " You take a seat. The men introduce themselves and then."
   PRINT " they tell you it's 5 CREDITS per round to play thier game."
   PRINT " They ask if you wish to play."
   PRINT ""
   COLOR 9
   PRINT " (a)sk about rules  (p)lay  (l)eave table"
   INPUT "a,p,l"; a$
        IF a$ = "l" THEN 400
        IF a$ = "a" THEN 450
        IF a$ = "p" THEN 455
        CLS
        GOTO 420

450 CLS
   COLOR 4
   PRINT "--------------------------"
   COLOR 7
   PRINT "Class Number:"; CHAR%; "         "
   PRINT "Hit Points:"; HITPTS%; "         "
   PRINT "Power level:"; POWER%; "          "
   PRINT "Experience:"; XP%; "               "
   PRINT "Speed level:"; SPEED%; "          "
   PRINT " Weapon:"; WEPON$; "      "
   PRINT "CREDITS:"; CREDITS%; "              "
   PRINT "MEN:"; men%; "                  "
   COLOR 4
   PRINT "--------------------------"
 
   COLOR 7
   PRINT " They tell you the rules:"
   COLOR 7
   PRINT " 1) You put down 5 CREDITS on the table."
   PRINT " 2) The person at the head of the table thinks of a number."
   PRINT " 3) If you guess it right, you get everyone's CREDITS at the table!"
   PRINT "    If your wrong, someone else get's your money."
   PRINT ""
   PRINT " You thank them for the rules."
   COLOR 9
   INPUT zz$
   GOTO 37

455 CLS
   COLOR 4
   PRINT "--------------------------"
   COLOR 7
   PRINT "Class Number:"; CHAR%; "         "
   PRINT "Hit Points:"; HITPTS%; "         "
   PRINT "Power level:"; POWER%; "          "
   PRINT "Experience:"; XP%; "               "
   PRINT "Speed level:"; SPEED%; "          "
   PRINT " Weapon:"; WEPON$; "      "
   PRINT "CREDITS:"; CREDITS%; "              "
   PRINT "MEN:"; men%; "                  "
   COLOR 4
   PRINT "--------------------------"
 
   COLOR 7
   PRINT " You are ready to play. You put down 5 CREDITS on the table."
   CREDITS% = CREDITS% - 5
   PRINT " The master of the table has the number written on a card."
   PRINT " He tells you to guess it. The number is 1 through 10."
   PRINT ""
   COLOR 9
   x = INT(RND * 10) + 1
   INPUT "Your guess"; a
         IF a = x THEN 465 ELSE 460
         CLS
         GOTO 40

460 CLS
   COLOR 4
   PRINT "--------------------------"
   COLOR 7
   PRINT "Class Number:"; CHAR%; "         "
   PRINT "Hit Points:"; HITPTS%; "         "
   PRINT "Power level:"; POWER%; "          "
   PRINT "Experience:"; XP%; "               "
   PRINT "Speed level:"; SPEED%; "          "
   PRINT " Weapon:"; WEPON$; "      "
   PRINT "CREDITS:"; CREDITS%; "              "
   PRINT "MEN:"; men%; "                  "
   COLOR 4
   PRINT "--------------------------"
 
   COLOR 7
   PRINT " Oh, no! The number was wrong."
   PRINT " The cheery group laughs it off and encourages you to play again."
   PRINT " You decline and leave the table. They tell you to come back"
   PRINT " anytime."
   PRINT ""
   COLOR 9
   INPUT zz$
   GOTO 410

465 CLS
   COLOR 4
   PRINT "--------------------------"
   COLOR 7
   PRINT "Class Number:"; CHAR%; "         "
   PRINT "Hit Points:"; HITPTS%; "                 "
   PRINT "Power level:"; POWER%; "          "
   PRINT "Experience:"; XP%; "               "
   PRINT "Speed level:"; SPEED%; "          "
   PRINT " Weapon:"; WEPON$; "      "
   PRINT "CREDITS:"; CREDITS%; "              "
   PRINT "MEN:"; men%; "                  "
   COLOR 4
   PRINT "--------------------------"
 
   COLOR 7
   PRINT " That number is correct! You collect 60 CREDITS!"
   CREDITS% = CREDITS% + 60
   PRINT " The men hand you thier money and congratulate you."
   PRINT " You tell them you must leave for now, but will be back."
   PRINT " They tell you to come back soon."
   PRINT ""
   COLOR 9
   INPUT zz$
   GOTO 410

430 CLS
   COLOR 4
   PRINT "--------------------------"
   COLOR 7
   PRINT "Class Number:"; CHAR%; "         "
   PRINT "Hit points:"; HITPTS%; "            "
   PRINT "Power level:"; POWER%; "          "
   PRINT "Experience:"; XP%; "               "
   PRINT "Speed level:"; SPEED%; "          "
   PRINT " Weapon:"; WEPON$; "      "
   PRINT "CREDITS:"; CREDITS%; "              "
   PRINT "MEN:"; men%; "                  "
   COLOR 4
   PRINT "--------------------------"
 
   COLOR 7
   PRINT " You walk over to a group of men..."
   PRINT " You talk to a young boy who tells you that the man sitting"
   PRINT " in the corner is powerful. He says that if you have the"
   PRINT " credits then this man can get you weapons of a heavier"
   PRINT " caliber than the Military standard. He says that the password"
   PRINT " is `Mike is God'."
   COLOR 9
   INPUT zz$
   GOTO 410

440 CLS
    PRINT "Luckily you are in walking distance of the Base."
    INPUT zz$
    GOTO 301

470 CLS
   COLOR 4
   PRINT "--------------------------"
   COLOR 7
   PRINT "Class Number:"; CHAR%; "         "
   PRINT "Power level:"; POWER%; "          "
   PRINT "Experience:"; XP%; "               "
   PRINT "Speed level:"; SPEED%; "          "
   PRINT " Weapon:"; WEPON$; "      "
   PRINT "CREDITS:"; CREDITS%; "              "
   PRINT "MEN:"; men%; "                  "
   COLOR 4
   PRINT "--------------------------"
   PRINT " What will you say to him?"
   INPUT ""; a$
   IF a$ = "Mike is God" THEN 480 ELSE 475

475 CLS
   COLOR 4
   PRINT "--------------------------"
   COLOR 7
   PRINT "Class Number:"; CHAR%; "         "
   PRINT "Power level:"; POWER%; "          "
   PRINT "Experience:"; XP%; "               "
   PRINT "Speed level:"; SPEED%; "          "
   PRINT " Weapon:"; WEPON$; "      "
   PRINT "CREDITS:"; CREDITS%; "              "
   PRINT "MEN:"; men%; "                  "
   COLOR 4
   PRINT "--------------------------"
   PRINT " The two large men at his sides glare at you and you feel"
   PRINT " obliged (and lucky) to leave."
   INPUT zz$
   GOTO 400

480 CLS
   COLOR 4
   PRINT "--------------------------"
   COLOR 7
   PRINT "Class Number:"; CHAR%; "         "
   PRINT "Power level:"; POWER%; "          "
   PRINT "Experience:"; XP%; "               "
   PRINT "Speed level:"; SPEED%; "          "
   PRINT " Weapon:"; WEPON$; "      "
   PRINT "CREDITS:"; CREDITS%; "              "
   PRINT "MEN:"; men%; "                  "
   COLOR 4
   PRINT "--------------------------"
   COLOR 7
   PRINT " After discussing it a while Marlin makes you an attractive offer."
   PRINT " (h)igh Power Flamer - 40P           - 100"
   PRINT " (y)rack bomb lobber - 45P           - 130"
   PRINT " (f)ully automatic 12g shotgun - 60P - 200"
   PRINT " Press enter to cancel"
   PRINT ""
   COLOR 9
   INPUT ""; a$
   IF a$ = "h" THEN 490
   IF a$ = "y" THEN 500
   IF a$ = "f" THEN 510
   GOTO 475

490 CLS
   COLOR 4
   PRINT "--------------------------"
   COLOR 7
   PRINT "Class Number:"; CHAR%; "         "
   PRINT "Power level:"; POWER%; "          "
   PRINT "Experience:"; XP%; "               "
   PRINT "Speed level:"; SPEED%; "          "
   PRINT " Weapon:"; WEPON$; "      "
   PRINT "CREDITS:"; CREDITS%; "              "
   PRINT "MEN:"; men%; "                  "
   COLOR 4
   PRINT "--------------------------"
   IF WEPON$ = "PWRFLM" THEN 491
   IF CREDITS% <= 99 THEN 492
   PRINT " You have just bought the Power Flamer!"
   CREDITS% = CREDITS% - 100
   POWER% = 40
   WEPON$ = "PWRFLM"
   INPUT zz$
   GOTO 475

491 CLS
    COLOR 4
    PRINT " You already have this."
    INPUT zz$
    GOTO 480

492 CLS
    COLOR 4
    PRINT " You don't have enough credits for this!"
    INPUT zz$
    GOTO 480

500 CLS
   COLOR 4
   PRINT "--------------------------"
   COLOR 7
   PRINT "Class Number:"; CHAR%; "         "
   PRINT "Power level:"; POWER%; "          "
   PRINT "Experience:"; XP%; "               "
   PRINT "Speed level:"; SPEED%; "          "
   PRINT " Weapon:"; WEPON$; "      "
   PRINT "CREDITS:"; CREDITS%; "              "
   PRINT "MEN:"; men%; "                  "
   COLOR 4
   PRINT "--------------------------"
   IF WEPON$ = "yrack" THEN 491
   IF CREDITS% <= 129 THEN 492
   PRINT " You have just bought the Y-rack bomb lobber!"
   CREDITS% = CREDITS% - 130
   POWER% = 45
   WEPON$ = "yrack"
   INPUT zz$
   GOTO 475

510 CLS
   COLOR 4
   PRINT "--------------------------"
   COLOR 7
   PRINT "Class Number:"; CHAR%; "         "
   PRINT "Power level:"; POWER%; "          "
   PRINT "Experience:"; XP%; "               "
   PRINT "Speed level:"; SPEED%; "          "
   PRINT " Weapon:"; WEPON$; "      "
   PRINT "CREDITS:"; CREDITS%; "              "
   PRINT "MEN:"; men%; "                  "
   COLOR 4
   PRINT "--------------------------"
   IF WEPON$ = "shotgun" THEN 491
   IF CREDITS% <= 199 THEN 492
   PRINT " You have just bought the fully automatic military-style"
   PRINT " 12gauge shotgun!"
   CREDITS% = CREDITS% - 200
   POWER% = 60
   WEPON$ = "shotgun"
   INPUT zz$
   GOTO 475

520 CLS
    PRINT "Leaving ship..."
    INPUT zz$
    x = INT(RND * 4) + 1
    IF x = 1 THEN 400
    IF x = 2 THEN 400
    IF x = 3 THEN 30
    IF x = 4 THEN 400

550 PRINT " Which planet will you raid?"
    PRINT " (s)kinnies or"
    PRINT " (b)ugs?"
    INPUT ""; a$
    IF a$ = "s" THEN 2200
    IF a$ = "b" THEN 2600





' ******************* START OF MINI BATTLE PROGRAM **************

2000 CLS
   COLOR 4
   PRINT "--------------------------"
   COLOR 7
   PRINT "Class Number:"; CHAR%; "         "
   PRINT "Hit Points:"; HITPTS%; "         "
   PRINT "Power level:"; POWER%; "          "
   PRINT "Experience:"; XP%; "               "
   PRINT "Speed level:"; SPEED%; "          "
   PRINT " Weapon:"; WEPON$; "      "
   PRINT "CREDITS:"; CREDITS%; "              "
   PRINT "MEN:"; men%; "                  "
   COLOR 4
   PRINT "--------------------------"
     COLOR 7
     PRINT " In the undergroud terminal waiting for the bus, you spot"
     PRINT " about 5 of the merchant sailors that were at the bar. "
     PRINT " they followed you here, there is nobody save you and"
     PRINT " your two friends in the terminal and they are approching"
     PRINT " rapidly. They are armed with knives and lead pipes."
     COLOR 4
     INPUT zz$
     GOTO 2005


2003 IF CHAR% <= 4 THEN 2200
     IF CHAR% = 5 THEN 2600
     IF CHAR% = 7 OR CHAR% = 6 THEN 550

2005 COLOR 7
     PRINT " You have encountered sailors"
     WEPOWER% = 2  ' total power
     WEPTS% = 5
     WESPEED% = 15   ' his speed
     WECREDITS% = 12    ' his CREDITS
     WEEXP% = 2      ' strength you get for killing him
     WEFAST% = 3      ' speed you get for killing him
     WENO% = 0       ' The monster's number for return commands
     WENAME$ = "sailors"
     INPUT zz$
2006   CLS
       COLOR 4
       PRINT "--------------------------"
       COLOR 7
       PRINT "Class Number:"; CHAR%; "         "
       PRINT "Hit Points:"; HITPTS%; "         "
       PRINT "Power level:"; POWER%; "          "
       PRINT "Experience:"; XP%; "               "
       PRINT "Speed level:"; SPEED%; "          "
       PRINT " Weapon:"; WEPON$; "      "
       PRINT "CREDITS:"; CREDITS%; "              "
       PRINT "MEN:"; men%; "                  "
       COLOR 4
       PRINT "--------------------------"
       INPUT "(f)ight  (r)un  "; x$
         IF x$ = "f" THEN 2010
         IF x$ = "r" THEN 3000
         GOTO 2006

2010 B% = INT(RND * 4) + 1
     IF B% = 1 THEN 2015
     IF B% = 2 THEN 2020
     IF B% = 3 THEN 2015
     IF B% = 4 THEN 2020

2015 PRINT " The "; WENAME$; " hits you for "; WEPOWER%; " HP's."
             HITPTS% = HITPTS% - WEPOWER%
             INPUT zz$
             IF HITPTS% <= 0 THEN 2999
             GOTO 2006

2020 PRINT " You wail the "; WENAME$; " for "; POWER%; " HP's"
             WEPTS% = WEPTS% - POWER%
             IF WEPTS% <= 0 THEN 3001
             INPUT zz$
             GOTO 2006



2200 CLS
     COLOR 7
     PRINT " You are on the Skinnies planet"
     PLANET% = 1
     B% = INT(RND * 5) + 1
     IF B% = 1 THEN 2300
     IF B% = 2 THEN 2400
     IF B% = 3 THEN 2300
     IF B% = 4 THEN 2400
     IF B% = 5 THEN 2500

2300 PRINT " You have encountered a civilian"
             WEPOWER% = INT(RND * 10) + 1
             WEPTS% = INT(RND * 50) + 1
             WESPEED% = SPEED% - INT(RND * 1)
             WECREDITS% = 5
             WEEXP% = 1
             WEFAST% = 1
             WENAME$ = "Civlian"
             WENO% = 3
             INPUT zz$
             GOTO 2006
2400 PRINT " You have encountered a fighter!"
             WEPOWER% = INT(RND * 20) + 10
             WEPTS% = INT(RND * 100) + 75
             WESPEED% = SPEED% - INT(RND * 1)
             WECREDITS% = 10
             WEEXP% = 2
             WEFAST% = 4
             WENAME$ = "Fighter"
             WENO% = 4
             INPUT zz$
             GOTO 2006
2500 PRINT " You have encountered a Leader!"
             WEPOWER% = INT(RND * 30) + 20
             WEPTS% = INT(RND * 250) + 175
             WESPEED% = SPEED% - INT(RND * 1)
             WECREDITS% = 20
             WEEXP% = 3
             WEFAST% = 30
             WENAME$ = "Leader"
             WENO% = 5
             INPUT zz$
             GOTO 2006

2550 PRINT " The mission is complete."
     PRINT zz$
     GOTO 301

2600 CLS
     COLOR 7
     PRINT " You are on the Bugs planet."
     PLANET% = 2
     B% = INT(RND * 7) + 1
     IF B% = 1 THEN 2700
     IF B% = 2 THEN 2800
     IF B% = 3 THEN 2700
     IF B% = 4 THEN 2800
     IF B% = 5 THEN 2700
     IF B% = 6 THEN 2800
     IF B% = 7 THEN 2900

2700 PRINT " You have encountered a worker!"
             WEPOWER% = INT(RND * 10) + 1
             WEPTS% = INT(RND * 400) + 300
            WESPEED% = SPEED% - INT(RND * 1)
            WECREDITS% = 5
            WEEXP% = 2
            WEFAST% = 3
            WENAME$ = "Worker"
            WENO% = 7
            INPUT zz$
            GOTO 2006
2800 PRINT " You have encountered a Warrior"
             WEPOWER% = INT(RND * 40) + 30
             WEPTS% = INT(RND * 200) + 75
            WESPEED% = SPEED% - INT(RND * 1)
            WECREDITS% = 20
            WEEXP = 4
            WEFAST% = 1
            WENAME$ = "Warrior"
            WENO% = 8
            INPUT zz$
            GOTO 2006
2900 PRINT " You have encountered a QUEEN!"
             WEPOWER% = INT(RND * 50) + 40
             WEPTS% = INT(RND * 350) + 300
           WESPEED% = SPEED% - INT(RND * 1)
           WECREDITS% = 30
           WEEXP% = 10
           WEFAST% = 5
           WENAME$ = "Queen"
           WENO% = 9
           INPUT zz$
           GOTO 2006

2990 PRINT " The mission is complete. You are awarded 25 credits."
     CREDITS% = CREDITS% + 25
     INPUT zz$
     GOTO 301





2999 CLS
     PRINT ""
     PRINT " Oh-no, You have died!!!!"
     PRINT ""
     PRINT " Well, you can always try again!"
     PRINT " Good luck...."
     INPUT " (p)lay again or (ENTER) to quit"; a$
     IF a$ = "p" THEN 5
     IF a$ = "groovy" THEN 301
     END

3000 CLS
     PRINT " You attempt to run from the "; WENAME$; "."
     x = INT(RND * 2) + 1
     IF x = 2 THEN 3004
     IF x = 1 THEN 3005

3001 PRINT " Alright! You have defeated the "; WENAME$; "!"
     PRINT " You have gained:"; WECREDITS%; " CREDITS!     "
     PRINT " You have gained "; WEEXP%; " Experience!"
     PRINT " You have gained "; WEFAST%; " Speed!"
     PRINT ""
     XP% = XP% + WEEXP%
     CREDITS% = CREDITS% + WECREDITS%
     SPEED% = SPEED% + WEFAST%
     INPUT zz$
     IF WENAME$ = "sailors" THEN GOTO 301
     IF WENAME$ = "Leader" THEN GOTO 2990
     IF WENAME$ = "Queen" THEN GOTO 2990
     IF PLANET% = 1 THEN 2200
     IF PLANET% = 2 THEN 2600

3003 CLS
     PRINT " You make a break for a cave exit!"
     PRINT " But first, you must run from the monster!"
     INPUT zz$
     GOTO 3000


3004 CLS
     PRINT " You were able to outrun the "; WENAME$; "!"
     PRINT " Uh-oh, here comes another!"
     PRINT " But, you have time to return to the ship."
     INPUT " (l)eave  (f)ight on"; a$
         IF a$ = "l" THEN 301
         IF a$ = "f" THEN 3504
3504     IF PLANET% = 1 THEN GOTO 2200
         IF PLANET% = 2 THEN GOTO 2600
3005 CLS
     PRINT " You were NOT able to outrun the "; WENAME$; "! "
     PRINT " Keep fighting!"
     INPUT zz$
     GOTO 2006













        































9998 CLS
     COLOR 9
     PRINT " OK, since you knew how to get here... the map!"
     PRINT " + = mountains   X = towns       0 = lake"
     PRINT " I = castle      F = waterfalls  * secret town "
     PRINT " r = road        # = forest?"
     PRINT ""
     COLOR 7
     PRINT "  ++++++ the mt.s rrrrrrrrrrrrrr                      "
     COLOR 7
     PRINT "    r                           r"
     COLOR 9
     PRINT "  r * Cedar    00000          X Crystal           "
     COLOR 9
     PRINT "     r          00000             r"
     PRINT "     r          00000             r"
     PRINT "  X ruby        00000             r                   "
     PRINT "     r          00000             r                  "
     COLOR 7
     PRINT "     r           000000           r"
     PRINT "   X Norshif     000000         X Havocville "
     COLOR 7
     PRINT "          rrrrrrrr"
     COLOR 9
     PRINT "                 FFFFFF                        "
     COLOR 9
     PRINT "                 r"
     COLOR 9
     PRINT "       IIIIIIIII r "
     PRINT "       III   III    "
     PRINT ""
     PRINT " And since you saw this.... goodbye!"
     END





9999 CLS
     COLOR 7
     PRINT " You have decided to quit."
     COLOR 7
     PRINT " Please play again."
     PRINT ""
     COLOR 9
     PRINT " COME VISIT AGAIN!"
     COLOR 9
     PRINT ""
     INPUT zz$
     END

SUB door
DRAW "br300 u230 l600 d450 r600 u225 bd225 bl200 bu400 bl350" 'box
DRAW "c4 r50 bl50 d25 r50 d25 l50 bu50 br75 r50 bl25 d50 bu50 br50 bd25 d25 bu25 e25 f25 d25 bu20 l50"   'st
DRAW "br50 bu30 br25 d50 bu50 r50 d20 l50 br25 f25 d5 bu50 br 25 "'ar
DRAW "r50 bl50 d25 r50 d25 l50 bu50 br75 d50 bu25 r50 bd25 u50 br25" 'sh
DRAW "d50 bu50 br25 d50  bu30 r50 u20 l50"    'ip
DRAW "bd75 bl440 d300 bu300 bl25 r50 br25 d300 bu300 r50 d50 l50 br25 f25 d225 bu300" 'tr
DRAW "br25 d300 r50 u300 l50 br50 br25 d300 r50 u300 l50 br75"'oo
DRAW "d300 u225 r50 u75 l50 br75 d300 r50 bl50 bu225 r35 bl35 bu75 r50 br25" 'pe
DRAW "d300 bu300 r50 d50 l50 br25 f25 d225 bu300"
END SUB

SUB pow
    CLS
    SCREEN 12
    LINE (300, 200)-(600, 400), 7, BF    'bar
    LINE (350, 220)-(550, 260), 15, BF      'bar sign
    LINE (350, 220)-(550, 260), 8, B
    LINE (350, 280)-(450, 340), 15, BF          'window
    LINE (350, 280)-(450, 340), 8, B
    DRAW "c8 bl50 u60 bd30 l50 r100"
    LINE (470, 300)-(540, 400), 6, BF
    LINE (470, 300)-(540, 400), 8, B
    CIRCLE (480, 360), 5, 14
    PAINT (480, 360), 14
    CIRCLE (480, 360), 5, 8
    DRAW "bu100 c13 bl95 bu2 u36 r20 d8 ta30 l20 ta-30 r20 ta0 d8 l20 br55 ta-10 u36 ta0 r10 ta10 d36 u20 ta0l10 r10 ta10 d20 ta0 br35 u36 br5 r15 d10 ta10 l15 ta37 d29"     '''''BAR
    DRAW "c6  ta0 bd170 br100 l640"
END SUB

SUB S
DRAW "c4 bl300 bu100 r60 f15 d20 h15 l25 d20 r25 f15 d40 l75 u20 r55 u20 l35 h20 u35"
END SUB

SUB stats
   COLOR 4
   PRINT "--------------------------"
   COLOR 7
   PRINT "Class Number:"; CHAR%; "         "
   PRINT "Hit Points:"; HITPTS%; "         "
   PRINT "Power level:"; POWER%; "          "
   PRINT "Speed level:"; SPEED%; "          "
   PRINT " Weapon:"; ARMOR%; "      "
   PRINT "CREDITS:"; CREDITS%; "              "
   PRINT "MEN:"; men%; "                  "
   COLOR 4
   PRINT "--------------------------"
END SUB

