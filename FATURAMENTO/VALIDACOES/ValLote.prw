#include "Rwmake.ch"
#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FATVC02   ³Autor  ³Henio Brasil        ³ Data ³ 06/11/2012  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Validacao na coluna de Qtd do Item do pedido para tratar    º±±
±±º          ³lote de Prdutos Acabados.                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Totvs Para                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//////////////////////////////////////////////
//////////////////////////////////////////////
User Function VALLOTE(_cLote)
//////////////////////////////////////////////
//////////////////////////////////////////////
Local aAreaPed	:= GetArea()
Local aAreaSB8	:= SB8->(GetArea())
local _lret := .t.
Local nPosProd := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
Local nPosQPed	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})

_cProduto := aCols[n][nPosProd]
_nQuant   := aCols[n][nPosQPed]

if !empty(_cLote)
	
	if !empty(_cProduto) .and. !empty(_nQuant)
		
		dbSelectArea("SB8")
		dbSetOrder(5)
		dbgotop()
		
		If dbSeek(xFilial("SB8")+_cProduto+_cLote,.f.)
			
			If B8_SALDO < _nQuant .or. B8_DTVALID <= dDataBase
				
				ALERT( "VALLOTE - Lote informado vencido ou quantidade insuficiente!")
				_lret := .f.
				
			Endif
			
		Else
			
			ALERT( "VALLOTE - Lote nao existe!")
			_lret := .f.
			
		Endif
		
	Else
		
		ALERT("VALLOTE - Produto e quantidade sao obrigatorios !")
		_lret := .f.
		
	Endif

Endif

RestArea(aAreaSB8)
RestArea(aAreaPed)

Return(_lret)
