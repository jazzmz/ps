{pirsavelog.p}
/*************************************************************
 * Процедура установки дополнительного реквизита                          *
 * PirCheckPODFT в значение нет по расписанию.                                *
 *************************************************************
 * Алгоритм работы:                                                                                   *
 * 1. Идем по всем отрытым дням;                                                          *
 * 2. Ищем все документы с доп. реквизитом                                        *
 * PirCheckPODFT = ДА;                                                                             *
 * 3. Устанавливаем его в НЕТ                                                                 *
 *                                                                                                                      *
 * Автор: Маслов Д. А.                                                                                *
 * Дата создания: 12:10 26.07.2010                                                             *
 * Заявка: #391                                                                                              *
 *************************************************************
* Заявка: #431
* Дата создания: 13:56 21.09.2010
 *************************************************************
 * Заявка: #536
 * Дата создания: 11:40 18.11.2010
 *************************************************************/

DEF INPUT PARAM iParam AS CHAR.

{globals.i}
{intrface.get xclass}


DEF VAR oSysClass AS TSysClass NO-UNDO.
DEF VAR oDocHist  AS TDocHist  NO-UNDO.

/*******************  РИСОВАЛКИ  **********************/ 

DEF VAR oTpl       AS TTpl      NO-UNDO.
DEF VAR oTableGood AS TTableCSV NO-UNDO.
DEF VAR oTableBad  AS TTableCSV NO-UNDO.

/*************** КОНЕЦ РИСОВАЛОК *******************/

/************* СЛУЖЕБНЫЕ ПЕРЕМЕНЫЕ **************/

DEF VAR lRes          AS LOGICAL   INITIAL FALSE NO-UNDO.
DEF VAR iGoodDocCount AS INTEGER   INITIAL 0     NO-UNDO.
DEF VAR iBadDocCount  AS INTEGER   INITIAL 0     NO-UNDO.
DEF VAR cFioList      AS CHARACTER INITIAL ""    NO-UNDO.
DEF VAR cStatusList   AS CHARACTER INITIAL ""    NO-UNDO.
DEF VAR i             AS INTEGER                 NO-UNDO.
DEF VAR docDate	      AS DATE      		 NO-UNDO.

DEF VAR cFileName AS CHARACTER INITIAL "pir-chpircheckpodft.tmp" NO-UNDO.
DEF VAR cMailSystem AS CHARACTER INITIAL "/usr/sbin/sendmail -t" NO-UNDO.
DEF VAR cRec AS CHARACTER EXTENT 2 NO-UNDO.


cFileName   = ENTRY(1,iParam,';').
cMailSystem = ENTRY(2,iParam,";").

         /*** ПОЧТА ***/

cRec[1] = ENTRY(3,iParam,";").
cRec[2] = ENTRY(4,iParam,";").

/********* КОНЕЦ СЛУЖЕБНЫХ ПЕРЕМЕННЫХ ********/


oTpl = new TTpl("pir-chpircheckpodft.tpl").

oTableGood = new TTableCSV(9).
oTableBad = new TTableCSV(8).
oSysClass = new TSysClass().


OUTPUT TO VALUE(cFileName).

PUT UNFORMAT "To: " cRec[1] "," cRec[2] SKIP
                                    "Content-Type: text/plain; charset = ibm866" SKIP
                                    "Content-Transfer-Encoding: 8bit"
                                    SKIP
                                    "Subject: Установка доп. реквизита PirCheckPODFT в значение ДА  " STRING(TIME,"HH:MM:SS") "
                                    " TODAY "" SKIP(2).

PUT UNFORMAT STRING(TIME,"HH:MM:SS") ' : ' PROGRAM-NAME(1) ': Start'  SKIP.

FOR EACH signs WHERE file-name="op" AND code="PirCheckPODFT" AND code-value="Да" NO-LOCK,
    FIRST op WHERE op.op=INTEGER(signs.surrogate)  NO-LOCK,
        FIRST op-entry OF op NO-LOCK:

      ACCUMULATE op.op (COUNT).

        lRes = UpdateSigns("opb",STRING(op.op),"PirCheckPODFT","Нет",?). 

	lRes = true.

        oDocHist    = new TDocHist(op.op).
        cFIOList    = oDocHist:whoModifAttr("PirCheckPODFT").
	cStatusList = oDocHist:whoModifAttr("status").

        docDate = IF oDocHist:DocDate = ? THEN oDocHist:ins-date ELSE oDocHist:DocDate.


        DO i = 1 TO NUM-ENTRIES(cFIOList,","):                    
                        ENTRY(i,cFIOList) = oSysClass:getUserFIO(ENTRY(i,cFIOList),"F").
        END.

        DO i = 1 TO NUM-ENTRIES(cStatusList,","):                    
                        ENTRY(i,cStatusList) = oSysClass:getUserFIO(ENTRY(i,cStatusList),"F").
        END.



              IF lRes THEN
                        DO:
                                   oTableGood:addRow().
                                    oTableGood:addCell(docDate).
                                    oTableGood:addCell(TSysClass:getDateFirstClose(docDate)).
                                    oTableGood:addCell(TSysClass:getDateLastClose(docDate)).
                                    oTableGood:addCell(op.doc-num).
                                    oTableGood:addCell(cFIOList).
                                    oTableGood:addCell(op-entry.amt-rub).
                                    oTableGood:addCell(oSysClass:REPLACE_ASCII(oSysClass:REPLACE_ASCII(op.details,13,""),10,"")).
                                    oTableGood:addCell(oSysClass:getUserFIO(op.user-id,"F I")).
				    oTableGood:addCell(IF NUM-ENTRIES(cStatusList) = 0 THEN ENTRY(NUM-ENTRIES(cStatusList),cStatusList,",") ELSE oDocHist:doc-status).
                                    iGoodDocCount = iGoodDocCount + 1.
                        END.
                        ELSE
                            DO:
                                oTableBad:addRow().
                                    oTableBad:addCell(op.op-date).
                                    oTableBad:addCell(TSysClass:getDateFirstClose(docDate)).
                                    oTableBad:addCell(TSysClass:getDateLastClose(docDate)).
                                    oTableBad:addCell(op.doc-num).
                                    oTableBad:addCell(cFIOList).
                                    oTableBad:addCell(op-entry.amt-rub).
                                    oTableBad:addCell(oSysClass:REPLACE_ASCII(oSysClass:REPLACE_ASCII(op.details,13,""),10,"")).
                                    oTableBad:addCell(oSysClass:getUserFIO(op.user-id,"F I")).
                                    iBadDocCount = iBadDocCount + 1.
                            END.   

                DELETE OBJECT oDocHist.
 END.  /* Конец по всем документам с PirCheckPODF = ДА */

oTpl:addAnchorValue("GoodDocCount",iGoodDocCount).
IF oTableGood:HEIGHT <> 0 THEN  oTpl:addAnchorValue("TABLEGOOD",oTableGood). ELSE oTpl:addAnchorValue("TABLEGOOD","*** НЕТ ДАННЫХ ***").

oTpl:addAnchorValue("BadDocCount",iBadDocCount).
IF oTableBad:HEIGHT   <> 0 THEN oTpl:addAnchorValue("TABLEBAD",oTableBad).       ELSE oTpl:addAnchorValue("TABLEBAD","*** НЕТ ДАННЫХ ***"). 

oTpl:show().

PUT UNFORMAT STRING(TIME,"HH:MM:SS") ' : ' PROGRAM-NAME(1) ': Finish' SKIP.

IF OPSYS = "UNIX" THEN 
  DO:
         OS-COMMAND SILENT VALUE(cMailSystem + " < " + cFileName).
  END.

OS-DELETE VALUE(cFileName).
OUTPUT CLOSE.


oTableGood:SAVE-TO("/home2/bis/quit41d/imp-exp/doc/pir-chpircheckpodft-" + oSysClass:DATETIME2STR(TODAY,"%y%m%d") + ".txt").

DELETE OBJECT oSysClass.
DELETE OBJECT oTableGood.
DELETE OBJECT oTableBad.
DELETE OBJECT oTpl.