{pirsavelog.p}

/* ------------------------------------------------------
File          : $RCSfile: pirposnew1s.p,v $ $Revision: 1.4 $ $Date: 2007-10-18 07:42:24 $
Copyright     : ООО КБ "Пpоминвестрасчет"
Базируется    : POSNEW1.P
Причина       : Приказ №64 от 25.10.2005
Назначение    : Автосохранение
Место запуска : Описание точки в ИБС "БИСКВИТ", откуда производится запуск процедуры
Автор         : buryagin 
Изменения     : $Log: not supported by cvs2svn $
Изменения     : Revision 1.3  2007/08/13 10:53:40  lavrinenko
Изменения     : *** empty log message ***
Изменения     :
Изменения     : Revision 1.2  2007/08/13 10:32:37  Lavrinenko
Изменения     : Добавлен стандартный заголовок
Изменения     :
              : 30.08.2006 buryagin 
              : Восстановлена функциональность автосохранения после "падения" от 22 патча.
------------------------------------------------------ */
{globals.i}
{norm.i new}
{intrface.get strng}
{intrface.get separate}

DEF INPUT PARAM iParam AS CHAR NO-UNDO. /* 1 параметр - список счетов 2-го порядка
                                             по которым выводить только сумму */
DEFINE VARIABLE acc_list  AS CHARACTER NO-UNDO.
DEFINE VARIABLE sort_list AS CHARACTER NO-UNDO.

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
DEFINE VARIABLE vMsgErrChar   AS CHARACTER NO-UNDO.
DEFINE VARIABLE vSortListChar AS CHARACTER NO-UNDO INIT "Вал;Ключ;Филиал;Номер".
DEFINE VARIABLE vSortAcctChar AS CHARACTER NO-UNDO.
DEFINE VARIABLE vCustInnChar  AS CHARACTER NO-UNDO.


acc_list = REPLACE(GetEntries(1,iParam,",","*"),";",",").
sort_list = REPLACE(GetEntries(2,iParam,",",vSortListChar),";",",").

DO WHILE TRUE :
   /* контроль полей сортировки */
   DO vIInt = 1 TO NUM-ENTRIES(sort_list):
      IF LOOKUP(ENTRY(vIInt,sort_list),vSortListChar,";") = 0 THEN
      DO:
         MESSAGE "Ошибочен элемент второго параметра отчета!" SKIP(1)
              "в списке сортировки задан:" ENTRY(vIInt,sort_list) SKIP
              "Допустимы только значения:" SKIP
              vSortListChar
         VIEW-AS ALERT-BOX.
         vMsgErrChar = "ERROR".
      END.
   END.
   IF vMsgErrChar = "ERROR" THEN LEAVE.

   &GLOB no-disp-all    YES
   &GLOB beg-date       end-date

   {getdate.i}
   {getbac.i}

   def var zerospace as logical format "Да/Нет" initial no no-undo.
   def var zeroskip  as logical format "Да/Нет" initial yes no-undo.

   run getzerzo.p (INPUT beg-date,
                   INPUT end-date,
                   INPUT-OUTPUT zerospace,
                   INPUT-OUTPUT zeroskip,
                   INPUT-OUTPUT flag-zo).

   {num-pril.i 6
            "ВЕДОМОСТЬ_ОСТАТКОВ||ПО_СЧЕТАМ_КРЕДИТНОЙ_ОРГАНИЗАЦИИ_РОССИЙСКОЙ_ФЕДЕРАЦИИ||НА_&2"
            {&*}
   }

   { modhead.i &out = "vHdrPril" &enddate = "end-date" }

   /** 30.08.2006 11:10 Бурягин закоментировал строку
   {setdest.i &cols = 142}
   */
   
	 /** 30.08.2006 11:11 Бурягин добавил код */
   DEF VAR in-end-date LIKE end-date.
   in-end-date = end-date.
   {pirraproc.def}
   IF in-acct-cat = "b" THEN DO:
   	{pirraproc.i &arch_file_name="pril_6b.txt"}
   END.

   IF in-acct-cat = "o" THEN DO:
   	{pirraproc.i &arch_file_name="pril_6v.txt"}
   END.
    
   {setdest.i &cols = 142 &filename=arch_file_name}
   /** Бурягин end */
	 
	 
	 
   {posnew1s.rep}                       /* Формирование отчета       */

   /** 30.08.2006 11:11 Бурягин закоментировал строку 
   {preview.i}
   */
   
   /** 30.08.2006 11:12 Бурягин добавил строку */
   {preview.i &filename=arch_file_name}

   LEAVE.
END. /* DO WHILE .T. */

{intrface.del}
