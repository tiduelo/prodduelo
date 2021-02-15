#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#define CLD_GREEN		RGB(177,241,186)
#define CLD_YELLOW	RGB(241,243,152)
#define CLD_RED 		RGB(255,81,81)
/*
*****************************************************************************
*****************************************************************************
**  Rotina  | GDP011 | Autor  -Claudenilson Dias        | Data | 20.02.14  **
**                   |                                  |      |           **
*****************************************************************************
** Descricao | GDP011 - REGRAS DE COMISSIONAMENTO                          **
*****************************************************************************
**  Uso      | SIGAFAT                                                     **
*****************************************************************************
*****************************************************************************
*/
/////////////////////////////////////////////////////
/////////////////////////////////////////////////////
User Function GDP011()
/////////////////////////////////////////////////////
/////////////////////////////////////////////////////

_cArea := Alias()
_nind  := indexord()
_nReg  := Recno()

/*

_cTmpSC5  := CriaTrab(SC5->(dbstruct()),.T.) + GetDbExtension()
_cTmpSC5I := strtran(_cTmpSC5,GetDbExtension(),".IDX")
_cTmpSC5F := strtran(_cTmpSC5,GetDbExtension(),".FPT")
_cTmpSC6  := CriaTrab(SC6->(dbstruct()),.T.) + GetDbExtension()
_cTmpSC6I := strtran(_cTmpSC6,GetDbExtension(),".IDX")
_cTmpSC6F := strtran(_cTmpSC6,GetDbExtension(),".FPT")

if select("SC5TMP") > 0
SC5TMP->(dbclosearea())
Endif
if select("SC6TMP") > 0
SC6TMP->(dbclosearea())
Endif

dbUseArea(.T.,,_cTmpSC5,"SC5TMP",.F.,.F.)
IndRegua("SC5TMP",_cTmpSC5I,"C5_PEDSAIB",,,)
dbSetorder(1)
dbgotop()

dbUseArea(.T.,,_cTmpSC6,"SC6TMP",.F.,.F.)
IndRegua("SC6TMP",_cTmpSC6I,"C6_PEDSAIB+C6_ITMSAIB",,,)
dbSetorder(1)

*/

aSizeEst   := MsAdvSize()
//
// 1 -> Linha  inicial area trabalho
// 2 -> Coluna inicial area trabalho
// 3 -> Coluna final   area trabalho
// 4 -> Linha  final   area trabalho
// 5 -> Coluna final   dialog
// 6 -> Linha  final   dialog
// 7 -> Linha  inicial dialog
//

ofontBtn   := TFont():New("ARIAL" , , 25 , , .T. )
ofontBtn2  := TFont():New("ARIAL" , , 15 , , .T. )
ofont1     := TFont():New("ARIAL" , , 22 , , .T. )

oOk        := LoadBitmap(GetResources(),'LBOK')
oNoOk      := LoadBitmap(GetResources(),'LBNO')
oOkTk      := LoadBitmap(GetResources(),'LBTK')

oVerde     := LoadBitmap(GetResources(),'br_verde')
oAmarelo   := LoadBitmap(GetResources(),'br_amarelo')
oVermelho  := LoadBitmap(GetResources(),'br_vermelho')
oPreto     := LoadBitmap(GetResources(),'br_preto')

nForeCor   := CLR_BLACK
nBackCor   := CLR_GREEN

_nFolLar   := aSizeEst[3] - 20
_nFolAlt   := aSizeEst[4] - 40

//aFolTit   := { 'Pedidos' , 'Itens do pedido'}
//aFolDial  := { "oFol1"   , "oFol2"    }

aFolTit   := { 'Regras'}
aFolDial  := { "oFol1" }

dbselectarea("SZC")

oDlgComissao := MSDialog():New( 10, 10 , aSizeEst[6] , aSizeEst[5] , 'Bebidas Duelo - Regras de Comissionamento' , , , .F. , , , , , , .T. , , , .T. , , )

oFolder  := TFolder():New( 5, 10 , aFolTit, aFolDial, oDlgComissao ,,,, .T., .t. , _nFolLar , _nFolAlt, ,.t. )

oFolRegra    := oFolder:aDialogs[1]

//oFolItem     := oFolder:aDialogs[2]


_oBrwRegras := TCBrowse():New(    5  ,   5   , _nFolLar-10 ,  _nFolAlt-20 ,          ,            ,             , oFolRegra,          ,           ,            ,          ,              ,           ,         ,           ,            ,            ,        ,            , "SZC"    ,  .T.     ,         ,            ,          ,   .T.      , .T.         )

_oBrwRegras:AddColumn(TCColumn():New('  '              	, {||IIF(SZC->ZC_MSBLQL == 2 , oVerde ,oVermelho) }       	,                      	,,,'LEFT'  , ,.T.,.F.,,,,.F.,))
_oBrwRegras:AddColumn(TCColumn():New('Regiao'         	, {||SZC->ZC_REGIAO                                } 	   	,                      	,,,'LEFT'  , ,.T.,.F.,,,,.F.,))
_oBrwRegras:AddColumn(TCColumn():New('Produto'         	, {||SZC->ZC_PRODUTO                }                   		,                      	,,,'LEFT'  , ,.F.,.F.,,,,.F.,))
_oBrwRegras:AddColumn(TCColumn():New('Relacionamento'  	, {||SZC->ZC_TIPO                   }                  	   ,                      	,,,'LEFT'  , ,.F.,.F.,,,,.F.,))
_oBrwRegras:AddColumn(TCColumn():New('Comissao'        	, {||SZC->ZC_PERCENT                }                       ,  "@E 999.99" 			,,,'RIGHT' , ,.F.,.F.,,,,.F.,))

//_oBrwItem := TCBrowse():New(    5  ,   5   , _nFolLar-10 ,  _nFolAlt-20 ,          ,            ,             , oFolItem,          ,           ,            ,          ,              ,           ,         ,           ,            ,            ,        ,            , "SC6TMP"    ,  .T.     ,         ,            ,          ,   .T.      , .T.         )

//_oBrwItem:AddColumn(TCColumn():New('Produto'            ,{||SC6TMP->C6_PRODUTO }                                                , "@!"                ,,,'LEFT'    , ,.F.,.F.,,,,.F.,))
//_oBrwItem:AddColumn(TCColumn():New('Descricao'          ,{||Posicione("SB1",1,xFilial("SB1")+SC6TMP->C6_PRODUTO ,"B1_DESC")}   ,                     ,,,'LEFT'    , ,.F.,.F.,,,,.F.,))
//_oBrwItem:AddColumn(TCColumn():New('Quantidade'         ,{||SC6TMP->C6_QTDVEN}                                                  , "@E 999,999"        ,,,'RIGHT'   , ,.F.,.F.,,,,.F.,))
//_oBrwItem:AddColumn(TCColumn():New('Preco Pedido'       ,{||SC6TMP->C6_PRCFIN}                                                  , "@E 999,999.999999" ,,,'RIGHT'   , ,.F.,.F.,,,,.F.,))
//_oBrwItem:AddColumn(TCColumn():New('Total Pedido'       ,{||SC6TMP->C6_VLDED}                                                   , "@E 999,999,999.99" ,,,'RIGHT'   , ,.F.,.F.,,,,.F.,))
//_oBrwItem:AddColumn(TCColumn():New('Prc.Faturamento'    ,{||SC6TMP->C6_PRCVEN}                                                  , "@E 999,999.999999" ,,,'RIGHT'   , ,.F.,.F.,,,,.F.,))
//_oBrwItem:AddColumn(TCColumn():New('Total Faturamento'  ,{||SC6TMP->C6_VALOR}                                                   , "@E 999,999,999.99" ,,,'RIGHT'   , ,.F.,.F.,,,,.F.,))

//dbselectarea("SC5TMP")
//dbsetorder(1)
//dbgotop()

//dbselectarea("SC6TMP")
//_cFILSC6 := " ( C6_PEDSAIB == SC5TMP->C5_PEDSAIB ) "
//SET FILTER TO &_cFILSC6
//dbgotop()

//_oBrwRegras:bChange      := {|| filsc6( SC5TMP->C5_PEDSAIB, SC5TMP->(RECNO()) ) }
//_oBrwRegras:bLdblclick   := {|| MarkPed( SC5TMP->C5_PEDSAIB, 1, SC5TMP->(RECNO()) ) }
//_oBrwRegras:bHeaderClick := {|| msgrun("Aguarde...","Marcacao", {|| MarkPed( SC5TMP->C5_PEDSAIB, 2, SC5TMP->(RECNO()) ) }) }


//oMenuImp   := TMenu():New(0,0,0,0,.T.)    // Adiciona itens no Menu
//oMenuItem1 := TMenuItem():New(oDlgComissao , "1 Abaixo Minimo"    ,,,,{||Alert("TMenuItem 01")},,,,,,,,,.T.)
//oMenuItem2 := TMenuItem():New(oDlgComissao , "2 Acima do Maximo"  ,,,,{||Alert("TMenuItem 02")},,,,,,,,,.T.)
//oMenuItem3 := TMenuItem():New(oDlgComissao , "3 Abaixo do Normal" ,,,,{||Alert("TMenuItem 02")},,,,,,,,,.T.)
//oMenuItem4 := TMenuItem():New(oDlgComissao , "4 Normal"           ,,,,{||Alert("TMenuItem 02")},,,,,,,,,.T.)
//oMenuItem5 := TMenuItem():New(oDlgComissao , "5 Todos "           ,,,,{||Alert("TMenuItem 02")},,,,,,,,,.T.)

//oMenuImp:Add(oMenuItem1)
//oMenuImp:Add(oMenuItem2)
//oMenuImp:Add(oMenuItem3)
//oMenuImp:Add(oMenuItem4)
//oMenuImp:Add(oMenuItem5)

//oMenuTra   := TMenu():New(0,0,0,0,.T.)    // Adiciona itens no Menu
//oMenuTra1  := TMenuItem():New(oDlgComissao , "1 Por Fabricante"   ,,,,{||u_visp004t(1)},,,,,,,,,.T.)
//oMenuTra2  := TMenuItem():New(oDlgComissao , "2 Por Loja"         ,,,,{||u_visp004t(2)},,,,,,,,,.T.)

//oMenuTra:Add(oMenuTra1)
//oMenuTra:Add(oMenuTra2)

//                             1                2                   3                    4                          5              6     7   8      9       10     11    12    13   14    15                               16   17
//
oBtnLer  := TButton():New( _nFolAlt+15 , 010            , 'Incluir'                 	, oDlgComissao , {|| ManComis(1) }    		, 50  , 15 , , ofontBtn2 ,      , .T. ,     ,    ,   ,  											,    ,     )
oBtnImp  := TButton():New( _nFolAlt+15 , 070            , 'Alterar'                 	, oDlgComissao , {|| ManComis(2) }  		, 50  , 15 , , ofontBtn2 ,      , .T. ,     ,    ,   ,                                 	,    ,     )
oBtnImp  := TButton():New( _nFolAlt+15 , 130            , 'Excluir'                 	, oDlgComissao , {|| ManComis(3) }  		, 50  , 15 , , ofontBtn2 ,      , .T. ,     ,    ,   ,                                 	,    ,     )
oBtnImp  := TButton():New( _nFolAlt+15 , 190            , 'Imprimir'                 	, oDlgComissao , {|| ManComis(4) }  		, 50  , 15 , , ofontBtn2 ,      , .T. ,     ,    ,   ,                                  	,    ,     )
oBtnSair := TButton():New( _nFolAlt+15 , aSizeEst[3]-50 , 'Sair'                    	, oDlgComissao , {|| oDlgComissao:end()}	, 30  , 15 , , ofontBtn2 ,      , .T. ,     ,    ,   ,                                   ,    ,     )

//_cQtdLido := ""
//_oLeg   := TSay():New   ( _nFolAlt+18 , 150 , {|| _cQtdLido} , oDlgComissao,  ,   ofont1     ,,,,.T., CLR_GREEN  , CLR_WHITE,100, 25)

//oTBitmap := TBitmap():New( _nFolAlt+10 , 140, 8 , 8 , "br_vermelho" ,  , .t. , oDlgComissao , {||} , {||} , .F. , .F. ,  ,  ,  , {||.t.} , .T. , {|| .t.} )
//_oLeg    := TSay():New   ( _nFolAlt+10 , 150 , {|| "Abaixo Minimo"} , oDlgComissao,  ,        ,,,,.T., CLR_BLUE  , CLR_WHITE,40, 8)

//oTBitmap := TBitmap():New( _nFolAlt+10 , 200, 8 , 8 , "br_amarelo"  ,  , .t. , oDlgComissao , {||} , {||} , .F. , .F. ,  ,  ,  , {||.t.} , .T. , {|| .t.} )
//_oLeg    := TSay():New   ( _nFolAlt+10 , 210 , {|| "Abaixo Normal"} , oDlgComissao,  ,        ,,,,.T., CLR_BLUE  , CLR_WHITE,40, 8 )

//oTBitmap := TBitmap():New( _nFolAlt+10 , 260, 8 , 8 , "br_verde"    ,  , .t. , oDlgComissao , {||} , {||} , .F. , .F. ,  ,  ,  , {||.t.} , .T. , {|| .t.} )
//_oLeg    := TSay():New   ( _nFolAlt+10 , 270 , {|| "Normal"}        , oDlgComissao,  ,        ,,,,.T., CLR_BLUE  , CLR_WHITE,40, 8 )

//oTBitmap := TBitmap():New( _nFolAlt+10 , 320, 8 , 8 , "br_preto"    ,  , .t. , oDlgComissao , {||} , {||} , .F. , .F. ,  ,  ,  , {||.t.} , .T. , {|| .t.} )
//_oLeg    := TSay():New   ( _nFolAlt+10 , 330 , {|| "Acima Maximo"}  , oDlgComissao,  ,        ,,,,.T., CLR_BLUE  , CLR_WHITE,40, 8)

//_oLeg    := TSay():New   ( _nFolAlt+20 , 140 , {|| "F10 - Pesquisa"}       , oDlgComissao,  ,        ,,,,.T., CLR_BLUE  , CLR_WHITE,40, 8)
//_oLeg    := TSay():New   ( _nFolAlt+20 , 200 , {|| "F5  - Marca Status"}   , oDlgComissao,  ,        ,,,,.T., CLR_BLUE  , CLR_WHITE,45, 8)
//_oLeg    := TSay():New   ( _nFolAlt+20 , 260 , {|| "F6  - Marca Item"}     , oDlgComissao,  ,        ,,,,.T., CLR_BLUE  , CLR_WHITE,40, 8)


//oBtnImp2:SetPopupMenu(oMenuTra)

_oBrwRegras:setfocus()
_oBrwRegras:refresh()

//_oBrwItem:refresh()
oDlgComissao:refresh()

_oBrwRegras:setfocus()

oDlgComissao:Activate( , , , .f. )


SetKey(VK_F5  , {|| nil } )
SetKey(VK_F6  , {|| nil } )
SetKey(VK_F9  , {|| nil } )
setkey(VK_F10 , {|| nil } )


//if select("SC5TMP") > 0
//	SC5TMP->(dbclosearea())
//Endif
//if select("SC6TMP") > 0
//	SC6TMP->(dbclosearea())
//Endif

//if file(_cTmpSC5)
//	ferase(_cTmpSC5)
//	ferase(_cTmpSC5I)
//	ferase(_cTmpSC5F)
//Endif

//if file(_cTmpSC6)
//	ferase(_cTmpSC6)
//	ferase(_cTmpSC6I)
//	ferase(_cTmpSC6F)
//Endif

dbselectarea("SB1")

return nil


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//TFont(): New ( [ cName], [ uPar2], [ nHeight], [ uPar4], [ lBold], [ uPar6], [ uPar7], [ uPar8], [ uPar9], [ lUnderline], [ lItalic] ) --> oObjeto


//MsDialog(): New ( [ nTop], [ nLeft], [ nBottom], [ nRight], [ cCaption], [ uParam6], [ uParam7], [ uParam8], [ uParam9], [ nClrText], [ nClrBack], [ uParam12], [ oWnd], [ lPixel], [ uParam15], [ uParam16], [ uParam17], [ uParam18], [ uParam19] ) --> oObjeto

//Nome			Tipo			Descrição

//nTop			Numérico		Indica a coordenada vertical superior em pixels ou caracteres.
//nLeft			Numérico		Indica a coordenada horizontal esquerda em pixels ou caracteres.
//nBottom		Numérico		Indica a coordenada vertical inferior em pixels ou caracteres.
//nRight		Numérico		Indica a coordenada horizontal direita em pixels ou caracteres.
//cCaption		Caracter		Indica o título da janela.
//uParam6		Caracter		Compatibilidade.
//uParam7		Numérico		Compatibilidade.
//uParam8		Lógico			Compatibilidade.
//uParam9		Qualquer		Compatibilidade.
//nClrText		Numérico		Indica a cor do texto.
//nClrBack		Numérico		Indica a cor de fundo.
//uParam12		Objeto			Compatibilidade.
//oWnd			Objeto			ndica a janela mãe (principal) da janela que será criada. O padrão é a janela principal do programa.
//lPixel		Lógico			Indica se considera as coordenadas passadas em pixels (.T.) ou caracteres (.F.).
//uParam15		Qualquer		Compatibilidade.
//uParam16		Qualquer		Compatibilidade.
//uParam17		Qualquer		Compatibilidade.
//uParam18		Array of Record	Compatibilidade.
//uParam19		Array of Record	Compatibilidade.

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//TGet(): New ( [ nRow], [ nCol], [ bSetGet], [ oWnd], [ nWidth], [ nHeight], [ cPict], [ bValid], [ nClrFore], [ nClrBack], [ oFont], [ uParam12], [ uParam13], [ lPixel], [ uParam15], [ uParam16], [ bWhen], [ uParam18], [ uParam19], [ bChange], [ lReadOnly], [ lPassword], [ uParam23], [ cReadVar], [ uParam25], [ uParam26], [ uParam27], [ lHasButton], [ lNoButton] ) --> oObjeto

// Nome			Tipo			Descrição		Obrigatório		Referência

// nRow 		Numérico 		Indica a coordenada vertical em pixels ou caracteres.
// nCol			Numérico		Indica a coordenada horizontal em pixels ou caracteres.
// bSetGet		Bloco de código	Indica o bloco de código, no formato {|u| if( Pcount( )>0, := u, ) }, que será executado para atualizar a variável (essa variável deve ser do tipo caracter). Desta forma, se a lista for sequencial, o controle atualizará com o conteúdo do item selecionado, se for indexada, será atualizada com o valor do índice do item selecionado.
// oWnd			Objeto			Indica a janela ou controle visual onde o objeto será criado.
// nWidth		Numérico		Indica a largura em pixels do objeto.
// nHeight		Numérico		Indica a altura em pixels do objeto.
// cPict		Caracter		Indica a máscara de formatação, do conteúdo, que será apresentada.
// bValid		Bloco de código	Indica o bloco de código de validação que será executado quando o conteúdo do objeto for modificado. Retorna verdadeiro (.T.), se o conteúdo é válido; caso contrário, falso (.F.).
// nClrFore		Numérico		Indica a cor do texto do objeto.
// nClrBack		Numérico		Indica a cor de fundo do objeto.
// oFont		Objeto			Indica o objeto, do tipo TFont, que será utilizado para definir as características da fonte aplicada na exibição do conteúdo do controle visual.
// uParam12		Lógico			Compatibilidade.
// uParam13		Objeto			Compatibilidade.
// lPixel		Lógico			Indica se considera as coordenadas passadas em pixels (.T.) ou caracteres (.F.).
// uParam15		Caracter		Compatibilidade.
// uParam16		Lógico			Compatibilidade.
// bWhen		Bloco de código	Indica o bloco de código que será executado quando a mudança de foco da entrada de dados, no objeto criado, estiver sendo realizada. Se o retorno for verdadeiro (.T.), o objeto continua habilitado; caso contrário, falso (.F.).
// uParam18		Lógico			Compatibilidade.
// uParam19		Lógico			Compatibilidade.
// bChange		Bloco de código	Indica o bloco de código que será executado quando o estado ou conteúdo do objeto é modificado pela ação sobre o controle visual.
// lReadOnly	Lógico			Indica se o objeto pode ser editado.
// lPassword	Lógico			Indica se, verdadeiro (.T.), o objeto apresentará asterisco (*) para entrada de dados de senha; caso contrário, falso (.F.).
// uParam23		Caracter		F3 - .
// cReadVar		Caracter		Indica o nome da variável, configurada no parâmetro bSetGet, que será manipulada pelo objeto. Além disso, esse parâmetro será o retorno da função ReadVar().
// uParam25		Caracter		Compatibilidade.
// uParam26		Caracter		Compatibilidade.
// uParam27		Lógico			Compatibilidade.
// lHasButton	Lógico			Indica se, verdadeiro (.T.), o uso dos botões padrão, como calendário e calculadora.
// lNoButton	Lógico			Oculta o botão F3 (HasButton).

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//                                                                                                                    1            1          1            1            1            1         1            1
//                   1        2        3            4        5           6          7           8           9         0            1          2            3            4            5         6            7
//TButton(): New ( [ nRow], [ nCol], [ cCaption], [ oWnd], [ bAction], [ nWidth], [ nHeight], [ uParam8], [ oFont], [ uParam10], [ lPixel], [ uParam12], [ uParam13], [ uParam14], [ bWhen], [ uParam16], [ uParam17] ) --> oObjeto
//
// Nome			Tipo			Descrição
//
// nRow			Numérico		Indica a coordenada vertical em pixels ou caracteres.
// nCol			Numérico		Indica a coordenada horizontal em pixels ou caracteres.
// cCaption		Caracter		Indica o título do botão.
// oWnd			Objeto			Indica a janela ou controle visual onde o botão será criado.
// bAction		Bloco de código	Indica o bloco de código que será executado quando clicar, com o botão esquerdo do mouse, sobre o botão.
// nWidth		Numérico		Indica a largura em pixels do botão.
// nHeight		Numérico		Indica a altura em pixels do botão.
// uParam8		Numérico		Compatibilidade.
// oFont		Objeto			Indica o objeto do tipo TFont utilizado para definir as características da fonte aplicada na exibição do conteúdo do controle visual.
// uParam10		Lógico			Compatibilidade.
// lPixel		Lógico			Indica se considera as coordenadas passadas em pixels (.T.) ou caracteres (.F.).
// uParam12		Lógico			Compatibilidade.
// uParam13		Lógico			Compatibilidade.
// uParam14		Lógico			Compatibilidade.
// bWhen		Bloco de código	Indica o bloco de código que será executado quando a mudança de foco da entrada de dados, na janela em que o controle foi criado, estiver sendo efetuada. Observação: O bloco de código retornará verdadeiro (.T.), se o controle permanecer habilitado; caso contrário, retornará falso (.F.).
// uParam16		Bloco de código	Compatibilidade.
// uParam17		Lógico			Compatibilidade.

// Principais commandos
// TButton():New(140,010, 'GoUp()'                           , oDlgFilPro, {|| _oBrowse:GoUp() }            ,40,10,,,,.T.)
// TButton():New(140,060, 'GoDown()'                         , oDlgFilPro, {|| _oBrowse:GoDown() }          ,40,10,,,,.T.)
// TButton():New(140,110, 'GoTop()'                          , oDlgFilPro, {|| _oBrowse:GoTop() }           ,40,10,,,,.T.)
// TButton():New(140,160, 'GoBottom()'                       , oDlgFilPro, {|| _oBrowse:GoBottom() }        ,40,10,,,,.T.)
// TButton():New(140,210, 'nAt (Linha selecionada)'          , oDlgFilPro, {|| Alert (_oBrowse:nAt)}        ,80,10,,,,.T.)
// TButton():New(140,260, 'nRowCount (Nr de linhas visiveis)', oDlgFilPro, {|| Alert(_oBrowse:nRowCount()) },80,10,,,,.T.)
// TButton():New(140,310, 'nLen (Numero total de linhas)'    , oDlgFilPro, {|| Alert(_oBrowse:nLen) }       ,80,10,,,,.T.)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//tDialog(): Activate ( [ uParam1], [ uParam2], [ uParam3], [ lCentered], [ bValid], [ uParam6], [ bInit], [ uParam8], [ uParam9] ) -->

//Nome			Tipo			Descrição

//uParam1		Qualquer		Compatibilidade.
//uParam2		Qualquer		Compatibilidade.
//uParam3		Qualquer		Compatibilidade.
//lCentered		Lógico			Indica se a janela será (.T.) ou não (.F.) centralizada. O padrão é falso (.F.).
//bValid		Bloco de código	Indica se o conteúdo do diálogo é válido. Se o retorno for falso (.F.), o diálogo não será fechado quando a finalização for solicitada.
//uParam6		Qualquer		Compatibilidade.
//bInit			Bloco de código	Indica o bloco de código que será executado quando o diálogo iniciar a exibição.
//uParam8		Qualquer		Compatibilidade.
//uParam9		Qualquer		Compatibilidade

//oLBox1     := TListBox():New( 136,068,,{"a","b","c","d","e","f","g","h"},060,048,,oDlg1,,CLR_BLACK,CLR_WHITE,.T.,,,,"",,,,,,, )
//oCBox1     := TComboBox():New( 048,064,,{"aa","bb","cc","dd","ee","ff","gg","hh","ii",""},072,010,oDlg1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
//GoRMenu1   := TGroup():New( 036,308,088,400,"oRMenu1",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
//oRMenu1    := TRadMenu():New( 040,314,{"1","2","3","4","5","6"},,oDlg1,,,CLR_BLACK,CLR_WHITE,"",,,072,8,,.F.,.F.,.T. )



//_odefwnd := GetWndDefault()
//_oObj    := GetMarkBrow()

//_aSize   := MsAdvSize(.t.,.f.) // Retorna Array com 7 elementos

//ExpA1 -> Dimensões da janela / área de trabalho
//
// 1 -> Linha inicial área trabalho.
// 2 -> Coluna inicial área trabalho.
// 3 -> Linha final área trabalho.
// 4 -> Coluna final área trabalho.
// 5 -> Coluna final dialog (janela).
// 6 -> Linha final dialog (janela).
// 7 -> Linha inicial dialog (janela).



// Para utilização da MarkBrow() é necessário declarar as variáveis cCadastro e aRotina () como Private acima da chamada da função.
//
// aRotina
//
// Vetor com as rotinas que serão executadas. Nele será definido o tipo de operação a ser executada (inclusão, alteração, exclusão, visualização, pesquisa, ...), sua estrutura é composta de 5 (cinco) dimensões:
// [n][1] - Título
// [n][2] - Rotina
// [n][3] - Reservado
// [n][4] - Operação (1 - pesquisa; 2 - visualização; 3 - inclusão; 4 - alteração; 5 - exclusão)
// [n][5] - Acesso relacionado à rotina. Se esta posição não for informada, nenhum acesso será validado.
//
// aCampos
//
// [n][1] - Nome do campo
// [n][2] - Nulo (Nil);
// [n][3] - Título do campo
// [n][4] - Máscara (picture).
//
// Parâmetros:
//
// Nome				Tipo			Descrição
//
//
// 01 - cAlias			Caracter		Alias do arquivo a ser exibido no browse.
// 02 - cCampo			Caracter		Campo do arquivo onde será feito o controle (gravação) da marca.
// 03 - cCpo			Caracter		Campo onde será feita a validação para marcação e exibição do bitmap de status.
// 04 - aCampos			Vetor			Vetor de colunas a serem exibidas no browse
// 05 - lInverte		Lógico			Inverte a marcação.
// 06 - cMarca			Caracter		String a ser gravada no campo especificado para marcação.
// 07 - cCtrlM			Caracter		Função a ser executada caso deseje marcar todos elementos.
// 08 - uPar8			Qualquer		Parâmetro reservado.
// 09 - cExpIni			Caracter		Função que retorna o conteúdo inicial do filtro baseada na chave de índice selecionada.
// 10 - cExpFim			Caracter		Função que retorna o conteúdo final do filtro baseada na chave de índice selecionada.
// 11 - cAval			Caracter		Função a ser executada no duplo clique em um elemento no browse.
// 12 - bParBloco		Bloco de código	Bloco de código a ser executado na inicialização da janela
// 13 - cExprFilTop		Caracter		Expressão de filtro para execução somente em ambiente TOP, a expressão deve ser SQL
// 14 - uPar14			Qualquer		Parâmetro reservado
// 15 - aColors			Vetor			Legenda da Markbrowse
// 16 - uPar16			Qualquer		Parâmetro reservado
//
//
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



//TFolder(): New ( [ nTop], [ nLeft], [ aPrompts], [ aDialogs], [ oWnd], [ nOption], [ nClrFore], [ nClrBack], [ lPixel], [ uParam10], [ nWidth], [ nHeight], [ cMsg], [ uParam14] ) --> oObjeto




//          TCBrowse():New( [ nRow], [ nCol], [ nWidth]     , [ nHeight]   , [ bLine], [ aHeaders], [ aColSizes], [ oWnd], [ cField], [ uValue1], [ uValue2], [ bChange], [ bLDblClick], [ bRClick], [ oFont], [ oCursor], [ nClrFore], [ nClrBack], [ cMsg], [ uParam20], [ cAlias], [ lPixel], [ bWhen], [ uParam24], [ bValid], [ lHScroll], [ lVScroll] )
//                      1        2        3          4           5         6            7             8        9          10          11          12          13             14          15        16          17           18           19       20           21         22         23        24           25         26           27
//
//      Nome			Tipo				Descrição
//
// 01 - nRow			Numérico			Indica a coordenada vertical.
// 02 - nCol			Numérico			Indica a coordenada horizontal.
// 03 - nWidth			Numérico			Indica a largura em pixels do objeto.
// 04 - nHeight			Numérico			Indica a altura em pixels do objeto.
// 05 - bLine			Bloco de código		Indica o bloco de código da lista de campos. Observação: Esse parâmetro é utilizado somente quando o browse trabalha com array.
// 06 - aHeaders		Array of Record		Indica o título dos campos no cabeçalho.
// 07 - aColSizes		Array of Record		Indica a largura das colunas.
// 08 - oWnd			Objeto				Indica o controle visual onde o divisor será criado.
// 09 - cField			Caracter			Indica os campos necessários para o filtro.
// 10 - uValue1			Qualquer			Indica o início do intervalo para o filtro.
// 11 - uValue2			Qualquer			Indica o fim do intervalo para o filtro.
// 12 - bChange			Bloco de código		Indica o bloco de código que será executado ao mudar de linha.
// 13 - bLDblClick		Bloco de código		Indica o bloco de código que será executado quando clicar duas vezes, com o botão esquerdo do mouse, sobre o objeto.
// 14 - bRClick			Bloco de código		Indica o bloco de código que será executado quando clicar, com o botão direito do mouse, sobre o objeto.
// 15 - oFont			Objeto				Indica o objeto do tipo TFont utilizado para definir as características da fonte aplicada na exibição do conteúdo do controle visual.
// 16 - oCursor			Objeto				Indica o tipo de ponteiro do mouse.
// 17 - nClrFore		Numérico			Indica a cor do texto da janela.
// 18 - nClrBack		Numérico			Indica a cor de fundo da janela.
// 19 - cMsg			Caracter			Indica a mensagem ao posicionar o ponteiro do mouse sobre o objeto.
// 20 - uParam20		Lógico				Compatibilidade.
// 21 - cAlias			Caracter			Indica se o objeto é utilizado com array (opcional) ou tabela (obrigatório).
// 22 - lPixel			Lógico				Indica se considera as coordenadas passadas em pixels (.T.) ou caracteres (.F.).
// 23 - bWhen			Bloco de código		Indica o bloco de código que será executado quando a mudança de foco da entrada de dados, na janela em que o controle foi criado, estiver sendo efetuada. Observação: O bloco de código retornará verdadeiro (.T.) se o controle permanecer habilitado; caso contrário, retornará falso (.F.).
// 24 - uParam24		Lógico				Compatibilidade.
// 25 - bValid			Bloco de código		Indica o bloco de código de validação que será executado quando o conteúdo do objeto for modificado. Retorna verdadeiro (.T.), se o conteúdo é válido; caso contrário, falso (.F.).
// 26 - lHScroll		Lógico				Indica se habilita(.T.)/desabilita(.F.) a barra de rolagem horizontal.
// 27 - lVScroll		Lógico				Indica se habilita(.T.)/desabilita(.F.) a barra de rolagem vertical.

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
STATIC FUNCTION MarkPed( _Pedido , _Modo, _Registro )
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
local _cOk


if SC5TMP->C5_OK == "SS"
	_cOk := "NN"
Else
	_cOk := "SS"
Endif

dbselectarea("SC5TMP")

if _Modo == 1
	
	if empty(SC5TMP->C5_NUM)
		if reclock("SC5TMP",.F.)
			
			SC5TMP->C5_OK := _cOk
			
			msunlock()
		Endif
		
		dbcommit()
	Endif
	
Else
	
	Dbgotop()
	
	Do While ! eof()
		
		if empty(SC5TMP->C5_NUM)
			if reclock("SC5TMP",.F.)
				
				SC5TMP->C5_OK := _cOk
				
				msunlock()
			Endif
		Endif
		
		dbskip()
		
	Enddo
	
	dbcommit()
	
Endif

Dbgoto(_registro)
_oBrwRegras:refresh()
_oBrwRegras:setfocus()

return nil

////////////////////////////////////////
////////////////////////////////////////
static function FILSC6( _Pedido , _recno)
////////////////////////////////////////
////////////////////////////////////////
dbselectarea("SC6TMP")
SET FILTER TO

_cFILSC6 := " ( C6_PEDSAIB == SC5TMP->C5_PEDSAIB ) "
SET FILTER TO &_cFILSC6
dbgotop()

//_oBrwItem:gotop()
_oBrwItem:resetlen()
//_oBrwItem:refresh()

dbselectarea("SC5TMP")
dbgoto(_recno)

return nil





///////////////////////////
STATIC FUNCTION LERSAIB()
//////////////////////////
local cPerg := "GDP011"

CriaPerg(cPerg)

_dPrevfat := dDataBase

if dow(_dPrevfat) == 6
	_dPrevfat += 3
Else
	_dPrevfat += 1
Endif

dbSelectArea("SX1")
dbSetOrder(1)

If MsSeek(padr(cPerg,10)+"03")
	//Acerto o parametro com a database
	RecLock("SX1",.F.)
	Replace x1_cnt01		With "'"+DTOC(_dPrevfat)+"'"
	MsUnlock()
	
Endif

updsaib()

if pergunte(cPerg,.t.)
	
	_dPrevfat := mv_par03
	
	// CABECALHO DE PEDIDOS
	
	// CD_PEDIDO_PALM
	// CD_CLIENTE
	// CD_PEDIDO_CLIENTE
	// DT_EMISSAO
	// VR_PEDIDO
	// CD_ORG_VENDA
	// CD_COND_PGTO
	// CD_TIPO_PEDIDO
	// DT_ENTREGA
	// CD_MEIO_PGTO
	// CD_ST_PEDIDO
	// ID_PRIORIDADE
	// CD_VENDEDOR
	// DT_EXPORTACAO
	// ID_TIPO_FRETE
	// CD_TRANSPORTADORA
	// DS_OBSERVACAO
	// NM_RZ_SOCIAL_ENTR
	// DS_ENDERECO_ENTR
	// NM_BAIRRO_ENTR
	// NM_CIDADE_ENTR
	// NM_ESTADO_ENTR
	// NR_CEP_ENTR
	// NR_FONE_ENTR
	// NR_CNPJ_CPF_ENTR
	// NR_CGF_ENTR
	// CD_PEDIDO_PALM_PAI
	// ASSINATURA
	// NM_RESPONSAVEL
	// ID_ORCAMENTO
	// CD_JUSTIFICATIVA_ROTA
	// NR_PARCELAS
	// CD_TAB_PRECO
	// DS_OBS_FATURAMENTO
	// CD_FRETE
	// ID_AUTORIZADO
	// DS_TAB_PRECO
	// CD_ROTA
	// ORIGEM_SAIB
	// DS_OBS_NOTA_FISCAL
	// DS_TIPO_FRETE
	// MOTIVO_NAO_COMPRA
	// DEZ_MAIS_SEM_COMPRA
	// MOTIVADO_SEM_COMPRA_A_30_DIAS
	// DESVIO_DA_ROTA
	// CLIENTE_SEM_COORDENADAS
	// TIPO_ATENDIMENTO
	
	// ITENS DE PEDIDOS
	
	// CD_PEDIDO_PALM
	// NR_ITEM_PEDIDO
	// CD_PRODUTO
	// QT_ITEM
	// VR_ITEM
	// NR_CARACTERISTICA
	// NR_PRAZO_MEDIO
	// QT_ITEM_SOLICITADA
	// DS_OBS_FATURAMENTO
	// PC_DESCONTO
	// CD_UNIDADE
	// CD_MOTIVO
	// ID_AUTORIZADO
	// CD_AUTORIZACAO
	// CD_RESPONSAVEL_AUTORIZACAO
	// CD_VENDEDOR
	// DT_EMISSAO
	
	
	//////////////////////////////////////////////////
	///////////// Inicializar Variaveis //////////////
	//////////////////////////////////////////////////
	
	//CD_PEDIDO, 50      - pedido no protheus
	//CD_ST_PEDIDO  ,50  - status da importacao no protheus
	
	_lNovaqry := .t.
	
	if _lNovaQry
		
		dbselectarea("SC6TMP")
		zap
		
		dbselectarea("SC5TMP")
		zap
		
		_cQry := "SELECT "
		_cQry += "PEDIDO.CD_PEDIDO_PALM AS PEDSAIB, "
		_cQry += "ITENS.NR_ITEM_PEDIDO AS ITMSAIB, "
		_cQry += "CONVERT(NVARCHAR(10), PEDIDO.DT_EMISSAO,103) AS DTEMISSAO , "
		_cQry += "CONVERT(NVARCHAR(10), PEDIDO.DT_ENTREGA,103) AS DTENTREGA ,"
		_cQry += "PEDIDO.CD_TAB_PRECO  AS TABPRECO,"
		_cQry += "PEDIDO.DS_OBSERVACAO AS OBSFAT, "
		_cQry += "ITENS.PC_DESCONTO AS DESCONTO,"
		_cQry += "PEDIDO.*,"
		_cQry += "ITENS.* "
		
		if sm0->m0_codigo == '04'
			_cQry += "FROM SAIB.dbo.PEDIDO_RB PEDIDO, SAIB.dbo.ITEM_PEDIDO_RB ITENS "
		Else
			_cQry += "FROM SAIB_Lugpet.dbo.PEDIDO_RB PEDIDO, SAIB_Lugpet.dbo.ITEM_PEDIDO_RB ITENS "
		Endif
		
		_cQry += "WHERE PEDIDO.MOTIVO_NAO_COMPRA IS NULL "
		_cQry += "AND PEDIDO.CD_PEDIDO IS NULL "
		_cQry += "AND ITENS.CD_PEDIDO_PALM = PEDIDO.CD_PEDIDO_PALM "
		_cQry += "AND ( CONVERT(NVARCHAR(10), PEDIDO.DT_ENTREGA,112) BETWEEN '"+dtos(mv_par01-7)+"' AND '"+dtos(mv_par02+7)+"' ) "
		_cQry += "ORDER BY PEDIDO.CD_PEDIDO_PALM , ITENS.NR_ITEM_PEDIDO   "
		
		//ALERT(_cQry)
		
		if select("TMPPED") > 0
			TMPPED->(dbclosearea())
		Endif
		
		//////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cQry), "TMPPED", .F., .T.)
		//////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////
		
		dbselectarea("TMPPED")
		dbgotop()
		
		_t := 00
		
		Do While ! eof()
			
			cC5PedSaib := padr(alltrim(PEDSAIB),50)
			
			if cC5PedSaib == padr('6491833',50)
				_t ++
			Endif
			
			cC5VlrSaib := val(alltrim(VR_PEDIDO))
			
			dC5Emissao := ctod(DTEMISSAO)
			dC5Saida   := ctod(DTENTREGA)
			
			if empty(dC5Saida)
				dC5Saida   := dC5Emissao
			Endif
			
			if ! empty(dC5Emissao)
				if dC5Saida == dC5Emissao
					if dow(dC5Emissao) == 6
						dC5Saida += 3
					Else
						dC5Saida += 1
					Endif
				Endif
				
			Endif
			
			if dC5Saida < _dPrevfat
				dC5Saida := _dPrevfat
			Endif
			
			if cC5VlrSaib > 0 .and. dC5Saida >= mv_par01 .and. dC5Saida <= mv_par02
				
				dbselectarea("SC5")
				dbsetorder(6)
				dbgotop()
				
				if ! dbseek(xfilial("SC5")+cC5PedSaib , .f.)
					
					dbselectarea("TMPPED")
					
					cC5Filial  := xFilial("SC5")
					cC5Num     := space(6)
					cC5Cliente := LEFT(CD_CLIENTE,6)
					
					if !empty(substr(CD_CLIENTE,7,2))
						cC5Lojacli := substr(CD_CLIENTE,7,2)
					Else
						cC5Lojacli := '01'
					Endif
					
					cC5Client  := cC5Cliente
					cC5Lojaent := cC5Lojacli
					
					cC5Descri  := Posicione("SA1",1,xFilial("SA1")+cC5Cliente+cC5Lojacli,"A1_NOME")
					cC5Tipo    := Posicione("SA1",1,xFilial("SA1")+cC5Cliente+cC5Lojacli,"A1_PESSOA")//"N"
					
					cC5Tipocli := Posicione("SA1",1,xFilial("SA1")+cC5Cliente+cC5Lojacli,"A1_TIPO")
					
					if sm0->m0_codigo == '05'
						cC5Tipocli := "R"
					Endif
					
					
					cC5Pedcli  := space(6)
					cC5Condpag := ALLTRIM(CD_COND_PGTO)
					cC5Formpag := ALLTRIM(CD_MEIO_PGTO)
					cC5Tpfrete := "C"
					cC5Transp  := space(6)
					cC5Veiculo := space(8)
					cC5Placa   := space(8)
					cC5Ufplaca := space(2)
					nC5Pesol   := 0
					nC5Pbruto  := 0
					nC5Pespal  := 0
					
					cC5Vend1   := ALLTRIM(CD_VENDEDOR)
					cC5Vendnom := cC5Vend1+"-"+Posicione("SA3",1,xFilial("SA3")+cC5Vend1,"A3_NOME")
					
					nC5Comis1  := 0
					cC5Vend2   := space(6)
					nC5Comis2  := 0
					cC5Vend3   := space(6)
					nC5Comis3  := 0
					cC5Vend4   := space(6)
					nC5Comis4  := 0
					cC5Vend5   := space(6)
					nC5Comis5  := 0
					
					cC5Menpad  := space(3)
					cC5Mens1   := space(65)
					cC5Mens2   := space(65)
					cC5Mens3   := space(65)
					cC5Mens4   := space(65)
					cC5Mens5   := space(65)
					cC5Mens6   := space(65)
					cC5Mens7   := space(65)
					cC5Mennota := cC5Vendnom //space(60)
					
					cC5Obsfat  := OBSFAT
					
					nC5Volume1 := 0
					cC5Especi1 := space(10)
					cC5Marca   := 'DUELO'
					cC5Tiplib  := '1'
					cC5Tabela  := alltrim(tabpreco)
					nC5Desc1   := 0
					nC5Desc2   := 0
					nC5Desc3   := 0
					nC5Desc4   := 0
					cC5Banco   := space(3)
					nC5Descfi  := 0
					cC5Cotacao := space(6)
					nC5Parc1   := 0
					dC5Data1   := ctod('')
					nC5Parc2   := 0
					dC5Data2   := ctod('')
					nC5Parc3   := 0
					dC5Data3   := ctod('')
					nC5Parc4   := 0
					dC5Data4   := ctod('')
					nC5Frete   := 0
					nC5Despesa := 0
					nC5Fretaut := 0
					cC5Reajust := space(3)
					nC5Moeda   := 1
					nC5Seguro  := 0
					nC5Reimp   := 0
					cC5Redesp  := space(6)
					nC5Volume2 := 0
					nC5Volume3 := 0
					nC5Volume4 := 0
					cC5Especi2 := space(10)
					cC5Especi3 := space(10)
					cC5Especi4 := space(10)
					cC5Inciss  := space(1)
					cC5Liberok := space(1)
					cC5Ok      := space(2)
					nC5Acrsfin := 0
					cC5Nota    := space(9)
					cC5Serie   := space(3)
					cC5Venda   := space(2)
					cC5Os      := space(6)
					cC5Kitrep  := space(6)
					nC5Descont := 0
					nC5Txmoeda := 1
					cC5Pedexp  := space(20)
					cC5Tpcarga := "1"
					cC5Prepemb := space(1)
					nC5Pdescab := 0
					cC5Blq     := space(1)
					cC5Forniss := space(6)
					cC5Contra  := space(10)
					cC5Reciss  := space(1)
					cC5Recfaut := space(1)
					nC5Vlrfrt  := 0
					cC5Mdcontr := space(15)
					cC5Mdnumed := space(6)
					cC5Mdplani := space(6)
					cC5Solfre  := space(2)
					cC5Orcres  := space(6)
					cC5Munpres := space(7)
					cC5Descmun := space(30)
					cC5Nfsubst := space(9)
					cC5Sersubs := space(3)
					dC5Dtlanc  := ctod('')
					cC5Gerawms := '1'
					dC5Fecent  := ctod('')
					cC5Solopc  := '1'
					dC5Sugent  := ctod('')
					cC5Coded   := space(15)
					cC5Numpr   := space(15)
					cC5Obra    := space(10)
					cC5Estpres := space(2)
					cC5Origem  := "SAIB"
					cC5Importa := space(1)
					
					//////////////////////////////////////////////////
					///////////// Gravar/Atualizar Dados /////////////
					//////////////////////////////////////////////////
					
					DbSelectArea('SC5TMP')
					DbSetOrder(1) // verificar se o indice utilizado esta correto
					Dbgotop()
					
					_lInclui := .t.
					
					DbSeek(cC5PedSaib,.f.)
					
					If !Eof()
						_lInclui := .f.
					Endif
					
					If reclock('SC5TMP',_lInclui) // .T. - Inclui / .F. - Altera
						
						SC5TMP->C5_FILIAL  := cC5Filial
						SC5TMP->C5_NUM     := cC5Num
						SC5TMP->C5_PEDSAIB := cC5PedSaib
						SC5TMP->C5_VLRSAIB := cC5VlrSaib
						SC5TMP->C5_TIPO    := cC5Tipo
						SC5TMP->C5_CLIENTE := cC5Cliente
						SC5TMP->C5_LOJACLI := cC5Lojacli
						SC5TMP->C5_CLIENT  := cC5Client
						SC5TMP->C5_LOJAENT := cC5Lojaent
						SC5TMP->C5_DESCRI  := cC5Descri
						SC5TMP->C5_TIPOCLI := cC5Tipocli
						SC5TMP->C5_PEDCLI  := cC5Pedcli
						SC5TMP->C5_CONDPAG := cC5Condpag
						SC5TMP->C5_FORMPAG := cC5Formpag
						SC5TMP->C5_TPFRETE := cC5Tpfrete
						SC5TMP->C5_TRANSP  := cC5Transp
						SC5TMP->C5_VEICULO := cC5Veiculo
						SC5TMP->C5_PLACA   := cC5Placa
						SC5TMP->C5_UFPLACA := cC5Ufplaca
						SC5TMP->C5_PESOL   := nC5Pesol
						SC5TMP->C5_PBRUTO  := nC5Pbruto
						SC5TMP->C5_PESPAL  := nC5Pespal
						SC5TMP->C5_VEND1   := cC5Vend1
						SC5TMP->C5_COMIS1  := nC5Comis1
						SC5TMP->C5_VEND2   := cC5Vend2
						SC5TMP->C5_COMIS2  := nC5Comis2
						SC5TMP->C5_VEND3   := cC5Vend3
						SC5TMP->C5_COMIS3  := nC5Comis3
						SC5TMP->C5_VEND4   := cC5Vend4
						SC5TMP->C5_COMIS4  := nC5Comis4
						SC5TMP->C5_VEND5   := cC5Vend5
						SC5TMP->C5_COMIS5  := nC5Comis5
						SC5TMP->C5_MENPAD  := cC5Menpad
						SC5TMP->C5_MENS1   := cC5Mens1
						SC5TMP->C5_MENS2   := cC5Mens2
						SC5TMP->C5_MENS3   := cC5Mens3
						SC5TMP->C5_MENS4   := cC5Mens4
						SC5TMP->C5_MENS5   := cC5Mens5
						SC5TMP->C5_MENS6   := cC5Mens6
						SC5TMP->C5_MENS7   := cC5Mens7
						SC5TMP->C5_MENNOTA := cC5Mennota
						SC5TMP->C5_OBSFAT  := cC5Obsfat
						
						SC5TMP->C5_EMISSAO := dC5Emissao
						SC5TMP->C5_SAIDA   := dC5Saida
						SC5TMP->C5_VOLUME1 := nC5Volume1
						SC5TMP->C5_ESPECI1 := cC5Especi1
						SC5TMP->C5_MARCA   := cC5Marca
						SC5TMP->C5_TIPLIB  := cC5Tiplib
						SC5TMP->C5_TABELA  := cC5Tabela
						SC5TMP->C5_DESC1   := nC5Desc1
						SC5TMP->C5_DESC2   := nC5Desc2
						SC5TMP->C5_DESC3   := nC5Desc3
						SC5TMP->C5_DESC4   := nC5Desc4
						SC5TMP->C5_BANCO   := cC5Banco
						SC5TMP->C5_DESCFI  := nC5Descfi
						SC5TMP->C5_COTACAO := cC5Cotacao
						SC5TMP->C5_PARC1   := nC5Parc1
						SC5TMP->C5_DATA1   := dC5Data1
						SC5TMP->C5_PARC2   := nC5Parc2
						SC5TMP->C5_DATA2   := dC5Data2
						SC5TMP->C5_PARC3   := nC5Parc3
						SC5TMP->C5_DATA3   := dC5Data3
						SC5TMP->C5_PARC4   := nC5Parc4
						SC5TMP->C5_DATA4   := dC5Data4
						SC5TMP->C5_FRETE   := nC5Frete
						SC5TMP->C5_DESPESA := nC5Despesa
						SC5TMP->C5_FRETAUT := nC5Fretaut
						SC5TMP->C5_REAJUST := cC5Reajust
						SC5TMP->C5_MOEDA   := nC5Moeda
						SC5TMP->C5_SEGURO  := nC5Seguro
						SC5TMP->C5_REIMP   := nC5Reimp
						SC5TMP->C5_REDESP  := cC5Redesp
						SC5TMP->C5_VOLUME2 := nC5Volume2
						SC5TMP->C5_VOLUME3 := nC5Volume3
						SC5TMP->C5_VOLUME4 := nC5Volume4
						SC5TMP->C5_ESPECI2 := cC5Especi2
						SC5TMP->C5_ESPECI3 := cC5Especi3
						SC5TMP->C5_ESPECI4 := cC5Especi4
						SC5TMP->C5_INCISS  := cC5Inciss
						SC5TMP->C5_LIBEROK := cC5Liberok
						SC5TMP->C5_OK      := cC5Ok
						SC5TMP->C5_ACRSFIN := nC5Acrsfin
						SC5TMP->C5_NOTA    := cC5Nota
						SC5TMP->C5_SERIE   := cC5Serie
						SC5TMP->C5_VENDA   := cC5Venda
						SC5TMP->C5_OS      := cC5Os
						SC5TMP->C5_KITREP  := cC5Kitrep
						SC5TMP->C5_DESCONT := nC5Descont
						SC5TMP->C5_TXMOEDA := nC5Txmoeda
						SC5TMP->C5_PEDEXP  := cC5Pedexp
						SC5TMP->C5_TPCARGA := cC5Tpcarga
						SC5TMP->C5_PREPEMB := cC5Prepemb
						SC5TMP->C5_PDESCAB := nC5Pdescab
						SC5TMP->C5_BLQ     := cC5Blq
						SC5TMP->C5_FORNISS := cC5Forniss
						SC5TMP->C5_CONTRA  := cC5Contra
						SC5TMP->C5_RECISS  := cC5Reciss
						SC5TMP->C5_RECFAUT := cC5Recfaut
						SC5TMP->C5_VLR_FRT := nC5Vlrfrt
						SC5TMP->C5_MDCONTR := cC5Mdcontr
						SC5TMP->C5_MDNUMED := cC5Mdnumed
						SC5TMP->C5_MDPLANI := cC5Mdplani
						SC5TMP->C5_SOLFRE  := cC5Solfre
						SC5TMP->C5_ORCRES  := cC5Orcres
						SC5TMP->C5_MUNPRES := cC5Munpres
						SC5TMP->C5_DESCMUN := cC5Descmun
						SC5TMP->C5_NFSUBST := cC5Nfsubst
						SC5TMP->C5_SERSUBS := cC5Sersubs
						SC5TMP->C5_DTLANC  := dC5Dtlanc
						SC5TMP->C5_GERAWMS := cC5Gerawms
						SC5TMP->C5_FECENT  := dC5Fecent
						SC5TMP->C5_SOLOPC  := cC5Solopc
						SC5TMP->C5_SUGENT  := dC5Sugent
						SC5TMP->C5_CODED   := cC5Coded
						SC5TMP->C5_NUMPR   := cC5Numpr
						SC5TMP->C5_OBRA    := cC5Obra
						SC5TMP->C5_ESTPRES := cC5Estpres
						SC5TMP->C5_ORIGEM  := cC5Origem
						SC5TMP->C5_IMPORTA := cC5Importa
						
						msunlock()
						dbcommit()
						
						dbselectarea("TMPPED")
						
						Do While ! eof() .and. padr(alltrim(PEDSAIB),50) == cC5PedSaib
							
							cC6Pedsaib := cC5PedSaib
							
							nC6Prcbrt  := val(ALLTRIM(VR_ITEM))
							nC6PerDes  := val(ALLTRIM(DESCONTO))/100
							nC6Prcfin  := nC6Prcbrt-(nC6Prcbrt*nC6PerDes)
							
							if nC6Prcfin > 0
								
								cC6Filial  := xfilial('SC6')
								cC6Itmsaib := padl(alltrim(ITMSAIB),03,'0')
								cC6Num     := space(6)
								
								cC6Item    := padl(alltrim(ITMSAIB),02,'0')
								cC6Produto := padr(padl(alltrim(CD_PRODUTO),07,'0'),30)
								
								cC6Descri  := Posicione("SB1",1,xFilial("SB1")+cC6Produto ,"B1_DESC")
								cC6Um      := Posicione("SB1",1,xFilial("SB1")+cC6Produto ,"B1_UM")
								
								cC6Cli     := SC5TMP->C5_CLIENTE
								cC6Loja    := SC5TMP->C5_LOJACLI
								
								nC6Qtdven  := val(ALLTRIM(QT_ITEM))
								
								nC6Prcven  := nC6Prcfin // u_gdg001(cC6Produto,nC6Prcfin,cC6Cli,cC6Loja)
								
								nC6Valor   := ROUND(nC6Qtdven*nC6Prcven,2)
								
								cC6Lotenew := space(10)
								nC6Qtdlib  := 0
								cC6Segum   := space(2)
								
								cC6Tes     := Posicione("SB1",1,xFilial("SB1")+cC6Produto ,"B1_TS")
								
								_cOrigem   := space(1)
								_cSitTrib  := space(2)
								
								if !empty(cC6Tes)
									
									_cOrigem := substr(Posicione("SB1",1,xFilial("SB1")+cC6Produto ,"B1_ORIGEM"),1,1)
									
									if empty(_cOrigem)
										_cOrigem := "0"
									Endif
									
									_cSitTrib := Posicione("SF4",1,xFilial("SF4")+cC6Tes ,"F4_SITTRIB")
									
									if empty(_cSitTrib)
										_cSitTrib := "00"
									Endif
									
									
								Endif
								
								cC6Cf      := Posicione("SF4",1,xFilial("SF4")+cC6Tes ,"F4_CF")
								cC6Clasfis := _cOrigem+_cSitTrib
								
								nC6Qtdemp  := 0
								nC6Qtdent  := 0
								nC6Unsven  := 0
								cC6Local   := Posicione("SB1",1,xFilial("SB1")+cC6Produto ,"B1_LOCPAD")
								dC6Entreg  := dDataBase
								cC6La      := space(8)
								
								nC6Descont := 0
								nC6Valdesc := 0
								dC6Datfat  := ddatabase
								cC6Nota    := space(9)
								cC6Serie   := space(3)
								nC6Comis1  := 0
								nC6Comis2  := 0
								nC6Comis3  := 0
								nC6Comis4  := 0
								nC6Comis5  := 0
								cC6Pedcli  := space(9)
								nC6Prunit  := nC6Prcven
								cC6Bloquei := space(2)
								cC6Geroupv := space(1)
								cC6Reserva := space(6)
								cC6Nfori   := space(9)
								cC6Op      := space(2)
								cC6Ok      := space(2)
								nC6Ipidev  := 0
								cC6Identb6 := space(6)
								cC6Blq     := space(2)
								cC6Seriori := space(3)
								cC6Itemori := space(4)
								cC6Grade   := space(1)
								cC6Itemgrd := space(3)
								cC6Lotectl := space(10)
								cC6Numlote := space(6)
								nC6Picmret := 0
								cC6Numorc  := space(8)
								cC6Codiss  := space(9)
								cC6Opc     := space(80)
								cC6Localiz := space(15)
								cC6Numseri := space(20)
								cC6Numop   := space(6)
								cC6Itemop  := space(2)
								dC6Dtvalid := Ctod("")
								cC6Chassi  := space(17)
								nC6Qtdrese := 0
								cC6Numos   := space(10)
								cC6Numosfa := space(10)
								cC6Codfab  := space(6)
								cC6Lojafa  := space(2)
								cC6Tpop    := 'F'
								nC6Qtdent2 := 0
								cC6Revisao := space(3)
								nC6Qtdlib2 := 0
								cC6Servic  := space(3)
								cC6Endpad  := space(15)
								cC6Contrt  := space(15)
								cC6Tpcontr := space(1)
								cC6Itcontr := space(2)
								cC6Projpms := space(10)
								nC6Qtdemp2 := 0
								cC6Taskpms := space(12)
								cC6Licita  := space(6)
								cC6Contrat := space(6)
								cC6Itemcon := space(2)
								cC6Tpestr  := space(6)
								cC6Edtpms  := space(12)
								cC6Trt     := space(3)
								cC6Projet  := space(6)
								cC6Itproj  := space(2)
								mC6Mopc    := space(10)
								nC6Potenci := 0
								cC6Regwms  := space(1)
								nC6Abatiss := 0
								nC6Abatmat := 0
								cC6Numsc   := space(6)
								cC6Itemsc  := space(4)
								cC6Numcp   := space(6)
								nC6Abscins := 0
								nC6Funrura := 0
								nC6Fetab   := 0
								cC6Codrom  := space(6)
								cC6Pvcomop := space(1)
								dC6Sugentr := dDataBase
								cC6Itemed  := space(3)
								cC6Tpdeduz := space(1)
								cC6Motded  := space(1)
								cC6Forded  := space(6)
								cC6Lojded  := space(2)
								cC6Serded  := space(3)
								cC6Nfded   := space(9)
								nC6Vlnfd   := 0
								nC6Pcded   := 0
								
								nC6Vlded   := ROUND(nC6Qtdven*nC6PrcFin,2) //0
								
								cC6Pedcom  := space(6)
								cC6Itpc    := space(4)
								cC6Filped  := space(2)
								nC6Abatins := 0
								cC6Turno   := space(1)
								cC6Codlan  := space(6)
								cC6Program := space(10)
								cC6Rateio  := "2"
								cC6Codinf  := space(6)
								cC6Importa := space(1)
								
								
								//////////////////////////////////////////////////
								///////////// Gravar/Atualizar Dados /////////////
								//////////////////////////////////////////////////
								
								DbSelectArea('SC6TMP')
								DbSetOrder(1) // verificar se o indice utilizado esta correto
								Dbgotop()
								
								_lInclui := .t.
								
								DbSeek(cC6Pedsaib+cC6Itmsaib,.f.)
								
								If !Eof()
									_lInclui := .f.
								Endif
								
								If reclock('SC6TMP',_lInclui) // .T. - Inclui / .F. - Altera
									
									SC6TMP->C6_FILIAL  := cC6Filial
									SC6TMP->C6_ITEM    := cC6Item
									SC6TMP->C6_PRODUTO := cC6Produto
									SC6TMP->C6_DESCRI  := cC6Descri
									SC6TMP->C6_UM      := cC6Um
									SC6TMP->C6_QTDVEN  := nC6Qtdven
									SC6TMP->C6_PRCFIN  := nC6Prcfin
									SC6TMP->C6_PRCVEN  := nC6Prcven
									SC6TMP->C6_VALOR   := nC6Valor
									SC6TMP->C6_LOTENEW := cC6Lotenew
									SC6TMP->C6_QTDLIB  := nC6Qtdlib
									SC6TMP->C6_SEGUM   := cC6Segum
									SC6TMP->C6_TES     := cC6Tes
									SC6TMP->C6_QTDEMP  := nC6Qtdemp
									SC6TMP->C6_QTDENT  := nC6Qtdent
									SC6TMP->C6_CF      := cC6Cf
									SC6TMP->C6_UNSVEN  := nC6Unsven
									SC6TMP->C6_LOCAL   := cC6Local
									SC6TMP->C6_ENTREG  := dC6Entreg
									SC6TMP->C6_LA      := cC6La
									SC6TMP->C6_CLI     := cC6Cli
									SC6TMP->C6_DESCONT := nC6Descont
									SC6TMP->C6_VALDESC := nC6Valdesc
									SC6TMP->C6_DATFAT  := dC6Datfat
									SC6TMP->C6_LOJA    := cC6Loja
									SC6TMP->C6_NOTA    := cC6Nota
									SC6TMP->C6_SERIE   := cC6Serie
									SC6TMP->C6_NUM     := cC6Num
									SC6TMP->C6_COMIS1  := nC6Comis1
									SC6TMP->C6_COMIS2  := nC6Comis2
									SC6TMP->C6_COMIS3  := nC6Comis3
									SC6TMP->C6_COMIS4  := nC6Comis4
									SC6TMP->C6_COMIS5  := nC6Comis5
									SC6TMP->C6_PEDCLI  := cC6Pedcli
									SC6TMP->C6_PRUNIT  := nC6Prunit
									SC6TMP->C6_BLOQUEI := cC6Bloquei
									SC6TMP->C6_GEROUPV := cC6Geroupv
									SC6TMP->C6_RESERVA := cC6Reserva
									SC6TMP->C6_NFORI   := cC6Nfori
									SC6TMP->C6_OP      := cC6Op
									SC6TMP->C6_OK      := cC6Ok
									SC6TMP->C6_IPIDEV  := nC6Ipidev
									SC6TMP->C6_IDENTB6 := cC6Identb6
									SC6TMP->C6_BLQ     := cC6Blq
									SC6TMP->C6_SERIORI := cC6Seriori
									SC6TMP->C6_ITEMORI := cC6Itemori
									SC6TMP->C6_GRADE   := cC6Grade
									SC6TMP->C6_ITEMGRD := cC6Itemgrd
									SC6TMP->C6_LOTECTL := cC6Lotectl
									SC6TMP->C6_NUMLOTE := cC6Numlote
									SC6TMP->C6_PICMRET := nC6Picmret
									SC6TMP->C6_NUMORC  := cC6Numorc
									SC6TMP->C6_CODISS  := cC6Codiss
									SC6TMP->C6_OPC     := cC6Opc
									SC6TMP->C6_LOCALIZ := cC6Localiz
									SC6TMP->C6_NUMSERI := cC6Numseri
									SC6TMP->C6_NUMOP   := cC6Numop
									SC6TMP->C6_ITEMOP  := cC6Itemop
									SC6TMP->C6_CLASFIS := cC6Clasfis
									SC6TMP->C6_DTVALID := dC6Dtvalid
									SC6TMP->C6_CHASSI  := cC6Chassi
									SC6TMP->C6_QTDRESE := nC6Qtdrese
									SC6TMP->C6_NUMOS   := cC6Numos
									SC6TMP->C6_NUMOSFA := cC6Numosfa
									SC6TMP->C6_CODFAB  := cC6Codfab
									SC6TMP->C6_LOJAFA  := cC6Lojafa
									SC6TMP->C6_TPOP    := cC6Tpop
									SC6TMP->C6_QTDENT2 := nC6Qtdent2
									SC6TMP->C6_REVISAO := cC6Revisao
									SC6TMP->C6_QTDLIB2 := nC6Qtdlib2
									SC6TMP->C6_SERVIC  := cC6Servic
									SC6TMP->C6_ENDPAD  := cC6Endpad
									SC6TMP->C6_CONTRT  := cC6Contrt
									SC6TMP->C6_TPCONTR := cC6Tpcontr
									SC6TMP->C6_ITCONTR := cC6Itcontr
									SC6TMP->C6_PROJPMS := cC6Projpms
									SC6TMP->C6_QTDEMP2 := nC6Qtdemp2
									SC6TMP->C6_TASKPMS := cC6Taskpms
									SC6TMP->C6_LICITA  := cC6Licita
									SC6TMP->C6_CONTRAT := cC6Contrat
									SC6TMP->C6_ITEMCON := cC6Itemcon
									SC6TMP->C6_TPESTR  := cC6Tpestr
									SC6TMP->C6_EDTPMS  := cC6Edtpms
									SC6TMP->C6_TRT     := cC6Trt
									SC6TMP->C6_PROJET  := cC6Projet
									SC6TMP->C6_ITPROJ  := cC6Itproj
									SC6TMP->C6_MOPC    := mC6Mopc
									SC6TMP->C6_POTENCI := nC6Potenci
									SC6TMP->C6_REGWMS  := cC6Regwms
									SC6TMP->C6_ABATISS := nC6Abatiss
									SC6TMP->C6_ABATMAT := nC6Abatmat
									SC6TMP->C6_NUMSC   := cC6Numsc
									SC6TMP->C6_ITEMSC  := cC6Itemsc
									SC6TMP->C6_NUMCP   := cC6Numcp
									SC6TMP->C6_ABSCINS := nC6Abscins
									SC6TMP->C6_FUNRURA := nC6Funrura
									SC6TMP->C6_FETAB   := nC6Fetab
									SC6TMP->C6_CODROM  := cC6Codrom
									SC6TMP->C6_PVCOMOP := cC6Pvcomop
									SC6TMP->C6_SUGENTR := dC6Sugentr
									SC6TMP->C6_ITEMED  := cC6Itemed
									SC6TMP->C6_TPDEDUZ := cC6Tpdeduz
									SC6TMP->C6_MOTDED  := cC6Motded
									SC6TMP->C6_FORDED  := cC6Forded
									SC6TMP->C6_LOJDED  := cC6Lojded
									SC6TMP->C6_SERDED  := cC6Serded
									SC6TMP->C6_NFDED   := cC6Nfded
									SC6TMP->C6_VLNFD   := nC6Vlnfd
									SC6TMP->C6_PCDED   := nC6Pcded
									SC6TMP->C6_VLDED   := nC6Vlded
									SC6TMP->C6_PEDCOM  := cC6Pedcom
									SC6TMP->C6_ITPC    := cC6Itpc
									SC6TMP->C6_FILPED  := cC6Filped
									SC6TMP->C6_ABATINS := nC6Abatins
									SC6TMP->C6_TURNO   := cC6Turno
									SC6TMP->C6_CODLAN  := cC6Codlan
									SC6TMP->C6_PROGRAM := cC6Program
									SC6TMP->C6_RATEIO  := cC6Rateio
									SC6TMP->C6_CODINF  := cC6Codinf
									SC6TMP->C6_IMPORTA := cC6Importa
									SC6TMP->C6_PEDSAIB := cC6Pedsaib
									SC6TMP->C6_ITMSAIB := cC6Itmsaib
									
									msunlock()
									
								Endif
								
							Endif
							
							dbselectarea("TMPPED")
							dbskip()
							
						Enddo
						
					Endif
					
				Else
					
					dbselectarea("TMPPED")
					dbskip()
					
				Endif
				
			Else
				
				dbselectarea("TMPPED") 				//alert("Pedido "+cC5PedSaib+" ja existe !!")
				dbskip()
				
			Endif
			
		Enddo
		
		dbselectarea("TMPPED")
		dbclosearea()
		
		
		
		
	Else
		
		_cQry := " SELECT * FROM OpenRowSet('SQLOLEDB','192.168.1.4';'SAIB';'s2013','SELECT CD_PEDIDO_PALM AS PEDSAIB, CONVERT(NVARCHAR(10),DT_EMISSAO,103) AS DTEMISSAO, CONVERT(NVARCHAR(10),DT_ENTREGA,103) AS DTENTREGA ,CD_TAB_PRECO AS TABPRECO,DS_OBSERVACAO AS OBSFAT, * FROM SAIB.dbo.PEDIDO_RB ') AS PEDIDO WHERE MOTIVO_NAO_COMPRA IS NULL "
		
		//WHERE CONVERT(NVARCHAR(8),DT_EMISSAO,112) >= '20131029' AND MOTIVO_NAO_COMPRA IS NULL
		
		
		//////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cQry), "TMPPED", .F., .T.)
		//////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////
		
		dbselectarea("TMPPED")
		dbgotop()
		
		_QryPed := ""
		
		Do While ! eof()
			
			//////////////////////////////////////////////////
			///////////// Inicializar Variaveis //////////////
			//////////////////////////////////////////////////
			
			//CD_PEDIDO, 50      - pedido no protheus
			//CD_ST_PEDIDO  ,50  - status da importacao no protheus
			
			
			
			cC5Filial  := xFilial("SC5")
			cC5Num     := space(6)
			cC5PedSaib := padr(alltrim(PEDSAIB),50)
			
			dbselectarea("SC5")
			dbsetorder(6)
			dbgotop()
			
			if ! dbseek(xfilial("SC5")+cC5PedSaib , .f.)
				
				dbselectarea("TMPPED")
				
				_QryPed += ",'"+PEDSAIB+"'"
				
				cC5VlrSaib := val(alltrim(VR_PEDIDO))
				
				cC5Cliente := LEFT(CD_CLIENTE,6)
				if !empty(substr(CD_CLIENTE,7,2))
					cC5Lojacli := substr(CD_CLIENTE,7,2)
				Else
					cC5Lojacli := '01'
				Endif
				
				cC5Client  := cC5Cliente
				cC5Lojaent := cC5Lojacli
				
				cC5Descri  := Posicione("SA1",1,xFilial("SA1")+cC5Cliente+cC5Lojacli,"A1_NOME")
				
				cC5Tipo    := Posicione("SA1",1,xFilial("SA1")+cC5Cliente+cC5Lojacli,"A1_PESSOA")//"N"
				
				cC5Tipocli := Posicione("SA1",1,xFilial("SA1")+cC5Cliente+cC5Lojacli,"A1_TIPO")
				
				if sm0->m0_codigo == '05'
					cC5Tipocli := "R"
				Endif
				
				cC5Pedcli  := space(6)
				cC5Condpag := ALLTRIM(CD_COND_PGTO)
				cC5Formpag := ALLTRIM(CD_MEIO_PGTO)
				cC5Tpfrete := "C"
				cC5Transp  := space(6)
				cC5Veiculo := space(8)
				cC5Placa   := space(8)
				cC5Ufplaca := space(2)
				nC5Pesol   := 0
				nC5Pbruto  := 0
				nC5Pespal  := 0
				
				cC5Vend1   := ALLTRIM(CD_VENDEDOR)
				cC5Vendnom := cC5Vend1+"-"+Posicione("SA3",1,xFilial("SA3")+cC5Vend1,"A3_NOME")
				
				nC5Comis1  := 0
				cC5Vend2   := space(6)
				nC5Comis2  := 0
				cC5Vend3   := space(6)
				nC5Comis3  := 0
				cC5Vend4   := space(6)
				nC5Comis4  := 0
				cC5Vend5   := space(6)
				nC5Comis5  := 0
				
				cC5Menpad  := space(3)
				cC5Mens1   := space(65)
				cC5Mens2   := space(65)
				cC5Mens3   := space(65)
				cC5Mens4   := space(65)
				cC5Mens5   := space(65)
				cC5Mens6   := space(65)
				cC5Mens7   := space(65)
				cC5Mennota := cC5Vendnom //space(60)
				
				cC5Obsfat  := OBSFAT
				
				//dC5Emissao := ctod(substr(DTEMISSAO,1,2)+'/'+substr(DTEMISSAO,6,2)+'/'+substr(DTEMISSAO,1,4))
				dC5Emissao := ctod(DTEMISSAO)
				
				dC5Saida   := ctod(DTENTREGA)//DDATABASE
				
				if ! empty(dC5Emissao)
					if dC5Saida == dC5Emissao .or. empty(dC5Saida)
						dC5Saida += 1
					Endif
				Endif
				
				nC5Volume1 := 0
				cC5Especi1 := space(10)
				cC5Marca   := 'DUELO'
				cC5Tiplib  := '1'
				cC5Tabela  := alltrim(tabpreco)
				nC5Desc1   := 0
				nC5Desc2   := 0
				nC5Desc3   := 0
				nC5Desc4   := 0
				cC5Banco   := space(3)
				nC5Descfi  := 0
				cC5Cotacao := space(6)
				nC5Parc1   := 0
				dC5Data1   := ctod('')
				nC5Parc2   := 0
				dC5Data2   := ctod('')
				nC5Parc3   := 0
				dC5Data3   := ctod('')
				nC5Parc4   := 0
				dC5Data4   := ctod('')
				nC5Frete   := 0
				nC5Despesa := 0
				nC5Fretaut := 0
				cC5Reajust := space(3)
				nC5Moeda   := 1
				nC5Seguro  := 0
				nC5Reimp   := 0
				cC5Redesp  := space(6)
				nC5Volume2 := 0
				nC5Volume3 := 0
				nC5Volume4 := 0
				cC5Especi2 := space(10)
				cC5Especi3 := space(10)
				cC5Especi4 := space(10)
				cC5Inciss  := space(1)
				cC5Liberok := space(1)
				cC5Ok      := space(2)
				nC5Acrsfin := 0
				cC5Nota    := space(9)
				cC5Serie   := space(3)
				cC5Venda   := space(2)
				cC5Os      := space(6)
				cC5Kitrep  := space(6)
				nC5Descont := 0
				nC5Txmoeda := 1
				cC5Pedexp  := space(20)
				cC5Tpcarga := "1"
				cC5Prepemb := space(1)
				nC5Pdescab := 0
				cC5Blq     := space(1)
				cC5Forniss := space(6)
				cC5Contra  := space(10)
				cC5Reciss  := space(1)
				cC5Recfaut := space(1)
				nC5Vlrfrt  := 0
				cC5Mdcontr := space(15)
				cC5Mdnumed := space(6)
				cC5Mdplani := space(6)
				cC5Solfre  := space(2)
				cC5Orcres  := space(6)
				cC5Munpres := space(7)
				cC5Descmun := space(30)
				cC5Nfsubst := space(9)
				cC5Sersubs := space(3)
				dC5Dtlanc  := ctod('')
				cC5Gerawms := '1'
				dC5Fecent  := ctod('')
				cC5Solopc  := '1'
				dC5Sugent  := ctod('')
				cC5Coded   := space(15)
				cC5Numpr   := space(15)
				cC5Obra    := space(10)
				cC5Estpres := space(2)
				cC5Origem  := "SAIB"
				cC5Importa := space(1)
				
				if cC5VlrSaib > 0 .and. dC5Saida >= mv_par01 .and. dC5Saida <= mv_par02
					
					//////////////////////////////////////////////////
					///////////// Gravar/Atualizar Dados /////////////
					//////////////////////////////////////////////////
					
					DbSelectArea('SC5TMP')
					DbSetOrder(1) // verificar se o indice utilizado esta correto
					Dbgotop()
					
					_lInclui := .t.
					
					DbSeek(cC5PedSaib,.f.)
					
					If !Eof()
						_lInclui := .f.
					Endif
					
					If reclock('SC5TMP',_lInclui) // .T. - Inclui / .F. - Altera
						
						SC5TMP->C5_FILIAL  := cC5Filial
						SC5TMP->C5_NUM     := cC5Num
						SC5TMP->C5_PEDSAIB := cC5PedSaib
						SC5TMP->C5_VLRSAIB := cC5VlrSaib
						SC5TMP->C5_TIPO    := cC5Tipo
						SC5TMP->C5_CLIENTE := cC5Cliente
						SC5TMP->C5_LOJACLI := cC5Lojacli
						SC5TMP->C5_CLIENT  := cC5Client
						SC5TMP->C5_LOJAENT := cC5Lojaent
						SC5TMP->C5_DESCRI  := cC5Descri
						SC5TMP->C5_TIPOCLI := cC5Tipocli
						SC5TMP->C5_PEDCLI  := cC5Pedcli
						SC5TMP->C5_CONDPAG := cC5Condpag
						SC5TMP->C5_FORMPAG := cC5Formpag
						SC5TMP->C5_TPFRETE := cC5Tpfrete
						SC5TMP->C5_TRANSP  := cC5Transp
						SC5TMP->C5_VEICULO := cC5Veiculo
						SC5TMP->C5_PLACA   := cC5Placa
						SC5TMP->C5_UFPLACA := cC5Ufplaca
						SC5TMP->C5_PESOL   := nC5Pesol
						SC5TMP->C5_PBRUTO  := nC5Pbruto
						SC5TMP->C5_PESPAL  := nC5Pespal
						SC5TMP->C5_VEND1   := cC5Vend1
						SC5TMP->C5_COMIS1  := nC5Comis1
						SC5TMP->C5_VEND2   := cC5Vend2
						SC5TMP->C5_COMIS2  := nC5Comis2
						SC5TMP->C5_VEND3   := cC5Vend3
						SC5TMP->C5_COMIS3  := nC5Comis3
						SC5TMP->C5_VEND4   := cC5Vend4
						SC5TMP->C5_COMIS4  := nC5Comis4
						SC5TMP->C5_VEND5   := cC5Vend5
						SC5TMP->C5_COMIS5  := nC5Comis5
						SC5TMP->C5_MENPAD  := cC5Menpad
						SC5TMP->C5_MENS1   := cC5Mens1
						SC5TMP->C5_MENS2   := cC5Mens2
						SC5TMP->C5_MENS3   := cC5Mens3
						SC5TMP->C5_MENS4   := cC5Mens4
						SC5TMP->C5_MENS5   := cC5Mens5
						SC5TMP->C5_MENS6   := cC5Mens6
						SC5TMP->C5_MENS7   := cC5Mens7
						SC5TMP->C5_MENNOTA := cC5Mennota
						SC5TMP->C5_OBSFAT  := cC5Obsfat
						
						SC5TMP->C5_EMISSAO := dC5Emissao
						SC5TMP->C5_SAIDA   := dC5Saida
						SC5TMP->C5_VOLUME1 := nC5Volume1
						SC5TMP->C5_ESPECI1 := cC5Especi1
						SC5TMP->C5_MARCA   := cC5Marca
						SC5TMP->C5_TIPLIB  := cC5Tiplib
						SC5TMP->C5_TABELA  := cC5Tabela
						SC5TMP->C5_DESC1   := nC5Desc1
						SC5TMP->C5_DESC2   := nC5Desc2
						SC5TMP->C5_DESC3   := nC5Desc3
						SC5TMP->C5_DESC4   := nC5Desc4
						SC5TMP->C5_BANCO   := cC5Banco
						SC5TMP->C5_DESCFI  := nC5Descfi
						SC5TMP->C5_COTACAO := cC5Cotacao
						SC5TMP->C5_PARC1   := nC5Parc1
						SC5TMP->C5_DATA1   := dC5Data1
						SC5TMP->C5_PARC2   := nC5Parc2
						SC5TMP->C5_DATA2   := dC5Data2
						SC5TMP->C5_PARC3   := nC5Parc3
						SC5TMP->C5_DATA3   := dC5Data3
						SC5TMP->C5_PARC4   := nC5Parc4
						SC5TMP->C5_DATA4   := dC5Data4
						SC5TMP->C5_FRETE   := nC5Frete
						SC5TMP->C5_DESPESA := nC5Despesa
						SC5TMP->C5_FRETAUT := nC5Fretaut
						SC5TMP->C5_REAJUST := cC5Reajust
						SC5TMP->C5_MOEDA   := nC5Moeda
						SC5TMP->C5_SEGURO  := nC5Seguro
						SC5TMP->C5_REIMP   := nC5Reimp
						SC5TMP->C5_REDESP  := cC5Redesp
						SC5TMP->C5_VOLUME2 := nC5Volume2
						SC5TMP->C5_VOLUME3 := nC5Volume3
						SC5TMP->C5_VOLUME4 := nC5Volume4
						SC5TMP->C5_ESPECI2 := cC5Especi2
						SC5TMP->C5_ESPECI3 := cC5Especi3
						SC5TMP->C5_ESPECI4 := cC5Especi4
						SC5TMP->C5_INCISS  := cC5Inciss
						SC5TMP->C5_LIBEROK := cC5Liberok
						SC5TMP->C5_OK      := cC5Ok
						SC5TMP->C5_ACRSFIN := nC5Acrsfin
						SC5TMP->C5_NOTA    := cC5Nota
						SC5TMP->C5_SERIE   := cC5Serie
						SC5TMP->C5_VENDA   := cC5Venda
						SC5TMP->C5_OS      := cC5Os
						SC5TMP->C5_KITREP  := cC5Kitrep
						SC5TMP->C5_DESCONT := nC5Descont
						SC5TMP->C5_TXMOEDA := nC5Txmoeda
						SC5TMP->C5_PEDEXP  := cC5Pedexp
						SC5TMP->C5_TPCARGA := cC5Tpcarga
						SC5TMP->C5_PREPEMB := cC5Prepemb
						SC5TMP->C5_PDESCAB := nC5Pdescab
						SC5TMP->C5_BLQ     := cC5Blq
						SC5TMP->C5_FORNISS := cC5Forniss
						SC5TMP->C5_CONTRA  := cC5Contra
						SC5TMP->C5_RECISS  := cC5Reciss
						SC5TMP->C5_RECFAUT := cC5Recfaut
						SC5TMP->C5_VLR_FRT := nC5Vlrfrt
						SC5TMP->C5_MDCONTR := cC5Mdcontr
						SC5TMP->C5_MDNUMED := cC5Mdnumed
						SC5TMP->C5_MDPLANI := cC5Mdplani
						SC5TMP->C5_SOLFRE  := cC5Solfre
						SC5TMP->C5_ORCRES  := cC5Orcres
						SC5TMP->C5_MUNPRES := cC5Munpres
						SC5TMP->C5_DESCMUN := cC5Descmun
						SC5TMP->C5_NFSUBST := cC5Nfsubst
						SC5TMP->C5_SERSUBS := cC5Sersubs
						SC5TMP->C5_DTLANC  := dC5Dtlanc
						SC5TMP->C5_GERAWMS := cC5Gerawms
						SC5TMP->C5_FECENT  := dC5Fecent
						SC5TMP->C5_SOLOPC  := cC5Solopc
						SC5TMP->C5_SUGENT  := dC5Sugent
						SC5TMP->C5_CODED   := cC5Coded
						SC5TMP->C5_NUMPR   := cC5Numpr
						SC5TMP->C5_OBRA    := cC5Obra
						SC5TMP->C5_ESTPRES := cC5Estpres
						SC5TMP->C5_ORIGEM  := cC5Origem
						SC5TMP->C5_IMPORTA := cC5Importa
						
						msunlock()
						
					Endif
					
				Endif
				
			Else
				
				//alert("Pedido "+cC5PedSaib+" ja existe !!")
				
			Endif
			
			dbselectarea("TMPPED")
			dbskip()
			
		Enddo
		
		dbselectarea("TMPPED")
		dbclosearea()
		
		_QryPed := "("+substr(_QryPed,2)+")"
		
		_cQry := " SELECT * FROM OpenRowSet('SQLOLEDB','192.168.1.4';'SAIB';'s2013', 'SELECT CD_PEDIDO_PALM AS PEDSAIB, NR_ITEM_PEDIDO AS ITMSAIB, PC_DESCONTO AS DESCONTO,* FROM SAIB.dbo.ITEM_PEDIDO_RB ' ) AS ITENS "
		
		//_cQry := " SELECT * FROM OpenRowSet('SQLOLEDB','192.168.1.4';'SAIB';'s2013',' SELECT CD_PEDIDO_PALM AS PEDSAIB, NR_ITEM_PEDIDO AS ITMSAIB, PC_DESCONTO AS DESCONTO,* FROM SAIB.dbo.ITEM_PEDIDO_RB WHERE CD_PEDIDO_PALM IN "+_QryPed+" ORDER BY CD_PEDIDO_PALM, NR_ITEM_PEDIDO ') AS ITENS "
		
		//ALERT(_cQry)
		
		
		///////////////////////////////////////////////////////////////////////////
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cQry), "TMPITEM", .F., .T.)
		///////////////////////////////////////////////////////////////////////////
		
		dbselectarea("TMPITEM")
		dbgotop()
		
		Do While ! eof()
			
			//////////////////////////////////////////////////
			///////////// Inicializar Variaveis //////////////
			//////////////////////////////////////////////////
			
			cC6Pedsaib := padr(alltrim(PEDSAIB),50)
			
			DbSelectArea('SC5TMP')
			DbSetOrder(1)
			Dbgotop()
			
			if dbseek(cC6Pedsaib)
				
				dbselectarea("TMPITEM")
				
				cC6Filial  := xfilial('SC6')
				cC6Itmsaib := padl(alltrim(ITMSAIB),03,'0')
				cC6Num     := space(6)
				cC6Item    := padl(alltrim(ITMSAIB),02,'0')
				cC6Produto := padr(padl(alltrim(CD_PRODUTO),07,'0'),30)
				cC6Descri  := Posicione("SB1",1,xFilial("SB1")+cC6Produto ,"B1_DESC")
				cC6Um      := Posicione("SB1",1,xFilial("SB1")+cC6Produto ,"B1_UM")
				
				cC6Cli     := SC5TMP->C5_CLIENTE
				cC6Loja    := SC5TMP->C5_LOJACLI
				
				nC6Qtdven  := val(ALLTRIM(QT_ITEM))
				
				nC6Prcbrt  := val(ALLTRIM(VR_ITEM))
				
				nC6PerDes  := val(ALLTRIM(DESCONTO))/100
				
				nC6Prcfin  := nC6Prcbrt-(nC6Prcbrt*nC6PerDes)
				
				nC6Prcven  := nC6Prcfin // u_gdg001(cC6Produto,nC6Prcfin,cC6Cli,cC6Loja)
				
				nC6Valor   := ROUND(nC6Qtdven*nC6Prcven,2)
				
				cC6Lotenew := space(10)
				nC6Qtdlib  := 0
				cC6Segum   := space(2)
				
				cC6Tes     := Posicione("SB1",1,xFilial("SB1")+cC6Produto ,"B1_TS")
				
				_cOrigem   := space(1)
				_cSitTrib  := space(2)
				
				if !empty(cC6Tes)
					
					_cOrigem := substr(Posicione("SB1",1,xFilial("SB1")+cC6Produto ,"B1_ORIGEM"),1,1)
					
					if empty(_cOrigem)
						_cOrigem := "0"
					Endif
					
					_cSitTrib := Posicione("SF4",1,xFilial("SF4")+cC6Tes ,"F4_SITTRIB")
					
					if empty(_cSitTrib)
						_cSitTrib := "00"
					Endif
					
					
				Endif
				
				cC6Cf      := Posicione("SF4",1,xFilial("SF4")+cC6Tes ,"F4_CF")
				cC6Clasfis := _cOrigem+_cSitTrib
				
				nC6Qtdemp  := 0
				nC6Qtdent  := 0
				nC6Unsven  := 0
				cC6Local   := Posicione("SB1",1,xFilial("SB1")+cC6Produto ,"B1_LOCPAD")
				dC6Entreg  := dDataBase
				cC6La      := space(8)
				
				nC6Descont := 0
				nC6Valdesc := 0
				dC6Datfat  := ddatabase
				cC6Nota    := space(9)
				cC6Serie   := space(3)
				nC6Comis1  := 0
				nC6Comis2  := 0
				nC6Comis3  := 0
				nC6Comis4  := 0
				nC6Comis5  := 0
				cC6Pedcli  := space(9)
				nC6Prunit  := nC6Prcven
				cC6Bloquei := space(2)
				cC6Geroupv := space(1)
				cC6Reserva := space(6)
				cC6Nfori   := space(9)
				cC6Op      := space(2)
				cC6Ok      := space(2)
				nC6Ipidev  := 0
				cC6Identb6 := space(6)
				cC6Blq     := space(2)
				cC6Seriori := space(3)
				cC6Itemori := space(4)
				cC6Grade   := space(1)
				cC6Itemgrd := space(3)
				cC6Lotectl := space(10)
				cC6Numlote := space(6)
				nC6Picmret := 0
				cC6Numorc  := space(8)
				cC6Codiss  := space(9)
				cC6Opc     := space(80)
				cC6Localiz := space(15)
				cC6Numseri := space(20)
				cC6Numop   := space(6)
				cC6Itemop  := space(2)
				dC6Dtvalid := Ctod("")
				cC6Chassi  := space(17)
				nC6Qtdrese := 0
				cC6Numos   := space(10)
				cC6Numosfa := space(10)
				cC6Codfab  := space(6)
				cC6Lojafa  := space(2)
				cC6Tpop    := 'F'
				nC6Qtdent2 := 0
				cC6Revisao := space(3)
				nC6Qtdlib2 := 0
				cC6Servic  := space(3)
				cC6Endpad  := space(15)
				cC6Contrt  := space(15)
				cC6Tpcontr := space(1)
				cC6Itcontr := space(2)
				cC6Projpms := space(10)
				nC6Qtdemp2 := 0
				cC6Taskpms := space(12)
				cC6Licita  := space(6)
				cC6Contrat := space(6)
				cC6Itemcon := space(2)
				cC6Tpestr  := space(6)
				cC6Edtpms  := space(12)
				cC6Trt     := space(3)
				cC6Projet  := space(6)
				cC6Itproj  := space(2)
				mC6Mopc    := space(10)
				nC6Potenci := 0
				cC6Regwms  := space(1)
				nC6Abatiss := 0
				nC6Abatmat := 0
				cC6Numsc   := space(6)
				cC6Itemsc  := space(4)
				cC6Numcp   := space(6)
				nC6Abscins := 0
				nC6Funrura := 0
				nC6Fetab   := 0
				cC6Codrom  := space(6)
				cC6Pvcomop := space(1)
				dC6Sugentr := dDataBase
				cC6Itemed  := space(3)
				cC6Tpdeduz := space(1)
				cC6Motded  := space(1)
				cC6Forded  := space(6)
				cC6Lojded  := space(2)
				cC6Serded  := space(3)
				cC6Nfded   := space(9)
				nC6Vlnfd   := 0
				nC6Pcded   := 0
				
				nC6Vlded   := ROUND(nC6Qtdven*nC6PrcFin,2) //0
				
				cC6Pedcom  := space(6)
				cC6Itpc    := space(4)
				cC6Filped  := space(2)
				nC6Abatins := 0
				cC6Turno   := space(1)
				cC6Codlan  := space(6)
				cC6Program := space(10)
				cC6Rateio  := "2"
				cC6Codinf  := space(6)
				cC6Importa := space(1)
				
				if nC6Prcfin > 0
					
					//////////////////////////////////////////////////
					///////////// Gravar/Atualizar Dados /////////////
					//////////////////////////////////////////////////
					
					DbSelectArea('SC6TMP')
					DbSetOrder(1) // verificar se o indice utilizado esta correto
					Dbgotop()
					
					_lInclui := .t.
					
					DbSeek(cC6Pedsaib+cC6Itmsaib,.f.)
					
					If !Eof()
						_lInclui := .f.
					Endif
					
					If reclock('SC6TMP',_lInclui) // .T. - Inclui / .F. - Altera
						
						SC6TMP->C6_FILIAL  := cC6Filial
						SC6TMP->C6_ITEM    := cC6Item
						SC6TMP->C6_PRODUTO := cC6Produto
						SC6TMP->C6_DESCRI  := cC6Descri
						SC6TMP->C6_UM      := cC6Um
						SC6TMP->C6_QTDVEN  := nC6Qtdven
						SC6TMP->C6_PRCFIN  := nC6Prcfin
						SC6TMP->C6_PRCVEN  := nC6Prcven
						SC6TMP->C6_VALOR   := nC6Valor
						SC6TMP->C6_LOTENEW := cC6Lotenew
						SC6TMP->C6_QTDLIB  := nC6Qtdlib
						SC6TMP->C6_SEGUM   := cC6Segum
						SC6TMP->C6_TES     := cC6Tes
						SC6TMP->C6_QTDEMP  := nC6Qtdemp
						SC6TMP->C6_QTDENT  := nC6Qtdent
						SC6TMP->C6_CF      := cC6Cf
						SC6TMP->C6_UNSVEN  := nC6Unsven
						SC6TMP->C6_LOCAL   := cC6Local
						SC6TMP->C6_ENTREG  := dC6Entreg
						SC6TMP->C6_LA      := cC6La
						SC6TMP->C6_CLI     := cC6Cli
						SC6TMP->C6_DESCONT := nC6Descont
						SC6TMP->C6_VALDESC := nC6Valdesc
						SC6TMP->C6_DATFAT  := dC6Datfat
						SC6TMP->C6_LOJA    := cC6Loja
						SC6TMP->C6_NOTA    := cC6Nota
						SC6TMP->C6_SERIE   := cC6Serie
						SC6TMP->C6_NUM     := cC6Num
						SC6TMP->C6_COMIS1  := nC6Comis1
						SC6TMP->C6_COMIS2  := nC6Comis2
						SC6TMP->C6_COMIS3  := nC6Comis3
						SC6TMP->C6_COMIS4  := nC6Comis4
						SC6TMP->C6_COMIS5  := nC6Comis5
						SC6TMP->C6_PEDCLI  := cC6Pedcli
						SC6TMP->C6_PRUNIT  := nC6Prunit
						SC6TMP->C6_BLOQUEI := cC6Bloquei
						SC6TMP->C6_GEROUPV := cC6Geroupv
						SC6TMP->C6_RESERVA := cC6Reserva
						SC6TMP->C6_NFORI   := cC6Nfori
						SC6TMP->C6_OP      := cC6Op
						SC6TMP->C6_OK      := cC6Ok
						SC6TMP->C6_IPIDEV  := nC6Ipidev
						SC6TMP->C6_IDENTB6 := cC6Identb6
						SC6TMP->C6_BLQ     := cC6Blq
						SC6TMP->C6_SERIORI := cC6Seriori
						SC6TMP->C6_ITEMORI := cC6Itemori
						SC6TMP->C6_GRADE   := cC6Grade
						SC6TMP->C6_ITEMGRD := cC6Itemgrd
						SC6TMP->C6_LOTECTL := cC6Lotectl
						SC6TMP->C6_NUMLOTE := cC6Numlote
						SC6TMP->C6_PICMRET := nC6Picmret
						SC6TMP->C6_NUMORC  := cC6Numorc
						SC6TMP->C6_CODISS  := cC6Codiss
						SC6TMP->C6_OPC     := cC6Opc
						SC6TMP->C6_LOCALIZ := cC6Localiz
						SC6TMP->C6_NUMSERI := cC6Numseri
						SC6TMP->C6_NUMOP   := cC6Numop
						SC6TMP->C6_ITEMOP  := cC6Itemop
						SC6TMP->C6_CLASFIS := cC6Clasfis
						SC6TMP->C6_DTVALID := dC6Dtvalid
						SC6TMP->C6_CHASSI  := cC6Chassi
						SC6TMP->C6_QTDRESE := nC6Qtdrese
						SC6TMP->C6_NUMOS   := cC6Numos
						SC6TMP->C6_NUMOSFA := cC6Numosfa
						SC6TMP->C6_CODFAB  := cC6Codfab
						SC6TMP->C6_LOJAFA  := cC6Lojafa
						SC6TMP->C6_TPOP    := cC6Tpop
						SC6TMP->C6_QTDENT2 := nC6Qtdent2
						SC6TMP->C6_REVISAO := cC6Revisao
						SC6TMP->C6_QTDLIB2 := nC6Qtdlib2
						SC6TMP->C6_SERVIC  := cC6Servic
						SC6TMP->C6_ENDPAD  := cC6Endpad
						SC6TMP->C6_CONTRT  := cC6Contrt
						SC6TMP->C6_TPCONTR := cC6Tpcontr
						SC6TMP->C6_ITCONTR := cC6Itcontr
						SC6TMP->C6_PROJPMS := cC6Projpms
						SC6TMP->C6_QTDEMP2 := nC6Qtdemp2
						SC6TMP->C6_TASKPMS := cC6Taskpms
						SC6TMP->C6_LICITA  := cC6Licita
						SC6TMP->C6_CONTRAT := cC6Contrat
						SC6TMP->C6_ITEMCON := cC6Itemcon
						SC6TMP->C6_TPESTR  := cC6Tpestr
						SC6TMP->C6_EDTPMS  := cC6Edtpms
						SC6TMP->C6_TRT     := cC6Trt
						SC6TMP->C6_PROJET  := cC6Projet
						SC6TMP->C6_ITPROJ  := cC6Itproj
						SC6TMP->C6_MOPC    := mC6Mopc
						SC6TMP->C6_POTENCI := nC6Potenci
						SC6TMP->C6_REGWMS  := cC6Regwms
						SC6TMP->C6_ABATISS := nC6Abatiss
						SC6TMP->C6_ABATMAT := nC6Abatmat
						SC6TMP->C6_NUMSC   := cC6Numsc
						SC6TMP->C6_ITEMSC  := cC6Itemsc
						SC6TMP->C6_NUMCP   := cC6Numcp
						SC6TMP->C6_ABSCINS := nC6Abscins
						SC6TMP->C6_FUNRURA := nC6Funrura
						SC6TMP->C6_FETAB   := nC6Fetab
						SC6TMP->C6_CODROM  := cC6Codrom
						SC6TMP->C6_PVCOMOP := cC6Pvcomop
						SC6TMP->C6_SUGENTR := dC6Sugentr
						SC6TMP->C6_ITEMED  := cC6Itemed
						SC6TMP->C6_TPDEDUZ := cC6Tpdeduz
						SC6TMP->C6_MOTDED  := cC6Motded
						SC6TMP->C6_FORDED  := cC6Forded
						SC6TMP->C6_LOJDED  := cC6Lojded
						SC6TMP->C6_SERDED  := cC6Serded
						SC6TMP->C6_NFDED   := cC6Nfded
						SC6TMP->C6_VLNFD   := nC6Vlnfd
						SC6TMP->C6_PCDED   := nC6Pcded
						SC6TMP->C6_VLDED   := nC6Vlded
						SC6TMP->C6_PEDCOM  := cC6Pedcom
						SC6TMP->C6_ITPC    := cC6Itpc
						SC6TMP->C6_FILPED  := cC6Filped
						SC6TMP->C6_ABATINS := nC6Abatins
						SC6TMP->C6_TURNO   := cC6Turno
						SC6TMP->C6_CODLAN  := cC6Codlan
						SC6TMP->C6_PROGRAM := cC6Program
						SC6TMP->C6_RATEIO  := cC6Rateio
						SC6TMP->C6_CODINF  := cC6Codinf
						SC6TMP->C6_IMPORTA := cC6Importa
						SC6TMP->C6_PEDSAIB := cC6Pedsaib
						SC6TMP->C6_ITMSAIB := cC6Itmsaib
						
						msunlock()
						
					Endif
					
				Endif
				
			Endif
			
			//////////////////////////////////////////////////
			//////////////////////////////////////////////////
			
			dbselectarea("TMPITEM")
			dbskip()
			
		Enddo
		
		dbselectarea("TMPITEM")
		dbclosearea()
		
	Endif
	
	dbselectarea("SC5TMP")
	
	SC5TMP->(dbgotop())
	SC6TMP->(dbgotop())
	
	_cQtdLido := "Pedidos Lidos: "+strzero(reccount(),6)
	_oLeg:refresh()
	
	filsc6( SC5TMP->C5_PEDSAIB, SC5TMP->(RECNO()) )
	
	//_oBrwItem:resetlen()
	//_oBrwItem:refresh()
	
	_oBrwRegras:setfocus()
	_oBrwRegras:goposition(1)
	_oBrwRegras:refresh()
	
Endif

return nil

//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////
STATIC FUNCTION IMPSAIB()
//////////////////////////
local _aPedsaib := {}
Local y := 0 

dbselectarea("SC5TMP")
_nrecatu := recno()
dbgotop()

Do While ! eof()
	
	if C5_OK == "SS"
		
		_cNumPed := "00001S"
		
		DbSelectArea ("SX6")
		DbSetOrder (1)
		
		IF DbSeek("  US_PEDSAIB")
			
			_cNumPed := strzero(val(ALLTRIM(X6_CONTEUD)),5)
			
			if reclock("SX6",.F.)
				SX6->X6_CONTEUD := STRZERO(VAL(_cNumPed)+1,5)
				msunlock()
				_cNumPed += 'S'
				
			Endif
			
		EndIf
		
		
		DbSelectArea('SC5TMP')
		
		If reclock('SC5TMP', .f. ) // .T. - Inclui / .F. - Altera
			
			SC5TMP->C5_NUM     := _cNumPed
			SC5TMP->C5_OK      := "NN"
			msunlock()
			dbcommit()
			
		Endif
		
		dbselectarea("SC5")
		
		_nFCount := FCount()
		
		if RecLock("SC5",.t.)
			
			For y := 1 to _nFCount
				DbSelectArea("SC5TMP")
				_cNome  := FieldName(y)
				_cCampo := FieldGet (y)
				dbSelectArea("SC5")
				FieldPut ( FieldPos ( _cNome ), _cCampo )
			Next
			
			SC5->C5_MENNOTA := " "
			SC5->C5_TIPO    := "N"
			
			if empty(SC5->C5_SAIDA)
				SC5->C5_SAIDA := ddatabase+1
			Endif
			
			dbSelectArea("SC5")
			msunlock()
			
			AADD(_aPedsaib,{C5_PEDSAIB,C5_NUM})
			
		Endif
		
	Endif
	
	dbselectarea("SC5TMP")
	dbskip()
	
Enddo

dbselectarea("SC6TMP")
set filter to
dbgotop()

Do While ! eof()
	
	_nPed  := aScan(_aPedsaib ,{ |X| X[1] == SC6TMP->C6_PEDSAIB })
	
	IF _nPed > 0
		
		DbSelectArea('SC6TMP')
		
		If reclock('SC6TMP', .f. ) // .T. - Inclui / .F. - Altera
			SC6TMP->C6_NUM  := _aPedsaib[_nPed][2]
			msunlock()
			dbcommit()
		Endif
		
		dbselectarea("SC6")
		
		_nFCount := FCount()
		
		if RecLock("SC6",.t.)
			
			For y := 1 to _nFCount
				DbSelectArea("SC6TMP")
				_cNome  := FieldName(y)
				_cCampo := FieldGet (y)
				dbSelectArea("SC6")
				FieldPut ( FieldPos ( _cNome ), _cCampo )
			Next
			
			SC6->C6_VLDED  := 0
			
			if SM0->M0_CODIGO == '04'
				SC6->C6_PRCVEN := U_GDG001(SC6->C6_PRODUTO ,SC6->C6_PRCFIN, SC6->C6_CLI , SC6->C6_LOJA)
			Else
				SC6->C6_PRCVEN := SC6->C6_PRCFIN
			Endif
			
			SC6->C6_VALOR  := ROUND(SC6->C6_QTDVEN*SC6->C6_PRCVEN,2)
			SC6->C6_PRUNIT := SC6->C6_PRCVEN
			
			dbSelectArea("SC6")
			msunlock()
			
		Endif
		
	Endif
	
	dbselectarea("SC6TMP")
	dbskip()
	
Enddo

dbselectarea("SC5TMP")
dbgoto(_nrecatu)

updsaib()

filsc6( SC5TMP->C5_PEDSAIB, SC5TMP->(RECNO()) )

SC6TMP->(dbgotop())

_oBrwRegras:refresh()
//_oBrwItem:resetlen()
//_oBrwItem:refresh()

_oBrwRegras:setfocus()


return nil


//////////////////////////////////////////////////
//////////////////////////////////////////////////
static Function updsaib()
/////////////////////////////////////////////////
////////////////////////////////////////////////

if sm0->m0_codigo == '04'
	_cQry := "UPDATE SAIB.dbo.PEDIDO_RB SET CD_PEDIDO = SC5.C5_NUM "
	_cQry += "FROM SAIB.dbo.PEDIDO_RB SAIB, PROTHEUS.dbo.SC5040 SC5 "
Else
	_cQry := "UPDATE SAIB_Lugpet.dbo.PEDIDO_RB SET CD_PEDIDO = SC5.C5_NUM "
	_cQry += "FROM SAIB_Lugpet.dbo.PEDIDO_RB SAIB, PROTHEUS.dbo.SC5050 SC5 "
Endif

_cQry += "WHERE ( CD_PEDIDO IS NULL  OR CD_PEDIDO = '') AND ( LEFT(SAIB.CD_PEDIDO_PALM,50) = left(SC5.C5_PEDSAIB,50)  COLLATE Latin1_General_CI_AS ) "

If ( TCSQLExec(_cQry) < 0 )
	MsgStop("Houve erro na atualizacao dos dados SAIB."+chr(10)+chr(10)+"Erro: " + TCSQLError())
EndIf

return Nil

//dbselectarea("SC5")

//_cNovoOrc := getsxenum("SC5","C5_NUM")

//If __lSX8
//	//alert(_cNovoOrc)
//	ConfirmSX8()
//Endif




///////////////////////////////
///////////////////////////////
Static Function CriaPerg(cPerg)
///////////////////////////////
///////////////////////////////
Local j:= 0 
Local i := 0 

aSvAlias:={Alias(),IndexOrd(),Recno()}
i:=j:=0

cPerg := PADR(cPerg,10)
aRegistros:={}
//                                                                           1                                                                                          2                                                          3                               4
//               1      2    3                      4   5   6        7  8  9 0  1   2                        3         4                 5  6  7  8  9                  0  1  2  3  4                  5  6  7  8  9               0  1  2  3  4  5  6  7  8    9  0  1  2
AADD(aRegistros,{cPerg,"01","Data de Entrega de ?",".",".","mv_ch1","D",08,0,0,"G",""                      ,"mv_par01","            "   ,"","","","","            "    ,"","","","","               " ,"","","","",""             ,"","","","","","","","","  ","","","",""})
AADD(aRegistros,{cPerg,"02","Data de Entrega Ate?",".",".","mv_ch2","D",08,0,0,"G",""                      ,"mv_par02","            "   ,"","","","","            "    ,"","","","","               " ,"","","","",""             ,"","","","","","","","","  ","","","",""})
AADD(aRegistros,{cPerg,"03","Previsao emissao NF?",".",".","mv_ch3","D",08,0,0,"G",""                      ,"mv_par03","            "   ,"","","","","            "    ,"","","","","               " ,"","","","",""             ,"","","","","","","","","  ","","","",""})

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










///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
user function ManComis(_nOpcao ,_nFolder )
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
Local xzy := 0 
Local _i := 0
Local _nX := 0
Local _x := 0 
Local _nacols := 0  
private aHeader1 := {} 	, aHeader2 := {} 	, aHeader3 := {} 	, aHeader4 := {} 	, aHeader5 := {} 	, aHeader6 := {} 	, aHeader7 := {} 	, aHeader8 := {} 	, aHeader9 := {} 	, aHeader10 := {}
private aCols1   := {} 	, aCols2   := {}	, aCols3   := {} 	, aCols4   := {}	, aCols5   := {} 	, aCols6   := {} 	, aCols7   := {} 	, aCols8   := {} 	, aCols9   := {}	, aCols10   := {}
private nOpcx1   := 0  	, nOpcx2   := 0  	, nOpcx3   := 0  	, nOpcx4   := 0  	, nOpcx5   := 0  	, nOpcx6   := 0  	, nOpcx7   := 0  	, nOpcx8   := 0  	, nOpcx9   := 0  	, nOpcx10   := 0
private nTam1    := 0  	, nTam2    := 0  	, nTam3    := 0  	, nTam4    := 0  	, nTam5    := 0  	, nTam6    := 0  	, nTam7    := 0  	, nTam88   := 0  	, nTam9    := 0  	, nTam10    := 0

private CMSG,ALTERA,INCLUI,EXCLUI
private oDlgCldBrw , oFolder
private odlg1      , odlg2      , odlg3      , odlg4      , odlg5      , odlg6
private oGetDados1 , oGetDados2 , oGetDados3 , oGetDados4 , oGetDados5 , oGetDados6
private _oObj      , _aSay      , _aGet
private _oCldSay   , _oCldGet

//Private _bFColor1  := &("{|| Iif( oGetDados1:aCols[oGetDados1:oBrowse:nAt][len(oGetDados1:aCols[1])],"+ Str(CLR_WHITE)  +"  , Iif( AllTrim(oGetDados1:aCols[oGetDados1:oBrowse:nAt,1]) == '****' , " + Str(CLR_BLACK)  + " , " + Str(CLR_BLACK) + " ) ) }")
//private _bBColor1  := &("{|| iif( oGetDados1:aCols[oGetDados1:oBrowse:nAt][len(oGetDados1:aCols[1])],"+ Str(CLR_RED)    +"  , Iif( AllTrim(oGetDados1:aCols[oGetDados1:oBrowse:nAt,1]) == '****' , " + Str(CLR_YELLOW) + " , " + Str(CLR_WHITE) + " ) ) }")

Private _bFColor1  := &("{|| Iif( oGetDados1:aCols[oGetDados1:oBrowse:nAt][len(oGetDados1:aCols[1])],"+ Str(CLR_WHITE)  +"  , Iif( AllTrim(oGetDados1:aCols[oGetDados1:oBrowse:nAt,1]) == '****' , " + Str(CLR_BLACK)  + " , " + Str(CLR_BLACK) + " ) ) }")
private _bBColor1  := &("{|| iif( oGetDados1:aCols[oGetDados1:oBrowse:nAt][len(oGetDados1:aCols[1])],"+ Str(CLR_RED)    +"  , Iif( AllTrim(oGetDados1:aCols[oGetDados1:oBrowse:nAt,1]) == '****' , " + Str(CLR_YELLOW) + " , " + Str(CLR_WHITE) + " ) ) }")

SetKey( VK_F9	,	{|| nil } )
setkey( VK_F10 , 	{|| nil } )

_aSay := {}
_aGet := {}


_cArea     := Alias()
_nind      := indexord()
_nReg      := Recno()

INCLUI      := .F. // 1
ALTERA      := .T. // 2
EXCLUI      := .F. // 4

cMsg        :=  ""
nOpcx1      :=  Iif(Altera .OR. Inclui .or. EXCLUI, GD_INSERT+GD_DELETE+GD_UPDATE, 0)

if _nOpcao == 1
	_cRegCod    := space(6)
	_cRegNome   := space(50)
Else
	_cRegCod    := SZC->ZC_REGIAO
	_cRegNome   := substr(Posicione("SX5",1,xFilial("SX5")+"A2"+_cRegCod,"X5_DESCRI"),1,50)
Endif

_oObj      := _oBrwregras

dbselectarea("SZC")

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// GRID 1 - Regioes
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

_cFile1    := "SZC"

nUsado1    :=  0
aHeader1   := {}
aCols1     := {}
_aCampos1  := {}

//			     				X3_TITULO      , X3_CAMPO     ,  X3_PICTURE   ,  X3_TAMANHO	,  X3_DECIMAL	,  X3_VALID                      ,  X3_USADO         ,  X3_TIPO ,  X3_F3 ,  X3_CONTEXT ,  X3_CBOX, X3_RELACAO, X3_WHEN     , X3_VISUAL, X3_VLDUSER,  X3_PICTVAR,  X3_OBRIGAT

/*01*/ aadd(_aCampos1,{"Codigo" 			, "ZC_PRODUTO" , "@!"          ,  30  			,   0 			,                                , "€€€€€€€€€€€€€€ " ,   "C"  	,    "   ",       ""		, ""      , ""        , ".F."    	, ""       , ""        , ""         , ""         }) // 01
/*02*/ aadd(_aCampos1,{"Produto" 		, "ZC_USUARIO" , "@!"          ,  60  			,   0 			,                                , "€€€€€€€€€€€€€€ " ,   "C"   ,    "   ",       ""		, ""      , ""        , ".F"     	, ""       , ""        , ""         , ""         }) // 01
/*03*/ aadd(_aCampos1,{"Vendedor"     	, "ZC_PERCENT" , "@E 999.99"   ,  06 			,   2 			,                                , "€€€€€€€€€€€€€€ " ,    ""	,       "",       ""		, ""      , ""        , ""     		, ""       , ""        , ""         , ""         }) // 03
/*04*/ aadd(_aCampos1,{"Representante"	, "ZC_PERCENT" , "@E 999.99"   ,  06 			,   2 			,                                , "€€€€€€€€€€€€€€ " ,    ""	,       "",       ""		, ""      , ""        , ""     		, ""       , ""        , ""         , ""         }) // 04
/*05*/ aadd(_aCampos1,{"Supervisor"   	, "ZC_PERCENT" , "@E 999.99"   ,  06 			,   2 			,                                , "€€€€€€€€€€€€€€ " ,    ""	,       "",       ""		, ""      , ""        , ""     		, ""       , ""        , ""         , ""         }) // 05
/*06*/ aadd(_aCampos1,{"Gerente"      	, "ZC_PERCENT" , "@E 999.99"   ,  06 			,   2 			,                                , "€€€€€€€€€€€€€€ " ,    ""	,       "",       ""		, ""      , ""        , ""     		, ""       , ""        , ""         , ""         }) // 05

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek(_cFile1)

While !Eof() .And. (x3_arquivo == _cFile1)
	
	for xzy := 1 to len(_aCampos1)
		
		If upper(Rtrim(x3_campo)) == upper(Rtrim(_aCampos1[xzy][2]))
			
			_aCampos1[xzy][01]  := iif(empty(_aCampos1[xzy][01]),TRIM(x3_titulo),_aCampos1[xzy][01])
			_aCampos1[xzy][03]  := iif(empty(_aCampos1[xzy][03]),x3_picture     ,_aCampos1[xzy][03])
			_aCampos1[xzy][04]  := iif(empty(_aCampos1[xzy][04]),x3_tamanho     ,_aCampos1[xzy][04])
			_aCampos1[xzy][05]  := iif(empty(_aCampos1[xzy][05]),x3_decimal     ,_aCampos1[xzy][05])
			_aCampos1[xzy][06]  := iif(empty(_aCampos1[xzy][06]),x3_valid       ,_aCampos1[xzy][06])
			_aCampos1[xzy][07]  := iif(empty(_aCampos1[xzy][07]),x3_usado       ,_aCampos1[xzy][07])
			_aCampos1[xzy][08]  := iif(empty(_aCampos1[xzy][08]),x3_tipo        ,_aCampos1[xzy][08])
			_aCampos1[xzy][09]  := iif(empty(_aCampos1[xzy][09]),x3_F3          ,_aCampos1[xzy][09])
			_aCampos1[xzy][10]  := iif(empty(_aCampos1[xzy][10]),x3_context     ,_aCampos1[xzy][10])
			_aCampos1[xzy][11]  := iif(empty(_aCampos1[xzy][11]),x3_cbox        ,_aCampos1[xzy][11])
			_aCampos1[xzy][13]  := iif(empty(_aCampos1[xzy][13]),x3_when        ,_aCampos1[xzy][13])
			_aCampos1[xzy][14]  := iif(empty(_aCampos1[xzy][14]),x3_visual      ,_aCampos1[xzy][14])
			_aCampos1[xzy][15]  := iif(empty(_aCampos1[xzy][15]),x3_vlduser     ,_aCampos1[xzy][15])
			_aCampos1[xzy][16]  := iif(empty(_aCampos1[xzy][16]),x3_pictvar     ,_aCampos1[xzy][16])
			_aCampos1[xzy][17]  := iif(empty(_aCampos1[xzy][17]),x3_obrigat     ,_aCampos1[xzy][17])
			
			If nOpcx1 >= 2
				If x3_tipo == "C"
					_aCampos1[xzy][12] := SPACE(_aCampos1[xzy][04])
				Elseif x3_tipo == "N"
					_aCampos1[xzy][12] := 0
				Elseif x3_tipo == "D"
					_aCampos1[xzy][12] := cTod("")
				Elseif x3_tipo == "M"
					_aCampos1[xzy][12] := space(10)
				Else
					_aCampos1[xzy][12] := .f.
				Endif
			Endif
		Endif
		
		
	Next
	
	dbSkip()
	
Enddo

nusado1 := len(_aCampos1)

for xzy := 1 to len(_aCampos1)
	AADD(aHeader1,{_aCampos1[xzy][1],_aCampos1[xzy][2],_aCampos1[xzy][3],_aCampos1[xzy][4],_aCampos1[xzy][5],_aCampos1[xzy][6],_aCampos1[xzy][7],_aCampos1[xzy][8],_aCampos1[xzy][9],_aCampos1[xzy][10],_aCampos1[xzy][11],_aCampos1[xzy][12],_aCampos1[xzy][13],_aCampos1[xzy][14],_aCampos1[xzy][15],_aCampos1[xzy][16],_aCampos1[xzy][17]})
Next

///////////////////////////


dbselectarea("SB1")
dbsetorder(1)
dbgotop()

Do While ! eof()
	
	IF SB1->B1_TIPO == 'PA'
		aadd(aCols1,Array(nUsado1+1))
		
		i := len(aCols1)
		
		
		aCols1[i][01] := b1_cod
		aCols1[i][02] := b1_desc
		
		aCols1[i][03] := 0
		aCols1[i][04] := 0
		aCols1[i][05] := 0
		aCols1[i][06] := 0
		
		
		aCols1[i][nUsado1+1] := .F.
		
	Endif
	
	dbskip()
	
Enddo


For _i :=1 to len(aCols1)
	
	dbselectarea("SZC")
	dbsetorder(1)
	dbgotop()
	
	if dbseek(xfilial("SZC")+_cRegCod+acols1[_i][1],.f.)
		
	Endif
	
	
Next


/////////////////////////

_nSalDep := 0

incproc("Processando Estoques..." )

_cQry := " SELECT B2_FILIAL, SUM(B2_QATU) AS B2_QATU "
_cQry += " FROM "+retsqlname("SB2")
_cQry += " WHERE  D_E_L_E_T_ <> '*' "
_cQry += " AND  ( B2_QATU <> 0) "
_cQry += " AND  ( LEFT(B2_COD,6) NOT IN ('000135','000199') ) "

//if !_lSubtipo
_cQry += " AND  ( B2_COD =  '"+_CodPrd+"') "
//Else
//	_cQry += " AND  ( B2_01CAT3 =  '"+_cPrdSub+"') "
//	_cQry += " AND  ( B2_01CAT4 =  '"+_cDepCod+"') "
//Endif

_cQry += " GROUP BY B2_FILIAL "
//_cQry += " ORDER BY B2_FILIAL "

//alert(_cqRY)

MsgRun("Aguarde... selecionando Estoques..","",{|| dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cqRY), "TMPSB2", .F., .T.) })

_aStrutmp:= SB2->(dbStruct())

For _nX := 1 To Len(_aStrutmp)
	If _aStrutmp[_nX,2] $ "DN" .AND. alltrim(upper(_aStrutmp[_nX,1])) $ "B2_QATU"
		TcSetField("TMPSB2",_aStrutmp[_nX,1],_aStrutmp[_nX,2],_aStrutmp[_nX,3],_aStrutmp[_nX,4])
	EndIf
Next nX

dbselectarea("TMPSB2")
dbgotop()

Do While ! eof()
	
	if left(TMPSB2->B2_FILIAL,2) == '03'
		_nSalDep := TMPSB2->B2_QATU
	Endif
	
	_nLoja := aScan( aCols1, { |X| X[1] == TMPSB2->B2_FILIAL } )
	
	if _nLoja > 0
		aCols1[_nLoja][06] := TMPSB2->B2_QATU
	Endif
	
	dbskip()
	
Enddo

dbselectarea("TMPSB2")
dbclosearea()

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

_cQry := " SELECT D2_FILIAL,LEFT(D2_EMISSAO,6) AS D2_MES, SUM(D2_QUANT) AS D2_QUANT , SUM(D2_TOTAL) AS D2_TOTAL "
_cQry += " FROM "+retsqlname("SD2")
_cQry += " WHERE  D_E_L_E_T_ <> '*' "
_cQry += " AND LEFT(D2_CODANT,6) NOT IN ('000135','000199') "

if !_lSubtipo
	_cQry += " AND  ( D2_COD =  '"+_CodPrd+"') "
Else
	_cQry += " AND  ( D2_01CAT3 =  '"+_cPrdSub+"') "
	_cQry += " AND  ( D2_01CAT4 =  '"+_cDepCod+"') "
Endif

_cQry += " AND  ( LEFT(D2_EMISSAO,6) BETWEEN '" + _xMesIni +"' AND '" + _xMesFim +"' ) "

_cQry += " GROUP BY D2_FILIAL,LEFT(D2_EMISSAO,6) "
//_cQry += " ORDER BY D2_FILIAL,LEFT(D2_EMISSAO,6) "

//alert(_cqRY)

MsgRun("Aguarde... selecionando Vendas..","",{|| dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cqRY), "TMPSD2", .F., .T.) })

_aStrutmp:= SD2->(dbStruct())

For _nX := 1 To Len(_aStrutmp)
	If _aStrutmp[_nX,2] $ "DN" .AND. alltrim(upper(_aStrutmp[_nX,1])) $ "D2_QUANT,D2_TOTAL"
		TcSetField("TMPSD2",_aStrutmp[_nX,1],_aStrutmp[_nX,2],_aStrutmp[_nX,3],_aStrutmp[_nX,4])
	EndIf
Next nX

dbselectarea("TMPSD2")
dbgotop()

Do While ! eof()
	
	_nMesVen := aScan( _aMes, { |X| X[1] == TMPSD2->D2_MES } )
	
	if _nMesVen > 0
		
		if _nMesVen < 7
			_nMesVen += 8
		Else
			_nMesVen += 9
		Endif
		
		_nLoja := aScan( aCols1, { |X| X[1] == TMPSD2->D2_FILIAL } )
		
		if _nLoja > 0
			aCols1[_nLoja,      _nMesVen] += TMPSD2->D2_QUANT
			aCols1[len(aCols1), _nMesVen] += TMPSD2->D2_QUANT
		Endif
		
	Endif
	
	dbskip()
	
Enddo

dbselectarea("TMPSD2")
dbclosearea()

dbselectarea("SD2")

/*
Else


dbselectarea("SD2")
set filter to
DbOrderNickName("VISVENPROD")
dbGotop()

DbSeek(_CodPrd,.T.)

Do While ! eof() .and. SD2->D2_COD == SB1->B1_COD // .and. SD2->D2_EMISSAO <= _dPerAte

_nMesVen := aScan( _aMes, { |X| X[1] == substr(dtos(SD2->D2_EMISSAO),1,6) } )

if _nMesVen > 0

_nMesVen += 7

_nLoja := aScan( aCols1, { |X| X[1] == SD2->D2_FILIAL } )

if _nLoja > 0
aCols1[_nLoja,      _nMesVen] += SD2->D2_QUANT
aCols1[len(aCols1), _nMesVen] += SD2->D2_QUANT
Endif

Endif


dbskip()

Enddo

Endif
*/

incproc("Consolidando registros..." )

aCols:= {}

_nEsttot := 0

For _nacols := 1 to len(acols1)
	
	if aCols1[_nacols][06] <  aCols1[_nacols][04]
		aCols1[_nacols][07] := "BR_VERMELHO"
	Elseif aCols1[_nacols][06] < aCols1[_nacols][03]
		aCols1[_nacols][07] := "BR_AMARELO"
	Elseif aCols1[_nacols][06] <= aCols1[_nacols][05]
		aCols1[_nacols][07] := "BR_VERDE"
	Elseif aCols1[_nacols][06] > aCols1[_nacols][05]
		aCols1[_nacols][07] := "BR_PRETO"
	Else
		aCols1[_nacols][07] := "BR_BRANCO"
	Endif
	
	aCols1[_nacols][08] := aCols1[_nacols][05]-aCols1[_nacols][06]
	
	_nmes := 0
	
	if aCols1[_nacols][09] > 0
		_nmes ++
	Endif
	if aCols1[_nacols][10] > 0
		_nmes ++
	Endif
	if aCols1[_nacols][11] > 0
		_nmes ++
	Endif
	if aCols1[_nacols][12] > 0
		_nmes ++
	Endif
	if aCols1[_nacols][13] > 0
		_nmes ++
	Endif
	if aCols1[_nacols][14] > 0
		_nmes ++
	Endif
	
	if _nMes == 0
		_nmes ++
	Endif
	
	_nEst    :=   aCols1[_nacols][06] // Qtd Em Estoque Atual
	
	_nEstseg :=   aCols1[_nacols][18] // Qtd em estoque minimo
	
	_nsoma := ( aCols1[_nacols][09] + aCols1[_nacols][10] + aCols1[_nacols][11] + aCols1[_nacols][12] + aCols1[_nacols][13] + aCols1[_nacols][14])
	
	aCols1[_nacols][15] := iif( mod( _nsoma ,_nmes) > 0 , int(_nsoma/_nmes)+1, int(_nsoma/_nmes))
	
	_nEstMed := aCols1[_nacols][15] //aCols1[_nacols][14]
	
	aCols1[_nacols][17] := (_nEstMed*3)
	
	_nEstMin := int(_nEstMed- (_nEstMed*(_nPerMin/100)))
	_nEstMax := int(_nEstMed+ (_nEstMed*(_nPerMax/100)))
	
	//if (aCols1[_nacols][04]+aCols1[_nacols][05]) == 0
	//   aCols1[_nacols][04] := _nEstMin
	//   aCols1[_nacols][05] := _nEstMax
	//Endif
	
	if substr(aCols1[_nacols][1],1,2) <> '04' .and. ( substr(aCols1[_nacols][1],1,2) $ '03/01') // .or. _nsoma > 0 .or. _nEst > 0 .or. _nEstseg > 0)
		
		aadd(aCols,{aCols1[_nacols][1],aCols1[_nacols][2],aCols1[_nacols][3],aCols1[_nacols][4],aCols1[_nacols][5],aCols1[_nacols][6],aCols1[_nacols][7],aCols1[_nacols][8],aCols1[_nacols][9],aCols1[_nacols][10],aCols1[_nacols][11],aCols1[_nacols][12],aCols1[_nacols][13],aCols1[_nacols][14],aCols1[_nacols][15],aCols1[_nacols][16],aCols1[_nacols][17],aCols1[_nacols][18],aCols1[_nacols][19],aCols1[_nacols][20] , .f. })
		
		_nEsttot += aCols1[_nacols][3]
		
		_aTotais[1][03] += aCols1[_nacols][03]
		_aTotais[1][04] += aCols1[_nacols][04]
		_aTotais[1][05] += aCols1[_nacols][05]
		
		_aTotais[1][06] += aCols1[_nacols][06]
		
		_aTotais[1][09] += aCols1[_nacols][09]
		_aTotais[1][10] += aCols1[_nacols][10]
		_aTotais[1][11] += aCols1[_nacols][11]
		_aTotais[1][12] += aCols1[_nacols][12]
		_aTotais[1][13] += aCols1[_nacols][13]
		_aTotais[1][14] += aCols1[_nacols][14]
		
		_aTotais[1][15] += aCols1[_nacols][15]
		
		_aTotais[1][16] += aCols1[_nacols][16]
		
		
		_aTotais[1][17] += aCols1[_nacols][17] // Verificar se atinge estoque
		
		
		_aTotais[1][18] += aCols1[_nacols][18]
		_aTotais[1][19] += aCols1[_nacols][19]
		_aTotais[1][20] += aCols1[_nacols][20]
		
	Endif
	
Next

aCols1 := aclone(aCols)

////////////////////////////////////////////////////
////////////////////////////////////////////////////

/*

aadd(aCols1,Array(nUsado1+1))

i := len(aCols1)

aCols1[i][01] := space(4)
aCols1[i][02] := space(15)

aCols1[i][03] := 0
aCols1[i][04] := "BR_BRANCO"

aCols1[i][05] := 0
aCols1[i][06] := 0
aCols1[i][07] := 0

aCols1[i][08] := 0
aCols1[i][09] := 0
aCols1[i][10] := 0
aCols1[i][11] := 0
aCols1[i][12] := 0
aCols1[i][13] := 0

aCols1[i][14] := 0

aCols1[i][15] := 0
aCols1[i][16] := 0
aCols1[i][17] := 0

aCols1[i][nUsado1+1] := .F.

*/

////////////////////////////////////////////////////
////////////////////////////////////////////////////

aadd(aCols1,Array(nUsado1+1))

i := len(aCols1)

aCols1[i][01] := "****"
aCols1[i][02] := padr("TOTAL GERAL",15)

aCols1[i][03] := _aTotais[1][03]
aCols1[i][04] := _aTotais[1][04]
aCols1[i][05] := _aTotais[1][05]

aCols1[i][06] := _aTotais[1][06]

aCols1[i][09] := _aTotais[1][09]
aCols1[i][10] := _aTotais[1][10]
aCols1[i][11] := _aTotais[1][11]
aCols1[i][12] := _aTotais[1][12]
aCols1[i][13] := _aTotais[1][13]
aCols1[i][14] := _aTotais[1][14]

aCols1[i][15] := _aTotais[1][15]

aCols1[i][16] := _aTotais[1][16]

aCols1[i][17] := _aTotais[1][17]

aCols1[i][18] := _aTotais[1][18]
aCols1[i][19] := _aTotais[1][19]
aCols1[i][20] := _aTotais[1][20]

aCols1[i][nUsado1+1] := .F.


////////////////////////////////////////////////////
////////////////////////////////////////////////////

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Titulo da Janela                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cTitulo:="Calculo de Estoques"


_nLimCol := oMainwnd:nClientWidth  - 100
_nLimLin := oMainwnd:nClientHeight - 100

aSize   := MsAdvSize()

_nBrwLin1 := asize[1] + 5
_nBrwCol1 := asize[2] + 5
_nBrwLin2 := asize[4] - 10
_nBrwCol2 := asize[3] - 10

aTela  :={asize[1],asize[2],asize[6],asize[5]}

aCGD1   :={100, 005 ,_nBrwLin2  , _nBrwCol2 }


//@ _nBrwLin2+10,010 SAY "Valores: Total: "                                           PIXEL FONT oFont1  SIZE 060,20 //COLOR CLR_HBLUE
//@ _nBrwLin2+10,080 MSGET oTotFol VAR _nTotFol PICTURE "@e 999,999,999.99"  when .f. PIXEL FONT oFont2  size 090,25 COLOR CLR_HRED
//@ _nBrwLin2+25,020 SAY oQtdFol   VAr _nQtdFol PICTURE "@e 999,999"                  PIXEL FONT oFont1  SIZE 030,15 COLOR CLR_HBLUE

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array com descricao dos campos do Cabecalho                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aC:={}

ofont1 := TFont():New("TIMES NEW ROMAN" , 15, 50,,.T.)
ofont2 := TFont():New("TIMES NEW ROMAN" , 10, 30,,.T.)
ofont3 := TFont():New("ARIAL"           , 07, 16,,.F.)
ofont3 := TFont():New("ARIAL"           , 07, 16,,.F.)
ofont4 := TFont():New("TIMES NEW ROMAN" , 10, 20,,.T.)

_nLin := 5

//        1                 2              3     4      5         6          7          8         9                     10                                                                        			                 11        12         13     14          15          16              17              18             19             20      21
//        Descricao       , variavel     , Lin   , Col , Larg Say , Alt Say ,  Larg Get , Alt Get , Picture             , Valid                                                                   		 	               , F3      , when     , Tipo , Fonte Say , Fonte Get , Cor Texto Say , Cor Fundo Say , Cor Texto Get, Cor Fundo Get, Pixel , Alinha a direita
AADD(aC,{"Departamento "  , "_cPrdDep"   , _nLin , 005 , 45       , 10      ,  060      , 10      , "@!"                ,                                                                         			               ,         , .f.      ,  1   , "ofont3"  , "ofont3"  , ""            , ""            , CLR_HBLUE    , CLR_WHITE    , 1.8   , .f. })
AADD(aC,{""               , "_cPrdDepNm" , _nLin , 120 , 0        , 10      ,  200      , 10      , "@!"                ,                                                                         			               ,         , .f.      ,  1   , "ofont3"  , "ofont3"  , ""            , ""            , CLR_HBLUE    , CLR_WHITE    , 1.8   , .f. })

AADD(aC,{"Comprador    "  , "_cPrdCom"   , _nLin , 330 , 40       , 10      ,  040      , 10      , "@!"                , "u_p004com(@_cPrdCom,@_cPrdComNm)"                                                               , "VISCOM", .t.      ,  1   , "ofont3"  , "ofont3"  , ""            , ""            , CLR_HBLUE    , CLR_WHITE    , 1.8   , .f. })
AADD(aC,{""               , "_cPrdComNm" , _nLin , 420 , 0        , 10      ,  100      , 10      , "@!"                ,                                                                         			               ,         , .f.      ,  1   , "ofont3"  , "ofont3"  , ""            , ""            , CLR_HBLUE    , CLR_WHITE    , 1.8   , .f. })

_nLin += 15
AADD(aC,{"Grupo        "  , "_cPrdGrp"   , _nLin , 005 , 45       , 10      ,  060      , 10      , "@!"                ,                                                                         			               ,         , .f.      ,  1   , "ofont3"  , "ofont3"  , ""            , ""            , CLR_HBLUE    , CLR_WHITE    , 1.8   , .f. })
AADD(aC,{""               , "_cPrdGrpNm" , _nLin , 120 , 0        , 10      ,  200      , 10      , "@!"                ,                                                                         			               ,         , .f.      ,  1   , "ofont3"  , "ofont3"  , ""            , ""            , CLR_HBLUE    , CLR_WHITE    , 1.8   , .f. })

AADD(aC,{"Prc.Venda    "  , "_cPrdPrv"   , _nLin , 330 , 40       , 10      ,  040      , 10      , "@E 999,999.99"     ,                                                                                                  ,         , .f.      ,  1   , "ofont3"  , "ofont3"  , ""            , ""            , CLR_HBLUE    , CLR_WHITE    , 1.8   , .f. })
AADD(aC,{"Cor          "  , "_cPrdCor"   , _nLin , 420 , 40       , 10      ,  060      , 10      , "@!"                ,                                                                                                  ,         , .f.      ,  1   , "ofont3"  , "ofont3"  , ""            , ""            , CLR_HBLUE    , CLR_WHITE    , 1.8   , .f. })


_nLin += 15
AADD(aC,{"Tipo         "  , "_cPrdTip"   , _nLin , 005 , 45       , 10      ,  060      , 10      , "@!"                ,                                                                         			               ,         , .f.      ,  1   , "ofont3"  , "ofont3"  , ""            , ""            , CLR_HBLUE    , CLR_WHITE    , 1.8   , .f. })
AADD(aC,{""               , "_cPrdTipNm" , _nLin , 120 , 0        , 10      ,  200      , 10      , "@!"                ,                                                                         			               ,         , .f.      ,  1   , "ofont3"  , "ofont3"  , ""            , ""            , CLR_HBLUE    , CLR_WHITE    , 1.8   , .f. })

AADD(aC,{"Prc.Compra   "  , "_cPrdPrc"   , _nLin , 330 , 40       , 10      ,  040      , 10      , "@E 999,999.99"     ,                                                                                                  ,         , .f.      ,  1   , "ofont3"  , "ofont3"  , ""            , ""            , CLR_HBLUE    , CLR_WHITE    , 1.8   , .f. })
AADD(aC,{"Tamanho      "  , "_cPrdTam"   , _nLin , 420 , 40       , 10      ,  060      , 10      , "@!"                ,                                                                                                  ,         , .f.      ,  1   , "ofont3"  , "ofont3"  , ""            , ""            , CLR_HBLUE    , CLR_WHITE    , 1.8   , .f. })


_nLin += 15
AADD(aC,{"Subtipo"        , "_cPrdSub"   , _nLin , 005 , 45       , 10      ,  060      , 10      , "@!"                ,                                                                         			               ,         , .f.      ,  1   , "ofont3"  , "ofont3"  , ""            , ""            , CLR_HBLUE    , CLR_WHITE    , 1.8   , .f. })
AADD(aC,{""               , "_cPrdSubNm" , _nLin , 120 , 0        , 10      ,  200      , 10      , "@!"                ,                                                                         			               ,         , .f.      ,  1   , "ofont3"  , "ofont3"  , ""            , ""            , CLR_HBLUE    , CLR_WHITE    , 1.8   , .f. })

AADD(aC,{"Custo        "  , "_cPrdCus"   , _nLin , 330 , 40       , 10      ,  040      , 10      , "@E 999,999.99"     ,                                                                                                  ,         , .f.      ,  1   , "ofont3"  , "ofont3"  , ""            , ""            , CLR_HBLUE    , CLR_WHITE    , 1.8   , .f. })
AADD(aC,{"Etiqueta     "  , "_cPrdEtqnM" , _nLin , 420 , 40       , 10      ,  060      , 10      , "@!"                ,                                                                                                  ,         , .f.      ,  1   , "ofont3"  , "ofont3"  , ""            , ""            , CLR_HBLUE    , CLR_WHITE    , 1.8   , .f. })

if _cPrdPrc > 0
	_nMkp := round( (_cPrdPrv-_cPrdPrc) / _cPrdPrc * 100 , 2 )
Else
	_nMkp := 0
Endif

_nLin += 15
AADD(aC,{"Codigo       "  , "_cPrdCod"   , _nLin , 005 , 45       , 10      ,  060      , 10      , "@!"                ,                                                                         			               ,         , .f.      ,  1   , "ofont3"  , "ofont3"  , ""            , ""            , CLR_HBLUE    , CLR_WHITE    , 1.8   , .f. })
AADD(aC,{""               , "_cPrdNome"  , _nLin , 120 , 0        , 10      ,  200      , 10      , "@!"                ,                                                                         			               ,         , .f.      ,  1   , "ofont3"  , "ofont3"  , ""            , ""            , CLR_HBLUE    , CLR_WHITE    , 1.8   , .f. })
AADD(aC,{"Markup       "  , "_nMkp"      , _nLin , 330 , 40       , 10      ,  040    , 10      , "@E 999,999.99"                ,                                                                                                  ,         , .f.      ,  1   , "ofont3"  , "ofont3"  , ""            , ""            , CLR_HBLUE    , CLR_WHITE    , 1.8   , .f. })

_nLin += 15
AADD(aC,{"Codigo Visao "  , "_cPrdVis"   , _nLin , 005 , 45       , 10      ,  060      , 10      , "@!"                ,                                                                         			               ,         , .f.      ,  1   , "ofont3"  , "ofont3"  , ""            , ""            , CLR_HBLUE    , CLR_WHITE    , 1.8   , .f. })
AADD(aC,{"GTIN 13"        , "_cPrdG13"   , _nLin , 120 , 30       , 10      ,  060      , 10      , "@!"                ,                                                                         			               ,         , .f.      ,  1   , "ofont3"  , "ofont3"  , ""            , ""            , CLR_HBLUE    , CLR_WHITE    , 1.8   , .f. })
AADD(aC,{"Modelo"         , "_cPrdMod"   , _nLin , 230 , 30       , 10      ,  060      , 10      , "@!"                ,                                                                         			               ,         , .f.      ,  1   , "ofont3"  , "ofont3"  , ""            , ""            , CLR_HBLUE    , CLR_WHITE    , 1.8   , .f. })

AADD(aC,{"Fornecedor   "  , "_cPrdFor"   , _nLin , 330 , 40       , 10      ,  040      , 10      , "@!"                ,                                                                         			               ,         , .f.      ,  1   , "ofont3"  , "ofont3"  , ""            , ""            , CLR_HBLUE    , CLR_WHITE    , 1.8   , .f. })
AADD(aC,{""               , "_cPrdForNm" , _nLin , 420 , 0        , 10      ,  200      , 10      , "@!"                ,                                                                         			               ,         , .f.      ,  1   , "ofont3"  , "ofont3"  , ""            , ""            , CLR_HBLUE    , CLR_WHITE    , 1.8   , .f. })

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array com descricao dos campos do Rodape                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//_nTitVal   := E2_VALOR


aR:={}

/*

//        1                   2              3               4                 5          6          7          8         9                     10                                     11    12     13      14         15          16              17              18             19             20      21
//        Descricao         , variavel     , Lin           , Col             , Larg Say , Alt Say ,  Larg Get , Alt Get , Picture             , Valid                                , F3  , when , Tipo , Fonte Say , Fonte Get , Cor Texto Say , Cor Fundo Say , Cor Texto Get, Cor Fundo Get, Pixel , Alinha a direita
AADD(aR,{"Natureza: "       ,              , _nBrwLin2-90  , _nBrwCol1       , 90       , 20      ,  001      , 20      ,                     ,                                      ,     , .F.  ,  1   , "ofont4"  , "ofont4"  , ""            , ""            , CLR_HBLUE    , CLR_WHITE    , 1.8   , .F. })

AADD(aR,{"Rateado"          , "_cNatTot"   , _nBrwLin2-75  , _nBrwCol1       , 50       , 20      ,  070      , 20      ,                     ,                                      ,     , .F.  ,  1   , "ofont2"  , "ofont2"  , ""            , ""            , CLR_HBLUE    , CLR_WHITE    , 1.8   , .F. })
AADD(aR,{""                 , "_cNatPer"   , _nBrwLin2-75  , _nBrwCol1+130   , 01       , 20      ,  035      , 20      ,                     ,                                      ,     , .F.  ,  1   , "ofont2"  , "ofont2"  , ""            , ""            , CLR_HBLUE    , CLR_WHITE    , 1.8   , .t. })
AADD(aR,{"A Ratear"         , "_cNatRes"   , _nBrwLin2-50  , _nBrwCol1       , 50       , 20      ,  070      , 20      ,                     ,                                      ,     , .F.  ,  1   , "ofont2"  , "ofont2"  , ""            , ""            , CLR_HRED     , CLR_WHITE    , 1.8   , .F. })
AADD(aR,{""                 , "_cNatPrs"   , _nBrwLin2-50  , _nBrwCol1+130   , 01       , 20      ,  035      , 20      ,                     ,                                      ,     , .F.  ,  1   , "ofont2"  , "ofont2"  , ""            , ""            , CLR_HRED     , CLR_WHITE    , 1.8   , .t. })

AADD(aR,{"C.Custo: "       ,               , _nBrwLin2-90  , _nCol1 + 5      , 90       , 20      ,  001      , 20      ,                     ,                                      ,     , .F.  ,  1   , "ofont4"  , "ofont4"  , ""            , ""            , CLR_HBLUE    , CLR_WHITE    , 1.8   , .F. })

AADD(aR,{"Rateado"         , "_cCusTot"    , _nBrwLin2-75  , _nCol1 + 5      , 50       , 20      ,  070      , 20      ,                     ,                                      ,     , .F.  ,  1   , "ofont2"  , "ofont2"  , ""            , ""            , CLR_HBLUE    , CLR_WHITE    , 1.8   , .F. })
AADD(aR,{""                , "_cCusPer"    , _nBrwLin2-75  , _nCol1 + 135    , 01       , 20      ,  035      , 20      ,                     ,                                      ,     , .F.  ,  1   , "ofont2"  , "ofont2"  , ""            , ""            , CLR_HBLUE    , CLR_WHITE    , 1.8   , .t. })

AADD(aR,{"A Ratear"        , "_cCusRes"    , _nBrwLin2-50  , _nCol1 + 5      , 50       , 20      ,  070      , 20      ,                     ,                                      ,     , .F.  ,  1   , "ofont2"  , "ofont2"  , ""            , ""            , CLR_HRED     , CLR_WHITE    , 1.8   , .F. })
AADD(aR,{""                , "_cCusPrs"    , _nBrwLin2-50  , _nCol1 + 135    , 01       , 20      ,  035      , 20      ,                     ,                                      ,     , .F.  ,  1   , "ofont2"  , "ofont2"  , ""            , ""            , CLR_HRED     , CLR_WHITE    , 1.8   , .t. })
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Validacoes na GetDados                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_cLinhaOk1 := " u_vallin1()  "
_cTudoOk1  := " allwaystrue()"
_cDelLin1  := " u_Dellin1()  "
_cBlkChng1 := "{|| u_chglin1()}"



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chamada da Funcao de Browse para edicao                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_aGetDados := {}

_aGetEdt1  := {"B2_FILIAL","B2_CMFIM2","B2_CMFIM3","B2_CMFIM4"}
_nmax1     := 99 //len(aCols1)

aadd(_aGetDados,{ nOpcx1 , @acols1, @aHeader1, @aCGD1 , @_cLinhaOk1, @_cTudoOk1, @_aGetEdt1 , /* @_cIniCpos */ , @_nMax1 , @_cDelLin1, 1 , @_bBColor1, @_bFColor1, _cBlkChng1  } )

_aBotoes := {}

Aadd( _aBotoes , {"S4WB010N", {|| u_visr015()}, "Impressao (F9)" , "Impressao (F9)" , {|| .T.}} )

Do While .t.
	
	SetKey( VK_F9,{|| u_visr015() } )
	
	_lCldRet  := u_cldjan(cTitulo,aTela,/*bF4*/,aC,aR,@_aGetDados,/*oDlgMain*/,/*_aFolTit*/,/*_aFolDial*/,/*_aFolPos*/,_aBotoes)
	
	SetKey( VK_F9,{|| nil } )
	
	oDlgEst:refresh()
	oMainWnd:refresh()
	
	if _lCldRet
		
		if empty(_cVsComCod)
			//alert("Comprador sem cadastro no sistema.")
			//exit
		Endif
		
		dbselectarea("SBZ")
		set filter to
		dbsetorder(2)
		dbgotop()
		
		_xChvSBZ := _cPrdCod
		
		//if _lSubtipo // Por Subtipo
		//	_xChvSBZ := PADR("SUB-"+ALLTRIM(_cPrdCod),18)
		//Endif
		
		dbseek(_xChvSBZ)
		
		Do While ! eof() .and. BZ_COD == _xChvSBZ
			
			if reclock("SBZ",.F.)
				delete
				msunlock()
			Endif
			
			dbskip()
			
		Enddo
		
		dbcommit()
		
		nTam1 := 0
		
		nBzLe      := 0
		
		FOR _x := 1 to len(aCols1)
			if ! aCols1[_x,nUsado1+1] .and. alltrim(aCols1[_x,1]) <> '****'
				if left(aCols1[_x][1],2) == "03
					nBzLe += aCols1[_x][6]
				Endif
			Endif
		Next
		
		dbselectarea("SBZ")
		set filter to
		
		FOR _x := 1 to len(aCols1)
			
			if ! aCols1[_x,nUsado1+1] .and. alltrim(aCols1[_x,1]) <> '****' .and. ( aCols1[_x][3] <> 0 .or. aCols1[_x][18] <> 0)
				
				nTam1 ++
				
				//////////////////////////////////////////////////
				///////////// Inicializar Variaveis //////////////
				//////////////////////////////////////////////////
				
				cBzFilial  := aCols1[_x][1]
				cBzCod     := _xChvSBZ //_cPrdCod
				cBzLocpad  := '01' //SB1->B1_LOCPAD
				
				nBzEstseg  := aCols1[_x][3]
				nBzEmin    := aCols1[_x][4]
				nBzEmax    := aCols1[_x][5]
				
				nBzqatu    := aCols1[_x][6]
				
				if nBzqatu < nBzEmin
					nBzStatus  := '1'
				Elseif nBzqatu > nBzEmax
					nBzStatus  := '2'
				Elseif nBzqatu < nBzEstseg
					nBzStatus  := '3'
				Else
					nBzStatus  := '4'
				Endif
				
				nBzCustd   := 0
				nBzUprc    := 0
				nBzQe      := 0
				dBzUcom    := ctod('')
				nBzPe      := 0
				cBzTipe    := space(1)
				nBzLm      := 0
				nBzToler   := 0
				nBzMarkup  := 0
				
				cBz01cdcom := _cPrdCom//_cVsComCod
				
				cBzProc    := _cPrdFor
				cBzLojproc := "01" // SB1->B1_LOJPROC
				
				cBz01cat1  := _cPrdGrp
				cBz01cat2  := _cPrdTip
				cBz01cat3  := _cPrdSub
				cBz01cat4  := _cPrdDep
				cBz01cat5  := space(6)
				
				cBz01codma := _cPrdEtq
				cBz01mod   := _cPrdMod
				cBzCodant  := _cPrdVis
				
				dBzData    := ctod('')
				dBz01dtcad := DDATABASE
				cBzFabrica := space(6)
				
				cBzTe      := space(3)
				cBzTs      := space(3)
				dBzUcalstd := ctod('')
				cBzMcustd  := '1'
				cBzEstfor  := space(3)
				cBzForprz  := space(3)
				cBzTipocq  := "M"
				nBzQb      := 0
				cBzMrp     := space(1)
				cBzFantasm := space(1)
				dBzConini  := ctod('')
				dBzDatref  := ctod('')
				nBzPicm    := 0
				nBzVlricm  := 0
				nBzInticm  := 0
				nBzPicmret := 0
				nBzPicment := 0
				nBzIpi     := 0
				nBzVlripi  := 0
				nBzRedpis  := 0
				nBzRedcof  := 0
				cBzIrrf    := space(1)
				cBzOrigem  := space(1)
				cBzGrtrib  := space(6)
				cBzOpc     := space(80)
				nBzAliqiss := 0
				nBzAlfumac := 0
				cBzCodiss  := space(8)
				
				//////////////////////////////////////////////////
				///////////// Gravar/Atualizar Dados /////////////
				//////////////////////////////////////////////////
				
				DbSelectArea('SBZ')
				DbSetOrder(1) // verificar se o indice utilizado esta correto
				Dbgotop()
				
				_lInclui := .t.
				
				// Alterar a chave de pesquisa de acordo com a tabela
				
				DbSeek(cBzFilial+cBzCod,.f.)
				
				If !Eof()
					_lInclui := .f.
				Endif
				
				If reclock('SBZ',_lInclui) // .T. - Inclui / .F. - Altera
					
					IF _lInclui
						
						SBZ->BZ_FILIAL  := cBzFilial
						SBZ->BZ_COD     := cBzCod
						SBZ->BZ_LOCPAD  := cBzLocpad
						SBZ->BZ_CUSTD   := nBzCustd
						SBZ->BZ_UPRC    := nBzUprc
						SBZ->BZ_QE      := nBzQe
						SBZ->BZ_UCOM    := dBzUcom
						SBZ->BZ_PE      := nBzPe
						SBZ->BZ_TIPE    := cBzTipe
						SBZ->BZ_LE      := nBzLe
						SBZ->BZ_LM      := nBzLm
						SBZ->BZ_TOLER   := nBzToler
						SBZ->BZ_MARKUP  := nBzMarkup
						SBZ->BZ_01CAT4  := cBz01cat4
						SBZ->BZ_01CDCOM := cBz01cdcom
						SBZ->BZ_PROC    := cBzProc
						SBZ->BZ_LOJPROC := cBzLojproc
						SBZ->BZ_01CAT1  := cBz01cat1
						SBZ->BZ_01CAT2  := cBz01cat2
						SBZ->BZ_01CAT3  := cBz01cat3
						SBZ->BZ_01CAT5  := cBz01cat5
						SBZ->BZ_01CODMA := cBz01codma
						SBZ->BZ_01MOD   := cBz01mod
						SBZ->BZ_CODANT  := cBzCodant
						SBZ->BZ_DATA    := dBzData
						SBZ->BZ_01DTCAD := dBz01dtcad
						SBZ->BZ_TE      := cBzTe
						SBZ->BZ_TS      := cBzTs
						SBZ->BZ_UCALSTD := dBzUcalstd
						SBZ->BZ_MCUSTD  := cBzMcustd
						SBZ->BZ_ESTFOR  := cBzEstfor
						SBZ->BZ_FORPRZ  := cBzForprz
						SBZ->BZ_TIPOCQ  := cBzTipocq
						SBZ->BZ_QB      := nBzQb
						SBZ->BZ_MRP     := cBzMrp
						SBZ->BZ_FANTASM := cBzFantasm
						SBZ->BZ_CONINI  := dBzConini
						SBZ->BZ_DATREF  := dBzDatref
						SBZ->BZ_PICM    := nBzPicm
						SBZ->BZ_VLR_ICM := nBzVlricm
						SBZ->BZ_INT_ICM := nBzInticm
						SBZ->BZ_PICMRET := nBzPicmret
						SBZ->BZ_PICMENT := nBzPicment
						SBZ->BZ_IPI     := nBzIpi
						SBZ->BZ_VLR_IPI := nBzVlripi
						SBZ->BZ_REDPIS  := nBzRedpis
						SBZ->BZ_REDCOF  := nBzRedcof
						SBZ->BZ_IRRF    := cBzIrrf
						SBZ->BZ_ORIGEM  := cBzOrigem
						SBZ->BZ_GRTRIB  := cBzGrtrib
						SBZ->BZ_OPC     := cBzOpc
						SBZ->BZ_ALIQISS := nBzAliqiss
						SBZ->BZ_ALFUMAC := nBzAlfumac
						SBZ->BZ_CODISS  := cBzCodiss
						SBZ->BZ_FABRICA := cBzFabrica
						
					Endif
					
					SBZ->BZ_ESTSEG  := nBzEstseg
					SBZ->BZ_EMIN    := nBzEmin
					SBZ->BZ_EMAX    := nBzEmax
					SBZ->BZ_QATU    := nBzqatu
					SBZ->BZ_STATUS  := nBzStatus
					
					msunlock()
					
				Endif
				
				dbcommit()
				
				//////////////////////////////////////////////////
				//////////////////////////////////////////////////
				
			Endif
			
			
		Next
		
		exit
		
	Else
		
		exit
		
	Endif
	
EndDo

//Endif

dbselectarea("SBZ")
SET FILTER TO &_cFilSBZ
dbsetorder(5)
dbgotop()
//dbsetfilter( {|| BZ_01CAT4 == AY0->AY0_CODIGO} , "BZ_01CAT4 == AY0->AY0_CODIGO" )

_oBrwEst:resetlen()
_oBrwEst:gotop()
_oBrwEst:refresh()

dbselectarea('SB1')
//dbclosearea()
//chkfile('SB1')

if _nFolder == 2
	dbselectarea("SBZ")
Endif

if _nFolder == 4
	dbselectarea("AY1")
Endif

_aVsDep   := u_rtcomdep(__CUSERID)

//Elseif _nFolder == 5

//	_oObj := _oBrwEtq

//Endif

dbselectarea(_cArea)
dbsetorder(_nind)
dbgoto(_nReg)

setkey( VK_F10 ,  { || _lKeypesq := .t. , u_VISP004p(oFolder:nOption) } )


Return NIL
