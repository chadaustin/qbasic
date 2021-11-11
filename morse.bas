DECLARE SUB morse (a$)
DECLARE SUB morseStr (a$)

DIM SHARED code$(28)
code$(0) = ".-"                      'A
code$(1) = "-..."                    'B
code$(2) = "-.-."                    'C
code$(3) = "-.."                     'D
code$(4) = "."                       'E
code$(5) = "..-."                    'F
code$(6) = "--."                     'G
code$(7) = "...."                    'H
code$(8) = ".."                      'I
code$(9) = ".---"                    'J
code$(10) = "-.-"                    'K
code$(11) = ".-.."                   'L
code$(12) = "--"                     'M
code$(13) = "-."                     'N
code$(14) = "---"                    'O
code$(15) = ".--."                   'P
code$(16) = "--.-"                   'Q
code$(17) = ".-."                    'R
code$(18) = "..."                    'S
code$(19) = "-"                      'T
code$(20) = "..-"                    'U
code$(21) = "...-"                   'V
code$(22) = ".--"                    'W
code$(23) = "-..-"                   'X
code$(24) = "-.--"                   'Y
code$(25) = "--.."                   'Z
code$(26) = ".-.-.-"                 '.
code$(27) = "--..--"                 ',
code$(28) = "..--.."                 '?

INPUT "Enter string: ", mc$
morseStr mc$

SUB morse (a$)
 PLAY "mfo2"
 FOR x = 1 TO LEN(a$)
   IF MID$(a$, x, 1) = "-" THEN
     PLAY "l6"
   ELSE
     PLAY "l12"
   END IF
   PLAY "b"
 NEXT
END SUB

SUB morseStr (a$)
  FOR x = 1 TO LEN(a$)
    value = ASC(UCASE$(MID$(a$, x, 1)))
    SELECT CASE value
      CASE 32
        delay! = TIMER
        WHILE TIMER - delay! < .5: WEND

      CASE 65 TO 90
        morse code$(ASC(UCASE$(MID$(a$, x, 1))) - 65)
      
      CASE ASC(".")
        morse code$(26)

      CASE ASC(",")
        morse code$(27)

      CASE ASC("?")
        morse code$(28)
      
    END SELECT

    delay! = TIMER
    WHILE TIMER - delay! < 1: WEND
  NEXT
END SUB

