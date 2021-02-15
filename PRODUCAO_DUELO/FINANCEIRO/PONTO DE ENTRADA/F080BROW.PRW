#INCLUDE "PROTHEUS.CH"
//#INCLUDE "rwmake.ch"

//
// Ponto de entrada utilizado na inicializacao do contas a pagar
// 18/10/2011
//
/////////////////////////////////
user function F080BROW()
/////////////////////////////////
public _cFiltro   := " "
public _cFilse1   := " "
public _cFilse2   := " "
public _nradio    := 5
public _aCli      := {}
public _aFor      := {}

public _filpar01
public _filpar02
public _filpar03
public _filpar04
public _filpar05
public _filpar06
public _filpar07
public _filpar08
public _filpar09
public _filpar10
public _filpar11
public _filpar12
public _filpar13
public _filpar14
public _filpar15
public _filpar16
public _filpar17
public _filpar18
public _filpar19
public _filpar20
public _filpar21
public _filpar22
public _filpar23

if valtype(_filpar01) == "U"
	public _filpar01  := space(TamSx3("E2_NUM")[1])
Endif

if valtype(_filpar02) == "U"
	public _filpar02  := ctod("")
Endif

if valtype(_filpar03) == "U"
	public _filpar03  := space(50)
Endif

if valtype(_filpar04) == "U"
	public _filpar04  := ctod("")
Endif

if valtype(_filpar05) == "U"
	public _filpar05  := ctod("")
Endif

if valtype(_filpar06) == "U"
	public _filpar06  := ctod("")
Endif

if valtype(_filpar07) == "U"
	public _filpar07  := ctod("")
Endif

if valtype(_filpar08) == "U"
	public _filpar08  := ctod("")
Endif

if valtype(_filpar09) == "U"
	public _filpar09  := ctod("")
Endif

if valtype(_filpar10) == "U"
	public _filpar10  := space(50)
Endif

if valtype(_filpar11) == "U"
	public _filpar11  := 0
Endif

if valtype(_filpar12) == "U"
	public _filpar12  := 0
Endif

if valtype(_filpar13) == "U"
	public _filpar13  := 'T'
Endif

if valtype(_filpar14) == "U"
	public _filpar14  := space(50)
Endif

if valtype(_filpar15) == "U"
	public _filpar15  := space(50)
Endif

if valtype(_filpar16) == "U"
	public _filpar16  := space(50)
Endif
if valtype(_filpar17) == "U"
	public _filpar17  := space(50)
Endif

if valtype(_filpar18) == "U"
	public _filpar18  := space(50)
Endif

if valtype(_filpar19) == "U"
	public _filpar19  := 0
Endif

if valtype(_filpar20) == "U"
	public _filpar20  := 0
Endif

if valtype(_filpar21) == "U"
	public _filpar21  := space(50)
Endif

if valtype(_filpar22) == "U"
	public _filpar22  := space(50)
Endif

if valtype(_filpar23) == "U"
	public _filpar23  := 'T'
Endif

setkey( VK_F10 ,  { || _lKeypesq := .t. , U_FILFIN(1) } )

dbselectarea("SE2")
SET FILTER TO
dbgotop()

Return NIL


