/************************************
 * Инструментарий для работы        *
 * с параметрами и состоянием КИД   *
 *				    *
 * Автор: Маслов Д. А. Maslov D. A. *
 * Заявка:                          *
 *************************************/
{intrface.get pkid}

DEF TEMP-TABLE tblReserv NO-UNDO
		FIELD cont-code  AS CHARACTER
		FIELD param1     AS INT
	        FIELD value1     AS DECIMAL
	        FIELD value1Usd  AS DECIMAL
	        FIELD value1Eur  AS DECIMAL
		.

EMPTY TEMP-TABLE tblReserv.

FUNCTION getParamINRur RETURNS DECIMAL(INPUT loanNum AS CHARACTER,INPUT p AS INT,INPUT dDate AS DATE):

END FUNCTION.

FUNCTION getParam RETURNS DECIMAL(INPUT loanNum AS CHARACTER,INPUT p AS INT,INPUT dDate AS DATE):

	DEF VAR vRes     AS DECIMAL NO-UNDO.
	DEF VAR vDbOpDec AS DECIMAL NO-UNDO.
	DEF VAR vCrOpDec AS DECIMAL NO-UNDO.

RUN STNDRT_PARAM (
        "Кредит",                 /* Назначение договора */
        loanNum,                  /* Номер договора */
        p,                        /* Код параметра  */
        dDate,                    /* Значение параметра на дату состояния договора */
        OUTPUT vRes,              /* Значение параметра без loan.interest[i] */
        OUTPUT vDbOpDec,          /* Е дб операций (не используется) */
        OUTPUT vCrOpDec).         /* Е кр операций (не используется) */

  RETURN vRes.
END FUNCTION.

/**
 * @param TEMP-TABLE tblReserv
 * @param CHARACTER loanContCode
 * @param INT v
 * @param INT vUsd
 * @param INT vEur
 * @return LOGICAL
 *
 * Добавляет строку в промежуточную таблицу.
 **/

FUNCTION addLine RETURNS LOGICAL(INPUT TABLE tblReserv,
				 INPUT loanContCode AS CHARACTER,
				 INPUT p AS INT,
			         INPUT v AS DECIMAL,
			         INPUT vUsd AS DECIMAL,
				 INPUT vEur AS DECIMAL):
  CREATE tblReserv.
      ASSIGN
          tblReserv.cont-code = loanContCode
          tblReserv.param1     = p
          tblReserv.value1     = v
          tblReserv.value1Usd  = vUsd
          tblReserv.value1Eur  = vEur
      .  
END FUNCTION.

/*********************************************
 * @param HANDLE bLoan 
 * @param CHARACTER cParamList
 * @param DATE currDate
 * @return VOID
 *
 * Заполняет временную таблицу параметрами
 * из договора на дату currDate.
 ********************************************/
FUNCTION fillState RETURNS LOGICAL(INPUT bLoan AS HANDLE,INPUT cParamList AS CHARACTER,INPUT currDate AS DATE):

     DEF VAR i             AS INT         NO-UNDO.
     DEF VAR lcc           AS CHARACTER   NO-UNDO.
     DEF VAR param1        AS INT         NO-UNDO.
     DEF VAR oSysClass     AS TSysClass   NO-UNDO.
     DEF VAR kUsd AS DECIMAL NO-UNDO.
     DEF VAR kEur AS DECIMAL NO-UNDO.

     DEF VAR pRur AS DECIMAL NO-UNDO.
     DEF VAR pUsd AS DECIMAL NO-UNDO.
     DEF VAR pEur AS DECIMAL NO-UNDO.
     oSysClass = new TSysClass().

	/***************************
	 * Получаем курсы.         *
	 ***************************/
	kUsd = oSysClass:getCBRKurs(840,currDate).
	kEur = oSysClass:getCBRKurs(978,currDate).
    

     lcc = IF NUM-ENTRIES(bLoan::cont-code," ") GT 1 THEN bLoan::cont-code ELSE bLoan::cont-code + " 0". 

     DO i = 1 TO NUM-ENTRIES(cParamList):
     param1 = INT(ENTRY(i,cParamList)).
     pRur = ABS(getParam(bLoan::cont-code,param1,currDate)).
     pUsd = IF bLoan::currency="840" THEN ROUND((ABS(getParam(bLoan::cont-code,param1,currDate)) / kUsd),2) ELSE 0.
     pEur = IF bLoan::currency="978" THEN ROUND((ABS(getParam(bLoan::cont-code,param1,currDate)) / kEur),2) ELSE 0.

        addLine(TABLE tblReserv BY-REFERENCE,lcc,param1,
			      			 pRur,
		   			         pUsd,
					         pEur
		).
     END.
 DELETE OBJECT oSysClass.
END FUNCTION.

FUNCTION getPosId RETURNS CHAR(INPUT cName AS CHAR,INPUT iNum  AS INT):
  RETURN DYNAMIC-FUNCTION("getPosId IN h_pkid",cName,iNum).
END FUNCTION.


FUNCTION getRsrvBase RETURNS DECIMAL (INPUT cLoan AS CHARACTER,INPUT currDate AS DATE,INPUT base AS CHARACTER):

	DEF VAR p0  AS DECIMAL NO-UNDO.
	DEF VAR p2  AS DECIMAL NO-UNDO.
	DEF VAR p7  AS DECIMAL NO-UNDO.
	DEF VAR p46 AS DECIMAL NO-UNDO.
	DEF VAR p10 AS DECIMAL NO-UNDO.
	DEF VAR p33 AS DECIMAL NO-UNDO.
	DEF VAR p35 AS DECIMAL NO-UNDO.
	DEF VAR p19 AS DECIMAL NO-UNDO.
	DEF VAR p27 AS DECIMAL NO-UNDO.

	CASE base:
	  WHEN "%" THEN DO:
	        p33  = getParam(cLoan,33,currDate).
	        p35  = getParam(cLoan,35,currDate).
		RETURN p33 + p35.
	  END.

	  WHEN "bad%" THEN DO:
	        p10  = getParam(cLoan,10,currDate).
		RETURN p10.
	  END.

	  WHEN "debt" THEN DO:
		p0   = getParam(cLoan,0,currDate).
		p2   = getParam(cLoan,2,currDate).
		RETURN p0 + p2.
	  END.

	  WHEN "baddebt" THEN DO:
		p7      = ABS(getParam(cLoan,7,currDate)).
		RETURN p7.
	  END.

	  WHEN "limit"   THEN DO:
	   /* Конечно это не правильный способ, 
	    * надо проверять тип линии и другие
	    * настройки, но для экономии времени
	    * пока сделаю так.
	    *************/
		p19 = getParam(cLoan,19,currDate).
		p27 = getParam(cLoan,27,currDate).
		RETURN p19.
	  END.

	  OTHERWISE DO:
		RETURN ?.
	  END.
      END. /* END CASE */


END FUNCTION.

FUNCTION getRsrv RETURNS DECIMAL (INPUT cLoan AS CHARACTER,INPUT currDate AS DATE,INPUT base AS CHARACTER):

 DEF VAR p21  AS DECIMAL NO-UNDO.
 DEF VAR p46  AS DECIMAL NO-UNDO.
 DEF VAR p350 AS DECIMAL NO-UNDO.
 DEF VAR p351 AS DECIMAL NO-UNDO.
 DEF VAR p88  AS DECIMAL NO-UNDO.

	CASE base:
	  WHEN "debt" THEN DO:
            p21 = ABS(getParam(cLoan,21,currDate)).
            RETURN p21.
	  END.	
	  WHEN "baddebt" THEN DO:
            p46 = ABS(getParam(cLoan,46,currDate)).
            RETURN p46.
	  END.	
	  WHEN "%" THEN DO:
            p350 = ABS(getParam(cLoan,350,currDate)).
            RETURN p350.
	  END.	
	  WHEN "bad%" THEN DO:
            p351 = ABS(getParam(cLoan,351,currDate)).
            RETURN p351.
	  END.	
	  WHEN "limit" THEN DO:
	        p88  = ABS(getParam(cLoan,88,currDate)).
	        RETURN p88.
	  END.
	  OTHERWISE DO:
		RETURN ?.
	  END.
        END CASE.
END FUNCTION.
