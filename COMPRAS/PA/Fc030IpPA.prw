#Include "FINC030.CH"
#Include "PROTHEUS.CH"
#Include "MSGRAPHI.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fC030Imp ³ Autor ³ Wagner Xavier         ³ Data ³ 06/07/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime a consulta de titulos                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fC030Imp()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Fc030IpPA()

LOCAL cDesc1   :=OemToAnsi(STR0074) //"Este programa ira imprimir a Consulta de um Fornecedor,"
LOCAL cDesc2   :=OemToAnsi(STR0075) //"informando os dados acumulados do Fornecedor, os Pedidos"
LOCAL cDesc3   :=OemToAnsi(STR0076) //"em aberto, Titulos em Aberto e rela‡„o do Faturamento."
LOCAL cString  :="SA2"
LOCAL nRegistro:= SA2 -> (RecNo())
LOCAL cTamanho := "G"  
Local aPergs		:= {}
Local cFilBkp   := cFilAnt
PRIVATE cPerg   := "FIC030"
PRIVATE aReturn := { OemToAnsi(STR0077), 1,OemToAnsi(STR0078), 1, 2, 1, "",1 } //"Zebrado"###"Administracao"
PRIVATE nLastKey:= 0
PRIVATE cTitulo := OemToAnsi(STR0079) //"Consulta Posicao Atual de Fornecedores"
PRIVATE nCasas  := GetMv("MV_CENT")
li       := 80
m_pag    := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01        // Emissao De                                ³
//³ mv_par02        // Emissao Ate                               ³
//³ mv_par03        // Vencimento De                             ³
//³ mv_par04        // Vencimento Ate                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHelpPor		:= {}
aHelpEng		:= {}
aHelpSpa		:= {}
AADD(aHelpPor,"Selecione o metodo de conversao para a   ")
AADD(aHelpPor,"moeda selecionada")

AADD(aHelpSpa,"Seleccione el metodo de conversion ")
AADD(aHelpSpa,"para la moneda seleccionada ")

AADD(aHelpEng,"Select the conversion method for the ")
AADD(aHelpEng,"selected currency")

Aadd(aPergs,{"Conv.mov. na moeda sel.pela?","Conv. mov. en moneda sel. por?","Conv. mov. in selec. curr. by?","mv_ch9","N",1,0,2,"C","","mv_par09","Data Movimento","Fecha movimiento","Movement day","","","Data de Hoje","Fecha de hoy.","Today's date","","","","","","","","","","","","","","","","","","","S","",aHelpPor,aHelpEng,aHelpSpa})
/*
GESTAO - inicio */
aHelpPor := {"Escolha Sim se deseja selecionar ","as filiais. ","Esta pergunta somente terá efeito em","ambiente TOTVSDBACCESS (TOPCONNECT)"}			
aHelpEng := {"Enter Yes if you want to select ","the branches.","This question affects TOTVSDBACCESS","(TOPCONNECT) environment only."}
aHelpSpa := {"La opción Sí, permite seleccionar ","las sucursales.","Esta pregunta solo tendra efecto en el ","entorno TOTVSDBACCESS (TOPCONNECT)"}
Aadd(aPergs,{"Seleciona Filiais?" ,"¿Selecciona sucursales?" ,"Select Branches?","mv_cha","N",1,0,2,"C","","mv_par10","Sim","Si ","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","","S","",aHelpPor,aHelpEng,aHelpSpa})
/* GESTAO - fim
*/
AjustaSx1("FIC030",aPergs) 

pergunte("FIC030",.F.)

wnrel := "FINC030"

wnrel := SetPrint(cString,wnrel,cPerg,cTitulo,cDesc1,cDesc2,cDesc3,.F.,"",.T.,cTamanho,"",.F.)

If nLastKey == 27
	cFilant := cFilBkp
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	cFilant := cFilBkp
	Return
Endif

dbSelectArea("SA2")
dbGoTo(nRegistro)
RptStatus({|lEnd| Fc030RlPA(@lEnd,wnRel,cString)},cTitulo)
cFilant := cFilBkp
Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³ Fc030Rel ³ Autor ³ Pilar S. ALbaladejo   ³ Data ³ 16/01/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³ Impressao da posicao de Fornecedor                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³ Fc030Rel(lEnd,wnRel,cString)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGACON                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ lEnd    - A‡Æo do Codeblock                                ³±±
±±³           ³ wnRel   - T¡tulo do relat¢rio                              ³±±
±±³           ³ cString - Mensagem                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fc030RlPA(lEnd,WnRel,cString)

LOCAL cCabec1,cCabec2,cCabec3,cCabec4,cCabec5,cTamanho,cNomeProg,dData,dVencto
LOCAL cBanco, cAgencia, cConta, cHistor, cMotBx
LOCAL nPedidos  := 0
LOCAL nNotas    := 0
LOCAL nTotal    := 0
LOCAL nTitulos  := 0
LOCAL nTotalPA  := 0
LOCAL nTituloPA := 0
LOCAL nTotNota  := 0
LOCAL nTotPgto  := 0
LOCAL nTitPagos := 0
LOCAL nValPed   := 0
Local nValItPed := 0
Local nFN030IPC := 0
LOCAL nSavRec   := 0
LOCAL nTotalNF  := 0
LOCAL cbcont    := 0
Local nCotac	:= 0
LOCAL aMatriz   := {}
LOCAL cMoeda
LOCAL cbtxt     := SPACE(10)
LOCAL nPos      := 0
LOCAL aMotBx    := ReadMotBx()
Local nLaco		:= 0
Local nSpaceNum := 14 - TamSX3("E2_NUM")[1]
Local nJuros	:= 0
Local nMulta	:= 0
Local nDesco	:= 0
Local nTotJur	:= 0
Local nTotMul	:= 0
Local nTotDes	:= 0
LOCAL cDescMoeda:= " "      		
Local nColMovel	:= {}
Local cHistCompl:=""
/*
GESTAO - inicio */
Local cQuery		:= ""
Local cFilAtual		:= ""
Local cAliasTmp		:= ""
Local nPosAlias		:= 0
Local nEspacoFil	:= 0
Local lC7Fiscori	:=	SC7->(FieldPos("C7_FISCORI")) > 0

Private aSelFil		:= {}
Private aTmpFil		:= {}

#IFDEF TOP
	nEspacoFil := FWSizeFilial() + 2
	If FWModeAccess("SA2",3) == "C"
		If MV_PAR10 == 1
			If  FindFunction("AdmSelecFil")
					AdmSelecFil("FIC030",10,.F.,@aSelFil,"SA2",(FWModeAccess("SA2",1) == "E"),(FWModeAccess("SA2",2) == "E"),cFilCorr)
			Else
				aSelFil := AdmGetFil(.F.,.F.,"SA2")
			Endif
		Endif
	Endif
#ENDIF
If Empty(aSelFil)
	Aadd(aSelFil,cFilCorr)
Endif		
/* GESTAO - fim
*/
cMoeda   := GetMv("MV_MCUSTO")
cMoeda   := SubStr(Getmv("MV_SIMB"+cMoeda)+Space(4),1,4)

cTamanho := "G"
cCabec2  := " "
cNomeProg:= "FIC030"
cCabec1  := " "
cabec(cTitulo,cCabec1,cCabec2,cNomeProg,cTamanho)
li++

If cPaisLoc == "MEX"
	nColMovel := {{163,184,197},{173,184,197}}
Else
	nColMovel := {{163,179,192},{173,194,207}}
EndIf
 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao dos dados do Fornecedor           				  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@li, 1 pSay Padr(AllTrim(OemToAnsi(STR0044)),30,".") + ": " + SA2->A2_COD + "   " + OemToAnsi(STR0046) + ": " + SA2->A2_NOME //"Codigo"###"Nome"
li++
@li, 1 pSay Padr(AllTrim(OemToAnsi(STR0080)),30,".") + ": " + SA2->A2_CGC 				//"N.Contrib.Jur."
li++
@li, 1 pSay Padr(AllTrim(OemToAnsi(STR0061)),30,".") + ": " + DTOC(SA2->A2_PRICOM)  	//"Primeira Compra"
li++
@li, 1 pSay Padr(AllTrim(OemToAnsi(STR0081)),30,".") + ": " + DTOC(SA2->A2_ULTCOM)   	//"Ultima Compra"
li++
@li, 1 pSay Padr(AllTrim(OemToAnsi(STR0063)),30,".") + ":" 								//"Maior Atraso"
@li,Pcol() + 1 pSay SA2->A2_MATR Picture tm(SA2->A2_MATR,14)
li++
@li, 1 pSay Padr(AllTrim(OemToAnsi(STR0057)),30,".") + ":" 								//"Saldo Atual"
@li,Pcol() + 1 pSay SA2->A2_SALDUP Picture tm(SA2->A2_SALDUP,14,nCasas)
li++
@li, 1 pSay Padr(AllTrim(OemToAnsi(STR0058)),30,".") + ":" 								//"Maior Compra"
@li,Pcol() + 1 pSay SA2->A2_MCOMPRA Picture tm(SA2->A2_MCOMPRA,14,nCasas)
li++
@li, 1 pSay Padr(AllTrim(OemToAnsi(STR0059)),30,".") + ":" 								//"Maior Saldo"
@li,Pcol() + 1 pSay SA2->A2_MSALDO Picture tm(SA2->A2_MSALDO,14,nCasas)
li++
@li, 1 pSay Padr(AllTrim(OemToAnsi(STR0060) + " " + AllTrim(cMoeda)),30,".") + ":" 		//"Saldo Atual em"
@li,Pcol() + 1 pSay SA2->A2_SALDUPM Picture tm(SA2->A2_SALDUPM,14,nCasas)
li+=3

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao dos Titulos em aberto             				  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@li,1 pSay OemToAnsi(Upper(STR0051)) //"TITULOS EM ABERTO"
li++
@li, 1 pSay Repl("-",17)
li++

SetRegua( Reccount() )
If cPaisLoc == "BRA"	// Sergio Fuzinaka - 20.08.01
	cCabec1 := OemToAnsi(STR0082) //"PRF  NUMERO       PC TIPO  EMISSAO    NATUREZA     SALDO A PAGAR   DATA VENCTO    ATRASO   VALOR JUROS    VALOR IRRF     VALOR ISS   VALOR  INSS   NUM CHEQUE"
Else
	If cPaisLoc == "MEX"
		cCabec1 := OemToAnsi(STR0137) //"PRF  NUMERO              PC TIPO  EMISION    MODALIDAD    SALDO POR PAGAR   FCH. VENCTO    ATRASO   VALOR INTERES  NUM CHEQUE"	
	Else
		cCabec1 := OemToAnsi(STR0083) //"PRF  NUMERO       PC TIPO  EMISSAO    NATUREZA     SALDO A PAGAR   DATA VENCTO    ATRASO   VALOR JUROS    NUM CHEQUE"
	EndIf
Endif
/*
GESTAO - inicio */
#IFDEF TOP
	cCabec1 := PadR(Upper(SX3->(RetTitle("E2_FILORIG"))),FWSizeFilial()) + "  " + cCabec1
#ENDIF 
/* GESTATO - fim
*/
@li, 1 pSay cCabec1
aMatriz := {}
/*
GESTAO - inicio */
dbSelectArea("SE2")
dbSetOrder(3)
#IFDEF TOP
	cQuery := "select R_E_C_N_O_ RECSE2 from " + RetSQLName("SE2")
	nPosAlias := FC030QFil(1,"SE2")
	cQuery += " WHERE E2_FILIAL " + aTmpFil[nPosAlias,2]
	cQuery += " and E2_FORNECE = '" + SA2->A2_COD + "'"
	cQuery += " and E2_LOJA = '" + SA2->A2_LOJA + "'"
	cQuery += " and E2_VENCREA >= '" + Dtos(mv_par03) + "'"
	cQuery += " and E2_VENCREA <= '" + Dtos(mv_par04) + "'"
	cQuery += " and D_E_L_E_T_ = ' '"
    cQuery += " order by E2_VENCREA,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO"
    cQuery := ChangeQuery(cQuery)
    cAliasTmp := GetNextAlias()
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasTmp, .T., .T.)
	cFilAtual := cFilAnt
	While !((cAliasTmp)->(Eof()))
		DbSelectArea("SE2")
		SE2->(DbGoTo((cAliasTmp)->RECSE2))
		cFilAnt := SE2->E2_FILORIG
#ELSE
	dbSeek( xFilial("SE2")+ dTos( mv_par03 ) , .T. )
	cAliasTmp := "SE2"
	While !EOF() .And. SE2->E2_FILIAL==cFilial .and. SE2->E2_VENCREA <= mv_par04
#ENDIF	
	If lEnd
		@Prow()+1,0 PSay cCancel
		Exit
	EndIF
	
	IncRegua()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Nao lˆ outros fornecedores, abatimentos e provis¢rios.  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SE2->E2_FORNECE+SE2->E2_LOJA # SA2->A2_COD+SA2->A2_LOJA .or. SE2->E2_TIPO $ MVABATIM .or. SE2->E2_SALDO = 0
		(cAliasTmp)->(dbSkip())
		Loop
	EndIF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Nao lˆ cheques para versao localizada, sao tratados por ³
	//³ separado na rotina "Cartera de cheques".                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cPaisLoc != "BRA" .And. SE2->E2_TIPO$IIF(Type('MVCHEQUES')=='C',MVCHEQUES,MVCHEQUE)
		(cAliasTmp)->(dbSkip())
		Loop
	EndIF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se considera Titulos Provisorios.            	³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If	SE2->E2_TIPO $ MVPROVIS .and. mv_par05 == 2
		(cAliasTmp)->(dbSkip())
		Loop
	Endif		
	
	IF mv_par06 == 2 .and. !Empty(SE2->E2_FATURA) .and. Substr(SE2->E2_FATURA,1,6) != "NOTFAT"
		(cAliasTmp)->(dbSkip())
		Loop
	Endif
	
	nSavRec := SE2->( Recno() )
	
	nTotAbat := 0
	IF SE2->E2_VENCTO >= mv_par03 .and. SE2->E2_VENCTO <= mv_par04 .and. ;
			SE2->E2_EMISSAO >= mv_par01 .and. SE2->E2_EMISSAO <= mv_par02
		nTotAbat:=0
		nTotAbat:=SomaAbat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,"P",1,,SE2->E2_FORNECE,SE2->E2_LOJA)
		If !empty(SE2->E2_SDDECRE) 
			nTotAbat += SE2->E2_SDDECRE
		Endif
		dbSetOrder(6)
		IF SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG
			nTotal-=xMoeda(SE2->E2_SALDO-nTotAbat,SE2->E2_MOEDA,1,,,Iif(mv_par09==1,SE2->E2_TXMOEDA,0))
		Else
			nTotal+=xMoeda(SE2->E2_SALDO-nTotAbat,SE2->E2_MOEDA,1,,,Iif(mv_par09==1,SE2->E2_TXMOEDA,0))
		Endif
		
		nTitulos++
		nAtraso := dDataBase-fC030Venc()
		fa080Juros()
		/*
		GESTAO - inicio */
		#IFDEF TOP
			If cPaisLoc == "BRA"	// Sergio Fuzinaka - 20.08.01
			    Aadd( aMatriz , DTOS(fc030Venc())+"|"+SE2->E2_FILORIG+"  "+SE2->E2_PREFIXO+"  "+SE2->E2_NUM+Space(4)+;
				SE2->E2_PARCELA+"  "+SE2->E2_TIPO + " "+PADC(DTOC(SE2->E2_EMISSAO),10)+"    "+SE2->E2_NATUREZ + ;
				Transform(xMoeda(SE2->E2_SALDO-nTotAbat,SE2->E2_MOEDA,1,,,Iif(mv_par09==1,SE2->E2_TXMOEDA,0)),Tm(SE2->E2_SALDO,15,nCasas) ) +"    "+;
				PADC(DTOC(fc030Venc()),10)+Space(3)+Str(nAtraso,6)+" "+Transform(nJuros,Tm(nJuros,15,nCasas) )+;
				Transform(SE2->E2_IRRF,Tm(SE2->E2_IRRF,15,nCasas)) + Transform(SE2->E2_ISS,Tm(SE2->E2_ISS,15,nCasas) ) +;
				Transform(SE2->E2_INSS,Tm(SE2->E2_INSS,15,nCasas)) + "   "+ SE2->E2_NUMBCO )
			Else
				Aadd( aMatriz , DTOS(fc030Venc())+"|"+SE2->E2_FILORIG+"  "+SE2->E2_PREFIXO+"  "+SE2->E2_NUM+Space(nSpaceNum)+" "+;
					SE2->E2_PARCELA+" "+SE2->E2_TIPO + "   "+PADC(DTOC(SE2->E2_EMISSAO),10)+" "+SE2->E2_NATUREZ+"  "+;
					Transform(Moeda((SE2->E2_SALDO-nTotAbat),1,"P"),Tm(SE2->E2_SALDO,15,nCasas) ) +"     "+;
					PADC(DTOC(fc030Venc()),10)+Space(2)+Str(nAtraso,6)+" "+Transform(nJuros,Tm(nJuros,15,nCasas) )+;
					"    "+ SE2->E2_NUMBCO )
			Endif
		#ELSE
			If cPaisLoc == "BRA"	// Sergio Fuzinaka - 20.08.01
			    Aadd( aMatriz , DTOS(fc030Venc())+"|"+SE2->E2_PREFIXO+"  "+SE2->E2_NUM+Space(3)+;
				SE2->E2_PARCELA+" "+SE2->E2_TIPO + " "+PADC(DTOC(SE2->E2_EMISSAO),10)+"   "+SE2->E2_NATUREZ+" "+;
				Transform(xMoeda(SE2->E2_SALDO-nTotAbat,SE2->E2_MOEDA,1,,,Iif(mv_par09==1,SE2->E2_TXMOEDA,0)),Tm(SE2->E2_SALDO,15,nCasas) ) +"    "+;
				PADC(DTOC(fc030Venc()),10)+Space(2)+Str(nAtraso,6)+"  "+Transform(nJuros,Tm(nJuros,15,nCasas) )+;
				Transform(SE2->E2_IRRF,Tm(SE2->E2_IRRF,15,nCasas)) + Transform(SE2->E2_ISS,Tm(SE2->E2_ISS,15,nCasas) ) +;
				Transform(SE2->E2_INSS,Tm(SE2->E2_INSS,15,nCasas)) + "   "+ SE2->E2_NUMBCO )
			Else
				Aadd( aMatriz , DTOS(fc030Venc())+"|"+SE2->E2_PREFIXO+"  "+SE2->E2_NUM+Space(nSpaceNum)+" "+;
					SE2->E2_PARCELA+"  "+SE2->E2_TIPO + "  "+PADC(DTOC(SE2->E2_EMISSAO),10)+"  "+SE2->E2_NATUREZ+" "+;
					Transform(Moeda((SE2->E2_SALDO-nTotAbat),1,"P"),Tm(SE2->E2_SALDO,15,nCasas) ) +"    "+;
					PADC(DTOC(fc030Venc()),10)+Space(2)+Str(nAtraso,6)+"  "+Transform(nJuros,Tm(nJuros,15,nCasas) )+;
					"   "+ SE2->E2_NUMBCO )
			Endif
		#ENDIF		
	EndIF
	dbSelectArea("SE2")
	dbSetOrder(3)
	#IFNDEF TOP
		SE2->(dbGoTo( nSavRec ))
	#ENDIF
	(cAliasTmp)->(dbSkip())
EndDo
/*
GESTAO - inicio */
#IFDEF TOP
	cFilAnt := cFilAtual
	DbSelectArea(cAliasTmp)
	DbCloseArea()
	DbSelectArea("SE2")
#ENDIF
/* GESTAO - fim
*/
dbSetOrder(1)
aSort( aMatriz )
For nLaco := 1 to Len( aMatriz)
	IF li > 58
		cabec(cTitulo,cCabec1,cCabec2,cNomeProg,cTamanho)
	Endif
	li++
	@li, 01 pSay Subst( aMatriz[nLaco] , 10 , Len( aMatriz[nLaco] ) )
Next

li+=2
@li, 1 pSay OemToAnsi(STR0084) //"Total de Titulos .........."
@Prow(),Pcol() pSay nTitulos Picture "9999"
@li,nEspacoFil + 50 pSay nTotal Picture tm(nTotal,15,nCasas)




//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ INICIO - Impressao dos Titulos PA Pedido de Compra			  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
li+=3
@li,1 pSay "TITULOS PAGOS ANTECIPADOS/PEDIDO DE COMPRAS"
li++
@li, 1 pSay Repl("-",27)
li++

SetRegua( Reccount() )
If cPaisLoc == "BRA"	// Sergio Fuzinaka - 20.08.01
	cCabec1 := "PRF  NUMERO       PC TIPO  EMISSAO    NATUREZA        VALOR PAGO     DATA VENCTO    ATRASO   VALOR JUROS    VALOR IRRF      VALOR ISS   VALOR   INSS   NUM CHEQUE"
Else
	If cPaisLoc == "MEX"
		cCabec1 := OemToAnsi(STR0137) //"PRF  NUMERO              PC TIPO  EMISION    MODALIDAD    SALDO POR PAGAR   FCH. VENCTO    ATRASO   VALOR INTERES  NUM CHEQUE"	
	Else
		cCabec1 := OemToAnsi(STR0083) //"PRF  NUMERO       PC TIPO  EMISSAO    NATUREZA     SALDO A PAGAR   DATA VENCTO    ATRASO   VALOR JUROS    NUM CHEQUE"
	EndIf
Endif
/*
GESTAO - inicio */
#IFDEF TOP
	cCabec1 := PadR(Upper(SX3->(RetTitle("E2_FILORIG"))),FWSizeFilial()) + "  " + cCabec1
#ENDIF 
/* GESTATO - fim
*/
@li, 1 pSay cCabec1
aMatriz := {}
/*
GESTAO - inicio */
dbSelectArea("SE2")
dbSetOrder(3)
#IFDEF TOP
	cQuery := "select R_E_C_N_O_ RECSE2 from " + RetSQLName("SE2")
	nPosAlias := FC030QFil(1,"SE2")
	cQuery += " WHERE E2_FILIAL " + aTmpFil[nPosAlias,2]
	cQuery += " and E2_FORNECE  = '" + SA2->A2_COD + "'"
	cQuery += " and E2_LOJA     = '" + SA2->A2_LOJA + "'"
	cQuery += " and E2_VENCREA >= '" + Dtos(mv_par03) + "'"
	cQuery += " and E2_VENCREA <= '" + Dtos(mv_par04) + "'"
	cQuery += " and E2_FLAGPA   = 'S'"	
	cQuery += " and D_E_L_E_T_  = ' '"
    cQuery += " order by E2_VENCREA,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO"
    cQuery := ChangeQuery(cQuery)
    cAliasTmp := GetNextAlias()
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasTmp, .T., .T.)
	cFilAtual := cFilAnt
	While !((cAliasTmp)->(Eof()))
		DbSelectArea("SE2")
		SE2->(DbGoTo((cAliasTmp)->RECSE2))
		cFilAnt := SE2->E2_FILORIG
#ELSE
	dbSeek( xFilial("SE2")+ dTos( mv_par03 ) , .T. )
	cAliasTmp := "SE2"
	While !EOF() .And. SE2->E2_FILIAL==cFilial .and. SE2->E2_VENCREA <= mv_par04
#ENDIF	
	If lEnd
		@Prow()+1,0 PSay cCancel
		Exit
	EndIF
	
	IncRegua()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Nao lˆ outros fornecedores, abatimentos e provis¢rios.  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SE2->E2_FORNECE+SE2->E2_LOJA # SA2->A2_COD+SA2->A2_LOJA .or. SE2->E2_TIPO $ MVABATIM //.or. SE2->E2_SALDO = 0
		(cAliasTmp)->(dbSkip())
		Loop
	EndIF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Nao lˆ cheques para versao localizada, sao tratados por ³
	//³ separado na rotina "Cartera de cheques".                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cPaisLoc != "BRA" .And. SE2->E2_TIPO$IIF(Type('MVCHEQUES')=='C',MVCHEQUES,MVCHEQUE)
		(cAliasTmp)->(dbSkip())
		Loop
	EndIF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se considera Titulos Provisorios.            	³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If	SE2->E2_TIPO $ MVPROVIS .and. mv_par05 == 2
		(cAliasTmp)->(dbSkip())
		Loop
	Endif		
	
	IF mv_par06 == 2 .and. !Empty(SE2->E2_FATURA) .and. Substr(SE2->E2_FATURA,1,6) != "NOTFAT"
		(cAliasTmp)->(dbSkip())
		Loop
	Endif
	
	nSavRec := SE2->( Recno() )
	
	nTotAbat := 0
	IF SE2->E2_VENCTO >= mv_par03 .and. SE2->E2_VENCTO <= mv_par04 .and. ;
			SE2->E2_EMISSAO >= mv_par01 .and. SE2->E2_EMISSAO <= mv_par02
		nTotAbat:=0
		nTotAbat:=SomaAbat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,"P",1,,SE2->E2_FORNECE,SE2->E2_LOJA)
		If !empty(SE2->E2_SDDECRE) 
			nTotAbat += SE2->E2_SDDECRE
		Endif
		dbSetOrder(6)
		IF SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG
		  	nTotalPA-=xMoeda(SE2->E2_VALOR-nTotAbat,SE2->E2_MOEDA,1,,,Iif(mv_par09==1,SE2->E2_TXMOEDA,0))//xMoeda(SE2->E2_SALDO-nTotAbat,SE2->E2_MOEDA,1,,,Iif(mv_par09==1,SE2->E2_TXMOEDA,0))
		Else
			nTotalPA+=xMoeda(SE2->E2_VALOR-nTotAbat,SE2->E2_MOEDA,1,,,Iif(mv_par09==1,SE2->E2_TXMOEDA,0))//xMoeda(SE2->E2_SALDO-nTotAbat,SE2->E2_MOEDA,1,,,Iif(mv_par09==1,SE2->E2_TXMOEDA,0))
		Endif
		
		nTituloPA++
		nAtraso := dDataBase-fC030Venc()
		fa080Juros()
		/*
		GESTAO - inicio */
		#IFDEF TOP
			If cPaisLoc == "BRA"	// Sergio Fuzinaka - 20.08.01
			    Aadd( aMatriz , DTOS(fc030Venc())+"|"+SE2->E2_FILORIG+"  "+SE2->E2_PREFIXO+"  "+SE2->E2_NUM+Space(4)+;
				SE2->E2_PARCELA+"  "+SE2->E2_TIPO + " "+PADC(DTOC(SE2->E2_EMISSAO),10)+"    "+SE2->E2_NATUREZ + ;
				Transform(xMoeda(SE2->E2_VALOR-nTotAbat,SE2->E2_MOEDA,1,,,Iif(mv_par09==1,SE2->E2_TXMOEDA,0)),Tm(SE2->E2_VALOR,15,nCasas) ) +"    "+;
				PADC(DTOC(fc030Venc()),10)+Space(3)+Str(nAtraso,6)+" "+Transform(nJuros,Tm(nJuros,15,nCasas) )+;
				Transform(SE2->E2_IRRF,Tm(SE2->E2_IRRF,15,nCasas)) + Transform(SE2->E2_ISS,Tm(SE2->E2_ISS,15,nCasas) ) +;
				Transform(SE2->E2_INSS,Tm(SE2->E2_INSS,15,nCasas)) + "   "+ SE2->E2_NUMBCO )
			Else
				Aadd( aMatriz , DTOS(fc030Venc())+"|"+SE2->E2_FILORIG+"  "+SE2->E2_PREFIXO+"  "+SE2->E2_NUM+Space(nSpaceNum)+" "+;
					SE2->E2_PARCELA+" "+SE2->E2_TIPO + "   "+PADC(DTOC(SE2->E2_EMISSAO),10)+" "+SE2->E2_NATUREZ+"  "+;
					Transform(Moeda((SE2->E2_VALOR-nTotAbat),1,"P"),Tm(SE2->E2_VALOR,15,nCasas) ) +"     "+;
					PADC(DTOC(fc030Venc()),10)+Space(2)+Str(nAtraso,6)+" "+Transform(nJuros,Tm(nJuros,15,nCasas) )+;
					"    "+ SE2->E2_NUMBCO )
			Endif
		#ELSE
			If cPaisLoc == "BRA"	// Sergio Fuzinaka - 20.08.01
			    Aadd( aMatriz , DTOS(fc030Venc())+"|"+SE2->E2_PREFIXO+"  "+SE2->E2_NUM+Space(3)+;
				SE2->E2_PARCELA+" "+SE2->E2_TIPO + " "+PADC(DTOC(SE2->E2_EMISSAO),10)+"   "+SE2->E2_NATUREZ+" "+;
				Transform(xMoeda(SE2->E2_VALOR-nTotAbat,SE2->E2_MOEDA,1,,,Iif(mv_par09==1,SE2->E2_TXMOEDA,0)),Tm(SE2->E2_VALOR,15,nCasas) ) +"    "+;
				PADC(DTOC(fc030Venc()),10)+Space(2)+Str(nAtraso,6)+"  "+Transform(nJuros,Tm(nJuros,15,nCasas) )+;
				Transform(SE2->E2_IRRF,Tm(SE2->E2_IRRF,15,nCasas)) + Transform(SE2->E2_ISS,Tm(SE2->E2_ISS,15,nCasas) ) +;
				Transform(SE2->E2_INSS,Tm(SE2->E2_INSS,15,nCasas)) + "   "+ SE2->E2_NUMBCO )
			Else
				Aadd( aMatriz , DTOS(fc030Venc())+"|"+SE2->E2_PREFIXO+"  "+SE2->E2_NUM+Space(nSpaceNum)+" "+;
					SE2->E2_PARCELA+"  "+SE2->E2_TIPO + "  "+PADC(DTOC(SE2->E2_EMISSAO),10)+"  "+SE2->E2_NATUREZ+" "+;
					Transform(Moeda((SE2->E2_VALOR-nTotAbat),1,"P"),Tm(SE2->E2_VALOR,15,nCasas) ) +"    "+;
					PADC(DTOC(fc030Venc()),10)+Space(2)+Str(nAtraso,6)+"  "+Transform(nJuros,Tm(nJuros,15,nCasas) )+;
					"   "+ SE2->E2_NUMBCO )
			Endif
		#ENDIF		
	EndIF
	dbSelectArea("SE2")
	dbSetOrder(3)
	#IFNDEF TOP
		SE2->(dbGoTo( nSavRec ))
	#ENDIF
	(cAliasTmp)->(dbSkip())
EndDo
/*
GESTAO - inicio */
#IFDEF TOP
	cFilAnt := cFilAtual
	DbSelectArea(cAliasTmp)
	DbCloseArea()
	DbSelectArea("SE2")
#ENDIF
/* GESTAO - fim
*/
dbSetOrder(1)
aSort( aMatriz )
For nLaco := 1 to Len( aMatriz)
	IF li > 58
		cabec(cTitulo,cCabec1,cCabec2,cNomeProg,cTamanho)
	Endif
	li++
	@li, 01 pSay Subst( aMatriz[nLaco] , 10 , Len( aMatriz[nLaco] ) )
Next

li+=2
@li, 1 pSay OemToAnsi(STR0084) //"Total de Titulos .........."
@Prow(),Pcol() pSay nTituloPA Picture "9999"
@li,nEspacoFil + 50 pSay nTotalPA Picture tm(nTotalPA,15,nCasas)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FIM - Impressao dos Titulos PA para pedido de compra  		  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ










//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao dos Titulos pagos                 				  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCabec1 := " "
cCabec2 := " "
IF li > 50
	cabec(cTitulo,cCabec1,cCabec2,cNomeProg,cTamanho)
	@li, 00 pSay Replicate("*",220)
	li++
Else
	li+=3
EndIF
//                 1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9
//        123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
If cPaisLoc == "MEX"
	cCabec1 := OemToAnsi(STR0136) //"PRF NUMERO       PC  EMISSAO   NATUREZA     VALOR TITULO     VALOR PAGO   BAIXA       VENCTO.    ATRASO  BCO. AGENCIA CONTA       HISTORICO                             MOTIVO BAIXA   NUM CHEQUE"
Else
	cCabec1 := OemToAnsi(STR0085) //"PRF NUMERO       PC  EMISSAO   NATUREZA     VALOR TITULO     VALOR PAGO   BAIXA       VENCTO.    ATRASO  BCO. AGENCIA CONTA       HISTORICO                             MOTIVO BAIXA   NUM CHEQUE"
	/*
	GESTAO - inicio */
	#IFDEF TOP  
		cCabec1 := PadR(Upper(SX3->(RetTitle("E2_FILORIG"))),nEspacoFil) + cCabec1
	#ENDIF
	/* GESTATO - fim
	*/	
EndIf
cCabec3 := OemToAnsi(STR0123) //54/30, 58/20, 64/20
cCabec4 := OemToAnsi(STR0124) //92
cCabec5 := OemToAnsi(STR0125) //107
@li,1 pSay OemToAnsi(Upper(STR0052)) //"TITULOS PAGOS"
li++
@li, 1 pSay Repl("-",17)
li++
@li, 1 pSay cCabec1
@li, nEspacoFil + nColMovel[Iif(TamSX3("E5_CONTA")[1]==10,1,2),1] pSay cCabec3
@li, nEspacoFil + nColMovel[Iif(TamSX3("E5_CONTA")[1]==10,1,2),2] pSay cCabec4
@li, nEspacoFil + nColMovel[Iif(TamSX3("E5_CONTA")[1]==10,1,2),3] pSay cCabec5

SetRegua( Reccount() )

dbSelectArea("SE2")
dbSetOrder(3)
#IFDEF TOP
	cQuery := "select R_E_C_N_O_ RECSE2 from " + RetSQLName("SE2")
	nPosAlias := FC030QFil(1,"SE2")
	cQuery += " WHERE E2_FILIAL " + aTmpFil[nPosAlias,2]
	cQuery += " and E2_FORNECE = '" + SA2->A2_COD + "'"
	cQuery += " and E2_LOJA = '" + SA2->A2_LOJA + "'"
	cQuery += " and E2_VENCREA >= '" + Dtos(mv_par03) + "'"
	cQuery += " and E2_VENCREA <= '" + Dtos(mv_par04) + "'"
	cQuery += " and D_E_L_E_T_ = ' '"
    cQuery += " order by E2_VENCREA,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO"
    cQuery := ChangeQuery(cQuery)
    cAliasTmp := GetNextAlias()
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasTmp, .T., .T.)
	cFilAtual := cFilAnt
	While !((cAliasTmp)->(Eof()))
		DbSelectArea("SE2")
		SE2->(DbGoTo((cAliasTmp)->RECSE2))
		cFilAnt := SE2->E2_FILORIG
#ELSE
	cAliasTmp := "SE2"
	dbSeek( xFilial("SE2")+ dTos( mv_par03 ) , .T. )
	While !EOF() .And. SE2->E2_FILIAL==cFilial .And. SE2->E2_VENCREA <= mv_par04
#ENDIF
	If lEnd
		@Prow()+1,0 PSay cCancel
		Exit
	EndIF
	
	IncRegua()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Nao lˆ outros fornecedores, abatimentos e provis¢rios.  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SE2->E2_FORNECE+SE2->E2_LOJA # SA2->A2_COD+SA2->A2_LOJA .or. ;
		SE2->E2_TIPO $ MVABATIM  .or. ;
		SE2->E2_SALDO = SE2->E2_VALOR
		(cAliasTmp)->(dbSkip())
		Loop
	EndIF
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se considera Titulos Provisorios.            	³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If	SE2->E2_TIPO $ MVPROVIS .and. mv_par05 == 2
		(cAliasTmp)->(dbSkip())
		Loop
	Endif		
	
	IF mv_par06 == 2 .and. !Empty(SE2->E2_FATURA) .and. Substr(SE2->E2_FATURA,1,6) != "NOTFAT"
		(cAliasTmp)->(dbSkip())
		Loop
	Endif
	
	nSavRec := SE2->( Recno() )
	
	nTotAbat :=0
	IF  SE2->E2_VENCTO >= mv_par03 .And. SE2->E2_VENCTO <= mv_par04 .and. ;
			SE2->E2_EMISSAO >= mv_par01 .and. SE2->E2_EMISSAO <= mv_par02
		
		dbSelectArea("SE5")
		dbSetOrder(4)
		dbSeek(cFilial+SE2->E2_NATUREZ+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO)
		While !Eof() .And. cFilial == SE5->E5_FILIAL .And. SE2->E2_NATUREZ == SE5->E5_NATUREZA .And.;
				SE2->E2_PREFIXO == SE5->E5_PREFIXO .And. SE2->E2_NUM == SE5->E5_NUMERO .And.;
				SE2->E2_PARCELA == SE5->E5_PARCELA .And. SE2->E2_TIPO == SE5->E5_TIPO


			dData   := SE5->E5_DATA
			dVencto := SE2->E2_VENCREA
			nAtrBai := SE5->E5_DATA - SE2->E2_VENCREA
			If Dow(SE2->E2_VENCTO)=1 .or. Dow(SE2->E2_VENCTO) = 7
				If SE5->E5_DATA > SE2->E2_VENCREA
					nAtrBai := SE5->E5_DATA - SE2->E2_VENCTO
				Else
					nAtrBai := SE5->E5_DATA - SE2->E2_VENCREA
				Endif
			Endif
			
			nCotac := 0
			nPago		:= 0
			nJuros	:= 0
			nMulta	:= 0
			nDesco	:= 0
			While !Eof() .And. cFilial == SE5->E5_FILIAL .And. SE2->E2_NATUREZ == SE5->E5_NATUREZA .And.;
				SE2->E2_PREFIXO == SE5->E5_PREFIXO .And. SE2->E2_NUM == SE5->E5_NUMERO .And.;
				SE2->E2_PARCELA == SE5->E5_PARCELA .And. SE2->E2_TIPO == SE5->E5_TIPO .And. ;
				dData == SE5->E5_DATA
				
				IF E5_TIPO $ MVRECANT+"/"+MV_CRNEG .OR. E5_TIPO $ MVPAGANT+"/"+MV_CPNEG;
					.or. E5_CLIFOR+E5_LOJA != SE2->E2_FORNECE+SE2->E2_LOJA
					dbSkip()
					Loop
				Endif
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se existe estorno para esta baixa                       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If SE5->E5_SITUACA == "C" .OR.;
				   TemBxCanc(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ)
					SE5->( dbSkip() )
					Loop
				EndIf

				cMotBx   := space(09)
				cBanco   := E5_BANCO
				cAgencia := E5_AGENCIA
				cConta   := E5_CONTA
				cHistor  := AllTrim(E5_HISTOR)
				cCheque	:= E5_NUMCHEQ

				nPos := Ascan(aMotBx, {|x| Substr(x,1,3) == Upper(SE5->E5_MOTBX) })
				If nPos > 0
					cMotBx := Substr(aMotBx[nPos],07,09)
				ElseIf E5_MOTBX == "CEC"
					cMotBx := STR0073	 //"COMP CART"
				EndIf

				IF E5_TIPODOC $ "VL/BA/CP"
					nCotac++       
					If cPaisLoc $ "MEX|BOL"
	      	            nPago += xMoeda(SE5->E5_VALOR,Val(SE5->E5_MOEDA),1,,,Iif(mv_par09==1,SE5->E5_TXMOEDA,0))         
	   	            Else
						nPago+= SE5->E5_VALOR
 					EndIf
					nJuros += SE5->E5_VLJUROS
					nMulta += SE5->E5_VLMULTA
					nDesco += SE5->E5_VLDESCO
					IF li > 58
						cabec(cTitulo,cCabec1,cCabec2,cNomeProg,cTamanho)
					Endif
					dbSelectArea( "SE2" )
					li++
			   		If cPaisLoc $ "MEX|BOL"
						@li, 01 pSay SE2->E2_PREFIXO
						@li, 05 pSay SE2->E2_NUM
						@li, 26 pSay SE2->E2_PARCELA
						@li, 28 pSay DTOC(SE2->E2_EMISSAO)
						@li, 39 pSay SE2->E2_NATUREZ
						@li, 49 pSay Transf(xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,1,,,Iif(mv_par09==1,SE2->E2_TXMOEDA,0)),Tm(SE2->E2_VALOR,14,nCasas))
						@li, 64 pSay Transf(xMoeda(SE5->E5_VALOR,Val(SE5->E5_MOEDA),1,,,Iif(mv_par09==1,SE5->E5_TXMOEDA,0)),Tm(SE5->E5_VALOR,14,nCasas))
						@li, 78 pSay SE5->E5_VLJUROS	Picture Tm(SE5->E5_VLJUROS,11,nCasas) //@E 9999,999.99
						@li, 89 pSay SE5->E5_VLMULTA	Picture Tm(SE5->E5_VLMULTA,11,nCasas) //@E 9999,999.99
						@li,100 pSay SE5->E5_VLDESCO	Picture Tm(SE5->E5_VLDESCO,11,nCasas) //@E 9999,999.99
					  	@li,112 pSay DTOC(dData)
						@li,124 pSay DTOC(dVencto)
						@li,135 pSay nAtrBai		Picture PesqPictQt("A2_MATR")
						@li,145 pSay SubStr(cBanco, 1, 4)
						@li,149 pSay SubStr(cAgencia, 1, 7)
						@li,155 pSay SubStr(cConta, 1, 6)
						dbSelectArea( "SE5" )
						If TamSX3("E5_CONTA")[1] == 10
							@li,nColMovel[1,1] pSay SUBSTR(cHistor,1,30)
							@li,nColMovel[1,2]+1 pSay Substr(cMotBx,1,12)
							@li,nColMovel[1,3]+1 pSay cCheque
							If (mv_par08==1) .And. (TamSX3("E5_HISTOR")[1] > 30)
								li++
								@li,nColMovel[1,1] pSay SUBSTR(cHistor,31,TamSX3("E5_HISTOR")[1]-30)
							EndIf
						Else
							@li,nColMovel[2,1] pSay SUBSTR(cHistor,1,20)
							@li,nColMovel[2,2]+1 pSay Substr(cMotBx,1,12)
							@li,nColMovel[2,3]+1 pSay cCheque
							If (mv_par08==1) .And. (TamSX3("E5_HISTOR")[1] > 20)
								li++
								@li,nColMovel[2,1] pSay SUBSTR(cHistor,21,TamSX3("E5_HISTOR")[1]-20)
							EndIf
						EndIf
					Else
						@li, 01 pSay SE2->E2_FILORIG
						@li,nEspacoFil + 01 pSay SE2->E2_PREFIXO
						@li,nEspacoFil + 05 pSay SE2->E2_NUM
						@li,nEspacoFil + 17 pSay SE2->E2_PARCELA
						@li,nEspacoFil + 21 pSay DTOC(SE2->E2_EMISSAO)
						@li,nEspacoFil + 35 pSay SE2->E2_NATUREZ
						@li,nEspacoFil + 46 pSay Transf(xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,1,,,Iif(mv_par09==1,SE2->E2_TXMOEDA,0)),Tm(SE2->E2_VALOR,14,nCasas))
						@li,nEspacoFil + 61 pSay SE5->E5_VALOR 	Picture Tm(SE5->E5_VALOR,14,nCasas)   		//@E 999,999,999.99
						@li,nEspacoFil + 73 pSay SE5->E5_VLJUROS	Picture Tm(SE5->E5_VLJUROS,11,nCasas)	//@E 9999,999.99
						@li,nEspacoFil + 81 pSay SE5->E5_VLMULTA	Picture Tm(SE5->E5_VLMULTA,11,nCasas)	//@E 9999,999.99
						@li,nEspacoFil + 93 pSay SE5->E5_VLDESCO	Picture Tm(SE5->E5_VLDESCO,11,nCasas)	//@E 9999,999.99
					  	@li,nEspacoFil + 106 pSay DTOC(dData)
						@li,nEspacoFil + 119 pSay DTOC(dVencto)
						@li,nEspacoFil + 131 pSay nAtrBai		Picture PesqPictQt("A2_MATR")
						@li,nEspacoFil + 140 pSay SubStr(cBanco, 1, 4)
						@li,nEspacoFil + 146 pSay SubStr(cAgencia, 1, 7) 
						#IFDEF TOP
							@li,nEspacoFil + 152 pSay SubStr(cConta, 1, 10)
							dbSelectArea( "SE5" )
							@li,nEspacoFil + nColMovel[1,1]+1 pSay SUBSTR(cHistor,1,15)
							@li,nEspacoFil + nColMovel[1,2]+1 pSay Substr(cMotBx,1,12)
							@li,nEspacoFil + nColMovel[1,3]+1 pSay cCheque
							If (mv_par08==1) .And. (Len(cHistor) > 15)
								li++
								@li,nEspacoFil + nColMovel[1,1] + 1 pSay SUBSTR(cHistor,16)
							EndIf
						#ELSE
							@li,154 pSay SubStr(cConta, 1, 6)
							dbSelectArea( "SE5" )
							If TamSX3("E5_CONTA")[1] == 10
								@li,nColMovel[1,1]+1 pSay SUBSTR(cHistor,1,30)
								@li,nColMovel[1,2]+1 pSay Substr(cMotBx,1,12)
								@li,nColMovel[1,3]+1 pSay cCheque
								If (mv_par08==1) .And. (TamSX3("E5_HISTOR")[1] > 30)
									li++
									@li,nColMovel[1,1] pSay SUBSTR(cHistor,31,TamSX3("E5_HISTOR")[1]-30)
								EndIf
							Else
								@li,nColMovel[2,1]+1 pSay SUBSTR(cHistor,1,20)
								@li,nColMovel[2,2]+1 pSay Substr(cMotBx,1,12)
								@li,nColMovel[2,3]+1 pSay cCheque
								If (mv_par08==1) .And. (TamSX3("E5_HISTOR")[1] > 20)
									li++
									@li,nColMovel[2,1] pSay SUBSTR(cHistor,21,TamSX3("E5_HISTOR")[1]-20)
								EndIf
							EndIf		
						#ENDIF				
					EndIf
				Endif
				dbSkip( )
			Enddo
			If nPago != 0 .Or. nCotac <> 0 
				nTotPgto+=nPago
				nTotJur+=nJuros
				nTotMul+=nMulta
				nTotDes+=nDesco								
				nTitPagos++
			Endif
		Enddo
	Endif
	dbSelectArea( "SE2" )
	dbSetOrder(3)
	dbGoTo( nSavRec )
	(cAliasTmp)->(dbSkip())
Enddo
/*
GESTAO - inicio */
#IFDEF TOP
	cFilAnt := cFilAtual
	DbSelectArea(cAliasTmp)
	DbCloseArea()
#ENDIF
DbSelectArea("SE2")
/* GESTAO - fim
*/
dbSetOrder(1)
Li+=2
@li,  1 pSay OemToAnsi(STR0086) //"Total de Pagamentos ......."
@li, nEspacoFil + 28 pSay nTitPagos	Picture PesqPictQt("A2_MATR")
@li, nEspacoFil + 61 pSay nTotPgto	Picture Tm(nTotPgto,14,nCasas)
@li, nEspacoFil + 73 pSay nTotJur	Picture Tm(nTotJur,11,nCasas)
@li, nEspacoFil + 81 pSay nTotMul	Picture Tm(nTotMul,11,nCasas)
@li, nEspacoFil + 93 pSay nTotDes	Picture Tm(nTotDes,11,nCasas)								
					


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao dos Pedidos Colocados             				  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCabec1 := " "
cCabec2 := " "
IF li > 50
	cabec(cTitulo,cCabec1,cCabec2,cNomeProg,cTamanho)
	@li, 00 pSay Replicate("*",220)
	li++
Else
	li+=3
EndIF
@li,1 pSay OemToAnsi(STR0087) //"PEDIDOS COLOCADOS"
li++
@li, 1 pSay Repl("-",17)
li++
cCabec1 := OemToAnsi(STR0088) //"NUMERO        DATA EMISSAO                   VALOR DO ITEM"

If lC7Fiscori
	/*
	GESTAO - inicio */
	#IFDEF TOP  
		cCabec1 := PadR(Upper(SX3->(RetTitle("C7_FISCORI"))),nEspacoFil) + cCabec1
	#ENDIF
	/* GESTATO - fim
	*/	
Endif

dbSelectArea("SC7")
SetRegua( Reccount() )

dbSetOrder(3)
@li, 1 pSay cCabec1
/*
GESTAO - inicio*/
#IFDEF TOP
	cQuery := "select R_E_C_N_O_ RECSC7 from " + RetSQLName("SC7")
	nPosAlias := FC030QFil(1,"SC7")
	cQuery += " WHERE C7_FILIAL " + aTmpFil[nPosAlias,2]
	cQuery += " and C7_FORNECE = '" + SA2->A2_COD + "'"
	cQuery += " and C7_LOJA = '" + SA2->A2_LOJA + "'"
	cQuery += " and C7_EMISSAO >= '" + Dtos(mv_par01) + "'"
	cQuery += " and C7_EMISSAO <= '" + Dtos(mv_par02) + "'"
	cQuery += " and D_E_L_E_T_ = ' '"
    cQuery += " order by C7_FILIAL,C7_FORNECE,C7_LOJA,C7_NUM"
    cQuery := ChangeQuery(cQuery)
    cAliasTmp := GetNextAlias()
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasTmp, .T., .T.)
	While !((cAliasTmp)->(Eof()))
		DbSelectArea("SC7")
		SC7->(DbGoTo((cAliasTmp)->RECSC7))
#ELSE
	cAliasTmp := "SC7"	
	dbSeek(cFilial+SA2->A2_COD+SA2->A2_LOJA)
	While !EOF() .And. SC7->C7_FILIAL==cFilial .And. SC7->C7_FORNECE+C7_LOJA = SA2->A2_COD+SA2->A2_LOJA
#ENDIF
/* GESTAO - fim
*/
	If lEnd
		@Prow()+1,0 PSay cCancel
		Exit
	EndIF
	
	IncRegua()
	
	IF SC7->C7_EMISSAO >= mv_par01 .And. SC7->C7_EMISSAO <= mv_par02
		If mv_par07 == 2 
			If (SC7->C7_QUANT - SC7->C7_QUJE) == 0
				(cAliasTmp)->(dbSkip())
				Loop
			EndIf
		EndIf
		nPedidos++
		li++
		IF li > 58
			cabec(cTitulo,cCabec1,cCabec2,cNomeProg,cTamanho)
		EndIF
		
		nValItPed := SC7->C7_TOTAL
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ponto de Entrada para manipular o valor total do item do Pedido de Compras³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ExistBlock("FN030IPC")
			nFN030IPC := Execblock("FN030IPC",.F.,.F.,{nValItPed})
			If ValType(nFN030IPC) == "N"
				nValItPed := nFN030IPC
			EndIf
		EndIf
		
		If lC7Fiscori
			/*
			GESTAO - inicio */
			#IFDEF TOP
				@li,01 PSay SC7->C7_FISCORI
			#ENDIF
			/* GESTAO - fim
			*/
			@li,nEspacoFil + 1 pSay SC7->C7_NUM
			@li,nEspacoFil + 26 pSay SC7->C7_EMISSAO
			@li,nEspacoFil + 54 pSay nValItPed Picture PesqPict("SC7","C7_TOTAL",14)			
		Else
			@li, 1 pSay SC7->C7_NUM
			@li,26 pSay SC7->C7_EMISSAO
			@li,54 pSay nValItPed Picture PesqPict("SC7","C7_TOTAL",14)
		Endif
		
		nValPed+=nValItPed
	EndIF
	(cAliasTmp)->(dbSkip())
EndDO
li+=2
IF li > 58
	cabec(cTitulo,cCabec1,cCabec2,cNomeProg,cTamanho)
EndIF
@li,01 pSay OemToAnsi(STR0089)+StrZero(nPedidos,4) //"Total de Itens ............ "
@li,nEspacoFil + 54 pSay nValPed Picture PesqPict("SC7","C7_TOTAL",14)
/*
GESTAO - inicio */
#IFDEF TOP
	DbSelectArea(cAliasTmp)
	DbCloseArea()
#ENDIF
DbSelectArea("SC7")
/* GESTAO - fim
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Faturamento                    				  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
cCabec1 := " "
cCabec2 := " "
IF li > 50
	cabec(cTitulo,cCabec1,cCabec2,cNomeProg,cTamanho)
	@li, 00 pSay Replicate("*",220)
	li++
Else
	li+=3
EndIF
@li,1 pSay OemToAnsi(Upper(STR0054)) //"FATURAMENTO"
li++
@li, 1 pSay Repl("-",11)
li++
cCabec1:=" "+OemToAnsi(STR0090) //"NUMERO         DATA EMISSAO    VALOR DA NOTA  DUPLICATA"
/*
GESTAO - inicio */
#IFDEF TOP
	If FWModeAccess("SF1",1) == "E"
		cCabec1 := PadR(Upper(SX3->(RetTitle("E2_FILORIG"))),nEspacoFil) + cCabec1
		nEspacoFil := FWSizeFilial() + 2
	Else
		nEspacoFil := 0
	Endif  
#ENDIF
/* GESTATO - fim
*/	

dbSelectArea("SF1")
SetRegua( Reccount() )
dbSetOrder(2)
@li, 1 pSay cCabec1
nTotalNf := 0
/*
GESTAO - inicio*/
#IFDEF TOP
	cQuery := "select R_E_C_N_O_ RECSF1 from " + RetSQLName("SF1")
	nPosAlias := FC030QFil(1,"SF1")
	cQuery += " WHERE F1_FILIAL " + aTmpFil[nPosAlias,2]
	cQuery += " and F1_FORNECE = '" + SA2->A2_COD + "'"
	cQuery += " and F1_LOJA = '" + SA2->A2_LOJA + "'"
	cQuery += " and F1_EMISSAO >= '" + Dtos(mv_par01) + "'"
	cQuery += " and F1_EMISSAO <= '" + Dtos(mv_par02) + "'"
	cQuery += " and F1_TIPO not in ('B','D')"
	cQuery += " and D_E_L_E_T_ = ' '"
    cQuery += " order by F1_FORNECE,F1_LOJA,F1_DOC"
    cQuery := ChangeQuery(cQuery)
    cAliasTmp := GetNextAlias()
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasTmp, .T., .T.)
	cFilAtual := cFilAnt
	While !((cAliasTmp)->(Eof()))
		DbSelectArea("SF1")
		SF1->(DbGoTo((cAliasTmp)->RECSF1))
#ELSE
	cAliasTmp := "SF1"
	dbSeek(cFilial+SA2->A2_COD+SA2->A2_LOJA)
	While !EOF() .And. SF1->F1_FILIAL==cFilial .And. SF1->F1_FORNECE+F1_LOJA == SA2->A2_COD+SA2->A2_LOJA
#ENDIF
/* GESTAO - fim
*/	
	If lEnd
		@Prow()+1,0 PSay cCancel
		Exit
	EndIF
	
	IncRegua()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Notas Canceladas   --  SHELL                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	#IFDEF SHELL
		IF F1_CANCEL == "S"
			dbSkip()
			Loop
		EndIf
	#ENDIF
	
	IF SF1->F1_EMISSAO >= mv_par01 .And. SF1->F1_EMISSAO <= mv_par02 .And. !(SF1->F1_TIPO $ "BD")
		nNotas++
		IF li > 58
			cabec(cTitulo,cCabec1,cCabec2,cNomeProg,cTamanho)
		EndIF
		li++
		/* GESTAO */
		#IFDEF TOP
			If nEspacoFil > 0
				@li,01 PSay SF1->F1_FILIAL
			Endif
		#ENDIF
		@li, nEspacoFil + 1 pSay SF1->F1_DOC
		@li,nEspacoFil + 25 pSay SF1->F1_EMISSAO
		nTotNota:= SF1->F1_VALMERC+SF1->F1_FRETE+SF1->F1_VALIPI+SF1->F1_ICMSRET+SF1->F1_DESPESA-SF1->F1_DESCONT
		@li,nEspacoFil + 38 pSay nTotNota     Picture tm(nTotNota,14,nCasas)
		@li,nEspacoFil + 63 pSay SF1->F1_DUPL
		nTotalNF += nTotNota
	EndIF
	(cAliasTmp)->(dbSkip())
EndDO
li+=2
IF li > 58
	cabec(cTitulo,cCabec1,cCabec2,cNomeProg,cTamanho)
EndIF

@li, 1 pSay OemToAnsi(STR0091)+StrZero(nNotas,4) //"Total de Notas.: "
@li,nEspacoFil + 38 pSay nTotalNF Picture Tm( nTotalNF, 14,nCasas )
/*
GESTAO - inicio */
#IFDEF TOP
	DbSelectArea(cAliasTmp)
	DbCloseArea()
#ENDIF
DbSelectArea("SF1")
/* GESTAO - fim
*/
If cPaisLoc != "BRA"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao da carteira de cheques              				  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
	
	cCabec1 := " "
	cCabec2 := " "
	IF li > 50
		cabec(cTitulo,cCabec1,cCabec2,cNomeProg,cTamanho)
		@li, 00 pSay Replicate("*",220)
		li++
	Else
		li+=3
	EndIF
	@li,1 pSay OemToAnsi(STR0092) //"CARTEIRA DE CHEQUES"
	li++
	@li, 1 pSay Repl("-",11)
	li++
	     
	cDescMoeda:= ALLTRIM( UPPER(GetMV("MV_MOEDAP1")) )
	If Len(cDescMoeda)>8
		cDescMoeda:=Subs(cDescMoeda,1,8)	
	EndIf
	cDescMoeda := PADR( "(" + cDescMoeda + ")", 10, " " )
	
	
	cCabec1:=OemToAnsi(STR0093) + cDescMoeda + OemToAnsi(STR0119)  //"SITUACION NUMERO     FECHA EMISION            VALOR MONEDA      VALOR  FECHA VENCTO BANCO AGENCIA CUENTA     FECHA DEPOSITO ORDEN DE PAGO"
	/*
	GESTAO - inicio */
	#IFDEF TOP
		cCabec1 := PadR(Upper(SX3->(RetTitle("E2_FILORIG"))),nEspacoFil) + cCabec1
		nEspacoFil := FWSizeFilial() + 2
	#ENDIF
/* GESTATO - fim
*/	
	li++
	
	dbSelectArea("SE2")
	
	SetRegua( Reccount() )
	
	li++
	@li, 1 pSay cCabec1
	
	aTotal6	:=	{0.00,0,0.00,0}
	SE2->(dbSetOrder(6))
#IFDEF TOP
	cQuery := "select R_E_C_N_O_ RECSE2 from " + RetSQLName("SE2")
	nPosAlias := FC030QFil(1,"SE2")
	cQuery += " WHERE E2_FILIAL " + aTmpFil[nPosAlias,2]
	cQuery += " and E2_FORNECE = '" + SA2->A2_COD + "'"
	cQuery += " and E2_LOJA = '" + SA2->A2_LOJA + "'"
	cQuery += " and E2_VENCTO >= '" + Dtos(mv_par03) + "'"
	cQuery += " and E2_VENCTO <= '" + Dtos(mv_par04) + "'"
	cQuery += " and E2_EMISSAO >= '" + Dtos(mv_par01) + "'"
	cQuery += " and E2_EMISSAO <= '" + Dtos(mv_par02) + "'"
	cQuery += " and D_E_L_E_T_ = ' '"
    cQuery += " order by E2_VENCREA,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO"
    cQuery := ChangeQuery(cQuery)
    cAliasTmp := GetNextAlias()
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasTmp, .T., .T.)
	cFilAtual := cFilAnt
	While !((cAliasTmp)->(Eof()))
		DbSelectArea("SE2")
		SE2->(DbGoTo((cAliasTmp)->RECSE2))
		cFilAnt := SE2->E2_FILORIG
#ELSE
	cAliasTmp := "SE2"
	dbSeek( xFilial("SE2")+ SA2->A2_COD + SA2->A2_LOJA)
	While !Eof() .And. SE2->(E2_FILIAL + E2_FORNECE + E2_LOJA) == cFilial + SA2->(A2_COD + A2_LOJA )
#ENDIF
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Filtra os nao cheques e os que estao fora dos parametros|
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SE2->E2_VENCTO<=mv_par03 .or. SE2->E2_VENCTO>=mv_par04 .or. ; 		
			SE2->E2_EMISSAO<=mv_par01 .or. SE2->E2_EMISSAO>=mv_par02
         	(cAliasTmp)->(dbSkip())
			Loop
		EndIF
		If SE2->E2_TIPO $ IIF(Type('MVCHEQUES')=='C',MVCHEQUES,MVCHEQUE)
        	If SE2->E2_SALDO>0.AND.EMPTY(SE2->E2_BAIXA)
				aTotal6[1]+=	Moeda(SE2->E2_SALDO,1,"P")
				aTotal6[2]+=	1
				cSituac	:= STR0094 //"No Dep."
			Else
				aTotal6[3]+=	Moeda(SE2->E2_VALOR,1,"P")
				aTotal6[4]+=	1
				cSituac	:= STR0095 //"Dep."
			Endif
	
			If lEnd
				@Prow()+1,0 PSay cCancel
				Exit
			EndIF
			
			IncRegua()
			
			nNotas++
			IF li > 58
				cabec(cTitulo,cCabec1,cCabec2,cNomeProg,cTamanho)
			EndIF
			li++
			#IFDEF TOP
				@li,001 PSay SE2->E2_FILORIG
			#ENDIF
			@li,nEspacoFil + 001 pSay cSituac
			@li,nEspacoFil + 011 pSay SE2->E2_NUM
			@li,nEspacoFil + 035 pSay SE2->E2_EMISSAO
			@li,nEspacoFil + 051 pSay SE2->E2_VALOR  Picture Tm( VALOR, 14, nCasas )
			@li,nEspacoFil + 070 pSay STRZERO(E2_MOEDA,2)
			@li,nEspacoFil + 079 pSay MOEDA(SE2->E2_VALOR,1,"P")	Picture Tm( SE2->E2_VALOR, 14,nCasas)
			@li,nEspacoFil + 104 pSay SE2->E2_VENCTO
			@li,nEspacoFil + 117 pSay SE2->E2_BCOCHQ
			@li,nEspacoFil + 123 pSay SE2->E2_AGECHQ 
			@li,nEspacoFil + 131 pSay SE2->E2_CTACHQ
			@li,nEspacoFil + 142 pSay SE2->E2_BAIXA
			@li,nEspacoFil + 157 pSay SE2->E2_ORDPAGO
		Endif	
		(cAliasTmp)->(dbSkip())
	Enddo
	li+=2
	@li,001 Say STR0096 + Str(aTotal6[2],5) 											//"Cheques en abierto "
	@li,nEspacoFil + 026 Say STR0097	+ Str(aTotal6[4],5)  							//"Cheques dep. "
	@li,nEspacoFil + 051 Say STR0098	+ Transf(aTotal6[1],Tm(aTotal6[1],15,nCasas)) 	//"Total Chqs en abierto : "
	@li,nEspacoFil + 079 Say STR0099 + Transf(aTotal6[3],Tm(aTotal6[3],15,nCasas)) 		//"Total Chqs dep. : "
	IF li != 80
		li++
		roda(cbcont,cbtxt,"G")
	EndIF
	/*
	GESTAO - inicio */
	#IFDEF TOP
		cFilAnt := cFilAtual
		DbSelectArea(cAliasTmp)
		DbCloseArea()
	#ENDIF
	DbSelectArea("SE2")
/* GESTAO - fim
*/
EndIF

IF li != 80
	li++
	roda(cbcont,cbtxt,"G")
EndIF

If aReturn[5] = 1
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif
MS_FLUSH()
/*
GESTAO - inicio */
FC030QFil(2)
/*
GESTAO - fim
*/
Return (.T.)
