{pirsavelog.p}

/*
                ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright:  (C) 1992-1997 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename:  i56#.p
      Comment:  ��楤�� ���� ������ ��� ���ᮢ�� �� �� ���㤭����
                ����� i56_1
         Uses:  sv-calc.i, i56#.def, i56#.i, i56#.ii, i56#.cr
      Created:  17/10/01 Olenka
     Modified:
*/
Form "~n@(#) I56#.p 17/10/01 Olenka ��楤�� ���� ������ ��� ���ᮢ�� �� �� ���㤭����"
with frame sccs-id stream-io width 250.

{sv-calc.i}
{i56#.def}
{op-cash.def}

/* ��᪨ �����ᮢ�� ��⮢ ��� ��।������ �ப� �࠭���� ���㬥�� */
run find_formula in h_olap (DataClass.DataClass-id,"i56_75",
                            DataBlock.End-Date,yes, buffer formula).
if avail formula 
then
   assign
      list_bal = replace(formula.formula,"~~","")
      list_bal = replace(list_bal,";",",")
   .

end-date = datablock.end-date .
find first branch 
     where branch.branch-id = DataBlock.Branch-id 
           no-lock no-error.

/* ������塞 tt */
do i = 1 to num-entries(param-calc) :
   cur-cat = entry(i,param-calc).
   {i56#a.i}
end.

/* �롮ઠ �� ����, �� �� ������� � ���������� �����*/
for each xentry 
         no-lock,
   first op 
   where xentry.op = op.op 
         no-lock:

   /* ��� ࠧ� ������ ���������, �᫨ ���� � � ����� � � �।�� */
   if     xentry.branch-db = branch.branch-id 
      and xentry.iscash-db 
      and xentry.polupr <> "d" 
   then do:
      db_cr = "db".
      run create_dl.
   end.
   if     xentry.branch-cr = branch.branch-id 
      and xentry.iscash-cr 
      and xentry.polupr <> "c" 
   then do:
      db_cr = "cr".
      run create_dl.
   end.

end.
return "".

function getnumop return dec
   (input papka as char):
   find first oprec 
        where oprec.dlrec = recid(TDataLine) 
          and oprec.papka = papka 
          and oprec.oprec = recid(op) 
              no-lock no-error.
   if avail oprec 
   then return 0.0.

   create oprec.
   assign 
          oprec.dlrec = recid(TDataLine)
          oprec.papka = papka
          oprec.oprec = recid(op)
   .
   return 1.0.
end.
/* ���࠭���� */
procedure create_dl.
   run cr_dl (xentry.user-inspector,
              xentry.user-id,
              xentry.acct-cat,
              (if db_cr = "db" 
               then xentry.curr-db 
               else xentry.curr-cr), 
              db_cr).

   /* �஢��塞 ����� */
   if db_cr = "db" 
   then
      papka = if can-find(first acct 
                          where acct.acct = xentry.acct-cr 
                            and acct.currency begins xentry.curr-cr 
                            and can-do(list_bal,string(acct.bal-acct))) 
              then "75" 
              else "5" .
   else
      papka = if can-find(first acct 
                          where acct.acct = xentry.acct-db 
                            and acct.currency begins xentry.curr-db 
                            and can-do(list_bal,string(acct.bal-acct))) 
              then "75" 
              else "5" .
   if papka = "75" 
   then
      assign
         TDataLine.Val[3] = TDataLine.Val[3] + (if TDataLine.Sym3 > "" 
                                                then xentry.vamt 
                                                else 0)
         TDataLine.Val[4] = TDataLine.Val[4] + xentry.amt
         TDataLine.Val[8] = TDataLine.Val[8] + getnumop("75")
      .
   /* 5 ��� �࠭���� ������� � ᥡ� � 75 ��� ⮦� */
   assign
      TDataLine.Val[1] = TDataLine.Val[1] + (if TDataLine.Sym3 > "" 
                                             then xentry.vamt 
                                             else 0)
      TDataLine.Val[2] = TDataLine.Val[2] + xentry.amt
      TDataLine.Val[6] = TDataLine.Val[6] + getnumop("5")
   .
end.

/* �������� ����� */
procedure cr_dl.
   def input param in-kas_user as char no-undo. /* Sym1 */
   def input param in-opr_user as char no-undo. /* Sym1 */
   def input param in-acct-cat as char no-undo. /* Sym2 */
   def input param in-currency as char no-undo. /* Sym3 */
   def input param in-db_cr    as char no-undo. /* Sym4 */

   find first TDataLine of DataBlock 
        where TDataLine.Sym1 = in-kas_user + "_" + in-opr_user 
          and TDataLine.Sym2 = in-acct-cat 
          and TDataLine.Sym3 = in-currency 
          and TDataLine.Sym4 = in-db_cr 
              no-error.
   if not avail TDataLine 
   then do:
      create TDataLine.
      assign 
             TDataLine.Data-id = Datablock.Data-id
             TDataLine.Sym1    = in-kas_user + "_" + in-opr_user
             TDataLine.Sym2    = in-acct-cat
             TDataLine.Sym3    = in-currency
             TDataLine.Sym4    = in-db_cr
      .
      find first _user 
           where _user._userid = in-kas_user 
                 no-lock no-error.
      TDataLine.Txt = (if avail _user 
                       then _user._user-name 
                       else "").
      find first _user 
           where _user._userid = in-opr_user 
                 no-lock no-error.
      TDataLine.Txt = TDataLine.Txt + "~n" + (if avail _user 
                                              then _user._user-name 
                                              else "").
   end.
end.

