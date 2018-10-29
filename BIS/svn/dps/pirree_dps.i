/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2004 ТОО "Банковские информационные системы"
     Filename: PIRREE_DPS.I
      Comment: Создание временнной таблицы для печати из класса ree_dpspr
   Parameters:
         Uses:
      Used by:
      Created: 24.08.2004 15:18 SAP     
     Modified: 25.08.2004 12:27 SAP      
     Modified: 
*/


DEFINE VARIABLE vTxt  AS CHARACTER  EXTENT 11 NO-UNDO.
DEFINE VARIABLE vVal  AS DECIMAL    EXTENT 2 NO-UNDO.

DEF VAR vSym1 AS CHAR NO-UNDO.
DEF VAR vSym2 AS CHAR NO-UNDO.
DEF VAR vSym3 AS CHAR NO-UNDO.
DEF VAR vSym4 AS CHAR NO-UNDO.
DEFINE VARIABLE vI       AS INTEGER    NO-UNDO.

DEFINE BUFFER bDataLine FOR DataLine.

{pirree_dps.def}

FIND FIRST DataBlock WHERE DataBlock.Data-Id EQ in-data-id.
IF AVAIL DataBlock THEN
DO:
   FOR EACH bDataLine OF DataBlock:
      /*MESSAGE bDataLine.Sym1 VIEW-AS ALERT-BOX.*/
      ASSIGN
         vSym1 = bDataLine.Sym1
         vSym2 = bDataLine.Sym2
         vSym3 = ENTRY(1, bDataLine.Sym3)
         vSym4 = bDataLine.Sym4
         .
      DO vI = 1 TO EXTENT (vVal):
         vVal[vI] = bDataLine.Val[vI].
      END.
      DO vI = 1 TO EXTENT (vTxt):
         vTxt[vI] = ENTRY(vI, bDataLine.Txt, "~n").
      END.

      FIND FIRST ttRee WHERE
         ttRee.SysNum EQ vSym1 /*AND
         ttRee.FIO    EQ vTxt[1]*/ NO-ERROR.
      IF NOT AVAIL ttRee THEN
      DO:
         CREATE ttRee.
         ASSIGN 
            ttRee.FIO = vTxt[1]
            ttRee.SysNum = vSym1 
            ttRee.AdressReq = vTxt[2]
	    ttree.AdressPos = vTxt[11]
            ttRee.DocTypeCod = vTxt[3]
            ttRee.KemVidano = vTxt[5]
            ttRee.Phone = vTxt[8]
            ttRee.DocNum = vTxt[4]
	    ttRee.Email = vTxt[10]
            .
      END.
      CREATE ttReeLoan.
      ASSIGN
         ttReeLoan.SysNum = ttRee.SysNum
         ttReeLoan.SumInCurr = vVal[1]
         ttReeLoan.SumInRur = vVal[2]
         ttReeLoan.ContDate = vTxt[6]
         ttReeLoan.AcctNum = vTxt[7]
         ttReeLoan.Curr = SUBSTRING(ttReeLoan.AcctNum,6,3)
         ttReeLoan.Symbol = vSym2 
         ttReeLoan.ContNum = /* if vTxt[9] = "" then vSym3 else*/ vTxt[9]
/*	 ttReeLoan.ContPl = vTxt[9] */
         ttReeLoan.BankRegNum = vSym4.

   END.
END.

/*удаление клиентов, у которых нет вкладов, а только кредиты*/
 FOR EACH ttRee:
    IF NOT CAN-FIND(FIRST ttReeLoan WHERE ttReeLoan.Symbol = "д" AND
                                          ttReeLoan.SysNum = ttRee.SysNum) THEN
    DO:
        FOR EACH ttReeLoan WHERE ttReeLoan.SysNum = ttRee.SysNum:
            DELETE ttReeLoan.
        END.
        DELETE ttRee. 
    END.
END.

/*перенумерация записей*/
vI = 1.
FOR EACH ttRee BY FIO:
   ASSIGN ttRee.id = vI. 
   vI = vI + 1.
END.



