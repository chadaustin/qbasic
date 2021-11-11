DEFINT A-Z
CLS
SCREEN 9
PALETTE 5, 39
DIM a&(32)
DIM c AS STRING * 5
OPEN "life_pic.dat" FOR BINARY AS #1
num = 18
DIM help$(num)
help$(0) = "Nothing"
help$(1) = "Man"
help$(2) = "Woman"
help$(3) = "Oxygen Filter"
help$(4) = "CO2 Filter"
help$(5) = "Methane Filter"
help$(6) = "Plant"
help$(7) = "Light"
help$(8) = "Hydrolysis Device"
help$(9) = "Fire"
help$(10) = "Flowing Water"
help$(11) = "Still Water"
help$(12) = "Hydrogen Filter"
help$(13) = "Airlock"
help$(14) = "Dirt"
help$(15) = "Firewood"
help$(16) = "Ladder"
help$(17) = "Rock"
help$(18) = "Sand"
LOCATE , 55: PRINT "A = Black"
LOCATE , 55: PRINT "B = Blue"
LOCATE , 55: PRINT "C = Green"
LOCATE , 55: PRINT "D = Cyan"
LOCATE , 55: PRINT "E = Red"
LOCATE , 55: PRINT "F = Magenta"
LOCATE , 55: PRINT "G = Brown"
LOCATE , 55: PRINT "H = White"
LOCATE , 55: PRINT "I = Gray"
LOCATE , 55: PRINT "J = Light Blue"
LOCATE , 55: PRINT "K = Light Green"
LOCATE , 55: PRINT "L = Light Cyan"
LOCATE , 55: PRINT "M = Light Red"
LOCATE , 55: PRINT "N = Light Magenta"
LOCATE , 55: PRINT "O = Yellow"
LOCATE , 55: PRINT "P = High-intensity white"
LOCATE , 55: PRINT "Backspace = clear screen"
LOCATE , 55: PRINT "Enter = done"
LOCATE 20, 30: PRINT "Life Graphical Editor"
LOCATE 21, 35: PRINT "Chad Austin"
a$ = "VALID"
PUT #1, , a$
LINE (0, 0)-(17, 17), , B
LINE (0, 100)-(129, 229), , B
OPEN "life_pic.dat" FOR BINARY AS #2
GET #2, , c
FOR x = 0 TO num
 d = 0
 FOR a = 0 TO 32
  GET #2, , a&(a)
  IF EOF(2) THEN d = 1: EXIT FOR
 NEXT
 IF d = 0 THEN
  PUT (1, 1), a&(0), PSET
  FOR a = 0 TO 15
   FOR b = 0 TO 15
    LINE (a * 8 + 1, b * 8 + 101)-(a * 8 + 8, b * 8 + 108), POINT(a + 1, b + 1), BF
   NEXT
  NEXT
 END IF
 LOCATE 6: PRINT "Item to draw: "; help$(x); SPACE$(20)
 LOCATE 7: PRINT "Item number:"; x
 DO
  LINE (131, 101)-(131, 244), 0
  LINE (1, 231)-(129, 231), 0
  LINE (131, row * 8 + 101)-(131, row * 8 + 108)
  LINE (col * 8 + 1, 231)-(col * 8 + 8, 231)
  LOCATE 1, 30: PRINT "Color  = "; CHR$(POINT(col + 1, row + 1) + 65)
  LOCATE , 30: PRINT "Column ="; col + 1
  LOCATE , 30: PRINT "Row    ="; row + 1
  DO: kbd$ = UCASE$(INKEY$): LOOP UNTIL kbd$ <> ""
  SELECT CASE kbd$
  CASE CHR$(0) + "H"
   row = row - 1
   IF row = -1 THEN row = 15
   CASE CHR$(0) + "M"
   col = col + 1
   IF col = 16 THEN col = 0
  CASE CHR$(0) + "P"
   row = row + 1
   IF row = 16 THEN row = 0
  CASE CHR$(0) + "K"
   col = col - 1
   IF col = -1 THEN col = 15
  CASE CHR$(13)
   GET (1, 1)-(16, 16), a&
   FOR y = 0 TO 32
    PUT #1, , a&(y)
   NEXT
  CASE "A" TO "P"
   PSET (col + 1, row + 1), ASC(kbd$) - 65
   LINE (col * 8 + 1, row * 8 + 101)-(col * 8 + 8, row * 8 + 108), ASC(kbd$) - 65, BF
  CASE CHR$(8)
   LINE (1, 101)-(128, 228), 0, BF
   LINE (1, 1)-(16, 16), 0, BF
  END SELECT
 LOOP UNTIL kbd$ = CHR$(13)
NEXT
CLOSE
CLS

