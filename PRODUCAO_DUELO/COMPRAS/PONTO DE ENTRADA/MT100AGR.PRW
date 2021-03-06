#include "rwmake.ch"        

User Function MT100AGR()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("XMENS1,XMENS2,XMENS3")

/*
_____________________________________________________________________________
└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└�
└+-----------------------------------------------------------------------+└
└쪭un醴o    쪴T100AGR  � Autor � Ary Medeiros          � Data � 15.02.96 └�
└+----------+------------------------------------------------------------└�
└쪫escri醴o 쪷ONTO DE ENTRADA NA DIGITACAO NF ENTRADA                    └�
└+----------+------------------------------------------------------------└�
└� Uso      쪬xclusivo para Vinhos Duelo                                 └�
└+----------+------------------------------------------------------------└�
└� Objetivo 쪰nformar observacoes a serem impressas na nf de entrada.    └�
└+-----------------------------------------------------------------------+└
└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└�
�����������������������������������������������������������������������������
*/              

if (sf1->f1_tipo == "N") .and. (sf1->f1_formul == "S")

	xMens1 := space(70)
	xMens2 := space(70)
	xMens3 := space(70)

	@ 0,0 TO 230,500 DIALOG oDlg TITLE "Observacao para Nota Fiscal de Entrada"
	@ 010,010 SAY "Mensagem 1 : " SIZE 50,10
	@ 030,010 SAY "Mensagem 2 : " SIZE 50,10
	@ 050,010 SAY "Mensagem 3 : " SIZE 50,10
	@ 010,070 GET xMens1 PICTURE "@!" SIZE 120,10
	@ 030,070 GET xMens2 PICTURE "@!" SIZE 120,10
    @ 050,070 GET xMens3 PICTURE "@!" SIZE 120,10
	@ 070,118 BMPBUTTON TYPE 1 ACTION GravaMens()
	@ 070,150 BMPBUTTON TYPE 2 ACTION Close(oDlg)
	ACTIVATE DIALOG oDlg CENTERED                

Endif
Return


Static Function GravaMens()

	RecLock("SF1",.f.)
	sf1->f1_mens1 := xMens1
	sf1->f1_mens2 := xMens2
	sf1->f1_mens3 := xMens3
	MsUnlock("SF1")
	
	Close(oDlg)
	
	Return
