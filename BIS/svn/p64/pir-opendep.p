/*
                ������᪠� ��⥣��஢����� ���⥬� �������
    Copyright:  (C) 1992-1996 ��� "������᪨� ����ଠ樮���� ���⥬�"
     Filename:  opendep.p
      Comment:  depo ����� �������� � �������� �� ��ਮ� � �� ����
         Uses:  opendep.i
      Used by:  -
      Created:  05/04/1997 nata
     Modified:
*/
{globals.i}
DEFINE INPUT PARAMETER iParmStr AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFileName AS CHARACTER NO-UNDO.

def new global shared var pick-value as char no-undo.

def var name like bal-acct.name no-undo.
def var type-depo as char no-undo.
def var type-save as char no-undo.
def var tit1 as char format "x(40)" no-undo.
def var i as int no-undo.
def var oneday as logical no-undo.
def var rid1 as recid NO-UNDO.
def var dat1 as date NO-UNDO.
{chkacces.i}

beg-date=TODAY - INTEGER(iParmStr).
end-date=TODAY - INTEGER(iParmStr).

{getdaydir.i}

cFileName = getDayDir('/home2/bis/quit41d/imp-exp/Arhiv',INTEGER(iParmStr)) + '/opendep1.txt'.

oneday = beg-date eq end-date.
{setdest.i &cols=150 &filename=cFileName}
if end-date eq ? then end-date = 01/01/3000 .

if oneday then tit1= string(beg-date) .
          else tit1="� " + string(beg-date) + " �� " + string(end-date).

{opendep1.i &pr2="��" &nf=2 &tit=tit1 }
page.
