#include "rwmake.ch" 

 // calcula novo codigo de cliente na inclusao
USER FUNCTION VIN001()

nORDEM := dbsetorder()
dbsetorder()
nRECATU := recno()
dbgoto(lastrec())
cCODW := strzero(val(A1_COD)+1,5)
dbgoto(nRECATU)
dbsetorder(nORDEM)
m->a1_cod := cCODW

return(cCODW)