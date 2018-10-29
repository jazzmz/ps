/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2000 ТОО "Банковские информационные системы"
     Filename: G-LOLIB.P
      Comment: persistent библиотека для   Loan_op для работы одновременно с счетами основного договора и транша
      Parameters: none
      Функции:
         РольПоСогл -  определение счета по роли, привязанного к соглашению
         Uses:
      Used by:
      Created:  nata
      Modified: 10.01.2003 15:09 PESV
                     по заявке 13199 Из ВТБ в осн версию функция НДата - Возвращает дату начала периода начисления %%.
      Modified: 06.06.03 ILVI
         Функция ПРМСОГл перенесена в g-pfunc.def в связи с выполнением 15239
      Modified: 22.06.04 fepa Перенесен функционал из VTB по заявке 23046.
      Modified: 27.06.07 koch Перенесен функционал из VTB по заявке 49257.
      Modified: 25.08.2007 13:13 OZMI     (0075110)
      Modified: 06.11.2007 jadv (0077751) Доработка РольС, если счет резерва закрыт, открывать новый счет.
      Modified: 12.11.2007 boes (0083188) Добавлены парсерные функции НачБал(), СменаКК()
      Modified: 06.11.2007 jadv (0085692) Добавлены парсерные функции ФормРезДискСроч() и ФормРезДискПр()
                                          Доработана Form_Rsrv()
      Modified: 31.01.2008 jadv (0077751) Доработка РольССоз, если счет резерва закрыт, открывать новый счет.
*/

{def-wf.i}
{pick-val.i}
{globals.i}
{done}
{sh-defs.i}
{intrface.get ovl}
{intrface.get lv}
{intrface.get i254}
{intrface.get tmess}
{intrface.get cdrep}
{intrface.get loanx}
{loan_sn.i}
{intrface.get loan}
{intrface.get instrum}
{t-otch.i new}
{intrface.get xclass}
{par_mass.i}
{loan.pro}
{shttacct.def NEW}
{intrface.get pint}
{intrface.get bag}      /* Библиотека для работ с ПОС. */
{intrface.get lngar}    /* Библиотека для работы с гарантиями */
{intrface.get limit}
{intrface.get aclog}
{intrface.get oldpr}
{intrface.get date}
{savepars.i}

DEF VAR mViewAcctLog AS LOG NO-UNDO. /* признак необходимости создания записей в лог-таблице */
mViewAcctLog  = LOGICAL(FGetSetting("ViewAcctLog", ?, "NO")) NO-ERROR.

ASSIGN THIS-PROCEDURE:PRIVATE-DATA = "parssen library,testperspars,РольПоСогл,Лимит,КомСумма,НДата,ПРМДТ,ПСумма,ФормРез,ФормРезСроч,ФормРезПр,НепогОст,НепогОстД,РольС,ПрмВал,ПрмЭкв,РегРезерва,РольСРез,НачБал,СменаКК,ФормРезПроцПр,ФормРезПроцСроч,ФормРезДискСроч,ФормРезДискПр,ФормРезКом,ПогГрейс,ДогДр,ДогДрСогл,СуммаГрейс,КомДогЗн,ПрАлгОдин,СумПросПр,ПлавОбСчет,ПлавОбСумм,ОПР,ЛимВосст,ГрейсСрокОконч,ФормРезВб,ФормРезВозмУб,СумНачКом,ПирРольС".

{additem.i THIS-PROCEDURE:private-data 'ПрмОб'}
{additem.i THIS-PROCEDURE:private-data 'ПроцПар'}
{additem.i THIS-PROCEDURE:private-data 'ПлатПериодПр'}
{additem.i THIS-PROCEDURE:private-data 'ПлатПериодОД'}
{additem.i THIS-PROCEDURE:private-data 'СумДсрПг'}
{additem.i THIS-PROCEDURE:private-data 'СумШтрНеДП'}
{additem.i THIS-PROCEDURE:private-data 'ПРМПок'}
{additem.i THIS-PROCEDURE:private-data 'РольПоКонтр'}
{additem.i THIS-PROCEDURE:private-data 'НВПИКурс'}
{additem.i THIS-PROCEDURE:private-data 'ПДатаПр'}
{additem.i THIS-PROCEDURE:private-data 'ПДатаПлат'}
{additem.i THIS-PROCEDURE:private-data 'ФормРезПроцПрВ'}
{additem.i THIS-PROCEDURE:private-data 'СуммаПросГр'}
{additem.i THIS-PROCEDURE:private-data 'ПовышСтав'}
{additem.i THIS-PROCEDURE:private-data 'ГрейсПроцК'}
/* ф-ция возвращающая параметр, передаваемый в процедуру */
/* после разбора строки  параметров парсером             */
{getprm.lib}

/* Процедура поиска счета по Роли - используется для определения счета договора - соглашения */
/* об овердрафте                                                                             */
/* Вызов: РольПоСогл("<Роль1>","<Роль2>")                                                    */
/* Роль1 - роль счета в договоре течении - обычно Кредит                                     */
/* Роль2 - роль счета в договоре соглашении, который надо найти                              */
PROCEDURE РольПоСогл.

   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEF VAR in-contract  AS CHAR NO-UNDO.
   DEF VAR in-cont-code AS CHAR NO-UNDO .
   DEF VAR vFindRole AS CHAR NO-UNDO .

   vFindRole = getparam(2,param-str).

   DEF BUFFER xloan-acct FOR loan-acct .
    IF param-count NE 2 THEN DO:
       RUN Fill-Sysmes IN h_tmess ("", "", "0", "Ошибочное количество параметров передано в процедуру РольПоСогл:" + STRING(param-count) + "\n(должно быть 2) !").
       RETURN.
    END.
    ASSIGN
      in-contract = getparam(1,param-str)
      in-cont-code = get_loan()
      .

    FIND LAST xloan-acct WHERE
              xloan-acct.contract  = in-contract
          AND xloan-acct.cont-code = in-cont-code
          AND xloan-acct.acct-type = vFindRole
          AND xloan-acct.since    LE in-op-date NO-LOCK NO-ERROR.

    IF NOT AVAIL xloan-acct THEN
        RUN CreateBill(in-cont-code,in-contract,in-op-date,vFindRole).
    ELSE
       pick-value = xloan-acct.acct.
END PROCEDURE .


/* процедура определения лимита кредита по овердрафтному договору       */
/*   вызов: Лимит("Кредит",
                  "<признак даты>" - ПД плановая дата, ОД дата опер дня
                                     по умолчанию ОД
     пример: Лимит("Кредит")
             Лимит("Кредит","ОД")
             Лимит("Кредит","ПД")
             Лимит("Кредит","ПД","план")
             Лимит("Кредит",,"лимит")                                */

PROCEDURE Лимит.

   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEF VAR h_templ     AS HANDLE NO-UNDO.
   DEF VAR in-contract AS CHAR   NO-UNDO.
   DEF VAR in-contcode AS CHAR   NO-UNDO.
   DEF VAR vDate       AS DATE   NO-UNDO.
   DEF VAR vLimDebt    AS DEC    NO-UNDO.
   DEF VAR vRezhim     AS CHAR   NO-UNDO.
   DEF VAR vLoanGraf   AS CHAR   NO-UNDO.
   DEF VAR vTypeLim    AS CHAR   NO-UNDO.

   mb:
   DO ON ERROR UNDO, LEAVE:

      pick-value = ?.
      IF param-count GT 3 THEN
      DO:
         RUN Fill-Sysmes IN h_tmess ("", "", "-1", "ОШИБОЧНОЕ количество параметров передано в процедуру Лимит:" + STRING(param-count) + "\n(должно быть 1, 2 или 3) !").
         LEAVE mb.
      END.
      in-contract = getparam(1,param-str).

      IF param-count EQ 2
         OR param-count EQ 3
         AND getparam(2,param-str) NE "" THEN
      DO:
         /*ищем wop для определения плановой даты*/
         FIND FIRST wop WHERE RECID(wop) EQ rid NO-LOCK NO-ERROR.
         IF NOT AVAIL wop AND getparam(2,param-str) EQ "ПД" THEN
            LEAVE mb.
      END.
      vDate = IF getparam(2,param-str) EQ "ПД" THEN wop.con-date
                                               ELSE in-op-date.

      /* При vTypeLim='лимит' ищется сумма по плановым остаткам на охватывающем договоре и из меню 'Лимиты',
         при vTypeLim='план' - по плановому остатку на договоре (транше),
         при пустом параметре - в зависимости от НП 'ПарсерЛимит':
           НП 'ПарсерЛимит' = Нет, или <пусто>, или НП отсутствует -
           ищется сумма по плановым остаткам на охватывающем договоре и из меню 'Лимиты',
           НП 'ПарсерЛимит' = Да - берется сумма планового остатка на договоре (транше) */

      vTypeLim = IF param-count EQ 3 THEN getparam(3,param-str)
                 ELSE "".
      IF vTypeLim = "" THEN
         vTypeLim = IF FGetSetting("ПарсерЛимит",?,"Нет") NE "Да" THEN "лимит" ELSE "план".
      ELSE
        IF NOT CAN-DO("план,лимит",vTypeLim) THEN
        DO:
          RUN Fill-Sysmes IN h_tmess ("", "", "-1", "ОШИБОЧНОЕ значение 3-го параметра процедуры Лимит:" + "\n(должно быть <пусто>, или 'лимит', или 'план') !").
          LEAVE mb.
        END.

      /* Определение правильного применения функции, формат private-data */
      RUN LOAN_VALID_HANDLE (INPUT-OUTPUT h_templ).

      IF NOT VALID-HANDLE(h_templ) THEN
         LEAVE mb.

      RUN FindLPResult(in-contract,
                       in-contcode,
                       "Лимит",
                       param-str,
                       OUTPUT pick-value).
      IF pick-value EQ "" THEN
      DO:
         in-contcode = ENTRY(2,h_templ:PRIVATE-DATA).

      RUN RE_B_LOAN (in-contract,
                     ENTRY(2,h_templ:PRIVATE-DATA),
                     BUFFER loan).

      IF NOT AVAIL loan THEN
         LEAVE mb.

      IF param-count EQ 2
         OR param-count EQ 3
         AND getparam(2,param-str) NE "" THEN
      DO:
            /*ищем wop для определения плановой даты*/
            vRezhim = getparam(2,param-str).
            FIND FIRST wop WHERE RECID(wop) EQ rid NO-LOCK NO-ERROR.
            IF NOT AVAIL wop AND vRezhim BEGINS "ПД" THEN
               LEAVE mb.
            IF vRezhim BEGINS "ПД" THEN vDate = wop.con-date.
        IF CAN-DO("ПД-,ОД-",vRezhim) THEN
        DO:
               vDate = vDate - 1.
               vLoanGraf = GetWorkGraf(in-contract + "," + in-contcode,
                                       loan.class-code).

               DO WHILE NOT IsWorkDayGraf(vDate,
                                          vLoanGraf):
                  vDate = vDate - 1.
               END.

        END.
      END.

      IF vTypeLim EQ "лимит" THEN
         RUN GetLoanLoanLimits(in-contract,
                            entry(1,in-contcode," "),
                            vDate,
                            OUTPUT vLimDebt).
      IF vTypeLim EQ "план" THEN
         RUN GetLoanLimitsOld (in-contract,
                            in-contcode,
                            vDate,
                            OUTPUT vLimDebt).

         pick-value = STRING(vLimDebt).
      END.

      RUN SaveLPResult (in-contract,
                        in-contcode,
                           "Лимит",
                           param-str,
                           pick-value).
   END. /* do on error */

END PROCEDURE .

/*
    * Что делает: Возвращает дату начала периода начисления %%.
                  плановая дата платежа по процентам (строго меньшая плановой даты транзакции)
                  или последняя операция 65,16,35,83,84,96,97,98,99,304,308,315
                  - выбирается более поздняя дата. Второй необязательный параметр указывает
                  участвует ли в поиске дата из графика %%, по умолчанию учитываем.
    * Синтаксис : НДата("Кредит"|"Депоз"[,ДА/НЕТ])
    * Автор     : Sema 5/12/2
*/
PROCEDURE НДата:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEFINE VARIABLE vDate       AS DATE       NO-UNDO. /* дата начала периода */
   DEFINE VARIABLE vContract   AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE vChkGr      AS LOG        NO-UNDO.
   DEFINE VARIABLE h_templ     AS HANDLE     NO-UNDO.
   DEFINE VARIABLE vI          AS INT64    NO-UNDO.
   DEFINE VARIABLE vS          AS CHARACTER  NO-UNDO.

   vS = fGetSetting("НДатаОп",?, ""). /*65,16,35,83,84,96,97,98,99,304,308,315*/

   IF param-count GT 2 THEN DO:
      RUN Fill-Sysmes IN h_tmess ("", "", "-1", "ОШИБОЧНОЕ количество параметров передано в процедуру НДата:" + STRING(param-count) + " !").
      RETURN.
   END.

   vContract = GetParam(1,param-str).

   IF param-count EQ 2 THEN
      vChkGr = IF GetParam(2,param-str) EQ "NO" OR  GetParam(2,param-str) EQ "НЕТ" THEN NO
                                                                                   ELSE YES.
   ELSE
      vChkGr = YES.

   /* Определение правильного применения функции, формат private-data */
   RUN LOAN_VALID_HANDLE (INPUT-OUTPUT h_templ).

   IF NOT VALID-HANDLE(h_templ) THEN
   DO:
      pick-value  = ? .
      RETURN .
   END.

   RUN RE_B_LOAN (vContract,
                  ENTRY(2,h_templ:PRIVATE-DATA),
                  BUFFER loan).
   IF NOT AVAIL loan THEN
   DO:
      pick-value = ?.
      RETURN .
   END.

   /*ищем wop для определения плановой даты*/
   FIND FIRST wop WHERE RECID(wop) = rid NO-LOCK NO-ERROR.
   IF NOT AVAIL wop THEN
   DO:
      pick-value = ?.
      RETURN .
   END.

   vDate = ?.
   DO vI = 1 TO NUM-ENTRIES (vS):
      /* ищем последняю операцию */
      FIND FIRST chowhe WHERE chowhe.id-op EQ INT64(ENTRY(vI, vS)) NO-LOCK NO-ERROR.
      IF AVAIL chowhe THEN
      DO:
         FIND LAST loan-int OF loan WHERE
                loan-int.cont-code EQ loan.cont-code
            AND loan-int.contract  EQ loan.contract
            AND loan-int.mdate     LT wop.con-date
            AND loan-int.id-d      EQ chowhe.id-d
            AND loan-int.id-k      EQ chowhe.id-k
            NO-LOCK NO-ERROR.
         IF AVAIL loan-int THEN
            IF vDate EQ ? OR loan-int.mdate > vDate THEN vDate = loan-int.mdate.
      END.
   END.

   IF vChkGr THEN
   DO:
      /* ищем плановау дату платежа по процентам */
      RUN RE_TERM_OBL (loan.contract,  /*назначение договора*/
                       loan.cont-code, /*код договора*/
                       1,              /*тип остатка всегда 1  не используется*/
                       (wop.con-date - 1),    /*плановая дата документа*/
                       BUFFER term-obl).

      IF AVAIL term-obl THEN
         IF vDate EQ ? OR term-obl.end-date > vDate THEN vDate = term-obl.end-date.
   END.

   IF vDate EQ ? THEN
      vDate = loan.open-date.
   pick-value = STRING(vDate + 1, "99/99/9999").
END. /*PROCEDURE НДата*/

/* процедура определения значения параметра договора соглашения при работе с периодами */
/*  вызов: ПРМДТ("<назначение>",           - назначение договора
                 "<код параметра>",        - параметр
                 "<признак даты>"          - ПД плановая дата Од опер день
                 [,"<учитывать проценты>"]) -  если равен "да"
    пример - определение остатка неиспользованного лимита : ПрмСогл("Кредит","19")       */
PROCEDURE  ПРМДТ.
   DEFINE INPUT PARAMETER rid         AS RECID     NO-UNDO.
   DEFINE INPUT PARAMETER in-op-date  AS DATE      NO-UNDO.
   DEFINE INPUT PARAMETER param-count AS INT64   NO-UNDO.
   DEFINE INPUT PARAMETER param-str   AS CHARACTER NO-UNDO.

   DEFINE VARIABLE h_templ     AS HANDLE    NO-UNDO.
   DEFINE VARIABLE in-contract AS CHARACTER NO-UNDO.
   DEFINE VARIABLE loan_ost    AS DECIMAL   NO-UNDO.
   DEFINE VARIABLE loan_db     AS DECIMAL   NO-UNDO.
   DEFINE VARIABLE loan_cr     AS DECIMAL   NO-UNDO.
   DEFINE VARIABLE in-param    AS INT64   NO-UNDO.
   DEFINE VARIABLE vSumma      AS DECIMAL   NO-UNDO.
   DEFINE VARIABLE vDate       AS DATE      NO-UNDO.
   DEFINE VARIABLE vRateLog    AS LOGICAL   NO-UNDO.

   DEF BUFFER bLoan FOR Loan.

   IF param-count NE 3 AND
      param-count NE 4 THEN
   DO:
      RUN Fill-Sysmes IN h_tmess ("", "", "-1", "ОШИБОЧНОЕ количество параметров передано в процедуру ПРМДТ:" + STRING(param-count) + "\n(должно быть 3 или 4) !").
      RETURN.
   END.

   in-contract = getparam(1,param-str) .

   in-param = INT64(getparam(2,param-str)) NO-ERROR.
   IF ERROR-STATUS:ERROR THEN
   DO:
      RUN Fill-Sysmes IN h_tmess ("", "", "0", "Неправильно указан код параметра!").
      RETURN.
   END.

   FIND FIRST wop WHERE RECID(wop) = rid NO-LOCK NO-ERROR.

   vDate = IF getparam(3,param-str) = "ОД" THEN
              in-op-date
           ELSE
             wop.con-date.

   vRateLog = IF param-count = 4 AND getparam(4,param-str) = "Да" THEN
                 YES
              ELSE
                 NO.
   /* Определение правильного применения функции, формат private-data */
   RUN LOAN_VALID_HANDLE (INPUT-OUTPUT h_templ).

   IF NOT VALID-HANDLE(h_templ) THEN
   DO:
      pick-value  = ? .
      RETURN .
   END.

   RUN RE_B_LOAN (in-contract,
      ENTRY(2,h_templ:PRIVATE-DATA),
      BUFFER loan).
   IF NOT AVAILABLE loan THEN
   DO :
      pick-value = ?.
      RETURN .
   END.

   RUN "STNDRT_PARAM" (loan.contract,
                       loan.cont-code,
                       in-param,
                       vDate,
                       OUTPUT loan_ost,
                       OUTPUT loan_cr,
                       OUTPUT loan_db).
   vSumma = loan_ost.
   /* Если есть признак "учитывать текущие проценты по параметрам" */
   IF vRateLog THEN
   DO:
      IF in-param = 81 OR
         in-param = 82 OR
         in-param = 96 THEN
      DO:
         vSumma = vSumma + LoadPar(IF in-param = 81
                                   THEN 11
                                   ELSE IF in-param = 82
                                   THEN 12
                                   ELSE 13,loan.contract + ',' + loan.cont-code).
      END.
      ELSE
          IF mass[in-param + 1] >= 1 AND mass[in-param + 1] <= 10 THEN
         vSumma = vSumma + loan.interest[mass[in-param + 1]].
   END.

   FOR EACH bLoan WHERE
            bLoan.contract  =      loan.contract
        AND bLoan.cont-code BEGINS loan.cont-code + " "
        AND bLoan.cont-code <>     loan.cont-code
   NO-LOCK:
      RUN "STNDRT_PARAM" (bLoan.contract,
                          bLoan.cont-code,
                          in-param,
                          vDate,
                          OUTPUT loan_ost,
                          OUTPUT loan_cr,
                          OUTPUT loan_db).
      vSumma = vSumma + loan_ost.
      /* Если есть признак "учитывать текущие проценты по параметрам" */
      IF vRateLog THEN
      DO:
         IF in-param = 81 OR
            in-param = 82 OR
            in-param = 96 THEN
         DO:
             vSumma = vSumma + LoadPar(IF in-param = 81
                                       THEN 11
                                       ELSE IF in-param =82
                                       THEN 12
                                       ELSE 13,bLoan.contract + ',' + bLoan.cont-code).
         END.
         ELSE
             IF mass[in-param + 1] >= 1 AND mass[in-param + 1] <= 10 THEN
            vSumma = vSumma + bLoan.interest[mass[in-param + 1]].
      END.
   END.
   pick-value = STRING(vSumma).
END PROCEDURE .

/*
    * Что делает: Возвращает сумму планового погашения по договору,
                  дата которого совпадает с плановой датой документа
    * Синтаксис : ПСумма("Кредит"|"Депоз",
                         ["1"|"2"|"3"],    - Тип суммы 1,2 или 3.
                         ["ОД"|"ДВ"|"ПД"], - Дата отноительно которой считаем Опер День, Дата Валютирования, Плановая Дата.
                         ["EQ" | "GE" | "LE" | "GT" | "LT"| "="] - Знак поиска даты = ,<= ,>= ,> ,<.
                         )
                  По умолчанию берется ПД , 3 , = .
    * Автор     : Pesv 23/10/2003
*/

PROCEDURE ПСумма:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEFINE VARIABLE vTermObl    AS INT64 NO-UNDO.
   DEFINE VARIABLE vDate       AS DATE NO-UNDO.
   DEFINE VARIABLE vContract   AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE h_templ     AS HANDLE     NO-UNDO.
   DEFINE VARIABLE vZnak       AS CHAR NO-UNDO.
   DEFINE VARIABLE vNapr       AS CHAR NO-UNDO.

   IF param-count NE 1
   AND param-count NE 2
   AND param-count NE 3
   AND param-count NE 4

   THEN DO:
      RUN Fill-Sysmes IN h_tmess ("", "", "0", "Ошибочное количество параметров передано в функцию ПСумма:" + STRING(param-count) + "\n(должно быть 1,2,3 или 4) !").
      RETURN.
   END.

   vContract = GetParam(1,param-str).

   /* Определение правильного применения функции, формат private-data */
   RUN LOAN_VALID_HANDLE (INPUT-OUTPUT h_templ).

   IF NOT VALID-HANDLE(h_templ)
   THEN DO:
      pick-value  = ? .
      RETURN .
   END.

   RUN RE_B_LOAN (vContract,
                  ENTRY(2,h_templ:PRIVATE-DATA),
                  BUFFER loan).
   IF NOT AVAIL loan THEN
   DO:
      pick-value = ?.
      RETURN .
   END.

   /*ищем wop для определения плановой даты*/
   FIND FIRST wop WHERE RECID(wop) = rid NO-LOCK NO-ERROR.
   IF NOT AVAIL wop THEN
   DO:
      pick-value = ?.
      RETURN .
   END.

   vTermObl = INT64(getparam(2,param-str)) NO-ERROR.
   IF ERROR-STATUS:ERROR THEN
   DO:
      RUN Fill-Sysmes IN h_tmess ("", "", "0", "Неправильно указан идентификатор обязательства!").
      RETURN.
   END.
   IF vTermObl = ? THEN vTermObl = 3.

   IF getparam(3,param-str) NE ? THEN
       CASE getparam(3,param-str):
          WHEN "ОД" THEN
              vDate = in-op-date.
          WHEN "ДВ" THEN
              vDate = wop.value-date.
          WHEN "ПД" THEN
              vDate = wop.con-date.
       END CASE.
       ELSE
          vDate = wop.con-date.

   IF vDate = ? THEN
   DO:
      RUN Fill-Sysmes IN h_tmess ("", "", "0", "Неправильно указана дата!").
      RETURN.
   END.

   /* ищем плановау дату платежа  */
   IF getparam(4,param-str) NE ? THEN
      vZnak = getparam(4,param-str).
      ELSE
      vZnak = "EQ".

   IF NOT CAN-DO("GT,LT,LE,GE,EQ,=",vZnak) THEN
   DO:
      RUN Fill-Sysmes IN h_tmess ("", "", "0", "Неправильно указан знак!").
      RETURN.
   END.

   CASE vZnak:
      WHEN "EQ"  OR
      WHEN "=" THEN
          {psymm.i &idnt=vTermObl &znak="=" &DATE=vDate &napr="FIND LAST" }
      WHEN "LE" THEN
          {psymm.i &idnt=vTermObl &znak="<=" &DATE=vDate &napr="FIND LAST" }
      WHEN "LT" THEN
          {psymm.i &idnt=vTermObl &znak="<" &DATE=vDate &napr="FIND LAST" }
      WHEN "GT" THEN
          {psymm.i &idnt=vTermObl &znak=">" &DATE=vDate &napr="FIND FIRST" }
      WHEN "GE" THEN
          {psymm.i &idnt=vTermObl &znak=">=" &DATE=vDate &napr="FIND FIRST" }
   END CASE.

   IF AVAIL term-obl THEN
   DO:
      pick-value = STRING(term-obl.amt-rub).
   END.
   ELSE
      pick-value = STRING(0).
END. /*PROCEDURE ПСумма*/

/*
    * Что делает: Возвращает сумму комиссии за ведение ссудного/депозитного счета с
                  даты последнего начисления
    * Синтаксис : КомСумма("Кредит"|"Депоз")
    * Автор     : Илюха  05/11/2002
    * Пример    : КомСумма("Кредит") - Сумма комиссии за ведение ссудного счета
                  по кредитному договору
*/
PROCEDURE КомСумма:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEF VAR h_templ     AS HANDLE NO-UNDO.
   DEF VAR in-contract AS CHAR   NO-UNDO.
   DEF VAR summa       AS DEC    NO-UNDO.
   DEF VAR dat-per     AS DATE   NO-UNDO.
   DEF VAR date-start  AS DATE   NO-UNDO.
   DEF VAR proc-name   AS CHAR   NO-UNDO.


   IF param-count NE 1 THEN DO:
      RUN Fill-Sysmes IN h_tmess ("", "", "0", "Ошибочное количество параметров передано в функцию КомСумма:" + STRING(param-count) + "\n(должно быть 1) !").
      RETURN.
   END.

   ASSIGN
     summa       = 0
     in-contract = GetParam(1,param-str)
     .

   /* Определение правильного применения функции, формат private-data */
   RUN LOAN_VALID_HANDLE (INPUT-OUTPUT h_templ).

   IF NOT VALID-HANDLE(h_templ)
   THEN DO:
      pick-value  = ? .
      RETURN .
   END.

   RUN RE_B_LOAN (in-contract,
                  ENTRY(2,h_templ:PRIVATE-DATA),
                  BUFFER loan).
   IF NOT AVAIL loan
   THEN DO:
     pick-value = ?.
     RETURN .
   END.

   /*определяем дату перехода на 39П  var dat-per*/
   {ch_dat_p.i}
   /*чистим otch1*/
   {empty otch1}

   /*ищем wop для определения плановой даты*/
   FIND FIRST wop WHERE RECID(wop) = rid NO-LOCK NO-ERROR.
   IF NOT AVAIL wop
   THEN DO:
     pick-value = ?.
     RETURN .
   END.
   /*последняя операция начисления, которая создается автоматически на дату
     плановой оплаты процентов*/
   FIND LAST loan-int OF loan WHERE
             loan-int.id-d  EQ 96 /*параметр 96 по номером 13 в последовательности параметров*/
         AND loan-int.mdate LT wop.con-date
   NO-LOCK NO-ERROR.
   /*с учетом 39П корректируем начало интервала...*/
   date-start = IF AVAIL loan-int
                THEN loan-int.mdate + (IF loan-int.mdate GE dat-per
                                       THEN 1
                                       ELSE 0)
                ELSE loan.open-date.

   {get_meth.i  'NachProc' 'nach-pp'}

   RUN VALUE(proc-name + ".p")(loan.contract,  /*назначение договора*/
                               loan.cont-code, /*код договора*/
                               date-start,     /*дата начала интервала т.е дата посл. нач.*/
                               wop.con-date,   /*плановая дата документа*/
                               dat-per,        /*переход на 39П*/
                               13,             /*номер параметра*/
                               1).             /*тип остатка всегда 1  не используется*/
   FOR EACH otch1:
      summa = summa + otch1.summ_pr.
   END.

   pick-value = STRING(summa).

END. /*PROCEDURE КомСумма*/

/*--------------------------------------------------------------------------
    * Что делает: Возвращает величину формируемого резерва по ссуде.
    * Синтаксис : ФормРез ( <признак даты> , <СОГЛ>)
                  <признак даты>:  "ОД"  - дата опер. дня
                                   "ПД"  - плановая дата
                  <СОГЛ>  - необязательный параметр, разрешает посчитать резерв по
                  траншу, если резерв ведется на охватывающем договоре

    * Автор     : amam 14/07/04
    * Пример    : ФормРез("ОД")
  --------------------------------------------------------------------------*/
PROCEDURE ФормРез:
   DEF INPUT  PARAM rid         AS RECID NO-UNDO.
   DEF INPUT  PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT  PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT  PARAM param-str   AS CHAR  NO-UNDO.
   RUN Form_Rsrv('ФормРез',rid,in-op-date, param-count, param-str).
END PROCEDURE.

/*--------------------------------------------------------------------------
    * Что делает: Возвращает величину формируемого резерва по срочной
                  задолженности.
    * Синтаксис : ФормРезСроч( <признак даты> , <СОГЛ>)
                  <признак даты>:  "ОД"  - дата опер. дня
                                   "ПД"  - плановая дата
                  <СОГЛ>  - необязательный параметр, разрешает посчитать резерв по
                  траншу, если резерв ведется на охватывающем договоре
                  <ПАРАМЕТЫ1> - список параметров  для расчета срочной задолжности
                  <ПАРАМЕТЫ2> - список параметров  для расчета просроченной задолжности

    * Автор     : amam 14/07/04
    * Пример    : ФормРезСроч("ОД") ФормРезСроч("ОД","СОГЛ")
                  ФормРезСроч("ОД","","0,5104","7,5109") - для цессии
  --------------------------------------------------------------------------*/
PROCEDURE ФормРезСроч:
   DEF INPUT  PARAM rid         AS RECID NO-UNDO.
   DEF INPUT  PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT  PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT  PARAM param-str   AS CHAR  NO-UNDO.

   RUN Form_Rsrv('ФормРезСроч',rid,in-op-date, param-count, param-str).
END PROCEDURE.

/*--------------------------------------------------------------------------
    * Что делает: Возвращает величину формируемого резерва по просроченной
                  задолженности.
    * Синтаксис : ФормРезПр( <признак даты>  , <СОГЛ>)
                  <признак даты>:  "ОД"  - дата опер. дня
                                   "ПД"  - плановая дата
                  <СОГЛ>  - необязательный параметр, разрешает посчитать резерв по
                  траншу, если резерв ведется на охватывающем договоре
                  <ПАРАМЕТЫ1> - список параметров  для расчета срочной задолжности
                  <ПАРАМЕТЫ2> - список параметров  для расчета просроченной задолжности


    * Автор     : amam 14/07/04
    * Пример    : ФормРезПр("ОД")
                  ФормРезПр("ОД","","0,5104","7,5109,5110,5112,5113,5116,5155") - для цессии
  --------------------------------------------------------------------------*/
PROCEDURE ФормРезПр:
   DEF INPUT  PARAM rid         AS RECID NO-UNDO.
   DEF INPUT  PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT  PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT  PARAM param-str   AS CHAR  NO-UNDO.

   RUN Form_Rsrv('ФормРезПр',rid,in-op-date, param-count, param-str).
END PROCEDURE.
/*--------------------------------------------------------------------------
    * Что делает: Возвращает величину формируемого резерва для процентов.
    * Синтаксис : ФормРезПроцСроч( <признак даты>  , <СОГЛ>)
                  <признак даты>:  "ОД"  - дата опер. дня
                                   "ПД"  - плановая дата
                  <СОГЛ>  - необязательный параметр, разрешает посчитать резерв по
                  траншу, если резерв ведется на охватывающем договоре
    * Автор     : daru 26/11/07
    * Пример    : ФормРезПроцСроч("ОД")
  --------------------------------------------------------------------------*/
PROCEDURE ФормРезПроцСроч:
   DEF INPUT  PARAM rid         AS RECID NO-UNDO.
   DEF INPUT  PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT  PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT  PARAM param-str   AS CHAR  NO-UNDO.

   RUN Form_Rsrv('ФормРезПроцСроч',rid,in-op-date, param-count, param-str).
END PROCEDURE.
/*--------------------------------------------------------------------------
    * Что делает: Возвращает величину формируемого резерва для просроченных процентов.
    * Синтаксис : ФормРезПроцПр( <признак даты>  , <СОГЛ>)
                  <признак даты>:  "ОД"  - дата опер. дня
                                   "ПД"  - плановая дата
                  <СОГЛ>  - необязательный параметр, разрешает посчитать резерв по
                  траншу, если резерв ведется на охватывающем договоре
    * Автор     : daru 26/11/07
    * Пример    : ФормРезПроцСроч("ОД")
  --------------------------------------------------------------------------*/
PROCEDURE ФормРезПроцПр:
   DEF INPUT  PARAM rid         AS RECID NO-UNDO.
   DEF INPUT  PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT  PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT  PARAM param-str   AS CHAR  NO-UNDO.

   RUN Form_Rsrv('ФормРезПроцПр',rid,in-op-date, param-count, param-str).
END PROCEDURE.
/*--------------------------------------------------------------------------
    * Что делает: Возвращает величину формируемого резерва для просроченных процентов на внебалансе.
    * Синтаксис : ФормРезПроцПрВ( <признак даты>  , <СОГЛ>)
                  <признак даты>:  "ОД"  - дата опер. дня
                                   "ПД"  - плановая дата
                  <СОГЛ>  - необязательный параметр, разрешает посчитать резерв по
                  траншу, если резерв ведется на охватывающем договоре
    * Автор     : daru 26/11/07
    * Пример    : ФормРезПроцСроч("ОД")
  --------------------------------------------------------------------------*/
PROCEDURE ФормРезПроцПрВ:
   DEF INPUT  PARAM rid         AS RECID NO-UNDO.
   DEF INPUT  PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT  PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT  PARAM param-str   AS CHAR  NO-UNDO.

   RUN Form_Rsrv('ФормРезПроцПрВ',rid,in-op-date, param-count, param-str).
END PROCEDURE.

/*--------------------------------------------------------------------------
    * Что делает: Возвращает величину формируемого резерва по комиссиям.
    * Синтаксис : ФормРезКом( <признак даты>,<расчетная база>,<роль счета> , <СОГЛ>)
                  <признак даты>  :  "ОД"  - дата опер. дня
                                     "ПД"  - плановая дата
                  <зарезервирован (не используется)>:
                  <роль счета>    :  роль счета, на котором отражаются
                         соответствующие требования для резервирования
                         (КредБудКом,КредБудПени,...)
                  <СОГЛ>  - необязательный параметр, разрешает посчитать резерв по
                  траншу, если резерв ведется на охватывающем договоре

    * Автор     : ariz 18/03/08
    * Пример    : ФормРезКом("ОД","","КредБудКом")
  --------------------------------------------------------------------------*/
PROCEDURE ФормРезКом:
   DEF INPUT  PARAM rid         AS RECID NO-UNDO.
   DEF INPUT  PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT  PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT  PARAM param-str   AS CHAR  NO-UNDO.

   RUN Form_Rsrv('ФормРезКом',rid,in-op-date, param-count, param-str).
END PROCEDURE.

/*--------------------------------------------------------------------------
    * Что делает: Возвращает величину формируемого резерва по требованиям по возмещению убытка.
    * Синтаксис : ФормРезВозмУб( <признак даты> )
                  <признак даты>:  "ОД"  - дата опер. дня
                                   "ПД"  - плановая дата
    * Автор     : daru 26/11/07
    * Пример    : ФормРезПроцСроч("ОД")
  --------------------------------------------------------------------------*/
PROCEDURE ФормРезВозмУб:
   DEF INPUT  PARAM rid         AS RECID NO-UNDO.
   DEF INPUT  PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT  PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT  PARAM param-str   AS CHAR  NO-UNDO.

   RUN Form_Rsrv('ФормРезВозмУб',rid,in-op-date, param-count, param-str).
END PROCEDURE.

PROCEDURE Form_Rsrv:
   DEF INPUT  PARAM ipName      AS CHAR  NO-UNDO.
   DEF INPUT  PARAM rid         AS RECID NO-UNDO.
   DEF INPUT  PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT  PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT  PARAM param-str   AS CHAR  NO-UNDO.

   DEF VAR vHTempl    AS HANDLE NO-UNDO. /* Указатель на параметры договора */
   DEF VAR vContract  AS CHAR   NO-UNDO. /* назначение договора */
   DEF VAR vDate      AS DATE   NO-UNDO. /* Требуемая дата расчета */
   DEF VAR vRsrvSum   AS DEC    NO-UNDO INIT 0.00.
   DEF VAR vPcount    AS CHAR   NO-UNDO. /* Доп.текст ошибки */
   DEF VAR vDerivFlg  AS LOG    NO-UNDO. /* Признак заполнять ДР deriv для 'ФормРезВб' */
   DEF VAR vScreenFlg AS LOG    NO-UNDO. /* Выводить ли на экран протокол заполнения ДР deriv для 'ФормРезВб' */
   DEF VAR vSpisParam3 AS CHARACTER NO-UNDO . /* необязательный третий   параметр  у ФормРезСроч и ФормРезПр    */
   DEF VAR vSpisParam4 AS CHARACTER NO-UNDO . /* необязательный четвертый параметр  у ФормРезСроч и ФормРезПр    */

      /* У функции ФормРезКом 2 параметра, у ФормРезВб - 2 или 3, у остальных 1,2  */
   ASSIGN
      ipName  = TRIM(ipName)
      vPcount = ""
      vSpisParam3 = ""
      vSpisParam4 = ""
   .

   CASE ipName:
      WHEN 'ФормРезСроч' THEN
         IF     param-count LT 1
            AND param-count GT 3 THEN
            vPcount = "1,2,3".
      WHEN 'ФормРезПр' THEN
         IF     param-count LT 1
            AND param-count GT 3 THEN
            vPcount = "1,2,3".
      WHEN 'ФормРезКом' THEN
         IF     param-count LT 3
            AND param-count GT 4 THEN
            vPcount = "3,4".
      WHEN 'ФормРезВб'  THEN
         IF     param-count LT 2
            AND param-count GT 4 THEN
            vPcount = "2,3 или 4".
      OTHERWISE
         IF     param-count LT 1
            AND param-count GT 2 THEN
            vPcount = "1,2".
   END CASE.
   IF vPcount NE "" THEN
   DO:
      RUN Fill-Sysmes IN h_tmess ("", "", "0",
                                  "Ошибочное количество параметров передано в процедуру ipName:" +
                                  STRING(param-count) + "\n(должно быть " + vPcount + ") !").
      RETURN.
   END.

   CASE ipName:
      WHEN 'ФормРезСроч' OR
      WHEN 'ФормРезПр' THEN DO:
         vSpisParam3 = GETPARAM(3, param-str) NO-ERROR .
         IF vSpisParam3 = ? THEN vSpisParam3 = "".
         vSpisParam4 = GETPARAM(4, param-str) NO-ERROR .
         IF vSpisParam4 = ? THEN
         ASSIGN
            vSpisParam3 = ""
            vSpisParam4 = ""
         .
      END.
   END CASE.

      /* Определение правильного применения функции,
      ** формат private-data */
   RUN LOAN_VALID_HANDLE (INPUT-OUTPUT vHTempl).

      /* Номер договора не определен */
   IF NOT VALID-HANDLE(vHTempl) THEN DO:
      pick-value = ?.
      RETURN.
   END.

   vContract = ENTRY(1, vHTempl:PRIVATE-DATA).

      /* Для кредитов */
   IF vContract <> "Кредит" THEN DO:  /* Неверное назначение договора */
      pick-value = ?.
      RETURN.
   END.

      /* Поиск договора */
   RUN RE_B_LOAN (vContract,
                  ENTRY(2, vHTempl:PRIVATE-DATA),
                  BUFFER loan).
   IF NOT AVAIL loan THEN DO:
      pick-value = ?.
      RETURN.
   END.

   RUN FindLPResult(loan.contract,
                    loan.cont-code,
                    TRIM(ipName),
                    param-str,
                    OUTPUT pick-value).

   IF pick-value EQ "" THEN
   DO:

      /* ищем wop для определения плановой даты */
      FIND FIRST wop WHERE RECID(wop) = rid NO-LOCK NO-ERROR.
      IF NOT AVAIL wop
      THEN DO:
        pick-value = ?.
        RETURN .
      END.

      vDate = IF getparam(1,param-str) = "ОД" THEN
                 in-op-date
              ELSE
                 wop.con-date.

      ASSIGN
         vDerivFlg  = GETPARAM(3, param-str) EQ "deriv"
         vScreenFlg = CAN-DO("Да,yes",GETPARAM(4, param-str))
      .
      IF loan.since NE vDate THEN
      DO:
         RUN Fill-Sysmes IN h_tmess ("", "", "0", "Договор " + loan.doc-ref + " не пересчитан на дату " + STRING(vDate, "99/99/9999") + "!").
         RETURN.
      END.

      /* Взведем флаг ,нужно ли обрабатывать параметр CОГЛ */
      RUN setVerifyRelType IN h_i254 (FALSE) .
      IF INDEX(param-str,"СОГЛ") GT 0
      THEN
         RUN setVerifyRelType IN h_i254  (TRUE) .
   /* Передаем vSpisParam в обработку парсеров  */
   RUN setSpisBaseParam IN h_i254 (vSpisParam3,vSpisParam4) .


      CASE TRIM(ipName):
         WHEN 'ФормРез'          THEN
            vRsrvSum =    LnFormRsrv          (loan.contract, loan.cont-code, vDate, "").
         WHEN 'ФормРезСроч'      THEN
               vRsrvSum = LnFormRsrvGoodDebt  (loan.contract, loan.cont-code, vDate, "").
         WHEN 'ФормРезПр'        THEN
            vRsrvSum =    LnFormRsrvBadDebt   (loan.contract, loan.cont-code, vDate, "").
         WHEN 'ФормРезПроцСроч'  THEN
            vRsrvSum =    LnFormRsrvProcGood  (loan.contract, loan.cont-code, vDate, "").
         WHEN 'ФормРезПроцПр'    THEN
            vRsrvSum =    LnFormRsrvProcBad   (loan.contract, loan.cont-code, vDate, "").
         WHEN 'ФормРезПроцПрВ'    THEN
            vRsrvSum =    LnFormRsrvProcBadVb (loan.contract, loan.cont-code, vDate, "").
         WHEN 'ФормРезДискСроч'  THEN
            vRsrvSum =    LnFormRsrvVDiskGood (loan.contract, loan.cont-code, vDate, "").
         WHEN 'ФормРезДискПр'    THEN
            vRsrvSum =    LnFormRsrvDiskBad   (loan.contract, loan.cont-code, vDate, "").
         WHEN 'ФормРезКом'       THEN
            vRsrvSum =    LnFormRsrvCom       (loan.contract, loan.cont-code, vDate, "", GETPARAM(3, param-str)).
         WHEN 'ФормРезВб'        THEN
            vRsrvSum =    LnFormRsrvVb        (loan.contract, loan.cont-code, vDate, "", TRIM(GETPARAM(2, param-str)), vDerivFlg, vScreenFlg).
         WHEN 'ФормРезВозмУб'    THEN
            vRsrvSum =    LnFormRsrvDam       (loan.contract, loan.cont-code, vDate, "").
      END.

      RUN setVerifyRelType IN h_i254 (FALSE) .
      RUN setSpisBaseParam IN h_i254 ("","") .
      pick-value = STRING(ABS(vRsrvSum)).
      RUN SaveLPResult (loan.contract,
                        loan.cont-code,
                        TRIM(ipName),
                        param-str,
                        pick-value).
   END.
END PROCEDURE.    /* Form_Rsrv */


PROCEDURE НепогОст:
   DEF INPUT  PARAM iRid        AS RECID NO-UNDO.
   DEF INPUT  PARAM iOpDate     AS DATE  NO-UNDO.
   DEF INPUT  PARAM iParamCount AS INT64   NO-UNDO.
   DEF INPUT  PARAM iParamStr   AS CHAR  NO-UNDO.

   DEF VAR vContract AS CHAR   NO-UNDO.
   DEF VAR vContCode AS CHAR   NO-UNDO.
   DEF VAR vDate     AS DATE   NO-UNDO.
   DEF VAR vHTempl   AS HANDLE NO-UNDO.
   DEF VAR vType     AS CHAR   NO-UNDO.
   DEF VAR vTypeD    AS CHAR   NO-UNDO.
   DEF VAR vTotal    AS DEC    NO-UNDO.
   DEF VAR vSumma    AS DEC    NO-UNDO.
   DEF VAR vTypeDog  AS CHAR   NO-UNDO. /* Для обработки соглашения */
   DEF VAR vRet      AS LOG    NO-UNDO.

   DEF BUFFER term-obl FOR term-obl.
   DEF BUFFER loan     FOR loan.

   pick-value = ?.

   IF     iParamCount NE 1
      AND iParamCount NE 2
      AND iParamCount NE 3 THEN         /* Обработка соглашения */
   DO:
      RUN Fill-Sysmes IN h_tmess ("", "", "0",
                                  "Ошибочное количество параметров передано в " +
                                  "функцию НепогОст \n(должно быть 1, 2 или 3)!").
      vRet = TRUE.
   END.

   IF NOT vRet THEN
   DO:
      ASSIGN
         vType    = GetParam(1, iParamStr)
         vTypeD   = GetParam(2, iParamStr) WHEN iParamCount = 2
         vTypeDog = GetParam(3, iParamStr) WHEN iParamCount = 3
      .
      IF     vType NE "1"
         AND vType NE "2" THEN
      DO:
         RUN Fill-Sysmes IN h_tmess ("", "", "0",
                                     "Неправильно указан тип суммы - возможные " +
                                     "значения: \n1 - основной долг \n2 - проценты").
         vRet = TRUE.
      END.
   END.

   IF NOT vRet THEN
   DO:
      RUN LOAN_VALID_HANDLE (INPUT-OUTPUT vHTempl).

      IF NOT VALID-HANDLE(vHTempl) THEN RETURN .

      RUN RE_B_LOAN (ENTRY(1,vHTempl:PRIVATE-DATA),
                     ENTRY(2,vHTempl:PRIVATE-DATA),
                     BUFFER loan).

      IF NOT AVAIL loan THEN
         RETURN.

         /* Обработка соглашения */
      IF vTypeDog EQ "СОГЛ" THEN
      DO:
         RUN RE_B_LOAN (loan.contract,
                        ENTRY(1, loan.cont-code, " "),
                        BUFFER loan).
          IF NOT AVAIL loan THEN
             vRet = TRUE.
      END.
      RUN FindLPResult(loan.contract,
                       loan.cont-code,
                       "НепогОст",
                       iParamStr,
                       OUTPUT pick-value).
      IF pick-value NE "" THEN
         vRet = TRUE.
   END.

   IF NOT vRet THEN
   DO:
      FIND FIRST wop WHERE RECID(wop) = iRid NO-LOCK NO-ERROR.

      IF NOT AVAIL wop AND vTypeD = "ПД" THEN RETURN.

      vDate = IF vTypeD = "ПД"
                 THEN wop.con-date
                 ELSE iOpDate.

      IF loan.since < vDate THEN
      DO:
         RUN Fill-Sysmes IN h_tmess ("", "", "0",
                                     "Договор пересчитан на дату меньшую даты операции").
         vRet = TRUE.
      END.
   END.

   IF NOT vRet THEN
   DO:
      IF vType = "1" THEN
         FOR EACH term-obl WHERE
                  term-obl.contract  = loan.Contract
              AND term-obl.cont-code = loan.Cont-Code
              AND term-obl.idnt      = 3
              AND term-obl.end-date >= loan.open-date
              AND term-obl.end-date <= vDate
         NO-LOCK:
            RUN summ-t.p (OUTPUT vSumma,
                          loan.Contract,
                          loan.Cont-Code,
                          RECID(term-obl),
                          vDate).
            vTotal = vTotal + vSumma.
         END.
      ELSE
         FOR EACH term-obl WHERE
                  term-obl.contract  = loan.Contract
              AND term-obl.cont-code = loan.Cont-Code
              AND term-obl.idnt      = 1
              AND term-obl.end-date >= loan.open-date
              AND term-obl.end-date <= vDate
         NO-LOCK:
            RUN summ-t1.p (OUTPUT vSumma,
                           RECID(term-obl),
                           RECID(loan)).
            vTotal = vTotal + vSumma.
         END.
      pick-value = STRING(vTotal).
      RUN SaveLPResult (loan.contract,
                        loan.cont-code,
                        "НепогОст",
                        iParamStr,
                        pick-value).
   END.
END PROCEDURE.

PROCEDURE НепогОстД:
   DEF INPUT  PARAM iRid        AS RECID NO-UNDO.
   DEF INPUT  PARAM iOpDate     AS DATE  NO-UNDO.
   DEF INPUT  PARAM iParamCount AS INT64   NO-UNDO.
   DEF INPUT  PARAM iParamStr   AS CHAR  NO-UNDO.

   DEF VAR vContract AS CHAR   NO-UNDO.
   DEF VAR vContCode AS CHAR   NO-UNDO.
   DEF VAR vDate     AS DATE   NO-UNDO.
   DEF VAR vHTempl   AS HANDLE NO-UNDO.
   DEF VAR vType     AS CHAR   NO-UNDO.
   DEF VAR vTypeD    AS CHAR   NO-UNDO.
   DEF VAR vTotal    AS DEC    NO-UNDO.
   DEF VAR vSumma    AS DEC    NO-UNDO.

   DEF BUFFER term-obl FOR term-obl.
   DEF BUFFER loan     FOR loan.

   pick-value = ?.

   IF iParamCount <> 1 AND
      iParamCount <> 2
   THEN DO:
      RUN Fill-Sysmes IN h_tmess ("", "", "0", "Ошибочное количество параметров передано в функцию НепогОст\n(должно быть 1 или 2)!").
      RETURN.
   END.

   ASSIGN
      vType  = GetParam(1,iParamStr)
      vTypeD = GetParam(2,iParamStr) WHEN iParamCount = 2
      .

   IF vType <> "1" AND
      vType <> "2"
   THEN DO:
      RUN Fill-Sysmes IN h_tmess ("", "", "0", "Неправильно указан тип суммы - возможные значения\n1 - основной долг\n2 - проценты").
      RETURN.
   END.

   RUN LOAN_VALID_HANDLE (INPUT-OUTPUT vHTempl).

   IF NOT VALID-HANDLE(vHTempl) THEN RETURN .

   RUN RE_B_LOAN (ENTRY(1,vHTempl:PRIVATE-DATA),
                  ENTRY(2,vHTempl:PRIVATE-DATA),
                  BUFFER loan).

   IF NOT AVAIL loan THEN
      RETURN.

   FIND FIRST wop WHERE RECID(wop) = iRid NO-LOCK NO-ERROR.

   IF NOT AVAIL wop THEN RETURN.

   RUN FindLPResult(loan.contract,
                    loan.cont-code,
                    "НепогОстД",
                    STRING(wop.op-templ) + CHR(1) + iParamStr,
                    OUTPUT pick-value).
   IF pick-value EQ "" THEN
   DO:
      vDate = IF vTypeD = "ПД"
              THEN wop.con-date
              ELSE iOpDate.

      IF loan.since < vDate THEN
      DO:
         RUN Fill-Sysmes IN h_tmess ("", "", "0", "Договор пересчитан на дату меньшую даты операции").
         RETURN.
      END.

      IF vType = "1" THEN
         FOR EACH term-obl WHERE
                  term-obl.contract  = loan.Contract
              AND term-obl.cont-code = loan.Cont-Code
              AND term-obl.idnt      = 3
              AND term-obl.end-date  = vDate
         NO-LOCK:
            RUN summ-t.p (OUTPUT vSumma,
                          loan.Contract,
                          loan.Cont-Code,
                          RECID(term-obl),
                          vDate).
            vTotal = vTotal + vSumma.
         END.
      ELSE
         FOR EACH term-obl WHERE
                  term-obl.contract  = loan.Contract
              AND term-obl.cont-code = loan.Cont-Code
              AND term-obl.idnt      = 1
              AND term-obl.end-date  = vDate
         NO-LOCK:
            RUN summ-t1.p (OUTPUT vSumma,RECID(term-obl),RECID(loan)).
            vTotal = vTotal + vSumma.
         END.

      pick-value = STRING(vTotal).
      RUN SaveLPResult (loan.contract,
                        loan.cont-code,
                        "НепогОстД",
                        STRING(wop.op-templ) + CHR(1) + iParamStr,
                        pick-value).
   END.
END PROCEDURE.

/*--------------------------------------------------------------------------
    * Что делает: Ищет счет с указанной ролью, если не найден, то запускает
                  соответствующий шаблон создания счета с этой ролью.
    * Синтаксис : Роль( <необходимая роль счета> )
    * Автор     : fepa 17/09/04
    * Пример    : Роль("Кредит")
  --------------------------------------------------------------------------*/
PROCEDURE РольС .
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEF VAR in-contract  AS CHAR   NO-UNDO.
   DEF VAR vFindRole    AS CHAR   NO-UNDO.
   DEF VAR vSignDate    AS LOG    NO-UNDO. /* Признак поиска относительно плановой даты */
   DEF VAR h_templ      AS HANDLE NO-UNDO.

   vFindRole = getparam(1,param-str).

   IF     param-count           GE 2
      AND getparam(2,param-str) EQ "ПД"
   THEN vSignDate = YES .

   DEF BUFFER xloan-acct FOR loan-acct .


   /* Определение правильного применения функции, формат private-data */
   RUN LOAN_VALID_HANDLE (INPUT-OUTPUT h_templ).

   IF NOT VALID-HANDLE(h_templ) THEN
   DO:
      pick-value  = ?.
      RETURN.
   END.

   in-contract = ENTRY(1,h_templ:PRIVATE-DATA).

   RUN RE_B_LOAN (in-contract,
                 ENTRY(2,h_templ:PRIVATE-DATA),
                 BUFFER loan).
   IF NOT AVAIL loan THEN
   DO:
      pick-value  = ? .
      RETURN.
   END.

   RUN FindLPResult(loan.contract,
                    loan.cont-code,
                    "РольС",
                    param-str,
                    OUTPUT pick-value).
   IF pick-value EQ "" THEN
   DO:

      FIND FIRST wop WHERE RECID(wop) = rid NO-LOCK.

      FIND LAST xloan-acct WHERE
                 xloan-acct.contract  EQ in-contract
             AND xloan-acct.cont-code EQ loan.cont-code
             AND xloan-acct.acct-type EQ vFindRole
             AND xloan-acct.since     LE IF vSignDate THEN wop.con-date ELSE in-op-date
        NO-LOCK NO-ERROR.

      IF NOT AVAIL xloan-acct THEN
         RUN CreateBill(loan.cont-code,
                        in-contract,
                        MIN(in-op-date,wop.con-date),
                        vFindRole).
       /* Дополнительно,  проверяется наличие незакрытого счета, если указанный счет
       ** закрыт, то при наличии НП "ПрРольС" и его значения "КредРез, КредРез1, КредТ"
       ** запускается стандартная процедура открытия счета резерва */
      ELSE IF NOT (CAN-FIND(FIRST acct WHERE acct.acct       EQ xloan-acct.acct
                                         AND acct.currency   EQ xloan-acct.currency
                                         AND acct.close-date EQ ?))
              AND  CAN-DO(FGetSetting("ПрРольС","",?),vFindRole) THEN
         RUN CreateBill(loan.cont-code,
                        in-contract,
                        MIN(in-op-date,wop.con-date),
                        vFindRole).
      ELSE
         pick-value = xloan-acct.acct.
      RUN SaveLPResult (loan.contract,
                        loan.cont-code,
                        "РольС",
                        param-str,
                        pick-value).
   END.

END PROCEDURE.

PROCEDURE CreateBill.
   DEF INPUT  PARAM in-cont-code  AS CHAR  NO-UNDO.
   DEF INPUT  PARAM in-contract   AS CHAR  NO-UNDO.
   DEF INPUT  PARAM in-op-date    AS DATE  NO-UNDO.
   DEF INPUT  PARAM vFindRole     AS CHAR  NO-UNDO.

   DEF VAR vTransCode AS CHAR   NO-UNDO.
   DEF VAR vFlagCr    AS CHAR   NO-UNDO. /* Флаг проверки наличия LA. */
   DEF VAR vpj        AS INT64  NO-UNDO.
   DEF VAR vpn        AS INT64  NO-UNDO.
   DEF VAR vRestOldPr AS LOG    NO-UNDO.  /* Восстанавливать ли контекст pp-oldpr перед выходом */

   BLCK:
   DO
   ON ERROR  UNDO BLCK, LEAVE BLCK
   ON ENDKEY UNDO BLCK, LEAVE BLCK:
      IF NUM-ENTRIES (in-cont-code, CHR(1)) GT 1
      THEN ASSIGN
         vFlagCr        =  ENTRY (2, in-cont-code, CHR (1))
         in-cont-code   =  ENTRY (1, in-cont-code, CHR (1))
      .
      vTransCode = getsysconf("ТранзОткрСч").


      FIND FIRST op-kind WHERE op-kind.op-kind EQ vTransCode NO-LOCK NO-ERROR.



      FOR EACH op-template WHERE op-template.op-kind EQ vTransCode NO-LOCK :
         IF GetXAttrValue("op-template",op-kind.op-kind + "," +
                          string(op-templ.op-templ),"acct-type") EQ vFindRole THEN DO:
         LEAVE.
         END.
         ELSE NEXT.
      END.

      IF NOT AVAIL op-template THEN RETURN.

      FIND FIRST loan WHERE loan.cont-code EQ in-cont-code
                  AND loan.contract EQ in-contract NO-LOCK NO-ERROR.

                           /* Сохраняем контекст pp-oldpr */
      RUN GetEnv IN h_oldpr (OUTPUT vpj,
                             OUTPUT vpn).
      vRestOldPr = YES.

      RUN accttmpl.p (
         STRING (RECID(op-templ)) + CHR (1) + vFlagCr,
         RECID(loan),
         in-op-date
      ).
      IF RETURN-VALUE = "-1" THEN
         LEAVE BLCK. /* Создание прошло с ошибкой  дальше не пойдем. */

      FIND LAST tt-editacct NO-LOCK NO-ERROR.
      FIND acct WHERE RECID(acct) EQ tt-editacct.rid NO-LOCK NO-ERROR.
      IF NOT AVAIL acct THEN
         LEAVE BLCK.
      RUN parssign.p (in-op-date,
                      "op-template",
                      op-kind.op-kind + "," + STRING(op-template.op-template),
                      op-template.class-code,
                      "acct",
                      acct.acct + "," + acct.currency,
                      acct.class-code,
                      ?).
      IF AVAIL loan THEN DO:
         RUN SetKau IN h_loanx (RECID(acct),
                                RECID(loan),
                                tt-editacct.acct-type).
         CREATE loan-acct.
         loan-acct.cont-code = loan.cont-code.
         {lacc.ini
            &loan-acct = loan-acct
            &contract  = loan.contract
            &acct      = acct.acct
            &currency  = acct.currency
            &acct-type = tt-editacct.acct-type
         }
         IF mViewAcctLog THEN
         DO:
            IF tt-editacct.fndstat THEN
               RUN CrtLogTbl IN h_aclog (loan-acct.contract,
                                         loan-acct.cont-code,
                                         loan-acct.acct,
                                         loan-acct.acct-type,
                                         YES).
            RUN CrtLogTbl IN h_aclog (loan-acct.contract,
                                      loan-acct.cont-code,
                                      loan-acct.acct,
                                      loan-acct.acct-type,
                                      NO).
         END.
      END.


      pick-value = string(IF CAN-FIND(FIRST  tt-editacct) THEN acct.acct ELSE ?).


      RELEASE loan-acct.
      RELEASE acct.
   END.
   IF vRestOldPr THEN
                        /* Востанавливаем контекст pp-oldpr */
      RUN SetEnv IN h_oldpr (vpj, vpn).
END PROCEDURE.


/*
    * Что делает: Возвращает цифровой код валюты параметра договора на дату.
                  Для национальной валюты возвращает пусто.
    * Синтаксис : ПРМВАЛ (<код параметра>[,<признак даты>])
                  <признак даты>:
                  "ОД"  - дата опер. дня
                  "ПД"  - плановая дата
    * Автор     : amam 15/12/04
    * Пример    : ПРМВАЛ (0,"ОД")
*/
PROCEDURE ПРМВАЛ:
   DEF INPUT PARAM rid         AS RECID     NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE      NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHARACTER NO-UNDO.

   DEF VAR vHTempl   AS HANDLE    NO-UNDO. /* Указатель на параметры договора */
   DEF VAR in_param  AS INT64   NO-UNDO.  /* Параметр по договору */
   DEF VAR vContract AS CHARACTER NO-UNDO.
   DEF VAR vContCode AS CHARACTER NO-UNDO.
   DEF VAR vDate     AS DATE      NO-UNDO.
   DEF VAR vCurr     AS CHARACTER NO-UNDO.

   DEF BUFFER loan FOR loan.

   IF param-count < 1 OR param-count > 2 THEN
   DO:
      RUN Fill-Sysmes IN h_tmess ("", "", "0", "Ошибочное количество параметров передано в процедуру ПРМВАЛ: " + STRING(param-count) + "\n(должно быть 2) !").
      RETURN.
   END.

   /* Определение правильного применения функции,
   ** формат private-data */
   RUN LOAN_VALID_HANDLE(INPUT-OUTPUT vHTempl).

   /* Номер договора не определен */
   IF NOT VALID-HANDLE(vHTempl) THEN
   DO :
      pick-value = ?.
      RETURN.
   END.

   ASSIGN
      vContract = ENTRY(1, vHTempl:PRIVATE-DATA)
      vContCode = ENTRY(2, vHTempl:PRIVATE-DATA).

   /* Поиск договора */
   RUN RE_B_LOAN (vContract, vContCode, BUFFER loan).
   IF NOT AVAIL loan THEN
   DO:
      pick-value = ?.
      RETURN.
   END.

   /* ищем wop для определения плановой даты */
   FIND FIRST wop WHERE RECID(wop) = rid NO-LOCK NO-ERROR.
   IF NOT AVAIL wop THEN
   DO:
      pick-value = ?.
      RETURN .
   END.

   ASSIGN
      in_param = INT64( getparam(1,param-str) )
      vDate    = IF getparam(2,param-str) = "ОД" OR getparam(2,param-str) = ?
                 THEN in-op-date
                 ELSE wop.con-date

      pick-value = LN_GetParamCurr(vContract,      /* Идентификатор   */
                                   vContCode,      /* договора        */
                                   in_param,       /* Код Параметра   */
                                   loan.currency,  /* Валюта договора */
                                   vDate)          /* Дата расчета    */
      .
END PROCEDURE.


/*
   * Что делает: Возвращает значение параметра договора в нац.валюте на дату.
                 Если договор не пересчитан на требуемую дату возвращает ошибку.
   * Синтаксис : ПрмЭкв (<код параметра>[,<признак даты>[,<текущие проценты>]])
                 <признак даты>:
                 "ОД"  - дата опер. дня
                 "ПД"  - плановая дата
                 <текущие проценты> (по умолчанию Нет):
                 "Нет" - не учитывать проценты сохраненные в loan.interest[i]
                 "Да"  - учитывать проценты сохраненные в loan.interest[i]
   * Автор     : amam 15/12/04
   * Пример    : ПрмЭкв (0,"ОД")
*/
PROCEDURE ПРМЭКВ:
   DEF INPUT PARAM rid         AS RECID     NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE      NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHARACTER NO-UNDO.

   DEF VAR vHTempl   AS HANDLE    NO-UNDO. /* Указатель на параметры договора */
   DEF VAR vCurr     AS CHARACTER NO-UNDO.
   DEF VAR vContract AS CHARACTER NO-UNDO. /* назначение договора */
   DEF VAR vContCode AS CHARACTER NO-UNDO. /* номер договора */
   DEF VAR vDate     AS DATE      NO-UNDO. /* Требуемая дата расчета */
   DEF VAR vDateType AS CHARACTER NO-UNDO. /* признак даты */
   DEF VAR in_param  AS INT64   NO-UNDO. /* Параметр по договору */
   DEF VAR vRateLog  AS LOGICAL   NO-UNDO. /* Учитывать проценты из массива */
   DEF VAR vDbOpDec  AS DECIMAL   NO-UNDO. /* Е дб. операций (не используется) */
   DEF VAR vCrOpDec  AS DECIMAL   NO-UNDO. /* Е кр. операций (не используется) */
   DEF VAR summ      AS DECIMAL   NO-UNDO.

   DEF BUFFER loan FOR loan.

   IF param-count < 1 OR param-count > 3 THEN
   DO:
      RUN Fill-Sysmes IN h_tmess ("", "", "0", "Ошибочное количество параметров передано в процедуру ПРМЭКВ: " + STRING(param-count) + "\n(должно быть 2 или 3) !").
      RETURN.
   END.

   /* Определение правильного применения функции,
   ** формат private-data */
   RUN LOAN_VALID_HANDLE(INPUT-OUTPUT vHTempl).

   /* Номер договора не определен */
   IF NOT VALID-HANDLE(vHTempl) THEN
   DO :
      pick-value = ?.
      RETURN.
   END.

   ASSIGN
      vContract = ENTRY(1, vHTempl:PRIVATE-DATA)
      vContCode = ENTRY(2, vHTempl:PRIVATE-DATA).

   /* Поиск договора */
   RUN RE_B_LOAN (vContract, vContCode, BUFFER loan).
   IF NOT AVAIL loan THEN
   DO:
      pick-value = ?.
      RETURN.
   END.

   /* ищем wop для определения плановой даты */
   FIND FIRST wop WHERE RECID(wop) = rid NO-LOCK NO-ERROR.
   IF NOT AVAIL wop THEN
   DO:
      pick-value = ?.
      RETURN .
   END.

   ASSIGN
      in_param  = INT64( getparam(1,param-str) )
      vDateType = getparam(2,param-str)
      vDate     = IF vDateType = "ОД" OR vDateType = ? THEN in-op-date
                                                       ELSE wop.con-date
      vRateLog  = getparam(3,param-str) EQ "Да"
      .

   IF loan.since NE (IF vDateType EQ "ОД" THEN in-op-date
                                          ELSE wop.con-date)
   THEN DO:
      RUN Fill-Sysmes IN h_tmess ("", "", "0", "Договор" + loan.cont-code + " не пересчитан на дату " + STRING(vDate, "99/99/9999") + "!").
      RETURN.
   END.

   /* Получение значения параметра */
   RUN STNDRT_PARAM(
       loan.contract,    /* Назначение договора */
       loan.cont-code,   /* Номер договора */
       in_param,         /* Код параметра  */
       loan.since,       /* Значение параметра на дату состояния договора */
       OUTPUT summ,      /* Значение параметра без loan.interest[i] */
       OUTPUT vDbOpDec,  /* Е дб операций (не используется) */
       OUTPUT vCrOpDec). /* Е кр операций (не используется) */

   /* Если есть признак "учитывать текущие проценты по параметрам" */
   IF vRateLog THEN DO:
       IF in_param = 81 OR
          in_param = 82 OR
          in_param = 96
       THEN
          summ = summ + LoadPar(IF in_param = 81
                                THEN 11
                                ELSE IF in_param = 82
                                THEN 12
                                ELSE 13 ,loan.contract + ',' + loan.cont-code).
       ELSE DO:
          IF mass[in_param + 1] GT 0 THEN
             summ = summ + loan.interest[mass[in_param + 1]].
       END.
   END.

   vCurr = LN_GetParamCurr(vContract,       /* Идентификатор   */
                           vContCode,       /* договора        */
                           in_param,        /* Код Параметра   */
                           loan.currency,   /* Валюта договора */
                           vDate).          /* Дата расчета    */
   IF vCurr <> "" THEN
      summ = CurToBase("УЧЕТНЫЙ",   /*тип курса*/
                       vCurr,       /*из валюты*/
                       vDate,       /*дата*/
                       summ).       /*переводимая сумма*/

   pick-value = STRING(summ).
END PROCEDURE.

PROCEDURE РегРезерва:
   DEF INPUT  PARAM rid         AS RECID NO-UNDO.
   DEF INPUT  PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT  PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT  PARAM param-str   AS CHAR  NO-UNDO.

   DEF VAR vHTempl   AS HANDLE NO-UNDO. /* Указатель на параметры договора */
   DEF VAR vContract AS CHAR   NO-UNDO. /* назначение договора */
   DEF VAR vContCode AS CHAR   NO-UNDO. /* номер договора */
   DEF VAR end-date  AS DATE   NO-UNDO.

   IF param-count <> 0 THEN DO:
      RUN Fill-Sysmes IN h_tmess ("", "", "-1", "Ошибочное количество параметров передано в функцию РегРезерва:" +
                                                STRING(param-count) + "\n(должно быть 2)!").
      RETURN.
   END.

   /* Определение правильного применения функции,
   ** формат private-data */
   RUN LOAN_VALID_HANDLE(INPUT-OUTPUT vHTempl).

   /* Номер договора не определен */
   IF NOT VALID-HANDLE(vHTempl) THEN DO :
      pick-value = ?.
      RETURN.
   END.

   vContract = ENTRY(1, vHTempl:PRIVATE-DATA).
   vContCode = ENTRY(2, vHTempl:PRIVATE-DATA).

   IF vContract <> "Кредит" THEN DO:  /* Неверное назначение договора */
      pick-value = ?.
      RETURN.
   END.

   /* Поиск договора */
   RUN RE_B_LOAN (vContract, vContCode, BUFFER loan).

   IF NOT AVAIL loan THEN DO:
      pick-value = ?.
      RETURN.
   END.

   /* поиск даты предыдущего операционного дня */
   FIND LAST op-date WHERE op-date.op-date < in-op-date NO-ERROR.

   IF AVAIL op-date THEN end-date = op-date.op-date.
                    ELSE end-date = in-op-date.

   {getdate.i
       &DateLabel = "Предыд.урегулир."
       &DateHelp  = "Дата предыдущего урегулирования резерва (F1 - календарь)"
   }

   pick-value = IF RegulationNeed(vContract, vContCode, end-date, in-op-date)
                THEN "1"
                ELSE "0".

END PROCEDURE.

/* определение суммы досрочного погашения */
PROCEDURE СумДсрПг:
   DEFINE INPUT  PARAMETER rid         AS RECID       NO-UNDO.
   DEFINE INPUT  PARAMETER in-op-date  AS DATE        NO-UNDO.
   DEFINE INPUT  PARAMETER param-count AS INT64     NO-UNDO.
   DEFINE INPUT  PARAMETER param-str   AS CHARACTER   NO-UNDO.

   DEF VAR vHTempl   AS HANDLE    NO-UNDO. /* Указатель на параметры договора */
   DEF VAR vContract AS CHARACTER NO-UNDO.
   DEF VAR vContCode AS CHARACTER NO-UNDO.

   DEF BUFFER loan FOR loan.

   /* Определение правильного применения функции,
   ** формат private-data */
   RUN LOAN_VALID_HANDLE(INPUT-OUTPUT vHTempl).

   /* Номер договора не определен */
   IF NOT VALID-HANDLE(vHTempl) THEN
   DO :
      pick-value = ?.
      RETURN.
   END.

   ASSIGN
      vContract = ENTRY(1, vHTempl:PRIVATE-DATA)
      vContCode = ENTRY(2, vHTempl:PRIVATE-DATA)
   .
   RUN GetSumDp IN h_pint(rid,
                          in-op-date,
                          param-count,
                          param-str,
                          vContract,
                          vContCode).
END PROCEDURE.

/* определение суммы штрафа за неисполнение досрочного погашения */
PROCEDURE СумШтрНеДП:
   DEFINE INPUT  PARAMETER rid         AS RECID       NO-UNDO.
   DEFINE INPUT  PARAMETER in-op-date  AS DATE        NO-UNDO.
   DEFINE INPUT  PARAMETER param-count AS INT64     NO-UNDO.
   DEFINE INPUT  PARAMETER param-str   AS CHARACTER   NO-UNDO.

   DEF VAR vHTempl   AS HANDLE    NO-UNDO. /* Указатель на параметры договора */
   DEF VAR vContract AS CHARACTER NO-UNDO.
   DEF VAR vContCode AS CHARACTER NO-UNDO.

   DEF BUFFER loan FOR loan.

   /* Определение правильного применения функции,
   ** формат private-data */
   RUN LOAN_VALID_HANDLE(INPUT-OUTPUT vHTempl).

   /* Номер договора не определен */
   IF NOT VALID-HANDLE(vHTempl) THEN
   DO :
      pick-value = ?.
      RETURN.
   END.

   ASSIGN
      vContract = ENTRY(1, vHTempl:PRIVATE-DATA)
      vContCode = ENTRY(2, vHTempl:PRIVATE-DATA)
   .
   RUN GetShtrDp IN h_pint(rid,
                           in-op-date,
                           param-count,
                           param-str,
                           vContract,
                           vContCode).
END PROCEDURE.

/*
требование:
Для вычисления сумм уплаченных процентов и других разнообразных показателей
предлагается реализовать парсерную функцию ПрмОб(), реализующую подсчет
оборотов по параметру договора в корреспонденции с указанными параметрами.

Параметры функции:
- (обязательный) код параметра;
- (обязательный) тип оборота, варианты:
  НЧ - начислено (выборка по loan-int.id-d);
  СП - списано   (выборка по loan-int.id-k);
- (обязательный) маска номеров корреспондирующих параметров
  указывается в формате CAN-DO()
- (НЕ обязательный) дата, от которой считать обороты
  НД - начало договора
  НМ - начало текущего месяца
  ОД - начало опердня
  ПД - начало планового дня
  По умолчанию "НД"

Расчет значения накопленных оборотов выполняется за период с даты начала
договора по плановую дату операции (op.contract-date).

* Пример: ПрмОб(6,СП,5) - сумма всех операций с кодом 10, выполненных по
договору с даты его начала по плановую дату.

*/

PROCEDURE ПрмОб :
   DEFINE INPUT  PARAMETER rid         AS RECID NO-UNDO.
   DEFINE INPUT  PARAMETER in-op-date  AS DATE  NO-UNDO.
   DEFINE INPUT  PARAMETER param-count AS INT64   NO-UNDO.
   DEFINE INPUT  PARAMETER param-str   AS CHAR  NO-UNDO.

   DEFINE VARIABLE vLoanHandle AS HANDLE  NO-UNDO.
   DEFINE VARIABLE vReturn     AS DECIMAL INITIAL 0 NO-UNDO.
   DEFINE VARIABLE isOK        AS LOGICAL NO-UNDO.
   DEFINE VARIABLE vDateClcBeg AS CHAR    NO-UNDO.
   DEFINE VARIABLE vDateClcEnd AS CHAR    NO-UNDO.
   DEFINE VARIABLE vSinceBeg   AS DATE    NO-UNDO.
   DEFINE VARIABLE vSinceEnd   AS DATE    NO-UNDO.
   DEFINE VARIABLE vtermtype   AS INT64   NO-UNDO.

   DEF BUFFER loan FOR loan.

   pick-value = ?.
   IF    param-count LT 3
     AND param-count GT 5 THEN
   DO:
      RUN Fill-Sysmes IN h_tmess ("", "", "-1", "ОШИБОЧНОЕ количество параметров передано в функцию " +
                                                STRING(PROGRAM-NAME(1)) + ": \n(должно быть от 3 до 5)!").
      RETURN.
   END.
   ELSE
   DO:
      vDateClcBeg = IF param-count GE 4 THEN GetParam(4, param-str)
                                        ELSE "".
      vDateClcEnd = IF param-count EQ 5 THEN GetParam(5, param-str)
                                        ELSE "".

      FIND FIRST wop WHERE RECID(wop) EQ rid NO-ERROR.
      IF AVAIL wop THEN
      DO:
         RUN LOAN_VALID_HANDLE (INPUT-OUTPUT vLoanHandle).
         IF VALID-HANDLE (vLoanHandle) THEN
         DO:
            FIND FIRST loan WHERE loan.contract  EQ ENTRY(1,vLoanHandle:private-data)
                              AND loan.cont-code EQ ENTRY(2,vLoanHandle:private-data)
                            NO-LOCK NO-ERROR.

            CASE vDateClcBeg :
               WHEN "НМ" THEN
                  vSinceBeg = DATE(MONTH(in-op-date),1,YEAR(in-op-date)).
               WHEN "ППД1" THEN DO:
                  FIND LAST term-obl WHERE term-obl.contract  EQ loan.contract
                                       AND term-obl.cont-code EQ loan.cont-code
                                       AND term-obl.idnt      EQ 1
                                       AND term-obl.end-date  LE in-op-date
                                     NO-LOCK NO-ERROR.

                  vSinceBeg = IF AVAIL term-obl THEN term-obl.end-date
                                                ELSE in-op-date.
               END.
               WHEN "ППД2" THEN DO:
                  FIND LAST term-obl WHERE term-obl.contract  EQ loan.contract
                                       AND term-obl.cont-code EQ loan.cont-code
                                       AND term-obl.idnt      EQ 3
                                       AND term-obl.end-date  LE in-op-date
                                     NO-LOCK NO-ERROR.

                  vSinceBeg = IF AVAIL term-obl THEN term-obl.end-date
                                                ELSE in-op-date.
               END.
               WHEN "ОД" THEN
                  vSinceBeg = in-op-date.
               WHEN "ПД" THEN
                  vSinceBeg = in-op-date.
               WHEN "НД" THEN
                  vSinceBeg = loan.open-date.
               OTHERWISE DO:
                  vSinceBeg = wop.con-date.
               END.
            END CASE.

            CASE vDateClcEnd :
               WHEN "НМ" THEN
                  vSinceEnd = DATE(MONTH(in-op-date),1,YEAR(in-op-date)).
               WHEN "ППД1" THEN DO:
                  FIND LAST term-obl WHERE term-obl.contract  EQ loan.contract
                                       AND term-obl.cont-code EQ loan.cont-code
                                       AND term-obl.idnt      EQ 1
                                       AND term-obl.end-date  LE in-op-date
                                     NO-LOCK NO-ERROR.

                  vSinceEnd = IF AVAIL term-obl THEN term-obl.end-date
                                                ELSE in-op-date.
               END.
               WHEN "ППД2" THEN DO:
                  FIND LAST term-obl WHERE term-obl.contract  EQ loan.contract
                                       AND term-obl.cont-code EQ loan.cont-code
                                       AND term-obl.idnt      EQ 3
                                       AND term-obl.end-date  LE in-op-date
                                     NO-LOCK NO-ERROR.

                  vSinceEnd = IF AVAIL term-obl THEN term-obl.end-date
                                                ELSE in-op-date.
               END.
               WHEN "ОД" THEN
                  vSinceEnd = in-op-date.
               WHEN "ПД" THEN
                  vSinceEnd = in-op-date.
               WHEN "НД" THEN
                  vSinceEnd = loan.open-date.
               OTHERWISE DO:
                  vSinceEnd = wop.con-date.
               END.
            END CASE.

            RUN _ПрмОб IN h_pint (
               loan.contract,
               loan.cont-code,
               GetParam(1, param-str), /*код параметра*/
               GetParam(2, param-str), /*тип оборота {нч|сп}*/
               GetParam(3, param-str), /*маска корреспондирующих пар-в*/
               vSinceBeg, /*дата от которой считать обороты*/
               vSinceEnd, /*дата до которой считать обороты*/
               OUTPUT vReturn,
               OUTPUT isOK).
            IF isOK THEN
               ASSIGN
                  pick-value = STRING(vReturn)
               .
         END. /*valid-handle*/
      END. /*avail wop*/
   END.
END PROCEDURE.


/*
Для вычисления сумм процентов, штарфов и пени за некоторый временной период
при исполнении транзакции предлагается реализовать новую парсерную функцию
ПроцПар(). Задача функции - выполнить расчет суммы процентов указанного вида
за указанный настройщиком интервал дат - в точности так же, как это делает
процентная ведомость.

Параметры функции:

- (обязательный) код параметра, соответствующего статье начисления процентов;

- (обязательный) код типа даты, вплоть до которой выполняется расчет
  процентов, варианты:

  ПД - плановая дата операции (op.contract-date);
  ОД - дата операционного дня (op.op-date);
  ГП - дата окончания истекшего периода уплаты процентов;

     Если плановая дата операции совпадает с датой из графика уплаты
     процентов, то в качестве даты окончания периода расчета должна быть
     использована эта дата.
     Если плановая дата операции не совпадает с датой из графика уплаты
     процентов, то должен быть выполнен поиск предшествующей плановой даты
     уплаты процентов.
     Если эта дата найдена, то она должна быть использована в качестве даты
     окончания периода расчета.
     Если такая дата не найдена, то функция ПроцПар() должна возвратить 0.

  ГБ - дата окончания текущего периода уплаты процентов;

     Если плановая дата операции совпадает с датой из графика уплаты
     процентов, то в качестве даты окончания периода расчета должна быть
     использована эта дата.
     Если плановая дата операции не совпадает с датой из графика уплаты
     процентов, то должен быть выполнен поиск следующей плановой даты уплаты
     процентов.
     Если эта дата найдена, то она должна быть использована в качестве даты
     окончания периода расчета.
     Если такая дата не найдена, то функция ПроцПар() должна возвратить 0.

- (необязательный) код типа даты, начиная с которой выполняется расчет
  процентов, варианты:

  НД - дата начала договора (умолчание);
  НП - дата начала периода уплаты процентов.

     Выполняется поиск плановой даты уплаты процентов, предшествующей дате,
     вплоть до которой выполняется расчет процентов.
     Если такая дата найдена, то искомая дата вычисляется прибавлением к
     найденной дате одного дня.
     Если дата не найдена, то используется дата начала договора.

* Пример: ПроцПар(4,ГП,НД) - сумма процентов, начисленных на срочную
задолженность, за период от начала договора до плановой даты уплаты процентов,
которая равна или предшествует плановой дате операции.
*/
PROCEDURE ПроцПар:
   DEFINE INPUT  PARAMETER rid         AS RECID NO-UNDO.
   DEFINE INPUT  PARAMETER in-op-date  AS DATE  NO-UNDO.
   DEFINE INPUT  PARAMETER param-count AS INT64   NO-UNDO.
   DEFINE INPUT  PARAMETER param-str   AS CHAR  NO-UNDO.

   DEFINE VARIABLE vLoanHandle AS HANDLE NO-UNDO.
   DEFINE VARIABLE vReturn AS DECIMAL INITIAL 0.0 NO-UNDO.
   DEFINE VARIABLE isOK AS LOGICAL NO-UNDO.

   pick-value = ?.
   IF param-count NE 3
      AND param-count NE 2 THEN
   DO:
      RUN Fill-Sysmes IN h_tmess ("", "", "-1", "ОШИБОЧНОЕ количество параметров передано в функцию " +
                                                STRING(PROGRAM-NAME(1)) + ": \n(должно быть 2 или 3)!").
      RETURN.
   END.
   ELSE
   DO:
      FIND FIRST wop WHERE RECID(wop) EQ rid NO-ERROR.
      IF AVAIL wop THEN
      DO:
         RUN LOAN_VALID_HANDLE (INPUT-OUTPUT vLoanHandle).
         IF VALID-HANDLE (vLoanHandle) THEN
         DO:
            RUN _ПроцПар IN h_pint (
               ENTRY(1,vLoanHandle:private-data),
               ENTRY(2,vLoanHandle:private-data),
               INT64(GetParam(1, param-str)), /*код параметра*/

               IF param-count EQ 3 THEN
                  GetParam(3, param-str) /*тип даты {НД*|НП}*/
               ELSE
               "НД" ,
               GetParam(2, param-str), /*тип даты {ПД|ОД|ГП|ГБ}*/

               wop.con-date,
               in-op-date,
               OUTPUT vReturn,
               OUTPUT isOK).

            IF isOK THEN
               ASSIGN
                  pick-value = STRING(vReturn)
               .
         END. /*valid-handle*/
      END. /*avail wop*/
   END.
END PROCEDURE.


/*{{{ ПлатПериодПр:
требование:
Реализовать парсерную функцию ПлатПериодПр(). Функция должна возвращать 1,
если плановая дата операции (op.contract-date) принадлежит платежному периоду
уплаты процентов, то есть совпадает с некоторой плановой датой графика уплаты
процентов, либо принадлежит периоду пробега после некоторой плановой даты
этого графика. */
PROCEDURE ПлатПериодПр:
   DEFINE INPUT  PARAMETER rid         AS RECID NO-UNDO.
   DEFINE INPUT  PARAMETER in-op-date  AS DATE  NO-UNDO.
   DEFINE INPUT  PARAMETER param-count AS INT64   NO-UNDO.
   DEFINE INPUT  PARAMETER param-str   AS CHAR  NO-UNDO.

   DEFINE VARIABLE vLoanHandle AS HANDLE NO-UNDO.
   DEFINE VARIABLE vReturn AS INT64 INITIAL 0 NO-UNDO.
   DEFINE VARIABLE isOK AS LOGICAL NO-UNDO.

   pick-value = ?.
   IF param-count NE 0 THEN
   DO:
      RUN Fill-Sysmes IN h_tmess ("", "", "-1", "ОШИБОЧНОЕ количество параметров передано в функцию " +
                                                STRING(PROGRAM-NAME(1)) + ": \n(должно быть 0)!").
      RETURN.
   END.
   ELSE
   DO:
      FIND FIRST wop WHERE RECID(wop) EQ rid NO-ERROR.
      IF AVAIL wop THEN
      DO:
         RUN LOAN_VALID_HANDLE (INPUT-OUTPUT vLoanHandle).
         IF VALID-HANDLE (vLoanHandle) THEN
         DO:
            RUN _ПлатПериод IN h_pint (
               ENTRY(1,vLoanHandle:private-data),
               ENTRY(2,vLoanHandle:private-data),
               wop.con-date,
               1, /*idnt=1*/
               OUTPUT vReturn).

            ASSIGN
               pick-value = STRING(vReturn)
            .
         END. /*valid-handle*/
      END. /*avail wop*/
   END.
END PROCEDURE.
/* }}} */


/* {{{ ПлатПериодОД
требование:
Реализовать парсерную функцию ПлатПериодОД(). Функция должна возвращать 1,
если плановая дата операции (op.contract-date) принадлежит платежному периоду
уплаты ОСНОВНОГО ДОЛГА, то есть совпадает с некоторой плановой датой графика уплаты
ОСНОВНОГО ДОЛГА, либо принадлежит периоду пробега после некоторой плановой даты
этого графика. */
PROCEDURE ПлатПериодОД:
   DEFINE INPUT  PARAMETER rid         AS RECID NO-UNDO.
   DEFINE INPUT  PARAMETER in-op-date  AS DATE  NO-UNDO.
   DEFINE INPUT  PARAMETER param-count AS INT64   NO-UNDO.
   DEFINE INPUT  PARAMETER param-str   AS CHAR  NO-UNDO.

   DEFINE VARIABLE vLoanHandle AS HANDLE NO-UNDO.
   DEFINE VARIABLE vReturn AS INT64 INITIAL 0 NO-UNDO.
   DEFINE VARIABLE isOK AS LOGICAL NO-UNDO.

   pick-value = ?.
   IF param-count NE 0 THEN
   DO:
      RUN Fill-Sysmes IN h_tmess ("", "", "-1", "ОШИБОЧНОЕ количество параметров передано в процедуру " +
                                                STRING(PROGRAM-NAME(1)) + ": \n(должно быть 0)!").
      RETURN.
   END.
   ELSE
   DO:
      FIND FIRST wop WHERE RECID(wop) EQ rid NO-ERROR.
      IF AVAIL wop THEN
      DO:
         RUN LOAN_VALID_HANDLE (INPUT-OUTPUT vLoanHandle).
         IF VALID-HANDLE (vLoanHandle) THEN
         DO:
            RUN _ПлатПериод IN h_pint (
               ENTRY(1,vLoanHandle:private-data),
               ENTRY(2,vLoanHandle:private-data),
               wop.con-date,
               3, /*для idnt=3*/
               OUTPUT vReturn).

            ASSIGN
               pick-value = STRING(vReturn)
            .
         END. /*valid-handle*/
      END. /*avail wop*/
   END.
END PROCEDURE.
/* }}} */




   /* ==============================-=-=-=-= */
   /* Поиск операции договора                */
   /* Вспомогательная, используется РольСРез */
PROCEDURE FindLoanOper.
   DEF INPUT  PARAM iContract    AS CHAR NO-UNDO.     /* Назначение договора */
   DEF INPUT  PARAM iContCode    AS CHAR NO-UNDO.     /* Номер договора */
   DEF INPUT  PARAM iDate        AS DATE NO-UNDO.     /* Дата расчета */
   DEF INPUT  PARAM iId-d        AS INT64  NO-UNDO.     /* Параметр начисления */
   DEF INPUT  PARAM iId-k        AS INT64  NO-UNDO.     /* Параметр списания */
   DEF PARAM BUFFER loan-int     FOR loan-int.        /* Возвращает буфер на loan-int */

   DEF BUFFER b-loan-int   FOR loan-int.
   DEF BUFFER op-entry     FOR op-entry.
   DEF BUFFER op           FOR op.

   /* Поиск операции по договору. LT не учитываем текущий день, т.к. по счетам
   ** КредРСозд / КредРСпис уже могли быть проводки по списанию из-за переноса между ПОСами. */

      /* Поиск loan-int'ов по индексу "contract-d-mdate", т.к.
      ** он содержит поле id-d, и в данном случае будет самым быстрым */
   FIND LAST loan-int WHERE
             loan-int.contract  EQ iContract
      AND    loan-int.cont-code EQ iContCode
      AND    loan-int.id-d      EQ iId-d
      AND    loan-int.mdate     LT iDate
      AND    loan-int.id-k      EQ iId-k
   NO-LOCK NO-ERROR.
      /* Необходимо найти обе операции, и взять самую позднюю, т.к.
      ** can-find работает быстрее непосредственно FIND'a, то */
   IF    (AVAIL loan-int AND CAN-FIND(LAST b-loan-int WHERE
                                           b-loan-int.contract  EQ iContract
                                       AND b-loan-int.cont-code EQ iContCode
                                       AND b-loan-int.id-d      EQ iId-k
                                       AND b-loan-int.mdate     LT iDate
                                       AND b-loan-int.mdate     GT loan-int.mdate
                                       AND b-loan-int.id-k      EQ iId-d ))
      OR NOT AVAIL loan-int THEN
   DO:
         /* Если есть такая операция, но есть ответная, и при этом более поздняя
         ** или не нашли такую операцию, то ищем: */
      FIND LAST loan-int WHERE
                loan-int.contract  EQ iContract
         AND    loan-int.cont-code EQ iContCode
         AND    loan-int.id-d      EQ iId-k
         AND    loan-int.mdate     LT iDate
         AND    loan-int.id-k      EQ iId-d
      NO-LOCK NO-ERROR.
   END.

END PROCEDURE.    /* FindLoanOper */

/* Что делает: Ищет счет с указанной ролью, если не найден, то запускает
**             соответствующий шаблон создания счета с этой ролью.
** Синтаксис : Роль(<роль счета>, [<где искать счет>, [<вывод сообщения>, [<плановая дата>, [<не искать дог. для резерв.>]]]])
**             <роль счета>      - роль счета для поиска
**             необязатаельные параметры:
**             <где искать счет> - если параметр не указан или "НЕТ", то будет искаться счет по привязкам (loan-acct),
**                                 если "ДА", то будет искаться последняя проводка урегулирования по ссуде и счет будет взят из нее.
**             <вывод сообщения> - выводить ли сообщения об ошибках
**             <плановая дата>   - искать привязки на плановую дату
**             <не искать дог. для резерв.> - не определять договор, по которому реально ведется урегулирование
** Автор     : fepa 17/09/04
** Пример    : РольСРез("Кредит", Да, "Да", "ПД")
*/
PROCEDURE РольСРез.
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEF VAR vin-contract AS CHARACTER NO-UNDO.
   DEF VAR vin-contcode AS CHARACTER NO-UNDO.
   DEF VAR vFindRole    AS CHARACTER NO-UNDO.
   DEF VAR vKauDb       AS CHARACTER NO-UNDO.
   DEF VAR vKauCr       AS CHARACTER NO-UNDO.
   DEF VAR vSettlement  AS LOGICAL   NO-UNDO.
   DEF VAR h_templ      AS HANDLE    NO-UNDO.
   DEF VAR vCurrency    AS CHAR      NO-UNDO.
   DEF VAR vPos         AS CHAR      NO-UNDO. /* Код ПОСа. */
   DEF VAR vPosLAcct    AS CHAR      NO-UNDO. /* Счет ссуды ПОСа. */
   DEF VAR vBegDate     AS DATE      NO-UNDO. /* Дата начала поиска. */
   DEF VAR vLastLA      AS DATE      NO-UNDO. /* Дата последнего loan-acct. */
   DEF VAR vRoleOnPOS   AS LOG       NO-UNDO. /* счет с ролью ведется на ПОС? YES/NO */
   DEF VAR vMRole       AS CHAR      NO-UNDO. /* список обязательных для ПОС'а ролей счетов */
   DEF VAR vMesFl       AS LOG INIT YES NO-UNDO. /* выводить/не выводить сообщений */
   DEF VAR vDateCB      AS DATE      NO-UNDO. /* Дата создания счёта */
   DEF VAR vNoSrchRsrvL AS LOG       NO-UNDO. /* не определять договор, по которому реально ведется урегулирование */
   DEF VAR vCreateAcct  AS LOG       NO-UNDO. /* Открывать счета */
   DEF VAR vAcctRB      AS CHAR      NO-UNDO. /* Для обработки счетов с ролью КредРезВб */

   DEF BUFFER acct       FOR acct.      /* Локализация буфера. */
   DEF BUFFER loan       FOR loan.      /* Локализация буфера. */
   DEF BUFFER op-entry   FOR op-entry.  /* Локализация буфера. */
   DEF BUFFER loan-int   FOR loan-int.  /* Локализация буфера. */
   DEF BUFFER loan-acct  FOR loan-acct. /* Локализация буфера. */
   DEF BUFFER rloan-acct FOR loan-acct. /* Локализация буфера. */
   DEF BUFFER NewLA      FOR loan-acct. /* Для копирования старой привязки. */
   DEF BUFFER signs      FOR signs.     /* Локализация буфера. */

   BLCK:
   DO
   ON ERROR    UNDO BLCK, LEAVE BLCK
   ON ENDKEY   UNDO BLCK, LEAVE BLCK:
                        /* Сброс возвращаемого значения. */
      pick-value  =  ?.
                        /* Определение режима работы. */
      vFindRole = getparam(1,param-str).
      IF param-count GE 2
         THEN vSettlement = getparam(2, param-str) EQ "Да".
                        /* выводить/не выводить сообщений */
      IF param-count GE 3
         THEN vMesFl = getparam(3, param-str) EQ "Да".

      FIND FIRST wop WHERE RECID(wop) = rid NO-LOCK.
      vDateCB = MIN (in-op-date,wop.con-date).
      IF     param-count           GE 4
         AND getparam(4,param-str) EQ "ПД"
      THEN
         in-op-date = wop.con-date .

      IF param-count GE 5 THEN
         vNoSrchRsrvL = getparam(5, param-str) EQ "Да".

      IF param-count GE 6 THEN
         vCreateAcct = getparam(6, param-str) EQ "Да".
      ELSE
         vCreateAcct = YES.

                        /* Определение правильного применения функции, формат private-data */
      RUN LOAN_VALID_HANDLE (INPUT-OUTPUT h_templ).
      IF NOT VALID-HANDLE(h_templ)
         THEN LEAVE BLCK.
                        /* Получение идентификатора договора. */
      ASSIGN
         vin-contract = ENTRY(1,h_templ:PRIVATE-DATA)
         vin-contcode = ENTRY(2,h_templ:PRIVATE-DATA)
      .

      RUN FindLPResult(vin-contract,
                       vin-contcode,
                       "РольСРез",
                       param-str,
                       OUTPUT pick-value).
      IF pick-value EQ "" THEN
      DO:

         /* Определение договора, по которому реально ведется урегулирование */
         IF NOT vNoSrchRsrvL THEN
         RUN LnWhereResType (vin-contract,
                             vin-contcode,
                             vFindRole,
                             OUTPUT vin-contract,
                             OUTPUT vin-contcode).
            /* Поиск договора. */
         FIND FIRST loan WHERE
                  loan.contract  EQ vin-contract
            AND   loan.cont-code EQ vin-contcode
         NO-LOCK NO-ERROR.
         IF NOT AVAIL loan
            THEN LEAVE BLCK.
            /* Получаем код портфеля. */
         ASSIGN
            vPos       =  LnInBagOnDate (vin-contract, vin-contcode, in-op-date)
            vBegDate   =  loan.open-date
         .

         /* ссуда принадлежит ПОС */
         IF vPos NE ? THEN
            ASSIGN
                          /* список обязательных для ПОС'а ролей счетов */
               vMRole     =  GetXAttrValueEx("loan","ПОС" + "," + vPos,"ПОСРоль",FGetSetting("ПОС","ПОСРольОбяз",""))
                          /* счет с ролью ведется на ПОС - YES/индивидуально - NO */
               vRoleOnPOS =  CAN-DO(vMRole,vFindRole)
            .

            /* Поиск последнего счета по которому было урегулирование. */
         IF vSettlement THEN
         DO:
            RELEASE loan-int.
               /* Операции 32/33 */
            IF CAN-DO("КредРез,КредРСпис,КредРСозд", vFindRole) THEN
               RUN FindLoanOper (vin-contract,        /* Назначение договора */
                                 vin-contcode,        /* Номер договора */
                                 in-op-date,          /* Дата расчета */
                                 22,                  /* Параметр начисления */
                                 21,                  /* Параметр списания */
                                 BUFFER loan-int).    /* Буфер loan-int */
               /* Операции 136/137 */
            ELSE IF CAN-DO("КредРез1,КредРСпис,КредРСозд", vFindRole) THEN
               RUN FindLoanOper (vin-contract,        /* Назначение договора */
                                 vin-contcode,        /* Номер договора */
                                 IF AVAIL loan-int    /* Для ролей КредРСпис,КредРСозд  */
                                    THEN loan-int.mdate
                                    ELSE in-op-date,  /* Дата расчета */
                                 22,                  /* Параметр начисления */
                                 46,                  /* Параметр списания */
                                 BUFFER loan-int).    /* Буфер loan-int */
               /* Операции 470/471. 350 - резерв на возм. потери по %%  */
            ELSE IF CAN-DO("КредРезП,КредРСпП,КредРСзП", vFindRole) THEN
               RUN FindLoanOper (vin-contract,        /* Назначение договора */
                                 vin-contcode,        /* Номер договора */
                                 in-op-date,          /* Дата расчета */
                                 22,                  /* Параметр начисления */
                                 350,                 /* Параметр списания */
                                 BUFFER loan-int).    /* Буфер loan-int */
               /* Операции 473/474. 351 - резерв на возм. потери по просроченным %% */
            ELSE IF CAN-DO("КредРезПр,КредРСпПр,КредРСзПр", vFindRole) THEN
               RUN FindLoanOper (vin-contract,        /* Назначение договора */
                                 vin-contcode,        /* Номер договора */
                                 in-op-date,          /* Дата расчета */
                                 22,                  /* Параметр начисления */
                                 351,                 /* Параметр списания */
                                 BUFFER loan-int).    /* Буфер loan-int */
               /* Операции 426/427 */
            ELSE IF CAN-DO("КредРезКом,КредРСпКом,КредРСзКом", vFindRole) THEN
               RUN FindLoanOper (vin-contract,        /* Назначение договора */
                                 vin-contcode,        /* Номер договора */
                                 in-op-date,          /* Дата расчета */
                                 22,                  /* Параметр начисления */
                                 356,                 /* Параметр списания */
                                 BUFFER loan-int).    /* Буфер loan-int */
               /* Операции 429/430 */
            ELSE IF CAN-DO("КредРезПени,КредРСпПени,КредРСзПени", vFindRole) THEN
               RUN FindLoanOper (vin-contract,        /* Назначение договора */
                                 vin-contcode,        /* Номер договора */
                                 in-op-date,          /* Дата расчета */
                                 22,                  /* Параметр начисления */
                                 357,                 /* Параметр списания */
                                 BUFFER loan-int).    /* Буфер loan-int */
               /* Операции 320/321 */
            ELSE IF CAN-DO("КредРезВб,КредРСпВб,КредРСзВб", vFindRole) THEN
               RUN FindLoanOper (vin-contract,        /* Назначение договора */
                                 vin-contcode,        /* Номер договора */
                                 in-op-date,          /* Дата расчета */
                                 22,                  /* Параметр начисления */
                                 88,                  /* Параметр списания */
                                 BUFFER loan-int).    /* Буфер loan-int */
               /* Операции 310 */
            ELSE IF CAN-DO("КредРезВУб,КредРСзВУб,КредРСпВУб", vFindRole) THEN
               RUN FindLoanOper (vin-contract,        /* Назначение договора */
                                 vin-contcode,        /* Номер договора */
                                 in-op-date,          /* Дата расчета */
                                 22,                  /* Параметр начисления */
                                 310,                 /* Параметр списания */
                                 BUFFER loan-int).    /* Буфер loan-int */

               /* Поиск проводки по операции. */
            IF AVAIL loan-int THEN
               FIND FIRST op-entry WHERE
                          op-entry.op       EQ loan-int.op
                  AND     op-entry.op-entry EQ loan-int.op-entry
               NO-LOCK NO-ERROR.
            IF AVAIL op-entry THEN
            DO:
                           /* Нашли операцию создания резерва id-d = 22, id-k = 21/46
                           ** проводка - КредРСозд - КредРез/КредРез1. */
               pick-value  =  IF loan-int.id-d  EQ 22
                                 THEN IF vFindRole BEGINS "КредРез"
                                    THEN op-entry.acct-cr /* запрошен КредРез/КредРез1 */
                                    ELSE op-entry.acct-db /* запрошен КредРСозд/КредРСпис */
                           /* нашли операцию списания резерва id-d = 21/46, id-k = 22
                           ** проводка - КредРез/КредРез1 - КредРСпис */
                                 ELSE IF vFindRole BEGINS "КредРез"
                                    THEN op-entry.acct-db
                                    ELSE op-entry.acct-cr.
                           /* Определяем, с нужной ли ролью нашли счет */
               FOR EACH loan-acct WHERE loan-acct.contract   EQ vin-contract
                                    AND loan-acct.cont-code  EQ vin-contcode
                                    AND loan-acct.acct       EQ pick-value
               NO-LOCK:
                  IF loan-acct.acct-type EQ vFindRole THEN LEAVE.
               END.
            END.
               /* Если от последней операции найден счет не с нашей ролью,
               ** то ищем счет привязанный с ролью до даты операции */
            IF NOT AVAIL loan-acct THEN
            DO:
               FIND LAST loan-acct WHERE loan-acct.contract   EQ vin-contract
                                     AND loan-acct.cont-code  EQ vin-contcode
                                     AND loan-acct.acct-type  EQ vFindRole
                                     AND loan-acct.since      LT in-op-date
               NO-LOCK NO-ERROR.
               IF AVAIL loan-acct THEN
                  pick-value = loan-acct.acct.
               ELSE DO:
                  /* если не нашли счет с нашей ролью до даты операции, то ищем в дату операции.
                  ** Искать сразу LE in-op-date НЕЛЬЗЯ, т.к. найдем только что привязанный счет. А нам нужен предыдущий. */
                  FIND LAST loan-acct WHERE loan-acct.contract   EQ vin-contract
                                        AND loan-acct.cont-code  EQ vin-contcode
                                        AND loan-acct.acct-type  EQ vFindRole
                                        AND loan-acct.since      EQ in-op-date
                 NO-LOCK NO-ERROR.
                 IF AVAIL loan-acct THEN
                    pick-value = loan-acct.acct.
               END.
            END.
         END.
                           /* Поиск счета на договоре. */
         ELSE DO:

            IF vRoleOnPOS
            THEN DO:
                           /* Поиск привязки для определения даты привязки к ПОС. */
               FIND LAST term-obl WHERE
                        term-obl.contract    EQ vin-contract
                  AND   term-obl.cont-code   EQ vin-contcode
                  AND   term-obl.idnt        EQ 128
                  AND   term-obl.end-date    LE in-op-date
               NO-LOCK NO-ERROR.
               IF AVAIL term-obl
                  THEN vBegDate  =  term-obl.end-date.
            END.
                           /* Перебираем счета. */
            CCL:
            FOR EACH loan-acct   WHERE
                     loan-acct.contract   EQ vin-contract
               AND   loan-acct.cont-code  EQ vin-contcode
               AND   loan-acct.acct-type  EQ vFindRole
               AND   loan-acct.since      GE vBegDate
               AND   loan-acct.since      LE in-op-date
            NO-LOCK
               BY loan-acct.since DESCENDING:
                           /* исключаем из перебора закрытые счета */
               {find-act.i
                  &acct = "loan-acct.acct"
                  &curr = "loan-acct.currency"
                  &AddWhere = "AND acct.close-date EQ ?"
                  }
               IF NOT AVAILABLE (acct) THEN NEXT CCL.
                           /* Сохраняем дату последнего loan-acct. */
               IF vLastLA  EQ ?
                  THEN vLastLA   = loan-acct.since.
                           /* Определяем принадлежность счета к ПОС. */
               vPosLAcct   =  GetXattrValueEx (
                                 "loan-acct",
                                 loan-acct.contract + "," + loan-acct.cont-code + "," + loan-acct.acct-type + "," + STRING (loan-acct.since),
                                 "ПОС",
                                 "").
                           /* Ссуда в ПОС. */
               IF       vRoleOnPOS
                  AND   vPosLAcct   NE ""
               THEN DO:
                           /* Если это последняя привязка, то счет НАШ. */
                  IF     vLastLA  EQ loan-acct.since
                     AND vPos     EQ ENTRY(2,vPosLAcct)  /* договор и счет привязаны к одному ПОСу  */
                     THEN  pick-value = loan-acct.acct.
                     ELSE  LEAVE CCL.
                  LEAVE BLCK.
               END.
                           /* Счет ссуды. */
               ELSE IF  NOT vRoleOnPOS
                  AND   vPosLAcct   EQ ""
               THEN DO:
                           /* Если последняя привязка, то счет НАШ. */
                  IF vLastLA  EQ loan-acct.since
                  THEN DO:
                     pick-value = loan-acct.acct.

                     /* Дополнительно проверяется наличие незакрытого счета. Если указанный счет
                     ** закрыт, то при наличии НП "ПрРольС" и его значении "КредРез, КредРез1"
                     ** запускается стандартная процедура открытия счета резерва. Кроме счетов
                     ** с ролью КредРезВб */
                     IF NOT (CAN-FIND(FIRST acct WHERE
                                            acct.acct       EQ loan-acct.acct
                                        AND acct.currency   EQ loan-acct.currency
                                        AND acct.close-date EQ ?))
                        AND CAN-DO(FGetSetting("ПрРольС","",?),vFindRole)
                        AND vFindRole NE "КредРезВб" THEN
                     DO:
                        IF vMesFl THEN
                           RUN Fill-SysMes IN h_tmess ("", "core10", "-1",
                                                       "%s=" + loan-acct.acct).
                        IF vCreateAcct THEN
                           RUN CreateBill (STRING (vin-contcode) + CHR(1) + "Нет" ,
                                           vin-contract,
                                           vDateCB,
                                           vFindRole).
                     END.
                     LEAVE BLCK.
                  END.
                  ELSE DO:
                           /* Если счет существует и открыт,
                           ** то копируем привязку с новой датой. */
                     FIND FIRST acct WHERE
                              acct.acct         EQ loan-acct.acct
                        AND   acct.currency     EQ loan-acct.currency
                        AND   acct.close-date   EQ ?
                     NO-LOCK NO-ERROR.
                     IF AVAIL acct THEN
                     BNLA:
                     DO
                     ON ERROR    UNDO BNLA, LEAVE BLCK
                     ON ENDKEY   UNDO BNLA, LEAVE BLCK:
                        CREATE NewLA.
                        BUFFER-COPY loan-acct EXCEPT since TO NewLA
                        ASSIGN NewLA.since   = in-op-date
                        NO-ERROR.
                        IF ERROR-STATUS:ERROR
                        THEN DO:
                           IF vMesFl THEN
                              RUN Fill-SysMes IN h_tmess (
                                 "", "-1", "",
                                 IF ERROR-STATUS:NUM-MESSAGES GT 0
                                    THEN ERROR-STATUS:GET-MESSAGE (1)
                                    ELSE RETURN-VALUE
                              ).
                           UNDO BNLA, LEAVE BLCK.
                        END.
                        pick-value = NewLA.acct.
                        IF mViewAcctLog THEN
                           RUN CrtLogTbl IN h_aclog (NewLA.contract,
                                                     NewLA.cont-code,
                                                     NewLA.acct,
                                                     NewLA.acct-type,
                                                     NO).
                        LEAVE BLCK.
                     END.
                  END.
               END.
            END.
                           /* Если ссуда не включена в ПОС,
                           ** и счет не найден, а также если это не роль КредРезВб
                           ** то запускаем создание счета. */
            IF    NOT vRoleOnPOS THEN
            DO:
               IF     vFindRole NE "КредРезВб"
                  OR (vFindRole EQ "КредРезВб"
                      AND NOT {assigned vPOS}) THEN
               DO:
                  IF vCreateAcct THEN
                     RUN CreateBill (STRING (vin-contcode) + CHR(1) + "Нет" ,
                                     vin-contract,
                                     vDateCB,
                                     vFindRole).
               END.
               ELSE
                  IF vMesFl THEN
                     RUN Fill-Sysmes IN h_tmess (
                                          "", "", "-1",
                                          "Для ссуды " + vin-contcode + " не задан счет с ролью " + vFindRole + ".").
            END.
            ELSE
            DO:
               /* поиск ссудного счета договора */
               FIND LAST loan-acct WHERE
                         loan-acct.contract   EQ vin-contract
                   AND   loan-acct.cont-code  EQ vin-contcode
                   AND   loan-acct.acct-type  EQ vin-contract
                   AND   loan-acct.since      LE in-op-date
               NO-LOCK NO-ERROR.
               IF AVAIL loan-acct THEN
               DO:
                  IF    vFindRole EQ "КредРезВб"
                    AND GetXAttrInit(loan.class-code,"main-loan-acct") EQ "Кредит" THEN
                  DO:
                     FIND LAST rloan-acct WHERE rloan-acct.contract  EQ loan-acct.contract
                                            AND rloan-acct.cont-code EQ loan-acct.cont-code
                                            AND rloan-acct.acct-type EQ "КредЛин"
                                            AND rloan-acct.since     LE in-op-date
                     NO-LOCK NO-ERROR.
                     IF AVAIL rloan-acct THEN
                        vAcctRB = rloan-acct.acct + "," + rloan-acct.currency.
                     ELSE
                     DO:
                        FIND LAST rloan-acct WHERE rloan-acct.contract  EQ loan-acct.contract
                                               AND rloan-acct.cont-code EQ loan-acct.cont-code
                                               AND rloan-acct.acct-type EQ "КредН"
                                               AND rloan-acct.since     LE in-op-date
                        NO-LOCK NO-ERROR.
                        IF AVAIL rloan-acct THEN
                           vAcctRB = rloan-acct.acct + "," + rloan-acct.currency.
                     END.

                     IF vAcctRB EQ "" THEN
                     DO:
                        pick-value = "".
                        LEAVE BLCK.
                     END.
                  END.
                  ELSE
                     vAcctRB = loan-acct.acct + "," + loan-acct.currency.

                              /* Ищем счет с ролью на портфеле */
                  RUN getAcctResBag (ENTRY(1,vAcctRB),
                                     ENTRY(2,vAcctRB),
                                     vPos,
                                     vFindRole,
                                     in-op-date,
                                     NO,
                                     OUTPUT pick-value,
                                     OUTPUT vCurrency).
               END.
               /* если счет найден, создать привязку счета к ссуде */
               IF {assigned pick-value} THEN
               DO:
                  BNLA:
                  DO
                  ON ERROR    UNDO BNLA, LEAVE BLCK
                  ON ENDKEY   UNDO BNLA, LEAVE BLCK:
                     CREATE NewLA.
                     ASSIGN
                        NewLA.contract   =  vin-contract
                        NewLA.cont-code  =  vin-contcode
                        NewLA.acct-type  =  vFindRole
                        NewLA.since      =  in-op-date
                        NewLA.acct       =  pick-value
                        NewLA.currency   =  vCurrency
                     NO-ERROR.
                     IF ERROR-STATUS:ERROR
                     THEN DO:
                        IF vMesFl THEN
                           RUN Fill-SysMes IN h_tmess (
                              "", "", "-1",
                              IF ERROR-STATUS:NUM-MESSAGES GT 0
                                 THEN ERROR-STATUS:GET-MESSAGE (1)
                                 ELSE RETURN-VALUE
                           ).
                        pick-value = "".
                        UNDO BNLA, LEAVE BNLA.
                     END.
                     IF mViewAcctLog THEN
                        RUN CrtLogTbl IN h_aclog (NewLA.contract,
                                                  NewLA.cont-code,
                                                  NewLA.acct,
                                                  NewLA.acct-type,
                                                  NO).
                  END.
                  IF pick-value NE "" THEN
                     UpdateSigns ("loan-acct",
                                  vin-contract + "," + vin-contcode + "," + vFindRole + "," + STRING (in-op-date),
                                  "ПОС",
                                  "ПОС," + vPos,
                                  YES).
                  LEAVE BLCK.
               END.
               ELSE
                  IF vMesFl THEN
                     RUN Fill-Sysmes IN h_tmess (
                                          "", "", "-1",
                                          "Для ссуды " + vin-contcode + " не задан счет с ролью " + vFindRole +
                                          ".~n Ссуда входит в ПОС " + vPos + ".").
            END.
         END.
         RUN SaveLPResult (vin-contract,
                           vin-contcode,
                           "РольСРез",
                           param-str,
                           pick-value).
      END.
   END.
   RETURN.
END PROCEDURE.    /* РольСРез */





/*--------------------------------------------------------------------------
    * Что делает: Определяет где начислять проценты - на балансе или внебалансе,
                  в зависимости от того была ли смена группы риска в текущем дне (302П)
                  Возвращаемые значения:
                      1 - начислять на балансе
                      2 - начислять на внебалансе
    * Синтаксис : НачБал()
    * Автор     : boes 12/11/07
    * Пример    : НачБал()
--------------------------------------------------------------------------*/


PROCEDURE НачБал:

   DEFINE INPUT  PARAMETER rid         AS RECID NO-UNDO.
   DEFINE INPUT  PARAMETER in-op-date  AS DATE  NO-UNDO.
   DEFINE INPUT  PARAMETER param-count AS INT64   NO-UNDO.
   DEFINE INPUT  PARAMETER param-str   AS CHAR  NO-UNDO.

   DEFINE VARIABLE vLoanHandle AS HANDLE NO-UNDO.


   DEFINE VARIABLE   vSetGrInt      AS INT64   NO-UNDO.
   DEFINE VARIABLE   vLoanGrInt     AS INT64   NO-UNDO.
   DEFINE VARIABLE   vLoanGrStr     AS CHAR  NO-UNDO.
   DEFINE VARIABLE   vRisk AS DECIMAL.
   pick-value = ?.

   IF param-count NE 0 THEN
   DO:
      RUN Fill-Sysmes IN h_tmess ("", "", "-1", "ОШИБОЧНОЕ количество параметров передано в процедуру " +
                                                STRING(PROGRAM-NAME(1)) + ": \n(должно быть 0)!").
      RETURN.
   END.
   ELSE
   DO:
        RUN LOAN_VALID_HANDLE (INPUT-OUTPUT vLoanHandle).

        IF VALID-HANDLE (vLoanHandle)
            THEN
               pick-value = Get_NachBal(ENTRY(1,vLoanHandle:PRIVATE-DATA),
                                     ENTRY(2,vLoanHandle:PRIVATE-DATA),
                                     in-op-date)
            .


   END. /*Else*/
END. /*PROCEDURE НачБал*/





/*--------------------------------------------------------------------------
    * Что делает: Определяет факт измения в текущем дне группы риска(302П)
                  Возвращает 0 - нет смены в текущем дне
                             1 - смена с (3),4,5 на 1,2,(3), т.е. необходим перенос внебаланс-баланс
                             2 - смена с 1,2,(3) на (3),4,5  т.е. необходим перенос баланс-внебаланс
    * Синтаксис : СменаКК()
    * Автор     : boes 12/11/07
    * Пример    : СменаКК()
--------------------------------------------------------------------------*/

PROCEDURE СменаКК:

   DEFINE INPUT  PARAMETER rid         AS RECID NO-UNDO.
   DEFINE INPUT  PARAMETER in-op-date  AS DATE  NO-UNDO.
   DEFINE INPUT  PARAMETER param-count AS INT64   NO-UNDO.
   DEFINE INPUT  PARAMETER param-str   AS CHAR  NO-UNDO.

   DEFINE VARIABLE vLoanHandle AS HANDLE NO-UNDO.


   DEFINE VARIABLE   vSetGrInt      AS INT64   NO-UNDO.
   DEFINE VARIABLE   vTypeD         AS CHAR  NO-UNDO.
   DEFINE VARIABLE   vLoanGrInt     AS INT64   NO-UNDO.
   DEFINE VARIABLE   vLoanGrStr     AS CHAR  NO-UNDO.
   DEFINE VARIABLE   vDate          AS DATE  NO-UNDO.
   DEFINE VARIABLE   vRisk          AS DECIMAL.
   mb:
   DO ON ERROR UNDO, LEAVE:
      pick-value = ?.
      IF param-count > 1
      THEN
         RUN Fill-Sysmes IN h_tmess ("", "", "-1", "ОШИБОЧНОЕ количество параметров передано в процедуру " +
                                                STRING(PROGRAM-NAME(1)) + ": \n(должно быть 0)!").
      ELSE DO:
         ASSIGN
            vTypeD = GetParam(1,param-str) WHEN param-count EQ 1
         .
         FIND FIRST wop WHERE RECID(wop) = Rid NO-LOCK NO-ERROR.
         IF NOT AVAIL wop AND vTypeD EQ "ПД" THEN LEAVE mb.
         IF vTypeD EQ "ПД"
            THEN vDate = wop.con-date.
            ELSE vDate = in-op-date.
         RUN LOAN_VALID_HANDLE (INPUT-OUTPUT vLoanHandle).

         IF VALID-HANDLE (vLoanHandle) THEN
            pick-value = GetChanges_GrRiska(ENTRY(1,vLoanHandle:PRIVATE-DATA),
                                            ENTRY(2,vLoanHandle:PRIVATE-DATA),
                                            vDate)
         .
      END. /*Else*/
   END. /*mb*/

END. /*PROCEDURE СменаКК*/

/*--------------------------------------------------------------------------
    * Что делает: Возвращает величину формируемого резерва для дисконта.
    * Синтаксис : ФормРезПроцСроч( <признак даты> )
                  <признак даты>:  "ОД"  - дата опер. дня
                                   "ПД"  - плановая дата
    * Автор     : jadv 21.01.2008
    * Пример    : ФормРезДискСроч("ОД")
  --------------------------------------------------------------------------*/
PROCEDURE ФормРезДискСроч:
   DEF INPUT  PARAM rid         AS RECID NO-UNDO.
   DEF INPUT  PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT  PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT  PARAM param-str   AS CHAR  NO-UNDO.

   RUN Form_Rsrv('ФормРезДискСроч', rid, in-op-date, param-count, param-str).
END PROCEDURE.

/*--------------------------------------------------------------------------
    * Что делает: Возвращает величину формируемого резерва для просроченного дисконта.
    * Синтаксис : ФормРезПроцПр( <признак даты> )
                  <признак даты>:  "ОД"  - дата опер. дня
                                   "ПД"  - плановая дата
    * Автор     : jadv 21.01.2008
    * Пример    : ФормРезДискПр("ОД")
  --------------------------------------------------------------------------*/
PROCEDURE ФормРезДискПр:
   DEF INPUT  PARAM rid         AS RECID NO-UNDO.
   DEF INPUT  PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT  PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT  PARAM param-str   AS CHAR  NO-UNDO.

   RUN Form_Rsrv('ФормРезДискПр',rid,in-op-date, param-count, param-str).
END PROCEDURE.


/* ==================================================================-=-=-=-=
    * Что делает: Возвращает величину резерва по условным обязательствам.
    * Синтаксис : ФормРезВб(<признак даты>,<список ролей счета>,<признак deriv>)
                  <признак даты>       : "ОД/ПД" - дата опер.дня/плановая дата
                  <список ролей счета> : Список ролей (через "|") для счета условного обязательства
                  <признак deriv>      : Заполнять/не заполнять ДР deriv на счете с указанной ролью
                                         "deriv" - заполнять, пусто - не заполнять
    * Автор     : jadv 22/12/09 (0096811)
    * Пример    : ФормРезВб("ОД","","КредРезВб")
  ==================================================================-=-=-=-= */
PROCEDURE ФормРезВб:
   DEF INPUT  PARAM rid         AS RECID NO-UNDO.
   DEF INPUT  PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT  PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT  PARAM param-str   AS CHAR  NO-UNDO.

   RUN Form_Rsrv('ФормРезВб',rid,in-op-date, param-count, param-str).

END PROCEDURE.    /* ФормРезВб */


/*--------------------------------------------------------------------------
    * Что делает: Возвращает признак необходимости фиксации платежа по Грейсам.
                  Возвращает: 0 - минимальные платежи НЕ должны гаситься
                              1 - минимальные платежи должны гаситься
    * Синтаксис : ПогГрейс() ПогГрейс("ПР")
    * Автор     : Fepa 07.05.2008
    * Пример    : ПогГрейс()
  --------------------------------------------------------------------------*/
PROCEDURE ПогГрейс:
   DEFINE INPUT  PARAMETER rid         AS RECID NO-UNDO.
   DEFINE INPUT  PARAMETER in-op-date  AS DATE  NO-UNDO.
   DEFINE INPUT  PARAMETER param-count AS INT64   NO-UNDO.
   DEFINE INPUT  PARAMETER param-str   AS CHAR  NO-UNDO.

   DEFINE VARIABLE vLoanHandle AS HANDLE NO-UNDO.
   DEFINE VARIABLE vGraceClass AS CHAR   NO-UNDO.
   DEFINE VARIABLE vGraceValue AS CHAR   NO-UNDO.
   DEFINE VARIABLE vDirect     AS CHAR   NO-UNDO.
   DEFINE VARIABLE vDirectDay  AS DATE   NO-UNDO.
   DEFINE VARIABLE vGrPog      AS INT64  INIT 3 NO-UNDO.
   DEFINE VARIABLE vMyClass    AS CHAR   NO-UNDO.

   DEFINE BUFFER sloan      FOR loan.      /* Договор соглашение */
   DEFINE BUFFER tloan      FOR loan.      /* Грейс течение */
   DEFINE BUFFER gloan      FOR loan.      /* Грейс течение */
   DEFINE BUFFER tloan-cond FOR loan-cond. /* Грейс условие */
   DEFINE BUFFER term-obl   FOR term-obl.
   DEFINE BUFFER sloan-cond FOR loan-cond.
   mb:
   DO ON ERROR UNDO, LEAVE:
      pick-value = "0".
      IF     param-count NE 0
         AND param-count NE 1 THEN
      DO:
         RUN Fill-Sysmes IN h_tmess ("", "", "-1", "ОШИБОЧНОЕ количество параметров передано в функцию " +
                                                   STRING(PROGRAM-NAME(1)) + ": \n(должно быть 0 или 1)!").
         pick-value = ?.
         LEAVE mb.
      END.
      IF     param-count EQ 1
         AND getparam(1,param-str) EQ "Пр" THEN
          vGrPog = 1.

      /* Определение правильного применения функции,
      ** формат private-data */
      RUN LOAN_VALID_HANDLE (INPUT-OUTPUT vLoanHandle).

      /* Договор не определен */
      IF NOT VALID-HANDLE (vLoanHandle) THEN
      DO:
         pick-value = ?.
         LEAVE mb.
      END.
      /* Проверим сначала, что это последний рабочий день месяца */
      /*
      IF in-op-date NE PrevWorkDay(DATE(MONTH(in-op-date) + 1,1,YEAR(in-op-date))) THEN
         LEAVE mb.
       */

      /* Ищем сам договор */
       FIND FIRST tloan WHERE tloan.contract  EQ ENTRY(1,vLoanHandle:PRIVATE-DATA)
                          AND tloan.cont-code EQ ENTRY(2,vLoanHandle:PRIVATE-DATA)
            NO-LOCK NO-ERROR.
       IF AVAIL tloan THEN
          vMyClass = tloan.class-code.
       ELSE
           LEAVE mb.
      /* Ищем договор соглашение */
      FIND FIRST sloan WHERE sloan.contract  EQ ENTRY(1,vLoanHandle:PRIVATE-DATA)
                         AND sloan.cont-code EQ ENTRY(1,ENTRY(2,vLoanHandle:PRIVATE-DATA)," ")
                         AND sloan.cont-type EQ "Течение"
      NO-LOCK NO-ERROR.


     /* Проверим, не грейс транш .
        Если дата окончания платежного периожда графика  совпадает с оперднем то нужно гасить */

      IF vMyClass EQ GetXAttrInit(sloan.class-code,"КлассНеГрейс") THEN
      DO:
         /*Если КС или П*/
         FIND FIRST sloan-cond where
                    sloan-cond.contract  EQ tloan.contract AND
                    sloan-cond.cont-code EQ tloan.cont-code NO-LOCK NO-ERROR .

         IF sloan-cond.cred-period = "Кс"  OR
            sloan-cond.cred-period = "П"   THEN DO:
             pick-value = "1".
             LEAVE mb.
         END.
         ELSE DO:
         FOR EACH term-obl WHERE term-obl.contract  EQ tloan.contract
                             AND term-obl.cont-code EQ tloan.cont-code
                             AND term-obl.end-date  LE in-op-date
                             AND term-obl.idnt      EQ vGrPog NO-LOCK:
             IF term-obl.dsc-beg-date EQ in-op-date THEN
             DO:
                pick-value = "1".
                LEAVE mb.
             END.
          END.
          END.

          /*March. вот здесь нужно выходить для негрейс течения, а то переходим на грейс течение .....  */
          pick-value = "0".
            LEAVE mb.
         END.

      /* Берем Грейс Класс */
      vGraceClass = GetXAttrInit(sloan.class-code,"КлассГрейс").


      /* Ищем не закрытый транш с таким классом */
      IF tloan.class-code EQ vGraceClass THEN
         FIND FIRST gloan WHERE gloan.contract  EQ    sloan.contract
                           AND gloan.cont-code  BEGINS sloan.cont-code + " "
                           AND int(entry(2,gloan.cont-code," ")) GE int(entry(2,tloan.cont-code," "))
                           AND gloan.class-code EQ     vGraceClass
                           AND gloan.close-date EQ     ?
      NO-LOCK NO-ERROR.
      ELSE
         FIND FIRST gloan WHERE gloan.contract  EQ    sloan.contract
                           AND gloan.cont-code  BEGINS sloan.cont-code + " "
                           AND gloan.class-code EQ     vGraceClass
                           AND gloan.close-date EQ     ?
      NO-LOCK NO-ERROR.

      /* Нет грейса */
      IF NOT AVAIL gloan THEN
      DO:
         pick-value = "1".
         LEAVE mb.
      END.

      /* Находим действующее условие по такому траншу */
      FIND LAST tloan-cond WHERE tloan-cond.contract  EQ gloan.contract
                             AND tloan-cond.cont-code EQ gloan.cont-code
                             AND tloan-cond.since     LE in-op-date
      NO-LOCK NO-ERROR.

      /* Нет грейса */
      IF NOT AVAIL tloan-cond THEN
      DO:
         pick-value = "1".
         LEAVE mb.
      END.

      /* Определяем какое это условие - грейс-период или негрейс-период */
      vGraceValue = GetXAttrValue("loan-cond",
                                  tloan-cond.contract  + "," +
                                  tloan-cond.cont-code + "," +
                                  STRING(tloan-cond.since),
                                  "Грейс").
      /* Нет грейса ИЛИ есть грейс, но он закончился в предыдущем месяце
      ** т.к. мы ищем действующее на дату условие, то достаточно проверить
      ** что это не грейс - тогда возвращаем 1, если это грейс, то автоматом 0 */
      IF vGraceValue NE "Да" THEN
      DO:
         /* March. А вот тут нужно как по негрейс смотреть график.... */
         IF tloan-cond.cred-period = "Кс"  OR
            tloan-cond.cred-period = "П"   THEN DO:
         pick-value = "1".
         LEAVE mb.
      END.
      ELSE DO:
            FOR EACH term-obl WHERE term-obl.contract  EQ tloan.contract
                                AND term-obl.cont-code EQ tloan.cont-code
                             AND term-obl.end-date  LE in-op-date
                             AND term-obl.idnt      EQ vGrPog NO-LOCK:
               IF term-obl.dsc-beg-date EQ in-op-date THEN DO:
         pick-value = "1".
         LEAVE mb.
      END.
            END.
          END.

         /*March. вот здесь нужно выходить  */
         pick-value = "0".
         LEAVE mb.
      END.
      ELSE DO:

         /* March. Здесь нужно проверить, не последний ли это день грейс-условия? */
         /* Находим условие, действующее на СЛЕДУЮЩИЙ ДЕНЬ по такому траншу */
         FIND LAST tloan-cond WHERE tloan-cond.contract  EQ gloan.contract
                                AND tloan-cond.cont-code EQ gloan.cont-code
                                AND tloan-cond.since     EQ DATE(in-op-date + 1)
            NO-LOCK NO-ERROR.

         IF AVAIL tloan-cond THEN DO:
            /* Определяем какое это условие - грейс-период или негрейс-период */
            vGraceValue = GetXAttrValue("loan-cond",
                                        tloan-cond.contract  + "," +
                                        tloan-cond.cont-code + "," +
                                        STRING(tloan-cond.since),
                                        "Грейс").
            IF vGraceValue NE "Да" THEN DO:
               /* Завтра будет неГрейс, нужно погашать */
               pick-value = "1".
               LEAVE mb.
            END.
         END.
      END.
   END. /* mb: */

END PROCEDURE.

/*--------------------------------------------------------------------------
    * Что делает: Возвращает значение реквизита на обрабатываемомо договоре.
    * Синтаксис : ДогДр(<код реквизита>)
    * Автор     : feok 21.05.08
    * Пример    : ДогДр("ГрРабПодр")
  --------------------------------------------------------------------------*/
PROCEDURE ДогДр:
   DEFINE INPUT  PARAMETER rid         AS RECID NO-UNDO.
   DEFINE INPUT  PARAMETER in-op-date  AS DATE  NO-UNDO.
   DEFINE INPUT  PARAMETER param-count AS INT64   NO-UNDO.
   DEFINE INPUT  PARAMETER param-str   AS CHAR  NO-UNDO.

   DEFINE VARIABLE vLoanHandle AS HANDLE NO-UNDO.

   BLCK:
   DO
   ON ERROR UNDO BLCK, LEAVE BLCK:

      pick-value = "0".
      IF param-count NE 1 THEN
      DO:
         RUN Fill-Sysmes IN h_tmess ("", "", "-1", "ОШИБОЧНОЕ количество параметров передано в функцию " +
                                                   STRING(PROGRAM-NAME(1)) + ": \n(должно быть 1)!").
         pick-value = ?.
         LEAVE blck.
      END.

      /* Определение правильного применения функции,
      ** формат private-data */
      RUN LOAN_VALID_HANDLE(INPUT-OUTPUT vLoanHandle).

      /* Номер договора не определен */
      IF NOT VALID-HANDLE(vLoanHandle) THEN DO :
      pick-value = ?.
      RETURN.
      END.

      FIND FIRST loan WHERE
       loan.contract  EQ ENTRY(1,vLoanHandle:PRIVATE-DATA) AND
       loan.cont-code EQ ENTRY(2,vLoanHandle:PRIVATE-DATA)
      NO-LOCK NO-ERROR.

      IF NOT AVAIL loan THEN
      DO:
         pick-value = ?.
         LEAVE blck.
      END.

      RUN GetXattr (loan.Class-Code, GetParam(1,param-str), BUFFER xattr).

      IF AVAIL xattr THEN
      DO:
         IF xattr.progress-field THEN
            pick-value = GetBufferValue("loan",
                                        "WHERE loan.contract EQ '" + loan.contract + "'
                                         AND loan.cont-code EQ '" + loan.cont-code + "'",
                                         STRING(GetParam(1,param-str))) NO-ERROR.
         ELSE
         DO:
            pick-value = GetXattrValue ("loan",
                                        loan.contract + ',' + loan.cont-code,
                                        GetParam(1,param-str)
                                        ).
         END.
      END.
   END.
END PROCEDURE.

/*--------------------------------------------------------------------------
    * Что делает: Возвращает значение реквизита на вышестоящем (охватывающем)
                  договоре (соглашении) - может применяться при обработке течений,
                  если требуется получить реквизит с соглашения.
    * Синтаксис : ДогДрСогл(<код реквизита>)
    * Автор     : feok 21.05.08
    * Пример    : ДогДрСогл("ГрРабПодр")
  --------------------------------------------------------------------------*/
PROCEDURE ДогДрСогл:
   DEFINE INPUT  PARAMETER rid         AS RECID NO-UNDO.
   DEFINE INPUT  PARAMETER in-op-date  AS DATE  NO-UNDO.
   DEFINE INPUT  PARAMETER param-count AS INT64   NO-UNDO.
   DEFINE INPUT  PARAMETER param-str   AS CHAR  NO-UNDO.

   DEFINE VARIABLE vLoanHandle AS HANDLE NO-UNDO.

   BLCK:
   DO
   ON ERROR UNDO BLCK, LEAVE BLCK:

      pick-value = "0".
      IF param-count NE 1 THEN
      DO:
         RUN Fill-Sysmes IN h_tmess ("", "", "-1", "ОШИБОЧНОЕ количество параметров передано в функцию " +
                                                      STRING(PROGRAM-NAME(1)) + ": \n(должно быть 1)!").
         pick-value = ?.
         LEAVE blck.
      END.

      /* Определение правильного применения функции,
      ** формат private-data */
      RUN LOAN_VALID_HANDLE(INPUT-OUTPUT vLoanHandle).

      /* Номер договора не определен */
      IF NOT VALID-HANDLE(vLoanHandle) THEN DO :
      pick-value = ?.
      RETURN.
      END.

      FIND FIRST loan WHERE
       loan.contract  EQ ENTRY(1,vLoanHandle:PRIVATE-DATA) AND
       loan.cont-code EQ ENTRY(1,ENTRY(2,vLoanHandle:PRIVATE-DATA)," ")
      NO-LOCK NO-ERROR.

      IF NOT AVAIL loan THEN
      DO:
         pick-value = ?.
         LEAVE blck.
      END.

      RUN GetXattr (loan.Class-Code, GetParam(1,param-str), BUFFER xattr).

      IF AVAIL xattr THEN
      DO:
         IF xattr.progress-field THEN
            pick-value = GetBufferValue("loan",
                                        "WHERE loan.contract EQ '" + loan.contract + "'
                                         AND loan.cont-code EQ '" + loan.cont-code + "'",
                                         STRING(GetParam(1,param-str))) NO-ERROR.
         ELSE
         DO:
            pick-value = GetXattrValue ("loan",
                                        loan.contract + ',' + loan.cont-code,
                                        GetParam(1,param-str)
                                        ).
         END.
      END.
   END.
END PROCEDURE.

/*--------------------------------------------------------------------------
    * Что делает: Возвращает сумму к выдачи для грейс или негрейс транша,
                  в зависимости от того, какой транш.
    * Синтаксис : СуммаГрейс()
    * Автор     : Gorm 10.05.2008
    * Пример    : СуммаГрейс()
  --------------------------------------------------------------------------*/
PROCEDURE СуммаГрейс:
   DEFINE INPUT  PARAMETER rid         AS RECID NO-UNDO.
   DEFINE INPUT  PARAMETER in-op-date  AS DATE  NO-UNDO.
   DEFINE INPUT  PARAMETER param-count AS INT64   NO-UNDO.
   DEFINE INPUT  PARAMETER param-str   AS CHAR  NO-UNDO.

   pick-value = chpar1.

END PROCEDURE.

/*--------------------------------------------------------------------------
    * Что делает: Вычисляет комиссию
    * Синтаксис : КомДогЗн(<Код Комиссии>,<база начисления>)
     <база начисления>:  сумма в валюте договораю
    * Автор     : feok
    * Пример    : КомДогЗн('%Выд',10000)
  --------------------------------------------------------------------------*/
PROCEDURE КомДогЗн:
   DEFINE INPUT  PARAMETER rid         AS RECID NO-UNDO.
   DEFINE INPUT  PARAMETER in-op-date  AS DATE  NO-UNDO.
   DEFINE INPUT  PARAMETER param-count AS INT64   NO-UNDO.
   DEFINE INPUT  PARAMETER param-str   AS CHAR  NO-UNDO.

   DEFINE VARIABLE vLoanHandle AS HANDLE NO-UNDO.

   DEFINE VARIABLE in-comm AS CHARACTER NO-UNDO.
   DEFINE VARIABLE in-base AS DECIMAL   NO-UNDO.

   mb:
   DO ON ERROR UNDO, LEAVE:

      pick-value = "0".
      IF param-count NE 2 THEN
      DO:
         RUN Fill-Sysmes IN h_tmess ("", "", "-1", "ОШИБОЧНОЕ количество параметров передано в функцию " +
                                                      STRING(PROGRAM-NAME(1)) + ": \n(должно быть 2)!").
         pick-value = ?.
         LEAVE mb.
      END.

      ASSIGN
         in-comm = getparam(1, param-str)
         in-base = DEC(getparam(2, param-str))
      .
      /* Определение правильного применения функции,
      ** формат private-data */
      RUN LOAN_VALID_HANDLE(INPUT-OUTPUT vLoanHandle).

      /* Номер договора не определен */
      IF NOT VALID-HANDLE(vLoanHandle) THEN DO :
         pick-value = ?.
         LEAVE mb.
      END.
      /*договор*/
      FIND FIRST loan WHERE
                 loan.contract  EQ ENTRY(1,vLoanHandle:PRIVATE-DATA)
             AND loan.cont-code EQ ENTRY(2,vLoanHandle:PRIVATE-DATA)
      NO-LOCK NO-ERROR.

      IF NOT AVAIL loan THEN
         LEAVE mb.

      /*условие*/
      FIND LAST loan-cond WHERE loan-cond.contract  EQ loan.contract
                            AND loan-cond.cont-code EQ loan.cont-code
                            AND loan-cond.since     LE in-op-date
      NO-LOCK NO-ERROR.

      IF NOT AVAIL loan-cond THEN
         LEAVE mb.

      FIND LAST comm-rate WHERE
                comm-rate.commi     EQ in-comm
            AND comm-rate.acct      EQ "0"
            AND comm-rate.currency  EQ loan.currency
            AND comm-rate.kau       EQ loan-cond.contract + "," + loan-cond.cont-code
            AND comm-rate.min-value EQ 0
            AND comm-rate.period    EQ 0
            AND comm-rate.since     LE in-op-date
      NO-LOCK NO-ERROR.

      IF AVAIL comm-rate THEN
         IF comm-rate.rate-fixed EQ YES THEN
            pick-value = string(comm-rate.rate-comm).                 /* = */
         ELSE
            pick-value = string(comm-rate.rate-comm * in-base / 100). /* % */
   END.
END PROCEDURE.

/*--------------------------------------------------------------------------
    * Что делает: Функция определяет, надо ли применять функцию расчета
                  просроченных процентов по алгоритму ОдинБанка.
                  Возвращаемое значение:
                  ╙ 0, если алгоритм ОдинБанка не применяется;
                  - 1, если применяется.
    * Синтаксис : ПрАлгОдин()
    * Автор     : Jadv 15.01.2008
    * Пример    : ПрАлгОдин()
  --------------------------------------------------------------------------*/
PROCEDURE ПрАлгОдин:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEF VAR vLoanHandle AS HANDLE NO-UNDO.

   pick-value = "0".

   RUN LOAN_VALID_HANDLE (INPUT-OUTPUT vLoanHandle).
   IF VALID-HANDLE(vLoanHandle) THEN
   DO:
      IF FUseAlgOdin(ENTRY(1, vLoanHandle:PRIVATE-DATA), /* Назначение договора */
                     ENTRY(2, vLoanHandle:PRIVATE-DATA), /* Номер договора */
                     in-op-date)                         /* На дату */
         THEN
         pick-value = "1".
   END.
END PROCEDURE.

/*--------------------------------------------------------------------------
    * Что делает: Возвращает сумму просроченных процентов по алгоритму ОдинБанка.
                  Парамеры ╞ код параметра, могут передаваться 4,33,29.
                  Возвращаемое значение ╞ сумма процентов в валюте договора,
                  которую надо вынести на просрочку в плановую дату
                  по указанном параметру.
    * Синтаксис : СумПросПр(<код параметра>[,<признак даты>])
                  <код параметра>: номер параметра договора
                  <признак даты>:
                  "ОД"  - дата опер. дня
                  "ПД"  - плановая дата
    * Автор     : Jadv 15.01.2008
    * Пример    : СумПросПр(33,ОД)
  --------------------------------------------------------------------------*/
PROCEDURE СумПросПр:
   DEFINE INPUT  PARAMETER rid         AS RECID NO-UNDO.
   DEFINE INPUT  PARAMETER in-op-date  AS DATE  NO-UNDO.
   DEFINE INPUT  PARAMETER param-count AS INT64   NO-UNDO.
   DEFINE INPUT  PARAMETER param-str   AS CHAR  NO-UNDO.

   DEF VAR vLoanHandle AS HANDLE NO-UNDO.
   DEF VAR vContract   AS CHAR   NO-UNDO.
   DEF VAR vContCode   AS CHAR   NO-UNDO.
   DEF VAR vParam      AS CHAR   NO-UNDO.
   DEF VAR vSum        AS DEC    NO-UNDO.
   DEF VAR vDate       AS DATE   NO-UNDO.

   IF    param-count LT 1
      OR param-count GT 2 THEN
   DO:
      RUN Fill-Sysmes IN h_tmess ("", "", "-1", "ОШИБОЧНОЕ количество параметров передано в функцию " +
                                                 STRING(PROGRAM-NAME(1)) + ": \n(должено быть 1 или 2)!").
      RETURN.
   END.

      /* Ищем wop для определения плановой даты */
   FIND FIRST wop WHERE
        RECID(wop) EQ rid
   NO-LOCK NO-ERROR.
   IF NOT AVAIL wop THEN
   DO:
      pick-value = ?.
      RETURN .
   END.

   ASSIGN
      vParam = GetParam(1, param-str)               /* Код параметра */
      vDate  = IF    GetParam(2, param-str) = "ОД"
                  OR GetParam(2, param-str) = ?
                  THEN in-op-date
                  ELSE wop.con-date
   .

      /* Определение правильного применения функции, формат private-data */
   RUN LOAN_VALID_HANDLE(INPUT-OUTPUT vLoanHandle).
      /* Номер договора не определен */
   IF NOT VALID-HANDLE(vLoanHandle) THEN
   DO:
      pick-value = ?.
      RETURN.
   END.

   ASSIGN
      vContract = ENTRY(1, vLoanHandle:PRIVATE-DATA)
      vContCode = ENTRY(2, vLoanHandle:PRIVATE-DATA)
   .

      /* Поиск договора */
   RUN RE_B_LOAN (vContract, vContCode, BUFFER loan).
   IF NOT AVAIL loan THEN
   DO:
     pick-value = ?.
     RETURN.
   END.

   RUN PSumDelayProc (vContract,       /* Назначение договора */
                      vContCode,       /* Номер договора */
                      vDate,           /* На дату */
                      INT64(vParam),     /* Параметр для определения непогашенного остатка */
                      OUTPUT vSum).    /* Сумма %% на просрочку */
   pick-value = STRING(vSum).

END PROCEDURE.

/*--------------------------------------------------------------------------
    * Что делает: Вычисляет сумму комиссии на дату по договору
    * Синтаксис : СумНачКом(<код комиссии>)
    * Автор     : Chumv 20.10.2009
    * Пример    : СумНачКом("ОфИпот")
  --------------------------------------------------------------------------*/
PROCEDURE СумНачКом:
   DEFINE INPUT  PARAMETER rid         AS RECID NO-UNDO.
   DEFINE INPUT  PARAMETER in-op-date  AS DATE  NO-UNDO.
   DEFINE INPUT  PARAMETER param-count AS INT64   NO-UNDO.
   DEFINE INPUT  PARAMETER param-str   AS CHAR  NO-UNDO.

   DEF VAR vLoanHandle AS HANDLE NO-UNDO.
   DEF VAR vParam      AS CHAR   NO-UNDO.
   DEF VAR vDate       AS DATE   NO-UNDO.
   DEF VAR vSum        AS DEC    NO-UNDO.

   MAIN:
   DO:
      IF param-count LT 1 THEN
      DO:
         RUN Fill-Sysmes IN h_tmess ("", "", "-1", "ОШИБОЧНОЕ количество параметров передано в функцию " +
                                                    STRING(PROGRAM-NAME(1)) + ": \n(должен быть 1 или 2)!").
         pick-value = ?.
         LEAVE MAIN.
      END.
      RUN LOAN_VALID_HANDLE (INPUT-OUTPUT vLoanHandle).
      IF VALID-HANDLE(vLoanHandle) THEN
      DO:
         IF param-count EQ 2 THEN
         DO:
            /*ищем wop для определения плановой даты*/
            FIND FIRST wop WHERE RECID(wop) EQ rid NO-LOCK NO-ERROR.
            IF NOT AVAIL wop AND getparam(2,param-str) EQ "ПД" THEN
               LEAVE MAIN.
            vDate = IF getparam(2,param-str) EQ "ПД" THEN wop.con-date
                                                     ELSE in-op-date.
         END.
         ELSE
            vDate = in-op-date.
         vParam = GetParam(1, param-str).
         RUN CalcCommLoan (ENTRY(1, vLoanHandle:PRIVATE-DATA),
                           ENTRY(2, vLoanHandle:PRIVATE-DATA),
                           vParam,
                           vDate,
                           vDate,
                           OUTPUT vSum).
         pick-value = STRING(vSum).
      END.
   END.
END PROCEDURE.

   /* =======================================---=-=-=-=-=-=-=-=-
   ** Что делает: Расчет суммы корректировки суммы плавающего обеспечения
   ** Синтаксис : ПлавОбСумм()
   ** Автор     : Jadv 09.09.2009
   ** Пример    : ПлавОбСумм()
   */
PROCEDURE ПлавОбСумм:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEF VAR vLoanHandle AS HANDLE NO-UNDO.  /* Хэндл договора */
   DEF VAR vSummObCalc AS DEC    NO-UNDO.  /* Сумма обеспечения */
   DEF VAR vSummCorr   AS DEC    NO-UNDO.  /* Сумма корректировки */

   pick-value = "0".

   RUN LOAN_VALID_HANDLE (INPUT-OUTPUT vLoanHandle).

   IF VALID-HANDLE(vLoanHandle) THEN
   DO:
      RUN CalcSummObFloat IN h_lngar (ENTRY(1, vLoanHandle:PRIVATE-DATA),  /* Назначение договора */
                                      ENTRY(2, vLoanHandle:PRIVATE-DATA),  /* Номер договора */
                                      in-op-date,                          /* Дата */
                                      OUTPUT vSummObCalc,                  /* Сумма обеспечения */
                                      OUTPUT vSummCorr).                   /* Сумма корректировки */
      pick-value = STRING(vSummCorr).
   END.

END PROCEDURE.

   /* =======================================---=-=-=-=-=-=-=-=-
   ** Что делает: Определяет счет по плавающему обеспечению
   ** Синтаксис : ПлавОбСчет()
   ** Автор     : Jadv 09.09.2009
   ** Пример    : ПлавОбСчет()
   */
PROCEDURE ПлавОбСчет:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEF VAR vLoanHandle AS HANDLE NO-UNDO.  /* Хэндл договора */
      /* Локализация буфера */
   DEF BUFFER b-acct FOR acct.

   pick-value = ?.

   RUN LOAN_VALID_HANDLE (INPUT-OUTPUT vLoanHandle).

   IF VALID-HANDLE(vLoanHandle) THEN
   DO:
      RUN GetObFloatAcct IN h_lngar (ENTRY(1, vLoanHandle:PRIVATE-DATA),  /* Назначение договора */
                                      ENTRY(2, vLoanHandle:PRIVATE-DATA),  /* Номер договора */
                                      in-op-date,                          /* Дата */
                                      BUFFER b-acct).                      /* Буфер счета */

      IF AVAIL b-acct THEN
         pick-value = b-acct.acct.

      RELEASE b-acct.
   END.

END PROCEDURE.

/* Процедура возвращает сумму, на которую необходимо восстановить лимит по кредиту */
/*   вызов: ЛимВосст(<Сумма на которую необходимо восстановить лимит>)
     пример: ЛимВосст("1000000")  */

PROCEDURE ЛимВосст.

   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEF VAR vLoanHandle     AS HANDLE NO-UNDO. /* Просто хэндл, просто договора */
   DEF VAR vSumm           AS DEC    NO-UNDO. /* Передаваемая сумма */
   DEF VAR vRejim          AS CHAR   NO-UNDO. /* ДР "Режим с договора" */
   DEF VAR vOstLimVid      AS DEC    NO-UNDO. /* Оставшийся лимит выдачи */
   DEF VAR vMeasure        AS CHAR   NO-UNDO. /* Затычка для get-one-limit */
   DEF VAR vLimZad         AS DEC    NO-UNDO. /* Лимит задолжености */
   DEF VAR vKredNOst       AS DEC    NO-UNDO. /* Остаток на КредН */

   DEF BUFFER loan      FOR loan.      /* Локализация буфера. */
   DEF BUFFER loan-int  FOR loan-int.  /* Локализация буфера. */
   DEF BUFFER loan-acct FOR loan-acct. /* Локализация буфера. */
   mb:
   DO ON ERROR UNDO, LEAVE:

      pick-value = ?.

      IF param-count GT 1 THEN
      DO:
         RUN Fill-Sysmes IN h_tmess ("", "", "-1", "ОШИБОЧНОЕ количество параметров передано в процедуру ЛимВосст:" + STRING(param-count) + "\n(должно быть 1) !").
         LEAVE mb.
      END.

      RUN LOAN_VALID_HANDLE (INPUT-OUTPUT vLoanHandle).

      IF NOT VALID-HANDLE(vLoanHandle) THEN
         LEAVE mb.

      vSumm = DEC(getparam(1,param-str)).

      FIND FIRST wop WHERE RECID(wop) EQ rid NO-LOCK NO-ERROR.
      IF NOT AVAIL wop THEN
         LEAVE mb.

      /* Если проводка создается по траншу, то работаем с охватывающеми соглашением,
      ** иначе - с обрабатываемым транзакцией договором */
      IF NUM-ENTRIES(ENTRY(2, vLoanHandle:PRIVATE-DATA)," ") EQ 2 THEN
         FIND FIRST loan WHERE loan.contract  EQ ENTRY(1, vLoanHandle:PRIVATE-DATA)
                           AND loan.cont-code EQ ENTRY(1,ENTRY(2, vLoanHandle:PRIVATE-DATA)," ")
         NO-LOCK NO-ERROR.
      ELSE
         FIND FIRST loan WHERE loan.contract  EQ ENTRY(1, vLoanHandle:PRIVATE-DATA)
                           AND loan.cont-code EQ ENTRY(2, vLoanHandle:PRIVATE-DATA)
         NO-LOCK NO-ERROR.

      IF NOT AVAIL loan THEN
         LEAVE mb.

      vRejim = GetXAttrValueEx ("loan",loan.contract + "," + loan.cont-code,"Режим",?).

      CASE vRejim:
         WHEN "ВозобнЛиния" THEN
         DO:
            /* Для возобновляемых линий лимит восстанавливается на всю сумму погашения ОД */
            pick-value = STRING(vSumm).
            LEAVE mb.
         END.
         WHEN "НевозЛиния" THEN
         DO:
            /* Для невозвобновляемых линий лимит не восстанавливается */
            pick-value = "0".
            LEAVE mb.
         END.
         WHEN "ЛимВыдЗад" THEN
         DO:
            RUN get-one-limit ("loan",
                               loan.contract + "," + loan.cont-code,
                               "limit-l-distr",
                               wop.con-date,
                               "",
                               OUTPUT vMeasure,
                               OUTPUT vOstLimVid).

            FOR EACH loan-int WHERE loan-int.contract  EQ loan.contract
                                AND loan-int.cont-code EQ loan.cont-code
                                AND loan-int.id-d      EQ 0
                                AND loan-int.id-k      EQ 3
                                AND loan-int.mdate     LE wop.con-date
            NO-LOCK:
               vOstLimVid =  vOstLimVid - loan-int.amt-rub.
            END.
            /* Если это договор соглашение, то вычитаем еще операции выдачи по траншам */
            IF loan.cont-type EQ "Течение" THEN
               FOR EACH loan-int WHERE loan-int.contract  EQ     loan.contract
                                   AND loan-int.cont-code BEGINS loan.cont-code + " "
                                   AND loan-int.id-d      EQ     0
                                   AND loan-int.id-k      EQ     3
                                   AND loan-int.mdate     LE     wop.con-date
               NO-LOCK:
                  vOstLimVid =  vOstLimVid - loan-int.amt-rub.
               END.

            vOstLimVid = MAX(vOstLimVid,0).

            RUN get-one-limit ("loan",
                               loan.contract + "," + loan.cont-code,
                               "limit-l-debts",
                               wop.con-date,
                               "",
                               OUTPUT vMeasure,
                               OUTPUT vLimZad).

            FIND LAST loan-acct WHERE loan-acct.contract  EQ loan.contract
                                  AND loan-acct.cont-code EQ loan.cont-code
                                  AND loan-acct.acct-type EQ "КредН"
                                  AND loan-acct.since     LE wop.con-date
            NO-LOCK NO-ERROR.
            IF AVAIL loan-acct THEN
            DO:
               RUN acct-pos IN h_base (loan-acct.acct, loan.currency, wop.con-date,wop.con-date,"v").
               vKredNOst = IF loan.currency EQ "" THEN ABS(sh-bal)
                                                  ELSE ABS(sh-val).
            END.

            pick-value = STRING(MIN(MIN(vLimZad,vOstLimVid) - vKredNOst,vSumm)).
         END.
      END CASE.
   END. /* do on error */

END PROCEDURE .

PROCEDURE ОПР.
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEFINE VARIABLE vContract AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE vContCode AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE vChowhe   AS INT64     NO-UNDO.
   DEFINE VARIABLE vBegDate  AS DATE        NO-UNDO.
   DEFINE VARIABLE vEndDate  AS DATE        NO-UNDO.
   DEFINE VARIABLE vSumInt   AS DECIMAL     NO-UNDO.
   DEFINE VARIABLE vHTempl   AS HANDLE      NO-UNDO.

   mb:
   DO ON ERROR UNDO, LEAVE:
       /* Определение правильного применения функции,
      ** формат private-data */
      RUN LOAN_VALID_HANDLE(INPUT-OUTPUT vHTempl).

      /* Номер договора не определен */
      IF NOT VALID-HANDLE(vHTempl) THEN DO :
         pick-value = ?.
         LEAVE mb.
      END.
      IF  param-count           LT 1
      THEN DO:
         RUN Fill-Sysmes IN h_tmess ("", "", "-1", "ОШИБОЧНОЕ количество параметров передано в процедуру ОПР:" + STRING(param-count) + "\n(должно быть не меньше 1) !").
         LEAVE mb.
      END.
      ASSIGN
         vContract = ENTRY(1, vHTempl:PRIVATE-DATA)
         vContCode = ENTRY(2, vHTempl:PRIVATE-DATA)
      .
      vChowhe   = INT64(getparam(1,param-str)).
      FIND FIRST wop WHERE RECID(wop) EQ rid NO-LOCK.
      CASE getparam(2,param-str):
         WHEN "ПД" THEN
            vBegDate = wop.con-date.
         WHEN "ОД" THEN
            vBegDate = in-op-date.
         WHEN "ППД1" THEN
         DO:
            FIND LAST term-obl WHERE term-obl.contract  EQ vContract
                                 AND term-obl.cont-code EQ vContCode
                                 AND term-obl.idnt      EQ 1
                                 AND term-obl.end-date  LE in-op-date
                               NO-LOCK NO-ERROR.

            vBegDate = IF AVAIL term-obl THEN term-obl.end-date
                                         ELSE in-op-date.
         END.
         WHEN "ППД2" THEN
         DO:
            FIND LAST term-obl WHERE term-obl.contract  EQ vContract
                                 AND term-obl.cont-code EQ vContCode
                                 AND term-obl.idnt      EQ 3
                                 AND term-obl.end-date  LE in-op-date
                               NO-LOCK NO-ERROR.

            vBegDate = IF AVAIL term-obl THEN term-obl.end-date
                                         ELSE in-op-date.
         END.
         WHEN "?" THEN
            vBegDate = gbeg-date.
         OTHERWISE
         DO:
            vBegDate = DATE(getparam(2,param-str)) NO-ERROR.
            IF   ERROR-STATUS:ERROR
              OR vBegDate EQ ? THEN
               vBegDate = gbeg-date.
         END.
      END CASE.
      CASE getparam(3,param-str):
         WHEN "ПД" THEN
            vEndDate = wop.con-date.
         WHEN "ОД" THEN
            vEndDate = in-op-date.
         WHEN "ППД1" THEN
         DO:
            FIND LAST term-obl WHERE term-obl.contract  EQ vContract
                                 AND term-obl.cont-code EQ vContCode
                                 AND term-obl.idnt      EQ 1
                                 AND term-obl.end-date  LE in-op-date
                               NO-LOCK NO-ERROR.

            vEndDate = IF AVAIL term-obl THEN term-obl.end-date
                                         ELSE in-op-date.
         END.
         WHEN "ППД2" THEN
         DO:
            FIND LAST term-obl WHERE term-obl.contract  EQ vContract
                                 AND term-obl.cont-code EQ vContCode
                                 AND term-obl.idnt      EQ 3
                                 AND term-obl.end-date  LE in-op-date
                               NO-LOCK NO-ERROR.

            vEndDate = IF AVAIL term-obl THEN term-obl.end-date
                                         ELSE in-op-date.
         END.
         WHEN "?" THEN
            vEndDate = gend-date.
         OTHERWISE
         DO:
            vEndDate = DATE(getparam(3,param-str)) NO-ERROR.
            IF   ERROR-STATUS:ERROR
              OR vEndDate EQ ? THEN
               vEndDate = gend-date.
         END.
      END CASE.

      IF vBegDate > vEndDate THEN
      DO:
         RUN Fill-Sysmes IN h_tmess ("", "", "-1", "ОШИБКА в функции ОПР: Дата начала периода больше даты окончания.").
         LEAVE mb.
      END.
      RUN GetSumLoanInt (vContract,
                         vContCode,
                         vChowhe,
                         vBegDate,
                         vEndDate,
                         OUTPUT vSumInt).
   END.
   pick-value = STRING(vSumInt).
END PROCEDURE.

/*--------------------------------------------------------------------------
    * Что делает: Функция определяет, что наступил срок окончания грейс-периода.
    * Синтаксис : ГрейсСрокОконч()
    * Автор     : Gorm 07.10.2009
    * Пример    : ГрейсСрокОконч()
  --------------------------------------------------------------------------*/
PROCEDURE ГрейсСрокОконч:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEF VAR vLoanHandle   AS HANDLE    NO-UNDO.
   DEF VAR vContract     AS CHARACTER NO-UNDO.
   DEF VAR vContCode     AS CHARACTER NO-UNDO.
   DEF VAR vGrace        AS CHARACTER NO-UNDO.
   DEF VAR vGraceProb    AS INT64   NO-UNDO. /* пробег даты окончания грейс-периода */
   DEF VAR vGraceSdvig   AS CHARACTER NO-UNDO. /* сдвиг даты окончания грейс-периода */
   DEF VAR vEndDateGr    AS DATE      NO-UNDO. /* дата окончания грейс-периода */

   DEF BUFFER gloan-cond FOR loan-cond.

   pick-value = "0".

   RUN LOAN_VALID_HANDLE (INPUT-OUTPUT vLoanHandle).
   IF VALID-HANDLE(vLoanHandle) THEN
   DO:
      ASSIGN
          vContract = ENTRY(1, vLoanHandle:PRIVATE-DATA)
          vContCode = ENTRY(2, vLoanHandle:PRIVATE-DATA)
          .
      FIND FIRST loan WHERE
                 loan.contract  EQ ENTRY(1,vLoanHandle:PRIVATE-DATA)
             AND loan.cont-code EQ ENTRY(2,vLoanHandle:PRIVATE-DATA)
      NO-LOCK NO-ERROR.

      IF NOT AVAIL loan THEN RETURN.

      /* ищем первое условие */
      FIND FIRST gloan-cond WHERE
                 gloan-cond.contract = vContract
             AND gloan-cond.cont-code = vContCode
          NO-LOCK NO-ERROR.
      IF AVAIL gloan-cond THEN
          vGrace = GetXattrValueEx("loan-cond",
                                   vContract + "," + vContCode + ","
                                   + STRING(gloan-cond.since),
                                   "Грейс",
                                   "").
      ELSE vGrace = "Нет".

      IF vGrace = "Да" THEN DO:

          FIND LAST loan-cond WHERE
                    loan-cond.contract = vContract
                AND loan-cond.cont-code = vContCode
                AND loan-cond.since <= in-op-date + 1
                AND loan-cond.since > gloan-cond.since
          NO-LOCK NO-ERROR.

          IF AVAIL loan-cond AND
                   loan-cond.since = in-op-date + 1
              THEN pick-value = "1".

      END.

   END.
END PROCEDURE.

/*
   * Что делает: Возвращает значение параметра договора из ДР rests.
   * Синтаксис : ПРМПок (<код параметра>)
   * Пример    : ПРМПок (5400) = 200
*/
PROCEDURE ПРМПок:
   DEF INPUT PARAM rid         AS RECID     NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE      NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHARACTER NO-UNDO.

   DEF VAR vHTempl   AS HANDLE    NO-UNDO. /* Указатель на параметры договора */
   DEF VAR vCurr     AS CHARACTER NO-UNDO.
   DEF VAR vContract AS CHARACTER NO-UNDO. /* назначение договора */
   DEF VAR vContCode AS CHARACTER NO-UNDO. /* номер договора */
   DEF VAR vRests    AS CHARACTER NO-UNDO. /* параметры приобретения */
   DEF VAR iCount    AS INT64   NO-UNDO. /* просто счетчик */
   DEF VAR vparamStr AS CHARACTER NO-UNDO. /* код и сумма параметра приобретения */
   DEF VAR vparcode  AS CHARACTER NO-UNDO. /* код параметра приобретения */
   DEF VAR ipar      AS CHARACTER NO-UNDO. /* код параметра искомый */
   DEF VAR vsumm     AS DECIMAL INITIAL 0.0  NO-UNDO.

   DEF BUFFER loan FOR loan.

   IF param-count > 1 THEN
   DO:
      RUN Fill-Sysmes IN h_tmess ("", "", "0", "Ошибочное количество параметров передано в процедуру ПРМЭКВ: " + STRING(param-count) + "\n(должно быть 2 или 3) !").
      RETURN.
   END.

   /* Определение правильного применения функции,
   ** формат private-data */
   RUN LOAN_VALID_HANDLE(INPUT-OUTPUT vHTempl).

   /* Номер договора не определен */
   IF NOT VALID-HANDLE(vHTempl) THEN
   DO :
      pick-value = ?.
      RETURN.
   END.

   ASSIGN
      vContract = ENTRY(1, vHTempl:PRIVATE-DATA)
      vContCode = ENTRY(2, vHTempl:PRIVATE-DATA).

   /* Поиск договора */
   RUN RE_B_LOAN (vContract, vContCode, BUFFER loan).
   IF NOT AVAIL loan THEN
   DO:
      pick-value = ?.
      RETURN.
   END.
   ASSIGN
      ipar = getparam(1,param-str)
      vRests = GetXAttrValueEx("loan",vContract + "," + vContCode,
                               "rests", "").
   IF vRests NE "" THEN DO:
      DO iCount = 1 TO NUM-ENTRIES(vRests, ";"):
         vparamStr = TRIM(ENTRY(iCount, vRests, ";")).
         vparcode = ENTRY(1, vparamStr, "=").
         IF (    ENTRY(1, vparcode, ":") EQ "-1"
             AND ENTRY(2, vparcode, ":") EQ ipar)
            OR
            (vparcode EQ ipar) THEN
            DO:
               vsumm = DEC(ENTRY(1,
                                 ENTRY(2, vparamStr, "="),
                                 ":")
                          ).
               LEAVE.
            END.
      END.

   END.

   pick-value = STRING(vsumm).
END PROCEDURE.

/* Процедура поиска счета по Роли от контрагента - используется для определения              */
/* счета договора - соглашения с контрагентом                                                */
/* Вызов: РольПоКонтр("<Роль>")                                                               */
/* Роль1 - роль счета в договоре с контрагентом - РасчетВнеш РасчетОп СчетПродаж ТрПерВык ТрПеречисл ТрПост */

PROCEDURE РольПоКонтр.

   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEF VAR vHTempl      AS HANDLE NO-UNDO. /* Указатель на параметры договора */
   DEF VAR vContract    AS CHAR   NO-UNDO. /* назначение договора */
   DEF VAR vContCode    AS CHAR   NO-UNDO. /* номер договора */
   DEF VAR in-contract  AS CHAR   NO-UNDO.
   DEF VAR in-cont-code AS CHAR   NO-UNDO.
   DEF VAR vFindRole    AS CHAR   NO-UNDO.

   DEF BUFFER loan FOR loan.
   DEF BUFFER xloan-acct FOR loan-acct.

   IF param-count > 1 THEN
   DO:
      RUN Fill-Sysmes IN h_tmess ("", "", "0", "Ошибочное количество параметров передано в процедуру ПРМЭКВ: " + STRING(param-count) + "\n(должно быть 2 или 3) !").
      RETURN.
   END.

   /* Определение правильного применения функции,
   ** формат private-data */
   RUN LOAN_VALID_HANDLE(INPUT-OUTPUT vHTempl).

   /* Номер договора не определен */
   IF NOT VALID-HANDLE(vHTempl) THEN
   DO :
      pick-value = ?.
      RETURN.
   END.

   ASSIGN
      vContract = ENTRY(1, vHTempl:PRIVATE-DATA)
      vContCode = ENTRY(2, vHTempl:PRIVATE-DATA).
/* найдем контрагента */
   in-cont-code = GetXAttrValueEx("loan",vContract + "," + vContCode,
                               "РКонтрДог", "").
   IF in-cont-code EQ "" THEN DO:
      RUN Fill-Sysmes IN h_tmess ("", "", "0", "Не определен договор с контрагентом!").
      RETURN.
   END.

   ASSIGN
      vFindRole = getparam(1,param-str)
      in-contract = 'aijk'.

   FIND LAST xloan-acct WHERE
             xloan-acct.contract  EQ in-contract
         AND xloan-acct.cont-code EQ in-cont-code
         AND xloan-acct.acct-type EQ vFindRole
         AND xloan-acct.since     LE in-op-date NO-LOCK NO-ERROR.

   IF NOT AVAIL xloan-acct THEN
      FIND LAST xloan-acct WHERE
                xloan-acct.contract  EQ in-contract
            AND xloan-acct.cont-code EQ in-cont-code + "@" + ShFilial
            AND xloan-acct.acct-type EQ vFindRole
            AND xloan-acct.since     LE in-op-date NO-LOCK NO-ERROR.
   IF NOT AVAIL xloan-acct THEN
      RUN Fill-Sysmes IN h_tmess ("", "", "0", "Не найден счет с ролью " + vFindRole + " на договоре с контрагентом").
   ELSE
      pick-value = xloan-acct.acct.
END PROCEDURE.


/* Процедура расчета курсовых разниц                   */
/* Вызов: НВПИКурс(<код параметра>,<Сумма>,<ПОЛ/ОТР>") */
/* Параметр      - номер параметра договора на котором фиксируются списания и начисления */
/* Сумма         - сумма списания                                                        */
/* ПОЛ или ОТР   - положительную или отрицательную курсовую разницу считать              */

PROCEDURE НВПИКурс.

   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEF VAR vHTempl      AS HANDLE NO-UNDO. /* Указатель на параметры договора */
   DEF VAR vContract    AS CHAR   NO-UNDO. /* назначение договора */
   DEF VAR vContCode    AS CHAR   NO-UNDO. /* номер договора */
   DEF VAR vCodPar      AS CHAR   NO-UNDO.
   DEF VAR vSign        AS CHAR   NO-UNDO.
   DEF VAR vSumma       AS DECIMAL NO-UNDO .
   DEF VAR vVes         AS DECIMAL NO-UNDO .


   IF param-count NE 3 THEN
   DO:
      RUN Fill-Sysmes IN h_tmess ("", "", "0", "Ошибочное количество параметров передано в процедуру НВПИКурс: " + STRING(param-count) + "\n(должно быть 3) !").
      RETURN.
   END.

   /* Определение правильного применения функции,
   ** формат private-data */
   RUN LOAN_VALID_HANDLE(INPUT-OUTPUT vHTempl).

   /* Номер договора не определен */
   IF NOT VALID-HANDLE(vHTempl) THEN
   DO :
      pick-value = ?.
      RETURN.
   END.

   ASSIGN
      vContract = ENTRY(1, vHTempl:PRIVATE-DATA)
      vContCode = ENTRY(2, vHTempl:PRIVATE-DATA)
      vCodPar   = getparam(1,param-str)
      vSumma    = DECIMAL(getparam(2,param-str))
      vSign     = getparam(3,param-str)
      .

   vVes = fNVPIKurs (
            vContract ,
            vContCode ,
            in-op-date ,
            vCodPar ,
            vSumma ,
            vSign
            ) .

      pick-value =  string(vVes).

END PROCEDURE.

/*
    * Что делает: Возвращает дату "план" или "период" погашения процентов по договору
    * Синтаксис : ПДатаПр("Кредит"|"Депоз",
                         [ПЛАН|ПЕРИОД], - дата, которую возвращает ф-ция из графика
                         ["ОД"|"ДВ"|"ПД"], - Дата отноительно которой считаем Опер День, Дата Валютирования, Плановая Дата.
                         ["EQ" | "GE" | "LE" | "GT" | "LT"| "="] - Знак поиска даты = ,<= ,>= ,> ,<.
                         )
                  в парсере нельзя использовать знаки > или <, т.к. они воспринимаются, как открытие и закрытие тега с ф-цией
                  По умолчанию берется ПД , ПЛАН , = .
    * Автор     : Priv 16/05/2011
*/
PROCEDURE ПДатаПр:
   DEF INPUT PARAM rid         AS RECID  NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE   NO-UNDO.
   DEF INPUT PARAM param-count AS INT64  NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR   NO-UNDO.

   DEF VAR mDateKind   AS CHAR   NO-UNDO.
   DEF VAR mDate       AS DATE   NO-UNDO.
   DEF VAR mContract   AS CHAR   NO-UNDO.
   DEF VAR h_templ     AS HANDLE NO-UNDO.
   DEF VAR mZnak       AS CHAR   NO-UNDO.
   DEF VAR mNapr       AS CHAR   NO-UNDO.
   DEF VAR mReturnDate AS DATE   NO-UNDO.

   IF     param-count LT 1
      OR  param-count GT 4 THEN
   DO:
      RUN Fill-Sysmes IN h_tmess ("", "", "0", "Ошибочное количество параметров передано в функцию ПДатаПр:" + STRING(param-count) + "\n(должно быть 1-4) !").
      RETURN.
   END.

   mContract = GetParam(1,param-str).

   /* Определение правильного применения функции, формат private-data */
   RUN LOAN_VALID_HANDLE (INPUT-OUTPUT h_templ).

   IF NOT VALID-HANDLE(h_templ)
   THEN DO:
      pick-value  = ? .
      RETURN .
   END.

   RUN RE_B_LOAN (mContract,
                  ENTRY(2,h_templ:PRIVATE-DATA),
                  BUFFER loan).
   IF NOT AVAIL loan THEN
   DO:
      pick-value = ?.
      RETURN .
   END.

   /*ищем wop для определения плановой даты*/
   FIND FIRST wop WHERE RECID(wop) = rid NO-LOCK NO-ERROR.
   IF NOT AVAIL wop THEN
   DO:
      pick-value = ?.
      RETURN .
   END.

   mDateKind = getparam(2,param-str) NO-ERROR.
   IF ERROR-STATUS:ERROR THEN
   DO:
      RUN Fill-Sysmes IN h_tmess ("", "", "0", "Неправильно указан идентификатор обязательства!").
      RETURN.
   END.
   IF NOT {assigned mDateKind} THEN mDateKind = "ПЛАН".

   IF getparam(3,param-str) NE ? THEN
       CASE getparam(3,param-str):
          WHEN "ОД" THEN
              mDate = in-op-date.
          WHEN "ДВ" THEN
              mDate = wop.value-date.
          WHEN "ПД" THEN
              mDate = wop.con-date.
       END CASE.
   ELSE
      mDate = wop.con-date.

   IF mDate = ? THEN
   DO:
      RUN Fill-Sysmes IN h_tmess ("", "", "0", "Неправильно указана дата!").
      RETURN.
   END.

   /* ищем плановау дату платежа  */
   IF getparam(4,param-str) NE ? THEN
      mZnak = getparam(4,param-str).
   ELSE
      mZnak = "EQ".

   IF NOT CAN-DO("GT,LT,LE,GE,EQ,=",mZnak) THEN
   DO:
      RUN Fill-Sysmes IN h_tmess ("", "", "0", "Неправильно указан знак!").
      RETURN.
   END.

   RUN pGetDatePay(loan.contract,
                   loan.cont-code,
                   mDateKind,
                   mDate,
                   mZnak,
                   1,
                   OUTPUT mReturnDate).

   pick-value = STRING(mReturnDate).

END. /*PROCEDURE ПДатаПр*/

/*
    * Что делает: Возвращает дату "план" или "период" погашения процентов по договору
    * Синтаксис : ПДатаПлат("Кредит"|"Депоз",
                         [ПЛАН|ПЕРИОД], - дата, которую возвращает ф-ция из графика
                         ["ОД"|"ДВ"|"ПД"], - Дата отноительно которой считаем Опер День, Дата Валютирования, Плановая Дата.
                         ["EQ" | "GE" | "LE" | "GT" | "LT"| "="] - Знак поиска даты = ,<= ,>= ,> ,<.
                         "1"|"3" - Тип платежа (1- проценты, 3 - основной долг)
                         )
                  в парсере нельзя использовать знаки > или <, т.к. они воспринимаются, как открытие и закрытие тега с ф-цией
                  По умолчанию берется ПД , ПЛАН , = .
    * Автор     : Priv 16/05/2011
*/
PROCEDURE ПДатаПлат:
   DEF INPUT PARAM rid         AS RECID  NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE   NO-UNDO.
   DEF INPUT PARAM param-count AS INT64  NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR   NO-UNDO.

   DEF VAR mDateKind   AS CHAR   NO-UNDO.
   DEF VAR mDate       AS DATE   NO-UNDO.
   DEF VAR mContract   AS CHAR   NO-UNDO.
   DEF VAR h_templ     AS HANDLE NO-UNDO.
   DEF VAR mZnak       AS CHAR   NO-UNDO.
   DEF VAR mNapr       AS CHAR   NO-UNDO.
   DEF VAR mReturnDate AS DATE   NO-UNDO.
   DEF VAR TypePay     AS INT64  NO-UNDO.

   IF     param-count LT 1
      OR  param-count GT 5 THEN
   DO:
      RUN Fill-Sysmes IN h_tmess ("", "", "0", "Ошибочное количество параметров передано в функцию ПДатаПлат:" + STRING(param-count) + "\n(должно быть 1-5) !").
      RETURN.
   END.

   mContract = GetParam(1,param-str).

   /* Определение правильного применения функции, формат private-data */
   RUN LOAN_VALID_HANDLE (INPUT-OUTPUT h_templ).

   IF NOT VALID-HANDLE(h_templ)
   THEN DO:
      pick-value  = ? .
      RETURN .
   END.

   RUN RE_B_LOAN (mContract,
                  ENTRY(2,h_templ:PRIVATE-DATA),
                  BUFFER loan).
   IF NOT AVAIL loan THEN
   DO:
      pick-value = ?.
      RETURN .
   END.

   /*ищем wop для определения плановой даты*/
   FIND FIRST wop WHERE RECID(wop) = rid NO-LOCK NO-ERROR.
   IF NOT AVAIL wop THEN
   DO:
      pick-value = ?.
      RETURN .
   END.

   mDateKind = getparam(2,param-str) NO-ERROR.
   IF ERROR-STATUS:ERROR THEN
   DO:
      RUN Fill-Sysmes IN h_tmess ("", "", "0", "Неправильно указан идентификатор обязательства!").
      RETURN.
   END.
   IF NOT {assigned mDateKind} THEN mDateKind = "ПЛАН".

   IF getparam(3,param-str) NE ? THEN
       CASE getparam(3,param-str):
          WHEN "ОД" THEN
              mDate = in-op-date.
          WHEN "ДВ" THEN
              mDate = wop.value-date.
          WHEN "ПД" THEN
              mDate = wop.con-date.
       END CASE.
   ELSE
      mDate = wop.con-date.

   IF mDate = ? THEN
   DO:
      RUN Fill-Sysmes IN h_tmess ("", "", "0", "Неправильно указана дата!").
      RETURN.
   END.

   /* ищем плановау дату платежа  */
   IF getparam(4,param-str) NE ? THEN
      mZnak = getparam(4,param-str).
   ELSE
      mZnak = "EQ".

   IF getparam(5,param-str) NE ? THEN
      TypePay = INT(getparam(5,param-str)).
   ELSE
   DO:
      RUN Fill-Sysmes IN h_tmess ("", "", "0", "Неправильно указан тип платежа.").
      RETURN.
   END.
   IF NOT CAN-DO("GT,LT,LE,GE,EQ",mZnak) THEN
   DO:
      RUN Fill-Sysmes IN h_tmess ("", "", "0", "Неправильно указан знак!").
      RETURN.
   END.

   RUN pGetDatePay(loan.contract,
                   loan.cont-code,
                   mDateKind,
                   mDate,
                   mZnak,
                   TypePay,
                   OUTPUT mReturnDate).

   pick-value = STRING(mReturnDate, "99/99/9999").

END. /*PROCEDURE ПДатаПлат*/

/*
  * Что делает: Определяет сумму просрочки в периоде (Грейс)
  * Параметры : [Пр] без параметра по ОД, с параметром по %
  * Результат : Определяет сумму просрочки в периоде
  * Синтаксис : СуммаПросГр()
  * Пример    : СуммаПросГр() = 468
*/
PROCEDURE СуммаПросГр:

   DEF INPUT PARAM rid         AS RECID     NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE      NO-UNDO.
   DEF INPUT PARAM param-count AS INT64     NO-UNDO.
   DEF INPUT PARAM param-str   AS CHARACTER NO-UNDO.

   DEF VAR vHTempl     AS HANDLE NO-UNDO.   /* Указательна параметры договора */
   DEF VAR vNotPogSumm AS DEC    NO-UNDO.
   DEF VAR vNotPogCurS AS DEC    NO-UNDO.
   DEF VAR vContract   AS CHAR   NO-UNDO.
   DEF VAR vContCode   AS CHAR   NO-UNDO.
   DEF VAR vGrPog      AS INT64  INIT 3 NO-UNDO.

   DEFINE BUFFER tloan      FOR loan.      /* Договор */
   DEFINE BUFFER term-obl   FOR term-obl.
   mb:
   DO ON ERROR UNDO, LEAVE:
      pick-value = "0".
      IF     param-count NE 0
         AND param-count NE 1 THEN
      DO:
         RUN Fill-Sysmes IN h_tmess ("", "", "-1", "ОШИБОЧНОЕ количество параметров передано в функцию " +
                                                   STRING(PROGRAM-NAME(1)) + ": \n(должно быть 0 или 1)!").
         pick-value = ?.
         LEAVE mb.
      END.
      IF     param-count EQ 1
         AND getparam(1,param-str) EQ "Пр" THEN
          vGrPog = 1.

      /* Определение правильного применения функции,
      ** формат private-data */
      RUN LOAN_VALID_HANDLE (INPUT-OUTPUT vHTempl).

      /* Договор не определен */
      IF NOT VALID-HANDLE (vHTempl) THEN
      DO:
         pick-value = ?.
         LEAVE mb.
      END.
      ASSIGN
         vContract = ENTRY(1,vHTempl:PRIVATE-DATA)
         vContCode = ENTRY(2,vHTempl:PRIVATE-DATA)
      .
      /* Ищем сам договор */
      FIND FIRST tloan WHERE tloan.contract  EQ vContract
                         AND tloan.cont-code EQ vContCode
           NO-LOCK NO-ERROR.
      IF NOT AVAIL tloan THEN
         LEAVE mb.
      ASSIGN
         vNotPogSumm = 0
      .

       FOR EACH term-obl WHERE term-obl.contract  EQ vContract
                          AND term-obl.cont-code EQ vContCode
                          AND term-obl.end-date  LE in-op-date
                          AND term-obl.idnt      EQ vGrPog NO-LOCK:
         IF term-obl.dsc-beg-date EQ in-op-date THEN
         DO:
            IF vGrPog EQ 3 THEN
               RUN summ-t.p (OUTPUT vNotPogCurS,
                                    tloan.contract,
                                    tloan.cont-code,
                                    RECID(term-obl),
                                    tloan.since).
            ELSE
               RUN summ-t1.p (OUTPUT vNotPogCurS,
                                     RECID(term-obl),
                                     RECID(tloan)).
            ASSIGN
               vNotPogSumm = vNotPogSumm + vNotPogCurS
            .
         END.
      END. /* FOR EACH term-obl*/
      pick-value = STRING(vNotPogSumm).
   END.
END PROCEDURE.

/*
  * Что делает: Получение значения ДР ПовышСтав с условия
  * Параметры : без параметров
  * Результат : Возвращает признак повышенной ставки на договоре. Если на условии задан ДР ПовышСтав = Да, значит повышенная ставка присутствует.
  * Синтаксис : ПовышСтав()
  * Пример    : ПовышСтав()
*/
PROCEDURE ПовышСтав:

   DEF INPUT PARAM rid         AS RECID     NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE      NO-UNDO.
   DEF INPUT PARAM param-count AS INT64     NO-UNDO.
   DEF INPUT PARAM param-str   AS CHARACTER NO-UNDO.

   DEF VAR vHTempl     AS HANDLE NO-UNDO.   /* Указательна параметры договора */
   DEF VAR vContract   AS CHAR   NO-UNDO.
   DEF VAR vContCode   AS CHAR   NO-UNDO.

   DEFINE BUFFER bloan      FOR loan.
   DEFINE BUFFER bloan-cond FOR loan-cond.

   mb:
   DO ON ERROR UNDO, LEAVE:

      pick-value = ?.

      IF param-count NE 0 THEN
      DO:
         RUN Fill-Sysmes IN h_tmess ("", "", "-1", "ОШИБОЧНОЕ количество параметров передано в функцию " +
                                                   STRING(PROGRAM-NAME(1)) + ": \n(должно быть 0)!").
         pick-value = ?.
         LEAVE mb.
      END.

         /* Определение правильного применения функции,
         ** формат private-data */
      RUN LOAN_VALID_HANDLE (INPUT-OUTPUT vHTempl).

         /* Договор не определен */
      IF NOT VALID-HANDLE (vHTempl) THEN
      DO:
         pick-value = ?.
         LEAVE mb.
      END.
      ASSIGN
         vContract = ENTRY(1,vHTempl:PRIVATE-DATA)
         vContCode = ENTRY(2,vHTempl:PRIVATE-DATA)
      .

         /* Ищем сам договор */
      FIND FIRST bloan WHERE
                 bloan.contract  EQ vContract
             AND bloan.cont-code EQ vContCode
      NO-LOCK NO-ERROR.
      IF NOT AVAIL bloan THEN
         LEAVE mb.

         /* Ущем последнее условие на дату опер. дня */
      FIND FIRST bloan-cond WHERE
                 bloan-cond.contract  EQ vContract
             AND bloan-cond.cont-code EQ vContCode
             AND bloan-cond.since     LE in-op-date
      NO-LOCK NO-ERROR.
      IF NOT AVAIL bloan-cond THEN
         LEAVE mb.

      pick-value = GetXAttrValueEx ("loan-cond",
                                    loan-cond.contract + "," + loan-cond.cont-code + "," + STRING(loan-cond.since),
                                    "ПовышСтав",
                                    "Нет").

   END.
END PROCEDURE.

/*
  * Что делает: Определяет  последний день платежного периода  (Грейс)
  * Параметры : без параметра
  * Результат : 0 - процентный период не окончился 1 - закончился
  * Синтаксис : ГрейсПроцК
  * Пример    : ГрейсПроцК() = 1  - последний день Помпеи , нужно смотреть что выносить на просрочку!
*/

PROCEDURE ГрейсПроцК:


   DEF INPUT PARAM rid         AS RECID     NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE      NO-UNDO.
   DEF INPUT PARAM param-count AS INT64     NO-UNDO.
   DEF INPUT PARAM param-str   AS CHARACTER NO-UNDO.

   DEF VAR vHTempl     AS HANDLE NO-UNDO.   /* Указательна параметры договора */
   DEF VAR vNotPogSumm AS DEC    NO-UNDO.
   DEF VAR vNotPogCurS AS DEC    NO-UNDO.
   DEF VAR vContract   AS CHAR   NO-UNDO.
   DEF VAR vContCode   AS CHAR   NO-UNDO.
   DEF VAR vDate       AS DATE NO-UNDO .

   DEFINE BUFFER tloan      FOR loan.      /* Договор */
   DEFINE BUFFER term-obl   FOR term-obl.
   mb:
   DO ON ERROR UNDO, LEAVE:
      pick-value = "0".

      /* Определение правильного применения функции,
      ** формат private-data */
      RUN LOAN_VALID_HANDLE (INPUT-OUTPUT vHTempl).

      /* Договор не определен */
      IF NOT VALID-HANDLE (vHTempl) THEN
      DO:
         pick-value = ?.
         LEAVE mb.
      END.
      ASSIGN
         vContract = ENTRY(1,vHTempl:PRIVATE-DATA)
         vContCode = ENTRY(2,vHTempl:PRIVATE-DATA)
      .
      /* Ищем сам договор */
      FIND FIRST tloan WHERE tloan.contract  EQ vContract
                         AND tloan.cont-code EQ vContCode
           NO-LOCK NO-ERROR.
      IF NOT AVAIL tloan THEN
         LEAVE mb.
      ASSIGN
      .
      pick-value =  "0" .
      /*  Если выдача была в последний день месяца и в графиках такой строки нет */
       IF NOT CAN-FIND(FIRST term-obl WHERE
                              term-obl.contract  EQ vContract
                          AND term-obl.cont-code EQ vcontcode
                          AND term-obl.end-date  LE in-op-date
                          AND term-obl.idnt      EQ 1)
       THEN DO:
         IF tloan.open-date EQ LastMonDate(tloan.open-date) THEN DO: /* если ни найдено еще ни одного периода  и открыто в последний день месяца нужен лишний период !*/
            FIND FIRST term-obl WHERE term-obl.contract  EQ vContract
                                  AND term-obl.cont-code EQ vContCode
                                  AND term-obl.idnt      EQ 1 NO-LOCK.
            IF AVAILABLE term-obl THEN DO:
               IF tloan.class-code EQ 'loan_trans_nongrace' THEN    /* гипотетический период для нельготного транша */
                  IF MONTH(term-obl.dsc-beg-date) = 1  /* если январь */
                     THEN
                        vDate = LastWorkDay ( DATE(12 , DAY(term-obl.dsc-beg-date) , YEAR(term-obl.dsc-beg-date) - 1)) .
                     ELSE
                        vDate = LastWorkDay ( DATE(MONTH(term-obl.dsc-beg-date) - 1 , DAY(term-obl.dsc-beg-date) , YEAR(term-obl.dsc-beg-date))) .
               ELSE
                  vDate = term-obl.dsc-beg-date .   /* для льготного транша окончание  как у всех периодов в льготном условии */

               IF in-op-date EQ vDate  THEN
                  pick-value = "1".
            END.
         END.
      END.
      ELSE
         FOR EACH term-obl WHERE term-obl.contract  EQ vContract
                           AND term-obl.cont-code EQ vContCode
                           AND term-obl.end-date  LE in-op-date
                           AND term-obl.idnt      EQ 1 NO-LOCK :
            IF term-obl.dsc-beg-date EQ in-op-date THEN
               pick-value =  "1" .
         END. /* FOR EACH term-obl*/
   END.
END PROCEDURE.

/**/


PROCEDURE PirCreateBill.
   DEF INPUT  PARAM in-cont-code  AS CHAR  NO-UNDO.
   DEF INPUT  PARAM in-contract   AS CHAR  NO-UNDO.
   DEF INPUT  PARAM in-op-date    AS DATE  NO-UNDO.
   DEF INPUT  PARAM vFindRole     AS CHAR  NO-UNDO.

   DEF VAR vTransCode AS CHAR   NO-UNDO.
   DEF VAR vFlagCr    AS CHAR   NO-UNDO. /* Флаг проверки наличия LA. */
   DEF VAR vpj        AS INT64  NO-UNDO.
   DEF VAR vpn        AS INT64  NO-UNDO.
   DEF VAR vRestOldPr AS LOG    NO-UNDO.  /* Восстанавливать ли контекст pp-oldpr перед выходом */

   BLCK:
   DO 
   ON ERROR  UNDO BLCK, LEAVE BLCK
   ON ENDKEY UNDO BLCK, LEAVE BLCK:
      IF NUM-ENTRIES (in-cont-code, CHR(1)) GT 1
      THEN ASSIGN
         vFlagCr        =  ENTRY (2, in-cont-code, CHR (1))
         in-cont-code   =  ENTRY (1, in-cont-code, CHR (1))
      .


      vTransCode = GetXAttrValueEX("op-kind",wop.op-kind,"ПирТранзСоздСч",?).
      
      if vTransCode = ? then vTransCode = getsysconf("ТранзСоздСч").

      FIND FIRST op-kind WHERE op-kind.op-kind EQ vTransCode NO-LOCK NO-ERROR.
   
  
      FOR EACH op-template WHERE op-template.op-kind EQ vTransCode NO-LOCK :
         IF GetXAttrValue("op-template",op-kind.op-kind + "," +
                          string(op-templ.op-templ),"acct-type") EQ vFindRole THEN DO:
         LEAVE.
         END.
         ELSE NEXT.
      END.

      IF NOT AVAIL op-template THEN RETURN.
   
      FIND FIRST loan WHERE loan.cont-code EQ in-cont-code
                  AND loan.contract EQ in-contract NO-LOCK NO-ERROR.

                           /* Сохраняем контекст pp-oldpr */
      RUN GetEnv IN h_oldpr (OUTPUT vpj,
                             OUTPUT vpn).
      vRestOldPr = YES.
   
      RUN accttmpl.p (
         STRING (RECID(op-templ)) + CHR (1) + vFlagCr,
         RECID(loan),
         in-op-date
      ).

      IF RETURN-VALUE = "-1" THEN 
         LEAVE BLCK. /* Создание прошло с ошибкой  дальше не пойдем. */
  


      FIND LAST tt-editacct NO-LOCK NO-ERROR.
      FIND acct WHERE RECID(acct) EQ tt-editacct.rid NO-LOCK NO-ERROR.

      IF NOT AVAIL acct THEN
         LEAVE BLCK.
      RUN parssign.p (in-op-date,
                      "op-template",
                      op-kind.op-kind + "," + STRING(op-template.op-template),
                      op-template.class-code,
                      "acct",
                      acct.acct + "," + acct.currency,
                      acct.class-code,
                      ?).
      IF AVAIL loan THEN DO:
         RUN SetKau IN h_loanx (RECID(acct),
                                RECID(loan),
                                tt-editacct.acct-type).
         CREATE loan-acct.
         loan-acct.cont-code = loan.cont-code.
         {lacc.ini
            &loan-acct = loan-acct
            &contract  = loan.contract
            &acct      = acct.acct
            &currency  = acct.currency
            &acct-type = tt-editacct.acct-type
         }
         IF mViewAcctLog THEN
         DO:
            IF tt-editacct.fndstat THEN
               RUN CrtLogTbl IN h_aclog (loan-acct.contract,
                                         loan-acct.cont-code,
                                         loan-acct.acct,
                                         loan-acct.acct-type,
                                         YES).
            RUN CrtLogTbl IN h_aclog (loan-acct.contract,
                                      loan-acct.cont-code,
                                      loan-acct.acct,
                                      loan-acct.acct-type,
                                      NO).
         END.
      END.
   
   
      pick-value = string(IF CAN-FIND(FIRST  tt-editacct) THEN acct.acct ELSE ?).
   
   
      RELEASE loan-acct.
      RELEASE acct.
   END.
   IF vRestOldPr THEN
                        /* Востанавливаем контекст pp-oldpr */
      RUN SetEnv IN h_oldpr (vpj, vpn).
END PROCEDURE.




/*--------------------------------------------------------------------------
    * Что делает: Ищет счет с указанной ролью, если не найден, то запускает
                  соответствующий шаблон создания счета с этой ролью.
    * Синтаксис : Роль( <необходимая роль счета> )
    * Автор     : fepa 17/09/04
    * Пример    : Роль("Кредит")
  --------------------------------------------------------------------------*/
PROCEDURE ПирРольС.
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEF VAR in-contract  AS CHAR   NO-UNDO.
   DEF VAR vFindRole    AS CHAR   NO-UNDO.
   DEF VAR vSignDate    AS LOG    NO-UNDO. /* Признак поиска относительно плановой даты */
   DEF VAR h_templ      AS HANDLE NO-UNDO.
   DEF VAR PosIskl      AS CHAR   NO-UNDO.
   def var newacct      AS LOG    NO-UNDO.

   vFindRole = getparam(1,param-str).

   IF     param-count           GE 2
      AND getparam(2,param-str) EQ "ПД"
   THEN vSignDate = YES .

   DEF BUFFER xloan-acct FOR loan-acct .
   DEF BUFFER bxloan-acct FOR loan-acct .
   DEF BUFFER xacct FOR acct .


   /* Определение правильного применения функции, формат private-data */
   RUN LOAN_VALID_HANDLE (INPUT-OUTPUT h_templ).

   IF NOT VALID-HANDLE(h_templ) THEN
   DO:
      pick-value  = ?.
      RETURN.
   END.                                         

   in-contract = ENTRY(1,h_templ:PRIVATE-DATA).

   RUN RE_B_LOAN (in-contract,
                 ENTRY(2,h_templ:PRIVATE-DATA),
                 BUFFER loan).
   IF NOT AVAIL loan THEN
   DO:
      pick-value  = ? .
      RETURN.
   END.

   RUN FindLPResult(loan.contract,
                    loan.cont-code, 
                    "ПирРольС",
                    param-str,
                    OUTPUT pick-value).

   IF pick-value EQ "" THEN
   DO:
      FIND FIRST wop WHERE RECID(wop) = rid NO-LOCK.

      FIND LAST xloan-acct WHERE
                 xloan-acct.contract  EQ in-contract
             AND xloan-acct.cont-code EQ loan.cont-code
             AND xloan-acct.acct-type EQ vFindRole
             AND xloan-acct.since     LE IF vSignDate THEN wop.con-date ELSE in-op-date
        NO-ERROR.


 
      IF AVAILABLE xloan-acct THEN  /*если нашли счет привязанный к траншу*/
         DO:
            PosIskl = GetXAttrValueEX("loan",loan.contract + "," + loan.cont-code,"ПОСИскл",?). /*если договор исключен из ПОС, тогда нам необходимо удалить все привязки счета от ПОС*/
            if PosIskl = "ИСКЛ" THEN
	       DO:
                  if CAN-FIND (FIRST bxloan-acct where bxloan-acct.acct = xloan-acct.acct 
                                           and bxloan-acct.contract = "ПОС") THEN 
				DO:             /*если это счет ПОСа, а договор исключен, то нам нужен другой счет*/
				   pick-value = xloan-acct.acct.
                                   DELETE xloan-acct.
                                   find last xloan-acct where xloan-acct.acct <> pick-value 
                                                          and xloan-acct.contract = in-contract
                                                          and xloan-acct.cont-code = ENTRY(1,loan.cont-code," ")
                                                          and xloan-acct.acct-type = vFindRole
                                                          and xloan-acct.since <= IF vSignDate THEN wop.con-date ELSE in-op-date
		 	                                  NO-LOCK NO-ERROR.
                                   pick-value = "".
				END.
	       END.
         END.




   
      IF NOT AVAIL xloan-acct 
      THEN
	DO:

         RUN CreateBill(loan.cont-code,
                        in-contract,
                        MIN(in-op-date,wop.con-date),
                        vFindRole).    /*сначала пробуем найти счет на охвате.*/


          IF CAN-FIND (FIRST bxloan-acct where bxloan-acct.acct = pick-value 
                                           and bxloan-acct.contract = "ПОС") THEN /*если каким-то образом счет оказался счетом ПОС*/
          DO:
             FIND LAST xloan-acct WHERE xloan-acct.acct = pick-value                                   /*ищем свежепривязанный счет ПОС на транше*/
                                    AND xloan-acct.contract = in-contract
                                    AND xloan-acct.cont-code = loan.cont-code
                                    AND xloan-acct.acct-type = vFindRole
                                    AND xloan-acct.since = MIN(in-op-date,wop.con-date) NO-ERROR.
              IF AVAILABLE xloan-acct THEN DELETE xloan-acct.      /*если нашли - удаляем привязку*/
                                                                                                  
              FIND LAST xloan-acct WHERE xloan-acct.acct <> pick-value                            /*ищем счет с нужной ролью, но не счет ПОС вдруг он был ранее создан*/
                                    AND xloan-acct.contract = in-contract
                                    AND xloan-acct.cont-code = ENTRY(1,loan.cont-code," ")
                                    AND xloan-acct.acct-type = vFindRole
                                    AND xloan-acct.since <= MIN(in-op-date,wop.con-date) 
                                  NO-LOCK NO-ERROR.
              IF AVAILABLE xloan-acct THEN  /*нашли - создаем новую привязку*/
                 DO:
                    pick-value = xloan-acct.acct.
                    CREATE bxloan-acct.
                    ASSIGN
                          bxloan-acct.contract  = xloan-acct.contract
                          bxloan-acct.cont-code = loan.cont-code
                          bxloan-acct.acct-type = xloan-acct.acct-type
                          bxloan-acct.acct      = xloan-acct.acct
                          bxloan-acct.currency  = xloan-acct.currency
                          bxloan-acct.since     = MIN(in-op-date,wop.con-date).
                 END.
              ELSE pick-value = ?.             /*не нашли*/
	
	  END.
          /*здесь поищем у клиента счет, не привязанный к договору, и при этом содержащий номер договора в наименовании счета 
	    это временная заглушка для счета с ролью КредРезВб	*/

	  IF vFindRole = "КредРезВб" THEN
	     DO:
                  FIND FIRST xacct WHERE xacct.bal-acct = 47425
                                   AND CAN-DO("*" + ENTRY(1,loan.cont-code," ")+ "*",xacct.details)
                                   AND xacct.cust-cat = loan.cust-cat
                                   AND xacct.cust-id = loan.cust-id
                                   NO-LOCK NO-ERROR.                       
                if AVAILABLE xacct THEN 
                   DO:
                     if NOT CAN-FIND(FIRST xloan-acct where xloan-acct.acct = xacct.acct                 /*проверяем что счет никуда не привязан*/
                                                       AND xloan-acct.contract = in-contract)
                      THEN DO:
                              pick-value = xacct.acct.
                              CREATE xloan-acct.
                                 ASSIGN
                                        xloan-acct.contract = loan.contract
                                        xloan-acct.cont-code = ENTRY(1,loan.cont-code," ")
                                        xloan-acct.acct-type = vFindRole
                                        xloan-acct.acct = xacct.acct
                                        xloan-acct.currency = xacct.currency
                                        xloan-acct.since = MIN(in-op-date,wop.con-date).

                           end.
                   END.
             END.
                        
	  IF (pick-value = ?) or (pick-value = "") THEN  /*если счет не нашли на охвате*/
	     DO:                                         
      
                RUN PirCreateBill(loan.cont-code,      /*если счет не нашли на охвате, то создаем счет с помощью транзакции указанной в допреке ПирТранзСоздСч*/
                               in-contract,
                               MIN(in-op-date,wop.con-date),
                               vFindRole). 

                
                IF (pick-value <> ?) and (pick-value <> "")  THEN /*если счет все-таки создался то нужно его привязать на охват*/
                  DO:
                     find first bxloan-acct where bxloan-acct.acct = pick-value
                                              and bxloan-acct.contract = in-contract
                                              and bxloan-acct.cont-code = loan.cont-code   /*ожидается что здесь транш*/
                                              and bxloan-acct.acct-type = vFindRole
					      and bxloan-acct.since <= in-op-date
					      NO-LOCK NO-ERROR.
                      IF AVAILABLE (bxloan-acct) THEN 
                         DO:
                            find first xloan-acct where xloan-acct.acct = bxloan-acct.acct
						    and xloan-acct.contract = bxloan-acct.contract
						    and xloan-acct.cont-code = ENTRY(1,bxloan-acct.cont-code," ")
                                                    and xloan-acct.acct-type = bxloan-acct.acct-type
						    and xloan-acct.since <= bxloan-acct.since 
						    NO-LOCK NO-ERROR.
                           IF NOT AVAILABLE (xloan-acct) THEN 
                              DO:
                                 CREATE xloan-acct.
                                 ASSIGN
                                        xloan-acct.contract = bxloan-acct.contract
                                        xloan-acct.cont-code = ENTRY(1,bxloan-acct.cont-code," ")
                                        xloan-acct.acct-type = bxloan-acct.acct-type
                                        xloan-acct.acct = bxloan-acct.acct
                                        xloan-acct.currency = bxloan-acct.currency
                                        xloan-acct.since = bxloan-acct.since.
                              END.            
                         END.      
                  END.
             END.
           ELSE
		
	END.
      ELSE
         pick-value = xloan-acct.acct.
      RUN SaveLPResult (loan.contract,
                        loan.cont-code,
                        "ПирРольС",
                        param-str,
                        pick-value).
   END.

END PROCEDURE.




/**/

