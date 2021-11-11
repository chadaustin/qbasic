CONST xmin = -20
CONST xmax = 20
CONST ymin = -20
CONST ymax = 20

SCREEN 12
WINDOW (xmin, ymin)-(xmax, ymax)
LINE (xmin, 0)-(xmax, 0)
LINE (0, ymin)-(0, ymax)
PRINT "XMin = "; xmin, "YMin = "; ymin
PRINT "XMax = "; xmax, "YMax = "; ymax
COLOR 14
FOR x = xmin TO xmax STEP (xmax - xmin) / 640

  ' Change these equations 
  y1 = SIN(x) + TAN(x) * COS(x ^ 2) ^ 2
  y2 = SIN(oldx) + TAN(oldx) * COS(oldx ^ 2) ^ 2

  oldx = x
  IF x = 0 THEN LOCATE 3: PRINT "Intersects X at "; y
  IF y1 = 0 THEN LOCATE 4: PRINT "Intersects Y at "; x
  LINE (x, y1)-(oldx, y2)
NEXT

