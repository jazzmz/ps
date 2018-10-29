/* ========================================================================= */
/** 
    Copyright: ��� ��� ����, ��ࠢ����� ��⮬�⨧�樨 (C) 2013
     Filename: pir_u11rep_w008.p
      Comment: ���� "����� �� ���������� ������ 䨧.���" ��� �11
		���� ࠡ�⠥� ⮫쪮 �� �����⠬, � ������ ���� �������騩 ������� �� ��
   Parameters: 
       Launch: �� - ������� - ���.��� - �⬥砥� �㦭��, ctrl+g - �������: (�11) ����� �� ���������� ������ 䨧.���
      Created: Sitov S.A., 06.08.2013
	Basis: #3504
     Modified: 
               
*/
/* ========================================================================= */

MESSAGE  "      ��� ��楤���  #3504-001       "  VIEW-AS ALERT-BOX TITLE "[ ���: ��� ��������� � �������������� ]". 


{globals.i}
{tmprecid.def}
{wordwrap.def}
{getdate.i}
{ulib.i}


DEF VAR AcctList  AS CHAR  NO-UNDO.
DEF VAR n      AS INT  INIT 0   NO-UNDO.

DEF VAR tmpStr AS CHAR EXTENT 4 NO-UNDO.
DEF VAR s      AS INT  INIT 0   NO-UNDO.




/*** ===================================================================== ***/
/*** ====                                                             ==== ***/
/*** ===================================================================== ***/

/**
 * �����頥� ᯨ᮪ �᭮���� ��⮢ ������� ������஢ �� �� (��� 䨧���)
 **/
FUNCTION GetAcctList RETURNS CHAR(INPUT mClId AS INT,INPUT mDate AS DATE):
  DEF VAR  mAcctList  AS CHAR  INIT "" NO-UNDO.     
  DEF BUFFER loan FOR loan.

  FOR EACH loan 
    WHERE loan.contract EQ 'card-pers' 
    AND   loan.cust-cat EQ '�'
    AND   CAN-DO("card-loan-pers", loan.class-code) 
    AND   loan.cust-id  EQ mClId 
    AND   CAN-DO("����,����",loan.loan-status)
    AND   loan.end-date > mDate
    AND  (loan.close-date = ? OR loan.close-date >= mDate)
    NO-LOCK :

	IF mAcctList = "" THEN 
	  mAcctList = GetLoanAcct_ULL(loan.contract, loan.cont-code, 'SCS@' + loan.currency, mDate, false) .
	ELSE 
	  mAcctList = mAcctList + "," + GetLoanAcct_ULL(loan.contract, loan.cont-code, 'SCS@' + loan.currency, mDate, false).

  END.

  RETURN mAcctList .
END FUNCTION.




/*** ===================================================================== ***/
/*** ====                                                             ==== ***/
/*** ===================================================================== ***/

{setdest.i}

FOR EACH tmprecid,
FIRST person
  WHERE RECID(person) = tmprecid.id
NO-LOCK:


  AcctList =  GetAcctList(person.person-id, end-date) .

  IF  NUM-ENTRIES(AcctList,",") < 1   
	THEN  NEXT .


  PUT UNFORM SKIP(3).

	/*** ��� ������ */
  tmpStr[1] = person.name-last + " " + person.first-name .
  {wordwrap.i &s=tmpStr &n=4 &l=37}
  DO s = 1 TO 4 :
    IF tmpStr[s] <> "" THEN  PUT UNFORM  FILL(" ", 42) tmpStr[s]  SKIP.
  END.

	/*** ���᮪ �᭮���� ��⮢ �� �� */
  DO n = 1 TO NUM-ENTRIES(AcctList,",") :
    IF n = 1 THEN  
	PUT UNFORM  FILL(" ", 42) "������ ��� � " ENTRY(n,AcctList,",") SKIP.
    ELSE
	PUT UNFORM  FILL(" ", 59)                     ENTRY(n,AcctList,",") SKIP.
  END.


  PUT UNFORM
        " " SKIP(2)
	"      � 楫�� ���������� � ���㠫���樨 ������ ��襣� �ਤ��᪮�� ���� ��ᨬ"  SKIP
	"� ���砩訥 �ப� �।��⠢��� � �⤥� ���㦨����� ��ᨨ ��ࠢ����� �����-"  SKIP
	"����� ���� ��� ��� ���� ᫥���騥 ���㬥���:"  SKIP(1)

	"1) ��ᯮ�� (��� ���� �����)."  SKIP(1)

	"���������� ���, �� ᮣ��᭮ �.5.7. ������� ������᪮�� ���, �।�ᬠ�ਢ��-"  SKIP
	"饣� ᮢ��襭�� ����権 � �ᯮ�짮������ ������ ����  VISA - PIR Bank �� "    SKIP
	"��易�� ���������⥫쭮 �।��⠢���� ���㬥��� �� ��������� ������, 㪠������"  SKIP
	"� �������, � ������ �� �������������."  SKIP(2)

	"� 㢠������, "  SKIP
	"��砫쭨� ��ࠢ����� ����⨪���� ����                              ��ﭮ�� �.�."  SKIP(2)

	"��� "  end-date FORMAT "99/99/9999"  " �."  SKIP(4)
	"���.: +7(495)785-56-97, +7(495)742-05-05 (���.143,182)"  SKIP(2)
  .

  PAGE.

END.


{preview.i}
	