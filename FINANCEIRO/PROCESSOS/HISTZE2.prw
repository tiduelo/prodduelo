#Include "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#include "ap5mail.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RAltDtCR ºAutor  ³Rafael Almeida      º Data ³  			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função para envio de e-mails aos monitore                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function HISTZE2(aLista)
Local _aVetor  := aLista

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º  [01]-SubStr(Time(),1,5))		->		Hora de Inclusão do Titulo    º±±
±±º  [02]-DtoC(Date())				->		Data de Inclusão do Titulo    º±±
±±º  [03]-RetCodUsr()				->		Cód. Usuario que Inc. Titulo  º±±
±±º  [04]-UsrFullName(RetCodUsr())	->		Nome usuario que Inc. Titulo  º±±
±±º  [05]-M->E1_CLIENTE				->		Cód. do Cliente				  º±±
±±º  [06]-M->E1_LOJA				->		Loja do Cliente				  º±±
±±º  [07]-M->E1_NOMCLI				->		Nome do Cliente				  º±±
±±º  [08]-M->E1_VALOR				->		Valor do Titulo				  º±±
±±º  [09]-M->E1_PREFIXO				->		Prexifo do Titulo			  º±±
±±º  [10]-M->E1_NUM					->		Numero do Titulo			  º±±
±±º  [11]-M->E1_TIPO				->		Tipo do Titulo				  º±±
±±º  [12]-M->E1_NATUREZ				->		Natureza do Titulo			  º±±
±±º  [13]-M->E1_EMISSAO				->		Emissão do Titulo			  º±±
±±º  [14]-M->E1_VENCTO				->		Vencimento do Titulo		  º±±
±±º  [15]-M->E1_HIST				->		Historico do Titulo			  º±±
±±º  [16]-M->E1_PARCELA				->		Parcela do Titulo			  º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/

Begin Transaction
	DbSelectArea("ZE2")
	DbSetOrder(1)

	RecLock("ZE2",.T.)
			ZE2->ZE2_FILIAL := xFilial("ZE2")
			ZE2->ZE2_DTINCL := _aVetor[1][2]
			ZE2->ZE2_HRINCL := _aVetor[1][1]
			ZE2->ZE2_FORNEC := _aVetor[1][5]
			ZE2->ZE2_LOJA   := _aVetor[1][6]
			ZE2->ZE2_NOMFOR := _aVetor[1][7]
			ZE2->ZE2_VALOR  := _aVetor[1][8]
			ZE2->ZE2_PREFIX := _aVetor[1][9]
			ZE2->ZE2_NUM    := _aVetor[1][10]
			ZE2->ZE2_PARCEL := _aVetor[1][16]
			ZE2->ZE2_TIPO   := _aVetor[1][11]
			ZE2->ZE2_NATURE := _aVetor[1][12]
			ZE2->ZE2_EMISSA := _aVetor[1][13]
			ZE2->ZE2_VENCTO := _aVetor[1][14]
			ZE2->ZE2_HIST   := _aVetor[1][15]
			ZE2->ZE2_CODUSR := _aVetor[1][3]
			ZE2->ZE2_NAMUSR := _aVetor[1][4]
	ZE2->(MsUnLock())
	DbCloseArea()

End Transaction

Return()