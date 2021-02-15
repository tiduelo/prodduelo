#include "rwmake.ch"

User Function LP_FOLHA(_cTipo)

//
// Contabilizacao de proventos
//
_cArea := Alias()
_nOrd  := IndexOrd()
_nReg  :=RecNo()

DbSelectArea("SZX")
dbsetorder(1)
DbGotop()

if _ctipo <> nil
	
	_cTipo     := upper(alltrim(_cTipo))
	
	if ! (_cTipo $ "DC")
		Alert("O parametro so pode ser D ou C")
		_cConta    := "VERBA "+SRZ->RZ_PD
	Else
		
		_cContaALL := ""
		_cConta    := ""
		
		dbseek(xfilial("SZX")+SRZ->RZ_PD,.F.)
		
		Do While ! eof() .and. ZX_PD == SRZ->RZ_PD
			
			if ZX_CC == SRZ->RZ_CC
				if _cTipo == "D"
					_cConta    := ZX_DEBITO
				Else
					_cConta    := ZX_CREDITO
				Endif
			Endif
			
			if empty(ZX_CC)
				IF  !empty(ZX_DEBITO)  .and.  _cTipo == "D"
					_cContaALL := ZX_DEBITO
				Endif
				
				IF  !empty(ZX_CREDITO)  .and.  _cTipo == "C"
					_cContaALL := ZX_CREDITO
				Endif
			Endif			
			dbskip()			
		Enddo		
		if empty(_cConta)
			if !empty(_cContaALL)
				_cConta    := _cContaALL
			Else
				_cConta    := "VERBA "+SRZ->RZ_PD
			Endif
		Endif
		
	Endif
Else
	Alert("Precisa informar o parametro D ou C na funcao")
	_cConta    := "VERBA "+SRZ->RZ_PD
Endif

dbselectarea(_cArea)
dbsetorder(_nOrd)
dbgoto(_nReg)
return(_cConta)
