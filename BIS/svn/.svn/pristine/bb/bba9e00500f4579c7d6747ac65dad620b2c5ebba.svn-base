this-procedure:private-data = this-procedure:private-data + ",О_ДР,О_АДР-КЛАДР,О_ДОКУМЕНТ,О_ДОК-ВЫДАН".

/*================    ДОПОЛНЕНИЯ  ПPОМИНВЕСТРАСЧЕТ  в  dps-b2p.p  (borisov) ===================*/
/*----------------------------------------------------------------------------------------------
   О_ДР     День рождения вкладчика
-----------------------------------------------------------------------------------------------*/
PROCEDURE О_ДР:
  DEF INPUT PARAM rid         AS RECID   NO-UNDO.
  DEF INPUT PARAM in-op-date  AS DATE    NO-UNDO.
  DEF INPUT PARAM param-count AS INT64   NO-UNDO.
  DEF INPUT PARAM param-str   AS CHAR    NO-UNDO.

  pick-value = ?.
  DO ON ERROR UNDO, LEAVE:

    FIND loan
      WHERE (RECID(loan) = loan-rid)
      NO-LOCK.

    pick-value = STRING(person.birthday, "99.99.9999").
  END. /* DO */
END PROCEDURE.

/*----------------------------------------------------------------------------------------------
   О_АДР-КЛАДР     "Красивый" адрес вкладчика
-----------------------------------------------------------------------------------------------*/
{pir_anketa.fun}
PROCEDURE О_АДР-КЛАДР:
  DEF INPUT PARAM rid         AS RECID   NO-UNDO.
  DEF INPUT PARAM in-op-date  AS DATE    NO-UNDO.
  DEF INPUT PARAM param-count AS INT64   NO-UNDO.
  DEF INPUT PARAM param-str   AS CHAR    NO-UNDO.

  pick-value = ?.
  DO ON ERROR UNDO, LEAVE:

    FIND loan
      WHERE (RECID(loan) = loan-rid)
      NO-LOCK.

    FIND person
      WHERE (person.person-id EQ loan.cust-id)
      NO-LOCK.

    pick-value = Kladr(person.country-id + ","
                     + GetXAttrValue("person", STRING(loan.cust-id), "КодРег"),
                       person.address[1] + person.address[2]).
  END. /* DO */
END PROCEDURE.

/*----------------------------------------------------------------------------------------------
   О_ДОКУМЕНТ     Удостоверение личности вкладчика
-----------------------------------------------------------------------------------------------*/
PROCEDURE О_ДОКУМЕНТ:
  DEF INPUT PARAM rid         AS RECID   NO-UNDO.
  DEF INPUT PARAM in-op-date  AS DATE    NO-UNDO.
  DEF INPUT PARAM param-count AS INT64   NO-UNDO.
  DEF INPUT PARAM param-str   AS CHAR    NO-UNDO.

  pick-value = ?.
  DO ON ERROR UNDO, LEAVE:

    FIND loan
      WHERE (RECID(loan) = loan-rid)
      NO-LOCK.

    FIND person
      WHERE (person.person-id EQ loan.cust-id)
      NO-LOCK.

    pick-value = person.document-id.
  END. /* DO */
END PROCEDURE.

/*----------------------------------------------------------------------------------------------
   О_ДОК-ВЫДАН     Полная инф.об удостоверении личности вкладчика
-----------------------------------------------------------------------------------------------*/
PROCEDURE О_ДОК-ВЫДАН:
  DEF INPUT PARAM rid         AS RECID   NO-UNDO.
  DEF INPUT PARAM in-op-date  AS DATE    NO-UNDO.
  DEF INPUT PARAM param-count AS INT64   NO-UNDO.
  DEF INPUT PARAM param-str   AS CHAR    NO-UNDO.

  DEF VAR cSurr AS CHARACTER NO-UNDO.

  pick-value = ?.
  DO ON ERROR UNDO, LEAVE:

    FIND loan
      WHERE (RECID(loan) = loan-rid)
      NO-LOCK.

    FIND person
      WHERE (person.person-id EQ loan.cust-id)
      NO-LOCK.

    FIND cust-ident
       WHERE /* cust-ident.class-code     EQ "p-cust-adr"
         AND */ cust-ident.cust-cat       EQ "Ч"
         AND cust-ident.cust-id        EQ person.person-id
         AND cust-ident.cust-code-type EQ person.document-id
         AND cust-ident.cust-code      EQ person.document
       NO-LOCK NO-ERROR.

    cSurr = cust-ident.cust-code-type + ','
          + cust-ident.cust-code      + ','
          + STRING(cust-ident.cust-type-num).

    IF AVAIL cust-ident
    THEN
       pick-value = cust-ident.cust-code + " выдан "
                  + STRING(cust-ident.open-date, "99.99.9999") + " "
                  + cust-ident.issue + ",К/П "
                  + GetXAttrValue("cust-ident", cSurr, "Подразд").
    ELSE
       pick-value = person.document + " выдан "
                  + GetXAttrValue("person", STRING(loan.cust-id), "Document4Date_Vid") + " "
                  + person.issue.

  END. /* DO */
END PROCEDURE
