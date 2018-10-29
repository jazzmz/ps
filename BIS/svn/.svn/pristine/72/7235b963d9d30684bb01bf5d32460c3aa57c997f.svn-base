/*По заявке 1292, процедура проставления референса для документов загруженых транзакцией pireval
Автор: Красков А.С.
Заказчик: Кузьмина Н.В.*/
{globals.i}
{tmprecid.def}
{intrface.get xclass}
def var opdate as DATE NO-UNDO.
def var cparam as CHAR NO-UNDO.
def var ref as char format "x(6)" NO-UNDO.
def var summ as char format "x(15)" Label "‘“ЊЊЂ €Ќ‚Ђ‹ћ’›" NO-UNDO.
def var count as INT INIT 0 NO-UNDO.
def var apply-update as logical INIT no NO-UNDO.
def var findone as logical INIT no NO-UNDO.
def var ref_signs as char no-undo.
DEFINE TEMP-TABLE op-ref NO-UNDO
   FIELD op-id     like tmprecid.id
   FIELD ref       AS char
.


cparam = "@REF".
/*find first tmprecid NO-LOCK NO-ERROR.
find first op where RECID(op) = tmprecid.id NO-LOCK NO-ERROR.*
opdate = op.op-date.                                          */
opdate = gend-date.

for each op where op.op-date = opdate
	      and can-do("pireval*",op.op-kind) 
	      and can-do("*" + cparam + "*",op.details)
	      and op.op-status < CHR(251)  NO-LOCK,   
	first op-entry where op-entry.op = op.op NO-LOCK:

	        findone = yes.
		summ = TRIM(STRING(op-entry.amt-cur,">>>,>>>,>>>,>>9.99")).
		display op-entry.acct-db LABEL "„ҐЎҐв" format "x(25)" op-entry.acct-cr LABEL "Љђ…„€’" format "x(25)" summ.
		ref = "".
	PAUSE(0).
		set ref LABEL "ђҐдҐаҐ­б".
	PAUSE(0).
		if ref <> ""  then 
			do:
			  count = count + 1.
			  create op-ref.
			  assign
				op-ref.op-id = RECID(op)
			 	op-ref.ref = ref.
			end.

END.

if NOT findone then message "ЌҐ ­ ©¤Ґ­® ¤®Єг¬Ґ­в®ў ¤«п ўў®¤  аҐдҐаҐ­б " VIEW-AS ALERT-BOX.

if count > 0 then MESSAGE 
			"€§¬Ґ­Ёвм аҐдҐаҐ­б ў " count " ¤®Єг¬Ґ­в е?"  SKIP(1)
		VIEW-AS ALERT-BOX /*QUESTION*/ BUTTONS YES-NO TITLE "‚Ќ€ЊЂЌ€…!" UPDATE apply-update.	

if apply-update then 
do:
   for each op-ref,
       first op where RECID(op) = op-ref.op-id:
         op.details = REPLACE(op.details,cparam,op-ref.ref).
          ref_signs = GetXattrValueEx("op", string(op.op), "op-reference","").    
	  ref_signs = REPLACE(ref_signs,cparam,op-ref.ref).
          UpdateSignsEx('opb',STRING(op.op),"op-reference",ref_signs).   

       end.
end.

EMPTY TEMP-TABLE op-ref.

{intrface.del}