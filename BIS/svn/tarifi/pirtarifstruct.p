{globals.i}

DEF VAR TERMINAL-SIMULATION AS WIDGET-HANDLE NO-UNDO.

DEF VAR confirm_delete as logical NO-UNDO. 

DEF QUERY qItem FOR code SCROLLING.

DEF BROWSE brwItem QUERY qItem 
        DISPLAY        
                code.code format "x(3)" LABEL "N"
                code.name format "x(34)" LABEL "Пункт ТП"
                code.val format "x(15)" LABEL "Код пункта ТП 	"
                code.misc[1] format "x(20)" LABEL "Транзакции"
        WITH 10 DOWN WIDTH 73 NO-LABELS.
        
DEF BUTTON btn_add LABEL "Добавить".
DEF BUTTON btn_edit LABEL "Редактировать".
DEF BUTTON btn_exit LABEL "Выход".
DEF BUTTON btn_delete LABEL "Удалить".

DEF FRAME frmPlan 
        brwItem at row 1 column 1 skip
        " " btn_add btn_edit btn_delete SPACE(27) btn_exit
WITH CENTERED OVERLAY SIZE 75 BY 18 TITLE "Структура тарифного плана".

TERMINAL-SIMULATION = CURRENT-WINDOW.
ASSIGN CURRENT-WINDOW                = TERMINAL-SIMULATION 
       THIS-PROCEDURE:CURRENT-WINDOW = TERMINAL-SIMULATION.


/* Здесь обрабатываем события по нажатию на кнопки */


on choose of btn_add in frame frmPlan do:
RUN pirtarifeditstruct.p("").
RUN RefreshForm.

end.

on choose of btn_edit in frame frmPlan do:
FIND CURRENT code.
RUN pirtarifeditstruct.p(code.code).
RUN RefreshForm.
end.

on choose of btn_delete in frame frmPlan do:
confirm_delete = NO.

		MESSAGE 
			"Вы действительно хотите удалить пункт тарифного плана?" 
		VIEW-AS ALERT-BOX  BUTTONS YES-NO TITLE "ВНИМАНИЕ !!!!" UPDATE confirm_delete .	
if confirm_delete then do:
FIND CURRENT code.
delete code.
RUN RefreshForm.
end.
end.



PROCEDURE RefreshForm.
  CLOSE QUERY qItem.
  OPEN QUERY qItem FOR EACH code WHERE code.class = "PirSrtTarif".
END PROCEDURE.




/**/

MAIN-BLOCK:
DO         ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
           ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
           :
           
                
        /** список договоров */
        OPEN QUERY qItem FOR EACH code WHERE code.class = "PirSrtTarif".
        ENABLE brwItem WITH FRAME frmPlan IN WINDOW TERMINAL-SIMULATION.

        enable btn_add with frame frmPlan IN WINDOW TERMINAL-SIMULATION.
        enable btn_edit with frame frmPlan IN WINDOW TERMINAL-SIMULATION.
        enable btn_exit with frame frmPlan IN WINDOW TERMINAL-SIMULATION.
        enable btn_delete with frame frmPlan IN WINDOW TERMINAL-SIMULATION.

        VIEW TERMINAL-SIMULATION.


        IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
                   WAIT-FOR /**CLOSE OF THIS-PROCEDURE*/
                            CHOOSE OF btn_exit  IN FRAME frmPlan
                    FOCUS brwItem.
           END.

END. 

ON esc endkey.
