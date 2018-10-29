/********************************************************
* Заявка #835
* Отчет для контроля ОВП.
* Автор: Маслов Д. А. Maslov D. A.
*********************************************************/

{globals.i}
{ulib.i}
{intrface.get instrum}
{intrface.get loan}
{intrface.get i254}


DEF VAR pkClassCodeMask AS CHARACTER INIT "l_agr_with_diff,loan_trans_diff" NO-UNDO.
DEF VAR stClassCodeMask AS CHARACTER INIT "loan_allocat,loan-transh"        NO-UNDO.

DEF VAR currDate AS DATE NO-UNDO.

DEF VAR oTablePk    AS TTable NO-UNDO.
DEF VAR oTableStd  AS TTable NO-UNDO.
DEF VAR cCurrencyMask AS CHARACTER INIT "840,978" NO-UNDO.

DEF VAR cParamList AS CHARACTER NO-UNDO.

DEF VAR RTVUSD     AS DECIMAL INIT 0 NO-UNDO.
DEF VAR RTVEUR     AS DECIMAL INIT 0 NO-UNDO.

DEF VAR oSysClass1 AS TSysClass NO-UNDO.

DEF VAR oa AS TAArray NO-UNDO.

DEF VAR oTableStdE AS TTable NO-UNDO.
DEF VAR oa1 AS TAArray NO-UNDO.
DEF VAR oa2 AS TAArray NO-UNDO.
DEF VAR i AS INT NO-UNDO.
DEF VAR value2 AS CHARACTER NO-UNDO.
DEF VAR key2 AS CHARACTER NO-UNDO.
DEF VAR showE AS LOGICAL NO-UNDO.

FUNCTION clear1 RETURNS LOGICAL(INPUT oa AS TAArray):
 DEF VAR i AS INTEGER NO-UNDO.
 DO i=1 TO NUM-ENTRIES(cParamList):
  oa:setH(ENTRY(i,cParamList),0).
 END.

END.


oSysClass1 = new TSysClass().
oa = new TAArray().
cParamList = oSysClass1:getSetting("Форма634","КредРез_Парам").

oa:setH("88","Линия").
oa:setH("21","Срочная задолженность").
oa:setH("46","Просроченная задолженность").
oa:setH("350","Нач. %").
oa:setH("351","Проср. %").
oa:setH("357","Пеня").
oa:setH("368","Пеня").

{tpl.create}
{pir-gp.i}

{getdate.i}
currDate = end-date.


DEF TEMP-TABLE tblReserv1 LIKE tblReserv.
pkClassCodeMask = REPLACE(oSysClass1:getSetting("ОверКлассТранз","КлОхватТранш"),"|",",").


/*************************************
 * №1. Резервы пластики пластики.
 *************************************/

EMPTY TEMP-TABLE tblReserv.

FOR EACH loan WHERE loan.contract = "Кредит" AND CAN-DO(pkClassCodeMask,loan.class-code)
                AND loan.open-date <= currDate
	        AND (loan.close-date >= currDate OR loan.close-date = ?)  
                AND CAN-DO("!Ц*,!CB*,*",loan.cont-code) AND CAN-DO("!ВексУчт,*",loan.cont-type)
		AND CAN-DO(cCurrencyMask,loan.currency)
            NO-LOCK:

	fillState(BUFFER loan:HANDLE,cParamList,currDate).	

END.
oTablePk = new TTable(5).
FOR EACH tblReserv BREAK BY param1:      
 ACCUMULATE tblReserv.value1 (TOTAL BY param1).  
 ACCUMULATE tblReserv.value1Usd (TOTAL BY param1).  
 ACCUMULATE tblReserv.value1Eur (TOTAL BY param1).  

 IF LAST-OF(param1) THEN DO:
  oTablePk:addRow().
  oTablePk:addCell(oa:get(STRING(param1))).
  oTablePk:addCell(param1).
  oTablePk:addCell(ACCUM TOTAL BY param1 tblReserv.value1).
  oTablePk:addCell(ACCUM TOTAL BY param1 tblReserv.value1Usd).
  oTablePk:addCell(ACCUM TOTAL BY param1 tblReserv.value1Eur).

  IF CAN-DO(cParamList,STRING(param1)) THEN DO:
	ASSIGN
          RTVUSD = RTVUSD + ACCUM TOTAL BY param1 tblReserv.value1Usd
	  RTVEUR = RTVEUR + ACCUM TOTAL BY param1 tblReserv.value1Eur
        .
   END.
 END.

END.

/*************************************
 * №2. Резервы классические кредиты.
 *************************************/

FOR EACH tblReserv:
  CREATE tblReserv1.
  BUFFER-COPY tblReserv TO tblReserv1.
END.

EMPTY TEMP-TABLE tblReserv.
FOR EACH loan WHERE loan.contract = "Кредит" AND NOT(CAN-DO(pkClassCodeMask,loan.class-code))
                AND loan.open-date <= currDate
	        AND (loan.close-date >= currDate OR loan.close-date = ?)  
                AND CAN-DO("!Ц*,!CB*,*",loan.cont-code) AND CAN-DO("!ВексУчт,*",loan.cont-type)
		AND CAN-DO(cCurrencyMask,loan.currency)
            NO-LOCK:

	fillState(BUFFER loan:HANDLE,cParamList,currDate).	

END.

FOR EACH tblReserv:
  CREATE tblReserv1.
  BUFFER-COPY tblReserv TO tblReserv1.
END.


oTableStd = new TTable(5).
FOR EACH tblReserv BREAK BY tblReserv.param1:      
 ACCUMULATE tblReserv.value1 (TOTAL BY tblReserv.param1).  
 ACCUMULATE tblReserv.value1Usd (TOTAL BY tblReserv.param1).  
 ACCUMULATE tblReserv.value1Eur (TOTAL BY tblReserv.param1).  

 IF LAST-OF(tblReserv.param1) THEN DO:

  oTableStd:addRow().
   oTableStd:addCell(oa:get(STRING(tblReserv.param1))).
   oTableStd:addCell(tblReserv.param1).
   oTableStd:addCell(ACCUM TOTAL BY tblReserv.param1 tblReserv.value1).
   oTableStd:addCell(ACCUM TOTAL BY tblReserv.param1 tblReserv.value1Usd).
   oTableStd:addCell(ACCUM TOTAL BY tblReserv.param1 tblReserv.value1Eur).

  IF CAN-DO(cParamList,STRING(tblReserv.param1)) THEN DO:
       ASSIGN
          RTVUSD = RTVUSD + ACCUM TOTAL BY tblReserv.param1 tblReserv.value1Usd
	  RTVEUR = RTVEUR + ACCUM TOTAL BY tblReserv.param1 tblReserv.value1Eur
       .
     END.
 END.
END.

/*** ВЫВОДИМ ИНФОРМАЦИЯ ***/
oTpl:addAnchorValue("kUsd",oSysClass1:getCBRKurs(840,currDate)).
oTpl:addAnchorValue("kEur",oSysClass1:getCBRKurs(978,currDate)).
oTpl:addAnchorValue("currDate",currDate).
oTpl:addAnchorValue("tbli",oTablePk).
oTpl:addAnchorValue("tblstd",oTableStd).
oTpl:addAnchorValue("paramList",cParamList).

oTpl:addAnchorValue("RTVUSD",RTVUSD).
oTpl:addAnchorValue("RTVEUR",RTVEUR).


{tpl.show}

MESSAGE "Выводить расшифровку отчета?" VIEW-AS ALERT-BOX BUTTONS YES-NO UPDATE showE.


IF showE THEN DO:

/*** РАСШИФРОВКА РАСЧЕТА ***/
{setdest.i}


oa1 = new TAArray().
oa2 = new TAArray().



oTableStdE = new TTable(2 * NUM-ENTRIES(cParamList) + 1).
oTableStdE:showItog=TRUE.

 oTableStdE:addRow().
  oTableStdE:addCell("Договор").
  oTableStdE:addCell("USD").
  oTableStdE:addCell("EUR").


  oTableStdE:addRow().
  oTableStdE:addCell("").
  DO i=1 TO NUM-ENTRIES(cParamList):
    oTableStdE:addCell(ENTRY(i,cParamList)).
  END.

  DO i=1 TO NUM-ENTRIES(cParamList):
    oTableStdE:addCell(ENTRY(i,cParamList)).
  END.


FOR EACH tblReserv1 BREAK BY ENTRY(1,tblReserv1.cont-code," ") BY tblReserv1.param1:      

  IF FIRST-OF(ENTRY(1,tblReserv1.cont-code," ")) THEN DO:
	clear1(oa1).
	clear1(oa2).
        oTableStdE:addRow().
        oTableStdE:addCell(ENTRY(1,tblReserv1.cont-code," ")).
  END.
 
	 oa1:setH(STRING(tblReserv1.param1),DECIMAL(oa1:get(STRING(tblReserv1.param1))) + tblReserv1.value1Usd).
	 oa2:setH(STRING(tblReserv1.param1),DECIMAL(oa2:get(STRING(tblReserv1.param1))) + tblReserv1.value1Eur).


  IF LAST-OF(ENTRY(1,tblReserv1.cont-code," ")) THEN DO:
	DO i=1 TO NUM-ENTRIES(cParamList):
          oTableStdE:addCell(DECIMAL(oa1:get(ENTRY(i,cParamList)))).
        END.


	DO i=1 TO NUM-ENTRIES(cParamList):
          oTableStdE:addCell(DECIMAL(oa2:get(ENTRY(i,cParamList)))).
	END.
      
  END.
END.

  oTableStdE:setAlign(2,1,"center").
  oTableStdE:setAlign(3,1,"center").

  oTableStdE:setColspan(2,1,NUM-ENTRIES(cParamList)).
  oTableStdE:setColspan(NUM-ENTRIES(cParamList) + 2,1,NUM-ENTRIES(cParamList)).

 oTableStdE:show().
 {preview.i}

END. /* showE = TRUE */


DELETE OBJECT oSysClass1 NO-ERROR.
DELETE OBJECT oTablePk NO-ERROR.
DELETE OBJECT oTableStd NO-ERROR.
DELETE OBJECT oTableStdE NO-ERROR.
DELETE OBJECT oa1 NO-ERROR.
DELETE OBJECT oa2 NO-ERROR.
DELETE OBJECT oa NO-ERROR.
{tpl.delete}

{intrface.del}