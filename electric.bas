DEFINT A-Z
SCREEN 13
x = 160
y = 100
RANDOMIZE TIMER
WHILE 1
  SELECT CASE INT(RND * 4)
    CASE 0: x = x + 1
    CASE 1: y = y + 1
    CASE 2: x = x - 1
    CASE 3: y = y - 1
  END SELECT
  PSET (x, y), x OR y
WEND

