#include "Rwmake.ch"
#include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FATVC02   �Autor  �Henio Brasil        � Data � 06/11/2012  ���
�������������������������������������������������������������������������͹��
���Desc.     �Validacao na coluna de Qtd do Item do pedido para tratar    ���
���          �lote de Prdutos Acabados.                                   ���
�������������������������������������������������������������������������͹��
���Uso       �Totvs Para                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������
*/
User Function FATVC02()		// Antiga: ChecSld(_nQtd)

Local nAnsLote	:= 0
Local lRetorno := .T.
Local lBroke 	:= .T.
Local lLoteAuto:= .T. 			// Parametro para desligar a personalizacao
Local lMsErrAuto:= .F.
Local lDispLote:= .F.
Local lUpdate 	:= (Altera)
Local aAreaPed	:= GetArea()
Local nQtdPed	:= &(ReadVar())
Local dDatLote	:= Ctod("  /  /  ")
Local nPosTes	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})
Local nPosProd := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
Local nPosAlmo := aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOCAL"})
Local nPosDtVal:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_DTVALID"})
Local nPosQLib	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDLIB"})
Local nPosQPed	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})
Local nPLoteNew:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOTENEW"})		// "C6_LOTECTL"
Local nPLoteCtl:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOTECTL"})
Local nPLoteCtl:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOTECTL"})
Local nPosPunit:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})
Local nPosPTab := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRUNIT"})
Local nPospTot := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})

SB2->(DbSetOrder(1))

If SB2->(DbSeek(xFilial("SB2")+aCols[n][nPosProd]+aCols[n][nPosAlmo]))
	nQtdSaldo := SB2->B2_QATU-SB2->B2_RESERVA
	If nQtdPed > nQtdSaldo
		//ALERT("Saldo Insuficiente "+transform(nQtdSaldo,"@e 999,999.99"))     
	   	//Aviso("Aten��o", "FatVc02 - N�o h� estoque suficiente para movimenta��o deste item!", {"&Ok"}, 2, "Saldo Insuficiente")
	   	MsgInfo( "FatVc02 - N�o h� estoque suficiente para movimenta��o deste item!", "Aten��o")
		lRetorno := .F.
	Endif
EndIf
/*
������������������������������������������������������������������������Ŀ
�Desliga a personalizacao do Lote no pedido de vendas                    �
��������������������������������������������������������������������������
*/
If !lLoteAuto
	Return(.T.)
Endif
/*
������������������������������������������������������������������������Ŀ
�Verifica se o produto tem Rastreabilidade                               �
��������������������������������������������������������������������������
*/
If !Rastro(aCols[n][nPosProd])
	Return(.T.)
Endif
/*
������������������������������������������������������������������������Ŀ
�Verifica se Movimenta Estoque                                           �
��������������������������������������������������������������������������
*/
If lUpdate .And. lRetorno
	
	dbSelectArea("SF4")
	dbSetOrder(1)
	
	If (  MsSeek(xFilial("SF4")+aCols[n][nPosTes]) .And. SF4->F4_ESTOQUE=="N" )
		
		If !Empty(aCols[n][nPLoteNew]) .Or. !Empty(aCols[n][nPLoteCtl])
			Aviso("Aten��o", "FatVc02 - Este TES n�o exige atualiza��o de estoque, logo n�o precisa de informa��o de Lote!", {"&Ok"}, 2, "TES incorreto")
			
			If Aviso("Decis�o","Deseja permanecer com este TES ? Em caso positivo o sistema atualizar� as colunas referente a Lote!", {"&Sim","&N�o"}, 2, "Decis�o") == 1
				M->C6_LOTENEW			:= space(10)
				M->C6_LOTECTL			:= space(10)
				aCols[n][nPLoteNew]	:= space(10)
				aCols[n][nPLoteCtl]	:= space(10)
				M->C6_DTVALID			:= dDatLote
				aCols[n][nPosDtVal]	:= dDatLote
			Endif
			
			Return(.T.)
			
		EndIf
		
	EndIf
	
Endif

/*
������������������������������������������������������������������������Ŀ
�Verifica se o produto tiver rastreabilidade obriga colocar informacao   �
��������������������������������������������������������������������������
If lRetorno .And. Rastro(aCols[n][nPosProd]) .And.
Aviso("Aten��o", "A410LinOk - Este produto possui rastreabilidade, logo � preciso inform�-la.", {"&Ok"}, 2, "Produto Sem Lote")
Return(.T.)
Endif
*/

/*
������������������������������������������������������������������������Ŀ
�Pesquisa a tabela de Lotes para criar regra de distribuicao por data    �
�de validade.                                                            �
��������������������������������������������������������������������������
*/
If lRetorno
	
	dbSelectArea("SB8")
	
	SB8->(dbSetOrder(1))   // Por data de validade
	
	If SB8->( dbSeek(xFilial("SB8")+aCols[n][nPosProd]+aCols[n][nPosAlmo]))
		
		While !Eof() .And. SB8->(B8_FILIAL+B8_PRODUTO+B8_LOCAL) == xFilial("SB8")+aCols[n][nPosProd]+aCols[n][nPosAlmo]
			/*
			������������������������������������������������������������������������Ŀ
			�Valida a data do lote, se for antigo passa para o proximo               �
			��������������������������������������������������������������������������
			*/
			If SB8->B8_DTVALID <= dDataBase .And. SB8->B8_SALDO > 0.0
				
				Aviso("Aten��o", "FatVc02 - Existem lotes com data de validade vencida! Informe ao Depto de Produ��o!", {"&Ok"}, 2, "Validade vencida")
				aCols[n][nPLoteNew]	:= ""
				aCols[n][nPLoteCtl]	:= ""
				aCols[n][nPosDtVal]	:= dDatLote
				
			Else
				
				If SB8->B8_DTVALID <= (dDataBase+30) .And. SB8->B8_SALDO > 0.0
//					Aviso("Aten��o", "FatVc02 - O lote ira vencer em ate 30 dias! Informe ao Depto de Produ��o!", {"&Ok"}, 2, "Validade a vencer")
			   	   	MsgInfo("FatVc02 - O lote ir� vencer em at� 30 dias! Informe ao Depto de Produ��o!", "Aten��o")
	   	
//	   		   	MsgInfo( "FatVc02 - N�o h� estoque suficiente para movimenta��o deste item!", "Aten��o")
				Endif
				
				If (SB8->(B8_SALDO-B8_EMPENHO) > 0)
					Exit
				Endif
				
			Endif
			
			SB8->(DbSkip())
			
		Enddo
		
		/*
		������������������������������������������������������������������������Ŀ
		�Efetua a quebra de lotes caso a qtd solicitada for > que a qtd do lote  �
		��������������������������������������������������������������������������
		*/
		lDispLote := (SB8->(B8_SALDO-B8_EMPENHO) > 0)
		
		If nQtdPed > SB8->(B8_SALDO-B8_EMPENHO) .And. SB8->(B8_SALDO-B8_EMPENHO) > 0
			
			nAnsLote := Aviso("Decis�o","Escolha a forma de quebra de Lote para item de pedido.", {"&Autom�tico","&Manual"}, 2, "Decis�o")
			
			
			If nAnsLote == 1
				
				cChave := xFilial("SB8")+aCols[n][nPosProd]+aCols[n][nPosAlmo]
				lBroke := U_Vc02ItBreak(cChave,SB8->(B8_SALDO-B8_EMPENHO),nQtdPed, nPosQPed,nPosQLib,nPLoteNew,nPLoteCtl,nPosDtVal,nPosPunit,nPospTot)

			Else
				/*
				������������������������������������������������������������������������Ŀ
				�Variaveis Privates utilizadas na  funcao  F4Lote                        �
				��������������������������������������������������������������������������
				nPosLote  	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_NUMLOTE"})
				nPosLotCtl 	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOTENEW"})
				nPosDValid  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_DTVALID"})
				nPosPotenc  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_POTENCI"})
				Vc01LoteShow(,,,"A440",cProduto,cLocal)
				*/
			Endif
			
		Else
			
			If lDispLote
				/*
				������������������������������������������������������������������������Ŀ
				�Caso de substituicao de produto, sendo o anterior com Rastro tambem     �
				��������������������������������������������������������������������������
				*/
				If lUpdate .And. !Empty(aCols[n][nPosDtVal]) .And. (aCols[n][nPosDtVal] <> SB8->B8_DTVALID) 		// !lBroke
					/*
					lMSErrAuto := !Empty(aCols[n][nPosDtVal])
					If lMSErrAuto
					Help(" ",1,"A240DTVALI")
					*/
				EndIf
				
				aCols[n][nPLoteNew]	:= SB8->B8_LOTECTL
				aCols[n][nPLoteCtl]	:= SB8->B8_LOTECTL
				aCols[n][nPosDtVal]	:= SB8->B8_DTVALID
				
			Endif
			
			/*
			������������������������������������������������������������������������Ŀ
			�Se depois das consistencias ainda restar algo, gera lote para o Item    �
			��������������������������������������������������������������������������
			*/
			
			If Empty(aCols[n][nPLoteNew]) .And. Empty(aCols[n][nPLoteCtl]) .And. Empty(aCols[n][nPosDtVal])
				aCols[n][nPLoteNew]	:= SB8->B8_LOTECTL
				aCols[n][nPLoteCtl]	:= SB8->B8_LOTECTL
				aCols[n][nPosDtVal]	:= SB8->B8_DTVALID
			Endif
			
		Endif
		
	Endif
	
	If !lBroke .Or. !lDispLote
		Aviso("Aten��o", "FatVc02 - N�o h� lotes disponibiveis para atender a demanda solicitada, aceite a sugest�o da quantidade dispon�vel ou altere o produto!", {"&Ok"}, 2, "Lotes Indispon�veis.")
		M->C6_QTDVEN	    	:= 0.0
		aCols[n][nPosQPed]	:= 0.0
		aCols[n][nPosQLib]	:= 0.0
	Endif
	
Endif

Ma410Rodap(o)

RestArea(aAreaPed)
Return(lRetorno)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Vc02ItBreak �Autor  �Henio Brasil      � Data � 06/11/2012  ���
�������������������������������������������������������������������������͹��
���Desc.     �Efetua a quebra do lote em qtos itens forem necessarios ate ���
���          �satisfazer a quantidade solicitada.                         ���
�������������������������������������������������������������������������͹��
���Uso       �Totvs Para                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������
*/
User Function Vc02ItBreak(cChvLote,nSalSb8,nQtdPed, nPosQPed,nPosQLib,nPLoteNew,nPLoteCtl,nPosDtVal,nPosPunit,nPospTot)

/*
1. Precisa ver se e' a ultima linha;
2. Se for, basta criar a proxima com o resto da quant.
3. Se nao for, precisa empurrar as demais para baixo
*/
Local nPosIt	:= n
Local aLote		:= {}
Local aTemp		:= {}
Local lRet 		:= .T.
Local nQtdLine	:= 0.0
Local nQtdTot 	:= nQtdPed
Local aLine		:= aClone(aCols[n])
Local nPosItem	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_ITEM"})
Local cItemPed	:= aCols[n][nPosItem]
Local _ax := 0 

DbSelectArea("SB8")

While !Eof() .And. SB8->(B8_FILIAL+B8_PRODUTO+B8_LOCAL) = cChvLote
	
	IF SB8->(B8_SALDO-B8_EMPENHO) > 0
		
		//nQtdLine := iIf( nQtdLine==0 , SB8->(B8_SALDO-B8_EMPENHO), Iif( nQtdTot > SB8->(B8_SALDO-B8_EMPENHO), Abs( nQtdTot - SB8->(B8_SALDO-B8_EMPENHO) ) , nQtdTot ) )
		nQtdLine := iIf( nQtdLine==0 , SB8->(B8_SALDO-B8_EMPENHO), Iif( nQtdTot > SB8->(B8_SALDO-B8_EMPENHO), SB8->(B8_SALDO-B8_EMPENHO) , nQtdTot ) )
		
		If SB8->B8_DTVALID > dDataBase
			
			If nPosIt == n 		// Se for a 1a manutencao, esta na linha da ocorrencia;
				
				M->C6_QTDVEN 		:= nQtdLine
				
				aCols[n][nPosQPed]	:= nQtdLine
				aCols[n][nPosQLib]	:= Iif(aCols[n][nPosQLib]<>0, nQtdLine, aCols[n][nPosQLib])
				aCols[n][nPLoteNew]	:= SB8->B8_LOTECTL
				aCols[n][nPLoteCtl]	:= SB8->B8_LOTECTL
				aCols[n][nPosDtVal]	:= SB8->B8_DTVALID

				aCols[n][nPospTot]	:= round(aCols[n][nPosPunit]*aCols[n][nPosQPed] , 2)
				
				// M->C6_QTDLIB 		:= Iif(M->C6_QTDLIB<>0, nQtdLine, M->C6_QTDLIB)
				// M->C6_LOTENEW		:= SB8->B8_LOTECTL
				// M->C6_LOTECTL		:= SB8->B8_LOTECTL
				// M->C6_DTVALID		:= SB8->B8_DTVALID
				
			Else
				
				// nPosQPed,nPLoteNew,nPLoteCtl,nPosDtVal)
				aLine[nPosItem ]:= cItemPed		// StrZero(nPosIt,2)
				aLine[nPosQPed ]:= nQtdLine
				aLine[nPosQLib ]:= Iif(aLine[nPosQLib]<>0,nQtdLine,aLine[nPosQLib])
				aLine[nPLoteNew]:= SB8->B8_LOTECTL
				aLine[nPLoteCtl]:= SB8->B8_LOTECTL
				aLine[nPosDtVal]:= SB8->B8_DTVALID

				aLine[nPospTot] := round(aLine[nPosPunit]*aLine[nPosQPed],2)

				
				Aadd( aCols, array(len(aLine)) )
				
				For _ax := 1 to len(aLine)
					aCols[len(acols)][_ax] := aLine[_ax]
				Next
				
				// Destativado em 4/6/2013 nilson para verificacao pois nao permitia mais de 2 lotes automaticos
				
				/*
				
				If Len(aCols) == n         // Significa que estou no fim do aCols
				
				Aadd(aCols, aLine)
				
				Else
				
				aLote := Array(Len(aCols)+1) 		// temporariamente desativado
				
				For nL:= 1 To Len(aCols) 			// Len(aLote)
				
				If nL >= nPosIt
				
				// Incluir a linha nova , ou nao fazer nada pois os anteriores
				
				aLote[nL]:= aClone(aCols[nL])
				aLote[nL][nPosItem]:= StrZero(Val(aLote[nL][nPosItem])+1,2)
				aCols[nL]:= aLine
				Aadd(aCols, aLote[nL])
				
				// Acerta apenas a coluna de Item de Pedido:
				// If Len(aCols)+1 < nL
				//    Aadd(aCols, aLote[nL])
				// Endif
				
				Endif
				
				Next
				
				Endif
				
				*/
				
			Endif
			
			If (nQtdTot-nQtdLine) == 0.0
				Exit
			Endif
			
			nPosIt	+= 1
			nQtdTot -= nQtdLine
			
			//cItemPed:= StrZero(Val(aCols[ n ][nPosItem])+1,2) // Verificar se nao pode ser usado em vez de "n" a opcao "len(acols)"
			cItemPed:= StrZero( Val(aCols[ len(acols) ][nPosItem])+1 , 2 ) // Verificar se nao pode ser usado em vez de "n" a opcao "len(acols)"
			
		Endif
		
	Endif
	
	SB8->(DbSkip())
	
Enddo

Return(lRet)
