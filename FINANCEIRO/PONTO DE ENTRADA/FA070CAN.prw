#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  FA070CAN �Autor  �Rafael Almeida       � Data �   11/12/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada executado quando os dados da tabela SE1   ���
���          � j� est�o gravado no momento do cancelamento da baixa sendo ���
���          � assim podemos manipula os campos de usuarios               ���
�������������������������������������������������������������������������͹��
���Uso       � FINA070 - Rotina cancelamento de Baixa                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FA070CAN()
	
DbSelectArea("ZCG")
DbSetOrder(2)                                           
DBSEEK(xFilial("ZCG")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_FILORIG)  // ZCG_PREFIX, ZCG_TITULO, ZCG_PARCEL, ZCG_TIPO, ZCG_FILORI
        WHILE !EOF().AND. ZCG_PREFIX+ZCG_TITULO+ZCG_PARCEL+ZCG_TIPO+ZCG_FILORI = SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_FILORIG
        	If ZCG_STATUS=="1"
				Reclock("ZCG",.F.)
					ZCG->ZCG_STATUS := "2"
				ZCG->(MSUnlock())
        	EndIf
         DBSKIP()
        ENDDO      	
DbCloseArea("ZCG")
Return()