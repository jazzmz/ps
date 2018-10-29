{pirsavelog.p}

/*
   Распоряжение по резервам 232-П
   Бурягин Е.П. 10.01.2006 10:19

   Условимся, что броузере выбраны только "правильные" документы, т.е. те,
   которые должны отображаться в настоящем распоряжении.

Modified: 20.05.2009 Borisov - Добавлены колонки обеспечения
*/

{globals.i} /* Подключяем глобалные настройки*/

{ulib.i}    /* Библиотека функций для работы со счетами */
{intrface.get rsrv}
{intrface.get i254}
{intrface.get instrum}
{intrface.get loan}
{intrface.get xclass}   /* Функции работы с метасхемой */
{intrface.get count}


/** ОПРЕДЕЛЕНИЯ **/
FUNCTION LnPrincipal2 RETURNS DECIMAL (INPUT iContract AS CHAR, INPUT iContCode AS CHAR,
                      INPUT iDate AS DATE, INPUT iCurrency AS CHAR, INPUT CC AS CHAR)
   FORWARD.
/* ============================================== */
DEF VAR oTable AS TTable       NO-UNDO.
DEF VAR oTpl     AS TTpl           NO-UNDO.
DEF VAR oDoc   AS TDocument NO-UNDO.

oTpl = new TTpl("pir_rsrv254.tpl").


DEF INPUT PARAM inParam    AS CHARACTER.
DEF VAR acct_rsrv          AS CHARACTER NO-UNDO. /* Счет резерва: определим и сохраним его в этой переменной */
DEF VAR acct_main_no       AS CHARACTER NO-UNDO. /* Внебалансовый счет, который попадает в первый столбец */
DEF VAR acct_main_cur      AS CHARACTER NO-UNDO.
DEF VAR acct_main_pos      AS DECIMAL   NO-UNDO. /* Позиция по счету */
DEF VAR acct_main_pos_rur  AS DECIMAL   NO-UNDO.
DEF VAR acct_rsrv_calc_pos AS DECIMAL   NO-UNDO.
DEF VAR acct_rsrv_real_pos AS DECIMAL   NO-UNDO.

/* Сумма операции */
DEF VAR amt_create  AS DECIMAL   NO-UNDO.
DEF VAR amt_delete  AS DECIMAL   NO-UNDO.

DEF VAR client_name AS CHARACTER NO-UNDO.
DEF VAR loaninf     AS CHARACTER NO-UNDO.
DEF VAR grrisk      AS INTEGER   NO-UNDO.
DEF VAR prrisk      AS DECIMAL   NO-UNDO.
DEF VAR obesp       AS DECIMAL   NO-UNDO.
DEF VAR o2          AS DECIMAL   NO-UNDO. /* obesp usl dog - ne isp */
DEF VAR ob-cat      AS CHARACTER NO-UNDO.
DEF VAR iob-cat     AS DECIMAL   NO-UNDO.
DEF VAR loannum     AS CHARACTER NO-UNDO.
DEF VAR vSurr       AS CHARACTER NO-UNDO. /* Суррогат обязательства */

/* Итоговые значения */
DEF VAR total_pos         AS DECIMAL NO-UNDO.
DEF VAR total_pos_rur     AS DECIMAL NO-UNDO.
DEF VAR total_pos_usd     AS DECIMAL NO-UNDO.
DEF VAR total_pos_eur     AS DECIMAL NO-UNDO.
DEF VAR total_calc_rsrv   AS DECIMAL NO-UNDO.
DEF VAR total_real_rsrv   AS DECIMAL NO-UNDO.
DEF VAR total_create_rsrv AS DECIMAL NO-UNDO.
DEF VAR total_delete_rsrv AS DECIMAL NO-UNDO.

DEF VAR traceOn           AS LOGICAL INITIAL false NO-UNDO. /* Вывод ошибок на экран */
DEF VAR tmpStr    AS CHARACTER NO-UNDO. /* Временная для работы */
DEF VAR PIRbos    AS CHARACTER NO-UNDO. /* Должности и подписи */
DEF VAR PIRbosFIO AS CHARACTER NO-UNDO.
DEF VAR userPost  AS CHARACTER NO-UNDO.

DEF BUFFER bfrLA  FOR loan-acct.

DEF VAR DATE-rasp AS DATE NO-UNDO. /* Дата распоряжения */
/* Таблица выделенных в броузере документов */

{tmprecid.def}
/**** Маслов выгрузка в архив ***/
&IF DEFINED(arch2)<>0 &THEN
&GLOBAL-DEFINE wsd 1
{pir-out2arch.i}
curr-user-inspector = FGetSetting("PirEArch","RepInspCredit",?). /* #3718 */
&ENDIF



/** Проверка входящего параметра =================================================== */
IF NUM-ENTRIES(inParam) <> 2 
THEN DO:
   MESSAGE "Недостаточное кол-во параметров. Должно быть <норм_документ>,<код_руководителя_из_PIRBoss>" 
      VIEW-AS ALERT-BOX.
   RETURN.
END.

PIRbos      =  ENTRY(1, FGetSetting("PIRboss", ENTRY(2, inParam), "")).
PIRbosFIO = ENTRY(2, FGetSetting("PIRboss", ENTRY(2, inParam), "")).

/** РЕАЛИЗАЦИЯ **/

/* Из первой операции найдем дату отчета */
DATE-rasp = gend-date.

oTable = new TTable(16).

/* Для всех документов, выбранных в брoузере выполняем... =========================== */
FOR EACH tmprecid NO-LOCK:

  oDoc = new TDocument(tmprecid.id).

   ASSIGN
      amt_create = 0
      amt_delete = 0
   .
   /* Найдем счет резерва в проводке. Он либо по дебету, либо по кредиту и начинается с 4 
      попутно сохраним значение суммы проводки в соответствующую переменную  */
   IF oDoc:acct-db BEGINS "4" THEN
      ASSIGN
         acct_rsrv  = oDoc:acct-db
         amt_delete = oDoc:sum
      .
   IF oDoc:acct-cr BEGINS "4" THEN
      ASSIGN
         acct_rsrv  = oDoc:acct-cr
         amt_create = oDoc:sum
      .

   /* Если все-таки ни по дебету, ни по кредиту счет, начинающийся на 4 не найден,
      выдаем сообщение и выходим из процедуры */
   IF acct_rsrv = ""
   THEN DO:
      MESSAGE "В проводке документа " + oDoc:doc-num + " нет счета резерва, начинающегося на 4!" VIEW-AS ALERT-BOX.
      RETURN.
   END.

   /* Найдем название клиента */
   client_name = GetAcctClientName_UAL(acct_rsrv, traceOn).

   /* Найдем информацию о договоре */
   loannum = "".
   FIND LAST bfrLA
      WHERE bfrLA.acct = acct_rsrv
        AND bfrLA.contract EQ "Кредит"
      NO-LOCK NO-ERROR.
   IF AVAIL bfrLA
   THEN DO:
      
      FIND LAST loan
         WHERE loan.contract  = bfrLA.contract
           AND loan.cont-code = bfrLA.cont-code
         NO-LOCK NO-ERROR.

      IF AVAIL loan
      THEN DO:
         IF client_name = "" THEN 
            client_name = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_short_name", false).

         loaninf = getMainLoanAttr("Кредит",loan.cont-code,"%cont-code от %ДатаСогл").
         loannum = loan.cont-code.

   /* найти "базовый" счет через договор  */
      /* Если счет привязан к договору, то нужно проанализировать его роль.
         Таблица соотвествия ролей счета резерва и "базового"
                 КредРез ....... Кредит
                 КредРез1....... КредПр 
      */

   IF bfrLA.acct-type = "КредРез1" THEN
      acct_main_no = GetLoanAcct_ULL(loan.contract, loan.cont-code, "КредПр", oDoc:DocDate, false).
   IF bfrLA.acct-type = "КредРез"  THEN
      acct_main_no = GetLoanAcct_ULL(loan.contract, loan.cont-code, "Кредит", oDoc:DocDate, false).
   acct_main_cur = SUBSTR(acct_main_no, 6, 3).

   /* Найдем остаток по базовый счету на дату */

   acct_main_pos     = LnPrincipal2 (loan.contract, loan.cont-code, DATE-rasp, loan.currency, bfrLA.acct-type).
   acct_main_pos_rur = CurToCur ("УЧЕТНЫЙ", acct_main_cur, "", DATE-rasp, acct_main_pos).

   /* Найдем расчетный резерв. На самом деле, на момент выполнения процедуры это фактически уже 
      сформированный резерв */
   acct_rsrv_calc_pos = ABS(GetAcctPosValue_UAL(acct_rsrv, "810", oDoc:DocDate, traceOn)).

   /* Найдем сформированный резерв. Поскольку распоряжение формируется по факту, т.е. по проводкам, то
      сумма сформированного резерва = остаток на счете резерва +- сумма проводки */
   acct_rsrv_real_pos = acct_rsrv_calc_pos - amt_create + amt_delete.

   /* Накапливаем итоговые суммы */
   total_pos = total_pos + acct_main_pos_rur.
   IF acct_main_cur = "810" THEN
      total_pos_rur = total_pos_rur + acct_main_pos.
   IF acct_main_cur = "840" THEN
      total_pos_usd = total_pos_usd + acct_main_pos.
   IF acct_main_cur = "978" THEN
      total_pos_eur = total_pos_eur + acct_main_pos.

   ASSIGN
      total_calc_rsrv = total_calc_rsrv + acct_rsrv_calc_pos
      total_real_rsrv = total_real_rsrv + acct_rsrv_real_pos
      total_create_rsrv = total_create_rsrv + amt_create
      total_delete_rsrv = total_delete_rsrv + amt_delete
   .

   /* Определим процентную ставку и группу риска */
   prrisk = LnRsrvRate(loan.contract, loan.cont-code, DATE-rasp).
   grrisk = LnGetGrRiska(prrisk, DATE-rasp).

   /* Определим Обеспечение */
   RUN LnCollateralValueEx(loan.contract, loan.cont-code, DATE-rasp, ?, "", OUTPUT obesp, OUTPUT o2).

   ob-cat = "".

   IF obesp NE 0
   THEN DO:
      FOR EACH term-obl
         WHERE term-obl.cont-code EQ loannum
           AND term-obl.idnt      EQ 5
         NO-LOCK:

         vSurr  = term-obl.contract + "," + 
                  term-obl.cont-code + "," + 
                  STRING(term-obl.idnt) + "," +
                  STRING(term-obl.end-date) + "," + 
                  STRING(term-obl.nn).
         ob-cat = Get_QualityGar ("comm-rate", vSurr, DATE-rasp).

         /* индекс качества обеспечения по классификатору "КачествоОбесп"*/
         iob-cat  = DECIMAL(GetCode("КачествоОбесп", ob-cat )).

         IF (ob-cat NE "") AND (ob-cat NE "?") THEN LEAVE.
      END.

      IF ob-cat EQ "" THEN 
         MESSAGE "Не найдено обеспечение для договора " + loannum
            VIEW-AS ALERT-BOX.
      END.

   IF ((acct_main_pos_rur GT obesp) AND (ABS(ROUND((acct_main_pos_rur - obesp) * prrisk / 100, 2) - acct_rsrv_calc_pos) GE 0.05)) OR
      ((acct_main_pos_rur LE obesp) AND (acct_rsrv_calc_pos NE 0))
   THEN DO:
      MESSAGE "Неправильный расчет для договора " + loannum
         skip "Obesp = " STRING(obesp)
         skip "d.b.  = " STRING(CurrRound(acct_main_pos_rur - (acct_rsrv_calc_pos * 100 / prrisk), ""))
         VIEW-AS ALERT-BOX.
      obesp = CurrRound(acct_main_pos_rur - (acct_rsrv_calc_pos * 100 / prrisk), "").
   END.
   IF iob-cat NE 0 THEN
      obesp = obesp / (iob-cat / 100).
   END.

  END.



/* Основное тело таблицы */
oTable:addRow().
oTable:addCell(acct_main_no + client_name + loaninf).
oTable:addCell(acct_main_pos).
oTable:addCell(acct_main_cur).
oTable:addCell(acct_main_pos_rur).
oTable:addCell(grrisk).
oTable:addCell(prrisk).
oTable:addCell(obesp).
oTable:addCell(ob-cat).
oTable:addCell(acct_rsrv_calc_pos).
oTable:addCell(acct_rsrv_real_pos).
oTable:addCell(amt_create).
oTable:addCell(amt_delete).

oTable:addCell(oDoc:acct-db).
oTable:addCell(oDoc:acct-cr).

DELETE OBJECT oDoc.


END.


/* Итого */
oTable:addRow().
oTable:addCell("ИТОГО:").
oTable:addCell(total_pos_rur).
oTable:addCell("810").
oTable:addCell(total_pos).
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell(total_calc_rsrv).
oTable:addCell(total_real_rsrv).
oTable:addCell(total_create_rsrv).
oTable:addCell(total_delete_rsrv).
oTable:addCell("").
oTable:addCell("").


oTable:addRow().
oTable:addCell("").
oTable:addCell(total_pos_usd).
oTable:addCell("840").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").

oTable:addRow().
oTable:addCell("").
oTable:addCell(total_pos_eur).
oTable:addCell("978").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").

oTable:setBorder(1,oTable:height,1,0,1,1).
oTable:setBorder(1,oTable:height - 1,1,0,1,1).
oTable:setAlign(1,oTable:height - 2,"center").

oTpl:addAnchorValue("TABLE",oTable).
oTpl:addAnchorValue("date-rasp",date-rasp).

{setdest.i &cols=220} /* Вывод в preview */
	oTpl:show().
{preview.i}
DELETE OBJECT oTpl.

{send2arch.i}

/* ========================================================== */
FUNCTION LnPrincipal2 RETURNS DECIMAL (INPUT iContract AS CHAR,
                                       INPUT iContCode AS CHAR,
                                       INPUT iDate     AS DATE,
                                       INPUT iCurrency AS CHAR,
                                       INPUT CC        AS CHAR).
   DEFINE BUFFER b-loan FOR loan.

   DEF VAR mLoanCurr  AS CHAR NO-UNDO. /* тры■Єр фюуютюЁр */
   DEF VAR vParamSumm AS DEC  NO-UNDO.
   DEF VAR vDb        AS DEC  NO-UNDO.
   DEF VAR vCr        AS DEC  NO-UNDO.
   DEF VAR vRes       AS DEC  NO-UNDO.
   DEF VAR mResult    AS DEC  NO-UNDO.

   RUN RE_B_LOAN IN h_Loan (iContract,iContCode,BUFFER b-loan).

   IF b-loan.cont-type <> "Течение"
   THEN DO:
      IF CC = "КредРез"
      THEN DO:
         RUN RE_PARAM IN h_Loan ( 0, iDate, iContract, iContCode, OUTPUT vRes, OUTPUT vDb, OUTPUT vCr).
         RUN RE_PARAM IN h_Loan (13, iDate, iContract, iContCode, OUTPUT vParamSumm, OUTPUT vDb, OUTPUT vCr).
         vRes = vRes + vParamSumm.
      END.
      ELSE
         RUN RE_PARAM IN h_Loan ( 7, iDate, iContract, iContCode, OUTPUT vRes, OUTPUT vDb, OUTPUT vCr).

      IF b-loan.Currency <> iCurrency
         THEN vRes = CurToCurWork("Учетный", b-loan.currency, iCurrency, iDate, vRes).
   END.

   ELSE DO:
      vRes = 0.
      FOR EACH b-loan WHERE
               b-loan.contract = iContract
           AND b-loan.cont-code BEGINS iContCode
           AND NUM-ENTRIES(b-loan.cont-code, " ") = 2
           AND ENTRY(1, b-loan.cont-code, " ")    = iContCode
           AND b-loan.open-date <= iDate
         NO-LOCK:

         IF b-loan.close-date <> ? AND
            b-loan.close-date <= iDate
         THEN
            NEXT.

         vRes = vRes +  LnPrincipal2(b-loan.contract, b-loan.cont-code, iDate, iCurrency, CC).
      END. /*FOR EACH*/
   END.

   mResult = CurrRound(vRes,iCurrency).

   RETURN mResult.

END FUNCTION.
