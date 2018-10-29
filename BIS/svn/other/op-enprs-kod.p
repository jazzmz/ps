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
def var lastkod as logical no-undo.
def buffer xop-entry for op-entry.

DEFINE TEMP-TABLE ttSpod
   FIELD op-date LIKE op.op-date
   FIELD op-status LIKE op.op-status
   FIELD doc-type as CHAR
   FIELD doc-num LIKE op.doc-num
   FIELD adb AS char
   FIELD acr as char
   field ben-acct like op.ben-acct
   field symbol like op-entry.symbol
   field prev-year like op-entry.prev-year
   field currency like op-entry.currency
   field amt-cur like op-entry.amt-cur
   field amt-rub like op-entry.amt-rub
   FIELD kodst as int
   field rash as char
   INDEX spod-cur-idx op-date.


{setdest.i &cols=184}

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
              page-number form "����zz9" /* to 184 skip(2) */.

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
     
     create ttSpod.
     assign
     ttSpod.op-date		= op.op-date
     ttSpod.op-status	= op.op-status
     ttSpod.doc-type	= op.doc-type
     ttSpod.doc-num		= op.doc-num
     ttSpod.adb			= adb
     ttSpod.acr			= acr
     ttSpod.ben-acct	= op.ben-acct
     ttSpod.symbol		= op-entry.symbol
     ttSpod.prev-year	= op-entry.prev-year
     ttSpod.currency	= op-entry.currency
     ttSpod.amt-cur		= op-entry.amt-cur
     ttSpod.amt-rub		= op-entry.amt-rub 
     ttSpod.kodst		= int(kodst)
     ttSpod.rash		= rash
     .

 end. 
end.

for each ttSpod break by ttSpod.kodst:

assign
	lastkod = last-of(ttSpod.kodst).
accum
	ttSpod.amt-cur (sub-total by ttSpod.kodst)
	ttSpod.amt-rub (sub-total by ttSpod.kodst).

display
     ttSpod.op-date 
     ttSpod.op-status		FORMAT "X(1)"
     ttSpod.doc-type		FORMAT "X(3)"		COLUMN-LABEL '���'
     ttSpod.doc-num
     ttSpod.adb				FORMAT "X(25)"		COLUMN-LABEL '�����'
     ttSpod.acr				FORMAT "X(25)"		COLUMN-LABEL '������'
     ttSpod.ben-acct
     ttSpod.symbol
     ttSpod.prev-year
     ttSpod.currency
     ttSpod.amt-cur								COLUMN-LABEL '����� ���'
     ttSpod.amt-rub
     string(ttSpod.kodst)						COLUMN-LABEL '���'
     ttSpod.rash			FORMAT "X(50)"		COLUMN-LABEL '�����������'
with no-box width 255.


if lastkod then do:
	down.
	underline 	ttSpod.op-date 
				ttSpod.op-status 
				ttSpod.doc-type 
				ttSpod.doc-num 
				ttSpod.adb 
				ttSpod.acr 
				ttSpod.ben-acct
				ttSpod.symbol
				ttSpod.prev-year
				ttSpod.currency 
				ttSpod.amt-cur 
				ttSpod.amt-rub
				ttSpod.rash.
	display
		(accum sub-total by ttSpod.kodst ttSpod.amt-cur) @ ttSpod.amt-cur
		(accum sub-total by ttSpod.kodst ttSpod.amt-rub) @ ttSpod.amt-rub.
	down 1.
end. 
end. 
{signatur.i &user-only=yes}
{preview.i}
