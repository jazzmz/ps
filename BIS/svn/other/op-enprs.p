{pirsavelog.p}

/*
                ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright:  (C) 1992-1997 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename:  op-enpr2.p
      Comment:  ����� �������� �஢����

         Uses:  -
      Used by:  op-en(s1.p,op-en(s2.p
      Created:  05/05/1996 eagle
     Modified:  06/05/1996 serge 䨫���
     Modified:  12/08/1996 serge ������, ����.ᨬ���
     Modified:  27/08/1996 serge ��ࠢ����� break'��
     Modified:  20/02/1997 serge ���������� ���� � ��
     Modified:  16/04/1997 serge ���஢�� �� ���, ���������� �����
     Modified:  05/05/1997 serge ��ࠢ����� �᫮��� �롮ન - f-op-status & f-user-id
     Modified:  09/09/1997 Dima  ���� �ଠ�� ��⮢
        Last change:  SG   27 Nov 97    4:22 pm
*/

{op-entmp.i}

def var adb as char format 'x(25)' no-undo.
def var acr as char format 'x(25)' no-undo.
def var kodst as char format 'x(6)' no-undo.
def var rash  as char format 'x(30)' no-undo.
def var j as int initial 0 no-undo.
def var lastofcur as logical no-undo.
def var lastofuserid as logical no-undo.
def var lastuserid as logical no-undo.
def buffer xop-entry for op-entry.

{setdest.i &cols=184}

/***************************************************************************/
function GetCBDocType1 returns char /* �����頥� ��-�� ��� ���㬥��     */
         (input in-doc-type as char): /* doc-type.doc-type */
  find first doc-type where doc-type.doc-type = in-doc-type no-lock no-error.
  return if avail doc-type then doc-type.digital else in-doc-type.
end function.
/***************************************************************************/

mainc:
for each tmprecid no-lock,
   first op-entry where recid(op-entry) = tmprecid.id no-lock,
   op of op-entry no-lock
   break by op-entry.op-date
         by op-entry.currency
         by op-entry.amt-rub
   on error undo, leave:

   {on-esc leave}

   {op-enprt.i}

   form header
              caps(name-bank) form "x(60)" skip
              "����� ����������"
              (if in-op-date-beg = in-op-date-end then
                "�� " + (if in-op-date-end = ? then "?" else string(in-op-date-end))
              else
                  "� "   + (if in-op-date-beg = ? then "?" else string(in-op-date-beg))
                + " �� " + (if in-op-date-end = ? then "?" else string(in-op-date-end))
              )
              format "x(45)"
              page-number form "����zz9" to 184 skip(2).

   assign
     lastofuserid = last-of(op-entry.op-date)
     lastofcur    = last-of(op-entry.currency)
     lastuserid   = last(op-entry.op-date).

   if lastofuserid then do:
     {chkpage if lastuserid then 12
              else if lastofcur then 7 else 4}
   end.

 kodst = GetXAttrValueEx("op-entry",STRING(op-entry.op) + "," + STRING(op-entry.op-entry),"�����ਡ����","").
 if kodst ne "" then do:
 find first code WHERE code.class eq "�ਡ����" and
                       code.code eq kodst.
 if avail code then rash = code.name.
 end.
 else rash = "".
   find first op-bank of op no-lock no-error.

  if adb <> ? or acr <> ? then do:

   display
  /*  j form ">>>9" label "N �/�"*/
    op.op-date
    op.op-status format "x(4)"
    GetCBDocType1(op.doc-type) @ op.doc-type
    op.doc-num
    adb column-label '�����'
    acr column-label '������'
/*    op-bank.bank-code when avail op-bank
    op.ben-acct
    op-entry.symbol
    op-entry.prev-year*/
    op-entry.currency
    op-entry.amt-cur when op-entry.amt-cur <> 0
    op-entry.amt-rub
/*    op-entry.user-id*/
    kodst column-label "���"
    rash column-label "�����������"
    with no-box width 255.

  accum
    op-entry.amt-cur (sub-total by op-entry.currency)
    op-entry.amt-rub (total by op-entry.op-date by op-entry.currency)
    op-entry.amt-rub (count by op-entry.op-date by op-entry.currency).
 end.

  if lastofcur and not (op-entry.currency = "" and lastofuserid) then do:
     down.
     underline op.doc-num op-entry.currency op-entry.amt-cur op-entry.amt-rub.
     display
        (accum count by op-entry.currency op-entry.amt-rub) format ">>>>9"
           @ op.doc-num
        op-entry.currency
        (accum sub-total by op-entry.currency op-entry.amt-cur) @ op-entry.amt-cur
        (accum total by op-entry.currency op-entry.amt-rub) @ op-entry.amt-rub.
     down 1.
  end.

  if lastofuserid then do:
     j = j + 1.
     if op-entry.currency <> "" then down.
     underline op.doc-num op-entry.amt-rub.
     display
        (accum count by op-entry.op-date op-entry.amt-rub) format ">>>>9"
           @ op.doc-num
        (accum total by op-entry.op-date op-entry.amt-rub) @ op-entry.amt-rub.
     down 2.
  end.

  if lastuserid and j > 1 then do:
     underline op.doc-num op-entry.amt-rub.
     display
        (accum count op-entry.amt-rub) format ">>>>9" @ op.doc-num
        (accum total op-entry.amt-rub) @ op-entry.amt-rub
     .
  end.

end.

{signatur.i &user-only=yes}
{preview.i}
