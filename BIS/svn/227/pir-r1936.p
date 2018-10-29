/*********************************************
 *
 * ���� �뢮��� �������� ॣ����
 * �� �।��� ������.
 *
 *********************************************
 * ����        : ��᫮� �. �. Maslov D. A.
 * ��� ���  : #1933
 * ��� ᮧ�����: 11.12.12
 *********************************************/

{globals.i}

DEF INPUT PARAM in-Data-Id LIKE DataBlock.Data-Id NO-UNDO.
DEF INPUT PARAM cParam                    AS CHAR NO-UNDO.

DEF VAR oReportBuilder   AS T1936 NO-UNDO.

DEF VAR dBegDate AS DATE    NO-UNDO.
DEF VAR dEndDate AS DATE    NO-UNDO.
DEF VAR oParam   AS TAArray NO-UNDO.

DEF VAR key1     AS CHAR    NO-UNDO.
DEF VAR val1     AS CHAR    NO-UNDO.

oParam = NEW TAArray().

oParam:loadSplittedList(cParam,"=",FALSE).

ASSIGN
  dBegDate = gbeg-date
  dEndDate = gend-date
 .


{tpl.create}
oReportBuilder = NEW T1936().

 ASSIGN
  oReportBuilder:condition=oParam:get("mask")
  oReportBuilder:dBegDate = dBegDate
  oReportBuilder:dEndDate = dEndDate
 .

oReportBuilder:build().

oTpl:addAnchorValue("tableIsIndepended",oReportBuilder:oTable2).
oTpl:addAnchorValue("tableIsDepend",oReportBuilder:oTable1).
oTpl:addAnchorValue("YEAR",{term2str oReportBuilder:dBegDate oReportBuilder:dEndDate}).
oTpl:addAnchorValue("calc%",STRING(ROUND(oReportBuilder:marketPrice,3) * 100,">>>,>>9.99")).

{foreach oParam key1 val1}
 oTpl:addAnchorValue(key1,val1).
{endforeach oParam}


{tpl.show}

{tpl.delete}
DELETE OBJECT oReportBuilder.
DELETE OBJECT oParam.