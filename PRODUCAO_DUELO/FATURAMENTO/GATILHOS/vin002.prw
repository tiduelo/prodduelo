#INCLUDE "rwmake.ch"

User Function vin002

/*/SIGAVILLE
_____________________________________________________________________________

�������������������������������������������������������������������������Ŀ��
���Cliente      � VINHOS DUELO                                            ���
�������������������������������������������������������������������������Ĵ��
���Programa     � VIN002.PRW       � Responsavel � Bernardo Kuhlhoff      ���
�������������������������������������������������������������������������Ĵ��
���Descri��o    � GATILHO DEFINICAO DE CONTAS CONTABEIS FATURAMENTO       ���
�������������������������������������������������������������������������Ĵ��
��� Data        � 27/09/01         � Implantacao � 27/09/01               ���
�������������������������������������������������������������������������Ĵ��
��� Programador �                                                         ���
�������������������������������������������������������������������������Ĵ��
��� Objetivos   � ExecBlock acionado no lancamento padrao 620/01          ���
���             �                                                         ���
�������������������������������������������������������������������������Ĵ��
��� Arquivos    �                                                         ���
���             �                                                         ���
�������������������������������������������������������������������������Ĵ��
��� Indices     �                                                         ���
�������������������������������������������������������������������������Ĵ��
��� Parametros  �                                                         ���
�������������������������������������������������������������������������Ĵ��
��� Observacoes �                                                         ���
�������������������������������������������������������������������������Ĵ��
��� Cuidados na � Nenhuma                                                 ���
��� Atualizacao �                                                         ���
��� de versao   �                                                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
//Claudio - Inclus�o 17/10/06
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
