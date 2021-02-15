// Lançamento 660 01 - COMPRAS FORNECEDOR
#include "rwmake.ch" 

User Function due009()

vLan := 0.00

IF SF1->F1_TIPO#"D"
  IF SF4->F4_CODIGO#"136".AND.SF4->F4_CODIGO#"156".AND.SF4->F4_CODIGO#"136"
         IF SF4->F4_CF=="197".OR.SF4->F4_CF=="297"
         vLan := SD1->D1_TOTAL                               
         ELSEIF SF4->F4_CODIGO=="006"                    
         vLan := SD1->D1_CUSTO                                        
         ELSE
         vLan := SD1->D1_TOTAL+SD1->D1_VALIPI
         ENDIF
    ENDIF     
ENDIF         

return(vLan)                    
