#INCLUDE "RWMAKE.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA650OK �Autor Rafael Almeida - SIGACORP� Data �27/10/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � INIBIR DIALOGO CONFIRMANDO CRIA��O DE OPS INTERMEDI�RIAS   ���
���          �  E SCS.                                                    ���
�������������������������������������������������������������������������͹��
���Uso       � ESTOQUE / CUSTOS                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function A650LEMP()
Local aLinCol     := PARAMIXB  //Conteudo da linha do aCols  possicionado
Local _lActivRot  := GetNewPar("US_A261TOK",.T.) 
Local cRetLocal   := ""

If _lActivRot
	If aLinCol[3]=="01"
		cRetLocal := "11"
	ElseIf 	aLinCol[3]=="02"
		cRetLocal := "12"
	EndIf
EndIf

Return cRetLocal
