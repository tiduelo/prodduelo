#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/00

User Function DUE004()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/00

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("NLIN,NLININI,NOPC,CCOR,NTEL,CCADASTRO")
SetPrvt("AROTINA,")

cCadastro := OemToAnsi("Informar Centro de Custos nos Itens da NF. de Entrada")


aRotina    := {{OemToAnsi("Pesquisar")          ,'AxPesqui'             ,0,2},;
               {OemToAnsi("Incluir C.C.")     ,'EXECBLOCK("DUE004A",.F.,.F.)',0,3}}

DbSelectArea("SD1")
SD1->(Dbgotop())
mBrowse(06, 01, 22, 75, "SD1")

RETURN

