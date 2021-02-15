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
USER FUNCTION MkBrwSA1()
Local aCpos := {}
Local aCampos := {}
Local nI := 0
Local cAlias   := "SA1"
Private cFiltra := "A1_FILIAL == '"+xFilial("SA1")+"' .And. A1_MSBLQL <> '1'"
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
AADD(aRotina,{"Roteirização" ,"U_VisLote" ,0,3})

/*
AADD(aRotina,{"Incluir" ,"AxInclui" ,0,3})
AADD(aRotina,{"Alterar" ,"AxAltera" ,0,4})
AADD(aRotina,{"Excluir" ,"AxDeleta" ,0,5})
*/
AADD(aCpos, "A1_OK" )
AADD(aCpos, "A1_FILIAL" )
AADD(aCpos, "A1_COD" )
AADD(aCpos, "A1_LOJA" )
AADD(aCpos, "A1_VEND" )
AADD(aCpos, "A1_ROTA" )
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
MarkBrow(cAlias,aCpos[1],"A1_TIPO == ' '",aCampos,.F.,GetMark(,"SA1","A1_OK"))  

EndFilBrw(cAlias,aIndexSA1)
Return Nil  

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


/*/
+-----------------------------------------------------------------------------
| Programa | VisLote() | Autor | ARNALDO RAYMUNDO JR. | Data | |
+-----------------------------------------------------------------------------
| Desc. | Função utilizada para demonstrar o uso do recurso da MarkBrowse|
+-----------------------------------------------------------------------------
| Uso | Curso de ADVPL |
+-----------------------------------------------------------------------------
/*/
USER FUNCTION VisLote()      
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
Local cGet3 := Space(40)
Local oGet4
Local cGet4 := Space(4)
Local oRadMenu1
Local nRadMenu1 := 0
Local _cSeqDA7  := ""
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
Private nOpca := .F.
Static oDlg

DbSelectArea("SA1")
DbGoTop()

While SA1->(!EOF())
	// IsMark("A1_OK", cMarca, lInverte)
	IF SA1->A1_OK == cMarca .AND. !lInvert
		AADD(aRecSel,{SA1->(Recno()),SA1->A1_COD, SA1->A1_LOJA, SA1->A1_VEND, SA1->A1_ROTA})
	ELSEIF SA1->A1_OK != cMarca .AND. lInvert
		AADD(aRecSel,{SA1->(Recno()),SA1->A1_COD, SA1->A1_LOJA, SA1->A1_VEND, SA1->A1_ROTA})
	ENDIF
	SA1->(dbSkip())
Enddo

IF Len(aRecSel) > 0
	
	DEFINE MSDIALOG oDlg TITLE "Roteirização Cliente" FROM 000, 000  TO 330, 700 COLORS 0, 16777215 PIXEL
	
	@ 002, 001 GROUP oGroup1 TO 149, 349 OF oDlg COLOR 0, 16777215 PIXEL
	@ 014, 004 SAY oSay1 PROMPT "Essa rotina ira realizar a troca das rotas ou dos vendedores para os clientes, afim de agilizar" SIZE 339, 012 OF oDlg FONT oFont1 COLORS 16711680, 16777215 PIXEL
	@ 025, 004 SAY oSay2 PROMPT "a manutenção da roteirização." SIZE 237, 010 OF oDlg FONT oFont1 COLORS 16711680, 16777215 PIXEL
	@ 041, 004 GROUP oGroup2 TO 088, 343 OF oDlg COLOR 0, 16777215 PIXEL
	@ 048, 007 SAY oSay3 PROMPT "Código Vendedor:" SIZE 067, 010 OF oDlg FONT oFont2 COLORS 255, 16777215 PIXEL
	@ 048, 122 SAY oSay4 PROMPT "Código Rota:" SIZE 046, 009 OF oDlg FONT oFont2 COLORS 255, 16777215 PIXEL
	@ 048, 232 SAY oSay6 PROMPT "Código Zona:" SIZE 067, 009 OF oDlg FONT oFont2 COLORS 255, 16777215 PIXEL	
	@ 071, 007 SAY oSay5 PROMPT "Nome Vendedor:" SIZE 061, 007 OF oDlg FONT oFont2 COLORS 255, 16777215 PIXEL
	@ 047, 071 MSGET oGet1 VAR cGet1 F3 "SA3ROT" SIZE 043, 011 VALID (U_lVldVend(cGet1) .And. !Empty(cGet1)) OF oDlg COLORS 0, 16777215 PIXEL
	@ 047, 170 MSGET oGet2 VAR cGet2  SIZE 056, 011 VALID (U_lVldRota(cGet1,cGet2))OF oDlg COLORS 0, 16777215 PIXEL
	@ 047, 280 MSGET oGet4 VAR cGet4  SIZE 056, 011 VALID (U_lVldZona(cGet1,cGet2,cGet4))OF oDlg COLORS 0, 16777215 PIXEL	
	@ 071, 070 MSGET oGet3 VAR cGet3 := SubStr(GetAdvFVal("SA3", "A3_NOME",xFilial("SA3")+cGet1,1),1,30)SIZE 265, 011 OF oDlg COLORS 0, 16777215 PIXEL When .F.
	@ 091, 004 GROUP oGroup3 TO 145, 344 PROMPT "  Atualizar  " OF oDlg COLOR 16711680, 16777215 PIXEL
	@ 103, 023 RADIO oRadMenu1 VAR nRadMenu1 ITEMS "&Vendedor","&Rota","&Vende && Rota","&Zona && Vende && Rota" SIZE 103, 027  OF oDlg COLOR 255, 16777215 PIXEL
	DEFINE SBUTTON oSButton1 FROM 152, 290 TYPE 01 ACTION (nOpca := .T.,oDlg:End()) OF oDlg ENABLE
	DEFINE SBUTTON oSButton2 FROM 152, 318 TYPE 02 ACTION (nOpca := .F.,oDlg:End()) OF oDlg ENABLE
	
	
	ACTIVATE MSDIALOG oDlg CENTERED VALID U_lVldOpc(nRadMenu1)
	
	
	If nOpca
		For nX := 1 	to Len(aRecSel)
			_ZonA := GetAdvFVal("DA5", "DA5_COD",xFilial("DA5")+aRecSel[nX][4],2)
			_RotA := GetAdvFVal("DA7", "DA7_ROTA",xFilial("DA7")+aRecSel[nX][2]+aRecSel[nX][3]+_ZonA+aRecSel[nX][5],2)			
			
			If nRadMenu1 == 1
				dbSelectArea("SA1")
				dbSetOrder(1)
				If dbSeek(xFilial("SA1") + aRecSel[nX][2]  + aRecSel[nX][3] )
					RECLOCK("SA1",.F.)
					SA1->A1_VEND   := cGet1
					MSUNLOCK()
				EndIf
				SA1->(DBCLOSEAREA())			
				
			ElseIf	nRadMenu1 == 2
				cQry := " "
				cQry += " 	SELECT TOP 1	"
				cQry += " 		REPLICATE('0', 6-LEN(CONVERT(INT, DA7_SEQUEN) ))+ CONVERT(NVARCHAR(6),(CONVERT(INT, DA7_SEQUEN)+1)) AS SQDA7	"
				cQry += " 	FROM "+ RETSQLNAME("DA7")+"  "
				cQry += " 	WHERE D_E_L_E_T_ = ''	"  
				cQry += " 		AND DA7_FILIAL = '"+xfilial("DA7")  +"' "
				cQry += " 		AND DA7_ROTA   = '"+ Alltrim(cGet2) +"'	"
				cQry += " 		AND DA7_PERCUR = '"+ Alltrim(_ZonA) +"'	"
				cQry += " 	ORDER BY DA7_FILIAL, DA7_PERCUR, DA7_ROTA, DA7_SEQUEN DESC	"	
				cQry:= ChangeQuery(cQry)
				dbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQry) , "TOC" , .T. , .F.)
				
				DBSelectArea("TOC")
				TOC->(DbGoTop())  
				While !TOC->(Eof())
					_cSeqDA7 := TOC->SQDA7
					TOC->(DbSkip())
				EndDo
				TOC->( DBCloseArea())
				
				
				dbSelectArea("SA1")
				dbSetOrder(1)
				If dbSeek(xFilial("SA1") + aRecSel[nX][2]  + aRecSel[nX][3] )
					RECLOCK("SA1",.F.)
					SA1->A1_ROTA   := cGet2
					MSUNLOCK()
				EndIf
				
				dbSelectArea("DA7")
				dbSetOrder(2)
				If dbSeek(xFilial("DA7") + aRecSel[nX][2]  + aRecSel[nX][3] + _ZonA + _RotA )								
					RECLOCK("DA7",.F.)
					DA7->DA7_ROTA   := cGet2
					DA7->DA7_SEQUEN := Iif(Empty(_cSeqDA7),"000001",_cSeqDA7)
					MSUNLOCK()
				EndIf
				DA7->(DBCLOSEAREA())
				SA1->(DBCLOSEAREA())				
				
			ElseIf	nRadMenu1 == 3			
				cQry := " "
				cQry += " 	SELECT TOP 1	"
				cQry += " 		REPLICATE('0', 6-LEN(CONVERT(INT, DA7_SEQUEN) ))+ CONVERT(NVARCHAR(6),(CONVERT(INT, DA7_SEQUEN)+1)) AS SQDA7	"
				cQry += " 	FROM "+ RETSQLNAME("DA7")+"  "
				cQry += " 	WHERE D_E_L_E_T_ = ''	"  
				cQry += " 		AND DA7_FILIAL = '"+xfilial("DA7")  +"' "
				cQry += " 		AND DA7_ROTA   = '"+ Alltrim(cGet2) +"'	"
				cQry += " 		AND DA7_PERCUR = '"+ Alltrim(_ZonA) +"'	"
				cQry += " 	ORDER BY DA7_FILIAL, DA7_PERCUR, DA7_ROTA, DA7_SEQUEN DESC	"	
				cQry:= ChangeQuery(cQry)
				dbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQry) , "TOC" , .T. , .F.)
				
				DBSelectArea("TOC")
				TOC->(DbGoTop())  
				While !TOC->(Eof())
					_cSeqDA7 := TOC->SQDA7
					TOC->(DbSkip())
				EndDo
				TOC->( DBCloseArea())
				
							
				dbSelectArea("SA1")
				dbSetOrder(1)
				If dbSeek(xFilial("SA1") + aRecSel[nX][2]  + aRecSel[nX][3] )
					RECLOCK("SA1",.F.)
					SA1->A1_ROTA   := cGet2
					SA1->A1_VEND   := cGet1					
					MSUNLOCK()
				EndIf
				SA1->(DBCLOSEAREA())				
				dbSelectArea("DA7")
				dbSetOrder(2)
				If dbSeek(xFilial("DA7") + aRecSel[nX][2]  + aRecSel[nX][3] + _ZonA + _RotA )
					RECLOCK("DA7",.F.)
					DA7->DA7_ROTA   := cGet2
					DA7->DA7_SEQUEN := Iif(Empty(_cSeqDA7),"000001",_cSeqDA7)
					MSUNLOCK()
				EndIf
				DA7->(DBCLOSEAREA())				
				
			ElseIf	nRadMenu1 == 4				
				cQry := " "
				cQry += " 	SELECT TOP 1	"
				cQry += " 		REPLICATE('0', 6-LEN(CONVERT(INT, DA7_SEQUEN) ))+ CONVERT(NVARCHAR(6),(CONVERT(INT, DA7_SEQUEN)+1)) AS SQDA7	"
				cQry += " 	FROM "+ RETSQLNAME("DA7")+"  "
				cQry += " 	WHERE D_E_L_E_T_ = ''	"  
				cQry += " 		AND DA7_FILIAL = '"+xfilial("DA7")  +"' "
				cQry += " 		AND DA7_ROTA   = '"+ Alltrim(cGet2) +"'	"
				cQry += " 		AND DA7_PERCUR = '"+ Alltrim(cGet4) +"'	"
				cQry += " 	ORDER BY DA7_FILIAL, DA7_PERCUR, DA7_ROTA, DA7_SEQUEN DESC	"	
				cQry:= ChangeQuery(cQry)
				dbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQry) , "TOC" , .T. , .F.)
				
				DBSelectArea("TOC")
				TOC->(DbGoTop())  
				While !TOC->(Eof())
					_cSeqDA7 := TOC->SQDA7
					TOC->(DbSkip())
				EndDo
				TOC->( DBCloseArea())
				
							
				dbSelectArea("SA1")
				dbSetOrder(1)
				If dbSeek(xFilial("SA1") + aRecSel[nX][2]  + aRecSel[nX][3] )
					RECLOCK("SA1",.F.)
					SA1->A1_ROTA   := cGet2
					SA1->A1_VEND   := cGet1					
					MSUNLOCK()
				EndIf
				SA1->(DBCLOSEAREA())				
				dbSelectArea("DA7")
				dbSetOrder(2)
				If dbSeek(xFilial("DA7") + aRecSel[nX][2]  + aRecSel[nX][3] + _ZonA + _RotA )
					RECLOCK("DA7",.F.)
					DA7->DA7_PERCUR := cGet4
					DA7->DA7_ROTA   := cGet2
					DA7->DA7_SEQUEN := Iif(Empty(_cSeqDA7),"000001",_cSeqDA7)
					MSUNLOCK()
				EndIf
				DA7->(DBCLOSEAREA())				
								
			EndIf
		Next nX
	EndIf
	_RotA := ""
	_ZonA := ""  
	_cSeqDA7 := ""
	cGet1 := Space(6)
	cGet2 := Space(4)
	cGet3 := Space(40)
	cGet4 := Space(4)
	nRadMenu1 := 0	
	LimpaMarca()
	aRecSel :={}	
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
User Function lVldOpc(_nOpcRd)
Local lRet := .F.

If _nOpcRd > 0
	lRet := .T.
Else
	MsgAlert("Selecione uma das Opções de atualização... ","A T E N Ç Ã O")
EndIF

Return(lRet)

/*/
+-----------------------------------------------------------------------------
| Programa | LimpaMarca | Autor | ARNALDO RAYMUNDO JR. | Data | |
+-----------------------------------------------------------------------------
| Desc. | Função utilizada para demonstrar o uso do recurso da MarkBrowse|
+-----------------------------------------------------------------------------
| Uso | Curso de ADVPL |
+-----------------------------------------------------------------------------
/*/
User Function lVldVend(_cVend)
Local lRet := .F.

If ExistCpo("DA5", _cVend,2)
	lRet := .T.
Else
	MsgAlert("Atenção! Vendedor não vinculado a uma ZONA de atendimento!","A T E N Ç Ã O")
EndIf

Return(lRet)


/*/
+-----------------------------------------------------------------------------
| Programa | LimpaMarca | Autor | ARNALDO RAYMUNDO JR. | Data | |
+-----------------------------------------------------------------------------
| Desc. | Função utilizada para demonstrar o uso do recurso da MarkBrowse|
+-----------------------------------------------------------------------------
| Uso | Curso de ADVPL |
+-----------------------------------------------------------------------------
/*/
User Function lVldRota(_cVend,_CoRot)
Local _Zona := ""
Local lRet := .F.


_Zona   := GetAdvFVal("DA5", "DA5_COD",xFilial("DA5")+_cVend,2)
If ExistCpo("DA6", _Zona + _CoRot, 1)
	lRet := .T.
ElseIf Empty(_cVend)
	MsgAlert("Atenção! Informar VENDEDOR !!! ","A T E N Ç Ã O")
ElseIf Empty(_CoRot)
	MsgAlert("Atenção! Informar ROTA do Vendedor!!!","A T E N Ç Ã O")
Else
	MsgAlert("Atenção! Esta ROTA não está vinculado a zona do Vendedor!","A T E N Ç Ã O")
EndIf

Return(lRet)



/*/
+-----------------------------------------------------------------------------
| Programa | LimpaMarca | Autor | ARNALDO RAYMUNDO JR. | Data | |
+-----------------------------------------------------------------------------
| Desc. | Função utilizada para demonstrar o uso do recurso da MarkBrowse|
+-----------------------------------------------------------------------------
| Uso | Curso de ADVPL |
+-----------------------------------------------------------------------------
/*/
User Function lVldZona(_cVend,_CoRot,_cCoZon)
Local _cVndd := ""
Local lRet := .F.

_cVndd	:= GetAdvFVal("DA5", "DA5_VENDED",xFilial("DA5")+_cCoZon,1) 


If ExistCpo("DA5", _cCoZon, 1)  .And. _cVndd == _cVend
	lRet := .T.
ElseIf Empty(_cVend)
	MsgAlert("Atenção! Informar VENDEDOR !!! ","A T E N Ç Ã O")
ElseIf Empty(_cCoZon)
	MsgAlert("Atenção! Informar ZONA do Vendedor !!! ","A T E N Ç Ã O")
ElseIf Empty(_CoRot)
	MsgAlert("Atenção! Informar ROTA do Vendedor!!!","A T E N Ç Ã O")
Else
	MsgAlert("Atenção! Esta ZONA não está vinculado ao Vendedor!","A T E N Ç Ã O")
EndIf

Return(lRet)
