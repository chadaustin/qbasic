DECLARE SUB question (a$, b$, c$, d$, e$, f$)
DIM SHARED score%
CLS
PRINT "Quiz Program"
PRINT "Chad Austin"
PRINT
PRINT "Subject:  The Hobbit, Lord of the Rings, and the Silmarillion"
PRINT "          (Tolkien Mythology)"
PRINT
PRINT "Press any key to continue"
WHILE INKEY$ = "": WEND
question "1) What is Bilbo's relation to Frodo?", "Brother", "Father", "Cousin", "Grandfather", "C"
question "2) Where did Frodo meet his first balrog?", "The Iron Hills", "Khazad-Dum", "Minas Tirith", "Mount Doom", "B"
question "3) Who is the Dark King?", "The Nazgul Lord", "Boromir", "Sauron", "Mithrandir", "C"
question "4) What is the name of Bilbo's sword?", "Glamdring", "Biter", "Beater", "Sting", "D"
question "5) Who bit off Frodo's finger at the end of The Return of the King?", "Gollum", "Merry", "Sauron", "Sam", "A"
question "6) Where is Bilbo's home?", "The Shire", "Minas Tirith", "Minas Morgul", "Calembel", "A"
question "7) Aragorn (Strider) was of what group?", "Hunters", "Dunedain", "Heavy Infantry of Gondor", "Elves of Elrond", "B"
question "8) Who killed Saruman?", "Bilbo", "Gandalf", "Smaug", "Wormtongue", "D"
question "9) Who created the gods?", "Sauron", "Gandalf the Grey", "Iluvatar", "Elessar", "C"
question "10) Who created evil?", "Sauron", "Melkor", "Aragorn", "Celeborn", "B"
CLS
PRINT "You got"; score%; "out of 10 correct!"
SELECT CASE score%
 CASE IS = 10: PRINT "PERFECT!"
 CASE IS > 7: PRINT "Good job!"
 CASE IS > 4: PRINT "You did okay."
 CASE IS > 2: PRINT "You could have done better."
 CASE ELSE: PRINT "Read those books again."
END SELECT
x! = TIMER
DO: LOOP UNTIL TIMER - x! > .5
WHILE INKEY$ <> "": WEND
WHILE INKEY$ = "": WEND

SUB question (a$, b$, c$, d$, e$, f$)
 CLS
 PRINT a$
 PRINT "    A. "; b$
 PRINT "    B. "; c$
 PRINT "    C. "; d$
 PRINT "    D. "; e$
 PRINT
 PRINT "Answer:"
 WHILE g$ < "A" OR g$ > "D"
  g$ = UCASE$(INKEY$)
 WEND
 IF g$ = f$ THEN score% = score% + 1
END SUB

