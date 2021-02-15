#Include "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
//--------------------------------------------------------------
/*/{Protheus.doc} MyFunction
Description

@param xParam Parameter Description
@return xRet Return Description
@author  -
@since 20/08/2017
/*/
//--------------------------------------------------------------
User Function TeleCob()
Local aArea := GetArea()
Local _cAlias     := "ZCF"
Local cRotina     := "3"    //Indica as rotinas de atendimento. 1-Telemarketing 2- Televendas 3-Telecobranca
Local aCabec := {}
Local aItens := {}
Local aLinha := {}
Local cCLIENTE := SA1->A1_COD //Space(6)
Local cCONTATO
Local cCONTATO := Space(50)
Local cEMAIL
Local cEMAIL := Space(50)
Local cFONECELULAR
Local cFONECELULAR := Space(15)
Local cHORA
Local cHORA := Space(5)
Local cLJ
Local cLJ := SA1->A1_LOJA
Local cNUMTITULO
Local cNUMTITULO := Space(9)
Local cPARCELA
Local cPARCELA := ""
Local cPRX
Local cPRX := ""
Local cRAZAOSOCIAL
Local cRAZAOSOCIAL := GetAdvFVal("SA1", "A1_NOME",xFilial("SA1")+SA1->A1_COD+SA1->A1_LOJA,1)
Local cTIP
Local cTIP := ""
Local dDATARET
Local cDATARET := CTOD("  /  /  ")
Local dDTEMISS
Local cDTEMISS := CTOD("  /  /  ")
Local dDTVENCTO
Local cDTVENCTO := CTOD("  /  /  ")
Local nDIAS
Local cDIAS := 0
Local nVALOR
Local cVALOR := 0
Local nVLRSALDO
Local cVLRSALDO := 0
Local oBitmap1
Local oGroup1
Local oGroup2
Local oGroup3
Local oGroup4
Local oGroup5
Local oMultiGe1
Local cMultiGe1 := ""
Local _ObsTelCob := ""
Local oSay1
Local oSay10
Local oSay11
Local oSay12
Local oSay13
Local oSay14
Local oSay15
Local oSay16
Local oSay17
Local oSay2
Local oSay3
Local oSay30
Local oSay4
Local oSay5
Local oSay6
Local oSay7
Local oSay8
Local oSay9
Local oSButton1
Local oSButton2
Local nOpca := .F.
Local cLogo := GetSrvProfString("Startpath","") + "telecob.jpg"
Local cQuery := ""
Local _cTikTelCob := "" //GETSXENUM("ZCF","ZCF_CODIGO")
LOCAL _FILIAL 	:= ""
LOCAL _CODIGO	:= ""
LOCAL _TITULO	:= ""
LOCAL _PREFIX	:= ""
LOCAL _PARCEL	:= ""
LOCAL _TIPO		:= ""
LOCAL _NATURE	:= ""
LOCAL _DTVENC	:= CTOD("  /  /  ")
LOCAL _DTREAL	:= CTOD("  /  /  ")
LOCAL _VALOR	:= 0
LOCAL _ACRESC	:= 0
LOCAL _DECRES	:= 0
LOCAL _nRec := 0
LOCAL _NUMBCO	:= ""
LOCAL _HIST		:= ""
LOCAL _VALJUR	:= 0
LOCAL _PORJUR	:= 0
LOCAL _IRRF  	:= 0
LOCAL _ISS   	:= 0
LOCAL _CSLL  	:= 0
LOCAL _COFINS	:= 0
LOCAL _PIS   	:= 0
LOCAL _STATUS	:= ""
LOCAL _OPERAD	:= ""
LOCAL _JUROS 	:= 0
LOCAL _FILORI	:= ""
LOCAL _MULTA 	:= 0
LOCAL _DESCJU	:= 0
Local oComboBo1
Local nComboBo1 := "1"
Local _cProbCobr := " "
Local oBrowse
Local aTitulos 	:= {}
Local HistCob :=""
Local i := 0
Static oDlg
PRIVATE lMsErroAuto := .F.
Private oOk	:= LoadBitMap(GetResources(), "LBOK")
Private oNo	:= LoadBitMap(GetResources(), "LBNO")

If Select("TIT") > 0
	TIT->(DBCLoseArea())
EndIf

cQuery := ""
cQuery += " SELECT		"
cQuery += "  E1_NUM	"
cQuery += " ,E1_PARCELA	"
cQuery += " ,E1_TIPO     "
cQuery += " ,SUBSTRING(E1_EMISSAO,7,2)+'/'+SUBSTRING(E1_EMISSAO,5,2)+'/'+SUBSTRING(E1_EMISSAO,1,4) AS E1_EMISSAO "
cQuery += " ,SUBSTRING(E1_VENCTO,7,2)+'/'+SUBSTRING(E1_VENCTO,5,2)+'/'+SUBSTRING(E1_VENCTO,1,4) AS E1_VENCTO	"
cQuery += " ,DATEDIFF(day,E1_VENCTO,convert(varchar, GetDate(),112)) AS E1_DATRASO	"
cQuery += " ,E1_VALOR	"
cQuery += " ,E1_SALDO   "
cQuery += " FROM  "+RetSQLName("SE1")+" "
cQuery += " WHERE D_E_L_E_T_ = ''	"
cQuery += " AND E1_FILIAL  = '"+xFilial("SE1")+"' "
cQuery += " AND E1_CLIENTE = '"+Alltrim(cCLIENTE)+"'  "
cQuery += " AND E1_LOJA    = '"+Alltrim(cLJ)+"'  "
cQuery += " AND E1_SALDO > 0 	"
cQuery += " AND E1_PREFIXO = '001' 	"
cQuery += " AND E1_VENCTO < Convert(VarChar, GetDate(),112)	"
cQuery += " ORDER BY 1,2 	"
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TIT",.F.,.T.)
DBSelectArea("TIT")
TIT->(DBGoTop())
Do While !TIT->(EOF())
	
	aAdd(aTitulos,	{  			'*',;
	TIT->E1_NUM,;
	TIT->E1_PARCELA,;
	TIT->E1_TIPO,;
	TIT->E1_EMISSAO,;
	TIT->E1_VENCTO,;
	TIT->E1_DATRASO,;
	TransForm(TIT->E1_VALOR,"@E 9,999,999,999.99"),;
	TransForm(TIT->E1_SALDO,"@E 9,999,999,999.99")})
	TIT->(DBSkip())
	
EndDo
TIT->(DBCLoseArea())

If Len(aTitulos) <= 0
	Aadd(aTitulos,{' ',"         ","   ","  ","  /  /  ","  /  /  ",0,0,0})
EndIf


DEFINE MSDIALOG oDlg TITLE "TeleCOBRANÇA" FROM 000, 000  TO 600, 500 COLORS 0, 16777215 PIXEL

@ 002, 003 GROUP oGroup1 TO 297, 247 OF oDlg COLOR 0, 8421504 PIXEL
@ 008, 007 BITMAP oBitmap1 SIZE 327, 100 OF oDlg FILENAME cLogo NOBORDER PIXEL

@ 062, 007 GROUP oGroup5 TO 098, 243 PROMPT "  DADOS CLIENTE  " OF oDlg COLOR 0, 12632256 PIXEL
@ 072, 015 SAY oSay6 PROMPT "CÓDIGO"       SIZE 025, 007 OF oDlg COLORS 0, 12632256 PIXEL
@ 072, 057 SAY oSay7 PROMPT "LOJA"         SIZE 025, 007 OF oDlg COLORS 0, 12632256 PIXEL
@ 072, 075 SAY oSay8 PROMPT "RAZÃO SOCIAL" SIZE 051, 007 OF oDlg COLORS 0, 12632256 PIXEL
@ 072, 195 SAY oSay30 PROMPT "MOTIVO COBRANC." SIZE 051, 007 OF oDlg COLORS 0, 12632256 PIXEL

@ 080, 015 MSGET cCLIENTE  F3 "SA1" VALID CodSA1(cCLIENTE,@cLJ,@cRAZAOSOCIAL) SIZE 033, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
@ 080, 057 MSGET cLJ SIZE 014, 010 OF oDlg COLORS 0, 16777215 PIXEL  WHEN .F.
@ 080, 075 MSGET cRAZAOSOCIAL SIZE 112, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
@ 080, 195 MSCOMBOBOX oComboBo1 VAR nComboBo1 ITEMS {"1","2","3","4","5","6","7","8","9"} SIZE 040, 010 OF oDlg COLORS 0, 16777215 PIXEL


//@ 100, 007 GROUP oGroup4 TO 153, 243 PROMPT "  TÍTULO FINANCEIRO   " OF oDlg COLOR 0, 12632256 PIXEL
oBrowse:= TCBrowse():New( 105 , 007, 237, 57,,{' ',"NºTÍTULO","PARCELA","TIPO","EMISSÃO","VENCIMENTO","D.ATRASO","VLR TÍTULO","LIQ.DEVEDOR"},,oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
oBrowse:SetArray(aTitulos)

// Evento de clique no cabeçalho da browse
oBrowse:bHeaderClick:= {|| MarcaColun(oBrowse,aTitulos),oBrowse:Refresh()}

// Evento de clicar duas vezes na célula
oBrowse:bLDblClick	:= {|| MarcaItem (oBrowse,aTitulos)}
oBrowse:bLine		:= {|| {IIf(aTitulos[oBrowse:nAt,1]==' ',oNo,oOk),;
aTitulos[oBrowse:nAt,2],;
aTitulos[oBrowse:nAt,3],;
aTitulos[oBrowse:nAt,4],;
aTitulos[oBrowse:nAt,5],;
aTitulos[oBrowse:nAt,6],;
aTitulos[oBrowse:nAt,7],;
aTitulos[oBrowse:nAt,8],;
aTitulos[oBrowse:nAt,9]}}

// Antiga Tela para selecionar Titulo ficava nesse trecho

@ 164, 007 GROUP oGroup3 TO 225, 243 PROMPT "  OBSERVAÇÃO  " OF oDlg COLOR 0, 12632256 PIXEL
@ 175, 011 GET oMultiGe1 VAR cMultiGe1 OF oDlg MULTILINE SIZE 227, 45 COLORS 0, 16777215 HSCROLL PIXEL

@ 227, 007 GROUP oGroup2 TO 279, 243 PROMPT "  RETORNO  " OF oDlg COLOR 0, 12632256 PIXEL
@ 236, 015 SAY oSay1 PROMPT "DATA"         SIZE 025, 007 OF oDlg COLORS 0, 12632256 PIXEL
@ 236, 060 SAY oSay2 PROMPT "HORA"         SIZE 025, 007 OF oDlg COLORS 0, 12632256 PIXEL
@ 236, 090 SAY oSay3 PROMPT "CONTATO"      SIZE 036, 007 OF oDlg COLORS 0, 12632256 PIXEL
@ 258, 015 SAY oSay4 PROMPT "FONE/CELULAR" SIZE 042, 007 OF oDlg COLORS 0, 12632256 PIXEL
@ 258, 067 SAY oSay5 PROMPT "E-MAIL"       SIZE 025, 007 OF oDlg COLORS 0, 12632256 PIXEL

@ 244, 015 MSGET cDATARET     SIZE 038, 010 OF oDlg COLORS 0, 16777215 PIXEL
@ 244, 060 MSGET cHORA        PICTURE "99:99" SIZE 021, 010 OF oDlg COLORS 0, 16777215 PIXEL
@ 244, 090 MSGET cCONTATO     SIZE 150, 010 OF oDlg COLORS 0, 16777215 PIXEL
@ 266, 015 MSGET cFONECELULAR PICTURE "@R (99)9999-99999" SIZE 048, 010 OF oDlg COLORS 0, 16777215 PIXEL
@ 266, 067 MSGET cEMAIL       SIZE 173, 010 OF oDlg COLORS 0, 16777215 PIXEL


DEFINE SBUTTON oSButton1 FROM 282, 214 TYPE 01 ACTION (nOpca := .T.,oDlg:End()) OF oDlg ENABLE
DEFINE SBUTTON oSButton2 FROM 282, 185 TYPE 02 ACTION (nOpca := .F.,oDlg:End()) OF oDlg ENABLE


ACTIVATE MSDIALOG oDlg CENTERED

If nOpca
	//_cTikTelCob := TkNumero("ZCF","ZCF_CODIGO")
	Begin Transaction
	
	
	If nComboBo1 == "1"
		_cProbCobr := "Número não está recebendo chamadas (não existe)"
		_cNumCobrM:= "1"
	Elseif nComboBo1 == "2"
		_cProbCobr := "Conseguiu contato, mas não agendou pagamento"
		_cNumCobrM:= "2"		
	Elseif nComboBo1 == "3"
		_cProbCobr := "Número incorreto (alguém atendeu, mas não é o contato da pessoa)"
		_cNumCobrM:= "3"		
	Elseif nComboBo1 == "4"
		_cProbCobr := "Ocupado"
		_cNumCobrM:= "4"		
	Elseif nComboBo1 == "5"
		_cProbCobr := "Desligado"
		_cNumCobrM:= "5"		
	Elseif nComboBo1 == "6"
		_cProbCobr := "Conseguiu contato, agendou pagamento"
		_cNumCobrM:= "6"		
	Elseif nComboBo1 == "7"
		_cProbCobr := "Aguardando compensação de cheque/ liberação do depósito"
		_cNumCobrM:= "7"		
	Elseif nComboBo1 == "8"
		_cProbCobr := "Número só chama"
		_cNumCobrM:= "8"		
	Elseif nComboBo1 == "9"
		_cProbCobr := "Cadastro sem telefone"
		_cNumCobrM:= "9"								
	EndIf
	
	_ObsTelCob := _cProbCobr + Chr(13) + Chr(10)
	_ObsTelCob += cMultiGe1
	
	
	
	For i:= 1 to Len(aTitulos)
	
	If aTitulos[i][1] =="*"
		
		//_nRec := (_cAlias)->(Recno())
		//_cTikTelCob :=  NumSeqZCF()//GetSxeNum("ZCF","ZCF_CODIGO") //StrZero(_nRec,6)//GETSXENUM("ZCF","ZCF_CODIGO")
		//HistCob := MSMM(,TamSx3("ZCF_OBS")[1],,cMultiGe1,1,,,"ZCF","ZCF_CODOBS")
		DbSelectArea("ZCF")
		DbSetOrder(1)
		(_cAlias)->(DBGoBottom())
		
		RecLock("ZCF",.T.)
		ZCF->ZCF_FILIAL  := xFilial("ZCF")
		ZCF->ZCF_CODIGO	 := GetSX8NUM("ZCF","ZCF_CODIGO")//_cTikTelCob
		ZCF->ZCF_CLIENTE := cCLIENTE
		ZCF->ZCF_LOJA	 := cLJ
		ZCF->ZCF_OPERAD	 := RetCodUsr()
		ZCF->ZCF_MOTIVO	 := "000001"
		ZCF->ZCF_DATA	 := Date()
		ZCF->ZCF_CODOBS	 := MSMM(,TamSx3("ZCF_OBS")[1],,_ObsTelCob,1,,,"ZCF","ZCF_CODOBS")//HistCob //
		ZCF->ZCF_PENDEN	 := cDATARET
		ZCF->ZCF_HRPEND	 := cHORA
		ZCF->ZCF_DTINI 	 := Date()
		ZCF->ZCF_STATUS	 := "2"
		ZCF->ZCF_TEL     := TRANSFORM(cFONECELULAR,"@R (99)9999-99999")
		ZCF->ZCF_CONTAT  := cCONTATO
		ZCF->ZCF_EMAIL	 := cEMAIL
		ZCF->ZCF_REGCOB  := _cNumCobrM //_cProbCobr
		ZCF->(MsUnLock())
		ConfirmSX8()
		HistCob := ""
		
		
		cQuery := ""
		cQuery += " SELECT DISTINCT  "
		cQuery += "   E1_NUM			"
		cQuery += "  ,E1_PREFIXO		"
		cQuery += "  ,E1_PARCELA		"
		cQuery += "  ,E1_TIPO			"
		cQuery += "  ,E1_NATUREZ		"
		cQuery += "  ,E1_VENCTO 		"
		cQuery += "  ,E1_VENCREA		"
		cQuery += "  ,E1_VALOR  		"
		cQuery += "  ,E1_ACRESC 		"
		cQuery += "  ,E1_DECRESC		"
		cQuery += "  ,E1_NUMBCO 		"
		cQuery += "  ,E1_HIST   		"
		cQuery += "  ,E1_VALJUR 		"
		cQuery += "  ,E1_PORCJUR		"
		cQuery += "  ,E1_IRRF	"
		cQuery += "  ,E1_ISS    		"
		cQuery += "  ,E1_CSLL	"
		cQuery += "  ,E1_COFINS 	"
		cQuery += "  ,E1_PIS    	"
		cQuery += "  ,E1_JUROS  	"
		cQuery += "  ,E1_FILORIG	"
		cQuery += "  ,E1_MULTA		"
		cQuery += "  ,E1_DESCONT	"
		cQuery += " FROM "+RetSQLName("SE1")
		cQuery += " WHERE D_E_L_E_T_ = ''   "
		cQuery += " AND E1_FILIAL  = 	'" + xFilial("SE1")    +"'  "
		cQuery += " AND E1_NUM     = 	'" + Alltrim(aTitulos[i,2])  +"'  "
		cQuery += " AND E1_PREFIXO = 	'001'  "
		cQuery += " AND E1_CLIENTE = 	'" + Alltrim(cCLIENTE)  +"'  "
		cQuery += " AND E1_LOJA    = 	'" + Alltrim(cLJ)  +"'  "
		cQuery += " AND E1_TIPO    = 	'" + Alltrim(aTitulos[i,4])  +"'  "
		cQuery += " AND E1_PARCELA = 	'" + Alltrim(aTitulos[i,3])  +"'  "
		cQuery := ChangeQuery(cQuery )
		dbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , "SE1TMP" , .T. , .F.)
		
	
		DBSelectArea("SE1TMP")
		SE1TMP->(DBGoTop())
		While !SE1TMP->(Eof())
			_FILIAL := xFilial("ZCG")
			_TITULO	:= SE1TMP->E1_NUM
			_PREFIX	:= SE1TMP->E1_PREFIXO
			_PARCEL	:= SE1TMP->E1_PARCELA
			_TIPO	:= SE1TMP->E1_TIPO
			_NATURE	:= SE1TMP->E1_NATUREZ
			_DTVENC	:= STOD(SE1TMP->E1_VENCTO)
			_DTREAL	:= STOD(SE1TMP->E1_VENCREA)
			_VALOR	:= SE1TMP->E1_VALOR
			_ACRESC	:= SE1TMP->E1_ACRESC
			_DECRES	:= SE1TMP->E1_DECRESC
			_NUMBCO	:= SE1TMP->E1_NUMBCO
			_HIST	:= SE1TMP->E1_HIST
			_VALJUR	:= SE1TMP->E1_VALJUR
			_PORJUR	:= SE1TMP->E1_PORCJUR
			_IRRF  	:= SE1TMP->E1_IRRF
			_ISS   	:= SE1TMP->E1_ISS
			_CSLL  	:= SE1TMP->E1_CSLL
			_COFINS	:= SE1TMP->E1_COFINS
			_PIS   	:= SE1TMP->E1_PIS
			_STATUS	:= "2"
			_OPERAD	:= RetCodUsr()
			_JUROS 	:= SE1TMP->E1_JUROS
			_FILORI	:= SE1TMP->E1_FILORIG
			_MULTA 	:= SE1TMP->E1_MULTA
			_DESCJU	:= SE1TMP->E1_DESCONT
			SE1TMP->(Dbskip())
		Enddo
		SE1TMP->( DBCloseArea())

		DbSelectArea("ZCG")
		DbSetOrder(1)		
		
		RECLOCK("ZCG",.T.)
		ZCG->ZCG_FILIAL := _FILIAL
		ZCG->ZCG_CODIGO	:= GetSX8NUM("ZCG","ZCG_CODIGO")//_cTikTelCob
		ZCG->ZCG_TITULO	:= _TITULO
		ZCG->ZCG_PREFIX	:= _PREFIX
		ZCG->ZCG_PARCEL	:= _PARCEL
		ZCG->ZCG_TIPO	:= _TIPO
		ZCG->ZCG_NATURE	:= _NATURE
		ZCG->ZCG_DTVENC	:= _DTVENC
		ZCG->ZCG_DTREAL	:= _DTREAL
		ZCG->ZCG_VALOR	:= _VALOR
		ZCG->ZCG_ACRESC	:= _ACRESC
		ZCG->ZCG_DECRES	:= _DECRES
		ZCG->ZCG_NUMBCO	:= _NUMBCO
		ZCG->ZCG_HIST	:= _HIST
		ZCG->ZCG_VALJUR	:= _VALJUR
		ZCG->ZCG_PORJUR	:= _PORJUR
		ZCG->ZCG_IRRF  	:= _IRRF
		ZCG->ZCG_ISS   	:= _ISS
		ZCG->ZCG_CSLL  	:= _CSLL
		ZCG->ZCG_COFINS	:= _COFINS
		ZCG->ZCG_PIS   	:= _PIS
		ZCG->ZCG_STATUS	:= _STATUS
		ZCG->ZCG_OPERAD	:= _OPERAD
		ZCG->ZCG_JUROS 	:= _JUROS
		ZCG->ZCG_FILORI	:= _FILORI
		ZCG->ZCG_MULTA 	:= _MULTA
		ZCG->ZCG_DESCJU	:= _DESCJU
		ZCG->(MsUnLock())
		ConfirmSX8()
		
		DbCloseArea("ZCF")
		DbCloseArea("ZCG")
		EndIf
	Next i
	End Transaction
	
EndIf

RestArea(aArea)
Return


//+--------------------------------------------------------------------+
//| Rotina | Mod2Vend | Autor | Robson Luiz (rleg) | Data | 01.01.2007 |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para validar o código do vendedor. |
//+--------------------------------------------------------------------+
//| Uso | Para treinamento e capacitação. |
//+--------------------------------------------------------------------+
Static Function CodSA1( cCLIENTE, cLJ, cRAZAOSOCIAL)

If ExistCpo("SA1",cCLIENTE)
	cLJ   := SA1->A1_LOJA
	cRAZAOSOCIAL := SA1->A1_NOME
Endif

Return(!Empty( cCLIENTE, cLJ, cRAZAOSOCIAL))


//+--------------------------------------------------------------------+
//| Rotina | Mod2Vend | Autor | Robson Luiz (rleg) | Data | 01.01.2007 |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para validar o código do vendedor. |
//+--------------------------------------------------------------------+
//| Uso | Para treinamento e capacitação. |
//+--------------------------------------------------------------------+
Static Function CodSE1(cNUMTITULO, cPRX, cTIP, cPARCELA, dDTEMISS, dDTVENCTO, nDIAS, nVALOR, nVLRSALDO)

cPRX      := SE1->E1_PREFIXO
cTIP      := SE1->E1_TIPO
cPARCELA  := SE1->E1_PARCELA
dDTEMISS  := SE1->E1_EMISSAO
dDTVENCTO := SE1->E1_VENCTO
nDIAS     := DateDiffDay( Date() , SE1->E1_VENCTO  )
nVALOR    := SE1->E1_VALOR
nVLRSALDO := SE1->E1_SALDO


Return(!Empty(cNUMTITULO, cPRX, cTIP, cPARCELA, dDTEMISS, dDTVENCTO, nDIAS, nVALOR, nVLRSALDO))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  MarcaColun  ³Microsiga           º Data ³  10/03/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MarcaColun (oBrowse,aTitulos)

Local nI := 0

If Len(aTitulos) > 0
	For nI := 1 to Len(aTitulos)
		If aTitulos[nI][1] == " "
			aTitulos[nI][1] := "*"
		Else
			aTitulos[nI][1] := " "
		EndIf
	Next
EndIf

Return nil



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MarcaItem ºAutor  Denis Haruo        º Data ³  10/22/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Marca os itens para serem deletados                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MarcaItem(oBrowse,aTitulos)

If	aTitulos[oBrowse:nAt,1] == ' '
	aTitulos[oBrowse:nAt,1] := "*"
Else
	aTitulos[oBrowse:nAt,1] := " "
EndIf

Return nil


/* // Antiga Tela para selecionar Titulo
@ 110, 015 SAY oSay9  PROMPT "Nº TÍTULO"   SIZE 032, 007 OF oDlg COLORS 0, 12632256 PIXEL
@ 110, 063 SAY oSay10 PROMPT "PREFIXO"     SIZE 025, 007 OF oDlg COLORS 0, 12632256 PIXEL
@ 110, 091 SAY oSay11 PROMPT "TIPO"        SIZE 025, 007 OF oDlg COLORS 0, 12632256 PIXEL
@ 110, 116 SAY oSay12 PROMPT "PARCELA"     SIZE 025, 007 OF oDlg COLORS 0, 12632256 PIXEL
@ 110, 152 SAY oSay13 PROMPT "EMISSÃO"     SIZE 025, 007 OF oDlg COLORS 0, 12632256 PIXEL
@ 132, 015 SAY oSay14 PROMPT "VENCIMENTO"  SIZE 038, 007 OF oDlg COLORS 0, 12632256 PIXEL
@ 132, 063 SAY oSay15 PROMPT "D. ATRASO"   SIZE 029, 007 OF oDlg COLORS 0, 12632256 PIXEL
@ 132, 096 SAY oSay16 PROMPT "VLR TÍTULO"  SIZE 037, 007 OF oDlg COLORS 0, 12632256 PIXEL
@ 132, 143 SAY oSay17 PROMPT "LIQ DEVEDOR" SIZE 036, 007 OF oDlg COLORS 0, 12632256 PIXEL

@ 118, 015 MSGET cNUMTITULO F3 "SE1TEL" PICTURE "@!" VALID CodSE1(cNUMTITULO,@cPRX,@cTIP,@cPARCELA,@dDTEMISS,@dDTVENCTO,@nDIAS,@nVALOR,@nVLRSALDO) SIZE 039, 010 OF oDlg COLORS 0, 16777215 PIXEL
@ 118, 063 MSGET cPRX      SIZE 024, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
@ 118, 091 MSGET cTIP      SIZE 019, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
@ 118, 116 MSGET cPARCELA  SIZE 030, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
@ 118, 152 MSGET dDTEMISS  SIZE 036, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
@ 139, 015 MSGET dDTVENCTO SIZE 039, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
@ 139, 063 MSGET nDIAS     SIZE 028, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
@ 139, 096 MSGET nVALOR    PICTURE "@E 999,999,999,999.99" SIZE 045, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
@ 139, 143 MSGET nVLRSALDO PICTURE "@E 999,999,999,999.99" SIZE 045, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
*/// Antiga Tela para selecionar Titulo




/* Rotina que faz gravação de dados
aCabec := {}
aItens := {}
AADD(aCabec,{"ACF_CLIENT" ,cCLIENTE     ,Nil})  //Codigo do cliente
AADD(aCabec,{"ACF_LOJA"   ,cLJ          ,Nil})  //Codigo da loja
AADD(aCabec,{"ACF_OPERAD" ,"000001"     ,Nil})  //Codigo do Operador
AADD(aCabec,{"ACF_OPERA"  ,"2"          ,Nil})  //Ligacao - 1-Receptivo 2-Ativo
AADD(aCabec,{"ACF_CODCON" ,"000001"     ,Nil})  //1-Ativo 2-Receptivo
AADD(aCabec,{"ACF_STATUS" ,"2"          ,Nil})  //Status do Atendimento 1-Atendimento 2-Cobranca 3-Encerrado
AADD(aCabec,{"ACF_MOTIVO" ,"000001"     ,Nil})  //Ocorrencia
AADD(aCabec,{"ACF_PENDEN" ,DDATABASE     ,Nil})  //Data de Retorno
AADD(aCabec,{"ACF_HRPEND" ,cHORA        ,Nil})  //Hora de Retorno
AADD(aCabec,{"ACF_OBS   " ,cMultiGe1     ,Nil})  //Observacao

aLinha := {}
aadd(aLinha,{"ACG_PREFIX" ,_PREFIX ,Nil})
aadd(aLinha,{"ACG_PARCEL" ,_PARCEL ,Nil})
aadd(aLinha,{"ACG_TIPO  " ,_TIPO   ,Nil})
aadd(aLinha,{"ACG_FILORI" ,_FILORI ,Nil})
aadd(aLinha,{"ACG_TITULO" ,_TITULO ,Nil})
aadd(aLinha,{"ACG_STATUS" ,"2"     ,Nil}) //Negociado
aadd(aItens,aLinha)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Executa a chamada da rotina de atendimento CALL CENTER       |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
TMKA271(aCabec,aItens,3,cRotina)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Exibe se foi feita a inclusao ou se retornou erro³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lMsErroAuto
ConOut("Atendimento incluído com sucesso! ")
Else
ConOut("Erro na inclusão!")
Mostraerro()
DisarmTransaction()
Break
Endif

*/
//+--------------------------------------------------------------------+
//| Rotina | Mod2Vend | Autor | Robson Luiz (rleg) | Data | 01.01.2007 |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para validar o código do vendedor. |
//+--------------------------------------------------------------------+
//| Uso | Para treinamento e capacitação. |
//+--------------------------------------------------------------------+



Static Function NumSeqZCF()
Local NewCodZcf := ""
Local cQuery := ""


			cQuery := ""
			cQuery += " SELECT TOP 1  "
			cQuery += "   REPLICATE('0', 6 - LEN(ZCF_CODIGO+1))+ CAST(ZCF_CODIGO+1 AS VARCHAR(6)) AS 'NUMSEQ'			"
			cQuery += " FROM "+RetSQLName("ZCF")
			cQuery += " WHERE D_E_L_E_T_ = ''   "
			cQuery += " ORDER BY ZCF_CODIGO DESC 	"
			cQuery := ChangeQuery(cQuery )
			dbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , "ZCFTMP" , .T. , .F.)
			
	
			DBSelectArea("ZCFTMP")
			ZCFTMP->(DBGoTop())
			While !ZCFTMP->(Eof())
				NewCodZcf := ZCFTMP->NUMSEQ
			ZCFTMP->(Dbskip())
			Enddo
			ZCFTMP->( DBCloseArea())

return(NewCodZcf)