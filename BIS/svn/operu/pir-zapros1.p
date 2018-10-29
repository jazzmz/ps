/*****************************************
 *
 * Сведения об операциях клиентов.
 * 
 * Первая таблица из запроса на уточнение
 * реквизитов.
 *
 * Выполнено по #492
 *****************************************************
 *
 * !!! ВНИМАНИЕ !!! ЗАПУСКАТЬ ИЗ БРАУЗЕРА ПРОВОДОК !!!
 *
 * Заявка: #707
 * Автор: Маслов Д. А. Maslov D. A.
 * Дата: 25.05.11
 * 1. Добавил запрос на ввод кассового 
 * символа;
 * 2. В зависимости от кассового символа, 
 * подставляется счета либо по дб, либо
 * по кредиту.
 *****************************************/

{globals.i}
{intrface.get tmess}
{tmprecid.def}

DEF VAR oTpl AS TTpl           NO-UNDO.
DEF VAR oTable AS TTableCSV    NO-UNDO.
DEF VAR oClient AS TClient     NO-UNDO.
DEF VAR oAcct AS TAcct         NO-UNDO.
DEF VAR oSysClass AS TSysClass NO-UNDO.
DEF VAR cKass AS CHARACTER     NO-UNDO.

DEF VAR i AS INTEGER INITIAL 1 NO-UNDO.
DEF VAR cAcct AS CHARACTER NO-UNDO.

DEF VAR dDocSum AS DECIMAL INITIAL 0 NO-UNDO.

DEF VAR isPrihod AS LOGICAL INITIAL FALSE NO-UNDO.

RUN Fill-SysMes IN h_tmess  ("","","3","Тип операции?|Приход,Расход").


IF pick-value EQ "2" THEN DO:
     MESSAGE "Делаем по расходу" VIEW-AS ALERT-BOX.
     isPrihod = FALSE.
 END.
 ELSE
 DO:
  MESSAGE "Делаем по приходу" VIEW-AS ALERT-BOX.
  isPrihod = TRUE.
 END.




oTpl = new TTpl("pir-zapros1.tpl").
oTable = new TTableCSV(8).
oSysClass = new TSysClass().

FOR EACH tmprecid,
  FIRST op-entry WHERE RECID(op-entry) = tmprecid.id,
   FIRST op OF op-entry BY op-entry.amt-rub:                                      


       oTable:addRow().
        oTable:addCell(i).
        oTable:addCell((IF isPrihod THEN op-entry.acct-cr ELSE op-entry.acct-db)).

	ACCUMULATE op-entry.amt-rub (TOTAL).

        oClient = new TClient((IF isPrihod THEN op-entry.acct-cr ELSE op-entry.acct-db)).
        oAcct   = new TAcct((IF isPrihod THEN op-entry.acct-cr ELSE op-entry.acct-db)).
	
            oTable:addCell(oClient:clInn).
            oTable:addCell(oAcct:open-date).
            oTable:addCell(oClient:name-short).
            oTable:addCell(op.op-date).
            oTable:addCell(ROUND(op-entry.amt-rub / 1000,2)).
            oTable:addCell(oSysClass:REPLACE_ASCII(op.details,10," ")).

        DELETE OBJECT oAcct.
        DELETE OBJECT oClient.
        i = i + 1.

END.
oTable:addRow().
oTable:addCell("").
oTable:addCell("ИТОГО:").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell((ACCUM TOTAL op-entry.amt-rub)).
oTable:addCell("").

oTable:SAVE-TO("/home2/bis/quit41d/imp-exp/users/admmda/tab1-1.txt").
oTpl:addAnchorValue("TABLE",oTable).
{setdest.i}
  oTpl:show().
{preview.i}

DELETE OBJECT oTable.
DELETE OBJECT oTpl.
DELETE OBJECT oSysClass.
{intrface.del}