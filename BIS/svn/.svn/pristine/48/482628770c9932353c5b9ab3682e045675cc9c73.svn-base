/***********************************
 *                                 *
 * Отчет.                          *
 * Отчет о расределении активов    *
 * по ПОС.                         *
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

{pir-gp.i}
{pir-c2346u.i}

DEF INPUT PARAM cParam AS CHAR NO-UNDO.

DEF VAR oTable1  AS TTable      NO-UNDO.
DEF VAR oTable2  AS TTable      NO-UNDO.
DEF VAR oTable3  AS TTable      NO-UNDO.
DEF VAR oTable4  AS TTable      NO-UNDO.
DEF VAR oTable5  AS TTable      NO-UNDO.
DEF VAR oTable6  AS TTable      NO-UNDO.


DEF VAR oClient AS TClient     NO-UNDO.
DEF VAR i       AS INT  INIT 0 NO-UNDO.

DEF VAR cClassCode AS CHARACTER INIT "loan_trans_diff" NO-UNDO.
DEF VAR posName    AS CHARACTER			       NO-UNDO.
DEF VAR itog 	   AS DECIMAL INIT 0 		       NO-UNDO.

DEF VAR oSysClass  AS TSysClass NO-UNDO.

DEF VAR baseCalc   AS DECIMAL                NO-UNDO.
DEF VAR showZero   AS LOGICAL INITIAL FALSE  NO-UNDO.

DEF VAR currDate   AS DATE NO-UNDO.

DEF VAR oSysClass1	    AS TSysClass NO-UNDO.
DEF VAR curr-user-id        AS CHARACTER NO-UNDO.
DEF VAR curr-user-inspector AS CHARACTER NO-UNDO.



{tmprecid.def}

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


currDate     = end-date.
gend-date    = currDate.


MESSAGE "Подавлять нулевые?" VIEW-AS ALERT-BOX BUTTONS YES-NO SET showZero.
showZero = NOT showZero.

{tpl.create}

oSysClass = new TSysClass().
cClassCode = ENTRY(2,oSysClass:getSetting("ОверКлассТранз","КлОхватТранш"),"|").

oTable1 = new TTable(4).
oTable2 = new TTable(4).
oTable3 = new TTable(4).
oTable4 = new TTable(4).
oTable5 = new TTable(4).
oTable6 = new TTable(4).

posName = getPosId("ПЛКарт",1).

{pir-getlinpos.i cClassCode currDate posName}
oClient = new TClient(loan.cust-cat,loan.cust-id).
        baseCalc = oSysClass:convert2rur(INT(loan.currency),getRsrvBase(loan.cont-code,currDate,"debt"),currDate).

	IF baseCalc <> 0 OR showZero THEN DO:
	    i = i + 1.
   	    oTable1:addRow().
	      oTable1:addCell(i).
	      oTable1:addCell(loan.cont-code + (IF loan.currency <> oSysClass:getSetting("КодНацВал") AND loan.currency <> "" THEN "*" ELSE "")).
	      oTable1:addCell(oClient:name-short).
	      oTable1:addCell(baseCalc).
        END.

itog = itog + baseCalc.


DELETE OBJECT oClient.

END. /* END по всем договорам 1ого портфеля */
oTable1:addRow().
oTable1:addCell("ИТОГО:").
oTable1:addCell("").
oTable1:addCell("").
oTable1:addCell(itog).

/*****
 * Второй ПОС
 *****/
i = 0.
posName = getPosId("ПЛКарт",2).
itog = 0.
{pir-getlinpos.i cClassCode currDate posName}

oClient = new TClient(loan.cust-cat,loan.cust-id).

    baseCalc = oSysClass:convert2rur(INT(loan.currency),getRsrvBase(loan.cont-code,currDate,"baddebt"),currDate).

     IF baseCalc <> 0 OR showZero THEN DO:
        i = i + 1.
	oTable2:addRow().
	 oTable2:addCell(i).
	 oTable2:addCell(loan.cont-code).
	 oTable2:addCell(oClient:name-short + (IF loan.currency <> oSysClass:getSetting("КодНацВал") AND loan.currency <> "" THEN "*" ELSE "")).
	 oTable2:addCell(baseCalc).
    END.

DELETE OBJECT oClient.

itog = itog + baseCalc.

END. /* END по всем договорам 1ого портфеля */

oTable2:addRow().
oTable2:addCell("ИТОГО:").
oTable2:addCell("").
oTable2:addCell("").
oTable2:addCell(itog).

/*****
 * 3ий ПОС
 *****/
i    = 0.
itog = 0.
posName = getPosId("ПЛКарт",3).
{pir-getlinpos.i cClassCode currDate posName}

oClient = new TClient(loan.cust-cat,loan.cust-id).
  baseCalc = oSysClass:convert2rur(INT(loan.currency),getRsrvBase(loan.cont-code,currDate,"baddebt"),currDate).

    IF baseCalc <> 0 OR showZero THEN DO:
        i = i + 1.
	oTable3:addRow().
	 oTable3:addCell(i).
	 oTable3:addCell(loan.cont-code).
	 oTable3:addCell(oClient:name-short + (IF loan.currency <> oSysClass:getSetting("КодНацВал") AND loan.currency <> "" THEN "*" ELSE "")).
	 oTable3:addCell(baseCalc).
    END.

DELETE OBJECT oClient.
itog = itog + baseCalc.
END. /* END по всем договорам 1ого портфеля */
oTable3:addRow().
oTable3:addCell("ИТОГО:").
oTable3:addCell("").
oTable3:addCell("").
oTable3:addCell(itog).


/*****
 * 4ый ПОС
 *****/
i    = 0.
itog = 0.
posName = getPosId("ПЛКарт",4).
{pir-getlinpos.i cClassCode currDate posName}

oClient = new TClient(loan.cust-cat,loan.cust-id).

  baseCalc = oSysClass:convert2rur(INT(loan.currency),getRsrvBase(loan.cont-code,currDate,"baddebt"),currDate).

        IF baseCalc <> 0 OR showZero THEN DO:
           i = i + 1.
   	   oTable4:addRow().
   	    oTable4:addCell(i).
	    oTable4:addCell(loan.cont-code).
	    oTable4:addCell(oClient:name-short + (IF loan.currency <> oSysClass:getSetting("КодНацВал") AND loan.currency <> "" THEN "*" ELSE "")).
	    oTable4:addCell(baseCalc).
       END.

DELETE OBJECT oClient.
itog = itog + baseCalc.
END. /* END по всем договорам */

oTable4:addRow().
oTable4:addCell("ИТОГО:").
oTable4:addCell("").
oTable4:addCell("").
oTable4:addCell(itog).


/*****
 * 5ый ПОС
 *****/
i    = 0.
itog = 0.

posName = getPosId("ПЛКарт",5).
{pir-getlinpos.i cClassCode currDate posName}

oClient = new TClient(loan.cust-cat,loan.cust-id).

        baseCalc = oSysClass:convert2rur(INT(loan.currency),getRsrvBase(loan.cont-code,currDate,"baddebt"),currDate).

	IF baseCalc <> 0 OR showZero THEN DO:
                i = i + 1.
		oTable5:addRow().
		 oTable5:addCell(i).
		 oTable5:addCell(loan.cont-code).
		 oTable5:addCell(oClient:name-short + (IF loan.currency <> oSysClass:getSetting("КодНацВал") AND loan.currency <> "" THEN "*" ELSE "")).
		 oTable5:addCell(baseCalc).
	END.

DELETE OBJECT oClient.
itog = itog + baseCalc.
END. /* END по всем договорам 1ого портфеля */

oTable5:addRow().
oTable5:addCell("ИТОГО:").
oTable5:addCell("").
oTable5:addCell("").
oTable5:addCell(itog).


/*****
 * 6ый ПОС
 *****/
i    = 0.
itog = 0.
posName = getPosId("ПЛКарт",6).
{pir-getlinpos.i cClassCode currDate posName}

oClient = new TClient(loan.cust-cat,loan.cust-id).

  baseCalc = oSysClass:convert2rur(INT(loan.currency),getRsrvBase(loan.cont-code,currDate,"baddebt"),currDate).
        IF baseCalc <> 0 OR showZero THEN DO:
           i = i + 1.
   	   oTable6:addRow().
   	    oTable6:addCell(i).
	    oTable6:addCell(loan.cont-code).
	    oTable6:addCell(oClient:name-short + (IF loan.currency <> oSysClass:getSetting("КодНацВал") AND loan.currency <> "" THEN "*" ELSE "")).
	    oTable6:addCell(baseCalc).
       END.

DELETE OBJECT oClient.
itog = itog + baseCalc.
END. /* END по всем договорам */

oTable6:addRow().
oTable6:addCell("ИТОГО:").
oTable6:addCell("").
oTable6:addCell("").
oTable6:addCell(itog).

oTpl:addAnchorValue("currDate",currDate).
oTpl:addAnchorValue("TABLEPOS1",oTable1).
oTpl:addAnchorValue("TABLEPOS2",oTable2).
oTpl:addAnchorValue("TABLEPOS3",oTable3).
oTpl:addAnchorValue("TABLEPOS4",oTable4).
oTpl:addAnchorValue("TABLEPOS5",oTable5).
oTpl:addAnchorValue("TABLEPOS6",oTable6).

{tpl.show}

/**************
 * Отправка в архив
 **************/
&SCOPED-DEFINE arch2 1
{send2arch.i notmark=1}

DELETE OBJECT oTable1.
DELETE OBJECT oTable2.
DELETE OBJECT oTable3.
DELETE OBJECT oTable4.
DELETE OBJECT oTable5.
DELETE OBJECT oTable6.
DELETE OBJECT oSysClass.
{tpl.delete}
{intrface.del}