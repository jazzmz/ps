/*
#4106 Бакланов А.В.
Смена статуса поступившего п/п с перечислением зарплаты на аннулированный
и добавление информации в класс для формирования проводок перечисления з/п
*/

{bislogin.i}
{globals.i}
{tmprecid.def}

{intrface.get xclass}

DEFINE VAR Doc_YN AS LOGICAL NO-UNDO INIT NO.

FOR EACH tmprecid,
    FIRST op WHERE RECID(op) EQ tmprecid.id.

if op.user-id eq "BNK-CL" then do:
	message "Вы уверены, что выбрали правильный документ? Содержание выбранного: " op.details view-as alert-box buttons yes-no SET Doc_YN.
	IF Doc_YN THEN DO:

	create code.
		code.class	 = "PIR4106".
		code.parent	 = "PIR4106".
		code.code	 = string(op.op).
		code.val	 = string(op-date).
	find first op-entry where op-entry.op = op.op no-lock no-error.
	if available op-entry then do: 
		code.description[1] = op-entry.acct-db.
		code.name = "Документ №" + string(op.doc-num) + ", сумма: " + string(op-entry.amt-rub) + "р.".
		end.
        
	op.op-status = "А".
	op.op-date = ?.
        
	end.
end.
END.

MESSAGE "Готово!" VIEW-AS ALERT-BOX.

{intrface.del}
