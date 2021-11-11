'
'                    Q B a s i c   M O N E Y   M A N A G E R
'
'                   Copyright (C) Microsoft Corporation 1990
'
' The Money Manager is a personal finance manager that allows you
' to enter account transactions while tracking your account balances
' and net worth.
'
' To run this program, press Shift+F5.
'
' To exit QBasic, press Alt, F, X.
'
' To get help on a BASIC keyword, move the cursor to the keyword and press
' F1 or click the right mouse button.
'


DEFINT A-Z

DECLARE SUB TransactionSummary (item%)
DECLARE SUB LCenter (text$)
DECLARE SUB ScrollUp ()
DECLARE SUB ScrollDown ()
DECLARE SUB Initialize ()
DECLARE SUB Intro ()
DECLARE SUB SparklePause ()
DECLARE SUB Center (row%, text$)
DECLARE SUB FancyCls (dots%, Background%)
DECLARE SUB LoadState ()
DECLARE SUB SaveState ()
DECLARE SUB MenuSystem ()
DECLARE SUB MakeBackup ()
DECLARE SUB RestoreBackup ()
DECLARE SUB Box (Row1%, Col1%, Row2%, Col2%)
DECLARE SUB NetWorthReport ()
DECLARE SUB EditAccounts ()
DECLARE SUB PrintHelpLine (help$)
DECLARE SUB EditTrans (item%)
DECLARE FUNCTION Cvdt$ (x#)
DECLARE FUNCTION Cvst$ (x!)
DECLARE FUNCTION Cvit$ (x%)
DECLARE FUNCTION Menu% (CurrChoiceX%, MaxChoice%, choice$(), ItemRow%(), ItemCol%(), help$(), BarMode%)
DECLARE FUNCTION GetString$ (row%, col%, start$, end$, Vis%, Max%)
DECLARE FUNCTION Trim$ (x$)

TYPE AccountType
 Title        AS STRING * 20
 AType        AS STRING * 1
 Desc         AS STRING * 50
END TYPE

TYPE Recordtype
 Date     AS STRING * 8
 Ref      AS STRING * 10
 Desc     AS STRING * 50
 Fig1     AS DOUBLE
 Fig2     AS DOUBLE
END TYPE

DIM SHARED account(1 TO 19)  AS AccountType
DIM SHARED ColorPref
DIM SHARED colors(0 TO 20, 1 TO 4)
DIM SHARED ScrollUpAsm(1 TO 7)
DIM SHARED ScrollDownAsm(1 TO 7)
DIM SHARED PrintErr AS INTEGER

 DEF SEG = 0
 KeyFlags = PEEK(1047)
 POKE 1047, &H0
 DEF SEG
 
 ON ERROR GOTO ErrorTrap
 OPEN "money.dat" FOR INPUT AS #1
 CLOSE
 ON ERROR GOTO 0

 Initialize
 Intro
 MenuSystem
 COLOR 7, 0
 CLS

 DEF SEG = 0
 POKE 1047, KeyFlags
 DEF SEG

 END

ErrorTrap:
 SELECT CASE ERR
  CASE 53
   CLOSE
   ColorPref = 1
   FOR a = 1 TO 19
    account(a).Title = ""
    account(a).AType = ""
    account(a).Desc = ""
   NEXT
   SaveState
   RESUME
  CASE 24, 25
   PrintErr = 1
   Box 8, 13, 14, 69
   Center 11, "Printer not responding ... Press Space to continue"
   WHILE INKEY$ <> "": WEND
   WHILE INKEY$ <> " ": WEND
   RESUME NEXT
 END SELECT
RESUME NEXT

DATA 0,7,15,7,0,7,0,15,0,0
DATA 1,9,12,3,0,1,15,0,7,0
DATA 3,15,13,1,14,3,15,0,7,0
DATA 0,12,15,4,14,0,15,15,1,0

DATA 184,1,6,185,1,4,186,78,22,183,0,205,16,203
DATA 184,1,7,185,1,4,186,78,22,183,0,205,16,203

SUB Box (Row1, Col1, Row2, Col2) STATIC
 BoxWidth = Col2 - Col1 + 1
 LOCATE Row1, Col1
 PRINT "Ú"; STRING$(BoxWidth - 2, "Ä"); "¿";
 FOR a = Row1 + 1 TO Row2 - 1
  LOCATE a, Col1
  PRINT "³"; SPACE$(BoxWidth - 2); "³";
 NEXT
 LOCATE Row2, Col1
 PRINT "À"; STRING$(BoxWidth - 2, "Ä"); "Ù";
END SUB

SUB Center (row, text$)
 LOCATE row, 41 - LEN(text$) / 2
 PRINT text$;
END SUB

FUNCTION Cvdt$ (x#)
 Cvdt$ = RIGHT$(STR$(x#), LEN(STR$(x#)) - 1)
END FUNCTION

FUNCTION Cvit$ (x)
 Cvit$ = RIGHT$(STR$(x), LEN(STR$(x)) - 1)
END FUNCTION

FUNCTION Cvst$ (x!)
 Cvst$ = RIGHT$(STR$(x!), LEN(STR$(x!)) - 1)
END FUNCTION

SUB EditAccounts
 REDIM help$(4), col(4), Vis(4), Max(4), edit$(19, 3)
 COLOR colors(7, ColorPref), colors(4, ColorPref)
 Box 2, 1, 24, 80
 COLOR colors(5, ColorPref), colors(4, ColorPref)
 LOCATE 1, 1: PRINT SPACE$(80)
 LOCATE 1, 4: PRINT "Account Editor";
 COLOR colors(7, ColorPref), colors(4, ColorPref)
 LOCATE 3, 2: PRINT "No³ Account Title      ³ Description                                      ³A/L"
 LOCATE 4, 2: PRINT "ÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄ"
 u$ = "##³\                  \³\                                                \³ ! "
 FOR a = 5 TO 23
  LOCATE a, 2
  x = a - 4
  PRINT USING u$; x; account(x).Title; account(x).Desc; account(x).AType;
 NEXT
 help$(1) = "  Account name                             | <F2=Save and Exit> <Escape=Abort>"
 help$(2) = "  Account description                      | <F2=Save and Exit> <Escape=Abort>"
 help$(3) = "  Account type (A = Asset, L = Liability)  | <F2=Save and Exit> <Escape=Abort>"
 col(1) = 5: col(2) = 26: col(3) = 78
 Vis(1) = 20: Vis(2) = 50: Vis(3) = 1
 Max(1) = 20: Max(2) = 50: Max(3) = 1
 FOR a = 1 TO 19
  edit$(a, 1) = account(a).Title
  edit$(a, 2) = account(a).Desc
  edit$(a, 3) = account(a).AType
 NEXT
 finished = 0
 CurrRow = 1
 CurrCol = 1
 PrintHelpLine help$(CurrCol)
 DO
  COLOR colors(8, ColorPref), colors(9, ColorPref)
  LOCATE CurrRow + 4, col(CurrCol)
  PRINT LEFT$(edit$(CurrRow, CurrCol), Vis(CurrCol));
  DO
   Kbd$ = INKEY$
  LOOP UNTIL Kbd$ <> ""
  IF Kbd$ >= " " AND Kbd$ < "~" THEN
   COLOR colors(8, ColorPref), colors(9, ColorPref)
   ok = 0
   start$ = Kbd$
   DO
    Kbd$ = GetString$(CurrRow + 4, col(CurrCol), start$, end$, Vis(CurrCol), Max(CurrCol))
    edit$(CurrRow, CurrCol) = LEFT$(end$ + SPACE$(Max(CurrCol)), Max(CurrCol))
    start$ = ""
    IF CurrCol = 3 THEN
     x$ = UCASE$(end$)
     IF x$ = "A" OR x$ = "L" OR x$ = "" OR x$ = " " THEN
      ok = 1
      IF x$ = "" THEN x$ = " "
      edit$(CurrRow, CurrCol) = x$
     ELSE : BEEP
     END IF
    ELSE ok = 1
    END IF
   LOOP UNTIL ok
  END IF
  COLOR colors(7, ColorPref), colors(4, ColorPref)
  LOCATE CurrRow + 4, col(CurrCol)
  PRINT LEFT$(edit$(CurrRow, CurrCol), Vis(CurrCol));
  SELECT CASE Kbd$
   CASE CHR$(0) + "H": CurrRow = (CurrRow + 17) MOD 19 + 1
   CASE CHR$(0) + "P": CurrRow = (CurrRow) MOD 19 + 1
   CASE CHR$(0) + "K", CHR$(0) + CHR$(15)
    CurrCol = (CurrCol + 1) MOD 3 + 1
    PrintHelpLine help$(CurrCol)
   CASE CHR$(0) + "M", CHR$(9)
    CurrCol = (CurrCol) MOD 3 + 1
    PrintHelpLine help$(CurrCol)
   CASE CHR$(0) + "<": finished = 1: Save = 1
   CASE CHR$(27): finished = 1: Save = 0
   CASE CHR$(13)
   CASE ELSE: BEEP
  END SELECT
 LOOP UNTIL finished
 IF Save THEN
  FOR a = 1 TO 19
   account(a).Title = edit$(a, 1)
   account(a).Desc = edit$(a, 2)
   account(a).AType = edit$(a, 3)
  NEXT
  SaveState
 END IF
END SUB

SUB EditTrans (item)
 REDIM help$(6), col(6), Vis(6), Max(6), CurrString$(3), CurrFig#(5)
 REDIM Balance#(1000)
 file$ = "money." + Cvit$(item)
 OPEN file$ FOR RANDOM AS #1 LEN = 84
 FIELD #1, 8 AS IoDate$, 10 AS IoRef$, 50 AS IoDesc$, 8 AS IoFig1$, 8 AS IoFig2$
 FIELD #1, 11 AS valid$, 5 AS IoMaxRecord$, 8 AS IoBalance$
 CurrString$(1) = ""
 CurrString$(2) = ""
 CurrString$(3) = ""
 CurrFig#(4) = 0
 CurrFig#(5) = 0
 GET #1, 1
 IF valid$ <> "THISISVALID" THEN
  LSET IoDate$ = ""
  LSET IoRef$ = ""
  LSET IoDesc$ = ""
  LSET IoFig1$ = MKD$(0)
  LSET IoFig2$ = MKD$(0)
  PUT #1, 2
  LSET valid$ = "THISISVALID"
  LSET IoMaxRecord$ = "1"
  LSET IoBalance$ = MKD$(0)
  PUT #1, 1
 END IF
 MaxRecord = VAL(IoMaxRecord$)
 Balance#(0) = 0
 a = 1
 WHILE a <= MaxRecord
  GET #1, a + 1
  Balance#(a) = Balance#(a - 1) + CVD(IoFig1$) - CVD(IoFig2$)
  a = a + 1
 WEND
 GOSUB EditTransWriteBalance
 help$(1) = "Date of transaction (mm/dd/yy) "
 help$(2) = "Transaction reference number   "
 help$(3) = "Transaction description        "
 help$(4) = "Increase asset or debt value   "
 help$(5) = "Decrease asset or debt value   "
 col(1) = 2
 col(2) = 11
 col(3) = 18
 col(4) = 44
 col(5) = 55
 Vis(1) = 8
 Vis(2) = 6
 Vis(3) = 25
 Vis(4) = 10
 Vis(5) = 10
 Max(1) = 8
 Max(2) = 6
 Max(3) = 25
 Max(4) = 10
 Max(5) = 10
 COLOR colors(7, ColorPref), colors(4, ColorPref)
 Box 2, 1, 24, 80
 COLOR colors(5, ColorPref), colors(4, ColorPref)
 LOCATE 1, 1: PRINT SPACE$(80);
 LOCATE 1, 4: PRINT "Transaction Editor: " + Trim$(account(item).Title);
 COLOR colors(7, ColorPref), colors(4, ColorPref)
 LOCATE 3, 2: PRINT "  Date  ³ Ref# ³ Description             ³ Increase ³ Decrease ³   Balance    "
 LOCATE 4, 2: PRINT "ÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
 u$ = "\      \³\    \³\                       \³"
 u1$ = "        ³      ³                         ³          ³          ³              "
 u1x$ = "ßßßßßßßß³ßßßßßß³ßßßßßßßßßßßßßßßßßßßßßßßßß³ßßßßßßßßßß³ßßßßßßßßßß³ßßßßßßßßßßßßßß"
 u2$ = "###,###.##"
 u3$ = "###,###,###.##"
 u4$ = "          "
 CurrTopline = 1
 GOSUB EditTransPrintWholeScreen
 CurrRow = 1
 CurrCol = 1
 PrintHelpLine help$(CurrCol) + "|  <F2=Save and Exit> <F9=Insert> <F10=Delete>"
 GOSUB EditTransGetLine
 finished = 0
 DO
  COLOR colors(8, ColorPref), colors(9, ColorPref)
  LOCATE CurrRow + 4, col(CurrCol)
  SELECT CASE CurrCol
   CASE 1, 2, 3: PRINT LEFT$(CurrString$(CurrCol), Vis(CurrCol));
   CASE 4: IF CurrFig#(4) <> 0 THEN PRINT USING u2$; CurrFig#(4);  ELSE PRINT SPACE$(Vis(CurrCol));
   CASE 5: IF CurrFig#(5) <> 0 THEN PRINT USING u2$; CurrFig#(5);  ELSE PRINT SPACE$(Vis(CurrCol));
  END SELECT
  DO: Kbd$ = INKEY$: LOOP UNTIL Kbd$ <> ""
  COLOR colors(7, ColorPref), colors(4, ColorPref)
  LOCATE CurrRow + 4, col(CurrCol)
  SELECT CASE CurrCol
  CASE 1, 2, 3: PRINT LEFT$(CurrString$(CurrCol), Vis(CurrCol));
  CASE 4: IF CurrFig#(4) <> 0 THEN PRINT USING u2$; CurrFig#(4);  ELSE PRINT SPACE$(Vis(CurrCol));
  CASE 5: IF CurrFig#(5) <> 0 THEN PRINT USING u2$; CurrFig#(5);  ELSE PRINT SPACE$(Vis(CurrCol));
  END SELECT
  IF Kbd$ >= " " AND Kbd$ < "~" OR Kbd$ = CHR$(8) THEN
   CurrRecord = CurrTopline + CurrRow - 1
   COLOR colors(8, ColorPref), colors(9, ColorPref)
   SELECT CASE CurrCol
    CASE 1, 2, 3
     Kbd$ = GetString$(CurrRow + 4, col(CurrCol), Kbd$, new$, Vis(CurrCol), Max(CurrCol))
     CurrString$(CurrCol) = new$
     GOSUB EditTransPutLine
     GOSUB EditTransGetLine
    CASE 4
     start$ = Kbd$
     DO
      Kbd$ = GetString$(CurrRow + 4, col(4), start$, new$, Vis(4), Max(4))
      new4# = VAL(new$)
      start$ = ""
     LOOP WHILE new4# >= 999999.99# OR new4# < 0
     a = CurrRecord
     WHILE a <= MaxRecord
      Balance#(a) = Balance#(a) + new4# - CurrFig#(4) + CurrFig#(5)
      a = a + 1
     WEND
     CurrFig#(4) = new4#
     CurrFig#(5) = 0
     GOSUB EditTransPutLine
     GOSUB EditTransGetLine
     GOSUB EditTransPrintBalances
     GOSUB EditTransWriteBalance
    CASE 5
     start$ = Kbd$
     DO
      Kbd$ = GetString$(CurrRow + 4, col(5), start$, new$, Vis(5), Max(5))
      new5# = VAL(new$)
      start$ = ""
     LOOP WHILE new5# >= 999999.99# OR new5# < 0
     a = CurrRecord
     WHILE a <= MaxRecord
      Balance#(a) = Balance#(a) - new5# + CurrFig#(5) - CurrFig#(4)
      a = a + 1
     WEND
     CurrFig#(4) = 0
     CurrFig#(5) = new5#
     GOSUB EditTransPutLine
     GOSUB EditTransGetLine
     GOSUB EditTransPrintBalances
     GOSUB EditTransWriteBalance
   END SELECT
   GOSUB EditTransPrintLine
  END IF
  SELECT CASE Kbd$
   CASE CHR$(0) + "H": GOSUB EditTransMoveUp
   CASE CHR$(0) + "P"
    IF (CurrRow + CurrTopline - 1) >= MaxRecord THEN
     BEEP
    ELSE
     IF CurrRow = 19 THEN
      ScrollUp
      CurrTopline = CurrTopline + 1
      GOSUB EditTransGetLine
      GOSUB EditTransPrintLine
     ELSE
      CurrRow = CurrRow + 1
      GOSUB EditTransGetLine
     END IF
    END IF
   CASE CHR$(0) + "K", CHR$(0) + CHR$(15)
    CurrCol = (CurrCol + 3) MOD 5 + 1
    PrintHelpLine help$(CurrCol) + "|  <F2=Save and Exit> <F9=Insert> <F10=Delete>"
   CASE CHR$(0) + "M", CHR$(9)
    CurrCol = (CurrCol) MOD 5 + 1
    PrintHelpLine help$(CurrCol) + "|  <F2=Save and Exit> <F9=Insert> <F10=Delete>"
   CASE CHR$(0) + "G": CurrCol = 1
   CASE CHR$(0) + "O": CurrCol = 5
   CASE CHR$(0) + "I"
    CurrRow = 1
    CurrTopline = CurrTopline - 19
    IF CurrTopline < 1 THEN CurrTopline = 1
    GOSUB EditTransPrintWholeScreen
    GOSUB EditTransGetLine
    CASE CHR$(0) + "Q"
    CurrRow = 1
    CurrTopline = CurrTopline + 19
    IF CurrTopline > MaxRecord THEN CurrTopline = MaxRecord
    GOSUB EditTransPrintWholeScreen
    GOSUB EditTransGetLine
   CASE CHR$(0) + "<": finished = 1
   CASE CHR$(0) + "C"
    CurrRecord = CurrTopline + CurrRow - 1
    a = MaxRecord
    WHILE a > CurrRecord
     GET #1, a + 1
     PUT #1, a + 2
     Balance#(a + 1) = Balance#(a)
     a = a - 1
    WEND
    Balance#(CurrRecord + 1) = Balance#(CurrRecord)
    MaxRecord = MaxRecord + 1
    LSET IoDate$ = ""
    LSET IoRef$ = ""
    LSET IoDesc$ = ""
    LSET IoFig1$ = MKD$(0)
    LSET IoFig2$ = MKD$(0)
    PUT #1, CurrRecord + 2
    LSET valid$ = "THISISVALID"
    LSET IoMaxRecord$ = Cvit$(MaxRecord)
    PUT #1, 1
    GOSUB EditTransPrintWholeScreen
    GOSUB EditTransGetLine
   CASE CHR$(0) + "D"
    IF MaxRecord = 1 THEN
     BEEP
    ELSE
     CurrRecord = CurrTopline + CurrRow - 1
     MaxRecord = MaxRecord - 1
     a = CurrRecord
     WHILE a <= MaxRecord
      GET #1, a + 2
      PUT #1, a + 1
      Balance#(a) = Balance#(a + 1) - CurrFig#(4) + CurrFig#(5)
      a = a + 1
     WEND
     LSET valid$ = "THISISVALID"
     LSET IoMaxRecord$ = Cvit$(MaxRecord)
     PUT #1, 1
     GOSUB EditTransPrintWholeScreen
     CurrRecord = CurrTopline + CurrRow - 1
     IF CurrRecord > MaxRecord THEN GOSUB EditTransMoveUp
     GOSUB EditTransGetLine
     GOSUB EditTransWriteBalance
    END IF
   CASE ELSE: BEEP
  END SELECT
 LOOP UNTIL finished
 CLOSE
 EXIT SUB

EditTransMoveUp:
 IF CurrRow = 1 THEN
  IF CurrTopline = 1 THEN
   BEEP
  ELSE
   ScrollDown
   CurrTopline = CurrTopline - 1
   GOSUB EditTransGetLine
   GOSUB EditTransPrintLine
  END IF
 ELSE
  CurrRow = CurrRow - 1
  GOSUB EditTransGetLine
 END IF
 RETURN

EditTransPrintLine:
 COLOR colors(7, ColorPref), colors(4, ColorPref)
 CurrRecord = CurrTopline + CurrRow - 1
 LOCATE CurrRow + 4, 2
 IF CurrRecord = MaxRecord + 1 THEN
  PRINT u1x$;
 ELSEIF CurrRecord > MaxRecord THEN PRINT u1$;
 ELSE
  PRINT USING u$; CurrString$(1); CurrString$(2); CurrString$(3);
  IF CurrFig#(4) = 0 AND CurrFig#(5) = 0 THEN
   PRINT USING u4$ + "³" + u4$ + "³" + u3$; Balance#(CurrRecord)
  ELSEIF CurrFig#(5) = 0 THEN PRINT USING u2$ + "³" + u4$ + "³" + u3$; CurrFig#(4); Balance#(CurrRecord)
  ELSE
   PRINT USING u4$ + "³" + u2$ + "³" + u3$; CurrFig#(5); Balance#(CurrRecord)
  END IF
 END IF
 RETURN

EditTransPrintBalances:
 COLOR colors(7, ColorPref), colors(4, ColorPref)
 FOR a = 1 TO 19
  CurrRecord = CurrTopline + a - 1
  IF CurrRecord <= MaxRecord THEN
   LOCATE 4 + a, 66
   PRINT USING u3$; Balance#(CurrTopline + a - 1);
  END IF
 NEXT
 RETURN

EditTransPrintWholeScreen:
 temp = CurrRow
 FOR CurrRow = 1 TO 19
  CurrRecord = CurrTopline + CurrRow - 1
  IF CurrRecord <= MaxRecord THEN GOSUB EditTransGetLine
  GOSUB EditTransPrintLine
 NEXT
 CurrRow = temp
 RETURN

EditTransWriteBalance:
 GET #1, 1
 LSET IoBalance$ = MKD$(Balance#(MaxRecord))
 PUT #1, 1
 RETURN

EditTransPutLine:
 CurrRecord = CurrTopline + CurrRow - 1
 LSET IoDate$ = CurrString$(1)
 LSET IoRef$ = CurrString$(2)
 LSET IoDesc$ = CurrString$(3)
 LSET IoFig1$ = MKD$(CurrFig#(4))
 LSET IoFig2$ = MKD$(CurrFig#(5))
 PUT #1, CurrRecord + 1
 RETURN

EditTransGetLine:
 CurrRecord = CurrTopline + CurrRow - 1
 GET #1, CurrRecord + 1
 CurrString$(1) = IoDate$
 CurrString$(2) = IoRef$
 CurrString$(3) = IoDesc$
 CurrFig#(4) = CVD(IoFig1$)
 CurrFig#(5) = CVD(IoFig2$)
 RETURN
END SUB

SUB FancyCls (dots, Background)
 VIEW PRINT 2 TO 24
 COLOR dots, Background
 CLS 2
 FOR a = 95 TO 1820 STEP 45
  row = a / 80 + 1
  col = a MOD 80 + 1
  LOCATE row, col
  PRINT CHR$(250);
 NEXT
 VIEW PRINT
END SUB

FUNCTION GetString$ (row, col, start$, end$, Vis, Max)
 curr$ = Trim$(LEFT$(start$, Max))
 IF curr$ = CHR$(8) THEN curr$ = ""
 LOCATE , , 1
 finished = 0
 DO
  LOCATE row, col
  IF LEN(curr$) > Vis THEN
   PRINT RIGHT$(curr$, Vis);
  ELSE
   PRINT curr$; SPACE$(Vis - LEN(curr$));
   LOCATE row, col + LEN(curr$)
  END IF
  Kbd$ = ""
  WHILE Kbd$ = ""
   Kbd$ = INKEY$
  WEND
  IF LEN(Kbd$) > 1 THEN
   finished = 1
   GetString$ = Kbd$
  ELSE
   SELECT CASE Kbd$
    CASE CHR$(13), CHR$(27), CHR$(9)
     finished = 1
     GetString$ = Kbd$
    CASE CHR$(8): IF curr$ <> "" THEN curr$ = LEFT$(curr$, LEN(curr$) - 1)
    CASE " " TO "}": IF LEN(curr$) < Max THEN curr$ = curr$ + Kbd$ ELSE BEEP
    CASE ELSE: BEEP
   END SELECT
  END IF
 LOOP UNTIL finished
 end$ = curr$
 LOCATE , , 0
END FUNCTION

SUB Initialize
 WIDTH , 25
 VIEW PRINT
 FOR ColorSet = 1 TO 4
  FOR x = 1 TO 10
   READ colors(x, ColorSet)
  NEXT
 NEXT
 LoadState
 P = VARPTR(ScrollUpAsm(1))
 DEF SEG = VARSEG(ScrollUpAsm(1))
 FOR I = 0 TO 13
  READ J
  POKE (P + I), J
 NEXT
 P = VARPTR(ScrollDownAsm(1))
 DEF SEG = VARSEG(ScrollDownAsm(1))
 FOR I = 0 TO 13
  READ J
  POKE (P + I), J
 NEXT
 DEF SEG
END SUB

SUB Intro
 SCREEN 0
 WIDTH 80, 25
 COLOR 7, 0
 CLS
 Center 4, "Q B a s i c"
 COLOR 15
 Center 5, "Ü     Ü ÜÜÜÜ Ü   Ü ÜÜÜÜ Ü   Ü      Ü     Ü ÜÜÜÜ Ü   Ü ÜÜÜÜ ÜÜÜÜÜ ÜÜÜÜ ÜÜÜÜÜ"
 Center 6, "ÛßÜ ÜßÛ Û  Û ÛÜ  Û Û    ÛÜÜÜÛ      ÛßÜ ÜßÛ Û  Û ÛÜ  Û Û  Û Û     Û    Û   Û"
 Center 7, "Û  ß  Û Û  Û Û ßÜÛ Ûßßß   Û        Û  ß  Û ÛßßÛ Û ßÜÛ ÛßßÛ Û ßßÛ Ûßßß ÛßÛßß"
 Center 8, "Û     Û ÛÜÜÛ Û   Û ÛÜÜÜ   Û        Û     Û Û  Û Û   Û Û  Û ÛÜÜÜÛ ÛÜÜÜ Û  ßÜ"
 COLOR 7
 Center 11, "A Personal Finance Manager written in"
 Center 12, "MS-DOS QBasic"
 Center 24, "Press any key to continue"
 SparklePause
END SUB

SUB LCenter (text$)
 LPRINT TAB(41 - LEN(text$) / 2); text$
END SUB

SUB LoadState
 OPEN "money.dat" FOR INPUT AS #1
 INPUT #1, ColorPref
 FOR a = 1 TO 19
  LINE INPUT #1, account(a).Title
  LINE INPUT #1, account(a).AType
  LINE INPUT #1, account(a).Desc
 NEXT
 CLOSE
END SUB

FUNCTION Menu (CurrChoiceX, MaxChoice, choice$(), ItemRow(), ItemCol(), help$(), BarMode)
 currChoice = CurrChoiceX
 IF BarMode THEN
  COLOR colors(7, ColorPref), colors(4, ColorPref)
  LOCATE 1, 1
  PRINT SPACE$(80);
 ELSE
  FancyCls colors(2, ColorPref), colors(1, ColorPref)
  COLOR colors(7, ColorPref), colors(4, ColorPref)
  Box ItemRow(1) - 1, ItemCol(1) - 1, ItemRow(MaxChoice) + 1, ItemCol(1) + LEN(choice$(1)) + 1
  COLOR colors(10, ColorPref), colors(6, ColorPref)
  FOR a = 1 TO MaxChoice + 1
   LOCATE ItemRow(1) + a - 1, ItemCol(1) + LEN(choice$(1)) + 2
   PRINT CHR$(178); CHR$(178);
  NEXT
  LOCATE ItemRow(MaxChoice) + 2, ItemCol(MaxChoice) + 2
  PRINT STRING$(LEN(choice$(MaxChoice)) + 2, 178);
 END IF
 COLOR colors(7, ColorPref), colors(4, ColorPref)
 FOR a = 1 TO MaxChoice
  LOCATE ItemRow(a), ItemCol(a)
  PRINT choice$(a);
 NEXT
 finished = 0
 WHILE finished = 0
  COLOR colors(8, ColorPref), colors(9, ColorPref)
  LOCATE ItemRow(currChoice), ItemCol(currChoice)
  PRINT choice$(currChoice);
  PrintHelpLine help$(currChoice)
  Kbd$ = ""
  WHILE Kbd$ = ""
   Kbd$ = INKEY$
  WEND
  COLOR colors(7, ColorPref), colors(4, ColorPref)
  LOCATE ItemRow(currChoice), ItemCol(currChoice)
  PRINT choice$(currChoice);
  SELECT CASE Kbd$
   CASE CHR$(0) + "H": IF BarMode THEN BEEP ELSE currChoice = (currChoice + MaxChoice - 2) MOD MaxChoice + 1
   CASE CHR$(0) + "P":  IF BarMode THEN finished = 1 ELSE currChoice = (currChoice) MOD MaxChoice + 1
   CASE CHR$(0) + "K"
    IF BarMode THEN
     currChoice = (currChoice + MaxChoice - 2) MOD MaxChoice + 1
    ELSE
     currChoice = -2
     finished = 1
    END IF
   CASE CHR$(0) + "M"
    IF BarMode THEN
     currChoice = (currChoice) MOD MaxChoice + 1
    ELSE
     currChoice = -3
     finished = 1
    END IF
   CASE CHR$(13): finished = 1
   CASE CHR$(27): currChoice = 0: finished = 1
   CASE ELSE:  BEEP
  END SELECT
 WEND
 Menu = currChoice
END FUNCTION

SUB MenuSystem
 DIM choice$(20), menuRow(20), menuCol(20), help$(20)
 LOCATE , , 0
 choice = 1
 finished = 0
 WHILE finished = 0
  FancyCls colors(2, ColorPref), colors(1, ColorPref)
  COLOR colors(7, ColorPref), colors(4, ColorPref)
  Box 9, 19, 14, 61
  Center 11, "Use arrow keys to navigate menu system"
  Center 12, "Press Enter to select a menu item"
  choice$(1) = " File "
  choice$(2) = " Accounts "
  choice$(3) = " Transactions "
  choice$(4) = " Reports "
  choice$(5) = " Colors "
  menuRow(1) = 1: menuCol(1) = 2
  menuRow(2) = 1: menuCol(2) = 8
  menuRow(3) = 1: menuCol(3) = 18
  menuRow(4) = 1: menuCol(4) = 32
  menuRow(5) = 1: menuCol(5) = 41
  help$(1) = "Exit the Money Manager"
  help$(2) = "Add/edit/delete accounts"
  help$(3) = "Add/edit/delete account transactions"
  help$(4) = "View and print reports"
  help$(5) = "Set screen colors"
  DO
   NewChoice = Menu((choice), 5, choice$(), menuRow(), menuCol(), help$(), 1)
  LOOP WHILE NewChoice = 0
  choice = NewChoice
  subchoice = -1
  WHILE subchoice < 0
   SELECT CASE choice
    CASE 1
     choice$(1) = " Exit           "
     menuRow(1) = 3: menuCol(1) = 2
     help$(1) = "Exit the Money Manager"
     subchoice = Menu(1, 1, choice$(), menuRow(), menuCol(), help$(), 0)
     IF subchoice = 1 THEN finished = 1
    CASE 2
     choice$(1) = " Edit Account Titles "
     menuRow(1) = 3: menuCol(1) = 8
     help$(1) = "Add/edit/delete accounts"
     subchoice = Menu(1, 1, choice$(), menuRow(), menuCol(), help$(), 0)
     IF subchoice = 1 THEN EditAccounts
    CASE 3
     FOR a = 1 TO 19
      IF Trim$(account(a).Title) = "" THEN choice$(a) = RIGHT$(STR$(a), 2) + ". ------------------- " ELSE choice$(a) = RIGHT$(STR$(a), 2) + ". " + account(a).Title
      menuRow(a) = a + 2
      menuCol(a) = 19
      help$(a) = RTRIM$(account(a).Desc)
     NEXT
     subchoice = Menu(1, 19, choice$(), menuRow(), menuCol(), help$(), 0)
     IF subchoice > 0 THEN EditTrans (subchoice)
    CASE 4
     choice$(1) = " Net Worth Report       "
     menuRow(1) = 3: menuCol(1) = 32
     help$(1) = "View and print net worth report"
     FOR a = 1 TO 19
      IF Trim$(account(a).Title) = "" THEN choice$(a + 1) = RIGHT$(STR$(a), 2) + ". ------------------- " ELSE choice$(a + 1) = RIGHT$(STR$(a), 2) + ". " + account(a).Title
      menuRow(a + 1) = a + 3
      menuCol(a + 1) = 32
      help$(a + 1) = "Print " + RTRIM$(account(a).Title) + " transaction summary"
     NEXT
     subchoice = Menu(1, 20, choice$(), menuRow(), menuCol(), help$(), 0)
     SELECT CASE subchoice
      CASE 1: NetWorthReport
      CASE 2 TO 20: TransactionSummary (subchoice - 1)
     END SELECT
    CASE 5
     choice$(1) = " Monochrome Scheme "
     choice$(2) = " Cyan/Blue Scheme  "
     choice$(3) = " Blue/Cyan Scheme  "
     choice$(4) = " Red/Black Scheme  "
     menuRow(1) = 3: menuCol(1) = 41
     menuRow(2) = 4: menuCol(2) = 41
     menuRow(3) = 5: menuCol(3) = 41
     menuRow(4) = 6: menuCol(4) = 41
     help$(1) = "Color scheme for monochrome and LCD displays"
     help$(2) = "Color scheme featuring cyan"
     help$(3) = "Color scheme featuring blue"
     help$(4) = "Color scheme featuring red"
     subchoice = Menu(1, 4, choice$(), menuRow(), menuCol(), help$(), 0)
     IF subchoice > 0 AND subchoice < 5 THEN
      ColorPref = subchoice
      SaveState
     END IF
   END SELECT
   FancyCls colors(2, ColorPref), colors(1, ColorPref)
   SELECT CASE subchoice
    CASE -2: choice = (choice + 3) MOD 5 + 1
    CASE -3: choice = (choice) MOD 5 + 1
   END SELECT
  WEND
 WEND
END SUB

SUB NetWorthReport
 DIM assetIndex(19), liabilityIndex(19)
 maxAsset = 0
 maxLiability = 0
 FOR a = 1 TO 19
  IF account(a).AType = "A" THEN
   maxAsset = maxAsset + 1
   assetIndex(maxAsset) = a
  ELSEIF account(a).AType = "L" THEN
   maxLiability = maxLiability + 1
   liabilityIndex(maxLiability) = a
  END IF
 NEXT
 finished = 0
 DO
  u1$ = "\                  \$$###,###,###.##"
  u2$ = "\               \+$$#,###,###,###.##"
  COLOR colors(5, ColorPref), colors(4, ColorPref)
  LOCATE 1, 1: PRINT SPACE$(80);
  LOCATE 1, 4: PRINT "Net Worth Report: " + DATE$;
  PrintHelpLine "<F2=Exit>    <F3=Print Report>"
  COLOR colors(7, ColorPref), colors(4, ColorPref)
  Box 2, 1, 24, 40
  Box 2, 41, 24, 80
  LOCATE 2, 16: PRINT " ASSETS "
  assetTotal# = 0
  a = 1
  count1 = 1
  WHILE a <= maxAsset
   file$ = "money." + Cvit$(assetIndex(a))
   OPEN file$ FOR RANDOM AS #1 LEN = 84
   FIELD #1, 11 AS valid$, 5 AS IoMaxRecord$, 8 AS IoBalance$
   GET #1, 1
   IF valid$ = "THISISVALID" THEN
    LOCATE 2 + count1, 3: PRINT USING u1$; account(assetIndex(a)).Title; CVD(IoBalance$)
    assetTotal# = assetTotal# + CVD(IoBalance$)
    count1 = count1 + 1
   END IF
   CLOSE
   a = a + 1
  WEND
  LOCATE 2, 55: PRINT " LIABILITIES "
  liabilityTotal# = 0
  a = 1
  count2 = 1
  WHILE a <= maxLiability
   file$ = "money." + Cvit$(liabilityIndex(a))
   OPEN file$ FOR RANDOM AS #1 LEN = 84
   FIELD #1, 11 AS valid$, 5 AS IoMaxRecord$, 8 AS IoBalance$
   GET #1, 1
   IF valid$ = "THISISVALID" THEN
    LOCATE 2 + count2, 43: PRINT USING u1$; account(liabilityIndex(a)).Title; CVD(IoBalance$)
    liabilityTotal# = liabilityTotal# + CVD(IoBalance$)
    count2 = count2 + 1
   END IF
   CLOSE
   a = a + 1
  WEND
  IF count2 > count1 THEN count1 = count2
  LOCATE 2 + count1, 25: PRINT "--------------"
  LOCATE 2 + count1, 65: PRINT "--------------"
  LOCATE 3 + count1, 3: PRINT USING u2$; "Total assets"; assetTotal#;
  LOCATE 3 + count1, 43: PRINT USING u2$; "Total liabilities"; liabilityTotal#
  COLOR colors(5, ColorPref), colors(4, ColorPref)
  LOCATE 1, 43: PRINT USING u2$; "    NET WORTH:"; assetTotal# - liabilityTotal#
  DO: Kbd$ = INKEY$: LOOP UNTIL Kbd$ <> ""
  SELECT CASE Kbd$
   CASE CHR$(0) + "<": finished = 1
   CASE CHR$(0) + "="
    PrintHelpLine ""
    Box 8, 20, 14, 62
    Center 10, "Prepare printer on LPT1 for report"
    Center 12, "Hit <Enter> to print, or <Esc> to abort"
    DO: Kbd$ = INKEY$: LOOP WHILE Kbd$ <> CHR$(13) AND Kbd$ <> CHR$(27)
    IF Kbd$ = CHR$(13) THEN
     Box 8, 20, 14, 62
     Center 11, "Printing report..."
     u0$ = "                     \                  \ "
     u1$ = "                        \                 \ $$###,###,###.##"
     u2$ = "                                              --------------"
     u3$ = "                                               ============="
     u4$ = "                        \               \+$$#,###,###,###.##"
     PrintErr = 0
     ON ERROR GOTO ErrorTrap
     LPRINT
     IF PrintErr = 0 THEN
      LPRINT : LPRINT : LPRINT : LPRINT : LPRINT
      LCenter "Q B a s i c"
      LCenter "M O N E Y   M A N A G E R"
      LPRINT : LPRINT
      LCenter "NET WORTH REPORT:  " + DATE$
      LCenter "-------------------------------------------"
      LPRINT USING u0$; "ASSETS:"
      assetTotal# = 0
      a = 1
      WHILE a <= maxAsset
       file$ = "money." + Cvit$(assetIndex(a))
       OPEN file$ FOR RANDOM AS #1 LEN = 84
       FIELD #1, 11 AS valid$, 5 AS IoMaxRecord$, 8 AS IoBalance$
       GET #1, 1
       IF valid$ = "THISISVALID" THEN
        LPRINT USING u1$; account(assetIndex(a)).Title; CVD(IoBalance$)
        assetTotal# = assetTotal# + CVD(IoBalance$)
       END IF
       CLOSE #1
       a = a + 1
      WEND
      LPRINT u2$
      LPRINT USING u4$; "Total assets"; assetTotal#
      LPRINT
      LPRINT
      LPRINT USING u0$; "LIABILITIES:"
      liabilityTotal# = 0
      a = 1
      WHILE a <= maxLiability
       file$ = "money." + Cvit$(liabilityIndex(a))
       OPEN file$ FOR RANDOM AS #1 LEN = 84
       FIELD #1, 11 AS valid$, 5 AS IoMaxRecord$, 8 AS IoBalance$
       GET #1, 1
       IF valid$ = "THISISVALID" THEN
        LPRINT USING u1$; account(liabilityIndex(a)).Title; CVD(IoBalance$)
        liabilityTotal# = liabilityTotal# + CVD(IoBalance$)
       END IF
       CLOSE #1
       a = a + 1
      WEND
      LPRINT u2$
      LPRINT USING u4$; "Total liabilities"; liabilityTotal#
      LPRINT
      LPRINT
      LPRINT u3$
      LPRINT USING u4$; "NET WORTH"; assetTotal# - liabilityTotal#
      LCenter "-------------------------------------------"
      LPRINT : LPRINT : LPRINT
     END IF
     ON ERROR GOTO 0
    END IF
   CASE ELSE: BEEP
  END SELECT
 LOOP UNTIL finished
END SUB

SUB PrintHelpLine (help$)
 COLOR colors(5, ColorPref), colors(4, ColorPref)
 LOCATE 25, 1
 PRINT SPACE$(80);
 Center 25, help$
END SUB

SUB SaveState
 OPEN "money.dat" FOR OUTPUT AS #2
 PRINT #2, ColorPref
 FOR a = 1 TO 19
  PRINT #2, account(a).Title
  PRINT #2, account(a).AType
  PRINT #2, account(a).Desc
 NEXT
 CLOSE #2
END SUB

SUB ScrollDown
 DEF SEG = VARSEG(ScrollDownAsm(1))
 CALL Absolute(VARPTR(ScrollDownAsm(1)))
 DEF SEG
END SUB

SUB ScrollUp
 DEF SEG = VARSEG(ScrollUpAsm(1))
 CALL Absolute(VARPTR(ScrollUpAsm(1)))
 DEF SEG
END SUB

SUB SparklePause
 COLOR 4, 0
 a$ = "*    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    "
 WHILE INKEY$ <> "": WEND
 WHILE INKEY$ = ""
  FOR a = 1 TO 5
   LOCATE 1, 1
   PRINT MID$(a$, a, 80);
   LOCATE 22, 1
   PRINT MID$(a$, 6 - a, 80);
   FOR b = 2 TO 21
    c = (a + b) MOD 5
    IF c = 1 THEN
     LOCATE b, 80
     PRINT "*";
     LOCATE 23 - b, 1
     PRINT "*";
    ELSE
     LOCATE b, 80
     PRINT " ";
     LOCATE 23 - b, 1
     PRINT " ";
    END IF
   NEXT
  NEXT
 WEND
END SUB

SUB TransactionSummary (item)
 FancyCls colors(2, ColorPref), colors(1, ColorPref)
 PrintHelpLine ""
 Box 8, 20, 14, 62
 Center 10, "Prepare printer on LPT1 for report"
 Center 12, "Hit <Enter> to print, or <Esc> to abort"
 DO: Kbd$ = INKEY$: LOOP WHILE Kbd$ <> CHR$(13) AND Kbd$ <> CHR$(27)
 IF Kbd$ = CHR$(13) THEN
  Box 8, 20, 14, 62
  Center 11, "Printing report..."
  PrintErr = 0
  ON ERROR GOTO ErrorTrap
  LPRINT
  IF PrintErr = 0 THEN
   PRINT
   LPRINT : LPRINT : LPRINT : LPRINT : LPRINT
   LCenter "Q B a s i c"
   LCenter "M O N E Y   M A N A G E R"
   LPRINT : LPRINT
   LCenter "Transaction summary: " + Trim$(account(item).Title)
   LCenter DATE$
   LPRINT
   u5$ = "--------|------|------------------------|----------|----------|--------------"
   LPRINT u5$
   LPRINT "  Date  | Ref# | Description            | Increase | Decrease |  Balance   "
   LPRINT u5$
   u0$ = "\      \|\    \|\                      \|"
   u2$ = "###,###.##"
   u3$ = "###,###,###.##"
   u4$ = "          "
   file$ = "money." + Cvit$(item)
   OPEN file$ FOR RANDOM AS #1 LEN = 84
   FIELD #1, 8 AS IoDate$, 10 AS IoRef$, 50 AS IoDesc$, 8 AS IoFig1$, 8 AS IoFig2$
   FIELD #1, 11 AS valid$, 5 AS IoMaxRecord$, 8 AS IoBalance$
   GET #1, 1
   IF valid$ = "THISISVALID" THEN
    Balance# = 0
    MaxRecord = VAL(IoMaxRecord$)
    CurrRecord = 1
    WHILE CurrRecord <= MaxRecord
     GET #1, CurrRecord + 1
     Fig1# = CVD(IoFig1$)
     Fig2# = CVD(IoFig2$)
     LPRINT USING u0$; IoDate$; IoRef$; IoDesc$;
     IF Fig2# = 0 AND Fig1# = 0 THEN
      LPRINT USING u4$ + "|" + u4$ + "|" + u3$; Balance#
     ELSEIF Fig2# = 0 THEN
      Balance# = Balance# + Fig1#
      LPRINT USING u2$ + "|" + u4$ + "|" + u3$; Fig1#; Balance#
     ELSE
      Balance# = Balance# - Fig2#
      LPRINT USING u4$ + "|" + u2$ + "|" + u3$; Fig2#; Balance#
     END IF
     CurrRecord = CurrRecord + 1
    WEND
    LPRINT u5$
    LPRINT : LPRINT
   END IF
   ON ERROR GOTO 0
  END IF
  CLOSE
 END IF
END SUB

FUNCTION Trim$ (x$)
 IF x$ = "" THEN
  Trim$ = ""
 ELSE
  lastChar = 0
  FOR a = 1 TO LEN(x$)
   y$ = MID$(x$, a, 1)
   IF y$ <> CHR$(0) AND y$ <> " " THEN lastChar = a
  NEXT
  Trim$ = LEFT$(x$, lastChar)
 END IF
END FUNCTION

