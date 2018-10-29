{pirsavelog.p}

/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2004 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: ap-m17.p
      Comment: ����窠 ��� ���ਠ���
   Parameters:
         Uses:
      Used by:
      Created: 25.12.1998 Peter
     Modified: 13.09.2004 fedm
*/

{globals.i}

{intrface.get xclass}
{intrface.get db2l}
{intrface.get xobj}

{a-defs.i}
{wordwrap.def}
{ap-func.i}
{repinfo.i}

DEF INPUT PARAMETER rid       AS RECID    NO-UNDO.
/* ��� 蠡���� ��� ��� ��ࠦ���� �������� */
DEF INPUT PARAMETER iKau-Id   AS CHAR     NO-UNDO.
/* �������� � �㬬� (C), ������⢥(�) ��� ������⢥ + �㬬� (�,�) */
DEF INPUT PARAMETER iQty      AS CHAR     NO-UNDO.
/* �����뢠�� �⮣�?  */
DEF INPUT PARAMETER iTotal    AS LOGICAL  NO-UNDO.

DEF VAR okpo      AS CHAR     NO-UNDO.
/* �㬬�  */
DEF VAR mSum      AS DECIMAL  NO-UNDO EXTENT 3.
/* ���-�� */
DEF VAR mQty      AS DECIMAL  NO-UNDO EXTENT 3.
/* ����稪 */
DEF VAR mCnt      AS INT      NO-UNDO.
/* ������������ ���⠢騪� */
DEF VAR mSupplier AS CHAR     NO-UNDO EXTENT 4.
/* ��ଠ� �뢮�� �㬬� */
&GLOBAL-DEFINE SumFmt '->>>>>>>>9.99'
/* ��ଠ� �뢮�� ������⢠ */
DEF VAR mQtyFmt  AS CHAR      NO-UNDO INITIAL {&SumFmt}.

/* ��� �� ������ ����� */
DEF VAR in-dob1    LIKE op.op-date NO-UNDO.
DEF VAR schet      AS CHAR     NO-UNDO.
DEF VAR CostNew    AS DEC  NO-UNDO.

IF iQty = "�,�" THEN
   mQtyFmt = '->>>9.99'.
   
in-dob1 = today.
MESSAGE "������ ���� :" UPDATE in-dob1.

/* ��������� �������� */
DEF VAR mTitle    AS CHAR     NO-UNDO EXTENT 10 INITIAL
[
"���������������������������������������������������������������������������������������������������������������������������������������������������������������������Ŀ",
"�  ���  �       �����     ��� ���� ����祭� ��� ���� ���饭�                            � ��⭠� ������ �    ��室   �    ���室   �   ���⮪   � �������, ��� �",
"� ����� �����������������Ĵ                                                              ����᪠ �த�樨�             �             �             �               �",
"�        ����㬥�⠳  ��   �                                                              �  (ࠡ��, ���) �             �             �             �               �",
"�        �         ����浪�                                                              �                 �             �             �             �               �",
"���������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ",
"�   1    �    2    �   3   �                4                                             �        5        �      6      �      7      �      8      �       9       �",
"���������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ",
"�        �         �       � � � � � � :                                                  �                 �>            �             �             �               �",
"�����������������������������������������������������������������������������������������������������������������������������������������������������������������������"
].
IF iQty = "�,�" THEN
   ASSIGN
      OVERLAY(mTitle[ 1], 64) = "������������������������������������������������������������������������������������������������������Ŀ"
      OVERLAY(mTitle[ 2], 64) = "� ��⭠� ������ �       ��室         �        ���室        �       ���⮪        � �������, ��� �"
      OVERLAY(mTitle[ 3], 64) = "����᪠ �த�樨�                      �                      �                      �               �"
      OVERLAY(mTitle[ 4], 64) = "�   (ࠡ��, ���)��������������������������������������������������������������������Ĵ               �"
      OVERLAY(mTitle[ 5], 64) = "�                 � ���-�� �    �㬬�    � ���-�� �    �㬬�    � ���-�� �    �㬬�    �               �"
      OVERLAY(mTitle[ 6], 64) = "������������������������������������������������������������������������������������������������������Ĵ"
      OVERLAY(mTitle[ 7], 64) = "�         5       �    6   �      7      �    8   �      9      �   10   �      11     �      12       �"
      OVERLAY(mTitle[ 8], 64) = "������������������������������������������������������������������������������������������������������Ĵ"
      OVERLAY(mTitle[ 9], 64) = "�                 �>       �             �        �             �        �             �               �"
      OVERLAY(mTitle[10], 64) = "��������������������������������������������������������������������������������������������������������".

/* �����頥� "�� ���� ����祭� ��� ���� ���饭�" */
FUNCTION GetMOLName RETURNS CHAR:
   /* ���.� ���㤭��� */
   DEF VAR vTabNo     AS INT   NO-UNDO.
   /* ��� ���㤭��� */
   DEF VAR vFIO       AS CHAR  NO-UNDO.
   /* �� ���� ����祭� ��� ���� ���饭� */
   DEF VAR vName      AS CHAR  NO-UNDO.
   /* ��ਭ� ������� */
   DEF VAR vWidth     AS INT   NO-UNDO.

   /* ��᮪ ���� ��� �������樨 ⠡� � ��� */
   &SCOPED-DEFINE TabN2FIO                          ~
      vTabNo = INT(vName) NO-ERROR.                 ~
      IF NOT ERROR-STATUS:ERROR AND vTabNo > 0 THEN ~
      DO:                                           ~
         vFIO = GetObjName("employee", shFilial + "," + vName, YES). ~
         IF vFIO <> "" AND vFIO <> ? THEN           ~
            vName = vFIO.                           ~
      END.

   DEF BUFFER op FOR op.

   /* ��� �㡯஢���� ��� ������⢠ �� ������塞 */
   IF tt-kau-entry.qty <> 0 THEN
   DO:
      FOR FIRST op OF tt-kau-entry
         NO-LOCK:

         vName = GetXAttrValueEx ("op",
                                  STRING(op.op),
                                  "hand-over",
                                  ""
                                 ).
         /* �᫨ � ����⢥ ᤠ�饣� 業���� 㪠��� ⠡.� ���㤭���,
         ** � ����砥� ��� ���
         */
         {&TabN2FIO}

         IF vName = "" THEN
         DO:
            vName = GetXAttrValueEx ("op",
                                     STRING(op.op),
                                     "receipt",
                                     ""
                                    ).
            /* �᫨ � ����⢥ �����⥫� 㪠��� ⠡.� ���㤭���,
            ** � ����砥� ��� ���
            */
            {&TabN2FIO}
         END.
      END.

      IF vName = "" THEN
         vName = GetObjName("employee",
                            shFilial + "," + ENTRY(3, tt-kau-entry.kau),
                            YES
                           ).
   END.

   ASSIGN
      vWidth = (IF iQty = "�,�" THEN 35 ELSE 62)
      vName  = (IF LENGTH(vName) < vWidth
                THEN vName + FILL(" ", vWidth - LENGTH(vName))
                ELSE SUBSTR(vName, 1, vWidth)
               ).
   /* ������塞 ����� ���ࠧ������� */
   IF tt-kau-entry.qty <> 0 THEN
      OVERLAY(vName, vWidth - 8) = ENTRY(4, tt-kau-entry.kau).

   RETURN vName.

END FUNCTION.

RUN InitPrc (OUTPUT pick-value,
             OUTPUT mSupplier[1]
            ).

{wordwrap.i
   &s = mSupplier
   &n = EXTENT(mSupplier)
   &l = 18
}

{getbrnch.i &branch-id=pick-value &OKPO=okpo}

{strtout3.i &cols=168}

FIND FIRST loan  WHERE RECID(loan) = rid NO-LOCK.
FIND FIRST asset WHERE asset.cont-type = loan.cont-type NO-LOCK.
FIND LAST loan-acct of loan where loan-acct.acct-type = "�����-���" 
                               and loan-acct.since LE in-dob1 NO-LOCK.

schet = loan-acct.acct.
CostNew = GetCostUMC(loan.contract + CHR(6) + loan.cont-code,
                     in-dob1,
		     "",
		     ""
		     ).

PUT UNFORMATTED
  SPACE(75) '����窠 N-' loan.cont-code ' ��� ���ਠ���'                            SKIP
  SPACE(136)                                          '                 ������������Ŀ' SKIP
  SPACE(136)                                          '                 �    ����    �' SKIP
  SPACE(136)                                          '                 ������������Ĵ' SKIP
  SPACE(136)                                          '   ��ଠ �� ���� �   0315008  �' SKIP
  SPACE(136)                                          '                 ������������Ĵ' SKIP
             '�࣠������ ' name-bank format 'x(124)' '         �� ���� �' okpo FORMAT 'x(8)'  '    �' SKIP
  SPACE(136)                                          '                 ������������Ĵ' SKIP
  SPACE(136)                                          '��� ��⠢����� � ' STRING(DAY  (in-dob1), '>9')   '� '
                                                                            STRING(MONTH(in-dob1), '>9')   '�'
                                                                            STRING(YEAR (in-dob1), '9999') '�' SKIP
  SPACE(136)                                          '                 ��������������' SKIP
             '������୮� ���ࠧ������� ' GetDocParamFmt('������', ?) SKIP(1)
  '���������������������������������������������������������������������������������������������������������������������������������������������������������������������Ŀ' SKIP
  '� ������୮�  �  ���   ����������� �࠭���� ��ઠ � ���� ���䨫쳐����� ������������ ������� ����७��   ����, ��.���.  � ��ଠ �  �ப  �     ���⠢騪    �' SKIP
  '����ࠧ������� ����⥫�-�     ��������������Ĵ       �      �       �      �     �����      �����������������Ĵ                   ������ �������⨳                  �' SKIP
  '�              � ����  �     ��⥫�����祩���       �      �       �      �                ���� ��������������                   �       �        �                  �' SKIP
  '���������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ' SKIP
  '�' GetDocParamFmt('������', 'x(14)')
  '�' SPACE(8)
  '�' pick-value   FORMAT 'x(5)'
  '�' GetAssetParamFmt('�⥫���', 'x(7)')
  '�' GetAssetParamFmt('�祩��', 'x(6)')
  '�' GetAssetParamFmt('��ઠ', 'x(7)')
  '�' GetAssetParamFmt('����', 'x(6)')
  '�' GetAssetParamFmt('��䨫�', 'x(7)')
  '�' GetAssetParamFmt('������', 'x(6)')
  '�' GetAssetParamFmt('�����������', 'x(16)')
  '�' GetAssetParamFmt('������', 'x(4)')
  '�' GetAssetParamFmt('�����栍���', 'x(12)')
/*  '�' GetAssetParamFmt('����','>>>>,>>>,>>>,>>9.99')*/
  '�' string(CostNew,'>>>>,>>>,>>>,>>9.99')
  '�' GetAssetParamFmt('��ଠ�����', 'x(7)')
  '�' GetAssetParamFmt('�ப��', 'x(8)')
  '�' mSupplier[1] FORMAT 'x(18)'
  '�'
SKIP.

DO mCnt = 2 TO EXTENT(mSupplier):
   IF TRIM(mSupplier[mCnt]) = "" THEN
      LEAVE.

   PUT UNFORMATTED
      '�              �        �     �       �      �       �      �       �      �                �    �            �                   �       �        �'
      mSupplier[mCnt] FORMAT 'x(18)'
      '�'
   SKIP.
END.

PUT UNFORMATTED
   '�����������������������������������������������������������������������������������������������������������������������������������������������������������������������'
SKIP(1).

/* �뢮� ���ଠ樨 � �ࠣ.���ਠ��� */
RUN PutGold.

/* ������ �������� �� ����窥 */
PUT UNFORMATTED
   mTitle[1] SKIP
   mTitle[2] SKIP
   mTitle[3] SKIP
   mTitle[4] SKIP
   mTitle[5] SKIP
   mTitle[6] SKIP
   mTitle[7] SKIP
   mTitle[8] SKIP.

FOR
   EACH  tt-kau-entry WHERE
         tt-kau-entry.kau-id   = iKau-Id
     AND tt-kau-entry.kau BEGINS loan.contract + "," + loan.cont-code + ","
     AND ENTRY(4, tt-kau-entry.kau) = pick-value
     AND tt-kau-entry.op-date LE in-dob1
      NO-LOCK
/*��� �뫠 ������ ��᫥ NO-LOCK
   FIRST op OF tt-kau-entry
      NO-LOCK */

   BREAK BY tt-kau-entry.op-date
         BY tt-kau-entry.op
         BY tt-kau-entry.op-entry:
   FIND FIRST op OF tt-kau-entry NO-LOCK NO-ERROR. 
    
   ACCUMULATE tt-kau-entry.op-date (SUB-COUNT BY tt-kau-entry.op-date).

   PUT UNFORMATTED
      '�' tt-kau-entry.op-date       FORMAT '99/99/99'
      '�' (IF AVAILABLE op
           THEN op.doc-num
           ELSE "��"
          )                          FORMAT 'x(9)'
      '�' ACCUM SUB-COUNT BY tt-kau-entry.op-date tt-kau-entry.op-date
                                     FORMAT '>>>>>>9'
      '�' GetMOLName()
      '�                 '.

   IF tt-kau-entry.debit THEN /* ��室 */
      ASSIGN
         mQty [1] = tt-kau-entry.qty
         mSum [1] = tt-kau-entry.amt-rub
         mQty [2] = 0
         mSum [2] = 0.        /* ���室 */
   ELSE
      ASSIGN
         mQty [1] = 0
         mSum [1] = 0
         mQty [2] = tt-kau-entry.qty
         mSum [2] = tt-kau-entry.amt-rub.

   ASSIGN                     /* ���⮪ */
      mQty [3] = mQty [3] + mQty [1] - mQty [2]
      mSum [3] = mSum [3] + mSum [1] - mSum [2].

   /* �뢮� ����⮢ � ���⪠ � �㬬� �/��� ������⢥ */
   RUN PutSumm.

   /* ����������� �⮣� �� ����⠬ */
   IF iTotal THEN
      ACCUMULATE
         mQty [1] (TOTAL)
         mSum [1] (TOTAL)
         mQty [2] (TOTAL)
         mSum [2] (TOTAL).
END.

/* ��ப� �⮣�� */
IF iTotal THEN
DO:
   PUT UNFORMATTED
      mTitle[8] SKIP
      SUBSTR(mTitle[9], 1, INDEX(mTitle[9], "�>") - 1).

   ASSIGN
      mQty [1] = (ACCUM TOTAL mQty [1])
      mSum [1] = (ACCUM TOTAL mSum [1])
      mQty [2] = (ACCUM TOTAL mQty [2])
      mSum [2] = (ACCUM TOTAL mSum [2]).

   /* �뢮� �⮣�� ����⮢ � ��᫥����� ���⪠ � �㬬� �/��� ������⢥ */
   RUN PutSumm.
END.

FIND _user WHERE _user._userid = USERID('bisquit') NO-LOCK.
PUT UNFORMATTED
  mTitle[10] SKIP(1)
  '  ������ ��������    ' GetXattrValue("_user", USERID('bisquit'), "���������")
                                           _user._User-Name AT 70 SKIP
  '                      _____________________  _____________________  ________________________________________' SKIP
  '                          ���������                 �������               ����஢�� ������' SKIP(1)
  '     "___"___________ 20   �.'
SKIP.

{endout3.i}

/* 1. ��⠭����/����� ���� ���ࠧ�������
   2. ����祭�� ������������ ���⠢騪�
*/
PROCEDURE InitPrc:
   /* ��࠭�� ᪫�� */
   DEF OUTPUT PARAMETER oBranch-Id  AS CHAR  NO-UNDO.
   /* ���⠢騪 */
   DEF OUTPUT PARAMETER oSupplier   AS CHAR  NO-UNDO.

   DEF BUFFER loan       FOR loan.
   DEF BUFFER kau-entry  FOR kau-entry.
   DEF BUFFER op         FOR op.

   FOR
      FIRST loan      WHERE
            RECID(loan) = rid
         NO-LOCK,

      EACH  kau-entry WHERE
            kau-entry.kau-id   = iKau-Id
        AND kau-entry.kau BEGINS loan.contract + "," + loan.cont-code + ","
         NO-LOCK:

      IF NUM-ENTRIES(kau-entry.kau) >= 4  AND
         NOT CAN-DO(oBranch-Id, ENTRY(4,kau-entry.kau)) THEN
         {additem.i oBranch-Id ENTRY(4,kau-entry.kau) }

      IF oSupplier = "" THEN
      FOR FIRST op OF kau-entry
         NO-LOCK:
         oSupplier = GetXAttrValueEx ("op",
                                      STRING(op.op),
                                      "where-buy",
                                      ""
                                     ).
      END.
   END.

   IF oSupplier = "" THEN
      oSupplier = GetXAttrValueEx ("loan",
                                   loan.contract + "," + loan.cont-code,
                                   "���⠢騪",
                                   ""
                                  ).
   /* �᫨ � ����⢥ �����⥫� 㪠��� ��� �� �����䨪��� "���⠢騪�",
   ** � ����砥� �� ���� ������������ ���⠢騪�.
   */
   IF oSupplier <> "" AND
      AvailCode("���⠢騪�", oSupplier) THEN
      oSupplier = GetCodeName("���⠢騪�", oSupplier).

   IF NUM-ENTRIES(oBranch-Id) > 1 THEN
   DO TRANSACTION:
      RUN browseld.p
         ("branch",                   /* ����� ��ꥪ�. */
          "title"          + CHR(1) + /* ���� ��� �।��⠭����. */
          "branch-id"      + CHR(1) + /* ���� ��� �।��⠭����. */
          "LineStruct",
          "�������� �����" + CHR(1) +
          oBranch-Id       + CHR(1) +
          "yes",                      /* ���᮪ ���祭�� �����. */
          "branch-id",
          4                           /* ��ப� �⮡ࠦ���� �३��. */
         ).

      oBranch-Id = (IF pick-value = ? OR pick-value = ""
                    THEN ?
                    ELSE pick-value
                   ).
   END.

   RETURN.

END PROCEDURE.

/* �뢮� ����⮢ � ���⪠ � �㬬� �/��� ������⢥ */
PROCEDURE PutSumm:
   /* ��室 */
   IF CAN-DO(iQty, "�") THEN
      PUT UNFORMATTED '�'
         IF mQty [1] = 0
         THEN FILL(' ', LENGTH(mQtyFmt))
         ELSE STRING(mQty [1], mQtyFmt)
      .
   IF CAN-DO(iQty, "�") THEN
      PUT UNFORMATTED '�'
         IF mSum [1] = 0
         THEN FILL(' ', LENGTH({&SumFmt}))
         ELSE STRING(mSum [1], {&SumFmt})
      .

   /* ���室 */
   IF CAN-DO(iQty, "�") THEN
      PUT UNFORMATTED '�'
         IF mQty [2] = 0
         THEN FILL(' ', LENGTH(mQtyFmt))
         ELSE STRING(mQty [2], mQtyFmt)
      .
   IF CAN-DO(iQty, "�") THEN
      PUT UNFORMATTED '�'
         IF mSum [2] = 0
         THEN FILL(' ', LENGTH({&SumFmt}))
         ELSE STRING(mSum [2], {&SumFmt})
      .

   /* ���⮪ */
   IF CAN-DO(iQty, "�") THEN
      PUT UNFORMATTED '�'
         STRING(mQty [3],  mQtyFmt).

   IF CAN-DO(iQty, "�") THEN
      PUT UNFORMATTED '�'
         STRING(mSum [3], {&SumFmt}).

   PUT UNFORMATTED
      "�               �"
   SKIP.

   RETURN.

END PROCEDURE.

/* �뢮� ���ଠ樨 � �ࠣ.���ਠ��� */
PROCEDURE PutGold:
   &SCOPED-DEFINE AT_SKIP AT 77 SKIP
   /* ��������� */
   DEF VAR vTitle    AS CHAR     NO-UNDO EXTENT 11 INITIAL
   ["�����������������������������������������������������������������������������������������Ŀ",
    "�                          �ࠣ�業�� ���ਠ� (��⠫�, ������)                          �",
    "�����������������������������������������������������������������������������������������Ĵ",
    "� ������������ � ��� � ������������ ������� ����७�ﳪ�����⢮�   �����  �           �",
    "�              �     �     �����      �����������������Ĵ  (����) � ��ᯮ�� �           �",
    "�              �     �                ���� ��������������          �          �           �",
    "�����������������������������������������������������������������������������������������Ĵ",
    "�      1       �  2  �       3        � 4  �     5      �    6     �    7     �     8     �",
    "�����������������������������������������������������������������������������������������Ĵ",
    "�[������      ]�     �                �    �            �[���᠄� ]�          �           �",
    "�������������������������������������������������������������������������������������������"
   ].

   /* ��ப� ���� */
   DEF VAR vStr      AS CHAR     NO-UNDO.
   /* ����稪 */
   DEF VAR vCnt      AS INT      NO-UNDO.

   PUT UNFORMATTED
    "������������ ���ਠ��:"                   vTitle[1] {&AT_SKIP}
    CAPS(GetAssetParamFmt("������������", "x(76)")) vTitle[2] {&AT_SKIP}
                                                vTitle[3] {&AT_SKIP}
    "��� ���:"                               vTitle[4] {&AT_SKIP}
    schet                                       vTitle[5] {&AT_SKIP}
                                                vTitle[6] {&AT_SKIP}
                                                vTitle[7] {&AT_SKIP}
                                                vTitle[8] {&AT_SKIP}
                                                vTitle[9] {&AT_SKIP}.
   DO vCnt = 1 TO 4:
      vStr = GetValue ((BUFFER asset:HANDLE),
                       "precious-" + STRING(vCnt)
                      ).

      IF vStr <> "0" THEN
      DO:
         ASSIGN
            vStr = REPLACE(vTitle[10],
                           "[���᠄� ]",
                           STRING(vStr, "xxxxxxxxxx")
                          )
            vStr = REPLACE(vStr,
                           "[������      ]",
                           STRING(GetXAttrEx("asset",
                                             "precious-" + STRING(vCnt),
                                             "xattr-label"
                                            ),
                                  "xxxxxxxxxxxxxx"
                                 )
                          ).
         PUT UNFORMATTED
            vStr {&AT_SKIP}.
      END.
   END.

   PUT UNFORMATTED
      vTitle[11] {&AT_SKIP}(1).

   RETURN.

END PROCEDURE.