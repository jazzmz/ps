
/***** ================================================================= *****/
/*** 	Процедура редактирования журнала заявок на выдачу наличных 
	по кассе (классификатор PirStatCash) 
	для членов Правления
	Входной параметр - дата оп.дня журнала (ГГГГММДД - тип CHAR)
	Запуск - из процедуры pir-statcash.p (с параметром 4)              ***/
/***** ================================================================= *****/
{globals.i}
{ulib.i}
{pir-statcash.i}


/***** ================================================================= *****/
/*** 	          ВХОДНЫЕ ПАРАМЕТРЫ, ПЕРЕМЕННЫЕ И ПР.                      ***/
/***** ================================================================= *****/

DEF INPUT PARAM iOpDate AS CHAR.
/* MESSAGE "pir-statcash-edruk.p  INPUT PARAM iOpDate = "  iOpDate VIEW-AS ALERT-BOX. */

DEF VAR cCause  AS CHAR    NO-UNDO.
DEF VAR cKlName AS CHAR    NO-UNDO.

DEF VAR TERMINAL-SIMULATION AS WIDGET-HANDLE NO-UNDO.

DEF QUERY qItem FOR code.

DEF BROWSE brwItem QUERY qItem 

DISPLAY	
	(IF NUM-ENTRIES(code.name,";") >= 4 THEN ENTRY(4,code.name,";") ELSE "" ) FORMAT "x(5)" LABEL "ИЗМ"
	GetClientInfo_ULL(ENTRY(3,code.code,"_") + "," + ENTRY(1,code.code,"_"), "name", false)  FORMAT "x(25)" LABEL "Клиент"
	ENTRY(1,code.name,";") FORMAT "x(20)" LABEL "Счет"
	ENTRY(2,code.name,";") FORMAT "x(12)" LABEL "Сумма"
	ENTRY(3,code.name,";") FORMAT "x(25)" LABEL "Вид расчета"
	ENTRY(1,code.val ,";") FORMAT "x(20)" LABEL "Статус ПодФТ"
	(IF NUM-ENTRIES(code.val ,";") >= 3 THEN STRING(ENTRY(2,code.val ,";") + " " +  ENTRY(3,code.val ,";")) ELSE "" ) FORMAT "x(70)" LABEL "Причина"
	ENTRY(5,code.name,";") FORMAT "x(10)" LABEL "Разрешил завести онлайн завку"
	(IF NUM-ENTRIES(code.description[1],";") >= 3 THEN ENTRY(3,code.description[1],";") ELSE "" ) format "x(20)" LABEL "Утвердил член Правления"
WITH 10 DOWN WIDTH 73 NO-LABELS.


DEF BUTTON btn_approve	LABEL "УТВЕРДИТЬ".
DEF BUTTON btn_hist     LABEL "История".
DEF BUTTON btn_histbrw  LABEL "Журнал".
DEF BUTTON btn_exit	LABEL "Выход".


DEF FRAME frmPlan 
	brwItem at row 1 column 1 skip
	" " btn_approve SPACE(3) btn_histbrw HELP "F4 - выход из журнала" btn_hist SPACE(10) btn_exit 
  WITH CENTERED OVERLAY SIZE 75 BY 18 TITLE STRING("Журнал заявок на " + iOpDate).

DEF FRAME fCause 
 	"ФИО члена Правления:"	cCause	FORMAT "X(40)" SKIP(1) 
 WITH CENTERED NO-LABELS TITLE "ВЫБЕРИТЕ".



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


		IF ENTRY(1,code.val,";") <> "УТВЕРЖДЕНА" THEN
		DO:
			MESSAGE "Внимание: Заявка не была утверждена ПОДФТ! Вы точно хотите её утвердить?" 
			  VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE mChange AS LOG.
			IF mChange = ? OR mChange = NO THEN 
			DO:
				MESSAGE "Заявка не утвеждена! Выходим!" VIEW-AS ALERT-BOX.
				RETURN NO-APPLY.
		  	END.
		END.


			/*** ЧЛЕН ПРАВЛЕНИЯ ***/
		cCause = "" .

		DISPLAY cCause WITH FRAME fCause.
		SET cCause WITH FRAME fCause.
		HIDE FRAME fCause.

		code.description[1] = "1;ACT;" + REPLACE(cCause,",","") + ";" . /* признак, что заявку можно выдавать и что заявка активная */
			/* Ставим признак правки члена Правления */
		code.name = EditCdNameStCash(code.name,"RUK","","") .		
		MESSAGE "Заявка утверждена" VIEW-AS ALERT-BOX TITLE "Результат".

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
	ENABLE btn_hist    with frame frmPlan IN WINDOW TERMINAL-SIMULATION.
	ENABLE btn_histbrw with frame frmPlan IN WINDOW TERMINAL-SIMULATION.
	ENABLE btn_exit	   with frame frmPlan IN WINDOW TERMINAL-SIMULATION.


	VIEW TERMINAL-SIMULATION.

	IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
   		WAIT-FOR /**CLOSE OF THIS-PROCEDURE*/
   	 		CHOOSE OF btn_exit  IN FRAME frmPlan
    		FOCUS brwItem.
   	END.

END. 

ON ESC END-ERROR.
