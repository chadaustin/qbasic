DEFINT A-Z
DECLARE SUB Center (x%, a$)
DECLARE SUB Detect (a$)
RANDOMIZE TIMER
DO
 ON ERROR GOTO problem
 SCREEN 0
 CLS
 Center 3, "Master Program"
 Center 4, "By: Chad Austin"
 Center 5, "1-2-96"
 Center 8, "    1)  Hearing Test          "
 Center 9, "    2)  Screen Designs        "
 Center 10, "    3)  Port and RAM Checks   "
 Center 11, "    4)  Joystick Test         "
 Center 12, "    5)  Geometric Screen Saver"
 Center 13, "    6)  Keyboard Test         "
 Center 14, "    7)  Detect Monitor        "
 Center 15, "    8)  Math                  "
 Center 16, "    9)  Exit                  "
 Center 20, "Select Item (1-9)"
 DO
  mode = VAL(INKEY$)
 LOOP UNTIL mode > 0 AND mode < 10
 SELECT CASE mode
 CASE 1
  CLS
  Center 8, "Hearing Test"
  Center 9, "By: Chad Austin"
  Center 12, "    This test will measure the frequency of     "
  Center 13, "highest pitch you hear.  This test is not a true"
  Center 14, "hearing test.                                   "
  Center 17, "Hit any key to begin"
  WHILE INKEY$ <> "": WEND
  WHILE INKEY$ = "": WEND
  Center 17, "Hit a key when you cannot hear the sound"
  x& = 20
  DO
   x& = x& + 20
   SOUND x&, .3
  LOOP UNTIL INKEY$ <> "" OR x& > 32759
  Center 19, STR$(x&) + " is the highest pitch (in hertz) you can hear"
  WHILE INKEY$ = "": WEND
 CASE 2
  ON ERROR GOTO ScreenError
  SCREEN 13
  KEY 15, CHR$(0) + CHR$(1)
  KEY 16, CHR$(0) + CHR$(58)
  KEY 17, CHR$(0) + CHR$(69)
  KEY 18, CHR$(0) + CHR$(70)
  ON KEY(15) GOSUB EndGame
  FOR x = 15 TO 18
   KEY(x) ON
  NEXT
  DEF SEG = 0
  KeyFlag = PEEK(1047)
  POKE 1047, 0
  DEF SEG
  SCREEN 13
  LOCATE 1, 34: PRINT "Hit"
  LOCATE 2, 34: PRINT "ESC"
  LOCATE 3, 34: PRINT "to"
  LOCATE 4, 34: PRINT "exit"
  WHILE INKEY$ <> "": WEND
  DO
   z = CINT(RND * 5) + 1
   FOR x = 0 TO 255
    FOR y = 1 TO 199
     SELECT CASE z
     CASE 1: PSET (x, y), x AND y
     CASE 2: PSET (x, y), x OR y
     CASE 3: PSET (x, y), x XOR y
     CASE 4: PSET (x, y), x EQV y
     CASE 5: PSET (x, y), x IMP y
     CASE 6: PSET (x, y), x MOD y
     END SELECT
    NEXT
   NEXT
   SLEEP 10
  LOOP
 CASE 3
  DO
   CLS
   ON ERROR GOTO FileError
   a = 1
   b = 1
   OPEN "port.dat" FOR INPUT AS #1
   CLOSE
   PRINT "   Port:"
   PRINT "       1) Save port info"
   IF a THEN
    PRINT "       2) Load and check previous info"
    PRINT "       3) Delete previous info"
   END IF
   PRINT "   RAM:"
   PRINT "       4) Save RAM info"
   b = 2
   a = a + 2
   OPEN "ram.dat" FOR INPUT AS #1
   CLOSE
   IF a = 2 OR a = 3 THEN
    PRINT "       5) Load and check previous info"
    PRINT "       6) Delete previous info"
   END IF
   PRINT "   7) Exit utility"
   ON ERROR GOTO 0
   PRINT "   Enter mode:";
   ON ERROR GOTO 0
   DO
    y = VAL(INKEY$)
    IF ((y = 2 OR y = 3) AND (a = 0 OR a = 2)) OR ((y = 5 OR y = 6) AND (a = 0 OR a = 1)) THEN y = 0
   LOOP UNTIL y > 0 AND y < 8
   PRINT y
   SELECT CASE y
   CASE 1
    PRINT "   Working. . . ."
    OPEN "port.dat" FOR BINARY AS #1
    f = CSRLIN
    FOR x = -32768 TO 32766
     z = INP(x + 32768)
     PUT #1, , z
     IF (x + 32768) MOD 5242.88 = 0 THEN LOCATE f: PRINT USING "   ##% completed"; (x + 32768) / 655.36
     IF INKEY$ <> "" THEN CLOSE : KILL "port.dat": EXIT FOR
    NEXT
    a = a + 1
   CASE 2
    IF a THEN
     OPEN "port.dat" FOR BINARY AS #1
     PRINT "Differences between previous and current port data are shown below"
     PRINT "Press any key to begin"
     WHILE INKEY$ = "": WEND
     CLS
     PRINT " Port #        Input #       Old #"
     LOCATE 1, 40: PRINT "Press ESC to exit"
     VIEW PRINT 3 TO 25
     b = -1
     FOR x = -32768 TO 32766
      GET #1, , z
      IF z <> INP(x + 32768) THEN PRINT x + 32768; "("; HEX$(x + 32768); ")", INP(x + 32768); "("; HEX$(INP(x + 32768)); ")", z; "("; HEX$(z); ")": b = b + 1
      IF b = 21 THEN
       LOCATE 12, 40: PRINT "End of screen"
       LOCATE 13, 40: PRINT "Hit any key to continue"
       DO
        a$ = INKEY$
       LOOP UNTIL a$ <> ""
       IF a$ = CHR$(27) THEN EXIT FOR
       LOCATE 12, 40: PRINT "             "
       LOCATE 13, 40: PRINT "                       "
       LOCATE 25
       b = 0
      END IF
      IF INKEY$ = CHR$(27) THEN EXIT FOR
     NEXT
     VIEW PRINT
     WHILE INKEY$ = "": WEND
    END IF
   CASE 3: IF a THEN KILL "port.dat"
   CASE 4
    PRINT "   Working. . . ."
    OPEN "ram.dat" FOR BINARY AS #1
    f = CSRLIN
    FOR x = -32768 TO 32766
     z = PEEK(x + 32768)
     PUT #1, , z
     IF (x + 32768) MOD 5242.88 = 0 THEN LOCATE f: PRINT USING "   ##% completed"; (x + 32768) / 655.36
     IF INKEY$ <> "" THEN CLOSE : KILL "ram.dat": EXIT FOR
    NEXT
    a = a + 2
   CASE 5
    IF a THEN
     OPEN "ram.dat" FOR BINARY AS #1
     PRINT "Differences between previous and current RAM data are shown below"
     PRINT "Press any key to begin"
     WHILE INKEY$ = "": WEND
     CLS
     PRINT " RAM Address   Input #       Old #"
     LOCATE 1, 40: PRINT "Press ESC to exit"
     VIEW PRINT 3 TO 25
     b = -1
     FOR x = -32768 TO 32766
      GET #1, , z
      IF z <> INP(x + 32768) THEN PRINT x + 32768; "("; HEX$(x + 32768); ")", INP(x + 32768); "("; HEX$(INP(x + 32768)); ")", z; "("; HEX$(z); ")": b = b + 1
      IF b = 21 THEN
       LOCATE 12, 40: PRINT "End of screen"
       LOCATE 13, 40: PRINT "Hit any key to continue"
       DO
        a$ = INKEY$
       LOOP UNTIL a$ <> ""
       IF a$ = CHR$(27) THEN EXIT FOR
       LOCATE 12, 40: PRINT "             "
       LOCATE 13, 40: PRINT "                       "
       LOCATE 25
       b = 0
      END IF
      IF INKEY$ = CHR$(27) THEN EXIT FOR
     NEXT
     VIEW PRINT
     WHILE INKEY$ = "": WEND
    END IF
   CASE 6: IF a THEN KILL "ram.dat"
   END SELECT
   CLOSE
  LOOP UNTIL y = 7
 CASE 4
  ON ERROR GOTO ScreenError2
  SCREEN 9
  ON ERROR GOTO JoystickError
  LOCATE 17: PRINT "Hit <ESC> to exit"
  DO
   PSET (x, y), 0
   x = STICK(0)
   y = STICK(1)
   IF x > 255 THEN x = 255
   IF y > 255 THEN y = 255
   PSET (x, y), 15
   COLOR 15
   LOCATE 1, 50: PRINT "X ="; x; " "
   LOCATE 2, 50: PRINT "Y ="; y; " "
   IF STRIG(5) THEN COLOR 15 ELSE COLOR 8
   LOCATE 6, 50: PRINT "TRIGGER"
   IF STRIG(1) THEN COLOR 15 ELSE COLOR 8
   LOCATE 7, 50: PRINT "OTHER"
  LOOP UNTIL INKEY$ = CHR$(27)
  ON ERROR GOTO problem
 CASE 5
  SCREEN 12
  d = RND * 3 + 2
  DIM x(d), y(d), dir(d)
  FOR z = 0 TO d
   x(z) = RND * 639
   y(z) = RND * 479
   dir(z) = RND * 7
  NEXT
  x! = TIMER
  DO
   a = a + 1
  LOOP UNTIL TIMER - x! >= .5
  CLS
  WHILE INKEY$ <> "": WEND
  DO
   FOR b = 1 TO RND * 20 + 10
    FOR z = 0 TO d
     IF x(z) < 0 THEN dir(z) = 0
     IF x(z) > 639 THEN dir(z) = 4
     IF y(z) < 0 THEN dir(z) = 2
     IF y(z) > 479 THEN dir(z) = 6
     SELECT CASE dir(z)
     CASE 0: x(z) = x(z) + 2
     CASE 1: x(z) = x(z) + 2: y(z) = y(z) + 2
     CASE 2: y(z) = y(z) + 2
     CASE 3: x(z) = x(z) - 2: y(z) = y(z) + 2
     CASE 4: x(z) = x(z) - 2
     CASE 5: x(z) = x(z) - 2: y(z) = y(z) - 2
     CASE 6: y(z) = y(z) - 2
     CASE 7: x(z) = x(z) + 2: y(z) = y(z) - 2
     END SELECT
    NEXT
    FOR z = 0 TO d
     LINE (x(z), y(z))-(x((z + 1) MOD (d + 1)), y((z + 1) MOD (d + 1))), RND * 6 + 9
    NEXT
    FOR z = 0 TO d
     LINE (x(z), y(z))-(x((z + 1) MOD (d + 1)), y((z + 1) MOD (d + 1))), 0
    NEXT
    IF INKEY$ <> "" THEN EXIT DO
   NEXT
   dir(RND * d) = RND * 7
  LOOP
  ERASE x, y, dir
 CASE 6
  CLS
  PRINT "Press NumLock to exit"
  PRINT "Press any other key to see ASCII codes and string representation"
  DEF SEG = 0
  KeyFlag = PEEK(1047)
  POKE 1047, 0
  DEF SEG
  KEY 15, CHR$(0) + CHR$(69)
  ON KEY(15) GOSUB done
  KEY(15) ON
  a = 0
  DO
   kbd$ = INKEY$
   IF kbd$ <> "" THEN
    PRINT STR$(ASC(kbd$));
    IF LEN(kbd$) > 1 THEN PRINT "+"; LTRIM$(STR$(ASC(RIGHT$(kbd$, 1))));
    PRINT "  ", CHR$(34); kbd$; CHR$(34)
   END IF
  LOOP UNTIL a
 CASE 7
  CLS
  ON ERROR GOTO vga
  SCREEN 12
  Detect "VGA or better"
 CASE 8
  ON ERROR GOTO problem
  DO
   CLS
   PRINT "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
   PRINT "This is an experimental program."
   PRINT
   PRINT "A) Sum and average of several numbers"
   PRINT "B) Positive integral factors"
   PRINT "C) Least common denominator"
   PRINT "D) Graphing X and Y axis"
   PRINT "E) Circumference and area of a circle"
   PRINT "F) Subtraction"
   PRINT "G) Multiplication"
   PRINT "H) Division"
   PRINT "I) Segments between points"
   PRINT "Which program would you like to work with? (A-J, Z to quit)"
   DO
    kbd$ = UCASE$(INKEY$)
   LOOP UNTIL kbd$ >= "A" AND kbd$ <= "I" OR kbd$ = "Z"
   SELECT CASE kbd$
   CASE "A"
    PRINT "(To end, hit enter)"
    s! = 0
    c = -1
    DO
     c = c + 1
     INPUT "Number"; n!
     s! = s! + n!
    LOOP UNTIL n! = 0
    PRINT "Sum ="; s!
    IF c = 0 THEN PRINT "Average not calcuted" ELSE PRINT "Average ="; s! / c
   CASE "B"
    DO
     INPUT "Enter a positive integer >1:"; i
    LOOP UNTIL i > 1
    c = 0
    FOR f = 1 TO i
     q! = i / f
     IF q! = INT(q!) AND q! >= f THEN
      PRINT f; "and"; q!; "are factors of"; i
      c = c + 1
     ELSEIF q! < f THEN EXIT FOR
     END IF
    NEXT
    IF c < 2 THEN PRINT i; "is prime" ELSE PRINT i; "is composite"
   CASE "C"
    INPUT "Enter one denominator"; d1
    IF d1 > 0 THEN INPUT "Enter another denominator"; d2
    PRINT "Working. . . ."
    IF d1 > 0 AND d2 > 0 THEN
     a& = 0
     DO
      a& = a& + 1
     LOOP UNTIL a& / d1 = INT(a& / d1) AND a& / d2 = INT(a& / d2)
     PRINT "LCD("; LTRIM$(STR$(d1)); ","; STR$(d2); ") ="; a&
    END IF
   CASE "D"
    PRINT "This will plot a line on a graph using the linear equation P + Q = R"
    INPUT "P"; p!
    INPUT "Q"; q!
    INPUT "R"; r!
    PRINT
    IF p! = 0 THEN
     PRINT "The graph does not cross the X-axis"
     IF q! THEN PRINT "The graph crosses the Y-axis at"; r! / q!
    END IF
    IF q! THEN
     PRINT "The graph crosses the X-axis at"; r! / p!
     PRINT "The graph crosses the Y-axis at"; r! / q!
    ELSE
     PRINT "The graph does not cross the Y-axis"
     IF r THEN PRINT "The graph crosses the X-axis at"; p! / r!
    END IF
   CASE "E"
    pi! = 3.1415927#
    INPUT "Enter the radius of a circle:"; r!
    d! = 2 * r!
    c! = d! * pi!
    PRINT c!; "is the circumference of the circle"
    PRINT pi! * r! * r!; "is the area of the circle"
   CASE "F"
    INPUT "Enter a number:"; z!
    INPUT "Enter a second number:"; a!
    PRINT z! - a!; "is the difference"
   CASE "G"
    p! = 1
    f! = 1
    DO
     p! = f! * p!
     INPUT "Enter a factor (0 to quit):"; f!
    LOOP UNTIL f! = 0
    PRINT p!; "is the product."
   CASE "H"
    INPUT "Enter a dividend:"; x!
    INPUT "Enter a divisor:"; y!
    IF y! THEN PRINT x! / y!; " is the quotient." ELSE PRINT "Error: divide by 0"
   CASE "I"
    INPUT "Points"; a
    b = 0
    b = (a ^ 2 - a) / 2
    PRINT b; "possible segments could be drawn between"; a; "points"
   END SELECT
   PRINT "Done"
   IF kbd$ <> "Z" THEN WHILE INKEY$ = "": WEND
  LOOP UNTIL kbd$ = "Z"
 END SELECT
LOOP UNTIL mode = 9
CLS
END
problem:
 PRINT
 PRINT "Unexpected error"
 PRINT "Ending program"
 END
vga:
 ON ERROR GOTO mcga
 SCREEN 13
 Detect "MCGA"
mcga:
 ON ERROR GOTO ega64k:
 SCREEN 9, , 1, 1
 Detect "EGA 64K+"
ega64k:
 ON ERROR GOTO ega:
 SCREEN 9
 Detect "EGA < 64K"
ega:
 ON ERROR GOTO cga:
 SCREEN 1
 Detect "CGA"
cga:
 ON ERROR GOTO Hercules
 SCREEN 3
 Detect "Hercules"
Hercules:
 ON ERROR GOTO olivetti
 SCREEN 4
 Detect "Olivetti"
olivetti:
 PRINT "Neither VGA, MCGA, EGA, CGA, Hercules, or Olivetti detected"
 WHILE INKEY$ = "": WEND
 RUN
EndGame:
 FOR x = 15 TO 18
  KEY(x) OFF
 NEXT
 POKE 1047, KeyFlag
 SCREEN 0, 0, 0, 0
 COLOR 7, 0, 0
 CLS
 RUN
ScreenError:
 SCREEN 0
 PRINT "An MCGA monitor or better is required for this program"
 WHILE INKEY$ = "": WEND
 RUN
ScreenError2:
 PRINT "A VGA monitor or better is required for this program"
 WHILE INKEY$ = "": WEND
 RUN
done:
 a = 1
 DEF SEG = 0
 POKE 1047, KeyFlag
 DEF SEG
 RUN
FileError:
 a = a - b
 RESUME NEXT
JoystickError:
 SCREEN 0
 COLOR 7
 PRINT "Joystick A not detected"
 WHILE INKEY$ = "": WEND
 RUN

SUB Center (x, a$)
 LOCATE x, 40 - INT(LEN(a$) / 2)
 PRINT a$
END SUB

SUB Detect (a$)
 SCREEN 0
 PRINT "        Video card identifier"
 PRINT "        Chad Austin"
 PRINT "        12/28/95"
 PRINT
 PRINT "        "; a$; " detected"
 WHILE INKEY$ = "": WEND
END SUB

