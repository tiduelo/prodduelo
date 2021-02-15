#INCLUDE "rwmake.ch"

//////////////////////////////////////////
User Function pvcalprc(_Campo,lDelete)
//////////////////////////////////////////
local nUsado 	:= LEN(AHEADER)
Local _x := 0
Local _y := 0
local lProcessa := .t. 
Local _cNoAlcoo := GetMv("US_NOALCOO")  //RAFAEL ALMEIDA  - SIGACORP (03/08/2016) // PARÂMETRO QUE CONTEM A RELAÇÃO DOS GRUPOS NÃO ALCOÓLICOS  
Local _cSiAlcoo := GetMv("US_SIALCOO")  //RAFAEL ALMEIDA  - SIGACORP (03/08/2016) // PARÂMETRO QUE CONTEM A RELAÇÃO DOS GRUPOS ALCOÓLICOS

if lDelete == nil
	lDelete := .f.
Endif

aSvAlias:={Alias(),IndexOrd(),Recno()}

//Alert(readvar())

_Tabela  := _Campo
_Retorno := space(3)

_aGrupo  := {}
_cGrupo  := space(4)

_nPOSPRO := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO"})
_nPOSTES := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_TES"})
_nPOSPRC := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRCVEN"})
_nPOSQTD := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDVEN"})
_nPOSVAL := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_VALOR"})
_nPOSPRT := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRUNIT"})
_nPOSPRF := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRCFIN"})

_lGrpDsc := .f.

if "C6_QTDVEN" $ upper(readvar()) .or. lDelete
	
		
	_Tabela  := M->C5_TABELA
	_Retorno := _Campo
	_cGrupo  := substr(aCols[n][_nPOSPRO],1,4)
	
	if _cGrupo $ "0203,0204,0205"
		_lGrpDsc := .t.
	Endif

	if _Campo == aCols[n][_nPOSQTD]
		lProcessa := .t.
	Endif
	
Else	
	dbselectarea("DA0")
	dbsetorder(1)
	dbgotop()
	
	if dbseek( xfilial("DA0")+_Tabela, .F.)
		_Retorno := da0_condpg
	Endif
	
Endif
  

if empty(_Tabela)
	lProcessa := .f.
Endif

if lProcessa
	
	if sm0->m0_codigo == '05'
		
		// Verifica condicao de pagamento da tabela
		
		
		// Gera a quantidade vendida por familia de produtos
		
		For _x := 1 to len(aCols)
			
			If !aCols[_x][nUsado+1]


//RAFAEL ALMEIDA - SIGACORP (03/08/2016) - TRATAMENTO PARA BEBIDAS NÃO ALCOOLICAS				
				if empty(_cGrupo) .or. ( !empty(_cGrupo) .and. substr(aCols[_x][_nPOSPRO],1,4) $ _cNoAlcoo )
					
				    // Trecho abaixo comentado, pois ele estava validando apenas para produtos que tinham o mesmo código nos primeiro 4 dígitos.
					//_nPos := Ascan( _agrupo, { |x| x[1] == substr(aCols[_x][_nPOSPRO],1,4) } ) 
					_nPos := Ascan( _agrupo, { |x| x[1] $ _cNoAlcoo } )
					
					if _nPos == 0
						aadd( _aGrupo, { substr(aCols[_x][_nPOSPRO],1,4) , aCols[_x][_nPOSQTD] } )
					Else
						_aGrupo[_nPos][2] += aCols[_x][_nPOSQTD]
					Endif
					
				Endif
				
//RAFAEL ALMEIDA - SIGACORP (03/08/2016) - TRATAMENTO PARA BEBIDAS ALCOOLICAS
				if empty(_cGrupo) .or. ( !empty(_cGrupo) .and. substr(aCols[_x][_nPOSPRO],1,4) $ _cSiAlcoo )
					
				    // Trecho abaixo comentado, pois ele estava validando apenas para produtos que tinham o mesmo código nos primeiro 4 dígitos.
					//_nPos := Ascan( _agrupo, { |x| x[1] == substr(aCols[_x][_nPOSPRO],1,4) } )
					  _nPos := Ascan( _agrupo, { |x| x[1] $ _cSiAlcoo } )
					
					if _nPos == 0
						aadd( _aGrupo, { substr(aCols[_x][_nPOSPRO],1,4) , aCols[_x][_nPOSQTD] } )
					Else
						_aGrupo[_nPos][2] += aCols[_x][_nPOSQTD]
					Endif
					
				Endif

/*
//RAFAEL ALMEIDA - SIGACORP (03/08/2016) - CONTEUDO ORIGINAL DO CODIGO FONTE, FOI COMENTADO PARA ATENDER A SOLICITAÇÃO DE DESCONTO POR FAMILIA
//                                         POREM ESTAVA APENAS FAZENDO QUANDO OS 4 PRIMEIRO DIGITOS DOS PRODUTOS FOREM IGUAIS, MAS EXISTE PRODUTO DA MESMA FAMILIA COM
//										   4 PRIMEIRO DIGITOS DIFERENTE.

				if empty(_cGrupo) .or. ( !empty(_cGrupo) .and. substr(aCols[_x][_nPOSPRO],1,4) == _cGrupo )
					
					_nPos := Ascan( _agrupo, { |x| x[1] == substr(aCols[_x][_nPOSPRO],1,4) } )
					
					if _nPos == 0
						aadd( _aGrupo, { substr(aCols[_x][_nPOSPRO],1,4) , aCols[_x][_nPOSQTD] } )
					Else
						_aGrupo[_nPos][2] += aCols[_x][_nPOSQTD]
					Endif
					
				Endif
*/				

			Endif
			
		Next
		
		// Processa o preco de cada produto considerando a quantidade da familia
		
		For _x := 1 to len(aCols)
			
			If !aCols[_x][nUsado+1]
				
//RAFAEL ALMEIDA - SIGACORP (03/08/2016) - TRATAMENTO PARA BEBIDAS NÃO ALCOOLICAS
				if empty(_cGrupo) .or. ( !empty(_cGrupo) .and. substr(aCols[_x][_nPOSPRO],1,4) $ _cNoAlcoo )
					
					_Produto := aCols[_x][_nPOSPRO]
					_Grupo   := substr( aCols[_x][_nPOSPRO] , 1 , 4 )
					_Preco   := aCols[_x][_nPOSPRC]
					_Quant   := 0
					
					//_nPos 	 := Ascan( _agrupo, { |x| x[1] == _Grupo } )
					  _nPos 	 := Ascan( _agrupo, { |x| x[1] $ _cNoAlcoo } )
					
					If !Empty(_Grupo)
						if _nPos > 0
							_Quant   := _agrupo[_nPos][2]
						Else
							alert("Problema no calculo de precos")
						Endif
					EndIf
					
					// Verifica as faixas existentes para cada produto da tabela
					
					dbselectarea("DA1")
					dbsetorder(2)
					dbgotop()
					
					dbseek( xfilial("DA1")+_Produto+_Tabela, .F.)
					
					_aFaixas := {}
					
					Do while ! eof() .and. DA1_FILIAL+DA1_CODPRO+DA1_CODTAB == xfilial("DA1")+_Produto+_Tabela
						aadd( 	_aFaixas , { DA1_QTDLOT, DA1_PRCVEN } )
						dbskip()
					Enddo
					
					_aFaixas := aSort( _aFaixas ,,, { |x,y| X[1] > Y[1] } )
					
					For _y :=1 to len(_aFaixas)
						
						if _Quant <=  _aFaixas[_y][1]
							_Preco := _aFaixas[_y][2]
						Endif
						
					Next
					
					if _Preco > 0
						aCols[_x][_nPOSPRT] := _Preco
						aCols[_x][_nPOSPRC] := _Preco
						aCols[_x][_nPOSPRF] := _Preco
						aCols[_x][_nPOSVAL] := _Preco * aCols[_x][_nPOSQTD]
					Endif
				Endif
				
//RAFAEL ALMEIDA - SIGACORP (03/08/2016) - TRATAMENTO PARA BEBIDAS ALCOOLICAS				
				if empty(_cGrupo) .or. ( !empty(_cGrupo) .and. substr(aCols[_x][_nPOSPRO],1,4) $ _cSiAlcoo )
					
					_Produto := aCols[_x][_nPOSPRO]
					_Grupo   := substr( aCols[_x][_nPOSPRO] , 1 , 4 )
					_Preco   := aCols[_x][_nPOSPRC]
					_Quant   := 0
					
					//_nPos 	 := Ascan( _agrupo, { |x| x[1] == _Grupo } )
   					  _nPos 	 := Ascan( _agrupo, { |x| x[1] $  _cSiAlcoo } )
					
					If !Empty(_Grupo)
						if _nPos > 0
							_Quant   := _agrupo[_nPos][2]
						Else
							alert("Problema no calculo de precos")
						Endif
					EndIf
					
					// Verifica as faixas existentes para cada produto da tabela
					
					dbselectarea("DA1")
					dbsetorder(2)
					dbgotop()
					
					dbseek( xfilial("DA1")+_Produto+_Tabela, .F.)
					
					_aFaixas := {}
					
					Do while ! eof() .and. DA1_FILIAL+DA1_CODPRO+DA1_CODTAB == xfilial("DA1")+_Produto+_Tabela
						aadd( 	_aFaixas , { DA1_QTDLOT, DA1_PRCVEN } )
						dbskip()
					Enddo
					
					_aFaixas := aSort( _aFaixas ,,, { |x,y| X[1] > Y[1] } )
					
					For _y :=1 to len(_aFaixas)
						
						if _Quant <=  _aFaixas[_y][1]
							_Preco := _aFaixas[_y][2]
						Endif
						
					Next
					
					if _Preco > 0
						aCols[_x][_nPOSPRT] := _Preco
						aCols[_x][_nPOSPRC] := _Preco
					    aCols[_x][_nPOSPRF] := _Preco
						aCols[_x][_nPOSVAL] := _Preco * aCols[_x][_nPOSQTD]
					Endif
				Endif
				  
/*
//RAFAEL ALMEIDA - SIGACORP (03/08/2016) - CONTEUDO ORIGINAL DO CODIGO FONTE, FOI COMENTADO PARA ATENDER A SOLICITAÇÃO DE DESCONTO POR FAMILIA
//                                         POREM ESTAVA APENAS FAZENDO QUANDO OS 4 PRIMEIRO DIGITOS DOS PRODUTOS FOREM IGUAIS, MAS EXISTE PRODUTO DA MESMA FAMILIA COM
//										   4 PRIMEIRO DIGITOS DIFERENTE.				

				if empty(_cGrupo) .or. ( !empty(_cGrupo) .and. substr(aCols[_x][_nPOSPRO],1,4) == _cGrupo )
					
					_Produto := aCols[_x][_nPOSPRO]
					_Grupo   := substr( aCols[_x][_nPOSPRO] , 1 , 4 )
					_Preco   := aCols[_x][_nPOSPRC]
					_Quant   := 0
					
					_nPos 	 := Ascan( _agrupo, { |x| x[1] == _Grupo } )
					
					if _nPos > 0
						_Quant   := _agrupo[_nPos][2]
					Else
						alert("Problema no calculo de precos")
					Endif
					
					// Verifica as faixas existentes para cada produto da tabela
					
					dbselectarea("DA1")
					dbsetorder(2)
					dbgotop()
					
					dbseek( xfilial("DA1")+_Produto+_Tabela, .F.)
					
					_aFaixas := {}
					
					Do while ! eof() .and. DA1_FILIAL+DA1_CODPRO+DA1_CODTAB == xfilial("DA1")+_Produto+_Tabela
						aadd( 	_aFaixas , { DA1_QTDLOT, DA1_PRCVEN } )
						dbskip()
					Enddo
					
					_aFaixas := aSort( _aFaixas ,,, { |x,y| X[1] > Y[1] } )
					
					For _y :=1 to len(_aFaixas)
						
						if _Quant <=  _aFaixas[_y][1]
							_Preco := _aFaixas[_y][2]
						Endif
						
					Next
					
					if _Preco > 0
						aCols[_x][_nPOSPRT] := _Preco
						aCols[_x][_nPOSPRC] := _Preco
						aCols[_x][_nPOSVAL] := _Preco * aCols[_x][_nPOSQTD]
					Endif
				Endif
*/			
								
			Endif
			
		Next
		
		oGetDad:refresh()
		
		Ma410Rodap() //Ma410Rodap(o)
		
	Endif
	
Endif

dbSelectArea(aSvAlias[1])
dbSetOrder(aSvAlias[2])
dbGoto(aSvAlias[3])

return(_Retorno)
