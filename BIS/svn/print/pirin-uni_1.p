/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-1997 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: pp-uni.p
      Comment: ������ᠫ쭠� ��楤�� ���� �����ᮢ��� ����祭��

      Comment:
   Parameters: Input: RID -  RecID(op)
         Uses: Globals.I ChkAcces.I StrtOut3.I EndOut3.I
      Used by:
      Created: 25.10.2000 Kostik
     Modified: 29/04/2003 kraw 0016138 �������� ����᪨� �뢮�
     Modified: 18/12/2003 kraw 0023749 ��� ���஭���� �����ᮢ��� ����祭��
     Modified: 12/01/2005 kraw 0040840 ����䨪��� ����� ���⥫�騪� (�� "�106�_��⏫��")
     Modified: 13/12/2012 aeg ������� �⠬� � ��⠬� � 䠬���ﬨ
*/
Form "~n@(#) pp-uni.p 1.0 Kostik 02.03.2000 Kostik 02.03.2000 ������ᠫ�� �/�" with frame sccs-id width 250.

{globals.i}                                 /* �������� ��६����         */
{chkacces.i}
{intrface.get xclass}
&GLOB tt-op-entry yes
&SCOP TEST YES
&GLOBAL-DEFINE OFFSIGNS YES
&IF "{&TEST}" EQ "YES" &THEN
   DEF STREAM test.
   OUTPUT STREAM test TO "test.pp".
&ENDIF
&IF defined(NEW_1256) NE 0 &THEN
   &SCOP NEW_1256 YES
&ENDIF

{pirpp-uni.var}                                /* ��।������ ��६�����        */

DEF VAR beg-row AS INT NO-UNDO.
DEF VAR end-row AS INT NO-UNDO.

/* ��� �⬥⪨ �����-�����⥫� */
DEFINE VARIABLE mDateMarcRec AS CHARACTER NO-UNDO.
DEFINE VARIABLE mPrnStr-El-Doc AS CHARACTER NO-UNDO EXTENT 7 FORMAT "x(27)".
DEFINE VARIABLE mMark-El-Doc   AS LOGICAL   NO-UNDO.

&IF DEFINED(FRM_PRN) EQ 0 &THEN
   {in-uni.frm}                                /* ��।������ �३��            */
&ELSE
   {{&FRM_PRN}}
&ENDIF
{pp-uni.err}                                /* ᮮ�饭�� �� �訡���          */
{pirpp-uni.prg}                     /* ���ᠭ�� �⠭������ ��楤�� */

{pp-uni.chk}                                /* �஢�ઠ �室��� ������       */

{pp-uni.run}                                /* �����।�⢥��� ����        */
&IF DEFINED(in-el) NE 0 &THEN   /* ��� ���஭���� �����ᮢ��� ����祭�� */
{{&in-el} &in-run=YES}
&ENDIF

&IF "{&TEST}" EQ "YES" &THEN
   OUTPUT STREAM test CLOSE.
&ENDIF

ASSIGN
   NameOrder  = "���������� ��������� N"
   NumberForm = "0401071"
.

{nal_name.i}

{strtout3.i &cols=80 &option=Paged}  /* �����⮢�� � �뢮��           */
mDateCart = DATE(GetXAttrValueEx("op", STRING(op.op), "��⠏���饭����",?)).
mDateMarcRec = GetXAttrValueEx("op", STRING(op.op), "��⠎⬁���", "").

mMark-El-Doc = LOGICAL(GetXAttrValueEx("op-kind",
                                       op.op-kind,
                                       "Mark-El-Doc",
                                       "���"), "��/���").
IF mMark-El-Doc THEN
DO:
   mPrnStr-El-Doc[1] = REPLACE(FGetSetting("PrnStr-El-Doc", "", ""), "|", "~n").
   {wordwrap.i &s=mPrnStr-El-Doc &n=7 &l=27}
END.


{in-uni.prn}                                /* �����।�⢥��� �뢮�         */ 

&IF defined(NEW_1256) NE 0 AND defined(NO_GRAPH) EQ 0 &THEN
IF iDoc EQ 1 THEN DO: 

   end-row = 72.
   beg-row =  1.
   theUserID = OP.user-id.
   FIND FIRST _user WHERE _user._userid EQ theUserID NO-LOCK NO-ERROR. 
   IF AVAILABLE (_user) THEN DO:
     IF _user._user-name NE ? THEN
          theUser = _user._user-name. 
   END.
   theKontr ="".

{pirlazerprn.lib &DATARETURN = 0401071.gen
                 &ELIT_POL   = "{&ELIT_POL}"
                 &FORM-DOC   = "71" 
                 &USER_SIGN_XY  = "VALUE('/X:3350 /Y:' + STRING((end-row - beg-row) * 75 - 550))"
                 {&*}} 
     


END.
&ENDIF 
{endout3.i  &nofooter=yes}                   /* �����襭�� �뢮��             */
