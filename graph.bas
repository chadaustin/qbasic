CONST xmin = -1
CONST xmax = 1
CONST ymin = -1
CONST ymax = 1

SCREEN 12
WINDOW (xmin, ymin)-(xmax, ymax)
LINE (xmin, 0)-(xmax, 0)
LINE (0, ymin)-(0, ymax)
PRINT "XMin = "; xmin, "YMin = "; ymin
PRINT "XMax = "; xmax, "YMax = "; ymax
COLOR 14
FOR x = xmin TO xmax STEP (xmax - xmin) / 640

  ' Change this equation 
  y = ABS(x) - x ^ 2
  PSET (x, y)

  IF x = 0 THEN LOCATE 3: PRINT "Intersects X at "; y
  IF y = 0 THEN LOCATE 4: PRINT "Intersects Y at "; x
NEXT

