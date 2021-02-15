#INCLUDE "RWMAKE.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA260D3 �Autor  Rafael Almeida - SIGACORP� Data �10/11/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Pode ser utilizado para atualizar algum arquivo ou campo   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � ESTOQUE / CUSTOS                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MA260D3()

Local LcNoAlco 	  := GetNewPar("US_ARNALC","02") //ARMAZEM N�O ALCOOLICO  PADRAO
Local LcYsAlco 	  := GetNewPar("US_ARSALC","01") //ARMAZEM ALCOOLICO PADRAO
Local LcNoAlcoFab := GetNewPar("US_ARNALCP","12")//ARMAZEM N�O ALCOOLICO CHAO DE FABRICA
Local LcYsAlcoFab := GetNewPar("US_ARSALCP","11")//ARMAZEM ALCOOLICO CHAO DE FABRICA
Local _lActivRot  := GetNewPar("US_A261TOK",.T.) // ATIVA E DESATIVA ROTINA DE TRANSFERENCIA
Local _cDocument := SD3->D3_DOC
Local _cProduto  := SD3->D3_COD

If _lActivRot
	If (((cLocOrig $ LcYsAlco .AND. cLocDest $ LcYsAlcoFab)   .Or. (cLocOrig $ LcNoAlco .AND. cLocDest $ LcNoAlcoFab)) .Or. ;
		((cLocOrig $ LcYsAlcoFab .AND. cLocDest $ LcYsAlco)   .or. (cLocOrig $ LcNoAlcoFab .AND. cLocDest $ LcNoAlco)))
		SD3->( dbSetOrder( 2 ))
		If SD3->(MsSeek(xFilial("SD3") + _cDocument + _cProduto)) .And. Empty(SD3->D3_PROJPMS)
			While !SD3->(Eof()) .and. xFilial("SD3") == SD3->D3_FILIAL .AND. SD3->D3_DOC == _cDocument .AND. SD3->D3_COD == _cProduto
				RecLock("SD3",.F.)
			  		SD3->D3_PROJPMS :=  "TRANS_PROD"
				MsUnLock()
				SD3->(dbskip())
			EnddO
		EndIf
	EndIf
EndIf

Return()
