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
User Function  WfNFDev(_cDoc,_cSerie,_dEmiss,_nValBrut,_cNFeOrig,_cSerOrig,_dEmiSF2,_nValSF2,_cPagSF2,_cCodUsr,_cFornece, _cLoja,_cMotDev)

//Variaveis do Processo oHTML
Local cCodProcesso, cCodStatus, cHtmlModelo, oHtml, oProcess
Local cUsuarioProtheus, cCodProduto, cTexto, cAssunto
Local cMailSOL   := ""
Local cMailApro  := ""
Local _Count     := 0
Local cMailTI     := GetMv("US_MAILTI")
Local cMailFIN    := GetMv("US_MAILFIN")

Local _cCdCli    := _cFornece
Local _cLjCli    := _cLoja
Local _cNmCli    := ""
Local _cClient   := ""
Local cUserApro  := _cCodUsr
Local _cNFEnt  	 := _cDoc
Local _cSRDev	 := _cSerie
Local _nVlrF1    := _nValBrut
Local _dEmssF1   := _dEmiss  

local _cMDev	 := _cMotDev
local _cMoDev	 := "" 
local _cDescMD	 := "" 


Local _cNFFat    :=	""
Local _cNFDev    :=	""
Local _cNFOrg  	 := _cNFeOrig
Local _cSROrg	 := _cSerOrig
Local _nVlrF2    := _nValSF2
Local _dEmssF2   := _dEmiSF2
Local _cCodPag   := _cPagSF2     //RAFAEL ALMEIDA SIGACORP - (12/05/2017)
Local _cDesPag   := ""           //RAFAEL ALMEIDA SIGACORP - (12/05/2017)
Local _cPagCod   := ""           //RAFAEL ALMEIDA SIGACORP - (12/05/2017)
Local _cNmApro   := ""	     	 //RAFAEL ALMEIDA SIGACORP - (12/05/2017)
Local _WfMail	 := GetMv("MV_WFMLBOX")


Local lServProd := IIf(GetServerIP() == '192.168.1.4', .T.,.F.)
Local _lVlddRetItn := .F.

_cDesPag := GetAdvFVal("SE4", "E4_DESCRI",xFilial("SE4")+_cCodPag,1)
_cPagCod := _cCodPag +" - "+ _cDesPag

_cMoDev := GetAdvFVal("ZTM", "ZTM_DESCRI",xFilial("ZTM")+_cMDev,1)
_cDescMD:= _cMdev +" - "+ _cMoDev


_cNmCli  := GetAdvFVal("SA1", "A1_NOME",xFilial("SA1")+ _cCdCli + _cLjCli ,1)
_cClient :=  Alltrim(_cCdCli)+"/"+Alltrim(_cLjCli)+ " - " + Alltrim(_cNmCli)

_cNFFat :=  Alltrim(_cNFOrg)+"/"+Alltrim(_cSROrg)
_cNFDev :=  Alltrim(_cNFEnt)+"/"+Alltrim(_cSRDev)


If !(_WfMail == "WORKFLOW")
	DbSelectArea("SX6") //Abre a tabela SX6
	DbSetOrder(1) //Se posiciona no primeiro indice
	If DbSeek(xFilial("SX6")+"MV_WFMLBOX") //Verifique se o parametro existe
		RecLock("SX6",.F.) //Abre o registro para edição
		SX6->X6_CONTEUD := "WORKFLOW"  //atualiza apenas o campo desejado
		MsUnLock() //salva o registro
	EndIf
EndIf



cMailApro  :=  UsrRetMail(cUserApro)

cCodProcesso := "WF_106"
//Solicitando Recebimento do Material no Almoxarifado
cHtmlModelo := "\Workflow\WF_HTML\ADM\WFNFDEV_Note.html"
cAssunto := "NOTIFICAÇÃO - NOTA FISCAL DE DEVOLUÇÃO"
cUsuarioProtheus:= SubStr(cUsuario,7,15)
oProcess:= TWFProcess():New(cCodProcesso, cAssunto)
cTitProc :=  "WF_106"
oProcess:NewTask(cTitProc, cHtmlModelo)
oHtml	:= oProcess:oHTML

oProcess:oHtml:ValByName( "NfDev"  	    	,Alltrim(_cNFDev))
oProcess:oHtml:ValByName( "DtDev"   		,Alltrim(_dEmssF1))
oProcess:oHtml:ValByName( "VlDev"           ,TRANSFORM(_nVlrF1, "@E 999,999,999.99"))

oProcess:oHtml:ValByName( "NfOrg"  	    	,Alltrim(_cNFFat))
oProcess:oHtml:ValByName( "DtOrg"   		,Alltrim(_dEmssF2))
oProcess:oHtml:ValByName( "VlOrg"           ,TRANSFORM(_nVlrF2, "@E 999,999,999.99"))

oProcess:oHtml:ValByName( "Client"	       	,Alltrim(_cClient))
oProcess:oHtml:ValByName( "CdPgt"	        ,Alltrim(_cPagCod))
oProcess:oHtml:ValByName( "Motdev"	        ,Alltrim(_cDescMD))

oProcess:cSubject := cAssunto
oProcess:cTo :=  cMailTI +";" + cMailFIN +";"
oProcess:Start()
oProcess:Finish()

Return()
