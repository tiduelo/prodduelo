#include "rwmake.ch"
#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa ³ MA103BUT ³ Rafael Almeida - SIGACORP³ Data ³ 21/10/2016    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ P.E p/Adicionar opções na barra de menus EnchoiceBar      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe ³ Chamada padrao para programas em RDMake. MATA103.PRW        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MA103BUT()

Local aRet := {}

aAdd(aRet, {"NOTE",{||MtDevNf(SF1->F1_MOTDEV)},OemToAnsi("Selecionar Documento Original (NF de Devolução)"),"Mot. de Devolução"} )

Return(aRet)   

Static Function MtDevNf(_cMtDev)
Local oFont1 := TFont():New("MS Sans Serif",,018,,.T.,,,,,.F.,.F.)
Local oFont2 := TFont():New("MS Sans Serif",,016,,.F.,,,,,.F.,.F.)
Local oGet1
Local cGet1 := _cMtDev
Local oGet2
Local cGet2 := Space(254)
Local oGroup1
Local oSay1
Local oSButton1
Local _lOk := .F.
Static oDlg

		DEFINE MSDIALOG oDlg TITLE "Informe Motivo da Devolução" FROM 000, 000  TO 150, 300 COLORS 0, 16777215 PIXEL
		
		@ 006, 003 GROUP oGroup1 TO 058, 148 PROMPT "Devolução NF " OF oDlg COLOR 16711680, 16777215 PIXEL
		@ 020, 009 SAY oSay1 PROMPT "Motivo da Devolução " SIZE 055, 007 OF oDlg FONT oFont2 COLORS 255, 16777215 PIXEL
		@ 017, 066 MSGET oGet1 VAR cGet1  F3 "ZTM"  VALID ExistCpo("ZTM",cGet1)  SIZE 070, 010 OF oDlg COLORS 0, 16777215 PIXEL When .F.
		@ 037, 009 MSGET oGet2 VAR UPPER(cGet2:=GetAdvFVal("ZTM", "ZTM_DESCRI",xFilial("ZTM")+cGet1,1)) SIZE 127, 010 OF oDlg COLORS 0, 16777215 PIXEL When .F.
		DEFINE SBUTTON oSButton1 FROM 061, 118 TYPE 01 ACTION (oDlg:End())OF oDlg ENABLE
		
		ACTIVATE MSDIALOG oDlg CENTERED 

Return
