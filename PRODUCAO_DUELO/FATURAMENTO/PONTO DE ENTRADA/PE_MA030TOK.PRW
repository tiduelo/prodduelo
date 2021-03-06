#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  MA030TOK � Autor � RAFAEL ALMEIDA - SIGACORP � Data �05/05/16���
�������������������������������������������������������������������������͹��
���Descricao � valida��o da digita��o na inclus�o e altera��o de clientes ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MATA030 - Cadatro de Cliente                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MA030TOK()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
local ret      := .T. 
Local cVend    := A1_VEND
Local cClie    := A1_COD
Local cLoja    := A1_LOJA
Local cRota    := A1_ROTA
Local CliAlt   := M->A1_COD
Local LojAlt   := M->A1_LOJA
Local VddAlt   := M->A1_VEND
Local RotAlt   := M->A1_ROTA

//���������������������������������������������������������������������Ŀ
//� Iniciando o Processamento - Valida��o                               �
//� Se o cliente for pessoa Juridica � obrigado informar a Inscri��o    �
//� estadual.                                                           �
//�����������������������������������������������������������������������
If M->A1_PESSOA=="J" .And. Empty(M->A1_INSCR) 
     MsgAlert("Aten��o! Inscric�o Estadual inv�lida!") 
     ret := .F. 
endif 
           
If ret
	If      Alltrim(cClie) # Alltrim(M->A1_COD)    //Inclus�o de Novo Cliente 
		ret := U_UOMSA090(CliAlt,LojAlt,VddAlt,RotAlt,"INC",cVend,cRota)
	ElseIf  (Alltrim(cClie) == Alltrim(M->A1_COD)) .And. (Alltrim(cVend) # Alltrim(M->A1_VEND))   //Altera��o do Vendedor
		ret := U_UOMSA090(CliAlt,LojAlt,VddAlt,RotAlt,"ALT",cVend,cRota)
	ElseIf  (Alltrim(cClie) == Alltrim(M->A1_COD)) .And. (Alltrim(cRota) # Alltrim(M->A1_ROTA)) //Altera��o da Rota
		ret := U_UOMSA090(CliAlt,LojAlt,VddAlt,RotAlt,"ROT",cVend,cRota)
	EndIf
EndIf

If ALTERA .And. ret 
	If M->A1_PRF_OBS <> SA1->A1_PRF_OBS
		ret := U_ZDDVldUsr("SA1" , "A1_PRF_OBS", M->A1_PRF_OBS , SA1->A1_PRF_OBS )			
	EndIf
EndIf

Return ret 