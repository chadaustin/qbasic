DEFINT A-Z
DECLARE FUNCTION GetString$ (row%, col%, a$, length%)
DECLARE FUNCTION Query$ (text$, a$, b$, c$, d$)
DECLARE SUB Center (row%, text$)
DECLARE SUB Lpr (text$)
DECLARE SUB Store ()
 PLAY "mb"
 DIM SHARED clr
 CLS
 COLOR 15
 Center 2, "The Spy Game"
 Center 3, "Ver. 2.5"
 COLOR 13
 Center 4, "Written by: C. A. Austin"
 COLOR 12
 LOCATE 6, 42
 PRINT "(1-14)"
 LOCATE 6, 30: PRINT "Color: _"
 DO
  b$ = INKEY$
  SELECT CASE b$
  CASE "0" TO "9": IF LEN(a$) < 2 THEN a$ = a$ + b$: IF VAL(a$) > 14 THEN a$ = "14"
  CASE CHR$(8): IF LEN(a$) > 0 THEN a$ = LEFT$(a$, LEN(a$) - 1)
  CASE CHR$(13)
   clr = VAL(a$)
   IF clr > 0 THEN
    LOCATE 6, 37 + LEN(a$): PRINT " "
    EXIT DO
   END IF
   a$ = ""
  END SELECT
  LOCATE 6, 37: PRINT a$ + "_ "
 LOOP
 nam$ = GetString$(7, 30, "Name:  ", 12)
 COLOR clr
 PRINT
 Lpr "  `Hi, " + nam$ + ".  I am a secret agent sending you on a mission"
 Lpr "to Iraq to inform us on the building of nuclear weapons.  The"
 Lpr "CIA and the Pentagon will give you supplies and a plane ticket."
 Lpr "Be ready tomorrow at nine hundred hours and meet me at the"
 Lpr "airport.'"
 DO
  SELECT CASE Query("Where do you go? (Store/Apartment)", "S", "A", "  ", "  ")
  CASE "S": Store
  CASE "A"
   Lpr "  You go to your apartment.  It feels as if someone is watching"
   Lpr "you.  You know you need to pack for your mission to Iraq."
   a$ = Query("What do you do? (Pack/Search the apartment/Leave)", "P", "S", "L", "  ")
   SELECT CASE a$
   CASE "P"
    Lpr "  You begin to pack when you hear a rustling in the closet."
    Lpr "A man jumps out and draws a pistol.  One bullet through the"
    Lpr "chest is all it takes to kill you."
    END
   CASE "L"
    Lpr "  You leave the apartment."
   CASE "S"
    Lpr "  You search the apartment carefully and quietly.  When opening"
    Lpr "the closet door, a man dressed in black jumps out.  He pulls"
    Lpr "a gun, but you wrestle him to the ground.  `Please don't kill"
    Lpr "me,' he pleads, `I will tell you everything.'"
    z$ = Query("What do you do? (Kill him/Let him go/Talk to him)", "K", "L", "T", "  ")
    SELECT CASE z$
    CASE "K": Lpr "  You shoot him and his body lies lifeless on the floor."
    CASE "T"
     Lpr "  He begins stuttering but soon talks smoothly.  `I was hired by"
     Lpr "the Iraqi government to spy on and kill you.  My contacts, here"
     Lpr "in America, told me where you lived.  I hid in your closet until"
     Lpr "you came home.  Then you attacked me.  That is all I know."
     y$ = Query("What do you do to him now? (Kill him/Tie him up)", "K", "T", "  ", "  ")
     IF y$ = "K" THEN Lpr "  You shoot him and his body lies lifeless on the floor." ELSE Lpr "  You tie him to a chair and gag him."
    CASE "L": Lpr "You let him go."
    END SELECT
   END SELECT
  END SELECT
 LOOP UNTIL a$ <> "L"
 IF Query("What do you do now? (Sleep/Contact the CIA)", "S", "C", "  ", "  ") = "C" THEN
  Lpr "  `Hi " + nam$ + ".  I heard about the men that are trying to kill"
  Lpr "you.  Anyway, meet me at the airport tomorrow and try to get some"
  Lpr "sleep now."
  IF y$ = "T" THEN
   LOCATE CSRLIN - 1, 22
   PRINT "A fellow agent will pick up your prisoner tonight.'"
  ELSE
   LOCATE CSRLIN - 1, 20
   PRINT "'"
  END IF
 END IF
 Lpr "  You get in bed.  After tossing and turning, you eventually"
 Lpr "fall asleep.  Nightmares haunt you until your alarm clock"
 Lpr "goes off at 7:30 a.m."
 DO
  a$ = Query("Where do you go? (Airport/Store/Restaurant/Bar)", "A", "S", "R", "B")
  SELECT CASE a$
  CASE "S": Store
  CASE "B"
   Lpr "  You enter the bar.  Many drunk men are sleeping around you."
   Lpr "One man tells you to leave."
   IF Query("Do you? (Yes/No)", "Y", "N", "  ", "  ") = "N" THEN
    Lpr "  The man gets up and shoots you.  Your last thought is that"
    Lpr "the men are laughing at you."
    END
   ELSE Lpr "You leave the bar."
   END IF
  CASE "R"
   Lpr "  The restaurant is empty except for some waiters."
   b$ = Query("Do you order food? (Yes/No)", "Y", "N", "  ", "  ")
   IF b$ = "Y" THEN
    Lpr "  You begin to eat your food when you realize you need to go"
    Lpr "to the airport.  After jumping in the car, you speed to the airport."
   END IF
  END SELECT
 LOOP UNTIL a$ = "R" AND b$ = "Y" OR a$ = "A"
 Lpr "  The airport is bustling with activity.  A man rushes up to you."
 Lpr "He is the secret agent!  `Good morning, " + nam$ + ".  I am glad"
 Lpr "that you could meet me here.  Here are your supplies.'  He"
 Lpr "hands you a high-powered rifle, which you put with your pistol,"
 Lpr "a paper that allows you to take your equipment on a commercial"
 Lpr "plane, a fake ID, a fake passport, some clothes, and $5000."
 Lpr "`The plane is taking off in forty-five minutes.  A man in Iraq"
 Lpr "will meet you at the airport.  He will tell you what to do."
 Lpr "Remember, be at gate 5A in forty-five minutes.  Until then, have fun!'"
 Lpr "The man leaves."
 DO
  a$ = Query("Where do you go? (Shop/Gate 5A/Bathroom)", "S", "G", "B", "  ")
  IF a$ = "B" THEN
   Lpr "  You accidentally enter the woman's bathroom.  A woman screams and"
   Lpr "slaps you.  You blush, leave, and enter the men's bathroom."
   Lpr "The bathroom is clean but a stench fills the air.  Many men are"
   Lpr "relieving themselves, but a few are smoking against the wall."
   Lpr "You notice a `no-smoking' sign on the wall."
   IF Query("Do you approach the men? (Yes/No)", "Y", "N", "  ", "  ") = "Y" THEN
    Lpr "  A man says, `We no botherin' no one.  We goan kill you.'"
    Lpr "Before you can react, security guards come in and take the men away."
    a$ = Query("Where do you go now? (Shop/Gate 5A)", "S", "G", "  ", "  ")
   END IF
  END IF
 LOOP UNTIL a$ = "S" OR a$ = "G"
 IF a$ = "S" THEN
  Lpr "  You enter the shop.  You look around at the items for sale and"
  Lpr "decide that they are too outrageously priced to be bought."
  Lpr "You look at your watch and see that it is almost time to leave."
 END IF
 Lpr "  A loudspeaker says, `The plane is about to leave.'"
 Lpr "A security guard sees your guns in your bag, but you show him"
 Lpr "your paper.  He nods and places your bags in the back of the plane."
 Lpr "He looks at your passport and says, `Steve Carson?  I could"
 Lpr "almost swear your name is " + nam$ + ".'  You feel sweat on your"
 Lpr "neck and upper lip.  The man says, `I must know someone that"
 Lpr "looks like you.'  You get on the plane and sit quietly for a"
 Lpr "few minutes.  The plane takes off and nothing happens for a few"
 Lpr "hours.  A man stands up and enters the cockpit.  He comes out after"
 Lpr "a while with a gun to the pilots head.  `I am hijacking this plane,'"
 Lpr "he says."
 SELECT CASE Query$("What do you do? (Attack the hijacker/Get your guns/Hide)", "A", "G", "H", "  ")
 CASE "A"
  Lpr "  You jump out of your seat and punch the hijacker.  He hits"
  Lpr "you with his pistol and knocks you out.  Days later you wake"
  Lpr "up in a cell in a terrorist base.  You are there for the rest"
  Lpr "of your short life."
  END
 CASE "H"
  Lpr "  You hide in the bathroom while the plane goes on its way to"
  Lpr "Moscow.  After hours of flight, the plane lands.  Everybody"
  Lpr "gets off the plane to be taken to a base somewhere."
  IF Query("What do you do? (Follow the prisoners/Leave the airport)", "F", "L", "  ", "  ") = "F" THEN
   Lpr "  You follow the prisoners and see them being taken into a secret"
   Lpr "base.  You go into the base and see a leader talking to a group"
   Lpr "of men.  He notices you!  `Well, " + nam$ + ", I had my men"
   Lpr "hijack that plane because you would be on it.  I guess they did"
   Lpr "not hijack the wrong plane after all.'  He pulls out a bag with"
   Lpr "all your equipment in it!  Suddenly,  police jump in the room "
   Lpr "and shoot the leader.  Your equipment is given back, but the"
   Lpr "$5000 is missing.  The police thank you."
  ELSE Lpr "Your equipment is found in a gutter, but the $5000 is gone."
  END IF
  Lpr "  You find yourself on a deserted street.  You run and see a"
  Lpr "pretty woman.  She is sleeping in a parked car."
  IF Query("What do you do? (Get in the car/Keep walking)", "G", "K", "  ", "  ") = "K" THEN
   Lpr "  You keep walking and a band of gangsters shoots you and steals"
   Lpr "your equipment."
   END
  ELSE
   Lpr "  You get in the car."
   a$ = Query("What do you do now? (Start the car/Kill the woman/Leave the car)", "S", "L", "K", "  ")
   IF a$ = "K" THEN
    Lpr "The woman is now dead."
   ELSEIF a$ = "L" THEN
    Lpr "  You keep walking and a band of gangsters shoots you and steals"
    Lpr "your equipment."
    END
   END IF
   Lpr "  You start the car and begin driving south."
   IF a$ = "S" THEN
    Lpr "The woman wakes up and begins to talk.  She says, `Please drive me to a"
    Lpr "certain house.'"
    IF Query("Do you? (Yes/No)", "Y", "N", "  ", "  ") = "N" THEN
     Lpr "  The woman says, `If I can't get my way, you won't get yours.'"
     Lpr "She takes your high-powered rifle and blows your brains out."
     END
    END IF
    Lpr "  You drive her to the house.  She thanks and kisses you."
    Lpr "`Good-bye.  Thanks again for driving me.  Her voice fades in the"
    Lpr "distance."
   END IF
  END IF
  Lpr "  You keep driving and travel closer and closer to Iraq."
 CASE "G"
  Lpr "  You go to the back of the plane to get your guns."
  Lpr "When you come out of the luggage room, the pilot is being forced"
  Lpr "to travel to Moscow.  You sneak up on the hijacker and are ready"
  Lpr "to shoot him."
  IF Query("Do you? (Yes/No)", "Y", "N", "  ", "  ") = "N" THEN
   Lpr "  The hijacker notices you and shoots you.  You never knew what"
   Lpr "hit you."
   END
  END IF
  Lpr "  You shoot the hijacker and put him in an empty suitcase."
  Lpr "Everybody on the plane thanks you and you sit down."
  Lpr "The pilot changes course from Moscow to Iraq."
  Lpr "You notice that the $5000 in your bag is missing."
 END SELECT
 Lpr "  You make your way to the airport in Baghdad.  Another secret agent"
 Lpr "approaches you.  `Hi, " + nam$ + ", follow me."
 IF Query("What do you do?  (Follow the agent/Look around)", "F", "L", "  ", "  ") = "F" THEN
  Lpr "  You follow the agent.  He takes you to his house in the hills."
  IF z$ = "L" THEN
   Lpr "`Remember me?  I have tried to kill you at your house before."
   Lpr "Now I will definitely kill you.'  BANG!!"
  ELSE Lpr "`I am a fake agent.  Now you will die!'"
  END IF
  END
 END IF
 Lpr "  You look around in the airport.  A man whispers to you,"
 Lpr "`I am the man that is supposed to meet you.  Come with me.'"
 IF Query("Do you follow him? (Yes/No)", "Y", "N", "  ", "  ") = "N" THEN
  Lpr "  You decide to study the airport more closely."
  Lpr "The man turns around and yells, `FOLLOW ME NOW!'"
  Lpr "A sniper shot travels through your head and a second shot kills"
  Lpr "the agent meeting you."
  END
 END IF
 Lpr "  The man takes you to his home.  His home is a small, three"
 Lpr "room apartment.  He opens a closet door and gives you a"
 Lpr "Code 5 security pass that allows you to enter Iraqi installations."
 Lpr "He also lets you borrow his jeep.  You stay there for the night."
 Lpr "The next morning you feel ready for your mission.  You leave."
 DO
  a$ = Query("Where do you go? (Bar/Installation/Terrorist HQ)", "B", "I", "T", "  ")
  SELECT CASE a$
  CASE "B"
   Lpr "  You enter the bar.  Many Arab men are sitting at stools,"
   Lpr "drinking beer.  Someone offers you a drink and you sit down."
   Lpr "`I heard that the installation outside of town is mass"
   Lpr "producing nuclear weapons.'"
  CASE "T"
   Lpr "  The terrorist headquarters is heavily guarded.  There are"
   Lpr "many ways to get in."
   SELECT CASE Query("What do you do? (Leave/Kill the guards/Sneak past the guards)", "L", "K", "S", "  ")
   CASE "S"
    Lpr "  You try to sneak past the guards.  These men are well trained"
    Lpr "and can hear you.  A couple well placed shots eliminate you."
   CASE "K"
    IF Query("Which gun do you want to use? (Pistol/Rifle)", "P", "R", "  ", "  ") = "P" THEN
     Lpr "  You begin firing at the guards but none of the shots can reach"
     Lpr "the guards.  A few counter shots kill you."
     END
    END IF
    Lpr "  All the guards die under your fire.  You find the headquarters"
    Lpr "abandoned so you go on to the installation."
    a$ = "I"
   END SELECT
  END SELECT
 LOOP UNTIL a$ = "I"
 Lpr "  The installation has no guards, although you notice some"
 Lpr "snipers in the windows.  It is a tall building situated in the"
 Lpr "middle of the woods."
 a$ = Query("How will you get in? (Kill the snipers/Charge/Sneak into the installation)", "K", "C", "S", "  ")
 SELECT CASE a$
 CASE "C"
  Lpr "  You charge the base, making a lot of noise and the snipers notice"
  Lpr "you.  Their shots are well aimed and you make an easy target."
  END
 CASE "S": Lpr "  You sneak past the snipers and enter the installation."
 CASE "K"
  Lpr "  You aim your rifle and kill some of the snipers.  The remaining"
  Lpr "men leave the windows."
 END SELECT
 IF Query("Do you enter the installation? (Yes/No)", "Y", "N", "  ", "  ") = "N" THEN
  PRINT
  PRINT
  a$ = LCASE$(GetString$(22, 10, "Why would you want to leave the installation? ", 24))
  IF a$ = "because" THEN
   Lpr "Okay, you can leave."
   Lpr "A man on the street kills you."
   END
  ELSEIF aa$ = "" THEN Lpr "Yeah, right!"
  ELSE Lpr "WRONG ANSWER!!!"
  END IF
 END IF
 Lpr "  You enter the installation.  Three halls are before you."
 DO
  a$ = Query("Which one do you go down? (Forward/Right/Left)", "F", "R", "L", "  ")
  IF a$ <> "F" THEN Lpr "  You travel around in a wide circle and end up where you started from."
 LOOP UNTIL a$ = "F"
 Lpr "  You travel up the hall. Straight ahead there is a stairway and"
 Lpr "there is an office to your right.  You also find a secret elevator."
 a$ = Query("Where do you go? (Stairs/Office/Elevator)", "S", "O", "E", "  ")
 IF a$ = "O" THEN
  Lpr "  You go into the office.  A tech is working at a computer.  The"
  Lpr "man turns around and calls guards.  Many men rush in and"
  Lpr "surprise you.  You are sitting there with seven armed men."
  Lpr "One man yells, `He is a spy!  Get him!'  The men rush you."
  IF Query("What do you do? (Attack the men/Take the technician as a hostage)", "A", "T", "  ", "  ") = "A" THEN
   Lpr "  You decide to attack the men, but they all take out guns"
   Lpr "and blow your head off before you get a shot."
   END
  ELSE
   Lpr "  You take the technician as hostage and tell the men to get up"
   Lpr "against the wall.  After they do, you take your pistol and shoot"
   Lpr "every one, even the tech."
   a$ = Query("Where do you go now? (Stairs/Elevator)", "S", "E", "  ", "  ")
  END IF
 END IF
 IF a$ = "S" THEN
  Lpr "  The stairs are steep but you finally make it to the top."
  Lpr "You notice the elevator beside you."
 ELSE
  Lpr "  You go up the elevator and reach the second floor."
  Lpr "You notice the stairs next to you."
 END IF
 Lpr "The second  floor looks like a lab and a computer"
 Lpr "center.  Many techs rush beside you."
 DO
  SELECT CASE Query("Where do you go? (Laboratory/Computer room/Unmarked Room)", "L", "C", "U", "  ")
  CASE "L": Lpr "  The laboratory is empty."
  CASE "C"
   Lpr "  You enter the computer room.  Many lights are flashing around"
   Lpr "you.  Imagine this all day:"
   COLOR 31
   FOR x = 1 TO 20
    a$ = ""
    FOR y = 1 TO 60
     a$ = a$ + LTRIM$(STR$(CINT(RND)))
    NEXT
    Lpr a$
    IF x MOD 2 = 0 THEN PLAY "L32N15N40N45N60" ELSE PLAY "L32N20N50N20N25"
   NEXT
   IF Query("Do you look at the computer? (Yes/No)", "Y", "N", "  ", "  ") = "Y" THEN
    Lpr "  The computer has many files.  You look through them,"
    IF CINT(RND) = 1 THEN
     Lpr "and you see a file headed `Nuclear Weapons Production."
     Lpr "  You open the file and see that this installation is making"
     Lpr "nuclear weapons.  A printout is the evidence you need."
     Lpr "You leave the computer room."
     a = 1
    ELSE Lpr "but you find nothing interesting in the files."
    END IF
   END IF
  CASE "U"
   IF b = 0 THEN
    Lpr "  The unmarked room has many soldiers in it.  A general sees"
    Lpr "you and fires at you.  Luckily, the shot was a miss.  `Well,"
    Lpr nam$ + ", we have been waiting for you.'"
    SELECT CASE Query("What do you do? (Attack the soldiers/Kill the general/Run/Scream)", "A", "K", "R", "S")
    CASE "S"
     Lpr "  You yell an ear-splitting scream, but this does not seem to affect"
     Lpr "the soldiers.  `You idiot, " + nam$ + ".'  One shot kills you."
     END
    CASE "K"
     Lpr "  You level your pistol and kill the general, pumping five shots"
     Lpr "into his chest.  The soldiers shoot at you, but you die a hero."
     PLAY "L5N10N9N8N7N6N5N4N3N2N1"
     END
    CASE "R"
     Lpr "  You break into a wild sprint down the hall, but shots from"
     Lpr "behind you knock you down the stairs.  Your last memory is that"
     Lpr "your neck breaks."
     END
    CASE "A"
     Lpr "  You duck behind a desk and shoot all of the soldiers."
     Lpr "The mad general attacks you, but a fatal shot to the head"
     Lpr "kills him."
     b = 1
     IF a = 0 THEN Lpr "Go to the computer room to get your evidence."
    END SELECT
   ELSE Lpr "The room is empty"
   END IF
  END SELECT
 LOOP UNTIL a AND b
 Lpr "  You exit Iraq in an American helicopter.  `You completed your"
 Lpr "mission successfully.  See you later.'"
 WHILE INKEY$ = "": WEND
 PRINT
 PRINT
 COLOR clr + 1
 IF clr = 15 THEN COLOR 14
 Lpr "You beat the game!!!!!!"
 PRINT
 PRINT
 PRINT
 Center CSRLIN, "T H E   E N D"
 DO
  PLAY "mfl16n30n20n40n20n10n20n30n20"
 LOOP UNTIL INKEY$ <> ""
 COLOR 7
 END

SUB Center (row, text$)
 LOCATE row, 40 - INT(LEN(text$) / 2)
 PRINT text$
END SUB

FUNCTION GetString$ (row, col, text$, length)
 LOCATE row, col: PRINT text$ + "_"
 DO
  kbd$ = INKEY$
  SELECT CASE kbd$
  CASE " " TO "}": IF LEN(a$) < length THEN a$ = a$ + kbd$
  CASE CHR$(8): IF LEN(a$) > 0 THEN a$ = LEFT$(a$, LEN(a$) - 1)
  CASE CHR$(13)
   IF a$ <> "" THEN
    LOCATE row, col + LEN(text$) + LEN(a$): PRINT " "
    EXIT DO
   END IF
  END SELECT
  LOCATE row, col + LEN(text$): PRINT a$ + "_ "
 LOOP
 GetString$ = a$
END FUNCTION

SUB Lpr (text$)
 LOCATE CSRLIN, 10
 PRINT text$
END SUB

FUNCTION Query$ (text$, a$, b$, c$, d$)
 COLOR 15
 Center CSRLIN, text$
 COLOR clr
 WHILE e$ <> a$ AND e$ <> b$ AND e$ <> c$ AND e$ <> d$
  e$ = UCASE$(INKEY$)
 WEND
 Query$ = e$
END FUNCTION

SUB Store
 Lpr "  You go to the store.  The manager says, `May I help you?'"
 a$ = Query("What do you need? (Guns/Supplies)", "G", "S", "  ", "  ")
 Lpr "  Before you buy anything, assassins jump through a window and"
 Lpr "begin shooting.  You and the manager die in the midst of fire."
 END
END SUB

