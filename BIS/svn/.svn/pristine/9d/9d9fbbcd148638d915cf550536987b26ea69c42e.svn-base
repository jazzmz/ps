{pirsavelog.p}

/*
*
*	КБ ПPОМИНВЕСТРАСЧЕТ
*	
*       17/03/06
*       Ввод плановых значений сметы расходов.
*	Решил плановые значения хранить в виде формул класса данных. может и не умно... но
*	в дальнейшем хотел сделать смету в виде класса. Может руки и дойдут...:)
*
*	[vk]
*
*/

{globals.i}

def var ed-year as integer initial 2007.
def var ed-kvartal as integer initial 1.
def var ed-mode as logical initial true. /* в тысячах */
def var smeta as char initial "SmRashod". /* класс где хранятся плановые значения */
def var dmin as date. /* дата начала периода */ 
def var dmax as date. /* дата конца периода  */
def var datekvartals as char initial "01/01,31/03,01/04,30/06,01/07,30/09,01/10,31/12".
def var edit-mode as logical initial false.

def var ttstr as char.
def var ttlen as int.
def var edc as char format "x(2)".
def var edn as char format "x(30)".
def var edp as integer format ">>>>>>>>9".


/* временная таблица */
def temp-table ttformula NO-UNDO
	field plan as integer label "Значение" format ">>>>>>>>9"
	field name as char label "Название" format "x(59)"
	field DataClass-id as char
	field since as date
	field code as char label "NN" format "x(2)"
	field flcreate as logical
	field varid as char.

def temp-table ttplan NO-UNDO
	field plan as integer label "Значение" format ">>>>>>>>9"
	field name as char label "Название" format "x(59)"
	field code as char label "NN" format "x(2)".


/* browse */
Define query qPlan for ttplan.
Define browse bPlan query qPlan
   display 
	ttplan.code  
	"|" 
	ttplan.name format "x(50)" 
	"|" 
	ttplan.plan
   enable ttplan.plan 
   with 12 down  no-row-markers no-labels.
 Define button bedd label "F9 - РЕДАКТИРОВАНИЕ". 

Define frame f-plan
   bplan	
   skip(1)
   bedd 
with row 4 centered overlay side-labels title dcolor 9 "" .

/* F9 ------------------------------ */

on f9 of frame f-plan anywhere  apply "choose" to bedd in frame f-plan.

/* --------------------------------- */

/* Choose bedd --------------------- */
on choose of bedd do:
  if edit-mode = false then do:
     ttplan.plan:column-read-only in browse bplan = false. 
     bplan:read-only in frame f-plan = false.
     ttplan.plan:column-dcolor in browse bplan = 1.
     edit-mode = true.
     bedd:label = "F9 - ЗАКОНЧИТЬ РЕДАКТИРОВАНИЕ".	
  end.
  else do:
     message "save and exit" view-as alert-box.
     ttplan.plan:column-dcolor in browse bplan = 7.
     edit-mode = false.
     bedd:label = "F9 - РЕДАКТИРОВАНИЕ".	
     /*сохраняем значения */ 
     for each ttplan:
 	find first ttformula where ttformula.code = ttplan.code no-error.
	 if avail ttplan then do:
		if ttformula.plan <> ttplan.plan then ttformula.plan = ttplan.plan.
	 end.
	 else do:
	   return.
	 end.
     end.
     ttplan.plan:column-read-only in browse bplan = true.      
     bplan:read-only in frame f-plan = true.
	
  end.
end.

/* --------------------------------- */
on Escape,error of frame f-plan do:
  return.

end.


/******************************************************************************/

form
   ed-year	
      FORMAT "9999"
      LABEL  "Расчетный год" 
      HELP   "Номер расчетного года"
   ed-kvartal
      FORMAT "9"
      LABEL  "Номер квартала" 
      HELP   "Номер квартала" 
/*   ed-mode
      AT 4	
      LABEL  "Расчет в тысячах" 
      HELP   "Расчет в тысячах" */

WITH FRAME frParamed 1 COL OVERLAY CENTERED ROW 10 TITLE "[ КАКОЙ КВАРТАЛ РЕДАКТИРУЕМ? ]".

PAUSE 0.
UPDATE
   ed-year   
/*   ed-mode */ 
   ed-kvartal

WITH FRAME frParamed.

HIDE FRAME frParamed NO-PAUSE.


IF NOT (   KEYFUNC(LASTKEY) EQ "GO" 
        OR KEYFUNC(LASTKEY) EQ "RETURN") 
THEN LEAVE.

/******************************************************************************/


/* начало */
   dmin = date(entry((ed-kvartal * 2 - 1),datekvartals) + "/" + string (ed-year,"9999")) no-error.
     if error-status:error then do:
        message "ошибка формирования даты dmin" view-as alert-box.
    	return.	
     end.


/* создаем временную таблицу */

for each code where code.class = "СтатьиСметыРасх" and 
		       code.parent = "СтатьиСметыРасх" by code.code:
    find first formula where formula.DataClass-id = smeta and
				formula.var-id = code.val and
				formula.since = dmin no-error.
    if avail formula then do:
      create ttformula.
	ttformula.plan = integer (substring (formula.formula,1,length(formula.formula) - 1)) no-error.
	  if error-status:error then message 
		"ФОРМУЛА ДОЛЖНА СОДЕРЖАТЬ ТОЛЬКО ЦИФРОВОЕ ЗНАЧЕНИЕ ПОКАЗАТЕЛЯ!!!" view-as alert-box.
	ttformula.name = code.name.
	ttformula.Dataclass-id = smeta.
	ttformula.since = dmin.
	ttformula.code = code.code.
	ttformula.flCreate = false.
	ttformula.varid = code.val.
    end.
    Else do:
/*      message "else!!! " formula.formula view-as alert-box. */
      Create ttformula.
	ttformula.plan = 0.
	ttformula.name = code.name.
	ttformula.Dataclass-id = smeta.
	ttformula.since = dmin.
	ttformula.code = code.code.
	ttformula.flCreate = true.
	ttformula.varid = code.val.
    end.
end.

for each ttformula:
 create ttplan.
	ttplan.plan = ttformula.plan.
	ttplan.name = ttformula.name.
	ttplan.code = ttformula.code.
end.


/* main */
OPEN QUERY qplan FOR EACH ttplan.
ttplan.plan:column-dcolor = 7.
ttplan.plan:column-read-only =true.
Frame f-plan:title = "[ ПЛАН СМЕТЫ РАСХОДОВ НА " + string(ed-kvartal) + " КВАРТАЛ " 
			+ string (ed-year) + " ГОДА ]".

/*
ttplan.plan:column-dcolor = 1.
*/
PAUSE 0.
FRAME f-plan:VISIBLE = YES.

XATTRBLK:
DO
ON ERROR  UNDO XATTRBLK, LEAVE XATTRBLK
ON ENDKEY UNDO XATTRBLK, LEAVE XATTRBLK
WITH FRAME f-plan:

   PAUSE 0.

   ENABLE
      bPlan
      bedd  
   WITH FRAME f-plan.

   WAIT-FOR GO, END-ERROR OF FRAME f-plan FOCUS bplan.

END.

ASSIGN FRAME f-plan:visible = NO.

/* отладка 
for each ttplan:
   find first ttformula where ttformula.code = ttplan.code.
   message ttplan.code ":" string(ttformula.plan) ":" ttplan.plan view-as alert-box.

end.
   отладка */


for each ttformula:
  if ttformula.flcreate then do:
    /* создаем новую */
     create formula.
	formula.var-id = ttformula.varid.
	formula.var-name = ttformula.name.
	formula.upd-enable = false.
	formula.neg-enable = true.
	formula.dataclass-id = smeta.
	formula.formula = string(ttformula.plan) + chr(126).
	formula.since = dmin.   
  end.
  Else do:
   /* редактируем существ. */
    find first formula where formula.DataClass-id = smeta and
				formula.var-id = ttformula.varid and
				formula.since = dmin no-error.
    if avail formula then do:
          formula.formula = string(ttformula.plan) + chr(126).
/*          message ttformula.code string(ttformula.plan) "<--" formula.formula " " view-as alert-box.
*/
    end.
  end.
end.

message "Данные успешно сохранены." view-as alert-box.

