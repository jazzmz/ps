/***********************************
 *                                 *
 * Отчет.                          *
 * Отчет о расределении активов    *
 * по ПОС.                         *
 * Приложение №3
 *				   *
 ***********************************
 * Автор: Маслов Д. А.             *
 * Дата создания:                  *
 * Заявка: #856                    *
 ***********************************/

/*****************
Заявка #996
теперь в параметре передаем код транзакции сброса резерва по ПОС.
Автор модификации: Красков А.С.
                 */


{globals.i}
{intrface.get loan}
{intrface.get count}
{intrface.get xclass}

{tmprecid.def}


{pir-gp.i}
{pir-c2346u.i}
DEF INPUT PARAM cParam AS CHAR NO-UNDO.

DEF VAR oTable1  AS TTable      NO-UNDO.
DEF VAR oClient AS TClient     NO-UNDO.
DEF VAR i       AS INT  INIT 0 NO-UNDO.

DEF VAR cClassCode AS CHARACTER INIT "loan_trans_diff" NO-UNDO.
DEF VAR posName    AS CHARACTER			       NO-UNDO.
DEF VAR itog 	   AS DECIMAL INIT 0 		       NO-UNDO.

DEF VAR oSysClass  AS TSysClass NO-UNDO.
DEF VAR baseCalc   AS DECIMAL   NO-UNDO.
DEF VAR currDate   AS DATE      NO-UNDO.

DEF VAR showZero   AS LOGICAL INITIAL FALSE  NO-UNDO.

DEF VAR oSysClass1	    AS TSysClass NO-UNDO.
DEF VAR curr-user-id        AS CHARACTER NO-UNDO.
DEF VAR curr-user-inspector AS CHARACTER NO-UNDO.


oSysClass = new TSysClass().
cClassCode = ENTRY(1,oSysClass:getSetting("ОверКлассТранз","КлОхватТранш"),"|").



{getdate.i}
find first op where op.op-date = end-date and can-do (cParam,op.op-kind) NO-LOCK NO-ERROR.
if AVAILABLE op then 
   do:
      curr-user-id        = op.user-id.
      curr-user-inspector = FGetSetting("PirEArch","RepInspCredit",?). /*#4066*/
   end.
else
do:
   MESSAGE COLOR WHITE/RED "Не найдены проводки созданные транзакцей " cParam VIEW-AS ALERT-BOX TITLE "ОШИБКА #996".
   RETURN.
end.

currDate  = end-date.
gend-date = currDate.

MESSAGE "Подавлять нулевые?" VIEW-AS ALERT-BOX BUTTONS YES-NO SET showZero.
showZero = NOT showZero.


{tpl.create}

oTable1 = new TTable(4).

posName = getPosId("ПЛКарт",1).

{pir-getlinpos.i cClassCode currDate posName}

oClient = new TClient(loan.cust-cat,loan.cust-id).
        baseCalc = oSysClass:convert2rur(INT(loan.currency),getRsrvBase(loan.cont-code,currDate,"limit"),currDate).
	IF baseCalc <> 0 OR showZero THEN DO:
	 i = i + 1.
  	 oTable1:addRow().
	 oTable1:addCell(i).
	 oTable1:addCell(loan.cont-code + (IF loan.currency <> oSysClass:getSetting("КодНацВал") AND loan.currency <> "" THEN "*" ELSE "")).
	 oTable1:addCell(oClient:name-short).
	 oTable1:addCell(baseCalc).
         itog = itog + baseCalc.
	END.

DELETE OBJECT oClient.

END. /* END по всем договорам 1ого портфеля */
oTable1:addRow().
oTable1:addCell("ИТОГО:").
oTable1:addCell("").
oTable1:addCell("").
oTable1:addCell(itog).

oTpl:addAnchorValue("currDate",currDate).
oTpl:addAnchorValue("TABLEPOS1",oTable1).
{tpl.show}

/**************
 * Отправка в архив
 **************/
&SCOPED-DEFINE arch2 1
{send2arch.i notmark=1}


DELETE OBJECT oTable1.
DELETE OBJECT oSysClass.
{tpl.delete}
{intrface.del}