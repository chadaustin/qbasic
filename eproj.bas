DECLARE SUB sponges ()
DECLARE SUB sponges2 ()
DECLARE SUB sponges3 ()
DECLARE SUB sponges4 ()
DECLARE SUB sponges7 ()
DECLARE SUB sponges9 ()
DECLARE SUB sponges11 ()
DECLARE SUB sponges10 ()
DECLARE SUB let2 ()
DECLARE SUB let1 ()
DECLARE SUB dance ()
DECLARE SUB menu ()
DECLARE SUB Instruct ()
DECLARE SUB music ()
DECLARE SUB Credits ()
DECLARE SUB sparkle ()
DECLARE SUB City ()
DECLARE SUB Title ()
City
SCREEN 13
DEFINT A-Z
FOR x = 1 TO 500 STEP 4
FOR y = 1 TO 350 STEP 2
        PSET (x, y), 14 MOD 5
  NEXT
NEXT
Title
music
sparkle
Credits
LOCATE 23, 1
5 INPUT "Ready to Explore? <Y, N>"; start$
IF start$ = "Y" THEN GOTO 10
IF start$ = "N" THEN END
10 CLS
Title
Instruct
15 COLOR 5
PRINT
PRINT
INPUT "Type in menu to continue"; start$
IF start$ = "menu" THEN 20
GOTO 15
20 menu
25 INPUT "Choose a Letter?"; menus$
IF menus$ = "A" THEN 30
IF menus$ = "B" THEN 40
IF menus$ = "C" THEN 50
IF menus$ = "D" THEN END
IF menus$ = "E" THEN 60
IF menus$ = "F" THEN 70
IF menus$ = "G" THEN 80
GOTO 25
30 dance
35 INPUT "Type menu to continue or end to quit"; dances$
IF dances$ = "menu" THEN 20
IF dances$ = "end" THEN END
GOTO 35
40 DEFINT A-Z
FOR e = 4 TO 14
LINE (0, 0)-(400, 400), e, BF
z = z + 1
let1
let2
IF z = 3 THEN sponges
IF z = 4 THEN sponges2
IF z = 5 THEN sponges3
IF z = 6 THEN sponges4
IF z = 7 THEN sponges7
IF z = 8 THEN sponges9
IF z = 9 THEN sponges10
IF z = 10 THEN sponges11
FOR y = 200 TO 1 STEP -1
   FOR x = 0 TO 200 STEP y
    LINE (x, 0)-(200, x), x MOD 2
    LINE (200, x)-(200 - x, 200), x MOD 2
    LINE (200 - x, 200)-(0, 200 - x), x MOD 2
    LINE (0, 200 - x)-(x, 0), x MOD 2
   NEXT
NEXT
NEXT
INPUT "Type menu to continue or end to quit"; init$
IF init$ = "menu" THEN 20
IF init$ = "end" THEN END
50 SCREEN 13
CLS
LINE (0, 0)-(400, 600), 2, BF
y! = .1
FOR x = 1 TO 200
    CIRCLE (160, 100), x, 0
NEXT x
INPUT "Type menu to continue or end to quit"; init$
IF init$ = "menu" THEN 20
IF init$ = "end" THEN END
60
CLS
WINDOW (0, 0)-(1, 1)
DO
 SELECT CASE RND
  CASE IS > 2 / 3
   x! = x! / 2
   y! = y! / 2
  CASE IS > 1 / 3
   x! = .5 * (.5 + x!)
   y! = .5 * (1 + y!)
  CASE ELSE
   x! = .5 * (1 + x!)
   y! = .5 * y!
 END SELECT
 PSET (x!, y!), (x! + y!) * 128
LOOP UNTIL INKEY$ <> ""
WINDOW SCREEN (0, 0)-(319, 199)
INPUT "Type menu to continue or end to quit"; init$
IF init$ = "menu" THEN 20
IF init$ = "end" THEN END
70
CLS
c = 0
FOR x = 0 TO 100
 FOR y = x TO 100
  CIRCLE (159, 99), y, y - x
  IF INKEY$ <> "" THEN c = 1: EXIT FOR
 NEXT
 IF c THEN EXIT FOR
NEXT
INPUT "Type menu to continue or end to quit"; init$
IF init$ = "menu" THEN 20
IF init$ = "end" THEN END
80
CLS
c = 0
FOR b = 1 TO 255
 FOR a = 0 TO 200
  LINE (100, 100)-(0, a), b
  LINE (100, 100)-(a, 200), b - 1
  LINE (100, 100)-(a, 0), b
  LINE (100, 100)-(200, a), b - 1
  IF INKEY$ <> "" THEN c = 1: EXIT FOR
 NEXT
 IF c THEN EXIT FOR
NEXT
INPUT "Type menu to continue or end to quit"; init$
IF init$ = "menu" THEN 20
IF init$ = "end" THEN END

SUB City
SCREEN 13
LINE (0, 0)-(350, 300), 4, BF
LINE (0, 0)-(6, 300), 4, BF
LINE (0, 0)-(350, 5), 4, BF
LINE (0, 200)-(350, 185), 4, BF
LINE (311, 0)-(325, 400), 4, BF
REM Building 1
LINE (5, 100)-(40, 200), 0, BF
LINE (5, 100)-(10, 200), 20, BF
REM Building 2
LINE (42, 75)-(75, 200), 0, BF
LINE (42, 75)-(47, 100), 20, BF
REM Building 3
LINE (77, 150)-(100, 200), 0, BF
REM Skyskraper
LINE (102, 50)-(150, 200), 0, BF
LINE (102, 50)-(105, 200), 20, BF
LINE (112, 20)-(114, 50), 0, BF
LINE (138, 20)-(136, 50), 0, BF
LINE (138, 20)-(136, 22), 14, BF
LINE (112, 20)-(114, 22), 14, BF
REM Sun
CIRCLE (0, 0), 30, 14
REM Building 4
LINE (140, 110)-(165, 200), 0, BF
REM Building 5
LINE (170, 90)-(200, 200), 0, BF

END SUB

SUB Credits
LOCATE 21, 35
COLOR 14
PRINT "Program by Eric Chenoweth (c) 1996"
END SUB

SUB dance
CLS
PRINT "         Ode to my Family"
FOR x = 1 TO 2
Cranberries$ = "MBT180o3G4.E5F+4.F+4.P5F+4.E5F+4.F+4.P5F+4.E5F+4.F+4.P5F+4.G5D4.D4.P5"
PLAY Cranberries$
NEXT
RANDOMIZE TIMER
FOR e = 1 TO 25
CLS
a = RND * 250
b = RND * 250
FOR n = 1 TO 10
CIRCLE (a, b), (RND * 50), RND * 1
CIRCLE (a, b), (RND * 100), RND * 3
CIRCLE (a, b), RND * 75, RND * 4
NEXT n
FOR z = 1 TO 100: NEXT z
NEXT e

END SUB

SUB Instruct
CLS
PRINT " Welcome to Hack the City!"
PRINT " This is a Program created by Eric Chenoweth in 1996."
PRINT " The purpose is to use this program to explore computer graphics and gaming."
PRINT " I have created my own menu of nifty graphics for your enjoyment."
PRINT " Feel free to explore and create your own menu additions."
END SUB

SUB let1
LINE (75, 50)-(75, 130), 1
LINE (75, 50)-(115, 50), 1
LINE (75, 90)-(108, 90), 1
LINE (75, 130)-(115, 130), 1

END SUB

SUB let2
LINE (225, 50)-(225, 130), 1
LINE (225, 50)-(275, 50), 1
LINE (225, 130)-(275, 130), 1

END SUB

SUB menu
CLS
COLOR 1
PRINT "               MENU"
PRINT
COLOR 2
PRINT "A) Dance of the Circles (music by Cranberries)"
COLOR 3
PRINT "B) Psycadelic Initials (music by Sponge)"
PRINT
COLOR 4
PRINT "C) Fractal Circles"
PRINT
COLOR 5
PRINT "D) Quit"
PRINT
COLOR 6
PRINT "E) Triangular Fractal"
PRINT
COLOR 7
PRINT "F) Moving Tube"
PRINT
COLOR 9
PRINT "G) Rotating Square"
PRINT
END SUB

SUB music
Nirvana$ = "MBT180o2F5F5F5F5B-5B-5B-5B-5A-5A-5A-5A-5o3C+5C+5C+5C"
Nirv$ = "MBT180o2F4"
FOR m = 1 TO 2
        PLAY Nirvana$
NEXT
PLAY Nirv$
END SUB

SUB sparkle
FOR x = 1 TO 33
FOR t4 = 1 TO 3000: NEXT t4
  CIRCLE (0, 0), 30, 4
  LINE (35, 5)-(40, 10), 4
  LINE (39, 15)-(60, 25), 4
  LINE (30, 20)-(45, 30), 4
  LINE (20, 30)-(25, 45), 4
  LINE (15, 32)-(16, 23), 4
  LINE (10, 28)-(12, 40), 4
  LINE (5, 34)-(3, 50), 4
   FOR t4 = 1 TO 1000: NEXT t4
  CIRCLE (0, 0), 30, 43
  LINE (35, 5)-(40, 10), 14
  LINE (39, 15)-(60, 25), 14
  LINE (30, 20)-(45, 30), 14
  LINE (20, 30)-(25, 45), 14
  LINE (15, 32)-(16, 23), 14
  LINE (10, 28)-(12, 40), 14
  LINE (5, 34)-(3, 50), 14
NEXT
END SUB

SUB sponges
REM Opening
Sponge$ = "MBT180o2D6EEEEE5E5P5C4.P4"
REM Second phrase
Sponge2$ = "MBT180o2E5E5FGEEFP5G4.P4"
REM Third Phrase
Sponge3$ = "MBT180o2C5C5.o1B4.A2o2E2.E.EE5C5C4.P4"
REM Don't ask WHY
Why$ = "MBT180o2E5E5.FG2.P5o3C3.Co2GG2.P4."
REM Down the Drain
drain$ = "MBT180o2P2EEECDEC2P3"
REM Guitar
Guitar$ = "MBT180o3C5D5E5C5G5.C5D5C5o2B-5o3C5D5o2B-5o3F5.o2B-5o3C5o2B-5"
Guitarend$ = "MBT180o3C5D5E5C5G5.C5D5C5o2B-5o3C5D5o2B-5o3F5.o2B-5o3C5o2B-5C2"
PLAY Sponge$
PLAY Sponge2$
PLAY Sponge$
END SUB

SUB sponges10
REM Guitar
Guitar$ = "MBT180o3C5D5E5C5G5.C5D5C5o2B-5o3C5D5o2B-5o3F5.o2B-5o3C5o2B-5"
PLAY Guitar$

END SUB

SUB sponges11
Guitarend$ = "MBT180o3C5D5E5C5G5.C5D5C5o2B-5o3C5D5o2B-5o3F5.o2B-5o3C5o2B-5C2"
PLAY Guitarend$
END SUB

  SUB sponges2
REM Third Phrase
Sponge3$ = "MBT180o2C5C5.o1B4.A2o2E2.E.EE5C5C4.P4"
PLAY Sponge3$
END SUB

SUB sponges3
REM Don't ask WHY
Why$ = "MBT180o2E5E5.FG2.P5o3C3.Co2GG2.P4."
PLAY Why$
PLAY Why$
END SUB

SUB sponges4
REM Down the Drain
drain$ = "MBT180o2P2EEECDEC2P3"
PLAY drain$
END SUB

'
SUB sponges7
REM Guitar
Guitar$ = "MBT180o3C5D5E5C5G5.C5D5C5o2B-5o3C5D5o2B-5o3F5.o2B-5o3C5o2B-5"
PLAY Guitar$
END SUB

SUB sponges9
REM Guitar
Guitar$ = "MBT180o3C5D5E5C5G5.C5D5C5o2B-5o3C5D5o2B-5o3F5.o2B-5o3C5o2B-5"
PLAY Guitar$

END SUB

SUB Title
REM Hack
LINE (160, 5)-(165, 40), 6, BF
LINE (165, 22.5)-(175, 24.5), 6, BF
LINE (175, 5)-(180, 40), 6, BF
REM
LINE (190, 23.5)-(193, 39), 6, BF
LINE (190, 23.5)-(205, 24.5), 6, BF
LINE (193, 39)-(205, 38), 6, BF
LINE (205, 22.5)-(209, 40), 6, BF
REM
LINE (219, 22.5)-(222, 40), 6, BF
LINE (219, 22.5)-(234, 24.5), 6, BF
LINE (222, 40)-(234, 38), 6, BF
REM
LINE (244, 5)-(247, 40), 6, BF
LINE (247, 30)-(252, 35), 6, BF
LINE (252, 30)-(257, 25), 6, BF
LINE (252, 35)-(257, 40), 6, BF
REM the
LINE (190, 50)-(190, 70), 6
LINE (185, 57)-(195, 57), 6
REM
LINE (205, 50)-(205, 70), 6
LINE (205, 63)-(212, 63), 6
LINE (212, 63)-(212, 70), 6
REM
LINE (222, 60)-(222, 70), 6
LINE (222, 60)-(230, 60), 6
LINE (230, 60)-(230, 63), 6
LINE (230, 63)-(222, 63), 6
LINE (222, 70)-(231, 70), 6
FOR t = 1 TO 10000: NEXT t
FOR t1 = 1 TO 10000: NEXT t1
FOR t2 = 1 TO 10000: NEXT t2
FOR t3 = 1 TO 10000: NEXT t3
REM City
LOCATE 12, 22
COLOR 10
PRINT "$$$$"
LOCATE 13, 22
PRINT "$"
LOCATE 14, 22
PRINT "$"
LOCATE 15, 22
PRINT "$"
LOCATE 16, 22
PRINT "$$$$"
REM
FOR x23 = 13 TO 17
LOCATE x23, 27
PRINT "$"
NEXT
REM
LOCATE 14, 29
PRINT "$$$$$"
FOR x24 = 15 TO 18
LOCATE x24, 31
PRINT "$"
NEXT
REM
LOCATE 15, 35
PRINT "$"
LOCATE 15, 39
PRINT "$"
LOCATE 16, 36
PRINT "$"
LOCATE 16, 38
PRINT "$"
LOCATE 17, 37
PRINT "$"
LOCATE 18, 37
PRINT "$"
LOCATE 19, 37
PRINT "$"
END SUB

