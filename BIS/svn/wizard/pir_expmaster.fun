/* ========================================================================= */
/** 
    Copyright: ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (C) 2011
     Filename: pir_expmaster.p
      Comment: Библиотека функций для процедур экспорт данных в МАСТЕР ДОГОВОРОВ
      Created: Ситов С.А., 08.02.2012 
     Modified: Sitov S.A., 02.08.2012 - #1184
     Modified: <Кто> <Когда [F7]> (Локальный код для поиска <уникальный_код>) 
               <Описание изменения>                                           
*/
/* ========================================================================= */


{globals.i}
{sh-defs.i}
{ulib.i}




/* ========================================================================= */
/** Подпрограмма печати строки для файла экспорта */

PROCEDURE Master_OutStr:
DEFINE  INPUT PARAMETER inStr AS CHARACTER NO-UNDO.

   inStr = inStr + CHR(13) + CHR(10).
   PUT UNFORMATTED CODEPAGE-CONVERT(inStr,"1251",SESSION:CHARSET).

END PROCEDURE.


PROCEDURE Master_OutStrUser:
DEFINE  INPUT PARAMETER inUserId AS CHARACTER NO-UNDO.

   RUN Master_OutStr("<user>").
   RUN Master_OutStr("username=" + GetUserInfo_ULL(inUserId, "fio", false) ).
   RUN Master_OutStr("usershortname=" + FIOShort_ULL(GetUserInfo_ULL(inUserId, "fio", false), false) ).
   RUN Master_OutStr("userpost=" + GetUserInfo_ULL(inUserId, "Должность", false) ).
   RUN Master_OutStr("</user>").

END PROCEDURE.


/* ========================================================================= */
  /** Функция возвращает Регион*/

FUNCTION Master_RegGNI RETURNS CHARACTER
   (INPUT cR AS CHARACTER):

   IF    (cR EQ ?)
      OR (cR EQ "")
      OR (cR EQ "77")
      OR (cR EQ "78")
      OR (cR EQ "0")
      OR (cR EQ "00000")
      OR (cR EQ "00040")
      OR (cR EQ "00045")
   THEN
      RETURN "".
   ELSE
      CASE LENGTH(cR):
         WHEN 2 THEN
            RETURN REPLACE(REPLACE(GetCodeName ("КодРегГНИ", cR), "область", "обл."), "автономный округ", "АО") + ",".
         WHEN 5 THEN
            RETURN REPLACE(REPLACE(GetCodeName ("КодРег",    cR), "область", "обл."), "автономный округ", "АО") + ",".
         OTHERWISE
            RETURN "".
      END CASE.
END.




/* ========================================================================= */
/** Функция преобразования адреса в формате КЛАДР к удобочитаемому виду                   
    Формат КЛАДР: индекс,район,город,нас.пункт,улица,дом,корпус,квартира,строение 
    Причем поля адреса сопровождаются дополнениями г,р-н,ул и т.д. */

FUNCTION Master_Kladr RETURNS CHARACTER
   (INPUT cReg AS CHARACTER, /* Country,GNI */
    INPUT cAdr AS CHARACTER):

   DEFINE VARIABLE cAdrPart AS CHARACTER EXTENT 9 INITIAL "" NO-UNDO.
   DEFINE VARIABLE cAdrKl   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE iI       AS INTEGER NO-UNDO.
   DEFINE VARIABLE iNzpt    AS INTEGER NO-UNDO.

   iNzpt = MINIMUM(NUM-ENTRIES(cAdr), 9).

   DO iI = 1 TO iNzpt:
      cAdrPart[iI] = ENTRY(iI, cAdr).
   END.

   IF (ENTRY(1, cReg) NE "RUS")
   THEN DO:
      FIND FIRST country
         WHERE (country.country-id EQ ENTRY(1, cReg))
         NO-LOCK NO-ERROR.
      cAdrKl = IF (AVAIL country) THEN TRIM(country.country-name) ELSE "".

      IF     (cAdrPart[1] NE "")
         AND (cAdrPart[1] NE "000000")
      THEN
         cAdrKl = TRIM(cAdrKl + "," + cAdrPart[1], ",").

      DO iI = 2 TO MINIMUM(iNzpt, 9) :
         IF (cAdrPart[iI] NE "") THEN cAdrKl = cAdrKl + "," + cAdrPart[iI].
      END.
   END.
   ELSE DO:
      cAdrKl = TRIM((IF ((cAdrPart[1] NE "") AND (cAdrPart[1] NE "000000"))
                     THEN (cAdrPart[1] + ",")
                     ELSE "")
                   + Master_RegGNI(ENTRY(2, cReg)), ",").
      DO iI = 2 TO MINIMUM(iNzpt, 5) :
         IF (cAdrPart[iI] NE "") THEN cAdrKl = cAdrKl + "," + cAdrPart[iI].
      END.

      IF     (cAdrPart[6] NE "")
         AND (iNzpt GE 6)
      THEN DO:
         iI = INTEGER(SUBSTRING(cAdrPart[6], 1, 1)) NO-ERROR.
         cAdrKl = cAdrKl
                + (IF (ERROR-STATUS:ERROR) THEN "," ELSE ",д.")
                + cAdrPart[6].
      END.

      IF     (cAdrPart[9] NE "")
         AND (iNzpt EQ 9)
      THEN DO:
         iI = INTEGER(SUBSTRING(cAdrPart[9], 1, 1)) NO-ERROR.
         cAdrKl = cAdrKl
                + (IF (ERROR-STATUS:ERROR) THEN "," ELSE ",стр.")
                + cAdrPart[9].
      END.

      IF     (cAdrPart[7] NE "")
         AND (iNzpt GE 7)
      THEN DO:
         iI = INTEGER(SUBSTRING(cAdrPart[7], 1, 1)) NO-ERROR.
         cAdrKl = cAdrKl
                + (IF (ERROR-STATUS:ERROR) THEN "," ELSE ",корп.")
                + cAdrPart[7].
      END.

      IF     (cAdrPart[8] NE "")
         AND (iNzpt GE 8)
      THEN DO:
         iI = INTEGER(SUBSTRING(cAdrPart[8], 1, 1)) NO-ERROR.
         cAdrKl = cAdrKl
                + (IF (ERROR-STATUS:ERROR) THEN "," ELSE ",кв.")
                + cAdrPart[8].
      END.
   END.

   RETURN TRIM(cAdrKl, ",").

END FUNCTION.




/* ========================================================================= */
/** Функция возвращает адрес клиента в формате функции Master_Kladr
    Входные параметры: Ид.клиента, ТипКлиента, ТипАдреса */

FUNCTION Master_GetClntAddr RETURNS CHARACTER
   (INPUT ClId    AS INTEGER, 
    INPUT ClType  AS CHARACTER,
    INPUT AdrType AS CHARACTER):

   DEFINE VARIABLE cT         AS CHARACTER NO-UNDO.
   DEFINE VARIABLE ClntAddr   AS CHARACTER INIT "" NO-UNDO.


   FIND LAST cust-ident
	WHERE (cust-ident.cust-cat     EQ ClType)
	AND (cust-ident.cust-id        EQ ClId)
	AND (cust-ident.cust-code-type EQ AdrType)
	AND (cust-ident.class-code     EQ "p-cust-adr")
	AND (cust-ident.close-date     EQ ?)
   NO-ERROR.

   IF (AVAIL cust-ident) THEN
	DO:
	   cT = GetXAttrValue("cust-ident", cust-ident.cust-code-type + ',' 
		+ cust-ident.cust-code + ',' + STRING(cust-ident.cust-type-num), "country-id") + ","
               	+ GetXAttrValue("cust-ident", cust-ident.cust-code-type + ',' 
		+ cust-ident.cust-code + ',' + STRING(cust-ident.cust-type-num), "КодРегГНИ").
	   ClntAddr = Master_Kladr(cT, cust-ident.issue) .
	END.

   RETURN ClntAddr.

END FUNCTION.



/* ========================================================================= */
/** Функция возвращает номер овердрафтного договора 
    по соответвующему карточному договору
    Входные параметры: Номер карточного договора       */

FUNCTION Master_GetCardDogOver RETURNS CHARACTER
   (INPUT DogCard    AS CHARACTER ):

   DEFINE VARIABLE DogOver AS CHARACTER NO-UNDO.

   DEFINE BUFFER qloan-acct FOR loan-acct.
   DEFINE BUFFER qloan FOR loan.
   DEFINE BUFFER tloan-acct FOR loan-acct.
   DEFINE BUFFER tloan FOR loan.


   FOR EACH qloan WHERE qloan.contract  EQ 'card-pers' 
	     AND qloan.cust-cat   EQ 'Ч'
	     AND qloan.class-code EQ "card-loan-pers"  
	     AND qloan.cont-code  EQ DogCard
   NO-LOCK,
   LAST qloan-acct OF qloan WHERE qloan-acct.currency EQ qloan.currency
			AND qloan-acct.acct-type  EQ STRING("SCS@" + qloan.currency)
   NO-LOCK:

   IF AVAIL (qloan-acct) THEN
      DO:

	FOR EACH tloan WHERE tloan.class-code EQ "l_agr_with_diff"
	NO-LOCK,
	LAST tloan-acct OF tloan 
		WHERE tloan-acct.acct    EQ  qloan-acct.acct
		AND tloan-acct.acct-type EQ "КредРасч"
	NO-LOCK:
/*
message  tloan.doc-ref " | " tloan.class-code " | " tloan.cont-code " | " tloan-acct.acct  view-as alert-box.
*/
		IF AVAIL (tloan) THEN
		  DogOver = tloan.cont-code .
		ELSE
		  DogOver ="".

	END.
      END.

   END.

   RETURN DogOver.

END FUNCTION.



/* ========================================================================= */
/** Функция возвращает платежный лимит по карточному договору
    Входные параметры: Номер карточного договора
    Комментарий: Если нет овердр. договора, то возвращается остаток на 40817/40820
		 Если есть оверд.договор, то берется еще и остаток 91317 с овердрафта 
*/

FUNCTION Master_GetDogCardPayLim RETURNS DECIMAL
   (INPUT DogCard    AS CHARACTER ):


   DEFINE VARIABLE Ost_408   AS DECIMAL INIT 0 NO-UNDO.
   DEFINE VARIABLE Ost_91317 AS DECIMAL INIT 0 NO-UNDO.
   DEFINE VARIABLE PayLim    AS DECIMAL INIT 0 NO-UNDO.
   DEFINE VARIABLE DogOver AS CHARACTER NO-UNDO.

   DEFINE BUFFER xloan FOR loan.
   DEFINE BUFFER xloan-acct FOR loan-acct.
/*
message "DogCard = " DogCard view-as alert-box.
*/
   FIND FIRST xloan WHERE xloan.cont-code EQ DogCard
		     AND  xloan.contract EQ "card-pers"
		     AND  xloan.class-code EQ "card-loan-pers"
   NO-LOCK NO-ERROR.

	/* Остаток на СпецКартСчете */
   FIND FIRST xloan-acct OF xloan WHERE 
		   xloan-acct.acct-type EQ STRING("SCS@" + xloan.currency )
   NO-LOCK NO-ERROR.

   IF AVAIL(xloan-acct) THEN
      DO:
	RUN acct-pos IN h_base (xloan-acct.acct,xloan-acct.currency,today,today,"√").

	IF xloan-acct.currency = "" THEN
		Ost_408 = ABS(sh-bal). 
	ELSE
		Ost_408 = ABS(sh-val).
      END.


	/* Проверяем есть ли договор Овердрафта */ 

   DogOver = Master_GetCardDogOver(DogCard)  .
/*
message "DogOver= " DogOver view-as alert-box.
*/
   IF ( DogOver <> "" ) THEN
   DO:
	/* Т.е. есть овердр. договор */

     FIND FIRST xloan WHERE xloan.cont-code EQ DogOver
		      AND  xloan.class-code EQ "l_agr_with_diff"
     NO-LOCK NO-ERROR.
	
     FIND LAST xloan-acct OF xloan WHERE 
		   xloan-acct.acct-type EQ "КредН"
     NO-LOCK NO-ERROR.

     IF AVAIL(xloan-acct) THEN
       DO:

	  RUN acct-pos IN h_base (xloan-acct.acct,xloan-acct.currency,today,today,"√").
	  IF xloan-acct.currency = "" THEN
		Ost_91317 = ABS(sh-bal). 
	  ELSE
		Ost_91317 = ABS(sh-val).
       END.

   END. /*    IF DogOver = ""  */

   PayLim = Ost_408 + Ost_91317 .
/*
message "Ost_408 = " Ost_408 " ; Ost_91317 = " Ost_91317 " ; PayLim = " PayLim view-as alert-box.
*/
   RETURN PayLim.

END FUNCTION.



/* ========================================================================= */
/** Функция определяет комиссию по сумме
    Входные параметры: код комиссии, валюта, дата, сумма, по которой берется комиссия 
    Добавлена в рамках реализации #1184
*/

FUNCTION GetKom RETURNS DECIMAL
  (INPUT iCode   AS CHARACTER , /* код комиссии */
   INPUT iCurr   AS CHARACTER , /* валюта */
   INPUT iDate   AS DATE ,	
   INPUT iAmnt   AS DECIMAL  ): /* сума */

   DEF VAR   oKom    AS DEC    NO-UNDO.

   DEF BUFFER bcommission FOR commission.
   DEF BUFFER bcomm-rate FOR comm-rate.

   FOR EACH bcommission
        WHERE bcommission.commission EQ iCode
        AND   bcommission.contract   EQ 'base'
        AND   bcommission.currency   EQ iCurr
   NO-LOCK BY bcommission.min-value DESC :

	IF iAmnt >= bcommission.min-value THEN
	DO:

	   FIND LAST bcomm-rate OF bcommission
	        WHERE bcomm-rate.branch-id = ''
	        AND   bcomm-rate.acct EQ '0'
	        AND   bcomm-rate.since <= iDate
	        AND   bcomm-rate.kau EQ ''
	        AND   bcomm-rate.filial-id EQ '0000'
	   NO-LOCK NO-ERROR.

	   IF bcomm-rate.rate-fixed = yes THEN /* "=" */ 
		oKom = bcomm-rate.rate-comm .
	   ELSE  /* "%" */ 
		oKom =  ROUND( bcomm-rate.rate-comm / 100 * iAmnt,2) .

	   LEAVE.

	END.

   END.

   IF oKom <> ? THEN
	RETURN oKom.
   ELSE 
	MESSAGE "Не определена сумма комиссии!" VIEW-AS ALERT-BOX.

END FUNCTION.