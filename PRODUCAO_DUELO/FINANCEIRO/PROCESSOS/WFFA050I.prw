#Include "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#include "ap5mail.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥RAltDtCR ∫Autor  ≥Denis Tsuchiya      ∫ Data ≥  01/31/14   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥FunÁ„o para envio de e-mails aos monitore                   ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function WFFINLUG()
Local aArea := GetArea()

Conout("Empresa: 04 Filial: 01")
RPCSetType(3) //n„o consome licenÁa.
PREPARE ENVIRONMENT EMPRESA '05' FILIAL '01'

DbSelectArea("SX6") //Abre a tabela SX6
DbSetOrder(1) //Se posiciona no primeiro indice
If DbSeek(xFilial("SX6")+"MV_WFMLBOX") //Verifique se o parametro existe
	RecLock("SX6",.F.) //Abre o registro para ediÁ„o
	SX6->X6_CONTEUD := "WORKFLOW"  //atualiza apenas o campo desejado
	MsUnLock() //salva o registro
EndIf



Conout("EXECUTANDO WFCobLug - Iniciando   rotinas scheduladas em " + dtoc(date()) + " as " + time())
U_WFFA050I()
Conout("WFCobLug - Finalizando rotinas scheduladas em " + dtoc(date()) + " as " + time())

RESET ENVIRONMENT
RestArea(aArea)
Return()





/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥RAltDtCR ∫Autor  ≥Denis Tsuchiya      ∫ Data ≥  01/31/14   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥FunÁ„o para envio de e-mails aos monitore                   ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function WFFINDUE()
Local aArea := GetArea()

Conout("Empresa: 04 Filial: 01")
RPCSetType(3) //n„o consome licenÁa.
PREPARE ENVIRONMENT EMPRESA '04' FILIAL '01'

DbSelectArea("SX6") //Abre a tabela SX6
DbSetOrder(1) //Se posiciona no primeiro indice
If DbSeek(xFilial("SX6")+"MV_WFMLBOX") //Verifique se o parametro existe
	RecLock("SX6",.F.) //Abre o registro para ediÁ„o
	SX6->X6_CONTEUD := "WORKFLOW"  //atualiza apenas o campo desejado
	MsUnLock() //salva o registro
EndIf



Conout("EXECUTANDO WFCobLug - Iniciando   rotinas scheduladas em " + dtoc(date()) + " as " + time())
U_WFFA050I()
Conout("WFCobLug - Finalizando rotinas scheduladas em " + dtoc(date()) + " as " + time())

RESET ENVIRONMENT
RestArea(aArea)
Return()




/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥RAltDtCR ∫Autor  ≥Denis Tsuchiya      ∫ Data ≥  01/31/14   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥FunÁ„o para envio de e-mails aos monitore                   ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function WFFA050I()

//Variaveis do Processo oHTML
Local cCodProcesso, cCodStatus, cHtmlModelo, oHtml, oProcess
Local cUsuarioProtheus, cCodProduto, cTexto, cAssunto
Local cMailSOL   := ""
Local cMailApro  := ""
Local _Count     := 0
Local cQuery     := ""
Local cMailTI     := ""
Local cMailFIN    := ""
Local lServProd := ""
Local _lVlddRetItn := .F.
Local _aVetor  := {}
Local _cQryx := " "
Local nI   
Local _dDtInc := ""

cMailTI     := "ronaldo@lugpet.com.br"
//cMailFIN    := GetMv("US_MAILFIN")
lServProd := IIf(GetServerIP() == '192.168.1.4', .T.,.F.)        

_cQryx := " "
_cQryx += " SELECT 	"
_cQryx += " ZE2_HRINCL
_cQryx += " ,SUBSTRING(ZE2_DTINCL,7,2)+'/'+SUBSTRING(ZE2_DTINCL,5,2)+'/'+SUBSTRING(ZE2_DTINCL,1,4) AS ZE2_DTINCL	"
_cQryx += " ,ZE2_CODUSR	"
_cQryx += " ,ZE2_NAMUSR,ZE2_FORNEC,ZE2_LOJA	"
_cQryx += " ,ZE2_NOMFOR,ZE2_VALOR, ZE2_PREFIX	"
_cQryx += " ,ZE2_NUM,   ZE2_TIPO,  ZE2_NATURE		"
_cQryx += " ,SUBSTRING(ZE2_EMISSA,7,2)+'/'+SUBSTRING(ZE2_EMISSA,5,2)+'/'+SUBSTRING(ZE2_EMISSA,1,4) AS ZE2_EMISSA	"
_cQryx += " ,SUBSTRING(ZE2_VENCTO,7,2)+'/'+SUBSTRING(ZE2_VENCTO,5,2)+'/'+SUBSTRING(ZE2_VENCTO,1,4) AS ZE2_VENCTO	"
_cQryx += " ,ZE2_HIST,ZE2_PARCEL	"
_cQryx += " FROM " + RetSqlName("ZE2") +"  "
_cQryx += " WHERE D_E_L_E_T_ = '' "
_cQryx += " AND ZE2_DTINCL = CONVERT(VARCHAR(10),DATEADD(DAY, -1, GETDATE()),112)	"
_cQryx := ChangeQuery(_cQryx )
dbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQryx), "ZE2WF", .F., .T.)

DbSelectArea("ZE2WF")
ZE2WF->(DbGoTop())

Do While !ZE2WF->(Eof())
	_dDtInc := ZE2WF->ZE2_DTINCL
	aAdd(_aVetor, {ZE2WF->ZE2_HRINCL,ZE2WF->ZE2_DTINCL,ZE2WF->ZE2_CODUSR,ZE2WF->ZE2_NAMUSR,ZE2WF->ZE2_FORNEC,ZE2WF->ZE2_LOJA,ZE2WF->ZE2_NOMFOR,ZE2WF->ZE2_VALOR,ZE2WF->ZE2_PREFIX,ZE2WF->ZE2_NUM,ZE2WF->ZE2_TIPO,ZE2WF->ZE2_NATURE,	ZE2WF->ZE2_EMISSA,ZE2WF->ZE2_VENCTO,ZE2WF->ZE2_HIST,ZE2WF->ZE2_PARCEL})
	ZE2WF->(DbSkip())
EndDo
ZE2WF->( DBCloseArea())

cCodProcesso := "WF_106"
//Solicitando Recebimento do Material no Almoxarifado
cHtmlModelo := "\Workflow\WF_HTML\ADM\WFFA050I_Note.html"
cAssunto := "INFORMATIVO - INCLUS√O DE TITULO MANUAL"
cUsuarioProtheus:= SubStr(cUsuario,7,15)
oProcess:= TWFProcess():New(cCodProcesso, cAssunto)
cTitProc :=  "WF_106"
oProcess:NewTask(cTitProc, cHtmlModelo)
oHtml	:= oProcess:oHTML

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫  [01]-SubStr(Time(),1,5))		->		Hora de Inclus„o do Titulo    ∫±±
±±∫  [02]-DtoC(Date())				->		Data de Inclus„o do Titulo    ∫±±
±±∫  [03]-RetCodUsr()				->		CÛd. Usuario que Inc. Titulo  ∫±±
±±∫  [04]-UsrFullName(RetCodUsr())	->		Nome usuario que Inc. Titulo  ∫±±
±±∫  [05]-M->E1_CLIENTE				->		CÛd. do Cliente				  ∫±±
±±∫  [06]-M->E1_LOJA				->		Loja do Cliente				  ∫±±
±±∫  [07]-M->E1_NOMCLI				->		Nome do Cliente				  ∫±±
±±∫  [08]-M->E1_VALOR				->		Valor do Titulo				  ∫±±
±±∫  [09]-M->E1_PREFIXO				->		Prexifo do Titulo			  ∫±±
±±∫  [10]-M->E1_NUM					->		Numero do Titulo			  ∫±±
±±∫  [11]-M->E1_TIPO				->		Tipo do Titulo				  ∫±±
±±∫  [12]-M->E1_NATUREZ				->		Natureza do Titulo			  ∫±±
±±∫  [13]-M->E1_EMISSAO				->		Emiss„o do Titulo			  ∫±±
±±∫  [14]-M->E1_VENCTO				->		Vencimento do Titulo		  ∫±±
±±∫  [15]-M->E1_HIST				->		Historico do Titulo			  ∫±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/

oProcess:oHtml:ValByName( "cData"  		, _dDtInc)

For nI := 1 to Len(_aVetor)
	aAdd( (oProcess:oHtml:ValByName( "ti.cCodUsr"))		,Alltrim(_aVetor[nI][3]))
	aAdd( (oProcess:oHtml:ValByName( "ti.cNomUsr"))		,Alltrim(_aVetor[nI][4]))
	aAdd( (oProcess:oHtml:ValByName( "ti.cCodCli"))	    ,Alltrim(_aVetor[nI][5]))
	aAdd( (oProcess:oHtml:ValByName( "ti.cLojCli"))	    ,Alltrim(_aVetor[nI][6]))
	aAdd( (oProcess:oHtml:ValByName( "ti.cNomCli"))	    ,Alltrim(_aVetor[nI][7]))
	aAdd( (oProcess:oHtml:ValByName( "ti.cValor"))	    ,TRANSFORM(_aVetor[nI][8], "@E 999,999,999.99"))
	aAdd( (oProcess:oHtml:ValByName( "ti.cPrefix"))	    ,Alltrim(_aVetor[nI][9]))
	aAdd( (oProcess:oHtml:ValByName( "ti.cNumTit"))     ,Alltrim(_aVetor[nI][10]))
	aAdd( (oProcess:oHtml:ValByName( "ti.cTipoTit"))    ,Alltrim(_aVetor[nI][11]))
	aAdd( (oProcess:oHtml:ValByName( "ti.cNatur"))	    ,Alltrim(_aVetor[nI][12]))
	aAdd( (oProcess:oHtml:ValByName( "ti.cEmissao"))    ,Alltrim(_aVetor[nI][13]))
	aAdd( (oProcess:oHtml:ValByName( "ti.cVencto"))	    ,Alltrim(_aVetor[nI][14]))
	aAdd( (oProcess:oHtml:ValByName( "ti.cHist"))	    ,Alltrim(_aVetor[nI][15]))
Next nI

oProcess:cSubject := cAssunto
oProcess:cTo :=  "ronaldomjr@gmail.com;" +"ti@bebidasduelo.com.br" //+ cMailFIN +";"
oProcess:Start()
oProcess:Finish()

Return()
