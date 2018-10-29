{pirsavelog.p}


                   /*******************************************
                    *                                         *
                    *  ������� ������������ � �������������!  *
                    *                                         *
                    *  ������������� ������ ���� ����������,  *
                    *  �.�. �� ��������� ����������� �������  *
                    *             �������������!              *
                    *                                         *
                    *******************************************/

/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2006 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: memorv.p
      Comment: ����, ᮧ����� ������஬ ���⮢
      Comment:
   Parameters: Input: RID -  RecID(op)
         Uses: Globals.I ChkAcces.I SetDest.I PreView.I
      Used by:
      Created: 13/06/06 17:26:47
     Modified:
*/
Form "~n@(#) memorv.p 1.0 RGen 13/06/06 RGen 13/06/06 [ AutoReport By R-Gen ]"
     with frame sccs-id stream-io width 250.

{globals.i}
{chkacces.i}
/*-------------------- �室�� ��ࠬ���� --------------------*/
Define Input Param RID as RecID no-undo.

/*-------------------- ������� ��६����� --------------------*/

/*--------------- ���� ��� ����� ��: ---------------*/
Define Buffer buf_0_op               For op. /* ���� ��� op, ஫� '��� ᠬ� Op, ��� ����� ������� �஢����' */

/*--------------- ��६���� ��� ᯥ樠���� �����: ---------------*/
Define Variable AmtStr           As Character Extent   2 No-Undo.
Define Variable Detail           As Character Extent   5 No-Undo.
Define Variable PlCAcct          As Character            No-Undo.
Define Variable PlLAcct          As Character            No-Undo.
Define Variable PlMFO            As Character            No-Undo.
Define Variable PlName           As Character Extent   5 No-Undo.
Define Variable PlRKC            As Character Extent   2 No-Undo.
Define Variable PoAcct           As Character            No-Undo.
Define Variable PoCAcct          As Character            No-Undo.
Define Variable PolMFO           As Character            No-Undo.
Define Variable PoName           As Character Extent   3 No-Undo.
Define Variable PoRKC            As Character Extent   2 No-Undo.
Define Variable Rub              As Character            No-Undo.
Define Variable theDate          As Character            No-Undo.
Define Variable type-doc         As Character            No-Undo.
Define Variable Val              As Character            No-Undo.
Define Variable ValStr           As Character Extent   2 No-Undo.

/*--------------- ��।������ �� ��� 横��� ---------------*/

/* ��砫�� ����⢨� */
{wordwrap.def}
{pick-val.i}

Def Var InCity  as logic          no-undo.
Def Var NameCli as char  extent 2 no-undo.
Def Buffer Bank1 for Banks.

def var bank-cor-acct as char form "x(20)" no-undo.
{get_set.i "�����"}
bank-cor-acct = setting.val.

/*-----------------------------------------
   �஢�ઠ ������ ����� ������� ⠡����,
   �� ������ 㪠�뢠�� Input Param RID
-------------------------------------------*/
Find op Where RecID(op) = RID no-lock no-error.
If Not Avail(op) then do:
  message "��� ����� <op>".
  Return.
end.

/*------------------------------------------------
   ���⠢��� buffers �� �����, ��������
   � ᮮ⢥��⢨� � ������묨 � ���� �ࠢ�����
------------------------------------------------*/
/* �ࠢ��� ��� ������� ⠡���� op */
function BankNameCity return char (buffer b for banks):
  return {banknm.lf b} + (if {bankct.lf b} <> "" then ', ' else '') +
         {bankct.lf b}.
end function.
         
{bank-id.i}

find op where RecID(op) = RID no-lock.
find first op-bank of op no-lock no-error.
find op-entry of op no-lock no-error.

if Ambig(op-entry) then do:
  Bell.
  {message &text="|� ���㬥��� �⭮���� ����� ����� �஢����!"
           &alert-box="error"}.
  Return.
end.

/* Find PlName */
find first acct where acct.acct = op-entry.acct-db no-lock.
{getcust.i &name=NameCli}
PlLAcct = op-entry.acct-db.
PlName[1] = NameCli[1] + " " + NameCli[2].
{wordwrap.i &s=PlName &n=5 &l=35}

/* Find PoName */
find first acct where acct.acct = op-entry.acct-cr no-lock.
{getcust.i &name=NameCli}
PoAcct = op-entry.acct-cr.
PoName[1] = NameCli[1] + " " + NameCli[2].
{wordwrap.i &s=poName &n=3 &l=35}

/* ���⠢�� buf_0_op �� op ஫� '��� ᠬ� Op, ��� ����� ������� �஢����' */
Find buf_0_op Where RecID(buf_0_op) = RecID(op) no-lock.

/*------------------------------------------------
   ���᫨�� ���祭�� ᯥ樠���� �����
   � ᮮ⢥��⢨� � ������묨 � ���� �ࠢ�����
------------------------------------------------*/
/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� AmtStr */
Run x-amtstr.p(op-entry.amt-rub,'',true,true,output amtstr[1], output amtstr[2]).
if trunc(op-entry.amt-rub,0) = op-entry.amt-rub
 then AmtStr[2] = ''.
 else AmtStr[1] = AmtStr[1] + ' ' + AmtStr[2].
{wordwrap.i &s=AmtStr &n=2 &l=70} 
Substr(AmtStr[1],1,1) = Caps(Substr(AmtStr[1],1,1)).

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� Detail */
Detail[1] = if op.details <> ? then op.details else "".
{wordwrap.i &s=Detail &n=5 &l=80}

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� PlCAcct */
PlCAcct = bank-acct. /* bank-cor-acct <- setting */

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� PlLAcct */
/* */

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� PlMFO */
PlMFO = {out-fmt.i string(int(bank-mfo-9),fill('9',9)) 'xxxxxxxxx' }.

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� PlName */
/* In Rule 4 Table Op */

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� PlRKC */
{get_set.i "����"}
PlRKC[1] = setting.val.

{getbank.i bank1 bank-mfo-9}
if avail bank1 then  PlRKC[1] = BankNameCity(buffer bank1).
               else  PlRKC[1] = "".
{wordwrap.i &s=PlRKC &n=2 &l=35}

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� PoAcct */
/* */

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� PoCAcct */
PoCAcct = bank-acct.  /* bank-cor-acct <- setting */

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� PolMFO */
PolMFO = {out-fmt.i string(int(bank-mfo-9),fill('9',9)) 'xxxxxxxxx' }.

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� PoName */
/* In PoAcct */

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� PoRKC */
/*{get_set.i "����"}
PoRKC[1] = setting.val.*/

{getbank.i bank1 bank-mfo-9}
if avail bank1 then PoRKC[1] = BankNameCity(buffer bank1).
               else PoRKC[1] = "".
{wordwrap.i &s=PoRKC &n=2 &l=35}

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� Rub */
if trunc(op-entry.amt-rub,0) = op-entry.amt-rub 
  then 
Rub = string(string(op-entry.amt-rub * 100, "-zzzzzzzzzz999"),"x(12)=").
  else 
Rub = string(string(op-entry.amt-rub * 100, "-zzzzzzzzzz999"),"x(12)-x(2)").

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� theDate */
if op.doc-date <> ? then
  theDate = {strdate.i op.doc-date}.
else
  theDate = {strdate.i op.op-date}.

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� type-doc */
/* find doc-kind */

find first doc-type where doc-type.doc-type = op.doc-type no-lock no-error.
if avail doc-type then type-doc = doc-type.digital.
                  else type-doc = "".

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� Val */
if trunc(op-entry.amt-cur,0) = op-entry.amt-cur
  then 
Val = string(string(op-entry.amt-cur * 100, "-zzzzzzzzzz999"),"x(12)=").
  else 
Val = string(string(op-entry.amt-cur * 100, "-zzzzzzzzzz999"),"x(12)-x(2)").

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� ValStr */
Run x-amtstr.p(op-entry.amt-cur,op-entry.currency,true,true,output valstr[1], output valstr[2]).
if trunc(op-entry.amt-cur,0) = op-entry.amt-cur
 then ValStr[2] = ''.
 else ValStr[1] = ValStr[1] + ' ' + ValStr[2].
{wordwrap.i &s=ValStr &n=2 &l=70} 
Substr(ValStr[1],1,1) = Caps(Substr(ValStr[1],1,1)).

/*-------------------- ��ନ஢���� ���� --------------------*/
{strtout3.i &cols=80 &option=Paged}

put unformatted "                                                                       �������Ŀ" skip.
put unformatted "                                                                       �0401108�" skip.
put unformatted "������������ �����  N " buf_0_op.doc-num Format "x(6)"
                "   " theDate Format "x(20)"
                "                    ���������" skip.
put unformatted "                                     (���)" skip.
put unformatted " �㬬�  � " ValStr[1] Format "x(70)"
                "" skip.
put unformatted "�ய���� " ValStr[2] Format "x(70)"
                "" skip.
put unformatted "��������������������������������������������������������������������������������" skip.
put unformatted " �㬬�  � " AmtStr[1] Format "x(70)"
                "" skip.
put unformatted "�����.� " AmtStr[2] Format "x(70)"
                "" skip.
put unformatted "��������������������������������������������������������������������������������" skip.
put unformatted "" PlName[1] Format "x(35)"
                " � �㬬� � " Val Format "x(15)"
                "" skip.
put unformatted "" PlName[2] Format "x(35)"
                " �������Ĵ" skip.
put unformatted "" PlName[3] Format "x(35)"
                " ���.�� " Rub Format "x(15)"
                "" skip.
put unformatted "" PlName[4] Format "x(35)"
                " ��������������������������������������������" skip.
put unformatted "" PlName[5] Format "x(35)"
                " � ��.N  � " PlLAcct Format "x(25)"
                "" skip.
put unformatted "                                    �       �" skip.
put unformatted " ���⥫�騪                         �       �" skip.
put unformatted "�������������������������������������������Ĵ" skip.
put unformatted "" PlRKC[1] Format "x(35)"
                " �  ���  � " PlMFO Format "x(9)"
                "" skip.
put unformatted "" PlRKC[2] Format "x(35)"
                " �������Ĵ" skip.
put unformatted "                                    � ��.N  � " PlCAcct Format "x(25)"
                "" skip.
put unformatted " ���� ���⥫�騪�                   �       �" skip.
put unformatted "��������������������������������������������������������������������������������" skip.
put unformatted "" PoRKC[1] Format "x(35)"
                " �  ���  � " PolMFO Format "x(9)"
                "" skip.
put unformatted "" PoRKC[2] Format "x(35)"
                " �������Ĵ" skip.
put unformatted "                                    � ��.N  � " PoCAcct Format "x(25)"
                "" skip.
put unformatted " ���� �����⥫�                    �       �" skip.
put unformatted "�������������������������������������������Ĵ" skip.
put unformatted "" PoName[1] Format "x(35)"
                " � ��.N  � " PoAcct Format "x(25)"
                "" skip.
put unformatted "" PoName[2] Format "x(35)"
                " �       �" skip.
put unformatted "" PoName[3] Format "x(35)"
                " �       �" skip.
put unformatted "                                    ��������������������������������������������" skip.
put unformatted "                                    ���� ��.� " type-doc Format "x(2)"
                "       ��ப ����.�" skip.
put unformatted "                                    �������Ĵ          ����������Ĵ" skip.
put unformatted "                                    ����.��.�          ����.����.� " buf_0_op.order-pay Format "x(2)"
                "" skip.
put unformatted "                                    �������Ĵ          ����������Ĵ" skip.
put unformatted " �����⥫�                         ����    �          ����.����  �" skip.
put unformatted "��������������������������������������������������������������������������������" skip.
put unformatted " �����祭�� ���⥦�, ������������ ⮢��, �믮������� ࠡ��, ��������� ���," skip.
put unformatted " NN � ���� ⮢���� ���㬥�⮢, ���" skip.
put unformatted "" Detail[1] Format "x(80)"
                "" skip.
put unformatted "" Detail[2] Format "x(80)"
                "" skip.
put unformatted "" Detail[3] Format "x(80)"
                "" skip.
put unformatted "" Detail[4] Format "x(80)"
                "" skip.
put unformatted "" Detail[5] Format "x(80)"
                "" skip.
put unformatted "��������������������������������������������������������������������������������" skip.
put unformatted "                        ������                          �⬥⪨ �����" skip.
put skip(2).
put unformatted "                 �����������������������" skip.
put unformatted "      �.�." skip.
put skip(1).
put unformatted "                 �����������������������" skip.

{endout3.i &nofooter=yes}

