/* pir_ul_no_op6.p поиск клиентов не осуществляющих операции больше 6-ти месяцев
1.	теперь вводятся обе даты - начала и окончания периода - то есть можно задать любой произвольный период.
2.	формат чисел без разделителей триад (без запятых)
3.	последний столбец (Дата обновления анкеты клиента) в формате "dd.mm.yy" как и все остальные даты.
4.	для пользователя 07000gvv отчет копируется еще и в профиль gaman.
*/

{pirsavelog.p}

{globals.i}
{sh-defs.i}
{intrface.get xclass}

{uxelib.i}

DEF VAR gbeg-date_save AS DATE NO-UNDO.
DEF VAR gend-date_save AS DATE NO-UNDO.

gbeg-date_save = gbeg-date.
gend-date_save = gend-date.
DEF VAR PrevPeriodYear  AS INT NO-UNDO.
DEF VAR PrevPeriodMonth AS INT NO-UNDO.
gend-date = TODAY.
IF (MONTH(gend-date) - 6) < 1
  THEN  ASSIGN
	  PrevPeriodYear  = YEAR (gend-date) - 1
	  PrevPeriodMonth = MONTH(gend-date) + 6
	.
  ELSE ASSIGN
	  PrevPeriodYear  = YEAR (gend-date)
	  PrevPeriodMonth = MONTH(gend-date) - 6
	.
gbeg-date = DATE(PrevPeriodMonth, DAY(gend-date), PrevPeriodYear) + 1.
{getdates.i} /* !!! */
gbeg-date = gbeg-date_save.
gend-date = gend-date_save.

DEF VAR reportXmlCode AS CHAR.
DEF VAR sheetXmlCode AS CHAR.
DEF VAR rowsXmlCode AS CHAR.
DEF VAR cellsXmlCode AS CHAR.
DEF VAR styleXmlCode AS CHAR.
DEF VAR fileName  AS CHAR.
DEF VAR fileName1 AS CHAR.

fileName = "/home/bis/quit41d/imp-exp/users/" + lc(userid)
	   + "/ul_6_months.xls".
fileName1 = IF lc(userid) = "07000gvv"
	THEN "/home/bis/quit41d/imp-exp/users/" + "gaman" + "/fl_6_months.xls"
	ELSE "".

OUTPUT TO VALUE(fileName).
styleXmlCode = 	CreateExcelStyleEx("title1","Center", "Center", 2,"","B","") +
		CreateExcelStyleEx("title2","Center","Center", 2,"","B,U","") +
		CreateExcelStyle("Center",  "Center", 2, "title3") +
		CreateExcelStyle("Left",    "Center", 1, "cell1") +
		CreateExcelStyle("Right",   "Center", 1, "cell2")
				               .

PUT UNFORMATTED CreateExcelWorkbook(styleXmlCode).
PUT UNFORMATTED CreateExcelWorksheet("Лист1").
				
PUT UNFORMATTED 
	SetExcelColumnWidth( 1, 150) + /* Клиент */
	SetExcelColumnWidth( 2,  70) + /* ИНН */
	SetExcelColumnWidth( 3,  55) + /* Дата регистрации */
	SetExcelColumnWidth( 4,  75) + /* ОГРН */
	SetExcelColumnWidth( 5, 230) + /* Адрес места нахождения(регистрации) */
	SetExcelColumnWidth( 6,  90) + /* Номер контактного телефона */
	SetExcelColumnWidth( 7, 120) + /* Сведения об исполнительном органе */
	SetExcelColumnWidth( 8,  70) + /* ОКВЭД */
	SetExcelColumnWidth( 9, 130) + /* N счета */
	SetExcelColumnWidth(10,  70) + /* Дата открытия счета */
	SetExcelColumnWidth(11,  65) + /* Дата последней операции */
	SetExcelColumnWidth(12,  65) + /* Дата последней операции больше 10тыс.руб */
	SetExcelColumnWidth(13,  65) + /* Сумма остатка на счете */
	SetExcelColumnWidth(14,  70) + /* Клиент-банк */
	SetExcelColumnWidth(15,  50) + /* Присутствие по местонахожнению */
	SetExcelColumnWidth(16,  70) + /* Риск */
	SetExcelColumnWidth(17, 460) + /* Обоснование риска */
	SetExcelColumnWidth(18,  60)   /* Дата обновления анкеты клиента */
.

PUT UNFORMATTED CreateExcelRow(
		  CreateExcelCell("String","", 
"Клиенты не осуществляющие операции за период с " + STRING(beg-date, "99/99/99") + " по " + STRING(end-date, "99/99/99"))).

PUT UNFORMATTED CreateExcelRow(
			CreateExcelCell("String", "title1", "Клиент") +
			CreateExcelCell("String", "title1", "ИНН") +
			CreateExcelCell("String", "title1", "Дата регистрации") +
			CreateExcelCell("String", "title1", "ОГРН") +
			CreateExcelCell("String", "title1", "Адрес места нахождения(регистрации)") +
			CreateExcelCell("String", "title1", "Номер контактного телефона") +
			CreateExcelCell("String", "title1", "Сведения об исполнительном органе") +
			CreateExcelCell("String", "title1", "ОКВЭД") +
			CreateExcelCell("String", "title1", "N счета") +
			CreateExcelCell("String", "title1", "Дата открытия счета") +
			CreateExcelCell("String", "title1", "Дата последней операции") +
			CreateExcelCell("String", "title1", "Дата последней операции больше 10тыс.руб") +
			CreateExcelCell("String", "title1", "Сумма остатка на счете") +
			CreateExcelCell("String", "title1", "Клиент-банк") +
			CreateExcelCell("String", "title1", "Присутствие по местонахожнению") +
			CreateExcelCell("String", "title1", "Риск") +
			CreateExcelCell("String", "title1", "Обоснование риска") +
			CreateExcelCell("String", "title1", "Дата обновления анкеты клиента")
		).

/* {setdest.i} */

DEF BUFFER bacct-pos FOR acct-pos.

FOR EACH cust-corp
  NO-LOCK
 , EACH acct
  WHERE acct.cust-cat = "Ю"
    AND acct.cust-id  = cust-corp.cust-id
/*    AND	CAN-DO("40702978600002122093", acct.acct)
   AND	CAN-DO("40702810700001122269", acct.acct)  !!! */
    AND acct.close-date = ?
    AND acct.contract   = "Расчет"
    AND acct.currency   = ""
  NO-LOCK :
	/* поиск любой последней операции по его счету дебета или кредита */
	/* чтобы шло по индексам нельзя объеденять дебетовый и кредитовый счета в одном запросе */
	FIND LAST op-entry
  	  WHERE op-entry.acct-db   =  acct.acct
    	    AND op-entry.op-date   >= beg-date
    	    AND op-entry.op-date   <= end-date
    	    AND op-entry.op-status > 'А'
    	    AND op-entry.currency  = acct.currency
    	    AND op-entry.amt-rub   <> 0.0
  	  NO-LOCK NO-ERROR.
	IF NOT AVAIL op-entry THEN DO:
		FIND LAST op-entry
	  	  WHERE op-entry.acct-cr   = acct.acct
    	    	    AND op-entry.op-date   >= beg-date
    	    	    AND op-entry.op-date   <= end-date
	    	    AND op-entry.op-status > 'А'
	    	    AND op-entry.currency  = acct.currency
	    	    AND op-entry.amt-rub   <> 0.0
	  	  NO-LOCK NO-ERROR.
	END.

    	IF NOT AVAIL(op-entry) THEN DO: /* не было движений за последние полгода */
		DEF VAR v_last_op       AS DATE NO-UNDO.
		DEF VAR v_last_op10k	AS DATE NO-UNDO.
		DEF VAR v_OGRN  	AS CHAR NO-UNDO.
		DEF VAR v_OKVED 	AS CHAR NO-UNDO.
		DEF VAR v_tel 		AS CHAR NO-UNDO.
		DEF VAR v_IspOrgan 	AS CHAR NO-UNDO.
		DEF VAR v_KlBank        AS CHAR NO-UNDO.
		DEF VAR v_Risk 		AS CHAR NO-UNDO.
		DEF VAR v_ObosnRiska 	AS CHAR NO-UNDO.
		DEF VAR v_DataObnAnketi AS CHAR NO-UNDO.

		v_OGRN  = GetXAttrValueEx("cust-corp", 
                                	  STRING(cust-corp.cust-id), 
                                	  "ОГРН", 
                                	  "").

		v_OKVED = GetXAttrValueEx("cust-corp", 
                                	  STRING(cust-corp.cust-id), 
                                	  "ОКВЭД", 
                                	  "").

		v_tel = GetXAttrValueEx("cust-corp", 
                                	  STRING(cust-corp.cust-id), 
                                	  "tel", 
                                	  "").
		v_IspOrgan = GetXAttrValueEx("cust-corp", 
                                	  STRING(cust-corp.cust-id), 
                                	  "ИсполнОрган", 
                                	  "").
		v_KlBank = GetXAttrValueEx("cust-corp", 
                                	  STRING(cust-corp.cust-id), 
                                	  "КлБанк",
                                	  "нет").

		v_Risk = GetXAttrValueEx("cust-corp", 
                                	     STRING(cust-corp.cust-id), 
					     "РискОтмыв",
                                	     "").
		v_ObosnRiska = GetXAttrValueEx("cust-corp", 
                                	     STRING(cust-corp.cust-id), 
					     "ОценкаРиска", 
                                	     "").

		v_DataObnAnketi = GetXAttrValueEx("cust-corp", 
                                	     STRING(cust-corp.cust-id), 
					     "ДатаОбнАнкеты", 
                                	     "").
		/* переформатируем дату через точки и выбрасываем старшие 2 цифры года */
		v_DataObnAnketi = REPLACE(v_DataObnAnketi, "/", ".").
		IF LENGTH(v_DataObnAnketi) >= 10
			THEN v_DataObnAnketi = SUBSTR(v_DataObnAnketi, 1, 6) + SUBSTR(v_DataObnAnketi, 9).

      		RUN acct-pos IN h_base (acct.acct,
                              		acct.currency,
                              		end-date,
                              		end-date,
                              		gop-status
                             		).
		/* поиск любой последней операции по его счету дебета или кредита */
		/* чтобы шло по индексам нельзя объеденять дебетовый и кредитовый счета в одном запросе */
		FIND LAST op-entry
	  	  WHERE op-entry.acct-db   = acct.acct
	    	    AND op-entry.op-date   < beg-date
	    	    AND op-entry.op-status > 'А'
	    	    AND op-entry.currency  = acct.currency
	    	    AND op-entry.amt-rub   <> 0.0
	  	  NO-LOCK NO-ERROR.
		v_last_op = ?.
		IF AVAIL op-entry
	 	  THEN v_last_op = op-entry.op-date.

		FIND LAST op-entry
	  	  WHERE op-entry.acct-cr   = acct.acct
	    	    AND op-entry.op-date   < beg-date
	    	    AND op-entry.op-status > 'А'
	    	    AND op-entry.currency  = acct.currency
	    	    AND op-entry.amt-rub   <> 0.0
	  	  NO-LOCK NO-ERROR.
		v_last_op = IF AVAIL op-entry
	 	  			THEN (IF v_last_op = ?
						THEN op-entry.op-date
						ELSE MAX(v_last_op, op-entry.op-date)
					     )
	  				ELSE v_last_op.

		/* поиск любой последней операции > 10.000 руб. по его счету дебета или кредита */
		/* чтобы шло по индексам нельзя объеденять дебетовый и кредитовый счета в одном запросе */
		FIND LAST op-entry
	  	  WHERE op-entry.acct-db   = acct.acct
	    	    AND op-entry.op-date   < beg-date
	    	    AND op-entry.op-status > 'А'
	    	    AND op-entry.currency  = acct.currency
	    	    AND op-entry.amt-rub   > 10000.0
	  	  NO-LOCK NO-ERROR.
		v_last_op10k = ?.
		IF AVAIL op-entry
			THEN v_last_op10k = op-entry.op-date.
	
		FIND LAST op-entry
	  	  WHERE op-entry.acct-cr   = acct.acct
	    	    AND op-entry.op-date   < beg-date
	    	    AND op-entry.op-status > 'А'
	    	    AND op-entry.currency  = acct.currency
	    	    AND op-entry.amt-rub   > 10000.0
	  	  NO-LOCK NO-ERROR.
		v_last_op10k = IF AVAIL op-entry
	 	  			THEN (IF v_last_op10k = ?
						THEN op-entry.op-date
						ELSE MAX(v_last_op10k, op-entry.op-date)
					     )
	  				ELSE v_last_op10k.

        	DEF VAR v_cust-code-type AS CHARACTER   NO-UNDO INIT "АдрФакт,АдрЮр".
        	DEF VAR vAddress     AS CHARACTER   NO-UNDO EXTENT 2.
        	DEF VAR j            AS INT         NO-UNDO.
        	DO j = 1 TO NUM-ENTRIES(v_cust-code-type):
            		FIND FIRST cust-ident
                		WHERE (    cust-ident.close-date = ?
                    			OR cust-ident.close-date >= TODAY)
                    		AND cust-ident.class-code   = 'p-cust-adr'   
                    		AND cust-ident.cust-cat     = 'Ю'
                    		AND cust-ident.cust-id      = cust-corp.cust-id
                    		AND cust-ident.cust-code-type   = ENTRY(j, v_cust-code-type)   
                			NO-LOCK NO-ERROR.
            		vAddress[j] = (IF AVAIL cust-ident THEN cust-ident.issue ELSE "").
        	END.


/*		DISP
		.
		DOWN.
*/
		PUT UNFORMATTED CreateExcelRow(
            		CreateExcelCell("String", "cell1", cust-corp.name-short) +
            		CreateExcelCell("String", "cell1", cust-corp.inn) +
			CreateExcelCell("String", "cell1", STRING(date-in, "99.99.99")) +
			CreateExcelCell("String", "cell1", v_OGRN) +

            		CreateExcelCell("String", "cell1", vAddress[2]) + /* адрес - АдрЮр */
            		CreateExcelCell("String", "cell1", v_tel) + 
            		CreateExcelCell("String", "cell1", v_IspOrgan) +
            		CreateExcelCell("String", "cell1", v_OKVED) +
            		CreateExcelCell("String", "cell1", acct.acct) +

            		CreateExcelCell("String", "cell1", STRING(acct.open-date, "99.99.99")) +
            		CreateExcelCell("String", "cell1", STRING(v_last_op	, "99.99.99")) +
            		CreateExcelCell("String", "cell1", STRING(v_last_op10k	, "99.99.99")) +
            		CreateExcelCell("String", "cell1", REPLACE(STRING(-1 * sh-bal,"-zzzzzzzzzzzz9.99"), ' ', '')) +

            		CreateExcelCell("String", "cell1", v_KlBank) +	  /* Клиент-Банк */
			 /* присутствие по местонахождению */
            		CreateExcelCell("String", "cell1", (IF vAddress[1] = vAddress[2] THEN "да" ELSE "нет")) +
            		CreateExcelCell("String", "cell1", v_Risk) +
            		CreateExcelCell("String", "cell1", v_ObosnRiska) +
            		CreateExcelCell("String", "cell1", v_DataObnAnketi)
		).
    	END. /* IF NOT AVAIL(op-entry) THEN DO: -- не было движений за последние полгода */
END. /* FOR EACH cust-corp */

PUT UNFORMATTED CreateExcelRow(						
			CreateExcelCell("String","", "")).

PUT UNFORMATTED CloseExcelTag("Worksheet").

PUT UNFORMATTED CloseExcelTag("Workbook").
OUTPUT CLOSE.

IF fileName1 <> ""
  THEN OS-COPY VALUE(fileName) VALUE(fileName1).
