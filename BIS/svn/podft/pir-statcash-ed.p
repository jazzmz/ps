
/***** ================================================================= *****/
/*** 	Процедура редактирования журнала заявок на выдачу наличных 
	по кассе (классификатор PirStatCash) 
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
/* MESSAGE "pir-statcash-ed.p  INPUT PARAM iOpDate = "  iOpDate VIEW-AS ALERT-BOX. */

DEF VAR cCause1 AS INT     NO-UNDO.
DEF VAR cCause2 AS CHAR    NO-UNDO.
DEF VAR cKlName AS CHAR    NO-UNDO.
DEF VAR vvod_ok AS LOGICAL NO-UNDO.

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
	(IF NUM-ENTRIES(code.description[1],";") >= 3 THEN ENTRY(3,code.description[1],";") ELSE "" ) format "x(20)" LABEL "Утвердил член Правления"
WITH 10 DOWN WIDTH 73 NO-LABELS.


DEF BUTTON btn_edit	LABEL "РЕДАКТИРОВАТЬ".
DEF BUTTON btn_del	LABEL "УДАЛИТЬ".
DEF BUTTON btn_exit	LABEL "Выход".


DEF FRAME frmPlan 
	brwItem at row 1 column 1 skip
	" " btn_edit SPACE(10) btn_del SPACE(20) btn_exit 
  WITH CENTERED OVERLAY SIZE 75 BY 18 TITLE STRING("Журнал заявок на " + iOpDate).

DEF FRAME fCause 
	"Новая сумма:"	cCause1	FORMAT ">>>,>>>,>>>,>99" SKIP(1) 
 	"Новый вид расхода:"	cCause2	FORMAT "X(40)" SKIP(1) 
 WITH CENTERED NO-LABELS TITLE "ВВЕДИТЕ НОВЫЕ ДАННЫЕ".



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


	/*** КНОПКА РЕДАКТИРОВАТЬ ***/

ON CHOOSE OF btn_edit IN FRAME frmPlan DO:

	FIND CURRENT code.
	
	IF ENTRY(1,code.val,";") <> "не контролировали" THEN
	  DO:
		MESSAGE "Заявку уже контролировал сотрудник ПОДФТ. Её нельзя редактировать!" VIEW-AS ALERT-BOX.
		RETURN NO-APPLY.
	  END.

	IF ENTRY(4,code.name,";") = "DEL" THEN
	  DO:
		MESSAGE "Заявка была отмечена пользователем как удаленная. Её нельзя редактировать!" VIEW-AS ALERT-BOX.
		RETURN NO-APPLY.
	  END.

	IF ENTRY(1,code.val,";") = "не контролировали" AND ENTRY(4,code.name,";") <> "DEL" THEN
	  DO:
			/*** ОКНО РЕДАКТИРОВАНИЯ ***/
		vvod_ok = true.
		cCause1 = 0 .
		cCause2 = "" .

		IF vvod_ok THEN
		DO:

		      DISPLAY cCause1 cCause2 WITH FRAME fCause .
		      SET cCause1 cCause2 WITH FRAME fCause .
		      HIDE FRAME fCause.

			IF cCause1 = 0 OR cCause2 = "" THEN
			   MESSAGE "НЕВЕРНО ВВЕДЕНЫ ДАННЫЕ!!! Заявка не отредактирована" VIEW-AS ALERT-BOX TITLE "Результат".
			ELSE
			   DO:
				cCause2 = TRIM(REPLACE(cCause2,",","")) .
					/* Ставим признак модификации */
				IF EditCdNameStCash(code.name,"MOD",STRING(cCause1),cCause2) <> "" THEN
				DO:
				   code.name = EditCdNameStCash(code.name,"MOD",STRING(cCause1),cCause2) .
				   MESSAGE "Заявка отредактирована" VIEW-AS ALERT-BOX TITLE "Результат".
				END.
			   END.
		END.

	  END.

	BROWSE brwItem:REFRESH().

END.


	/*** КНОПКА УДАЛИТЬ ***/

ON CHOOSE OF btn_del IN FRAME frmPlan DO:

	FIND CURRENT code.
	
/* Sitov S.A.: убрал такую проверку по заявке Гамана В.В. #3039
	IF ENTRY(1,code.val,";") <> "не контролировали" THEN
	  DO:
		MESSAGE "Заявку уже контролировал сотрудник ПОДФТ. Её нельзя удалить!" VIEW-AS ALERT-BOX.
		RETURN NO-APPLY.
	  END.
*/
	IF ENTRY(4,code.name,";") = "DEL" THEN
	  DO:
		MESSAGE "Заявка была отмечена пользователем как удаленная. Её нельзя удалить!" VIEW-AS ALERT-BOX.
		RETURN NO-APPLY.
	  END.

	IF /* #3039   ENTRY(1,code.val,";") = "не контролировали" AND */  ENTRY(4,code.name,";") <> "DEL" THEN
	  DO:
			/* Ставим признаки удаления и неактивности заявки */
		/* code.description[1] = "0;NOACT;" + ( IF ENTRY(3,code.description[1],";") <> "" THEN ENTRY(3,code.description[1],";") ELSE "" ). */
		code.description[1] = "0;NOACT;" + ENTRY(3,code.description[1],";") + ";" .
		code.name = EditCdNameStCash(code.name,"DEL","","") .
		MESSAGE "Заявка помечена, как удаленная!" VIEW-AS ALERT-BOX TITLE "Результат".
	  END.

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

	ENABLE btn_edit with frame frmPlan IN WINDOW TERMINAL-SIMULATION.
	ENABLE btn_del  with frame frmPlan IN WINDOW TERMINAL-SIMULATION.
	ENABLE btn_exit with frame frmPlan IN WINDOW TERMINAL-SIMULATION.


	VIEW TERMINAL-SIMULATION.

	IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
   		WAIT-FOR /**CLOSE OF THIS-PROCEDURE*/
   	 		CHOOSE OF btn_exit  IN FRAME frmPlan
    		FOCUS brwItem.
   	END.

END. 

ON ESC END-ERROR.
