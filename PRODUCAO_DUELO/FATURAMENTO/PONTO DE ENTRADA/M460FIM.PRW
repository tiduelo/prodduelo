#INCLUDE "rwmake.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MSD2460   º Autor ³ GEOVANI            º Data ³  26/04/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ PONTO DE ENTRADA PARA ATUALIZAR C. CUSTO NO FATURAMENTO    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ DUELO                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function M460FIM()
Local _i := 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// ALERT("PE M460FIM")

if AllTrim(FWCodEmp()) == "04"//SM0->M0_codigo == "04"
	
	_aarea := GETAREA()
	
	_aIpi 		:= {}
	_aPis 		:= {}
	_aCofins 	:= {}
	
	xBaseIpi 	:= 0
	xBasePis 	:= 0
	xBaseCof 	:= 0
	
	xValorIpi 	:= 0
	xValorPis 	:= 0
	xValorCof 	:= 0
	
	_lAtualCab	:= .f.
	
	SD2->(DBSETORDER(3))
	SD2->(DBSEEK( SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA) , .F.) )
	
	Do while ! ( SD2->(EOF()) )  .AND. SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA) == SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)
		
		SB1->(DBSETORDER(1))
		SB1->(DBSEEK(SD2->D2_FILIAL+SD2->D2_COD))
		
		SF4->(DBSETORDER(1))
		SF4->(DBSEEK(SD2->D2_FILIAL+SD2->D2_TES))
		
		// IPI DE PAUTA
		
		_lPauta := .f.
		
		IF ALLTRIM( SF4->F4_IPI ) == "S"
			
			_lAtualCab	:= .t.
			
			// Ipi baseado em aliquota
			
			_nIpiAlqBs := SD2->D2_TOTAL // Base do Ipi em Aliquota
			
			if SB1->B1_IPI2 > 0
				_nIpiAlq := SB1->B1_IPI2
			Else
				_nIpiAlq := SB1->B1_IPI
			Endif
			
			_nIpiAlqVl := round( _nIpiAlqBs * ( _nIpiAlq / 100 ) , 2  )
			
			// Ipi baseado em Pauta
			
			IF SB1->B1_VLRIPI > 0 // Existe a possibilidade de Pauta
				
				if ( SB1->B1_CONV == 0 )   .or. ( SB1->B1_QDTLIT == 0 )
					_nIpiPauBs := SD2->D2_QUANT
				Else
					_nIpiPauBs := SD2->D2_QUANT * SB1->B1_CONV * SB1->B1_QDTLIT
				Endif
				
				_nIpiPauta := SB1->B1_VLRIPI
				_nIpiPauVl := round( _nIpiBase * _nIpiPauta , 2  )
				
			Else
				
				_nIpiPauBs := 0
				_nIpiPauta := 0
				_nIpiPauVl := 0
				
			Endif
			
			if _nIpiPauVl > _nIpiAlqVl // Valor do ipi de pauta maior que o ipi de aliquota
				
				_lPauta := .t.
				
				_nIpiBase  := _nIpiPauBs
				_nIpiAliq  := 0
				_nIpiValor := _nIpiPauVl
				_nIpiPauta := SB1->B1_VLRIPI
				
			Else
				
				_lPauta := .f.
				
				_nIpiBase  := _nIpiAlqBs
				_nIpiAliq  := _nIpiAlq
				_nIpiValor := _nIpiAlqVl
				_nIpiPauta := 0
				
			Endif
			
			
			if RECLOCK( "SD2" , .F. )
				
				SD2->D2_BASEIPI	:=  _nIpiBase
				SD2->D2_IPI 	:=  _nIpiAliq
				SD2->D2_VALIPI 	:=  _nIpiValor
				
				MSUNLOCK()
				
				DBSELECTAREA("SFT")
				SFT->(DBSETORDER(1))
				
				IF SFT->(DBSEEK(XFILIAL("SFT") + "S" + SD2->D2_SERIE+SD2->D2_DOC+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_ITEM+'  '+SD2->D2_COD))
					
					RECLOCK("SFT",.F.)
					
					SFT->FT_BASEIPI := _nIpiBase
					SFT->FT_ALIQIPI := _nIpiAliq
					SFT->FT_VALIPI  := _nIpiValor
					
					SFT->FT_PAUTIPI := _nIpiPauta
					
					//SFT->FT_TNATREC := SD2->D2_TNATREC
					//SFT->FT_CNATREC := SD2->D2_CNATREC
					//SFT->FT_GRUPONC := SD2->D2_GRUPONC
					
					SFT->(MSUNLOCK())
					
				ENDIF
				
				CD2->(Dbgotop())
				
				IF CD2->( DbSeek(xFilial("CD2")+'S'+SD2->D2_SERIE+SD2->D2_DOC+SD2->D2_CLIENTE+SD2->D2_LOJA + padr( SD2->D2_ITEM, 4 )+SD2->D2_COD+'IPI', .f. ) )
					
					if RecLock("CD2",.F.)
						
						CD2->CD2_VLTRIB := SD2->D2_VALIPI
						
						if _lPauta
							CD2->CD2_BC     := 0
							CD2->CD2_QTRIB  := _nIpiBase
						Else
							CD2->CD2_BC     := _nIpiBase
							CD2->CD2_QTRIB  := 0
						Endif

						CD2->CD2_ALIQ   := _nIpiAliq
						CD2->CD2_PAUTA  := _nIpiPauta
						CD2->CD2_VLTRIB := _nIpiValor
						
						CD2->(MsUnLock())
						
					Endif
					
				ENDIF
				
			Endif
			
		Endif
		
		IF ( SF4->F4_CODIGO == SD2->D2_TES ) .AND. ALLTRIM(SF4->F4_PISCOF) == "3"
			
			IF ( SB1->B1_COD == SD2->D2_COD )
				
				// Tratamento da Lei 13.097/2015 (novas aliquotas de IPI,PIS e COFINS
				
				if SD2->D2_TIPO == "N" .and. ALLTRIM(SF4->F4_PISCRED) == "2" .and. alltrim(SA1->A1_SATIV1) == "000104"
					
					_lAtualCab	:= .t.
					_lPauta := .f.
					
					//
					// Calculo da Pauta
					//
					
					_nPisBasPa  := SD2->D2_QUANT * SB1->B1_CONV * SB1->B1_QDTLIT
					_nPisAlqPa 	:= SB1->B1_VLRPIS
					_nPisValPa  := _nPisBasPa * _nPisAlqPa
					
					_nCofBasPa  := SD2->D2_QUANT * SB1->B1_CONV * SB1->B1_QDTLIT
					_nCofAlqPa  := SB1->B1_VLRCOF
					_nCofValPa  := _nCofBasPa * _nCofAlqPa
					
					//
					// Calculo com base am aliquota
					//
					
					_nPisBase  := SD2->D2_TOTAL
					_nPisAlq   := SB1->B1_PPIS2
					_nPisVal   := round( _nPisBase * ( _nPisAlq/100) , 2 )
					
					_nCofBase  := SD2->D2_TOTAL
					_nCofAlq   := SB1->B1_PCOFIN2
					_nCofVal   := round( _nCofBase * ( _nCofAlq/100) , 2 )
					
					if RECLOCK("SD2",.F.)
						
						// PIS
						if SB1->B1_PPIS2 > 0
							
							if _nPisVal > _nPisValPa
								SD2->D2_BASIMP6 :=  _nPisBase
								SD2->D2_ALQIMP6 :=  _nPisAlq
								SD2->D2_VALIMP6 :=  _nPisVal
							Else
								SD2->D2_BASIMP6 :=  _nPisBasPa
								SD2->D2_ALQIMP6 :=  _nPisAlqPa
								SD2->D2_VALIMP6 :=  _nPisValPa
							
								_lPauta := .t.
							
							Endif
							
						Endif
						
						
						// COFINS
						
						if SB1->B1_PCOFIN2 > 0
							
							if _nCofVal > _nCofValPa
								
								SD2->D2_BASIMP5 :=  _nCofBase
								SD2->D2_ALQIMP5 :=  _nCofAlq
								SD2->D2_VALIMP5 :=  _nCofVal
								
							Else
								
								SD2->D2_BASIMP5 :=  _nCofBasPa
								SD2->D2_ALQIMP5 :=  _nCofAlqPa
								SD2->D2_VALIMP5 :=  _nCofValPa
							
								_lPauta := .t.
								
							Endif
							
						Endif
						
						SD2->(MSUNLOCK())
						
						CD2->(DbSetOrder(1))
						CD2->(Dbgotop())
						
						IF CD2->( DbSeek(xFilial("CD2")+'S'+SD2->D2_SERIE+SD2->D2_DOC+SD2->D2_CLIENTE+SD2->D2_LOJA + padr( SD2->D2_ITEM, 4 )+SD2->D2_COD+'PS2', .f. ) )
							
							if RecLock("CD2",.F.)
								
								if ! _lPauta
									
									CD2->CD2_BC     := SD2->D2_BASIMP6
									CD2->CD2_ALIQ   := SD2->D2_ALQIMP6
									CD2->CD2_VLTRIB := SD2->D2_VALIMP6
									
									CD2->CD2_QTRIB  := 0
									CD2->CD2_PAUTA  := 0
									
									//CD2->CD2_CST    := '01' // Verificar por aliquota se eh 01 ou 02
									
								Else
									
									CD2->CD2_BC     := 0
									CD2->CD2_ALIQ   := 0
									CD2->CD2_VLTRIB := SD2->D2_VALIMP6
									
									CD2->CD2_QTRIB  := SD2->D2_BASIMP6
									CD2->CD2_PAUTA  := SD2->D2_ALQIMP6
									
									CD2->CD2_CST    := '03' 
									
								Endif
								
								CD2->(MsUnLock())
								
							Endif
							
						ENDIF
						
						CD2->(Dbgotop())
						
						IF CD2->( DbSeek(xFilial("CD2")+'S'+SD2->D2_SERIE+SD2->D2_DOC+SD2->D2_CLIENTE+SD2->D2_LOJA + padr( SD2->D2_ITEM, 4 )+SD2->D2_COD+'CF2', .f. ) )
							
							if RecLock("CD2",.F.)
								
								if ! _lPauta
									
									CD2->CD2_BC     := SD2->D2_BASIMP5
									CD2->CD2_ALIQ   := SD2->D2_ALQIMP5
									CD2->CD2_VLTRIB := SD2->D2_VALIMP5
									CD2->CD2_QTRIB  := 0
									CD2->CD2_PAUTA  := 0
									
								Else
									
									CD2->CD2_BC     := 0
									CD2->CD2_ALIQ   := 0
									CD2->CD2_VLTRIB := SD2->D2_VALIMP5
									
									CD2->CD2_QTRIB  := SD2->D2_BASIMP5
									CD2->CD2_PAUTA  := SD2->D2_ALQIMP5

									CD2->CD2_CST    := '03' 
									
								Endif
							Endif
							
							CD2->(MsUnLock())
							
						ENDIF
						
						
						DBSELECTAREA("SFT")
						SFT->(DBSETORDER(1))
						
						IF SFT->(DBSEEK(XFILIAL("SFT") + "S" + SD2->D2_SERIE+SD2->D2_DOC+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_ITEM+'  '+SD2->D2_COD))
							
							RECLOCK("SFT",.F.)
							
							SFT->FT_BASEPIS := SD2->D2_BASIMP6
							SFT->FT_VALPIS  := SD2->D2_VALIMP6
							
							if ! _lPauta
								SFT->FT_ALIQPIS := SD2->D2_ALQIMP6
								SFT->FT_PAUTPIS := 0
							Else
								SFT->FT_ALIQPIS := 0
								SFT->FT_PAUTPIS := SD2->D2_ALQIMP6
								SFT->FT_CSTPIS  := '03'
							Endif
							
							SFT->FT_BASECOF := SD2->D2_BASIMP5
							SFT->FT_VALCOF  := SD2->D2_VALIMP5
							
							if ! _lPauta
								SFT->FT_ALIQCOF := SD2->D2_ALQIMP5
								SFT->FT_PAUTCOF := 0
							Else
								SFT->FT_ALIQCOF := 0
								SFT->FT_PAUTCOF := SD2->D2_ALQIMP5
								SFT->FT_CSTCOF  := '03'
							Endif
							
							
							//SFT->FT_TNATREC := SD2->D2_TNATREC
							//SFT->FT_CNATREC := SD2->D2_CNATREC
							//SFT->FT_GRUPONC := SD2->D2_GRUPONC
							
							SFT->(MSUNLOCK())
							
						ENDIF
					Endif
					
				Else
					
					//
					// Calculo do Pis e Cofins para fora do estado
					//
					
					IF LEFT( SD2->D2_CF , 1 ) == '6'
						
						_lAtualCab	:= .t.
						
						_nPisBase  := SD2->D2_TOTAL
						_nPisAlq   := SD2->D2_ALQIMP6
						_nPisVal   := round( _nPisBase * ( _nPisAlq/100) , 2 )
						
						_nCofBase  := SD2->D2_TOTAL
						_nCofAlq   := SD2->D2_ALQIMP5
						_nCofVal   := round( _nCofBase * ( _nCofAlq/100) , 2 )
						
						if RECLOCK("SD2",.F.)
							
							// PIS
							
							SD2->D2_BASIMP6 :=  _nPisBase
							SD2->D2_ALQIMP6 :=  _nPisAlq
							SD2->D2_VALIMP6 :=  _nPisVal
							
							// COFINS
							
							SD2->D2_BASIMP5 :=  _nCofBase
							SD2->D2_ALQIMP5 :=  _nCofAlq
							SD2->D2_VALIMP5 :=  _nCofVal
							
							SD2->(MSUNLOCK())
							
							CD2->(DbSetOrder(1))
							CD2->(Dbgotop())
							
							IF CD2->( DbSeek(xFilial("CD2")+'S'+SD2->D2_SERIE+SD2->D2_DOC+SD2->D2_CLIENTE+SD2->D2_LOJA + padr( SD2->D2_ITEM, 4 )+SD2->D2_COD+'PS2', .f. ) )
								
								if RecLock("CD2",.F.)
									
									CD2->CD2_BC     := SD2->D2_BASIMP6
									CD2->CD2_ALIQ   := SD2->D2_ALQIMP6
									CD2->CD2_VLTRIB := SD2->D2_VALIMP6
									
									CD2->CD2_QTRIB  := 0
									CD2->CD2_PAUTA  := 0
									
									CD2->(MsUnLock())
									
								Endif
								
							ENDIF
							
							CD2->(Dbgotop())
							
							IF CD2->( DbSeek(xFilial("CD2")+'S'+SD2->D2_SERIE+SD2->D2_DOC+SD2->D2_CLIENTE+SD2->D2_LOJA + padr( SD2->D2_ITEM, 4 )+SD2->D2_COD+'CF2', .f. ) )
								
								if RecLock("CD2",.F.)
									
									CD2->CD2_BC     := SD2->D2_BASIMP5
									CD2->CD2_ALIQ   := SD2->D2_ALQIMP5
									CD2->CD2_VLTRIB := SD2->D2_VALIMP5
									CD2->CD2_QTRIB  := 0
									CD2->CD2_PAUTA  := 0
									
								Endif
								
								CD2->(MsUnLock())
								
							ENDIF
							
							
							DBSELECTAREA("SFT")
							SFT->(DBSETORDER(1))
							
							IF SFT->(DBSEEK(XFILIAL("SFT") + "S" + SD2->D2_SERIE+SD2->D2_DOC+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_ITEM+'  '+SD2->D2_COD))
								
								RECLOCK("SFT",.F.)
								
								SFT->FT_BASEPIS := SD2->D2_BASIMP6
								SFT->FT_VALPIS  := SD2->D2_VALIMP6
								
								SFT->FT_ALIQPIS := SD2->D2_ALQIMP6
								SFT->FT_PAUTPIS := 0
								
								SFT->FT_BASECOF := SD2->D2_BASIMP5
								SFT->FT_VALCOF  := SD2->D2_VALIMP5
								
								SFT->FT_ALIQCOF := SD2->D2_ALQIMP5
								SFT->FT_PAUTCOF := 0
								
								//SFT->FT_TNATREC := SD2->D2_TNATREC
								//SFT->FT_CNATREC := SD2->D2_CNATREC
								//SFT->FT_GRUPONC := SD2->D2_GRUPONC
								
								SFT->(MSUNLOCK())
								
							Endif
							
						Endif
						
					Endif
					
				Endif
				
			Endif
			
		Endif
		
		// Ipi por CFOP
		
		_nPosImp := aScan( _aIpi , {|x| AllTrim(x[1]) + X[2] == alltrim(SD2->D2_CF) + STRZERO( SD2->D2_PICM , 5 , 2 ) } )
		
		IF _nPosImp > 0
			_aIpi[_nPosImp][3] += SD2->D2_BASEIPI
			_aIpi[_nPosImp][4] += SD2->D2_VALIPI
		Else
			aadd( _aIpi ,  { alltrim(SD2->D2_CF) , STRZERO( SD2->D2_PICM , 5 , 2 ) , SD2->D2_BASEIPI , SD2->D2_VALIPI } )
		Endif
		
		
		///////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////
		
		_nPosImp := aScan( _aPis , {|x| AllTrim(x[1]) == alltrim(SD2->D2_CF) } )
		
		IF _nPosImp > 0
			_aPis[_nPosImp][2] += SD2->D2_BASIMP6
			_aPis[_nPosImp][3] += SD2->D2_VALIMP6
		Else
			aadd( _aPis ,  { alltrim(SD2->D2_CF) , SD2->D2_BASIMP6 , SD2->D2_VALIMP6 } )
		Endif
		
		///////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////

		_nPosImp := aScan( _aCofins , {|x| AllTrim(x[1]) == alltrim(SD2->D2_CF) } )
		
		IF _nPosImp > 0
			_aCofins[_nPosImp][2] += SD2->D2_BASIMP5
			_aCofins[_nPosImp][3] += SD2->D2_VALIMP5
		Else
			aadd( _aCofins ,  { alltrim(SD2->D2_CF) , SD2->D2_BASIMP5 , SD2->D2_VALIMP5 } )
		Endif
		
		///////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////
		
		xBaseIpi 	+= SD2->D2_BASEIPI
		xBasePis 	+= SD2->D2_BASIMP6
		xBaseCof 	+= SD2->D2_BASIMP5
		
		xValorIpi 	+= SD2->D2_VALIPI
		xValorPis 	+= SD2->D2_VALIMP6
		xValorCof 	+= SD2->D2_VALIMP5
		
		SD2->( DBSKIP() )
		
	Enddo
	
	if _lAtualCab
		
		if SF2->( RECLOCK("SF2",.F.) )
			
			// IPI
			SF2->F2_BASEIPI	:=  xBaseIpi
			SF2->F2_VALIPI 	:=  xValorIpi
			
			// PIS
			SF2->F2_BASIMP6 :=  xBasePis
			SF2->F2_VALIMP6 :=  xValorPis
			
			// COFINS
			SF2->F2_BASIMP5 :=  xBaseCof
			SF2->F2_VALIMP5 :=  xValorCof
			
			// VALOR BRUTO
			SF2->F2_VALBRUT	:=  ( SF2->F2_VALMERC+SF2->F2_VALIPI+SF2->F2_ICMSRET )
			
			SF2->(MSUNLOCK())
			
		ENDIF
		
		//////////////////////////
		
		// Liberada em 07/07/2015 para corrigir o SF3 das alteracoes efetuadas
		
		DBSELECTAREA("SF3")
		SF3->(DBSETORDER(1))
		
		SF3->( DBSEEK( SF2->(F2_FILIAL+DTOS(F2_EMISSAO)+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA ), .F. ) )
		
		Do while ! ( SF3->(EOF()) )  .AND. SF3->( F3_FILIAL+DTOS(F3_ENTRADA)+F3_NFISCAL+F3_SERIE+F3_CLIEFOR+F3_LOJA ) == SF2->(F2_FILIAL+DTOS(F2_EMISSAO)+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA )
			
			//STR(F3_ALIQICM,5,2)
			
			for _i := 1 to len(_aIpi)
				
				if alltrim( SF3->F3_CFO ) == ALLTRIM( _aIpi[_i][1] ) .and.  strzero( F3_ALIQICM , 5, 2 ) == _aIpi[_i][2]
					
					if reclock( "SF3" , .f. )
						
						SF3->F3_BASEIPI	:=  _aIpi[_i][3]
						SF3->F3_VALIPI 	:=  _aIpi[_i][4]
						
						msunlock()
						
					Endif
					
				Endif
				
			Next
			
			SF3->( DBSKIP() )
			
		Enddo
		
		//////////////////////////////////////////////////
		
	Endif
	
	RESTAREA(_AaREA)
	
Endif


Return NIL
