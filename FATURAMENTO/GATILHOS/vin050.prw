#include "Protheus.ch"
#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/00
/*SIGAVILLE
_____________________________________________________________________________

�������������������������������������������������������������������������Ŀ��
���Cliente      � VINHOS DUELO                                            ���
�������������������������������������������������������������������������Ĵ��
���Programa     � VIN050.PRW       � Responsavel �                        ���
�������������������������������������������������������������������������Ĵ��
���Descri��o    � GATILHO CALCULA CODIGO PRODUTO - SB1                    ���
�������������������������������������������������������������������������Ĵ��
��� Data        � 26/06/00         � Implantacao �   /  /                 ���
�������������������������������������������������������������������������Ĵ��
��� Programador �                                                         ���
�������������������������������������������������������������������������Ĵ��
��� Objetivos   � ExecBlock acionado no campo B1_SUBLINH para calculo do  ���
���             � Codigo de produto                                       ���
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
*/

user function VIN050

Local ncod   := 0
Local nvez   := 0
Local nPro   := " "
Local cQry := " "
Local cchave := m->b1_grupo //m->b1_linha+m->b1_sublinh

/*
nOrder := sb1->(dbsetorder())
nRecNo := sb1->(Recno())
sb1->(dbsetorder(1))
sb1->(dbseek(xFilial("SB1")+cchave,.t.)) //sb1->(dbseek(xFilial("SB1")+m->b1_linha+m->b1_sublinh,.t.))
while !sb1->(eof()) .and. xFilial("SB1") == sb1->b1_filial .and. Substr(sb1->b1_cod,1,4) == cchave
        
        nCod := val(substr(sb1->b1_cod,5,5))

        sb1->(dbskip())
End  
m->b1_cod := cchave+strzero(ncod+1,5)
sb1->(dbsetorder(nOrder))
sb1->(dbgoto(nRecno))
*/
cQry := " "
cQry += "	SELECT 	"
cQry += " 		TOP 1 B1_COD+1 AS B1_COD "  
cQry += " 		,SUBSTRING(B1_COD,5,4)  AS TAM_COD	"
cQry += " 	FROM "+ RETSQLNAME("SB1")+" "
cQry += " 	WHERE D_E_L_E_T_ = ''	"
cQry += " 		AND SUBSTRING(B1_COD,1,4) = '"+ ALLTRIM(cchave) + "' "
cQry += " 		AND B1_FILIAL = '"+xFilial("SB1")  +"' "
cQry += "	ORDER BY R_E_C_N_O_ DESC	"
cQry := ChangeQuery(cQry)
dbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQry) , "TB1" , .T. , .F.)

DBSelectArea("TB1")
TB1->(DbGoTop())
While !TB1->(Eof())
		If Val(TB1->TAM_COD) <= 999
			m->b1_cod := STRZERO(TB1->B1_COD,7)		
		Else
			m->b1_cod := STRZERO(TB1->B1_COD,8)		
		EndIf
	TB1->(DbSkip())
EndDo
TB1->( DBCloseArea())

return(m->b1_cod)
