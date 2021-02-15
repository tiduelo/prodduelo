//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณZDDVldUsr     บAutor  ณRafael Almeida  บ Data ณ  10/11/19   บฑฑ
ฑฑ                                                                         ฑฑ
อออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออออออฯออออนฑฑ
ฑฑบDesc.     ณFun็oes Autentica็ao do Aprovador.                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Duelo                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ZDDVldUsr(_cAlias,_cCampo,_cContNew,_cContAntig)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Declaracao de Variaveis                                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Local _aArea:= GetArea() //guarda a แrea para restaura็ใo
	Local cCodigo   := Space(30)
	Local _cSenha    := Space(30)
	Local _cAprov   := Space(6)
	Local lAutoriza := .F.
	Local _lRet     := .T.
	Local nOpca     := 0
	Local _lAprBlq  := .F.
	Local _cSolict  := RetCodUsr()
	Local _cNomTab := ""
	Local _cReg := Recno()

	If ALTERA
		If _cContNew <> _cContAntig

			DEFINE MSDIALOG oDlgSenha TITLE "Autoriza็ใo" From 001,001 to 125,300 Pixel STYLE DS_MODALFRAME

			oSaySenha := tSay():New(012,010,{|| "Usuแrio:"   },oDlgSenha,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
			oGetSenha := tGet():New(010,050,{|u| if(PCount()>0,cCodigo:=u,cCodigo)}, oDlgSenha,080,9,"@A",{ ||  },,,,,,.T.,,, { || .T. } ,,,,.F.,,,'cCodigo')

			oSaySenha := tSay():New(022,010,{|| "Digite a senha:"   },oDlgSenha,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
			oGetSenha := tGet():New(020,050,{|u| if(PCount()>0,_cSenha:=u,_cSenha)}, oDlgSenha,080,9,"@A",{ ||  },,,,,,.T.,,, { || .T. } ,,,,.F.,.T.,,'_cSenha')

			oBtnOk := tButton():New(040,035,"Ok"  , oDlgSenha, {|| nOpca := 1, ::End() },40,12,,,,.T.,,,, { ||  },,)
			oBtnNo := tButton():New(040,080,"Cancelar"  , oDlgSenha, {|| ::End() },40,12,,,,.T.,,,, { || .F.  },,)

			ACTIVATE MSDIALOG oDlgSenha CENTERED   VALID (!Empty(cCodigo) .Or. !Empty(_cSenha))

			If nOpca == 1

				If Select("ZDD")>0
					DbSelectArea("ZDD")
					DbCloseArea("ZDD")
				EndIf
				_cAprov := Space(6)

				PswOrder(2)
				If PswSeek( cCodigo, .T. )
					_cAprov := PswID()
				EndIf

				dbSelectArea("ZDD")
				dbSetOrder(1)
				dbGoTop()
				If dbSeek(xFilial("ZDD")+_cAprov)
					_cNomTab := X2Nome()

					If ZDD->ZDD_STATUS == .T.
						PswOrder(1)
						If PswSeek(ZDD->ZDD_USER)
							lAutoriza := PswName(_cSenha)
						EndIf
					Else
						_lAprBlq := .T.
					EndIf
					cCodigo := Space(30)
					_cSenha  := Space(30)
				EndIf
				ZDD->(DbCloseArea())
			Endif

			If _lAprBlq
				MsgStop("Aprovador Bloqueado!","SEM PERMISSรO")
				_lRet := .F.
			ElseIf !lAutoriza .And. nOpca == 1
				MsgStop("Usuแrio e/ou senha invแlidos!","SEM PERMISSรO")
				_lRet := .F.
			ElseIf lAutoriza .And. nOpca == 1
				_cMotivo := _fInfMot()
				fGrvLogZDE(_cAlias,_cCampo,_cContNew,_cContAntig,_cSolict,_cAprov,_cMotivo,_cNomTab,_cReg)
				MsgInfo("Iniciando grava็ใo de LOG!","LOG GRAVADO")
				_lRet := .T.
			EndIf
		EndIf
	EndIf
	RestArea(_aArea) //restaura o ambiente anterior ao gatilho
Return _lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_fInfMot    บAutor  ณRafael Almeida  บ Data ณ  10/11/19   บฑฑ
ฑฑ                                                                         ฑฑ
อออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออออออฯออออนฑฑ
ฑฑบDesc.     ณFun็oes que captura o motivo da alter็ใo.                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Duelo                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function _fInfMot()

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Declaracao de Variaveis                                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Local oFont1 := TFont():New("MS Sans Serif",,022,,.T.,,,,,.F.,.F.)
	Local oGroup1
	Local oMultiGe1
	Local cMultiGe1 := ""
	Local _MotText :=  ""
	Local oSButton1
	Local oSButton2
	lOCAL nOpcao := 0
	Static oDlg


	DEFINE MSDIALOG oDlg TITLE "MOTIVO DA ALTERAวรO" FROM 000, 000  TO 290, 500 COLORS 0, 16777215 PIXEL

	@ 007, 005 GROUP oGroup1 TO 114, 245 PROMPT "INFORME" OF oDlg COLOR 16711680, 16777215 PIXEL
	DEFINE SBUTTON oSButton1 FROM 125, 216 TYPE 02 ACTION (nOpcao := 1, oDlg:End()) OF oDlg ENABLE
	DEFINE SBUTTON oSButton2 FROM 125, 178 TYPE 01 ACTION (nOpcao := 0, oDlg:End()) OF oDlg ENABLE
	@ 023, 011 GET oMultiGe1 VAR cMultiGe1 VALID !Empty(cMultiGe1)  OF oDlg MULTILINE SIZE 224, 079 COLORS 0, 16777215 HSCROLL PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED VALID !Empty(cMultiGe1)

	If nOpcao == 1
		If !Empty(cMultiGe1)
			Conout("OK")
		EndIf
	Endif

Return (cMultiGe1)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfGrvLogZDE    บAutor  ณRafael Almeida  บ Data ณ  10/11/19   บฑฑ
ฑฑ                                                                         ฑฑ
อออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออออออฯออออนฑฑ
ฑฑบDesc.     ณFun็oes Grava log de altera็ใo de conteudo de campo.        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Duelo                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fGrvLogZDE(_cTab,_Camp,_NewCont, _AntCont,_cCodSolic,_cCodAprov,_cTxt,_cDesTab,_cRecno)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Declaracao de Variaveis                                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Local lRet := .F.
	Local _cTxtAreac := ""
	Local _cNovoCtdc := ""
	Local _cAntgCtdc := ""
	Local _cChave := ""
	Local _aVetChv := {}
	Local _cAuxc := ""
	Local _cAuxc2 := ""	
	Local _nPIni  := 0
	Local _nPos   := 0
	Local _RgAlt  := ""
	Local _nReg  := 1


	If ValType(_AntCont) == "C"
		_cNovoCtdc := _NewCont
		_cAntgCtdc := _AntCont
	ElseIf ValType(_AntCont) == "N"
		_cNovoCtdc := TransForm(_NewCont,X3Picture(_Camp)) 
		_cAntgCtdc := TransForm(_AntCont,X3Picture(_Camp)) 
	ElseIf ValType(_AntCont) == "D"
		_cNovoCtdc := DtoC(_NewCont)
		_cAntgCtdc := DtoC(_AntCont)
	ElseIf  ValType(_AntCont) == "M"
		_cNovoCtdc := _NewCont
		_cAntgCtdc := _AntCont
	Else
		_cNovoCtdc := TransForm(_NewCont,X3Picture(_Camp)) 
		_cAntgCtdc := TransForm(_AntCont,X3Picture(_Camp)) 		 
	EndIf

	dbSelectArea(_cTab)
	DbSetOrder(1)

	_cChave := IndexKey(IndexOrd())
	_cReg   :=  StrTran(_cChave,"+",",")
	_cAuxc  :=  _cChave
	_cAuxc2  := _cAuxc


	_cQry :=" "
	_cQry +=" SELECT " + _cChave  + " AS CHAVE "
	_cQry +="  FROM "+RetSqlName(_cTab)+ " "
	_cQry +=" WHERE D_E_L_E_T_ =  ''	" 
	_cQry +=" AND R_E_C_N_O_ = '" + cValToChar(Recno()) +"' "
	_cQry := ChangeQuery(_cQry)
	DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQry), "TMPLOG", .T., .T.)


	DbSelectArea("TMPLOG")
	TMPLOG->(DbGoTop())

	Do While !TMPLOG->(Eof())
		_RgAlt += TMPLOG->CHAVE 
		TMPLOG->(dbSkip())
	Enddo
	TMPLOG->(DBCLOSEAREA())




	/*
	For _nE := 1 To Len(_cChave)  
	_nPos  := AT( "+", _cAuxc2 )
	If _nPos > 0		
	_cAuxc2 := SubStr(_cAuxc2, (_nPos + 1) )		 		
	_nReg+= 1
	EndIf		
	Next _nE

	_cAuxc2 := _cAuxc	

	For _nI := 1 To _nReg
	_nPos  := AT( "+", _cAuxc2 )
	If _nPos > 0		
	_cAuxc  := SubStr(_cAuxc2, 1, ( _nPos -1 ) )
	_cAuxc2 := SubStr(_cAuxc2, (_nPos + 1) )		 		
	AAdd(_aVetChv,_cAuxc)
	Else
	AAdd(_aVetChv,_cAuxc2)
	EndIf		
	Next _nI

	For _nJ := 1 To Len(_aVetChv)
	_RgAlt += GetAdvFVal(_cTab,_aVetChv[_nJ][1],xFilial(_cTab)+_cChave,1) + " - "
	Next _nJ   
	*/	





	_cTxtAreac := "Chave do Registro Alterado = " + Alltrim(_cChave) + Chr(13) + Chr(10)
	_cTxtAreac += "Registro Alterado          = " + _RgAlt + Chr(13) + Chr(10)	
	_cTxtAreac += Chr(13) + Chr(10)
	_cTxtAreac += "-----------------------------" + Chr(13) + Chr(10)
	_cTxtAreac += "Altera็ใo Solicitada = " + Alltrim(UsrFullName(_cCodSolic)) + Chr(13) + Chr(10)
	_cTxtAreac += "Altera็ใoAADMIN	 Aprovada   = " + Alltrim(UsrFullName(_cCodAprov)) + Chr(13) + Chr(10)	
	_cTxtAreac += Chr(13) + Chr(10)
	_cTxtAreac += "-----------------------------" + Chr(13) + Chr(10)	 
	_cTxtAreac += "Conteudo Anterior = " + Alltrim(_cAntgCtdc) + Chr(13) + Chr(10) 
	_cTxtAreac += Chr(13) + Chr(10)
	_cTxtAreac += "-----------------------------" + Chr(13) + Chr(10)
	_cTxtAreac += "Conteudo Atual    = " + Alltrim(_cNovoCtdc) + Chr(13) + Chr(10)
	_cTxtAreac += "-----------------------------" + Chr(13) + Chr(10)
	_cTxtAreac += Chr(13) + Chr(10)	
	_cTxtAreac += "Motivo = " + Chr(13) + Chr(10)
	_cTxtAreac += Alltrim(_cTxt)

	Begin Transaction

		DBSelectArea("ZDE")
		RecLock("ZDE",.T.)
		ZDE->ZDE_FILIAL := xFilial("ZDD")
		ZDE->ZDE_DATA   := Date()
		ZDE->ZDE_TIME   := Time()
		ZDE->ZDE_SOLICT := _cCodSolic
		ZDE->ZDE_IP     :=  GetClientIP()
		ZDE->ZDE_PC     := ComputerName()
		ZDE->ZDE_USEWIN := LogUserName()
		ZDE->ZDE_MOTIVO := _cTxtAreac
		ZDE->ZDE_ALIAS  := _cTab
		ZDE->ZDE_NAMTAB := _cDesTab
		ZDE->ZDE_RECUPD := cValToChar(_cRecno)
		ZDE->ZDE_CAMPO  := _Camp
		//ZDE->ZDE_CTDNEW := _NewCont
		//ZDE->ZDE_CTDANT := _AntCont
		ZDE->ZDE_APROVD :=  _cCodAprov
		ZDE->ZDE_ORIGEM := FunName()

		MSUnlock()

		lRet := .T.

	End Transaction

	If !lRet
		MsgStop("Erro durante a Grava็ใo do LOG!","E R R O")
	EndIf

Return(lRet)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVLDCADZDD     บAutor  ณRafael Almeida  บ Data ณ  10/11/19   บฑฑ
ฑฑ                                                                         ฑฑ
อออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออออออฯออออนฑฑ
ฑฑบDesc.     ณFun็oes Valida Perfil de Administrador.                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Duelo                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function  VLDCADZDD()

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Declaracao de Variaveis                                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	Local _lRet := .T.
	Local _cCodUsr := RetCodUsr ( )
	Local _cUsrAdm :=  GETNEWPAR("US_USERADM", "000000/000594/")

	If Alltrim(_cCodUsr) $ Alltrim(_cUsrAdm)
		U_CADZDD()
	Else
		MsgAlert("Perfil de Administrador ้ necessแrio","SEM PERMISSรO")
	EndIf


Return _lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCADZDD        บAutor  ณRafael Almeida  บ Data ณ  10/11/19   บฑฑ
ฑฑ                                                                          ฑฑ
อออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออออออฯออออนฑฑ
ฑฑบDesc.     ณFun็oes Cadastro de Usuแrios Aprovadores.                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Duelo                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CADZDE()
	Private cCadastro := " Log de Processo"
	Private aRotina := {{"Pesquisar"  , "AxPesqui" , 0, 1},;
	{"Visualizar" , "AxVisual" , 0, 2},;
	{"Aprovadores" , "U_VLDCADZDD" , 0, 3}}

	DbSelectArea("ZDE")
	DbSetOrder(1)

	MBrowse(6,1,22,75,"ZDE",,,,,,)

Return (.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCADZDD        บAutor  ณRafael Almeida  บ Data ณ  10/11/19   บฑฑ
ฑฑ                                                                          ฑฑ
อออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออออออฯออออนฑฑ
ฑฑบDesc.     ณFun็oes Cadastro de Usuแrios Aprovadores.                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Duelo                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CADZDD()
	Private cCadastro := " Aprovadores Log de Altera็ใo"
	Private aRotina := {{"Pesquisar"  , "AxPesqui" , 0, 1},;
	{"Visualizar" , "AxVisual" , 0, 2},;
	{"Incluir"    , "AxInclui" , 0, 3},;
	{"Alterar"    , "AxAltera" , 0, 4},;
	{"Excluir"    , "AxDeleta" , 0, 5}}

	DbSelectArea("ZDD")
	DbSetOrder(1)

	MBrowse(6,1,22,75,"ZDD",,,,,,)

Return (.T.)
