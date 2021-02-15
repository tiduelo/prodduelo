#include "rwmake.ch"
#include "colors.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO3     º Autor ³ AP6 IDE            º Data ³  14/02/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function GDP006()


//if ! U_LOG("26")
//	Return nil
//Endif



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SA1")
dbSetOrder(2)


aRotina := { { "Pesquisar"      ,'AXPESQUI'       , 0, 1 } ,;
{ "Visualiza"    ,'AXVISUAL' , 0, 2 },;
{ "Manutencao"    ,'Processa( {|| U_GDP006a() } )' , 0, 4 }}

cCadastro := "Manutencao de Clientes"

_aCpo := {}
aadd(_aCpo,{"Codigo","A1_COD"})
aadd(_aCpo,{"Loja"  ,"A1_LOJA"})
aadd(_aCpo,{"Nome"  ,"A1_NOME"})
aadd(_aCpo,{"Limite de Cred.","A1_LC"})
aadd(_aCpo,{"Cod.Munic.","A1_COD_MUN"})
aadd(_aCpo,{"Municipio","A1_MUN"})

mBrowse(01, 01, 30, 70, "SA1",_aCpo)

Return NIL

/*++++++++++++++++++++++*/
User Function GDP006a(_nPar)
/*++++++++++++++++++++++*/
Local xzy := 0
Local i := 0
dbSelectArea("SA1")
_nSA1Ord := indexord()
_nSA1Reg := recno()


nOpcx  :=3
nUsado :=0
aHeader:={}

_aCampos := {}
aadd(_aCampos,{"Bloqueado"   ,"A1_MSBLQL" ,"" ,0,0,""                    ,"","","","",""})//01
aadd(_aCampos,{"Regiao    "  ,"A1_REGIAO" ,"" ,0,0,""                    ,"","","","",""})//02
aadd(_aCampos,{"Vendedor    ","A1_VEND  " ,"" ,0,0,""                    ,"","","","",""})//03
aadd(_aCampos,{"Lim. Credito","A1_LC   "  ,"" ,0,0,""                    ,"","","","",""})//04
aadd(_aCampos,{""            ,"A1_MUN"    ,"" ,0,0,""                    ,"","","","",""})//05
aadd(_aCampos,{""            ,"A1_NOME"   ,"" ,0,0,""                    ,"","","","",""})//06
aadd(_aCampos,{""            ,"A1_COD"   ,"" ,0,0,""                    ,"","","","",""}) //07
aadd(_aCampos,{""            ,"A1_LOJA"  ,"" ,0,0,""                    ,"","","","",""}) //08
aadd(_aCampos,{"Ok"          ,"A1_ESTC"   ,"" ,1,0,""                    ,"","","","",""})//09
aadd(_aCampos,{"Filial"      ,"A1_FILIAL" ,"" ,0,0,""                    ,"","","","",""})//10

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SA1")

_cusado := ""

While !Eof() .And. (x3_arquivo == "SA1")
	
	for xzy := 1 to len(_aCampos)
		
		If upper(Rtrim(x3_campo)) == upper(Rtrim(_aCampos[xzy][2]))
			
			IF xzy < 4
				_CVAL := "U_VALTCRE()"
			Else
				_CVAL := ""
			Endif
			
			_aCampos[xzy][01]  := iif(empty(_aCampos[xzy][01]),TRIM(x3_titulo),_aCampos[xzy][01])
			_aCampos[xzy][03]  := iif(empty(_aCampos[xzy][03]),x3_picture     ,_aCampos[xzy][03])
			_aCampos[xzy][04]  := iif(empty(_aCampos[xzy][04]),x3_tamanho     ,_aCampos[xzy][04])
			_aCampos[xzy][05]  := iif(empty(_aCampos[xzy][05]),x3_decimal     ,_aCampos[xzy][05])
			_aCampos[xzy][06]  := _CVAL
			_aCampos[xzy][07]  := iif(empty(_aCampos[xzy][07]),x3_usado       ,_aCampos[xzy][07])
			_aCampos[xzy][08]  := iif(empty(_aCampos[xzy][08]),x3_tipo        ,_aCampos[xzy][08])
			_aCampos[xzy][09]  := iif(empty(_aCampos[xzy][09]),x3_arquivo     ,_aCampos[xzy][09])
			_aCampos[xzy][10]  := iif(empty(_aCampos[xzy][10]),x3_context     ,_aCampos[xzy][10])
			
			_cusado := x3_usado
			
			If nOpcx == 3
				If x3_tipo == "C"
					_aCampos[xzy][11] := SPACE(X3_TAMANHO)
				Elseif x3_tipo == "N"
					_aCampos[xzy][11] := 0
				Elseif x3_tipo == "D"
					_aCampos[xzy][11] := cTod("")
				Elseif x3_tipo == "M"
					_aCampos[xzy][11] := ""
				Else
					_aCampos[xzy][11] := .f.
				Endif
			Endif
			
		Endif
		
	Next
	
	dbSkip()
	
Enddo


for xzy := 1 to len(_aCampos)
	nUsado := nUsado+1
	AADD(aHeader,{_aCampos[xzy][1],_aCampos[xzy][2],_aCampos[xzy][3],_aCampos[xzy][4],_aCampos[xzy][5],;
	_aCampos[xzy][6],_cusado,_aCampos[xzy][8],_aCampos[xzy][9],_aCampos[xzy][10]})
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montando aCols                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aCols := Array(1,nUsado+1)
nUsado:=0

for xzy := 1 to len(_aCampos)
	nUsado:=nUsado+1
	acols[1][xzy] := _aCampos[xzy][11]
Next

aCols[1][nUsado+1] := .F.

cTitulo :="Manutencao CLiente"

aTela   :={000,000,400,630}

aGetEdt   :={"A1_MSBLQL","A1_REGIAO","A1_VEND","A1_LC"}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array com descricao dos campos do cabecalho                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
ofont1 := TFont():New("TIMES NEW ROMAN" , 15, 50,,.T.)
ofont2 := TFont():New("TIMES NEW ROMAN" , 08, 30,,.F.)
ofont3 := TFont():New("ARIAL"           , 06, 15,,.F.)
//ofont4 := TFont():New("LCDD"            , 15, 50,,.T.)
_cCliCod := space(6)
_cCliNom := space(30)
aC:={}


//           1              2          3  4          5                       6                   7      8     9      10         11             12        13          14         15      16    17      18    19
//                                                                                                                 fonte   ,  fonte    , cor texto , cor fundo, cor texto , cor fundo, larg , alt  , larg , alt
//        Descricao    , variavel   ,Lin,Col ,  picture       ,  Valid                        , F3   ,when ,tipo ,  Say    ,   Get     ,    Say    ,    Say   ,    Get    ,    Get   , Say  , say  ,  get , Get
//AADD(aC,{"Codigo  "    ,"_cCliCod"  ,015,005 , "999999"       ,'u_valcodCli(_cCliCod,1)'      ,      ,.T.  , 1   , ""      , "ofont3"  , ""        , ""       , CLR_HBLUE , CLR_WHITE, 30   , 10   ,  40  , 10  , 1.8 , .f. })
//AADD(aC,{"Nome   "     ,"_cCliNom"  ,015,110 , "@!"           ,'u_valcodCli(_cCliNom,2)'      ,      ,.T.  , 1   , ""      , "ofont3"  , ""        , ""       , CLR_HBLUE , CLR_WHITE, 30   , 10   ,  100 , 10  , 1.8 , .f. })



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array com descricao dos campos do Rodape                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aR :={}

aCGD:={15,03,195,313}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Validacoes na GetDados                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cLinhaOk :=  ".t."
cTudoOk  :=  ".t."

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chamada da Funcao de Browse para edicao                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// 000,000 To 400,630 Dialog oTELA

dbselectarea("SA1")

//if _nPar == 2
dbsetorder(2)
dbgotop()
ProcRegua(RECCOUNT())
_cWhile := " !eof() "
//Else
//	_cCodCli := a1_cod
//	dbsetorder(1)
//	dbgotop()
//	ProcRegua(5)
//	dbseek(xfilial("SA1")+_cCodCli,.f.)
//	_cWhile := " !eof() .and. a1_cod  == _cCodCli "
//Endif

if ! eof()

	aCols := {}
	n := 0
	
	Do While &_cWhile
		incproc(a1_cod+'-'+substr(A1_NOME,1,20))
		aadd(acols,{A1_MSBLQL,A1_REGIAO,A1_VEND,A1_LC,A1_MUN,A1_NOME,A1_COD,A1_LOJA,space(1),A1_FILIAL,.F.})
		dbskip()
	Enddo
	
	if len(acols) > 0
	
		n:= 1
		
		lRetMod2 := u_modelonew(cTitulo,aC,aR,aCGD,3,cLinhaOk,cTudoOk,aGetEdt,,,len(acols),aTela,.f.)
		
		If lRetMod2
			
			ProcRegua(LEN(aCols))
			
			For i := 1 to LEN(aCols)
				
				incproc("Atualizando... "+aCols[i][6])
				
				IF !aCols[i][nUsado + 1] .and. upper(alltrim(aCols[i][9])) == "*"
					
					dbSelectArea("SA1")
					dbsetorder(1)
					dbgotop()
					
					dbSeek(xFilial("SA1")+aCols[i][7]+aCols[i][8],.F.)
					
					IF ! EOF()
						IF reclock('SA1',.F.)
							SA1->A1_MSBLQL :=  aCols[i][1]
							SA1->A1_REGIAO :=  aCols[i][2]
							SA1->A1_VEND   :=  aCols[i][3]
							SA1->A1_LC     :=  aCols[i][4]
							msunlock()
						Endif
					Else
						alert("Problemas na Atualizacao do cliente "+aCols[i][7]+"-"+aCols[i][8]+" "+aCols[i][6])
					Endif
				Endif
				
			Next
			
		EndIf
	Endif
Endif

dbselectarea("SA1")
dbsetorder(_nSA1Ord)
dbgoto(_nSA1Reg)

Return nil

/*********************************/
user function VALTCRE()
/*********************************/
_lret := .t.

acols[n][9] := '*'

oGetDados2:refresh()

return _lret

/*********************************/
user function valcodcli(_cValCli,_nPar)
/*********************************/

if ! empty(_cValCli)
	if _nPar == 1
		n := aScan(aCols,{ |X| X[4] == _nPar })
	Else
		_nLenCli := len(alltrim(_cValCli))
		n := aScan( aCols , { |X| upper(substr(X[6],1,_nLenCli)) == upper(alltrim(_cValCli)) })
	Endif
	
Endif

alert(str(n))

oGetDados2:goto(n)
eval(oGetDados2:obrowse:bDrawselect)

//For nLoop := 1 To Len(oGetDados2)
oGetDados2:oBrowse:lDisablePaint := .F.
oGetDados2:oBrowse:Refresh(.T.)
//Next nLoop


Dlgrefresh(oDlg2)
oGetDados2:refresh()

//Dlgrefresh(oBrw)
//oBrw:oBrowse:refresh()


return(.t.)


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
±±³			  ³ nOpcx=Modo de operacao 									  ³±±
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
user FUNCTION Modelonew(cTitulo,aC,aR,aCGD,nOpcx,cLineOk,cAllOk,aGetsGD,bF4,cIniCpos,nMax,aCordW,lDelGetD,oDlgMain)
Local _xy := 0
local   nOpca:=0, i,lAllOk, cCampo, nX, nY, cCaption, cPict, cValid, cF3, cWhen, nLargSay, nLargGet, uConteudo
Local   cBlkGet,cBlkWhen,cBlkVld, oSaveGetdad := Nil, aSvRot := Nil
Local _nctd := 0
private oSay2, oGet2,oGets2 := {},oSays2 := {}
private oDlg2
private oGetDados2
private cLineOk2 := cLineOk
private cAllOk2  := cAllOk
private lFirst   := .t.
nCount  := 0
//nOpcx	    := 3
//aCGD	    := {}
lDelGetD  := Iif(lDelGetD==Nil,.t.,lDelGetD)
oDlgMain  := Iif(oDlgMain==Nil,oMainWnd,oDlgMain)
VK_F4     := 115
nOpcX     := Iif(nOpcX<1,3,nOpcX)
cIniCpos  := Iif(cIniCpos==Nil,"",cIniCpos)
nCount++

//__cLineOk := cLineOK
//__nOpcx	 := nOpcx

If nCount > 1
	oSaveGetdad := oGetDados2
	oSaveGetdad:lDisablePaint := .t.
EndIf


If Type("aRotina") == "A"
	aSvRot := aClone(aRotina)
EndIf

aRotina := {}

For nX := 1 to nOpcX
	AADD(aRotina,{"","",0,nOpcx})
Next

aCGD:=Iif(Len(aCGD)==0,{34,5,128,315},aCGD)

If !Empty(bF4)
	SetKey(VK_F4,bF4)
EndIf

aCordW :=Iif(aCordW==Nil,{125,0,400,635},aCordW)

DEFINE MSDIALOG oDlg2 TITLE OemToAnsi(cTitulo) FROM aCordW[1],aCordW[2] TO aCordW[3],aCordW[4] PIXEL OF oDlgMain

For _nctd := 1 to Len(aC)
	
	If Len(Ac[_nctd]) == 21
		
		_cCaption   := Iif(Empty(Ac[_nctd,01]), " "  , Ac[_nctd,01])
		_cBlKSay   := "{|| OemToAnsi('"+_cCaption+"')}"
		_cCampo     := Ac[_nctd,02]
		_nX         := Ac[_nctd,03]
		_nY         := Ac[_nctd,04]
		_cPict      := Iif(Empty(Ac[_nctd,05]) , NIL     , Ac[_nctd,05])
		_cValid     := Iif(Empty(Ac[_nctd,06]) , ".T."   , Ac[_nctd,06])
		_cF3        := Iif(Empty(Ac[_nctd,07]) , NIL     , Ac[_nctd,07])
		_cWhen      := Iif(Ac[_nctd,08] == NIL , ".t." , Iif(Ac[_nctd,08] , ".t." ,".f."))
		_nTipo      := Ac[_nctd,09]
		_cFonsay    := Iif(Empty(Ac[_nctd,10]), "NIL"  , Ac[_nctd,10])
		_cFonGet    := Iif(Empty(Ac[_nctd,11]), "NIL"  , Ac[_nctd,11])
		_cCorlsay   := Iif(Empty(Ac[_nctd,12]), NIL  , Ac[_nctd,12])
		_cCorfsay   := Iif(Empty(Ac[_nctd,13]), NIL  , Ac[_nctd,13])
		_cCorlget   := Iif(Empty(Ac[_nctd,14]), NIL  , Ac[_nctd,14])
		_cCorfget   := Iif(Empty(Ac[_nctd,15]), NIL  , Ac[_nctd,15])
		_nLarsay    := Iif(Ac[_nctd,16] == 0  , len(_cCaption), Ac[_nctd,16])
		_nAltsay    := Iif(Ac[_nctd,17] == 0  , NIL  , Ac[_nctd,17])
		_nLarget    := Iif(Ac[_nctd,18] == 0  , NIL  , Ac[_nctd,18])
		_nAltget    := Iif(Ac[_nctd,19] == 0  , NIL  , Ac[_nctd,19])
		_nFator     := Ac[_nctd,20]
		_lAlidir	:= Iif(Empty(Ac[_nctd,21]), .f.  , Ac[_nctd,21])
		
		
		
		_oSay2 := TSay():New( _nX-1  , _nY    , &_cBlKsay   ,oDlg2  ,         , &_cFonsay, .F.          , .F.         , .F.        , .T.       , _cCorlsay   , _cCorfsay   , _nLarsay  , _nAltsay  , .F.       , .F.       , .F.         , .F.       , .F.         )
		//        TSay():New( <nRow> , <nCol> , <{cText}>   , <oWnd>, <cPict> , <oFont>  , <.lCenter.>  , <.lRight.>  ,<.lBorder.> , <.lPixel.>, <nClrText>  , <nClrBack>  , <nWidth>  , <nHeight> , <.design.>, <.update.>, <.lShaded.> , <.lBox.>  , <.lRaised.> )
		AADD(oSays2,_oSay2)
		
		_cCaption := _oSay2:cCaption
		
		_nLargSay := GetTextWidth(0,_cCaption) / _nFator
		
		_cBlkGet := "{ | u | If( PCount() == 0, "+_cCampo+","+_cCampo+":= u ) }"
		_cBlKVld := "{|| "+_cValid+"}"
		_cBlKWhen := "{|| "+_cWhen+"}"
		
		if _nTipo == 1
			_oGet2  := TGet():New( _nX    , _nY + _nLarsay  , &_cBlKGet       ,oDlg2  , _nLarget   ,_nAltget    ,_cPict   , &(_cBlkVld)   , _cCorlget   , _cCorfget  , &_cFonGet , .F.       ,          , .T.      ,           , .F.       ,  &(_cBlkWhen) , .F.        , _lAlidir  ,                                     ,   .F.       , .F.    ,_cF3             , (_cCampo)  )
			//_oGet := TGet():New( _nX    , _nY + _nLargSay , &_cBlKGet       ,&_OBJ  , _nLarget   ,_nAltget    ,_cPict   , &(_cBlkVld)   , _cCorlget   , _cCorfget  , &_cFonGet , .F.       ,          , .T.      ,           , .F.       ,  &(_cBlkWhen) , .F.        , .F.       ,                                     ,   .F.       , .F.    ,_cF3             , (_cCampo)  )
			//         TGet():New( <nRow> , <nCol>          , bSETGET(<uVar>) , <oWnd>, <nWidth>   , <nHeight>  , <cPict> , <{ValidFunc}> , <nClrFore>  , <nClrBack> , <oFont>   , <.design.>, <oCursor>, <.pixel.>, <cMsg>    , <.update.>,  <{uWhen}>    , <.lCenter.>, <.lRight.>, [\{|nKey, nFlags, Self| <uChange>\}], <.readonly.>,<.pass.>,  [<.lNoBorder.>], <nHelpId>  )
			//         TGet():New( nX     , nY+nLargSay     ,&cBlKGet         ,oDlg   ,            ,            , cPict   , &(cBlkVld)    ,             ,            ,           , .F.       ,          , .T.      ,           , .F.       ,  &(cBlkWhen)  , .F.        , .F.       ,                                     , .F.         , .F.    ,cF3              , (cCampo)   )
			
			AADD(oGets2,_oGet2)
		Else
			_oSay2  := TSay():New( _nX-1  ,  _nY + _nLarsay , &_cBlKGet   , oDlg2 , _cPict  , &_cFonget, .F.          , _lAlidir    , .F.        , .T.       , _cCorlget   , _cCorfget  , _nLarget  , _nAltget  , .F.       , .F.       , .F.         , .T.       , .F.         )
			//_oSay := TSay():New( _nX-1  ,  _nY + _nLargSay, &_cBlKGet   ,&_OBJ  , _cPict  , &_cFonget, .F.          , .F.         , .F.        , .T.       , _cCorlget   , _cCorfget  , _nLarget  , _nAltget  , .F.       , .F.       , .F.         , .T.       , .F.         )
			//         TSay():New( <nRow> , <nCol>          , <{cText}>   , <oWnd>, <cPict> , <oFont>  , <.lCenter.> , <.lRight.>  ,<.lBorder.> , <.lPixel.>, <nClrText>  , <nClrBack>  , <nWidth>  , <nHeight> , <.design.>, <.update.>, <.lShaded.> , <.lBox.>  , <.lRaised.> )
			AADD(oSays2,_oSay2)
		Endif
		
		
	EndIf
	
Next

For _xy:= 1 to Len(oGets2)
	oGets2[_xy]:Refresh()
Next

For _xy:= 1 to Len(oSays2)
	oSays2[_xy]:Refresh()
Next

oGetDados2:=MSGetDados():New(aCGD[1],aCGD[2],aCGD[3],aCGD[4],nOpcX,"u_LinhaOK()","u_Tudook()",cIniCpos,lDelGetD,aGetsGD, , ,nMax ,"u_CampoOk()")

For _nctd := 1 to Len(Ar)
	
	If Len(Ar[_nctd]) == 21
		
		_cCaption   := Iif(Empty(Ar[_nctd,01]), " "  , Ar[_nctd,01])
		_cBlKSay   := "{|| OemToAnsi('"+_cCaption+"')}"
		_cCampo     := Ar[_nctd,02]
		_nX         := Ar[_nctd,03]
		_nY         := Ar[_nctd,04]
		_cPict      := Iif(Empty(Ar[_nctd,05]) , NIL     , Ar[_nctd,05])
		_cValid     := Iif(Empty(Ar[_nctd,06]) , ".T."   , Ar[_nctd,06])
		_cF3        := Iif(Empty(Ar[_nctd,07]) , NIL     , Ar[_nctd,07])
		_cWhen      := Iif(Ar[_nctd,08] == NIL , ".t." , Iif(Ar[_nctd,08] , ".t." ,".f."))
		_nTipo      := Ar[_nctd,09]
		_cFonsay    := Iif(Empty(Ar[_nctd,10]), "NIL"  , Ar[_nctd,10])
		_cFonGet    := Iif(Empty(Ar[_nctd,11]), "NIL"  , Ar[_nctd,11])
		_cCorlsay   := Iif(Empty(Ar[_nctd,12]), NIL  , Ar[_nctd,12])
		_cCorfsay   := Iif(Empty(Ar[_nctd,13]), NIL  , Ar[_nctd,13])
		_cCorlget   := Iif(Empty(Ar[_nctd,14]), NIL  , Ar[_nctd,14])
		_cCorfget   := Iif(Empty(Ar[_nctd,15]), NIL  , Ar[_nctd,15])
		_nLarsay    := Iif(Ar[_nctd,16] == 0  , len(_cCaption), Ar[_nctd,16])
		_nAltsay    := Iif(Ar[_nctd,17] == 0  , NIL  , Ar[_nctd,17])
		_nLarget    := Iif(Ar[_nctd,18] == 0  , NIL  , Ar[_nctd,18])
		_nAltget    := Iif(Ar[_nctd,19] == 0  , NIL  , Ar[_nctd,19])
		_nFator     := Ar[_nctd,20]
		_lAlidir	:= Iif(Empty(Ar[_nctd,21]) , .f.  , Ar[_nctd,21])
		
		_oSay2 := TSay():New( _nX-1  , _nY    , &_cBlKsay   ,oDlg2,         , &_cFonsay, .F.          , .F.         , .F.        , .T.       , _cCorlsay   , _cCorfsay   , _nLarsay  , _nAltsay  , .F.       , .F.       , .F.         , .F.       , .F.         )
		//      TSay():New( <nRow> , <nCol> , <{cText}>   , <oWnd>, <cPict> , <oFont>  , <.lCenter.>  , <.lRight.>  ,<.lBorder.> , <.lPixel.>, <nClrText>  , <nClrBack>  , <nWidth>  , <nHeight> , <.design.>, <.update.>, <.lShaded.> , <.lBox.>  , <.lRaised.> )
		AADD(oSays2,_oSay2)
		
		_cCaption := _oSay2:cCaption
		
		_nLargSay := GetTextWidth(0,_cCaption) / _nFator
		
		_cBlkGet := "{ | u | If( PCount() == 0, "+_cCampo+","+_cCampo+":= u ) }"
		_cBlKVld := "{|| "+_cValid+"}"
		_cBlKWhen := "{|| "+_cWhen+"}"
		
		if _nTipo == 1
			_oGet2  := TGet():New( _nX    , _nY + _nLarsay  , &_cBlKGet       ,oDlg2  , _nLarget   ,_nAltget    ,_cPict   , &(_cBlkVld)   , _cCorlget   , _cCorfget  , &_cFonGet , .F.       ,          , .T.      ,           , .F.       ,  &(_cBlkWhen) , .F.        , _lAlidir  ,                                     ,   .F.       , .F.    ,_cF3             , (_cCampo)  )
			//_oGet := TGet():New( _nX    , _nY + _nLargSay , &_cBlKGet       ,&_OBJ  , _nLarget   ,_nAltget    ,_cPict   , &(_cBlkVld)   , _cCorlget   , _cCorfget  , &_cFonGet , .F.       ,          , .T.      ,           , .F.       ,  &(_cBlkWhen) , .F.        , .F.       ,                                     ,   .F.       , .F.    ,_cF3             , (_cCampo)  )
			//         TGet():New( <nRow> , <nCol>          , bSETGET(<uVar>) , <oWnd>, <nWidth>   , <nHeight>  , <cPict> , <{ValidFunc}> , <nClrFore>  , <nClrBack> , <oFont>   , <.design.>, <oCursor>, <.pixel.>, <cMsg>    , <.update.>,  <{uWhen}>    , <.lCenter.>, <.lRight.>, [\{|nKey, nFlags, Self| <uChange>\}], <.readonly.>,<.pass.>,  [<.lNoBorder.>], <nHelpId>  )
			//         TGet():New( nX     , nY+nLargSay     ,&cBlKGet         ,oDlg   ,            ,            , cPict   , &(cBlkVld)    ,             ,            ,           , .F.       ,          , .T.      ,           , .F.       ,  &(cBlkWhen)  , .F.        , .F.       ,                                     , .F.         , .F.    ,cF3              , (cCampo)   )
			
			AADD(oGets2,_oGet2)
		Else
			_oSay2  := TSay():New( _nX-1  ,  _nY + _nLarsay , &_cBlKGet   , oDlg2 , _cPict  , &_cFonget, .F.          , _lAlidir    , .F.        , .T.       , _cCorlget   , _cCorfget  , _nLarget  , _nAltget  , .F.       , .F.       , .F.         , .T.       , .F.         )
			//_oSay := TSay():New( _nX-1  ,  _nY + _nLargSay, &_cBlKGet   ,&_OBJ  , _cPict  , &_cFonget, .F.          , .F.         , .F.        , .T.       , _cCorlget   , _cCorfget  , _nLarget  , _nAltget  , .F.       , .F.       , .F.         , .T.       , .F.         )
			//         TSay():New( <nRow> , <nCol>          , <{cText}>   , <oWnd>, <cPict> , <oFont>  , <.lCenter.> , <.lRight.>  ,<.lBorder.> , <.lPixel.>, <nClrText>  , <nClrBack>  , <nWidth>  , <nHeight> , <.design.>, <.update.>, <.lShaded.> , <.lBox.>  , <.lRaised.> )
			AADD(oSays2,_oSay2)
		Endif
		
	EndIf
	
Next

For _xy:= 1 to Len(oGets2)
	oGets2[_xy]:Refresh()
Next

For _xy:= 1 to Len(oSays2)
	oSays2[_xy]:Refresh()
Next


ACTIVATE MSDIALOG oDlg2 ON INIT EnchoiceBar(oDlg2,{||nOpca:=1,lAllOk := u_TudoOK(),Iif(lAllOk,oDlg2:End(),nOpca:=0)},{||oDlg2:End()})

nCount--

If nCount > 0
	oGetDados2 := oSaveGetDad
	oGetDados2:lDisablePaint := .f.
EndIf

If ValType(aSvRot) == "A"
	aRotina := aClone(aSvRot)
EndIf

SetKey(VK_F4,{||Nil})

Return (nOpca==1)

//********************************************
user Function 2LinhaOk()
//********************************************
Local lRet := .t.
Local _xy := 0 

If Str(nOpcx,1,0) $ "346"
	lRet := &cLineOK2
Endif

For _xy:= 1 to Len(oGets2)
	oGets2[_xy]:Refresh()
Next

For _xy:= 1 to Len(oSays2)
	oSays2[_xy]:Refresh()
Next

Dlgrefresh(oDlg2)
oGetDados2:refresh()

Return lRet

//********************************************
user Function 2Tudook()
//********************************************

lRet := u_LinhaOk()

If lRet
	lRet := &cAllOk2
EndIf

Return lRet

//********************************

static Function CallMod2Obj()
Return oGetDados2

//********************************

user Function 2campoOk()
Local _xy

For _xy:= 1 to Len(oGets2)
	oGets2[_xy]:Refresh()
Next

For _xy:= 1 to Len(oSays2)
	oSays2[_xy]:Refresh()
Next

Dlgrefresh(oDlg2)
oGetDados2:refresh()

Return .t.
