#Include "RwMake.Ch"
User Function M410SOLI()
	/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ³M460SOLI  ºAutor  ³Lucio Graim-Belém   º Data ³  25/02/02   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDesc.     ³ Modificará o valor da substituição Tributária de acordo    º±±
	±±º          ³ com o TES                                                  º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ Vinho Duelo                                                º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

	SetPrvt("_xProduto, _aIcmRet, _nSB1Ord, _nSB1Reg, _nAliqIpi, _nB1margem, _nSF7Ord")
	SetPrvt("_nSF7Reg, _nAliqIcm, _nAliqExt, _nSF4Ord, _nSF4Reg, _cIncide, _nRedSub")
	SetPrvt("_nPrcVen, _nQtdLib, _nValMerc, _nValTot, _nValIcm, _nBaseRet, _nValRet, _nValSubs")
	SetPrvt("_cAlias, _nSA1Ord, NSA1Reg, _cSb1Grup")

	_cAlias := Alias()

	_nPOSPRO := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
	_nPOSTES := aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})
	_nPOSPRC := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})
	_nPOSVAL := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})
	_nPOSQTD := aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})

	_n := paramixb[1]

	_PRODUTO := acols[_n][_nPOSPRO]
	_TES     := acols[_n][_nPOSTES]
	_PRCVEN  := acols[_n][_nPOSPRC]
	_VALOR   := acols[_n][_nPOSVAL]
	_QTDEMP  := acols[_n][_nPOSQTD]


	_xProduto   := _PRODUTO
	_aIcmRet    := {}
	_lVlrIpi    := .F.
	_nAliqIpi   :=  0
	_nIpi       :=  0
	_nB1margem  :=  0
	_nBaseRet 	:=  0
	_cEst       := "PA" // estado destino do produto
	_cSeqExc    := "" // sequencia na tabela de excessao fiscal
	_nAliqIcm   := GETMV("MV_ICMPAD") // Retorna o Icm Padrão
	_nAliqExt   := 12
	_cSb1Grup	:= Alltrim(Posicione("SB1",1,xFilial("SB1")+_xProduto,"B1_GRUPO"))
	_nPDc1583   := Posicione("SB1",1,xFilial("SB1")+_xProduto,"B1_DC1583") //Rafael Almeida - SIGACORP (29/03/2016) atender o Decreto Nº 1583
	_nPautST    := Posicione("SB1",1,xFilial("SB1")+_xProduto,"B1_PAUTST") //Rafael Almeida - SIGACORP (23/11/2016) Nova Pauta para refrigerante
	_lDc1583    := GETMV("US_DEC1583")  //Rafael Almeida - SIGACORP (29/03/2016) atender o Decreto Nº 1583
	_cEmpFil    := GETMV("US_EMPFIL1")  //Rafael Almeida - SIGACORP (29/03/2016) atender o Decreto Nº 1583
	_cEmpPautST := GETMV("US_EMPPTST")  //Rafael Almeida - SIGACORP (23/11/2016) Referente a empresa que se enquadrada na Pauta ST para refrigerantes.
	_lSB1PautST := GETMV("US_SB1PTST")  //Rafael Almeida - SIGACORP (23/11/2016) Referente a empresa que se enquadrada na Pauta ST para refrigerantes ativa ou desativa a rotina.


	//If SC6->C6_TES $ "522|523|526" // Forca saida do ponto quando TES de cupom fiscal
	//	Alert("Desviou")
	//	Return(nil)
	//EndIf

	dbSelectArea("SA1")
	_nSA1Ord := IndexOrd()
	_nSA1Reg := RecNo()
	dbSetOrder(1)


	IF dbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI)
		_cEst := upper(alltrim(SA1->A1_EST))
	EndIf

	IF M->C5_TIPOCLI == "S" .and. _cEst $ "PA/AP"       //Testa se o cliente é do estado do Para ou Amapa

		/*If _cSb1Grup $ '0203' // Energeticos

			If _cEst == 'PA'
				_cSeqExc := "001"
			ElseIf _cEst == "AP"
				_cSeqExc := "002"
			Endif

		Else*/
		If _cSb1Grup $ '0204|0206'   

			If _cEst == 'PA'
				_cSeqExc := "001" // "003" AJUSTADO RAFAEL CRUZ 18/06/2021
			ElseIf _cEst == "AP"
				_cSeqExc := "002" // "004"  AJUSTADO RAFAEL CRUZ 18/06/2021
			Endif

		ElseIf  _cSb1Grup $ '0203|0205'   

			If _cEst == 'PA'
				_cSeqExc := "001"
			ElseIf _cEst == "AP"
				_cSeqExc := "002"
			Endif

		Else

			if _cEst == "PA"
				_cSeqExc := "022"
			ElseIf _cEst == "AP"
				_cSeqExc := "025"
			Endif

		Endif

		dbSelectArea("SB1")                             // Solidário
		_nSB1Ord := IndexOrd()
		_nSB1Reg := RecNo()

		dbSetOrder(1)

		IF dbSeek(xFilial("SB1")+_xProduto) // Procura pelo produto

			//alert(_xProduto)

			If SB1->B1_VLRIPI > 0   //B1_VLR_IPI
				_nIpi    := SB1->B1_VLRIPI
				_lVlrIpi := .T.
			Else
				_nIpi    := Round(SB1->B1_IPI/100,2)
			EndIf

			_nAliqIpi  :=  SB1->B1_IPI
			_nB1margem :=  SB1->B1_PICMRET

			dbSelectArea("SF7")
			_nSF7Ord := IndexOrd()
			_nSF7Reg := RecNo()

			dbSetOrder(1)

			_cGrpCli := space(3) // chave da pesquisa da excessao fiscal

			// Busca no arquivo de excssao fiscal

			IF !Empty(SB1->B1_GRTRIB) .And. dbSeek(xFilial("SF7")+PADR(SB1->B1_GRTRIB,6)+_cGrpCli+_cSeqExc)

				_nAliqIcm  := SF7->F7_ALIQINT        // tações aquele ao qual o produto
				_nAliqExt  := SF7->F7_ALIQEXT        // se enquadra e retorna valor do ICM
				_nB1margem := iif(SF7->F7_MARGEM > 0 , SF7->F7_MARGEM, _nB1margem )

			ENDIF        


			dbSetOrder(_nSF7Ord)
			dbGoTo(_nSF7Reg)

		EndIf                        

		//alert(_nAliqIcm )

		_lCalcRet :=  (_nB1margem > 0)

		dbSelectArea("SB1")
		dbSetOrder(_nSB1Ord)
		dbGoTo(_nSB1Reg)

		dbSelectArea("SF4")
		_nSF4Ord := IndexOrd()
		_nSF4Reg := RecNo()
		dbSetOrder(1)

		_cIncide := ""
		_nRedSub := 0

		IF dbSeek(xFilial("SF4")+_TES)  // Verifica se o TES possui incidência
			_cIncide := SF4->F4_INCIDE         // de IPI na base do ICM e se existe re
			_nRedSub := SF4->F4_REDSUB         // ducao do substituto tributário
		ENDIF


		//Modificado por Dias 28.03.2012 Verificar se a Tes Calcula IPI
		If SF4->F4_IPI = 'N'
			_lVlrIpi  := .F.
			_nIpi     := 0.00
			_nAliqIpi := 0.00
		Endif

		dbSetOrder(_nSF4Ord)
		dbGoTo(_nSF4Reg)

		// se existir ipi de pauta calcula pelo valor senao utiliza o percentual do IPI

		If _lVlrIpi
			xIpi    := ROUND(_QTDEMP * _nIpi,2)
		Else
			xIpi    := ROUND(_VALOR  * _nIpi,2)
		EndIf

		_nPrcVen := _PRCVEN
		_nQtdLib := _QTDEMP

		_nValMerc:= Round(_PRCVEN * _QTDEMP , 2)

		_nValTot := _nValMerc + (Round(IF(_cIncide == "S", xIpi, 0) , 2))


		if _cEst == "PA"
			_nValIcm := Round(_nValTot * _nAliqIcm / 100, 2)
		Else
			_nValIcm := Round(_nValTot * _nAliqExt / 100, 2)
		Endif

		if _cEst == "PA"
			_nBaseRet:= _nValMerc + (Round(xIpi, 2))
		else	
			if _cEst == "AP" .And. _cSb1Grup $ '0202'
				_nBaseRet:= _nValMerc + (Round(xIpi, 2))
			endif
			if _cEst == "AP" .And. _cSb1Grup $ '0204|0205'
				_nBaseRet:= _nValMerc + (Round(xIpi, 2))-(_nValMerc * _nAliqExt/100)
			endif
		Endif



		_nBaseRet+= Round(_nBaseRet * _nB1margem / 100, 2)

		_nValRet := Round(_nBaseRet * _nAliqIcm / 100, 2) // observar o % ICMS do destino


		/*	
		|=========================================================|
		|Autor: Rafael Almeida - SIGACORP  						  |
		|Data: 23/11/2016										  |
		|Descrição: Ira usar nova base de calculo conforme o      |
		|           novo decreto para refrigerante                |
		|Usado: Durate o pedido de venda.						  |
		|=========================================================|
		*/
		if _cEst == "PA"
			if !Empty(_cEmpPautST) .And. cNumEmp$Alltrim(_cEmpPautST)	
				if (_lSB1PautST  .And. _nPautST > 0	.And. _cSb1Grup $ '0204') .or. Alltrim(SB1->B1_GRTRIB) $ '004'
					_nBaseRet:= Round(_nPautST * _QTDEMP,2)
					//_nValRet := Round(_nPautST * _nAliqIcm / 100, 2) 
					_nValRet := Round(_QTDEMP*(_nPautST * _nAliqIcm / 100), 2)					
				EndIf
			EndIf
		EndIf	
		// FIM - Rafael Almeida - SIGACORP ()	


		if _cEst == "PA"

			if dDatabase > ctod("31/12/2013")
				_nRedSub := _nAliqIcm
				_nCrePre := Round( _nValMerc  * _nRedSub / 100, 2)
			Else
				_nCrePre := Round((_nValTot + IF(_cIncide # "S", xIpi, 0)) * _nRedSub / 100, 2)
			Endif

		Else

			_nCrePre := Round(_nValIcm, 2)

		Endif

		If _cSb1Grup $ '0204|0205|0206'
			_nCrePre := Round(_nValIcm, 2)
		Endif

		/*	
		|=========================================================|
		|Autor: Rafael Almeida - SIGACORP  						  |
		|Data: 29/07/2016										  |
		|Descrição: Ira usar nova base de calculo conforme o      |
		|           decreto Nº 1583                               |
		|Usado: Durate o pedido de venda.						  |
		|=========================================================|
		*/

		if _cEst == "PA"
			if !Empty(_cEmpFil) .And. cNumEmp$Alltrim(_cEmpFil)
				if _lDc1583  .And. _nPDc1583 > 0
					_nCrePre := Round(((_nValMerc + (Round(xIpi, 2)))* _nPDc1583) / 100 , 2)
				EndIf
			EndIf
		EndIf	
		// FIM - Rafael Almeida - SIGACORP (DECRETO Nº 1583)


		_nValSubs:= _nValRet - _nCrePre

		If _nValSubs < 0
			//alert("Problema no calculo da susbtituicao tributaria. Comunicar TI (M410SOLI).")
			_nBaseRet := 0
			_nValSubs := 0
		Endif

		//ALERT("Valor ret: "+str(_nValRet,10,2))
		//ALERT("Cred Pres: "+str(_nCrePre,10,2))

		//ALERT("Base subst: "+str(_nBaseRet,10,2))
		//ALERT("Valor subst: "+str(_nValSubs,10,2))

		//IF _nRedSub = 0 // Recalcula o valor do substituto tributário
		//_nValSubs := _nValSubs - _nValIcm
		//EndIf

		If _lCalcRet
			_aIcmRet := {_nBaseRet, _nValSubs}
		Else
			_lCalcRet := {0,0}
		EndIf

		//      _aIcmRet := {_nBaseRet, _nValSubs}

	EndIf

Return(_aIcmRet)
