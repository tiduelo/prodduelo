#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³FISVALNFE³ Autor³ Rafael Almeida-SIGACORP ³ Data ³13.04.2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Este ponto de entrada foi disponibilizado a fim de permitir ³±±
±±³          ³a validação da transmissão  das NF pela rotina SPEDNFE.     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Verdadeiro .T. ou Falso .F.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Objetivo  ³ Bloquear NF a ser transmitida p/SEFAZ sem MONTAGEM DE CARGA³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FISVALNFE()

Local lTran		:=.T.
Local cTipo		:=PARAMIXB[1]
Local cFil		:=PARAMIXB[2]
Local cEmissao	:=PARAMIXB[3]
Local cNota		:=PARAMIXB[4]
Local cSerie	:=PARAMIXB[5]
Local cClieFor	:=PARAMIXB[6]
Local cLoja		:=PARAMIXB[7]
Local cEspec	:=PARAMIXB[8]
Local cFormul	:=PARAMIXB[9]


If cTipo=="S"
	dbSelectArea("SF2")
	dbSetOrder(2)
	dbseek(cFil+cClieFor+cLoja+cNota+cSerie)
	
	While !EOF() .AND. SF2->F2_FILIAL+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_DOC+SF2->F2_SERIE == cFil+cClieFor+cLoja+cNota+cSerie
		If Empty(SF2->F2_CARGA)
			lTran :=.F.
			MSGALERT( "A Nota Fiscal: "+cNota+"/"+cSerie+" - NÃO poderá ser transmitida sem montagem de carga.", "Bloqueio de transmissão NFe" )
			Exit
		EndIf
		dbSkip()
	End
EndIf
Return(lTran)
