#INCLUDE "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EstCltOp  � Autor �Rafael Almeida(SIGACORP)�Data �18/08/17  ���
�������������������������������������������������������������������������͹��
���Descricao � Gatilo para preecher o numero do Lote na rotina da Produ��o���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MATA250                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function EstCltOp()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local _cLtCTL := ""
local _dAno := (DateDiffDay(M->D3_EMISSAO,FirstYDate(M->D3_EMISSAO))+1)

//���������������������������������������������������������������������Ŀ
//�Processamento:                                                      �
//				Existe uma logica para o numero de lote para tampico   �
//				caso o produto n�o seja tampico o numero do lote ser�  �
//				Numero da OP.									       �
//�Regra NUMERO LOTEP                                                  �
//			"109"+ultimo digito do ano + numero do dia referente ao ano�
//�����������������������������������������������������������������������
//ALERT(_dAno)
If FunName()=="MATA250"
	If GetAdvFVal("SB1", "B1_RASTRO",xFilial("SB1")+M->D3_COD,1)$"L"
		If M->D3_GRUPO$"0205"
			If  _dAno < 100
				_cLtCTL := "109"+SubStr(DtoS(M->D3_EMISSAO),4,1)+'0'+cValToChar(_dAno)//(DateDiffDay(M->D3_EMISSAO,FirstYDate( M->D3_EMISSAO))+1)
			Else
				_cLtCTL := "109"+SubStr(DtoS(M->D3_EMISSAO),4,1)+cValToChar((DateDiffDay(M->D3_EMISSAO,FirstYDate( M->D3_EMISSAO)))+1)
			Endif
			Else
				_cLtCTL := SubStr(M->D3_OP,1,6)
			EndIf
		Else
			_cLtCTL := ""
		EndIf
	EndIf
	
	Return(_cLtCTL)
