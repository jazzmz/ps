{pirsavelog.p}

/* 
 * �����誠, ����室��� ��� ����᪠ �� e-ucscu3 �� �����஢騪� �����. 
 * �ନ��� �.�.
 * 01/07/2010 
 */

{globals.i}

DEF VAR vOpRID AS RECID NO-UNDO.
DEFINE INPUT PARAMETER iDays AS INT.

FIND FIRST op-kind WHERE op-kind.op-kind = 'e-ucscu3' NO-LOCK NO-ERROR.
IF AVAIL op-kind THEN DO transaction:
	vOpRID = RECID(op-kind).
	RUN VALUE(op-kind.proc + ".p")(INPUT (TODAY + iDays), INPUT vOpRID) NO-ERROR.
    RETURN.
END.

RETURN. 
	
	

