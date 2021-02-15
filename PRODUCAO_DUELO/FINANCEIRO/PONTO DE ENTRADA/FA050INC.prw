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
User Function FA050INC()

//Variaveis do Processo
Local lRetorno    :=.T.
Local aLista      := {}
Local lWfIncFA050 := SuperGetMV("US_WFFA050",.T.,.F.) //Ativa��o Envio de WORKFLOW para inclus�o de titulos financeiro na rotina FINA050 - Contas a Pagar// Rafael Almeida - SIGACORP 04/01/2018
Local cRotName := FunName()
Local _lAtvFa050INC :=  SuperGetMv("AL_FA050TOK",.T.,.T.)
Local _cCC      := ""
Local _cCta     := ""
Local _cRat		:= ""
Local _cRgNvCC1  := ""
Local _cRgNvCC2  := ""
Local _cRgNvCC3  := ""
Local _cRgNv1Cta := ""
Local _cRgNv2Cta := ""
Local _cRgNv3Cta := ""
Private _cCodUsr  := RetCodUsr()
Private _cGrpUsr  := GetNewPar("US_USRCT1","/000107/000029/000049/000122/000124/000069/000127/000047/")



If lRetorno .AND. (cRotName == "FINA750" .Or. cRotName == "FINA050")
	If  _lAtvFa050INC
		
		_cCC  :=  M->E2_CCUSTO   // A variavel esta recebendo o conteudo do campo onde a linha esta posicionada.
		_cCta :=  M->E2_CONTAD      // A variavel esta recebendo o conteudo do campo onde a linha esta posicionada.
		
		_cRat :=  M->E2_RATEIO
		
		If !Empty(_cCta) .And. SubStr(Alltrim(_cCta),1,1)=="4" .And. Empty(_cCC) .And. _cRat == "N"
			lRetorno := .F.
			MSGInfo("Aten��o!!! Centro de Custo � obrigatorio para Conta Cont�bil.")
		ElseIf !Empty(_cCC) .And. Empty(_cCta) .And. _cRat == "N"
			lRetorno := .F.
			MSGInfo("Aten��o!!! Conta Cont�bil � obrigatorio para quando Centro de Custo estiver preenchido.")
		ElseIf Empty(_cCC) .And. Empty(_cCta) .And. _cRat == "N"
			lRetorno := .F.
			MSGInfo("Aten��o!!! Conta Cont�bil e Centro de Custo s�o Obrigatorios.")											
		Elseif !Empty(_cCta) .And. SubStr(Alltrim(_cCta),1,1)=="4" .And. !Empty(_cCC) .And. _cRat == "N"
			_cRgNvCC1   := GetAdvFVal("CTT","CTT_CRGNV1",xFilial("CTT")+_cCC,1)
			_cRgNvCC2   := GetAdvFVal("CTT","CTT_RGNV2",xFilial("CTT")+_cCC,1)
			_cRgNvCC3   := GetAdvFVal("CTT","CTT_RGNV3",xFilial("CTT")+_cCC,1)
			_cRgNv1Cta  := GetAdvFVal("CT1","CT1_RGNV1",xFilial("CT1")+_cCta,1)
			_cRgNv2Cta  := GetAdvFVal("CT1","CT1_RGNV2",xFilial("CT1")+_cCta,1)
			_cRgNv3Cta  := GetAdvFVal("CT1","CT1_RGNV3",xFilial("CT1")+_cCta,1)
			
			If     !Empty(_cRgNvCC1)
				If Alltrim(_cRgNvCC1) <>  Alltrim(_cRgNv1Cta)
					If Alltrim(_cCodUsr) $  Alltrim(_cGrpUsr)
						lRetorno := .T.
					Else
						lRetorno := .F.
						MSGInfo("Aten��o!!! Favor verificar o preenchimento do Centro de Custo e/ou Conta Cont�bil corretos.")
					EndIf
				Else
					Conout("Primeiro IF _cAtvPE - MT110LOK")
				EndIf
				
				If !Empty(_cRgNvCC2)
					If Alltrim(_cRgNvCC2) <>  Alltrim(_cRgNv2Cta)
						If Alltrim(_cCodUsr) $  Alltrim(_cGrpUsr)
							lRetorno := .T.
						Else
							lRetorno := .F.
							MSGInfo("Aten��o!!! Favor verificar o preenchimento do Centro de Custo e/ou Conta Cont�bil corretos.")
						EndIf
					Else
						Conout("Primeiro IF _cAtvPE - MT110LOK")
					EndIf
				EndIf
				
				If !Empty(_cRgNvCC3)
					If Alltrim(_cRgNvCC3) <>  Alltrim(_cRgNv3Cta)
						If Alltrim(_cCodUsr) $  Alltrim(_cGrpUsr)
							lRetorno := .T.
						Else
							lRetorno := .F.
							MSGInfo("Aten��o!!! Favor verificar o preenchimento do Centro de Custo e/ou Conta Cont�bil corretos.")
						EndIf
					Else
						Conout("Primeiro IF _cAtvPE - MT110LOK")
					EndIf
				EndIf
				
			ElseIf !Empty(_cRgNvCC2)
				If Alltrim(_cRgNvCC2) <>  Alltrim(_cRgNv2Cta)
					If Alltrim(_cCodUsr) $  Alltrim(_cGrpUsr)
						lRetorno := .T.
					Else
						lRetorno := .F.
						MSGInfo("Aten��o!!! Favor verificar o preenchimento do Centro de Custo e/ou Conta Cont�bil corretos.")
					EndIf
				EndIf
				
				If !Empty(_cRgNvCC3)
					If Alltrim(_cRgNvCC3) <>  Alltrim(_cRgNv3Cta)
						If Alltrim(_cCodUsr) $  Alltrim(_cGrpUsr)
							lRetorno := .T.
						Else
							lRetorno := .F.
							MSGInfo("Aten��o!!! Favor verificar o preenchimento do Centro de Custo e/ou Conta Cont�bil corretos.")
						EndIf
					Else
						Conout("Primeiro IF _cAtvPE - MT110LOK")
					EndIf
				EndIf
				
			ElseIf !Empty(_cRgNvCC3)
				If Alltrim(_cRgNvCC3) <>  Alltrim(_cRgNv3Cta)
					If Alltrim(_cCodUsr) $  Alltrim(_cGrpUsr)
						lRetorno := .T.
					Else
						lRetorno := .F.
						MSGInfo("Aten��o!!! Favor verificar o preenchimento do Centro de Custo e/ou Conta Cont�bil corretos.")
					EndIf
				EndIf
				
			EndIf
		EndIf
	EndIf
EndIf


//Envio de WORKFLOW para notificar a inclus�o de um TITULO mannual
//Rafael Almeida - SIGACORP 04/01/2018
If lRetorno
	If lWfIncFA050 .AND. (cRotName == "FINA750" .Or. cRotName == "FINA050")
		/*
		�����������������������������������������������������������������������������
		�����������������������������������������������������������������������������
		�������������������������������������������������������������������������ͻ��
		���  [01]-SubStr(Time(),1,5))		->		Hora de Inclus�o do Titulo    ���
		���  [02]-DtoC(Date())				->		Data de Inclus�o do Titulo    ���
		���  [03]-RetCodUsr()				->		C�d. Usuario que Inc. Titulo  ���
		���  [04]-UsrFullName(RetCodUsr())	->		Nome usuario que Inc. Titulo  ���
		���  [05]-M->E1_CLIENTE				->		C�d. do Cliente				  ���
		���  [06]-M->E1_LOJA				->		Loja do Cliente				  ���
		���  [07]-M->E1_NOMCLI				->		Nome do Cliente				  ���
		���  [08]-M->E1_VALOR				->		Valor do Titulo				  ���
		���  [09]-M->E1_PREFIXO				->		Prexifo do Titulo			  ���
		���  [10]-M->E1_NUM					->		Numero do Titulo			  ���
		���  [11]-M->E1_TIPO				->		Tipo do Titulo				  ���
		���  [12]-M->E1_NATUREZ				->		Natureza do Titulo			  ���
		���  [13]-M->E1_EMISSAO				->		Emiss�o do Titulo			  ���
		���  [14]-M->E1_VENCTO				->		Vencimento do Titulo		  ���
		���  [15]-M->E1_HIST				->		Historico do Titulo			  ���
		�����������������������������������������������������������������������������
		�����������������������������������������������������������������������������
		*/
		aAdd(aLista, {SubStr(Time(),1,5),Date(),RetCodUsr(),UsrFullName(RetCodUsr()),M->E2_FORNECE,M->E2_LOJA,M->E2_NOMFOR,M->E2_VALOR,M->E2_PREFIXO,M->E2_NUM,M->E2_TIPO,M->E2_NATUREZ,M->E2_EMISSAO,M->E2_VENCTO,M->E2_HIST,M->E2_PARCELA})
		U_HISTZE2(aLista)
	Endif
EndIf
//Termino


Return(lRetorno)
