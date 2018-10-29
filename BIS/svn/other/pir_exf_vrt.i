DEFINE VARIABLE iVR AS INTEGER FORMAT "9" INITIAL 1 NO-UNDO. /* ��ਠ�� ���� */

/** ��楤�� ���᪠ ���� ��᫥����� �������� �� ���� ********/
/** ��� ��ᮢ�� �� 䠩��� acct-pos.i � last-pos.i pos ********/

PROCEDURE LookLastMove.
   DEFINE INPUT PARAMETER in-acct     LIKE acct.acct     NO-UNDO.
   DEFINE INPUT PARAMETER in-currency LIKE acct.currency NO-UNDO.
   DEFINE INPUT PARAMETER since       AS   DATE          NO-UNDO.

   DEFINE VARIABLE vLastPos AS DATE  NO-UNDO.

   vLastPos = since.
   REPEAT:
      FIND LAST acct-pos WHERE
         acct-pos.acct EQ in-acct AND
         acct-pos.currency EQ in-currency AND
         acct-pos.since LT vLastPos
         NO-LOCK NO-ERROR.
      /* ⮫쪮 � ��砥 ������⢨� �࠭���樨, ���� �ந�室��
         ��९������� ⠡���� �����஢�� */
      IF NOT TRANSACTION AND AVAIL acct-pos THEN DO:
         /* 㬥��蠥� ���� ��� �᪫�祭�� ���᪠ �������஢����� ����� */
         vLastPos = acct-pos.since.
         FIND CURRENT acct-pos
            SHARE-LOCK NO-WAIT NO-ERROR.
         IF NOT AVAIL acct-pos THEN
            /* �᫨ ������ �ᯥ�� 㤠���� �� �⪠� ���
            ��� ��� �������஢��� �� �����⨨ ��� */
            NEXT.
         ELSE
            /* �᢮������� ��墠� */
            FIND CURRENT acct-pos
               NO-LOCK NO-ERROR.
      END.
      LEAVE.
   END.
   lastmove = IF AVAILABLE acct-pos THEN acct-pos.since ELSE ?.

END PROCEDURE.

Function FindRDPO returns date (input in-acct as char,
				input in-since as date).
/* �� ��� #3912 �� ������: ��� "ॠ�쭮�" �������� �� ����� */
	define variable rValue as date init 01/01/1900 no-undo.
	define variable CodRub as char init "810" no-undo.  /*����⠭� ��� ���� �㡫�*/
	define variable min_amt as integer init 300 no-undo. /*����⠭� ��� �������쭮� �㬬� ���㬥��*/
	define variable EntryDateCr as date init 01/01/1900 no-undo.
	define variable EntryDateDb as date init 01/01/1900 no-undo.

	if substring(in-acct, 6, 8) ne CodRub then do: /*���㬥�� �� �㡫��*/
		find last op-entry where op-entry.op-date ge in-since and
					op-entry.acct-cr eq in-acct and
					op-entry.amt-cur ne 0 and  /* �᪫�砥� ������� ��८業�� */
					op-entry.amt-rub gt min_amt no-lock no-error.
		if available op-entry then EntryDateCr = op-entry.op-date.
			find last op-entry where op-entry.op-date ge in-since and /*or �ࠩ�� �������� ࠡ�⠥� � ������, �.�. ���� �� �� �������. ��������� �� 2 ����� */
						op-entry.acct-db eq in-acct and 
						op-entry.amt-cur ne 0 and  /* �᪫�砥� ������� ��८業�� */
						op-entry.amt-rub gt min_amt no-lock no-error.
		if available op-entry then EntryDateDb = op-entry.op-date.
		rValue = max(EntryDateDb, EntryDateCr).
	end.
	else do:
		find last op-entry where op-entry.op-date ge in-since and
					op-entry.acct-db eq in-acct and
					op-entry.amt-rub gt min_amt no-lock no-error.
		if available op-entry then EntryDateCr = op-entry.op-date.
		find last op-entry where op-entry.op-date ge in-since and /*or �ࠩ�� �������� ࠡ�⠥� � ������, �.�. ���� �� �� �������. ��������� �� 2 ����� */
					op-entry.acct-cr eq in-acct and
					op-entry.amt-rub gt min_amt no-lock no-error.
		if available op-entry then EntryDateDb = op-entry.op-date.
		rValue = max(EntryDateDb, EntryDateCr).
	end.
	if rValue eq 01/01/1900 then rValue = ?.
	return rValue.
End Function.

/** �஢�ઠ �᫮��� �⡮� ��⮢ �� ���������� ��ਠ��� iVR */

FUNCTION VrTest RETURNS LOGICAL
   (INPUT acct     AS CHAR, /* ���          */
    INPUT currency AS CHAR, /* �����        */
    INPUT dOpen    AS DATE, /* ��� ������ */
    INPUT dClose   AS DATE  /* ��� ������� */
   ):

   DEFINE VARIABLE lRt AS LOGICAL NO-UNDO.

   CASE iVR :
      WHEN 1 THEN
         lRt = ((dOpen GE beg-date ) AND (dOpen LE end-date)).
      WHEN 2 THEN
         lRt = ((dClose GE beg-date ) AND (dClose LE end-date)).
      WHEN 3 THEN
         lRt = (dClose LE end-date).
      WHEN 4 THEN
         DO:
            RUN LookLastMove(acct, currency, end-date).
            lRt = ((dOpen GE beg-date ) AND (dOpen LE end-date) AND (lastmove EQ ?)).
         END.
      WHEN 5 THEN
         lRt = ((dOpen LE end-date) AND ((dClose GT end-date) OR (dClose EQ ?))).
   END CASE.

   IF lRt THEN RUN LookLastMove(acct, currency, TODAY).
   RETURN lRt.
END FUNCTION.

/**********************************************************************/
/** �� ���� ������� ����訢����� ��ਠ�� ���� � ���� ***********/

FORM
   "1 - ������ � 㪠����� ��ਮ� (��, ����� � ������묨);"
   "2 - ������� � 㪠����� ��ਮ�;"
   "3 - ������ � ������� �� 㪠������ ����;"
   "4 - ������ � �� ��砫� �������� �� ����;"
   "5 - �������騥 �� 㪠������ ����."
   iVR LABEL "�������" VALIDATE ( iVR < 6, "���������騩 ��ਠ�� !!!")
   WITH FRAME fVR 
   OVERLAY
   SIDE-LABELS
   1 COL
   CENTERED
   ROW 3 
   TITLE COLOR BRIGHT-WHITE "[ ������ ��ਠ�� ����: ]"
   WIDTH 60.

DO 
   ON ENDKEY UNDO , RETURN
   ON ERROR  UNDO , RETRY
:
   UPDATE iVR WITH FRAME fVR.
END.

IF (iVR = 3) OR (iVR = 5) THEN DO:
   {getdate.i}
END.
ELSE DO:
   {getdates.i}
END.
HIDE FRAME fVR.
