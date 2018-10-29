/* ========================================================================= */
/** 
    Copyright: ��� ��� ����, ��ࠢ����� ��⮬�⨧�樨 (C) 2013
     Filename: pir_u102_kodopval.p
      Comment: ��楤�� ���⠢��� ���.४����� ��������117 �� ��㯯� ���㬥�⮢
		���㬥��� �⡨ࠥ� ���㤭�� �� 䨫����
		������ ���祭�� ��������117, � ��楤�� ���ᮢ� ���⠢��� �� �� ���㬥���
		� ��⮬ ��᪨ ���������� �⮣� ���.४�����
   Parameters: 
       Launch: �� - ����.���� - �⬥砥� �㦭� ���㬥���, CTRl+G - ���: ���⠭���� �� ��������117 �� ���㬥���
      Created: Sitov S.A., 2013-10-01
	Basis: # 3781
     Modified: <��> <����� [F7]> (������� ��� ��� ���᪠ <㭨�����_���>) 
               <���ᠭ�� ���������>                                           
*/
/* ========================================================================= */


{globals.i}
{intrface.get xclass}  
{intrface.get tmess} 
{tmprecid.def}




/* =========================   ����������   ================================= */

DEF VAR vAllAmt		AS DEC  NO-UNDO.
DEF VAR vKolOpEntry	AS DEC  NO-UNDO.

DEF VAR vDRValue	AS CHAR NO-UNDO.
DEF VAR vKodOpVal	AS CHAR NO-UNDO.

DEF TEMP-TABLE tt
	FIELD id AS INT64 
.

FOR EACH tmprecid NO-LOCK:
  CREATE tt.
  tt.id = tmprecid.id . 
END.



/* =========================   ����������   ================================= */

FORM
   vKodOpVal   FORMAT "X(10)"	LABEL  "��������117"  HELP   "��������"
WITH FRAME frm01 1 COL OVERLAY CENTERED ROW 10 TITLE "[ ������� ��������117 ��� ���� ���������� ]".


ON "F1" OF vKodOpVal IN FRAME frm01
DO:
   pick-value = ?. 
   DO TRANSACTION:

      RUN codelay.p("��������117", "��������117", "���� �������� ��������� ��������", 4).
   
      IF LAST-EVENT:FUNCTION NE "END-ERROR"  AND  pick-value <> ? THEN 
      DO:
         vKodOpVal:SCREEN-VALUE = pick-value . 

         IF  CAN-FIND(FIRST code WHERE code.class  = "��������117" AND code.parent = TRIM(pick-value))  AND LENGTH(pick-value) < 5  THEN 
         DO:
            RUN Fill-SysMes ("", "", "-1", "� ��ࠬ��� " + vKodOpVal + " ���� �����ࠬ����. �롥�� �����ࠬ���." ).
            RETURN NO-APPLY.
         END.

         vKodOpVal = pick-value NO-ERROR.
         vKodOpVal:SCREEN-VALUE = pick-value.

      END.

      RETURN NO-APPLY.
   END.

END.



ON "ENTER" OF FRAME frm01 ANYWHERE 
DO:
    APPLY "TAB" TO SELF. 
END.

ON "GO" OF FRAME frm01 ANYWHERE 
DO:
   ASSIGN
     vKodOpVal 
  .
  IF NOT CAN-FIND(FIRST code WHERE code.class = "��������117" AND code.parent <> "��������117"  AND code.code  = vKodOpVal ) THEN
  DO:
     RUN Fill-SysMes ("", "", "-1", "��������� �����䨪��� ��������117 � ����� " + vKodOpVal ).
     APPLY "Entry" TO vKodOpVal  IN FRAME frm01.
     RETURN NO-APPLY.
  END.
END.



DO TRANSACTION
  ON ERROR  UNDO, RETRY 
  ON ENDKEY UNDO, RETURN 
WITH FRAME frm01 :
   PAUSE 0.
   UPDATE 
     vKodOpVal
   .
END.
	

HIDE FRAME frm01 NO-PAUSE.


IF NOT ( KEYFUNC(LASTKEY) = "GO" OR KEYFUNC(LASTKEY) = "RETURN") THEN 
  LEAVE.




/* =========================   ����������   ================================= */
{setdest.i}

FOR EACH tt,
FIRST op WHERE RECID(op) EQ tt.id 
NO-LOCK:

  vKolOpEntry = 0 .
  vAllAmt = 0 .

  FOR EACH  op-entry OF op  
  NO-LOCK:
	vKolOpEntry = vKolOpEntry + 1 .
	vAllAmt = ( IF op-entry.currency = "" THEN op-entry.amt-rub ELSE op-entry.amt-cur ) + vAllAmt .
  END.

  IF vKolOpEntry > 1 THEN
  DO:
	MESSAGE "���㬥�� �" op.doc-num " ������஢�����. �ॡ���� ��筮� ���� ४�����!" VIEW-AS ALERT-BOX.
	PUT UNFORM "���㬥�� " op.doc-num FORMAT "X(12)" " ������஢�����. �ॡ���� ��筮� ���� ४�����!" SKIP.
	NEXT.
  END.

  vDRValue = vKodOpVal + ",," + STRING(vAllAmt) + ",0,," + STRING(vAllAmt) + ",1,1,�," .


	/* ������ �஢�ઠ ���祭�� ४�����. */
  RUN CheckFullFieldValue IN h_xclass (
     op.class-code,		/* ��� �����. */
     "��������117",		/* ��� ४�����. */
     op.op,			/* �����䨪��� ��ꥪ�. */
     vDRValue			/* ���祭�� ४�����. */
  ).
  IF RETURN-VALUE NE "" THEN 
  DO:
	RUN Fill-SysMes ("", "", "-1", RETURN-VALUE + " ��室�� �� ��楤���." ).
	RETURN .
  END.


  UpdateSigns("op", STRING(op.op), "��������117", vDRValue, ?) NO-ERROR .

  IF ERROR-STATUS:ERROR  THEN
  DO:
	MESSAGE "�� ���㬥�� �" op.doc-num " �ॡ���� ��筮� ���� ४�����!" VIEW-AS ALERT-BOX.
	PUT UNFORM "�� ���㬥�� �" op.doc-num FORMAT "X(12)" " �ॡ���� ��筮� ���� ४�����!" SKIP.
	NEXT.
  END.

END.

{preview.i}

MESSAGE "��楤�� �����祭�." VIEW-AS ALERT-BOX.

{intrface.del}
