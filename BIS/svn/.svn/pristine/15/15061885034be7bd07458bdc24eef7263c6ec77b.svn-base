/***************************************************************
 * Распоряжение по резервам для сделок МБК
 * Автор: Маслов Д. А.
 * Дата создания: 11:44 12.07.2010
 * Заявка: #53
 ***************************************************************/
{date.fun}
{intrface.get date}

{globals.i} /* Подключяем глобалные настройки*/
{ulib.i}    /* Библиотека функций для работы со счетами */
{tmprecid.def}


DEF VAR oTable    AS TTable    NO-UNDO.
DEF VAR oSysClass AS TSysClass NO-UNDO.

oSysClass = new TSysClass().

DEF BUFFER bOpEntry FOR op-entry.

DEF VAR oTpl AS TTpl NO-UNDO.

DEF VAR traceOn     AS LOGICAL INITIAL false NO-UNDO. /* Вывод ошибок на экран */
DEF VAR client_name AS CHARACTER INITIAL ""  NO-UNDO.
DEF VAR acct_rsrv   AS CHARACTER INITIAL ""  NO-UNDO.
DEF VAR comType     AS CHARACTER 	     NO-UNDO.

DEF VAR dbeg AS DATE NO-UNDO.
DEF VAR dend AS DATE NO-UNDO.


DEF BUFFER bfrLA FOR loan-acct.

{setdest.i &cols=220} /* Вывод в preview */

oTpl = new TTpl("pir_rsrv_39.tpl").
oTable = new TTable(10).

    FOR EACH tmprecid,
     FIRST op WHERE RECID(op) EQ tmprecid.id NO-LOCK,
        FIRST op-entry OF op NO-LOCK:
         /* Найдем информацию о договоре */

   IF op-entry.acct-db BEGINS "4" THEN
      ASSIGN
         acct_rsrv = op-entry.acct-db
      .
   IF op-entry.acct-cr BEGINS "4" THEN
      ASSIGN
         acct_rsrv = op-entry.acct-cr
      .

      FIND LAST bfrLA WHERE bfrLA.acct = acct_rsrv AND bfrLA.contract EQ "Кредит" NO-LOCK NO-ERROR.
    
       IF AVAIL bfrLA THEN 
            DO:     
                   FIND LAST loan WHERE loan.contract  = bfrLA.contract 
                                                                AND loan.cont-code = bfrLA.cont-code
                                                                NO-LOCK NO-ERROR.   
                      IF AVAIL loan THEN 
                            DO:                                       

                                        FIND FIRST bOpEntry WHERE bOpEntry.op-date<op-entry.op-date AND bOpEntry.acct-db = acct_rsrv AND MONTH(bOpEntry.op-date) = MONTH(op-entry.op-date) NO-LOCK NO-ERROR.           
                                        /* Проверяем наличие начисления наращенных % из-за смены категории качества */

                                        IF AVAILABLE(bOpEntry) THEN dbeg = bOpEntry.op-date + 1.
                                                                                        ELSE 
                                                                                            dbeg = MAX(FirstMonDate(op.op-date),Date(oSysClass:str2Date(GetLoanInfo_ULL(loan.contract,loan.cont-code,"open_date",false),"%dd.%mm.%yyyy")) + 1).



                                             dend=MIN(oSysClass:str2Date(GetLoanInfo_ULL(loan.contract,loan.cont-code,"end_date",false),"%dd.%mm.%yyyy"),LastMonDate(op.op-date)).

                                             client_name = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_short_name", false).
                                            oTable:addRow().
                                            oTable:addCell(client_name).
                                            oTable:addCell(loan.doc-num).
                                            oTable:addCell(dbeg).
                                            oTable:addCell(dend).
                                            oTable:addCell(dend - dbeg + 1).
                                            oTable:addCell(STRING(GetLoanCommissionEx_ULL(loan.contract,loan.cont-code,"%Кред",op.op-date,false,comType)) + comType).
                                            oTable:addCell(op-entry.amt-rub).
                                            oTable:addCell("810").
                                            oTable:addCell(op-entry.acct-db).
                                            oTable:addCell(op-entry.acct-cr).

                          END. /* Если найден договор */
              END.  /* Конец если найден loan-acct */
   oTpl:addAnchorValue("ДАТА",op.op-date).
END. /* Конец по всем документам */
oTpl:addAnchorValue("TABLE1",oTable).
oTpl:addAnchorValue("ПЕРИОД",oSysClass:getMonthString(MONTH(dend))).

{setdest.i}
    oTpl:show().
{preview.i}

DELETE OBJECT oTable.
DELETE OBJECT oTpl.
DELETE OBJECT oSysClass.