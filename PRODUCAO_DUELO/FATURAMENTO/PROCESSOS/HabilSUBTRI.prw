#include "rwmake.ch"
#INCLUDE "colors.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³HABILEASY   º Autor ³ MARCUS PLATÃO    º Data ³  01/07/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ HABILITA E DESABILITA O PARAMETRO    MV_EASY               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºP/  Criar ³ Paramêtro: 	 AL_HABEASY                                    º±±
±±º          ³ Tipo: 	     CARACTER  											  º±±         
±±º			 ³ Conteúdo Ex.: 000002;000005 		   							  º±±
±±º          ³ Descrição:    Informar o ID dos Usuários separados por ";" º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP11 IDE                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function HabilSUBTRI()
Local cPrograma := "HABILSUBTRIB"

//########################
//DECLARAÇÃO DAS VARIÁVEIS
//########################

cConteudoAtual   	:=""
cNovoConteudo		:= Space(250)
cUsuarioAuto		:="" 
cUsuarioLoga		:=""



//################
//CAIXA DE DIALOGO
//################

//@ 180,040 SAY Transform(nValor,"@E 999,999.99") COLOR CLR_GREEN object oValor

@ 0,0 to 200,400 Dialog oDlg Title "Habilita e Desabilita o Parâmetro MV_SUBTRIB"

cConteudoAtual := GetMV("MV_SUBTRIB")
@ 15,10 Say "Conteúdo Atual: " 
@ 15,61 Say cConteudoAtual COLOR CLR_GREEN

@ 30,10 Say "Novo Conteúdo: "
@ 30,60 Get cNovoConteudo picture "@!" Size 70,10
//@ 30,60 Get cNovoConteudo Valid ValConteudo(cNovoConteudo) picture "@!" Size 15,10

@ 50,10 SAY "Conteúdo PADRÃO:  AP030343437 " 
 
@ 65,10 SAY "Usuário Logado: " 
@ 65,54 SAY Substr(__cUSERID,1) + " - " + UsrFullName(__cUserID)  COLOR CLR_BLUE  

@ 75,10 BmpButton Type 1 Action	Processa( {|| okproc() } )
@ 75,60 BmpButton Type 2 Action Close(oDlg)             

@ 90,10 SAY "Suporte: Em caso de Adição de Usuário, Verificar  -->  US_USERTRI " COLOR CLR_RED


ACTIVATE DIALOG oDlg CENTER

return nil



//##########################################
//ROTINA PARA LIBERACAO DE ACESSO AO USUARIO
//##########################################

/***********************/
static function okproc()
/***********************/

cUsuarioLoga    := __cUSERID
cUsuarioAuto	 := GetMV("US_USERTRI")

   
If  cUsuarioLoga $ cUsuarioAuto
   		MSGINFO("Usuário Autorizado !!!" +chr(13)+chr(10)+"Parâmetro Atualizado Com Sucesso !!!") 
//			alltrim(GetMV("MV_EASY"))    		//Pega o parametro
   		PutMv("MV_SUBTRIB",cNovoConteudo)   //Grava no Parametro
	Close(oDlg)                                          
Else
 		MSGSTOP("Você NÃO está autorizado a alterar este parâmetro." +chr(13)+chr(10)+"Suporte: Verificar o Parâmetro AL_HABEASY") 
 		
EndIf


Return nil     

///////////////////////////////////////
Static Function ValConteudo(_pConteudo)  
//////////////////////////////////////
                                       
Local _lRet:= .T.

	If !(_pConteudo $ "SN")
		MSGSTOP ("Favor Informar S ou N  !")
		_lRet:= .F.
	EndIf

Return _lRet 