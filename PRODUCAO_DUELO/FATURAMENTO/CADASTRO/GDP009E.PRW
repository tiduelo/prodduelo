#include "rwmake.ch"
#include "colors.ch"

User Function GDP009E(_nOpcao)
Local xzy := 0
Local i:= 0
SetPrvt("ATUAL_KEY,CMSG,NOPCX,ALTERA,INCLUI,EXCLUI")

/*
*****************************************************************************
*****************************************************************************
**  Rotina   | GDP009D  | Autor  -Claudenilson Dias     | Data | 05.03.10  **
**                      |                               |      |           **
*****************************************************************************
** Descricao | GDP009D - ALTERACAO DE MANIFESTO                            **
*****************************************************************************
**  Uso      | SIGAFAT                                                     **
*****************************************************************************
*****************************************************************************
*/

_cArea := Alias()
_nind  := indexord()
_nReg  := Recno()

INCLUI      := .F.
ALTERA      := .F.

if _nOpcao == 5
	EXCLUI      := .T.
Else
	EXCLUI      := .F.
Endif

cMsg        :=  ""
nOpcx       :=  3
nUsado      :=  0
aHeader     :=  {}
_cFile      := "SF2"

_aCampos := {}
aadd(_aCampos,{"Item"       ,"F2_SERIE  ","",00,0,"","","","","",""}) // 01
aadd(_aCampos,{""           ,"F2_DOC    ","",13,0,"","","","","",""}) // 02
aadd(_aCampos,{""           ,"F2_CLINOME","",00,0,"","","","","",""}) // 03
aadd(_aCampos,{""           ,"F2_VALBRUT","",00,0,"","","","","",""}) // 04
aadd(_aCampos,{""           ,"F2_VALFAT ","",00,0,"","","","","",""}) // 05
aadd(_aCampos,{""           ,"F2_VLDUP  ","",00,0,"","","","","",""}) // 06
aadd(_aCampos,{""           ,"F2_VLDIN  ","",00,0,"","","","","",""}) // 07
aadd(_aCampos,{""           ,"F2_VLCHQ  ","",00,0,"","","","","",""}) // 08
aadd(_aCampos,{""           ,"F2_VLBON  ","",00,0,"","","","","",""}) // 09
aadd(_aCampos,{""           ,"F2_VLCONS ","",00,0,"","","","","",""}) // 10
aadd(_aCampos,{"Qtd.Prod."  ,"F2_VLCRE  ","",00,0,"","","","","",""}) // 11
aadd(_aCampos,{""           ,"F2_PLIQUI ","",00,0,"","","","","",""}) // 12
aadd(_aCampos,{""           ,"F2_PBRUTO ","",00,0,"","","","","",""}) // 13
aadd(_aCampos,{"Bairro"     ,"F2_MENNOTA","",30,0,"","","","","",""}) // 14
aadd(_aCampos,{""           ,"F2_CLIENTE","",00,0,"","","","","",""}) // 15
aadd(_aCampos,{""           ,"F2_LOJA   ","",00,0,"","","","","",""}) // 16
aadd(_aCampos,{""           ,"F2_EMISSAO","",00,0,"","","","","",""}) // 17
aadd(_aCampos,{""           ,"F2_COND   ","",00,0,"","","","","",""}) // 18
aadd(_aCampos,{"Forma Pg."  ,"F2_DUPL   ","",04,0,"","","","","",""}) // 19

oMainTrf := oMainWnd

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek(_cFile)

While !Eof() .And. (x3_arquivo == _cFile)
	
	for xzy := 1 to len(_aCampos)
		
		If upper(Rtrim(x3_campo)) == upper(Rtrim(_aCampos[xzy][2]))
			
			_CVAL := ""
			
			//If TRIM(x3_campo)=="Z6_CODPROD"
			//	_CVAL := "u_fvalcod(M->Z6_CODPROD)"
			//Endif
			
			_aCampos[xzy][1]  := iif(empty(_aCampos[xzy][1]),TRIM(x3_titulo),_aCampos[xzy][1])
			_aCampos[xzy][3]  := x3_picture
			_aCampos[xzy][4]  := iif(_aCampos[xzy][4] <> 0,_aCampos[xzy][4],x3_tamanho)
			_aCampos[xzy][5]  := x3_decimal
			_aCampos[xzy][6]  := _CVAL
			_aCampos[xzy][7]  := x3_usado
			_aCampos[xzy][8]  := x3_tipo
			_aCampos[xzy][9]  := x3_arquivo
			_aCampos[xzy][10] := x3_context
			
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

nusado := len(_aCampos)

//aCols := Array(1,nUsado+1)

for xzy := 1 to len(_aCampos)
	AADD(aHeader,{_aCampos[xzy][1],_aCampos[xzy][2],_aCampos[xzy][3],_aCampos[xzy][4],_aCampos[xzy][5],;
	_aCampos[xzy][6],_aCampos[xzy][7],_aCampos[xzy][8],_aCampos[xzy][9],_aCampos[xzy][10]})
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montando aCols                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//for xzy := 1 to len(_aCampos)
//	acols[1][xzy] := _aCampos[xzy][11]
//Next


aCols := Array(1,nUsado+1)

for xzy := 1 to len(_aCampos)
	acols[1][xzy] := _aCampos[xzy][11]
Next

aCols[1][nUsado+1] := .F.

dbselectarea("SZM")

_dData     := ZM_DATA
_cMan      := ZM_MANIFES
_cAuxMan   := ZM_MANIFES
_cVeiculo  := ZM_VEICULO
_cVeicNom  := space(30)
_cMotorista:= ZM_MOTORIS
_cMotoNom  := space(40)
_cResponsa := ZM_RESPONS
_dDataNF   := ZM_NFDTSAI


_nQtdCli   := ZM_QTDCLI
_nQtdNF    := ZM_QTDNF
_nQtdPro   := ZM_QTDTRAN
_nQtdBai   := ZM_QTDLOC


_nPesoB := ZM_PESOB
_nPesoL := ZM_PESOL

_nValNf := ZM_VALNF
_nValFat := ZM_VALFAT

_nVlDup := ZM_VLDUP
_nVlDin := ZM_VLDIN
_nVlChq := ZM_VLCHQ
_nVlBon := ZM_VLBON
_nVlCons:= ZM_VLCONS

dbselectarea("DA3")
dbsetorder(1)
dbgotop()

if dbseek(xfilial("DA3")+_cVeiculo,.f.)
	_cVeicNom  := DA3_DESC
Endif

dbselectarea("DA4")
dbsetorder(1)
dbgotop()

if dbseek(xfilial("DA4")+_cMotorista,.f.)
	_cMotoNom  := DA4_NOME
Endif

dbselectarea("SZM")

Processa( {|| u_fValDat(m->_dDataNF,'A',m->_cVeiculo,m->_cMotorista) } )"
_cMan := _cAuxMan
//aCols[1][nUsado+1] := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Titulo da Janela                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


cTitulo:="MANIFESTO DE VENDAS"

lCab   := .t.
lRod   := .t.

aTela  :=MsAdvSize()
//aTela  :={000,000,400,610}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array com descricao dos campos do Cabecalho                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aC:={}

ofont1 := TFont():New("TIMES NEW ROMAN" , 15, 50,,.T.)
ofont2 := TFont():New("TIMES NEW ROMAN" , 08, 30,,.F.)
ofont3 := TFont():New("ARIAL"           , 06, 20,,.F.)
//ofont4 := TFont():New("LCDD"            , 15, 50,,.T.)


//        1                2             3   4      5                6                                                      7      8     9      10          11             12        13          14         15      16    17      18    19     20    21
//                                                                                                                                             fonte    ,  fonte    , cor texto , cor fundo, cor texto , cor fundo, larg , alt  , larg , alt , pixel, alinha
//        Descricao       , variavel    ,Lin,Col ,  picture       ,  Valid                                                 , F3   ,when ,tipo ,  Say    ,   Get     ,    Say    ,    Say   ,    Get    ,    Get   , Say  , say  ,  get , Get          direita
AADD(aC,{"Manifesto: "    ,"_cMan  "    ,040,005 ,"@!"            ,  "!empty(m->_cMan)"                                    ,      ,.F.  , 1   , "ofont3", "ofont3"  , ""        , ""       , CLR_HBLUE , CLR_WHITE, 45   , 10   ,  20  , 10  , 1.8 , .f. })
AADD(aC,{"Data: "         ,"_dData"     ,040,090 ,                ,  "!empty(m->_dData)"                                   ,      ,.F.  , 1   , "ofont3", "ofont3"  , ""        , ""       , CLR_HBLUE , CLR_WHITE, 25   , 10   ,  40  , 10  , 1.8 , .f. })
AADD(aC,{"Responsavel: "  ,"_cResponsa" ,040,250 ,"@!"            ,                                                        ,      ,.F.  , 1   , "ofont3", "ofont3"  , ""        , ""       , CLR_HBLUE , CLR_WHITE, 45   , 10   ,  200 , 10  , 1.8 , .f. })
AADD(aC,{"Veiculo: "      ,"_cVeiculo"  ,055,005 ,"999"           ,  "u_fValVei(m->_cVeiculo)"                             , "DA3",.F.  , 1   , "ofont3", "ofont3"  , ""        , ""       , CLR_HBLUE , CLR_WHITE, 45   , 10   ,  20  , 10  , 1.8 , .f. })
AADD(aC,{" "              ,"_cVeicNom"  ,055,080 ,"@!"            ,                                                        , "   ",.F.  , 2   , "ofont3", "ofont3"  , ""        , ""       , CLR_HBLUE , CLR_WHITE, 05   , 10   ,  180 , 10  , 1.8 , .f. })
AADD(aC,{"Motorista: "    ,"_cMotorista",070,005 ,"999"           ,  "u_fValMot(m->_cMotorista)"                           , "DA4",.F.  , 1   , "ofont3", "ofont3"  , ""        , ""       , CLR_HBLUE , CLR_WHITE, 45   , 10   ,  20  , 10  , 1.8 , .f. })
AADD(aC,{" "              ,"_cMotoNom"  ,070,080 ,"@!"            ,                                                        ,      ,.F.  , 2   , "ofont3", "ofont3"  , ""        , ""       , CLR_HBLUE , CLR_WHITE, 05   , 10   ,  180 , 10  , 1.8 , .f. })
AADD(aC,{"DT das NF : "   ,"_dDataNF "  ,070,250 ,                ,  "	Processa( {|| u_fValDat(m->_dDataNF,X,m->_cVeiculo,m->_cMotorista) } )"          ,      ,.F.  , 1   , "ofont3", "ofont3"  , ""        , ""       , CLR_HBLUE , CLR_WHITE, 45   , 10   ,  40  , 10  , 1.8 , .f. })

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array com descricao dos campos do Rodape                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aR:={}
//        1                2             3   4      5                   6                                                      7      8     9      10          11             12        13          14         15      16    17      18    19     20    21
//                                                                                                                                                fonte    ,  fonte    , cor texto , cor fundo, cor texto , cor fundo, larg , alt  , larg , alt , pixel, alinha
//        Descricao       , variavel    ,Lin,Col ,  picture          ,  Valid                                                 , F3   ,when ,tipo ,  Say    ,   Get     ,    Say    ,    Say   ,    Get    ,    Get   , Say  , say  ,  get , Get          direita
AADD(aR,{"Clientes:"      ,"_nQtdCli"   ,210,005 ,                   ,                                                        ,      ,.F.  , 1   , "ofont3", "ofont3"  , ""        , ""       , CLR_HBLUE , CLR_WHITE, 30   , 10   ,  40  , 10  , 1.8 , .f. })
AADD(aR,{"NF: "           ,"_nQtdNF"    ,210,085 ,                   ,                                                        ,      ,.F.  , 1   , "ofont3", "ofont3"  , ""        , ""       , CLR_HBLUE , CLR_WHITE, 30   , 10   ,  40  , 10  , 1.8 , .f. })
AADD(aR,{"Produtos:"      ,"_nQtdPro"   ,210,165 ,                   ,                                                        ,      ,.F.  , 1   , "ofont3", "ofont3"  , ""        , ""       , CLR_HBLUE , CLR_WHITE, 30   , 10   ,  40  , 10  , 1.8 , .f. })
AADD(aR,{"Bairros :"      ,"_nQtdBai"   ,210,245 ,                   ,                                                        ,      ,.F.  , 1   , "ofont3", "ofont3"  , ""        , ""       , CLR_HBLUE , CLR_WHITE, 30   , 10   ,  40  , 10  , 1.8 , .f. })
AADD(aR,{"Peso Brt:"      ,"_nPesoB "   ,210,325 , "@E 99,999,999.99",                                                        ,      ,.F.  , 1   , "ofont3", "ofont3"  , ""        , ""       , CLR_HBLUE , CLR_WHITE, 30   , 10   ,  40  , 10  , 1.8 , .f. })
AADD(aR,{"Peso Liq:"      ,"_nPesoL "   ,210,405 , "@E 99,999,999.99",                                                        ,      ,.F.  , 1   , "ofont3", "ofont3"  , ""        , ""       , CLR_HBLUE , CLR_WHITE, 30   , 10   ,  40  , 10  , 1.8 , .f. })

AADD(aR,{"Valor NF"       ,"_nValNF "   ,225,005 , "@E 99,999,999.99",                                                        ,      ,.F.  , 1   , "ofont3", "ofont3"  , ""        , ""       , CLR_HBLUE , CLR_WHITE, 30   , 10   ,  40  , 10  , 1.8 , .f. })
AADD(aR,{"Faturado"       ,"_nValFat"   ,225,085 , "@E 99,999,999.99",                                                        ,      ,.F.  , 1   , "ofont3", "ofont3"  , ""        , ""       , CLR_HBLUE , CLR_WHITE, 30   , 10   ,  40  , 10  , 1.8 , .f. })
AADD(aR,{"Duplicata"      ,"_nVlDup "   ,225,165 , "@E 99,999,999.99",                                                        ,      ,.F.  , 1   , "ofont3", "ofont3"  , ""        , ""       , CLR_HBLUE , CLR_WHITE, 30   , 10   ,  40  , 10  , 1.8 , .f. })
AADD(aR,{"Dinheiro "      ,"_nVlDin "   ,225,245 , "@E 99,999,999.99",                                                        ,      ,.F.  , 1   , "ofont3", "ofont3"  , ""        , ""       , CLR_HBLUE , CLR_WHITE, 30   , 10   ,  40  , 10  , 1.8 , .f. })
AADD(aR,{"Cheque"         ,"_nVlChq "   ,225,325 , "@E 99,999,999.99",                                                        ,      ,.F.  , 1   , "ofont3", "ofont3"  , ""        , ""       , CLR_HBLUE , CLR_WHITE, 30   , 10   ,  40  , 10  , 1.8 , .f. })
AADD(aR,{"Bonificacao"    ,"_nVLBon "   ,225,405 , "@E 99,999,999.99",                                                        ,      ,.F.  , 1   , "ofont3", "ofont3"  , ""        , ""       , CLR_HBLUE , CLR_WHITE, 30   , 10   ,  40  , 10  , 1.8 , .f. })

aCGD:={070,03,200,600}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Validacoes na GetDados                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cLinhaOk := "AllwaysTrue()"
cTudoOk  := "AllwaysTrue()"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chamada da Funcao de Browse para edicao                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_nmax := len(acols)
_aGetEdt := {}

_lDelLin := .F.


Do While .t.
	
	lRetMod2  := u_Modelot(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,_aGetEdt,,,_nMax,aTela,_lDelLin)
	
	IF lRetMod2 .AND. _nOpcao == 5
	
		if msgyesno("Tem certeza que quer apagar o Manifesto ?","ATENÇÃO")
			
			//if U_LOG("06",SZM->ZM_MANIFES,,,"",,,,"MAN",SZM->ZM_MANIFES) // versao 12

				dbselectarea("SZM")
				
				IF RecLock("SZM",.F.)
					DELETE
					MsUnLock()
				EndIF
				
				For i:=1 to Len(aCols)
					dbselectarea("SF2")
					dbsetorder(2)
					dbgotop()
					
					_cChave := xfilial("SF2") +aCols[i,15]+aCols[i,16] + substr(aCols[i,2],01,09) + substr(aCols[i,2],11,3) 
					
					if dbseek(_cChave,.f.)
						if f2_emissao == aCols[i,17] .and. f2_valbrut == aCols[i,4]
							IF reclock("SF2",.F.)
								SF2->F2_MANIFES := space(6)
								msUnlock()
							Endif
						Else
							Alert("Problemas na atualizacao do Manifesto ! (DATA_3)")
						Endif
					Else
						Alert("Problemas na atualizacao do Manifesto ! (SF2_DEL)")
					Endif
				Next
			//eNDIF
		eNDIF
		
		dbselectarea("SZM")
		
		aCols := Array(1,nUsado+1)
		
		for xzy := 1 to len(_aCampos)
			acols[1][xzy] := _aCampos[xzy][11]
		Next
		
		aCols[1][nUsado+1] := .F.
		
	Endif
	
	Exit
	
EndDo

cLineOk2   := "AllwaysTrue()"
oGets2     := {}
oSays2     := {}
oDlg2      := oMainWnd
oGetDados2 := oMainWnd

dbselectarea(_cArea)
dbsetorder(_nind)
dbgoto(_nReg)


Return NIL


