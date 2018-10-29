
/***** ================================================================= *****/
/*** 	Процедура редактирования журнала заявок на выдачу наличных 
	по кассе (классификатор PirStatCash) сотрудником У10-1
	Входной параметр - дата оп.дня журнала (ГГГГММДД - тип CHAR)
	Запуск - из процедуры pir-statcash.p (с параметром 3)              ***/
/***** ================================================================= *****/
{globals.i}
{ulib.i}



/***** ================================================================= *****/
/*** 	          ВХОДНЫЕ ПАРАМЕТРЫ, ПЕРЕМЕННЫЕ И ПР.                      ***/
/***** ================================================================= *****/

DEF INPUT PARAM iOpDate AS CHAR.
/* MESSAGE "pir-statcash-u101.p  INPUT PARAM iOpDate = "  iOpDate VIEW-AS ALERT-BOX. */

DEF VAR cCause1 AS CHAR    NO-UNDO.
DEF VAR vvod_ok AS LOGICAL NO-UNDO.
DEF VAR cKlName AS CHAR    NO-UNDO.

DEF VAR TERMINAL-SIMULATION AS WIDGET-HANDLE NO-UNDO.

DEF QUERY qItem FOR code.

DEF BROWSE brwItem QUERY qItem 

DISPLAY	
	GetClientInfo_ULL(ENTRY(3,code.code,"_") + "," + ENTRY(1,code.code,"_"), "name", false)  format "x(25)" LABEL "Клиент"
	/*ENTRY(2,code.code,"_") format "x(3)"  LABEL "Вал"*/
	ENTRY(1,code.name,";") format "x(20)" LABEL "Счет"
	ENTRY(2,code.name,";") format "x(12)" LABEL "Сумма"
	ENTRY(3,code.name,";") format "x(25)" LABEL "Вид расчета"
	ENTRY(1,code.val ,";") format "x(20)" LABEL "Статус ПодФТ"
	ENTRY(2,code.val ,";") format "x(70)" LABEL "Причина"
	code.description[1]    format "x(70)" LABEL "Исполнено/Не исполнено У10-1"
WITH 6 DOWN WIDTH 73 NO-LABELS.


DEF BUTTON btn_approve LABEL "Исполнено".
DEF BUTTON btn_exit    LABEL "Выход".


DEF FRAME frmPlan 
	brwItem at row 1 column 1 skip
	" " btn_approve SPACE(10) btn_exit 
WITH CENTERED OVERLAY SIZE 75 BY 18 TITLE STRING("Журнал заявок на " + iOpDate).


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


	/*** КНОПКА ИСПОЛНЕНО ***/

ON CHOOSE OF btn_approve IN FRAME frmPlan DO:

	FIND CURRENT code.

	vvod_ok = false.
	
	code.description[1] = "Исполнено" + ";" + USERID("bisquit") + " " +  STRING(TODAY, "99/99/99") + " " + STRING(TIME, "HH:MM:SS").

	MESSAGE "Сорудник У10-1 исполнил требование" VIEW-AS ALERT-BOX TITLE "Результат".
	BROWSE brwItem:SELECT-NEXT-ROW().

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
	ENABLE btn_exit with frame frmPlan IN WINDOW TERMINAL-SIMULATION.


	VIEW TERMINAL-SIMULATION.

	IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
   		WAIT-FOR /**CLOSE OF THIS-PROCEDURE*/
   	 		CHOOSE OF btn_exit  IN FRAME frmPlan
    		FOCUS brwItem.
   	END.

END. 

ON ESC END-ERROR.
