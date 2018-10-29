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

{ttreestr.def}

DEF VAR mReestrNum     LIKE Seance.Number NO-UNDO.
DEF VAR mProverka      AS LOGICAL NO-UNDO.
DEF VAR currDate AS DATE. /* Дата текущего опер дня */

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
        "РЕЕСТР ЭКСПОРТИРУЕМЫХ ДОКУМЕНТОВ" at 6 today
        PAGE-NUMBER format "Листzz9" to 75 skip
        "№ рейса экспорта - " at 6 string(mReestrNum) format "x(2)"  skip(1)
        /* "Уникальный номер рейса - " at 6  refer skip(2)*/
        "+-------+------------------+----------------------+----------+----------------------+----+------------+----------------------------------------------------------------------+" 
        "| N док |      Сумма       |   Счет плательщика   |   БИК    |   Счет получателя    |Оч.П|  ИНН получ.|                Наименование получателя                               |" 
        "+-------+------------------+----------------------+----------+----------------------+----+------------+----------------------------------------------------------------------+" 
        WITH WIDTH 174 NO-BOX.
 
     DISPLAY 
        "|" at 1   TTReestr.doc-num	       format "x(6)"  	
        "|" at 9   TTReestr.amt-rub  FORMAT "-z,zzz,zzz,zz9.99"                   
        "|" at 28  TTReestr.acct     FORMAT "99999999999999999999"   
        "|" at 51  TTReestr.bank-code FORMAT "999999999"
        "|" at 62  TTReestr.ben-acct       FORMAT "99999999999999999999"   
        "|" at 85  TTReestr.order-pay      format "x(3)"            
        "|" at 90  TTReestr.inn at 91      FORMAT "x(12)"
        "|" at 103 TTReestr.name-ben       FORMAT "x(69)"
        "|" at 174
        WITH NO-LABELS NO-UNDERLINE
        .

     ACCUMULATE TTReestr.amt-rub (TOTAL).
     ACCUMULATE TTReestr.doc-num (COUNT).

END.

PUT UNFORMATTED   
           "+-------+------------------+----------------------+----------+----------------------+----+------------+----------------------------------------------------------------------+" skip(1)
           "Всего док-тов: " +
           STRING(accum count TTReestr.doc-num,">>>9") + FILL(" ",10) +
           "Итоговая сумма:" + FILL(" ",3) +
           STRING(ACCUM TOTAL TTReestr.amt-rub,"-z,zzz,zzz,zzz,zz9.99") 
           FORMAT "x(100)" SKIP(2).

IF mProverka = YES THEN
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
        "+-------+------------------+----------------------+----------+----------------------+----+------------+----------------------------------------------------------------------+" 
        "| N док |      Сумма       |   Счет плательщика   |    БИК   |   Счет получателя    |Оч.П|  ИНН получ.|                Содержание операции                                   |" 
        "+-------+------------------+----------------------+----------+----------------------+----+------------+----------------------------------------------------------------------+" 
        WITH WIDTH 174 NO-BOX.
 
     DISPLAY 
        "|" at 1   TTReestr.doc-num	       format "x(6)"  	
        "|" at 9   TTReestr.amt-rub  FORMAT "-z,zzz,zzz,zz9.99"                   
        "|" at 28  TTReestr.acct     FORMAT "99999999999999999999"   
        "|" at 51  TTReestr.bank-code FORMAT "999999999"
        "|" at 62  TTReestr.ben-acct       FORMAT "99999999999999999999"   
        "|" at 85  TTReestr.order-pay      format "x(3)"            
        "|" at 90  TTReestr.inn at 91      FORMAT "x(12)"
        "|" at 103 TTReestr.details       FORMAT "x(69)"
        "|" at 174
        WITH NO-LABELS NO-UNDERLINE
        .

     ACCUMULATE TTReestr.amt-rub (TOTAL).
     ACCUMULATE TTReestr.doc-num (COUNT).
  END. /* Конец по всем документам реестра */  
END. /* Конец если необходимо провести валютный контроль */



PUT UNFORMATTED   
           "+-------+------------------+----------------------+----------+----------------------+----+------------+----------------------------------------------------------------------+"  skip(1)
           "Всего док-тов: " +
           STRING(accum count TTReestr.doc-num,">>>9") + FILL(" ",10) /* +
           "Итоговая сумма:" + FILL(" ",3) +
           STRING(ACCUM TOTAL TTReestr.amt-rub,"-zz,zzz,zzz,zz9.99") 
           FORMAT "x(100)" */ SKIP(2).
END.

/*****************************************
 * Проверка на отправку связанных
 * парных документов.
 * Заявка: #665
 * Автор: Маслов Д. А.
 * Дата создания: 18:00 28.03.2011
 *******************************************/

{pir-chkexp665.i}

/*** КОНЕЦ #665 ***/

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
            NO-LOCK:


            CREATE TTReestr.
            ASSIGN TTReestr.doc-num    =  op.doc-num 
				 TTReestr.op-status = op.op-status
            			 TTReestr.amt-rub    =  op-entry.amt-rub
            			 TTReestr.acct       =  op-entry.acct-db
            			 TTReestr.bank-code  =  op-bank.bank-code
            			 TTReestr.ben-acct   =  op.ben-acct
            			 TTReestr.order-pay  =  op.order-pay
            			 TTReestr.inn        =  op.inn
            			 TTReestr.name-ben   =  op.name-ben
            			 TTReestr.op         =  op-entry.op
            			 TTReestr.details    =  op.details				 
            .
   END.

  currDate = op-entry.op-date.

END PROCEDURE.
