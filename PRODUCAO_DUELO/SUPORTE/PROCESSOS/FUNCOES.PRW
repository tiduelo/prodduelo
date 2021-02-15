#include "PROTHEUS.ch"
#include "RWMAKE.ch"
#include "TOPCONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "DBINFO.CH"
#INCLUDE "MSMGADD.CH"
#INCLUDE 'FONT.CH'
// -------------------------------------------------------------------------------------------------------------------- //
// -------------------------------------------------------------------------------------------------------------------- //
// -------------------------------------------------------------------------------------------------------------------- //
///////////////////////////////////
///////////////////////////////////
user function rtcomdep(_cUsuCod,_nTipoCod)
///////////////////////////////////
///////////////////////////////////
Local _cDepCod  := ""
Local _cDepNome := ""

if _nTipoCod == nil
	_nTipoCod := 1
Endif

_cAreexp  := Alias()
_nRecexp  := Recno()
_cIndexp  := IndexOrd()

dbselectarea("SY1") // Compradores

if _nTipoCod == 1 // usa codigo de usuario do sistema
	
	dbsetorder(3)
	
	_lVsIsCom  := .f.
	
	_aVsDep    := {}
	_cVsDep    := ""
	
	_cVsDepsql := ""
	
	
Else                        // usa codigo de comprador para saber os departamentos para relatorios temporarios
	
	dbsetorder(1)
	
	tlVsIsCom  := .f.
	
	taVsDep    := {}
	tcVsDep    := ""
	
	tcVsDepSql := ""
	
	tcVsComCod := ""
	tcVsComNom := ""
	
Endif

dbgotop()

if dbseek(xFilial("SY1")+_cUsuCod,.F.)
	
	if ( alltrim(y1_cod) $ "104,992,46,001,3" )
		_lVsIsDir  := .t.
	Endif
	
	if _nTipoCod == 1
		
		_lVsIsCom  := .t.
		
		_cVsComCod := Y1_COD
		_cVsComNom := Y1_NOME
		
		if ! ( alltrim(y1_cod) $ "104,992,46,001,3" )
			
			dbselectarea("AYJ") // Compradores x Departamentos (categorias)
			dbsetorder(1)
			dbgotop()
			
			Dbseek(xFilial("AYJ")+SY1->Y1_COD+'4',.F.) // Tipo 4 = Departamento
			
			Do While ! eof() .and. AYJ_FILIAL+AYJ_COD+AYJ_TIPO == xFilial("AYJ")+SY1->Y1_COD+'4'
				
				_cDepCod  := padr(AYJ->AYJ_CATEG,8)
				_cDepNome := ""
				
				dbselectarea("AY0") // Categoria (4 - Departamento)
				dbsetorder(1)
				dbgotop()
				
				Dbseek(xFilial("AY0")+_cDepCod,.F.)
				
				Do While ! eof() .and. AY0_FILIAL+AY0_CODIGO == xFilial("AY0")+_cDepCod
					
					if AY0_TIPO == '4'
						_cDepNome := AY0_DESC
						exit
					Endif
					
					dbskip()
					
				Enddo
				
				dbselectarea("AYJ") // Compradores x Departamentos (categorias)
				
				//ALERT(_cDepCod+'-'+_cDepNome+'/'+_cVsComCod+'-'+_cVsComNom)
				
				aadd(_aVsDep, {_cDepCod,_cDepNome,_cVsComCod,_cVsComNom} )
				
				_cVsDep     += ","+alltrim(_cDepCod)
				_cVsDepsql  += ",'"+_cDepCod+"'"
				
				dbskip()
				
			Enddo
			
		Else
			
			dbselectarea("AY0") // Categoria (4 - Departamento)
			dbsetorder(3)
			dbgotop()
			
			Dbseek(xFilial("AY0")+"4",.F.)
			
			Do While ! eof() .and. AY0_FILIAL == xFilial("AY0") .AND. AY0_TIPO == '4'
				
				aadd( _aVsDep, {ay0_codigo,ay0_desc,"000",cUsername} )
				
				_cVsDep     += ","+alltrim(ay0_codigo)
				_cVsDepsql  += ",'"+ay0_codigo+"'"
				
				dbskip()
				
			Enddo
			
		Endif
		
	Else
		
		tlVsIsCom  := .t.
		
		tcVsComCod := Y1_COD
		tcVsComNom := Y1_NOME
		
		taVsDep    := {}
		tcVsDep    := ""
		tcVsDepSql := ""
		
		dbselectarea("AYJ") // Compradores x Departamentos (categorias)
		dbsetorder(1)
		dbgotop()
		
		Dbseek(xFilial("AYJ")+SY1->Y1_COD+'4',.F.) // Tipo 4 = Departamento
		
		Do While ! eof() .and. AYJ_FILIAL+AYJ_COD+AYJ_TIPO == xFilial("AYJ")+SY1->Y1_COD+'4'
			
			_cDepCod  := padr(AYJ->AYJ_CATEG,8)
			_cDepNome := ""
			
			dbselectarea("AY0") // Categoria (4 - Departamento)
			dbsetorder(1)
			dbgotop()
			
			Dbseek(xFilial("AY0")+_cDepCod,.F.)
			
			Do While ! eof() .and. AY0_FILIAL+AY0_CODIGO == xFilial("AY0")+_cDepCod
				
				if AY0_TIPO == '4'
					_cDepNome := AY0_DESC
					exit
				Endif
				
				dbskip()
				
			Enddo
			
			dbselectarea("AYJ") // Compradores x Departamentos (categorias)
			
			aadd(taVsDep, {_cDepCod,_cDepNome,tcVsComCod,tcVsComNom} )
			
			tcVsDep     += ","+alltrim(_cDepCod)
			tcVsDepSql  += ",'"+_cDepCod+"'"
			
			dbskip()
			
		Enddo
		
	Endif
	
Else
	
	dbselectarea("AY0") // Categoria (4 - Departamento)
	dbsetorder(3)
	dbgotop()
	
	Dbseek(xFilial("AY0")+"4",.F.)
	
	Do While ! eof() .and. AY0_FILIAL == xFilial("AY0") .AND. AY0_TIPO == '4'
		
		aadd(_aVsDep, {ay0_codigo,ay0_desc,"000",cUsername} )
		
		_cVsDep     += ","+alltrim(ay0_codigo)
		_cVsDepsql  += ",'"+ay0_codigo+"'"
		
		dbskip()
		
	Enddo
	
Endif

if _nTipoCod == 1
	
	if len(_aVsDep) > 0
		if substr(_cVsDep   ,1,1) == ","
			_cVsDep    := substr(_cVsDep   ,2)
			_cVsDepsql := substr(_cVsDepsql,2)
		Endif
	Endif
	
Else
	
	if len(taVsDep) > 0
		if substr(tcVsDep   ,1,1) == ","
			tcVsDep    := substr(tcVsDep   ,2)
			tcVsDepsql := substr(tcVsDepsql,2)
		Endif
	Endif
	
Endif

dbselectarea(_cAreexp)
dbsetorder(_cIndexp)
dbgoto(_nRecexp)

if _nTipoCod == 1
	return(_aVsDep)
Else
	return(taVsDep)
Endif

// -------------------------------------------------------------------------------------------------------------------- //
// -------------------------------------------------------------------------------------------------------------------- //
// -------------------------------------------------------------------------------------------------------------------- //
///////////////////////////////////
///////////////////////////////////
user function verdir(_cPathLoc)
///////////////////////////////////
///////////////////////////////////
local _cPath := upper( If( Right( alltrim(_cPathLoc),1 ) == "\", Left(alltrim(_cPathLoc), Len(alltrim(_cPathLoc))-1), alltrim(_cPathLoc) ) )
local _aDir  := Directory(_cPath,"D")
Local _x := 0

//   If ( !IsFileServer(_cPath) .and.  .or.

If !File(_cPath) //	If Len(_aDir) == 0
	
	//alert("Precisa Criar a pasta "+_cPath)
	
	_aDir := {}
	_cDir := ""
	
	for _x := 1 to len(_cPath)
		
		if (substr(_cPath,_x,1) == '\' .and. _x > 3) // Verifica se a string \ faz parte do diretorio ignorando (c:\)
			aadd(_aDir,_cDir)
		Endif
		
		_cDir += substr(_cPath,_x,1)
		
		if ( len(_cDir) == len(_cPath) )
			aadd(_aDir,_cDir)
		Endif
	Next
	
	for _x := 1 to len(_aDir)
		
		if len(Directory(_aDir[_x],"D")) == 0
			If MakeDir(_aDir[_x]) <> 0
				Alert("Nao Foi possivel criar o diretorio "+_aDir[_x])
			EndIf
		Endif
		
	Next
	
Else
	//alert("Nao precisa criar")
EndIf

//EndIf

return nil

// -------------------------------------------------------------------------------------------------------------------- //
// -------------------------------------------------------------------------------------------------------------------- //
// -------------------------------------------------------------------------------------------------------------------- //

////////////////////////////////////////////////
////////////////////////////////////////////////
user function convcpo( _chave , _alias , _TamCpo , _tipo , _lstrzero )
////////////////////////////////////////////////
////////////////////////////////////////////////
local _Tabela := space(2)
local _x := 0

if _alias == nil
	_alias := ""
Endif

if _TamCpo == nil
	_TamCpo := 0
Endif


if _lstrzero == nil
	_lstrzero := .f.
Endif

_alias := upper(alltrim(_alias))

if substr(_Alias,1,3) == "SX5"
	_Tabela := substr(_Alias,4,2)
	_Alias  := "SX5"
Endif

if !empty(_chave)
	
	if empty(_TamCpo)
		
		if _Alias == "SM0"
			_TamCpo := len(CriaVar("X5_FILIAL"))
		Elseif _Alias == "SA2"
			_TamCpo := len(CriaVar("A2_COD"))
		Elseif _Alias == "SA1"
			_TamCpo := len(CriaVar("A1_COD"))
		Elseif _Alias == "SED"
			_TamCpo := len(CriaVar("ED_CODIGO"))
		Elseif _Alias == "CTT"
			_TamCpo := len(CriaVar("CTT_CUSTO"))
		Elseif _Alias == "SA6"
			_TamCpo := len(CriaVar("A6_COD"))
		Elseif _Alias == "NUMREF"
			_TamCpo := len(CriaVar("E2_NUMREF"))
		Elseif _Alias == "SC7"
			_TamCpo := len(CriaVar("C7_NUM"))
		Elseif _Alias == "SX5"
			_TamCpo := len(CriaVar("X5_CHAVE"))
		Endif
	Endif
	
	if _tipo == NIL
		_tipo := "A"
		//alert(_tipo)
	Endif
	
	_lProcessa := .t.
	
	if !empty(_Alias)
		
		if len(alltrim(_chave)) <= _TamCpo .and. !( "." $ _chave) .and. !( "," $ _chave) .and. !( "-" $ _chave)  .and. !( ";" $ _chave)
			
			dbselectarea(_Alias)
			dbsetorder(1)
			dbgotop()
			
			if dbseek(xFilial() + iif( _Alias == "SX5", _Tabela, "") + substr(_chave,1,_TamCpo)  ,.f.)
				
				_lProcessa := .f.
				
				if _tipo <> "A"
					_aParam := .T.
				Else
					_aParam := {{substr(_chave,1,_TamCpo) , substr(_chave,1,_TamCpo)}}
				Endif
			Endif
			
		Endif
		
	Endif
	
	//ALERT(&(_tipo))
	
	if _lProcessa
		
		_chave := strtran( _chave , ";" , "," )
		_chave := strtran( _chave , "." , "," )
		_chave := strtran( _chave , "'" , ""  )
		_chave := strtran( _chave , '"' , ''  )
		
		if substr(_chave,1,1) == ","
			_chave  := substr(_chave,2)
		Endif
		
		if substr(_chave,len(_chave),1) == ","
			_chave  := substr(_chave,1,len(_chave)-1)
		Endif
		
		_chave  := upper(alltrim(_chave))
		
		_aParam := {}
		
		_nIni := 1
		_nFim := 0
		
		For _x := 1 to len(_chave)
			
			_nFim := 0
			
			if substr(_chave,_x,1) == "," .or. _x == len(_chave)
				
				if substr(_chave,_x,1) == ","
					_nFim := (_x-1)
				Elseif  _x == len(_chave)
					_nFim := _x
				Endif
				
				if _nFim > 0
					
					aadd(_aParam,{ substr(_chave,_nIni, (_nFim-_nIni+1) ), substr(_chave,_nIni, (_nFim-_nIni+1) ) })
					
					_nIni := _x+1
					
					if _nIni <= Len(_chave)
						if substr(_chave,_nIni,1) == ","
							_nIni ++
						Endif
					Endif
				Endif
			Endif
		Next
		
		for _x :=1 to len(_aParam)
			
			_cFx := _aParam[_x,1]
			_nfx := at("-",_cFx)
			
			if _nfx > 0
				_aParam[_x,1] :=  substr(_cFx, 1      , _nfx-1)
				_aParam[_x,2] :=  substr(_cFx, _nfx+1         )
			Endif
			
		Next
		
		for _x :=1 to len(_aParam)
			
			_cPar1 := _aParam[_x,1]
			_cPar2 := _aParam[_x,2]
			
			_lFaixa := iif( _cPar1 <> _cPar2 , .t. , .f. )
			
			if _Alias == "SA2" // Fornecedores
				
				if at("Z",_cPar1) > 0
					_aParam[_x,1] := 'FZZZZZ'
				Else
					if substr(_cPar1,1,1) == "F"
						_aParam[_x,1] := "F"+strzero(val(substr(_cPar1,2)),_TamCpo-1)
					else
						_aParam[_x,1] := "F"+strzero(val(substr(_cPar1,1)),_TamCpo-1)
					Endif
				Endif
				
				if _aParam[_x,1] == 'F00000'
					_aParam[_x,1] := 'F'+space(5)
				Endif
				
				if _lfaixa
					if at("Z",_cPar2) > 0
						_aParam[_x,2] := 'FZZZZZ'
					Else
						if substr(_cPar2,1,1) == "F"
							_aParam[_x,2] := "F"+strzero(val(substr(_cPar2,2)),_TamCpo-1)
						else
							_aParam[_x,2] := "F"+strzero(val(substr(_cPar2,1)),_TamCpo-1)
						Endif
					Endif
				Else
					_aParam[_x,2] := _aParam[_x,1]
				Endif
				
			Elseif _Alias == "SA1" // Clientes
				
				if at("Z",_cPar1) > 0
					_aParam[_x,1] := 'CZZZZZ'
				Else
					if substr(_cPar1,1,1) == "C"
						_aParam[_x,1] := "C"+strzero(val(substr(_cPar1,2)),_TamCpo-1)
					else
						_aParam[_x,1] := "C"+strzero(val(substr(_cPar1,1)),_TamCpo-1)
					Endif
				Endif
				
				if _aParam[_x,1] == 'C00000'
					_aParam[_x,1] := 'C'+space(5)
				Endif
				
				
				if _lfaixa
					if at("Z",_cPar2) > 0
						_aParam[_x,2] := 'CZZZZZ'
					Else
						if substr(_cPar2,1,1) == "C"
							_aParam[_x,2] := "C"+strzero(val(substr(_cPar2,2)),_TamCpo-1)
						else
							_aParam[_x,2] := "C"+strzero(val(substr(_cPar2,1)),_TamCpo-1)
						Endif
					Endif
				Else
					_aParam[_x,2] := _aParam[_x,1]
				Endif
				
			Elseif _Alias == "SED" // Naturezas
				
				if at("Z",_cPar1) > 0
					
					if substr(_cPar1,1,1) $ "DR"
						_aParam[_x,1] := padr(substr(_cPar1,1,1),_TamCpo,"Z")
					Else
						_aParam[_x,1] := padr('0ZZ',_TamCpo)
					Endif
				Else
					if substr(_cPar1,1,1) $ "DR"
						_aParam[_x,1] := substr(_cPar1,1,1)+strzero(val(substr(_cPar1,2)),_TamCpo-1)
					Else
						_aParam[_x,1] := padr(strzero(val(alltrim(_cPar1)),3),_TamCpo)
					Endif
				Endif
				
				if _aParam[_x,1] == '0000000000'
					_aParam[_x,1] := '0'+space(9)
				Endif
				
				
				if _lfaixa
					if at("Z",_cPar2) > 0
						if substr(_cPar2,1,1) $ "DR"
							_aParam[_x,2] := padr(substr(_cPar2,1,1),_TamCpo,"Z")
						Else
							_aParam[_x,2] := padr('0ZZ',_TamCpo)
						Endif
					Else
						if substr(_cPar2,1,1) $ "DR"
							_aParam[_x,2] := substr(_cPar2,1,1)+strzero(val(substr(_cPar2,2)),_TamCpo-1)
						Else
							_aParam[_x,2] := padr(strzero(val(alltrim(_cPar2)),3),_TamCpo)
						Endif
					Endif
				Else
					_aParam[_x,2] := _aParam[_x,1]
				Endif
				
			Else
				
				if at("Z",_cPar1) > 0
					_aParam[_x,1] := replicate('Z',_TamCpo)
				Else
					if _lstrzero
						_aParam[_x,1] := strzero( val( substr(_cPar1,1) ), _TamCpo )
					Else
						_aParam[_x,1] := padr( substr(_cPar1,1,_TamCpo) , _TamCpo )
					Endif
				Endif
				
				if _aParam[_x,1] == replicate('0' , _TamCpo )
					_aParam[_x,1] := space(_TamCpo)
				Endif
				
				if _lfaixa
					
					if at("Z",_cPar2) > 0
						_aParam[_x,2] := replicate('Z',_TamCpo)
					Else
						if _lstrzero
							_aParam[_x,2] := strzero( val( substr(_cPar2,1) ) , _TamCpo )
						Else
							_aParam[_x,2] := padr( substr(_cPar2,1,_TamCpo) , _TamCpo )
						Endif
					Endif
					
				Else
					_aParam[_x,2] := _aParam[_x,1]
				Endif
				
			Endif
			
		Next
		
		if len(_aparam) > 0
			
			if _tipo <> "A"
				
				&(_tipo) := _aParam[1][1]
				_cpo     := _aParam[1][1]
				
				dbselectarea(_Alias)
				dbsetorder(1)
				dbgotop()
				
				if dbseek(xFilial()+_cpo,.f.)
					_aParam := .T.
				Else
					_aParam := .f.
				Endif
				
				//ALERT(&(_tipo))
			Endif
			
		Endif
		
	Endif
	
	//for _x :=1 to len(_aParam)
	//	alert(_aParam[_x,1]+'-'+_aParam[_x,2])
	//Next
	
Else
	
	if _tipo <> "A"
		_aParam := .T.
	Else
		_aParam := {{_chave,_chave}}
	Endif
	
Endif

return(_aParam)

// -------------------------------------------------------------------------------------------------------------------- //
// -------------------------------------------------------------------------------------------------------------------- //
// -------------------------------------------------------------------------------------------------------------------- //

////////////////////////////////////////////////
////////////////////////////////////////////////
USER function copy2dbf(_Arq,_alias,_driver )
////////////////////////////////////////////////
////////////////////////////////////////////////
Local _aArea := { Alias(), IndexOrd(), Recno() }

if _alias == nil
	_alias := Alias()
Endif

if _driver == nil
	_driver := "CTREECDX"
Endif

dbselectarea(_alias)

Copy To &(_Arq) via _driver

dbSelectArea(_aArea[1])
dbSetOrder(_aArea[2])
dbGoto(_aArea[3])

return nil

// -------------------------------------------------------------------------------------------------------------------- //
// -------------------------------------------------------------------------------------------------------------------- //
// -------------------------------------------------------------------------------------------------------------------- //


////////////////////////////////////////////////
////////////////////////////////////////////////
USER function imparq(_Arq,_tipo,_alias )
////////////////////////////////////////////////
////////////////////////////////////////////////
Local _aArea := { Alias(), IndexOrd(), Recno() }

if _alias == nil
	_alias := Alias()
Endif

dbselectarea(_alias)

if _tipo == 2
	append from (_Arq) SDF
Else
	append from (_Arq)
Endif

dbSelectArea(_aArea[1])
dbSetOrder(_aArea[2])
dbGoto(_aArea[3])

return nil


// -------------------------------------------------------------------------------------------------------------------- //
// -------------------------------------------------------------------------------------------------------------------- //
// -------------------------------------------------------------------------------------------------------------------- //

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
User Function ImpCry(_cCryNome,_cCryTitulo,_Alias,_cTmpSZR,_cSrvCry,_cLocFolder,_cLocDBF,_cLocCry,_lVisual)
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

if _lVisual == nil
	_lVisual := .f.
Endif


if _Alias == nil
	_Alias := "SZR"
else
	_Alias := upper(_Alias)
Endif

dbselectarea(_Alias)
dbgotop()

if reccount() > 0 .or. _lVisual
	
	u_verdir(_cLocFolder)
	
	dbCloseArea()
	
	if file(_cTmpSZR) .or. _lVisual
		
		if ! _lVisual
			MsgRun("Gerando dados para relatorio..","",{||	__CopyFile(_cTmpSZR, _cLocDBF )})
			FErase(_cTmpSZR)
		Endif
		
		_lCopy := .f.
		
		if file(_cSrvCry)
			
			if !file(_cLocCry)
				_lCopy := .t.
			Else
				
				_aRptArq  := directory(_cSrvCry)
				_aRptLoc  := directory(_cLocCry)
				
				if _aRptLoc[1,3] < _aRptArq[1,3]
					_lCopy := .t.
				Endif
				if _aRptLoc[1,3] == _aRptArq[1,3]
					if _aRptLoc[1,4] < _aRptArq[1,4]
						//alert(_aRptLoc[1,4]+" / "+ _aRptArq[1,4])
						_lCopy := .t.
					Endif
				Endif
				
			Endif
			
			if _lCopy
				MsgRun("Atualizando modelo de Relatorio...","",{|| __CopyFile(_cSrvCry,_cLocCry)})
			Endif
			
			if file(_cLocCry)
				if file(_cLocDBF)
					callcrys(_cCryNome,,"1;0;1;"+_cCryTitulo,.t.)
				Else
					MSGBOX("!! Arquivo de dados  "+_cLocDBF+" nao foi encontrado.")
				Endif
			Else
				MSGBOX("!! Modelo de relatorio "+_cLocCry+" nao foi encontrado.")
			Endif
		Else
			MSGBOX("!! Modelo de relatorio "+_cSrvCry+" nao foi encontrado.")
		Endif
	Else
		alert("Nao encontrado arquivo "+_cTmpSZR+".")
	Endif
	
Else
	Alert("Nao existe dados a serem impressos")
Endif

return nil

// -------------------------------------------------------------------------------------------------------------------- //
// -------------------------------------------------------------------------------------------------------------------- //
// -------------------------------------------------------------------------------------------------------------------- //

////////////////////////////////////////////////
// RETORNAR O NOVO NUMERO DE REFERENCIA PARA TOTULOS DO CONTAS A PAGAR/RECEBER
// 07/11/2011
/////////////////////////
user Function getnumref()
/////////////////////////
//DbSelectArea('SE2')
//DbOrderNickName("NUMREF")

if Inclui
	
	_cConteud := "000001"
	_cParam   := "  US_NUMREF "
	
	Dbselectarea('SX6')
	Dbsetorder(1)
	Dbgotop()
	IF ! Dbseek(_cParam,.f.)
		
		_nNumRef := 0
		
		// Pesquisa o maior valor de referencia no contas a pagar
		
		_cQuery   := " SELECT MAX(E2_NUMREF) NUMREF "
		_cQuery   += " FROM "+RetSqlName("SE2")
		_cQuery   += " WHERE D_E_L_E_T_ <> '*' AND E2_NUMREF <> SPACE(6) "
		_cQuery   := ChangeQuery(_cQuery)
		
		If Select("MAXREF") > 0
			dbSelectArea("MAXREF")
			dbCloseArea()
		Endif
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"MAXREF")
		dbSelectArea("MAXREF")
		dbGoTop()
		
		If Empty(MAXREF->NUMREF)
			_nNumRef := 1
		Else
			_nNumRef := val(NUMREF)+1
		Endif
		
		dbSelectArea("MAXREF")
		dbCloseArea()
		
		// Pesquisa o maior valor de referencia no contas a receber
		
		_cQuery   := " SELECT MAX(E1_NUMREF) NUMREF "
		_cQuery    += " FROM "+RetSqlName("SE1")
		_cQuery    += " WHERE D_E_L_E_T_ <> '*' AND E1_NUMREF <> SPACE(6) "
		_cQuery    := ChangeQuery(_cQuery)
		
		If Select("MAXREF") > 0
			dbSelectArea("MAXREF")
			dbCloseArea()
		Endif
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"MAXREF")
		dbSelectArea("MAXREF")
		dbGoTop()
		
		If Empty(MAXREF->NUMREF)
			_xNumRef := 1
		Else
			_xNumRef := val(NUMREF)+1
		Endif
		
		dbSelectArea("MAXREF")
		dbCloseArea()
		
		if _xNumRef > _nNumRef
			_nNumRef := _xNumRef
		Endif
		
		_cConteud := strzero(_nNumRef,6)
		
		Dbselectarea('SX6')
		
		if Reclock('SX6',.T.)
			SX6->X6_FIL     := " "
			SX6->X6_VAR     := substr(_cParam,3,10)
			SX6->X6_TIPO    := 'C'
			SX6->X6_DESCRIC := 'Numero de referencia para Contas a pagar/receber'
			SX6->X6_PROPRI  := "U"
			SX6->X6_CONTEUD := _cConteud
			SX6->X6_CONTSPA := _cConteud
			SX6->X6_CONTENG := _cConteud
			Msunlock()
		Endif
	Else
		_cConteud := strzero(val(SX6->X6_CONTEUD)+1,6)
		
		if Reclock('SX6',.F.)
			SX6->X6_CONTEUD := _cConteud
			SX6->X6_CONTSPA := _cConteud
			SX6->X6_CONTENG := _cConteud
			Msunlock()
		Endif
	Endif
Else
	_cConteud := &_cCampo
Endif

return(_cConteud)

// -------------------------------------------------------------------------------------------------------------------- //
// -------------------------------------------------------------------------------------------------------------------- //
// -------------------------------------------------------------------------------------------------------------------- //

////////////////////////////////////////////////////////////////////////////////////////////
// Funcao para retornar em gatilho o codigo do produto baseado no grupo
////////////////////////////////////////////////////////////////////////////////////////////
// 09/11/2011
////////////////////////////////////////////////////////////////////////////////////////////
User Function GETCODPRO(_cGrupo)

_cGrupo  := alltrim(_cGrupo)
_cCodPro := alltrim(_cGrupo)+'0001'

dbselectarea('SB1')
dbsetorder(1)
dbgotop()

if dbseek(xfilial('SB1')+_cGrupo,.F.)
	
	Do While ! eof() .and. substr(b1_cod,1,4) == substr(_cGrupo,1,4)
		_cCodPro := b1_cod
		dbskip()
	Enddo
	
	_cCodPro := padr(strzero(val(_cCodPro)+1,8),15)
	
Endif

return(_cCodPro)

// -------------------------------------------------------------------------------------------------------------------- //
// -------------------------------------------------------------------------------------------------------------------- //
// -------------------------------------------------------------------------------------------------------------------- //


/////////////////////////////////////////////////
/////////////////////////////////////////////////
user function mes(_pMes)
/////////////////////////////////////////////////
/////////////////////////////////////////////////
_cMes := " "
_pMes := strzero(val(_pMes),2)

if _pMes == '01'
	_cMes := "Janeiro"
Elseif _pMes == '02'
	_cMes := "Fevereiro"
Elseif _pMes == '03'
	_cMes := "Marco"
Elseif _pMes == '04'
	_cMes := "Abril"
Elseif _pMes == '05'
	_cMes := "Maio"
Elseif _pMes == '06'
	_cMes := "Junho"
Elseif _pMes == '07'
	_cMes := "Julho"
Elseif _pMes == '08'
	_cMes := "Agosto"
Elseif _pMes == '09'
	_cMes := "Setembro"
Elseif _pMes == '10'
	_cMes := "Outubro"
Elseif _pMes == '11'
	_cMes := "Novembro"
Elseif _pMes == '12'
	_cMes := "Dezembro"
Endif

Return(_cMes)

// -------------------------------------------------------------------------------------------------------------------- //
// -------------------------------------------------------------------------------------------------------------------- //
// -------------------------------------------------------------------------------------------------------------------- //


///////////////////////////////////
///////////////////////////////////
user function visdepto(_rotina)
///////////////////////////////////
///////////////////////////////////
_cCompCod := " "
_cRet     := "@#AY0->AY0_TIPO == '4'@#"
_lCond1   := " AYJ_FILIAL+AYJ_TIPO == xfilial('AYJ')+'4' "
_lCond2   := " AYJ_FILIAL+AYJ_TIPO <> xfilial('AYJ')+'4' "
_lProcfil := .f.

if upper(_rotina) == 'VISR003'
	
	_cCompCod := MV_PAR02
	
	_lCond1 := " AYJ_FILIAL+AYJ_COD+AYJ_TIPO == xfilial('AYJ')+_cCompCod+'4' "
	_lCond2 := " AYJ_FILIAL+AYJ_COD+AYJ_TIPO <> xfilial('AYJ')+_cCompCod+'4' "
	
	_lProcfil := .t.
	
Endif

if _lProcfil
	
	dbselectarea('AYJ')
	dbsetorder(1)
	dbgotop()
	
	if dbseek(xfilial('AYJ')+_cCompCod+'4',.f.)
		
		_cRet := "@#AY0->AY0_TIPO == '4' .AND. ( "
		
		Do While !eof() .and. &_lCond1
			
			_cRet += " LEFT(AY0->AY0_CODIGO,4) == '"+ LEFT(AYJ_CATEG,4)+"'"
			
			dbskip()
			
			IF eof() .or. &_lCond2
				_cRet += " )@#"
			Else
				_cRet += " .OR. "
			Endif
		Enddo
	Endif
Endif

return(_cRet)

// -------------------------------------------------------------------------------------------------------------------- //
// -------------------------------------------------------------------------------------------------------------------- //
// -------------------------------------------------------------------------------------------------------------------- //

///////////////////////////////////
///////////////////////////////////
user function visgrupo(_rotina)
///////////////////////////////////
///////////////////////////////////

_cRet     :=  "@#AY0->AY0_TIPO == '1'@#"
_lCond1   :=  " AYJ_FILIAL+AYJ_TIPO == xfilial('AYJ')+'1' "
_lCond2   :=  " AYJ_FILIAL+AYJ_TIPO <> xfilial('AYJ')+'1' "
_lProcfil :=  .f.

if upper(_rotina) == 'VISR003'
	
	_cCompCod :=  MV_PAR02
	_lCond1   := " AYJ_FILIAL+AYJ_COD+AYJ_TIPO == xfilial('AYJ')+_cCompCod+'1'  "
	_lCond2   := " AYJ_FILIAL+AYJ_COD+AYJ_TIPO <> xfilial('AYJ')+_cCompCod+'1'  "
	_lProcfil := .t.
	
Endif

if _lProcfil
	
	dbselectarea('AYJ')
	dbsetorder(1)
	dbgotop()
	
	if dbseek(xfilial('AYJ')+_cCompCod+'1',.f.)
		
		_cRet := "@#AY0->AY0_TIPO == '1' .AND. ( "
		
		Do While !eof() .and. &_lCond1
			
			_cRet += " LEFT(AY0->AY0_CODIGO,4) == '"+LEFT(AYJ_CATEG,4)+"'"
			
			dbskip()
			
			IF eof() .or. &_lCond2
				_cRet += " )@#"
			Else
				_cRet += " .OR. "
			Endif
		Enddo
	Endif
Endif

return(_cRet)

// -------------------------------------------------------------------------------------------------------------------- //
// -------------------------------------------------------------------------------------------------------------------- //
// -------------------------------------------------------------------------------------------------------------------- //

///////////////////////////////////
///////////////////////////////////
user function vistipo(_rotina)
///////////////////////////////////
///////////////////////////////////

_lProcfil := .f.
_cRet     := "@#LEN(ALLTRIM(AY1->AY1_SUBCAT)) == 4@#"

if upper(_rotina) == 'VISR001'
	
	_cGrupo   := MV_PAR06
	_cRet     := "@#AY1->AY1_CODIGO == '"+_cGrupo+"'@#"
	
Elseif upper(_rotina) == 'VISR003'
	
	_cCompCod := MV_PAR02
	_cGrupo   := MV_PAR05
	
	_lcond1   := " AYJ_FILIAL+AYJ_COD+AYJ_TIPO == xfilial('AYJ')+_cCompCod+'2' "
	_lcond2   := " AYJ_FILIAL+AYJ_COD+AYJ_TIPO <> xfilial('AYJ')+_cCompCod+'2' "
	_lProcfil := .t.
	
Elseif upper(_rotina) == 'VISR004'
	
	_cGrupo   := MV_PAR11
	_cRet     := "@#AY1->AY1_CODIGO == '"+_cGrupo+"'@#"
	
Elseif upper(_rotina) == 'VISR005'
	
	_cGrupo   := MV_PAR05
	_cRet     := "@#AY1->AY1_CODIGO == '"+_cGrupo+"'@#"
	
Elseif upper(_rotina) == 'VISR008'
	
	_cGrupo   := MV_PAR10
	_cRet     := "@#AY1->AY1_CODIGO == '"+_cGrupo+"'@#"
	
Elseif upper(_rotina) == 'VISP004'
	
	_cGrupo   := _cGrp
	_cRet     := "@#AY1->AY1_CODIGO == '"+_cGrp+"'@#"
	
Endif

if _lProcfil
	
	dbselectarea('AYJ')
	dbsetorder(1)
	dbgotop()
	
	if dbseek(xfilial('AYJ')+_cCompCod+'2',.f.)
		
		_cRet := "@#AY1->AY1_CODIGO == '"+_cGrupo+"' .AND. ( "
		
		Do While !eof() .and. &_lcond1
			
			_cRet += " LEFT(AY1->AY1_SUBCAT,4) == '"+LEFT(AYJ_CATEG,4)+"'"
			dbskip()
			
			IF eof() .or. &_lcond2
				_cRet += " )@#"
			Else
				_cRet += " .OR. "
			Endif
		Enddo
	Else
		_cRet := "@#AY1->AY1_CODIGO == '"+_cGrupo+"'@#"
	Endif
Endif

return(_cRet)

// -------------------------------------------------------------------------------------------------------------------- //
// -------------------------------------------------------------------------------------------------------------------- //
// -------------------------------------------------------------------------------------------------------------------- //

///////////////////////////////////
///////////////////////////////////
user function vissub(_rotina)
///////////////////////////////////
///////////////////////////////////

_cRet     := "@#LEN(ALLTRIM(AY1->AY1_SUBCAT)) == 7@#"
_lProcfil := .f.

if upper(_rotina) == 'VISR001'
	
	_cGrupo   := MV_PAR06
	_cTipo    := MV_PAR07
	
	_cRet := "@#AY1->AY1_CODIGO == '"+_cTipo+"'@#"
	
Elseif upper(_rotina) == 'VISR003'
	
	_cCompCod := MV_PAR02
	_cGrupo   := MV_PAR05
	_cTipo    := MV_PAR06
	
	_lCond1 := " AYJ_FILIAL+AYJ_COD+AYJ_TIPO == xfilial('AYJ')+_cCompCod+'3' "
	_lCond2 := " AYJ_FILIAL+AYJ_COD+AYJ_TIPO <> xfilial('AYJ')+_cCompCod+'3' "
	_lProcfil := .t.
	
Elseif upper(_rotina) == 'VISR004'
	
	_cGrupo   := MV_PAR11
	_cTipo    := MV_PAR12
	
	_cRet := "@#AY1->AY1_CODIGO == '"+_cTipo+"'@#"
	
Elseif upper(_rotina) == 'VISR005'
	
	_cGrupo   := MV_PAR05
	_cTipo    := MV_PAR06
	
	_cRet := "@#AY1->AY1_CODIGO == '"+_cTipo+"'@#"
	
Elseif upper(_rotina) == 'VISR008'
	
	_cGrupo   := MV_PAR10
	_cTipo    := MV_PAR11
	
	_cRet := "@#AY1->AY1_CODIGO == '"+_cTipo+"'@#"
	
Elseif upper(_rotina) == 'VISP004'
	
	_cGrupo   := _cGrp
	_cTipo    := _cTip
	
	_cRet := "@#AY1->AY1_CODIGO == '"+_cTip+"'@#"
	
Endif

if _lProcfil
	
	dbselectarea('AYJ')
	dbsetorder(1)
	dbgotop()
	
	if dbseek(xfilial('AYJ')+_cCompCod+'3',.f.)
		
		_cRet := "@#AY1->AY1_CODIGO == '"+_cTipo+"' .AND. ( LEFT(AY1->AY1_SUBCAT,7) $ '"
		
		Do While !eof() .and. &_lCond1
			
			_cRet += LEFT(AYJ_CATEG,7)
			
			dbskip()
			
			IF eof() .or. &_lCond2
				_cRet += "')@#"
			Else
				_cRet += ","
			Endif
		Enddo
	Else
		_cRet := "@#AY1->AY1_CODIGO == '"+_cTipo+"'@#"
	Endif
Endif

return(_cRet)

// -------------------------------------------------------------------------------------------------------------------- //
// -------------------------------------------------------------------------------------------------------------------- //
// -------------------------------------------------------------------------------------------------------------------- //

///////////////////////////////
User Function pesqcad(_vAlias,_vCod,_vDescricao, _vArray)
///////////////////////////////

_cAtuAli := alias()
_cAtuInd := indexord()
_cAtuRec := recno()

if _vArray == nil
	_vArray := {}
Endif

if ! empty(_vDescricao)
	
	_lret     := .t.
	_cMarca   := getmark()
	_lInverte := .f.
	_cQry     := ""
	
	ofont1 := TFont():New("TIMES NEW ROMAN" , 15, 20,,.T.)
	ofont2 := TFont():New("TIMES NEW ROMAN" , 30, 40,,.T.)
	
	PRIVATE cCADASTRO := "Consulta "
	
	
	
	if "SB1" $ _vAlias
		_xAlias := 	"SB1"
	Else
		_xAlias := 	_vAlias
	Endif
	
	dbselectarea(_xAlias)
	
	
	_vAliInd := indexord()
	_vAliRec := recno()
	
	If Select("PESTMP") > 0
		PESTMP->(dbCloseArea())
	EndIf
	
	if _vAlias == "SA2"
		
		cCADASTRO += "de Fornecedores"
		
		_cQry := " SELECT '  ' AS MARK, SA2.A2_COD AS COD , SA2.A2_NOME AS NOME , SA2.A2_NREDUZ , SA2.A2_EST , SA2.A2_CGC, ' ' AS A2_TIPO  "
		_cQry += " FROM "+RetSqlName("SA2")+" SA2 "
		_cQry += " WHERE SA2.D_E_L_E_T_ <> '*' "
		
		
		If Left(alltrim(_vDescricao),1) == "@"
			
			_cQry += " AND A2_NOME LIKE '%"+substr(alltrim(_vDescricao),2)+"%' "
			
		Elseif iSalpha(Left(alltrim(_vDescricao),1))
			
			_nTam  := len(alltrim(_vDescricao))
			_cQry += " AND SUBSTRING(SA2.A2_NOME,1,"+str(_nTam,2,0)+") = '"+alltrim(_vDescricao)+"'"
			
		Endif
		
		_cQry += " ORDER BY SA2.A2_NOME "
		
	Elseif "SB1" $ _vAlias
		
		cCADASTRO += "de Produtos"
		
		_cQry := " SELECT '  ' AS MARK , "
		
		If _vAlias == "SB1"
			_cQry += " SB1.B1_COD    AS COD, "
		Else
			_cQry += " SB1.B1_CODANT AS COD, "
		Endif
		
		_cQry += " SB1.B1_DESC AS NOME , SB1.B1_UM  "
		_cQry += " FROM "+RetSqlName("SB1")+" SB1 "
		_cQry += " WHERE SB1.D_E_L_E_T_ <> '*' "
		
		If Left(alltrim(_vDescricao),1) == "@"
			
			_cQry += " AND B1_DESC LIKE '%"+substr(alltrim(_vDescricao),2)+"%' "
			
		Elseif iSalpha(Left(alltrim(_vDescricao),1))
			
			_nTam  := len(alltrim(_vDescricao))
			_cQry += " AND SUBSTRING(SB1.B1_DESC,1,"+str(_nTam,2,0)+") = '"+alltrim(_vDescricao)+"'"
			
		Endif
		
		_cQry += " ORDER BY SB1.B1_DESC "
		
	Endif
	
	MsgRun("Analisando consulta..","",{|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),"PESTMP",.F.,.F.) })
	
	_cArqTmp := CriaTrab(NIL,.F.)+ GetDbExtension()
	
	DbSelectArea('PESTMP')
	Copy To &_cArqTmp
	dbclosearea()
	
	dbUseArea(.T.,,_cArqTMP,"PESTMP",.F.,.F.)
	dbgotop()
	
	if reccount() == 0
		
		alert("Nao encontrado registros para esta pesquisa ! ")
		_lret := .f.
		
	Else
		
		dbSelectArea("PESTMP")
		dbGoTop()
		
		While !Eof()
			
			RecLock("PESTMP",.f.)
			PESTMP->MARK := _cMarca
			dbSkip()
			
		Enddo
		
		dbcommit()
		dbGoTop()
		
		DbSelectArea('PESTMP')
		
		DEFINE MSDIALOG oDlgPesq FROM 010,010 To 300,700 PIXEL TITLE cCADASTRO
		
		_aCampos := {}
		_aCord   := { 5, 5 , 120 , 340 } // Usar a metade das coordenadas
		
		aadd(_aCampos, {"MARK"      , ,"Ok"               , "@!" })
		aadd(_aCampos, {"COD"       , ,"Codigo"           , "@!" })
		aadd(_aCampos, {"NOME"      , ,"Nome "            , "@!" })
		
		_aCores  := {{ "!EMPTY(PESTMP->NOME)","BR_AZUL"} , { "EMPTY(PESTMP->NOME)","BR_AMARELO"} }
		
		if _vAlias == "SA2"
			
			aadd(_aCampos, {"A2_NREDUZ" , ,"Nome Fantasia"    , "@!" })
			aadd(_aCampos, {"A2_EST"    , ,"Estado"           , "@!" })
			aadd(_aCampos, {"A2_CGC"    , ,"CNPJ"             , "@R 99.999.999/9999-99"})
			
		Elseif "SB1" $ _vAlias
			
		Endif
		
		
		oMark       := MsSelect():New( 'PESTMP', 'MARK', '!NOME', _aCampos, @_lInverte , @_cMarca , _aCord ,  , , oDlgPesq , ,  )
		oMark:oBrowse:lhasMark    := .t.
		oMark:oBrowse:lCanAllmark := .t.
		oMark:oBrowse:bAllMark    := {| | MarkAllPes(@_cMarca,@oMark)}
		oMark:oBrowse:bLdblclick  := {| | MarkPes(@_cMarca,@oMark) }
		//oMark:bMark               := {| | MarkFor(@_cMarca,@oMark) }
		
		_cBlkOkPes := {|| _lret  := .t., OkPes(@_vAlias,@_vCod,@_vDescricao,@_vArray), Close(oDlgPesq) }
		
		TButton():New(130,250, 'Confirma'   , oDlgPesq, _cBlkOkPes                           , 40 , 10,,,,.T.)
		TButton():New(130,290, 'Cancela '   , oDlgPesq, {|| _lret  := .f., Close(oDlgPesq) } , 40 , 10,,,,.T.)
		
		ACTIVATE MSDIALOG oDlgPesq CENTERED
		
		If select("PESTMP") > 0
			PESTMP->(dbCloseArea())
			DELE FILE &_cArqTmp
		Endif
		
	Endif
	
	dbselectarea(_xAlias)
	dbsetorder(_vAliInd)
	dbgoto(_vAliRec)
	
Endif

dbselectarea(_cAtuAli)
dbsetorder(_cAtuInd)
dbgoto(_cAtuRec)

return(_vArray)

// -------------------------------------------------------------------------------------------------------------------- //
// -------------------------------------------------------------------------------------------------------------------- //
// -------------------------------------------------------------------------------------------------------------------- //

///////////////////////////
///////////////////////////
static function MarkPes(_cMarca,oMark)
///////////////////////////
///////////////////////////

dbselectarea("PESTMP")

if reclock("PESTMP",.f.)
	If PESTMP->MARK == _cMarca
		PESTMP->MARK := "  "//thismark()
	Else
		PESTMP->MARK := _cMarca
	Endif
	MSUNLOCK()
	dbcommit()
Endif

oMark:oBrowse:Refresh()

Return Nil

// -------------------------------------------------------------------------------------------------------------------- //
// -------------------------------------------------------------------------------------------------------------------- //
// -------------------------------------------------------------------------------------------------------------------- //

///////////////////////////
///////////////////////////
static function MarkAllPes(_cMarca,oMark)
///////////////////////////
///////////////////////////
dbSelectArea("PESTMP")
dbGoTop()
While !Eof()
	RecLock("PESTMP",.f.)
	IF PESTMP->MARK == _cMarca
		PESTMP->MARK := "  "//thismark()
	Else
		PESTMP->MARK := _cMarca
	Endif
	dbSkip()
Enddo
dbcommit()
dbGoTop()
oMark:oBrowse:Refresh(.t.)

Return Nil

// -------------------------------------------------------------------------------------------------------------------- //
// -------------------------------------------------------------------------------------------------------------------- //
// -------------------------------------------------------------------------------------------------------------------- //

//////////////////////////////////////////
//////////////////////////////////////////
static function OkPes(_vAlias, _vCod,_vDescricao,_vArray)
//////////////////////////////////////////
//////////////////////////////////////////

_vArray := {}

dbSelectArea("PESTMP")
dbgotop()

While !Eof()
	
	IF PESTMP->MARK == _cMarca
		
		_cNome2 := " "
		
		if _vAlias == "SA2"
			_cNome2 := PESTMP->A2_NREDUZ
		Elseif "SB1" $ _vAlias
			_cNome2 := strtran(_vDescricao,"@","")
		Endif
		
		aadd(_vArray,{COD,NOME,_cNome2})
		
	Endif
	
	dbSkip()
	
Enddo

IF len(_vArray) > 0
	
	IF len(_vArray) == 1
		
		_vCod       := _vArray[1][1]
		_vDescricao := _vArray[1][2]
		
	Else
		
		_vCod       := '******'
		_vDescricao := PADR('(VARIOS) '+_vArray[1][3],40)
		
	Endif
Else
	
	Alert("Nao encontrado dados")
	
Endif

return(.t.)

// -------------------------------------------------------------------------------------------------------------------- //
// -------------------------------------------------------------------------------------------------------------------- //
// -------------------------------------------------------------------------------------------------------------------- //


///////////////////////////
///////////////////////////
static function visproduto()
///////////////////////////
///////////////////////////

//_oSay1:SetText ( PESTMP->B1_DESC )
//_oSay2:SetText ( 'R$'+TRANSFORM(PESTMP->B1_PRV1,"@E 999,999.99") )
//_oSay3:SetText ( IIF(PESTMP->B2_QATU > 0," ","S/ESTOQUE") )

//_oSay1:refresh()
//_oSay2:refresh()
//_oSay3:refresh()

return(.t.)

// -------------------------------------------------------------------------------------------------------------------- //
// -------------------------------------------------------------------------------------------------------------------- //
// -------------------------------------------------------------------------------------------------------------------- //


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	  ³ Modelo2  ³ Autor ³ Juan Jose Pereira	  ³ Data ³ 18/09/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ Exibe Formulario Modelo 2 								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ cTitulo=Titulo da Janela								  ³±±
±±³			  ³ aC=Array com campos do cabecalho						  ³±±
±±³			  ³ aR=Array com campos do rodape							  ³±±
±±³			  ³ aCGD=Array com coordenadas da GetDados					  ³±±
±±³			  ³ nOpcx1=Modo de operacao 									  ³±±
±±³			  ³ cLineOk2=Validacao de linha da GetDados					  ³±±
±±³			  ³ cAllOkk=Validacao de toda GetDados 						  ³±±
±±³			  ³ aGetsD=Array com gets editaveis 						  ³±±
±±³			  ³ bF4=bloco de codigo para tecla F4						  ³±±
±±³			  ³ cIniCpos=string com nome dos campos que devem ser inicia- ³±±
±±³			  ³			 lizados ao teclar seta para baixo. 			  ³±±
±±³			  ³ lDelGetD=determina se as linhas da Getdados podem ser de- ³±±
±±³			  ³			 letadas ou nao.											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		  ³ Generico																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
USER FUNCTION cldjan( cTitulo , aCordW , bF4 , aC , aR , _aGetDados , oDlgCldMain , aFolTit , aFolDial , aFolPos, aBotoes )
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
local _nOpca     := 0
local _cFiller   := ""
local i
local lAllOk
Local _nctd := 0
Local _xy := 0
local oSaveGetd1 := Nil, oSaveGetd2 := Nil, oSaveGetd3 := Nil, oSaveGetd4 := Nil, oSaveGetd5 := Nil, oSaveGetd6 := Nil
local aSvRot     := Nil
local nFolder1   := 1   , nFolder2 := 1 , nFolder3 := 1 , nFolder4 := 1 , nFolder5 := 1 , nFolder6 := 1
local bBColor1   := " " , bFColor1 := " "
local bBColor2   := " " , bFColor2 := " "
local bBColor3   := " " , bFColor3 := " "
local bBColor4   := " " , bFColor4 := " "
local bBColor5   := " " , bFColor5 := " "
local bBColor6   := " " , bFColor6 := " "
local nX := 0
private _oCldSay
private _oCldGet
private _aSay    := {}
private _aGet    := {}
private _oDlgCldBrw
private oGetDados1, oGetDados2, oGetDados3, oGetDados4, oGetDados5, oGetDados6
//private aCols1, aCols2, aCols3, aCols4, aCols5, aCols6
private oFolder , odlg1 , odlg2, odlg3, odlg4, odlg5, odlg6
private nCount  := 0
private cAllOk1   := "ALLWAYSTRUE()" , cAllOk2   := "ALLWAYSTRUE()" , cAllOk3   := "ALLWAYSTRUE()" , cAllOk4   := "ALLWAYSTRUE()" , cAllOk5   := "ALLWAYSTRUE()" , cAllOk6   := "ALLWAYSTRUE()"
private cLineOk1  := "ALLWAYSTRUE()" , cLineOk2  := "ALLWAYSTRUE()" , cLineOk3  := "ALLWAYSTRUE()" , cLineOk4  := "ALLWAYSTRUE()" , cLineOk5  := "ALLWAYSTRUE()" , cLineOk6  := "ALLWAYSTRUE()"

if aBotoes == nil
	aBotoes := {}
Endif

//VK_F4     := 115

oDlgCldMain  := Iif(oDlgCldMain==Nil,oMainWnd,oDlgCldMain)

//
//_aGetDados -> { nOpcx1 , @acols1, @aHeader1, @aCGD1 , @_cLinhaOk1, @_cTudoOk1, /* @_aGetEdt1 */ , /* @_cIniCpos */ , @_nMax1 , @_cDelLin1, 1 , @bBColor1, @bFColor1 } )
//


nOpcx1    := iif( _aGetDados[1,01]      == NIL .or. _aGetDados[1,1]  <3  , 3                , _aGetDados[1,01] )
aCols1    :=      _aGetDados[1,02]
aHeader1  :=      _aGetDados[1,03]
aCGD1     := Iif( Len(_aGetDados[1,04]) == 0                             , {34,5,128,315}   , _aGetDados[1,04] )
cLineOk1  := iif( _aGetDados[1,05]      == NIL                           , "ALLWAYSTRUE()"  , _aGetDados[1,05] )
cAllOk1   := iif( _aGetDados[1,06]      == NIL                           , "ALLWAYSTRUE()"  , _aGetDados[1,06] )
aGetsGD1  := iif( _aGetDados[1,07]      == NIL                           , NIL              , _aGetDados[1,07] )
cIniCpos1 := Iif( _aGetDados[1,08]      == Nil                           , " "              , _aGetDados[1,08] )
nMax1     := Iif( _aGetDados[1,09]      == Nil                           , 99               , _aGetDados[1,09] )
lDelGetD1 := Iif( _aGetDados[1,10]      == Nil                           , .t.              , _aGetDados[1,10] )
nFolder1  := Iif( _aGetDados[1,11]      == Nil .or. _aGetDados[1,11] <1  , 1                , _aGetDados[1,11] )

if len(_aGetDados[1]) > 11
	bBColor1  := Iif( _aGetDados[1,12]      == Nil                           , " "              , _aGetDados[1,12] )
	bFColor1  := Iif( _aGetDados[1,13]      == Nil                           , " "              , _aGetDados[1,13] )
	bchg1     := Iif( _aGetDados[1,14]      == Nil                           , " "              , _aGetDados[1,14] )
Endif

If len(_aGetDados) > 1
	nOpcX2    := Iif( _aGetDados[2,01]      == NIL .or. _aGetDados[2,1]  <1  , 3                , _aGetDados[2,01])
	aCols2    :=      _aGetDados[2,02]
	aHeader2  :=      _aGetDados[2,03]
	aCGD2     := Iif( Len(_aGetDados[2,04]) == 0                             , {34,5,128,315}   , _aGetDados[2,04])
	cLineOk2  := iif( _aGetDados[2,05]      == NIL                           , "ALLWAYSTRUE()"  , _aGetDados[2,05])
	cAllOk2   := iif( _aGetDados[2,06]      == NIL                           , "ALLWAYSTRUE()"  , _aGetDados[2,06])
	aGetsGD2  := iif( _aGetDados[2,07]      == NIL                           , NIL              , _aGetDados[2,07])
	cIniCpos2 := Iif( _aGetDados[2,08]      == Nil                           , ""               , _aGetDados[2,08])
	nMax2     := Iif( _aGetDados[2,09]      == Nil                           , 99               , _aGetDados[2,09])
	lDelGetD2 := Iif( _aGetDados[2,10]      == Nil                           , .t.              , _aGetDados[2,10])
	nFolder2  := Iif( _aGetDados[2,11]      == Nil .or. _aGetDados[2,11] <1  , 1                , _aGetDados[2,11])
	
	if len(_aGetDados[2]) > 11
		bBColor2  := Iif( _aGetDados[2,12]      == Nil                           , " "              , _aGetDados[2,12] )
		bFColor2  := Iif( _aGetDados[2,13]      == Nil                           , " "              , _aGetDados[2,13] )
	Endif
	
Endif

If len(_aGetDados) > 2
	nOpcX3    := Iif( _aGetDados[3,01]       == NIL .or. _aGetDados[3,1]  <1 , 3                , _aGetDados[3,01])
	aCols3    :=      _aGetDados[3,02]
	aHeader3  :=      _aGetDados[3,03]
	aCGD3     := Iif( Len(_aGetDados[3,04])  == 0                            , {34,5,128,315}   , _aGetDados[3,04])
	cLineOk3  := iif( _aGetDados[3,05]       == NIL                          , "ALLWAYSTRUE()"  , _aGetDados[3,05])
	cAllOk3   := iif( _aGetDados[3,06]       == NIL                          , "ALLWAYSTRUE()"  , _aGetDados[3,06])
	aGetsGD3  := iif( _aGetDados[3,07]       == NIL                          , NIL              , _aGetDados[3,07])
	cIniCpos3 := Iif( _aGetDados[3,08]       == Nil                          , ""               , _aGetDados[3,08])
	nMax3     := Iif( _aGetDados[3,09]       == Nil                          , 99               , _aGetDados[3,09])
	lDelGetD3 := Iif( _aGetDados[3,10]       == Nil                          , .t.              , _aGetDados[3,10])
	nFolder3  := Iif( _aGetDados[3,11]       == Nil .or. _aGetDados[3,11] <1 , 1                , _aGetDados[3,11])
	
	if len(_aGetDados[3]) > 11
		bBColor3  := Iif( _aGetDados[3,12]      == Nil                           , " "              , _aGetDados[3,12] )
		bFColor3  := Iif( _aGetDados[3,13]      == Nil                           , " "              , _aGetDados[3,13] )
	Endif
	
Endif

If len(_aGetDados) > 3
	nOpcX4    := Iif( _aGetDados[4,01]       == NIL .or. _aGetDados[4,1]  <1 , 3                , _aGetDados[4,01])
	aCols4    := _aGetDados[4,02]
	aHeader4  := _aGetDados[4,03]
	aCGD4     := Iif( Len(_aGetDados[4,04])  == 0                            , {34,5,128,315}   , _aGetDados[4,04])
	cLineOk4  := iif( _aGetDados[4,05]       == NIL                          , "ALLWAYSTRUE()"  , _aGetDados[4,05])
	cAllOk4   := iif( _aGetDados[4,06]       == NIL                          , "ALLWAYSTRUE()"  , _aGetDados[4,06])
	aGetsGD4  := iif( _aGetDados[4,07]       == NIL                          , NIL              , _aGetDados[4,07])
	cIniCpos4 := Iif( _aGetDados[4,08]       == Nil                          , ""               , _aGetDados[4,08])
	nMax4     := Iif( _aGetDados[4,09]       == Nil                          , 99               , _aGetDados[4,09])
	lDelGetD4 := Iif( _aGetDados[4,10]       == Nil                          , .t.              , _aGetDados[4,10])
	nFolder4  := Iif( _aGetDados[4,11]       == Nil .or. _aGetDados[4,11] <1 , 1                , _aGetDados[4,11])
	
	if len(_aGetDados[4]) > 11
		bBColor4  := Iif( _aGetDados[4,12]      == Nil                           , " "              , _aGetDados[4,12] )
		bFColor4  := Iif( _aGetDados[4,13]      == Nil                           , " "              , _aGetDados[4,13] )
	Endif
	
Endif

If len(_aGetDados) > 4
	nOpcX5    := Iif( _aGetDados[5,01]       == NIL .or. _aGetDados[5,1]  <1 , 3                , _aGetDados[5,01])
	aCols5    := _aGetDados[5,02]
	aHeader5  := _aGetDados[5,03]
	aCGD5     := Iif( Len(_aGetDados[5,04]) == 0                             , {34,5,128,315}   , _aGetDados[5,04])
	cLineOk5  := iif( _aGetDados[5,05]      == NIL                           , "ALLWAYSTRUE()"  , _aGetDados[5,05])
	cAllOk5   := iif( _aGetDados[5,06]      == NIL                           , "ALLWAYSTRUE()"  , _aGetDados[5,06])
	aGetsGD5  := iif( _aGetDados[5,07]      == NIL                           , NIL              , _aGetDados[5,07])
	cIniCpos5 := Iif( _aGetDados[5,08]      == Nil                           , ""               , _aGetDados[5,08])
	nMax5     := Iif( _aGetDados[5,09]      == Nil                           , 99               , _aGetDados[5,09])
	lDelGetD5 := Iif( _aGetDados[5,10]      == Nil                           , .t.              , _aGetDados[5,10])
	nFolder5  := Iif( _aGetDados[5,11]       ==Nil .or. _aGetDados[5,11] <1  , 1                , _aGetDados[5,11])
	
	if len(_aGetDados[5]) > 11
		bBColor5  := Iif( _aGetDados[5,12]      == Nil                           , " "              , _aGetDados[5,12] )
		bFColor5  := Iif( _aGetDados[5,13]      == Nil                           , " "              , _aGetDados[5,13] )
	Endif
Endif

If len(_aGetDados) > 5
	nOpcX6    := Iif( _aGetDados[6,01]      == NIL .or. _aGetDados[6,1]  <1   , 3               , _aGetDados[6,01])
	aCols6    := _aGetDados[6,02]
	aHeader6  := _aGetDados[6,03]
	aCGD6     := Iif( Len(_aGetDados[6,04]) == 0                              , {34,5,128,315}  , _aGetDados[6,04])
	cLineOk6  := iif( _aGetDados[6,05]      == NIL                            , "ALLWAYSTRUE()" , _aGetDados[6,05])
	cAllOk6   := iif( _aGetDados[6,06]      == NIL                            , "ALLWAYSTRUE()" , _aGetDados[6,06])
	aGetsGD6  := iif( _aGetDados[6,07]      == NIL                            , NIL             , _aGetDados[6,07])
	cIniCpos6 := Iif( _aGetDados[6,08]      == Nil                            , ""              , _aGetDados[6,08])
	nMax6     := Iif( _aGetDados[6,09]      == Nil                            , 99              , _aGetDados[6,09])
	lDelGetD6 := Iif( _aGetDados[6,10]      == Nil                            , .t.             , _aGetDados[6,10])
	nFolder6  := Iif( _aGetDados[6,11]      == Nil .or. _aGetDados[6,11] <1   , 1               , _aGetDados[6,11])
	
	if len(_aGetDados[6]) > 11
		bBColor6  := Iif( _aGetDados[6,12]      == Nil                           , " "              , _aGetDados[6,12] )
		bFColor6  := Iif( _aGetDados[6,13]      == Nil                           , " "              , _aGetDados[6,13] )
	Endif
	
Endif

nCount++

If nCount > 1
	
	oSaveGetd1 := oGetDados1
	oSaveGetd2 := oGetDados2
	oSaveGetd3 := oGetDados3
	oSaveGetd4 := oGetDados4
	oSaveGetd5 := oGetDados5
	oSaveGetd6 := oGetDados6
	
	oSaveGetd1:lDisablePaint := .t.
	oSaveGetd2:lDisablePaint := .t.
	oSaveGetd3:lDisablePaint := .t.
	oSaveGetd4:lDisablePaint := .t.
	oSaveGetd5:lDisablePaint := .t.
	oSaveGetd6:lDisablePaint := .t.
	
EndIf

If Type("aRotina") == "A"
	aSvRot := aClone(aRotina)
EndIf

aRotina := {}

For nX := 1 to nOpcx1
	AADD(aRotina,{"","",0,nOpcx1})
Next

aCordW  :=Iif( aCordW ==Nil , {125,0,400,635} , aCordW )

SetKey( VK_F4 , bF4 )

DEFINE MSDIALOG _oDlgCldBrw TITLE OemToAnsi(cTitulo) FROM aCordW[1],aCordW[2] TO aCordW[3],aCordW[4] PIXEL OF oDlgCldMain

if aFoltit <> nil
	
	oFolder  := TFolder():New( aFolPos[1], aFolPos[2], aFolTit, aFolDial, _oDlgCldBrw,,,, .T., , aFolPos[3],aFolPos[4] )
	
	odlg1    := oFolder:aDialogs[nFolder1]
	
	if len(aFolDial) <= nFolder2
		odlg2 := oFolder:aDialogs[nFolder2]
	Else
		odlg2 := oFolder:aDialogs[1]
	Endif
	
	if len(aFolDial) <= nFolder3
		odlg3 := oFolder:aDialogs[nFolder3]
	Else
		odlg3 := oFolder:aDialogs[1]
	Endif
	
	if len(aFolDial) <= nFolder4
		odlg4 := oFolder:aDialogs[nFolder4]
	Else
		odlg4 := oFolder:aDialogs[1]
	Endif
	
	if len(aFolDial) <= nFolder5
		odlg5 := oFolder:aDialogs[nFolder5]
	Else
		odlg5 := oFolder:aDialogs[1]
	Endif
	
	if len(aFolDial) <= nFolder6
		odlg6 := oFolder:aDialogs[nFolder6]
	Else
		odlg6 := oFolder:aDialogs[1]
	Endif
	
Else
	
	odlg1  := _oDlgCldBrw
	
Endif

For _nctd := 1 to Len(aC)
	
	If Len(Ac[_nctd]) > 20 // 21 e 22
		
		_cCaption   := Iif(Ac[_nctd,01] == NIL .OR. Empty(Ac[_nctd,01]) , " "        , Ac[_nctd,01])
		_cBlKSay    := "{|| OemToAnsi('"+_cCaption+"')}"
		_cCampo     := iif(Ac[_nctd,02] == NIL .OR. empty(Ac[_nctd,02])	, "_cFiller" , Ac[_nctd,02])
		_nX         := Ac[_nctd,03]
		_nY         := Ac[_nctd,04]
		_nLarsay    := Iif(Ac[_nctd,05] == 0   	, len(_cCaption) 		, Ac[_nctd,05])
		_nAltsay    := Iif(Ac[_nctd,06] == 0   	, NIL            		, Ac[_nctd,06])
		_nLarget    := Iif(Ac[_nctd,07] == 0   	, NIL  					, Ac[_nctd,07])
		_nAltget    := Iif(Ac[_nctd,08] == 0   	, NIL  					, Ac[_nctd,08])
		_cPict      := Iif(Empty(Ac[_nctd,09]) 	, NIL     				, Ac[_nctd,09])
		_cValid     := Iif(Empty(Ac[_nctd,10]) 	, ".T."   				, Ac[_nctd,10])
		_cF3        := Iif(Empty(Ac[_nctd,11]) 	, NIL     				, Ac[_nctd,11])
		_cWhen      := Iif(Ac[_nctd,12] == NIL 	, ".t." 				, Iif(Ac[_nctd,12] , ".t." ,".f."))
		_nTipo      := Ac[_nctd,13]
		_cFonsay    := Iif(Empty(Ac[_nctd,14])	, "NIL" 				, Ac[_nctd,14])
		_cFonGet    := Iif(Empty(Ac[_nctd,15])	, "NIL" 				, Ac[_nctd,15])
		_cCorlsay   := Iif(Empty(Ac[_nctd,16])	,  NIL  				, Ac[_nctd,16])
		_cCorfsay   := Iif(Empty(Ac[_nctd,17])	,  NIL  				, Ac[_nctd,17])
		_cCorlget   := Iif(Empty(Ac[_nctd,18])	,  NIL  				, Ac[_nctd,18])
		_cCorfget   := Iif(Empty(Ac[_nctd,19])	,  NIL  				, Ac[_nctd,19])
		_nFator     := Iif(Empty(Ac[_nctd,20])  ,  1.8					, Ac[_nctd,20])
		_lAlidir	:= Iif(Empty(Ac[_nctd,21])	, .f.  					, Ac[_nctd,21])
		
		If Len(Ac[_nctd]) > 21
			_aopcoes    := Iif(Empty(Ac[_nctd,22]), {} , Ac[_nctd,22])
		Else
			_aopcoes   := {}
		Endif
		
		_oCldSay := TSay():New( _nX-1  , _nY    , &_cBlKsay   , _oDlgCldBrw  ,         , &_cFonsay , .F.          , _lAlidir    , .F.        , .T.       , _cCorlsay   , _cCorfsay   , _nLarsay  , _nAltsay  , .F.       , .F.       , .F.         , .F.       , .F.         )
		//        TSay():New( <nRow> , <nCol> , <{cText}>   , <oWnd>      , <cPict> , <oFont>   , <.lCenter.>  , <.lRight.>  ,<.lBorder.> , <.lPixel.>, <nClrText>  , <nClrBack>  , <nWidth>  , <nHeight> , <.design.>, <.update.>, <.lShaded.> , <.lBox.>  , <.lRaised.> )
		
		AADD(_aSay,_oCldSay)
		
		_cCaption := _oCldSay:cCaption
		_nLargSay := GetTextWidth(0,_cCaption) / _nFator
		_cBlkGet  := "{ | u | If( PCount() == 0, "+_cCampo+","+_cCampo+":= u ) }"
		_cBlKVld  := "{|| "+_cValid+"}"
		_cBlKWhen := "{|| "+_cWhen+"}"
		
		if _nTipo == 1
			
			_oCldGet  := TGet():New( _nX     , _nY + _nLarsay  , &_cBlKGet       ,_oDlgCldBrw  , _nLarget   ,_nAltget    ,_cPict   , &(_cBlkVld)   , _cCorlget   , _cCorfget  , &_cFonGet , .F.       ,          , .T.      ,           , .F.       ,  &(_cBlkWhen) , .F.        , .F.       ,           ,   .F.       , .F.         ,   _cF3   , (_cCampo)  ,         ,         ,         ,         )
			
			AADD(_aGet,_oCldGet)
			
			
		Elseif _nTipo == 3
			
			_oCombo2     := TComboBox():New( _nX , _nY + _nLarsay  , &_cBlKGet, _aopcoes , _nLarget , _nAltget , _oDlgCldBrw , , , &(_cBlkVld), _cCorlget , _cCorfget , .T. , , "" , , &(_cBlKWhen) , , , , , (_cCampo) )
			
			AADD(_aGet,_oCombo2)
			
		Else
			
			_oCldSay  := TSay():New( _nX-1  ,  _nY + _nLarsay , &_cBlKGet   , _oDlgCldBrw , _cPict  , &_cFonget, .F.          , _lAlidir    , .F.        , .T.       , _cCorlget   , _cCorfget  , _nLarget  , _nAltget  , .F.       , .F.       , .F.         , .F.       , .F.         )
			//         TSay():New( <nRow> , <nCol>          , <{cText}>   , <oWnd>     , <cPict> , <oFont>  , <.lCenter.>  , <.lRight.>  ,<.lBorder.> , <.lPixel.>, <nClrText>  , <nClrBack> , <nWidth>  , <nHeight> , <.design.>, <.update.>, <.lShaded.> , <.lBox.>  , <.lRaised.> )
			AADD(_aSay,_oCldSay)
			
		Endif
		
	EndIf
	
Next

For _xy:= 1 to Len(_aGet)
	_aGet[_xy]:Refresh()
Next

For _xy:= 1 to Len(_aSay)
	_aSay[_xy]:Refresh()
Next

//oGetDados1:=MsNewGetDados():New(aCGD1[1], aCGD1[2], aCGD1[3], aCGD1[4], nOpcx1 ,"u_LineOK(cLineOK1)", "u_allok(cAllOk1,cLineOK1)", cIniCpos1, aGetsGD1,  , nMax1,"u_FieldOk()",  ,lDelGetD1, _oDlgCldBrw, aHeader1, aCols1 )

oGetDados1     := MsNewGetDados():New(aCGD1[1], aCGD1[2], aCGD1[3], aCGD1[4], nOpcx1 ,"u_LineOK1(cLineOK1)", "u_allok1(cAllOk1,cLineOK1)", cIniCpos1, aGetsGD1,  , nMax1,"u_FieldOk1()",  ,lDelGetD1, oDlg1, aHeader1, aCols1 )

//oGetDados1:AddAction("XLEGENDA",{||  Mrk1() })

IF !EMPTY(bBColor1) .AND. !EMPTY(bFColor1)
	oGetDados1:oBrowse:SetBlkBackColor(bBColor1)
	oGetDados1:oBrowse:SetBlkColor(bFColor1)
Endif

IF !EMPTY(bchg1)
	oGetDados1:oBrowse:bChange := &bchg1
Endif

If len(_aGetDados) > 1
	oGetDados2 := MsNewGetDados():New(aCGD2[1], aCGD2[2], aCGD2[3], aCGD2[4], nOpcX2,"u_LineOK2(cLineOK2)", "u_allok2(cAllOk2,cLineOK2)", cIniCpos2, aGetsGD2,  , nMax2,"u_FieldOk2()", , lDelGetD2, oDlg2, Aheader2, aCols2)
	
	IF !EMPTY(bBColor2) .AND. !EMPTY(bFColor2)
		oGetDados2:oBrowse:SetBlkBackColor(bBColor2)
		oGetDados2:oBrowse:SetBlkColor(bFColor2)
	Endif
	
Else
	oGetDados2 := oGetDados1
	aCols2     :=  aCols1
Endif

If len(_aGetDados) > 2
	oGetDados3 := MsNewGetDados():New(aCGD3[1], aCGD3[2], aCGD3[3], aCGD3[4], nOpcX3,"u_LineOK3(cLineOK3)", "u_allok3(cAllOk3,cLineOK3)", cIniCpos3, aGetsGD3,  , nMax3,"u_FieldOk3()", , lDelGetD3, oDlg3, Aheader3, aCols3)
	
	IF !EMPTY(bBColor3) .AND. !EMPTY(bFColor3)
		oGetDados3:oBrowse:SetBlkBackColor(bBColor3)
		oGetDados3:oBrowse:SetBlkColor(bFColor3)
	Endif
	
Else
	oGetDados3 := oGetDados1
	aCols3     :=  aCols1
Endif

If len(_aGetDados) > 3
	oGetDados4 := MsNewGetDados():New(aCGD4[1], aCGD4[2], aCGD4[3], aCGD4[4], nOpcX4,"u_LineOK4(cLineOK4)", "u_allok4(cAllOk4,cLineOK4)", cIniCpos4, aGetsGD4,  , nMax4,"u_FieldOk4()", , lDelGetD4, oDlg4, Aheader4, aCols4)
	
	IF !EMPTY(bBColor4) .AND. !EMPTY(bFColor4)
		oGetDados4:oBrowse:SetBlkBackColor(bBColor4)
		oGetDados4:oBrowse:SetBlkColor(bFColor4)
	Endif
	
Else
	oGetDados4 := oGetDados1
	aCols4     :=  aCols1
Endif

If len(_aGetDados) > 4
	oGetDados5 := MsNewGetDados():New(aCGD5[1], aCGD5[2], aCGD5[3], aCGD5[4], nOpcX5,"u_LineOK5(cLineOK4)", "u_allok5(cAllOk5,cLineOK5)", cIniCpos5, aGetsGD5,  , nMax5,"u_FieldOk5()", , lDelGetD5, oDlg5, Aheader5, aCols5)
	
	IF !EMPTY(bBColor5) .AND. !EMPTY(bFColor5)
		oGetDados5:oBrowse:SetBlkBackColor(bBColor5)
		oGetDados5:oBrowse:SetBlkColor(bFColor5)
	Endif
	
Else
	oGetDados5 := oGetDados1
	aCols5     :=  aCols1
Endif

If len(_aGetDados) > 5
	oGetDados6 := MsNewGetDados():New(aCGD6[1], aCGD6[2], aCGD6[3], aCGD6[4], nOpcX6,"u_LineOK6(cLineOK4)", "u_allok6(cAllOk6,cLineOK6)", cIniCpos6, aGetsGD6,  , nMax6,"u_FieldOk6()", , lDelGetD6, oDlg6, Aheader6, aCols6)
	
	IF !EMPTY(bBColor6) .AND. !EMPTY(bFColor6)
		oGetDados6:oBrowse:SetBlkBackColor(bBColor6)
		oGetDados6:oBrowse:SetBlkColor(bFColor6)
	Endif
	
Else
	oGetDados6 := oGetDados1
	aCols6     :=  aCols1
Endif

For _nctd := 1 to Len(Ar)
	
	If Len(Ar[_nctd]) > 20 // == 21
		
		_cCaption   := Iif(Ar[_nctd,01] == NIL .OR. Empty(Ar[_nctd,01]), " "     , Ar[_nctd,01])
		_cBlKSay    := "{|| OemToAnsi('"+_cCaption+"')}"
		_cCampo     := iif(Ar[_nctd,02] == NIL .OR. empty(Ar[_nctd,02]), "_cFiller", Ar[_nctd,02])
		_nX         := Ar[_nctd,03]
		_nY         := Ar[_nctd,04]
		_nLarsay    := Iif(Ar[_nctd,05] == 0   , len(_cCaption), Ar[_nctd,05])
		_nAltsay    := Iif(Ar[_nctd,06] == 0   , NIL   , Ar[_nctd,06])
		_nLarget    := Iif(Ar[_nctd,07] == 0   , NIL   , Ar[_nctd,07])
		_nAltget    := Iif(Ar[_nctd,08] == 0   , NIL   , Ar[_nctd,08])
		_cPict      := Iif(Empty(Ar[_nctd,09]) , NIL   , Ar[_nctd,09])
		_cValid     := Iif(Empty(Ar[_nctd,10]) , ".T." , Ar[_nctd,10])
		_cF3        := Iif(Empty(Ar[_nctd,11]) , NIL   , Ar[_nctd,11])
		_cWhen      := Iif(Ar[_nctd,12] == NIL , ".t." , Iif(Ar[_nctd,12] , ".t." ,".f."))
		_nTipo      := Ar[_nctd,13]
		_cFonsay    := Iif(Empty(Ar[_nctd,14]) , "NIL" , Ar[_nctd,14])
		_cFonGet    := Iif(Empty(Ar[_nctd,15]) , "NIL" , Ar[_nctd,15])
		_cCorlsay   := Iif(Empty(Ar[_nctd,16]) , NIL   , Ar[_nctd,16])
		_cCorfsay   := Iif(Empty(Ar[_nctd,17]) , NIL   , Ar[_nctd,17])
		_cCorlget   := Iif(Empty(Ar[_nctd,18]) , NIL   , Ar[_nctd,18])
		_cCorfget   := Iif(Empty(Ar[_nctd,19]) , NIL   , Ar[_nctd,19])
		_nFator     := Ar[_nctd,20]
		_lAlidir	:= Iif(Empty(Ar[_nctd,21]) , .f.  , Ar[_nctd,21])
		
		If Len(Ar[_nctd]) > 21
			_aopcoes    := Iif(Empty(Ar[_nctd,22]), {} , Ar[_nctd,22])
		Else
			_aopcoes   := {}
		Endif
		
		//        TSay():New( <nRow> , <nCol> , <{cText}>   , <oWnd>   , <cPict> , <oFont>   , <.lCenter.>  , <.lRight.>  ,<.lBorder.> , <.lPixel.>, <nClrText>  , <nClrBack>  , <nWidth>  , <nHeight> , <.design.>, <.update.>, <.lShaded.> , <.lBox.>  , <.lRaised.> )
		
		_oCldSay := TSay():New( _nX-1  , _nY    , &_cBlKsay   ,_oDlgCldBrw,         , &_cFonsay, .F.           , _lAlidir    , .f.        , .t.       , _cCorlsay   , _cCorfsay   , _nLarsay  , _nAltsay  , .F.       , .F.       , .F.         , .F.       , .F.         )
		
		AADD(_aSay,_oCldSay)
		
		_cCaption :=  _oCldSay:cCaption
		_nLargSay :=  GetTextWidth(0,_cCaption) / _nFator
		_cBlkGet  :=  "{ | u | If( PCount() == 0, "+_cCampo+","+_cCampo+":= u ) }"
		_cBlKVld  :=  "{|| "+_cValid+"}"
		_cBlKWhen :=  "{|| "+_cWhen+"}"
		
		if _nTipo == 1
			
			_oCldGet  := TGet():New( _nX    , _nY + _nLarsay  , &_cBlKGet       ,_oDlgCldBrw  , _nLarget   ,_nAltget    ,_cPict   , &(_cBlkVld)   , _cCorlget   , _cCorfget  , &_cFonGet , .F.       ,          , .T.      ,           , .F.       ,  &(_cBlkWhen) , .T.        , .F.       ,                                     ,   .F.       , .F.         ,_cF3           , (_cCampo)  ,         ,  .F.    ,         ,  .F.    )
			
			AADD(_aGet,_oCldGet)
			
		Elseif _nTipo == 3
			
			_oCombo2     := TComboBox():New( _nX , _nY + _nLarsay  , &_cBlKGet, _aopcoes , _nLarget , _nAltget , _oDlgCldBrw , , , &(_cBlkVld) , _cCorlget , _cCorfget , .T. , , "" , , &(_cBlKWhen) , , , , , (_cCampo) )
			
			AADD(_aGet,_oCombo2)
			
			
		Else
			
			_oCldSay  := TSay():New( _nX-1  ,  _nY + _nLarsay , &_cBlKGet   , _oDlgCldBrw , _cPict  , &_cFonget, .F.          , _lAlidir    , .T.        , .T.       , _cCorlget   , _cCorfget   , _nLarget  , _nAltget  , .F.       , .F.       , .F.         , .F.       , .F.         )
			
			AADD(_aSay,_oCldSay)
			
		Endif
		
	EndIf
	
Next

For _xy:= 1 to Len(_aGet)
	_aGet[_xy]:Refresh()
Next

For _xy:= 1 to Len(_aSay)
	_aSay[_xy]:Refresh()
Next


//ACTIVATE MSDIALOG _oDlgCldBrw ON INIT EnchoiceBar( _oDlgCldBrw, {|| _nOpca:=1, alert("Grid Natureza:"+str(len(ogetdados1:acols),2)+chr(13)+"Grid Custos: "+str(len(ogetdados2:acols),2) ), lAllOk := (u_allOK(cAllOk1,cLineOK1) .and. u_allOK2(cAllOk2,cLineOK2) ), Iif( lAllOk, _oDlgCldBrw:End() , _nOpca := 0 ) } , {||_oDlgCldBrw:End()} )
//ACTIVATE MSDIALOG _oDlgCldBrw ON INIT EnchoiceBar( _oDlgCldBrw , {|| _nOpca:= 1 , lAllOk := (u_allOK1(cAllOk1,cLineOK1) .and. u_allOK2(cAllOk2,cLineOK2) .and. u_allOK3(cAllOk3,cLineOK3) .and. u_allOK4(cAllOk4,cLineOK4) .and. u_allOK5(cAllOk5,cLineOK5) .and. u_allOK6(cAllOk6,cLineOK6) ), aCols1 := aclone(ogetdados1:acols), aCols2 := aclone(ogetdados2:acols), aCols3 := aclone(ogetdados3:acols), aCols4 := aclone(ogetdados4:acols), aCols5 := aclone(ogetdados5:acols), aCols6 := aclone(ogetdados6:acols), Iif( lAllOk , _oDlgCldBrw:End() , _nOpca := 0 ) } ,  {||_oDlgCldBrw:End()}, , aButBar  ) centered
ACTIVATE MSDIALOG _oDlgCldBrw ON INIT EnchoiceBar( _oDlgCldBrw , {|| _nOpca:= 1 , lAllOk := (u_allOK1(cAllOk1,cLineOK1) .and. u_allOK2(cAllOk2,cLineOK2) .and. u_allOK3(cAllOk3,cLineOK3) .and. u_allOK4(cAllOk4,cLineOK4) .and. u_allOK5(cAllOk5,cLineOK5) .and. u_allOK6(cAllOk6,cLineOK6) ), aCols1 := aclone(ogetdados1:acols), aCols2 := aclone(ogetdados2:acols), aCols3 := aclone(ogetdados3:acols), aCols4 := aclone(ogetdados4:acols), aCols5 := aclone(ogetdados5:acols), aCols6 := aclone(ogetdados6:acols), Iif( lAllOk , _oDlgCldBrw:End() , _nOpca := 0 ) } ,  {||_oDlgCldBrw:End()},, aBotoes  ) centered
//

nCount--

If nCount > 0
	
	oGetDados1 := oSaveGetD1
	oGetDados1:lDisablePaint := .f.
	
	oGetDados2 := oSaveGetD2
	oGetDados2:lDisablePaint := .f.
	
	oGetDados3 := oSaveGetD3
	oGetDados3:lDisablePaint := .f.
	
	oGetDados4 := oSaveGetD4
	oGetDados4:lDisablePaint := .f.
	
	oGetDados5 := oSaveGetD5
	oGetDados5:lDisablePaint := .f.
	
	oGetDados6 := oSaveGetD6
	oGetDados6:lDisablePaint := .f.
	
EndIf

If ValType(aSvRot) == "A"
	aRotina := aClone(aSvRot)
EndIf

SetKey( VK_F4, {|| })

Return ( _nOpca == 1 )


///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
// Validacao do Grid 1
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////
user Function LineOk1(cLineOK1)
//////////////////////////////////////////////
Local lRet := .t.
Local _xy := 0

If Str(nOpcx1,1,0) $ "34567"
	lRet := &(cLineOK1)
Endif

For _xy:= 1 to Len(_aGet)
	_aGet[_xy]:Refresh()
Next

For _xy:= 1 to Len(_aSay)
	_aSay[_xy]:Refresh()
Next

Dlgrefresh(_oDlgCldBrw)
oGetDados1:refresh()

Return lRet


//////////////////////////////////////////////
user Function allok1(cAllOk1,cLineOK1)
//////////////////////////////////////////////

lRet := u_LineOk1(cLineOK1)

If lRet
	lRet := &(cAllOk1)
EndIf

Return lRet


//////////////////////////////////////////////////
//////////////////////////////////////////////////
user Function FieldOk1()
//////////////////////////////////////////////////
//////////////////////////////////////////////////
Local _xy

For _xy:= 1 to Len(_aGet)
	_aGet[_xy]:Refresh()
Next

For _xy:= 1 to Len(_aSay)
	_aSay[_xy]:Refresh()
Next

Dlgrefresh(_oDlgCldBrw)
oGetDados1:refresh()

Return .t.


///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
// Validacao do Grid 2
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////
user Function LineOk2(cLineOK2)
//////////////////////////////////////////////
Local lRet := .t.
Local _xy := 0 
If Str(nOpcx2,1,0) $ "34567"
	lRet := &(cLineOK2)
Endif

For _xy:= 1 to Len(_aGet)
	_aGet[_xy]:Refresh()
Next

For _xy:= 1 to Len(_aSay)
	_aSay[_xy]:Refresh()
Next

Dlgrefresh(_oDlgCldBrw)
oGetDados2:refresh()

Return lRet

//////////////////////////////////////////////
user Function allok2(cAllOk2,cLineOK2)
//////////////////////////////////////////////

lRet := u_LineOk2(cLineOK2)

If lRet
	lRet := &(cAllOk2)
EndIf

Return lRet


//////////////////////////////////////////////////
user Function FieldOk2()
//////////////////////////////////////////////////

Local _xy

For _xy:= 1 to Len(_aGet)
	_aGet[_xy]:Refresh()
Next

For _xy:= 1 to Len(_aSay)
	_aSay[_xy]:Refresh()
Next

Dlgrefresh(_oDlgCldBrw)
oGetDados2:refresh()

Return .t.

///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
// Validacao do Grid 3
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////
user Function LineOk3(cLineOK3)
//////////////////////////////////////////////
Local lRet := .t.
Local _xy := 0

If Str(nOpcx3,1,0) $ "34567"
	lRet := &(cLineOK3)
Endif

For _xy:= 1 to Len(_aGet)
	_aGet[_xy]:Refresh()
Next

For _xy:= 1 to Len(_aSay)
	_aSay[_xy]:Refresh()
Next

Dlgrefresh(_oDlgCldBrw)
oGetDados3:refresh()

Return lRet

//////////////////////////////////////////////
user Function allok3(cAllOk3,cLineOK3)
//////////////////////////////////////////////

lRet := u_LineOk3(cLineOK3)

If lRet
	lRet := &(cAllOk3)
EndIf

Return lRet

//////////////////////////////////////////////////
user Function FieldOk3()
//////////////////////////////////////////////////

Local _xy

For _xy:= 1 to Len(_aGet)
	_aGet[_xy]:Refresh()
Next

For _xy:= 1 to Len(_aSay)
	_aSay[_xy]:Refresh()
Next

Dlgrefresh(_oDlgCldBrw)
oGetDados3:refresh()

Return .t.


///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
// Validacao do Grid 4
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////
user Function LineOk4(cLineOK4)
//////////////////////////////////////////////
Local lRet := .t.
Local _xy := 0 

If Str(nOpcx4,1,0) $ "34567"
	lRet := &(cLineOK4)
Endif

For _xy:= 1 to Len(_aGet)
	_aGet[_xy]:Refresh()
Next

For _xy:= 1 to Len(_aSay)
	_aSay[_xy]:Refresh()
Next

Dlgrefresh(_oDlgCldBrw)
oGetDados4:refresh()

Return lRet

//////////////////////////////////////////////
user Function allok4(cAllOk4,cLineOK4)
//////////////////////////////////////////////

lRet := u_LineOk4(cLineOK4)

If lRet
	lRet := &(cAllOk4)
EndIf

Return lRet

//////////////////////////////////////////////////
user Function FieldOk4()
//////////////////////////////////////////////////

Local _xy

For _xy:= 1 to Len(_aGet)
	_aGet[_xy]:Refresh()
Next

For _xy:= 1 to Len(_aSay)
	_aSay[_xy]:Refresh()
Next

Dlgrefresh(_oDlgCldBrw)
oGetDados4:refresh()

Return .t.


///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
// Validacao do Grid 5
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////
user Function LineOk5(cLineOK5)
//////////////////////////////////////////////
Local lRet := .t.
Local _xy := 0

If Str(nOpcx5,1,0) $ "34567"
	lRet := &(cLineOK5)
Endif

For _xy:= 1 to Len(_aGet)
	_aGet[_xy]:Refresh()
Next

For _xy:= 1 to Len(_aSay)
	_aSay[_xy]:Refresh()
Next

Dlgrefresh(_oDlgCldBrw)
oGetDados5:refresh()

Return lRet

//////////////////////////////////////////////
user Function allok5(cAllOk5,cLineOK5)
//////////////////////////////////////////////

lRet := u_LineOk5(cLineOK5)

If lRet
	lRet := &(cAllOk5)
EndIf

Return lRet


//////////////////////////////////////////////////
user Function FieldOk5()
//////////////////////////////////////////////////
Local _xy

For _xy:= 1 to Len(_aGet)
	_aGet[_xy]:Refresh()
Next

For _xy:= 1 to Len(_aSay)
	_aSay[_xy]:Refresh()
Next

Dlgrefresh(_oDlgCldBrw)
oGetDados5:refresh()

Return .t.



///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
// Validacao do Grid 6
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////
user Function LineOk6(cLineOK6)
//////////////////////////////////////////////
Local lRet := .t.
Local _xy:= 0 
If Str(nOpcx6,1,0) $ "34567"
	lRet := &(cLineOK6)
Endif

For _xy:= 1 to Len(_aGet)
	_aGet[_xy]:Refresh()
Next

For _xy:= 1 to Len(_aSay)
	_aSay[_xy]:Refresh()
Next

Dlgrefresh(_oDlgCldBrw)
oGetDados6:refresh()

Return lRet

//////////////////////////////////////////////
user Function allok6(cAllOk6,cLineOK6)
//////////////////////////////////////////////

lRet := u_LineOk6(cLineOK6)

If lRet
	lRet := &(cAllOk6)
EndIf

Return lRet

//////////////////////////////////////////////////
user Function FieldOk6()
//////////////////////////////////////////////////
Local _xy:= 0 

For _xy:= 1 to Len(_aGet)
	_aGet[_xy]:Refresh()
Next

For _xy:= 1 to Len(_aSay)
	_aSay[_xy]:Refresh()
Next

Dlgrefresh(_oDlgCldBrw)
oGetDados6:refresh()

Return .t.

//********************************

static Function CallMod2Obj()
Return oGetDados1

//********************************

//MsNewGetDados():New( nSuperior, nEsquerda ,nInferior, nDireita, nOpc,   cLinOk    , cTudoOk    , cIniCpos                 , aAlterGDa, nFreeze               , nMax    ,cFieldOk     , cSuperDel       , cDelOk, oDLG, aHeader, aCols)
//	nSuperior 	Distancia entre a MsNewGetDados e o extremidade superior do objeto que a contem
//	nEsquerda 	Distancia entre a MsNewGetDados e o extremidade esquerda do objeto que a contem
//	nInferior	Distancia entre a MsNewGetDados e o extremidade inferior do objeto que a contem
//	nDireita	Distancia entre a MsNewGetDados e o extremidade direita do objeto que a contem
//	nOpc		Operação em execução: 2- Visualizar, 3- Incluir, 4- Alterar, 5- Excluir
//	cLinOk 		Função executada para validar o contexto da linha atual do aCols
//	cTudoOk		Função executada para validar o contexto geral da MsNewGetDados (todo aCols)
//	cIniCpos	Nome dos campos do tipo caracter que utilizarão incremento automático.
//	aAlterGDa	Campos alteráveis da GetDados
//	nFreeze		Campos estáticos na GetDados, partindo sempre da posição inicial da getdados aonde:
//				1- Primeiro campo congelado
//				2- Primeiro e segundo campos congelados...
//	nMax		Número máximo de linhas permitidas. Valor padrão 99
//	cFieldOk	Função executada na validação do campo
//	cSuperDel	Função executada quando pressionada as teclas <Ctrl>+<Delete>
//	cDelOk		Função executada para validar a exclusão de uma linha do aCols
//	oDLG		Objeto no qual a MsNewGetDados será criada
//	aHeader		Array a ser tratado internamente na MsNewGetDados como aHeader
//	aCols		Array a ser tratado internamente na MsNewGetDados como aCols


// MSGETDADOS():NEW( nSuperior, nEsquerda, nInferior, nDireita, nOpc, [ cLinhaOk ], [ cTudoOk ], [ cIniCpos ], [ lApagar ], [ aAlter ], [ uPar1 ], [ lVazio ], [ nMax ], [ cCampoOk ], [ cSuperApagar ], [ uPar2 ], [ cApagaOk ], [ oWnd ] ) -> objeto

// 	Argumentos		Descrição

// 	nSuperior		Distancia entre a MsGetDados e o extremidade superior do objeto que a contém.
// 	nEsquerda		Distancia entre a MsGetDados e o extremidade esquerda do objeto que a contém.
// 	nInferior		Distancia entre a MsGetDados e o extremidade inferior do objeto que a contém.
// 	nDireita		Distancia entre a MsGetDados e o extremidade direita do objeto que a contém.
// 	nOpc			Posição do elemento do vetor aRotina que a MsGetDados usará como referencia.
// 	cLinhaOk		Função executada para validar o contexto da linha atual do aCols.
// 	cTudoOk			Função executada para validar o contexto geral da MsGetDados (todo aCols).
// 	cIniCpos		Nome dos campos do tipo caracter que utilizarão incremento automático. Este parâmetro deve ser no formato "+<nome do primeiro campo>+<nome do segundo campo>+...".
// 	lApagar			Habilita deletar linhas do aCols. Valor padrão falso.
// 	aAlter			Vetor com os campos que poderão ser alterados.
// 	uPar1			Parâmetro reservado.
// 	lVazio			Habilita validação da primeira coluna do aCols para esta não poder estar vazia. Valor padrão falso.
// 	nMax			Número máximo de linhas permitidas. Valor padrão 99.
// 	cCampoOk		Função executada na validação do campo.
// 	cSuperApagar	Função executada quando pressionada as teclas <Ctrl>+<Delete>.
// 	uPar2			Parâmetro reservado.
// 	cApagaOk		Função executada para validar a exclusão de uma linha do aCols.
// 	oWnd			Objeto no qual a MsGetDados será criada.

// Retorno 		Objeto.


//                               1       2        3         4         5           6           7          8            9        10          11         12          13           14       15         16         17          18        19        20        21         22       23        24         25        26         27
//                       New( [nRow], [nCol], [nWidth], [nHeigth], [bFields], [aHeaders], [aColSizes], [oDlg]   , [cField], [uValue1], [uValue2], [uChange], [uLDblClick], [uRClick], [oFont], [oCursor], [nClrFore], [nClrBack], [cMsg], [lUpdate], [cAlias] , [lPixel], [bWhen], [lDesign], [bValid], [aAlter], [oMother] )

//_oBrowse := BrGetDDB():New(    1  ,    3  ,    350  ,     100  ,          ,           ,            , oDlgPesq ,         ,          ,          ,          ,             ,          ,        ,          ,           ,           ,       ,    .F.   , 'PESTMP' ,    .T.  ,        ,    .F.   ,         ,         ,           )

// Propriedades:
// 	+	 - Herdadas da classe superior
// 	nAt  - Linha atualmente selecionada / posicionada no objeto
// 	nLen - Número total de linhas do objeto
//
// Parâmetros:
// 	01 - nRow 		- Numérico, opcional. Coordenada vertical
// 	02 - nCol 		- Numérico, opcional. Coordenada horizontal
// 	03 - nWidth  	- Numérico, opcional. Largura do objeto
//  04 - nHeight 	- Numérico, opcional. Altura do objeto
// 	05 - bFields 	- Bloco de código, Lista de Campos
// 	06 - aHeaders 	- Vetor, Descrição dos campos para no cabeçalho
// 	07 - aColSizes 	- Vetor, Largura das colunas
// 	08 - oDlg 		- Objeto, opcional. Janela ou controle onde o divisor deverá ser criado.
// 	09 - cField 	- Caracter, opcional. Campos necessários ao filtro
// 	10 - uValue1 	- Indefinido, opcional. Inicio do intervalo para o filtro
// 	11 - uValue2 	- Indefinido, opcional. Fim do intervalo para o filtro
// 	12 - bChange 	- Bloco de código, opcional. Executado quando o item selecionado é alterado.
// 	13 - bLDblClick - Bloco de código, opcional. Executado quando acionado duplo click do botão esquerdo do mouse sobre o controle.
// 	14 - bRClick 	- Não utilizado
// 	15 - oFont 		- Objeto, opcional. Fonte
// 	16 - oCursor 	- Objeto, opcional. Tipo do Cursor
// 	17 - nClrFore 	- Numérico, opcional. Cor do texto da janela.
// 	18 - nClrBack 	- Numérico, opcional. Cor de fundo da janela.
// 	09 - cMsg 		- Caracter, opcional. Mesamge ao posicionar o mouse sobre o objeto
// 	20 - lUpdate 	- Não utilizado
// 	21 - cAlias 	- Caracter, opcional se objeto utilizado com Vetor, obrigatorio se utilizado com Tabela
// 	22 - lPixel 	- Lógico, opcional. Se .T. as coordenadas informadas são em pixels, se .F. são em caracteres.
// 	23 - bWhen 		- Bloco de código, opcional. Executado quando mudança de foco de entrada de dados está sendo efetuada na janela onde o controle foi criado. O bloco deve retornar .T. se o controle deve permanecer habilitado ou .F. se não.
// 	24 - lDesign 	- Não Utilizado
// 	25 - bValid 	- Bloco de código, opcional. Executado quando o conteúdo do controle deve ser validado, deve retornar .T. se o conteúdo for válido e .F. quando o conteúdo for inválido.
// 	26 - aAlter 	- Não Utilizado
// 	27 - oMother 	- Não Utilizado

//_oBrowse:AddColumn(TCColumn():New(' '          ,{||PESTMP->A2_OK     },                         , , , 'LEFT' , , .T. , .F. , , , , .F. , ))
//_oBrowse:AddColumn(TCColumn():New('Cod.  '     ,{||PESTMP->A2_COD    },"@!"                     , , , 'LEFT' , , .F. , .F. , , , , .F. , ))
//_oBrowse:AddColumn(TCColumn():New('Descricao'  ,{||PESTMP->A2_NOME   },"@!"                     , , , 'LEFT' , , .F. , .F. , , , , .F. , ))
//_oBrowse:AddColumn(TCColumn():New('Fantasia'   ,{||PESTMP->A2_NREDUZ },                         , , , 'LEFT' , , .F. , .F. , , , , .F. , ))
//_oBrowse:AddColumn(TCColumn():New('UF'         ,{||PESTMP->A2_EST    },                         , , , 'LEFT' , , .F. , .F. , , , , .F. , ))
//_oBrowse:AddColumn(TCColumn():New('CNPJ'       ,{||PESTMP->A2_CGC    },"@R 99.999.999/9999-99"  , , , 'LEFT' , , .F. , .F. , , , , .F. , ))

// TCColumn(): New ( < cTitulo>, < bData>, [ cPicture], [ uParam4], [ uParam5], [ cAlinhamento], [ nLargura], [ uParam8], [ lEdit], [ uParam10], [ bValid], [ uParam12], [ uParam13], [ uParam14] ) --> Nil
//
// cTitulo		- Caracter	- Indica o título da coluna.
// bData	 	- Bloco de código - Indica o bloco de código que contém o campo da tabela que será apresentado no browse.
// cPicture 	- Caracter	- Indica a picture necessária para edição da coluna.
// uParam4	 	- Qualquer	- Compatibilidade.
// uParam5	 	- Qualquer	- Compatibilidade.
// cAlinhamento- Caracter	- Indica o tipo de alinhamento da coluna. Sendo: Left (à esquerda), Center (centralizada) ou Right (à direita).
// nLargura		- Numérico	- Indica a largura da coluna.
// uParam8 		- Qualquer	- Indica se, verdadeiro (.T.), a coluna é uma imagem; caso contrário, falso (.F.) (conteúdo padrão).
// lEdit 		- Lógico 	- Compatibilidade.
// uParam10 	- Qualquer	- Compatibilidade.
// bValid 		- Bloco de código - Indica o bloco de código de validação que será executado quando o conteúdo do objeto for modificado. Retorna verdadeiro (.T.), se o conteúdo é válido; caso contrário, falso (.F.).
// uParam12 	- Qualquer	- Compatibilidade.
// uParam13 	- Qualquer	- Compatibilidade.
// uParam14 	- Qualquer	- Compatibilidade.

//_oBrowse:bLDblClick    := { || PESTMP->A2_OK := iif(PESTMP->A2_OK == getmark(),thismark(), getmark() ), _oBrowse:refresh() }
//_oBrowse:bWhen         := { || visproduto() }
//_oBrowse:bChange         := { || visproduto() }


//_aSize   := MsAdvSize()

//alert( len(_asize))

//alert( "MsAdvSize() " + chr(10)+;
//'WorkArea - Lin Ini: ' +str(_aSize[1],5,0) + chr(10)+;
//'WorkArea - Col Ini: ' +str(_aSize[2],5,0) + chr(10)+;
//'WorkArea - Lin Fim: ' +str(_aSize[4],5,0) + chr(10)+;
//'WorkArea - Col Fim: ' +str(_aSize[3],5,0) + chr(10) + chr(10)+;
//'Dialog   - Lin Ini: ' +str(_aSize[7],5,0) + chr(10) + ;
//'Dialog   - Lin Fim: ' +str(_aSize[6],5,0) + chr(10) + ;
//'Dialog   - Col Fim: ' +str(_aSize[5],5,0) )


// Retorno   ExpA1 -> Dimensoes da janela / area de trabalho
//               1 -> Linha inicial area trabalho
//               2 -> Coluna inicial area trabalho
//               3 -> Coluna final area trabalho
//               4 -> Linha final area trabalho
//               5 -> Coluna final dialog
//               6 -> Linha final dialog
//               7 -> Linha inicial dialog


//TButton(): New ( [ nRow], [ nCol], [ cCaption], [ oWnd], [ bAction], [ nWidth], [ nHeight], [ uParam8], [ oFont], [ uParam10], [ lPixel], [ uParam12], [ uParam13], [ uParam14], [ bWhen], [ uParam16], [ uParam17] )

// Principais commandos
// TButton():New(140,010, 'GoUp()'                           , oDlgPesq, {|| _oBrowse:GoUp() }            ,40,10,,,,.T.)
// TButton():New(140,060, 'GoDown()'                         , oDlgPesq, {|| _oBrowse:GoDown() }          ,40,10,,,,.T.)
// TButton():New(140,110, 'GoTop()'                          , oDlgPesq, {|| _oBrowse:GoTop() }           ,40,10,,,,.T.)
// TButton():New(140,160, 'GoBottom()'                       , oDlgPesq, {|| _oBrowse:GoBottom() }        ,40,10,,,,.T.)
// TButton():New(140,210, 'nAt (Linha selecionada)'          , oDlgPesq, {|| Alert (_oBrowse:nAt)}        ,80,10,,,,.T.)
// TButton():New(140,260, 'nRowCount (Nr de linhas visiveis)', oDlgPesq, {|| Alert(_oBrowse:nRowCount()) },80,10,,,,.T.)
// TButton():New(140,310, 'nLen (Numero total de linhas)'    , oDlgPesq, {|| Alert(_oBrowse:nLen) }       ,80,10,,,,.T.)



//                          1           2              3                4              5           6            7        8                9             10          11          12          13        14          15          16         17              18            19          20            21           22           23         24          25        26        27        28
//         TGet():New( [anRow] , [anCol]         , [abSetGet]      , [aoWnd]    , [anWidth]  , [anHeight] , [acPict], [abValid]     , [anClrFore] , [anClrBack], [aoFont]  , [lPar12]  , [oPar13] , [alPixel], [cPar15]  , [lPar16]  , [abWhen]      , [lPar18]   , [lPar19]  , [abChange], [alReadOnly], [alPassword], [cPar23] , [acReadVar], [cPar25], [lPar26], [nPar27], [lPar28])
//
// Parametros:
// 01 - anRow		Numerico, opcional. Coordenada vertical em pixels ou caracteres.
// 02 - anCol		Numerico, opcional. Coordenada horizontal em pixels ou caracteres.
// 03 - abSetGet	Bloco de codigo, opcional. Bloco de codigo no formato {|u| IF( Pcount( )>0, <var>:= u, <var> ) } que o controle utiliza para atualizar a variavel <var>. <var> deve ser tipo caracter, numerico ou data.
// 04 - aoWnd		Objeto, opcional. Janela ou controle onde o controle sera criado.
// 05 - anWidth		Numerico, opcional. Largura do controle em pixels.
// 06 - anHeight	Numerico, opcional. Altura do controle em pixels.
// 07 - acPict		Caractere, opcional. Mascara de formatacao do conteudo a ser exibido.
// 08 - abValid     Bloco de codigo, opcional. Executado quando o conteudo do controle deve ser validado, deve retornar .T. se o conteudo for valido e .F. quando o conteudo for invalido.
// 09 - anClrFore	Numerico, opcional. Cor de fundo do controle.
// 10 - anClrBack   Numerico, opcional. Cor do texto do controle.
// 11 - aoFont      Objeto, opcional. Objeto tipo tFont utilizado para definir as caracteristicas da fonte utilizada para exibir o conteudo do controle.
// 12 - lPar12		Reservado.
// 13 - oPar13		Reservado.
// 14 - alPixel		Logico, opcional. Se .T. as coordenadas informadas sao em pixels, se .F. sao em caracteres.
// 15 - cPar15 		Reservado.
// 16 - lPar16		Reservado.
// 17 - abWhen		Bloco de codigo, opcional. Executado quando mudanca de foco de entrada de dados esta sendo efetuada na janela onde o controle foi criado. O bloco deve retornar .T. se o controle deve permanecer habilitado ou .F. se nao.
// 18 - lPar18		Reservado.
// 19 - lPar19		Reservado.
// 20 - abChange	Bloco de codigo, opcional. Executado quando o controle modifica o valor da variavel associada.
// 21 - alReadOnly  Logico, opcional. Se .T. o controle nao podera ser editado.
// 22 - alPassword	Logico, opcional. Se .T. o controle exibira asteriscos ¡§*¡¨ no lugar dos caracteres exibidos pelo controle para simular entrada de senha.
// 23 - cPar23		Reservado.
// 24 - acReadVar	Caractere, opcional. Nome da variavel que o controle devera manipular, devera ser a mesma variavel informada no parametro abSetGet, e sera o retorno da funcao ReadVar( ).
// 25 - cPar25		Reservado.
// 26 - lPar26		Reservado.
// 27 - nPar27		Reservado.
// 28 - lPar28		Reservado.

// MsSelect(): New ( < cAlias>, [ cCampo], [ cCpo], [ aCampos], [ lInv], [ cMar], < aCord>, [ cTopFun], [ cBotFun], < oWnd>, [ uPar11], [ aColors] ) --> oSelf
//
// Parâmetros
//
// Nome  		Tipo 				Descrição
//
// cAlias		Caracter			Alias da tabela utilizada pela MsSelect para controle dos registros/colunas apresentadas.
// cCampo		Caracter			Nome do campo presente na tabela definida em cAlias, qual contemplara a opção de marcação (check/unckeck)
// cCpo			Caracter    		Campo da tabela informada pelo parametro cAlias ou função que será executada na apresentação da coluna que indica se a linha da MsSelect esta habilitada ou não.
// aCampos		Array of Record		Vetor com informações dos campos para criação das colunas da MsSelect. Se não for informado, a MsSelect irá criar as colunas baseado no Dicionário de Campos (SX3) da tabela informada no parametro cAlias.
// lInv 		Lógico				Indica se MsSelect irá utilizar marcação invertida
// cMar 		Caracter			Marca que será utilizada pela MsSelect para controle do campo informado pelo parametro cCampo. Para utilizar o parametro cMar, utilize a função GetMark() para retornar a próxima marca disponivel para uso.
// aCord		Array of Record		Coordenadas para criação da MsSelect, sendo:aCord[1] = Coordenada vertical inicialaCord[2] = Coordenada horizontal inicialaCord[3] = Altura do objeto MsSelectaCord[4] = Largura do objeto MsSelect
// cTopFun 		Caracter			Função que retornará o conteúdo inicial que a MsSelect utilizará para apresentar a primeira linha da tabela, como um range, junto com o parametro cBotFun. O conteúdo retornado será utilizado para fazer o posicionamento da tabela informada pelo parametro cAlias, baseado na chave de índice posicionada para a mesma.
// cBotFun		Caracter			Função que retornará o conteúdo final que a MsSelect utilizará para apresentar a última linha da tabela, como um range, junto com o parametro cTopFun. O conteúdo retornado será utilizado para o posicionamento final da tabela informada pelo parametro cAlias, baseado na chave de índice posicionada para a mesma.
// oWnd			Objeto				Objeto tipo "Dialog" (MSDIALOG, MSWINDOW, MSPANEL, etc.) aonde a MsSelect sera posicionada.
// uPar11		Nulo				Parametro reservado relativo a compatibilidade.
// aColors		Array of Record		Vetor com regras para a apresentação da coluna de legenda.


Static Function mrk1()

Local cMarca:=( IIf( oGetDados1:aCols[oGetDados1:nAt,3]== "LBNO" , "LBOK" , "LBNO"    ) )

oGetDados1:aCols[oGetDados1:nAt,3] := iif(cMarca == "LBOK","1","2")     // atualiza para Sim ou Nao
oGetDados1:oBrowse:Refresh()

Return cMarca






///////////////////////////////////
///////////////////////////////////
user function rtcompra()
///////////////////////////////////
///////////////////////////////////
local _aCompradores := {}

_cAreexp  := Alias()
_nRecexp  := Recno()
_cIndexp  := IndexOrd()

aadd(_aCompradores,space(20))

dbselectarea("SY1") // Compradores
dbsetorder(1)
dbgotop()

Do While ! eof()
	
	if ! ( alltrim(y1_cod) $ "104,992,46,001,3" )
		aadd(_aCompradores , padr(upper(alltrim(Y1_NOME))+" ("+Y1_COD+")",20) )
	Endif
	
	dbskip()
	
Enddo

aSort(_aCompradores)

dbselectarea(_cAreexp)
dbsetorder(_cIndexp)
dbgoto(_nRecexp)

return(_aCompradores)




////////////////////////////////////////////
////////////////////////////////////////////
user function FILFIN(_nOption)
////////////////////////////////////////////
////////////////////////////////////////////
Local nOpcao  := 0

private _cDoc      := _filpar01
private _dDtLanc   := _filpar02
private _cCliFor   := _filpar03
private _cNome     := space(40)
private _dEmisDe   := _filpar04
private _dEmisAte  := _filpar05
private _dVencDe   := _filpar06
private _dVencAte  := _filpar07
private _dBaixDe   := _filpar08
private _dBaixAte  := _filpar09
private _cNatureza := _filpar10
private _nValorde  := _filpar11
private _nValorAte := _filpar12
private _cStatus   := _filpar13

private _cFilial   := _filpar14
private _cReferenc := _filpar15
private _cCusto    := _filpar16
private _cBanco    := _filpar17
private _cFormpg   := _filpar18
private _nVlrNfDe  := _filpar19
private _nVlrNfAte := _filpar20
private _cTipo     := _filpar21
private _cDocAux   := _filpar22
private _cCtb      := _filpar23
private _cClass    := '5'

if _cCliFor == '******'
	_cCliFor := space(6)
Endif

_aFilial   := {} // iif( !empty(_cFilial)   , u_convcpo(_cFilial   , "E"  ) , {} )
_aClifor   := {} // iif( !empty(_cCliFor)   , u_convcpo(_cCliFor   , "F"  ) , {} )
_aNatureza := {} // iif( !empty(_cNatureza) , u_convcpo(_cNatureza , "N"  ) , {} )
_aBanco    := {} // iif( !empty(_cBanco)    , u_convcpo(_cBanco    , "B"  ) , {} )
_aReferenc := {} // iif( !empty(_cReferenc) , u_convcpo(_cReferenc , "R"  ) , {} )
_aFormpg   := {} // iif( !empty(_cFormpg  ) , u_convcpo(_cFormpg   , "Z2" ) , {} )
_aCusto    := {} // iif( !empty(_cCusto)    , u_convcpo(_cCusto    , "T"  ) , {} )

_aFor      := {}
_acli      := {}

if _nOption == nil
	_nOption   := iif( upper(alias()) == "SE2", 1 , 2 )
	//alert("verificar rotina: "+alias())
Endif

_oObj:= GetObjBrow()

//_oObj:Default()
//alert("Pesquisar")

_lKeypesq  := .f.

setkey( VK_F10, {|| nil } )

ofont1     := TFont():New("TIMES NEW ROMAN" , 15, 20,,.T.)
ofont2     := TFont():New("TIMES NEW ROMAN" , 30, 40,,.T.)
_nLin      := 5
_nInc      := 15

oDlgFilPag := MSDialog():New( 050 , 13 , 380 , 580 , 'Selecao de registros do Contas a '+iif(_nOption == 1,'Pagar','Receber'), , , .F. , , , , , , .T. , , , .T. , , )

_oCpgSay    := TSay():New(_nLin, 010 , {||"No.Titulo"}              , oDlgFilPag,  ,        ,,,,.T.,CLR_BLUE  , CLR_WHITE,60 ,15)
_oDoc       := TGet():New(_nLin, 070 , {|u| If(PCount() > 0, _cDoc      := u , _cDoc      )} , oDlgFilPag , 045 , 010 , "@!"                 ,                                       , 0 ,   ,   , .F. ,   , .T. ,   , .F. ,   , .F. , .F. ,   , .F. , .F. ,       , '_cDoc'     ,   ,   ,   ,   )
_nLin       += _nInc

_oCpgSay    := TSay():New( _nLin, 010 ,  {||  "Data da Inclusao"}                              , oDlgFilPag,    ,     ,,,,.T.,CLR_BLUE  , CLR_WHITE,60 ,15)
_oDtMov     := TGet():New( _nLin, 070 , {|u| If(PCount() > 0, _dDtLanc   := u , _dDtLanc    )}  , oDlgFilPag, 045, 010 ,                 ,                                      , 0 ,   ,   , .F. ,   , .T. ,   , .F. ,   , .F. , .F. ,   , .F. , .F. ,       , '_dDtLanc'   ,   ,   ,   ,   )
_nLin       += _nInc

_oCpgSay    := TSay():New( _nLin, 010 , {||  iif(_nOption == 1,"Fornecedor","Cliente")}                                   , oDlgFilPag,    ,     ,,,,.T.,CLR_BLUE  , CLR_WHITE,60 ,15)
_oCliFor    := TGet():New( _nLin, 070 , {|u| If(PCount() > 0, _cCliFor := u , _cCliFor   )}     , oDlgFilPag, 045, 010 , "!!!!!!"        , {|| u_parclifor(@_cCliFor,@_cNome, @_oCliFor, @_oNome, _nOption ) }             , 0 ,   ,   , .F. ,   , .T. ,   , .F. ,   , .F. , .F. ,   , .F. , .F. , iif(_nOption==1,'SA2','SA1') , '_cCliFor'   ,   ,   ,   ,   )
_oNome      := TGet():New( _nLin, 125 , {|u| If(PCount() > 0, _cNome   := u , _cNome     )}     , oDlgFilPag, 140, 010 , "@!"            , {|| u_parclifor(@_cCliFor,@_cNome, @_oCliFor, @_oNome, _nOption ) }             , 0 ,   ,   , .F. ,   , .T. ,   , .F. ,   , .F. , .F. ,   , .F. , .F. ,                              , '_cNome'     ,   ,   ,   ,   )
_nLin       += _nInc

_oCpgSay    := TSay():New( _nLin, 010 , {||"Emissao de"   }                                     , oDlgFilPag,    ,     ,,,,.T.,CLR_BLUE  , CLR_WHITE,60 ,15)
_oCpgSay    := TSay():New( _nLin, 125 , {||"Ate"}                                               , oDlgFilPag,    ,     ,,,,.T.,CLR_BLUE  , CLR_WHITE,30 ,15)
_oEmisDe    := TGet():New( _nLin, 070 , {|u| If(PCount() > 0, _dEmisDe   := u , _dEmisDe   )}   , oDlgFilPag, 045, 010 , "      "        , {|| u_ParEmi(@_dEmisDe,@_dEmisAte) }   , 0 ,   ,   , .F. ,   , .T. ,   , .F. ,   , .F. , .F. ,   , .F. , .F. ,      , '_dEmisDe'  ,   ,   ,   ,   )
_oEmisAte   := TGet():New( _nLin, 160 , {|u| If(PCount() > 0, _dEmisAte  := u , _dEmisAte  )}   , oDlgFilPag, 045, 010 , "      "        ,                                        , 0 ,   ,   , .F. ,   , .T. ,   , .F. ,   , .F. , .F. ,   , .F. , .F. ,      , '_dEmisAte' ,   ,   ,   ,   )
_nLin       += _nInc

_oCpgSay    := TSay():New(_nLin, 010 , {||"Vencimento de"}                                      , oDlgFilPag,    ,     ,,,,.T.,CLR_BLUE  , CLR_WHITE,60 ,15)
_oCpgSay    := TSay():New(_nLin, 125 , {||"Ate"}                                                , oDlgFilPag,    ,     ,,,,.T.,CLR_BLUE  , CLR_WHITE,30 ,15)
_oVencDe    := TGet():New(_nLin, 070 , {|u| If(PCount() > 0, _dVencDe   := u , _dVencDe   )}    , oDlgFilPag, 045, 010 , "      "        , {|| u_ParVcto(@_dVencDe,@_dVencAte) }   , 0 ,   ,   , .F. ,   , .T. ,   , .F. ,   , .F. , .F. ,   , .F. , .F. ,       , '_dVencDe'  ,   ,   ,   ,   )
_oVencAte   := TGet():New(_nLin, 160 , {|u| If(PCount() > 0, _dVencAte  := u , _dVencAte  )}    , oDlgFilPag, 045, 010 , "      "        ,                                       , 0 ,   ,   , .F. ,   , .T. ,   , .F. ,   , .F. , .F. ,   , .F. , .F. ,       , '_dVencAte' ,   ,   ,   ,   )
_nLin       += _nInc

_oCpgSay    := TSay():New(_nLin, 010 , {||"Baixados De"}                                        , oDlgFilPag,    ,     ,,,,.T.,CLR_BLUE  , CLR_WHITE,60 ,15)
_oCpgSay    := TSay():New(_nLin, 125 , {||"Ate"}                                                , oDlgFilPag,    ,     ,,,,.T.,CLR_BLUE  , CLR_WHITE,30 ,15)
_oBaixDe    := TGet():New(_nLin, 070 , {|u| If(PCount() > 0, _dBaixDe   := u , _dBaixDe   )}    , oDlgFilPag, 045, 010 , "      "        , {|| u_ParBxa(@_dBaixDe,@_dBaixAte) }   , 0 ,   ,   , .F. ,   , .T. ,   , .F. ,   , .F. , .F. ,   , .F. , .F. ,       , '_dBaixDe'  ,   ,   ,   ,   )
_oBaixAte   := TGet():New(_nLin, 160 , {|u| If(PCount() > 0, _dBaixAte  := u , _dBaixAte  )}    , oDlgFilPag, 045, 010 , "      "        ,                                       , 0 ,   ,   , .F. ,   , .T. ,   , .F. ,   , .F. , .F. ,   , .F. , .F. ,       , '_dBaixAte' ,   ,   ,   ,   )
_nLin       += _nInc

_oCpgSay    := TSay():New(_nLin, 010 , {||"Natureza   "}                                        , oDlgFilPag,    ,     ,,,,.T.,CLR_BLUE  , CLR_WHITE,60 ,15)
_oNatureza  := TGet():New(_nLin, 070 , {|u| If(PCount() > 0, _cNatureza := u , _cNatureza  )}   , oDlgFilPag, 200, 010 , "@9"            , {|| u_parnat(@_cNatureza, @_oNatureza)}                , 0 ,   ,   , .F. ,   , .T. ,   , .F. ,   , .F. , .F. ,   , .F. , .F. , 'SED' , '_cNatureza'   ,   ,   ,   ,   )
_nLin       += _nInc

_oCpgSay    := TSay():New(_nLin, 010 , {||"Valor De   "}            , oDlgFilPag,  ,        ,,,,.T.,CLR_BLUE  , CLR_WHITE,60 ,15)
_oCpgSay    := TSay():New(_nLin, 125 , {||"Ate "}                   , oDlgFilPag,  ,        ,,,,.T.,CLR_BLUE  , CLR_WHITE,30 ,15)
_oValorDe   := TGet():New(_nLin, 070 , {|u| If(PCount() > 0, _nValorDe  := u , _nValorDe  )} , oDlgFilPag , 045 , 010 , "@E 9999,999.99"     , {|| u_parvlr(@_nValorDe,@_nValorAte )}             , 0 ,   ,   , .F. ,   , .T. ,   , .F. ,   , .F. , .F. ,   , .F. , .F. ,       , '_nValorDe' ,   ,   ,   ,   )
_oValorAte  := TGet():New(_nLin, 160 , {|u| If(PCount() > 0, _nValorAte := u , _nValorAte )} , oDlgFilPag , 045 , 010 , "@E 9999,999.99"     ,                                       , 0 ,   ,   , .F. ,   , .T. ,   , .F. ,   , .F. , .F. ,   , .F. , .F. ,       , '_nValorAte',   ,   ,   ,   )
_nLin       += _nInc

_oCpgSay    := TSay():New(_nLin, 010 , {||"Baixados/Nao/Todos"}     , oDlgFilPag,  ,        ,,,,.T.,CLR_BLUE  , CLR_WHITE,60 ,15)
_oStatus    := TComboBox():New(_nLin , 070 , {|u| if(PCount()>0 , _cStatus :=u , _cStatus )}, {"A=Abertos","B=Baixados","T=Todos"} , 45 , 010 , oDlgFilPag , , , , CLR_BLACK , CLR_WHITE , .T. , , "" , , , , , , , "_cStatus")


////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

//_oCpgSay    := TSay():New( _nLin, 010 , {||   "Firma"}                                          , oDlgFilPag,    ,     ,,,,.T.,CLR_BLUE  , CLR_WHITE,60 ,15)
//_oFilial    := TGet():New( _nLin, 070 , {|u| If(PCount() > 0, _cFilial    := u , _cFilial    )} , oDlgFilPag, 200, 010 , "@!"            , {|| u_Parfil(@_cFilial,_oFilial) }               , 0 ,   ,   , .F. ,   , .T. ,   , .F. ,   , .F. , .F. ,   , .F. , .F. , 'SM0' , '_cFilial'   ,   ,   ,   ,   )
//_nLin       += _nInc


//_oCpgSay    := TSay():New(_nLin, 010 , {||"Referencia   "}                                      , oDlgFilPag,    ,     ,,,,.T.,CLR_BLUE  , CLR_WHITE,60 ,15)
//_oReferenc  := TGet():New(_nLin, 070 , {|u| If(PCount() > 0, _cReferenc := u , _cReferenc )}    , oDlgFilPag, 200, 010 , "@9"            , {|| u_ParRef(@_cReferenc, @_oReferenc)}               , 0 ,   ,   , .F. ,   , .T. ,   , .F. ,   , .F. , .F. ,   , .F. , .F. ,       , '_cReferenc'   ,   ,   ,   ,   )
//_nLin       += _nInc

//_oCpgSay    := TSay():New(_nLin, 010 , {||"C.Custo   "}             , oDlgFilPag,  ,        ,,,,.T.,CLR_BLUE  , CLR_WHITE,60 ,15)
//_oCusto     := TGet():New(_nLin, 070 , {|u| If(PCount() > 0, _cCusto    := u , _cCusto    )} , oDlgFilPag , 200 , 010 , "@9"                 , {|| FILCPCus(@_cCusto  )}              , 0 ,   ,   , .F. ,   , .T. ,   , .F. ,   , .F. , .F. ,   , .F. , .F. , 'CTT' , '_cCusto  ' ,   ,   ,   ,   )
//_nLin       += _nInc

//_oCpgSay    := TSay():New(_nLin, 010 , {||"Banco"}                  , oDlgFilPag,  ,        ,,,,.T.,CLR_BLUE  , CLR_WHITE,60 ,15)
//_oBanco     := TGet():New(_nLin, 070 , {|u| If(PCount() > 0, _cBanco    := u , _cBanco    )} , oDlgFilPag , 200 , 010 , "@!"                 , {|| FILCPBco(@_cBanco)}                , 0 ,   ,   , .F. ,   , .T. ,   , .F. ,   , .F. , .F. ,   , .F. , .F. , 'SA6' , '_cBanco'   ,   ,   ,   ,   )
//_nLin       += _nInc

//_oCpgSay    := TSay():New(_nLin, 010 , {||iif(_nOption == 1,"Forma Pag","Forma Rec")}              , oDlgFilPag,  ,        ,,,,.T.,CLR_BLUE  , CLR_WHITE,30 ,15)
//_oFormpg    := TGet():New(_nLin, 070 , {|u| If(PCount() > 0, _cFormpg   := u , _cFormpg   )} , oDlgFilPag , 200 , 010 , "@!"                 , {|| FILCPFpg(@_cFormpg)}               , 0 ,   ,   , .F. ,   , .T. ,   , .F. ,   , .F. , .F. ,   , .F. , .F. , 'Z2'  , '_cFormpg'  ,   ,   ,   ,   )
//_nLin       += _nInc

//_oCpgSay    := TSay():New(_nLin, 010 , {||"Tipo"}                   , oDlgFilPag,  ,        ,,,,.T.,CLR_BLUE  , CLR_WHITE,60 ,15)
//_oTipo      := TGet():New(_nLin, 070 , {|u| If(PCount() > 0, _cTipo     := u , _cTipo     )} , oDlgFilPag , 045 , 010 , "@!"                 ,                                       , 0 ,   ,   , .F. ,   , .T. ,   , .F. ,   , .F. , .F. ,   , .F. , .F. , '05'  , '_cTipo'    ,   ,   ,   ,   )
//_nLin       += _nInc

//_aClas      := {iif(_nOption==1,"1=Fornecedor","1=Cliente"),"2=Emissao","3=Vencimento","4=Baixa","5=Referencia","6=Valor","7=Natureza","8=C.Custo","9=Filial"}
//_oCpgSay    := TSay():New(_nLin, 160 , {||"Classificacao"}               , oDlgFilPag,  ,        ,,,,.T.,CLR_BLUE  , CLR_WHITE,40 ,15)
//_oClas      := TComboBox():New(_nLin , 215 , {|u| if(PCount()>0 , _cClass    :=u , _cClass    )}, _aClas , 55 , 010 , oDlgFilPag , , , , CLR_BLACK , CLR_WHITE , .T. , , "" , , , , , , , "_cClass" )

//oGOrdem    := TGroup():New  ( _nLin , 215 , 230 , 265 , "Ordem" , oDlgFilPag , CLR_BLACK , CLR_WHITE , .T. , .F. )
//oROrdem    := TRadMenu():New( _nLin+5 , 220 , {"Fornecedor","Emissao","Vencimento","Baixa","Referencia","Vlr. Parcela","Natureza","C.Custo"} , {|u|Iif (PCount()==0,_nRadio,_nRadio:=u)} , oGOrdem , , , CLR_BLACK , CLR_WHITE , "Opcoes de classificacao dos registros" , , , 40 , 15 , , .F. , .F. , .T. )

//_oCpgSay    := TSay():New(_nLin, 010 , {||"Vlr Nota de   " }        , oDlgFilPag,  ,        ,,,,.T.,CLR_BLUE  , CLR_WHITE,60 ,15)
//_oCpgSay    := TSay():New(_nLin, 125 , {||"Ate "}                   , oDlgFilPag,  ,        ,,,,.T.,CLR_BLUE  , CLR_WHITE,30 ,15)
//_oParcDe    := TGet():New(_nLin, 070 , {|u| If(PCount() > 0, _nVlrNfde  := u , _nVlrNfde  )} , oDlgFilPag , 045 , 010 , "@E 9999,999.99"     , {|| u_parvnf(@_nVlrNfde, @_nVlrNfAte )}              , 0 ,   ,   , .F. ,   , .T. ,   , .F. ,   , .F. , .F. ,   , .F. , .F. ,       , '_nVlrNfde'  ,   ,   ,   ,   )
//_oParcAte   := TGet():New(_nLin, 160 , {|u| If(PCount() > 0, _nVlrNfAte := u , _nVlrNfAte )} , oDlgFilPag , 045 , 010 , "@E 9999,999.99"     ,                                       , 0 ,   ,   , .F. ,   , .T. ,   , .F. ,   , .F. , .F. ,   , .F. , .F. ,       , '_nVlrNfAte' ,   ,   ,   ,   )
//_nLin       += _nInc


//_oCpgSay    := TSay():New(_nLin, 125 , {||"Comp.Titulo"}            , oDlgFilPag,  ,        ,,,,.T.,CLR_BLUE  , CLR_WHITE,30 ,15)
//_oDocAux    := TGet():New(_nLin, 160 , {|u| If(PCount() > 0, _cDocaux   := u , _cDocAux   )} , oDlgFilPag , 045 , 010 , "@!"                 ,                                       , 0 ,   ,   , .F. ,   , .T. ,   , .F. , {|| iif(_nOption == 1,.t.,.f.)}  , .F. , .F. ,   , .F. , .F. ,       , '_cDocAux'  ,   ,   ,   ,   )
//_nLin       += _nInc

//_oCpgSay    := TSay():New(_nLin, 125 , {||"Contabil"}               , oDlgFilPag,  ,        ,,,,.T.,CLR_BLUE  , CLR_WHITE,30 ,15)
//_oCtb       := TComboBox():New(_nLin , 160 , {|u| if(PCount()>0 , _cCtb    :=u , _cCtb    )}, {"C=Contabil","N=Nao","T=Todos"} , 45 , 010 , oDlgFilPag , , , , CLR_BLACK , CLR_WHITE , .T. , , "" , , , , , , , "_cCtb" )

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

_nLin       += _nInc

@ 003,005 to _nLin,280 pixel

_nLin       += 5

TButton():New( _nLin, 185, 'Confirma'     , oDlgFilPag, {|| oDlgFilPag:end() , okpesq(.t.,_nOption, @_oObj) }   ,40,10,,,,.T.)
TButton():New( _nLin, 230, 'Limpa Filtro' , oDlgFilPag, {|| oDlgFilPag:end() , okpesq(.f.,_nOption, @_oObj) }   ,50,10,,,,.T.)

oDlgFilPag:Activate( , , , .T. )

setkey( VK_F10, { || _lKeypesq   := .t. , u_FILFIN() } )

return nil


////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
static function okpesq(_lok, _nOption, _oObj )
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
local _lret := .t.
Local _i := 0 

if _cCliFor == '******'
	_cCliFor := space(6)
Endif

if  _nOption == 1
	dbselectarea("SE2")
Else
	dbselectarea("SE1")
Endif


_cFilse1   := se1->(dbfilter())
_cFilse2   := se2->(dbfilter())
_cFiltro   := " "

if _lok
	
	_filpar01 := _cDoc
	_filpar02 := _dDtLanc
	_filpar03 := _cCliFor
	_filpar04 := _dEmisDe
	_filpar05 := _dEmisAte
	_filpar06 := _dVencDe
	_filpar07 := _dVencAte
	_filpar08 := _dBaixDe
	_filpar09 := _dBaixAte
	_filpar10 := _cNatureza
	_filpar11 := _nValorde
	_filpar12 := _nValorAte
	_filpar13 := _cStatus
	
	_filpar14 := _cFilial
	_filpar15 := _cReferenc
	_filpar16 := _cCusto
	_filpar17 := _cBanco
	_filpar18 := _cFormpg
	_filpar19 := _nVlrNfDe
	_filpar20 := _nVlrNfAte
	_filpar21 := _cTipo
	_filpar22 := _cDocAux
	_filpar23 := _cCtb
	
	
	//_aFilial   := iif( !empty(_cFilial)   , u_convcpo(_cFilial   , "E"  ) , {} )
	_aClifor   := iif( !empty(_cCliFor)   , u_convcpo(_cCliFor   , "F"  ) , {} )
	_aNatureza := iif( !empty(_cNatureza) , u_convcpo(_cNatureza , "N"  ) , {} )
	//_aBanco    := iif( !empty(_cBanco)    , u_convcpo(_cBanco    , "B"  ) , {} )
	//_aReferenc := iif( !empty(_cReferenc) , u_convcpo(_cReferenc , "R"  ) , {} )
	//_aFormpg   := iif( !empty(_cFormpg  ) , u_convcpo(_cFormpg   , "Z2" ) , {} )
	//_aCusto    := iif( !empty(_cCusto)    , u_convcpo(_cCusto    , "T"  ) , {} )
	
	if _nOption == 1 // Contas a Pagar

		/////////////////////////////////////////////////////////////////////////////////////////
		
		if !empty(_cDoc)
			
			if left(alltrim(_cDoc),1) == "@"
				
				_xtmp := substr(alltrim(_cDoc),2)
				
				IF LEN(_xtmp) >= 3
					_cFiltro += IIF(empty(_cFiltro),"" , " .AND. ") + "( '"+_xtmp+"' $ E2_NUM )"
				Else
					alert("Pesquisa relativa somente com mais de 3 caracteres (1).")
				Endif
				
			Else
				
				_cFiltro += IIF(empty(_cFiltro),"" , " .AND. ") + "( E2_NUM  == '"+_cDoc+"' )"
				
			Endif
		Endif
		
		/////////////////////////////////////////////////////////////////////////////////////////
		
		if !empty(_dDtLanc)
			_cFiltro += " ( DTOS(E2_EMIS1) = '" + dtos(_dDtLanc) +"' ) "
		Endif
		
		
		/////////////////////////////////////////////////////////////////////////////////////////
		
		_aClifor := {}
		
		if !empty(_cClifor) .and. _cClifor <> '******'
			_aClifor   := iif( !empty(_cCliFor)   , u_convcpo(_cCliFor   , "F"  ) , {} )
			//aadd(_aClifor, {_cClifor , _cClifor} )
		Endif
		
		if len(_aClifor) > 0
			
			_cFiltro += IIF(empty(_cFiltro)," ( " , " .AND.  ( ")
			
			for _i := 1 to len(_aClifor)
				
				if _i > 1
					_cFiltro += " .OR. "
				Endif
				
				if _aClifor[_i][1] <> _aClifor[_i][2]
					_cFiltro += " ( E2_FORNECE >= '" + _aClifor[_i][1]  +"' .AND. E2_FORNECE <= '" + _aClifor[_i][2]  +"' ) "
				Else
					_cFiltro += " ( E2_FORNECE == '" + _aClifor[_i][1]  +"' ) "
				Endif
				
			Next
			
			_cFiltro += " )"
			
		Endif
		
		
		/////////////////////////////////////////////////////////////////////////////////////////
		
		if !empty(_dEmisDe) .or.  !empty(_dEmisAte)
			_cFiltro += IIF(empty(_cFiltro),"" , " .AND. ") + "( DTOS(E2_EMISSAO)>= '" + dtos(_dEmisDe)        +"' .AND. DTOS(E2_EMISSAO) <= '" + dtos(_dEmisAte)      +"' ) "
		Endif
		
		/////////////////////////////////////////////////////////////////////////////////////////
		
		if !empty(_dVencDe) .or. !empty(_dVencAte)
			_cFiltro += IIF(empty(_cFiltro),"" , " .AND. ") + "( DTOS(E2_VENCTO) >= '" + dtos(_dVencDe)        +"' .AND. DTOS(E2_VENCTO)  <= '" + dtos(_dVencAte)      +"' ) "
		Endif
		
		/////////////////////////////////////////////////////////////////////////////////////////
		
		
		if len(_aNatureza) > 0
			
			_cFiltro += IIF(empty(_cFiltro)," ( " , " .AND.  ( ")
			
			for _i := 1 to len(_aNatureza)
				
				if _i > 1
					_cFiltro += " .OR. "
				Endif
				
				if _aNatureza[_i][1] <> _aNatureza[_i][2]
					_cFiltro += " ( E2_NATUREZ >= '" + _aNatureza[_i][1]  +"' .AND. E2_NATUREZ <= '" + _aNatureza[_i][2]  +"' ) "
				Else
					_cFiltro += " ( E2_NATUREZ == '" + _aNatureza[_i][1]  +"' ) "
				Endif
				
			Next
			
			_cFiltro += " )"
			
		Endif
		
		/////////////////////////////////////////////////////////////////////////////////////////
		
		if _nValorDe > 0  .or. _nValorAte > 0
			_cFiltro += IIF(empty(_cFiltro),"" , " .AND. ") + "( E2_VALOR        >=  "  + str(_nValorDe,12,2)   +"  .AND. E2_VALOR         <= "  + str(_nValorAte,12,2)  +" ) "
		Endif
		
		/////////////////////////////////////////////////////////////////////////////////////////
		
		IF _cStatus <> 'T'
			
			IF _cStatus == 'B'
				
				_cFiltro += IIF(empty(_cFiltro),"" , " .AND. ") + "( E2_SALDO == 0 ) "
				
				if !empty(_dBaixDe) .or. !empty(_dBaixAte)
					_cFiltro += IIF(empty(_cFiltro),"" , " .AND. ") + "( DTOS(E2_BAIXA ) >= '" + dtos(_dBaixDe)        +"' .AND. DTOS(E2_BAIXA )  <= '" + dtos(_dBaixAte)      +"' ) "
				Endif
				
			ElseIF _cStatus == 'A'
				_cFiltro += IIF(empty(_cFiltro),"" , " .AND. ") + "( E2_SALDO > 0 ) "
			Endif
			
		Endif
		
		/*
		
		/////////////////////////////////////////////////////////////////////////////////////////
		
		if len(_aFilial) > 0
		
		_cFiltro += IIF(empty(_cFiltro)," ( " , " .AND.  ( ")
		
		for _i := 1 to len(_aFilial)
		
		if _i > 1
		_cFiltro += " .OR. "
		Endif
		
		if _aFilial[_i][1] <> _aFilial[_i][2]
		_cFiltro += " ( E2_FILIAL >= '" + _aFilial[_i][1]  +"' .AND. E2_FILIAL <= '" + _aFilial[_i][2]  +"' ) "
		Else
		_cFiltro += " ( E2_FILIAL == '" + _aFilial[_i][1]  +"' ) "
		Endif
		
		Next
		
		_cFiltro += " )"
		
		Endif
		
		/////////////////////////////////////////////////////////////////////////////////////////
		
		if len(_aBanco) > 0
		
		_cFiltro += IIF(empty(_cFiltro)," ( " , " .AND.  ( ")
		
		for _i := 1 to len(_aBanco)
		
		if _i > 1
		_cFiltro += " .OR. "
		Endif
		
		if _aBanco[_i][1] <> _aBanco[_i][2]
		_cFiltro += " ( E2_BCOPAG  >= '" + _aBanco[_i][1]  +"' .AND. E2_BCOPAG <= '" + _aBanco[_i][2]  +"' ) "
		Else
		_cFiltro += " ( E2_BCOPAG  == '" + _aBanco[_i][1]  +"' ) "
		Endif
		
		Next
		
		_cFiltro += " )"
		
		Endif
		
		/////////////////////////////////////////////////////////////////////////////////////////
		
		if len(_aCusto) > 0
		
		_cFiltro += IIF(empty(_cFiltro)," ( " , " .AND.  ( ")
		
		for _i := 1 to len(_aCusto)
		
		if _i > 1
		_cFiltro += " .OR. "
		Endif
		
		if _aCusto[_i][1] <> _aCusto[_i][2]
		_cFiltro += " ( E2_CCD  >= '" + _aCusto[_i][1]  +"' .AND. E2_CCD <= '" + _aCusto[_i][2]  +"' ) "
		Else
		_cFiltro += " ( E2_CCD  == '" + _aCusto[_i][1]  +"' ) "
		Endif
		
		Next
		
		_cFiltro += " )"
		
		Endif
		
		/////////////////////////////////////////////////////////////////////////////////////////
		
		if len(_aReferenc) > 0
		
		_cFiltro += IIF(empty(_cFiltro)," ( " , " .AND. ( ")
		
		for _i := 1 to len(_aReferenc)
		
		if _i > 1
		_cFiltro += " .OR. "
		Endif
		
		if _aReferenc[_i][1] <> _aReferenc[_i][2]
		_cFiltro += " ( E2_NUMREF  >= '" + _aReferenc[_i][1]  +"' .AND. E2_NUMREF <= '" + _aReferenc[_i][2]  +"' ) "
		Else
		_cFiltro += " ( E2_NUMREF  == '" + _aReferenc[_i][1]  +"' ) "
		Endif
		
		Next
		
		_cFiltro += " )"
		
		Endif
		
		/////////////////////////////////////////////////////////////////////////////////////////
		
		if _nVlrNFde > 0 .or. _nVlrNFAte > 0
		_cFiltro += IIF(empty(_cFiltro),"" , " .AND. ") + "( E2_VLRNF        >=  "  + str(_nVlrNFde,12,2)  +"  .AND. E2_VLRNF         <= "  + str(_nVlrNFAte,12,2) +" ) "
		Endif
		
		/////////////////////////////////////////////////////////////////////////////////////////
		
		if !empty(_cFormpg)
		_cFiltro += IIF(empty(_cFiltro),"" , " .AND. ") + "( E2_FORPAG == '"+_cFormpg+"' ) "
		Endif
		
		/////////////////////////////////////////////////////////////////////////////////////////
		
		if !empty(_cTipo)
		_cFiltro += IIF(empty(_cFiltro),"" , " .AND. ") + "( E2_TIPO == '"+_cTipo+"' ) "
		Endif
		
		/////////////////////////////////////////////////////////////////////////////////////////
		
		if !empty(_cDocAux)
		
		if left(alltrim(_cDocAux),1) == "@"
		
		_xtmp := substr(alltrim(_cDocAux),2)
		
		IF LEN(_xtmp) >= 3
		_cFiltro += IIF(empty(_cFiltro),"" , " .AND. ") + "( '"+_xtmp+"' $ E2_DOCAUX )"
		Else
		alert("Pesquisa relativa somente com mais de 3 caracteres (2).")
		Endif
		Else
		_cFiltro += IIF(empty(_cFiltro),"" , " .AND. ") + "( E2_DOCAUX  == '"+_cDocAux+"') "
		Endif
		
		Endif
		
		/////////////////////////////////////////////////////////////////////////////////////////
		
		if _cCtb <> 'T'
		if _cCtb == 'C'
		_cFiltro += IIF(empty(_cFiltro),"" , " .AND. ") + "( E2_CTB ==  'C' ) "
		Else
		_cFiltro += IIF(empty(_cFiltro),"" , " .AND. ") + "( E2_CTB <> 'C' ) "
		Endif
		Endif
		
		/////////////////////////////////////////////////////////////////////////////////////////
		
		if len(_aFilial) > 0
		
		_cFiltro += IIF(empty(_cFiltro)," ( " , " .AND.  ( ")
		
		for _i := 1 to len(_aFilial)
		
		if _i > 1
		_cFiltro += " .OR. "
		Endif
		
		if _aFilial[_i][1] <> _aFilial[_i][2]
		_cFiltro += " ( E1_FILIAL >= '" + _aFilial[_i][1]  +"' .AND. E1_FILIAL <= '" + _aFilial[_i][2]  +"' ) "
		Else
		_cFiltro += " ( E1_FILIAL == '" + _aFilial[_i][1]  +"' ) "
		Endif
		
		Next
		
		_cFiltro += " )"
		
		Endif
		
		/////////////////////////////////////////////////////////////////////////////////////////
		
		*/
		
		dbselectarea("SE2")
		
	Else
		
		/////////////////////////////////////////////////////////////////////////////////////////
		
		if !empty(_dDtLanc)
			_cFiltro += " ( DTOS(E1_EMIS1) = '" + dtos(_dDtLanc) +"' ) "
		Endif
		
		
		/////////////////////////////////////////////////////////////////////////////////////////
		
		_aClifor := {}
		
		if len(_aCli) > 0
			For _i := 1 to len(_aCli)
				aadd(_aClifor, {_aCli[_i,1] , _aCli[_i,1]} ) // Vetor _aClifor de 2 elementos deve gravar em ambos o codigo do fornecedor gravado no 1 elemento de _afor
			Next
		Else
			if !empty(_cClifor) .and. _cClifor <> '******'
				_aClifor   := iif( !empty(_cCliFor)   , u_convcpo(_cCliFor   , "C"  ) , {} )
				//aadd(_aClifor, {_cClifor , _cClifor} )
			Endif
		Endif
		
		_x1 := len(_aCli)
		_x2 := len(_aClifor)
		
		if len(_aClifor) > 0
			
			_cFiltro += IIF(empty(_cFiltro)," ( " , " .AND.  ( ")
			
			for _i := 1 to len(_aClifor)
				
				if _i > 1
					_cFiltro += " .OR. "
				Endif
				
				if _aClifor[_i][1] <> _aClifor[_i][2]
					_cFiltro += " ( E1_CLIENTE >= '" + _aClifor[_i][1]  +"' .AND. E1_CLIENTE <= '" + _aClifor[_i][2]  +"' ) "
				Else
					_cFiltro += " ( E1_CLIENTE == '" + _aClifor[_i][1]  +"' ) "
				Endif
				
			Next
			
			_cFiltro += " )"
			
		Endif
		
		/////////////////////////////////////////////////////////////////////////////////////////
		
		if len(_aNatureza) > 0
			
			_cFiltro += IIF(empty(_cFiltro)," ( " , " .AND.  ( ")
			
			for _i := 1 to len(_aNatureza)
				
				if _i > 1
					_cFiltro += " .OR. "
				Endif
				
				if _aNatureza[_i][1] <> _aNatureza[_i][2]
					_cFiltro += " ( E1_NATUREZ >= '" + _aNatureza[_i][1]  +"' .AND. E1_NATUREZ <= '" + _aNatureza[_i][2]  +"' ) "
				Else
					_cFiltro += " ( E1_NATUREZ == '" + _aNatureza[_i][1]  +"' ) "
				Endif
				
			Next
			
			_cFiltro += " )"
			
		Endif
		
		/////////////////////////////////////////////////////////////////////////////////////////
		
		if len(_aBanco) > 0
			
			_cFiltro += IIF(empty(_cFiltro)," ( " , " .AND.  ( ")
			
			for _i := 1 to len(_aBanco)
				
				if _i > 1
					_cFiltro += " .OR. "
				Endif
				
				if _aBanco[_i][1] <> _aBanco[_i][2]
					_cFiltro += " ( E1_BCOPAG  >= '" + _aBanco[_i][1]  +"' .AND. E1_BCOPAG <= '" + _aBanco[_i][2]  +"' ) "
				Else
					_cFiltro += " ( E1_BCOPAG  == '" + _aBanco[_i][1]  +"' ) "
				Endif
				
			Next
			
			_cFiltro += " )"
			
		Endif
		
		/////////////////////////////////////////////////////////////////////////////////////////
		
		if len(_aCusto) > 0
			
			_cFiltro += IIF(empty(_cFiltro)," ( " , " .AND.  ( ")
			
			for _i := 1 to len(_aCusto)
				
				if _i > 1
					_cFiltro += " .OR. "
				Endif
				
				if _aCusto[_i][1] <> _aCusto[_i][2]
					_cFiltro += " ( E1_CCD  >= '" + _aCusto[_i][1]  +"' .AND. E1_CCD <= '" + _aCusto[_i][2]  +"' ) "
				Else
					_cFiltro += " ( E1_CCD  == '" + _aCusto[_i][1]  +"' ) "
				Endif
				
			Next
			
			_cFiltro += " )"
			
		Endif
		
		/////////////////////////////////////////////////////////////////////////////////////////
		
		if len(_aReferenc) > 0
			
			_cFiltro += IIF(empty(_cFiltro)," ( " , " .AND. ( ")
			
			for _i := 1 to len(_aReferenc)
				
				if _i > 1
					_cFiltro += " .OR. "
				Endif
				
				if _aReferenc[_i][1] <> _aReferenc[_i][2]
					_cFiltro += " ( E1_NUMREF  >= '" + _aReferenc[_i][1]  +"' .AND. E1_NUMREF <= '" + _aReferenc[_i][2]  +"' ) "
				Else
					_cFiltro += " ( E1_NUMREF  == '" + _aReferenc[_i][1]  +"' ) "
				Endif
				
			Next
			
			_cFiltro += " )"
			
		Endif
		
		if !empty(_dEmisDe) .or.  !empty(_dEmisAte)
			_cFiltro += IIF(empty(_cFiltro),"" , " .AND. ") + "( DTOS(E1_EMISSAO)>= '" + dtos(_dEmisDe)        +"' .AND. DTOS(E1_EMISSAO) <= '" + dtos(_dEmisAte)      +"' ) "
		Endif
		
		if !empty(_dVencDe) .or. !empty(_dVencAte)
			_cFiltro += IIF(empty(_cFiltro),"" , " .AND. ") + "( DTOS(E1_VENCTO) >= '" + dtos(_dVencDe)        +"' .AND. DTOS(E1_VENCTO)  <= '" + dtos(_dVencAte)      +"' ) "
		Endif
		
		if _nValorDe > 0  .or. _nValorAte > 0
			_cFiltro += IIF(empty(_cFiltro),"" , " .AND. ") + "( E1_VALOR        >=  "  + str(_nValorDe,12,2)   +"  .AND. E1_VALOR         <= "  + str(_nValorAte,12,2)  +" ) "
		Endif
		
		if _nVlrNFde > 0 .or. _nVlrNFAte > 0
			_cFiltro += IIF(empty(_cFiltro),"" , " .AND. ") + "( E1_VLRNF        >=  "  + str(_nVlrNFde,12,2)  +"  .AND. E1_VLRNF         <= "  + str(_nVlrNFAte,12,2) +" ) "
		Endif
		
		if !empty(_cFormpg)
			_cFiltro += IIF(empty(_cFiltro),"" , " .AND. ") + "( E1_FORREC == '"+_cFormpg+"' ) "
		Endif
		
		if !empty(_cTipo)
			_cFiltro += IIF(empty(_cFiltro),"" , " .AND. ") + "( E1_TIPO == '"+_cTipo+"' ) "
		Endif
		
		if !empty(_cDoc)
			
			if left(alltrim(_cDoc),1) == "@"
				
				_xtmp := substr(alltrim(_cDoc),2)
				
				IF LEN(_xtmp) >= 3
					_cFiltro += IIF(empty(_cFiltro),"" , " .AND. ") + "( '"+_xtmp+"' $ E1_NUM )"
				Else
					alert("Pesquisa relativa somente com mais de 3 caracteres (1).")
				Endif
				
			Else
				
				_cFiltro += IIF(empty(_cFiltro),"" , " .AND. ") + "( E1_NUM  == '"+_cDoc+"' )"
				
			Endif
		Endif
		
		
		IF _cStatus <> 'T'
			
			IF _cStatus == 'B'
				
				_cFiltro += IIF(empty(_cFiltro),"" , " .AND. ") + "( E1_SALDO == 0 ) "
				
				if !empty(_dBaixDe) .or. !empty(_dBaixAte)
					_cFiltro += IIF(empty(_cFiltro),"" , " .AND. ") + "( DTOS(E1_BAIXA ) >= '" + dtos(_dBaixDe)        +"' .AND. DTOS(E1_BAIXA )  <= '" + dtos(_dBaixAte)      +"' ) "
				Endif
				
			ElseIF _cStatus == 'A'
				_cFiltro += IIF(empty(_cFiltro),"" , " .AND. ") + "( E1_SALDO > 0 ) "
			Endif
		Endif
		
		if _cCtb <> 'T'
			if _cCtb == 'C'
				_cFiltro += IIF(empty(_cFiltro),"" , " .AND. ") + "( E1_CTB ==  'C' ) "
			Else
				_cFiltro += IIF(empty(_cFiltro),"" , " .AND. ") + "( E1_CTB <> 'C' ) "
			Endif
		Endif
		
		dbselectarea("SE1")
		
	Endif
	
	//alert(_cFiltro)
	
Else
	
	
	_cDoc      := space(len(_filpar01))
	_dDtLanc   := ctod("")
	_cCliFor   := space(len(_filpar03))
	_cNome     := space(40)
	_dEmisDe   := ctod("")
	_dEmisAte  := ctod("")
	_dVencDe   := ctod("")
	_dVencAte  := ctod("")
	_dBaixDe   := ctod("")
	_dBaixAte  := ctod("")
	_cNatureza := space(len(_filpar10))
	_nValorde  := 0
	_nValorAte := 0
	_cStatus   := 'T'
	
	_cFilial   := space(len(_filpar14))
	_cReferenc := space(len(_filpar15))
	_cCusto    := space(len(_filpar16))
	_cBanco    := space(len(_filpar17))
	_cFormpg   := space(len(_filpar18))
	_nVlrNfDe  := 0
	_nVlrNfAte := 0
	_cTipo     := space(len(_filpar21))
	_cDocAux   := space(len(_filpar22))
	_cCtb      := 'T'
	
	_filpar01 := _cDoc
	_filpar02 := _dDtLanc
	_filpar03 := _cCliFor
	_filpar04 := _dEmisDe
	_filpar05 := _dEmisAte
	_filpar06 := _dVencDe
	_filpar07 := _dVencAte
	_filpar08 := _dBaixDe
	_filpar09 := _dBaixAte
	_filpar10 := _cNatureza
	_filpar11 := _nValorde
	_filpar12 := _nValorAte
	_filpar13 := _cStatus
	
	_filpar14 := _cFilial
	_filpar15 := _cReferenc
	_filpar16 := _cCusto
	_filpar17 := _cBanco
	_filpar18 := _cFormpg
	_filpar19 := _nVlrNfDe
	_filpar20 := _nVlrNfAte
	_filpar21 := _cTipo
	_filpar22 := _cDocAux
	_filpar23 := _cCtb
	
	_cFiltro := " "
	
	if _nOption == 1
		_cFilse2 := " "
	Else
		_cFilse1 := " "
	Endif
	
Endif

_xAlias := Alias()

SET FILTER TO

if _nOption == 1
	_cFilse2 := _cFiltro
	SET FILTER TO  &_cFilse2
Else
	_cFilse1 := _cFiltro
	SET FILTER TO  &_cFilse1
Endif


dbSelectArea(_xAlias)

//alert(_cClass)

/*
if _cClass  == '2' // Emissao
dbsetorder(5)
Elseif _cClass  == '3' // Vencimento
dbsetorder(3)
Elseif _cClass  == '4' // Baixa
dbsetorder(19)
Elseif _cClass  == '5' // Referencia
dbsetorder(18)
Elseif _cClass  == '6' // Valor do titulo
dbsetorder(17)
Elseif _cClass  == '7' // Natureza
dbsetorder(2)
Elseif _cClass  == '8' // Centro de Custo **** criar
dbsetorder(20)
Else
dbsetorder(6)   // Fornecedor
Endif

*/

dbgotop()

_oObj:ResetLen()
_oObj:Gotop()
_oObj:Refresh()

_aFilial   := {} // iif( !empty(_cFilial)   , u_convcpo(_cFilial   , "E"  ) , {} )
_aClifor   := {} // iif( !empty(_cCliFor)   , u_convcpo(_cCliFor   , "F"  ) , {} )
_aNatureza := {} // iif( !empty(_cNatureza) , u_convcpo(_cNatureza , "N"  ) , {} )
_aBanco    := {} // iif( !empty(_cBanco)    , u_convcpo(_cBanco    , "B"  ) , {} )
_aReferenc := {} // iif( !empty(_cReferenc) , u_convcpo(_cReferenc , "R"  ) , {} )
_aFormpg   := {} // iif( !empty(_cFormpg  ) , u_convcpo(_cFormpg   , "Z2" ) , {} )
_aCusto    := {} // iif( !empty(_cCusto)    , u_convcpo(_cCusto    , "T"  ) , {} )

_aFor      := {}
_acli      := {}

if _cCliFor == '******'
	_cCliFor := space(6)
Endif


return nil


////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
user function Parfil(_cFilial,_oFilial)
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
local _lret := .t.

if !empty(_cFilial)
	_aFilial   := iif( !empty(_cFilial)   , u_convcpo(_cFilial   , "E" ) , {} )
Endif

_oFilial:refresh()

//oDlgCldPar:refresh()
return(_lret)

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
user function parclifor(_CliFor,_Nome, _oClifor, _oNome, _nOption )
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
local _lret := .t.

_aFor := {}
_aCli := {}

if alltrim(upper(readvar())) == '_CCLIFOR'
	
	if ! empty(_CliFor)
		
		if _nOption == 1
			
			if left(_CliFor,1) $ "F"
				_CliFor := left(_CliFor,1)+strzero(val(substr(_CliFor,2)),5)
			else
				_CliFor := "F"+strzero(val(substr(_CliFor,1)),5)
			Endif
			
			dbselectarea("SA2")
			dbsetorder(1)
			dbgotop()
			
			if dbseek(xfilial('SA2')+_CliFor,.F.)
				_Nome     := substr(a2_nome,1,40)
			Else
				_CliFor  := space(6)
				_Nome    := space(40)
			Endif
			
		Else
			
			if left(_CliFor,1) $ "C"
				_CliFor := left(_CliFor,1)+strzero(val(substr(_CliFor,2)),5)
			else
				_CliFor := "C"+strzero(val(substr(_CliFor,1)),5)
			Endif
			
			dbselectarea("SA1")
			dbsetorder(1)
			dbgotop()
			
			if dbseek(xfilial('SA1')+_CliFor,.F.)
				_Nome     := substr(a1_nome,1,40)
			Else
				_CliFor  := space(6)
				_Nome    := space(40)
			Endif
			
		Endif
		
	Endif
	
Else
	
	if ! empty(_Nome)
		
		if  empty(_CliFor)
			
			if _nOption == 1
				
				_aFor := u_pesqcad("SA2",@_CliFor, @_Nome , @_aFor)
				
				if len(_aFor) == 0
					_Nome    := space(40)
				Endif
				
			Else
				
				_aCli := u_pesqcad("SA1",@_CliFor, @_Nome , @_aCli)
				
				if len(_aCli) == 0
					_Nome    := space(40)
				Endif
				
			Endif
			
		Endif
		
	Else
		
		_CliFor  := space(6)
		_Nome    := space(40)
		
	Endif
	
Endif

if  _nOption == 1
	dbselectarea("SE2")
Else
	dbselectarea("SE1")
Endif


_oClifor:refresh()
_oNome:refresh()

//oDlgFilPag:refresh()

return(_lret)



////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
user function ParEmi(_Emisde,_EmisAte)
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
local _lret := .t.

if empty( _Emisde)
	_EmisAte := ctod("")
Elseif (!empty( _Emisde)) .and. empty( _EmisAte)
	_EmisAte := _Emisde
Endif

_oEmisDe:refresh()
_oEmisAte:refresh()

//oDlgFilPag:refresh()

return(_lret)



////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
user function ParVcto(_Vencde,_VencAte)
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
local _lret := .t.

if empty( _Vencde)
	_VencAte := ctod("")
Elseif (!empty( _Vencde)) .and. empty( _VencAte)
	_VencAte := _Vencde
Endif

_oVencDe:refresh()
_oVencAte:refresh()

//oDlgFilPag:refresh()

return(_lret)


////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
user function ParBxa(_Baixde,_BaixAte)
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
local _lret := .t.

if empty( _Baixde)
	_BaixAte := ctod("")
Elseif (!empty( _Baixde)) .and. empty( _BaixAte)
	_BaixAte := _Baixde
Endif

_oBaixDe:refresh()
_oBaixAte:refresh()

//oDlgFilPag:refresh()

return(_lret)


////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
user function ParRef(_cReferenc,_oReferenc)
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
local _lret := .t.

if !empty(_cReferenc)
	_aReferenc := iif( !empty(_cReferenc) , u_convcpo(_cReferenc , "R"  ) , {} )
Endif

_oReferenc:refresh()

//oDlgFilPag:refresh()

return(_lret)

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
user function parNat(_cNatureza , _oNatureza)
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
local _lret := .t.

if !empty(_cNatureza)
	_aNatureza := iif( !empty(_cNatureza) , u_convcpo(_cNatureza , "N"  ) , {} )
Endif

_oNatureza:refresh()

//oDlgFilPag:refresh()

return(_lret)


////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
static function FILCPCus(_CC)
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
local _lret := .t.

if ! empty(_CC)
	_CC := padr(strzero(val(_CC),4),9)
Else
Endif

_oCusto:refresh()
oDlgFilPag:refresh()

return(_lret)

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
user function parvlr(_nValorDe,_nValorAte)
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
local _lret := .t.

if ! empty(_nValorDe)
	if alltrim(upper(readvar())) == '_NVALORDE'
		if _nValorAte == 0
			_nValorAte := _nValorDe
		Endif
	Endif
Else
	if _nValorAte == 0
		_nValorAte := 0 //999999.99
	Endif
Endif

_oValorde:refresh()
_oValorAte:refresh()

oDlgFilPag:refresh()

return(_lret)

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
user function parvnf(_nVlrNfde, _nVlrNfAte )
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
local _lret := .t.

if ! empty(_nVlrNfde)
	if alltrim(upper(readvar())) == '_NVLRNFDE'
		if empty(_nVlrNfAte)
			_nVlrNfAte := _nVlrNfde
		Endif
	Endif
Else
	if empty(_nVlrNfAte)
		_nVlrNfAte := 0//999999.99
	Endif
Endif

_oParcde:refresh()
_oParcAte:refresh()

oDlgFilPag:refresh()

return(_lret)

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
static function FILCPBco(_Bco)
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
local _lret := .t.

if !empty(_Bco)
	_Bco := strzero(val(_Bco),3)
Endif

_oBanco:refresh()
oDlgFilPag:refresh()

return(_lret)

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
static function FILCPFpg(_Fpg)
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
local _lret := .t.

if !empty(_Fpg)
	
	_Fpg := padr(strzero(val(_Fpg),2),4)
	
	
Endif

_oFormpg:refresh()
oDlgFilPag:refresh()

return(_lret)

////////////////////////////////////////
user function filvldst(_cStatus)
////////////////////////////////////////

IF _cstatus <> 'B'
	
	_dBaixDe   := ctod("")
	_dBaixAte  := ctod("")
	
	_oBaixDe:disable()
	_oBaixAte:disable()

	_oBaixDe:refresh()
	_oBaixAte:refresh()

Else	

	_oBaixDe:enable()
	_oBaixAte:enable()

	_oBaixDe:refresh()
	_oBaixAte:refresh()

Endif

return(.t.)


