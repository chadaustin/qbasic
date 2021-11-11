DEFINT A-Z
DECLARE FUNCTION question$ (prompt$, a1$, a2$, a3$, a4$)
DECLARE FUNCTION getstr$ (prompt$, length%)
DECLARE FUNCTION getstring$ (prompt$, length%)
DECLARE FUNCTION getint% (prompt$, min%, max%)
DECLARE FUNCTION cut$ (x%)

DIM SHARED clr

  ON PLAY(1) GOSUB musicroutine

  CLS
  COLOR 15
  PRINT "Spygame: ";
  COLOR 4
  PRINT "Deluxe Edition"
  COLOR 9
  PRINT
  PRINT "Programmer: Chad Austin"
  PRINT "Background Music: Ryan Hedlund"
  PRINT
  COLOR 15
  
  FOR i = 1 TO 15
    COLOR i: PRINT i;
  NEXT
  PRINT
  clr = getint("Enter text color: ", 1, 15)
  WHILE nam$ = ""
    nam$ = getstr$("Enter your name: ", 12)
  WEND
  PRINT "Play background music? (Y/N) ";
  DO
    mus$ = UCASE$(INKEY$)
    IF mus$ = CHR$(0) THEN mus$ = INKEY$: mus$ = ""
    IF mus$ = "Y" THEN
      PLAY ON
      PLAY "mb p64 p64 p64"
      EXIT DO
    END IF
    IF mus$ = "N" THEN EXIT DO
  LOOP

  CLS
  COLOR clr
  PRINT "`Hi, "; nam$; ".  I am a secret agent sending you on a mission"
  PRINT "to Iraq to inform us on the building of nuclear weapons.  The "
  PRINT "CIA and the Pentagon will give you supplies and a plane ticket."
  PRINT "Be ready tomorrow at nine hundred hours and meet me at the"
  PRINT "airport.'"

street:
  first$ = question$("Where do you go? (Store/Apartment)", "S", "A", "", "")
  IF first$ = "S" THEN GOTO store
  IF first$ = "A" THEN GOTO apartment

store:
  PRINT "You go to the store.  The manager says, `May I help you?'"
  temp$ = question$("What do you need? (Guns/Supplies)", "G", "S", "", "")
  PRINT "Before you buy anything, assassins jump through a window and"
  PRINT "begin shooting.  You and the manager die in the midst of fire."
  GOTO dead

apartment:
  PRINT "You go to your apartment.  It feels as if someone is watching"
  PRINT "you.  You know you need to pack for your mission to Iraq."
  apartment$ = question$("What do you do? (Pack/Search the apartment/Leave)", "P", "S", "L", "")
  IF apartment$ = "P" THEN GOTO pack
  IF apartment$ = "S" THEN GOTO search
  IF apartment$ = "L" THEN GOTO leave

pack:
  PRINT "You begin to pack when you hear a rustling in the closet."
  PRINT "A man jumps out and draws a pistol.  One bullet through the"
  PRINT "chest is all it takes to kill you."
  GOTO dead

leave:
  PRINT "You leave the apartment."
  GOTO street

search:
  PRINT "You search the apartment carefully and quietly.  When opening"
  PRINT "the closet door, a man dressed in black jumps out.  He pulls"
  PRINT "a gun, but you wrestle him to the ground.  `Please don't kill"
  PRINT "me,' he pleads, `I will tell you everything.'"
  pris$ = question$("What do you do? (Kill him/Let him go/Talk to him)", "K", "L", "T", "")
  IF pris$ = "K" THEN GOTO killpris
  IF pris$ = "T" THEN GOTO talk
  IF pris$ = "L" THEN GOTO letgo

killpris:
  PRINT "You shoot him and his body lies lifeless on the floor."
  GOTO prisdone

talk:
  PRINT "He begins stuttering but soon talks smoothly.  `I was hired by"
  PRINT "the Iraqi government to spy on and kill you.  My contacts, here"
  PRINT "in america, told me where you lived.  I hid in your closet until"
  PRINT "you came home.  Then you attacked me.  That is all I know."

  pris2$ = question$("What do you do to him now? (Kill him/Tie him up)", "K", "T", "", "")
  IF pris2$ = "K" THEN GOTO killpris
  IF pris2$ = "T" THEN GOTO prisdone

letgo:
  PRINT "You release him."
  GOTO prisdone

prisdone:
  prisdone$ = question$("What do you do now? (Sleep/Contact the CIA)", "S", "C", "", "")
  IF prisdone$ = "S" THEN GOTO bed
  IF prisdone$ = "C" THEN GOTO contact

contact:
  PRINT "`Hi "; nam$; ".  I heard about the men that are trying to kill"
  PRINT "you.  Anyway, meet me at the airport tomorrow and try to get some"
  PRINT "sleep now.'"
  IF pris2$ = "T" THEN PRINT "`A fellow agent will pick up your prisoner tonight.'"

bed:
  PRINT "You get in bed.  After tossing and turning, you eventually"
  PRINT "fall asleep.  Nightmares haunt you until your alarm clock"
  PRINT "goes off at 7:30 a.m."

adventure:
  adventure$ = question$("Where do you go? (Airport/Store/Restaurant/Bar)", "A", "S", "R", "B")
  IF adventure$ = "S" THEN GOTO store
  IF adventure$ = "B" THEN GOTO bar
  IF adventure$ = "R" THEN GOTO restaurant
  IF adventure$ = "A" THEN GOTO airport

bar:
  PRINT "You enter the bar.  Many drunk men are sleeping around you."
  PRINT "One man tells you to leave."
  leavebar$ = question$("Do you? (Yes/No)", "Y", "N", "", "")
  IF leavebar$ = "Y" THEN GOTO adventure
  IF leavebar$ = "N" THEN GOTO stayedinbar

stayedinbar:
  PRINT "The man gets up and shoots you.  Your last thought is that"
  PRINT "the men are laughing at you."
  GOTO dead

restaurant:
  PRINT "The restaurant is empty except for some waiters."
  order$ = question$("Do you order food? (Yes/No)", "Y", "N", "", "")
  IF order$ = "Y" THEN GOTO eatfood
  IF order$ = "N" THEN GOTO adventure

eatfood:
  PRINT "You begin to eat your food when you realize you need to go"
  PRINT "to the airport.  After jumping in the car, you speed to the airport."

airport:
  PRINT "The airport is bustling with activity.  A man rushes up to you."
  PRINT "He is the secret agent!  `Good morning, "; nam$; ".  I am glad"
  PRINT "that you could meet me here.  Here are your supplies.'  He"
  PRINT "hands you a high-powered rifle, which you put with your pistol,"
  PRINT "a paper that allows you to take your equipment on a commercial"
  PRINT "plane, a fake ID, a fake passport, some clothes, and $5000."
  PRINT "`The plane is taking off in forty-five minutes.  A man in Iraq"
  PRINT "will meet you at the airport.  He will tell you what to do."
  PRINT "Remember, be at gate 5A in forty-five minutes.  Until then, have fun!'"
  PRINT "The man leaves."
  airport$ = question$("Where do you go? (Shop/Gate 5A/Bathroom)", "S", "G", "B", "")
  IF airport$ = "B" THEN GOTO bathroom
  IF airport$ = "S" THEN GOTO shop
  IF airport$ = "G" THEN GOTO gate5a

bathroom:
  PRINT "You accidentally enter the woman's bathroom.  A woman screams and"
  PRINT "slaps you.  You blush, leave, and enter the men's bathroom."
  PRINT "The bathroom is clean but a stench fills the air.  Many men are"
  PRINT "relieving themselves, but a few are smoking against the wall."
  PRINT "You notice a `no-smoking' sign on the wall."
  bathroom$ = question$("Do you approach the men? (Yes/No)", "Y", "N", "", "")
  IF bathroom$ = "Y" THEN GOTO approachmen
  IF bathroom$ = "N" THEN GOTO leavebathroom

approachmen:
  PRINT "A man says, `We no botherin' no one.  We gonna kill you.'"
  PRINT "Before you can react, security guards come in and take the men away."

leavebathroom:
  airport2$ = question$("Where do you go now? (Shop/Gate 5A)", "S", "G", "", "")
  IF airport2$ = "S" THEN GOTO shop
  IF airport2$ = "G" THEN GOTO gate5a

shop:
  PRINT "You enter the shop.  You look around at the items for sale and"
  PRINT "decide that they are too outrageously priced to be bought."
  PRINT "You look at your watch and see that it is almost time to leave."

gate5a:
  PRINT "A loudspeaker says, `The plane is about to leave.'"
  PRINT "A security guard sees your guns in your bag, but you show him"
  PRINT "your paper.  He nods and places your bags in the back of the plane."
  PRINT "He looks at your passport and says, `Steve Carson?  I could"
  PRINT "almost swear your name is "; nam$; ".'  You feel sweat on your"
  PRINT "neck and upper lip.  The man says, `I must know someone that"
  PRINT "looks like you.'  You get on the plane and sit quietly for a"
  PRINT "few minutes."
  PRINT "The plane takes off and nothing happens for a few hours.  A"
  PRINT "man stands up and enters the cockpit.  He comes out after a while"
  PRINT "with a gun to the pilots head.  `I am hijacking this plane,' he"
  PRINT "says."
  hijack$ = question$("What do you do? (Attack the hijacker/Hide/Get your guns)", "A", "H", "G", "")
  IF hijack$ = "A" THEN GOTO Attack
  IF hijack$ = "H" THEN GOTO hide
  IF hijack$ = "G" THEN GOTO getguns

Attack:
  PRINT "You jump out of your seat and punch the hijacker.  He hits"
  PRINT "you with his pistol and knocks you out.  Days later you wake"
  PRINT "up in a cell in a terrorist base.  You are there for the rest"
  PRINT "of your short life."
  GOTO dead

hide:
  PRINT "You hide in the bathroom while the plane goes on its way to"
  PRINT "Moscow.  After hours of flight, the plane lands.  Everybody"
  PRINT "gets off the plane to be taken to a base somewhere."

 moscow$ = question$("What do you do? (Follow the prisoners/Leave the airport)", "F", "L", "", "")
 IF moscow$ = "F" THEN GOTO follow
 IF moscow$ = "L" THEN GOTO leaveairport
     
follow:
  PRINT "You follow the prisoners and see them being taken into a secret"
  PRINT "base.  You go into the base and see a leader talking to a group"
  PRINT "of men.  He notices you!  `Well, "; nam$; ", I had my men"
  PRINT "hijack that plane because you would be on it.  I guess they did"
  PRINT "not hijack the wrong plane after all.'  He pulls out a bag with"
  PRINT "all your equipment in it!  Suddenly,  police jump in the room "
  PRINT "and shoot the leader.  Your equipment is given back, but the"
  PRINT "$5000 is missing.  The police thank you. "

leaveairport:
  IF moscow$ = "L" THEN PRINT "Your equipment is found in a gutter, but the $5000 is gone."
  PRINT "You find yourself on a deserted street.  You run and see a"
  PRINT "pretty woman.  She is sleeping in a parked car."
  street$ = question$("What do you do? (Get in the car/Keep walking)", "G", "K", "", "")
  IF street$ = "K" THEN GOTO keepwalking
  IF street$ = "G" THEN GOTO getincar

keepwalking:
  PRINT "You keep walking and a band of gangsters shoots you and steals"
  PRINT "your equipment."
  GOTO dead

getincar:
  PRINT "You get in the car."
  car$ = question$("What do you do now? (Start the car/Kill the woman/Leave the car)", "S", "K", "L", "")
  IF car$ = "L" THEN GOTO keepwalking
  IF car$ = "S" THEN GOTO startcar
  IF car$ = "K" THEN GOTO killwoman

killwoman:
  PRINT "The woman is now dead."

startcar:
  PRINT "You start the car and begin driving south."
  IF car$ = "S" THEN
    PRINT "The woman wakes up and begins to talk.  She says, `Please drive me to a"
    PRINT "certain house.'"
    drivelady$ = question$("Do you? (Yes/No)", "Y", "N", "", "")
    IF drivelady$ = "N" THEN GOTO dontdrivelady
    IF drivelady$ = "Y" THEN GOTO agree
  END IF
  GOTO keepdriving

dontdrivelady:
  PRINT "The woman says, `If I can't get my way, you won't get yours.'"
  PRINT "She takes your high-powered rifle and blows your brains out."
  GOTO dead

agree:
  PRINT "You drive her to the house.  She thanks and kisses you."
  PRINT "`Good-bye.  Thanks again for driving me.  Her voice fades in the"
  PRINT "distance."

keepdriving:
  PRINT "You keep driving and travel closer and closer to Iraq."
  GOTO iraq

getguns:
  PRINT "You go to the back of the plane to get your guns."
  PRINT "When you come out of the luggage room, the pilot is being forced"
  PRINT "to travel to Moscow.  You sneak up on the hijacker and are ready"
  PRINT "to shoot him."
  shootman$ = question$("Do you? (Yes/No)", "Y", "N", "", "")
  IF shootman$ = "N" THEN GOTO dontshoot
  IF shootman$ = "Y" THEN GOTO shoot

dontshoot:
  PRINT "The hijacker notices you and shoots you.  You never knew what"
  PRINT "hit you."
  GOTO dead

shoot:
  PRINT "You shoot the hijacker and put him in an empty suitcase."
  PRINT "Everybody on the plane thanks you and you sit down."
  PRINT "The pilot changes course from Moscow to Iraq."
  PRINT "You notice that the $5000 in your bag is missing."

iraq:
  PRINT "You make your way to the airport in Baghdad.  Another secret agent"
  PRINT "approaches you.  `Hi, "; nam$; ", follow me."
  follow$ = question$("What do you do?  (Follow the agent/Look around)", "F", "L", "", "")
  IF follow$ = "F" THEN GOTO followagent
  IF follow$ = "L" THEN GOTO lookaround
  
followagent:
  PRINT "You follow the agent.  He takes you to his house in the hills."
  IF pris$ = "L" THEN
    PRINT "`Remember me?  I have tried to kill you at your house before."
    PRINT "Now I will definitely kill you.'  BANG!!"
  ELSE
    PRINT "`I am a fake agent.  Now you will die!'"
  END IF
  GOTO dead

lookaround:
  PRINT "You look around in the airport.  A man whispers to you."
  PRINT "`I am the man that is supposed to meet you.  Come with me.'"
  follow2$ = question$("Do you follow him? (Yes/No)", "Y", "N", "", "")
  IF follow2$ = "N" THEN GOTO sniper
  IF follow2$ = "Y" THEN GOTO houseinhills

sniper:
  PRINT "The man turns around and says, `FOLLOW ME NOW.'"
  PRINT "A sniper shot travels through your head and a second shot kills"
  PRINT "the agent meeting you."
  GOTO dead

houseinhills: 
  PRINT "The man takes you to his home.  His home is a small, three"
  PRINT "room apartment.  He opens a closet door and gives you a"
  PRINT "Code 5 security pass that allows you to enter Iraqi installations."
  PRINT "He also lets you borrow his jeep.  You stay there for the night."
  PRINT "The next morning you feel ready for your mission.  You leave."
 
adventure2:
  iraq2$ = question$("Where do you go? (Bar/Installation/Terrorist HQ)", "B", "I", "T", "")
  IF iraq2$ = "B" THEN GOTO ibar
  IF iraq2$ = "I" THEN GOTO installation
  IF iraq2$ = "T" THEN GOTO terroristhq

ibar: 
  PRINT "You enter the bar.  Many Arab men are sitting at stools"
  PRINT "drinking beer.  Someone offers you a drink and you sit down."
  PRINT "`I heard that the installation outside of town is mass"
  PRINT "producing nuclear weapons.'"
  GOTO adventure2

terroristhq:
  PRINT "The terrorist headquarters is heavily guarded.  There are"
  PRINT "many ways to get in."

  thq$ = question$("What do you do? (Leave/Kill the guards/Sneak past the guards)", "L", "K", "S", "")
  IF thq$ = "L" THEN GOTO adventure2
  IF thq$ = "S" THEN GOTO sneak
  IF thq$ = "K" THEN GOTO killguards

sneak:
  PRINT "You try to sneak past the guards.  These men are well trained"
  PRINT "and can hear you.  A couple well placed shots eliminate you."
  GOTO dead

killguards:
  gun$ = question$("Which gun do you want to use? (Pistol/Rifle)", "P", "R", "", "")
  IF gun$ = "P" THEN GOTO pistol
  IF gun$ = "R" THEN GOTO rifle

pistol:
  PRINT "You begin firing at the guards but none of the shots can reach"
  PRINT "the guards.  A few counter-shots kill you."
  GOTO dead

rifle:
  PRINT "All the guards die under your fire.  You find the headquarters"
  PRINT "abandoned so you go to the installation."

installation:
  PRINT "The installation has no guards, although you notice some"
  PRINT "snipers in the windows.  It is a tall building situated in the"
  PRINT "middle of the woods."
  enter$ = question$("How will you get in? (Kill the snipers/Charge/Sneak into the installation)", "K", "C", "S", "")
  IF enter$ = "C" THEN GOTO charge
  IF enter$ = "K" THEN GOTO killsnipers
  IF enter$ = "S" THEN GOTO sneakininstallation

charge:
  PRINT "You charge the base, making a lot of noise and the snipers notice"
  PRINT "you.  Their shots are well aimed and you make an easy target."
  GOTO dead

sneakininstallation:
  PRINT "You sneak past the snipers and enter the installation."
  GOTO ininst

killsnipers:
  PRINT "You aim your rifle and kill some of the snipers.  The remaining"
  PRINT "men leave the windows."
  ei$ = question$("Do you enter the installation? (Yes/No)", "Y", "N", "", "")
  IF ei$ = "Y" THEN GOTO ininst

  COLOR 15
  LINE INPUT "    Why would you want to leave the installation?"; duh$
  IF LCASE$(LEFT$(duh$, 7)) = "because" THEN
    PRINT "Okay, you can leave."
    PRINT "A man on the street kills you."
    GOTO dead
  END IF

  PRINT "Yeah, right!  WRONG ANSWER!!!"
  GOTO ininst

ininst:
  PRINT "You enter the installation."

halls:
  PRINT "Three halls are before you."
  hall$ = question$("Which one do you go in? (Forward/Right/Left)", "F", "R", "L", "")
  IF hall$ = "R" OR hall$ = "L" THEN GOTO hallloop
  IF hall$ = "F" THEN GOTO forward


hallloop:
  PRINT "You travel around in a wide circle and end up where you started from."
  GOTO halls

forward:
  PRINT "You travel up the hall and there is a stairway ahead and"
  PRINT "an office to your right.  You also find a secret elevator."
  room$ = question$("Where do you go? (Stairs/Office/Elevator)", "S", "O", "E", "")
  IF room$ = "O" THEN GOTO office
temp:
  IF room$ = "S" THEN GOTO stairs
  IF room$ = "E" THEN GOTO elevator

office:
  PRINT "You go into the office.  A tech is working at a computer.  The"
  PRINT "man turns around and calls guards.  Many men rush in and"
  PRINT "surprise you.  You are sitting there with seven armed men."
  PRINT "One man yells, `He is a spy!  Get him!'  The men rush you."
  office$ = question$("What do you do? (Attack the men/Take the technician as a hostage)", "A", "T", "", "")
  IF office$ = "A" THEN GOTO attackmen
  IF office$ = "T" THEN GOTO taketech

attackmen:
  PRINT "You decide to attack the men, but they all take out guns"
  PRINT "and blow your head off before you get a shot."
  GOTO dead

taketech:
  PRINT "You take the technician as hostage and tell the men to get up"
  PRINT "against the wall.  After they do, you take your pistol and shoot"
  PRINT "every one, even the tech."
  room$ = question$("Where do you go now? (Stairs/Elevator)", "S", "E", "", "")
  GOTO temp

stairs:
  PRINT "The stairs are steep but you finally make it to the top."
  PRINT "You notice the elevator beside you."
  GOTO topfloor

elevator:
  PRINT "You go up the elevator and reach the second floor."
  PRINT "You notice the stairs next to you."
  GOTO topfloor

topfloor:
  PRINT "The second and highest floor looks like a lab and a computer"
  PRINT "center.  Many techs rush beside you."
topfloorq:
  topfloor$ = question$("Where do you go? (Laboratory/Computer room/Unmarked Room)", "L", "C", "U", "")
  IF topfloor$ = "L" THEN GOTO lab
  IF topfloor$ = "C" THEN GOTO comp
  IF topfloor$ = "U" THEN GOTO unmarked

lab:
  PRINT "The laboratory is empty."
  GOTO topfloorq

comp:
  PRINT "You enter the computer room.  Many lights are flashing around"
  PRINT "you.  Imagine this all day:"
  COLOR 31
  FOR x = 0 TO 20
    lights$ = ""
    FOR y = 0 TO 79
      IF INT(RND * 2) THEN
        lights$ = lights$ + "1"
      ELSE
        lights$ = lights$ + "0"
      END IF
    NEXT
    PRINT lights$
  NEXT
  WHILE INKEY$ = "": WEND
  COLOR clr
  PRINT "The computer has many files.  You look through them,"
  PRINT "and you see a file headed `Nuclear Weapons Production."
  PRINT "You open the file and see that this installation is making"
  PRINT "nuclear weapons.  A printout is the evidence you need."
  PRINT "You leave the computer room."
  computerchecked = 1
  IF killedgeneral THEN GOTO ending
  GOTO topfloorq

unmarked:
  PRINT "The unmarked room has many soldiers in it.  A general sees"
  PRINT "you and fires at you.  Luckily, the shot was a miss.  `Well,"
  PRINT nam$; ", we have been waiting for you.'"
  lastmove$ = question$("What do you do? (Attack soldiers/Kill general/Run/Scream)", "A", "K", "R", "S")
  IF lastmove$ = "S" THEN GOTO scream
  IF lastmove$ = "K" THEN GOTO killgeneral
  IF lastmove$ = "R" THEN GOTO runaway
  IF lastmove$ = "A" THEN GOTO attacksoldiers

scream:
  PRINT "You yell an ear-splitting scream, but this does not seem to affect"
  PRINT "the soldiers.  `You idiot, "; nam$; ".'  One shot kills you."
  GOTO dead

killgeneral:
  PRINT "You level your pistol and kill the general, pumping five shots"
  PRINT "into his chest.  The soldiers shoot at you, but you die a hero."
  GOTO dead

runaway:
  PRINT "You break into a wild sprint down the hall, but shots from"
  PRINT "behind you knock you down the stairs.  Your last memory is that"
  PRINT "your neck breaks."
  GOTO dead

attacksoldiers: 
  PRINT "You duck behind a desk and shoot all of the soldiers."
  PRINT "The mad general attacks you, but a fatal shot to the head"
  PRINT "kills him."
  killedgeneral = 1
  IF computerchecked THEN GOTO ending
  GOTO topfloorq

ending:
  PRINT
  PRINT "You exit Iraq in an American helicopter.  `You completed your"
  PRINT "mission successfully.  See you later.'"
  PRINT
  PRINT
  COLOR 15 + 16
  PRINT "You beat the game."
  PRINT
  COLOR 4 + 16
  PRINT "THE END"
  WHILE INKEY$ = "": WEND
  GOTO done

dead:
  PRINT "You died and lost the game."
  END

done:
  END

CONST numlines = 13

musicroutine:
  IF initialized = 0 THEN
    curline = 1
    initialized = 1
    DIM music$(1 TO numlines)
    FOR x = 1 TO numlines
      READ music$(x)
    NEXT
    PLAY "mb o1"
  END IF

  PLAY music$(curline)
  curline = curline + 1
  IF curline > numlines THEN curline = 1
  RETURN

DATA "L4 E L8 A L4 F L8 A F A L4 F# L8 A L4 F L8 A F A"
DATA "L4 E L8 A L4 F L8 A F A L4 F# L8 A L4 F L8 A F A"
DATA "P4 L4 E L8 E L4 G ML B L2 B MN L4 A L8 G L4 G ML E L8 E MN L4 G E"
DATA "P5 P8 L8 E E L4 E ML L8 G L4 G MN L8 A ML L8 B L4 B MN P4 L8 B L4 > D < L8 B"
DATA "> L8 D# < B A L4 B P2 L8 E E L4 < B > E ML L1 C MN P8 L8 E L4 E E L8 G"
DATA "L4 B A G G L8 E L4 G L2 E ML P4 P2 MN L8 E E P2 L2 B L8 F# L4 G P4"
DATA "L8 E E P2 L4 B L8 F# L4 G P2 G L8 A L4 G A L8 G L4 A L2 G P4 L4 A"
DATA "L8 A L4 G B L8 E L4 E P2 E L8 A L4 F L8 A F A L4 F# L8 A L4 F"
DATA "L8 A F A L1 E E- P8 L8 E L4 E L2 E L4 E ML L1 E E E- E- MN L4 A G"
DATA "L8 F# L4 E L8 D E L4 E P2 P8 L8 G A L4 G A L8 E L4 E P4 P2 L1 E E- E"
DATA "L4 E P4 L8 E E P2 L2 B L8 F# L4 G P1 L8 E E P2 L2 B L8 F# L4 G P2 G"
DATA "P4 A L8 A L4 G B L8 E L4 E P2"
DATA "P1 P1 P1 P1"

FUNCTION cut$ (x)
  cut$ = LTRIM$(STR$(x))
END FUNCTION

FUNCTION getint (prompt$, min, max)
  y = POS(0)
  x = CSRLIN
  PRINT prompt$; "_  "
  DO
    DO: char$ = INKEY$: LOOP UNTIL char$ <> ""
    SELECT CASE char$
      CASE "0": IF LEN(edit$) THEN edit$ = edit$ + "0": IF VAL(edit$) > max THEN edit$ = cut$(max)
      CASE "1" TO "9": edit$ = edit$ + char$: IF VAL(edit$) > max THEN edit$ = cut$(max)
      CASE CHR$(8): IF LEN(edit$) THEN edit$ = LEFT$(edit$, LEN(edit$) - 1)
      CASE CHR$(13)
        value = VAL(edit$)
        IF value >= min THEN
          LOCATE x, y + LEN(prompt$) + LEN(edit$): PRINT " "
          EXIT DO
        END IF
        edit$ = ""
      CASE CHR$(27)
        getint = 0
        EXIT FUNCTION
    END SELECT
    LOCATE x, y + LEN(prompt$): PRINT edit$ + "_ "
  LOOP
  getint = value
END FUNCTION

FUNCTION getstr$ (prompt$, length)
  x = CSRLIN
  y = POS(0)
  LOCATE x, y: PRINT prompt$ + "_"
  DO
    DO: char$ = INKEY$: LOOP UNTIL char$ <> ""
    SELECT CASE char$
      CASE " " TO "}": IF LEN(edit$) < length THEN edit$ = edit$ + char$
      CASE CHR$(8): IF LEN(edit$) > 0 THEN edit$ = LEFT$(edit$, LEN(edit$) - 1)
      CASE CHR$(13)
        LOCATE x, y + LEN(prompt$) + LEN(edit$): PRINT " "
        EXIT DO
    END SELECT
    LOCATE x, y + LEN(prompt$): PRINT edit$ + "_ "
  LOOP
  getstr$ = edit$
END FUNCTION

FUNCTION question$ (prompt$, a1$, a2$, a3$, a4$)
  COLOR 15
  PRINT "    " + prompt$ + " ";
  DO
    DO: char$ = UCASE$(INKEY$): LOOP UNTIL char$ <> ""
    IF char$ = CHR$(0) THEN char$ = INKEY$: char$ = ""
    IF char$ = a1$ OR char$ = a2$ OR char$ = a3$ OR char$ = a4$ THEN EXIT DO
  LOOP
  PRINT char$
  COLOR clr
  question$ = char$
END FUNCTION

