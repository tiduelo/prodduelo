#include "rwmake.ch"        
#INCLUDE "Protheus.ch"
#INCLUDE "PROTHEUS2.CH"
#INCLUDE "Topconn.ch"
#INCLUDE "Rwmake.ch"
#INCLUDE "Msole.ch"    
#include "protheus.ch"
//+--------------------------------------------------------------------+
//| Rotina | ALATFA001 | Autor | Rafael Almeida | Data | 30.06.2015    |
//+--------------------------------------------------------------------+
//| Descr. | Função exemplo do protótipo Modelo2.                      |
//+--------------------------------------------------------------------+
//| Uso | PA21_CTCON36 - ATIVO FIXO.                                   |
//+--------------------------------------------------------------------+
User Function ALATFA001()

Private cCadastro := "Grupo Usuário X Centro Custo"
Private aRotina := {}

AADD( aRotina, {"Pesquisar"  ,"AxPesqui"   ,0,1})
AADD( aRotina, {"Visualizar" ,'U_MTATFA001',0,2})
AADD( aRotina, {"Incluir"    ,'U_INATFA001',0,3})
AADD( aRotina, {"Alterar"    ,'U_MTATFA001',0,4})
AADD( aRotina, {"Excluir"    ,'U_MTATFA001',0,5})

dbSelectArea("ZTT")
dbSetOrder(1)
dbGoTop()
MBrowse(,,,,"ZTT",,,,,,)

Return

//+--------------------------------------------------------------------+
//| Rotina | INATFA001 | Autor | Rafael Almeida | Data | 30.06.2015    |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para incluir dados.                                |
//+--------------------------------------------------------------------+
//| Uso | PA21_CTCON36 - ATIVO FIXO.                                   |
//+--------------------------------------------------------------------+
User Function INATFA001( cAlias, nReg, nOpc )

Local oDlg
Local oGet
Local oTPanel1
Local oTPAnel2
Local cCodigo := ""
Local cDescGrp := ""
Local cNome := USRFULLNAME(RETCODUSR())
Local dData := dDataBase
Local cCC := "999"
Private aHeader := {}
Private aCOLS := {}
Private aREG := {}


dbSelectArea( cAlias )
dbSetOrder(1)

Mod2aHeader( cAlias )
Mod2aCOLS( cAlias, nReg, nOpc )

DEFINE MSDIALOG oDlg TITLE cCadastro From 8,0 To 28,180 OF oMainWnd 
oDlg:lMaximized := .T.
oTPanel1 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
oTPanel1:Align := CONTROL_ALIGN_TOP

@ 4, 005 SAY "Grupo Usuario:" SIZE 70,7 PIXEL OF oTPanel1
@ 4, 105 SAY "Descrição :" SIZE 70,7 PIXEL OF oTPanel1
@ 3, 050 MSGET cCodigo F3 "GRP" PICTURE "@!" VALID Mod2Grp(cCodigo, @cDescGrp) SIZE 030,7 PIXEL OF oTPanel1
@ 3, 140 MSGET cDescGrp   When .F. SIZE 150,7 PIXEL OF oTPanel1

oTPanel2 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
oTPanel2:Align := CONTROL_ALIGN_BOTTOM

oGet := MSGetDados():New(0,0,0,0,nOpc,"U_Mod2LOk()",".T.","",.T.)
oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar(oDlg,{|| IIF(U_Mod2TOk(),(Mod2GrvI(cCodigo,cDescGrp),oDlg:End()),( oDlg:End(), NIL ) )},{|| oDlg:End() })
Return


//+----------------------------------------------------------------------+
//| Rotina | Mod2aHeader | Autor | Rafael Almeida | Data | 30.06.2015    |
//+----------------------------------------------------------------------+
//| Descr. | Rotina para montar o vetor aHeader.                         |
//+----------------------------------------------------------------------+
//| Uso | PA21_CTCON36 - ATIVO FIXO.                                     |
//+----------------------------------------------------------------------+
Static Function Mod2aHeader( cAlias )

Local aArea := GetArea()
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek( cAlias )
	While !EOF() .And. X3_ARQUIVO == cAlias
		If X3Uso(X3_USADO) .And. cNivel >= X3_NIVEL
			AADD( aHeader, { Trim( X3Titulo() ),;
								   X3_CAMPO,;
								   X3_PICTURE,;
								   X3_TAMANHO,;
								   X3_DECIMAL,;
								   X3_VALID,;
								   X3_USADO,;
								   X3_TIPO,;
								   X3_ARQUIVO,;
								   X3_CONTEXT})
		Endif
	 dbSkip()
	End
RestArea(aArea)
Return

//+--------------------------------------------------------------------+
//| Rotina | Mod2aCOLS | Autor | Rafael Almeida | Data | 30.06.2015    |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para montar o vetor aCOLS.                         |
//+--------------------------------------------------------------------+
//| Uso | PA21_CTCON36 - ATIVO FIXO.                                   |
//+--------------------------------------------------------------------+
Static Function Mod2aCOLS( cAlias, nReg, nOpc )

Local aArea := GetArea()
Local cChave := ZTT->ZTT_GRPUSR+ZTT->ZTT_CC
Local nI := 0

	If nOpc <> 3
		dbSelectArea( cAlias )
		dbSetOrder(1)
		dbSeek( xFilial( cAlias ) + cChave )
			While !EOF() .And. ZTT->( ZTT_FILIAL + ZTT_GRPUSR + ZTT_CC ) == xFilial( cAlias ) + cChave
				AADD( aREG, ZTT->( RecNo() ) )
				AADD( aCOLS, Array( Len( aHeader ) + 1 ) )
					For nI := 1 To Len( aHeader )
						If aHeader[nI,10] == "V"
							aCOLS[Len(aCOLS),nI] := CriaVar(aHeader[nI,2],.T.)
						Else
							aCOLS[Len(aCOLS),nI] := FieldGet(FieldPos(aHeader[nI,2]))
						Endif
					Next nI
				aCOLS[Len(aCOLS),Len(aHeader)+1] := .F.
			dbSkip()
			End
	Else
		AADD( aCOLS, Array( Len( aHeader ) + 1 ) )

		For nI := 1 To Len( aHeader )
			aCOLS[1, nI] := CriaVar( aHeader[nI, 2], .T. )
		Next nI
		aCOLS[1, Len( aHeader )+1 ] := .F.
	Endif

Restarea( aArea )
Return                                        



//+--------------------------------------------------------------------+
//| Rotina | Mod2LOk   | Autor | Rafael Almeida | Data | 30.06.2015    |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para validar a linha de dados.                     |
//+--------------------------------------------------------------------+
//| Uso | PA21_CTCON36 - ATIVO FIXO.                                   |
//+--------------------------------------------------------------------+
User Function Mod2LOk()

Local lRet := .T.
Local cMensagem := "Não será permitido linhas sem o centro de custo."


	If !aCOLS[n, Len(aHeader)+1]
		If Empty(aCOLS[n,GdFieldPos("ZTT_CC")])
			MsgAlert(cMensagem,cCadastro)
			lRet := .F.
		Endif
	Endif
Return( lRet )                         


//+--------------------------------------------------------------------+
//| Rotina | Mod2TOk   | Autor | Rafael Almeida | Data | 30.06.2015    |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para validar toda as linhas de dados.              |
//+--------------------------------------------------------------------+
//| Uso | PA21_CTCON36 - ATIVO FIXO.                                   |
//+--------------------------------------------------------------------+
User Function Mod2TOk()

Local lRet := .T.
Local nI := 0
Local cMensagem := "Não será permitido linhas sem o centro de custo."

	For nI := 1 To Len( aCOLS )
		If aCOLS[nI, Len(aHeader)+1]
			Loop
		Endif

		If !aCOLS[nI, Len(aHeader)+1]
			If Empty(aCOLS[n,GdFieldPos("ZTT_CC")])
				MsgAlert(cMensagem,cCadastro)
				lRet := .F.
				Exit
			Endif					
		Endif
	Next nI

Return( lRet )                                   


//+--------------------------------------------------------------------+
//| Rotina | Mod2GrvI  | Autor | Rafael Almeida | Data | 30.06.2015    |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para gravar os dados na inclusão.                  |
//+--------------------------------------------------------------------+
//| Uso | PA21_CTCON36 - ATIVO FIXO.                                   |
//+--------------------------------------------------------------------+
Static Function Mod2GrvI(cCodigo,cDescGrp)

Local aArea := GetArea()
Local nI        := 0
Local nX        := 0
Local cStatus   := ""
Local cUserSol  := "" 
Local cUsrApro  := ""
Local cUserApro := ""
Local cMailApro := ""

dbSelectArea("ZTT")
dbSetOrder(1)
	For nI := 1 To Len( aCOLS )
		If ! aCOLS[nI,Len(aHeader)+1]
			RecLock("ZTT",.T.)
			ZTT->ZTT_FILIAL    := xFilial("ZTT")
			ZTT->ZTT_GRPUSR    := cCodigo
			ZTT->ZTT_DESCGRP   := cDescGrp
			For nX := 1 To Len( aHeader )
				FieldPut( FieldPos( aHeader[nX, 2] ), aCOLS[nI, nX] )
			Next nX
			MsUnLock()
		Endif
	Next nI

RestArea(aArea)
Return



//+--------------------------------------------------------------------+
//| Rotina | MTATFA001 | Autor | Rafael Almeida | Data | 30.06.2015    |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para Visualizar, Alterar e Excluir dados.          |
//+--------------------------------------------------------------------+
//| Uso | PA21_CTCON36 - ATIVO FIXO.                                   |
//+--------------------------------------------------------------------+
User Function MTATFA001( cAlias, nReg, nOpc )

Local oDlg
Local oGet
Local oTPanel1
Local oTPAnel2
Local cCodigo   := ""
Local cNome     := ""
Local cData     := Ctod("  /  /  ")
Local cCC       := ""
Local cCodSupCTT := ""
Local cUserLogin := RetCodUsr()
Private aHeader := {}
Private aCOLS   := {}
Private aREG    := {} 


dbSelectArea( cAlias )
dbGoTo( nReg )
	cCodigo 	:= ZTT->ZTT_GRPUSR
	cDescGrp    := ZTT->ZTT_DESCGRP

	Mod2aHeader( cAlias )
	Mod2aCOLS( cAlias, nReg, nOpc )

	DEFINE MSDIALOG oDlg TITLE cCadastro From 8,0 To 28,80 OF oMainWnd
	oDlg:lMaximized := .T.
    oTPanel1 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
    oTPanel1:Align := CONTROL_ALIGN_TOP


	@ 4, 005 SAY "Grupo Usuario:" SIZE 70,7 PIXEL OF oTPanel1
	@ 4, 105 SAY "Descrição :" SIZE 70,7 PIXEL OF oTPanel1
	@ 3, 050 MSGET cCodigo F3 "GRP" PICTURE "@!" VALID Mod2Grp(cCodigo, @cDescGrp) SIZE 030,7 PIXEL OF oTPanel1
	@ 3, 140 MSGET cDescGrp   When .F. SIZE 150,7 PIXEL OF oTPanel1

	oTPanel2 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPanel2:Align := CONTROL_ALIGN_BOTTOM

		If nOpc == 4
			oGet := MSGetDados():New(0,0,0,0,nOpc,"U_Mod2LOk()",".T.","",.T.)
		Else
			oGet := MSGetDados():New(0,0,0,0,nOpc)			
		Endif
		oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

	ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar(oDlg,{|| ( IIF( nOpc==4, (Mod2GrvA(cCodigo,cDescGrp),oDlg:End()), IIF( nOpc==5, Mod2GrvE(), oDlg:End() ) ), oDlg:End() ) },{|| oDlg:End() })


Return                    



//+--------------------------------------------------------------------+
//| Rotina | Mod2GrvE  | Autor | Rafael Almeida | Data | 30.06.2015    |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para excluir os registros.      				   |
//+--------------------------------------------------------------------+
//| Uso | PA21_CTCON36 - ATIVO FIXO.                                   |
//+--------------------------------------------------------------------+
Static Function Mod2GrvE()

Local nI := 0

	dbSelectArea("ZTT")
		For nI := 1 To Len( aCOLS )
			dbGoTo(aREG[nI])
				RecLock("ZTT",.F.)
					dbDelete()
				MsUnLock()
		Next nI
Return     


//+--------------------------------------------------------------------+
//| Rotina | Mod2GrvA  | Autor | Rafael Almeida | Data | 30.06.2015    |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para gravar os dados na alteração.                 |
//+--------------------------------------------------------------------+
//| Uso | PA21_CTCON36 - ATIVO FIXO.                                   |
//+--------------------------------------------------------------------+
Static Function Mod2GrvA(cCodigo,cDescGrp)

Local aArea := GetArea()
Local nI := 0
Local nX := 0

	dbSelectArea("ZTT")
		For nI := 1 To Len( aREG )
			If nI <= Len( aREG )
				dbGoTo( aREG[nI] )
				RecLock("ZTT",.F.)
					If aCOLS[nI, Len(aHeader)+1]
						dbDelete()
					Endif
			Else
				RecLock("ZTT",.T.)
			Endif
			
			If !aCOLS[nI, Len(aHeader)+1]
				ZTT->ZTT_FILIAL    := xFilial("ZTT")
				ZTT->ZTT_GRPUSR    := cCodigo			
				ZTT->ZTT_DESCGRP   := cDescGrp				
				For nX := 1 To Len( aHeader )
					FieldPut( FieldPos( aHeader[nX, 2] ), aCOLS[nI, nX] )
				Next nX
			Endif
			MsUnLock()
		Next nI 		
RestArea( aArea )
Return                                           


//+--------------------------------------------------------------------+
//| Rotina | Mod2Vend | Autor | Robson Luiz (rleg) | Data | 01.01.2007 |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para validar o código do vendedor. |
//+--------------------------------------------------------------------+
//| Uso | Para treinamento e capacitação. |
//+--------------------------------------------------------------------+
Static Function Mod2Grp( cCodigo, cDescGrp )
Local aGrpUsr := AllGroups()
Local _t
            
	For _t :=1 to len(aGrpUsr)			
		if Alltrim(cCodigo) ==  Alltrim(aGrpUsr[_t][1][1])
			cDescGrp := Alltrim(aGrpUsr[_t][1][2])
		Endif
	Next _t   

Return(!Empty(cDescGrp))



User Function ZZTFastFilter()
Local cGrupo :=  UsrRetGrp(RetCodUsr())

Conout("TESTE")

Return(nil)