{pirsavelog.p}

/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2004 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: 
      Comment: ���� ���ᮢ �� ����筮� �����
   Parameters:
         Uses:
      Used by:
      Created: 
     Modified: 
*/

{globals.i}

{intrface.get instrum}
{intrface.get rights}

DEFINE VARIABLE mBegDate AS DATE      NO-UNDO. /* ��� ���� */

DEFINE VARIABLE mEndDate AS DATE      NO-UNDO. /* ��� ���� */
DEFINE VARIABLE mClass   AS CHARACTER NO-UNDO. /* ��� ������ */
DEFINE VARIABLE mPokVal  AS DECIMAL NO-UNDO.
DEFINE VARIABLE mPrVal   AS DECIMAL NO-UNDO.

DEFINE VARIABLE mTable   AS CHARACTER NO-UNDO.
DEFINE VARIABLE mField   AS CHARACTER NO-UNDO.
DEFINE VARIABLE mUser    AS CHARACTER NO-UNDO.
DEFINE VARIABLE mDetails AS LOGICAL   NO-UNDO.
DEFINE VARIABLE mTmp     AS CHARACTER NO-UNDO.
DEFINE VARIABLE mNum     AS INTEGER   NO-UNDO.

DEFINE NEW SHARED VARIABLE list-id AS CHARACTER NO-UNDO.

DEFINE NEW GLOBAL SHARED TEMP-TABLE txattr NO-UNDO
   FIELD record AS RECID. /* ����ন� recid ४����⮢ */

DEFINE NEW GLOBAL SHARED TEMP-TABLE tclass NO-UNDO
   FIELD record AS RECID.

DEFINE NEW GLOBAL SHARED TEMP-TABLE tmethod NO-UNDO
   FIELD record AS RECID.


{empty txattr}

ASSIGN

   mEndDate = gend-date
   mClass   = "840"
   mPokVal  = FindRateSimple("������",mClass, mEndDate)
   mPrVal   = FindRateSimple("�����",mClass, mEndDate)
.

FORM
   mEndDate
      FORMAT "99/99/9999"
      LABEL  "���"  
      HELP   "��� ����� ���ᮢ"
   mClass
      FORMAT "x(3)" VIEW-AS FILL-IN SIZE 3 by 1
      LABEL  "�����"  
      HELP   "��� ������"
   mPokVal
      FORMAT "99.9999" 
      LABEL  "���� ���㯪�"  
      HELP   "���� ���㯪� ������ �� ����筮�� �����"
   mPrVal
      FORMAT "99.9999" 
      LABEL  "���� �த���"  
      HELP   "���� �த��� ������ �� ����筮�� �����"
WITH FRAME frParam 1 COL OVERLAY CENTERED ROW 10 TITLE "[ ������� ���� ]".

ON F1 OF mEndDate DO:
   RUN calend.p.
   IF    (   LASTKEY EQ 13 
          OR LASTKEY EQ 10) 
      AND pick-value NE ?
   THEN FRAME-VALUE = pick-value.
   RETURN NO-APPLY.
END.


ON LEAVE OF mClass do:
      mClass = input mClass.
/*      message mClass. pause.*/
      DISP  mClass @ mClass
      FindRateSimple("������",mClass, mEndDate) @ mPokVal 
      FindRateSimple("�����", mClass, mEndDate) @ mPrVal 
      WITH FRAME frparam.
END.


ON F1 OF mClass DO:
   DO TRANSACTION:
      RUN currency.p ("����",4).
   END.
   IF     LASTKEY EQ 10 
      AND pick-value NE ?
   THEN do:
	DISPLAY pick-value @ mClass  /* WITH FRAME frParam. */
	        FindRateSimple("������",pick-value, mEndDate) @ mPokVal 
                FindRateSimple("�����", pick-value, mEndDate) @ mPrVal 
                with frame frParam.
        end.
  RETURN NO-APPLY.
END.



PAUSE 0.

UPDATE
   mEndDate
   mClass
   mPokVal
   mPrVal
WITH FRAME frParam.

HIDE FRAME frParam NO-PAUSE.

IF NOT (   KEYFUNC(LASTKEY) EQ "GO" 
        OR KEYFUNC(LASTKEY) EQ "RETURN") 
THEN LEAVE. 


     IF mPokVal  ne 0.0 then
	DO:
         RUN UpdateRate IN h_instrum (
                "currency",
                "������",
	        mClass,
		mEndDate,
		mPokVal,
		1.0 ,
		YES
		).
        END.		
     IF mPrVal  ne 0.0 then
	DO:
         RUN UpdateRate IN h_instrum (
                "currency",
                "�����",
	        mClass,
		mEndDate,
		mPrVal,
		1.0 ,
		YES
		).
        END.	
		
/*	CREATE instr-rate.
	 ASSIGN
	   instr-rate.instr-cat = "currency"
           instr-rate.rate-type = "������"
	   instr-rate.instr-code = mClass
	   instr-rate.since = mEndDate
           instr-rate.rate-instr = mPokVal
	   instr-rate.per = 1.0 .
*/		

    

MESSAGE "���� ���ᮢ �����祭."
   VIEW-AS ALERT-BOX INFO BUTTONS OK.
   
