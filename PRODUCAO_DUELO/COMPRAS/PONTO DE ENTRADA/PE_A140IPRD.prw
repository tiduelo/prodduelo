#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch" 

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  A140IPRD �     Autor � Rafael Cruz         � Data �25.11.2020���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Rdmake de exemplo para impress�o da DANFE no formato Retrato���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Retorna o c�digo do produto da tabela SB1                   ���
�������������������������������������������������������������������������Ĵ��
���Parametros� cCodigo  -> C -> C�digo do fornecedor/cliente.             ���
���            cLoja    -> A -> C�digo da loja do fornecedor/cliente.     ���
���            cPrdXML  -> A -> C�digo do produto contido no arquivo xml. ���
���            oDetItem -> A -> Objeto contendo a Tag principal: InfNFE   ���
���            /subtag det nItem com os n�s referente ao item posicionado ���
���            no XML recebido de acordo com o Manual de Orienta��o ao    ���
���            Contribuinte da NFe.                                       ���
���          � cAlias   -> A -> C�digo da tabela "SA5" ou "SA7" para      ���
���            identificar se o c�digo que est� vindo como par�metro �    ���
���            de um fornecedor ou de um cliente para os casos de notas   ���
���            do tipo devolu��o e beneficiamento.                        ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function A140IPRD()
Local cFornec     := PARAMIXB[1]
Local cLoja       := PARAMIXB[2]
Local cNewPRD     := PARAMIXB[3]
Local oDetItem    := PARAMIXB[4]
 Local _cProdCad   := "99999"
 Local _nTamCamp := TAMSX3("B1_COD")[1]

cNewPRD := "MANIPULADO PELO USU�RIO"

dbSelectArea("SB1")
bSetOrder(1)
    If MsSeek(xFilial("SB1")+Padr(_cProdCad,_nTamCamp))
		RecLock("SB1",.F.)
		If !SB1->B1_COD==Padr(_cProdCad,_nTamCamp)
            dbDelete()
		EndIf
		MsUnlock()
	EndIf

Alert("oi")

cNewPRD := _cProdCad

Return cNewPRD
