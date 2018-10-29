/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: ��� �� "�P��������������"
     Filename: pir-migr.p
      Comment: ���� �� ��⥪訬 �ப�� ��� � ����樮���� ����
   Parameters: 
         Uses: Globals.I Signatur.i preview.i Tmprecid.def
      Used by: -
      Created: 08/10/2008 Templar
     Modified:
*/

/** �������� ��।������ */
{globals.i}

DEFINE VAR i	as int  no-undo.
DEFINE VAR client_id	as int  no-undo.

DEFINE VAR vAcct	as char  no-undo.
DEFINE VAR vName	as char  no-undo.
DEFINE VAR vVisa	as char  no-undo.
DEFINE VAR vOkonpreb	as char  no-undo.
DEFINE VAR vOkonprav	as char  no-undo.


/*--------------------------------------- Main ------------------------------------------------------------------*/

DEFINE INPUT PARAM tekdate AS DATE NO-UNDO.
MESSAGE "������ ���� �஢�ન " UPDATE tekdate.

{setdest.i}
PUT UNFORMATTED '����� �� �����, ������������ ������ � �������� ������' SKIP(1) .

PUT UNFORMATTED "���������������������������������������������������������������������������������������������������������������������������������͸" SKIP
                "�     ������ ���     �      ������������ ������       �     �����: ᢥ����� � �ꥧ���� ����       � ����.���� � ����.���� �" SKIP
                "�                        �                                 �                                            ������. �ࠢ�������.�ॡ-�" SKIP
                "���������������������������������������������������������������������������������������������������������������������������������͵" SKIP.


FOR EACH person WHERE person.country-id NE "rus":

		Vname = person.name-last + ' ' + person.first-names.
		vAcct = "".
		client_id = person.person-id.

		FOR EACH signs WHERE  signs.file-name = "person"  AND  signs.surrogate = STRING(client_id)  :
			IF signs.code EQ "�����ࠢ�ॡ��" Then Vokonpreb = signs.code-value .
			IF signs.code EQ "�����ॡ뢏�" Then Vokonprav = signs.code-value .
			IF signs.code EQ "Visa" Then Vvisa = signs.xattr-value .
		END.

		FIND FIRST acct WHERE  acct.cust-id = client_id AND acct.cust-cat EQ "�"  AND  acct.contract EQ "�����" no-lock no-error.     
			if AVAIL acct THEN 
				DO:	
					vAcct = acct.acct .
				END.
		
	IF DATE(vokonpreb) < tekdate AND Vacct <> ""  THEN	
	PUT UNFORMATTED "� " Vacct FORMAT "X(22)"  " � " Vname FORMAT "x(31)" " � " Vvisa FORMAT "x(42)" " � " Vokonprav " � " Vokonpreb " �"  SKIP.

END.

PUT UNFORMATTED "�����������������������������������������������������������������������������������������������������������������������������������" SKIP.

{signatur.i}
{preview.i}
