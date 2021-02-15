#INCLUDE "PROTHEUS.CH"
#Define ENTER  Chr(10) + Chr (13) // SALTO DE LINHA (CARRIAGE RETURN + LINE FEED)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � ImpMt140   Autor �     Rafael Cruz     � Data � 13/11/2020 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Valida permiss�o do usuario p/ selecionar a Especie SPED   ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Clientes Microsiga  - Duelo                ���
�������������������������������������������������������������������������Ĵ��
���Obs       �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function VldEspMT103(cFormul,cEspecie)
	Local _lRet      := .T.
	Local _cUsrLogin := RetCodUsr()
	Local _cUsrAdm   := SUPERGETMV("US_ADMT103",.F.,"/000000/")
    Local _cMsgInfo  := ""
  

	If Upper(GetEnvServer()) == "DESENV"
        If Upper(FunName()) == "MATA103"
            _cMsgInfo := "Seu perfil n�o tem permiss�o para incluir a Nota Fiscal como SPED"+ENTER+ENTER
            _cMsgInfo += "SOLU��O:"+ENTER
            _cMsgInfo += "- Realizar a Entrada da NF atraves da Rotina de Importa��o do XML"+ENTER
            _cMsgInfo += "ou"+ENTER
            _cMsgInfo += "- Seu usuario dever� ter permiss�o no parametro US_ADMT103"

		    If Empty(cFormul)  .And. Empty(cEspecie)
                _lRet      := .T.
            If cFormul == "S" .And. "SPED"$cEspecie
                If !(_cUsrLogin $ _cUsrAdm)
                    _lRet := .F.
                    MsgAlert(_cMsgInfo,"SEM PERMISS�O")
                EndIf
		    EndIf
	    EndIf
    EndIf

Return(_lRet)
