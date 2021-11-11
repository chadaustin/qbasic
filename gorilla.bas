'                         Q B a s i c   G o r i l l a s
'
'                   Copyright (C) Microsoft Corporation 1990
'
' Your mission is to hit your opponent with the exploding banana
' by varying the angle and power of your throw, taking into account
' wind speed, gravity, and the city skyline.
'
' Speed of this game is determined by the constant SPEEDCONST.  If the
' program is too slow or too fast adjust the "CONST SPEEDCONST = 500" line
' below.  The larger the number the faster the game will go.
'
' To run this game, press Shift+F5.
'
' To exit QBasic, press Alt, F, X.
'
' To get help on a BASIC keyword, move the cursor to the keyword and press
' F1 or click the right mouse button.
'

DEFINT A-Z

DECLARE SUB DoSun (Mouth)
DECLARE SUB SetScreen ()
DECLARE SUB EndGame ()
DECLARE SUB Center (Row, Text$)
DECLARE SUB Intro ()
DECLARE SUB SparklePause ()
DECLARE SUB GetInputs (Player1$, Player2$, NumGames)
DECLARE SUB PlayGame (Player1$, Player2$, NumGames)
DECLARE SUB DoExplosion (x#, y#)
DECLARE SUB MakeCityScape (BCoor() AS ANY)
DECLARE SUB PlaceGorillas (BCoor() AS ANY)
DECLARE SUB UpdateScores (Record(), PlayerNum, Results)
DECLARE SUB DrawGorilla (x, y, arms)
DECLARE SUB GorillaIntro (Player1$, Player2$)
DECLARE SUB Rest (t#)
DECLARE SUB VictoryDance (Player)
DECLARE SUB ClearGorillas ()
DECLARE SUB DrawBan (xc#, yc#, r, bc)
DECLARE FUNCTION Scl (n!)
DECLARE FUNCTION GetNum# (Row, Col)
DECLARE FUNCTION DoShot (PlayerNum, x, y)
DECLARE FUNCTION ExplodeGorilla (x#, y#)
DECLARE FUNCTION Getn# (Row, Col)
DECLARE FUNCTION PlotShot (StartX, StartY, Angle#, Velocity, PlayerNum)
DECLARE FUNCTION CalcDelay! ()

'$DYNAMIC

TYPE XYPoint
 XCoor AS INTEGER
 YCoor AS INTEGER
END TYPE

CONST SPEEDCONST = 500

DIM SHARED GorillaX(1 TO 2), GorillaY(1 TO 2)
DIM SHARED LastBuilding, pi#
DIM SHARED LBan&(x), RBan&(x), UBan&(x), DBan&(x)
DIM SHARED GorD&(120), GorL&(120), GorR&(120), gravity#, Wind, ScrHeight
DIM SHARED ScrWidth, Mode, MaxCol, ExplosionColor, SunColor, BackColor
DIM SHARED SunHit, SunHt, GHeight, MachSpeed AS SINGLE

 DEF FnRan (x) = INT(RND(1) * x) + 1
 DEF SEG = 0
 KeyFlags = PEEK(1047)
 IF (KeyFlags AND 32) = 0 THEN POKE 1047, KeyFlags OR 32
 DEF SEG

 pi# = 4 * ATN(1#)
 
 ON ERROR GOTO ScreenModeError
 Mode = 9
 SCREEN Mode
 ON ERROR GOTO PaletteError
 IF Mode = 9 THEN PALETTE 4, 0
 ON ERROR GOTO 0

 MachSpeed = CalcDelay

 IF Mode = 9 THEN
  ScrWidth = 640
  ScrHeight = 350
  GHeight = 25
  RESTORE EGABanana
  REDIM LBan&(8), RBan&(8), UBan&(8), DBan&(8)
  FOR i = 0 TO 8
   READ LBan&(i)
  NEXT
  FOR i = 0 TO 8
   READ DBan&(i)
  NEXT
  FOR i = 0 TO 8
   READ UBan&(i)
  NEXT
  FOR i = 0 TO 8
   READ RBan&(i)
  NEXT
  SunHt = 39
 ELSE
  ScrWidth = 320
  ScrHeight = 200
  GHeight = 12
  RESTORE CGABanana
  REDIM LBan&(2), RBan&(2), UBan&(2), DBan&(2)
  REDIM GorL&(20), GorD&(20), GorR&(20)
  FOR i = 0 TO 2
   READ LBan&(i)
  NEXT
  FOR i = 0 TO 2
   READ DBan&(i)
  NEXT
  FOR i = 0 TO 2
   READ UBan&(i)
  NEXT
  FOR i = 0 TO 2
   READ RBan&(i)
  NEXT
  MachSpeed = MachSpeed * 1.3
  SunHt = 20
 END IF

 Intro
 GetInputs Name1$, Name2$, NumGames
 GorillaIntro Name1$, Name2$
 PlayGame Name1$, Name2$, NumGames
 
 DEF SEG = 0
 POKE 1047, KeyFlags
 DEF SEG

 END

CGABanana:
 DATA 327686, -252645316, 60
 DATA 196618, -1057030081, 49344
 DATA 196618, -1056980800, 63
 DATA 327686,  1010580720, 240

EGABanana:
 DATA 458758,202116096,471604224,943208448,943208448,943208448,471604224,202116096,0
 DATA 262153, -2134835200, -2134802239, -2130771968, -2130738945,8323072, 8323199, 4063232, 4063294
 DATA 262153, 4063232, 4063294, 8323072, 8323199, -2130771968, -2130738945, -2134835200,-2134802239
 DATA 458758, -1061109760, -522133504, 1886416896, 1886416896, 1886416896,-522133504,-1061109760,0

ScreenModeError:
 IF Mode = 1 THEN
  CLS
  LOCATE 10, 5
  PRINT "Sorry, you must have CGA, EGA color, or VGA graphics to play GORILLA.BAS"
  END
 ELSE
  Mode = 1
  RESUME
 END IF

PaletteError:
 Mode = 1
RESUME NEXT

REM $STATIC
FUNCTION CalcDelay!
 s! = TIMER
 DO
  i = i + 1
 LOOP UNTIL TIMER - s! >= .5
 CalcDelay! = CSNG(i)
END FUNCTION

SUB Center (Row, Text$)
 LOCATE Row, MaxCol \ 2 - (LEN(Text$) / 2 + .5)
 PRINT Text$;
END SUB

SUB DoExplosion (x#, y#)
 PLAY "MBO0L32EFGEFDC"
 Radius = ScrHeight / 50
 IF Mode = 9 THEN Inc# = .5 ELSE Inc# = .41
 FOR c# = 0 TO Radius STEP Inc#
  CIRCLE (x#, y#), c#, ExplosionColor
 NEXT
 FOR c# = Radius TO 0 STEP (-1 * Inc#)
  CIRCLE (x#, y#), c#, 0
  FOR i = 1 TO 100: NEXT
  Rest .005
 NEXT
END SUB

FUNCTION DoShot (PlayerNum, x, y)
 IF PlayerNum = 1 THEN
  LocateCol = 1
 ELSE IF Mode = 9 THEN LocateCol = 66 ELSE LocateCol = 26
 END IF
 LOCATE 2, LocateCol
 PRINT "Angle:";
 Angle# = GetNum#(2, LocateCol + 7)
 LOCATE 3, LocateCol
 PRINT "Velocity:";
 Velocity = GetNum#(3, LocateCol + 10)
 IF PlayerNum = 2 THEN Angle# = 180 - Angle#
 FOR i = 1 TO 4
  LOCATE i, 1
  PRINT SPACE$(30 \ (80 \ MaxCol));
  LOCATE i, (50 \ (80 \ MaxCol))
  PRINT SPACE$(30 \ (80 \ MaxCol));
 NEXT
 SunHit = 0
 PlayerHit = PlotShot(x, y, Angle#, Velocity, PlayerNum)
 IF PlayerHit = 0 THEN
  DoShot = 0
 ELSE
  DoShot = 1
  IF PlayerHit = PlayerNum THEN PlayerNum = 3 - PlayerNum
  VictoryDance PlayerNum
 END IF
END FUNCTION

SUB DoSun (Mouth)
 x = ScrWidth \ 2: y = Scl(25)
 LINE (x - Scl(22), y - Scl(18))-(x + Scl(22), y + Scl(18)), 0, BF
 CIRCLE (x, y), Scl(12), 3
 PAINT (x, y), 3
 LINE (x - Scl(20), y)-(x + Scl(20), y), 3
 LINE (x, y - Scl(15))-(x, y + Scl(15)), 3
 LINE (x - Scl(15), y - Scl(10))-(x + Scl(15), y + Scl(10)), 3
 LINE (x - Scl(15), y + Scl(10))-(x + Scl(15), y - Scl(10)), 3
 LINE (x - Scl(8), y - Scl(13))-(x + Scl(8), y + Scl(13)), 3
 LINE (x - Scl(8), y + Scl(13))-(x + Scl(8), y - Scl(13)), 3
 LINE (x - Scl(18), y - Scl(5))-(x + Scl(18), y + Scl(5)), 3
 LINE (x - Scl(18), y + Scl(5))-(x + Scl(18), y - Scl(5)), 3
 IF Mouth THEN
  CIRCLE (x, y + Scl(5)), Scl(2.9), 0
  PAINT (x, y + Scl(5)), 0, 0
 ELSE CIRCLE (x, y), Scl(8), 0, (210 * pi# / 180), (330 * pi# / 180)
 END IF
 CIRCLE (x - 3, y - 2), 1, 0
 CIRCLE (x + 3, y - 2), 1, 0
 PSET (x - 3, y - 2), 0
 PSET (x + 3, y - 2), 0
END SUB

SUB DrawBan (xc#, yc#, r, bc)
 SELECT CASE r
  CASE 0: IF bc THEN PUT (xc#, yc#), LBan&, PSET ELSE PUT (xc#, yc#), LBan&, XOR
  CASE 1: IF bc THEN PUT (xc#, yc#), UBan&, PSET ELSE PUT (xc#, yc#), UBan&, XOR
  CASE 2: IF bc THEN PUT (xc#, yc#), DBan&, PSET ELSE PUT (xc#, yc#), DBan&, XOR
  CASE 3: IF bc THEN PUT (xc#, yc#), RBan&, PSET ELSE PUT (xc#, yc#), RBan&, XOR
 END SELECT
END SUB

SUB DrawGorilla (x, y, arms)
 DIM i AS SINGLE
 LINE (x - Scl(4), y)-(x + Scl(2.9), y + Scl(6)), 1, BF
 LINE (x - Scl(5), y + Scl(2))-(x + Scl(4), y + Scl(4)), 1, BF
 LINE (x - Scl(3), y + Scl(2))-(x + Scl(2), y + Scl(2)), 0
 IF Mode = 9 THEN
  FOR i = -2 TO -1
   PSET (x + i, y + 4), 0
   PSET (x + i + 3, y + 4), 0
  NEXT
 END IF
 LINE (x - Scl(3), y + Scl(7))-(x + Scl(2), y + Scl(7)), 1
 LINE (x - Scl(8), y + Scl(8))-(x + Scl(6.9), y + Scl(14)), 1, BF
 LINE (x - Scl(6), y + Scl(15))-(x + Scl(4.9), y + Scl(20)), 1, BF
 FOR i = 0 TO 4
  CIRCLE (x + Scl(i), y + Scl(25)), Scl(10), 1, 3 * pi# / 4, 9 * pi# / 8
  CIRCLE (x + Scl(-6) + Scl(i - .1), y + Scl(25)), Scl(10), 1, 15 * pi# / 8, pi# / 4
 NEXT
 CIRCLE (x - Scl(4.9), y + Scl(10)), Scl(4.9), 0, 3 * pi# / 2, 0
 CIRCLE (x + Scl(4.9), y + Scl(10)), Scl(4.9), 0, pi#, 3 * pi# / 2
 FOR i = -5 TO -1
  SELECT CASE arms
   CASE 1
    CIRCLE (x + Scl(i - .1), y + Scl(14)), Scl(9), 1, 3 * pi# / 4, 5 * pi# / 4
    CIRCLE (x + Scl(4.9) + Scl(i), y + Scl(4)), Scl(9), 1, 7 * pi# / 4, pi# / 4
    GET (x - Scl(15), y - Scl(1))-(x + Scl(14), y + Scl(28)), GorR&
   CASE 2
    CIRCLE (x + Scl(i - .1), y + Scl(4)), Scl(9), 1, 3 * pi# / 4, 5 * pi# / 4
    CIRCLE (x + Scl(4.9) + Scl(i), y + Scl(14)), Scl(9), 1, 7 * pi# / 4, pi# / 4
    GET (x - Scl(15), y - Scl(1))-(x + Scl(14), y + Scl(28)), GorL&
   CASE 3
    CIRCLE (x + Scl(i - .1), y + Scl(14)), Scl(9), 1, 3 * pi# / 4, 5 * pi# / 4
    CIRCLE (x + Scl(4.9) + Scl(i), y + Scl(14)), Scl(9), 1, 7 * pi# / 4, pi# / 4
    GET (x - Scl(15), y - Scl(1))-(x + Scl(14), y + Scl(28)), GorD&
  END SELECT
 NEXT
END SUB

FUNCTION ExplodeGorilla (x#, y#)
 YAdj = Scl(12)
 XAdj = Scl(5)
 SclX# = ScrWidth / 320
 SclY# = ScrHeight / 200
 IF x# < ScrWidth / 2 THEN PlayerHit = 1 ELSE PlayerHit = 2
 PLAY "MBO0L16EFGEFDC"
 FOR i = 1 TO 8 * SclX#
  CIRCLE (GorillaX(PlayerHit) + 3.5 * SclX# + XAdj, GorillaY(PlayerHit) + 7 * SclY# + YAdj), i, ExplosionColor, , , -1.57
  LINE (GorillaX(PlayerHit) + 7 * SclX#, GorillaY(PlayerHit) + 9 * SclY# - i)-(GorillaX(PlayerHit), GorillaY(PlayerHit) + 9 * SclY# - i), ExplosionColor
 NEXT
 FOR i = 1 TO 16 * SclX#
  IF i < (8 * SclX#) THEN CIRCLE (GorillaX(PlayerHit) + 3.5 * SclX# + XAdj, GorillaY(PlayerHit) + 7 * SclY# + YAdj), (8 * SclX# + 1) - i, 0, , , -1.57
  CIRCLE (GorillaX(PlayerHit) + 3.5 * SclX# + XAdj, GorillaY(PlayerHit) + YAdj), i, i MOD 2 + 1, , , -1.57
 NEXT
 FOR i = 24 * SclX# TO 1 STEP -1
  CIRCLE (GorillaX(PlayerHit) + 3.5 * SclX# + XAdj, GorillaY(PlayerHit) + YAdj), i, 0, , , -1.57
  FOR Count = 1 TO 200: NEXT
 NEXT
 ExplodeGorilla = PlayerHit
END FUNCTION

SUB GetInputs (Player1$, Player2$, NumGames)
 COLOR 7, 0
 CLS
 LOCATE 8, 15
 LINE INPUT "Name of Player 1 (Default = 'Player 1'): "; Player1$
 IF Player1$ = "" THEN Player1$ = "Player 1" ELSE Player1$ = LEFT$(Player1$, 10)
 LOCATE 10, 15
 LINE INPUT "Name of Player 2 (Default = 'Player 2'): "; Player2$
 IF Player2$ = "" THEN Player2$ = "Player 2" ELSE Player2$ = LEFT$(Player2$, 10)
 DO
  LOCATE 12, 56: PRINT SPACE$(25);
  LOCATE 12, 13
  INPUT "Play to how many total points (Default = 3)"; game$
  NumGames = VAL(LEFT$(game$, 2))
 LOOP UNTIL NumGames > 0 AND LEN(game$) < 3 OR LEN(game$) = 0
 IF NumGames = 0 THEN NumGames = 3
 DO
  LOCATE 14, 53: PRINT SPACE$(28);
  LOCATE 14, 17
  INPUT "Gravity in Meters/Sec (Earth = 9.8)"; grav$
  gravity# = VAL(grav$)
 LOOP UNTIL gravity# > 0 OR LEN(grav$) = 0
 IF gravity# = 0 THEN gravity# = 9.8
END SUB

FUNCTION GetNum# (Row, Col)
 Result$ = ""
 Done = 0
 WHILE INKEY$ <> "": WEND
 DO WHILE Done = 0
  LOCATE Row, Col
  PRINT Result$; CHR$(95); "    ";
  Kbd$ = INKEY$
  SELECT CASE Kbd$
   CASE "0" TO "9": Result$ = Result$ + Kbd$
   CASE ".": IF INSTR(Result$, ".") = 0 THEN Result$ = Result$ + Kbd$
   CASE CHR$(13): IF VAL(Result$) > 360 THEN Result$ = "" ELSE Done = 1
   CASE CHR$(8): IF LEN(Result$) > 0 THEN Result$ = LEFT$(Result$, LEN(Result$) - 1)
   CASE ELSE: IF LEN(Kbd$) > 0 THEN BEEP
  END SELECT
 LOOP
 LOCATE Row, Col
 PRINT Result$; " ";
 GetNum# = VAL(Result$)
END FUNCTION

SUB GorillaIntro (Player1$, Player2$)
 LOCATE 16, 34: PRINT "--------------"
 LOCATE 18, 34: PRINT "V = View Intro"
 LOCATE 19, 34: PRINT "P = Play Game"
 LOCATE 21, 35: PRINT "Your Choice?"
 DO WHILE Char$ = ""
  Char$ = INKEY$
 LOOP
 IF Mode = 1 THEN
  x = 125
  y = 100
 ELSE
  x = 278
  y = 175
 END IF
 SCREEN Mode
 SetScreen
 IF Mode = 1 THEN Center 5, "Please wait while gorillas are drawn."
 VIEW PRINT 9 TO 24
 IF Mode = 9 THEN PALETTE 1, BackColor
 FOR z = 1 TO 3
  DrawGorilla x, y, z
  CLS 2
 NEXT
 VIEW PRINT 1 TO 25
 IF Mode = 9 THEN PALETTE 1, 46
 IF UCASE$(Char$) = "V" THEN
  Center 2, "Q B A S I C   G O R I L L A S"
  Center 5, "             STARRING:               "
  P$ = Player1$ + " AND " + Player2$
  Center 7, P$
  PUT (x - 13, y), GorD&, PSET
  PUT (x + 47, y), GorD&, PSET
  Rest 1
  PUT (x - 13, y), GorL&, PSET
  PUT (x + 47, y), GorR&, PSET
  PLAY "t120o1l16b9n0baan0bn0bn0baaan0b9n0baan0b"
  Rest .3
  PUT (x - 13, y), GorR&, PSET
  PUT (x + 47, y), GorL&, PSET
  PLAY "o2l16e-9n0e-d-d-n0e-n0e-n0e-d-d-d-n0e-9n0e-d-d-n0e-"
  Rest .3
  PUT (x - 13, y), GorL&, PSET
  PUT (x + 47, y), GorR&, PSET
  PLAY "o2l16g-9n0g-een0g-n0g-n0g-eeen0g-9n0g-een0g-"
  Rest .3
  PUT (x - 13, y), GorR&, PSET
  PUT (x + 47, y), GorL&, PSET
  PLAY "o2l16b9n0baan0g-n0g-n0g-eeen0o1b9n0baan0b"
  Rest .3
  FOR i = 1 TO 4
   PUT (x - 13, y), GorL&, PSET
   PUT (x + 47, y), GorR&, PSET
   PLAY "T160O0L32EFGEFDC"
   Rest .1
   PUT (x - 13, y), GorR&, PSET
   PUT (x + 47, y), GorL&, PSET
   PLAY "T160O0L32EFGEFDC"
   Rest .1
  NEXT
 END IF
END SUB

SUB Intro
 SCREEN 0
 WIDTH 80, 25
 MaxCol = 80
 COLOR 15, 0
 CLS
 Center 4, "Q B a s i c    G O R I L L A S"
 COLOR 7
 Center 6, "Copyright (C) Microsoft Corporation 1990"
 Center 8, "Your mission is to hit your opponent with the exploding"
 Center 9, "banana by varying the angle and power of your throw, taking"
 Center 10, "into account wind speed, gravity, and the city skyline."
 Center 11, "The wind speed is shown by a directional arrow at the bottom"
 Center 12, "of the playing field, its length relative to its strength."
 Center 24, "Press any key to continue"
 PLAY "MBT160O1L8CDEDCDL4ECC"
 SparklePause
 IF Mode = 1 THEN MaxCol = 40
END SUB

SUB MakeCityScape (BCoor() AS XYPoint)
 x = 2
 Slope = FnRan(6)
 SELECT CASE Slope
  CASE 1: NewHt = 15
  CASE 2: NewHt = 130
  CASE 3 TO 5: NewHt = 15
  CASE 6: NewHt = 130
 END SELECT
 IF Mode = 9 THEN
  BottomLine = 335
  HtInc = 10
  DefBWidth = 37
  RandomHeight = 120
  WWidth = 3
  WHeight = 6
  WDifV = 15
  WDifh = 10
 ELSE
  BottomLine = 190
  HtInc = 6
  NewHt = NewHt * 20 \ 35
  DefBWidth = 18
  RandomHeight = 54
  WWidth = 1
  WHeight = 2
  WDifV = 5
  WDifh = 4
 END IF
 CurBuilding = 1
 DO
  SELECT CASE Slope
   CASE 1: NewHt = NewHt + HtInc
   CASE 2: NewHt = NewHt - HtInc
   CASE 3 TO 5: IF x > ScrWidth \ 2 THEN NewHt = NewHt - 2 * HtInc ELSE NewHt = NewHt + 2 * HtInc
   CASE 4: IF x > ScrWidth \ 2 THEN NewHt = NewHt + 2 * HtInc ELSE NewHt = NewHt - 2 * HtInc
  END SELECT
  BWidth = FnRan(DefBWidth) + DefBWidth
  IF x + BWidth > ScrWidth THEN BWidth = ScrWidth - x - 2
  BHeight = FnRan(RandomHeight) + NewHt
  IF BHeight < HtInc THEN BHeight = HtInc
  IF BottomLine - BHeight <= MaxHeight + GHeight THEN BHeight = MaxHeight + GHeight - 5
  BCoor(CurBuilding).XCoor = x
  BCoor(CurBuilding).YCoor = BottomLine - BHeight
  IF Mode = 9 THEN BuildingColor = FnRan(3) + 4 ELSE BuildingColor = 2
  LINE (x - 1, BottomLine + 1)-(x + BWidth + 1, BottomLine - BHeight - 1), BACKGROUND, B
  LINE (x, BottomLine)-(x + BWidth, BottomLine - BHeight), BuildingColor, BF
  c = x + 3
  DO
   FOR i = BHeight - 3 TO 7 STEP -WDifV
    IF Mode <> 9 THEN
     WinColr = (FnRan(2) - 2) * -3
    ELSEIF FnRan(4) = 1 THEN WinColr = 8
    ELSE WinColr = 14
    END IF
    LINE (c, BottomLine - i)-(c + WWidth, BottomLine - i + WHeight), WinColr, BF
   NEXT
   c = c + WDifh
  LOOP UNTIL c >= x + BWidth - 3
  x = x + BWidth + 2
  CurBuilding = CurBuilding + 1
 LOOP UNTIL x > ScrWidth - HtInc
 LastBuilding = CurBuilding - 1
 Wind = FnRan(10) - 5
 IF FnRan(3) = 1 THEN IF Wind > 0 THEN Wind = Wind + FnRan(10) ELSE Wind = Wind - FnRan(10)
 IF Wind <> 0 THEN
  WindLine = Wind * 3 * (ScrWidth \ 320)
  LINE (ScrWidth \ 2, ScrHeight - 5)-(ScrWidth \ 2 + WindLine, ScrHeight - 5), ExplosionColor
  IF Wind > 0 THEN ArrowDir = -2 ELSE ArrowDir = 2
  LINE (ScrWidth / 2 + WindLine, ScrHeight - 5)-(ScrWidth / 2 + WindLine + ArrowDir, ScrHeight - 5 - 2), ExplosionColor
  LINE (ScrWidth / 2 + WindLine, ScrHeight - 5)-(ScrWidth / 2 + WindLine + ArrowDir, ScrHeight - 5 + 2), ExplosionColor
 END IF
END SUB

SUB PlaceGorillas (BCoor() AS XYPoint)
 IF Mode = 9 THEN
  XAdj = 14
  YAdj = 30
 ELSE
  XAdj = 7
  YAdj = 16
 END IF
 SclX# = ScrWidth / 320
 SclY# = ScrHeight / 200
 FOR i = 1 TO 2
  IF i = 1 THEN BNum = FnRan(2) + 1 ELSE BNum = LastBuilding - FnRan(2)
  BWidth = BCoor(BNum + 1).XCoor - BCoor(BNum).XCoor
  GorillaX(i) = BCoor(BNum).XCoor + BWidth / 2 - XAdj
  GorillaY(i) = BCoor(BNum).YCoor - YAdj
  PUT (GorillaX(i), GorillaY(i)), GorD&, PSET
 NEXT
END SUB

SUB PlayGame (Player1$, Player2$, NumGames)
 DIM BCoor(0 TO 30) AS XYPoint
 DIM TotalWins(1 TO 2)
 J = 1
 FOR i = 1 TO NumGames
  CLS
  RANDOMIZE (TIMER)
  CALL MakeCityScape(BCoor())
  CALL PlaceGorillas(BCoor())
  DoSun 0
  Hit = 0
  DO WHILE Hit = 0
   J = 1 - J
   LOCATE 1, 1
   PRINT Player1$
   LOCATE 1, (MaxCol - 1 - LEN(Player2$))
   PRINT Player2$
   Center 23, LTRIM$(STR$(TotalWins(1))) + ">Score<" + LTRIM$(STR$(TotalWins(2)))
   Tosser = J + 1: Tossee = 3 - J
   Hit = DoShot(Tosser, GorillaX(Tosser), GorillaY(Tosser))
   IF SunHit THEN DoSun 0
   IF Hit = 1 THEN CALL UpdateScores(TotalWins(), Tosser, Hit)
  LOOP
  SLEEP 1
 NEXT
 SCREEN 0
 WIDTH 80, 25
 COLOR 7, 0
 MaxCol = 80
 CLS
 Center 8, "GAME OVER!"
 Center 10, "Score:"
 LOCATE 11, 30: PRINT Player1$; TAB(50); TotalWins(1)
 LOCATE 12, 30: PRINT Player2$; TAB(50); TotalWins(2)
 Center 24, "Press any key to continue"
 SparklePause
 COLOR 7, 0
 CLS
END SUB

FUNCTION PlotShot (StartX, StartY, Angle#, Velocity, PlayerNum)
 Angle# = Angle# / 180 * pi#
 Radius = Mode MOD 7
 InitXVel# = COS(Angle#) * Velocity
 InitYVel# = SIN(Angle#) * Velocity
 oldx# = StartX
 oldy# = StartY
 IF PlayerNum = 1 THEN PUT (StartX, StartY), GorL&, PSET ELSE PUT (StartX, StartY), GorR&, PSET
 PLAY "MBo0L32A-L64CL16BL64A+"
 Rest .1
 PUT (StartX, StartY), GorD&, PSET
 adjust = Scl(4)
 xedge = Scl(9) * (2 - PlayerNum)
 Impact = 0
 ShotInSun = 0
 OnScreen = 1
 PlayerHit = 0
 NeedErase = 0
 StartXPos = StartX
 StartYPos = StartY - adjust - 3
 IF PlayerNum = 2 THEN
  StartXPos = StartXPos + Scl(25)
  direction = Scl(4)
 ELSE direction = Scl(-4)
 END IF
 IF Velocity < 2 THEN
  x# = StartX
  y# = StartY
  pointval = 1
 END IF
 DO WHILE Impact = 0 AND OnScreen
  Rest .02
  IF NeedErase THEN
   NeedErase = 0
   CALL DrawBan(oldx#, oldy#, oldrot, 0)
  END IF
  x# = StartXPos + (InitXVel# * t#) + (.5 * (Wind / 5) * t# ^ 2)
  y# = StartYPos + ((-1 * (InitYVel# * t#)) + (.5 * gravity# * t# ^ 2)) * (ScrHeight / 350)
  IF (x# >= ScrWidth - Scl(10)) OR (x# <= 3) OR (y# >= ScrHeight - 3) THEN OnScreen = 0
  IF OnScreen AND y# > 0 THEN
   LookY = 0
   LookX = Scl(8 * (2 - PlayerNum))
   DO
    pointval = POINT(x# + LookX, y# + LookY)
    IF pointval = 0 THEN
     Impact = 0
     IF ShotInSun = 1 THEN IF ABS(ScrWidth \ 2 - x#) > Scl(20) OR y# > SunHt THEN ShotInSun = 0
    ELSEIF pointval = 3 AND y# < SunHt THEN
     IF SunHit = 0 THEN DoSun 1
     SunHit = 1
     ShotInSun = 1
    ELSE Impact = 1
    END IF
    LookX = LookX + direction
    LookY = LookY + Scl(6)
   LOOP UNTIL Impact OR LookX <> Scl(4)
   IF ShotInSun = 0 AND Impact = 0 THEN
    rot = (t# * 10) MOD 4
    CALL DrawBan(x#, y#, rot, 1)
    NeedErase = 1
   END IF
   oldx# = x#
   oldy# = y#
   oldrot = rot
  END IF
  t# = t# + .1
 LOOP
 IF pointval <> 1 AND Impact THEN
  CALL DoExplosion(x# + adjust, y# + adjust)
 ELSEIF pointval = 1 THEN PlayerHit = ExplodeGorilla(x#, y#)
 END IF
 PlotShot = PlayerHit
END FUNCTION

SUB Rest (t#)
 s# = TIMER
 t2# = MachSpeed * t# / SPEEDCONST
 DO: LOOP UNTIL TIMER - s# > t2#
END SUB

FUNCTION Scl (n!)
 IF n! <> INT(n!) THEN IF Mode = 1 THEN n! = n! - 1
 IF Mode = 1 THEN Scl = CINT(n! / 2 + .1) ELSE Scl = CINT(n!)
END FUNCTION

SUB SetScreen
 IF Mode = 9 THEN
  ExplosionColor = 2
  BackColor = 1
  PALETTE 0, 1
  PALETTE 1, 46
  PALETTE 2, 44
  PALETTE 3, 54
  PALETTE 5, 7
  PALETTE 6, 4
  PALETTE 7, 3
  PALETTE 9, 63
 ELSE
  ExplosionColor = 2
  BackColor = 0
  COLOR BackColor, 2
 END IF
END SUB

SUB SparklePause
 COLOR 4, 0
 A$ = "*    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    "
 WHILE INKEY$ <> "": WEND
 WHILE INKEY$ = ""
  FOR A = 1 TO 5
   LOCATE 1, 1
   PRINT MID$(A$, A, 80);
   LOCATE 22, 1
   PRINT MID$(A$, 6 - A, 80);
   FOR B = 2 TO 21
    c = (A + B) MOD 5
    IF c = 1 THEN
     LOCATE B, 80
     PRINT "*";
     LOCATE 23 - B, 1
     PRINT "*";
    ELSE
     LOCATE B, 80
     PRINT " ";
     LOCATE 23 - B, 1
     PRINT " ";
    END IF
   NEXT
  NEXT
 WEND
END SUB

SUB UpdateScores (Record(), PlayerNum, Results)
 IF Results = 1 THEN Record(ABS(PlayerNum - 3)) = Record(ABS(PlayerNum - 3)) + 1 ELSE Record(PlayerNum) = Record(PlayerNum) + 1
END SUB

SUB VictoryDance (Player)
 FOR i# = 1 TO 4
  PUT (GorillaX(Player), GorillaY(Player)), GorL&, PSET
  PLAY "MFO0L32EFGEFDC"
  Rest .2
  PUT (GorillaX(Player), GorillaY(Player)), GorR&, PSET
  PLAY "MFO0L32EFGEFDC"
  Rest .2
 NEXT
END SUB

