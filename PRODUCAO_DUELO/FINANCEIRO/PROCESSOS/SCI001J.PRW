#Include "RwMake.Ch"
#Include "TopConn.Ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSCI001J   บ Autor ณ Cleiton Campos     บ Data ณ  12/09/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Gera arquivo para pessoa juridica                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณArguto                                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ Alteracoes                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      ณ Descricao                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

USER FUNCTION SCI001J(nHdl,_cEol,MV_PAR01,MV_PAR02)

LOCAL _cLin		:= ""
LOCAL _cCpo		:= ""
LOCAL _cQuery	:= ""
Local _lValid   := .F.
Local _cData    := ""

ProcRegua(1)

_cQuery := "SELECT "
_cQuery += "       'TPREG'    = 'J'," // Campo 01. Nao negativa clientes
_cQuery += "       'CNPJ'     = A1_CGC,"          // Campo 02
_cQuery += "       'NOME'     = REPLACE(SA1.A1_NOME,',',''),"         // Campo 03
_cQuery += "       'FANTASIA' = A1_NREDUZ,"       // Campo 04
_cQuery += "       'NTZ_END'  = 'D',"             // Campo 05
_cQuery += "       'ENDERECO' = REPLACE(A1_END,',',''),"          // Campo 06
_cQuery += "       'CIDADE'   = LEFT(A1_MUN,30)," // Campo 07
_cQuery += "       'UF'       = A1_EST,"          // Campo 08
_cQuery += "       'CEP'      = A1_CEP,"          // Campo 09
_cQuery += "       'DDD_TEL'  = LEFT(A1_TEL,2),"  // Campo 10
_cQuery += "       'TELEFONE' = SUBSTRING(A1_TEL,3,10)," // Campo 11
_cQuery += "       'DDD_FAX'  = LEFT(A1_FAX,2),"         // Campo 12
_cQuery += "       'FAX'      = SUBSTRING(A1_FAX,3,10)," // Campo 13
_cQuery += "       'EMAIL'    = SA1.A1_EMAIL,"           // Campo 14
_cQuery += "       'DATCAD'   = SUBSTRING(A1_DTCAD,5,2)+SUBSTRING(A1_DTCAD,1,4)," // Campo 15
_cQuery += "       'TITULO'   = REPLACE(SE1.E1_NUM,',','')," // Campo 16
_cQuery += "       'TIPODOC'  = CASE "        // Campo 17
_cQuery += "                     WHEN E1_TIPO   =  'NF' THEN 'N'"
_cQuery += "                     WHEN E1_TIPO   =  'CH' THEN 'C'"
_cQuery += "                     WHEN E1_TIPO   =  'FT' THEN 'F'"
_cQuery += "                     WHEN E1_TIPO   =  'DP' THEN 'D'"
_cQuery += "                     WHEN E1_NUMBOR <> ''   THEN 'B'"
_cQuery += "                    END, "
_cQuery += "       'MOEDA'   = 'R$  ',"
_cQuery += "       'VALOR'   = CONVERT(INT,CONVERT(MONEY,E1_VALOR*100)) - "                 // Campo 19 e 20
_cQuery += "                    (SELECT ISNULL(CONVERT(INT,CONVERT(MONEY,SUM(E5_VALOR*100))),0)"
_cQuery += "                     FROM SE5010 SE5"
_cQuery += "                     WHERE SE5.E5_NUMERO = SE1.E1_NUM"
_cQuery += "                     AND   SE5.E5_PARCELA = SE1.E1_PARCELA"
_cQuery += "                     AND   SE5.E5_CLIFOR = SE1.E1_CLIENTE"
_cQuery += "                     AND   SE5.E5_LOJA   = SE1.E1_LOJA"
_cQuery += "                     AND   SE5.E5_MOTBX <> 'NOR' "
_cQuery += "                     AND   SE5.D_E_L_E_T_ <> '*'),"
_cQuery += "       'VLRPAGO' = CONVERT(INT,CONVERT(MONEY,(SE1.E1_VALLIQ*100)))," // Campo 21 e 22
_cQuery += "       'DTVENDA' = SE1.E1_EMISSAO,"                 // Campo 23
_cQuery += "       'DTVECTO' = SE1.E1_VENCTO,"                  // Campo 24
_cQuery += "       'DTBAIXA' = CASE"                            // Campo 25
_cQuery += "                    WHEN SE1.E1_EMISSAO = SE1.E1_VENCTO AND SE1.E1_BAIXA <> '' THEN E1_VENCTO "
_cQuery += "                    ELSE SE1.E1_BAIXA "
_cQuery += "                   END "
_cQuery += " FROM  " + RetSqlName("SA1") + " SA1, "
_cQuery +=             RetSqlName("SE1") + " SE1  "
_cQuery	+= " WHERE SE1.E1_VENCTO  <= '" + DtoS(M->ddatabase) + "'"
_cQuery	+= " AND   SE1.E1_STATUS = 'B'"
_cQuery += " AND   SE1.E1_EMISSAO BETWEEN '"+ DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "' "
_cQuery	+= " AND   SA1.A1_COD  = SE1.E1_CLIENTE "
_cQuery += " AND   SA1.A1_LOJA = SE1.E1_LOJA    "
_cQuery += " AND   LEN(SA1.A1_CGC) = 14         "
_cQuery += " AND   SA1.D_E_L_E_T_ <> '*'        "
_cQuery += " AND   SE1.D_E_L_E_T_ <> '*'        "

TcQuery _cQuery New Alias "REGSCIJ"

IncProc("Totalizando dados de clientes...")
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Atualiza array                                                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("REGSCIJ")
dbGoTop()
WHILE !EOF()
	
	_cLin		:= SPACE(387)
	
	_lValid := REGSCIJ->VALOR > 0 .And.  REGSCIJ->DTVECTO < DtoS(M->dDataBase)
	
	If _lValid
		
		// Campo 01
		_cCpo		:= PADR(REGSCIJ->TPREG,01)					// Tipo do registro
		_cLin		:= STUFF(_cLin,01,01,_cCpo)
		
		// Campo 02
		_cCpo		:= PADR(REGSCIJ->CNPJ,14)					// Numero do CNPJ
		_cLin		:= STUFF(_cLin,02,15,_cCpo)
		
		// Campo 03
		_cCpo		:= PADR(REGSCIJ->NOME,55)					// Razao social
		_cLin		:= STUFF(_cLin,16,70,_cCpo)
		
		// Campo 04
		_cCpo		:= PADR(REGSCIJ->FANTASIA,55)				// Nome fantasia
		_cLin		:= STUFF(_cLin,71,125,_cCpo)
		
		// Campo 05
		_cCpo		:= PADR(REGSCIJ->NTZ_END,1)				   	// Natureza do endereco
		_cLin		:= STUFF(_cLin,126,126,_cCpo)
		
		// Campo 06
		_cCpo		:= PADR(REGSCIJ->ENDERECO,70)			   	// Endereco
		_cLin		:= STUFF(_cLin,127,196,_cCpo)
		
		// Campo 07
		_cCpo		:= PADR(REGSCIJ->CIDADE,30)			       	// Cidade
		_cLin		:= STUFF(_cLin,197,226,_cCpo)
		
		// Campo 08
		_cCpo		:= PADR(REGSCIJ->UF,2)			       		// UF
		_cLin		:= STUFF(_cLin,227,228,_cCpo)
		
		// Campo 09
		_cCpo		:= PADR(REGSCIJ->CEP,8)			            // CEP
		_cLin		:= STUFF(_cLin,229,236,_cCpo)
		
		// Campo 10
		_cCpo		:= PADR("",4)			        // DDD do telefone
		_cLin		:= STUFF(_cLin,237,240,_cCpo)
		
		// Campo 11
		_cCpo		:= PADR("",10)			    // Numero do telefone
		_cLin		:= STUFF(_cLin,241,250,_cCpo)
		
		// Campo 12
		_cCpo		:= PADR("",4)			        // DDD do fax
		_cLin		:= STUFF(_cLin,251,254,_cCpo)
		
		// Campo 13
		_cCpo		:= PADR("",10)			     	// Numero do fax
		_cLin		:= STUFF(_cLin,255,264,_cCpo)
		
		// Campo 14
		_cCpo		:= PADR("",50)			        // E-MAIL
		_cLin		:= STUFF(_cLin,265,314,_cCpo)
		
		// Campo 15
		_cCpo		:= PADR(REGSCIJ->DATCAD,6)			        // Cliente desde
		_cLin		:= STUFF(_cLin,315,320,_cCpo)
		
		// Campo 16
		_cCpo		:= PADR(REGSCIJ->TITULO,12)			        // Identificador da transacao
		_cLin		:= STUFF(_cLin,321,332,_cCpo)
		
		// Campo 17
		_cCpo		:= PADR(REGSCIJ->TIPODOC,1)			        // Tipo de documento da transacao
		_cLin		:= STUFF(_cLin,333,333,_cCpo)
		
		// Campo 18
		_cCpo		:= PADR(REGSCIJ->MOEDA,4)			        // Moeda
		_cLin		:= STUFF(_cLin,334,337,_cCpo)
		
		// Campos 19 e 20
		_cCpo		:= PADR(STRZERO(REGSCIJ->VALOR,13),13)	    // Valor inteiro da transacao
		_cLin		:= STUFF(_cLin,338,350,_cCpo)
		
		// Campo 21 e 22
		_cCpo		:= PADR(STRZERO(REGSCIJ->VLRPAGO,13),13)	// Valor inteiro pago
		_cLin		:= STUFF(_cLin,351,363,_cCpo)
		
		// Campo 23
		_cData      := SubStr(REGSCIJ->DTVENDA,7,2) + SubStr(REGSCIJ->DTVENDA,5,2) + SubStr(REGSCIJ->DTVENDA,1,4)
		_cCpo		:= PADR(AllTrim(_cData),8)    // Data da venda
		_cLin		:= STUFF(_cLin,364,371,_cCpo)
		
		// Campo 24
		_cData      := SubStr(REGSCIJ->DTVECTO,7,2) + SubStr(REGSCIJ->DTVECTO,5,2) + SubStr(REGSCIJ->DTVECTO,1,4)
		_cCpo		:= PADR(AllTrim(_cData),8)	    // Data do vencimento
		_cLin		:= STUFF(_cLin,372,379,_cCpo)
		
		// Campo 25
		_cData      := SubStr(REGSCIJ->DTBAIXA,7,2) + SubStr(REGSCIJ->DTBAIXA,5,2) + SubStr(REGSCIJ->DTBAIXA,1,4)
		_cCpo		:= PADR(AllTrim(_cData),8)	    // Data da baixa
		_cLin		:= STUFF(_cLin,380,387,_cCpo)
		
		_cLin		+= _cEol
		
		IncProc("Gravando registro! "+Alltrim(REGSCIJ->TITULO))
		
		IF fWrite(nHdl,_cLin,Len(_cLin)) != LEN(_cLin)
			_cMensagem	:= "Ocorreu um erro na gravacao do arquivo. "
			HELP("",1,PROCNAME(),,_cMensagem,1,0)
		ENDIF
	EndIf
	dbSelectArea("REGSCIJ")
	dbSkip()
	
ENDDO

dbCloseArea("REGSCIJ")

RETURN
