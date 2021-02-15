#Include "PROTHEUS.CH"
#Include "RWMAKE.CH"
#Include "TOPCONN.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CopiaTes  �Autor  �Microsiga           � Data �  27/01/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CopiaTes()                                  
	//�������������������������
	//�Declaracao de variaveis�
	//�������������������������
	Local oGroup1
	Local oGroup2
	Local oSay1
	Local oSay2
	Local oSay3
	Local oSay4
	Local oSay5
	Local oSay6
	Local oSay7
	Local oSay8
	Local oSay9
	Local oSay10
	Local oSay11
	Local oSay12
	Local oF4_CODIGO
	Local oF4_TIPO
	Local oF4_DUPLIC
	Local oF4_ESTOQUE
	Local oF4_ICM
	Local oF4_IPI
	Local oF4_CF
	Local oF4_TEXTO
	Local oF4_LFICM
	Local oF4_LFIPI
	Local oF4_PISCOF
	Local xF4_CODIGO 	:= SF4->F4_CODIGO
	Local xF4_TIPO 	:= iif(SF4->F4_TIPO == "E","Entrada","Saida")
	Local xF4_DUPLIC	:= iif(SF4->F4_DUPLIC == "S","Sim","Nao")
	Local xF4_ESTOQUE := iif(SF4->F4_ESTOQUE == "S","Sim","Nao")
	Local xF4_ICM 		:= iif(SF4->F4_ICM == "S","Sim","Nao")
	Local xF4_IPI 		:= iif(SF4->F4_IPI == "S","Sim",iif(SF4->F4_IPI == "N","Nao","Com.Nao Atac."))
	Local xF4_CF		:= SF4->F4_CF
	Local xF4_TEXTO	:= SF4->F4_TEXTO
	Local xF4_LFICM 	:= iif(SF4->F4_LFICM=="T","Tributado",iif(SF4->F4_LFICM=="I","Isento",iif(SF4->F4_LFICM=="O","Outros",Iif(SF4->F4_LFICM=="N","Nao",iif(SF4->F4_LFICM=="Z","ICMS Zerado","Observacao")))))
	Local xF4_LFIPI 	:= iif(SF4->F4_LFIPI=="T","Tributado",iif(SF4->F4_LFIPI=="I","Isento",iif(SF4->F4_LFIPI=="O","Outros",Iif(SF4->F4_LFIPI=="N","Nao",iif(SF4->F4_LFIPI=="Z","IPI Zerado","Vl.IPI Outr.ICM")))))
	Local xF4_PISCOF 	:= iif(SF4->F4_PISCOF=="1","PIS",iif(SF4->F4_PISCOF=="2","COFINS",iif(SF4->F4_PISCOF=="3","Ambos",Iif(SF4->F4_PISCOF=="4","Nao Considera",""))))
	Local i := 0 
	Local j := 0 
 
	Private oJanela    
	Private oF4_CODDES
	Private cNomeCampo
	Private cConteudo
	Private nPosicao
	Private xF4_CODORI	:= SF4->F4_CODIGO
	Private xF4_TIPORI 	:= SF4->F4_TIPO
	Private xF4_CODDES 	:= Space(Len(SF4->F4_CODIGO))	//	Substr(SF4->F4_CODIGO, 1, 1) + "ZZ"
	Private lContinua 	:= .F.
	Private lFecha	 		:= .F.
	Private aCampos   	:= {}
	Private aRegistro		:= {}
	Private aButtons		:= {}                                                                                                                                                    
	
	//�������������������
	//�Definicao de tela�
	//�������������������
	DEFINE MSDIALOG oJanela TITLE "Copia do Tipo de E/S " + Alltrim(xF4_CODORI) FROM 000,000 TO 400,700 PIXEL  
		EnchoiceBar(oJanela, {|| lContinua 	:= .F.,Close(oJanela)},{|| lContinua := .F.,Close(oJanela)},,aButtons)

		@ 004,003 GROUP oGroup1 TO 116, 344 PROMPT "  Origem:    "	OF oJanela COLOR 0,16777215 PIXEL
		@ 120,003 GROUP oGroup2 TO 176, 344 PROMPT "  Destino:   "	OF oJanela COLOR 0,16777215 PIXEL

    	@ 133,010 SAY oSay12	PROMPT "C�d. Novo:" 			SIZE 034,007 OF oJanela COLORS 0,16777215 PIXEL
    	@ 017,010 SAY oSay1 	PROMPT "C�digo:" 		  		SIZE 034,007 OF oJanela COLORS 0,16777215 PIXEL
    	@ 017,122 SAY oSay2 	PROMPT "Tipo do TES:" 		SIZE 032,007 OF oJanela COLORS 0,16777215 PIXEL
    	@ 017,237 SAY oSay3 	PROMPT "Gera Dupli:" 		SIZE 038,007 OF oJanela COLORS 0,16777215 PIXEL
    	@ 033,010 SAY oSay4 	PROMPT "Atu Estoque:" 		SIZE 032,007 OF oJanela COLORS 0,16777215 PIXEL
    	@ 033,237 SAY oSay5 	PROMPT "Calc. ICMS:"   		SIZE 032,007 OF oJanela COLORS 0,16777215 PIXEL
    	@ 049,010 SAY oSay6 	PROMPT "Calc. IPI:" 			SIZE 032,007 OF oJanela COLORS 0,16777215 PIXEL
    	@ 033,122 SAY oSay7 	PROMPT "C�d. Fiscal:"		SIZE 034,007 OF oJanela COLORS 0,16777215 PIXEL
    	@ 049,122 SAY oSay8 	PROMPT "Txt Padr�o:" 		SIZE 034,007 OF oJanela COLORS 0,16777215 PIXEL
    	@ 065,010 SAY oSay9 	PROMPT "L.Fisc.ICMS:" 		SIZE 032,007 OF oJanela COLORS 0,16777215 PIXEL
    	@ 065,122 SAY oSay10 	PROMPT "L.Fisc.IPI:" 	SIZE 032,007 OF oJanela COLORS 0,16777215 PIXEL
    	@ 065,237 SAY oSay11 	PROMPT "PIS/COFINS:" 	SIZE 032,007 OF oJanela COLORS 0,16777215 PIXEL
    
    	@ 133,048 MSGET oF4_CODDES 	VAR xF4_CODDES 	SIZE 023,010 OF oJanela COLORS 0,16777215 Valid ValidTES()				PIXEL
    	@ 017,048 MSGET oF4_CODIGO		VAR xF4_CODIGO 	SIZE 023,010 OF oJanela COLORS 0,16777215 						READONLY PIXEL
    	@ 017,159 MSGET oF4_TIPO		VAR xF4_TIPO 		SIZE 051,010 OF oJanela COLORS 0,16777215	 						READONLY PIXEL
    	@ 017,275 MSGET oF4_DUPLIC		VAR xF4_DUPLIC 	SIZE 051,010 OF oJanela COLORS 0,16777215 						READONLY PIXEL
    	@ 033,048 MSGET oF4_ESTOQUE	VAR xF4_ESTOQUE 	SIZE 051,010 OF oJanela COLORS 0,16777215 						READONLY PIXEL
    	@ 033,159 MSGET oF4_CF 			VAR xF4_CF 			SIZE 035,010 OF oJanela COLORS 0,16777215 						READONLY PIXEL
    	@ 033,275 MSGET oF4_ICM			VAR xF4_ICM		 	SIZE 051,010 OF oJanela COLORS 0,16777215 						READONLY PIXEL
    	@ 049,048 MSGET oF4_IPI 		VAR xF4_IPI 		SIZE 051,010 OF oJanela COLORS 0,16777215	 						READONLY PIXEL
    	@ 049,159 MSGET oF4_TEXTO 		VAR xF4_TEXTO 		SIZE 166,010 OF oJanela COLORS 0,16777215 						READONLY PIXEL
    	@ 065,048 MSGET oF4_LFICM		VAR xF4_LFICM 		SIZE 051,010 OF oJanela COLORS 0,16777215 						READONLY PIXEL
    	@ 065,159 MSGET oF4_LFIPI 		VAR xF4_LFIPI 		SIZE 051,010 OF oJanela COLORS 0,16777215 						READONLY PIXEL
    	@ 065,275 MSGET oF4_PISCOF		VAR xF4_PISCOF		SIZE 051,010 OF oJanela COLORS 0,16777215 						READONLY PIXEL
	ACTIVATE MSDIALOG oJanela CENTERED VALID TudoOK()
	
//	If !lContinua .Or. Empty(xF4_CODDES)
//   	Return (.T.)
//	Endif

	If lContinua
		If MsgBox("Confirma a inclusao do Tipo de Entrada/Saida " + Alltrim(xF4_CODDES) + " no Cadastro?","Tipos de Entrada/Saida","YESNO")
			//���������������������������������������������������������
			//�Captar os dados do tipo de Entrada/Saida atual (Origem)�
			//���������������������������������������������������������
		   dbSelectArea("SF4")
	
			//����������������������������
			//�Captar os campos de origem�
			//����������������������������
		   For i := 1 To FCount()
	    		cNomeCampo := Upper(Alltrim(FieldName(i)))
	       	cConteudo  := FieldGet(i)
	       	nPosicao   := FieldPos(cNomeCampo)
	
	       	If cNomeCampo == "F4_CODIGO"
	          	aAdd(aCampos,xF4_CODDES)
	       	Elseif cNomeCampo == "F4_FINALID"
	          	aAdd(aCampos, "*** REVISAR *** " + cConteudo)
	       	Else
	          	aAdd(aCampos, cConteudo)
	       	Endif
	  		Next i
	
			//��������������������������������������������������������
			//�Acumular o registro de origem p/ o registro de destino�
			//��������������������������������������������������������
		   If Len(aCampos) > 0
	   	   aAdd(aRegistro, aCampos)
	   	Endif
	
			//�����������������������������������������������������������
			//�Copiar o registro de origem p/ o novo registro de destino�
			//�����������������������������������������������������������
		   For i := 1 To Len(aRegistro)
				//�������������������������������������������������
				//�Verificar e gravar os dados copiados no destino�
				//�������������������������������������������������
	       	SF4->(DbSetOrder(1))
	       	SF4->(DbSeek(xFilial("SF4") + xF4_CODDES, .F.))
	
				//��������������������
				//�Incluir o Registro�
				//��������������������
				If SF4->(!Found())
	          	DbSelectArea("SF4")
	          	If SF4->(Reclock("SF4",.T.))
	             	For j := 1 To FCount()
	                 	FieldPut(j,aRegistro[i,j])
	             	Next j
		          	
		          	SF4->(MsUnlock())
		      	Endif
	      	Endif
			Next i
		Endif
	Endif
Return (.T.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TudoOK    �Autor  �Microsiga           � Data �  27/01/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function TudoOK()
	Local lTOK 	:= .F.
	
	lTOK := ValidTES()
	
	If lTOK
		lContinua := .T.
	Endif
Return(lTOK)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ValidTES  �Autor  �Microsiga           � Data �  27/01/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ValidTES()
	Local __cAlias  	:= Alias()
	Local __nOrder  	:= IndexOrd()
	Local __nRecno 	:= Recno()

	Local __nRegSF4 	:= SF4->(Recno())
	Local __nOrdSF4 	:= SF4->(IndexOrd())

	//�����������������������������������������������������������
	//�Status de Tipo de Entrada/Saida Valido (.T.) ou Nao (.F.)�
	//�����������������������������������������������������������
	Local lRetorno := .T.

	If Empty(xF4_CODDES)
	   MsgBox("O Codigo do Tipo de Entrada/Saida a ser criado deve ser informado, verifique !!!", "Atencao !!!", "ALERT")
   	lRetorno 	:= .F.
	Endif
	
	SF4->(DbSetOrder(1))
	SF4->(DbSeek(xFilial("SF4") + xF4_CODDES,.F.))

	If SF4->(Found()) .And. !Empty(xF4_CODDES)
	   MsgBox("O Codigo do Tipo de Entrada/Saida a ser criado " + Alltrim(xF4_CODDES) + " ja esta cadastrado no sistema, verifique !!!", "Atencao !!!", "ALERT")
   	lRetorno 	:= .F.
	Endif

	If xF4_CODDES <= "500" .And. xF4_TIPORI $ "S,"
	   MsgBox("O Tipo de Entrada/Saida " + Alltrim(xF4_CODDES) + " deve ser de saida de acordo com o tipo de origem, verifique !!!", "Atencao !!!", "ALERT")
   	lRetorno 	:= .F.
	Elseif xF4_CODDES > "500" .And. xF4_TIPORI $ "E,"
	   MsgBox("O Tipo de Entrada/Sa�da " + Alltrim(xF4_CODDES) + " deve ser de entrada de acordo com o tipo de origem, Verifique !!!", "Atencao !!!", "ALERT")
   	lRetorno 	:= .F.
	Endif

	If Len(Alltrim(xF4_CODDES)) < Len(SF4->F4_CODIGO) .And. !Empty(xF4_CODDES)
	   MsgBox("O Tipo de Entrada/Sa�da " + Alltrim(xF4_CODDES) + " deve possuir o tamanho de " + Alltrim(Str(Len(SF4->F4_CODIGO), 10)) + " posicoes para ser valido, verifique !!!", "Atencao !!!", "ALERT")
   	lRetorno 	:= .F.
	Endif

	//���������������������
	//�Restaurar Contextos�
	//���������������������
	SF4->(DbSetOrder(__nOrdSF4))
	SF4->(DbGoTo(__nRegSF4))

	dbSelectArea(__cAlias)
	dbSetOrder(__nOrder)
	dbGoTo(__nRecno)

//	If !_lRetorno
//   	xF4_CODDES := Space(Len(SF4->F4_CODIGO))
//	Endif
Return (lRetorno)