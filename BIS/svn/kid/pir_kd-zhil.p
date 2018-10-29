/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2012 PIRbank
     Filename: pir_kd-zhil.p
      Comment: ���� �� ������ �।�⠬.
		1. ������ �।���.
		��㤭� ��� | ����騪 | ����� ������� | ��� �뤠�
		1.1. �� ��� �������
		1.2 �� ��� ������� � ��� 8806
   Parameters:
         Uses:
      Used by:
      Created: 29/05/2012 SSV
     Modified:
*/

{globals.i}

{tmprecid.def}
{intrface.get tmess}
{intrface.get strng}
{intrface.get card}
{intrface.get cust}
{intrface.get xclass}
{intrface.get instrum}
{intrface.get loan}
{intrface.get date}

/* DEF INPUT PARAM i_user-proc_procedure AS CHAR. / * �ᯮ��㥬� 蠡��� ��।����� ��ࠬ��஬ */

{getdates.i}
/* beg-date = gbeg-date.
end-date = gend-date. */

{setdest.i}

RUN PrintKDwithTypeXAttr("1. ������ �।���.", "������,����*", "*").

RUN PrintKDwithTypeXAttr("1.1. �� ��� �������", "����*", "*").

RUN PrintKDwithTypeXAttr("1.2 �� ��� ������� � ��� 8806", "������,����*", "��8806").

FIND FIRST _user
  WHERE _user._userid = userid
  NO-LOCK NO-ERROR.

PUT UNFORMATTED
	SKIP(2) "\t" "\t" "\t"
	STRING(TODAY, "99/99/99") " "
	STRING(TIME, "hh:mm:ss")

	" ___________________ "
	(IF AVAIL _user
	  THEN _user._user-name
	  ELSE "-"
	) SKIP.


{preview.i}


/* ���⠥� �������� � ��।������ ⨯�� � �� */
PROCEDURE PrintKDwithTypeXAttr.
  DEF INPUT PARAM ipTitle 	AS CHAR NO-UNDO.
  DEF INPUT PARAM ipContType 	AS CHAR NO-UNDO.
  DEF INPUT PARAM ipXAttrValue 	AS CHAR NO-UNDO.

  DEF VAR vCount AS INT NO-UNDO.
  DEF VAR vSum   AS DEC NO-UNDO.
  vCount = 0.
  vSum   = 0.

  PUT UNFORMATTED
    ipTitle
      SKIP.

  FOR /* EACH tmprecid
  , FIRST */ EACH loan
/*    WHERE RecID(loan) = tmprecid.id */
      WHERE loan.open-date >= beg-date
        AND loan.open-date <= end-date
        AND CAN-DO(ipContType, loan.cont-type)
      NO-LOCK
        WITH WIDTH 120 :
     FIND LAST loan-acct
       OF loan
       WHERE loan-acct.acct-type = "�।��"
	 AND loan-acct.since     <= end-date
       NO-LOCK NO-ERROR.
     DEF VAR         vClName AS CHAR NO-UNDO EXTENT 3.
     RUN GetCustName IN h_base (loan.cust-cat,
                                loan.cust-id,
                                "",
                                OUTPUT       vClName[1],
                                OUTPUT       vClName[2],
                                INPUT-OUTPUT vClName[3]
     				).

	vClName[1] = vClName[1] + " " + vClName[2].

  	DEF VAR vXAttrValue 	AS CHAR NO-UNDO.
	vXAttrValue = IF ipXAttrValue <> "*"
	  		THEN (IF (GetXAttrValue("acct", (loan-acct.acct + "," + loan-acct.curr), "i1_dec") = ipXAttrValue)
					THEN "*"
					ELSE ""
				)
			ELSE "*".
     	
	IF vXAttrValue = "*" THEN DO:
	  vCount = vCount + 1.
    	  DISP
	    (IF AVAIL loan-acct
	     THEN loan-acct.acct
	     ELSE "")	 FORMAT 'x(20)'      		COLUMN-LABEL "��㤭� ���"
	    vClName[1]	 FORMAT 'x(31)'      		COLUMN-LABEL "����騪"
  	    loan.cont-code	 FORMAT 'x(12)'	     	COLUMN-LABEL "����� �������"
/*	    loan.loan-status FORMAT 'x(4)' */
  	    loan.open-date 	 FORMAT '99.99.9999' 	COLUMN-LABEL "��� �뤠�"
/*	    loan.end-date  	 FORMAT '99.99.9999'
	    loan.currency */
		SKIP.
	END. /* IF vXAttrValue = "*" THEN DO: */
  END. /* FOR EACH loan */
  PUT UNFORMATTED
    "�⮣� " vCount
      SKIP SKIP	.
END. /* PROCEDURE PrintKDwithTypeXAttr. */
