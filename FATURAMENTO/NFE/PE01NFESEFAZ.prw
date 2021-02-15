#include "rwmake.ch"
#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa ³ PE01NFESEFAZ ³ Rafael Almeida - SIGACORP ³ Data ³ 09/10/16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ manipulacao dos dados nfesefaz                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe ³ Chamada padrao para programas NFESEFAZ.                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

****************************
User Function PE01NFESEFAZ()
****************************

Local aRet      := ParamIXB
Local aClonRet  := aClone(ParamIXB)
Local cTipo     := ""
Local cDoc      := ""
Local cSerie    := ""
Local lVld      := .T.
Local lDC1583   := GetMv("US_DEC1583")
Local lDecLugP  := GetMv("US_LUG1583")
Local cEmpDuel  := GetMv("US_EMPDUEL")
Local cMsgDuel  := GetMv("US_MSGDUEL")
Local cEmpLugP  := GetMv("US_EMPLUGP")
Local cMsgLugP  := GetMv("US_MSGLUGP")
Local cPrdLugP  := GetMv("US_PRODLUG")
Local lPESefaz  := GetMv("US_PESEFAZ")
Local I := 0


If lPESefaz
	
	cTipo  := If(aRet[5, 4] = "1", "S", "E") //Tipo de Nota: 1 – Saída, 2 – Entrada
	cDoc   := aRet[5, 2] //Número da Nota
	cSerie := aRet[5, 1] //Série da Nota
	
	
	If cTipo = "S"
		For I := 1 To Len(aRet[01])
			If lVld
				If cNumEmp $ Alltrim(cEmpDuel)
					If lDC1583
						If GetAdvFVal("SB1", "B1_DC1583",xFilial("SB1")+aRet[01, I, 02],1) > 0
							aRet[02] := Alltrim(cMsgDuel)+" "
							lVld := .F.
						EndIf
					EndIf
				ElseIf cNumEmp $ Alltrim(cEmpLugP)
					If lDecLugP
//						If aRet[01, I, 02] $  Alltrim(cPrdLugP)
						If GetAdvFVal("SB1", "B1_MSG226",xFilial("SB1")+aRet[01, I, 02],1) = "S"
							aRet[02] :=	Alltrim(cMsgLugP)+" "
							lVld := .F.
						EndIf
					EndIf
				EndIf
			EndIf
		Next
		If !lVld
			aRet[02] +=	aClonRet[02]
		EndIf
	EndIf

EndIf

Return(aRet)
