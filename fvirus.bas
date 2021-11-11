DEFINT A-Z
DECLARE FUNCTION getint% (a$, d%)
DECLARE FUNCTION timer$ (x%)
DECLARE FUNCTION query$ (a$)
ON ERROR GOTO done
RANDOMIZE TIMER
CLS
PRINT "Fake Virus 1.3"
PRINT "Setup"
PRINT
hr = getint("Enter hours:   ", 99)
min = getint("Enter minutes: ", 59)
sec = getint("Enter seconds: ", 59)
PRINT
b$ = query("Lock up when completed? (Y/N)")
IF b$ = "Y" THEN
 PRINT
 PRINT "    If key event trapping is on, whenever ESC, CTRL+C, CTRL, or ENTER"
 PRINT "    is pressed, the computer will lock up.  Key event trapping will"
 PRINT "    not work if NUM-LOCK, CAPS-LOCK, or SCROLL-LOCK is on.  Some of"
 PRINT "    these may not work."
 PRINT
 d$ = query("Turn on key event trapping? (Y/N)")
 PRINT
 IF query("Turn NUM-LOCK, CAPS-LOCK, and SCROLL-LOCK off permanently? (Y/N)") = "Y" THEN
  DEF SEG = 0
  POKE 1047, 0
  DEF SEG
  KEY 19, CHR$(0) + CHR$(58)
  KEY 20, CHR$(0) + CHR$(69)
  KEY 21, CHR$(0) + CHR$(70)
  FOR x = 19 TO 21
   KEY(x) ON
  NEXT
  WHILE INKEY$ <> "": WEND
 END IF
END IF
PRINT
c$ = query("Make hard drive light flicker? (Y/N)")
PRINT
PRINT "    Program may not recognize itself correctly and may not delete itself."
PRINT
e$ = query("Delete program when done? (Y/N)")
PRINT
a$ = query("Play sound? (Y/N)")
IF a$ = "Y" THEN
 PRINT
 PRINT "    = set tone"
 PRINT "+-    = set duration"
 PRINT "T     = test"
 PRINT "Enter = done"
 PRINT
 x = CSRLIN
 IF x = 24 THEN
  PRINT
  x = 23
 END IF
 y = 1
 z = 64
 DO
  LOCATE x: PRINT USING "Tone: ##      Duration: 1/##"; y; z
  kbd$ = UCASE$(INKEY$)
  SELECT CASE kbd$
  CASE CHR$(0) + "H": IF y < 80 THEN y = y + 1
  CASE CHR$(0) + "P": IF y > 1 THEN y = y - 1
  CASE "=", "+": IF z < 64 THEN z = z + 1
  CASE "-", "_": IF z > 1 THEN z = z - 1
  CASE "T": PLAY "l" + STR$(z) + "n" + STR$(y)
  END SELECT
 LOOP UNTIL kbd$ = CHR$(13)
 PLAY "mbl" + STR$(z) + "n" + STR$(y)
END IF
IF d$ = "Y" THEN
 KEY 15, CHR$(0) + CHR$(1)
 KEY 16, CHR$(0) + CHR$(28)
 KEY 17, CHR$(0) + CHR$(29)
 KEY 18, CHR$(4) + CHR$(46)
 FOR x = 15 TO 18
  KEY(x) ON
  ON KEY(x) GOSUB done
 NEXT
END IF
ON TIMER(1) GOSUB checktime
TIMER ON
CLS
DO
 LOCATE 1
 PRINT "In "; timer$(hr); ":"; timer$(min); ":"; timer$(sec); ", the hard drive will be erased."
 WHILE INKEY$ <> "": WEND
LOOP UNTIL hr < 0
TIMER OFF
CLS
PRINT "Erasing FATs"
IF c$ = "Y" THEN OPEN "temp.dat" FOR BINARY AS #1
x! = TIMER
DO
 IF c$ = "Y" THEN PUT #1, , x#
LOOP UNTIL TIMER - x! >= 4
CLOSE
PRINT "FATs erased"
PRINT "Erasing configuration file"
x! = TIMER
DO
 IF c$ = "Y" THEN
  OPEN "temp.dat" FOR BINARY AS #1
  CLOSE #1
  KILL "temp.dat"
 END IF
LOOP UNTIL TIMER - x! >= 6
CLOSE
PRINT "Configuration file written over"
PRINT "Erasing DOS files and COMMAND.COM"
IF c$ = "Y" THEN OPEN "temp.dat" FOR OUTPUT AS #1
x! = TIMER
DO
 IF c$ = "Y" THEN PRINT #1, CHR$(RND * 255)
LOOP UNTIL TIMER - x! >= 5
CLOSE
y = 81
IF c$ = "Y" THEN KILL "temp.dat"
GOSUB done
checktime:
 sec = sec - 1
 IF sec = -1 THEN
  sec = 59
  min = min - 1
  IF min = -1 THEN
   min = 59
   hr = hr - 1
  END IF
 END IF
 IF a$ = "Y" THEN PLAY "n" + STR$(y)
RETURN
done:
 IF e$ = "Y" THEN
  IF g = 0 THEN
   g = 1
   DEF SEG = 0
   x = 5405
   a$ = ""
   DO
    x = x + 1
    a$ = a$ + CHR$(PEEK(x))
   LOOP UNTIL PEEK(x + 1) = 0
   DEF SEG
   OPEN a$ FOR INPUT AS #1
   z = LOF(1)
   CLOSE
   KILL a$
   PRINT a$
   OPEN a$ FOR OUTPUT AS #1
   FOR x = 1 TO z
    PRINT #1, CHR$(RND * 255);
   NEXT
  END IF
 END IF
 IF y = 81 THEN PRINT "Erasing completed"
 IF b$ = "Y" THEN
  DEF SEG = 0
  FOR x& = 0 TO 65535
   POKE x&, RND * 255
  NEXT
 ELSE DO: LOOP
 END IF

FUNCTION getint (a$, d)
 a = CSRLIN
 LOCATE a: PRINT a$ + "_ "
 DO
  DO: b$ = INKEY$: LOOP UNTIL b$ <> ""
  SELECT CASE b$
  CASE "0" TO "9": IF LEN(c$) < 2 THEN c$ = c$ + b$: IF VAL(c$) > d THEN c$ = LTRIM$(STR$(d))
  CASE CHR$(8): IF LEN(c$) THEN c$ = LEFT$(c$, LEN(c$) - 1)
  CASE CHR$(13), CHR$(27)
   IF b$ = CHR$(13) THEN e = VAL(c$)
   LOCATE a, 1 + LEN(a$) + LEN(c$): PRINT " "
   EXIT DO
  END SELECT
  LOCATE a, LEN(a$) + 1: PRINT c$ + "_  "
 LOOP
 getint = e
END FUNCTION

FUNCTION query$ (a$)
 PRINT a$;
 DO
  b$ = UCASE$(INKEY$)
 LOOP UNTIL b$ = "Y" OR b$ = "N"
 PRINT " "; b$
 query$ = b$
END FUNCTION

FUNCTION timer$ (x)
 a$ = LTRIM$(STR$(x))
 IF LEN(a$) = 1 THEN a$ = "0" + a$
 timer$ = a$
END FUNCTION

