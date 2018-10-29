/*Часть функционала Тарифные планы*/
{globals.i}
{intrface.get tmess}
DEF VAR TERMINAL-SIMULATION AS WIDGET-HANDLE NO-UNDO.

DEF VAR confirm_delete as logical NO-UNDO. 
DEFINE VARIABLE confirm_button_del AS LOGICAL FORMAT "Да/Нет" INIT no NO-UNDO.
DEF temp-table tarifs NO-UNDO
          FIELD code like code.code	
	  FIELD name like code.name
	  FIELD since as date
	  INDEX code code.

def var oTarif as TTarif NO-UNDO.
def var outTarif as char no-undo.
DEF QUERY qItem FOR tarifs SCROLLING.


def buffer bcode-date for code.


DEF BROWSE brwItem QUERY qItem 
        DISPLAY        
                tarifs.code format "x(3)" LABEL "N"
                tarifs.name format "x(30)" LABEL "Наименование тарифного плана"
                tarifs.since format "99/99/99" LABEL "Дата"
        WITH 10 DOWN WIDTH 48 NO-LABELS.
        
DEF BUTTON btn_add LABEL "Добавить".    
DEF BUTTON btn_edit LABEL "Редактировать".
DEF BUTTON btn_exit LABEL "Выход".

DEF FRAME frmPlan 
        brwItem at row 1 column 1 skip
        btn_add btn_edit  SPACE(14) btn_exit
WITH CENTERED OVERLAY SIZE 50 BY 18 TITLE "Справочник тарифных планов".

TERMINAL-SIMULATION = CURRENT-WINDOW.
ASSIGN CURRENT-WINDOW                = TERMINAL-SIMULATION 
       THIS-PROCEDURE:CURRENT-WINDOW = TERMINAL-SIMULATION.


/* Здесь обрабатываем события по нажатию на кнопки */


on choose of btn_add in frame frmPlan do:
   run startAdd.
end.

on choose of btn_edit in frame frmPlan do:
   run startEdit.
end.



on INS of brwItem in frame frmPlan do:
   run startAdd.
end.

on del of brwItem in frame frmPlan do:

       FIND CURRENT tarifs NO-LOCK.
       oTarif = new TTarif(tarifs.code).
        confirm_button_del = yes.
     		MESSAGE COLOR RED 
		"Удалить тарифный план " + tarifs.name + "?" SKIP(1)
		VIEW-AS ALERT-BOX  BUTTONS YES-NO TITLE "ВНИМАНИЕ !!!!" UPDATE confirm_button_del .	

       if oTarif:CanDelete() and not confirm_button_del then 
       do:
           find first code WHERE code.class = "PirTarifMain" and code.code = tarifs.code NO-ERROR.
           if available code then 
           do:
           DELETE OBJECT oTarif.      
	   DELETE code.
	   end.

/*           for each Code where code.class = "PirTarifDate"
			     and code.name = tarifs.code:
	      DELETE code.
	   end.*/
       RUN RefreshForm.
       end.
       else do:
         DELETE OBJECT oTarif.       
         if not confirm_button_del then message "Нельзя удалить тарифный план по которому заведены комиссии" VIEW-AS ALERT-BOX.
        end.






end.


on f9 of brwItem in frame frmPlan do:
   run startEdit.
end.

on f5 of brwItem in frame frmPlan do:
   run StartCopyToNewTarif.
end.


on RETURN of brwItem in frame frmPlan do:
run ShowDateList.
end.


on f1 of brwItem in frame frmPlan do:
  FIND CURRENT tarifs NO-LOCK.
  find first code where code.code = tarifs.code and code.class = "PirTarifMain" NO-LOCK.
                                                                                        
  message "Тарифный план:" code.name SKIP 
	  "Дата утверждения:" tarifs.since SKIP 
          "Описание:" code.description[1]  view-as alert-box TITLE "ИНФОРМАЦИЯ".
end.

PROCEDURE ShowDateList:
  FIND CURRENT tarifs.
  RUN pirtarifdate.p(tarifs.code).
END PROCEDURE.

PROCEDURE StartCopyToNewTarif:
  FIND CURRENT tarifs.
  if tarifs.since <> ? then do:
  RUN Fill-SysMes IN h_tmess ("","",3,"Копировать " + tarifs.name + " c " + STRING(tarifs.since) + "|Да,Изменить дату,Отмена" ).
  FIND CURRENT tarifs.
  if INT(pick-value) = 1 then RUN CopyToNewTarif(tarifs.code,tarifs.since).
  if INT(pick-value) = 2 then DO:
                                 {getdate.i}
				 RUN CopyToNewTarif(tarifs.code,end-date).
                              END.
  IF INT(pick-value) = 3 THEN RETURN.
  end.
  else MESSAGE "Копирование Тарифного плана, для которого не заведены комиссии не возможно!" VIEW-AS ALERT-BOX.
END PROCEDURE.

PROCEDURE CopyToNewTarif:
 def input parameter fromTarif as CHAR NO-UNDO.
 def input parameter dDate as Date NO-UNDO.

    OutTarif = "".
    RUN pirtarifdetails.p(" ",OUTPUT outTarif).
    if OutTarif <> "" and OutTarif <> tarifs.code then
	DO:
           oTarif = new TTarif(OutTarif).
	   oTarif:CopyFromOtherTarif(fromTarif,dDate).
	   DELETE OBJECT oTarif.
	END.
      RUN RefreshForm.
END PROCEDURE.


PROCEDURE StartEdit:
  RUN Fill-SysMes IN h_tmess ("","",3,"|Описание,Комиссии" ).
  FIND CURRENT tarifs.
  if INT(pick-value) = 1 then RUN pirtarifdetails.p(tarifs.code,OUTPUT outTarif).
  if INT(pick-value) = 2 then RUN pirtarifdate.p(tarifs.code).

  RUN RefreshForm.

END PROCEDURE.

PROCEDURE StartAdd:
  
  RUN pirtarifdetails.p(" ",OUTPUT outTarif).
  RUN RefreshForm.

END PROCEDURE.


PROCEDURE FillTempTable.
def var tempdate as date no-undo.

   EMPTY TEMP-TABLE tarifs.

   FOR EACH code WHERE code.class = "PirTarifMain" NO-LOCK:

    /* find last bCode-date where bcode-date.class = "PirTarifDate"
			     and bcode-date.name = code.code
			     and dec(bcode-date.misc[1]) <= dec(gend-date) NO-LOCK NO-ERROR.*/


     /*
     if available bCode-date then tempdate = DATE(bcode-date.val).
     else tempdate = ?.*/

     oTarif = new TTarif(code.code).

     tempdate = oTarif:GetTarifSince(gend-date).
     DELETE OBJECT oTarif.

     CREATE tarifs.
     ASSIGN
           tarifs.code = code.code
	   tarifs.name = code.name
	   tarifs.since = tempdate.

   END.


END PROCEDURE.


PROCEDURE RefreshForm.
  CLOSE QUERY qItem.
  RUN FillTempTable.
  OPEN QUERY qItem FOR EACH tarifs.
END PROCEDURE.




/**/

MAIN-BLOCK:
DO         ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
           ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
           :
           
                
        /** список договоров */
	RUN FillTempTable.
        pause(0).
        OPEN QUERY qItem FOR EACH tarifs.
        ENABLE brwItem WITH FRAME frmPlan IN WINDOW TERMINAL-SIMULATION.

        enable btn_add with frame frmPlan IN WINDOW TERMINAL-SIMULATION.
        enable btn_edit with frame frmPlan IN WINDOW TERMINAL-SIMULATION.
        enable btn_exit with frame frmPlan IN WINDOW TERMINAL-SIMULATION.

        VIEW TERMINAL-SIMULATION.


        IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
                   WAIT-FOR /**CLOSE OF THIS-PROCEDURE*/
                            CHOOSE OF btn_exit  IN FRAME frmPlan
                    FOCUS brwItem.
           END.

END. 

ON esc endkey.


{intrface.del}