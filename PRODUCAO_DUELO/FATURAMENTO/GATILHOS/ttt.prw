#include "rwmake.ch"

user function ttt()

Use "SX25"    Alias SX25 New 
INDEX ON X2_CHAVE TO TT1

Use "SX24"    Alias SX24 New 
DBGOTOP()

RptStatus({|| RptDetail() })

Return

Static Function RptDetail()

SETREGUA(RECCOUNT())

WHILE !EOF()
      INCREGUA()
      _Key:=X2_CHAVE
      DBSELECTAREA("SX25")
      DBSEEK(_KEY)
      IF !FOUND()
         ALERT(_KEY)
      ENDIF
      DBSELECTAREA("SX24")
      DBSKIP()
ENDDO
DBCLOSEAREA()
         

return nil
