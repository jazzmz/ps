{pirsavelog.p}

/*
               
    Copyright: 
     Filename: pirrees.p
      Comment: Реестр документов
   Parameters: 
         Uses: 
      Used by: op-opord.p
      Created: 
    Modified: 
    run pirrees.p (in-op-date,in-series-num).

*/
DEF INPUT PARAM iDate      AS DATE NO-UNDO.
DEF INPUT PARAM iSeries    AS INTEGER NO-UNDO.

{globals.i}
{defexp.tab}
DEF VAR name as char EXTENT 2     NO-UNDO.
DEF VAR buf as char format "x(4)" LABEL "Примеч." NO-UNDO.
DEF VAR str-acct as char init "*" FORMAT "x(30)"  NO-UNDO.
def var in-series-num as char no-undo.
def var in-op-date as char no-undo.
def var refer as char no-undo.

def var doc-num  as char no-undo.
def var name-rec as char NO-UNDO.

RUN SetSysConf in h_base ('Series', "").

{chkacces.i}
{setdest.i &cols=160}


FOR EACH exp-temp-table WHERE exp-temp-table.order NE 0 
     AND exp-temp-table.order NE ?,
   FIRST op WHERE op.op EQ exp-temp-table.op NO-LOCK,
   FIRST op-bank  OF op NO-LOCK, 
   EACH  op-entry OF op WHERE CAN-DO(str-acct,string(op-entry.acct-db)) NO-LOCK
         BY op-entry.amt-rub 
         BY op.doc-type
         BY op.doc-num 
         BY op-bank.bank-code 
         BY op-bank.corr-acct 
         BY op.ben-acct
         BY op.order-pay
         BY op-entry.acct-db:


    {on-esc return}

    FORM HEADER
        caps(name-bank) at 6 format "x(60)" skip
        "РЕЕСТР ЭКСПОРТИРУЕМЫХ ДОКУМЕНТОВ" at 6 today
         PAGE-NUMBER format "Листzz9" to 75 skip
        "№ рейса экспорта - " at 6 string(iseries) format "x(2)"  skip(1)
        /* "Уникальный номер рейса - " at 6  refer skip(2)*/
        "+-------+---------------+----------------------+-----------+----------------------+-----+------------+----------------------------------------------------------------------+" 
        "| N док |     Сумма     |   Счет плательщика   |    БИК    |   Счет получателя    |Оч.Пл|  ИНН получ.|                Наименование получателя                               |" 
        "+-------+---------------+----------------------+-----------+----------------------+-----+------------+----------------------------------------------------------------------+" 
        WITH WIDTH 174 NO-BOX.
 
     DISPLAY 
        "|" at 1   op.doc-num	       format "x(6)"  	
        "|" at 9  op-entry.amt-rub  FORMAT "-zz,zzz,zz9.99"                   
        "|" at 25  op-entry.acct-db  FORMAT "99999999999999999999"   
        "|" at 48  op-bank.bank-code FORMAT "999999999"
        "|" at 60  op.ben-acct       FORMAT "99999999999999999999"   
        "|" at 83   op.order-pay      format "x(3)"            
        "|" at 89  op.inn at 90      FORMAT "x(12)"
        "|" at 102 op.name-ben       FORMAT "x(70)"
        "|" at 173
        WITH NO-LABELS NO-UNDERLINE
        .

     ACCUMULATE op-entry.amt-rub (TOTAL).
     ACCUMULATE op.doc-num (COUNT).

END.

PUT UNFORMATTED   
           "+-------+---------------+----------------------+-----------+----------------------+-----+------------+----------------------------------------------------------------------+" skip(1)
           "Всего док-тов: " +
           STRING(accum count op.doc-num,">>>9") + FILL(" ",10) +
           "Итоговая сумма:" + FILL(" ",3) +
           STRING(ACCUM TOTAL op-entry.amt-rub,"-zz,zzz,zzz,zz9.99") 
           FORMAT "x(100)" SKIP(2)
           "Подпись Операциониста:" + FILL(" ",20) +
           "Подпись Котролера:" + FILL(" ",20) +
           "Подпись Бухгалтера:" + FILL(" ",20) skip
           .
{signatur.i &user-only=yes}
{preview.i}
