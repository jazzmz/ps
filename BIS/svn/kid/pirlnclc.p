/*
               Банковская интегрированная система БИСквит
    Copyright: ОАО КБ "ПPОМИНВЕСТРАСЧЕТ"
     Filename: pir-loanclc.p
      Comment: Пересчет договоров (встраиваемая р-шка)
   Parameters: 
         Uses: Globals.I SetDest.I  Preview.I
      Used by: -
      Created: 20/07/2010 Templar
     Modified:
*/

{pirsavelog.p}

/* ************************  Global Definitions  ********************** */
{globals.i}
{tmprecid.def}
{svarloan.def NEW}


/* ************************  Local Definitions  *********************** */

DEFINE BUFFER bLoan FOR loan.
DEFINE VAR iSilent AS LOGICAL INITIAL NO  NO-UNDO.

DEFINE INPUT PARAMETER in-op-date AS DATE  NO-UNDO.
DEFINE INPUT PARAMETER iOpRID     AS RECID NO-UNDO.



/*MESSAGE "Введите дату" UPDATE rdate .*/




/* ***************************  Main Block  *************************** */
MAIN-BLOCK:
DO 
   ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

        EMPTY TEMP-TABLE tmprecid.
        
           FOR EACH bloan WHERE bloan.contract = 'Кредит' 
                AND CAN-DO('l_agr_with_per,loan_trans_ov,l_agr_with_diff,loan_trans_diff',bloan.class-code) 
                AND CAN-DO('ПК*,ДС*',bloan.cont-code)
                AND bloan.close-date = ? 
                AND bloan.since <> in-op-date :  
                DO:			
                        CREATE tmprecid.
                        tmprecid.id = RECID(bloan).                                                
                END.
        
        END.

        IF iSilent THEN      
        RUN SetSysConf IN h_base ("PUT-TO-TMESS","1").

	   RUN NoGarbageCollect IN h_base.
	           RUN "d-lcal(.p" ('Кредит',in-op-date).
	           RUN "sum-in(.p" ('Кредит').
	   RUN GarbageCollect IN h_base.

        IF iSilent THEN   
	RUN DeleteOldDataProtocol IN h_base ("PUT-TO-TMESS").
        
        
END. /* MAIN-BLOCK: */



