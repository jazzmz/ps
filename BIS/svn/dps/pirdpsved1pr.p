/*{pirsavelog.p}*/

/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-1999 ТОО "Банковские информационные системы"
     Filename: DPSVED1.P
      Comment: Ведомось  по вкладам.
   Parameters:
      Created: 10/12/2001 shin
     Modified:
     Modified: 20/03/2003 KOSTIK Заявка 14605 Подъем заявки (13066)
                                 (03/02/2003 Guva Исправлена логическая ошибка )
                                 (при выборе даты, на которую берется          )
                                 (процентная ставка з. 0013066                 )

     Modified: 21/05/2003 koag   Исправлена ошибка: несоответстви счета остатку 
                                 в случае, если дата рассчета больше, чем дата 
                                 пролонгации.

     Modified:
*/

Form
    "~n@(#) DPSVED1.P 1.0 shin 06/11/01"
with frame sccs-id stream-io width 250.
{globals.i}
{ksh-defs.i new}
{sh-defs.i}
{tmprecid.def}
{def_work.i new}    /* Необходимо для nachtool.p */

{prn-ved.i &DefTempTable = "Объявляем временную таблицу"}

DEF VAR vResult     AS DEC                   NO-UNDO.
DEF VAR vResult1    AS DEC                   NO-UNDO.
DEF VAR vFlag       AS INT                   NO-UNDO.
def var result      like    acct-pos.balance no-undo.
def var RESULT_na_opendate like    acct-pos.balance no-undo.
def var proc-qty    like comm-rate.rate-comm no-undo.
def var name        as char                  no-undo.
def var in-kau      as char                  no-undo.
def var in-k        as char extent 2         no-undo.
def var l-acct      as char                  no-undo.
DEF VAR vTmpAcct    AS CHAR                  NO-UNDO.
DEF VAR vCommi      AS CHAR                  NO-UNDO.
DEF VAR in-interest AS CHAR                  NO-UNDO.
define var vCommHandle as handle             no-undo.  /* Указатель на библиотеку комиссий */
DEFINE VARIABLE vBegDate AS DATE             NO-UNDO. /*виртуальная дата открытия вклада*/
DEFINE VARIABLE vEndDate AS DATE             NO-UNDO. /*виртуальная дата окончания вклада*/

define var vKindDate     as date             no-undo. /* Дата открытия/пролонгации вклада */
define var vKindChar     AS char             no-undo. /* Код транзакции
                                                       ** открытия/пролонгации */
define var vTemplInt     as int              no-undo. /* Номер шаблона карточки */
define var vLongInt      as int              no-undo. /* Продолжительность вклада в днях */
DEFINE VAR vMaxLoan      AS INTEGER          NO-UNDO.
DEFINE VAR vCurLoan      AS INTEGER          NO-UNDO.
def buffer bloan-acct for loan-acct.

DEF VAR tmp-ksh-bal LIKE ksh-bal NO-UNDO. 
DEF VAR tmp-ksh-val LIKE ksh-val NO-UNDO. 

/* Buryagin start 14/11/2004: added total count and total sum.*/
DEF VAR totalCount AS integer NO-UNDO.
DEF VAR totalSum LIKE acct-pos.balance NO-UNDO.


def stream err-log.
{intrface.get date}  /* Подключение инструментария работы с датами */
{dpsproc.def get-ost
             chk_date
             get-beg-date
             get-end-date
             Get_Param
             Get_Op-templ
}

{intrface.get "loan"}

{getdate.i} /* Ввод даты, подсказка по календарю */

run LOAD_NACHTOOL (Yes, output vCommHandle).

{setdest2.i &stream="stream err-log" &filename="spool.tmp " &cols=160}

FORM
    loan.cont-code
    vTmpAcct       FORMAT "x(20)"    column-label "РАСЧЕТНЫЙ СЧЕТ"
    loan.open-date form "99/99/9999" column-label "ДАТА ОТКРЫТИЯ"
    loan.end-date  form "99/99/9999" column-label "ДАТА ЗАКРЫТИЯ"
    RESULT                           column-label "ОСТАТОК"
    RESULT_na_opendate               column-label "ОСТАТОК (на откр.)"
    proc-qty     column-label "СТАВКА %"
    name           format "x(20)"    column-label "ФАМИЛИЯ"
    header  skip
    dept.name-bank "СТР.:" at 138
    page-number (err-log) format ">>9" at 144 skip (2)
with frame prn-log down width 160 title "ВЕДОМОСТЬ ПО ВКЛАДАМ" + " ЗА: " + string(end-date).

FOR EACH tmprecid NO-LOCK,
    FIRST loan WHERE RECID(loan) EQ tmprecid.id
                                        NO-LOCK:
      vMaxLoan = vMaxLoan + 1.
END.
{init-bar.i " "}

loan_:
FOR EACH tmprecid NO-LOCK,
    FIRST loan WHERE RECID(loan)      EQ tmprecid.id NO-LOCK
    transaction on error  undo loan_, leave loan_
            on endkey undo loan_, leave loan_ with frame prn-log :
      /* Buryagin added the next line */
      totalCount = totalCount + 1.
      pause 0.
      proc-qty = 0.
      vCurLoan = vCurLoan + 1.
      {move-bar.i vCurLoan vMaxLoan}
      run RE_CURRENT_KIND IN h_dpspc(
          recid(loan),        /* Идентификатор договора */
          end-date,          /* Дата, на которую "хочу все знать" */
          output vKindDate,   /* Дата пролонгации/открытия */
          output vKindChar,   /* Код транзакции пролонгации/открытия */
          output vTemplInt).  /* Номер шаблона карточки */

      RUN get-beg-date-prol IN h_dpspc (RECID(loan), 
                                                end-date, 
                                                OUTPUT vBegDate, 
                                                OUTPUT vEndDate).
      FIND FIRST op-templ
         WHERE op-templ.op-kind EQ vKindChar
           AND loan.op-templ    EQ vTemplInt
      NO-LOCK NO-ERROR.

      FIND LAST loan-acct OF loan
         WHERE loan-acct.acct-type EQ "loan-dps-t"
           AND loan-acct.since     LE end-date
      NO-LOCK NO-ERROR.
      IF NOT AVAIL loan-acct THEN
      FIND LAST loan-acct OF loan
         WHERE loan-acct.acct-type EQ "loan-dps-p"
           AND loan-acct.since     LE end-date
      NO-LOCK NO-ERROR.
      IF NOT AVAIL loan-acct THEN NEXT.

      FIND FIRST acct
          WHERE acct.acct     EQ loan-acct.acct
            AND acct.currency EQ loan-acct.currency
      NO-LOCK NO-ERROR.
      IF NOT AVAIL acct THEN NEXT.
      if not avail op-templ then next .
      if vEndDate eq ? then
            assign in-k[1] = 'ОстВклВ'
                      in-k[2] = 'НачПрВ'
                      l-acct  = 'loan-dps-p'.
      else
            assign
              in-k[1] = 'ОстВклС'
              in-k[2] = 'НачПрС1'
              l-acct  = 'loan-dps-t'.
      find last bloan-acct of loan where 
                      bloan-acct.acct-type eq l-acct
                      and bloan-acct.since     le end-date
                      no-lock no-error.
      IF avail bloan-acct then do:
        in-kau = loan.contract + ',' + loan.cont-code + ',' + in-k[1].
        run kau-pos.p(bloan-acct.acct,
                      bloan-acct.currency,
                      end-date,
                      end-date,
                      gop-status,
                      in-kau).
	result = if loan.currency  = '' then ksh-bal else ksh-val.

        RUN acct-pos IN h_base (bloan-acct.acct, 
				bloan-acct.currency,
				loan.open-date,
				loan.open-date,
				chr(251)).
        result_na_opendate = if loan.currency  = '' then sh-bal else sh-val.
         
	/* Buryagin added the next line */
	/* totalSum = totalSum + result.*/
        ASSIGN
           tmp-ksh-bal = ksh-bal
           tmp-ksh-val = ksh-val.
        in-kau = loan.contract + ',' + loan.cont-code + ',' + in-k[2].
        /*Рассчет начисленных процентов*/
        RUN kau-pos.p (bloan-acct.acct,
                       bloan-acct.currency,
                       end-date,
                       end-date,
                       gop-status,
                       in-kau).
        result = result + IF loan.currency  = '' THEN ksh-bal ELSE ksh-val.

        RUN acct-pos IN h_base (bloan-acct.acct, 
				bloan-acct.currency,
				loan.open-date,
				loan.open-date,
				chr(251)).
        result_na_opendate = if loan.currency  = '' then sh-bal else sh-val.

	/* Buryagin added the next line */
	totalSum = totalSum + result.

        ASSIGN
           ksh-bal = tmp-ksh-bal
           ksh-val = tmp-ksh-val.
           vTmpAcct = bloan-acct.acct.
      end.
      ELSE
         ASSIGN vTmpAcct = "                   ?".

      find last person where
                      person.person-id = loan.cust-id
                      no-lock no-error.
      if avail person then name = name-last + " " + first-names.
      else                 name = "?".

      /* Определение кода ставки */
      run Get_Last_Commi IN h_dpspc (recid(loan),
                                             vBegDate,
                                             vBegDate,
                                             output vCommi).
      
      if vCommi = ? or vCommi = '?' then do :
         ASSIGN proc-qty = ?.
         display stream err-log
           loan.cont-code
           vTmpAcct
           loan.open-date
           loan.end-date
           result format "zz,zzzzzz,zzzzz9.99 Дб"
              when result > 0  @ result
           - result format "zz,zzzzzz,zzzzz9.99 Кр"
              when result < 0  @ result
        result_na_opendate format "zz,zzzzzz,zzzzz9.99 Дб"
           when result_na_opendate >= 0  @ result_na_opendate
        - result_na_opendate format "zz,zzzzzz,zzzzz9.99 Кр"
           when result_na_opendate < 0  @ result_na_opendate
           proc-qty
           name with frame prn-log .
         down stream err-log.
         NEXT loan_.
      end.
      

      /* Определение кода схемы начисления*/
      run Get_Last_Inter IN h_dpspc (recid(loan),
                                             end-date,
                                             end-date,
                                             output in-interest).
      
      IF in-interest = ? OR in-interest = '?'  THEN DO:
         ASSIGN proc-qty = ?.
         display stream err-log
           loan.cont-code
           vTmpAcct
           loan.open-date
           loan.end-date
           result format "zz,zzzzzz,zzzzz9.99 Дб"
              when result > 0  @ result
           - result format "zz,zzzzzz,zzzzz9.99 Кр"
              when result < 0  @ result
        result_na_opendate format "zz,zzzzzz,zzzzz9.99 Дб"
           when result_na_opendate >= 0  @ result_na_opendate
        - result_na_opendate format "zz,zzzzzz,zzzzz9.99 Кр"
           when result_na_opendate < 0  @ result_na_opendate
           proc-qty
           name with frame prn-log .
         down stream err-log.
         NEXT loan_.
      END.
      
      /*реальная продолжительность вклада*/
     IF vEndDate = ?  THEN vLongInt = 0.
     ELSE run depos-dep-period in h_dpspc (recid(loan), 
                                                   end-date,
                                                   output vLongInt) .
     IF vLongInt < 0 THEN vLongInt = 0.
     release comm-rate.
     /*Поиск схемы начисления*/
     { findsch.i
       &dir    = last
       &sch    = in-interest
       &since1 = " <= beg-date"}
        
     IF NOT  AVAILABLE interest-sch-line then DO:
        ASSIGN proc-qty = ?.
        display stream err-log
           loan.cont-code
           vTmpAcct
           loan.open-date
           loan.end-date
           result format "zz,zzzzzz,zzzzz9.99 Дб"
              when result > 0  @ result
           - result format "zz,zzzzzz,zzzzz9.99 Кр"
              when result < 0  @ result
        result_na_opendate format "zz,zzzzzz,zzzzz9.99 Дб"
           when result_na_opendate >= 0  @ result_na_opendate
        - result_na_opendate format "zz,zzzzzz,zzzzz9.99 Кр"
           when result_na_opendate < 0  @ result_na_opendate
           proc-qty
           name with frame prn-log .
        down stream err-log.
        NEXT loan_.
     END.
     
     SUBSCRIBE "publish-comm"  ANYWHERE RUN-PROCEDURE "GetComm".

     in-kau = loan.contract + ',' + loan.cont-code + ',' + in-k[1].
     RUN nachki(RECID(interest-sch-line),
                      vCommi,
                      RECID(acct),
                      end-date,
                      in-kau,
                      NO,
                      OUTPUT vResult,
                      OUTPUT vResult1,
                      INPUT-OUTPUT vBegDate,
                      OUTPUT vFlag) NO-ERROR.

     IF NOT AVAIL comm-rate THEN 
        ASSIGN proc-qty = ?.

     display stream err-log
        loan.cont-code
        vTmpAcct
        loan.open-date
        loan.end-date
        result format "zz,zzzzzz,zzzzz9.99 Дб"
           when result >= 0  @ result
        - result format "zz,zzzzzz,zzzzz9.99 Кр"
           when result < 0  @ result
        result_na_opendate format "zz,zzzzzz,zzzzz9.99 Дб"
           when result_na_opendate >= 0  @ result_na_opendate
        - result_na_opendate format "zz,zzzzzz,zzzzz9.99 Кр"
           when result_na_opendate < 0  @ result_na_opendate
        proc-qty
        name with frame prn-log .
     down stream err-log.
end.
{dpsproc.def END-USE-PROC}

/* Удаление указателя на библиотеку инструментов Comm */
run REMOVE_NACHTOOL (Yes, vCommHandle).

find _user where _user._userid eq userid('bisquit') no-lock no-error.

/* Buryagin added the next code */
put stream err-log unformatted skip (1) "Итого:        кол-во:" totalCount format ">>>>>>>>"
"                                           ".
if totalSum > 0 then 
    put stream err-log unformatted totalSum format "zz,zzzzzz,zzzzz9.99" " Дб".
if totalSum < 0 then
    put stream err-log unformatted  - totalSum format "zz,zzzzzz,zzzzz9.99" " Кр".
if totalSum = 0 then
    put stream err-log unformatted totalSum format "zz,zzzzzz,zzzzz9.99".
/* Buryagin end */    

display stream err-log skip (2) "Исполнитель:"
    "_________________________" at 20
    _user._user-name format "x(30)"  no-label at 48.

{preview2.i &stream="stream err-log" &filename="spool.tmp"}
{intrface.del }

/*Определение ставки через запуск схемы начисления*/
PROCEDURE nachki:
  &GLOB use-tt use-tt
  {nachkin.p}
END.

/*Определение "параметров начисления" */
PROCEDURE GetComm.
   DEFINE INPUT PARAMETER iRecComm   AS RECID NO-UNDO. /*recid записи %% ставки*/
   DEFINE INPUT PARAMETER iValComm   AS DEC   NO-UNDO. /*значение %% ставки*/
   FIND FIRST comm-rate WHERE RECID(comm-rate) = iRecComm NO-LOCK NO-ERROR.
   ASSIGN
    proc-qty = iValComm.
END.
