#INCLUDE "PROTHEUS.CH"
#Define ENTER  Chr(10) + Chr (13) // SALTO DE LINHA (CARRIAGE RETURN + LINE FEED)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ImpMt140   Autor ³     Rafael Cruz     ³ Data ³ 13/11/2020 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida permissão do usuario p/ selecionar a Especie SPED   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga  - Duelo                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Obs       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function VldEspMT103(cFormul,cEspecie)
	Local _lRet      := .T.
	Local _cUsrLogin := RetCodUsr()
	Local _cUsrAdm   := SUPERGETMV("US_ADMT103",.F.,"/000000/")
    Local _cMsgInfo  := ""
  

	If Upper(GetEnvServer()) == "DESENV"
        If Upper(FunName()) == "MATA103"
            _cMsgInfo := "Seu perfil não tem permissão para incluir a Nota Fiscal como SPED"+ENTER+ENTER
            _cMsgInfo += "SOLUÇÃO:"+ENTER
            _cMsgInfo += "- Realizar a Entrada da NF atraves da Rotina de Importação do XML"+ENTER
            _cMsgInfo += "ou"+ENTER
            _cMsgInfo += "- Seu usuario deverá ter permissão no parametro US_ADMT103"

		    If Empty(cFormul)  .And. Empty(cEspecie)
                _lRet      := .T.
            If cFormul == "S" .And. "SPED"$cEspecie
                If !(_cUsrLogin $ _cUsrAdm)
                    _lRet := .F.
                    MsgAlert(_cMsgInfo,"SEM PERMISSÃO")
                EndIf
		    EndIf
	    EndIf
    EndIf

Return(_lRet)
