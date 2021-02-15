#INCLUDE "FATA050.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE 'FWMVCDEF.CH'

Static aIndSCT
Static lCopia

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �FatA050   � Autor � Vendas CRM		    � Data � 11/11/10 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Manutencao do Cadastro de Metas de Venda.                  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �Void FatA050(void)                                          ���
�������������������������������������������������������������������������Ĵ��
���Uso       �SIGAFAT                                                     ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
USER Function MFatA050()
                                            
Local oBrowse	:= Nil
Private cCadastro := STR0001  //"Meta de Venda"

AjustaHlp() //"Ajusta Help"

//���������������Ŀ
//� Cria o Browse �
//�����������������
oBrowse := FWMBrowse():New()
oBrowse:SetAlias('SCT')
oBrowse:SetDescription(STR0001)  //"Meta de Venda"
oBrowse:Activate()

Return(.T.)

/*
���������������������������������������������������������������������������
���������������������������������������������������������������������������
�����������������������������������������������������������������������ͻ��
���Programa  �ModelDef  � Autor � Vendas CRM         � Data � 11/11/10  ���
�����������������������������������������������������������������������͹��
���Desc.     �Define o modelo de dados para Manutencao do Cadastro de   ���
���          �Metas de Venda (MVC).                                     ���
�����������������������������������������������������������������������͹��
���Uso       �FatA050                                                   ���
�����������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������
���������������������������������������������������������������������������
*/

Static Function ModelDef()

Local oModel
Local oStruCab := FWFormStruct(1,'SCT',{|cCampo| AllTrim(cCampo)+"|" $ "CT_DOC|CT_DESCRI|"})
Local oStruGrid := FWFormStruct(1,'SCT')

Local bActivate     := {|oMdl|FatA050Act(oMdl)}
Local bPosValidacao := {||FatA050Pos()}
Local bCommit		:= {|oMdl|FatA050Cmt(oMdl)}
Local bCancel   	:= {|oMdl|FatA050Can(oMdl)}
Local bLinePost 	:= {||Ft050LinOk()}

oStruGrid:RemoveField('CT_DOC')
oStruGrid:RemoveField('CT_DESCRI')

oModel := MPFormModel():New('MFATA050',/*bPreValidacao*/,bPosValidacao,bCommit,bCancel)
oModel:AddFields('SCTCAB',/*cOwner*/,oStruCab,/*bPreValidacao*/,/*bPosValidacao*/,/*bCarga*/)
oModel:AddGrid( 'SCTGRID','SCTCAB',oStruGrid,/*bLinePre*/,bLinePost,/*bPreVal*/,/*bPosVal*/)
oModel:SetRelation("SCTGRID",{{"CT_FILIAL",'xFilial("SCT")'},{"CT_DOC","CT_DOC"}},SCT->(IndexKey(1)))
oModel:SetPrimaryKey({'CT_FILIAL','CT_DOC','CT_SEQUEN'})       
oModel:SetActivate(bActivate)
oModel:SetDescription(STR0001)                                                 
                                     
Return(oModel)

/*                               
�����������������������������������������������������������������������
�����������������������������������������������������������������������
�������������������������������������������������������������������ͻ��
���Programa  �ViewDef   � Autor � Vendas CRM      � Data � 11/11/10 ���
�������������������������������������������������������������������͹��
���Desc.     �Define a interface para Manutencao do Cadastro de     ���
���          �Metas de Venda (MVC).                                 ���
�������������������������������������������������������������������͹��
���Uso       �FatA050                                               ���
�������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������
�����������������������������������������������������������������������
*/
Static Function ViewDef()

Local oView

Local oModel     := FWLoadModel('MFATA050')
Local oStruCab   := FWFormStruct(2,'SCT',{|cCampo| AllTrim(cCampo)+"|" $ "CT_FILIAL|CT_DOC|CT_DESCRI|"})
Local oStruGrid   := FWFormStruct(2,'SCT')
Local aCabExcel  := Ft050Cab()  			// Cria o cabecalho para utilizacao no Microsoft Excel
Local aUsrBut    := {}     					// recebe o ponto de entrada
Local aButtons	 := {}                      // botoes da enchoicebar
Local nAuxFor    := 0                       // auxiliar do For , contador da Array aUsrBut
Local lFat050But := ExistBlock("FAT050BUT") // P.E. para incluir botoes do usuario na enchoicebar
Local oMdlCab    := oModel:GetModel('SCTCAB')
Local oMdlGrid    := oModel:GetModel('SCTGRID')

oStruGrid:RemoveField('CT_DOC')
oStruGrid:RemoveField('CT_DESCRI')


oView := FWFormView():New()
oView:SetModel(oModel)

oView:AddField('VIEW_CAB',oStruCab,'SCTCAB')
oView:AddGrid('VIEW_GRID',oStruGrid,'SCTGRID' )
oView:AddIncrementField('VIEW_GRID','CT_SEQUEN')

oView:CreateHorizontalBox('SUPERIOR',8)
oView:CreateHorizontalBox('INFERIOR',92)

oView:SetOwnerView( 'VIEW_CAB','SUPERIOR' )
oView:SetOwnerView( 'VIEW_GRID','INFERIOR' )


If GetRemoteType() == 1
	oView:AddUserButton(PmsBExcel()[3],PmsBExcel()[1],{|| DlgToExcel({ {"CABECALHO",oMdlCab:GetDescription(),{aCabExcel[1][1],aCabExcel[2][1]},{oMdlCab:GetValue('CT_DOC'),oMdlCab:GetValue('CT_DESCRI')}},{"GETDADOS","",oMdlGrid:aHeader,oMdlGrid:aCols}})},PmsBExcel()[2])
EndIf


//�����������������������������������������������������������Ŀ
//� Ponto de entrada para incluir botoes do usuario na barra, �
//� de ferramentas do formulario na copia das metas de venda. �
//�������������������������������������������������������������

If lFat050But .AND. lCopia == .T.
	aUsrBut := ExecBlock("FAT050BUT",.F.,.F.)
	If (ValType(aUsrBut) == "A")
		For nAuxFor := 1 To Len(aUsrBut)
			oView:AddUserButton(aUsrBut[nAuxFor][3],aUsrBut[nAuxFor][1],aUsrBut[nAuxFor][2],aUsrBut[nAuxFor][4])
		Next nAuxFor
	EndIf
	lCopia := .F.
EndIf

Return(oView)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    |MenuDef   � Autor � Vendas CRM            � Data � 11/11/10 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Funcao de definicao do aRotina                              ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �aRotina retorna a array com lista de aRotina                ���
�������������������������������������������������������������������������Ĵ��
���Uso       �FatA050                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MenuDef()
Local aRotina :={}
Local aUsrBut :={}
Local nX := 0

If IsInCallStack("FATA320") .AND. FindFunction("FT060Permi")
	aPermissoes := FT060Permi(__cUserId, "ACA_ACMETA")
Else
	aPermissoes := {.T.,.T.,.T.,.T.}
EndIf

ADD OPTION aRotina TITLE STR0002 ACTION 'PesqBrw' 			OPERATION 1	ACCESS 0

If aPermissoes[4]
	ADD OPTION aRotina TITLE STR0003 ACTION 'VIEWDEF.MFATA050'	OPERATION 2	ACCESS 0
EndIf

If aPermissoes[1]
	ADD OPTION aRotina TITLE STR0004 ACTION 'VIEWDEF.MFATA050'	OPERATION 3	ACCESS 0
EndIf

If aPermissoes[2]
	ADD OPTION aRotina TITLE STR0005 ACTION 'VIEWDEF.MFATA050'	OPERATION 4	ACCESS 0
EndIf

If aPermissoes[3]
	ADD OPTION aRotina TITLE STR0006 ACTION 'VIEWDEF.MFATA050'	OPERATION 5	ACCESS 0
EndIf

	ADD OPTION aRotina TITLE STR0008 ACTION 'Ft050Cons'			OPERATION 6	ACCESS 0 //"Consulta"
	ADD OPTION aRotina TITLE STR0007 ACTION 'Ft050Copia'		OPERATION 7	ACCESS 0 //"Copia"
    
If ExistBlock("FT050MNU")
	aUsrBut := ExecBlock("FT050MNU",.F.,.F.)
	For nX := 1 To Len(aUsrBut)
		ADD OPTION aRotina TITLE aUsrBut[nX][1] ACTION aUsrBut[nX][2] OPERATION aUsrBut[nX][4] ACCESS 0
	Next nX
EndIf

Return(aRotina)



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FatA050Act� Autor � Vendas CRM         � Data �  11/11/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Bloco executado ao iniciar o formulario MVC para inclusao,  ���
���          �alteracao, exclusao e visualizacao.                         ���
�������������������������������������������������������������������������͹��
���Uso       �FatA050                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function FatA050Act(oMdl)

Local nOperation := oMdl:GetOperation()
Local oMdlGrid := oMdl:GetModel('SCTGRID')
Local nX := 0

//��������������������������������������������Ŀ
//�Se a operacao for copia ajusta a sequencia, �
//�da linha.         						   �
//����������������������������������������������

if nOperation == 3 .AND. lCopia
	For nX:= 1 to oMdlGrid:GetQtdLine()
		oMdlGrid:GoLine(nX)
		oMdlGrid:SetValue("CT_SEQUEN",cValToChar(StrZero(nX,TamSx3("CT_SEQUEN")[1])),.T.)
	Next nX
   	lCopia := .F.
EndIf

Return(.T.)            


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FatA050Pos� Autor � Vendas CRM         � Data �  11/11/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Pos validacao do browse MVC, executada antes da gravacao,   ���
���          �permitindo validar o formulario.                            ���
�������������������������������������������������������������������������͹��
���Uso       �TmkA330                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FatA050Pos()
Local lRet := .T.

If ExistBlock("FT050TOK")
	lRet := ExecBlock("FT050TOK",.F.,.F.)
EndIf

Return(lRet)


/*
���������������������������������������������������������������������������
���������������������������������������������������������������������������
�����������������������������������������������������������������������ͻ��
���Programa  �FatA050Cmt� Autor � Vendas CRM         � Data � 11/11/10  ���
�����������������������������������������������������������������������͹��
���Desc.     �Bloco executado na gravacao dos dados do formulario MVC.  ���
�����������������������������������������������������������������������͹��
���Uso       �FatA050                                                   ���
�����������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������
���������������������������������������������������������������������������
*/

Static Function FatA050Cmt(oMdl)
Local nOperation := oMdl:GetOperation()
//integracao com modulo de planejamento e controle orcamentario
Local lInt_Pco := (SuperGetMV("MV_PCOINTE",.F.,"2")=="1")

//�����������������������������������������������������������Ŀ
//� Inicializa a gravacao dos lancamentos do SIGAPCO          �
//�������������������������������������������������������������
PcoIniLan("000155")

If nOperation == 3  .Or. nOperation == 5
	
	FWModelActive(oMdl)
	FWFormCommit(oMdl)
	
	//�������������������������������������������������������Ŀ
	//�Grava os lancamentos para integracao com modulo SIGAPCO�
	//���������������������������������������������������������
	If lInt_Pco
		PcoDetLan("000155","01","MFATA050")
	EndIf
	
	
Endif


If nOperation == 4
	
	
	FWModelActive(oMdl)
	FWFormCommit(oMdl)
	Ft050GrvDesc(oMdl)
	//�������������������������������������������������������Ŀ
	//�Grava os lancamentos para integracao com modulo SIGAPCO�
	//���������������������������������������������������������
	If lInt_Pco
		PcoDetLan("000155","01","MFATA050")
	EndIf
	
	
EndIf


//�����������������������������������������������������������Ŀ
//� Finaliza a gravacao dos lancamentos do SIGAPCO            �
//�������������������������������������������������������������
PcoFinLan("000155")




Return(.T.)



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FatA050Can� Autor � Vendas CRM         � Data �  11/11/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Bloco acionado no cancelamento de inclusao/alteracao do     ���
���          �formulario MVC.                                             ���
�������������������������������������������������������������������������͹��
���Uso       �FatA050                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FatA050Can(oMdl)

Local nOperation:= oMdl:GetOperation()

If nOperation == 3
	RollBackSX8()
EndIf

Return(.T.)


/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  �Ft050Copia � Autor � Vendas CRM         � Data �  11/11/10   ���
��������������������������������������������������������������������������͹��
���Desc.     �Copia do Cadastro de Metas de Venda.                         ���
��������������������������������������������������������������������������͹��
���Uso       �FatA050                                                      ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/

USER Function MFt050Copia()

Local cTitulo		:= STR0007
Local nOperation 	:= 9 // Define o modo de operacao como copia
lCopia := .T.

FWExecView(cTitulo,'VIEWDEF.MFATA050',nOperation,/*oDlg*/,/*bCloseOnOk*/,/*bOk*/,/*nPercReducao*/)

Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GrvDesc   � Autor � Vendas CRM         � Data �  11/11/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Grava a descricao do cabecalho no grid.                     ���
�������������������������������������������������������������������������͹��
���Uso       �FatA050                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Ft050GrvDesc(oMdl)

Local oMdlCab := oMdl:GetModel('SCTCAB')
Local oMdlGrid := oMdl:GetModel('SCTGRID')
Local nX := 0

dbSelectArea("SCT")
dbSetOrder(1)
For nX:= 1 to oMdlGrid:GetQtdLine()
	oMdlGrid:GoLine(nX)
	If DbSeek(xFilial("SCT")+oMdlCab:GetValue("CT_DOC")+oMdlGrid:GetValue("CT_SEQUEN"))
		RecLock("SCT",.F.)
		SCT->CT_DESCRI := oMdlCab:GetValue("CT_DESCRI")
		MsUnlock()
	Endif
Next nX

Return Nil





/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Ft050Cab  � Autor � Vendas CRM         � Data �  11/11/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Criacao do cabecalho para integracao com Microsoft Excel.   ���
�������������������������������������������������������������������������͹��
���Uso       �FatA050                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


Static Function Ft050Cab()

Local aCabec := {}

//������������������������������������������������������������������������Ŀ
//�Montagem do Array do Cabecalho                                          �
//��������������������������������������������������������������������������
dbSelectArea("SX3")
dbSetOrder(2)
dbSeek("CT_DOC")
aadd(aCabec,{OemToAnsi(X3Titulo()),SX3->X3_PICTURE,Nil})
dbSelectArea("SX3")
dbSetOrder(2)
dbSeek("CT_DESCRI")
aadd(aCabec,{OemToAnsi(X3Titulo()),SX3->X3_PICTURE,Nil})

Return(aCabec)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Ft050LinOk� Autor � Vendas CRM         � Data �  11/11/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Validacao da Linha.                                         ���
�������������������������������������������������������������������������͹��
���Uso       �FatA050                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Ft050LinOk()

Local oMdl		:= FWModelActive()
Local oMdlGrid	:= oMdl:GetModel('SCTGRID')
Local nPMoeda	:= oMdlGrid:GetValue('CT_MOEDA') // moeda
Local nPValor	:= oMdlGrid:GetValue('CT_VALOR') // valor
Local nPQuant	:= oMdlGrid:GetValue('CT_QUANT') // quantidade
Local lRet	:= .T.


If !oMdlGrid:IsDeleted()
	Do Case
		Case nPMoeda == 0
			UserException('CT_MOEDA Must be Used !!!')
/*		Case nPValor == 0
			UserException('CT_VALOR Must be Used !!!')
		Case nPQuant == 0
			UserException('CT_QUANT Must be Used !!!')
*/
	EndCase
	
	If Empty(nPMoeda) .Or. Empty(nPValor) .Or. Empty(nPQuant)
		Help(" ",1,"FT050LOK01")
		lRet := .F.
	EndIf
EndIf*/	

If ExistBlock("FT050LOK")
	lRet := ExecBlock("FT050LOK",.F.,.F.)
EndIf

Return(lRet)



/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �Ft050Cons � Autor � Eduardo Riera         � Data �28.11.2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Consulta as Metas de Venda por data.                       ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �                                                            ���
�������������������������������������������������������������������������Ĵ��
���          � ExpN1 : Registro                                           ���
���          � ExpN2 : Opcao                                              ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
USER Function Ft050Cons(cAlias,nReg,nOpc)

Local cCadastro := STR0001              // Meta de Venda
Local aArea     := GetArea()        	// Salva ambiente anterior
Local aSizeAut  := MsAdvSize( .F. )    // Array para redimensionamento da tela
Local aObjects  := {}					// Array para redimensionamento da tela
Local aPosObj   := {}					// Array para redimensionamento da tela
Local aCampos   := {}                   // campos da a tela
Local aStru     := {}                   // Estrutura da Query
Local aStruExcel:= {}
Local aSoma     := {}                   // soma dos valores
Local aDesc     := {}   				// descri��o dos elementos no Tree

Local cDesc     := ""                  // descricao
Local cChave    := ""                  // chave da tabela
Local cCampo    := ""                  // campo da tabela
Local cConteudo := ""                  // conteudo do campo
Local cSeek     := ""                  // chave da pesquisa
Local cLast     := ""
Local cTitulo   := ""                  // titulo
Local cChar     := ""
Local cQuery    := ""                  // Query
Local cAliasSCT := "SCT"               // Alias
Local cQuebra1  := ""
Local cQuebra2  := ""

Local dData     := SCT->CT_DATA        // data

Local lData     := .F.

Local nOrdem    := 0                   // ordem
Local nX        := 0                   // auxiliar
Local nY        := 0                   // auxiliar
Local nPSoma    := 0

Local oDlg                            // tela
Local oTree                           // estrutura da  tela
Local oSay1                           // objeto say1
Local oSay2                           // objeto say2

nOrdem    := SCT->(FtOrdMeta())
cChave    := SCT->(IndexKey())

//������������������������������������������������������������������������Ŀ
//� Define as descricoes para cada tipo de elemento no Tree                �
//��������������������������������������������������������������������������
AAdd( aDesc, { "CT_REGIAO" , { |x| Posicione( "SX5", 1, xFilial( "SX5" ) + "A2" + x, "X5_DESCRI" ) } } )
AAdd( aDesc, { "CT_TIPO"   , { |x| Posicione( "SX5", 1, xFilial( "SX5" ) + "02" + x, "X5_DESCRI" ) } } )
AAdd( aDesc, { "CT_GRUPO"  , { |x| Posicione( "SBM", 1, xFilial( "SBM" ) + x, "BM_DESC" ) } } )
AAdd( aDesc, { "CT_PRODUTO", { |x| Posicione( "SB1", 1, xFilial( "SB1" ) + x, "B1_DESC" ) } } )
AAdd( aDesc, { "CT_VEND"   , { |x| Posicione( "SA3", 1, xFilial( "SA3" ) + x, "A3_NOME" ) } } )

dbSelectArea("SCT")
For nX := 1 To Len(cChave)+1
	cChar  := SubStr(cChave,1,1)
	cChave := SubStr(cChave,2)
	If cChar <> "+" .And. !Empty(cChar)
		cCampo += cChar
	Else
		If ( !Empty(cCampo) )
			aadd(aCampos,cCampo)
		EndIf
		cCampo := ""
	EndIf
Next nX

//������������������������������������������������������������������������Ŀ
//� Calculo automatico de dimensoes dos objetos                            �
//��������������������������������������������������������������������������
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 080, 100, .f., .t. } )

aInfo := { aSizeAut[1], aSizeAut[2], aSizeAut[3], aSizeAut[4], 3, 3 }
aObj  := MsObjSize( aInfo, aObjects, , .T. )

DEFINE MSDIALOG oDlg FROM aSizeAut[7],00 TO aSizeAut[6],aSizeAut[5] TITLE cCadastro OF oMainWnd PIXEL

oTree := DbTree():New( aObj[1,1], aObj[1,2], aObj[1,3], aObj[1,4],oDlg,,,.T.)

dbSelectArea(cAliasSCT)
#IFDEF TOP
	aStru  := SCT->(dbStruct())
	// cAliasSCT := "Ft050Cons"
	cAliasSCT := CriaTrab( ,.F. )
	cQuery := "SELECT * "
	cQuery += "FROM "+RetSqlName("SCT")+" SCT "
	cQuery += "WHERE "
	cQuery += "SCT.CT_FILIAL='"+xFilial("SCT")+"' AND "
	cQuery += "SCT.CT_DATA='"+Dtos(dData)+"' AND "
	cQuery += "SCT.D_E_L_E_T_=' ' "
	cQuery += "ORDER BY "+SqlOrder(SCT->(IndexKey()))
	
	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSCT,.T.,.T.)
	For nX := 1 To Len(aStru)
		If ( aStru[nX][2] <> "C" )
			TcSetField(cAliasSCT,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
		EndIf
	Next nX
#ELSE
	dbSeek(xFilial("SCT")+Dtos(dData))
#ENDIF
cQuebra1 := ""
For nX := 1 To Len(aCampos)
	cQuebra1 += "+"+aCampos[nX]
Next nX
cQuebra1 := SubStr(cQuebra1,2)
While ( !Eof() .And. (cAliasSCT)->CT_FILIAL == xFilial("SCT") .And.;
	(cAliasSCT)->CT_DATA == dData )
	cQuebra2 := &cQuebra1
	nY    := 0
	cLast := ""
	For nX := 1 To Len(aCampos)
		cCampo    := aCampos[nX]
		cConteudo := &(cCampo)
		cDesc     := ""
		nY        += Len(cConteudo)
		//������������������������������������������������������������������������Ŀ
		//� Obtem as descricoes para cada tipo de elemento no Tree                 �
		//��������������������������������������������������������������������������
		If !Empty( nScan := AScan( aDesc, { |x| x[1] == AllTrim( cCampo ) } ) )
			cDesc := " - " + AllTrim( Capital( Eval( aDesc[ nScan, 2 ], cConteudo ) ) )
		EndIf
		
		If ( nX > 1 )
			cLast     += &(aCampos[nX-1])
		EndIf
		lData := .F.
		Do Case
			Case "DTOS"$Upper(cCampo)
				cCampo := SubStr(cCampo,6,Len(cCampo)-6)
				lData  := .T.
		EndCase
		cTitulo := PadR(AllTrim(RetTitle(cCampo))+": "+If(lData, DToC( SToD( cConteudo ) ) , AllTrim( cConteudo ) ) + cDesc, 120 )
		cSeek   := PadR(SubStr(cQuebra2,1,nY),Len(cQuebra2))
		If !oTree:TreeSeek(cSeek)
			oTree:TreeSeek(cLast)
			oTree:addItem(cTitulo,cSeek,"FOLDER5","FOLDER6",,,If(nX==1,1,2))
			cLast := cSeek
			If ( !Empty(cConteudo) )
				aadd(aSoma,{cSeek,(cAliasSCT)->CT_QUANT,(cAliasSCT)->CT_VALOR})
			EndIf
		Else
			If ( !Empty(cConteudo) )
				nPSoma := aScan(aSoma,{|x| x[1]==cSeek })
				aSoma[nPSoma][2] += (cAliasSCT)->CT_QUANT
				aSoma[nPSoma][3] += (cAliasSCT)->CT_VALOR
			EndIf
		EndIf
	Next nX
	dbSelectArea(cAliasSCT)
	dbSkip()
EndDo
#IFDEF TOP
	dbSelectArea(cAliasSCT)
	dbCloseArea()
	dbSelectArea("SCT")
#ENDIF

@ aObj[2,1], aObj[2,2] TO aObj[2,3], aObj[2,4] PROMPT OemToAnsi(STR0009) PIXEL //"Hierarquia"

nLin := aObj[2,1] +  8
nCol := aObj[2,2] +  7

@ nLin,nCol          SAY RetTitle("CT_QUANT") SIZE 040,008 OF oDlg PIXEL
@ nLin + 10,nCol + 6 SAY oSay1 PROMPT 0 SIZE 050,008 OF oDlg PIXEL
@ nLin + 30,nCol SAY RetTitle("CT_VALOR") SIZE 040,008 OF oDlg PIXEL
@ nLin + 40,nCol + 6 SAY oSay2 PROMPT 0 SIZE 050,008 OF oDlg PIXEL

oTree:bChange := {|| Ft050Msg(oTree,oSay1,oSay2,aSoma) }

@ aObj[2,3] - 17,aObj[2,4] - 33 BUTTON STR0010 ACTION ( oDlg:End() ) OF oDlg PIXEL SIZE 30,10 //"Sair"
@ aObj[2,3] - 17,aObj[2,4] - 75 BUTTON STR0011 ACTION ( FtToExcel(aCampos,aSoma) ) OF oDlg PIXEL SIZE 30,10 //"Excel"

ACTIVATE MSDIALOG oDlg ON INIT Eval(oTree:bChange)

RestArea(aArea)

Return(.T.)
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �Ft050Msg  � Autor � Eduardo Riera         � Data �03.12.2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Demonstra as mensagens do rodape da funcao de consulta      ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpO1 : Objeto Tree                                        ���
���          � ExpO2 : Objeto Say 1                                       ���
���          � ExpO3 : Objeto Say 2                                       ���
���          � ExpA4 : Array com os totais a serem exibidos               ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � ExpL1 : Sempre .T.                                         ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Ft050Msg(oTree,oSay1,oSay2,aSoma)

Local nPSoma := 0
Local cSeek  := oTree:GetCargo()

nPSoma := aScan(aSoma,{|x| x[1]==cSeek })

oSay1:SetText(AllTRim( TransForm(aSoma[nPSoma,2],PesqPict("SCT","CT_QUANT",18))))
oSay2:SetText(AllTRim( TransForm(aSoma[nPSoma,3],PesqPict("SCT","CT_VALOR",18))))


Return(.T.)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �FtOrdMeta � Autor � Eduardo Riera         � Data �28.11.2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Estabelece o indice de hierarquia das metas de venda        ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � ExpN1 : Ordem da hierarquia das metas de venda             ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 : Hierarquia a ser seguida                           ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
USER Function MFtOrdMeta(cChave)

Local aArea    := GetArea()                			// retorna o ambiente anterios
Local nOrdem   := 0                                 // ordem
Local nPos     := 0                                 // posi��o
Local cArqInd  := ""                                // index

DEFAULT cChave  := AllTrim(&(GetMv("MV_FTMETA")))  // chave da tabela
DEFAULT aIndSCT := {}

nPos := At("CT_FILIAL",cChave)
If ( nPos == 0 )
	cChave := "C7_DATA+"+cChave
Else
	cChave := AllTrim(SubStr(cChave,nPos,9))+"+Dtos(CT_DATA)"+SubStr(cChave,nPos+9)
EndIf
dbSelectArea("SCT")
nOrdem := RetIndex("SCT") + 1
nPos := aScan(aIndSCT,{|x| AllTrim(x[2])==cChave})
If ( nPos <> 0 )
	#IFNDEF TOP
		dbSetIndex(aIndSCT[nPos][1])
		dbSetOrder(nOrdem)
	#ELSE
		nPos := 0
	#ENDIF
EndIf
If ( nPos == 0 )
	cArqInd := CriaTrab(,.F.)
	IndRegua("SCT",cArqInd,cChave)
	nOrdem := RetIndex("SCT") + 1
	#IFNDEF TOP
		dbSetIndex(cArqInd+OrdBagExt())
		aadd(aIndSCT,{ cArqInd , cChave })
	#ENDIF
	dbSetOrder(nOrdem)
EndIf
If ( aArea[1]<>"SCT" )
	RestArea(aArea)
EndIf
Return(nOrdem)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �FtToExcel � Autor � Eduardo Riera         � Data �09.07.2005���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Exporta para o Excell                                       ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpA1 : Array com dados                                    ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function FtToExcel(aCampos,aDados)

Local aArea		:= GetArea()                 	// retorna ambiente anterior
Local aStruct   := {}                           // estrutura
Local cDirDocs  := MsDocPath()
Local cPath		:= AllTrim(GetTempPath())
Local nY		:= 0                            // auxiliar do for
Local nX        := 0                            // auxiliar do for
Local cBuffer   := ""                           // recebe as variaveis de valores
Local oExcelApp := Nil                          // recebe planilha do excell
Local nHandle   := 0
Local cArquivo  := CriaTrab(,.F.)+".CSV"        // arquivo
Local xValor    := Nil                          //  valor

If ApOleClient("MsExcel")
	For nX := 1 To Len(aCampos)
		aCampos[nX] := Upper(aCampos[nX])
		aCampos[nX] := StrTran(aCampos[nX],"DTOS(","")
		aCampos[nX] := StrTran(aCampos[nX],")","")
		dbSelectArea("SX3")
		dbSetOrder(2)
		If MsSeek(aCampos[nX])
			aadd(aStruct,{aCampos[nX],SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		EndIf
	Next nX
	SX3->(dbSetOrder(1))
	If (nHandle := FCreate(cDirDocs + "\"+cArquivo)) > 0
		For nY := 1 To Len(aStruct)
			xValor := RetTitle(aStruct[nY][1])
			xValor := PadR(xValor,Max(aStruct[nY][3]+aStruct[nY][4],Len(xValor)))
			cBuffer += ToXlsFormat(xValor)
			cBuffer += ";"
		Next nY
		cBuffer += ToXlsFormat(RetTitle("CT_QUANT"))+";"
		cBuffer += ToXlsFormat(RetTitle("CT_VALOR"))+CRLF
		FWrite(nHandle, cBuffer)
		For nX := 1 To Len(aDados)
			cBuffer	:= ""
			cLinha := aDados[nX][1]
			For nY := 1 To Len(aStruct)
				xValor := SubStr(cLinha,1,aStruct[nY][3]+aStruct[nY][4])
				Do Case
					Case aStruct[nY][2]=="N"
						xValor := Val(xValor)
					Case aStruct[nY][2]=="D"
						xValor := Stod(xValor)
				EndCase
				cBuffer += ToXlsFormat(xValor)
				cBuffer += ";"
				cLinha := SubStr(cLinha,aStruct[nY][3]+aStruct[nY][4]+1)
			Next nY
			cBuffer += ToXlsFormat(aDados[nX][2])+";"
			cBuffer += ToXlsFormat(aDados[nX][3])+CRLF
			FWrite(nHandle, cBuffer)
		Next nX
		FClose(nHandle)
		CpyS2T(cDirDocs + "\" + cArquivo, cPath, .T.)
		
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open(cPath + cArquivo)
		oExcelApp:SetVisible(.T.)
	Else
		MsgStop(STR0012) //"Erro na criacao do arquivo na estacao local. Contate o administrador do sistema"
	EndIf
Else
	MsgStop(STR0013)	 //"Microsoft Excel nao instalado."
EndIf

RestArea(aArea)
Return



/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �AjustaHlp � Autor � Marco Bianchi         � Data �18/10/2007���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Inclui help de rotina (confirma gravacao com todos os itens ���
���          �deletados                                                   ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function AjustaHlp()

Local aArea		:= Getarea()
Local aAreaSX3	:= SX3->(Getarea())
Local aHelpPor	:= {}
Local aHelpSpa	:= {}
Local aHelpEng	:= {}

//�������������������������������������������������������Ŀ
//�HELP na Inclusao  		  �
//���������������������������������������������������������
//�������������������������������������������������������Ŀ
//�Problema												  �
//���������������������������������������������������������
Aadd(aHelpPor,"Nao ha registros a serem gravados na " )
Aadd(aHelpPor,"tabela SCT - Metas de Venda."  )
// Espanhol
Aadd(aHelpSpa,"No existen registros para grabar " )
Aadd(aHelpSpa,"en la tabla SCT - Metas de venta."  )
// Ingles
Aadd(aHelpEng,"No records are to be recorded " )
Aadd(aHelpEng,"in the table SCT - Sales Goals"  )
PutHelp("PA050NAOREG",aHelpPor,aHelpEng,aHelpSpa,.T.)

//�������������������������������������������������������Ŀ
//�Solucao 												  �
//���������������������������������������������������������
aHelpPor := {}
aHelpSpa := {}
aHelpEng := {}

Aadd(aHelpPor,"Verifique a sequencia das Metas de Venda." )
// Espanhol
Aadd(aHelpSpa,"Verifique la sequencia de las Metas de" )
Aadd(aHelpSpa,"venta." )
// Ingles
Aadd(aHelpEng,"Check the sequence of Sales Goals." )
PutHelp("SA050NAOREG",aHelpPor,aHelpEng,aHelpSpa,.T.)

//�������������������������������������������������������Ŀ
//�HELP na Alteracao                               		  �
//���������������������������������������������������������
//�������������������������������������������������������Ŀ
//�Problema												  �
//���������������������������������������������������������
aHelpPor := {}
aHelpSpa := {}
aHelpEng := {}

Aadd(aHelpPor,"Para excluir todos os itens utilize" )
Aadd(aHelpPor,"a opcao Excluir Metas de Venda."  )
// Espanhol
Aadd(aHelpSpa,"Para borrar todos los items use  " )
Aadd(aHelpSpa,"la rotina Borrar Meta de Venta."  )
// Ingles
Aadd(aHelpEng,"To delete all items use the" )
Aadd(aHelpEng,"Delete option Sales Goals."  )
PutHelp("PA050EXCL",aHelpPor,aHelpEng,aHelpSpa,.T.)

//�������������������������������������������������������Ŀ
//�Solucao 												  �
//���������������������������������������������������������
aHelpPor := {}
aHelpSpa := {}
aHelpEng := {}

Aadd(aHelpPor,"Posicione Meta de Venda e clique" )
Aadd(aHelpPor,"no botao excluir." )
// Espanhol
Aadd(aHelpSpa,"Posicione Meta de Venta y clique" )
Aadd(aHelpSpa,"en el botao borrar." )
// Ingles
Aadd(aHelpEng,"Position Sales Goals and click" )
Aadd(aHelpEng,"on the delete button." )
PutHelp("SA050EXCL",aHelpPor,aHelpEng,aHelpSpa,.T.)

//����������������������������Ŀ
//�Ajusta o dicionario de dados�
//������������������������������  
DbSelectArea("SX3")
DbSetOrder(2)

If Dbseek("CT_PRODUTO") .AND. AllTrim(SX3->X3_VALID) <> '( Vazio() .Or. ExistCpo("SB1") ) .and. FA050CLEAR( 1 )'
	RecLock("SX3",.F.)
	SX3->X3_VALID	:= '( Vazio() .Or. ExistCpo("SB1") ) .and. FA050CLEAR( 1 )'
	MsUnLock()
EndIf

If Dbseek("CT_GRUPO") .AND. AllTrim(SX3->X3_VALID) <> '( Vazio() .Or. ExistCpo("SBM") ) .and. FA050CLEAR( 2 )'
	RecLock("SX3",.F.)
	SX3->X3_VALID	:= '( Vazio() .Or. ExistCpo("SBM") ) .and. FA050CLEAR( 2 )'
	MsUnLock()
EndIf

If Dbseek("CT_TIPO") .AND. AllTrim(SX3->X3_VALID) <> '( Vazio() .Or. ExistCpo("SX5","02"+M->CT_TIPO) ) .and. FA050CLEAR( 3 )'
	RecLock("SX3",.F.)
	SX3->X3_VALID	:= '( Vazio() .Or. ExistCpo("SX5","02"+M->CT_TIPO) ) .and. FA050CLEAR( 3 )'
	MsUnLock()
EndIf

//������������������Ŀ
//�Ajusta os gatilhos�
//��������������������
DbSelectArea("SX7")
DbSetOrder(1)

If DbSeek("CT_GRUPO  001") .AND. AllTrim(SX7->X7_CDOMIN) == "CT_TIPO" .AND. AllTrim(SX7->X7_REGRA) == '""'
	RecLock("SX7",.F.)
	DbDelete()
	MsUnLock()
EndIf

If DbSeek("CT_GRUPO  002") .AND. AllTrim(SX7->X7_CDOMIN) == "CT_PRODUTO" .AND. AllTrim(SX7->X7_REGRA) == '""'
	RecLock("SX7",.F.)
	DbDelete()
	MsUnLock()
EndIf

If DbSeek("CT_PRODUTO001") .AND. AllTrim(SX7->X7_CDOMIN) == "CT_TIPO" .AND. AllTrim(SX7->X7_REGRA) == 'SB1->B1_TIPO'
	RecLock("SX7",.F.)
	DbDelete()
	MsUnLock()
EndIf

If DbSeek("CT_PRODUTO002") .AND. AllTrim(SX7->X7_CDOMIN) == "CT_GRUPO" .AND. AllTrim(SX7->X7_REGRA) == 'SB1->B1_GRUPO'
	RecLock("SX7",.F.)
	DbDelete()
	MsUnLock()
EndIf

If DbSeek("CT_TIPO   001") .AND. AllTrim(SX7->X7_CDOMIN) == "CT_GRUPO" .AND. AllTrim(SX7->X7_REGRA) == '""'
	RecLock("SX7",.F.)
	DbDelete()
	MsUnLock()
EndIf

If DbSeek("CT_TIPO   002") .AND. AllTrim(SX7->X7_CDOMIN) == "CT_PRODUTO" .AND. AllTrim(SX7->X7_REGRA) == '""'
	RecLock("SX7",.F.)
	DbDelete()
	MsUnLock()
EndIf

RestArea(aAreaSX3)
RestArea(aArea)

Return

/*

FUNCOES PARA TESTE PONTO DE ENTRADA

User Function FT050MNU()
Local Putz := {}
AAdd(Putz,{'Botao 1','Alert("botao 1")', 0 , 9,0,NIL})
AAdd(Putz,{'Botao 2','Alert("botao 2")', 0 , 9,0,NIL})
AAdd(Putz,{'Botao 3','Alert("botao 3")', 0 , 9,0,NIL})

Return(Putz)


User Function FAT050BUT()
Local Putz := {}
AAdd(Putz,{"",{||Alert("TESTE1")},'Botao Int 1','Botao 1 Mouse'})
AAdd(Putz,{"",{||Alert("TESTE2")},'Botao Int 2','Botao 2 Mouse'})
AAdd(Putz,{"",{||Alert("TESTE3")},'Botao Int 3','Botao 3 Mouse'})
Return(Putz)



User Function FT050TOK()
Local lRet := .F.

MsgAlert("TEste")
Return(lRet)
 */

          
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA050CLEAR�Autor  �Vendas CRM          � Data �  10/01/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Preenche ou limpa os campos do grid da tabela SCT de acordo ���
���          �com a origem                                                ���
�������������������������������������������������������������������������͹��
���Parametros�EXPN1 - Identificacao da origem(1-Produto, 2-Grupo, 3-Tipo) ���
�������������������������������������������������������������������������͹��
���Uso       �FATA050                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER Function MFA050CLEAR( nType ) 

Local oModel := FWModelActive()                    
Local aArea  := GetArea()
Local aAreaSB1 := SB1->( GetArea() )

If nType == 1                   
	SB1->( dbSetOrder( 1 ) )                                            
    If SB1->( dbSeek( xFilial("SB1") + M->CT_PRODUTO ) )
		oModel:LoadValue( 'SCTGRID', 'CT_GRUPO', SB1->B1_GRUPO )
		oModel:LoadValue( 'SCTGRID', 'CT_TIPO' , SB1->B1_TIPO  )
    EndIf   
    
ElseIf  nType == 2
	oModel:ClearField( 'SCTGRID', 'CT_PRODUTO' )
	oModel:ClearField( 'SCTGRID', 'CT_TIPO'    )

ElseIf nType == 3
	oModel:ClearField( 'SCTGRID', 'CT_PRODUTO' )
	oModel:ClearField( 'SCTGRID', 'CT_GRUPO'   )

EndIf

RestArea(aAreaSB1)
RestArea(aArea)

Return .T.