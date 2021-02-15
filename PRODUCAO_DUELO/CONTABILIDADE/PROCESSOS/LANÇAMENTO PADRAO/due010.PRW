// Lançamento 650 01 - COMPRAS FORNECEDOR
#include "rwmake.ch" 

User Function due010()
vLan := 0.00

IF SF4->F4_DUPLIC=='N'
  IF SF4->F4_CF=="121".OR.SF4->F4_CODIGO#"006"
         IF SD1->D1_TIPO=='D'
         vLan := 0.00                               
         ELSEIF SF4->F4_CF=="197".OR.SF4->F4_CF=="297"
         vLan := SD1->D1_CUSTO                                        
         ELSE
         vLan := SD1->D1_TOTAL+SD1->D1_VALIPI
         ENDIF
    ENDIF     
ENDIF         

return(vLan)                    
