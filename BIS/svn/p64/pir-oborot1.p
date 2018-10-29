/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-1998 ТОО "Банковские информационные системы"
     Filename: oborot1.p
      Comment: 1. Оборотная ведомомсть и 2. Сводная карточка ЦБ
               1 - форма обычно квартальная
               2 - печатается если дата начальная равна дате конечной.
   Parameters: 
         Uses:
      Used by:
      Created: 
     Modified: 07.12.01 Lera - причесали мордочку.
*/

{globals.i}
{sh-defs.i}
DEFINE INPUT PARAMETER iParmStr AS CHARACTER.
DEFINE VARIABLE cFileName AS CHARACTER NO-UNDO.

def var q  as int extent 12 initial [1,1,1,4,4,4,7,7,7,10,10,10] no-undo.
def var h  as int extent 12 initial [1,1,1,1,1,1,7,7,7,7,7,7] no-undo.
def var in-sec like sec-code.sec-code init "*" format "xxxx" NO-UNDO.
                                                             
pause 0.                                                     
/*{datedepo.i                                                
   &date1 = yes
   &date2 = yes
   &sec-cod = yes}*/
beg-date=TODAY - INTEGER(iParmStr).
end-date=TODAY - INTEGER(iParmStr).
in-sec="*".
{pir-oborot1.def}