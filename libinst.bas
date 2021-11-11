DECLARE FUNCTION getstring$ (a%, b%, a$, c%)
CLS
PRINT "Library Installation Program"
PRINT "Chad Austin"
lib$ = getstring(4, 4, "Enter name of library file (.BAS assumed): ", 12)
IF RTRIM$(lib$) = "" THEN END
IF INSTR(lib$, ".") = 0 THEN lib$ = RTRIM$(lib$) + ".bas"
ON ERROR GOTO inputerror
OPEN lib$ FOR INPUT AS #1
prog$ = getstring(6, 4, "Enter name of program (.BAS assumed): ", 12)
IF RTRIM$(prog$) = "" THEN END
IF INSTR(prog$, ".") = 0 THEN prog$ = RTRIM$(prog$) + ".bas"
ON ERROR GOTO progerror
OPEN prog$ FOR APPEND AS #2
ON ERROR GOTO unexpect
LOCATE 8, 4: PRINT "Install comments? (Y/N) ";
DO
 kbd$ = UCASE$(INKEY$)
LOOP UNTIL kbd$ = "Y" OR kbd$ = "N"
PRINT kbd$
PRINT
PRINT "Working. . . ."
DO
 LINE INPUT #1, a$
 IF kbd$ = "N" THEN
  IF INSTR(a$, "'") THEN a$ = LEFT$(a$, INSTR(a$, "'") - 1)
  IF INSTR(UCASE$(a$), "REM") THEN a$ = LEFT$(a$, INSTR(UCASE$(a$), "REM") - 1)
 END IF
 PRINT #2, a$
LOOP UNTIL EOF(1)
PRINT
PRINT "Done."
CLOSE
END
inputerror:
 CLS
 PRINT "Error opening input file"
 lib$ = getstring(4, 4, "Enter new library file (.BAS assumed): ", 12)
 IF RTRIM$(lib$) = "" THEN END
 IF INSTR(lib$, ".") = 0 THEN lib$ = RTRIM$(lib$) + ".bas"
RESUME
progerror:
 CLS
 PRINT "Error opening output file"
 PRINT
 PRINT "Create new file? (Y/N) ";
 DO
  a$ = UCASE$(INKEY$)
 LOOP UNTIL a$ = "Y" OR a$ = "N"
 PRINT a$
 ON ERROR GOTO unexpect
 IF RTRIM$(LEFT$(prog$, INSTR(prog$, ".") - 1)) = "" THEN GOSUB unexpect
 IF a$ = "Y" THEN
  OPEN prog$ FOR OUTPUT AS #2
 ELSE END
 END IF
 CLOSE
RESUME
unexpect:
 CLS
 PRINT "Unexpected error"
 END

DEFINT A-Z
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

