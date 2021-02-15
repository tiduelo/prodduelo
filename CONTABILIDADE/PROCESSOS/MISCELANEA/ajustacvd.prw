#include "rwmake.ch"
#include "topconn.ch"

User Function ajustacvd()


if msgyesno("Ajusta Tabela de Plano de Conta x Plano referencial?")
	Processa( {|| ajustaok() } )
Endif

return nil

//////////////////////////////////////////////////////////////
Static Function ajustaok()


dbSelectArea("CT1")
dbsetorder(1)
dbgotop()

procregua(reccount())

Do While ! eof()
	
	if CT1_CLASSE == '2
		
		
		//////////////////////////////////////////////////
		///////////// Inicializar Variaveis //////////////
		//////////////////////////////////////////////////
		
		cCvdFilial := xfilial('CVD')
		cCvdEntref := '10'
		cCvdCodpla := '001'
		cCvdCtaref := space(30)
		cCvdConta  := CT1->CT1_CONTA
		cCvdCusto  := space(9)
		cCvdTputil := 'F'
		
		//////////////////////////////////////////////////
		///////////// Gravar/Atualizar Dados /////////////
		//////////////////////////////////////////////////
		
		DbSelectArea('CVD')
		DbSetOrder(1) // verificar se o indice utilizado esta correto
		Dbgotop()
		
		_lInclui := .t.
		
		// Alterar a chave de pesquisa de acordo com a tabela
		
		DbSeek(cCvdFilial+cCvdConta+cCvdEntref,.f.)
		
		If !Eof()
			_lInclui := .f.
		Endif
		
		if _lInclui
			
			If reclock('CVD',_lInclui) // .T. - Inclui / .F. - Altera
				
				CVD->CVD_FILIAL := cCvdFilial
				CVD->CVD_ENTREF := cCvdEntref
				CVD->CVD_CODPLA := cCvdCodpla
				CVD->CVD_CTAREF := cCvdCtaref
				CVD->CVD_CONTA  := cCvdConta
				CVD->CVD_CUSTO  := cCvdCusto
				CVD->CVD_TPUTIL := cCvdTputil
				
				msunlock()
				
			Endif
			
		Endif
		
		//////////////////////////////////////////////////
		//////////////////////////////////////////////////
		
	Endif
	
	dbSelectArea("CT1")
	dbskip()
	
Enddo

return nil

