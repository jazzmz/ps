DEF INPUT PARAMETER iTarif as CHAR.
DEF OUTPUT PARAMETER outTarif as CHAR.

def buffer code for code.
def var cName as char FORMAT "x(59)" NO-UNDO.
def var isnew as logical init yes no-undo.
def buffer bcode for code.
DEF VAR cDescription AS CHAR VIEW-AS EDITOR SIZE 48 BY 7 NO-UNDO.

find last code where code.class = "PirTarifMain" and code.code = iTarif NO-ERROR.
if available code then do:
  cName = code.name.
  cDescription = code.description[1].
  isnew = false.
end.

def frame fSet
"Наименование тарифного плана: " cName skip(1)
"Описание:" cDescription
   WITH CENTERED NO-LABELS TITLE "Введите данные".

DISPLAY cName cDescription WITH FRAME fSet.

ON LEAVE OF cName IN FRAME fSet DO:
   if (INPUT cName) = "" or (INPUT cName) = ? then 
	do:
	   MESSAGE "Заведение тарифного плана с пустым наименованием не допускается!" VIEW-AS ALERT-BOX.
	   RETURN NO-APPLY.
	end.
  find first bcode where bcode.code <> iTarif 
	       and bcode.class = "PirTarifMain" 
	       and bcode.parent = "PirTarifMain" 
	       and bcode.name = (INPUT cName) NO-LOCK NO-ERROR.

  if AVAILABLE(bcode) then 
      do:
	 MESSAGE "Уже существует тарифный план с наименованием: " (INPUT cName) VIEW-AS ALERT-BOX.
	 RETURN NO-APPLY.
      end.

END.


SET cName cDescription WITH FRAME fSet.



if isnew then do:
create code.
find last bcode where bcode.class = "PirTarifMain" NO-LOCK. 
assign 
      code.code = TRIM(String(DEC(bcode.code) + 1,">>>>>>>9"))
      code.parent = "PirTarifMain"
      code.class = "PirTarifMain".
end.

assign 
      code.name = cName
      code.description[1] = cDescription.

outTarif = code.code.

