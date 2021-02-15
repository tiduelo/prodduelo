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
User Function MSD2460
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// ALERT("Teste")

_aArea := GETAREA()

IF SD2->D2_TIPO == "D"
	
	SD1->(DBSETORDER(2))
	
	IF SD1->(DBSEEK(XFILIAL("SD1")+SD2->D2_COD+SD2->D2_NFORI+SD2->D2_SERIORI))
		RECLOCK("SD2",.F.)
		SD2->D2_CC := SD1->D1_CC
		MSUNLOCK("SD2")
	ENDIF
	
ENDIF

SF4->(DBSETORDER(1))
SF4->(DBSEEK(SD2->D2_FILIAL+SD2->D2_TES))

IF ( SF4->F4_CODIGO == SD2->D2_TES ) .AND. ALLTRIM(SF4->F4_PISCOF) == "3"
	
	SB1->(DBSETORDER(1))
	SB1->(DBSEEK(SD2->D2_FILIAL+SD2->D2_COD))
	
	IF ( SB1->B1_COD == SD2->D2_COD )
		
		// Tratamento da Lei 13.097/2015 (novas aliquotas de IPI,PIS e COFINS
		
		_lPauta := .f.
		
		IF dtos(SD2->D2_EMISSAO) >= '20150501'
			
			If AllTrim(FWCodEmp()) == "04" 
			//IF SM0->M0_CODIGO == "04"
				
				if SD2->D2_TIPO == "N" .and. ALLTRIM(SF4->F4_PISCRED) == "2" .and. alltrim(SA1->A1_SATIV1) == "000104"
					
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
						
						// IPI
						if SB1->B1_IPI2 > 0
							SD2->D2_BASEIPI	:=  SD2->D2_TOTAL
							SD2->D2_IPI 	:=  SB1->B1_IPI2
							SD2->D2_VALIPI 	:=  round( SD2->D2_TOTAL * (SB1->B1_IPI2/100) , 2  )
						Endif
						
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
						
					Endif
					
				Else
					
					//
					// Calculo do Pis e Cofins para fora do estado
					//
					
					IF LEFT( SD2->D2_CF , 1 ) == '6'
						
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
							
						Endif

					Endif
					
				Endif
				
			Endif
			
		Else
			
			IF  ALLTRIM(SB1->B1_TNATREC) == "4311"  .and.  ( ALLTRIM(SB1->B1_CNATREC) $ "930,970" )
				
				//.and. (SB1->B1_QDTLIT > 0) // Incluido em 14-02-13 para nao zerar PIS e COFINS de produtos diferente de Refrigerante
				
				RECLOCK("SD2",.F.)
				
				SD2->D2_BASIMP5 :=  SD2->D2_QUANT * SB1->B1_CONV * SB1->B1_QDTLIT  // COFINS
				SD2->D2_BASIMP6 :=  SD2->D2_QUANT * SB1->B1_CONV * SB1->B1_QDTLIT  // PIS
				
				SD2->D2_ALQIMP5 :=  0 //SB1->B1_VLR_COF
				SD2->D2_ALQIMP6 :=  0 //SB1->B1_VLR_PIS
				
				SD2->D2_VALIMP5 :=  SD2->D2_BASIMP5 * SB1->B1_VLRCOF
				SD2->D2_VALIMP6 :=  SD2->D2_BASIMP6 * SB1->B1_VLRPIS
				
				SD2->(MSUNLOCK())
				
			Endif
			
			IF  ALLTRIM(SB1->B1_TNATREC) == "4311"  .and. ALLTRIM(SB1->B1_CNATREC) $ "759,760,762"
				
				RECLOCK("SD2",.F.)
				
				SD2->D2_BASIMP5 :=  SD2->D2_QUANT  // COFINS
				SD2->D2_BASIMP6 :=  SD2->D2_QUANT  // PIS
				
				SD2->D2_ALQIMP5 :=  0 //SB1->B1_VLR_COF
				SD2->D2_ALQIMP6 :=  0 //SB1->B1_VLR_PIS
				
				SD2->D2_VALIMP5 :=  SD2->D2_BASIMP5 * SB1->B1_VLRCOF
				SD2->D2_VALIMP6 :=  SD2->D2_BASIMP6 * SB1->B1_VLRPIS
				
				SD2->(MSUNLOCK())
				
			Endif
			
		Endif
		
	Endif
	
Endif

RESTAREA(_aAREA)

Return NIL
