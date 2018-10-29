
/***** ================================================================= *****/
/*** 	Процедура редактирования журнала заявок на выдачу наличных 
	по кассе (классификатор PirStatCash) сотрудником ПодФТ
	Входной параметр - дата оп.дня журнала (ГГГГММДД - тип CHAR)
	Запуск - из процедуры pir-statcash.p (с параметром 2)              ***/
/***** ================================================================= *****/
{globals.i}
{ulib.i}
{pir-statcash.i}
{tmprecid.def}


/***** ================================================================= *****/
/*** 	          ВХОДНЫЕ ПАРАМЕТРЫ, ПЕРЕМЕННЫЕ И ПР.                      ***/
/***** ================================================================= *****/

DEF INPUT PARAM iOpDate AS CHAR.
/* MESSAGE "pir-statcash-podft.p  INPUT PARAM iOpDate = "  iOpDate VIEW-AS ALERT-BOX. */

DEF VAR cCause1 AS CHAR    NO-UNDO.
DEF VAR cCause2 AS CHAR    NO-UNDO.
DEF VAR vvod_ok AS LOGICAL NO-UNDO.

DEF VAR mAcct   AS CHAR NO-UNDO.   
DEF VAR mAcctID AS CHAR NO-UNDO.   
DEF VAR mAcctCustCat AS CHAR NO-UNDO. 

DEF FRAME fCause1 
	"Причина:"	cCause1	FORMAT "X(60)" SKIP(1) 
  WITH CENTERED NO-LABELS TITLE "ВВЕДИТЕ ПРИЧИНУ".

DEF FRAME fCause2 
	"Причина:"	cCause2	FORMAT "X(60)" SKIP(1) 
  WITH CENTERED NO-LABELS TITLE "ВВЕДИТЕ ПРИЧИНУ ОТКАЗА".

DEF VAR TERMINAL-SIMULATION AS WIDGET-HANDLE NO-UNDO.

DEF QUERY qItem FOR code.

DEF BROWSE brwItem QUERY qItem 

DISPLAY	
	(IF NUM-ENTRIES(code.name,";") >= 4 THEN ENTRY(4,code.name,";") ELSE "" ) FORMAT "x(5)" LABEL "ИЗМ"
	GetClientInfo_ULL(ENTRY(3,code.code,"_") + "," + ENTRY(1,code.code,"_"), "name", false)  format "x(25)" LABEL "Клиент"
	ENTRY(1,code.name,";") format "x(20)" LABEL "Счет"
	DECIMAL(ENTRY(2,code.name,";")) format ">>>,>>>,>>>,>99.99" LABEL "Сумма"
	ENTRY(3,code.name,";") format "x(25)" LABEL "Вид расчета"
	ENTRY(1,code.val ,";") format "x(20)" LABEL "Статус ПодФТ"
	(IF NUM-ENTRIES(code.val ,";") >= 3 THEN STRING(ENTRY(2,code.val ,";") + " " +  ENTRY(3,code.val ,";")) ELSE "" ) FORMAT "x(70)" LABEL "Причина"
	ENTRY(5,code.name,";") FORMAT "x(10)" LABEL "Разрешил завести онлайн завку"
	(IF NUM-ENTRIES(code.description[1],";") >= 3 THEN ENTRY(3,code.description[1],";") ELSE "" ) format "x(20)" LABEL "Утвердил член Правления"
WITH 10 DOWN WIDTH 73 NO-LABELS.


DEF BUTTON btn_approve LABEL "Утвердить".
DEF BUTTON btn_reject  LABEL "Запретить".
DEF BUTTON btn_acct    LABEL "Счет".
DEF BUTTON btn_histbrw LABEL "Журнал".
DEF BUTTON btn_hist    LABEL "История".
DEF BUTTON btn_exit    LABEL "Выход".


DEF VAR mFileName  AS CHAR NO-UNDO.
DEF FRAME frmPlan 
	brwItem at row 1 column 1 skip
	" " btn_approve btn_reject SPACE(3) btn_acct HELP "F4 - выход из счета" btn_histbrw HELP "F4 - выход из журнала" btn_hist SPACE(10) btn_exit   
WITH CENTERED OVERLAY SIZE 75 BY 18 TITLE STRING("Журнал заявок на " + STRING( SUBSTRING(iOpDate,7,2) + "/" + SUBSTRING(iOpDate,5,2) + "/" + SUBSTRING(iOpDate,1,4) )).


TERMINAL-SIMULATION = CURRENT-WINDOW.
ASSIGN CURRENT-WINDOW                = TERMINAL-SIMULATION 
       THIS-PROCEDURE:CURRENT-WINDOW = TERMINAL-SIMULATION.


ON ESC GO.


/***** ================================================================= *****/
/*** 	                                                                   ***/
/***** ================================================================= *****/

	/*** КНОПКА ВЫХОД ***/

ON CHOOSE OF btn_exit IN FRAME frmPlan DO:
	LEAVE .
END.



	/*** КНОПКА УТВЕРДИТЬ ***/
ON CHOOSE OF btn_approve IN FRAME frmPlan DO:

	FIND CURRENT code.

	vvod_ok = false.
	
	IF ENTRY(1,code.val,";") = "УТВЕРЖДЕНА" THEN
	  DO:
		MESSAGE "Заявка уже утверждена!" VIEW-AS ALERT-BOX.
		RETURN NO-APPLY.
	  END.

	IF ENTRY(1,code.val,";") = "ВЫДАЕТСЯ" THEN
	  DO:
		MESSAGE "Заявка уже выдается. Нельзя повторно утвердить!" VIEW-AS ALERT-BOX.
		RETURN NO-APPLY.
	  END.

	IF ENTRY(4,code.name,";") = "DEL" THEN
	  DO:
		MESSAGE "Заявка была отмечена как удаленная. Её нельзя утвердить!" VIEW-AS ALERT-BOX.
		RETURN NO-APPLY.
	  END.


	IF ENTRY(1,code.val,";") <> "ВЫДАЕТСЯ" AND ENTRY(1,code.val,";") <> "УТВЕРЖДЕНА" AND ENTRY(4,code.name,";") <> "DEL" THEN
	  DO:

			/*** ВВОД ПРИЧИНЫ ***/
		vvod_ok = true.
		cCause1 = "" .

		IF vvod_ok THEN
		DO:
			DISPLAY cCause1 WITH FRAME fCause1.
			SET cCause1 WITH FRAME fCause1.
			HIDE FRAME fCause1.

			code.val = EditCdValStCash("УТВЕРЖДЕНА",REPLACE(cCause1,",","")) .
			code.description[1] = "1;ACT;;" . /* признак, что заявку можно выдавать и что заявка активная */
				/* Ставим признак правки ПОДФТ */
			code.name = EditCdNameStCash(code.name,"PODFT","","") .

			IF code.val <> "" THEN	
			DO:	

			   MESSAGE "Заявка утверждена" VIEW-AS ALERT-BOX TITLE "Результат".
			     /* message "TIME = " TIME " iOpDate = " iOpDate view-as alert-box.*/
			     /* рассылаются уведомления об утверждении онлайн-заявки */ 

				/* DEF VAR ziOpDate AS DATE    NO-UNDO. */
				/* ziOpDate = DATE('07/12/12') . */
                        /*
			   IF CreateStrOpDtStCash(TODAY) = iOpDate 
				AND TIME > 34200 AND TIME < 66600       /* с 9.30 до 18.30 */
			   THEN	
			*/
				RUN pir-statcash-answmail.p (INPUT code.code)  NO-ERROR.

			END.

		END.

	  END.

	BROWSE brwItem:REFRESH().

END.


	/*** КНОПКА ЗАПРЕТИТЬ ***/
ON CHOOSE OF btn_reject IN FRAME frmPlan DO:

	FIND CURRENT code.
	
	IF ENTRY(1,code.val,";") = "ВЫДАЕТСЯ" THEN
	  DO:
		MESSAGE "Заявка уже выдаётся. Её нельзя запретить!" VIEW-AS ALERT-BOX.
		RETURN NO-APPLY.
	  END.

	IF ENTRY(4,code.name,";") = "DEL" THEN
	  DO:
		MESSAGE "Заявка была отмечена пользователем как удаленная. Её нельзя запретить!" VIEW-AS ALERT-BOX.
		RETURN NO-APPLY.
	  END.

	IF ENTRY(1,code.val,";") <> "ВЫДАЕТСЯ" AND ENTRY(4,code.name,";") <> "DEL" THEN
	  DO:
			/*** ВВОД ПРИЧИНЫ ОТКАЗА ***/
		vvod_ok = true.
		cCause2 = "" .

		IF vvod_ok THEN
		DO:
			DISPLAY cCause2 WITH FRAME fCause2.
			SET cCause2 WITH FRAME fCause2.
			HIDE FRAME fCause2.

			code.val = EditCdValStCash("НЕ УТВЕРЖДЕНА",REPLACE(cCause2,",","")) .
				/* Ставим признак правки ПОДФТ */
			code.name = EditCdNameStCash(code.name,"PODFT","","") .		
			MESSAGE "Заявка запрещена" VIEW-AS ALERT-BOX TITLE "Результат".
		END.

	  END.

	BROWSE brwItem:REFRESH().

END.


	/*** КНОПКА СЧЕТ ***/
ON CHOOSE OF btn_acct IN FRAME frmPlan DO:

   DO TRANSACTION:

	FIND CURRENT code.

	mAcct = ENTRY(1,code.name,";") .   /* "40817810000002000072" */
	mAcctID = ENTRY(1,code.code,"_") . /* "116" */
	mAcctCustCat = ENTRY(3,code.code,"_") . /* "Ч" . */

	RUN browseld.p 
		("acct",
		"acct" + CHR(1) +
		"cust-cat" + CHR(1) +
		"cust-id",  /* Поля для предустановки. */
	        mAcct + CHR(1) + 
		mAcctCustCat + CHR(1) +
		mAcctID,   /* Список значений полей. */
	        ?,  /* Поля для блокировки. */
	        "5" /* Строка отображения фрейма. */
		).

   END.

   BROWSE brwItem:REFRESH().

END.


	/*** КНОПКА ИСТОРИЯ ***/
ON CHOOSE OF btn_hist IN FRAME frmPlan DO:

	FIND CURRENT code.

	RUN VALUE( "pir-statcash-hist.p" )( INPUT STRING(code.class + "," + code.code) )  NO-ERROR.

	BROWSE brwItem:REFRESH().

END.



	/*** КНОПКА ЖУРНАЛ ***/
ON CHOOSE OF btn_histbrw IN FRAME frmPlan DO:

	FIND CURRENT code.

	RUN browseld.p 
		("history",
		"file-name" + CHR(1) +
		"field-ref" ,			/* Поля для предустановки. */
	        "code" + CHR(1) + 
		"PirStatCash," + code.code ,	/* Список значений полей. */
	        ?,	/* Поля для блокировки. */
	        "5"	/* Строка отображения фрейма. */
		) .

	BROWSE brwItem:REFRESH().

END.




/***** ================================================================= *****/
/*** 	                                                                   ***/
/***** ================================================================= *****/

MAIN-BLOCK:
DO 	ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   	ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   	:

	OPEN QUERY qItem 
		FOR EACH code WHERE code.class = "PirStatCash"  
			      AND  code.parent = iOpDate  
		.

	ENABLE brwItem WITH FRAME frmPlan IN WINDOW TERMINAL-SIMULATION.

	ENABLE btn_approve with frame frmPlan IN WINDOW TERMINAL-SIMULATION.
	ENABLE btn_reject  with frame frmPlan IN WINDOW TERMINAL-SIMULATION.
	ENABLE btn_acct    with frame frmPlan IN WINDOW TERMINAL-SIMULATION.
	ENABLE btn_hist    with frame frmPlan IN WINDOW TERMINAL-SIMULATION.
	ENABLE btn_histbrw with frame frmPlan IN WINDOW TERMINAL-SIMULATION.
	ENABLE btn_exit    with frame frmPlan IN WINDOW TERMINAL-SIMULATION.


	VIEW TERMINAL-SIMULATION.

	IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
   		WAIT-FOR /**CLOSE OF THIS-PROCEDURE*/
   	 		CHOOSE OF btn_exit  IN FRAME frmPlan
    		FOCUS brwItem.
   	END.

END. 

ON ESC END-ERROR.
