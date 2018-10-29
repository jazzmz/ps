{pirsavelog.p}

/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-1998 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: p-depo.p
      Comment: ����祭�� ���� �� �ਥ�/��⨥ ��
      Comment:
   Parameters: Input: RID -  RecID(op)
         Uses: Globals.I ChkAcces.I SetDest.I PreView.I
      Used by:
      Created: 22/11/99 19:36:48 Lera
     Modified:
*/
Form "~n@(#) p-depo(p.p 1.0 Lera 22/11/99 Lera 22/11/99 "
     with frame sccs-id stream-io width 250.

{globals.i}
{chkacces.i}
/*-------------------- �室�� ��ࠬ���� --------------------*/
Define Input Param RID as RecID no-undo.

/*-------------------- ������� ��६����� --------------------*/

Define Buffer buf_0_op               For op.

/*--------------- ���� ��� ����� ��: ---------------*/

/*--------------- ��६���� ��� ᯥ樠���� �����: ---------------*/
Define Variable AcctCr           As Character            No-Undo.
Define Variable AcctDb           As Character            No-Undo.
Define Variable BankName         As Character            No-Undo.
Define Variable Dep              As Character            No-Undo.
Define Variable DepCr            As Character            No-Undo.
Define Variable reg-num          As Character            No-Undo.
Define Variable sum-nom          As Decimal              No-Undo.

Def Var FH_p-depo-1 as integer init 5 no-undo. /* frm_1: ���. ��ப �� ���室� �� ����� ��࠭��� */


/* ��砫�� ����⢨� */
{wordwrap.def}
{get-fmt.i &obj=D-Acct-Fmt}
{rekv-dop.i}


define variable signs-code-val as character no-undo.
def var AcctName as char extent 2 no-undo.
def buffer acct-buf1 for acct.
def buffer acct-buf2 for acct.
def var summ-all as dec no-undo.
def var summ-kol as dec no-undo.


/*-----------------------------------------
   �஢�ઠ ������ ����� ������� ⠡����, �� ������ 㪠�뢠�� Input Param RID
-------------------------------------------*/
Find op Where RecID(op) = RID no-lock no-error.
If Not Avail(op) then do:
  message "��� ����� <op>".
  Return.
end.

/*------------------------------------------------*/
/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� BankName */
BankName = dept.name-bank.

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� Dep */
find first op-entry of op no-lock.
if not avail op-entry then do:
      message "� ����祭��: " + op.doc-num + " ��� �஢����." view-as alert-box.
      return.
end.

find first acct-buf1 where acct-buf1.acct = op-entry.acct-db no-lock no-error.
if not avail acct-buf1 then do:
   message "��� �� ������: " + op-entry.acct-db + " ��������� � �ࠢ�筨�� ��楢�� ��⮢." view-as alert-box.
   return.
end.
find first acct-buf2 where acct-buf2.acct = op-entry.acct-cr no-lock no-error.
if not avail acct-buf2 then do:
   message "��� �� �।���: " + op-entry.acct-cr + " ��������� � �ࠢ�筨�� ��楢�� ��⮢." view-as alert-box.
   return.
end.
if not ((acct-buf2.side = "�" and acct-buf1.side = "�") or (acct-buf1.side = "�" and acct-buf2.side = "�")) then do:
   message "������ ����祭�� ���⠥��� ⮫쪮 �� ����ᯮ����樨 ��⨢���� � ���ᨢ���� ��楢��� ���." view-as alert-box.
   return.
end.
signs-code-val = GetXAttrValue("acct",(if acct-buf2.side = "�" then acct-buf2.acct else acct-buf1.acct) + "," + (if acct-buf2.side = "�" then acct-buf2.currency else acct-buf1.currency),"����").
if signs-code-val ne "" then do:
   find first loan where loan.contract = "�����" and
                         loan.cont-code = signs-code-val and
                         loan.class-code = "depoacct" no-lock no-error.

   if avail loan then do:
       case loan.cust-cat:
           when "�" then do:
               find first cust-corp of loan no-lock no-error.
               Dep = if avail cust-corp then cust-corp.cust-stat + " " + cust-corp.name-corp else "".
           end.
           when "�" then do:
               find first person where person.person-id = loan.cust-id no-lock no-error.
               Dep = if avail person then person.name-last + " " + person.first-names else "".
           end.
           when "�" then do:
               find first banks where banks.bank-id = loan.cust-id no-lock no-error.
               Dep = if avail banks then banks.name else "".
           end.
        end case.
   end.
end.


/*-------------------- ��ନ஢���� ���� --------------------*/
{strtout3.i &cols=106 &option=Paged}
find first _user where _user._userid = op-entry.user-id no-lock.

put unformatted "            " at 60 skip.
put unformatted "������������������������������������������������������������������������Ŀ" at 45 skip.
put unformatted caps(BankName) format "x(40)" at 1.
put unformatted "� ��� �ਥ�� '___' ________200_�.      � �������樨 ����祭�� ________ �" at 45 skip.
put unformatted "� �६� �ਥ�� ___��______���.         ������� ________________________ �" at 45 skip.
put unformatted "������������������������������������������������������������������������Ĵ" at 45 skip.
put unformatted "                                                                          " at 45 skip.
put unformatted "                                                                          " at 45 skip(1).
put unformatted "����������������������������������������������������������������������������������������������������������������������" at 1 skip(1).
put unformatted "                                        ��������� ���� � _____________ " skip
                "                                       �� ����� ������ ����� �� ���� ����" skip(1)
                "�. ��᪢�                                                                                    "
                {term2str op-entry.op-date op-entry.op-date yes} skip(1).

put unformatted space(int((110 - length(Dep)) / 2))  caps(Dep) skip.
put unformatted "���������������������������������������������������������������������������������������������������������������������" skip
                "               ������ ������������ �࣠����樨 - �������� ��� ����, �.�.�. - ��� 䨧.���" skip(2).
put unformatted "��������������������������������������������������������������������������������������������������������������������Ŀ" skip
                "� ����� ����� ���� ��������� �����                                                           �  "
      string(signs-code-val,"x(19)") "  �"  skip
                "����������������������������������������������������������������������������������������������������������������������" skip(1).
put unformatted "                                                             " skip
                "��� 業��� �㬠�� (�⬥��� ⨯ 業��� �㬠�, �� ����� ������ ����祭��) " skip(1).
put unformatted "�Ŀ" "������樨 ���㤠��⢥����� ᡥॣ�⥫쭮�� ����� ��������⢠ 䨭��ᮢ �� (����)" skip
                "���" skip
                "��" " ���ᥫ�(�)  " entry(1,dop-rekviz("sec-code",(if acct-buf1.side = "�" then acct-buf1.currency else acct-buf2.currency),"issue_cod","name"),"[") skip
                "��" "            ����������������������������������������������������������������������������" skip
                "�Ŀ" "��樨" skip
                "���" skip
                "�Ŀ" "������樨 ����७���� ����⭮�� ���㤠��⢥����� ����� (�����)" skip
                "���" skip(2).

put unformatted "��������������������������������������������������������������������������������������������������������������������Ŀ" skip
                "� ����� ���       �   �������       � ����������� �    ����������   � ����� ��������� (�� ��������), ���.            �" skip
                "� ������          �     ���.        � ��� ��      � ������ ����� ��.�                                                �" skip
                "��������������������������������������������������������������������������������������������������������������������Ĵ" skip.
summ-all = 0.
summ-kol = 0.
for each op-entry of op no-lock:
     /* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� reg-num */
     find first sec-code where sec-code.sec-code = op-entry.currency no-lock no-error.
     find last instr-rate where instr-rate.instr-cat = "sec-code" and
                                instr-rate.rate-type = "�������" and
                                instr-rate.since <= op-entry.op-date and
                                instr-rate.instr-code = op-entry.currency no-lock no-error.  /* ��諨 ������� ��� ������ �㬠�� */
     put unformatted "�" (if avail sec-code then sec-code.reg-num else " ") format "x(17)"
                     "�" (if avail instr-rate then instr-rate.rate-instr else 0) format ">>>>>>>>>>>>>9.99"
                     "� " (if avail sec-code then sec-code.sec-code else " ") format "x(12)"
                     "�" op-entry.amt-rub format ">>>>>>>>>>>>>9.99"
                     "�" ((if avail instr-rate then instr-rate.rate-instr else 0) * op-entry.amt-rub) format ">>>>>>,>>>,>>>,>>>,>>9.99"
                     "�" at 118 skip.
     summ-kol = summ-kol + op-entry.amt-rub.
     summ-all = summ-all + ((if avail instr-rate then instr-rate.rate-instr else 0) * op-entry.amt-rub).
end.

put unformatted "��������������������������������������������������������������������������������������������������������������������Ĵ" skip
                "� �����           �                 �             �" summ-kol format ">>>>>>>>>>>>>9.99"
                "�" summ-all format ">>>>>>,>>>,>>>,>>>,>>9.99" "�" at 118 skip.

put unformatted "����������������������������������������������������������������������������������������������������������������������" skip.
put unformatted "���������: " op.details skip(1)
                "                                                                     ������������������������������������������Ŀ" skip
                "                                                                     �      ������� �� ���������� ���������     �" skip
                "                                                                     �                                          �" skip
                "                                                                     � ���������������������������������������� �" skip
                "                                                                     �   (�.�.�. 㯮�����祭���� ���㤭���)    �" skip
                "                                                                     �                                          �" skip
                "                                                                     � ������� ��������������� ����������       �" skip
                "                                                                     � �����������:                             �" skip
                "                                                                     �                                          �" skip
                "                                                                     � ���������������������������������������� �" skip
		"                                                                     � ��� �ᯮ������ '__'______________200_�. �" skip
		"                                                                     ��������������������������������������������" skip
                "           " skip.

/* put unformatted "���㤠��⢥��� ����� 業��� �㬠��: " reg-num Format "x(12)" skip(1).

put unformatted "��᫮ ��: " op-entry.amt-rub skip(1).

put unformatted "�᭮����� ᮢ��蠥��� ����樨: " buf_0_op.details Format "x(100)" skip(1).

put unformatted "��� �ᯮ������ ����樨: " buf_0_op.op-date Format "99/99/9999" skip(2).

put unformatted "��������祭��� ��� " skip.
  */
{endout3.i &nofooter=yes}
