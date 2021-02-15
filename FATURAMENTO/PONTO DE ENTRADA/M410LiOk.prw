#include "Rwmake.ch"
#include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M410LIOK  �Autor  �Henio Brasil        � Data � 06/11/2012  ���
�������������������������������������������������������������������������͹��
���Desc.     �Pto de Entrada para validar dados na linha do Pedido de     ���
���          �Vendas.                                                     ���
�������������������������������������������������������������������������͹��
���Uso       �Totvs Para                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
User Function M410LIOK()

Local lReturn 	   	:= .T.
Local nPosProd 		:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"} )
Local nPLoteNew   	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOTENEW"} )
Local nPLoteCtl   	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOTECTL"} )
Local nPosDtVal   	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_DTVALID"} )      
Local nPosQtdLb   	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDLIB"}  )      
local nPOSQTDVen    := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDVEN"})
Local nTES�����     := aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_TES"})
Local lVazio 	   := aCols[n][nPosQtdLb] > 0 .AND. ( (Empty(aCols[n][nPLoteNew]) .Or. Empty(aCols[n][nPLoteCtl]) .Or. Empty(aCols[n][nPosDtVal])) )
Local _ParTES      := GetMv("US_TESBONF")
Local _cTexto := ""
Local cEOL := CHR(10)+CHR(13)

_TES := aCols[n,nTES]

if aCols[n][len(aCols[n])] == .f.
	
	If Rastro(aCols[n][nPosProd]) .And. lVazio
		MsgAlert("M410LIOK - Produto liberado com rastreabilidade, h� alguma coluna incompleta nesta linha!" )
		lReturn := .F.
	Endif

	//u_pvcalprc(aCols[n][nPOSQTDVen],.t.)

Else

	//u_pvcalprc(aCols[n][nPOSQTDVen],.t.)
	
Endif 

If �M->C5_TABELA == "100"
	If !(_TES $ _ParTES)
		lReturn := .F.
	����_cTexto := "A TES: "+_TES+", n�o � uma TES de bonifica��o" +cEOL
����	_cTexto += "Informe a TES para bonifica��o!!!"��
�����
	����MsgBox(_cTexto,"TES de bonifica��o-INCORRETO","STOP")�����	
	EndIf
EndIf

oGetDad:refresh()

Return(lReturn) 
