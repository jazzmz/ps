    FIND FIRST op-kind WHERE RECID(op-kind) = oprid NO-LOCK.

    FOR EACH op-template WHERE op-template.op-kind = op-kind.op-kind NO-LOCK:

     CREATE wop.

       ASSIGN
        wop.op-date  = currDate
        wop.con-date = currDate
        wop.op-templ = op-template.op-template
        wop.op-kind  = op-template.op-kind
      .


      {asswop.i}

      {g-acctv1.i &vacct=tacct &OFBase="/*" &OFsrch=* &func-def=*}
      {g-acctv1.i &nodef-GetAcct=* &vacct=tacct}

      RUN ProcessDetails (RECID(wop), INPUT-OUTPUT wop.details).

      RUN parssen.p (RECID(wop),in-op-date,OUTPUT fler).

    END.

  FOR EACH wop NO-LOCK, 
     FIRST op-template WHERE op-template.op-kind=op-kind.op-kind AND op-template.op-template = wop.op-templ NO-LOCK:

   /** Документы с нулевой суммой пропускаем **/
   IF wop.amt-rub > 0 OR wop.amt-cur > 0 THEN DO:






    CREATE op. 

    {op(sess).cr}
    {g-op.ass}

       ASSIGN
            op.doc-num  = STRING(GetCounterNextValue("Общий",op.op-date))
            op.doc-date = in-op-date
            op.details  = wop.details
       .
        CREATE op-entry.
              ASSIGN
               op-entry.op-date      = in-op-date
               op-entry.acct-cat     = wop.acct-cat
               op-entry.op-status    = op.op-status
               op-entry.user-id      = op.user-id
               op-entry.op           = op.op
               op-entry.op-entry     = 1
               op-entry.acct-db      = wop.acct-db
               op-entry.acct-cr      = wop.acct-cr
               op-entry.currency     = wop.currency
               op-entry.value-date   = in-op-date
               op-entry.amt-cur      = 0
               op-entry.amt-rub      = wop.amt-rub
               op-entry.qty          = wop.qty
               op-entry.type         = wop.type
               op-entry.op-cod       = wop.op-cod
         .

   /*** ПАРСЕР ПО ДР ***/

            RUN parssign.p (op.op-date,
                            "op-template",
                            wop.op-kind + "," + STRING(wop.op-templ),
                            op-template.class-code,
                            "op",
                            STRING(op.op),
                            op.class-code,
                            RECID(wop)).


           /* Проверяем наличие обязательных доп.реквизитов. */
            RUN chsigns.p (op.class-code,?,?,YES,OUTPUT result).

           /* Если они есть - запускаем редактирование. */
            IF result GT 0 THEN RUN "xattr-ed.p" (op.class-code, STRING(op.op),"ДОКУМЕНТА", YES, 3).

   /*** КОНЕЦ ПАРСЕРА ПО ДР ***/


   {op.upd &undo="undo, return "}
    END.
  END.

 {empty wop}
