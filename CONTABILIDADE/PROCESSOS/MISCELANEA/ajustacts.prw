#include "rwmake.ch"
#include "topconn.ch"

User Function ajustacts()


if msgyesno("Ajusta Tabela de Visao Gerencial?")
	Processa( {|| ajustaok() } )
Endif

return nil

//////////////////////////////////////////////////////////////
Static Function ajustaok()
Local _i := 0

dbSelectArea("CTS")
dbsetorder(0)
dbgotop()

Do while ! eof()

	if reclock("CTS",.f.)
		
		CTS->CTS_ORDEM := "X"+substr(CTS->CTS_ORDEM,2)
		
		if CTS->CTS_CODPLA == "XBL"
			CTS->CTS_CODPLA := "BAL"
			CTS->CTS_NOME   := "BALANCO PATRIMONIAL"
		Endif
		
		if CTS->CTS_CODPLA == "XDR"
			CTS->CTS_CODPLA := "DRE"
			CTS->CTS_NOME   := "DEMONSTRACAO DE RESULTADO"
		Endif
		
		msunlock()
		
	Endif

	dbskip()

Enddo

dbsetorder(1)
dbgotop()

procregua(reccount())

Do While ! eof()
	
	_aContas := {}
	_nCtd    := 1
	
	_nrecAtu := 0
	
	_codpla  := cts_codpla
	
	Do while ! eof() .and. 	_codpla == cts_codpla
		
		_ordem     := cts_ordem
		_NovaOrdem := strzero(_nCtd,10)
		
		Do while ! eof() .and. 	_codpla == cts_codpla .and. _ordem   == cts_ordem
			
			incproc()
			
			if reclock("CTS",.f.)
				
				aadd(_aContas,{recno(),cts_contag,_NovaOrdem})
				
				CTS->CTS_ORDEM  := _NovaOrdem
				CTS->CTS_CONTAG := _NovaOrdem
				
				msunlock()
				
			Endif
			
			dbskip()
			
			_nrecAtu := recno()
			
			_leof := .f.
			
			if eof()
				_leof := .t.
			Endif
			
		Enddo
		
		_nCtd += 10
		
	Enddo
	
	For _i:= 1 to len(_aContas)
		
		dbgoto(_aContas[_i][1])
		
		if !empty(CTS->CTS_CTASUP)
			
			_n := aScan(_aContas,{ |X| X[2] == CTS->CTS_CTASUP })
			
			if _n > 0
				
				if reclock("CTS",.f.)
					CTS->CTS_CTASUP := _aContas[_N][3]
					msunlock()
				Endif
				
			Endif
		Endif
	Next
	
	if _leof
		exit
	Else
		dbgoto(_nrecAtu)
	Endif
	
Enddo

return nil

