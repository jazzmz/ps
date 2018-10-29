{pirsavelog.p}

{globals.i}

&GLOB LST-ACCT-TYPE  loan-dps-p,loan-dps-t,loan-dps-int,loan-dps-exc
&GLOB LST-COD-OST    "ОстВклВ,ОстВклС,НачПР,ПрПр"

DEFINE INPUT PARAMETER in-cont-code AS CHARACTER NO-UNDO.

DEFINE VAR date-begins     AS DATE    NO-UNDO.
DEFINE VAR last-close-date AS DATE    NO-UNDO.
DEFINE VAR in-date         AS DATE    NO-UNDO.

DEFINE VAR summ        AS DECIMAL NO-UNDO.
DEFINE SHARED TEMP-TABLE prol-loan NO-UNDO
      FIELD cont-code AS CHARACTER
      FIELD op-date   AS DATE
.

FUNCTION cr_kau  RETURN CHARACTER (BUFFER buf-loan-acct FOR loan-acct,
                                   c-summ  AS DECIMAL,
                                   c-ost   AS CHARACTER,
                                   in-date AS DATE
                                  ):
   IF buf-loan-acct.currency EQ "" THEN DO:
      FIND kau WHERE kau.acct     = buf-loan-acct.acct
                 AND kau.currency = buf-loan-acct.currency
                 AND kau.kau-id   = buf-loan-acct.acct-type
                 AND kau.kau      = buf-loan-acct.contract  + "," +
                                    buf-loan-acct.cont-code + "," +
                                    c-ost EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAIL kau THEN
      CREATE kau.
      ASSIGN
         kau.acct           = buf-loan-acct.acct
         kau.currency       = buf-loan-acct.currency
         kau.kau-id         = buf-loan-acct.acct-type
         kau.kau            = buf-loan-acct.contract  + "," +
                              buf-loan-acct.cont-code + "," +
                              c-ost
         kau.balance        = ABSOLUTE(c-summ)
         kau.zero-bal       = no
         kau.sort           = ""
         kau.numop          = 1

      .
      CREATE kau-pos.
      ASSIGN
         kau-pos.acct       = buf-loan-acct.acct
         kau-pos.currency   = buf-loan-acct.currency
         kau-pos.kau        = buf-loan-acct.contract  + "," +
                              buf-loan-acct.cont-code + "," +
                              c-ost
         kau-pos.kau-id     = buf-loan-acct.acct-type
         kau-pos.balance    = - c-summ
         kau-pos.credit     = 0
         kau-pos.debit      = 0
         kau-pos.since      = in-date
         kau-pos.numop-db   = 0
         kau-pos.numop-cr   = 1
         kau-pos.numop      = 1
      .
   END.
   ELSE DO:
      FIND kau WHERE kau.acct     = buf-loan-acct.acct
                 AND kau.currency = buf-loan-acct.currency
                 AND kau.kau-id   = buf-loan-acct.acct-type
                 AND kau.kau      = buf-loan-acct.contract  + "," +
                                    buf-loan-acct.cont-code + "," +
                                    c-ost EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAIL kau THEN
      CREATE kau.
      ASSIGN
         kau.acct           = buf-loan-acct.acct
         kau.currency       = buf-loan-acct.currency
         kau.kau-id         = buf-loan-acct.acct-type
         kau.kau            = buf-loan-acct.contract  + "," +
                              buf-loan-acct.cont-code + "," +
                              c-ost
         kau.curr-bal       = ABSOLUTE(c-summ)
         kau.zero-bal       = no
         kau.sort           = ""
         kau.numop          = 1

      .
      CREATE kau-cur.
      ASSIGN
         kau-cur.acct       = buf-loan-acct.acct
         kau-cur.currency   = buf-loan-acct.currency
         kau-cur.kau        = buf-loan-acct.contract  + "," +
                              buf-loan-acct.cont-code + "," +
                              c-ost
         kau-cur.kau-id     = buf-loan-acct.acct-type
         kau-cur.balance    = - c-summ
         kau-cur.credit     = 0
         kau-cur.debit      = 0
         kau-cur.since      = in-date
         kau-cur.numop-db   = 0
         kau-cur.numop-cr   = 1
         kau-cur.numop      = 1
      .
   END.
   RETURN "".
END FUNCTION.

PROCEDURE get-transfer-opdate:
   DEFINE PARAMETER BUFFER buf-loan FOR loan.
   DEFINE OUTPUT PARAMETER out-date AS DATE NO-UNDO.
   out-date = buf-loan.open-date.
   DO WHILE {holiday.i out-date}:
      out-date = out-date + 1.
   END.
END PROCEDURE.

PROCEDURE get-first-date:
   DEFINE PARAMETER BUFFER buf-loan FOR loan.
   DEFINE OUTPUT PARAMETER out-date AS DATE NO-UNDO.
   DEFINE BUFFER buf-loan-acct FOR loan-acct.
   DEFINE VAR in-acct-type    AS CHARACTER NO-UNDO.
   DEFINE VAR transfer-opdate AS DATE      NO-UNDO.
   out-date = ?.
   IF buf-loan.open-date GT last-close-date THEN RETURN.
   out-date = date-begins.
   IF buf-loan.open-date LE date-begins THEN RETURN.

   IF buf-loan.end-date NE ? THEN in-acct-type = "loan-dps-t".
                             ELSE in-acct-type = "loan-dps-p".

   FIND LAST buf-loan-acct WHERE buf-loan-acct.contract  EQ buf-loan.contract
                             AND buf-loan-acct.cont-code EQ buf-loan.cont-code
                             AND buf-loan-acct.acct-type EQ in-acct-type
                             AND buf-loan-acct.since     LE last-close-date
                                                              NO-LOCK NO-ERROR.
   IF NOT AVAIL buf-loan-acct THEN RETURN.

   RELEASE acct-pos.
   RELEASE acct-cur.

   IF buf-loan-acct.currency EQ "" THEN
      FIND LAST acct-pos WHERE acct-pos.acct      EQ buf-loan-acct.acct
                           AND acct-pos.currency  EQ buf-loan-acct.currency
                           AND acct-pos.since     GE date-begins
                           AND acct-pos.since     LT buf-loan.open-date
                                                       NO-LOCK NO-ERROR.
   ELSE
      FIND LAST acct-cur WHERE acct-cur.acct      EQ buf-loan-acct.acct
                           AND acct-cur.currency  EQ buf-loan-acct.currency
                           AND acct-cur.since     GE date-begins
                           AND acct-cur.since     LT buf-loan.open-date
                                                      NO-LOCK NO-ERROR.
   IF AVAIL acct-pos OR AVAIL acct-cur THEN DO:
      transfer-opdate = ?.
      RUN get-transfer-opdate(BUFFER buf-loan,OUTPUT transfer-opdate).
      IF transfer-opdate NE ? THEN DO:
         CREATE prol-loan.
         ASSIGN
            prol-loan.cont-code = buf-loan.cont-code
            prol-loan.op-date   = transfer-opdate
         .
      END.
      out-date = buf-loan.open-date - 1.
   END.
END PROCEDURE.

{get_set.i "Дата_НР" NO}
IF NOT AVAIL setting THEN DO:
   MESSAGE "Отсутствует настроечный параметр Дата_НР!"
   VIEW-AS ALERT-BOX ERROR BUTTONS OK.
   RETURN.
END.
ASSIGN
   date-begins = DATE(setting.val)
NO-ERROR.
IF ERROR-STATUS:ERROR THEN DO:
   MESSAGE "Параметр Дата_НР установлен не правильно!"
   VIEW-AS ALERT-BOX ERROR BUTTONS OK.
   ERROR-STATUS:ERROR = NO.
   RETURN.
END.
FIND LAST acct-pos NO-LOCK NO-ERROR.
IF AVAIL acct-pos THEN
last-close-date = acct-pos.since.
ELSE
   MESSAGE "Дата последнего закрытого дня не установлена!"
   VIEW-AS ALERT-BOX ERROR BUTTONS OK.


/*{setdest.i}*/
FOR EACH loan WHERE loan.contract  EQ "DPS"
                AND CAN-DO(in-cont-code,loan.cont-code)
                AND loan.open-date LE last-close-date NO-LOCK:
   RUN get-first-date(BUFFER loan,OUTPUT in-date).
   IF in-date EQ ? THEN NEXT.

   FOR EACH loan-acct WHERE loan-acct.contract  EQ loan.contract
                        AND loan-acct.cont-code EQ loan.cont-code
                        AND CAN-DO("{&LST-ACCT-TYPE}",loan-acct.acct-type)
                        AND loan-acct.since     LE last-close-date NO-LOCK:
      RELEASE kau-pos.
      RELEASE kau-cur.
      IF loan-acct.currency EQ "" THEN
         FIND FIRST kau-pos WHERE kau-pos.acct     EQ loan-acct.acct
                              AND kau-pos.currency EQ loan-acct.currency
                              AND kau-pos.since    LE in-date
                                                        NO-LOCK NO-ERROR.
      ELSE
         FIND FIRST kau-cur WHERE kau-cur.acct     EQ loan-acct.acct
                              AND kau-cur.currency EQ loan-acct.currency
                              AND kau-cur.since    LE in-date
                                                        NO-LOCK NO-ERROR.
      IF AVAIL kau-pos OR AVAIL kau-cur THEN NEXT.


      IF loan-acct.currency EQ "" THEN DO:
         FIND LAST acct-pos WHERE acct-pos.acct      EQ loan-acct.acct
                              AND acct-pos.currency  EQ loan-acct.currency
                              AND acct-pos.since     LE in-date
                                                       NO-LOCK NO-ERROR.
         IF NOT AVAIL acct-pos THEN NEXT.
         summ = ABS(acct-pos.balance).
      END.
      ELSE DO:
         FIND LAST acct-cur WHERE acct-cur.acct      EQ loan-acct.acct
                              AND acct-cur.currency  EQ loan-acct.currency
                              AND acct-cur.since     LE in-date
                                                          NO-LOCK NO-ERROR.
         IF NOT AVAIL acct-cur THEN NEXT.
         summ = ABS(acct-cur.balance).
      END.
      IF summ = 0 THEN NEXT.
      cr_kau(BUFFER loan-acct,
             summ,
             ENTRY(LOOKUP(loan-acct.acct-type,"{&LST-ACCT-TYPE}"),{&LST-COD-OST}),
             in-date).
   END.
END.
/*{preview.i}*/

