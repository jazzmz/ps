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
      Modified: 16.02.2007 ���� �.�. (������� ��� ��� ���᪠: BEP000001)
                ������� ���஢��.
      Modified: 01.03.2007 ���� �.�. (������� ��� ��� ���᪠: BEP000002)
      					������� �롮�� ��� ��壠��� �� ����஥筮�� ��ࠬ��� �����ᨊ���-��壠���,
      					�᫨ ��� ���⮥, � ��� ������ �� ��.��������.
      Modified: 13.04.2007 12:04 ���� �.�. (������� ��� ��� ���᪠: BEP000003)
                ������� �ଠ� ������ � �������⥫��� ����� ���� ���㯮� � �த��.
                 
*/

  
{globals.i}
{intrface.get xclass}
{intrface.get instrum}
{intrface.get tparam}
{intrface.get axd}
{intrface.get asset}
{intrface.get strng }
  
  
DEF INPUT PARAM iDataBlock AS CHAR NO-UNDO.

DEF TEMP-TABLE tmpDataLine NO-UNDO LIKE DataLine
   FIELD Date1     AS DATE
   FIELD Date2     AS DATE
    /** BEP000001: ����⠭������ 13.04.2007 12:00 */
    FIELD sfDate AS DATE
    FIELD sfNum AS CHAR
    /** BEP000001: end */
   FIELD isprav    AS CHARACTER /*����� (���㫨஢����� ��� ��ࠢ�⥫쭠�)*/
   FIELD cont-code AS CHARACTER /*����� ���-䠪����, ������ ��ࠢ���
                                 ������ ���-䠪���.*/  
   INDEX dateprim Data-ID Date1 Date2
   INDEX isprav cont-code.

DEF BUFFER bDB FOR DataBlock.
DEF BUFFER bDataLine FOR DataLine.
DEF BUFFER bDL FOR tmpDataLine.

DEF VAR mBuyer AS CHAR NO-UNDO.
DEF VAR mINN   AS CHAR NO-UNDO.
DEF VAR mKPP   AS CHAR NO-UNDO.
DEF VAR mAdrs  AS CHAR NO-UNDO.

DEF VAR mStrNum  AS INTEGER NO-UNDO.

DEF VAR mOutStr AS CHAR NO-UNDO.

DEF VAR i AS INTEGER NO-UNDO.
DEF VAR mNamePostav AS CHAR NO-UNDO.
DEF VAR mNums        AS CHAR NO-UNDO.
DEF VAR mBuhName AS CHAR NO-UNDO.
DEF VAR mAmt AS CHAR NO-UNDO.

DEFINE STREAM sfact.
{setdest.i &cols=120 &STREAM="stream sfact" }

/*�饬 ���� ������ ��� ����祭�� ��� ��砫� � ����*/
FIND FIRST bDB WHERE bDB.Data-ID EQ INTEGER(iDataBlock)
   NO-LOCK NO-ERROR.

FIND FIRST branch WHERE branch.Branch-Id EQ bDB.Branch-Id NO-LOCK NO-ERROR.
/** BEP000002: ����⠭������ 13.04.2007 12:03 */
mBuhName = FGetSetting("�����ᨊ���","��壠���","").
IF mBuhName = "" AND AVAIL branch THEN mBuhName = branch.CFO-name.
/** BEP000002: end */

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

FOR EACH bDataLine WHERE 
         bDataLine.data-id = INT(iDataBlock)
   NO-LOCK:

   CREATE bDL.
   BUFFER-COPY bDataLine TO bDL.
   ASSIGN
      bDL.Date1 = DATE(bDataLine.Sym1)
      bDL.Date2 = DATE(bDataLine.Sym2)
      /** BEP000001: ����⠭������ 13.04.2007 11:59 */
      bDL.sfDate = DATE(
        		INT(ENTRY(2, ENTRY(6, bDataLine.Txt, "~n"), "/")),
        		INT(ENTRY(1, ENTRY(6, bDataLine.Txt, "~n"), "/")),
        		INT(ENTRY(3, ENTRY(6, bDataLine.Txt, "~n"), "/"))
        )
      bDL.sfNum = ENTRY(8, bDataLine.txt, "~n")
      /** BEP000001: end */
   .

END.
/*����� �������⥫��� ���⮢ ����� ���㯮�*/
PROCEDURE BuyAddPage:
   DEFINE INPUT PARAMETER inDataBlock  AS CHARACTER NO-UNDO.
   DEFINE INPUT PARAMETER inValStr     AS CHARACTER NO-UNDO. /*�⮣� 
                                                             �� ���-䠪��ࠬ*/
   DEFINE INPUT PARAMETER inPagenumber AS INTEGER   NO-UNDO. /*����� ��࠭���*/
   /*����� �����*/
   DEFINE VARIABLE iVal   AS DECIMAL NO-UNDO EXTENT 9. /*�⮣� �� ���㫨஢��.
                                                         ���-䠪��ࠬ */ 
   DEFINE VARIABLE iVal_a AS DECIMAL NO-UNDO EXTENT 9. /*�⮣� �� ���㫨஢��.
                                                         ���-䠪��ࠬ */ 
   DEFINE VARIABLE ii     AS INTEGER NO-UNDO.

   PUT STREAM sfact UNFORMATTED
     
      FILL(" ",40)  + "�������������� ���� � ����� ������� �" + 
      STRING(inPagenumber) SKIP(3)
      "���㯠⥫� " + STRING(mBuyer,"x(35)")              SKIP
      "           " + FILL("�",35)                        SKIP(2)
      "�����䨪�樮��� ����� � ��� ��稭� ���⠭���� �� ��� ���������⥫�騪�-���㯠⥫� " + TRIM(STRING(mINN)) + "/" + STRING(mKPP,"x(15)") SKIP
      "                                                                                      " + FILL("�",35) SKIP(2)
      "���㯪� �� ��ਮ� � " + string(bDB.Beg-Date,"99/99/9999") + " �� " + STRING(bDB.end-Date,"99/99/9999") SKIP
      "                    ����������    ����������" SKIP(3)
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
      STRING(dec(entry(1,inValStr)),">>,>>>,>>9.99") + "�" +
      STRING(dec(entry(2,inValStr)),">>,>>>,>>9.99") + "�" +
      STRING(dec(entry(3,inValStr)),">>,>>>,>>9.99") + "�" +
      STRING(dec(entry(4,inValStr)),">>,>>>,>>9.99") + "�" +
      STRING(dec(entry(5,inValStr)),">>,>>>,>>9.99") + "�" +
      STRING(dec(entry(6,inValStr)),">>,>>>,>>9.99") + "�" +
      STRING(dec(entry(7,inValStr)),">>,>>>,>>9.99") + "�" +
      STRING(dec(entry(8,inValStr)),">>,>>>,>>9.99") + "�" +
      STRING(dec(entry(9,inValStr)),">>,>>>,>>9.99") + "�" skip
      "���������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
   .
   mStrNum = 0.
   FOR EACH DataLine
      WHERE DataLine.Data-ID EQ INTEGER(inDataBlock)
      NO-LOCK BREAK BY DataLine.Data-ID:
      
      IF ENTRY(9,DataLine.Txt,"~n") EQ "���㫨�" THEN
      DO:
         
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
                                 "~n").
   
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
            STRING(DataLine.Val[1],">>,>>>,>>9.99") + "�" +
            STRING(DataLine.Val[2],">>,>>>,>>9.99") + "�" +
            STRING(DataLine.Val[3],">>,>>>,>>9.99") + "�" +
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
      iVal_a[6] = ACCUM TOTAL DataLine.Val[4]
      iVal_a[7] = ACCUM TOTAL DataLine.Val[7]
      iVal_a[8] = ACCUM TOTAL DataLine.Val[8]
      iVal_a[9] = ACCUM TOTAL DataLine.Val[9]
   .
   DO ii = 1 TO 9:
      iVal[ii] = DEC(ENTRY(ii,inValStr)).
      iVal[ii] = iVal[ii] - iVal_a[ii].
   END.

   inValStr = string(iVal[1]) + "," + string(iVal[2]) + "," + string(iVal[3]) + "," + 
              string(iVal[4]) + "," + string(iVal[5]) + "," + string(iVal[6]) + "," + 
              string(iVal[7]) + "," + string(iVal[8]) + "," + string(iVal[9]).

   PUT STREAM sfact UNFORMATTED
      "���������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
      "�                                                                                                         �ᥣ�:�" + 
      STRING(dec(entry(1,inValStr)),">>,>>>,>>9.99") + "�" +
      STRING(dec(entry(2,inValStr)),">>,>>>,>>9.99") + "�" +
      STRING(dec(entry(3,inValStr)),">>,>>>,>>9.99") + "�" +
      STRING(dec(entry(4,inValStr)),">>,>>>,>>9.99") + "�" +
      STRING(dec(entry(5,inValStr)),">>,>>>,>>9.99") + "�" +
      STRING(dec(entry(6,inValStr)),">>,>>>,>>9.99") + "�" +
      STRING(dec(entry(7,inValStr)),">>,>>>,>>9.99") + "�" +
      STRING(dec(entry(8,inValStr)),">>,>>>,>>9.99") + "�" +
      STRING(dec(entry(9,inValStr)),">>,>>>,>>9.99") + "�" skip
      "�����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������" SKIP
   .
END PROCEDURE.


/*����� �������⥫��� ���⮢ ����� �த��*/
PROCEDURE SellAddPage:
   DEFINE INPUT PARAMETER inDataBlock  AS CHARACTER NO-UNDO.
   DEFINE INPUT PARAMETER inPagenumber AS INTEGER   NO-UNDO. /*����� ��࠭���*/
		 /*�⮣� �� ���-䠪��ࠬ*/	
   DEFINE VARIABLE iVal_m AS DECIMAL NO-UNDO EXTENT 9. /*�� ���㫨஢��.*/
   DEFINE VARIABLE iVal_a AS DECIMAL NO-UNDO EXTENT 9. /*���㫨஢��. */
   DEFINE VARIABLE iVal_i AS DECIMAL NO-UNDO EXTENT 9. /*��ࠢ�⥫��*/
   DEFINE VARIABLE iValStr AS CHARACTER NO-UNDO.

   DEFINE VARIABLE ii     AS INTEGER NO-UNDO.

   DEFINE BUFFER iTmpDataline FOR TmpDataLine. 
   /*������ �⮣� ��� ���-䠪��� (�� ���㫨஢�����) */
   RUN CalcTotals(inDataBlock,OUTPUT iValStr).
   FOR EACH DataLine
   WHERE DataLine.Data-ID EQ INTEGER(inDataBlock)
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
               iVal_a[6]             = iVal_a[6] +  DataLine.Val[4]
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
      "�த��� �� ��ਮ� � " + STRING(bDB.Beg-Date,"99/99/9999") + " �� " + STRING(bDB.end-Date,"99/99/9999") SKIP
      "                    ����������    ����������" SKIP(3)
   .
   /*����� ��������*/
   PUT STREAM sfact UNFORMATTED
      "������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ŀ" SKIP
      "� ��� � �����  �    ������������     �     ���      �     ���      �  ���    ��ᥣ� �த�� �                                        � ⮬ �᫥                                                            �" SKIP
      "� ���-䠪���� �     ���㯠⥫�      �  ���㯠⥫�  �  ���㯠⥫�  � ������   � ������ ��� ���������������������������������������������������������������������������������������������������������������Ĵ" SKIP
      "�   �த���    �                     �              �              � ���-   �             �                            �த���, ��������� ������� �� �⠢��                                �  �த���,   �" SKIP
      "�               �                     �              �              � 䠪����  �             �������������������������������������������������������������������������������������������������Ĵ�᢮�������륳" SKIP
      "�               �                     �              �              � �த��� �             �       18 ��業⮢        �       10 ��業⮢        � 0 ��業⮢ �       20 ��業⮢*       �  �� ������  �" SKIP
      "�               �                     �              �              �          �             �������������������������������������������������������������������������������������������������Ĵ             �" SKIP
      "�               �                     �              �              �          �             ��⮨����� ��-� �㬬� ���   ��⮨����� ��-� �㬬� ���   �             ��⮨����� ��-� �㬬� ���   �             �" SKIP
      "�               �                     �              �              �          �             ����� ��� ��� �             ����� ��� ��� �             �             ����� ��� ��� �             �             �" SKIP
      "������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
      "�     (1)       �         (2)         �     (3)      �     (3�)     �   (3�)   �     (4)     �     (5�)    �     (5�)    �     (6�)    �     (6�)    �     (7)     �     (8�)    �     (8�)    �     (9)     �" SKIP
      "������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
   .
   /*�����*/
   PUT STREAM sfact UNFORMATTED
      "������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
      "�                                                                        �����:�" + 
      STRING(DEC(ENTRY(1,iValStr)),">>,>>>,>>9.99") + "�" +
      STRING(DEC(ENTRY(2,iValStr)),">>,>>>,>>9.99") + "�" +
      STRING(DEC(ENTRY(3,iValStr)),">>,>>>,>>9.99") + "�" +
      STRING(DEC(ENTRY(4,iValStr)),">>,>>>,>>9.99") + "�" +
      STRING(DEC(ENTRY(5,iValStr)),">>,>>>,>>9.99") + "�" +
      STRING(DEC(ENTRY(6,iValStr)),">>,>>>,>>9.99") + "�" +
      STRING(DEC(ENTRY(7,iValStr)),">>,>>>,>>9.99") + "�" +
      STRING(DEC(ENTRY(8,iValStr)),">>,>>>,>>9.99") + "�" +
      STRING(DEC(ENTRY(9,iValStr)),">>,>>>,>>9.99") + "�" SKIP
      "������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
   .
   FOR EACH tmpDataLine WHERE tmpDataLine.isprav EQ "���㫨�" NO-LOCK BREAK BY tmpDataLine.Data-ID:
      mNamePostav =  SplitStr(ENTRY(1,tmpDataLine.Txt,"~n"),
                              21,
                             "~n").

      mNums       =  SplitStr(ENTRY(6,tmpDataLine.Txt,"~n") + " " 
                            + ENTRY(8,tmpDataLine.Txt,"~n"),
                              15,
                              "~n").
      mAmt = SplitStr(STRING(tmpDataLine.Val[11],">>,>>>,>>9.99") + " " 
                           + ENTRY(7,tmpDataLine.Txt,"~n"),
                             13,
                             "~n").

      PUT STREAM sfact UNFORMATTED
         "�" +
         STRING(ENTRY(1,mNums,"~n"),"x(15)") + "�" +
         STRING(ENTRY(1,mNamePostav,"~n"),"x(21)") + "�" +
         STRING(ENTRY(2,tmpDataLine.Txt,"~n"),"x(14)") + "�" +
         STRING(ENTRY(3,tmpDataLine.Txt,"~n"),"x(14)") + "�" +
         STRING(tmpDataLine.Sym2,"x(10)") + "�" +
         STRING(DEC(ENTRY(1,mAmt,"~n")),">>,>>>,>>9.99") + "�" +
         STRING(tmpDataLine.Val[1],">>,>>>,>>9.99") + "�" +
         STRING(tmpDataLine.Val[2],">>,>>>,>>9.99") + "�" +
         STRING(tmpDataLine.Val[3],">>,>>>,>>9.99") + "�" +
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
      FOR EACH iTmpDataLine WHERE iTmpDataLine.cont-code EQ STRING(TmpDataLine.sym3) NO-LOCK BREAK BY iTmpDataLine.Data-ID:         
         
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
            STRING(iTmpDataLine.Val[1],">>,>>>,>>9.99") + "�" +
            STRING(iTmpDataLine.Val[2],">>,>>>,>>9.99") + "�" +
            STRING(iTmpDataLine.Val[3],">>,>>>,>>9.99") + "�" +
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
            iVal_i[6] = iVal_i[6] +  iTmpDataLine.Val[4]
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
      iVal_m[ii] = DEC(ENTRY(ii,iValStr)).
      iVal_m[ii] = iVal_m[ii] - iVal_a[ii] + iVal_i[ii].
   END.

   iValStr = string(iVal_m[1]) + "," + string(iVal_m[2]) + "," + string(iVal_m[3]) + "," + 
             string(iVal_m[4]) + "," + string(iVal_m[5]) + "," + string(iVal_m[6]) + "," + 
             string(iVal_m[7]) + "," + string(iVal_m[8]) + "," + string(iVal_m[9]).

   PUT STREAM sfact UNFORMATTED
      "������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
      "�                                                                        �ᥣ�:�" + 
      STRING(DEC(ENTRY(1,iValStr)),">>,>>>,>>9.99") + "�" +
      STRING(DEC(ENTRY(2,iValStr)),">>,>>>,>>9.99") + "�" +
      STRING(DEC(ENTRY(3,iValStr)),">>,>>>,>>9.99") + "�" +
      STRING(DEC(ENTRY(4,iValStr)),">>,>>>,>>9.99") + "�" +
      STRING(DEC(ENTRY(5,iValStr)),">>,>>>,>>9.99") + "�" +
      STRING(DEC(ENTRY(6,iValStr)),">>,>>>,>>9.99") + "�" +
      STRING(DEC(ENTRY(7,iValStr)),">>,>>>,>>9.99") + "�" +
      STRING(DEC(ENTRY(8,iValStr)),">>,>>>,>>9.99") + "�" +
      STRING(DEC(ENTRY(9,iValStr)),">>,>>>,>>9.99") + "�" SKIP
      "��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������" SKIP
   .
	/** BEP000003: 13.04.2007 12:07 
   {signatur.i
      &stream="STREAM sfact"}
  */
  
  /** BEP000003: 13.04.2007 12:07 */
	PUT STREAM sfact UNFORMATTED
   SKIP(3)
   "������ ��壠���                      " + mBuhName SKIP
   "                  �������������������� ���������������������������������������" SKIP
   "                      (�������)                        (�. �. �.)             " SKIP(2)
   "�������㠫�� �।�ਭ���⥫� ____________________ _______________________________________" SKIP 
   "                                     (�������)                        (�. �. �.)             " SKIP(2)
   "��������� ᢨ��⥫��⢠ � ���㤠��⢥����" SKIP
   "ॣ����樨 �������㠫쭮�� �।�ਭ���⥫� ____________________________________________________" SKIP(3)
   "_________________________" SKIP
   "* �� �����襭�� ���⮢ �� ⮢�ࠬ (ࠡ�⠬, ��㣠�), ���㦥��� (�믮������, �������) �� 1 ﭢ��� 2004 �." SKIP
	.
	/** BEP000003: end */
  
END PROCEDURE.


/*������ �⮣� (�㬬� ��⮢-䠪���)*/
PROCEDURE CalcTotals:
   DEFINE INPUT  PARAMETER inDataBlock AS CHARACTER NO-UNDO.
   DEFINE OUTPUT PARAMETER oValStr     AS CHARACTER NO-UNDO. /*�㬬�
                                                              ���-䠪���*/
   DEF VAR vVal_m      AS DECIMAL   NO-UNDO EXTENT 9. /*�㬬�
                                                        ���-䠪���*/

   FOR EACH DataLine
      WHERE DataLine.Data-ID EQ INTEGER(inDataBlock)
      NO-LOCK:
      IF NUM-ENTRIES(DataLine.Txt,"~n") < 9 OR ENTRY(9,DataLine.Txt,"~n") <> "��ࠢ" THEN
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
      vVal_m[6] = ACCUM TOTAL DataLine.Val[4]
      vVal_m[7] = ACCUM TOTAL DataLine.Val[7]
      vVal_m[8] = ACCUM TOTAL DataLine.Val[8]
      vVal_m[9] = ACCUM TOTAL DataLine.Val[9]
   .
   oValStr = STRING(vVal_m[1]) + "," + STRING(vVal_m[2]) + "," + STRING(vVal_m[3]) + "," + 
             STRING(vVal_m[4]) + "," + STRING(vVal_m[5]) + "," + STRING(vVal_m[6]) + "," + 
             STRING(vVal_m[7]) + "," + STRING(vVal_m[8]) + "," + STRING(vVal_m[9]).

END PROCEDURE.
