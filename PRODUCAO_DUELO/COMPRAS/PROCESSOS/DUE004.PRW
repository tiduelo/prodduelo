#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/00

User Function DUE004()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/00

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("NLIN,NLININI,NOPC,CCOR,NTEL,CCADASTRO")
SetPrvt("AROTINA,")

cCadastro := OemToAnsi("Informar Centro de Custos nos Itens da NF. de Entrada")


aRotina    := {{OemToAnsi("Pesquisar")          ,'AxPesqui'             ,0,2},;
               {OemToAnsi("Incluir C.C.")     ,'EXECBLOCK("DUE004A",.F.,.F.)',0,3}}

DbSelectArea("SD1")
SD1->(Dbgotop())
mBrowse(06, 01, 22, 75, "SD1")

RETURN

