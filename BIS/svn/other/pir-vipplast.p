{pirsavelog.p}


DEF INPUT PARAM InParam AS CHAR NO-UNDO.
DEF VAR out_file_name AS CHAR. 
DEF VAR vDate AS DATE FORMAT "99/99/9999" LABEL "Введите дату" INIT TODAY NO-UNDO.

out_file_name = "/home/bis/quit41d/imp-exp/plast/out/plastik.txt" . 
RUN getdate.p("УКАЖИТЕ ДАТУ ПОИСКА ПРОВОДОК", OUTPUT vDate).

{setdest.i &cols = 200}

OUTPUT TO VALUE(out_file_name).
put unformatted
        "memdos" skip.
for each op-entry where op-entry.op-date eq vDate and
                          (can-do(InParam,op-entry.acct-db) or
                           can-do(InParam,op-entry.acct-cr)) and
                          not can-do("202*",op-entry.acct-db)
                          no-lock  :
    for each op where op.op-date eq vDate and
                      op.op eq op-entry.op and
                      op.user-id begins "SAF"
                      no-lock:
        put unformatted
        "999'"
        STRING(op.op-date,"99.99.9999") "''"
        op-entry.acct-db "'".
        case substr(op-entry.acct-db,6,3) :
           WHEN "810"  THEN put unformatted "RUR'".
					 WHEN "840"  THEN put unformatted "DOL'".
					 WHEN "978"  THEN put unformatted "EUR'".
        END CASE.
        put unformatted
        if op-entry.acct-cr begins "61304" then "70107810000001720509" else op-entry.acct-cr
        "'".
        case substr(op-entry.acct-db,6,3) :
           WHEN "810"  THEN put unformatted "RUR'".
					 WHEN "840"  THEN put unformatted "DOL'".
					 WHEN "978"  THEN put unformatted "EUR'".
        END CASE.
        put unformatted
        replace(trim(string(op-entry.amt-rub,"->>>>>>>>>>>>9.99")),".",",") "'"
        replace(op.details,"~n"," ") "'"
        "''''''''0'0''"
        skip.
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
        STRING(op.op-date,"99/99/9999")","
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