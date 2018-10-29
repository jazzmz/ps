/*
               Банковская интегрированная система БИСквит
    Copyright: ОАО КБ "ПPОМИНВЕСТРАСЧЕТ"
     Filename: pir-undoucs.p
      Comment: Откат статуса у транзакций ПЦ неудачно обработанных pir-pk0
   Parameters: 
         Uses: Globals.I SetDest.I  Preview.I
      Used by: -
      Created: 20/11/2008 Templar
     Modified:
*/

{globals.i}

DEFINE VAR i	as int  no-undo.
DEFINE VAR pctrans_id	as int  no-undo.
DEFINE VAR ucs_file AS CHAR FORMAT "X(50)" NO-UNDO.
DEFINE VAR iStatus AS CHAR FORMAT "X(3)" NO-UNDO.

/*--------------------------------------- Main ------------------------------------------------------------------*/




MESSAGE "Введите имя файла из ПЦ, например c0198__1.777 " .
MESSAGE "Имя:" UPDATE ucs_file .

MESSAGE "new status:" UPDATE iStatus.

ASSIGN
ucs_file = "/home/bis/quit41d/imp-exp/pcard/in/"+ ucs_file.


{setdest.i}
PUT UNFORMATTED 'ТРАНЗАКЦИИ ЗАГРУЖЕННЫЕ ИЗ ФАЙЛА ПЦ ' ucs_file SKIP(1) .

FOR EACH pc-trans:
	DO:
		pctrans_id = pc-trans.pctr-id.
		IF GetXAttrValue("pc-trans", STRING(pctrans_id), "pir_fromfile") EQ ucs_file  AND  YEAR(pc-trans.cont-date) = YEAR(TODAY)
		THEN
			DO: 
				PUT UNFORMATTED  pc-trans.pctr-status '|' pc-trans.num-card '|' pc-trans.num-equip  '|' pc-trans.cont-date '|' pc-trans.proc-date  SKIP.
				MESSAGE pc-trans.pctr-status '|' pc-trans.num-card '|' pc-trans.num-equip  '|' pc-trans.cont-date '|' pc-trans.proc-date  VIEW-AS ALERT-BOX.
				pc-trans.pctr-status = iStatus. 
			END.					
	END.
END.





PUT UNFORMATTED '!!!! СТАТУСЫ МЕНЯЮТСЯ НА ' iStatus SKIP(1) .

{preview.i}
