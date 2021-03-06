#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa �FA080PE �Autor � Rafael Almeida - SIGACORP  �Data � 31/08/15 ���
�������������������������������������������������������������������������͹��
���Descricao � Esse ponto de entrada ser� utilizado para grava informa��es���
���  �do SE2 para o SE5 o exemplo � CENTRO DE CUSTO E2_CC -> E5_CC        ���
�������������������������������������������������������������������������͹��
���Uso       � FINA080 - BAIXA DE TITULOS APAGAR MANUAL                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FA080PE()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local aArea     := GetArea()
Local _cCCE2    := SE2->E2_CCUSTO
Local _cContaD  := SE2->E2_CONTAD
Local _cRecPag  := SE5->E5_RECPAG
Local _cNum  	:= SE5->E5_NUMERO
Local _cPrfx 	:= SE2->E2_PREFIXO
Local _cParc	:= SE2->E2_PARCELA
Local _cForn 	:= SE2->E2_FORNECE
Local _cLjFn 	:= SE5->E5_LOJA
Local _cTipo 	:= SE2->E2_TIPO
Local _cOrig	:= SE2->E2_ORIGEM
Local _cRat		:= SE2->E2_RATEIO
Local _nTamCC   := TamSX3("E2_CC")
Local oFont1    := TFont():New("Cambria",,018,,.T.,,,,,.F.,.F.)
Local oFont2    := TFont():New("Arial Narrow",,018,,.T.,,,,,.F.,.F.)
Local cCodCC    := Space(10)
Local cCodCT    := Space(20)
Local cGet2     := Space(50)
Local _cEmpFil	:= cNumEmp
Local _cEmpPar	:= ""
Local _cFilPar	:= ""
Local _cEmp	    := FWCodEmp()
Local _cFil 	:= FWCodFil()
Local _lExec	:= .F.
Local oCodCC
Local oCodCT
Local oGp1
Local oGp2
Local oSay1
Local oDescCC
Local oDescCT
Local oSButCAN
Local oSButOK
Local Desc01    := ""
Local bContinua := .F.
Local _lAtvFA080PE := SUPERGETMV("US_FA080PE", .T., .T.)
Static oDlg



If _lAtvFA080PE
	
	
	
	
	Desc01 := "       N�o foi identificado o CENTRO DE CUSTO "
	Desc01 += "no titulo em quest�o, para realizar a BAIXA DO TITULO A PAGAR "
	Desc01 += "� necess�rio informar o centro de custo abaixo."
	
	If Alltrim(_cRecPag) == "P" .and. !Empty(_cContaD) .and. Alltrim(_cOrig) == "FINA050"
		Begin Transaction
		DbSelectArea("SE5")
		DbSetOrder(7)
		//E5_FILIAL, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_CLIFOR, E5_LOJA, E5_SEQ
		DbSeek(xFilial("SE5") + _cPrfx + _cNum + _cParc + _cTipo + _cForn + _cLjFn)
		RecLock("SE5",.F.)
		SE5->E5_CCD    := 	_cCCE2
		SE5->E5_DEBITO := 	_cContaD
		MSUnlock()
		End Transaction
	ElseIf  Alltrim(_cRecPag) == "P" .and. Empty(_cCCE2) .and. Alltrim(_cOrig) == "FINA050" .And. _cRat == "N"
		
		DEFINE MSDIALOG oDlg TITLE "Centro de Custo - BAIXA DE TITULOS" FROM 000, 000  TO 225, 540 COLORS 0, 10485760 PIXEL
		
		@ 006, 007 GROUP oGp1 TO 109, 248 PROMPT "   AVISO   " OF oDlg COLOR 255, 16777215 PIXEL
		@ 052, 012 GROUP oGp2 TO 088, 239 PROMPT "   CENTRO DE CUSTO & CONTA CONTABIL " OF oDlg COLOR 255, 16777215 PIXEL
		@ 021, 012 SAY oSay1 PROMPT Desc01 SIZE 225, 020 OF oDlg FONT oFont2 COLORS 16711680, 16777215 PIXEL
		
		@ 062, 019 SAY oCodCC  PROMPT "C�digo C. Custo" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
		@ 062, 076 SAY oDescCC PROMPT "Descri��o do C. Custo" SIZE 058, 007 OF oDlg COLORS 0, 16777215 PIXEL
		@ 071, 019 MSGET cCodCC SIZE 038, 010 OF oDlg F3 "CTT" VALID EXISTCPO("CTT",cCodCC) .OR. NAOVAZIO(cCodCC) COLORS 0, 16777215 PIXEL
		@ 071, 075 MSGET POSICIONE("CTT",1,xFILIAL("CTT")+cCodCC,"CTT_DESC01") SIZE 157, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
		
		@ 082, 019 SAY oCodCC  PROMPT "Conta Contabil" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
		@ 082, 076 SAY oDescCC PROMPT "Descri��o da Conta" SIZE 058, 007 OF oDlg COLORS 0, 16777215 PIXEL
		@ 091, 019 MSGET cCodCT SIZE 038, 010 OF oDlg F3 "CT1" VALID EXISTCPO("CT1",cCodCT) .OR. NAOVAZIO(cCodCT) COLORS 0, 16777215 PIXEL
		@ 091, 075 MSGET POSICIONE("CT1",1,xFILIAL("CT1")+cCodCT,"CT1_DESC01") SIZE 157, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
		
		DEFINE SBUTTON oSButOK  FROM 092, 211 TYPE 01 ACTION (bContinua := .T.,oDlg:End()) OF oDlg ENABLE
		
		
		ACTIVATE MSDIALOG oDlg CENTERED  VALID(Iif(bContinua == .F., U_AlerSE2(),.T.))
	EndIf
	
	If bContinua
		Begin Transaction
		
		DbSelectArea("SE5")
		DbSetOrder(7)
		//E5_FILIAL, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_CLIFOR, E5_LOJA, E5_SEQ
		DbSeek(xFilial("SE5") + _cPrfx + _cNum + _cParc + _cTipo + _cForn + _cLjFn)
		RecLock("SE5",.F.)
		SE5->E5_CCD    := 	cCodCC
		SE5->E5_DEBITO := 	cCodCT
		MSUnlock()
		
		DbSelectArea("SE2")
		DbSetOrder(1)
		//E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA
		DbSeek(xFilial("SE2") + _cPrfx + _cNum + _cParc + _cTipo + _cForn + _cLjFn)
		RecLock("SE2",.F.)
		SE2->E2_CCUSTO := 	cCodCC
		SE2->E2_CONTAD := 	cCodCT
		MSUnlock()
		
		End Transaction
	EndIf
EndIf
Return()


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa �AlerSE2 �Autor � Rafael Almeida - SIGACORP  �Data � 31/08/15 ���
�������������������������������������������������������������������������͹��
���Descricao � Esse programa exibe o alerta caso usuario tente fecha a    ���
���  �janela sem informar o centro de custo o sistema n�o ira deixar.     ���
�������������������������������������������������������������������������͹��
���Uso       � FINA080 - BAIXA DE TITULOS APAGAR MANUAL                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function AlerSE2()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local _lRet      := .F.
Local _cMenAlert := ""

_cMenAlert:="� necess�rio informar o CENTRO DE CUSTO"+CHR(13)+CHR(10)
_cMenAlert+="e confirmar o processo para encerrar a rotina. "+CHR(13)+CHR(10)
_cMenAlert+="  "+CHR(13)+CHR(10)
_cMenAlert+="Maiores informa��es contatar o departamento. T.I"+CHR(13)+CHR(10)
//_cMenAlert+="ti.alubar@alubar.net"+CHR(13)+CHR(10)
Aviso("Aviso",_cMenAlert,{"Ok"},1)

Return(_lRet)


