// +-----------+---------------+---------------------------------+---------------------+
// | Programa  | F200VAR.PRW   | Autor: rafael Almeida           | Data: 14/03/2019    |
// +-----------+---------------+---------------------------------+---------------------+
// | Descricao | PE do relatorio FINR650 utilizado para alterar os dados recebidos.    |
// +-----------+-------------------------------------------------+---------------------+
// | Uso       | CNAB (Arquivo de Retorno) - DUELO               | Dt. Atu: 14/03/2019 |
// +-----------+-------------------------------------------------+---------------------+

#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"

///////////////////////
User Function F430VAR()
///////////////////////

Local _aArea    := GetArea()
Local _cLinha   := PARAMIXB[01][16]
Local _cTitulo  := ""
Local _cEspecie := ""
Local _cFuncao  := FunName()
Local _cBanco   := ""
Local	_cCNABCodCli := ""
Local	_cCNABLojCli := ""
Local	_cCNABNomCli := ""
Local _sgmento := ""
Local _cDtBaixa  := SubStr(PARAMIXB[1][16],149,4) + SubStr(PARAMIXB[1][16],147,2) + SubStr(PARAMIXB[1][16],145,2)
Local _cTipTit := cTipo
Public 	_cCNABHistRec := ""


					// Estrutura de aValores
					//	Numero do T?tulo	- 01
					//	data da Baixa		- 02
					// Tipo do T?tulo		- 03
					// Nosso Numero			- 04
					// Valor da Despesa		- 05
					// Valor do Desconto	- 06
					// Valor do Abatiment	- 07
					// Valor Pagamento   	- 08
					// Juros				- 09
					// Multa				- 10
					// Fornecedor			- 11
					// Ocorrencia			- 12
					// CGC					- 13
					// nCM					- 14
					// Rejeicao				- 15
					// Linha Inteira		- 16


If MV_PAR05 == "001"
/*
		_cNumTit :=  SubStr(PARAMIXB[1][16],183,10)
		_cPrxTit := SubStr(PARAMIXB[1][16],55,3)
		_cParTit := SubStr(PARAMIXB[1][16],69,1)
		 _cDtBaixa  := SubStr(PARAMIXB[1][16],149,4) + SubStr(PARAMIXB[1][16],147,2) + SubStr(PARAMIXB[1][16],145,2)
		_cTipTit := ""
		_cIdCNAB := ""
		_cNumBco := ""

		cQry := " "
		cQry += " 	SELECT E2_IDCNAB, E2_NUMBCO, E2_FORNECE, E2_LOJA, E2_NOMFOR, E2_VALOR, E2_NUM	"	
		cQry += " 	FROM "+ RETSQLNAME("SE2")+"  "
		cQry += " 	WHERE D_E_L_E_T_ = ''	"
		cQry += " 		AND E2_FILIAL    = '"+xfilial("SE2")  +"' "
		cQry += " 		AND E2_IDCNAB       = '"+ Alltrim(_cNumTit) +"'	"
		cQry += " 		AND E2_PORTADO   = '001'	"
		//cQry += " 		AND E2_TIPO      = '"+ Alltrim(_cTipTit) +"'	"
		dbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQry) , "TOCE2" , .T. , .F.)
	
		DBSelectArea("TOCE2")
		TOCE2->(DbGoTop())
		While !TOCE2->(Eof())
			_cIdCNAB := TOCE2->E2_IDCNAB
			_cNumBco := TOCE2->E2_NUM
			_cCNABCodCli := TOCE2->E2_FORNECE
			_cCNABLojCli := TOCE2->E2_LOJA
			_cCNABNomCli := TOCE2->E2_NOMFOR
			_nVlrTit     := TOCE2->E2_VALOR		
			_cTipTit     := TOCE2->E2_TIPO	
			TOCE2->(DbSkip())
		EndDo
		TOCE2->( DBCloseArea())
		_cCNABHistRec := ALLTRIM(_cCNABCodCli)+"/"+ALLTRIM(_cCNABLojCli)+"-"+ ALLTRIM(_cCNABNomCli)

		cNumTit   := _cIdCNAB
		cNsNum    := _cNumBco
		cTipo     := Alltrim(_cTipTit)
		nDepres   := 0
		nDescont  := 0
		nMulta    := 0
		nValCred  := 0
		dDataCred := dDataBase
		dBaixa	  := StoD(_cDtBaixa)

*/
	_cNumTit :=  SubStr(PARAMIXB[1][16],183,10)
	_cPrxTit := SubStr(PARAMIXB[1][16],55,3)
	_cParTit := SubStr(PARAMIXB[1][16],61,1)
	_sgmento := SubStr(PARAMIXB[1][16],14,1)
	//_cTipTit := cTipo
	_cIdCNAB := ""
	_cNumBco := ""
	
	If 	_sgmento == "J"
		
		_codBra  := SubStr(PARAMIXB[1][16],18,44)

		cQry := " "
		cQry += " 	SELECT E2_IDCNAB, E2_NUMBCO, E2_FORNECE, E2_LOJA, E2_NOMFOR, E2_NUM, E2_TIPO	"
		cQry += " 	FROM "+ RETSQLNAME("SE2")+"  "
		cQry += " 	WHERE D_E_L_E_T_ = ''	"
		cQry += " 		AND E2_FILIAL    = '"+xfilial("SE2")  +"' "
		cQry += " 		AND E2_CODBAR       = '"+ Alltrim(_codBra) +"'	"
		cQry += " 		AND E2_PORTADO   = '001'	"
		dbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQry) , "RCTOC" , .T. , .F.)
		
		DBSelectArea("RCTOC")
		RCTOC->(DbGoTop())
		While !RCTOC->(Eof())
			_cIdCNAB     := RCTOC->E2_IDCNAB
			_cNumBco     := RCTOC->E2_NUM
			_cCNABCodCli := RCTOC->E2_FORNECE
			_cCNABLojCli := RCTOC->E2_LOJA
			_cCNABNomCli := RCTOC->E2_NOMFOR
			_cTipTit     := RCTOC->E2_TIPO
			RCTOC->(DbSkip())
		EndDo
		RCTOC->( DBCloseArea())
		_cCNABHistRec := ALLTRIM(_cCNABCodCli)+"/"+ALLTRIM(_cCNABLojCli)+"-"+ ALLTRIM(_cCNABNomCli)
		cNumTit   := _cIdCNAB
		cNsNum    := _cNumBco
		cTipo     := Alltrim(_cTipTit)
		nDepres   := 0
		nDescont  := 0
		nMulta    := 0
		nValCred  := 0
		dDataCred := dDataBase
		dBaixa	  := StoD(_cDtBaixa)
		
		
	
	EndIf
ElseIf MV_PAR05 == "033"
	_sgmento := SubStr(PARAMIXB[1][16],14,1)
	_cNumBco := ""


	If 	_sgmento == "J"
		
		_codBra  := SubStr(PARAMIXB[1][16],18,44)

		cQry := " "
		cQry += " 	SELECT E2_IDCNAB, E2_NUMBCO, E2_FORNECE, E2_LOJA, E2_NOMFOR, E2_NUM	"
		cQry += " 	FROM "+ RETSQLNAME("SE2")+"  "
		cQry += " 	WHERE D_E_L_E_T_ = ''	"
		cQry += " 		AND E2_FILIAL    = '"+xfilial("SE2")  +"' "
		cQry += " 		AND E2_CODBAR       = '"+ Alltrim(_codBra) +"'	"
		cQry:= ChangeQuery(cQry)
		dbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQry) , "TOC" , .T. , .F.)
		
		DBSelectArea("TOC")
		TOC->(DbGoTop())
		While !TOC->(Eof())
			_cIdCNAB := TOC->E2_IDCNAB
			_cNumBco := TOC->E2_NUM
			_cCNABCodCli := TOC->E2_FORNECE
			_cCNABLojCli := TOC->E2_LOJA
			_cCNABNomCli := TOC->E2_NOMFOR
			TOC->(DbSkip())
		EndDo
		TOC->( DBCloseArea())	
		_cCNABHistRec := ALLTRIM(_cCNABCodCli)+"/"+ALLTRIM(_cCNABLojCli)+"-"+ ALLTRIM(_cCNABNomCli)

		cNumTit   := _cIdCNAB
		cNsNum    := _cNumBco
		cTipo     := Alltrim(_cTipTit)
		nDepres   := 0
		nDescont  := 0
		nMulta    := 0
		nValCred  := 0
		dDataCred := dDataBase
		dBaixa	  := StoD(_cDtBaixa)
	
	EndIf

EndIf
RETURN
