{pirsavelog.p}
/**             ��� �� "�P��������������", ��ࠢ����� ��⮬�⨧�樨 (�) 2007
                ���� ����� �� ��㯭� �����⠬
		ᤥ��� �� pir_krupnye.p - �������� �롮� ��⮢,
		������砥��� Ctrl-G � ��㧥� ��⮢
��ࠡ�⠫ 09/02/12 SStepanov ����� ��㯯� ��� ����� �����⮢ � ��㣨�
cust-id � person-id
		#843 ����� �� ��몥 ����ᮢ �����(pir_krupnye*.p) � ����⨥ ��⮢ � �����⨪�(pir_anketa.p)
		����� ����ᨫ�, �⮡� � ��� �뫠 ��㣠� �㭪樮���쭮��� �� ����� ��� ����� �ᥣ�� �����뢠�� ���� ������ ���
		PROCEDURE FirstKlAcctPODFT :
		����� ��� ��� �஬� ����� �� �����뢠�� ���� ������ ��� �᫨ �� ������ PROCEDURE FirstKlAcct :
*/

{globals.i}           /** �������� ��।������ */
{tmprecid.def}        /** �ᯮ��㥬 ���ଠ�� �� ��㧥� */
{intrface.get xclass} /** �㭪樨 ��� ࠡ��� � ����奬�� */
{intrface.get strng}  /** �㭪樨 ��� ࠡ��� � ��ப��� */

{tmprecid.def}        /** �ᯮ��㥬 ���ଠ�� �� ��㧥� */

{sh-defs.i}

/******************************************* ��।������ ��६����� � ��. */
DEFINE INPUT PARAM icPorog AS CHAR         NO-UNDO.

DEFINE VARIABLE dPorog  AS DECIMAL   NO-UNDO.
DEFINE VARIABLE cXL     AS CHARACTER NO-UNDO.
/*
DEFINE VARIABLE iMes    AS INTEGER   NO-UNDO.
DEFINE VARIABLE iGod    AS INTEGER   NO-UNDO.
DEFINE VARIABLE iMes1   AS INTEGER   NO-UNDO.
DEFINE VARIABLE iGod1   AS INTEGER   NO-UNDO.
DEFINE VARIABLE iYM     AS INTEGER   NO-UNDO.
DEFINE VARIABLE daBegY  AS DATE      NO-UNDO.
DEFINE VARIABLE daBegM  AS DATE      NO-UNDO.
DEFINE VARIABLE daBegYP AS DATE      NO-UNDO.
DEFINE VARIABLE daEndM  AS DATE      NO-UNDO.
*/
DEFINE VARIABLE cMesStr AS CHARACTER INIT "������,���ࠫ�,����,��५�,���,���,���,������,�������,������,�����,�������"  NO-UNDO.

DEFINE TEMP-TABLE ttCl NO-UNDO
   FIELD iRate   AS INTEGER
   FIELD iRateM  AS INTEGER
   FIELD iRateP  AS INTEGER
   FIELD cClName AS CHARACTER
   FIELD cClType AS CHARACTER
   FIELD cClINN  AS CHARACTER
   FIELD dYDb    AS DECIMAL
   FIELD dYCr    AS DECIMAL
   FIELD dMDb    AS DECIMAL
   FIELD dMCr    AS DECIMAL
   FIELD dYPDb   AS DECIMAL
   FIELD dYPCr   AS DECIMAL
   FIELD daFAcc  AS DATE
   FIELD daLAcc  AS DATE
.
DEFINE VARIABLE cFstAcct  AS CHARACTER NO-UNDO.
DEFINE VARIABLE daFirstCl AS DATE      NO-UNDO.
DEFINE VARIABLE cUsrFirst AS CHARACTER NO-UNDO.
DEFINE VARIABLE iR        AS INTEGER   NO-UNDO.

DEFINE VARIABLE dSYDb     AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dSYCr     AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dSY20Db   AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dSY20Cr   AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dSY30Db   AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dSY30Cr   AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dSMDb     AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dSMCr     AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dSM20Db   AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dSM20Cr   AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dSM30Db   AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dSM30Cr   AS DECIMAL   NO-UNDO.

/*******************************************  */
dPorog = DECIMAL(icPorog).

{pir_krupnye.frm}
{pir_anketa.fun}
{pir_exf_exl.i}

cXL = "/home2/bis/quit41d/imp-exp/users/" + LC(UserID("bisquit")) + "/BigCred.xls".
REPEAT:
   {getfile.i &filename = cXL &mode = create} 
   LEAVE.
END.
/*
{exp-path.i &exp-filename = "'BigCred.xls'"}
iMes = MONTH(end-date).
iGod = YEAR(end-date).
iYM  = 12 * iGod + iMes.

daBegM  = DATE(iMes, 1, iGod).
daBegYP = DATE(iMes, 1, iGod - 1).
iMes1   = (iYM MODULO 12) + 1.
iGod1   = INTEGER(TRUNCATE(iYM / 12, 0)).
daEndM  = DATE(iMes1, 1, iGod1) - 1.
daBegY  = DATE(iMes1, 1, iGod1 - 1).
*/

/*******************************************  */
PUT UNFORMATTED XLHead("���� �� " + STRING(TODAY, "99.99.9999"),
                       "CCCNNNNNNDD", "215,92,150,110,110,110,110,110,110,71,71").

cXL = XLCell("������������ ������")
    + XLCell("���")
    + XLCell("Acct")
    + XLCell("�।.���. ����� �� ������")
    + XLCell("�।.���. ����� �� �।���")
    + XLCell("������� ����� �� ������")
    + XLCell("������� ����� �� �।���")
    + XLCell("������ ����� �� ������")
    + XLCell("������ ����� �� �।���")
    + XLCell("��� ���. �/�")
    + XLCell("��� ������� ���")
    .

PUT UNFORMATTED XLRow(0) cXL XLRowEnd().

/*******************************************  */
/*
FOR EACH cust-corp
   WHERE (cust-corp.date-out EQ ?)
   NO-LOCK
   BY cust-corp.name-corp
   BY cust-corp.cust-id
:

   put screen col 1 row 24 "��ࠡ��뢠���� " + STRING(cust-corp.name-corp) + FILL(" ", 60).

   CREATE ttCl.
   ASSIGN
      ttCl.cClName = cust-corp.cust-stat + " " + cust-corp.name-corp
      ttCl.cClType = (IF ((cust-corp.cust-stat EQ "��")
                       OR (cust-corp.cust-stat EQ "�����")
                       OR (cust-corp.cust-stat EQ "�������")
                       OR (cust-corp.cust-stat EQ "������")
                       OR (cust-corp.cust-stat EQ "���")
                         ) THEN "�" ELSE "�")
/*      ttCl.cClINN  = (IF (cust-corp.country-id EQ "RUS") THEN cust-corp.inn
                      ELSE GetXAttrValue("cust-corp", STRING(cust-corp.cust-id), "���"))
*/    
      /* #3358 */
      ttCl.cClINN  = (IF (cust-corp.inn <> "") THEN cust-corp.inn
                      ELSE GetXAttrValue("cust-corp", STRING(cust-corp.cust-id), "���"))
      ttCl.dMDb    = 0
      ttCl.dMCr    = 0
      ttCl.dYDb    = 0
      ttCl.dYCr    = 0
      ttCl.dYPDb   = 0
      ttCl.dYPCr   = 0
      NO-ERROR.

   FOR EACH acct
      WHERE (acct.cust-cat EQ "�")
        AND (acct.cust-id  EQ cust-corp.cust-id)
        AND (acct.acct BEGINS "40")
        AND NOT CAN-DO("�����,����", acct.contract)
        AND ((acct.close-date GT daBegYP)
          OR (acct.close-date EQ ?))
*/

DEF BUFFER bacct FOR acct.
FOR EACH tmprecid NO-LOCK
	, FIRST acct
		WHERE RECID(acct) 	= tmprecid.id
		      AND acct.cust-cat 	= "�"
		NO-LOCK
	, FIRST cust-corp
   	  	WHERE cust-corp.cust-id = acct.cust-id
   		NO-LOCK
   BREAK BY cust-corp.name-corp
      	 BY cust-corp.cust-id
:

  IF    FIRST-OF(cust-corp.name-corp) 
     OR FIRST-OF(cust-corp.cust-id)   THEN DO:

   put screen col 1 row 24 "��ࠡ��뢠���� " + STRING(cust-corp.name-corp) + FILL(" ", 60).

   CREATE ttCl.
   ASSIGN
      ttCl.cClName = cust-corp.cust-stat + " " + cust-corp.name-corp
      ttCl.cClType = (IF ((cust-corp.cust-stat EQ "��")
                       OR (cust-corp.cust-stat EQ "�����")
                       OR (cust-corp.cust-stat EQ "�������")
                       OR (cust-corp.cust-stat EQ "������")
                       OR (cust-corp.cust-stat EQ "���")
                         ) THEN "�" ELSE "�")
      ttCl.cClINN  = (IF (cust-corp.country-id EQ "RUS") THEN cust-corp.inn
                      ELSE GetXAttrValue("cust-corp", STRING(cust-corp.cust-id), "���"))
      ttCl.dMDb    = 0
      ttCl.dMCr    = 0
      ttCl.dYDb    = 0
      ttCl.dYCr    = 0
      ttCl.dYPDb   = 0
      ttCl.dYPCr   = 0
      NO-ERROR.

  END. /* IF FIRST-OF(cust-corp.name-corp) THEN DO: */

      cXL = XLCell(ttCl.cClName)
          + XLCell(ttCl.cClINN)
          + XLCell(acct.acct)
          .

      RUN acct-pos IN h_base(acct.acct, acct.currency, daBegYP, daEndYP, cXL).
      ttCl.dYPDb = ttCl.dYPDb + sh-db.
      ttCl.dYPCr = ttCl.dYPCr + sh-cr.
      cXL = cXL
          + XLNumCell(sh-db)
          + XLNumCell(sh-cr)
          .

      RUN acct-pos IN h_base(acct.acct, acct.currency, daBegY, daEndY, cXL).
      ttCl.dYDb  = ttCl.dYDb  + sh-db.
      ttCl.dYCr  = ttCl.dYCr  + sh-cr.
      cXL = cXL
          + XLNumCell(sh-db)
          + XLNumCell(sh-cr)
          .

      RUN acct-pos IN h_base(acct.acct, acct.currency, daBegM, daEndM, cXL).
      ttCl.dMDb  = ttCl.dMDb  + sh-db.
      ttCl.dMCr  = ttCl.dMCr  + sh-cr.

      cXL = cXL
          + XLNumCell(sh-db)
          + XLNumCell(sh-cr)
          + XLDateCell(acct.open-date)
          + XLDateCell(acct.close-date)
          .

      PUT UNFORMATTED XLRow(0) cXL XLRowEnd().
/*   END. */

  IF    LAST-OF(cust-corp.name-corp)
     OR LAST-OF(cust-corp.cust-id)  THEN DO:
/* PUT UNFORMATTED "RUN FirstKlAcct(��" cust-corp.cust-id SKIP. */
   IF (ttCl.cClType EQ "�")
   THEN
      RUN FirstKlAcctPODFT("��", cust-corp.cust-id, OUTPUT cFstAcct, OUTPUT ttCl.daFAcc, OUTPUT daFirstCl, OUTPUT cUsrFirst).
   ELSE
      RUN FirstKlAcctPODFT("��", cust-corp.cust-id, OUTPUT cFstAcct, OUTPUT ttCl.daFAcc, OUTPUT daFirstCl, OUTPUT cUsrFirst).

   IF (daFirstCl NE ?)
   THEN DO:
      ttCl.daLAcc  = daFirstCl.

      FOR EACH bacct
         WHERE (bacct.cust-cat EQ "�")
           AND (bacct.cust-id  EQ cust-corp.cust-id)
           AND (bacct.acct BEGINS "40")
           AND NOT CAN-DO("�����,����", bacct.contract)
           AND NOT (bacct.close-date GT daFirstCl)
         NO-LOCK
         BY bacct.close-date DESCENDING:

         ttCl.daLAcc  = bacct.close-date.
         LEAVE.
      END.
   END.
  END. /* IF LAST-OF(cust-corp.name-corp) THEN DO: */
END. /* FOR EACH tmprecid NO-LOCK */

/*******************************************  */
/*
FOR EACH person
   WHERE (person.date-out EQ ?)
   NO-LOCK
   BY person.name-last
   BY person.person-id
:

   put screen col 1 row 24 "��ࠡ��뢠���� " + person.name-last + " " + person.first-names + FILL(" ", 60).

   CREATE ttCl.
   ASSIGN
      ttCl.cClName = person.name-last + " " + person.first-names
      ttCl.cClType = "�"
      ttCl.cClINN  = (IF ((person.inn EQ "000000000000") OR (person.inn = "0")) THEN "" ELSE person.inn)
      ttCl.dMDb    = 0
      ttCl.dMCr    = 0
      NO-ERROR.

   FOR EACH acct
      WHERE (acct.cust-cat EQ "�")
        AND (acct.cust-id  EQ person.person-id)
        AND (acct.acct BEGINS "40")
        AND NOT CAN-DO("�����,����", acct.contract)
        AND ((acct.close-date GT daBegYP)
          OR (acct.close-date EQ ?))
      NO-LOCK:
*/
FOR EACH tmprecid NO-LOCK
	, FIRST acct
		WHERE RECID(acct) 	= tmprecid.id
		      AND acct.cust-cat 	= "�"
		NO-LOCK
	, FIRST person
   	  	WHERE person.person-id = acct.cust-id
   		NO-LOCK
   BREAK BY person.name-last
         BY person.person-id
:

  IF    FIRST-OF(person.name-last)
     OR FIRST-OF(person.person-id) /* SSV ���� ����� 24/02/12 */
  THEN DO:
   put screen col 1 row 24 "��ࠡ��뢠���� " + person.name-last + " " + person.first-names + FILL(" ", 60).

   CREATE ttCl.
   ASSIGN
      ttCl.cClName = person.name-last + " " + person.first-names
      ttCl.cClType = "�"
      ttCl.cClINN  = (IF ((person.inn EQ "000000000000") OR (person.inn = "0")) THEN "" ELSE person.inn)
      ttCl.dMDb    = 0
      ttCl.dMCr    = 0
      NO-ERROR.
  END. /* IF FIRST-OF(person.name-last) THEN DO: */

      cXL = XLCell(ttCl.cClName)
          + XLCell(ttCl.cClINN)
          + XLCell(acct.acct)
          + XLEmptyCells(2)
          .

      RUN acct-pos IN h_base(acct.acct, acct.currency, daBegY, daEndY, cXL).
      ttCl.dYDb  = ttCl.dYDb  + sh-db.
      ttCl.dYCr  = ttCl.dYCr  + sh-cr.
      cXL = cXL
          + XLNumCell(sh-db)
          + XLNumCell(sh-cr)
          .

      RUN acct-pos IN h_base(acct.acct, acct.currency, daBegM, daEndM, cXL).
      ttCl.dMDb  = ttCl.dMDb  + sh-db.
      ttCl.dMCr  = ttCl.dMCr  + sh-cr.

      cXL = cXL
          + XLNumCell(sh-db)
          + XLNumCell(sh-cr)
          + XLDateCell(acct.open-date)
          + XLDateCell(acct.close-date)
          .

      PUT UNFORMATTED XLRow(0) cXL XLRowEnd().
/*   END. */

/* PUT UNFORMATTED "RUN FirstKlAcct(��" cust-corp.cust-id SKIP. */
   RUN FirstKlAcctPODFT("��", person.person-id, OUTPUT cFstAcct, OUTPUT ttCl.daFAcc, OUTPUT daFirstCl, OUTPUT cUsrFirst).

  IF    LAST-OF(person.name-last)
     OR LAST-OF(person.person-id)
THEN DO:
   IF (daFirstCl NE ?)
   THEN DO:
      ttCl.daLAcc  = daFirstCl.

      FOR EACH bacct
         WHERE (bacct.cust-cat EQ "�")
           AND (bacct.cust-id  EQ person.person-id)
           AND (bacct.acct BEGINS "40")
           AND NOT CAN-DO("�����,����", bacct.contract)
           AND NOT (bacct.close-date GT daFirstCl)
         NO-LOCK
         BY bacct.close-date DESCENDING:

         ttCl.daLAcc  = bacct.close-date.
         LEAVE.
      END.
   END.
  END. /* IF LAST-OF(person.name-last) THEN DO: */
END.

put screen col 1 row 24 FILL(" ", 80).

/*******************************************  */
ASSIGN
   iR    = 0
   dSYDb = 0
   dSYCr = 0
   dSMDb = 0
   dSMCr = 0
   NO-ERROR.

FOR EACH ttCl
   WHERE (ttCl.cClType EQ "�")
   NO-LOCK
   BY ttCl.dYDb DESCENDING:

   ASSIGN
      iR         = iR + 1
      ttCl.iRate = iR
      dSYDb = dSYDb + ttCl.dYDb
      dSYCr = dSYCr + ttCl.dYCr
      dSMDb = dSMDb + ttCl.dMDb
      dSMCr = dSMCr + ttCl.dMCr
      NO-ERROR.
END.

iR = 0.
FOR EACH ttCl
   WHERE (ttCl.cClType EQ "�")
   NO-LOCK
   BY ttCl.dYPDb DESCENDING:

   iR          = iR + 1.
   ttCl.iRateP = iR.
END.

iR = 0.
FOR EACH ttCl
   WHERE (ttCl.cClType EQ "�")
   NO-LOCK
   BY ttCl.dMDb DESCENDING:

   iR          = iR + 1.
   ttCl.iRateM = IF (ttCl.dMDb NE 0) THEN iR ELSE 0.
END.

/*******************************************  */
PUT UNFORMATTED XLNextList(cListN, "IICCNNINNCCCCDD", "53,53,215,92,110,110,53,110,110,50,50,50,50,71,71").

IF lNeStnd
THEN
   cXL = XLCell("����� ���/��:  ���᮪ ��㯭�� �����⮢ ����� �� " + STRING(daEndM + 1, "99.99.9999") + " ����."
              + " (��ਮ� 1 : " + STRING(daBegYP, "99.99.9999") + " - " + STRING(daEndYP, "99.99.9999")
              + ", ��ਮ� 2 : " + STRING(daBegY,  "99.99.9999") + " - " + STRING(daEndY,  "99.99.9999")
              + ", ��ਮ� 3 : " + STRING(daBegM,  "99.99.9999") + " - " + STRING(daEndM,  "99.99.9999") + ")").
ELSE
   cXL = XLCell("����� ���/��:  ���᮪ ��㯭�� �����⮢ ����� �� " + STRING(daEndM + 1, "99.99.9999")
              + " ����. ������� ��ਮ�:  " + STRING(daBegY, "99.99.9999") + " - " + STRING(daEndM, "99.99.9999")
              + ". ����� - " + ENTRY(iMes, cMesStr) + " " + STRING(iGod, "9999")).
PUT UNFORMATTED XLRow(0) cXL XLRowEnd().

cXL = XLCell("�।. ३⨭� (���)")
    + XLCell("���⨭� (���)")
    + XLCell("������������ ������")
    + XLCell("���")
    + XLCell("������� ����� �� ������")
    + XLCell("������� ����� �� �।���")
    + XLCell("���⨭� �� " + ENTRY(iMes, cMesStr))
    + XLCell("������ ����� �� ������")
    + XLCell("������ ����� �� �।���")
    + XLCell("��� ��᫥����� ����")
    + XLCell("������ (���� �� " + ENTRY(iMes1, cMesStr) + ")")
    + XLCell("���")
    + XLCell("��ࠢ�� �� ���")
    + XLCell("��� ���.��ࢮ�� �/�")
    + XLCell("��� ������� ��᫥����� ���")
    .

PUT UNFORMATTED XLRow(1) cXL XLRowEnd().

FOR EACH ttCl
   WHERE (ttCl.cClType EQ "�")
   NO-LOCK
   BY ttCl.iRate
   iR = 1 TO 30 :

   ASSIGN
      dSY30Db = dSY30Db + ttCl.dYDb
      dSY30Cr = dSY30Cr + ttCl.dYCr
      dSM30Db = dSM30Db + ttCl.dMDb
      dSM30Cr = dSM30Cr + ttCl.dMCr
      ttCl.cClType = "30"
      NO-ERROR.

   IF (iR LE 20)
   THEN
      ASSIGN
         dSY20Db = dSY20Db + ttCl.dYDb
         dSY20Cr = dSY20Cr + ttCl.dYCr
         dSM20Db = dSM20Db + ttCl.dMDb
         dSM20Cr = dSM20Cr + ttCl.dMCr
         NO-ERROR.

   cXL = XLNumCell(ttCl.iRateP)
       + XLNumCell(ttCl.iRate)
       + XLCell(ttCl.cClName)
       + XLCell(ttCl.cClINN)
       + XLNumCell(ttCl.dYDb)
       + XLNumCell(ttCl.dYCr)
       + (IF (ttCl.iRateM NE 0) THEN XLNumCell(ttCl.iRateM) ELSE XLCell("--"))
       + XLNumCell(ttCl.dMDb)
       + XLNumCell(ttCl.dMCr)
       + XLEmptyCells(4)
       + XLDateCell(ttCl.daFAcc)
       + XLDateCell(ttCl.daLAcc)
       .
   PUT UNFORMATTED XLRow(0) cXL XLRowEnd() .
END.

cXL = XLEmptyCells(2)
    + XLCell("�ᥣ� �� 20:")
    + XLEmptyCell()
    + XLNumCell(dSY20Db)
    + XLNumCell(dSY20Cr)
    + XLEmptyCell()
    + XLNumCell(dSM20Db)
    + XLNumCell(dSM20Cr)
    .
PUT UNFORMATTED XLRow(2) cXL XLRowEnd() .

cXL = XLEmptyCells(2)
    + XLCell("�ᥣ� �� 30:")
    + XLEmptyCell()
    + XLNumCell(dSY30Db)
    + XLNumCell(dSY30Cr)
    + XLEmptyCell()
    + XLNumCell(dSM30Db)
    + XLNumCell(dSM30Cr)
    .
PUT UNFORMATTED XLRow(0) cXL XLRowEnd() .

cXL = XLEmptyCells(2)
    + XLCell("�⮣� ����⮢ �� ���/�����:")
    + XLEmptyCell()
    + XLNumCell(dSYDb)
    + XLNumCell(dSYCr)
    + XLEmptyCell()
    + XLNumCell(dSMDb)
    + XLNumCell(dSMCr)
    .
PUT UNFORMATTED XLRow(0) cXL XLRowEnd() .

cXL = XLEmptyCells(2)
    + XLCell("���� ����⮢ 20 ��㯭�� �����⮢ (%):")
    + XLEmptyCell()
    + XLNumCell(ROUND(dSY20Db / dSYDb * 100, 2))
    + XLNumCell(ROUND(dSY20Cr / dSYCr * 100, 2))
    + XLEmptyCell()
    + XLNumCell(ROUND(dSM20Db / dSMDb * 100, 2))
    + XLNumCell(ROUND(dSM20Cr / dSMCr * 100, 2))
    .
PUT UNFORMATTED XLRow(0) cXL XLRowEnd() .

/*******************************************  */
cXL = XLCell("��㣨� �������, ����騥 ������ ��� " + STRING(dPorog / 1000000) + " ���. �㡫�� �� "
            + ENTRY(iMes, cMesStr) + " " + STRING(iGod, "9999") + " ����").
PUT UNFORMATTED XLRow(2) XLRowEnd() XLRow(0) cXL XLRowEnd().

cXL = XLEmptyCell()
    + XLCell("N �/�")
    + XLCell("������������ ������")
    + XLCell("���")
    + XLCell("������� ����� �� ������")
    + XLCell("������� ����� �� �।���")
    + XLCell("���⨭� �� " + ENTRY(iMes, cMesStr))
    + XLCell("������ ����� �� ������")
    + XLCell("������ ����� �� �।���")
    + XLCell("��� ��᫥����� ����")
    + XLCell("������ (���� �� " + ENTRY(iMes1, cMesStr) + ")")
    + XLCell("���")
    + XLCell("��ࠢ�� �� ���")
    + XLCell("��� ���.��ࢮ�� �/�")
    + XLCell("��� ������� ��᫥����� ���")
    .

PUT UNFORMATTED XLRow(1) cXL XLRowEnd().

ASSIGN
   iR    = 0
   dSYDb = 0
   dSYCr = 0
   dSMDb = 0
   dSMCr = 0
   NO-ERROR.

FOR EACH ttCl
   WHERE (ttCl.cClType NE "30")
     AND (ttCl.dMDb    GE dPorog)
   NO-LOCK
   BY ttCl.dMDb DESCENDING:

   ASSIGN
      iR         = iR + 1
      dSYDb = dSYDb + ttCl.dYDb
      dSYCr = dSYCr + ttCl.dYCr
      dSMDb = dSMDb + ttCl.dMDb
      dSMCr = dSMCr + ttCl.dMCr
      NO-ERROR.

   cXL = XLEmptyCell()
       + XLNumCell(iR)
       + XLCell(ttCl.cClName)
       + XLCell(ttCl.cClINN)
       + XLNumCell(ttCl.dYDb)
       + XLNumCell(ttCl.dYCr)
       + (IF (ttCl.cClType EQ "�") THEN XLNumCell(ttCl.iRateM) ELSE XLCell("--"))
       + XLNumCell(ttCl.dMDb)
       + XLNumCell(ttCl.dMCr)
       + XLEmptyCells(4)
       + XLDateCell(ttCl.daFAcc)
       + XLDateCell(ttCl.daLAcc)
       .
   PUT UNFORMATTED XLRow(0) cXL XLRowEnd().
END.

cXL = XLEmptyCells(2)
    + XLCell("�⮣�:")
    + XLEmptyCell()
    + XLNumCell(dSYDb)
    + XLNumCell(dSYCr)
    + XLEmptyCell()
    + XLNumCell(dSMDb)
    + XLNumCell(dSMCr)
    .
PUT UNFORMATTED XLRow(0) cXL XLRowEnd().

PUT UNFORMATTED XLEnd().

{intrface.del}
