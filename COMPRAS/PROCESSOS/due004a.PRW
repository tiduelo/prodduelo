#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/00
          

User Function DUE004A()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/00

SetPrvt("cCusto,LREFRESH,")

cCusto := space(10)


   @ 080, 130 TO 270, 450 DIALOG oDlg1 TITLE "Incluir Centro de Custo"
   
   @ 015, 010 SAY "Centro de Custos: "
   @ 015, 080 GET cCusto  Picture "@!"    size 55,10 F3 "SI3"
   
   @ 050, 080 BMPBUTTON TYPE 1 ACTION GravaDados() 
   @ 050, 114 BMPBUTTON TYPE 2 ACTION Close(oDlg1) 

   ACTIVATE DIALOG oDlg1 CENTERED

   LRefresh := .t.

Return(Nil) 

// Gravar Dados
//--------------

Static Function GravaDados()

If LastKey() != 27
   dbSelectArea("SD1")               
   
   RecLock('SD1',.F.)
   
    SD1->D1_CC := cCusto
   
    MSUNLOCK('SD1')
   
EndIf

Set Cursor Off    

#IFDEF WINDOWS
   Close(oDlg1)
#ENDIF

Return(nil)        // incluido pelo assistente de conversao do AP5 IDE em 19/08/00

