ON ERROR GOTO unexpect
DO
 CLS
 COLOR 15
 PRINT "README.BAS"
 PRINT
 PRINT "1) Read README.TXT"
 PRINT "2) Print README.TXT"
 PRINT "3) Exit"
 PRINT
 PRINT "Choice: "
 DO
  a% = VAL(INKEY$)
 LOOP UNTIL a% > 0 AND a% < 4
 CLS
 SELECT CASE a%
  CASE 1
   b% = 0
   OPEN "readme.txt" FOR INPUT AS 1
   WHILE EOF(1) = 0
    LINE INPUT #1, a$
    PRINT a$
    b% = b% + 1
    IF b% = 22 THEN
     WHILE INKEY$ = ""
     WEND
     b% = 0
    END IF
   WEND
   CLOSE 1
   IF b% THEN
    WHILE INKEY$ = ""
    WEND
   END IF
  CASE 2
   OPEN "readme.txt" FOR INPUT AS 1
   WHILE EOF(1) = 0
    LINE INPUT #1, a$
    LPRINT a$
   WEND
   LPRINT CHR$(12)
 END SELECT
LOOP UNTIL a% = 3
CLS
COLOR 7
END
unexpect:
 CLS
 PRINT "Unexpected error"
 PRINT "Ending program"
 COLOR 7
 END

