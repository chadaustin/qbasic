SCREEN 12
CONST PI = 3.1415
DIM sine(360) AS SINGLE
DIM cosine(360) AS SINGLE
FOR a% = 0 TO 360
 sine(a%) = SIN(a%)
 cosine(a%) = COS(a%)
NEXT
FOR a% = 180 TO 1 STEP -1
 oldx = 200
 oldy = 100
 FOR z% = 0 TO 360 STEP a%
  y = 100 + sine(z% * (PI / 180)) * 100
  x = 100 + cosine(z% * (PI / 180)) * 100
  LINE (x, y)-(oldx, oldy)
  oldx = x
  oldy = y
 NEXT
NEXT

