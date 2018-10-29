/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2008 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: card_rep.p
      Comment: �믨᪠ �� ����. ��� 54 �� !!!
   Parameters:
         Uses:
      Used by:
      Created: 11/02/2008  BMS
     Modified: 11/02/2008  BMS
     Modified: 21/05/2008  JADV (0091047)
*/

DEF INPUT PARAM iCont-code AS CHAR NO-UNDO.
DEF INPUT PARAM iDate-from AS DATE NO-UNDO.
DEF INPUT PARAM iDateTo    AS DATE NO-UNDO.

{globals.i}

{sh-defs.i}
{intrface.get tmess}
{intrface.get strng}
{intrface.get card}
{intrface.get cust}
{intrface.get xclass}
{intrface.get instrum}
{intrface.get loan}
{intrface.get date}

DEF VAR mDateFrom   AS DATE NO-UNDO.
DEF VAR mDateTo     AS DATE NO-UNDO.
DEF VAR mCnt        AS INT  NO-UNDO.
DEF VAR mFormatDec  AS CHAR NO-UNDO INIT "->>>,>>>,>>9.99".
DEF VAR mDet        AS CHAR NO-UNDO. /* ����ঠ��� ����樨 � ���. ��ப     */
DEF VAR mDetEnt     AS INT  NO-UNDO. /* ����ঠ��� ����樨 � ���. ��ப     */
DEF VAR mAcctP      AS CHAR NO-UNDO. /* �� ��� ������⥫��� ���ᮢ�� ࠧ��� */
DEF VAR mAcctN      AS CHAR NO-UNDO. /* �� ��� ����⥫��� ���ᮢ�� ࠧ��� */
DEF VAR mTextNP     AS LOG  NO-UNDO. /* ��६ ⥪�� ��ப� �� ��              */
DEF VAR mNameOrg    AS CHAR NO-UNDO.


DEF VAR RepTempl  AS CHAR NO-UNDO FORMAT "x(150)" EXTENT 40 INITIAL
[
"������������������������������������������������������������������������������������������������������������������������������������������������������Ŀ",
"�              �                                                              ���� �믨᪨�_��⠢믨᪨                                               �",
"�    �.�.�.    �_�������                                                      �Report date �                                                           �",
"� Client name  �                                                              ������������������������������������������������������������������������Ĵ",
"�              �_Familia1                                                     � ��� �����  �_��������                                                  �",
"�              �_Familia2                                                     � Card type  �                                                           �",
"������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ",
"�    ����     �_����                                                        ������ ����� �_����ઠ���                                                �",
"�   Address    �                                                              �Card number �                                                           �",
"��������������������������������������������������������������������������������������������������������������������������������������������������������",
" ",
"������������������������������������������������������������������������������������������������������������������������������������������������������Ŀ",
"�              �            �                                         �              �             �㬬�               �               �               �",
"���� ����樨 ���� ���⠳          ����ঠ��� ����樨            �     ���      �             Amount              �   �������    �     �⮣�     �",
"�Operation date� Value date �           Operation details             � ���ਧ�樨  ���������������������������������Ĵ      fee      �     Total     �",
"�              �            �                                         �Operation code�� ����� ����樨�� ����� ��� �               �               �",
"�              �            �                                         �              �    Operation    �    Account    �               �               �",
"������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ",
"�_��⠮���樨 �_������⠳_����ঠ�������樨                      �_������ਧ�� �_�����⥮���     �_���������  �_�������      �_�⮣�         �",
"�              �            �_����ঠ�������樨                      �              �                 �               �               �               �",
"������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ",
"������������ ������� (Insurance deposit):                                                              �_��᭨����멮��⮪                            �",
"���� ������������ ��������                                                                            �_��⣠�⯮��                                 �",
"�������� �� ������ ������� (Initial balance):                                                          �_���⮪����砫���ਮ��                        �",
"������� �� ������� �� ������ (Credit turnover):                                                        �_����⯮��室㧠��ਮ�                       �",
"������� �� ������� �� ������ (Debit turnover):                                                         �_����⯮��室㧠��ਮ�                       �",
"�������� �� ����� ������� (Total balance):                                                             �_���⮪������毥ਮ��                         �",
"�������������� ����� (������������ ��������) (Blocked amount):                                         �_�����஢������㬬�                            �",
"����������� ���������� (��������� �����) (Acceptable overdarft):                                       �_�����⨬멯����室                          �",
"�������� ��������� ����� (opento-buy):                                                                 �_����騩��室�멫����                         �",
"���������� ����� (available quota):                                                                    �_����㯭멫����                                �",
"������ ���������� (Debts)                                                                              �_�㬬��������                               �",
"������ ����������������� ����������                                                                    �_�㬬���ᯎ���                                 �",
"������ ������ ����������                                                                               �_�㬬�����⠮������                         �",
"������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ",
"������:                                         ����.��.�_�㬬�������⥦�    ����� ���.��.�_��⠬����  ����� ����.������_��⠪���३�-��ਮ��          �",
"������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ",
"������ �������������� ����������                                                                       �_�㬬���ࠧ�襭�����������                 �",
"������ ������������ �������������                                                                      �_�㬬�����祭���������������                �",
"��������������������������������������������������������������������������������������������������������������������������������������������������������"
].

DEF VAR RepTempl2  AS CHAR NO-UNDO FORMAT "x(150)" EXTENT 5 INITIAL
[
"������������������������������������������������������������������������������������������������������������������������������������������������������Ŀ",
"� �࣠������  �_�࣠������                                                                                                                           �",
"��������������������������������������������������������������������������������������������������������������������������������������������������������"
].

DEF STREAM fil.

DEF TEMP-TABLE tt-cardrep NO-UNDO
   FIELD name        AS CHAR /* ���                                           */
   FIELD data        AS DATE /* ��� �믨᪨                                  */
   FIELD type-card   AS CHAR /* ⨯ �����                                     */
   FIELD address     AS CHAR /* ����                                         */
   FIELD card_num    AS CHAR /* ����� �����                                   */
   FIELD ins_depos   AS DEC  /* ��᭨����� ���⮪                           */
   FIELD bal_sgp     AS DEC  /* ��� ��࠭⨩���� �������                    */
   FIELD init_bal    AS DEC  /* ���⮪ �� ��砫� ��ਮ��                     */
   FIELD credit_turn AS DEC  /* ����� �� ��室� �� ��ਮ�                   */
   FIELD debit_turn  AS DEC  /* ����� �� ��室� �� ��ਮ�                   */
   FIELD total_bal   AS DEC  /* ���⮪ �� ����� ��ਮ��                      */
   FIELD block_amm   AS DEC  /* �����஢����� �㬬� (�����-��� ����樨 + 2%)*/
   FIELD avail_amt   AS DEC  /* ����㯭� �����                               */
   FIELD ovefdraft   AS DEC  /* �����⨬� �����室 (�।��� �����)       */
   FIELD open_to_buy AS DEC  /* ����騩 ��室�� �����                       */
   FIELD debts       AS DEC  /* �㬬� �������                              */
   FIELD notover     AS DEC  /* �㬬� ���ᯮ�짮������� �������            */
   FIELD LimOver     AS DEC  /* �㬬� ����� �������                       */
   FIELD amt_min_pay AS DEC  /* �㬬� �������쭮�� ���⥦� */
   FIELD dat_min_pay AS DATE /* ��� �������쭮�� ���⥦� */
   FIELD dat_grs_end AS DATE /* ��� ����砭�� �३�-��ਮ�� */
   FIELD amt_uns_ovd AS DEC  /* �㬬� ��ࠧ�襭���� ������� */
   FIELD amt_pst_due AS DEC  /* �㬬� ����祭��� ������������ */
   FIELD flg_grs_pnt AS LOG  /* ������ �� ��ப� � �३� ��ਮ�� */

   INDEX card_num card_num
.

DEF TEMP-TABLE tt-opcard NO-UNDO
   FIELD card_num    AS CHAR /* ����� �����                                   */
   FIELD date_op     AS DATE /* ��� ����樨                                 */
   FIELD date_val    AS DATE /* ��� ����                                  */
   FIELD details     AS CHAR /* ���������� ����樨                           */
   FIELD code_op     AS CHAR /* ��� ���ਧ�樨                               */
   FIELD amm_op      AS DEC  /* �㬬� ����樨 � ����� ����樨              */
   FIELD amm_acct    AS DEC  /* �㬬� ����樨 � ����� ���                 */
   FIELD comm        AS DEC  /* �������                                      */
   FIELD total       AS DEC  /* �������                                      */
   FIELD scs         AS CHAR /* ��� SCS                                      */
   FIELD acct-cor    AS CHAR /* ����ᯮ������騩 ��� � �஢����             */
   FIELD curr        AS CHAR /* ����� ����樨                               */
   FIELD AddOper     AS LOG  /* ��� ����樨. �� - �������⥫쭠�             */

   INDEX card_num card_num
.

DEF BUFFER Pcard  FOR loan. /* ���� ����� �� ���ன ���⠥��� ���� */

/* ���� �� �易��� ������� ������� */
FUNCTION IsOverdraft RETURNS LOG (iPaContract AS CHAR,
                                  iPaContCode AS CHAR,
                                  iSince      AS DATE
                                 ):

   DEF VAR          vAcct       AS CHAR   NO-UNDO.
   DEF VAR          vCurr       AS CHAR   NO-UNDO.

   DEF BUFFER  loan      FOR loan.      /* ������� */
   DEF BUFFER bloan      FOR loan.      /* ������� */
   DEF BUFFER  loan-acct FOR loan-acct.

   /* ��।������ ������� ����� */
   FOR FIRST loan WHERE loan.contract  EQ iPaContract
                    AND loan.cont-code EQ iPaContCode
   NO-LOCK:
      RUN GetRoleAcct IN h_card (       loan.contract + "," + loan.cont-code,
                                        iSince,
                                        "SCS",
                                        loan.currency,
                                 OUTPUT vAcct,
                                 OUTPUT vCurr
      ).

      IF vAcct NE ""
      THEN DO:
         FOR EACH loan-acct WHERE loan-acct.acct      EQ vAcct
                              AND loan-acct.currency  EQ vCurr
                              AND loan-acct.acct-type EQ "�।����"
                              AND loan-acct.since     LE iSince
         NO-LOCK,
         FIRST    bloan     OF loan-acct
         NO-LOCK:
            IF GetXattrValue ("loan",
                              bloan.contract + "," + bloan.cont-code,
                              "���⎢��"
                             ) EQ "�����" THEN
               RETURN YES.
         END.
      END.
   END.

   RETURN NO.
END FUNCTION.

/* -------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------- */


MAIN:
DO ON ERROR UNDO MAIN, LEAVE MAIN:

   FIND FIRST Pcard WHERE Pcard.contract  EQ "card"
                      AND Pcard.cont-code EQ iCont-code
   NO-LOCK NO-ERROR.

   IF NOT AVAIL Pcard THEN
      UNDO MAIN, LEAVE MAIN.

   ASSIGN
      mDateFrom   = iDate-from
      mDateTo     = iDateTo
   .

   /* ���������� �६����� ⠡��� ��� �믨᪨. */
   RUN BuildCardRep (Pcard.contract,
                     Pcard.cont-code
   ).

   /* ����� �믨᪨ �� ����� ����. */
   {setdest.i
      &stream   = "stream fil"
      &append   = "append"
   }

   RUN PrintCardRep (Pcard.contract,
                     Pcard.cont-code
   ).
END.

{intrface.del}



/* -------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------- */

/* ���������� �६����� ⠡��� ��� �믨᪨ */
PROCEDURE BuildCardRep:
   DEF INPUT  PARAM iContract   AS CHAR   NO-UNDO.
   DEF INPUT  PARAM iContCode   AS CHAR   NO-UNDO.

   DEF BUFFER card  FOR loan.
   DEF BUFFER card2 FOR loan.

   FIND FIRST card WHERE card.contract  EQ iContract
                     AND card.cont-code EQ iContCode
   NO-LOCK.

   DEF VAR         vClName AS CHAR NO-UNDO EXTENT 3.
   DEF VAR         vInn    AS CHAR NO-UNDO.
   DEF VAR         vKpp    AS CHAR NO-UNDO.
   DEF VAR         vType   AS CHAR NO-UNDO.
   DEF VAR         vCode   AS CHAR NO-UNDO.
   DEF VAR         vAcct   AS CHAR NO-UNDO.
   DEF VAR         vAddres AS CHAR NO-UNDO.
   DEF VAR         vAmt1   AS DEC  NO-UNDO.
   DEF VAR         vAmt2   AS DEC  NO-UNDO.
   DEF VAR         vAcctRl AS CHAR NO-UNDO.
   DEF VAR         vCurrRl AS CHAR NO-UNDO.
   DEF VAR vCardContract   AS CHAR NO-UNDO. /* �����祭�� ����筮�� �������   */
   DEF VAR vCardContCode   AS CHAR NO-UNDO. /* ����� ����筮�� �������        */
   DEF VAR vAmtMinPay      AS DEC  NO-UNDO. /* �㬬� �������쭮�� ���⥦�       */
   DEF VAR vDateMinPay     AS DATE NO-UNDO. /* ��� �������쭮�� ���⥦�        */
   DEF VAR vDateGraceEnd   AS DATE NO-UNDO. /* ��� ����砭�� �३�-��ਮ��     */
   DEF VAR vFlgGracePrint  AS LOG  NO-UNDO. /* �ਧ��� �뢮�� �� ����� �३�   */
   DEF VAR vAmtUnSolvOvdft AS DEC  NO-UNDO. /* �㬬� ��ࠧ�襭���� �������  */
   DEF VAR vAmtPastDueLoan AS DEC  NO-UNDO. /* �㬬� ����祭��� ������������ */
   DEF VAR vAcctTypeTmp    AS CHAR NO-UNDO. /* ���� ��㤭��� ��� �� ��        */
   DEF VAR vAcctTmp        AS CHAR NO-UNDO. /* �����誠 */
   DEF VAR vCurrTmp        AS CHAR NO-UNDO. /* �����誠 */

   RUN GetCustName IN h_base (             card.cust-cat,
                                           card.cust-id,
                                           "",
                              OUTPUT       vClName[1],
                              OUTPUT       vClName[2],
                              INPUT-OUTPUT vClName[3]
   ).

   FIND FIRST loan WHERE loan.contract  EQ card.parent-contract
                     AND loan.cont-code EQ card.parent-cont-code
   NO-LOCK.


   CREATE tt-cardrep.
   ASSIGN
      tt-cardrep.name      = vClName[1] + " " + vClName[2]
                           + CHR(1) + card.user-o[2] + CHR(1) + card.user-o[3]
      tt-cardrep.address   = GetCliName (             card.cust-cat,
                                                      STRING (card.cust-id),
                                         OUTPUT       vAddres,
                                         OUTPUT       vINN,
                                         OUTPUT       vKPP,
                                         INPUT-OUTPUT vType,
                                         OUTPUT       vCode,
                                         OUTPUT       vAcct
                                        )
      tt-cardrep.address   = ""
      tt-cardrep.address   = vAddres
      tt-cardrep.type-card = GetCodeName("����끠���", card.sec-code) + " "
                           + GetISOCode(loan.currency)
      tt-cardrep.data      = IF FGetSettingEx ("����믨᪠",
                                               "�믨᪠���",
                                               "",
                                               NO
                                              ) EQ "���⥬���"
                             THEN TODAY
                             ELSE gend-date
      tt-cardrep.card_num  = SUBSTR(card.doc-num, 1 , 4) + " xxxx xxxx "
                           + SUBSTR(card.doc-num, 13, 2) + "xx"
   .

   /* ��।������ � ��࠭���� � tt-card ��᭨������� ���⪠ */
   RUN CardMinOst (       card.contract,
                          card.cont-code,
                          mDateTo,
                   OUTPUT vAmt1
   ).
   ASSIGN
      tt-cardrep.ins_depos = vAmt1
      vAmt1                = 0
      vAddres              = FGetSettingEx ("����믨᪠",
                                            "���쑃�",
                                            "",
                                            NO
                                           )
   .

   /* C�� ��࠭⨩���� ������� */

   RUN GetRoleAcct IN h_card (       loan.contract + "," + loan.cont-code,
                                     mDateTo,
                                     vAddres,
                                     loan.currency,
                              OUTPUT vAcctRl,
                              OUTPUT vCurrRl
   ).
   IF vAcctRl NE ""
   THEN DO:
      RUN acct-pos IN h_base (vAcctRl,
                              vCurrRl,
                              mDateTo,
                              mDateTo,
                              gop-status
                             ).

      IF vCurrRl EQ "" THEN
         tt-cardrep.bal_sgp = sh-bal * (- 1).
      ELSE
         tt-cardrep.bal_sgp = sh-val * (- 1).
   END.

   /* �᫨ ���� � �� �᭮����, ���� ���� ��௮�⨢��� � ��� �ᥣ� ���� ��� ᢮��� ����筮�� ������� */
   IF    (loan.contract EQ "card-pers"
      AND Pcard.loan-work
         )
      OR (loan.contract EQ "card-corp"
      AND NOT CAN-FIND (FIRST card2 WHERE card2.parent-contract  EQ "card-corp"
                                      AND card2.parent-contract  EQ loan.contract
                                      AND card2.parent-cont-code EQ loan.cont-code
                                      AND RECID(card2)           NE RECID(Pcard)
                       )
         ) THEN
   DO:
      /* �������������. */
      RUN GetCredit (       card.parent-contract,
                            card.parent-cont-code,
                     OUTPUT vAmt1
                    ).
      ASSIGN
         tt-cardrep.debts = vAmt1
         vAmt1               = 0
      .

      /* ���ᯮ�짮����� �����. */
      RUN GetLim (       card.parent-contract,
                         card.parent-cont-code,
                  OUTPUT vAmt1
                 ).
      ASSIGN
         tt-cardrep.notover = vAmt1
         vAmt1              = 0
         tt-cardrep.LimOver = tt-cardrep.debts + tt-cardrep.notover
      .
   END.

   /* ��।������ � ��࠭���� � tt-card ���⪠ �� ��砫� ��ਮ�� */
   /*
      �᫨ ���� �������⥫쭠� � ����஥�� ��ࠬ��� ����믨᪠/���⮪������� = ���
      �㬬� ���⪠ ��⠥��� = 0.

      �᫨ ���� ��௮�⨢��� � ����஥�� ��ࠬ��� ����믨᪠/���⮪��ொ��� = ���
      �㬬� ���⪠ ��⠥��� = 0.
   */
   IF    (
            NOT Pcard.loan-work
      AND   FGetSettingEx ("����믨᪠",
                           "���⮪�������",
                           "",
                           NO
                          ) EQ "���"
         )
      OR
         (
            loan.contract  EQ "card-corp"
      AND   FGetSettingEx ("����믨᪠",
                           "���⮪��ொ���",
                           "",
                           NO
                          ) EQ "���"
         ) THEN
      tt-cardrep.init_bal = 0.

   ELSE DO:
      RUN CardInitBal (       card.parent-contract,
                              card.parent-cont-code,
                              mDateFrom,
                       OUTPUT vAmt1
      ).
      ASSIGN
         tt-cardrep.init_bal = vAmt1
         vAmt1               = 0
      .
   END.

   /* ��।������ � ��࠭���� � tt-card �����⨬��� �����室� */
   RUN CardOverdraft (       card.parent-contract,
                             card.parent-cont-code,
                             mDateTo,
                      OUTPUT vAmt1
   ).
   ASSIGN
      tt-cardrep.ovefdraft = vAmt1
      vAmt1                = 0
      vAmt2                = 0
   .

   /* ����஥��� ᯨ᪠ ����権 �� ���� */
   RUN BuildOpCard (card.contract,
                    card.cont-code,
                    loan.contract,
                    loan.cont-code
   ).



/**************************************/
   /* ��।������ � ��࠭���� � tt-card ��室�饣� ���⪠ */
   /*
      �᫨ ���� �������⥫쭠� � ����஥�� ��ࠬ��� ����믨᪠/���⮪������� = ���
      �㬬� ���⪠ ��⠥��� = 0.

      �᫨ ���� ��௮�⨢��� � ����஥�� ��ࠬ��� ����믨᪠/���⮪��ொ��� = ���
      �㬬� ���⪠ ��⠥��� = 0.
   */
   IF    (
            NOT Pcard.loan-work
      AND   FGetSettingEx ("����믨᪠",
                           "���⮪�������",
                           "",
                           NO
                          ) EQ "���"
         )
      OR
         (
            loan.contract  EQ "card-corp"
      AND   FGetSettingEx ("����믨᪠",
                           "���⮪��ொ���",
                           "",
                           NO
                          ) EQ "���"
         ) THEN
      tt-cardrep.total_bal = 0.
/*      
   ELSE
      ASSIGN
         tt-cardrep.total_bal = tt-cardrep.init_bal + vAmt1 - vAmt2
         vAmt1                = 0
      .
*/

ELSE DO:
   RUN CardInitBal (       card.parent-contract,
                          card.parent-cont-code,
			  	      			                                 mDateto + 1,
							                     OUTPUT vAmt1
									        ).
										   ASSIGN
										         tt-cardrep.total_bal = vAmt1
											       vAmt1               = 0
											          .
												  END.

/*
message tt-cardrep.init_bal skip
vAmt1 skip
vAmt2 skip
tt-cardrep.total_bal
view-as alert-box.
*/
/**************************************/



   RUN GetBlockedAmt(       card.doc-num,
                            card.contract + "," + card.cont-code,
                            loan.contract,
                            loan.cont-code,
                     OUTPUT tt-cardrep.block_amm).

   RUN GetAvailAmt(       card.doc-num,
                          card.contract + "," + card.cont-code,
                          loan.contract,
                          loan.cont-code,
                   OUTPUT tt-cardrep.avail_amt).

   /* ��।����� � ��࠭���� tt-card ���⥦���� ����� */
   RUN CardCurrentLimit (card.contract,
                         card.cont-code,
                         loan.contract,
                         loan.cont-code
   ).

   /* ������ �� ���� */
   RUN CardTurnovers (       Pcard.contract,
                             Pcard.cont-code,
                      OUTPUT vAmt1,
                      OUTPUT vAmt2
   ).

   ASSIGN
      tt-cardrep.credit_turn = vAmt1
      tt-cardrep.debit_turn  = ABS(vAmt2)
      vAmt1                  = 0
      vAmt2                  = 0
   .


/*
   /* ��।������ � ��࠭���� � tt-card ��室�饣� ���⪠ */
   /*
      �᫨ ���� �������⥫쭠� � ����஥�� ��ࠬ��� ����믨᪠/���⮪������� = ���
      �㬬� ���⪠ ��⠥��� = 0.

      �᫨ ���� ��௮�⨢��� � ����஥�� ��ࠬ��� ����믨᪠/���⮪��ொ��� = ���
      �㬬� ���⪠ ��⠥��� = 0.
   */
   IF    (
            NOT Pcard.loan-work
      AND   FGetSettingEx ("����믨᪠",
                           "���⮪�������",
                           "",
                           NO
                          ) EQ "���"
         )
      OR
         (
            loan.contract  EQ "card-corp"
      AND   FGetSettingEx ("����믨᪠",
                           "���⮪��ொ���",
                           "",
                           NO
                          ) EQ "���"
         ) THEN
      tt-cardrep.total_bal = 0.
/*      
   ELSE
      ASSIGN
         tt-cardrep.total_bal = tt-cardrep.init_bal + vAmt1 - vAmt2
         vAmt1                = 0
      .
*/

ELSE DO:
   RUN CardInitBal (       card.parent-contract,
                          card.parent-cont-code,
			  	      			                                 mDateto,
							                     OUTPUT vAmt1
									        ).
										   ASSIGN
										         tt-cardrep.total_bal = vAmt1
											       vAmt1               = 0
											          .
												  END.

/*
message tt-cardrep.init_bal skip
vAmt1 skip
vAmt2 skip
tt-cardrep.total_bal
view-as alert-box.
*/
*/





   /* ���ଠ�� � �३�-��ਮ�� */
      /* ��� �������쭮�� ���⥦� = ��᫥���� ࠡ�稩 ���� ����� */
   vDateMinPay = LastWorkDay(LastMonDate(mDateTo)).
      /* ��室�� ������ ������� �� �।�⭮�� �������� */
   RUN GetCardLoanCredit (loan.contract,
                          loan.cont-code,
                          ?,
                          mDateTo,
                          "�����",
                          OUTPUT vCardContract,
                          OUTPUT vCardContCode).
   IF TRIM(vCardContCode) NE "" THEN
   DO:
         /* ��।������ �㬬� �������쭮�� ���⥦� */
      RUN GetCredLoanMin (vCardContract,
                          vCardContCode,
                          mDateTo,
                          OUTPUT vAmtMinPay).
         /* ��� ����砭�� �३�-��ਮ�� */
      RUN GetCredLoanGraceDate (vCardContract,
                                vCardContCode,
                                mDateTo,
                                OUTPUT vDateGraceEnd).
         /* �㬬� ����祭��� ������������ */
      vAcctTypeTmp = FGetSettingEx("����믨᪠", "�������窠", "", YES).
      RUN GetCredLoanBalance (vCardContract,
                              vCardContCode,
                              mDateTo,
                              vAcctTypeTmp,     /* ���� �� �� �������窠 */
                              OUTPUT vAmtPastDueLoan,
                              OUTPUT vAcctTmp,
                              OUTPUT vCurrTmp).
   END.

      /* ��ப� �३� ���⠥��� ⮫쪮 �᫨  � ����� ���� �।��� ������� �
      ** �� ���� �������� ���.� �३�-��ਮ����.
      ** ��� ���.���� �� �������⥫쭮 �஢������ �� "������३ᄮ��" = "��" */
   IF Pcard.loan-work THEN
      vFlgGracePrint = IF FGetSettingEx("����믨᪠", "������३�ᭊ", "���", NO) = "��" THEN YES ELSE NO.
   ELSE                     /* ��� ���.����� �஢��塞 �� "������३ᄮ��" */
      vFlgGracePrint = IF FGetSettingEx("����믨᪠", "������३ᄮ��", "���", NO) = "��" THEN YES ELSE NO.

   ASSIGN
      vCardContract = ""
      vCardContCode = ""
   .
         /* ��室�� ������� ��ࠧ�襭���� ������� */
   RUN GetCardLoanCredit (loan.contract,
                          loan.cont-code,
                          ?,
                          mDateTo,
                          "��孨�",
                          OUTPUT vCardContract,
                          OUTPUT vCardContCode).
   IF TRIM(vCardContCode) NE "" THEN
   DO:
         /* �㬬� ��ࠧ�襭���� ������� */
      vAcctTypeTmp = FGetSettingEx("����믨᪠", "�����㤑��", "", YES).
      RUN GetCredLoanBalance (vCardContract,
                              vCardContCode,
                              mDateTo,
                              vAcctTypeTmp,     /* ���� �� �� �����㤑�� */
                              OUTPUT vAmtUnSolvOvdft,
                              OUTPUT vAcctTmp,
                              OUTPUT vCurrTmp).
   END.
   ASSIGN
      vAmtUnSolvOvdft        = ABS(vAmtUnSolvOvdft)
      tt-cardrep.amt_min_pay = vAmtMinPay      /* �㬬� �������쭮�� ���⥦�       */
      tt-cardrep.dat_min_pay = vDateMinPay     /* ��� �������쭮�� ���⥦�        */
      tt-cardrep.dat_grs_end = vDateGraceEnd   /* ��� ����砭�� �३�-��ਮ��     */
      tt-cardrep.flg_grs_pnt = vFlgGracePrint  /* �ਧ��� �뢮�� �� ����� �३�   */
      tt-cardrep.amt_uns_ovd = vAmtUnSolvOvdft /* �㬬� ��ࠧ�襭���� �������  */
      tt-cardrep.amt_pst_due = vAmtPastDueLoan /* �㬬� ����祭��� ������������ */
   .
   /* End Of ���ଠ�� � �३�-��ਮ�� */

   RETURN.
END PROCEDURE.


/* ���������� �६����� ⠡���� ��� ����権 �� ���� */
PROCEDURE BuildOpCard:
   DEF INPUT  PARAM iContract   AS CHAR   NO-UNDO.
   DEF INPUT  PARAM iContCode   AS CHAR   NO-UNDO. /* ����                   */
   DEF INPUT  PARAM iLContract  AS CHAR   NO-UNDO.
   DEF INPUT  PARAM iLContCode  AS CHAR   NO-UNDO. /* ������� �����           */

   DEF VAR          vAcctC      AS CHAR   NO-UNDO. /* �� �᪫��௏஢����     */
   DEF VAR          vCurrOE     AS CHAR   NO-UNDO. /* ����� �஢���          */


   DEF BUFFER loan   FOR loan.
   DEF BUFFER card   FOR loan.
   DEF BUFFER card2  FOR loan.
   DEF BUFFER cardD  FOR loan. /* �������⥫쭠� ���� */
   DEF BUFFER signs1 FOR signs.
   DEF BUFFER signs2 FOR signs.

   FIND FIRST card  WHERE card.contract  EQ iContract
                      AND card.cont-code EQ iContCode
   NO-LOCK.

   FIND FIRST loan  WHERE loan.contract  EQ iLContract
                      AND loan.cont-code EQ iLContCode
   NO-LOCK.

   ASSIGN
      vCurrOE = IF FGetSettingEx ("����믨᪠",
                                  "�஢�����������",
                                  "",
                                  NO
                                 ) EQ "��"
                THEN loan.currency
                ELSE ""
   .

   FOR EACH loan-acct OF loan
                      WHERE loan-acct.acct-type EQ "SCS@" + vCurrOE
   NO-LOCK:

      ASSIGN
         vAcctC = FGetSettingEx ("����믨᪠",
                                 "�᪫��௏஢����",
                                 "",
                                 NO
                                )
      .

      FOR EACH op-entry            WHERE
              (op-entry.acct-db       EQ loan-acct.acct
           AND op-entry.op-date       GE mDateFrom
           AND op-entry.op-date       LE mDateTo
           AND op-entry.op-status     GT "�"
              )
           OR
              (op-entry.acct-cr       EQ loan-acct.acct
           AND op-entry.op-date       GE mDateFrom
           AND op-entry.op-date       LE mDateTo
           AND op-entry.op-status     GT "�"
              )
      NO-LOCK,
      FIRST op                      OF op-entry
      NO-LOCK:

         /* ��⠥��� ���� op-int ��� �஢���� (�� ���४����⠬ ���㬥�� � �஢����) */
         RELEASE op-int.
         RELEASE signs1.
         RELEASE signs2.
         RELEASE cardD.
         FOR FIRST signs1 WHERE signs1.file-name  EQ "op-int"
                            AND signs1.code       EQ "���㬥��"
                            AND signs1.code-value EQ STRING(op.op)
         NO-LOCK,
         FIRST     signs2 WHERE signs2.file-name  EQ "op-int"
                            AND signs2.code       EQ "�஢����"
                            AND signs2.surr       EQ signs1.surr
                            AND signs2.code-value EQ STRING(op-entry.op-entry)
         NO-LOCK:
            FIND FIRST op-int WHERE
                       op-int.op-int-id EQ INT(signs1.surr)
                   AND op-int.op-int-id EQ INT(signs2.surr)
            NO-LOCK NO-ERROR.

            IF AVAIL op-int THEN
               FIND FIRST cardD WHERE
                          cardD.parent-contract  EQ loan.contract
                      AND cardD.parent-cont-code EQ loan.cont-code
                      AND NOT cardD.loan-work
                      AND cardD.contract         EQ ENTRY(1, op-int.surrogate)
                      AND cardD.cont-code        EQ ENTRY(2, op-int.surrogate)
               NO-LOCK NO-ERROR.
         END.

         /*
            ����� ������������ ��������������
            �᫨ op-int �� ������, ��� ���� �� op-int'� �� ᮢ������ � ��ࠡ��뢠���� - �ய�᪠�� �஢����
         */
         IF      loan.contract  EQ "card-pers"
            AND  NOT Pcard.loan-work
            AND (NOT AVAIL op-int
            OR   op-int.surrogate NE card.contract + "," + card.cont-code
                ) THEN
            NEXT.

         /*
         ����� �������������
         �᫨ �᪫��௏஢���� = �� � �� �⮬ op-int �� ������ - �ய�᪠�� �஢����
         �᫨ op-int ������ � ��� ���� �� ᮢ������ � ��ࠡ��뢠���� - �ய�᪠�� �஢����
         */

         IF      loan.contract  EQ "card-corp"
            AND (
                 (vAcctC EQ "��"
            AND   NOT AVAIL op-int
                 )
              OR (AVAIL op-int
            AND   op-int.surrogate NE card.contract + "," + card.cont-code
                 )
                ) THEN
            NEXT.

         /* �᫨ �� ���㬥�� ���� ���४����� �࠭��� - �ய�᪠�� �஢���� */
         IF GetXattrValue ("op",
                           STRING(op.op),
                           "�࠭���"
                          ) NE "" THEN
            NEXT.

         IF     op-entry.currency NE ""
            AND op-entry.amt-cur  EQ 0 THEN
            NEXT.

         CREATE tt-opcard.

         /*
            tt-opcard.details:
            �᫨
            - �믨᪠ ���⠥��� �� �᭮���� ����,
            - �� �⮬ op-int ������, � ᮮ⢥����� �������⥫쭮� ����:
            ������塞 � op.details �� ⥪�� "�� �.���� 4237xxxxxxxx73xx"
            ��� 4237xxxxxxxx73xx ����� ᮮ⢥�����饩 �������⥫쭮� �����.
            �����뢠���� ���� 4 ���� ����� ����� � ��� �।��᫥����.
         */
         ASSIGN
            tt-opcard.card_num = card.doc-num

            tt-opcard.date_op  = IF AVAIL op-int
                                 THEN op-int.create-date
                                 ELSE ?

            tt-opcard.date_val = IF AVAIL op-int
                                 THEN op-int.cont-date
                                 ELSE op-entry.op-date

            tt-opcard.details  = op.details
                               + (IF     Pcard.loan-work
                                     AND AVAIL op-int
                                     AND AVAIL cardD
                                     AND op-int.surrogate EQ cardD.contract + ","
                                                           + cardD.cont-code
                                  THEN " �� �. ���� "
                                     + SUBSTR(cardD.doc-num, 1 , 4)
                                     + " xxxx xxxx "
                                     + SUBSTR(cardD.doc-num,
                                              LENGTH(cardD.doc-num) - 3, 2)
                                     + "xx"
                                  ELSE ""
                                 )

            tt-opcard.scs      = loan-acct.acct
            tt-opcard.acct-cor = IF loan-acct.acct EQ op-entry.acct-db
                                 THEN op-entry.acct-cr
                                 ELSE op-entry.acct-db

            tt-opcard.amm_op   = IF AVAIL op-int
                                 THEN op-int.par-dec[1]
                                 ELSE
                                 IF op-entry.currency EQ ""
                                 THEN op-entry.amt-rub
                                 ELSE op-entry.amt-cur

            tt-opcard.amm_op   = IF loan-acct.acct EQ op-entry.acct-db
                                 THEN tt-opcard.amm_op * (- 1)
                                 ELSE tt-opcard.amm_op
            tt-opcard.curr     = op-entry.currency
         .

         IF op-entry.currency EQ ENTRY (2, loan-acct.acct-type, "@") THEN
            tt-opcard.amm_acct = IF op-entry.currency EQ ""
                                 THEN op-entry.amt-rub
                                 ELSE op-entry.amt-cur.
         ELSE DO:
            IF ENTRY (2, loan-acct.acct-type, "@") EQ "" THEN
               tt-opcard.amm_acct = op-entry.amt-rub.
            ELSE
               tt-opcard.amm_acct = CurToCurWork ( "����",
                                                   op-entry.currency,
                                                   ENTRY (2, loan-acct.acct-type, "@"),
                                                   op.op-date,
                                                  (IF op-entry.currency EQ ""
                                                   THEN op-entry.amt-rub
                                                   ELSE op-entry.amt-cur
                                                  )
                                                 ).
         END.
         ASSIGN
            tt-opcard.amm_acct = IF loan-acct.acct EQ op-entry.acct-db
                                 THEN tt-opcard.amm_acct * (- 1)
                                 ELSE tt-opcard.amm_acct

            tt-opcard.comm     = 0
            tt-opcard.total    = tt-opcard.amm_acct + tt-opcard.comm
         .
      END.
   END.

/* -------------------------------------------------------------------------- */

   /* �᫨ ���� �������⥫쭠� */
   IF NOT card.loan-work THEN
      RUN FTrans (iContract, iContCode, NO).

   /*
      �᫨ ���� �᭮���� ���ᮭ��쭠� - �롮ઠ ��ந��� �� �ᥬ ���⠬ �������,
      ᮮ⢥�����饣� ��࠭��� ���� (����, ������ - �������筮 �롮થ �� ����� ����).
   */
   ELSE
   IF    (loan.contract EQ "card-pers"
      AND card.loan-work
         )
      OR (loan.contract EQ "card-corp") THEN
   FOR EACH card2 WHERE (card2.parent-contract  EQ loan.contract
                    AND  card2.parent-cont-code EQ loan.cont-code
                    AND  card2.cont-code        NE Pcard.cont-code
                        )
                    OR  (card2.parent-contract  EQ loan.contract
                    AND  card2.parent-cont-code EQ loan.cont-code
                    AND  Pcard.loan-work
                        )
   NO-LOCK:
      RUN FTrans (card2.contract, card2.cont-code, YES).
   END.

   IF loan.contract EQ "card-corp" THEN
      RUN AddOper (iContract, iContCode).

   RETURN.
END PROCEDURE.

/* ���� � ���������� ����権 � ��. */
PROCEDURE FTrans:
   DEF INPUT  PARAM iContract   AS CHAR   NO-UNDO.
   DEF INPUT  PARAM iContCode   AS CHAR   NO-UNDO.
   DEF INPUT  PARAM iLog        AS LOG    NO-UNDO. /* ��������� ⥪�� � ���� details */

   DEF VAR          vAcct       AS CHAR   NO-UNDO.
   DEF VAR          vCurr       AS CHAR   NO-UNDO. /* �����誠                */
   DEF VAR          vList       AS CHAR   NO-UNDO.
   DEF VAR          vAmtA       AS DEC    NO-UNDO.
   DEF VAR          vAmtC       AS DEC    NO-UNDO.
   DEF VAR          vAmtComm    AS DEC    NO-UNDO.
   DEF VAR          vCur        AS CHAR   NO-UNDO.

   DEF BUFFER card      FOR loan.
   DEF BUFFER op        FOR op.
   DEF BUFFER op-entry1 FOR op-entry.
   DEF BUFFER op-entry2 FOR op-entry.
   DEF BUFFER signs     FOR signs.

   FIND FIRST card WHERE card.contract  EQ iContract
                     AND card.cont-code EQ iContCode
   NO-LOCK.

   /* ��।����� ᯨ᪠ ����ᮢ ����権 */
   vList = FGetSettingEx ("����믨᪠",
                          "�믨᪠���",
                          "",
                          NO
                         ).

   FOR EACH pc-trans        WHERE
           (pc-trans.sur-card  EQ card.contract + "," + card.cont-code
        AND pc-trans.proc-date GE mDateFrom
        AND pc-trans.proc-date LE mDateTo
        AND CAN-DO (vList, pc-trans.pctr-status)
           )
        OR
           (pc-trans.sur-card  EQ card.contract + "," + card.cont-code
        AND pc-trans.proc-date EQ ?
        AND CAN-DO (vList, pc-trans.pctr-status)
           )
   NO-LOCK:
      RUN CardSummA    IN h_card (       pc-trans.pctr-id,
                                  OUTPUT vAmtA,
                                  OUTPUT vCur
      ).
      RUN CardSummComm IN h_card (       pc-trans.pctr-id,
                                  OUTPUT vAmtComm,
                                  OUTPUT vCur
      ).
      RUN CardSummC    IN h_card (       pc-trans.pctr-id,
                                  OUTPUT vAmtC,
                                  OUTPUT vCur
      ).

      CREATE tt-opcard.
      ASSIGN
         tt-opcard.date_op  = pc-trans.cont-date
         tt-opcard.date_val = pc-trans.proc-date
         tt-opcard.details  = GetEntries(1, pc-trans.pctr-code, CHR(1) , "")
                            + " , "
                            + pc-trans.eq-country + " "
                            + pc-trans.eq-city    + " "
                            + pc-trans.eq-location
                            + (IF  iLog
                               AND Pcard.loan-work
                               AND NOT card.loan-work
                               THEN " �� �. ���� "
                                  + SUBSTR(card.doc-num, 1 , 4)
                                  + " xxxx xxxx "
                                  + SUBSTR(card.doc-num,
                                           LENGTH(card.doc-num) - 3, 2)
                                  + "xx"
                               ELSE ""
                              )
         tt-opcard.code_op  = pc-trans.auth-code
         tt-opcard.amm_op   = IF pc-trans.dir
                              THEN vAmtC * (- 1)
                              ELSE vAmtC
         tt-opcard.amm_acct = IF pc-trans.dir
                              THEN vAmtA * (- 1)
                              ELSE vAmtA
         tt-opcard.comm     = vAmtComm * (- 1)
         tt-opcard.total    = tt-opcard.amm_acct + tt-opcard.comm
         tt-opcard.card_num = card.doc-num
         tt-opcard.curr     = vCur
         vAmtA              = 0
         vAmtC              = 0
         vAmtComm           = 0
      .

/* �� ��:
   �饬 ���㬥��, � ���ன ���� ���४����� �࠭���,
   ᮤ�ঠ騩 ��� pc-trans.pctr-id.

   �᫨ ���㬥�� �� ������ - ���� ��⠢�塞 ����묨.
   �᫨ ���㬥�� ����: ��६ � �⮣� ���㬥�� �஢����, � ��� �롨ࠥ� ���.
   ��� �� ��������� �� �।��饬 蠣�,
   ��⠫��� ��।����� ����ᯮ������騩 ���.
   ...
*/

      RELEASE signs.
      FIND FIRST signs WHERE signs.file-name  EQ     "op"
                         AND signs.code       EQ     "�࠭���"
                         AND signs.code-value BEGINS STRING(pc-trans.pctr-id)
      NO-LOCK NO-ERROR.



      IF AVAIL signs THEN
      FOR FIRST op WHERE op.op EQ INT(signs.surrogate)
      NO-LOCK,
      FIRST op-entry1 OF op
      NO-LOCK:
         RUN GetRoleAcct IN h_card (       card.parent-contract + "," + card.parent-cont-code,
                                           mDateTo,
                                           "SCS",
                                           loan.currency,
                                    OUTPUT vAcct,
                                    OUTPUT vCurr
         ).
         tt-opcard.scs = vAcct.
/*
   ...
   �᫨ �஢���� �� ���㬥�� �� ����:
   - �᫨ ���� �� ��⮢ - ��� ���ᮢ�� ࠧ���, ��� �஢���� �� ��ᬠ�ਢ���.
   - ��⠫��� �஢���� ����� ���� ���� ��� 2.
     �᫨ �஢���� ���� - ����ᯮ������騩 ��� ��६ � ���.
     �᫨ �஢���� 2 - �� ����஢����, ᮮ⢥��⢥���,
     �� ������ �㤥� �� ������ ����.
*/
         IF NOT CAN-FIND (FIRST op-entry2 OF op
                                          WHERE ROWID(op-entry2) NE ROWID(op-entry1)
                         ) THEN
            tt-opcard.acct-cor = IF vAcct EQ op-entry1.acct-db
                                 THEN op-entry1.acct-cr
                                 ELSE op-entry1.acct-db
            .
         ELSE
         FOR EACH op-entry2 OF op
         NO-LOCK
         BREAK BY op-entry2.op:
            IF    CAN-DO(mAcctN, op-entry2.acct-cr)
               OR CAN-DO(mAcctN, op-entry2.acct-db)
               OR CAN-DO(mAcctP, op-entry2.acct-cr)
               OR CAN-DO(mAcctP, op-entry2.acct-db) THEN
               NEXT.

            IF LAST (op-entry2.op) THEN
               tt-opcard.acct-cor = IF vAcct EQ op-entry2.acct-db
                                    THEN op-entry2.acct-cr
                                    ELSE op-entry2.acct-db
               .
            ELSE
               tt-opcard.acct-cor = IF     op-entry2.acct-cr NE ?
                                       AND op-entry2.acct-cr NE vAcct
                                       AND op-entry2.acct-db EQ ?
                                    THEN op-entry2.acct-cr
                                    ELSE
                                    IF     op-entry2.acct-db NE ?
                                       AND op-entry2.acct-db NE vAcct
                                       AND op-entry2.acct-cr EQ ?
                                    THEN op-entry2.acct-db
                                    ELSE ""
               .


            IF tt-opcard.acct-cor NE "" THEN
               LEAVE.
         END.
      END.
   END.


   RETURN.
END PROCEDURE.


/* ����� �ᯮ����⥫쭮�� ᯨ᪠ ����権 ��� ��௮�⨢��� ���� */
PROCEDURE AddOper:
   DEF INPUT  PARAM iContract   AS CHAR   NO-UNDO.
   DEF INPUT  PARAM iContCode   AS CHAR   NO-UNDO.

   DEF VAR          vList       AS CHAR   NO-UNDO.
   DEF VAR          vAmtA       AS DEC    NO-UNDO.
   DEF VAR          vAmtComm    AS DEC    NO-UNDO.
   DEF VAR          vCur        AS CHAR   NO-UNDO.

   DEF BUFFER card      FOR loan.
   DEF BUFFER ocard     FOR loan. /* ��㣠� ���� ⮣� �� ���. �������      */
   DEF BUFFER loan      FOR loan.

   /* ��।����� ᯨ᪠ ����ᮢ ����権 */
   vList = FGetSettingEx ("����믨᪠",
                          "�믨᪠���",
                          "",
                          NO
                         ).

   FIND FIRST card  WHERE card.contract          EQ iContract
                      AND card.cont-code         EQ iContCode
   NO-LOCK.

   FOR FIRST loan   WHERE loan.contract          EQ card.parent-contract
                      AND loan.cont-code         EQ card.parent-cont-code
   NO-LOCK,
   EACH      ocard  WHERE ocard.parent-contract  EQ iContract
                      AND ocard.parent-cont-code EQ iContCode
                      AND RECID(ocard)           NE RECID(card)
   NO-LOCK,
   EACH pc-trans    WHERE pc-trans.sur-card      EQ ocard.contract + "," + ocard.cont-code
                      AND pc-trans.proc-date     EQ ?
                      AND CAN-DO (vList, pc-trans.pctr-status)
   NO-LOCK:
      RUN CardSummA    IN h_card (       pc-trans.pctr-id,
                                  OUTPUT vAmtA,
                                  OUTPUT vCur
      ).
      RUN CardSummComm IN h_card (       pc-trans.pctr-id,
                                  OUTPUT vAmtComm,
                                  OUTPUT vCur
      ).

      CREATE tt-opcard.
      ASSIGN
         tt-opcard.date_op  = pc-trans.cont-date
         tt-opcard.date_val = pc-trans.proc-date
         tt-opcard.details  = GetEntries(1, pc-trans.pctr-code, CHR(1) , "")
                            + " , "
                            + pc-trans.eq-country + " "
                            + pc-trans.eq-city    + " "
                            + pc-trans.eq-location
         tt-opcard.code_op  = pc-trans.auth-code
         tt-opcard.amm_acct = IF pc-trans.dir
                              THEN vAmtA * (- 1)
                              ELSE vAmtA
         tt-opcard.comm     = vAmtComm * (- 1)
         tt-opcard.total    = tt-opcard.amm_acct + tt-opcard.comm
         tt-opcard.card_num = card.doc-num
         tt-opcard.curr     = vCur
         tt-opcard.AddOper  = YES
         vAmtA              = 0
         vAmtComm           = 0
      .
   END.


   RETURN.
END PROCEDURE.


/* ��।������ ��᭨������� ���⪠. */
PROCEDURE CardMinOst:
   DEF INPUT  PARAM iContract   AS CHAR   NO-UNDO.
   DEF INPUT  PARAM iContCode   AS CHAR   NO-UNDO.
   DEF INPUT  PARAM iSince      AS DATE   NO-UNDO.

   DEF OUTPUT PARAM oValComm    AS DEC    NO-UNDO.

   /* �����誨 */
   DEF VAR vCurrency   AS CHAR    NO-UNDO.
   DEF VAR vValComm    AS DEC     NO-UNDO.
   DEF VAR vValMinRate AS DEC     NO-UNDO.
   DEF VAR vPlusRate   AS DEC     NO-UNDO.
   DEF VAR vPeriodAdd  AS CHAR    NO-UNDO.
   DEF VAR vFixed      AS LOG     NO-UNDO.
   DEF VAR vPeriodDate AS CHAR    NO-UNDO. /* �ப ������ ��� */
   DEF VAR vScheme     AS CHAR    NO-UNDO. /* �奬� ���᫥���  */
   DEF VAR vCode       AS CHAR    NO-UNDO.

   DEF BUFFER loan FOR loan.
   DEF BUFFER card FOR loan.

   vCode = FGetSettingEx ("����믨᪠",
                          "���⊮�����",
                          "",
                          NO
                         ).

   IF SUBSTRING(vCode, LENGTH(vCode)) EQ "*" THEN
   DO:
      FIND FIRST card WHERE card.contract  EQ iContract
                        AND card.cont-code EQ iContCode
         NO-LOCK NO-ERROR.
      IF AVAIL card THEN
      DO:
         FIND FIRST loan WHERE loan.contract  EQ card.parent-contract
                           AND loan.cont-code EQ card.parent-cont-code
            NO-LOCK NO-ERROR.
         IF AVAIL loan THEN
            vCode = SUBSTRING(vCode, 1, LENGTH(vCode) - 1) + loan.currency.
      END.
   END.

   RUN getCommCard IN h_card (iContract,
                              iContCode,
                              vCode,
                              iSince,
                              OUTPUT vCurrency,
                              OUTPUT oValComm, /* ��᭨����� ���⮪ */
                              OUTPUT vValMinRate,
                              OUTPUT vPlusRate,
                              OUTPUT vPeriodAdd,
                              OUTPUT vFixed,
                              OUTPUT vPeriodDate,
                              OUTPUT vScheme).

   RETURN.
END PROCEDURE.


/* ��।������ ���⪠ �� ��砫� ��ਮ�� */
PROCEDURE CardInitBal:
   DEF INPUT  PARAM iContract   AS CHAR   NO-UNDO.
   DEF INPUT  PARAM iContCode   AS CHAR   NO-UNDO.
   DEF INPUT  PARAM iSince      AS DATE   NO-UNDO.

   DEF OUTPUT PARAM oAmt        AS DEC    NO-UNDO.

   RUN CardBalanceTot IN h_card (       iContract,
                                        iContCode,
                                        iSince - 1,
                                 OUTPUT oAmt
   ).

   RETURN.
END PROCEDURE.


/* ����� �믨᪨ �� ����� ���� */
PROCEDURE PrintCardRep:
   DEF INPUT  PARAM iContract   AS CHAR   NO-UNDO.
   DEF INPUT  PARAM iContCode   AS CHAR   NO-UNDO.

   DEF VAR vCodeMisc2       AS CHAR NO-UNDO. /* ����ᨭ�� �� �����䨪��� ����끠��� */
   DEF VAR vProcessing      AS CHAR NO-UNDO. /* �� �믨᪠�������                 */
   DEF VAR vShowCorpOb      AS CHAR NO-UNDO. /* �� �������௎�����           */
   DEF VAR vShowNOstOsnCard AS CHAR NO-UNDO. /* �� ���������ᭊ���           */
   DEF VAR vShowNOstDopCard AS CHAR NO-UNDO. /* �� ��������℮�����           */
   DEF VAR vShowSGPOOsnCard AS CHAR NO-UNDO. /* �� ���������ᭊ���            */
   DEF VAR vShowSGPODopCard AS CHAR NO-UNDO. /* �� ���������������            */
   DEF VAR vShowDebt        AS CHAR NO-UNDO. /* �� �����������                */
   DEF VAR vShowCredLine    AS CHAR NO-UNDO. /* �� ������।�����             */
   DEF VAR vShowBlockAmt    AS CHAR NO-UNDO. /* �� ���������                  */
   DEF VAR vShowAvailAmt    AS CHAR NO-UNDO. /* �� ��������⋨�               */
   DEF VAR vShowBanOverd    AS CHAR NO-UNDO. /* �� �������ࠧ�����            */
   DEF VAR vShowDelay       AS CHAR NO-UNDO. /* �� ���������窠             */
   DEF VAR vShowUnusedOver  AS CHAR NO-UNDO. /* �� ��������ᯋ��              */

   DEF VAR vCnt             AS INT  NO-UNDO.
   DEF VAR vNameOrg         AS CHAR NO-UNDO.

   DEF BUFFER card FOR loan.

   FIND FIRST card WHERE card.contract  EQ iContract
                     AND card.cont-code EQ iContCode
   NO-LOCK.

   ASSIGN
      /* ���� ���-� �⫨��� ⠬������ ����� */
      vProcessing      = FGetSettingEx ("����믨᪠",
                                         "�믨᪠�������",
                                         "",
                                         NO
                                       )
      vShowCorpOb      = FGetSettingEx ("����믨᪠",
                                        "�������௎�����",
                                        "",
                                        NO
                                       )
      vShowNOstOsnCard = FGetSettingEx ("����믨᪠",
                                        "���������ᭊ���",
                                        "",
                                        NO
                                       )
      vShowNOstDopCard = FGetSettingEx ("����믨᪠",
                                        "��������℮�����",
                                        "",
                                        NO
                                       )
      vShowSGPOOsnCard = FGetSettingEx ("����믨᪠",
                                        "���������ᭊ���",
                                        "",
                                        NO
                                       )
      vShowSGPODopCard = FGetSettingEx ("����믨᪠",
                                        "���������������",
                                        "",
                                        NO
                                       )
      vShowDebt        = FGetSettingEx ("����믨᪠",
                                        "�����������",
                                        "",
                                        NO
                                       )
      vShowCredLine    = FGetSettingEx ("����믨᪠",
                                        "������।�����",
                                        "",
                                        NO
                                       )
      vShowBlockAmt    = FGetSettingEx ("����믨᪠",
                                        "���������",
                                        "",
                                        NO
                                       )

      vShowAvailAmt    = FGetSettingEx ("����믨᪠",
                                        "��������⋨�",
                                        "",
                                        NO
                                       )
      vShowBanOverd    = FGetSettingEx ("����믨᪠",
                                        "�������ࠧ�����",
                                        "",
                                        NO
                                       )

      vShowDelay       = FGetSettingEx ("����믨᪠",
                                        "���������窠",
                                        "",
                                        NO
                                       )
      vShowUnusedOver  = FGetSettingEx ("����믨᪠",
                                        "��������ᯋ��",
                                        "",
                                        NO
                                       )

      vCodeMisc2       = GetCodeMisc   ("����끠���", card.sec-code, 2)
   .

   FOR EACH tt-cardrep:
      PUT STREAM fil UNFORMATTED FGetSettingEx ("����믨᪠",
                                                "�믨᪠���劮�",
                                                "",
                                                NO
                                               ) SKIP.

      PUT STREAM fil UNFORMATTED FGetSettingEx ("����믨᪠",
                                                "�믨᪠���劮�2",
                                                "",
                                                NO
                                               ) SKIP.

      PUT STREAM fil UNFORMATTED FGetSettingEx ("����믨᪠",
                                                "�믨᪠���劮�3",
                                                "",
                                                NO
                                               ) SKIP(2).

      PUT STREAM fil UNFORMATTED FILL(" ", 50) + "�믨᪠ (Report)" SKIP.
      PUT STREAM fil UNFORMATTED FILL(" ", 30) + "�� ��ਮ� � (from) "
         + STRING(mDateFrom) + " �� (to) " + STRING(mDateTo) SKIP(1).


      IF FGetSettingEx ("����믨᪠",
                        "�����������",
                        "",
                        NO
                       ) EQ "��" THEN
      DO:
         RUN GetNameOrg (       card.parent-contract,
                                card.parent-cont-code,
                         OUTPUT mNameOrg).
         DO mCnt = 1 TO 3:
            IF mCnt EQ 2 THEN
            DO:
               IF NUM-ENTRIES(mNameOrg, CHR(1)) GT 1 THEN
               DO:
                  vNameOrg = mNameOrg.
                  DO vCnt = 1 TO NUM-ENTRIES(vNameOrg, CHR(1)):
                     mNameOrg = ENTRY(vCnt, vNameOrg, CHR(1)).
                     RUN PutLine(RepTempl2[mCnt], NO).
                  END.
               END.
               ELSE DO:
                  mNameOrg = REPLACE(mNameOrg, CHR(1), "").
                  RUN PutLine(RepTempl2[mCnt], NO).
               END.
            END.
            ELSE
               RUN PutLine(RepTempl2[mCnt], NO).
         END.
      END.

      DO mCnt = 1 TO 17:
         RUN PutLine(RepTempl[mCnt], NO).
      END.

      /* �᫨ ��� ����権 ���⠥� �ࠧ� ����뢠���� ����� */
      IF NOT CAN-FIND (FIRST tt-opcard) THEN
         RUN PutLine(RepTempl[21], NO).

      ELSE DO:
         RUN PutLine(RepTempl[18], NO).

         /*
            ����஢�� � 横�� �� ⠡��� tt-opcard:
            1. �� ������/������⢨� ���� ���� (�� �� ��������,
               � �� <> ? - �⮡� ��᫥����� �����뢠���� ���ਧ�樨)
            2. �� ��� ����樨
            3. �� ��� ����

            �᫨ ���� �᭮���� ���ᮭ��쭠� �����뢠�� ��� ����樨
         */
         FOR EACH  tt-opcard WHERE
                 ( tt-opcard.card_num EQ card.doc-num
             AND  (NOT card.loan-work
              OR   loan.contract      EQ "card-corp"
                  )
             AND   tt-opcard.AddOper  EQ NO
                 )
             OR  (card.loan-work
             AND  loan.contract EQ "card-pers"
                 )
         BREAK BY tt-opcard.date_val NE ? DESC
               BY tt-opcard.date_val
               BY tt-opcard.date_op
               BY tt-opcard.card_num
         :

            /* ����� � ���. ��ப */
            ASSIGN
               mDet    = ""
               mDetEnt = 0
               mDet    = SplitStr(tt-opcard.details, 41, "�")
               mDetEnt = NUM-ENTRIES(mDet, "�") + 1
            .

            IF LINE-COUNTER(fil) + mDetEnt /*+ 1*/ LT PAGE-SIZE(fil)
            THEN DO:
               RUN PutLine (RepTempl[19], YES).
               DO WHILE mDet NE '':
                  RUN PutLine (RepTempl[20], NO).
               END.
            END.

            ELSE
            IF LINE-COUNTER(fil) + mDetEnt /*+ 1*/ GE PAGE-SIZE(fil)
            THEN DO:
               PAGE STREAM fil.
               RUN PutLine (RepTempl[21], YES).
               RUN PutLine (RepTempl[19], YES).
               DO WHILE mDet NE '':
                  RUN PutLine (RepTempl[20], NO).
               END.
            END.

            IF LAST (tt-opcard.card_num)
            THEN RUN PutLine(RepTempl[21], NO).
            ELSE RUN PutLine(RepTempl[18], NO).
         END.
      END.

      DO mCnt = 22 TO 40:
         /*
            ��ப� ���⠥��� ⮫쪮 �� ᫥����� �᫮����:
            - ���� �� ����믨᪠/���������ᭊ��� = �� � ���� �������
            - ���� �� ����믨᪠/��������℮����� = �� � ���� �������⥫쭠�

            ��ப� ���⠥��� ⮫쪮 �� ᫥����� �᫮����:
            - ���� �� ����믨᪠/���������ᭊ��� = �� � ���� �������
            - ���� �� ����믨᪠/��������������� = �� � ���� �������⥫쭠�
         */
         IF
            (
                  RepTempl[mCnt] BEGINS "������������ �������"
               AND  NOT  ( (vShowNOstOsnCard EQ "��"
                           AND Pcard.loan-work
                           )
                           OR
                           (vShowNOstDopCard EQ "��"
                           AND NOT Pcard.loan-work
                           )
                         )
            )
            OR
            (
                  RepTempl[mCnt] BEGINS "���� ������������ ��������"
               AND  NOT  ( (vShowSGPOOsnCard EQ "��"
                           AND Pcard.loan-work
                           )
                           OR
                           (vShowSGPODopCard EQ "��"
                           AND NOT Pcard.loan-work
                          )
                        )
            )
            OR
            (
                  RepTempl[mCnt] BEGINS "������ ����������"
               AND  NOT (vShowDebt EQ "��")
            )
            OR
            (
                  RepTempl[mCnt] BEGINS "������ ����������������� ����������"
               AND  NOT  (    IsOverdraft (Pcard.parent-contract,
                                           Pcard.parent-cont-code,
                                           mDateTo
                                          )
                          AND vShowUnusedOver EQ "��"
                         )
            )

            OR
            (
                  RepTempl[mCnt] BEGINS "������ ������ ����������"
               AND  NOT  (    IsOverdraft (Pcard.parent-contract,
                                           Pcard.parent-cont-code,
                                           mDateTo
                                          )
                          AND vShowCredLine EQ "��"
                         )
            )
            OR
            (
                  RepTempl[mCnt] BEGINS "�������������� ����� (������������ ��������)"
               AND  NOT  (    vShowBlockAmt EQ "��"
                         )
            )

            OR
            (
                  RepTempl[mCnt] BEGINS "���������� �����"
               AND  NOT  (    vShowAvailAmt EQ "��"
                         )
            )

            OR
            (
                  (RepTempl[mCnt] BEGINS "�������������������������������������������������"
                OR RepTempl[mCnt] BEGINS "�������������������������������������������������"
                OR RepTempl[mCnt] BEGINS "������:"
                  )
               AND  NOT  (    tt-cardrep.flg_grs_pnt)
            )

            OR
            (
                  RepTempl[mCnt] BEGINS "������ �������������� ����������"
               AND  NOT  (    tt-cardrep.amt_uns_ovd NE 0
                          AND vShowBanOverd          EQ "��"
                         )
            )

            OR
            (
                  RepTempl[mCnt] BEGINS "������ ������������ �������������"
               AND  NOT  (    tt-cardrep.amt_pst_due NE 0
                          AND vShowDelay             EQ "��"
                         )
            )

         THEN NEXT.

         /* �஢��塞 �� �ਭ���������� � ���. ���⠬. ����� ��� �஢��� ��� �㤥� ����訬 ���஬��������.

         ** �᫨ ���� ��௮�⨢��� (�� ⠬������� � �� 䨧���) � ��
         ** ����믨᪠/�������௎����� = ��, ����室��� ������ ⮫쪮 �⮣��� ��ப�
         ** ������� �� ������� �� ������
         ** ������� �� ������� �� ������
         ** ��⠫�� �⮣��� ��ப� �� ��������.
         ** �᫨ ���� ⠬������� ��� 䨧��� ��� �� ����믨᪠/�������௎����� = ��� - ����� �⮣���� ��ப �ࠢ�����, ��� � ࠭��, ᮮ⢥�����騬� ����஥�묨 ��ࠬ��ࠬ�.
         ** ��� ⮣�, �⮡� ��।�����, ���� �� ���� ⠬������� - ᮧ��� �������⥫�� ����஥�� ��ࠬ��� ����믨᪠/�믨᪠�������, ᮤ�ঠ騩 ��� ����ᨭ�� ⠬������� ����.
         */
         IF    (    loan.contract      EQ "card-corp"
                AND NOT CAN-DO(vProcessing, vCodeMisc2)
                AND
                (   RepTempl[mCnt] BEGINS "������� �� ������� �� ������"
                 OR RepTempl[mCnt] BEGINS "������� �� ������� �� ������"
                 OR mCnt EQ 40
                )
                AND vShowCorpOb EQ "��"
               )
            OR (    loan.contract      EQ "card-corp"
                AND NOT CAN-DO(vProcessing, vCodeMisc2)     /*** SSitov: ᪮�४�஢�� �� ��� �1188  */
               )
            OR (loan.contract      EQ "card-pers")
         THEN
            RUN PutLine(RepTempl[mCnt], NO).
      END.

      IF     FGetSettingEx ("����믨᪠",
                            "���������砭��",
                            "",
                            NO
                           ) EQ "��"
         AND mDateTo + INT(FGetSettingEx ("����믨᪠",
                           "����砭���ப",
                           "",
                           NO
                          )) GE Pcard.end-date THEN
         PUT STREAM fil UNFORMATTED FGetSettingEx ("����믨᪠",
                                                   "����砭�������",
                                                   "",
                                                   NO
                                                  ) SKIP.


      PUT STREAM fil UNFORMATTED "����䮭 ��� �ࠢ��: " + FGetSettingEx ("����믨᪠",
                                                                          "�믨᪠���",
                                                                          "",
                                                                          NO
                                                                         ) SKIP.

      PUT STREAM fil UNFORMATTED "E-mail: "              + FGetSettingEx ("����믨᪠",
                                                                          "�믨᪠����",
                                                                          "",
                                                                          NO
                                                                         ) SKIP.

      PUT STREAM fil UNFORMATTED "Web: "                 + FGetSettingEx ("����믨᪠",
                                                                          "�믨᪠����",
                                                                          "",
                                                                          NO
                                                                         ) SKIP.

      PUT STREAM fil UNFORMATTED                           FGetSettingEx ("����믨᪠",
                                                                          "�믨᪠�������",
                                                                          "",
                                                                          NO
                                                                         ) SKIP.

      PUT STREAM fil UNFORMATTED                           FGetSettingEx ("����믨᪠",
                                                                          "�믨᪠�������2",
                                                                          "",
                                                                          NO
                                                                         ) SKIP.

      PUT STREAM fil UNFORMATTED                           FGetSettingEx ("����믨᪠",
                                                                          "�믨᪠�������3",
                                                                          "",
                                                                          NO
                                                                         ) SKIP.
   END.

   RETURN.
END PROCEDURE.  /* PrintCardRep */


/* ��।������ ��室�饣� ���⪠ */
PROCEDURE CardTotalBal:
   DEF INPUT  PARAM iContract   AS CHAR   NO-UNDO.
   DEF INPUT  PARAM iContCode   AS CHAR   NO-UNDO.
   DEF INPUT  PARAM iSince      AS DATE   NO-UNDO.

   DEF OUTPUT PARAM oAmt        AS DEC    NO-UNDO.

   RUN CardBalanceTot IN h_card (       iContract,
                                        iContCode,
                                        iSince,
                                 OUTPUT oAmt
   ).

   RETURN.
END PROCEDURE.


/* ��।������ ������������ �� �������� */
PROCEDURE CardOverdraft:
   DEF INPUT  PARAM iPaContract AS CHAR   NO-UNDO. /* parent-contract         */
   DEF INPUT  PARAM iPaContCode AS CHAR   NO-UNDO. /* parent-cont-code        */
   DEF INPUT  PARAM iSince      AS DATE   NO-UNDO. /* ���                    */

   DEF OUTPUT PARAM oAmt        AS DEC    NO-UNDO. /* sh-bal | sh-val         */

   DEF VAR          vAcct       AS CHAR   NO-UNDO.
   DEF VAR          vCurr       AS CHAR   NO-UNDO.
   DEF VAR          vAmt1       AS DEC    NO-UNDO.
   DEF VAR          vAmt2       AS DEC    NO-UNDO.
   DEF VAR          vAmt3       AS DEC    NO-UNDO.

   DEF BUFFER  loan      FOR loan.      /* ������� */
   DEF BUFFER bloan      FOR loan.      /* ������� */
   DEF BUFFER  loan-acct FOR loan-acct.

   /* ��।������ ������� ����� */
   FOR FIRST loan WHERE loan.contract  EQ iPaContract
                    AND loan.cont-code EQ iPaContCode
   NO-LOCK:
      RUN GetRoleAcct IN h_card (       loan.contract + "," + loan.cont-code,
                                        iSince,
                                        "SCS",
                                        loan.currency,
                                 OUTPUT vAcct,
                                 OUTPUT vCurr
      ).

      IF vAcct NE ""
      THEN DO:
         FOR EACH loan-acct WHERE loan-acct.acct      EQ vAcct
                              AND loan-acct.currency  EQ vCurr
                              AND loan-acct.acct-type EQ "�।����"
                              AND loan-acct.since     LE iSince
         NO-LOCK,
         FIRST    bloan     OF loan-acct
		WHERE bloan.close-date GE iSince  OR bloan.close-date EQ ?
		AND NUM-ENTRIES(bloan.cont-code," ") = 1 
         NO-LOCK:
            IF GetXattrValue ("loan",
                              bloan.contract + "," + bloan.cont-code,
                              "���⎢��"
                             ) EQ "�����"
            THEN DO:
               FIND LAST term-obl WHERE term-obl.contract  EQ bloan.contract
                                    AND term-obl.cont-code EQ bloan.cont-code
                                    AND term-obl.end-date  LE iSince
                                    AND term-obl.idnt      EQ 2
               NO-LOCK NO-ERROR.
               IF AVAIL term-obl THEN
                  oAmt = oAmt + term-obl.amt-rub.
            END.
         END.
      END.
   END.

   RETURN.
END PROCEDURE.


/* ��।����� ���⥦���� ����� */
PROCEDURE CardCurrentLimit:
   DEF INPUT  PARAM iContract   AS CHAR   NO-UNDO.
   DEF INPUT  PARAM iContCode   AS CHAR   NO-UNDO. /* ����                   */
   DEF INPUT  PARAM iLContract  AS CHAR   NO-UNDO.
   DEF INPUT  PARAM iLContCode  AS CHAR   NO-UNDO. /* ������� �����           */

   DEF VAR vAmt1 AS DEC NO-UNDO.
   DEF VAR vAmt2 AS DEC NO-UNDO.
   DEF VAR vAmt3 AS DEC NO-UNDO.

   DEF BUFFER card  FOR loan.
   DEF BUFFER loan  FOR loan.
   DEF BUFFER cardO FOR loan. /* ���� �᭮���� ����� */

   FIND FIRST card WHERE card.contract  EQ iContract
                     AND card.cont-code EQ iContCode
   NO-LOCK.

   FIND FIRST loan WHERE loan.contract  EQ card.parent-contract
                     AND loan.cont-code EQ card.parent-cont-code
   NO-LOCK.
/*   
message
tt-cardrep.total_bal skip
tt-cardrep.ovefdraft skip
ABS(tt-cardrep.block_amm)
view-as alert-box.
*/


   /* ���� �᭮����? */
   IF card.loan-work THEN
      tt-cardrep.open_to_buy = tt-cardrep.total_bal
                             + tt-cardrep.ovefdraft
                             - ABS(tt-cardrep.block_amm).
   ELSE DO:
      /* ��।������ �᭮���� ����� */
      FOR FIRST loan WHERE loan.contract          EQ card.parent-contract
                       AND loan.cont-code         EQ card.parent-cont-code
      NO-LOCK,

      FIRST cardO    WHERE cardO.parent-contract  EQ loan.contract
                       AND cardO.parent-cont-code EQ loan.cont-code
                       AND cardO.loan-work        EQ YES
      NO-LOCK:
         /* ����஥��� ᯨ᪠ ����権 �� ���� */
         RUN BuildOpCard (cardO.contract,
                          cardO.cont-code,
                          loan.contract,
                          loan.cont-code

         ).

         /* ��।������ �����஢����� �㬬� */
         FOR EACH tt-opcard WHERE tt-opcard.date_val EQ ?
         :
            vAmt1 = vAmt1 + tt-opcard.total.
         END.

         /* ��।������ ������������ �� �������� */
         RUN CardOverdraft (       cardO.parent-contract,
                                   cardO.parent-cont-code,
                                   mDateTo,
                            OUTPUT vAmt2
         ).

         /* ��।������ ���⪠ �� ����� ��ਮ�� */
         RUN CardTotalBal (       cardO.parent-contract,
                                  cardO.parent-cont-code,
                                  mDateTo,
                           OUTPUT vAmt3
         ).

         tt-cardrep.open_to_buy = vAmt3 + vAmt2 - ABS(vAmt1).
      END.
   END.

   RETURN.
END PROCEDURE.


/* ����� ��ப� */
PROCEDURE PutLine PRIVATE:
   DEF INPUT PARAMETER iRepTempl        AS CHAR    NO-UNDO.
   DEF INPUT PARAMETER iFirst           AS LOG     NO-UNDO.

   DEF VAR             vCnt             AS INT     NO-UNDO.
   DEF VAR             vLen             AS INT     NO-UNDO.
   DEF VAR             vItm             AS CHAR    NO-UNDO.
   DEF VAR             vVal             AS CHAR    NO-UNDO.
   DEF VAR             vStr             AS CHAR    NO-UNDO.

   vStr = iRepTempl.

   DO vCnt = 2 TO NUM-ENTRIES(iRepTempl, "�"):

      ASSIGN
         vItm = ENTRY  (vCnt, iRepTempl, "�")
         vLen = LENGTH (vItm)
      .

      CASE TRIM(vItm):
         WHEN ""                          THEN
            NEXT.

         WHEN "_�������"                  THEN
            vVal = STRING(ENTRY(1, tt-cardrep.name, CHR(1))).

         WHEN "_Familia1"                 THEN
            vVal = STRING(ENTRY(2, tt-cardrep.name, CHR(1))).

         WHEN "_Familia2"                 THEN
            vVal = STRING(ENTRY(3, tt-cardrep.name, CHR(1))).

         WHEN "_����"                    THEN
            vVal = STRING(tt-cardrep.address).

         WHEN "_��⠢믨᪨"              THEN
            vVal = STRING(tt-cardrep.data).

         WHEN "_��������"                 THEN
            vVal = STRING(tt-cardrep.type-card).

         WHEN "_����ઠ���"               THEN
            vVal = STRING(tt-cardrep.card_num).

         WHEN "_��⠮���樨"             THEN
            vVal = STRING(tt-opcard.date_op).

         WHEN "_�������"              THEN
         DO:
            IF tt-opcard.date_val EQ ?
            THEN vVal = "�".
            ELSE vVal = STRING(tt-opcard.date_val).
         END.

         WHEN "_����ঠ�������樨"       THEN
         DO:
            vVal = ENTRY(1, mDet, "�").
            ENTRY(1, mDet, "�") = "".

            IF mDet NE ""                THEN
               mDet = SUBSTRING(mDet, 2).
         END.

         WHEN "_������ਧ��"             THEN
            vVal = STRING(tt-opcard.code_op).

         WHEN "_�����⥮���"              THEN
            vVal = STRING(tt-opcard.amm_op, mFormatDec) + " "
                 + GetISOCode(tt-opcard.curr).

         WHEN "_���������"             THEN
            vVal = STRING(tt-opcard.amm_acct, mFormatDec) + " "
                 + GetISOCode(loan.currency).

         WHEN "_�������"                 THEN
            vVal = STRING(tt-opcard.comm, mFormatDec).

         WHEN "_�⮣�"                    THEN
            vVal = STRING(tt-opcard.total, mFormatDec).

         WHEN "_��᭨����멮��⮪"       THEN
            vVal = STRING(tt-cardrep.ins_depos, mFormatDec).

         WHEN "_��⣠�⯮��"       THEN
            vVal = STRING(tt-cardrep.bal_sgp, mFormatDec).

         WHEN "_���⮪����砫���ਮ��"   THEN
            vVal = STRING(tt-cardrep.init_bal, mFormatDec).

         WHEN "_����⯮��室㧠��ਮ�"  THEN
            vVal = STRING(tt-cardrep.credit_turn, mFormatDec).

         WHEN "_����⯮��室㧠��ਮ�"  THEN
            vVal = STRING(tt-cardrep.debit_turn, mFormatDec).

         WHEN "_���⮪������毥ਮ��"    THEN
            vVal = STRING(tt-cardrep.total_bal, mFormatDec).

         WHEN "_�����஢������㬬�" THEN
            vVal = STRING(tt-cardrep.block_amm, mFormatDec).

         WHEN "_�����⨬멯����室"     THEN
            vVal = STRING(tt-cardrep.ovefdraft, mFormatDec).

         WHEN "_����騩��室�멫����"    THEN
            vVal = STRING(tt-cardrep.open_to_buy, mFormatDec).

         WHEN "_����㯭멫����"           THEN
            vVal = STRING(tt-cardrep.avail_amt, mFormatDec).

         WHEN "_�㬬��������"          THEN
            vVal = STRING(tt-cardrep.debts, mFormatDec).

         WHEN "_�㬬���ᯎ���"            THEN
            vVal = STRING(tt-cardrep.notover, mFormatDec).

         WHEN "_�㬬�����⠮������"    THEN
            vVal = STRING(tt-cardrep.LimOver, mFormatDec).

         WHEN "_�㬬�������⥦�"          THEN
            vVal = STRING(tt-cardrep.amt_min_pay, mFormatDec).

         WHEN "_��⠬����"                THEN
            vVal = " " + STRING(tt-cardrep.dat_min_pay).

         WHEN "_��⠪���३�-��ਮ��"     THEN
            vVal = IF tt-cardrep.dat_grs_end EQ ?
                   THEN "����� �������"
                   ELSE STRING(tt-cardrep.dat_grs_end)
            .

         WHEN "_�㬬���ࠧ�襭�����������"  THEN
            vVal = STRING(tt-cardrep.amt_uns_ovd, mFormatDec).

         WHEN "_�㬬�����祭���������������" THEN
            vVal = STRING(tt-cardrep.amt_pst_due, mFormatDec).

         WHEN "_�࣠������" THEN
            vVal = mNameOrg.

         OTHERWISE
            NEXT.
      END CASE.

      IF vVal EQ ?                        THEN
         vVal = "".

      vVal = TRIM(vVal).

      IF      vItm BEGINS " "
          AND SUBSTR(vItm, vLen) = " "
      THEN
         vVal = PADC(vVal, vLen).
      ELSE IF vItm BEGINS " "             THEN
         vVal = PADL(vVal, vLen).
      ELSE
         vVal = PADR(vVal, vLen).

      ENTRY(vCnt, vStr, "�") = vVal.
   END.

   IF    vStr BEGINS "������������ �������"
      OR vStr BEGINS "���� ������������ ��������"
      OR vStr BEGINS "������ ���������� (Debts)"
      OR vStr BEGINS "������ ����������������� ����������"
      OR vStr BEGINS "������ ������ ����������"
      OR vStr BEGINS "������ �������������� ����������"
      OR vStr BEGINS "������ ������������ �������������"
   THEN
      ASSIGN
         vItm              = FGetSettingEx ("����믨᪠"
                                            ,
                                            IF vStr BEGINS "������������ �������"
                                            THEN "���⒥���"

                                            ELSE
                                            IF vStr BEGINS "���� ������������ ��������"
                                            THEN "��������"

                                            ELSE
                                            IF vStr BEGINS "������ ���������� (Debts)"
                                            THEN "�����������"

                                            ELSE
                                            IF vStr BEGINS "������ ����������������� ����������"
                                            THEN "���ᯋ�������"

                                            ELSE
                                            IF vStr BEGINS "������ ������ ����������"
                                            THEN "�।�������"

                                            ELSE
                                            IF vStr BEGINS "������ �������������� ����������"
                                            THEN "��ࠧ����������"

                                            ELSE
                                            IF vStr BEGINS "������ ������������ �������������"
                                            THEN "����窠�����"

                                            ELSE ""
                                            ,
                                            ""
                                            ,
                                            NO
                                           )
         vItm              = IF LENGTH(vItm) LT 102
                             THEN vItm + FILL(" ", 102 - LENGTH(vItm))
                             ELSE SUBSTR(vItm, 1, 102)
         ENTRY(2,vStr,"�") = vItm
      .

   PUT STREAM fil UNFORMATTED vStr SKIP.

   RETURN.
END PROCEDURE.   /* PutLine */


/* ������ �� ���� */
PROCEDURE CardTurnovers:
   DEF INPUT  PARAM iContract       AS CHAR   NO-UNDO.
   DEF INPUT  PARAM iContCode       AS CHAR   NO-UNDO. /* ����               */

   DEF OUTPUT PARAM oCreditTurnover AS DEC    NO-UNDO. /* ��室�� ������   */
   DEF OUTPUT PARAM oDebitTurnover  AS DEC    NO-UNDO. /* ��室�� ������   */

   DEF VAR vList1 AS CHAR NO-UNDO.
   DEF VAR vList2 AS CHAR NO-UNDO.

   DEF BUFFER card FOR loan.

   ASSIGN
      vList1 = FGetSettingEx ("����믨᪠",
                              "�믨᪠�����",
                              "",
                              NO
                             )
      vList2 = FGetSettingEx ("����믨᪠",
                              "����℮����",
                              "",
                              NO
                             )
   .
   /*
      �᫨ �������⥫쭠� ��� ��௮�⨢���, � �� ����.
      �᫨ ���� �᭮���� ���ᮭ��쭠� ��⠥� ��� ������.
   */

   FOR FIRST card WHERE card.contract      EQ iContract
                    AND card.cont-code     EQ iContCode
   NO-LOCK,
   EACH tt-opcard WHERE (tt-opcard.card_num EQ card.doc-num
                    AND  (NOT card.loan-work
                     OR   loan.contract     EQ "card-corp"
                         )
                    AND  tt-opcard.AddOper   EQ NO
                        )
                     OR
                        (card.loan-work
                     AND loan.contract      EQ "card-pers"
                        )
   :
      /*
         ��� ���� ��室��� ����⮢ ��ᬠ�ਢ����� �� ����樨.
         - ��易⥫쭮 ���뢠���� ����樨, � ������ ��।����� ��� ����
         - �᫨ ����஥�� ��ࠬ��� ����믨᪠/����℮���� = ��,
           ⠪�� ���뢠���� ����樨, � ������ �� ��।�����
           ��� ���� (⠪�� ����樨 ������� �����ﬨ ���ਧ�樨).
         FUNC15823
      */
      IF     date_val EQ ?
         AND vList2   NE "��" THEN
         NEXT.
	 

if tt-opcard.details matches "*�����*" then
message
1 tt-opcard.amm_acct skip
2 tt-opcard.details skip
3 tt-opcard.scs skip
4 tt-opcard.acct-cor skip
5 vList1 skip
6 date_val skip
7 tt-opcard.comm
view-as alert-box.

	 
      IF tt-opcard.amm_acct LE 0 THEN
/*         oDebitTurnover  = oDebitTurnover + tt-opcard.amm_acct.	 */
         oDebitTurnover = oDebitTurnover
                         + (IF    tt-opcard.acct-cor EQ ""
                               OR NOT CAN-DO(vList1, tt-opcard.acct-cor)
                            THEN tt-opcard.amm_acct
                            ELSE 0
                           ).



      ELSE
      /* �᫨ ����ᯮ������騩 ��� ���室�� ��� ���� �� ��ࠬ��� �᪫�砥��� ��⮢ - �ய�᪠�� */
         oCreditTurnover = oCreditTurnover
                         + (IF    tt-opcard.acct-cor EQ ""
                               OR NOT CAN-DO(vList1, tt-opcard.acct-cor)
                            THEN tt-opcard.amm_acct
                            ELSE 0
                           ).

      IF tt-opcard.comm LE 0 THEN
         oDebitTurnover  = oDebitTurnover + tt-opcard.comm.
      ELSE
         oCreditTurnover = oCreditTurnover + tt-opcard.comm.
   END.


   RETURN.
END PROCEDURE.

/* �����஢����� �㬬� */
PROCEDURE GetBlockedAmt:
   DEF INPUT  PARAM iCardNum         AS CHAR   NO-UNDO. /* ����               */
   DEF INPUT  PARAM iSurr            AS CHAR   NO-UNDO. /* ���ண�� �����               */
   DEF INPUT  PARAM iParentContract  AS CHAR   NO-UNDO.
   DEF INPUT  PARAM iParentContCode  AS CHAR   NO-UNDO.
   DEF OUTPUT PARAM oAmt             AS DEC    NO-UNDO.

   DEFINE VARIABLE vBlokSumm  AS CHARACTER      NO-UNDO.
   DEFINE VARIABLE vSurrAcct  AS CHARACTER      NO-UNDO.
   DEFINE VARIABLE vProcesing AS CHARACTER      NO-UNDO. /* ���ᨭ� */

   DEF BUFFER loan FOR loan. /* ���������� ����. */

   /* ��।������ �����஢����� �㬬� */
   vBlokSumm = fGetSetting ("����믨᪠", "�����㬬�"  , "" ).
   IF vBlokSumm EQ "���ਧ"
   THEN DO:
      FOR EACH tt-opcard WHERE (tt-opcard.date_val EQ ?
                            AND iParentContract    EQ "card-corp"
                            AND tt-opcard.card_num EQ iCardNum
                               )
                            OR (tt-opcard.date_val EQ ?
                            AND iParentContract    EQ "card-pers"
                               )
                            OR (tt-opcard.AddOper)
      :
         oAmt = oAmt + tt-opcard.total.
      END.
   END.
   ELSE IF vBlokSumm EQ "�����"
   THEN DO:
      FIND FIRST loan WHERE loan.contract  EQ iParentContract
                        AND loan.cont-code EQ iParentContCode
         NO-LOCK NO-ERROR.
      IF AVAIL loan
      THEN DO:
         ASSIGN
            vSurrAcct  = ENTRY(1,GetLinks ("card",iSurr,?,"���⠏��",CHR(1),mDateTo),CHR(1))
            vProcesing = GetCodeMisc("����끠���",loan.trade-sys,2)
         .
         FIND LAST op-int WHERE op-int.file-name   EQ "acct"
                            AND op-int.surrogate   EQ vSurrAcct
                            AND op-int.class-code  EQ "����╫�"
                            AND op-int.create-date LE mDateTo
                            AND op-int.destination EQ vProcesing
            NO-LOCK NO-ERROR.
         IF AVAIL op-int THEN oAmt = op-int.par-dec[2].
      END.
   END.

END PROCEDURE.

/* ����㯭� ����� */
PROCEDURE GetAvailAmt:
   DEF INPUT  PARAM iCardNum         AS CHAR   NO-UNDO. /* ����               */
   DEF INPUT  PARAM iSurr            AS CHAR   NO-UNDO. /* ���ண�� �����      */
   DEF INPUT  PARAM iParentContract  AS CHAR   NO-UNDO.
   DEF INPUT  PARAM iParentContCode  AS CHAR   NO-UNDO.
   DEF OUTPUT PARAM oAmt             AS DEC    NO-UNDO.

   DEFINE VARIABLE vSurrAcct  AS CHARACTER     NO-UNDO.
   DEFINE VARIABLE vProcesing AS CHARACTER     NO-UNDO. /* ���ᨭ� */

   DEF BUFFER loan FOR loan. /* ���������� ����. */

   FIND FIRST loan WHERE loan.contract  EQ iParentContract
                     AND loan.cont-code EQ iParentContCode
      NO-LOCK NO-ERROR.
   IF AVAIL loan
   THEN DO:
      ASSIGN
         vSurrAcct =  ENTRY(1,GetLinks ("card",iSurr,?,"���⠏��",CHR(1),mDateTo),CHR(1))
         vProcesing = GetCodeMisc("����끠���",loan.trade-sys,2)
      .
      FIND LAST op-int WHERE op-int.file-name   EQ "acct"
                         AND op-int.surrogate   EQ vSurrAcct
                         AND op-int.class-code  EQ "����╫�"
                         AND op-int.create-date LE mDateTo
                         AND op-int.destination EQ vProcesing
         NO-LOCK NO-ERROR.
      IF AVAIL op-int THEN oAmt = op-int.par-dec[3].
   END.

END PROCEDURE.


/* ����祭�� ������������ �࣠����樨 */
PROCEDURE GetNameOrg:
DEF INPUT  PARAM iContract   AS CHAR   NO-UNDO.
DEF INPUT  PARAM iContCode   AS CHAR   NO-UNDO.
DEF OUTPUT PARAM oNameOrg    AS CHAR   NO-UNDO.

   DEF VAR       vClName     AS CHAR   NO-UNDO EXTENT 3.
   DEF VAR       vLinkId     AS INT    NO-UNDO. /* GetXLink */

   DEF BUFFER loan  FOR loan.
   DEF BUFFER loan2 FOR loan.
   DEF BUFFER gr    FOR loan. /* �/� ������� */
   DEF BUFFER xlink FOR xlink.

   FOR FIRST loan WHERE loan.contract  EQ iContract
                    AND loan.cont-code EQ iContCode
   NO-LOCK:
      IF iContract EQ "card-corp" THEN
      DO:
         RUN GetCustName IN h_base (             loan.cust-cat,
                                                 loan.cust-id,
                                                 "",
                                    OUTPUT       vClName[1],
                                    OUTPUT       vClName[2],
                                    INPUT-OUTPUT vClName[3]).
         oNameOrg = vClName[1] + " " + vClName[2].
      END.

      ELSE DO:
         RUN GetXLink IN h_xclass (       "card-loan-gr",
                                          "��������⥫�",
                                   OUTPUT vLinkId,
                                   BUFFER xlink
         ).

         FOR FIRST       loan2 WHERE loan2.contract  EQ iContract
                                 AND loan2.cont-code EQ iContCode
         NO-LOCK:
            /*
               �饬 ���� �������騩 �� �������.
               �᫨ �������饣� ��� - � ���� ����
            */
            forgr:
            FOR EACH     links  WHERE  links.link-id   EQ vLinkId
                                  AND  links.target-id EQ loan2.contract + "," +
                                                          loan2.cont-code
                                  AND (links.end-date  GE mDateTo
                                   OR  links.end-date  EQ ?)
            NO-LOCK:
               RELEASE gr.
               FIND FIRST gr    WHERE  gr.contract     EQ ENTRY(1, links.source-id)
                                  AND  gr.cont-code    EQ ENTRY(2, links.source-id)
                                  AND (gr.end-date     LE mDateTo
                                   OR  gr.end-date     EQ ?
                                      )
               NO-LOCK NO-ERROR.
               IF AVAIL gr THEN
               DO:
                  RUN GetCustName IN h_base (             gr.cust-cat,
                                                          gr.cust-id,
                                                          "",
                                             OUTPUT       vClName[1],
                                             OUTPUT       vClName[2],
                                             INPUT-OUTPUT vClName[3]).
                  oNameOrg = IF oNameOrg EQ ""
                             THEN vClName[1] + " " + vClName[2]
                             ELSE oNameOrg + CHR(1) + vClName[1] + " " + vClName[2].
               END.
            END.
         END.
      END.
   END.

   RETURN.
END PROCEDURE.


/* ����� ⥪�饩 ������������ */
PROCEDURE GetCredit:
DEF INPUT  PARAM iContract   AS CHAR   NO-UNDO.
DEF INPUT  PARAM iContCode   AS CHAR   NO-UNDO.
DEF OUTPUT PARAM oAmt        AS DEC    NO-UNDO.

   DEF VAR vAcctType AS CHAR NO-UNDO.
   DEF VAR vContract AS CHAR NO-UNDO.
   DEF VAR vContCode AS CHAR NO-UNDO.
   DEF VAR vAcct     AS CHAR NO-UNDO.
   DEF VAR vCurr     AS CHAR NO-UNDO.

   DEF BUFFER acct FOR acct.

   vAcctType = FGetSettingEx ("����믨᪠",
                              "�����㤑��",
                              "",
                              NO
                             ).

   RUN GetCardLoanCredit IN h_card (        iContract,
                                            iContCode,
                                            ?,
                                            mDateTo,
                                            "�����",
                                    OUTPUT vContract,
                                    OUTPUT vContCode
                                   ).

   RUN GetCredLoanBalance IN h_card (       vContract,
                                            vContCode,
                                            mDateTo,
                                            vAcctType,
                                     OUTPUT oAmt,
                                     OUTPUT vAcct,
                                     OUTPUT vCurr
                                    ).

   IF vAcct NE "" THEN
   DO:
      FOR FIRST acct WHERE acct.acct     EQ vAcct
                       AND acct.currency EQ vCurr
      NO-LOCK:
         IF acct.side EQ "�" THEN
            oAmt = oAmt * (- 1).
      END.
   END.

   RETURN.
END PROCEDURE.


/* ����� ���ᯮ�짮������� ����� */
PROCEDURE GetLim:
DEF INPUT  PARAM iContract   AS CHAR   NO-UNDO.
DEF INPUT  PARAM iContCode   AS CHAR   NO-UNDO.
DEF OUTPUT PARAM oAmt        AS DEC    NO-UNDO.

   DEF VAR vAcctType AS CHAR NO-UNDO.
   DEF VAR vContract AS CHAR NO-UNDO.
   DEF VAR vContCode AS CHAR NO-UNDO.
   DEF VAR vAcct     AS CHAR NO-UNDO.
   DEF VAR vCurr     AS CHAR NO-UNDO.
   DEF VAR vAmt      AS DEC  NO-UNDO.
   DEF VAR vCode     AS CHAR NO-UNDO.

   DEF BUFFER acct FOR acct.

   ASSIGN
      vAcctType = FGetSettingEx ("����믨᪠",
                                 "���썥�ᯋ��",
                                 "",
                                 NO
                                )

      vCode     = FGetSettingEx ("����믨᪠",
                                 "�������窠",
                                 "",
                                 NO
                                )
      vCode     = IF ENTRY(1, vCode) EQ "�।��"
                  THEN ENTRY(1, vCode)
                  ELSE ""
   .

   RUN GetCardLoanCredit IN h_card (        iContract,
                                            iContCode,
                                            ?,
                                            mDateTo,
                                            "�����",
                                    OUTPUT vContract,
                                    OUTPUT vContCode
                                   ).

   RUN GetCredLoanBalance IN h_card (       vContract,
                                            vContCode,
                                            mDateTo,
                                            vAcctType,
                                     OUTPUT oAmt,
                                     OUTPUT vAcct,
                                     OUTPUT vCurr
                                    ).

   RUN GetCredLoanBalance IN h_card (       vContract,
                                            vContCode,
                                            mDateTo,
                                            vCode,
                                     OUTPUT vAmt,
                                     OUTPUT vAcct,
                                     OUTPUT vCurr
                                    ).

   IF vAcct NE "" THEN
   DO:
      FOR FIRST acct WHERE acct.acct     EQ vAcct
                       AND acct.currency EQ vCurr
      NO-LOCK:
         IF acct.side EQ "�" THEN
            oAmt = oAmt * (- 1) - ABS(vAmt).
      END.
   END.

   RETURN.
END PROCEDURE.

