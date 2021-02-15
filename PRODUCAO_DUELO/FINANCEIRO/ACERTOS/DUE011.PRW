#INCLUDE "rwmake.ch"

/*/
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DUE011    Autor ³ LIOMAR A. RATKIEWICZ    Data   06/11/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Geração de Código sequencial p/ Clientes e Fornecedores    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ VINHOS DUELO                                               º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/                 

User Function DUE011

//³ Declaracao de Variaveis                                             ³

Private cCod

Private cCod := ""

  @ 080, 130 TO 270, 450 DIALOG oDlg1 TITLE "Gerar Códigos Sequenciais"
   
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
