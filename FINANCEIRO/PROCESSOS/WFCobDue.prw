#include "rwmake.ch"
#include "ap5mail.ch"
#Include "PROTHEUS.CH"  
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ WFCobLug ³ Autor³ Rafael Almeida SIGACORP ³Data ³ 14/03/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ WORKFLOW DE COBRANÇA TIT. VENCTO. - AGENDADO PELO WINDOWS  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

*/

//************************
User Function WFCobDue()
//************************
Local nRadMenu1 := 1
Local aArea := GetArea()
Local _cQry  := ""  

Conout("Empresa: 04 Filial: 01")
RPCSetType(3) //não consome licença.
PREPARE ENVIRONMENT EMPRESA '04' FILIAL '01'

//WORKFLOW DEVERÁ SER ENVIADO PELO E-MAIL COBRANÇA P/ ISSO FAZ NECESSARIO ALTERAR O PARAMETRO 
//QUE DEFINE QUAL E-MAIL É RESPONSAVEL POR ENVIAR RELATORIO NO SISTEMA PROTHEUS.
DbSelectArea("SX6") //Abre a tabela SX6
DbSetOrder(1) //Se posiciona no primeiro indice
If DbSeek(xFilial("SX6")+"MV_WFMLBOX") //Verifique se o parametro existe
      RecLock("SX6",.F.) //Abre o registro para edição
      SX6->X6_CONTEUD := "COBRANCA"  //atualiza apenas o campo desejado
      MsUnLock() //salva o registro
EndIf


Conout("EXECUTANDO WFCobLug - Iniciando   rotinas scheduladas em " + dtoc(date()) + " as " + time())

U_QryDueCob()
                                 
Conout("WFCobLug - Finalizando rotinas scheduladas em " + dtoc(date()) + " as " + time())


//RETORNANDO O WORKFLOW PADRÃO POR ENVIAR E-MAIL RELATORIO NO SISTEMA PROTHEUS.
DbSelectArea("SX6") //Abre a tabela SX6
DbSetOrder(1) //Se posiciona no primeiro indice
If DbSeek(xFilial("SX6")+"MV_WFMLBOX") //Verifique se o parametro existe
      RecLock("SX6",.F.) //Abre o registro para edição
      SX6->X6_CONTEUD := "WORKFLOW"  //atualiza apenas o campo desejado
      MsUnLock() //salva o registro
EndIf


RESET ENVIRONMENT


RestArea(aArea)

Return()  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ QryLugCob³ Autor³ Rafael Almeida SIGACORP ³Data ³ 14/03/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ VERIFICA CLEINTE COM FATURAS VENCIDAS                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

*/

//************************
User Function QryDueCob()
//************************
Local _cQry  := ""

_cQry := " "
_cQry += " SELECT 	"
_cQry += "  E1_CLIENTE  AS CLIENTE  " 
_cQry += " ,E1_LOJA  AS LOJA  "
_cQry += " ,COUNT(*)  AS TOT_FAT  "
_cQry += " FROM " + RetSqlName("SE1") +"  "
_cQry += " WHERE D_E_L_E_T_ = '' "
_cQry += " AND E1_SALDO > 0      " 
_cQry += " AND E1_CLIENTE NOT IN ('010359')      " 
_cQry += " AND E1_TIPO IN ('NF')      "
//_cQry += " AND E1_CLIENTE IN ('002206')      " 
_cQry += " AND E1_FILIAL  = '"+xFilial("SE1")+"' "
_cQry += " AND ( E1_VENCTO = CONVERT(VARCHAR(10),GETDATE(),112) OR   "   

// _cQry += " E1_VENCTO = CONVERT(VARCHAR(10),DATEADD(DAY,-7,GETDATE()),112) OR "
// _cQry += " E1_VENCTO = CONVERT(VARCHAR(10),DATEADD(DAY,-7,GETDATE()),112) OR "

_cQry += " E1_VENCTO = CONVERT(VARCHAR(10),DATEADD(DAY,-7,GETDATE()),112) )     " 
_cQry += " GROUP BY E1_CLIENTE, E1_LOJA "
_cQry += " ORDER BY 3 DESC  "
_cQry := ChangeQuery(_cQry )
dbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQry), "TMPSE1", .F., .T.)

DbSelectArea("TMPSE1")
TMPSE1->(DbGoTop())

Do While !TMPSE1->(Eof())

	Conout("WFCobDue - Envio de e-mail " + TMPSE1->CLIENTE)
	U_ECobDue(TMPSE1->CLIENTE, TMPSE1->LOJA)   // chamada da funcao - INCLUIDO -Claudio Oliveira - 29042014.	
	Conout("WFCobDue - E-mail enviado: " + TMPSE1->CLIENTE)

	TMPSE1->(dbSkip())
Enddo
TMPSE1->(DBCLOSEAREA())

Return()  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ ECobLug ³ Autor³ Rafael Almeida SIGACORP ³ Data ³ 14/03/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ MONTANDO O WORKFLOW E ENVIANDO PARA O CLIENTE              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

*/

//************************
User Function ECobDue(_cSE1Cli, _cSE1Loj)
//************************               

//Variaveis do Processo oHTML
Local cCodProcesso, cCodStatus, cHtmlModelo, oHtml, oProcess
Local cUsuarioProtheus, cCodProduto, cTexto, cAssunto 
Local cMailSOL   := ""
Local cMailApro  := "" 
Local cNameApro  := "" 
Local _Count     := 0 
Local cMailCOB   := GetMv("US_MAILTI")
Local _cCliWf    := _cSE1Cli
Local _cLojWf    := _cSE1Loj
Local _cQryx     := "" 
Local _cRazao    := "" 
Local _lVlddRetItn := .f.
Local _cEmailCli := ""

Local lServProd := IIf(GetServerIP() == '192.168.1.4', .T.,.F.)  
Local _lVlddRetItn := .F.

_cQryx := " "
_cQryx += " SELECT 	"
_cQryx += " (SELECT RTRIM(LTRIM(A1_NOME)) FROM SA1040 WHERE D_E_L_E_T_ = '' AND A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA AND A1_FILIAL = E1_FILIAL) AS RAZAO  "
_cQryx += " ,E1_NUM AS FATURA  "
_cQryx += " ,SUBSTRING(E1_VENCTO,7,2)+'/'+SUBSTRING(E1_VENCTO,5,2)+'/'+SUBSTRING(E1_VENCTO,1,4) AS VENCTO  "
_cQryx += " ,E1_SALDO  AS SALDO  " 
_cQryx += " ,E1_CLIENTE  AS CLIENTE  " 
_cQryx += " ,E1_LOJA  AS LOJA  "  
_cQryx += " ,CASE                               "
_cQryx += "  WHEN RTRIM(LTRIM(E1_PARCELA)) =''	"
_cQryx += "  	THEN 'UNICA'                     "
_cQryx += "  	ELSE E1_PARCELA                 "
_cQryx += "  	END AS PARCELA				    "
_cQryx += " FROM " + RetSqlName("SE1") +"  "
_cQryx += " WHERE D_E_L_E_T_ = '' "
_cQryx += " AND E1_SALDO > 0      "               
_cQryx += " AND E1_CLIENTE NOT IN ('010359')      "   
_cQryx += " AND E1_TIPO IN ('NF')      " 
//_cQryx += " AND E1_CLIENTE IN ('002206')      "
_cQryx += " AND ( E1_VENCTO = CONVERT(VARCHAR(10),GETDATE(),112) OR   "   

// _cQryx += " E1_VENCTO = CONVERT(VARCHAR(10),DATEADD(DAY,-7,GETDATE()),112) OR "
// _cQryx += " E1_VENCTO = CONVERT(VARCHAR(10),DATEADD(DAY,-7,GETDATE()),112) OR "

_cQryx += " E1_VENCTO = CONVERT(VARCHAR(10),DATEADD(DAY,-7,GETDATE()),112) )     " 
_cQryx += " AND E1_CLIENTE =  '"+ Alltrim(_cCliWf) +"'	"
_cQryx += " AND E1_LOJA    = '"+ Alltrim(_cLojWf) +"'	"
_cQryx += " AND E1_FILIAL  = '"+xFilial("SE1")+"' "
_cQryx += " ORDER BY SUBSTRING(E1_VENCTO,7,2)+'/'+SUBSTRING(E1_VENCTO,5,2)+'/'+SUBSTRING(E1_VENCTO,1,4) " 
_cQryx := ChangeQuery(_cQryx )
dbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQryx), "TMPWF", .F., .T.)

DbSelectArea("TMPWF")
TMPWF->(DbGoTop())

Do While !TMPWF->(Eof())


	_cRazao    := Alltrim(TMPWF->RAZAO)
    _cEmailCli := GetAdvFVal("SA1", "A1_EMAIL2",xFilial("SA1")+_cCliWf+_cLojWf,1)

	_lVlddRetItn := .F.	

	cCodProcesso := "WF_106"	
	//Solicitando Recebimento do Material no Almoxarifado
	cHtmlModelo := "\Workflow\WF_HTML\ADM\WfCobDuelo.html"
	cAssunto := "INFORMATIVO - VENCIMENTO DE SUA(S) FATURA(S)"
	cUsuarioProtheus:= SubStr(cUsuario,7,15)
	oProcess:= TWFProcess():New(cCodProcesso, cAssunto)
	cTitProc :=  "WF_106"
	oProcess:NewTask(cTitProc, cHtmlModelo)
	oHtml	:= oProcess:oHTML



	oProcess:oHtml:ValByName( "cFornc"		,_cRazao)
	

	While !TMPWF->(Eof()) .AND. TMPWF->CLIENTE = _cCliWf  .AND.  TMPWF->LOJA = _cLojWf
			aAdd( (oProcess:oHtml:ValByName( "ti.cItem"     )), Alltrim(TMPWF->FATURA))
			aAdd( (oProcess:oHtml:ValByName( "ti.cPac"      )), Alltrim(TMPWF->PARCELA))			
			aAdd( (oProcess:oHtml:ValByName( "ti.nPrc"      )), Alltrim(TMPWF->VENCTO))
			aAdd( (oProcess:oHtml:ValByName( "ti.nTot"      )), TRANSFORM(TMPWF->SALDO, "@E 999,999,999.99"))			
		   _lVlddRetItn := .T.
		TMPWF->(DbSkip())
	EndDo
	    If _lVlddRetItn
			oProcess:cSubject := cAssunto
			//oProcess:cTo :=  cMailCOB+";"+_cEmailCli  //cMailTI +";" + cMailApro + ";" + cMailSOL +";"
			oProcess:cTo  := _cEmailCli  //cMailTI +";" + cMailApro + ";" + cMailSOL +";"
			oProcess:cBCC :=  cMailCOB
			oProcess:Start()
			oProcess:Finish()
	    EndIf
EndDo
TMPWF->( DBCloseArea())

StartJob( "WFLauncher", GetEnvServer(), .f., { "WFSndMsg", { cEmpAnt, cFilAnt, "COBRANCA", .t. } } )//ENVIA E-MAIL PELO CORREIO DE COBRANÇA

Return()  