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

DEF VAR cFileName AS CHARACTER NO-UNDO.
DEF VAR in-sec LIKE sec-code.sec-code INIT "*" FORMAT "xxxx" NO-UNDO.

pause 0.

beg-date = TODAY - INTEGER(iParmStr).
end-date = ?.

{pir-oborot1_svod.def}