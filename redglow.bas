SCREEN 13
DO
 FOR x% = 0 TO 63
   PALETTE 0, x%
   IF INKEY$ <> "" THEN EXIT DO
 NEXT
 FOR x% = 62 TO 0 STEP -1
   PALETTE 0, x%
   IF INKEY$ <> "" THEN EXIT DO
 NEXT
LOOP
SCREEN 0
WIDTH 80

SUB delay (x)
 a = TIMER
 DO
 LOOP UNTIL TIMER - a > x
END SUB

