

{globals.i}



/************************************************************************/
DEF VAR currFileName AS CHAR NO-UNDO.
DEF VAR sel_day AS CHAR  VIEW-AS SELECTION-LIST SINGLE LIST-ITEMS 
        "Инсайдеры Банка", "Инсайдеры Банка на дату", "Отчет 3", "Отчет 4"
        INNER-CHARS 25 INNER-LINES 4.
                                   
DEF BUTTON btn-exit LABEL "Выполнить".
/*** DEF FRAME frame1 sel_day NO-LABEL btn-exit AT ROW 12 COL 12 WITH CENTERED NO-UNDERLINE.  ***/
DEF FRAME frame1 sel_day LABEL "Список отчетов: " HELP "Выберите отчет и нажмите клавишу <Tab> "
                 btn-exit AT ROW 12 COL 12
    WITH CENTERED NO-UNDERLINE.

ON LEAVE OF sel_day
DO:
ASSIGN sel_day.
MESSAGE "Выбран отчет: " sel_day
   VIEW-AS ALERT-BOX INFORMATION BUTTONS OK  TITLE " Сообщение ".

END.
ENABLE ALL WITH FRAME frame1.
WAIT-FOR CHOOSE OF btn-exit.
HIDE FRAME frame1.

CASE sel_day :
  WHEN "Инсайдеры Банка" THEN
     DO ON STOP UNDO, RETRY:
       IF RETRY THEN DO:
         MESSAGE "Процедурный файл pir_tvv_insiders.p - не найден "
           VIEW-AS ALERT-BOX TITLE " Предупреждение ".
         UNDO,LEAVE.
       END.
       ELSE DO:
         currFileName = "pir_tvv_insiders".
         RUN VALUE(currFileName + '.p').
       END.  /*** ELSE  ***/
     END.  /*** DO  ***/

  WHEN "Инсайдеры Банка на дату" THEN
     DO ON STOP UNDO, RETRY:
       IF RETRY THEN DO:
         MESSAGE "Процедурный файл pir_date_insiders.p - не найден "
           VIEW-AS ALERT-BOX TITLE " Предупреждение ".
         UNDO,LEAVE.
       END.
       ELSE DO:
         currFileName = "pir_date_insiders".
         RUN VALUE(currFileName + '.p').
       END.  /*** ELSE  ***/
     END.  /*** DO  ***/

  WHEN "Отчет 3" THEN "".
  WHEN "Отчет 4" THEN "".
END.

