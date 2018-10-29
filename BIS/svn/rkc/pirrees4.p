{pirsavelog.p}
/*
        Comment: ОЭД. Печать отчета об экспорта документов.
 
*/


{globals.i}

{tmprecid.def}
{wordwrap.def}

{exchange.equ}

{intrface.get strng}
{intrface.get exch}
{pck-pop.def}

{intrface.get xclass}

{intrface.get bank}
{intrface.get swi}
{intrface.get terr}
{intrface.get instrum}
{intrface.get re}      
{intrface.get tmess}

{intrface.get ps}
{intrface.get strng}

{chkop117.i}         

{ulib.i}


DEF VAR mReestrNum     LIKE Seance.Number NO-UNDO.
DEF VAR mProverka      AS LOGICAL NO-UNDO.

/** Buryagin added the next line at 23/10/2008 */
DEF VAR i AS INTEGER NO-UNDO.
 
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
   /** Buryagin added the next code at 23/10/2008 */
   FIELD bank-name   AS CHAR 
   FIELD acct-details AS CHAR 
   FIELD op-details  AS CHAR 
   /** Buryagin end */ 
   FIELD ESID        AS CHAR
   INDEX ESID 
         ESID PackDate SeanceNum
. 

/*

*/
/*============================================================================*/
mProverka = No.

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
                 

FOR EACH TTReestr by TTReestr.amt-rub:
   
    {on-esc return}
    
  IF ChckAcctNecessary (TTReestr.acct,"Да,Пр") or ChckAcctNecessary (TTReestr.ben-acct,"Да,Пр") THEN mProverka = Yes.

  IF AVAIL seance then  mReestrNum = Seance.Number.
   

    FORM HEADER
        caps(name-bank) at 6 format "x(60)" skip
        "ДАТА" at 6 today
        PAGE-NUMBER format "Листzz9" to 75 skip
        "№ рейса экспорта - " at 6 string(mReestrNum) format "x(2)"  skip(1)
        /* "Уникальный номер рейса - " at 6  refer skip(2)*/
        "+-------+------------------+------------------------------------------------------+------------------------------------------+---------------------------------------------------------------+---------------------------------------------------------------------------------+" 
        "| N док |      Сумма       |                Наименование плательщика              |             Наименование банка           |                     Наименование получателя                   |     Назначение платежа                                                          |" 
        "+-------+------------------+------------------------------------------------------+------------------------------------------+---------------------------------------------------------------+---------------------------------------------------------------------------------+" 
        WITH WIDTH 272 NO-BOX.
 
     DISPLAY 
        "|" at 1 TTReestr.doc-num format "x(6)"  	
        "|" at 9 TTReestr.amt-rub FORMAT "-z,zzz,zzz,zz9.99"                   
        "|" at 28 TTReestr.acct-details FORMAT "x(52)"
        "|" at 83 TTReestr.bank-name FORMAT "x(41)"	
        "|" at 126 TTReestr.name-ben FORMAT "x(62)"
        "|" at 190 TTReestr.op-details FORMAT "x(80)"
        "|" at 272
        WITH NO-LABELS NO-UNDERLINE
        .
     
     ACCUMULATE TTReestr.amt-rub (TOTAL).
     ACCUMULATE TTReestr.doc-num (COUNT).

END.

PUT UNFORMATTED   
	       "+-------+------------------+------------------------------------------------------+------------------------------------------+---------------------------------------------------------------+---------------------------------------------------------------------------------+" skip(1) 
           "Всего док-тов: " +
           STRING(accum count TTReestr.doc-num,">>>9") + FILL(" ",10) +
           "Итоговая сумма:" + FILL(" ",3) +
           STRING(ACCUM TOTAL TTReestr.amt-rub,"-z,zzz,zzz,zzz,zz9.99") 
           FORMAT "x(100)" SKIP(2).


/** Buryagin changed the next line */
IF false /* mProverka = YES */ THEN 
DO:

FOR EACH TTReestr    by TTReestr.amt-rub:
 if ChckAcctNecessary (TTReestr.acct,"Да,Пр") or ChckAcctNecessary (TTReestr.ben-acct,"Да,Пр") THEN
 
 DO:
    FORM HEADER
        caps(name-bank) at 6 format "x(60)" skip
        "ОТЧЕТ ЭКСПОРТИРУЕМЫХ ДОКУМЕНТОВ ТРЕБУЮЩИХ ОТМЕТКИ ВАЛЮТНОГО КОНТРОЛЯ" at 6 today
       /* PAGE-NUMBER format "Листzz9" to 75 skip*/
        "№ рейса экспорта - " at 6 string(mReestrNum) format "x(2)"  skip(1)
        /* "Уникальный номер рейса - " at 6  refer skip(2)*/
        "+-------+------------------+------------------------------------------------------+------------------------------------------+---------------------------------------------------------------+---------------------------------------------------------------------------------+" 
        "| N док |      Сумма       |                Наименование плательщика              |             Наименование банка           |                     Наименование получателя                   |     Назначение платежа                                                          |" 
        "+-------+------------------+------------------------------------------------------+------------------------------------------+---------------------------------------------------------------+---------------------------------------------------------------------------------+" 
        WITH WIDTH 272 NO-BOX.
 
     DISPLAY 
        "|" at 1 TTReestr.doc-num format "x(6)"  	
        "|" at 9 TTReestr.amt-rub FORMAT "-z,zzz,zzz,zz9.99"                   
        "|" at 28 TTReestr.acct-details FORMAT "x(52)"
        "|" at 83 TTReestr.bank-name FORMAT "x(41)"	
        "|" at 126 TTReestr.name-ben FORMAT "x(62)"
        "|" at 190 TTReestr.op-details FORMAT "x(80)"
        "|" at 272
        WITH NO-LABELS NO-UNDERLINE
        .

     ACCUMULATE TTReestr.amt-rub (TOTAL).
     ACCUMULATE TTReestr.doc-num (COUNT).
  END.

END.

PUT UNFORMATTED   
           "+-------+------------------+------------------------------------------------------+------------------------------------------+---------------------------------------------------------------+---------------------------------------------------------------------------------+" skip(1) 
           "Всего док-тов: " +
           STRING(accum count TTReestr.doc-num,">>>9") + FILL(" ",10) /* +
           "Итоговая сумма:" + FILL(" ",3) +
           STRING(ACCUM TOTAL TTReestr.amt-rub,"-zz,zzz,zzz,zz9.99") 
           FORMAT "x(100)" */ SKIP(2).
END.

PUT UNFORMATTED 
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
            NO-LOCK,
      FIRST banks-code WHERE 
            banks-code.bank-code-type = op-bank.bank-code-type AND
            banks-code.bank-code = op-bank.bank-code
            NO-LOCK,
      FIRST banks WHERE
            banks.bank-id = banks-code.bank-id
            NO-LOCK,
      FIRST acct WHERE
      		acct.acct = op-entry.acct-db
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
            			 TTReestr.details    =  op.details
            			 TTReestr.acct-details = GetAcctClientName_UAL(acct.acct, false)
            			 TTReestr.bank-name = banks.name
            			 TTReestr.op-details = REPLACE(op.details, CHR(10), " ")
            .
            IF TTReestr.acct-details = "" THEN TTReestr.acct-details = acct.details.
            
   END.
END PROCEDURE.
