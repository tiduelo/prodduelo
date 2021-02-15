// +-----------+---------------+---------------------------------+---------------------+
// | Programa  | F200VAR.PRW   | Autor: rafael Almeida           | Data: 14/03/2019    |
// +-----------+---------------+---------------------------------+---------------------+
// | Descricao | PE do relatorio FINR650 utilizado para alterar os dados recebidos.    |
// +-----------+-------------------------------------------------+---------------------+
// | Uso       | CNAB (Arquivo de Retorno) - DUELO               | Dt. Atu: 14/03/2019 |
// +-----------+-------------------------------------------------+---------------------+

#INCLUDE "rwmake.ch"

///////////////////////
User Function F200VAR()
///////////////////////

Local _aArea    := GetArea()
Local _cLinha   := PARAMIXB[01][16]
Local _cTitulo  := ""
Local _cEspecie := ""
Local _cFuncao  := FunName()
Local _cBanco   := ""  
Local _nVlrTit  := 0
Local	_cCNABCodCli := ""
Local	_cCNABLojCli := ""
Local	_cCNABNomCli := ""
Local   _cDtBaixa := ""
Public 	_cCNABHist := ""

If MV_PAR06 == "033"
	
	_cNumTit := SubStr(PARAMIXB[1][16],58,9)
	_cPrxTit := SubStr(PARAMIXB[1][16],55,3)
	_cParTit := SubStr(PARAMIXB[1][16],69,1)
	 _cDtBaixa  := SubStr(PARAMIXB[1][16],74,4) + SubStr(PARAMIXB[1][16],72,2) + SubStr(PARAMIXB[1][16],70,2)
	_cTipTit := cTipo
	_cIdCNAB := ""
	_cNumBco := ""
	_nVlrTit  := 0
	
	cQry := " "
	cQry += " 	SELECT E1_IDCNAB, E1_NUMBCO, E1_CLIENTE, E1_LOJA, E1_NOMCLI, E1_VALOR	"	
	cQry += " 	FROM "+ RETSQLNAME("SE1")+"  "
	cQry += " 	WHERE D_E_L_E_T_ = ''	"
	cQry += " 		AND E1_FILIAL    = '"+xfilial("SE1")  +"' "
	cQry += " 		AND E1_NUM       = '"+ Alltrim(_cNumTit) +"'	"
	cQry += " 		AND E1_PREFIXO   = '"+ Alltrim(_cPrxTit) +"'	"
	cQry += " 		AND E1_TIPO      = '"+ Alltrim(_cTipTit) +"'	"
	If Alltrim(_cParTit) =="1"
		cQry += " 	AND E1_PARCELA   IN ('','1')	"
	Else
		cQry += " 	AND E1_PARCELA   = '"+ Alltrim(_cParTit) +"'	"
	EndIf
	
	cQry:= ChangeQuery(cQry)
	dbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQry) , "TOC" , .T. , .F.)
	
	DBSelectArea("TOC")
	TOC->(DbGoTop())
	While !TOC->(Eof())
		_cIdCNAB := TOC->E1_IDCNAB
		_cNumBco := TOC->E1_NUMBCO
		_cCNABCodCli := TOC->E1_CLIENTE
		_cCNABLojCli := TOC->E1_LOJA
		_cCNABNomCli := TOC->E1_NOMCLI
		_nVlrTit     := TOC->E1_VALOR 		
		TOC->(DbSkip())
	EndDo
	TOC->( DBCloseArea())

	SegCNAB ( MV_PAR04 )
	
	cNumTit   := _cIdCNAB
	cNsNum    := _cNumBco
	_cCNABHist  := ALLTRIM(_cCNABCodCli)+"/"+ALLTRIM(_cCNABLojCli)+"-"+ ALLTRIM(_cCNABNomCli)
	cTipo := Alltrim(_cTipTit)
	nDepres    := 0
	nDescont  := 0
	//nAbatim   := 0
	//nJuros	  := 0
	nMulta    := 0
	nValCred  := 0
	//nValIof   := 0
	dDataCred	  := dDataBase
	dBaixa	      := StoD(_cDtBaixa)
ElseIf MV_PAR06 == "001" 

	_cNumTit := PadL(SubStr(PARAMIXB[1][16],120,6),9,"0")
	_cPrxTit := SubStr(PARAMIXB[1][16],117,3)
	_cParTit := SubStr(PARAMIXB[1][16],126,1)
	_cTipTit := "NF"
	_cIdCNAB := ""
	_cNumBco := ""
	_nVlrTit  := 0
	
	cQry := " "
	cQry += " 	SELECT E1_IDCNAB, E1_NUMBCO, E1_CLIENTE, E1_LOJA, E1_NOMCLI, E1_VALOR	"
	cQry += " 	FROM "+ RETSQLNAME("SE1")+"  "
	cQry += " 	WHERE D_E_L_E_T_ = ''	"
	cQry += " 		AND E1_FILIAL    = '"+xfilial("SE1")  +"' "
	cQry += " 		AND E1_NUM       = '"+ Alltrim(_cNumTit) +"'	"
	cQry += " 		AND E1_PREFIXO   = '"+ Alltrim(_cPrxTit) +"'	"
	cQry += " 		AND E1_TIPO      = '"+ Alltrim(_cTipTit) +"'	"
	If Alltrim(_cParTit) =="1"
		cQry += " 	AND E1_PARCELA   IN ('','1')	"
	Else
		cQry += " 	AND E1_PARCELA   = '"+ Alltrim(_cParTit) +"'	"	
	EndIf

	cQry:= ChangeQuery(cQry)
	dbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQry) , "TOC" , .T. , .F.)
	
	DBSelectArea("TOC")
	TOC->(DbGoTop())
	While !TOC->(Eof())
		_cIdCNAB := TOC->E1_IDCNAB
		_cNumBco := TOC->E1_NUMBCO
		_cCNABCodCli := TOC->E1_CLIENTE
		_cCNABLojCli := TOC->E1_LOJA
		_cCNABNomCli := TOC->E1_NOMCLI	
		_nVlrTit     := TOC->E1_VALOR	
		TOC->(DbSkip())
	EndDo
	TOC->( DBCloseArea())
	
	cNumTit   := _cIdCNAB
	cNsNum 	  := SubStr(PARAMIXB[1][16],32,17)
	cTipo 	  := "NF"
	_cCNABHist := ALLTRIM(_cCNABCodCli)+"/"+ALLTRIM(_cCNABLojCli)+"-"+ ALLTRIM(_cCNABNomCli)
	//nDespes   := 0
	//nDescont  := 0
	//nAbatim   := 0 
	//nJuros	  := 0
	//nMulta    := 0
	//nVaLOutrD := 0
	//nValIof   := 0	

ElseIf MV_PAR06 == "341" 

	_cNumTit := PadL(SubStr(PARAMIXB[1][16],120,6),9,"0")
	_cPrxTit := SubStr(PARAMIXB[1][16],117,3)
	_cParTit := SubStr(PARAMIXB[1][16],126,1)
	_cTipTit := "NF"
	_cIdCNAB := ""
	_cNumBco := ""
	_nVlrTit  := 0
	
	cQry := " "
	cQry += " 	SELECT E1_IDCNAB, E1_NUMBCO, E1_CLIENTE, E1_LOJA, E1_NOMCLI, E1_VALOR	"
	cQry += " 	FROM "+ RETSQLNAME("SE1")+"  "
	cQry += " 	WHERE D_E_L_E_T_ = ''	"
	cQry += " 		AND E1_FILIAL    = '"+xfilial("SE1")  +"' "
	cQry += " 		AND E1_NUM       = '"+ Alltrim(_cNumTit) +"'	"
	cQry += " 		AND E1_PREFIXO   = '"+ Alltrim(_cPrxTit) +"'	"
	cQry += " 		AND E1_TIPO      = '"+ Alltrim(_cTipTit) +"'	"
	If Alltrim(_cParTit) =="1"
		cQry += " 	AND E1_PARCELA   IN ('','1')	"
	Else
		cQry += " 	AND E1_PARCELA   = '"+ Alltrim(_cParTit) +"'	"	
	EndIf

	cQry:= ChangeQuery(cQry)
	dbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQry) , "TOC" , .T. , .F.)
	
	DBSelectArea("TOC")
	TOC->(DbGoTop())
	While !TOC->(Eof())
		_cIdCNAB := TOC->E1_IDCNAB
		_cNumBco := TOC->E1_NUMBCO
		_cCNABCodCli := TOC->E1_CLIENTE
		_cCNABLojCli := TOC->E1_LOJA
		_cCNABNomCli := TOC->E1_NOMCLI
		_nVlrTit     := TOC->E1_VALOR		
		TOC->(DbSkip())
	EndDo
	TOC->( DBCloseArea())
	
	cNumTit   := _cIdCNAB
	cNsNum 	  := SubStr(PARAMIXB[1][16],32,17)
	cTipo 	  := "NF"
	_cCNABHist := ALLTRIM(_cCNABCodCli)+"/"+ALLTRIM(_cCNABLojCli)+"-"+ ALLTRIM(_cCNABNomCli)
	nValRec   -=  Val(SubStr(PARAMIXB[1][16],241,13))
	nValRec   += (Val(SubStr(PARAMIXB[1][16],267,13))/100) 
	//nDespes   := 0
	//nDescont  := 0
	//nAbatim   := 0 
	//nJuros	  := 0
	//nMulta    := 0
	//nVaLOutrD := 0
	//nValIof   := 0	

EndIf

RETURN

//------------------------------------------------------------------------------------------------------------------
//     SegCNAB: BUSCA SEGMENTO NO ARQUIVO 
//------------------------------------------------------------------------------------------------------------------
Static Function SegCNAB ( _cArqRet )
Local oFile
Local _nX := 0

//Definindo o arquivo a ser lido
oFile := FWFileReader():New(_cArqRet)
 
//Se o arquivo pode ser aberto
If (oFile:Open())

  //Array de todas as linhas do arquivo
  cLinAtu := oFile:GetAllLines()

//Pecorrer o Array como estivesse pecorrendo a linha a linha do arquivo 
For  _nX := 1 To Len(cLinAtu)

	// Pega a linha 
	If SubStr(cLinAtu[_nX],1,14)==SubStr(PARAMIXB[1][16],1,14)

		//Pula para o SEGMENTO U da linha atual
		if  SubStr( cLinAtu[_nX+1],14,1)=="U" 
			nValRec := Round(Val(SubStr( cLinAtu[_nX+1],78,15))/100,2)
			nJuros  := Round(Val(SubStr( cLinAtu[_nX+1],18,15))/100,2)
			nAbatim := Round(Val(SubStr( cLinAtu[_nX+1],48,15))/100,2)
			EXIT
		EndIf
	EndIf
Next _nX 

    //Fecha o arquivo e finaliza o processamento
    oFile:Close()
EndIf

Return()
