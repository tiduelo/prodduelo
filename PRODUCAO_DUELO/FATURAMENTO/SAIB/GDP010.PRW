#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#Include "Topconn.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"
#define CLD_GREEN		RGB(177,241,186)
#define CLD_YELLOW	RGB(241,243,152)
#define CLD_RED 		RGB(255,81,81)
/*
*****************************************************************************
*****************************************************************************
**  Rotina  | GDP010 | Autor  -Claudenilson Dias        | Data | 07.07.13  **
**                   |                                  |      |           **
*****************************************************************************
** Descricao | GDP010 - IMPORTA PEDIDOS SAIB                               **
*****************************************************************************
**  Uso      | SIGAFAT                                                     **
*****************************************************************************
*****************************************************************************
*/
/////////////////////////////////////////////////////
/////////////////////////////////////////////////////
User Function GDP010(_lRotAuto)
/////////////////////////////////////////////////////   
Local aArea := GetArea()

//RPCSETTYPE(3)
	lMenu := .f.
	If Select("SX2") <> 0
		lMenu := .t.
	Endif

	//If isblind()
	If !lMenu
		RPCSetType(3) //não consome licença.
		Prepare Environment Empresa "05" Filial "01"
	Endif

if _lRotAuto == nil
	_lRotAuto      	:= IIF( AllTrim(Funname(0) ) == "" , .T. , .F. )
Endif

__LOCALDRIVER	:= "CTREECDX"

// SELECT * FROM OpenRowSet('SQLOLEDB','192.168.1.4';'SAIB';'s2013','SELECT * FROM SAIB.dbo.PEDIDO_RB ') AS B
// SELECT * FROM OpenRowSet('SQLOLEDB','192.168.1.4';'SAIB';'s2013','SELECT * FROM SAIB.dbo.ITEM_PEDIDO_RB ') AS B

_cTmpSC5  := CriaTrab(SC5->(dbstruct()),.T.)+".DTC"
_cTmpSC5I := strtran(_cTmpSC5,".DTC",".IDX")
_cTmpSC5F := strtran(_cTmpSC5,".DTC",".FPT")

_cTmpSC6  := CriaTrab(SC6->(dbstruct()),.T.)+".DTC"
_cTmpSC6I := strtran(_cTmpSC6,".DTC",".IDX")
_cTmpSC6F := strtran(_cTmpSC6,".DTC",".FPT")

if select("SC5TMP") > 0
	SC5TMP->(dbclosearea())
Endif

if select("SC6TMP") > 0
	SC6TMP->(dbclosearea())
Endif

dbUseArea(.T.,,_cTmpSC5,"SC5TMP",.F.,.F.)
//IndRegua("SC5TMP",_cTmpSC5I,"C5_PEDSAIB",,,)
IndRegua("SC5TMP",_cTmpSC5I,"C5_MENNOTA+DTOS(C5_SAIDA)+C5_PEDSAIB",,,)
dbSetorder(1)
dbgotop()

dbUseArea(.T.,,_cTmpSC6,"SC6TMP",.F.,.F.)
IndRegua("SC6TMP",_cTmpSC6I,"C6_PEDSAIB+C6_ITMSAIB",,,)
dbSetorder(1)

If _lRotAuto
	
	conout("IMPORTA SAIB: Iniciando Atualizacao...")
	
//COMENTADO POR RONALDO MAIA EM 18/10/2016 E SOLICITADO POR RODRIGO OTAVIO PARA DESCONTINUAR A MANSAGEM 50 E DESCONTINUA A TABELA SZ3
//	PREPARE ENVIRONMENT EMPRESA "05" FILIAL "01" TABLES "SC5","SC6","SB1","SZ3","SM0","SX1","SX6" MODULO "SIGAFAT"
PREPARE ENVIRONMENT EMPRESA "05" FILIAL "01" TABLES "SC5","SC6","SB1","SM0","SX1","SX6" MODULO "SIGAFAT"
	//////////////////////////////////////////////////////
	LERSAIB(_lRotAuto)
	IMPSAIB(_lRotAuto)
	//////////////////////////////////////////////////////
	
	if select("SC5TMP") > 0
		SC5TMP->(dbclosearea())
	Endif
	
	if select("SC6TMP") > 0
		SC6TMP->(dbclosearea())
	Endif
	
	if file(_cTmpSC5)
		ferase(_cTmpSC5)
		ferase(_cTmpSC5I)
		ferase(_cTmpSC5F)
	Endif
	
	if file(_cTmpSC6)
		ferase(_cTmpSC6)
		ferase(_cTmpSC6I)
		ferase(_cTmpSC6F)
	Endif
	
	RESET ENVIRONMENT
	
Else
	
	_cArea := Alias()
	_nind  := indexord()
	_nReg  := Recno()
	
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
	
	aFolTit   := { 'Pedidos' , 'Itens do pedido'}
	aFolDial  := { "oFol1"         , "oFol2"    }
	
	oDlgEst := MSDialog():New( 10, 10 , aSizeEst[6] , aSizeEst[5] , 'Bebidas Duelo - importacao de Pedidos SAIB' , , , .F. , , , , , , .T. , , , .T. , , )
	
	oFolder  := TFolder():New( 5, 10 , aFolTit, aFolDial, oDlgEst ,,,, .T., .t. , _nFolLar , _nFolAlt, ,.t. )
	
	oFolPed    := oFolder:aDialogs[1]
	oFolItem   := oFolder:aDialogs[2]
	
	_oBrwPed := TCBrowse():New(    5  ,   5   , _nFolLar-10 ,  _nFolAlt-20 ,          ,            ,             , oFolPed,          ,           ,            ,          ,              ,           ,         ,           ,            ,            ,        ,            , "SC5TMP"    ,  .T.     ,         ,            ,          ,   .T.      , .T.         )
	
	_oBrwPed:AddColumn(TCColumn():New('  '              ,{||IIF(EMPTY(SC5TMP->C5_NUM)  , IIF(EMPTY(SC5TMP->C5_OBSFAT)  ,oVerde ,opreto),oVermelho)  }              ,                      ,,,'LEFT'  , ,.T.,.F.,,,,.F.,))
	_oBrwPed:AddColumn(TCColumn():New('Selecao'         ,{||Iif(SC5TMP->C5_OK  == 'SS' , oOk   ,  oNoOk)       }           ,                       ,,,'LEFT'  , ,.T.,.F.,,,,.F.,))
	_oBrwPed:AddColumn(TCColumn():New('Pedido SAIB'     ,{||SC5TMP->C5_PEDSAIB                }                             ,                      ,,,'LEFT'  , ,.F.,.F.,,,,.F.,))
	_oBrwPed:AddColumn(TCColumn():New('Pedido PROTHEUS' ,{||SC5TMP->C5_NUM                    }                             ,                      ,,,'LEFT'  , ,.F.,.F.,,,,.F.,))
	_oBrwPed:AddColumn(TCColumn():New('Emissao'         ,{||SC5TMP->C5_EMISSAO                }                             ,                      ,,,'LEFT'  , ,.F.,.F.,,,,.F.,))
	_oBrwPed:AddColumn(TCColumn():New('Entrega'         ,{||SC5TMP->C5_SAIDA                  }                             ,                      ,,,'LEFT'  , ,.F.,.F.,,,,.F.,))
	_oBrwPed:AddColumn(TCColumn():New('Valor'           ,{||SC5TMP->C5_VLRSAIB                }                             ,  "@E 999,999,999.99" ,,,'RIGHT' , ,.F.,.F.,,,,.F.,))
	_oBrwPed:AddColumn(TCColumn():New('Cliente'         ,{||SC5TMP->C5_CLIENTE                }                             ,                      ,,,'LEFT'  , ,.F.,.F.,,,,.F.,))
	_oBrwPed:AddColumn(TCColumn():New('Loja'            ,{||SC5TMP->C5_LOJACLI                }                             ,                      ,,,'LEFT'  , ,.F.,.F.,,,,.F.,))	
	_oBrwPed:AddColumn(TCColumn():New('Nome'            ,{||SC5TMP->C5_DESCRI                 }                             ,                      ,,,'LEFT'  , ,.F.,.F.,,,,.F.,))
	_oBrwPed:AddColumn(TCColumn():New('Município'       ,{||GetAdvFVal("SA1","A1_MUN",xFilial("SA1")+SC5TMP->C5_CLIENTE+SC5TMP->C5_LOJACLI,1," ")} ,"@!",,,'LEFT', ,.F.,.F.,,,,.F.,))
	_oBrwPed:AddColumn(TCColumn():New('Vendedor'        ,{||SC5TMP->C5_MENNOTA                }                             ,                      ,,,'LEFT'  , ,.F.,.F.,,,,.F.,))
	_oBrwPed:AddColumn(TCColumn():New('Pessoa'          ,{||SC5TMP->C5_TIPO                   }                             ,                      ,,,'LEFT'  , ,.F.,.F.,,,,.F.,))
	_oBrwPed:AddColumn(TCColumn():New('Observacao'      ,{||SC5TMP->C5_OBSFAT                 }                             ,  "@!"                ,,,'LEFT'  , ,.F.,.F.,,,,.F.,))
//    _oBrwPed:AddColumn(TCColumn():New('Dt inclusao'     ,{||SC5TMP->C5_DTINCLU                }                             ,  "@!"                ,,,'LEFT'  , ,.F.,.F.,,,,.F.,))
	
	_oBrwItem := TCBrowse():New(    5  ,   5   , _nFolLar-10 ,  _nFolAlt-20 ,          ,            ,             , oFolItem,          ,           ,            ,          ,              ,           ,         ,           ,            ,            ,        ,            , "SC6TMP"    ,  .T.     ,         ,            ,          ,   .T.      , .T.         )
	
	_oBrwItem:AddColumn(TCColumn():New('Produto'            ,{||SC6TMP->C6_PRODUTO }                                                , "@!"                ,,,'LEFT'    , ,.F.,.F.,,,,.F.,))
	_oBrwItem:AddColumn(TCColumn():New('Descricao'          ,{||Posicione("SB1",1,xFilial("SB1")+SC6TMP->C6_PRODUTO ,"B1_DESC")}   ,                      ,,,'LEFT'    , ,.F.,.F.,,,,.F.,))
	_oBrwItem:AddColumn(TCColumn():New('Quantidade'         ,{||SC6TMP->C6_QTDVEN}                                                  , "@E 999,999"        ,,,'RIGHT'   , ,.F.,.F.,,,,.F.,))
	_oBrwItem:AddColumn(TCColumn():New('Preco Pedido'       ,{||SC6TMP->C6_PRCFIN}                                                  , "@E 999,999.999999" ,,,'RIGHT'   , ,.F.,.F.,,,,.F.,))
	_oBrwItem:AddColumn(TCColumn():New('Total Pedido'       ,{||SC6TMP->C6_VLDED}                                                   , "@E 999,999,999.99" ,,,'RIGHT'   , ,.F.,.F.,,,,.F.,))
	_oBrwItem:AddColumn(TCColumn():New('Prc.Faturamento'    ,{||SC6TMP->C6_PRCVEN}                                                  , "@E 999,999.999999" ,,,'RIGHT'   , ,.F.,.F.,,,,.F.,))
	_oBrwItem:AddColumn(TCColumn():New('Total Faturamento'  ,{||SC6TMP->C6_VALOR}                                                   , "@E 999,999,999.99" ,,,'RIGHT'   , ,.F.,.F.,,,,.F.,))
	
	dbselectarea("SC5TMP")
	dbsetorder(1)
	dbgotop()
	
	dbselectarea("SC6TMP")
	_cFILSC6 := " ( C6_PEDSAIB == SC5TMP->C5_PEDSAIB ) "
	SET FILTER TO &_cFILSC6
	dbgotop()
	
	dbselectarea("SC5TMP")
	
	//_oBrwItem:resetlen()
	
	_oBrwPed:bChange      := {|| filsc6( SC5TMP->C5_PEDSAIB, SC5TMP->(RECNO()) ) }
	_oBrwPed:bLdblclick   := {|| MarkPed( SC5TMP->C5_PEDSAIB, 1, SC5TMP->(RECNO()) ) }
	_oBrwPed:bHeaderClick := {|| msgrun("Aguarde...","Marcacao", {|| MarkPed( SC5TMP->C5_PEDSAIB, 2, SC5TMP->(RECNO()) ) }) }
	
	oMenuImp   := TMenu():New(0,0,0,0,.T.)    // Adiciona itens no Menu
	oMenuItem1 := TMenuItem():New(oDlgEst , "1 Abaixo Minimo"    ,,,,{||Alert("TMenuItem 01")},,,,,,,,,.T.)
	oMenuItem2 := TMenuItem():New(oDlgEst , "2 Acima do Maximo"  ,,,,{||Alert("TMenuItem 02")},,,,,,,,,.T.)
	oMenuItem3 := TMenuItem():New(oDlgEst , "3 Abaixo do Normal" ,,,,{||Alert("TMenuItem 02")},,,,,,,,,.T.)
	oMenuItem4 := TMenuItem():New(oDlgEst , "4 Normal"           ,,,,{||Alert("TMenuItem 02")},,,,,,,,,.T.)
	oMenuItem5 := TMenuItem():New(oDlgEst , "5 Todos "           ,,,,{||Alert("TMenuItem 02")},,,,,,,,,.T.)
	
	oMenuImp:Add(oMenuItem1)
	oMenuImp:Add(oMenuItem2)
	oMenuImp:Add(oMenuItem3)
	oMenuImp:Add(oMenuItem4)
	oMenuImp:Add(oMenuItem5)
	
	oMenuTra   := TMenu():New(0,0,0,0,.T.)    // Adiciona itens no Menu
	oMenuTra1  := TMenuItem():New(oDlgEst , "1 Por Fabricante"   ,,,,{||u_visp004t(1)},,,,,,,,,.T.)
	oMenuTra2  := TMenuItem():New(oDlgEst , "2 Por Loja"         ,,,,{||u_visp004t(2)},,,,,,,,,.T.)
	
	oMenuTra:Add(oMenuTra1)
	oMenuTra:Add(oMenuTra2)
	
	//                             1                2                   3                    4                          5                                                                 6     7   8      9       10     11    12    13   14    15                                       16   17
	//
	oBtnLer  := TButton():New( _nFolAlt+15 , 010            , 'Ler SAIB'                 	, oDlgEst , {|| MsgRun("Selecionando pedidos SAIB...Aguarde !","Importacao de Pedidos",{|| LERSAIB(_lRotAuto) } )   }    	, 50  , 15 , , ofontBtn2 ,      , .T. ,     ,    ,   , {|| iif((oFolder:nOption == 1),.T.,.F.)} ,    ,     )
	oBtnImp  := TButton():New( _nFolAlt+15 , 070            , 'Importar'                 	, oDlgEst , {|| MsgRun("Gravando Pedidos.....Aguarde !","Gravacao de Pedidos"         ,{|| IMPSAIB(_lRotAuto) } )   }  	, 50  , 15 , , ofontBtn2 ,      , .T. ,     ,    ,   ,                                            ,    ,     )
	oBtnSair := TButton():New( _nFolAlt+15 , aSizeEst[3]-50 , 'Sair'                    	, oDlgEst , {|| oDlgEst:end()                                                          }  	, 30  , 15 , , ofontBtn2 ,      , .T. ,     ,    ,     ,                                        ,    ,     )
	
	_cQtdLido := ""
	_oLeg   := TSay():New   ( _nFolAlt+18 , 150 , {|| _cQtdLido} , oDlgEst,  ,   ofont1     ,,,,.T., CLR_GREEN  , CLR_WHITE,100, 25)
	
	_oBrwPed:setfocus()
	_oBrwPed:refresh()
	_oBrwItem:refresh()
	oDlgEst:refresh()
	
	_oBrwPed:setfocus()
	
	oDlgEst:Activate( , , , .f. )
	
	
	SetKey(VK_F5  , {|| nil } )
	SetKey(VK_F6  , {|| nil } )
	SetKey(VK_F9  , {|| nil } )
	setkey(VK_F10 , {|| nil } )
	
	if select("SC5TMP") > 0
		SC5TMP->(dbclosearea())
	Endif
	
	if select("SC6TMP") > 0
		SC6TMP->(dbclosearea())
	Endif
	
	if file(_cTmpSC5)
		ferase(_cTmpSC5)
		ferase(_cTmpSC5I)
		ferase(_cTmpSC5F)
	Endif
	
	if file(_cTmpSC6)
		ferase(_cTmpSC6)
		ferase(_cTmpSC6I)
		ferase(_cTmpSC6F)
	Endif
	
	dbselectarea("SB1")
	
Endif 
	If !lMenu
		Reset Environment
	Endif

RestArea(aArea)
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
_oBrwPed:refresh()
_oBrwPed:setfocus()

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

_oBrwItem:gotop()
_oBrwItem:resetlen()
_oBrwItem:refresh()

dbselectarea("SC5TMP")
dbgoto(_recno)

return nil


///////////////////////////
STATIC FUNCTION LERSAIB(_lRotAuto)
//////////////////////////
local cPerg := "GDP010"

_dPrevfat := dDataBase

if dow(_dPrevfat) == 6
	_dPrevfat += 3
Else
	_dPrevfat += 1
Endif

///////////////////////////////////////
updsaib(_lRotAuto)
///////////////////////////////////////

_lPergunta := .t.

If !_lRotAuto
	
	CriaPerg(cPerg)
	
	dbSelectArea("SX1")
	dbSetOrder(1)
	
	If MsSeek(padr(cPerg,10)+"03")
		//Acerto o parametro com a database
		RecLock("SX1",.F.)
		Replace x1_cnt01		With "'"+DTOC(_dPrevfat)+"'"
		MsUnlock()
		
	Endif
	
	_lPergunta :=  pergunte(cPerg,.t.)
	
	_dPrevfat  := mv_par03
	
Endif

if _lPergunta
	
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
	
	If !_lRotAuto
		_cQry += "AND ( CONVERT(NVARCHAR(10), PEDIDO.DT_ENTREGA,112) BETWEEN '"+dtos(mv_par01-7)+"' AND '"+dtos(mv_par02+7)+"' ) "
	Endif
	
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
		
		if cC5PedSaib == padr('23024348',50)
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
		
		if cC5VlrSaib > 0 .and. ( _lRotAuto .or. ( !_lRotAuto .and. dC5Saida >= mv_par01 .and. dC5Saida <= mv_par02 ) )
			
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
				cC5Vendnom := alltrim(Posicione("SA3",1,xFilial("SA3")+cC5Vend1,"A3_NOME"))+" ("+cC5Vend1+")"
				
				nC5Comis1  := 0
				cC5Vend2   := space(6)
				nC5Comis2  := 0
				cC5Vend3   := space(6)
				nC5Comis3  := 0
				cC5Vend4   := space(6)
				nC5Comis4  := 0
				cC5Vend5   := space(6)
				nC5Comis5  := 0
/*			 COMENTADO POR RONALDO MAIA EM 18/10/2016 E SOLICITADO POR RODRIGO OTAVIO PARA DESCONTINUAR A MANSAGEM 50
				cC5Menpad  := space(3)
				cC5Mens1   := space(65)
				cC5Mens2   := space(65)
				cC5Mens3   := space(65)
				cC5Mens4   := space(65)
				cC5Mens5   := space(65)
				cC5Mens6   := space(65)
				cC5Mens7   := space(65)
				
				if sm0->m0_codigo == '05'
					
					cC5Menpad  := "50 " //space(3)
					
					dbselectarea("SZ3")
					dbsetorder(1)
					dbgotop()
					
					if dbseek( xfilial("SZ3")+cC5Menpad ,.F.)
						
						cC5Mens1   := Z3_TEXTO1
						cC5Mens2   := Z3_TEXTO2
						cC5Mens3   := Z3_TEXTO3
						cC5Mens4   := Z3_TEXTO4
						cC5Mens5   := Z3_TEXTO5
						cC5Mens6   := Z3_TEXTO6
						cC5Mens7   := Z3_TEXTO7
						
					Endif
					
				Endif
*/
				
				dbselectarea("TMPPED")
				
				cC5Mennota := cC5Vendnom //space(60)
				
				cC5Obsfat  := OBSFAT
				
				nC5Volume1 := 0
				cC5Especi1 := space(10)
				cC5Marca   := 'DUELO'
//				cC5Tiplib  := '1'
				cC5Tiplib  := '2'
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
				cC5Importa := space(1)
				dC5DtInclu := ctod('')
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
/*					SC5TMP->C5_MENPAD  := cC5Menpad - COMENTADO POR RONALDO MAIA EM 18/10/2016 E SOLICITADO POR RODRIGO OTAVIO PARA DESCONTINUAR A MENSAGEM 50
					SC5TMP->C5_MENS1   := cC5Mens1
					SC5TMP->C5_MENS2   := cC5Mens2
					SC5TMP->C5_MENS3   := cC5Mens3
					SC5TMP->C5_MENS4   := cC5Mens4
					SC5TMP->C5_MENS5   := cC5Mens5
					SC5TMP->C5_MENS6   := cC5Mens6
					SC5TMP->C5_MENS7   := cC5Mens7*/
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
					SC5TMP->C5_DTINCLU := dC5Emissao 
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
	
	dbselectarea("SC5TMP")
	
	SC5TMP->(dbgotop())
	SC6TMP->(dbgotop())
	
	If !_lRotAuto
		
		_cQtdLido := "Pedidos Lidos: "+strzero(reccount(),6)
		
		_oLeg:refresh()
		
		filsc6( SC5TMP->C5_PEDSAIB, SC5TMP->(RECNO()) )
		
		_oBrwItem:resetlen()
		_oBrwItem:refresh()
		
		_oBrwPed:setfocus()
		_oBrwPed:goposition(1)
		_oBrwPed:refresh()
		
	Endif
	
Endif

return nil

//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////
STATIC FUNCTION IMPSAIB(_lRotAuto)
//////////////////////////
local _aPedsaib := {}
Local y := 0 
dbselectarea("SC5TMP")
_nrecatu := recno()
dbgotop()

Do While ! eof()
	
	if C5_OK == "SS" .or. _lRotAuto
/*ALTERADO EM 18/10/2016 - CODIGO DO PEDIDO DE COMPRA CHEGOU EM 99999S, DESTA FORMA FOI ALTERADO PARA INICIAR OS PEDIDOS DO DIA 
  18/10/2016 PARA INICIAR COM 00001A ATÉ CHEGAR M 99999A*/
//		_cNumPed := "00001S"
//		_cNumPed := "00001A"
		_cNumPed := "00001B"
		
		DbSelectArea ("SX6")
		DbSetOrder (1)
		
		IF DbSeek("  US_PEDSAIB")
			
			_cNumPed := strzero(val(ALLTRIM(X6_CONTEUD)),5)
			
			if reclock("SX6",.F.)
				SX6->X6_CONTEUD := STRZERO(VAL(_cNumPed)+1,5)
				msunlock()
//				_cNumPed += 'S'
//				_cNumPed += 'A'				
				_cNumPed += 'B'				
				
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
			

/*
                 //RAFAEL ALMEIDA - SIGACORP (28/09/2018)
				dbselectarea("SA1")
				dbsetorder(1)
				dbgotop()
				IF dbSeek(xFilial("SA1")+SC5TMP->C5_CLIENTE+SC5TMP->C5_LOJACLI) 
					RecLock("SA1",.f.)
						SA1->A1_SALPED += SC5TMP->C5_VLRSAIB
					MsUnLock()
				EndIf
*/
			
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
			
			//if SM0->M0_CODIGO == '04'
				SC6->C6_PRCVEN := U_GDG001(SC6->C6_PRODUTO ,SC6->C6_PRCFIN, SC6->C6_CLI , SC6->C6_LOJA)
			//Else
			//	SC6->C6_PRCVEN := SC6->C6_PRCFIN
			//Endif
			
			SC6->C6_VALOR  := ROUND(SC6->C6_QTDVEN*SC6->C6_PRCVEN,2)
			SC6->C6_PRUNIT := SC6->C6_PRCVEN
			
			dbSelectArea("SC6")
			msunlock()
			
            //RAFAEL ALMEIDA - SIGACORP (28/09/2018
			If (SC6->C6_QTDVEN > 0)											
				dbselectarea("SA1")
				dbsetorder(1)
				dbgotop()
				IF dbSeek(xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA) 
					RecLock("SA1",.f.)
						SA1->A1_SALPED += (SC6->C6_QTDVEN * SC6->C6_PRCVEN)
					MsUnLock()
				EndIf
			EndIf			
			
		Endif
		
	Endif
	
	dbselectarea("SC6TMP")
	dbskip()
	
Enddo

dbselectarea("SC5TMP")
dbgoto(_nrecatu)

updsaib(_lRotAuto)

if ! _lRotAuto
	
	filsc6( SC5TMP->C5_PEDSAIB, SC5TMP->(RECNO()) )
	
	SC6TMP->(dbgotop())
	
	_oBrwPed:refresh()
	_oBrwItem:resetlen()
	_oBrwItem:refresh()
	
	_oBrwPed:setfocus()
	
Endif

return nil


//////////////////////////////////////////////////
//////////////////////////////////////////////////
static Function updsaib(_lRotAuto)
/////////////////////////////////////////////////
////////////////////////////////////////////////

if ! ( "TESTE" $ upper( alltrim( getenvserver() ) ) )
	
	if sm0->m0_codigo == '04'
		_cQry := "UPDATE SAIB.dbo.PEDIDO_RB SET CD_PEDIDO = SC5.C5_NUM "
		_cQry += "FROM SAIB.dbo.PEDIDO_RB SAIB, PROTHEUS.dbo.SC5040 SC5 "
	Else
		_cQry := "UPDATE SAIB_Lugpet.dbo.PEDIDO_RB SET CD_PEDIDO = SC5.C5_NUM "
		_cQry += "FROM SAIB_Lugpet.dbo.PEDIDO_RB SAIB, PROTHEUS.dbo.SC5050 SC5 "
	Endif
	
	_cQry += "WHERE ( CD_PEDIDO IS NULL  OR CD_PEDIDO = '') AND ( LEFT(SAIB.CD_PEDIDO_PALM,50) = left(SC5.C5_PEDSAIB,50)  COLLATE Latin1_General_CI_AS ) "
	
	If ( TCSQLExec(_cQry) < 0 )
		if _lRotAuto
			CONOUT("Houve erro na atualizacao dos dados SAIB - Erro: " + TCSQLError())
		Else
			MsgStop("Houve erro na atualizacao dos dados SAIB."+chr(10)+chr(10)+"Erro: " + TCSQLError())
		Endif
	EndIf
	
Else
	
	If _lRotAuto
		conout("Não atualizado banco de dados SAIB em ambiente TESTE")
	Else
		alert("Não atualizado banco de dados SAIB em ambiente TESTE")
	Endif
	
	
Endif

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
Local i := 0
Local j := 0  

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
