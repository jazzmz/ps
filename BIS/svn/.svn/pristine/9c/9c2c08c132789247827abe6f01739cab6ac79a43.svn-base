{pirsavelog.p}

/*
               Банковская интегрированная система БИСквит
    Copyright: (C) MCMXCII-MCMXCIX ТОО "Банковские информационные системы"
     Filename: DblEnGut.P
      Comment: Двойной ввод - переделан из DoublEn2.P для Гуты
   Parameters: -
         Uses: Globals.I GetSt2Dt.IGu WClass.I Get-Fmt.I Out-Fmt.I
      Used by: BQ
      Created:
     Modified: 31/03/1999 11:46 Dima
     Modified: 02/11/2001 NIK Заявка 0004030
     Modified: Kuntash была доработана в 2005 году незнаю где, но знаю что нужна
*/
DEF INPUT PARAM in-op-date LIKE op.op-date         NO-UNDO.
DEF INPUT PARAM oprid      AS   RECID              NO-UNDO.
DEFINE VARIABLE vUndo      AS   LOGICAL INIT YES   NO-UNDO.


def buffer bfrop for op.
def buffer bfrop-entry for op-entry.
def buffer bfrop-bank for op-bank.
def var temp-vcorr-acct LIKE op-bank.corr-acct NO-UNDO.
def var bbanks as logical no-undo.



{globals.i}
{getst2dt.igu}
{wclass.i}
{get-fmt.i &obj=B-Acct-Fmt}

{chktempl.i}                           /* доступ к транзакции и шаблону       */


/*используется для подсчета кол-ва проверенных документов*/
&SCOP Qu OPEN QUERY q PRESELECT                                                ~
            EACH op  WHERE op.op-date   EQ in-op-date                          ~
                       AND op.op-status EQ xop-status                          ~
                       AND CAN-DO(op-template.doc-type,op.doc-type)            ~
                       AND CAN-DO(xuser,op.user-id) NO-LOCK,                   ~
            FIRST bftdoc OUTER-JOIN                                            ~
                     WHERE bftdoc.oprec   EQ RECID(op)                         ~
                       AND bftdoc.checked               NO-LOCK,               ~
            FIRST op-entry OF op                                               ~
                     WHERE AVAIL bftdoc                                        ~
            NO-LOCK,                                                           ~
            FIRST op-bank OUTER-JOIN OF op NO-LOCK.             

/*используется для подсчета кол-ва не проверенных документов*/
&SCOP Qu1 OPEN QUERY q PRESELECT                                               ~
            EACH op  WHERE op.op-date   EQ in-op-date                          ~
                       AND op.op-status EQ xop-status                          ~
                       AND CAN-DO(op-template.doc-type,op.doc-type)            ~
                       AND CAN-DO(xuser,op.user-id) NO-LOCK,                   ~
            FIRST bftdoc OUTER-JOIN                                            ~
                     WHERE bftdoc.oprec   EQ RECID(op)                         ~
                       AND bftdoc.checked               NO-LOCK,               ~
            FIRST op-entry OF op                                               ~
                     WHERE NOT AVAIL bftdoc                                    ~
            NO-LOCK,                                                           ~
            FIRST op-bank OUTER-JOIN OF op NO-LOCK.             

/*Используется для поиска документа в базе по соответствующим реквизитам */
&SCOP Qu2 OPEN QUERY q PRESELECT                                               ~
            EACH op WHERE op.op-date    EQ in-op-date                          ~
                      AND op.op-status  EQ xop-status                          ~
                      AND (op.doc-num   EQ vdoc-num   OR NOT enter-docnum)     ~
                      AND (op.ben-acct  EQ vben-acct  OR NOT enter-polacct)    ~
                      AND (op.order-pay EQ vorder-pay OR NOT enter-orderpay)   ~
                      AND CAN-DO(op-template.doc-type,op.doc-type)             ~
                      AND CAN-DO(xuser,op.user-id)                             ~
                  NO-LOCK,                                                        ~
            FIRST bftdoc OUTER-JOIN                                               ~
                    WHERE bftdoc.oprec   EQ RECID(op)                             ~
                      AND bftdoc.checked               NO-LOCK,                   ~
            FIRST op-entry OF op                                                  ~
                    WHERE (op-entry.amt-rub EQ vamt-rub OR NOT enter-summa)       ~
                      AND (op-entry.acct-db EQ vacct-db OR NOT enter-platacct)    ~
                      AND NOT AVAIL bftdoc                                        ~
                  NO-LOCK,                                                        ~
            FIRST op-bank  OF op                                                  ~
                    WHERE (STRING(INT(op-bank.bank-code),"999999999") EQ          ~
                           STRING(INT(vbank-code),"999999999") OR NOT enter-bic)  ~
                      AND (op-bank.corr-acct EQ vcorr-acct OR NOT enter-corracct) ~
                  NO-LOCK.

DEF VAR fl AS LOG NO-UNDO.

DEF VAR vdoc-num       LIKE op.doc-num        NO-UNDO.
DEF VAR vorder-pay     LIKE op.order-pay      NO-UNDO.
DEF VAR vacct-db       LIKE op-entry.acct-db  NO-UNDO.
DEF VAR vben-acct      LIKE op.ben-acct       NO-UNDO.
DEF VAR vamt-rub       LIKE op-entry.amt-rub  NO-UNDO.
DEF VAR vbank-code     LIKE op-bank.bank-code NO-UNDO.
DEF VAR vcorr-acct     LIKE op-bank.corr-acct NO-UNDO.
DEF VAR hdbut          AS WIDGET-HANDLE       NO-UNDO.
DEF VAR level          AS INT INITIAL 4       NO-UNDO.
DEF VAR nmcingd        AS INT                 NO-UNDO.
DEF VAR nmcedd         AS INT                 NO-UNDO.
DEF VAR smcingd        LIKE acct-pos.balance  NO-UNDO.
DEF VAR smcedd         LIKE acct-pos.balance  NO-UNDO.

DEF VAR enter-bic      AS LOG INIT YES        NO-UNDO.
DEF VAR enter-docnum   AS LOG INIT YES        NO-UNDO.
DEF VAR enter-orderpay AS LOG INIT YES        NO-UNDO.
DEF VAR enter-platacct AS LOG INIT YES        NO-UNDO.
DEF VAR enter-corracct AS LOG INIT YES        NO-UNDO.
DEF VAR enter-polacct  AS LOG INIT YES        NO-UNDO.
DEF VAR enter-summa    AS LOG INIT YES        NO-UNDO.
DEF VAR nn             AS int                 NO-UNDO.

DEF VAR input-proc     AS CHAR INIT ?         NO-UNDO.
DEF TEMP-TABLE tdoc
   FIELD checked    AS LOG FORM "Проверен/"
   FIELD oprec      AS RECID
   FIELD nn         AS INT
   FIELD doc-num    LIKE op.doc-num
   FIELD acct-db    LIKE op-entry.acct-db
   FIELD ben-acct   LIKE op.ben-acct
   FIELD amt-rub    LIKE op-entry.amt-rub
   FIELD bank-code  LIKE op-bank.bank-code
   FIELD corr-acct  LIKE op-bank.corr-acct
   FIELD order-pay  LIKE op.order-pay
   INDEX nn nn DESCENDING
.

DEFINE BUFFER bftdoc FOR tdoc.

DEF BUFFER sop-en FOR op-entry.

DEFINE QUERY q  FOR op, 
                    bftdoc, 
                    op-entry, 
                    op-bank 
       SCROLLING.

DEFINE QUERY tq FOR tdoc SCROLLING.

DEFINE BROWSE b QUERY tq
  DISPLAY
    tdoc.checked                             COLUMN-LABEL "√"
    tdoc.doc-num                             COLUMN-LABEL 'NN ДОК'
    tdoc.acct-db  FORMAT "x(20)"             COLUMN-LABEL 'СЧЕТ ПЛАТЕЛЬЩИКА'
    tdoc.ben-acct FORMAT "x(20)"             COLUMN-LABEL 'СЧЕТ ПОЛУЧАТЕЛЯ'
    tdoc.amt-rub  FORMAT ">>>>>>>>>>>>.99"
  WITH 5 DOWN WIDTH 78 TITLE COLOR bright-white "[ ДОКУМЕНТЫ ]".

DEF BUTTON btn LABEL "Сменить статус".

FUNCTION getsum RETURN DEC:
   DEF VAR aent AS DEC NO-UNDO.

   GET FIRST q NO-LOCK.
   DO WHILE AVAILABLE(op-entry):
      aent = aent + op-entry.amt-rub.
      GET NEXT q NO-LOCK.
   END.
   RETURN aent.
END FUNCTION.

/*-----------------------------------------------------------------------------------------------*/
IF input-proc NE ? THEN DO:
   IF SEARCH(input-proc + '.p') EQ ?  AND
      SEARCH(input-proc + '.r') EQ ? THEN
      MESSAGE COLOR MESSAGES                                        SKIP
              "Не найдена процедура доввода [" + input-proc + ".p]" SKIP
              VIEW-AS ALERT-BOX ERROR.
END.

DEF FRAME f
 "Кол-во проверяемых документов: " nmcingd " на сумму:" smcingd SKIP
 "Кол-во проверенных документов: " nmcedd  " на сумму:" smcedd  SKIP
 "┌────────────────────────────[ ПОЛЯ ДЛЯ ВВОДА ]──────────────────────────────┐" SKIP
 "│ NN ДОК    СУММА                СЧЕТ ПЛАТЕЛЬЩИКА                            │" SKIP
 "│ ------    ---------------      --------------------                        │" SKIP
 "│"  vdoc-num
      vamt-rub AT COL 13 ROW 6 FORMAT ">>>>>>>>>>>>.99"
      vacct-db AT COL 34 ROW 6 FORMAT "x(20)"                                 "│" TO 78 SKIP
 "│ КОД БАНКА КОРСЧЕТ              СЧЕТ ПОЛУЧАТЕЛЯ      ОЧЕРЕДНОСТЬ            │" SKIP
 "│ --------- -------------------- -------------------- -----------            │" SKIP
 "│"   vbank-code FORMAT "x(9)"
       vcorr-acct FORMAT "x(20)"
       vben-acct  FORMAT "x(20)"
       vorder-pay                                                             "│" TO 78 SKIP
 "└────────────────────────────────────────────────────────────────────────────┘" SKIP
 b
WITH OVERLAY CENTERED NO-LABELS
     TITLE COLOR bright-white "[ ПОВТОРНЫЙ ВВОД ]".

/* hdbut = btn:handle.
 */

ON f1 OF b IN FRAME f DO:
  RUN    view-op.
  RETURN NO-APPLY.
END.

ON LEAVE OF vdoc-num IN FRAME f DO:
   if LASTKEY <> KEYCODE("ESC") and LASTKEY <> 509  then do: /*509 - SHIFT + TAB */
      find first bfrop where bfrop.op-date = in-op-date and bfrop.doc-num = (INPUT vdoc-num) AND CAN-DO(xuser,bfrop.user-id) AND bfrop.op-status  EQ xop-status NO-LOCK NO-ERROR.
      if not avail bfrop then 
   	   do: 
  	      message "Документ с номером: " (INPUT vdoc-num) " не найден!"  VIEW-As ALERT-BOX.
                    RETURN NO-APPLY.
           end.
   end.
END.
                         
ON LEAVE OF vamt-rub IN FRAME f DO:
   if LASTKEY <> KEYCODE("ESC") and LASTKEY <> 509  then do:
      find first bfrop-entry where bfrop-entry.op-date = in-op-date and bfrop-entry.amt-rub = (INPUT vamt-rub) AND CAN-DO(xuser,bfrop-entry.user-id) AND bfrop-entry.op-status  EQ xop-status NO-LOCK NO-ERROR.
      if not avail bfrop-entry then
   	do:
   	   message "Документ на сумму: " (INPUT vamt-rub) " не найден!"  VIEW-As ALERT-BOX.
            RETURN NO-APPLY.
        end.
   end.
END.

ON LEAVE OF vacct-db IN FRAME f DO:
   if LASTKEY <> KEYCODE("ESC") and LASTKEY <> 509  then do:

   find first bfrop-entry where bfrop-entry.op-date = in-op-date and bfrop-entry.acct-db = (INPUT vacct-db) AND CAN-DO(xuser,bfrop-entry.user-id) AND bfrop-entry.op-status  EQ xop-status NO-LOCK NO-ERROR.
   if not avail bfrop-entry then 
      do:
	message "Документ по счету: " (INPUT vacct-db) " не найден!"  VIEW-As ALERT-BOX.
            RETURN NO-APPLY.
      end.
    end.
END.

ON LEAVE OF vbank-code IN FRAME f DO:
    if LASTKEY <> KEYCODE("ESC") and LASTKEY <> 509  then do:  

             bBanks = false.

	     for each bfrop where bfrop.op-date = in-op-date             
			      and bfrop.doc-num = (INPUT vdoc-num)       
			      AND CAN-DO(xuser,bfrop.user-id)             
			      AND bfrop.op-status EQ xop-status NO-LOCK,
             first bfrop-entry where bfrop-entry.op = bfrop.op
				 and bfrop-entry.op-date = in-op-date 
			         and bfrop-entry.amt-rub = (INPUT vamt-rub)
			         AND CAN-DO(xuser,bfrop-entry.user-id) 
				 AND bfrop-entry.op-status  EQ xop-status NO-LOCK,
	     first bfrop-bank where bfrop-bank.op = bfrop.op and bfrop-bank.bank-code = INPUT vbank-code NO-LOCK:
	        bBanks = true.
	     end.

   if not bBanks then 
	do:
	   Message "Не найден документ с кодом банка " INPUT vbank-code  VIEW-AS ALERT-BOX.
	   RETURN NO-APPLY.
        end.

   find first banks-code where banks-code.bank-code = INPUT vbank-code and banks-code.bank-code-type = "МФО-9" NO-LOCK NO-ERROR.
  
    if available (banks-code) then do:
        find first banks where banks.bank-id = banks-code.bank-id NO-LOCK NO-ERROR.
          if banks.bank-type = "ОТЗВ" then 
          do:
             Message "У БАНКА С БИК:" banks-code.bank-code "ОТОЗВАННА ЛИЦЕНЗИЯ! ПРОВЕРЬТЕ!" VIEW-AS ALERT-BOX.
	     vbank-code = "".
          end.
   END. /*if available (banks-code)*/

	     vcorr-acct = "".

                


	     IF NOT enter-corracct THEN DO:
	        RUN get-corr-acct(INPUT INPUT vbank-code).
	        DISPLAY vcorr-acct WITH FRAME f.
	     END.
  end.                              
END.

ON LEAVE OF vcorr-acct IN FRAME f DO:       /*Когда выходим из поля vcorr-acct*/

     if LASTKEY <> KEYCODE("ESC") and LASTKEY <> 509  then do:
	     for each bfrop where bfrop.op-date = in-op-date              /*т.к. фактически мы работаем со множеством проводок,*/ 
			      and bfrop.doc-num = (INPUT vdoc-num)        /*по крайней мере практически также сделано при подтверждении*/
			      AND CAN-DO(xuser,bfrop.user-id)             /*документа в преселектзапросе Qu2, решение конечно не красивое, но другого не придумал */
			      AND bfrop.op-status EQ xop-status NO-LOCK,
             first bfrop-entry where bfrop-entry.op = bfrop.op
				 and bfrop-entry.op-date = in-op-date 
			         and bfrop-entry.amt-rub = (INPUT vamt-rub)
			         AND CAN-DO(xuser,bfrop-entry.user-id) 
				 AND bfrop-entry.op-status  EQ xop-status NO-LOCK,
	     first bfrop-bank of bfrop NO-LOCK:
	     /*нашли документ-проводку-банковскиереквизиты*/
            	        bBanks = true.

	        RUN get-corr-acct(INPUT INPUT vbank-code).                                                  	
	        if    (vcorr-acct <> INPUT vcorr-acct) and bbanks then                  /*коррсчет из справочника <> тому что вводим*/
			do:
	                    MESSAGE COLOR WHITE/RED "Коррсчет не соответствует справочнику банков"  VIEW-AS ALERT-BOX TITLE "[ОШИБКА #1020]".
			     vcorr-acct = "".
                             vbank-code = "".
			     Display vcorr-acct vbank-code WITH FRAME f.
				 bbanks = false.
			end.

	   	if (INPUT vcorr-acct <> bfrop-bank.corr-acct) and bbanks then        /*то что вводим <> Тому что в банковсих реквизитах*/	
	   	        do:
	                    MESSAGE COLOR WHITE/RED "Коррсчет не соответствует банковским реквизитам документа"  VIEW-AS ALERT-BOX TITLE "[ОШИБКА #1020]".
			     vcorr-acct = "".
                             vbank-code = "".
			     bbanks = false.
			     Display vcorr-acct vbank-code WITH FRAME f.
			end.

	   	if (vcorr-acct <> bfrop-bank.corr-acct) and bbanks then 
		       do:         
	                    MESSAGE COLOR WHITE/RED "Коррсчет в банковских реквизитах документа не соответствует данным из справочника банков"  VIEW-AS ALERT-BOX TITLE "[ОШИБКА #1020]".
			     vcorr-acct = "".
                             vbank-code = "".
			     bbanks = false.
			     Display vcorr-acct vbank-code WITH FRAME f.
		       end.
	

	           
             end.
    end.
END.

ON LEAVE OF vben-acct IN FRAME f DO:
   if LASTKEY <> KEYCODE("ESC") and LASTKEY <> 509  then do:
   find first bfrop where bfrop.op-date = in-op-date and bfrop.ben-acct = (INPUT vben-acct) AND CAN-DO(xuser,bfrop.user-id) AND bfrop.op-status  EQ xop-status NO-LOCK NO-ERROR.
   if not avail bfrop then
      do:
	 message "Документ со счетом получателя: " (INPUT vben-acct) " не найден!"  VIEW-As ALERT-BOX.
            RETURN NO-APPLY.
      end.
    end.
END.



ON END-ERROR OF FRAME f
DO:
   IF CAN-FIND(FIRST tdoc   WHERE tdoc.checked) THEN DO:
      MESSAGE "Изменить статус по проверенным документам?"
      VIEW-AS ALERT-BOX QUESTION
      BUTTONS YES-NO SET choice AS LOGICAL.
      IF choice NE YES THEN vUndo = YES.
      ELSE DO:
         RUN XchngStatusOp.
         vUndo = NO.
      END.
   END.
   APPLY "END-ERROR".
END.

ON GO OF FRAME f DO:
   RUN end-accept.

   IF nmcingd EQ 0 THEN DO:
      MESSAGE "Все документы сверены успешно" skip
              "Завершить обработку ?"         skip
      VIEW-AS ALERT-BOX QUESTION
      BUTTONS YES-NO SET choice AS LOGICAL.
   
      IF choice NE YES THEN RETURN NO-APPLY.
      RUN XchngStatusOp.
      vUndo = NO.
      APPLY "END-ERROR".
   END.
   RETURN NO-APPLY.
END.

CHECK-DOCS:    
DO TRANSACTION ON ERROR  UNDO CHECK-DOCS, LEAVE CHECK-DOCS
               ON ENDKEY UNDO CHECK-DOCS, LEAVE CHECK-DOCS:

    RUN get-set.
    RUN get-state.

    ENABLE all except nmcingd smcingd nmcedd smcedd b with frame f.
    IF NOT enter-bic      THEN DISABLE vbank-code WITH FRAME f.
    IF NOT enter-docnum   THEN DISABLE vdoc-num   WITH FRAME f.
    IF NOT enter-platacct THEN DISABLE vacct-db   WITH FRAME f.
    IF NOT enter-polacct  THEN DISABLE vben-acct  WITH FRAME f.
    IF NOT enter-corracct THEN DISABLE vcorr-acct WITH FRAME f.
    IF NOT enter-summa    THEN DISABLE vamt-rub   WITH FRAME f.
    IF NOT enter-orderpay THEN DISABLE vorder-pay WITH FRAME f.

    WAIT-FOR END-ERROR OF FRAME f. /* focus b */ 
    HIDE FRAME f.
    IF vUndo THEN
    UNDO CHECK-DOCS, LEAVE CHECK-DOCS.
END. 

/*===============================================================================================*/
PROCEDURE get-state:
   OPEN QUERY tq FOR EACH tdoc.
   {&Qu1}
   GET FIRST q NO-LOCK .
   nmcingd = NUM-RESULTS("q").
   smcingd = getsum().
   {&Qu}
   GET FIRST q NO-LOCK .
   nmcedd = NUM-RESULTS("q").
   smcedd = getsum().
   DISPLAY nmcingd
           smcingd
           nmcedd
           smcedd
      WITH FRAME f.
END.

PROCEDURE get-set:
   {get_set2.i "ПовторныйВвод" "НачСтатус"} xop-status     = setting.val.
   {get_set2.i "ПовторныйВвод" "КонСтатус"} xop-status2    = setting.val.
   {get_set2.i "ПовторныйВвод" "InputProc"} input-proc     = setting.val.
   {get_set2.i "ПовторныйВвод" "BIC"}         enter-bic      = lookup(setting.val,'yes,да,true') <> 0.
   {get_set2.i "ПовторныйВвод" "DocNum"}      enter-docnum   = lookup(setting.val,'yes,да,true') <> 0.
   {get_set2.i "ПовторныйВвод" "PlatAcct"}    enter-platacct = lookup(setting.val,'yes,да,true') <> 0.
   {get_set2.i "ПовторныйВвод" "PolAcct"}     enter-polacct  = lookup(setting.val,'yes,да,true') <> 0.
   {get_set2.i "ПовторныйВвод" "CorrAcct"}    enter-corracct = lookup(setting.val,'yes,да,true') <> 0.
   {get_set2.i "ПовторныйВвод" "Summa"}       enter-summa    = lookup(setting.val,'yes,да,true') <> 0.
   {get_set2.i "ПовторныйВвод" "Очередность"} enter-orderpay = lookup(setting.val,'yes,да,true') <> 0.
END.

PROCEDURE view-op:
   proc-name = ?.
   proc-name = GET-CLASS-METHOD(op.class-code,"Browse").
   IF proc-name NE ? THEN DO:
      IF search(proc-name + ".p") <> ? OR search(proc-name + ".r") <> ?
      THEN RUN VALUE(proc-name + ".p") (op.op-date,op.user-id,op.op,level + 1).
      ELSE DO:
         MESSAGE "Не найдена процедура просмотра " + proc-name + ".p !"
         VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
      END.
   END.
   ELSE run op#.p (op.op-date,op.user-id,op.op,level + 1).
END.

PROCEDURE get-corr-acct:
   DEF INPUT PARAM in-bank-code AS CHAR NO-UNDO.
   {getbank.i banks  in-bank-code 'МФО-9'}
   IF AVAIL banks THEN DO:
      FIND FIRST banks-corr 
           WHERE banks-corr.bank-corr EQ banks.bank-id
             AND CAN-FIND (banks OF banks-corr WHERE banks.flag-rkc) 
      NO-LOCK NO-ERROR.
      IF AVAILABLE banks-corr THEN vcorr-acct = banks-corr.corr-acct.
   END.
END.


PROCEDURE end-accept:
   DEFINE VAR first-entry AS WIDGET-HANDLE.
   
   fl = NO.
   ASSIGN FRAME f
      vdoc-num
      vacct-db
      vbank-code
      vben-acct
      vamt-rub
      vcorr-acct
      vorder-pay
   .

   CREATE tdoc.
   ASSIGN
      tdoc.nn        = nn
      tdoc.doc-num   = vdoc-num
      tdoc.acct-db   = vacct-db
      tdoc.bank-code = vbank-code
      tdoc.ben-acct  = vben-acct
      tdoc.corr-acct = vcorr-acct
      tdoc.amt-rub   = vamt-rub
      tdoc.order-pay = vorder-pay
      nn             = nn + 1
   .

   {&Qu2}

   IF NUM-RESULTS("q") > 0 THEN
chg:
   DO TRANSACTION:
      GET FIRST q NO-LOCK.
      FIND CURRENT op EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
      IF AVAILABLE(op) THEN DO:
         ASSIGN
            tdoc.checked    = YES
            tdoc.oprec      = RECID(op)
         .
         IF input-proc NE ? THEN DO:
            RUN VALUE(input-proc + '.p') (RECID(op)).
            IF KEYFUNCTION(LASTKEY) EQ "end-error"
               THEN UNDO chg, LEAVE chg.
         END.
         ELSE DO:
            RUN view-op.
         END.
      END.
      ELSE IF LOCKED op THEN DO:
         BELL.
         MESSAGE "Этот документ редактируется другим пользователем!". PAUSE 2.
         fl = YES.
      END.
   END.

   RUN get-state.

   first-entry = vdoc-num:HANDLE.
   DO WHILE VALID-HANDLE(first-entry):
      IF first-entry:SENSITIVE THEN DO:
         APPLY "ENTRY" TO first-entry.
         LEAVE.
      END.
      first-entry = first-entry:NEXT-SIBLING.
   END.

   RETURN NO-APPLY.
END.

/* смену статуса надо делать в конце контроля документов */
PROCEDURE XchngStatusOp:
   DEFINE BUFFER buf_op-entry  FOR op-entry.
   DEFINE BUFFER buf_kau-entry FOR kau-entry.
   DEFINE BUFFER buf_op        FOR op.
   
   FOR EACH tdoc   WHERE tdoc.checked NO-LOCK,
       EACH buf_op WHERE RECID(buf_op) EQ tdoc.oprec 
   EXCLUSIVE-LOCK:  
      ASSIGN
         buf_op.op-status    = xop-status2
         buf_op.user-inspect = USERID('bisquit')
      .
      
      FOR EACH buf_op-entry OF buf_op EXCLUSIVE-LOCK:
         buf_op-entry.op-status = xop-status2.
         FOR EACH buf_kau-entry OF buf_op-entry EXCLUSIVE-LOCK:
            buf_kau-entry.op-status = xop-status2.
         END.
      END.
   END.
END PROCEDURE.
/******************************************************************************/
