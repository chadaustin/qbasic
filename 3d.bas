DEFINT A-Z

TYPE p
  x AS INTEGER
  y AS INTEGER
  z AS INTEGER
END TYPE

DIM pv1 AS p, pv2 AS p
FOR x = 0 TO 319
 pv1.x = x
 pv2.x = x
 pv1.z = 0
 pv2.z = 320
 LINE (D * pv1.x / pv1.z, D * pv1.y / pv1.z)-(D * pv2.x / pv2.z, D * pv2.y / pv2.z)
 CLS
NEXT

