#INCLUDE "rwmake.ch"
User Function OS010REJ()
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Ponto de entrada para gravar corretamente o reajuste da tabela de precos �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸    

//ALERT("PE: OS010REJ")

nFtAplic  := mv_par09                                                      
nDecimais := mv_par10                                                      
nBase     := DA1->DA1_PRCFIN

if RecLock("DA1")  

	DA1->DA1_PRCFIN := If(nFtAplic > 0, NoRound(nBase * nFtAplic,nDecimais), nBase )
	DA1->DA1_PRCVEN := u_gdg001(DA1->DA1_CODPRO,DA1->DA1_PRCFIN)
	
	MsUnLock()

ENDIF


Return
