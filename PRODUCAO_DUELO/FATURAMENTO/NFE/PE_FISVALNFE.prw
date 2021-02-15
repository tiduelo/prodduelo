#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �FISVALNFE� Autor� Rafael Almeida-SIGACORP � Data �13.04.2017���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Este ponto de entrada foi disponibilizado a fim de permitir ���
���          �a valida��o da transmiss�o  das NF pela rotina SPEDNFE.     ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Verdadeiro .T. ou Falso .F.                                 ���
�������������������������������������������������������������������������Ĵ��
���Objetivo  � Bloquear NF a ser transmitida p/SEFAZ sem MONTAGEM DE CARGA���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FISVALNFE()

Local lTran		:=.T.
Local cTipo		:=PARAMIXB[1]
Local cFil		:=PARAMIXB[2]
Local cEmissao	:=PARAMIXB[3]
Local cNota		:=PARAMIXB[4]
Local cSerie	:=PARAMIXB[5]
Local cClieFor	:=PARAMIXB[6]
Local cLoja		:=PARAMIXB[7]
Local cEspec	:=PARAMIXB[8]
Local cFormul	:=PARAMIXB[9]


If cTipo=="S"
	dbSelectArea("SF2")
	dbSetOrder(2)
	dbseek(cFil+cClieFor+cLoja+cNota+cSerie)
	
	While !EOF() .AND. SF2->F2_FILIAL+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_DOC+SF2->F2_SERIE == cFil+cClieFor+cLoja+cNota+cSerie
		If Empty(SF2->F2_CARGA)
			lTran :=.F.
			MSGALERT( "A Nota Fiscal: "+cNota+"/"+cSerie+" - N�O poder� ser transmitida sem montagem de carga.", "Bloqueio de transmiss�o NFe" )
			Exit
		EndIf
		dbSkip()
	End
EndIf
Return(lTran)
