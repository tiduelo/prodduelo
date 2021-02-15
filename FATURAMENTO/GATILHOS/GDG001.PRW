#INCLUDE "rwmake.ch"

////////////////////////////
User Function GDG001(_produto,_preco,_cliente,_cloja)
Local aArea := GetArea()
////////////////////////////
// gatilho para calculo do preco inicial de venda de um produto
////////////////////////////
aSvAlias:={Alias(),IndexOrd(),Recno()}

if .t. 
//IF sm0->m0_codigo == '04'
	
	_Preco2  := round(_preco,4)
	_cEst    := "PA"
	_cliSol  := "S"
	_cGrpCli := space(3) // chave da pesquisa da excessao fiscal
	
	if !empty(_produto)
		
		dbselectarea("SB1")
		dbsetorder(1)
		DbGotop()
		
		if dbseek(xfilial("SB1")+ _produto ,.F.)
			
			_cSb1Grup	:= SB1->B1_GRUPO
			_Valipi     := SB1->B1_VLRIPI
			_Alqipi     := SB1->B1_IPI
			
			_Picmpad    := getmv("MV_ICMPAD")  // Falta o icms de destino fora do para
			_Picm       := SB1->B1_PICM
			_PAgrega    := SB1->B1_PICMRET
			
			if !Empty(_cliente)// <> nil
				
				dbSelectArea("SA1")				
				dbSetOrder(1)
				dbGoTop()
				//_nSA1Ord := IndexOrd()
				//_nSA1Reg := RecNo()
				
				IF dbSeek(xFilial("SA1")+_cliente + _cloja)
					_cEst   := upper(alltrim(SA1->A1_EST))
					_cliSol := upper(alltrim(SA1->A1_TIPO))
				EndIf
				
				dbselectarea("SB1")				
			Endif
			
			if _Picm == 0
				_Picm := _Picmpad
			Endif
			
			_PicmDes := _Picm
			
			if _cEst  <> "PA"
				
				if _cliSol <> "F"
					_Picm    := 12
					_PicmDes := 12
				Endif
				
			Endif
			
			IF _cliSol == "S" .and. _cEst $ "PA/AP"       //Testa se o cliente é do estado do Para ou Amapa
				
				If _cSb1Grup $ '0203' // Energeticos
					
					If _cEst == 'AP'
						_cSeqExc := "01"
					ElseIf _cEst == "PA"
						_cSeqExc := "02"
					Endif
					
				ElseIf _cSb1Grup $ '0204|0206'   // Refrigerante ok // Refrigerante Cerpa
					
					If _cEst == 'PA'
						_cSeqExc := "03"
					ElseIf _cEst == "AP"
						_cSeqExc := "04"
					Endif
					
				ElseIf  _cSb1Grup $ '0205'   // Suco Tampico
					
					If _cEst == 'PA'
						_cSeqExc := "01"
					ElseIf _cEst == "AP"
						_cSeqExc := "02"
					Endif
					
				Else
					
					if _cEst == "PA"
						_cSeqExc := "22"
					ElseIf _cEst == "AP"
						_cSeqExc := "25"
					Endif
					
				Endif
				
				
				// Busca no arquivo de excssao fiscal
				dbSelectArea("SF7")
				_nSF7Ord := IndexOrd()
				_nSF7Reg := RecNo()
				
				dbSetOrder(1)
				
				IF !Empty(SB1->B1_GRTRIB) .And. dbSeek(xFilial("SF7")+PADR(SB1->B1_GRTRIB,6)+_cGrpCli+_cSeqExc)
					_Picm      := SF7->F7_ALIQINT        // tações aquele ao qual o produto
					_PicmDes   := SF7->F7_ALIQEXT        // se enquadra e retorna valor do ICM
					_PAgrega   := iif(SF7->F7_MARGEM > 0 , SF7->F7_MARGEM, _PAgrega )
				ENDIF
				
				dbSetOrder(_nSF7Ord)
				dbGoTo(_nSF7Reg)
				
				dbselectarea("SB1")
				
				
			Endif
			
			if left(b1_cod,4) == '0202' .and. _cEst == 'PA'
				
				if dDatabase > ctod("31/12/2013")
					_PicmCrd := _Picm
				Else
					_PicmCrd := 40
				Endif
				
			Else
				
				_PicmCrd := _Picm
				
			Endif
			
			Do While .t.
				
				_precotmp   := _Preco2
				
				_Valipi     := round( ( _precotmp * _Alqipi / 100  ) , 2 )
				
				_VlrIcm     := _precotmp * (_Picm/100)
				
				_vlrMercad  := _precotmp
				
				_vlrTotal   := _vlrMercad  +_Valipi
				
				if left(b1_cod,4) == '0202'
					
					if dDatabase > ctod("31/12/2013")
						_VlrIcmCrd  := _vlrMercad  * (_PicmCrd/100)
					Else
						_VlrIcmCrd  := _vlrTotal   * (_PicmCrd/100)
					Endif
					
				Else
					_VlrIcmCrd  := _vlrMercad  * (_PicmCrd/100)
				Endif
				
				
				if _PAgrega > 0
					
					_Agrega     := _vlrTotal * (_PAgrega/100)
					_BaseSt     := _vlrTotal + _Agrega
					
					_VlrIcmSub  := (_BaseSt * (_Picm/100)) - _VlrIcmCrd
					
					if _VlrIcmSub <= 0
						_VlrIcmSub := 0.00
					Endif
					
				Else
					
					_BaseSt     := 0
					_VlrIcmSub  := 0
					
				Endif
				
				_precoFim := _precotmp+_Valipi+_VlrIcmSub
				
				if _precoFim < 0
					_preco2 := 0
					exit
				Endif
				
				//if round(_precoFim,4) <= round(_preco,4)
				//if STRZERO(_precoFim,12,4) <= STRZERO(_preco,12,4)
				
				if noround(_precoFim,4) <= noround(_preco,4)
					_preco2 := _precotmp
					exit
				Else
					_preco2 -= 0.0001
				Endif
				exit
			Enddo
			
		Endif
		
	Endif
	
Else
	
	_Preco2  := _preco
	
Endif


dbSelectArea(aSvAlias[1])
dbSetOrder(aSvAlias[2])
dbGoto(aSvAlias[3])

//_nPosCpo := Ascan(aHeader, {|x| Alltrim(x[2]) == "DA1_PRCFIN"})
//n ++
//msgetdados():refresh()
RestArea(aArea)
return(_preco2)
