{pirsavelog.p}
/*                                2
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-1997 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: u205p7#1.P
      Comment: ��楤�� ���� ������ ��� ���� � ࠧ��饭���/�ਢ��祭���
               �।��
   Parameters:
         Uses:
      Used BY:
      Created: yuss 01.04.04
     Modified:
*/
/* ��� ��⮬���᪮�� ����᪠ �� �ਪ���  64 ��������஢�� ��ப�, ����� ������ ������ �� �ᥬ ��㫠� ��� ��� */
{sv-calc.i}
{intrface.get loan}
{intrface.get strng}

{pqtt.def &TABLE=acct} /* TEMP-TABLE � ROWD-��� acct � ��楤�� ��� �� ���������� */

RUN SetSysConf IN h_Base ("ReturnAcctRowid","YES").

{u205p7#1.def}

DEFINE VARIABLE i              AS INTEGER   NO-UNDO.
DEFINE VARIABLE j              AS INTEGER   NO-UNDO.
DEFINE VARIABLE ii             AS INTEGER   NO-UNDO.

/* ᯨ᮪ ���ࠧ������� � �⤥����ﬨ */
DEFINE VARIABLE mBrList AS CHAR NO-UNDO.
{getbrlst.i DataBlock.branch-id mBrList}

DEFINE VARIABLE vTmpChar             AS CHAR               NO-UNDO.
DEFINE VARIABLE vTmp1Char            AS CHAR               NO-UNDO.
DEFINE VARIABLE vTmpInt              AS INTEGER            NO-UNDO.

/* �⡮� ��� �� ��ࠬ���� �� ��⮤� ���� */
vParamCalcFormulaChar      = TRIM(REPLACE(GetEntries(1,param-calc,",",vParamCalcFormulaChar),";",",")).
IF vParamCalcFormulaChar   = "" THEN vParamCalcFormulaChar = "*".
vParamCalcClassSrokChar    = TRIM(GetEntries(2,param-calc,",",vParamCalcClassSrokChar)).
IF vParamCalcClassSrokChar = "" THEN vParamCalcClassSrokChar = "�ப���".
vParamCalcDescripChar      = TRIM(REPLACE(GetEntries(3,param-calc,",",""),";",",")).
IF vParamCalcDescripChar   = "" THEN vParamCalcDescripChar = "�ப,������,LastMov*,�ப����".

FIND FIRST DataLine OF DataBlock NO-LOCK NO-ERROR.

/* �⡮� ��⮢ �� �� ����稨 ����⠭���� ����� */
IF AVAIL DataLine THEN
DO:
   pick-value = "yes".
   
   /*  PIR Kuntashev 
   RUN message.p ("������ ��� �����ᮢ�� ��⮢ ?",
                  "",
                  "QUESTION",
                  "YES-NO",
                  "[ �������� �������� ]",
                  FALSE).

   IF LASTKEY = KEYCODE("ESC") THEN RETURN "error".
*/
   IF pick-value = "NO" THEN
   DO:
		DO	TRANSACTION:
			RUN u205p7b.p (in-data-id,1).
		END.
      IF LASTKEY = 13 OR LASTKEY = 10 AND pick-value <> "" THEN
      DO:
         vListCalcBalAcctChar = pick-value. /* �� ���� �������� */

         /* ��ਠ�� ������ */
         pick-value = "yes".
         vModFormLog = TRUE. /* TRUE   - formula - �⠭����� ���� */

         {empty TDataLine}

         FOR EACH DataLine OF DataBlock
            WHERE DataLine.Sym2 <> vCodeSym2Char [2] /* "_err" */
            NO-LOCK:  /* ���࠭���� ⥪�饣� ����� */

            ASSIGN
               vTmpInt  = NUM-ENTRIES(dataline.sym4) /* �ப,45206 - �뫠 ��ॠ��ᮢ�� */
               vTmpChar = IF vTmpInt > 1 THEN ENTRY(2,dataline.sym4) ELSE dataline.sym3
            .

            IF CAN-DO(vListCalcBalAcctChar,vTmpChar) THEN
            DO:
               IF NOT vModFormLog THEN           /* FALSE - ���� �� DataLine.Txt[1] */
               DO:
                  /* ��।������ ��६����� �� ���� */
                  vTmp1Char = ENTRY(1,DataLine.Txt,"~n").
                  { u205p7#a.fml &PARAMS=vTmp1Char }

                  ASSIGN
                     vCodeSrokChar = GetXAttrValueEx("bal-acct",vTmpChar,"�ப���", ?)
                     vCodeSrokChar = IF vCodeSrokChar = ? THEN "?" ELSE vCodeSrokChar
                  .

                  RUN CalcBalTdl (DataLine.Sym1,              /* �/� ��� */
                                  vTmpChar,                   /* ��� ��� */
                                  vCodeSrokChar,              /* �ப��� ��� */
                                  DataLine.Sym2,              /* ��� ����뢠����� �ப� */
                                  ENTRY(1,dataline.sym4),     /* ��� ���� */
                                  ENTRY(1,DataLine.Txt,"~n"), /* formula.formula */
                                  ENTRY(1,DataLine.Txt,"~n")  /* ��㫠 ��� ������ ��� */
                                  ).
               END.
            END.
            ELSE
            DO:
               CREATE TDataLine.
               buffer-copy DataLine TO TDataLine.
            END.
         END.
      END.
      ELSE
         RETURN "error".
   END.
END.

{justamin}

DEFINE STREAM s1.

OUTPUT STREAM s1 TO list.txt.

DEFINE STREAM fil2.

DEFINE VARIABLE temp-prot AS CHAR NO-UNDO.
temp-prot = "./" +  DataBlock.DataClass-id + ".log".
if opsys eq "unix" then unix silent rm -f value(temp-prot).
OUTPUT STREAM fil2 CLOSE .
OUTPUT STREAM fil2 TO VALUE(temp-prot) .

{setdest.i &stream="stream fil2" &filename=temp-prot }

DEF BUFFER xDataLine FOR TDataLine .

FIND FIRST DataLine OF DataBlock NO-LOCK NO-ERROR.

IF vModFormLog THEN           /* TRUE - formula - �⠭����� ���� */
DO:
   {u205p7#.fml}
   {u205p7#1.i}
END.

/* ��।������ '_err' */
RUN CalcErrTdl.

PAUSE 0.

OUTPUT STREAM s1   CLOSE.
OUTPUT STREAM fil2 CLOSE.
{preview.i &filename=temp-prot}

/* ���⨬ ������ */
{intrface.del}

RUN SetSysConf IN h_Base ("ReturnAcctRowid",?).


PROCEDURE CalcBalTdl.
   DEF INPUT PARAM iBalAcctSideChar AS CHAR NO-UNDO.
   DEF INPUT PARAM iBalAcctCodeChar AS CHAR NO-UNDO.
   DEF INPUT PARAM iBalAcctSrokChar AS CHAR NO-UNDO.
   DEF INPUT PARAM iCodeSrokChar    AS CHAR NO-UNDO.
   DEF INPUT PARAM iFuncChar        AS CHAR NO-UNDO.
   DEF INPUT PARAM iFormInChar      AS CHAR NO-UNDO.
   DEF INPUT PARAM iFormOutChar     AS CHAR NO-UNDO.

   DEFINE VARIABLE vUpdCodeChar     AS CHAR NO-UNDO.

   iFuncChar = formula.var-id.

   RUN pNormParsTdl (iBalAcctSideChar,   /* �/� ��� */
                     iBalAcctCodeChar,   /* ��� ��� */
                     iBalAcctSrokChar,   /* �ப��� ��� */
                     iCodeSrokChar,      /* ��� ����뢠����� �ப� */
                     iFuncChar,          /* ��� ���� */
                     iFormInChar,        /* formula.formula */
                     iFormOutChar,       /* ��㫠 ��� ������ ��� */
                     INPUT-OUTPUT vUpdCodeChar
                    ).

   IF vUpdCodeChar  <> "" AND
      (GetXAttrValueEx("bal-acct",ENTRY(2,vUpdCodeChar),"�ப���", ?) = ?)
   THEN /* �ந��諮 ��८�।������ ���, �� ����饣� ���. ४����� -�ப��� */
   DO:
      /* ����஫� �� ����稥 ���⪮� �� ������ ���� */
      FIND FIRST TDataLine
           WHERE TDataLine.Data-Id = in-Data-Id
             AND TDataLine.sym1    = ENTRY(1,vUpdCodeChar)  /* �/� ��� */
             AND TDataLine.sym2    = ENTRY(4,vUpdCodeChar)  /* @ost - ��� ����뢠����� �ப� */
             AND TDataLine.sym3    = ENTRY(2,vUpdCodeChar)  /* ��� ��� */
           NO-ERROR.

      IF NOT AVAIL TDataLine THEN
         RUN pNormParsTdl (ENTRY(1,vUpdCodeChar), /* �/� ��� */
                           ENTRY(2,vUpdCodeChar), /* ��� ��� */
                           ENTRY(3,vUpdCodeChar), /* �ப��� ��� */
                           ENTRY(4,vUpdCodeChar), /* ��� ����뢠����� �ப� */
                           REPLACE(ENTRY(5,vUpdCodeChar),"@",","), /* ��� ���� */
                           REPLACE(ENTRY(6,vUpdCodeChar),"@",","), /* formula.formula */
                           REPLACE(ENTRY(7,vUpdCodeChar),"@",","), /* ��㫠 ��� ������ ��� */
                           INPUT-OUTPUT vUpdCodeChar
                           ).
   END.

END PROCEDURE.

PROCEDURE pNormParsTdl.

   DEF INPUT PARAM iBalAcctSideChar AS CHAR NO-UNDO.
   DEF INPUT PARAM iBalAcctCodeChar AS CHAR NO-UNDO.
   DEF INPUT PARAM iBalAcctSrokChar AS CHAR NO-UNDO.
   DEF INPUT PARAM iCodeSrokChar    AS CHAR NO-UNDO.
   DEF INPUT PARAM iFuncChar        AS CHAR NO-UNDO.
   DEF INPUT PARAM iFormInChar      AS CHAR NO-UNDO.
   DEF INPUT PARAM iFormOutChar     AS CHAR NO-UNDO.
   DEF INPUT-OUTPUT PARAM oUpdBalAcctCodeChar AS CHAR NO-UNDO.

   DEFINE VARIABLE vNewBalAcctChr   AS CHAR    NO-UNDO.
   DEFINE VARIABLE vCntAcctInt      AS INTEGER NO-UNDO.
   DEFINE VARIABLE vTmpFormulaChar  AS CHAR    NO-UNDO.

   IF vBCLog AND
      oUpdBalAcctCodeChar = "" THEN          /* �᪫�砫�  ��=  �� ���� */
      iFormOutChar = '"' + iFormOutChar
                + (IF iFormOutChar <> "" THEN ","  ELSE "")
                + "��=" + iBalAcctCodeChar
                + '"'.

   IF mFmlRoleChar <> "" AND
      mFmlNaznChar <> "" THEN
   DO:
      RUN GetBalAcctsOfRole IN h_loan
         (iBalAcctCodeChar,
          mFmlNaznChar,
          mFmlRoleChar,
          DataBlock.end-date,
          OUTPUT vNewBalAcctChr /* ᯨ᮪ ��,����� �����. */
         ).

      IF vNewBalAcctChr <> "" THEN
      DO:
         FIND FIRST bal-acct
         WHERE bal-acct.bal-acct = INTEGER(ENTRY(1,vNewBalAcctChr))
         NO-LOCK NO-ERROR.
         IF AVAIL bal-acct THEN
         DO:
            {additem.i iFuncChar iBalAcctCodeChar}
            {additem.i iFuncChar ENTRY(2,vNewBalAcctChr)}

            ASSIGN
               iBalAcctCodeChar = STRING(bal-acct.bal-acct,"99999")
               iBalAcctSideChar = bal-acct.side
               oUpdBalAcctCodeChar =
                 iBalAcctSideChar + ","           /* iBalAcctSideChar */
               + iBalAcctCodeChar + ","           /* iBalAcctCodeChar */
               + ","                              /* iBalAcctSrokChar */
               + vCodeSym2Char [1] + ","          /* iCodeSrokChar    */
               + vFuncErrChar + ","               /* iFuncChar  */
               + '"��=' + bal-acct.acct-cat
               + "@��=" + iBalAcctCodeChar + '",' /* iFormInChar  */
               + '"��=' + bal-acct.acct-cat
               + "@��=" + iBalAcctCodeChar + '"'  /* iFormOutChar  */
            .
         END.
         ELSE
            RETURN. /* ���� ஫�, �� ��� �� */
      END.
   END.

   vMsgErrChar = "".

   RUN pChkTDataLine (iFuncChar,          /* ��� ���� */
                     iBalAcctSideChar,    /* �/�         */
                     iCodeSrokChar,       /* �ப        */
                     iBalAcctCodeChar,    /* ���        */
                     iFormInChar,         /* ���.��㫠 */
                     iFormOutChar,        /* � ��⮬   */
                     OUTPUT vMsgErrChar).   /* �������   */

   IF vMsgErrChar <> "" THEN
      RETURN "".

   ASSIGN
      vCntAcctInt = 0
      vTmpFormulaChar = ""
   .

   DO vTmpInt = 1 TO NUM-ENTRIES(iFormOutChar):
      IF INDEX(ENTRY(vTmpInt,iFormOutChar),"abs") > 0
      THEN vAbsInt = INDEX(iFormOutChar,"abs").
      ELSE
         IF INDEX(ENTRY(vTmpInt,iFormOutChar),"�=") > 0 /* �� �뢮���� १���� �� ���� */
         THEN .
         ELSE
         DO:
            {additem.i vTmpFormulaChar ENTRY(vTmpInt,iFormOutChar)}
         END.
   END.
   vTmpFormulaChar = (IF SUBSTR(vTmpFormulaChar,1,1) = '"' THEN "" ELSE '"')
                   + vTmpFormulaChar
                   + (IF SUBSTR(vTmpFormulaChar,LENGTH(vTmpFormulaChar),1) = '"' THEN "" ELSE '"')
                   .

   IF mFmlListAcctLog THEN
      RUN ParsqInitTempTable IN h_Parsq ("acct").

   RUN normpars.p(vTmpFormulaChar,
                  datablock.beg-date,
                  datablock.end-date,
                  OUTPUT xResult).

   IF mFmlListAcctLog THEN
   DO:
      RUN ParsqGetQuery IN h_Parsq (       "acct",
                                    OUTPUT vQueryH).

      {for_dqry.i vQueryH}
         vCntAcctInt = vCntAcctInt + 1.
         vAcctRwd = TO-ROWID (GetValue (vQueryH:GET-BUFFER-HANDLE (1),"Source_Rowid")).

         IF vStepInt = 1 THEN     /* ���� ��� �� ᮤ�ঠ�� lastmov* */
         DO:
            IF NOT CAN-FIND (FIRST ttAcct WHERE ttAcct.ID EQ vAcctRwd) THEN
            DO:
               CREATE ttAcct.
               ASSIGN
                  ttAcct.ID  = vAcctRwd
               .
            END.
         END.
         ELSE
         DO:
            FIND FIRST ttAcct WHERE ttAcct.ID EQ vAcctRwd NO-ERROR.
            IF AVAIL ttAcct THEN
            DO:
               ASSIGN
                  vAcctVal = ABSOLUTE(DEC (GetValue (vQueryH:GET-BUFFER-HANDLE (1),"Parsq_Value")))
                  xResult = xResult - vAcctVal
               .
               RUN PrintFil2 (0,"��������","�᪫�祭 ��="
                                                   + GetValue (vQueryH:Get-BUFFER-HANDLE (2),"acct")
                                                   + ","
                                                   + STRING(GetValue (vQueryH:Get-BUFFER-HANDLE (2),"currency"),"XXX")
                                                   + " �� �㬬� : " + STRING(vAcctVal)).
               RUN PrintFil2 (0,"        ","� �裡 � ���⮬ �� ��������").
            END.
         END.
      END.
   END. /* IF mFmlListAcctLog THEN */

   RUN PrintFil2 (1,iBalAcctCodeChar,
                             iBalAcctSrokChar
                           + ", "
                           + iFormOutChar
                             ).
   IF vAbsInt > 0 THEN xResult = ABSOLUTE(xResult).

   RUN PrintFil2 (2,"१����",STRING(xResult,"->,>>>,>>>,>>>,>>9.99")).

   IF vStepInt = 1 AND     /* ���� ��� �� ᮤ�ঠ�� lastmov* */
      xResult <> 0 AND
      iCodeSrokChar <> vCodeSym2Char [1] AND  /* "@ost" - ���⮪ �� ���� �� ����� �� */
      mFmlListAcctLog  AND
      vCntAcctInt = 0 THEN
      DO:
         RUN PrintFil2 (0,"��������","��� ���� : " + iFormOutChar).
         RUN PrintFil2 (0,""        ,"�� ��।������ ��楢� ���").
      END.

   IF RETURN-VALUE <> "" THEN RETURN RETURN-VALUE.

   IF xResult <> 0 THEN
   DO:
      CREATE TDataLine.
      ASSIGN
         TDataLine.Data-Id = in-Data-Id
         TDataLine.Sym1    = iBalAcctSideChar
         TDataLine.Sym2    = iCodeSrokChar
         TDataLine.Sym3    = iBalAcctCodeChar
         TDataLine.Sym4    = iFuncChar
         TDataLine.Val[1]  = ROUND(xResult,2)
         TDataLine.Txt     = iFormOutChar
     .
   END.

END PROCEDURE.

PROCEDURE CalcErrTdl.

   DEFINE VARIABLE vOstDec AS DECIMAL NO-UNDO.
   DEFINE VARIABLE vErrDec AS DECIMAL NO-UNDO.
   DEFINE VARIABLE vValDec AS DECIMAL NO-UNDO.
   DEFINE BUFFER   b-TDataLine FOR TDataLine.

   FOR EACH TDataLine BREAK BY Sym3 : /* ��� */
      IF FIRST-OF(TDataLine.sym3) THEN
         ASSIGN
            vOstDec = 0
            vValDec = 0
         .

      CASE TDataLine.sym2:
         WHEN vCodeSym2Char [1] THEN   /* _��� */
            vOstDec = vOstDec + TDataLine.Val[1].
         WHEN vCodeSym2Char [2] THEN . /* _err */
         OTHERWISE
            vValDec = vValDec + TDataLine.Val[1].
      END CASE.

      IF LAST-OF(TDataLine.sym3) THEN
      DO:
         FIND FIRST b-TDataLine
             WHERE b-TDataLine.Data-Id = in-Data-Id
               AND b-TDataLine.sym1    = TDataLine.sym1
               AND b-TDataLine.sym2    = vCodeSym2Char [2] /* _err */
               AND b-TDataLine.sym3    = TDataLine.sym3
               AND b-TDataLine.sym4    = vFuncErrChar
                  NO-ERROR.

         IF NOT AVAIL b-TDataLine THEN
         DO:
            CREATE b-TDataLine.
            ASSIGN
               b-TDataLine.Data-Id = in-Data-Id
               b-TDataLine.sym1    = TDataLine.sym1
               b-TDataLine.sym2    = vCodeSym2Char [2] /* _err */
               b-TDataLine.sym3    = TDataLine.sym3
               b-TDataLine.sym4    = vFuncErrChar
            .
         END.

         ASSIGN
            b-TDataLine.Val[1]  = vOstDec - vValDec
            b-TDataLine.Txt     = "(" + STRING(vOstDec) + ")"
                                + " - "
                                + "(" + STRING(vValDec) + ")"
         .
      END.
   END.
END PROCEDURE.

PROCEDURE CalcLastmovTdl.
   DEF INPUT PARAM iCodeSrokChar    AS CHAR NO-UNDO. /* ��� ���뢠����� �ப� */
   DEF INPUT PARAM iFuncChar        AS CHAR NO-UNDO. /* ��� ����         */
   DEF INPUT PARAM iFormInChar      AS CHAR NO-UNDO. /* ��室��� ��㫠    */
   DEF INPUT PARAM iFormOutChar     AS CHAR NO-UNDO. /* ��㫠 � ��᪮� �� */
   DEF INPUT PARAM iMaskSrokChar    AS CHAR NO-UNDO. /* ��᪠ �ப��  */
   DEF INPUT PARAM iListBalAcctChar AS CHAR NO-UNDO. /* ᯨ᮪ �� ��� ���� ���� */

   DEFINE VARIABLE vTmpBalAcctChar  AS CHARACTER NO-UNDO.  /* ��� �� */
   DEFINE VARIABLE vTmpSideChar     AS CHARACTER NO-UNDO.  /* ⨯ �� {�/�}*/
   DEFINE VARIABLE vTmpSrokChar     AS CHARACTER NO-UNDO.  /* ����. ���.४. �ப��� � �� */
   DEFINE VARIABLE vTmpUpdCodeChar  AS CHAR NO-UNDO.       /* ࠡ��� ��६����� */
   DEFINE VARIABLE vTmpNoxResult    AS DECIMAL NO-UNDO.    /* ࠡ��� ��६����� */
   DEFINE VARIABLE vTmpYesxResult   AS DECIMAL NO-UNDO.    /* ࠡ��� ��६����� */

   {empty ttBalLastmov} /* ᯨ᮪ �� �ନ�㥬� �� ���� ���� */

   RUN ParsqInitTempTable IN h_Parsq ("acct").

   RUN normpars.p(REPLACE(REPLACE (iFormOutChar,"*",iListBalAcctChar),",�",""),  /* �᪫�砥� �뢮� ⠡���� १���⮢ */
                  datablock.beg-date,
                  datablock.end-date,
                  OUTPUT xResult).

   RUN ParsqGetQuery IN h_Parsq (       "acct",
                                 OUTPUT vQueryH).

   {for_dqry.i vQueryH}
      vAcctRwd = TO-ROWID (GetValue (vQueryH:GET-BUFFER-HANDLE (1),"Source_Rowid")).
      vAcctVal = ABSOLUTE(DEC (GetValue (vQueryH:GET-BUFFER-HANDLE (1),"Parsq_Value"))).

      FIND FIRST ttAcct WHERE ttAcct.ID EQ vAcctRwd NO-ERROR.
      IF AVAIL ttAcct THEN
      DO:
         vTmpNoxResult = vTmpNoxResult + vAcctVal.
         RUN PrintFil2 (0,"��������","�᪫�祭 ��="
                                             + GetValue (vQueryH:Get-BUFFER-HANDLE (2),"acct")
                                             + ","
                                             + STRING(GetValue (vQueryH:Get-BUFFER-HANDLE (2),"currency"),"XXX")
                                             + " �� �㬬� : " + STRING(vAcctVal)).
         RUN PrintFil2 (0,"        ","� �裡 � ���⮬ �� ��������").
      END.
      ELSE
      DO:
         vTmpBalAcctChar = SUBSTR(GetValue (vQueryH:Get-BUFFER-HANDLE (2),"acct"),1,5).
         /* ����஫� �� �ப��� */
         FIND FIRST ttBalAcct WHERE ttBalAcct.CodeBalAcct EQ vTmpBalAcctChar NO-ERROR.
         IF NOT AVAIL ttBalAcct OR
            NOT CAN-DO(iMaskSrokChar,ttBalAcct.CodeSrokBal) THEN  /* ��᪠ �ப�� */
         DO:
            vTmpNoxResult = vTmpNoxResult + vAcctVal.
            RUN PrintFil2 (0,"��������","�᪫�祭 ��="
                                             + GetValue (vQueryH:Get-BUFFER-HANDLE (2),"acct")
                                             + ","
                                             + STRING(GetValue (vQueryH:Get-BUFFER-HANDLE (2),"currency"),"XXX")
                                             + " �� �㬬� : " + STRING(vAcctVal)).
         END.

         IF NOT AVAIL ttBalAcct THEN
            RUN PrintFil2 (0,""        ,"�.�. � �� " + vTmpBalAcctChar
                                      + " ��������� ���.४ '�ப���'").
         ELSE
         DO:
            IF NOT CAN-DO(iMaskSrokChar,ttBalAcct.CodeSrokBal) THEN  /* ��᪠ �ப�� */
               RUN PrintFil2 (0,""        ,"�.�. � �� " + vTmpBalAcctChar
                                         + " ���祭�� ���.४ '�ப���' = "
                                         + ttBalAcct.CodeSrokBal
                                         + " �� �室�� � ���� " + iMaskSrokChar).
            ELSE
            DO:
               FIND FIRST ttBalLastmov WHERE ttBalLastmov.BalAcct EQ vTmpBalAcctChar NO-ERROR.
               IF NOT AVAIL ttBalLastmov THEN
               DO:
                  CREATE ttBalLastmov.
                  ASSIGN
                     ttBalLastmov.BalSrok = GetXAttrValueEx("bal-acct",ttBalLastmov.BalAcct,"�ப���","?")
                     ttBalLastmov.BalAcct = vTmpBalAcctChar
                  .
               END.
               ASSIGN
                  vAcctVal         = ROUND(vAcctVal,2)
                  ttBalLastmov.Val = ttBalLastmov.Val + vAcctVal
                  vTmpYesxResult   = vTmpYesxResult   + vAcctVal
               .
            END.
         END.
      END.
   END.

   FOR EACH ttBalLastmov :
      ASSIGN
         ttBalLastmov.Side = "?"
         ttBalLastmov.Cat  = "?"
      .

      FIND FIRST bal-acct
         WHERE bal-acct.bal-acct = INTEGER(ttBalLastmov.BalAcct)
         NO-LOCK NO-ERROR.

      IF NOT AVAIL bal-acct THEN
      DO:
         RUN PrintFil2 (-1,"������",
                                  "���� : " + ttBalLastmov.BalAcct
                                + " ����������� � ����� ������").
      END.
      ELSE
         ASSIGN
            ttBalLastmov.Side = bal-acct.side
            ttBalLastmov.Cat  = bal-acct.acct-cat
         .


      ASSIGN
         vTmpSrokChar      = ttBalLastmov.BalSrok
         vTmpSideChar      = ttBalLastmov.Side
      .

      RUN PrintFil2 (1,ttBalLastmov.BalAcct,
                                (IF vTmpSrokChar = "?"
                                 THEN "   "
                                 ELSE vTmpSrokChar)
                              + ", "
                              + REPLACE (iFormOutChar,"*",ttBalLastmov.BalAcct)
                             ).

      RUN PrintFil2 (2,"१����",STRING(ttBalLastmov.val,"->,>>>,>>>,>>>,>>9.99")).

      IF ttBalLastmov.val <> 0 THEN
      DO:

         vMsgErrChar = "".
         RUN pChkTDataLine (iFuncChar,            /* ��� ���� */
                           vTmpSideChar,         /* �/�         */
                           iCodeSrokChar,        /* �ப        */
                           ttBalLastmov.BalAcct, /* ���        */
                           iFormInChar,          /* ���.��㫠 */
                           REPLACE (iFormOutChar,"*",ttBalLastmov.BalAcct), /* � ��⮬   */
                           OUTPUT vMsgErrChar).    /* �������   */
         IF vMsgErrChar <> "" THEN
            RETURN "".

         CREATE TDataLine.
         ASSIGN
            TDataLine.Data-Id = in-Data-Id
            TDataLine.Sym1    = vTmpSideChar            /* �/� ��� */
            TDataLine.Sym2    = iCodeSrokChar           /* �ப */
            TDataLine.Sym3    = ttBalLastmov.BalAcct    /* ��� ��� */
            TDataLine.Sym4    = iFuncChar               /* ��� ���� */
            TDataLine.Val[1]  = ttBalLastmov.val
            TDataLine.Txt     = REPLACE (iFormOutChar,"*",ttBalLastmov.BalAcct) /* ��㫠 ��� ������ ��� */
         .

      END. /* IF ttBalLastmov.val <> 0 THEN */
   END. /* FOR EACH ttBalLastmov */

   IF vTmpYesxResult + vTmpNoxResult <> xResult THEN
   DO:
      RUN PrintFil2 (0,'��������',' ��室��� ��㫠:' + iFormInChar).
      RUN PrintFil2 (0,''        ,'������� ����: ' + STRING(xResult,"->,>>>,>>>,>>>,>>9.99")).
      RUN PrintFil2 (0,''        ,' �㬬� �� ���. ��: ' + STRING(vTmpYesxResult,"->,>>>,>>>,>>>,>>9.99")).
      RUN PrintFil2 (0,''        ,' �㬬� �� �᪫.��: ' + STRING(vTmpNoxResult,"->,>>>,>>>,>>>,>>9.99")).
   END.

   FOR EACH ttBalLastmov WHERE ttBalLastmov.BalSrok = "?" :
      /* ���, �� ����饣� ���. ४����� -�ப��� */
      /* ����஫� �� ����稥 ���⪮� �� ���� */
      FIND FIRST TDataLine
         WHERE  TDataLine.Data-Id = in-Data-Id
            AND TDataLine.sym1    = ttBalLastmov.Side      /* �/� ��� */
            AND TDataLine.sym2    = vCodeSym2Char [1]      /* @ost - ��� ����뢠����� �ப� */
            AND TDataLine.sym3    = ttBalLastmov.BalAcct   /* ��� ��� */
         NO-ERROR.

      vTmpUpdCodeChar = "".

      IF NOT AVAIL TDataLine THEN
         RUN pNormParsTdl (ttBalLastmov.Side,    /* �/� ��� */
                           ttBalLastmov.BalAcct, /* ��� ��� */
                           "",                   /* �ப��� ��� */
                           vCodeSym2Char [1],    /* ��� ����뢠����� �ப� */
                           vFuncErrChar,         /* ��� ���� */
                           '"��=' + ttBalLastmov.Cat
                         + ",��=" + ttBalLastmov.BalAcct + '"', /* iFormInChar  */
                           '"��=' + ttBalLastmov.Cat
                         + ",��=" + ttBalLastmov.BalAcct + '"',     /* iFormOutChar  */
                     INPUT-OUTPUT vTmpUpdCodeChar
                                 ).
   END. /* FOR EACH ttBalLastmov WHERE ttBalLastmov.BalSrok = "?"THEN */
END PROCEDURE.


PROCEDURE PrintFil2.
   DEF INPUT PARAM iLevel  AS INT  NO-UNDO.
   DEF INPUT PARAM iSource AS CHAR NO-UNDO.
   DEF INPUT PARAM iStr    AS CHAR NO-UNDO.

   IF iLevel = -1 THEN
   DO:
      iLevel = 0.
      RUN normdbg IN h_debug (iLevel,iSource,iStr).
   END.

   PUT STREAM fil2 UNFORMATTED
      STRING (TODAY,"99/99/9999") " "
      STRING (TIME,"hh:mm:ss") "   ["
      STRING (iLevel,"9") "]   "
      STRING (iSource,"x(9)") " "
              iStr SKIP.

END PROCEDURE.

PROCEDURE pChkTDataLine.
   DEF INPUT PARAM ipFuncChar          AS CHAR NO-UNDO.    /* ��� ���� */
   DEF INPUT PARAM ipBalAcctSideChar   AS CHAR NO-UNDO.    /* �/�         */
   DEF INPUT PARAM ipCodeSrokChar      AS CHAR NO-UNDO.    /* �ப        */
   DEF INPUT PARAM ipBalAcctCodeChar   AS CHAR NO-UNDO.    /* ���        */
   DEF INPUT PARAM ipFormInChar        AS CHAR NO-UNDO.    /* ���.��㫠 */
   DEF INPUT PARAM ipFormOutChar       AS CHAR NO-UNDO.    /* � ��⮬   */
   DEF OUTPUT PARAM opMsgErrChar       AS CHAR NO-UNDO.    /* �������   */

   IF INDEX(ipFuncChar,"_unq") > 0 THEN
   DO:
      FIND FIRST TDataLine
         WHERE TDataLine.Data-Id  = in-Data-Id
            AND TDataLine.sym1    = ipBalAcctSideChar
            AND TDataLine.sym2    = ipCodeSrokChar
            AND TDataLine.sym3    = ipBalAcctCodeChar
         NO-ERROR.
   END.
   ELSE
   DO:
      FIND FIRST TDataLine
         WHERE TDataLine.Data-Id  = in-Data-Id
            AND TDataLine.sym1    = ipBalAcctSideChar
            AND TDataLine.sym2    = ipCodeSrokChar
            AND TDataLine.sym3    = ipBalAcctCodeChar
            AND ( TDataLine.sym4  = ipFuncChar OR
                  CAN-DO(vListFmlUnqChar,TDataLine.sym4) )
         NO-ERROR.
   END.

   IF AVAIL TDataLine THEN
   DO:
      opMsgErrChar = "error".
      RUN PrintFil2 (0,'���.��㫠',ipFormInChar).
      RUN PrintFil2 (0,'� ��⮬',ipFormOutChar).
      RUN PrintFil2 (0,'�訡��','��� ' + TDataLine.Sym3 +
                                         ' � �ப�� ' + TDataLine.Sym2 +
                                         ' 㦥 ����⠭ �� ��㫥:' + ipFuncChar
                                         ).
      IF INDEX(ipFuncChar,"_unq") > 0 THEN
      DO:
         RUN PrintFil2 (-1,'��������',"����� ��� ���� '" + ipFuncChar + "' ��࠭��� �� ��!").
      END.
   END.
END PROCEDURE.
