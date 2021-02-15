#INCLUDE "protheus.ch"
#INCLUDE "TOPCONN.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
�������������������������������������������������������������������������͹��
���Descricao �INFORMA DATA PARA TRAVAR O ESTOQUE   22/08/16               ���
���          �RONALDO MAIA									              ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function PAREST()

Private oEst                                                    
Private cFimLin := (chr(13)+chr(10))
Private dDTEST := getmv("MV_ULMES")
Private oDTEST
Private cMsg1 := "Aten��o, n�o ser� poss�vel efetuar"
pRIVATE cMsg2 := "movimenta��es anteriores a data"
pRIVATE cMsg3 := "informada!!!"

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
DEFINE MSDIALOG oEst from 000,000 to 150,270 title "�ltimo Fechamento" pixel
@ 005,005 Say OemToAnsi("Estoque: ") PIXEL COLORS CLR_HBLUE OF oEst 
@ 005,050 MsGet oDTEST VAR dDTEST SIZE 40,08 PIXEL OF oEst Valid !empty(dDTEST)

@ 005,100 BUTTON "Confirmar" OF oEST SIZE 030,010 PIXEL ACTION EstOK(.t.,dDTEST)
@ 025,100 BUTTON "Cancelar" OF oEST SIZE 030,010 PIXEL ACTION EstOK(.f.)

@ 030,005 Say OemToAnsi(cMsg1) PIXEL COLORS CLR_HRED OF oEst                                                  
@ 040,005 Say OemToAnsi(cMsg2) PIXEL COLORS CLR_HRED OF oEst                                                  
@ 050,005 Say OemToAnsi(cMsg3) PIXEL COLORS CLR_HRED OF oEst                                                  

ACTIVATE MSDIALOG oEst CENTER

Return(.T.)


static function EstOk(lPar,dParEST)

if lPar
     if MsgYESNO("Confirma atualiza��o de data de fechamento?","Atencao...","YESNO")
          putmv("MV_ULMES",dParEst)

          
     MsgInfo("Fechamento Estoque: "+dtoc(dParEst)+chr(13)+chr(10))

     endif
endif 

oEst:end()

return(.t.)