'
'   Microsoft RemLine - Line Number Removal Utility
'   Copyright (C) Microsoft Corporation 1985-1990
'
'   REMLINE.BAS is a program to remove line numbers from Microsoft Basic
'   Programs. It removes only those line numbers that are not the object
'   of one of the following statements: GOSUB, RETURN, GOTO, THEN, ELSE,
'   RESUME, RESTORE, or RUN.
'
'   When REMLINE is run, it will ask for the name of the file to be
'   processed and the name of the file or device to receive the
'   reformatted output. If no extension is given, .BAS is assumed (except
'   for output devices). If filenames are not given, REMLINE prompts for
'   file names. If both filenames are the same, REMLINE saves the original
'   file with the extension .BAK.
'
'   REMLINE makes several assumptions about the program:
'
'     1. It must be correct syntactically, and must run in BASICA or
'        GW-BASIC interpreter.
'     2. There is a 400 line limit. To process larger files, change
'        MaxLines constant.
'     3. The first number encountered on a line is considered a line
'        number; thus some continuation lines (in a compiler-specific
'        construction) may not be handled correctly.
'     4. REMLINE can handle simple statements that test the ERL function
'        using relational operators such as =, <, and >. For example,
'        the following statement is handled correctly:
'
'             IF ERL = 100 THEN END
'
'        Line 100 is not removed from the source code. However, more
'        complex expressions that contain the +, -, AND, OR, XOR, EQV,
'        MOD, or IMP operators may not be handled correctly. For example,
'        in the following statement REMLINE does not recognize line 105
'        as a referenced line number and removes it from the source code:
'
'             IF ERL + 5 = 105 THEN END
'
'   If you do not like the way REMLINE formats its output, you can modify
'   the output lines in SUB GenOutFile. An example is shown in comments.
DEFINT A-Z

DECLARE FUNCTION GetToken$ (Search$, Delim$)
DECLARE FUNCTION StrSpn% (InString$, Separator$)
DECLARE FUNCTION StrBrk% (InString$, Separator$)
DECLARE FUNCTION IsDigit% (Char$)
DECLARE SUB GetFileNames ()
DECLARE SUB BuildTable ()
DECLARE SUB GenOutFile ()
DECLARE SUB InitKeyTable ()

CONST KeyWordCount = 9
CONST MaxLines = 2000

DIM SHARED LineTable!(MaxLines)
DIM SHARED LineCount
DIM SHARED Seps$, InputFile$, OutputFile$, TmpFile$
DIM SHARED KeyWordTable$(KeyWordCount)

KeyData: DATA THEN, ELSE, GOSUB, GOTO, RESUME, RETURN, RESTORE, RUN, ERL, ""

 Seps$ = " ,:=<>()" + CHR$(9)
 InitKeyTable
 GetFileNames
 ON ERROR GOTO FileErr1
 OPEN InputFile$ FOR INPUT AS 1
 ON ERROR GOTO 0
 COLOR 7: PRINT "Working"; : COLOR 23: PRINT " . . .": COLOR 7: PRINT
 BuildTable
 CLOSE #1
 OPEN InputFile$ FOR INPUT AS 1
 ON ERROR GOTO FileErr2
 OPEN OutputFile$ FOR OUTPUT AS 2
 ON ERROR GOTO 0
 GenOutFile
 CLOSE #1, #2
 IF OutputFile$ <> "CON" THEN CLS
 END

FileErr1:
 CLS
 PRINT "      Invalid file name": PRINT
 INPUT "      New input file name (ENTER to terminate): ", InputFile$
 IF InputFile$ = "" THEN END
FileErr2:
 INPUT "      Output file name (ENTER to print to screen) :", OutputFile$
 PRINT
 IF (OutputFile$ = "") THEN OutputFile$ = "CON"
 IF TmpFile$ = "" THEN RESUME ELSE TmpFile$ = ""
 RESUME NEXT

SUB BuildTable STATIC
 DO WHILE NOT EOF(1)
  LINE INPUT #1, InLin$
  Token$ = GetToken$(InLin$, Seps$)
  DO WHILE (Token$ <> "")
   FOR KeyIndex = 1 TO KeyWordCount
    IF (KeyWordTable$(KeyIndex) = UCASE$(Token$)) THEN
     Token$ = GetToken$("", Seps$)
     DO WHILE (IsDigit(LEFT$(Token$, 1)))
      LineCount = LineCount + 1
      LineTable!(LineCount) = VAL(Token$)
      Token$ = GetToken$("", Seps$)
      IF Token$ <> "" THEN KeyIndex = 0
     LOOP
    END IF
   NEXT
   Token$ = GetToken$("", Seps$)
  LOOP
 LOOP
END SUB

SUB GenOutFile STATIC
 Sep$ = " " + CHR$(9)
 DO WHILE NOT EOF(1)
  LINE INPUT #1, InLin$
  IF (InLin$ <> "") THEN
   Token$ = GetToken$(InLin$, Sep$)
   IF IsDigit(LEFT$(Token$, 1)) THEN
    LineNumber! = VAL(Token$)
    FoundNumber = 0
    FOR index = 1 TO LineCount
     IF (LineNumber! = LineTable!(index)) THEN FoundNumber = 1
    NEXT
    IF FoundNumber = 0 THEN
     Token$ = SPACE$(LEN(Token$))
     MID$(InLin$, StrSpn(InLin$, Sep$), LEN(Token$)) = Token$
    END IF
   END IF
  END IF
  IF OutputFile$ = "CON" THEN PRINT InLin$ ELSE PRINT #2, InLin$
 LOOP
END SUB

SUB GetFileNames STATIC
 CLS
 PRINT " Microsoft RemLine: Line Number Removal Utility"
 PRINT "       (.BAS assumed if no extension given)"
 PRINT
 INPUT "      Input file name (ENTER to terminate): ", InputFile$
 IF InputFile$ = "" THEN END
 INPUT "      Output file name (ENTER to print to screen): ", OutputFile$
 PRINT
 IF (OutputFile$ = "") THEN OutputFile$ = "CON"
 IF INSTR(InputFile$, ".") = 0 THEN InputFile$ = InputFile$ + ".BAS"
 IF INSTR(OutputFile$, ".") = 0 THEN
  SELECT CASE OutputFile$
   CASE "CON", "SCRN", "PRN", "COM1", "COM2", "LPT1", "LPT2", "LPT3": EXIT SUB
   CASE ELSE: OutputFile$ = OutputFile$ + ".BAS"
  END SELECT
 END IF
 DO WHILE InputFile$ = OutputFile$
  TmpFile$ = LEFT$(InputFile$, INSTR(InputFile$, ".")) + "BAK"
  ON ERROR GOTO FileErr1
  NAME InputFile$ AS TmpFile$
  ON ERROR GOTO 0
  IF TmpFile$ <> "" THEN InputFile$ = TmpFile$
 LOOP
END SUB

FUNCTION GetToken$ (Search$, Delim$) STATIC
 IF (Search$ <> "") THEN
  BegPos = 1
  SaveStr$ = Search$
 END IF
 NewPos = StrSpn(MID$(SaveStr$, BegPos, LEN(SaveStr$)), Delim$)
 IF NewPos THEN
  BegPos = NewPos + BegPos - 1
 ELSE
  GetToken$ = ""
  EXIT FUNCTION
 END IF
 NewPos = StrBrk(MID$(SaveStr$, BegPos, LEN(SaveStr$)), Delim$)
 IF NewPos THEN NewPos = BegPos + NewPos - 1 ELSE NewPos = LEN(SaveStr$) + 1
 GetToken$ = MID$(SaveStr$, BegPos, NewPos - BegPos)
 BegPos = NewPos
END FUNCTION

SUB InitKeyTable STATIC
 RESTORE KeyData
 FOR Count = 1 TO KeyWordCount
  READ KeyWord$
  KeyWordTable$(Count) = KeyWord$
 NEXT
END SUB

FUNCTION IsDigit (Char$) STATIC
 IF (Char$ = "") THEN
  IsDigit = 0
 ELSE
  CharAsc = ASC(Char$)
  IsDigit = (CharAsc >= ASC("0")) AND (CharAsc <= ASC("9"))
 END IF
END FUNCTION

FUNCTION StrBrk (InString$, Separator$) STATIC
 Ln = LEN(InString$)
 BegPos = 1
 DO WHILE INSTR(Separator$, MID$(InString$, BegPos, 1)) = 0
  IF BegPos > Ln THEN
   StrBrk = 0
   EXIT FUNCTION
  ELSE BegPos = BegPos + 1
  END IF
 LOOP
 StrBrk = BegPos
END FUNCTION

FUNCTION StrSpn% (InString$, Separator$) STATIC
 Ln = LEN(InString$)
 BegPos = 1
 DO WHILE INSTR(Separator$, MID$(InString$, BegPos, 1))
  IF BegPos > Ln THEN
   StrSpn = 0
   EXIT FUNCTION
  ELSE BegPos = BegPos + 1
  END IF
 LOOP
 StrSpn = BegPos
END FUNCTION

