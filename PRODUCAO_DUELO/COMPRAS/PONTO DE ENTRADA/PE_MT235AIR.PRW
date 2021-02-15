// +-----------+--------------+------------------------------------+-----------------------+
// | Programa  | MT235AIR.PRW | Autor: Rafael Cruz                 | Data Des.: 03/01/2020 |
// +-----------+--------------+------------------------------------+-----------------------+
// | Descricao | PE Permite customização do usuário, executado sempre ao final do          | 
// |           | processamento de eliminação por resíduo                                   |
// +-----------+---------------------------------------------------+-----------------------+
// | Uso       | DUELO                                             | Data Atu.: 03/01/2020 |
// +-----------+---------------------------------------------------+-----------------------+
// | 03/01/20  | Ajustes:                                                                  |
// |           |                                                                           |
// |           |                                                                           |
// |           |                                                                           |
// +-----------+---------------------------------------------------+-----------------------+

/*
ParamIxb[1]			Caracter			Alias do arq.em verificação: "SC7","SC3" ou "SC1"										
ParamIxb[2]			Array of Record		Número indicativo do arq.em verificação: 1 = "SC7" | 2 = "SC3" | 3 = "SC1"
*/


#include "rwmake.ch"
#include "PROTHEUS.ch"

User Function MT235AIR()
	Local _cAlias   := ParamIXB[1]
	Local _cTpAlias := ParamIXB[2]
	Local _lVld     := .T.
Local oFont1 := TFont():New("MS Sans Serif",,018,,.T.,,,,,.F.,.F.)
Local oFont2 := TFont():New("MS Sans Serif",,020,,.T.,,,,,.F.,.F.)
Local oGet1
Local cGet1 := " "
Local oGet2
Local cGet2 := " "
Local oGet3
Local cGet3 := " "
Local oGet4
Local cGet4 := " "
Local oGet5
Local cGet5 := " "
Local oGroup1
Local oGroup2
Local oMultiGe1
Local cMultiGe1 := " "
Local oSay1
Local oSay2
Local oSay3
Local oSay4
Local oSay5
Local oSay6
Local oSButton1
Static oDlg

		If _cTpAlias == 1
			cGet1 := "Pedido de Compras" 
			cGet2 := SC7->C7_NUM
			cGet3 := SC7->C7_ITEM
			cGet4 := SC7->C7_PRODUTO
			cGet5 := SC7->C7_DESCRI
		ElseIf _cTpAlias == 3
			cGet1 := "Solicitação de Compras" 
			cGet2 := SC1->C1_NUM
			cGet3 := SC1->C1_ITEM
			cGet4 := SC1->C1_PRODUTO
			cGet5 := SC1->C1_DESCRI			
		Endif



  DEFINE MSDIALOG oDlg TITLE "EXCLUSÃO DE RESÍDUO" FROM 000, 000  TO 470, 500 COLORS 0, 16777215 PIXEL



    @ 009, 005 GROUP oGroup2 TO 052, 246 OF oDlg COLOR 0, 16777215 PIXEL
    @ 019, 018 SAY oSay1 PROMPT "ATENÇÃO - Será necessário informar o motivo da exclusão por resido" SIZE 216, 020 OF oDlg FONT oFont2 COLORS 255, 16777215 PIXEL
        
    @ 055, 006 GROUP oGroup1 TO 229, 246 PROMPT "MOTIVO" OF oDlg COLOR 255, 16777215 PIXEL
    @ 131, 019 GET oMultiGe1 VAR cMultiGe1 VALID !Empty(cMultiGe1) OF oDlg MULTILINE SIZE 213, 078 COLORS 0, 16777215 HSCROLL PIXEL
    @ 066, 015 SAY oSay2 PROMPT "Tipo :" SIZE 025, 007 OF oDlg FONT oFont1 COLORS 16711680, 16777215 PIXEL
    @ 077, 015 SAY oSay3 PROMPT "Numero: " SIZE 028, 007 OF oDlg FONT oFont1 COLORS 16711680, 16777215 PIXEL
    @ 089, 015 SAY oSay4 PROMPT "Item: " SIZE 025, 007 OF oDlg FONT oFont1 COLORS 16711680, 16777215 PIXEL
    @ 100, 015 SAY oSay5 PROMPT "Produto: " SIZE 029, 007 OF oDlg FONT oFont1 COLORS 16711680, 16777215 PIXEL
    @ 113, 015 SAY oSay6 PROMPT "Descrição" SIZE 044, 007 OF oDlg FONT oFont1 COLORS 16711680, 16777215 PIXEL
    @ 065, 052 MSGET oGet1 VAR cGet1 SIZE 185, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
    @ 076, 052 MSGET oGet2 VAR cGet2 SIZE 185, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
    @ 087, 052 MSGET oGet3 VAR cGet3 SIZE 185, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
    @ 099, 052 MSGET oGet4 VAR cGet4 SIZE 185, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
    @ 111, 052 MSGET oGet5 VAR cGet5 SIZE 185, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
    DEFINE SBUTTON oSButton1 FROM 213, 217 TYPE 01 ACTION (_lOk:=.T.,oDlg:End()) OF oDlg ENABLE
    
	ACTIVATE MSDIALOG oDlg CENTERED VALID !Empty(cMultiGe1)

	If _lOk
		If _cTpAlias == 1
			RecLock("SC7",.F.)
			SC7->C7_MOTIVO := cMultiGe1
			MsUnlock("SC7")
		ElseIf _cTpAlias == 3
			RecLock("SC1",.F.)
			SC1->C1_MOTIVO := cMultiGe1
			MsUnlock("SC1")
		Endif
	EndIf

Return