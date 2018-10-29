/*процедура для пересчета классов данных по 69т. Заявка #3923*/
{globals.i}
{norm.i new}


def input param in-date as date no-undo.
/*def var in-date as date init 10/23/2013 no-undo.*/

DEF VAR BtOk 	as log		NO-UNDO.

DEFINE NEW SHARED STREAM err.

DEF VAR cClassesAllDay AS CHAR /*INIT "f_69t,f_69t_ob"*/ NO-UNDO. /*классы, которые расчитываются за период с последнего расчитаного дня по текущий закрываемый день*/
DEF VAR cClassesOneDay AS CHAR /*INIT "f806,f157,f118n,f117n,f69tmail"*/ NO-UNDO. /*классы, которые расчитываются только за дату закрываемого опердня*/

DEF VAR currdate AS DATE NO-UNDO.
DEF VAR cBranch AS CHAR INIT "0000" NO-UNDO.
DEF VAR i AS INT INIT 0 NO-UNDO.
def var dDate as DATE NO-UNDO.
def var lastDate as DATE NO-UNDO.

DEF VAR vLnCountInt AS INTEGER NO-UNDO. /* Счетчик договоров */
DEF VAR vLnTotalInt AS INTEGER NO-UNDO. /* Общее количество договоров */

DEFINE  VARIABLE Out-Id       LIKE DataBlock.Data-Id NO-UNDO.
currdate = in-date.



cClassesAllDay = FGetSetting("f69t","PirCalcAllDay","").
cClassesOneDay = FGetSetting("f69t","PirCalcOneDay","").

PROCEDURE ReCalcDay.
DEFINE INPUT PARAMETER cClassname AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER cClassDate AS DATE NO-UNDO.

/*ищем датаблок за этот день*/
FIND FIRST dataclass WHERE dataclass.dataclass-id = cClassname NO-LOCK NO-ERROR.

IF AVAILABLE DataClass THEN /* если нашли датакласс, то значит в параметре правильное имя класса */
   DO:
         find first datablock where datablock.dataclass-id = dataclass.dataclass-id 
                                and datablock.beg-date = cClassDate
                                and datablock.end-date = cClassDate
                                NO-ERROR.
         IF AVAILABLE datablock then datablock.isFinal = no.

         RUN sv-get.p (dataclass.dataClass-Id, 
                       cBranch, 
                       cClassDate, 
                       cClassDate, 
                       OUTPUT out-id).   

         IF out-id = ? OR RETURN-VALUE = "Ошибка" THEN 
         DO:
            MESSAGE 
               'Не могу рассчитать данные "' + dataclass.name +
               '" (' + DataClass.DataClass-id ") за "
               + STRING(cClassDate) VIEW-AS ALERT-BOX.
         END.
         ELSE IF out-id NE ? AND NOT AVAIL DataBlock THEN
            FIND FIRST DataBlock WHERE DataBlock.Data-Id EQ out-id EXCLUSIVE-LOCK NO-ERROR.
            DataBlock.IsFinal = YES.
                                         
   END.
END PROCEDURE.

MESSAGE "Хотите запустить расчет индикаторов по 69т?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE BtOk. 
IF NOT BtOk or Btok = ? THEN RETURN .

/*считаем для прогрессбара*/

DO i = 1 to NUM-ENTRIES(cClassesAllDay,","):       /*пересчитываем за период*/

 FIND FIRST dataclass WHERE dataclass.dataclass-id = ENTRY(i,cClassesAllDay) NO-LOCK NO-ERROR.
 IF AVAILABLE dataclass THEN
   DO:

         FIND LAST datablock WHERE datablock.dataclass-id = dataclass.dataclass-id 
                               AND datablock.beg-date <= currdate
                               AND datablock.end-date <= currdate
			       and isFinal = yes
                                NO-LOCK NO-ERROR.
      lastdate = currdate. 

      IF AVAILABLE datablock then lastdate = datablock.end-date.
   
       DO dDate = lastdate to currdate.
           if NOT {holiday.i dDate} then     vLnTotalInt = vLnTotalInt + 1.

       END.
   END.

END.

DO i = 1 to NUM-ENTRIES(cClassesOneDay,","):       /*пересчитываем классы за один день*/

 vLnTotalInt = vLnTotalInt + 1.

END.

/*посчитали для прогрессбара*/


DO i = 1 to NUM-ENTRIES(cClassesAllDay,","):       /*пересчитываем за период*/

 FIND FIRST dataclass WHERE dataclass.dataclass-id = ENTRY(i,cClassesAllDay) NO-LOCK NO-ERROR.
 IF AVAILABLE dataclass THEN
   DO:

         FIND LAST datablock WHERE datablock.dataclass-id = dataclass.dataclass-id 
                               AND datablock.beg-date <= currdate
                               AND datablock.end-date <= currdate
			       and isFinal = yes
                                NO-LOCK NO-ERROR.
      lastdate = currdate. 

      IF AVAILABLE datablock then lastdate = datablock.end-date.
   
       DO dDate = lastdate to currdate.

         /* Бегущая строка - индикатор работы процесса */
         {move-bar.i
            vLnCountInt
            vLnTotalInt
          }


           if NOT {holiday.i dDate} then RUN ReCalcDay(dataclass.dataclass-id,dDate).

         vLnCountInt = vLnCountInt + 1.  
       END.
   END.

END.


DO i = 1 to NUM-ENTRIES(cClassesOneDay,","):       /*пересчитываем классы за один день*/

         /* Бегущая строка - индикатор работы процесса */
         {move-bar.i
            vLnCountInt
            vLnTotalInt
          }


 RUN ReCalcDay(ENTRY(i,cClassesOneDay),currdate).

    vLnCountInt = vLnCountInt + 1.  

END.
          

/**/


