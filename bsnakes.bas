'
'                         B A T T L E   S N A K E S
'                               By: Chad Austin
'
'       Battle Snakes is a game in which two snakes try to kill the other
' by trapping it with its body or distract it into hitting a wall.  There
' are seven different battle fields, or arenas, to fight in.  The snake that
' kills the other the most wins.
'
'
'
'
' Hit [ALT], F, X to exit QBasic
'
' Hit [SHIFT]-[F5] to play "Battle Snakes"
'
'
'

' SUB Declarations
DECLARE SUB GetArena ()
DECLARE SUB GetInputs ()
DECLARE SUB InitArena ()
DECLARE SUB Intro ()
DECLARE SUB PlayBSnakes ()
DECLARE SUB ShowEnd ()

' Snake TYPE's
TYPE char
    col  AS INTEGER
    row  AS INTEGER
    dir  AS INTEGER
    clr  AS INTEGER
    dead AS INTEGER
    p    AS INTEGER
END TYPE

' Constants
CONST true = -1
CONST false = NOT true

' Global Variables
DIM SHARED player(1 TO 2) AS char
DIM SHARED speed, round, arena, ro
DIM SHARED Tboun, Bboun, Rboun, Lboun

RANDOMIZE TIMER

Intro
GetInputs
IF round > 10 THEN round = 11
FOR ro = 1 TO round
    PlayBSnakes
NEXT
ShowEnd

SUB GetArena
IF ro > 1 THEN
    PRINT "What arena? (1-7)"
    DO
        cd$ = INKEY$
        arena = VAL(cd$)
    LOOP UNTIL arena > 0 AND arena <= 7
END IF
CLS
player(1).clr = 9
player(2).clr = 13
SELECT CASE arena
CASE 1
    player(1).col = 50
    player(1).row = 98
    player(1).dir = 1
    player(2).col = 100
    player(2).row = 98
    player(2).dir = 1
    LINE (2, 2)-(301, 199), 15, B
    LINE (3, 3)-(300, 198), 15, B
CASE 2
    player(1).col = 5
    player(1).row = 80
    player(1).dir = 1
    player(2).col = 145
    player(2).row = 20
    player(2).dir = 2
    LINE (2, 2)-(301, 198), 15, B
    LINE (3, 3)-(300, 198), 15, B
    FOR x = 2 TO 40 STEP 2
        LINE (150, x * 2)-(151, x * 2 + 1), 15, B
    NEXT x
    FOR x = 60 TO 100 STEP 2
        LINE (150, x * 2)-(151, x * 2 + 1), 15, B
    NEXT x
CASE 3
    player(1).col = 2
    player(1).row = 2
    player(1).dir = 4
    player(2).col = 149
    player(2).row = 98
    player(2).dir = 3
    LINE (2, 2)-(301, 199), 15, B
    LINE (3, 3)-(300, 198), 15, B
    FOR z = 1 TO 40
        x% = RND * 110 + 15
        y% = RND * 60 + 15
        LINE (x% * 2, y% * 2)-(x% * 2 + 1, y% * 2 + 1), 15, B
    NEXT z
CASE 4
    player(1).col = 2
    player(1).row = 50
    player(1).dir = 4
    player(2).col = 149
    player(2).row = 50
    player(2).dir = 3
    LINE (50, 100)-(131, 101), 15, B
    LINE (170, 100)-(253, 101), 15, B
    LINE (150, 24)-(151, 83), 15, B
    LINE (150, 118)-(151, 183), 15, B
    LINE (2, 2)-(301, 199), 15, B
    LINE (3, 3)-(300, 198), 15, B
CASE 5
    player(1).col = 3
    player(1).row = 2
    player(1).dir = 2
    player(2).col = 148
    player(2).row = 98
    player(2).dir = 1
    LINE (2, 2)-(301, 199), 15, B
    LINE (3, 3)-(300, 198), 15, B
    FOR x = 10 TO 130 STEP 20
        LINE (x * 2, 3)-(x * 2 + 1, 151), 15, B
    NEXT x
    FOR x = 20 TO 140 STEP 20
        LINE (x * 2, 55)-(x * 2 + 1, 198), 15, B
    NEXT x
CASE 6
    player(1).col = 2
    player(1).row = 2
    player(1).dir = 4
    player(2).col = 49
    player(2).row = 24
    player(2).dir = 3
    LINE (2, 2)-(101, 51), 15, B
    LINE (3, 3)-(100, 50), 15, B
CASE 7
    player(1).col = 3
    player(1).row = 2
    player(1).dir = 2
    player(2).col = 148
    player(2).row = 98
    player(2).dir = 1
    LINE (2, 2)-(301, 199), 15, B
    LINE (3, 3)-(300, 198), 15, B
    FOR x = 25 TO 125 STEP 20
        FOR y = 2 TO 98 STEP 2
            LINE (x * 2, y * 2)-(x * 2 + 1, y * 2 + 1), 15, B
        NEXT y
    NEXT x
END SELECT
END SUB

SUB GetInputs
CLS
LOCATE 3, 20: PRINT "1   = very slow"
LOCATE 4, 20: PRINT "50  = slow"
LOCATE 5, 20: PRINT "100 = medium"
LOCATE 6, 20: PRINT "150 = fast"
LOCATE 7, 20: PRINT "200 = very fast"
LOCATE 8, 10: PRINT "(Computer speed may affect your skill level)"
DO
    LOCATE 2, 34: PRINT SPACE$(47)
    LOCATE 2, 15: INPUT "What is the game speed"; x$
    x = VAL(x$)
LOOP UNTIL x <= 200 AND x >= 1
speed = (201 - x) * 2
DO
    LOCATE 14, 53: PRINT SPACE$(28)
    LOCATE 14, 15: INPUT "How many rounds of combat do you want"; r$
    round = VAL(r$)
LOOP UNTIL round >= 1
LOCATE 20, 15: PRINT "In what arena would you like to fight? (1-7)"
DO
    arena$ = INKEY$
    arena = VAL(arena$)
LOOP UNTIL arena >= 1 AND arena <= 7
END SUB

SUB Intro
SCREEN 0
CLS
COLOR 14: LOCATE 1, 24: PRINT "Battle Snakes,  By: Chad Austin"
COLOR 7
LOCATE 3, 1: PRINT "        Battle Snakes is a game where two snakes attempt to kill each"
PRINT "other by cutting the other one off or scaring it into a wall.  There"
PRINT "are seven different arenas, each one having different wall positions"
PRINT "and different boundaries."
COLOR 3
LOCATE 10, 1
PRINT "                   Player 1                          Player 2"
COLOR 15
PRINT
PRINT "                     -up-                              -up- "
PRINT "                      W                                 "; CHR$(24)
PRINT
PRINT "           -left- A       D -right-         -left- "; CHR$(27); "         "; CHR$(26); " -right-"
PRINT
PRINT "                      X                                 "; CHR$(25)
PRINT "                    -down-                            -down-"
COLOR 7: LOCATE 21, 29: PRINT "Hit any key to continue"
WHILE INKEY$ = "": WEND
END SUB

SUB PlayBSnakes
SCREEN 7
GetArena
WHILE INKEY$ = "": WEND
player(1).dead = false
player(2).dead = false
DO
    FOR i = 1 TO speed - 10: NEXT i
    FOR c = 1 TO 2
        LINE (player(c).col * 2, player(c).row * 2)-(player(c).col * 2 + 1, player(c).row * 2 + 1), player(c).clr, BF
    NEXT c
    IF player(1).row = player(2).row AND player(1).col = player(2).col THEN
        player(1).dead = true
        player(2).dead = true
    END IF
    kbd$ = INKEY$
    SELECT CASE kbd$
    CASE CHR$(0) + "H": IF player(2).dir <> 2 THEN player(2).dir = 1
    CASE CHR$(0) + "P": IF player(2).dir <> 1 THEN player(2).dir = 2
    CASE CHR$(0) + "K": IF player(2).dir <> 4 THEN player(2).dir = 3
    CASE CHR$(0) + "M": IF player(2).dir <> 3 THEN player(2).dir = 4
    CASE CHR$(0) + "G": IF player(2).dir <> 6 THEN player(2).dir = 5
    CASE CHR$(0) + "Q": IF player(2).dir <> 5 THEN player(2).dir = 6
    CASE CHR$(0) + "O": IF player(2).dir <> 8 THEN player(2).dir = 7
    CASE CHR$(0) + "I": IF player(2).dir <> 7 THEN player(2).dir = 8
    CASE "w", "W": IF player(1).dir <> 2 THEN player(1).dir = 1
    CASE "x", "X": IF player(1).dir <> 1 THEN player(1).dir = 2
    CASE "a", "A": IF player(1).dir <> 4 THEN player(1).dir = 3
    CASE "d", "D": IF player(1).dir <> 3 THEN player(1).dir = 4
    CASE "q", "Q": IF player(1).dir <> 6 THEN player(1).dir = 5
    CASE "c", "C": IF player(1).dir <> 5 THEN player(1).dir = 6
    CASE "z", "Z": IF player(1).dir <> 8 THEN player(1).dir = 7
    CASE "e", "E": IF player(1).dir <> 7 THEN player(1).dir = 8
    CASE "p", "P", "s", "S": WHILE INKEY$ = "": WEND
    CASE ELSE
    END SELECT
    FOR e = 1 TO 2
        SELECT CASE player(e).dir
        CASE 1: player(e).row = player(e).row - 1
        CASE 2: player(e).row = player(e).row + 1
        CASE 3: player(e).col = player(e).col - 1
        CASE 4: player(e).col = player(e).col + 1
        CASE 5: player(e).row = player(e).row - 1: player(e).col = player(e).col - 1
        CASE 6: player(e).row = player(e).row + 1: player(e).col = player(e).col + 1
        CASE 7: player(e).row = player(e).row + 1: player(e).col = player(e).col - 1
        CASE 8: player(e).row = player(e).row - 1: player(e).col = player(e).col + 1
        END SELECT
    NEXT e
    IF POINT(player(2).col * 2, player(2).row * 2) <> 0 THEN player(2).dead = true
    IF POINT(player(1).col * 2, player(1).row * 2) <> 0 THEN player(1).dead = true
LOOP UNTIL player(1).dead = true OR player(2).dead = true
PLAY "L32N5N3N1N4N2"
SCREEN 9
CLS
IF player(1).dead = true THEN y = 1: t = true: player(2).p = player(2).p + 1
IF player(2).dead = true THEN y = 2: s = true: player(1).p = player(1).p + 1
IF t = true AND s = true THEN PRINT "Both players died!!" ELSE PRINT "Player"; y; "died!!"
WHILE INKEY$ = "": WEND
END SUB

SUB ShowEnd
CLS
PRINT "Player 1 had"; player(1).p; "points!!!!"
PRINT "Player 2 had"; player(2).p; "points!!!!"
WHILE INKEY$ = "": WEND
END SUB

