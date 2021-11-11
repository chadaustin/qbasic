DECLARE FUNCTION cut$ (x!)
CLS
FOR x = -10 TO 10
 FOR y = -10 TO 10

  'Convert <<EQUATION>> to the desired equation and the
  'program will execute properly.

  IF <<EQUATION>> THEN
   PRINT "("; cut$(x); ", "; cut$(y); ")"
  END IF
 NEXT
NEXT

FUNCTION cut$ (x)
  cut$ = LTRIM$(STR$(x))
END FUNCTION

