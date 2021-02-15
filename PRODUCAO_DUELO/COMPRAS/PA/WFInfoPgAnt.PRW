#Include "PROTHEUS.CH"  
#INCLUDE "TOPCONN.CH"
#include "ap5mail.ch"  
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RAltDtCR ºAutor  ³Denis Tsuchiya      º Data ³  01/31/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função para envio de e-mails aos monitore                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function  WFYesPA(cPedSC7,cCodApro,cObsAp,cCodPgSC7) 

//Variaveis do Processo oHTML
Local cCodProcesso, cCodStatus, cHtmlModelo, oHtml, oProcess
Local cUsuarioProtheus, cCodProduto, cTexto, cAssunto , _cMsgAss
Local cMailSOL   := ""
Local cMailApro  := "" 
Local cUserApro  := cCodApro
Local MsgObs     := cObsAp
Local cNameApro  := "" 
Local _Count     := 0 
Local cQuery     := ""
Local cMailTI    := GetMv("US_MAILTI")
Local cMailFIN   := GetMv("US_MAILFIN")
Local _cNumPC    := ""
Local _cCompr    := ""
Local _nVlrPC    := ""
Local _nFornec   := ""
Local _cPrfx	 := ""
Local _cNumPA    := ""
Local _nVlrPA    := ""
Local _cNumPed   := cPedSC7 
Local _cCodPag   := cCodPgSC7    //RAFAEL ALMEIDA SIGACORP - (12/05/2017)
Local _cDesPag   := ""           //RAFAEL ALMEIDA SIGACORP - (12/05/2017)
Local _cPagCod   := ""           //RAFAEL ALMEIDA SIGACORP - (12/05/2017)
Local _cNmApro   := ""		 //RAFAEL ALMEIDA SIGACORP - (12/05/2017)
local _cDtpgPA	 := ""
local _cEmissa	 := ""


Local lServProd := IIf(GetServerIP() == '192.168.1.4', .T.,.F.)  
Local _lVlddRetItn := .F.

_cDesPag := GetAdvFVal("SE4", "E4_DESCRI",xFilial("SE4")+_cCodPag,1)  //RAFAEL ALMEIDA SIGACORP - (12/05/2017)
_cPagCod := _cCodPag +" - "+ _cDesPag                                 //RAFAEL ALMEIDA SIGACORP - (12/05/2017)


DbSelectArea("SX6") //Abre a tabela SX6
DbSetOrder(1) //Se posiciona no primeiro indice
If DbSeek(xFilial("SX6")+"MV_WFMLBOX") //Verifique se o parametro existe
      RecLock("SX6",.F.) //Abre o registro para edição
      SX6->X6_CONTEUD := "WORKFLOW"  //atualiza apenas o campo desejado
      MsUnLock() //salva o registro
EndIf

cQuery := " "
cQuery += " 	SELECT 	"
cQuery += " 	 C7_NUM	"
cQuery += " 	,C7_USER	"
cQuery += " 	,(SELECT SUM(C7_TOTAL) FROM  "+ RETSQLNAME("SC7")+"  WHERE D_E_L_E_T_ <> '*'AND C7_NUM =  '"+ Alltrim(_cNumPed) +"' AND C7_FILIAL = '"+xFilial("SC7")+"' ) AS C7_TOTPC	"
cQuery += " 	,C7_FORNECE+'-'+(SELECT A2_NREDUZ FROM  "+ RETSQLNAME("SA2")+"  WHERE D_E_L_E_T_ <> '*' AND A2_COD =  C7_FORNECE AND A2_LOJA = C7_LOJA AND A2_FILIAL = '"+xFilial("SA2")+"' ) AS C7_FORNECE	"
cQuery += " 	,'ANT' AS C7_PRFX	"
cQuery += " 	,'PC'+C7_NUM AS C7_TITULO	"
cQuery += " 	,C7_VLRPA	"
cQuery += " 	,REPLICATE('0', 4 - LEN(C7_ITEM)) + RTrim(C7_ITEM) AS C7_ITEM	"
cQuery += " 	,C7_PRODUTO	"
cQuery += " 	,(SELECT B1_DESC FROM  "+ RETSQLNAME("SB1")+"  WHERE D_E_L_E_T_ <> '*' AND B1_COD = C7_PRODUTO AND B1_FILIAL = '"+xFilial("SB1")+"' ) AS C7_DESC	"
//cQuery += " 	,C7_DESCRI AS C7_DESC	"
cQuery += " 	,C7_QUANT	"
cQuery += " 	,C7_PRECO	"
cQuery += " 	,C7_TOTAL	"
cQuery += " 	,C7_OBS	"
cQuery += " 	,C7_UM	"
cQuery += "     ,SUBSTRING(C7_DTPGTPA,7,2)+'/'+SUBSTRING(C7_DTPGTPA,5,2)+'/'+SUBSTRING(C7_DTPGTPA,1,4) AS C7_DTPGTPA  "
cQuery += "     ,SUBSTRING(C7_EMISSAO,7,2)+'/'+SUBSTRING(C7_EMISSAO,5,2)+'/'+SUBSTRING(C7_EMISSAO,1,4) AS C7_EMISSAO  "
cQuery += " 	FROM "+ RETSQLNAME("SC7")+"  "
cQuery += " 	WHERE D_E_L_E_T_ <> '*'	"
cQuery += " 	AND C7_NUM = '"+ Alltrim(_cNumPed) +"'	"
cQuery += " 	AND C7_FILIAL = '"+xFilial("SC7")+"' "
cQuery += " 	ORDER BY C7_NUM, REPLICATE('0', 4 - LEN(C7_ITEM)) + RTrim(C7_ITEM) 	"
cQuery:= ChangeQuery(cQuery)
dbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , "DOC" , .T. , .F.)

DBSelectArea("DOC")
DOC->(DbGoTop())



While !DOC->(Eof())

	cMailSOL   :=  UsrRetMail(DOC->C7_USER)
	cMailApro  :=  UsrRetMail(cUserApro)
	_cNmApro   :=  UsrFullName(cUserApro)  //RAFAEL ALMEIDA - SIGACORP (12/05/2017)	

	_cNumPC    := Alltrim(DOC->C7_NUM)
    _cCompr    := UsrRetName(DOC->C7_USER)
	_nVlrPC    := TRANSFORM(DOC->C7_TOTPC, "@E 999,999,999.99")	
	_nFornec   := Alltrim(DOC->C7_FORNECE)        

	_cPrfx	   := Alltrim(DOC->C7_PRFX)
	_cNumPA    := DOC->C7_TITULO
	_nVlrPA    := TRANSFORM(DOC->C7_VLRPA, "@E 999,999,999.99")
	_cDtpgPA   := alltrim(DOC->C7_DTPGTPA)
	_cEmissa   := alltrim(DOC->C7_EMISSAO)

//alert(_cDtpgtPA)

	_lVlddRetItn := .F.	

	cCodProcesso := "WF_106"	
	//Solicitando Recebimento do Material no Almoxarifado
	cHtmlModelo := "\Workflow\WF_HTML\ADM\WFINFOPA_Note.html"
	cAssunto := "LIBERAÇÃO - PAGAMENTO ANTECIPADO (AUTORIZADO)"
	//cAssunto :=  DecodeUTF8(_cMsgAss, "cp1252")
	cUsuarioProtheus:= SubStr(cUsuario,7,15)
	oProcess:= TWFProcess():New(cCodProcesso, cAssunto)
	cTitProc :=  "WF_106"
	oProcess:NewTask(cTitProc, cHtmlModelo)
	oHtml	:= oProcess:oHTML

	oProcess:oHtml:ValByName( "Prfx"		,Alltrim(_cPrfx))
	oProcess:oHtml:ValByName( "NumPa"  		,Alltrim(_cNumPA))
	oProcess:oHtml:ValByName( "VlrPa"		,_nVlrPA)
	oProcess:oHtml:ValByName( "DtpgPA"		,alltrim(_cDtpgPA))
	oProcess:oHtml:ValByName( "DtEmis"		,alltrim(_cEmissa))
	oProcess:oHtml:ValByName( "cNumPc" 		,Alltrim(_cNumPC))
	oProcess:oHtml:ValByName( "cComp"  		,Alltrim(_cCompr))
	oProcess:oHtml:ValByName( "VlrPc"  		,_nVlrPC)
	oProcess:oHtml:ValByName( "cFornc"	    ,Alltrim(_nFornec))				
	oProcess:oHtml:ValByName( "cObsApr"	    ,Alltrim(MsgObs))	
	
	oProcess:oHtml:ValByName( "cUsrApr"	    ,Alltrim(_cNmApro))     //RAFAEL ALMEIDA SIGACORP - (12/05/2017)
	oProcess:oHtml:ValByName( "cCodPg"	    ,Alltrim(_cPagCod))	    //RAFAEL ALMEIDA SIGACORP - (12/05/2017)
	

	While !DOC->(Eof())	.AND. DOC->C7_NUM = _cNumPC
			aAdd( (oProcess:oHtml:ValByName( "ti.cItem"     )), Alltrim(DOC->C7_ITEM))
			aAdd( (oProcess:oHtml:ValByName( "ti.cCodProd"  )), Alltrim(DOC->C7_PRODUTO))
			aAdd( (oProcess:oHtml:ValByName( "ti.cDescProd" )), Alltrim(DOC->C7_DESC))
			aAdd( (oProcess:oHtml:ValByName( "ti.nQtd"      )), TRANSFORM(DOC->C7_QUANT, "@E 999999999.9999"))			
			aAdd( (oProcess:oHtml:ValByName( "ti.nPrc"      )), TRANSFORM(DOC->C7_PRECO, "@E 9,999,999.99999"))
			aAdd( (oProcess:oHtml:ValByName( "ti.nTot"      )), TRANSFORM(DOC->C7_TOTAL, "@E 999,999,999.99"))
			aAdd( (oProcess:oHtml:ValByName( "ti.cObs"      )), Alltrim(DOC->C7_OBS)) 
			aAdd( (oProcess:oHtml:ValByName( "ti.cUm"       )), Alltrim(DOC->C7_UM))			
		   _lVlddRetItn := .T.
		DOC->(DbSkip())
	EndDo
	    If _lVlddRetItn
			oProcess:cSubject := DecodeUTF8(EncodeUTF8(cAssunto, "cp1252"), "cp1252")
//			oProcess:cTo :=  cMailSOL +";"+ cMailApro +";"+ cMailTI +";"+ cMailFIN
			oProcess:cTo :=  cMailTI +";" + cMailFIN +";" + cMailApro + ";"  + cMailSOL +";"
			oProcess:Start()
			oProcess:Finish()
	    EndIf
EndDo
DOC->( DBCloseArea())
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RAltDtCR ºAutor  ³Denis Tsuchiya      º Data ³  01/31/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função para envio de e-mails aos monitore                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function  WFNoPA(cPedSC7,cCodApro,cObsAp,cCodPgSC7) 

//Variaveis do Processo oHTML
Local cCodProcesso, cCodStatus, cHtmlModelo, oHtml, oProcess
Local cUsuarioProtheus, cCodProduto, cTexto, cAssunto , _cMsgAss
Local cMailSOL   := ""
Local cMailApro  := "" 
Local cUserApro  := cCodApro
Local MsgObs     := cObsAp
Local cNameApro  := "" 
Local _Count     := 0 
Local cQuery     := ""
Local cMailTI     := GetMv("US_MAILTI")
Local cMailFIN    := GetMv("US_MAILFIN")
Local _cNumPC    := ""
Local _cCompr    := ""
Local _nVlrPC    := ""
Local _nFornec   := ""
Local _cPrfx	 := ""
Local _cNumPA    := ""
Local _nVlrPA    := ""
Local _cNumPed   := cPedSC7 
Local _cCodPag   := cCodPgSC7    //RAFAEL ALMEIDA SIGACORP - (12/05/2017)
Local _cDesPag   := ""           //RAFAEL ALMEIDA SIGACORP - (12/05/2017)
Local _cPagCod   := ""           //RAFAEL ALMEIDA SIGACORP - (12/05/2017)
Local _cNmApro   := ""		 //RAFAEL ALMEIDA SIGACORP - (12/05/2017)

Local lServProd := IIf(GetServerIP() == '192.168.1.4', .T.,.F.)  
Local _lVlddRetItn := .F.

_cDesPag := GetAdvFVal("SE4", "E4_DESCRI",xFilial("SE4")+_cCodPag,1)  //RAFAEL ALMEIDA SIGACORP - (12/05/2017)
_cPagCod := _cCodPag +" - "+ _cDesPag                                 //RAFAEL ALMEIDA SIGACORP - (12/05/2017)

DbSelectArea("SX6") //Abre a tabela SX6
DbSetOrder(1) //Se posiciona no primeiro indice
If DbSeek(xFilial("SX6")+"MV_WFMLBOX") //Verifique se o parametro existe
      RecLock("SX6",.F.) //Abre o registro para edição
      SX6->X6_CONTEUD := "WORKFLOW"  //atualiza apenas o campo desejado
      MsUnLock() //salva o registro
EndIf

cQuery := " "
cQuery += " 	SELECT 	"
cQuery += " 	 C7_NUM	"
cQuery += " 	,C7_USER	"
cQuery += " 	,(SELECT SUM(C7_TOTAL) FROM  "+ RETSQLNAME("SC7")+"  WHERE D_E_L_E_T_ <> '*'AND C7_NUM =  '"+ Alltrim(_cNumPed) +"' AND C7_FILIAL = '"+xFilial("SC7")+"' ) AS C7_TOTPC	"
cQuery += " 	,C7_FORNECE+'-'+(SELECT A2_NREDUZ FROM  "+ RETSQLNAME("SA2")+"  WHERE D_E_L_E_T_ <> '*' AND A2_COD =  C7_FORNECE AND A2_LOJA = C7_LOJA AND A2_FILIAL = '"+xFilial("SA2")+"' ) AS C7_FORNECE	"
cQuery += " 	,'ANT' AS C7_PRFX	"
cQuery += " 	,'PC'+C7_NUM AS C7_TITULO	"
cQuery += " 	,C7_VLRPA	"
cQuery += " 	,REPLICATE('0', 4 - LEN(C7_ITEM)) + RTrim(C7_ITEM) AS C7_ITEM	"
cQuery += " 	,C7_PRODUTO	"
cQuery += " 	,(SELECT B1_DESC FROM  "+ RETSQLNAME("SB1")+"  WHERE D_E_L_E_T_ <> '*' AND B1_COD = C7_PRODUTO AND B1_FILIAL = '"+xFilial("SB1")+"' ) AS C7_DESC	"
//cQuery += " 	,C7_DESCRI AS C7_DESC	"
cQuery += " 	,C7_QUANT	"
cQuery += " 	,C7_PRECO	"
cQuery += " 	,C7_TOTAL	"
cQuery += " 	,C7_OBS	"
cQuery += " 	,C7_UM	"
cQuery += " 	FROM "+ RETSQLNAME("SC7")+"  "
cQuery += " 	WHERE D_E_L_E_T_ <> '*'	"
cQuery += " 	AND C7_NUM = '"+ Alltrim(_cNumPed) +"'	"
cQuery += " 	AND C7_FILIAL = '"+xFilial("SC7")+"' "
cQuery += " 	ORDER BY C7_NUM, REPLICATE('0', 4 - LEN(C7_ITEM)) + RTrim(C7_ITEM) 	"
cQuery:= ChangeQuery(cQuery)
dbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , "DOC" , .T. , .F.)

DBSelectArea("DOC")
DOC->(DbGoTop())

While !DOC->(Eof())

	cMailSOL   :=  UsrRetMail(DOC->C7_USER)
	cMailApro  :=  UsrRetMail(cUserApro)
	_cNmApro   :=  UsrFullName(cUserApro)  //RAFAEL ALMEIDA - SIGACORP (12/05/2017)
	
	_cNumPC    := Alltrim(DOC->C7_NUM)
    _cCompr    := UsrRetName(DOC->C7_USER)
	_nVlrPC    := TRANSFORM(DOC->C7_TOTPC, "@E 999,999,999.99")	
	_nFornec   := Alltrim(DOC->C7_FORNECE)        

	_cPrfx	   := Alltrim(DOC->C7_PRFX)
	_cNumPA    := DOC->C7_TITULO
	_nVlrPA    := TRANSFORM(DOC->C7_VLRPA, "@E 999,999,999.99")

	_lVlddRetItn := .F.	

	cCodProcesso := "WF_106"	
	//Solicitando Recebimento do Material no Almoxarifado
	cHtmlModelo := "\Workflow\WF_HTML\ADM\WFINFOPA_CANC.html"
	cAssunto := "LIBERAÇÃO - PAGAMENTO ANTECIPADO (NÃO AUTORIZADO)"
	//cAssunto :=  DecodeUTF8(_cMsgAss, "cp1252")
	cUsuarioProtheus:= SubStr(cUsuario,7,15)
	oProcess:= TWFProcess():New(cCodProcesso, cAssunto)
	cTitProc :=  "WF_106"
	oProcess:NewTask(cTitProc, cHtmlModelo)
	oHtml	:= oProcess:oHTML

	oProcess:oHtml:ValByName( "VlrPa"		,_nVlrPA)
	oProcess:oHtml:ValByName( "cNumPc" 		,Alltrim(_cNumPC))
	oProcess:oHtml:ValByName( "VlrPc"  		,_nVlrPC)
	oProcess:oHtml:ValByName( "cFornc"		,Alltrim(_nFornec))				
	oProcess:oHtml:ValByName( "cObsApr"		,Alltrim(MsgObs)) 	
	oProcess:oHtml:ValByName( "cUsrApr"	    ,Alltrim(_cNmApro))     //RAFAEL ALMEIDA SIGACORP - (12/05/2017)
	oProcess:oHtml:ValByName( "cCodPg"	    ,Alltrim(_cPagCod))	    //RAFAEL ALMEIDA SIGACORP - (12/05/2017)	

	While !DOC->(Eof())	.AND. DOC->C7_NUM = _cNumPC
			aAdd( (oProcess:oHtml:ValByName( "ti.cItem"     )), Alltrim(DOC->C7_ITEM))
			aAdd( (oProcess:oHtml:ValByName( "ti.cCodProd"  )), Alltrim(DOC->C7_PRODUTO))
			aAdd( (oProcess:oHtml:ValByName( "ti.cDescProd" )), Alltrim(DOC->C7_DESC))
			aAdd( (oProcess:oHtml:ValByName( "ti.nQtd"      )), TRANSFORM(DOC->C7_QUANT, "@E 999999999.9999"))			
			aAdd( (oProcess:oHtml:ValByName( "ti.nPrc"      )), TRANSFORM(DOC->C7_PRECO, "@E 9,999,999.99999"))
			aAdd( (oProcess:oHtml:ValByName( "ti.nTot"      )), TRANSFORM(DOC->C7_TOTAL, "@E 999,999,999.99"))
			aAdd( (oProcess:oHtml:ValByName( "ti.cObs"      )), Alltrim(DOC->C7_OBS)) 
			aAdd( (oProcess:oHtml:ValByName( "ti.cUm"       )), Alltrim(DOC->C7_UM))			
		   _lVlddRetItn := .T.
		DOC->(DbSkip())
	EndDo
	    If _lVlddRetItn
			oProcess:cSubject := DecodeUTF8(EncodeUTF8(cAssunto, "cp1252"), "cp1252")
//			oProcess:cTo :=  cMailSOL +";"+ cMailApro +";"+ cMailTI +";"+ cMailFIN
			oProcess:cTo :=  cMailTI +";" + cMailApro + ";" + cMailSOL +";"
			oProcess:Start()
			oProcess:Finish()
	    EndIf
EndDo
DOC->( DBCloseArea())
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RAltDtCR ºAutor  ³Denis Tsuchiya      º Data ³  01/31/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função para envio de e-mails aos monitore                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function  WFNoPC(cPedSC7,cCodApro,cObsAp,cCodPgSC7) 

//Variaveis do Processo oHTML
Local cCodProcesso, cCodStatus, cHtmlModelo, oHtml, oProcess
Local cUsuarioProtheus, cCodProduto, cTexto, cAssunto , _cMsgAss
Local cMailSOL   := ""
Local cMailApro  := "" 
Local cMailSC    := ""
Local cUserApro  := cCodApro 
Local MsgObs     := cObsAp
Local cNameApro  := "" 
Local _Count     := 0 
Local cQuery     := ""
Local cMailTI     := GetMv("US_MAILTI")
Local _cNumPC    := ""
Local _cCompr    := ""
Local _nVlrPC    := ""
Local _nFornec   := ""
Local _cPrfx	 := ""
Local _cNumPA    := ""
Local _nVlrPA    := ""
Local _cNumPed   := cPedSC7 
Local _cCodPag   := cCodPgSC7    //RAFAEL ALMEIDA SIGACORP - (12/05/2017)
Local _cDesPag   := ""           //RAFAEL ALMEIDA SIGACORP - (12/05/2017)
Local _cPagCod   := ""           //RAFAEL ALMEIDA SIGACORP - (12/05/2017)
Local _cNmApro   := ""			//RAFAEL ALMEIDA SIGACORP - (12/05/2017)

Local lServProd := IIf(GetServerIP() == '192.168.1.4', .T.,.F.)  
Local _lVlddRetItn := .F.

_cDesPag := GetAdvFVal("SE4", "E4_DESCRI",xFilial("SE4")+_cCodPag,1)  //RAFAEL ALMEIDA SIGACORP - (12/05/2017)
_cPagCod := _cCodPag +" - "+ _cDesPag                                 //RAFAEL ALMEIDA SIGACORP - (12/05/2017)

DbSelectArea("SX6") //Abre a tabela SX6
DbSetOrder(1) //Se posiciona no primeiro indice
If DbSeek(xFilial("SX6")+"MV_WFMLBOX") //Verifique se o parametro existe
      RecLock("SX6",.F.) //Abre o registro para edição
      SX6->X6_CONTEUD := "WORKFLOW"  //atualiza apenas o campo desejado
      MsUnLock() //salva o registro
EndIf

cQuery := " "
cQuery += " 	SELECT 	"
cQuery += " 	 C7_NUM	"
cQuery += " 	,C7_USER	"
cQuery += " 	,(SELECT SUM(C7_TOTAL) FROM  "+ RETSQLNAME("SC7")+"  WHERE D_E_L_E_T_ <> '*'AND C7_NUM =  '"+ Alltrim(_cNumPed) +"' AND C7_FILIAL = '"+xFilial("SC7")+"' ) AS C7_TOTPC	"
cQuery += " 	,C7_FORNECE+'-'+(SELECT A2_NREDUZ FROM  "+ RETSQLNAME("SA2")+"  WHERE D_E_L_E_T_ <> '*' AND A2_COD =  C7_FORNECE AND A2_LOJA = C7_LOJA AND A2_FILIAL = '"+xFilial("SA2")+"' ) AS C7_FORNECE	"
cQuery += " 	,REPLICATE('0', 4 - LEN(C7_ITEM)) + RTrim(C7_ITEM) AS C7_ITEM	"
cQuery += " 	,C7_PRODUTO	"
cQuery += " 	,(SELECT B1_DESC FROM  "+ RETSQLNAME("SB1")+"  WHERE D_E_L_E_T_ <> '*' AND B1_COD = C7_PRODUTO AND B1_FILIAL = '"+xFilial("SB1")+"' ) AS C7_DESC	"
//cQuery += " 	,C7_DESCRI AS C7_DESC	"
cQuery += " 	,C7_QUANT	"
cQuery += " 	,C7_PRECO	"
cQuery += " 	,C7_TOTAL	"
cQuery += " 	,(SELECT C1_USER FROM SC1040 WHERE D_E_L_E_T_ <> '*' AND C1_NUM = C7_NUMSC AND C1_ITEM = C7_ITEMSC AND C1_PRODUTO = C7_PRODUTO) AS C7_SOLIC	 "
cQuery += " 	,C7_OBS	"
cQuery += " 	,C7_UM	"
cQuery += " 	FROM "+ RETSQLNAME("SC7")+"  "
cQuery += " 	WHERE D_E_L_E_T_ <> '*'	"
cQuery += " 	AND C7_NUM = '"+ Alltrim(_cNumPed) +"'	"
cQuery += " 	AND C7_FILIAL = '"+xFilial("SC7")+"' "
cQuery += " 	ORDER BY C7_NUM, REPLICATE('0', 4 - LEN(C7_ITEM)) + RTrim(C7_ITEM) 	"
cQuery:= ChangeQuery(cQuery)
dbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , "DOC" , .T. , .F.)

DBSelectArea("DOC")
DOC->(DbGoTop())

While !DOC->(Eof())

	cMailSOL   :=  UsrRetMail(DOC->C7_USER)
	cMailApro  :=  UsrRetMail(cUserApro)
	cMailSC    :=  UsrRetMail(DOC->C7_SOLIC)
	_cNmApro   :=  UsrFullName(cUserApro)  //RAFAEL ALMEIDA - SIGACORP (12/05/2017)

	_cNumPC    := Alltrim(DOC->C7_NUM)
    _cCompr    := UsrRetName(DOC->C7_USER)
	_nVlrPC    := TRANSFORM(DOC->C7_TOTPC, "@E 999,999,999.99")	
	_nFornec   := Alltrim(DOC->C7_FORNECE)        


	_lVlddRetItn := .F.	

	cCodProcesso := "WF_106"	
	//Solicitando Recebimento do Material no Almoxarifado
	cHtmlModelo := "\Workflow\WF_HTML\ADM\WF_PEDCOM_N_AUT.html"
	cAssunto := "LIBERAÇÃO - PEDIDO DE COMPRA (NÃO AUTORIZADO)"
	//cAssunto :=  DecodeUTF8(_cMsgAss, "cp1252")
	cUsuarioProtheus:= SubStr(cUsuario,7,15)
	oProcess:= TWFProcess():New(cCodProcesso, cAssunto)
	cTitProc :=  "WF_106"
	oProcess:NewTask(cTitProc, cHtmlModelo)
	oHtml	:= oProcess:oHTML



	oProcess:oHtml:ValByName( "cNumPc" 		,Alltrim(_cNumPC))
	oProcess:oHtml:ValByName( "VlrPc"  		,_nVlrPC)
	oProcess:oHtml:ValByName( "cFornc"	    ,Alltrim(_nFornec))				

	oProcess:oHtml:ValByName( "cUsrApr"	    ,Alltrim(_cNmApro))     //RAFAEL ALMEIDA SIGACORP - (12/05/2017)
	oProcess:oHtml:ValByName( "cCodPg"	    ,Alltrim(_cPagCod))	    //RAFAEL ALMEIDA SIGACORP - (12/05/2017)

	oProcess:oHtml:ValByName( "cObsApr"	,Alltrim(MsgObs))
	
	

	While !DOC->(Eof())	.AND. DOC->C7_NUM = _cNumPC
			aAdd( (oProcess:oHtml:ValByName( "ti.cItem"     )), Alltrim(DOC->C7_ITEM))
			aAdd( (oProcess:oHtml:ValByName( "ti.cCodProd"  )), Alltrim(DOC->C7_PRODUTO))
			aAdd( (oProcess:oHtml:ValByName( "ti.cDescProd" )), Alltrim(DOC->C7_DESC))
			aAdd( (oProcess:oHtml:ValByName( "ti.nQtd"      )), TRANSFORM(DOC->C7_QUANT, "@E 999999999.9999"))			
			aAdd( (oProcess:oHtml:ValByName( "ti.nPrc"      )), TRANSFORM(DOC->C7_PRECO, "@E 9,999,999.99999"))
			aAdd( (oProcess:oHtml:ValByName( "ti.nTot"      )), TRANSFORM(DOC->C7_TOTAL, "@E 999,999,999.99"))
			aAdd( (oProcess:oHtml:ValByName( "ti.cObs"      )), Alltrim(DOC->C7_OBS)) 
			aAdd( (oProcess:oHtml:ValByName( "ti.cUm"       )), Alltrim(DOC->C7_UM))												
		   _lVlddRetItn := .T.
		DOC->(DbSkip())
	EndDo
	    If _lVlddRetItn
			oProcess:cSubject := DecodeUTF8(EncodeUTF8(cAssunto, "cp1252"), "cp1252")
			oProcess:cTo :=  cMailTI +";" + cMailApro + ";" + cMailSOL +";" + cMailSC + ";"
			oProcess:Start()
			oProcess:Finish()
	    EndIf
EndDo
DOC->( DBCloseArea())
Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RAltDtCR ºAutor  ³Denis Tsuchiya      º Data ³  01/31/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função para envio de e-mails aos monitore                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function  WFYesPC(cPedSC7,cCodApro,cObsAp,cCodPgSC7) 

//Variaveis do Processo oHTML
Local cCodProcesso, cCodStatus, cHtmlModelo, oHtml, oProcess
Local cUsuarioProtheus, cCodProduto, cTexto, cAssunto , _cMsgAss
Local cMailSOL   := ""
Local cMailApro  := "" 
Local cMailSC    := ""
Local cUserApro  := cCodApro
Local MsgObs     := cObsAp
Local cNameApro  := "" 
Local _Count     := 0 
Local cQuery     := ""
Local cMailTI     := GetMv("US_MAILTI")
Local _cNumPC    := ""
Local _cCompr    := ""
Local _nVlrPC    := ""
Local _nFornec   := ""
Local _cPrfx	 := ""
Local _cNumPA    := ""
Local _nVlrPA    := ""
Local _cNumPed   := cPedSC7 
Local _cCodPag   := cCodPgSC7    //RAFAEL ALMEIDA SIGACORP - (12/05/2017)
Local _cDesPag   := ""           //RAFAEL ALMEIDA SIGACORP - (12/05/2017)
Local _cPagCod   := ""           //RAFAEL ALMEIDA SIGACORP - (12/05/2017)
Local _cNmApro   := ""			//RAFAEL ALMEIDA SIGACORP - (12/05/2017)


Local lServProd := IIf(GetServerIP() == '192.168.1.4', .T.,.F.)  
Local _lVlddRetItn := .F.

_cDesPag := GetAdvFVal("SE4", "E4_DESCRI",xFilial("SE4")+_cCodPag,1)  //RAFAEL ALMEIDA SIGACORP - (12/05/2017)
_cPagCod := _cCodPag +" - "+ _cDesPag                                 //RAFAEL ALMEIDA SIGACORP - (12/05/2017)

DbSelectArea("SX6") //Abre a tabela SX6
DbSetOrder(1) //Se posiciona no primeiro indice
If DbSeek(xFilial("SX6")+"MV_WFMLBOX") //Verifique se o parametro existe
      RecLock("SX6",.F.) //Abre o registro para edição
      SX6->X6_CONTEUD := "WORKFLOW"  //atualiza apenas o campo desejado
      MsUnLock() //salva o registro
EndIf

cQuery := " "
cQuery += " 	SELECT 	"
cQuery += " 	 C7_NUM	"
cQuery += " 	,C7_USER	"
cQuery += " 	,(SELECT SUM(C7_TOTAL) FROM  "+ RETSQLNAME("SC7")+"  WHERE D_E_L_E_T_ <> '*'AND C7_NUM =  '"+ Alltrim(_cNumPed) +"' AND C7_FILIAL = '"+xFilial("SC7")+"' ) AS C7_TOTPC	"
cQuery += " 	,C7_FORNECE+'-'+(SELECT A2_NREDUZ FROM  "+ RETSQLNAME("SA2")+"  WHERE D_E_L_E_T_ <> '*' AND A2_COD =  C7_FORNECE AND A2_LOJA = C7_LOJA AND A2_FILIAL = '"+xFilial("SA2")+"' ) AS C7_FORNECE	"
cQuery += " 	,REPLICATE('0', 4 - LEN(C7_ITEM)) + RTrim(C7_ITEM) AS C7_ITEM	"
cQuery += " 	,C7_PRODUTO	"
cQuery += " 	,(SELECT B1_DESC FROM  "+ RETSQLNAME("SB1")+"  WHERE D_E_L_E_T_ <> '*' AND B1_COD = C7_PRODUTO AND B1_FILIAL = '"+xFilial("SB1")+"' ) AS C7_DESC	"
//cQuery += " 	,C7_DESCRI AS C7_DESC	"
cQuery += " 	,C7_QUANT	"
cQuery += " 	,C7_PRECO	"
cQuery += " 	,C7_TOTAL	"
cQuery += " 	,(SELECT C1_USER FROM SC1040 WHERE D_E_L_E_T_ <> '*' AND C1_NUM = C7_NUMSC AND C1_ITEM = C7_ITEMSC AND C1_PRODUTO = C7_PRODUTO) AS C7_SOLIC	 "
cQuery += " 	,C7_OBS	"
cQuery += " 	,C7_UM	"
cQuery += " 	FROM "+ RETSQLNAME("SC7")+"  "
cQuery += " 	WHERE D_E_L_E_T_ <> '*'	"
cQuery += " 	AND C7_NUM = '"+ Alltrim(_cNumPed) +"'	"
cQuery += " 	AND C7_FILIAL = '"+xFilial("SC7")+"' "
cQuery += " 	ORDER BY C7_NUM, REPLICATE('0', 4 - LEN(C7_ITEM)) + RTrim(C7_ITEM) 	"
cQuery:= ChangeQuery(cQuery)
dbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , "DOC" , .T. , .F.)

DBSelectArea("DOC")
DOC->(DbGoTop())



While !DOC->(Eof())

	cMailSOL   :=  UsrRetMail(DOC->C7_USER)
	cMailApro  :=  UsrRetMail(cUserApro)
	cMailSC    :=  UsrRetMail(DOC->C7_SOLIC)
	_cNmApro   :=  UsrFullName(cUserApro)  //RAFAEL ALMEIDA - SIGACORP (12/05/2017)

	_cNumPC    := Alltrim(DOC->C7_NUM)
    _cCompr    := UsrRetName(DOC->C7_USER)
	_nVlrPC    := TRANSFORM(DOC->C7_TOTPC, "@E 999,999,999.99")	
	_nFornec   := Alltrim(DOC->C7_FORNECE)        


	_lVlddRetItn := .F.	

	cCodProcesso := "WF_106"	
	//Solicitando Recebimento do Material no Almoxarifado
	cHtmlModelo := "\Workflow\WF_HTML\ADM\WF_PEDCOM_S_AUT.html"
	cAssunto := "LIBERAÇÃO - PEDIDO DE COMPRA (AUTORIZADO)"
	//cAssunto :=  DecodeUTF8(_cMsgAss, "cp1252")
	cUsuarioProtheus:= SubStr(cUsuario,7,15)
	oProcess:= TWFProcess():New(cCodProcesso, cAssunto)
	cTitProc :=  "WF_106"
	oProcess:NewTask(cTitProc, cHtmlModelo)
	oHtml	:= oProcess:oHTML



	oProcess:oHtml:ValByName( "cNumPc" 		,Alltrim(_cNumPC))
	oProcess:oHtml:ValByName( "VlrPc"  		,_nVlrPC)
	oProcess:oHtml:ValByName( "cFornc"	    ,Alltrim(_nFornec))				

	oProcess:oHtml:ValByName( "cUsrApr"	    ,Alltrim(_cNmApro))     //RAFAEL ALMEIDA SIGACORP - (12/05/2017)
	oProcess:oHtml:ValByName( "cCodPg"	    ,Alltrim(_cPagCod))	    //RAFAEL ALMEIDA SIGACORP - (12/05/2017)
	
	oProcess:oHtml:ValByName( "cObsApr"	,Alltrim(MsgObs))	
	

	While !DOC->(Eof())	.AND. DOC->C7_NUM = _cNumPC
			aAdd( (oProcess:oHtml:ValByName( "ti.cItem"     )), Alltrim(DOC->C7_ITEM))
			aAdd( (oProcess:oHtml:ValByName( "ti.cCodProd"  )), Alltrim(DOC->C7_PRODUTO))
			aAdd( (oProcess:oHtml:ValByName( "ti.cDescProd" )), Alltrim(DOC->C7_DESC))
			aAdd( (oProcess:oHtml:ValByName( "ti.nQtd"      )), TRANSFORM(DOC->C7_QUANT, "@E 999999999.9999"))			
			aAdd( (oProcess:oHtml:ValByName( "ti.nPrc"      )), TRANSFORM(DOC->C7_PRECO, "@E 9,999,999.99999"))
			aAdd( (oProcess:oHtml:ValByName( "ti.nTot"      )), TRANSFORM(DOC->C7_TOTAL, "@E 999,999,999.99"))
			aAdd( (oProcess:oHtml:ValByName( "ti.cObs"      )), Alltrim(DOC->C7_OBS)) 
			aAdd( (oProcess:oHtml:ValByName( "ti.cUm"       )), Alltrim(DOC->C7_UM))			
		   _lVlddRetItn := .T.
		DOC->(DbSkip())
	EndDo
	    If _lVlddRetItn
			oProcess:cSubject := DecodeUTF8(EncodeUTF8(cAssunto, "cp1252"), "cp1252")
//			oProcess:cTo :=  cMailTI +";" + cMailApro + ";" + cMailSOL +";" + cMailSC + ";"
			oProcess:cTo :=  cMailTI +";" + cMailSOL +";" + cMailSC +";"
			oProcess:Start()
			oProcess:Finish()
	    EndIf
EndDo
DOC->( DBCloseArea())
Return()
