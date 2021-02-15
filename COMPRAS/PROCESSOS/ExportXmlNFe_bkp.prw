#Include "Protheus.ch"
#Include "ApWebSrv.ch"
#Include "TopConn.ch"


//-----------------------------------------------------------------------
/*/{Protheus.doc} BaixaZip()
Montagem da Dialog 'Exportar Zip'

@author Natalia Sartori
@since 04.07.2012
@version 1.00

@param cAlias, nReg, nOpc, cMarca, lInverte
/*/
//-----------------------------------------------------------------------
user function zExpoXML()
Local cWhere	:= ""
Local aNFXML	:= {}
Local _nL := 0

     cWhere += "%"
      cWhere += " C00_FILIAL='"+xFilial("C00")+"'"
      cWhere += " AND C00_STATUS = '1' "
      cWhere += " AND C00_CODEVE = '3' "
      cWhere += " AND C00_SITDOC = '1' "
	  cWhere += " AND C00_EXPXML = ''  "
      cWhere += "%"

      BeginSql Alias "TMPC00"
			SELECT C00_SERNFE , C00_NUMNFE
			FROM %Table:C00%    
			WHERE %Exp:cWhere% AND
			%notdel%
      EndSql

      TMPC00->(dbGotop())

        While !TMPC00->(Eof())
          aadd(aNFXML,{TMPC00->C00_SERNFE, TMPC00->C00_NUMNFE})
          TMPC00->(dbSkip())
        End
      TMPC00->(dbCloseArea())

	   For _nL:= 1 to Len(aNFXML)
		U_XMLBaixaGz( aNFXML[_nL,1], aNFXML[_nL,2])
	   Next _nL

Return




//-----------------------------------------------------------------------
/*/{Protheus.doc} BaixaZip()
Montagem da Dialog 'Exportar Zip'

@author Natalia Sartori
@since 04.07.2012
@version 1.00

@param cAlias, nReg, nOpc, cMarca, lInverte
/*/
//----------------------------------------------------------------------- 
user function XMLBaixaGz(_cSerXml, _cDocXml)


  Local aArea		:= GetArea()
  Local aPerg		:= {}
  Local aParam	:= {Space(3),Space(09),Space(09),Space(60),Space(1)}
  Local aChaves	:= {}
  Local aXmlRet	:= {}

  Local cPaExpXml	:= SM0->M0_CODIGO+SM0->M0_CODFIL+"BxXml"
  Local cWhere	:= ""
  Local lUsaColab := .f.
  Local cAliasTemp:= GetNextAlias()
  Local cURL		:= PadR(GetNewPar("MV_SPEDURL","http://"),250)
  Local cIdEnt	:= RetIdEnti(lUsaColab)
  Local cAmbiente	:= ""
  Local cAviso	:= ""
  Local cHelp		:= ""
  Local lParamOk	:= .F.
  Local lRet		:= .F.

  Local nX		:= 0
  Local nY		:= 0
  Local nZ		:= 0
  Local nW		:= 0
  Local nXAux		:= 0
  Local nQtdChv	:= 0

//Váriavel que define se vai ser a exportação direta ou irá montar browse para marcar - usado apenas para TOTVS Colaboração
  Default nOpc		:= 0

  Private oRet

  If CTIsReady(cURL)
    MV_PAR01 := aParam[01] :=  _cSerXml //PadR(ParamLoad(cPaExpXml,aPerg,1,aParam[01]),Len(C00->C00_SERNFE))
    MV_PAR02 := aParam[02] :=  _cDocXml //PadR(ParamLoad(cPaExpXml,aPerg,2,aParam[02]),Len(C00->C00_NUMNFE))
    MV_PAR03 := aParam[03] :=  _cDocXml //PadR(ParamLoad(cPaExpXml,aPerg,3,aParam[03]),Len(C00->C00_NUMNFE))
    MV_PAR04 := aParam[04] := "D:\TOTVS12\Microsiga\Protheus_Data\importadorxml\inn" //ParamLoad(cPaExpXml,aPerg,4,aParam[04])
    MV_PAR05 := aParam[05] := "2" //ParamLoad(cPaExpXml,aPerg,5,aParam[05])


      cWhere += "%"
      cWhere += " C00_FILIAL='"+xFilial("C00")+"'"
      cWhere += " AND C00_NUMNFE BETWEEN '" + MV_PAR02 + "' AND '" + MV_PAR03 + "'"
      cWhere += " AND C00_SERNFE = '" + MV_PAR01+ "'"
      cWhere += " AND C00_STATUS = '1' "
      cWhere += " AND C00_CODEVE = '3' "
      cWhere += " AND C00_SITDOC = '1' "
	  cWhere += " AND C00_EXPXML = ''  "
      cWhere += "%"

      BeginSql Alias cAliasTemp
			SELECT C00_CHVNFE
			FROM %Table:C00%    
			WHERE %Exp:cWhere% AND
			%notdel%
      EndSql

      (cAliasTemp)->(dbGotop())


        While !(cAliasTemp)->(Eof())
          aadd(aChaves,(cAliasTemp)->C00_CHVNFE)
          (cAliasTemp)->(dbSkip())
        End
  
      (cAliasTemp)->(dbCloseArea())
      RestArea(aArea)

        oWs :=WSMANIFESTACAODESTINATARIO():New()
        oWs:cUserToken   := "TOTVS"
        oWs:cIDENT	     := cIdEnt
        oWs:cAMBIENTE	 := ""
        oWs:cVERSAO      := ""
        oWs:_URL         := AllTrim(cURL)+"/MANIFESTACAODESTINATARIO.apw"
        oWs:CONFIGURARPARAMETROS()
        cAmbiente		 := oWs:OWSCONFIGURARPARAMETROSRESULT:CAMBIENTE

        oWs:cUserToken   := "TOTVS"
        oWs:cIDENT	     := cIdEnt
        oWs:cAMBIENTE	 := cAmbiente

        oWs:_URL         := AllTrim(cURL)+"/MANIFESTACAODESTINATARIO.apw"

        cAviso := "Arquivos gerados: "+ CRLF + CRLF + "Serie  Numero" + CRLF

        While nQtdChv < Len(aChaves)

          oWs:oWSDOCUMENTOS:oWSDOCUMENTO  := MANIFESTACAODESTINATARIO_ARRAYOFBAIXARDOCUMENTO():New()

          If (Len(aChaves) - nQtdChv) < 5
            nXAux := 1
            For nX:= nQtdChv+1 to Len(aChaves)
              aadd(oWs:oWSDOCUMENTOS:oWSDOCUMENTO:oWSBAIXARDOCUMENTO,MANIFESTACAODESTINATARIO_BAIXARDOCUMENTO():New())
              oWs:oWSDOCUMENTOS:oWSDOCUMENTO:oWSBAIXARDOCUMENTO[nXAux]:CCHAVE := aChaves[nX]
              nXAux++
              nQtdChv++
            Next nX
            If oWs:BAIXARXMLDOCUMENTOS()
              If Type ("oWs:OWSBAIXARXMLDOCUMENTOSRESULT:OWSDOCUMENTORET:OWSBAIXARDOCUMENTORET") <> "U"
                If Type ("oWs:OWSBAIXARXMLDOCUMENTOSRESULT:OWSDOCUMENTORET:OWSBAIXARDOCUMENTORET") == "A"
                  aXmlRet := oWs:OWSBAIXARXMLDOCUMENTOSRESULT:OWSDOCUMENTORET:OWSBAIXARDOCUMENTORET
                Else
                  aXmlRet := {oWs:OWSBAIXARXMLDOCUMENTOSRESULT:OWSDOCUMENTORET:OWSBAIXARDOCUMENTORET}
                EndIf
              EndIF

              Processa({|| lRet := VerifProces(oRet,aXmlRet,aParam,@cAviso)},"Processando","Aguarde, exportando arquivos",.T.)

            EndIf
          Else
            For nY:= 1 to 5
              aadd(oWs:oWSDOCUMENTOS:oWSDOCUMENTO:oWSBAIXARDOCUMENTO,MANIFESTACAODESTINATARIO_BAIXARDOCUMENTO():New())
              oWs:oWSDOCUMENTOS:oWSDOCUMENTO:oWSBAIXARDOCUMENTO[nY]:CCHAVE := aChaves[nY+nQtdChv]
            Next nY
            nQtdChv := nQtdChv + 5

            If oWs:BAIXARXMLDOCUMENTOS()
              If Type ("oWs:OWSBAIXARXMLDOCUMENTOSRESULT:OWSDOCUMENTORET:OWSBAIXARDOCUMENTORET") <> "U"
                If Type ("oWs:OWSBAIXARXMLDOCUMENTOSRESULT:OWSDOCUMENTORET:OWSBAIXARDOCUMENTORET") == "A"
                  aXmlRet := oWs:OWSBAIXARXMLDOCUMENTOSRESULT:OWSDOCUMENTORET:OWSBAIXARDOCUMENTORET
                Else
                  aXmlRet := {oWs:OWSBAIXARXMLDOCUMENTOSRESULT:OWSDOCUMENTORET:OWSBAIXARDOCUMENTORET}
                EndIf
              EndIF
              Processa({|| lRet := VerifProces(oRet,aXmlRet,aParam,@cAviso)},"Processando","Aguarde, exportando arquivos",.T.)
            EndIf
          EndIf
        EndDo

  EndIf

Return

//-----------------------------------------------------------------------
/*/{Protheus.doc} VerifProces() 

Função auxiliar para o processamento da exportação do arquivo zip

@author Natalia Sartori
@since 04.07.2012
@version 1.00

@param oRet, aXmlRet, aParam, cAviso 

@return lRet - Se o arquivo foi gerado ou não
/*/
//----------------------------------------------------------------------- 
Static Function VerifProces(oRet,aXmlRet,aParam,cAviso)

  Local nZ 		:= 0
  Local lRet 		:= .F.

  ProcRegua(Len(aXmlRet))

  For nZ:=1 to Len(aXmlRet)
    IncProc()
    oRet := aXmlRet[nZ]
    If GeraArq(aParam,oRet)
      lRet := .T.
      cAviso += SubStr(oRet:CCHAVE,23,3)+ "    "+SubStr(oRet:CCHAVE,26,9) + CRLF
    EndIf
  Next

Return(lRet)

//-----------------------------------------------------------------------
/*/{Protheus.doc} GeraArq() 

Função que exporta os arquivos conforme o retorno do metodo

@author Natalia Sartori
@since 04.07.2012
@version 1.00

@param aParam 	- Parametros do parambox
       oRetorno - Retorno do metodo com o resultado da solicitação
       
@return lRet	- Arquivo gerado ou não       
/*/
//----------------------------------------------------------------------- 
Static Function GeraArq(aParam,oRetorno)

  Local cDestino 	:= ""
  Local cDrive   	:= ""
  Local cNfeProt  	:= ""
  Local cNfe			:= ""
  Local cNfeProc	:= ""
  Local cChave		:= ""
  Local cNfeProtzi	:= ""
  Local cNfeZip		:= ""
  Local cNfeProcZi	:= ""
  Local cExportar	:= aParam[5]	// 1=Separado ou 2=Unificado

  Local lRet		:= .F.

  Local nHandle	:= 0
  Local _cLocXml := "\importadorxml\"

  oRet := oRetorno

  SplitPath(aParam[04],@cDrive,@cDestino,"","")
  cDestino := cDrive+cDestino


  If Type ("oRet:CCHAVE") <> "U" .and. !Empty(oRet:CCHAVE)
    cChave	:= oRet:CCHAVE
  EndIf
  If Type ("oRet:CCHVSTATUS") <> "U" .and. (!Empty(oRet:CCHVSTATUS) .and. ('138' $ oRet:CCHVSTATUS .or. '140' $ oRet:CCHVSTATUS .or. '656' $ oRet:CCHVSTATUS))   //140: Download disponibilizado - 656:Consumo indevido (tras dos campos da SPED156)
  
    If Type ("oRet:CNFEPROTZIP") <> "U" .and. !Empty(oRet:CNFEPROTZIP)
      cNfeProtZi	:= oRet:CNFEPROTZIP
    EndIf
    If Type ("oRet:CNFEZIP") <> "U" .and. !Empty(oRet:CNFEZIP)
      cNfeZip	:= oRet:CNFEZIP
    EndIf
    If Type ("oRet:CNFEPROCZIP") <> "U" .and. !Empty(oRet:CNFEPROCZIP)
      cNfeProcZi	:= oRet:CNFEPROCZIP
    EndIf

  EndIf

  If !Empty(cChave)

		If !Empty( cNfeProcZi ) .AND. !'<nfeProc' $ cNfeProcZi
			nHandle  := FCreate( cDestino+cChave+"-"+"nfeProc.gz" )
			If nHandle > 0
				FWrite( nHandle, cNfeProcZi )
				FClose( nHandle )
				lRet   := .T.
				GzDecomp(_cLocXml+cChave+"-"+"nfeProc.gz", _cLocXml )				
				frename(cDestino+cChave+"-"+"nfeProc" , cDestino+"inn\"+cChave+"-"+"nfeProc.xml" )
				
				//__CopyFile(cDestino+cChave+"-"+"nfeProc.xml" , cDestino+"inn\"+cChave+"-"+"nfeProc.xml"  )

				DbSelectArea("C00")
				Dbsetorder(1)
				Dbgotop()
				If DbSeek(xFilial("C00")+cChave,.F.)
					RecLock("C00",.F.)
						C00->C00_EXPXML := "S"
					MsUnlock("C00")
				EndIf

			EndIf
		EndIf



/*
    If cExportar == "1"	// Separado
  
      If !Empty(cNfeProtZi) .AND. !'<protNFe' $ cNfeProtZi
        cNfeProt := Decode64(cNfeProtZi)
        cNfeProt := Decode64(cNfeProtZi)
        nHandle  := FCreate(cDestino+cChave+"-"+"protNFe.zip")
        If nHandle > 0
          FWrite ( nHandle, cNfeProt)
          FClose(nHandle)
          lRet	:= .T.
        EndIf
      EndIf

		//Inserido este If pois para os Estados diferentes de RS,o retorno não vem zipado e não é necessãrio dar o decode64
      If '<protNFe' $ cNfeProtZi
        nHandle  := FCreate(cDestino+cChave+"-"+"protNFe.xml")
        If nHandle > 0
          FWrite ( nHandle, cNfeProtZi)
          FClose(nHandle)
          lRet	:= .T.
        EndIf
      EndIf

      If !Empty(cNfeZip) .AND. !'<NFe' $ cNfeZip
        cNfe := Decode64(cNfeZip)
        cNfe := Decode64(cNfeZip)
        nHandle  := FCreate(cDestino+cChave+"-"+"NFeZip.zip")
        If nHandle > 0
          FWrite ( nHandle, cNfe)
          FClose(nHandle)
          lRet	:= .T.
        EndIf
      EndIf

		//Inserido este If pois para os Estados diferentes de RS,o retorno não vem zipado e não é necesserio dar o decode64
      If '<NFe' $ cNfeZip
        nHandle  := FCreate(cDestino+cChave+"-"+"XmlNFe.xml")
        If nHandle > 0
          FWrite ( nHandle, cNfeZip)
          FClose(nHandle)
          lRet	:= .T.
        EndIf
      EndIf

    Endif

    If cExportar == "2"	// Unificado

      if '<protNFe' $ cNfeProtZi .And. '<NFe' $ cNfeZip
        nHandle  := FCreate(cDestino+cChave+"-"+"nfeProc.xml")
        nAt	:= At(' versao="', cNfeZip )
        cVersao := SubStr(cNfeZip,nAt,14)
        If nHandle > 0
          FWrite ( nHandle, '<nfeProc'+cVersao+' xmlns="http://www.portalfiscal.inf.br/nfe">'+cNfeZip+cNfeProtZi+'</nfeProc>')
          FClose(nHandle)
          lRet	:= .T.
        EndIf
      endif

      If !Empty(cNfeProcZi)
        cNfeProc := Decode64(cNfeProcZi)
        cNfeProc := Decode64(cNfeProcZi)
        nHandle  := FCreate(cDestino+cChave+"-"+"procNFe.zip")
        If nHandle > 0
          FWrite ( nHandle, cNfeProc)
          FClose(nHandle)
          lRet	:= .T.
        EndIf
      EndIf

    Endif
*/
  EndIf

Return lRet
