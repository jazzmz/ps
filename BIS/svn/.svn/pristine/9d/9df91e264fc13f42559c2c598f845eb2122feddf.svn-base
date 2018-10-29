/***************************
 * Справка на отчуждаемый
 * носитель.
 ***************************/
{bislogin.i}
{globals.i}
{intrface.get xclass}

/*DEF INPUT PARAM in-op-date LIKE op-date.op-date.*/
/*DEF INPUT PARAM oprid      AS   RECID.*/

DEF VAR dCount  AS INTEGER INITIAL 0 NO-UNDO. 
DEF VAR dCountInGr  AS INTEGER INITIAL 0 NO-UNDO. 

DEF VAR dSumRur AS DECIMAL INITIAL 0 NO-UNDO.
DEF VAR dSumVal AS DECIMAL INITIAL 0 NO-UNDO.

DEF VAR vOpRubLog AS LOGICAL INITIAL FALSE NO-UNDO.
DEF VAR vOpCurLog AS LOGICAL INITIAL FALSE NO-UNDO.

DEF VAR currDEVRees AS INT64 NO-UNDO.
DEF VAR currDEVId    AS INT64 NO-UNDO.

DEF VAR oSysClass AS TSysClass NO-UNDO.
oSysClass = new TSysClass().

/*** ЗАПРАШИВАЕМ ТИП ВАЛЮТЫ ***/
def frame fmVidOp with width 35 no-labels overlay centered row 9 /* top-only */
title color brigth-white "[ СПРАВКА В ЭЛЕКТРОННЫЙ АРХИВ ]".
form                                                            skip
    "   Формировать по операциям"                               skip(1)
    " " vOpRubLog label " Рублевым" view-as toggle-box
    " " vOpCurLog label " Валютным" view-as toggle-box          skip
with frame fmVidOp.

update vOpRubLog vOpCurLog with frame fmVidOp.
hide frame fmVidOp.

IF NOT vOpRubLog AND
   NOT vOpCurLog THEN	DO:
	MESSAGE "Необходимо выбрать тип валюты" VIEW-AS ALERT-BOX.
	RETURN "".
  END.


{tpl.create}
/*** ЗАПРАШИВАЕМ ДАТУ ***/
DEF VAR in-op-date AS DATE NO-UNDO.
DEF VAR cNum AS CHARACTER  NO-UNDO.
{getdate.i}
in-op-date = end-date.

/*
/*** ЗАПРАШИВАЕМ НОМЕР ЕХ ***/
RUN getnum.p("ВВЕДИТЕ НОМЕР ЕХД",OUTPUT cNum).
*/

cNum = oSysClass:DATETIME2STR(in-op-date,"%y%m%d").

/*
DEF FRAME frmMain
          "Введите номер ЕД:" cNum NO-LABEL
        WITH SIDE-LABELS CENTERED OVERLAY
        AT COL 5 ROW 5
        TITLE "Уникальный номер единицы хранения"
        SIZE 35 BY 3.

         .
ENABLE ALL WITH FRAME frmMain.

ON GO,RETURN OF cNum DO:
 cNum = cNum:SCREEN-VALUE.
END.


WAIT-FOR GO,RETURN OF cNum.

HIDE FRAME frmMain.
*/
/*** ***/

DEF VAR oTable  AS TTable NO-UNDO.
DEF VAR oTable2 AS TTable NO-UNDO.
DEF VAR oTable3 AS TTable NO-UNDO.

/***
  Объявляем переменные для подсчета ДЭВ.
  Следует учесть, что проводки из двух разных документов БИС, 
  могут входить в один ДЭВ
 ***/
DEF VAR iCountB AS INTEGER INITIAL 0 NO-UNDO. /*   БАЛАНС  */
DEF VAR iCountO AS INTEGER INITIAL 0 NO-UNDO. /* ВНЕБАЛАНС */
DEF VAR iCountf AS INTEGER INITIAL 0 NO-UNDO. /* СРОЧНЫЕ СДЕЛКИ */

DEF TEMP-TABLE tmpDoc NO-UNDO
             FIELD iRees  AS INTEGER
             FIELD iDEVId AS INTEGER
	     FIELD tacct-cat LIKE op.acct-cat
           .




/*** ПО БАЛАНСОВЫМ СЧЕТАМ ***/

oTable = new TTable(3).

   /*** ОТБИРАЕМ ДОКУМЕНТЫ ВЫГРУЖЕННЫЕ В АРХИВ БАЛАНС***/

   FOR EACH op WHERE op.op-date EQ in-op-date AND acct-cat EQ "b" NO-LOCK,
    EACH op-entry OF op NO-LOCK WHERE (vOpRubLog AND op-entry.currency EQ '') OR (vOpCurLog AND op-entry.currency<>'')
    BREAK BY SUBSTRING(op-entry.acct-db,1,5):

        /* ДОКУМЕНТ ВЫГРУЖЕН В АРХИВ */			
	IF INT64(getXAttrValue("op",STRING(op-entry.op),"PirA2346U")) > 1000 THEN DO:

	     currDEVRees = INT64(getXAttrValue("op",STRING(op.op),"PirA2346U")).
	     currDEVId   = INT64(getXAttrValueEx("op-entry",STRING(op.op) + "," + STRING(op-entry.op-entry),"PirDEVLink",STRING(op.op))).


             /* Итого по подкатегориям */
             ACCUMULATE  op-entry.op      (SUB-COUNT BY SUBSTRING(op-entry.acct-db,1,5)).
	     ACCUMULATE  op-entry.amt-rub (SUB-TOTAL BY SUBSTRING(op-entry.acct-db,1,5)).
	     ACCUMULATE  op-entry.amt-cur (SUB-TOTAL BY SUBSTRING(op-entry.acct-db,1,5)).
	     
	     ACCUMULATE op-entry.amt-rub (TOTAL).
	     ACCUMULATE op-entry.amt-cur (TOTAL).

	   IF LAST-OF(SUBSTRING(op-entry.acct-db,1,5)) THEN DO:
		oTable:addRow().
                oTable:addCell(SUBSTRING(op-entry.acct-db,1,5)).
		oTable:addCell((ACCUM SUB-TOTAL BY SUBSTRING(op-entry.acct-db,1,5) op-entry.amt-rub)).
		oTable:addCell((ACCUM SUB-TOTAL BY SUBSTRING(op-entry.acct-db,1,5) op-entry.amt-cur)).
	   END.


	   /*** 
		Формируем таблицу для подсчета ДЭВ 
		Формируем ее хитро, если проводка
		входит в сводный ДЭВ, то проверяем
		на наличие дублирующих записей.
		Иначе делаем как есть.
	   ***/
		
		    IF NOT CAN-FIND(FIRST tmpDoc WHERE iRees = currDEVRees AND iDEVId = currDEVId AND tacct-cat EQ "b") THEN DO:
			CREATE tmpDoc.
			tmpDoc.tacct-cat = "b".
			tmpDoc.iRees  = currDEVRees.
			tmpDoc.iDEVId = currDEVId.
		    END.

	END. /* IF getXAttrValue */
   END.      /* For each */

 oTable:addRow().
 oTable:addCell("ИТОГО:").
 oTable:addCell(ACCUM TOTAL op-entry.amt-rub).
 oTable:addCell(ACCUM TOTAL op-entry.amt-cur).

   /*** ОТБИРАЕМ ДОКУМЕНТЫ ВЫГРУЖЕННЫЕ В АРХИВ ВНЕБАЛАНС ***/

   oTable2 = new TTable(3).
   dCount = 0.


   FOR EACH op WHERE op.op-date EQ in-op-date AND acct-cat EQ "o" NO-LOCK,
    EACH op-entry OF op WHERE (vOpRubLog AND op-entry.currency EQ '') OR (vOpCurLog AND op-entry.currency<>'') NO-LOCK BREAK BY SUBSTRING(op-entry.acct-db,1,5) BY SUBSTRING(op-entry.acct-cr,1,5) BY op-entry.op:

        /* ДОКУМЕНТ ВЫГРУЖЕН В АРХИВ */			
	IF INT64(getXAttrValue("op",STRING(op.op),"PirA2346U")) > 1000 THEN DO:

	     currDEVRees = INT64(getXAttrValue("op",STRING(op.op),"PirA2346U")).
	     currDEVId   = INT64(getXAttrValueEx("op-entry",STRING(op.op) + "," + STRING(op-entry.op-entry),"PirDEVLink",STRING(op.op))).

             ACCUMULATE  op-entry.op      (SUB-COUNT BY SUBSTRING(op-entry.acct-db,1,5)).
	     ACCUMULATE  op-entry.amt-rub (SUB-TOTAL BY SUBSTRING(op-entry.acct-db,1,5)).
	     ACCUMULATE  op-entry.amt-cur (SUB-TOTAL BY SUBSTRING(op-entry.acct-db,1,5)).

             ACCUMULATE  op-entry.op      (SUB-COUNT BY SUBSTRING(op-entry.acct-cr,1,5)).
	     ACCUMULATE  op-entry.amt-rub (SUB-TOTAL BY SUBSTRING(op-entry.acct-cr,1,5)).
	     ACCUMULATE  op-entry.amt-cur (SUB-TOTAL BY SUBSTRING(op-entry.acct-cr,1,5)).


	     /* Итого по всем выгруженным в архив */

	     IF FIRST-OF(op-entry.op) THEN dCount = dCount + 1.
	     ACCUMULATE op-entry.amt-rub (TOTAL).
	     ACCUMULATE op-entry.amt-cur (TOTAL).


	   IF LAST-OF(SUBSTRING(op-entry.acct-db,1,5)) THEN DO:
	    IF CAN-DO("!99999*,!99998*,*",op-entry.acct-db) THEN DO:
		oTable2:addRow().
                oTable2:addCell(SUBSTRING(op-entry.acct-db,1,5)).
		oTable2:addCell((ACCUM SUB-TOTAL BY SUBSTRING(op-entry.acct-db,1,5) op-entry.amt-rub)).
		oTable2:addCell((ACCUM SUB-TOTAL BY SUBSTRING(op-entry.acct-db,1,5) op-entry.amt-cur)).
	     END.
	   END.

	   IF LAST-OF(SUBSTRING(op-entry.acct-cr,1,5)) THEN DO:
	     IF CAN-DO("!99999*,!99998*,*",op-entry.acct-cr) THEN DO:
		oTable2:addRow().
                oTable2:addCell(SUBSTRING(op-entry.acct-cr,1,5)).
		oTable2:addCell((ACCUM SUB-TOTAL BY SUBSTRING(op-entry.acct-cr,1,5) op-entry.amt-rub)).
		oTable2:addCell((ACCUM SUB-TOTAL BY SUBSTRING(op-entry.acct-cr,1,5) op-entry.amt-cur)).
	    END.


		    IF NOT CAN-FIND(FIRST tmpDoc WHERE iRees = currDEVRees AND iDEVId = currDEVId AND tacct-cat EQ "o") THEN DO:
			CREATE tmpDoc.
			tmpDoc.tacct-cat = "o".
			tmpDoc.iRees  = currDEVRees.
			tmpDoc.iDEVId = currDEVId.
		    END.

	   END.


	END.
   END.

 oTable2:addRow().
 oTable2:addCell("ИТОГО:").
 oTable2:addCell(ACCUM TOTAL op-entry.amt-rub).
 oTable2:addCell(ACCUM TOTAL op-entry.amt-cur).


   /*** ОТБИРАЕМ ДОКУМЕНТЫ ВЫГРУЖЕННЫЕ В АРХИВ СРОЧНЫЕ ***/

   oTable3 = new TTable(3).
   dCount = 0.


   FOR EACH op WHERE op.op-date EQ in-op-date AND acct-cat EQ "f" NO-LOCK,
    EACH op-entry OF op WHERE (vOpRubLog AND op-entry.currency EQ '') OR (vOpCurLog AND op-entry.currency<>'') NO-LOCK BREAK BY SUBSTRING(op-entry.acct-db,1,5) BY SUBSTRING(op-entry.acct-cr,1,5) BY op-entry.op: 
        /* ДОКУМЕНТ ВЫГРУЖЕН В АРХИВ */			
	IF INT64(getXAttrValue("op",STRING(op.op),"PirA2346U")) > 1000 THEN DO:

	     currDEVRees = INT64(getXAttrValue("op",STRING(op.op),"PirA2346U")).
	     currDEVId   = INT64(getXAttrValueEx("op-entry",STRING(op.op) + "," + STRING(op-entry.op-entry),"PirDEVLink",STRING(op.op))).

             ACCUMULATE  op-entry.op      (SUB-COUNT BY SUBSTRING(op-entry.acct-db,1,5)).
	     ACCUMULATE  op-entry.amt-rub (SUB-TOTAL BY SUBSTRING(op-entry.acct-db,1,5)).
	     ACCUMULATE  op-entry.amt-cur (SUB-TOTAL BY SUBSTRING(op-entry.acct-db,1,5)).

/*             ACCUMULATE  op-entry.op      (SUB-COUNT BY SUBSTRING(op-entry.acct-cr,1,5)).
	     ACCUMULATE  op-entry.amt-rub (SUB-TOTAL BY SUBSTRING(op-entry.acct-cr,1,5)).
	     ACCUMULATE  op-entry.amt-cur (SUB-TOTAL BY SUBSTRING(op-entry.acct-cr,1,5)). */


	     /* Итого по всем выгруженным в архив */

	     IF FIRST-OF(op-entry.op) THEN dCount = dCount + 1.
	     ACCUMULATE op-entry.amt-rub (TOTAL).
	     ACCUMULATE op-entry.amt-cur (TOTAL).


	   IF LAST-OF(SUBSTRING(op-entry.acct-db,1,5)) THEN DO:
	    IF CAN-DO("!99999*,!99998*,*",op-entry.acct-db) THEN DO:
		oTable3:addRow().
                oTable3:addCell(SUBSTRING(op-entry.acct-db,1,5)).
		oTable3:addCell((ACCUM SUB-TOTAL BY SUBSTRING(op-entry.acct-db,1,5) op-entry.amt-rub)).
		oTable3:addCell((ACCUM SUB-TOTAL BY SUBSTRING(op-entry.acct-db,1,5) op-entry.amt-cur)).
	     END.
	   END.

 /* Исключаем кредит */

/*	   IF LAST-OF(SUBSTRING(op-entry.acct-cr,1,5)) THEN DO:
	     IF CAN-DO("!99999*,!99998*,*",op-entry.acct-cr) THEN DO:
		oTable3:addRow().
                oTable3:addCell(SUBSTRING(op-entry.acct-cr,1,5)).
		oTable3:addCell((ACCUM SUB-TOTAL BY SUBSTRING(op-entry.acct-cr,1,5) op-entry.amt-rub)).
		oTable3:addCell((ACCUM SUB-TOTAL BY SUBSTRING(op-entry.acct-cr,1,5) op-entry.amt-cur)).
	    END.

*/
		    IF NOT CAN-FIND(FIRST tmpDoc WHERE iRees = currDEVRees AND iDEVId = currDEVId AND tacct-cat EQ "f") THEN DO:
			CREATE tmpDoc.
			tmpDoc.tacct-cat = "f".
			tmpDoc.iRees  = currDEVRees.
			tmpDoc.iDEVId = currDEVId.
		    END.

	   END. 


/*	END.*/
   END.

 oTable3:addRow().
 oTable3:addCell("ИТОГО:").
 oTable3:addCell(ACCUM TOTAL op-entry.amt-rub).
 oTable3:addCell(ACCUM TOTAL op-entry.amt-cur).



/*** ПРОСЧИТЫВАЕМ КОЛИЧЕСТВО ДОКУМЕНТОВ ПО БАЛАНСУ ***/
FOR EACH tmpDoc WHERE tacct-cat EQ "b" BREAK BY iRees:
 ACCUMULATE iDEVId (SUB-COUNT BY iRees).

    IF LAST-OF(tmpDoc.iRees) THEN DO:
       iCountB = iCountB + (ACCUM SUB-COUNT BY iRees iDEVId).
    END.

END.

/*** ПРОСЧИТЫВАЕМ КОЛИЧЕСТВО ДОКУМЕНТОВ ПО ВНЕБАЛАНСУ ***/
FOR EACH tmpDoc WHERE tacct-cat EQ "o" BREAK BY iRees:

 ACCUMULATE iDEVId (SUB-COUNT BY iRees).

    IF LAST-OF(tmpDoc.iRees) THEN DO:
          iCountO = iCountO + (ACCUM SUB-COUNT BY iRees iDEVId).
    END.
END.

/*** ПРОСЧИТЫВАЕМ КОЛИЧЕСТВО ДОКУМЕНТОВ ПО СРОЧНЫМ СДЕЛКАМ ***/
FOR EACH tmpDoc WHERE tacct-cat EQ "f" BREAK BY iRees:

 ACCUMULATE iDEVId (SUB-COUNT BY iRees).

    IF LAST-OF(tmpDoc.iRees) THEN DO:
          iCountf = iCountf + (ACCUM SUB-COUNT BY iRees iDEVId).
    END.
END.



oTpl:addAnchorValue("CURR-OPER-DATE",in-op-date).
oTpl:addAnchorValue("NUM",cNum).
oTpl:addAnchorValue("TABLE1",oTable).
oTpl:addAnchorValue("TABLE2",oTable2).
oTpl:addAnchorValue("TABLE3",oTable3).
oTpl:addAnchorValue("COUNT-BL",iCountB).
oTpl:addAnchorValue("COUNT-VB",iCountO).
oTpl:addAnchorValue("COUNT-SS",iCountf).
{tpl.show}

{intrface.del}
{tpl.delete}
DELETE OBJECT oSysClass.
/*** КОНЕЦ ПО БАЛАНСОВЫМ СЧЕТАМ ***/