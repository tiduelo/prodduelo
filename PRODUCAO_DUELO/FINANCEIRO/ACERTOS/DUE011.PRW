#INCLUDE "rwmake.ch"

/*/
�������������������������������������������������������������������������ͻ��
���Programa  �DUE011    Autor � LIOMAR A. RATKIEWICZ    Data   06/11/01   ���
�������������������������������������������������������������������������͹��
���Descricao � Gera��o de C�digo sequencial p/ Clientes e Fornecedores    ���
�������������������������������������������������������������������������͹��
���Uso       � VINHOS DUELO                                               ���
�����������������������������������������������������������������������������
/*/                 

User Function DUE011

//� Declaracao de Variaveis                                             �

Private cCod

Private cCod := ""

  @ 080, 130 TO 270, 450 DIALOG oDlg1 TITLE "Gerar C�digos Sequenciais"
   
   @ 015, 010 SAY "Este Programa Gera Codigos Sequenciais p/ "
   @ 025, 010 SAY "cadastros de Clientes e Fornecedores"   
   @ 050, 080 BMPBUTTON TYPE 1 ACTION OKPROC() 
   @ 050, 114 BMPBUTTON TYPE 2 ACTION Close(oDlg1) 

   ACTIVATE DIALOG oDlg1 CENTERED

Return(Nil) 

// Gravar Dados
//--------------

Static Function OKPROC()

dbSelectArea("SA1")
dbSetOrder(1)

While !SA1->(eof())
     cCod := GetSX8Num("SA1")
     RecLock("SA1",.F.)
     SA1->A1_COD := cCod
     MsUnlock("SF2")
EndDo

Return