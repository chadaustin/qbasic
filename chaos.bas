SCREEN 12
CLS
PRINT "Chaos Displayer (Population Graph)"
PRINT "Chad Austin"
PRINT
a! = 0
WHILE a! <= 0 OR a! >= 4
  INPUT "Enter beginning rate of growth (.0001-3.999): ", a!
WEND
b! = 0
WHILE b! <= 0 OR b! > 299
  INPUT "Enter beginning population (.0001-299): ", b!
WEND
b! = b! / 300
c! = 0
WHILE c! <= 0 OR c! > .5
  INPUT "Enter rate of increasing growth (.0001-.5): ", c!
WEND
CLS
FOR r! = a! TO 4 STEP c!
  x! = b!
  LOCATE 27: PRINT "Rate of Growth:"; CINT(r! * 100) / 100; "  "
  FOR y% = 0 TO 639
    LINE (y%, 0)-(y%, 400), 0
    PSET (y%, 400 - x! * 400)
    x! = x! * r! * (1 - x!)
    IF y% MOD 49 = 0 OR y% < 50 THEN LOCATE 28: PRINT "Population ="; CINT(x! * 300); " "
    IF INKEY$ <> "" THEN END
  NEXT
NEXT

