#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  MT450ABT º Autor ³ RAFAEL ALMEIDA - SIGACORP º Data ³14/03/17º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Adicionar botões na tela de analise de crédito cliente     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA450A - Analise Credito Cliente                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MT450ABT()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aButtons := {}



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Iniciando o Processamento - Validação                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aButtons, {"Detalhe Ped.", {||  U_PedCPag() }, "Detalhe Ped." ,"Detalhe Ped." })


Return aButtons


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  MT450ABT º Autor ³ RAFAEL ALMEIDA - SIGACORP º Data ³14/03/17º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Criando o alerta para ser exibido na tela.                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA450A - Analise Credito Cliente                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PedCPag()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aAreaSC5 := GetArea()
Local _cNumSc5 := ""
Local _cCodSE4 := ""
Local _cDscSE4 := ""
Local _nValFat := 0
Local cQuery := " "
Local _aImp := {}
Local nALIQICM
Local nBaseIcm
Local nValIcm
Local nALIQPis
Local nBasePis
Local nValPis
Local nALIQCof
Local nBaseCof
Local nValCof
Local nBaseSol
Local nValSol
Local nValIPI
Local nTotIt
Local nTotalPrc     := 0
Local nTotalIPI     := 0
Local nTotalBIC     := 0
Local nTotalICM     := 0
Local nTotalPis		:= 0
Local nTotalCof		:= 0
Local nTotalBSo     := 0
Local nTotalSol     := 0
Local nTotalPed     := 0
Local nTotalDesc    := 0
Local _aDados       := {}      
Local nItem          := 0
Local oDlgR
Local oLbx
Local cTitulo := "Cadastro de Bancos"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Iniciando o Processamento - Validação                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//_cNumSc5 := C5_NUM
//_cCodSE4 := GetAdvFVal("SC5", "C5_CONDPAG",xFilial("SC5")+_cNumSc5,1)
//_cDscSE4 := GetAdvFVal("SE4", "E4_DESCRI",xFilial("SE4")+_cCodSE4,1)

cQry := " "
cQry += " 	SELECT "
cQry += " 	     DISTINCT C5_NUM	"
cQry += " 	FROM "+ RETSQLNAME("SC9")+" C9 "
cQry += " 	INNER JOIN "+ RETSQLNAME("SC5")+" C5 "
cQry += " 		ON C5_FILIAL = C9_FILIAL AND C5_NUM = C9_PEDIDO AND C5.D_E_L_E_T_ = ''	"
cQry += " 		AND  C5_NOTA = '' AND C5_CLIENTE = C9_CLIENTE AND C5_LOJACLI = C9_LOJA	"
cQry += " 	WHERE C9.D_E_L_E_T_ = ''	"
cQry += " 		AND ( C9_BLCRED NOT IN ('10','') OR C9_BLEST  NOT IN ('10','') OR C9_BLWMS  IN     ('03'))	"
cQry += " 		AND C9_CLIENTE = '"+ Alltrim(SA1->A1_COD) +"'	"
cQry += " 		AND C9_LOJA = '"+ Alltrim(SA1->A1_LOJA) +"'	"
cQry += " 	ORDER BY 1	"
cQry:= ChangeQuery(cQry)
dbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQry) , "TOC" , .T. , .F.)

DBSelectArea("TOC")
TOC->(DbGoTop())  

While !TOC->(Eof())
	
	cQuery := " "
	cQuery += " 	SELECT "
	cQuery += " 	     C5_NUM	"
	cQuery += " 		,C5_CONDPAG	"
	cQuery += " 		,C9_ITEM    "
	cQuery += " 		,C9_PRODUTO "
	cQuery += " 		,C6_TES     "
	cQuery += " 		,C9_QTDLIB  "
	cQuery += " 		,C6_PRUNIT  "
	cQuery += " 		,C9_PRCVEN  "  
	cQuery += " 		,(C9_QTDLIB*C9_PRCVEN) C9_TOTAL	"
	cQuery += " 	FROM "+ RETSQLNAME("SC9")+" C9 "
	cQuery += " 	INNER JOIN "+ RETSQLNAME("SC5")+" C5 "
	cQuery += " 		ON C5_FILIAL = C9_FILIAL AND C5_NUM = C9_PEDIDO AND C5.D_E_L_E_T_ = ''	"
	cQuery += " 		AND  C5_NOTA = '' AND C5_CLIENTE = C9_CLIENTE AND C5_LOJACLI = C9_LOJA	"
	cQuery += " 	INNER JOIN "+ RETSQLNAME("SC6")+" C6 "
	cQuery += " 		ON C6_FILIAL = C9_FILIAL AND C6_NUM = C9_PEDIDO AND C6.D_E_L_E_T_ = ''  "
	cQuery += " 		AND  C6_PRODUTO = C9_PRODUTO AND C6_ITEM = C9_ITEM AND C6_CLI = C9_CLIENTE AND C6_LOJA = C9_LOJA "
	cQuery += " 	WHERE C9.D_E_L_E_T_ = ''	"
	cQuery += " 		AND ( C9_BLCRED NOT IN ('10','') OR C9_BLEST  NOT IN ('10','') OR C9_BLWMS  IN     ('03'))	"
	cQuery += " 		AND C9_CLIENTE = '"+ Alltrim(SA1->A1_COD) +"'	"
	cQuery += " 		AND C9_LOJA = '"+ Alltrim(SA1->A1_LOJA) +"'	"   
	cQuery += " 		AND C9_PEDIDO = '"+ Alltrim(TOC->C5_NUM) +"'	"   	
	cQuery += " 		ORDER BY 3 "   			
	cQuery:= ChangeQuery(cQuery)
	dbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , "DOC" , .T. , .F.)

	nValSubSt:= 0
	nItem    := 0	
	
	DBSelectArea("DOC")
	DOC->(DbGoTop())
	While !DOC->(Eof()) .And. DOC->C5_NUM = TOC->C5_NUM

	nItem ++
	_cDscSE4 := GetAdvFVal("SE4", "E4_DESCRI",xFilial("SE4")+DOC->C5_CONDPAG,1)

/*
	MaFisSave()
	MaFisEnd()
	MaFisIni(SA1->A1_COD,;     // 1-Codigo Cliente/Fornecedor
			 SA1->A1_LOJA,;    // 2-Loja do Cliente/Fornecedor
			 "C",;             // 3-C:Cliente , F:Fornecedor
			 "N",;             // 4-Tipo da NF
			 SA1->A1_TIPO,; // 5-Tipo do Cliente/Fornecedor
			 MaFisRelImp("MTR700",{"SC5","SC6"}),;     // 6-Relacao de Impostos que suportados no arquivo
			 Nil,;             // 7-Tipo de complemento
			 Nil,;             // 8-Permite Incluir Impostos no Rodape .T./.F.
			 "SB1",;             // 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
			 "MATA461")        // 10-Nome da rotina que esta utilizando a funcao     
		
		MaFisAdd(DOC->C9_PRODUTO,; // 1-Codigo do Produto ( Obrigatorio )
	   		 	 DOC->C6_TES,;         // 2-Codigo do TES ( Opcional )
	   		 	 DOC->C9_QTDLIB,;       // 3-Quantidade ( Obrigatorio )
	   		 	 DOC->C6_PRUNIT,;      // 4-Preco Unitario ( Obrigatorio )
	   		 	 0,;                   // 5-Valor do Desconto ( Opcional )
	   		 	 "",;                  // 6-Numero da NF Original ( Devolucao/Benef )
	   		 	 "",;                  // 7-Serie da NF Original ( Devolucao/Benef )
	   		 	 0,;                   // 8-RecNo da NF Original no arq SD1/SD2
	   		 	 0,;                   // 9-Valor do Frete do Item ( Opcional )
	   		 	 0,;                   // 10-Valor da Despesa do item ( Opcional )
	   		 	 0,;                   // 11-Valor do Seguro do item ( Opcional )
	   		 	 0,;                   // 12-Valor do Frete Autonomo ( Opcional )
	   		 	 DOC->C9_PRCVEN,;     // 13-Valor da Mercadoria ( Obrigatorio )
	   		 	 0,;                   // 14-Valor da Embalagem ( Opiconal )
	   		 	 0,;                   // 15-RecNo do SB1
	   		 	 0)                    // 16-RecNo do SF4
		
		//icms
		nALIQICM     := MaFisRet(1,"IT_ALIQICM")
		nBaseIcm     := MaFisRet(1,"IT_BASEICM")
		nValIcm      := MaFisRet(1,"IT_VALICM")   
		
		//pis
		nALIQPis      := MaFisRet(1,"IT_BASEPIS") //Base de calculo do PIS
		nBasePis      := MaFisRet(1,"IT_ALIQPIS") //Aliquota de calculo do PIS
		nValPis      := MaFisRet(1,"IT_VALPIS") //Valor do PIS		
		
		//cofins
		nALIQCof      := MaFisRet(1,"IT_BASECOF") //Base de calculo do COFINS
		nBaseCof      := MaFisRet(1,"IT_ALIQCOF") //Aliquota de calculo do COFINS
		nValCof       := MaFisRet(1,"IT_VALCOF") //Valor do COFINS
		
		// ICM Substituicao
		nBaseSol     := MaFisRet(1,"IT_BASESOL")
		nValSol      := MaFisRet(1,"IT_VALSOL")
  */		
		//calcula o IPI
		nValIPI      := (DOC->C9_TOTAL * (Posicione("SB1",1,xFilial("SB1")+DOC->C9_PRODUTO,"B1_IPI") / 100))
		
		//soma o total do item
		nTotIt       := DOC->C9_TOTAL + nValIPI
		
/*
		//soma os totais
		nTotalPrc    += DOC->C9_PRCVEN
		nTotalIPI    += nValIPI
		nTotalBIC    += nBaseIcm
		nTotalICM    += nValIcm
		nTotalPis    += nValPis		
		nTotalCof    += nValCof
		nTotalBSo    += nBaseSol
		nTotalSol    += nValSol
		nTotalPed    += nTotIt + nValSol  + nValIcm   + nValPis + nValCof
		nTotalDesc   += 0
*/
		nTotalPed    += Round(nTotIt,2)
						
//		MaFisEnd()
		nValIPI := 0
		nTotIt  := 0
		
		DOC->(DbSkip())
	EndDo
	DOC->( DBCloseArea())

	Aadd(_aDados ,{TOC->C5_NUM,nTotalPed,_cDscSE4 }) 
	nTotalPed := 0
		
	TOC->(DbSkip())
EndDo
TOC->( DBCloseArea())

/*MsgInfo("Pedido: "+_cNumSc5 + Chr(13) + Chr(10) + ;
"Cond. Pagamento: "+_cCodSE4 +" - "+_cDscSE4 + Chr(13) + Chr(10) + ;
"Valor Faturado R$: "+TRANSFORM(_nValFat, "@E 999,999,999.99"),"Detalhamento")
*/

// Se não houver dados no vetor, avisar usuário e abandonar rotina.
If Len( _aDados ) == 0
Aviso( cTitulo, "Não existe dados a consultar", {"Ok"} )
Return
Endif    

// Monta a tela para usuário visualizar consulta.
DEFINE MSDIALOG oDlgR TITLE cTitulo FROM 0,0 TO 240,500 PIXEL
// Primeira opção para montar o listbox.
@ 10,10 LISTBOX oLbx FIELDS HEADER "Pedido", "Total NF", "Cond. Pag" SIZE 230,95 OF oDlgR PIXEL
oLbx:SetArray( _aDados )
oLbx:bLine := {|| {_aDados[oLbx:nAt,1],;
				   _aDados[oLbx:nAt,2],;
				   _aDados[oLbx:nAt,3]}}

// Segunda opção para monta o listbox
/*
oLbx :=
TWBrowse():New(10,10,230,95,,aCabecalho,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oLbx:SetArray( aVetor )
oLbx:bLine := {|| aEval(aVetor[oLbx:nAt],{|z,w| aVetor[oLbx:nAt,w] } ) }
*/
DEFINE SBUTTON FROM 107,213 TYPE 1 ACTION oDlgR:End() ENABLE OF oDlgR
ACTIVATE MSDIALOG oDlgR CENTER

RestArea(aAreaSC5)

Return()