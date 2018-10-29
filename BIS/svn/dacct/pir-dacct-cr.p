/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2011 ���
     Filename: pir-dacct-cr.p
      Comment: ᤥ���� �� �������� dacct-cr.p �� ���� �����⥫�� �ࠪ��
		1.�����⨥ ���, ����饣� ����, �� ��࠭� "�� ����뢠�� ����" 
		2.����⨥ ���, ����� ������ ����� ����, �� �� ����⨨ ��࠭� "�� ���뢠�� ����" 
   Parameters: rec-acct AS RECID
         Uses:
      Used by:
      Created: 12.08.2011 SStepanov ����⨥ ����� ��⮢
     Modified: 21.11.2011 ���室 �� D73 � � ���� ��᫮�� 
		rec-acct -> surr-acct

*/
{globals.i}
{intrface.get tmess}   
{intrface.get xclass}  
{intrface.get acct} 

/* �뫮 �� ��� ��᫮�� DEFINE INPUT PARAMETER rec-acct AS RECID NO-UNDO. */
DEFINE INPUT PARAMETER surr-acct AS CHARACTER NO-UNDO. /* �⠫� */

DEF BUFFER bAcct-contr 	FOR acct.
DEF BUFFER bAcct	FOR acct.
DEFINE VARIABLE c_return-value    AS CHARACTER NO-UNDO.

/* RUN dacct-cr.p (rec-acct). 21.11.2011 ���室 �� D73 � � ���� ��᫮�� rec-acct -> surr-acct */
RUN dacct-cr.p (surr-acct).
/* MESSAGE RETURN-VALUE VIEW-AS ALERT-BOX. */

c_return-value = return-value.

FIND FIRST bAcct
	/* WHERE RECID(bAcct) = rec-acct 21.11.2011 ���室 �� D73 � � ���� ��᫮�� rec-acct -> surr-acct */
	WHERE bAcct.acct 	= ENTRY(1, surr-acct)
	  AND bAcct.currency 	= ENTRY(2, surr-acct)
	NO-LOCK.

IF {assigned bacct.contr-acct} THEN DO:
  FIND FIRST bAcct-contr
	WHERE bAcct-contr.acct = bAcct.contr-acct NO-LOCK.
  IF AVAIL bAcct-contr THEN DO:		/* ���� ���� ��� */
    IF bacct-contr.close-date <> ? THEN DO:	/* � �� ������ */
      MESSAGE "���� ��� " bacct-contr.contr-acct " ������ ���� �����!\n ����� ������ ��� � ������� ���� ���"
	VIEW-AS ALERT-BOX ERROR.
      c_return-value = "Error".
    END.
  END.
END.
ELSE DO:
  FIND FIRST CODE
    WHERE code.class = "Dual-bal-acct" AND 
          (code.code EQ STRING(bacct.bal-acct) OR
           code.val  EQ STRING(bacct.bal-acct))
    NO-LOCK NO-ERROR.

  IF AVAIL(CODE) THEN DO:
      MESSAGE "���� ��� ������ ���� ����� ��� ⠪��� �����ᮢ��� ��� 2�� ���浪�!"
	VIEW-AS ALERT-BOX ERROR.
      c_return-value = "Error".
  END.
END.

RETURN c_return-value.
