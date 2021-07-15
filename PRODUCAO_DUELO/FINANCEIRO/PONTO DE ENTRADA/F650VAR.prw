/*
// +-----------+---------------+---------------------------------+---------------------+
// | Programa  | F200VAR.PRW   | Autor: rafael Almeida           | Data: 14/03/2019    |
// +-----------+---------------+---------------------------------+---------------------+
// | Descricao | PE do relatorio FINR650 utilizado para alterar os dados recebidos.    |
// +-----------+-------------------------------------------------+---------------------+
// | Uso       | CNAB (Arquivo de Retorno) - DUELO               | Dt. Atu: 14/03/2019 |
// +-----------+-------------------------------------------------+---------------------+
*/
#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"

//
User Function F650VAR()
//


Local _aArea    := GetArea()
Local _cLinha   := PARAMIXB[01][14]
Local _cTitulo  := ""
Local _cEspecie := ""
Local _cFuncao  := FunName()
Local _cBanco   := ""
Local _nVlrTit  := 0



If MV_PAR07 == 1
	If MV_PAR03 == "033"
	
		_cNumTit := SubStr(PARAMIXB[1][14],58,9)
		_cPrxTit := SubStr(PARAMIXB[1][14],55,3)
		_cParTit := SubStr(PARAMIXB[1][14],69,1)
		 _cDtBaixa  := SubStr(PARAMIXB[1][14],74,4) + SubStr(PARAMIXB[1][14],72,2) + SubStr(PARAMIXB[1][14],70,2)
		_cTipTit := cTipo
		_cIdCNAB := ""
		_cNumBco := ""

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

		SegCNAB(MV_PAR01)


	
		cNumTit   := _cIdCNAB
		cNsNum    := _cNumBco
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
	ElseIf MV_PAR03 == "001" // .AND. MV_PAR08 == 2
		
		_cNumTit := PadL(SubStr(PARAMIXB[1][14],120,6),9,"0")
		_cPrxTit := SubStr(PARAMIXB[1][14],117,3)
		_cParTit := SubStr(PARAMIXB[1][14],126,1)
		_cTipTit := "NF"
		_cIdCNAB := ""
		_cNumBco := ""
		_cDtBaixa := SubStr(PARAMIXB[1][14],176,2)+"/"+SubStr(PARAMIXB[1][14],178,2)+"/"+SubStr(PARAMIXB[1][14],180,2)
		
		cQry := " "
		cQry += " 	SELECT E1_IDCNAB, E1_NUMBCO	"
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
			TOC->(DbSkip())
		EndDo
		TOC->( DBCloseArea())
		
		cNumTit   := _cIdCNAB
		cNsNum 	  := SubStr(PARAMIXB[1][14],32,17)
		cTipo 	  := "NF"
		nDespes   := 0
		nDescont  := 0
		nAbatim   := 0
		nMulta    := 0
		nVaLOutrD := 0
		nValIof   := 0
		nJuros	  :=  Val( SubStr(PARAMIXB[1][14],267,11)+"."+ SubStr(PARAMIXB[1][14],278,2))
		dDataCred	  := dDataBase	
		dBaixa	      := CtoD(_cDtBaixa)
		//	dCred	  := MV_PAR10//Data Recebimento
		//	dBaixa	  := MV_PAR09//Data Movimentação
		
	ElseIf MV_PAR03 == "341"
		
		_cNumTit := PadL(SubStr(PARAMIXB[1][14],120,6),9,"0")
		_cPrxTit := SubStr(PARAMIXB[1][14],117,3)
		_cParTit := SubStr(PARAMIXB[1][14],126,1)
		_cTipTit := "NF"
		_cIdCNAB := ""
		_cNumBco := ""
		
		cQry := " "
		cQry += " 	SELECT E1_IDCNAB, E1_NUMBCO	"
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
			TOC->(DbSkip())
		EndDo
		TOC->( DBCloseArea())
		
		cNumTit   := _cIdCNAB
		cNsNum 	  := SubStr(PARAMIXB[1][14],32,17)
		cTipo 	  := "NF"
		nValRec   -=  Val(SubStr(PARAMIXB[1][14],241,13))
		nValRec   += (Val(SubStr(PARAMIXB[1][14],267,13))/100)
		//nDespes   := 0
		//nDescont  := 0
		//nAbatim   := 0
		//nJuros	:= 0
		//nMulta    := 0
		//nVaLOutrD := 0
		//nValIof   := 0
		
		
	EndIf
ElseIf MV_PAR07 == 2
	If MV_PAR03 == "033"
	
		_cNumTit := PARAMIXB[1][1]
		_cPrxTit := SubStr(PARAMIXB[1][14],55,3)
		_cParTit := SubStr(PARAMIXB[1][14],69,1)
		 _cDtBaixa  := SubStr(PARAMIXB[1][14],149,4) + SubStr(PARAMIXB[1][14],147,2) + SubStr(PARAMIXB[1][14],145,2)
		_cTipTit := cTipo
		_cIdCNAB := ""
		_cNumBco := ""

		cQry := " "
		cQry += " 	SELECT E2_IDCNAB, E2_NUMBCO, E2_FORNECE, E2_LOJA, E2_NOMFOR, E2_VALOR, E2_NUM	"	
		cQry += " 	FROM "+ RETSQLNAME("SE2")+"  "
		cQry += " 	WHERE D_E_L_E_T_ = ''	"
		cQry += " 		AND E2_FILIAL    = '"+xfilial("SE2")  +"' "
		cQry += " 		AND E2_IDCNAB       = '"+ Alltrim(PARAMIXB[1][1]) +"'	"
		cQry += " 		AND E2_PORTADO   = '033'	"
		cQry += " 		AND E2_TIPO      = '"+ Alltrim(_cTipTit) +"'	"
		//If Alltrim(_cParTit) =="1"
		//	cQry += " 	AND E2_PARCELA   IN ('','1')	"
		//Else
		//	cQry += " 	AND E2_PARCELA   = '"+ Alltrim(_cParTit) +"'	"
		//EndIf
	
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
			_nVlrTit     := TOC->E2_VALOR		
			TOC->(DbSkip())
		EndDo
		TOC->( DBCloseArea())

		SegCNAB(MV_PAR01)


	
		cNumTit   := _cIdCNAB
		cNsNum    := _cNumBco
		cTipo     := Alltrim(_cTipTit)
		nDepres   := 0
		nDescont  := 0
		//nAbatim := 0
		//nJuros  := 0 
		nMulta    := 0
		nValCred  := 0
		//nValIof := 0
		dDataCred := dDataBase
		dBaixa	  := StoD(_cDtBaixa)
	EndIf

	If MV_PAR03 == "001"

		_cNumTit := PARAMIXB[1][1]
		_cPrxTit := SubStr(PARAMIXB[1][14],55,3)
		_cParTit := SubStr(PARAMIXB[1][14],69,1)
		 _cDtBaixa  := SubStr(PARAMIXB[1][14],149,4) + SubStr(PARAMIXB[1][14],147,2) + SubStr(PARAMIXB[1][14],145,2)
		_cTipTit := cTipo
		_cIdCNAB := ""
		_cNumBco := ""

		cQry := " "
		cQry += " 	SELECT E2_IDCNAB, E2_NUMBCO, E2_FORNECE, E2_LOJA, E2_NOMFOR, E2_VALOR, E2_NUM	"	
		cQry += " 	FROM "+ RETSQLNAME("SE2")+"  "
		cQry += " 	WHERE D_E_L_E_T_ = ''	"
		cQry += " 		AND E2_FILIAL    = '"+xfilial("SE2")  +"' "
		cQry += " 		AND E2_IDCNAB       = '"+ Alltrim(PARAMIXB[1][1]) +"'	"
		cQry += " 		AND E2_PORTADO   = '001'	"
		cQry += " 		AND E2_TIPO      = '"+ Alltrim(_cTipTit) +"'	"
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
			TOCE2->(DbSkip())
		EndDo
		TOCE2->( DBCloseArea())

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
  cLinAtu := oFile:GetAllLines()
 
For  _nX := 1 To Len(cLinAtu)
	If SubStr(cLinAtu[_nX],1,14)==SubStr(PARAMIXB[1][14],1,14)
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
