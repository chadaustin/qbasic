DEFINT A-Z
RANDOMIZE TIMER
CLS
COLOR RND * 14 + 1
LOCATE 2, 20: PRINT "Chad Austin's Screen Savers"
COLOR RND * 14 + 1
LOCATE 4, 10: PRINT "Which screen saver would you like to run? (1-5)"
DO
        kd$ = INKEY$
LOOP UNTIL kd$ = "1" OR kd$ = "2" OR kd$ = "3" OR kd$ = "4" OR kd$ = "5"
IF kd$ = "1" THEN
        CLS
        COLOR RND * 14 + 1
        LOCATE 2, 25
        PRINT "Chad Austin's Screen Saver"
        LOCATE 3, 22
        PRINT "February 6, 1995 A.D.   4:08 p.m."
        COLOR RND * 14 + 1
        DO
                LOCATE 7, 10
                INPUT "What screen (7 or 9)"; z
        LOOP UNTIL z = 7 OR z = 9
        COLOR RND * 14 + 1
        DO
                LOCATE 10, 10
                INPUT "Loop rate (1 - 100000)"; L
        LOOP UNTIL L < 100001 AND L > 0
        COLOR RND * 14 + 1
        DO
                LOCATE 13, 10
                INPUT "Color or Monochrome (C/M)"; M$
        LOOP UNTIL M$ = "c" OR M$ = "m"
        COLOR RND * 14 + 1
        DO
                LOCATE 16, 10
                INPUT "Size of Square (0-200)"; w
        LOOP UNTIL w < 201 AND w > -1
        COLOR RND * 14 + 1
        DO
                LOCATE 19, 10
                INPUT "Do you want the square to be filled (Y/N)"; diff$
                diff$ = LCASE$(diff$)
        LOOP UNTIL diff$ = "y" OR diff$ = "n"
        SCREEN z
        IF z = 7 THEN
                a = 320
                B = 200
        END IF
        IF z = 9 THEN
                a = 600
                B = 450
        END IF
        DO
                CLS
                F = 0
                WHILE F <> L AND go <> 1
                        IF INKEY$ <> "" THEN go = 1
                        F = F + 1
                        y = RND * a
                        x = RND * B
                        IF M$ = "c" THEN
                                C = RND * 15
                        END IF
                        IF M$ = "m" THEN
                                F = RND * 3
                                IF F = 0 THEN C = 0
                                IF F = 1 THEN C = 7
                                IF F = 2 THEN C = 8
                                IF F = 3 THEN C = 15
                        END IF
                        IF L > 999 THEN LOCATE 1, 1: PRINT LTRIM$(RTRIM$(STR$(F)))
                        IF diff$ = "y" THEN LINE (y + w, x + w)-(y - w, x - w), C, BF
                        IF diff$ = "n" THEN LINE (y + w, x + w)-(y - w, x - w), C, B
                WEND
        LOOP UNTIL go = 1
END IF
IF kd$ = "2" THEN
        CLS
        COLOR CINT((RND * 14 + 1))
        LOCATE 1, 22: PRINT "Chad Austin's Second Screen Saver"
        LOCATE 2, 22: PRINT "February 6, 1995 A.D.   7:21 p.m. "
        LOCATE 22, 25: PRINT "Hit any key to continue"
        WHILE INKEY$ = "": WEND
        SCREEN 9
        y = 1
        DO
                IF y / 2 = INT(y / 2) THEN
                        COLOR 15
                        LINE (0, 175)-(640, 175)
                        LINE (320, 0)-(320, 640)
                        LINE (0, 0)-(640, 350)
                        LINE (0, 350)-(640, 0)
                        COLOR 0
                        LINE (0, 87.5)-(640, 262.5)
                        LINE (0, 262.5)-(640, 87.5)
                        LINE (475, 0)-(155, 350)
                        LINE (155, 0)-(475, 350)
                ELSE
                        COLOR 15
                        LINE (0, 87.5)-(640, 262.5)
                        LINE (0, 262.5)-(640, 87.5)
                        LINE (475, 0)-(155, 350)
                        LINE (155, 0)-(475, 350)
                        COLOR 0
                        LINE (0, 175)-(640, 175)
                        LINE (320, 0)-(320, 640)
                        LINE (0, 0)-(640, 350)
                        LINE (0, 350)-(640, 0)
                END IF
                IF y / 4 = INT((y) / 4) THEN v = 0
                IF (y + 1) / 4 = INT((y + 1) / 4) THEN v = 1
                IF (y + 2) / 4 = INT((y + 2) / 4) THEN v = 9
                IF (y + 3) / 4 = INT((y + 3) / 4) THEN v = 1
                x! = 1
                C = 1
                DO
                        CIRCLE (320, 175), x!, v
                        x! = x! * 1.25
                        C = C + 1
                LOOP UNTIL C > 30
                y = y + 1
        LOOP UNTIL INKEY$ <> ""
END IF
IF kd$ = "3" THEN
        CLS
        SCREEN 12
        DO
                CLS
                FOR i = 1 TO 500
                        CIRCLE (RND * 640, RND * 480), (RND ^ 2) * 250, RND * 14 + 1
                        IF INKEY$ <> "" THEN END
                NEXT i
        LOOP
END IF
IF kd$ = "4" THEN
        CLS
        DO
                INPUT "What loop rate do you want (1-500)"; L
        LOOP UNTIL L > 0 AND L < 501
        L = L * 10
        SCREEN 7
        DO
                FOR x = 0 TO 15
                        PAINT (1, 100), x
                        FOR i = 1 TO L
                                IF INKEY$ <> "" THEN END
                        NEXT i
                NEXT x
        LOOP
END IF
IF kd$ = "5" THEN
SCREEN 9
        w = 1
        x = 1
        y = 640
        z = 350
        DO WHILE go <> 1
                IF INKEY$ <> "" THEN go = 1
                COLOR RND * 15
                LINE (w, x)-(y, z), , B
                w = w + 1
                x = x + 1
                y = y - 1
                z = z - 1
                IF w = 321 THEN
                        w = 1
                        y = 640
                END IF
                IF x = 176 THEN
                        x = 1
                        z = 350
                END IF
        LOOP
END IF

