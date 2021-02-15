#include "rwmake.ch"
#include "Protheus.ch"
#include "colors.ch"

User Function GDP009C()
Local xzy := 0
Local i := 0

SetPrvt("ATUAL_KEY,CMSG,NOPCX,ALTERA,INCLUI,EXCLUI")

/*
*****************************************************************************
*****************************************************************************
**  Rotina   | GDP009C  | Autor  -Claudenilson Dias     | Data | 05.03.10  **
**                      |                               |      |           **
*****************************************************************************
** Descricao | GDP009C - INCLUSAO DE MANIFESTO                            **
*****************************************************************************
**  Uso      | SIGAFAT                                                     **
*****************************************************************************
*****************************************************************************
*/

_cArea := Alias()
_nind  := indexord()
_nReg  := Recno()

INCLUI      := .T.
ALTERA      := .F.
EXCLUI      := .F.

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

dbselectarea("SF2")

//aCols[1][nUsado+1] := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Titulo da Janela                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_aCodDoc := {}

cTitulo:="MANIFESTO DE VENDAS"

lCab   := .t.
lRod   := .t.  

aTela := MsAdvSize()

//aTela  :={000,000,600,710}

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
AADD(aC,{"Manifesto: "    ,"_cMan  "    ,040,005 ,"@!"            ,  "ExistCpo('DAK',m->_cMan) .And. u_fVecMot(m->_cMan,m->_cVeiculo,m->_cMotorista)"                            , "DAK" ,.T.  , 1   , "ofont3", "ofont3"  , ""        , ""       , CLR_HBLUE , CLR_WHITE, 45   , 10   ,  20  , 10  , 1.8 , .f. })
AADD(aC,{"Data: "         ,"_dData"     ,040,090 ,                ,  "!empty(m->_dData)"                                   ,       ,.T.  , 1   , "ofont3", "ofont3"  , ""        , ""       , CLR_HBLUE , CLR_WHITE, 25   , 10   ,  40  , 10  , 1.8 , .f. })
AADD(aC,{"Responsavel: "  ,"_cResponsa" ,040,250 ,"@!"            ,                                                        ,       ,.F.  , 1   , "ofont3", "ofont3"  , ""        , ""       , CLR_HBLUE , CLR_WHITE, 45   , 10   ,  200 , 10  , 1.8 , .f. })
AADD(aC,{"Veiculo: "      ,"_cVeiculo"  ,055,005 ,"999"           ,  "U_fValVei(m->_cVeiculo)"                             , "DA3" ,.T.  , 1   , "ofont3", "ofont3"  , ""        , ""       , CLR_HBLUE , CLR_WHITE, 45   , 10   ,  20  , 10  , 1.8 , .f. })
AADD(aC,{" "              ,"_cVeicNom"  ,055,080 ,"@!"            ,                                                        , "   " ,.F.  , 2   , "ofont3", "ofont3"  , ""        , ""       , CLR_HBLUE , CLR_WHITE, 05   , 10   ,  180 , 10  , 1.8 , .f. })
AADD(aC,{"Motorista: "    ,"_cMotorista",070,005 ,"999"           ,  "U_fValMot(m->_cMotorista)"                           , "DA4" ,.T.  , 1   , "ofont3", "ofont3"  , ""        , ""       , CLR_HBLUE , CLR_WHITE, 45   , 10   ,  20  , 10  , 1.8 , .f. })
AADD(aC,{" "              ,"_cMotoNom"  ,070,080 ,"@!"            ,                                                        ,       ,.F.  , 2   , "ofont3", "ofont3"  , ""        , ""       , CLR_HBLUE , CLR_WHITE, 05   , 10   ,  180 , 10  , 1.8 , .f. })
AADD(aC,{"DT das NF : "   ,"_dDataNF "  ,070,250 ,                ,  "	Processa( {|| u_fValDat(m->_dDataNF,'I',m->_cVeiculo,m->_cMotorista,m->_cMan) } )"      ,      ,.T.  , 1   , "ofont3", "ofont3"  , ""        , ""       , CLR_HBLUE , CLR_WHITE, 45   , 10   ,  40  , 10  , 1.8 , .f. })

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


aCGD:={100,03,200,600}
//aCGD:={100,03,300,700}


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Validacoes na GetDados                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cLinhaOk := "U_fValLin(@aCOls)"
cTudoOk  := "AllwaysTrue()"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chamada da Funcao de Browse para edicao                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_nmax := len(acols)
_aGetEdt := {"F2_VLDIN","F2_VLDUP","F2_VLCHQ","F2_VLBON","F2_VLCONS"}
_lDelLin := .t.

Do While .t.
	
	_dData     := dDataBase
	
	dbselectarea("SZM")
	dbsetorder(1)
	dbgobottom()
	
	_cMan      := strzero(val(zm_manifes)+1,6)  //getsxenum("SZM","ZM_MANIFES")	 //substr(getmv("MV_TRFFIL"),1,6)
	dbselectarea("SF2")
	
	_cVeiculo  := space(8)
	_cVeicNom  := space(30)
	_cMotorista:= space(6)
	_cMotoNom  := space(40)
	_cResponsa := UsrFullName(RetCodUsr()) //space(50) //RAFAEL ALMEIDA - SIGACORP (07/04/2017)
	_dDataNF   := ctod("")
	
	
	_nQtdCli   := 0
	_nQtdNF    := 0
	_nQtdPro   := 0
	_nQtdBai   := 0
	
	
	_nPesoB := 0
	_nPesoL := 0
	
	_nValNf := 0
	_nValFat := 0
	
	_nVlDin := 0
	_nVlDup := 0
	_nVlChq := 0
	_nVlBon := 0
	_nVlCons:= 0
	
	Do While .t.
		
		dbselectarea("SZM")
		dbsetorder(1)
		dbgotop()
		
		If dbseek(xfilial("SZM")+_cMan,.f.)
			_cMan := strzero(val(_cMan)+1,6)
		Else
			Exit
		Endif
		
	Enddo
	
	_cFiller  := ""
	
	lRetMod2  := u_Modelot(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,_aGetEdt,,,_nMax,aTela,_lDelLin)
	
	IF lRetMod2
		
		dbselectarea("SZM")
		
		u_fTotMan(@aCols)
		
		IF RecLock("SZM",.T.)
			
			SZM->ZM_FILIAL  := xfilial("SZM")
			SZM->ZM_MANIFES := _cMan
			SZM->ZM_DATA    := _dData
			SZM->ZM_VEICULO := _cVeiculo
			SZM->ZM_MOTORIS := _cMotorista
			SZM->ZM_RESPONS := _cResponsa
			SZM->ZM_NFDTSAI := _dDataNF
			SZM->ZM_PESOB   := _nPesoB
			SZM->ZM_PESOL   := _nPesoL
			SZM->ZM_QTDITE  := 0
			SZM->ZM_QTDNF   := _nQtdNF
			SZM->ZM_QTDTRAN := _nQtdPro
			SZM->ZM_QTDCLI  := _nQtdCli
			SZM->ZM_QTDLOC  := _nQtdBai
			SZM->ZM_QTDEMB1 := 0
			SZM->ZM_QTDEMB2 := 0
			SZM->ZM_QTDEMB3 := 0
			SZM->ZM_VALNF   := _nValNF
			SZM->ZM_VALFAT  := _nValFat
			SZM->ZM_VLDIN   := _nVlDin
			SZM->ZM_VLDUP   := _nVlDup
			SZM->ZM_VLCHQ   := _nVlCHQ
			SZM->ZM_VLBON   := _nVlBon
			SZM->ZM_VLCONS  := _nVlCons
			SZM->ZM_STATUS  := "I"
			
			MsUnLock()
			
			//ConfirmSx8()
			
		EndIF
		
		
		For i:=1 to Len(aCols)
			
			If !aCols[i][nUsado+1]
				
				dbselectarea("SF2")
				dbsetorder(1)
				dbgotop()
				
				_cChave := xfilial("SF2") + substr(aCols[i,2],01,09) + substr(aCols[i,2],11,3) +aCols[i,15]+aCols[i,16]
				
				if dbseek(_cChave,.f.)
					if f2_emissao == aCols[i,17] .and. f2_valbrut == aCols[i,4]
						IF reclock("SF2",.F.)
							SF2->F2_MANIFES := _cMan
							SF2->F2_VLDUP   := aCols[i,06]
							SF2->F2_VLDIN   := aCols[i,07]
							SF2->F2_VLCHQ   := aCols[i,08]
							SF2->F2_VLBON   := aCols[i,09]
							SF2->F2_VLCONS  := aCols[i,10]
							msUnlock()
						Endif
					Else
						Alert("Problemas na atualizacao do Manifesto ! (DATA)")
					Endif
				Else
					Alert("Problemas na atualizacao do Manifesto ! (SF2)")
				Endif
			Endif
			
		Next
		
		
		dbselectarea("SZM")
		
		aCols := Array(1,nUsado+1)
		
		for xzy := 1 to len(_aCampos)
			acols[1][xzy] := _aCampos[xzy][11]
		Next
		
		aCols[1][nUsado+1] := .F.
		
	Else
		
		//RollBackSx8()
		Exit
		
	Endif
	
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
USER FUNCTION Modelot(cTitulo,aC,aR,aCGD,nOpcx,cLineOk,cAllOk,aGetsGD,bF4,cIniCpos,nMax,aCordW,lDelGetD,oDlgMain)

local   nOpca:=0, i,lAllOk, cCampo, nX, nY, cCaption, cPict, cValid, cF3, cWhen, nLargSay, nLargGet, uConteudo
Local   cBlkGet,cBlkWhen,cBlkVld, oSaveGetdad := Nil, aSvRot := Nil
Local _nctd := 0
Local _xy := 0
private oSay2, oGet2,oGets2 := {},oSays2 := {}

private oDlg2
private oGetDados2
private cLineOk2 := cLineOk
private cAllOk2  := cAllOk
private lFirst   := .t.
Private nCount  := 0
//Private VK_F4     := 115
//nOpcx	    := 3

//aCGD	    := {}
lDelGetD  := Iif(lDelGetD==Nil,.t.,lDelGetD)
oDlgMain  := Iif(oDlgMain==Nil,oMainWnd,oDlgMain)

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
                         //125,0,400,635
aCordW :=MsAdvSize()//Iif(aCordW==Nil,{125,0,600,800},aCordW)




//DEFINE MSDIALOG oDlg2 TITLE OemToAnsi(cTitulo) FROM aCordW[1],aCordW[2] TO aCordW[3],aCordW[4] PIXEL OF oDlgMain
DEFINE MSDIALOG oDlg2 TITLE OemToAnsi(cTitulo) FROM aCordW[7],0 to aCordW[6],aCordW[5]  PIXEL OF oDlgMain

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
			
			//			         TGet():New( <nRow> , <nCol>          , bSETGET(<uVar>) , <oWnd>, <nWidth>   , <nHeight>  , <cPict> , <{ValidFunc}> , <nClrFore>  , <nClrBack> , <oFont>   , <.design.>, <oCursor>, <.pixel.>, <cMsg>    , <.update.>,  <{uWhen}>    , <.lCenter.>, <.lRight.>, [\{|nKey, nFlags, Self| <uChange>\}], <.readonly.>,<.pass.>,  [<.lNoBorder.>], <nHelpId>  )
			//			         TGet():New( nX     , nY+nLargSay     ,&cBlKGet         ,oDlg   ,            ,            , cPict   , &(cBlkVld)    ,             ,            ,           , .F.       ,          , .T.      ,           , .F.       ,  &(cBlkWhen)  , .F.        , .F.       ,                                     , .F.         , .F.    ,cF3              , (cCampo)   )
			
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

oGetDados2:=MSGetDados():New(aCGD[1],aCGD[2],aCGD[3],aCGD[4],nOpcX,"u_LineOK()","u_allok()",cIniCpos,lDelGetD,aGetsGD, , ,nMax ,"u_FieldOk()")

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
			//			         TGet():New( <nRow> , <nCol>          , bSETGET(<uVar>) , <oWnd>, <nWidth>   , <nHeight>  , <cPict> , <{ValidFunc}> , <nClrFore>  , <nClrBack> , <oFont>   , <.design.>, <oCursor>, <.pixel.>, <cMsg>    , <.update.>,  <{uWhen}>    , <.lCenter.>, <.lRight.>, [\{|nKey, nFlags, Self| <uChange>\}], <.readonly.>,<.pass.>,  [<.lNoBorder.>], <nHelpId>  )
			//			         TGet():New( nX     , nY+nLargSay     ,&cBlKGet         ,oDlg   ,            ,            , cPict   , &(cBlkVld)    ,             ,            ,           , .F.       ,          , .T.      ,           , .F.       ,  &(cBlkWhen)  , .F.        , .F.       ,                                     , .F.         , .F.    ,cF3              , (cCampo)   )
			
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


ACTIVATE MSDIALOG oDlg2 ON INIT EnchoiceBar(oDlg2,{||nOpca:=1,lAllOk := u_allOK(),Iif(lAllOk,oDlg2:End(),nOpca:=0)},{||oDlg2:End()})

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
user Function LineOk()
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
user Function allok()
//********************************************

lRet := u_LineOk()

If lRet
	lRet := &cAllOk2
EndIf

Return lRet

//********************************

static Function CallMod2Obj()
Return oGetDados2

//********************************

user Function FieldOk()
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


/////////////////////////////////////////
/////////////////////////////////////////
user function fValVei(_cVeiculo)
/////////////////////////////////////////
/////////////////////////////////////////
Local aArea := GetArea()
Local lRet := .f.

if ! empty(_cVeiculo)
	
	dbselectarea("DA3")
	dbsetorder(1)
	dbgotop()
	
	if dbseek(xfilial("DA3")+_cVeiculo,.F.)
		_cVeicNom := DA3_DESC
		lRet      := .t.
	Else
		alert("Veiculo nao cadastrado !!")
	Endif
	
Endif

Dlgrefresh(oDlg2)
oGetDados2:refresh()
RestArea(aArea)

return lRet


/////////////////////////////////////////
/////////////////////////////////////////
user function fValMot(_cMotorista)
/////////////////////////////////////////
/////////////////////////////////////////
Local aArea := GetArea()
Local lRet := .f.

if ! empty(_cMotorista)
	
	dbselectarea("DA4")
	dbsetorder(1)
	dbgotop()
	
	if dbseek(xfilial("DA4")+_cMotorista,.F.)
		_cMotoNom := DA4_NOME
		lRet      := .t.
	Else
		alert("Motorista nao cadastrado !!")
	Endif
	
Endif

Dlgrefresh(oDlg2)
oGetDados2:refresh()
RestArea(aArea)

return lRet



/////////////////////////////////////////
/////////////////////////////////////////
user function fValDat(_dDataNf,cOperacao,_cCaminh,_cMotor,_cManf)
/////////////////////////////////////////
/////////////////////////////////////////
Local aArea := GetArea()
Local lRet := .f.
Local _cQry := " "    //RAFAEL ALMEIDA - SIGACORP (07/04/2017)
Local _cCodDak := ""  //RAFAEL ALMEIDA - SIGACORP (07/04/2017)
Local _cCodSZM := _cManf 
Local _nX := 0
Local _x := 0

//INICIO - RAFAEL ALMEIDA - SIGACORP (07/04/2017)
_cQry := " "
_cQry += " SELECT 
_cQry += " TOP 1 DAK_COD
_cQry += "  FROM " + RetSqlName("DAK") +"  "
_cQry += " WHERE D_E_L_E_T_ = ''	"
_cQry += " AND DAK_FILIAL = '"+xfilial("DAK")+"' "
_cQry += " AND DAK_CAMINH = '"+_cCaminh+"' "
_cQry += " AND DAK_MOTORI = '"+_cMotor+"' "    
_cQry += " AND DAK_DATA BETWEEN '"+ DTOS(DaySub(_dDataNf, 7)) +"' AND '"+ DTOS(_dDataNf)+"'  "
_cQry += " ORDER BY 1 DESC	    "
_cQry := ChangeQuery(_cQry )
dbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQry), "TMPDAK", .F., .T.)

DbSelectArea("TMPDAK")
TMPDAK->(DbGoTop())
	
Do While !TMPDAK->(Eof())
	_cCodDak := TMPDAK->DAK_COD
	TMPDAK->(dbSkip())
Enddo
TMPDAK->(DBCLOSEAREA())
//FIM - RAFAEL ALMEIDA - SIGACORP (07/04/2017)


if len(acols) == 1 .and. empty(acols[1,1])
	
	procregua(4)
	
	if _dDataNf >= ctod('01/03/2010') .and. _dDataNf >= _dData
		
		incproc()
		
		_cQry := " "
		
		_cQry += " SELECT SF2.*,  SA1.*, SE4.*  FROM "+retsqlname("SF2")+ " AS SF2, "+retsqlname("SA1")+ " AS SA1, "+retsqlname("SE4")+ " AS SE4 "
		_cQry += " WHERE  SF2.D_E_L_E_T_ <> '*' AND  SA1.D_E_L_E_T_ <> '*' AND  SE4.D_E_L_E_T_ <> '*' "
		_cQry += " AND  SF2.F2_FILIAL = '"+xfilial("SF2")+"' "
		
		if cOperacao == "I"
			_cQry += " AND  SF2.F2_SAIDA   = '"+ DTOS(_dDataNF) +"' "
			_cQry += " AND  SF2.F2_MANIFES = ' ' "
			_cQry += " AND  SF2.F2_CARGA = '"+_cMan+"' "			
		Else
			_cQry += " AND  SF2.F2_MANIFES = '"+_cMan+"' "
		Endif
		
		_cQry += " AND  SA1.A1_FILIAL = '"+xfilial("SA1")+"' "
		_cQry += " AND  SA1.A1_COD     = SF2.F2_CLIENTE "
		_cQry += " AND  SA1.A1_LOJA    = SF2.F2_LOJA "
		_cQry += " AND  SE4.E4_FILIAL = '"+xfilial("SE4")+"' "
		_cQry += " AND  SE4.E4_CODIGO  = SF2.F2_COND    "
		
		_cQry += " ORDER BY SF2.F2_DOC "
		
		_cQry := ChangeQuery(_cQry)
		
		//alert(_cQry)
		
		
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cqRY), "TSF2", .F., .T.)
		
		_aStrutmp1 := SF2->(dbStruct())
		
		For _nX := 1 To Len(_aStrutmp1)
			If _aStrutmp1[_nX,2] $ "DN"
				TcSetField("TSF2",_aStrutmp1[_nX,1],_aStrutmp1[_nX,2],_aStrutmp1[_nX,3],_aStrutmp1[_nX,4])
			EndIf
		Next nX
		
		_aStrutmp1 := SB1->(dbStruct())
		
		For _nX := 1 To Len(_aStrutmp1)
			If _aStrutmp1[_nX,2] $ "DN"
				TcSetField("TSF2",_aStrutmp1[_nX,1],_aStrutmp1[_nX,2],_aStrutmp1[_nX,3],_aStrutmp1[_nX,4])
			EndIf
		Next nX
		
		
		dbselectarea("TSF2")
		dbgotop()
		
		aCols2 := Aclone(aCols)
		aCols  := {}
		
		_nQtdNF := 0
		
		incproc()
		
		Do While ! eof()
			
			_nQtdNF ++
			
					_lusado := .f.

			if cOperacao == "I"
				
				
				_cForma := upper(alltrim(E4_FORMA))
				
				_vlDup  := 0
				_vlDin  := 0
				_vlchq  := 0
				_vlbon  := 0
				_vlCons := 0
				
				if f2_veicul1 == _cVeiculo
					_lusado := .f.
				Else
					_lusado := .t.
				Endif
				
				
				IF F2_VALFAT == 0
					_vlbon  := F2_VALBRUT
				Elseif _cForma == "BOL"
					_vlDup  := F2_VALFAT
				Elseif _cForma == "R$"
					_vldin  := F2_VALFAT
				Elseif _cForma == "CH"
					_vlchq  := F2_VALFAT
				Else
					_vlDup  := F2_VALFAT
				Endif
				
			Else
				
				
				_vlDup  := f2_vldup
				_vlDin  := f2_vldin
				_vlchq  := f2_vlchq
				_vlbon  := f2_vlbon
				_vlCons := f2_vlcons
				
			Endif
			
			//           1                   2                    3                  4           5          6       7       8       9       10       11   12         13         14                15          16       17          18     19        20
			aadd(aCols,{ strzero(_nQtdNF,3), F2_DOC+'-'+F2_SERIE, upper(F2_CLINOME), F2_VALBRUT, F2_VALFAT, _VLDUP, _VLDIN, _VLCHQ, _VLBON, _VLCONS, 0  , F2_PLIQUI, F2_PBRUTO, UPPER(A1_BAIRRO), F2_CLIENTE, F2_LOJA, F2_EMISSAO,F2_COND,E4_FORMA, _lUsado})
			
			dbskip()
			
		Enddo
		
		if len(acols) == 0
			
			aCols := Aclone(aCols2)
			
		Else
			
			
			incproc()
			
			For _x :=1 to len(aCols)
				
				_cChave  :=  xfilial("SD2")+substr(aCols[_x,2],01,09)+substr(aCols[_x,2],11,3)+aCols[_x,15]+aCols[_x,16]
				_nQtdPro := 0
				
				dbselectarea("SD2")
				dbsetorder(3)
				dbgotop()
				
				dbseek(_cChave,.f.)
				
				Do While ! eof() .and. D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA == _cChave
					
					IF D2_EMISSAO == aCols[_x,17]
						_nQtdPro += d2_quant
					Endif
					
					dbskip()
				Enddo
				
				aCols[_x,11] := _nQtdPro
				
			Next
			
			incproc()
			
			_nmax := len(acols)
			
			u_fTotMan(@aCols)
			
			lRet := .t.
			
		Endif
		
		
		dbselectarea("TSF2")
		dbclosearea()
		dbselectarea("SZM")
		
		n := 1
		
	Else
		alert("Data para NF nao e valida !!")
	Endif
	
Endif

//RAFAEL ALMEIDA - SIGACORP (28/04/2017)
//If !Empty(_cCodDak) 
//_cMan := _cCodDak //RAFAEL ALMEIDA - SIGACORP (07/04/2017) 
//Else 
_cMan := _cCodSZM
//EndIf

Dlgrefresh(oDlg2)
oGetDados2:refresh()

RestArea(aArea)

return lRet



user function fTotMan(_aCols)

Local _x := 0

_aCliente := {}
_aLocal   := {}
_aProduto := {}
_aTranspo := {}

_nQtdNF  := 0
_nQtdPro := 0
_nQtdBai := 0
_nQtdCli := 0

_nPesoB  := 0
_nPesoL  := 0

_nValNf := 0
_nValFat := 0

_nVlDin := 0
_nVlDup := 0
_nVlChq := 0
_nVlBon := 0
_nVlCons:= 0

for _x := 1 to len(_aCols)
	
	
	if !_aCols[_x,nusado+1]
		
		_nQtdNF ++
		
		_nQtdPro += _aCols[_x,11]
		
		_nPesoL  += _aCols[_x,12]
		_nPesoB  += _aCols[_x,13]
		
		
		_nValNf  += _aCols[_x,04]
		_nValFat += _aCols[_x,05]
		
		_nVlDup += _aCols[_x,06]
		_nVlDin += _aCols[_x,07]
		_nVlChq += _aCols[_x,08]
		_nVlBon += _aCols[_x,09]
		_nVlCons+= _aCols[_x,10]
		
		//////////////////////////////////
		_cBairro  := _aCols[_x,14]
		
		
		_nBai :=  aScan( _aLocal , { |X| X[1]  == _cBairro  })
		
		if _nBai == 0
			aadd(_aLocal,{_cBairro,1})
		Else
			_aLocal[_nBai,2] ++
		Endif
		
		
		//////////////////////////////////
		
		_cCLiente  := _aCols[_x,03]
		
		_nCli :=  aScan( _aCliente , { |X| upper(alltrim(X[1]))  == _cCliente  })
		
		if _nCli == 0
			aadd(_aCliente, {_cCLiente,1})
		Else
			_aCliente[_nCli,2] ++
		Endif
		
		
	Endif
Next

_nQtdBai := len(_aLocal)
_nQtdCli := len(_aCLiente)

Dlgrefresh(oDlg2)
oGetDados2:refresh()

return .t.


user function fValLin(_aCOls)
Local _cCarga := ""
local lRet := .f.
Local _nZ := 0

if u_fTotMan(_aCols)
	
	if  acols[n,nusado+1]
		lRet := .t.
	Else
		
		if   acols[n,5] == 0
			if acols[n,4] == acols[n,6]+acols[n,7]+acols[n,8]+acols[n,9]+acols[n,10]
				lRet := .t.
			Else
				Alert("O valor da bonificacao nao bate com o valor da NF !")
			Endif
		Else
			if acols[n,5] == acols[n,6]+acols[n,7]+acols[n,8]+acols[n,9]+acols[n,10]
				lRet := .t.
			Else
				Alert("O valor faturado nao bate com os valores por forma de pagamento !")
			Endif
		Endif
	Endif
Endif


If lRet
	For _nZ := 1 To Len(_aCOls)		
		_cCarga := GetAdvFVal("SF2", "F2_CARGA",xFilial("SF2")+ _aCOls[_nZ][15] + _aCOls[_nZ][16] + SUBSTRING(_aCOls[_nZ][2],1,9) + SUBSTRING(_aCOls[_nZ][2],11,3) ,2)		
		If Empty(_cCarga)
			MSGALERT( "Nota Fiscal "+  _aCOls[_nZ][2] +" deverá ser atrelada a uma Carga!","Atenção" )
			Return(.F.)
		EndIf				
	Next _nZ	
EndIf

return lret



/////////////////////////////////////////
/////////////////////////////////////////
user function fVecMot(_cManf,_cCaminh,_cMotor)
/////////////////////////////////////////
/////////////////////////////////////////
Local aArea := GetArea()
Local lRet     := .t.
Local _cQry    := " "
Local _cMotDak := ""
Local _cVecDak := ""
Local _cCodSZM := _cManf 

_cQry := " "
_cQry += " SELECT 
_cQry += " TOP 1 DAK_CAMINH, DAK_MOTORI
_cQry += "  FROM " + RetSqlName("DAK") +"  "
_cQry += " WHERE D_E_L_E_T_ = ''	"
_cQry += " AND DAK_FILIAL = '"+xfilial("DAK")+"' "
_cQry += " AND DAK_COD    = '"+_cManf+"' "    
_cQry += " ORDER BY 1 DESC	    "
_cQry := ChangeQuery(_cQry )
dbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQry), "VCMTDAK", .F., .T.)

DbSelectArea("VCMTDAK")
VCMTDAK->(DbGoTop())
	
Do While !VCMTDAK->(Eof())
	_cMotDak := VCMTDAK->DAK_MOTORI
	_cVecDak := VCMTDAK->DAK_CAMINH	
	VCMTDAK->(dbSkip())
Enddo
VCMTDAK->(DBCLOSEAREA())


If !Empty(_cVecDak) 
	_cMotorista := _cMotDak
	_cVeiculo   := _cVecDak
Else 
	_cMotorista := ""
	_cVeiculo   := ""	
EndIf

Dlgrefresh(oDlg2)
oGetDados2:refresh()

RestArea(aArea)

Return(lRet)