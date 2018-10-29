/* ========================================================================= */
/** 
    Copyright: ��� �� "�P��������������", ��ࠢ����� ��⮬�⨧�樨 (C) 2012
     Filename: pir_u11rep_w002.p
      Comment: ��ᯮ�� � csv-䠩� ������ � ������⢥ ����७���⥩ �� ��, ��������� 
		�� �������� ����
   Parameters: ��⠫�� ��� 䠩�� �ᯮ��
      Launch:  �� - ����� - ��室�� ��� - ���: ���᮪ ����७���⥩ �� �ᥬ �� 
         Uses:
      Created: Sitov S.A., 11.10.2012
	Basis: #1168 (��)
     Modified: <��> <����� [F7]> (������� ��� ��� ���᪠ <㭨�����_���>) 
               <���ᠭ�� ���������>                                           
*/
/* ========================================================================= */


/*{pirsavelog.p}*/
{globals.i}		/** �������� ��।������ */
{ulib.i}		/** ������⥪� ���-�㭪権 */
{getdate.i}


/* ========================================================================= */
				/** ������� */
/* ========================================================================= */

  /* �室�� ��ࠬ���� ��楤��� */
DEF INPUT PARAM iParam AS CHAR.
  /* ��室��� 䠩� */
DEF VAR out_file_name AS CHAR. 

DEF VAR cardholder    AS CHAR NO-UNDO.
DEF VAR pr-agent-id   AS CHAR NO-UNDO.
DEF VAR pr-agent-name AS CHAR NO-UNDO.
DEF VAR pr-docum      AS CHAR NO-UNDO.
  /* ४������, ��।����騥 �ࠢ� �� ����� */
DEF VAR pir-cashinpk  AS CHAR NO-UNDO.
DEF VAR pir-getvip    AS CHAR NO-UNDO.
DEF VAR pir-getpin    AS CHAR NO-UNDO.
DEF VAR pir-getpk     AS CHAR NO-UNDO.
DEF VAR pr-list	      AS CHAR NO-UNDO.

DEF VAR i  AS INT INIT 0 NO-UNDO.

   /* �६����� ⠡���  */
DEF TEMP-TABLE prrep NO-UNDO
	FIELD cardholdr	AS CHAR
	FIELD card	AS CHAR
	FIELD cardloan	AS CHAR
	FIELD cardtype	AS CHAR
	FIELD propndate	AS DATE
	FIELD prenddate	AS DATE
	FIELD prmonth	AS INT
	FIELD pragent	AS CHAR
	FIELD pragdoc	AS CHAR
	FIELD prcashinpk AS CHAR
	FIELD prgetvip 	AS CHAR
	FIELD prgetpin 	AS CHAR
	FIELD prgetpk  	AS CHAR
.

DEF BUFFER card FOR loan.	/* ��� ����窨 */
DEF BUFFER prloan FOR loan.     /* ��� ����७���⥩ */



/* ========================================================================= */
				/** ��������� */
/* ========================================================================= */

IF NUM-ENTRIES(iParam) > 0 THEN
	out_file_name = ENTRY(1,iParam) + "/" + LC(userid("bisquit")) + "/pir_u11rep_w002.csv" .
ELSE
	out_file_name = "/home2/bis/quit41d/imp-exp/users/pir_u11rep_w002.csv" .

  /** ������ �뢮� � 䠩� */		
OUTPUT TO VALUE(out_file_name) CONVERT TARGET "1251" .



FOR EACH card 
	WHERE card.contract = "card"
	AND CAN-DO("���,���,���",card.loan-status)
	AND card.parent-contract = "card-pers"
	/* AND card.parent-cont-code = "G/USD/05-030" */
NO-LOCK: 


	/* ������ ������������ �� ��������� ����� */
  FOR EACH sign
	WHERE sign.file-name = "loan"
	AND sign.code = "drower-id"
	AND sign.dec-value = card.cust-id
  NO-LOCK,
  EACH  prloan 
	WHERE prloan.contract = "proxy"
	AND prloan.contract   = "proxy"
	AND prloan.cont-code  = ENTRY(2,sign.surrogate)
	AND prloan.end-date   >= end-date
  NO-LOCK:

           /* ��।��塞 �� ����७���� ᯨ᮪ ����७��� ��⮢, ��, � �.� */
	pr-list = GetXattrValueEx("loan", STRING(prloan.contract + "," + prloan.cont-code), "loan-allowed", "")  .

	IF CAN-DO(pr-list,card.doc-num) THEN
	DO:

		  /* �ࠢ� �� ����� */
		pir-cashinpk = GetXattrValueEx("loan", STRING(prloan.contract + "," + prloan.cont-code), "pir-cashinpk", "") .	
	        pir-getvip   = GetXattrValueEx("loan", STRING(prloan.contract + "," + prloan.cont-code), "pir-getvip"  , "") .	
		pir-getpin   = GetXattrValueEx("loan", STRING(prloan.contract + "," + prloan.cont-code), "pir-getpin"  , "") .	
		pir-getpk    = GetXattrValueEx("loan", STRING(prloan.contract + "," + prloan.cont-code), "pir-getpk"   , "") .	

		   /* ����७��� ��� � ��ঠ⥫� ����� */
		pr-agent-id = GetXattrValueEx("loan", STRING(prloan.contract + "," + prloan.cont-code), "agent-id", "")  .
		pr-agent-name =  "" .
		pr-docum      = "" .
		cardholder    = "" .

		IF card.cust-cat = "�" THEN
		DO:

		      /* ����७��� ��� � ��� ���㬥��  */
		    FIND FIRST person WHERE STRING(person.person-id) = pr-agent-id NO-LOCK NO-ERROR.
		    pr-agent-name = person.name-last + " " + person.first-names .
		    pr-docum = person.document-id + ": " + person.document + ". �뤠�: " + person.issue + " " + GetXAttrValueEx("person",STRING(person.person-id),"Document4Date_vid","") .

		      /* ��ঠ⥫� ����� */
		    FIND FIRST person WHERE person.person-id = card.cust-id NO-LOCK NO-ERROR.
		    cardholder = person.name-last + " " + person.first-names .
		   
		END.

		  /* ⨯ ����� */
		FIND LAST code
			WHERE code.class EQ '����끠���' 
			AND code.parent EQ '����끠���' 
			AND code.code = card.sec-code
		NO-LOCK NO-ERROR.

		CREATE prrep .
		ASSIGN
		  prrep.cardholdr = cardholder
		  prrep.card	  = card.doc-num
		  prrep.cardloan  = card.parent-cont-code
		  prrep.cardtype  = REPLACE(code.name, "VISA ", "") 
		  prrep.propndate = prloan.open-date   /* ��� ��砫� ����⢨� � ��� ����砭��, ����� */
		  prrep.prenddate = prloan.end-date 
		  prrep.prmonth	  = MONTH(prloan.open-date)
		  prrep.pragent	  = pr-agent-name
		  prrep.pragdoc	  = REPLACE(pr-docum, CHR(10) , "") 
		  prrep.prcashinpk = ( IF LC(pir-cashinpk) = "��" THEN pir-cashinpk ELSE "" )
		  prrep.prgetvip  =  ( IF LC(pir-getvip)   = "��" THEN pir-getvip   ELSE "" )
		  prrep.prgetpin  =  ( IF LC(pir-getpin)   = "��" THEN pir-getpin   ELSE "" )
		  prrep.prgetpk   =  ( IF LC(pir-getpk)    = "��" THEN pir-getpk    ELSE "" )
		.

	END. /* if_IF CAN-DO(pr-list,card.doc-num) */

  END. /* end_FOR EACH sign*/

END.



	  /*** �뢮� � ���� ***/

  /* ����� ���� */
PUT UNFORM 
    ";" 		      
    "��ঠ⥫� �����;"
    "��� �����;"      
    "����� �����;"
    /* "�������;" */
    "��� ���.���-�;"
    "�ப ����⢨� ���-�;"
    "�����;"
    "����७��� ���;"
    "�ࠢ� ���ᥭ�� ����� �� ��� ��;"
    "�ࠢ� ����祭�� �믨᪨ �� ����;"    
    "�ࠢ� ����祭�� � ��।�� ����;"    
    "�ࠢ� ����祭�� � ��।�� ��;"    
    "���㬥�� �����७���� ���;"
SKIP.


FOR EACH prrep BY prrep.cardholdr BY prrep.cardtype :

  i = i + 1 .
  
  PUT UNFORM 
    i 		      ";"
    prrep.cardholdr   ";"
    prrep.cardtype    ";"
    "'" prrep.card	      ";"
    /* prrep.cardloan    ";" */
    STRING(prrep.propndate,"99/99/9999")   ";"
    STRING(prrep.prenddate,"99/99/9999")   ";"
    "'" STRING(prrep.prmonth,"99")     ";"  
    prrep.pragent     ";"  
    prrep.prcashinpk  ";"
    prrep.prgetvip    ";"
    prrep.prgetpin    ";"
    prrep.prgetpk     ";"
    prrep.pragdoc     ";"  
  SKIP.
  
END.

PUT UNFORM "�����:;" i  SKIP.
PUT UNFORM "�� ����;" STRING(end-date,"99/99/9999") SKIP.

OUTPUT CLOSE.

MESSAGE out_file_name 
  VIEW-AS ALERT-BOX  TITLE "���� ��࠭�� �:".
