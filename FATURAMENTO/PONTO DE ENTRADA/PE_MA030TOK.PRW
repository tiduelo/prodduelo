#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  MA030TOK º Autor ³ RAFAEL ALMEIDA - SIGACORP º Data ³05/05/16º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ validação da digitação na inclusão e alteração de clientes º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA030 - Cadatro de Cliente                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MA030TOK()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
local ret      := .T. 
Local cVend    := A1_VEND
Local cClie    := A1_COD
Local cLoja    := A1_LOJA
Local cRota    := A1_ROTA
Local CliAlt   := M->A1_COD
Local LojAlt   := M->A1_LOJA
Local VddAlt   := M->A1_VEND
Local RotAlt   := M->A1_ROTA

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Iniciando o Processamento - Validação                               ³
//³ Se o cliente for pessoa Juridica é obrigado informar a Inscrição    ³
//³ estadual.                                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If M->A1_PESSOA=="J" .And. Empty(M->A1_INSCR) 
     MsgAlert("Atenção! Inscricão Estadual inválida!") 
     ret := .F. 
endif 
           
If ret
	If      Alltrim(cClie) # Alltrim(M->A1_COD)    //Inclusão de Novo Cliente 
		ret := U_UOMSA090(CliAlt,LojAlt,VddAlt,RotAlt,"INC",cVend,cRota)
	ElseIf  (Alltrim(cClie) == Alltrim(M->A1_COD)) .And. (Alltrim(cVend) # Alltrim(M->A1_VEND))   //Alteração do Vendedor
		ret := U_UOMSA090(CliAlt,LojAlt,VddAlt,RotAlt,"ALT",cVend,cRota)
	ElseIf  (Alltrim(cClie) == Alltrim(M->A1_COD)) .And. (Alltrim(cRota) # Alltrim(M->A1_ROTA)) //Alteração da Rota
		ret := U_UOMSA090(CliAlt,LojAlt,VddAlt,RotAlt,"ROT",cVend,cRota)
	EndIf
EndIf

If ALTERA .And. ret 
	If M->A1_PRF_OBS <> SA1->A1_PRF_OBS
		ret := U_ZDDVldUsr("SA1" , "A1_PRF_OBS", M->A1_PRF_OBS , SA1->A1_PRF_OBS )			
	EndIf
EndIf

Return ret 