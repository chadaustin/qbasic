0 RANDOMIZE TIMER
DEFINT A-R
SCREEN 13
q = 0: r = 0
z = INT(RND * 150)
x = INT(RND * 150)
v = (INT(RND * 13 + 1))
FOR a = 1 TO 10
v = (INT(RND * 14 + 1))
LINE (0, 0)-(319, 63), 0, BF
COLOR v
LOCATE 1
PRINT "You will have"; 11 - a; "chances to come"
PRINT "within 10 of the hidden target.  The"
PRINT "coordinates are between 0 and 150"
INPUT "What is the coordinate of x"; b
INPUT "What is the coordinate of y"; c
'LINE ((b - 1) * 10, (c - 1) * 10 + 64)-((b - 1) * 10 + 9, (c - 1) * 10 + 73), , BF
PSET (b * 2, c + 64)
IF b + 10 > z AND b - 10 < z THEN 10
GOTO 30
10 IF c + 10 > x AND c - 10 < x THEN 40
GOTO 30
40 a = 0
GOTO 190
30 PRINT "You missed"
NEXT
CLS
COLOR 15
PRINT "You have"
50 r = r + 1
IF r > 25000 THEN 60
GOTO 50
60 COLOR 4
PRINT "LOST"
END
190
CLS
 FOR w = 31 TO 16 STEP -.2
 q = q + 1
 CIRCLE (z, x), q, w
 NEXT
COLOR 4
PRINT "Congratulations, You won"

