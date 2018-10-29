/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: ��� �� "�P��������������"
     Filename: pir-dov-check.p
      Comment: ��������� � �ப��� ����७���⥩ �� �����⠬. 
   Parameters: 
         Uses: Globals.I SetDest.I Signatur.I Preview.I
      Used by: -
      Created: 28/04/2009 Templar
     Modified: 01/02/12 SStepanov ��������� � ���� ��⮢ 30109* �� ������ ����⠭���� �.�.
*/

{globals.i}

DEFINE VAR client_id as int  no-undo.
DEFINE VAR client_name as char  no-undo.
DEFINE VAR corp_id as int  no-undo.
DEFINE VAR corp_name as char  no-undo.
DEFINE VAR symb as char no-undo.
DEFINE VAR schet as char no-undo.

DEFINE TEMP-TABLE tt-custcorp
	FIELD name AS CHAR 
	FIELD typedov AS CHAR 
	FIELD schet AS CHAR
	FIELD date1 AS DATE
	FIELD date2 AS DATE
	INDEX main date2 ASCENDING name ASCENDING.



DEFINE TEMP-TABLE tt-person
	FIELD name AS CHAR 
	FIELD typedov AS CHAR 
	FIELD schet AS CHAR
	FIELD date1 AS DATE
	FIELD date2 AS DATE
	INDEX main date2 ASCENDING name ASCENDING.



/*--------------------------------------- Main ------------------------------------------------------------------*/



{getdates.i}

symb = "-".


{setdest.i &cols=80 }

PUT UNFORMATTED '          ���� �� �ப�� ����⢨� ����७���⥩       ' SKIP(1) .


/*------------------------------------------------------------------------------------------------------*/




									
FOR EACH cust-corp :
DO:	
	corp_id = cust-corp.cust-id .

	
	/**   �������� ࠡ���   **/
	put screen col 77 row 24 color bright-blink-normal "(" + symb + ")" .
   	   CASE symb :
	          WHEN "\\"  THEN symb = "|".
	          WHEN "|"   THEN symb = "/".
	          WHEN "/"   THEN symb = "-".
	          WHEN "-"   THEN symb = "\\".
	      END CASE.

	FOR EACH cust-role WHERE cust-role.file-name EQ "cust-corp" AND cust-role.surrogate EQ STRING(corp_id) 
	AND CAN-DO ("�ࠢ�_���_������,�ࠢ�_��ࢮ�_������",cust-role.class-code)
	AND cust-role.close-date GE beg-date AND cust-role.close-date LE end-date :		

		FIND FIRST acct WHERE 	acct.cust-cat = '�' AND acct.cust-id = corp_id AND 
					(acct.close-date EQ ? OR  acct.close-date GE beg-date ) AND
					CAN-DO ('�����,�����',acct.contract) NO-LOCK NO-ERROR.
	
			IF AVAIL acct THEN DO:
				CREATE tt-custcorp .
				tt-custcorp.name = cust-corp.name-corp .
				tt-custcorp.schet = acct.acct .
				tt-custcorp.typedov = cust-role.class-code .
				tt-custcorp.date1 = cust-role.open-date .
				tt-custcorp.date2 = cust-role.close-date .
			END.	


		END.
	END.
END.


FOR EACH banks :
  DO:	
	client_id = banks.bank-id.

	/**   �������� ࠡ���   **/
	put screen col 77 row 24 color bright-blink-normal "(" + symb + ")" .
   	   CASE symb :
	          WHEN "\\"  THEN symb = "|".
	          WHEN "|"   THEN symb = "/".
	          WHEN "/"   THEN symb = "-".
	          WHEN "-"   THEN symb = "\\".
	      END CASE.

	FOR EACH cust-role WHERE cust-role.file-name EQ "banks" 
				AND cust-role.surrogate EQ STRING(client_id) 
				AND CAN-DO ("�ࠢ�_���_������,�ࠢ�_��ࢮ�_������",cust-role.class-code)  
				AND cust-role.close-date GE beg-date
				AND cust-role.close-date LE end-date :

	FIND FIRST acct WHERE 	acct.cust-cat = '�'
			    AND acct.cust-id = client_id
			    AND (acct.close-date EQ ? OR  acct.close-date GE beg-date )
			    AND CAN-DO ('���',acct.contract)
			NO-LOCK NO-ERROR.

		IF AVAIL acct THEN DO:
				CREATE tt-custcorp.
				tt-custcorp.name    = banks.name.
				tt-custcorp.schet   = acct.acct .
				tt-custcorp.typedov = cust-role.class-code .
				tt-custcorp.date1   = cust-role.open-date .
				tt-custcorp.date2   = cust-role.close-date .
			END.	
		

    END.
  END.
END.


PUT UNFORMATTED '                I. �ਤ��᪨� ���        ' SKIP(1) .
PUT UNFORMATTED "���������������������������������������������������������������������������������������������������������͸" SKIP
                "�             ������              �        ���          �   ��� ����७����   �    ���    �    ���    �" SKIP
                "�                                 �                      �                      �   ��砫�   � ����砭��  �" SKIP
                "���������������������������������������������������������������������������������������������������������͵" SKIP.

FOR EACH tt-custcorp:

	PUT UNFORMATTED '�' tt-custcorp.name FORMAT 'X(33)' '� ' tt-custcorp.schet FORMAT 'X(20)'  ' � ' tt-custcorp.typedov FORMAT 'X(20)' ' � '  tt-custcorp.date1 FORMAT '99/99/9999'   ' � '  tt-custcorp.date2 FORMAT '99/99/9999' ' �'   SKIP.

END.

PUT UNFORMATTED "�����������������������������������������������������������������������������������������������������������" SKIP(2).                                                     


/*------------------------------------------------------------------------------------------------------*/


FOR EACH person :
  DO:	
	client_id = person.person-id.

	/**   �������� ࠡ���   **/
	put screen col 77 row 24 color bright-blink-normal "(" + symb + ")" .
   	   CASE symb :
	          WHEN "\\"  THEN symb = "|".
	          WHEN "|"   THEN symb = "/".
	          WHEN "/"   THEN symb = "-".
	          WHEN "-"   THEN symb = "\\".
	      END CASE.

	FOR EACH cust-role WHERE cust-role.file-name EQ "person" 
				AND cust-role.surrogate EQ STRING(client_id) 
				AND CAN-DO ("�ࠢ�_���_������,�ࠢ�_��ࢮ�_������",cust-role.class-code)  
				AND cust-role.close-date GE beg-date AND cust-role.close-date LE end-date :

	FIND FIRST acct WHERE 	acct.cust-cat = '�' AND acct.cust-id = client_id AND 
				(acct.close-date EQ ? OR  acct.close-date GE beg-date ) AND
				CAN-DO ('�����,�����',acct.contract) NO-LOCK NO-ERROR.

		IF AVAIL acct THEN DO:
				CREATE tt-person .
				tt-person.name = person.name-last + ' ' + person.first-names.
				tt-person.schet = acct.acct .
				tt-person.typedov = cust-role.class-code .
				tt-person.date1 = cust-role.open-date .
				tt-person.date2 = cust-role.close-date .
			END.	
		

  END.
END.
END.


PUT UNFORMATTED '                II. �����᪨� ���        ' SKIP(1) .

PUT UNFORMATTED "���������������������������������������������������������������������������������������������������������͸" SKIP
                "�             ������              �         ���         �   ��� ����७����   �    ���    �    ���    �" SKIP
                "�                                 �                      �                      �   ��砫�   � ����砭��  �" SKIP
                "���������������������������������������������������������������������������������������������������������͵" SKIP.
 


FOR EACH tt-person:
	PUT UNFORMATTED '�' tt-person.name FORMAT 'X(33)' '� ' tt-person.schet FORMAT 'X(20)'  ' � ' tt-person.typedov FORMAT 'X(20)' ' � '  tt-person.date1 FORMAT '99/99/9999'   ' � '  tt-person.date2 FORMAT '99/99/9999' ' �'   SKIP.
END.



PUT UNFORMATTED "�����������������������������������������������������������������������������������������������������������" SKIP(2).                                                     


/*------------------------------------------------------------------------------------------------------*/

{signatur.i}
{preview.i}



