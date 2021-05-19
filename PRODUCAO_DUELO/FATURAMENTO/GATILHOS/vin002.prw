#INCLUDE "rwmake.ch"

User Function vin002

/*/SIGAVILLE
_____________________________________________________________________________

±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Cliente      ³ VINHOS DUELO                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programa     ³ VIN002.PRW       ³ Responsavel ³ Bernardo Kuhlhoff      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o    ³ GATILHO DEFINICAO DE CONTAS CONTABEIS FATURAMENTO       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Data        ³ 27/09/01         ³ Implantacao ³ 27/09/01               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Programador ³                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Objetivos   ³ ExecBlock acionado no lancamento padrao 620/01          ³±±
±±³             ³                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Arquivos    ³                                                         ³±±
±±³             ³                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Indices     ³                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Parametros  ³                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Observacoes ³                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Cuidados na ³ Nenhuma                                                 ³±±
±±³ Atualizacao ³                                                         ³±±
±±³ de versao   ³                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


cconta := "         "
if SM0->M0_CODIGO == "04"
    if sf4->f4_cf == '5102'
         cconta := "3420201"
    endif
    /*CFOP DE VENDA ANTECIPADA - CONTA VENDA ANTECIPADA DUELO*/
    if substr(sf4->f4_cf,2,3) == '116'
         cconta := "341010101"
    endif     
if SM0->M0_CODIGO == "04" .or.  SM0->M0_CODIGO == "05"
        if substr(sf4->f4_cf,2,3)=="101"
            cconta := "3"+SUBSTR(SM0->M0_CODIGO,2,1)+"1010101"
        endif
        
        if substr(sf4->f4_cf,2,3)=="401"
            cconta := "3"+SUBSTR(SM0->M0_CODIGO,2,1)+"1010101"
        endif
        if substr(sf4->f4_cf,2,3)=="102"
            cconta := "3"+SUBSTR(SM0->M0_CODIGO,2,1)+"1010102"
        endif
//Inicio
//Claudio - Inclusão 17/10/06
        If substr(sf4->f4_cf,2,3)=="405"     
            cconta := "3"+SUBSTR(SM0->M0_CODIGO,2,1)+"1010102"
        endif  
//Fim
        if substr(sf4->f4_cf,2,3)=="201"
            cconta := "4"+SUBSTR(SM0->M0_CODIGO,2,1)+"1020302" 
        endif
        if substr(sf4->f4_cf,2,3)=="901"
            cconta := "3"+SUBSTR(SM0->M0_CODIGO,2,1)+"20102" 
        endif
        if substr(sf4->f4_cf,2,3)=="902"
            cconta := "4"+SUBSTR(SM0->M0_CODIGO,2,1)+"1020302" 
        endif
        if substr(sf4->f4_cf,2,3)=="109"
//    cconta := "3"+SUBSTR(SM0->M0_CODIGO,2,1)+"1010101"
            cconta := "341010101"
        endif
    elseif SM0->M0_CODIGO == "06"
        cconta := "311010102"
endif
endif
return(cconta)
