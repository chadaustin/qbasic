DEFINT A-Z
SCREEN 12
FOR x = 0 TO 15
 LINE (x * 16, 0)-(255, x * 16), x + 1
 LINE (255, x * 16)-(255 - x * 16, 255), x + 1
 LINE (255 - x * 16, 255)-(0, 255 - x * 16), x + 1
 LINE (0, 255 - x * 16)-(x * 16, 0), x + 1
NEXT

