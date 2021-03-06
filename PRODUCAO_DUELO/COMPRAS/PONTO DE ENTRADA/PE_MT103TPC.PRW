#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  MT103TPC � Autor � RAFAEL ALMEIDA - SIGACORP � Data �05/05/16���
�������������������������������������������������������������������������͹��
���Descricao � Possibilita a altera��o do par�metro MV_TESPCNF            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MATA030 - Cadatro de Cliente                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MT103TPC()

	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������
	Local _cRelTES      := PARAMIXB[1]
	Local _cQryTES      := ""
    

	//���������������������������������������������������������������������Ŀ
	//� Iniciando o Processamento - Valida��o                               �
	//� Se o cliente for pessoa Juridica � obrigado informar a Inscri��o    �
	//� estadual.                                                           �
	//�����������������������������������������������������������������������

	if select("TMPSF4") > 0
		dbSelectArea("TMPSF4")
		TMPSF4->(dbclosearea())
	Endif

	_cQry :=" "
	_cQry +=" SELECT F4_CODIGO "
	_cQry +="  FROM "+RetSqlName("SF4")+ " "
	_cQry +=" WHERE D_E_L_E_T_ =  ''	"
	_cQry +=" AND F4_TESPCNF = 'N' "	 
	_cQry +=" AND F4_FILIAL = '"+ xFilial("SF4") +"'	"
	_cQry := ChangeQuery(_cQry)
	DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQry), "TMPSF4", .T., .T.)


	DbSelectArea("TMPSF4")
	TMPSF4->(DbGoTop())

	Do While !TMPSF4->(Eof())
		_cQryTES += "'" + TMPSF4->F4_CODIGO +"'," 
		TMPSF4->(dbSkip())
	Enddo
	TMPSF4->(DBCLOSEAREA())


If !( Alltrim(_cQryTES) $ Alltrim(_cRelTES) )
	_cRelTES := _cQryTES
EndIf

Return _cRelTES 