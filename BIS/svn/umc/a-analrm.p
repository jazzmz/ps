{pirsavelog.p}

/* ------------------------------------------------------
File          : $RCSfile: a-analrm.p,v $ $Revision: 1.6 $ $Date: 2007-10-18 07:42:20 $
Copyright     : ООО КБ "Пpоминвестрасчет"
Базируется    : a-analrm.p
Причина       : У2-2 21.08.2007 Макарова М. 
              : Заявка в в ЗАО "БИС" 0081105 . 
              : При переносе документов по забалансу  УМЦ модуль "СКЛАД" в следующий день, если есть
              : документы по карточки в следующем дне, документы не переносятся.
Назначение    : Проверка на аналитику
Описание      :
Место запуска : При переносе забалансовых документов по УМЦ
Автор         : $Author: anisimov $
Изменения     : $Log: not supported by cvs2svn $
Изменения     : Revision 1.5  2007/09/07 12:00:45  lavrinenko
Изменения     : *** empty log message ***
Изменения     :
Изменения     : Revision 1.4  2007/09/07 11:41:50  lavrinenko
Изменения     : Исправление заголовка
Изменения     :
Изменения     : Revision 1.1 - 1.3
Изменения     : Закоментировал код на несовершение действий по 
Изменения     : переносу документов
------------------------------------------------------ */

{globals.i}

DEF SHARED VAR  pick-value AS CHAR  NO-UNDO.

DEF INPUT PARAM iRid       AS RECID NO-UNDO.
DEF INPUT PARAM iDb-Cr     AS LOG   NO-UNDO.

DEF VAR         v-ok       AS LOG   NO-UNDO.


DEF BUFFER xop-entry  FOR op-entry.
DEF BUFFER xkau-entry FOR kau-entry.
DEF BUFFER xloan      FOR loan.


pick-value = "no".

FIND FIRST op-entry WHERE
     RECID(op-entry)   EQ iRid
   EXCLUSIVE-LOCK.

IF iDb-Cr EQ NO THEN
   FIND FIRST kau       WHERE
              kau.acct     EQ op-entry.acct-cr
          AND kau.currency EQ op-entry.currency
          AND kau.kau      EQ op-entry.kau-cr
   EXCLUSIVE-LOCK NO-ERROR.

ELSE
   FIND FIRST kau       WHERE
              kau.acct     EQ op-entry.acct-db
          AND kau.currency EQ op-entry.currency
          AND kau.kau      EQ op-entry.kau-db
   EXCLUSIVE-LOCK NO-ERROR.


IF AVAILABLE kau
THEN DO:
   FIND FIRST xop-entry       WHERE
              xop-entry.acct-cr  EQ kau.acct
          AND xop-entry.currency EQ kau.currency
          AND RECID(xop-entry)   NE iRid
          AND xop-entry.kau-cr   EQ kau.kau
      NO-LOCK NO-ERROR.

   IF NOT AVAILABLE xop-entry THEN
      FIND FIRST xop-entry       WHERE
                 xop-entry.acct-db  EQ kau.acct
             AND xop-entry.currency EQ kau.currency
             AND RECID(xop-entry)   NE iRid
             AND xop-entry.kau-db   EQ kau.kau
         NO-LOCK NO-ERROR.

/* У счетов с ролью амор не полное kau - пытаемся их найти */
   IF    work-module EQ "ОС"
      OR work-module EQ "НМА"
   THEN DO:
      FIND FIRST kau-entry       WHERE
                 kau-entry.kau-id   EQ     "УМЦ-амор"
             AND kau-entry.kau      BEGINS ENTRY(1,kau.kau) + ","
                                         + ENTRY(2,kau.kau)
             AND kau-entry.op-date  GE     op-entry.op-date
         NO-LOCK NO-ERROR.

      IF NOT AVAILABLE kau-entry THEN
         FIND FIRST kau-entry    OF kau
                                 WHERE
                    kau-entry.op    NE op-entry.op
            NO-LOCK NO-ERROR.
   END.

   ELSE
      FIND FIRST kau-entry       OF kau
                                 WHERE
                 kau-entry.op       NE op-entry.op
         NO-LOCK NO-ERROR.

   IF     NOT AVAILABLE xop-entry
      AND NOT AVAILABLE kau-entry THEN
      DELETE kau.
   ELSE DO:

      IF iDb-Cr EQ NO
      THEN DO:

         {kau(off).cal
            &ssum = "op-entry.amt-rub"
            &inc  = (-1)
            &scur = "op-entry.amt-cur"
         }
      END.

      ELSE DO:
         {kau(off).cal
            &ssum = "- op-entry.amt-rub"
            &inc  = (-1)
            &scur = "- op-entry.amt-cur"
         }
      END.


      FIND FIRST kau-entry OF op-entry
         NO-LOCK NO-ERROR.

      IF     kau.kau-id  EQ "УМЦ-учет"
         AND LASTKEY     EQ KEYCODE("F9")
         AND
             (   (CAN-FIND ( FIRST xloan         WHERE
                                   xloan.cont-code  EQ ENTRY(2, kau-entry.kau)
                               AND xloan.deal-type  EQ NO
                               AND xloan.contract   EQ ENTRY(1, kau-entry.kau)
                               AND xloan.class-code EQ "ОС1")
                  OR
                  CAN-FIND ( FIRST xloan         WHERE
                                   xloan.cont-code  EQ ENTRY(2, kau-entry.kau)
                               AND xloan.deal-type  EQ NO
                               AND xloan.contract   EQ ENTRY(1, kau-entry.kau)
                               AND xloan.class-code EQ "НМА1")
                 )
             )
      THEN DO:
         IF CAN-FIND ( FIRST xkau-entry          WHERE
                             xkau-entry.kau-id      EQ "УМЦ-амор"
                         AND xkau-entry.kau     BEGINS ENTRY(1,kau-entry.kau)
                                                       + "," +
                                                       ENTRY(2,kau-entry.kau)
                         AND xkau-entry.op-date     EQ kau-entry.op-date
                         AND xkau-entry.op          NE kau-entry.op
                     )
         THEN DO:
            MESSAGE
               "В текущем операционном дне"
               "существуют документы амортизации !" SKIP
               "Продолжить ?"
               VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE v-ok.

            IF NOT v-ok EQ YES THEN
               RETURN.
         END.

         ELSE
         IF CAN-FIND ( FIRST xkau-entry          WHERE
                             xkau-entry.kau-id      EQ "УМЦ-амор"
                         AND xkau-entry.kau     BEGINS ENTRY(1,kau-entry.kau)
                                                       + "," +
                                                       ENTRY(2,kau-entry.kau)
                         AND xkau-entry.op-date     GT kau-entry.op-date
                         AND xkau-entry.op          NE kau-entry.op
                     )
         THEN DO:
            MESSAGE
               "Существуют более поздние документы амортизации !"
               VIEW-AS ALERT-BOX ERROR.

            RETURN.
         END.
      END.


      ELSE
      IF    (     work-module EQ "СКЛАД")
         OR (     kau.kau-id  EQ "УМЦ-учет-u"
             AND  LASTKEY     EQ KEYCODE("F9")
             AND  work-module EQ "МБП"
            )
      THEN DO:
         IF  CAN-FIND ( FIRST xkau-entry         WHERE
                              xkau-entry.acct       EQ kau-entry.acct
                          AND xkau-entry.currency   EQ kau-entry.currency
                          AND xkau-entry.kau        EQ kau-entry.kau
                          AND xkau-entry.op-date    GT kau-entry.op-date
                          AND xkau-entry.debit      EQ NO
                          AND xkau-entry.kau-id     EQ kau-entry.kau-id
                          AND xkau-entry.op         NE kau-entry.op
                      )
         THEN DO:
/*      PIR  Кунташев "чтобы пропускало"
					  MESSAGE
               "Существуют более поздние документы списания !"

               VIEW-AS ALERT-BOX ERROR.

            RETURN.*/
         END.

         ELSE
         IF  CAN-FIND ( FIRST xkau-entry         WHERE
                              xkau-entry.acct       EQ kau-entry.acct
                          AND xkau-entry.currency   EQ kau-entry.currency
                          AND xkau-entry.kau        EQ kau-entry.kau
                          AND xkau-entry.op-date    EQ kau-entry.op-date
                          AND xkau-entry.debit      EQ NO
                          AND xkau-entry.kau-id     EQ kau-entry.kau-id
                          AND xkau-entry.op         NE kau-entry.op
                      )
         THEN DO:
            MESSAGE
               "В текущем операционном дне"
               "существуют документы списания !" SKIP
               "Продолжить ?"

               VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE v-ok.

            IF NOT v-ok EQ YES THEN
               RETURN.
         END.
      END.

/* ------------------------------------------------------------------------- */

      IF      kau.kau-id  EQ "УМЦ-учет"
         AND (kau.balance LT 0 OR  kau.curr-bal LT 0)
      THEN DO:
         MESSAGE
            IF LASTKEY NE KEYCODE("F9") THEN
               "Балансовая стоимость мат. ценности Инв.№"
             + ENTRY(2, kau.kau) + "< 0 !"

            ELSE "Есть более поздние документы учета !"
            VIEW-AS ALERT-BOX ERROR.

         RETURN.
      END.

      IF      kau.kau-id  EQ "УМЦ-амор"
         AND (kau.balance GT 0 OR kau.curr-bal GT 0)
      THEN DO:
         MESSAGE
            IF LASTKEY NE KEYCODE("F9") THEN
               "Начисленная амортизация мат. ценности Инв.№"
             + ENTRY(2, kau.kau) + "< 0 !"

            ELSE "Существуют более поздние документы амортизации !!!"
         VIEW-AS ALERT-BOX ERROR.

         RETURN.
      END.
   END.

/* проверка закрытия карточки -
** если удаляем документ списания то карточка и счета могут быть закрыты
*/
   IF iDb-Cr EQ NO THEN
      FIND FIRST acct         WHERE
                 acct.acct       EQ op-entry.acct-cr
             AND acct.currency   EQ op-entry.currency
             AND acct.close-date NE ?
             AND acct.close-date LE op-entry.op-date
         EXCLUSIVE NO-ERROR.

   ELSE
      FIND FIRST acct         WHERE
                 acct.acct       EQ op-entry.acct-db
             AND acct.currency   EQ op-entry.currency
             AND acct.close-date NE ?
             AND acct.close-date LE op-entry.op-date
         EXCLUSIVE NO-ERROR.

   IF AVAILABLE acct
   THEN DO:
      MESSAGE
         "Счет " acct.number " закрыт" SKIP
         "Открыть счет?"
         VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE v-ok.

      IF v-ok EQ YES
      THEN acct.close-date = ?.
      ELSE RETURN.
   END.

   IF iDb-Cr EQ NO THEN
      FIND FIRST loan         WHERE
                 loan.contract   EQ ENTRY(1, op-entry.kau-cr)
             AND loan.cont-code  EQ ENTRY(2, op-entry.kau-cr)
             AND loan.close-date NE ?
             AND loan.close-date LE op-entry.op-date
         EXCLUSIVE NO-ERROR.

   ELSE
      FIND FIRST loan         WHERE
                 loan.contract   EQ ENTRY(1, op-entry.kau-db)
             AND loan.cont-code  EQ ENTRY(2, op-entry.kau-db)
             AND loan.close-date NE ?
             AND loan.close-date LE op-entry.op-date
         EXCLUSIVE NO-ERROR.

   IF AVAILABLE loan
   THEN DO:
      MESSAGE
         "Карточка инв номер " loan.doc-ref " закрыта " SKIP
         "Открыть карточку ?"
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE v-ok.

      IF v-ok EQ YES
      THEN loan.close-date = ?.
      ELSE RETURN.
   END.

/* надо запомнить старое значение - для редактирования */
   IF iDb-Cr EQ NO
   THEN DO:

      RUN SetSysConf IN h_base ("op-entry-kau-cr-"
                              + STRING(op-entry.op) + "-"
                              + STRING(op-entry.op-entry),
                                op-entry.kau-cr).
      op-entry.kau-cr = "".

      FOR EACH kau-entry OF op-entry WHERE
           NOT kau-entry.debit
         EXCLUSIVE-LOCK:
         DELETE kau-entry.
      END.
   END.

   ELSE DO:
      RUN SetSysConf IN h_base ("op-entry-kau-db-"
                              + STRING(op-entry.op) + "-"
                              + STRING(op-entry.op-entry),
                                op-entry.kau-db).
      op-entry.kau-db = "".

      FOR EACH kau-entry OF op-entry WHERE
               kau-entry.debit
         EXCLUSIVE-LOCK:
         DELETE kau-entry.
      END.
   END.
END.

pick-value = "yes".
