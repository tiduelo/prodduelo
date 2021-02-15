#INCLUDE "rwmake.ch"
////////////////////////////////////////////////////////////////////////////////////////////////
// Processo GDP008 - Rotinas da Folha de Pagamento para calculo de tabelas
// Criado em 30-11-09 por Nilson                                                              //
// Utiliza tabelas na pasta \DATA para interface com os funcionários
////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////
/////////////////////
User Function GDP008(_cTabela,_nsalario)
/////////////////////
/////////////////////
aSvAlias :={Alias(),IndexOrd(),Recno()}

_cTabela  := alltrim(upper(_cTabela))
_nRetorno := 0

if  _cTabela  $ "U001/U002"
	
	dbselectarea("RCC")
	dbsetorder(1)
	dbgotop()
	
	dbseek(xfilial("RCC")+_cTabela,.f.)
	
	Do While ! eof() .and. ALLTRIM(RCC_CODIGO) == _cTabela
		
		_nFaixade  := val( substr(rcc_conteu,01,12))
		_nFaixaAte := val( substr(rcc_conteu,13,12))
		_nmenval   := val( substr(rcc_conteu,25,12))
		_nmenper   := val( substr(rcc_conteu,37,06))
		
		if _nSalario >= _nFaixade .and. _nSalario <= _nFaixaAte

			if  _nmenval > 0
				_nRetorno := _nmenval
			Else
				_nRetorno := round((_nSalario*_nmenper)/100,2)
			Endif

			exit

		Endif
		
		dbskip()
		
	Enddo

Endif

dbSelectArea(aSvAlias[1])
dbSetOrder(aSvAlias[2])
dbGoto(aSvAlias[3])

return(_nRetorno)
