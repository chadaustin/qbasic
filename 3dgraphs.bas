DEFINT A-Z
DECLARE SUB makegraph ()
DECLARE SUB drawgraph ()
TYPE pnt
  x AS INTEGER
  y AS INTEGER
  h AS INTEGER
END TYPE
DIM SHARED x(19, 19) AS pnt
SCREEN 12
makegraph
drawgraph
WHILE INKEY$ = "": WEND

SUB drawgraph
  COLOR 9
  FOR a = 0 TO 18
    FOR b = 0 TO 18
      LINE (x(a, b).x, x(a, b).y)-(x(a + 1, b).x, x(a + 1, b).y)
      LINE -(x(a + 1, b + 1).x, x(a + 1, b + 1).y)
      LINE -(x(a, b + 1).x, x(a, b + 1).y)
      LINE -(x(a, b).x, x(a, b).y)
    NEXT
  NEXT
END SUB

SUB makegraph
  FOR a = 0 TO 19
    FOR b = 0 TO 19
                  ' Change this equation to change graph
      x(a, b).h = SIN(a) * COS(b) * 10
      x(a, b).x = 160 + a * 24 - b * 8
      x(a, b).y = b * 16 + a * 8 - x(a, b).h
    NEXT
  NEXT
END SUB

