{pirsavelog.p}

{globals.i}
DEFINE INPUT PARAMETER in-cont-code AS CHARACTER NO-UNDO.
&GLOB ACCT%          "702*,47411*"
&GLOB CODES-%        "НачПрС1,НачПрВ,НачПр,ПрПр"
&GLOB CODES-OST      "ОстВклВ,ОстВклС"
&GLOB LST-ACCT-TYPE  "loan-dps-p,loan-dps-t,loan-dps-int,loan-dps-exc,loan-dps-out"
DEFINE VAR work-status   AS CHARACTER INITIAL "П" NO-UNDO.

DEFINE VAR max-loan-acct AS INTEGER   NO-UNDO.
DEFINE VAR cur-loan-acct AS INTEGER   NO-UNDO.
DEFINE VAR action-name   AS CHARACTER NO-UNDO.
DEFINE VAR prol-date     AS DATE      NO-UNDO.

DEFINE BUFFER buf-loan-acct FOR loan-acct.

DEFINE NEW SHARED TEMP-TABLE prol-loan NO-UNDO
      FIELD cont-code AS CHARACTER
      FIELD op-date   AS DATE
.



{s3sgnop.lib}
{ksh-defs.i NEW}


DEFINE VAR summ-%        AS DECIMAL   NO-UNDO.
DEFINE VAR summ-ost      AS DECIMAL   NO-UNDO.
DEFINE VAR c-ost         AS CHARACTER NO-UNDO.
DEFINE VAR lst-cod       AS CHARACTER NO-UNDO.

DEFINE VAR i             AS INTEGER   NO-UNDO.
DEFINE VAR mess          AS CHARACTER NO-UNDO.



DEFINE VAR MESS-ID     AS INTEGER
                       INITIAL 0    NO-UNDO.

DEFINE TEMP-TABLE out-protocol   NO-UNDO
   FIELD id          AS INTEGER
   FIELD type        AS CHARACTER
   FIELD cont-code   AS CHARACTER
   FIELD acct-type   AS CHARACTER
   FIELD op-date     AS DATE
   FIELD doc-num     AS CHARACTER
   FIELD op-entry    AS INTEGER
   FIELD mess        AS CHARACTER
INDEX TYPE type
INDEX ID   IS UNIQUE ID.

PROCEDURE SAVE_PROTOCOL:
   DEFINE PARAMETER BUFFER buf-loan    FOR loan.
   DEFINE PARAMETER BUFFER buf-lnacct  FOR loan-acct.
   DEFINE PARAMETER BUFFER buf-op-date FOR op-date.
   DEFINE PARAMETER BUFFER buf-open    FOR op-entry.
   DEFINE PARAMETER BUFFER buf-op      FOR op.
   DEFINE INPUT PARAMETER in-type AS CHARACTER NO-UNDO.
   DEFINE INPUT PARAMETER in-text AS CHARACTER NO-UNDO.

   MESS-ID = MESS-ID + 1.
   CREATE out-protocol.
   ASSIGN
      out-protocol.id         = MESS-ID
      out-protocol.type       = in-type
      out-protocol.cont-code  = buf-loan.cont-code
      out-protocol.acct-type  = buf-lnacct.acct-type
      out-protocol.op-date    = op-date.op-date
      out-protocol.doc-num    = IF AVAIL buf-op THEN buf-op.doc-num
                                                ELSE ""
      out-protocol.op-entry   = IF AVAIL buf-open THEN buf-open.op-entry
                                                  ELSE ?
      out-protocol.mess       = in-text
   .
END PROCEDURE.

PROCEDURE CREATE_SGN_EXC:
   DEFINE PARAMETER BUFFER buf_op   FOR op.
   DEFINE PARAMETER BUFFER buf_loan FOR loan.

   IF NOT AVAIL buf_op THEN RETURN.
   IF NOT AVAIL buf_loan THEN RETURN.
   FIND signs WHERE signs.file      EQ "op"
                AND signs.code      EQ "Вклад"
                AND signs.surr      EQ STRING(buf_op.op)
                                  EXCLUSIVE-LOCK NO-ERROR.
   IF NOT AVAIL signs THEN
   CREATE signs.
   ASSIGN
      signs.file      =  "op"
      signs.code      =  "Вклад"
      signs.surr      =  STRING(buf_op.op)
      signs.code-val  =  buf_loan.cont-code
   .
END PROCEDURE.

FUNCTION GET-DATE-KM RETURNS DATE (INPUT in-date AS DATE):
   DEF VAR i AS INTEGER NO-UNDO.
   DO WHILE month(in-date) EQ month(in-date + i):
      i = i + 1.
   END.
   in-date = in-date + i - 1.
   RETURN in-date.
END FUNCTION.

FUNCTION count-ost RETURNS CHARACTER (BUFFER buf-loan-acct FOR loan-acct,
                                      INPUT in-date AS DATE):
   DEFINE VAR in-kau AS CHARACTER NO-UNDO.

   in-kau = IF buf-loan-acct.acct-type EQ "loan-dps-t" THEN
            (buf-loan-acct.contract + "," + buf-loan-acct.cont-code + ",ОстВклС")
            ELSE IF buf-loan-acct.acct-type EQ "loan-dps-p" THEN
            (buf-loan-acct.contract + "," + buf-loan-acct.cont-code + ",ОстВклВ")
            ELSE ?.
   IF in-kau EQ ? THEN RETURN "Не известная роль счета".
   RUN kau-pos.p (buf-loan-acct.acct,
                  buf-loan-acct.currency,
                  in-date,
                  in-date,
                  work-status,
                  in-kau).
   summ-ost = ABS(IF buf-loan-acct.currency EQ "" THEN ksh-bal
                                                  ELSE ksh-val).

   in-kau = IF buf-loan-acct.acct-type EQ "loan-dps-t" THEN
            (buf-loan-acct.contract + "," + buf-loan-acct.cont-code + ",НачПрС1")
            ELSE IF buf-loan-acct.acct-type EQ "loan-dps-p" THEN
            (buf-loan-acct.contract + "," + buf-loan-acct.cont-code + ",НачПрВ")
            ELSE ?.
   IF in-kau EQ ? THEN RETURN "Не известная роль счета".
   RUN kau-pos.p (buf-loan-acct.acct,
                  buf-loan-acct.currency,
                  in-date,
                  in-date,
                  work-status,
                  in-kau).
   summ-% = ABS(IF buf-loan-acct.currency EQ "" THEN ksh-bal
                                                ELSE ksh-val).
   RETURN "OK".
END FUNCTION.


FUNCTION Select-cod-ost RETURNS CHARACTER (BUFFER buf-open FOR op-entry,
                                           INPUT in-acct-type AS CHARACTER,
                                           INPUT in-currency  AS CHARACTER,
                                           INPUT db-cr        AS LOGICAL):

   DEFINE VAR entry-amt    AS DECIMAL NO-UNDO.
   DEFINE BUFFER b-entry   FOR op-entry.
   DEFINE VAR d-acct       LIKE acct.acct NO-UNDO.
   
   IF NOT db-cr AND buf-open.acct-db EQ ? THEN DO:
      FIND FIRST b-entry WHERE b-entry.op EQ buf-open.op AND
                               b-entry.acct-db NE ? AND
                               b-entry.acct-cr EQ ? 
                               NO-LOCK NO-ERROR.
      IF AVAIL b-entry THEN
         d-acct = b-entry.acct-db.
   END.
   ELSE
      d-acct = buf-open.acct-db.
   
   entry-amt = IF in-currency EQ "" THEN buf-open.amt-rub
                                    ELSE buf-open.amt-cur.
   IF entry-amt LE 0 THEN RETURN "Сумма документа меньше или равна 0".
   CASE in-acct-type:
      WHEN "loan-dps-exc" THEN
      ASSIGN
         c-ost    = "ПрПр"
         summ-%   = entry-amt
         summ-ost = 0
      .
      WHEN "loan-dps-int" THEN
      ASSIGN
         c-ost    = "НачПр"
         summ-%   = entry-amt
         summ-ost = 0
      .
      WHEN "loan-dps-t"   THEN DO:
         IF db-cr THEN DO:
            IF entry-amt GT summ-% THEN
              ASSIGN
                 summ-ost = entry-amt - summ-%
                 c-ost    = "НачПрС1,ОстВклС"
              .
            ELSE
              ASSIGN
                 summ-%   = entry-amt
                 summ-ost = 0
                 c-ost    = "НачПрС1"
              .
         END.
         ELSE DO:
            IF CAN-DO({&ACCT%},d-acct) AND buf-open.op-date NE prol-date THEN
            ASSIGN
               c-ost    = "НачПрС1"
               summ-%   = entry-amt
               summ-ost = 0
            .
            ELSE
            ASSIGN
               c-ost    = "ОстВклС"
               summ-%   = 0
               summ-ost = entry-amt
            .
         END.
      END.
      WHEN "loan-dps-p"   THEN DO:
         IF db-cr THEN DO:
            IF entry-amt GT summ-% THEN
              ASSIGN
                 summ-ost = entry-amt - summ-%
                 c-ost    = "НачПрВ,ОстВклВ"
              .
            ELSE
              ASSIGN
                 summ-%   = entry-amt
                 summ-ost = 0
                 c-ost    = "НачПрВ"
              .
         END.
         ELSE DO:
            IF CAN-DO({&ACCT%},d-acct) AND buf-open.op-date NE prol-date THEN
            ASSIGN
               c-ost    = "НачПрВ"
               summ-%   = entry-amt
               summ-ost = 0
            .
            ELSE
            ASSIGN
               c-ost = "ОстВклВ"
               summ-%   = 0
               summ-ost = entry-amt
            .
         END.
      END.
      WHEN "loan-dps-out"  THEN DO:
            ASSIGN
               summ-%   = entry-amt
               summ-ost = 0
               c-ost    = "НачПрС1"
           .
      END.
   END CASE.
   IF c-ost EQ "" OR c-ost EQ ? THEN RETURN "Не могу определить код остатка.".
   IF summ-%   EQ 0 AND summ-ost EQ 0 THEN RETURN "суб. остатки равны 0".
   IF summ-%   LT 0 THEN RETURN "Списывается сумма превышающая остаток %%".
   IF summ-ost LT 0 THEN RETURN "Списывается сумма превышающая остаток по вкладу".
   RETURN "OK".
END FUNCTION.

RUN delete_kau.
/*
message "КАУ удалено". pause.
*/
RUN s2n_pos.p(in-cont-code).


cur-loan-acct = 0.
action-name = "Привязка проводок:" + STRING(max-loan-acct).
{init-bar.i """ + action-name + ""}
LOOP_LOAN:
FOR EACH loan WHERE loan.contract  EQ "DPS"
                AND CAN-DO(in-cont-code,loan.cont-code) NO-LOCK,
    EACH loan-acct WHERE loan-acct.contract  EQ loan.contract
                     AND loan-acct.cont-code EQ loan.cont-code
                     AND CAN-DO({&LST-ACCT-TYPE},loan-acct.acct-type)
                                                        NO-LOCK:
    /* В случае,если счет причисления процентов совпадает 
       со счетом вклада, пропускаем */
    IF loan-acct.acct-type EQ "loan-dps-out" AND 
       CAN-FIND(      
                 FIRST buf-loan-acct WHERE
                       buf-loan-acct.acct-type EQ "loan-dps-t" AND
                       buf-loan-acct.contract  EQ  loan-acct.contract AND
                       buf-loan-acct.cont-code EQ  loan-acct.cont-code AND
                       buf-loan-acct.acct      EQ  loan-acct.acct NO-LOCK)
    THEN 
       NEXT.
         
   cur-loan-acct = cur-loan-acct + 1.
   {move-bar.i cur-loan-acct max-loan-acct}
   FOR EACH op-date WHERE op-date.op-date GE loan.open-date NO-LOCK:
      SGN_OP:
      DO TRANSACTION ON ERROR  UNDO sgn_op, NEXT  loop_loan
                     ON ENDKEY UNDO sgn_op, LEAVE loop_loan:
         /* Проводки постановки */
         ASSIGN
            summ-%   = 0
            summ-ost = 0
            c-ost    = ""
            lst-cod  = ""
         .
         FOR EACH op-entry WHERE op-entry.acct-cr   EQ loan-acct.acct
                             AND op-entry.op-date   EQ op-date.op-date
                             AND op-entry.op-status GT work-status
/*                             AND op-entry.currency  EQ loan-acct.currency
 */                                                             EXCLUSIVE-LOCK:
            FIND op OF op-entry EXCLUSIVE-LOCK NO-ERROR.

            FIND prol-loan WHERE prol-loan.cont-code EQ loan.cont-code
                                                      NO-LOCK NO-ERROR.
            IF AVAIL prol-loan THEN
            prol-date = prol-loan.op-date.
            ELSE
            prol-date = ?.

            IF op-entry.currency NE "" AND op-entry.amt-cur EQ 0 THEN NEXT.
            IF op-entry.kau-cr NE "" AND op-entry.kau-cr NE ? THEN NEXT.
            mess = Select-cod-ost(BUFFER op-entry,
                                  loan-acct.acct-type,
                                  loan-acct.currency,
                                  NO).
            IF mess NE "OK" THEN DO:
               RUN SAVE_PROTOCOL(BUFFER loan,
                                 BUFFER loan-acct,
                                 BUFFER op-date,
                                 BUFFER op-entry,
                                 BUFFER op,
                                 "E",
                                 mess).
               UNDO sgn_op, NEXT loop_loan.
            END.
            IF loan-acct.acct-type EQ "loan-dps-int" THEN
            op.contract-date = GET-DATE-KM(op-date.op-date).
            IF loan-acct.acct-type EQ "loan-dps-exc" THEN
            RUN CREATE_SGN_EXC(BUFFER op,BUFFER loan).
            DO i = 1 TO NUM-ENTRIES(c-ost):
               IF CAN-DO({&CODES-%},ENTRY(i,c-ost)) AND summ-% NE 0 THEN
               sgn-opent(BUFFER loan-acct,
                         BUFFER op-entry,
                         ENTRY(i,c-ost),
                         summ-%).
               ELSE IF CAN-DO({&CODES-OST},ENTRY(i,c-ost)) AND summ-ost NE 0 THEN
               sgn-opent(BUFFER loan-acct,
                         BUFFER op-entry,
                         ENTRY(i,c-ost),
                         summ-ost).
            END.
         END.
         /* Проводки списания */
/*
message " /* Проводки списания */" . pause.
*/         FOR EACH op-entry WHERE op-entry.acct-db   EQ loan-acct.acct
                             AND op-entry.op-date   EQ op-date.op-date
                             AND op-entry.op-status GT work-status
/*                             AND op-entry.currency  EQ loan-acct.currency
*/                                                              EXCLUSIVE-LOCK:
/*
message " 1 op-entry.currency op-entry.acct-db loan-acct.acct " op-entry.op-date op-entry.currency op-entry.acct-db loan-acct.acct op-entry.op-date . pause.
*/
            IF op-entry.currency NE "" AND op-entry.amt-cur EQ 0 THEN NEXT.
            IF op-entry.kau-db NE "" AND op-entry.kau-db NE ? THEN NEXT.
            FIND op OF op-entry NO-LOCK NO-ERROR.

            count-ost(BUFFER loan-acct,op-date.op-date).
            mess = Select-cod-ost(BUFFER op-entry,
                                  loan-acct.acct-type,
                                  loan-acct.currency,
                                  YES).
            {additem.i lst-cod c-ost}
            IF mess NE "OK" THEN DO:
               RUN SAVE_PROTOCOL(BUFFER loan,
                                 BUFFER loan-acct,
                                 BUFFER op-date,
                                 BUFFER op-entry,
                                 BUFFER op,
                                 "E",
                                 mess).
               UNDO sgn_op, NEXT loop_loan.
            END.
/*
message " 2 op-entry.currency op-entry.acct-db loan-acct.acct " op-entry.op-date op-entry.currency op-entry.acct-db loan-acct.acct op-entry.op-date . pause.
*/
            DO i = 1 TO NUM-ENTRIES(c-ost):
               IF CAN-DO({&CODES-%},ENTRY(i,c-ost)) AND summ-% NE 0  THEN
               sgn-opent(BUFFER loan-acct,
                         BUFFER op-entry,
                         ENTRY(i,c-ost),
                         summ-%).
               ELSE IF CAN-DO({&CODES-OST},ENTRY(i,c-ost)) AND summ-ost NE 0  THEN
               sgn-opent(BUFFER loan-acct,
                         BUFFER op-entry,
                         ENTRY(i,c-ost),
                         summ-ost).
            END.
         END.
      END.
      lst-cod = IF loan-acct.acct-type EQ "loan-dps-p" THEN "ОстВклВ,НачПрВ"
                ELSE IF loan-acct.acct-type EQ "loan-dps-t" THEN "ОстВклС,НачПрС1"
                ELSE IF loan-acct.acct-type EQ "loan-dps-int" THEN "НачПр"
                ELSE IF loan-acct.acct-type EQ "loan-dps-exc" THEN "ПрПр"
                ELSE "".
      DO i = 1 TO NUM-ENTRIES(lst-cod):
         rfrsh-pos(BUFFER loan-acct,
                   ENTRY(i,lst-cod),
                   op-date.op-date).
      END.
      /* Пересчет остатков на закрытый день */
/*      RUN SAVE_PROTOCOL(BUFFER loan,
                        BUFFER loan-acct,
                        BUFFER op-date,
                        BUFFER op-entry,
                        BUFFER op,
                        "I",
                        "Привязан").*/
   END.
END.

{del-bar.i}

{setdest.i}
FOR EACH out-protocol WHERE out-protocol.type BEGINS "E" NO-LOCK
                                BREAK BY out-protocol.cont-code
                                      BY out-protocol.id:
   DISPLAY
      out-protocol.type       FORMAT "x(4)"
                              LABEL  ""
      out-protocol.cont-code  FORMAT "x(25)"
                              WHEN FIRST-OF(out-protocol.cont-code)
                              LABEL  "N ВКЛАДА"
      out-protocol.acct-type  FORMAT "x(10)"
                              LABEL  "ТИП СЧЕТА"
      out-protocol.op-date    FORMAT "99/99/9999"
                              LABEL  "ДАТА"
      out-protocol.doc-num    FORMAT "x(10)"
                              LABEL  "N ДОК."
      out-protocol.op-entry   FORMAT ">9"
                              LABEL  ""
                              WHEN  out-protocol.op-entry NE ?
      out-protocol.mess       FORMAT "x(30)"
                              LABEL  "ПРИМЕЧАНИЕ"
   WITH FRAME PROTOCOL DOWN WIDTH 150.
   DOWN WITH FRAME PROTOCOL.
END.

{preview.i}



