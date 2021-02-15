#include "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"
/*/
+-----------------------------------------------------------------------------
| Programa | MkBrwSA1 | Autor | ARNALDO RAYMUNDO JR. | Data | |
+-----------------------------------------------------------------------------
| Desc. | MarkBrowse Genérico |
+-----------------------------------------------------------------------------
| Uso | Curso de ADVPL |
+-----------------------------------------------------------------------------
/*/
USER FUNCTION SA1BLOQ()
Local aCpos := {}
Local aCampos := {}
Local nI := 0
Local cAlias   := "SA1"
Private cFiltra := "A1_FILIAL == '"+xFilial("SA1")+"' .And. A1_MSBLQL <> '1'   .And. A1_SALDUP = 0    "
Private aRotina:={}
Private cCadastro:="Cadastro de Clientes"
Private aRecSel:={}
Private aIndexSA1 := {}
//Private bFiltraBrw:={||FilBrowse(cAlias,@aIndexSA1,@cFiltra)}  
PRIVATE bFiltraBrw := {|| Nil}
PRIVATE bEndFilBrw := {|| EndFilBrw("SA1",aIndexSA1),aIndexSA1:={}}


//AADD(aRotina,{"Filtar" ,"U_FiltVend" ,0,0})
AADD(aRotina,{"Pesquisar" ,"PesqBrw" ,0,0})
AADD(aRotina,{"Visualizar" ,"A030Visual" ,0,2})
AADD(aRotina,{"Blouqear" ,"U_BloqSA1" ,0,3})

/*
AADD(aRotina,{"Incluir" ,"AxInclui" ,0,3})
AADD(aRotina,{"Alterar" ,"AxAltera" ,0,4})
AADD(aRotina,{"Excluir" ,"AxDeleta" ,0,5})
*/
AADD(aCpos, "A1_OK" )
AADD(aCpos, "A1_FILIAL" )
AADD(aCpos, "A1_COD" )
AADD(aCpos, "A1_LOJA" )
AADD(aCpos, "A1_PRF_OBS" )
AADD(aCpos, "A1_TIPO" )
dbSelectArea("SX3")
dbSetOrder(2)
For nI := 1 To Len(aCpos)
	IF dbSeek(aCpos[nI])
		AADD(aCampos,{X3_CAMPO,"",IIF(nI==1,"",Trim(X3_TITULO)),;
		Trim(X3_PICTURE)})
	ENDIF
Next

DbSelectArea(cAlias)
DbSetOrder(1)     
Eval(bFiltraBrw)
     

DbSelectArea(cAlias)
DbGoTop()
MarkBrow(cAlias,    aCpos[1],"",aCampos,.F.,GetMark(,"SA1","A1_OK"),,,,,,,,,) 
//MarkBrow( "SE2","E2_ZZMARCA","",aCampos,.F.,GetMark(,"SE2","E2_ZZMARCA"),,,,,,,,,)

EndFilBrw(cAlias,aIndexSA1)
Return Nil  
/*
User Function FiltVend(cAlias)

Local aArea    := GetArea()
Local _cOldFil := cFiltra //Eval(bFiltraBrw,1)[1]
Local cFiltro 

(cAlias)->(dbClearFilter())
cFiltro := FilterExpr(cAlias)
Eval(bFiltraBrw)

dbSelectArea(cAlias)
If ( Empty(cFiltro) )
	cFiltro := ".T."	
EndIf

cFiltro := _cOldFil + ".And." + cFiltro
Eval(bFiltraBrw,3,cFiltro)

Eval(bFiltraBrw)
RestArea(aArea)

Return(.T.)
*/

/*/
+-----------------------------------------------------------------------------
| Programa | BloqSA1() | Autor | ARNALDO RAYMUNDO JR. | Data | |
+-----------------------------------------------------------------------------
| Desc. | Função utilizada para demonstrar o uso do recurso da MarkBrowse|
+-----------------------------------------------------------------------------
| Uso | Curso de ADVPL |
+-----------------------------------------------------------------------------
/*/
USER FUNCTION BloqSA1()      
Local aArea := GetArea()
Local cMarca := ThisMark()
Local nX := 0
Local lInvert := ThisInv()
Local cTexto := ""
Local cEOL := CHR(10)+CHR(13)
Local oDlg
Local oMemo
Local oCheckBo1
Local lCheckBo1 := .F.
Local oCheckBo2
Local lCheckBo2 := .F.
Local oCheckBo3
Local lCheckBo3 := .F.
Local oFont1 := TFont():New("MS Sans Serif",,018,,.T.,,,,,.F.,.F.)
Local oFont2 := TFont():New("MS Sans Serif",,018,,.T.,,,,,.F.,.F.)
Local oGet1
Local cGet1 := Space(6)
Local oGet2
Local cGet2 := Space(4)
Local oGet3
Local cGet3 := Space(150)
Local oGet4
Local cGet4 := Space(4)
Local oRadMenu1
Local nRadMenu1 := 0
Local _cSeqDA7  := "" 
Local _cObsPerfil := ""
Local oGroup1
Local oGroup2
Local oGroup3
Local oSay1
Local oSay2
Local oSay3
Local oSay4
Local oSay6
Local oSay5
Local oSButton1
Local oSButton2
Local _cTexto := ""
Local cEOL := CHR(10)+CHR(13)
Private nOpca := .F.
Static oDlg

DbSelectArea("SA1")
DbGoTop()

While SA1->(!EOF())
	// IsMark("A1_OK", cMarca, lInverte)
	IF SA1->A1_OK == cMarca .AND. !lInvert
			AADD(aRecSel,{SA1->(Recno()),SA1->A1_COD, SA1->A1_LOJA, SA1->A1_PRF_OBS})		
	ELSEIF SA1->A1_OK != cMarca .AND. lInvert
			AADD(aRecSel,{SA1->(Recno()),SA1->A1_COD, SA1->A1_LOJA, SA1->A1_PRF_OBS})
	ENDIF
	SA1->(dbSkip())
Enddo

IF Len(aRecSel) > 0
	
	DEFINE MSDIALOG oDlg TITLE "Bloqueio e desbloqueio de Clientes" FROM 000, 000  TO 330, 700 COLORS 0, 16777215 PIXEL
	
	@ 002, 001 GROUP oGroup1 TO 149, 349 OF oDlg COLOR 0, 16777215 PIXEL
	@ 014, 004 SAY oSay1 PROMPT "Essa rotina ira realizar o bloqueio de Clientes, a fim de agilizar" SIZE 339, 012 OF oDlg FONT oFont1 COLORS 16711680, 16777215 PIXEL
	@ 025, 004 SAY oSay2 PROMPT "a manutenção do cadastro" SIZE 237, 010 OF oDlg FONT oFont1 COLORS 16711680, 16777215 PIXEL	
	@ 041, 004 GROUP oGroup2 TO 088, 343 OF oDlg COLOR 0, 16777215 PIXEL
	@ 048, 007 SAY oSay3 PROMPT "Data Bloqueio:" SIZE 067, 010 OF oDlg FONT oFont2 COLORS 255, 16777215 PIXEL
	@ 047, 071 MSGET oGet1 VAR cGet1 := DtoC(Date()) SIZE 043, 011 OF oDlg COLORS 0, 16777215 PIXEL	 WHEN .F.	
	@ 071, 007 SAY oSay5 PROMPT "Motivo:" SIZE 061, 007 OF oDlg FONT oFont2 COLORS 255, 16777215 PIXEL
	@ 071, 070 MSGET oGet3 VAR cGet3 SIZE 265, 011 VALID !Empty(cGet3) OF oDlg COLORS 0, 16777215 PIXEL 
	@ 091, 004 GROUP oGroup3 TO 145, 344 PROMPT "  Atualizar  " OF oDlg COLOR 16711680, 16777215 PIXEL
	@ 103, 023 RADIO oRadMenu1 VAR nRadMenu1 ITEMS "&Desbloquear","&Bloquear" SIZE 103, 027  OF oDlg COLOR 255, 16777215 PIXEL	
	DEFINE SBUTTON oSButton1 FROM 152, 290 TYPE 01 ACTION (nOpca := .T.,oDlg:End()) OF oDlg ENABLE
	DEFINE SBUTTON oSButton2 FROM 152, 318 TYPE 02 ACTION (nOpca := .F.,oDlg:End()) OF oDlg ENABLE
	
	
	ACTIVATE MSDIALOG oDlg CENTERED  VALID U_VldSA1Opc(nRadMenu1)
	
	
	If nOpca
		For nX := 1 	to Len(aRecSel)
		
		If nRadMenu1 == 2		
				dbSelectArea("SA1")
				dbSetOrder(1)
				If dbSeek(xFilial("SA1") + aRecSel[nX][2]  + aRecSel[nX][3] )
					If SA1->A1_SALDUP > 0    
						_cTexto := "O Clientea baixo não será bloqueado, pois possui titulos em aberto. "+cEOL
						_cTexto += "Cliente: "+aRecSel[nX][2]+"/"+aRecSel[nX][3]+" - "+ GetAdvFVal("SA1", "A1_NOME",xFilial("SA1")+aRecSel[nX][2]  + aRecSel[nX][3],1) + cEOL
						_cTexto += "Valor em aberto: R$ " +   Transform(GetAdvFVal("SA1", "A1_SALDUP",xFilial("SA1")+aRecSel[nX][2]  + aRecSel[nX][3],1),"@E 999,999,999,999.99")       
						MsgBox(_cTexto,"Cliente c/Titulo em aberto","ALERT")
					Else
						_cObsPerfil := SA1->A1_PRF_OBS
						RECLOCK("SA1",.F.)
						SA1->A1_MSBLQL    := "1"
						SA1->A1_PRF_OBS   := Alltrim(cGet1) +" - "+AllTrim(cGet3)+CRLF+Alltrim(_cObsPerfil)
						MSUNLOCK()
					EndIf
				EndIf
		Else
				dbSelectArea("SA1")
				dbSetOrder(1)
				If dbSeek(xFilial("SA1") + aRecSel[nX][2]  + aRecSel[nX][3] )  
				    _cObsPerfil := SA1->A1_PRF_OBS				
					RECLOCK("SA1",.F.)
					SA1->A1_MSBLQL    := "2"
					SA1->A1_PRF_OBS   := Alltrim(cGet1) +" - "+AllTrim(cGet3)+CRLF+Alltrim(_cObsPerfil)
					MSUNLOCK()
				EndIf		
		EndIf
				

		Next nX
	EndIf
	cGet3 := Space(150)
	LimpaMarca()
	aRecSel :={}	
	nRadMenu1 := 0	
	_cObsPerfil := ""
Else
	MsgAlert("Por Favor! Selecione pelo menos um registro...","A T E N Ç Ã O")
EndIf

RestArea(aArea)
RETURN

/*/
+-----------------------------------------------------------------------------
| Programa | LimpaMarca | Autor | ARNALDO RAYMUNDO JR. | Data | |
+-----------------------------------------------------------------------------
| Desc. | Função utilizada para demonstrar o uso do recurso da MarkBrowse|
+-----------------------------------------------------------------------------
| Uso | Curso de ADVPL |
+-----------------------------------------------------------------------------
/*/
STATIC FUNCTION LimpaMarca()
Local nX := 0
For nX := 1 to Len(aRecSel)
	SA1->(DbGoto(aRecSel[nX][1]))
	RecLock("SA1",.F.)
	SA1->A1_OK := SPACE(2)
	MsUnLock()
Next nX
RETURN





/*/
+-----------------------------------------------------------------------------
| Programa | LimpaMarca | Autor | ARNALDO RAYMUNDO JR. | Data | |
+-----------------------------------------------------------------------------
| Desc. | Função utilizada para demonstrar o uso do recurso da MarkBrowse|
+-----------------------------------------------------------------------------
| Uso | Curso de ADVPL |
+-----------------------------------------------------------------------------
/*/
User Function VldSA1Opc(_nOpcRd)
Local lRet := .F.

If _nOpcRd > 0
	lRet := .T.
Else
	MsgAlert("Selecione uma das Opções de atualização... ","A T E N Ç Ã O")
EndIF

Return(lRet)
