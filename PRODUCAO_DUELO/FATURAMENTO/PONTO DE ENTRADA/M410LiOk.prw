#include "Rwmake.ch"
#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M410LIOK  ³Autor  ³Henio Brasil        ³ Data ³ 06/11/2012  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Pto de Entrada para validar dados na linha do Pedido de     º±±
±±º          ³Vendas.                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Totvs Para                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function M410LIOK()

Local lReturn 	   	:= .T.
Local nPosProd 		:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"} )
Local nPLoteNew   	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOTENEW"} )
Local nPLoteCtl   	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOTECTL"} )
Local nPosDtVal   	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_DTVALID"} )      
Local nPosQtdLb   	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDLIB"}  )      
local nPOSQTDVen    := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDVEN"})
Local nTES          := aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_TES"})
Local lVazio 	   := aCols[n][nPosQtdLb] > 0 .AND. ( (Empty(aCols[n][nPLoteNew]) .Or. Empty(aCols[n][nPLoteCtl]) .Or. Empty(aCols[n][nPosDtVal])) )
Local _ParTES      := GetMv("US_TESBONF")
Local _cTexto := ""
Local cEOL := CHR(10)+CHR(13)

_TES := aCols[n,nTES]

if aCols[n][len(aCols[n])] == .f.
	
	If Rastro(aCols[n][nPosProd]) .And. lVazio
		MsgAlert("M410LIOK - Produto liberado com rastreabilidade, há alguma coluna incompleta nesta linha!" )
		lReturn := .F.
	Endif

	//u_pvcalprc(aCols[n][nPOSQTDVen],.t.)

Else

	//u_pvcalprc(aCols[n][nPOSQTDVen],.t.)
	
Endif 

If  M->C5_TABELA == "100"
	If !(_TES $ _ParTES)
		lReturn := .F.
	    _cTexto := "A TES: "+_TES+", não é uma TES de bonificação" +cEOL
    	_cTexto += "Informe a TES para bonificação!!!"  
     
	    MsgBox(_cTexto,"TES de bonificação-INCORRETO","STOP")     	
	EndIf
EndIf

oGetDad:refresh()

Return(lReturn) 
