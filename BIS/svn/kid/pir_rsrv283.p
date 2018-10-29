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
{intrface.get comm}     /* Инструменты для работы с комиссиями */
{intrface.get xclass}   /* Функции работы с метасхемой */
{intrface.get count}

{tmprecid.def}

/** ОПРЕДЕЛЕНИЯ **/
/* ============================================== */
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
DEF VAR o2          AS DECIMAL   NO-UNDO.
DEF VAR ob-cat      AS CHARACTER NO-UNDO.
DEF VAR iob-cat     AS DECIMAL   NO-UNDO.
DEF VAR loannum     AS CHARACTER NO-UNDO.
DEF VAR dLoanDate   AS CHARACTER NO-UNDO.
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

DEF VAR traceOn   AS LOGICAL INITIAL false NO-UNDO. /* Вывод ошибок на экран */
DEF VAR tmpStr    AS CHARACTER NO-UNDO. /* Временная для работы */
DEF VAR PIRbos    AS CHARACTER NO-UNDO. /* Должности и подписи */
DEF VAR PIRbosFIO AS CHARACTER NO-UNDO.
DEF VAR userPost  AS CHARACTER NO-UNDO.

DEF BUFFER bfrLA FOR loan-acct.
DEF VAR DATE-rasp AS DATE. /* Дата распоряжения */

/** Проверка входящего параметра */
IF NUM-ENTRIES(inParam) <> 2 
THEN DO:
   MESSAGE "Недостаточное кол-во параметров. Должно быть <норм_документ>,<код_руководителя_из_
PIRBoss>" 
      VIEW-AS ALERT-BOX.
   RETURN.
END.


/** РЕАЛИЗАЦИЯ **/

/* Определяем дату распоряжения */
DATE-rasp = gend-date.

DEF VAR oDoc   AS TDocument    NO-UNDO.
DEF VAR oTable AS TTable       NO-UNDO.
DEF VAR oTpl AS TTpl 	       NO-UNDO.


oTpl = new TTpl("pir_rsrv283.tpl").

oTable = new TTable(16).

/* Отображаем содержимое preview */

&IF DEFINED(arch2)<>0 &THEN
{pir-out2arch.i}
 curr-user-inspector = FGetSetting("PirEArch","RepInspCredit",?). /* #3718 */
&ENDIF


/* Для всех документов, выбранных в брoузере выполняем... */
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
         acct_rsrv =  oDoc:acct-db
         amt_delete = oDoc:sum
      .
   IF oDoc:acct-cr BEGINS "4" THEN
      ASSIGN
         acct_rsrv = oDoc:acct-cr
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
   loannum = oDoc:getLnkLoanNum().   
   IF NOT {assigned client_name} THEN client_name = GetLoanInfo_ULL("Кредит",loannum, "client_short_name", false).
   loaninf = getMainLoanAttr("Кредит",loannum,"Договор № %cont-code от %ДатаСогл").

/* добавлено по заявке #4203, ТЗ Бажиновой */
IF getMainLoanAttr("Кредит",loannum,"%cont-type") = "Гарантии" THEN DO:
	RUN ReqAcctByRole in h_loan ("Кредит",
			     loannum,
			     "КредВГар",
			     "o",
			     "PlAcct302",
			      DATE-rasp,
			      FALSE,
			      OUTPUT acct_main_no).
END.
/* окончание #4203 */

ELSE DO:

RUN ReqAcctByRole in h_loan ("Кредит",
			     loannum,
			     IF CAN-DO("Возоб*",getMainLoanAttr("Кредит",loannum,"%Режим")) THEN "КредН" ELSE "КредЛин",
			     "o",
			     "PlAcct302",
			      DATE-rasp,
			      FALSE,
			      OUTPUT acct_main_no).

END.

   /* Найдем остаток по внебалансовому счету на дату */
   acct_main_cur = getMainLoanAttr("Кредит",loannum,"%currency").

   acct_main_pos = ABS(GetAcctPosValue_UAL(acct_main_no, acct_main_cur, oDoc:op-date, traceOn)).
   acct_main_pos_rur = CurToCur ("УЧЕТНЫЙ", acct_main_cur, "", DATE-rasp, acct_main_pos).

   /* Найдем расчетный резерв. На самом деле, на момент выполнения процедуры это фактически уже 
      сформированный резерв */
   acct_rsrv_calc_pos = ABS(GetAcctPosValue_UAL(acct_rsrv, "810", oDoc:op-date, traceOn)).

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
      total_calc_rsrv   = total_calc_rsrv   + acct_rsrv_calc_pos
      total_real_rsrv   = total_real_rsrv   + acct_rsrv_real_pos
      total_create_rsrv = total_create_rsrv + amt_create
      total_delete_rsrv = total_delete_rsrv + amt_delete
   .

   /* Определим процентную ставку и группу риска */
   prrisk = GetCommRate_ULL("%Рез", (if acct_main_cur = "810" then "" else acct_main_cur), 0, acct_main_no, 0, DATE-rasp, false) * 100.
   grrisk = LnGetGrRiska(prrisk, DATE-rasp).

   /* Определим Обеспечение */
   RUN LnCollateralValueEx("Кредит", loannum, DATE-rasp, ?, "", OUTPUT o2, OUTPUT obesp).

   ob-cat  = "".
   iob-cat = 0.

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
         skip STRING(obesp)
         VIEW-AS ALERT-BOX.
      obesp = CurrRound(acct_main_pos_rur - (acct_rsrv_calc_pos * 100 / prrisk), "").
   END.

   IF iob-cat NE 0 THEN
      obesp = obesp / (iob-cat / 100).

/* Основное тело таблицы */
oTable:addRow().
oTable:addCell(acct_main_no + " " +  client_name + " " + loaninf).
oTable:addCell(acct_main_pos).
oTable:addCell(acct_main_cur).
oTable:addCell(acct_main_pos_rur).
oTable:addCell(grrisk).
oTable:addCell(prrisk).
oTable:addCell(ROUND(obesp,2)).
oTable:addCell(ob-cat).
oTable:addCell(acct_rsrv_calc_pos).
oTable:addCell(acct_rsrv_real_pos).
oTable:addCell(amt_create).
oTable:addCell(amt_delete).

oTable:addCell(oDoc:acct-db).
oTable:addCell(oDoc:acct-cr).


DELETE OBJECT oDoc.
END. /* Конец по tmprecid */

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


oTpl:addAnchorValue("TABLE1",oTable).
oTpl:addAnchorValue("PIRbos",PIRbos).
oTpl:addAnchorValue("PIRbosFIO",PIRbosFIO).
oTpl:addAnchorValue("date-rasp",DATE-rasp).
{tpl.show}
{tpl.delete}

{send2arch.i}

