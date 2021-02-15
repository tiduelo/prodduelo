
#INCLUDE "FINR865.CH"
#INCLUDE "PROTHEUS.CH"

#DEFINE N_VALSEST		1
#DEFINE N_VALIRRF		2
#DEFINE N_VALISS 		3
#DEFINE N_VALINSS		4
#DEFINE N_VALPIS 		5
#DEFINE N_VALCOF 		6
#DEFINE N_VALCSLL		7

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ FINR865	³ Autor ³ Nilton Pereira        ³ Data ³ 24.03.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relacao de titulos a pagar com rentencao PIS/Cofins/CSLL	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FINR865(void)			 								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function UFINR865()

Local oReport                              
Local aArea	:= GetArea()
Local cPerg := PadR( "FIN865", Len( SX1->X1_GRUPO ) )

AjustaSX1(cPerg)
                                                             
If FindFunction("TRepInUse") .And. TRepInUse()
	oReport := ReportDef()
	oReport:PrintDialog()
Else
	Return UFINR865R3() // Executa versão anterior do fonte
Endif

RestArea(aArea)  

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ReportDef º Autor ³ Marcio Menon		  º Data ³  01/09/06  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Definicao do objeto do relatorio personalizavel e das      º±±
±±º          ³ secoes que serao utilizadas.                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ EXPC1 - Grupo de perguntas do relatorio                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 										                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportDef()

Local oReport
Local oSection1        
Local oSection2
Local oSection3
Local cReport 	:= "FINR865" 				// Nome do relatorio
Local cDescri 	:= STR0001					//"Imprime a relacao dos titulos a pagar que sofreram retencao de Impostos"
Local cTitulo 	:= STR0007 					//"Relacao de Titulos a Pagar com retencao de Impostos"
Local cPerg		:= "FIN865"					// Nome do grupo de perguntas
Local aOrdem	:= {STR0004,STR0005}	 	//"Por Codigo Fornecedor"###"Por Nome Fornecedor"
Local aCodRet	:= {}						// Codigos de retencao selecionados para filtro

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte("FIN865",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros ³
//³ mv_par01		 // Do Fornecedor?     ³
//³ mv_par02		 // Ate Fornecedor?    ³
//³ mv_par03		 // Da Loja?      	  ³
//³ mv_par04		 // Ate Loja?          ³
//³ mv_par05		 // Da Emissao?	     ³
//³ mv_par06		 // Ate Emissao?       ³
//³ mv_par07		 // Do Vencimento?     ³
//³ mv_par08		 // Ate Vencimento?    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport := TReport():New(cReport, cTitulo, cPerg, {|oReport|	Iif( mv_par09 == 2 .Or. (mv_par09 == 1 .And. FR865CodRet( @aCodRet )),;
																ReportPrint( oReport, aCodRet ), .F. ) }, cDescri )

oReport:SetLandscape()	//Imprime o relatorio no formato paisagem
oReport:SetTotalInLine(.F.)		//Imprime o total em linha

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                                                                        ³
//³                      Definicao das Secoes                              ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Secao 01 (Dados Fornecedor)                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1 := TRSection():New(oReport,STR0022, {"TRB","SA2"}, aOrdem)

TRCell():New(oSection1,"CODIGO" ,"TRB",STR0020,/*Picture*/, 06 ,/*lPixel*/,{ || TRB->CODIGO  } )		//"Codigo"
TRCell():New(oSection1,"LOJA"   ,"TRB",STR0021,/*Picture*/, 02 ,/*lPixel*/,{ || TRB->LOJA 	  } )		//"Loja"
TRCell():New(oSection1,"NOMEFOR","TRB",STR0022,/*Picture*/, 40 ,/*lPixel*/,{ || TRB->NOMEFOR } )		//"Fornecedor"
TRCell():New(oSection1,"CGC"    ,"TRB",STR0023,/*Picture*/, 25 ,/*lPixel*/,{ || If(!Empty(TRB->CGC), TRB->CGC, ) } )	//"CGC"

oSection1:SetNoFilter("TRB")	// Desabilita Filtro
oSection1:SetNoFilter("SA2")	// Desabilita Filtro
oSection1:SetHeaderSection(.F.)	//Nao imprime o cabeçalho da secao

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Secao 02 (Titulos)                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection2 := TRSection():New(oSection1, STR0014, {"TRB","SE2"}, aOrdem)		//"TITULOS"

TRCell():New(oSection2,"PRF"    ,"TRB",STR0024,/*Picture*/, TamSX3("E2_PREFIXO")[1],/*lPixel*/,{ || TRB->PREFIXO } )	//"Prf"
TRCell():New(oSection2,"NUM"    ,"TRB",STR0025,/*Picture*/, TamSX3("E2_NUM")[1]    ,/*lPixel*/,{ || TRB->NUM     } )	//"Numero"
TRCell():New(oSection2,"PARCELA","TRB",STR0026,/*Picture*/, TamSX3("E2_PARCELA")[1],/*lPixel*/,{ || TRB->PARCELA } )	//"Pc"
TRCell():New(oSection2,"TIPO"   ,"TRB",STR0027,/*Picture*/, TamSX3("E2_TIPO")[1]   ,/*lPixel*/,{ || TRB->TIPO    } )	//"Tipo"
TRCell():New(oSection2,"EMISSAO","TRB",STR0028,/*Picture*/, TamSX3("E2_EMISSAO")[1],/*lPixel*/,/*{ || TRB->EMISSAO }*/ )	//"Emissao"
TRCell():New(oSection2,"VENCTO" ,"TRB",STR0029,/*Picture*/, TamSX3("E2_VENCREA")[1],/*lPixel*/,/*{ || TRB->VENCTO  }*/ )	//"Vencto"
TRCell():New(oSection2,"VALBASE","TRB",STR0030+STR0031,TM(0,15), 15,/*lPixel*/,/*{ || TRB->VALBASE }*/ )		//"Valor "##"Original"
TRCell():New(oSection2,"VALSEST","TRB",STR0030+STR0032,TM(0,15), 15,/*lPixel*/,/*{ || }*/ )	//"Valor "##"SEST"
TRCell():New(oSection2,"VALIRRF","TRB",STR0030+STR0033,TM(0,15), 15,/*lPixel*/,/*{ || }*/ )	//"Valor "##"IRRF"
TRCell():New(oSection2,"VALISS" ,"TRB",STR0030+STR0034,TM(0,15), 15,/*lPixel*/,/*{ || }*/ )	//"Valor "##"ISS"
TRCell():New(oSection2,"VALINSS","TRB",STR0030+STR0035,TM(0,15), 15,/*lPixel*/,/*{ || }*/ )	//"Valor "##"INSS"
TRCell():New(oSection2,"VALPIS" ,"TRB",STR0030+STR0036,TM(0,15), 15,/*lPixel*/,/*{ || }*/ )	//"Valor "##"PIS"
TRCell():New(oSection2,"VALCOF" ,"TRB",STR0030+STR0037,TM(0,15), 15,/*lPixel*/,/*{ || }*/ )	//"Valor "##"COFINS"
TRCell():New(oSection2,"VALCSLL","TRB",STR0030+STR0038,TM(0,15), 15,/*lPixel*/,/*{ || }*/ )	//"Valor "##"CSLL"
TRCell():New(oSection2,"VALLIQ" ,"TRB",STR0030+STR0039,TM(0,15), 15,/*lPixel*/,/*{ || If (!lPccBaixa .or. !lContrRet, TRB->VALLIQ, TRB->(VALLIQ-VALPIS-VALCOF-VALCSLL) ) }*/ )	//"Valor "##"Liquido"
TRCell():New(oSection2,"TIPORET",""   ,Substr(STR0017,1,1)+Substr(STR0018,1,1)+Substr(STR0019,1,1),/*Picture*/, 01 ,/*lPixel*/,/*CodeBlock*/)

oSection2:Cell("VALBASE"):SetHeaderAlign("RIGHT")
oSection2:Cell("VALSEST"):SetHeaderAlign("RIGHT")
oSection2:Cell("VALIRRF"):SetHeaderAlign("RIGHT")
oSection2:Cell("VALISS" ):SetHeaderAlign("RIGHT")
oSection2:Cell("VALINSS"):SetHeaderAlign("RIGHT")
oSection2:Cell("VALPIS" ):SetHeaderAlign("RIGHT")
oSection2:Cell("VALCOF" ):SetHeaderAlign("RIGHT")
oSection2:Cell("VALCSLL"):SetHeaderAlign("RIGHT")
oSection2:Cell("VALLIQ" ):SetHeaderAlign("RIGHT")
oSection2:Cell("TIPORET"):HideHeader()	//Oculta o texto do cabeçalho

oSection2:SetNoFilter("TRB")  	// Desabilita Filtro
oSection2:SetHeaderPage()	//Define o cabecalho da secao como padrao
oSection2:SetLineBreak(.T.)		//Quebra a linha quando não couber na página
oSection2:SetTotalInLine(.F.)   //Imprime o total em linha

oSection3 := TRSection():New(oSection2, STR0014, {"TRB"}, aOrdem)	//"TITULOS"

TRCell():New(oSection3,"TOTFIL" ,"TRB",,/*Picture*/, 50,/*lPixel*/ )	//"Prf"
TRCell():New(oSection3,"VALBASE","TRB",,TM(0,15), 15,/*lPixel*/ )	//"Valor "##"Original"
TRCell():New(oSection3,"VALSEST","TRB",,TM(0,15), 15,/*lPixel*/ )	//"Valor "##"SEST"
TRCell():New(oSection3,"VALIRRF","TRB",,TM(0,15), 15,/*lPixel*/ )	//"Valor "##"IRRF"
TRCell():New(oSection3,"VALISS" ,"TRB",,TM(0,15), 15,/*lPixel*/ )	//"Valor "##"ISS"
TRCell():New(oSection3,"VALINSS","TRB",,TM(0,15), 15,/*lPixel*/ )	//"Valor "##"INSS"
TRCell():New(oSection3,"VALPIS" ,"TRB",,TM(0,15), 15,/*lPixel*/ )	//"Valor "##"PIS"
TRCell():New(oSection3,"VALCOF" ,"TRB",,TM(0,15), 15,/*lPixel*/ )	//"Valor "##"COFINS"
TRCell():New(oSection3,"VALCSLL","TRB",,TM(0,15), 15,/*lPixel*/ )	//"Valor "##"CSLL"
TRCell():New(oSection3,"VALLIQ" ,"TRB",,TM(0,15), 15,/*lPixel*/ )	//"Valor "##"Liquido"

oSection3:SetNoFilter("TRB")  	// Desabilita Filtro
oSection3:SetHeaderSection(.F.)	//Nao imprime o cabeçalho da secao

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma   ³ReportPrint ³Autor³ Marcio Menon       ³ Data ³  01/09/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao  ³ Imprime o objeto oReport definido na funcao ReportDef.     º±± 
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros ³ oReport - Objeto TReport do relatorio                      º±±
±±º           ³ 				   										   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º   Data    ³    Autor   ³ BOPS ³        Manutencao Efetuada             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º06/11/2007 ³Pedro P Lima³134275³ O relatorio nao considerava o valor    º±±
±±º           ³   TI6434   ³ P10  ³ original do titulo, que era impresso   º±±
±±º           ³            ³      ³ com o valor 0,00 e tabem nao           º±±
±±º           ³            ³      ³ considerava o valor do campo valor liq.º±±
±±º           ³            ³      ³ que era impresso incorretamente.       º±±  
±±º           ³            ³      ³ Foi corrigido o trecho onde a variavel º±±
±±º           ³            ³      ³ nValBase recebe o valor original do    º±±
±±º           ³            ³      ³ titulo e o tratamento do valor liquido.º±± 
±±ÈÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportPrint( oReport, aCodRet )

Local oSection1 := oReport:Section(1) 
Local oSection2 := oReport:Section(1):Section(1)
Local oSection3 := oReport:Section(1):Section(1):Section(1)

Local oTotPis
Local oTotCof
Local oTotCsll

#IFDEF TOP
	Local cFilterUser := oSection1:GetSqlExp("SE2")
#ELSE
	Local cFilterUser := oSection1:GetADVPLExp("SE2")
#ENDIF
Local oBreak
Local nOrdem		:= oReport:Section(1):GetOrder()
Local nRegEmp   	:= SM0->(RecNo())
Local aTam	    	:= TAMSX3("E2_NUM")
Local CbCont
Local CbTxt
Local cCGCAnt
Local cChaveSe2
Local lContinua		:= .T.
Local nTitCli		:= 0
Local nTitRel		:= 0
Local nVlCliOri		:= 0
Local nVlCliIns		:= 0
Local nVlCliLiq		:= 0
Local nVlTotOri		:= 0
Local nVlTotIns		:= 0
Local nVlTotPis		:= 0
Local nVlTotCof		:= 0
Local nVlTotCsl		:= 0
Local nVlTotIrf		:= 0 
Local nVlCliIrf		:= 0
Local nVlTotIss		:= 0 
Local nVlCliIss		:= 0
Local nVlTotSes		:= 0 
Local nVlCliSes		:= 0
Local nVlCliPis		:= 0
Local nVlCliCof		:= 0
Local nVlCliCsl		:= 0
Local nVlTotLiq		:= 0
Local nX            := 0
Local aCampos		:= {}                                   
Local cCodFor		:= ""
Local cLojFor		:= ""
Local cNomFor		:= ""                       
Local cNomFil		:= ""
Local cNomFilAnt	:= ""
Local aTamNum		:= TAMSX3("E2_NUM")
Local nValBase	 	:= 0
Local nValLiq	 	:= 0
Local lFatura 	 	:= .F.
Local lCalcIssBx 	:=	!Empty( SE5->( FieldPos( "E5_VRETISS" ) ) ) .and. !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .and. ;
                   		!Empty( SE2->( FieldPos( "E2_TRETISS" ) ) ) .and. GetNewPar("MV_MRETISS","1") == "2"  //Retencao do ISS pela emissao (1) ou baixa (2)
Local cFilterSE2 	:= ""
Local cTipoForn		:= Iif( mv_par10 == 1, "F", Iif( mv_par10 == 2, "J", "" ) )	// Tipo de Fornecedor
Local lConsFil		:= ( mv_par11 == 1 )	// Considera Filiais
Local lMultFil   	:= .F.	// Indica que existe mais de uma filial para a empresa
Local nTotFil		:= 0	// Total de filiais da empresa atual
Local nTitFil		:= 0	// Total de titulos processados para filial
Local cCodRet		:= ""
Local nTotValImp	:= ""
Local aValImp		:= {}
Local lFilCRet		:= .F.		// Indica se foram selecionados codigos de retencao para filtro
Local lTitPai		:= SE2->( FieldPos( "E2_TITPAI" ) ) > 0
Local lTotPCC		:= .T.		// Indica se deve totalizar colunas de PCC. Deve ser .F. se a coluna TIPORET for igual a "B"
Local lImpFornec	:= .T.
Local lSE2Comp		:= Empty(xFilial("SE2"))

Local lContRetIRF	:= !Empty(SE2->(FieldPos("E2_VRETIRF"))) .AND. !Empty(SE2->(FieldPos("E2_PRETIRF")))

#IFNDEF TOP
	Local nIndexSE2
	Local cIndexSe2
#ENDIF

Local nTotREG		:= 0

Local lIRPFBaixa :=  	! Empty( SE2->( FieldPos( "E2_VRETIRF" ) ) ) .And. ;
						! Empty( SE2->( FieldPos( "E2_PRETIRF" ) ) ) .And. ;
						! Empty( SE5->( FieldPos( "E5_VRETIRF" ) ) ) .And. ;
						! Empty( SE5->( FieldPos( "E5_PRETIRF" ) ) ) 
Local lIRPFBxAux  := .F.

Private lContrRet	:= !Empty( SE2->( FieldPos( "E2_VRETPIS" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_VRETCOF" ) ) ) .And. ; 
				 	   !Empty( SE2->( FieldPos( "E2_VRETCSL" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETPIS" ) ) ) .And. ;
				 	   !Empty( SE2->( FieldPos( "E2_PRETCOF" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETCSL" ) ) )

Private lPCCBaixa := SuperGetMv("MV_BX10925",.T.,"2") == "1"  .and. (!Empty( SE5->( FieldPos( "E5_VRETPIS" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_VRETCOF" ) ) ) .And. ; 
                     !Empty( SE5->( FieldPos( "E5_VRETCSL" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETPIS" ) ) ) .And. ;
				 	 !Empty( SE5->( FieldPos( "E5_PRETCOF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETCSL" ) ) ) .And. ;
				 	 !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .And. !Empty( SFQ->( FieldPos( "FQ_SEQDES"  ) ) ) )

Private lSest  := SE2->(FieldPos("E2_SEST"))	> 0  //Verifica campo de SEST

oReport:SetTotalText({|| STR0016+"("+ALLTRIM(STR(nTitRel))+" "+IIF(nTitRel > 1,STR0014,STR0015)+")"})
oReport:SetPageFooter(4,{|| If(!oSection2:Printing(),F865Legenda(oReport),"")})

TRPosition():New(oSection1,"SA2",1,{|| xFilial("SA2")+TRB->CODIGO+TRB->LOJA}) 
TRPosition():New(oSection2,"SE2",1,{|| xFilial("SE2")+TRB->PREFIXO+TRB->NUM+TRB->PARCELA+TRB->TIPO+TRB->CODIGO+TRB->LOJA})

oBreak := TRBreak():New(oSection1,{|| TRB->CODIGO+TRB->LOJA},{|| STR0013 + AllTrim(cNomFor) +" ("+AllTrim(STR(nTitCli))+" "+IiF(nTitCli>1,STR0014,STR0015)+")"})
oBreak:OnBreak({|x| cNomFor := SA2->A2_NOME })

TRFunction():New(oSection2:Cell("PRF"),"","",oBreak,,,,.F.,.T.)
TRFunction():New(oSection2:Cell("NUM" ),"","",oBreak,,,,.F.,.T.)
TRFunction():New(oSection2:Cell("PARCELA"),"","",oBreak,,,,.F.,.T.)
TRFunction():New(oSection2:Cell("TIPO"),"","",oBreak,,,,.F.,.T.)
TRFunction():New(oSection2:Cell("EMISSAO" ),"","TIMESUB",oBreak,,,,.F.,.T.)
TRFunction():New(oSection2:Cell("VENCTO"),"","TIMESUB",oBreak,,,,.F.,.T.)
TRFunction():New(oSection2:Cell("VALBASE"),"","SUM",oBreak,,,,.F.,.T.)
TRFunction():New(oSection2:Cell("VALBASE"),"","SUM",oBreak,,,,.F.,.T.)
TRFunction():New(oSection2:Cell("VALSEST"),"","SUM",oBreak,,,,.F.,.T.)
TRFunction():New(oSection2:Cell("VALIRRF"),"","SUM",oBreak,,,,.F.,.T.)
TRFunction():New(oSection2:Cell("VALISS" ),"","SUM",oBreak,,,,.F.,.T.)
TRFunction():New(oSection2:Cell("VALINSS"),"","SUM",oBreak,,,,.F.,.T.)


oTotPis  := TRFunction():New(oSection2:Cell("VALPIS" ),"","SUM",oBreak,,,{|| Iif(	TRB->PRETPIS == "1" .Or. aValImp[N_VALPIS]  == 0, 0, TRB->VALPIS  ) },.F.,.T.,.F.,oSection2)
oTotCof  := TRFunction():New(oSection2:Cell("VALCOF" ),"","SUM",oBreak,,,{|| Iif(	TRB->PRETCOF == "1" .Or. aValImp[N_VALCOF]  == 0, 0, TRB->VALCOF  ) },.F.,.T.,.F.,oSection2)
oTotCsll := TRFunction():New(oSection2:Cell("VALCSLL"),"","SUM",oBreak,,,{|| Iif(	TRB->PRETCSL == "1" .Or. aValImp[N_VALCSLL] == 0, 0, TRB->VALCSLL ) },.F.,.T.,.F.,oSection2)

TRFunction():New(oSection2:Cell("VALLIQ" ),"","SUM",oBreak,,,,.F.,.T.)
If !lSest		//Se o campo SEST nao existir, ele oculta as colunas das secoes
	oSection2:Cell("VALSEST"):Disable()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a estrutura do TRB.				                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCampos	:= {	{"CODIGO"	,"C",TamSX3("A2_COD")[1],0 },;
				{"LOJA"	    ,"C",02,0 },;
				{"NOMEFOR"	,"C",40,0 },;
				{"CGC"		,"C",14,0 },;  
				{"FILIAL"   ,"C",TamSX3("E2_FILIAL")[1],0 },;
				{"PREFIXO"	,"C",03,0 },;
				{"NUM"		,"C",aTamNum[1],0 },;
				{"PARCELA"	,"C",TamSx3("E2_PARCELA")[1],0 },;
				{"TIPO"		,"C",03,0 },;
				{"EMISSAO"	,"D",08,0 },;
				{"VENCTO"	,"D",08,0 },;
				{"VALBASE"  ,"N",17,2 },;
				{"VALINSS"	,"N",17,2 },;
				{"VALPIS"	,"N",17,2 },;
				{"VALCOF"	,"N",17,2 },;
				{"VALCSLL"	,"N",17,2 },;
				{"VALIRRF"	,"N",17,2 },;
				{"VALISS"	,"N",17,2 },;
				{"VALSEST"	,"N",17,2 },;
				{"VALLIQ"	,"N",17,2 },;
				{"VRETPIS"	,"N",17,2 },;
				{"VRETCOF"	,"N",17,2 },;
				{"VRETCSL"	,"N",17,2 },;
				{"PRETPIS"	,"C",01,0 },;
				{"PRETCOF"	,"C",01,0 },;
				{"PRETCSL"	,"C",01,0 },; 
				{"PRETIRF"	,"C",01,0 },; 
				{"TRETISS"	,"C",01,0 },;
				{"FATURA"	,"C",TamSx3("E2_FATURA")[1],0 },; 
				{"PARCISS"  ,"C",TamSX3("E2_PARCPIS")[1],0 },;
				{"PARCINS"  ,"C",TamSX3("E2_PARCINS")[1],0 },;
				{"PARCIR"   ,"C",TamSX3("E2_PARCIR")[1],0 },;
				{"PARCPIS"  ,"C",TamSX3("E2_PARCPIS")[1],0 },;
				{"PARCCOF"  ,"C",TamSX3("E2_PARCCOF")[1],0 },;
				{"PARCSLL"  ,"C",TamSX3("E2_PARCSLL")[1],0 },;
				{"PARCSES"  ,"C",TamSX3("E2_PARCSES")[1],0 }}

// Verifica se existe mais de uma filial para a empresa posicionada
SM0->( dbSeek( cEmpAnt ) )
SM0->( DBEval( { || nTotFil++ },, { || SM0->M0_CODIGO == cEmpAnt } ) )

lMultFil := ( nTotFil > 1 )

// Monta string com codigos de retencao selecionadas no filtro
lFilCRet := ( Len( aCodRet ) > 0 )

If lFilCRet
	AEval( aCodRet, { |x| cCodRet += ( x + "/" ) } )
	cCodRet := Left( cCodRet, Len( cCodRet ) - 1 )
	oReport:OnPageBreak( { || FR865ImpCRet( oReport, cCodRet ) } )
EndIf

// Cons. Filiais Abaixo ?
If lConsFil	
	cFilDe  := mv_par12	// De Filial ?
	cFilAte := mv_par13	// Ate Filial ?
Else
	cFilDe  := cFilAnt
	cFilAte := cFilAnt
EndIf
                       
dbSelectArea("SM0")
dbSeek( cEmpAnt + cFilDe, .T. )

nRegSM0 := SM0->(Recno())

Do While SM0->( !Eof() .And. M0_CODIGO == cEmpAnt .And. M0_CODFIL <= cFilAte )
		
	cFilAnt := SM0->M0_CODFIL

	// Inicializa totalizadores por filial se considera filiais e utiliza mais de uma filial
	If lConsFil .And. lMultFil
		nTitFil	  := 0
		nVlFilOri := 0
		nVlFilLiq := 0
		nVlFilIns := 0
		nVlFilPis := 0
		nVlFilCof := 0
		nVlFilCsl := 0
		nVlFilIrf := 0
		nVlFilIss := 0
		nVlFilSes := 0
	EndIf
	                  

	dbSelectArea("SA2")			
	SA2->(dbSetOrder(1))

	dbSelectArea("SE2")
	
	If nOrdem == 1  //Por Codigo
		dbSetOrder(6)
	Else            //Por Nome
		dbSetOrder(2)
	Endif
	
	cChaveSe2 := IndexKey()
	cFilterSE2 := cFilterUser
	
	#IFDEF TOP
		If nOrdem == 1  //Por Codigo
			cOrder := "FILIAL, CODIGO,LOJA"
		Else            //Por Nome
			cOrder := "FILIAL, NOMEFOR"
		Endif
		
		cQuery := "SELECT A2_COD CODIGO,A2_LOJA LOJA,A2_NOME NOMEFOR,A2_CGC CGC, E2_FILIAL FILIAL, E2_PREFIXO PREFIXO,"
		cQuery += "E2_NUM NUM,E2_PARCELA PARCELA,E2_TIPO TIPO,E2_EMISSAO EMISSAO,E2_VENCREA VENCTO,"
		cQuery += "E2_IRRF VALIRRF,"
		cQuery += "E2_ISS VALISS,E2_INSS VALINSS,E2_FATURA FATURA,"
		cQuery += "E2_PIS VALPIS,E2_COFINS VALCOF,E2_CSLL VALCSLL,"	
		//Se controla Retencao
		If lContrRet
			cQuery += "E2_VRETPIS VRETPIS,E2_VRETCOF VRETCOF,E2_VRETCSL VRETCSL,"	
			cQuery += "E2_PRETPIS PRETPIS,E2_PRETCOF PRETCOF,E2_PRETCSL PRETCSL,"	
			If lSest  // So processa se existir o campo E2_SEST
				cQuery += "(E2_VALOR) VALBASE,"
				cQuery += "E2_SEST VALSEST,"
			Else
				cQuery += "(E2_VALOR) VALBASE,"
			Endif	
		Else
			If lSest  // So processa se existir o campo E2_SEST
				cQuery += "(E2_VALOR) VALBASE,"
				cQuery += "E2_SEST VALSEST,"
			Else
				cQuery += "(E2_VALOR) VALBASE,"
			Endif
		Endif		

		If lContRetIRF
			cQuery += "E2_VRETIRF VRETIRF, E2_PRETIRF PRETIRF, "
		Endif			

		IF lCalcIssBx
			cQuery += "E2_TRETISS TRETISS,"
		Endif
	
		cQuery += "E2_VALOR VALLIQ, E2_PARCISS PARCISS, E2_PARCINS PARCINS, E2_PARCIR PARCIR, "
		cQuery += "E2_PARCPIS PARCPIS, E2_PARCCOF PARCCOF, E2_PARCSLL PARCSLL, E2_PARCSES PARCSES "
		cQuery += "FROM " + RetSqlName("SA2")+" SA2, " + RetSqlName("SE2")+" SE2 "
		cQuery += " WHERE SA2.A2_FILIAL = '" + xFilial("SA2") + "' "
		cQuery += " AND SA2.A2_COD  BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "'"
		cQuery += " AND SA2.A2_LOJA BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "'"
		If !Empty( cTipoForn )
			cQuery += " AND SA2.A2_TIPO = '" + cTipoForn + "' "
		EndIf	
		cQuery += " AND SA2.D_E_L_E_T_ = ' ' "
		cQuery += " AND SE2.E2_FILIAL = '" + xFilial("SE2") + "'"
		cQuery += " AND SE2.E2_FORNECE = SA2.A2_COD"
		cQuery += " AND SE2.E2_LOJA	= SA2.A2_LOJA"
		cQuery += " AND SE2.E2_EMISSAO  <= '" + DTOS(dDataBase) + "'"
		cQuery += " AND (SE2.E2_INSS > 0 "
		cQuery += " OR SE2.E2_ISS > 0 "
		cQuery += " OR SE2.E2_PIS > 0 "
		cQuery += " OR SE2.E2_COFINS > 0 "
		cQuery += " OR SE2.E2_CSLL > 0 "
		If lSest
			cQuery += " OR SE2.E2_SEST > 0 "
		EndIf         

		If lContRetIRF
			cQuery += " OR (SE2.E2_IRRF > 0 OR (SE2.E2_VRETIRF > 0 AND SE2.E2_PRETIRF <> '1' ))) "
		Else 
			cQuery += " OR SE2.E2_IRRF > ) "		
		Endif
		cQuery += " AND SE2.E2_VENCREA  between '" + DTOS(mv_par07)  + "' AND '" + DTOS(mv_par08) + "'"
		cQuery += " AND SE2.E2_EMISSAO  between '" + DTOS(mv_par05)  + "' AND '" + DTOS(mv_par06) + "'"
		cQuery += " AND SE2.E2_EMISSAO  <= '"      + DTOS(dDataBase) + "'"		
		// Se considera filiais e SE2 estah compartilhado, realiza filtro por filial origem
		If lConsFil .And. lSE2Comp
			cQuery += " AND SE2.E2_FILORIG = '" + cFilAnt + "' "
		EndIf
		If !Empty(cFilterSE2)
	      	cQuery += " AND " + cFilterSE2
		EndIf
		
		cQuery += " AND SE2.D_E_L_E_T_ = ' ' "
		cQuery += " ORDER BY "+ cOrder
		cQuery := ChangeQuery(cQuery)
	
		dbSelectArea("SE2")
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .F., .T.)
	#ELSE
		cIndexSe2 := CriaTrab(nil,.f.)
		IndRegua("SE2",cIndexSe2,cChaveSe2,,,FR865IndR(cFilterSE2,cTipoForn,lSest,lConsFil,lSE2Comp,lContRetIRF),STR0011) //"Selecionando Registros..."
		nIndexSE2 := RetIndex("SE2")
		dbSetIndex(cIndexSe2+OrdBagExt())
		dbSetOrder(nIndexSE2+1)                                                                            
		dbSeek(xFilial("SE2"))
	
		cArqTrab := CriaTrab( aCampos )
		dbUseArea( .T.,, cArqTrab, "TRB", if(.F. .OR. .F., !.F., NIL), .F. )
		If nOrdem == 1  //Por Codigo
			IndRegua("TRB",cArqTrab,"CODIGO+LOJA",,,)
		Else            //Por Nome
			IndRegua("TRB",cArqTrab,"NOMEFOR",,,)
		Endif
		dbSetIndex( cArqTrab +OrdBagExt())
	
		dbSelectArea("SE2")				
	
		While SE2->(!Eof())
		
			dbSelectArea("SA2")			
			SA2->(dbSetOrder(1))
			
			If SA2->(dbSeek(xFilial("SA2")+SE2->(E2_FORNECE+E2_LOJA)))
				
				lCalcIssBx :=	IIf( ! Empty( SA2->( FieldPos( "A2_TIPO" ) ) ),SA2->A2_TIPO == "J", .F.) .And.;
								!Empty( SE5->( FieldPos( "E5_VRETISS" ) ) ) .and. !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .And. ;
								!Empty( SE2->( FieldPos( "E2_TRETISS" ) ) ) .and. GetNewPar("MV_MRETISS","1") == "2" //Retencao do ISS pela emissao (1) ou baixa (2)
							

				If	lContrRet
					nValBase := SE2->(E2_VALOR+E2_IRRF+E2_INSS+E2_ISS)
					nValLiq := SE2->E2_VALOR
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³No que esta consolidado nao se pode determinar qual o    ³
					//³tipo de retencao de PCC estava em uso e nao se pode usar ³
					//³o parametro MV_BX10925 como referencia, entao utilizar   ³
					//³apenas os campos PRET para determinar se o PCC deve      ³
					//³ou nao ser agregado ao valor original do titulo.         ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If (Empty(SE2->E2_PRETPIS) .OR. Empty(SE2->E2_PRETCOF) .OR. Empty(SE2->E2_PRETCSL)) .AND. SE2->(E2_PIS+E2_COFINS+E2_CSLL) > 0
						//PCC retido na emissao nele mesmo, somar para compor o valor original.
						nValBase += SE2->(E2_PIS+E2_COFINS+E2_CSLL)
					Else
						//PCC retido na baixa ou na emissao nao nele mesmo, ou seja, o E2_VALOR nao sofreu abatimento, entao abater o PCC para obter o liquido
						nValLiq -= SE2->(E2_PIS+E2_COFINS+E2_CSLL)
					Endif
				Else
					nValBase := SE2->(E2_VALOR+E2_IRRF+E2_INSS+E2_ISS+E2_PIS+E2_COFINS+E2_CSLL)
					nValLiq := SE2->E2_VALOR
				Endif
				If lSest
					nValBase += SE2->E2_SEST
				Endif
				
				dbSelectArea("TRB")
				RecLock("TRB",.T.)	
				TRB->CODIGO		:= SA2->A2_COD
				TRB->LOJA		:= SA2->A2_LOJA
				TRB->NOMEFOR	:= SA2->A2_NOME 
				TRB->CGC		:= SA2->A2_CGC
				TRB->FILIAL  	:= SE2->E2_FILIAL
				TRB->PREFIXO	:= SE2->E2_PREFIXO
				TRB->NUM		:= SE2->E2_NUM
				TRB->PARCELA	:= SE2->E2_PARCELA
				TRB->TIPO		:= SE2->E2_TIPO
				TRB->EMISSAO	:= SE2->E2_EMISSAO
				TRB->VENCTO		:= SE2->E2_VENCREA
				TRB->VALBASE	:= nValBase
				TRB->VALINSS	:= SE2->E2_INSS
				TRB->VALPIS		:= SE2->E2_PIS
				TRB->VALCOF		:= SE2->E2_COFINS
				TRB->VALCSLL	:= SE2->E2_CSLL 
				TRB->VALIRRF	:= SE2->E2_IRRF
				TRB->VALISS		:= SE2->E2_ISS       
				TRB->FATURA		:= SE2->E2_FATURA
				TRB->TRETISS	:= SE2->E2_TRETISS 			
				TRB->PARCISS	:= SE2->E2_PARCISS
				TRB->PARCINS	:= SE2->E2_PARCINS
				TRB->PARCIR		:= SE2->E2_PARCIR
				TRB->PARCPIS	:= SE2->E2_PARCPIS
				TRB->PARCCOF	:= SE2->E2_PARCCOF
				TRB->PARCSLL	:= SE2->E2_PARCSLL
				TRB->PARCSES	:= SE2->E2_PARCSES
				
				If lSest  // So processa se existir o campo E2_SEST
					TRB->VALSEST := SE2->E2_SEST  
				Endif
				TRB->VALLIQ := nValLiq
	
				//Se controla retencao
				If lContrRet
					TRB->VRETPIS	:= SE2->E2_VRETPIS
					TRB->VRETCOF	:= SE2->E2_VRETCOF
					TRB->VRETCSL	:= SE2->E2_VRETCSL 
					TRB->PRETPIS	:= SE2->E2_PRETPIS
					TRB->PRETCOF	:= SE2->E2_PRETCOF
					TRB->PRETCSL	:= SE2->E2_PRETCSL 
				Endif			
	    		
				MSUnlock()
			Endif
			SE2->(dbSkip())
		EndDo
	#ENDIF
	dbSelectArea("TRB")
	TRB->(dbGoTop())
	TRB->(dbEval({|| nTotREG++}))
	TRB->(dbGoTop())	
	
	oReport:SetMeter(nTotREG)

	Do While !TRB->(Eof())
	
		nTitCli		:= 0
		nVlCliOri	:= 0
		nVlCliIns	:= 0
		nVlCliLiq	:= 0
		nVlCliPis	:= 0
		nVlCliCof	:= 0
		nVlCliCsl	:= 0
		nVlCliSes	:= 0
		nVlCliIrf	:= 0
		nVlCliIss	:= 0
		nValBase	:= 0
                    
		// Inicializa totais de PIS, COFINS e CSLL que devem ser abatidos do total do fornecedor se coluna TIPORET igual a "B"
		nNTotPis	:= 0
		nNTotCof	:= 0
		nNTotCsl	:= 0
	
		cCodFor		:= TRB->CODIGO
		cLojFor		:= TRB->LOJA
		cNomFor		:= TRB->NOMEFOR                       
		cCGCAnt		:= TRB->CGC
	
		lImpFornec	:= .T.

		Do While TRB->(!EOF()) .AND. cCodFor + cLojFor == TRB->(CODIGO+LOJA) .AND. cNomFor == TRB->NOMEFOR 

			
			If SA2->(! dbSeek(xFilial("SA2")+TRB->CODIGO+TRB->LOJA) )
				TRB->( dbSkip() )
				Loop
			EndIf

			lIRPFBAux  := lIRPFBaixa
			If SA2->( FieldPos( "A2_CALCIRF" ) ) > 0
				lIRPFBxAux := lIRPFBAux .And. ( SA2->A2_CALCIRF == "2" )
			Else
				lIRPFBxAux := .F.
			EndIf

			// Inicializa vetor com o valor dos impostos do titulo
			aValImp := {;
						TRB->VALSEST,;		// Valor SEST
						TRB->VALIRRF,;		// Valor IRRF 	
						TRB->VALISS ,;		// Valor ISS
						TRB->VALINSS,;		// Valor INSS
						TRB->VALPIS	,;		// Valor PIS
						TRB->VALCOF	,;		// Valor COFINS
						TRB->VALCSLL }		// Valor CSLL
			           
			// Se utiliza filtro por codigo de retencao, altera os valores do vetor 
			// de acordo com os codigos de retencao selecionados para filtro
			If lFilCRet

				nTotValImp := 0
				FR865FilCRet( @aValImp, aCodRet, lTitPai )
				AEval( aValImp, { |x| nTotValImp += x } )

				// Se todos os impostos estao com valor zero, vai para o proximo titulo
				If nTotValImp == 0
					TRB->(dbSkip())
					Loop     
				EndIf

			EndIf
             
			If lImpFornec
				oSection1:Init()
				oSection1:Cell("CGC"):SetPicture(IIF(Len(Alltrim(TRB->CGC)) == 11 , "@R 999.999.999-99","@R 99.999.999/9999-99"))					
				oSection1:PrintLine()
				oSection2:Init()
				lImpFornec := .F.
			EndIf		

			oSection2:Cell("VALSEST"):SetBlock( { || aValImp[N_VALSEST] } )
			oSection2:Cell("VALIRRF"):SetBlock( { || aValImp[N_VALIRRF] } )
			oSection2:Cell("VALISS" ):SetBlock( { || aValImp[N_VALISS]  } )
			oSection2:Cell("VALINSS"):SetBlock( { || aValImp[N_VALINSS] } )
			oSection2:Cell("VALPIS" ):SetBlock( { || aValImp[N_VALPIS]  } )
			oSection2:Cell("VALCOF" ):SetBlock( { || aValImp[N_VALCOF]  } )
			oSection2:Cell("VALCSLL"):SetBlock( { || aValImp[N_VALCSLL] } )
	
			lFatura := .F.
			lTotPCC	:= .T.
			
		 	If !Empty(TRB->FATURA) .And. TRB->FATURA == 'NOTFAT'
				lFatura := .T.
			EndIf 

			oSection2:Cell("EMISSAO"):SetBlock( { || STOD(TRB->EMISSAO) } )
			oSection2:Cell("VENCTO" ):SetBlock( { || STOD(TRB->VENCTO) } )	
			#IFDEF TOP
				If	lContrRet

					nValBase	:= TRB->(VALBASE+If(!lIRPFBxAux,VALIRRF,0)+VALINSS+VALISS)
					nValLiq := TRB->VALLIQ
                     

					If !lPccBaixa
						If (Empty( TRB->PRETPIS) .OR. Empty( TRB->PRETCOF) .OR. Empty( TRB->PRETCSL)) .AND.  TRB->(VALPIS+VALCOF+VALCSLL)  > 0
						//PCC retido na emissao nele mesmo, somar para compor o valor original.
					   		nValBase += TRB->(VALPIS+VALCOF+VALCSLL) 
				  		
				  		Elseif ( ( TRB->PRETPIS == '2')   .OR.  ( TRB->PRETCOF == '2') .OR. ( TRB->PRETCSL == '2')) .AND. TRB->( VALPIS + VALCOF + VALCSLL ) > 0
						//PCC retido na baixa ou na emissao nao nele mesmo, ou seja, o E2_VALOR nao sofreu abatimento, entao abater o PCC para obter o liquido
							nValLiq -= TRB->(VALPIS+VALCOF+VALCSLL) 
						Endif
					Endif
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³No que esta consolidado nao se pode determinar qual o    ³
					//³tipo de retencao de PCC estava em uso e nao se pode usar ³
					//³o parametro MV_BX10925 como referencia, entao utilizar   ³
					//³apenas os campos PRET para determinar se o PCC deve      ³
					//³ou nao ser agregado ao valor original do titulo.         ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If	( ( TRB->PRETPIS <> '2' .And. TRB->PRETPIS <> '3' )   .OR.  ;
						  ( TRB->PRETCOF <> '2' .And. TRB->PRETCOF <> '3' )   .OR.  ;
						  ( TRB->PRETCSL <> '2' .And. TRB->PRETCSL <> '3' ) ) .AND. ;
						  TRB->( VALPIS + VALCOF + VALCSLL ) > 0

						//PCC retido na emissao nele mesmo, somar para compor o valor original.
					

					    If	( ( TRB->PRETPIS <> '2' .And. TRB->PRETPIS <> '3' )   .OR.  ;
						  	  ( TRB->PRETCOF <> '2' .And. TRB->PRETCOF <> '3' )   .OR.  ;
						  	  ( TRB->PRETCSL <> '2' .And. TRB->PRETCSL <> '3' ) ) .AND. ;
							  TRB->( VALPIS + VALCOF + VALCSLL ) > 0
					    
					    	nDescont:= TRB->(VRETPIS+VRETCOF+VRETCSL) - TRB->(VALPIS+VALCOF+VALCSLL) 
							nValLiq += nDescont
							If !lIRPFBxAux
								nValBase+= nDescont
							EndIf
						EndIf			   	  		

					Elseif lPccBaixa .and. (( TRB->PRETPIS <> '2') .OR. ( TRB->PRETCOF <> '2') .OR. ( TRB->PRETCSL <> '2' ))

						//PCC retido na baixa ou na emissao nao nele mesmo, ou seja, o E2_VALOR nao sofreu abatimento, entao abater o PCC para obter o liquido
						nValLiq -= TRB->(VALPIS+VALCOF+VALCSLL)

					Endif

				Else

					nValBase := TRB->VALBASE
					nValLiq := TRB->VALLIQ

				Endif

				//Caso o calculo do ISS seja efetuado na baixa do titulo, nao somo o imposto para compor o valor base
				If lCalcIssBx .and. TRB->TRETISS == "2"
					nValBase -= TRB->VALISS
					nValLiq	 -= TRB->VALISS
				Endif
				
				If lIRPFBxAux .and. TRB->PRETIRF $ "1/7/ /4"
//					nValBase -= TRB->VALIRRF
					nValLiq	 -= TRB->VALIRRF
				Endif
				oSection2:Cell("VALBASE"):SetBlock( { || nValBase } )
				oSection2:Cell("VALLIQ" ):SetBlock( { || nValLiq } )
			#ELSE
				nValBase := TRB->VALBASE
				nValLiq := TRB->VALLIQ
				//Caso o calculo do ISS seja efetuado na baixa do titulo, nao somo o imposto para compor o
				//valor base
				If lCalcIssBx .AND. TRB->TRETISS == "2"
					nValBase -= TRB->VALISS
					nValLiq	 -= TRB->VALISS
				Endif
				
				If lIRPFBxAux .and. TRB->PRETIRF $ "1/7/ /4"
//					nValBase -= TRB->VALIRRF
					nValLiq	 -= TRB->VALIRRF
				Endif
				oSection2:Cell("VALBASE"):SetBlock( { || nValBase } )
				oSection2:Cell("VALLIQ" ):SetBlock( { || nValLiq } )
			#ENDIF
			oSection2:Cell("TIPORET"):Hide()
			If lContrRet // Verifica se o sistema esta fazendo controle de retencao de impostos
				If lPccBaixa	// Geracao dos impostos lei 10925 pela baixa
					If TRB->(VALPIS+VALCOF+VALCSLL) > 0  
						If TRB->TIPO $ MVPAGANT 
							If TRB->PRETPIS == "1" .OR. TRB->PRETCOF == "1" .OR. TRB->PRETCSL == "1"
								If TRB->(VRETPIS+VRETCOF+VRETCSL) == 0	   
									oSection2:Cell("TIPORET"):Show()
									oSection2:Cell("TIPORET"):SetBlock( { || "A" } )
								Endif
							Endif			                                               					
						Else
							If TRB->PRETPIS == "3" .OR. TRB->PRETCOF == "3" .OR. TRB->PRETCSL == "3"
								If TRB->(VRETPIS+VRETCOF+VRETCSL) == 0
									oSection2:Cell("TIPORET"):Show()								
									oSection2:Cell("TIPORET"):SetBlock( { || "A" } )
								Endif
							ElseIf TRB->PRETPIS == "1" .OR. TRB->PRETCOF == "1" .OR. TRB->PRETCSL == "1"
								oSection2:Cell("TIPORET"):Show()							
								oSection2:Cell("TIPORET"):SetBlock( { || "B" } )   
								lTotPCC := .F.
							Endif
						Endif
					Endif			
				Else
					If TRB->PRETPIS == "2" .OR. TRB->PRETCOF == "2" .OR. TRB->PRETCSL == "2"
						oSection2:Cell("TIPORET"):Show()					
						oSection2:Cell("TIPORET"):SetBlock( { || "A" } )					
					ElseIf TRB->PRETPIS == "1" .OR. TRB->PRETCOF == "1" .OR. TRB->PRETCSL == "1"
						oSection2:Cell("TIPORET"):Show()					
						oSection2:Cell("TIPORET"):SetBlock( { || "B" } )	
						lTotPCC := .F.
					Endif
				Endif
			Endif
			
		 	If lFatura   
				oSection2:Cell("TIPORET"):Show()		 	
				oSection2:Cell("TIPORET"):SetBlock( { || "C" } )
			EndIf
	
			oSection2:PrintLine()
			
			nTitCli++
	
			If !lFatura
				nVlCliOri += nValBase
			EndIf
	
			nVlCliLiq += nValLiq
			nVlCliIns += aValImp[N_VALINSS]
			nVlCliIrf += aValImp[N_VALIRRF]
			nVlCliIss += aValImp[N_VALISS]
	
		 	If lTotPCC
				nVlCliPis += aValImp[N_VALPIS]
				nVlCliCof += aValImp[N_VALCOF]
				nVlCliCsl += aValImp[N_VALCSLL]
			Else
				nNTotPis  += aValImp[N_VALPIS]
				nNTotCof  += aValImp[N_VALCOF]
				nNTotCsl  += aValImp[N_VALCSLL]
			EndIf
	
			If lSest   // So processa se existir o campo E2_SEST
				nVlCliSes += aValImp[N_VALSEST]
			Endif
			    
			If lConsFil .And. lMultFil
				If !lFatura
			        nVlFilOri += nValBase
			    EndIf 
				nVlFilLiq += nValLiq
				nVlFilIns += aValImp[N_VALINSS]
				If lTotPCC
					nVlFilPis += aValImp[N_VALPIS]
					nVlFilCof += aValImp[N_VALCOF]
					nVlFilCsl += aValImp[N_VALCSLL]
				EndIf	
				nVlFilIrf += aValImp[N_VALIRRF]
				nVlFilIss += aValImp[N_VALISS]
				If lSest
					nVlFilSes += aValImp[N_VALSEST]
				EndIf
			EndIf
	
			TRB->(dbSkip())
			oReport:IncMeter()
		Enddo	

		oSection1:Finish()
		oSection2:Finish()

		If lConsFil .And. lMultFil
			nTitFil += nTitCli
		EndIf
			
		nTitRel += nTitCli

		oReport:IncMeter()
	Enddo

	#IFNDEF TOP
		dbSelectArea("SE2")
		dbClearFilter()
		RetIndex( "SE2" )
		If !Empty(cIndexSE2)
			FErase (cIndexSE2+OrdBagExt())
		Endif
		dbSetOrder(1)
		TRB->(dbCloseArea())
		fErase( cArqTrab + GetDBExtension() )
		fErase( cArqTrab + OrdBagExt() )
	#ELSE
		dbSelectArea("SE2")
		dbCloseArea()
		ChKFile("SE2")
		dbSelectArea("SE2")
		dbSetOrder(1)
		TRB->(dbCloseArea())
	#ENDIF

	If lConsFil .And. lMultFil
		lTemCont := If(nTitFil > 0,.T.,.F.)
		
		If lTemCont		
			cNomFil 	:= cFilAnt + " - " + AllTrim(SM0->M0_FILIAL) + " (" + AllTrim( Str(nTitFil) ) + " " + Iif( nTitFil > 1, STR0014, STR0015 ) + ")"
			cNomFilAnt  := cNomFil
		Else
			cNomFil     := cNomFilAnt  
		Endif        
		If nTitFil > 0
			FR865QuebraFil( nTitFil, nVlFilOri, nVlFilLiq, nVlFilIns, nVlFilPis, nVlFilCof,;
							nVlFilCsl, nVlFilIrf, nVlFilIss, nVlFilSes, oReport )
		EndIf	
	EndIf

	dbSelectArea("SM0")
	dbSkip()	

EndDo

SM0->( dbGoTo( nRegSM0 ) )
cFilAnt := SM0->M0_CODFIL

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F865Legendaº Autor ³ Marcio Menon	      º Data ³  09/05/08  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Impressao da legenda de retencao de impostos.		      º±±
±±º          ³ 								                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ 											                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Finr865								                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function F865Legenda(oReport)

Local lContrRet	:= 	!Empty( SE2->( FieldPos( "E2_VRETPIS" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_VRETCOF" ) ) ) .And. ;
					!Empty( SE2->( FieldPos( "E2_VRETCSL" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETPIS" ) ) ) .And. ;
					!Empty( SE2->( FieldPos( "E2_PRETCOF" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETCSL" ) ) )

If lContrRet
	oReport:PrintText(STR0017)		// A = Os valores de Pis,Cofins e Csll deste titulo foram retidos em outro titulo.
	oReport:PrintText(STR0018)		// B = Os valores de Pis,Cofins e Csll deste titulo se referem a uma previsao, ainda nao foram retidos.
	oReport:PrintText(STR0019)		// C = Os registros referentes a fatura não são incluidos nos totalizadores.
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ FR865QuebraFil ³Autor ³ Gustavo Henrique ³ Data ³ 02/07/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprimir total do relatorio								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPN1  - Total de titulos da filial                        ³±±
±±³          ³ EXPN2  - Total de valor original da filial                 ³±±
±±³          ³ EXPN3  - Total de valor liquido da filial                  ³±±
±±³          ³ EXPN4  - Total do imposto INSS da filial                   ³±±
±±³          ³ EXPN5  - Total do imposto PIS  da filial                   ³±±
±±³          ³ EXPN6  - Total do imposto COFINS da filial                 ³±±
±±³          ³ EXPN7  - Total do imposto CSLL da filial                   ³±±
±±³          ³ EXPN8  - Total do imposto IRRF da filial                   ³±±
±±³          ³ EXPN9  - Total do imposto ISS da filial                    ³±±
±±³          ³ EXPN10 - Total do imposto SEST da filial                   ³±±
±±³          ³ EXPN11 - Objeto do relatorio de Retencao de Impostos       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINR865 				   									  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function FR865QuebraFil( nTitFil, nVlFilOri, nVlFilLiq, nVlFilIns, nVlFilPis, nVlFilCof,;
								nVlFilCsl, nVlFilIrf, nVlFilIss, nVlFilSes, oReport )

Local nTamChave :=	TamSX3("E2_PREFIXO")[1] + TamSX3("E2_NUM")[1]     + TamSX3("E2_PARCELA")[1] +;
					TamSX3("E2_TIPO")[1]    + TamSX3("E2_EMISSAO")[1] + TamSX3("E2_VENCREA")[1]
Local oSection3 := oReport:Section(1):Section(1):Section(1)

oReport:SkipLine()
         
oSection3:Init()

oSection3:Cell("TOTFIL"  ):SetBlock({|| STR0042 + " - " + cFilAnt + " - " + AllTrim(SM0->M0_FILIAL) +;	 		// Total Filial
							" (" + AllTrim( Str(nTitFil) ) + " " + Iif( nTitFil > 1, STR0014, STR0015 ) + ")" })	// TITULOS ### TITULO
oSection3:Cell("VALBASE" ):SetBlock({|| })
oSection3:Cell("VALLIQ"  ):SetBlock({|| })
oSection3:Cell("VALSEST" ):SetBlock({|| })
oSection3:Cell("VALIRRF" ):SetBlock({|| })
oSection3:Cell("VALISS"  ):SetBlock({|| })
oSection3:Cell("VALINSS" ):SetBlock({|| })
oSection3:Cell("VALPIS"  ):SetBlock({|| })
oSection3:Cell("VALCOF"  ):SetBlock({|| })
oSection3:Cell("VALCSLL" ):SetBlock({|| })

oSection3:PrintLine()

oReport:ThinLine()
                                              
oSection3:Cell("TOTFIL"  ):SetSize(nTamChave+7)
oSection3:Cell("TOTFIL"  ):SetBlock({|| })
oSection3:Cell("VALBASE" ):SetBlock({|| nVlFilOri })
oSection3:Cell("VALLIQ"  ):SetBlock({|| nVlFilLiq })
oSection3:Cell("VALSEST" ):SetBlock({|| nVlFilSes })
oSection3:Cell("VALIRRF" ):SetBlock({|| nVlFilIrf })
oSection3:Cell("VALISS"  ):SetBlock({|| nVlFilIss })
oSection3:Cell("VALINSS" ):SetBlock({|| nVlFilIns })
oSection3:Cell("VALPIS"  ):SetBlock({|| nVlFilPis })
oSection3:Cell("VALCOF"  ):SetBlock({|| nVlFilCof })
oSection3:Cell("VALCSLL" ):SetBlock({|| nVlFilCsl })

oSection3:PrintLine()
oSection3:Finish()

oSection3:Cell("TOTFIL"  ):SetSize(50)

oReport:SkipLine()			

Return                              
                  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FR865ImpCRet ºAutor ³ Gustavo Henrique º Data ³ 03/07/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Imprimir os codigos de retencao selecionados no filtro.    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Relatorio de Retencao de Impostos                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FR865ImpCRet(oReport, cCodRet)
oReport:PrintText("Códigos de Retenção Selecionados: " + cCodRet)
oReport:ThinLine()
oReport:SkipLine()
Return

/*
---------------------------------------------- Release 3 ---------------------------------------------------------
*/
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	  ³ FINR865  ³ Autor ³ Nilton Pereira        ³ Data ³ 24.03.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o  ³ Relacao de titulos a pagar com rentencao PIS/Cofins/CSLL   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e  ³ FINR865(void)									           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		  ³ Generico 												   ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º   Data    ³    Autor   ³ BOPS ³        Manutencao Efetuada             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º06/11/2007 ³Pedro P Lima³134275³ O relatorio nao considerava o valor    º±±
±±º           ³   TI6434   ³ P10  ³ original do titulo, que era impresso   º±±
±±º           ³            ³      ³ com o valor 0,00 e tabem nao           º±±
±±º           ³            ³      ³ considerava o valor do campo valor liq.º±±
±±º           ³            ³      ³ que era impresso incorretamente.       º±±  
±±º           ³            ³      ³ Foi corrigido o trecho onde a variavel º±±
±±º           ³            ³      ³ nValBase recebe o valor original do    º±±
±±º           ³            ³      ³ titulo e o tratamento do valor liquido.º±± 
±±º           ³            ³      ³ RELEASE 3                              º±± 
±±ÈÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static Function UFINR865R3()

Local cDesc1    := STR0001 //"Imprime a relacao dos titulos a pagar que sofreram retencao de Impostos"
Local cDesc2    := ""
Local cDesc3    := ""
Local wnrel
Local cString   := "SE2" //Contas a Pagar
Local nRegEmp   := SM0->(RecNo())
Local aTam	    := TAMSX3("E2_NUM")
Local aCodRet	:= {}	// Codigos de retencao selecionados para filtro
Local lOk		:= .T.

Private titulo  := ""
Private cabec1  := ""
Private cabec2  := ""
Private aLinha  := {}
Private aReturn := { STR0002, 1,STR0003, 1, 2, 1, "",1 }   //"Zebrado"###"Administracao"
Private aOrd    := {STR0004,STR0005} //"Por Codigo Fornecedor"###"Por Nome Fornecedor"
Private cPerg	 := "FIN865"
Private nJuros  := 0
Private nLastKey:= 0
Private nomeprog:= "FINR865"
Private tamanho := "G"
Private lSest   := SE2->(FieldPos("E2_SEST"))	> 0  //Verifica campo de SEST                                        

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetKey (VK_F12,{|a,b| AcessaPerg("FIN865",.T.)})
			
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros ³
//³ mv_par01		 // Data de?   	     ³
//³ mv_par02		 // Data ate?          ³
//³ mv_par03		 // Organiza por?      ³
//³ mv_par04		 // Enviados?          ³
//³ mv_par05		 // De Emissao?	     ³
//³ mv_par06		 // Ate Emissao?       ³
//³ mv_par07		 // De Vencto?		     ³
//³ mv_par08		 // Ate Vencto?        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte("FIN865",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Defini‡„o dos cabe‡alhos ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo := STR0007 //"Relacao de Titulos a Pagar com retencao de Impostos"
cabec1 := STR0008 //"Codigo         Nome do Fornecedor             CGC"
If lSest  // So processa se existir o campo E2_SEST
	cabec2 := STR0009 //"     Prf Numero      Pc  Tipo  Dt.Emissao Dt.Vencto  Valor Original           Valor SEST         Valor IRFF           Valor ISS          Valor INSS           Valor PIS        Valor COFINS          Valor CSLL       Valor Liquido"
Else
	cabec2 := STR0010 //"     Prf Numero      Pc  Tipo  Dt Emissao Dt.Vencto  Valor Original                              Valor IRFF           Valor ISS          Valor INSS           Valor PIS        Valor COFINS          Valor CSLL       Valor Liquido"
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros	³
//³ mv_par01		 // Do Cliente			³
//³ mv_par02		 // Ate o Cliente		³
//³ mv_par03		 // Da loja				³
//³ mv_par04		 // Ate a loja			³
//³ mv_par05		 // Da DaTa				³
//³ mv_par06		 // Ate Data			³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a fun‡„o SETPRINT ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "FINR865"            //Nome Default do relatorio em Disco
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,"",.T.)
If nLastKey == 27
	Return
Endif
SetDefault(aReturn,cString)
If nLastKey == 27
	Return
Endif
// Indica se deve realizar filtro de codigos de retencao
If mv_par09 == 1	// Sim
	lOk := FR865CodRet( @aCodRet )
EndIf	
If lOk
	RptStatus({|lEnd| FA865Imp(@lEnd,wnRel,cString,aCodRet)},titulo)  // Chamada do Relatorio
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	  ³ FA865Imp ³ Autor ³ Nilton Pereira        ³ Data ³ 24.03.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o  ³ Imprime relat¢rio dos T¡tulos a Receber c/Retencao de INSS ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e  ³ FA865Imp(lEnd,WnRel,cString)						       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ lEnd	  - A‡Æo do Codeblock							   ³±±
±±³			  ³ wnRel   - T¡tulo do relat¢rio							   ³±±
±±³			  ³ cString - Mensagem										   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		  ³ Generico												   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FA865Imp(lEnd,WnRel,cString,aCodRet)

Local CbCont
Local CbTxt
Local cCGCAnt
Local cChaveSe2
Local lContinua		:= .T.
Local nTitCli		:= 0
Local nTitRel		:= 0
Local nVlCliOri		:= 0
Local nVlCliIns		:= 0
Local nVlCliLiq		:= 0
Local nVlTotOri		:= 0
Local nVlTotIns		:= 0
Local nVlTotPis		:= 0
Local nVlTotCof		:= 0
Local nVlTotCsl		:= 0
Local nVlTotIrf		:= 0 
Local nVlCliIrf		:= 0
Local nVlTotIss		:= 0 
Local nVlCliIss		:= 0
Local nVlTotSes		:= 0 
Local nVlCliSes		:= 0
Local nVlCliPis		:= 0
Local nVlCliCof		:= 0
Local nVlCliCsl		:= 0
Local nVlTotLiq		:= 0
Local nVlFilOri 	:= 0
Local nVlFilLiq 	:= 0
Local nVlFilIns 	:= 0
Local nVlFilPis 	:= 0
Local nVlFilCof 	:= 0
Local nVlFilCsl 	:= 0
Local nVlFilIrf 	:= 0
Local nVlFilIss 	:= 0
Local nVlFilSes 	:= 0
Local nTitFil		:= 0
Local nRegSM0		:= 0
Local aCampos		:= {}                                   
Local cCodFor		:= ""
Local cLojFor		:= ""
Local cNomFor		:= ""                       
Local aTamNum		:= TAMSX3("E2_NUM")
Local nOrdem		:= aReturn[8]   
Local nValBase		:= 0
Local nValLiq		:= 0
Local lFatura		:= .F.
Local lContrRet 	:= !Empty( SE2->( FieldPos( "E2_VRETPIS" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_VRETCOF" ) ) ) .And. ; 
				 		!Empty( SE2->( FieldPos( "E2_VRETCSL" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETPIS" ) ) ) .And. ;
				 		!Empty( SE2->( FieldPos( "E2_PRETCOF" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETCSL" ) ) )

Local lConsFil		:= ( mv_par11 == 1 )	// Considera Filiais
Local cTipoForn		:= Iif( mv_par10 == 1, "F", Iif( mv_par10 == 2, "J", "" ) )	// Tipo de Fornecedor

#IFNDEF TOP
	Local nIndexSE2
	Local cIndexSe2
#ENDIF

Local lPCCBaixa 	:= SuperGetMv("MV_BX10925",.T.,"2") == "1"  .and. (!Empty( SE5->( FieldPos( "E5_VRETPIS" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_VRETCOF" ) ) ) .And. ; 
				 		!Empty( SE5->( FieldPos( "E5_VRETCSL" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETPIS" ) ) ) .And. ;
				 		!Empty( SE5->( FieldPos( "E5_PRETCOF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETCSL" ) ) ) .And. ;
				 		!Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .And. !Empty( SFQ->( FieldPos( "FQ_SEQDES"  ) ) ) )

Local lCalcIssBx 	:= !Empty( SE5->( FieldPos( "E5_VRETISS" ) ) ) .and. !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .and. ;
							!Empty( SE2->( FieldPos( "E2_TRETISS" ) ) ) .and. GetNewPar("MV_MRETISS","1") == "2"  //Retencao do ISS pela emissao (1) ou baixa (2)

Local cFilterUser 	:= aReturn[7]
Local cFilADVPL   	:= ""
Local cFiltroSE2  	:= ""
Local lMultFil    	:= .F.	// Indica que existe mais de uma filial
Local lFilCRet    	:= ( Len( aCodRet ) > 0 )		// Indica se foram selecionados codigos de retencao para filtro
Local nTotFil     	:= 0
              
Local lTitPai     	:= SE2->( FieldPos( "E2_TITPAI" ) ) > 0
Local nX          	:= 0
Local nTotValImp  	:= 0
Local lImpFornec  	:= .T.	// Indica se imprimiu pelo menos um titulo para o fornecedor
Local cCodRet     	:= ""

Local lSE2Comp		:= Empty(xFilial("SE2"))

Local lContRetIRF	:= !Empty(SE2->(FieldPos("E2_VRETIRF"))) .AND. !Empty(SE2->(FieldPos("E2_PRETIRF")))

Local nTotREG		:= 0

Local lIRPFBaixa :=  	! Empty( SE2->( FieldPos( "E2_VRETIRF" ) ) ) .And. ;
						! Empty( SE2->( FieldPos( "E2_PRETIRF" ) ) ) .And. ;
						! Empty( SE5->( FieldPos( "E5_VRETIRF" ) ) ) .And. ;
						! Empty( SE5->( FieldPos( "E5_PRETIRF" ) ) ) 
Local lIRPFBxAux  := .F.


aCampos	:= {	{"CODIGO"	,"C",06,0 },;
				{"LOJA"	,"C",02,0 },;
				{"NOMEFOR"	,"C",40,0 },;
				{"CGC"		,"C",14,0 },;
				{"PREFIXO"	,"C",03,0 },;
				{"NUM"		,"C",aTamNum[1],0 },;
				{"PARCELA"	,"C",TamSx3("E2_PARCELA")[1],0 },;
				{"TIPO"		,"C",03,0 },;
				{"EMISSAO"	,"D",08,0 },;
				{"VENCTO"	,"D",08,0 },;
				{"VALBASE"  ,"N",17,2 },;
				{"VALINSS"	,"N",17,2 },;
				{"VALPIS"	,"N",17,2 },;
				{"VALCOF"	,"N",17,2 },;
				{"VALCSLL"	,"N",17,2 },;
				{"VALIRRF"	,"N",17,2 },;
				{"VALISS"	,"N",17,2 },;
				{"VALSEST"	,"N",17,2 },;
				{"VALLIQ"	,"N",17,2 },;
				{"VRETPIS"	,"N",17,2 },;
				{"VRETCOF"	,"N",17,2 },;
				{"VRETCSL"	,"N",17,2 },;
				{"PRETPIS"	,"C",01,0 },;
				{"PRETCOF"	,"C",01,0 },;
				{"PRETCSL"	,"C",01,0 },;
				{"PRETIRF"	,"C",01,0 },;
				{"TRETISS"	,"C",01,0 },;
				{"FATURA"	,"C",TamSx3("E2_FATURA")[1],0 },;
				{"PARCISS"  ,"C",TamSX3("E2_PARCPIS")[1],0 },;
				{"PARCINS"  ,"C",TamSX3("E2_PARCINS")[1],0 },;
				{"PARCIR"   ,"C",TamSX3("E2_PARCIR")[1],0 },;
				{"PARCPIS"  ,"C",TamSX3("E2_PARCPIS")[1],0 },;
				{"PARCCOF"  ,"C",TamSX3("E2_PARCCOF")[1],0 },;
				{"PARCSLL"  ,"C",TamSX3("E2_PARCSLL")[1],0 },;
				{"PARCSES"  ,"C",TamSX3("E2_PARCSES")[1],0 }}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Vari veis utilizadas para Impress„o do Cabe‡alho e Rodap‚ ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt 	:= ""
cbcont	:= 1
li 		:= 80
m_pag 	:= 1

// Verifica se existe mais de uma filial para a empresa posicionada
SM0->( dbSeek( cEmpAnt ) )
SM0->( DBEval( { || nTotFil++ },, { || SM0->M0_CODIGO == cEmpAnt } ) )

lMultFil := ( nTotFil > 1 )

// Monta string com codigos de retencao selecionadas no filtro
lFilCRet := ( Len( aCodRet ) > 0 )

If lFilCRet
	AEval( aCodRet, { |x| cCodRet += ( x + "/" ) } )
	cCodRet := Left( cCodRet, Len( cCodRet ) - 1 )
EndIf

// Cons. Filiais Abaixo ?
If lConsFil
	cFilDe  := mv_par12	// De Filial ?
	cFilAte := mv_par13	// Ate Filial ?
Else
	cFilDe  := cFilAnt
	cFilAte := cFilAnt
EndIf

dbSelectArea("SM0")
dbSeek( cEmpAnt + cFilDe, .T. )

nRegSM0 := SM0->(Recno())

Do While SM0->( !Eof() .And. M0_CODIGO == cEmpAnt .And. M0_CODFIL <= cFilAte )

	cFilAnt := SM0->M0_CODFIL

	// Inicializa totalizadores por filial se considera filiais e utiliza mais de uma filial
	If lConsFil .And. lMultFil
		nTitFil	  := 0
		nVlFilOri := 0
		nVlFilLiq := 0
		nVlFilIns := 0
		nVlFilPis := 0
		nVlFilCof := 0
		nVlFilCsl := 0
		nVlFilIrf := 0
		nVlFilIss := 0
		nVlFilSes := 0
	EndIf

	If nOrdem == 1  //Por Codigo
		SE2->( dbSetOrder(6) )
	Else            //Por Nome
		SE2->( dbSetOrder(2) )
	Endif

	cChaveSe2 := SE2->( IndexKey() )

	#IFDEF TOP
		If !Empty(cFilterUser)
			//Transforma a expressão do filtro de ADVPL para Query SQL
			cFilADVPL := PcoParseFil(cFilterUser,"SE2") 
	    EndIf
		If nOrdem == 1  //Por Codigo
			cOrder := "CODIGO,LOJA"
		Else            //Por Nome
			cOrder := "NOMEFOR"
		Endif
		
		cQuery := "SELECT A2_COD CODIGO,A2_LOJA LOJA,A2_NOME NOMEFOR,A2_CGC CGC,E2_PREFIXO PREFIXO,"
		cQuery += "E2_NUM NUM,E2_PARCELA PARCELA,E2_TIPO TIPO,E2_EMISSAO EMISSAO,E2_VENCREA VENCTO,"
		cQuery += "E2_IRRF VALIRRF,"                          
		cQuery += "E2_ISS VALISS,E2_INSS VALINSS,E2_FATURA FATURA,"
		cQuery += "E2_PIS VALPIS,E2_COFINS VALCOF,E2_CSLL VALCSLL,"	
		//Se controla Retencao
		If lContrRet
			cQuery += "E2_VRETPIS VRETPIS,E2_VRETCOF VRETCOF,E2_VRETCSL VRETCSL,"
			cQuery += "E2_PRETPIS PRETPIS,E2_PRETCOF PRETCOF,E2_PRETCSL PRETCSL,"
			If lSest  // So processa se existir o campo E2_SEST
				cQuery += "(E2_VALOR) VALBASE,"
				cQuery += "E2_SEST VALSEST,"
			Else
				cQuery += "(E2_VALOR) VALBASE,"
			Endif	
		Else
			If lSest  // So processa se existir o campo E2_SEST
				cQuery += "(E2_VALOR) VALBASE,"
				cQuery += "E2_SEST VALSEST,"
			Else
				cQuery += "(E2_VALOR) VALBASE,"
			Endif
		Endif					
	
		IF lCalcIssBx
			cQuery += "E2_TRETISS TRETISS,"
		Endif

		If lContRetIRF
			cQuery += "E2_VRETIRF VRETIRF, E2_PRETIRF PRETIRF, "
		Endif			

		cQuery += "E2_VALOR VALLIQ, E2_PARCISS PARCISS, E2_PARCINS PARCINS, E2_PARCIR PARCIR, "
		cQuery += "E2_PARCPIS PARCPIS, E2_PARCCOF PARCCOF, E2_PARCSLL PARCSLL, E2_PARCSES PARCSES "
		cQuery += "FROM "+RetSqlName("SE2")+" SE2,"
		cQuery +=         RetSqlName("SA2")+" SA2 "
		cQuery += " WHERE SA2.A2_FILIAL = '" + xFilial("SA2") + "'"
		cQuery += " AND SA2.A2_COD = SE2.E2_FORNECE "
		cQuery += " AND SA2.A2_LOJA = SE2.E2_LOJA "
		If !Empty( cTipoForn )
			cQuery += " AND SA2.A2_TIPO = '" + cTipoForn + "' "
		EndIf	
		cQuery += " AND SA2.D_E_L_E_T_ = ' ' "
		cQuery += " AND SE2.E2_FILIAL = '" + xFilial("SE2") + "'"
		cQuery += " AND SE2.E2_FORNECE  between '" + mv_par01 + "' AND '" + mv_par02 + "'"
		cQuery += " AND SE2.E2_LOJA     between '" + mv_par03 + "' AND '" + mv_par04 + "'"
		cQuery += " AND (SE2.E2_INSS > 0 "
		cQuery += " OR SE2.E2_ISS > 0 "
		cQuery += " OR SE2.E2_PIS > 0 "
		cQuery += " OR SE2.E2_COFINS > 0 "
		cQuery += " OR SE2.E2_CSLL > 0 "
		If lSest
			cQuery += " OR SE2.E2_SEST > 0 "
		EndIf  

		If lContRetIRRF
			cQuery += " OR (SE2.E2_IRRF > 0 OR (SE2.E2_VRETIRF > 0 AND SE2.E2_PRETIRF <> '1'))) "
		Else
			cQuery += " OR SE2.E2_IRRF > 0 ) "
		Endif
		cQuery += " AND SE2.E2_VENCREA  between '" + DTOS(mv_par07)  + "' AND '" + DTOS(mv_par08) + "'"
		cQuery += " AND SE2.E2_EMISSAO  between '" + DTOS(mv_par05)  + "' AND '" + DTOS(mv_par06) + "'"
		cQuery += " AND SE2.E2_EMISSAO  <= '"      + DTOS(dDataBase) + "'"
		// Se considera filiais e SE2 estah compartilhado, realiza filtro por filial origem
		If lConsFil .And. lSE2Comp
			cQuery += " AND SE2.E2_FILORIG = '" + cFilAnt + "' "
		EndIf
		If !Empty(cFilADVPL)
			cQuery += " AND (" + cFilADVPL + ")"
		Else
			//Coloco o filtro de usuário em outra variável, pois quando seleciona a tabela TRB
			//a variável cFilterUser é zerada.
			cFiltroSE2 := cFilterUser
		EndIf
		
		cQuery += " AND SE2.D_E_L_E_T_ = ' ' "
		cQuery += " ORDER BY "+ cOrder
		cQuery := ChangeQuery(cQuery)
	
		dbSelectArea("SE2")
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TRB", .F., .T.)
	#ELSE
		cFiltroSE2 := cFilterUser
		cIndexSe2 := CriaTrab(Nil,.F.)
		IndRegua("SE2",cIndexSe2,cChaveSe2,,FR865IndR(cFiltroSE2,cTipoForn,lSest,lConsFil,lSE2Comp,lContRetIRRF),STR0011)
		nIndexSE2 := RetIndex("SE2")
		SE2->(dbSetIndex(cIndexSe2+OrdBagExt()))
		SE2->(dbSetOrder(nIndexSE2+1))
		SE2->(dbSeek(xFilial("SE2")))
	
		cArqTrab := CriaTrab( aCampos )
		dbUseArea( .T.,, cArqTrab, "TRB", if(.F. .OR. .F., !.F., NIL), .F. )
		If nOrdem == 1  //Por Codigo
			IndRegua("TRB",cArqTrab,"CODIGO+LOJA",,,)
		Else            //Por Nome
			IndRegua("TRB",cArqTrab,"NOMEFOR",,,)
		Endif
		TRB->(dbSetIndex( cArqTrab +OrdBagExt()))
	
		dbSelectArea("SE2")
	
		While !SE2->(Eof())
		
			dbSelectArea("SA2")			
			SA2->(dbSetOrder(1))
			
			If SA2->(dbSeek(xFilial("SA2") + SE2->(E2_FORNECE+E2_LOJA)))

				  If	lContrRet
					nValBase := SE2->(E2_VALOR+E2_IRRF+E2_INSS+E2_ISS)
					nValLiq := SE2->E2_VALOR
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³No que esta consolidado nao se pode determinar qual o    ³
					//³tipo de retencao de PCC estava em uso e nao se pode usar ³
					//³o parametro MV_BX10925 como referencia, entao utilizar   ³
					//³apenas os campos PRET para determinar se o PCC deve      ³
					//³ou nao ser agregado ao valor original do titulo.         ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If (Empty(SE2->E2_PRETPIS) .OR. Empty(SE2->E2_PRETCOF) .OR. Empty(SE2->E2_PRETCSL)) .AND. SE2->(E2_PIS+E2_COFINS+E2_CSLL) > 0
						//PCC retido na emissao nele mesmo, somar para compor o valor original.
						nValBase += SE2->(E2_PIS+E2_COFINS+E2_CSLL)
					Else
						//PCC retido na baixa ou na emissao nao nele mesmo, ou seja, o E2_VALOR nao sofreu abatimento, entao abater o PCC para obter o liquido
						nValLiq -= SE2->(E2_PIS+E2_COFINS+E2_CSLL)
					Endif
				Else   
					nValBase := SE2->(E2_VALOR+E2_IRRF+E2_INSS+E2_ISS+E2_PIS+E2_COFINS+E2_CSLL)
					nValLiq := SE2->E2_VALOR
				Endif
				If lSest
					nValBase += SE2->E2_SEST
				Endif
				
				dbSelectArea("TRB")
				RecLock("TRB",.T.)	
				TRB->CODIGO		:= SA2->A2_COD
				TRB->LOJA		:= SA2->A2_LOJA
				TRB->NOMEFOR	:= SA2->A2_NOME 
				TRB->CGC		:= SA2->A2_CGC
				TRB->PREFIXO	:= SE2->E2_PREFIXO
				TRB->NUM		:= SE2->E2_NUM
				TRB->PARCELA	:= SE2->E2_PARCELA
				TRB->TIPO		:= SE2->E2_TIPO
				TRB->EMISSAO	:= SE2->E2_EMISSAO
				TRB->VENCTO		:= SE2->E2_VENCREA
				TRB->VALBASE	:= nValBase
				TRB->VALINSS	:= SE2->E2_INSS
				TRB->VALPIS		:= SE2->E2_PIS
				TRB->VALCOF		:= SE2->E2_COFINS
				TRB->VALCSLL	:= SE2->E2_CSLL 
				TRB->VALIRRF	:= SE2->E2_IRRF
				TRB->VALISS		:= SE2->E2_ISS       
				TRB->FATURA		:= SE2->E2_FATURA
				TRB->TRETISS    := SE2->E2_TRETISS
				TRB->PARCISS	:= SE2->E2_PARCISS
				TRB->PARCINS	:= SE2->E2_PARCINS
				TRB->PARCIR		:= SE2->E2_PARCIR
				TRB->PARCPIS	:= SE2->E2_PARCPIS
				TRB->PARCCOF	:= SE2->E2_PARCCOF
				TRB->PARCSLL	:= SE2->E2_PARCSLL
				TRB->PARCSES	:= SE2->E2_PARCSES
				
				If lSest  // So processa se existir o campo E2_SEST
					TRB->VALSEST   := SE2->E2_SEST  
				Endif
				TRB->VALLIQ		:= nValLiq
	
				//Se controla retencao
				If lContrRet
					TRB->VRETPIS	:= SE2->E2_VRETPIS
					TRB->VRETCOF	:= SE2->E2_VRETCOF
					TRB->VRETCSL	:= SE2->E2_VRETCSL 
					TRB->PRETPIS	:= SE2->E2_PRETPIS
					TRB->PRETCOF	:= SE2->E2_PRETCOF
					TRB->PRETCSL	:= SE2->E2_PRETCSL 
				Endif			
				
				MSUnlock()
			Endif
			SE2->(dbSkip())
		EndDo
	#ENDIF
	TRB->(dbGoTop())
	TRB->(dbEval({|| nTotREG++}))
	TRB->(dbGoTop())
	SetRegua(nTotREG)

	While !TRB->(Eof())
		IF lEnd
			@PROW()+1,001 PSAY OemToAnsi(STR0012) //"CANCELADO PELO OPERADOR"
			lContinua := .F.
			Exit
		EndIF     

		If li > 58
			FR865Cabec(GetMv("MV_COMP"),nRegSM0,lFilCRet,cCodRet)
		EndIf
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Caso a funçao PcoParseFil() retorne vazio, posiciono na      ³
		//³ tabela SE2 para fazer o filtro do usuário.				     ³		
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ    
		If Empty(cFilADVPL)	.And. !Empty(cFiltroSE2)
	    	dbSelectArea("SE2")
	    	SE2->(dbSetOrder(1))
	    	SE2->(MsSeek(xFilial("SE2")+TRB->PREFIXO+TRB->NUM+TRB->PARCELA+TRB->TIPO+TRB->CODIGO+TRB->LOJA))
			If !SE2->(&cFiltroSE2)
				TRB->(dbSkip())
				Loop
			Endif
		EndIF
		
		nTitCli		:= 0
		nVlCliOri	:= 0
		nVlCliIns	:= 0
		nVlCliLiq	:= 0
		nVlCliPis	:= 0
		nVlCliCof	:= 0
		nVlCliCsl	:= 0
		nVlCliSes	:= 0
		nVlCliIrf	:= 0
		nVlCliIss	:= 0
		nValBase	:= 0
	
		cCodFor		:= TRB->CODIGO
		cLojFor		:= TRB->LOJA
		cNomFor		:= TRB->NOMEFOR
		cCGCAnt		:= TRB->CGC    
		lImpFornec  := .T.
		
		Do While !TRB->(Eof()) .And. cCodFor + cLojFor == TRB->(CODIGO+LOJA) .AND. cNomFor == TRB->NOMEFOR
			IncRegua()
			
			IF li > 58
				FR865Cabec(GetMv("MV_COMP"),nRegSM0,lFilCRet,cCodRet)
			EndIF 

			If SA2->(! dbSeek(xFilial("SA2")+TRB->CODIGO+TRB->LOJA) )
				TRB->( dbSkip() )
				Loop
			EndIf

			lIRPFBAux  := lIRPFBaixa
			If SA2->( FieldPos( "A2_CALCIRF" ) ) > 0
				lIRPFBxAux := lIRPFBAux .And. ( SA2->A2_CALCIRF == "2" )
			Else
				lIRPFBxAux := .F.
			EndIf

			// Inicializa vetor com o valor dos impostos do titulo
			aValImp := {;
						TRB->VALSEST,;		// Valor SEST
						TRB->VALIRRF,;		// Valor IRRF 	
						TRB->VALISS ,;		// Valor ISS
						TRB->VALINSS,;		// Valor INSS
						TRB->VALPIS	,;		// Valor PIS
						TRB->VALCOF	,;		// Valor COFINS
						TRB->VALCSLL }		// Valor CSLL
			           
			// Se utiliza filtro por codigo de retencao, altera os valores do vetor 
			// de acordo com os codigos de retencao selecionados para filtro
			If lFilCRet

				nTotValImp := 0
				FR865FilCRet( @aValImp, aCodRet, lTitPai )
				AEval( aValImp, { |x| nTotValImp += x } )

				// Se todos os impostos estao com valor zero, vai para o proximo titulo
				If nTotValImp == 0
					TRB->( dbSkip() )
					Loop     
				EndIf

			EndIf

			lFatura := .F.
	
		 	If !Empty(TRB->FATURA) .And. TRB->FATURA == 'NOTFAT'
				lFatura := .T.
			EndIf 
                    
			If lImpFornec
				@li,  0 PSAY TRB->CODIGO+"-"+TRB->LOJA
				@li, 15 PSAY Substr(TRB->NOMEFOR,1,30)
				@li, 46 PSAY TRB->CGC Picture IIF(Len(Alltrim(TRB->CGC)) == 11 , "@R 999.999.999-99","@R 99.999.999/9999-99")
				li+=2
				lImpFornec := .F.
			EndIf	
	
			@li, 05 PSAY TRB->PREFIXO
			@li, 09 PSAY TRB->NUM
			
			@LI, 021 PSAY TRB->PARCELA
			@li, 025 PSAY TRB->TIPO
	                                                              
			@li, 031 PSAY STOD(TRB->EMISSAO)
			@li, 042 PSAY STOD(TRB->VENCTO)
			#IFDEF TOP
				If	lContrRet

					nValBase	:= TRB->(VALBASE+If(!lIRPFBxAux,VALIRRF,0)+VALINSS+VALISS)
					nValLiq := TRB->VALLIQ
					If !lPccBaixa
						If (Empty( TRB->PRETPIS) .OR. Empty( TRB->PRETCOF) .OR. Empty( TRB->PRETCSL)) .AND.  TRB->(VALPIS+VALCOF+VALCSLL)  > 0
						//PCC retido na emissao nele mesmo, somar para compor o valor original.
					   		nValBase += TRB->(VALPIS+VALCOF+VALCSLL) 
				  		Elseif ( ( TRB->PRETPIS == '2')   .OR.  ( TRB->PRETCOF == '2') .OR. ( TRB->PRETCSL == '2')) .AND. TRB->( VALPIS + VALCOF + VALCSLL ) > 0
						//PCC retido na baixa ou na emissao nao nele mesmo, ou seja, o E2_VALOR nao sofreu abatimento, entao abater o PCC para obter o liquido
							nValLiq -= TRB->(VALPIS+VALCOF+VALCSLL) 
						Endif
					EndIf
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³No que esta consolidado nao se pode determinar qual o    ³
					//³tipo de retencao de PCC estava em uso e nao se pode usar ³
					//³o parametro MV_BX10925 como referencia, entao utilizar   ³
					//³apenas os campos PRET para determinar se o PCC deve      ³
					//³ou nao ser agregado ao valor original do titulo.         ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If	( ( TRB->PRETPIS <> '2' .And. TRB->PRETPIS <> '3' )   .OR.  ;
						  ( TRB->PRETCOF <> '2' .And. TRB->PRETCOF <> '3' )   .OR.  ;
						  ( TRB->PRETCSL <> '2' .And. TRB->PRETCSL <> '3' ) ) .AND. ;
						  TRB->( VALPIS + VALCOF + VALCSLL ) > 0

						//PCC retido na emissao nele mesmo, somar para compor o valor original.
					
							
					    If	( ( TRB->PRETPIS <> '2' .And. TRB->PRETPIS <> '3' )   .OR.  ;
						  	  ( TRB->PRETCOF <> '2' .And. TRB->PRETCOF <> '3' )   .OR.  ;
						  	  ( TRB->PRETCSL <> '2' .And. TRB->PRETCSL <> '3' ) ) .AND. ;
							  TRB->( VALPIS + VALCOF + VALCSLL ) > 0

					    	nDescont:= TRB->(VRETPIS+VRETCOF+VRETCSL) - TRB->(VALPIS+VALCOF+VALCSLL) 
							nValLiq += nDescont
							If !lIRPFBxAux							
								nValBase+= nDescont
							EndIf
						EndIf			   	  		

					ElseIF lPccBaixa .and. (( TRB->PRETPIS <> '2') .OR. ( TRB->PRETCOF <> '2') .OR. ( TRB->PRETCSL <> '2' ))

						//PCC retido na baixa ou na emissao nao nele mesmo, ou seja, o E2_VALOR nao sofreu abatimento, entao abater o PCC para obter o liquido
						nValLiq -= TRB->(VALPIS+VALCOF+VALCSLL)

					Endif

				Else

					nValBase := TRB->VALBASE
					nValLiq := TRB->VALLIQ

				Endif

				//Caso o calculo do ISS seja efetuado na baixa do titulo, nao somo o imposto para compor o valor base
				If lCalcIssBx .and. TRB->TRETISS == "2"
					nValBase -= TRB->VALISS
					nValLiq	 -= TRB->VALISS					
				Endif
				
				If lIRPFBxAux .and. TRB->PRETIRF $ "1/7/ /4"
//					nValBase -= TRB->VALIRRF
					nValLiq	 -= TRB->VALIRRF
				Endif
				@li, 053 PSAY nValBase Picture tm (TRB->VALBASE ,15)
			#ELSE        
				nValBase := TRB->VALBASE
				nValLiq := TRB->VALLIQ			                                                          
				//Caso o calculo do ISS seja efetuado na baixa do titulo, nao somo o imposto para compor o
				//valor base
				If lCalcIssBx .AND. TRB->TRETISS == "2"
					nValBase -= TRB->VALISS
					nValLiq	 -= TRB->VALISS					
				Endif
				
				If lIRPFBxAux .and. TRB->PRETIRF $ "1/7/ /4"
//					nValBase -= TRB->VALIRRF
					nValLiq	 -= TRB->VALIRRF
				Endif
				
				@li, 053 PSAY nValBase Picture tm (TRB->VALBASE ,15)			
			#ENDIF              
			
			If lSest  // So processa se existir o campo E2_SEST
				@li, 069 PSAY aValImp[N_VALSEST]	Picture tm (TRB->VALSEST ,15)
			EndIf
			@li, 085 PSAY aValImp[N_VALIRRF]		Picture tm (TRB->VALIRRF ,15)
			@li, 101 PSAY aValImp[N_VALISS]		Picture tm (TRB->VALISS  ,15)
			@li, 117 PSAY aValImp[N_VALINSS]  		Picture tm (TRB->VALINSS ,15)
			@li, 133 PSAY aValImp[N_VALPIS]		Picture tm (TRB->VALPIS  ,15)
			@li, 149 PSAY aValImp[N_VALCOF]		Picture tm (TRB->VALCOF  ,15)
			@li, 165 PSAY aValImp[N_VALCSLL]		Picture tm (TRB->VALCSLL ,15)
			@li, 181 PSAY nValLiq		   			Picture tm (TRB->VALLIQ  ,15)		
	
			If lContrRet // Verifica se o sistema esta fazendo controle de retencao de impostos
				If lPccBaixa	// Geracao dos impostos lei 10925 pela baixa
					If TRB->(VALPIS+VALCOF+VALCSLL) > 0  
						If TRB->TIPO $ MVPAGANT 
							If TRB->PRETPIS == "1" .or. TRB->PRETCOF == "1" .or. TRB->PRETCSL == "1"
								If TRB->(VRETPIS+VRETCOF+VRETCSL) == 0			                      
									@li, 197 PSAY "A"
								Endif
							Endif			                                               					
						Else
							If TRB->PRETPIS == "3" .or. TRB->PRETCOF == "3" .or. TRB->PRETCSL == "3"
								If TRB->(VRETPIS+VRETCOF+VRETCSL) == 0
									@li, 197 PSAY "A"			                                               
								Endif
							ElseIf TRB->PRETPIS == "1" .or. TRB->PRETCOF == "1" .or. TRB->PRETCSL == "1"
								@li, 197 PSAY "B"			
							Endif
						Endif
					Endif			
				Else
					If TRB->PRETPIS == "2" .or. TRB->PRETCOF == "2" .or. TRB->PRETCSL == "2"
						@li, 197 PSAY "A"
					ElseIf TRB->PRETPIS == "1" .or. TRB->PRETCOF == "1" .or. TRB->PRETCSL == "1"
						@li, 197 PSAY "B"			
					Endif
				Endif
			Endif
			
		 	If lFatura
			 	@li, 198 PSAY "/C"
			EndIf
	
			li++
			nTitCli++
			If !lFatura
				nVlCliOri += nValBase
			EndIf
	
			nVlCliLiq += nValLiq
			nVlCliIns += aValImp[N_VALINSS]
			nVlCliIrf += aValImp[N_VALIRRF]
			nVlCliIss += aValImp[N_VALISS]
			
			If TRB->PRETPIS <> "1" .Or. TRB->PRETCOF <> "1" .Or. TRB->PRETCSL <> "1"
				nVlCliPis += aValImp[N_VALPIS]
				nVlCliCof += aValImp[N_VALCOF]
				nVlCliCsl += aValImp[N_VALCSLL]
			EndIf	
			If lSest   // So processa se existir o campo E2_SEST
				nVlCliSes += aValImp[N_VALSEST]
			Endif
			TRB->(dbSkip())
		EndDo

		IF nVlCliOri > 0 
			li++
			SubTot865(nTitCli,nVlCliOri,nVlCliIns,nVlCliLiq,cNomFor,cCgcAnt,nVlCliPis,nVlCliCof,nVlCliCsl,nVlCliSes,nVlCliIrf,nVlCliIss)
			li++
		Endif
	
		nTitRel	  += nTitCli
		nVlTotOri += nVlCliOri
		nVlTotLiq += nVlCliLiq
		nVlTotIns += nVlCliIns       
		nVlTotPis += nVlCliPis
		nVlTotCof += nVlCliCof
		nVlTotCsl += nVlCliCsl
		nVlTotIrf += nVlCliIrf
		nVlTotIss += nVlCliIss
		If lSest  // So processa se existir o campo E2_SEST
			nVlTotSes += nVlCliSes                  
		Endif

		If lConsFil .And. lMultFil
			nTitFil	  += nTitCli
	        nVlFilOri += nVlCliOri
			nVlFilLiq += nVlCliLiq
			nVlFilIns += nVlCliIns
			nVlFilPis += nVlCliPis
			nVlFilCof += nVlCliCof
			nVlFilCsl += nVlCliCsl
			nVlFilIrf += nVlCliIrf
			nVlFilIss += nVlCliIss
			If lSest
				nVlFilSes += nVlCliSes
			EndIf
		EndIf
				
	Enddo
                 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprimir TOTAL por filial somente quando houver mais do que 1 filial ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nTitFil > 0	.And. lConsFil .And. lMultFil 
		TRB->( dbGoTop() )
		If TRB->( ! EoF() ) 
			li--
			If li > 58
				FR865Cabec(GetMv("MV_COMP"),nRegSM0,lFilCRet,cCodRet)
			EndIf
			@li,000 PSAY	STR0042 + " ---> " + cFilAnt + " - " + AllTrim(SM0->M0_FILIAL) +;			 		// Total Filial ->
							" (" + AllTrim( Str(nTitFil) ) + " " + Iif( nTitFil > 1, STR0014, STR0015 ) + ")" 	// TITULOS ### TITULO
			@li,053 PSAY nVlFilOri Picture TM( nVlFilOri, 15 )
			If lSest  // So processa se existir o campo E2_SEST
				@li,069 PSAY nVlFilSes Picture TM( nVlFilSes, 15 )
			EndIf
			@li,085 PSAY nVlFilIrf Picture TM( nVlFilIrf, 15 )
			@li,101 PSAY nVlFilIss Picture TM( nVlFilIss, 15 )
			@li,117 PSAY nVlFilIns Picture TM( nVlFilIns, 15 )
			@li,133 PSAY nVlFilPis Picture TM( nVlFilPis, 15 )
			@li,149 PSAY nVlFilCof Picture TM( nVlFilCof, 15 )
			@li,165 PSAY nVlFilCsl Picture TM( nVlFilCsl, 15 )
			@li,181 PSAY nVlFilLiq Picture TM( nVlFilLiq, 15 )
			li++
			@li,000 PSAY Replicate("-",220)                            
			li+=2
		EndIf	
	EndIf
	
	#IFNDEF TOP
		dbSelectArea("SE2")
		dbClearFil()
		RetIndex( "SE2" )
		If !Empty(cIndexSE2)
			FErase (cIndexSE2+OrdBagExt())
		Endif
		dbSetOrder(1)
		TRB->(dbCloseArea())
		fErase( cArqTrab + GetDBExtension() )
		fErase( cArqTrab + OrdBagExt() )
	#ELSE
		dbSelectArea("SE2")
		dbCloseArea()
		ChKFile("SE2")
		dbSelectArea("SE2")
		dbSetOrder(1)
		TRB->(dbCloseArea())
	#ENDIF
	
	dbSelectArea("SM0")
	dbSkip()

EndDo

SM0->( dbGoTo( nRegSM0 ) )
cFilAnt := SM0->M0_CODFIL

IF li != 80
	IF li > 58
		FR865Cabec(GetMv("MV_COMP"),nRegSM0,lFilCRet,cCodRet)
	EndIF
	TotGeR865(nVlTotOri,nVlTotIns,nVlTotPis,nVlTotCof,nVlTotCsl,nVlTotLiq,nTitRel,nVlTotIrf,nVlTotIss,nVlTotSes)

	If lContrRet
		IF li > 58
			FR865Cabec(GetMv("MV_COMP"),nRegSM0,lFilCRet,cCodRet)
		EndIF
		@li, 001 PSAY STR0017 // A = Os valores de Pis,Cofins e Csll deste titulo foram retidos em outro titulo.
		@li++            
		@li, 001 PSAY STR0018+STR0041 // B = Os valores de Pis,Cofins e Csll deste titulo se referem a uma previsao, ainda nao foram retidos.
		@li++
		@li, 001 PSAY STR0019  // C = Os registros referentes a fatura não são incluidos nos totalizadores.
	Endif

	Roda(cbcont,cbtxt,"G")
EndIF

Set Device To Screen

If aReturn[5] = 1
	Set Printer TO
	dbCommitAll()
	Ourspool(wnrel)
Endif
MS_FLUSH()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³SubTot865 ³ Autor ³ Nilton Pereira        ³ Data ³ 24.03.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Imprimir SubTotal do Relatorio							           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ SubTot865()												              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³															                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico													              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function SubTot865(nTitCli,nVlCliOri,nVlCliIns,nVlCliLiq,cNomFor,cCgcAnt,nVlCliPis,nVlCliCof,nVlCliCsl,nVlCliSes,nVlCliIrf,nVlCliIss)

@li,000 PSAY Replicate("-",220)                              
li+=1     
@li,000 PSAY STR0013 + Substr(cNomFor,1,09) //"Total Fornecedor  - "

@li,030 PSAY " ("+ALLTRIM(STR(nTitCli))+" "+IiF(nTitCli > 1,STR0014,STR0015)+")" //"TITULOS"###"TITULO"

@li,053 PSAY nVlCliOri		Picture TM(nVlCliOri,15)
If lSest  // So processa se existir o campo E2_SEST
	@li,069 PSAY nVlCliSes		Picture TM(nVlCliSes,15)
Endif
@li,085 PSAY nVlCliIrf		Picture TM(nVlCliIrf,15)
@li,101 PSAY nVlCliIss		Picture TM(nVlCliIss,15)
@li,117 PSAY nVlCliIns		Picture TM(nVlCliIns,15)
@li,133 PSAY nVlCliPis		Picture TM(nVlCliLiq,15)
@li,149 PSAY nVlCliCof		Picture TM(nVlCliLiq,15)
@li,165 PSAY nVlCliCsl		Picture TM(nVlCliLiq,15)
@li,181 PSAY nVlCliLiq		Picture TM(nVlCliLiq,15)

li++
@li,000 PSAY Replicate("-",220)                            
li++
Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ TotGeR865³ Autor ³ Nilton Pereira		³ Data ³ 24.03.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprimir total do relatorio								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ TotGeR865()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function TotGeR865(nVlTotOri,nVlTotIns,nVlTotPis,nVlTotCof,nVlTotCsl,nVlTotLiq,nTitRel,nVlTotIrf,nVlTotIss,nVlTotSes)

@li,000 PSAY Replicate("_",220)
li+= 2
@li,000 PSAY STR0016  //"TOTAL GERAL      ----> "
@li,030 PSAY "("+ALLTRIM(STR(nTitRel))+" "+IIF(nTitRel > 1,STR0014,STR0015)+")"	 //"TITULOS"###"TITULO"
@li,053 PSAY nVlTotOri	   Picture TM(nVlTotOri,15)
If lSest  // So processa se existir o campo E2_SEST
	@li,069 PSAY nVlTotSes		Picture TM(nVlTotSes,15)
Endif
@li,085 PSAY nVlTotIrf		Picture TM(nVlTotIrf,15)
@li,101 PSAY nVlTotIss		Picture TM(nVlTotIss,15)
@li,117 PSAY nVlTotIns	   Picture TM(nVlTotIns,15)
@li,133 PSAY nVlTotPis		Picture TM(nVlTotPis,15)
@li,149 PSAY nVlTotCof		Picture TM(nVlTotCof,15)
@li,165 PSAY nVlTotCsl		Picture TM(nVlTotCsl,15)
@li,181 PSAY nVlTotLiq	   Picture TM(nVlTotLiq,15)
li++
@li,000 PSAY Replicate("_",220)
li++
Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³FR865IndR ³ Autor ³ Nilton Pereira		³ Data ³ 24.03.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Monta Indregua para impressao do relat¢rio				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±                 
±±³ Uso		 ³ Generico													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±                           
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                                              
#IFNDEF TOP
	Static Function FR865IndR(cFilterSE2,cTipoForn,lSest,lConsFil,lSE2Comp,lContRetIRRF)
	Local cFiltro
		
	Default lSest := .F.
	
	cFiltro := 'E2_FILIAL=="'+xFilial("SE2")+'".And.'
	If !Empty(cTipoForn)
		cFiltro += 'E2_TIPO=="'+cTipoForn+'".And.'
	EndIf
	cFiltro += 'E2_FORNECE>="'+mv_par01+'".and.E2_FORNECE<="'+mv_par02+'".And.'
	cFiltro += 'E2_LOJA>="'+mv_par03+'".And.E2_LOJA<="'+mv_par04+'".And.'
	cFiltro += '(E2_ISS>0.OR.E2_INSS>0.OR.E2_PIS>0.OR.E2_COFINS>0.OR.E2_CSLL>0.OR.'
	If lSest
		cFiltro += 'E2_SEST>0.OR.'
	EndIf

	If lContRetIRRF
		cFiltro += '(E2_IRRF > 0 .OR. (E2_VRETIRF > 0 .AND. E2_PRETIRF <> "' + "1" + '"))) .AND. '
	Else
		cFiltro += 'E2_IRRF > 0) .AND.'
	Endif
	// Se considera filiais e SE2 estah compartilhado, realiza filtro por filial origem
	If lConsFil .And. lSE2Comp
		cFiltro += 'E2_FILORIG == "' + cFilAnt + '".And. '
	EndIf
	cFiltro += 'DTOS(E2_VENCREA) >="'+DTOS(mv_par07)+'".And.DTOS(E2_VENCREA)<="'+DTOS(mv_par08)+'".And.'
	cFiltro += 'DTOS(E2_EMISSAO)>="'+DTOS(mv_par05)+'".And.DTOS(E2_EMISSAO)<="'+DTOS(mv_par06)+'".And.'
	cFiltro += 'DTOS(E2_EMISSAO)<="'+DTOS(dDataBase)+'"'
	If !Empty(cFilterSE2)
		cFiltro += ' .And. ' + cFilterSE2
	EndIf
	
	Return cFiltro
#ENDIF


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AjustaSX1 º Autor ³ Gustavo Henrique  º Data ³ 29/06/2009  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ajusta perguntas da tabela SX1                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINR865                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1(cPerg)
                     
Local aArea		:= GetArea()
Local aTamSX3	:= {}
Local aHelpPor	:= {}
Local aHelpSpa	:= {}
Local aHelpEng	:= {}

DbSelectArea( "SX1" )
SX1->( dbSetOrder( 1 ) )

// Filtra Codigos de Retencao? (mv_par09)
If !SX1->( MsSeek( cPerg + "09" ) )
      
	aHelpPor := {}
	aHelpSpa := {}
	aHelpEng := {}

    Aadd( aHelpPor, "Selecione a opção 'Sim' para que a"   )	
    Aadd( aHelpPor, "geração do relatorio considere os"    )
    Aadd( aHelpPor, "códigos de reteção a serem "          )
    Aadd( aHelpPor, "informados, ou 'Nao', caso contrário.")

    Aadd( aHelpSpa, "Elija la opcion 'Si' para que la "    )
    Aadd( aHelpSpa, "generacion del informe considere los" )
    Aadd( aHelpSpa, "códigos de retencion que se deben"    )
    Aadd( aHelpSpa, "informar, o en caso contrario, "      )
    Aadd( aHelpSpa, "elija 'No'."                          )

    Aadd( aHelpEng, "Select the option 'Yes' for the "     )
    Aadd( aHelpEng, "generation of the report considers "  )
    Aadd( aHelpEng, "the Withholding Codes that are "      )
    Aadd( aHelpEng, "going to be informed, otherwise, "    )
    Aadd( aHelpEng, "select 'No'."                         )

	PutSx1(	cPerg,	"09", "Filtra Cod. de Retencao ?", "¿Filtra Cod. de Retencion?", "Filter Withholding Code?", "mv_ch9", "N", 1, 0, 2, "C", "", "", "", "",;
					"mv_par09", "Sim", "Si", "Yes", "", "Nao", "No", "No", "", "", "", "", "", "", "", "", "", , , , "." + RTrim(cPerg) + "09." )

	PutSX1Help( "P." + RTrim(cPerg) + "09.", aHelpPor, aHelpEng, aHelpSpa )
		
EndIf

// Tipo Fornecedor? (mv_par10)
If !SX1->( MsSeek( cPerg + "10" ) )
      
	aHelpPor := {}
	aHelpSpa := {}
	aHelpEng := {}

    Aadd( aHelpPor, "Selecionar o tipo do fornecedor que" )	
    Aadd( aHelpPor, "será impresso no relatório." )

    Aadd( aHelpSpa, "Elija lo tipo del proveedor que " )
    Aadd( aHelpSpa, "debe ser impreso en informe." )

    Aadd( aHelpEng, "Select the type of supplier to" )
    Aadd( aHelpEng, "be considered in the print." )

	PutSx1(	cPerg,	"10", "Tipo Fornecedor ?", "¿Tipo Proveedor?", "Supplier type ?", "mv_cha", "N", 1, 0, 3, "C", "", "", "", "",;
					"mv_par10", "Pessoa Fisica", "Persona Fisica", "Natual Person", "", "Pessoa Juridica", "Persona Juridica",;
					"Company Entity", "Ambas", "Ambas", "Both", "", "", "", "", "", "", , , , "." + RTrim(cPerg) + "10." )

	PutSX1Help( "P." + RTrim(cPerg) + "10.", aHelpPor, aHelpEng, aHelpSpa )
		
EndIf
             
// Considera Filiais Abaixo? (mv_par11)
If !SX1->( MsSeek( cPerg + "11" ) )
      
	aHelpPor := {}
	aHelpSpa := {}
	aHelpEng := {}

    Aadd( aHelpPor, "Selecione a opcao 'Sim' para que a"   )	
    Aadd( aHelpPor, "geracao do relatorio considere as"    )
    Aadd( aHelpPor, "filiais a serem informadas nos"       )
    Aadd( aHelpPor, "parâmetros seguintes, ou 'Nao',"      )
    Aadd( aHelpPor, "caso contrário."                      )

    Aadd( aHelpSpa, "Elija la opcion 'Si' para que la "    )
    Aadd( aHelpSpa, "generacion del informe considere las" )
    Aadd( aHelpSpa, "sucursales que se deben informar en"  )
    Aadd( aHelpSpa, "los siguientes parametros, o en caso" )
    Aadd( aHelpSpa, "contrario, elija 'No'."               )

    Aadd( aHelpEng, "Select the option 'Yes' so that the " )
    Aadd( aHelpEng, "report generation can consider the"   )
    Aadd( aHelpEng, "branches to be entered in the"        )
    Aadd( aHelpEng, "following parameters."                )

	PutSx1(	cPerg,	"11", "Cons.Filiais abaixo ?", "¿Considera Siguientes Suc ?", "Cons.Branches below ?", "mv_chb", "N", 1, 0, 2, "C", "", "", "", "",;
					"mv_par11", "Sim", "Si", "Yes", "", "Nao", "No", "No", "", "", "", "", "", "", "", "", "", , , , "." + RTrim(cPerg) + "11." )

	PutSX1Help( "P." + RTrim(cPerg) + "11.", aHelpPor, aHelpEng, aHelpSpa )
		
EndIf

// De Filial ? (mv_par12)
If !SX1->( MsSeek( cPerg + "12" ) )

	aTamSX3	:= TamSX3( "E2_FILIAL" )
                  
	aHelpPor := {}
	aHelpSpa := {}
	aHelpEng := {}

    Aadd( aHelpPor, "Informe o codigo inicial do intervalo"  ) 
    Aadd( aHelpPor, "de filiais da sua empresa a serem"      )
    Aadd( aHelpPor, "considerados na impressao."             )

    Aadd( aHelpSpa, "Digite el codigo inicial del intervalo" )
    Aadd( aHelpSpa, "de sucursales de su empresa que se"     )
    Aadd( aHelpSpa, "deben considerar en la impresion."      )

    Aadd( aHelpEng, "Enter the initial code of your "        )
    Aadd( aHelpEng, "company's branches interval to "        )
    Aadd( aHelpEng, "be considered in the print."            )


	PutSx1(	cPerg,	"12", "De Filial ?", "¿De Sucursal ?", "From Branch ?", "mv_chc", aTamSX3[3], aTamSx3[1], aTamSX3[2], 2, "G", "", "", "", "",;
					"mv_par12", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", , , , "." + RTrim(cPerg) + "12." )

	PutSX1Help( "P." + RTrim(cPerg) + "12.", aHelpPor, aHelpEng, aHelpSpa )
				
EndIf				
             
// Ate Filial ? (mv_par12)
If !SX1->( MsSeek( cPerg + "13" ) )

	aTamSX3	:= TamSX3( "E2_FILIAL" )

	aHelpPor := {}
	aHelpSpa := {}
	aHelpEng := {}

    Aadd( aHelpPor, "Informe o codigo final do intervalo"   )
    Aadd( aHelpPor, "de filiais da sua empresa a serem"     )
    Aadd( aHelpPor, "considerados na impressao."            )

    Aadd( aHelpSpa, "Digite el codigo final del intervalo " )
    Aadd( aHelpSpa, "de sucursales de su empresa que se "   )
    Aadd( aHelpSpa, "deben considerar en la impresion."     )

    Aadd( aHelpEng, "Enter the final code of your "         )
    Aadd( aHelpEng, "company's branches interval to "       )
    Aadd( aHelpEng, "be considered in the print."           )

	PutSx1(	cPerg,	"13", "Ate Filial ?", "¿A Sucursal ?", "To Branch ?", "mv_chd", aTamSX3[3], aTamSx3[1], aTamSX3[2], 2, "G", "", "", "", "",;
					"mv_par13", "", "", "", "ZZ", "", "", "", "", "", "", "", "", "", "", "", "", , , , "." + RTrim(cPerg) + "13." )

	PutSX1Help( "P." + RTrim(cPerg) + "13.", aHelpPor, aHelpEng, aHelpSpa )

EndIf

RestArea( aArea )

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FR865CodRet º Autor ³ Gustavo Henrique º Data ³ 01/07/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Exibe dialogo para selecao dos codigos de retencao caso    º±±
±±º          ³ seja informado "Sim" na pergunta "Filtra Cod. Retencao?"   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ EXPA1 - Vetor com os codigos de retencao selecionados para º±±
±±º          ³         filtro dos valores de impostos impressos.          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Relatorio de Retencao de Impostos - FINR865                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FR865CodRet( aCodRet )
     
Local aArea		:= GetArea()
Local cTitulo	:= ""                     
Local lRet		:= .T.
Local cTabela	:= "37"		// Tabela 37 - Codigos de retencao
Local aBox		:= {}                        
Local nTam		:= TamSX3("E2_CODRET")[1]
                     
Local MvParDef	:= ""

// Posiciona na Tabela 37 para buscar a descricao da tabela do SX5
If SX5->( MsSeek( xFilial("SX5") + "00" + cTabela ) )
   cTitulo := SX5->( Alltrim( Left( X5Descri(), 20 ) ) )
EndIf

// Monta opcoes para selecao de acordo com os itens da tabela do SX5
If SX5->( MsSeek( xFilial("SX5") + cTabela ) )
	Do While SX5->( !Eof() .And. X5_TABELA == cTabela )
		AAdd( aBox, AllTrim( SX5->X5_CHAVE ) + " - " + Alltrim( SX5->( X5Descri() ) ) )
		MvParDef += AllTrim( SX5->X5_CHAVE )
		SX5->( dbSkip() )
	EndDo
EndIf

Do While lRet

	lRet := f_Opcoes(	@aCodRet,;		// uVarRet
						cTitulo,;		// cTitulo
						@aBox,;			// aOpcoes
						MvParDef,;		// cOpcoes
						,;				// nLin1
						,;				// nCol1
						,;				// l1Elem
						nTam,; 			// nTam
						Len( aBox ),;	// nElemRet
						,;				// lMultSelect
						,;				// lComboBox
						,;				// cCampo
						,;				// lNotOrdena
						,;				// NotPesq
						.T.,;			// ForceRetArr
						 )				// F3
			
	If lRet .And. Len( aCodRet ) == 0
		// Quando for informado "Sim" na pergunta "Filtra Códigos de Retenção?", deve ser selecionado ao menos um código de retenção.
		MsgInfo( STR0043 ) 
	Else
		Exit
	EndIf
	
EndDo

RestArea( aArea )

Return lRet



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FR865FilCRet º Autor ³ Gustavo Henrique º Data ³ 01/07/09  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Realiza filtro por codigo de retencao se informados.       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ EXPA1 - Valores dos impostos do titulo a serem impressos.  º±±
±±º          ³ EXPA2 - Codigos de retencao selecionados no filtro.        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Relacao de Impostos                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FR865FilCRet( aValImp, aCodRet, lTitPai )
			                               
Local cNatImp := ""			   

// Verifica parcelas dos impostos do titulo principal para saber se tem o imposto			   
If !Empty( TRB->PARCPIS )	// Pis
	cNatImp := SuperGetMV( "MV_PISNAT" )
	// Se o codigo de retencao nao foi selecionado para filtro, grava zero no valor do imposto
	If ! FR865PesqImp( TRB->( PREFIXO + NUM + PARCPIS ), aCodRet, cNatImp, lTitPai )
		aValImp[ N_VALPIS ] := 0
	EndIf	             
EndIf

If !Empty( TRB->PARCCOF )	// Cofins
	cNatImp := SuperGetMV( "MV_COFINS" )
	If ! FR865PesqImp( TRB->( PREFIXO + NUM + PARCCOF ), aCodRet, cNatImp, lTitPai )
		aValImp[ N_VALCOF ] := 0   
	EndIf	
EndIf

If !Empty( TRB->PARCSLL )	// Csll
	cNatImp := SuperGetMV( "MV_CSLL" )
	If ! FR865PesqImp( TRB->( PREFIXO + NUM + PARCSLL ), aCodRet, cNatImp, lTitPai )
		aValImp[ N_VALCSLL ] := 0   
	EndIf	
EndIf

If !Empty( TRB->PARCIR )	// Irrf
	cNatImp := &( SuperGetMV( "MV_IRF" ) )
	If ! FR865PesqImp( TRB->( PREFIXO + NUM + PARCIR ), aCodRet, cNatImp, lTitPai )
		aValImp[ N_VALIRRF ] := 0   
	EndIf	
EndIf

// ISS nao tem codigo de retencao, tem codigo de recolhimento pois eh uma contribuicao da previdencia 
// social. Por este motivo, nao imprime o imposto se selecionado filtro por codigos de retencao.
If !Empty( TRB->PARCISS ) .Or. !Empty( TRB->VALISS ) // Iss
	aValImp[ N_VALISS ] := 0  
EndIf

// INSS nao tem codigo de retencao, tem codigo de recolhimento pois eh uma contribuicao da previdencia 
// social. Por este motivo, nao imprime o imposto se selecionado filtro por codigos de retencao.
If !Empty( TRB->PARCINS ) .Or. !Empty( TRB->VALINSS )	// Inss
	aValImp[ N_VALINSS ] := 0
EndIf

If !Empty( TRB->PARCSES )	// Sest
	cNatImp := SuperGetMV( "MV_SEST" )
	If ! FR865PesqImp( TRB->( PREFIXO + NUM + PARCSES ), aCodRet, cNatImp, lTitPai )
		// Para o caso de Sest, verifica tambem se existe codigo de rentecao no titulo pai
		SE2->( dbSetOrder( 1 ) )     
		SE2->( MsSeek( xFilial("SE2") + TRB->( PREFIXO + NUM + PARCELA + TIPO + CODIGO + LOJA ) ) )
		If aScan( aCodRet, SE2->E2_CODRET ) == 0
			aValImp[ N_VALSEST ] := 0
		EndIf	
	EndIf	
EndIf
	
Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FR865PesqImp º Autor ³ Gustavo Henrique º Data ³ 01/07/09  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Retornar se o valor do imposto deve ser impresso no        º±±
±±º          ³ relatorio a partir dos filtros de codigo de retencao       º±±
±±º          ³ selecionados.                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ EXPC1 - Chave parcial do titulo de imposto (Prefixo,       º±±
±±º          ³         Numero e Parcela do Imposto)                       º±±
±±º          ³ EXPA2 - Vetor com os codigos de retencao para filtro       º±±
±±º          ³ EXPC3 - Natureza do titulo de imposto.                     º±±
±±º          ³ EXPL4 - Indica se existe o campo E2_TITPAI.                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ EXPL1 - Retorna .T. se deve considerar o valor do imposto  º±±
±±º          ³         no relatorio ou .F. caso contrario.                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Relacao de Impostos                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FR865PesqImp( cChaveImp, aCodRet, cNatImp, lTitPai )

Local lRet := .T.

SE2->( dbSetOrder( 1 ) )     
SE2->( MsSeek( xFilial("SE2") + cChaveImp ) )

Do While SE2->( ! Eof() .And. E2_PREFIXO + E2_NUM + E2_PARCELA == cChaveImp )
	// Faz a validacao da chave do titulo pai se existir o campo
	If lTitPai .And. !Empty( SE2->E2_TITPAI )
		If AllTrim( SE2->E2_TITPAI ) == AllTrim( TRB->( PREFIXO + NUM + PARCELA + TIPO + CODIGO + LOJA ) ) .And.;
			AllTrim( SE2->E2_NATUREZ ) == AllTrim( cNatImp )
			If aScan( aCodRet, SE2->E2_CODRET ) == 0
				lRet := .F.
				Exit
			EndIf	                                                                              			
		EndIf                                                                                     
	Else            
		// Caso nao exista o campo ou existe mas esta vazio, verifica a natureza do imposto
		If AllTrim( SE2->E2_NATUREZ ) $ cNatImp .And. aScan( aCodRet, SE2->E2_CODRET ) == 0
			lRet := .F.
			Exit
		EndIf
	EndIf	
	SE2->( dbSkip() )
EndDo                  

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FR865Cabec º Autor ³ Gustavo Henrique º Data ³  07/02/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Imprime o cabecalho do relatorio com os codigos de retencaoº±±
±±º          ³ selecionados, se informado filtro por codigo de retencao.  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Relacao de Impostos                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FR865Cabec( nMVComp, nRegSM0, lFilCRet, cCodRet )

Local nAtuSM0 := SM0->(Recno())

SM0->( dbGoto(nRegSM0) )
cabec( titulo, cabec1, cabec2, nomeprog, tamanho, nMVComp )
SM0->( dbGoTo(nAtuSM0) )

If lFilCRet          
	@li, 000 PSAY STR0044 + cCodRet		// Codigos de Retencao Selecionados: 
	li++
	@li,000 PSAY Replicate("_",220)
	li+=2
EndIf

Return
