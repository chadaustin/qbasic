DEFINT A-Z
CLS
INPUT "Enter x: ", x
INPUT "Enter y: ", y
PRINT
IF x > y THEN z = x ELSE z = y
FOR a = z TO 1 STEP -1
  IF x / a = INT(x / a) AND y / a = INT(y / a) THEN
    PRINT "GCF ="; a
    PRINT "X / GCF ="; x / a
    PRINT "Y / GCF ="; y / a
    END
  END IF
NEXT

