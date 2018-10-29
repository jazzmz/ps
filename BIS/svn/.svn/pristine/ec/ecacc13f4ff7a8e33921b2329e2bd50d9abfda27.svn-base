{pirsavelog.p}
/** 
   ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (с) 2009

   Формирование .
   Борисов А.В., 20.07.2010
*/

{globals.i}           /* Глобальные определения */
{tmprecid.def}        /* Используем информацию из броузера */
{lshpr.pro}           /* Инструменты для расчета параметров договора */
{ulib.i}
{utilities.def}
/*
{lshpr.pro}
*/
/*******************************************  */
FUNCTION OsnKard RETURNS CHARACTER (
   INPUT icContract AS CHARACTER,
   INPUT icContCode AS CHARACTER).

   DEFINE BUFFER   bLAcct FOR loan-acct.
   DEFINE BUFFER   bLoan  FOR loan.
   DEFINE VARIABLE cKard  AS CHARACTER  NO-UNDO.

   FOR EACH loan-acct
      WHERE (loan-acct.contract  EQ icContract)
        AND (loan-acct.cont-code EQ icContCode)
        AND (loan-acct.acct-type EQ "КредРасч")
      NO-LOCK
      BY loan-acct.since DESCENDING:

      FOR EACH bLAcct
         WHERE (bLAcct.acct      EQ loan-acct.acct)
           AND (bLAcct.currency  EQ loan-acct.currency)
           AND (bLAcct.acct-type EQ "SCS@" + loan-acct.currency)
         NO-LOCK
         BY bLAcct.since DESCENDING:

         FOR EACH bLoan
            WHERE (bLoan.parent-contract  EQ bLAcct.contract)
              AND (bLoan.parent-cont-code EQ bLAcct.cont-code)
              AND (bLoan.loan-status      EQ "АКТ")
              AND bLoan.loan-work
            NO-LOCK:

            cKard = bLoan.doc-num.
            SUBSTRING(cKard, 5, 8) = "********".

            RETURN ", Карта " + GetCodeName("КартыБанка", bLoan.sec-code) + " № " + cKard.
         END.

         LEAVE.
      END.

      LEAVE.
   END.

   RETURN "".
END.

/******************************************* Определение переменных и др. */
DEFINE VARIABLE cKlName   AS CHARACTER          NO-UNDO.
DEFINE VARIABLE cCurr     AS CHARACTER          NO-UNDO.
DEFINE VARIABLE dKurs     AS DECIMAL            NO-UNDO.
DEFINE VARIABLE dStr      AS DECIMAL  EXTENT 7  NO-UNDO.
DEFINE VARIABLE daTmp     AS DATE               NO-UNDO.
DEFINE VARIABLE daRs      AS DATE               NO-UNDO.

def buffer transh for loan.
def var d8 as dec NO-UNDO.
def var d4 as dec NO-UNDO.
def var dsum4 as dec NO-UNDO.
def var dsum8 as dec NO-UNDO.
def var dTMP as dec NO-UNDO.


/******************************************* Реализация */

FOR FIRST tmprecid
   NO-LOCK,
   FIRST loan
      WHERE (RECID(loan) EQ tmprecid.id)
        AND (loan.cont-code BEGINS "ПК")
        AND NUM-ENTRIES(loan.cont-code, " ") EQ 1
      NO-LOCK:

   IF (loan.cust-cat EQ "Ч")
   THEN DO:
      FIND FIRST person
         WHERE (person.person-id EQ loan.cust-id)
         NO-LOCK NO-ERROR.
      cKlName = person.name-last + " " + person.first-names.
   END.
   ELSE DO:
      FIND FIRST cust-corp
         WHERE (cust-corp.cust-id EQ loan.cust-id)
         NO-LOCK NO-ERROR.
      cKlName = cust-corp.cust-stat + " " + cust-corp.name-corp.
   END.

   cCurr    = IF (loan.currency EQ "") THEN "810" ELSE loan.currency.
   end-date = loan.since.
   {getdate.i &noinit=YES}
   daRs     = end-date.

   IF (daRs NE loan.since)
   THEN DO:
      RUN "d-lcal(.p" ('Кредит', daRs).
      RUN "sum-in(.p" ('Кредит').
   END.

   dKurs = GetDateCourse(loan.currency, daRs).

   dsum8 = 0.
   dsum4 = 0.

   for each transh where transh.contract = loan.contract and transh.cont-code begins loan.cont-code and transh.cont-code <> loan.cont-code and transh.close-date = ? and transh.class-code = "loan_trans_diff" NO-Lock:
        RUN STNDRT_PARAM(transh.contract, transh.cont-code, 8, daRs, OUTPUT d8, OUTPUT dTMP, OUTPUT dTMP).


/*        RUN GET_PARAM(transh.contract, transh.cont-code, 8, daRs, OUTPUT d8, OUTPUT daTmp).*/

        RUN GET_PARAM(transh.contract, transh.cont-code, 4, daRs, OUTPUT d4, OUTPUT daTmp).

        dsum8 = dsum8 + d8 + transh.interest[2].
        dsum4 = dsum4 + d4 + transh.interest[1].
        d8 = 0.
        d4 = 0.

   end.

   dStr[1] = dsum8.
   dStr[4] = dsum4.


/*   dStr[1] = dStr[1] + loan.interest[2].*/

   dStr[2] = GetAcctPosValueEx_UAL(GetLoanAcct_ULL(loan.contract, loan.cont-code, "КредПр%",  daRs, NO),
                                   loan.currency, daRs, "√", NO)
           + GetAcctPosValueEx_UAL(GetLoanAcct_ULL(loan.contract, loan.cont-code, "КредПр%В", daRs, NO),
                                   loan.currency, daRs, "√", NO).
   dStr[3] = GetAcctPosValueEx_UAL(GetLoanAcct_ULL(loan.contract, loan.cont-code, "КредПр",   daRs, NO),
                                   loan.currency, daRs, "√", NO).




  /* dStr[4] = dStr[4] + loan.interest[1].*/

   dStr[5] = GetAcctPosValueEx_UAL(GetLoanAcct_ULL(loan.contract, loan.cont-code, "КредТ",    daRs, NO),
                                   loan.currency, daRs, "√", NO)
           + GetAcctPosValueEx_UAL(GetLoanAcct_ULL(loan.contract, loan.cont-code, "КредТВ",   daRs, NO),
                                   loan.currency, daRs, "√", NO).
   dStr[6] = GetAcctPosValueEx_UAL(GetLoanAcct_ULL(loan.contract, loan.cont-code, "Кредит",   daRs, NO),
                                   loan.currency, daRs, "√", NO).
   dStr[7] = dStr[1] + dStr[2] + dStr[3] + dStr[4] + dStr[5] + dStr[6].

   FIND FIRST _user
      WHERE (_user._userid = USERID)
      NO-LOCK NO-ERROR.

   {setdest.i}
   PUT UNFORMATTED 
      SPACE(10) "Задолженность по договору № " + loan.cont-code + " на " STRING(daRs, "99.99.9999") SKIP
      cKlName + OsnKard(loan.contract, loan.cont-code) SKIP(1)
      "┌───┬───────────────────────────────┬──────┬───────────────┬───────────────┐" SKIP
      "│ N │   Название задолженности      │Валюта│ Значение (вал)│ Значение (руб)│" SKIP
      "├───┼───────────────────────────────┼──────┼───────────────┼───────────────┤" SKIP
      "│ 1 │Штр.%% за просроч.задолженность│  " cCurr FORMAT "x(3)" " │" 
      dStr[1] FORMAT "->>>,>>>,>>9.99" "│" ROUND(dStr[1] * dKurs, 2) FORMAT "->>>,>>>,>>9.99" "│" SKIP
      "│ 2 │Просроченные %%                │  " cCurr FORMAT "x(3)" " │" 
      dStr[2] FORMAT "->>>,>>>,>>9.99" "│" ROUND(dStr[2] * dKurs, 2) FORMAT "->>>,>>>,>>9.99" "│" SKIP
      "│ 3 │Просроч.ссудная задолженность  │  " cCurr FORMAT "x(3)" " │" 
      dStr[3] FORMAT "->>>,>>>,>>9.99" "│" ROUND(dStr[3] * dKurs, 2) FORMAT "->>>,>>>,>>9.99" "│" SKIP
      "│ 4 │Основные %%                    │  " cCurr FORMAT "x(3)" " │" 
      dStr[4] FORMAT "->>>,>>>,>>9.99" "│" ROUND(dStr[4] * dKurs, 2) FORMAT "->>>,>>>,>>9.99" "│" SKIP
      "│ 5 │Начисленные %%                 │  " cCurr FORMAT "x(3)" " │" 
      dStr[5] FORMAT "->>>,>>>,>>9.99" "│" ROUND(dStr[5] * dKurs, 2) FORMAT "->>>,>>>,>>9.99" "│" SKIP
      "│ 6 │Ссудная задолженность          │  " cCurr FORMAT "x(3)" " │" 
      dStr[6] FORMAT "->>>,>>>,>>9.99" "│" ROUND(dStr[6] * dKurs, 2) FORMAT "->>>,>>>,>>9.99" "│" SKIP
      "├───┼───────────────────────────────┼──────┼───────────────┼───────────────┤" SKIP
      "│   │   Задолженность ВСЕГО:        │  " cCurr FORMAT "x(3)" " │" 
      dStr[7] FORMAT "->>>,>>>,>>9.99" "│" ROUND(dStr[7] * dKurs, 2) FORMAT "->>>,>>>,>>9.99" "│" SKIP
      "└───┴───────────────────────────────┴──────┴───────────────┴───────────────┘" SKIP(2)
      "Исполнитель __________________ / " + _user._user-name + " /" SKIP
      STRING(TODAY, "99.99.9999") + "  " + STRING(TIME, "HH:MM") SKIP(5)
      .

   dStr[2] = GetAcctPosValueEx_UAL(GetLoanAcct_ULL(loan.contract, loan.cont-code, "КредПр%",  daRs, NO),
                                   loan.currency, daRs, "К", NO)
           + GetAcctPosValueEx_UAL(GetLoanAcct_ULL(loan.contract, loan.cont-code, "КредПр%В", daRs, NO),
                                   loan.currency, daRs, "К", NO).
   dStr[3] = GetAcctPosValueEx_UAL(GetLoanAcct_ULL(loan.contract, loan.cont-code, "КредПр",   daRs, NO),
                                   loan.currency, daRs, "К", NO).

   dStr[5] = GetAcctPosValueEx_UAL(GetLoanAcct_ULL(loan.contract, loan.cont-code, "КредТ",    daRs, NO),
                                   loan.currency, daRs, "К", NO)
           + GetAcctPosValueEx_UAL(GetLoanAcct_ULL(loan.contract, loan.cont-code, "КредТВ",   daRs, NO),
                                   loan.currency, daRs, "К", NO).
   dStr[6] = GetAcctPosValueEx_UAL(GetLoanAcct_ULL(loan.contract, loan.cont-code, "Кредит",   daRs, NO),
                                   loan.currency, daRs, "К", NO).
   dStr[7] = dStr[1] + dStr[2] + dStr[3] + dStr[4] + dStr[5] + dStr[6].

   FIND FIRST _user
      WHERE (_user._userid = USERID)
      NO-LOCK NO-ERROR.

   PUT UNFORMATTED 
      "По непроведенным документам :" SKIP(1)
      SPACE(10) "Задолженность по договору № " + loan.cont-code + " на " STRING(daRs, "99.99.9999") SKIP
      cKlName + OsnKard(loan.contract, loan.cont-code) SKIP(1)
      "┌───┬───────────────────────────────┬──────┬───────────────┬───────────────┐" SKIP
      "│ N │   Название задолженности      │Валюта│ Значение (вал)│ Значение (руб)│" SKIP
      "├───┼───────────────────────────────┼──────┼───────────────┼───────────────┤" SKIP
      "│ 1 │Штр.%% за просроч.задолженность│  " cCurr FORMAT "x(3)" " │" 
      dStr[1] FORMAT "->>>,>>>,>>9.99" "│" ROUND(dStr[1] * dKurs, 2) FORMAT "->>>,>>>,>>9.99" "│" SKIP
      "│ 2 │Просроченные %%                │  " cCurr FORMAT "x(3)" " │" 
      dStr[2] FORMAT "->>>,>>>,>>9.99" "│" ROUND(dStr[2] * dKurs, 2) FORMAT "->>>,>>>,>>9.99" "│" SKIP
      "│ 3 │Просроч.ссудная задолженность  │  " cCurr FORMAT "x(3)" " │" 
      dStr[3] FORMAT "->>>,>>>,>>9.99" "│" ROUND(dStr[3] * dKurs, 2) FORMAT "->>>,>>>,>>9.99" "│" SKIP
      "│ 4 │Основные %%                    │  " cCurr FORMAT "x(3)" " │" 
      dStr[4] FORMAT "->>>,>>>,>>9.99" "│" ROUND(dStr[4] * dKurs, 2) FORMAT "->>>,>>>,>>9.99" "│" SKIP
      "│ 5 │Начисленные %%                 │  " cCurr FORMAT "x(3)" " │" 
      dStr[5] FORMAT "->>>,>>>,>>9.99" "│" ROUND(dStr[5] * dKurs, 2) FORMAT "->>>,>>>,>>9.99" "│" SKIP
      "│ 6 │Ссудная задолженность          │  " cCurr FORMAT "x(3)" " │" 
      dStr[6] FORMAT "->>>,>>>,>>9.99" "│" ROUND(dStr[6] * dKurs, 2) FORMAT "->>>,>>>,>>9.99" "│" SKIP
      "├───┼───────────────────────────────┼──────┼───────────────┼───────────────┤" SKIP
      "│   │   Задолженность ВСЕГО:        │  " cCurr FORMAT "x(3)" " │" 
      dStr[7] FORMAT "->>>,>>>,>>9.99" "│" ROUND(dStr[7] * dKurs, 2) FORMAT "->>>,>>>,>>9.99" "│" SKIP
      "└───┴───────────────────────────────┴──────┴───────────────┴───────────────┘" SKIP(2)
      "Исполнитель __________________ / " + _user._user-name + " /" SKIP
      STRING(TODAY, "99.99.9999") + "  " + STRING(TIME, "HH:MM") SKIP(5)
      .

END.

{preview.i}
{intrface.del}
