#INCLUDE "rwmake.ch"

User Function DUE001A
Local j:= 0
Local i := 0 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CBTXT,CBCONT,NORDEM,ALFA,Z,M")
SetPrvt("TAMANHO,LIMITE,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("CNATUREZA,ARETURN,NOMEPROG,CPERG,NLASTKEY,LCONTINUA")
SetPrvt("NLIN,WNREL,NTAMNF,CSTRING,CPEDANT,NLININI")
SetPrvt("XNUM_NF,XSERIE,XEMISSAO,XTOT_FAT,XLOJA,XFRETE")
SetPrvt("XSEGURO,XBASE_ICMS,XBASE_IPI,XVALOR_ICMS,XICMS_RET,XVALOR_IPI")
SetPrvt("XVALOR_MERC,XNUM_DUPLIC,XCOND_PAG,XPBRUTO,XPLIQUI,XTIPO")
SetPrvt("XESPECIE,XVOLUME,CPEDATU,CITEMATU,XPED_VEND,XITEM_PED")
SetPrvt("XNUM_NFDV,XPREF_DV,XICMS,XCOD_PRO,XQTD_PRO,ZQTD_PRO,XPRE_UNI")
SetPrvt("XPRE_TAB,XIPI,XVAL_IPI,XDESC,XVAL_DESC,XVAL_MERC")
SetPrvt("XTES,XCF,XICMSOL,XICM_PROD,XPESO_PRO,XPESO_UNIT")
SetPrvt("XDESCRICAO,XUNID_PRO,ZUNID_PRO,XCOD_TRIB,XMEN_TRIB,XCOD_FIS,XCLAS_FIS")
SetPrvt("XMEN_POS,XISS,XTIPO_PRO,XLUCRO,XCLFISCAL,XPESO_LIQ,WPESO_BRU")
SetPrvt("I,NPELEM,_CLASFIS,NPTESTE,],XPED")
SetPrvt("XPESO_BRUTO,XP_LIQ_PED,XCLIENTE,XTIPO_CLI,XCOD_MENS,XMENSAGEM,XREDESP")
SetPrvt("XTPFRETE,XCONDPAG,XCOD_VEND,XDESC_NF,XDESC_PAG,XPED_CLI")
SetPrvt("XDESC_PRO,J,XCOD_CLI,XNOME_CLI,XEND_CLI,XBAIRRO")
SetPrvt("XCEP_CLI,XCOB_CLI,XREC_CLI,XMUN_CLI,XEST_CLI,XCGC_CLI")
SetPrvt("XINSC_CLI,XTRAN_CLI,XTEL_CLI,XFAX_CLI,XSUFRAMA,XCALCSUF")
SetPrvt("ZFRANCA,XVENDEDOR,XBSICMRET,XNOME_TRANSP,XEND_TRANSP,XMUN_TRANSP")
SetPrvt("XEST_TRANSP,XVIA_TRANSP,XCGC_TRANSP,XTEL_TRANSP,XPARC_DUP,XVENC_DUP")
SetPrvt("XVALOR_DUP,XDUPLICATAS,XNATUREZA,XFORNECE,XNFORI,XPEDIDO")
SetPrvt("XPESOPROD,XFAX,NOPC,CCOR,NTAMDET,XB_ICMS_SOL")
SetPrvt("XV_ICMS_SOL,NCONT,NCOL,NTAMOBS,NAJUSTE,BB,XSAIDA")

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦  DUE001  ¦ Autor ¦   Clovis Knopp        ¦ Data ¦ 22/06/00 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Nota Fiscal de Saida                                       ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Especifico para Clientes Microsiga                         ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦          ¦ Criar Campos:C5_TEXTO1 C 03, C5_TEXTO2 C 03, C5_TEXTO3 C 03¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
cPerg := "DUE001    "
aRegistros := {}
AADD(aRegistros,{cPerg,"01","Da Nota Fiscal     ","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
AADD(aRegistros,{cPerg,"02","Ate Nota Fiscal    ","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","",""})
AADD(aRegistros,{cPerg,"03","Da Serie           ","mv_ch3","C",03,0,0,"G","","mv_par03","","","","","","","","","","","","","","",""})

dbSelectArea("SX1")
dbSeek(cPerg)
If !Found()
	dbSeek(cPerg)
	While SX1->X1_GRUPO==cPerg.and.!Eof()
		Reclock("SX1",.f.)
		dbDelete()
		MsUnlock("SX1")
		dbSkip()
	End
	For i:=1 to Len(aRegistros)
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			FieldPut(j,aRegistros[i,j])
		Next
		MsUnlock("SX1")
	Next
Endif

//+--------------------------------------------------------------+
//¦ Define Variaveis Ambientais                                  ¦
//+--------------------------------------------------------------+
//+--------------------------------------------------------------+
//¦ Variaveis utilizadas para parametros                         ¦
//¦ mv_par01             // Da Nota Fiscal                       ¦
//¦ mv_par02             // Ate a Nota Fiscal                    ¦
//¦ mv_par03             // Da Serie                             ¦
//+--------------------------------------------------------------+
CbTxt:=""
CbCont:=""
nOrdem :=0
Alfa := 0
Z:=0
M:=0
tamanho:="G"
limite:=220
titulo :=PADC("Nota Fiscal - Vinhos Duelo Ltda.                ",74)
cDesc1 :=PADC("Este programa ira emitir a Nota Fiscal de Saida",74)
cDesc2 :=""
cDesc3 :=""
cNatureza:=""
aReturn := { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog:="DUE001A"
cPerg:="DUE001    "
nLastKey:= 0
lContinua := .T.
nLin:=0
wnrel    := "DUE001A"

//+-----------------------------------------------------------+
//¦ Tamanho do Formulario de Nota Fiscal (em Linhas)          ¦
//+-----------------------------------------------------------+

nTamNf:=72     // Apenas Informativo

//+-------------------------------------------------------------------------+
//¦ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ¦
//+-------------------------------------------------------------------------+

Pergunte(cPerg,.F.)               // Pergunta no SX1

cString:="SF2"

//+--------------------------------------------------------------+
//¦ Envia controle para a funcao SETPRINT                        ¦
//+--------------------------------------------------------------+

wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.)

If nLastKey == 27
	Return
Endif

//+--------------------------------------------------------------+
//¦ Verifica Posicao do Formulario na Impressora                 ¦
//+--------------------------------------------------------------+
SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

setprc(0,0)
@ prow(),000 PSAY char(15)+""

//+--------------------------------------------------------------+
//¦                                                              ¦
//¦ Inicio do Processamento da Nota Fiscal                       ¦
//¦                                                              ¦
//+--------------------------------------------------------------+
RptStatus({|| Imp_Nota()})
Return

Static Function Imp_Nota
Local I := 0

dbSelectArea("SF2")                // * Cabecalho da Nota Fiscal Saida
dbSetOrder(1)
dbSeek(xFilial("SF2")+mv_par01+mv_par03,.t.)

dbSelectArea("SD2")                // * Itens de Venda da Nota Fiscal
dbSetOrder(3)
dbSeek(xFilial("SD2")+mv_par01+mv_par03,.T.)
cPedant := SD2->D2_PEDIDO

//+-----------------------------------------------------------+
//¦ Inicializa  regua de impressao                            ¦
//+-----------------------------------------------------------+
SetRegua(Val(mv_par02)-Val(mv_par01))

dbSelectArea("SF2")
While !eof() .and. SF2->F2_DOC    <= mv_par02 .and. lContinua .and. SF2->F2_FILIAL ==  xFilial("SF2")
	
	If SF2->F2_SERIE #mv_par03    // Se a Serie do Arquivo for Diferente
		dbSelectArea("SF2")
		DbSkip()                    // do Parametro Informado !!!
		Loop
	Endif
	
	IF lAbortPrint
		@ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
		lContinua := .F.
		Exit
	Endif
	
	nLinIni:=nLin                         // Linha Inicial da Impressao
	
	//+--------------------------------------------------------------+
	//¦ Inicio de Levantamento dos Dados da Nota Fiscal              ¦
	//+--------------------------------------------------------------+
	
	// * Cabecalho da Nota Fiscal
	
	xCONDPAG    := ""
	xTIPO       := SF2->F2_TIPO            // Tipo dA nf
	xNUM_NF     := SF2->F2_DOC             // Numero
	xSERIE      := SF2->F2_SERIE           // Serie
	xEMISSAO    := SF2->F2_EMISSAO         // Data de Emissao
	xTOT_FAT    := IIF(xTIPO=="I".OR.XTIPO=="P",0.00,SF2->F2_VALBRUT)          // Valor Total da Fatura
	
	IF xTOT_FAT == 0 .and. (xTipo # "I" .AND. XTIPO # "P")
		xTOT_FAT := SF2->F2_VALMERC+SF2->F2_VALIPI+SF2->F2_SEGURO+SF2->F2_FRETE //alterado para não duplicar na nota
	ENDIF
	
	xCOD_CLI    := SF2->F2_CLIENTE         // Codigo do Cliente
	xCLIENTE    := SF2->F2_CLIENTE
	xLOJA       := SF2->F2_LOJA            // Loja do Cliente
	xFRETE      := SF2->F2_FRETE           // Frete
	xSEGURO     := SF2->F2_SEGURO          // Seguro
	xBASE_ICMS  := SF2->F2_BASEICM         // Base   do ICMS
	xBASE_IPI   := SF2->F2_BASEIPI         // Base   do IPI
	
	xVALOR_ICMS := IIF(xTIPO=="I",SF2->F2_VALMERC,SF2->F2_VALICM)          // Valor  do ICMS
	
	xICMS_RET   := SF2->F2_ICMSRET         // Valor  do ICMS Retido
	xBSICMRET   := SF2->F2_BRICMS          // Valor Base do ICMS Retido - Kuroda 19/02/2002
	
	xVALOR_IPI  := IIF(xTIPO=="P",SF2->F2_VALMERC,SF2->F2_VALIPI)          // Valor  do IPI
	xVALOR_MERC := IIF(xTIPO=="I".OR.xTIPO=="P",0,SF2->F2_VALMERC)         // Valor  da Mercadoria
	
	xDESPESA    := SF2->F2_DESPESA         // Despesas Acessorias
	xNUM_DUPLIC := SF2->F2_DUPL            // Numero da Duplicata
	xCOND_PAG   := SF2->F2_COND            // Condicao de Pagamento
	xPESO_BRU   := 0.00                    // Peso Bruto
	xPESO_LIQ   := SF2->F2_PLIQUI          // Peso Liquido
	xTOT_QTDVOL := 0
	
	dbSelectArea("SD2")                   // * Itens de Venda da N.F.
	dbSetOrder(3)
	dbSeek(xFilial("SD2")+xNUM_NF+xSERIE)
	
	cPedAtu     := SD2->D2_PEDIDO
	cItemAtu    := SD2->D2_ITEMPV
	
	xPED_VEND := {}                         // Numero do Pedido de Venda
	xITEM_PED := {}                         // Numero do Item do Pedido de Venda
	xNUM_NFDV := {}                         // nUMERO QUANDO HOUVER DEVOLUCAO
	xPREF_DV  := {}                         // Serie  quando houver devolucao
	xICMS     := {}                         // Porcentagem do ICMS
	xCOD_PRO  := {}                         // Codigo  do Produto
	xQTD_PRO  := {}                         // Peso/Quantidade do Produto
	zQTD_PRO  := {}                         // Peso/Quantidade na segunda UM
	xPRE_UNI  := {}                         // Preco Unitario de Venda
	xPRE_TAB  := {}                         // Preco Unitario de Tabela
	xIPI      := {}                         // Porcentagem do IPI
	xVAL_IPI  := {}                         // Valor do IPI
	xDESC     := {}                         // Desconto por Item
	xVAL_DESC := {}                         // Valor do Desconto
	xVAL_MERC := {}                         // Valor da Mercadoria
	xTES      := {}                         // TES
	xCF       := {}                         // Classificacao quanto natureza da Operacao
	xICMSOL   := {}                         // Base do ICMS Solidario
	xICM_PROD := {}                         // ICMS do Produto
	xDESCRICAO:= {}                         // Descricao do Produto
	zUNID_PRO := {}
	xUNID_PRO := {}                           // Unidade do Produto
	xCOD_TRIB := {}                           // Codigo de Tributacao
	xMEN_TRIB := {}                           // Mensagens de Tributacao
	xCOD_FIS  := {}                           // Cogigo Fiscal
	xCLAS_FIS := {}                           // Classificacao Fiscal
	xMEN_POS  := {}                           // Mensagem da Posicao IPI
	xISS      := {}                           // Aliquota de ISS
	xTIPO_PRO := {}                           // Tipo do Produto
	xLUCRO    := {}                           // Margem de Lucro p/ ICMS Solidario
	xCLFISCAL :={}
	
	while !eof() .and. SD2->D2_DOC == xNUM_NF .and. SD2->D2_SERIE == xSERIE
		
		If SD2->D2_SERIE # mv_par03
			
			dbSelectArea("SD2")
			DbSkip()
			Loop
			
		Endif
		
		AADD(xPED_VEND ,SD2->D2_PEDIDO)
		AADD(xITEM_PED ,SD2->D2_ITEMPV)
		AADD(xNUM_NFDV ,IIF(Empty(SD2->D2_NFORI).OR.SD2->D2_NFORI=="999999","",SD2->D2_NFORI))
		AADD(xPREF_DV  ,IIF(Empty(SD2->D2_NFORI).OR.SD2->D2_NFORI=="999999","",SD2->D2_SERIORI))
		AADD(xICMS     ,IIf(Empty(SD2->D2_PICM),0,SD2->D2_PICM))
		AADD(xCOD_PRO  ,SD2->D2_COD)
		AADD(xQTD_PRO  ,SD2->D2_QUANT)     // Guarda as quant. da NF
		AADD(zQTD_PRO  ,SD2->D2_QTSEGUM)   // Guarda as quant. da NF SEGUNDA UNID.MED.
		AADD(xPRE_UNI  ,SD2->D2_PRCVEN)
		AADD(xPRE_TAB  ,SD2->D2_PRUNIT)
		AADD(xIPI      ,IIF(Empty(SD2->D2_IPI),0,SD2->D2_IPI))
		AADD(xVAL_IPI  ,SD2->D2_VALIPI)
		AADD(xDESC     ,SD2->D2_DESC)
		AADD(xVAL_MERC ,SD2->D2_TOTAL)
		AADD(xTES      ,SD2->D2_TES ) 
		AADD(xCF       ,SD2->D2_CF)
		AADD(xICM_PROD ,IIf(Empty(SD2->D2_PICM),0,SD2->D2_PICM))
		AADD(xCOD_FIS  ,SD2->D2_CLASFIS)
		
		dbSelectArea("SB1")                     // * Desc. Generica do Produto
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+SD2->D2_COD)
		
		AADD(xUNID_PRO ,SB1->B1_UM)
		AADD(zUNID_PRO ,SB1->B1_SEGUM)
		AADD(xCOD_TRIB ,SB1->B1_ORIGEM)
		If Ascan(xMEN_TRIB, SB1->B1_ORIGEM)==0
			AADD(xMEN_TRIB ,SB1->B1_ORIGEM)
		Endif
		
		If SB1->B1_ALIQISS > 0
			AADD(xISS ,SB1->B1_ALIQISS)
		Endif
		AADD(xTIPO_PRO ,SB1->B1_TIPO)
		AADD(xLUCRO    ,SB1->B1_PICMRET)
		xPESO_BRU := xPESO_BRU + (SB1->B1_PESBRU * SD2->D2_QUANT)
		
		dbSelectArea("SD2")                   // * Itens de Venda da N.F.
		dbskip()
	End
	
	xPED        := {}
	
	For I:=1 to Len(xPED_VEND)
		DBSelectArea("SC5")                            // * Pedidos de Venda
		dbSetOrder(1)
		dbSeek(xFilial("SC5")+xPED_VEND[I])
		If ASCAN(xPED,xPED_VEND[I])==0
			xTIPO_CLI   :=SC5->C5_TIPOCLI            // Tipo de Cliente
			xMENSAG1    :=SC5->C5_MENS1              // Mensagem para a Nota Fiscal
			xMENSAG2    :=SC5->C5_MENS2              // Mensagem para a Nota Fiscal
			xMENSAG3    :=SC5->C5_MENS3              // Mensagem para a Nota Fiscal
			xMENSAG4    :=SC5->C5_MENS4              // Mensagem para a Nota Fiscal
			xMENSAG5    :=SC5->C5_MENS5              // Mensagem para a Nota Fiscal
			xMENSAG6    :=SC5->C5_MENS6              // Mensagem para a Nota Fiscal
			xMENSAG7    :=SC5->C5_MENS7              // Mensagem para a Nota Fiscal
			xTPFRETE    :=SC5->C5_TPFRETE            // Tipo de Entrega
			xPLACA      :=SC5->C5_PLACA              // Placa do Veiculo
			xESTVEI     :=SC5->C5_UFPLACA            // Estado veiculo transportador
			xCONDPAG    :=SC5->C5_CONDPAG            // Condicao de Pagamento
			xPESO_BRU   := IIF(SC5->C5_PBRUTO#0,SC5->C5_PBRUTO,xPESO_BRU)             // Peso Bruto
			xPESO_PLT   :=SC5->C5_PESPAL             // Peso Pallet
			xPESO_LIQ   := IIF(SC5->C5_PESOL#0 ,SC5->C5_PESOL,xPESO_LIQ)              // Peso Liquido
			xCODVEN     := SC5->C5_VEND1             // Codigo do Vendedor 1
			xPEDCLI     := SC5->C5_PEDCLI
			xDESC_NF := {SC5->C5_DESC1,;             // Desconto Global 1
			SC5->C5_DESC2,;             // Desconto Global 2
			SC5->C5_DESC3,;             // Desconto Global 3
			SC5->C5_DESC4}              // Desconto Global 4
			xESPECIE    :=SC5->C5_ESPECI1            // Especie 1 no Pedido
			xVOLUME     :=SC5->C5_VOLUME1            // Volume 1 no Pedido
			xMARCA      :=SC5->C5_MARCA              // Marca
			xREDESP             :=SC5->C5_REDESP             //Redespacho
			AADD(xPED,xPED_VEND[I])
			xSAIDA      :=SC5->C5_SAIDA              // Data Saida
		Endif
	NEXT
	
	//+---------------------------------------------+
	//¦ Pesquisa da Condicao de Pagto               ¦
	//+---------------------------------------------+
	
	dbSelectArea("SE4")                    // Condicao de Pagamento
	dbSetOrder(1)
	dbSeek(xFilial("SE4")+xCONDPAG)
	xDESC_PAG := SE4->E4_DESCRI
	
	xPED_CLI :={}                          // Numero de Pedido
	xDESC_PRO:={}                          // Descricao aux do produto
	
	J:=Len(xPED_VEND)
	For I:=1 to J
		dbSelectArea("SC6")                    // * Itens de Pedido de Venda
		dbSetOrder(1)
		dbSeek(xFilial("SC6")+xPED_VEND[I]+xITEM_PED[I])
		AADD(xPED_CLI ,SC6->C6_PEDCLI)
		AADD(xDESCRICAO,SC6->C6_DESCRI)
	Next
	
	If (xTIPO=='N') .OR. (xTIPO=='C') .OR. (xTIPO=='P') .OR. (xTIPO=='I') .OR. (xTIPO=='S') .OR. (xTIPO=='T') .OR. (xTIPO=='O')
		dbSelectArea("SA1")                // * Cadastro de Clientes
		dbSetOrder(1)
		dbSeek(xFilial("SA1")+xCLIENTE+xLOJA)
		xCOD_CLI :=SA1->A1_COD             // Codigo do Cliente
		xNOME_CLI:=SA1->A1_NOME            // Nome
		xEND_CLI :=alltrim(SA1->A1_END)// +iif(!empty(SA1->A1_COD),","+str(SA1->A1_COD,5),"") // Endereco
		xEND_ENT :=iif(empty(SA1->A1_ENDENT),xEnd_Cli,alltrim(SA1->A1_ENDENT)) //+iif(!empty(SA1->A1_COD),","+str(SA1->A1_COD,5),""))+"-"+alltrim(SA1->A1_mun)+"-"+SA1->A1_est  // Endereco Entrega
		xBAIRRO  :=SA1->A1_BAIRRO          // Bairro
		xCEP_CLI :=SA1->A1_CEP             // CEP
		xCOB_END :=SA1->A1_ENDCOB          // Endereco de Cobranca
		xCOB_MUN :=SA1->A1_MUNC            // Municipio de Cobranca
		xCOB_EST :=SA1->A1_ESTC            // Estado de Cobranca
		xCOB_BAI :=SA1->A1_BAIRROC         // Bairro de Cobranca
		xCOB_CEP :=SA1->A1_CEPC            // CEP de Cobranca
		xREC_CLI :=SA1->A1_ENDENT          // Endereco de Entrega
		xMUN_CLI :=SA1->A1_MUN             // Municipio
		xEST_CLI :=SA1->A1_EST             // Estado
		xCGC_CLI :=SA1->A1_CGC             // CGC
		xINSC_CLI:=SA1->A1_INSCR           // Inscricao estadual
		xTRAN_CLI:=SA1->A1_TRANSP          // Transportadora
		xTEL_CLI :=SA1->A1_TEL             // Telefone
		xFAX_CLI :=SA1->A1_FAX             // Fax
		xSUFRAMA :=SA1->A1_SUFRAMA            // Codigo Suframa
		xCALCSUF :=SA1->A1_CALCSUF            // Calcula Suframa
		// Alteracao p/ Calculo de Suframa
		if !empty(xSUFRAMA) .and. xCALCSUF =="S"
			IF XTIPO == 'D' .OR. XTIPO == 'B'
				zFranca := .F.
			else
				zFranca := .T.
			endif
		Else
			zfranca:= .F.
		endif
		
	Else
		
		zFranca:=.F.
		dbSelectArea("SA2")                // * Cadastro de Fornecedores
		dbSetOrder(1)
		dbSeek(xFilial("SA2")+xCLIENTE+xLOJA)
		xCOD_CLI :=SA2->A2_COD             // Codigo do Fornecedor
		xNOME_CLI:=SA2->A2_NOME            // Nome Fornecedor
		xEND_CLI :=SA2->A2_END             // Endereco
		xEND_ENT :=""                      // Endereco Entrega
		xBAIRRO  :=SA2->A2_BAIRRO          // Bairro
		xCEP_CLI :=SA2->A2_CEP             // CEP
		xCOB_CLI :=""                      // Endereco de Cobranca
		xREC_CLI :=""                      // Endereco de Entrega
		xMUN_CLI :=SA2->A2_MUN             // Municipio
		xEST_CLI :=SA2->A2_EST             // Estado
		xCGC_CLI :=SA2->A2_CGC             // CGC
		xINSC_CLI:=SA2->A2_INSCR           // Inscricao estadual
		xTRAN_CLI:=SA2->A2_TRANSP          // Transportadora
		xTEL_CLI :=SA2->A2_TEL             // Telefone
		xFAX_CLI :=SA2->A2_FAX             // Fax
	Endif
	
	If xICMS_RET >0                          // Apenas se ICMS Retido > 0
		/*
		dbSelectArea("SF3")                   // * Cadastro de Livros Fiscais
		dbSetOrder(4)
		dbSeek(xFilial("SF3")+SA1->A1_COD+SA1->A1_LOJA+SF2->F2_DOC+SF2->F2_SERIE)
		If Found()
		xBSICMRET:=F3_VALOBSE
		Else
		xBSICMRET:=0
		Endif
		*/
	Else
		xBSICMRET:=0
	Endif
	dbSelectArea("SA4")                   // * Transportadoras
	dbSetOrder(1)
	dbSeek(xFilial("SA4")+SF2->F2_TRANSP)
	xCOD_TRANSP  :=SA4->A4_COD            // Codigo da transportadora
	xNOME_TRANSP :=SA4->A4_NOME           // Nome Transportadora
	xEND_TRANSP  :=SA4->A4_END            // Endereco
	xMUN_TRANSP  :=SA4->A4_MUN            // Municipio
	xEST_TRANSP  :=SA4->A4_EST            // Estado
	xVIA_TRANSP  :=SA4->A4_VIA            // Via de Transporte
	xCGC_TRANSP  :=SA4->A4_CGC            // CGC
	xTEL_TRANSP  :=SA4->A4_TEL            // Fone
	xINSC_TRANSP :=SA4->A4_INSEST         // Inscricao Estadual
	
	dbSelectArea("SE1")                   // * Contas a Receber
	dbSetOrder(1)
	xPARC_DUP  :={}                       // Parcela
	xVENC_DUP  :={}                       // Vencimento
	xVALOR_DUP :={}                       // Valor
	xDUPLICATAS:=IIF(dbSeek(xFilial("SE1")+xSERIE+xNUM_DUPLIC,.T.),.T.,.F.) // Flag p/Impressao de Duplicatas
	
	dbSelectArea("SE1")                   // * Contas a Receber
	while !eof() .and. SE1->E1_NUM==xNUM_DUPLIC .and. xDUPLICATAS==.T.
		If !("NF" $ SE1->E1_TIPO)
			dbSelectArea("SE1")                   // * Contas a Receber
			dbSkip()
			Loop
		Endif
		AADD(xPARC_DUP ,SE1->E1_PARCELA)
		AADD(xVENC_DUP ,SE1->E1_VENCTO)
		//AADD(xVALOR_DUP,SE1->E1_VALOR)
		AADD(xVALOR_DUP,SE1->E1_VLCRUZ)
		dbSelectArea("SE1")                   // * Contas a Receber
		dbSkip()
	EndDo
	
	dbSelectArea("SF4")                   // * Tipos de Entrada e Saida
	DbSetOrder(1)
	
	dbSeek(xFilial("SF4")+xTES[1])
	xNATUREZA:=SF4->F4_TEXTO              // Natureza da Operacao
	
	Imprime()
	
	//+--------------------------------------------------------------+
	//¦ Termino da Impressao da Nota Fiscal                          ¦
	//+--------------------------------------------------------------+
	
	IncRegua()                    // Termometro de Impressao
	
	nLin:=0
	dbSelectArea("SF2")
	dbSkip()                      // passa para a proxima Nota Fiscal
	
EndDo

//+--------------------------------------------------------------+
//¦                                                              ¦
//¦                      FIM DA IMPRESSAO                        ¦
//¦                                                              ¦
//+--------------------------------------------------------------+

//+--------------------------------------------------------------+
//¦ Fechamento do Programa da Nota Fiscal                        ¦
//+--------------------------------------------------------------+

dbSelectArea("SF2")
Retindex("SF2")
dbSelectArea("SD2")
Retindex("SD2")
Set Device To Screen

If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

// Funcao de impressao dos Produtos da NF.
//--------------------------------------------------

Static Function IMPDET()
Local I := 0 

nTamDet :=11            // Tamanho da Area de Detalhe
nItens  :=1

I:=1
J:=1

xB_ICMS_SOL:=0          // Base  do ICMS Solidario
xV_ICMS_SOL:=0          // Valor do ICMS Solidario

IF (xTES[1] # "553") .AND. (xTES[1] # "554")
	FOR I:=1 TO LEN(xCOD_PRO)
		
		IF nItens > nTamDet
			@ nLin, 14 PSAY "CONTINUA..."
			
			nItens := 0
			nLin   := nLin+1
			
			ImpVal1()
			ImpCab()
			
			nLin := 23
			
			@ nLin, 14 PSAY "CONTINUACAO..."
			nItens := nItens + 1
			nLin   := nLin+1
			
		ENDIF
		
		IF xTipo == "N" .or. xTipo == "D" .or. xTipo == "B"
			dbSelectArea("SB1")
			dbSetorder(1)
			dbSeek(xFilial("SB1")+xCOD_PRO[I])
			
			@ nLin, 000  PSAY SUBSTR(xCOD_PRO[I],1,9)
			@ nLin, 009  PSAY SUBSTR(xDESCRICAO[I],1,55)
			@ nLin, 067  PSAY xCOD_FIS[I]
			
			IF EMPTY(ALLTRIM(xCOD_TRIB[I]))
				@ nLin, 070 PSAY "00"
				
			ELSE
				@ nLin, 070 PSAY xCOD_TRIB[I]
			ENDIF
			
			IF xQTD_PRO[I] < 1
				@ nLin, 074  PSAY zUNID_PRO[I]
				@ nLin, 078  PSAY zQTD_PRO[I]               Picture"@E 999,999.99"
				@ nLin, 087  PSAY xVAL_MERC[I]/zQTD_PRO[I]  Picture"@E 999,999.9999"
			ELSE
				@ nLin, 074  PSAY xUNID_PRO[I]
				@ nLin, 078  PSAY xQTD_PRO[I]               Picture"@E 99,999.999"
				@ nLin, 087  PSAY xPRE_UNI[I]               Picture"@E 999,999.9999"
			ENDIF
			
			xTOT_QTDVOL := xTOT_QTDVOL + xQTD_PRO[I] // Qtd. Volumes
			
			@ nLin, 102  PSAY xVAL_MERC[I]              Picture"@E 99,999,999.99"
			@ nLin, 118  PSAY xICM_PROD[I]              Picture"99"
			@ nLin, 121  PSAY xIPI[I]                   Picture"99"
			@ nLin, 128  PSAY xVAL_IPI[I]               Picture"@E 99999.99"
			
			J:=J+1
			nLin :=nLin+1
			nItens := nItens + 1
			
		ENDIF
	NEXT
ENDIF

IF (xTES[1] == "553") .OR. (xTES[1] == "554")
	
	IF SF2->F2_VALICM > 0
		
		@ 024, 009 PSAY "Transf. de Creditos de ICMS realizada  nos"
		@ 025, 009 PSAY "termos do Artigo 40 Decreto Nr. 1790/97.  "
		@ 026, 009 PSAY "Operacao realizada com creditos acumulados"
		@ 027, 009 PSAY "de Exportacoes."
		
	ENDIF
	
	IF SF2->F2_VALIPI > 0
		
		@ 024, 009 PSAY "Transferencia de Creditos de IPI de acordo"
		@ 025, 009 PSAY "com Artigo 4o do Paragrafo II  de 27.02.97"
		@ 026, 009 PSAY "da Lei Nr. 9363 Portaria Nr. 38."
		
	ENDIF
	
ENDIF

RETURN


// Funcao DUPLIC() para Impressao das Duplicatas
//-----------------------------------------------

Static Function DUPLIC()

// Imprime se nao for NF. Complementar
//------------------------------------

IF (SF2->F2_TIPO # "P") .AND. (SF2->F2_TIPO # "I") .AND. (xTES[1] # "553") .AND. (xTES[1] # "554")
	
	nCol    := 0
	nAjuste := 0
	
	@ nLIN,001 PSAY ALLTRIM(xCOB_END)
	@ nLIN,052 PSAY xNUM_NF
	
	// Impressao da Parcela 1 e Parcela 4
	//-----------------------------------
	
	IF LEN(xVALOR_DUP) >= 1
		If xCond_pag == "001"
			@ nLIN,069 PSAY "A VISTA"
		Else
			@ nLIN,069 PSAY xVENC_DUP[1]
		Endif
		@ nLIN,084 PSAY xVALOR_DUP[1] PICTURE("@E 9,999,999.99")
	ENDIF
	
	IF LEN(xVALOR_DUP) >= 4
		@ nLIN,106 PSAY xVENC_DUP[4]
		@ nLIN,123 PSAY xVALOR_DUP[4] PICTURE("@E 9,999,999.99")
	ENDIF
	
	nLIN:=nLIN + 1
	
	IF !EMPTY(xCOB_BAI).AND.!(EMPTY(xCOB_CEP))
		@ nLIN,001 PSAY ALLTRIM(xCOB_BAI)+" - "+xCOB_CEP
	ENDIF
	
	// Impressao da Parcela 2 e Parcela 5
	//-----------------------------------
	
	IF LEN(xVALOR_DUP) >= 2
		@ nLIN,070 PSAY xVENC_DUP[2]
		@ nLIN,085 PSAY xVALOR_DUP[2] PICTURE("@E 9,999,999.99")
	ENDIF
	
	IF LEN(xVALOR_DUP) >= 5
		@ nLIN,106 PSAY xVENC_DUP[5]
		@ nLIN,123 PSAY xVALOR_DUP[5] PICTURE("@E 9,999,999.99")
	ENDIF
	
	nLIN:=nLIN + 1
	
	IF !EMPTY(xCOB_MUN)
		@ nLIN,001 PSAY ALLTRIM(xCOB_MUN)+" - "+xCOB_EST
	ENDIF
	
	// Impressao da Parcela 3 e Parcela 6
	//-----------------------------------
	
	IF LEN(xVALOR_DUP) >= 3
		@ nLIN,070 PSAY xVENC_DUP[3]
		@ nLIN,085 PSAY xVALOR_DUP[3] PICTURE("@E 9,999,999.99")
	ENDIF
	
	IF LEN(xVALOR_DUP) >= 6
		@ nLIN,106 PSAY xVENC_DUP[6]
		@ nLIN,123 PSAY xVALOR_DUP[6] PICTURE("@E 9,999,999.99")
	ENDIF
	
	nLIN:=nLIN + 1
	
ELSE
	nLIN := nLIN + 3
ENDIF

RETURN

// Funcao Imprime() para Estruturar Impressao da NF.
//--------------------------------------------------

Static Function Imprime()

ImpCab() // Funcao de Impressao do Cabecalho da NF.

nLin := 23

ImpDet() // Funcao de Impressao dos Itens da NF.

// Imprime Codigo do Vendedor e Pedido do Cliente no Corpo da NF.
//----------------------------------------------------------------

nCOL := 30

IF (!Empty(xCODVEN))
	@ 033, 010 PSAY "Vendedor: " + xCODVEN
	nCOL := 30
ENDIF

IF (!Empty(xPEDCLI))
	@ 033, nCOL PSAY "S/Pedido: " + xPEDCLI
ENDIF

ImpVal() // Funcao de Impressao dos Valores de Impostos

// Imprime Dados do Transportador se nao for NF. Complementar
//-----------------------------------------------------------

IF (SF2->F2_TIPO # "P") .AND. (SF2->F2_TIPO # "I") .AND. (xTES[1] # "553") .AND. (xTES[1] # "554")
	@ 44, 001 PSAY ALLTRIM(xCOD_TRANSP)+" - "+ALLTRIM(xNOME_TRANSP)
	IF xTPFRETE=='C'                                   // Frete por conta do
		@ 44, 080 PSAY "1"                              // Emitente (1)
	ELSE                                              //     ou
		@ 44, 080 PSAY "2"                              // Destinatario (2)
	ENDIF
ENDIF
@ 44, 087 PSAY xPlaca
@ 44, 101 PSAY xESTVei
IF !EMPTY(xCGC_TRANSP)
	@ 44, 108 PSAY xCGC_TRANSP Picture"@R 99.999.999/9999-99"
ELSE
	@ 44, 108 PSAY " "
ENDIF
@ 46, 001 PSAY xEND_TRANSP
@ 46, 067 PSAY xMUN_TRANSP
@ 46, 101 PSAY xEST_TRANSP
@ 46, 108 PSAY xINSC_TRANSP

nNrDe := nNrAte := 0

IF EMPTY(ALLTRIM(xVOLUME))
	xVOLUME := xTOT_QTDVOL
ENDIF
IF !EMPTY(xVOLUME)
	@ 49, 001 PSAY Transf(xVOLUME,"@E@Z 999,999")
ENDIF
@ 49, 020 PSAY xESPECIE Picture"@!"
@ 49, 067 PSAY xMARCA
@ 49, 087 PSAY " "

// Se nao for NF. complemento de IPI e ICMS imprime pesos
//---------------------------------------------------------
IF (SF2->F2_TIPO # "P") .AND. (SF2->F2_TIPO # "I") .AND. (xTES[1] # "553") .AND. (xTES[1] # "554")
	@ 49, 104 PSAY (xPESO_BRU+xPESO_PLT)       Picture"@E@Z 999,999.99"
	@ 49, 122 PSAY xPESO_LIQ                   Picture"@E@Z 999,999.99"
ENDIF

@ 052, 001 PSAY UPPER(xMENSAG1)
@ 053, 001 PSAY UPPER(xMENSAG2)
@ 054, 001 PSAY UPPER(xMENSAG3)
@ 055, 001 PSAY UPPER(xMENSAG4)
@ 055, 101 PSAY xSAIDA
@ 056, 001 PSAY UPPER(xMENSAG5)
@ 057, 001 PSAY UPPER(xMENSAG6)
@ 058, 001 PSAY UPPER(xMENSAG7)

@ 061, 120 PSAY xNUM_NF                   // Numero da Nota Fiscal

//      @ PROW()+5,000 PSAY ""

@ 62, 000 PSAY ""
@ 63, 000 PSAY ""
@ 64, 000 PSAY ""

RETURN

// Funcao para impressao do Cabecalho da NF.
//------------------------------------------

Static Function ImpCab()

@ 01, 125 PSAY xNUM_NF
//@ 02, 030 PSAY SM0->M0_NOMECOM
@ 02, 087 PSAY "X"
//@ 03, 030 PSAY ALLTRIM(SM0->M0_ENDCOB)+" - "+SM0->M0_BAIRCOB
//@ 04, 030 PSAY ALLTRIM(SM0->M0_CIDCOB)+" - "+SM0->M0_ESTCOB+" - "+TRANSF(SM0->M0_CEPCOB,"@R 99999-999")
//@ 05, 030 PSAY "Fone/Fax: "+SM0->M0_TEL
//@ 05, 088 PSAY TRANSF(SM0->M0_CGC,"@R 99.999.999/9999-99")
@ 07, 001 PSAY xNATUREZA
@ 07, 044 PSAY xCF[1] Picture"@R 9.9999"
//@ 07, 088 PSAY SM0->M0_INSC

// Impressao dos dados do Cliente
//---------------------------------------------------------

@ 10, 001 PSAY ALLTRIM(xNOME_CLI)+"  ("+xCOD_CLI+"."+xLOJA+")"

IF !EMPTY(xCGC_CLI)
	@ 10, 088 PSAY xCGC_CLI Picture"@R 99.999.999/9999-99"
ELSE
	@ 10, 088 PSAY " "
ENDIF

@ 10, 123 PSAY xEMISSAO
@ 12, 001 PSAY xEND_CLI
@ 12, 070 PSAY xBAIRRO
@ 12, 101 PSAY xCEP_CLI Picture"@R 99999-999"
//@ 12, 123 PSAY dDATABASE
@ 12, 123 PSAY xSAIDA
@ 14, 001 PSAY xMUN_CLI
@ 14, 055 PSAY xTEL_CLI
@ 14, 081 PSAY xEST_CLI
@ 14, 088 PSAY xINSC_CLI
@ 14, 121 PSAY " "

IF (xTIPO=='N') .OR. (xTIPO=='C') .OR. (xTIPO=='P') .OR. (xTIPO=='I') .OR. (xTIPO=='S') .OR. (xTIPO=='T') .OR. (xTIPO=='O')
	nLin:=17
	BB:=1
	nCol := 10
	DUPLIC()
ENDIF

RETURN

// Funcao para impressao dos Valores de Impostos da NF.
//-----------------------------------------------------

Static Function ImpVal()

// Imprime Valores de Impostos (Se nao for NF. Complementar)
//-----------------------------------------------------------

IF (SF2->F2_TIPO # "P") .AND. (SF2->F2_TIPO # "I") .AND. (xTES[1] # "553") .AND. (xTES[1] # "554")
	@ 39, 008  PSAY Transf(xBASE_ICMS  ,"@E@Z 999,999,999.99")  // Base do ICMS
ENDIF

@ 39, 036  PSAY Transf(xVALOR_ICMS ,"@E@Z 999,999,999.99")  // Valor do ICMS
IF (SF2->F2_TIPO # "P") .AND. (SF2->F2_TIPO # "I") .AND. (xTES[1] # "553") .AND. (xTES[1] # "554")
	@ 39, 063  PSAY Transf(xBSICMRET   ,"@E@Z 999,999,999.99")  // Base ICMS Ret.
	@ 39, 091  PSAY Transf(xICMS_RET   ,"@E@Z 999,999,999.99")  // Valor  ICMS Ret.
	@ 39, 117  PSAY Transf(xVALOR_MERC ,"@E@Z 999,999,999.99")  // Valor Tot. Prod.
	@ 41, 008  PSAY Transf(xFRETE     ,"@E@Z 999,999,999.99")   // Valor do Frete
	@ 41, 036  PSAY Transf(xSEGURO    ,"@E@Z 999,999,999.99")   // Valor Seguro
	@ 41, 063  PSAY Transf(xDESPESA   ,"@E@Z 999,999,999.99")   // Despesa
ENDIF
@ 41, 091  PSAY Transf(xVALOR_IPI ,"@E@Z 999,999,999.99")  // Valor do IPI
IF (SF2->F2_TIPO # "P") .AND. (SF2->F2_TIPO # "I") .AND. (xTES[1] # "553") .AND. (xTES[1] # "554")
	@ 41, 117  PSAY Transf(xTOT_FAT   ,"@E@Z 999,999,999.99")  // Valor Total NF
ENDIF

RETURN

Static Function ImpVal1()

@ 39, 008  PSAY "**************"  // Base do ICMS
@ 39, 036  PSAY "**************"  // Valor do ICMS
@ 39, 063  PSAY "**************"  // Base ICMS Ret.
@ 39, 091  PSAY "**************"  // Valor  ICMS Ret.
@ 39, 117  PSAY "**************"  // Valor Tot. Prod.
@ 41, 008  PSAY "**************"  // Valor do Frete
@ 41, 036  PSAY "**************"  // Valor Seguro
@ 41, 063  PSAY "**************"  // Despesa
@ 41, 091  PSAY "**************"  // Valor do IPI
@ 41, 117  PSAY "**************"  // Valor Total NF

RETURN
