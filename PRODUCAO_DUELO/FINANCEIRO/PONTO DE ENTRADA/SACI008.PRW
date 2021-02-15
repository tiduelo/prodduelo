
// PE DEPOIS DA BAIXA DO CONTAS A RECEBER

#include "rwmake.ch"

User Function saci008()

if reclock("SE5",.F.)
	SE5->E5_BXAUSU := CUSERNAME
	SE5->E5_BXADAT := date()
	SE5->E5_BXAHOR := time()
	msunlock()
Endif

Return nil

