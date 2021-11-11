DEFINT A-Z
SCREEN 12
CONST mx = 296
CONST hx = 148
FOR x = 0 TO 15
 COLOR 15
 x1 = x * hx / 15
 y1 = 256 - x * 16
 LINE (mx - x * (mx / 15), 256)-(x1, y1 - 16)
 LINE (mx - x * (mx / 15), 256)-(hx + x1, 256 - y1)
 LINE (x1, y1 - 16)-(hx + x1, 256 - y1)
NEXT





