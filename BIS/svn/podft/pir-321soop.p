{pirsavelog.p}
/*
                ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-1996 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: pir-321soop.p
      Comment: ����� ॥��� �� ����� Legal321
               ᮣ��᭮ ��������� 321-� (��뢠��� ��室��)
         Uses:
      Used BY:
       Edited: 12/01/2009 Borisov
*/
/******************************************************************************/
DEFINE INPUT PARAMETER ipDataID  AS INTEGER NO-UNDO.

{globals.i}
{repinfo.i}
{norm.i NEW}

{intrface.get xclass}
{intrface.get strng}

{leg321p.def}
{leg321p.fun}
{pir_anketa.fun}

DEFINE VAR mErrCount   AS  INTEGER    NO-UNDO.
DEFINE VAR mError      AS  INTEGER    NO-UNDO.
DEFINE VAR cTD         AS  CHARACTER  NO-UNDO.
DEFINE VAR cA1         AS  CHARACTER  NO-UNDO.
DEFINE VAR cA2         AS  CHARACTER  NO-UNDO.
DEFINE VAR cA3         AS  CHARACTER  NO-UNDO.
DEFINE VAR cA4         AS  CHARACTER  NO-UNDO.
DEFINE VAR cA5         AS  CHARACTER  NO-UNDO.
DEFINE VAR cA6         AS  CHARACTER  NO-UNDO.
DEFINE VAR cDatDoc     AS  CHARACTER  NO-UNDO.
DEFINE VAR cDatMigr1   AS  CHARACTER  NO-UNDO.
DEFINE VAR cDatMigr2   AS  CHARACTER  NO-UNDO.
DEFINE VAR cTmp        AS  CHARACTER  NO-UNDO.
DEFINE VAR str         AS  CHARACTER EXTENT 100  NO-UNDO. /** ����� ᮮ�饭�� */
DEFINE VAR i           AS  INTEGER    NO-UNDO. /** ����� */
DEFINE VAR j           AS  INTEGER    NO-UNDO.
DEFINE VAR lOurSnd     AS  LOGICAL    NO-UNDO.
DEFINE VAR lOurRcv     AS  LOGICAL    NO-UNDO.
DEFINE VAR cKlSnd      AS  CHARACTER  NO-UNDO.
DEFINE VAR cKlRcv      AS  CHARACTER  NO-UNDO.
DEFINE VAR cKlntStr    AS  CHARACTER  NO-UNDO.
DEFINE VAR cKlntPl     AS  CHARACTER  NO-UNDO.
DEFINE VAR cDocNum     AS  CHARACTER
   LABEL "����� ���㬥��" FORMAT "x(61)" NO-UNDO.
DEFINE VAR lIsPred     AS  LOGICAL    NO-UNDO.

/** ���㠫�� �����, � ������� ���ண� � ��砥 ����室�����
    ����� ����� ������, ����� ������� � ᮮ�饭�� */
DEFINE VAR needClient AS CHAR LABEL "�㦭� ������" FORMAT "x(59)"
   VIEW-AS COMBO-BOX LIST-ITEM-PAIRS "","" INNER-LINES 2.

DEFINE FRAME frmMessage
   cDocNum   SKIP
   needClient
   WITH SIDE-LABELS CENTERED OVERLAY TITLE "���������".

DEFINE BUFFER Data0 FOR DataLine.
DEFINE BUFFER Data1 FOR DataLine.
DEFINE BUFFER Data2 FOR DataLine.

FUNCTION GetDat0Txt RETURN CHAR    (INPUT ipItem   AS INTEGER) forward.
FUNCTION GetDat1Txt RETURN CHAR    (INPUT ipItem   AS INTEGER) forward.
FUNCTION GetDat2Txt RETURN CHAR    (INPUT ipItem   AS INTEGER) forward.
/*============================================================================*/
{fexp-chk.i &DataID = ipDataID}

FIND FIRST setting
   WHERE setting.code     EQ "Legal207"
     AND setting.sub-code EQ "�������"
   SHARE-LOCK NO-ERROR.

IF NOT AVAILABLE(setting) THEN DO:
   MESSAGE
      "����� � ��� �ᯮ�������� ��㣨� ���짮��⥫��." SKIP
      "���஡�� �����."                                 SKIP
      VIEW-AS ALERT-BOX INFORMATION.
   RETURN.
END.

FIND current DataBlock
   SHARE-LOCK NO-ERROR.

IF NOT AVAILABLE(DataBlock) THEN DO:
   MESSAGE
      "���� ������ ��������� ��㣨� ���짮��⥫��." SKIP
      "���஡�� �����."                            SKIP
      VIEW-AS ALERT-BOX INFORMATION.
   RETURN.
END.

FOR EACH Data0
   WHERE Data0.Data-ID EQ ipDataID
     AND Data0.Sym2    EQ {&MAIN-LINE}
   NO-LOCK:

   j = needClient:NUM-ITEMS.
   DO i = 1 TO j:
      needClient:DELETE(1).
   END.

   cKlntStr = "".

   /* ����砥� ����� � ���⥫�騪� */
   FIND FIRST Data1
      WHERE Data1.Data-ID EQ ipDataID
        AND Data1.Sym1    EQ Data0.Sym1
        AND Data1.Sym2    EQ {&SEND-LINE}
      NO-LOCK NO-ERROR.

   IF (AVAIL Data1)
   THEN DO:
      ASSIGN
         lOurSnd = (Data0.Val[4] EQ 1)
         cKlSnd  = Data1.Sym3
         NO-ERROR.

/*
      needClient:ADD-LAST((IF (NUM-ENTRIES(cKlSnd) GT 2) THEN ENTRY(3, cKlSnd) ELSE "                    ")
*/
      needClient:ADD-LAST(STRING(GetDat1Txt(38), "x(20)")
                         + "-" + REPLACE(SUBSTRING(GetDat1Txt(3), 1, 59), ",", "_"), {&SEND-LINE}).
   END.
   ELSE
      lOurSnd = NO.

   /* ����砥� ����� � �����⥫� */
   FIND FIRST Data1
      WHERE Data1.Data-ID EQ ipDataID
        AND Data1.Sym1    EQ Data0.Sym1
        AND Data1.Sym2    EQ {&RECV-LINE}
      NO-LOCK NO-ERROR.

   IF (AVAIL Data1)
   THEN DO:
      ASSIGN
         lOurRcv = (Data0.Val[5] EQ 1)
         cKlRcv  = Data1.Sym3
         NO-ERROR.
/*
      needClient:ADD-LAST((IF (NUM-ENTRIES(cKlRcv) GT 2) THEN ENTRY(3, cKlRcv) ELSE "                    ")
*/
      needClient:ADD-LAST(STRING(GetDat1Txt(38), "x(20)")
                         + "-" + REPLACE(SUBSTRING(GetDat1Txt(3), 1, 59), ",", "_"), {&RECV-LINE}).
   END.
   ELSE
      lOurRcv = NO.

   /* �᫨ ��-� �� ���⭨��� ������ ����� */
   IF (lOurSnd OR lOurRcv)
   THEN DO:
      /* �᫨ ⮫쪮 ��ࠢ�⥫� ������ ����� */
      IF (lOurSnd AND NOT lOurRcv)
      THEN
         cKlntStr = {&SEND-LINE}.
      ELSE
      /* �᫨ ⮫쪮 �����⥫� ������ ����� */
      IF (NOT lOurSnd AND lOurRcv)
      THEN
         cKlntStr = {&RECV-LINE}.
      ELSE DO:
         /* �᫨ ��ࠢ�⥫� � �����⥫� ���� � �� ��*/
/*
         IF     (ENTRY(1, cKlSnd) EQ ENTRY(1, cKlRcv))
            AND (ENTRY(2, cKlSnd) EQ ENTRY(2, cKlRcv))
         THEN DO:
            /* � ���� 㪠��� ॠ��� ��� */
            IF (NUM-ENTRIES(cKlRcv) GT 2)
            THEN
               cKlntStr = {&RECV-LINE}.
            ELSE
               cKlntStr = {&SEND-LINE}.
         END.
         /* �᫨ ���⭨�� ࠧ�� - ����� ������� */
         ELSE DO:
*/
            PAUSE 0.
            DISPLAY
               cDocNum
               needClient
               WITH FRAME frmMessage.

            SET needClient
               WITH FRAME frmMessage.
            cKlntStr = needClient:SCREEN-VALUE.
            HIDE FRAME frmMessage.
/*
         END.
*/
      END.

      /* ����砥� ����� � ��࠭��� ������ */
      FIND FIRST Data1
         WHERE Data1.Data-ID EQ ipDataID
           AND Data1.Sym1    EQ Data0.Sym1
           AND Data1.Sym2    EQ cKlntStr
         NO-LOCK NO-ERROR.

      cKlntStr = GetDat1Txt(1).
   END.
   ELSE DO:
      /* �᫨ �� ��� �������, �롨ࠥ� ��ࠢ�⥫� */
      FIND FIRST Data1
         WHERE Data1.Data-ID EQ ipDataID
           AND Data1.Sym1    EQ Data0.Sym1
           AND Data1.Sym2    EQ {&SEND-LINE}
         NO-LOCK NO-ERROR.

      cKlntStr = GetDat1Txt(1).
   END.

   {setdest.i}

   CASE cKlntStr:
      WHEN "1" OR WHEN "4" THEN
         PUT UNFORMATTED
            SPACE(30) "��������� �� ����樨 �ਤ��᪮�� ���." SKIP
         .
      WHEN "2" THEN
         PUT UNFORMATTED
            SPACE(30) "��������� �� ����樨 䨧��᪮�� ���." SKIP
         .
      WHEN "3" THEN
         PUT UNFORMATTED
            SPACE(30) "��������� �� ����樨 �������㠫쭮�� �।�ਭ���⥫�." SKIP
         .
   END CASE.

   PUT UNFORMATTED 
      "����������������������������������������������������������������������������������������������������������������������Ŀ" SKIP
      "��������� �� ����樨 (ᤥ���)                                                                                         �" SKIP
      "����������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
   .

   IF (Data0.Sym3 EQ "6001")
   THEN
      PUT UNFORMATTED 
         "�   �����筠� ᤥ���                            �" SPACE(34) "X" SPACE(35)                                            "�" SKIP
         "����������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
      .
   ELSE
      PUT UNFORMATTED 
         "�   ������, ��������� ��易⥫쭮�� ����஫� �" SPACE(34) "X" SPACE(35)                                            "�" SKIP
         "����������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
      .

   cDocNum = TRIM(STRING(Data0.Val[7], ">>>>>9")).
   PUT UNFORMATTED 
      "����㬥��, �� �᭮����� ���ண� �����⢫���� �" cDocNum FORMAT "x(70)"                                             "�" SKIP
      "������� (ᤥ���)                              �                                                                      �" SKIP
      "����������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
   .
   /** ����ঠ��� ����樨 �㦭� ࠧ���� �� ��ப�� */
   str[1] = GetDat0Txt(12).
   str[1] = GetDat0Txt(11) + (IF (str[1] NE "0") THEN str[1] ELSE "").
   {wordwrap.i &s=str &n=10 &l=70}

   PUT UNFORMATTED
      "�   ����ঠ��� ����樨 (ᤥ���)                �" str[1] FORMAT "x(70)"                                              "�" SKIP
   .
   DO i = 2 TO 10:
      IF (str[i] NE "")
      THEN DO:
         PUT UNFORMATTED
            "�                                               �" str[i] FORMAT "x(70)"                                              "�" SKIP
         .
         str[i] = "".
      END.
   END.

   cTmp = string(GetDat0Txt(10), "x(3)").
   cTmp = cTmp + (IF (cTmp EQ "643") THEN "" ELSE " / 643").
   PUT UNFORMATTED
      "����������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
      "�   ��� ������ ����樨 (ᤥ���)                �" cTmp FORMAT "x(70)"                                                "�" SKIP
      "����������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
   .
   cTmp = IF (cTmp EQ "643")
          THEN (TRIM(string(Data0.Val[2],   "->>>,>>>,>>>,>>>,>>9.99")))
          ELSE (TRIM(string(Data0.Val[3],   "->>>,>>>,>>>,>>>,>>9.99")) + " / "
              + TRIM(string(Data0.Val[2],   "->>>,>>>,>>>,>>>,>>9.99"))).
   PUT UNFORMATTED 
      "�   �㬬� ����樨 (ᤥ���)                     �" cTmp FORMAT "x(70)"                                                "�" SKIP
      "����������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
   .
   cTmp = STRING(DATE(GetEntries( 9, Data0.Txt, "~n", {&E-DATE})), "99.99.9999").
   PUT UNFORMATTED 
      "�   ��� ᮢ��襭�� ����樨 (ᤥ���)           �" cTmp FORMAT "x(70)"                                                "�" SKIP
      "����������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
   .

   CASE cKlntStr:
      WHEN "2" OR WHEN "3" THEN DO:
         str[1] = GetDat1Txt(22).   /* ���� */
         cTmp   = GetDat1Txt(20).   /* ���㬥�� */

         FIND FIRST code
            WHERE (code.class   EQ "�������")
              AND (code.parent  EQ "�������")
              AND (code.misc[6] EQ cTmp)
            NO-LOCK NO-ERROR.
         cTmp = IF (AVAIL code) THEN code.name ELSE "".

         str[1] = (IF (str[1] NE "0") THEN (str[1] + ", ") ELSE "")
                + (IF ((cTmp EQ "") OR (cTmp EQ "0")) THEN ""
                   ELSE (cTmp + ", N " + GetDat1Txt(21)
                        + (IF (GetDat1Txt(24) EQ "0") THEN "" ELSE (" " + GetDat1Txt(24)))
                        + ", �뤠� " + STRING(DATE(GetDat1Txt(26)), "99.99.9999") + ", " + GetDat1Txt(25))).
         {wordwrap.i &s=str &n=3 &l=70}

         PUT UNFORMATTED
            "��������� � ��� (����), �஢����� ������ (ᮢ������ ᤥ���)                                                     �" SKIP
            "����������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
            "�   �.�.�.                                      �" GetDat1Txt( 3) FORMAT "x(70)"                                      "�" SKIP
            "����������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
            "�   ���                                         �" GetDat1Txt(23) FORMAT "x(70)"                                      "�" SKIP
            "����������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
            "�   ���� ��� ��,����� ���㬥��,㤮�⮢����饣��" str[1] FORMAT "x(70)"                                              "�" SKIP
            "�   ��筮��� (⨯,���,�����,��� � ����� �뤠�)�" str[2] FORMAT "x(70)"                                              "�" SKIP
         .

         IF (str[3] NE "")
         THEN
            PUT UNFORMATTED
               "�                                               �" str[3] FORMAT "x(70)"                                              "�" SKIP
            .

         PUT UNFORMATTED
            "����������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
         .
         cTmp   = "," /* index */
                + (IF (GetDat1Txt( 7) NE "0") THEN GetDat1Txt( 7) ELSE "") + ","
                + (IF (GetDat1Txt( 8) NE "0") THEN GetDat1Txt( 8) ELSE "") + ",,"
                + (IF (GetDat1Txt( 9) NE "0") THEN GetDat1Txt( 9) ELSE "") + ","
                + (IF (GetDat1Txt(10) NE "0") THEN GetDat1Txt(10) ELSE "") + ","
                + (IF (GetDat1Txt(11) NE "0") THEN GetDat1Txt(11) ELSE "") + ","
                + (IF (GetDat1Txt(12) NE "0") THEN GetDat1Txt(12) ELSE "") + ",".
         str[1] = Kladr(  (IF (GetDat1Txt(4) EQ "64300") THEN "RUS" ELSE "-") + ","
                        + (IF (GetDat1Txt(6) NE "0") THEN ("000" + GetDat1Txt(6)) ELSE ""),
                          cTmp).
         {wordwrap.i &s=str &n=3 &l=70}

         PUT UNFORMATTED
            "�   ���� ॣ����樨                           �" (IF (str[1] NE "") THEN str[1] ELSE "0") FORMAT "x(70)"            "�" SKIP
         .
         IF (str[2] NE "")
         THEN
            PUT UNFORMATTED
               "�                                               �" str[2] FORMAT "x(70)"                                              "�" SKIP
            .

         PUT UNFORMATTED
            "����������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
            "��������� � ���, � �ᯮ�짮������ ���ண� �஢������ ������ ��� ᤥ��� (�஬� ��砥� �����⢫����               �" SKIP
            "���ॢ���� ��� ������ ���):                                                                                        �" SKIP
            "����������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
            "�   � ���                                     �" GetDat1Txt(38) FORMAT "x(70)"                                      "�" SKIP
            "����������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
         .
         
      END.
      WHEN "1" OR WHEN "4" THEN DO:
         PUT UNFORMATTED 
            "��������� � ��� (����), �஢����� ������ (ᮢ������ ᤥ���)                                                     �" SKIP
            "����������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
            "�   ������������                                �" GetDat1Txt( 3) FORMAT "x(70)"                                      "�" SKIP
            "����������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
            "�   ���                                         �" GetDat1Txt(23) FORMAT "x(70)"                                      "�" SKIP
            "����������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
            "�   �������樮��� �����                       �" GetDat1Txt(22) FORMAT "x(70)"                                      "�" SKIP
            "����������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
         .
         cTmp   = "," /* index */
                + (IF (GetDat1Txt( 7) NE "0") THEN GetDat1Txt( 7) ELSE "") + ","
                + (IF (GetDat1Txt( 8) NE "0") THEN GetDat1Txt( 8) ELSE "") + ",,"
                + (IF (GetDat1Txt( 9) NE "0") THEN GetDat1Txt( 9) ELSE "") + ","
                + (IF (GetDat1Txt(10) NE "0") THEN GetDat1Txt(10) ELSE "") + ","
                + (IF (GetDat1Txt(11) NE "0") THEN GetDat1Txt(11) ELSE "") + ","
                + (IF (GetDat1Txt(12) NE "0") THEN GetDat1Txt(12) ELSE "") + ",".
         str[1] = Kladr(  (IF (GetDat1Txt(4) EQ "64300") THEN "RUS" ELSE "-") + ","
                        + (IF (GetDat1Txt(6) NE "0") THEN ("000" + GetDat1Txt(6)) ELSE ""),
                          cTmp).
         {wordwrap.i &s=str &n=3 &l=70}

         PUT UNFORMATTED
            "�   ���� ॣ����樨 �ਤ��᪮�� ���         �" (IF (str[1] NE "") THEN str[1] ELSE "0") FORMAT "x(70)"            "�" SKIP
         .
         IF (str[2] NE "")
         THEN
            PUT UNFORMATTED
               "�                                               �" str[2] FORMAT "x(70)"                                              "�" SKIP
            .

         PUT UNFORMATTED
            "����������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
         .
         cTmp   = "," /* index */
                + (IF (GetDat1Txt(14) NE "0") THEN GetDat1Txt(14) ELSE "") + ","
                + (IF (GetDat1Txt(15) NE "0") THEN GetDat1Txt(15) ELSE "") + ",,"
                + (IF (GetDat1Txt(16) NE "0") THEN GetDat1Txt(16) ELSE "") + ","
                + (IF (GetDat1Txt(17) NE "0") THEN GetDat1Txt(17) ELSE "") + ","
                + (IF (GetDat1Txt(18) NE "0") THEN GetDat1Txt(18) ELSE "") + ","
                + (IF (GetDat1Txt(19) NE "0") THEN GetDat1Txt(19) ELSE "") + ",".
         str[1] = Kladr(  (IF (GetDat1Txt(5) EQ "64300") THEN "RUS" ELSE "-") + ","
                        + (IF (GetDat1Txt(13) NE "0") THEN ("000" + GetDat1Txt(13)) ELSE ""),
                          cTmp).
         {wordwrap.i &s=str &n=3 &l=70}

         PUT UNFORMATTED
            "�   ���� ��宦����� �ਤ��᪮�� ���          �" (IF (str[1] NE "") THEN str[1] ELSE "0") FORMAT "x(70)"            "�" SKIP
         .
         IF (str[2] NE "")
         THEN
            PUT UNFORMATTED
               "�                                               �" str[2] FORMAT "x(70)"                                              "�" SKIP
            .

         PUT UNFORMATTED
            "����������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
            "��������� � ���, � �ᯮ�짮������ ���ண� �஢������ ������ ��� ᤥ��� (�஬� ��砥� �����⢫����               �" SKIP
            "���ॢ���� ��� ������ ���):                                                                                        �" SKIP
            "����������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
            "�   � ���                                     �" GetDat1Txt(38) FORMAT "x(70)"                                     "�" SKIP
            "����������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
         .
         
      END.
   END CASE.

   PUT UNFORMATTED
      "����ᠭ�� �������� ����㤭���� �����䨪�樨 ����樨 ��� �������饩 ��易⥫쭮�� ����஫� ��� ��稭�,               �" SKIP
      "��� ����� ᤥ��� ������������ ��� �����筠�                                                                       �" SKIP
      "����������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
   .

   str[1] = GetDat0Txt(17)
          + (IF (GetDat0Txt(18) NE "0") THEN GetDat0Txt(18) ELSE "").
   {wordwrap.i &s=str &n=10 &l=115}

   DO i = 1 TO 10:
      IF str[i] <> ""
      THEN 
         PUT UNFORMATTED
            "�   " str[i] FORMAT "x(115)" "�" SKIP.
   END.

   PUT UNFORMATTED
      "����������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
      "��������� � ���㤭���, ��⠢��襬 ᮮ�饭��                                                                          �" SKIP
      "����������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
      "�   �.�.�.                                      �                                                                      �" SKIP
      "����������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
      "�   ���������                                   �                                                                      �" SKIP
      "����������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
      "�   �������                                     �                                                                      �" SKIP
      "����������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
      "�   ���, �६�                                 �                                                                      �" SKIP
      "����������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
      "�������� ������������ �������������             �                                                                      �" SKIP
      "����������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
      "��⬥⪠ ���㤭��� �⤥�� ���/�� � ����祭�� ����饭��:                                                               �" SKIP
      "����������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
      "�   ���, �६�                                 �                                                                      �" SKIP
      "����������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
      "�   �������                                     �                                                                      �" SKIP
      "����������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
      "��⬥⪠ �⢥��⢥����� ���㤭��� � �ਭ�⮬ �襭��:                                                                 �" SKIP
      "����������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
      "�   �ਭ�� �襭��                             �                                                                      �" SKIP
      "�                                               �                                                                      �" SKIP
      "�                                               �                                                                      �" SKIP
      "�                                               �                                                                      �" SKIP
      "�                                               �                                                                      �" SKIP
      "�                                               �                                                                      �" SKIP
      "����������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
      "�   ���                                        �                                                                      �" SKIP
      "����������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
      "�������� �㪮����⥫� �����                     �                                                                      �" SKIP
      "������������������������������������������������������������������������������������������������������������������������" SKIP
   .

   /* ����� ���ଠ樨 � �।�⠢�⥫�� */
   lIsPred = NO.

   FOR EACH Data1
      WHERE Data1.Data-ID EQ ipDataID
        AND Data1.Sym1    EQ Data0.Sym1
        AND (Data1.Sym2   EQ {&SPRX-LINE}
          OR Data1.Sym2   EQ {&RPRX-LINE})
      NO-LOCK:

      IF (GetDat1Txt(1) NE "0")
      THEN DO:
         lIsPred = YES.
         LEAVE.
      END.
   END.

   IF lIsPred
   THEN DO:
      PAGE.
      PUT UNFORMATTED
         SPACE(30) "�������� � �।�⠢�⥫��." SKIP
         "����������������������������������������������������������������������������������������������������������������������Ŀ" SKIP
      .
      /* ����砥� ����� � �।�⠢�⥫� ���⥫�騪� */
      FIND FIRST Data1
         WHERE Data1.Data-ID EQ ipDataID
           AND Data1.Sym1    EQ Data0.Sym1
           AND Data1.Sym2    EQ {&SPRX-LINE}
         NO-LOCK NO-ERROR.

      cKlntStr = "0".
      IF (AVAIL Data1)
      THEN cKlntStr = GetDat1Txt(1).

      IF (cKlntStr NE "0")
      THEN DO:
         cTmp   = GetDat1Txt(20).   /* ���㬥�� */

         FIND FIRST code
            WHERE (code.class   EQ "�������")
              AND (code.parent  EQ "�������")
              AND (code.misc[6] EQ cTmp)
            NO-LOCK NO-ERROR.
         cTmp = IF (AVAIL code) THEN code.name ELSE "".

         str[1] = (IF ((cTmp EQ "") OR (cTmp EQ "0")) THEN ""
                   ELSE (cTmp + ", N " + GetDat1Txt(21)
                        + (IF (GetDat1Txt(24) EQ "0") THEN "" ELSE (" " + GetDat1Txt(24)))
                        + ", �뤠� " + STRING(DATE(GetDat1Txt(26)), "99.99.9999") + ", " + GetDat1Txt(25))).
         {wordwrap.i &s=str &n=3 &l=70}

         PUT UNFORMATTED
            "��������� � �।�⠢�⥫� ���⥫�騪�                                                                                  �" SKIP
            "����������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
            "�   �.�.�.                                      �" GetDat1Txt( 3) FORMAT "x(70)"                                      "�" SKIP
            "����������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
            "�   ���                                         �" GetDat1Txt(23) FORMAT "x(70)"                                      "�" SKIP
            "����������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
            "�   ����� ���㬥��,㤮�⮢����饣� ��筮���   �" str[1] FORMAT "x(70)"                                              "�" SKIP
            "�   (⨯,���,�����,��� � ����� �뤠�)         �" str[2] FORMAT "x(70)"                                              "�" SKIP
            "����������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
         .
         /** ���� ॣ����樨 �㦭� ࠧ���� �� ��ப�� */
         str[1] = TRIM(
                  (IF (GetDat1Txt( 7) NE "0") THEN              GetDat1Txt( 7)  ELSE "")
                + (IF (GetDat1Txt( 8) NE "0") THEN (", "      + GetDat1Txt( 8)) ELSE "")
                + (IF (GetDat1Txt( 9) NE "0") THEN (", "      + GetDat1Txt( 9)) ELSE "")
                + (IF (GetDat1Txt(10) NE "0") THEN (", �."    + GetDat1Txt(10)) ELSE "")
                + (IF (GetDat1Txt(11) NE "0") THEN (", ���." + GetDat1Txt(11)) ELSE "")
                + (IF (GetDat1Txt(12) NE "0") THEN (", ��."   + GetDat1Txt(12)) ELSE ""), ",")
         .
         {wordwrap.i &s=str &n=10 &l=70}

         PUT UNFORMATTED
            "�   ���� ॣ����樨                           �" str[1] FORMAT "x(70)"                                              "�" SKIP
         .
         DO i = 2 TO 10:
            IF (str[i] NE "")
            THEN DO:
               PUT UNFORMATTED
                  "�                                               �" str[i] FORMAT "x(70)"                                              "�" SKIP
               .
               str[i] = "".
            END.
         END.
         PUT UNFORMATTED
            "����������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
            "�   ��� � ���� ஦�����                       �" (GetDat1Txt(34) + ", " + GetDat1Txt(35)) FORMAT "x(70)"            "�" SKIP
         .
      END.

      /* ����砥� ����� � �।�⠢�⥫� �����⥫� */
      FIND FIRST Data1
         WHERE Data1.Data-ID EQ ipDataID
           AND Data1.Sym1    EQ Data0.Sym1
           AND Data1.Sym2    EQ {&RPRX-LINE}
         NO-LOCK NO-ERROR.

      cKlntPl  = cKlntStr.
      cKlntStr = "0".
      IF (AVAIL Data1)
      THEN cKlntStr = GetDat1Txt(1).

      IF (cKlntStr NE "0")
      THEN DO:
         cTmp   = GetDat1Txt(20).   /* ���㬥�� */

         FIND FIRST code
            WHERE (code.class   EQ "�������")
              AND (code.parent  EQ "�������")
              AND (code.misc[6] EQ cTmp)
            NO-LOCK NO-ERROR.
         cTmp = IF (AVAIL code) THEN code.name ELSE "".

         str[1] = (IF ((cTmp EQ "") OR (cTmp EQ "0")) THEN ""
                   ELSE (cTmp + ", N " + GetDat1Txt(21)
                        + (IF (GetDat1Txt(24) EQ "0") THEN "" ELSE (" " + GetDat1Txt(24)))
                        + ", �뤠� " + STRING(DATE(GetDat1Txt(26)), "99.99.9999") + ", " + GetDat1Txt(25))).
         {wordwrap.i &s=str &n=3 &l=70}

         IF (cKlntPl NE "0")
         THEN
            PUT UNFORMATTED
               "����������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
            .


         PUT UNFORMATTED
            "��������� � �।�⠢�⥫� �����⥫�                                                                                   �" SKIP
            "����������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
            "�   �.�.�.                                      �" GetDat1Txt( 3) FORMAT "x(70)"                                      "�" SKIP
            "����������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
            "�   ���                                         �" GetDat1Txt(23) FORMAT "x(70)"                                      "�" SKIP
            "����������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
            "�   ����� ���㬥��,㤮�⮢����饣� ��筮���   �" str[1] FORMAT "x(70)"                                              "�" SKIP
            "�   (⨯,���,�����,��� � ����� �뤠�)         �" str[2] FORMAT "x(70)"                                              "�" SKIP
            "����������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
         .
         /** ���� ॣ����樨 �㦭� ࠧ���� �� ��ப�� */
         str[1] = TRIM(
                  (IF (GetDat1Txt( 7) NE "0") THEN              GetDat1Txt( 7)  ELSE "")
                + (IF (GetDat1Txt( 8) NE "0") THEN (", "      + GetDat1Txt( 8)) ELSE "")
                + (IF (GetDat1Txt( 9) NE "0") THEN (", "      + GetDat1Txt( 9)) ELSE "")
                + (IF (GetDat1Txt(10) NE "0") THEN (", �."    + GetDat1Txt(10)) ELSE "")
                + (IF (GetDat1Txt(11) NE "0") THEN (", ���." + GetDat1Txt(11)) ELSE "")
                + (IF (GetDat1Txt(12) NE "0") THEN (", ��."   + GetDat1Txt(12)) ELSE ""), ",")
         .
         {wordwrap.i &s=str &n=10 &l=70}

         PUT UNFORMATTED
            "�   ���� ॣ����樨                           �" str[1] FORMAT "x(70)"                                              "�" SKIP
         .
         DO i = 2 TO 10:
            IF (str[i] NE "")
            THEN DO:
               PUT UNFORMATTED
                  "�                                               �" str[i] FORMAT "x(70)"                                              "�" SKIP
               .
               str[i] = "".
            END.
         END.
         PUT UNFORMATTED
            "����������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
            "�   ��� � ���� ஦�����                       �" (GetDat1Txt(34) + ", " + GetDat1Txt(35)) FORMAT "x(70)"            "�" SKIP
         .
      END.

      PUT UNFORMATTED
         "������������������������������������������������������������������������������������������������������������������������" SKIP
      .
   END.

   {preview.i}
END.

{intrface.del}
/*----------------------------------------------------------------------------*/
FUNCTION GetDat0Txt RETURN CHAR (INPUT ipItem AS INTEGER):
   RETURN ClearExtSym(GetEntries(ipItem,Data0.Txt,"~n","0")).
END FUNCTION.
/*----------------------------------------------------------------------------*/
FUNCTION GetDat1Txt RETURN CHAR (INPUT ipItem AS INTEGER):
   RETURN ClearExtSym(GetEntries(ipItem,Data1.Txt,"~n","0")).
END FUNCTION.
