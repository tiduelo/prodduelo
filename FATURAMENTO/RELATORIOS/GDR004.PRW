#Include "PROTHEUS.Ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "RPTDEF.CH"

//---------------------------------------------------------------------------------------

//////////////////////////////////////
//////////////////////////////////////
user function GDR004()
//////////////////////////////////////
// 20/06/2013 - Rastreabiliade de vendas Por cliente
//////////////////////////////////////
Local _cPerg    := Padr("GDR004",Len(SX1->X1_GRUPO))
local _lWindows := iif(GetRemoteType() == 1 , .t. , .f. )

_cEmpCod  := sm0->m0_codigo
_cFilCod  := sm0->m0_codfil

_cTitulo1 := " "
_cTitulo2 := " "
_cTitulo3 := " "

//
// Pastas padrao para arquivos temporarios
//

_cTmpRep    := CriaTrab(,.F.) + GetDbExtension()
_cTmpRepi   := strtran(_cTmpRep,GetDbExtension(),".IDX")

//
// Informacoes para o relatorio em Crystal Report
//

_cSrvFolder := getmv("MV_CRYSTAL")
_cCryTitulo := "V01 - Resumo de Vendas"
_cLocFolder := 'C:\PROTHEUS\CRYSTAL\'

_cCryNome   := "GDR004"

_cLocDBF    := _cLocFolder+_cCryNome+ GetDbExtension()
_cSrvCry    := _cSrvFolder+_cCryNome+'.RPT'
_cLocCry    := _cLocFolder+_cCryNome+'.RPT'

CriaPerg(_cPerg)

Do While .t.
	
	_cCryNome   := "GDR004"
	
	If Pergunte(_cPerg,.t.)
		
		_pDataDe    := mv_par01
		_pDataAte   := mv_par02
		_pEquipe    := mv_par03
		_pGrupo     := mv_par04
		
		_pOrdem     := 1
		
		_lrunproc := .t.
		
		if _lrunproc
			U_GDR004C(_cPerg)
		Endif
		
	Else
		
		Exit
		
	Endif
	
Enddo

Return nil

//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------

////////////////////////////
////////////////////////////
User Function GDR004C(_cPerg)
////////////////////////////
////////////////////////////

_cAreexp    := Alias()
_nRecexp    := Recno()
_cIndexp    := IndexOrd()

if _pOrdem == 1
	_cTitulo1 := "V01 - Resumo de Vendas"
Endif

_cTitulo2 := " "
_cTitulo3 := " "

if select("REPORT") > 0
	REPORT->(dbclosearea())
Endif

//////////////////////////////////////////////////
//////////////////////////////////////////////////
Processa( {|| RunProc(@lEnd) } )
//////////////////////////////////////////////////
//////////////////////////////////////////////////

if _pOrdem == 1
	_cCryNome   := _cCryNome+"A"
Endif

_cLocDBF    := _cLocFolder+_cCryNome+ GetDbExtension()
_cSrvCry    := _cSrvFolder+_cCryNome+'.RPT'
_cLocCry    := _cLocFolder+_cCryNome+'.RPT'

U_ImpCry(_cCryNome,_cCryTitulo,"REPORT",_cTmpRep,_cSrvCry,_cLocFolder,_cLocDBF,_cLocCry)

if select("REPORT") > 0
	REPORT->(dbclosearea())
Endif

if file(_cTmpRep)
	FErase(_cTmpRep)
Endif
if file(_cTmpRepi)
	FErase(_cTmpRepi)
Endif

dbselectarea(_cAreexp)
dbsetorder(_cIndexp)
dbgoto(_nRecexp)

Return nil


//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------

/////////////////////////////////
/////////////////////////////////
static function runproc()
/////////////////////////////////
/////////////////////////////////
Local _nX := 0

dbselectarea("SM0")
_nRecSM0 := recno()

_cFilial   := sm0->m0_codfil
_cEmpresa  := sm0->m0_codfil
_cRazao    := sm0->m0_filial

set filter to
dbsetorder(1)

//////////////////////////////////////////////////
///////////////// Gera Strutura //////////////////
//////////////////////////////////////////////////

_aStru := {}

aadd( _aStru, { "_FILIAL"    , "C" ,    2 , 0 } )

aadd( _aStru, { "_EMPRESA"   , "C" ,    2 , 0 } )
aadd( _aStru, { "_RAZAO  "   , "C" ,   40 , 0 } )

aadd( _aStru, { "_USUARIO"   , "C" ,   15 , 0 } )

aadd( _aStru, { "_PAR01"     , "D" ,   08 , 0 } )
aadd( _aStru, { "_PAR02"     , "D" ,   08 , 0 } )
aadd( _aStru, { "_PAR03"     , "C" ,   1  , 0 } )
aadd( _aStru, { "_PAR04"     , "C" ,   4  , 0 } )

aadd( _aStru, { "_GRUPO01"   , "C" ,   30 , 0 } )
aadd( _aStru, { "_GRUPO02"   , "C" ,   30 , 0 } )
aadd( _aStru, { "_GRUPO03"   , "C" ,   30 , 0 } )

aadd( _aStru, { "_TITULO1"   , "C" ,  050 , 0 } )
aadd( _aStru, { "_TITULO2"   , "C" ,  001 , 0 } )
aadd( _aStru, { "_TITULO3"   , "C" ,  001 , 0 } )

////////////////////////////////////////////////////////////////////

aadd( _aStru, { "A1_FILIAL"  , "C" ,   02 , 0 } )
aadd( _aStru, { "A1_COD"     , "C" ,   06 , 0 } )
aadd( _aStru, { "A1_LOJA"    , "C" ,   02 , 0 } )
aadd( _aStru, { "A1_NOME"    , "C" ,   40 , 0 } )
aadd( _aStru, { "A3_FILIAL"  , "C" ,   02 , 0 } )
aadd( _aStru, { "A3_COD"     , "C" ,   06 , 0 } )
aadd( _aStru, { "A3_EST"     , "C" ,   02 , 0 } )
aadd( _aStru, { "A3_NOME"    , "C" ,   40 , 0 } )
aadd( _aStru, { "A3_TIPO"    , "C" ,   01 , 2 } )
aadd( _aStru, { "B1_FILIAL"  , "C" ,   02 , 0 } )
aadd( _aStru, { "B1_COD"     , "C" ,   30 , 0 } )
aadd( _aStru, { "B1_CONV"    , "N" ,   10 , 2 } )
aadd( _aStru, { "B1_DESC"    , "C" ,   60 , 0 } )
aadd( _aStru, { "B1_PESO"    , "N" ,   11 , 4 } )
aadd( _aStru, { "C5_FILIAL"  , "C" ,   02 , 0 } )
aadd( _aStru, { "C5_CLIENTE" , "C" ,   06 , 0 } )
aadd( _aStru, { "C5_LOJACLI" , "C" ,   02 , 0 } )
aadd( _aStru, { "C5_VEND1"   , "C" ,   06 , 0 } )
aadd( _aStru, { "C5_SAIDA"   , "D" ,   08 , 0 } )
aadd( _aStru, { "C5_NOTA"    , "C" ,   09 , 0 } )
aadd( _aStru, { "D2_FILIAL"  , "C" ,   02 , 0 } )
aadd( _aStru, { "D2_DOC"     , "C" ,   09 , 0 } )
aadd( _aStru, { "D2_CF"      , "C" ,   05 , 0 } )
aadd( _aStru, { "D2_COD"     , "C" ,   30 , 0 } )
aadd( _aStru, { "D2_ICMSRET" , "N" ,   14 , 2 } )
aadd( _aStru, { "D2_QTDEDEV" , "N" ,   11 , 2 } )
aadd( _aStru, { "D2_QUANT"   , "N" ,   15 , 4 } )
aadd( _aStru, { "D2_TOTAL"   , "N" ,   14 , 2 } )
aadd( _aStru, { "D2_TP"      , "C" ,   02 , 0 } )
aadd( _aStru, { "D2_VALIPI"  , "N" ,   14 , 2 } )
aadd( _aStru, { "F2_FILIAL"  , "C" ,   02 , 0 } )
aadd( _aStru, { "F2_CLIENTE" , "C" ,   06 , 0 } )
aadd( _aStru, { "F2_LOJA"    , "C" ,   02 , 0 } )
aadd( _aStru, { "F2_DOC"     , "C" ,   09 , 0 } )

dbcreate( _cTmpRep, _aStru )

if select("REPORT") > 0
	REPORT->(dbclosearea())
Endif

DbUseArea(.T., "CTREECDX", _cTmpRep, "REPORT", .F., .F.)
IndRegua("REPORT",_cTmpRepi,"_GRUPO01+_GRUPO02+_GRUPO03",,,)

dbSetorder(1)

/*///////////////////////////////////////////////////////////////////*/
/*///////////////////////////////////////////////////////////////////*/

_cUsuario := cusername

_cPar01   := _pDataDe
_cPar02   := _pDataAte
_cPar03   := str(_pEquipe,1,0)
_cPar04   := _pGrupo

_cTitulo1 := _cTitulo1
_cTitulo2 := _cTitulo2
_cTitulo3 := " "


/*//////////////////////////////////////////////////////////////////////////////////*/
/* Corpo da query */
/*//////////////////////////////////////////////////////////////////////////////////*/


_cQry := " SELECT "

_cQry += " SA1.A1_FILIAL,SA1.A1_COD,SA1.A1_LOJA, SA1.A1_NOME, SA3.A3_FILIAL,SA3.A3_COD, SA3.A3_NOME, SA3.A3_EST, SA3.A3_TIPO, SB1.B1_FILIAL, SB1.B1_COD, SB1.B1_DESC, SB1.B1_CONV, SB1.B1_PESO, SD2.D2_TOTAL, SD2.D2_VALIPI, SD2.D2_ICMSRET, SC5.C5_FILIAL, SC5.C5_SAIDA, SC5.C5_VEND1, SC5.C5_CLIENTE, SC5.C5_LOJACLI, SC5.C5_NOTA, SD2.D2_FILIAL, SD2.D2_DOC, SD2.D2_COD, SD2.D2_TP, SD2.D2_CF, SD2.D2_QUANT, SD2.D2_QTDEDEV, SF2.F2_FILIAL, SF2.F2_CLIENTE, SF2.F2_LOJA, SF2.F2_DOC, "

_cQry += " ( row_number() over (order by B1_COD DESC ) ) AS ID_LINHA "

_cQry += " FROM " + retsqlname("SA1")+" SA1, "+retsqlname("SA3")+" SA3, "+retsqlname("SB1")+" SB1, "+ retsqlname("SC5")+" SC5, "+retsqlname("SF2")+" SF2, "+retsqlname("SD2")+" SD2 "

_cQry += " WHERE SA1.D_E_L_E_T_<>'*' AND SA3.D_E_L_E_T_<> '*' AND SD2.D_E_L_E_T_<> '*' AND SF2.D_E_L_E_T_<> '*' AND SB1.D_E_L_E_T_<> '*' AND SC5.D_E_L_E_T_<> '*' "

_cQry += " AND SA1.A1_FILIAL = '"+xfilial("SA1")+"' "
_cQry += " AND SA3.A3_FILIAL = '"+xfilial("SA3")+"' "
_cQry += " AND SB1.B1_FILIAL = '"+xfilial("SB1")+"' "
_cQry += " AND SC5.C5_FILIAL = '"+xfilial("SC5")+"' "
_cQry += " AND SF2.F2_FILIAL = '"+xfilial("SF2")+"' "
_cQry += " AND SD2.D2_FILIAL = '"+xfilial("SD2")+"' "

_cQry += " AND SA1.A1_COD     = SF2.F2_CLIENTE "
_cQry += " AND SA1.A1_LOJA    = SF2.F2_LOJA "
_cQry += " AND SD2.D2_DOC     = SF2.F2_DOC "
_cQry += " AND SD2.D2_SERIE   = SF2.F2_SERIE "
_cQry += " AND SD2.D2_CLIENTE = SF2.F2_CLIENTE "
_cQry += " AND SD2.D2_EMISSAO = SF2.F2_EMISSAO "
_cQry += " AND SC5.C5_NOTA    = SF2.F2_DOC "
_cQry += " AND SC5.C5_CLIENTE = SF2.F2_CLIENTE "
_cQry += " AND SC5.C5_LOJACLI = SF2.F2_LOJA "
_cQry += " AND SA3.A3_COD     = SC5.C5_VEND1 "
_cQry += " AND SB1.B1_COD     = SD2.D2_COD "


_cQry += " AND SD2.D2_TP = 'PA' "
_cQry += " AND SF2.F2_DUPL <> ' ' "

_cQry += " AND (SC5.C5_SAIDA >= '"+dtos(_pDatade)+"' AND SC5.C5_SAIDA <= '"+dtos(_pDataAte)+"' )

if _pEquipe == 1 // Vendedores
	_cQry += " AND SA3.A3_TIPO = 'I' "
Elseif _pEquipe == 2 // Representante
	_cQry += " AND SA3.A3_TIPO = 'E' "
Endif

if !empty(_pGrupo) // Grupo
	_cQry += " AND SB1.B1_GRUPO = '"+_pGrupo+"' "
Endif

_cQry += " ORDER BY ID_LINHA DESC "

_cMsgQry := "Selecionando Vendas..."

//alert(_cQry)

/*//////////////////////////////////////////////////////////////////////////////////*/

If ( Select ( "QRYTMP" ) <> 0 )
	dbSelectArea ( "QRYTMP" )
	dbCloseArea ()
Endif

MsgRun(_cMsgQry,"",{|| dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cqRY), "QRYTMP", .F., .T.) })

/*//////////////////////////////////////////////////////////////////////////////////*/

DbSelectArea("SB1")

_aStrutmp:= SB1->(dbStruct())

For _nX := 1 To Len(_aStrutmp)
	If _aStrutmp[_nX,2] $ "DN" .and. upper(alltrim(_aStrutmp[_nX,1])) $ upper(_cQry)
		TcSetField("QRYTMP",_aStrutmp[_nX,1],_aStrutmp[_nX,2],_aStrutmp[_nX,3],_aStrutmp[_nX,4])
	EndIf
Next nX

DbSelectArea("SC5")

_aStrutmp:= SC5->(dbStruct())

For _nX := 1 To Len(_aStrutmp)
	If _aStrutmp[_nX,2] $ "DN" .and. upper(alltrim(_aStrutmp[_nX,1])) $ upper(_cQry)
		TcSetField("QRYTMP",_aStrutmp[_nX,1],_aStrutmp[_nX,2],_aStrutmp[_nX,3],_aStrutmp[_nX,4])
	EndIf
Next nX

DbSelectArea("SD2")

_aStrutmp:= SD2->(dbStruct())

For _nX := 1 To Len(_aStrutmp)
	If _aStrutmp[_nX,2] $ "DN" .and. upper(alltrim(_aStrutmp[_nX,1])) $ upper(_cQry)
		TcSetField("QRYTMP",_aStrutmp[_nX,1],_aStrutmp[_nX,2],_aStrutmp[_nX,3],_aStrutmp[_nX,4])
	EndIf
Next nX

dbselectarea("QRYTMP")
dbgotop()

_nRecPro   := 0
_nRecTotal := QRYTMP->ID_LINHA
procregua(_nRecTotal)


Do While ! eof()
	
	_nRecPro ++
	
	incproc("Produtos... "+alltrim(str(_nRecPro))+" / "+alltrim(str(_nRecTotal))+" - "+alltrim(str(int((_nRecPro/_nRecTotal)*100),3))+ " %" )
	
	//////////////////////////////////////////////////
	///////////// Inicializar Variaveis //////////////
	//////////////////////////////////////////////////
	
	_cGrupo01 := space(30)
	_cGrupo02 := space(30)
	_cGrupo03 := space(30)
	
	cA1_Filial  := space(2)
	cA1_COD     := space(6)
	cA1_Loja    := space(2)
	cA1_NOME    := space(40)
	cA3_Filial  := space(2)
	cA3_COD     := space(6)
	cA3_EST     := space(2)
	cA3_NOME    := space(40)
	cA3_TIPO    := space(1)
	cB1_Filial  := space(2)
	cB1_COD     := space(30)
	nB1_CONV    := 0
	cB1_DESC    := space(60)
	nB1_PESO    := 0
	cC5_Filial  := space(2)
	cC5_Cliente := space(6)
	cC5_Lojacli := space(2)
	cC5_Nota    := space(9)
	cC5_Vend1   := space(6)
	dC5_SAIDA   := ctod("")
	cD2_Filial  := space(2)
	cD2_Doc     := space(9)
	cD2_CF      := space(5)
	cD2_COD     := space(30)
	nD2_ICMSRET := 0
	nD2_QTDEDEV := 0
	nD2_QUANT   := 0
	nD2_TOTAL   := 0
	cD2_TP      := space(2)
	nD2_VALIPI  := 0
	cF2_Filial  := space(2)
	cF2_Cliente := space(6)
	cF2_Loja    := space(2)
	cF2_DOC     := space(9)
	
	
	_lProcessa := .t.
	
	if _lProcessa
		
		cA1_FILIAL  := QRYTMP->A1_FILIAL
		cA1_COD     := QRYTMP->A1_COD
		cA1_LOJA    := QRYTMP->A1_Loja
		cA1_NOME    := QRYTMP->A1_NOME
		cA3_Filial  := QRYTMP->A3_FILIAL
		cA3_COD     := QRYTMP->A3_COD
		cA3_EST     := QRYTMP->A3_EST
		cA3_NOME    := QRYTMP->A3_NOME
		cA3_TIPO    := QRYTMP->A3_TIPO
		cB1_Filial  := QRYTMP->B1_FILIAL
		cB1_Cod     := QRYTMP->B1_Cod
		nB1_CONV    := QRYTMP->B1_CONV
		cB1_DESC    := QRYTMP->B1_DESC
		nB1_PESO    := QRYTMP->B1_PESO
		cC5_FILIAL  := QRYTMP->C5_FILIAL
		cC5_CLIENTE := QRYTMP->C5_CLIENTE
		cC5_LOJACLI := QRYTMP->C5_LOJACLI
		cC5_VEND1   := QRYTMP->C5_VEND1
		cC5_NOTA    := QRYTMP->C5_NOTA
		dC5_SAIDA   := QRYTMP->C5_SAIDA
		cD2_CF      := QRYTMP->D2_CF
		cD2_FILIAL  := QRYTMP->D2_FILIAL
		cD2_DOC     := QRYTMP->D2_DOC
		cD2_COD     := QRYTMP->D2_COD
		nD2_ICMSRET := QRYTMP->D2_ICMSRET
		nD2_QTDEDEV := QRYTMP->D2_QTDEDEV
		nD2_QUANT   := QRYTMP->D2_QUANT
		nD2_TOTAL   := QRYTMP->D2_TOTAL
		cD2_TP      := QRYTMP->D2_TP
		nD2_VALIPI  := QRYTMP->D2_VALIPI
		cF2_FILIAL  := QRYTMP->F2_FILIAL
		cF2_CLIENTE := QRYTMP->F2_CLIENTE
		cF2_LOJA    := QRYTMP->F2_LOJA
		cF2_DOC     := QRYTMP->F2_DOC
		
		_cGrupo01 := " "
		_cGrupo02 := " "
		_cGrupo03 := " "
		
		_cChave := _cGrupo01+_cGrupo02+_cGrupo03
		
		/*////////////////////////////////////////////////*/
		/*//////////// Gravar/Atualizar Dados ////////////*/
		/*////////////////////////////////////////////////*/
		
		DbSelectArea("REPORT")
		dbSetOrder(1)
		dbgotop()
		
		_lInclui := .t.
		
		if dbseek(_cChave,.f.)
			//_lInclui := .f.
		Endif
		
		If reclock("REPORT",_lInclui)
			
			if _lInclui
				
				REPORT->_FILIAL   := _cFilial
				
				REPORT->_USUARIO  := _cUsuario
				
				REPORT->_PAR01    := _cPar01
				REPORT->_PAR02    := _cPar02
				REPORT->_PAR03    := _cPar03
				REPORT->_PAR04    := _cPar04
				
				REPORT->_TITULO1  := _cTitulo1
				REPORT->_TITULO2  := _cTitulo2
				REPORT->_TITULO3  := _cTitulo3
				
				REPORT->_GRUPO01  := _cGrupo01
				REPORT->_GRUPO02  := _cGrupo02
				REPORT->_GRUPO03  := _cGrupo03
				
				REPORT->A1_FILIAL  := cA1_FILIAL
				REPORT->A1_COD     := cA1_COD
				REPORT->A1_LOJA    := cA1_Loja
				REPORT->A1_NOME    := cA1_NOME
				REPORT->A3_Filial  := cA3_FILIAL
				REPORT->A3_COD     := cA3_COD
				REPORT->A3_EST     := cA3_EST
				REPORT->A3_NOME    := cA3_NOME
				REPORT->A3_TIPO    := cA3_TIPO
				REPORT->B1_Filial  := cB1_FILIAL
				REPORT->B1_Cod     := cB1_Cod
				REPORT->B1_CONV    := nB1_CONV
				REPORT->B1_DESC    := cB1_DESC
				REPORT->B1_PESO    := nB1_PESO
				REPORT->C5_FILIAL  := cC5_FILIAL
				REPORT->C5_CLIENTE := cC5_CLIENTE
				REPORT->C5_LOJACLI := cC5_LOJACLI
				REPORT->C5_VEND1   := cC5_VEND1
				REPORT->C5_NOTA    := cC5_NOTA
				REPORT->C5_SAIDA   := dC5_SAIDA
				REPORT->D2_CF      := cD2_CF
				REPORT->D2_FILIAL  := cD2_FILIAL
				REPORT->D2_DOC     := cD2_DOC
				REPORT->D2_COD     := cD2_COD
				REPORT->D2_ICMSRET := nD2_ICMSRET
				REPORT->D2_QTDEDEV := nD2_QTDEDEV
				REPORT->D2_QUANT   := nD2_QUANT
				REPORT->D2_TOTAL   := nD2_TOTAL
				REPORT->D2_TP      := cD2_TP
				REPORT->D2_VALIPI  := nD2_VALIPI
				REPORT->F2_FILIAL  := cF2_FILIAL
				REPORT->F2_CLIENTE := cF2_CLIENTE
				REPORT->F2_LOJA    := cF2_LOJA
				REPORT->F2_DOC     := cF2_DOC
				
			endif
			
			msunlock()
			
		Endif
		
	Endif
	
	dbselectarea("QRYTMP")
	dbskip()
	
Enddo


dbselectarea("QRYTMP")
dbclosearea()

dbselectarea("SM0")
dbclosearea()
OpenSm0()
dbgoto(_nRecSM0)

dbselectarea("REPORT")

return nil

////////////////////////////////
////////////////////////////////
Static Function CriaPerg(cPerg)
////////////////////////////////
////////////////////////////////
Local j := 0
Local i := 0  
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
aRegs :={}

cPerg := padr(alltrim(cPerg),len(sx1->x1_grupo))

//                                                                                                   1                                                                                                         2                                                                                                     3                                                                                             4
//          1      2      3                                 4       5       6         7     8    9   0         1     2      3           4                  5        6        7      8       9                  0        1        2      3      4                  5        6        7       8     9                  0        1        2      3      4                   5       6        7      8           9     0        1     2        3
//          GRUPO  ORDEM  PERGUNT                           PERSPA  PERENG  VARIAVL   TIPO  TAM  DEC PRESEL    GSC   VALID  VAR01       DEF01              DEFSPA1  DEFENG1  CNT01  VAR02   DEF02              DEFSPA2  DEFENG2  CNT02  VAR03  DEF03              DEFSPA3  DEFENG3  CNT03  VAR04  DEF04              DEFSPA4  DEFENG4  CNT04  VAR05  DEF05              DEFSPA5  DEFENG5  CNT05  F3          PYME  GRPSXG   HELP  PICTURE  IDFIL
AADD(aRegs,{cPerg, "01" , "Data Inicial:                  ", "."   , "."   , "mv_ch1", "D" , 03 , 0  ,0     , "G", " "  , "mv_par01", "               ", " "    , " "    , " "  , "  " , "               ", " "    , " "    , " "  , "  " , "               ", " "    , " "    , " "  , "  " , "               ", " "    , " "    , " "  , "  " , "               ", " "    , " "    , " "  , "      ", " " , " "   , " " , "@!"   , " "   })
AADD(aRegs,{cPerg, "02" , "Data Final:                    ", "."   , "."   , "mv_ch2", "D" , 15 , 0  ,0     , "G", " "  , "mv_par02", "               ", " "    , " "    , " "  , "  " , "               ", " "    , " "    , " "  , "  " , "               ", " "    , " "    , " "  , "  " , "               ", " "    , " "    , " "  , "  " , "               ", " "    , " "    , " "  , "      ", " " , " "   , " " , "@!"   , " "   })
AADD(aRegs,{cPerg, "03" , "Equipe:                        ", "."   , "."   , "mv_ch3", "N" , 01 , 0  ,0     , "C", " "  , "mv_par03", "Vendedores     ", " "    , " "    , " "  , "  " , "Representantes ", " "    , " "    , " "  , "  " , "Todos          ", " "    , " "    , " "  , "  " , "               ", " "    , " "    , " "  , "  " , "               ", " "    , " "    , " "  , "      ", " " , " "   , " " , "@!"   , " "   })
AADD(aRegs,{cPerg, "04" , "Grupo de Produtos:             ", "."   , "."   , "mv_ch4", "C" , 04 , 0  ,0     , "G", " "  , "mv_par04", "               ", " "    , " "    , " "  , "  " , "               ", " "    , " "    , " "  , "  " , "               ", " "    , " "    , " "  , "  " , "               ", " "    , " "    , " "  , "  " , "               ", " "    , " "    , " "  , "SBM   ", " " , " "   , " " , "@!"   , " "   })

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return nil
