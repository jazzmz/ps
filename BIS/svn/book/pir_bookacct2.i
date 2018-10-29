/*
   ��ନ஢���� ��������.
   ��ࠬ����:

   Modified: 30/10/2001 NIK ��ࠢ������� ����, �᪫�祭�� find signs...
                            ����ୠ� 8 �������
     Modified: 27.01.2004 kraw (0022373)
     Modified: 04.04.2005 kraw (0042443) ��।��� ��������� �����⬠ �ନ஢���� ����� � ���� �������
     Modified: 19.08.2005 anisimov  - �������� ��� �ॡ������ �⤥�� �� ������ ��⮢
*/

DEF VAR oSysClass AS TSysClass    NO-UNDO.
DEF VAR cName     AS CHAR         NO-UNDO.
DEF VAR cDetails  AS CHAR INIT "" NO-UNDO.
DEF VAR oClient   AS TClient      NO-UNDO.

DEF VAR oTable    AS TTable2      NO-UNDO.

oSysClass = new TSysClass().

oTable = NEW TTable2().
oTable:setDraw(NEW TCSVDraw("|")).

/*
oTable:colsWidthList = "10,10,10,20,35".
*/
/*
oTable:colsHeaderList = "����� NN,��� ������ ���,����� � ��� ������� �� ����⨨ ���,
������������ �����⮢ ���,����� ��楢��� ���,�����祭�� ���,
���冷� � ��ਮ��筮��� �뤠� �믨᮪,��� ᮮ�饭�� ������� �࣠��� �� ����⨨ ���,
��� ������� ���,��� ᮮ�饭�� � �����⨨,�ਬ�砭��".
*/

oTable:addRow().
oTable:addCell("����� NN").
oTable:addCell("��� ������ ���").
oTable:addCell("��� � ����� ������� �� ����⨨ ���").
oTable:addCell("������������ ������").
oTable:addCell("����� ��楢��� ���").
oTable:addCell("��� ���").
oTable:addCell("���冷� � ��ਮ��筮��� �뤠� �믨᮪").
oTable:addCell("��� ᮮ�饭�� �������� �࣠��� �� ����⨨ ���").
oTable:addCell("��� ������� ���").
oTable:addCell("��� ᮮ�饭�� �������� �࣠��� � �����⨨ ���").
oTable:addCell("�ਬ�砭��").
oTable:addCell("�����ᮢ� ���").


oTable:addRow().
oTable:addCell("1").
oTable:addCell("2").
oTable:addCell("3").
oTable:addCell("4").
oTable:addCell("5").
oTable:addCell("6").
oTable:addCell("7").
oTable:addCell("8").
oTable:addCell("9").
oTable:addCell("10").
oTable:addCell("11").
oTable:addCell("12").

ppnum = 0.

FOR EACH bal-acct WHERE CAN-DO(mAcct, string(bal-acct.bal-acct)) NO-LOCK,
   EACH acct OF bal-acct WHERE acct.cust-cat BEGINS mSewMode
                           AND open-date LE end-date
                           AND (close-date GT end-date OR close-date EQ ?)
                           AND acct.user-id BEGINS access
                           AND acct.acct-cat EQ "b"
                           AND CAN-DO(list-id,acct.user-id)
                           AND acct.cust-cat BEGINS mSewMode  /* ��,䨧,����,�� */
        NO-LOCK
   BREAK BY bal-acct.bal-acct 
         BY acct.currency 
         BY SUBSTRING(acct.acct,10,11) WITH FRAME fr{1}:

   mCustCat2 = GetXAttrValueEx("bal-acct",STRING(acct.bal-acct),"����","����७���").
   ppnum = ppnum + 1.

/*************************
 * ���������� ���� ����� *
 **************************/
col5 = getXAttrValue("acct",acct.acct + "," + acct.currency,"�����").

    /*********** ����� ������� ������������ ����� ������� ****************/
    /************
     * �஢��塞:
     * �᫨ ��� �ਭ������� ��᪥
     * !3*,!4*,*, 
     * � ������������ �����, ������
     * ����� � ��� �ਬ�砭��, � ������������
     * ������ ������ ���� �����.
     * �� ������� � ��୮ᮢ�� �. �. � �㪮��� �.
     * � ��砫� ��५� 2011.
     ************/
       IF CAN-DO("!3*,!4*,*",acct.acct) OR CAN-DO("�����*",col5) THEN DO:
	      ASSIGN
	        name[1] = ""
                cDetails = acct.details
              .
	 cDetails = REPLACE(cDetails,CHR(10),"").
	 cDetails = REPLACE(cDetails,CHR(13),"").
	END.
	ELSE
	DO:
	   /* �᫨ ��� � ������᪨�, � �⠢�� ४������ ��� �������� */
	   IF acct.cust-cat EQ '�' OR  acct.cust-cat EQ '�' THEN
        	 DO:
	           oClient = new TClient(acct.acct).

			 ASSIGN
	                   name[1] = oClient:name-short
	                   cDetails = ""
                          .

	            DELETE OBJECT oClient.
         	   END.
         	   ELSE
            	     DO:
			/* �᫨ ��� �����, � �⠢�� ������������ ��� */
		 	IF acct.cust-cat EQ "�" THEN DO:
			   ASSIGN
			    name[1]=acct.details
			    cDetails=""
			    .
			END.
		        ELSE DO:
                       		name[1] = "".
	                       cDetails = acct.details.
        	        END.
		END.
           IF name[1] EQ "" THEN cDetails = acct.details.
	END.

/*** ����� ���������� ��� ������������ ***/

cName = name[1].

IF name[1] <> "" THEN cName = TRIM(oSysClass:REPLACE_ASCII(name[1],10,"-")).
IF cName <> ""   THEN cName = TRIM(oSysClass:REPLACE_ASCII(cName,13,"-")).


col1[1] = getXAttrValue("acct",acct.acct + "," + acct.currency,"��������").

col1[1] = REPLACE(col1[1],CHR(10),"").
col1[1] = REPLACE(col1[1],CHR(13),"").

col4[1] = "". /* � �⮩ ����� ��� �������� ��⮢ */
col6 = getXAttrValue("acct",acct.acct + "," + acct.currency,"��⠑���釠�").



/* ��宦����� ��᫥����� �������饣� ������� ��� ��� */
/*
 ����� � ⠡��� �� ����� ���� ���� ����ᥩ ��� ������ � ⮣� �� �������.
 contract eq "" or can-find(contract of loan-acct)
*/

IF col1[1] = "" AND col1[1] NE "01/01/1900,00" THEN
DO:
 /* �᫨ �� 㪠��� ����� � ��� ������� �� � ���. ४�� ��� */

 FIND FIRST loan-acct OF acct WHERE loan-acct.since LE end-date 
						      AND (loan-acct.contract EQ "�।��" 
							   OR loan-acct.contract EQ "�����" 
							   OR loan-acct.contract EQ "dps" 
							   OR loan-acct.contract EQ "card-c"
                                                          ) NO-LOCK NO-ERROR.

 IF AVAILABLE(loan-acct) THEN
   DO:
		FIND FIRST loan  OF loan-acct NO-LOCK NO-ERROR.
		IF AVAILABLE(loan) THEN col1[1] = STRING(loan.open-date,"99/99/9999") + ",". 

		IF {assigned loan.doc-ref} THEN col1[1] = col1[1] + loan.doc-ref.
		ELSE
			DO:
				IF {assigned loan.doc-num} THEN col1[1] = col1[1] +  loan.doc-num.
				ELSE IF {assigned loan.cont-code} THEN col1[1] = col1[1] + loan.cont-code.
			 END.

     END.

END. 

/* ����� ��।������ ������� */
IF col1[1] EQ "01/01/1900,00" THEN col1[1] = "".


   IF col5 EQ "����७���" OR col5 EQ "��������" OR col5 EQ "��㤭�" THEN 
								DO:
								   ASSIGN
								     col2[1] = "�� �ॡ����"
								     col3 = "�� �ॡ����"
								     col6 = "�� �ॡ����"
                                                                    .
								END.	
					          ELSE  
							DO:
								col2[1] = getXAttrValue("acct",acct.acct + "," + acct.currency,"����뤂믨�").
 							        col3 = getXAttrValue("acct",acct.acct + "," + acct.currency,"��⠑���鋑").

								/* 
								 �᫨ ��� �������, ����� �᪮���� ���ࢠ��
								 ��� ��� ����� �����, � �� ���. ४����� �� ᬮ�ਬ
								 */
								col6 = getXAttrValue("acct",acct.acct + "," + acct.currency,"��⠑���釠�").

								IF NOT CAN-DO("�� ��*",col6) THEN
									DO:						
										IF acct.close-date >= end-date OR acct.close-date EQ ?  THEN col6 = "".
									END.
								
							END.


   
   /* ࠧ������ ������ ������������ �� ��᪮�쪮 ��ப */

oTable:addRow().

oTable:addCell(ppnum).			            /* �1 */
oTable:addCell(acct.open-date).	        /* �2 */
oTable:addCell(col1[1]).			            /* �3 */
oTable:addCell(cName).			            /* �4 */
oTable:addCell(acct.acct).			            /* �5 */
oTable:addCell(col5).	                            /* �6 ��� ��� */
oTable:addCell(col2[1]).                       /* �7  ���冷� �뤠� �믨᮪ */
oTable:addCell(col3).                            /* �8  ��� ᮮ�饭�� �� ����⨨ */
oTable:addCell(col4[1]).	                    /* �9  ��� ������� */
oTable:addCell(col6).                           /* �10 ��� ᮮ�饭�� � �����⨨ */
oTable:addCell(cDetails).                    /* �11 �ਬ�砭�� */
oTable:addCell(bal-acct.bal-acct).       /* �12 �����ᮢ� ���*/

END.

oTable:SAVE-TO(filePath + "/book-" + STRING(YEAR(end-date)) + STRING(MONTH(end-date)) + STRING(DAY(end-date)) + ".txt").


/*
{setdestp.i &cols=200}
oTable:show().
{preview.i}
*/

DELETE OBJECT oTable.
DELETE OBJECT oSysClass.
