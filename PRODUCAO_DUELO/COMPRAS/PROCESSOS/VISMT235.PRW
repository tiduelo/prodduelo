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

#include "rwmake.ch"
#include "PROTHEUS.ch"

User Function VISMT235(_nTabela)
Local _cTpAlias := _nTabela
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
Local oMultiGe1
Local cMultiGe1 := " "
Local oSay2
Local oSay3
Local oSay4
Local oSay5
Local oSay6
Local oSButton1
Local _cResiduo := " "
Static oDlg

If _cTpAlias == 1
			cGet1 := "Pedido de Compras" 
			cGet2 := SC7->C7_NUM
			cGet3 := SC7->C7_ITEM
			cGet4 := SC7->C7_PRODUTO
			cGet5 := SC7->C7_DESCRI
			cMultiGe1 := SC7->C7_MOTIVO 
			_cResiduo := SC7->C7_RESIDUO
		ElseIf _cTpAlias == 3
			cGet1 := "Solicitação de Compras" 
			cGet2 := SC1->C1_NUM
			cGet3 := SC1->C1_ITEM
			cGet4 := SC1->C1_PRODUTO
			cGet5 := SC1->C1_DESCRI	
			cMultiGe1 := SC1->C1_MOTIVO
			_cResiduo  := SC1->C1_RESIDUO 
		Endif
		
		If Empty(_cResiduo)
			Return()
		EndIf

  DEFINE MSDIALOG oDlg TITLE "EXCLUSÃO DE RESÍDUO" FROM 000, 000  TO 440, 500 COLORS 0, 16777215 PIXEL

    @ 005, 006 GROUP oGroup1 TO 193, 246 PROMPT "MOTIVO" OF oDlg COLOR 255, 16777215 PIXEL
    @ 108, 014 GET oMultiGe1 VAR cMultiGe1 OF oDlg MULTILINE SIZE 222, 078 COLORS 0, 16777215 HSCROLL PIXEL WHEN .F.
    @ 022, 012 SAY oSay2 PROMPT "Tipo :" SIZE 025, 007 OF oDlg FONT oFont1 COLORS 16711680, 16777215 PIXEL
    @ 038, 012 SAY oSay3 PROMPT "Numero: " SIZE 028, 007 OF oDlg FONT oFont1 COLORS 16711680, 16777215 PIXEL
    @ 054, 012 SAY oSay4 PROMPT "Item: " SIZE 025, 007 OF oDlg FONT oFont1 COLORS 16711680, 16777215 PIXEL
    @ 066, 012 SAY oSay5 PROMPT "Produto: " SIZE 029, 007 OF oDlg FONT oFont1 COLORS 16711680, 16777215 PIXEL
    @ 081, 012 SAY oSay6 PROMPT "Descrição:" SIZE 044, 007 OF oDlg FONT oFont1 COLORS 16711680, 16777215 PIXEL    
    @ 022, 052 MSGET oGet1 VAR cGet1 SIZE 185, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
    @ 036, 052 MSGET oGet2 VAR cGet2 SIZE 185, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
    @ 051, 052 MSGET oGet3 VAR cGet3 SIZE 185, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
    @ 065, 052 MSGET oGet4 VAR cGet4 SIZE 185, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
    @ 079, 052 MSGET oGet5 VAR cGet5 SIZE 185, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
    DEFINE SBUTTON oSButton1 FROM 200, 217 TYPE 01 ACTION (oDlg:End()) OF oDlg ENABLE        

  ACTIVATE MSDIALOG oDlg CENTERED

Return