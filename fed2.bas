DEFINT A-Z
DECLARE FUNCTION getstring$ (a$, z%)
DECLARE SUB getchar ()
ON ERROR GOTO unexpect
OPEN "com1" FOR OUTPUT AS #3
OPEN "com1" FOR INPUT AS #4
DIM SHARED nam AS STRING * 11
DIM SHARED var(1 TO 1)
getchar
END
unexpect:
 SELECT CASE ERR
  CASE 25
   PRINT "Modem not ready"
   WHILE INKEY$ = "": WEND
   RESUME
  CASE 53
   PRINT "You have not been identified"
   PRINT "Would you like to begin Federation II as "; RTRIM$(nam); "? (Y/N)"
   DO
    a$ = UCASE$(INKEY$)
   LOOP UNTIL a$ = "Y" OR a$ = "N"
   IF a$ = "Y" THEN var(1) = 1 ELSE var(1) = 0
   RESUME NEXT
  CASE ELSE
   PRINT "Unexpected error"
   PRINT "Ending program"
   END
 END SELECT

SUB getchar
 CLS
 VIEW PRINT 1 TO 25
 PRINT "Welcome to Federation II data space."
 DO
  DO
   nam = getstring("Your persona's name: ", 11)
   LOCATE CSRLIN - 1
  LOOP UNTIL RTRIM$(nam) <> ""
  PRINT
  var(1) = 2
  OPEN nam FOR INPUT AS #2
  IF var(1) = 1 THEN
   OPEN nam FOR OUTPUT AS #2
   var(1) = 2
  ELSEIF var(1) = 0 THEN PRINT "Try again"
  END IF
  CLOSE
 LOOP UNTIL var(1) = 2
END SUB

FUNCTION getstring$ (a$, z)
 y = CSRLIN
 IF y = 25 THEN PRINT : y = 24
 LOCATE y: PRINT a$; "_"; SPACE$(z)
 DO
  DO: c$ = INKEY$: LOOP UNTIL c$ <> ""
  SELECT CASE c$
  CASE " " TO ")", "+" TO ">", "@" TO "}": IF LEN(b$) < z THEN b$ = b$ + c$
  CASE CHR$(8), CHR$(0) + "K": IF LEN(b$) > 0 THEN b$ = LEFT$(b$, LEN(b$) - 1)
  CASE CHR$(13)
   LOCATE y, 1 + LEN(a$) + LEN(b$): PRINT " "
   EXIT DO
  END SELECT
  LOCATE y, 1 + LEN(a$): PRINT b$ + "_ "
 LOOP
 getstring$ = b$
END FUNCTION

