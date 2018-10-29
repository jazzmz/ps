/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2005 ��� "������᪨� ���ଠ樮��� ��⥬�"
1     Filename: SELLPRN.P
      Comment: ����� ����� �த��
   Parameters:
         Uses:
      Used by:
      Created: 21.02.2005 Dasu 0041882
*/
{globals.i}
{intrface.get xclass }
{intrface.get tmess }

DEF VAR mStrOfList AS INT64    NO-UNDO INIT   29.   /* ����� ��ப� �� ���� */
DEF VAR mAdvance   AS LOGICAL    NO-UNDO.
def var bdlVal as CHAR EXTENT 9 NO-UNDO.  

def var mSurrOp as char no-undo.
def var mI as INT no-undo.

DEFINE VAR temp-amt-rub     AS DEC NO-UNDO.     /*�⮨�����*/
DEFINE VAR temp-amt-rub-nds AS DEC NO-UNDO. /*�⮨����� ��� ���*/
DEFINE VAR temp-ao          as LOG NO-UNDO.


{bookprn-new.i }


PROCEDURE Sign-Prn.
/*   /*������*/
   &UNDEFINE signatur_i
   {signatur.i
      &stream="STREAM sfact"}           */

PUT STREAM sfact UNFORMATTED
"�㪮����⥫� �࣠����樨                          ������� �.�.       " skip
"��� ���� 㯮�����祭��� ���   ___________   _______________________ " skip
"                                 (�������)           (�.�.�.)        " skip
"�������㠫�� �।�ਭ���⥫� ___________   _____________________   " skip
"                                 (�������)          (�.�.�.)         " skip
"��������� ᢨ��⥫��⢠ � ���㤠��⢥����                            " skip
"ॣ����樨 �������㠫쭮�� �।�ਭ���⥫�  ______________________  " skip(2)

"--------------------------------" skip
"<*> �� �����襭�� ���⮢ �� ⮢�ࠬ (ࠡ�⠬, ��㣠�), ���㦥��� (�믮������, ��������) �� 1 ﭢ��� 2004 �." skip.


END PROCEDURE.
PUT STREAM sfact UNFORMATTED
    PADL("�ਫ������ N 5",220) SKIP
    PADL("� ���⠭������� �ࠢ�⥫��⢠",220) SKIP
    PADL("���ᨩ᪮� �����樨",220) SKIP
    PADL("�� 26.12.11  � 1137",220) SKIP
    PADL("��������    ����",220) SKIP
    SKIP(2).

/*����� �����*/
PUT STREAM sfact UNFORMATTED
   FILL(" ",60) + "����� ������" SKIP(2)
   FILL(" ",40) + "�த���� " + STRING(mBuyer,"x(230)") SKIP
   FILL(" ",40) + "         " + FILL("�",LENGTH(mBuyer)) SKIP(0)
   FILL(" ",40) + "�����䨪�樮��� ����� � ��� ��稭� ���⠭���� "  SKIP
   FILL(" ",40) + "�� ��� ���������⥫�騪�-�த��� " + TRIM(STRING(mINN)) + "/" + STRING(mKPP,"x(15)") SKIP
   FILL(" ",40) + "                                   " + FILL("�",20) SKIP(0)
   FILL(" ",40) + "�த��� �� ��ਮ� � " + string(bDB.Beg-Date,"99/99/9999") + " �� " + STRING(bDB.end-Date,"99/99/9999") SKIP
   FILL(" ",40) + "                    ����������    ����������" SKIP(1)
.
/*����� ��������*/
PUT STREAM sfact UNFORMATTED
   "������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ŀ" SKIP
   "� ��� � �����  � ����� � ���  � ����� � ���  � ����� � ���  �    ������������     �    ���     �    ���     � ���   � �⮨�����     �                                          � ⮬ �᫥                                                              �" SKIP
   "� ���-䠪���� � ��ࠢ�����   � ���४��-   � ��ࠢ�����   �     ���㯠⥫�      � ���㯠⥫� � ���㯠⥫� �������  � �த��,       �������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
   "�   �த���    � ���-䠪���� � ��筮��       � ���४��-   �                     �            �            ����-  � ������ ���,- �                            �⮨����� �த��, ���������� ������� �� �⠢��                           ��⮨�����    �" SKIP
   "�               � �த���      � ���-䠪���� � ��筮��       �                     �            �            �䠪���� � �ᥣ�         �����������������������������������������������������������������������������������������������������Ĵ�த��,      �" SKIP
   "�               �               � �த���      � ���-䠪���� �                     �            �            ��த��栳               �         18 ��業⮢          �       10 ��業⮢        � 0 ��業⮢ �       20 ��業⮢*       ��᢮���������" SKIP
   "�               �               �               � �த���      �                     �            �            �        �               �����������������������������������������������������������������������������������������������������Ĵ�� ������    �" SKIP
   "�               �               �               �               �                     �            �            �        �               � �⮨�����     �  �㬬� ���    �  �⮨�����  � �㬬� ���   �             �  �⮨�����  � �㬬� ���   �             �" SKIP
   "�               �               �               �               �                     �            �            �        �               �  �த��       �               �   �த��    �             �             �   �த��    �             �             �" SKIP
   "�               �               �               �               �                     �            �            �        �               �  ��� ���      �               �   ��� ���   �             �             �   ��� ���   �             �             �" SKIP
   "������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
   "�     (1)       �     (1�)      �     (1�)      �     (1�)      �         (2)         �    (3)     �    (3�)    �  (3�)  �      (4)      �      (5�)     �      (5�)     �     (6�)    �     (6�)    �     (7)     �     (8�)    �     (8�)    �     (9)     �" SKIP
   "������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
.
def var ispr as char no-undo.
def var mKorr1 as char no-undo.
def var mKorr2 as char no-undo.
def var mKorr3 as char no-undo.
def buffer sf for loan .
def buffer t1 for term-obl.
def buffer t2 for term-obl.
def var amt1 as dec no-undo.
def var nds1 as dec no-undo.
def var amt2 as dec no-undo.
def var nds2 as dec no-undo.
def var tot1 as dec no-undo.
def var tot2 as dec no-undo.
def buffer b_dl for bdl.
/*������ �� �������*/
FOR EACH bDL
   WHERE bDL.Data-ID EQ INT64(iDataBlock)
   NO-LOCK,
   first sf where sf.contract = "sf-out" and sf.cont-code = bDl.sf no-lock 
   BREAK BY bDl.Data-ID
         BY sf.doc-num
	 BY bDl.Date2
/*         BY bDl.Date1*/

         :

/*

   IF ( NUM-ENTRIES(bDL.Txt,"~n") < 9 OR ENTRY(9,bDL.Txt,"~n") <> "��ࠢ") AND
      /* ��� 13 ���� � ���⮩,  ��� ��� ��� */
      ( NUM-ENTRIES(bDL.Txt,"~n") < 13  OR
       ( NUM-ENTRIES(bDL.Txt,"~n") >= 13  AND  ENTRY(13,bDL.Txt,"~n") EQ "" ))
      THEN
*/
   DO:

      ASSIGN
         mStrNum     = mStrNum + 1
         mNamePostav = SplitStr(ENTRY(1,bDL.Txt,"~n"),
                                21,
                                "~n")

         mNums       = SplitStr(ENTRY(6,bDL.Txt,"~n") + " "
                              + ENTRY(8,bDL.Txt,"~n"),
                                15,
                                "~n")
         mAmt        = SplitStr(STRING(bDL.Val[11],">>>>,>>>,>>9.99") + " "
                              + ENTRY(7,bDL.Txt,"~n"),
                                15,
                                "~n")
         mAdvance    = ENTRY(4,bDL.Txt,"~n") EQ "�����"
      .
/*      find first sf where sf.contract = "sf-out" and sf.cont-code = bDl.sf no-lock no-error.*/
      ispr = GetXattrValue("loan","sf-out," + bDl.sf,"��ࠢ").
      
      find loan where loan.contract = entry(1,ispr) and loan.cont-code = entry(2,ispr) no-lock no-error.
      mKorr1 = "".
      mKorr2 = "".
      mKorr3 = "".
      if avail loan then
      do:

         mNums       = SplitStr(string(loan.conf-date,"99/99/99") + " " + loan.doc-num,15,"~n").
         mKorr1      = SplitStr(GetXattrValueEx("loan",sf.contract + "," + sf.cont-code,"�����⊮��",""),15,"~n").
         mKorr2      = SplitStr(string(sf.conf-date,"99/99/99") + " " + sf.doc-num,15,"~n").
         if loan.loan-status = "���㫨�" then
         do:
            ispr = GetXattrValue("loan",sf.contract + "," + sf.cont-code,"��ࠢ").
            mKorr3      = SplitStr(GetXattrValueEx("loan",ispr,"�����⊮��",""),15,"~n").
         end.

         for each t1 of sf no-lock:
             accumulate t1.amount-of-payment (total).
             accumulate t1.int-amt (total).
         end.
         for each t2 of loan  no-lock:
             accumulate t2.amount-of-payment (total).
             accumulate t2.int-amt (total).
         end.
	         bDL.Val[11] = (accum total t1.amount-of-payment) + (accum total t1.int-amt) - (accum total t2.amount-of-payment) - (accum total t2.int-amt).
         mAmt        = SplitStr(STRING(bDL.Val[11],"->>>,>>>,>>9.99") + " "
                              + ENTRY(7,bDL.Txt,"~n"),
                                15,
                                "~n").
         for each t1 of sf where t1.rate = 18 no-lock:
             accumulate t1.amount-of-payment (total).
             accumulate t1.int-amt (total).
         end.
         for each t2 of loan where t2.rate = 18  no-lock:
             accumulate t2.amount-of-payment (total).
             accumulate t2.int-amt (total).
         end.

         bDL.Val[1] = (accum total t1.amount-of-payment) - (accum total t2.amount-of-payment).
         bDL.Val[2] = (accum total t1.int-amt) - (accum total t2.int-amt).

         for each t1 of sf where t1.rate = 10 no-lock:
             accumulate t1.amount-of-payment (total).
             accumulate t1.int-amt (total).
         end.
         for each t2 of loan where t2.rate = 10  no-lock:
             accumulate t2.amount-of-payment (total).
             accumulate t2.int-amt (total).
         end.
         bDL.Val[3] = (accum total t1.amount-of-payment) - (accum total t2.amount-of-payment).
         bDL.Val[4] = (accum total t1.int-amt) - (accum total t2.int-amt).

         for each t1 of sf where t1.rate = 20 no-lock:
             accumulate t1.amount-of-payment (total).
             accumulate t1.int-amt (total).
         end.
         for each t2 of loan where t2.rate = 20  no-lock:
             accumulate t2.amount-of-payment (total).
             accumulate t2.int-amt (total).
         end.
         bDL.Val[7] = (accum total t1.amount-of-payment) - (accum total t2.amount-of-payment).
         bDL.Val[8] = (accum total t1.int-amt) - (accum total t2.int-amt).

         for each t1 of sf where t1.rate = 0 no-lock:
             accumulate t1.amount-of-payment (total).
             accumulate t1.int-amt (total).
         end.
         for each t2 of loan where t2.rate = 0  no-lock:
             accumulate t2.amount-of-payment (total).
             accumulate t2.int-amt (total).
         end.
         bDL.Val[9] = (accum total t1.amount-of-payment) - (accum total t2.amount-of-payment).
      end.
      /*  
      else
      do:

         temp-ao = false.
         temp-amt-rub-nds = 0.


         for each t1 of sf where t1.rate = 18 no-lock:
             accumulate t1.amount-of-payment (total).
             accumulate t1.int-amt (total).
  if mAdvance then do:
                 DO mI=1 TO NUM-ENTRIES(mSurrOp,";"):

                       
         	 if Entry(2,(GetXAttrValueEx("op", ENTRY(1,ENTRY(mI,mSurrOp,";")), "PIRSFInfo", ""))) = '�/�' /*�᫨ ���㬥�� �� ����ᮢ�� ����� � ᬮ�ਬ */
    	            then do:
 	              	   if DEC(GetXAttrValueEx("op", ENTRY(1,ENTRY(mI,mSurrOp,";")), "PIRSFAmount", "")) = t1.amt-rub then temp-amt-rub-nds = temp-amt-rub-nds + t1.amount-of-payment.
/*                      MESSAGE sf.doc-num bDL.Val[1] (accum total t1.amount-of-payment) (accum total t1.int-amt) VIEW-AS ALERT-BOX.*/
 	            end. 
 	            temp-ao = true.
    end.             	
            END.



        END.

         bDL.Val[1] = (accum total t1.amount-of-payment) - (accum total t1.int-amt) - temp-amt-rub-nds.





      end.
      */

 temp-ao = false.
 mSurrOp = "".
 temp-amt-rub-nds = 0.

 if mAdvance then do:
      mSurrOp = GetLinks(sf.class-code,             /* ID �����     */
                sf.contract + "," + sf.cont-code, /* ID(c��ண��) ��ꥪ�   */
                ?,                                    /* ���ࠢ����� �裡: s | t | ?         */
                "sf-op-pay",                          /* ���᮪ ����� ������ � CAN-DO �ଠ� */
                ";",                                  /* �������⥫� १������饣� ᯨ᪠   */
                ?).

         If mSurrOp <> "" and mSurrOp <> ? then do:
                 DO mI=1 TO NUM-ENTRIES(mSurrOp,";"):
                  
         	   if Entry(2,(GetXAttrValueEx("op", ENTRY(1,ENTRY(mI,mSurrOp,";")), "PIRSFInfo", ""))) = '�/�' /*�᫨ ���㬥�� �� ����ᮢ�� ����� � ᬮ�ਬ */
    	            then do:
    	                   find first op-entry where op-entry.op = INT(ENTRY(1,ENTRY(mI,mSurrOp,";"))) NO-LOCK NO-ERROR.
 	              	   temp-amt-rub-nds = temp-amt-rub-nds + op-entry.amt-rub.
                           temp-ao = true.

 	            end. 
 	        end.   
	       end.          	
     end.
   
     bDL.VAL[1] = bDL.VAL[1] - temp-amt-rub-nds.

     if bDL.VAL[1] < 0 then message sf.doc-num mSurrOp VIEW-AS ALERT-BOX.


/*
message sf.doc-num 
bDL.Val[6] bDL.Val[7] bDL.Val[8]
view-as alert-box.
*/ 

      if bDL.VAL[1] = 0 then bdlval[1] = "               ". else bdlval[1] = STRING(bDL.Val[1],"->>>,>>>,>>9.99").

      if bDL.VAL[2] = 0 then bdlval[2] = "               ". else bdlval[2] = STRING(bDL.Val[2],"->>>,>>>,>>9.99").

      if bDL.VAL[3] = 0 then bdlval[3] = "             ". else bdlval[3] = STRING(bDL.Val[3],"->,>>>,>>9.99").

      if bDL.VAL[4] = 0 then bdlval[4] = "             ". else bdlval[4] = STRING(bDL.Val[4],"->,>>>,>>9.99").

      if bDL.VAL[5] = 0 then bdlval[5] = "             ". else bdlval[5] = STRING(bDL.Val[5],"->,>>>,>>9.99").
/*      if bDL.VAL[6] = 0 then bdlval[6] = "             ". else bdlval[6] = STRING(bDL.Val[6],"->,>>>,>>9.99").*/

      if bDL.VAL[7] = 0 then bdlval[7] = "             ". else bdlval[7] = STRING(bDL.Val[7],"->,>>>,>>9.99").

      if bDL.VAL[8] = 0 then bdlval[8] = "             ".   else bdlval[8] = STRING(bDL.Val[8],"->,>>>,>>9.99").

      if bDL.VAL[9] = 0 then bdlval[9] = "             ". else bdlval[9] = STRING(bDL.Val[9],"->,>>>,>>9.99").

      IF mAdvance and not temp-ao THEN ASSIGN
         bDL.Val[1] = 0
         bDL.Val[3] = 0
      .
      PUT STREAM sfact UNFORMATTED
         "�" +
         STRING(ENTRY(1,mNums,"~n"),"x(15)") + "�" +

         STRING(ENTRY(1,mKorr1,"~n"),"x(15)") + "�" +
         STRING(ENTRY(1,mKorr2,"~n"),"x(15)") + "�" +
         STRING(ENTRY(1,mKorr3,"~n"),"x(15)") + "�" +


         STRING(ENTRY(1,mNamePostav,"~n"),"x(21)") + "�" +
         (if TRIM(REPLACE(STRING(ENTRY(2,bDL.Txt,"~n"),"x(12)"),"0"," ")) <> "" THEN 
         STRING(ENTRY(2,bDL.Txt,"~n"),"x(12)") else
         FILL(" ",12))
         + "�" +
         (if TRIM(REPLACE(STRING(ENTRY(3,bDL.Txt,"~n"),"x(12)"),"0"," ")) <> "" THEN 
         STRING(ENTRY(3,bDL.Txt,"~n"),"x(12)") else
         FILL(" ",12)) + "�" +
         STRING(bDL.Sym2,"x(8)") + "�" +
         STRING(ENTRY(1,mAmt,"~n"),"x(15)") + "�" +

         (IF mAdvance and not temp-ao
          THEN (" " + FILL(" ",13) + " ")
          ELSE 
          (bDLVal[1])) + "�" +
         (bDLVal[2]) + "�" +

         (IF mAdvance
          THEN (" " + FILL(" ",11) + " ")
          ELSE 
          (bDLVal[3])) + "�" +
          (bDLVal[4]) + "�" +
          (bDLVal[5]) + "�" +
          (bDLVal[7]) + "�" +
          (bDLVal[8]) + "�" +
          (bDLVal[9]) + "�"
         SKIP
      .
      RUN CalcStrike(mStrOfList + 1, 63, NO, OUTPUT mStrOfList).

      IF MAX(NUM-ENTRIES(mNamePostav,"~n"),

             NUM-ENTRIES(mKorr1,"~n"),
             NUM-ENTRIES(mKorr2,"~n"),
             NUM-ENTRIES(mKorr3,"~n"),

             NUM-ENTRIES(mNums,"~n"),
             NUM-ENTRIES(mAmt,"~n")) GE 2
      THEN DO i = 2 TO MAX(NUM-ENTRIES(mNamePostav,"~n"),

                           NUM-ENTRIES(mKorr1,"~n"),
                           NUM-ENTRIES(mKorr2,"~n"),
                           NUM-ENTRIES(mKorr3,"~n"),

                           NUM-ENTRIES(mNums,"~n"),
                           NUM-ENTRIES(mAmt,"~n")):
         PUT STREAM sfact UNFORMATTED
            "�" +
            STRING((IF i LE NUM-ENTRIES(mNums,"~n")
                   THEN ENTRY(i,mNums,"~n")
                   ELSE " "),"x(15)") + "�" +


            STRING((IF i LE NUM-ENTRIES(mKorr1,"~n")
                   THEN ENTRY(i,mkorr1,"~n")
                   ELSE " "),"x(15)") + "�" +
            STRING((IF i LE NUM-ENTRIES(mKorr2,"~n")
                   THEN ENTRY(i,mkorr2,"~n")
                   ELSE " "),"x(15)") + "�" +
            STRING((IF i LE NUM-ENTRIES(mKorr3,"~n")
                   THEN ENTRY(i,mkorr3,"~n")
                   ELSE " "),"x(15)") + "�" +



            STRING((IF i LE NUM-ENTRIES(mNamePostav,"~n")
                   THEN ENTRY(i,mNamePostav,"~n")
                   ELSE " "),"x(21)") +
            "�            �            �        �" +
            STRING((IF i LE NUM-ENTRIES(mAmt,"~n")
                   THEN ENTRY(i,mAmt,"~n")
                   ELSE " "),"x(15)") +
            "�               �               �             �             �             �             �             �             �" SKIP
            SKIP
         .
         RUN CalcStrike(mStrOfList + 1, 63, NO, OUTPUT mStrOfList).
      END.

      ACCUMULATE bDL.Val[11] (TOTAL).
      ACCUMULATE bDL.Val[1] (TOTAL).
      ACCUMULATE bDL.Val[2] (TOTAL).
      ACCUMULATE bDL.Val[3] (TOTAL).
      ACCUMULATE bDL.Val[4] (TOTAL).
      ACCUMULATE bDL.Val[5] (TOTAL).
      ACCUMULATE bDL.Val[7] (TOTAL).
      ACCUMULATE bDL.Val[8] (TOTAL).
      ACCUMULATE bDL.Val[9] (TOTAL).

      IF NOT LAST-OF(bDl.Data-ID) THEN DO:
         PUT STREAM sfact UNFORMATTED
            "������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
         .
         RUN CalcStrike(mStrOfList + 1, 63, NO, OUTPUT mStrOfList).
      END.
   END.
END.
/*�����*/
PUT STREAM sfact UNFORMATTED
            "������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP.
RUN CalcStrike(mStrOfList + 1, 63, NO, OUTPUT mStrOfList).
PUT STREAM sfact UNFORMATTED
            "�                                                                                                                  �ᥣ�:�" +
   STRING((ACCUM TOTAL bDL.Val[11]),"->>>,>>>,>>9.99") + "�" +
   STRING((ACCUM TOTAL bDL.Val[1]),"->>>,>>>,>>9.99") + "�" +
   STRING((ACCUM TOTAL bDL.Val[2]),"->>>,>>>,>>9.99") + "�" +
   STRING((ACCUM TOTAL bDL.Val[3]),"->,>>>,>>9.99") + "�" +
   STRING((ACCUM TOTAL bDL.Val[4]),"->,>>>,>>9.99") + "�" +
   STRING((ACCUM TOTAL bDL.Val[5]),"->,>>>,>>9.99") + "�" +
   STRING((ACCUM TOTAL bDL.Val[7]),"->,>>>,>>9.99") + "�" +
   STRING((ACCUM TOTAL bDL.Val[8]),"->,>>>,>>9.99") + "�" +
   STRING((ACCUM TOTAL bDL.Val[9]),"->,>>>,>>9.99") + "�" SKIP.
RUN CalcStrike(mStrOfList + 1, 63, NO, OUTPUT mStrOfList).
PUT STREAM sfact UNFORMATTED
            "��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������" SKIP
.
RUN CalcStrike(mStrOfList + 1, 63, NO, OUTPUT mStrOfList).

IF printer.page-lines < mStrOfList + 14 THEN DO:
   RUN EndStrike(mStrOfList + 2, 63, YES, OUTPUT mStrOfList).
   RUN Sign-Prn.
/*   RUN EndStrike(mStrOfList + 15, 63, YES, OUTPUT mStrOfList). /* �������� ����� - ������ */*/
END.
ELSE DO:
   RUN Sign-Prn.
   RUN EndStrike(mStrOfList + 15, 63, YES, OUTPUT mStrOfList).
END.
/*
IF CAN-FIND(FIRST bDl WHERE entry(9,bDL.Txt,"~n") EQ "���㫨�") THEN
DO:
   pick-value = 'yes'. /* ��������� �� 㬮�砭�� */
   RUN Fill-SysMes IN h_tmess (
      "", "", "4",
      "������ ���㫨஢���� ���-䠪����?"
   ).
   IF pick-value EQ "yes" THEN
   DO:
      RUN SellAddPage(iDataBlock, PAGE-NUMBER(sfact)).
   END.
END.
*/
{preview.i &STREAM="STREAM sfact"}
{intrface.del}
