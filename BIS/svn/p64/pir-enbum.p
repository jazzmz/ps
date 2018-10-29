{pirsavelog.p}

/* ------------------------------------------------------
File          : $RCSfile: pir-enbum.p,v $ $Revision: 1.5 $ $Date: 2007-10-18 07:42:21 $
Copyright     : ООО КБ "Проминвестрасчет"
Базируется    : op-enbum.p
Причина       : Приказ №64 от 25.10.2005
Назначение    : Бухгалтерский журнал
Параметры     : - Начальная дата
              : - Конечная дата
              : - Код подразделения
              : - Имя файла
              : - Признак валюты 
              : - Дополнительные параметры процедуры через ","              
Место запуска : Планировщик задач, процедура pir-shdrep.p 
Автор         : $Author: anisimov $ 
Изменения     : $Log: not supported by cvs2svn $
Изменения     : Revision 1.4  2007/08/21 13:39:00  lavrinenko
Изменения     : Реализовано сохранение в месячные и годовые е каталоги
Изменения     :
Изменения     : Revision 1.3  2007/08/20 13:24:56  lavrinenko
Изменения     : Исправлени заголовка
Изменения     :
Изменения     : Revision 1.2  2007/08/16 14:08:30  Lavrinenko
Изменения     : Исправление описания
Изменения     :
Изменения     : Revision 1.1  2007/08/16 13:14:01  Lavrinenko
Изменения     : процедура формирования бухгалтерского журнала
Изменения     :
------------------------------------------------------ */
{op-enbum.def}
{intrface.get xclass}
{get-bankname.i}
DEF INPUT PARAM iBegDate    AS DATE NO-UNDO. /* Начальная дата         */
DEF INPUT PARAM iEndDate    AS DATE NO-UNDO. /* Конечная дата          */
DEF INPUT PARAM iBranch     AS CHAR NO-UNDO. /* Код подразделения      */
DEF INPUT PARAM iFile       AS CHAR NO-UNDO. /* передаваемое имя файла */
DEF INPUT PARAM iCurr       AS CHAR NO-UNDO. /* признак  */
DEF INPUT PARAM cldate_type AS CHAR NO-UNDO. /* параметры для op-enbum.p */

DEFINE VARIABLE mAcctDb LIKE op-entry.acct-db NO-UNDO.
DEFINE VARIABLE mAcctCr LIKE op-entry.acct-cr NO-UNDO.
DEFINE VARIABLE mMask   AS CHARACTER          NO-UNDO.
DEFINE VARIABLE mItem   AS INTEGER            NO-UNDO.

DEFINE VARIABLE mIsCatB AS LOGICAL INITIAL YES NO-UNDO.
DEFINE VARIABLE mIsCatO AS LOGICAL INITIAL YES NO-UNDO.
DEFINE VARIABLE mIsCatF AS LOGICAL INITIAL NO  NO-UNDO.
DEFINE VARIABLE mIsCatT AS LOGICAL INITIAL NO  NO-UNDO.
DEFINE VARIABLE mIsCatD AS LOGICAL INITIAL NO  NO-UNDO.
DEFINE VARIABLE mAsuPar AS CHARACTER           NO-UNDO.
DEFINE VARIABLE mNameDe AS CHARACTER           NO-UNDO.

&GLOB filename arch_file_name

{intrface.get separate}
{intrface.get strng}
{pirraproc.def}
/* разбор входных пар-ров по переменным */
ASSIGN
   us_type2 = ENTRY(1,cldate_type,";")
   us_type1 = IF NUM-ENTRIES(us_type2) GE 1
                 THEN ENTRY(1,us_type2)
                 ELSE "21"
   us_type2 = IF NUM-ENTRIES(us_type2) GE 2
                 THEN ENTRY(2,us_type2)
                 ELSE "23"
   gRemote  = YES          
   gbeg-date = iBegDate
   gend-date = iEndDate
   fullacct  = YES
   out-branch-id = ''
   list-branch-id = iBranch
.

/* запрос даты */
{getdate.i}

{pirraproc.i &in-beg-date=iBegDate &in-end-date=iEndDate &arch_file_name=iFile &arch_file_name_var=yes}

/* запрос подразделений */


&IF DEFINED(UserAndSlave) NE 0 &THEN
   DEFINE VARIABLE mI0       AS INTEGER   NO-UNDO.
   DEFINE VARIABLE mSlUserId AS CHARACTER NO-UNDO.
   DEFINE VARIABLE mFullList AS CHARACTER NO-UNDO.
   IF     list-id GT ""
      AND list-id NE "*" THEN
   DO mI0 = 1 TO NUM-ENTRIES(list-id):
      mFullList = mFullList + "," + getUserSlaves(ENTRY(mI0,list-id)).
   END.
   DO mI0 = 1 TO NUM-ENTRIES(mFullList):
      mSlUserId = ENTRY(mI0,mFullList).
      IF     mSlUserId NE ""
         AND mSlUserId NE "*"
         AND LOOKUP(mSlUserId,list-id) EQ 0 THEN
      DO:
         {additem.i list-id mSlUserId}
      END.
   END.
&ENDIF

DEF var vOpRubLog as logical init true no-undo.
def var vOpCurLog as logical init true no-undo.


ASSIGN 
   vOpRubLog = iCurr EQ "no"     
   vOpCurLog = NOT  vOpRubLog    
.
{setdest.i &cols=130}

/* заполнение xentry */
{op-enbum.i}

/* заполним tt-usr для 0018058
Иметь возможность получать журнал в разрезе подчиненности ответ. исполнителей.
То есть по пользователю и его подчиненным. */
&IF DEFINED(UserAndSlave) NE 0 &THEN
{justamin}
{op-enbum.i3}
&ENDIF

FORM
         xentry.doc-num
         xentry.acct-db
         xentry.acct-cr
         xentry.vamt
         xentry.amt
         xentry.user-name
         xentry.refer
WITH WIDTH 225 NO-LABEL FRAME fentry DOWN.

DO:
    pg-num = pg-num + 1.

   IF mIsCatB THEN
   DO:
      PAGE.
      RUN print-jur (cur_name[2], "b", YES).
   END.


   IF mIsCatO THEN
   DO:
    PAGE.
    RUN print-jur (cur_name[2], "o", YES).
   END.


   IF mIsCatF THEN
   DO:
      PAGE.
      RUN print-jur (cur_name[2], "f", NO).
   END.


   IF mIsCatD THEN
   DO:
      PAGE.
      RUN print-jur ("                                                             (по депозитарию)", "d", NO).
   END.


   IF mIsCatT THEN
   DO:
      PAGE.
      RUN print-jur (cur_name[2], "t", NO).
    END.
END.
{preview.i}
{intrface.del}
RETURN "".
/*----------------------------------------------------------------------------*/
/* Печать одной категории учета                                               */
/*----------------------------------------------------------------------------*/
PROCEDURE print-jur:
   DEF INPUT PARAM in-name2 AS CHAR NO-UNDO.
   DEF INPUT PARAM in-acct-cat LIKE op-entry.acct-cat NO-UNDO.
   DEF INPUT PARAM need_kas AS LOG NO-UNDO.

   DEFINE VARIABLE vCatName AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE in-name1 AS CHARACTER  NO-UNDO.

   DEF VAR oTable AS TTable NO-UNDO.

&IF DEFINED(UserAndSlave) NE 0 &THEN
/* определим список начальников по разделу отчета */
   mUserACat = "". 
   IF mUserBoss NE "" THEN
   DO:
      mI = LOOKUP(in-acct-cat,mUserBoss,"^") + 1.
      IF mI GT 1 THEN
         mUserACat = ENTRY(mI,mUserBoss,"^").
   END.
&ENDIF

   ASSIGN
      vCatName = fCatLabel (in-acct-cat, NO, end-date)
      in-name1 = 'Реестр бухгалтерских проводок по категории "' + LC (vCatName)
      in-name1 = in-name1 + '" за ' + {term2str end-date end-date}
      in-name2 = TRIM (in-name2)
      mNameDe  = FILL("_",35) + FILL(" ",85)
   .

   IF NUM-ENTRIES(list-branch-id) EQ 1 THEN
   DO:
      FIND FIRST branch WHERE branch.branch-id EQ list-branch-id NO-LOCK NO-ERROR.

      IF AVAILABLE branch THEN
         mNameDe  = branch.name.
   END.


   PUT UNFORMATTED
      dept.name-bank SKIP
      "Дополнительный офис (подразделение)                                                                                              Ежедн." skip
      mNameDe FORMAT "x(120)"  " руб." SKIP(2)
      fStrCenter (in-name1, 135) FORMAT "x(135)" SKIP
      fStrCenter (in-name2, 135) FORMAT "x(135)" SKIP (1)
      "┌──────┬─────────────────────────┬─────────────────────────┬─────────────────┬─────────────────┬─────────────────────────┬───────────┐"  skip
      "│ Номер│   Номер лицевого счета  │ Номер лицевого счета    │     Сумма       │" fStrCenter ("Сумма в {&in-LP-C6}", 17) FORMAT "x(17)"
                                                                                                     "│          Ф.И.О.         │  Референс │"     skip
      "│ доку-│      по дебету          │    по кредиту           │     в ин.       │" fStrCenter ("и {&in-LP-DecC6}", 17)   FORMAT "x(17)"
                                                                                                     "│    Ответ исполнителя    │  подразде-│"     skip
      "│ мента│                         │                         │     валюте      │                 │                         │  ления    │"  skip
      "├──────┼─────────────────────────┼─────────────────────────┼─────────────────┼─────────────────┼─────────────────────────┼───────────┤"  skip
      "│   1  │            2            │             3           │        4        │         5       │            6            │     7     │"  skip
      "├──────┼─────────────────────────┼─────────────────────────┼─────────────────┼─────────────────┼─────────────────────────┼───────────┤"  skip (1).

       /*with centered no-box no-labels width 225.*/


    DEF VAR dSumByC   AS DECIMAL INITIAL 0.
    DEF VAR dCountByC AS DECIMAL INITIAL 0.
    DEF VAR dItogPRur    AS DECIMAL INITIAL 0. /* Итог по переоценке */
    DEF VAR dItogPVal    AS DECIMAL INITIAL 0. /* Итог по переоценке */
    DEF VAR dItogPC    AS DECIMAL INITIAL 0. /* Итог по переоценке */


    PUT UNFORMATTED  SKIP(1)
       "1. Мемориальные и иные документы" SKIP.

    IF in-acct-cat = "d" THEN cur_txt = "".
    ELSE cur_txt = " по мемориальным и иным документам: ".

    FOR EACH xentry WHERE xentry.acct-cat = in-acct-cat AND
                          xentry.doc-type EQ NO AND
                          xentry.prnum < 3
       {op-enbum.i2 mem}
    END.

/*
    cur_txt = "автоматическим документам".
    FOR EACH xentry WHERE xentry.acct-cat = in-acct-cat AND
                          xentry.doc-type EQ NO AND
                          xentry.prnum = 3
       {op-enbum.i2 mem}
    END.
*/

    IF in-acct-cat = "d" THEN cur_txt = "Итого по филиалу: ".
    ELSE cur_txt = "Итого по филиалу по мемориальным и иным документам: ".

    IF chk_all THEN
      PUT UNFORMATTED SKIP(1)
           cur_txt  FORMAT "x(77)"
           " " mem-amt FORMAT "->,>>>,>>>,>>9.99"  SKIP
           "Кол-во проводок: "
           mem-num FORMAT ">>>,>>9"
           SKIP.


    IF need_kas THEN DO:

       PUT UNFORMATTED  SKIP(1)
          "2. Кассовые документы" SKIP.

       cur_txt = " по кассовым документам: ".
       FOR EACH xentry WHERE xentry.acct-cat = in-acct-cat AND
                             xentry.doc-type
                         AND xentry.prnum < 3
          {op-enbum.i2 kas}
       END.

/*
       cur_txt = "автоматическим документам".
       FOR EACH xentry WHERE xentry.acct-cat = in-acct-cat AND
                             xentry.doc-type
                         AND xentry.prnum = 3
          {op-enbum.i2 kas}
       END.
*/

       IF chk_all THEN
         PUT UNFORMATTED SKIP(1)
            "Итого по филиалу по кассовым документам: " FORMAT "x(77)"
            " " kas-amt FORMAT "->,>>>,>>>,>>9.99" SKIP
            "Кол-во проводок: "
            kas-num FORMAT ">>>,>>9" SKIP.
    END.

    cur_txt = " автоматическим документам ".
    FOR EACH xentry WHERE xentry.acct-cat = in-acct-cat
                      AND xentry.prnum = 3
       {op-enbum.i2 aut}
    END.

    PUT UNFORMATTED SKIP(1)
       'Всего по филиалу по категории "' + LC (vCatName) + '": ' FORMAT "x(77)"
       " " kas-amt + mem-amt + aut-amt FORMAT "->,>>>,>>>,>>9.99" SKIP
       "Кол-во проводок: "
       kas-num + mem-num + aut-num FORMAT ">>>,>>9" SKIP.


    /* подпись */
    FIND FIRST _user WHERE _user._userid = userid('bisquit')
       NO-LOCK NO-ERROR.

    PUT UNFORMATTED SKIP(1) "Руководитель подразделения  " FORMAT "x(28)"

       IF AVAIL _user
         THEN GetXattrValue("branch", GetUserBranchId(_user._userid), "ФИОРукПодр")
         ELSE ""

       SKIP(1) "Ответственный исполнитель " FORMAT "x(28)"

       IF AVAILABLE _user
         THEN _user._user-name
         ELSE ""
       SKIP(1) "Конец формы" SKIP.
   IF PAGE-NUMBER GT 0 THEN
      PUT UNFORMATTED
        "Всего листов " PAGE-NUMBER - befor_num_page SKIP.
   PUT UNFORMATTED
        "Даты выдачи формы " STRING(TODAY,"99/99/9999") SKIP(1).
   ASSIGN
        mem-amt  = 0
        mem-num  = 0
        kas-amt  = 0
        kas-num  = 0
        aut-amt  = 0
        aut-num  = 0
        befor_num_page = PAGE-NUMBER
   .
END PROCEDURE.


