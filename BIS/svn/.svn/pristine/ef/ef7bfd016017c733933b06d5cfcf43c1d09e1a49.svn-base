/*********************************************
 * Отчет по картотеке невыясненных платежей *
 *********************************************
 * Выводит отчет по картотеке сумм,                     *
 * поставленных на картотеку до                         *
 * выяснения и не проплаченных                          *
 *********************************************
* Дата: 10:53 29.09.2010
 * Заявка: #432
 * Автор: Маслов Д. А.
 *********************************************
 * Дата: 18:08 05.10.2010
 * Заявка: #448
 * Автор: Маслов Д. А.
 *********************************************
 * Дата: 10:54 29.11.2010
 * Заявка: #549
 * Автор: Маслов Д. А.
 ********************************************/
{globals.i}
{intrface.get date}

DEF INPUT PARAM paramall AS CHARACTER NO-UNDO.

DEF VAR param1 AS INTEGER INITIAL ? NO-UNDO.
DEF VAR param2 AS LOGICAL INITIAL ? NO-UNDO.

param1 = INTEGER(ENTRY(1,paramall)) NO-ERROR.
param2 = LOGICAL(ENTRY(2,paramall)) NO-ERROR.

DEF VAR oTpl     AS TTpl     NO-UNDO.
DEF VAR oTable   AS TTable   NO-UNDO.
DEF VAR oClient  AS TClient  NO-UNDO.
DEF VAR oDTInput AS TDTInput NO-UNDO.

DEF VAR cAcct     AS CHARACTER INITIAL "47416810600000000001" NO-UNDO.
DEF VAR cCorrAcct AS CHARACTER INITIAL ""                     NO-UNDO.  /* Счет с которомы корреспондирует cAcct */

/**********************************
 * Через сколько дней             *
 * несписанный док-т постановки   *
 * пропадает из отчета.           *
 **********************************/
DEF VAR iStep  AS INTEGER INITIAL 14 NO-UNDO.
/***/
DEF VAR iDelay AS INTEGER INITIAL 6  NO-UNDO.

DEF VAR curDate   AS DATE                  NO-UNDO.
DEF VAR dNextDate AS DATE                  NO-UNDO.
DEF VAR lForce    AS LOGICAL INITIAL FALSE NO-UNDO.


DEF BUFFER bufOpEntryIn FOR op-entry.
DEF BUFFER bufOpEntryOut FOR op-entry.
DEF BUFFER bufOpIn FOR op.
DEF BUFFER bufOpOut FOR op.

oTpl = new TTpl("pir-repk4nev.tpl").
oTable = new TTable(10).
curDate = TODAY.

IF ENTRY(1,paramall) <> ? THEN iDelay = param1.
IF param2 <> ? THEN lForce = param2.

IF lForce THEN
    DO:
            /*******************************
            * Запрашиваем дату на которую  *
            * формируем отчет                         *
            *******************************/
                oDTInput = new TDTInput(3).
                       oDTInput:HEAD = "Картотека на?".
                        oDTInput:X = 250.
                       oDTInput:show().
                        curDate = ODTInput:beg-date.
                DELETE OBJECT oDTInput.
    END.
FOR EACH bufOpEntryIn WHERE bufOpEntryIn.acct-cr EQ cAcct 
                                                            AND bufOpEntryIn.op-date GE (curDate - iStep) AND bufOpEntryIn.op-date <> ? 
                                                            AND bufOpEntryIn.op-status GE "√" 
                                                            AND bufOpEntryIn.op-date LE curDate NO-LOCK,
           FIRST bufOpIn OF bufOpEntryIn NO-LOCK BY bufOpEntryIn.op-date:

   /**********************************
    * По всем проводкам,
    * на глубину iStep в обратном порядке  *
    *************************************/
        dNextDate = AfterWorkDays(bufOpEntryIn.op-date,iDelay).

  /************************************
   * В случае если сотрудник ошибся,
   * и списал докумены в другом дне,
   * то необходимо показывать его 
   * ошибку до даты ошибочного списания.
   ************************************/

        FIND FIRST bufOpEntryOut WHERE bufOpEntryOut.amt-rub EQ bufOpEntryIn.amt-rub
                                                                        AND bufOpEntryOut.acct-db EQ cAcct
                                                                        AND (
                                                                                    bufOpEntryOut.op-date GE bufOpEntryIn.op-date 
                                                                                    AND bufOpEntryOut.op-date LE MAXIMUM(dNextDate,curDate)
                                                                                    AND bufOpEntryOut.op-date LE curDate
                                                                                  )
                                                                        AND bufOpEntryOut.kau-db MATCHES STRING(bufOpEntryIn.op) + ",*"
                                                                        AND bufOpEntryOut.op-date <> ? NO-LOCK NO-ERROR.


            IF  NOT AVAILABLE(bufOpEntryOut) THEN
                                DO:			
                                                 /* *******************************
                                                  * Найден документ списания
                                                  * который отстоит на iDelay дней 
                                                  *  от документа постановки
                                                  *********************************/
                                                    cCorrAcct = getXAttrValue("op",STRING(bufOpIn.op),"acct-rec").
                                                    IF cCorrAcct = ? OR cCorrAcct = "" THEN
                                                               DO:
                                                                        /******************************** *********
                                                                         * Определяем счет с которым                           *
                                                                         * корреспондирует 47416 непосредственно     *
                                                                         * из проводки.                                                        *
                                                                         * #549                                                                       *
                                                                         ******************************************/
                                                                         cCorrAcct = bufOpEntryIn.acct-db.
                                                                END.
                                                                            
                                                    oClient = new TClient(cCorrAcct).
                                                   oTable:addRow().
                                                      oTable:addCell(bufOpIn.op-date).
                                                      oTable:addCell(dNextDate).
                                                      oTable:addCell(bufOpIn.doc-num).
                                                      oTable:addCell(cCorrAcct).
                                                      oTable:addCell(oClient:name-short).
                                                      oTable:addCell(getXAttrValue("op",STRING(bufOpIn.op),"name-rec")).
                                                       oTable:addCell(oClient:clinn).
                                                       oTable:addCell(getXAttrValue("op",STRING(bufOpIn.op),"inn-rec")).
                                                      oTable:addCell(bufOpEntryIn.amt-rub).
                                                      oTable:addCell(IF bufOpEntryIn.kau-cr <> "" THEN CHR(251) ELSE "-").
                                                    DELETE OBJECT oClient.
                                                
                                END.

END.  

  IF oTable:HEIGHT > 0 THEN oTpl:addAnchorValue("TABLE",oTable). ELSE oTpl:addAnchorValue("TABLE","*** НЕТ ДАННЫХ ***").
  oTpl:addAnchorValue("ON-DATE",curDate).
{setdest.i}
    oTpl:show().
{preview.i}

DELETE OBJECT oTable.
DELETE OBJECT oTpl.
