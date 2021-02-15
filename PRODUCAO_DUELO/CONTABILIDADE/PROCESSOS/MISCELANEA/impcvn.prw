#include "rwmake.ch"
#include "topconn.ch"

User Function impcvn()

IF SM0->M0_CODIGO $ '04'
	IF msgyesno("Importa Plano referencial?")
		Processa( {|| impok() } )
	Endif
Endif

return nil

//////////////////////////////////////////////////////////////
Static Function impok()

aStru :={}
aadd(aStru , {"_reg"      ,"C" ,500,00})

_cArqtmp := "\DATA\CVN2010" + GetDbExtension()
_cArqImp := "\DATA\REF2010.TXT"

dbcreate(_cArqtmp,aStru)

dbUseArea(.t.,,_cArqtmp,"IMPCTA",.f.)
dbSelectArea("IMPCTA")
zap

MsgRun("Importando registros..","",{|| u_append(_cArqImp)  })

dbSelectArea("IMPCTA")
dbgotop()

procregua(reccount())

Do While ! eof()
	
	incproc()
	
	if recno() > 1
		
		_cReg := alltrim(_reg)
		_cReg := strtran(_creg,";","','")
		_cReg := "{'"+_creg+"'}"
		_aReg := &(_cReg)
		
		//alert(_creg)
		//alert(len(_areg))
		//for i :=1 to len(_aReg)
		//	alert(_aReg[i])
		//Next
		//return nil
		
		cCvnFilial := xfilial('CVN')
		cCvnCodpla := "001"
		cCvnDscpla := "PLANO REFERENCIAL 2010"
		
		if !empty(_areg[3])
			dCvnDtvigi := ctod(substr(_areg[3],1,2)+"/"+substr(_areg[3],3,2)+"/"+substr(_areg[3],5,4))
		Else
			dCvnDtvigi := ctod("31/12/2020")
		Endif
		
		if !empty(_areg[4])
			dCvnDtvigf := ctod(substr(_areg[4],1,2)+"/"+substr(_areg[4],3,2)+"/"+substr(_areg[4],5,4))
		Else
			dCvnDtvigf := ctod("31/12/2020")
		Endif
		
		
		cCvnEntref := "10"
		cCvnLinha  := strzero(recno()-1,3)
		cCvnCtaref := _areg[1]
		cCvnDsccta := upper(_areg[2])
		cCvnTputil := "A"
		
		
		//////////////////////////////////////////////////
		///////////// Gravar/Atualizar Dados /////////////
		//////////////////////////////////////////////////
		
		DbSelectArea('CVN')
		DbSetOrder(1) // verificar se o indice utilizado esta correto
		Dbgotop()
		
		_lInclui := .t.
		
		// Alterar a chave de pesquisa de acordo com a tabela
		
		DbSeek(cCvnFilial+cCvnCodpla+cCvnLinha,.f.)
		
		If !Eof()
			_lInclui := .f.
		Endif
		
		If reclock('CVN',_lInclui) // .T. - Inclui / .F. - Altera
			
			CVN->CVN_FILIAL := cCvnFilial
			CVN->CVN_CODPLA := cCvnCodpla
			CVN->CVN_DSCPLA := cCvnDscpla
			CVN->CVN_DTVIGI := dCvnDtvigi
			CVN->CVN_DTVIGF := dCvnDtvigf
			CVN->CVN_ENTREF := cCvnEntref
			CVN->CVN_LINHA  := cCvnLinha
			CVN->CVN_CTAREF := cCvnCtaref
			CVN->CVN_DSCCTA := cCvnDsccta
			CVN->CVN_TPUTIL := cCvnTputil
			
			msunlock()
			
		Endif
		
		//////////////////////////////////////////////////
		//////////////////////////////////////////////////
		
	Endif
	
	dbSelectArea("IMPCTA")
	dbskip()
	
Enddo


dbSelectArea("IMPCTA")
dbclosearea()

return nil


///////////////////////////////
user function append(_cArqImp)
//////////////////////////////
dbSelectArea("IMPCTA")

append from &(_cArqImp) sdf

Return nil

