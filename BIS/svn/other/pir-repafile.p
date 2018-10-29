{pirsavelog.p}

/* ========================================================================= */
/** 
    Copyright: ��� �� "�P��������������", ��ࠢ����� ��⮬�⨧�樨 (C) 2011
     Filename: pir-repafile.p
      Comment: ���� �� �ᯮ��� ��������� Application 
		(ᠬ� ����祭�� �ନ��� �࠭����� e-ucsia)
   Parameters: 
       Launch: �� - ������ - �������� ����� 
         Uses:
      Created: ��⮢ �.�., 22.04.2011
	Basis: ��
     Modified: <��> <����� [F7]> (������� ��� ��� ���᪠ <㭨�����_���>) 
               <���ᠭ�� ���������>                                           
*/
/* ========================================================================= */



{globals.i}                                                                      
{getdate.i}

DEF VAR i AS int INIT 0 NO-UNDO.

DEF BUFFER mop-int FOR op-int.
DEF BUFFER mcard   FOR loan.
DEF BUFFER mPackObject FOR PackObject.
DEF BUFFER mPacket     FOR Packet.    
DEF BUFFER mSeance     FOR Seance.
{get-bankname.i}
{setdest.i}

PUT UNFORM SKIP(2).
PUT UNFORM FILL(" ",10)  "���������� �1"  SKIP.
PUT UNFORM FILL(" ",10)  cBankName SKIP(2).
PUT UNFORM FILL(" ",60)   string(TODAY,"99/99/9999") " " string(TIME,"HH:MM:SS") SKIP(1).
PUT UNFORM FILL(" ",40)  "����� ������������ ������ �� " string(end-date,"99/99/99") " �. " SKIP(2).

PUT UNFORM "| N ��| "
	"   ����� �����   | "
	"� | "
	"                   ���������                  | "
	"          �������� �� ��         | "
	"      � �����     |"
SKIP(1).


FOR EACH mop-int WHERE  mop-int.file-name = 'loan'
  AND mop-int.surrogate begins 'card,'
  AND can-do('��������,���������,���⏥ॢ�,���∧�',mop-int.class-code)
  AND can-do('���,���,���',mop-int.op-int-status) 
  AND mop-int.create-date = end-date
  NO-LOCK,
FIRST mcard
WHERE mcard.contract = 'card'
  AND mcard.cont-code = entry(2,mop-int.surrogate)
  NO-LOCK,
FIRST mPackObject
WHERE mPackObject.file-name EQ 'op-int'
  AND mPackObject.Surrogate EQ string(mop-int.op-int-id)
  NO-LOCK,
FIRST mPacket
WHERE mPacket.PacketID EQ mPackObject.PacketID
  NO-LOCK,
FIRST mSeance
WHERE mSeance.SeanceID EQ mPacket.SeanceID
NO-LOCK:

  i = i + 1 .

  FIND FIRST person WHERE person.person-id = mcard.cust-id NO-LOCK NO-ERROR.
  FIND FIRST FileExch WHERE FileExch.SeanceID = mSeance.SeanceID NO-LOCK NO-ERROR.

  PUT UNFORM	"| " string(i,"999") " | " 
		string(mcard.doc-num,"X(16)")   " | " 
		(if mcard.loan-work = yes then "+"  else " ")  " | "
		string(person.name-last + " " + person.first-name,"X(45)") " | "
		string(mop-int.op-int-status,"X(4)") " " mop-int.create-date " " string(mop-int.create-time,"HH:MM") " " string(mop-int.op-int-code,"X(12)") " | " 
		string(FileExch.Name,"X(17)") " | "
	/* mop-int.op-int-id */
  SKIP.

END.


PUT UNFORM SKIP(2).
PUT UNFORM " �����: ������⢮ �� - " i SKIP(2).


  /* �ᯮ���⥫� */

FIND FIRST code WHERE code.class EQ "PirU11Podpisi"
  AND code.parent EQ "PirU11Podpisi"
  AND code.code = userid("bisquit") NO-LOCK NO-ERROR.

  PUT UNFORM " " code.name SKIP(2).


{preview.i}