/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2005 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: BOOKPRN.I
      Comment: ����� ��� ����� ����� ���㯮� � ����� �த��.
               ��।���� ��६���� � ��� 蠯�� �����
   Parameters:
         Uses: 
      Used by:
      Created: 27.01.2005 Dasu 0041881
*/

  
{globals.i}
{intrface.get xclass}
{intrface.get instrum}
{intrface.get tparam}
{intrface.get axd}
{intrface.get asset}
{intrface.get strng }
  
  
DEF INPUT PARAM iDataBlock AS CHAR NO-UNDO.

DEF TEMP-TABLE tmpDataLine LIKE DataLine
   FIELD sf        AS CHARACTER
   FIELD Date1     AS DATE
   FIELD Date2     AS DATE
   FIELD isprav    AS CHARACTER /*����� (���㫨஢����� ��� ��ࠢ�⥫쭠�)*/
   FIELD cont-code AS CHARACTER /*����� ���-䠪����, ������ ��ࠢ���
                                 ������ ���-䠪���.*/  
   FIELD k1 AS CHARACTER
   FIELD k2 AS CHARACTER
   FIELD k3 AS CHARACTER
   FIELD nums AS CHARACTER
   INDEX dateprim Data-ID Date1 Date2
   INDEX isprav cont-code.

DEF BUFFER bDB       FOR DataBlock.
DEF BUFFER bDataLine FOR DataLine.
DEF BUFFER bDL       FOR tmpDataLine.

DEF VAR mBuyer      AS CHAR NO-UNDO.
DEF VAR mINN        AS CHAR NO-UNDO.
DEF VAR mKPP        AS CHAR NO-UNDO.
DEF VAR mAdrs       AS CHAR NO-UNDO.
                    
DEF VAR mStrNum     AS INT64  NO-UNDO.
DEF VAR mOutStr     AS CHAR NO-UNDO.
                    
DEF VAR i           AS INT64  NO-UNDO.
DEF VAR mNamePostav AS CHAR NO-UNDO.
DEF VAR mNums       AS CHAR NO-UNDO.
DEF VAR mBuhName    AS CHAR NO-UNDO.
DEF VAR mAmt        AS CHAR NO-UNDO.

DEFINE STREAM sfact.
{setdest.i &cols=99999 &STREAM="stream sfact"}

/*�饬 ���� ������ ��� ����祭�� ��� ��砫� � ����*/
FIND FIRST bDB WHERE bDB.Data-ID EQ INT64(IDATABLOCK)
   NO-LOCK NO-ERROR.

FIND FIRST branch WHERE branch.Branch-Id EQ bDB.Branch-Id NO-LOCK NO-ERROR.
IF AVAIL branch THEN mBuhName = branch.CFO-name.

/*����砥� ����� � ���㯠⥫� (����), ����� ������� �� ����஥��� ��ࠬ��஢*/
RUN SFAttribs_Buyer("",
                    "", 
                    bDB.Branch-Id,
                    OUTPUT mBuyer,
                    OUTPUT mAdrs,
                    OUTPUT mINN,
                    OUTPUT mKPP).

/*�����㥬 �� �६����� ⠡����, �� �� ᤥ���� �ࠢ����� ���஢�� �� ��⠬*/
{empty bDL}


IF     FGetSetting("�甁������",?,"") EQ "��"
   AND FGetSetting("�甏��ࠧ",?,"")  EQ "��" 
THEN
   mKPP  = GetXAttrValue("branch", bDB.Branch-Id, "���").
     
FOR EACH bDataLine WHERE 
         bDataLine.data-id = INT64(IDATABLOCK)
   NO-LOCK:
   CREATE bDL.
   BUFFER-COPY bDataLine TO bDL.
   ASSIGN
      bDL.Date1 = DATE(bDataLine.Sym1)
      bDL.Date2 = DATE(bDataLine.Sym2)
      bDL.sf    = Entry(11,bDataLine.txt,"~n")
   .
END.
/*����� �������⥫��� ���⮢ ����� ���㯮�*/
PROCEDURE BuyAddPage:

   DEFINE INPUT PARAMETER inDataBlock  AS CHARACTER NO-UNDO.
   DEFINE INPUT PARAMETER inPagenumber AS INT64     NO-UNDO. /*����� ��࠭���*/
   /*����� �����*/
   DEFINE VARIABLE iVal_m     AS DEC  NO-UNDO EXTENT 9. /*�� ���㫨஢��.*/
   DEFINE VARIABLE iVal   AS DECIMAL NO-UNDO EXTENT 9. /*�⮣� �� ���㫨஢��.
                                                         ���-䠪��ࠬ */ 
   DEFINE VARIABLE iVal_a AS DECIMAL NO-UNDO EXTENT 9. /*�⮣� �� ���㫨஢��.
                                                         ���-䠪��ࠬ */ 
   DEFINE VARIABLE iVal_d   AS DECIMAL NO-UNDO EXTENT 9. /*�⮣� �� ���-䠪��ࠬ � �� ������� */ 
   DEFINE VARIABLE ii       AS INT64   NO-UNDO.
   DEFINE VARIABLE vAdvance AS LOGICAL NO-UNDO.
   /*������ �⮣� ��� ���-䠪��� (�� ���㫨஢�����) */
   RUN CalcTotalsIn(inDataBlock, INPUT-OUTPUT iVal_m).
   
   PUT STREAM sfact UNFORMATTED
      FILL(" ",40)  + "�������������� ���� � ����� ������� �" + 
      STRING(inPagenumber) SKIP(3)
      "���㯠⥫� " + STRING(mBuyer,"x(35)")              SKIP
      "           " + FILL("�",35)                        SKIP(2)
      "�����䨪�樮��� ����� � ��� ��稭� ���⠭���� �� ��� ���������⥫�騪�-���㯠⥫� " + TRIM(STRING(mINN)) + "/" + STRING(mKPP,"x(15)") SKIP
      "                                                                                      " + FILL("�",35) SKIP(2)
      "�������� ��ਮ� (�����, ����⠫), ���, � ���஬ ��ॣ����஢�� ���-䠪��� �� ���ᥭ�� � ���� ��ࠢ�����: "
      term2str(bdb.Beg-Date,bdb.End-Date) SKIP
      "                                                                                                               ����������������" SKIP(2)
   
      "�������⥫�� ���� ��ଫ�� " STRING(TODAY,"99/99/9999") SKIP
       "                             ����������" SKIP(3)
   .
   /*����� ��������*/
   PUT STREAM sfact UNFORMATTED
      "���������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ŀ" SKIP
      "� � � ��� � �����  �  ���    �   ���   ������������� �த��栳 ��� �த��� � ��� �த��� �      ��࠭�     �   �ᥣ�     �                                        � ⮬ �᫥                                                            �" SKIP
      "�   � ���-䠪���� � ������   � �ਭ��� �                     �              �              �  �ந�宦�����  �  ���㯮�,   ���������������������������������������������������������������������������������������������������������������Ĵ" SKIP
      "��/��   �த���    � ���-   � �� ���  �                     �              �              �  ⮢��. �����  � ������ ��� �                 ���㯪�, ��������� ������� �� �⠢��                                           �  ���㯪�    �" SKIP
      "�   �               � 䠪����  � ⮢�஢  �                     �              �              �    ⠬�������   �             �������������������������������������������������������������������������������������������������Ĵ�᢮�������륳" SKIP
      "�   �               � �த��� � (ࠡ��,  �                     �              �              �    ������樨   �             �       18 ��業⮢        �       10 ��業⮢        � 0 ��業⮢ �       20 ��業⮢*       �  �� ������  �" SKIP   
      "�   �               �          �  ���), �                     �              �              �                 �             �������������������������������������������������������������������������������������������������Ĵ             �" SKIP
      "�   �               �          � ������- �                     �              �              �                 �             ��⮨����� ��-� �㬬� ���   ��⮨����� ��-� �㬬� ���   �             ��⮨����� ��-� �㬬� ���   �             �" SKIP
      "�   �               �          � ⢥����  �                     �              �              �                 �             ��㯪� ��� ����             ��㯪� ��� ����             �             ��㯪� ��� ����             �             �" SKIP
      "�   �               �          �   �ࠢ   �                     �              �              �                 �             �             �             �             �             �             �             �             �             �" SKIP
      "���������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
      "�(1)�      (2)      �    (3)   �   (4)    �         (5)         �      (5�)    �     (5�)     �       (6)       �     (7)     �     (8�)    �     (8�)    �     (9�)    �    (9�)     �     (10)    �    (11�)    �    (11�)    �     (12)    �" SKIP
      "���������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
   .
   /*������ �� �������*/
   /*�����*/
   PUT STREAM sfact UNFORMATTED
      "���������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
      "�                                                                                                         �����:�" + 
      STRING(iVal_m[1],">>,>>>,>>9.99") + "�" +
      STRING(iVal_m[2],">>,>>>,>>9.99") + "�" +
      STRING(iVal_m[3],">>,>>>,>>9.99") + "�" +
      STRING(iVal_m[4],">>,>>>,>>9.99") + "�" +
      STRING(iVal_m[5],">>,>>>,>>9.99") + "�" +
      STRING(iVal_m[6],">>,>>>,>>9.99") + "�" +
      STRING(iVal_m[7],">>,>>>,>>9.99") + "�" +
      STRING(iVal_m[8],">>,>>>,>>9.99") + "�" +
      STRING(iVal_m[9],">>,>>>,>>9.99") + "�" SKIP
      "���������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
   .
   mStrNum = 0.
   FOR EACH bDL WHERE bDL.Data-Id EQ INT64(INDATABLOCK)
   NO-LOCK,

   FIRST DataLine WHERE DataLine.Data-ID EQ bDL.Data-Id
                    AND DataLine.Sym1    EQ bDL.Sym1
                    AND DataLine.Sym2    EQ bDL.Sym2
                    AND DataLine.Sym3    EQ bDL.Sym3
                    AND DataLine.Sym4    EQ bDL.Sym4
   NO-LOCK
      BREAK BY DataLine.Data-ID:
      
      IF ENTRY(9,DataLine.Txt,"~n") EQ "���㫨�" THEN
      DO:
         
         ASSIGN
            mStrNum = mStrNum + 1.
            mNamePostav =  SplitStr(ENTRY(1,DataLine.Txt,"~n"),
                                          21,
                                          "~n").
   
            mNums       =  SplitStr(ENTRY(6,DataLine.Txt,"~n") + " " 
                                  + ENTRY(8,DataLine.Txt,"~n"),
                                          15,
                                          "~n").
      
            mAmt        =  SplitStr(STRING(DataLine.Val[11],">>,>>>,>>9.99") + " " 
                                  + ENTRY(7,DataLine.Txt,"~n"),
                                    13,
                                    "~n")       .
           vAdvance    = ENTRY(4,bDL.Txt,"~n") EQ "�����" 
         .
   
         PUT STREAM sfact UNFORMATTED
            "�" +
            STRING(mStrNum,"999") + "�" +
            STRING(ENTRY(1,mNums,"~n"),"x(15)") + "�" +
            STRING(DataLine.Sym2,"x(10)") + "�" +
            (IF vAdvance 
             THEN (" " + FILL("-",8) + " ")
             ELSE STRING(bDL.Sym1,"x(10)")) + "�" +
            STRING(ENTRY(1,mNamePostav,"~n"),"x(21)") + "�" +
            STRING(ENTRY(2,DataLine.Txt,"~n"),"x(14)") + "�" +
            STRING(ENTRY(3,DataLine.Txt,"~n"),"x(14)") + "�" +
            (IF vAdvance 
             THEN (" " + FILL("-",15) + " ")
             ELSE (STRING(ENTRY(4,bDL.Txt,"~n"),"x(10)") + " " + STRING(ENTRY(5,bDL.Txt,"~n"),"x(6)"))) + "�" +
            STRING(DEC(ENTRY(1,mAmt,"~n")),">>,>>>,>>9.99") + "�" +
            (IF vAdvance 
             THEN (" " + FILL("-",11) + " ")
             ELSE STRING(bDL.Val[1],">>,>>>,>>9.99")) + "�" +
            STRING(bDL.Val[2],">>,>>>,>>9.99") + "�" +
            (IF vAdvance 
             THEN (" " + FILL("-",11) + " ")
             ELSE STRING(bDL.Val[3],">>,>>>,>>9.99")) + "�" +
            STRING(DataLine.Val[4],">>,>>>,>>9.99") + "�" +
            STRING(DataLine.Val[5],">>,>>>,>>9.99") + "�" +
            STRING(DataLine.Val[7],">>,>>>,>>9.99") + "�" +
            STRING(DataLine.Val[8],">>,>>>,>>9.99") + "�" +
            STRING(DataLine.Val[9],">>,>>>,>>9.99") + "�"
            SKIP
         .
         IF MAX(NUM-ENTRIES(mNamePostav,"~n"),
            NUM-ENTRIES(mNums,"~n"),
            NUM-ENTRIES(mAmt,"~n")) GE 2 
         THEN DO i = 2 TO MAX(NUM-ENTRIES(mNamePostav,"~n"),
                              NUM-ENTRIES(mNums,"~n"),
                              NUM-ENTRIES(mAmt,"~n")):
            PUT STREAM sfact UNFORMATTED
               "�" +
               STRING("   ") + "�" +
               STRING((IF i LE NUM-ENTRIES(mNums,"~n") 
                                THEN ENTRY(i,mNums,"~n") 
                                ELSE " "),"x(15)") + "�" +
               STRING(" ","x(10)") + "�" +
               STRING(" ","x(10)") + "�" +
               STRING((IF i LE NUM-ENTRIES(mNamePostav,"~n") 
                                THEN ENTRY(i,mNamePostav,"~n") 
                                ELSE " "),"x(21)") + 
               "�              �              �                 �" + 
               STRING((IF i LE NUM-ENTRIES(mAmt,"~n") 
                         THEN ENTRY(i,mAmt,"~n") 
                         ELSE " "),"x(13)") +
               "�             �             �             �             �             �             �             �             �"                  
               SKIP
            .
         END.
         ACCUMULATE DataLine.Val[11] (TOTAL).
         ACCUMULATE DataLine.Val[1] (TOTAL).
         ACCUMULATE DataLine.Val[2] (TOTAL).
         ACCUMULATE DataLine.Val[3] (TOTAL).
         ACCUMULATE DataLine.Val[4] (TOTAL).
         ACCUMULATE DataLine.Val[5] (TOTAL).
         ACCUMULATE DataLine.Val[7] (TOTAL).
         ACCUMULATE DataLine.Val[8] (TOTAL).
         ACCUMULATE DataLine.Val[9] (TOTAL).  

         IF NOT LAST-OF(DataLine.Data-ID) 
            THEN PUT STREAM sfact UNFORMATTED
               "���������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
            .
      END.
   END.
   ASSIGN
      iVal_a[1] = ACCUM TOTAL DataLine.Val[11]
      iVal_a[2] = ACCUM TOTAL DataLine.Val[1]
      iVal_a[3] = ACCUM TOTAL DataLine.Val[2]
      iVal_a[4] = ACCUM TOTAL DataLine.Val[3]
      iVal_a[5] = ACCUM TOTAL DataLine.Val[4]
      iVal_a[6] = ACCUM TOTAL DataLine.Val[5]
      iVal_a[7] = ACCUM TOTAL DataLine.Val[7]
      iVal_a[8] = ACCUM TOTAL DataLine.Val[8]
      iVal_a[9] = ACCUM TOTAL DataLine.Val[9]
   .
   
   /* ���⠥� �⮣� ��ࠢ���� */

   PUT STREAM sfact UNFORMATTED
      "���������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
      "�                                                                                            �⮣� ���㫨஢���:�" + 
      STRING(ABS(iVal_a[1]),">>,>>>,>>9.99") + "�" +
      STRING(ABS(iVal_a[2]),">>,>>>,>>9.99") + "�" +
      STRING(ABS(iVal_a[3]),">>,>>>,>>9.99") + "�" +
      STRING(ABS(iVal_a[4]),">>,>>>,>>9.99") + "�" +
      STRING(ABS(iVal_a[5]),">>,>>>,>>9.99") + "�" +
      STRING(ABS(iVal_a[6]),">>,>>>,>>9.99") + "�" +
      STRING(ABS(iVal_a[7]),">>,>>>,>>9.99") + "�" +
      STRING(ABS(iVal_a[8]),">>,>>>,>>9.99") + "�" +
      STRING(ABS(iVal_a[9]),">>,>>>,>>9.99") + "�" SKIP
      "���������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
   .

   mStrNum = 0.
   FOR EACH bDL WHERE bDL.Data-Id EQ INT64(INDATABLOCK)
   NO-LOCK,

   FIRST DataLine WHERE DataLine.Data-ID EQ bDL.Data-Id
                    AND DataLine.Sym1    EQ bDL.Sym1
                    AND DataLine.Sym2    EQ bDL.Sym2
                    AND DataLine.Sym3    EQ bDL.Sym3
                    AND DataLine.Sym4    EQ bDL.Sym4
   NO-LOCK
      BREAK BY DataLine.Data-ID:
      
      IF NUM-ENTRIES(DataLine.Txt,"~n") GT 12
         AND ENTRY(13,DataLine.Txt,"~n") EQ "��" THEN
      DO:
         ASSIGN
            mStrNum     = mStrNum + 1
            mNamePostav =  SplitStr(ENTRY(1,DataLine.Txt,"~n"),
                                          21,
                                          "~n")
   
            mNums       =  SplitStr(ENTRY(6,DataLine.Txt,"~n") + " " 
                                  + ENTRY(8,DataLine.Txt,"~n"),
                                          15,
                                          "~n")
      
            mAmt        =  SplitStr(STRING(DataLine.Val[11],">>,>>>,>>9.99") + " " 
                                  + ENTRY(7,DataLine.Txt,"~n"),
                                    13,
                                    "~n")
            vAdvance    = ENTRY(4,bDL.Txt,"~n") EQ "�����"   
         .
   
         PUT STREAM sfact UNFORMATTED
            "�" +
            STRING(mStrNum,"999") + "�" +
            STRING(ENTRY(1,mNums,"~n"),"x(15)") + "�" +
            STRING(DataLine.Sym2,"x(10)") + "�" +
            STRING(DataLine.Sym1,"x(10)") + "�" +
            STRING(ENTRY(1,mNamePostav,"~n"),"x(21)") + "�" +
            STRING(ENTRY(2,DataLine.Txt,"~n"),"x(14)") + "�" +
            STRING(ENTRY(3,DataLine.Txt,"~n"),"x(14)") + "�" +
            STRING(ENTRY(4,DataLine.Txt,"~n"),"x(10)") + " " + 
            STRING(ENTRY(5,DataLine.Txt,"~n"),"x(6)") + "�" +
            STRING(DEC(ENTRY(1,mAmt,"~n")),">>,>>>,>>9.99") + "�" +
            (IF vAdvance 
             THEN (" " + FILL("-",11) + " ")
             ELSE STRING(bDL.Val[1],">>>>,>>>,>>9.99")) + "�" +
            STRING(bDL.Val[2],">>>>,>>>,>>9.99") + "�" +
            (IF vAdvance 
             THEN (" " + FILL("-",11) + " ")
             ELSE STRING(bDL.Val[3],">>,>>>,>>9.99")) + "�" +
            STRING(DataLine.Val[4],">>,>>>,>>9.99") + "�" +
            STRING(DataLine.Val[5],">>,>>>,>>9.99") + "�" +
            STRING(DataLine.Val[7],">>,>>>,>>9.99") + "�" +
            STRING(DataLine.Val[8],">>,>>>,>>9.99") + "�" +
            STRING(DataLine.Val[9],">>,>>>,>>9.99") + "�"
            SKIP
         .
         IF MAX(NUM-ENTRIES(mNamePostav,"~n"),
            NUM-ENTRIES(mNums,"~n"),
            NUM-ENTRIES(mAmt,"~n")) GE 2 
         THEN DO i = 2 TO MAX(NUM-ENTRIES(mNamePostav,"~n"),
                              NUM-ENTRIES(mNums,"~n"),
                              NUM-ENTRIES(mAmt,"~n")):
            PUT STREAM sfact UNFORMATTED
               "�" +
               STRING("   ") + "�" +
               STRING((IF i LE NUM-ENTRIES(mNums,"~n") 
                                THEN ENTRY(i,mNums,"~n") 
                                ELSE " "),"x(15)") + "�" +
               STRING(" ","x(10)") + "�" +
               STRING(" ","x(10)") + "�" +
               STRING((IF i LE NUM-ENTRIES(mNamePostav,"~n") 
                                THEN ENTRY(i,mNamePostav,"~n") 
                                ELSE " "),"x(21)") + 
               "�              �              �                 �" + 
               STRING((IF i LE NUM-ENTRIES(mAmt,"~n") 
                         THEN ENTRY(i,mAmt,"~n") 
                         ELSE " "),"x(13)") +
               "�             �             �             �             �             �             �             �             �"                  
               SKIP
            .
         END.
         ACCUMULATE DataLine.Val[11] (TOTAL).
         ACCUMULATE DataLine.Val[1] (TOTAL).
         ACCUMULATE DataLine.Val[2] (TOTAL).
         ACCUMULATE DataLine.Val[3] (TOTAL).
         ACCUMULATE DataLine.Val[4] (TOTAL).
         ACCUMULATE DataLine.Val[5] (TOTAL).
         ACCUMULATE DataLine.Val[7] (TOTAL).
         ACCUMULATE DataLine.Val[8] (TOTAL).
         ACCUMULATE DataLine.Val[9] (TOTAL).  

         IF NOT LAST-OF(DataLine.Data-ID) 
            THEN PUT STREAM sfact UNFORMATTED
               "���������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
            .
      END.
   END.
   ASSIGN
      iVal_d[1] = ACCUM TOTAL DataLine.Val[11]
      iVal_d[2] = ACCUM TOTAL DataLine.Val[1]
      iVal_d[3] = ACCUM TOTAL DataLine.Val[2]
      iVal_d[4] = ACCUM TOTAL DataLine.Val[3]
      iVal_d[5] = ACCUM TOTAL DataLine.Val[4]
      iVal_d[6] = ACCUM TOTAL DataLine.Val[5]
      iVal_d[7] = ACCUM TOTAL DataLine.Val[7]
      iVal_d[8] = ACCUM TOTAL DataLine.Val[8]
      iVal_d[9] = ACCUM TOTAL DataLine.Val[9]
   .

   /* ���⠥� �⮣� ��������� */

   PUT STREAM sfact UNFORMATTED
      "���������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
      "�                                                                                               �⮣� ���������:�" + 
      STRING(iVal_d[1],">>,>>>,>>9.99") + "�" +
      STRING(iVal_d[2],">>,>>>,>>9.99") + "�" +
      STRING(iVal_d[3],">>,>>>,>>9.99") + "�" +
      STRING(iVal_d[4],">>,>>>,>>9.99") + "�" +
      STRING(iVal_d[5],">>,>>>,>>9.99") + "�" +
      STRING(iVal_d[6],">>,>>>,>>9.99") + "�" +
      STRING(iVal_d[7],">>,>>>,>>9.99") + "�" +
      STRING(iVal_d[8],">>,>>>,>>9.99") + "�" +
      STRING(iVal_d[9],">>,>>>,>>9.99") + "�" SKIP
      "���������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
   .

   /*������뢠�� �뢮�*/
   DO ii = 1 TO 9:
      iVal_m[ii] = iVal_m[ii] - iVal_a[ii] + iVal_d[ii].
   END.

   PUT STREAM sfact UNFORMATTED
      "���������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
      "�                                                                                                         �ᥣ�:�" + 
      STRING(iVal_m[1],">>,>>>,>>9.99") + "�" +
      STRING(iVal_m[2],">>,>>>,>>9.99") + "�" +
      STRING(iVal_m[3],">>,>>>,>>9.99") + "�" +
      STRING(iVal_m[4],">>,>>>,>>9.99") + "�" +
      STRING(iVal_m[5],">>,>>>,>>9.99") + "�" +
      STRING(iVal_m[6],">>,>>>,>>9.99") + "�" +
      STRING(iVal_m[7],">>,>>>,>>9.99") + "�" +
      STRING(iVal_m[8],">>,>>>,>>9.99") + "�" +
      STRING(iVal_m[9],">>,>>>,>>9.99") + "�" SKIP
      "�����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������" SKIP
   .
   
   {signatur.i
      &stream="STREAM sfact"}
END PROCEDURE.


/*����� �������⥫��� ���⮢ ����� �த��*/
PROCEDURE SellAddPage:
   DEFINE INPUT PARAMETER inDataBlock  AS CHARACTER NO-UNDO.
   DEFINE INPUT PARAMETER inPagenumber AS INT64     NO-UNDO. /*����� ��࠭���*/
       /*�⮣� �� ���-䠪��ࠬ*/
   DEFINE VARIABLE iVal_m     AS DEC     NO-UNDO EXTENT 9. /*�� ���㫨஢��.*/
   DEFINE VARIABLE iVal_a     AS DEC     NO-UNDO EXTENT 9. /*���㫨஢��. */
   DEFINE VARIABLE iVal_i     AS DEC     NO-UNDO EXTENT 9. /*��ࠢ�⥫��*/
   DEFINE VARIABLE iVal_i-a   AS DEC     NO-UNDO EXTENT 9. /*�㬬�. */
   DEFINE VARIABLE iVal_d     AS DEC     NO-UNDO EXTENT 9. /*�⮣� �� ���-䠪��ࠬ � �� ������� */ 
   DEFINE VARIABLE iValStr    AS CHAR    NO-UNDO.
   DEFINE VARIABLE vAdvance   AS LOGICAL NO-UNDO.

   DEFINE VARIABLE ii     AS INT64 NO-UNDO.

   DEFINE BUFFER iTmpDataline FOR TmpDataLine. 
   /*������ �⮣� ��� ���-䠪��� (�� ���㫨஢�����) */
   RUN CalcTotalsIn(inDataBlock, INPUT-OUTPUT iVal_m).
   FOR EACH DataLine
   WHERE DataLine.Data-ID EQ INT64(inDataBlock)
   NO-LOCK:

      /*������ �㬬� ��� ���㫨஢����� � ��ࠢ�⥫��� ���-䠪���*/
      IF NUM-ENTRIES(DataLine.Txt,"~n") GE 9 THEN
      DO:           
         IF      ENTRY(9,DataLine.Txt,"~n") EQ "��ࠢ" THEN
         DO:         
            CREATE iTmpDataLine.
            BUFFER-COPY DataLine TO iTmpDataLine.
            ASSIGN
               itmpDataLine.isprav    = "��ࠢ"
               itmpDataLine.cont-code = IF NUM-ENTRIES(DataLine.Txt,"~n") GT 9 THEN 
                                          IF NUM-ENTRIES(ENTRY(10,DataLine.Txt,"~n")) GE 2 THEN 
                                             ENTRY(2,ENTRY(10,DataLine.Txt,"~n")) 
                                          ELSE ""
                                       ELSE ""         
            .
         END.
         ELSE IF ENTRY(9,DataLine.Txt,"~n") EQ "���㫨�" THEN
         DO:
            CREATE tmpDataLine.
            BUFFER-COPY DataLine TO tmpDataLine.
            ASSIGN 
               tmpDataLine.isprav    = "���㫨�"
               iVal_a[1]             = iVal_a[1] +  DataLine.Val[11]
               iVal_a[2]             = iVal_a[2] +  DataLine.Val[1]
               iVal_a[3]             = iVal_a[3] +  DataLine.Val[2]
               iVal_a[4]             = iVal_a[4] +  DataLine.Val[3]
               iVal_a[5]             = iVal_a[5] +  DataLine.Val[4]
               iVal_a[6]             = iVal_a[6] +  DataLine.Val[5]
               iVal_a[7]             = iVal_a[7] +  DataLine.Val[7]
               iVal_a[8]             = iVal_a[8] +  DataLine.Val[8]
               iVal_a[9]             = iVal_a[9] +  DataLine.Val[9]
            .
         END.
      END.
   END.

   PUT STREAM sfact UNFORMATTED
      FILL(" ",40)  + "�������������� ���� � ����� ������ �" + 
      STRING(inPagenumber) SKIP(3)
      "�த���� " + STRING(mBuyer,"x(35)")                 SKIP
      "         " + FILL("�",35)                           SKIP(2)
      "�����䨪�樮��� ����� � ��� ��稭� ���⠭���� �� ��� ���������⥫�騪�-�த��� " + TRIM(STRING(mINN)) + "/" + STRING(mKPP,"x(15)") SKIP
      "                                                                                    " + FILL("�",35) SKIP(2)
      "�������� ��ਮ� (�����, ����⠫), ���, � ���஬ ��ॣ����஢�� ���-䠪��� �� ���ᥭ�� � ���� ��ࠢ�����: " 
       term2str(bdb.Beg-Date,bdb.End-Date) SKIP
      "                                                                                                               ����������������" SKIP(2)
   
      "�������⥫�� ���� ��ଫ�� " STRING(TODAY,"99/99/9999") SKIP
      "                             ����������" SKIP(3)
   .
/*����� ��������*/
PUT STREAM sfact UNFORMATTED
   "������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ŀ" SKIP
   "� ��� � �����  � ����� � ���  � ����� � ���  � ����� � ���  �    ������������     �    ���     �    ���     � ���   � �ᥣ� �த��  �                                          � ⮬ �᫥                                                              �" SKIP
   "� ���-䠪���� � ��ࠢ�����   � ���४��-   � ��ࠢ�����   �     ���㯠⥫�      � ���㯠⥫� � ���㯠⥫� �������  �  ������ ���  �������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
   "�   �த���    � ���-䠪���� � ��筮��       � ���४��-   �                     �            �            ����-  �               �                              �த���, ��������� ������� �� �⠢��                                  �  �த���,   �" SKIP
   "�               �               � ���-䠪���� � ��筮��       �                     �            �            �䠪���� �               �����������������������������������������������������������������������������������������������������Ĵ�᢮�������륳" SKIP
   "�               �               �               � ���-䠪���� �                     �            �            ��த��栳               �         18 ��業⮢          �       10 ��業⮢        � 0 ��業⮢ �       20 ��業⮢*       �  �� ������  �" SKIP
   "�               �               �               �               �                     �            �            �        �               �����������������������������������������������������������������������������������������������������Ĵ             �" SKIP
   "�               �               �               �               �                     �            �            �        �               � �⮨����� ��- �  �㬬� ���    ��⮨����� ��-� �㬬� ���   �             ��⮨����� ��-� �㬬� ���   �             �" SKIP
   "�               �               �               �               �                     �            �            �        �               � ���� ��� ���  �               ����� ��� ��� �             �             ����� ��� ��� �             �             �" SKIP
   "������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
   "�     (1)       �     (1�)      �     (1�)      �     (1�)      �         (2)         �    (3)     �    (3�)    �  (3�)  �      (4)      �      (5�)     �      (5�)     �     (6�)    �     (6�)    �     (7)     �     (8�)    �     (8�)    �     (9)     �" SKIP
/*
   "������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
*/
.
   /*�����*/
   PUT STREAM sfact UNFORMATTED
   "������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
   "�                                                                                                                  �����:�" + 
      STRING(iVal_m[1],">>>>,>>>,>>9.99") + "�" +
      STRING(iVal_m[2],">>>>,>>>,>>9.99") + "�" +
      STRING(iVal_m[3],">>>>,>>>,>>9.99") + "�" +
      STRING(iVal_m[4],">,>>>,>>9.99") + "�" +
      STRING(iVal_m[5],">>,>>>,>>9.99") + "�" +
      STRING(iVal_m[6],">>,>>>,>>9.99") + "�" +
      STRING(iVal_m[7],">>,>>>,>>9.99") + "�" +
      STRING(iVal_m[8],">>,>>>,>>9.99") + "�" +
      STRING(iVal_m[9],">>,>>>,>>9.99") + "�" SKIP
   "������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
   .
   FOR EACH tmpDataLine WHERE tmpDataLine.isprav EQ "���㫨�"
   NO-LOCK,

   FIRST bDL WHERE bDL.Data-ID EQ tmpDataLine.Data-Id
               AND bDL.Sym1    EQ tmpDataLine.Sym1
               AND bDL.Sym2    EQ tmpDataLine.Sym2
               AND bDL.Sym3    EQ tmpDataLine.Sym3
               AND bDL.Sym4    EQ tmpDataLine.Sym4
   NO-LOCK
      BREAK BY tmpDataLine.Data-ID:

      ASSIGN
         mNamePostav =  SplitStr(ENTRY(1,tmpDataLine.Txt,"~n"),
                                 21,
                                "~n")
   
         mNums       =  SplitStr(ENTRY(6,tmpDataLine.Txt,"~n") + " " 
                               + ENTRY(8,tmpDataLine.Txt,"~n"),
                                 15,
                                 "~n")
         mAmt        = SplitStr(STRING(tmpDataLine.Val[11],">>,>>>,>>9.99") + " " 
                              + ENTRY(7,tmpDataLine.Txt,"~n"),
                                13,
                                "~n")
         
         vAdvance    = ENTRY(4,bDL.Txt,"~n") EQ "�����"
      .

      PUT STREAM sfact UNFORMATTED
         "�" +
         STRING(ENTRY(1,mNums,"~n"),"x(15)") + "�" +
         STRING(ENTRY(1,mNamePostav,"~n"),"x(21)") + "�" +
         STRING(ENTRY(2,tmpDataLine.Txt,"~n"),"x(14)") + "�" +
         STRING(ENTRY(3,tmpDataLine.Txt,"~n"),"x(14)") + "�" +
         STRING(tmpDataLine.Sym2,"x(10)") + "�" +
         STRING(DEC(ENTRY(1,mAmt,"~n")),">>,>>>,>>9.99") + "�" +
         (IF vAdvance 
          THEN (" " + FILL("-",11) + " ")
          ELSE STRING(bDL.Val[1],">>,>>>,>>9.99")) + "�" +
         STRING(bDL.Val[2],">>,>>>,>>9.99") + "�" +
         (IF vAdvance 
          THEN (" " + FILL("-",11) + " ")
          ELSE STRING(bDL.Val[3],">>,>>>,>>9.99")) + "�" +
         STRING(tmpDataLine.Val[4],">>,>>>,>>9.99") + "�" +
         STRING(tmpDataLine.Val[5],">>,>>>,>>9.99") + "�" +
         STRING(tmpDataLine.Val[7],">>,>>>,>>9.99") + "�" +
         STRING(tmpDataLine.Val[8],">>,>>>,>>9.99") + "�" +
         STRING(tmpDataLine.Val[9],">>,>>>,>>9.99") + "�"
         SKIP
      .
   
      IF MAX(NUM-ENTRIES(mNamePostav,"~n"),
         NUM-ENTRIES(mNums,"~n"),
         NUM-ENTRIES(mAmt,"~n")) GE 2 
      THEN DO i = 2 TO MAX(NUM-ENTRIES(mNamePostav,"~n"),
                           NUM-ENTRIES(mNums,"~n"),
                           NUM-ENTRIES(mAmt,"~n")):
         PUT STREAM sfact UNFORMATTED
            "�" +
            STRING((IF i LE NUM-ENTRIES(mNums,"~n") 
                    THEN ENTRY(i,mNums,"~n") 
                    ELSE " "),"x(15)") + "�" +
            STRING((IF i LE NUM-ENTRIES(mNamePostav,"~n") 
                    THEN ENTRY(i,mNamePostav,"~n") 
                    ELSE " "),"x(21)") + 
            "�              �              �          �" + 
            STRING((IF i LE NUM-ENTRIES(mAmt,"~n") 
                     THEN ENTRY(i,mAmt,"~n") 
                     ELSE " "),"x(13)") + 
            "�             �             �             �             �             �             �             �             �" SKIP
            SKIP
         .
      END.

      /*�⡨ࠥ� �� ���-䠪���� ��ࠢ���騥 ����� ���-䠪����*/            
      FOR EACH iTmpDataLine WHERE iTmpDataLine.cont-code EQ ENTRY(11,TmpDataLine.Txt,"~n") NO-LOCK BREAK BY iTmpDataLine.Data-ID:
         
         PUT STREAM sfact UNFORMATTED
            "������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
         .

         mNamePostav =  SplitStr(ENTRY(1,iTmpDataLine.Txt,"~n"),
                                 21,
                                "~n").
         mNums       =  SplitStr(ENTRY(6,iTmpDataLine.Txt,"~n") + " " 
                               + ENTRY(8,iTmpDataLine.Txt,"~n"),
                                 15,
                                 "~n").
         mAmt = SplitStr(STRING(iTmpDataLine.Val[11],">>,>>>,>>9.99") + " " 
                              + ENTRY(7,iTmpDataLine.Txt,"~n"),
                                13,
                                "~n").

         PUT STREAM sfact UNFORMATTED
            "�" +
            STRING(ENTRY(1,mNums,"~n"),"x(15)") + "�" +
            STRING(ENTRY(1,mNamePostav,"~n"),"x(21)") + "�" +
            STRING(ENTRY(2,iTmpDataLine.Txt,"~n"),"x(14)") + "�" +
            STRING(ENTRY(3,iTmpDataLine.Txt,"~n"),"x(14)") + "�" +
            STRING(iTmpDataLine.Sym2,"x(10)") + "�" +
            STRING(ENTRY(1,mAmt,"~n"),"x(13)") + "�" +
            (IF vAdvance 
             THEN (" " + FILL("-",11) + " ")
             ELSE STRING(bDL.Val[1],">>,>>>,>>9.99")) + "�" +
            STRING(bDL.Val[2],">>,>>>,>>9.99") + "�" +
            (IF vAdvance 
             THEN (" " + FILL("-",11) + " ")
             ELSE STRING(bDL.Val[3],">>,>>>,>>9.99")) + "�" +
            STRING(iTmpDataLine.Val[4],">>,>>>,>>9.99") + "�" +
            STRING(iTmpDataLine.Val[5],">>,>>>,>>9.99") + "�" +
            STRING(iTmpDataLine.Val[7],">>,>>>,>>9.99") + "�" +
            STRING(iTmpDataLine.Val[8],">>,>>>,>>9.99") + "�" +
            STRING(iTmpDataLine.Val[9],">>,>>>,>>9.99") + "�"
            SKIP
         .  
         ASSIGN 
            iVal_i[1] = iVal_i[1] +  iTmpDataLine.Val[11]
            iVal_i[2] = iVal_i[2] +  iTmpDataLine.Val[1]
            iVal_i[3] = iVal_i[3] +  iTmpDataLine.Val[2]
            iVal_i[4] = iVal_i[4] +  iTmpDataLine.Val[3]
            iVal_i[5] = iVal_i[5] +  iTmpDataLine.Val[4]
            iVal_i[6] = iVal_i[6] +  iTmpDataLine.Val[5]
            iVal_i[7] = iVal_i[7] +  iTmpDataLine.Val[7]
            iVal_i[8] = iVal_i[8] +  iTmpDataLine.Val[8]
            iVal_i[9] = iVal_i[9] +  iTmpDataLine.Val[9]
         .
         IF MAX(NUM-ENTRIES(mNamePostav,"~n"),
            NUM-ENTRIES(mNums,"~n"),
            NUM-ENTRIES(mAmt,"~n")) GE 2 
         THEN DO i = 2 TO MAX(NUM-ENTRIES(mNamePostav,"~n"),
                              NUM-ENTRIES(mNums,"~n"),
                              NUM-ENTRIES(mAmt,"~n")):
            PUT STREAM sfact UNFORMATTED
               "�" +
               STRING((IF i LE NUM-ENTRIES(mNums,"~n") 
                       THEN ENTRY(i,mNums,"~n") 
                       ELSE " "),"x(15)") + "�" +
               STRING((IF i LE NUM-ENTRIES(mNamePostav,"~n") 
                       THEN ENTRY(i,mNamePostav,"~n") 
                       ELSE " "),"x(21)") + 
               "�              �              �          �" + 
               STRING((IF i LE NUM-ENTRIES(mAmt,"~n") 
                     THEN ENTRY(i,mAmt,"~n") 
                     ELSE " "),"x(13)") + 
               "�             �             �             �             �             �             �             �             �" SKIP
               SKIP
            .

         END.
         IF NOT LAST-OF(iTmpDataLine.Data-ID) THEN 
            PUT STREAM sfact UNFORMATTED
               "������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
            .

      END.
      IF NOT LAST-OF(TmpDataLine.Data-ID) THEN 
         PUT STREAM sfact UNFORMATTED
            "������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
         .
   END.

   /*������뢠�� �뢮�*/
   DO ii = 1 TO 9:
      iVal_i-a[ii] = iVal_i[ii] - iVal_a[ii].
   END.

   /* ���⠥� �⮣� ��ࠢ���� */

   PUT STREAM sfact UNFORMATTED
      "������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
      "�                                                             �⮣� ��ࠢ����:�" + 
      STRING(ABS(iVal_i-a[1]),">>,>>>,>>9.99") + "�" +
      STRING(ABS(iVal_i-a[2]),">>,>>>,>>9.99") + "�" +
      STRING(ABS(iVal_i-a[3]),">>,>>>,>>9.99") + "�" +
      STRING(ABS(iVal_i-a[4]),">>,>>>,>>9.99") + "�" +
      STRING(ABS(iVal_i-a[5]),">>,>>>,>>9.99") + "�" +
      STRING(ABS(iVal_i-a[6]),">>,>>>,>>9.99") + "�" +
      STRING(ABS(iVal_i-a[7]),">>,>>>,>>9.99") + "�" +
      STRING(ABS(iVal_i-a[8]),">>,>>>,>>9.99") + "�" +
      STRING(ABS(iVal_i-a[9]),">>,>>>,>>9.99") + "�" SKIP
      "������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
   .

   mStrNum = 0.

   FOR EACH bDL WHERE bDL.Data-Id EQ INT64(INDATABLOCK)
   NO-LOCK,

   FIRST DataLine WHERE DataLine.Data-ID EQ bDL.Data-Id
                    AND DataLine.Sym1    EQ bDL.Sym1
                    AND DataLine.Sym2    EQ bDL.Sym2
                    AND DataLine.Sym3    EQ bDL.Sym3
                    AND DataLine.Sym4    EQ bDL.Sym4
   NO-LOCK
      BREAK BY DataLine.Data-ID:
      
      IF NUM-ENTRIES(DataLine.Txt,"~n") GT 12
         AND ENTRY(13,DataLine.Txt,"~n") EQ "��" THEN
      DO:
         ASSIGN
            mStrNum     = mStrNum + 1
            mNamePostav =  SplitStr(ENTRY(1,DataLine.Txt,"~n"),
                                          21,
                                          "~n")
   
            mNums       =  SplitStr(ENTRY(6,DataLine.Txt,"~n") + " " 
                                  + ENTRY(8,DataLine.Txt,"~n"),
                                          15,
                                          "~n")
      
            mAmt        =  SplitStr(STRING(DataLine.Val[11],">>,>>>,>>9.99") + " " 
                                  + ENTRY(7,DataLine.Txt,"~n"),
                                    13,
                                    "~n")
            vAdvance    = ENTRY(4,bDL.Txt,"~n") EQ "�����"   
         .

         PUT STREAM sfact UNFORMATTED
            "�" +
            STRING(ENTRY(1,mNums,"~n"),"x(15)") + "�" +
            STRING(ENTRY(1,mNamePostav,"~n"),"x(21)") + "�" +
            STRING(ENTRY(2,DataLine.Txt,"~n"),"x(14)") + "�" +
            STRING(ENTRY(3,DataLine.Txt,"~n"),"x(14)") + "�" +
            STRING(DataLine.Sym2,"x(10)") + "�" +
            STRING(DEC(ENTRY(1,mAmt,"~n")),">>,>>>,>>9.99") + "�" +
            (IF vAdvance 
             THEN (" " + FILL("-",11) + " ")
             ELSE STRING(bDL.Val[1],">>,>>>,>>9.99")) + "�" +
            STRING(bDL.Val[2],">>,>>>,>>9.99") + "�" +
            (IF vAdvance 
             THEN (" " + FILL("-",11) + " ")
             ELSE STRING(bDL.Val[3],">>,>>>,>>9.99")) + "�" +
            STRING(DataLine.Val[4],">>,>>>,>>9.99") + "�" +
            STRING(DataLine.Val[5],">>,>>>,>>9.99") + "�" +
            STRING(DataLine.Val[7],">>,>>>,>>9.99") + "�" +
            STRING(DataLine.Val[8],">>,>>>,>>9.99") + "�" +
            STRING(DataLine.Val[9],">>,>>>,>>9.99") + "�"
            SKIP
         .
         
         IF MAX(NUM-ENTRIES(mNamePostav,"~n"),
            NUM-ENTRIES(mNums,"~n"),
            NUM-ENTRIES(mAmt,"~n")) GE 2 
         THEN DO i = 2 TO MAX(NUM-ENTRIES(mNamePostav,"~n"),
                              NUM-ENTRIES(mNums,"~n"),
                              NUM-ENTRIES(mAmt,"~n")):
            PUT STREAM sfact UNFORMATTED
               "�" +
               STRING((IF i LE NUM-ENTRIES(mNums,"~n") 
                       THEN ENTRY(i,mNums,"~n") 
                       ELSE " "),"x(15)") + "�" +
               STRING((IF i LE NUM-ENTRIES(mNamePostav,"~n") 
                       THEN ENTRY(i,mNamePostav,"~n") 
                       ELSE " "),"x(21)") + 
               "�              �              �          �" + 
               STRING((IF i LE NUM-ENTRIES(mAmt,"~n") 
                     THEN ENTRY(i,mAmt,"~n") 
                     ELSE " "),"x(13)") + 
               "�             �             �             �             �             �             �             �             �" SKIP
               SKIP
            .

         END.
         
         ACCUMULATE DataLine.Val[11] (TOTAL).
         ACCUMULATE DataLine.Val[1] (TOTAL).
         ACCUMULATE DataLine.Val[2] (TOTAL).
         ACCUMULATE DataLine.Val[3] (TOTAL).
         ACCUMULATE DataLine.Val[4] (TOTAL).
         ACCUMULATE DataLine.Val[5] (TOTAL).
         ACCUMULATE DataLine.Val[7] (TOTAL).
         ACCUMULATE DataLine.Val[8] (TOTAL).
         ACCUMULATE DataLine.Val[9] (TOTAL).  

         IF NOT LAST-OF(DataLine.Data-ID) THEN
            PUT STREAM sfact UNFORMATTED
               "������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
            .
      END.
   END.
   ASSIGN
      iVal_d[1] = ACCUM TOTAL DataLine.Val[11]
      iVal_d[2] = ACCUM TOTAL DataLine.Val[1]
      iVal_d[3] = ACCUM TOTAL DataLine.Val[2]
      iVal_d[4] = ACCUM TOTAL DataLine.Val[3]
      iVal_d[5] = ACCUM TOTAL DataLine.Val[4]
      iVal_d[6] = ACCUM TOTAL DataLine.Val[5]
      iVal_d[7] = ACCUM TOTAL DataLine.Val[7]
      iVal_d[8] = ACCUM TOTAL DataLine.Val[8]
      iVal_d[9] = ACCUM TOTAL DataLine.Val[9]
   .

   /* ���⠥� �⮣� ��������� */

   PUT STREAM sfact UNFORMATTED
      "������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
      "�                                                              �⮣� ���������:�" + 
      STRING(iVal_d[1],">>,>>>,>>9.99") + "�" +
      STRING(iVal_d[2],">>,>>>,>>9.99") + "�" +
      STRING(iVal_d[3],">>,>>>,>>9.99") + "�" +
      STRING(iVal_d[4],">>,>>>,>>9.99") + "�" +
      STRING(iVal_d[5],">>,>>>,>>9.99") + "�" +
      STRING(iVal_d[6],">>,>>>,>>9.99") + "�" +
      STRING(iVal_d[7],">>,>>>,>>9.99") + "�" +
      STRING(iVal_d[8],">>,>>>,>>9.99") + "�" +
      STRING(iVal_d[9],">>,>>>,>>9.99") + "�" SKIP
      "������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
   .

   /*������뢠�� �뢮�*/
   DO ii = 1 TO 9:
      iVal_m[ii] = iVal_m[ii] + iVal_i-a[ii] + iVal_d[ii].
   END.

   PUT STREAM sfact UNFORMATTED
      "������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
      "�                                                                        �ᥣ�:�" + 
      STRING(iVal_m[1],">>,>>>,>>9.99") + "�" +
      STRING(iVal_m[2],">>,>>>,>>9.99") + "�" +
      STRING(iVal_m[3],">>,>>>,>>9.99") + "�" +
      STRING(iVal_m[4],">>,>>>,>>9.99") + "�" +
      STRING(iVal_m[5],">>,>>>,>>9.99") + "�" +
      STRING(iVal_m[6],">>,>>>,>>9.99") + "�" +
      STRING(iVal_m[7],">>,>>>,>>9.99") + "�" +
      STRING(iVal_m[8],">>,>>>,>>9.99") + "�" +
      STRING(iVal_m[9],">>,>>>,>>9.99") + "�" SKIP
      "��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������" SKIP
   .
   &UNDEFINE signatur_i
   {signatur.i
      &stream="STREAM sfact"}
END PROCEDURE.


/*������ �⮣� (�㬬� ��⮢-䠪���)*/
PROCEDURE CalcTotals:
   DEFINE INPUT  PARAMETER inDataBlock AS CHARACTER NO-UNDO.
   DEFINE OUTPUT PARAMETER oValStr     AS CHARACTER NO-UNDO. /*�㬬�
                                                              ���-䠪���*/
   DEF VAR vVal_m      AS DECIMAL   NO-UNDO EXTENT 9. /*�㬬�
                                                        ���-䠪���*/

   RUN CalcTotalsIn(inDataBlock,INPUT-OUTPUT vVal_m).
   
   oValStr = STRING(vVal_m[1]) + "," + STRING(vVal_m[2]) + "," + STRING(vVal_m[3]) + "," + 
             STRING(vVal_m[4]) + "," + STRING(vVal_m[5]) + "," + STRING(vVal_m[6]) + "," + 
             STRING(vVal_m[7]) + "," + STRING(vVal_m[8]) + "," + STRING(vVal_m[9]).

END PROCEDURE.

/*������ �⮣� (�㬬� ��⮢-䠪���)*/
PROCEDURE CalcTotalsIn:
   DEF INPUT        PARAM inDataBlock AS CHAR NO-UNDO.
   DEF INPUT-OUTPUT PARAM vVal_m      AS DEC  NO-UNDO EXTENT 9. /*�㬬� ���-䠪���*/
   
   FOR EACH DataLine
      WHERE DataLine.Data-ID EQ INT64(INDATABLOCK)
      NO-LOCK:
      IF NUM-ENTRIES(DataLine.Txt,"~n") < 9 OR ENTRY(9,DataLine.Txt,"~n") <> "��ࠢ" AND NUM-ENTRIES(DataLine.Txt,"~n") GT 12 AND ENTRY(13,DataLine.Txt,"~n") EQ "" THEN
      DO:
         ACCUMULATE DataLine.Val[11] (TOTAL).
         ACCUMULATE DataLine.Val[1] (TOTAL).
         ACCUMULATE DataLine.Val[2] (TOTAL).
         ACCUMULATE DataLine.Val[3] (TOTAL).
         ACCUMULATE DataLine.Val[4] (TOTAL).
         ACCUMULATE DataLine.Val[5] (TOTAL).
         ACCUMULATE DataLine.Val[7] (TOTAL).
         ACCUMULATE DataLine.Val[8] (TOTAL).
         ACCUMULATE DataLine.Val[9] (TOTAL).
      END.
   END.
   ASSIGN
      vVal_m[1] = ACCUM TOTAL DataLine.Val[11]
      vVal_m[2] = ACCUM TOTAL DataLine.Val[1]
      vVal_m[3] = ACCUM TOTAL DataLine.Val[2]
      vVal_m[4] = ACCUM TOTAL DataLine.Val[3]
      vVal_m[5] = ACCUM TOTAL DataLine.Val[4]
      vVal_m[6] = ACCUM TOTAL DataLine.Val[5]
      vVal_m[7] = ACCUM TOTAL DataLine.Val[7]
      vVal_m[8] = ACCUM TOTAL DataLine.Val[8]
      vVal_m[9] = ACCUM TOTAL DataLine.Val[9]
   .
END PROCEDURE.

procedure EndStrike.
   DEFINE INPUT  PARAM iNumStrike   AS INT64   NO-UNDO.   /* ����� ��ப� � ���� */
   DEFINE INPUT  PARAM iNumPosition AS INT64   NO-UNDO.   /* ������ �⮡ࠦ���� ��ப� "��࠭��" */
   DEFINE INPUT  PARAM iLastPage    AS LOGICAL NO-UNDO.   /* ����� ����� ���. �� ��᫥���� ��࠭�� */
   DEFINE OUTPUT PARAM oNumStrike   AS INT64   NO-UNDO.   /* ����� ��ப� � ���� */

   PUT STREAM sfact UNFORMATTED " " SKIP(printer.page-lines - (iNumStrike + 1)).
   PUT STREAM sfact UNFORMATTED "���. " AT printer.page-cols + iNumPosition
                    STRING(PAGE-NUMBER(sfact)) AT printer.page-cols + 5 + iNumPosition SKIP.
   IF iLastPage THEN PAGE STREAM sfact.
   iNumStrike = 0.
   oNumStrike = iNumStrike.
end procedure.

/* ��楤�� ������ ��ப � ���������� ����� ��࠭�� */
PROCEDURE CalcStrike.
   DEFINE INPUT  PARAM iNumStrike   AS INT64   NO-UNDO.   /* ����� ��ப� � ���� */
   DEFINE INPUT  PARAM iNumPosition AS INT64   NO-UNDO.   /* ������ �⮡ࠦ���� ��ப� "��࠭��" */
   DEFINE INPUT  PARAM iLastPage    AS LOGICAL NO-UNDO.   /* ����� ����� ���. �� ��᫥���� ��࠭�� */
   DEFINE OUTPUT PARAM oNumStrike   AS INT64   NO-UNDO.   /* ����� ��ப� � ���� */

   IF iLastPage THEN DO:
      PUT STREAM sfact UNFORMATTED " " SKIP(printer.page-lines - (iNumStrike + 5)).
      PUT STREAM sfact UNFORMATTED "���. " AT printer.page-cols + iNumPosition
                       STRING(PAGE-NUMBER(sfact)) AT printer.page-cols + 5 + iNumPosition SKIP.
      iNumStrike = 0.
   END.
   IF iNumStrike + 1 EQ printer.page-lines THEN DO:
      PUT STREAM sfact UNFORMATTED "���. " AT printer.page-cols + iNumPosition
                       STRING(PAGE-NUMBER(sfact)) AT printer.page-cols + 5 + iNumPosition SKIP.
      PAGE STREAM sfact.
      iNumStrike = 0.
   END.
   ELSE oNumStrike = iNumStrike.
END PROCEDURE.
