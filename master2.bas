DEFINT A-N, X-Z
DECLARE SUB calcscore (x%, y%)
DECLARE SUB center (x%, a$)
DEF fngetchoice
 PRINT "1) Area"
 PRINT "2) Perimeter"
 PRINT
 x = 0
 WHILE x < 1 OR x > 3
  INPUT "Enter number of returned data: ", x
 WEND
 PRINT
 fngetchoice = x
END DEF
DEF fnchoice (x)
 PRINT
 PRINT "Enter choice:";
 c = 0
 WHILE c < 1 OR c > x
  c = VAL(INKEY$)
 WEND
 PRINT c
 PRINT
 fnchoice = c
END DEF
RANDOMIZE TIMER
DIM SHARED score
ON ERROR GOTO screenerror
DO
 SCREEN 0
 CLS
 center 2, "Master Program II"
 center 3, "Chad Austin"
 center 4, "3/8/96"
 center 7, "1) Geometry Helper     "
 center 8, "2) Payment Tracker     "
 center 9, "3) Math Quiz           "
 center 10, "4) Wage Calculator     "
 center 11, "5) Number Guessing Game"
 center 12, "6) Restaurant Menu     "
 center 13, "7) Chaos Displayer     "
 center 14, "8) Spiral              "
 center 15, "9) Quit                "
 DO
  num = VAL(INKEY$)
 LOOP UNTIL num AND num < 10
 CLS
 SELECT CASE num
  CASE 1
   a$ = "Y"
   WHILE a$ = "Y"
    CLS
    PRINT "Geometry Helper"
    PRINT "Chad Austin"
    PRINT
    PRINT "1) Right Triangle"
    PRINT "2) Square"
    PRINT "3) Parallelogram"
    PRINT "4) Trapezoid"
    PRINT
    x = 0
    WHILE x < 1 OR x > 4
     INPUT "Enter number of figure: ", x
    WEND
    PRINT
    SELECT CASE x
     CASE 1
      IF fngetchoice = 1 THEN
       INPUT "Enter base: ", s1
       INPUT "Enter height: ", s2
       PRINT
       PRINT "Area:"; s1 * s2 / 2
      ELSE
       INPUT "Enter side 1: ", s1
       INPUT "Enter side 2: ", s2
       INPUT "Enter side 3: ", s3
       PRINT
       PRINT "Perimeter:"; s1 + s2 + s3
      END IF
     CASE 2
      INPUT "Enter a side: ", s1
      PRINT
      PRINT "Area:"; s1 ^ 2
      PRINT "Perimeter:"; s1 * 4
     CASE 3
      IF fngetchoice = 1 THEN
       INPUT "Enter a base: ", s1
       INPUT "Enter height: ", s2
       PRINT
       PRINT "Area:"; s1 * s2
      ELSE
       INPUT "Enter side 1: ", s1
       INPUT "Enter side 2: ", s2
       PRINT
       PRINT "Perimeter:"; (s1 + s2) * 4
      END IF
     CASE 4
      IF fngetchoice = 1 THEN
       INPUT "Enter base 1: ", s1
       INPUT "Enter base 2: ", s2
       INPUT "Enter height: ", s3
       PRINT
       IF s1 > s2 THEN
        a = s1
        b = s2
       ELSE
        a = s2
        b = s1
       END IF
       PRINT "Area:"; b * s3 + ((a - b) * s3) / 2
      ELSE
       INPUT "Enter side 1: ", s1
       INPUT "Enter side 2: ", s2
       INPUT "Enter side 3: ", s3
       INPUT "Enter side 4: ", s4
       PRINT
       PRINT "Perimeter:"; s1 + s2 + s3 + s4
      END IF
    END SELECT
    PRINT
    PRINT "Do another? (Y/N)"
    a$ = ""
    WHILE a$ <> "Y" AND a$ <> "N"
     a$ = UCASE$(INKEY$)
    WEND
   WEND
  CASE 2
   PRINT "Payment Tracker"
   PRINT "Chad Austin"
   PRINT
   INPUT "Enter amount of money borrowed: ", x!
   INPUT "Enter annual rate of interest: ", y
   PRINT
   FOR z = 2 TO 5
    PRINT STR$(z * 12); "-mth",
   NEXT
   PRINT
   FOR z = 2 TO 5
    PRINT CLNG(x! * ((1 + y) / 10) / (z * 12) * 100) / 100,
   NEXT
   WHILE INKEY$ = "": WEND
  CASE 3
   PRINT "Math Quiz"
   PRINT "Chad Austin"
   PRINT
   FOR a = 1 TO 10
    PRINT "1) Addition"
    PRINT "2) Substraction"
    PRINT "3) Multiplication"
    PRINT "4) Division"
    PRINT
    y = 0
    WHILE y < 1 OR y > 4
     INPUT "Enter number of mathematical operation: ", y
    WEND
    SELECT CASE y
     CASE 1
      num1 = RND * 9
      num2 = RND * 9
      PRINT num1; "+"; num2; "=";
      INPUT " ", x
      answer = num1 + num2
     CASE 2
      num1 = RND * 9
      num2 = RND * num1
      PRINT num1; "-"; num2; "=";
      INPUT " ", x
      answer = num1 - num2
     CASE 3
      num1 = RND * 9
      num2 = RND * 9
      PRINT num1; "x"; num2; "=";
      INPUT " ", x
      answer = num1 * num2
     CASE 4
      num1 = 1
      num2 = 2
      WHILE num1 / num2 <> INT(num1 / num2)
       num1 = RND * 8 + 1
       num2 = RND * 8 + 1
      WEND
      PRINT num1; "/"; num2; "=";
      INPUT " ", x
      answer = num1 / num2
    END SELECT
    calcscore answer = x, answer
   NEXT
   PRINT "You got"; score; "correct."
   SELECT CASE score
    CASE IS = 10: PRINT "PERFECT!"
    CASE IS > 8: PRINT "You did well."
    CASE IS > 5: PRINT "You did okay."
    CASE IS > 2: PRINT "You did poorly."
    CASE ELSE: PRINT "Math is not your subject."
   END SELECT
   WHILE INKEY$ = "": WEND
  CASE 4
   PRINT "Wage Calculator"
   PRINT "Chad Austin"
   PRINT
   x! = 0
   WHILE x! <= 0 OR x! > 24
    INPUT "Enter number of hours worked/day: ", x!
   WEND
   INPUT "Enter hourly wage: ", y!
   PRINT
   PRINT "Money earned/work week:"; x! * y! * 5
   PRINT "Money earned/month:"; x! * y! * 30
   PRINT "Money earned/year:"; x! * y! * 365
   WHILE INKEY$ = "": WEND
  CASE 5
   num = RND * 99 + 1
   PRINT "Number Guessing Game"
   PRINT "Chad Austin"
   PRINT
   PRINT "E)asy"
   PRINT "N)ormal"
   PRINT "H)ard"
   PRINT
   PRINT "Select difficulty (E, N, H): ";
   a$ = ""
   WHILE a$ <> "E" AND a$ <> "N" AND a$ <> "H"
    a$ = UCASE$(INKEY$)
   WEND
   SELECT CASE a$
    CASE "E": y = 7: PRINT "Easy"
    CASE "N": y = 5: PRINT "Normal"
    CASE "H": y = 3: PRINT "Hard"
   END SELECT
   PRINT
   PRINT "I have selected a random number between 1 and 100."
   FOR x = y TO 1 STEP -1
    PRINT
    PRINT "You have"; x;
    PRINT "guess";
    IF x > 1 THEN PRINT "es ";  ELSE PRINT " ";
    PRINT "left."
    n = 0
    WHILE n < 1 OR n > 100
     INPUT "Guess a number: ", n
    WEND
    PRINT
    SELECT CASE n
     CASE IS > num: PRINT "Too high"
     CASE IS < num: PRINT "Too low"
     CASE ELSE
      PRINT "Good guess!"
      PRINT "You win!"
      WHILE INKEY$ = "": WEND
      RUN
    END SELECT
   NEXT
   PRINT
   PRINT "You lose!"
   PRINT "The correct answer was"; STR$(num); "."
   WHILE INKEY$ = "": WEND
  CASE 6
   CLS
   PRINT "Welcome to the menu program!"
   PRINT "Chad Austin"
   PRINT
   PRINT "Press any key to continue"
   WHILE INKEY$ = "": WEND
   WHILE a <> 5
    CLS
    PRINT "1) Appetizers"
    PRINT "2) Main Courses"
    PRINT "3) Desserts"
    PRINT "4) Beveradges"
    PRINT "5) Exit"
    a = fnchoice(5)
    SELECT CASE a
     CASE 1
      PRINT "1) Cheese Sticks.............2.00"
      PRINT "2) Garlic Bread..............1.00"
      PRINT "3) Riblets...................3.00"
      PRINT "4) Shrimp....................2.50"
      SELECT CASE fnchoice(4)
       CASE 1: cost! = cost! + 2
       CASE 2: cost! = cost! + 1
       CASE 3: cost! = cost! + 3
       CASE 4: cost! = cost! + 2.5
      END SELECT
     CASE 2
      PRINT "1) Hamburger.................3.00"
      PRINT "2) Cheeseburger..............3.50"
      PRINT "3) Ribs......................6.00"
      PRINT "4) Steak.....................5.50"
      PRINT "5) Flounder..................7.00"
      PRINT "6) Crap Legs................11.50"
      PRINT "7) Lobster..................12.00"
      PRINT "8) Pizza. . . ."
      SELECT CASE fnchoice(8)
       CASE 1: cost! = cost! + 3
       CASE 2: cost! = cost! + 3.5
       CASE 3: cost! = cost! + 6
       CASE 4: cost! = cost! + 5.5
       CASE 5: cost! = cost! + 7
       CASE 6: cost! = cost! + 11.5
       CASE 7: cost! = cost! + 12
       CASE 8
        PRINT "1) Small. . . ."
        PRINT "2) Medium. . . ."
        PRINT "3) Large. . . ."
        SELECT CASE fnchoice(3)
         CASE 1: b = 6.5
         CASE 2: b = 8
         CASE 3: b = 9.5
        END SELECT
        PRINT "1) Cheese...................";
        PRINT USING "##.##"; b
        PRINT "2) Pepperoni................";
        PRINT USING "##.##"; b + .5
        PRINT "3) Sausage..................";
        PRINT USING "##.##"; b + .5
        PRINT "4) Vegetable................";
        PRINT USING "##.##"; b + 1.5
        SELECT CASE fnchoice(4)
         CASE 1: cost! = cost! + b
         CASE 2, 3: cost! = cost! + b + .5
         CASE 4: cost! = cost! + b + 1.5
        END SELECT
      END SELECT
     CASE 3
      PRINT "1) Pie. . . ."
      PRINT "2) Cake. . . ."
      PRINT "3) Cobbler. . . ."
      SELECT CASE fnchoice(3)
       CASE 1
        PRINT "1) Apple.....................3.50"
        PRINT "2) Peach.....................4.50"
        PRINT "3) Chocolate.................5.00"
        SELECT CASE fnchoice(3)
         CASE 1: cost! = cost! + 3.5
         CASE 2: cost! = cost! + 4.5
         CASE 3: cost! = cost! + 5
        END SELECT
       CASE 2
        PRINT "1) Vanilla...................3.50"
        PRINT "2) Chocalate.................3.50"
        PRINT "3) Angel Food................5.00"
        PRINT "4) Devil's Food..............4.00"
        SELECT CASE fnchoice(4)
         CASE 1, 2: cost! = cost! + 3.5
         CASE 3: cost! = cost! + 5
         CASE 4: cost! = cost! + 4
        END SELECT
       CASE 3
        PRINT "1) Peach.....................3.75"
        PRINT "2) Apple.....................3.50"
        PRINT "3) Cherry....................4.00"
        SELECT CASE fnchoice(3)
         CASE 1: cost! = cost! + 3.75
         CASE 2: cost! = cost! + 3.5
         CASE 3: cost! = cost! + 4
        END SELECT
      END SELECT
     CASE 4
      PRINT "1) Fountain Drink............0.75"
      PRINT "2) Wine......................4.00"
      PRINT "3) Beer......................1.50"
      PRINT "4) Milk......................1.00"
      PRINT "5) Hot Chocolate.............2.00"
      SELECT CASE fnchoice(5)
       CASE 1: cost! = cost! + .75
       CASE 2: cost! = cost! + 4
       CASE 3: cost! = cost! + 1.5
       CASE 4: cost! = cost! + 1
       CASE 5: cost! = cost! + 2
      END SELECT
    END SELECT
   WEND
   PRINT USING "Cost:       $$#####.##"; cost!
   PRINT USING "Tax:        $$#####.##"; cost! * .05
   PRINT USING "Tip:        $$#####.##"; cost! * .15
   PRINT USING "Total Bill: $$#####.##"; cost! * 1.2
   WHILE INKEY$ = "": WEND
  CASE 7
   SCREEN 12
   CLS
   PRINT "Chaos Displayer (Population Graph)"
   PRINT "Chad Austin"
   PRINT
   a! = 0
   WHILE a! <= 0 OR a! >= 4
    INPUT "Enter beginning rate of growth (.0001-3.999): ", a!
   WEND
   b! = 0
   WHILE b! <= 0 OR b! > 299
    INPUT "Enter beginning population (.0001-299): ", b!
   WEND
   b! = b! / 300
   c! = 0
   WHILE c! <= 0 OR c! > .5
    INPUT "Enter rate of increasing growth (.0001-.5): ", c!
   WEND
   CLS
   FOR r! = a! TO 4 STEP c!
    x! = b!
    LOCATE 27: PRINT "Rate of Growth:"; CINT(r! * 100) / 100; "  "
    FOR y% = 0 TO 639
     LINE (y%, 0)-(y%, 400), 0
     PSET (y%, 400 - x! * 400)
     x! = x! * r! * (1 - x!)
     IF y% MOD 49 = 0 OR y% < 50 THEN LOCATE 28: PRINT "Population ="; CINT(x! * 300); " "
     IF INKEY$ <> "" THEN RUN
    NEXT
   NEXT
  CASE 8
   SCREEN 12
   CLS
   a = 0
   WHILE a < 1 OR a > 240
    INPUT "Enter size of spiral (1-240): ", a
   WEND
   z! = 0
   WHILE NOT (z! > 0 AND z! <= 1)
    INPUT "Enter rate of spiral (0-1):   ", z!
   WEND
   z! = z! ^ (1 / 16)
   CLS
   b! = a
   pi! = ATN(1) * 4
   c = 1
   DO
    FOR x = 0 TO 360
     PSET (a + b! * COS(pi! / 180 * x), a + b! * SIN(pi! / 180 * x))
     b! = b! * z!
    NEXT
   LOOP UNTIL b! < 1 OR z! = 1
   LOCATE 28: PRINT "Done"
   WHILE INKEY$ = "": WEND
 END SELECT
LOOP UNTIL num = 9
END
screenerror:
 PRINT "The chaos displayer and the spiral maker require a VGA adapter."
 WHILE INKEY$ = "": WEND
 RUN

DEFSNG A-N
SUB calcscore (x, y)
 PRINT
 IF x THEN
  PRINT "You are correct!"
  PRINT "Good job!"
  score = score + 1
 ELSE
  PRINT "The correct answer is"; STR$(y); "."
 END IF
 PRINT
END SUB

DEFINT A-W
SUB center (x, a$)
 LOCATE x, 41 - LEN(a$) / 2 + .5
 PRINT a$
END SUB

