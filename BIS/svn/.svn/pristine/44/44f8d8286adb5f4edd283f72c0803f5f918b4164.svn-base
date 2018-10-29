{pirsavelog.p}

/* ---------------------------------------------------------------------
File       : $RCSfile: pir-vip-ex.p,v $ $Revision: 1.4 $ $Date: 2010-04-22 07:18:32 $
Copyright  : ООО КБ "Пpоминвестрасчет"
Function   : Процедура формирования выписки по валютным документам в Excel
Created    : 14.12.2007 kuntash
Modified   : $Log: not supported by cvs2svn $
Modified   : Revision 1.3  2009/09/02 07:29:26  ermilov
Modified   : add NO-LOCK for op-entry
Modified   :
Modified   : Revision 1.2  2007/12/16 09:27:42  kuntash
Modified   : dorabotka dlya Pascalya
Modified   :

Modified   : Revision 1.1  2007/06/07 09:33:21  kuntash
Modified   : 
Modified   :
---------------------------------------------------------------------- */


{globals.i}             /* Глобальные переменные сессии. */
{flt-val.i}    
{tmprecid.def}          /* Таблица отметок. */

{getdate.i}
{wordwrap.def}
{sh-defs.i}
{uxelib.i}

DEF VAR reportXmlCode AS CHAR NO-UNDO.
DEF VAR sheetXmlCode AS CHAR NO-UNDO.
DEF VAR rowsXmlCode AS CHAR NO-UNDO.
DEF VAR cellsXmlCode AS CHAR NO-UNDO.
DEF VAR styleXmlCode AS CHAR NO-UNDO.

DEF VAR fileName  AS CHAR NO-UNDO.
DEF VAR NameShap  AS CHAR NO-UNDO.
DEF VAR NameVhod  AS CHAR NO-UNDO.
DEF VAR NameIshod AS CHAR NO-UNDO.
DEF VAR NameKontr AS CHAR NO-UNDO.
DEF VAR oper      AS CHAR NO-UNDO.
DEF VAR name-cli  AS   CHARACTER  EXTENT    2    NO-UNDO.

DEF BUFFER xacct  FOR acct.


DEF TEMP-TABLE PrOp-entry NO-UNDO
   FIELD doc-date    AS DATE
   FIELD acct        AS CHAR
   FIELD acct-cor    AS CHAR
   FIELD name-kli    AS CHAR
   FIELD summa-db    AS DECIMAL
   FIELD summa-cr    AS DECIMAL
   FIELD details     AS CHAR
   FIELD kontragent  AS CHAR
   FIELD oper        AS CHAR
   FIELD acct-ben    AS CHAR
   FIELD bank-code   AS CHAR
   FIELD bank-name   AS CHAR
   INDEX acct-idx acct doc-date.
.
DEF TEMP-TABLE OtOp-entry NO-UNDO
   FIELD doc-date    AS DATE
   FIELD doc-num     AS CHAR
   FIELD acct        AS CHAR
   FIELD name-kli    AS CHAR
   FIELD amt-rub     AS DECIMAL
   FIELD acct-ben    AS CHAR
   FIELD bank-code   AS CHAR
   FIELD bank-name   AS CHAR
   INDEX acct-idx acct doc-date.
.


FOR EACH TmpRecId,
	FIRST xacct WHERE RECID (xacct) EQ TmpRecId.id,
	EACH op-entry where (op-entry.acct-db eq xacct.acct or
										op-entry.acct-cr eq xacct.acct) and 
										op-entry.op-date eq end-date and
										op-entry.amt-cur ne 0 
										NO-LOCK ,  
	FIRST op where op.op EQ op-entry.op				
	NO-LOCK:

  IF xacct.acct eq op-entry.acct-cr then oper = "cr". else oper ="db".
  name-cli[1]= "".
  IF oper eq "cr" THEN 
  DO: 
     FIND FIRST acct where acct.acct eq op-entry.acct-db and acct.cust-cat ne "В" no-lock no-error.
     IF avail acct then 
     DO:
     {getcust.i &name=name-cli &OFFInn="/*"}
     name-cli[1] = name-cli[1] + " " + name-cli[2].
     END.
  END.
   ELSE
  DO: 
    FIND FIRST acct where acct.acct eq op-entry.acct-cr and acct.cust-cat ne "В" no-lock no-error.
    IF avail acct then
    DO:
    {getcust.i &name=name-cli &OFFInn=""}
    name-cli[1] = name-cli[1] + " " + name-cli[2].
    END.
  END.
				
				NameKontr = "". 
				FOR EACH cust-role WHERE
                   cust-role.file-name  EQ "op"
               AND cust-role.surrogate  EQ STRING(op.op)
               AND (cust-role.class-code EQ "Benef-Cust" or cust-role.class-code EQ "Benef-Inst" or
               			cust-role.class-code EQ "Order-Cust" or cust-role.class-code EQ "Order-Inst"
                   )
        NO-LOCK :        
        IF AVAIL cust-role THEN
					NameKontr = NameKontr + "~n" + cust-role.cust-name
        .
       END.

   CREATE PrOp-entry.
   ASSIGN
      PrOp-entry.doc-date   = op-entry.op-date
      PrOp-entry.acct       = xacct.acct
      PrOp-entry.acct-cor   = if op-entry.acct-cr eq xacct.acct THEN op-entry.acct-db ELSE op-entry.acct-cr
      PrOp-entry.name-kli   = name-cli[1]
      PrOp-entry.kontragent = NameKontr
      PrOp-entry.details    = op.details
      .      
      if op-entry.acct-cr eq xacct.acct THEN PrOp-entry.summa-db   = op-entry.amt-cur.
      if op-entry.acct-db eq xacct.acct THEN PrOp-entry.summa-cr   = op-entry.amt-cur.
 
END.


fileName = "/home/bis/quit41d/imp-exp/users/" + lc(userid) + "/vip_" + string(end-date,"99.99.9999") + ".xml".

OUTPUT TO VALUE(fileName).

				styleXmlCode = CreateExcelStyleEx("title1","Center", "Center", 2,"","B","") +
				               CreateExcelStyleEx("title2","Center","Center", 2,"","B,U","") +
				               CreateExcelStyle("Center", "Center", 2, "title3") +
				               CreateExcelStyle("Left", "Center", 1, "cell1") +
				               CreateExcelStyle("Right", "Center", 1, "cell2")
				               .

				PUT UNFORMATTED CreateExcelWorkbook(styleXmlCode).
				PUT UNFORMATTED CreateExcelWorksheet("Лист1").
				
				PUT UNFORMATTED 
						SetExcelColumnWidth(1, 55) +
						SetExcelColumnWidth(2, 110) + 
						SetExcelColumnWidth(3, 130) +
						SetExcelColumnWidth(4, 65) +
						SetExcelColumnWidth(5, 65) +
						SetExcelColumnWidth(6, 250) +
						SetExcelColumnWidth(7, 100) +
						SetExcelColumnWidth(8, 70) +
						SetExcelColumnWidth(9, 50).
						
FOR EACH 	TmpRecId,
		FIRST acct WHERE RECID (acct) EQ TmpRecId.id:

nameShap = "Выписка по счету " + acct.acct + " " + acct.details + " за " + string(end-date,"99.99.9999").
run acct-pos in h_base (acct.acct,acct.currency, end-date, end-date,gop-status).
NameVhod  = " Входящий остаток: " + string(sh-in-val,"-z,zzz,zzz,zz9.99").
NameIshod = " Исходящий остаток: " + string(sh-val,"-z,zzz,zzz,zz9.99").

PUT UNFORMATTED 
						CreateExcelRow(
							CreateExcelCell("String","", nameShap)
						) +
						CreateExcelRow(
							CreateExcelCell("String", "title1", "Дата") +
							CreateExcelCell("String", "title1", "К/С") +
							CreateExcelCell("String", "title1", "Клиент") +
							CreateExcelCell("String", "title1", "Дт") +
							CreateExcelCell("String", "title1", "Кт") +
							CreateExcelCell("String", "title1", "Содержание операции") +
							CreateExcelCell("String", "title1", "Контрагент") +
							CreateExcelCell("String", "title1", "Содержание по договору") +
							CreateExcelCell("String", "title1", "Чей клиент")).

PUT UNFORMATTED CreateExcelRow(
						CreateExcelCell("String","", NameVhod)).		
						
    FOR EACH 	PrOp-entry where PrOp-entry.acct eq acct.acct by PrOp-entry.summa-db by PrOp-entry.summa-cr :
					PUT UNFORMATTED CreateExcelRow(
						CreateExcelCell("String", "cell1", string(PrOp-entry.doc-date,"99.99.9999")) +
						CreateExcelCell("String", "cell1", PrOp-entry.acct-cor) +
            CreateExcelCell("String", "cell1", PrOp-entry.name-kli) +
            CreateExcelCell("String", "cell2", (if string(PrOp-entry.summa-cr) = "0" then "" else string(PrOp-entry.summa-cr,"-z,zzz,zzz,zz9.99"))) +
            CreateExcelCell("String", "cell2", (if string(PrOp-entry.summa-db) = "0" then "" else string(PrOp-entry.summa-db,"-z,zzz,zzz,zz9.99"))) +
            CreateExcelCell("String", "cell1", PrOp-entry.details) +
						CreateExcelCell("String", "cell1", PrOp-entry.kontragent)
					).
		END.

PUT UNFORMATTED CreateExcelRow(
						CreateExcelCell("String","", NameIshod)).
PUT UNFORMATTED CreateExcelRow(						
						CreateExcelCell("String","", "")).

END.


PUT UNFORMATTED CloseExcelTag("Worksheet").

PUT UNFORMATTED CloseExcelTag("Workbook").
OUTPUT CLOSE.

MESSAGE "Выгружен" + fileName VIEW-AS ALERT-BOX.
