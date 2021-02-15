#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa � CALCVOL Autor � RONALDO MAIA 			 � Data � 13/05/2016 ���
�������������������������������������������������������������������������Ĵ��
���Objetivo � Funcao responsavel pelo preenchimento do campo volume ��
do Pedido de Vendas
�������������������������������������������������������������������������Ĵ��
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function CalcVol(nValor)
Local nVol := 0
Local _nItem := 0 

nPosItem := ASCAN(aHeader, {|aVal| Alltrim(aVal[2]) == "C6_ITEM"})
nPosProd := ASCAN(aHeader, {|aVal| Alltrim(aVal[2]) == "C6_PRODUTO"})
nPosQtde := ASCAN(aHeader, {|aVal| Alltrim(aVal[2]) == "C6_QTDVEN"})

For _nItem := 1 to Len(aCols)
If ! aCols[_nItem,Len(aHeader)+1]
nVol += aCols[_nItem,nPosQtde]
EndIf
Next

M->C5_VOLUME1 := nVol
GetDRefresh()
Return nValor