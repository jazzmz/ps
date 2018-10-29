{pirsavelog.p}

/*
Процедура отбора счетов, которые были заблокированы и по которым проводились операции
*/

{globals.i }

DEFINE INPUT PARAMETER iParmStr AS CHARACTER NO-UNDO.

{getdates.i}
{sh-defs.i}

DEFINE VAR max-op-entry AS INTEGER   NO-UNDO.
DEFINE VAR cur-op-entry AS INTEGER   NO-UNDO.
DEFINE VAR op-entry-name   AS CHARACTER NO-UNDO.

DEFINE VAR i AS INTEGER   NO-UNDO.
DEFINE VARIABLE cdetails  AS CHARACTER            NO-UNDO.
DEFINE VARIABLE ndetails  AS CHARACTER            NO-UNDO.

DEF VAR vStatus  AS CHAR NO-UNDO.
DEF VAR vSost    AS LOGICAL NO-UNDO.
DEF VAR vDate    AS date no-undo.

DEFINE TEMP-TABLE dbOp-entry
	 FIELD op LIKE op-entry.op
	 FIELD op-date LIKE op-entry.op-date
	 FIELD acct-db LIKE op-entry.acct-db
	 FIELD acct-cr LIKE op-entry.acct-cr
	 INDEX entry-date op op-date.

DEFINE TEMP-TABLE dbAcct
   FIELD acct LIKE acct.acct
   FIELD stat LIKE acct.acct-status
   FIELD beg-date LIKE history.modif-date
   FIELD end-date LIKE history.modif-date
   FIELD beg-time LIKE history.modif-time
   FIELD end-time LIKE history.modif-time
   INDEX acct-stat-idx acct stat.
.
DEFINE TEMP-TABLE ttAcct
   FIELD acct LIKE acct.acct
   FIELD currency LIKE acct.currency
   FIELD sh-val LIKE sh-val
   FIELD sh-bal LIKE sh-bal
   FIELD stat LIKE acct.acct-status
   FIELD date LIKE op.op-date
   FIELD order-pay LIKE op.order-pay
   FIELD ben-acct LIKE op.ben-acct
   FIELD user-id LIKE _user._user-name
   FIELD number LIKE op.doc-num
   FIELD details LIKE op.details
   INDEX acct-cur-idx acct currency.
.

cur-op-entry = 0.
max-op-entry = 1.

{setdest.i &cols=190}

/* отбор проводок по счетам которые указаны в параметре и запись их во временную таблицу*/
FOR EACH op-entry WHERE op-entry.op-date ge beg-date
                  AND   op-entry.op-date le end-date 
                  no-lock, 
    FIRST op where op-entry.op EQ op.op and op.op-kind ne "Курс"
                  no-lock,
    FIRST acct where CAN-DO(iParmStr,string(acct.bal-acct)) and
                     (acct.acct eq op-entry.acct-db or
    								 acct.acct eq op-entry.acct-cr)	       
    								 no-lock:       
    								 
    	CREATE dbOp-entry.
      ASSIGN
         dbOp-entry.op      = op-entry.op
         dbOp-entry.op-date = op-entry.op-date
         dbOp-entry.acct-cr = op-entry.acct-cr
         dbOp-entry.acct-db = op-entry.acct-db
         .

op-entry-name = "Поиск документов:" + STRING(max-op-entry).
{init-bar.i """ + op-entry-name + ""}
max-op-entry = max-op-entry + 1.                 
END.
  
  op-entry-name = "Обработка документов:" + STRING(max-op-entry).
  {init-bar.i """ + op-entry-name + ""}   

FOR EACH dbOp-entry WHERE dbop-entry.op-date ge beg-date
                    AND   dbop-entry.op-date le end-date 
                    no-lock, 
    FIRST op where dbop-entry.op EQ op.op and op.op-kind ne "Курс"
                   no-lock,              
    each acct where CAN-DO(iParmStr,string(acct.bal-acct)) and
                     (acct.acct eq dbop-entry.acct-db or
    								 acct.acct eq dbop-entry.acct-cr)	       
    								 no-lock,
    FIRST history where history.file-name eq "op"
                    AND history.field-ref EQ STRING(op.op)
                    and history.modify eq "c"
    NO-LOCK:
   
 FIND FIRST dbAcct where dbAcct.acct eq acct.acct and
                         history.modif-date >= dbacct.beg-date 
                         no-lock no-error.
 IF not avail dbAcct THEN  
  DO:
  RUN CheckStatusAcct(acct.acct,
                      acct.acct-status,
                      history.modif-date,
                      history.modif-time,
                      OUTPUT vStatus,
                      OUTPUT vSost,
                      OUTPUT vDate).
   
/* message "number" op.doc-num acct.acct  vStatus vSost vDate . pause. */

    IF vSost eq yes then
    DO:
    	CREATE dbAcct.
      ASSIGN
         dbacct.acct      = acct.acct
         dbacct.stat      = vStatus
         dbacct.beg-date  = vDate
         .
    END.
   END.
   ELSE
    		vStatus =  dbacct.stat.
  
  cur-op-entry = cur-op-entry + 1.
  {move-bar.i cur-op-entry max-op-entry}
            
     IF (acct.acct eq dbop-entry.acct-db and vStatus eq "БлокДб") or
        (acct.acct eq dbop-entry.acct-cr and vStatus eq "БлокКр") or
         vStatus eq "Блок"  then
       DO:  
         FIND _user WHERE _user._userid EQ op.user-id  NO-LOCK NO-ERROR.
      
      CREATE ttAcct.
      ASSIGN
         ttAcct.acct      = acct.acct
         ttAcct.stat      = vStatus
         ttAcct.date      = op.op-date
         ttAcct.order-pay = op.order-pay 
         ttAcct.number    = op.doc-num
         ttAcct.ben-acct  = if op.ben-acct = "" then dbop-entry.acct-cr else op.ben-acct
         ttAcct.details   = op.details
         ttAcct.user-id   = _user._user-name
      .
      END.

END.

FOR EACH ttAcct by ttAcct.date:

         cdetails = replace(ttAcct.details, "~n", " ").
         i = 80.

         DO WHILE substring(cdetails, i, 1) NE " " AND i > 10:
            i = i - 1.
         END.
         ndetails = substring(cdetails, i + 1).
         cdetails = substring(cdetails, 1, i).
         
    form header
        "СПИСОК БЛОКИРОВАННЫХ СЧЕТОВ ПО КОТОРЫМ" SKIP
        "БЫЛИ ОПЕРАЦИИ ЗА ПЕРИОД С" beg-date "ПО" end-date
         PAGE-NUMBER format "Листzz9" to 79 skip(1)
        "+----------------------+-----------+------------+-----+-------+----------------------+-----------------------------------------------------------------------+--------------------------+" 
        "|     Лицевой счет     |  Статус   |    Дата    |Оч.Пл| Номер |   Счет получателя    |                   Назначение платежа                                  |       Исполнитель        |" 
        "+----------------------+-----------+------------+-----+-------+----------------------+-----------------------------------------------------------------------+--------------------------+" 
            with WIDTH 186 no-box.
    {chkpage 3}
    display 
    				"|" at 1 ttAcct.acct FORMAT "99999999999999999999"
            "|" at 24 ttAcct.stat
            "|" at 36 ttAcct.date
            "|" at 49 ttAcct.order-pay format "x(3)"
            "|" at 55 ttAcct.number format "x(3)"
            "|" at 63 ttAcct.ben-acct FORMAT "99999999999999999999"
            "|" at 86 cdetails FORMAT "x(70)"
						"|" at 158 ttAcct.user-id format "x(24)"
						"|" at 185
            
            WITH NO-LABELS NO-UNDERLINE
            .
            
         cdetails = ndetails.

         DO WHILE LENGTH(cdetails) > 0:
            i = 80.

            DO WHILE SUBSTRING(cdetails, i, 1) NE " " AND i > 10:
               i = i - 1.
            END.
            ndetails = substring(cdetails, i + 1).
            cdetails = substring(cdetails, 1, i).
            PUT UNFORMATTED "|" FILL(" ",22)
                            "|" FILL(" ",11)
                            "|" FILL(" ",12)
                            "|" FILL(" ",5)
                            "|" FILL(" ",7)
                            "|" FILL(" ",22)
            .
            PUT UNFORMATTED "| " cdetails FORMAT "x(70)".
            cdetails = ndetails.
            PUT UNFORMATTED "|" FILL(" ",26) "|" skip.
         END.
 
            
PUT UNFORMATTED   
         "+----------------------+-----------+------------+-----+-------+----------------------+-----------------------------------------------------------------------+--------------------------+" skip
.     
END.

{signatur.i &user-only=yes }
{preview.i}
/* процедура проверки блокировки счета на дату создания документа */
PROCEDURE CheckStatusAcct.
		DEF INPUT PARAMETER iAcct     AS CHAR NO-UNDO.
		DEF INPUT PARAMETER iStatus   AS CHAR NO-UNDO.
		DEF INPUT PARAMETER iDate     LIKE history.modif-date.
		DEF INPUT PARAMETER iTime     LIKE history.modif-time.
		
	  DEF OUTPUT PARAMETER oStatus  AS CHAR NO-UNDO. /* статус который сейчас на счете */
	  DEF OUTPUT PARAMETER oSost    AS logical no-undo. /* если да тогда будем заносить в таблицу счетов */
	  DEF OUTPUT PARAMETER oDate    LIKE history.modif-date. /* дата с которой работает блокировка в нашем случае */

/* ищем запись в истории после проведения документа по изменению статуса документа 
   и таким образом узнаем какой статус счета был*/

FIND FIRST history where       entry(1,history.field-ref) EQ iAcct and
		                           history.file-name = "acct" and
                               history.modify = "W" and 
                               can-do("*acct-status*",history.field-value) and
                               history.modif-date > iDate
                               use-index file-date-time no-lock no-error.
/* разнесем для скорости поиска */
        IF not avail history then
        DO:
        FIND FIRST history where       entry(1,history.field-ref) EQ iAcct and
		                                   history.file-name = "acct" and
                                       history.modify = "W" and 
                                       can-do("*acct-status*",history.field-value) and
                                       history.modif-date = iDate and 
                                       history.modif-time > iTime
                                       use-index file-date-time no-lock no-error.
        END.                               
/* message "midle2" history.modif-date entry(lookup("acct-status",history.field-value) + 1,history.field-value). pause.*/

/* если изменений не было оставляем какой был */             
   IF avail history then 
   oStatus = entry(lookup("acct-status",history.field-value) + 1,history.field-value). 
   else 
   oStatus = iStatus.
   
	 IF (avail history and history.modif-date > end-date) or not avail history then
	 do:
	 oSost = yes.
	 oDate = iDate.
	 end.

/* message "end" iAcct oStatus oSost oDate . pause. */
END PROCEDURE.
