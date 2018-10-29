{pirsavelog.p}


/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2004 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: pirreedpsa.p
      Comment: ����� ॥��� ��易⥫��� ����� ��� �����稪���
   Parameters:
         Uses:
      Used by:
      Created: 18.08.2004 15:36 FEAK    
     Modified: 19.08.2004 15:00 FEAK     
     Modified: 11.03.2005 12:58 SAP      
     Modified: 14.03.2005 09:33 SAP      
     Modified: 
*/

DEFINE INPUT PARAMETER in-data-id LIKE DataBlock.Data-Id NO-UNDO.

{globals.i}
{wordwrap.def}
{norm.i}
{repinfo.i}
{intrface.get xclass}
{intrface.get strng}
{intrface.get cdrep}
{bank-id.i}

{get-bankname.i}

&glob STREAM STREAM mStr
&glob COLS 306

DEF VAR vMaxLines AS INTEGER NO-UNDO. 
DEF VAR mString AS CHAR EXTENT 12 NO-UNDO. 
DEF VAR mLength AS INT EXTENT 12 NO-UNDO. 
DEF VAR mS AS CHAR EXTENT 11 NO-UNDO.
DEF VAR i AS INTEGER NO-UNDO.
DEF VAR mI AS INTEGER NO-UNDO.
DEF VAR j AS INTEGER NO-UNDO.
DEF VAR vSString AS CHAR NO-UNDO.
DEF VAR vAFlag AS LOGICAL NO-UNDO.
DEF VAR vBFlag AS LOGICAL NO-UNDO.
DEF VAR vChet AS LOGICAL NO-UNDO.
DEF VAR vCurSysNum AS CHAR NO-UNDO.
DEF VAR vRec1 AS RECID NO-UNDO.
DEF VAR vRec2 AS RECID NO-UNDO.
DEF VAR vMaxVzSum AS DEC FORMAT "->>>,>>>,>>9.99" NO-UNDO.
DEF VAR vDate AS DATE FORMAT "99/99/9999" NO-UNDO.
DEF VAR in-end-date AS DATE FORMAT "99/99/9999" NO-UNDO.
DEF VAR vBank AS CHAR NO-UNDO.
DEF VAR vAdress AS CHAR NO-UNDO.
DEF VAR vKolKl AS CHAR NO-UNDO.

DEF VAR vSumRubD AS dec NO-UNDO.
DEF VAR vSumCurrD AS dec NO-UNDO.
DEF VAR vSumRubC AS dec NO-UNDO.
DEF VAR vSumCurrC AS dec NO-UNDO.
DEF VAR vSumRubCC AS dec NO-UNDO.
DEF VAR vSumCurrCC AS dec NO-UNDO.

DEF VAR vSum17 AS dec NO-UNDO.
DEF VAR vSum18 AS dec NO-UNDO.
DEF {&STREAM}.

{fexp-chk.i
   &DataID = " in-Data-Id"}

FIND FIRST DataBlock WHERE DataBlock.Data-Id EQ in-Data-Id NO-LOCK.
IF AVAIL DataBlock THEN
   ASSIGN vDate = DataBlock.End-Date.

/*vBank  = "�������᪨� ���� �஬�諥���-������樮���� ���⮢ " + chr(34) + "�p������������" + chr(34) + "(����⢮ � ��࠭�祭��� �⢥��⢥�������)".*/
vBank = cBankNameFull.
vAdress  = FGetSetting( "����_��", "", "" ).


DO
ON ERROR UNDO, LEAVE
ON ENDKEY UNDO, LEAVE
WITH FRAME fr1
   CENTERED
   ROW 10
   OVERLAY
   SIDE-LABELS
   1 COL
   COLOR MESSAGES
   TITLE "[ ������������ ����� ���������� ]":

vMaxVzSum = 700000.
   DISPLAY vMaxVzSum.

   UPDATE
      vMaxVzSum
         LABEL "�㬬� �����饭��:"
         HELP  "������ ���ᨬ����� �㬬� �����饭��."

    EDITING:
        READKEY.
        APPLY LASTKEY.
    END.   
END.

HIDE FRAME fr1 NO-PAUSE.

IF KEYFUNC(LASTKEY) EQ "end-error"
THEN RETURN.

 &IF DEFINED(REEDPSA_SAV) &THEN
  in-end-date= DataBlock.End-Date.
  {pirraproc.def}
  {pirraproc.i &arch_file_name="ree_vkl.txt"}
  {setdest.i  &filename=arch_file_name}
 &ELSE
  {setdest.i '&stream={&STREAM}' &filename="reestr.txt"}
 &ENDIF

/*����祭�� ������ �� ����� ������ - ?*/
{pirree_dps.i}

ASSIGN 
   mString[1] = ""
   mString[2] = "" 
   mString[3] = ""
   mString[4] = "" 
   mString[5] = ""
   mString[6] = ""
   mLength[1] = 6
   mLength[2] = 18
   mLength[3] = 20
   mLength[4] = 25
   mLength[5] = 16
   mLength[6] = 16
   
      .

ASSIGN 
   vMaxLines = 1
   j = 1
   i = 1
   .
   
/*�뢮� ४����⮢ �����*/

PUT {&STREAM} UNFORMATTED 
   SKIP(1)
   fStrCenter ("������ ��易⥫��� ����� ��। �����稪���, �।�⠢�塞� �� �㬠���� ���⥫�", {&COLS}) SKIP 
   fStrCenter ("�� ���ﭨ� �� " + STRING (vDate + 1), {&COLS}) SKIP(1).

PUT {&STREAM} UNFORMATTED
   "�������� � �����" SKIP
   "������������ �����:  " vBank SKIP
   "���⮢� ����:  " vAdress SKIP
   "�������樮��� �����:  " bank-regn SKIP(1).

/*�뢮� 蠯��*/

PUT {&STREAM} UNFORMATTED
   "����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ŀ" SKIP
   "������ �      �.�.�.      �       ����        �        ��� ���� �       �                                            ��易⥫��⢠ �����                                   �                                               ������ �ॡ������                               �     �㬬�      �     �㬬�,     �" SKIP
   "������-�                  �     ॣ����-      �         ४������       �����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ  ��易⥫���  �   ���������   �" SKIP     
   "� 稪� �                  �      樨, ���      �        ���㬥��,       �       �����        �   ���   � ���浪��멳       �����        �     �㬬�      �     �㬬�      �       �����        �   ���   � ���浪��멳       �����        �     �㬬�      �     �㬬�      �       ��       �   ���客���   �" SKIP
   "�  ��  �                  �      ���⮢��      �        㤮�⮢���-      �     ���㬥��      ����㬥��,�   �����   �      ��楢���      �       �        �       �        �     ���㬥��,     ����㬥��,�   �����   �      ��楢���      �       �        �       ��       �     �������    �   �����饭��   �" SKIP
   "�॥��-�                  �     㢥�����-      �           �饣�         �        ��          �    ��    � 䨫����,  �       ���        �     �����     �     �㡫��     �         ��         �    ��    �  䨫����, �       ���        �     �����     �   ������    �       ��       �                �" SKIP
   "�  ��  �                  �        ���,        �         ��筮���        �     �᭮�����      ��᭮����� � �����稢- �        ���         �  ��易⥫���  �       ��       �     �᭮�����      � �᭮������ �����稢- �        ���         �   �ॡ������   �  �ॡ������   �     ���⮬    �                �" SKIP
   "���易-�                  �      ⥫�䮭,      �                         �      ���ண�      � ���ண� �    襣�   �       ���        �                �     �����      �      ���ண�      � ���ண� �   襣�    �       ���        �                �       �        �      �㬬�     �                �" SKIP
   "�⥫���                  �     ���஭-      �                         �       �ਭ��       �  �ਭ��  �  �������  �    ��易⥫���    �                �     �����      �      ��������      � �������� �  �������  �     �������      �                �     �㡫��     �    �������   �                �" SKIP
   "�  �   �                  �     ��� ����      �                         �       �����        �   �����  �           �                    �                �     ���ᨨ     �     �ॡ������     ��ॡ�������           �    �ॡ������      �                �       ��       �   �ॡ������   �                �" SKIP
   "�      �                  �                    �                         �                    �          �           �                    �                �                �                    �          �           �                    �                �     �����      �                �                �" SKIP
   "�      �                  �                    �                         �                    �          �           �                    �                �                �                    �          �           �                    �                �     �����      �                �                �" SKIP
   "�      �                  �                    �                         �                    �          �           �                    �                �                �                    �          �           �                    �                �     ���ᨨ     �                �                �" SKIP
   "����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
   "�  1   �        2         �         3          �           4             �         5          �    6     �     7     �          8         �       9        �       10       �         11         �    12    �    13     �         14         �       15       �       16       �       17       �       18       �" SKIP.

   
FOR EACH ttRee BY ttRee.id:

   ASSIGN
      i = 0
      j = 1
      vMaxLines = 0
      mString[5] = "0"
      mString[6] = "0"
      mString[1] = /* STRING(ttRee.id)  string(INT(ttRee.SysNum),">>>>>9")*/ string(ttRee.SysNum)
      mString[2] = ttRee.FIO
      mString[3] = ttRee.AdressReq + ", " + ttRee.AdressPos + ", " + ttRee.Phone + ", " + ttRee.Email
      mString[4] = ttRee.DocTypeCode + ", " + ttRee.DocNum + ", " + ttRee.KemVidano
      vKolKl = STRING(ttRee.id)
      .
  

     vSumRubC = 0.
     vSumCurrC = 0.  
   FOR EACH ttReeLoan WHERE ttReeLoan.SysNum EQ ttRee.SysNum:
      IF ttReeLoan.Symbol = "�" THEN
         ASSIGN 
            mString[5] = STRING(DEC(mString[5]) + ttReeLoan.SumInRur,"->>>,>>>,>>9.99")
	    .
      ELSE IF ttReeLoan.Symbol = "�" THEN
         ASSIGN 
            mString[5] = STRING(DEC(mString[5]) - ttReeLoan.SumInRur,"->>>,>>>,>>9.99")
            . 
   END.

   IF DEC(mString[5]) LT 0 THEN
      ASSIGN mString[5] = STRING(0).
  
 /*���� ��ਠ��
   IF DEC(mString[5]) LE 100000.00 THEN
      ASSIGN mString[6] = mString[5].
   IF DEC(mString[5]) GT 100000.00 and  DEC(mString[5]) LE vMaxVzSum THEN
      mString[6] = STRING(100000.00 + ((dec(mString[5]) - 100000.00) / 100 * 90),"->>>,>>>,>>9.99").
*/

/*�ନ��� �.�.: ���� ��ਠ�� � ᮮ⢥��⢨� � ��������ﬨ  N 174-�� �� 13 ������ 2008  */
   IF DEC(mString[5]) LE vMaxVzSum THEN
      ASSIGN mString[6] = mString[5].

   IF DEC(mString[5]) GT vMaxVzSum THEN
      ASSIGN mString[6] = STRING(vMaxVzSum,"->>>,>>>,>>9.99").
      
  vSum17 = dec(mString[5]) + vSum17.
  vSum18 = dec(mString[6]) + vSum18.

   /*���� ���-�� ᨬ����� ��� ������*/
   DO i = 1 TO 10:
      ASSIGN mS[1] = mString[i]
      {wordwrap.i &s = mS
                  &n = 10
                  &l = mLength[i]}
      DO WHILE mS[j] NE "":
         ASSIGN j = j + 1.
      END.
      IF j GT vMaxLines THEN
         ASSIGN vMaxLines = j - 1.
   END.
   ASSIGN j = 0.
   FOR EACH ttReeLoan WHERE ttReeLoan.SysNum EQ ttRee.SysNum
                        AND ttReeLoan.Symbol EQ "�":
      ASSIGN j = j + 2.
   END.
   IF j GT vMaxLines THEN
         ASSIGN vMaxLines = j - 1.
   ASSIGN j = 0.
   FOR EACH ttReeLoan WHERE ttReeLoan.SysNum EQ ttRee.SysNum
                        AND ttReeLoan.Symbol EQ "�":
      ASSIGN j = j + 2.
   END.
   IF j GT vMaxLines THEN
         ASSIGN vMaxLines = j - 1.

   PUT {&STREAM} UNFORMATTED
      "����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP.

   DO j = 1 TO vMaxLines: /*横� �� ��ப��*/
      DO i = 1 TO 4:      /*横� �� ����⠬... 1-2-3...*/
         ASSIGN mS[1] = mString[i]. /*��࠭塞 ��� ���饩 ��१��*/
         {wordwrap.i &s = mS
                     &n = 2
                     &l = mLength[i]
         }
         ASSIGN mString[i] = mS[2]. /*��१���, ⥯��� �� �� �� ������������ ��࠭塞 
                                      ��� ���饣� 蠣� �� ��ப��*/
         RUN Cutter (mLength[i], 1, NO).

         /*�������� �஡���� �� �㦭��� ������⢠*/
         PUT {&STREAM} UNFORMATTED "�" mS[1]. /*�뢥�� ᠬ� �����*/
      END.

      /*⥯��� �㤥� �뢮���� �।��� � ��������*/
         ASSIGN VAFlag = NO.
         IF ((j / 2) - TRUNCATE (j / 2, 0)) NE 0 THEN
            FIND FIRST ttReeLoan WHERE ttReeLoan.SysNum EQ ttRee.SysNum
                                  AND ttReeLoan.Symbol EQ "�" NO-ERROR.
         ELSE 
            FIND LAST ttReeLoan WHERE RECID(ttReeLoan) EQ vRec1 NO-ERROR.
         IF AVAIL ttReeLoan THEN
         DO:
            ASSIGN
               vRec1 = RECID(ttReeLoan)
               VAFlag = YES
               ttReeLoan.Symbol = "�"
               .

            ASSIGN
               mString[7] = ttReeLoan.ContNum
               mLength[7] = 20
               mString[8] = ttReeLoan.ContDate
               mLength[8] = 10
               mString[9] = ttReeLoan.BankRegNum
               mLength[9] = 11
               mString[10] = ttReeLoan.AcctNum
               mLength[10] = 20
               mString[11] = STRING(ttReeLoan.SumInCurr,"->>>,>>>,>>9.99")
               mLength[11] = 16
               mString[12] = STRING(ttReeLoan.SumInRur,"->>>,>>>,>>9.99")
               mLength[12] = 16
               .
       
            DO i = 1 TO 6:
               ASSIGN mS[1] = mString [(i + 6)].
               RUN Cutter (mLength[(i + 6)], 1, YES).
               ASSIGN mString [(i + 6)] = mS[1].
            END.

            IF ((j / 2) - TRUNCATE (j / 2, 0)) NE 0 THEN
	      do:
            /*�뢮��� �� 蠣�� ���� �� ������*/
               ASSIGN 
                  vSString = "�" + mString[7] + 
                             "�" + mString[8] +
                             "�" + mString[9] +
                             "�" + mString[10] + 
                             "�" + mString[11] + 
                             "�" + mString[12] + ""
                  vChet = NO.
		  vSumCurrD = dec(mString[11]) + vSumCurrD.
		  vSumRubD = dec(mString[12]) + vSumRubD.
	      end.	  
            ELSE IF (((j / 2) - TRUNCATE (j / 2, 0)) EQ 0) AND j NE vMaxLines THEN
               ASSIGN 
                  vSString = "���������������������������������������������������������������������������������������������������"
                  vChet = YES
                  vAFlag = YES
                  .
            ELSE
               ASSIGN 
                  vSString = "�                    �          �           �                    �                �                "
                  vChet = YES
                  vAFlag = NO.
         END.
         ELSE
         DO:
            ASSIGN
               vRec1 = 000000
               VAFlag = NO
               .
            PUT {&STREAM} UNFORMATTED
               "�                    �          �           �                    �                �                ".
         END.

         IF ((j / 2) - TRUNCATE (j / 2, 0)) NE 0 THEN
            FIND FIRST ttReeLoan WHERE ttReeLoan.SysNum EQ ttRee.SysNum
                                  AND ttReeLoan.Symbol EQ "�" NO-ERROR.
         ELSE 
            FIND LAST ttReeLoan WHERE RECID(ttReeLoan) EQ vRec2 NO-ERROR.
         IF AVAIL ttReeLoan THEN
         DO:
            ASSIGN 
               vRec2 = RECID(ttReeLoan)
               ttReeLoan.Symbol = "�"
               vBFlag = YES
               .
            ASSIGN
               mString[7] = ttReeLoan.ContNum
               mLength[7] = 20
               mString[8] = ttReeLoan.ContDate
               mLength[8] = 10
               mString[9] = ttReeLoan.BankRegNum
               mLength[9] = 11
               mString[10] = ttReeLoan.AcctNum
               mLength[10] = 20
               mString[11] = STRING(ttReeLoan.SumInCurr,"->>>,>>>,>>9.99")
               mLength[11] = 16
               mString[12] = STRING(ttReeLoan.SumInRur,"->>>,>>>,>>9.99")
               mLength[12] = 16
	       .
	       
/* 	       if dec(mString[11]) NE 0 then 
	       vSumCurrC = dec(mString[11]) + vSumCurrC.
	        else vSumCurrC = vSumCurrD.
               if dec(mString[12]) NE 0 then
	       vSumRubC = dec(mString[12]) + vSumRubC.
	        else vSumRubC = vSumRubC.
*/             
            DO i = 1 TO 6:
               ASSIGN mS[1] = mString [(i + 6)].
               RUN Cutter (mLength[(i + 6)], 1, YES).
               ASSIGN mString [(i + 6)] = mS[1].
            END.
            IF ((j / 2) - TRUNCATE (j / 2, 0)) NE 0 THEN
            DO:
               ASSIGN 
                  vSString = vSString + "�" + mString[7] + 
                             "�" + mString[8] +
                             "�" + mString[9] +
                             "�" + mString[10] + 
                             "�" + mString[11] + 
                             "�" + mString[12] + ""
                  .
		
 	       if dec(mString[11]) NE 0 then 
	       vSumCurrC = dec(mString[11]) + vSumCurrC.
	    else vSumCurrC = vSumCurrC.
               if dec(mString[12]) NE 0 then
	       vSumRubC = dec(mString[12]) + vSumRubC.
	        else vSumRubC = vSumRubC.

	    END.
            ELSE
            DO:
               IF vAFlag = YES THEN
                  ASSIGN vSString = vSString + "�".
               ELSE IF (j NE vMaxLines) AND (vAFlag = YES) THEN
                  ASSIGN vSString = vSString + "�".
               ELSE IF vAFlag = NO AND j NE vMaxLines THEN
                  ASSIGN vSString = vSString + "�".
               ELSE IF (j EQ vMaxLines) THEN
                  ASSIGN vSString = vSString + "�".
               ELSE
                  ASSIGN vSString = vSString + "�".
               IF j NE vMaxLines THEN
                  ASSIGN vSString = vSString + "��������������������������������������������������������������������������������������������������".
 
		  
               ELSE
                  ASSIGN 
                     vSString = vSString + "                    �          �           �                    �                �                "
                     vBFlag = NO.
            END.
         END.
         ELSE
         DO:
            ASSIGN 
               vRec2 = 000000
               vBFlag = NO
               .
            IF ((j / 2) - TRUNCATE (j / 2, 0)) NE 0 THEN
               ASSIGN vSString = vSString + "�                    �          �           �                    �                �                ".
            ELSE
            DO:
               IF vAFlag = YES THEN
                  ASSIGN vSString = vSString + "�".
               ELSE
                  ASSIGN vSString = vSString + "�".
               ASSIGN vSString = vSString + "                    �          �           �                    �                �                ".
            END.
         END.

      PUT {&STREAM} UNFORMATTED vSString.

      IF j = vMaxLines THEN
      DO:
         IF ((j / 2) - TRUNCATE (j / 2, 0)) NE 0 THEN 
            ASSIGN vSString = "�".
         ELSE 
            IF vBFlag = YES THEN
               ASSIGN vSString = "�".
            ELSE 
               ASSIGN vSString = "�".      
         ASSIGN mS[1] = mString[5].
         RUN Cutter (mLength[5], 1, YES).    
         ASSIGN vSString = vSString + mS[1] + "�".
         ASSIGN mS[1] = mString[6].
         RUN Cutter (mLength[6], 1, YES). 
         ASSIGN vSString = vSString + mS[1] + "�".
      END.
      ELSE
      DO:
         IF ((j / 2) - TRUNCATE (j / 2, 0)) NE 0 THEN 
            ASSIGN vSString = "�".
         ELSE 
            IF vBFlag = YES THEN
               ASSIGN vSString = "�".
            ELSE
               ASSIGN vSString = "�".
         ASSIGN vSString = vSString + "                �                �".
      END.
      PUT {&STREAM} UNFORMATTED vSString SKIP.
      ASSIGN vSString = "".
   END.
   	vSumCurrCC = vSumCurrCC + vSumCurrC.	
        vSumRubCC = vSumRubCC + vSumRubC.	

END.


PUT {&STREAM} UNFORMATTED
   "������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������" SKIP(2)

/*   "����� �����⮢: " vKolKl "   ����� � ����� ��易⥫���: "  STRING(vSumCurrD,"->>>,>>>,>>>,>>9.99") " ����� � �㡫�� ��易⥫���: "  STRING(vSumRubD,"->>>,>>>,>>>,>>9.99") "   ����� � ����� �� �ॡ������: "  STRING(vSumCurrCC,"->>>,>>>,>>>,>>9.99") " ����� � �㡫�� �� �ॡ������: "  STRING(vSumRubCC,"->>>,>>>,>>>,>>9.99")    "  ����� ��易⥫���: "  STRING(vSum17,"->>>,>>>,>>>,>>9.99")"  ����� ���客����: "  STRING(vSum18,"->>>,>>>,>>>,>>9.99") skip(2) */

   STRING (dept.mgr-title,"x(40)") " " STRING (dept.mgr-name,"x(50)") " ��� ��⠢����� " STRING (vDate,"99/99/9999") SKIP (2)
   STRING (dept.cfo-title,"x(40)") " " STRING (dept.cfo-name,"x(50)") " ��� �����ᠭ��  ____________"                 SKIP (2)
   "      �.�." SKIP (2)
   STRING ( "�ᯮ���⥫�", "x(40)" ) " " LN_GetUserName (USERID ("bisquit"))  SKIP
   "����䮭 " telefon (USERID ("bisquit")) SKIP ( 1 ).


/* {signatur.i &stream="{&STREAM}"} */

 &IF DEFINED(REEDPSA_SAV) &THEN
  {preview.i &stream="{&STREAM}" &filename=arch_file_name}
 &ELSE
  {preview2.i &stream="{&STREAM}"}
 &ENDIF



PROCEDURE Cutter.

DEF INPUT PARAM iStr AS INTEGER.
DEF INPUT PARAM iNum AS INTEGER.
DEF INPUT PARAM iFwd AS LOGICAL.

ASSIGN mI = 1.
REPEAT WHILE mI LE iNum:
   IF mS[mI] NE ? THEN
      IF iFwd EQ NO THEN
         ASSIGN 
            mS[mI] = mS[mI] + FILL (" ", (iStr - LENGTH(mS[mI]))).
      ELSE
         ASSIGN 
            mS[mI] = FILL (" ", (iStr - LENGTH(mS[mI]))) + mS[mI].
   ELSE
      ASSIGN 
         mS[mI] = FILL (" ", iStr).
   IF LENGTH(mS[mI]) GT iStr THEN 
      mS[mI] = SUBSTRING (mS[mI], 1, iStr).
   ASSIGN mI = mI + 1.  
END.

END PROCEDURE.
