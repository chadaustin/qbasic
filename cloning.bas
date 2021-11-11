'Chad Austin
'Dustyn Goos
'
'Cloning Project
'Period 1
'
'
'Press <SHIFT>+<F5> to run again.
'
'Press <ALT>, F, X to quit.
'
'
'
'
'
'
'
'
DEFINT A-Z
DECLARE SUB center (x%, a$)
DECLARE SUB delay (x!)
DECLARE SUB drawcells (x%)
DECLARE SUB drawnucleus (x%, y%)
DECLARE SUB growtwins (x%, y%)
DECLARE SUB lightning ()
DECLARE SUB multcells (x%)
DECLARE SUB multcells2 (x%, y%)
DECLARE SUB msg (x%, y%, a$)
DECLARE SUB smallcell (x%, y%)
DECLARE SUB tinycell (x%, y%)

CONST membrane = 10
CONST nucleus1 = 12
CONST nucleus2 = 9

RANDOMIZE TIMER

SCREEN 12
DO
  CLS
  COLOR 9
  center 2, "‹ﬂﬂﬂﬂ‹  €       ‹ﬂﬂﬂﬂ‹  €‹   €  ﬂﬂ€ﬂﬂ  €‹   €  ‹ﬂﬂﬂﬂ‹"
  center 3, "€    ﬂ  €       €    €  € ﬂ‹ €    €    € ﬂ‹ €  €     "
  center 4, "€       €       €    €  €   ﬂ€    €    €   ﬂ€  €     "
  center 5, "€       €       €    €  €    €    €    €    €  €  ‹‹‹"
  center 6, "€    ‹  €       €    €  €    €    €    €    €  €    €"
  center 7, "ﬂ‹‹‹‹ﬂ  €‹‹‹‹‹  ﬂ‹‹‹‹ﬂ  €    €  ‹‹€‹‹  €    €  ﬂ‹‹‹‹ﬂ"
  COLOR 14
  center 9, "Chad Austin"
  center 10, "Dustyn Goos"
  COLOR 15
  center 13, "    There are two methods of cloning.  The first is accomplished"
  center 14, "by taking the nucleus out of a cell from the person you want to "
  center 15, "clone.  The nucleus is placed in an egg cell.  This cell is     "
  center 16, "placed in a uterus to grow.  The mother will then have a child. "
  center 17, "This child will be a clone since it has the same genetic        "
  center 18, "information as the cloned person.  The second method takes a    "
  center 19, "developing zygote and forces twins to grow.  This is done by    "
  center 20, "taking a four-celled zygote and splitting it in half.  Each half"
  center 21, "will then divide separately to become twins.                    "
  center 25, "1) Method One"
  center 26, "2) Method Two"
  center 27, "3) Quit      "
  x = 0
  WHILE x < 1 OR x > 3
    x = VAL(INKEY$)
  WEND
  CLS
  IF x = 3 THEN END

  IF x = 1 THEN

    drawcells 0
    msg 23, 1, "The nucleus of cell 1 is taken out."
    msg 24, 1, "Press any key to continue."
    WHILE INKEY$ = "": WEND
    FOR x = 1 TO 4
      CLS
      drawcells x
      delay .25
    NEXT

    msg 23, 1, "Then, the nucleus in cell 2 is moved to cell 1."
    msg 24, 1, "Press any key to continue."
    WHILE INKEY$ = "": WEND
    FOR x = 5 TO 9
      CLS
      drawcells x
      delay .25
    NEXT

    msg 23, 1, "Cell number 2 is not needed any more."
    msg 24, 1, "Press any key to continue."
    WHILE INKEY$ = "": WEND
    CLS
    drawcells 10

    msg 23, 1, "Next, the cell is electrified to start the growing process."
    msg 24, 1, "Press any key to continue."
    WHILE INKEY$ = "": WEND
    FOR x = 0 TO 3
      CLS
      drawcells 10
      delay .2
      lightning
      delay .3
    NEXT

    msg 23, 1, "Lastly, the cell multiplies and grows into a clone."
    msg 24, 1, "Press any key to continue."
    WHILE INKEY$ = "": WEND
    FOR x = 0 TO 4
      CLS
      multcells x
      delay .5
    NEXT

  ELSE

    smallcell 280, 140
    smallcell 360, 140
    smallcell 280, 220
    smallcell 360, 220

    msg 23, 1, "A four-celled zygote is divided down the middle."
    msg 24, 1, "Press any key to continue."
    WHILE INKEY$ = "": WEND
    FOR x = 0 TO 120 STEP 30
      CLS
      LINE (320, 0)-(320, 349)
      smallcell 280 - x, 140
      smallcell 360 + x, 140
      smallcell 280 - x, 220
      smallcell 360 + x, 220
      delay .2
    NEXT

    msg 23, 1, "Both halves divide normally and grow into twins."
    msg 24, 1, "Press any key to continue."
    WHILE INKEY$ = "": WEND
    FOR x = 0 TO 4
      CLS
      growtwins x, 160
      growtwins x, 480
      LINE (320, 0)-(320, 479)
      delay .3
    NEXT

  END IF
  msg 29, 1, "Demo complete"
  WHILE INKEY$ = "": WEND
LOOP

SUB center (x, a$)
  LOCATE x, 41 - LEN(a$) / 2!
  PRINT a$
END SUB

SUB delay (x!)
  a! = TIMER
  WHILE TIMER - a! < x!: WEND
END SUB

SUB drawcells (x)
  CIRCLE (100, 200), 100, membrane
  PAINT (100, 200), membrane, membrane
  msg 5, 10, "Cell 1"
  IF x < 10 THEN
    CIRCLE (539, 200), 100, membrane
    PAINT (539, 200), membrane, membrane
    msg 5, 65, "Cell 2"
  END IF
  COLOR nucleus2
  SELECT CASE x
    CASE 0
      COLOR nucleus1: drawnucleus 80, 220
      COLOR nucleus2: drawnucleus 530, 180
    CASE 1
      COLOR nucleus1: drawnucleus 60, 160
      COLOR nucleus2: drawnucleus 530, 180
    CASE 2
      COLOR nucleus1: drawnucleus 40, 100
      COLOR nucleus2: drawnucleus 530, 180
    CASE 3
      COLOR nucleus1: drawnucleus 20, 40
      COLOR nucleus2: drawnucleus 530, 180
    CASE 4: drawnucleus 530, 180
    CASE 5: drawnucleus 450, 160
    CASE 6: drawnucleus 350, 130
    CASE 7: drawnucleus 250, 100
    CASE 8: drawnucleus 150, 140
    CASE 9, 10: drawnucleus 100, 180
  END SELECT
  COLOR 15
END SUB

SUB drawnucleus (x, y)
  CIRCLE (x, y), 30
  PAINT (x, y)
END SUB

SUB growtwins (x, y)
  SELECT CASE x
    CASE 0:
      tinycell y - 20, 220
      tinycell y - 20, 260
      tinycell y + 20, 220
      tinycell y + 20, 260

    CASE 1:
      tinycell y - 60, 220
      tinycell y - 60, 260
      tinycell y - 20, 220
      tinycell y - 20, 260

      tinycell y + 20, 220
      tinycell y + 20, 260
      tinycell y + 60, 220
      tinycell y + 60, 260

    CASE 2:
      tinycell y - 60, 180
      tinycell y - 60, 220
      tinycell y - 20, 180
      tinycell y - 20, 220
      tinycell y + 20, 180
      tinycell y + 20, 220
      tinycell y + 60, 180
      tinycell y + 60, 220

      tinycell y - 60, 260
      tinycell y - 60, 300
      tinycell y - 20, 260
      tinycell y - 20, 300
      tinycell y + 20, 260
      tinycell y + 20, 300
      tinycell y + 60, 260
      tinycell y + 60, 300

    CASE 3:
      tinycell y - 140, 180
      tinycell y - 140, 220
      tinycell y - 100, 180
      tinycell y - 100, 220
      tinycell y - 60, 180
      tinycell y - 60, 220
      tinycell y - 20, 180
      tinycell y - 20, 220

      tinycell y - 140, 260
      tinycell y - 140, 300
      tinycell y - 100, 260
      tinycell y - 100, 300
      tinycell y - 60, 260
      tinycell y - 60, 300
      tinycell y - 20, 260
      tinycell y - 20, 300

      tinycell y + 20, 180
      tinycell y + 20, 220
      tinycell y + 60, 180
      tinycell y + 60, 220
      tinycell y + 100, 180
      tinycell y + 100, 220
      tinycell y + 140, 180
      tinycell y + 140, 220

      tinycell y + 20, 260
      tinycell y + 20, 300
      tinycell y + 60, 260
      tinycell y + 60, 300
      tinycell y + 100, 260
      tinycell y + 100, 300
      tinycell y + 140, 260
      tinycell y + 140, 300

    CASE 4:
      FOR a = 0 TO 7
        FOR b = 0 TO 7
          tinycell y - 140 + a * 40, b * 40 + 80
        NEXT
      NEXT

  END SELECT
END SUB

SUB lightning
  LINE (400, 0)-(260, 50)
  LINE (260, 50)-(280, 70)
  LINE (280, 70)-(200, 100)
  LINE (200, 100)-(220, 120)
  LINE (220, 120)-(160, 150)
  LINE (160, 150)-(250, 150)
  LINE (250, 150)-(240, 120)
  LINE (240, 120)-(320, 80)
  LINE (320, 80)-(310, 60)
  LINE (310, 60)-(500, 0)
  LINE (500, 0)-(400, 0)
  PAINT (400, 1), 15, 15
END SUB

SUB msg (x, y, a$)
 LOCATE x, y
 PRINT a$;
END SUB

SUB multcells (x)
  SELECT CASE x
    CASE 0:
      smallcell 320, 240
    CASE 1:
      smallcell 280, 240
      smallcell 360, 240
    CASE 2:
      smallcell 280, 200
      smallcell 360, 200
      smallcell 280, 280
      smallcell 360, 280
    CASE 3:
      smallcell 200, 200
      smallcell 280, 200
      smallcell 200, 280
      smallcell 280, 280

      smallcell 360, 200
      smallcell 440, 200
      smallcell 360, 280
      smallcell 440, 280
    CASE 4:
      smallcell 200, 120
      smallcell 280, 120
      smallcell 200, 200
      smallcell 280, 200
      smallcell 360, 120
      smallcell 440, 120
      smallcell 360, 200
      smallcell 440, 200

      smallcell 200, 280
      smallcell 280, 280
      smallcell 200, 360
      smallcell 280, 360
      smallcell 360, 280
      smallcell 440, 280
      smallcell 360, 360
      smallcell 440, 360

  END SELECT
END SUB

SUB smallcell (x, y)
  CIRCLE (x, y), 30, membrane
  PAINT (x, y), membrane, membrane
  CIRCLE (x + INT(RND * 9) - 4, y + INT(RND * 9) - 4), 10, nucleus2
  PAINT (x, y), nucleus2, nucleus2
END SUB

SUB tinycell (x, y)
  CIRCLE (x, y), 15, membrane
  PAINT (x, y), membrane, membrane
  CIRCLE (x + INT(RND * 3) - 1, y + INT(RND * 3) - 1), 4, nucleus2
  PAINT (x, y), nucleus2, nucleus2
END SUB

