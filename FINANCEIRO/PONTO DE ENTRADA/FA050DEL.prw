#Include "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#include "ap5mail.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RAltDtCR �Autor  �Denis Tsuchiya      � Data �  01/31/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o para envio de e-mails aos monitore                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FA050DEL()

//Variaveis do Processo
Local lRetorno    :=.T.
Local lWfDelFA050 := SuperGetMV("US_WFFA050",.T.,.F.) //Ativa��o Envio de WORKFLOW para inclus�o de titulos financeiro na rotina FINA050 - Contas a Pagar// Rafael Almeida - SIGACORP 04/01/2018
Local cRotName := FunName()

//Envio de WORKFLOW para notificar a inclus�o de um TITULO mannual
//Rafael Almeida - SIGACORP 04/01/2018
If lRetorno
	If lWfDelFA050 .AND. (cRotName == "FINA750" .Or. cRotName == "FINA050")
		
		DbSelectArea( "ZE2" )
		DbSetOrder( 1 )
		DbSeek( SE2->E2_FILIAL + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_FORNECE + SE2->E2_LOJA, .F. )
				
		While !Eof() .and. ZE2->(ZE2_PREFIX + ZE2_NUM + ZE2_PARCEL + ZE2_FORNEC + ZE2_LOJA) == SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_FORNECE + SE2->E2_LOJA
			RecLock( "ZE2" , .F. )
			dbDelete()
			MsUnlock()
			DbSkip()
		EndDo
				
	Endif
EndIf
//Termino

Return(lRetorno)  