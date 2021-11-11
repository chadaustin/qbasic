'
'                    PPPP       OOO      N   N      GGG
'                    P   P     O   O     NN  N     G   G
'                    P   P     O   O     N N N     G   G
'                    PPPP      O   O     N  NN     G
'                    P         O   O     N   N     G GGG
'                    P         O   O     N   N     G   G
'                    P          OOO      N   N      GGG
'
'
'
'
' Hit [Shift]-[F5] to play Pong again.
'
' Hit [Alt], F, X to exit Qbasic.
'
'
'

CONST True = -1
CONST false = NOT True
CONST up = 1
CONST down = 2
CONST right = 3
CONST left = 4

DECLARE FUNCTION OppoDir! (CurDir!)
DECLARE SUB Center (row, text$)
DECLARE SUB DrawScreen ()
DECLARE SUB GetInputs ()
DECLARE SUB Intro ()
DECLARE SUB PlayPong ()
DECLARE SUB PrintScore ()
DECLARE SUB ShowEnd ()

TYPE PaddleType
    clr    AS INTEGER
    dir    AS INTEGER
    top    AS INTEGER
    col    AS INTEGER
    score  AS INTEGER
END TYPE

TYPE BallType
    clr  AS INTEGER
    col  AS INTEGER
    dir  AS INTEGER
    row  AS INTEGER
END TYPE

RANDOMIZE TIMER

DIM SHARED paddle(1 TO 2) AS PaddleType
DIM SHARED ball AS BallType
DIM SHARED speed
DIM SHARED walls
DIM SHARED backclr
DIM SHARED NumGames
DIM SHARED incr$
DIM SHARED cont$

GOSUB CheckScreen
GOSUB ClearKeyLocks

Intro
GetInputs
PlayPong

GOSUB RestoreKeyLocks

ShowEnd

CheckScreen:
    ON ERROR GOTO ScreenWrong
    SCREEN 8
    SCREEN 0
    ON ERROR GOTO 0
RETURN

ScreenWrong:
    CLS
    LOCATE 12, 10: PRINT "You must VGA or EGA to play Pong."
    BEEP
    WHILE INKEY$ = "": WEND
    END

ClearKeyLocks:
    DEF SEG = 0
    KeyFlags = PEEK(1047)
    POKE 1047, &H0
    DEF SEG
RETURN

RestoreKeyLocks:
    DEF SEG = 0
    POKE 1047, KeyFlags
    DEF SEG
RETURN

SUB Center (row, text$)
    LOCATE row, 41 - LEN(text$) / 2
    PRINT text$
END SUB

SUB DrawScreen
    SCREEN 8
    LINE (0, 5)-(639, 154), backclr, BF
    FOR x = 0 TO 4
        LINE (0, x)-(639, x), walls
    NEXT
    FOR x = 155 TO 159
        LINE (0, x)-(639, x), walls
    NEXT
    LINE (paddle(1).col, paddle(1).top)-(paddle(1).col + 4, paddle(1).top + 29), paddle(1).clr, BF
    LINE (paddle(2).col, paddle(2).top)-(paddle(2).col + 4, paddle(2).top + 29), paddle(2).clr, BF
END SUB

SUB GetInputs
    COLOR 7
    CLS
    Center 2, "Play Continuous Pong? (Y/N)"
    DO: cont$ = UCASE$(INKEY$): LOOP UNTIL cont$ = "Y" OR cont$ = "N"
    LOCATE 2, 56: PRINT cont$
    LOCATE 6, 35: PRINT "1  = Slow"
    LOCATE 7, 35: PRINT "50 = Medium"
    LOCATE 8, 35: PRINT "99 = Fast"
    LOCATE 5, 33: PRINT "Speed: _"
    DO
        DO: kbd$ = INKEY$: LOOP UNTIL kbd$ <> ""
        SELECT CASE ASC(kbd$)
        CASE 48 TO 57
            IF LEN(speed$) = 0 OR LEN(speed$) = 1 THEN
                speed$ = speed$ + kbd$
            END IF
        CASE 8
            IF speed$ <> "" THEN speed$ = LEFT$(speed$, LEN(speed$) - 1)
        CASE 13
            speed = VAL(speed$)
            IF speed > 0 THEN EXIT DO
            speed$ = ""
        END SELECT
        LOCATE 5, 40: PRINT speed$; "_  "
    LOOP
    LOCATE 5, 40 + LEN(speed$): PRINT " "
    speed = (100 - speed) * 2 + 1
    LOCATE 11, 27: PRINT "Play to how many points? _"
    DO
        DO: kbd$ = INKEY$: LOOP UNTIL kbd$ <> ""
        SELECT CASE ASC(kbd$)
        CASE 48 TO 57
            IF LEN(play$) = 0 OR LEN(play$) = 1 THEN
                play$ = play$ + kbd$
            END IF
        CASE 8
            IF play$ <> "" THEN play$ = LEFT$(play$, LEN(play$) - 1)
        CASE 13
            NumGames = VAL(play$)
            IF NumGames > 0 THEN EXIT DO
            play$ = ""
        END SELECT
        LOCATE 11, 52: PRINT play$; "_  "
    LOOP
    LOCATE 11, 52 + LEN(play$): PRINT " "
    Center 14, "Increase speed during play? (Y/N)"
    DO
        incr$ = UCASE$(INKEY$)
    LOOP UNTIL incr$ = "Y" OR incr$ = "N"
    LOCATE 14, 58: PRINT incr$
    Center 17, "Color or Monochrome? (M/C)"
    DO
        clr$ = UCASE$(INKEY$)
    LOOP UNTIL clr$ = "C" OR clr$ = "M"
    LOCATE 17, 55: PRINT clr$
    IF clr$ = "C" THEN
        backclr = 1
        paddle(1).clr = 10
        paddle(2).clr = 13
        ball.clr = 15
        walls = 14
    ELSE
        paddle(1).clr = 7
        paddle(2).clr = 8
        ball.clr = 15
        walls = 15
    END IF
    start = TIMER
    FOR x = 1 TO 500: NEXT
    stp = TIMER
    speed = CINT(speed * (.2 / (stp - start)))
END SUB

SUB Intro
    CLS
    COLOR 14
    Center 2, "ÛßßÜ   ÜßßÜ   Û  Û   ÛßßÛ"
    Center 3, "ÛÜÜß   Û  Û   ÛßÜÛ   Û  ß"
    Center 4, "Û      Û  Û   Û  Û   Û ßÛ"
    Center 5, "Û      ßÜÜß   Û  Û   ÛÜÜÛ"
    COLOR 15
    Center 7, "Written by:  C. A. Austin"
    Center 9, "The computerized game of Ping-Pong"
    Center 11, "GENERAL CONTROLS"
    Center 13, "PAUSE = P"
    Center 14, "QUIT  = Q"
    Center 16, "Player #1              Player #2"
    Center 17, "UP:         Y                                  "
    Center 18, "DOWN:       N                                  "
    Center 19, "STOP:       H                    Enter          "
    Center 20, "FORWARD:    J                                  "
    Center 21, "BACK:       G                                  "
    Center 23, "Hit any key to continue"
    WHILE INKEY$ = "": WEND
END SUB

FUNCTION OppoDir! (CurDir!)
    IF ball.row > 6 AND ball.row < 11 THEN
        SELECT CASE CurDir
        CASE 1: OppoDir = RND * 7 + 21
        CASE 5: OppoDir = 8
        CASE 7: OppoDir = 6
        CASE 9: OppoDir = 14
        CASE 10: OppoDir = 13
        CASE 11: OppoDir = 12
        CASE 16: OppoDir = 15
        CASE 17: OppoDir = 24
        CASE 18: OppoDir = 23
        CASE 19: OppoDir = 22
        CASE 20: OppoDir = 21
        CASE 29: OppoDir = 28
        CASE 30: OppoDir = 27
        CASE 31: OppoDir = 26
        CASE 32: OppoDir = 25
        END SELECT
    ELSE
        SELECT CASE CurDir
        CASE 2
            x% = RND * 7 + 1
            IF x% < 5 THEN
                OppoDir = RND * 3 + 17
            ELSE
                OppoDir = RND * 3 + 29
            END IF
        CASE 8: OppoDir = 5
        CASE 6: OppoDir = 7
        CASE 14: OppoDir = 9
        CASE 13: OppoDir = 10
        CASE 12: OppoDir = 11
        CASE 15: OppoDir = 16
        CASE 24: OppoDir = 17
        CASE 23: OppoDir = 18
        CASE 22: OppoDir = 19
        CASE 21: OppoDir = 20
        CASE 28: OppoDir = 29
        CASE 27: OppoDir = 30
        CASE 26: OppoDir = 31
        CASE 25: OppoDir = 32
        END SELECT
    END IF
END FUNCTION

SUB PlayPong
    paddle(1).top = 65
    paddle(2).top = 65
    paddle(1).col = 10
    paddle(2).col = 625
    paddle(1).dir = 0
    paddle(2).dir = 0
    FOR GamesPlayed = 1 TO NumGames
        BallPast = false
        IF cont$ = "N" THEN
            paddle(1).top = 65
            paddle(2).top = 65
            paddle(1).col = 10
            paddle(2).col = 625
            paddle(1).dir = 0
            paddle(2).dir = 0
        END IF
        ball.dir = RND * 31 + 1
        ball.col = 320
        ball.row = 80
        DrawScreen
        PrintScore
        WHILE INKEY$ <> "": WEND
        IF cont$ = "N" THEN
            Center 22, "Hit any key to continue"
            WHILE INKEY$ = "": WEND
            Center 22, "                       "
        END IF
        CIRCLE (ball.col, ball.row), 2, ball.clr
        DO WHILE NOT BallPast
            FOR x = 1 TO speed: NEXT
            kbd$ = UCASE$(INKEY$)
            SELECT CASE kbd$
            CASE "Y": paddle(1).dir = up
            CASE "N": paddle(1).dir = down
            CASE "H": paddle(1).dir = 0
            CASE "J": paddle(1).dir = right
            CASE "G": paddle(1).dir = left
            CASE CHR$(0) + "H": paddle(2).dir = up
            CASE CHR$(0) + "P": paddle(2).dir = down
            CASE CHR$(0) + "K": paddle(2).dir = left
            CASE CHR$(0) + "M": paddle(2).dir = right
            CASE CHR$(13): paddle(2).dir = 0
            CASE "P"
                Center 22, "Game Paused, Hit any key to continue."
                WHILE INKEY$ = "": WEND
                Center 22, SPACE$(38)
            CASE "Q"
                Center 22, "Are you sure? (Y/N)"
                DO: kbd$ = LCASE$(INKEY$): LOOP UNTIL kbd$ = "y" OR kbd$ = "n"
                Center 22, "                   "
                IF kbd$ = "y" THEN
                    CLS
                    BallPast = True
                    GamesPlayed = NumGames
                END IF
            END SELECT
            FOR x = 1 TO 2
                SELECT CASE paddle(x).dir
                CASE up
                    IF paddle(x).top > 7 THEN
                        paddle(x).top = paddle(x).top - 3
                        LINE (paddle(x).col, paddle(x).top)-(paddle(x).col + 4, paddle(x).top + 29), paddle(x).clr, BF
                        LINE (paddle(x).col, paddle(x).top + 30)-(paddle(x).col + 4, paddle(x).top + 32), backclr, BF
                    END IF
                CASE down
                    IF paddle(x).top < 124 THEN
                        paddle(x).top = paddle(x).top + 3
                        LINE (paddle(x).col, paddle(x).top)-(paddle(x).col + 4, paddle(x).top + 29), paddle(x).clr, BF
                        LINE (paddle(x).col, paddle(x).top - 1)-(paddle(x).col + 4, paddle(x).top - 3), backclr, BF
                    END IF
                END SELECT
            NEXT
            SELECT CASE paddle(1).dir
            CASE right
                IF paddle(1).col < 311 THEN
                    paddle(1).col = paddle(1).col + 2
                    LINE (paddle(1).col, paddle(1).top)-(paddle(1).col + 4, paddle(1).top + 29), paddle(1).clr, BF
                    LINE (paddle(1).col - 4, paddle(1).top)-(paddle(1).col - 1, paddle(1).top + 29), backclr, BF
                END IF
            CASE left
                IF paddle(1).col > 10 THEN
                    paddle(1).col = paddle(1).col - 2
                    LINE (paddle(1).col, paddle(1).top)-(paddle(1).col + 4, paddle(1).top + 29), paddle(1).clr, BF
                    LINE (paddle(1).col + 5, paddle(1).top)-(paddle(1).col + 8, paddle(1).top + 29), backclr, BF
                END IF
            END SELECT
            SELECT CASE paddle(2).dir
            CASE right
                IF paddle(2).col < 624 THEN
                    paddle(2).col = paddle(2).col + 2
                    LINE (paddle(2).col, paddle(2).top)-(paddle(2).col + 4, paddle(2).top + 29), paddle(2).clr, BF
                    LINE (paddle(2).col - 4, paddle(2).top)-(paddle(2).col - 1, paddle(2).top + 29), backclr, BF
                END IF
            CASE left
                IF paddle(2).col > 324 THEN
                    paddle(2).col = paddle(2).col - 2
                    LINE (paddle(2).col, paddle(2).top)-(paddle(2).col + 4, paddle(2).top + 29), paddle(2).clr, BF
                    LINE (paddle(2).col + 5, paddle(2).top)-(paddle(2).col + 9, paddle(2).top + 29), backclr, BF
                END IF
            END SELECT
            IF ball.row < 11 OR ball.row > 148 THEN
                PLAY "L64N76N65N19"
                IF ball.row < 1 THEN ball.row = ball.row + 10
                IF ball.row > 158 THEN ball.row = ball.row - 10
                ball.dir = OppoDir!((ball.dir))
            END IF
            IF ball.col < paddle(1).col + 16 AND ball.col > paddle(1).col AND ball.row > paddle(1).top AND ball.row < paddle(1).top + 30 THEN
                PLAY "L64N10N25N57"
                a% = RND * 16 + 1
                SELECT CASE a%
                CASE 1: ball.dir = 4
                CASE 2: ball.dir = 6
                CASE 3: ball.dir = 7
                CASE 4: ball.dir = 10
                CASE 5: ball.dir = 11
                CASE 6: ball.dir = 12
                CASE 7: ball.dir = 13
                CASE 8: ball.dir = 17
                CASE 9: ball.dir = 18
                CASE 10: ball.dir = 19
                CASE 11: ball.dir = 20
                CASE 12: ball.dir = 21
                CASE 13: ball.dir = 22
                CASE 14: ball.dir = 23
                CASE 15: ball.dir = 24
                CASE 16: ball.dir = 1
                CASE 17: ball.dir = 2
                END SELECT
            END IF
            IF ball.col > paddle(2).col - 16 AND ball.col < paddle(2).col AND ball.row > paddle(2).top AND ball.row < paddle(2).top + 30 THEN
                PLAY "L64N10N25N57"
                a% = RND * 16 + 1
                SELECT CASE a%
                CASE 1: ball.dir = 3
                CASE 2: ball.dir = 5
                CASE 3: ball.dir = 8
                CASE 4: ball.dir = 9
                CASE 5: ball.dir = 14
                CASE 6: ball.dir = 15
                CASE 7: ball.dir = 16
                CASE 8: ball.dir = 25
                CASE 9: ball.dir = 26
                CASE 10: ball.dir = 27
                CASE 11: ball.dir = 28
                CASE 12: ball.dir = 29
                CASE 13: ball.dir = 30
                CASE 14: ball.dir = 31
                CASE 15: ball.dir = 32
                CASE 16: ball.dir = 1
                CASE 17: ball.dir = 2
                END SELECT
            END IF
            prevrow = ball.row
            prevcol = ball.col
            SELECT CASE ball.dir
            CASE 0: ball.dir = RND * 31 + 1
            CASE 1: ball.row = ball.row - 4
            CASE 2: ball.row = ball.row + 4
            CASE 3: ball.col = ball.col - 8
            CASE 4: ball.col = ball.col + 8
            CASE 5: ball.row = ball.row - 2: ball.col = ball.col - 4
            CASE 6: ball.row = ball.row + 2: ball.col = ball.col + 4
            CASE 7: ball.row = ball.row - 2: ball.col = ball.col + 4
            CASE 8: ball.row = ball.row + 2: ball.col = ball.col - 4
            CASE 9: ball.row = ball.row - 3: ball.col = ball.col - 2
            CASE 10: ball.row = ball.row - 3: ball.col = ball.col + 2
            CASE 11: ball.row = ball.row - 1: ball.col = ball.col + 6
            CASE 12: ball.row = ball.row + 1: ball.col = ball.col + 6
            CASE 13: ball.row = ball.row + 3: ball.col = ball.col + 2
            CASE 14: ball.row = ball.row + 3: ball.col = ball.col - 2
            CASE 15: ball.row = ball.row + 1: ball.col = ball.col - 6
            CASE 16: ball.row = ball.row - 1: ball.col = ball.col - 6
            CASE 17: ball.row = ball.row - 4: ball.col = ball.col + 1
            CASE 18: ball.row = ball.row - 3: ball.col = ball.col + 3
            CASE 19: ball.row = ball.row - 2: ball.col = ball.col + 5
            CASE 20: ball.row = ball.row - 1: ball.col = ball.col + 7
            CASE 21: ball.row = ball.row + 1: ball.col = ball.col + 7
            CASE 22: ball.row = ball.row + 2: ball.col = ball.col + 5
            CASE 23: ball.row = ball.row + 3: ball.col = ball.col + 3
            CASE 24: ball.row = ball.row + 4: ball.col = ball.col + 1
            CASE 25: ball.row = ball.row + 4: ball.col = ball.col - 1
            CASE 26: ball.row = ball.row + 3: ball.col = ball.col - 3
            CASE 27: ball.row = ball.row + 2: ball.col = ball.col - 5
            CASE 28: ball.row = ball.row + 1: ball.col = ball.col - 7
            CASE 29: ball.row = ball.row - 1: ball.col = ball.col - 7
            CASE 30: ball.row = ball.row - 2: ball.col = ball.col - 5
            CASE 31: ball.row = ball.row - 3: ball.col = ball.col - 3
            CASE 32: ball.row = ball.row - 4: ball.col = ball.col - 1
            END SELECT
            CIRCLE (prevcol, prevrow), 2, backclr
            CIRCLE (ball.col, ball.row), 2, ball.clr
            IF ball.col < 10 THEN
                PLAY "L64N70N65N62N54N51N47N46N36N35N34N33N32N30N28N27N24N21N18N16N14N12N10N8N6N5N4N3N2N1"
                paddle(2).score = paddle(2).score + 1
                BallPast = True
            END IF
            IF ball.col > 628 THEN
                PLAY "L64N70N65N62N54N51N47N46N36N35N34N33N32N30N28N27N24N21N18N16N14N12N10N8N6N5N4N3N2N1"
                paddle(1).score = paddle(1).score + 1
                BallPast = True
            END IF
        LOOP
        CIRCLE (ball.col, ball.row), 2, backclr
        IF incr$ = "Y" THEN speed = speed - 10
        IF speed < 0 THEN speed = 0
    NEXT
END SUB

SUB PrintScore
    x = 9 - LEN(STR$(paddle(1).score)) - LEN(STR$(paddle(2).score))
    a$ = "Player #1>" + STR$(paddle(1).score) + SPACE$(x) + STR$(paddle(2).score) + " <Player #2"
    Center 23, a$
END SUB

SUB ShowEnd
    SCREEN 0
    CLS
    COLOR 15
    IF paddle(1).score > paddle(2).score THEN
        a$ = "Player #1 won with" + STR$(paddle(1).score) + " point(s)!"
    END IF
    IF paddle(1).score < paddle(2).score THEN
        a$ = "Player #2 won with" + STR$(paddle(2).score) + " point(s)!"
    END IF
    IF paddle(1).score = paddle(2).score THEN
        a$ = "Players #1 and #2 tied with" + RTRIM$(STR$(paddle(1).score)) + " point(s)!"
    END IF
    Center 12, a$
    END
END SUB

