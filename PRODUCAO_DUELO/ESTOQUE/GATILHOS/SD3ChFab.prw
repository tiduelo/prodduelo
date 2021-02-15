#include "Rwmake.ch"
#include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ESTPC01   �Autor  �Henio Brasil        � Data � 02/10/2012  ���
�������������������������������������������������������������������������͹��
���Desc.     �Calculo do valor total da Producao para os PAs gerados na   ���
���          �Fabrica                                                     ���
�������������������������������������������������������������������������͹��
���Uso       �Vinhos Duelo Ltda                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
User Function SD3ChFab()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Private cUpdate := ""
Private nLastKey     := 0
Private cPerg    := "SD3FAB"


//���������������������������������������������������������������������Ŀ
//� Pergunta                                                           �
//�����������������������������������������������������������������������
If !Pergunte(cPerg, .T. )
	Return nil
Endif

If nLastKey==27
	Return
Endif

//���������������������������������������������������������������������Ŀ
//� Executando o processo                                               �
//�����������������������������������������������������������������������
BEGIN TRANSACTION
	cUpdate := " "
	cUpdate += " UPDATE "+RetSQLName("SD3")+" "
	cUpdate += " 	SET D3_CHAOFAB  = '1'  "
	cUpdate += " WHERE 	D3_FILIAL  = '"+ xFilial("SD3")   +"'  "
	cUpdate += " 	AND	D_E_L_E_T_ = ''             "
	cUpdate += " 	AND D3_EMISSAO BETWEEN '"+ DTOS(MV_PAR01) + "' AND '"+ DTOS(MV_PAR02) + "' "
	cUpdate += " 	AND D3_DOC IN (SELECT DISTINCT D3_DOC FROM "+RetSQLName("SD3")+"  WHERE D_E_L_E_T_ = ''AND D3_FILIAL = '"+ xFilial("SD3")   +"'  "
	cUpdate += " 	AND D3_EMISSAO BETWEEN '"+ DTOS(MV_PAR01) + "' AND '"+ DTOS(MV_PAR02) + "' AND D3_LOCAL IN ('11','12') AND D3_CF IN ('DE4','RE4'))   "
	TcSqlExec(cUpdate)
	TcSqlExec("COMMIT")
END TRANSACTION

MsgInfo("Fim!!!","OK")

Return()