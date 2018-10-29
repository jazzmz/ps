/*-----------------------------------------------------------------------------
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2003 ТОО "Банковские информационные системы"
     Filename: sw-uni.i
      Comment: Сбор данных для сводных мемордеров
   Parameters:
         Uses: 
      Used by:
      Created: 27/05/2003 Peter
     Modified: 12.12.2006 9:45 Бурягин Е.П.
               Добавлена метка 'next_tmprecid' и условие вызова оператора NEXT.
               Суть в том, что когда данная процедура выполняется для документов, 
               выбранных по "рублевому фильтру" (в параметрах фильтра в проле валюты задано
               пустое значение), она пытается обработать и "рублевые" полупроводки конверсионных
               операций, т.к. данные полупроводки удовлетворяют настройкам данного фильтра.
               Частный случай - конверсия долларов в евро - обрабатывается добавленным условием.
-----------------------------------------------------------------------------*/
form "~n@(#) sw-uni.i Peter Peter" with frame sccs-id stream-io width 250.


/** Buryagin added 12.12.2006 9:41 */ 
next_tmprecid: 
/** end */
FOR EACH tmprecid NO-LOCK,

&IF DEFINED(FILE_sword_p) = 0 &THEN

  FIRST op-entry WHERE RECID(op-entry) = tmprecid.id NO-LOCK,
  FIRST op OF op-entry NO-LOCK:

&ELSE

  FIRST op WHERE RECID(op) = tmprecid.id NO-LOCK,
  EACH op-entry OF op NO-LOCK:

&ENDIF

	/** Buryagin added 12.12.2006 9:41 */
	IF op-entry.acct-db = ? AND op-entry.currency = "" THEN NEXT next_tmprecid.
	/** end */
  
  FIND FIRST op-impexp OF op NO-LOCK NO-ERROR.

  IF CAN-FIND(FIRST tt-en WHERE tt-en.rid = RECID(op-entry)) THEN NEXT.
  RUN CreateTempEntry(RECID(op-entry)).

  CREATE tt-ope.
  ASSIGN
    tt-ope.acct-db    = IF op-entry.acct-db <> ? THEN op-entry.acct-db ELSE ""
    tt-ope.acct-cr    = IF op-entry.acct-cr <> ? THEN op-entry.acct-cr ELSE ""
    tt-ope.amt-rub    = op-entry.amt-rub
    tt-ope.amt-cur    = op-entry.amt-cur
    tt-ope.currency   = op-entry.currency
    tt-ope.value-date = op-entry.value-date
    tt-ope.due-date   = op.due-date
    tt-ope.order-pay  = op.order-pay
    tt-ope.doc-num    = op.doc-num
    tt-ope.details    = op.details
    tt-ope.doc-type   = op.doc-type
    tt-ope.op-status  = op.op-status
    tt-ope.doc-date   = if op.doc-date eq ? then op.op-date else op.doc-date
    tt-ope.op         = op.op
    tt-ope.op-date    = op.op-date
    tt-ope.qty        = op-entry.qty
    tt-ope.symbol     = op-entry.symbol
    tt-ope.reference  = if avail op-impexp then op-impexp.bank-reference else ""
    tt-ope.exp-batch  = if avail op-impexp then op-impexp.exp-batch else ""
    tt-ope.imp-batch  = if avail op-impexp then op-impexp.imp-batch else ""
  .

  IF fAggregate THEN DO:
    IF tt-ope.acct-db = "" THEN DO:
      FIND FIRST b-entry OF op WHERE b-entry.acct-cr = ? NO-LOCK NO-ERROR.
      IF AVAIL b-entry THEN DO:
        tt-ope.acct-db = b-entry.acct-db.
        IF tt-ope.currency = "" OR b-entry.currency = "" THEN
          ASSIGN
            tt-ope.currency = IF b-entry.currency <> "" THEN b-entry.currency ELSE tt-ope.currency
            tt-ope.amt-cur  = IF b-entry.currency <> "" THEN b-entry.amt-cur  ELSE tt-ope.amt-cur
          .
        ELSE IF fAggregateSide = "Дб" THEN
          ASSIGN
            tt-ope.currency = b-entry.currency
            tt-ope.amt-rub  = b-entry.amt-rub
            tt-ope.amt-cur  = b-entry.amt-cur
        .
        RUN CreateTempEntry(RECId(b-entry)).
      END.
    END.
    IF tt-ope.acct-cr = "" THEN DO:
      FIND FIRST b-entry OF op WHERE b-entry.acct-db = ? NO-LOCK NO-ERROR.
      IF AVAIL b-entry THEN DO:
        tt-ope.acct-cr = b-entry.acct-cr.
        IF tt-ope.currency = "" OR b-entry.currency = "" THEN
          ASSIGN
            tt-ope.currency = IF b-entry.currency <> "" THEN b-entry.currency ELSE tt-ope.currency
            tt-ope.amt-cur  = IF b-entry.currency <> "" THEN b-entry.amt-cur  ELSE tt-ope.amt-cur
          .
        ELSE IF fAggregateSide = "Кр" THEN
          ASSIGN
            tt-ope.currency = b-entry.currency
            tt-ope.amt-rub  = b-entry.amt-rub
            tt-ope.amt-cur  = b-entry.amt-cur
          .
        RUN CreateTempEntry(RECID(b-entry)).
      END.
    END.
  END.

  {empty Info-Store}
  RUN Collection-Info.
  
  RUN for-pay("ДЕБЕТ,ПЛАТЕЛЬЩИК,БАНКПЛ,БАНКГО,БАНКФИЛ",
              "ПП",
              OUTPUT PlName[1],
              OUTPUT PlLAcct,
              OUTPUT PlRKC[1],
              OUTPUT PlCAcct,
              OUTPUT PlMFO).
  ASSIGN
    tt-ope.pl     = PlName[1]
    tt-ope.plmfo  = PlMFO
    tt-ope.placct = PlLAcct
    tt-ope.plinn  = IF {assigned PlINN} THEN PlINN ELSE ""
    tt-ope.plkpp  = PlKPP
    tt-ope.plrkc  = PlCAcct
  .
  RUN for-rec("КРЕДИТ,ПОЛУЧАТЕЛЬ,БАНКПОЛ,БАНКГО,БАНКФИЛ",
              "ПП",
              OUTPUT PoName[1],
              OUTPUT PoAcct,
              OUTPUT PoRKC[1],
              OUTPUT PoCAcct,
              OUTPUT PoMFO).
  ASSIGN
    tt-ope.pol     = PoName[1]
    tt-ope.pomfo   = PoMFO
    tt-ope.polacct = PoAcct
    tt-ope.poinn   = IF {assigned PoINN} THEN PoINN ELSE ""
    tt-ope.pokpp   = PoKPP
    tt-ope.porkc   = PoCAcct
  .

  tt-ope.sort  = IF fSortAsc THEN GetSortValue(fSortFlds) ELSE "".
  tt-ope.sortd = IF fSortAsc THEN "" ELSE GetSortValue(fSortFlds).
  tt-ope.grp   = GetBreakValue(fBreakField).
END.
