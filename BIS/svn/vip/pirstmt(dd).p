{pirsavelog.p}

/* ------------------------------------------------------
File          : $RCSfile: pirstmt(dd).p,v $ $Revision: 1.2 $ $Date: 2007-10-18 07:42:24 $
Copyright     : ООО КБ "Пpоминвестрасчет"
Базируется    : stmt(dd).p, при обновлениях переносить доработки
Причина       : Приказ №64 от 25.10.2005
Назначение    : Замена существовавших выписок pirstmt(dd)r.p pirstmt(dd)v.p
Параметры     : Имя файла для сохранения
Место запуска : БМ/Печать/Выходные формы/Отчеты по лицевым счетам/Выписки
Автор         : ???? 
Изменения     : $Log: not supported by cvs2svn $
Изменения     : Revision 1.1  2007/08/16 13:43:47  Lavrinenko
Изменения     : Замена 2-х процедур на@
Изменения     :
------------------------------------------------------ */
{globals.i}
{sh-defs.i}
{pick-val.i}
{chkacces.i}
{intrface.get print}
{intrface.get bag}

/* PIR begin */
DEF INPUT PARAM iFile AS CHAR NO-UNDO. /* имя фала */
{pirraproc.def}
&GLOB filename arch_file_name
/* PIR end */

{getdates.i}
{pirraproc.i &in-end-date=end-date &arch_file_name=iFile &arch_file_name_var=yes} /* PIR */

DEFINE VARIABLE mdtBegDate LIKE beg-date.
DEFINE VARIABLE mdtEndDate LIKE beg-date.

DEFINE VARIABLE mIsSeparate AS LOGICAL NO-UNDO. 

{get-bankname.i}
name-bank = cBankname .

mIsSeparate = FGetSetting("Выписки", "Порядок", "Счета") EQ "Выписка".

if end-date = ? then undo, retry.

ASSIGN mdtBegDate = beg-date /* изолируем даты, чтобы tempacct.i не попортил их */
       mdtEndDate = end-date.
{tempacct.i
   &tempacct_i = "YES"}
ASSIGN beg-date = mdtBegDate /* восстанавливаем испорченное */
       end-date = mdtEndDate.

{stmt.i new }

{getstmt.i}

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

{stmtview.i}
