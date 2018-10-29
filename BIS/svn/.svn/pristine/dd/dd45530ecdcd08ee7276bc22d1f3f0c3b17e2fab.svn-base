/**************************************
 * Отчет по приходу по договорам
 * ПК.
 * Выполнен в результате перехода на
 * ПОС 
 **************************************
 *
 * Автор: Маслов Д. А. Maslov D. A.
 * Дата создания:
 *
 **************************************/
{globals.i}
{tmprecid.def}

DEF VAR oDoc          AS TDocument       NO-UNDO.
DEF VAR oAcct         AS TAcctBal        NO-UNDO.
DEF VAR oAcctKredit   AS TAcct           NO-UNDO.
DEF VAR oTable        AS TTable          NO-UNDO.
DEF VAR l             AS CHARACTER       NO-UNDO.
DEF VAR currDate      AS DATE INIT TODAY NO-UNDO.
DEF VAR oa            AS TAArray         NO-UNDO.
DEF VAR oa1           AS TAArray         NO-UNDO.
DEF VAR key1          AS CHARACTER       NO-UNDO.
DEF VAR value1        AS CHARACTER       NO-UNDO.
DEF VAR tmpSum        AS DECIMAL INIT 0  NO-UNDO.

DEF BUFFER op FOR op.
DEF BUFFER op-entry FOR op-entry.

DEF BUFFER dbAcct   FOR acct.
DEF BUFFER crAcct   FOR acct.


{tpl.create}

/*********
 Этап №1
 Смотрим по кому из пластиков
 есть приход.
 *********/
oa = new TAArray().

/*******************************
 *			       *
 * Шаг №1                      *
 * Определяем счета ПК         *
 * Заполняем доп. информацию.  *
 *                             *
 *******************************/


FOR EACH tmprecid NO-LOCK,
 FIRST op WHERE RECID(op) EQ tmprecid.id NO-LOCK,
   FIRST op-entry OF op 
     WHERE op-entry.acct-cr MATCHES '4............050....'
   NO-LOCK,
     FIRST crAcct WHERE crAcct.acct EQ op-entry.acct-cr AND crAcct.contract EQ "Текущ" NO-LOCK,
       FIRST dbAcct WHERE dbAcct.acct EQ op-entry.acct-db AND dbAcct.contract NE "Кредит" NO-LOCK:

  /**
   * А вот этот кусок кода
   * медленный!!!
   **/
  oAcct = new TAcctBal(op-entry.acct-cr).
  currDate = op.op-date.

  IF oAcct:isLnkOverLoan(currDate) THEN DO:
     l = ENTRY(1,oAcct:getLnkOverLoan(currDate)," ").
     oa:setH(l,oAcct:acct).		
  END. 

DELETE OBJECT oAcct.
END. /* FOR */


FOR EACH tmprecid NO-LOCK,
 FIRST op WHERE RECID(op) EQ tmprecid.id NO-LOCK,
   EACH op-entry OF op 
     WHERE op-entry.acct-cr MATCHES '4............050....' AND op-entry.acct-db = ? 
   NO-LOCK,
     FIRST crAcct WHERE crAcct.acct EQ op-entry.acct-cr AND crAcct.contract EQ "Текущ" NO-LOCK:

  oAcct = new TAcctBal(op-entry.acct-cr).
  currDate = op.op-date.

  IF oAcct:isLnkOverLoan(currDate) THEN DO:
     l = ENTRY(1,oAcct:getLnkOverLoan(currDate)," ").
     oa:setH(l,oAcct:acct).		
  END. 

DELETE OBJECT oAcct.
END. /* FOR */



 /****************************************
  * Шаг №2                               *
  * Получаем информацию                  *
  * по задолженности и строим таблицу.   *
  ****************************************/
 oTable = new TTable(6).

 {foreach oa key1 value1}
    
     oAcctKredit = new TAcct("Кредит",key1,"Кредит",currDate).     
     oAcct       = new TAcctBal(value1).

       oTable:addRow().
       oTable:addCell(key1).
       oTable:addCell(oAcctKredit:name-short).
       oTable:addCell(value1).
       oTable:addCell(oAcctKredit:getLastPos2Date(currDate - 1)).	

       oa1 = oAcct:getCrMove(currDate,currDate,"К").

       oTable:addCell(oa1:get("amt-rub")).
       oTable:addCell((IF oa1:get("amt-cur") EQ ? THEN "" ELSE oa1:get("amt-cur"))).


       DELETE OBJECT oAcctKredit.
       DELETE OBJECT oAcct.
       DELETE OBJECT oa1.
 {endforeach oa}

oTpl:addAnchorValue("currDate",currDate).
oTpl:addAnchorValue("TABLE",oTable).
{tpl.show}

DELETE OBJECT oa.
DELETE OBJECT oTable.
{tpl.delete}
