{pirsavelog.p}

/* ------------------------------------------------------
File          : $RCSfile: pir-pril6.p,v $ $Revision: 1.11 $ $Date: 2007-10-18 07:42:21 $
Copyright     : ООО КБ "Пpоминвестрасчет"
Базируется    : POSNEW1.P
Причина       : Приказ №64 от 25.10.2005
Назначение    : Приложение №6
Параметры     : - Начальная дата
              : - Конечная дата
              : - Код подразделения
              : - Имя файла
              : - Список балансовых категорий счетов участвующих в построении отчета              
              : - Дополнительные параметры процедуры через ","              
Место запуска : Планировщик задач, процедура pir-shdrep.p 
Автор         : $Author: anisimov $ 
Изменения     : $Log: not supported by cvs2svn $
Изменения     : Revision 1.10  2007/08/21 13:39:00  lavrinenko
Изменения     : Реализовано сохранение в месячные и годовые е каталоги
Изменения     :
Изменения     : Revision 1.9  2007/08/16 14:08:30  Lavrinenko
Изменения     : Исправление описания
Изменения     :
Изменения     : Revision 1.8  2007/08/16 13:12:30  Lavrinenko
Изменения     : изменение формата вызова
Изменения     :
Изменения     : Revision 1.7  2007/08/15 09:48:56  lavrinenko
Изменения     : правки заголовка
Изменения     :
------------------------------------------------------ */
{globals.i}
{norm.i new}
{intrface.get strng}

DEF INPUT PARAM iBegDate    AS DATE NO-UNDO. /* Начальная дата         */
DEF INPUT PARAM iEndDate    AS DATE NO-UNDO. /* конечная дата          */
DEF INPUT PARAM iBranch     AS CHAR NO-UNDO. /* Код подразделения      */
DEF INPUT PARAM iFile       AS CHAR NO-UNDO. /* передаваемое имя файла */
DEF INPUT PARAM iBalCat     AS CHAR NO-UNDO. /* список балансовых категорий счетов участвующих в построении отчета */
DEF INPUT PARAM iParam      AS CHAR NO-UNDO. /* 1 параметр - список счетов 2-го порядка
                                             по которым выводить только сумму */
DEFINE VARIABLE acc_list    AS CHARACTER NO-UNDO.
DEFINE VARIABLE sort_list   AS CHARACTER NO-UNDO.
DEFINE VARIABLE in-end-date LIKE end-date NO-UNDO.

DEF TEMP-TABLE ttAcct NO-UNDO
   FIELD AcctCat        AS CHAR
   FIELD BSectCode      AS CHAR
   FIELD BSectName      AS CHAR
   FIELD BalAcct0Code   AS CHAR
   FIELD BalAcct0Name   AS CHAR
   FIELD BalAcct1Code   AS CHAR
   FIELD BalAcct1Name   AS CHAR
   FIELD BalAcct2       AS INT
   FIELD CustCat        AS CHAR
   FIELD CustId         AS INT
   FIELD Acct           AS CHAR
   FIELD Currency       AS CHAR
   FIELD AcctLastWith10 AS CHAR
   FIELD ShBal          AS DEC
   FIELD ShVal          AS DEC
   FIELD LastMoveDate   AS DATE
   FIELD AcctRecId      AS RECID
   FIELD SortAcct       AS CHAR
.

DEFINE VARIABLE vIInt         AS INTEGER   NO-UNDO.
DEFINE VARIABLE vCount        AS INTEGER   NO-UNDO.
DEFINE VARIABLE vMsgErrChar   AS CHARACTER NO-UNDO.
DEFINE VARIABLE vSortListChar AS CHARACTER NO-UNDO INIT "Вал;Ключ;Филиал;Номер".
DEFINE VARIABLE vSortAcctChar AS CHARACTER NO-UNDO.
DEFINE VARIABLE vCustInnChar  AS CHARACTER NO-UNDO.

DEFINE VARIABLE in-acct-cat        LIKE  acct.acct-cat FORMAT "x(40)"  NO-UNDO.
DEF VAR bac AS CHAR FORM "x(300)"   INIT "?" NO-UNDO.
DEF VAR cur AS CHAR FORM "x(30)"    INIT "?" NO-UNDO.

{pirraproc.def}

ASSIGN  
        beg-date = iBegDate
        end-date = iEndDate
        bac      = '*'
        cur      = '*'
        acc_list = REPLACE(GetEntries(1,iParam,",","*"),";",",")
        sort_list = REPLACE(GetEntries(2,iParam,",",vSortListChar),";",",")
.

IF GetSysConf("AUTOTEST:autotest") EQ "YES" THEN
   ASSIGN
      bac = GetSysConf("AUTOTEST:Счета 2 порядка")
      cur = GetSysConf("AUTOTEST:Валюта")
.

/* контроль полей сортировки */
DO vIInt = 1 TO NUM-ENTRIES(sort_list):
   IF LOOKUP(ENTRY(vIInt,sort_list),vSortListChar,";") = 0 THEN DO:
      PUT UNFORMAT PROGRAM-NAME(1)  "Ошибочен элемент второго параметра отчета!" SKIP(1)
              "в списке сортировки задан:" ENTRY(vIInt,sort_list) SKIP
              "Допустимы только значения:" SKIP
              vSortListChar.
      RETURN.
   END.
END.

/* построение отчета */
DO vCount = 1 TO NUM-ENTRIES(iBalCat):
   in-acct-cat = ENTRY(vCount,iBalCat).     
   
   &GLOB no-disp-all    YES
   &GLOB beg-date       iBegDate

   def var zerospace as logical format "Да/Нет" initial no no-undo.
   def var zeroskip  as logical format "Да/Нет" initial yes no-undo.

   {num-pril.i 6
            "ВЕДОМОСТЬ_ОСТАТКОВ||ПО_СЧЕТАМ_КРЕДИТНОЙ_ОРГАНИЗАЦИИ_РОССИЙСКОЙ_ФЕДЕРАЦИИ||НА_&2"
            {&*}
   }

   { modhead.i &out = "vHdrPril" &enddate = "end-date" }
   
   IF in-acct-cat EQ "b" THEN DO:
   	{pirraproc.i &arch_file_name="pril_6b.txt" &in-beg-date=iBegDate &in-end-date=iEndDate}
           	
   END. ELSE IF in-acct-cat EQ "o" THEN DO:
   	{pirraproc.i &arch_file_name="pril_6v.txt" &in-beg-date=iBegDate &in-end-date=iEndDate}
   END.
    
   {setdest.i &cols = 142 &filename=arch_file_name}
	 
   {pirposnew1s.rep}                       /* Формирование отчета       */


END. /* DO vIInt = 1 TO NUM-ENTRIES(iBalCat) */

{intrface.del}

{pir-log.i &module="$RCSfile: pir-pril6.p,v $" &comment="автоматическая выгрузка приложения №6"}