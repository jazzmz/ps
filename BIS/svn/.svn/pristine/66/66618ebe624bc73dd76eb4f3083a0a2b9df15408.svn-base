/*******************************************************/
/* Функция выдает новое наименование счета с заданной ролью
   Вход:  iLnContCode : наименование договора
          iLnAcct     : счет
          iLnAcctType : роль счета
	  iOpDay      : дата, на которую определяются актуальные
			 данные для переименования
   Выход: новое наименование счета 			*/
/*******************************************************/

FUNCTION PirNewNameLoanAcct RETURNS CHARACTER 
	(INPUT iLnContCode AS CHARACTER,
	 INPUT iLnAcct     AS CHARACTER,
	 INPUT iOpDay      AS DATE
	).

  DEF VAR ofunc  AS tfunc  NO-UNDO.
  ofunc = new tfunc().

  DEF VAR oNewDet AS CHAR INIT "" NO-UNDO.

  DEF VAR cKlName AS CHAR NO-UNDO.
  DEF VAR cKDnum  AS CHAR NO-UNDO.
  DEF VAR cKDzakl AS CHAR NO-UNDO.
  DEF VAR cKDsrok AS CHAR NO-UNDO.
  DEF VAR grrisk  AS CHAR NO-UNDO.
  DEF VAR cKDkk   AS CHAR NO-UNDO.
  DEF VAR cKDrate AS CHAR NO-UNDO.

  DEFINE BUFFER bloan FOR loan .

  IF NUM-ENTRIES(iLnContCode,' ') > 1 THEN    
    cKDnum = ENTRY(1,iLnContCode,' ') .
  ELSE 
    cKDnum = iLnContCode .


  FIND FIRST bloan WHERE bloan.cont-code = cKDnum NO-LOCK NO-ERROR.

  cKlName = GetLoanInfo_ULL(bloan.contract, bloan.cont-code, "client_short_name", false) .
  cKDzakl = GetXattrValueEx("loan",STRING(bloan.contract + "," + bloan.cont-code),"ДатаСогл","__") .
  cKDnum = "КД " + cKDnum .

	/* Определяем категорию качества на дату пролонгации */
  grrisk = ofunc:getKRez(bloan.cont-code,iOpDay) .

  IF NUM-ENTRIES(grrisk,',') = 2 THEN    
    DO:
      cKDkk   = Entry(2,grrisk) .
    END.
  ELSE 
    DO:
      cKDkk   = "____" .
    END.

	/* Определяем проц.ставку на дату пролонгации */
  cKDrate = STRING(GetCredLoanCommission_ULL(bloan.cont-code, "%Кред", iOpDay, false) * 100 ,"99.99" ) .


  CASE SUBSTRING(iLnAcct,1,5) :
    WHEN "45201" OR WHEN "45202" OR WHEN "45203" OR WHEN "45204" OR WHEN "45205" OR WHEN "45206" OR WHEN "45207" OR WHEN "45208" OR WHEN "45209" OR WHEN "45502" OR WHEN "45503" OR WHEN "45504" OR WHEN "45505" OR WHEN "45506" OR WHEN "45507" OR WHEN "45508" OR WHEN "45701" OR WHEN "45702" OR WHEN "45703" OR WHEN "45704" OR WHEN "45705" OR WHEN "45706" OR WHEN "45707" OR WHEN "45709" THEN DO:
	cKDsrok = " с " + STRING(bloan.open-date,"99/99/9999") + " по " + STRING(bloan.end-date,"99/99/9999") .
	oNewDet = cKlName + " ссудный счет по " + cKDnum + " от " + cKDzakl + cKDsrok + "; на момент пролонгации к/к - " + cKDkk  + ", % ставка - " + cKDrate.
    END.
    WHEN "45509" OR WHEN "45708" THEN DO:
	oNewDet = cKlName + " ссудный счет по " + cKDnum + " от " + cKDzakl + ", % ставка - " + cKDrate.
    END.
  END CASE .

  DELETE OBJECT ofunc.

  RETURN oNewDet . 

END FUNCTION.



/*******************************************************/
/* Функция проверяет корректность простановки 
   доп.реков ВидРеструкт, КолРеструкт
   на договоре при пролонгации
   Вход:  iLnContCode : наименование договора
	  iLnKolProl  : количество пролонгаций по pro-obl
   Выход: результат проверки (либо "", либо "err")     */
/*******************************************************/

FUNCTION PirChkLoanDR RETURNS CHARACTER 
	(INPUT iLnContCode AS CHAR,
	 INPUT iLnKolProl  AS INT
	).

  DEF VAR oChkLoan AS CHAR INIT "err" NO-UNDO.
  DEF VAR VidRestr AS CHAR NO-UNDO.
  DEF VAR KolRestr AS CHAR NO-UNDO.
  DEF VAR cKDnum   AS CHAR NO-UNDO.

  DEFINE BUFFER bloan FOR loan .

  IF NUM-ENTRIES(iLnContCode,' ') > 1 THEN    
    cKDnum = ENTRY(1,iLnContCode,' ') .
  ELSE 
    cKDnum = iLnContCode .


  FIND FIRST bloan WHERE bloan.cont-code = cKDnum NO-LOCK NO-ERROR.

  VidRestr = GetXattrValueEx("loan",STRING(bloan.contract + "," + bloan.cont-code),"ВидРеструкт","") .
  KolRestr = GetXattrValueEx("loan",STRING(bloan.contract + "," + bloan.cont-code),"КолРеструкт","") .


  IF NOT(CAN-DO(VidRestr,"ПролОбСрДог"))  THEN
	RETURN oChkLoan  .

  IF NUM-ENTRIES(VidRestr,",") <> NUM-ENTRIES(KolRestr,",") THEN
    RETURN oChkLoan  .

  IF CAN-DO(VidRestr,"ПролОбСрДог")  THEN
    DO:
	IF STRING(iLnKolProl) <> ENTRY(LOOKUP("ПролОбСрДог", VidRestr),KolRestr,",") THEN
	  RETURN oChkLoan  .
    END.


    /* Если все проверки дали отрицательный результат (ветка else),
       то реквизиты стоят формально корректно, возвращаем "" */
  oChkLoan = "" . 
  RETURN oChkLoan.

END FUNCTION.


/* Функция возвращает код и соответсвующее наменование ошибки
   Вход:  типы проверки через запятую
   Выход: код + "-" + наменование ошибки
*/

FUNCTION PirErrCodeName RETURNS CHARACTER 
	(INPUT inewdetls AS CHAR,
	 INPUT ichkloan  AS CHAR
	).

  DEF VAR oErrCodeName AS CHAR INIT "" NO-UNDO.

  IF inewdetls = "" THEN
    DO:
	oErrCodeName = "01 - не удалось сформировать новое наименование счета"  .	
    END.

  IF ichkloan = "err" THEN
    DO:
	oErrCodeName = (if oErrCodeName <> "" then STRING(oErrCodeName + "; ") else "") 
			+ "02 - ошибка в ДР ВидРеструкт и КолРеструкт на договоре" .	
    END.


    /* Если ошибок не было, то вернем "" */
  RETURN oErrCodeName . 

END FUNCTION.
