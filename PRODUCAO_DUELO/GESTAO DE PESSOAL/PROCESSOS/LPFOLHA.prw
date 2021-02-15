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
	
	if _cTp == '1' // Normal (Cr�dito ou D�bito)
		
		if _cTipo == 'A' //Administrativo
			if empty(SZ0->Z0_ADM)
				Alert("Necess�rio Configurar a Verba -("+SRZ->RZ_PD+") com a conta Administrativa")
			else
				_cConta := SZ0->Z0_ADM
			Endif
		ElseIf _cTipo == 'C' //Comercial
			if empty(SZ0->Z0_COM)
				Alert("Necess�rio Configurar a Verba -("+SRZ->RZ_PD+") com a conta Comercial")
			else
				_cConta := SZ0->Z0_COM
			Endif
		ElseIf _cTipo == 'P' //Produ��o
			if empty(SZ0->Z0_PRO)
				Alert("Necess�rio Configurar a Verba -("+SRZ->RZ_PD+") com a conta Produ��o")
			else
				_cConta := SZ0->Z0_PRO
			Endif
		ElseIf _cTipo == 'X' //N�o configurado
			Alert("Verificar Tipo de Custo no Cadastro do C. Custo "+Alltrim(SRZ->RZ_CC))
		Endif
		
	Elseif _cTp == '2' // Contra Partida
		
		if empty(SZ0->Z0_PARTIDA) // Conta de Contra Partida n�o informada
			Alert("Necess�rio Configurar a Verba -("+SRZ->RZ_PD+") com a conta de Contra Partida")
		Else
			_cConta := SZ0->Z0_PARTIDA
		Endif
	Endif
Else
	Alert("Necess�rio Configurar a Verba -("+SRZ->RZ_PD+") para contabiliza��o")
Endif

RestArea(_cArea)

Return(_cConta)
