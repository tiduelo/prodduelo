#include "rwmake.ch"
#include "colors.ch"
#include "Protheus.ch"                     
User Function MT410BRW()
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT410BRW  �Autor  �CLAUDENILSON        � Data �  01/08/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ativa filtro para pedidos SAIB                             ���
���          � com o TES                                                  ���
�������������������������������������������������������������������������͹��
���Uso       � Vinho Duelo                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

SetKey( VK_F5, {|| U_FILSAIB()})		// MsgAlert("M410ALOK - Acionou a tecla F5!" ),

Return(.T.)

////////////////////////////////
USER FUNCTION FILSAIB()
////////////////////////////////
_cfilter := dbfilter()

DBSELECTAREA('SC5')

if empty(_cfilter)
	set filter to C5_PEDSAIB <> SPACE(10)    
	Alert("Somente pedidos SAIB")
Else
	Alert("Todos os Pedidos")
	set filter to
Endif

dbgotop()

_odefwnd := GetWndDefault()
//_odefwnd:gotop()
_odefwnd:refresh()

return nil

