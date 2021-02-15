
// PE ANTES DO CANCELAMENTO DA BAIXA NO FINANCEIRO

#include "rwmake.ch"

User Function GDP003()

_cRet := PADR( ALLTRIM( SE1->E1_PREFIXO + SUBSTR(SE1->E1_NUM,4,6) + SE1->E1_PARCELA ), 10 , "1" )

Return (_cRet  )


User Function FIN001()
Local _cRetFin := ""

_cRetFin := SUBSTR(SE1->E1_PREFIXO,3,1)+SUBSTR(SE1->E1_NUM,4,6)+IIF(empty(Alltrim(SE1->E1_PARCELA)),"1",Alltrim(SE1->E1_PARCELA))

Return (_cRetFin)
