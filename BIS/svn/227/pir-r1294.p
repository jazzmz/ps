/*********************************************
 *
 * ���� �뢮��� �������� ॣ����
 * �� �।��� ������.
 *
 *********************************************
 * ����        : ��᫮� �. �. Maslov D. A.
 * ��� ���  : 1294
 * ��� ᮧ�����: 11.12.12
 *********************************************/

{globals.i}

DEF INPUT PARAM in-Data-Id LIKE DataBlock.Data-Id NO-UNDO.
DEF INPUT PARAM cParam                    AS CHAR NO-UNDO.

DEF VAR oReportBuilder   AS T1294 NO-UNDO.

DEF VAR dBegDate AS DATE    NO-UNDO.
DEF VAR dEndDate AS DATE    NO-UNDO.
DEF VAR oParam   AS TAArray NO-UNDO.

DEF VAR key1     AS CHAR    NO-UNDO.
DEF VAR val1     AS CHAR    NO-UNDO.

DEF VAR oTpl     AS TTpl    NO-UNDO.

DEF VAR currYear AS INT    NO-UNDO.


oParam = NEW TAArray().

oParam:loadSplittedList(cParam,"=",FALSE).

RUN getnum.p("������ ���",OUTPUT currYear).

oTpl = NEW TTpl(IF oParam:get("template") = ? THEN ENTRY(1,PROGRAM-NAME(1),".") + ".tpl" ELSE oParam:get("template")).

ASSIGN
  dBegDate = gbeg-date
  dEndDate = gend-date
 .





oReportBuilder = NEW T1294().

 ASSIGN
  oReportBuilder:condition=oParam:get("mask")
  oReportBuilder:dBegDate = dBegDate
  oReportBuilder:dEndDate = dEndDate
  oReportBuilder:currYear = currYear
 .

oReportBuilder:build().

oTpl:addAnchorValue("tableIsIndepended",oReportBuilder:oTable2).
oTpl:addAnchorValue("tableIsDepend",oReportBuilder:oTable1).
oTpl:addAnchorValue("YEAR",{term2str oReportBuilder:dBegDate oReportBuilder:dEndDate}).

oTpl:addAnchorValue("calc%",STRING(ROUND(oReportBuilder:marketPrice,2),">>>,>>9.99")).

{foreach oParam key1 val1}
 oTpl:addAnchorValue(key1,val1).
{endforeach oParam}

{tpl.show}

{tpl.delete}
DELETE OBJECT oReportBuilder.
DELETE OBJECT oParam.