DEFINT A-Z
SCREEN 12
FOR x = 0 TO 15
 LINE (0, x * 16 + 127)-(127, 255 - x * 16), x
 LINE (127, 255 - x * 16)-(255, x * 16 + 127), x
NEXT

