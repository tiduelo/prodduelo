#include "rwmake.ch"
#INCLUDE "colors.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �HABILEASY   � Autor � MARCUS PLAT�O    � Data �  01/07/2016 ���
�������������������������������������������������������������������������͹��
���Descricao � HABILITA E DESABILITA O PARAMETRO    MV_EASY               ���
�������������������������������������������������������������������������͹��
���P/  Criar � Param�tro: 	 AL_HABEASY                                    ���
���          � Tipo: 	     CARACTER  											  ���         
���			 � Conte�do Ex.: 000002;000005 		   							  ���
���          � Descri��o:    Informar o ID dos Usu�rios separados por ";" ���
�������������������������������������������������������������������������͹��
���Uso       � AP11 IDE                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function HabilSUBTRI()
Local cPrograma := "HABILSUBTRIB"

//########################
//DECLARA��O DAS VARI�VEIS
//########################

cConteudoAtual   	:=""
cNovoConteudo		:= Space(250)
cUsuarioAuto		:="" 
cUsuarioLoga		:=""



//################
//CAIXA DE DIALOGO
//################

//@ 180,040 SAY Transform(nValor,"@E 999,999.99") COLOR CLR_GREEN object oValor

@ 0,0 to 200,400 Dialog oDlg Title "Habilita e Desabilita o Par�metro MV_SUBTRIB"

cConteudoAtual := GetMV("MV_SUBTRIB")
@ 15,10 Say "Conte�do Atual: " 
@ 15,61 Say cConteudoAtual COLOR CLR_GREEN

@ 30,10 Say "Novo Conte�do: "
@ 30,60 Get cNovoConteudo picture "@!" Size 70,10
//@ 30,60 Get cNovoConteudo Valid ValConteudo(cNovoConteudo) picture "@!" Size 15,10

@ 50,10 SAY "Conte�do PADR�O:  AP030343437 " 
 
@ 65,10 SAY "Usu�rio Logado: " 
@ 65,54 SAY Substr(__cUSERID,1) + " - " + UsrFullName(__cUserID)  COLOR CLR_BLUE  

@ 75,10 BmpButton Type 1 Action	Processa( {|| okproc() } )
@ 75,60 BmpButton Type 2 Action Close(oDlg)             

@ 90,10 SAY "Suporte: Em caso de Adi��o de Usu�rio, Verificar  -->  US_USERTRI " COLOR CLR_RED


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
   		MSGINFO("Usu�rio Autorizado !!!" +chr(13)+chr(10)+"Par�metro Atualizado Com Sucesso !!!") 
//			alltrim(GetMV("MV_EASY"))    		//Pega o parametro
   		PutMv("MV_SUBTRIB",cNovoConteudo)   //Grava no Parametro
	Close(oDlg)                                          
Else
 		MSGSTOP("Voc� N�O est� autorizado a alterar este par�metro." +chr(13)+chr(10)+"Suporte: Verificar o Par�metro AL_HABEASY") 
 		
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