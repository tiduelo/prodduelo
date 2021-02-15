#INCLUDE "PROTHEUS.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TKC020      ºAutor  ³Armando M. Tessaroliº Data ³  28/08/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Monta uma consulta com todos os titulos negociados em atendi- º±±
±±º          ³mentos do telecobranca do call center. Para cada titulo nego- º±±
±±º          ³ciado, exibe os atendimentos que foram realizados.            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³FINC010                                                       º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄº±±
±±³Analista  ³ Data/Bops/Ver ³Manutencao Efetuada                           º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄº±±
±±³Andrea F. ³06/04/04³811   ³- Compatibilizacao do layout da DIALOG com as º±±
±±³          ³        ³      ³outras opcoes de consulta da rotina.          º±±
±±³Hanna C.  ³14/02/07³811   ³- BOPS 119268 - Inclusao do ponto de entrada  º±±
±±³          ³        ³      ³TKC20Hist, que sera acionado ao clicar no bo- º±±
±±³          ³        ³      ³tao historico de cobranca, substituindo a telaº±±
±±³          ³        ³      ³consulta posição do cliente 					º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TKC20Hist()
Local aSize     := MsAdvSize( .F. )					// Array para dimensionar a tela de posicao do cliente    
Local _aArea	 := GetArea()			   //Seleciona a area para ser restaurada ao final
Local _nHeight			//Define tamanho da tela
Local _nWidth			//Define tamanho da tela
Local _oLB01				   				   //Listbox do Cabecalho 			- contem todos os titulos da empresa - ZCG
Local _aCabeca	:= {}							//Array com os registros do ZCG - representa os titulos cobrados
Local _oLB02				   					//Listbox dos Itens da consulta - contem todas os atendimentos de um titulo - ZCF
Local _aItens	:= {}							//Array com os registros do ZCF - representa os atendimentos(cobranca) de cada titulo
Local _oObs										//Objeto para as observacoes
Local _cObs										//Observacao digitada
Local aButtons := {}
Local oBtn
Private oDlg1

DbSelectArea("ZCG")
DbSetOrder(1)

DEFINE MSDIALOG oDlg1 FROM aSize[7],0 TO aSize[6],aSize[5] TITLE "Consulta negociações do Telecobranças" OF oMainWnd PIXEL 
	
Aadd( aButtons, {"COBRANÇA"     , {||  U_TeleCob()},"Incl. Cobrança..." ,"Incl. Cobrança"    , {|| .T.}} )  
Aadd( aButtons, {"Conhecimento" , {|| MSDOCUMENT("ZCF", ZCF->(RecNo()),4)},"Anexar Arq.","Anexar Arq." , {|| .T.}} )   
Aadd( aButtons, {"Relatorio"     , {||  U_RelatZCF()},"Relatório Cobrança..." ,"Relatório Cobrança"    , {|| .T.}} )  
Aadd( aButtons, {"WorkFlow"     , {||  U_QryAluCob()},"WorkFlow..." ,"Workflow"    , {|| .T.}} )  


_nHeight	:= oDlg1:nHeight / 2		
_nWidth	:= oDlg1:nWidth / 2

EnchoiceBar(oDlg1, {|| oDlg1:End()}, {|| oDlg1:End()},,@aButtons)



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta o cabecalho desta consulta, neste caso os itens do telecobranca³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_aCabeca := U_UTK020ListBox("ZCG")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta o Listbox do Cabecalho ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ (_nHeight*.08),(_nWidth*.02) ListBox _oLB01 Fields;
		Header	"Prefixo",; 
				"Titulo",; 
				"Parcela",; 
				"Tipo",; 
				"Natureza",;
			 	"Vencimento",;
				"Venc.Real",; 
				"Valor",; 
				"Acrescimo",;
				"Desconto",; 
				"Status",; 
				"Responsável",;
				"Nome",; 
				"Histórico"; 
		Size (_nWidth*.95),(_nHeight*.45) NoScroll Of oDlg1 Pixel

_oLB01:SetArray(_aCabeca)
_oLB01:bLine:={||{	_aCabeca[_oLB01:nAt,1],;
					_aCabeca[_oLB01:nAt,2],;
					_aCabeca[_oLB01:nAt,3],;
					_aCabeca[_oLB01:nAt,4],;
					_aCabeca[_oLB01:nAt,5],;
					_aCabeca[_oLB01:nAt,6],;
					_aCabeca[_oLB01:nAt,7],;
					_aCabeca[_oLB01:nAt,8],;
					_aCabeca[_oLB01:nAt,9],;
					_aCabeca[_oLB01:nAt,10],;
					_aCabeca[_oLB01:nAt,11],;
					_aCabeca[_oLB01:nAt,12],;
					_aCabeca[_oLB01:nAt,13],;
					_aCabeca[_oLB01:nAt,14];
					}}
_oLB01:nAt := 1

_oLB01:bChange := {||	_aItens := U_UTK020ListBox("ZCF", _aCabeca[_oLB01:nAt][len(_aCabeca[1])]),;
						_oLB02:SetArray(_aItens),;
						_oLB02:bLine:={||{	_aItens[_oLB02:nAt,1],;
											_aItens[_oLB02:nAt,2],;
											_aItens[_oLB02:nAt,3],;
											_aItens[_oLB02:nAt,4],;
											_aItens[_oLB02:nAt,5],;
											_aItens[_oLB02:nAt,6],;
											_aItens[_oLB02:nAt,7],;
											_aItens[_oLB02:nAt,8],;
											_aItens[_oLB02:nAt,9]}},;
						_oLB02:nAt := 1,;
						_oLB02:Refresh(),;
						ZCF->( DbSetOrder(1) ),;
						ZCF->( DbSeek(xFilial("ZCF") + Eval(_oLB02:bLine)[1]) ),;
						_cObs := MSMM(ZCF->ZCF_CODOBS,80),;
						_oObs:Refresh();
					}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta um browser tipo MSGetDados Read Only dos itens³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ (_nHeight*.55),(_nWidth*.02) ListBox _oLB02 Fields;
  			Header	"Atendimento",;
					"Dt. Atend.",;	
					"Dt. Retor.",;
					"Hr. Retor.",;	
					"Telefone",;	
					"Contato",;
					"E-mail",;	
					"Motivo",;
					"Descrição";
			Size (_nWidth*.7),(_nHeight*.35) NoScroll Of oDlg1 Pixel

_oLB02:SetArray(_aItens)
_oLB02:bLine:={||{	_aItens[_oLB02:nAt,1],;
					_aItens[_oLB02:nAt,2],;
					_aItens[_oLB02:nAt,3],;
					_aItens[_oLB02:nAt,4],;
					_aItens[_oLB02:nAt,5],;
					_aItens[_oLB02:nAt,6],;
					_aItens[_oLB02:nAt,7],;
					_aItens[_oLB02:nAt,8],;
					_aItens[_oLB02:nAt,9];
					}}
_oLB02:nAt := 1

_oLB02:bChange := {||	ZCF->( DbSetOrder(1) ),;                                             
						ZCF->( DbSeek(xFilial("ZCF") + Eval(_oLB02:bLine)[1]) ),;
						_cObs := MSMM(ZCF->ZCF_CODOBS,80),;
						_oObs:Refresh();
						}


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria um campo memo na tela para mostrar o historico das negociacoes³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
TSay():New((_nHeight*.55),_nWidth*.75,{|| "Observações" },oDlg1,,,,,,.T.,CLR_HBLUE,CLR_WHITE) //

@ (_nHeight*.6),_nWidth*.75 GET _oObs VAR _cObs MEMO SIZE (_nWidth*.22),(_nHeight*.30) WHEN .T. OF oDlg1 PIXEL READONLY


	ACTIVATE MSDIALOG oDlg1    

DbCloseArea("ZCG")
RESTAREA(_aArea)  
	
Return(.F.)	

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³TK020ListBox     ³Autor  ³Armando M. Tessaroli³ Data ³ 29/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna os valores que serao impressos pelo painel             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³cExp1: Alias para realizar a                                    ³±±
±±³          ³aExp2: Array com os codigos dos atendimentos realizados         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CALL CENTER						                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista  ³ Data/Bops/Ver ³Manutencao Efetuada                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Marcelo K ³20/08/01³609   ³- Revisao do fonte                              ³±±
±±³Andrea F. ³13/05/04³710   ³- Exibicao de todos os titulos NEGOCIADOS na    ³±±
±±³          ³        ³      ³Telecobranca no cabecalho e os atendimentos     ³±±
±±³          ³        ³      ³correspondentes nos itens.                      ³±±
±±³Andrea F. ³17/05/04³710   ³- BOPS 71528 Exibicao do campo ZCG_HIST         ³±±
±±³          ³        ³      ³(Historico) do titulo.                          ³±±
±±³Norbert W.³02/04/07³912   ³Bops 121340 - Correcao do indice de pesquisa da ³±±
±±³          ³        ³      ³descricao da ocorrencia na tabela SU9.          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function UTK020ListBox(cAlias, aFiltro)

Local aArea			:= GetArea()			//Seleciona a area para ser restaurada ao final
Local aDados		:= {}					//Array com os dados do ZCF
Local nPosTitulo	:= 0
Local aStatus		:= UTkc020Box("ZCG_STATUS")
Local aOpera		:= UTkc020Box("ZCF_OPERA")

#IFDEF TOP
	Local cQuery	:= ""
#ENDIF

Do Case
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Leitura do cabecalho telecobrança³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Case cAlias == "ZCF"
		#IFDEF TOP
			If TcSrvType() <> "AS/400"
				cQuery :=	"SELECT * " +;
							" FROM " + RetSqlName("ZCF") +;
							" WHERE ZCF_FILIAL = '" + xFilial("ZCF") + "' AND " +;
							" ZCF_CLIENT = '" + SA1->A1_COD + "' AND " +;
							" ZCF_LOJA = '" + SA1->A1_LOJA + "' AND " +;
							" ZCF_DATA >= '" + DtoS(MV_PAR01) + "' AND " +;
							" ZCF_DATA <= '" + DtoS(MV_PAR02) + "' AND " +;
							" D_E_L_E_T_ <> '*' " +;
							" ORDER BY ZCF_FILIAL,ZCF_CODIGO"
				
				cQuery := ChangeQuery(cQuery)
				DbSelectArea("ZCF")
				DbCloseArea()
				DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'ZCF', .F., .T.)
				
				TCSetField('ZCF', 'ZCF_DATA', 'D')
				TCSetField('ZCF', 'ZCF_PENDEN', 'D')
			Else
		#ENDIF
				DbSelectArea("ZCF")
				DbSetOrder(2)
				DbSeek(xFilial("ZCF") + SA1->A1_COD + SA1->A1_LOJA)
		#IFDEF TOP
			Endif		
		#ENDIF	
		While	!Eof()								.AND.;
				ZCF->ZCF_FILIAL == xFilial(cAlias)	.AND.;
				ZCF->ZCF_CLIENT == SA1->A1_COD		.AND.;
				ZCF->ZCF_LOJA   == SA1->A1_LOJA
			
			If ZCF->ZCF_DATA < MV_PAR01 .OR. ZCF->ZCF_DATA > MV_PAR02
				DbSkip()
				Loop
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³o Array aFiltro que e passado como parametro possui os codigos ³
			//³dos atendimentos em que o titulo foi negociado.                ³
			//³Nos itens serao exibidos apenas os atendimentos em que o titulo³
			//³foi negociado.                                                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Len(aFiltro) > 0
				nPosAtend := Ascan(aFiltro, {|x| x == ZCF->ZCF_CODIGO} )
				If nPosAtend > 0
					Aadd(aDados, {	ZCF->ZCF_CODIGO,;			// Codigo da Cobranca
									ZCF->ZCF_DATA,;				// Data
									DtoC(ZCF->ZCF_PENDEN),;		// Retorno
									ZCF->ZCF_HRPEND,;			// Hora Retorno
									Alltrim(ZCF->ZCF_TEL),;//aOpera[Val(ZCF_OPERA)+1],;	// Operacao ATIVO / RECEPTIVO
									Alltrim(ZCF->ZCF_CONTAT),;//ZCF->ZCF_OPERAD,;			// Cod Operador
									Alltrim(ZCF->ZCF_EMAIL),;//UsrFullName(ZCF->ZCF_OPERAD),;//Posicione("SU7",1,xFilial("SU7") + ZCF->ZCF_OPERAD,"SU7->U7_NOME"),;	// Nome Operador
									If(ZCF->ZCF_REGCOB=="1","1",If(ZCF->ZCF_REGCOB=="2","2",If(ZCF->ZCF_REGCOB=="3","3",If(ZCF->ZCF_REGCOB=="4","4",If(ZCF->ZCF_REGCOB=="5","5",If(ZCF->ZCF_REGCOB=="6","6",If(ZCF->ZCF_REGCOB=="7","7",If(ZCF->ZCF_REGCOB=="8","8",If(ZCF->ZCF_REGCOB=="9","9",""))))))))),;
									If(ZCF->ZCF_MOTIVO=="000001","COBRANÇA","");//Posicione("SU9",2,xFilial("SU9") + ZCF->ZCF_MOTIVO,"SU9->U9_DESC");	// Motivo
									} )
				Endif
			Endif
			DbSelectArea(cAlias)
			DbSkip()
		End
		#IFDEF TOP
			If TcSrvType() <> "AS/400"
				DbSelectArea("ZCF")
				DbCloseArea()
				ChKFile("ZCF")
			Endif
		#ENDIF
		If len(aDados) == 0
			DbSelectArea("ZCF")
			DbGoTo(0)
			AaDd(aDados, {	ZCF->ZCF_CODIGO,;			// Codigo da Cobranca
							ZCF->ZCF_DATA,;				// Data
							DtoC(ZCF->ZCF_PENDEN),;		// Retorno
							ZCF->ZCF_HRPEND,;			// Hora Retorno
							ZCF->ZCF_OPERA,;			// Operacao
							ZCF->ZCF_OPERAD,;			// Cod Operador
							ZCF->ZCF_OPERAD,;			// Nome Operador
							ZCF->ZCF_REGCOB,;			// Cod Motivo //rafael 111
							ZCF->ZCF_MOTIVO;			// Motivo
							} )
		Endif
		Asort( aDados,,, { |x,y| DtoS(x[2])+x[1] > DtoS(y[2])+y[1] } )



	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Leitura dos itens do telecobrança - titulos a receber³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Case cAlias == "ZCG"
		#IFDEF TOP
			If TcSrvType() <> "AS/400"
				cQuery :=	"SELECT * " +;
							" FROM " + RetSqlName("ZCF") +;
							" WHERE ZCF_FILIAL = '" + xFilial("ZCF") + "' AND " +;
							" ZCF_CLIENT = '" + SA1->A1_COD + "' AND " +;
							" ZCF_LOJA = '" + SA1->A1_LOJA + "' AND " +;
							" ZCF_DATA >= '" + DtoS(MV_PAR01) + "' AND " +;
							" ZCF_DATA <= '" + DtoS(MV_PAR02) + "' AND " +;
							" D_E_L_E_T_ <> '*' " +;
							" ORDER BY ZCF_FILIAL,ZCF_CODIGO"
				
				cQuery := ChangeQuery(cQuery)
				DbSelectArea("ZCF")
				DbCloseArea()
				DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'ZCF', .F., .T.)
				
				TCSetField('ZCF', 'ZCF_DATA', 'D')
			Else
		#ENDIF
				DbSelectArea("ZCF")
				DbSetOrder(2)
				DbSeek(xFilial("ZCF") + SA1->A1_COD + SA1->A1_LOJA)		// Cliente + Loja
		#IFDEF TOP
			Endif		
		#ENDIF	
		While	!Eof()								.AND.;
				ZCF->ZCF_FILIAL == xFilial("ZCF")	.AND.;
				ZCF->ZCF_CLIENT == SA1->A1_COD		.AND.;
				ZCF->ZCF_LOJA   == SA1->A1_LOJA

			If ZCF->ZCF_DATA < MV_PAR01 .OR. ZCF->ZCF_DATA > MV_PAR02
				DbSkip()
				Loop
			Endif
            
			#IFDEF TOP
				If TcSrvType() <> "AS/400"
					cQuery :=	"SELECT * " +;
								" FROM " + RetSqlName("ZCG") +;
								" WHERE ZCG_FILIAL = '" + xFilial("ZCG") + "' AND " +;
								" ZCG_CODIGO = '" + ZCF->ZCF_CODIGO + "' AND " +;
								" D_E_L_E_T_ <> '*' " +;
								" ORDER BY ZCG_FILIAL,ZCG_CODIGO"
					
					cQuery := ChangeQuery(cQuery)
					DbSelectArea("ZCG")
					DbCloseArea()
					DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'ZCG', .F., .T.)
					
					TCSetField('ZCG', 'ZCG_DTVENC', 'D')
					TCSetField('ZCG', 'ZCG_DTREAL', 'D')
					TCSetField('ZCG', 'ZCG_VALOR', 'N', 9, 2)
					TCSetField('ZCG', 'ZCG_ACRESC', 'N', 9, 2)
					TCSetField('ZCG', 'ZCG_DECRES', 'N', 9, 2)
				Else
			#ENDIF
					DbSelectArea("ZCG")
					DbSetOrder(1)
					DbSeek(xFilial("ZCG") + ZCF->ZCF_CODIGO)
			#IFDEF TOP
				Endif		
			#ENDIF	
			While	!Eof()								.AND.;
					ZCG->ZCG_FILIAL == xFilial("ZCG")	.AND.;
					ZCG->ZCG_CODIGO == ZCF->ZCF_CODIGO
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Se um titulo existir em atendimentos diferentes, guarda o codigo do atendimento   ³
				//³em que ele se repete. No array aDados grava o titulo apenas uma vez.  		     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nPosTitulo := Ascan(aDados, {|x| x[1]+x[2]+x[3]+x[4] == ZCG->ZCG_PREFIX+ZCG->ZCG_TITULO+ZCG->ZCG_PARCEL+ZCG->ZCG_TIPO} )
				If nPosTitulo > 0
					AaDd(aDados[nPosTitulo][len(aDados[1])], ZCF->ZCF_CODIGO)
				Else
					AaDd(aDados, {	ZCG->ZCG_PREFIX,;			// Prefixo
									ZCG->ZCG_TITULO,;			// Numero do titulo
									ZCG->ZCG_PARCEL,;			// Parcela
									ZCG->ZCG_TIPO,;				// Tipo
									ZCG->ZCG_NATURE,;			// Natureza
									DtoC(ZCG->ZCG_DTVENC),;		// Vencimento
									DtoC(ZCG->ZCG_DTREAL),;		// Vencimento real
									Transform(ZCG->ZCG_VALOR, PesqPict("ZCG", "ZCG_VALOR")),;		// Valor
									Transform(ZCG->ZCG_ACRESC, PesqPict("ZCG", "ZCG_ACRESC")),;	// Acrescimo
									Transform(ZCG->ZCG_DECRES, PesqPict("ZCG", "ZCG_DECRES")),;	// Desconto
									aStatus[Val(ZCG_STATUS)+1],;									// Status
									ZCG->ZCG_OPERAD,;												// Responsavel
									UsrFullName(ZCG->ZCG_OPERAD),;//Posicione("SU7",1,xFilial("SU7") + ZCG->ZCG_OPERAD,"U7_NOME"),;	// Nome do operador
									ZCG->ZCG_HIST,;	// Nome do operador
									{ZCF->ZCF_CODIGO};		// Todos os codigos de cobranca deste titulo
									} )
			    Endif

				DbSelectArea("ZCG")
				DbSkip()
            End
			#IFDEF TOP
				If TcSrvType() <> "AS/400"
					DbSelectArea("ZCG")
					DbCloseArea()
					ChKFile("ZCG")
				Endif
			#ENDIF
            
        	DbSelectArea("ZCF")
        	DbSkip()
		End
		#IFDEF TOP
			If TcSrvType() <> "AS/400"
				DbSelectArea("ZCF")
				DbCloseArea()
				ChKFile("ZCF")
			Endif
		#ENDIF
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Caso nao tenha dados inicializa o objeto com valores em branco.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If len(aDados) == 0
			AaDd(aDados, { "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" } )
		Else
			Asort( aDados,,, { |x,y| x[1]+x[2]+x[3] < y[1]+y[2]+y[3] } )
		Endif

End Case

RestArea(aArea)
Return(aDados)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TkSX3Box  ºAutor  ³Armando M. Tessaroliº Data ³  19/02/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   Funcao que monta um array com todas as opcoes do combo   º±±
±±º          ³box a partir da leitura do dicionario de dados SX3.         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ cCampo - Nome do campo que sera pesquisado no SX3.         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Call Center                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function UTkc020Box(cCampo)
Local aArea		:= GetArea()
Local aBox		:= {}
Local _aItns	:= {}
Local nI		:= 0

DbSelectArea("SX3")
DbSetOrder(2)
If DbSeek(cCampo)
	#IFDEF SPANISH
		aAdd(aBox, &('{"' + StrTran(AllTrim(SX3->X3_CBOXSPA),';','","') + '"}') )
	#ELSE
		#IFDEF ENGLISH
			aAdd(aBox, &('{"' + StrTran(AllTrim(SX3->X3_CBOXENG),';','","') + '"}') )
		#ELSE
			aAdd(aBox, &('{"' + StrTran(AllTrim(SX3->X3_CBOX),';','","') + '"}') )
		#ENDIF
	#ENDIF
Endif

aAdd(_aItns, "" )
For nI := 1 To Len(aBox[1])
	aAdd(_aItns, aBox[1][nI] )
Next nI

RestArea(aArea)

Return(_aItns)    

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³TK020Recno       ³Autor  ³Armando M. Tessaroli³ Data ³ 29/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao que retorna o numero do record para o evento change     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CALL CENTER						                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function UTK020Recno(cAlias, cCodigo)

Local aArea := GetArea()
Local nRet	:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona no registro para carregar a Enchoice³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea(cAlias)
DbSetOrder(1)
If DbSeek(xFilial(cAlias) + cCodigo)
	nRet := RecNo()
Else
	nRet := 0
Endif

RestArea(aArea)

Return(nRet)

/*
***********************
USER FUNCTION FTMSREL()   //23/02/17 - Ponto de entrada para incluir Entidade para a rotina de conhecimento
***********************
LOCAL aEntidade := {}  

AADD( aEntidade, { "ZCG", { "ZCG_CODIGO", "ZCG_PREFIX", "ZCG_TITULO", "ZCG_PARCEL", "ZCG_TIPO", "ZCG_FILORI" }, { || 	ZCG->ZCG_PREFIX+ZCG->ZCG_TITULO+ZCG->ZCG_PARCEL+ZCG->ZCG_TIPO+ZCG->ZCG_FILORI } } )  //{"ZCG_CODIGO", "ZCG_PREFIX", "ZCG_TITULO", "ZCG_PARCEL", "ZCG_TIPO", "ZCG_FILORI"}

Return aEntidade
*/