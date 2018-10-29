/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-1998 ТОО "Банковские информационные системы"
     Filename: chdat(op.i
      Comment: изменение даты проводки
   Parameters:
         Uses:
      Used BY:
      Created:
     Modified: 16/03/99 Lera - добавлена возможность проверки корректности проводки в новом опердне
     Modified: 22.05.2003 19:31 KAVI     выделена обработка op.due-date
     Modified: 09.06.2003       NIK Контроль документа в целом
     Modified: 06.07.2004       abko  22734 перенос "документ от"
     Modified:


для документов которые были созданы с помощью транзакции для 
послеоперационного обслуживания сумма руб эквивалента не изменяется

Бурягин добавил коментарий 04.08.2006 15:06
Если проводка валютная, в корреспонденции проводки есть кассовые счета "20202", принадлежащие отделению "00002",
то рублевый эквивалент при переносе не пересчитывается. 

*/
DEF VAR cdate       AS DATE      NO-UNDO.
DEF VAR ctime       AS INT64   NO-UNDO.
DEF VAR cddif       AS LOGICAL   NO-UNDO.
DEF VAR gend-date-t AS DATE      NO-UNDO.

DEF VAR currDoc     AS TDocument NO-UNDO.

DEFINE TEMP-TABLE tt-op-entry 
   FIELD op-entry LIKE op-entry.op-entry
.

/** Бурягин добавил определение */
DEF VAR afterOperCash AS LOGICAL INITIAL FALSE.
DEF VAR minDate AS DATE. /* старая дата документа */
DEF VAR position AS DECIMAL.
DEF VAR redAlert AS LOGICAL.
DEF VAR course AS INTEGER. /* направление переноса: вперед = 1, надаз = -1 */
/** Бурягин end */

{intrface.get op}
{intrface.get kau}
{intrface.get xclass}

IF AVAIL op THEN DO:
   ASSIGN
      cdate = TODAY
      ctime = TIME
   .
   /* если меняется дата */
   IF cur-op-date NE op.op-date THEN 
      /** Бурягин добавил условие */
      IF cur-op-date GT op.op-date THEN course = 1. ELSE course = -1.
      ASSIGN
      minDate = MINIMUM(cur-op-date, op.op-date)
         op.op-date        = (IF mChOpDate
                                 THEN cur-op-date
                                 ELSE op.op-date)
         op.op-value-date  = (IF ChVDate
                                 THEN cur-op-date
                                 ELSE op.op-value-date)
         op.due-date       = (IF mChDDate
                                 THEN cur-op-date
                                 ELSE op.due-date)
         op.ins-date       = (IF ChIDate
                                 THEN cur-op-date
                                 ELSE op.ins-date)
         op.contract-date  = (IF mChContDate
                                 THEN cur-op-date
                                 ELSE op.contract-date)
         op.doc-date       = (IF mChDocDate
                                 THEN cur-op-date
                                 ELSE op.doc-date)
      .

   IF mChSpDate AND GetXattrValue("op",STRING(op.op),"СписСчета") NE STRING(cur-op-date) THEN 
      UpdateSigns("op",string(op.op),"СписСчета",STRING(cur-op-date),YES).

   cddif = NO.
   FIND FIRST op-entry OF op WHERE op-entry.acct-db EQ ? NO-LOCK NO-ERROR.
   IF AVAIL op-entry THEN
      cddif = YES.
   ELSE DO:
      FIND FIRST op-entry OF op WHERE op-entry.acct-cr EQ ? NO-LOCK NO-ERROR.
      IF AVAIL op-entry THEN cddif = YES.
   END.

   pick-value = "no".
   RUN RunClassMethod IN h_xclass (op.class-code,"chkupd","","",
                              ?,string(recid(op)) + ",date").
   IF NOT CAN-DO("no-method,no-proc",RETURN-VALUE) AND
      pick-value                         NE  "yes" THEN DO:
      {ifdef {&open-undo}} {&open-undo} {else} */ UNDO, RETRY  {endif} */ .
   END.
   {empty tt-op-entry}
   FOR EACH op-entry OF op NO-LOCK:   

/**********************
 * 
 * Запрещается переносить
 * валютные документы в другой день.
 *
 **********************
 * Автор: Маслов Д. А. Maslov D. A.
 * Заявка: #1535
 * Дата создания: 15.10.12
 **********************/

 /***********************************
  * Оказывает имели ввиду
  * только конверсионные операции.
  ***********************************
  *
  * Необходимо устанавливать pick-value 
  * в значение по-умолчанию YES.
  *
  ***********************************
  *
  * Автор : Маслов Д. А. Maslov D. A.
  * Заявка: #1605 
  * Дата создания: 24.10.12
  *
  ***********************************/

       IF LOGICAL(FGetSetting("PirChkOp","DenyMoveVal","YES")) THEN DO:

                currDoc = NEW TDocument(op-entry.op).

                IF currDoc:isExchange() AND NOT CAN-DO(FGetSetting("PirChkOp","PermMoveValUsers","!*"),currDoc:user-id) THEN DO:

                       MESSAGE COLOR WHITE/RED
                         "Запрещено переносить конверсионные документы!" SKIP
                         " Обратитесь к главному бухгалтеру!!!" SKIP
                         VIEW-AS ALERT-BOX
                         TITLE "Ошибка #1535".
                         pick-value = "NO".
                END. ELSE DO:
                         pick-value = "YES".
                END.

                DELETE OBJECT currDoc NO-ERROR.

                IF pick-value = "NO" THEN DO:
                     {ifdef {&open-undo}} {&open-undo} {else} */ UNDO, RETRY  {endif} */ .
                END.
       END.


/** Бурягин добавил поиски 04.08.2006 14:55 */
      afterOperCash = FALSE.
      IF op-entry.acct-db BEGINS "20202" THEN 
      	DO:
      		FIND FIRST acct WHERE acct.acct = op-entry.acct-db NO-LOCK NO-ERROR.
      	END.
      ELSE IF op-entry.acct-cr BEGINS "20202" THEN
      	DO:
      		FIND FIRST acct WHERE acct.acct = op-entry.acct-cr NO-LOCK NO-ERROR.
      	END.
      IF AVAIL acct THEN 
      	DO:
      		IF CAN-DO("00002", acct.branch-id) THEN
      			afterOperCash = TRUE. 
      	END.
      /** Бурягин end */

      IF NOT cddif                          AND
         mChOpDate                          AND 
         cur-op-date NE op-entry.value-date AND
         op-entry.amt-cur NE 0              AND
         op-entry.curr    GT ""             
	/** Кунташев добавил сравнение с транзакцией послопер обслуж  и вечерней*/
	 AND NOT CAN-DO("030202N*,030102P*,i-tag*",op.op-kind)     
	/** Бурягин добавил послеоперационное обслуживание 04.08.2006 15:04 */
	 AND NOT afterOperCash THEN DO:
         CREATE tt-op-entry.    
         ASSIGN
            tt-op-entry.op-entry = op-entry.op-entry
         .
      END.
   END.   


   FOR EACH op-entry OF op EXCLUSIVE-LOCK:   
      IF CAN-FIND(FIRST tt-op-entry WHERE tt-op-entry.op-entry EQ op-entry.op-entry)
      THEN DO:               
         ASSIGN
            op-entry.amt-rub    = CurToBase("УЧЕТНЫЙ",
                                            op-entry.currency,
                                            cur-op-date,
                                            op-entry.amt-cur).
            op-entry.value-date = cur-op-date
         .
      END.
      ASSIGN
         op-entry.op-date    = op.op-date
      .

      IF op-entry.op-date NE ? THEN
         ASSIGN
            gend-date-t = gend-date
            gend-date   = op-entry.op-date
         .

      RUN KauOpDel IN h_kau (RECID (op-entry)).
      IF pick-value = 'no' THEN DO:
         {ifdef {&del-undo}} {&del-undo} {else} */ UNDO, RETRY  {endif} */ .
      END.

      {op-entry.upd {&*}}                        /* тотальный контроль        */

      IF op-entry.op-date NE ? THEN              /* возвращаем дату как было */
         gend-date = gend-date-t.

   END.
   FOR EACH op-impexp OF op EXCLUSIVE-LOCK:
      ASSIGN
         op-impexp.exp-batch  = ""
         op-impexp.exp-date   = ?
         op-impexp.exp-time   = 0.
   END.

   UpdateSigns("op",string(op.op),"num-rkc","",NO).
END.
/******************************************************************************/
