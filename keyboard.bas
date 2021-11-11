DECLARE SUB bin (x%)
CLS
DEF SEG = 0
DO
  LOCATE 1
  IF ((PEEK(1047) AND 4) = 4) THEN
    PRINT "CTRL was pressed. "
  ELSEIF ((PEEK(1047) AND 8) = 8) THEN
    PRINT "ALT was pressed.  "
  ELSEIF ((PEEK(1047) AND 1) = 1) THEN
    PRINT "SHIFT was pressed."
  END IF
LOOP

SUB bin (x%)
  FOR y% = 0 TO 7
    IF (x% AND 2 ^ y%) = 2 ^ y% THEN
      PRINT "1";
    ELSE
      PRINT "0";
    END IF
  NEXT
END SUB

