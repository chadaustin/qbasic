'
'                        Library of Common Functions
'                                Chad Austin
'                                  2-22-96
'
'   This is a list of common functions and subprograms that can be used from
'within any program.  You are free to distribute these and/or edit them to
'suit your own needs.  Press F2 and view the actual function/sub for a
'complete description.  A list of examples is below.

DECLARE FUNCTION cut$ (x%)
DECLARE FUNCTION getint% (a%, b%, a$, c%, d%)
DECLARE FUNCTION getstring$ (a%, b%, a$, c%)
DECLARE FUNCTION query$ (a%, b%, a$)
DECLARE SUB box (y1%, x1%, y2%, x2%, z%)
DECLARE SUB center (x%, a$)
DECLARE SUB message (x%, y%, a$)
DECLARE SUB rest (x!)

'Examples:
'NumPlayers = getint(2, 25, "Enter number of players (1-4): ", 1, 4)
'PRINT "Number of Players: "; cut$(NumPlayers)
'nam$ = getstring(4, 25, "What is your name? ", 10)
'box 6, 29, 8, 58, 0
'new$ = query(7, 30, "Are you new at this? (Y/N)")
'center 10, "This is centered text."
'message 12, 20, "This message will be here until you press a key."
'PRINT "Waiting 2.5 seconds.": rest 2.5

DEFINT A-Z
'
'Draws a text box on the screen.
'
'   y1 = beginning row
'   x1 = beginning column
'   y2 = ending row
'   x2 = ending column
'   z = if true (nonzero) then box has two lines, if false (zero) then box
'       has one.
'
SUB box (y1, x1, y2, x2, z)
 IF y1 < y2 AND x1 < x2 THEN
  x = x2 - x1
  LOCATE y1, x1
  IF z THEN PRINT CHR$(201); STRING$(x - 1, 205); CHR$(187) ELSE PRINT CHR$(218); STRING$(x - 1, 196); CHR$(191)
  FOR y = y1 + 1 TO y2 - 1
   LOCATE y, x1
   IF z THEN PRINT CHR$(186); SPACE$(x - 1); CHR$(186) ELSE PRINT CHR$(179); SPACE$(x - 1); CHR$(179)
  NEXT
  LOCATE y2, x1
  IF z THEN PRINT CHR$(200); STRING$(x - 1, 205); CHR$(188) ELSE PRINT CHR$(192); STRING$(x - 1, 196); CHR$(217)
 END IF
END SUB

'
'Centers text on screen.
'
'   x = row that a$ is printed on
'   a$ = printed string
'
SUB center (x, a$)
 LOCATE x, 41 - LEN(a$) / 2 + .5
 PRINT a$
END SUB

'
'Eliminates leading or trailing spaces from an integer and converts it into a
'   string.
'
'   x = integer to convert
'
FUNCTION cut$ (x)
 cut$ = LTRIM$(STR$(x))
END FUNCTION

'
'Gets an integer from user.
'
'   a = row to print prompt on
'   b = column to print prompt on
'   a$ = actual prompt
'   c = lowest possible value
'   d = highest possible value
'
FUNCTION getint (a, b, a$, c, d)
 LOCATE a, b: PRINT a$ + "_"; SPACE$(LEN(STR$(hi)) - 1)
 DO
  DO: b$ = INKEY$: LOOP UNTIL b$ <> ""
  SELECT CASE b$
  CASE "0" TO "9"
   IF LEN(c$) < LEN(STR$(d)) - 1 THEN
    IF b$ <> "0" OR LEN(c$) THEN
     c$ = c$ + b$
     IF VAL(c$) > d THEN c$ = LTRIM$(STR$(d))
    END IF
   END IF
  CASE CHR$(8): IF LEN(c$) > 0 THEN c$ = LEFT$(c$, LEN(c$) - 1)
  CASE CHR$(13)
   num = VAL(c$)
   IF num >= c AND num <= d THEN
    LOCATE a, b + LEN(a$) + LEN(c$): PRINT " "
    EXIT DO
   END IF
   c$ = ""
  END SELECT
  LOCATE a, b + LEN(a$): PRINT c$ + "_ "; SPACE$(LEN(STR$(hi)) - 1)
 LOOP
 getint = num
END FUNCTION

'
'Gets string from user
'
'   a = row to print prompt on
'   b = column to print prompt on
'   a$ = actual prompt
'   c = maximum length of string
'
FUNCTION getstring$ (a, b, a$, c)
 LOCATE a, b: PRINT a$ + "_ "
 DO
  DO: b$ = INKEY$: LOOP UNTIL b$ <> ""
  SELECT CASE b$
  CASE " " TO "}": IF LEN(c$) < c THEN c$ = c$ + b$
  CASE CHR$(8), CHR$(0) + "K": IF LEN(c$) > 0 THEN c$ = LEFT$(c$, LEN(c$) - 1)
  CASE CHR$(13)
   LOCATE a, b + LEN(a$) + LEN(c$): PRINT " "
   EXIT DO
  END SELECT
  LOCATE a, b + LEN(a$): PRINT c$ + "_ "
 LOOP
 getstring$ = c$
END FUNCTION

'
'Prints message on screen until key is pressed.  Then it is erased.
'
'   x = message appears on this row
'   y = message appears on this column
'   a$ = actual message
'
SUB message (x, y, a$)
 LOCATE x, y: PRINT a$
 WHILE INKEY$ = "": WEND
 LOCATE x, y: PRINT SPACE$(LEN(a$))
END SUB

'
'Returns one-character answer to Yes/No question.
'
'   a = row to print text on
'   b = column to print text on
'   a$ = actual prompt
'
FUNCTION query$ (a, b, a$)
 LOCATE a, b: PRINT a$
 WHILE b$ <> "Y" AND b$ <> "N"
  b$ = UCASE$(INKEY$)
 WEND
 LOCATE a, b + LEN(a$) + 1: PRINT b$
 query$ = b$
END FUNCTION

'
'Suspends execution of a program for x! seconds.
'
'   x! = number of seconds to stop program execution for
'
SUB rest (x!)
 y! = TIMER
 DO: LOOP UNTIL TIMER - y! > x!
END SUB

