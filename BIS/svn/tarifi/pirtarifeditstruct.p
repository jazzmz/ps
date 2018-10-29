DEF INPUT PARAMETER vCode as CHAR.

/*Форма для ввода и редактирования */
def var cNum as Char format "x(3)" NO-UNDO.
def var cName as Char format "x(34)" NO-UNDO.
def var cKod as Char format "x(15)" NO-UNDO.
def var cDopProc as Char format "x(20)" NO-UNDO.
def var bEdit as LOGICAL NO-UNDO.
def BUFFER bfrcode for code.
def BUFFER bfrcode2 for code.

def var isok as Logical NO-UNDO.


if vcode = "" then bedit = false.
else
DO:
   message vCode VIEW-AS ALERT-BOX.
   bedit = true.    
   find first bfrcode where bfrcode.class = "PirSrtTarif" and bfrcode.code = vcode NO-ERROR.                                    
   if NOT AVAILABLE(bfrcode) then 
	DO:
	   message "Не найден редактируемый пункт струтуры тарифного плана!" VIEW-AS ALERT-BOX.	
	   RETURN.
	END.
	else
	do:
	ASSIGN
           cNum = bfrcode.code
           cName = bfrcode.name
           cKod = bfrcode.val
           cDopProc = bfrcode.misc[1].
	end.
end.


DEF frame fSet 
   "Номер нункта ТП:" cNum SKIP(1) 
   "Наименование пункта ТП:" cName SKIP(1) 
   "Код пункта ТП" cKod SKIP(1)
   "Доп процедура:" cDopProc SKIP(1)
   WITH CENTERED NO-LABELS TITLE "Введите данные".




   DISPLAY cNum cName cKod cDopProc  WITH frame fSet.
   isok = true.
   ON LEAVE OF cNum IN FRAME fSet DO:

	if (INPUT cNum = "") or (INPUT cNum = ?) then do: 
	message "Не заполнен номер пункта тарифного плана" VIEW-AS ALERT-BOX.
	isok  = false.
        end.
   END.
   ON LEAVE OF cName IN FRAME fSet DO:
   if (INPUT cName = "") or (INPUT cName = ?) then do: 
	message "Не заполнено наименование пункта тарифного плана" VIEW-AS ALERT-BOX.
	isok  = false.
   end.
   END.
   ON LEAVE OF cKod IN FRAME fSet DO:
   if (INPUT cKod = "") or (INPUT cKod = ?) then do: 
	message "Не заполнен код пункта тарифного плана" VIEW-AS ALERT-BOX.
	isok  = false.
   end.
   END.



   if isok then do:	
      SET cNum cName cKod cDopProc WITH frame fSet.

   if bedit = false then
   do:
    
            message cNUM VIEW-AS ALERT-BOX.
            find first bfrcode where bfrcode.class = "PirSrtTarif" and bfrcode.code = cNum NO-LOCK NO-ERROR. 
            if not available bfrcode then 
            do:
                   create code.
                   assign 
                         code.class = "PirSrtTarif"
                         code.code = cNum
                         code.name = cName
                         code.val = cKod
                         code.misc[1] = cDopProc.
            end.
            else
            DO:
                  Message "Уже существует пункт тарифа с номером " cNum VIEW-AS ALERT-BOX.
            end.
  end.
  else
  DO:
     find first bfrcode2 where bfrcode2.class = bfrcode.class 
			   and bfrcode2.code = bfrcode.code 
			   and bfrcode2.name <> bfrcode.name 
			   and bfrcode2.val <> bfrcode.val 
			   and bfrcode2.misc[1] <> bfrcode.misc[1] NO-LOCK NO-ERROR.
     if not available (bfrcode2) then 
	DO:
           find first code where code.class = bfrcode.class 
      	 		 	 and code.code = bfrcode.code 
			         and code.name = bfrcode.name 
			         and code.val = bfrcode.val 
			         and code.misc[1] = bfrcode.misc[1] NO-LOCK NO-ERROR.
	     assign 
	           code.class = "PirSrtTarif"
	           code.code = cNum
	           code.name = cName
	           code.val = cKod
	           code.misc[1] = cDopProc.
        END. 
        else
        DO:
               Message "Уже существует пункт тарифа с номером " cNum VIEW-AS ALERT-BOX.
        end.

  END.


  end.





/**/



