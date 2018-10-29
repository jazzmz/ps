{pirsavelog.p}

/* ------------------------------------------------------
File          : $RCSfile: pirreedpsp.p,v $ $Revision: 1.7 $ $Date: 2009-04-23 17:04:48 $
Copyright     : ��� �� "�p������������"
���������    : reedpsp.p.
��稭�       :  
���� ����᪠ : ���� ��᪢��
����         : $Author: ermilov $
���������     : $Log: not supported by cvs2svn $
���������     : Revision 1.6  2008/03/18 09:27:35  kuntash
���������     : dorabotka itoga
���������     :
���������     : Revision 1.5  2008/01/28 15:25:55  kuntash
���������     : dorabotka 1927-u
���������     :
���������     : Revision 1.4  2007/10/18 07:42:24  anisimov
���������     : no message
���������     :
���������     : Revision 1.3  2007/09/10 08:26:09  kuntash
���������     : доработка 101 расп
���������     :
���������     : Revision 1.2  2007/09/10 12:44:53  kuntash
���������     : 1. �� �롮� ��᪮�쪨� �����稪�� ⠡��� ttReeLoan ᮧ������ ��᪮�쪮 ࠧ, �� ᮧ���� �㡫�஢����
���������     : ������ � ��ண� ���⭨��. ��७�ᥭ� ��楤�� ���������� ⠡���� {pirree_dps.i} �� ���� ������.
------------------------------------------------------ */
/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2004 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: reedpsp.p
      Comment: ����� �믨᪨ �� ॥��� ��易⥫��� ����� ��� �����稪���
   Parameters:
         Uses:
      Used by:
      Created: 18.08.2004 15:36 FEAK    
     Modified: 19.08.2004 15:00 FEAK     
     Modified: 
*/            
                                                    
DEFINE INPUT PARAMETER in-data-id LIKE DataBlock.Data-Id NO-UNDO.

{globals.i}
{wordwrap.def}
{norm.i}
{repinfo.i}
{intrface.get xclass}
{intrface.get strng}
{bank-id.i} 
{tmprecid.def}        /** �ᯮ��㥬 ���ଠ�� �� ��㧥� */

&glob STREAM STREAM mStr

DEF VAR vMaxLines AS INTEGER NO-UNDO.
DEF VAR mString AS CHAR EXTENT 12 NO-UNDO. 
DEF VAR mLength AS INT EXTENT 12 NO-UNDO.
DEF VAR mS AS CHAR EXTENT 10 NO-UNDO.
DEF VAR i AS INTEGER NO-UNDO.
DEF VAR j AS INTEGER NO-UNDO.
DEF VAR mI AS INTEGER NO-UNDO.
DEF VAR vSString AS CHAR NO-UNDO.
DEF VAR vMaxVzSum AS DEC FORMAT "->>>,>>>,>>9.99" NO-UNDO.
DEF VAR vDate AS DATE FORMAT "99/99/9999" NO-UNDO.
DEF VAR vBank AS CHAR NO-UNDO.
DEF VAR vAdress AS CHAR NO-UNDO.
DEF VAR vCurSumd AS DEC NO-UNDO.
DEF VAR vCurSumk AS DEC NO-UNDO.
DEF VAR vPers AS CHAR NO-UNDO.
DEF VAR vUNKg AS CHAR NO-UNDO.
DEF VAR vRecId AS RECID NO-UNDO.
DEF {&STREAM}.

{fexp-chk.i
   &DataID = " in-Data-Id"}

FIND FIRST DataBlock WHERE DataBlock.Data-Id EQ in-Data-Id NO-LOCK.
IF AVAIL DataBlock THEN
   ASSIGN vDate = DataBlock.End-Date.

{get-bankname.i}
vBank = cBankNameFull.
/*vBank  = "�������᪨� ���� �஬�諥���-������樮���� ���⮢ " + chr(34) + "�p������������" + chr(34) + "(����⢮ � ��࠭�祭��� �⢥��⢥�������)".*/
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
 vMaxVzSum=700000.
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

RUN browseld.p ("person",
                "crclass-code",
                "*",
                ?,
                3).

IF LASTKEY NE 10 AND LASTKEY NE 13 THEN RETURN.
IF NOT CAN-FIND (FIRST tmprecid) THEN DO:
    MESSAGE "��� ��࠭��� �����⮢"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN.
END.

{setdest.i &stream="stream mStr" &filename='reedpsp.tmp'}
{pirree_dps.i}
   
for each tmprecid:
   find first person where recid(person) = tmprecid.id no-lock.
   ASSIGN vUNKg = STRING(INT(GetXAttrValue("person",string(person.person-id),"���"))).
   
   /*����祭�� ������ �� ����� ������ - ?*/


   FIND FIRST ttRee WHERE string(int(ttRee.SysNum)) EQ vUNKg NO-ERROR.
   
   IF AVAIL ttRee THEN
   DO: 
      PUT {&STREAM} UNFORMATTED
      "        �믨᪠ �� ॥��� ��易⥫��� ����� ��। �����稪���" SKIP(1).
      PUT {&STREAM} UNFORMATTED
      "�������� � �����" SKIP
      "������������ �����:  " vBank SKIP
      "���⮢� ����:  " vAdress SKIP
      "�������樮��� �����:  " bank-regn SKIP(1).

      ASSIGN 
         mString[1] = /* STRING(ttRee.id)  string(int(ttRee.SysNum),">>>>>>9")*/ string(ttRee.SysNum)
         mString[2] = ttRee.FIO
         mString[3] = ttRee.AdressReq + ", " + ttRee.AdressPos + ", " + ttRee.Phone + ", " + ttRee.Email
         mString[4] = ttRee.DocTypeCode + ", " + ttRee.DocNum + ", " + ttRee.KemVidano
         mLength[1] = 10
         mLength[2] = 20
         mLength[3] = 30
         mLength[4] = 35
         vCurSumd = 0.
         vCurSumk = 0.
         .     
      PUT {&STREAM} UNFORMATTED
         "��������������������������������������������������������������������������������������������������Ŀ" SKIP
         "�  �����   �       �.�.�.       �      ���� ॣ����樨,      �       ��� ���� � ४������        �" SKIP
         "������稪� �                    �   ��� ���⮢�� 㢥��������,  �             ���㬥��,            �" SKIP
         "��� ॥����                    �           ⥫�䮭,           �      㤮�⮢����饣� ��筮���     �" SKIP
         "�  ��易-  �                    �      ���஭��� ����       �                                   �" SKIP
         "� ⥫���  �                    �                              �                                   �" SKIP
         "��������������������������������������������������������������������������������������������������Ĵ" SKIP.
      
      ASSIGN j = 1.     
      DO i = 1 TO 4:
         ASSIGN mS[1] = mString[i].
         {wordwrap.i &s = mS
                     &n = 10
                     &l = mLength[i]}
         DO WHILE mS[j] NE "":
            ASSIGN j = j + 1.
         END.
         IF j GT vMaxLines THEN
            ASSIGN vMaxLines = j - 1.
      END.
      
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
         PUT {&STREAM} UNFORMATTED "�" SKIP.
      END.
      PUT {&STREAM} UNFORMATTED
         "����������������������������������������������������������������������������������������������������" SKIP(1).
      
      /*��易⥫��⢠ �����*/
      FIND FIRST ttReeLoan WHERE ttReeLoan.SysNum EQ ttRee.SysNum
                           AND ttReeLoan.Symbol EQ "�" NO-ERROR.
      IF AVAIL ttReeLoan THEN
      DO:
         ASSIGN mString[6] = "".
         PUT {&STREAM} UNFORMATTED
            "�������� � ��������� ���客���� ��易⥫��⢠� ����� ��। �����稪��." SKIP(1).
      
         PUT {&STREAM} UNFORMATTED
            "���������������������������������������������������������������������������������������������������������Ŀ" SKIP
            "�� �/� �  ����� ���㬥��,  ���� ����-����浪��� �       �����        �     �㬬�      �      �㬬�     �" SKIP
            "�      �    �� �᭮�����    �����, �� �  �����    �      ��楢���      �    � �����    �    � �㡫��    �" SKIP
            "�      �      ���ண�      ��᭮����� � 䨫����,  �      ��� ���     �  ��易⥫���  �    �� �����    �" SKIP
            "�      �    �ਭ�� �����    � ���ண� � �����稢- �        ���       �                �     �����      �" SKIP
            "�      �                    �  �ਭ��  �   襣�    �    ��易⥫���    �                �     ���ᨨ     �" SKIP
            "�      �                    �  �����   �  �������  �                    �                �                �" SKIP
            "���������������������������������������������������������������������������������������������������������Ĵ" SKIP.
      
         FOR EACH ttReeLoan WHERE ttReeLoan.SysNum EQ ttRee.SysNum
                              AND ttReeLoan.Symbol EQ "�":
            ASSIGN 
               vCurSumd = vCurSumd + ttReeLoan.SumInRur
               vPers = vPers + ttReeLoan.ContNum + ","
               .
            ASSIGN
               mString[6] = STRING(INT(mString[6]) + 1)
               mLength[6] = 6
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
            DO i = 1 TO 7:
               ASSIGN mS[1] = mString [(i + 5)].
               RUN Cutter (mLength[(i + 5)], 1, YES).
               ASSIGN mString [(i + 5)] = mS[1].
            END.
            ASSIGN 
               vSString = "�" + mString[6] + 
                          "�" + mString[7] + 
                          "�" + mString[8] +
                          "�" + mString[9] +
                          "�" + mString[10] + 
                          "�" + mString[11] + 
                          "�" + mString[12] + "�"
               .
            PUT {&STREAM} UNFORMATTED vSString SKIP.
         END.         
         ASSIGN mS[1] = STRING(vCurSumd,"->>>,>>>,>>9.99").
         RUN Cutter (16, 1, YES).
      
         PUT {&STREAM} UNFORMATTED
            "���������������������������������������������������������������������������������������������������������Ĵ" SKIP
            "��⮣� ��易⥫��� (��.)                                                               �" mS[1] "�" SKIP
            "�����������������������������������������������������������������������������������������������������������" SKIP(1).
      END.
      
      /*������ �ॡ������*/
      
      PUT {&STREAM} UNFORMATTED
         "�������� � ������� �ॡ������� ����� � �����稪�." SKIP(1).
      
      PUT {&STREAM} UNFORMATTED
         "���������������������������������������������������������������������������������������������������������Ŀ" SKIP
         "�� �/� �  ����� ���㬥��,  ���� ����-����浪��� �       �����        �     �㬬�      �      �㬬�     �" SKIP
         "�      �    �� �᭮�����    �����, �� �  �����    �      ��楢���      �    � �����    �    � �㡫��    �" SKIP
         "�      �      ���ண�      ��᭮����� � 䨫����,  �      ��� ���     �   �ॡ������   �    �� �����    �" SKIP
         "�      �      ��������      � ���ண� � �����稢- �        ���       �                �     �����      �" SKIP
         "�      �     �ॡ������     � �������� �   襣�    �      �������     �                �     ���ᨨ     �" SKIP
         "�      �                    ��ॡ�������  �������  �     �ॡ������     �                �                �" SKIP
         "���������������������������������������������������������������������������������������������������������Ĵ" SKIP.
      
      ASSIGN mString[6] = "".
      FOR EACH ttReeLoan WHERE ttReeLoan.SysNum EQ ttRee.SysNum
                           AND ttReeLoan.Symbol EQ "�":
/*         IF LOOKUP(ttReeLoan.ContNum, vPers) NE 0 THEN NEXT.
*/
         ASSIGN 
            vCurSumk = vCurSumk + ttReeLoan.SumInRur
            vPers = vPers + ttReeLoan.ContNum + ","
            .
         ASSIGN
            mString[6] = STRING(INT(mString[6]) + 1)
            mLength[6] = 6
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
         DO i = 1 TO 7:
            ASSIGN mS[1] = mString [(i + 5)].
            RUN Cutter (mLength[(i + 5)], 1, YES).
            ASSIGN mString [(i + 5)] = mS[1].
         END.
         ASSIGN 
            vSString = "�" + mString[6] + 
                       "�" + mString[7] + 
                       "�" + mString[8] +
                       "�" + mString[9] +
                       "�" + mString[10] + 
                       "�" + mString[11] + 
                       "�" + mString[12] + "�"
            .
         PUT {&STREAM} UNFORMATTED vSString SKIP.
      END.      
      ASSIGN mS[1] = STRING(vCurSumk,"->>>,>>>,>>9.99").
      RUN Cutter (16, 1, YES).
      
      PUT {&STREAM} UNFORMATTED
         "���������������������������������������������������������������������������������������������������������Ĵ" SKIP
         "��⮣� ������� �ॡ������ (��.)                                                       �" mS[1] "�" SKIP
         "�����������������������������������������������������������������������������������������������������������" SKIP(1).
      
      IF vCurSumd EQ ? THEN
         ASSIGN vCurSumd = 0.
      IF vCurSumk EQ ? THEN
         ASSIGN vCurSumk = 0.
      ASSIGN vCurSumd = vCurSumd - vCurSumk.
      IF vCurSumd LT 0 THEN
         ASSIGN vCurSumd = 0.
      PUT {&STREAM} UNFORMATTED
         "�㬬� ��易⥫��� �� ������� �� ���⮬ �㬬� ������� �ॡ������ " SKIP
         "� �����稪� (��.)  " vCurSumd SKIP(1).


  /* IF vCurSumd LE 100000.00 THEN
      ASSIGN vCurSumk = vCurSumd.
   IF vCurSumd GT 100000.00 and  vCurSumd LE vMaxVzSum THEN
      vCurSumk = round(100000.00 + ((vCurSumd - 100000.00) / 100 * 90),2).
   IF vCurSumd GT vMaxVzSum THEN
      ASSIGN vCurSumk = vMaxVzSum.
     */

      IF vCurSumd LT vMaxVzSum THEN
         ASSIGN vCurSumk = vCurSumd.
      ELSE
         ASSIGN vCurSumk = vMaxVzSum.







      PUT {&STREAM} UNFORMATTED
         "�㬬�, ��������� ���客��� �����饭�� �����⢮� �� ���客����" SKIP
         "������� (��.)  " vCurSumk SKIP(3). 
      PAGE {&STREAM}.   
      ASSIGN vPers = "".
   END.
END.
{signatur.i &stream="{&STREAM}"}                               
{preview.i &stream="{&STREAM}" &filename='reedpsp.tmp'}


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
   ASSIGN mI = mI + 1.  
END.

END PROCEDURE.

