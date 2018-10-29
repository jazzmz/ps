{pirsavelog.p}

/* ------------------------------------------------------
File          : $RCSfile: pir-vip.p,v $ $Revision: 1.5 $ $Date: 2007-10-18 07:42:21 $
Copyright     : ООО КБ "Пpоминвестрасчет"
Базируется    : stmt(dd).p, при обновлениях переносить доработки
Причина       : Приказ №64 от 25.10.2005
Назначение    : Выписки за период
Параметры     : - Начальная дата
              : - Конечная дата
              : - Код подразделения
              : - Имя файла
              : - Cсылка на фильтр по счетам 
              : - Дополнительные параметры процедуры через ","              
Место запуска : Планировщик задач, процедура pir-shdrep.p 
Автор         : $Author: anisimov $ 
Изменения     : $Log: not supported by cvs2svn $
Изменения     : Revision 1.4  2007/08/21 13:39:00  lavrinenko
Изменения     : Реализовано сохранение в месячные и годовые е каталоги
Изменения     :
Изменения     : Revision 1.3  2007/08/20 13:53:49  Lavrinenko
Изменения     : Изменение формата вызова
Изменения     :
Изменения     : Revision 1.2  2007/08/20 06:53:32  lavrinenko
Изменения     : процедура ренерации выписок по счетам клиентов
Изменения     :
Изменения     : Revision 1.1  2007/08/17 13:03:38  lavrinenko
Изменения     : Процедура  регенрации выписок в автоматическом режите@
Изменения     :
------------------------------------------------------ */

/********************************************************
 *
 * 		    !!! ВНИМАНИЕ !!!
 *
 * Процедура использует только часть настроек фильтра!!!
 *
 ********************************************************/

{globals.i}
{sh-defs.i}
{pick-val.i}
{chkacces.i}
{intrface.get count}
{intrface.get xclass}

DEF VAR oSysClass1	    AS TSysClass NO-UNDO.
DEF VAR curr-user-id        AS CHARACTER NO-UNDO.
DEF VAR curr-user-inspector AS CHARACTER NO-UNDO.

curr-user-id = USERID("bisquit").

DEF INPUT PARAM iBranch     AS CHAR NO-UNDO. /* Код подразделения      */
DEF INPUT PARAM iFlt        AS CHAR NO-UNDO. /* Cсылка на фильтр по счетам  */
DEF INPUT PARAM taxon       AS CHAR NO-UNDO. /* Вид документа в электронном архиве */
DEF INPUT PARAM iParam      AS CHAR NO-UNDO. /* Дополнительные параметры процедуры через "," */

DEF VAR oEra    AS TEra    NO-UNDO.
DEF VAR oConfig AS TAArray NO-UNDO.


{pirraproc.def}

{pir-c2346u.i}
{getdate.i}

ASSIGN
   beg-date  = end-date
   gRemote   = YES  
.


DEFINE VARIABLE mIsSeparate AS LOGICAL NO-UNDO. 

mIsSeparate = FGetSetting("Выписки", "Порядок", "Счета") EQ "Выписка".

{tmprecid.def}          /* Таблица отметок. */
{empty TmpRecId}        /* Обнуление таблицы отметок. */

{flt-file.i NEW}        /* Определение структуры динамического фильтра. */

RUN acct-flt.p ("acctb").

DEF VAR list-class   AS CHAR NO-UNDO. /* список класса и подклассов*/
DEF VAR num-class    AS INT  NO-UNDO. /* N класса */

IF GetFltVal ("acct-cat") EQ ""
THEN DO:
   RUN SetFltFieldList ("acct-cat", "*"). /* Записываем в строку. */
   RUN SetFltField     ("acct-cat", "*"). /* Записываем структуру. */
END.


FIND FIRST user-config WHERE
        user-config.user-id    = entry(1,iFlt)           AND 
        user-config.proc-name  = entry(2,iFlt) AND 
        user-config.sub-code   = entry(3,iFlt) AND 
        user-config.descr      = entry(4,iFlt) NO-LOCK NO-ERROR.
  
IF NOT AVAIL user-config THEN DO:
        PUT UNFORMAT "Не найден фильтр " iFlt SKIP.
        RETURN.
END.
                       
RAW-TRANSFER user-config.config-data TO tt-table.
                       
{flt-attr.set}

PUT UNFORMAT "Используется фильтр " iFlt.

FOR EACH acct WHERE CAN-DO(GetFltVal('acct'), acct.acct) 
                AND CAN-DO(GetFltVal('currency'), acct.currency) 
		AND CAN-DO("b,o",acct.acct-cat) NO-LOCK:
    CREATE tmprecid.
    tmprecid.id = RECID(acct).
END.
{flt-file.end}

{empty flt-cat}
{empty flt-attr}
{empty tt-table}


FIND FIRST user-config WHERE
        user-config.user-id    = entry(1,iFlt)        AND 
        user-config.proc-name  = "stmt(dd).p"         AND 
        user-config.sub-code   = "stmt"               AND 
        user-config.descr      = entry(4,iFlt)        NO-LOCK NO-ERROR.
        
IF AVAIL user-config THEN 
        RAW-TRANSFER user-config.config-data TO tt-table.

{stmt.i new }

/* Вместо {getstmt.i} */
DEFINE VARIABLE vmode-proc-scr AS CHAR FORMAT "x(40)" NO-UNDO.
DEFINE VARIABLE proc-post-scr  AS CHAR FORMAT "x(40)" NO-UNDO.
DEFINE VARIABLE last-F5        AS CHAR                NO-UNDO.
DEFINE VARIABLE vDtZo          AS CHAR                NO-UNDO.
DEFINE VARIABLE Cols           AS INT                 NO-UNDO.
DEFINE VARIABLE vSortPoz       AS INT  INIT 10        NO-UNDO.

{setdest.i &custom=" if not pgd then 0 else " &cols=" + cols"}


IF mIsSeparate AND ts.cmode EQ 3 THEN
DO:
   ts.cmode = 1.

   FOR EACH tmprecid NO-LOCK,
       FIRST acct WHERE RECID(acct) = tmprecid.id NO-LOCK
                  BY acct.bal-acct
                  BY SUBSTRING(acct.acct,vSortPoz):

      {on-esc RETURN}

      IF NOT {acctlook.i} THEN
         NEXT.
      {stmt-prt.i &NEXT    ="NEXT"
                  &begdate = beg-date
                  &enddate = end-date
                  &bufacct = acct
      }
   END.
   ts.cmode = 2.
   ts.name-vip = "ВЫПИСКА ИЗ ЛИЦЕВОГО СЧЕТА".
END.

for each tmprecid no-lock,
   first acct where recid(acct) = tmprecid.id no-lock
        by acct.bal-acct
        by substr(acct.acct,vSortPoz):

   {on-esc return}
   if not {acctlook.i} then next.
   {stmt-prt.i &NEXT    ="NEXT"
               &begdate = beg-date
               &enddate = end-date
               &bufacct = acct
   }
end.

{preview.i}
oConfig = new TAArray().
oConfig:setH("taxon",taxon).
oConfig:setH("opdate",TEra:getDate(end-date)).
oConfig:setH("num",iCurrOut).
oConfig:setH("expn",iCurrOut).
oConfig:setH("author",USERID("bisquit")).
oConfig:setH("inspector",USERID("bisquit")).
oConfig:setH("fext","txt").
oEra = new TEra(TRUE).
 oEra:askAndSave(oConfig,"_spool.tmp").
DELETE OBJECT oEra.
DELETE OBJECT oConfig.
