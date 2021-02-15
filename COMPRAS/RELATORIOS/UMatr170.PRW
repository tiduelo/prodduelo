#INCLUDE "UMATR170.CH"
#INCLUDE "PROTHEUS.CH"
                              
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR170  ³ Autor ³ Ricardo Berti         ³ Data ³ 05.07.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao do Boletim de Entrada                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MATR170(ExpC1,ExpN1,ExpN2)                           	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                     	          ³±±
±±³          ³ ExpN1 = Numero do registro                                 ³±±
±±³          ³ ExpN2 = Opcao selecionada                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function UMatr170(cAlias,nReg,nOpcx)

	U_UMATR3170(cAlias,nReg,nOpcx)

Return NIL
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR170R3³ Rev.  ³ Edson Maricate        ³ Data ³07.07.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao do Boletim de Entrada                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MATR17OR3(ExpC1,ExpN1,ExpN2)                           	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                     	          ³±±
±±³          ³ ExpN1 = Numero do registro                                 ³±±
±±³          ³ ExpN2 = Opcao selecionada                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGACOM                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Descri‡…o ³ PLANO DE MELHORIA CONTINUA        ³Programa   MATR170.PRX  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ITEM PMC  ³ Responsavel              ³ Data          |BOPS             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³      01  ³                          ³               |                 ³±±
±±³      02  ³Flavio Luiz Vicco         ³ 06/04/2006    |00000095603      ³±±
±±³      03  ³                          ³               |                 ³±±
±±³      04  ³                          ³               |                 ³±±
±±³      05  ³                          ³               |                 ³±±
±±³      06  ³                          ³               |                 ³±±
±±³      07  ³                          ³               |                 ³±±
±±³      08  ³Ricardo Berti		        ³ 21/08/2006    |00000105488      ³±±
±±³      09  ³                          ³               |                 ³±±
±±³      10  ³Flavio Luiz Vicco         ³ 06/04/2006    |00000095603      ³±±
±±³      10* ³Ricardo Berti		        ³ 21/08/2006    |00000105488      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
User Function UMATR3170(cAlias,nReg,nOpcx)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL wnrel  :="MATR170"
LOCAL cDesc1 := STR0001	//"Este programa ira emitir o Boletim de Entrada."
LOCAL cDesc2 := ""
LOCAL cDesc3 := ""
LOCAL cString:= "SF1"
LOCAL aArea		:= GetArea()
LOCAL aAreaSF1	:= SF1->(GetArea())

STATIC aTamSXG

PRIVATE lAuto		:= (nReg!=Nil)
PRIVATE Titulo		:= STR0002	//"Boletim de Entrada"
PRIVATE aReturn		:= {STR0003, 1,STR0004, 1, 2, 1, "",1 }		//"Zebrado"###"Administracao"
PRIVATE nomeprog	:= "MATR170"
PRIVATE nLastKey	:= 0
PRIVATE cPerg		:= If(lAuto,"","MTR170")
PRIVATE cAuxLinha	:= SPACE(132)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica conteudo da variavel Grupo de Fornecedor (001)      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTamSXG := If(aTamSXG == NIL, TamSXG("001"), aTamSXG)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjustaSx1()
Pergunte("MTR170",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utiLizadas para parametros                         ³
//³ mv_par01             // da Data                              ³
//³ mv_par02             // ate a Data                           ³
//³ mv_par03             // Nota De                              ³
//³ mv_par04             // Nota Ate                             ³
//³ mv_par05             // Imprime Centro Custo X Cta. Contabil ³
//³ mv_par06             // Imprimir o Custo ? Total ou Unit rio ³
//³ mv_par07             // Ordenar itens por? Item+Prod/ Prd+It ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:=SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,"",,"M",,!lAuto)

If nLastKey == 27
	dbClearFilter()
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	dbClearFilter()
	Return
Endif

RptStatus({|lEnd| R170Imp(@lEnd,wnrel,cString,nReg)},Titulo)


RestArea(aAreaSF1)
RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R170IMP  ³ Rev.  ³ Edson Maricate        ³ Data ³06.07.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada e impressao do Relatorio.                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR170                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R170Imp(lEnd,wnrel,cString,nReg)

Local li          := 99
LOCAL cLocDest    := GetMV("MV_CQ")
Local cForMunic   := GetMv("MV_MUNIC")
Local aDivergencia:= {}
Local aPedidos  	:= {}
Local aDescPed    := {}
Local aCQ         := {}
Local aEntCont    := {}
Local _lQtdErr    := .F.
Local _lPrcErr    := .F.
Local _QtdSal     := .F.
Local _lTes       := .F.
Local cForAnt     := 0
Local nDocAnt     := 0
Local nCt         := 0
Local nX          := 0
Local nImp        := 0
Local nRecno      := 0
Local lPedCom     := .F.
Local cQuery      := ""
Local cArqInd     := ""
Local cArqIndSD1  := ""
Local cParcIR     := ""
Local cParcINSS   := ""
Local cParcISS    := ""
Local cParcCof    := ""
Local cParcPis    := ""
Local cParcCsll   := ""
Local cParcSest   := ""
Local cPrefixo
Local aImps       := {}
Local nBasePis    := 0
Local nValPis     := 0
Local nBaseCof    := 0
Local nValCof     := 0
Local nRec        := 0 
Local aRelImp     := MaFisRelImp("MT100",{ "SF1" })
Local lFornIss    := (SE2->(FieldPos("E2_FORNISS")) > 0 .And. SE2->(FieldPos("E2_LOJAISS")) > 0)
Local cFornIss 	  := ""
Local cLojaIss    := ""
Local cRemito     := ""
Local cItemRem    := ""
Local cSerieRem   := ""
Local cFornRem    := ""
Local cLojaRem    := ""
Local cCodRem     := ""
Local cPedido     := ""
Local cItemPed    := ""
Local lQuery      := .F.
Local cDtEmis     := ""
Local i 		  := 0
Local nCtb		  := 0

Private cAliasSF1	:= "SF1"

If lAuto
	dbSelectArea("SF1")
	dbGoto(nReg)
	MV_PAR03 := SF1->F1_DOC
	MV_PAR04 := SF1->F1_DOC
	MV_PAR01 := SF1->F1_DTDIGIT
	MV_PAR02 := SF1->F1_DTDIGIT
Else
	dbSelectArea("SF1")
	dbSetOrder(1)
	#IFDEF TOP
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Query para SQL                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cQuery := "SELECT *  "
		cQuery += "FROM "	    + RetSqlName( 'SF1' )
		cQuery += " WHERE "
		cQuery += "F1_FILIAL='"    	+ xFilial( 'SF1' )	+ "' AND "
		cQuery += "F1_DTDIGIT>='"  	+ DTOS(MV_PAR01)	+ "' AND "
		cQuery += "F1_DTDIGIT<='"  	+ DTOS(MV_PAR02)	+ "' AND "
		cQuery += "F1_DOC>='"  		+ MV_PAR03			+ "' AND "
		cQuery += "F1_DOC<='"  		+ MV_PAR04			+ "' AND "
		cQuery += "NOT ("+IsRemito(3,'F1_TIPODOC')+ ") AND "
		cQuery += "D_E_L_E_T_<>'*' "
		cQuery += "ORDER BY " + SqlOrder(SF1->(IndexKey()))
		cQuery := ChangeQuery(cQuery)

		cAliasSF1 := "QRYSF1"
		dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), 'QRYSF1', .F., .T.)
		aEval(SF1->(dbStruct()),{|x| If(x[2]!="C",TcSetField("QRYSF1",AllTrim(x[1]),x[2],x[3],x[4]),Nil)})

		If ( mv_par07 == 1 )
			cArqIndSD1 := CriaTrab(,.F.)
			IndRegua( "SD1", cArqIndSD1, "D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_ITEM" )
		EndIf
		
		lQuery := .T.
	#ELSE
		If !Empty(MV_PAR03)
			SF1->(dbSeek(xFilial("SF1")+MV_PAR03,.T.))
		Else
			cArqInd   := CriaTrab( , .F. )
			cQuery := "F1_FILIAL=='"	   	+xFilial("SF1")	+"'.AND."
			cQuery += "DTOS(F1_DTDIGIT)>='"	+DTOS(MV_PAR01)	+"'.AND."
			cQuery += "DTOS(F1_DTDIGIT)<='"	+DTOS(MV_PAR02)	+"'.AND."
			cQuery += "F1_DOC >= '"  	   	+MV_PAR03		+"'.AND."
			cQuery += "F1_DOC <= '"  		+MV_PAR04		+"'"
			cQuery += ".AND. !("+IsRemito(2,'SF1->F1_TIPODOC')+")"

			IndRegua( "SF1", cArqInd, IndexKey(), , cQuery )
			SF1->( dbSetIndex( cArqInd + OrdBagExt() ) )
		EndIf

		If ( mv_par07 == 1 )
			cArqIndSD1 := CriaTrab(,.F.)
			IndRegua( "SD1", cArqIndSD1, "D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_ITEM" )
			SD1->( dbSetIndex( cArqIndSD1 + OrdBagExt() ) )
		EndIf
		
		lQuery := .F.
	#ENDIF
EndIf

If !lAuto
	(cAliasSF1)->(dbGoTop())
EndIf

SF1->(SetRegua(LastRec()))
While ( (cAliasSF1)->(!Eof()) .And. (cAliasSF1)->F1_FILIAL == xFilial("SF1") .And.;
		((cAliasSF1)->F1_DOC <= MV_PAR04) )

	IncRegua()
	aCQ	:= {}
	If lEnd
		@PROW()+1,001 PSAY STR0005		//"CANCELADO PELO OPERADOR"
		Exit
	Endif

	dbSelectArea(cAliasSF1)
	If !Empty(aReturn[7]) .And. !&(aReturn[7])
		(cAliasSF1)->(dbSkip())
		Loop
	EndIf
	If (cAliasSF1)->F1_DTDIGIT < MV_PAR01 .OR. (cAliasSF1)->F1_DTDIGIT > MV_PAR02
		(cAliasSF1)->(dbSkip())
		Loop
	EndIf

	If (cAliasSF1)->F1_DOC < MV_PAR03 .or. (cAliasSF1)->F1_DOC > MV_PAR04
		(cAliasSF1)->(dbSkip())
		Loop
	EndIf

	If (lAuto .And. (cAliasSF1)->(Recno()) <> nReg)
		(cAliasSF1)->(dbSkip())
		Loop
	EndIf
	cDtEmis  := (cAliasSF1)->F1_EMISSAO

	If lQuery
		dbSelectArea("SF1")
		dbSeek(xFilial("SF1")+(cAliasSF1)->F1_DOC+(cAliasSF1)->F1_SERIE+(cAliasSF1)->F1_FORNECE+(cAliasSF1)->F1_LOJA)
	EndIf
	
	dbSelectArea("SD1")
	dbSeek(xFilial("SD1")+(cAliasSF1)->F1_DOC+(cAliasSF1)->F1_SERIE+(cAliasSF1)->F1_FORNECE+(cAliasSF1)->F1_LOJA)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do Cabecalho.                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea(cAliasSF1)
	If li > 20
		li :=  U_UR170Cabec()
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao dos itens da Nota de Entrada.                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SD1")
	nCt     := 1
	nDocAnt := D1_DOC+D1_SERIE
	cForAnt := D1_FORNECE+D1_LOJA
	aDivergencia := {}
	aPedidos     := {}
	aDescPed     := {}
	aEntCont     := {}

	//                                 1         2         3         4         5         6         7         8         9        10        11        12        13
	//                         012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
	//                         999999999999999 XX XXXXXXXXXXXXXXXXXXXX 99999999.99 99,999,999.99 999,999,999.99  99  99 12345678901234567890 999 9999 99,999,999.99
	//                         999999999999999 XX XXXXXXXXXXXXXXXXX XX 99999999.99 99,999,999.99 999,999,999.99  99  99 12345678901234567890 999 9999 99,999,999.99
	If mv_par05 <> 3
		If mv_par08 == 1
			cLinha :=         "               |  |                 |  |           |            |            |     |     |                    |   |     |             "
		Else
			cLinha :=         "               |  |                    |           |            |            |     |     |                    |   |     |             "
		EndIf
	Else
		If mv_par08 == 1
			cLinha :=         "               |  |                 |  |           |            |            |     |     |   |     |             "
		Else
			cLinha :=         "               |  |                    |           |            |            |     |     |   |     |             "	
		EndIf
	EndIf
	@ li,000 PSAY __PrtThinLine()
	li += 1
	@ li,000 PSAY STR0006 // "-------------------------------------------------------- DADOS DA NOTA FISCAL -------------------------------------------------------"
	li += 1
	@ li,000 PSAY If(mv_par08==1,If(cPaisLoc<>"BRA",STR0064,STR0063),If(cPaisLoc<>"BRA",STR0044,STR0007))+If(mv_par05==1,"   "+STR0009+If(cPaisLoc=="BRA"," ","")+"  |",If(mv_par05==2,"   "+STR0010+If(cPaisLoc=="BRA"," ","")+"   |",""))+STR0011+If(mv_par06==2,STR0012,STR0013)+STR0124  //"Codigo Material|UN|Descr. da Mercadoria|Quantidade |Vlr. Unitario| Valor Total  |IPI|ICM|   "###"Conta Contabil"###"Centro  Custo "###"   |TES  |CFOP|"###"Custo Unit. "###"Custo Total "
	li += 1

	While ( !Eof() .And. SD1->D1_DOC+SD1->D1_SERIE == nDocAnt .And.;
		cForAnt == SD1->D1_FORNECE+SD1->D1_LOJA .And.;
		SD1->D1_FILIAL == xFilial("SD1") )

		If li >= 60
			li := 1
			@ li,000 PSAY STR0085 //"------------------------------------------------------- ITENS DA NOTA FISCAL ----------------------------------------------------"
			li += 1
			@ li,000 PSAY If(mv_par08==1,If(cPaisLoc<>"BRA",STR0064,STR0063),If(cPaisLoc<>"BRA",STR0044,STR0007))+If(mv_par05==1,"   "+STR0009+If(cPaisLoc=="BRA"," ","")+"  |",If(mv_par05==2,"   "+STR0010+If(cPaisLoc=="BRA"," ","")+"   |",""))+STR0011+If(mv_par06==2,STR0012,STR0013)+STR0124  //"Codigo Material|UN|Descr. da Mercadoria|Quantidade |Vlr. Unitario| Valor Total  |IPI|ICM|   "###"Conta Contabil"###"Centro  Custo "###"   |TES  |CFOP|"###"Custo Unit. "###"Custo Total "
			li += 1
			@ li,000 PSAY __PrtThinLine()
			li += 1
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona Todos os Arquivos Ref. ao Itens                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+SD1->D1_COD)

		dbSelectArea("SF4")
		dbSetOrder(1)
		dbSeek(xFilial("SF4")+SD1->D1_TES)

		cPedido   := SD1->D1_PEDIDO
		cItemPed  := SD1->D1_ITEMPC			
        
		If cPaisLoc <> "BRA" .And. !Empty(SD1->D1_REMITO)
			cRemito   := SD1->D1_REMITO
			cItemRem  := SD1->D1_ITEMREM
			cSerieRem := SD1->D1_SERIREM
			cFornRem  := SD1->D1_FORNECE
			cLojaRem  := SD1->D1_LOJA
			cCodRem	  := SD1->D1_COD
		
			aArea := SD1->(GetArea())
		
			dbSelectArea("SD1")
			SD1->(dbSetOrder(1))
			If SD1->(dbSeek(xFilial("SD1")+cRemito+cSerieRem+cFornRem+cLojaRem+cCodRem+Alltrim(cItemRem))) .And. !Empty(SD1->D1_PEDIDO)
				cPedido   := SD1->D1_PEDIDO
				cItemPed  := SD1->D1_ITEMPC			
			Endif
			RestArea(aArea)
		Endif		
         
		dbSelectArea("SC7")
		dbSetOrder(19)
		If dbSeek(xFilial("SC7")+SD1->D1_COD+cPedido+cItemPed)
			dbSelectArea("SC1")
			dbSetOrder(2)
			dbSeek(xFilial("SC1")+SC7->C7_PRODUTO+SC7->C7_NUMSC+SC7->C7_ITEMSC)

			dbSelectArea("SE4")
			dbSetOrder(1)
			dbSeek(xFilial("SE4")+SC7->C7_COND)

			lPedCom := !Empty(IF(SC7->C7_TIPO == 1,SubStr(SC1->C1_SOLICIT,1,15), SubStr(UsrFullName(SC7->C7_USER),1,15))+SC7->C7_CC)

			cProblema := ""
			If ( SD1->D1_QTDPEDI > 0 .And. (SC7->C7_QUANT <> SD1->D1_QTDPEDI) ) .Or. SC7->C7_QUANT <> SD1->D1_QUANT
				cProblema += "Q"
				_lQtdErr := .T.
			Else
				cProblema += " "
			EndIf
			If (SC7->C7_QUANT - SC7->C7_QUJE) < SD1->D1_QUANT  .AND. SD1->D1_TES == "   "
				_QtdSal := .T.
				n_proc1 :=-(SD1->D1_QUANT - (SC7->C7_QUANT - SC7->C7_QUJE)) / SC7->C7_QUANT * 100
			EndIf
			If SD1->D1_TES != "   " .AND. (SC7->C7_QUANT - SC7->C7_QUJE) < 0
				_QtdSal := .T.
				N_PORC1 :=-(SC7->C7_QUANT - SC7->C7_QUJE) / SC7->C7_QUANT * 100
			EndIf
			If IIf(Empty(SC7->C7_REAJUSTE),SC7->C7_PRECO,Formula(SC7->C7_REAJUSTE)) # SD1->D1_VUNIT
				If SC7->C7_MOEDA <> 1
					cProblema := cProblema+"M"
				Else
					cProblema := cProblema+"P"
				EndIf
				_lPrcErr := .T.
			Else
				cProblema := cProblema+" "
			EndIf
			If SC7->C7_DATPRF <> SD1->D1_DTDIGIT
				cProblema := cProblema+"E"
			Else
				cProblema := cProblema+" "
			EndIf
			If !Empty(cProblema)
				aADD(aDivergencia,cProblema)
			Else
				aADD(aDivergencia,"Ok ")
			Endif
			aADD(aPedidos,{SC7->C7_NUM+"/"+SC7->C7_ITEM,;
				SC7->C7_DESCRI,;
				TransForm(SC7->C7_QUANT,PesqPict("SC7","C7_QUANT",11)),;
				TransForm(SC7->C7_PRECO,PesqPict("SC7","C7_PRECO",13)),;
				DTOC(SC7->C7_EMISSAO),;
				DTOC(SC7->C7_DATPRF),;
				SC7->C7_NUMSC+"/"+SC7->C7_ITEMSC,;
				If(lPedCom,IF(SC7->C7_TIPO == 1,SubStr(SC1->C1_SOLICIT,1,15), SubStr(UsrFullName(SC7->C7_USER),1,15)),"") ,;
				If(lPedCom,SC7->C7_CC,""),;
				AllTrim(SE4->E4_DESCRI)} )
		Else
			aADD(aDivergencia,STR0079) //"Err"
			aADD(aPedidos,{"",STR0014,"","","","","","","",""}) //"Sem Pedido de Compra"
		Endif

		If !Empty(SD1->D1_NUMCQ) .AND. SF4->F4_ESTOQUE == "S"
			AADD(aCQ,SD1->D1_NUMCQ+SD1->D1_COD+cLocDest+"001"+DTOS(SD1->D1_DTDIGIT))
		Endif

		U_UR170Load(0,cLinha)
		U_UR170Load(0,SD1->D1_COD)
		U_UR170Load(16,SD1->D1_UM)
		If mv_par08 == 1
			U_UR170Load(19,SubStr(SB1->B1_DESC,1,17))
			U_UR170Load(37,SubStr(SD1->D1_LOCAL,1,2))
		Else
			U_UR170Load(19,SubStr(SB1->B1_DESC,1,20))
		EndIf
		U_UR170Load(40,Transform(SD1->D1_QUANT,PesqPict("SD1","D1_QUANT",11)))
		U_UR170Load(52,TransForm(SD1->D1_VUNIT,PesqPict("SD1","D1_VUNIT",12)))
		If cPaisLoc=="BRA"
			U_UR170Load(65,Transform(SD1->D1_TOTAL,PesqPict("SD1","D1_TOTAL",12)))
			U_UR170Load(78,Transform(SD1->D1_IPI,PesqPict("SD1","D1_IPI",5)))
			U_UR170Load(84,Transform(SD1->D1_PICM,PesqPict("SD1","D1_PICM",5)))
		Else
			U_UR170Load(73,Transform(SD1->D1_TOTAL,PesqPict("SD1","D1_TOTAL",14)))
		EndIf
		If mv_par05 == 1
			U_UR170Load(90,SD1->D1_CONTA)
		ElseIf mv_par05 == 2
			U_UR170Load(90,SD1->D1_CC)
		Endif

		If (( mv_par05 == 1 ) .Or. ( mv_par05 == 2 ))
			U_UR170Load(111,(SD1->D1_TES))
			U_UR170Load(115,SD1->D1_CF)
			If mv_par06 = 1
				U_UR170Load(121,Transform(SD1->D1_CUSTO,PesqPict("SD1","D1_CUSTO",14)))
				U_UR170Load(137,('|'+Alltrim(GetAdvFVal("SF4", "F4_ESTOQUE",xFilial("SF4") + SD1->D1_TES ,1))))
			Else
				U_UR170Load(121,Transform((SD1->D1_CUSTO/SD1->D1_QUANT),PesqPict("SD1","D1_CUSTO",14)))
				U_UR170Load(137,('|'+Alltrim(GetAdvFVal("SF4", "F4_ESTOQUE",xFilial("SF4") + SD1->D1_TES ,1))))
			EndIf
		Else
			U_UR170Load(90,(SD1->D1_TES))
			U_UR170Load(94,SD1->D1_CF)
			If mv_par06 = 1
				U_UR170Load(100,Transform(SD1->D1_CUSTO,PesqPict("SD1","D1_CUSTO",14)))
				U_UR170Load(116,('|'+Alltrim(GetAdvFVal("SF4", "F4_ESTOQUE",xFilial("SF4") + SD1->D1_TES ,1))))
			Else
				U_UR170Load(100,Transform((SD1->D1_CUSTO/SD1->D1_QUANT),PesqPict("SD1","D1_CUSTO",14)))
				U_UR170Load(116,('|'+Alltrim(GetAdvFVal("SF4", "F4_ESTOQUE",xFilial("SF4") + SD1->D1_TES ,1))))
			EndIf
		EndIf
		
		U_UR170Say(Li)

		Li := Li + 1
		If !Empty(SD1->D1_TES)
			_lTES := .T.
		EndIf

		If mv_par08 == 1
			_nCntTam := 18
			While !(AllTrim(SubStr(SB1->B1_DESC,_nCntTam))=="")
				U_UR170Load(0,cLinha)
				U_UR170Load(19,SubStr(SB1->B1_DESC,_nCntTam,17))
				_nCntTam := _nCntTam + 17
				U_UR170Say(Li)
				Li := Li + 1
			EndDo
		Else
			_nCntTam := 21
			While !(AllTrim(SubStr(SB1->B1_DESC,_nCntTam))=="")
				U_UR170Load(0,cLinha)
				U_UR170Load(19,SubStr(SB1->B1_DESC,_nCntTam,20))
				_nCntTam := _nCntTam + 20
				U_UR170Say(Li)
				Li := Li + 1
			EndDo
		EndIf

		If ( mv_par05 == 3 )
			If ( SD1->D1_RATEIO == "1" )
				dbSelectArea("SDE")
				dbSetOrder(1)
				If MsSeek(xFilial("SDE")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_ITEM)
					While !Eof() .And. DE_FILIAL+DE_DOC+DE_SERIE+DE_FORNECE+DE_LOJA+DE_ITEMNF ==;
						xFilial("SDE")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_ITEM
						aAdd(aEntCont,{SDE->DE_ITEMNF,SDE->DE_ITEM,SDE->DE_PERC,SDE->DE_CC,SDE->DE_CONTA,SDE->DE_ITEMCTA,SDE->DE_CLVL})
						dbSelectArea("SDE")
						dbSkip()
					EndDo
				EndIf
			Else
				If !Empty(SD1->D1_CC) .Or. !Empty(SD1->D1_CONTA) .Or. !Empty(SD1->D1_ITEMCTA)
					aAdd(aEntCont,{SD1->D1_ITEM," - ","   -   ",SD1->D1_CC,SD1->D1_CONTA,SD1->D1_ITEMCTA,SD1->D1_CLVL})
				EndIf
			EndIf
		EndIf

		dbSelectArea("SD1")
		dbSkip()
	End

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime Entidades Contabeis ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(aEntCont) > 0
		If Li >= 60
			Li := 1
		Endif
		@ li,000 PSAY __PrtThinLine()
		li += 1
		cLinha :=   "        |      |       |                 |                      |            |              "
		@ Li, 0 PSAY STR0061  //"------------------------------------------------------- ENTIDADES CONTABEIS ---------------------------------------------------------"
		li += 1
		@ Li,000 PSAY STR0062 //"Item NF | Item | % Rat | Centro de Custo | Conta Contabil       | Item Conta | Classe Valor "
		li += 1

		For nX:=1 to Len(aEntCont)
			If Li >= 60
				Li := 1
				cLinha :=   "        |      |       |                 |                      |            |              "
				@ Li, 0 PSAY STR0061  //"------------------------------------------------------- ENTIDADES CONTABEIS ---------------------------------------------------------"
				li += 1
				@ Li,000 PSAY STR0062 //"Item NF | Item | % Rat | Centro de Custo | Conta Contabil       | Item Conta | Classe Valor "
				li += 1
			Endif
			U_UR170Load(0,cLinha)
			U_UR170Load(0,aEntCont[nX][1])
			U_UR170Load(10,aEntCont[nX][2])
			U_UR170Load(16,If(ValType(aEntCont[nX][3])=="N",Transform(aEntCont[nX][3],"@E 999.99"),aEntCont[nX][3]))
			U_UR170Load(25,aEntCont[nX][4])
			U_UR170Load(43,aEntCont[nX][5])
			U_UR170Load(66,aEntCont[nX][6])
			U_UR170Load(79,aEntCont[nX][7])
			U_UR170Say(Li)
			li += 1
		Next nX
		aEntCont := {}
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime produtos enviados ao Controle de Qualidade SD7       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If Len(aCQ) > 0
		If Li >= 60
			Li := 1
		Endif
		li += 1
		//                               1         2         3         4         5         6         7         8         9        10        11        12        13
		//                     012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
		//                     XXXXXXXXXXXXXXX                    XX                               XX                      99/99/9999                        999999
		cLinha :=    "                     |                               |                            |                           |                     "
		@ Li, 0 PSAY STR0015 //"------------------------------------------- PRODUTO(s) ENVIADO(s) AO CONTROLE DE QUALIDADE -----------------------------------------"
		li += 1
		@ Li,000 PSAY STR0016 //"Produto              |         Local Origem          |        Local Destino       |    Data Transferencia     |     Numero do CQ.   "
		li += 1

		For nX:=1 to Len(aCQ)
			If Li >= 60
				Li := 1
				//                               1         2         3         4         5         6         7         8         9        10        11        12        13
				//                     012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
				//                     XXXXXXXXXXXXXXX                    XX                               XX                      99/99/9999                        999999
				cLinha :=    "                     |                               |                            |                           |                     "
				@ Li, 0 PSAY STR0015 //"------------------------------------------- PRODUTO(s) ENVIADO(s) AO CONTROLE DE QUALIDADE -----------------------------------------"
				li += 1
				@ Li,000 PSAY STR0016 //"Produto              |         Local Origem          |        Local Destino       |    Data Transferencia     |     Numero do CQ.   "
				li += 1
			Endif
			dbSelectArea("SD7")
			dbSetOrder(1)
			dbSeek(xFilial("SD7")+aCQ[nX])
			If Found()
				U_UR170Load(0,cLinha)
				U_UR170Load(0,SD7->D7_PRODUTO)
				U_UR170Load(34,SD7->D7_LOCAL)
				U_UR170Load(68,SD7->D7_LOCDEST)
				U_UR170Load(92,DTOC(SD7->D7_DATA))
				U_UR170Load(123,SD7->D7_NUMERO)
				U_UR170Say(Li)
				li += 1
			Endif
		Next nX
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime Divergencia com Pedido de Compra.                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Li := Li + 1
	//                            1         2         3         4         5         6         7         8         9        10        11        12        13
	//                  012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
	//                   123 123456-12 12345678901234567890 99999999,99|99.999.999,99 99/99/9999 99/99/9999 999999/99 xxxxxxxxxxxx 999999999
	If cPaisLoc == "BRA"
		cLinha  :=    "   |           |                  |           |             |          |          |         |               |         |             "
	Else
		cLinha  :=    "   |           |                    |           |             |          |          |            |               |         |             "
	EndIf
	@ li,000 PSAY __PrtThinLine()
	Li += 1
	@ Li,000 PSAY STR0019 //"--------------------------------------------- DIVERGENCIAS COM O PEDIDO DE COMPRA --------------------------------------------------"
	Li += 1
	@ Li,000 PSAY If(cPaisLoc=="BRA",STR0020,STR0058) //"Div|Numero   |Descricao do Produto|Quantidade |Preco Unitar.| Emissao  | Entrega  |   S.C.  |Solicitante    | C.Custo |Cond.Pagto   "
	Li += 1
	If !Empty(aPedidos) .And. !Empty(aDivergencia)
		For nX := 1 To Len(aPedidos)
			If Li > 60
				Li := 0
				@ Li,000 PSAY STR0019 //"--------------------------------------------- DIVERGENCIAS COM O PEDIDO DE COMPRA --------------------------------------------------"
				Li += 1
				@ Li,000 PSAY If(cPaisLoc=="BRA",STR0020,STR0058) //"Div|Numero   |Descricao do Produto|Quantidade |Preco Unitar.| Emissao  | Entrega  |   S.C.  |Solicitante    | C.Custo |Cond.Pagto   "
				Li += 1
			EndIf
			U_UR170Load(0,cLinha)
			U_UR170Load(0,aDivergencia[nX])
			U_UR170Load(4,aPedidos[nX][1])
			If cPaisLoc == "BRA"
				U_UR170Load(16,AllTrim(Substr(aPedidos[nX][2],1,18)))
				U_UR170Load(35,aPedidos[nX][3])
				U_UR170Load(47,aPedidos[nX][4])
				U_UR170Load(61,aPedidos[nX][5])
				U_UR170Load(72,aPedidos[nX][6])
				U_UR170Load(83,aPedidos[nX][7])
				U_UR170Load(93,aPedidos[nX][8])
				U_UR170Load(109,aPedidos[nX][9])
				U_UR170Load(119,aPedidos[nX][10])
			Else
				U_UR170Load(16,AllTrim(Substr(aPedidos[nX][2],1,18)))
				U_UR170Load(37,aPedidos[nX][3])
				U_UR170Load(49,aPedidos[nX][4])
				U_UR170Load(63,aPedidos[nX][5])
				U_UR170Load(74,aPedidos[nX][6])
				U_UR170Load(85,aPedidos[nX][7])
				U_UR170Load(98,aPedidos[nX][8])
				U_UR170Load(114,aPedidos[nX][9])
				U_UR170Load(124,aPedidos[nX][10])
			EndIf
			U_UR170Say(Li)
			Li += 1
			_nCntTam := 19
			While !(AllTrim(SubStr(aPedidos[nX][2],_nCntTam)) == "")
				U_UR170Load(0,cLinha)
				U_UR170Load(16,SubStr(aPedidos[nX][2],_nCntTam,18))
				U_UR170Say(Li)
				_nCntTam := _nCntTam + 18
				Li += 1
			End
		Next nX
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime Totais da Nota Fiscal                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If Li >= 60
		Li := 1
	Endif
	dbSelectArea(cAliasSF1)
	@ li,000 PSAY __PrtThinLine()
	Li += 1
	@ Li,000 PSAY STR0023 //"------------------------------------------------------- TOTAIS DA NOTA FISCAL ------------------------------------------------------"
	Li += 1
	//                             1         2         3         4         5         6         7         8         9        10        11        12        13
	//                   012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
	//                      999,999,999,999.99    999,999,999,999.99    999,999,999,999.99    999,999,999,999.99      999,999,999,999.99   999,999,999,999.99
	If cPaisLoc=="BRA"
		cLinha  :=     "                     |                     |                     |                      |                        |                  "
	Else
		cLinha  :=     "                     |                     |                                            |                        |                  "
	EndIf
	@ Li,000 PSAY If(cPaisLoc<>"BRA",STR0046,STR0024) //" BASE DE CALCULO ICMS|  VALOR DO ICMS      |BASE CALC.ICMS SUBST.|  VALOR ICMS SUBST.   |VALOR TOTAL DOS PRODUTOS|    DESCONTOS     "
	Li += 1
	U_UR170Load(0,cLinha)
	If cPaisLoc=="BRA"
		U_UR170Load(003,Transform((cAliasSF1)->F1_BASEICM,"@E 999,999,999,999.99"))
		U_UR170Load(025,Transform((cAliasSF1)->F1_VALICM, "@E 999,999,999,999.99"))
		U_UR170Load(047,Transform((cAliasSF1)->F1_BRICMS, "@E 999,999,999,999.99"))
		U_UR170Load(069,Transform((cAliasSF1)->F1_ICMSRET,"@E 999,999,999,999.99"))
	Else
		aImps:=R170IMPT(cAliasSF1)
		U_UR170Load(003,Transform(aImps[1],"@E 999,999,999,999.99")) // Base de imposto
		U_UR170Load(025,Transform(aImps[2],"@E 999,999,999,999.99")) // Valor do Imposto
	EndIf
	U_UR170Load(093,Transform((cAliasSF1)->F1_VALMERC,"@E 999,999,999,999.99"))
	U_UR170Load(114,Transform((cAliasSF1)->F1_DESCONT,"@E 999,999,999,999.99"))
	U_UR170Say(Li)
	Li += 1
	@ Li,000 PSAY __PrtThinLine()
	Li += 1
	cLinha  :=    "                        |                         |                        |                         |                             "
	@ Li,000 PSAY If(cPaisLoc<>"BRA",STR0045,STR0025) //"  VALOR DO FRETE        |      VALOR DO SEGURO    | OUTRAS DESPESAS ACESSO.|   VALOR TOTAL DO IPI    |   VALOR TOTAL DA NOTA       "
	Li += 1
	U_UR170Load(0,cLinha)
	U_UR170Load(001,Transform((cAliasSF1)->F1_FRETE,  "@E 99,999,999,999,999.99"))
	U_UR170Load(027,Transform((cAliasSF1)->F1_SEGURO, "@E 99,999,999,999,999.99"))
	U_UR170Load(053,Transform((cAliasSF1)->F1_DESPESA,"@E 99,999,999,999,999.99"))
	If cPaisLoc=="BRA"
		U_UR170Load(079,Transform((cAliasSF1)->F1_VALIPI, "@E 99,999,999,999,999.99"))
		U_UR170Load(108,Transform((cAliasSF1)->F1_VALBRUT,"@E 99,999,999,999,999.99"))
	Else
		U_UR170Load(079,Transform((cAliasSF1)->F1_VALBRUT,"@E 99,999,999,999,999.99"))
	EndIf
	U_UR170Say(Li)
	Li += 1
	@ Li,000 PSAY __PrtThinLine()
	Li += 1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime desdobramento de Duplicatas.                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aFornece := {{(cAliasSF1)->F1_FORNECE,(cAliasSF1)->F1_LOJA,PadR(MVNOTAFIS,Len(SE2->E2_TIPO))},;
   				{PadR(GetMv('MV_UNIAO')  ,Len(SE2->E2_FORNECE)),PadR(Replicate('0',Len(SE2->E2_LOJA)),Len(SE2->E2_LOJA)),PadR(MVTAXA,Len(SE2->E2_TIPO))},;
				{PadR(GetMv('MV_FORINSS'),Len(SE2->E2_FORNECE)),PadR('00',Len(SE2->E2_LOJA)),PadR(MVINSS,Len(SE2->E2_TIPO))},;
				{PadR(GetMv('MV_MUNIC')  ,Len(SE2->E2_FORNECE)),PadR('00',Len(SE2->E2_LOJA)),PadR(MVISS ,Len(SE2->E2_TIPO))}}  
	If SE2->(FieldPos("E2_PARCSES")) > 0
		aadd(aFornece,{PadR(GetNewPar('MV_FORSEST',''),Len(SE2->E2_FORNECE)),PadR(IIf(SubStr(GetNewPar('MV_FORSEST',''),Len(SE2->E2_FORNECE)+1)<>"",SubStr(GetNewPar('MV_FORSEST',''),Len(SE2->E2_FORNECE)+1),"00"),Len(SE2->E2_LOJA)),PadR('SES',Len(SE2->E2_TIPO)),"E2_PARCSES",{ || .T. }})
	EndIf


	cPrefixo := If(Empty((cAliasSF1)->F1_PREFIXO),&(GetMV("MV_2DUPREF")),(cAliasSF1)->F1_PREFIXO)
	dbSelectArea("SE2")
	dbSetOrder(6)
	dbSeek(xFilial("SE2")+(cAliasSF1)->F1_FORNECE+(cAliasSF1)->F1_LOJA+cPrefixo+(cAliasSF1)->F1_DOC)
	
 	nRec:=RECNO()
			//Verifica se o Fornecedor do Titulo ja existe no aFornec // 
	IF dbSeek(xFilial("SE2")+cForMunic) 
   		While !Eof().and. alltrim(SE2->E2_FORNECE) == alltrim(cForMunic)
   		   	IF Ascan(aFornece,{|x| (alltrim(x[1])+alltrim(x[2])) == (alltrim(cForMunic)+alltrim(SE2->E2_LOJA))}) = 0
   		 		aAdd(aFornece, {PadR(GetMv('MV_MUNIC'),Len(SE2->E2_FORNECE)),SE2->E2_LOJA,PadR(MVISS ,Len(SE2->E2_TIPO))} )
   	   		EndIf
	  	 	DBSkip()
		EndDo 
	EndIF 
	  
	dbGoto(nRec) 
	
		Li += 1
		If Li >= 60
			Li := 1
		Endif
		//                               1         2         3         4         5         6         7         8         9        10        11        12        13
		//                     012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
		//                      123 123456789012A 99/99/9999 99,999,999,999.99                            123 123456789012A 99/99/99   99,999,999,999.99 xxxxxxxxxx
		@ Li,000 PSAY STR0026 //"--------------------------------------------------- DESDOBRAMENTO DE DUPLICATAS ----------------------------------------------------"
		Li += 1
		If cPaisLoc=="MEX"
			cLinha :=     "   |                     |          |                 |           ||   |                     |          |                 |         "
		Else
			cLinha :=     "   |             |          |                 |                   ||   |             |          |                 |                 "
		EndIf

		@ Li,000 PSAY If(cPaisLoc=="MEX",STR0109,STR0027) //"Ser|Titulo/Parc. | Vencto   |Valor do Titulo  | Natureza          ||Ser|Titulo/Parc. | Vencto   |Valor do Titulo  | Natureza        "
		Li += 1

		Col := 0
		U_UR170Load(0,cLinha)

		dbSelectArea('SE2')
		dbSetOrder(6)
		dbSeek(xFilial('SE2')+aFornece[1][1]+aFornece[1][2]+cPrefixo+(cAliasSF1)->F1_DOC)

		While !Eof() .And. xFilial('SE2')+aFornece[1][1]+aFornece[1][2]+cPrefixo+(cAliasSF1)->F1_DOC==;
			E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM

			If SE2->E2_TIPO == aFornece[1,3]

				R170Dupl(@Li,@Col)
				cParcCSS := SE2->E2_PARCCSS
				cParcIR  := SE2->E2_PARCIR
				cParcINSS:= SE2->E2_PARCINS
				cParcISS := SE2->E2_PARCISS
				cParcCof := SE2->E2_PARCCOF
				cParcPis := SE2->E2_PARCPIS
				cParcCsll:= SE2->E2_PARCSLL
				If lFornIss .And. !Empty(SE2->E2_FORNISS) .And. !Empty(SE2->E2_LOJAISS)
					cFornIss := SE2->E2_FORNISS
					cLojaIss := SE2->E2_LOJAISS
				Else
					cFornIss := aFornece[4,1]
					cLojaIss :=	aFornece[4,2]
				Endif
				cParcSest := IIf(SE2->(FieldPos("E2_PARCSES"))>0,SE2->E2_PARCSES,"")				

				nRecno   := SE2->(Recno())

				dbSelectArea('SE2')
				dbSetOrder(1)
				If (!Empty(cParcIR)).And.dbSeek(xFilial('SE2')+cPrefixo+(cAliasSF1)->F1_DOC+cParcIR+aFornece[2,3]+aFornece[2,1]+aFornece[2,2])
					R170Dupl(@Li,@Col)
				Endif
				If (!Empty(cParcINSS)).And.dbSeek(xFilial('SE2')+cPrefixo+(cAliasSF1)->F1_DOC+cParcINSS+aFornece[3,3])
					R170Dupl(@Li,@Col)
				Endif
				
				For i=1 to Len(aFornece)
					If AllTrim(aFornece[i,1])==alltrim(cForMunic)
						If (!Empty(cParcISS)).And.dbSeek(xFilial('SE2')+cPrefixo+(cAliasSF1)->F1_DOC+cParcISS+aFornece[i,3]+cFornIss+aFornece[i,2])
						    IF cDtEmis == SE2->E2_EMISSAO
								R170Dupl(@Li,@Col)
						   	EndIf
						EndIf
					EndIf   
				Next i
					
				If (!Empty(cParcCof)).And.dbSeek(xFilial('SE2')+cPrefixo+(cAliasSF1)->F1_DOC+cParcCof+aFornece[2,3])
					R170Dupl(@Li,@Col)
				Endif
				If (!Empty(cParcPis)).And.dbSeek(xFilial('SE2')+cPrefixo+(cAliasSF1)->F1_DOC+cParcPis+aFornece[2,3])
					R170Dupl(@Li,@Col)
				Endif
				If (!Empty(cParcCsll)).And.dbSeek(xFilial('SE2')+cPrefixo+(cAliasSF1)->F1_DOC+cParcCsll+aFornece[2,3])
					R170Dupl(@Li,@Col)
				Endif

				If (!Empty(cParcCSS)).And.dbSeek(xFilial('SE2')+cPrefixo+(cAliasSF1)->F1_DOC+cParcCSS+aFornece[2,3])
					While !Eof() .And. xFilial('SE2')+cPrefixo+(cAliasSF1)->F1_DOC+cParcCSS+aFornece[2,3] ==;
							SE2->E2_FILIAL+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO

						If PadR(GetMv('MV_CSS'),Len(SE2->E2_NATUREZ)) == SE2->E2_NATUREZ
							R170Dupl(@Li,@Col)
						EndIf

						dbSelectArea('SE2')
						dbSetOrder(1)
						dbSkip()
					EndDo
				Endif
				If (!Empty(cParcSest)).And.dbSeek(xFilial('SE2')+cPrefixo+(cAliasSF1)->F1_DOC+cParcSest+aFornece[5,3])
					R170Dupl(@Li,@Col)
				Endif				

				SE2->(dbGoto(nRecno))

			EndIf

			dbSelectArea('SE2')
			dbSetOrder(6)
			dbSkip()
		EndDo

		U_UR170Say(Li)
		Li += 1
		@ Li,000 PSAY __PrtThinLine()
		Li += 1

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime Dados do Livros Fiscais.                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cPaisloc=="BRA"
		dbSelectArea("SF3")
		dbSetOrder(4)
		dbSeek(xFilial("SF3")+(cAliasSF1)->F1_FORNECE+(cAliasSF1)->F1_LOJA+(cAliasSF1)->F1_DOC+(cAliasSF1)->F1_SERIE)
		If Found()
			Li += 1
			If Li >= 60
				Li := 1
			Endif
			//                                    1         2         3         4         5         6         7         8         9        10        11        12        13
			//                           012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
			//                            xxx xxxx  99  99,999,999,999.99 999,999,999,999.99 999,999,999,999.99 999,999,999,999.99 999,999,999,999.99       9,999,999,999.99

			@ Li,000 PSAY STR0030 //"----------------------------------------------- DEMONSTRATIVO DOS LIVROS FISCAIS ---------------------------------------------------"
			Li += 1
			@ Li,000 PSAY STR0031 //"|                               |   Operacoes c/ credito de Imposto   |            Operacoes s/ credito de Imposto                 |"
			Li += 1
			//                                 1         2         3         4         5         6         7         8         9        10        11        12        13
			//                       012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
			//                        xxxx xxxx  99   9,999,999,999.99 999,999,999,999.99 999,999,999,999.99 999,999,999,999.99 999,999,999,999.99       9,999,999,999.99

			@ Li,000 PSAY STR0032 //"|    |CFOP |Alic| Valor Contable | Base de Calculo  |     Impuesto     |     Exentas      |      Otras       |     Observacion      |"
			Li += 1
			cLinha :=               "|    |     |    |                |                  |                  |                  |                  |                      |"
			While ! Eof() .And. xFilial("SF3")+(cAliasSF1)->F1_FORNECE+(cAliasSF1)->F1_LOJA+(cAliasSF1)->F1_DOC+(cAliasSF1)->F1_SERIE==F3_FILiAL+F3_CLiEFOR+F3_LOJA+F3_NFISCAL+F3_SERIE

				If Val(Substr(SF3->F3_CFO,1,1))<5

					U_UR170Load(0,cLinha)
					U_UR170Load(01,IIf(!Empty((cAliasSF1)->F1_ISS) .And. SF3->F3_TIPO == "S" ,STR0087,STR0088)) //"ISS"##"ICMS"
					U_UR170Load(06,SF3->F3_CFO)
					U_UR170Load(12,Transform(SF3->F3_ALIQICM,"99"))
					U_UR170Load(17,Transform(SF3->F3_VALCONT,"@E 9,999,999,999.99"))
					U_UR170Load(34,Transform(SF3->F3_BASEICM,"@E 999,999,999,999.99"))
					U_UR170Load(53,Transform(SF3->F3_VALICM,"@E 999,999,999,999.99"))
					U_UR170Load(72,Transform(SF3->F3_ISENICM,"@E 999,999,999,999.99"))
					U_UR170Load(91,Transform(SF3->F3_OUTRICM,"@E 999,999,999,999.99"))
					U_UR170Say(Li)
					Li++
					If !EMPTY(SF3->F3_ICMSRET)
						U_UR170Load(0,cLinha)
						U_UR170Load(109,STR0080) //"RET  "
						U_UR170Load(114,Transform(SF3->F3_ICMSRET,"@E 9,999,999,999.99"))
						U_UR170Say(Li)
						Li += 1
					Endif
					If !EMPTY(SF3->F3_ICMSCOM)
						U_UR170Load(0,cLinha)
						U_UR170Load(109,STR0081) //"Compl"
						U_UR170Load(114,Transform(SF3->F3_ICMSCOM,"@E 9,999,999,999.99"))
						U_UR170Say(Li)
						Li += 1
					Endif
					If !Empty(SF3->F3_BASEIPI) .Or. !Empty(SF3->F3_ISENIPI) .Or. !Empty(SF3->F3_OUTRIPI)
						U_UR170Load(0,cLinha)
						U_UR170Load(01,STR0086) //"IPI"  
     					U_UR170Load(12,Transform(Posicione("SD1",1,xFilial("SD1")+(cAliasSF1)->F1_DOC+(cAliasSF1)->F1_SERIE+(cAliasSF1)->F1_FORNECE+(cAliasSF1)->F1_LOJA,"D1_IPI"),"99"))						
						U_UR170Load(17,Transform(SF3->F3_VALCONT,"@E 9,999,999,999.99"))
						U_UR170Load(34,Transform(SF3->F3_BASEIPI,"@E 999,999,999,999.99"))
						U_UR170Load(53,Transform(SF3->F3_VALIPI,"@E 999,999,999,999.99"))
						U_UR170Load(72,Transform(SF3->F3_ISENIPI,"@E 999,999,999,999.99"))
						U_UR170Load(91,Transform(SF3->F3_OUTRIPI,"@E 999,999,999,999.99"))
					Endif	

					If ! Empty(SF3->F3_VALOBSE)
						U_UR170Load(110,STR0082) //"OBS. "
						U_UR170Load(114,Transform(SF3->F3_VALOBSE,"@E 9,999,999,999.99"))
					Endif
					U_UR170Say(Li)
					Li += 1
				Endif

				dbSkip()
			End

		Endif

		Li += 1
		@ Li,000 PSAY __PrtThinLine()
		Li += 1
		@ Li,000 PSAY STR0059 //  "----------------------------------------------- DEMONSTRATIVO DOS DEMAIS IMPOSTOS ---------------------------------------------------"
		Li += 1
		@ Li,000 PSAY STR0060 //  "|                   | Base de Calculo  |     Imposto      |                                                                         |"
		Li += 1
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime Dados ref ao PIS                                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty( nScanPis := aScan(aRelImp,{|x| x[1]=="SF1" .And. x[3]=="NF_BASEPS2"} ) )
			If !Empty((cAliasSF1)->(FieldPos(aRelImp[nScanPis,2])))
				nBasePis := (cAliasSF1)->(FieldGet((cAliasSF1)->(FieldPos(aRelImp[nScanPis,2]) ) ) )
			EndIf
		EndIf

		If !Empty( nScanPis := aScan(aRelImp,{|x| x[1]=="SF1" .And. x[3]=="NF_VALPS2"} ) )
			If !Empty((cAliasSF1)->(FieldPos(aRelImp[nScanPis,2])))
				nValPis := (cAliasSF1)->(FieldGet((cAliasSF1)->(FieldPos(aRelImp[nScanPis,2]) ) ) )
			EndIf
		EndIf

		If !Empty(nValPis)
			U_UR170Load(0,"|                   | Base de Calculo  |     Imposto      |")
			U_UR170Load(01,STR0083) //"PIS APURACAO"
			U_UR170Load(21,Transform(nBasePis,"@E 999,999,999,999.99"))
			U_UR170Load(40,Transform(nValPis,"@E 999,999,999,999.99"))
			U_UR170Say(Li)
			Li++
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime Dados ref ao COFINS                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty( nScanCof := aScan(aRelImp,{|x| x[1]=="SF1" .And. x[3]=="NF_BASECF2"} ) )
			If !Empty((cAliasSF1)->(FieldPos(aRelImp[nScanCof,2])))
				nBaseCof := (cAliasSF1)->(FieldGet((cAliasSF1)->(FieldPos(aRelImp[nScanCof,2]) ) ) )
			EndIf
		EndIf

		If !Empty( nScanCof := aScan(aRelImp,{|x| x[1]=="SF1" .And. x[3]=="NF_VALCF2"} ) )
			If !Empty((cAliasSF1)->(FieldPos(aRelImp[nScanCof,2])))
				nValCof := (cAliasSF1)->(FieldGet((cAliasSF1)->(FieldPos(aRelImp[nScanCof,2]) ) ) )
			EndIf
		EndIf

		If !Empty(nValCof)
			U_UR170Load(0,"|                   | Base de Calculo  |     Imposto      |")
			U_UR170Load(01,STR0084) //"COFINS APURACAO"
			U_UR170Load(21,Transform(nBaseCof,"@E 999,999,999,999.99"))
			U_UR170Load(40,Transform(nValCof,"@E 999,999,999,999.99"))
			U_UR170Say(Li)
			Li++
		Endif

//		@ Li,000 PSAY __PrtThinLine()
//		If Li < 57
//			Li := 57
//		Endif

//INICIO - RAFAEL ALMEIDA LANÇAMENTO CONTABIL

		U_UR170Say(Li)
		Li += 1
		@ Li,000 PSAY __PrtThinLine()
		Li += 1

		Li += 1
		If Li >= 60
			Li := 1
		Endif
		//                               1         2         3         4         5         6         7         8         9        10        11        12        13
		//                     012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
		//                      123 123456789012A 99/99/9999 99,999,999,999.99                            123 123456789012A 99/99/99   99,999,999,999.99 xxxxxxxxxx
		@ Li,000 PSAY STR0122 //"--------------------------------------------------- DESDOBRAMENTO DE DUPLICATAS ----------------------------------------------------"
		Li += 1
			cLinha :=	    "|                 |                 |                       |                                          |             |             |"
		Li :=Li
		@ Li,000 PSAY STR0123  // |      DEBITO      |      CREDITO     |          VALOR          |                   DESCRIÇÃO                |  CC DEBITO  |  CC CREDITO
		Li += 1

		_aDdCtb := R170CTB((cAliasSF1)->F1_DOC, (cAliasSF1)->F1_SERIE, (cAliasSF1)->F1_FORNECE, (cAliasSF1)->F1_LOJA)   
		
		If Len(_aDdCtb) > 0
		For nCtb:=1 to Len(_aDdCtb)
			U_UR170Load(000,cLinha)
				U_UR170Load(004,Alltrim(_aDdCtb[nCtb][1]))
				U_UR170Load(022,Alltrim(_aDdCtb[nCtb][2]))
				U_UR170Load(040,Transform(_aDdCtb[nCtb][3],"@E 999,999,999,999.99"))
				U_UR170Load(062,Alltrim(_aDdCtb[nCtb][4]))
				U_UR170Load(109,Alltrim(_aDdCtb[nCtb][5]))
				U_UR170Load(123,Alltrim(_aDdCtb[nCtb][6]))
			U_UR170Say(Li)
			Li++
		Next nCtb
		EndIf

		@ Li,000 PSAY __PrtThinLine()
		If Li < 57
			Li := 57
		Endif	
		Li += 1
//FIM - RAFAEL ALMEIDA LANÇAMENTO CONTABIL
		
	Else
		aItens:=R170IMPI(cAliasSF1)
		If Len(aItens[1])>=0
			Li += 1
			If Li >= 60
				Li := 1
			Endif
			//                                     1         2         3         4         5         6         7         8         9        10        11        12        13
			//                           012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
			cLinha :=	    "|                  |                                          |     |        |                         |"
			@ Li,000 PSAY STR0042 //"-----------------------------------------------   RELACAO DE IMPOSTOS POR ITEM   ---------------------------------------------------"
			Li :=Li+1
			@ Li,000 PSAY STR0050  // |     PRODUTO      |               DESCRICAO                  | IMP |  ALIQ  |     BASE DE CALCULO     |      VALOR DO IMPOSTO
			Li += 1

			For nImp:=1 to Len(aItens)
				U_UR170Load(000,cLinha)
				U_UR170Load(001,aItens[nImp][1])
				U_UR170Load(022,aItens[nImp][2])
				U_UR170Load(064,aItens[nImp][3])
				U_UR170Load(070,Transform(NoRound(aItens[nImp][4]),PesqPict("SD1","D1_ALQIMP6")))
				U_UR170Load(080,Transform(aItens[nImp][5],PesqPict("SM2","M2_MOEDA1")))
				U_UR170Load(106,Transform(aItens[nImp][6],PesqPict("SM2","M2_MOEDA1")))
				U_UR170Say(Li)
				Li++
			Next
		Endif

		@ Li,000 PSAY __PrtThinLine()
		If Li < 57
			Li := 57
		Endif

	EndIf

	//                           1         2         3         4         5         6         7         8         9        10        11        12        13
	//                  123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
	@ Li,000 PSAY STR0033 //"------------------------------------------------------------------- VISTOS ---------------------------------------------------------"
	Li += 1
	@ Li,000 PSAY "|                               |                                |                                  |                              |"
	Li += 1
	@ Li,000 PSAY STR0034 //"| Recebimento  Fiscal           | Contabil/Custos                | Departamento Fiscal              | Administracao                |"
	Li += 1
	@ Li,000 PSAY __PrtThinLine()
	dbSelectArea(cAliasSF1)
	dbSkip()
	_lTES := .F.
	_lPrcErr := .F.
	_lQtdErr := .F.
	_QtdSal := .F.
EndDo

dbSelectArea("SF1")
RetIndex("SF1")
If File(cArqInd+ OrdBagExt())
	FErase(cArqInd+ OrdBagExt() )
EndIf

dbSelectArea("SD1")
RetIndex("SD1")
If File(cArqIndSD1+ OrdBagExt())
	FErase(cArqIndSD1+ OrdBagExt() )
EndIf

#IFDEF TOP
	If !lAuto
		dbSelectArea("QRYSF1")
		dbCloseArea()
	EndIf
#ENDIF

If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R170Cabec() ³ Rev.  ³ Edson Maricate     ³ Data ³06/07/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o cabecalho do Boletim.                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ R170Cabec()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR170                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function UR170Cabec()

Local li         := 01
Local aVencto    := {}
Local aAuxCombo1 := {"N","D","B","I","P","C","1","2","3"}
Local aCombo1	 := {STR0051,;	//"Normal"
	STR0052,;	//"Devoluçao"
	STR0053,;	//"Beneficiamento"
	STR0054,;	//"Compl.  ICMS"
	STR0055,;	//"Compl.  IPI"
	STR0056,; //"Compl. Preco/frete"
	STR0119,; //Compl. Preço
	STR0120,; //Compl. Quantidade
	STR0121}  //Compl. Frete
		
Local cNumDoc := ""	
Local nIncCol := If(cPaisLoc=="MEX",8,0)
Local cPrefixo := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz manualmente porque nao chama a funcao Cabec()                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ li,000 PSAY AvalImp(132)
@ li,000 PSAY  ""
@ Li,000 PSAY STR0035 +CUSERNAME + STR0036+Dtoc(dDataBase) //"Usuario: "###" Data Base: "
Li += 1
@ li,000 PSAY __PrtFatLine()
Li += 1

If (cAliasSF1)->F1_TIPO $ "DB"
	dbSelectArea("SE1")
	dbSetOrder(2)
	dbSeek(xFilial("SE1")+(cAliasSF1)->F1_FORNECE+(cAliasSF1)->F1_LOJA+(cAliasSF1)->F1_SERIE+(cAliasSF1)->F1_DOC)
	While !Eof() .And. E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM == xFilial("SE1")+(cAliasSF1)->F1_FORNECE+(cAliasSF1)->F1_LOJA+(cAliasSF1)->F1_SERIE+(cAliasSF1)->F1_DOC
		If ALLTRIM(E1_ORIGEM)=="MATA100"
			aADD(aVencto,E1_VENCREA)
		EndIf
		dbSkip()
	End
	@ li,000 PSAY OemToAnsi(STR0047)+SD1->D1_NUMSEQ+Space(66)+OemToAnsi(STR0048)+Dtoc(Date())+Space(14)+OemToAnsi(STR0049)+Time()   //  N. ## Data Ref. ### Hora Ref.
	li += 1
	@ li,000 PSAY STR0037 +dtoc((cAliasSF1)->F1_DTDIGIT)+IIF((cAliasSF1)->F1_TIPO=="D",STR0038," - ("+Alltrim(STR0053)+")") //"BOLETIM DE ENTRADA      Material recebido em: "###" - (Devolucao)"
	li += 1

	cCGC:=" - "
	cCGC+=Alltrim(RetTitle("A1_CGC"))
	cCGC+=": "
	cIE:=" "+AllTrim(RetTitle("A1_INSCR"))+": "
	cIEM:=" "+AllTrim(RetTitle("A1_INSCRM"))+": "

	@ li,0 PSAY SM0->M0_NOME + "-" + SM0->M0_FILIAL + cCGC + SM0->M0_CGC
	Li += 1
	@ li,0 PSAY __PrtThinLine()
	Li += 1
	@ li,0 PSAY If(cPaisLoc=="MEX",STR0107,STR0039) //"Dados do Cliente                                                                                 | Nota Fiscal  | Emissao  | Vencto"
	Li += 1
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial("SA1")+(cAliasSF1)->F1_FORNECE+(cAliasSF1)->F1_LOJA)
	cTipoNF	:= aCombo1[aScan(aAuxCombo1,(cAliasSF1)->F1_TIPO)]

	@ li,000 PSAY SA1->A1_COD+"/"+SA1->A1_LOJA+" - "+SUBS(SA1->A1_NOME,1,40)
	@ li,If(cPaisLoc=="BRA",069,065)-nIncCol PSAY "| "+(cAliasSF1)->F1_SERIE+" "+(cAliasSF1)->F1_DOC
	@ li,084 PSAY "| "+(cAliasSF1)->F1_ESPECIE
	@ li,091 PSAY "| "+PadR(CtipoNF,18)
	@ li,111 PSAY "|"+DTOC((cAliasSF1)->F1_EMISSAO)
	@ li,122 PSAY IIf( Len(aVencto) == 1,"|"+DTOC(aVencto[1]),If(Len(aVencto) ==0,"|"+STR0115,"|"+STR0040)) //"Diversos"
	Li += 1
	@ li,000 PSAY SA1->A1_END
	@ li,If(cPaisLoc=="BRA",069,065)-nIncCol PSAY STR0041
	@ li,115 PSAY transform(((cAliasSF1)->F1_VALBRUT),PesqPict("SF1","F1_VALBRUT")) //"| Valor Total   "
	Li += 1
	@ li,000 PSAY SA1->A1_MUN+" "+SA1->A1_EST+" "+Substr(cCGC,4,Len(cCGC)-3)+" "+If(cPaisLoc<>"BRA",Transform(SA1->A1_CGC,PesqPict("SA1","A1_CGC")),Transform(SA1->A1_CGC,PicPesFJ(If(Len(AllTrim(SA1->A1_CGC))<14,"F","J"))))+" "+cIE+" "+SA1->A1_INSCR+" "+cIEM+" "+SA1->A1_INSCRM //" CGC: "###"  I.E: "###"  I.M. "
Else
    cPrefixo := If(Empty((cAliasSF1)->F1_PREFIXO),&(GetMV("MV_2DUPREF")),(cAliasSF1)->F1_PREFIXO)
	dbSelectArea("SE2")
	dbSetOrder(6)
	dbSeek(xFilial("SE2")+(cAliasSF1)->F1_FORNECE+(cAliasSF1)->F1_LOJA+ cPrefixo +(cAliasSF1)->F1_DOC)
	While !Eof() .And. E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM == xFilial("SE2")+(cAliasSF1)->F1_FORNECE+(cAliasSF1)->F1_LOJA+(cAliasSF1)->F1_SERIE+(cAliasSF1)->F1_DOC
		If ALLTRIM(E2_ORIGEM)=="MATA100"
			aADD(aVencto,E2_VENCTO)
		EndIf
		dbSkip()
	End
	@ li,000 PSAY OemToAnsi(STR0047)+SD1->D1_NUMSEQ+Space(68)+OemToAnsi(STR0048)+Dtoc(Date())+Space(14)+OemToAnsi(STR0049)+Time()   // N. ### Data Impressao ### Hora Ref.
	li += 1
	@ li,000 PSAY STR0037 +Dtoc((cAliasSF1)->F1_DTDIGIT) //"BOLETIM DE ENTRADA      Material recebido em: "
	li += 1

	cCGC:=" - "
	cCGC+=Alltrim(RetTitle("A1_CGC"))
	cCGC+=": "
	cIE:=" "+AllTrim(RetTitle("A1_INSCR"))+": "
	cIEM:=" "+AllTrim(RetTitle("A1_INSCRM"))+": "

	@ li,0 PSAY SM0->M0_NOME + "-" + SM0->M0_FILIAL + cCGC + SM0->M0_CGC //" - CGC.: "
	li += 1
	@ li,000 PSAY __PrtThinLine()
	li += 1
	@ li,0 PSAY If(cPaisLoc=="BRA",STR0043,If(cPaisLoc=="MEX",STR0108,STR0057)) //"Dados do Fornecedor                                                                              | Nota Fiscal  | Emissao  | Vencto"
	li += 1
	dbSelectArea("SA2")
	dbSetOrder(1)
	dbSeek(XFilial("SA2")+(cAliasSF1)->F1_FORNECE+(cAliasSF1)->F1_LOJA)
		
	If SF1->(FieldPos("F1_TPCOMPL")) > 0 .And. (cAliasSF1)->F1_TIPO == "C" .And. !Empty((cAliasSF1)->F1_TPCOMPL)
		cTipoNF	:= aCombo1[aScan(aAuxCombo1,(cAliasSF1)->F1_TPCOMPL)]
	Else
		cTipoNF	:= aCombo1[aScan(aAuxCombo1,(cAliasSF1)->F1_TIPO)]
	EndIf

	cNumDoc := If(cPaisLoc=="BRA",(cAliasSF1)->F1_DOC,PadR((cAliasSF1)->F1_DOC,If(cPaisLoc=="MEX",21,13),""))

	@ li,000 PSAY SA2->A2_COD+"/"+SA2->A2_LOJA+" - "+SubStr(SA2->A2_NOME,1,40)
	@ li,069-nIncCol PSAY "| "+(cAliasSF1)->F1_SERIE+" "+cNumDoc
	@ li,If(cPaisLoc=="BRA",84,88) PSAY "| "+(cAliasSF1)->F1_ESPECIE
	@ li,If(cPaisLoc=="BRA",91,95) PSAY "| "+PadR(CtipoNF,If(cPaisLoc=="BRA",19,16))
	@ li,If(cPaisLoc=="BRA",111,114) PSAY "|"+DTOC((cAliasSF1)->F1_EMISSAO)
	@ li,If(cPaisLoc=="BRA",122,125) PSAY "|"+IIf( Len(aVencto) == 1, DTOC(aVencto[1]), Iif(Len(aVencto) == 0,STR0115,STR0040)) //"Diversos"
	
	li += 1
	@ li,000 PSAY SA2->A2_END
	@ li,069-nIncCol PSAY STR0041
	@ li,115 PSAY transform(((cAliasSF1)->F1_VALBRUT),PesqPict("SF1","F1_VALBRUT")) //"| Valor Total   "
	li += 1
	@ li,000 PSAY Left(SA2->A2_MUN, 30)+" "+SA2->A2_EST+" "+Substr(cCGC,4,Len(cCGC)-3)+" "+If(cPaisLoc<>"BRA",Transform(SA2->A2_CGC,PesqPict("SA2","A2_CGC")),Transform(SA2->A2_CGC,PicPesFJ(If(Len(AllTrim(SA2->A2_CGC))<14,"F","J"))))+" "+cIE+" "+SA2->A2_INSCR+" "+cIEM+" "+SA2->A2_INSCRM //" CGC: "###"  I.E: "###"  I.M. "
EndIf
li += 1
Return( li )


User Function UR170Load(nPos,cTexto)

cAuxLinha := Substr(cAuxLinha,1,nPos)+cTexto+Substr(cAuxLinha,nPos+Len(cTexto)+1,132-nPos+Len(cTexto))

Return

User Function UR170Say(nLinha)

@ nLinha,000 PSAY cAuxLinha
cAuxLinha := SPACE(132)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProgram   ³R170IMPT  ºAuthor ³Armando P. Waiteman º Date ³  08/07/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Faz a somatoria dos impostos da nota. Retornando um array   º±±
±±º          ³com todas as informacoes a serem impressas                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATR170                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function R170IMPT(cAliasSF1)


Local aArea    := {}
Local aAreaSD1 := {}
Local aImp     := {}
Local aImpostos:= {}
Local nImpos:= 0
Local nBase := 0
Local nY,cCampImp,cCampBas

aArea:=GetArea()


dbSelectArea("SD1")
aAreaSD1:=GetArea()

dbSetOrder(3)

cSeek:=(xFilial("SD1")+Dtos((cAliasSF1)->F1_EMISSAO)+(cAliasSF1)->F1_DOC+(cAliasSF1)->F1_SERIE+;
	(cAliasSF1)->F1_FORNECE+(cAliasSF1)->F1_LOJA)

If dbSeek(cSeek)
	While cSeek==xFilial("SD1")+dtos(D1_EMISSAO)+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA
		if empty(TesImpInf(D1_TES))        
			exit
		endif
		aImpostos:=TesImpInf(D1_TES)
		For nY:=1 to Len(aImpostos)
			cCampImp:="SD1->"+(aImpostos[nY][2])
			cCampBas:="SD1->"+(aImpostos[nY][7])
			nImpos+=&cCampImp
		Next
		nBase +=&cCampBas
		dbSkip()	
	Enddo
EndIf

RestArea(aAreaSD1)
RestArea(aArea)

AADD(aImp,nBase)
AADD(aImp,nImpos)


Return aImp

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProgram   ³R170IMPI  ºAuthor ³Armando P. Waiteman º Date ³  08/07/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna array com lista de impostos por item                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATR170                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function R170IMPI(cAliasSF1)


Local aArea    := {}
Local aAreaSD1 := {}
Local aImp     := {}
Local aRet     := {}
Local nY

aArea:=GetArea()


dbSelectArea("SD1")
aAreaSD1:=GetArea()

dbSetOrder(3)

cSeek:=(xFilial("SD1")+Dtos((cAliasSF1)->F1_EMISSAO)+(cAliasSF1)->F1_DOC+(cAliasSF1)->F1_SERIE+;
	(cAliasSF1)->F1_FORNECE+(cAliasSF1)->F1_LOJA)

If dbSeek(cSeek)
	While cSeek==xFilial("SD1")+dtos(D1_EMISSAO)+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA
		aImp:=TesImpInf(D1_TES)

		// Pega a descricao do produto
		dbSelectArea("SB1")
		aAreaSB1:=GetArea()
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+SD1->D1_COD)
		cDescProd:=B1_DESC
		RestArea(aAreaSB1)

		dbSelectArea("SD1")
		For nY:=1 to Len(aImp)
			AADD(aRet,{SD1->D1_COD,cDescProd,aImp[nY][1],&("SD1->"+aImp[nY][10]),&("SD1->"+(aImp[nY][7])),&("SD1->"+(aImp[nY][2]))})
		Next
		dbSkip()
	Enddo
EndIf

If Len(aRet)<= 0
	AADD(aRet,{"" ,"" ,"" ,0 ,0 ,0})
EndIf

RestArea(aAreaSD1)
RestArea(aArea)

Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProgram   ³R170Dupl  ºAuthor ³ALexandre I. Lemes  º Date ³  04/01/2002 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Imprime o Desdobramento de duplicatas                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATR170                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R170DUPL(Li,Col)
Local nIncCol := If(cPaisLoc=="MEX",8,0)

dbSelectArea("SE2")

If Li >= 60
	Li := 1
	@ Li,000 PSAY STR0026 //"--------------------------------------------------- DESDOBRAMENTO DE DUPLICATAS ----------------------------------------------------"
	Li := Li + 1
	@ Li,000 PSAY If(cPaisLoc=="MEX",STR0109,STR0027) //"Ser|Titulo       | Vencto   |Valor do Titulo  | Natureza          ||Ser|Titulo       | Vencto   |Valor do Titulo  | Natureza        "
	Li := Li + 1
Endif

U_UR170Load(Col,SE2->E2_PREFIXO)
U_UR170Load(Col+4,SE2->E2_NUM)
U_UR170Load(Col+16+nIncCol,SE2->E2_PARCELA)
U_UR170Load(Col+18+nIncCol,dtoc(SE2->E2_VENCTO))
U_UR170Load(Col+29+nIncCol,Transform(SE2->E2_VALOR,"@E 99,999,999,999.99"))
U_UR170Load(Col+48+nIncCol,SE2->E2_NATUREZ)

If Col == 0
	Col := 68
Else
	Col := 0
	U_UR170Say(Li)
	U_UR170Load(0,cLinha)
	Li := Li + 1
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProgram   ³R170Ctb   ºAuthor ³ALexandre I. Lemes  º Date ³  04/01/2002 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Imprime o Contabilização a rastreabilidade                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATR170                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function R170CTB(_cNunFisc, _cSerNf, _cCdForn, _cLjForn)
Local aDadoCtb := {}
Local cQry        := "" 
Local cQryA       := "" 
Local cQryB       := "" 
Local cQryC       := "" 
Local _cRecSF1    := 0
Local _cSegCV3    := ""
 
/*
cQry := "  SELECT  C.CV3_DEBITO ,C.CV3_CREDIT,C.CV3_VLR01,C.CV3_HIST,C.CV3_CCD,C.CV3_CCC FROM 	" + RetSqlName('CV3') + " AS C WHERE C.D_E_L_E_T_ = '' AND C.CV3_SEQUEN = "
cQry += " (SELECT TOP 1 B.CV3_SEQUEN FROM	" + RetSqlName('CV3') + " AS B WHERE B.D_E_L_E_T_ = '' AND B.CV3_TABORI = 'SF1' AND B.CV3_RECORI =  "
cQry += " (SELECT R_E_C_N_O_ FROM " + RetSqlName('SF1') + "  WHERE D_E_L_E_T_ = '' "
cQry += "  AND F1_DOC     = '" + Alltrim(_cNunFisc) + "' " 
cQry += "  AND F1_SERIE   = '" + Alltrim(_cSerNf)   + "' " 
cQry += "  AND F1_FORNECE = '" + Alltrim(_cCdForn)  + "' " 
cQry += "  AND F1_LOJA    = '" + Alltrim(_cLjForn)  + "')) " 
dbUseArea( .T., "TOPCONN" ,TcGenQry(,,cQry) , "TOC" , .T. , .F.)


DBSelectArea("TOC")
TOC->(DbGoTop())  
While !TOC->(Eof())
	aADD(aDadoCtb,{TOC->CV3_DEBITO ,TOC->CV3_CREDIT,TOC->CV3_VLR01,TOC->CV3_HIST,TOC->CV3_CCD,TOC->CV3_CCC})
	TOC->(DbSkip())
EndDo
TOC->( DBCloseArea())
*/
cQryC := "  "
cQryC += "  SELECT "
cQryC += "   CT2_DEBITO AS 'CV3_DEBITO' ,CT2_CREDIT AS 'CV3_CREDIT',SUM(CT2_VALOR) AS 'CV3_VLR01',CT2_CCD AS 'CV3_CCD',CT2_CCC AS 'CV3_CCC'	"
cQryC += "  ,CASE 	"
cQryC += "  	WHEN CT2_DC = '1'	"
cQryC += "  		THEN SUBSTRING((SELECT RTRIM(LTRIM(CT1_DESC01)) FROM "+ RETSQLNAME("CT1")+"  WHERE D_E_L_E_T_ = '' AND CT1_CONTA = CT2_DEBITO),1,100)	"
cQryC += "  	WHEN CT2_DC = '2'	"
cQryC += "  		THEN SUBSTRING((SELECT RTRIM(LTRIM(CT1_DESC01)) FROM "+ RETSQLNAME("CT1")+" WHERE D_E_L_E_T_ = '' AND CT1_CONTA = CT2_CREDIT),1,100)	"
cQryC += "  	WHEN CT2_DC = '3'	"
cQryC += "  		THEN SUBSTRING((SELECT RTRIM(LTRIM(CT1_DESC01)) FROM "+ RETSQLNAME("CT1")+" WHERE D_E_L_E_T_ = '' AND CT1_CONTA = CT2_DEBITO),1,50)+' / '+	"
cQryC += "  			 SUBSTRING((SELECT RTRIM(LTRIM(CT1_DESC01)) FROM "+ RETSQLNAME("CT1")+" WHERE D_E_L_E_T_ = '' AND CT1_CONTA = CT2_CREDIT),1,50)	"
cQryC += "  	ELSE ''	"
cQryC += "  END CV3_HIST	"
cQryC += "  FROM "+ RETSQLNAME("CT2")+"  "
cQryC += "  WHERE D_E_L_E_T_ = ''	"
cQryC += "  AND CT2_FILIAL   = '"+xfilial("CT2")  +"' "
cQryC += "  AND SUBSTRING(CT2_KEY,1,2)  = '"+xfilial("CT2")  +"' "
cQryC += "  AND SUBSTRING(CT2_KEY,3,9)  = '" + Alltrim(_cNunFisc) + "' "
cQryC += "  AND SUBSTRING(CT2_KEY,12,3) = '" + Alltrim(_cSerNf)   + "' "
cQryC += "  AND SUBSTRING(CT2_KEY,15,6) = '" + Alltrim(_cCdForn)  + "' "
cQryC += "  AND SUBSTRING(CT2_KEY,21,2) = '" + Alltrim(_cLjForn)  + "' " 
cQryC += "  AND CT2_LP <> '655'	"
cQryC += "  AND CT2_SEQUEN = (SELECT MAX(CT2_SEQUEN) FROM  "+ RETSQLNAME("CT2")+"  WHERE D_E_L_E_T_ = '' AND CT2_FILIAL   = '"+xfilial("CT2")  +"' " 
cQryC += "  					AND SUBSTRING(CT2_KEY,1,2)  = '" + xfilial("CT2")     +"'  AND SUBSTRING(CT2_KEY,3,9)  = '" + Alltrim(_cNunFisc) + "' "
cQryC += "  					AND SUBSTRING(CT2_KEY,12,3) = '" + Alltrim(_cSerNf)   + "' AND SUBSTRING(CT2_KEY,15,6) = '" + Alltrim(_cCdForn)  + "' "
cQryC += "  					AND SUBSTRING(CT2_KEY,21,2) = '" + Alltrim(_cLjForn)  + "' AND CT2_LP <> '655') "
cQryC += "  GROUP BY CT2_DEBITO ,CT2_CREDIT,CT2_CCD,CT2_CCC, CT2_DC		"
dbUseArea( .T., "TOPCONN" ,TcGenQry(,,cQryC) , "TOCC" , .T. , .F.)


/*
cQryA := " "
cQryA += " SELECT R_E_C_N_O_ AS RECSF1 FROM "+ RETSQLNAME("SF1")+  "  WHERE D_E_L_E_T_ = '' "
cQryA += "  AND F1_DOC     = '" + Alltrim(_cNunFisc) + "' " 
cQryA += "  AND F1_SERIE   = '" + Alltrim(_cSerNf)   + "' " 
cQryA += "  AND F1_FORNECE = '" + Alltrim(_cCdForn)  + "' " 
cQryA += "  AND F1_LOJA    = '" + Alltrim(_cLjForn)  + "' "
cQryA += "  AND F1_FILIAL = '"+xfilial("SF1")  +"' " 
dbUseArea( .T., "TOPCONN" ,TcGenQry(,,cQryA) , "TOCA" , .T. , .F.)

DBSelectArea("TOCA")
TOCA->(DbGoTop())  
While !TOCA->(Eof())
	_cRecSF1 := TOCA->RECSF1
	TOCA->(DbSkip())
EndDo
TOCA->( DBCloseArea())			


cQryB := "	"
cQryB += " SELECT TOP 1 CV3_SEQUEN "
cQryB += " FROM	"+ RETSQLNAME("CV3")+"  "
cQryB += " WHERE D_E_L_E_T_ = ''	" 
cQryB += " AND   CV3_TABORI = 'SF1'	" 
cQryB += " AND   CV3_FILIAL = '"+xfilial("CV3")  +"' " 
cQryB += " AND   CV3_RECORI =  "+alltrim(str(_cRecSF1,14))+" "
dbUseArea( .T., "TOPCONN" ,TcGenQry(,,cQryB) , "TOCB" , .T. , .F.)


DBSelectArea("TOCB")
TOCB->(DbGoTop())  
While !TOCB->(Eof())
	_cSegCV3 := TOCB->CV3_SEQUEN
	TOCB->(DbSkip())
EndDo
TOCB->( DBCloseArea())

//cQryC += "  SELECT  CV3_DEBITO ,CV3_CREDIT,CV3_VLR01,CV3_CCD,CV3_CCC

cQryC := "	"
cQryC += "  SELECT  CV3_DEBITO ,CV3_CREDIT,SUM(CV3_VLR01) AS 'CV3_VLR01',CV3_CCD,CV3_CCC	"
cQryC += "  ,CASE 	"
cQryC += "  	WHEN CV3_DC = '1'	"
cQryC += "  		THEN SUBSTRING((SELECT RTRIM(LTRIM(CT1_DESC01)) FROM "+ RETSQLNAME("CT1")+"  WHERE D_E_L_E_T_ = '' AND CT1_CONTA = CV3_DEBITO),1,100)	"
cQryC += "  	WHEN CV3_DC = '2'	"
cQryC += "  		THEN SUBSTRING((SELECT RTRIM(LTRIM(CT1_DESC01)) FROM "+ RETSQLNAME("CT1")+" WHERE D_E_L_E_T_ = '' AND CT1_CONTA = CV3_CREDIT),1,100)	"
cQryC += "  	WHEN CV3_DC = '3'	"
cQryC += "  		THEN SUBSTRING((SELECT RTRIM(LTRIM(CT1_DESC01)) FROM "+ RETSQLNAME("CT1")+" WHERE D_E_L_E_T_ = '' AND CT1_CONTA = CV3_DEBITO),1,50)+' / '+	"
cQryC += "  			 SUBSTRING((SELECT RTRIM(LTRIM(CT1_DESC01)) FROM "+ RETSQLNAME("CT1")+" WHERE D_E_L_E_T_ = '' AND CT1_CONTA = CV3_CREDIT),1,50)	"
cQryC += "  	ELSE ''	"
cQryC += "  END CV3_HIST	"
cQryC += "  FROM "+ RETSQLNAME("CV3")+"  "
cQryC += "  WHERE D_E_L_E_T_ = '' "
cQryC += "  AND   CV3_FILIAL = '"+xfilial("CV3")  +"' " 
cQryC += "  AND   CV3_SEQUEN = '"+_cSegCV3+"' "
cQryC += "  GROUP BY CV3_DEBITO ,CV3_CREDIT,CV3_CCD,CV3_CCC, CV3_DC	"
dbUseArea( .T., "TOPCONN" ,TcGenQry(,,cQryC) , "TOCC" , .T. , .F.)
*/

DBSelectArea("TOCC")
TOCC->(DbGoTop())  
While !TOCC->(Eof())
	aADD(aDadoCtb,{TOCC->CV3_DEBITO ,TOCC->CV3_CREDIT,TOCC->CV3_VLR01,TOCC->CV3_HIST,TOCC->CV3_CCD,TOCC->CV3_CCC})
	TOCC->(DbSkip())
EndDo
TOCC->( DBCloseArea())

Return(aDadoCtb)




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSX1    ³Autor ³ Aline Correa do Vale ³Data³16/01/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ajusta perguntas do SX1                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1()

Local aAreaAnt	 := GetArea()
Local aAreaSX1	 := SX1->(GetArea())
Local aAreaSX3	 := SX3->(GetArea())
Local aSXB		 := {}
Local nTamSX1    := Len(SX1->X1_GRUPO)
Local nTamSXB    := Len(SXB->XB_ALIAS)
Local aEstrut	 := {"XB_ALIAS","XB_TIPO","XB_SEQ","XB_COLUNA","XB_DESCRI","XB_DESCSPA","XB_DESCENG","XB_CONTEM"}
Local i			 := 1
Local j			 := 1
Local aHelpPor07 := {'Ordem de Impressao ', '', ''}
Local aHelpEsp07 := {'Orden de impresion ', '', ''}
Local aHelpEng07 := {'Print Order        ', '', ''}
Local aHelpPor08 := {'Se voce escolher imprimir o Armazem,  ', 'a descricao do Produto sera'      , 'reduzida em duas posicoes.'}
Local aHelpEsp08 := {'Si usted elige imprimir el Deposito,  ', 'la descripcion del producto sera ', 'reducida en dos posiciones.'}
Local aHelpEng08 := {'If you choose to print the Warehouse, ', 'the product description will be'  , 'reduced in two positions.'}

PutSX1Help("P.MTR17007.", aHelpPor07, aHelpEng07, aHelpEsp07)

PutSx1('MTR170','08','Imprime Armazem    ?','Imprime Deposito   ?','Show  Warehouse    ?','mv_ch8','N',2,0,2,'C','','','','','mv_par08','Sim','Si','Yes','','Nao','No','No','','','','','','','','','', aHelpPor08, aHelpEsp08, aHelpEng08)

// Ajusta a opcao do tipo
dbSelectArea("SX1")
If dbSeek(PADR("MTR170",nTamSX1)+"05")
	RecLock("SX1",.F.)
	Replace X1_DEF03   With "Entidade Contab"
	Replace X1_DEFSPA3 With "Ente Contable"
	Replace X1_DEFENG3 With "Account.Entity"
	MsUnLock()
EndIf

//-- Consulta SXB
Aadd(aSXB,{"SD1NF","1","01","DB"	,"Documento de Entrada"	,"Factura de Entrada"	,"Inflow Invoice"		,"SD1"       		})
Aadd(aSXB,{"SD1NF","2","01","01"	,"Documento"			,"Factura"				,"Document"				,"SD1"       		})
Aadd(aSXB,{"SD1NF","4","01","01"	,"Documento"			,"Factura"				,"Document"				,"SD1->D1_DOC"  	})
Aadd(aSXB,{"SD1NF","4","01","02"	,"Serie"				,"Serie"				,"Series"				,"SD1->D1_SERIE"	})
Aadd(aSXB,{"SD1NF","4","01","03"	,"Fornecedor"			,"Proveedor"			,"Supplier"				,"SD1->D1_FORNECE"	})
Aadd(aSXB,{"SD1NF","4","01","04"	,"Loja"		   			,"Tienda"				,"Unit"					,"SD1->D1_LOJA"		})
Aadd(aSXB,{"SD1NF","4","01","05"	,"Item"					,"Item"					,"Item"					,"SD1->D1_ITEMORI"	})
Aadd(aSXB,{"SD1NF","5","01",""		,""						,""						,""						,"SD1->D1_DOC"		})

dbSelectArea("SXB")
dbSetOrder(1)
For i := 1 To Len(aSXB)
	If !Empty(aSXB[i][1])
		If !dbSeek(PADR(aSXB[i,1],nTamSXB)+aSXB[i,2]+aSXB[i,3]+aSXB[i,4])
			lSXB := .T.
			RecLock("SXB",.T.)
			For j:=1 To Len(aSXB[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSXB[i,j])
				EndIf
			Next j
			dbCommit()
			MsUnLock()
		EndIf
	EndIf
Next i

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ajustando o dicionario SX1        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX1")
dbSetOrder(1)
If dbSeek(PADR('MTR170',nTamSX1)+"03") .And. Empty(SX1->X1_F3)
	RecLock("SX1",.F.)
	Replace X1_F3 With 'SD1NF'
	MsUnLock()
EndIf
If dbSeek(PADR('MTR170',nTamSX1)+"04") .And. Empty(SX1->X1_F3)
	RecLock("SX1",.F.)
	Replace X1_F3 With 'SD1NF'
	MsUnLock()
EndIf
RestArea(aAreaSX1)
RestArea(aAreaSX3)
RestArea(aAreaAnt)
Return
