{pirsavelog.p}

/*
        Comment: ОЭД. Печать отчета об экспорта документов.
 
*/


{globals.i}
{tmprecid.def}

{exchange.equ}
{intrface.get strng}
{intrface.get exch}
{pck-pop.def}

DEF VAR mReestrNum     LIKE Seance.Number.
 
DEF TEMP-TABLE TTReestr NO-UNDO
   FIELD PacketID    AS INT
   FIELD doc-type    AS CHAR
   FIELD doc-date    AS DATE
   FIELD doc-num     AS CHAR
   FIELD order-pay   AS CHAR
   FIELD due-date    AS DATE
   FIELD bank-code   AS CHAR
   FIELD ben-acct    AS CHAR
   FIELD acct        AS CHAR
   FIELD inn         AS CHAR
   FIELD details     AS CHAR
   FIELD amt-rub     AS DECIMAL
   FIELD send-id     AS CHAR
   FIELD reference   AS CHAR
   FIELD op-status   AS CHAR
   FIELD op          AS INT
   FIELD PackDate    AS DATE
   FIELD PackTime    AS CHAR
   FIELD ClassError  AS CHAR
   FIELD PackError   AS CHAR
   FIELD name-ben    AS CHAR
   FIELD SeanceNum   AS CHAR
   FIELD MailFormat  AS CHAR
   FIELD FileName    AS CHAR
   FIELD ESID        AS CHAR
   INDEX ESID 
         ESID PackDate SeanceNum
. 
/*

*/
/*============================================================================*/

RUN CrTTReestr.

IF NOT CAN-FIND(FIRST TTReestr) THEN DO:
   MESSAGE "Нет данных !" VIEW-AS ALERT-BOX.
   RETURN.
END. 

{chkacces.i}
{setdest.i &cols=160}
	
FIND FIRST tmprecid no-lock.

	IF avail tmprecid then
		 FIND FIRST op-entry where	RECID(op-entry) EQ tmprecid.id no-lock.
 
		 
	IF avail op-entry then
		FIND last PackObject WHERE
                    op-entry.op       EQ INT(ENTRY(1,PackObject.Surrogate))
                    AND op-entry.op-entry EQ INT(ENTRY(2,PackObject.Surrogate))
            NO-LOCK.
    
  IF avail PackObject THEN
    FIND  FIRST Seance WHERE
                       PackObject.SeanceID    EQ  Seance.SeanceID
                 NO-LOCK NO-ERROR.
   
 IF AVAIL seance then  mReestrNum = Seance.Number.

FOR EACH TTReestr by TTReestr.amt-rub:
   
    {on-esc return}

    FORM HEADER
        caps(name-bank) at 6 format "x(60)" skip
        "РЕЕСТР ЭКСПОРТИРУЕМЫХ ДОКУМЕНТОВ" at 6 today
        PAGE-NUMBER format "Листzz9" to 75 skip
        "№ рейса экспорта - " at 6 string(mReestrNum) format "x(2)"  skip(1)
        /* "Уникальный номер рейса - " at 6  refer skip(2)*/
        "+-------+---------------+----------------------+-----------+----------------------+-----+------------+----------------------------------------------------------------------+" 
        "| N док |     Сумма     |   Счет плательщика   |    БИК    |   Счет получателя    |Оч.Пл|  ИНН получ.|                Наименование получателя                               |" 
        "+-------+---------------+----------------------+-----------+----------------------+-----+------------+----------------------------------------------------------------------+" 
        WITH WIDTH 174 NO-BOX.
 
     DISPLAY 
        "|" at 1   TTReestr.doc-num	       format "x(6)"  	
        "|" at 9   TTReestr.amt-rub  FORMAT "-zz,zzz,zz9.99"                   
        "|" at 25  TTReestr.acct     FORMAT "99999999999999999999"   
        "|" at 48  TTReestr.bank-code FORMAT "999999999"
        "|" at 60  TTReestr.ben-acct       FORMAT "99999999999999999999"   
        "|" at 83  TTReestr.order-pay      format "x(3)"            
        "|" at 89  TTReestr.inn at 90      FORMAT "x(12)"
        "|" at 102 TTReestr.name-ben       FORMAT "x(69)"
        "|" at 173
        WITH NO-LABELS NO-UNDERLINE
        .

     ACCUMULATE TTReestr.amt-rub (TOTAL).
     ACCUMULATE TTReestr.doc-num (COUNT).

END.

PUT UNFORMATTED   
           "+-------+---------------+----------------------+-----------+----------------------+-----+------------+----------------------------------------------------------------------+" skip(1)
           "Всего док-тов: " +
           STRING(accum count TTReestr.doc-num,">>>9") + FILL(" ",10) +
           "Итоговая сумма:" + FILL(" ",3) +
           STRING(ACCUM TOTAL TTReestr.amt-rub,"-zz,zzz,zzz,zz9.99") 
           FORMAT "x(100)" SKIP(2)
           "Подпись Операциониста:" + FILL(" ",20) +
           "Подпись Котролера:" + FILL(" ",20) +
           "Подпись Бухгалтера:" + FILL(" ",20) skip
           .
{signatur.i &user-only=yes}
{preview.i}
RETURN.



PROCEDURE CrTTReestr.

   FOR EACH tmprecid,

      EACH op-entry WHERE RECID(op-entry) EQ tmprecid.id
            NO-LOCK,
      FIRST op OF op-entry NO-LOCK,
      FIRST op-bank OF op   WHERE 
            op-bank.op-bank-type   EQ "" AND
            op-bank.bank-code-type EQ "МФО-9"  
            NO-LOCK:


            CREATE TTReestr.
            ASSIGN TTReestr.doc-num    =  op.doc-num 
            			 TTReestr.amt-rub    =  op-entry.amt-rub
            			 TTReestr.acct       =  op-entry.acct-db
            			 TTReestr.bank-code  =  op-bank.bank-code
            			 TTReestr.ben-acct   =  op.ben-acct
            			 TTReestr.order-pay  =  op.order-pay
            			 TTReestr.inn        =  op.inn
            			 TTReestr.name-ben   =  op.name-ben
            			 TTReestr.op         =  op-entry.op
            .
   END.
END PROCEDURE.

