#include "rwmake.ch"
#include "TOPCONN.CH"

User Function exporta()

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±Funcao    :  EXPORTA  | Autor : Claudenilson Dias    | Data : 31.07.01   ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±Descricao : EXPORTA/IMPORTA ARQUIVOS DA BASE PARA PADRAO XBASE           ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±Uso       : TODAS AS ROTINAS                                             ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/

_cAreexp    := Alias()
_nRecexp    := Recno()
_cIndexp    := IndexOrd()
_nNumCorr   := 0
lEnd        := .f.

CriaParam()
Pergunte("EXPORT    ",.f.)

lParam   := lPerg:= .f.
cNumemp  := SM0->M0_CODIGO

_cMsg1  := "Este programa tem a finalidade de exportar, importar, verificar  a integridade de campos"
_cMsg2  := "numericos e dar informacoes sobre as tabelas do DATABASE de qualquer RDD (TOPCONN, XBASE,"
_cMsg3  := "ADS) utilizado.                                                                          "
_cMsg4  := "Os formatos aceitos para filtragem sao os abaixo descritos          "
_cMsg5  := "SE1010 - Tabela SE1010                                              "
_cMsg6  := "SR*    - Todas as tabelas que comecem com 'SR'                      "
_cMsg7  := "SR?    - Todas as tabelas a partir de 'SR'                          "
_cMsg8  := "*      - Todas as tabelas do DATABASE                               "
_cMsg9  := "Os arquivos gerados terao a extensao .DTC"
_cMsg10 := "A pasta de gravacao deve estar com a sintaxe '\PASTA\' no ROOTPATH do PROTHEUS"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Desenha a tela de processamento..........                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 000,00 TO 320,520 DIALOG oDlg TITLE "Processamento de Tabelas"

@ 020,010 Say _cMsg1
@ 030,010 Say _cMsg2
@ 040,010 Say _cMsg3
@ 050,010 Say _cMsg4
@ 060,010 Say _cMsg5
@ 070,010 Say _cMsg6
@ 080,010 Say _cMsg7
@ 090,010 Say _cMsg8
@ 110,010 Say _cMsg9
@ 125,010 Say _cMsg10

@ 010,005 TO 135,260

@ 145,010 BmpButton Type 05  ACTION _Param()
@ 145,060 BmpButton Type 01  ACTION OkProc(@lEnd)
@ 145,110 BmpButton Type 02  ACTION Close(oDlg)


ACTIVATE DIALOG oDlg CENTERED

dbselectarea(_cAreexp)
dbsetorder(_cIndexp)
dbgoto(_nRecexp)

Return nil

//************************************
Static Function _Param()
//************************************

lPerg:=Pergunte("EXPORT    ",.T.)
lParam:=.t.

Return

//************************************
Static Function OkProc(lEnd)
//************************************

If !lParam
	_Param()
Endif

If lPerg
	Processa( {|| RunProc(@lEnd) } )
Endif

Return(nil)

//************************************
Static Function RunProc(lEnd)
//************************************
Local _xtz := 0
local i := 0
_lTOP := .f.

If __cRDD == "TOPCONN"
	_lTOP := .t.
Endif

_lExporta   := .f.
_lImporta   := .f.
_lInforma   := .f.
_lCorrige   := .f.

_lProcVazio := .f.

_lTodos     := .f.

_lModAtual  := .f.
_lEmpTodos  := .f.
_lDATABASE  := .f.

_cTabela := upper(alltrim(mv_par01))
_cTabdtb := upper(alltrim(mv_par01))
_cPasta  := upper(alltrim(mv_par02))
_nModulo := mv_par03
_nExporta:= mv_par04
_nVazio  := mv_par05
_cMascara:= upper(alltrim(mv_par01))

if  _nExporta == 1
	_lExporta := .t.
Elseif _nExporta == 2
	_lImporta := .t.
Elseif _nExporta == 3
	_lInforma := .t.
Else
	_lCorrige := .t.
Endif

IF  _nVazio == 1
	_lProcVazio := .t.
Endif

if _nModulo == 1
	_lModAtual := .t.
Elseif _nModulo == 2
	_lEmpTodos := .t.
Else
	if _lTop .and. _lExporta
		_lDATABASE := .t.
	Else
		alert("Somente EXPORTACAO no TOPCONNECT pode utilizar o modulo DATABASE !!!")
		lParam:=.F.
		return nil
	Endif
Endif


_nPosMasc := AT("*",_cTabela)  //PESQUISA SUBSTRING DENTRO DA STRING, RETORNA VALOR NUMERICO COM A POSICAO ENCONTRADA
_nPoscont := AT("?",_cTabela)  //PESQUISA SUBSTRING DENTRO DA STRING, RETORNA VALOR NUMERICO COM A POSICAO ENCONTRADA

lCont := .f.

IF _nPoscont > 1
	_cTabela := substr(_cTabela,1,_nPoscont-1)
	lCont := .t.
else
	If _nPoscont == 1
		_cTabela  := "*"
	Else
		IF _nPosMasc > 1
			_cTabela := substr(_cTabela,1,_nPosMasc-1)
		else
			if _nPosMasc = 1
				_cTabela  := "*"
			Else
				if empty(_cTabela)
					_cTabela := '*'
				Endif
			Endif
			
		Endif
	endif
Endif

_nTabela := len(_cTabela)

if _cTabela == "*" .or. _cTabela == "*.*"
	_lTodos := .t.
Endif

_nCtdite := 0
_aArqtmp := {}
_aArqtrf := {}


if  _lDATABASE //.or. _lEmpTodos
	//SELECT name FROM sysobjects WHERE sysstat & 0xf in (3) and name not like '#%' ORDER BY name
	//SELECT * FROM INFORMATION_SCHEMA.TABLES
	if _lTOP
		//cQuery := "SELECT name as NOME FROM sysobjects WHERE sysstat & 0xf in (3) and name not like '#%' ORDER BY name"
		cQuery := "SELECT name as NOME FROM sysobjects WHERE sysstat & 0xf in (3) and name not like '#%' and name not like '%_BKP' and name not like 'TOP_%'ORDER BY name"
		TCQUERY cQuery NEW ALIAS "TRBEXP"
	Endif
Endif

if _lDatabase
	
	_lPosMasc := .f.
	_lMascara := .f.
	
	IF _nPosMasc > 0
		if _nPosMasc == 1
			_cStrComp := ""
			_nTamStr  := 0
			_lPosMasc := .t.
		Else
			_cStrComp := alltrim(upper(substr(_cTabdtb,1,_nPosMasc-1)))
			_nTamStr  := len(_cStrComp)
			_lPosMasc := .t.
		Endif
	Endif
	
	IF _nPoscont > 0
		_cStrComp  := _cTabdtb
		_nTamStr   := len(_cStrComp)
		_lMascara  := .t.
	Endif
	
	//lCont := .t.
	
	dbSelectArea("TRBEXP")
	dbgotop()
	
	procregua(10000)
	
	Do While ! eof()
		
		incproc("Selecionando Tabelas para Processar  - "+TRBEXP->NOME)
		
		_lAdd := .f.
		
		if substr(alltrim(upper(TRBEXP->NOME)),1,4) <> 'TOP_' // .AND. alltrim(upper(TRBEXP->NOME)) <> 'TOP_SP'
			
			//		if alltrim(upper(TRBEXP->NOME)) <> 'TOP_FIELD' .AND. alltrim(upper(TRBEXP->NOME)) <> 'TOP_SP'
			
			if _lPosMasc
				if substr(alltrim(upper(TRBEXP->NOME)),1,_nTamStr) == _cStrComp .or. empty(_cStrComp)
					_lAdd := .t.
				Endif
			Elseif _lMascara
				
				_cDtbTab := alltrim(upper(TRBEXP->NOME))
				
				if len(_cDtbTab) == _nTamStr
					
					_lAdd := .t.
					
					for _xtz := 1 to _nTamStr
						if substr(_cStrComp,_xtz,1) <> substr(_cDtbTab,_xtz,1) .and. ;
							substr(_cStrComp,_xtz,1) <> "?"
							_lAdd := .f.
						Endif
					Next
				Endif
			Else
				_lAdd := .t.
			Endif
			
			if _lAdd
				_nCtdite ++
				aadd(_aArqtrf,{"EXP",alltrim(upper(TRBEXP->NOME)),"DATABASE","DATABASE",strzero(_nCtdite,5),0,0,""})
			Endif
		Endif
		
		dbskip()
		
	Enddo
	
	dbSelectArea("TRBEXP")
	
	dbclosearea()
	
Else
	
	if _lEmpTodos
		if select("TRBEXP") > 0
			dbSelectArea("TRBEXP")
			dbclosearea()
		Endif
	Endif
	
	dbselectarea("SX2")
	
	_cfilter := dbfilter()
	
	if _lEmpTodos // Nao é somente do modulo, cancela filtro
		dbclearfilter()
	Endif
	
	DBGOTOP()
	procregua(reccount())
	
	
	Do while !eof()
		
		incproc("Analisando dicionario de dados - "+upper(X2_CHAVE))
		
		if  ( lCont  .and. upper(substr(X2_ARQUIVO,1,_nTabela)) >= upper(_cTabela) ) .or. ;
			( !lCont .and. upper(substr(X2_ARQUIVO,1,_nTabela)) == upper(_cTabela) ) .or. ;
			_lTodos
			
			++_nCtdite
			//                          1                         2                        3                        4                     5        6 7 8
			aadd(_aArqtmp,{alltrim(upper(X2_CHAVE)),alltrim(upper(X2_ARQUIVO)),alltrim(upper(X2_NOME)),alltrim(upper(X2_PATH)),strzero(_nCtdite,5),0,0,X2_UNICO})
		Endif
		
		dbskip()
		
	Enddo
	
	if _lEmpTodos //  refaz o filtro do SX2
		if ! empty(_cFilter)
			dbsetfilter({|| &(_cFilter)},_cFilter)
		Endif
	endif
	
	_nCtdite := 0
	
	if _lImporta
		
		_aFilTmp := directory(Alltrim(_cPasta)+"*"+ GetDbExtension())
		_aFilPro := aSort( _aFilTmp,,, { |x, y| x[1] < y[1] } )
		
		procregua(len(_aArqTmp))
		
		For i:=1 to len(_aArqTmp)
			
			incproc("Selecionando Importacao - "+_aArqTmp[i][1])
			
			_nTamCpo := len(_aArqTmp[i][2])
			
			nPos := 0
			nPos := aScan(_aFilPro,{ |X| substr(upper(X[1]),1,_nTamCpo) == _aArqTmp[i][2] })
			
			If nPos<> 0
				_nRegCount := 0
				
				dbUseArea(.t.,,Alltrim(_cPasta)+_aFilPro[npos][1],"TMPIMP",.f.)
				
				IF SELECT("TMPIMP") == 0
					alert("Arquivo "+Alltrim(_cPasta)+_aFilPro[npos][1]+" esta em uso !!!")
					loop
				Endif
				
				dbselectarea("TMPIMP")
				_nRegCount := reccount()
				dbclosearea()
				//                               1                              2                             3                          4                            5                   6            7
				aadd(_aArqtrf,{alltrim(upper(_aArqTmp[i][1])),alltrim(upper(_aArqTmp[i][2])),alltrim(upper(_aArqTmp[i][3])),alltrim(upper(_aArqTmp[i][4])),strzero(++_nCtdite,5),_aFilPro[npos][2],_nRegCount,alltrim(upper(_aArqTmp[i][8]))})
			Endif
			
		Next
		
	Else
		
		procregua(len(_aArqTmp))
		
		For i:=1 to len(_aArqTmp)
			incproc("Selecionando Tabelas para Processar  - "+_aArqTmp[i][1])
			aadd(_aArqtrf,{alltrim(upper(_aArqTmp[i][1])),alltrim(upper(_aArqTmp[i][2])),alltrim(upper(_aArqTmp[i][3])),alltrim(upper(_aArqTmp[i][4])),_aArqTmp[i][5],0,0,alltrim(upper(_aArqTmp[i][2]))})
		Next
	Endif
Endif

aStru :={}
aadd(aStru , {"_MARCA" ,"C" ,002,00})
aadd(aStru , {"_ITEM"  ,"C" ,005,00})
aadd(aStru , {"_CHAVE" ,"C" ,003,00})
aadd(aStru , {"_ARQUI" ,"C" ,010,00})
aadd(aStru , {"_DESCR" ,"C" ,030,00})
aadd(aStru , {"_PATH"  ,"C" ,030,00})
aadd(aStru , {"_TOTREG","N" ,010,00})
aadd(aStru , {"_TOTTAM","N" ,010,00})
aadd(aStru , {"_UNICO ","C" ,300,00})

_cArqMov := CriaTrab(aStru,.t.)

dbUseArea(.t.,,_cArqMov,"BRW",.f.)

dbSelectArea("BRW")

procregua(len(_aArqTrf))

_nitchv  := 0
_nProTam := 0
_nProQtd := 0

For i:=1 to len(_aArqTrf)
	
	_cArqAlias  := _aArqTrf[i][1]
	_cArqtrf    := upper(alltrim(_aArqTrf[i][2]))
	
	incproc("Consistindo Informacoes..."+_cArqAlias+'-'+_cArqtrf)
	
	_lOpen := .f. // SE TABELA FOI ABERTA FORA DO MODULO
	
	if _lDATABASE
		
		_cArqtrf    := upper(alltrim(_aArqTrf[i][2]))
		_cArqAlias  := "QXP"
		
		If MSFile(_cArqtrf,,__cRDD)
			
			// TABELA EXISTE NO DATABASE
			
			if !msopendbf(.t.,__cRDD,_cArqtrf,_cArqAlias,.t.)
				msgbox("!! Tabela "+_cArqtrf+" nao disponivel para exportacao !!!",,"STOP")
				loop
			Else
				_lOpen := .t.
			Endif
		Else
			//msgbox("!! Tabela "+_cArqtrf+" nao existe !!!",,"STOP")
			loop
		EndIf
		
	Else
		
		if ! select(_cArqAlias) > 0
			
			// O ARQUIVO NAO ESTA ABERTO NA ROTINA
			
			if ! _lImporta
				
				// NAO É IMPORTACAO
				
				If _lTOP
					
					// UTILIZA TOPCONNECT
					
					_cArqtrf  := RetArq(__cRDD,_cArqtrf)
					
					If MSFile(_cArqtrf,,__cRDD)
						
						// TABELA EXISTE NO DATABASE
						
						if !chkfile(_cArqAlias,.f.)
							msgbox("!! Tabela "+_cArqtrf+" nao disponivel para exportacao !!!",,"STOP")
							loop
						Else
							_lOpen := .t.
						Endif
					Else
						//msgbox("!! Tabela "+_cArqtrf+" nao existe !!!",,"STOP")
						loop
					EndIf
					
				Else
					
					if file(_aArqTrf[i][4]+_cArqtrf + GetDbExtension())
						dbusearea(.t.,,_aArqTrf[i][4]+_cArqtrf,_cArqAlias,.t.)
						_lOpen := .t.
						
					Else
						//msgbox("!! Tabela "+_aArqTrf[i][4]+_cArqtrf+" nao existe !!!",,"STOP")
						loop
					Endif
				Endif
			Else
				// É IMPORTACAO
				If _lTOP
					//_cArqtrf  := RetArq(__cRDD,_aArqTrf[i][4]+_cArqtrf)
					
					_cArqtrf  := RetArq(__cRDD,_cArqtrf)
					
					If  MSFile(_cArqtrf,,__cRDD)
						
						// A TABELA NAO PERTENCE A ESTE MÓDULO
						// E JA EXISTE NO DATABASE
						// 03/09/2005
						//msgbox("!! Tabela "+_cArqtrf+" ja existe no DATABASE !!!",,"STOP")
						loop
					EndIf
				Else
					if file(_aArqTrf[i][4]+_cArqtrf + GetDbExtension())
						
						// A TABELA NAO PERTENCE A ESTE MÓDULO
						// E JA EXISTE NO DATABASE
						// 03/09/2005
						//msgbox("!! Tabela "+_cArqtrf+" ja existe no DATABASE !!!",,"STOP")
						loop
					Endif
				Endif
			Endif
			
		Else
			
			// O ARQUIVO ESTA ABERTO NA ROTINA
			
			DbSelectArea(_cArqAlias)
			
			if _lImporta .and. reccount() > 0
				// 03/09/2005
				//msgbox("!! Tabela "+_cArqtrf+" ja contem DADOS !!!",,"STOP")
				loop
			Endif
			
		Endif
	Endif
	
	if ( !_lImporta  .and. (_nVazio == 1 .or. reccount() > 0)) .or. _lImporta
		
		// NAO É IMPORTACAO E ARQUIVO TEM REGISTROS
		// OU CONSIDERA ARQ. VAZIO
		
		// OU É IMPORTACAO
		
		_nTamreg := 0
		_nNumReg := 0
		_nTamarq := 0
		
		if ! _lImporta
			
			// NAO É IMPORTACAO
			
			_nNumReg  := reccount()
			_nTamreg  := recsize()
			
			_nTamArq  := int( ((_nNumReg*_nTamreg)+300) / 1024 )
			
		Endif
		
		if RecLock("BRW",.T.)
			
			BRW->_MARCA  :=  ""
			BRW->_ITEM   := strzero(++_nitchv,5)
			BRW->_CHAVE  := _cArqAlias
			BRW->_ARQUI  := _cArqtrf
			BRW->_DESCR  := _aArqTrf[i][3]
			
			if ! _lImporta
				BRW->_TOTREG :=	_nNumReg
				BRW->_TOTTAM := _nTamarq
				_nProTam     += _nTamArq
			Else
				_nTamArq  := int( _aArqTrf[i][6] / 1024 )
				
				BRW->_TOTREG :=	_aArqTrf[i][7]
				BRW->_TOTTAM := _nTamArq
				_nProTam     += _nTamArq
			Endif
			
			
			BRW->_PATH  := _aArqTrf[i][4]
			BRW->_UNICO := _aArqTrf[i][8]
			
			msunlock()
			
			_nProQtd     ++
			
			
		Endif
		
		
	Endif
	
	if _lOpen
		DbSelectArea(_cArqAlias)
		dbclosearea()
	Endif
	
Next

procregua(0)


dbSelectArea("BRW")
dbGoTop()


Campos:={}

aadd(Campos , {"_MARCA"  ,""})
aadd(Campos , {"_ITEM "  ,"It."})
aadd(Campos , {"_ARQUI"  ,"Tabela"})
aadd(Campos , {"_DESCR"  ,"Descricao"})
aadd(Campos , {"_TOTREG" ,"Registros","@e 999,999,999",10,0})
aadd(Campos , {"_TOTTAM" ,"Kb","@e 999,999,999",10,0})
aadd(Campos , {"_PATH"   ,"Local"})
aadd(Campos , {"_CHAVE"  ,"Chave"})
aadd(Campos , {"_UNICO"  ,"Unico"})

cTit:="Arquivos disponiveis para processar"

@ 145,013 To 440,622 DIALOG oMov TITLE cTit

@ 002,001 TO 120,305 BROWSE "BRW" Fields Campos ENABLE "!_CHAVE" MARK "_MARCA" object oBrw

@ 130,010 say "TABELAS -> " size 040,010

_cProQtd := str(_nProQtd,4)
_cProTam := transform(_nProTam,"@e 999,999,999")+" Kb"
@ 130,050 get _cProQtd   when .f. size 015,010
@ 130,080 get _cProTam   when .f. size 050,010

@ 130,180 BmpButton Type 01  ACTION Processa( {|| OkTRF(@lEnd) } )
@ 130,220 BmpButton Type 02  ACTION Close(oMov)

oBrw:bMark := { || AtuaPro()}

ACTIVATE DIALOG oMov

IF LastKey() == 27
	Close(oMov)
ENDIF

dbSelectArea("BRW")
dbclosearea()

_cArqMov := _cArqMov + GetDbExtension()
DELE FILE &_cArqMov

lParam:=.F.

Return NIL

//************************************
//************************************
Static Function OkTRF(lEnd)
//************************************
//************************************

Close(oMov)

dbSelectArea("BRW")
dbGoTop()

_aArqPro := {}
_aArqInf := {}


While !Eof()
	
	If Marked("_MARCA")
		aadd(_aArqPro,{ALLTRIM(BRW->_chave),ALLTRIM(BRW->_ARQUI),SUBSTR(BRW->_DESCR,1,20),ALLTRIM(BRW->_PATH),alltrim(transform(BRW->_TOTTAM,"@e 999,999,999")+" Kb"),ALLTRIM(BRW->_UNICO)})
		if _lInforma
			aadd(_aArqInf,{ ALLTRIM(BRW->_ARQUI)+"-"+SUBSTR(BRW->_DESCR,1,20),BRW->_TOTREG,0,BRW->_TOTTAM,0,0})
		Endif
	Endif
	
	dbskip()
	
End

Processa( {|| dbproc(len(_aArqPro)) } )

if _lInforma .or. len(_aArqInf) > 0
	RptStatus({|| Impressao() })
Endif

DbCommitAll()

Return nil


//****************************//
//****************************//
static Function DbProc(nCont1)
//****************************//
//****************************//
Local _nCCC := 0
_lNovoProc := .f.


if _lNovoProc
	
	oProcess := MsNewProcess():New({|| dbproc2(nCont1,oProcess,"1",0)},"","",.F.)
	
	If _lExporta
		oProcess:cTitle:="Exportando Tabelas...Aguarde !!"
	Elseif _lImporta
		oProcess:cTitle:="Importando Tabelas...Aguarde !!"
	Elseif _lCorrige
		oProcess:cTitle:="Corrigindo Tabelas...Aguarde !!"
	Else
		oProcess:cTitle:="Processando arquivo...Aguarde !!"
	Endif
	
	oProcess:Activate()
	
Else
	
	_cTitPro := ""
	
	If _lExporta
		_cTitPro := "Exportando Tabelas...Aguarde !!"
	Elseif _lImporta
		_cTitPro := "Importando Tabelas...Aguarde !!"
	Elseif _lCorrige
		_cTitPro := "Corrigindo Tabelas...Aguarde !!"
	Else
		_cTitPro := "Processando arquivo...Aguarde !!"
	Endif
	
	procregua(nCont1)
	
	For _nCCC :=1 to nCont1
		incproc(Alltrim(str(_nCCC,5,0))+'/'+alltrim(str(len(_aArqPro),5,0))+'-'+alltrim(_aArqPro[_nCCC][3])+"-"+_cArqtrf+"-"+_aArqPro[_nCCC][5])
		Processa( {|| dbproc2(nCont1,_cTitPro,"2",_nCCC) } )
	Next
	
Endif

Return nil

//**********************//
//**********************//
Static Function dbproc2(nCont1,oProcess,_cTipPro,_nCtdPro)
//**********************//
//**********************//
Local y := 0
Local x := 0
Local i := 0

if _cTipPro == '1'
	
	oProcess:SetRegua1(nCont1)
	
	For i:=1 to nCont1
		
		_lOpen := .f.
		
		_cArqAlias  := _aArqPro[i][1]
		_cArqTrf    := _aArqPro[i][2]
		
		
		//oProcess:IncRegua1("Proc.. "+Alltrim(str(i,5,0))+' / '+alltrim(str(len(_aArqPro),5,0))+' - '+alltrim(_aArqPro[i][3])+"-"+_cArqtrf+" - "+_aArqPro[i][5])
		oProcess:IncRegua1(Alltrim(str(i,5,0))+'/'+alltrim(str(len(_aArqPro),5,0))+'-'+alltrim(_aArqPro[i][3])+"-"+_cArqtrf+"-"+_aArqPro[i][5])
		
		
		if _lDATABASE
			
			_cArqtrf    := upper(alltrim(_aArqPro[i][2]))
			_cArqAlias  := "QXP"
			
			If MSFile(_cArqtrf,,__cRDD)
				
				// TABELA EXISTE NO DATABASE
				
				if !msopendbf(.t.,__cRDD,_cArqtrf,_cArqAlias,.t.)
					msgbox("!! Tabela "+_cArqtrf+" nao disponivel para exportacao !!!",,"STOP")
					loop
				Else
					_lOpen := .t.
				Endif
			Else
				//msgbox("!! Tabela "+_cArqtrf+" nao existe !!!",,"STOP")
				loop
			EndIf
			
		Else
			
			if ! select(_cArqAlias) > 0
				If _lTOP
					_cArqtrf  := RetArq(__cRDD,_cArqTrf)
					If MSFile(_cArqtrf,,__cRDD)
						if !chkfile(_cArqAlias,.f.)
							msgbox("!! Tabela "+_cArqtrf+" nao disponivel para exportacao !!!",,"STOP")
							loop
						Else
							_lOpen := .t.
						Endif
						//Else
						//msgbox("!! Tabela "+_cArqtrf+" nao existe !!!",,"STOP")
						//loop
					Else
						if _lImporta
							if !chkfile(_cArqAlias,.f.)
								msgbox("!! Tabela "+_cArqtrf+" nao disponivel para importacao !!!",,"STOP")
								loop
							Else
								_lOpen := .t.
							Endif
						Endif
					EndIf
				Else
					if file(_aArqPro[i][4]+_cArqtrf + GetDbExtension())
						dbusearea(.t.,,_aArqPro[i][4]+_cArqtrf,_cArqAlias,.t.)
						_lOpen := .t.
					Else
						if _lImporta
							if !chkfile(_cArqAlias,.f.)
								msgbox("!! Tabela "+_cArqtrf+" nao disponivel para importacao !!!",,"STOP")
								loop
							Else
								_lOpen := .t.
							Endif
						Endif
					Endif
				Endif
			Endif
			
		Endif
		
		DbSelectArea(_cArqAlias)
		_nOrdtrf := IndexOrd()
		dbsetorder(0)
		dbgotop()
		
		if _lexporta
			
			_cALiasExp := alias()
			_cArq      := Alltrim(_cPasta)+_cArqtrf + GetDbExtension()
			_nTamArq   := reccount()
			_ainfo     := dbstruct()
			_aArqInt   := {}
			
			For y := 1 to len(_ainfo)
				if  _ainfo[y][2] == "N"
					aadd(_aArqInt,{_ainfo[y][1],_ainfo[y][3],_ainfo[y][4]})
				Endif
			Next
			
			if !file(_cArq)
				
				//_lExporta := MsgYesNo("Arquivo destino ("+_cArqtrf + GetDbExtension() +") ja existe. Sobrepoe ? ","Sobrepoe arquivo")
				//Endif
				//if _lExporta
				//copy to &_cArq
				
				oProcess:SetRegua2(_nTamArq)
				
				//_cHOraini := time()
				//_cHOraFim := time()
				//__dbCopy((_cArq))
				
				copy stru to &_cArq
				dbUseArea(.t.,,_cArq,"TMPEXP",.f.)
				
				dbSelectArea(_cALiasExp)
				
				_nContReg := 0
				
				Do While ! eof()
					
					_nContReg ++
					
					_cPerc1     :=  str(int((_nContReg/_nTamArq)*100),4)+'%'
					
					oProcess:IncRegua2( "Registro... "+alltrim(STR(_nContReg))+' / '+alltrim(str(_nTamArq))+space(10)+_cPerc1)
					
					if len(_aArqInt) > 0
						
						For x := 1 to len(_aArqInt)
							
							_cCampo  := _aArqInt[x][1]
							_nTamcpo := _aArqInt[x][2]
							_nTamdec := _aArqInt[x][3]
							
							_nTamint := _nTamcpo-( iif( _nTamdec > 0 , _nTamdec+1 , 0 ) )
							
							_lCorCpo := .f.
							
							_lNegativo := .f.
							
							_nValAtu := &_cCampo
							
							if _nValAtu < 0
								_lNegativo := .t.
								_nTamint := iif(_nTamint > 1,_nTamint-1,_nTamint)
							Endif
							
							_nMaxVal := val( replicate('9',_nTamint) +'.'+replicate('9',_nTamdec) )
							
							if _lNegativo
								if _nTamint == 1
									_nMaxVal := 0
								Else
									_nMaxVal := _nMaxVal * (-1)
								Endif
								
								if _nValAtu < _nMaxVal
									_nValAtu := _nMaxVal
									_lCorCpo := .t.
								Endif
							Else
								if _nValAtu > _nMaxVal
									_nValAtu := _nMaxVal
									_lCorCpo := .t.
								endif
							Endif
							
							if _lCorCpo
								//msgbox("Campo   -> "+_cCampo+chr(13)+;
								//"Tamanho -> "+strzero(_nTamcpo,3)+chr(13)+;
								//"Decimal -> "+strzero(_nTamdec,1)+chr(13)+;
								//"Valor Original   -> ["+alltrim(str(&_cCampo,20,_nTamdec))+"] "+chr(13)+;
								//"Valor Modificado -> ["+alltrim(str(_nValAtu,20,_nTamdec))+"] ")
								
								aadd(_aArqInf,{ _cArqtrf,_cCampo,recno(),_nTamcpo,_nTamdec,padl(alltrim(str(&_cCampo,20,_nTamdec)),16),padl(alltrim(str(_nValAtu,20,_nTamdec)),16) })
								
								if RECLOCK(_cALiasExp,.F.)
									replace &_cCampo with _nValAtu
									msunlock()
								Endif
							endif
							
						Next
						
					Endif
					
					
					dbSelectArea("TMPEXP")
					
					if RecLock("TMPEXP",.t.)
						DbSelectArea(_cALiasExp)
						_nFCount := FCount()
						For y := 1 to _nFCount
							DbSelectArea(_cALiasExp)
							_cNome  := FieldName(y)
							_cCampo := FieldGet (y)
							dbSelectArea("TMPEXP")
							FieldPut ( FieldPos ( _cNome ), _cCampo )
						Next
						dbSelectArea("TMPEXP")
						msunlock()
					Endif
					
					DbSelectArea(_cALiasExp)
					dbSkip()
					
				Enddo
				
				dbSelectArea("TMPEXP")
				dbclosearea()
				DbSelectArea(_cALiasExp)
				
				
				//_cHOraFim := time()
				
				//alert("Inicio : "+_cHoraIni+chr(13)+"Inicio : "+_cHoraFim)
				
			Endif
			
		Elseif _lImporta
			
			/*
			
			_cArq     := Alltrim(_cPasta)+_cArqtrf + GetDbExtension()
			
			if file(_cArq)
			//ALERT("Apendando "+_cArq)
			Append from &_cArq
			//ALERT("terminei de appendar"+_cArq)
			Endif
			
			
			*/
			
			_cArq     := Alltrim(_cPasta)+_cArqtrf + GetDbExtension()
			
			if file(_cArq)
				
				_cALiasImp := alias()
				
				dbUseArea(.t.,,_cArq,"TMPIMP",.f.)
				dbSelectArea("TMPIMP")
				dbgotop()
				
				_nTamArq  := reccount()
				_nContReg := 0
				
				oProcess:SetRegua2(_nTamArq)
				
				Do While ! eof()
					
					_nContReg ++
					_cPerc1     :=  str(int((_nContReg/_nTamArq)*100),4)+'%'
					
					oProcess:IncRegua2( "Registro... "+alltrim(STR(_nContReg))+' / '+alltrim(str(_nTamArq))+space(10)+_cPerc1)
					
					dbSelectArea(_cALiasImp)
					
					if RecLock(_cALiasImp,.t.)
						DbSelectArea("TMPIMP")
						_nFCount := FCount()
						For y := 1 to _nFCount
							DbSelectArea("TMPIMP")
							_cNome  := FieldName(y)
							_cCampo := FieldGet(y)
							dbSelectArea(_cALiasImp)
							FieldPut ( FieldPos ( _cNome ), _cCampo )
						Next
						dbSelectArea(_cALiasImp)
						msunlock()
					Endif
					
					DbSelectArea("TMPIMP")
					
					dbSkip()
					
				Enddo
				
				dbSelectArea("TMPIMP")
				dbclosearea()
				
				
				DbSelectArea(_cALiasImp)
				
			Endif
			
		Elseif _lInforma
			
			
		Elseif _lCorrige
			
			_cALiasCor := alias()
			_ainfo     := dbstruct()
			_aArqInt   := {}
			_nTamArq  := reccount()
			_nContReg := 0
			
			For y := 1 to len(_ainfo)
				if  _ainfo[y][2] == "N"
					aadd(_aArqInt,{_ainfo[y][1],_ainfo[y][3],_ainfo[y][4]})
				Endif
			Next
			
			if len(_aArqInt) > 0
				
				oProcess:SetRegua2(_nTamArq)
				
				dbgotop()
				procregua(reccount())
				
				do while ! eof()
					
					if interrupcao(lend)
						exit
					Endif
					
					_nContReg ++
					_cPerc1     :=  str(int((_nContReg/_nTamArq)*100),4)+'%'
					
					oProcess:IncRegua2( "Registro... "+alltrim(STR(_nContReg))+' / '+alltrim(str(_nTamArq))+space(10)+_cPerc1)
					
					For x := 1 to len(_aArqInt)
						
						_cCampo  := _aArqInt[x][1]
						_nTamcpo := _aArqInt[x][2]
						_nTamdec := _aArqInt[x][3]
						
						_nTamint := _nTamcpo-( iif( _nTamdec > 0 , _nTamdec+1 , 0 ) )
						
						_lCorCpo := .f.
						
						_lNegativo := .f.
						
						_nValAtu := &_cCampo
						
						if _nValAtu < 0
							_lNegativo := .t.
							_nTamint := iif(_nTamint > 1,_nTamint-1,_nTamint)
						Endif
						
						_nMaxVal := val( replicate('9',_nTamint) +'.'+replicate('9',_nTamdec) )
						
						if _lNegativo
							
							if _nTamint == 1
								_nMaxVal := 0
							Else
								_nMaxVal := _nMaxVal * (-1)
							Endif
							
							if _nValAtu < _nMaxVal
								_nValAtu := _nMaxVal
								_lCorCpo := .t.
							Endif
						Else
							if _nValAtu > _nMaxVal
								_nValAtu := _nMaxVal
								_lCorCpo := .t.
							endif
						Endif
						
						if _lCorCpo
							
							//msgbox("Campo   -> "+_cCampo+chr(13)+;
							//"Tamanho -> "+strzero(_nTamcpo,3)+chr(13)+;
							//"Decimal -> "+strzero(_nTamdec,1)+chr(13)+;
							//"Valor Original   -> ["+alltrim(str(&_cCampo,20,_nTamdec))+"] "+chr(13)+;
							//"Valor Modificado -> ["+alltrim(str(_nValAtu,20,_nTamdec))+"] ")
							
							aadd(_aArqInf,{_cArqtrf,_cCampo,recno(),_nTamcpo,_nTamdec,padl(alltrim(str(&_cCampo,20,_nTamdec)),16),padl(alltrim(str(_nValAtu,20,_nTamdec)),16)})
							
							
							if RECLOCK(_cALiasCor,.F.)
								replace &_cCampo with _nValAtu
								msunlock()
							Endif
						endif
						
					Next
					
					dbskip()
					
				Enddo
			Endif
		Endif
		
		dbsetorder(_nOrdtrf)
		
		if _lOpen
			DbSelectArea(_cArqAlias)
			dbclosearea()
		Endif
		
		if interrupcao(lend)
			exit
		Endif
		
	Next
	
Else
	
	_lOpen := .f.
	
	_cArqAlias  := _aArqPro[_nCtdPro][1]
	_cArqTrf    := _aArqPro[_nCtdPro][2]
	_cArqUnq    := _aArqPro[_nCtdPro][6]
	
	_nOrdInd := 1
	_cunikey := _cArqunq
	
	if !empty(_cArqunq)
		
		dbselectarea("SIX")
		dbsetorder(1)
		dbgotop()
		
		if dbseek(_cArqAlias)
			
			Do While ! eof() .AND. INDICE == _cArqAlias
				
				IF INDICE == "SD2" .AND. ordem == "3"
					_cunikey :=upper(alltrim(CHAVE))
					_nOrdInd := 3
					exit
				Else
					IF ordem == "1"
						_cunikey :=upper(alltrim(CHAVE))
					Endif
					
					if  upper(alltrim(CHAVE)) == upper(alltrim(_cArqunq))
						_cunikey :=upper(alltrim(CHAVE))
						_nOrdInd := val(ordem)
						exit
					Endif
				Endif
				
				dbskip()
				
			Enddo
		Endif
	Endif
	
	if _lDATABASE
		
		_cArqtrf    := upper(alltrim(_aArqPro[_nCtdPro][2]))
		_cArqAlias  := "QXP"
		
		If MSFile(_cArqtrf,,__cRDD)
			
			// TABELA EXISTE NO DATABASE
			
			if !msopendbf(.t.,__cRDD,_cArqtrf,_cArqAlias,.t.)
				msgbox("!! Tabela "+_cArqtrf+" nao disponivel para exportacao !!!",,"STOP")
				return nil //loop
			Else
				_lOpen := .t.
			Endif
		Else
			//msgbox("!! Tabela "+_cArqtrf+" nao existe !!!",,"STOP")
			return nil //loop
		EndIf
		
	Else
		
		if ! select(_cArqAlias) > 0
			If _lTOP
				_cArqtrf  := RetArq(__cRDD,_cArqTrf)
				If MSFile(_cArqtrf,,__cRDD)
					if !chkfile(_cArqAlias,.f.)
						msgbox("!! Tabela "+_cArqtrf+" nao disponivel para exportacao !!!",,"STOP")
						return nil //loop
					Else
						_lOpen := .t.
					Endif
					//Else
					//msgbox("!! Tabela "+_cArqtrf+" nao existe !!!",,"STOP")
					//loop
				Else
					if _lImporta
						if !chkfile(_cArqAlias,.f.)
							msgbox("!! Tabela "+_cArqtrf+" nao disponivel para importacao !!!",,"STOP")
							return nil //loop
						Else
							_lOpen := .t.
						Endif
					Endif
				EndIf
			Else
				if file(_aArqPro[_nCtdPro][4]+_cArqtrf + GetDbExtension())
					dbusearea(.t.,,_aArqPro[_nCtdPro][4]+_cArqtrf,_cArqAlias,.t.)
					_lOpen := .t.
				Else
					if _lImporta
						if !chkfile(_cArqAlias,.f.)
							msgbox("!! Tabela "+_cArqtrf+" nao disponivel para importacao !!!",,"STOP")
							return nil //loop
						Else
							_lOpen := .t.
						Endif
					Endif
				Endif
			Endif
		Endif
		
	Endif
	
	DbSelectArea(_cArqAlias)
	_nOrdtrf := IndexOrd()
	dbsetorder(0)
	dbgotop()
	
	if _lexporta
		
		_cALiasExp := alias()
		_cArq      := Alltrim(_cPasta)+_cArqtrf + GetDbExtension()
		_nTamArq   := reccount()
		_ainfo     := dbstruct()
		_aArqInt   := {}
		
		For y := 1 to len(_ainfo)
			if  _ainfo[y][2] == "N"
				aadd(_aArqInt,{_ainfo[y][1],_ainfo[y][3],_ainfo[y][4]})
			Endif
		Next
		
		if !file(_cArq)
			
			//_lExporta := MsgYesNo("Arquivo destino ("+_cArqtrf + GetDbExtension() +") ja existe. Sobrepoe ? ","Sobrepoe arquivo")
			//Endif
			//if _lExporta
			//copy to &_cArq
			
			procregua(_nTamArq)
			
			//_cHOraini := time()
			//_cHOraFim := time()
			//__dbCopy((_cArq))
			
			copy stru to &_cArq
			dbUseArea(.t.,,_cArq,"TMPEXP",.f.)
			
			dbSelectArea(_cALiasExp)
			
			_nContReg := 0
			
			Do While ! eof()
				
				_nContReg ++
				
				_cPerc1     :=  str(int((_nContReg/_nTamArq)*100),4)+'%'
				
				incproc("Registro... "+alltrim(STR(_nContReg))+' / '+alltrim(str(_nTamArq))+space(10)+_cPerc1)
				
				if len(_aArqInt) > 0
					
					For x := 1 to len(_aArqInt)
						
						_cCampo  := _aArqInt[x][1]
						_nTamcpo := _aArqInt[x][2]
						_nTamdec := _aArqInt[x][3]
						
						_nTamint := _nTamcpo-( iif( _nTamdec > 0 , _nTamdec+1 , 0 ) )
						
						_lCorCpo := .f.
						
						_lNegativo := .f.
						
						_nValAtu := &_cCampo
						
						if _nValAtu < 0
							_lNegativo := .t.
							_nTamint := iif(_nTamint > 1,_nTamint-1,_nTamint)
						Endif
						
						_nMaxVal := val( replicate('9',_nTamint) +'.'+replicate('9',_nTamdec) )
						
						if _lNegativo
							if _nTamint == 1
								_nMaxVal := 0
							Else
								_nMaxVal := _nMaxVal * (-1)
							Endif
							
							if _nValAtu < _nMaxVal
								_nValAtu := _nMaxVal
								_lCorCpo := .t.
							Endif
						Else
							if _nValAtu > _nMaxVal
								_nValAtu := _nMaxVal
								_lCorCpo := .t.
							endif
						Endif
						
						if _lCorCpo
							//msgbox("Campo   -> "+_cCampo+chr(13)+;
							//"Tamanho -> "+strzero(_nTamcpo,3)+chr(13)+;
							//"Decimal -> "+strzero(_nTamdec,1)+chr(13)+;
							//"Valor Original   -> ["+alltrim(str(&_cCampo,20,_nTamdec))+"] "+chr(13)+;
							//"Valor Modificado -> ["+alltrim(str(_nValAtu,20,_nTamdec))+"] ")
							
							aadd(_aArqInf,{ _cArqtrf,_cCampo,recno(),_nTamcpo,_nTamdec,padl(alltrim(str(&_cCampo,20,_nTamdec)),16),padl(alltrim(str(_nValAtu,20,_nTamdec)),16) })
							
							if RECLOCK(_cALiasExp,.F.)
								replace &_cCampo with _nValAtu
								msunlock()
							Endif
						endif
						
					Next
					
				Endif
				
				
				dbSelectArea("TMPEXP")
				
				if RecLock("TMPEXP",.t.)
					DbSelectArea(_cALiasExp)
					
					_nFCount := FCount()
					For y := 1 to _nFCount
						DbSelectArea(_cALiasExp)
						_cNome  := FieldName(y)
						_cCampo := FieldGet (y)
						dbSelectArea("TMPEXP")
						FieldPut ( FieldPos ( _cNome ), _cCampo )
					Next
					dbSelectArea("TMPEXP")
					msunlock()
				Endif
				
				DbSelectArea(_cALiasExp)
				dbSkip()
				
			Enddo
			
			dbSelectArea("TMPEXP")
			dbclosearea()
			DbSelectArea(_cALiasExp)
			
			
			//_cHOraFim := time()
			
			//alert("Inicio : "+_cHoraIni+chr(13)+"Inicio : "+_cHoraFim)
			
		Endif
		
	Elseif _lImporta
		
		/*
		
		_cArq     := Alltrim(_cPasta)+_cArqtrf + GetDbExtension()
		
		if file(_cArq)
		//ALERT("Apendando "+_cArq)
		Append from &_cArq
		//ALERT("terminei de appendar"+_cArq)
		Endif
		
		
		*/
		
		_cArq     := Alltrim(_cPasta)+_cArqtrf + GetDbExtension()
		
		if file(_cArq)
			
			_cALiasImp := alias()
			
			dbUseArea(.t.,,_cArq,"TMPIMP",.f.)
			
			IF SELECT("TMPIMP") > 0
				
				dbSelectArea("TMPIMP")
				dbgotop()
				
				_nTamArq  := reccount()
				_nContReg := 0
				
				procregua(_nTamArq)
				
				Do While ! eof()
					
					_nContReg ++
					_cPerc1     :=  str(int((_nContReg/_nTamArq)*100),4)+'%'
					
					_CtdTabAtu := Alltrim(str(_nCtdPro,5,0))
					_CtdTabTot := alltrim(str(len(_aArqPro),5,0))
					_CtdTabNom := _cArqtrf+"-"+alltrim(_aArqPro[_nCtdPro][3]) //+"-"+_aArqPro[_nCtdPro][5]
					_CtdRegAtu := alltrim(STR(_nContReg))
					_CtdRegTot := alltrim(str(_nTamArq))
					
					incproc(_CtdTabAtu+'/'+_CtdTabTot+" "+_CtdRegAtu+'/'+_CtdRegTot+space(1)+_cPerc1+'-'+_CtdTabNom)
					
					_lContimp := .t.
					
					dbSelectArea(_cALiasImp)
					
					if !empty(_cArqunq)
						
						
						dbSelectArea(_cALiasImp)
						dbsetorder(_nOrdInd)
						dbgotop()
						
						_cChvunq := TMPIMP->(&_cUnikey)
						
						//ALERT(_cChvunq)
						
						if dbseek(_cChvunq)
							
							dbSelectArea("TMPIMP")
							
							_cCpoFilial := "TMPIMP->"+substr(FieldName(1), 1, AT("_",FieldName(1))) + "FILIAL"
							
							//ALERT(_cCpoFilial)
							
							if RecLock("TMPIMP",.F.)
								&_cCpoFilial := "X"+SUBSTR(&_cCpoFilial,2,1)
								msunlock()
							Endif
							
							_lContimp := .f.
							
							
						Endif
						
					Endif
					
					dbSelectArea(_cALiasImp)
					
					if _lContimp
						
						if RecLock(_cALiasImp,.t.)
							
							DbSelectArea("TMPIMP")
							
							_nFCount := FCount()
							
							For y := 1 to _nFCount
								DbSelectArea("TMPIMP")
								_cNome  := FieldName(y)
								_cCampo := FieldGet(y)
								dbSelectArea(_cALiasImp)
								FieldPut ( FieldPos ( _cNome ), _cCampo )
							Next
							
							dbSelectArea(_cALiasImp)
							
							msunlock()
							
						Endif
						
					Endif
					
					DbSelectArea("TMPIMP")
					
					dbSkip()
					
				Enddo
				
				dbSelectArea("TMPIMP")
				dbclosearea()
				
			Else
				
				alert("Arquivo "+Alltrim(_cPasta)+_aFilPro[npos][1]+" Nao existe ou esta em uso !!!")
				
			Endif
			
			DbSelectArea(_cALiasImp)
			
		Endif
		
	Elseif _lInforma
		
		
	Elseif _lCorrige
		
		_cALiasCor := alias()
		_ainfo     := dbstruct()
		_aArqInt   := {}
		_nTamArq  := reccount()
		_nContReg := 0
		
		For y := 1 to len(_ainfo)
			if  _ainfo[y][2] == "N"
				aadd(_aArqInt,{_ainfo[y][1],_ainfo[y][3],_ainfo[y][4]})
			Endif
		Next
		
		if len(_aArqInt) > 0
			
			procregua(_nTamArq)
			
			dbgotop()
			procregua(reccount())
			
			do while ! eof()
				
				if interrupcao(lend)
					exit
				Endif
				
				_nContReg ++
				_cPerc1     :=  str(int((_nContReg/_nTamArq)*100),4)+'%'
				
				incproc( "Registro... "+alltrim(STR(_nContReg))+' / '+alltrim(str(_nTamArq))+space(10)+_cPerc1)
				
				For x := 1 to len(_aArqInt)
					
					_cCampo  := _aArqInt[x][1]
					_nTamcpo := _aArqInt[x][2]
					_nTamdec := _aArqInt[x][3]
					
					_nTamint := _nTamcpo-( iif( _nTamdec > 0 , _nTamdec+1 , 0 ) )
					
					_lCorCpo := .f.
					
					_lNegativo := .f.
					
					_nValAtu := &_cCampo
					
					if _nValAtu < 0
						_lNegativo := .t.
						_nTamint := iif(_nTamint > 1,_nTamint-1,_nTamint)
					Endif
					
					_nMaxVal := val( replicate('9',_nTamint) +'.'+replicate('9',_nTamdec) )
					
					if _lNegativo
						
						if _nTamint == 1
							_nMaxVal := 0
						Else
							_nMaxVal := _nMaxVal * (-1)
						Endif
						
						if _nValAtu < _nMaxVal
							_nValAtu := _nMaxVal
							_lCorCpo := .t.
						Endif
					Else
						if _nValAtu > _nMaxVal
							_nValAtu := _nMaxVal
							_lCorCpo := .t.
						endif
					Endif
					
					if _lCorCpo
						
						//msgbox("Campo   -> "+_cCampo+chr(13)+;
						//"Tamanho -> "+strzero(_nTamcpo,3)+chr(13)+;
						//"Decimal -> "+strzero(_nTamdec,1)+chr(13)+;
						//"Valor Original   -> ["+alltrim(str(&_cCampo,20,_nTamdec))+"] "+chr(13)+;
						//"Valor Modificado -> ["+alltrim(str(_nValAtu,20,_nTamdec))+"] ")
						
						aadd(_aArqInf,{_cArqtrf,_cCampo,recno(),_nTamcpo,_nTamdec,padl(alltrim(str(&_cCampo,20,_nTamdec)),16),padl(alltrim(str(_nValAtu,20,_nTamdec)),16)})
						
						
						if RECLOCK(_cALiasCor,.F.)
							replace &_cCampo with _nValAtu
							msunlock()
						Endif
					endif
					
				Next
				
				dbskip()
				
			Enddo
		Endif
	Endif
	
	dbsetorder(_nOrdtrf)
	
	if _lOpen
		DbSelectArea(_cArqAlias)
		dbclosearea()
	Endif
	
	if interrupcao(lend)
		return nil //exit
	Endif
	
	
Endif


Return nil

//************************************
Static Function Impressao()
//************************************
Local _nCtdPro := 0
//lResp:=MsgYesNo("Deseja imprimir resumo da transferencia","Transferencia entre Filiais")

//If !lResp
//	Return
//EndIf

if len(_aArqinf) > 0
	
	aSort( _aArqinf,,, {|x,y| X[1] < Y[1]} )
	
	
	cRodaTxt   := ""
	nCntImpr   := 0
	Tamanho    := "P"
	titulo     := "Informacao de Arquivos"
	cDesc1     := "O objetivo deste relatorio e' imprimir um relatorio dos arquivos solicitados"
	cDesc2     := ""
	cDesc3     := ""
	cString    := ""
	nTipo      := 18
	nomeprog   := "EXPORTA"
	wnrel      := "EXPORTA" // Coloque aqui o nome do arquivo usado para impressao em disco
	limite     := 80
	nLin       := 80
	
	//                           1         2         3         4         5         6         7         8
	//                 012345678901234567890123456789012345678901234567890123456789012345678901234567890
	if _lInforma
		Cabec1     := " Arquivo Solicitado                           Registros          Tam.Tabela (kb)"
	Else
		Cabec1     := " Arquivo Campo       Registro  Tam.  Dec    Valor Original   Valor Modificado"
		//              SIGAGPE AAAAAAAAAA 999999999   999   9   9.999.999.999,99   9.999.999.999,99
	Endif
	Cabec2     := ""
	cbtxt      := Space(10)
	cbcont     := 00
	CONTFL     := 01
	m_pag      := 01
	imprime    := .T.
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis para controle do cursor de progressao do relatorio ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nTotRegs := 0 ;nMult := 1 ;nPosAnt := 4 ;nPosAtu := 4 ;nPosCnt := 0
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis tipo Private padrao de todos os relatorios         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aReturn  := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
	
	nLastKey := 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia controle para a funcao SETPRINT                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	wnrel:=SetPrint("BRW",NomeProg,,titulo,cDesc1,cDesc2,cDesc3,.F.,"")
	
	If LastKey() == 27 .or. nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If LastKey() == 27 .or. nLastKey == 27
		Return
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se deve comprimir ou nao                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nTipo  := IIF(aReturn[4]==1,GetMV("MV_COMP"),GetMV("MV_NORM"))
	
	aArea   := GetArea()  // Grava a area atual
	cLoja   := cNumemp
	
	_nTotpro := 0
	
	For _nCtdPro := 1 to len(_aArqinf)
		
		if nlin > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		if _lInforma
			@ nLin,01 pSay strzero(i,3)+" "+_aArqinf[_nCtdPro][1]
			@ nLin,43 pSay _aArqinf[_nCtdPro][2] picture "@e 999,999,999"
			//@ nLin,56 pSay _aArqinf[_nCtdPro][3] picture "9999"
			@ nLin,65 pSay _aArqinf[_nCtdPro][4] picture "@e 999,999,999.99"
			nLin ++
			_nTotpro += _aArqinf[_nCtdPro][4]
		Else
			@ nLin,01 pSay _aArqinf[_nCtdPro][1]
			@ nLin,09 pSay _aArqinf[_nCtdPro][2]
			@ nLin,20 pSay _aArqinf[_nCtdPro][3] picture "999999999"
			@ nLin,32 pSay _aArqinf[_nCtdPro][4] picture "999"
			@ nLin,38 pSay _aArqinf[_nCtdPro][5] picture "9"
			@ nLin,42 pSay _aArqinf[_nCtdPro][6]
			@ nLin,61 pSay _aArqinf[_nCtdPro][7]
			nLin ++
		Endif
		
	Next
	
	nLin ++
	@ nLin,00 pSay Replicate ("-",80)
	if _lInforma
		nLin ++
		@ nLin,65 pSay Trans(_nTotpro,"@E 999,999,999.99")
	Endif
	
	If nlin <> 70
		Roda(0,"",Tamanho)
		setprc(0,0)
	EndIf
	
	If aReturn[5] == 1
		Set Printer To
		dbCommitAll()
		OurSpool(wnrel)
	EndIf
	
	DbCommitAll()
	
	Ms_FLush()
Else
	alert("Nao ha dados a imprimir !!!")
	
Endif

return nil




// *****************************************************************************
Static Function CriaParam()
Local i:=0
Local j:=0

aSvAlias:={Alias(),IndexOrd(),Recno()}

cPerg := PADR("EXPORT",10)
aRegistros:={}
//                                                                           1                                                                                          2                                                          3                               4
//               1      2    3                      4   5   6        7  8  9 0  1   2                        3         4                 5  6  7  8  9                  0  1  2  3  4                  5  6  7  8  9               0  1  2  3  4  5  6  7  8    9  0  1  2
AADD(aRegistros,{cPerg,"01","Arquivo a Exportar ?",".",".","mv_ch1","C",10,0,0,"G",""                      ,"mv_par01",""               ,"","","","",""                ,"","","","",""                ,"","","","",""             ,"","","","","","","","","  ","","","",""})
AADD(aRegistros,{cPerg,"02","Pasta Origem/Desti.?",".",".","mv_ch2","C",30,0,0,"G","u_valdir('MV_PAR02',1)","mv_par02",""               ,"","","","",""                ,"","","","",""                ,"","","","",""             ,"","","","","","","","","  ","","","",""})
AADD(aRegistros,{cPerg,"03","Modulo             ?",".",".","mv_ch3","N",01,0,0,"C",""                      ,"mv_par03","Modulo Atual   ","","","","","Todos Modulos   ","","","","","DATABASE Compl." ,"","","","",""             ,"","","","","","","","","  ","","","",""})
AADD(aRegistros,{cPerg,"04","Operacao           ?",".",".","mv_ch4","N",01,0,0,"C",""                      ,"mv_par04","Exportar"       ,"","","","","Importar"        ,"","","","","Informacao"      ,"","","","","Corrigir Num.","","","","","","","","","  ","","","",""})
AADD(aRegistros,{cPerg,"05","Considera arq. vazio",".",".","mv_ch5","N",01,0,0,"C",""                      ,"mv_par05","Sim    "        ,"","","","","Nao"             ,"","","","","       "         ,"","","","",""             ,"","","","","","","","","  ","","","",""})


dbSelectArea("SX1")
dbsetorder(1)

For i := 1 to Len(aRegistros)
	dbgotop()
	dbSeek(aRegistros[i,1]+aRegistros[i,2])
	if eof()
		if RecLock("SX1",.T.)
			For j:=1 to 42
				FieldPut(j,aRegistros[i,j])
			Next
			MsUnlock()
		Endif
	Endif
Next i

dbSelectArea(aSvAlias[1])
dbSetOrder(aSvAlias[2])
dbGoto(aSvAlias[3])

Return(nil)


/**************************************/
/**************************************/
USER Function valdir(_cVariavel,_nModo)
/**************************************/
/**************************************/
local _cTitulo

If _nModo == NIL
	_nModo   := 1
Endif

If _nModo == 1
	_cTitulo := "Selecao de Pasta"
Else
	_cTitulo := "Selecao de Arquivo"
Endif


IF  EMPTY(&_cVariavel)
	
	If _nModo == 1
		_cTipo :=          "Pasta Atual       (*.*)    | .       "
	Else
		_cTipo :=          "Todos os Arquivos (*.*)    | *.*   | "
		_cTipo := _cTipo + "Arquivos de Texto (*.TXT)  | *.TXT | "
		_cTipo := _cTipo + "Arquivos de Dados (*.DTC)  | *.DTC | "
		_cTipo := _cTipo + "Figuras           (*.BMP)  | *.BMP | "
	Endif
	
	_CFILE := upper(alltrim(cGetFile(_cTipo,_cTitulo)))
	
	if _nModo == 1
		
		_PosBAR := rat("\",_CFILE)
		
		if _PosBAR > 0
			_CFILE := substr(_CFILE,1,_PosBAR)
		Endif
		
	Endif
	
	&_cVariavel := _CFILE
	
Endif

RETURN(.T.)


//**********************//
//**********************//
Static Function AtuaPro()
//**********************//
//**********************//

If BRW->_MARCA == Thismark()
	_nProQtd  --
	_nProTam  -= BRW->_TOTTAM
Else
	_nProQtd  ++
	_nProTam  += BRW->_TOTTAM
Endif

_cProQtd := str(_nProQtd,4)
_cProTam := transform(_nProTam,"@e 999,999,999")+" Kb"
@ 130,050 get _cProQtd   when .f. size 015,010
@ 130,080 get _cProTam   when .f. size 040,010

oBrw:oBrowse:refresh()

Return nil

