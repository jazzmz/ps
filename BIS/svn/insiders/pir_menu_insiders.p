

{globals.i}



/************************************************************************/
DEF VAR currFileName AS CHAR NO-UNDO.
DEF VAR sel_day AS CHAR  VIEW-AS SELECTION-LIST SINGLE LIST-ITEMS 
        "��ᠩ���� �����", "��ᠩ���� ����� �� ����", "���� 3", "���� 4"
        INNER-CHARS 25 INNER-LINES 4.
                                   
DEF BUTTON btn-exit LABEL "�믮�����".
/*** DEF FRAME frame1 sel_day NO-LABEL btn-exit AT ROW 12 COL 12 WITH CENTERED NO-UNDERLINE.  ***/
DEF FRAME frame1 sel_day LABEL "���᮪ ���⮢: " HELP "�롥�� ���� � ������ ������� <Tab> "
                 btn-exit AT ROW 12 COL 12
    WITH CENTERED NO-UNDERLINE.

ON LEAVE OF sel_day
DO:
ASSIGN sel_day.
MESSAGE "��࠭ ����: " sel_day
   VIEW-AS ALERT-BOX INFORMATION BUTTONS OK  TITLE " ����饭�� ".

END.
ENABLE ALL WITH FRAME frame1.
WAIT-FOR CHOOSE OF btn-exit.
HIDE FRAME frame1.

CASE sel_day :
  WHEN "��ᠩ���� �����" THEN
     DO ON STOP UNDO, RETRY:
       IF RETRY THEN DO:
         MESSAGE "��楤��� 䠩� pir_tvv_insiders.p - �� ������ "
           VIEW-AS ALERT-BOX TITLE " �।�०����� ".
         UNDO,LEAVE.
       END.
       ELSE DO:
         currFileName = "pir_tvv_insiders".
         RUN VALUE(currFileName + '.p').
       END.  /*** ELSE  ***/
     END.  /*** DO  ***/

  WHEN "��ᠩ���� ����� �� ����" THEN
     DO ON STOP UNDO, RETRY:
       IF RETRY THEN DO:
         MESSAGE "��楤��� 䠩� pir_date_insiders.p - �� ������ "
           VIEW-AS ALERT-BOX TITLE " �।�०����� ".
         UNDO,LEAVE.
       END.
       ELSE DO:
         currFileName = "pir_date_insiders".
         RUN VALUE(currFileName + '.p').
       END.  /*** ELSE  ***/
     END.  /*** DO  ***/

  WHEN "���� 3" THEN "".
  WHEN "���� 4" THEN "".
END.

