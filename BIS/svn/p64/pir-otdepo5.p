/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-1997 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: otdepo5.
      Comment: ����樮��� ��ୠ� ��楢��� ���  ����
   Parameters:
         Uses:
      Used by:
      Created: 02/04/01 Lera
     Modified: 20/01/03 Gunk �஡�� ������⢠
     Modified: 18.07.2006 OZMI (0054745) � ���������� for each ��⥭ 䨫���.
*/

{pick-val.i}
{globals.i}
{sh-defs.i}
DEFINE INPUT PARAMETER iParmStr AS CHARACTER NO-UNDO.

def var prn-tit   as char format "x(50)"  NO-UNDO.
def var prn-tit1  as char format "x(50)"  NO-UNDO.
def var nom-oper  as char init " " 	  NO-UNDO.
def var num       as int init 1 	  NO-UNDO.
def var vContCode as char 		  NO-UNDO.
def buffer xop-entry for op-entry .
def buffer buf-acct  for acct.

DEFINE VARIABLE mFmt AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cFileName AS CHARACTER NO-UNDO.

{pir-otdepo.i}
{getdaydir.i}
cFileName = getDayDir('/home2/bis/quit41d/imp-exp/Arhiv',INTEGER(iParmStr)) + '/otdepo5.txt'.


form
      num               column-label "�����"
      nom-oper          column-label "��� ��������" format "x(15)"
      op.op-kind        column-label "� ��������!�� �������" format "x(8)"
      op.doc-date       column-label "���� ������!���������"
      op.doc-num        column-label "�����!���������"
      op.op-date        column-label "����!����������"
      op.doc-num        column-label "����� ������ 0!������.����."
      op.op-date        column-label "���� ������ 0!������.����."
      acct.acct         column-label "�����������������!����    "format "x(20)"
      xop-entry.qty     column-label "�����"  format "->>>>>>>>>>>>>>9.9999999"
      op-entry.qty      column-label "������" format "->>>>>>>>>>>>>>9.9999999"
   with  frame prn width 180.

ASSIGN
   mFmt                              = GetFmtQty("", "acct", 24, 7)
   xop-entry.qty:FORMAT IN FRAME prn = mFmt
   op-entry.qty:FORMAT IN FRAME prn  = mFmt
.

{setdest.i &cols=130 &filename=cFileName}
for each acct where (filt or acct.acct eq cacct) and
                     can-do(sec-cod1,acct.currency) and
                     acct.bal-acct ge 98000 and
                     acct.bal-acct lt 99000 and
                     acct.acct-cat eq "d"   AND 
                     acct.filial-id EQ shFilial no-lock
         break by acct.currency by acct.bal-acct by acct.acct :

   find first sec-code where sec-code.sec-code eq acct.currency no-lock no-error .
   prn-tit = "����樮��� ��ୠ� �� ��楢��� ���� ���� " +  string(acct.acct,"x(20)")
           + " c " + string(beg-date) + " �� " + string(end-date) .
   prn-tit1 = "���.����� " + IF      AVAIL sec-code
                                 AND sec-code.reg-num NE ?
                             THEN sec-code.reg-num 
                             ELSE "".
   pause 0 .
   for each op-entry where (op-entry.acct-db eq acct.acct and
                            op-entry.currency eq acct.currency and
                            op-entry.op-date ge beg-date and
                            op-entry.op-date le end-date )        or
                           (op-entry.acct-cr eq acct.acct and
                            op-entry.currency eq acct.currency and
                            op-entry.op-date ge beg-date and
                            op-entry.op-date le end-date ) no-lock,
            first op of op-entry no-lock break by op-entry.op-date with frame prn:

      find first code where code.class eq "�����" and
                            code.code eq op-entry.op-cod no-lock no-error.
      if first(op-entry.op-date) then run acct-qty IN h_base (acct.acct,acct.currency,beg-date,end-date,"�").

      put unformatted prn-tit at 5 skip .
      put unformatted prn-tit1 at 5 skip .
      put unformatted "�室�騩 ���⮪" at 5  skip .
      if sh-in-qty ge 0 then
         put unformatted string(sh-in-qty, mFmt) at 5  skip .
      else
         put unformatted string( - sh-in-qty, mFmt) at 5  skip .

      find first buf-acct where buf-acct.acct eq (if op-entry.acct-db eq acct.acct then op-entry.acct-cr
                                                                                  else op-entry.acct-db) no-lock no-error.
      if acct.side eq "�" and buf-acct.side eq "�" then nom-oper = "��ॢ��".
      else if acct.side eq "�" and buf-acct.side eq "�" then nom-oper = "��६�饭��".
      else if op-entry.acct-db eq acct.acct then if acct.side eq "�" then nom-oper = "��室". else nom-oper = "���室".
      else if op-entry.acct-cr eq acct.acct then if acct.side eq "�" then nom-oper = "��室". else nom-oper = "���室".

      display num
              nom-oper
              op.op-kind
              op.doc-date
              op.doc-num
              op.op-date
              op.doc-num
              op.op-date
              op-entry.acct-cr when op-entry.acct-db eq acct.acct @ acct.acct
              op-entry.acct-db when op-entry.acct-cr eq acct.acct @ acct.acct
              op-entry.qty     when op-entry.acct-db eq acct.acct @ xop-entry.qty
              op-entry.qty     when op-entry.acct-cr eq acct.acct @ op-entry.qty
      .
      sh-in-qty = sh-in-qty + if op-entry.acct-db eq acct.acct then op-entry.qty else - op-entry.qty.
      sh-qty    = sh-in-qty.

      IF op-entry.qty NE 0 THEN
      DO:
         IF op-entry.acct-db EQ acct.acct THEN
            DISP "" @ op-entry.qty.
         ELSE
            DISP "" @ xop-entry.qty.
      END.

     down.
     underline num
               nom-oper
               op.op-kind
               op.doc-date
               op.doc-num
               op.op-date
               op.doc-num
               op.op-date
               acct.acct
               xop-entry.qty
               op-entry.qty.
     down .
     put  unformatted "" skip(1) "���������� ��������: " at 1 trim(op.details) format "x(100)"  skip .
     put  unformatted "" skip(1) "����������(�): " at 1 .

     if acct.side eq "�" then do:
        vContCode = GetXAttrValue("acct",
                                  acct.acct + "," + acct.currency,
                                  "����").
        if vContCode ne "" then do:
           find first loan where loan.cont-code eq vContCode and
                                 loan.contract eq "����" + acct.side no-lock no-error.
           if avail loan then do:
              case loan.cust-cat:
                 when "�" then do:
                    find first cust-corp of loan no-lock no-error.
                    if avail cust-corp then
                       put  unformatted cust-corp.cust-stat + " " + cust-corp.name-corp format "x(50)" at 16  skip .
                 end.
                 when "�" then do:
                    find first person where person.person-id eq loan.cust-id no-lock no-error.
                    if avail person then
                       put  unformatted person.name-last + " " + person.first-names format "x(50)" at 16  skip .
                 end.
                 when "�" then do:
                    find first banks where banks.bank-id eq loan.cust-id no-lock no-error.
                    if avail banks then
                       put  unformatted banks.name format "x(50)" at 16  skip .
                 end.
              end case.
           end.
        end.
     end.
     if op-entry.acct-db ne acct.acct then do:
        find first buf-acct where buf-acct.acct eq op-entry.acct-db and
                                  buf-acct.acct-cat eq "d" no-lock no-error.
        if avail buf-acct and buf-acct.side eq "�" then do:
           vContCode = GetXAttrValue("acct",
                                     buf-acct.acct + "," + buf-acct.currency,
                                     "����").
           if vContCode ne "" then do:
              find first loan where loan.cont-code eq vContCode and
                                    loan.contract eq "����" + buf-acct.side no-lock no-error.
              if avail loan then do:
                 case loan.cust-cat:
                    when "�" then do:
                       find first cust-corp of loan no-lock no-error.
                       if avail cust-corp then
                          put unformatted cust-corp.cust-stat + " " + cust-corp.name-corp format "x(50)" at 16  skip .
                    end.
                    when "�" then do:
                       find first person where person.person-id eq loan.cust-id no-lock no-error.
                       if avail person then
                          put  unformatted person.name-last + " " + person.first-names format "x(50)" at 16  skip .
                    end.
                    when "�" then do:
                       find first banks where banks.bank-id eq loan.cust-id no-lock no-error.
                       if avail banks then put  unformatted banks.name format "x(50)" at 16  skip .
                    end.
                 end case.
              end.
           end.
        end.
     end.
     if last(op-entry.op-date) then do:
        put unformatted " " skip  "�⮣� "   at 5
           if sh-qdb ne 0 then string(sh-qdb, mFmt) else " " at 101
           if sh-qcr ne 0 then string(sh-qcr, mFmt) else " " at 126 skip .
     end.
     put  unformatted "" skip(1) "��室�騩 ���⮪" at 5  skip .
     if sh-qty lt 0 then
        put unformatted  string( - sh-qty, mFmt) at 5 skip.
     else
        put unformatted  string( sh-qty, mFmt) at 5 skip.
     put " " skip(1) .
   end.
end.
pause 0 .
