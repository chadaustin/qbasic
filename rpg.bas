DECLARE SUB other ()
DECLARE SUB KELL ()
DECLARE SUB ENDING ()
DECLARE SUB ValAlorn ()
DECLARE SUB Riva ()
DECLARE SUB tolhoneth ()
DECLARE SUB Melcene ()
DECLARE SUB vale ()
DECLARE SUB Docks ()
DECLARE SUB Inn ()
DECLARE SUB Others ()
DECLARE SUB store ()
RANDOMIZE TIMER: CLS
DIM SHARED n$, g1, r$, r1$
PRINT "Welcome to the RPG Experience!"
1 PRINT "Choose your first race"
PRINT "(H)uman"
PRINT "(D)warf"
PRINT "(E)lf"
PRINT "(G)nome"
INPUT r$
r$ = UCASE$(r$)
IF r$ = "H" THEN r1$ = "Human": st1 = 6: in1 = 6: dx1 = 6
IF r$ = "D" THEN r1$ = "Dwarf": st1 = 9: in1 = 4: dx1 = 4
IF r$ = "E" THEN r1$ = "Elf": st1 = 5: in1 = 9: dx1 = 8
IF r$ = "G" THEN r1$ = "Gnome": st1 = 6: in1 = 8: dx1 = 9
2
PRINT
PRINT "Choose your Second Race"
PRINT "(H)uman"
PRINT "(D)warf"
PRINT "(E)lf"
PRINT "(G)nome"
INPUT r1$
r1$ = UCASE$(r1$)
IF r1$ = "H" THEN st2 = 6: in2 = 6: dx2 = 6
IF r1$ = "D" THEN st2 = 9: in2 = 4: dx2 = 4
IF r1$ = "E" THEN st2 = 5: in2 = 9: dx2 = 8
IF r1$ = "G" THEN st2 = 6: in2 = 8: dx2 = 9
st = st1 + st2
in = in1 + in2
dx = dx1 + dx2
PRINT
PRINT "Your Strength is "; st
PRINT "Your Intelligence is"; in
PRINT "Your Dextirity is "; dx
PRINT
PRINT "Enter your name."
PRINT
INPUT n$
3
CLS
PRINT "Fort DragonSword"
PRINT "1.The Store"
PRINT "2.The Docks"
PRINT "3.The Other Places"
PRINT "4.The Inn"
PRINT "5.Quit"
INPUT dr1
IF dr1 = 1 THEN store
IF dr1 = 2 THEN Docks
IF dr1 = 3 THEN other
IF dr1 = 4 THEN Inn
IF dr1 = 5 THEN END
GOTO 3

SUB Docks
CLS
PRINT "1.Val Alorn"
PRINT "2.Riva"
PRINT "3.Tol Honeth"
PRINT "4.Kell"
PRINT "5.Melcene"
PRINT "6.The Vale of Aldur"
INPUT T1
IF T1 = 1 THEN ValAlorn
IF T1 = 2 THEN Riva
IF T1 = 3 THEN tolhoneth
IF T1 = 4 THEN KELL
IF T1 = 5 THEN Melcene
IF T1 = 6 THEN vale
END SUB

SUB ENDING
PRINT "You have won the Eddings Game!"
PRINT "This was programmed by the Mad Hacker and ShadowTalon"
PRINT "Send us money! Please!"
END
END SUB

SUB Inn
200
CLS
PRINT "1.Get a room"
PRINT "2.Wake up another person"
PRINT "3.Buy food and drink"
PRINT "4.Talk to Barkeep"
PRINT "5.Do something to barmaid"
PRINT "6.Talk to old storyteller"
PRINT "7.Leave"
INPUT I1
IF I1 = 1 THEN GOTO 202
IF I1 = 2 THEN GOTO 205
IF I1 = 3 THEN GOTO 210
IF I1 = 4 THEN GOTO 220
IF I1 = 5 THEN GOTO 230
IF I1 = 6 THEN GOTO 240
IF I1 = 7 THEN GOTO 299
202
205
210 PRINT "You buy a good meal and get roaring drunk soon.": INPUT I1: GOTO 200
220 PRINT "This game is not registered!": INPUT I1: GOTO 200
230 PRINT "1.Wink."
PRINT "2.Smile"
PRINT "3.Peck her on the lips"
PRINT "4.Invite her to sit on your lap"
PRINT "5.Feel her backside."
PRINT "6.Fondle her bosom"
PRINT "7.Kiss her passionatly"
PRINT "8.Take her to the BackRoom"
PRINT "9.Take her on the table"
PRINT "10.Take her on your horse."
INPUT I1
IF I1 = 1 THEN PRINT "She blushes!.": INPUT p1: GOTO 200
IF I1 = 2 THEN PRINT "She smiles back!": INPUT p1: GOTO 200
IF I1 = 3 THEN PRINT "She wraps her arms around you and presses her body against yours.": INPUT p1: GOTO 200
IF I1 = 4 THEN PRINT "She accepts and rubs all over.": INPUT p1: GOTO 200
240 PRINT "Seek the Orb.  It tells all to the Chosen One.": WHILE INKEY$ = "": WEND: GOTO 200
299 END SUB

SUB KELL
400
CLS
PRINT "1.Seek advice from the Seers"
PRINT "2.Seek advice from the Diviners"
PRINT "3.Seek advice from the Necromancers"
PRINT "4.Leave"
INPUT k1
IF k1 = 1 THEN GOTO 401
IF k1 = 2 THEN GOTO 402
IF k1 = 3 THEN GOTO 403
IF k1 = 4 THEN GOTO 499
GOTO 400
401 PRINT "You must take control of all the kingdoms to get the Orb at Riva."
GOTO 999
402 PRINT "You must buy up the Council of Advidsors in Tol Honeth to become Emperor."
GOTO 999
403 PRINT "You must take economic control of Melcena."
999
WHILE INKEY$ = "": WEND
GOTO 400
499 END SUB

SUB Melcene
500
CLS
PRINT "1. Buy Stocks."
PRINT "2. Sell Stocks"
PRINT "3. Buy Products"
PRINT "4. Sell Products"
PRINT "5. Leave"
INPUT m1
IF m1 = 1 THEN GOTO 501
IF m1 = 2 THEN GOTO 505
IF m1 = 3 THEN GOTO 510
IF m1 = 4 THEN GOTO 515
IF m1 = 5 THEN GOTO 599
GOTO 500
501
CLS
PRINT "Invest in:"
PRINT "1.A Diamond Mine"
PRINT "2.The Elephants at Gahnadar"
PRINT "3.The Cherek Shipbuilders"
PRINT "4.The Shady Buisness"
INPUT m2
IF m1 = 1 THEN GOTO 502
IF m1 = 2 THEN GOTO 503
IF m1 = 3 THEN GOTO 504
IF m1 = 4 THEN GOTO 504.5
GOTO 500
502 PRINT "Costs 500 to purchase"
PRINT "Esimated Return of 50000"
PRINT "Presige points 50"
PRINT "Buy Y/N"
INPUT m1$
m1$ = UCASE$(m1$)
IF m1$ = "Y" AND m1 > 499 THEN I1$ = "Diamond Mine": m1 = m1 - 500: GOTO 500 ELSE GOTO 500
503 PRINT "Costs 400 to purchase"
PRINT "Esimated Return of 4000"
PRINT "Presige 30"
PRINT "Buy Y/N"
INPUT m2$
m2$ = UCASE$(m2$)
IF m2$ = "Y" AND m1 > 399 THEN I1$ = "Elephant Market": m1 = 1 - 400: GOTO 500 ELSE GOTO 500
504 PRINT "Costs 300 to purchase"
PRINT "Esimated return of 1000"
PRINT "Presige 25"
PRINT "Buy Y/N"
INPUT m3$
m3$ = UCASE$(m3$)
IF m3$ = "Y" AND m1 > 299 THEN I1$ = "Shipbuilding": m1 = m1 - 300: GOTO 500 ELSE GOTO 500
504.5 PRINT "Costs 200 to purchase"
PRINT "Esimated return of 10000"
PRINT "Presige 50"
PRINT "Buy Y/N"
INPUT m4$
m4$ = UCASE$(m4$)
IF m4$ = "Y" AND m1 > 199 THEN I1$ = "Illegal Buisness": m1 = m1 - 200: GOTO 500 ELSE GOTO 500
505 IF I1$ = "" THEN PRINT "You have nothing to sell!": GOTO 500
PRINT "Do you wish to sell "; I1$; "?"
PRINT "Y/N"
INPUT m2$
m2$ = UCASE$(m2$)
IF m2$ = "Y" THEN GOTO 506 ELSE GOTO 500
506 IF I1$ = "Illegal Buisness" THEN s1 = INT(RND * 10): s2 = 5
IF I1$ = "Shipbuilding" THEN s1 = INT(RND * 10): s2 = 4
510
515
599 END SUB

SUB other
END SUB

SUB Riva
300
CLS
PRINT "1.Steal Orb."
PRINT "2.Leave"
INPUT r1
IF r1 = 1 THEN GOTO 301
IF r1 = 2 THEN GOTO 399
GOTO 300
301 IF c1 > 1000 THEN
 PRINT "You stole the Orb!  You are now the Keeper of the Orb!  With you empire behind you,  You  rule the world!"
 WHILE INKEY$ = "": WEND
 ENDING
ELSE
 PRINT "You fail and have to escape."
 WHILE INKEY$ = "": WEND
 GOTO 399
END IF
399 END SUB

SUB store
0.5
CLS
PRINT "1.Buy Jewels."
PRINT "2.Buy Gold Bars"
PRINT "3.Buy a Old Tolnerdan"
PRINT "4.Exit"
INPUT s5
IF s5 = 1 AND g1 > 9 THEN PRINT "You bought a Jewel": g1 = g1 - 10: g2 = g2 + 1
IF s5 = 2 AND g1 > 99 THEN PRINT "You Bought a Gold Bar": g1 = g1 - 100: g3 = g3 + 1
IF s5 = 3 AND g1 > 999 THEN PRINT "You bought a Old Tolnedran"; g1 = g1 - 1000: g4 = g4 + 1
IF s5 = 4 THEN GOTO 0.7 ELSE WHILE INKEY$ = "": WEND
GOTO 0.5
0.7
END SUB

SUB tolhoneth
END SUB

SUB ValAlorn
CLS
100 PRINT "1.Go to the castle."
PRINT "2.Visit the Shipyards."
PRINT "3.Return to Fort DragonSword"
INPUT a1
IF a1 = 1 THEN GOTO 101
IF a1 = 2 THEN GOTO 105
IF a1 = 3 THEN GOTO 199
GOTO 100
101 : PRINT "Welcome to the Castle of King Anheg!"
PRINT "1. Overthrow King"
PRINT "2.Ally yourself with a Clan"
PRINT "3.Leave"
INPUT c1
IF c1 = 1 THEN GOTO 103
IF c1 = 2 THEN GOTO 104
103 CLS : IF c2 = 2 THEN PRINT "You overthrew him with the help of the clan.  You are now the King of Cherek!": INPUT p1: ch1 = 1: ch = ch + 50: g1 = g1 + 10000 ELSE PRINT "You failed and were exiled from Val Alorn.": exile1 = 1: GOTO 100
104 CLS : IF c2 = 0 THEN PRINT "You are now allied with an anti-king clan.": c2 = 2: GOTO 101
105
199 END SUB

SUB vale
END SUB

