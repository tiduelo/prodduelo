#include "PROTHEUS.CH"
#include "RWMAKE.CH"
#include "TOPCONN.CH"
#Include "AP5Mail.ch"
#INCLUDE "TBICONN.CH"
User Function MTA440C9()

	Local aAreaSC9 := SC9->(GetArea())
	Local _cRisco  := ""
	Local _cBlEst  := SC9->C9_BLEST   
	Local _nSldQtd := 0
	Local _nQtdPv  := SC9->C9_QTDLIB 
	Local _AtvLibPed := SuperGetMv("US_ATVLIPV",.T.,.T.)// Parametro Logico que valida sLIBERARÇÃO DE PEDIDO VAI SER ATIVADO..	
	_carea  := Getarea()

	_cRisco   := GetAdvFVal("SA1", "A1_RISCO",xFilial("SA1")+ SC5->C5_CLIENTE + SC5->C5_LOJACLI ,1)
	_nSldQtd  := CalcEst(SC9->C9_PRODUTO,SC9->C9_LOCAL, date())[1]

	If _nSldQtd >= _nQtdPv
		_cBlEst := " "
	EndIf

	DbSelectArea("SC6")
	DbSetOrder(1)

	If DbSeek(xFilial("SC6") + SC9->C9_PEDIDO + SC9->C9_ITEM + SC9->C9_PRODUTO)


		//	IF SC5->C5_CONDPAG == '901' .AND. SC5->C5_TIPO == 'N' .AND. Alltrim(SC5->C5_FORMPAG) == 'R$' .AND. Alltrim(_cRisco)$"ABCD"
		IF alltrim(SC5->C5_CONDPAG) == '901' .AND. alltrim(SC5->C5_TIPO) == 'N' .AND. Alltrim(SC5->C5_FORMPAG) == 'R$' .AND. Alltrim(_cRisco)$"ABCD" 	



			IF Empty(SC6->C6_LOTECTL) .And. GetAdvFVal("SB1","B1_RASTRO",xFilial("SB1")+SC9->C9_PRODUTO,1) == "L"
				If _AtvLibPed
					RECLOCK("SC9",.F.)
					C9_BLCRED  := "" 
					C9_BLEST   := _cBlEst	
					MSUNLOCK()
				EndIf
			Else
				RECLOCK("SC9",.F.)
				C9_BLCRED  := "" 
				C9_BLEST   := _cBlEst	
				C9_LOTECTL := SC6->C6_LOTECTL 
				C9_DTVALID := SC6->C6_DTVALID 				
				MSUNLOCK()     
				//Endif

				//				SA1->A1_SALPED  -= (SC6->C6_QTDVEN * SC6->C6_PRCVEN)
				If (SC6->C6_QTDVEN > 0)											
					dbselectarea("SA1")
					dbsetorder(1)
					dbgotop()
					IF dbSeek(xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA) 
						RecLock("SA1",.f.)
						SA1->A1_SALPEDB := 0
						//SA1->A1_SALPEDL += (SC6->C6_QTDVEN * SC6->C6_PRCVEN)
						SA1->A1_SALPEDL += (SC6->C6_QTDEMP * SC6->C6_PRCVEN)
						MsUnLock()
					EndIf
				EndIf
			EndIf			
		ENDIF


	EndIf



	_cBlEst:= ""

	Restarea(_carea)
Return ()
