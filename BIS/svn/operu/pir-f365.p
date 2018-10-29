/*******************************
 *
 * Отображаем счета для которых
 * требуется запретить проведение
 * операций в дату меньше текущего
 * операционного дня.
 *
 *******************************
 *
 * Автор  : Маслов Д. А. Maslov D. A.
 * Заявка : #1606
 * Дата   : 29.10.12
 *
 *******************************/

{globals.i}
{tmprecid.def}
{intrface.get tmess}
{intrface.get db2l}
{intrface.get xclass}

DEF INPUT PARAM in-op-date LIKE op.op-date.
DEF INPUT PARAM oprid      AS   RECID.

DEF VAR dDiff     AS INT  NO-UNDO.
DEF VAR currDate  AS DATE NO-UNDO.
DEF VAR permDate  AS DATE NO-UNDO.

DEF VAR skipCount AS INT NO-UNDO.
DEF VAR shouldDo  AS INT NO-UNDO.



dDiff = INT(FGetSetting("PirChkOp","F365Move","1")).


currDate = in-op-date.

EMPTY TEMP-TABLE tmprecid.

/**
 * Если к дате окончания не
 * не добавить время,
 * то в запросе будет пусто.
 ***/

RUN browseld.p("acct",
               "acct"            + CHR(1) +
               "cust-id"         + CHR(1) + 
               "cust-cat"        + CHR(1) + 
               "acct-cat"        + CHR(1) + 
               "currency"        + CHR(1) +
               "contract"        + CHR(1) +
               "beg-datetime1"   + CHR(1) + 
               "beg-datetime2",
               "*"               + CHR(1) +
               "*"               + CHR(1) + 
               "*"               + CHR(1) + 
               "*"               + CHR(1) +
               "*"               + CHR(1) +
               "*"               + CHR(1) +
               STRING(TODAY - dDiff) + CHR(1) + 
               STRING(TODAY) + " 23:59",
               'acct',
               4).


IF LASTKEY = 10 THEN DO:

FOR EACH tmprecid NO-LOCK,
  FIRST acct WHERE RECID(acct) EQ tmprecid.id NO-LOCK:

  permDate = DATE(getXAttrValueEx("acct",GetSurrogateBuffer("acct",BUFFER acct:HANDLE),"ПирРазПровод",FGetSetting("Дата_НР","","01/01/1900"))).

  IF permDate >= currdate THEN DO:
        {inc skipCount}
  END. ELSE DO:
        {inc shouldDo}
  END.
 ACCUMULATE tmprecid.id (COUNT).
END.


RUN Fill-SysMes IN h_tmess ("","",3,"Будем устанавливать реквизит, запрещающий проведение документов?\nВыделено счетов - " + STRING(ACCUM COUNT tmprecid.id) + ".\nИз них: " + STRING(skipCount) + " - пропущено. " + STRING(shouldDo) + " - применится.|Установить,Отменить").

 IF pick-value = "1" THEN DO:
       FOR EACH tmprecid NO-LOCK,
          FIRST acct WHERE RECID(acct) EQ tmprecid.id NO-LOCK:
           UpdateSigns("acctb",GetSurrogateBuffer("acct",BUFFER acct:HANDLE),"ПирРазПровод",STRING(currDate),?).
       END.     
 END.
END.

{intrface.del}