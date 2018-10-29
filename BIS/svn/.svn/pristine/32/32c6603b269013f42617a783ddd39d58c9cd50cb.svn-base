{pirsavelog.p}

/*-----------------------------------------------------------------------------
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2003 ТОО "Банковские информационные системы"
     Filename: sw-uni.p
      Comment: Универсальный мемордер по шаблону
   Parameters:
         Uses: 
      Used by:
      Created: 27/05/2003 Peter
     Modified: 12.12.2006 10:03 Бурягин Е.П.
               Изменил файл sw-uni.i (комментарий см. там)
-----------------------------------------------------------------------------*/
form "~n@(#) sw-uni.p Peter Peter" with frame sccs-id stream-io width 250.

DEF VAR CountRecord AS INTEGER.

{globals.i}
{wordwrap.def}
{intrface.get strng}
{flt-val.i}
{sw-uni.def &NEW=NEW}
{sw-uni.pro &ALL_PROC=YES}

RUN LoadTemplate(GetParamByNameAsChar(iParam, "Шаблон", ?)).
IF GetParamByNameAsChar(iParam, "Процедура", "") <> "" THEN DO:
  IF SEARCH(GetParamByNameAsChar(iParam, "Процедура", "") + ".p") = ? THEN DO:
    MESSAGE "Не найдена процедура сбора данных """ + GetParamByNameAsChar(iParam, "Процедура", "") + """!" VIEW-AS ALERT-BOX ERROR.
    RETURN.
  END.
  ELSE
    RUN VALUE(GetParamByNameAsChar(iParam, "Процедура", "") + ".p").
END.
ELSE
  IF GetParamByNameAsChar(iParam, "Проводки", "Нет") = "Нет" THEN 
    RUN sw-unico.p.
  ELSE
    RUN sw-unice.p.

HIDE MESSAGE NO-PAUSE.
{strtout3.i}
CountRecord = 0.
FIND FIRST _user WHERE _user._userid = USERID("bisquit") NO-LOCK NO-ERROR.
{empty tt-tot}
RUN PrintHeader.
FOR EACH tt-ope BREAK BY tt-ope.grp BY tt-ope.sort BY tt-ope.sortd DESCENDING:
  CountRecord = CountRecord + 1.
  IF FIRST-OF(tt-ope.grp) THEN DO:
    CREATE tt-tot.
    ASSIGN
      tt-tot.grp = tt-ope.grp
      tt-tot.val = FILL(",", NUM-ENTRIES(fBreakAccum) - 1)
    .
    tt-tot.grpr = GetRealBreakValue(fBreakField).
  END.
  ELSE
    FIND FIRST tt-tot WHERE tt-tot.grp = tt-ope.grp NO-LOCK.
  ASSIGN
    tt-tot.val = GetAccum(fBreakAccum, tt-tot.val)
    tt-tot.cnt = tt-tot.cnt + 1.
  .
  RUN PrintBody.
  IF LAST-OF(tt-ope.grp) THEN RUN PrintSubTotal(tt-ope.grp, fBreakAccum).
  IF LAST(tt-ope.grp) THEN RUN PrintTotal(fBreakAccum).
END.
RUN PrintFooter.
{endout3.i}
