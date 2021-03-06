#Include "RwMake.Ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SCI001    � Autor � Cleiton Campos     � Data �  12/09/02   ���
�������������������������������������������������������������������������͹��
���Descricao � Informacoes para o SCI/EQUIFAX                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Arguto                                                      ���
�������������������������������������������������������������������������͹��
���          � Alteracoes                                                 ���
�������������������������������������������������������������������������͹��
���Data      � Descricao                                                  ���
�������������������������������������������������������������������������͹��
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                           

USER FUNCTION SCI001()
//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis                                             �
//�����������������������������������������������������������������������
LOCAL nHdl
LOCAL _cEol
Private _cPerg   := "SCIREM    " 

ValidPerg()

Pergunte(_cPerg,.T.)


PROCESSA({ |lEnd| SCI001PROC(@nHdl,@_cEol)},"Criando o arquivo...")
PROCESSA({ |lEnd| U_SCI001J(nHdl,_cEol,MV_PAR01,MV_PAR02)},"Gerando registros pessoa juridica...")
PROCESSA({ |lEnd| U_SCI001F(nHdl,_cEol,MV_PAR01,MV_PAR02)},"Gerando registros pessoa fisica...")

fClose(nHdl)

RETURN

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ARGM001PRO� Autor � Cleiton Campos     � Data �  18/04/02   ���
�������������������������������������������������������������������������͹��
���Descricao � Geracao de arquivo para envio ao SINTEGRA                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Arguto                                                      ���
�������������������������������������������������������������������������͹��
���          � Alteracoes                                                 ���
�������������������������������������������������������������������������͹��
���Data      � Descricao                                                  ���
�������������������������������������������������������������������������͹��
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
STATIC FUNCTION SCI001PROC(_pnHdl,_pcEol)
//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis                                             �
//�����������������������������������������������������������������������
LOCAL _cArqDest		:= ""
LOCAL _cMensagem	:= ""
LOCAL cArqTxt		:= ""

ProcRegua(1)
//���������������������������������������������������������������������Ŀ
//� Monta nome do arquivo a ser gerado                                  �
//�����������������������������������������������������������������������
_cArqDest	:= "SCI"
_cArqDest	+= "_"
_cArqDest	+= SUBSTR(DTOS(dDatabase),7,2)			// dia
_cArqDest	+= SUBSTR(DTOS(dDatabase),5,2)			// mes
_cArqDest	+= SUBSTR(DTOS(dDatabase),1,4)			// ano
_cArqDest	+= LEFT(TIME(),2)
_cArqDest	+= SUBSTR(TIME(),4,2)
_cArqDest	+= RIGHT(TIME(),2)+".TXT"

//���������������������������������������������������������������������Ŀ
//� Cria o arquivo texto                                                �
//�����������������������������������������������������������������������
cArqTxt		:= "\SCI\" + _cArqDest
_pnHdl		:= fCreate(cArqTxt)
_pcEol		:= CHR(13)+CHR(10)

IncProc("Abrindo arquivo: "+cArqTxt)

IF _pnHdl == -1
	_cMensagem	:= "O arquivo de nome "
	_cMensagem	+= cArqTxt
	_cMensagem	+= " nao pode ser gerado!"+CHR(10)
	_cMensagem	+= "Verifique os parametros."
	HELP("",1,PROCNAME(),,_cMensagem,1,0)
ENDIF

RETURN
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �VALIDPERG � Autor � AP5 IDE            � Data �  21/08/00   ���
�������������������������������������������������������������������������͹��
���Descri��o � Verifica a existencia das perguntas criando-as caso seja   ���
���          � necessario (caso nao existam).                             ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function ValidPerg

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
_cPerg := "SCIREM    "

// Grupo/Ordem/PerguntaPor/PerguntaEsp/PerguntaIng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/PerguntaEsp1/PerguntaIng1/Cnt01/Var02/Def02/PerguntaEsp2/PerguntaIng2/Cnt02/Var03/Def03/PerguntaEsp3/PerguntaIng3/Cnt03/Var04/Def04/PerguntaEsp4/PerguntaIng4/Cnt04/Var05/Def05/PerguntaEsp5/PerguntaIng5/Cnt05/X1_F3/X1_G
//aAdd(aRegs,{_cPerg,"01","DIRETORIO DO ARQUIVO    ?","","","mv_ch1","C",8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})

aAdd(aRegs,{_cPerg,"01","Da data    ","","","mv_ch1","D",8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{_cPerg,"02","Ate a Data ","","","mv_ch2","D",8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(_cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to Len(aRegs[i])
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i][j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return