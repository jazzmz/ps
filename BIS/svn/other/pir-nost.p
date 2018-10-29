/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: ��� �� "�P��������������"
     Filename: pir-nost.p
      Comment: ��������� ������ ��⮢ � ������� ��᭨����� ���⪮�
   Parameters: 
         Uses: Globals.I SetDest.I Signatur.I Preview.I
      Used by: -
      Created: 22/09/2008 Templar
     Modified:
*/

{globals.i}

DEFINE VAR i	as int  no-undo.
DEFINE VAR minost	as int  no-undo.
DEFINE VAR k		as date  no-undo.


/*--------------------------------------- Main ------------------------------------------------------------------*/

DEFINE INPUT PARAM nost AS INT NO-UNDO.
MESSAGE "������ ��᭨����� ���⮪" UPDATE nost.

{setdest.i}
PUT UNFORMATTED '������ ��������� ������ � ����������� �������� �� ����� ' nost  ' ���' SKIP(1) 
'�� 2008 ���' SKIP(1) 'C���                              �����. �������' SKIP(1) FILL('-',80) FORM 'X(78)' SKIP(1) .

FOR EACH acct WHERE acct.contract EQ "�����" :
	minost=99999999.	/* ��������� ���⮪ �� ��� �� ���*/


		FOR EACH acct-pos WHERE acct-pos.acct = acct.acct :
			IF YEAR(acct-pos.since) = 2008 AND -(acct-pos.balance) < minost  THEN minost = - acct-pos.balance .			
		END.

	IF  minost > nost AND minost <> 99999999  THEN /* ���⮪ �� ��� �� �� �६� ����� ��᭨�. ���⪠ */
	PUT UNFORMATTED  acct.acct '            '  minost FORMAT "->>>,>>>,>>9.99" SKIP.
 	

END.

{signatur.i}
{preview.i}
