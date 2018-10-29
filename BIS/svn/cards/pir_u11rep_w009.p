/* ========================================================================= */
/** 
    Copyright: ��� ��� ����, ��ࠢ����� ��⮬�⨧�樨 (C) 2013
     Filename: pir_u11rep_w009.p
      Comment: ���� �� �����⠬ �11 (��� ���������� �����)
		������ ������� � ����, �᫨ �믮������ �� �᫮��� (�� ��)
   Parameters: 
       Launch: 
      Created: Sitov S.A., 2013-09-23
	Basis: #3806
     Modified: <��> <����� [F7]> (������� ��� ��� ���᪠ <㭨�����_���>) 
               <���ᠭ�� ���������>                                           
*/
/* ========================================================================= */

MESSAGE  "      ��� ��楤���  #3806-001       "  VIEW-AS ALERT-BOX TITLE "[ ���: ��� ��������� � �������������� ]". 

{globals.i}
{getdate.i}
{ulib.i}


DEF VAR CurrDate	AS DATE NO-UNDO.
DEF VAR BordDate	AS DATE NO-UNDO.  

DEF VAR DRUpdAnkDate	AS DATE NO-UNDO.  
DEF VAR DRDocumDate	AS DATE NO-UNDO.  
DEF VAR DRMarkRisk	AS CHAR NO-UNDO.  

DEF VAR if1ok		AS LOG  INIT no NO-UNDO.  /* yes - �������� � ���� */
DEF VAR if2ok		AS LOG  INIT no NO-UNDO.  /* yes - �������� � ���� */
DEF VAR if3ok		AS LOG  INIT no NO-UNDO.  /* yes - �������� � ���� */
DEF VAR if5ok		AS LOG  INIT no NO-UNDO.  /* yes - �������� � ���� */
DEF VAR if6ok		AS LOG  INIT no NO-UNDO.  /* yes - �������� � ���� */
DEF VAR if7ok		AS LOG  INIT no NO-UNDO.  /* yes - �������� � ���� */


DEFINE BUFFER loan	FOR loan.
DEFINE BUFFER card	FOR loan.
DEFINE BUFFER acct	FOR acct.
DEFINE BUFFER person	FOR person.
DEFINE BUFFER code	FOR code.
DEFINE BUFFER op-entry	FOR op-entry.

DEF VAR i		AS INT  NO-UNDO.  
DEF VAR tmpAcct		AS CHAR NO-UNDO.  
DEF VAR tmpEntry	AS CHAR NO-UNDO.  
DEF VAR CardAcct	AS CHAR NO-UNDO.  

/* ========================================================================= */
/* ===                                                                  ==== */
/* ========================================================================= */

FUNCTION getDateByYear RETURNS DATE (INPUT SourceDate AS DATE, INPUT KolYear AS INT, INPUT Direction AS CHAR).

	DEF VAR  DateByYear	AS  DATE  NO-UNDO.
	DEF VAR  NewDay		AS  INT   NO-UNDO.
	DEF VAR  NewYear	AS  INT   NO-UNDO.

	IF Direction <> "+" AND Direction <> "-" THEN KolYear = 0.
	IF Direction =  "-" THEN  KolYear = (-1) * KolYear .
	NewYear = YEAR(SourceDate) + KolYear .

	IF  DAY(SourceDate) = 29 AND MONTH(SourceDate) = 2  THEN  
	   NewDay = 28  .
	ELSE 	
	   NewDay =  DAY(SourceDate) .

	DateByYear = DATE(STRING(NewDay) +  "/" + STRING(MONTH(SourceDate)) + "/" + STRING(NewYear)) .

	RETURN DateByYear.

END FUNCTION.



/* ========================================================================= */
/* ===                                                                  ==== */
/* ========================================================================= */

CurrDate = end-date .
BordDate = DATE("01/07/13") .
i = 0 .



{setdest.i}

PUT UNFORM
	"���"		FORMAT "X(35)"  " | " 
	"��⠐�����"	FORMAT "X(10)"  " | " 
	"��⠄���"	FORMAT "X(10)"  " | " 
	"���� , �ப ����砭��"		FORMAT "X(29)"  " | " 
	"��⠎�����"	FORMAT "X(10)"  " | " 
	"���業����᪠"	FORMAT "X(15)"  " | " 
SKIP(1).


FOR EACH loan 
	WHERE loan.contract   = "card-pers" 
	AND   loan.class-code = "card-loan-pers"
	AND   loan.cust-cat   = '�'
	AND   loan.loan-status <> "����"  AND loan.loan-status <> "�"
NO-LOCK,
EACH card 
	WHERE card.contract = 'card' 
	AND   card.parent-cont-code = loan.cont-code 
	AND   card.parent-contract = loan.contract
	AND   card.end-date >= getDateByYear(CurrDate,3,"-")
	AND   card.end-date <= getDateByYear(CurrDate,1,"+")
	/*AND   card.loan-status <> "����" AND card.loan-status <> '�' AND card.loan-status <> '��' */
	AND   card.loan-status = "���"
NO-LOCK:

  IF AVAIL(loan) THEN
  DO:

	/* yes - �������� � ���� */
    ASSIGN
	if1ok = no
	if2ok = no
	if3ok = no
	if5ok = no
	if6ok = no
	if7ok = no
    .

	/* �᫮��� 5 */
    if5ok = yes .

	/* �᫮��� 3,4,6,7 */
    FIND FIRST person WHERE person.person-id = loan.cust-id  NO-LOCK NO-ERROR.

    IF AVAIL(person) THEN    
    DO:

	  /* �᫮��� 3,4 */
	DRUpdAnkDate = DATE(GetTempXAttrValueEx("person",STRING(person.person-id), "��⠎��������", CurrDate, "")) .
	IF     ( getDateByYear(DRUpdAnkDate,3,"+") < BordDate )  
	    OR  ( getDateByYear(DRUpdAnkDate,1,"+") > BordDate  AND  getDateByYear(DRUpdAnkDate,1,"+") < CurrDate ) 
        THEN
	   if3ok = yes .
	ELSE  NEXT.

	  /* �᫮��� 6 */
	DRDocumDate = DATE(GetXAttrValueEx("person",STRING(person.person-id), "Document4Date_vid",  "")) .
	IF   ( DRDocumDate > getDateByYear(person.birthday,45,"+") ) 
	  /* OR ( DRDocumDate > getDateByYear(person.birthday,20,"+")  AND  DRDocumDate < getDateByYear(person.birthday,45,"+")  ) */
	THEN
	   if6ok = yes .
	ELSE  NEXT.

	  /* �᫮��� 7 */
	DRMarkRisk = GetTempXAttrValueEx("person",STRING(person.person-id), "�業����᪠", CurrDate, "") .
	FIND FIRST code WHERE  code.class EQ "Pir�業����᪠" AND code.parent EQ  "Pir�業����᪠"  AND code.val = DRMarkRisk NO-LOCK NO-ERROR.
	IF AVAIL(code) THEN
	   DRMarkRisk = code.code .

	IF  DRMarkRisk = "01"  OR  DRMarkRisk = "0.1."  THEN
	   if7ok = yes .
	ELSE  NEXT.

    END. /* IF AVAIL(person) */ 


	/* �᫮��� 1 */
    tmpAcct = "" .
    FOR EACH acct 
	WHERE acct.acct-cat = "b"
	AND   acct.cust-id = loan.cust-id 
	AND   acct.close-date = ?  OR  acct.close-date > CurrDate
    NO-LOCK:

	IF  NOT( (acct.bal-acct = 40817  OR  acct.bal-acct = 42309)  AND  SUBSTRING(acct.acct,14,3) = "050")  THEN
	  tmpAcct = acct.acct + "," + tmpAcct.

    END.

    IF tmpAcct = "" THEN  
	if1ok = yes .	
    ELSE  NEXT.


	/* �᫮��� 2 */
    CardAcct = GetLoanAcct_ULL(loan.contract, loan.cont-code, 'SCS@' + loan.currency, CurrDate, false).
    tmpEntry = "" .
    FOR EACH op-entry 
	WHERE 
	(
	((op-entry.acct-db EQ CardAcct and op-entry.op-date >= getDateByYear(CurrDate,3,"-") and op-entry.op-date <= CurrDate)) 
	OR
	((op-entry.acct-cr EQ CardAcct and op-entry.op-date >= getDateByYear(CurrDate,3,"-") and op-entry.op-date <= CurrDate))
	) 
    NO-LOCK,
    FIRST op OF op-entry 
	WHERE op.op-kind <> "����" AND (op.op-status = "�"  OR op.op-status = "��") 
    NO-LOCK:
	tmpEntry = STRING(op-entry.op-date,'99/99/9999') .
    END.

    IF tmpEntry <> "" THEN  
	if2ok = yes .	
    ELSE  NEXT.



    IF  if1ok AND if2ok AND if3ok AND if5ok AND if6ok AND if7ok  THEN
    DO:

	i = i + 1 .

	PUT UNFORM 
	  (person.name-last + " " + person.first-name) FORMAT "X(35)"	" | "
	  person.birthday FORMAT "99/99/9999"				" | "
	  DRDocumDate 	  FORMAT "99/99/9999"				" | "
	  card.doc-num " , " card.end-date  FORMAT "99/99/9999"		" | "
	  DRUpdAnkDate    FORMAT "99/99/9999"				" | "
	  GetTempXAttrValueEx("person",STRING(person.person-id), "�業����᪠", CurrDate, "")  FORMAT "X(15)" " | "
        /*
	STRING(if1ok)  FORMAT "X(3)" "@" 
	STRING(if2ok)  FORMAT "X(3)" "@" 
	STRING(if3ok)  FORMAT "X(3)" "@" 
	STRING(if5ok)  FORMAT "X(3)" "@" 
	STRING(if6ok)  FORMAT "X(3)" "@" 
	STRING(if7ok)  FORMAT "X(3)" "@" 
	tmpEntry FORMAT "X(10)" " | "
	tmpAcct
	*/
	SKIP.
    END.


  END.

END.


PUT UNFORM  SKIP(1) .
PUT UNFORM "�����: " i SKIP .

{preview.i}