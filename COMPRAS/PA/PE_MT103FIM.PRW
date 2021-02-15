#include "rwmake.ch"
#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa ³ MT103FIM ³ Rafael Almeida - SIGACORP³ Data ³ 21/10/2016    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ P.E p/Gravação apos entrada da Nota Fiscal de Entrada     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe ³ Chamada padrao para programas em RDMake. MATA103.PRW        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function MT103FIM()
Local nOpcao    := PARAMIXB[1] 		// Opção Escolhida pelo usuario no aRotina
Local nConfirma := PARAMIXB[2]
Local oFont1 := TFont():New("MS Sans Serif",,018,,.T.,,,,,.F.,.F.)
Local oFont2 := TFont():New("MS Sans Serif",,016,,.F.,,,,,.F.,.F.)
Local oGet1
Local cGet1 := Space(3)
Local oGet2
Local cGet2 := Space(254)
Local oGroup1
Local oSay1
Local _nX := 0
Local oSButton1
Local _lOk := .F.
Local PNfOrg       := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_NFORI"})
Local PSrOrg       := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_SERIORI"})
Static oDlg
Private _cDoc			:= SF1->F1_DOC
Private _cSerie			:= SF1->F1_SERIE
Private _dEmiss			:= DtoC(SF1->F1_EMISSAO)
Private _cFornece		:= SF1->F1_FORNECE
Private _cLoja			:= SF1->F1_LOJA
Private _cTipo			:= SF1->F1_TIPO
Private _cNFeOrig		:= ""
Private _cSerOrig		:= ""
Private _nValBrut		:= SF1->F1_VALBRUT
Private _nValSF2		:= 0
Private _cPagSF2		:= ""
Private _dEmiSF2		:= CtoD("  /  /  ")
Private _cCodUsr		:= RetCodUsr() 
private _cMotDev		:= ""




if _cTipo == "D"
	if nOpcao == 3  .and. nConfirma==1 // (Inclusão e Confirmado
		_aArea:=GetArea()
		
		DEFINE MSDIALOG oDlg TITLE "Informe Motivo da Devolução" FROM 000, 000  TO 150, 300 COLORS 0, 16777215 PIXEL
		
		@ 006, 003 GROUP oGroup1 TO 058, 148 PROMPT "Devolução NF " OF oDlg COLOR 16711680, 16777215 PIXEL
		@ 020, 009 SAY oSay1 PROMPT "Motivo da Devolução " SIZE 055, 007 OF oDlg FONT oFont2 COLORS 255, 16777215 PIXEL
		@ 017, 066 MSGET oGet1 VAR cGet1  F3 "ZTM"  VALID ExistCpo("ZTM",cGet1)  SIZE 070, 010 OF oDlg COLORS 0, 16777215 PIXEL
		@ 037, 009 MSGET oGet2 VAR UPPER(cGet2:=GetAdvFVal("ZTM", "ZTM_DESCRI",xFilial("ZTM")+cGet1,1)) SIZE 127, 010 OF oDlg COLORS 0, 16777215 PIXEL When .F.
		DEFINE SBUTTON oSButton1 FROM 061, 118 TYPE 01 ACTION (_lOk:=.T.,oDlg:End())OF oDlg ENABLE
		
		ACTIVATE MSDIALOG oDlg CENTERED
		
		If _lOk
			dbSelectArea("SF1")
			dbSetOrder(1)
			dbSeek(xFilial("SF1")+_cDoc+_cSerie+_cFornece+_cLoja+_cTipo)
			RecLock("SF1",.F.)
			SF1->F1_MOTDEV := cGet1
			_cMotDev	:= SF1->F1_MOTDEV
			MsUnlock()
		EndIf
		
		dbSelectArea("SF1")
		dbCloseArea()
		RestArea(_aArea)
		
		
		For _nX := 1 To Len (aCols)
			If !Empty(aCols[_nX][PNfOrg])
				_cNFeOrig := aCols[_nX][PNfOrg]
				_cSerOrig := aCols[_nX][PSrOrg]
			EndIf
		Next _nX
		
		_cPagSF2 := GetAdvFVal("SF2", "F2_COND"   ,xFilial("SF2") + _cFornece + _cLoja + _cNFeOrig + _cSerOrig ,2)
		_dEmiSF2 := DtoC(GetAdvFVal("SF2", "F2_EMISSAO",xFilial("SF2") + _cFornece + _cLoja + _cNFeOrig + _cSerOrig ,2))
		_nValSF2 := GetAdvFVal("SF2", "F2_VALBRUT",xFilial("SF2") + _cFornece + _cLoja + _cNFeOrig + _cSerOrig ,2)
		
		If !Empty(_cPagSF2)
			If Val(_cPagSF2) >= 902
				Conout()
				U_WfNFDev(_cDoc,_cSerie,_dEmiss,_nValBrut,_cNFeOrig,_cSerOrig,_dEmiSF2,_nValSF2,_cPagSF2,_cCodUsr,_cFornece, _cLoja,_cMotDev)
			EndIf
		EndIf
		
	Endif
EndIf
Return
