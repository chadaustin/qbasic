DECLARE SUB Detect (a$)
CLS
ON ERROR GOTO vga
SCREEN 12
Detect "VGA"
vga:
 ON ERROR GOTO mcga
 SCREEN 13
 Detect "MCGA"
mcga:
 ON ERROR GOTO ega64k:
 SCREEN 9, , 1, 1
 Detect "EGA 64K+"
ega64k:
 ON ERROR GOTO ega:
 SCREEN 9
 Detect "EGA < 64K"
ega:
 ON ERROR GOTO cga:
 SCREEN 1
 Detect "CGA"
cga:
 ON ERROR GOTO Hercules
 SCREEN 3
 Detect "Hercules"
Hercules:
 ON ERROR GOTO olivetti
 SCREEN 4
 Detect "Olivetti"
olivetti:
 PRINT "Neither VGA, MCGA, EGA, CGA, Hercules, or Olivetti detected"

SUB Detect (a$)
 SCREEN 0
 PRINT "        Video card identifier"
 PRINT "        Chad Austin"
 PRINT "        12/28/95"
 PRINT
 PRINT "        "; a$; " detected"
 END
END SUB

