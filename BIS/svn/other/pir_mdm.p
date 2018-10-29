{pirsavelog.p}
/*
                Банковская интегрированная система БИСквит
    Copyright: (C) 1992-1996 ТОО "Банковские информационные системы"
     Filename: pir-mdm.p
      Comment: 
               
         Uses:
      Used BY:
       Edited: 07/05/2010 Borisov
*/
/******************************************************************************/
/*
DEFINE INPUT PARAMETER ipDataID  AS INTEGER NO-UNDO.
*/
{globals.i}
{getdates.i}
{setdest.i}

DEFINE VARIABLE i   AS INTEGER NO-UNDO.
DEFINE BUFFER Data1 FOR DataLine.
DEFINE BUFFER Data2 FOR DataLine.

PUT UNFORMATTED
   "    Период      Параметр      МДМ-банк       Моск.филиал             Сумма"    SKIP
   "-----------------------------------------------------------------------------" SKIP
.

FOR EACH DataBlock
   WHERE DataBlock.DataClass-Id EQ "i1db_all"
     AND DataBlock.Beg-Date     GE beg-date
     AND DataBlock.End-Date     LE end-date
   NO-LOCK,
      /* MDM */
   FIRST Data1
      WHERE Data1.Data-ID EQ DataBlock.Data-Id
        AND Data1.Sym1    EQ "000011082"
        AND Data1.Sym2    EQ "000011082"
      EXCLUSIVE-LOCK,
      /* Filial */
   FIRST Data2
      WHERE Data2.Data-ID EQ DataBlock.Data-Id
        AND Data2.Sym1    EQ "000013452"
        AND Data2.Sym2    EQ "000013452"
      EXCLUSIVE-LOCK:

   DO i = 1 TO 12:
      IF (Data2.Val[i] NE 0)
      THEN DO:
         PUT UNFORMATTED
            STRING(DataBlock.Beg-Date)
            IF (DataBlock.End-Date NE DataBlock.Beg-Date)
               THEN (" - " + STRING(DataBlock.End-Date))
               ELSE "           "
            i FORMAT ">>>9"
            Data1.Val[i]                 FORMAT ">>>,>>>,>>>,>>9.99"
            Data2.Val[i]                 FORMAT ">>>,>>>,>>>,>>9.99"
           (Data1.Val[i] + Data2.Val[i]) FORMAT ">>>,>>>,>>>,>>9.99"
            SKIP.

         Data1.Val[i] = Data1.Val[i] + Data2.Val[i].
         Data2.Val[i] = 0.
      END.
   END.
END.

{preview.i}
