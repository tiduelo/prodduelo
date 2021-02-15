#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT110END  � Autor� RAFAEL ALMEIDA SIGACORP �Data � 12/05/17 ���
�������������������������������������������������������������������������͹��
���Descricao � Ap�s o acionamento dos bot�es Solicita��o Aprovada,        ���
���          � Rejeita ou Bloqueada, deve ser utilizado para valida��es   ���
���          � do usuario ap�s a execu��o das a��es dos bot�es.           ���
�������������������������������������������������������������������������͹��
���Uso       � MATA110                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/       
User Function MT110END()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������   

 Local nNumSC := PARAMIXB[1]       // Numero da Solicita��o de compras
 Local nOpca  := PARAMIXB[2]       // 1 = Aprovar; 2 = Rejeitar; 3 = Bloquear 
 Local cUpdate := ""


	BEGIN TRANSACTION
		cUpdate := " "
		cUpdate += " UPDATE "+RetSQLName("SC1")+" "
		cUpdate += " 	SET C1_SITSC  = '"+ cValToChar(nOpca)   +"'  "
		cUpdate += " 	,   C1_DTAPRO = '"+ DtoS(Date()) +"'  "
		cUpdate += " 	,   C1_NMAPRO1 = '"+ Alltrim(UsrFullName(RetCodUsr())) +"'  "				
		cUpdate += " WHERE 	C1_FILIAL  = '"+ xFilial("SC1")   +"'  "
		cUpdate += " 	AND	C1_NUM  = '"+Alltrim(nNumSC) +"'  "
		cUpdate += " 	AND	D_E_L_E_T_ = ''             "
		TcSqlExec(cUpdate)
		TcSqlExec("COMMIT")
	END TRANSACTION


/*
DbSelectArea("SC1")
DbSetOrder(1)
Set Filter To SC1->C1_NUM == nNumSC

While !Eof() .And. SC1->C1_NUM == nNumSC

	RECLOCK("SC1",.F.)
		SC1->C1_SITSC  := cValToChar(nOpca)
		SC1->C1_DTAPRO := Date()
	MSUNLOCK() 
	
Dbskip()
Enddo
*/
    
Return ()
