/*Часть функционала Тарифные планы*/
{globals.i}
/*{getdate.i}*/


DEF INPUT PARAMETER vCode AS CHAR.
DEF INPUT PARAMETER iDate AS DATE.

/*def var vcode as char init "1" NO-UNDO.
def var idate as date init "12/12/2012" NO-UNDO.*/
def var bdel as logical NO-UNDO.
def var tempIdVetka as int.



DEF VAR TERMINAL-SIMULATION AS WIDGET-HANDLE NO-UNDO.


def var cNum as Char format "x(2)" NO-UNDO.
def var cName as Char format "x(35)" NO-UNDO.
def var cKod as Char format "x(15)" NO-UNDO.
def var cDopProc as Char format "x(20)" NO-UNDO.
def var bEdit as LOGICAL NO-UNDO.

def var BaseTarifNum as CHAR INIT "1" NO-UNDO.  /*код базового тарифного плана, потом вынесу в настроечник*/

def var oTarif as TTarif NO-UNDO.

def var oBaseTarif as TTarif NO-UNDO.

def var BaseTarifSince AS DATE NO-UNDO.

def BUFFER bcode-struct for code.
def BUFFER bfrcode for code.




def var bInHer as logical NO-UNDO.
def var bInHer2 as logical NO-UNDO.

DEF VAR isok AS Logical NO-UNDO.
DEF VAR iId AS INT INIT 0.

def var save-comm-rate-id as int no-undo.
def var save-code as char no-undo.


DEF BUTTON btn_add LABEL "Добавить".
DEF BUTTON btn_edit LABEL "Редактировать".
DEF BUTTON btn_del LABEL "Удалить".

DEF BUTTON btn_exit LABEL "Выход".

def temp-table drevo NO-UNDO
	field IDvetka as int
	field Cod like code.Code
	field Name like code.name
	field Hiden as CHAR /*если "+" - то свернуто, если "-" - развернуто*/
	field parentId as int
	field level as int
	INDEX IDVetka IDvetka.

def temp-table vetka no-undo
	field IDvetka as int
	field currency         like comm-rate.currency
	field min              like comm-rate.min-value
	field rate-fixed       like comm-rate.rate-fixed
	field rate-comm        like comm-rate.rate-comm
	field comm-rate-id     like comm-rate.comm-rate-id
	field InHer            AS LOGICAL /*тут пишем наследуется ли комиссия с базового тарифного плана*/
	INDEX IDVetka IDVetka.


def temp-table tTarif NO-UNDO 
        field id as int
	field IDvetka as int
        field HIDEN as CHAR
	field code like code.code
	field name like code.name
        field currency like comm-rate.currency
        field min as char
	field rate-comm as char
	field comm-rate-id     like comm-rate.comm-rate-id
	INDEX id id.


def buffer bDrevo for drevo.
def buffer bDrevo2 for drevo.


DEF QUERY qItem FOR tTarif SCROLLING.

DEF BROWSE brwItem QUERY qItem 

        DISPLAY        
             tTarif.HIDEN format "x(3)" LABEL " "
	     tTarif.code       format "x(14)" LABEL "N"
	     tTarif.name       format "x(28)" LABEL "Пункт тарифного плана"
	     tTarif.currency        format "x(4)" LABEL "Вал"
	     tTarif.min         format "x(10)" LABEL "Мин. сумма"
	     tTarif.rate-comm   format "x(11)"     LABEL "Размер комиссии"
        WITH 15 DOWN WIDTH 78.



TERMINAL-SIMULATION = CURRENT-WINDOW.
ASSIGN CURRENT-WINDOW                = TERMINAL-SIMULATION 
       THIS-PROCEDURE:CURRENT-WINDOW = TERMINAL-SIMULATION.

DEF FRAME frmPlan 
          brwItem at row 1 column 1 skip
          btn_add btn_edit btn_del  SPACE(20) btn_exit
WITH CENTERED OVERLAY SIZE 80 BY 22 TITLE cName.





PROCEDURE FormInit.

oTarif = new TTarif(vcode).
RUN CREATEDREVO.
  RUN CREATETTARIF.       /*заполняем временную таблиццццу*/
end PROCEDURE.


PROCEDURE AddVetv.
DEFINE INPUT PARAMETER TpNum AS CHAR.

	   for each comm-rate where comm-rate.commission = bcode-struct.val + "_" + TpNum and comm-rate.since = idate
	              NO-LOCK
			 BY comm-rate.currency
		         BY comm-rate.min-value
			 BY comm-rate.since DESCENDING.
                if bInHer2 then binher = false.
                
	        CREATE vetka.
		ASSIGN
	              vetka.IDVetka   = drevo.IDVetka
		      vetka.currency  = comm-rate.currency
	              vetka.min       = comm-rate.min-value
		      vetka.rate-fixed= comm-rate.rate-fixed
		      vetka.rate-comm = comm-rate.rate-comm
		      vetka.comm-rate-id = comm-rate.comm-rate-id
		      vetka.InHer = bInher.  /*т.к. не унаследовательно с базового*/
	   end.
 
END PROCEDURE.


PROCEDURE AddVetvInher.
DEFINE INPUT PARAMETER TpNum AS CHAR.
           if BaseTarifNum <> vCode then do:
	   for each comm-rate where comm-rate.commission = bcode-struct.val + "_" + TpNum and comm-rate.since = BaseTarifSince
	              NO-LOCK
			 BY comm-rate.currency
		         BY comm-rate.min-value
			 BY comm-rate.since DESCENDING.
                if bInHer2 then binher = false.
	        CREATE vetka.
		ASSIGN
	              vetka.IDVetka   = drevo.IDVetka
		      vetka.currency  = comm-rate.currency
	              vetka.min       = comm-rate.min-value
		      vetka.rate-fixed= comm-rate.rate-fixed
		      vetka.rate-comm = comm-rate.rate-comm
		      vetka.comm-rate-id = comm-rate.comm-rate-id
		      vetka.InHer = bInher.  /*т.к. не унаследовательно с базового*/
	   end.
          end.
END PROCEDURE.


PROCEDURE CorrectDrevo.
FOR EACH drevo.
         drevo.cod = fill(" ",drevo.level) + drevo.cod.
END.
END PROCEDURE.


PROCEDURE CorrectTTarif.
def buffer bTarif for tTarif.

for each tTarif where tTarif.comm-rate-id <> 0 and tTarif.comm-rate-id <> ? :
   find first bTarif where RECID(tTarif) <> RECID(bTarif) and tTarif.comm-rate-id = bTarif.comm-rate-id NO-ERROR.
   if available bTarif then delete bTarif.
end.                                      


END PROCEDURE.


PROCEDURE CREATEDREVO.     /*Здесь создаем древо при запуске процедуры. по умолчанию все ветви развернуты*/
   EMPTY TEMP-TABLE drevo.
   EMPTY TEMP-TABLE vetka.
   def var tempparentId as int NO-UNDO.
   def var tempLevel as int NO-UNDO.
   iId = 0.
   FOR EACH bcode-struct where bcode-struct.class = "PirStrTarif" NO-LOCK BY bcode-struct.description[2].         /*бежим по классификатору со структурой*/
       tempparentId = ?.
       if bcode-struct.description[1] <> "" and bcode-struct.description[1] <> ? then 
	  do:
            find first bDrevo where bDrevo.cod = bcode-struct.description[1] NO-LOCK NO-ERROR.
	    if available bDrevo then 
		do:
		   tempparentId = bDrevo.IDVetka.
		   templevel = bDrevo.level + 1. 
		end.
          end.
       iId = iId + 1.
       bInher = true.
       if templevel = ? then templevel = 0.
       CREATE drevo. 
       ASSIGN 
	      drevo.IDVetka = iId
              drevo.Cod = bcode-struct.code
              drevo.Name = bcode-struct.name
	      drevo.Hiden = "+"             /*начальное положение всего дерево "-" - развернуто, "+" - свернуто*/
	      drevo.ParentId = tempparentid
	      drevo.level = templevel.
       templevel = 0.
       if bcode-struct.val <> "" then  /*если есть код для комиссии - следовательно собираем комиссии */
	do:
	   bInHer = true.
           bInHer2 = true.
	   RUN AddVetv(oTarif:TpNum).
           if bInHer then
	      do:
		bInHer2 = false.
 	
		RUN AddVetvinHer(BaseTarifNum).
	      end.
	end.
   END.

    RUN CorrectDrevo.


 /**/

END PROCEDURE.

PROCEDURE CREATETTARIF.
def var Tarif-id as INT INIT 0 NO-UNDO.
def var temp as CHAR NO-UNDO.
def var temp2 as CHAR NO-UNDO.
def var skiped as LOGICAL NO-UNDO.
def var tempfix as char no-undo.


   EMPTY TEMP-TABLE tTarif.

   FOR EACH drevo NO-LOCK.
   skiped = false.

   if drevo.parentid <> ? then
	do:
	   find first bDrevo where bDrevo.IdVetka = drevo.parentid NO-LOCK NO-ERROR.
	   if available bDrevo then 
	      do:
	         if CAN-DO("*+",bDrevo.Hiden) then skiped = true.  
	      end.
	end.

   if not skiped then
   DO:	

   Tarif-id = Tarif-id + 1.
   CREATE tTarif. /*сначала создаем внешний уровень, затем подуровень*/ 
     ASSIGN
     tTarif.id = Tarif-id
     tTarif.IDvetka = drevo.IdVetka
     tTarif.hiden = drevo.Hiden
     tTarif.code = drevo.Cod
     tTarif.name = drevo.Name
     tTarif.currency = ""
     tTarif.min = ""
     tTarif.rate-comm = ""
     tTarif.comm-rate-id = 0.	



      if drevo.hiden = "-" then /*если пункт "развернут" то заполняем имеющимися комиссиями*/
        do: 
           for each vetka where vetka.IDvetka = drevo.IDVetka NO-LOCK
		BREAK BY vetka.IDVETKA.

	       if vetka.rate-fixed then tempfix = "=". else tempfix = "%".	
               Tarif-id = Tarif-id + 1.
               IF LAST-OF (vetka.IDVetka) then temp = "└". else temp = "├".
               if vetka.inher then temp2 = "Н". else temp2 = "─".
               CREATE tTarif.                          
               ASSIGN
    	         tTarif.id = Tarif-id
                 tTarif.IDvetka = vetka.IdVetka
	         tTarif.hiden = temp + temp2
  	         tTarif.code =  "─────────"
   	         tTarif.name = "─────────────────────────────"
 	         tTarif.currency = vetka.currency
	         tTarif.min = STRING(vetka.min)
	         tTarif.rate-comm = STRING(vetka.rate-comm,">>>,>>9.99") + tempfix
	         tTarif.comm-rate-id = vetka.comm-rate-id.	               
	   end.
        end.
   END.
   END.
RUN CorrectTTarif.
END PROCEDURE.

PROCEDURE RETURNTOCURRENTROW.

FIND FIRST tTarif where save-code = tTarif.code NO-LOCK NO-ERROR.
if available (tTarif) then REPOSITION qItem TO RECID RECID(tTarif).
 
END PROCEDURE.

PROCEDURE RETURNTOCURRENTCommRate.

FIND FIRST tTarif where save-comm-rate-id = tTarif.comm-rate-id NO-LOCK NO-ERROR.
if available (tTarif) then REPOSITION qItem TO RECID RECID(tTarif). 
 
END PROCEDURE.


PROCEDURE RefreshForm.
  CLOSE QUERY qItem.
  RUN CREATETTARIF.
  OPEN QUERY qItem FOR EACH tTarif NO-LOCK INDEXED-REPOSITION.
END PROCEDURE.


PROCEDURE RefreshVetka.

   find last drevo where drevo.idvetka = tempIdVetka.
   for each vetka where vetka.IDVetka   = drevo.IDVetka:
   delete vetka.
   end.
  	   bInHer = true.
           bInHer2 = true.
	   RUN AddVetv(oTarif:TpNum).
           if bInHer then
	      do:
		bInHer2 = false.
		RUN AddVetvInHer(BaseTarifNum).
	      end.

END PROCEDURE.


PROCEDURE StartAddNewRate.
FIND CURRENT tTarif.
if tTarif.comm-rate-id <> 0 then 
do:
   tempIdVetka = tTarif.idVetka.
   FIND FIRST tTarif where tTarif.idVetka = tempIdVetka NO-LOCK.
end.
find first bcode-struct where bcode-struct.class = "PirStrTarif" and bcode-struct.code = TRIM(tTarif.code) NO-LOCK.
if bcode-struct.val = "" then message "Для данного пункт тарифного плана не задан код комиссии! Исправьте в классификаторе PirStrTarif" VIEW-AS ALERT-BOX.
else
do:
   tempIdVetka = tTarif.idVetka.
   RUN pirtarifrate.p(bcode-struct.code,oTarif:TpNum,idate,0).

   save-code = bcode-struct.code.

   RUN RefreshVetka.
   RUN RefreshForm.
   RUN RETURNTOCURRENTROW.
end.

END PROCEDURE.

PROCEDURE StartEdit.
def var confirm_overwrite as logical init no NO-UNDO.
   FIND CURRENT tTarif.
   if NOT CAN-DO("*Н",tTarif.hiden) then do:
   if tTarif.comm-rate-id <> 0 then do:
      save-comm-rate-id = tTarif.comm-rate-id.
      tempIdVetka = tTarif.idVetka.
      FIND FIRST tTarif where tTarif.idVetka = tempIdVetka NO-LOCK.
      find first bcode-struct where bcode-struct.class = "PirStrTarif" and bcode-struct.code = TRIM(tTarif.code) NO-LOCK.
      tempIdVetka = tTarif.idVetka.
      RUN pirtarifrate.p(bcode-struct.code,oTarif:TpNum,idate,save-comm-rate-id).
      RUN RefreshVetka.

      RUN RefreshForm.
      RUN RETURNTOCURRENTCommRate.
   end.
   end.
   else
   do:
      Message "Размер комиссии наследован с Базового Тарифного плана, создат новую ставку для тарифа?"
              	         VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE confirm_overwrite.
      if confirm_overwrite then RUN StartAddNewRate.	
   end.
END PROCEDURE.

PROCEDURE StartDelete.
   FIND CURRENT tTarif.
   bdel = no.
   if NOT CAN-DO("*Н",tTarif.hiden) then do:
   if tTarif.comm-rate-id <> 0 then 
      do:
         tempIdVetka = tTarif.idVetka.
         find first comm-rate where comm-rate.comm-rate-id  = tTarif.comm-rate-id.
         MESSAGE "Удалить комиссию?" VIEW-AS ALERT-BOX  BUTTONS YES-NO TITLE "ВНИМАНИЕ !" UPDATE bdel.
         if bdel then 
	    do:
              DELETE comm-rate.
              RUN RefreshVetka.
              RUN RefreshForm.
	    end.

      end.
  end.
  else
  do:
     message "Нельзя удалить комиссию наследуемую с Базового Тарифного плана" VIEW-AS ALERT-BOX.
  end.
END PROCEDURE.



PROCEDURE HideShow.

   find current tTarif.

   save-comm-rate-id = tTarif.comm-rate-id.
   save-code = tTarif.code.

   if tTarif.comm-rate-id = 0 then 
      do:
         find first drevo where drevo.idVetka = ttarif.idVetka.
         if CAN-DO("*+",drevo.hiden) then drevo.hiden = "-". else 
	 do:
  	    drevo.hiden = "+".
	    for each bdrevo where bdrevo.parentid = ttarif.idvetka:
               bdrevo.hiden = "+".
               for each bdrevo2 where bdrevo2.parentid = bdrevo.idvetka: /*некрасиво но пока не придумал как лучше сделать*/
                  bdrevo2.hiden = "+".              	
	       end.
  	    end.
         end. 
         RUN RefreshForm.
         RUN RETURNTOCURRENTROW.
      end.

END PROCEDURE.


PROCEDURE ShowDetails.

DEF VAR NeedShow AS LOGICAL INIT FALSE NO-UNDO.
DEF VAR isFirstForCur AS LOGICAL INIT TRUE NO-UNDO.
DEF VAR tempstring AS CHAR INIT "" NO-UNDO.
def var prevComm-Rate as CHAR NO-UNDO.
def var tempfix as CHAR NO-UNDO.


   find current tTarif.
   tempstring = "".
   for each vetka where vetka.IDVetka = tTarif.idVetka 
	            and vetka.comm-rate-id <> 0 
	              NO-LOCK
			BREAK BY vetka.currency
		      BY vetka.min:
       
       NeedShow = true.
       if isFirstForCur then
       do:
           if vetka.currency = "" then tempstring = tempstring + CHR(10) + "Рубли: " + CHR(10).
           if vetka.currency = "840" then tempstring = tempstring + CHR(10) + "Доллары: " + CHR(10).	   
           if vetka.currency = "978" then tempstring = tempstring + CHR(10) + "Евро: " + CHR(10).	   

           tempstring = tempstring + STRING(vetka.min).
	   isFirstForCur = false.
       end. 
       else tempstring = tempstring + STRING(vetka.min) + "     " + prevComm-Rate + CHR(10) + STRING(vetka.min).

       if vetka.rate-fixed then tempfix = "=". else tempfix = "%".
       prevComm-Rate = TRIM(string(vetka.rate-comm,">>>,>>9.99")) + tempfix.


       if last-of(vetka.currency) then 
	  DO:
             tempstring = tempstring + "<=S" + "     " + prevComm-Rate + CHR(10).
	     isFirstForCur = true.
	  END.
	  else tempstring = tempstring + "<=S<".

       



   END.
if needshow then message "ПАРАМЕТРЫ СПИСАНИЯ КОМИССИИ:" SKIP "S - сумма документа;" SKIP tempstring VIEW-AS ALERT-BOX TITLE "Информация".		    
             
END PROCEDURE.

/* Обработка событий нажатия на кнопку */

on choose of btn_add in frame frmPlan do:
   RUN StartAddNewRate.
end.

on ins of brwItem in frame frmPlan do:
   RUN StartAddNewRate.
end.

on choose of btn_edit in frame frmPlan do:
   RUN STARTEDIT.
end.

on F9 of brwItem in frame frmPlan do:
   RUN STARTEDIT.
end.

on enter of brwItem in frame frmPlan do:
   RUN HideShow.
end.

on choose of btn_del in frame frmPlan do:
   RUN StartDelete.
end.

on del of brwItem in frame frmPlan do:
   RUN StartDelete.
end.


on 'F1' of brwItem in frame frmPlan do:
   RUN ShowDetails.
end.




MAIN-BLOCK:
DO         ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
           ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
           :

oBaseTarif = new TTarif(BaseTarifNum).
BaseTarifSince = oBaseTarif:PrevDate(iDate).


run formInit.
/*run FillTempTable.           */
          

        OPEN QUERY qItem FOR EACH tTarif NO-LOCK INDEXED-REPOSITION. 
                                          
        ENABLE brwItem  WITH FRAME frmPlan IN WINDOW TERMINAL-SIMULATION.
        ENABLE btn_add  WITH FRAME frmPlan IN WINDOW TERMINAL-SIMULATION.
        ENABLE btn_edit WITH FRAME frmPlan IN WINDOW TERMINAL-SIMULATION.
        ENABLE btn_del  WITH FRAME frmPlan IN WINDOW TERMINAL-SIMULATION.
        ENABLE btn_exit WITH FRAME frmPlan IN WINDOW TERMINAL-SIMULATION.


        VIEW TERMINAL-SIMULATION.


        IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
                   WAIT-FOR /**CLOSE OF THIS-PROCEDURE*/
                            CHOOSE OF btn_exit  IN FRAME frmPlan
                    FOCUS brwItem.
           END.

END. 

ON esc endkey.




DELETE OBJECT oTarif.
DELETE OBJECT oBaseTarif.




