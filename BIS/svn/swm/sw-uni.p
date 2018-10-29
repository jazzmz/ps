{pirsavelog.p}

/*-----------------------------------------------------------------------------
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2003 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: sw-uni.p
      Comment: ������ᠫ�� ����थ� �� 蠡����
   Parameters:
         Uses: 
      Used by:
      Created: 27/05/2003 Peter
     Modified: 12.12.2006 10:03 ���� �.�.
               ������� 䠩� sw-uni.i (�������਩ �. ⠬)
-----------------------------------------------------------------------------*/
form "~n@(#) sw-uni.p Peter Peter" with frame sccs-id stream-io width 250.

DEF VAR CountRecord AS INTEGER.

{globals.i}
{wordwrap.def}
{intrface.get strng}
{flt-val.i}
{sw-uni.def &NEW=NEW}
{sw-uni.pro &ALL_PROC=YES}

RUN LoadTemplate(GetParamByNameAsChar(iParam, "������", ?)).
IF GetParamByNameAsChar(iParam, "��楤��", "") <> "" THEN DO:
  IF SEARCH(GetParamByNameAsChar(iParam, "��楤��", "") + ".p") = ? THEN DO:
    MESSAGE "�� ������� ��楤�� ᡮ� ������ """ + GetParamByNameAsChar(iParam, "��楤��", "") + """!" VIEW-AS ALERT-BOX ERROR.
    RETURN.
  END.
  ELSE
    RUN VALUE(GetParamByNameAsChar(iParam, "��楤��", "") + ".p").
END.
ELSE
  IF GetParamByNameAsChar(iParam, "�஢����", "���") = "���" THEN 
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
