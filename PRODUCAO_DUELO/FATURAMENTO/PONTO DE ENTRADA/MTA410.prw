#include "Rwmake.ch"
#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA410    ³Autor  ³                    ³ Data ³ 19/09/2013  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Validacao do pedido                                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Pedido de vendas - ponto de entrada                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
///////////////////////////////////
User Function MTA410()
///////////////////////////////////
Local _x := 0 
Local _lret := .t.

if GetNewPar("MV_CNDPLIM","1") == "2"
	
	_nPosVen := Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_PRCVEN"})
	_nPosFin := Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_PRCFIN"})
	_nPosQtd := Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_QTDVEN"})
	
	_nValPed := 0
	
	For _x := 1 to len(acols)
		
		if ! ( acols[_x][len(aHeader)+1] )
			
			_VenPrc := acols[_x][_nPosVen]
			_VenFin := acols[_x][_nPosFin]
			_VenQtd := acols[_x][_nPosQtd]
			
			if _VenFin == 0
				_VenFin := _VenPrc
			Endif
			
			_nValPed += ROUND( _VenFin*_VenQtd ,2 )
			
		Endif
		
	Next
	
	//alert(transform(round(_nValPed,2),"@E 99,999,999.99"))
/*  VERSAO 12 - RONALDO	
	dbSelectArea("SE4")
	dbSetOrder(1)
	dbgotop()
	
	MsSeek(xFilial("SE4")+M->C5_CONDPAG)
	
	If _nValPed > SE4->E4_SUPER .AND. SE4->E4_SUPER <> 0 
		_lret := .f.
	ElseIf _nValPed < SE4->E4_INFER .AND. SE4->E4_INFER <> 0
		_lret := .f.
	Endif*/
	
//	if ! _lret // versao 12
//		_lret := U_LOG("14" , transform(round(SE4->E4_INFER,2),"@E 99,999,999.99") , transform(round(_nValPed,2),"@E 99,999,999.99"), ,"C",M->C5_CLIENTE,,,"PED",M->C5_NUM)
//	Endif
	
Endif

Return(_lret)
