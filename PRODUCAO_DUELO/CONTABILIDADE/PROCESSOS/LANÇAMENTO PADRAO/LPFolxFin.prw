#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FolxFin� Autor � AP6 IDE            � Data �  27/02/17   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FolxFin(_cSE2Prx, _cSE2Num, _cSE2Tip, _cSE2Nat, _cSE2Forn, _cSECLoj, _cSE2Fil)

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local _cNumTit := _cSE2Num
Local _cPrxTit := _cSE2Prx
Local _cTipTit := _cSE2Tip
Local _cNatTit := _cSE2Nat
Local _cFrcTit := _cSE2Forn
Local _cLjFTit := _cSECLoj
Local _cFiltit := _cSE2Fil
Local _cCodTit := ""
Local _cCtaCtb := "0000000"
Local _cCtbRC0 := ""
local _aCodRC0 := {}

										   //RC1_FILIAL,   RC1_FILTIT, RC1_PREFIX, RC1_NUMTIT, RC1_TIPO, RC1_FORNEC
_cCodTit := GetAdvFVal("RC1", "RC1_CODTIT",xFilial("RC1") + _cFiltit + _cPrxTit + _cNumTit + _cTipTit + _cFrcTit,2) 

If !Empty(_cCodTit)
	_cCtaCtb := GetAdvFVal("RC0", "RC0_CTACTB",xFilial("RC0") + _cCodTit + "01",1,"0000000") //RC0_FILIAL,    RC0_CODTIT, RC0_SEQUEN                                            
EndIf                                          

Return(_cCtaCtb)