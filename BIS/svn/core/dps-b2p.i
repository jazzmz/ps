this-procedure:private-data = this-procedure:private-data + ",_,_-,_,_-".

/*================      P  ข  dps-b2p.p  (borisov) ===================*/
/*----------------------------------------------------------------------------------------------
   _     ฅญ์ เฎฆคฅญจ๏ ขชซ ค็จช 
-----------------------------------------------------------------------------------------------*/
PROCEDURE _:
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
   _-     "เ แจข๋ฉ"  คเฅแ ขชซ ค็จช 
-----------------------------------------------------------------------------------------------*/
{pir_anketa.fun}
PROCEDURE _-:
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
                     + GetXAttrValue("person", STRING(loan.cust-id), "ฎคฅฃ"),
                       person.address[1] + person.address[2]).
  END. /* DO */
END PROCEDURE.

/*----------------------------------------------------------------------------------------------
   _     คฎแโฎขฅเฅญจฅ ซจ็ญฎแโจ ขชซ ค็จช 
-----------------------------------------------------------------------------------------------*/
PROCEDURE _:
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
   _-     ฎซญ ๏ จญไ.ฎก ใคฎแโฎขฅเฅญจจ ซจ็ญฎแโจ ขชซ ค็จช 
-----------------------------------------------------------------------------------------------*/
PROCEDURE _-:
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
         AND */ cust-ident.cust-cat       EQ ""
         AND cust-ident.cust-id        EQ person.person-id
         AND cust-ident.cust-code-type EQ person.document-id
         AND cust-ident.cust-code      EQ person.document
       NO-LOCK NO-ERROR.

    cSurr = cust-ident.cust-code-type + ','
          + cust-ident.cust-code      + ','
          + STRING(cust-ident.cust-type-num).

    IF AVAIL cust-ident
    THEN
       pick-value = cust-ident.cust-code + " ข๋ค ญ "
                  + STRING(cust-ident.open-date, "99.99.9999") + " "
                  + cust-ident.issue + ",/ "
                  + GetXAttrValue("cust-ident", cSurr, "ฎคเ งค").
    ELSE
       pick-value = person.document + " ข๋ค ญ "
                  + GetXAttrValue("person", STRING(loan.cust-id), "Document4Date_Vid") + " "
                  + person.issue.

  END. /* DO */
END PROCEDURE
