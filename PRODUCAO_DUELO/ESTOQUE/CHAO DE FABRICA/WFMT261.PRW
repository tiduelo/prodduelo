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
User Function  WFMT261(_cDocN,_cCdUser,_cTpTransf) 

//Variaveis do Processo oHTML
Local cCodProcesso, cCodStatus, cHtmlModelo, oHtml, oProcess
Local cUsuarioProtheus, cCodProduto, cTexto, cAssunto 
Local cMailSOL   := ""
Local cMailApro  := "" 
Local cMailSC    := ""
Local cUserApro  := _cCdUser
Local cNameApro  := "" 
Local _Count     := 0 
Local cQuery     := ""
Local cMailTI     := GetMv("US_MAILTI")
Local cMailCTR    := GetMv("US_MAILCTR")
Local _cNumPC    := ""
Local _cCompr    := ""
Local _nVlrPC    := ""
Local _nFornec   := ""
Local _cPrfx	 := ""
Local _cNumPA    := ""
Local _nVlrPA    := ""
Local _cNumMov   := _cDocN 
Local _cDesPag   := ""           //RAFAEL ALMEIDA SIGACORP - (12/05/2017)
Local _cPagCod   := ""           //RAFAEL ALMEIDA SIGACORP - (12/05/2017)
Local _cNmApro   := ""			//RAFAEL ALMEIDA SIGACORP - (12/05/2017)
Local _cEmiss    := ""
Local _cDestMail := _cTpTransf 
Local cMailProd  := GetNewPar("US_MAILPRO","julianny@bebidasduelo.com.br")
Local cMailAlmx  := GetNewPar("US_MAILALM","almoxarifado@bebidasduelo.com.br")


Local lServProd := IIf(GetServerIP() == '192.168.1.4', .T.,.F.)  
Local _lVlddRetItn := .F.

DbSelectArea("SX6") //Abre a tabela SX6
DbSetOrder(1) //Se posiciona no primeiro indice
If DbSeek(xFilial("SX6")+"MV_WFMLBOX") //Verifique se o parametro existe
      RecLock("SX6",.F.) //Abre o registro para edição
      SX6->X6_CONTEUD := "WORKFLOW"  //atualiza apenas o campo desejado
      MsUnLock() //salva o registro
EndIf

				conout("DOC INICIO SQL:"+_cNumMov+"/"+_cDocN)

cQuery := " "
cQuery += " 	SELECT 	"
cQuery += " 	 D3_FILIAL	"
cQuery += " 	,D3_DOC		"
cQuery += " 	,SUBSTRING(D3_EMISSAO,7,2)+'/'+SUBSTRING(D3_EMISSAO,5,2)+'/'+SUBSTRING(D3_EMISSAO,1,4) AS D3_EMISSAO	"
cQuery += " 	,D3_COD		"
cQuery += " 	,B1_DESC	"
cQuery += " 	,B1_UM		"
cQuery += " 	,D3_QUANT	"
cQuery += " 	,D3_LOCAL AS D3_LOCORIG	"
cQuery += " 	,(SELECT D3_LOCAL FROM SD3040 WHERE D_E_L_E_T_ =   '' 	"
cQuery += " 								    AND D3_FILIAL = '"+xFilial("SD3")+"' "
cQuery += " 									AND D3_ESTORNO <> 'S' 	"
cQuery += " 									AND D3_CF =     'DE4' 	"
cQuery += " 									AND D3_DOC = D3.D3_DOC	"
cQuery += " 									AND D3_COD = D3.D3_COD)  AS D3_LOCDEST	"
cQuery += " 	FROM "+ RETSQLNAME("SD3")+" D3 "
cQuery += " 	INNER JOIN "+ RETSQLNAME("SB1")+" B1 "
cQuery += " 	ON B1_COD = D3_COD AND B1.D_E_L_E_T_ = ''	"
cQuery += " 	WHERE D3.D_E_L_E_T_ = ''	"
cQuery += " 	AND D3_ESTORNO <> 'S'		"
cQuery += " 	AND D3_CF = 'RE4'			"
cQuery += " 	AND D3_DOC = '"+ Alltrim(_cNumMov) +"'	"
cQuery += " 	AND D3_FILIAL = '"+xFilial("SD3")+"' "
cQuery:= ChangeQuery(cQuery)
dbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , "DOC" , .T. , .F.)

DBSelectArea("DOC")
DOC->(DbGoTop())

				conout("DOC DEPOIS SQL:"+_cNumMov+"/"+_cDocN+"/"+DOC->D3_DOC)

While !DOC->(Eof())


	cMailApro  :=  UsrRetMail(cUserApro)
	_cNmApro   :=  UsrFullName(cUserApro)
	_cNumPC    := Alltrim(DOC->D3_DOC)
    _cEmiss    := Alltrim(DOC->D3_EMISSAO)

	_lVlddRetItn := .F.	

	cCodProcesso := "WF_106"	
	//Solicitando Recebimento do Material no Almoxarifado
	cHtmlModelo := "\Workflow\WF_HTML\ADM\WF_MT261_TRANS.html"
	cAssunto := "NOTIFICAÇÃO - Transferência entre armazéns (CHÃO DE FÁBRICA)"
	cUsuarioProtheus:= SubStr(cUsuario,7,15)
	oProcess:= TWFProcess():New(cCodProcesso, cAssunto)
	cTitProc :=  "WF_106"
	oProcess:NewTask(cTitProc, cHtmlModelo)
	oHtml	:= oProcess:oHTML

				conout("DOC ANTES HTML:"+_cNumMov+"/"+_cDocN+"/"+DOC->D3_DOC+"/"+_cNumPC)


	oProcess:oHtml:ValByName( "cNDoc" 		,Alltrim(_cNumPC))
	oProcess:oHtml:ValByName( "DtEmis"  	,Alltrim(_cEmiss))
	oProcess:oHtml:ValByName( "cUsrOpr"	    ,Alltrim(_cNmApro))				

	While !DOC->(Eof())	.AND. DOC->D3_DOC = _cNumMov
			aAdd( (oProcess:oHtml:ValByName( "ti.cCodProd"  )), Alltrim(DOC->D3_COD))
			aAdd( (oProcess:oHtml:ValByName( "ti.cDescProd" )), Alltrim(DOC->B1_DESC))
			aAdd( (oProcess:oHtml:ValByName( "ti.nQtd"      )), TRANSFORM(DOC->D3_QUANT, "@E 999999999.9999"))			
			aAdd( (oProcess:oHtml:ValByName( "ti.cUm"     )), Alltrim(DOC->B1_UM))			
			aAdd( (oProcess:oHtml:ValByName( "ti.LocOrig"      )), Alltrim(DOC->D3_LOCORIG)) 
			aAdd( (oProcess:oHtml:ValByName( "ti.LocDest"       )), Alltrim(DOC->D3_LOCDEST))			
		   _lVlddRetItn := .T.
		DOC->(DbSkip())
	EndDo
	    If _lVlddRetItn
			oProcess:cSubject := cAssunto 
			If	_cDestMail  == "PROD" 
				conout("PROD"+cMailProd)
				oProcess:cTo :=  cMailProd +";" + cMailApro +";" + cMailTI +";" + cMailCTR +";"
			ElseIf _cDestMail == "ALMX" 
				conout("ALMX"+cMailProd)
				oProcess:cTo :=  cMailAlmx +";" + cMailApro +";" + cMailTI +";" + cMailCTR +";"
			EndIf
			oProcess:Start()
			oProcess:Finish()
	    EndIf
EndDo
DOC->( DBCloseArea())
Return()
