#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "Protheus.ch"
#include "totvs.ch"
#INCLUDE "COLORS.CH"

*******************************
User Function ConsZTT() //23/03/16 - CONSULTA PADRAO ESPECIFICA DO PEDIDO
*******************************
Local cTexto := ""
Local bRet := .F.
Private nPOsSC1Cc   := ""
Private nPOsSC1Cta  := ""
Private _cCCSC1   := ""
Private _cCtaSc1  := ""
Private _cContCT1 := ""
Private lRetNoRg  := .F.
Private _cCodUsr  := RetCodUsr()
Private _cGrpUsr  := GetNewPar("US_USRCT1","/000107/000029/000049/000122/000124/000069/000127/000047/")
Private _cGrpAdm1 := Alltrim(UsrRetGrp(RetCodUsr())[1])
Private _cGrpAdm2 := Alltrim(UsrRetGrp(RetCodUsr())[2])


If FunName() == "MATA110"
	If __READVAR ==  "M->CX_CC"
		//		cTexto :=	RTRIM(M->CX_CC)
		nPOsSC1Cc   := aScan(aHeader,{|x| AllTrim(x[2]) == "CX_CC"})
		nPOsSC1Cta  := aScan(aHeader,{|x| AllTrim(x[2]) == "CX_CONTA"})
		_cCCSC1  :=  aCols[n][nPOsSC1Cc]
		_cCtaSc1 :=  aCols[n][nPOsSC1Cta]
	Else
		//		cTexto :=	RTRIM(M->C1_CC)
		nPOsSC1Cc   := aScan(aHeader,{|x| AllTrim(x[2]) == "C1_CC"})
		nPOsSC1Cta  := aScan(aHeader,{|x| AllTrim(x[2]) == "C1_CONTA"})
		_cCCSC1  :=  aCols[n][nPOsSC1Cc]
		_cCtaSc1 :=  aCols[n][nPOsSC1Cta]
	EndIf
ElseIf FunName() == "MATA120" .OR. FunName() == "MATA121"
	If __READVAR ==  "M->CH_CC"
		//	cTexto :=	RTRIM(M->CH_CC)
		nPOsSC1Cc   := aScan(aHeader,{|x| AllTrim(x[2]) == "CH_CC"})
		nPOsSC1Cta  := aScan(aHeader,{|x| AllTrim(x[2]) == "CH_CONTA"})
		_cCCSC1  :=  aCols[n][nPOsSC1Cc]
		_cCtaSc1 :=  aCols[n][nPOsSC1Cta]
	Else
		//	cTexto :=	RTRIM(M->C7_CC)
		nPOsSC1Cc   := aScan(aHeader,{|x| AllTrim(x[2]) == "C7_CC"})
		nPOsSC1Cta  := aScan(aHeader,{|x| AllTrim(x[2]) == "C7_CONTA"})
		_cCCSC1  :=  aCols[n][nPOsSC1Cc]
		_cCtaSc1 :=  aCols[n][nPOsSC1Cta]
	EndIf
ElseIf FunName() == "MATA103"
	If __READVAR ==  "M->DE_CC"
		//cTexto :=	RTRIM(M->DE_CC)
		nPOsSC1Cc   := aScan(aHeader,{|x| AllTrim(x[2]) == "DE_CC"})
		nPOsSC1Cta  := aScan(aHeader,{|x| AllTrim(x[2]) == "DE_CONTA"})
		_cCCSC1  :=  aCols[n][nPOsSC1Cc]
		_cCtaSc1 :=  aCols[n][nPOsSC1Cta]
	Else
		//		cTexto :=	RTRIM(M->D1_CC)
		nPOsSC1Cc   := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_CC"})
		nPOsSC1Cta  := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_CONTA"})
		_cCCSC1  :=  aCols[n][nPOsSC1Cc]
		_cCtaSc1 :=  aCols[n][nPOsSC1Cta]
	EndIf
ElseIf FunName() == "FINA750" .Or. FunName() == "FINA050"
	
	If M->E2_RATEIO=="S"
		_cCCSC1  := TMP->CTJ_CCD
		_cCtaSc1 := TMP->CTJ_DEBITO
	Else
		_cCCSC1  := M->E2_CCUSTO
		_cCtaSc1 := M->E2_CONTAD
	EndIf
	
ElseIf FunName() == "FINA100"
	
	If cRecPag=="P"
		_cCCSC1  := M->E5_CCD
		_cCtaSc1 := M->E5_DEBITO
	ElseIf cRecPag=="R"
		_cCCSC1  := M->E5_CCC
		_cCtaSc1 := M->E5_CREDIT
	EndIf
	
EndIf

DBSelectArea("CTT")
DBSelectArea("ZTT")
bRet := FiltraCTT()

If bRet
	DBSelectArea("CTT")
	DBSetOrder(1)
	DBSeek(xFilial()+_cContCT1)
Endif


Return bRet

**************************
Static Function FiltraCTT()
**************************
Local _aCols := {}
Local cQuery
Local I
Local oDlg
Local oGet1
Local cGet1 := Space(20)
Local oSay1
Local oSButton1
Private _bRet := .F.
Private aDadosSB1 := {}
Private oDlgSB1
Private oLstSB1

MsgRun("Selecionando Registros, Aguarde...",,{|| ProcQry()})


Define MsDialog oDlgSB1 Title "Busca de Contas" From 0,0 To 310, 700 Of oMainWnd Pixel

@ 008, 005 SAY oSay1 PROMPT "Pesquisar: " SIZE 033, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 005, 035 MSGET oGet1 VAR cGet1 SIZE 098, 010 OF oDlg COLORS 0, 16777215 PIXEL

DEFINE SBUTTON oSButton1 FROM 005, 140 TYPE 17 Action( FiltCc(cGet1) , oLstSB1:refresh() ) OF oDlgSB1 ENABLE
DEFINE SBUTTON oSButton1 FROM 005, 175 TYPE 9  Action( AtuFilCc() , oLstSB1:refresh() ) OF oDlgSB1 ENABLE

@ 020, 005 LISTBOX oLstSB1 VAR lVarMat Fields HEADER "Conta", "Descrição" SIZE 340,130 On DblClick ( ConfSB1(oLstSB1:nAt, @aDadosSB1, @_bRet) ) OF oDlgSB1 PIXEL

oLstSB1:SetArray(aDadosSB1)
oLstSB1:bLine := { || {aDadosSB1[oLstSB1:nAt,1], aDadosSB1[oLstSB1:nAt,2] } }



Activate MSDialog oDlgSB1 Centered

Return _bRet

*************************************************
Static Function ConfSB1(_nPos, aDadosSB1, _bRet)
*************************************************

If FunName() == "FINA750" .Or. FunName() == "FINA050"
	If !lRetNoRg
		If M->E2_RATEIO=="S"
			TMP->CTJ_CCD     := aDadosSB1[_nPos,1]
			TMP->CTJ_DEBITO  := _cCtaSc1
			_cContCT1        := aDadosSB1[_nPos,1]
		Else
			M->E2_CCUSTO  := aDadosSB1[_nPos,1]
			M->E2_CONTAD  :=  _cCtaSc1
			_cContCT1 	  := aDadosSB1[_nPos,1]
		EndIf
	EndIf
ElseIf FunName() == "FINA100"
	If cRecPag=="P"
		M->E5_CCD     := aDadosSB1[_nPos,1]
		M->E5_DEBITO  :=  _cCtaSc1
		_cContCT1     := aDadosSB1[_nPos,1]
	ElseIf cRecPag=="R"
		M->E5_CCC     := aDadosSB1[_nPos,1]
		M->E5_CREDIT  :=  _cCtaSc1
		_cContCT1     := aDadosSB1[_nPos,1]
	EndIf
Else
	aCols[n][nPOsSC1Cc]  := aDadosSB1[_nPos,1]
	aCols[n][nPOsSC1Cta] :=  _cCtaSc1
	_cContCT1            := aDadosSB1[_nPos,1]
EndIf
_bRet := .T.
Close(oDlgSB1)
Return


***************************
Static Function ProcQry(cGet1)
***************************
aDadosSB1:={}

If Select("cAliasTmp") > 0
	cAliasTmp->(DBCLoseArea())
EndIf

If Alltrim(_cCodUsr) $  Alltrim(_cGrpUsr)
	cQuery := " "
	cQuery += " SELECT 	"
	cQuery += "  CTT_CUSTO	AS CTT_CUSTO	"
	cQuery += " ,CTT_DESC01	AS CTT_DESC01	"
	cQuery += " FROM "+ RETSQLNAME("CTT") + " AS CTT "
	cQuery += " WHERE D_E_L_E_T_ = ''	"
	cQuery += " AND CTT_FILIAL = '"+XFILIAL("CTT")+"'"
	cQuery += " AND CTT_CLASSE = '2'	"
	cQuery += " AND CTT_BLOQ <> '1'		"
	cQuery += " AND CTT_BLOQ <> '1'		"
	cQuery += " ORDER BY CTT_CUSTO	"
Else
	cQuery := " "
	cQuery += " SELECT 	"
	cQuery += "  ZTT_CC	AS CTT_CUSTO	"
	cQuery += " ,ZTT_DESCCC	AS CTT_DESC01	"
	cQuery += " FROM "+ RETSQLNAME("ZTT") + " AS ZTT "
	cQuery += " WHERE D_E_L_E_T_ = ''	"
	cQuery += " AND ZTT_FILIAL = '"+XFILIAL("ZTT")+"'"
	cQuery += " AND (ZTT_GRPUSR = '"+Alltrim(_cGrpAdm1)+"'"
	cQuery += " OR   ZTT_GRPUSR = '"+Alltrim(_cGrpAdm2)+"' )"
	cQuery += " ORDER BY ZTT_CC	"
EndIf
cQuery := ChangeQuery(cQuery)
cAliasTmp := CriaTrab(Nil,.F.)
dbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAliasTmp, .F., .T.)

DBSelectArea(cAliasTmp)
DBGoTop()

/*
If Eof()
Alert("Conta nao encontrada.")
Return .F.
Endif
*/
Do While !EOF()
	AAdd( aDadosSB1, { (cAliasTmp)->CTT_CUSTO,;
	(cAliasTmp)->CTT_DESC01} )
	DbSkip()
Enddo
DBCloseArea(cAliasTmp)

If Len(aDadosSB1) <= 0
	lRetNoRg := .T.
	AAdd( aDadosSB1, { " "," " })
EndIf

Return



Static Function FiltCc(cGet1)

Local _PosFilt := 0
Local i := 0
Local j := 0


If !Empty(cGet1)
	If 	SubStr(Alltrim(cGet1),1,1) $ ("/0/1/2/3/4/5/6/7/8/9/")
		For i := 1 To Len(aDadosSB1)
			If Len(Alltrim(cGet1)) = 1
				If  Alltrim(cGet1) $ SubStr(Alltrim(aDadosSB1[i,1]),1,1)
					_PosFilt := (i-1)
					EXIT
				EndIf
			ElseIf Len(Alltrim(cGet1)) = 2
				If  Alltrim(cGet1) $ SubStr(Alltrim(aDadosSB1[i,1]),1,2)
					_PosFilt := (i-1)
					EXIT
				EndIf
			ElseIf  Len(Alltrim(cGet1)) >= 3
				If  Alltrim(cGet1) $ SubStr(Alltrim(aDadosSB1[i,1]),1)
					_PosFilt := (i-1)
					EXIT
				EndIf
			EndIf
			
		Next i
	ElseIf SubStr(UPPER(Alltrim(cGet1)),1,1) $ (" /A/B/C/D/E/F/G/H/I/J/K/W/L/M/N/O/P/Q/R/S/T/U/Y/V/X/Z/Ç")
		For j := 1 To Len(aDadosSB1)
			If Len(Alltrim(cGet1)) = 1
				If  Upper(Alltrim(cGet1)) $ Upper(SubStr(Alltrim(aDadosSB1[j,2]),1,1))
					_PosFilt := (j-1)
					EXIT
				EndIf
			ElseIf Len(Alltrim(cGet1)) = 2
				If  Upper(Alltrim(cGet1)) $ Upper(SubStr(Alltrim(aDadosSB1[j,2]),1,2))
					_PosFilt := (j-1)
					EXIT
				EndIf
			ElseIf  Len(Alltrim(cGet1)) >= 3
				If  Upper(Alltrim(cGet1)) $ Upper(SubStr(Alltrim(aDadosSB1[j,2]),1))
					_PosFilt := (j-1)
					EXIT
				EndIf
			EndIf
		Next i
	EndIf
EndIf
oLstSB1:GoTop()
oLstSB1:Skip(_PosFilt)
Return


Static Function AtuFilCc()
	oLstSB1:GoTop()
Return