{pirsavelog.p}
{intrface.get xclass}


DEF INPUT PARAM in-value AS CHARA NO-UNDO.

DEF VAR oSysClass AS TSysClass NO-UNDO.

DEF VAR out_file_name AS CHAR. 
DEF VAR vDate AS DATE FORMAT "99/99/9999" LABEL "Введите дату" INIT TODAY NO-UNDO.
DEF VAR InParam AS CHAR NO-UNDO.

/****************************************
 * Перечень счетов перенесен            *
 * из параметра запуска транзакции      *
 * в классификатор PirVipForm=>AcctList *
 ****************************************
 *
 * Автор: Маслов Д. А. Maslov D. A.
 * Дата создания: 21.06.11
 * Заявка: #724
 *
 ****************************************/

oSysClass = new TSysClass().
	InParam = oSysClass:getCodeValue("PirVipForm","AcctList","*").
DELETE OBJECT oSysClass.


out_file_name = "/home/bis/quit41d/imp-exp/doc/simport" . 
RUN getdate.p("УКАЖИТЕ ДАТУ ПОИСКА ПРОВОДОК", OUTPUT vDate).



{setdest.i &cols = 110}

OUTPUT TO VALUE(out_file_name).

for each op-entry where op-entry.op-date eq vDate and
                          (can-do(InParam,op-entry.acct-db) or
                           can-do(InParam,op-entry.acct-cr))
                    no-lock  :
    for each op where op.op-date eq vDate and
                      op.op eq op-entry.op no-lock:
        put unformatted
        "RUR   " 
        STRING(op.op-date,"99/99/9999") at 7
        FILL(" ",11 - length(op.doc-num)) + op.doc-num at 17
        FILL(" ",26 - length(op-entry.acct-db)) + op-entry.acct-db at 28 
        FILL(" ",26 - length(op-entry.acct-cr)) + op-entry.acct-cr at 54  
        string(op-entry.amt-rub,"->>>>>>>>>>>>9.99") at 80
        replace(op.details,"~n"," ") at 98 skip.
    end.          
           
end.    

OUTPUT CLOSE.
OS-COMMAND silent VALUE("ux2dos") VALUE(out_file_name).
MESSAGE "Данные успешно экспортированы!" VIEW-AS ALERT-BOX.
/*
{preview.i}   

MESSAGE
				"Экспортировать данные?"
VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE continue-ok AS LOGICAL .

IF continue-ok THEN
DO:
  OUTPUT TO VALUE(out_file_name).

{setdest.i &cols = 110}
for each op-entry where op-entry.op-date eq vDate and
                          (can-do(InParam,op-entry.acct-db) or
                           can-do(InParam,op-entry.acct-cr))
                    no-lock  :
    for each op where op.op-date eq vDate and
                      op.op eq op-entry.op no-lock:
        put unformatted
        "RUR   " 
        STRING(op.op-date,"99/99/9999") at 7
        FILL(" ",11 - length(op.doc-num)) + op.doc-num at 17
        FILL(" ",26 - length(op-entry.acct-db)) + op-entry.acct-db at 28 
        FILL(" ",26 - length(op-entry.acct-cr)) + op-entry.acct-cr at 54  
        string(op-entry.amt-rub,"->>>>>>>>>>>>9.99") at 80
        replace(op.details,"~n"," ") at 98 skip.
    end.          
end.      
.
  OUTPUT CLOSE.
OS-COMMAND silent VALUE("ux2dos") VALUE(out_file_name).
MESSAGE "Данные успешно экспортированы!" VIEW-AS ALERT-BOX.
END.
*/
{intrface.del}