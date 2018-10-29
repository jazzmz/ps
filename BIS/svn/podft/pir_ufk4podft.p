/* pir_ufk4podft.p #974 ���� ���⥦�� � ��� �� �ᥬ ���⥦�� ������
   �ᯮ�� � .xls 䠩�, ������� ��ॣ���, ��� ��᪮�쪮 ��⮢ � ������ ������
*/

using Progress.Lang.*.

{globals.i}
{sh-defs.i}
{tmprecid.def}

{ulib.i}

{pir_exf_exl.i}

{getdates.i}

DEF VAR V_CUST_CORP_ACCTS 	AS CHAR NO-UNDO INIT "404*,405*,406*,407*,408*".
DEF VAR V_UFK_ACCTS 	 	AS CHAR NO-UNDO INIT "401*,402*,403*,404*".

{ulib.i}

def var d1 as int		NO-UNDO.
DEF VAR oTpl   AS TTpl   	NO-UNDO.
def var oTable AS TTableCSV 	NO-UNDO.

oTable = new TTableCsv(9).
  oTable:AddROW().
  oTable:addCell("�/�").
  oTable:addCell("������������ ������").
  oTable:addCell("���").
  oTable:addCell("����� ���").
  oTable:addCell("����� �� ��").
  oTable:addCell("����� �� ��").
  oTable:addCell("�㬬� ���⥦�� � ���").
  oTable:addCell("���� ���⥦�� � ��� �� �⭮襭�� � ��").
  oTable:addCell("��� ������� ���").

DEF VAR i AS INT NO-UNDO INIT 1.

{exp-path.i &exp-filename = "'pir_ufk4podft.xls'"}
DEF VAR cXL AS CHAR NO-UNDO.
PUT UNFORMATTED XLHead("dop", "CCCCNNNND", "50,250,80,180,120,120,120,100,74").

cXL = XLCell("�⤥� �����: ����� �� ���⥦�� �����⮢ � ��� (��ࠢ����� ����ࠫ쭮�� �����祩�⢠) �� ��ਮ� � " +
		STRING(beg-date, "99/99/99") + " �� " + STRING(end-date, "99/99/99")
	).

PUT UNFORMATTED XLRow(0) cXL XLRowEnd() .

cXL = 
    XLCell("�/�")
  + XLCell("������������ ������")
  + XLCell("���")
  + XLCell("����� ���")
  + XLCell("����� �� ��")
  + XLCell("����� �� ��")
  + XLCell("�㬬� ���⥦�� � ���")
  + XLCell("���� ���⥦�� � ��� �� �⭮襭�� � ��")
  + XLCell("��� ������� ���")
.
PUT UNFORMATTED XLRow(0) cXL XLRowEnd() .

FOR EACH tmprecid
  , FIRST cust-corp
      WHERE RECID(cust-corp) = tmprecid.id
      NO-LOCK
  , EACH acct
      WHERE acct.cust-id  = cust-corp.cust-id
	AND acct.cust-cat = "�"
	AND CAN-DO(V_CUST_CORP_ACCTS, acct.acct)
	AND acct.currency = ""
      NO-LOCK 
	BREAK BY acct.cust-id :

   RUN acct-pos IN h_base(acct.acct, acct.currency, beg-date, end-date, "�").

   DEF VAR vAmt2UFK AS DEC NO-UNDO.
   vAmt2UFK = 0.
   FOR EACH op-entry
     WHERE op-entry.op-date >= beg-date
       AND op-entry.op-date <= end-date
       AND op-entry.acct-db = acct.acct
     NO-LOCK
     , FIRST op OF op-entry
         WHERE CAN-DO(V_UFK_ACCTS, op.ben-acct)
         NO-LOCK :
     vAmt2UFK = vAmt2UFK + op-entry.amt-rub.
   END.

   DEF VAR vAmt2UFKpart AS DEC NO-UNDO.
   vAmt2UFKpart = IF sh-db <> 0
			THEN vAmt2UFK / sh-db * 100
			ELSE 0.0.
/*
   oTable:AddROW().
   oTable:addCell(STRING(i, ">>>>9")).
   oTable:addCell(cust-corp.name-corp).	/* ������������ ������ */
   oTable:addCell(cust-corp.inn).	/* ��� */
   oTable:addCell(acct.acct).		/* ����� ��� */
   oTable:addCell(STRING(sh-db        , ">>>,>>>>,>>>,>>9.99")). /* ����� �� �� */
   oTable:addCell(STRING(sh-cr        , ">>>,>>>>,>>>,>>9.99")). /* ����� �� �� */
   oTable:addCell(STRING(vAmt2UFK     , ">>>,>>>>,>>>,>>9.99")). /* �㬬� ���⥦�� � ��� */
   oTable:addCell(STRING(vAmt2UFKpart , ">>>,>>>>,>>>,>>9.99")). /* ���� ���⥦�� � ��� �� �⭮襭�� � �� */
   oTable:addCell(acct.close-date).
*/

  cXL = 
     XLCell(STRING(i, ">>>>9"))
   + XLCell(cust-corp.name-corp)	/* ������������ ������ */
   + XLCell(cust-corp.inn) 		/* ��� */
   + XLCell(acct.acct) 			/* ����� ��� */
   + XLNumCell(sh-db        )  		/* ����� �� �� */
   + XLNumCell(sh-cr        )  		/* ����� �� �� */
   + XLNumCell(vAmt2UFK     )  		/* �㬬� ���⥦�� � ��� */
   + XLNumCell(vAmt2UFKpart )  		/* ���� ���⥦�� � ��� �� �⭮襭�� � �� */
   + XLDateCell(acct.close-date)
  .
  PUT UNFORMATTED XLRow(0) cXL XLRowEnd() .
  i = i + 1.
  ACCUMULATE
	acct.cust-id 	(COUNT BY acct.cust-id)
	sh-db		(TOTAL BY acct.cust-id)
	sh-cr		(TOTAL BY acct.cust-id)
	vAmt2UFK	(TOTAL BY acct.cust-id)
  .
  IF LAST-OF(acct.cust-id ) AND (ACCUM COUNT BY acct.cust-id acct.cust-id) > 1 THEN DO:
    vAmt2UFKpart = IF (ACCUM TOTAL BY acct.cust-id sh-db) <> 0
			THEN (ACCUM TOTAL BY acct.cust-id vAmt2UFK) / (ACCUM TOTAL BY acct.cust-id sh-db) * 100
			ELSE 0.0.
    cXL = 
       XLCell("�����")
     + XLCell(cust-corp.name-corp)	/* ������������ ������ */
     + XLCell(cust-corp.inn) 		/* ��� */
     + XLCell("") 			/* ����� ��� */
     + XLNumCell(ACCUM TOTAL BY acct.cust-id sh-db        )  	/* ����� �� �� */
     + XLNumCell(ACCUM TOTAL BY acct.cust-id sh-cr        )  	/* ����� �� �� */
     + XLNumCell(ACCUM TOTAL BY acct.cust-id vAmt2UFK     )  	/* �㬬� ���⥦�� � ��� */
     + XLNumCell(vAmt2UFKpart )  	/* ���� ���⥦�� � ��� �� �⭮襭�� � �� */
     + XLCell("")
    .
    PUT UNFORMATTED XLRow(0) cXL XLRowEnd() .
  END.
END.

/*
{setdest.i}

PUT UNFORMATTED "�⤥� �����: ����� �� ���⥦�� �����⮢ � ��� (��ࠢ����� ����ࠫ쭮�� �����祩�⢠) �� ��ਮ� � "
		STRING(beg-date, "99/99/99") " �� " STRING(end-date, "99/99/99") 
  SKIP.

oTable:show().

{preview.i}
*/
/* oTable:Save-To("1.csv"). */

PUT UNFORMATTED XLEnd().

DELETE OBJECT oTable.
