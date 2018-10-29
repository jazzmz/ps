{pirsavelog.p}

/*
                ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright:  (C) 1992-1997 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename:  OP-LENTA.P
      Comment:  ����� �������� �஢����

         Uses:  -
      Used by:  op-en(s1.p,op-en(s2.p
      Created:  05/05/1996 eagle
     Modified:  20/10/1999 Stepanov S.V. from op-enpr2.p 
     Modified:  22/10/2003 kraw (0012130) �⮡� ����஢���� �।�⠢�﫨��
                                          "��� � ��壠���᪮� ��ୠ��" (op-enbu2)
                21.07.2006 9:10 ���� �.�. - ��� ��� ����஢������ ������ᨩ.
                                � ����஢����� ���筮 �� ����� ⨯� (� ����ᨬ��� �� ������ �� ���ன ������-
                                ����� � ������ � ������ �����������)
                                1. ��-���		��-?			���-840
                                2. ��-?				��-���		���-978
                                3. ��-?				��-���		���-810
                                ��� ���, �㦭� (�� �ॡ������ ����᭨�����), �⮡� �㡫���� ����஢����
                                �᪠���� �� ����⭮� ����஢����. ���� � ⮬, �� ����� �ନ���� ��� ࠧ�:
                                �⤥�쭮 䨫������ ������ ���㬥��� (��� ������ �஢���� <> "") � �⤥�쭮 
                                䨫������ �㡫��� �஢����. �㡫��� ����஢���� ������ �������� � ����� �� 
                                ����⭮�� 䨫���� � � � �� �६� �� �������� � ����� �� �㡫����� 䨫����.
*/

{op-entmp.i}

DEFINE VARIABLE adb          AS CHARACTER FORMAT 'x(25)' NO-UNDO.
DEFINE VARIABLE acr          AS CHARACTER FORMAT 'x(25)' NO-UNDO.
DEFINE VARIABLE j            AS INTEGER   INITIAL 0      NO-UNDO.
DEFINE VARIABLE lastofcur    AS LOGICAL                  NO-UNDO.
DEFINE VARIABLE lastofuserid AS LOGICAL                  NO-UNDO.
DEFINE VARIABLE lastuserid   AS LOGICAL                  NO-UNDO.

DEFINE BUFFER xop-entry FOR op-entry.

DEFINE TEMP-TABLE xentry NO-UNDO
   FIELD num      AS INTEGER
   FIELD op-date  AS DATE 
   FIELD doc-num  LIKE op.doc-num
   FIELD op       LIKE op-entry.op
   FIELD currency AS CHARACTER
   FIELD doc-type LIKE op.doc-type
   FIELD acct-db  AS CHARACTER
   FIELD acct-cr  AS CHARACTER
   FIELD amt      LIKE op-entry.amt-rub
   FIELD vamt     LIKE op-entry.amt-cur
   FIELD qty      LIKE op-entry.qty
   FIELD user-id  LIKE op.user-id
   FIELD polupr   AS CHARACTER
   INDEX acct-db doc-type acct-db
   INDEX op op polupr
.

/***************************************************************************/
function GetCBDocType1 returns char /* �����頥� ��-�� ��� ���㬥��     */
         (input in-doc-type as char): /* doc-type.doc-type */
  find first doc-type where doc-type.doc-type = in-doc-type no-lock no-error.
  return if avail doc-type then doc-type.digital else in-doc-type.
end function.
/***************************************************************************/

{setdest.i &cols=184}

FOR EACH tmprecid NO-LOCK,
   FIRST op-entry WHERE RECID(op-entry) = tmprecid.id NO-LOCK,
   op OF op-entry NO-LOCK
   BREAK BY op-entry.op-date
         BY op-entry.currency
         BY op-entry.amt-rub
         BY op-entry.qty
   ON ERROR UNDO, LEAVE:

   {on-esc leave}
   adb = ?. acr = ?.
   IF op-entry.acct-cr eq ? THEN
   DO:
      FIND FIRST xop-entry WHERE xop-entry.op = op.op 
                             AND xop-entry.acct-db eq ? 
         USE-INDEX op-entry NO-LOCK.
      ASSIGN
         adb = op-entry.acct-db
         acr = xop-entry.acct-cr
      .

      /** ���� ������� 20.07.2006 17:32 */
      FIND LAST xop-entry WHERE 
      	xop-entry.op = op.op
      	AND
      	xop-entry.acct-db EQ ?
      	AND
      	xop-entry.acct-cr <> acr
      	NO-LOCK NO-ERROR.
      IF AVAIL xop-entry THEN 
      DO:
	      CREATE xentry.
  	    xentry.doc-type = GetCBDocType1(op.doc-type).
    	  ASSIGN
         	xentry.acct-db  = adb
         	xentry.acct-cr  = xop-entry.acct-cr
         	xentry.currency = xop-entry.currency
         	xentry.doc-num  = op.doc-num
         	xentry.amt      = xop-entry.amt-rub
        	xentry.vamt     = xop-entry.amt-cur
        	xentry.op       = op.op
        	xentry.polupr   = "" 
        	xentry.user-id  = op.user-id
      	.
		  END.

      /** ���� end */      
   END.
   ELSE IF op-entry.acct-db EQ ? THEN
   DO:
      FIND FIRST xop-entry WHERE xop-entry.op = op.op
                             AND xop-entry.acct-cr eq ? 
         USE-INDEX op-entry NO-LOCK.
      ASSIGN
         adb = xop-entry.acct-db
         acr = op-entry.acct-cr
      .
      /** ���� ������� 21.07.2006 16:49 */
      FIND LAST xop-entry WHERE 
      	xop-entry.op = op.op
      	AND
      	xop-entry.acct-cr EQ ?
      	AND
      	xop-entry.acct-db <> adb
      	NO-LOCK NO-ERROR.
      IF AVAIL xop-entry THEN 
      DO:
	      CREATE xentry.
  	    xentry.doc-type = GetCBDocType1(op.doc-type).
    	  ASSIGN
         	xentry.acct-db  = xop-entry.acct-db
         	xentry.acct-cr  = acr
         	xentry.currency = xop-entry.currency
         	xentry.doc-num  = op.doc-num
         	xentry.amt      = xop-entry.amt-rub
        	xentry.vamt     = xop-entry.amt-cur
        	xentry.op       = op.op
        	xentry.polupr   = "" 
        	xentry.user-id  = op.user-id
      	.
		  END.

      /** ���� end */


   END.
   ELSE
      ASSIGN
         adb = op-entry.acct-db
         acr = op-entry.acct-cr
      .
          
   IF adb NE ? AND acr NE ? THEN
   DO:
      CREATE xentry.
      xentry.doc-type = GetCBDocType1(op.doc-type).
      ASSIGN
         xentry.acct-db  = adb
         xentry.acct-cr  = acr
         xentry.currency = op-entry.currency
         xentry.doc-num  = op.doc-num
         xentry.amt      = op-entry.amt-rub
         xentry.qty      = op-entry.qty
         xentry.vamt     = op-entry.amt-cur
         xentry.op       = op.op
         xentry.polupr   = IF op-entry.acct-db EQ ? THEN "d"
                           ELSE IF op-entry.acct-cr EQ ? THEN "c" ELSE ""
         xentry.user-id  = op.user-id
      .
   END.
END.
   
FOR EACH xentry BREAK BY xentry.op BY xentry.amt BY xentry.currency DESCENDING:
   IF last-of(xentry.op) AND xentry.polupr <> "" THEN
      DELETE xentry.
END.
   
FOR EACH xentry BREAK BY xentry.op:
   xentry.num = IF first-of(xentry.op) THEN 1 ELSE 0.
END.

FOR EACH xentry NO-LOCK
   BREAK BY xentry.op-date
         BY xentry.currency
         BY xentry.amt
         BY xentry.qty
   ON ERROR UNDO, LEAVE:

   FORM header
      caps(name-bank) FORMAT "x(60)" SKIP
      "����� ����������"
      (IF in-op-date-beg = in-op-date-end THEN
          "�� " + (IF in-op-date-end = ? THEN "?" ELSE STRING(in-op-date-end))
       ELSE
          "� "   + (IF in-op-date-beg = ? THEN "?" ELSE STRING(in-op-date-beg))
          + " �� " + (IF in-op-date-end = ? THEN "?" ELSE STRING(in-op-date-end))
      )
      FORMAT "x(45)"
      page-number FORM "����zz9" TO 104 SKIP(2)
   .

   ASSIGN
      lastofuserid = LAST-OF(xentry.op-date)
      lastofcur    = LAST-OF(xentry.currency)
      lastuserid   = LAST(xentry.op-date)
   .

   IF lastofuserid THEN
   DO:
      {chkpage IF lastuserid THEN 12
               ELSE IF lastofcur THEN 7 ELSE 4}
   END.

   FIND FIRST op-bank OF op NO-LOCK NO-ERROR.

   IF adb <> ? or acr <> ? THEN 
   DO:
      DISPLAY
         GetCBDocType1(xentry.doc-type) @ xentry.doc-type
         xentry.doc-num
         REPLACE(xentry.acct-db, '-', '') FORMAT "x(20)" column-label '�����'
         REPLACE(xentry.acct-cr, '-', '') FORMAT "x(20)" column-label '������'
/*
         xentry.vamt when xentry.vamt <> 0
         xentry.amt
*/
         xentry.qty COLUMN-LABEL "����������"
         xentry.user-id
         with no-box width 255
      .

      ACCUM
         xentry.vamt (sub-total BY xentry.currency)
         xentry.amt (TOTAL BY xentry.op-date BY xentry.currency)
         xentry.amt (COUNT BY xentry.op-date BY xentry.currency)
         xentry.qty (TOTAL BY xentry.op-date BY xentry.currency)
         xentry.qty (COUNT BY xentry.op-date BY xentry.currency)
      .
   END.

  IF lastofcur and not (xentry.currency = "" and lastofuserid) THEN 
  DO:
     DOWN.
     UNDERLINE xentry.doc-num /* xentry.vamt xentry.amt */ xentry.qty.
     DISPLAY
        (ACCUM COUNT BY xentry.currency xentry.amt) FORMAT ">>>>9"
           @ xentry.doc-num
/*
        (ACCUM sub-total BY xentry.currency xentry.vamt) @ xentry.vamt
        (ACCUM TOTAL BY xentry.currency xentry.amt) @ xentry.amt
*/
        (ACCUM TOTAL BY xentry.currency xentry.qty) @ xentry.qty.
     DOWN 1.
  END.

  IF lastofuserid THEN
  DO:
     j = j + 1.
     IF xentry.currency <> "" THEN 
        DOWN.
     UNDERLINE xentry.doc-num /* xentry.amt */ xentry.qty.
     DISPLAY
        (ACCUM COUNT BY xentry.op-date xentry.amt) FORMAT ">>>>9"
           @ xentry.doc-num
/*
        (ACCUM TOTAL BY xentry.op-date xentry.amt) @ xentry.amt
*/
        (ACCUM TOTAL BY xentry.op-date xentry.qty) @ xentry.qty.
     DOWN 2.
  END.

  IF lastuserid and j > 1 THEN 
  DO:
     UNDERLINE xentry.doc-num /* xentry.amt */ xentry.qty.
     DISPLAY
        (ACCUM COUNT xentry.amt) FORMAT ">>>>9" @ xentry.doc-num
/*
        (ACCUM TOTAL xentry.amt) @ xentry.amt
*/
        (ACCUM TOTAL xentry.qty) @ xentry.qty
     .
  END.

END.

{signatur.i &user-only=yes}
{preview.i}
