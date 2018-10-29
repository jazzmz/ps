/* ------------------------------------------------------
     File: $RCSfile: pirloanrep5.p,v $ $Revision: 1.5 $ $Date: 2010-10-06 13:52:25 $
     Copyright: ООО КБ "Пpоминвестрасчет"
     Базируется: 
     Причина: прошение от 15.01.2008 13:13:19
     Что делает: Генерирует отчет о состоянии ссудной задолженности
     Как работает: 
     Параметры: 
     Место запуска: Броузер кредитных договоров
     Автор: $Author: borisov $ 
     Изменения: $Log: not supported by cvs2svn $
     Изменения: Revision 1.2  2008/11/18 08:16:41  ermilov
     Изменения: *** empty log message ***
     Изменения:
     Изменения: Revision 1.1  2008/01/15 10:19:46  Buryagin
     Изменения: no message
     Изменения:
------------------------------------------------------ */

{globals.i}
{ulib.i}
{intrface.get instrum}
{intrface.get loan}
{pir-gp.i}

DEF VAR cMAcct1 AS CHAR NO-UNDO.
DEF VAR cMAcct2 AS CHAR NO-UNDO.
DEF VAR i       AS INTEGER INIT 1 NO-UNDO.
DEF VAR CtrlSum AS DECIMAL NO-UNDO.
DEF VAR cCSumM  AS CHAR INIT "2,6,10,15,16,17,19,20,21,23,24,25,28,33,38,43,44,45" NO-UNDO.
DEF VAR cCSumP  AS CHAR INIT "47,48,49,51,52,53,55,56,57"        NO-UNDO.
DEF VAR oOtchet AS TTpl NO-UNDO.
DEF VAR oTZdl   AS TTable NO-UNDO.
DEF VAR nPar    AS DECIMAL NO-UNDO.
DEF VAR nS      AS DECIMAL INIT 0 NO-UNDO.
DEF VAR nPr     AS DECIMAL NO-UNDO.
DEF VAR nPrPl   AS DECIMAL NO-UNDO.
DEFINE VARIABLE cStb1 AS CHARACTER EXTENT 70 INIT [
   /*  1 */ "ЗАДОЛЖЕННОСТЬ",
   /*  2 */ "Итого (рубли)",
   /*  3 */ "   в т.ч.юр.лица :",
   /*  4 */ "         физ.лица:",
   /*  5 */ "",
   /*  6 */ "Итого (долл.США)",
   /*  7 */ "   в т.ч.юр.лица :",
   /*  8 */ "         физ.лица:",
   /*  9 */ "",
   /* 10 */ "Итого (евро)",
   /* 11 */ "   в т.ч.юр.лица :",
   /* 12 */ "         физ.лица:",
   /* 13 */ "──────────────────────",
   /* 14 */ "ОСТАТКИ БАЛАНС",
   /* 15 */ "Просроч.задолженность",
   /* 16 */ "   (счета 458*)",
   /* 17 */ "",
   /* 18 */ "",
   /* 19 */ "Просроченные %%",
   /* 20 */ "   (счета 459*)",
   /* 21 */ "",
   /* 22 */ "",
   /* 23 */ "Наращенные %%",
   /* 24 */ "   (счета 47427*)",
   /* 25 */ "",
   /* 26 */ "──────────────────────",
   /* 27 */ "ВНЕБАЛАНС",
   /* 28 */ "Итого (рубли)",
   /* 29 */ "   в т.ч.91316 :",
   /* 30 */ "         91317 :",
   /* 31 */ "         91315 :",
   /* 32 */ "",
   /* 33 */ "Итого (долл.США)",
   /* 34 */ "   в т.ч.91316 :",
   /* 35 */ "         91317 :",
   /* 36 */ "         91315 :",
   /* 37 */ "",
   /* 38 */ "Итого (евро)",
   /* 39 */ "   в т.ч.91316 :",
   /* 40 */ "         91317 :",
   /* 41 */ "         91315 :",
   /* 42 */ "",
   /* 43 */ "   91604",
   /* 44 */ "",
   /* 45 */ "",
   /* 46 */ "",
   /* 47 */ "   91414",
   /* 48 */ "",
   /* 49 */ "",
   /* 50 */ "",
   /* 51 */ "   91312",
   /* 52 */ "",
   /* 53 */ "",
   /* 54 */ "",
   /* 55 */ "   91311",
   /* 56 */ "",
   /* 57 */ "",
   /* 58 */ "──────────────────────",
   /* 59 */ "РЕЗЕРВЫ",
   /* 60 */ "1)По ссудной задолж.",
   /* 61 */ "",
   /* 62 */ "2)По счетам 47425",
   /* 63 */ "  в т.ч.линии+гарантии",
   /* 64 */ "        наращенные %%",
   /* 65 */ "        прочее",
   /* 66 */ "",
   /* 67 */ "3)По просроченным %%",
   /* 68 */ "",
   /* 69 */ "КОНТРОЛЬНАЯ СУММА:"]
NO-UNDO.
DEFINE VARIABLE cStb3 AS CHARACTER EXTENT 70 INIT [
   /*  1 */ "",
   /*  2 */ "(810)",
   /*  3 */ "(810)",
   /*  4 */ "(810)",
   /*  5 */ "",
   /*  6 */ "(840)",
   /*  7 */ "",
   /*  8 */ "",
   /*  9 */ "",
   /* 10 */ "(978)",
   /* 11 */ "",
   /* 12 */ "",
   /* 13 */ "",
   /* 14 */ "",
   /* 15 */ "(810)",
   /* 16 */ "(840)",
   /* 17 */ "(978)",
   /* 18 */ "",
   /* 19 */ "(810)",
   /* 20 */ "(840)",
   /* 21 */ "(978)",
   /* 22 */ "",
   /* 23 */ "(810)",
   /* 24 */ "(840)",
   /* 25 */ "(978)",
   /* 26 */ "",
   /* 27 */ "",
   /* 28 */ "(810)",
   /* 29 */ "",
   /* 30 */ "",
   /* 31 */ "",
   /* 32 */ "",
   /* 33 */ "(840)",
   /* 34 */ "",
   /* 35 */ "",
   /* 36 */ "",
   /* 37 */ "",
   /* 38 */ "(978)",
   /* 39 */ "",
   /* 40 */ "",
   /* 41 */ "",
   /* 42 */ "",
   /* 43 */ "(810)",
   /* 44 */ "(840)",
   /* 45 */ "(978)",
   /* 46 */ "",
   /* 47 */ "(810)",
   /* 48 */ "(840)",
   /* 49 */ "(978)",
   /* 50 */ "",
   /* 51 */ "(810)",
   /* 52 */ "(840)",
   /* 53 */ "(978)",
   /* 54 */ "",
   /* 55 */ "(810)",
   /* 56 */ "(840)",
   /* 57 */ "(978)",
   /* 58 */ "",
   /* 59 */ "",
   /* 60 */ "(810)",
   /* 61 */ "",
   /* 62 */ "(810)",
   /* 63 */ "(810)",
   /* 64 */ "(810)",
   /* 65 */ "",
   /* 66 */ "",
   /* 67 */ "(810)",
   /* 68 */ "",
   /* 69 */ ""]
NO-UNDO.
DEFINE VARIABLE cStb2 AS DECIMAL EXTENT 70 INIT ? NO-UNDO.
DEFINE VARIABLE cStb4 AS DECIMAL EXTENT 70 INIT ? NO-UNDO.

DEF VAR cClassCode      AS CHARACTER NO-UNDO.
DEF VAR pkClassCodeMask AS CHARACTER NO-UNDO.
DEF VAR oSysClass       AS TSysClass NO-UNDO.

DEF VAR rLine     AS DECIMAL NO-UNDO.
DEF VAR rGoodDebt AS DECIMAL NO-UNDO.
DEF VAR rBadDebt  AS DECIMAL NO-UNDO.
DEF VAR rGPr      AS DECIMAL NO-UNDO.
DEF VAR rBPr      AS DECIMAL NO-UNDO.

/*************************************
 * По заявке #835                    *
 * Исправлены классы ПК              *
 * учитываемых при расчете остатка.  *
 *************************************/
oSysClass = new TSysClass().
cClassCode      = ENTRY(1,oSysClass:getSetting("ОверКлассТранз","КлОхватТранш"),"|").
pkClassCodeMask = ENTRY(2,oSysClass:getSetting("ОверКлассТранз","КлОхватТранш"),"|").
DELETE OBJECT oSysClass.

/*************************************
 * По заявке #835                    *
 * Считаем состояние договоров ПК    *
 * по резервам.                      *
 *************************************/

FOR EACH loan WHERE loan.contract = "Кредит" AND CAN-DO(cClassCode + "," + pkClassCodeMask,loan.class-code)
                AND loan.open-date <= end-date
	        AND (loan.close-date >= end-date OR loan.close-date = ?) NO-LOCK:
	fillState(BUFFER loan:HANDLE,"88,21,46,350,351",end-date).	
END.

FOR EACH tblReserv BREAK BY param1:
   ACCUMULATE value1 (TOTAL BY param1).

   IF LAST-OF(param1) THEN DO:

       CASE param1:
            WHEN 88 THEN DO:
		 rLine = ACCUM TOTAL BY param1 value1.
	    END.
	    WHEN 21 THEN DO:
		 rGoodDebt = ACCUM TOTAL BY param1 value1.
	    END.
	    WHEN 46 THEN DO:
		 rBadDebt = ACCUM TOTAL BY param1 value1.
	    END.
	    WHEN 350 THEN DO:
		 rGPr = ACCUM TOTAL BY param1 value1.
	    END.
	    WHEN 351 THEN DO:
		 rBPr = ACCUM TOTAL BY param1 value1.
	    END.
       END CASE.	 

   END.

END.




{getdate.i}
{setdest.i}

/** Вычисление суммы отстатков счетов, удоволетворяющих маске и валюте */
FUNCTION getAcctPosSumBy RETURNS DECIMAL
   (INPUT inAcctMask  AS CHAR,
    INPUT inCurrMask  AS CHAR,
    INPUT inSideMask  AS CHAR,
    INPUT inDate      AS DATE).

   /** Выборка */
   FOR EACH acct
      WHERE (acct.open-date LE inDate)
        AND ((acct.close-date GE inDate)
          OR (acct.close-date EQ ?))
        AND CAN-DO(inAcctMask, acct.acct)
        AND CAN-DO(inCurrMask, acct.currency)
        AND CAN-DO(inSideMask, acct.side)
      NO-LOCK:

      ACCUM GetAcctPosValue_UAL(acct.acct, acct.currency, inDate, false) (TOTAL).
   END.

   RETURN ACCUM TOTAL GetAcctPosValue_UAL(acct.acct, acct.currency, inDate, false).
END FUNCTION.

/**                         */
FUNCTION getLoanAcctPosSumBy RETURNS DECIMAL
   (INPUT inAcctMask      AS CHAR,
    INPUT inCurr          AS CHAR,
    INPUT inAccttypeMask  AS CHAR,
    INPUT inLoanClassMask AS CHAR,
    INPUT inDate          AS DATE).

   /* Детализация расчета 
   PUT UNFORMATTED inAcctMask "," inCurr "," inAccttypeMask "," inLoanClassMask SKIP.
   */

   FOR EACH acct
      WHERE CAN-DO(inAcctMask, acct.acct)
        AND (acct.currency EQ inCurr)
      NO-LOCK,
      LAST loan-acct OF acct
         WHERE CAN-DO(inAccttypeMask,loan-acct.acct-type)
           AND loan-acct.contract EQ 'Кредит'
         NO-LOCK,
      FIRST loan OF loan-acct
         NO-LOCK
      BREAK BY acct.acct:

      IF CAN-DO(inLoanClassMask, loan.class-code)
      THEN DO:
         /* Детализация расчета 
         PUT UNFORMATTED
            loan-acct.acct "    " loan.cont-code "    "
            GetAcctPosValue_UAL(acct.acct, inCurr, inDate, false)
            SKIP.
         */
         ACCUM GetAcctPosValue_UAL(acct.acct, inCurr, inDate, false) (TOTAL).
      END.
   END.

   /* Детализация расчета
   PUT UNFORMATTED
      "                    " "    "
      ACCUM TOTAL GetAcctPosValue_UAL(loan-acct.acct, inCurr, inDate, false)
      SKIP(1).
   */
   RETURN ACCUM TOTAL GetAcctPosValue_UAL(acct.acct, inCurr, inDate, false).
END FUNCTION.

cMAcct1 = "!440*,!459*,44*,45*,46*,478*".
cMAcct2 = "91316*,91317*,91315*".

/************************   main ****************************************/
ASSIGN
/*  2 */ cStb2[2]  = getAcctPosSumBy("!440*,!459*,44*,45*,46*,478*", "", "А", end-date)
/*  3 */ cStb2[3]  = getAcctPosSumBy("!440*,!455*,!457*,!45815*,!45817*,!459*,44*,45*,46*,478*",    "", "А", end-date)
/*  4 */ cStb2[4]  = getAcctPosSumBy("455*,457*,45815*,45817*",                          "", "А", end-date)
         cStb4[4]  = getAcctPosSumBy("45510*,45509*,45708*,45815*050....,45817*050....", "", "А", end-date)
/*  6 */ cStb2[6]  = getAcctPosSumBy("!440*,!459*,44*,45*,46*,478*", "840", "А", end-date)
/*  7 */ cStb2[7]  = getAcctPosSumBy("!440*,!455*,!457*,!45815*,!45817*,!459*,44*,45*,46*,478*", "840", "А", end-date)
/*  8 */ cStb2[8]  = getAcctPosSumBy("455*,457*,45815*,45817*",                          "840", "А", end-date)
         cStb4[8]  = getAcctPosSumBy("45510*,45509*,45708*,45815*050....,45817*050....", "840", "А", end-date)
/* 10 */ cStb2[10] = getAcctPosSumBy("!440*,!459*,44*,45*,46*,478*", "978", "А", end-date)
/* 11 */ cStb2[11] = getAcctPosSumBy("!440*,!455*,!457*,!45815*,!45817*,!459*,44*,45*,46*,478*", "978", "А", end-date)
/* 12 */ cStb2[12] = getAcctPosSumBy("455*,457*,45815*,45817*",                          "978", "А", end-date)
         cStb4[12] = getAcctPosSumBy("45510*,45509*,45708*,45815*050....,45817*050....", "978", "А", end-date)
/* 15 */ cStb2[15] = ABS(getAcctPosSumBy("458*",           "", "А", end-date))
         cStb4[15] = ABS(getAcctPosSumBy("458*050....",    "", "А", end-date))
/* 16 */ cStb2[16] = ABS(getAcctPosSumBy("458*",        "840", "А", end-date))
         cStb4[16] = ABS(getAcctPosSumBy("458*050....", "840", "А", end-date))
/* 17 */ cStb2[17] = ABS(getAcctPosSumBy("458*",        "978", "А", end-date))
         cStb4[17] = ABS(getAcctPosSumBy("458*050....", "978", "А", end-date))
/* 19 */ cStb2[19] = ABS(getAcctPosSumBy("459*",           "", "А", end-date))
         cStb4[19] = ABS(getAcctPosSumBy("459*050....",    "", "А", end-date))
/* 20 */ cStb2[20] = ABS(getAcctPosSumBy("459*",        "840", "А", end-date))
         cStb4[20] = ABS(getAcctPosSumBy("459*050....", "840", "А", end-date))
/* 21 */ cStb2[21] = ABS(getAcctPosSumBy("459*",        "978", "А", end-date))
         cStb4[21] = ABS(getAcctPosSumBy("459*050....", "978", "А", end-date))
/* 23 */ cStb2[23] = ABS(getAcctPosSumBy("47427*",           "", "*", end-date))
         cStb4[23] = ABS(getAcctPosSumBy("47427*050....",    "", "*", end-date))
/* 24 */ cStb2[24] = ABS(getAcctPosSumBy("47427*",        "840", "*", end-date))
         cStb4[24] = ABS(getAcctPosSumBy("47427*050....", "840", "*", end-date))
/* 25 */ cStb2[25] = ABS(getAcctPosSumBy("47427*",        "978", "*", end-date))
         cStb4[25] = ABS(getAcctPosSumBy("47427*050....", "978", "*", end-date))
/* 28 */ cStb2[28] = ABS(getAcctPosSumBy("91316*,91317*,91315*",    "", "*", end-date))
/* 29 */ cStb2[29] = ABS(getAcctPosSumBy("91316*",                  "", "*", end-date))
/* 30 */ cStb2[30] = ABS(getAcctPosSumBy("91317*",                  "", "*", end-date))
         cStb4[30] = ABS(getAcctPosSumBy("91317*050....",           "", "*", end-date))
/* 31 */ cStb2[31] = ABS(getAcctPosSumBy("91315*",                  "", "*", end-date))
/* 33 */ cStb2[33] = ABS(getAcctPosSumBy("91316*,91317*,91315*", "840", "*", end-date))
/* 34 */ cStb2[34] = ABS(getAcctPosSumBy("91316*",               "840", "*", end-date))
/* 35 */ cStb2[35] = ABS(getAcctPosSumBy("91317*",               "840", "*", end-date))
         cStb4[35] = ABS(getAcctPosSumBy("91317*050....",        "840", "*", end-date))
/* 36 */ cStb2[36] = ABS(getAcctPosSumBy("91315*",               "840", "*", end-date))
/* 38 */ cStb2[38] = ABS(getAcctPosSumBy("91316*,91317*,91315*", "978", "*", end-date))
/* 39 */ cStb2[39] = ABS(getAcctPosSumBy("91316*",               "978", "*", end-date))
/* 40 */ cStb2[40] = ABS(getAcctPosSumBy("91317*",               "978", "*", end-date))
         cStb4[40] = ABS(getAcctPosSumBy("91317*050....",        "978", "*", end-date))
/* 41 */ cStb2[41] = ABS(getAcctPosSumBy("91315*",               "978", "*", end-date))
   NO-ERROR.
ASSIGN
/* 43 */ cStb2[43] = ABS(getAcctPosSumBy("91604*",           "", "*", end-date))
/*       cStb4[43] = ABS(getAcctPosSumBy("91604*050....",    "", "*", end-date)) */
         cStb4[43] = ABS(getLoanAcctPosSumBy("91604*",    "", "*", cClassCode, end-date))
/* 44 */ cStb2[44] = ABS(getAcctPosSumBy("91604*",        "840", "*", end-date))
/*       cStb4[44] = ABS(getAcctPosSumBy("91604*050....", "840", "*", end-date)) */
         cStb4[44] = ABS(getLoanAcctPosSumBy("91604*", "840", "*", cClassCode, end-date))
/* 45 */ cStb2[45] = ABS(getAcctPosSumBy("91604*",        "978", "*", end-date))
/*       cStb4[45] = ABS(getAcctPosSumBy("91604*050....", "978", "*", end-date)) */
         cStb4[45] = ABS(getLoanAcctPosSumBy("91604*", "978", "*", cClassCode, end-date))
/* 47 */ cStb2[47] = ABS(getAcctPosSumBy("91414*",           "", "*", end-date))
/*       cStb4[47] = ABS(getAcctPosSumBy("91414*050....",    "", "*", end-date)) */
         cStb4[47] = ABS(getLoanAcctPosSumBy("91414*",    "", "*", cClassCode, end-date))
/* 48 */ cStb2[48] = ABS(getAcctPosSumBy("91414*",        "840", "*", end-date))
/*       cStb4[48] = ABS(getAcctPosSumBy("91414*050....", "840", "*", end-date)) */
         cStb4[48] = ABS(getLoanAcctPosSumBy("91414*", "840", "*", cClassCode, end-date))
/* 49 */ cStb2[49] = ABS(getAcctPosSumBy("91414*",        "978", "*", end-date))
/*       cStb4[49] = ABS(getAcctPosSumBy("91414*050....", "978", "*", end-date)) */
         cStb4[49] = ABS(getLoanAcctPosSumBy("91414*", "978", "*", cClassCode, end-date))
/* 51 */ cStb2[51] = ABS(getAcctPosSumBy("91312*",           "", "*", end-date))
/*       cStb4[51] = ABS(getAcctPosSumBy(    "91312*050....","", "*", end-date)) */
         cStb4[51] = ABS(getLoanAcctPosSumBy("91312*",    "", "*","*", end-date))
/* 52 */ cStb2[52] = ABS(getAcctPosSumBy("91312*",        "840", "*", end-date))
/*       cStb4[52] = ABS(getAcctPosSumBy("91312*050....", "840", "*", end-date)) */
         cStb4[52] = ABS(getLoanAcctPosSumBy("91312*", "840", "*", cClassCode, end-date))
/* 53 */ cStb2[53] = ABS(getAcctPosSumBy("91312*",        "978", "*", end-date))
/*       cStb4[53] = ABS(getAcctPosSumBy("91312*050....", "978", "*", end-date)) */
         cStb4[53] = ABS(getLoanAcctPosSumBy("91312*", "978", "*", cClassCode, end-date))
/* 55 */ cStb2[55] = ABS(getAcctPosSumBy("91311*",           "", "*", end-date))
/*       cStb4[55] = ABS(getAcctPosSumBy("91311*050....",    "", "*", end-date)) */
         cStb4[55] = ABS(getLoanAcctPosSumBy("91311*",    "", "*", cClassCode, end-date))
/* 56 */ cStb2[56] = ABS(getAcctPosSumBy("91311*",        "840", "*", end-date))
/*       cStb4[56] = ABS(getAcctPosSumBy("91311*050....", "840", "*", end-date)) */
         cStb4[56] = ABS(getLoanAcctPosSumBy("91311*", "840", "*", cClassCode, end-date))
/* 57 */ cStb2[57] = ABS(getAcctPosSumBy("91311*",        "978", "*", end-date))
/*       cStb4[57] = ABS(getAcctPosSumBy("91311*050....", "978", "*", end-date)) */
         cStb4[57] = ABS(getLoanAcctPosSumBy("91311*", "978", "*", cClassCode, end-date))
/* 60 */ cStb2[60] = ABS(getAcctPosSumBy("!440*,!459*,44*,45*,46*,478*",                             "", "П", end-date))
         cStb4[60] = rGoodDebt + rBadDebt

/* 61 */ cStb2[62] = ABS(getAcctPosSumBy("47425*",        "", "*", end-date))
         cStb4[62] = rLine + rGPr

/* 62 */ cStb2[63] = ABS(getLoanAcctPosSumBy("47425*", "", "КредРезВб",              "*", end-date))
         cStb4[63] = rLine

/* 63 */ cStb2[64] = ABS(getLoanAcctPosSumBy("47425*", "", "КредРезП" ,              "*", end-date))
         cStb4[64] = rGPr

/* 64 */ cStb2[65] = cStb2[61] - cStb2[62] - cStb2[63]
         cStb4[65] = cStb4[61] - cStb4[62] - cStb4[63]
/* 65 */ cStb2[67] = ABS(getAcctPosSumBy("45918*", "", "*", end-date))
         cStb4[67] = rBPr
   NO-ERROR.

CtrlSum = 0.
DO i = 1 TO NUM-ENTRIES(cCSumP):
   CtrlSum = CtrlSum + cStb2[INTEGER(ENTRY(i, cCSumP))].
END.
DO i = 1 TO NUM-ENTRIES(cCSumM):
   CtrlSum = CtrlSum - cStb2[INTEGER(ENTRY(i, cCSumM))].
END.

/* 67 */ cStb2[69] = CtrlSum.

/************************  Print ****************************************/
/*
oOtchet = new TTpl("pirloanrep3.tpl"). 
oOtchet:addAnchorValue("DATE1", STRING(end-date, "99.99.9999")).
oOtchet:addAnchorValue("KURS-USD", STRING(FindRateSimple("Учетный", "840", end-date), "99.9999")).
oOtchet:addAnchorValue("KURS-EUR", STRING(FindRateSimple("Учетный", "978", end-date), "99.9999")).

oTZdl   = new TTable(4).

DO i = 1 TO 67:
   oTZdl:addRow().
   oTZdl:addCell(cStb1[i]).
   oTZdl:addCell(IF (cStb2[i] EQ ?) THEN "*" ELSE STRING(cStb2[i], ">>>,>>>,>>>,>>9.99")).
   oTZdl:addCell(cStb3[i]).
   oTZdl:addCell(IF (cStb4[i] EQ ?) THEN "*" ELSE STRING(cStb4[i], ">>>,>>>,>>>,>>9.99")).
END.

oOtchet:addAnchorValue("TABLE-ZDL",oTZdl).
DELETE OBJECT oTZdl.

oOtchet:show().
DELETE OBJECT oOtchet.
=======================
         ОТЧЕТ О СОСТОЯНИИ ССУДНОЙ ЗАДОЛЖЕННОСТИ за #DATE1#
  
курс: #KURS-USD# руб/$
      #KURS-EUR# руб/евро
  
#TABLE-ZDL 
colsHeaderList=",,Вал,в т.ч.пластик" 
colsWidthList=",,," 
colsAlignList="left,right,left,right" 
InnerBorder="no"#
=======================
*/

PUT UNFORMATTED
   "         ОТЧЕТ О СОСТОЯНИИ ССУДНОЙ ЗАДОЛЖЕННОСТИ за " STRING(end-date, "99.99.9999") SKIP(1)
   "курс: " STRING(FindRateSimple("Учетный", "840", end-date), "99.9999") " руб/$" SKIP
   "      " STRING(FindRateSimple("Учетный", "978", end-date), "99.9999") " руб/евро" SKIP(1)
   "                                           Вал       в т.ч.пластик" SKIP
.

DO i = 1 TO 69:

   PUT UNFORMATTED
      cStb1[i] FORMAT "x(23)"
      (IF (cStb2[i] EQ ?) THEN "                   " ELSE STRING(cStb2[i], ">>>,>>>,>>>,>>9.99 "))
      cStb3[i] FORMAT "x(5)"
      (IF (cStb4[i] EQ ?) THEN "                   " ELSE STRING(cStb4[i], " >>>,>>>,>>>,>>9.99"))
      SKIP.

END.

{preview.i}
{intrface.del}
