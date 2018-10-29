/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2009 ЗАО "Банковские информационные системы"
     Filename: dacct-cr.p
      Comment: <comment>
   Parameters:
         Uses:
      Used by:
      Created: 07.09.2009 MUTA 0108264 Открытие парных счетов
     Modified: 

*/
{globals.i}
{intrface.get tmess}   
{intrface.get xclass}  
{intrface.get acct} 

DEFINE INPUT PARAMETER surr-acct AS CHARACTER NO-UNDO.

DEFINE VARIABLE vbal-acct   AS CHARACTER NO-UNDO.
DEFINE VARIABLE vAcct       AS CHARACTER NO-UNDO.
DEFINE VARIABLE vAcctMask   AS CHARACTER NO-UNDO.
DEFINE VARIABLE vKodDoxRash AS CHARACTER NO-UNDO.
DEFINE VARIABLE vItem       AS INT64   NO-UNDO.

DEFINE BUFFER bAcct FOR Acct.
DEFINE BUFFER dAcct FOR Acct.

FIND FIRST bAcct WHERE bAcct.acct EQ ENTRY(1,surr-acct)
                   AND bAcct.currency EQ ENTRY(2,surr-acct) NO-LOCK.
IF NOT AVAIL(bAcct) THEN RETURN.   

IF {assigned bacct.contr-acct} THEN RETURN "Ok".

FIND FIRST CODE WHERE code.class = "Dual-bal-acct" AND 
          (CODE.code EQ STRING(bacct.bal-acct) OR
           CODE.val  EQ STRING(bacct.bal-acct)) NO-LOCK NO-ERROR.

IF AVAIL(CODE) THEN vBal-acct = (IF code.code EQ STRING(bacct.bal-acct) THEN code.val ELSE code.code).

IF {assigned vBal-acct} THEN DO:

   RUN Fill-SysMes("","acct45","", "%s=" + DelFilFromAcct(bAcct.acct)).

   IF pick-value NE "yes" THEN RETURN "Ok".

TR:
   DO ON ERROR  UNDO TR, LEAVE TR
      ON ENDKEY UNDO TR, LEAVE TR:

      RUN FindAcctMask IN h_acct (INPUT        bacct.class-code,
                                  INPUT        vBal-Acct,
                                  INPUT-OUTPUT vAcctMask,
                                  INPUT-OUTPUT vKodDoxRash).
/*
      DO vItem = 1 TO LENGTH(vAcctmask):

         IF SUBSTRING(vacctmask, vItem, 1) EQ "с" THEN
         DO:
            vacctmask = (IF vItem GT 1 THEN SUBSTRING(vacctmask, 1, vItem - 1)
                                    ELSE "")
                    + SUBSTRING(TRIM(delFilFromAcct(bacct.acct)), vItem, 1)
                    + (IF vItem LT LENGTH(vacctmask) THEN SUBSTRING(vacctmask, vItem + 1)
                                                  ELSE "").
            
         END.
      END. 
*/      
      vAcctMask = REPLACE(vAcctMask, "б[1-5]", "ббббб").
      vAcctMask = SUBSTRING(vAcctMask, 1, INDEX(vAcctMask, "к") - 1) + "к" + SUBSTRING(TRIM(delFilFromAcct(bacct.acct)), INDEX(vAcctMask, "к") + 1).
      RUN Cm_acct_cr IN h_acct (
             bAcct.class-code,        /* iClass                  */  
             vbal-acct,               /* iBal                    */  
             bAcct.currency,          /* iCurr                   */  
             bAcct.cust-cat,          /* iCustCat                */  
             bAcct.cust-id,           /* iCustID                 */  
             bacct.open-date,         /* iOpenDate               */  
             OUTPUT vAcct,            /* oAcct                   */  
             BUFFER dacct,            /* BUFFER iacct FOR acct   */  
             vAcctMask,               /* iAcctMask               */  
             bAcct.details,           /* iDetails                */  
             bacct.kau-id,            /* iKauId                  */  
             bacct.contract,          /* iContract               */  
             bAcct.USER-ID,           /* iUserId                 */  
             (IF LOGICAL( FGetSetting("PirDualAcct", "MaskBranch", "NO") )  AND  CAN-DO( FGetSetting("PirDualAcct", "MaskBranchLA", "NO"), bacct.acct ) THEN SUBSTRING(bacct.acct,10,4) ELSE bAcct.branch-id) ,    /* iBranchId               */  
             YES                      /* iCopyBalXattr           */  
      ) NO-ERROR. 
 
      IF ERROR-STATUS:ERROR OR vAcct = ? THEN DO:

         RUN Fill-SysMes IN h_tmess ("", "", "0", "Ошибка при создании парного счета." + GetErrMsg()).
         UNDO TR, LEAVE TR.           

      END.
 
      ASSIGN
        dacct.contr-acct = bacct.acct.
     
      VALIDATE dacct.

      RUN CopySigns (bAcct.class-code,bAcct.acct + "," + bAcct.currency,
                     dAcct.class-code,dAcct.acct + "," + dAcct.currency).

      FIND FIRST bal-acct WHERE bal-acct.acct-cat EQ dacct.acct-cat
                            AND bal-acct.bal-acct EQ dacct.bal-acct
      NO-LOCK NO-ERROR.
      IF AVAIL(bal-acct) THEN 
         dacct.contract = bal-acct.contract.
      ELSE
         dacct.details = "".
     
      IF GetSysConf("ДатаСообщЛС") EQ "YES" THEN DO:

         UpdateSigns("acct",
                     bAcct.acct + "," + bAcct.currency,
                     "ДатаСообщЛС",
                     STRING(bAcct.open-date  + 1),
                     ?).

         UpdateSigns("acct",
                     dAcct.acct + "," + dAcct.currency,
                     "ДатаСообщЛС",
                     STRING(dAcct.open-date  + 1),
                     ?).

      END.

   END.
END.
{intrface.del}

RETURN "Ok".
