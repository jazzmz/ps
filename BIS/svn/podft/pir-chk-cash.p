{pirsavelog.p}

/* ========================================================================= */
/** 
    Copyright: ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (C) 2012
     Filename: pir-chk-cash.p
      Comment: Контроль расходных наличных операций для ПодФТ
		Работает в рамках механизима визирования БИС (процедуры контроля при смене статусов)
		В класификаторе "ПроцедурыКонтр" код "Проверка9"
   Parameters: параметры для процедуры проверки документа и процедуры отправки письма
         Uses:
      Created: Sitov S.A., 26.04.2012
	Basis: # 946
     Modified: <Кто> <Когда [F7]> (Локальный код для поиска <уникальный_код>) 
               <Описание изменения>                                           
*/
/* ========================================================================= */



{globals.i}
{pir-statcash.i}

DEFINE PARAMETER BUFFER bop FOR op.  
DEFINE BUFFER dop FOR op.  
DEFINE BUFFER dop-entry FOR op-entry. 
 
DEFINE INPUT  PARAMETER iParam  AS CHARACTER NO-UNDO. 

DEFINE OUTPUT PARAMETER oResult AS LOGICAL NO-UNDO INIT YES.    /* YES - значит процедура контроля пропустит документ */


DEFINE VAR oFl		  AS LOGICAL NO-UNDO INIT NO. /* нельзя выдавать */
DEFINE VAR oFlSymb	  AS LOGICAL NO-UNDO INIT NO. /* разные кассовые символы */
DEFINE VAR oSumR	  AS DECIMAL INIT 0  NO-UNDO.
DEFINE VAR oSumV	  AS DECIMAL INIT 0  NO-UNDO.
DEFINE VAR oCur		  AS CHAR    INIT "" NO-UNDO.
DEFINE VAR oAcctDb	  AS CHAR    INIT "" NO-UNDO.
DEFINE VAR oAcctCr	  AS CHAR    INIT "" NO-UNDO.
DEFINE VAR oSymb	  AS CHAR    INIT "" NO-UNDO.
DEFINE VAR tmpOpTransaction   AS INT INIT 0 NO-UNDO.

DEFINE VAR KltrMaxSum AS CHARACTER NO-UNDO.
DEFINE VAR KltrMail   AS CHARACTER NO-UNDO.
DEFINE VAR ParMaxSum AS CHARACTER NO-UNDO.
DEFINE VAR ParMail   AS CHARACTER NO-UNDO.




/* =========================   РЕАЛИЗАЦИЯ   ================================= */


KltrMaxSum =  ENTRY(1,iParam,";") .
KltrMail   =  ENTRY(2,iParam,";") .


IF KltrMaxSum = "" OR KltrMail = "" THEN
   MESSAGE "Неверно заданы параметры процедуры контроля документов!" VIEW-AS ALERT-BOX.


  /* Определяем по классификаторам заданные значения: 
	ParMaxSum - максисмальная сумма 
	ParMail - пареметры отправки письма  */

FIND FIRST code WHERE code.class = "PirSightOP"
	AND code.code = KltrMaxSum
NO-LOCK NO-ERROR.
IF AVAIL code THEN ParMaxSum = code.val.

FIND FIRST code WHERE code.class = "PirSightOP"
	AND code.code = KltrMail
NO-LOCK NO-ERROR.
IF AVAIL code THEN ParMail = code.val.



	/* КОНТРОЛИРУЕМ ПРОВОДКИ */

FOR EACH op-entry OF bop 
	WHERE op-entry.acct-cr BEGINS "20202"
		AND
	      op-entry.acct-db BEGINS "4"
NO-LOCK:

/*message "op-entry " view-as alert-box. */

    IF NOT LOGICAL(FGetSetting("PirChkOpVis","Vs9AllChecks","YES")) THEN 
	LEAVE.

    IF op-entry.op-transaction = tmpOpTransaction THEN LEAVE.
    tmpOpTransaction = op-entry.op-transaction .

	/* Проверка на допустимость документа  */ 	
    IF op-entry.acct-db NE "" AND op-entry.acct-cr BEGINS "20202" THEN 
	DO:
	RUN ChkVerOp(INPUT bop.op-date, INPUT bop.op, INPUT bop.op-transaction,
		    OUTPUT oFl, OUTPUT oFlSymb, OUTPUT oSumR, OUTPUT oSumV, OUTPUT oCur, OUTPUT oAcctDb, OUTPUT oAcctCr, OUTPUT oSymb).
	END.

/*MESSAGE " oFl = "  oFl  VIEW-AS ALERT-BOX.*/

    /* Если в результате проверки на допустимость oFl = yes , то есть смысл выполнять следующие проверки 
	Иначе, сразу запрещаем проводить документ и отправляем письмо */
    IF oFl = YES THEN
	DO:

		/* Проверка на сумму */ 	
	    IF op-entry.acct-db NE "" AND op-entry.acct-cr BEGINS "20202" THEN 
		DO:
		RUN ChkCashPODFTMaxSum(INPUT oCur, INPUT oSumR, INPUT oSumV, INPUT ParMaxSum, OUTPUT oResult).
		END.

/*message "ChkCashPODFTMaxSum " oResult view-as alert-box.*/
		/* Проверка на исключение по журналу заявок */ 
	    IF oResult EQ NO  THEN 
		DO:
		RUN ChkCashPODFTStat(INPUT bop.op-date, INPUT oCur, INPUT oAcctDb, INPUT oSumR, INPUT oSumV, OUTPUT oResult).
		END.

/*message "ChkCashPODFTStat " oResult view-as alert-box.*/
		/* Проверка на исключение (выдача кредита ...) */ 
	    IF oResult EQ NO  AND oFlSymb = YES THEN 
		DO:
	        RUN ChkCashPODFTIskl(INPUT oAcctDb, INPUT oAcctCr, INPUT oSymb, INPUT bop.details, OUTPUT oResult).
		END.
/*message "ChkCashPODFTIskl " oResult view-as alert-box.*/
	END.
    ELSE 
	oResult = NO .
/*
MESSAGE 
  " Total oResult = " oResult 
VIEW-AS ALERT-BOX.
*/
	/* Если в итоге oResult = NO, то рассылаются уведомления при срабатывании процедуры контроля */ 
    IF oResult EQ NO  THEN 
	DO:
	RUN VALUE( STRING(ENTRY(1,ParMail,";")) )(INPUT STRING(ENTRY(2,ParMail,";") + ";" + ENTRY(3,ParMail,";") + ";" + ENTRY(4,ParMail,";") + ";" + STRING(bop.op) + ";" + STRING(bop.op-transaction)  ))  NO-ERROR.
	END.

END.



/* =========================   ПРОЦЕДУРЫ   ================================= */

PROCEDURE ChkVerOp:
   DEFINE INPUT PARAMETER  iOpOpDate	  AS DATE      NO-UNDO.
   DEFINE INPUT PARAMETER  iOpOp	  AS INTEGER   NO-UNDO.
   DEFINE INPUT PARAMETER  iOpTranz	  AS INTEGER   NO-UNDO.
   DEFINE OUTPUT PARAMETER oFl		  AS LOGICAL NO-UNDO INIT NO. /* нельзя выдавать */
   DEFINE OUTPUT PARAMETER oFlSymb	  AS LOGICAL NO-UNDO INIT NO. /* разные кассовые символы */
   DEFINE OUTPUT PARAMETER oSumR	  AS DECIMAL INIT 0  NO-UNDO.
   DEFINE OUTPUT PARAMETER oSumV	  AS DECIMAL INIT 0  NO-UNDO.
   DEFINE OUTPUT PARAMETER oCur		  AS CHAR    INIT "_" NO-UNDO.
   DEFINE OUTPUT PARAMETER oAcctDb	  AS CHAR    INIT "" NO-UNDO.
   DEFINE OUTPUT PARAMETER oAcctCr	  AS CHAR    INIT "" NO-UNDO.
   DEFINE OUTPUT PARAMETER oSymb	  AS CHAR    INIT "" NO-UNDO.


   DEF VAR cnt  AS INT INIT 0 NO-UNDO.

oSymb = "" .

   FIND FIRST dop 
	WHERE dop.op EQ iOpOP
	AND dop.op-transaction EQ iOpTranz
   NO-LOCK NO-ERROR.
	 
   FOR EACH dop-entry OF dop 
	WHERE dop-entry.acct-db BEGINS "4"
	AND   dop-entry.acct-cr BEGINS "20202"
   NO-LOCK:

	cnt = cnt + 1 .
 /*message " - count = " cnt " " dop-entry.symbol " " dop-entry.amt-rub VIEW-AS ALERT-BOX. */

	IF cnt = 1 THEN 
	DO:
 /*message "1 oFlSymb = " oFlSymb  "  oSymb= " oSymb "  " dop-entry.symbol VIEW-AS ALERT-BOX.*/
	   oSumR = dop-entry.amt-rub  .
	   oSumV = dop-entry.amt-cur  .
	   oCur  = dop-entry.currency .
	   oAcctDb = dop-entry.acct-db .
	   oAcctCr = dop-entry.acct-cr .
	   oSymb = dop-entry.symbol .
/*message "1end oFlSymb = " oFlSymb  "  oSymb= " oSymb "  " dop-entry.symbol VIEW-AS ALERT-BOX.*/
	END.

	IF cnt > 1 
	   AND oCur = dop-entry.currency 
	   AND oAcctDb = dop-entry.acct-db 
	   AND oAcctCr = dop-entry.acct-cr
	THEN
	DO:
/*message "bol 1 oFlSymb = " oFlSymb  "  oSymb= " oSymb "  " dop-entry.symbol VIEW-AS ALERT-BOX.*/
	   oFl = yes .	
	   oSumR = oSumR + dop-entry.amt-rub  .
	   oSumV = oSumV + dop-entry.amt-cur  .

	   IF oSymb = dop-entry.symbol  THEN
		   oFlSymb = yes .	
	   ELSE 
		   oFlSymb = no .	

/*message "bol 1end oFlSymb = " oFlSymb  "  oSymb= " oSymb "  " dop-entry.symbol VIEW-AS ALERT-BOX.*/
	END.

   END.

   IF cnt = 1 THEN 
   DO:
      oFl = yes .	
      oFlSymb = yes .	
   END.
/*
MESSAGE "END_ChkVerOp " 
  "oFl	 " oFl	
  "oSumR " oSumR	
  "oSumV " oSumV	
  "oCur	 " oCur	
  "oAcctDb " oAcctDb	
  "oAcctCr " oAcctCr	
  "oFlSymb " oFlSymb 
VIEW-AS ALERT-BOX.
*/
END PROCEDURE.



PROCEDURE ChkCashPODFTMaxSum:
   DEFINE INPUT PARAMETER  iOpEntrCur     AS CHARACTER NO-UNDO.
   DEFINE INPUT PARAMETER  iOpEntrAmtrub  AS DECIMAL   NO-UNDO.
   DEFINE INPUT PARAMETER  iOpEntrAmtcur  AS DECIMAL   NO-UNDO.
   DEFINE INPUT PARAMETER  pParam         AS CHARACTER NO-UNDO.
   DEFINE OUTPUT PARAMETER oResult   AS LOGICAL NO-UNDO INIT YES.

   DEF VAR MaxSumRUB AS DEC NO-UNDO.
   DEF VAR MaxSumUSD AS DEC NO-UNDO.
   DEF VAR MaxSumEUR AS DEC NO-UNDO.

   MaxSumRUB = DEC(ENTRY(1,pParam,";")) .
   MaxSumUSD = DEC(ENTRY(2,pParam,";")) .
   MaxSumEUR = DEC(ENTRY(3,pParam,";")) . 
   
   
   IF MaxSumRUB = ? OR MaxSumUSD = ? OR MaxSumEUR = ?  THEN
     DO:
   	MESSAGE "НЕ ЗАДАНА СУММА ДЛЯ КОНТРОЛЯ !!!" VIEW-AS ALERT-BOX.
   	RETURN.
     END.

   CASE iOpEntrCur:
      WHEN "" THEN DO:
	IF (iOpEntrAmtrub ) > MaxSumRUB THEN oResult = NO .
      END.	
      WHEN "840" THEN DO:
	IF (iOpEntrAmtcur ) > MaxSumUSD THEN oResult = NO .
      END.
      WHEN "978" THEN DO:
	IF (iOpEntrAmtcur ) > MaxSumEUR THEN oResult = NO .
      END.
   END CASE.    
/*
 MESSAGE "END_ChkCashPODFTMaxSum = " oResult VIEW-AS ALERT-BOX.
*/
END PROCEDURE.


PROCEDURE ChkCashPODFTStat:
   DEFINE INPUT PARAMETER  iOpDate        AS DATE      NO-UNDO.
   DEFINE INPUT PARAMETER  iOpEntrCur     AS CHARACTER NO-UNDO.
   DEFINE INPUT PARAMETER  iAcctDb  	  AS CHARACTER NO-UNDO.
   DEFINE INPUT PARAMETER  iOpEntrAmtrub  AS DECIMAL   NO-UNDO.
   DEFINE INPUT PARAMETER  iOpEntrAmtcur  AS DECIMAL   NO-UNDO.
   DEFINE OUTPUT PARAMETER oResult   AS LOGICAL NO-UNDO INIT NO.

   DEF VAR pOpDate AS CHAR  NO-UNDO.
   DEF VAR pCdCode AS CHAR  NO-UNDO.
   DEF VAR begCdCode AS CHAR  NO-UNDO.
   DEF VAR pKlID AS CHAR NO-UNDO.
   DEF VAR pCurr AS CHAR NO-UNDO.
   DEF VAR pSum  AS DEC  NO-UNDO.

   DEF BUFFER pbcode  FOR code.

   pOpDate = CreateStrOpDtStCash(iOpDate) .
   pCdCode = CreateCdCodeStCash(iAcctDb, pOpDate) .
   begCdCode = ENTRY(1,pCdCode,"_") + "_" + ENTRY(2,pCdCode,"_") + "_" 
	   + ENTRY(3,pCdCode,"_") + "_" + ENTRY(4,pCdCode,"_") + "_"   
	   + ENTRY(5,pCdCode,"_") .

   FIND FIRST acct WHERE acct.acct = iAcctDb NO-LOCK NO-ERROR.

   IF AVAIL(acct) THEN
     DO:
	pKlID = STRING(acct.cust-id) .
	IF iOpEntrCur = "" THEN 
	  DO:
	    pCurr = "810" .
	    pSum = iOpEntrAmtrub .
	  END.
	ELSE 
	  DO:
	    pCurr = iOpEntrCur .
	    pSum = iOpEntrAmtCur .
	  END.
     END.

   FOR EACH pbcode 
	WHERE pbcode.class  EQ 'PirStatCash' 
	AND pbcode.parent EQ pOpDate  
	AND pbcode.code   BEGINS begCdCode 
   NO-LOCK:

	IF AVAIL(pbcode) THEN
	  DO:                   
		IF      ENTRY(1,pbcode.name,";") = iAcctDb 
		   AND  DEC(ENTRY(2,pbcode.name,";")) >= pSum   
		   AND  ENTRY(2,pbcode.description[1],";") = "ACT"
		   AND  ( 
			  ( ENTRY(1,pbcode.val,";") = "УТВЕРЖДЕНА" AND  ENTRY(1,pbcode.description[1],";") = "1" )
			  OR
			  ( ENTRY(1,pbcode.description[1],";") = "1" AND  ENTRY(4,pbcode.name,";") = "RUK" )
			)		
		THEN
		DO:
		  /* меняем статус заявки в журнале заявок */
		   FOR FIRST code 
			WHERE code.class  EQ 'PirStatCash' 
			AND code.parent EQ pOpDate
			AND code.code   BEGINS pbcode.code
		   EXCLUSIVE-LOCK:
			code.val = EditCdValStCash("ВЫДАЕТСЯ","") .
			code.name = EditCdNameStCash(code.name,"KAS","","") .		
			code.description[1] = "0;NOACT;" + ENTRY(3,code.description[1],";") + ";" . /* признак, что уже нельзя выдавать и что она уже неактивная */
		   END.

		   oResult = YES .
	
		END.
	  END.

   END.
/*
 MESSAGE "END_ChkCashPODFTStat = " oResult VIEW-AS ALERT-BOX. 
*/
END PROCEDURE.


PROCEDURE ChkCashPODFTIskl:
   DEFINE INPUT PARAMETER  iAcctDb     AS CHARACTER NO-UNDO.
   DEFINE INPUT PARAMETER  iAcctCr     AS CHARACTER NO-UNDO.
   DEFINE INPUT PARAMETER  iOpEntrSymb AS CHARACTER NO-UNDO.
   DEFINE INPUT PARAMETER  iOpDetails  AS CHARACTER NO-UNDO.
   DEFINE OUTPUT PARAMETER oResult   AS LOGICAL NO-UNDO INIT YES.


	/*  Касса, ден средства в пути */
   IF iAcctDb BEGINS "202" AND iAcctCr BEGINS "20202" THEN
	DO:
	LEAVE.
	END.


/*** Скорректировано по решению, принятому на совещании 12/05/12 ***/
	/*  Выдача депозита прямо через кассу */
   IF (iAcctDb BEGINS "423") AND (NOT(iAcctDb BEGINS "42301")) AND (iAcctCr BEGINS "20202") THEN
	DO:
	LEAVE.
	END.


	/* Выдача кредитных средств через кассу - опредл-ся по кас.символу */
	/* 54 - Выдачи займов и кредитов */
   IF iOpEntrSymb = "54" 
      AND iAcctCr BEGINS "20202" 
      AND CAN-DO("40817,40820,42301,42601",SUBSTRING(iAcctDB,1,5) )
      AND iOpDetails MATCHES "*кредит*"
   THEN
	DO:
	LEAVE.
	END.


	/* Если проводка не попала ни под одно из исключений,
	то выходим с признаком oResult = NO - т.е. попадает под контроль и отсылается письмо */ 
   oResult = NO .

/*
 message "END_ChkCashPODFTIskl = " oResult view-as alert-box. 
*/

END PROCEDURE.
