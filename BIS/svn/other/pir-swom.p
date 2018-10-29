{pirsavelog.p}

/* ------------------------------------------------------
File          : $RCSfile: pir-swom.p,v $ $Revision: 1.2 $ $Date: 2007-10-18 07:42:21 $
Copyright     : ��� �� "�p������������"
�����祭��    : ��楤�� ���� ॥��� �ਭ�⮩ ����筮��.
��稭�		    : � ��ᮢ�� ��楤�� �ந�室�� ࠧ������� ���㬥�� �� ��
��ࠬ����     : iRecOp - ��뫪� �� 㤠�塞�� ������ op-entry
����         : $Author: anisimov $ 

----------------------------------------------------- */
{globals.i}
{tmprecid.def}
{pp-uni.var}
{flt-val.i}

{get-bankname.i}

DEFINE VARIABLE mNumb    AS   INTEGER                  NO-UNDO.
DEFINE VARIABLE mAmt     LIKE op-entry.amt-rub         NO-UNDO.
DEFINE VARIABLE mAmtS    LIKE op-entry.amt-rub         NO-UNDO.
DEFINE VARIABLE mDetails AS   CHARACTER EXTENT 3       NO-UNDO.
DEFINE VARIABLE mDate    AS   CHARACTER FORMAT "x(29)" NO-UNDO. 
DEFINE VARIABLE mAmtStr  AS   CHARACTER EXTENT 3       NO-UNDO.
DEFINE VARIABLE mStrTMP1 AS   CHARACTER                NO-UNDO.
DEFINE VARIABLE mStrTMP2 AS   CHARACTER                NO-UNDO.

{strtout3.i}
mDate = STRING( CAPS({term2str DATE(GetFltVal('op-date1')) DATE(GetFltVal('op-date2')) YES}), "x(30)" ).

PUT UNFORMATTED cBankName skip(1).
PUT UNFORMATTED "�������樮��� ����� 㯮�����祭���� ����� : 2655" skip.
PUT UNFORMATTED "���� ����樮���� ����� : 121099, �.��᪢�, �����᪨� �-� �.3 ���.1" skip(1).
PUT UNFORMATTED "                           ������ �������� �������� ����������" skip.
PUT UNFORMATTED "           ��� ������������� �������� �������� ������� �� ��������� ����������� ����" skip.
PUT UNFORMATTED "                             ��� �������� ����������� �����" skip.
PUT UNFORMATTED "                                 �� " mDate skip(1). 
                             

ASSIGN
   mNumb = 0
   mAmt  = 0
.
PUT UNFORMATTED "������������������������������������������������������������������������������������������������Ŀ" skip.
PUT UNFORMATTED "�      �           ����⥫�          �  �㬬� ��ॢ��� �         ������������ ����樨          �" skip.
PUT UNFORMATTED "������������������������������������������������������������������������������������������������Ĵ" skip.

ASSIGN
   mAmt  = 0
   mAmtS = 0
   mNumb = 1
.

FOR EACH tmprecid,
   EACH op WHERE RECID(op) EQ tmprecid.id NO-LOCK,
   EACH op-entry OF op NO-LOCK BREAK BY op.op BY op-entry.acct-db BY op-entry.acct-cr:

   ASSIGN
      mAmt  = mAmt  + op-entry.amt-rub
      mAmtS = mAmtS + op-entry.amt-rub
   .

   IF FIRST-OF(op.op) THEN
   DO:
      mDetails[1] = op.details.
      mDetails[2] = "".
      mDetails[3] = "".
      {wordwrap.i &s=mDetails &l=40 &n=3}
   END.

   IF LAST-OF(op-entry.acct-cr) THEN
   DO:

    FIND FIRST op-bank of op no-lock no-error.
    	IF avail op-bank then 
	do:
           PlName[1] = op.name-ben.
           PoName[1] = GetXattrValueEx("op",string(op.op),"name-rec","").
        end.
	ELSE 
	do:
	   PlName[1] = GetXattrValueEx("op",string(op.op),"name-send","").
           PoName[1] = op.name-ben.
        end.
      IF  PlName[1] = "" then
     DO:
      FIND FIRST acct WHERE acct.acct EQ op-entry.acct-db 
         NO-LOCK NO-ERROR.

      IF AVAILABLE acct THEN
      DO:
         
         IF acct.details NE ? AND acct.details NE "" THEN
         DO:
            PlName[1] = acct.details.
         END.
         ELSE
         DO:
            {getcust.i &name=PlName &offinn=YES &offsign=YES}

            IF PlName[1] EQ ? THEN 
               PlName[1] = "".

            IF PlName[2] EQ ? THEN 
               PlName[2] = "".
            PlName[1] = TRIM(PlName[1] + " " + PlName[2]).
         END.
      END.
     END. 

    IF PoName[1] = "" then
    DO:
      FIND FIRST acct WHERE acct.acct EQ op-entry.acct-cr 
         NO-LOCK NO-ERROR.

      IF AVAILABLE acct THEN
      DO:
         
         IF acct.details NE ? AND acct.details NE "" THEN
         DO:
            PoName[1] = acct.details.
         END.
         ELSE
         DO:
            {getcust.i &name=PoName &offinn=YES &offsign=YES}

            IF PoName[1] EQ ? THEN 
               PoName[1] = "".

            IF PoName[2] EQ ? THEN 
               PoName[2] = "".
            PoName[1] = TRIM(PoName[1] + " " + PoName[2]).
         END.
      END.
     END. 
      /*{wordwrap.i &s=PoName &l=34 &n=2}*/
      PUT UNFORMATTED "�" 
                      string(mNumb) FORMAT "x(6)" "�" 
                      PoName[1] FORMAT "x(30)" "�" 
                      mAmt FORMAT ">>,>>>,>>>,>>9.99" "�" 
                      mDetails[1]      FORMAT "x(40)" "�" 
                      SKIP.
      IF LENGTH(mDetails[2]) > 0 THEN                
      PUT UNFORMATTED "�      �" 
                      FORMAT "x(38)" "�" 
                      "                 �" 
                      mDetails[2]      FORMAT "x(40)" "�" 
                      SKIP.
      IF LENGTH(mDetails[3]) > 0 THEN                 
      PUT UNFORMATTED "�      �" 
                      FORMAT "x(38)" "�" 
                      "                 �" 
                      mDetails[3]      FORMAT "x(40)" "�" 
                      SKIP.
                      
      ASSIGN
         mAmt  = 0
         mNumb = mNumb + 1
      .
   END.

END.

PUT UNFORMATTED "��������������������������������������������������������������������������������������������������" skip(1).
PUT UNFORMATTED  " �⮣� �� ���� �� ॥����" skip.
PUT UNFORMATTED  " ���-�� ���㬥�⮢      "  string(mNumb - 1) FORMAT "x(6)"  "�� ����� �㬬�" mAmtS FORMAT ">,>>>,>>>,>>>,>>9.99" skip.

RUN x-amtstr.p (mAmtS, '', YES, YES,
                OUTPUT mStrTMP1, OUTPUT mStrTMP2).
mAmtStr = mStrTMP1 + ' ' + mStrTMP2.
{wordwrap.i &s=mAmtStr &n=3 &l=80}
PUT UNFORMATTED  " " mAmtStr[1]  SKIP(1).
IF LENGTH(mAmtStr[2]) > 0 THEN
   PUT UNFORMATTED  "        "  mAmtStr[2]  SKIP.

IF LENGTH(mAmtStr[3]) > 0 THEN
   PUT UNFORMATTED  "        "  mAmtStr[3]  SKIP.

PUT UNFORMATTED SKIP(1).
PUT UNFORMATTED "���ᮢ� ࠡ�⭨� _____________________" SKIP.
{endout3.i}
