#INCLUDE "TOTVS.CH"
#INCLUDE "RWMAKE.CH"

#define DMPAPER_LETTER 1  		// Letter 8 1/2 x 11 in
#define DMPAPER_LETTERSMALL 2  	// Letter Small 8 1/2 x 11 in
#define DMPAPER_TABLOID 3 		// Tabloid 11 x 17 in
#define DMPAPER_LEDGER 4 		// Ledger 17 x 11 in
#define DMPAPER_LEGAL 5 		// Legal 8 1/2 x 14 in
#define DMPAPER_STATEMENT 6  	// Statement 5 1/2 x 8 1/2 in
#define DMPAPER_EXECUTIVE 7 	// Executive 7 1/4 x 10 1/2 in
#define DMPAPER_A3 8 			// A3 297 x 420 mm
#define DMPAPER_A4 9  			// A4 210 x 297 mm
#define DMPAPER_A4SMALL 10  	// A4 Small 210 x 297 mm
#define DMPAPER_A5 11 			// A5 148 x 210 mm
#define DMPAPER_B4 12  			// B4 250 x 354
#define DMPAPER_B5 13 			// B5 182 x 257 mm
#define DMPAPER_FOLIO 14  		// Folio 8 1/2 x 13 in
#define DMPAPER_QUARTO 15  		// Quarto 215 x 275 mm
#define DMPAPER_10X14 16 		// 10x14 in
#define DMPAPER_11X17 17  		// 11x17 in
#define DMPAPER_NOTE 18 		// Note 8 1/2 x 11 in
#define DMPAPER_ENV_9 19  		// Envelope #9 3 7/8 x 8 7/8
#define DMPAPER_ENV_10 20  		// Envelope #10 4 1/8 x 9 1/2
#define DMPAPER_ENV_11 21 		// Envelope #11 4 1/2 x 10 3/8
#define DMPAPER_ENV_12 22  		// Envelope #12 4 \276 x 11
#define DMPAPER_ENV_14 23 		// Envelope #14 5 x 11 1/2
#define DMPAPER_CSHEET 24  		// C size sheet
#define DMPAPER_DSHEET 25 		// D size sheet
#define DMPAPER_ESHEET 26  		// E size sheet
#define DMPAPER_ENV_DL 27 		// Envelope DL 110 x 220mm
#define DMPAPER_ENV_C5 28  		// Envelope C5 162 x 229 mm
#define DMPAPER_ENV_C3 29 		// Envelope C3 324 x 458 mm
#define DMPAPER_ENV_C4 30  		// Envelope C4 229 x 324 mm
#define DMPAPER_ENV_C6 31 		// Envelope C6 114 x 162 mm
#define DMPAPER_ENV_C65 32  	// Envelope C65 114 x 229 mm
#define DMPAPER_ENV_B4 33 		// Envelope B4 250 x 353 mm
#define DMPAPER_ENV_B5 34  		// Envelope B5 176 x 250 mm
#define DMPAPER_ENV_B6 35 		// Envelope B6 176 x 125 mm
#define DMPAPER_ENV_ITALY 36  	// Envelope 110 x 230 mm
#define DMPAPER_ENV_MONARCH 37  // Envelope Monarch 3.875 x 7.5 in
#define DMPAPER_ENV_PERSONAL 38 // 6 3/4 Envelope 3 5/8 x 6 1/2 in
#define DMPAPER_FANFOLD_US 39 	// US Std Fanfold 14 7/8 x 11 in
#define DMPAPER_FANFOLD_STD_GERMAN 40	// German Std Fanfold 8 1/2 x 12 in
#define DMPAPER_FANFOLD_LGL_GERMAN 41 	// German Legal Fanfold 8 1/2 x 13 in

#define CLR_CINZA	RGB( 192 , 192 , 192 )

//
/////////////////////////////////////////////////////////////////////////////
// Programa: BLTCDBAR     Autor: 	Microsiga           Data   13/10/03   ///
//                        Alterado: Claudenilson Dias   Data   20/05/14   ///
//                        Alterado: Claudenilson Dias   Data   01/04/15   ///
/////////////////////////////////////////////////////////////////////////////
// Descricao: IMPRESSAO DO BOLETO BANCO DO BRASIL         				  ///
//            IMPRESSAO DO BOLETO BANCO SANTANDER         				  ///
/////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////
User Function BLTCDBAR()
///////////////////////////////////////
Local _i := 0
Local _nX := 0
Private _lTeste     := .f.

PRIVATE _lRotAntiga := .f.

PRIVATE lExec    	:= .F.
PRIVATE cIndexName 	:= ''
PRIVATE cIndexKey  	:= ''
PRIVATE cFilter    	:= ''
PRIVATE lEnd       	:= .F.
PRIVATE cPerg     	:= padr("BLTBAR", 10)
PRIVATE	_aNumBco 	:= {}
PRIVATE _cLogotipo  := ""

Private	oBrush1 	:= TBrush():New( , CLR_CINZA )

//-------------------------------------------------
// percentual da multa
//-------------------------------------------------

Private nMulta  	:= 2

//-------------------------------------------------
// percentual da Mora Mes (vai ser dividida por 30)
//-------------------------------------------------

Private nMoraDia	:= 3.5

//-------------------------------------------------


if ! _lTeste
	
	AjustaSx1(cPerg)
	
	If Pergunte (cPerg,.T.)
		
		dbSelectArea("SE1")
		
		if _lRotAntiga
			
			cIndexName	:= Criatrab(Nil,.F.)
			cIndexKey	:= "E1_PREFIXO+E1_NUM+E1_PARCELA+E1_PORTADO+E1_CLIENTE+E1_TIPO+DTOS(E1_EMISSAO)"
			
			cFilter		+= "E1_FILIAL=='"+xFilial("SE1")+"'.And.E1_SALDO>0.And."
			cFilter		+= "E1_PREFIXO>='" + MV_PAR01 + "'.And.E1_PREFIXO<='" + MV_PAR02 + "'.And."
			cFilter		+= "E1_NUM>='" + MV_PAR03 + "'.And.E1_NUM<='" + MV_PAR04 + "'.And."
			cFilter		+= "E1_PARCELA>='" + MV_PAR05 + "'.And.E1_PARCELA<='" + MV_PAR06 + "'.And."
			cFilter		+= "E1_PORTADO>='" + MV_PAR07 + "'.And.E1_PORTADO<='" + MV_PAR08 + "'.And."
			cFilter		+= "E1_CLIENTE>='" + MV_PAR09 + "'.And.E1_CLIENTE<='" + MV_PAR10 + "'.And."
			cFilter		+= "E1_LOJA>='" + MV_PAR11 + "'.And.E1_LOJA<='"+MV_PAR12 +"'.And."
			cFilter		+= "DTOS(E1_EMISSAO)>='"+DTOS(mv_par13)+"'.and.DTOS(E1_EMISSAO)<='"+DTOS(mv_par14)+"'.And."
			cFilter		+= 'DTOS(E1_VENCREA)>="'+DTOS(mv_par15)+'".and.DTOS(E1_VENCREA)<="'+DTOS(mv_par16)+'".And.'
			cFilter		+= "E1_NUMBOR>='" + MV_PAR17 + "'.And.E1_NUMBOR<='" + MV_PAR18 + "'.And."
			cFilter		+= "!(E1_TIPO$MVABATIM).And."
			cFilter		+= "E1_PORTADO<>'   '"
			
			IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Aguarde selecionando registros....")
			
			#IFNDEF TOP
				DbSetIndex(cIndexName + OrdBagExt())
			#ENDIF
			
		Else
			
			cIndexName	:= Criatrab(Nil,.F.)
			
			_cQry := " "
			
			_cQry += " SELECT *, R_E_C_N_O_ AS REGSE1 FROM "+retsqlname("SE1")+ " SE1 "
			_cQry += " WHERE  SE1.D_E_L_E_T_ <> '*'  "
			_cQry += "   AND  SE1.E1_FILIAL = '"+xfilial("SE1")+"' "
			_cQry += "   AND  SE1.E1_SALDO > 0 "
			_cQry += "   AND  ( SE1.E1_PREFIXO BETWEEN '"+ MV_PAR01 + "' AND '"+ MV_PAR02 + "') "
			_cQry += "   AND  ( SE1.E1_NUM     BETWEEN '"+ MV_PAR03 + "' AND '"+ MV_PAR04 + "') "
			_cQry += "   AND  ( SE1.E1_PARCELA BETWEEN '"+ MV_PAR05 + "' AND '"+ MV_PAR06 + "') "
			_cQry += "   AND  ( SE1.E1_PORTADO BETWEEN '"+ MV_PAR07 + "' AND '"+ MV_PAR08 + "') "
			_cQry += "   AND  ( SE1.E1_PORTADO <> '   ') "
			_cQry += "   AND  ( SE1.E1_CLIENTE BETWEEN '"+ MV_PAR09 + "' AND '"+ MV_PAR10 + "') "
			_cQry += "   AND  ( SE1.E1_LOJA    BETWEEN '"+ MV_PAR11 + "' AND '"+ MV_PAR12 + "') "
			_cQry += "   AND  ( SE1.E1_EMISSAO BETWEEN '"+ DTOS(MV_PAR13) + "' AND '"+ DTOS(MV_PAR14) + "') "
			_cQry += "   AND  ( SE1.E1_VENCREA BETWEEN '"+ DTOS(MV_PAR15) + "' AND '"+ DTOS(MV_PAR16) + "') "
			_cQry += "   AND  ( SE1.E1_NUMBOR  BETWEEN '"+ MV_PAR17 + "' AND '"+ MV_PAR18 + "') "
			//_cQry += "   AND   SE1.E1_TIPO     	//cFilter		+= "!(E1_TIPO$MVABATIM).And."
			
			_cQry += "   ORDER BY E1_PREFIXO,E1_NUM,E1_PARCELA,E1_PORTADO,E1_CLIENTE,E1_TIPO,E1_EMISSAO"
			
			//alert(_cQry)
			//alert(cIndexName)
			
			dbselectarea("SE1")
			_aStrutmp := SE1->(dbStruct())
			dbclosearea()
			
			dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cqRY), "TMPSE1", .F., .T.)
			
			For _nX := 1 To Len(_aStrutmp)
				If _aStrutmp[_nX,2] $ "DN"
					TcSetField("TMPSE1",_aStrutmp[_nX,1],_aStrutmp[_nX,2],_aStrutmp[_nX,3],_aStrutmp[_nX,4])
				EndIf
			Next
			
			COPY TO &(cIndexName)
			
			TMPSE1->(DBCLOSEAREA())
			
			dbUseArea( .T., "CTREECDX", cIndexName , "SE1", .F., .F.)
			
		Endif
		
		dbSelectArea("SE1")
		dbGoTop()
		
		@ 001,001 TO 400,700 DIALOG oDlg TITLE "SeleÁ„o de Titulos"
		@ 001,001 TO 170,350 BROWSE "SE1" MARK "E1_OK"
		
		@ 180,310 BMPBUTTON TYPE 01 ACTION ( lExec := .T., Close(oDlg) )
		@ 180,280 BMPBUTTON TYPE 02 ACTION ( lExec := .F., Close(oDlg) )
		
		ACTIVATE DIALOG oDlg CENTERED
		
		dbGoTop()
		
		If lExec
			
			Processa({ |lEnd| MontaRel() })
			
			_aNumBco := {}
			
			dbselectarea("SE1")
			
			if ! _lRotAntiga
				
				dbgotop()
				
				Do While ! eof()
					
					if ! empty(E1_NUMBCO)
						aadd( _aNumBco , { REGSE1 , E1_NUMBCO } )
					Endif
					
					dbskip()
					
				Enddo
				
			Endif
			
			
		Endif
		
		dbselectarea("SE1")
		dbclosearea()
		chkfile("SE1")
		
		dbselectarea("SE1")
		
		if _lRotAntiga
			
			Ferase(cIndexName+OrdBagExt())
			
		Else
			
			if len(_aNumBco) > 0
				
				For _i := 1 to len(_aNumBco)
					
					dbgoto(_aNumBco[_i][1])
					
					if RecLock("SE1",.f.)
						SE1->E1_NUMBCO 	:=	_aNumBco[_i][2]
						MsUnlock()
					Endif
					
					
				Next
				
			Endif
			
		Endif
		
	Endif
	
Else
	
	Processa({ |lEnd| MontaRel() })
	
Endif

Return Nil

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Programa  ≥  MontaRel≥ Autor ≥ Microsiga             ≥ Data ≥ 13/10/03 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥ IMPRESSAO DO BOLETO LASER DO ITAU COM CODIGO DE BARRAS     ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Uso       ≥ Especifico para Clientes Microsiga                         ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
Static Function MontaRel()
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
LOCAL oPrint
Local cNroDoc 		:=  " "
Local cNossoNum		:=  " "
LOCAL aDadosTit
LOCAL aBanco
LOCAL aCedente
Local aAvalista
LOCAL aSacado
LOCAL aBolText
LOCAL aCB_LD_NN    	:= {}
LOCAL nVlrAbat	   	:= 0

private _cCarteira
private _cConvenio
private _cCIP		:= ""
private _cUsoBanco  := ""
private _cMoeda    	:= "9"
private _lAvalista	:= .f.

//Parametros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)

private oFont8   := TFont():New("Arial"      	, 9 , 08 ,  , .F. , 5 , .T. ,5, .F. , .F. )
private oFont11c := TFont():New("Courier New"	, 9 , 11 ,  , .T. , 5 , .T. ,5, .F. , .F. )
private oFont11  := TFont():New("Arial"      	, 9 , 11 ,  , .F. , 5 , .T. ,5, .F. , .F. )
private oFont11n := TFont():New("Arial"      	, 9 , 11 ,  , .T. , 5 , .T. ,5, .F. , .F. )
private oFont10  := TFont():New("Arial"			, 9 , 10 ,  , .F. , 5 , .T. ,5, .F. , .F. )
private oFont9n  := TFont():New("Arial"			, 9 , 09 ,  , .T. , 5 , .T. ,5, .F. , .F. )
private oFont10n := TFont():New("Arial"			, 9 , 10 ,  , .T. , 5 , .T. ,5, .F. , .F. )
private oFont14  := TFont():New("Arial"			, 9 , 14 ,  , .T. , 5 , .T. ,5, .F. , .F. )
private oFont20  := TFont():New("Arial"			, 9 , 20 ,  , .T. , 5 , .T. ,5, .F. , .F. )
private oFont21  := TFont():New("Arial"			, 9 , 21 ,  , .T. , 5 , .T. ,5, .F. , .F. )
private oFont16n := TFont():New("Arial"			, 9 , 16 ,  , .F. , 5 , .T. ,5, .F. , .F. )
private oFont15  := TFont():New("Arial"			, 9 , 15 ,  , .T. , 5 , .T. ,5, .F. , .F. )
private oFont15n := TFont():New("Arial"			, 9 , 15 ,  , .F. , 5 , .T. ,5, .F. , .F. )
private oFont14n := TFont():New("Arial"			, 9 , 14 ,  , .F. , 5 , .T. ,5, .F. , .F. )
private oFont24  := TFont():New("Arial"			, 9 , 24 ,  , .T. , 5 , .T. ,5, .F. , .F. )

aCedente := {;
alltrim(SM0->M0_NOMECOM) ,; 														// [1] Nome da Empresa
alltrim(SM0->M0_ENDCOB)	 ,;															// [2] EndereÁo
AllTrim(SM0->M0_BAIRCOB) ,; 														// [3] Bairro
AllTrim(SM0->M0_CIDCOB)+"-"+SM0->M0_ESTCOB ,; 										// [4] Cidade / Estado
transform(SM0->M0_CEPCOB, "@R 99.999-999") ,; 										// [5] CEP
"PABX/FAX: "+SM0->M0_TEL                                                  	,; 		// [6] Telefones
transform(SM0->M0_CGC  , "@R 99.999.999/9999-99"),;      			 	// [7] CGC
"I.E.: " + transform(alltrim(SM0->M0_INSC) , "@R 99.999.999-9") }   				// [8] I.E

// Alaterar variaveis abaixo se houver avalistas
aAvalista 	:= { " " , " " , " " , " " , " " , " " , " " , " " }
_lAvalista	:= .f.

aAvalista 	:= aclone(aCedente)
_lAvalista	:= .t.



ABOLTEXT := {;
"APÛS O VENCIMENTO COBRAR MULTA DE R$ "                ,; 	// 01
"MORA DIARIA DE R$ "                                   ,; 	// 02
"SUJEITO A PROTESTO APOS 05 (CINCO) DIAS DO VENCIMENTO",; 	// 03
"PAGAMENTO SOMENTE EM BANCO",; 								// 04
"N√O PAGUE NADA AO VENDEDOR"}  								// 05

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
oPrint:= TMSPrinter():New( "Boleto Banc·rio" )
oPrint:SetPaperSize (DMPAPER_A4)
oPrint:SetPortrait() // ou SetLandscape()
oPrint:SetFont (oFont10n)

nPagColIni := 100
nPagColFim := 2300
nPagFimImp := nPagColFim-20

//oPrint:StartPage()   // Inicia uma nova p·gina
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////

if ! _lTeste
	
	dbselectarea("SE1")
	dbGoTop()
	
	ProcRegua(RecCount())
	
	Do While !EOF()
		
		IncProc()
		
		_lProcessa := .t.
		
		If Marked("E1_OK") // Verifica se Esta narcado para imprimir
			
			_cBanco := SE1->E1_PORTADO
			
			//Posiciona o SA6 (Bancos)
			DbSelectArea("SA6")
			DbSetOrder(1)
			DbSeek(xFilial("SA6")+_cBanco+SE1->E1_AGEDEP+SE1->E1_CONTA,.F.)
			
			IF EOF()
				alert("Banco Portador inexistente: "+_cBanco+chr(10)+"Titulo: " + SE1->E1_NUM)
				_lProcessa := .f.
			Endif
			
			if _lProcessa
				
				//Posiciona na Arq de Parametros CNAB
				DbSelectArea("SEE")
				DbSetOrder(1)
				DbSeek(xFilial("SEE")+_cBanco+SE1->(E1_AGEDEP+E1_CONTA),.F.)
				
				IF EOF()
					alert("Informacoes de CNAB inexistente para o Banco: "+_cBanco+chr(10)+"Titulo: " + SE1->E1_NUM)
					_lProcessa := .f.
				Endif
				
			Endif
			
			if _lProcessa
				
				//Posiciona o SA1 (Cliente)
				DbSelectArea("SA1")
				DbSetOrder(1)
				DbSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA,.F.)
				
				IF EOF()
					alert("Cliente incexistente: "+SE1->E1_CLIENTE+chr(10)+"Titulo: " + SE1->E1_NUM)
					_lProcessa := .f.
				Endif
				
			Endif
			
			if _lProcessa
				
				// Verificar a Carteira de acordo com o banco, em alguns bancos, pode existir mais de uma carteira.
				
				_cConvenio 	:= padr( alltrim(SEE->EE_CODEMP) , 7 ) // Verificar tamanho do convenio pois o layout do Banco do Brasil difere para cada tamanho
				_cCarteira 	:= alltrim(SEE->EE_CODCART)
				
				//////////////////////////////
				// Bradesco
				//////////////////////////////
				_cBnfAgenc	:= "0000"
				_cBnfConta	:= "0000000"
				//////////////////////////////
				
				if SA6->A6_COD == "001" // Banco do Brasil
					
					_cCarteira 	:= "17"
					_cMoeda 	:= "9"
					
					if sm0->m0_codigo == '04'
						
						aBanco := { ;
						SA6->A6_COD,;													// [1]Numero do Banco
						SA6->A6_NOME,; 													// [2]Nome do Banco
						SUBSTR(SA6->A6_AGENCIA ,1 , 4),;								// [3]AgÍncia
						SUBSTR(SA6->A6_NUMCON  ,1 , Len(AllTrim(SA6->A6_NUMCON))-1),;	// [4]Conta Corrente
						SUBSTR(SA6->A6_NUMCON  ,Len(AllTrim(SA6->A6_NUMCON)),1)  ,;		// [5]DÌgito da conta corrente
						_cCarteira,; 													// [6]Codigo da Carteira
						"-9" } 															// [7]Digito Verificador do Codigo do Banco (ver Manual)
			
						
					Else
						
						aBanco := { ;
						SA6->A6_COD ,;   												// [1]Numero do Banco
						SA6->A6_NOME, ; 												// [2]Nome do Banco
						SUBSTR(SA6->A6_AGENCIA ,1 , 4) ,;								// [3]AgÍncia
						alltrim(SA6->A6_NUMCON) ,; 										// [4]Conta Corrente
						SA6->A6_DVCTA  ,; 	   											// [5]DÌgito da conta corrente
						_cCarteira,; 													// [6]Codigo da Carteira
						"-9" } 															// [7]Digito Verificador do Codigo do Banco (ver Manual)
						
					Endif
					
					// ---------------------------------------------------------------
					// Numero do Documento (configurar de acordo com o cliente)
					// ---------------------------------------------------------------
					
					cNroDoc        := StrZero(	Val(Alltrim(SE1->E1_PREFIXO)) , 3 ) + strzero( val(Alltrim(SUBSTR(SE1->E1_NUM,4,6))) , 6 )  + IIF( empty( Alltrim(SE1->E1_PARCELA) ) , "1" , Alltrim(SE1->E1_PARCELA) )
					
				Elseif SA6->A6_COD == "033" // Banco Santander
					
					_cCarteira := "101"
					_cMoeda 	:= "9"
					
					aBanco := { ;
					SA6->A6_COD ,;   												// [1]Numero do Banco
					SA6->A6_NOME, ; 												// [2]Nome do Banco
					SUBSTR(SA6->A6_AGENCIA ,1 , 4) ,;								// [3]AgÍncia
					alltrim(SA6->A6_NUMCON) ,; 										// [4]Conta Corrente
					SA6->A6_DVCTA  ,; 	   											// [5]DÌgito da conta corrente
					_cCarteira,; 													// [6]Codigo da Carteira
					"-7" } 															// [7]Digito Verificador do Codigo do Banco (ver Manual)
					
					// ---------------------------------------------------------------
					// Numero do Documento (configurar de acordo com o cliente)
					// ---------------------------------------------------------------
					// Banco Santander o numero do docuemtno nao compoe o Nosso Numero
					
					cNroDoc := U_DOC_033(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA)
					
				Elseif SA6->A6_COD == "341" // Banco Itau
					
					_cCarteira := "109"
					_cMoeda 	:= "9"
					
					aBanco := { ;
					SA6->A6_COD ,;   												// [1]Numero do Banco
					SA6->A6_NOME, ; 												// [2]Nome do Banco
					SUBSTR(SA6->A6_AGENCIA ,1 , 4) ,;								// [3]AgÍncia
					alltrim(SA6->A6_NUMCON) ,; 										// [4]Conta Corrente
					SA6->A6_DVCTA  ,; 	   											// [5]DÌgito da conta corrente
					_cCarteira,; 													// [6]Codigo da Carteira
					"-7" } 															// [7]Digito Verificador do Codigo do Banco (ver Manual)
					
					// ---------------------------------------------------------------
					// Numero do Documento (configurar de acordo com o cliente)
					// ---------------------------------------------------------------
					// Banco Santander o numero do docuemtno nao compoe o Nosso Numero
					
					cNroDoc := U_DOC_033(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA)					
					
				Elseif SA6->A6_COD == "237" // Banco Bradesco / Daycoval
					
					_cConvenio 	:= ""
					_cCarteira 	:= "09"
					_cMoeda 	:= "9"
					_cBnfAgenc	:= "2374-4"
					_cBnfConta	:= "0001018-9"
					_cCIP 		:= "504"
					_cUsoBanco	:= "8600"
					_cLogotipo  := "bradesco.bmp"
					
					cNossoNum	:=	alltrim(SE1->E1_NUMBCO)
					nMulta  	:= 0
					nMoraDia	:= 0
					
					IF len(cNossoNum) <> 12
						cNossoNum := ""
					Endif
					
					aBolText := {;
					"SUJEITO A PROTESTO APOS 05 (CINCO) DIAS DO VENCIMENTO",; 	// 01
					"PAGAMENTO SOMENTE EM BANCO",; 								// 02
					"N√O PAGUE NADA AO VENDEDOR",;  							// 03
					" ",;  														// 04
					" "}  														// 05
					
					aBanco := { ;
					SA6->A6_COD ,;   												// [1]Numero do Banco
					SA6->A6_NOME, ; 												// [2]Nome do Banco
					SUBSTR(SA6->A6_AGENCIA ,1 , 4) ,;								// [3]AgÍncia
					alltrim(SA6->A6_NUMCON) ,; 										// [4]Conta Corrente
					SA6->A6_DVCTA  ,; 	   											// [5]DÌgito da conta corrente
					_cCarteira,; 													// [6]Codigo da Carteira
					"-2" } 															// [7]Digito Verificador do Codigo do Banco (ver Manual)
					
					// ---------------------------------------------------------------
					// Numero do Documento (configurar de acordo com o cliente)
					// ---------------------------------------------------------------
					
					cNroDoc := StrZero(	Val(Alltrim(SE1->E1_PREFIXO)) , 3 ) + strzero( val(Alltrim(SUBSTR(SE1->E1_NUM,4,6))) , 6 )  + IIF( empty( Alltrim(SE1->E1_PARCELA) ) , "1" , Alltrim(SE1->E1_PARCELA) )
					
				Endif
				
				If Empty(SA1->A1_ENDCOB)
					
					aSacado   := {;
					AllTrim(SA1->A1_NOME)           ,;   	// [1]Raz„o Social
					AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;    	// [2]CÛdigo
					AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO),;    	// [3]EndereÁo
					AllTrim(SA1->A1_MUN )                            ,;  	// [4]Cidade
					SA1->A1_EST                                      ,;     // [5]Estado
					SA1->A1_CEP                                      ,;    	// [6]CEP
					SA1->A1_CGC										 ,; 	// [7]CGC
					Iif(Len(AllTrim(SA1->A1_CGC))==14,"J","F")	}       	// [8]PESSOA
					
				Else
					
					aSacado   := {AllTrim(SA1->A1_NOME)            	,; 	// [1]Raz„o Social
					AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA            	,; 	// [2]CÛdigo
					AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO)	,; 	// [3]EndereÁo
					AllTrim(SA1->A1_MUN )	                            ,;	// [4]Cidade
					SA1->A1_EST	                                     	,;	// [5]Estado
					SA1->A1_CEP                                        	,; 	// [6]CEP
					SA1->A1_CGC											,;	// [7]CGC
					Iif(Len(AllTrim(SA1->A1_CGC))==14,"J","F")			 }	// [8]PESSOA
					
				Endif
				
				DbSelectArea("SE1")
				
				// ---------------------------------------------------------------
				// Verifica se tem abatimento
				// ---------------------------------------------------------------
				
				nVlrAbat     := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
				
				// ---------------------------------------------------------------------------------------------
				// Monta codigo de barras (Retorna array com CODIGO DE BARRAS, LINHA DIGITAVEL E NOSSO NUMERO)
				// ---------------------------------------------------------------------------------------------
				
				aCB_LD_NN	:= Ret_cBarra( Subs( aBanco[1] , 1 , 3 ), _cMoeda , aBanco[3] , aBanco[4] , aBanco[5] , cNroDoc , (SE1->E1_SALDO-nVlrAbat) , SE1->E1_VENCTO , _cConvenio  , _cCarteira , _cBnfAgenc , _cBnfConta , cNossoNum )
				
				aDadosTit	:= {;
				cNroDoc						,;  // [1] N˙mero do tÌtulo
				SE1->E1_EMISSAO            	,;  // [2] Data da emiss„o do tÌtulo
				dDataBase                  	,;  // [3] Data da emiss„o do boleto
				SE1->E1_VENCTO             	,;  // [4] Data do vencimento
				(SE1->E1_SALDO-nVlrAbat)   	,;  // [5] Valor do tÌtulo //(SE1->E1_SALDO - nVlrAbat)
				aCB_LD_NN[3]               	,;  // [6] Nosso n˙mero (Ver fÛrmula para calculo)
				SE1->E1_PREFIXO            	,;  // [7] Prefixo da NF
				SE1->E1_TIPO	           	}   // [8] Tipo do Titulo
				
				/////////////////////////////////////////////////////////////////////////////////////////
				/////////////////////////////////////////////////////////////////////////////////////////
				
				DbSelectArea("SE1")
				
				if RecLock("SE1",.f.)
					SE1->E1_NUMBCO 	:=	aCB_LD_NN[3]   // Nosso n˙mero (Ver fÛrmula para calculo)
					MsUnlock()
				Endif
				
				/////////////////////////////////////////////////////////////////////////////////////////
				Impress( oPrint , aCedente , aDadosTit , aBanco , aSacado , aBolText , aCB_LD_NN, aAvalista )
				/////////////////////////////////////////////////////////////////////////////////////////
				
			Endif
			
		EndIf
		
		dbSkip()
		
	EndDo
	
Else
	
	_cBanco := "237"
	
	_cConvenio 	:= ""
	_cCarteira 	:= "19"
	_cMoeda 	:= "9"
	_cBnfAgenc	:= "2374-X"
	_cBnfConta	:= "0061510-2"
	_cCIP 		:= "504"
	_cUsoBanco  := "8600"
	_cLogotipo  := "bradesco.bmp"
	
	nMulta  	:= 0
	nMoraDia	:= 0
	aBolText := {;
	"SUJEITO A PROTESTO APOS 05 (CINCO) DIAS DO VENCIMENTO",; 	// 01
	"PAGAMENTO SOMENTE EM BANCO",; 								// 02
	"N√O PAGUE NADA AO VENDEDOR",;  							// 03
	" ",;  								// 04
	" "}  								// 05
	
	// Numero do Documento
	cNroDoc		:= "6697/15   "
	
	// Nosso Numero
	cNossoNum 	:= "00001007178"
	
	// Valor
	nValor := 99999999.88 //250.00
	
	// Vencimento
	dVcto  := ctod("30/03/2015")
	
	aBanco := { ;
	_cBanco , ;   							// [1]Numero do Banco
	"BANCO TESTE", ; 						// [2]Nome do Banco
	SUBSTR(_cBnfAgenc , 1 , 4 ) ,;			// [3]AgÍncia
	SUBSTR(_cBnfConta , 1 , 7 ) ,; 			// [4]Conta Corrente
	SUBSTR(_cBnfConta , 9 , 1 ) ,; 	   	// [5]DÌgito da conta corrente
	_cCarteira,; 							// [6]Codigo da Carteira
	"-2" } 									// [7]Digito Verificador do Codigo do Banco (ver Manual)
	
	aSacado   := {;
	"CLIENTE TESTE DE BOLETO",;   						// [1]Raz„o Social
	"999999",;    										// [2]CÛdigo
	"RUA DO CLIENTE TESTE DE BLOETO, 999 - CENTRO",;    // [3]EndereÁo
	"ANANINDEUA" ,;  									// [4]Cidade
	"PA" ,;     										// [5]Estado
	"66073290" ,;    									// [6]CEP
	"01234456000178" ,;  							// [7]CGC
	"J"	}       										// [8]PESSOA
	
	//Monta codigo de barras
	aCB_LD_NN	:= Ret_cBarra( Subs( aBanco[1] , 1 , 3 ), _cMoeda , aBanco[3] , aBanco[4] , aBanco[5] , cNroDoc , nValor , dVcto , _cConvenio  , _cCarteira , _cBnfAgenc , _cBnfConta , cNossoNum )
	
	aDadosTit	:= {;
	cNroDoc						,;  // [1] N˙mero do tÌtulo
	date()             			,;  // [2] Data da emiss„o do tÌtulo
	dDataBase                  	,;  // [3] Data da emiss„o do boleto
	dVcto		             	,;  // [4] Data do vencimento
	nValor					   	,;  // [5] Valor do tÌtulo //(SE1->E1_SALDO - nVlrAbat)
	aCB_LD_NN[3]               	,;  // [6] Nosso n˙mero (Ver fÛrmula para calculo)
	"PRF"		            	,;  // [7] Prefixo da NF
	"NF"}   						// [8] Tipo do Titulo
	
	Impress( oPrint , aCedente , aDadosTit , aBanco , aSacado , aBolText , aCB_LD_NN , aAvalista )
	
	DbSelectArea("SE1")
	dbsetorder(0)
	dbgotop()
	
	if RecLock("SE1",.f.)
		SE1->E1_NUMBCO 	:=	aCB_LD_NN[3]   // Nosso n˙mero (Ver fÛrmula para calculo)
		MsUnlock()
	Endif
	
	//alert(recno())
	
Endif

oPrint:End()		 // Finaliza RelatÛrio
oPrint:EndPage()     // Finaliza a p·gina
oPrint:Preview()     // Visualiza antes de imprimir

Return nil


/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Programa  ≥  Impress ≥ Autor ≥ Microsiga             ≥ Data ≥ 13/10/03 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥ IMPRESSAO DO BOLETO LASERDO ITAU COM CODIGO DE BARRAS      ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Uso       ≥ Especifico para Clientes Microsiga                         ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Impress( oPrint , aCedente , aDadosTit , aBanco , aSacado , aBolText , aCB_LD_NN , aAvalista )
/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////
local _i := 0
Local nI := 0
oPrint:StartPage()   // Inicia uma nova p·gina


_cBcoCod  	:= aBanco[1]
_cBcoDig  	:= aBanco[7]
_cBcoNome 	:= aBanco[2]
_cLinhaDig 	:= aCB_LD_NN[2]

nRow1 := 0

IF _cBcoCod == "237" // Bradesco
	
	/******************/
	/* PRIMEIRA PARTE */
	/******************/
	
	////////////////////////////////////////////////////////////////////////
	//Pontilhado separador
	////////////////////////////////////////////////////////////////////////
	
	nRow1 += 150
	
	// For nI := nPagColIni to ( nPagColFim - 40 ) step 40
	//
	//	if nI == ( nPagColFim - 40 )
	//		oPrint:Line( nRow1 , nI , nRow1 , nPagColFim )
	//	Else
	//		oPrint:Line( nRow1 , nI , nRow1 , nI+30      )
	//	Endif
	
	// Next nI
	
	////////////////////////////////////////////////////////////////////////
	
	//nRow1 += 20
	
	oPrint:Say  ( nRow1 , nPagFimImp , "Recibo do Pagador" , oFont10n , , , , 1 )
	
	nRow1		+= 100
	
	nAltura  	:= 100
	aColunas	:= { 500 , 710 }
	
	//oPrint:Say  ( nRow1 + 10 , nPagColIni 	, _cBcoNome			, oFont10n )		// Nome do Banco
	oPrint:SayBitmap ( nRow1  , nPagColIni , _cLogotipo , 400 , 100 )                   // Logotipo
	oPrint:Say  ( nRow1 + 10 , 513 			, _cBcoCod+_cBcoDig	, oFont20 )				// Numero do Banco
	oPrint:Say  ( nRow1 + 15 , nPagFimImp 	, _cLinhaDig       	, oFont15n , , , , 1 )	// Linha Digitavel do Codigo de Barras
	
	For _i := 1 to len(aColunas)
		oPrint:Line ( nRow1 , aColunas[_i] , nRow1 + nAltura , aColunas[_i] )
	Next
	
	oPrint:Line ( nRow1 + nAltura , nPagColIni , nRow1 + nAltura , nPagColFim )
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	nRow1 += nAltura
	
	aColunas := {nPagColIni , 1150,1600,1730,1900}
	nAltura  := 100
	
	For _i := 1 to len(aColunas)
		oPrint:Line ( nRow1 , aColunas[_i] , nRow1 +nAltura , aColunas[_i] )
	Next
	
	//////////////////////////////////////////////////////////////////////////////////////
	// Muda a tonalidade da area definida
	//////////////////////////////////////////////////////////////////////////////////////
	_nLinhaAnt := nRow1 		+ nAltura
	_nLinhaAtu := _nLinhaAnt	+ nAltura
	
	oPrint:FillRect ( { _nLinhaAnt , 1300 , _nLinhaAtu , nPagColFim }, oBrush1 )
	//////////////////////////////////////////////////////////////////////////////////////
	
	oPrint:Line ( nRow1 + nAltura , nPagColIni , nRow1 + nAltura , nPagColFim )
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	nRow1 += 15
	
	oPrint:Say  ( nRow1 , aColunas[1]+ 15 ,"Nome do Benefici·rio", oFont8)
	oPrint:Say  ( nRow1 , aColunas[2]+ 15 ,"AgÍncia/CÛdigo do Benefici·rio", oFont8)
	oPrint:Say  ( nRow1 , aColunas[3]+ 15 ,"Moeda", oFont8)
	oPrint:Say  ( nRow1 , aColunas[4]+ 15 ,"Quantidade", oFont8)
	oPrint:Say  ( nRow1 , aColunas[5]+ 15 ,"Nosso N˙mero", oFont8)
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	nRow1 += 40
	
	oPrint:Say  ( nRow1 , aColunas[1]+ 15	, aCedente[1] , oFont10n)		//Nome + CNPJ
	oPrint:Say  ( nRow1 , aColunas[2]+ 15 	, aBanco[3]+"/"+aBanco[4]+iif( !empty(aBanco[5]),"-"+aBanco[5],"" ), oFont10n)
	oPrint:Say  ( nRow1 , aColunas[3]+ 15 	, "R$", oFont10n) 	// Especie do Titulo
	oPrint:Say  ( nRow1 , nPagFimImp 		, _cCarteira + "/" + alltrim( transform( aDadosTit[6],"@R 99999999999-!") )  , oFont10n , (nPagFimImp-aColunas[5]) , , , 1 )
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	nRow1 += 45
	
	aColunas := { nPagColIni , 900 , 1300 , 1730 }
	nAltura  := 100
	
	For _i := 1 to len(aColunas)
		oPrint:Line ( nRow1 , aColunas[_i] , nRow1 +nAltura , aColunas[_i] )
	Next
	
	oPrint:Line ( nRow1 +nAltura , nPagColIni , nRow1 +nAltura , nPagColFim )
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	nRow1 += 15
	
	oPrint:Say  ( nRow1 , aColunas[1]+ 15 ,"N˙mero do Documento", oFont8)
	oPrint:Say  ( nRow1 , aColunas[2]+ 15 ,"CPF/CNPJ", oFont8)
	oPrint:Say  ( nRow1 , aColunas[3]+ 15 ,"Vencimento", oFont8)
	oPrint:Say  ( nRow1 , aColunas[4]+ 15 ,"Valor do Documento", oFont8)
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	nRow1 += 40
	
	oPrint:Say  ( nRow1 , aColunas[1]+ 15 , aDadosTit[1] , oFont10n)		// Numero do Documento
	oPrint:Say  ( nRow1 , aColunas[2]+ 15 , aCedente[7], oFont10n) // CNPJ do Beneficiario
	
	oPrint:Say  ( nRow1 , aColunas[3] + 15 	, dtoc(aDadosTit[4]) , oFont10n) // Vencimento
	oPrint:Say  ( nRow1 , nPagFimImp 		, "R$ "+AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")), oFont10n , (nPagFimImp-aColunas[4]) , , , 1 ) 	//Valor do Titulo
	
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	nRow1 += 45
	
	aColunas := {nPagColIni , 500,900,1200,1730}
	nAltura  := 100
	
	For _i := 1 to len(aColunas)
		oPrint:Line ( nRow1 , aColunas[_i] , nRow1 +nAltura , aColunas[_i] )
	Next
	
	oPrint:Line ( nRow1 +nAltura , nPagColIni , nRow1 +nAltura , nPagColFim )
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	nRow1 += 15
	
	oPrint:Say  ( nRow1 , aColunas[1]+ 15 ,"(-)Desconto/Abatimento"            , oFont8)
	oPrint:Say  ( nRow1 , aColunas[2]+ 15 ,"(-)Outras DeduÁıes"                , oFont8)
	oPrint:Say  ( nRow1 , aColunas[3]+ 15 ,"(+)Juros/Multa"               , oFont8)
	oPrint:Say  ( nRow1 , aColunas[4]+ 15 ,"(+)Outros AcrÈscimos"              , oFont8)
	oPrint:Say  ( nRow1 , aColunas[5]+ 15 ,"(=)Valor Cobrado"                  , oFont8)
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	nRow1 += 40
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	nRow1 += 45
	
	aColunas := {nPagColIni}
	nAltura  := 260
	
	For _i := 1 to len(aColunas)
		oPrint:Line ( nRow1 , aColunas[_i] , nRow1 +nAltura , aColunas[_i] )
	Next
	
	oPrint:Line ( nRow1 +nAltura , nPagColIni , nRow1 +nAltura , nPagColFim )
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	nRow1 += 15
	
	oPrint:Say  ( nRow1 , aColunas[1]+ 15 ,"InstruÁıes"            , oFont8)
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	nRow1 += 40
	
	if nMulta > 0
		oPrint:Say  ( nRow1       , aColunas[1]+45 , aBolText[1] +" "+AllTrim(Transform(   aDadosTit[5] * ( nMulta/100  ) 		,"@E 99,999.99")) , oFont10n) // Mensagem 1
	Else
		oPrint:Say  ( nRow1       , aColunas[1]+45 , aBolText[1] , oFont10n) // Mensagem 1
	Endif
	
	nRow1 += 40
	if nMoraDia > 0
		oPrint:Say  ( nRow1       , aColunas[1]+45 , aBolText[2] +" "+AllTrim(Transform( ( aDadosTit[5] * ( nMoraDia/100) )/30 	,"@E 99,999.99")) , oFont10n) // Mensagem 1
	Else
		oPrint:Say  ( nRow1       , aColunas[1]+45 , aBolText[2] , oFont10n) // Mensagem 1
	Endif
	
	
	nRow1 += 40
	oPrint:Say  ( nRow1     , aColunas[1]+45 , aBolText[3] , oFont10n) // Mensagem 1
	
	nRow1 += 40
	oPrint:Say  ( nRow1     , aColunas[1]+45 , aBolText[4] , oFont10n) // Mensagem 1
	
	nRow1 += 40
	oPrint:Say  ( nRow1     , aColunas[1]+45 , aBolText[5] , oFont10n) // Mensagem 1
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	nRow1 += 45
	
	aColunas := {nPagColIni}
	nAltura  := 300
	
	For _i := 1 to len(aColunas)
		oPrint:Line ( nRow1 , aColunas[_i] , nRow1 +nAltura , aColunas[_i] )
	Next
	
	oPrint:Line ( nRow1 + nAltura  		, nPagColIni , nRow1 +nAltura , nPagColFim )
	oPrint:Say  ( nRow1 + nAltura + 15 	, nPagFimImp , "AutenticaÁ„o Mec‚nica" ,  oFont8 , , , , 1)
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	nRow1 += 15
	
	oPrint:Say  ( nRow1 , aColunas[1]+ 15 ,"Pagador"            , oFont8)
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	//nRow1 += 40
	
	_cCpfCnpj := "CPF: "+TRANSFORM(aSacado[7],"@R 999.999.999-99")
	
	if aSacado[8] = "J"
		_cCpfCnpj := "CNPJ: "+TRANSFORM(aSacado[7],"@R 99.999.999/9999-99")
	Endif
	
	oPrint:Say  ( nRow1 , aColunas[1]+250 	, aSacado[1]+" ("+aSacado[2]+")" , oFont10n)		//Nome
	oPrint:Say  ( nRow1 , nPagFimImp		, _cCpfCnpj , oFont10n , , , , 1 )		// Cpf/Cnpj
	
	nRow1 += 40
	oPrint:Say  ( nRow1 , aColunas[1]+250 , aSacado[3] , oFont10n)		// Endereco
	
	nRow1 += 40
	oPrint:Say ( nRow1 , aColunas[1]+250 , aSacado[4]+"-"+aSacado[5] + "     " + transform(aSacado[6],"@R 99.999-999") , oFont10n)		// CEP+Cidade+Estado
	
	nRow1 += 60
	
	oPrint:Say  ( nRow1 , aColunas[1]+ 15 ,"Sacador/Avalista"            , oFont8)
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	if _lAvalista
		
		//nRow1 += 40
		
		oPrint:Say  ( nRow1 , aColunas[1] + 250 , aAvalista[1] 			, oFont10n)				//Nome
		oPrint:Say  ( nRow1 , nPagFimImp 		, "CNPJ: "+aAvalista[7]	, oFont10n , , , , 1 )	// CNPJ
		
		nRow1 += 40
		oPrint:Say  ( nRow1 , aColunas[1] + 250 , aAvalista[2] + " - " + aAvalista[3] , oFont10n)		// Endereco
		
		nRow1 += 40
		oPrint:Say  ( nRow1 , aColunas[1] + 250 , aAvalista[4] + "     " +aAvalista[5] , oFont10n)		// CEP+Cidade+Estado
		
	Else
		nRow1 += 140
	Endif
	
	/*****************/
	/* SEGUNDA PARTE */
	/*****************/
	
	nRow1 += 300
	
	////////////////////////////////////////////////////////////////////////
	//Pontilhado separador
	////////////////////////////////////////////////////////////////////////
	
	For nI := nPagColIni to ( nPagColFim - 40 ) step 40
		
		if nI == ( nPagColFim - 40 )
			oPrint:Line( nRow1 , nI , nRow1 , nPagColFim )
		Else
			oPrint:Line( nRow1 , nI , nRow1 , nI+30      )
		Endif
		
	Next nI
	
	////////////////////////////////////////////////////////////////////////
	
	nRow1 += 20
	oPrint:Say  ( nRow1 , nPagFimImp , "Cortar na Linha Pontilhada" , oFont8 , , , , 1 )
	
	nRow1 		+= 150
	
	aColunas := { 500 , 710 }
	nAltura  := 100
	
	//oPrint:Say  ( nRow1 + 10 , nPagColIni 	, _cBcoNome			, oFont10n )		// Nome do Banco
	oPrint:SayBitmap ( nRow1  , nPagColIni , _cLogotipo , 400 , 100 )                   // Logotipo
	oPrint:Say  ( nRow1 + 10 , 513 			, _cBcoCod+_cBcoDig	, oFont20 )				// Numero do Banco
	oPrint:Say  ( nRow1 + 15 , nPagFimImp 	, _cLinhaDig       	, oFont15n , , , , 1 )	// Linha Digitavel do Codigo de Barras
	
	For _i := 1 to len(aColunas)
		oPrint:Line ( nRow1 , aColunas[_i] , nRow1 + nAltura , aColunas[_i] )
	Next
	
	//////////////////////////////////////////////////////////////////////////////////////
	// Muda a tonalidade da area definida
	//////////////////////////////////////////////////////////////////////////////////////
	_nLinhaAnt := nRow1 		+ nAltura
	_nLinhaAtu := _nLinhaAnt	+ nAltura
	
	oPrint:FillRect ( { _nLinhaAnt , 1730 , _nLinhaAtu , nPagColFim }, oBrush1 )
	//////////////////////////////////////////////////////////////////////////////////////
	
	oPrint:Line ( nRow1 + nAltura , nPagColIni , nRow1 + nAltura , nPagColFim )
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	nRow1 		+= nAltura
	
	aColunas 	:= { nPagColIni , 1730 }
	nAltura  	:= 100
	
	For _i := 1 to len(aColunas)
		oPrint:Line ( nRow1 , aColunas[_i] , nRow1 +nAltura , aColunas[_i] )
	Next
	
	oPrint:Line ( nRow1 + nAltura , nPagColIni , nRow1 + nAltura , nPagColFim )
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	nRow1 += 15
	
	oPrint:Say  ( nRow1 , aColunas[1]+ 15 ,"Local de Pagamento", oFont8)
	oPrint:Say  ( nRow1 , aColunas[2]+ 15 ,"Vencimento", oFont8)
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	nRow1 += 40
	
	oPrint:Say  ( nRow1 , aColunas[1]+ 15 	, "AtÈ o vencimento, na rede banc·ria autorizada. ApÛs o vencimento, somente na rede BRADESCO" , oFont9n )		//Nome + CNPJ
	oPrint:Say  ( nRow1 , nPagFimImp		, dtoc(aDadosTit[4]) 				, oFont10n  , (nPagFimImp-aColunas[2]) , , , 1 ) // Vencimento
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	nRow1 += 45
	
	aColunas := { nPagColIni , 1730 }
	nAltura  := 140
	
	For _i := 1 to len(aColunas)
		oPrint:Line ( nRow1 , aColunas[_i] , nRow1 +nAltura , aColunas[_i] )
	Next
	
	oPrint:Line ( nRow1 +nAltura , nPagColIni , nRow1 +nAltura , nPagColFim )
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	nRow1 += 15
	
	oPrint:Say  ( nRow1 , aColunas[1]+ 15 ,"Nome do Benefici·rio/CPF/CNPJ/EndereÁo ", oFont8)
	oPrint:Say  ( nRow1 , aColunas[2]+ 15 ,"AgÍncia/CÛdigo do Benefici·rio", oFont8)
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	nRow1 += 40
	oPrint:Say  ( nRow1 , aColunas[1]+ 15 	, aCedente[1]+" - CNPJ: "+aCedente[7] , oFont10n )						//Nome + CNPJ
	
	nRow1 += 40
	oPrint:Say  ( nRow1 , aColunas[1]+ 15 	, aCedente[2]+ " - " + aCedente[3] +" - " + aCedente[4] +" - " + aCedente[5] , oFont10n)		//EndereÁo
	oPrint:Say  ( nRow1 , nPagFimImp 		, Alltrim(aBanco[3]+"/"+aBanco[4]+iif( !empty(aBanco[5]),"-"+aBanco[5],"" )) , oFont10n , (nPagFimImp-aColunas[2]) , , , 1 ) // Agencia/Conta do benefici·rio
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	nRow1 += 45
	
	aColunas := { nPagColIni , 500 , 900 , 1150 , 1300 , 1730 }
	nAltura  := 100
	
	For _i := 1 to len(aColunas)
		oPrint:Line ( nRow1 , aColunas[_i] , nRow1 +nAltura , aColunas[_i] )
	Next
	
	//////////////////////////////////////////////////////////////////////////////////////
	// Muda a tonalidade da area definida
	//////////////////////////////////////////////////////////////////////////////////////
	
	_nLinhaAnt := nRow1 	 + nAltura
	_nLinhaAtu := _nLinhaAnt + nAltura
	
	oPrint:FillRect ( { _nLinhaAnt , 1730 , _nLinhaAtu , nPagColFim }, oBrush1 )
	
	//////////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////////
	
	oPrint:Line ( nRow1 + nAltura , nPagColIni , nRow1 + nAltura , nPagColFim )
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	nRow1 += 15
	
	oPrint:Say  ( nRow1 , aColunas[1]+ 15 ,"Data do Documento", oFont8)
	oPrint:Say  ( nRow1 , aColunas[2]+ 15 ,"N˙mero do Documento", oFont8)
	oPrint:Say  ( nRow1 , aColunas[3]+ 15 ,"EspÈcie Doc.", oFont8)
	oPrint:Say  ( nRow1 , aColunas[4]+ 15 ,"Aceite", oFont8)
	oPrint:Say  ( nRow1 , aColunas[5]+ 15 ,"Data Processamento", oFont8)
	oPrint:Say  ( nRow1 , aColunas[6]+ 15 ,"Nosso N˙mero", oFont8)
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	nRow1 += 40
	
	oPrint:Say  ( nRow1 , aColunas[1]+ 15 	, dtoc( aDadosTit[2]) , oFont10n)		// Emissao
	oPrint:Say  ( nRow1 , aColunas[2]+ 15 	, aDadosTit[1] , oFont10n) // Documento
	oPrint:Say  ( nRow1 , aColunas[3]+ 15 	, aDadosTit[8] , oFont10n) //Tipo do Titulo
	oPrint:Say  ( nRow1 , aColunas[4]+ 15 	, "N" , oFont10n) // Aceite
	oPrint:Say  ( nRow1 , aColunas[5]+ 15 	, dtoc( aDadosTit[2]) , oFont10n) // Data do processamento
	oPrint:Say  ( nRow1 , nPagFimImp		, _cCarteira + "/" + alltrim( transform( aDadosTit[6] , "@R 99999999999-!") )  , oFont10n , (nPagFimImp-aColunas[6]) , , , 1 ) // Nosso N˙mero
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	nRow1 += 45
	
	aColunas := {nPagColIni , 350 , 500 , 700 , 900 , 1300 , 1730 }
	nAltura  := 100
	
	For _i := 1 to len(aColunas)
		oPrint:Line ( nRow1 , aColunas[_i] , nRow1 +nAltura , aColunas[_i] )
	Next
	
	oPrint:Line ( nRow1 +nAltura , nPagColIni , nRow1 +nAltura , nPagColFim )
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	nRow1 += 15
	
	oPrint:Say  ( nRow1 , aColunas[1] + 15 , "Uso do Banco", oFont8)
	oPrint:Say  ( nRow1 , aColunas[2] + 15 , "CIP", oFont8)
	oPrint:Say  ( nRow1 , aColunas[3] + 15 , "Carteira", oFont8)
	oPrint:Say  ( nRow1 , aColunas[4] + 15 , "Moeda", oFont8)
	oPrint:Say  ( nRow1 , aColunas[5] + 15 , "Quantidade", oFont8)
	oPrint:Say  ( nRow1 , aColunas[6] + 15 , "Valor", oFont8)
	oPrint:Say  ( nRow1 , aColunas[7] + 15 , "(=) Valor do Documento", oFont8)
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	nRow1 += 40
	
	oPrint:Say  ( nRow1 , aColunas[1]+ 15 , _cUsoBanco	, oFont10n)		// Uso do Banco
	oPrint:Say  ( nRow1 , aColunas[2]+ 15 , _cCIP 		, oFont10n)		// CIP
	oPrint:Say  ( nRow1 , aColunas[3]+ 15 , aBanco[6] 	, oFont10n) 	// Carteira
	oPrint:Say  ( nRow1 , aColunas[4]+ 15 , "R$" 		, oFont10n) 	// Especie
	
	oPrint:Say  ( nRow1 , nPagFimImp      , "R$ "+Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99")) , oFont10n , ( nPagFimImp-aColunas[7] ) , , , 1 ) // Valor do Documento
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	nRow1 += 45
	
	aColunas := {nPagColIni , 1730}
	nAltura  := 500
	
	//////////////////////////////////////////////////////////////////////////////////////
	// Muda a tonalidade da area definida
	//////////////////////////////////////////////////////////////////////////////////////
	_nLinhaAnt := nRow1 	 + 400
	_nLinhaAtu := _nLinhaAnt + 100
	
	oPrint:FillRect ( { _nLinhaAnt , 1730 , _nLinhaAtu , nPagColFim }, oBrush1 )
	//////////////////////////////////////////////////////////////////////////////////////
	
	For _i := 1 to len(aColunas)
		oPrint:Line ( nRow1 , aColunas[_i] , nRow1 +nAltura , aColunas[_i] )
	Next
	
	oPrint:Line ( nRow1 +nAltura , nPagColIni , nRow1 +nAltura , nPagColFim )
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	nRow1 += 15
	
	oPrint:Say  ( nRow1 , aColunas[1]+ 15 , "InformaÁıes de responsabilidade do benefici·rio.", oFont8)
	oPrint:Say  ( nRow1 , aColunas[2]+ 15 , "(-)Desconto/Abatimento", oFont8)
	
	if nMulta > 0
		oPrint:Say  ( nRow1 + 040 , aColunas[1]+45 , aBolText[1] +" "+AllTrim(Transform(   aDadosTit[5] * ( nMulta/100  ) 		,"@E 99,999.99")) , oFont10n) // Mensagem 1
	Else
		oPrint:Say  ( nRow1 + 040 , aColunas[1]+45 , aBolText[1] , oFont10n) // Mensagem 1
	Endif
	
	if nMoraDia > 0
		oPrint:Say  ( nRow1 + 080 , aColunas[1]+45 , aBolText[2] +" "+AllTrim(Transform( ( aDadosTit[5] * ( nMoraDia/100) )/30 	,"@E 99,999.99")) , oFont10n) // Mensagem 1
	Else
		oPrint:Say  ( nRow1 + 080 , aColunas[1]+45 , aBolText[2] , oFont10n) // Mensagem 1
	Endif
	
	oPrint:Say  ( nRow1 + 120 , aColunas[1]+45 , aBolText[3] , oFont10n) // Mensagem 1
	oPrint:Say  ( nRow1 + 160 , aColunas[1]+45 , aBolText[4] , oFont10n) // Mensagem 1
	oPrint:Say  ( nRow1 + 200 , aColunas[1]+45 , aBolText[5] , oFont10n) // Mensagem 1
	
	nRow1 += 85
	oPrint:Line ( nRow1 , aColunas[2] , nRow1 , nPagColFim )
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	nRow1 += 15
	oPrint:Say  ( nRow1 , aColunas[2]+ 15 , "(-)Outras DeduÁıes", oFont8)
	
	nRow1 += 85
	oPrint:Line ( nRow1 , aColunas[2] , nRow1 , nPagColFim )
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	nRow1 += 15
	oPrint:Say  ( nRow1 , aColunas[2]+ 15 , "(+)Juros/Multa", oFont8)
	
	nRow1 += 85
	oPrint:Line ( nRow1 , aColunas[2] , nRow1 , nPagColFim )
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	nRow1 += 15
	oPrint:Say  ( nRow1 , aColunas[2]+ 15 , "(+)Outros AcrÈscimos", oFont8)
	
	nRow1 += 85
	oPrint:Line ( nRow1 , aColunas[2] , nRow1 , nPagColFim )
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	nRow1 += 15
	oPrint:Say  ( nRow1 , aColunas[2]+ 15 , "(=)Valor Cobrado", oFont8)
	
	nRow1 += 85
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	aColunas := {nPagColIni}
	nAltura  := 300
	
	For _i := 1 to len(aColunas)
		oPrint:Line ( nRow1 , aColunas[_i] , nRow1 +nAltura , aColunas[_i] )
	Next
	
	oPrint:Line ( nRow1 + nAltura 		, nPagColIni , nRow1 +nAltura , nPagColFim )
	oPrint:Say  ( nRow1 + nAltura + 15 	, nPagFimImp , "AutenticaÁ„o Mec‚nica - Ficha de CompensaÁ„o" , oFont8 , , , , 1 )
	
	_nLinCodBar := nRow1 + nAltura + 15
	
	nRow1 += 15
	
	oPrint:Say  ( nRow1 , aColunas[1]+ 15 ,"Pagador"            , oFont8)
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	//nRow1 += 40
	
	_cCpfCnpj := "CPF: "+TRANSFORM(aSacado[7],"@R 999.999.999-99")
	
	if aSacado[8] = "J"
		_cCpfCnpj := "CNPJ: "+TRANSFORM(aSacado[7],"@R 99.999.999/9999-99")
	Endif
	
	oPrint:Say  ( nRow1 , aColunas[1]+250 	, aSacado[1]+" ("+aSacado[2]+")" , oFont10n)		//Nome
	oPrint:Say  ( nRow1 , nPagFimImp		, _cCpfCnpj , oFont10n , , , , 1 )		// Cpf/Cnpj
	
	nRow1 += 40
	oPrint:Say  ( nRow1 , aColunas[1]+250 , aSacado[3] , oFont10n)		// Endereco
	
	nRow1 += 40
	oPrint:Say ( nRow1 , aColunas[1]+250 , aSacado[4]+"-"+aSacado[5]+ "    " + transform(aSacado[6],"@R 99.999-999") , oFont10n)		// CEP+Cidade+Estado
	
	nRow1 += 60
	
	oPrint:Say  ( nRow1 , aColunas[1]+ 15 ,"Sacador/Avalista"            , oFont8)
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	if _lAvalista
		
		//nRow1 += 40
		
		oPrint:Say  ( nRow1 , aColunas[1] + 250 , aAvalista[1] 			, oFont10n)				//Nome
		oPrint:Say  ( nRow1 , nPagFimImp 		, "CNPJ: "+aAvalista[7]	, oFont10n , , , , 1 )	// CNPJ
		
		nRow1 += 40
		oPrint:Say  ( nRow1 , aColunas[1] + 250 , aAvalista[2] + " - " + aAvalista[3] , oFont10n)		// Endereco
		
		nRow1 += 40
		oPrint:Say  ( nRow1 , aColunas[1] + 250 , aAvalista[4]+  "     " +aAvalista[5] , oFont10n)		// CEP+Cidade+Estado
		
	Else
		
		nRow1 += 140
		
	Endif
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Codigo de Barra
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	MSBAR( "INT25" , 25.3 , 1 , aCB_LD_NN[1] , oPrint , .F. , Nil , Nil , 0.025 , 1.5 , Nil , Nil , "A" , .F. )
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
Else
	
	/******************/
	/* PRIMEIRA PARTE */
	/******************/
	
	
	oPrint:Line ( nRow1 + 0150,500, nRow1 + 0070, 500)
	oPrint:Line ( nRow1 + 0150,710, nRow1 + 0070, 710)
	
	oPrint:Say  ( nRow1 + 0084 , nPagColIni , _cBcoNome, oFont10n )	// [2]Nome do Banco
	oPrint:Say  ( nRow1 + 0075,513,_cBcoCod+_cBcoDig, oFont20 )	// [1]Numero do Banco
	
	oPrint:Say  ( nRow1 + 0084,1900,"Comprovante de Entrega", oFont10n)
	oPrint:Line ( nRow1 + 0150 , nPagColIni , nRow1 + 0150 , nPagColFim)
	
	oPrint:Say  ( nRow1 + 0150 , nPagColIni ,"Benefici·rio", oFont8)
	oPrint:Say  ( nRow1 + 0200 , nPagColIni ,aCedente[1], oFont10n)	//Nome + CNPJ
	
	oPrint:Say  ( nRow1 + 0150,1060,"AgÍncia/CÛdigo Benefici·rio", oFont8)
	If _cBcoCod == "033"
		oPrint:Say  ( nRow1 + 0200,1060,aBanco[3]+"/"+"0107557", oFont10n)
	Else
		oPrint:Say  ( nRow1 + 0200,1060,aBanco[3]+"/"+aBanco[4]+iif( !empty(aBanco[5]),"-"+aBanco[5],"" ), oFont10n)
	EndIf

	
	oPrint:Say  ( nRow1 + 0150,1510,"Nro.Documento", oFont8)
	oPrint:Say  ( nRow1 + 0200,1510,aDadosTit[1], oFont10n) //Prefixo +Numero+Parcela
	
	oPrint:Say  ( nRow1 + 0250 , nPagColIni ,"Pagador", oFont8)
	oPrint:Say  ( nRow1 + 0300 , nPagColIni ,aSacado[1], oFont10n)	//Nome
	
	oPrint:Say  ( nRow1 + 0250,1060,"Vencimento", oFont8)
	oPrint:Say  ( nRow1 + 0300,1060,StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Str( Year(aDadosTit[4]) ,4,0) , oFont10n)
	
	oPrint:Say  ( nRow1 + 0250,1510,"Valor do Documento", oFont8)
	oPrint:Say  ( nRow1 + 0300,1550,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")), oFont10n)
	
	oPrint:Say  ( nRow1 + 0400 , nPagColIni , "Recebi(emos) o bloqueto/tÌtulo", oFont10n)
	oPrint:Say  ( nRow1 + 0450 , nPagColIni , "com as caracterÌsticas acima.", oFont10n)
	oPrint:Say  ( nRow1 + 0350,1060,"Data", oFont8)
	oPrint:Say  ( nRow1 + 0350,1410,"Assinatura", oFont8)
	oPrint:Say  ( nRow1 + 0450,1060,"Data", oFont8)
	oPrint:Say  ( nRow1 + 0450,1410,"Entregador", oFont8)
	
	oPrint:Line ( nRow1 + 0250, nPagColIni , nRow1 + 0250,1900 )
	oPrint:Line ( nRow1 + 0350, nPagColIni , nRow1 + 0350,1900 )
	oPrint:Line ( nRow1 + 0450,1050, nRow1 + 0450,1900 ) //---
	oPrint:Line ( nRow1 + 0550, nPagColIni , nRow1 + 0550 , nPagColFim )
	
	oPrint:Line ( nRow1 + 0550,1050, nRow1 + 0150,1050 )
	oPrint:Line ( nRow1 + 0550,1400, nRow1 + 0350,1400 )
	oPrint:Line ( nRow1 + 0350,1500, nRow1 + 0150,1500 ) //--
	oPrint:Line ( nRow1 + 0550,1900, nRow1 + 0150,1900 )
	
	oPrint:Say  ( nRow1 + 0165,1910,"(  )Mudou-se"                        , oFont8)
	oPrint:Say  ( nRow1 + 0205,1910,"(  )Ausente"                         , oFont8)
	oPrint:Say  ( nRow1 + 0245,1910,"(  )N„o existe n∫ indicado"          , oFont8)
	oPrint:Say  ( nRow1 + 0285,1910,"(  )Recusado"                        , oFont8)
	oPrint:Say  ( nRow1 + 0325,1910,"(  )N„o procurado"                   , oFont8)
	oPrint:Say  ( nRow1 + 0365,1910,"(  )EndereÁo insuficiente"           , oFont8)
	oPrint:Say  ( nRow1 + 0405,1910,"(  )Desconhecido"                    , oFont8)
	oPrint:Say  ( nRow1 + 0445,1910,"(  )Falecido"                        , oFont8)
	oPrint:Say  ( nRow1 + 0485,1910,"(  )Outros(anotar no verso)"         , oFont8)
	
	
	/*****************/
	/* SEGUNDA PARTE */
	/*****************/
	
	nRow2 := 0
	
	////////////////////////////////////////////////////////////////////////
	//Pontilhado separador
	////////////////////////////////////////////////////////////////////////
	
	For nI := nPagColIni to ( nPagColFim - 40 ) step 40
		
		if nI == ( nPagColFim - 40 )
			oPrint:Line( nRow2 + 0580 , nI , nRow2 + 0580 , nPagColFim )
		Else
			oPrint:Line( nRow2 + 0580 , nI , nRow2 + 0580 , nI + 30    )
		Endif
		
	Next nI
	
	////////////////////////////////////////////////////////////////////////
	
	oPrint:Line ( nRow2 + 0710 , nPagColIni , nRow2 + 0710 , nPagColFim)
	oPrint:Line ( nRow2 + 0710,500, nRow2 + 0630, 500)
	oPrint:Line ( nRow2 + 0710,710, nRow2 + 0630, 710)
	
	oPrint:Say  ( nRow2 + 0644 , nPagColIni , _cBcoNome, oFont10n )		// [2]Nome do Banco
	oPrint:Say  ( nRow2 + 0635,513,_cBcoCod+_cBcoDig, oFont20 )	// [1]Numero do Banco
	oPrint:Say  ( nRow2 + 0644,1800,"Recibo do Pagador", oFont10n)
	
	oPrint:Line ( nRow2 + 0810 , nPagColIni , nRow2 + 0810 , nPagColFim )
	oPrint:Line ( nRow2 + 0910 , nPagColIni , nRow2 + 0910 , nPagColFim )
	oPrint:Line ( nRow2 + 0980 , nPagColIni , nRow2 + 0980 , nPagColFim )
	oPrint:Line ( nRow2 + 1050 , nPagColIni , nRow2 + 1050 , nPagColFim )
	
	oPrint:Line ( nRow2 + 0910,500, nRow2 + 1050,500)
	oPrint:Line ( nRow2 + 0980,750, nRow2 + 1050,750)
	oPrint:Line ( nRow2 + 0910,1000, nRow2 + 1050,1000)
	oPrint:Line ( nRow2 + 0910,1300, nRow2 + 0980,1300)
	oPrint:Line ( nRow2 + 0910,1480, nRow2 + 1050,1480)
	
	oPrint:Say  ( nRow2 + 0710 , nPagColIni ,"Local de Pagamento", oFont8)
	
	oPrint:Say  ( nRow2 + 0725,400 ,"PAGAVEL EM QUALQUER BANCO ATE O VENCIMENTO", oFont10n)
	oPrint:Say  ( nRow2 + 0765,400 ,"AP”S O VENCIMENTO PAGAR SOMENTE NO "+_cBcoNome, oFont10n)
	
	oPrint:Say  ( nRow2 + 0710,1810,"Vencimento"                       , oFont8)
	cString	:= StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Str( Year(aDadosTit[4]) ,4,0 )
	nCol := 1810 +(374-(len(cString)*22))
	oPrint:Say  ( nRow2 + 0750,nCol,cString, oFont11c)
	
	oPrint:Say  ( nRow2 + 0810 , nPagColIni ,"Benefici·rio"                          , oFont8)
	oPrint:Say  ( nRow2 + 0850 , nPagColIni ,aCedente[1]+"                  - CNPJ: "+aCedente[7]	, oFont10n) //Nome + CNPJ
	
	oPrint:Say  ( nRow2 + 0810,1810,"AgÍncia/CÛdigo Benefici·rio", oFont8)
	If   _cBcoCod == "033"
		cString := Alltrim(aBanco[3]+"/"+ "0107557" )	
	Else
		cString := Alltrim(aBanco[3]+"/"+aBanco[4] + iif( !empty(aBanco[5]),"-"+aBanco[5],"" ) )
	EndIf
	nCol := 1810 +(374-(len(cString)*22))
	oPrint:Say  ( nRow2 + 0850,nCol,cString, oFont11c)
	
	oPrint:Say  ( nRow2 + 0910 , nPagColIni ,"Data do Documento"                , oFont8)
	oPrint:Say  ( nRow2 + 0940 , nPagColIni ,  StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Str( Year(aDadosTit[2]),4,0), oFont10n)
	
	oPrint:Say  ( nRow2 + 0910,505 ,"Nro.Documento"                    , oFont8)
	oPrint:Say  ( nRow2 + 0940,605 ,aDadosTit[1]						, oFont10n) //Prefixo +Numero+Parcela
	
	oPrint:Say  ( nRow2 + 0910,1005,"EspÈcie Doc."                     , oFont8)

	If _cBcoCod $ "/033/341/"
		oPrint:Say  ( nRow2 + 0940,1050,"DM"						, oFont10n) //Tipo do Titulo
	Else
		oPrint:Say  ( nRow2 + 0940,1050,aDadosTit[8]						, oFont10n) //Tipo do Titulo
	EndIf
	
	oPrint:Say  ( nRow2 + 0910,1305,"Aceite"                           , oFont8)
	oPrint:Say  ( nRow2 + 0940,1400,"N"                                , oFont10n)
	
	oPrint:Say  ( nRow2 + 0910,1485,"Data do Processamento"            , oFont8)
	oPrint:Say  ( nRow2 + 0940,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Str(Year(aDadosTit[3]),4,0), oFont10n) // Data impressao
	
	oPrint:Say  ( nRow2 + 0910,1810,"Nosso N˙mero"                     , oFont8)
	If _cBcoCod $ "/341/"
		cString := "109/" + SubStr(Alltrim(aDadosTit[6]),1,8)+"-"+SubStr(Alltrim(aDadosTit[6]),9,1)
	Else
		cString := Alltrim(aDadosTit[6])	
	EndIf
	

	
	nCol := 1810 +(374-(len(cString)*20))
	oPrint:Say  ( nRow2 + 0940,nCol,cString, oFont11c)
	
	oPrint:Say  ( nRow2 + 0980 , nPagColIni ,"Uso do Banco"                     , oFont8)
	
	oPrint:Say  ( nRow2 + 0980,505 ,"Carteira"                         , oFont8)
	oPrint:Say  ( nRow2 + 1010,555 ,aBanco[6]                     , oFont10n)
	
	oPrint:Say  ( nRow2 + 0980,755 ,"EspÈcie"                          , oFont8)
	oPrint:Say  ( nRow2 + 1010,805 ,"R$"                               , oFont10n)
	
	oPrint:Say  ( nRow2 + 0980,1005,"Quantidade"                       , oFont8)
	oPrint:Say  ( nRow2 + 0980,1485,"Valor"                            , oFont8)
	
	oPrint:Say  ( nRow2 + 0980,1810,"Valor do Documento"               , oFont8)
	cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
	nCol := 1810 +(374-(len(cString)*22))
	oPrint:Say  ( nRow2 + 1010,nCol,cString , oFont11c)
	
	oPrint:Say  ( nRow2 + 1050 , nPagColIni ,"InstruÁıes (Todas informaÁıes deste bloqueto s„o de exclusiva responsabilidade do cedente)", oFont8)
	oPrint:Say  ( nRow2 + 1150 , nPagColIni ,aBolText[1]+" "+ AllTrim(Transform(   aDadosTit[5] * ( nMulta/100  ) 		,"@E 99,999.99"))  , oFont10n)
	oPrint:Say  ( nRow2 + 1190 , nPagColIni ,aBolText[2]+" "+ AllTrim(Transform( ( aDadosTit[5] * ( nMoraDia/100) )/30 	,"@E 99,999.99"))  , oFont10n)
	If _cBcoCod $ "/341/"
		oPrint:Say  ( nRow2 + 1230 , nPagColIni ,aBolText[4]                         , oFont10n)
		oPrint:Say  ( nRow2 + 1270 , nPagColIni ,aBolText[5]                         , oFont10n)		
	Else                    
		oPrint:Say  ( nRow2 + 1230 , nPagColIni ,aBolText[3]                         , oFont10n)
		oPrint:Say  ( nRow2 + 1270 , nPagColIni ,aBolText[4]                         , oFont10n)
		oPrint:Say  ( nRow2 + 1310 , nPagColIni ,aBolText[5]                         , oFont10n)
	EndIf
	
	
	oPrint:Say  ( nRow2 + 1050,1810,"(-)Desconto/Abatimento"            , oFont8)
	oPrint:Say  ( nRow2 + 1120,1810,"(-)Outras DeduÁıes"                , oFont8)
	oPrint:Say  ( nRow2 + 1190,1810,"(+)Mora/Multa"                     , oFont8)
	oPrint:Say  ( nRow2 + 1260,1810,"(+)Outros AcrÈscimos"              , oFont8)
	oPrint:Say  ( nRow2 + 1330,1810,"(=)Valor Cobrado"                  , oFont8)
	
	oPrint:Say  ( nRow2 + 1400 , nPagColIni ,"Pagador"                            , oFont8)
	oPrint:Say  ( nRow2 + 1430,400 ,aSacado[1]+" ("+aSacado[2]+")", oFont10n)
	oPrint:Say  ( nRow2 + 1483,400 ,aSacado[3]                       , oFont10n)
	oPrint:Say  ( nRow2 + 1536,400 ,transform(aSacado[6],"@R 99.999-999") +"    "+aSacado[4]+" - "+aSacado[5], oFont10n) // CEP+Cidade+Estado
	
	if aSacado[8] = "J"
		oPrint:Say  ( nRow2 + 1589,400 ,"CNPJ: "+TRANSFORM(aSacado[7],"@R 99.999.999/9999-99"), oFont10n) // CGC
	Else
		oPrint:Say  ( nRow2 + 1589,400 ,"CPF: "+TRANSFORM(aSacado[7],"@R 999.999.999-99"), oFont10n) 	// CPF
	EndIf
	
	oPrint:Say  ( nRow2 + 1589,1850, Alltrim(aDadosTit[6]) , oFont10n)
	
	oPrint:Say  ( nRow2 + 1605 , nPagColIni ,"Sacador/Avalista", oFont8)
	oPrint:Say  ( nRow2 + 1645,1500,"AutenticaÁ„o Mec‚nica", oFont8)
	
	oPrint:Line ( nRow2 + 0710,1800, nRow2 + 1400,1800 )
	oPrint:Line ( nRow2 + 1120,1800, nRow2 + 1120 , nPagColFim )
	oPrint:Line ( nRow2 + 1190,1800, nRow2 + 1190 , nPagColFim )
	oPrint:Line ( nRow2 + 1260,1800, nRow2 + 1260 , nPagColFim )
	oPrint:Line ( nRow2 + 1330,1800, nRow2 + 1330 , nPagColFim )
	oPrint:Line ( nRow2 + 1400 , nPagColIni , nRow2 + 1400 , nPagColFim )
	oPrint:Line ( nRow2 + 1640 , nPagColIni , nRow2 + 1640 , nPagColFim )
	
	
	/******************/
	/* TERCEIRA PARTE */
	/******************/
	
	nRow3 := 0
	
	////////////////////////////////////////////////////////////////////////
	//Pontilhado separador
	////////////////////////////////////////////////////////////////////////
	
	For nI := nPagColIni to ( nPagColFim - 40 ) step 40
		
		if nI == ( nPagColFim - 40 )
			oPrint:Line( nRow3 + 1880 , nI , nRow3 + 1880 , nPagColFim )
		Else
			oPrint:Line( nRow3 + 1880 , nI , nRow3 + 1880 , nI + 30    )
		Endif
		
	Next nI
	
	////////////////////////////////////////////////////////////////////////
	
	oPrint:Line ( nRow3 +2000 , nPagColIni , nRow3 +2000 , nPagColFim)
	oPrint:Line ( nRow3 +2000,500, nRow3 + 1920, 500)
	oPrint:Line ( nRow3 +2000,710, nRow3 + 1920, 710)
	
	oPrint:Say  ( nRow3 + 1934 , nPagColIni , _cBcoNome 		, oFont10n )	// 	Nome do Banco
	oPrint:Say  ( nRow3 + 1925 , 513		, _cBcoCod+_cBcoDig	, oFont20  )	// 	Numero do Banco
	oPrint:Say  ( nRow3 + 1934 , 755		, _cLinhaDig		, oFont15n )	//	Linha Digitavel do Codigo de Barras
	
	oPrint:Line ( nRow3 +2100 , nPagColIni , nRow3 +2100 , nPagColFim )
	oPrint:Line ( nRow3 +2200 , nPagColIni , nRow3 +2200 , nPagColFim )
	oPrint:Line ( nRow3 +2270 , nPagColIni , nRow3 +2270 , nPagColFim )
	oPrint:Line ( nRow3 +2340 , nPagColIni , nRow3 +2340 , nPagColFim )
	
	oPrint:Line ( nRow3 +2200,500 , nRow3 +2340,500 )
	oPrint:Line ( nRow3 +2270,750 , nRow3 +2340,750 )
	oPrint:Line ( nRow3 +2200,1000, nRow3 +2340,1000)
	oPrint:Line ( nRow3 +2200,1300, nRow3 +2270,1300)
	oPrint:Line ( nRow3 +2200,1480, nRow3 +2340,1480)
	
	oPrint:Say  ( nRow3 +2000 , nPagColIni ,"Local de Pagamento", oFont8)
	oPrint:Say  ( nRow3 +2015,400 ,"PAGAVEL EM QUALQUER BANCO AT… A DATA DO VENCIMENTO", oFont10n)
	oPrint:Say  ( nRow3 +2055,400 ,"AP”S O VENCIMENTO PAGAR SOMENTE NO "+_cBcoNome, oFont10n)
	
	oPrint:Say  ( nRow3 +2000,1810,"Vencimento", oFont8)
	cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Str( Year(aDadosTit[4]) ,4,0 )
	nCol	 	 := 1810 +(374-(len(cString)*22))
	oPrint:Say  ( nRow3 +2040,nCol,cString, oFont11c)
	
	oPrint:Say  ( nRow3 +2100 , nPagColIni ,"Benefici·rio", oFont8)
	oPrint:Say  ( nRow3 +2140 , nPagColIni ,aCedente[1]+"                  - CNPJ: "+aCedente[7]	, oFont10n) //Nome + CNPJ
	
	oPrint:Say  ( nRow3 +2100,1810,"AgÍncia/CÛdigo Benefici·rio", oFont8)
	
	If _cBcoCod == "033"
		cString := Alltrim(aBanco[3]+"/"+"0107557")
	Else
		cString := Alltrim(aBanco[3]+"/"+aBanco[4]+iif( !empty(aBanco[5]),"-"+aBanco[5],"" ))
	EndIf
	nCol 	 := 1810 +(374-(len(cString)*22))
	oPrint:Say  ( nRow3 +2140,nCol,cString , oFont11c)
	
	
	oPrint:Say  ( nRow3 +2200 , nPagColIni ,"Data do Documento"                , oFont8)
	oPrint:Say ( nRow3 +2230 , nPagColIni ,  StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Str(Year(aDadosTit[2]),4,0), oFont10n)
	
	
	oPrint:Say  ( nRow3 +2200,505 ,"Nro.Documento"                    , oFont8)
	oPrint:Say  ( nRow3 +2230,605 ,aDadosTit[1]						, oFont10n) //Prefixo +Numero+Parcela
	
	oPrint:Say  ( nRow3 +2200,1005,"EspÈcie Doc."                     , oFont8)

	If _cBcoCod $ "/033/341/"
		oPrint:Say  ( nRow3 +2230,1050,"DM"  	  					    , oFont10n) //Tipo do Titulo	
	Else
		oPrint:Say  ( nRow3 +2230,1050,aDadosTit[8]						, oFont10n) //Tipo do Titulo
	EndIf

	oPrint:Say  ( nRow3 +2200,1305,"Aceite"                           , oFont8)
	oPrint:Say  ( nRow3 +2230,1400,"N"                                , oFont10n)
	
	oPrint:Say  ( nRow3 +2200,1485,"Data do Processamento"            , oFont8)
	oPrint:Say  ( nRow3 +2230,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Str(Year(aDadosTit[3]),4,0)                               , oFont10n) // Data impressao
	
	oPrint:Say  ( nRow3 +2200,1810,"Nosso N˙mero"                     , oFont8)
	If _cBcoCod $ "/341/"
		cString := "109/" + SubStr(Alltrim(aDadosTit[6]),1,8)+"-"+SubStr(Alltrim(aDadosTit[6]),9,1)
	Else	
		cString := Alltrim(aDadosTit[6])
	EndIf

	
	nCol 	 	:= 1810 +(374-(len(cString)*20))
	oPrint:Say  ( nRow3 +2230,nCol,cString, oFont11c)
	
	oPrint:Say  ( nRow3 +2270 , nPagColIni ,"Uso do Banco"                     , oFont8)
	
	oPrint:Say  ( nRow3 +2270,505 ,"Carteira"                         , oFont8)
	oPrint:Say  ( nRow3 +2300,555 ,aBanco[6]                     , oFont10n)
	
	oPrint:Say  ( nRow3 +2270,755 ,"EspÈcie"                          , oFont8)
	oPrint:Say  ( nRow3 +2300,805 ,"R$"                               , oFont10n)
	
	oPrint:Say  ( nRow3 +2270,1005,"Quantidade"                       , oFont8)
	oPrint:Say  ( nRow3 +2270,1485,"Valor"                            , oFont8)
	
	oPrint:Say  ( nRow3 +2270,1810,"Valor do Documento"               , oFont8)
	cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
	nCol 	 := 1810 +(374-(len(cString)*22))
	oPrint:Say  ( nRow3 +2300,nCol,cString, oFont11c)
	
	oPrint:Say  ( nRow3 +2340 , nPagColIni ,"InstruÁıes (Todas informaÁıes deste bloqueto s„o de exclusiva responsabilidade do Benefici·rio)" , oFont8)
	oPrint:Say  ( nRow3 +2440 , nPagColIni ,aBolText[1]+" "+AllTrim(Transform(   aDadosTit[5] * ( nMulta/100  ) 		,"@E 99,999.99")) , oFont10n)
	oPrint:Say  ( nRow3 +2480 , nPagColIni ,aBolText[2]+" "+AllTrim(Transform( ( aDadosTit[5] * ( nMoraDia/100) )/30 	,"@E 99,999.99")) , oFont10n)
	
	If _cBcoCod $ "/341/"
		oPrint:Say  ( nRow3 +2520 , nPagColIni ,aBolText[4]                         , oFont10n)
		oPrint:Say  ( nRow3 +2560 , nPagColIni ,aBolText[5]                         , oFont10n)
    Else
	    oPrint:Say  ( nRow3 +2520 , nPagColIni ,aBolText[3]                         , oFont10n)
		oPrint:Say  ( nRow3 +2560 , nPagColIni ,aBolText[4]                         , oFont10n)
		oPrint:Say  ( nRow3 +2600 , nPagColIni ,aBolText[5]                         , oFont10n)
    EndIf

	
	oPrint:Say  ( nRow3 +2340,1810,"(-)Desconto/Abatimento"            , oFont8)
	oPrint:Say  ( nRow3 +2410,1810,"(-)Outras DeduÁıes"                , oFont8)
	oPrint:Say  ( nRow3 +2480,1810,"(+)Mora/Multa"                     , oFont8)
	oPrint:Say  ( nRow3 +2550,1810,"(+)Outros AcrÈscimos"              , oFont8)
	oPrint:Say  ( nRow3 +2620,1810,"(=)Valor Cobrado"                  , oFont8)
	
	oPrint:Say  ( nRow3 +2690 , nPagColIni ,"Pagador"                            , oFont8)
	oPrint:Say  ( nRow3 +2700,400 ,aSacado[1]+" ("+aSacado[2]+")", oFont10n)
	oPrint:Say  ( nRow3 +2753,400 ,aSacado[3]                       , oFont10n)
	oPrint:Say  ( nRow3 +2806,400 ,transform(aSacado[6],"@R 99.999-999") +"    "+aSacado[4]+" - "+aSacado[5], oFont10n) // CEP+Cidade+Estado
	
	if aSacado[8] = "J"
		oPrint:Say  ( nRow3 +2859,400,"CNPJ: "+TRANSFORM(aSacado[7],"@R 99.999.999/9999-99"), oFont10n) // CGC
	Else
		oPrint:Say  ( nRow3 +2859,400,"CPF: "+TRANSFORM(aSacado[7],"@R 999.999.999-99"), oFont10n) 	// CPF
	EndIf
	
	oPrint:Say  ( nRow3 +2859,1750, Alltrim(aDadosTit[6])  , oFont10n)
	
	oPrint:Say  ( nRow3 +2875 , nPagColIni ,"Sacador/Avalista"                  , oFont8)
	oPrint:Say  ( nRow3 +2915,1500,"AutenticaÁ„o Mec‚nica - Ficha de CompensaÁ„o" , oFont8)
	
	oPrint:Line ( nRow3 +2000,1800, nRow3 +2690,1800 )
	oPrint:Line ( nRow3 +2410,1800, nRow3 +2410 , nPagColFim )
	oPrint:Line ( nRow3 +2480,1800, nRow3 +2480 , nPagColFim )
	oPrint:Line ( nRow3 +2550,1800, nRow3 +2550 , nPagColFim )
	oPrint:Line ( nRow3 +2620,1800, nRow3 +2620 , nPagColFim )
	oPrint:Line ( nRow3 +2690 , nPagColIni , nRow3 +2690 , nPagColFim )
	
	oPrint:Line ( nRow3 +2910 , nPagColIni , nRow3 +2910 , nPagColFim  )
	
	
	MSBAR("INT25",25.5,1,aCB_LD_NN[1], oPrint,.F.,Nil,Nil,0.025,1.5,Nil,Nil,"A",.F.)
	
	//ALERT(aCB_LD_NN[3])
	
Endif

oPrint:EndPage() // Finaliza a p·gina

Return Nil

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Programa  ≥ Modulo10 ≥ Autor ≥ Microsiga             ≥ Data ≥ 13/10/03 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥ IMPRESSAO DO BOLETO LASE DO ITAU COM CODIGO DE BARRAS      ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Uso       ≥ Especifico para Clientes Microsiga                         ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Static Function Modulo10bb(cData)
LOCAL L,D,P := 0
LOCAL B     := .F.
L := Len(cData)
B := .T.
D := 0
While L > 0
	P := Val(SubStr(cData, L, 1))
	If (B)
		P := P * 2
		If P > 9
			P := P - 9
		End
	End
	D := D + P
	L := L - 1
	B := !B
End

D := 10 - (Mod(D,10))

If D = 10
	D := 0
End
Return(D)

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Programa  ≥ Modulo11 ≥ Autor ≥ Microsiga             ≥ Data ≥ 13/10/03 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥ IMPRESSAO DO BOLETO LASER DO ITAU COM CODIGO DE BARRAS     ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Uso       ≥ Especifico para Clientes Microsiga                         ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

Static Function MODULO11BB( cData )

Local cDig, nPos , nAux := 0

For nPos := 1 To 43
	nAux += Val(SubStr(cData,nPos,1)) * Iif( nPos<= 3, ( 5-nPos),     ;
	Iif( nPos<=11, (13-nPos),     ;
	Iif( nPos<=19, (21-nPos),     ;
	Iif( nPos<=27, (29-nPos),     ;
	Iif( nPos<=35, (37-nPos),     ;
	(45-nPos) )))))
Next
nAux := nAux % 11
cDig := Iif( (11-nAux)>9, 1, (11-nAux) )

Return ( cDig )



/*

Static Function Modulo11(cData)
LOCAL L, D, P := 0
L := Len(cData)   // 43
D := 0
P := 2
While L > 0
P := P + 1
D := D + (Val(SubStr(cData, L, 1)) * P)

If P = 9
P := 2
End

L := L - 1
End
D := 11 - (mod(D,11))
If (D == 0 .Or. D == 1 .Or. D == 10 .Or. D == 11)
D := 1
End

//RESTO := (D/11)-INT((D/11))
//D     :=11-RESTO
//If (D == 0  .Or. D == 10 .Or. D == 11)
//	D := 1
//End


Return(D)
*/



/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Programa  ≥Ret_cBarra≥ Autor ≥ Microsiga             ≥ Data ≥ 13/10/03 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥ IMPRESSAO DO BOLETO LASE DO ITAU COM CODIGO DE BARRAS      ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Uso       ≥ Especifico para Clientes Microsiga                         ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Ret_cBarra( cBanco , cMoeda , cAgencia , cConta , cDacCC , cNroDoc , nValor , dVencto , cConvenio , cCarteira , _cBnfAgenc , _cBnfConta , cNossoNum )
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

LOCAL cFator      	:= strzero( dVencto - ctod("07/10/97") ,4 )
LOCAL cValorFinal   := strzero((nValor*100),10)

LOCAL cCodBase		:= ''
LOCAL cCodBasDv		:= '0'

LOCAL cNosNumDv		:= '0'

LOCAL cCodBarra		:= ''
LOCAL nCodBarDv		:= 0

LOCAL cLinhaDig		:= ''


if cBanco == "001"
	
	// Banco do Brasil para convenio de 7 numeros
	
	if empty(cCarteira)
		cCarteira := "17"
	Endif
	
	if empty(cConvenio)
		if sm0->m0_codigo == '04'
			cConvenio  := "2474857"
		Else
			cConvenio  := "2129572"
		Endif
	Endif
	
	//-----------------------------
	// Definicao do NOSSO NUMERO
	// ----------------------------
	
	cNossoNum   := cConvenio + cNroDoc
	
	//----------------------------------
	//	 Definicao do CODIGO DE BARRAS
	//----------------------------------
	
	
	cCodBase	:= cBanco + cMoeda + cFator + cValorFinal + "000000" + cNossoNum + cCarteira
	
	nCodBarDv	:= modulo11bb(cCodBase)
	
	//             1 (3)  	4 (1)    5 (1)                           6 (4)    10 (10)       20 (6)     26 (17)     			43 (2)
	cCodBarra   := cBanco + cMoeda + AllTrim( Str(nCodBarDv,1,0) ) + cFator + cValorFinal + "000000" + cNossoNum 		  + cCarteira
	//             AAA      B        C								 DDDD     EEEEEEEEEE    FFFFFF     GGGGGGGGGGGGGGGGG    HH
	
	//----------------------------------
	//	 Linha Digitavel
	//----------------------------------
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
	//	AAABF.FFFFX		FGGGG.GGGGGY	GGGGG.GGGHHZ	C			DDDDEEEEEEEEEE
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	//
	// 	CAMPO 1: AAABF.FFFFX
	//
	
	//	AAA		= Posicao 1 a 3 do Codigo de Barras. Codigo do banco na Camara de Compensacao
	//	B 		= Posicao 4 do Codigo de Barras. Codigo da moeda
	//	FFFFF	= Posicao 20 a 24 do Codigo de Barras. Constante "00000"
	//	X 		= DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
	
	cCodBase 	:= Substr(cCodBarra,01,04) + Substr(cCodBarra,20,5)
	cCodBasDv   := modulo10bb(cCodBase)
	
	cLinhaDig   := SubStr(cCodBase, 1, 5) + "." + SubStr(cCodBase, 6, 4) + AllTrim(Str(cCodBasDv)) + "  "
	
	//
	// 	CAMPO 2: FGGGG.GGGGGY
	//
	
	//	F      	  = Posicao 25 Codigo de Barras "0"
	//	GGGGGGGGG = Posicao 26 A 34 do Codigo de Barras. Posicoes de 1 a 9 do Nosso Numero (convenio e 2 primeiras posicoes do Documento)
	//	Y 		  = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
	
	cCodBase   	:= Substr(cCodBarra,25,10)
	cCodBasDv   := modulo10bb(cCodBase)
	
	cLinhaDig   += Substr(cCodBase,1,5)+"."+Substr(cCodBase,6,5)+Alltrim(Str(cCodBasDv)) + "  "
	
	//
	// 	CAMPO 3: GGGGG.GGGHHZ
	//
	
	//	GGGGGGGGGG 	= Posicao 35 A 42 do Codigo de Barras , Posicoes de 10 a 17 do Nosso Numero ( 8 ultimas posicoes do Documento)
	//	HH			= Posicao 43 A 44 do Codigo de Barras (Carteira)
	//	Z 			= DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
	
	cCodBase   	:= Substr(cCodBarra,35,10)
	cCodBasDv   := modulo10bb(cCodBase)
	
	cLinhaDig   += Substr(cCodBase,1,5)+"."+Substr(cCodBase,6,5)+Alltrim(Str(cCodBasDv)) + "  "
	
	//
	//	CAMPO 4: C
	//
	
	//	C 		= DAC do Codigo de Barras
	
	cLinhaDig   += " "+ Substr(cCodBarra,05,01) + "  "
	
	//
	// 	CAMPO 5: DDDDEEEEEEEEEE
	//
	
	//	DDDD 		= Fator de Vencimento
	//	EEEEEEEEEE 	= Valor do Titulo
	
	cLinhaDig   += Substr(cCodBarra,06,14)
	
ElseIf	cBanco == "033"
	
	// 	Santander
	

	cCarteira := "101"
	cConvenio := "0107557"
	
	//-----------------------------
	// Definicao do NOSSO NUMERO
	// ----------------------------
	
	cNossoNum   := U_NSN_033(SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_PREFIXO) // Funcao que calcula o Nosso Numero do banco Santander - 8 posicoes
	
	//----------------------------------
	//	 Definicao do CODIGO DE BARRAS
	//----------------------------------
	
	cCodBase   	:= cBanco + cMoeda + cFator + cValorFinal + "9" + cConvenio + cNossoNum + "0" + cCarteira
	
	cCodBarDv 	:= alltrim(modulo11(cCodBase,2,9))
	
	if cCodBarDv == "0" .or. cCodBarDv == "1" .or. VAL( cCodBarDv ) > 9
		cCodBarDv 	:= "1"
	Endif
	
	//             1 (3)  	4 (1)    5 (1)       6 (4)    10 (10)       20 (1)   21 (7)      28 (5)    33 (8)         41 (1)   42 (3)
	cCodBarra   := cBanco + cMoeda + cCodBarDv + cFator + cValorFinal + "9"    + cConvenio + cNossoNum   + "0"   +  cCarteira
	//             AAA      B        C			 DDDD     EEEEEEEEEE     F       GGGGGGG      HHHHH    IIIIIIII       J       KKK
	
	//----------------------------------
	//	 Linha Digitavel
	//----------------------------------
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
	//	AAABF.GGGGX		GGGHH.HHHHH		HHHHH.HIJJJZ	C			DDDDEEEEEEEEEE
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	//
	// 	CAMPO 1: AAABF.GGGGX
	//
	
	//	AAA		= Posicao 1 a 3 do Codigo de Barras. Codigo do banco na Camara de Compensacao.
	//	B 		= Posicao 4 do Codigo de Barras. Codigo da moeda.
	//	F     	= Posicao 20 do Codigo de Barras. Constante "9".
	//	GGGG	= Posicao 21 a 24 do Codigo de Barras. Posicao de 1 a 4 do Convenio.
	//	X 		= DAC que amarra o campo, calculado pelo Modulo 10 da String do campo.
	
	cCodBase  := Substr(cCodBarra,01,04) + Substr(cCodBarra,20,05)
	cCodBasDv := modulo10(cCodBase)
	
	cLinhaDig := SubStr(cCodBase, 1, 5) + "." + SubStr(cCodBase, 6, 4) + cCodBasDv + "  "
	
	//
	// 	CAMPO 2: GGGHH.HHHIIY
	//
	
	//	GGG  	= Posicao 25 a 27 do Codigo de Barras. Posicao de 5 a 7 do Convenio.
	//	HHHHH  	= Posicao 28 a 32 do Constante com 00000 para NOSSO NUMERO de 8 posicoes.
	//	II     	= Posicao 33 a 34 do Codigo de Barras. Posicao de 1 a 2 do NOSSO NUMERO.
	//	Y 		= DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
	
	cCodBase  := Substr(cCodBarra,25,10)
	cCodBasDv := modulo10(cCodBase)
	
	cLinhaDig += Substr(cCodBase,1,5) + "." + Substr(cCodBase,6,5)+ cCodBasDv + "  "
	
	//
	// 	CAMPO 3: IIIII.IJKKKZ
	//
	
	//	IIIIII	= Posicao 35 a 40 do Codigo de Barras. Posicao de 3 a 8 do NOSSO NUMERO.
	//	J    	= Posicao 41 do Codigo de Barras. Constante "0" (ZERO), IOS de seguradoras.
	//	KKK		= Posicao 42 a 44 do Codigo de Barras. Codigo da carteira utilizada.
	//	Z 		= DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
	
	cCodBase  := Substr(cCodBarra,35,10)
	cCodBasDv := modulo10(cCodBase)
	
	cLinhaDig += Substr(cCodBase,1,5) + "." + Substr(cCodBase,6,5) + cCodBasDv + "  "
	
	//
	//	CAMPO 4: C
	//
	
	//	C 		= DAC do Codigo de Barras
	
	cLinhaDig   += " "+ Substr(cCodBarra,05,01) + "  "
	
	//
	// 	CAMPO 5: DDDDEEEEEEEEEE
	//
	
	//	DDDD 		= Fator de Vencimento
	//	EEEEEEEEEE 	= Valor do Titulo
	
	cLinhaDig  += Substr(cCodBarra,06,14)
	
ElseIf	cBanco == "341"
	
	// 	Santander
	

	cCarteira := "109"
	
	
	//-----------------------------
	// Definicao do NOSSO NUMERO
	// ----------------------------
	
	cNossoNum   := U_NSN_341(SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_PREFIXO,SE1->E1_PORTADO, Alltrim(SE1->E1_AGEDEP), Alltrim(SE1->E1_CONTA), cCarteira) // Funcao que calcula o Nosso Numero do banco Santander - 8 posicoes
	
	//----------------------------------
	//	 Definicao do CODIGO DE BARRAS
	//----------------------------------
	
	cCodBase   	:= cBanco + cMoeda + cFator + cValorFinal  + cCarteira + cNossoNum + Alltrim(SE1->E1_AGEDEP) + Alltrim(SE1->E1_CONTA) + "0" + "000"
	
//	cCodBarDv 	:= alltrim(modulo11(cCodBase,2,9))
cCodBarDv 	:= alltrim(modulo11(cCodBase))
	
	if cCodBarDv == "0" .or. cCodBarDv == "1" .or. cCodBarDv == "10" .Or. cCodBarDv == "11"
		cCodBarDv 	:= "1"
	Endif
	
	//             1 (3)  	4 (1)    5 (1)       6 (4)    10 (10)       20 (1)   21 (7)      28 (5)    33 (8)         41 (1)   42 (3)
	cCodBarra   := cBanco + cMoeda + cCodBarDv + cFator + cValorFinal + cCarteira    + cNossoNum   + Alltrim(SE1->E1_AGEDEP) + Alltrim(SE1->E1_CONTA) + "0" + "000"
	//             AAA      B        C			 DDDD     EEEEEEEEEE     F       GGGGGGG      HHHHH    IIIIIIII       J       KKK
	
	//----------------------------------
	//	 Linha Digitavel
	//----------------------------------
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
	//	AAABF.GGGGX		GGGHH.HHHHH		HHHHH.HIJJJZ	C			DDDDEEEEEEEEEE
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	//
	// 	CAMPO 1: AAABF.GGGGX
	//
	
	//	AAA		= Posicao 1 a 3 do Codigo de Barras. Codigo do banco na Camara de Compensacao.
	//	B 		= Posicao 4 do Codigo de Barras. Codigo da moeda.
	//	F     	= Posicao 20 do Codigo de Barras. Constante "9".
	//	GGGG	= Posicao 21 a 24 do Codigo de Barras. Posicao de 1 a 4 do Convenio.
	//	X 		= DAC que amarra o campo, calculado pelo Modulo 10 da String do campo.
	
	cCodBase  := Substr(cCodBarra,01,04) + Substr(cCodBarra,20,05)
	cCodBasDv := modulo10(cCodBase)
	
	cLinhaDig := SubStr(cCodBase, 1, 5) + "." + SubStr(cCodBase, 6, 4) + cCodBasDv + "  "
	
	//
	// 	CAMPO 2: GGGHH.HHHIIY
	//
	
	//	GGG  	= Posicao 25 a 27 do Codigo de Barras. Posicao de 5 a 7 do Convenio.
	//	HHHHH  	= Posicao 28 a 32 do Constante com 00000 para NOSSO NUMERO de 8 posicoes.
	//	II     	= Posicao 33 a 34 do Codigo de Barras. Posicao de 1 a 2 do NOSSO NUMERO.
	//	Y 		= DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
	
	cCodBase  := Substr(cCodBarra,25,10)
	cCodBasDv := modulo10(cCodBase)
	
	cLinhaDig += Substr(cCodBase,1,5) + "." + Substr(cCodBase,6,5)+ cCodBasDv + "  "
	
	//
	// 	CAMPO 3: IIIII.IJKKKZ
	//
	
	//	IIIIII	= Posicao 35 a 40 do Codigo de Barras. Posicao de 3 a 8 do NOSSO NUMERO.
	//	J    	= Posicao 41 do Codigo de Barras. Constante "0" (ZERO), IOS de seguradoras.
	//	KKK		= Posicao 42 a 44 do Codigo de Barras. Codigo da carteira utilizada.
	//	Z 		= DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
	
	cCodBase  := Substr(cCodBarra,35,10)
	cCodBasDv := modulo10(cCodBase)
	
	cLinhaDig += Substr(cCodBase,1,5) + "." + Substr(cCodBase,6,5) + cCodBasDv + "  "
	
	//
	//	CAMPO 4: C
	//
	
	//	C 		= DAC do Codigo de Barras
	
	//cLinhaDig   += " "+ Substr(cCodBarra,05,01) + "  "
	  cLinhaDig   += " "+ Alltrim(cCodBarDv) + "  "
	
	//
	// 	CAMPO 5: DDDDEEEEEEEEEE
	//
	
	//	DDDD 		= Fator de Vencimento
	//	EEEEEEEEEE 	= Valor do Titulo
	
	cLinhaDig  += Substr(cCodBarra,06,14)



ElseIf	cBanco == "237"
	
	// 	Bradesco / Daycoval
	
	if empty(cCarteira)
		cCarteira := "09"
	Endif
	
	//-----------------------------
	// Definicao do NOSSO NUMERO
	// ----------------------------
	
	if empty( cNossoNum )
		
		cNossoBase  := strzero( val( nossonum() ), 11 , 0 )
		
		//cNossoDV    := modulo11( cCarteira + cNossoBase , 2 , 7 )
		
		cBaseDv    	:= cCarteira + cNossoBase
		
		nNossoDV    := 0
		
		nNossoDV    += val ( substr( cBaseDv ,  1 , 1 ) )  * 2
		nNossoDV    += val ( substr( cBaseDv ,  2 , 1 ) )  * 7
		nNossoDV    += val ( substr( cBaseDv ,  3 , 1 ) )  * 6
		nNossoDV    += val ( substr( cBaseDv ,  4 , 1 ) )  * 5
		nNossoDV    += val ( substr( cBaseDv ,  5 , 1 ) )  * 4
		nNossoDV    += val ( substr( cBaseDv ,  6 , 1 ) )  * 3
		nNossoDV    += val ( substr( cBaseDv ,  7 , 1 ) )  * 2
		nNossoDV    += val ( substr( cBaseDv ,  8 , 1 ) )  * 7
		nNossoDV    += val ( substr( cBaseDv ,  9 , 1 ) )  * 6
		nNossoDV    += val ( substr( cBaseDv , 10 , 1 ) )  * 5
		nNossoDV    += val ( substr( cBaseDv , 11 , 1 ) )  * 4
		nNossoDV    += val ( substr( cBaseDv , 12 , 1 ) )  * 3
		nNossoDV    += val ( substr( cBaseDv , 13 , 1 ) )  * 2
		
		// alert(nNossoDV)
		
		nNossoDV    := ( nNossoDV % 11 )

		// alert(nNossoDV)
		
		if nNossoDV == 1
			cNossoDV := "P"
		ElseIf nNossoDV == 0
			cNossoDV := "0"
		Else
			cNossoDV := str( 11 - nNossoDV , 1 , 0 )
		Endif
		
		// alert(cNossoDV)
		
		cNossoNum   := cNossoBase + cNossoDV
		
		// alert(cNossoNum)
		
	Else
		
		cNossoBase := substr( cNossoNum , 01 , 11 )
		
		if _lteste
			cNossoNum   := cNossoBase + modulo11( cCarteira + cNossoBase , 2 , 7 )
		Endif
		
	Endif
	
	cCodBarDv   := "0"
	
	//----------------------------------
	//	 Definicao do CODIGO DE BARRAS
	//----------------------------------
	
	//             1 (3)  	4 (1)    5 (1)       6 (4)    10 (10)       20 (4)  					24 (2)      	26 (11)   		37 (7)         				44 (1)
	cCodBarra   := cBanco + cMoeda + cCodBarDv + cFator + cValorFinal +	substr(_cBnfAgenc,1,4)	+  	cCarteira 	+ 	cNossoBase 	+	substr(_cBnfConta,1,7)	+ 	"0"
	//             AAA      B        C			 DDDD     EEEEEEEEEE    FFFF      					GG       		HHHHHHHHHHH     IIIIIII    					J
	
	if len(cCodBarra) <> 44
		alert("Codigo de barra Bradesco (237) diferente de 44 posiÁıes!")
		alert("Codigo: "+TRANSFORM(cCodBarra,"@R 999.9.9.9999.9999999999.9999.99.99999999999.9999999.9") )
	Endif
	
	cCodBase   	:= substr( cCodBarra , 1 , 4 ) + substr( cCodBarra , 6 )
	
	cCodBarDv 	:= alltrim( modulo11(cCodBase,2,9) )
	
	if cCodBarDv == '0' .or. cCodBarDv == '1' .or. val( cCodBarDv ) > 9
		cCodBarDv   := "1"
	Endif
	
	cCodBarra   := cBanco + cMoeda + cCodBarDv + cFator + cValorFinal +	substr(_cBnfAgenc,1,4)	+  	cCarteira 	+  cNossoBase 	+	substr(_cBnfConta,1,7)	+ 	"0"
	
	
	//----------------------------------
	//	 Linha Digitavel
	//----------------------------------
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//	Campo 1			Campo 2			Campo 3			Campo 4	Campo 5
	//	AAABF.GGGG X	GHHHH.HHHHH Y	HHIII.IIIIJ Z	C		DDDDEEEEEEEEEE
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	//
	// 	CAMPO 1: AAABF.GGGG X
	//
	
	//	AAA		= Posicao 1 a 3 do Codigo de Barras. Codigo do banco na Camara de Compensacao.
	//	B 		= Posicao 4 do Codigo de Barras. Codigo da moeda.
	//	FFFF  	= Posicao 20 a 23 do Codigo de Barras. Agencia do Beneficiario
	//	G   	= Posicao 24 do Codigo de Barras. Primeira posicao da Carteira.
	//	X 		= DAC que amarra o campo, calculado pelo Modulo 10 da String do campo.
	
	cCodBase  := Substr(cCodBarra,01,04) + Substr(cCodBarra,20,05)
	cCodBasDv := modulo10(cCodBase)
	
	cLinhaDig := SubStr(cCodBase, 1, 5) + "." + SubStr(cCodBase, 6, 4) + cCodBasDv + " "
	
	//
	// 	CAMPO 2: GHHHH.HHHHH Y
	//
	
	//	G    	= Posicao 25 do Codigo de Barras. Segunda posicao da Carteira.
	//	HHHH   	= Posicao 26 a 29 do Codigo de Barras. Posicao 1 a 4 do Nosso Numero.
	//	HHHHH  	= Posicao 30 a 34 do Codigo de Barras. Posicao 5 a 9 do Nosso Numero.
	//	Y 		= DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
	
	cCodBase  := Substr(cCodBarra,25,10)
	cCodBasDv := modulo10(cCodBase)
	
	cLinhaDig += Substr(cCodBase,1,5) + "." + Substr(cCodBase,6,5)+ cCodBasDv + " "
	
	//
	// 	CAMPO 3: HHIII.IIIIJ Z
	//
	
	//	HH     	= Posicao 35 a 36 do Codigo de Barras. Posicao 10 a 11 do Nosso Numero.
	//	III    	= Posicao 37 a 39 do Codigo de Barras. Posicao 1 a 3 da Conta do Beneficiario.
	//	IIII   	= Posicao 40 a 43 do Codigo de Barras. Posicao 4 a 7 da Conta do Beneficiario.
	//	J      	= Posicao 44 do Codigo de Barras. Constante Zero (0).
	//	Z 		= DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
	
	cCodBase  := Substr(cCodBarra,35,10)
	cCodBasDv := modulo10(cCodBase)
	
	cLinhaDig += Substr(cCodBase,1,5) + "." + Substr(cCodBase,6,5) + cCodBasDv + " "
	
	//
	//	CAMPO 4: C
	//
	
	//	C 		= DAC do Codigo de Barras
	
	cLinhaDig   += Substr(cCodBarra,05,01) + " "
	
	//
	// 	CAMPO 5: DDDDEEEEEEEEEE
	//
	
	//	DDDD 		= Fator de Vencimento
	//	EEEEEEEEEE 	= Valor do Titulo
	
	cLinhaDig  += Substr(cCodBarra,06,14)
	
Else
	
	cCodBase  	:= cAgencia + cConta + cCarteira + cNroDoc
	cNosNumDv 	:= modulo10(cCodBase)     // digito verifacador Agencia + Conta + Carteira + Nosso Num
	cNossoNum   := AllTrim(Str(nNosNumDv))
	
Endif


Return( { cCodBarra , cLinhaDig , cNossoNum } )


///////////////////////////////////////////////
///////////////////////////////////////////////
Static Function AjustaSX1(cPerg)
///////////////////////////////////////////////
///////////////////////////////////////////////
Local _sAlias	:= Alias()
Local aCposSX1	:= {}
Local nX 		:= 0
Local lAltera	:= .F.
Local cKey		:= ""
Local nJ		:= 0
Local aPergs 	:= {}

Aadd(aPergs,{"De Prefixo"		,"","","mv_ch1","C",3,0,0,"G","","MV_PAR01","","","",""			,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Ate Prefixo"		,"","","mv_ch2","C",3,0,0,"G","","MV_PAR02","","","","ZZZ"		,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"De Numero"		,"","","mv_ch3","C",9,0,0,"G","","MV_PAR03","","","",""			,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Ate Numero"		,"","","mv_ch4","C",9,0,0,"G","","MV_PAR04","","","","ZZZZZZ"	,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"De Parcela"		,"","","mv_ch5","C",1,0,0,"G","","MV_PAR05","","","",""			,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Ate Parcela"		,"","","mv_ch6","C",1,0,0,"G","","MV_PAR06","","","","Z"		,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"De Portador"		,"","","mv_ch7","C",3,0,0,"G","","MV_PAR07","","","",""			,"","","","","","","","","","","","","","","","","","","","","SA6"	,"","","",""})
Aadd(aPergs,{"Ate Portador"		,"","","mv_ch8","C",3,0,0,"G","","MV_PAR08","","","","ZZZ"		,"","","","","","","","","","","","","","","","","","","","","SA6"	,"","","",""})
Aadd(aPergs,{"De Cliente"		,"","","mv_ch9","C",6,0,0,"G","","MV_PAR09","","","",""			,"","","","","","","","","","","","","","","","","","","","","SE1"	,"","","",""})
Aadd(aPergs,{"Ate Cliente"		,"","","mv_cha","C",6,0,0,"G","","MV_PAR10","","","","ZZZZZZ"	,"","","","","","","","","","","","","","","","","","","","","SE1"	,"","","",""})
Aadd(aPergs,{"De Loja"			,"","","mv_chb","C",2,0,0,"G","","MV_PAR11","","","",""			,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Ate Loja"			,"","","mv_chc","C",2,0,0,"G","","MV_PAR12","","","","ZZ"		,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"De Emissao"		,"","","mv_chd","D",8,0,0,"G","","MV_PAR13","","","","01/01/80"	,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Ate Emissao"		,"","","mv_che","D",8,0,0,"G","","MV_PAR14","","","","31/12/03"	,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"De Vencimento"	,"","","mv_chf","D",8,0,0,"G","","MV_PAR15","","","","01/01/80"	,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Ate Vencimento"	,"","","mv_chg","D",8,0,0,"G","","MV_PAR16","","","","31/12/03"	,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Do Bordero"		,"","","mv_chh","C",6,0,0,"G","","MV_PAR17","","","",""			,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Ate Bordero"		,"","","mv_chi","C",6,0,0,"G","","MV_PAR18","","","","ZZZZZZ"	,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})


aCposSX1:={"X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO",;
"X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID",;
"X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1","X1_CNT01",;
"X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02",;
"X1_VAR03","X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03",;
"X1_VAR04","X1_DEF04","X1_DEFSPA4","X1_DEFENG4","X1_CNT04",;
"X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05",;
"X1_F3", "X1_GRPSXG", "X1_PYME","X1_HELP" }

dbSelectArea("SX1")
dbSetOrder(1)

For nX:=1 to Len(aPergs)
	
	lAltera := .F.
	
	If MsSeek(cPerg+Right(aPergs[nX][11], 2))
		If (ValType(aPergs[nX][Len(aPergs[nx])]) = "B" .And.;
			Eval(aPergs[nX][Len(aPergs[nx])], aPergs[nX] ))
			aPergs[nX] := ASize(aPergs[nX], Len(aPergs[nX]) - 1)
			lAltera := .T.
		Endif
	Endif
	
	If ! lAltera .And. Found() .And. X1_TIPO <> aPergs[nX][5]
		lAltera := .T.
	Endif
	
	If ! Found() .Or. lAltera
		RecLock("SX1",If(lAltera, .F., .T.))
		Replace X1_GRUPO with cPerg
		Replace X1_ORDEM with Right(aPergs[nX][11], 2)
		For nj:=1 to Len(aCposSX1)
			If 	Len(aPergs[nX]) >= nJ .And. aPergs[nX][nJ] <> Nil .And.;
				FieldPos(AllTrim(aCposSX1[nJ])) > 0
				Replace &(AllTrim(aCposSX1[nJ])) With aPergs[nx][nj]
			Endif
		Next nj
		MsUnlock()
		cKey := "P."+AllTrim(X1_GRUPO)+AllTrim(X1_ORDEM)+"."
		
		If ValType(aPergs[nx][Len(aPergs[nx])]) = "A"
			aHelpSpa := aPergs[nx][Len(aPergs[nx])]
		Else
			aHelpSpa := {}
		Endif
		
		If ValType(aPergs[nx][Len(aPergs[nx])-1]) = "A"
			aHelpEng := aPergs[nx][Len(aPergs[nx])-1]
		Else
			aHelpEng := {}
		Endif
		
		If ValType(aPergs[nx][Len(aPergs[nx])-2]) = "A"
			aHelpPor := aPergs[nx][Len(aPergs[nx])-2]
		Else
			aHelpPor := {}
		Endif
		
		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
		
	Endif
	
Next

//////////////////////////////////////////////////////////////////////
user function DOC_033(_PREFIXO,_NUM,_PARCELA)
//////////////////////////////////////////////////////////////////////
// Numero do Documento do banco Santader
// Usado tanto para o Boleto como para arquivo CNAB 400.
//////////////////////////////////////////////////////////////////////
local cNroDoc

if _PREFIXO == nil
	_PREFIXO := SE1->E1_PREFIXO
Endif

if _NUM == nil
	_NUM := SE1->E1_NUM
Endif

if _PARCELA == nil
	_PARCELA := SE1->E1_PARCELA
Endif

cNroDoc := StrZero(	Val(Alltrim(_PREFIXO)) , 3 ) + strzero( val(Alltrim(SUBSTR(_NUM,4,6))) , 6 )  + IIF( empty( Alltrim(_PARCELA) ) , "1" , Alltrim(_PARCELA) )

return(cNroDoc)

//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
user function NSN_033(_NUM,_PARCELA,_PREFIXO)
//////////////////////////////////////////////////////////////////////
// Calculo do Nosso Numero para banco 033 - Santander com 8 posicooes
// Usado tanto para o Boleto como para arquivo CNAB 400.
//////////////////////////////////////////////////////////////////////
local cNosNumDv

if _NUM == nil
	_NUM := SE1->E1_NUM
Endif

if _PREFIXO == nil
	_PREFIXO := SE1->E1_PREFIXO
Endif

if _PARCELA == nil
	_PARCELA := SE1->E1_PARCELA
Endif



//cCodBase  	:= StrZero( Val( Alltrim( SUBSTR(_NUM,4,6) ) ) , 6 ) + IIF( empty(Alltrim(_PARCELA)), "1" , Alltrim(_PARCELA) )
cCodBase  	:= SUBSTR(_PREFIXO,2,2) + Alltrim( _NUM) + IIF( empty(Alltrim(_PARCELA)), "1" , Alltrim(_PARCELA) )

cNosNumDv 	:= alltrim(modulo11(cCodBase,2,9))

cNossoNum   := cCodBase + cNosNumDv

return(cNossoNum)

//////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
user function NSN_341(_NUM,_PARCELA,_PREFIXO, _CPORTADO, _CAGEDEP, _CCONTA, cCarteira)
//////////////////////////////////////////////////////////////////////
// Calculo do Nosso Numero para banco 033 - Santander com 8 posicooes
// Usado tanto para o Boleto como para arquivo CNAB 400.
//////////////////////////////////////////////////////////////////////
local cNosNumDv

if _NUM == nil
	_NUM := SE1->E1_NUM
Endif

if _PREFIXO == nil
	_PREFIXO := SE1->E1_PREFIXO
Endif

if _PARCELA == nil
	_PARCELA := SE1->E1_PARCELA
Endif

if _CPORTADO == nil
	_CPORTADO := SE1->E1_PORTADO
Endif

if _CAGEDEP == nil
	_CAGEDEP := Alltrim(SE1->E1_AGEDEP)
Endif

if _CCONTA == nil
	_CCONTA := Alltrim(SE1->E1_CONTA)
Endif

if cCarteira == nil
	cCarteira := "109"
Endif


//cCodBase  	:= StrZero( Val( Alltrim( SUBSTR(_NUM,4,6) ) ) , 6 ) + IIF( empty(Alltrim(_PARCELA)), "1" , Alltrim(_PARCELA) )
cCodBase  	:= SUBSTR(_CAGEDEP,1,4) + SUBSTR(_CCONTA,1,5) + cCarteira + SUBSTR(_PREFIXO,3,1) + SUBSTR( _NUM,4,6) + IIF( empty(Alltrim(_PARCELA)), "1" , Alltrim(_PARCELA) )
_cCodBase   := SUBSTR(_PREFIXO,3,1) + SUBSTR( _NUM,4,6) + IIF( empty(Alltrim(_PARCELA)), "1" , Alltrim(_PARCELA) )
 
cNosNumDv 	:= alltrim(modulo10(cCodBase))

cNossoNum   := _cCodBase + cNosNumDv

return(cNossoNum)

//////////////////////////////////////////////////////////////////////


// TMSPrinter(): Say ( [ nRow], [ nCol], [ cText], [ oFont], [ nWidth], [ nClrText], [ uParam7], [ nAlign] )
//
// 		Nome 		Tipo 		DescriÁ„o
// 1 - 	nRow 		NumÈrico 	Indica a coordenada vertical em pixels ou caracteres.
// 2 - 	nCol 		NumÈrico 	Indica a coordenada horizontal em pixels ou caracteres.
// 3 - 	cText 		Caracter 	Indica o texto que ser· impresso.
// 4 - 	oFont 		Objeto 		Indica o objeto do tipo TFont utilizado para definir as caracterÌsticas da fonte aplicada na exibiÁ„o do conte˙do do controle visual.
// 5 - 	nWidth 		NumÈrico 	Indica a largura em pixels do objeto.
// 6 - 	nClrText	NumÈrico 	Indica a cor do texto do objeto.
// 7 - 	uParam7 	Nulo 		Mantido por compatibilidade, caso informado deve ser NIL.
// 8- 	nAlign 		NumÈrico 	Indica o alinhamento do texto : 0 - (Padr„o) Alinhado ‡ esquerda. 1 - Alinhado ‡ direita. 2 - Centraliza o texto.
