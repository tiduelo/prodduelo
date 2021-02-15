#include "rwmake.ch"
#include "protheus.ch"
#define DS_MODALFRAME   128
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
	Local oSButton1
	Local _lOk := .F. 
	Local _cAtvPE := SuperGetMv("US_MT100L",.T.,.T.)// Parametro Logico que valida se o ponto de entrada será utilizado.
	Local _aProdt := {}
	Local _y := 0
	Local _aArea :=GetArea()
	LOCAL oDlg
	Private _cDoc			:= SF1->F1_DOC
	Private _cSerie			:= SF1->F1_SERIE
	Private _cFornece		:= SF1->F1_FORNECE
	Private _cLoja			:= SF1->F1_LOJA
	Private _cTipo			:= SF1->F1_TIPO
	Private _cEspecie		:= SF1->F1_ESPECIE   
	Private _dDtEmis		:= SF1->F1_EMISSAO


	if _cTipo == "D"
		if nOpcao == 3  .and. nConfirma==1 // (Inclusão e Confirmado


			//		DEFINE MSDIALOG oDlg TITLE "Informe Motivo da Devolução" FROM 000, 000  TO 150, 300 COLORS 0, 16777215 PIXEL //Comentado por Ronaldo para incluir linha abaixo, com objetivo de remover o X caixa de dialogo e assim evitar o fechamento da mesma.
			DEFINE MsDialog oDlg From 000,000 To 150,300 TITLE "Informe Motivo da Devolução" Pixel Style DS_MODALFRAME // Cria Dialog sem o botão de Fechar.

			@ 006, 003 GROUP oGroup1 TO 058, 148 PROMPT "Devolução NF " OF oDlg COLOR 16711680, 16777215 PIXEL
			@ 020, 009 SAY oSay1 PROMPT "Motivo da Devolução " SIZE 055, 007 OF oDlg FONT oFont2 COLORS 255, 16777215 PIXEL
			@ 017, 066 MSGET oGet1 VAR cGet1  F3 "ZTM"  VALID ExistCpo("ZTM",cGet1)  SIZE 070, 010 OF oDlg COLORS 0, 16777215 PIXEL
			@ 037, 009 MSGET oGet2 VAR UPPER(cGet2:=GetAdvFVal("ZTM", "ZTM_DESCRI",xFilial("ZTM")+cGet1,1)) SIZE 127, 010 OF oDlg COLORS 0, 16777215 PIXEL When .F.
			DEFINE SBUTTON oSButton1 FROM 061, 118 TYPE 01 ACTION (_lOk:=.T.,oDlg:End())OF oDlg ENABLE
			oDlg:lEscClose     := .F. //incluído por ronaldo para impedir que usuário feche a tela usando o botão ESC
			ACTIVATE MSDIALOG oDlg CENTERED



			If _lOk
				dbSelectArea("SF1")
				dbSetOrder(1)
				dbSeek(xFilial("SF1")+_cDoc+_cSerie+_cFornece+_cLoja+_cTipo)
				RecLock("SF1",.F.)
				SF1->F1_MOTDEV := cGet1
				MsUnlock()
			EndIf

			dbSelectArea("SF1")
			dbCloseArea()

		Endif
	EndIf 

	If _cAtvPE 
		if nOpcao == 3  .and. nConfirma==1 .and. Alltrim(_cEspecie) == "SPED"// (Inclusão e Confirmado
			_aArea:=GetArea()

			cQry := " "
			cQry += " 	SELECT *	"
			cQry += " 	FROM "+ RETSQLNAME("SD1")+"  "
			cQry += " 	WHERE D_E_L_E_T_ = ''	"  
			cQry += " 		AND D1_FILIAL    = '"+xfilial("SD1")  +"' "
			cQry += " 		AND D1_DOC       = '"+ Alltrim(_cDoc) +"'	"
			cQry += " 		AND D1_SERIE     = '"+ Alltrim(_cSerie) +"'	"	
			cQry += " 		AND D1_FORNECE   = '"+ Alltrim(_cFornece) +"'	"
			cQry += " 		AND D1_LOJA      = '"+ Alltrim(_cLoja) +"'	"	
			cQry += " 		AND D1_EMISSAO   = '"+ DtoS(_dDtEmis) +"'	"
			cQry:= ChangeQuery(cQry)
			dbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQry) , "TOC" , .T. , .F.)

			DBSelectArea("TOC")
			TOC->(DbGoTop())  
			While !TOC->(Eof())
				aadd( 	_aProdt , { TOC->D1_COD, TOC->D1_TEC } )
				TOC->(DbSkip())
			EndDo
			TOC->( DBCloseArea())		


			For _y :=1 to len(_aProdt)	 

				dbSelectArea("SB1")
				dbSetOrder(1)
				dbSeek(xFilial("SB1")+_aProdt[_y][1])

				If !Empty(_aProdt[_y][2])
					If Alltrim(SB1->B1_POSIPI) <> Alltrim(_aProdt[_y][2])
						RecLock("SB1",.F.)
						SB1->B1_POSIPI :=  _aProdt[_y][2]
						MsUnlock()						
					EndIf
				EndIf

				dbSelectArea("SB1")
				dbCloseArea()		
			Next _y

			RestArea(_aArea)	
		EndIf

	EndIf
	RestArea(_aArea)
Return
