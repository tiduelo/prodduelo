#include "rwmake.ch"

User Function LPFOLHA(_cTp)
//
// Contabilizacao de proventos
//
// _cTp = 1-Normal / 2=Contra partida
//

_cArea 	:= GetArea()

_cCC   	:= SRZ->RZ_CC
_cPD   	:= SRZ->RZ_PD
_cConta	:= "VERBA "+SRZ->RZ_PD

DbSelectArea("SZ0")
dbsetorder(1)
dbSeek(xFilial("SZ0")+_cPD)
if Found()
	
	_cTipo := GetAdvFVal("CTT","CTT_TPCUST",xFilial("CTT")+_cCC,1,"X")
	
	if _cTp == '1' // Normal (Crédito ou Débito)
		
		if _cTipo == 'A' //Administrativo
			if empty(SZ0->Z0_ADM)
				Alert("Necessário Configurar a Verba -("+SRZ->RZ_PD+") com a conta Administrativa")
			else
				_cConta := SZ0->Z0_ADM
			Endif
		ElseIf _cTipo == 'C' //Comercial
			if empty(SZ0->Z0_COM)
				Alert("Necessário Configurar a Verba -("+SRZ->RZ_PD+") com a conta Comercial")
			else
				_cConta := SZ0->Z0_COM
			Endif
		ElseIf _cTipo == 'P' //Produção
			if empty(SZ0->Z0_PRO)
				Alert("Necessário Configurar a Verba -("+SRZ->RZ_PD+") com a conta Produção")
			else
				_cConta := SZ0->Z0_PRO
			Endif
		ElseIf _cTipo == 'X' //Não configurado
			Alert("Verificar Tipo de Custo no Cadastro do C. Custo "+Alltrim(SRZ->RZ_CC))
		Endif
		
	Elseif _cTp == '2' // Contra Partida
		
		if empty(SZ0->Z0_PARTIDA) // Conta de Contra Partida não informada
			Alert("Necessário Configurar a Verba -("+SRZ->RZ_PD+") com a conta de Contra Partida")
		Else
			_cConta := SZ0->Z0_PARTIDA
		Endif
	Endif
Else
	Alert("Necessário Configurar a Verba -("+SRZ->RZ_PD+") para contabilização")
Endif

RestArea(_cArea)

Return(_cConta)
