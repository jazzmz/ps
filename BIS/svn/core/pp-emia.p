/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2003 ТОО "Банковские информационные системы"
     Filename: PP-EMIA.P
      Comment: Библиотека процедур экспорта (создание и наполнение Транспортных
               форм) поручений для процессинга "МастерБанк"
   Parameters:
   Procedures:
      Used BY:
      Created: 14.03.2006 NIK
     Modified: 24.03.2006 NIK Методы
                              EMASTUndoExport
                              EMASTStatusExport
     Modified: 27.03.2006 NIK Экспорт через "Операции" (op-int)
     Modified: 26.04.2006 NIK Экспорт Изменений Клиента
                              Экспорт Изменений статуса карты
     Modified: 23.08.2006 NIK Контроль ошибок в cust-ident
     Modified: 08.11.2006 NIK 1. Перенос метода изменения статуса поручений
                              2. Перенос метода отмены экспорта
     Modified: 11.12.2006 NIK Перевыпуск Карт
     Modified:
*/
{ghandle.def}
{basefunc.def}
{filial.def}
DEFINE NEW  GLOBAL SHARED VAR auto AS LOGICAL NO-UNDO.

{form.def}
{g-trans.equ}
{card.equ}
{exchange.equ}

DEFINE BUFFER oiCode       FOR Code.
DEFINE VAR mCurrNat        AS CHAR     NO-UNDO.

{intrface.get strng}
{intrface.get xclass}
{intrface.get instrum}

{intrface.get tmess}
{intrface.get pbase}
{intrface.get trans}

{intrface.get exch}
{intrface.get xcard}
{intrface.get ecard}

mCurrNat = FGetSetting("КодНацВал",?,"810").

&GLOB NO-BASE-PROC YES
/*----------------------------------------------------------------------------*/
/* Заполнение данных карты и контракта для поручений IA                       */
/*----------------------------------------------------------------------------*/
PROCEDURE EMasterFill-IA:
   DEFINE INPUT PARAMETER  hCard AS handle NO-UNDO.
   DEFINE PARAMETER BUFFER bPers FOR Person.
   DEFINE PARAMETER BUFFER OpInt FOR Op-Int.
   DEFINE PARAMETER BUFFER bCard FOR Loan.
   DEFINE PARAMETER BUFFER bLoan FOR Loan.
   DEFINE PARAMETER BUFFER bCBnk FOR Code.
   DEFINE PARAMETER BUFFER bProc FOR Code.
  
   DEFINE BUFFER mCard FOR Loan.
   DEFINE BUFFER mloan-cond for loan-cond.

   DEFINE BUFFER bAcct     FOR Loan-Acct.
   DEFINE VAR vFlagSet     AS LOGICAL INIT ? NO-UNDO.
   DEFINE VAR vFlagSkip    AS LOGICAL INIT ? NO-UNDO.

   DEFINE VAR vOpDate      AS DATE     NO-UNDO.
   DEFINE VAR vScheme      AS CHAR     NO-UNDO.
   DEFINE VAR vCAcct       AS CHAR     NO-UNDO.
   DEFINE VAR vMAcct       AS CHAR     NO-UNDO.
   DEFINE VAR vCntrMType   AS CHAR     NO-UNDO.
   DEFINE VAR vBankCode    AS CHAR     NO-UNDO.
   DEFINE VAR vIdent       AS CHAR     NO-UNDO.
   DEFINE VAR vClntCrt     AS LOGICAL  NO-UNDO.
   DEFINE VAR vCntrScheme  AS CHAR     NO-UNDO.
   DEFINE VAR vCntrAScen   AS CHAR     NO-UNDO.
  
   DEFINE VAR vServicPack  AS CHAR     NO-UNDO. 
   DEFINE VAR vMainCard    AS CHAR     NO-UNDO.
	 DEFINE VAR vTarrif      AS CHAR     NO-UNDO.
		
MAIN:
   DO ON ERROR UNDO MAIN, LEAVE MAIN:
      {do-retry.i MAIN}

      ASSIGN
         vOpDate     = hCard:buffer-field("op-date"):buffer-value
      NO-ERROR. {&ON-ERROR}

      IF NOT AVAILABLE(oiCode)            OR
         oiCode.Code NE OpInt.op-int-code THEN
         IF NOT GetCodeBuff("UCSКартОпер",OpInt.op-int-code, BUFFER oiCode) THEN DO:
            RUN Fill-SysMes("","ExchCRD29","",
                            "%s=" + "UCSКартОпер"                 +
                            "%s=" + GetNullStr(OpInt.op-int-code)).
            vFlagSkip = YES.
            LEAVE MAIN.
         END.

      RUN XCARDDefineAcct (INPUT  vOpDate,
                           INPUT  "SCS@" + bLoan.currency,
                           BUFFER bLoan,
                           BUFFER bAcct).
      IF NOT AVAILABLE(bAcct) THEN DO:
         vFlagSkip = YES.
         LEAVE MAIN.
      END.

      vScheme     = GetISOCode(bLoan.Currency).
      vScheme     = "198" + substring(vScheme,1,2) + "1".
      vBankCode   = SUBSTRING(bProc.Val,2,3).

       		vIdent =	CRDGetCustIdent(INPUT  "Ч",
                               INPUT  bPers.Person-ID,
                               INPUT  bLoan.open-date,
                               INPUT  ?,
                               INPUT  bProc.Code,
                               OUTPUT vClntCrt).
      IF NOT {assigned vIdent} THEN UNDO MAIN, RETRY MAIN.
       
    
      CASE oiCode.Misc[4]:
         WHEN "0" THEN ASSIGN                    /* Изменение Клиента         */
            vCAcct      = bAcct.Acct
            vMAcct      = bAcct.Acct
            vCntrScheme = ""
            vCntrAScen  = ""
         .
         WHEN "1"  THEN ASSIGN                    /* Открытие основной         */
            vCAcct      = "PromIn" + bCard.doc-num
            vMAcct      = ""
            vCntrScheme = vScheme WHEN oiCode.Misc[5] EQ "10"
            vCntrAScen  = "Y"     WHEN oiCode.Misc[5] EQ "10"
         .
         WHEN "2" THEN 													/* Открытие дополнительной   */
            DO:
                                          
               FIND FIRST  mCard  WHERE  mCard.contract         eq "card" and
                                         mCard.parent-cont-code eq bLoan.cont-code and
                                         mCard.loan-status      eq "АКТ" and 
                                         mCard.loan-work        eq yes 
                                         no-lock no-error. 
                												 		    
                          
         		ASSIGN                    
            vCAcct      = ""
            vMAcct      = if avail mCard then "PromIn" + mCard.doc-num else "error"
            vCntrScheme = ""
            vCntrAScen  = "N"     WHEN oiCode.Misc[5] EQ "10"
            .
            END.
         WHEN "3" THEN 
           DO:
             IF bCard.loan-work        eq yes THEN
            ASSIGN                    /* Изменение Статуса         */
            vCAcct      = "PromIn" + bCard.doc-num
            vMAcct      = ""
            vCntrScheme = vScheme /* WHEN oiCode.Misc[5] EQ "10" */
            vCntrAScen  = "Y"     /* WHEN oiCode.Misc[5] EQ "10" */
            .
             ELSE
             DO:
                                          
               FIND FIRST  mCard  WHERE  mCard.contract         eq "card" and
                                         mCard.parent-cont-code eq bLoan.cont-code and
                                         mCard.loan-status      eq "АКТ" and 
                                         mCard.loan-work        eq yes 
                                         no-lock no-error. 
                												 		    
                          
         		ASSIGN                    
            vCAcct      = ""
            vMAcct      = if avail mCard then "PromIn" + mCard.doc-num else "error"
            vCntrScheme = ""
            vCntrAScen  = "N"     WHEN oiCode.Misc[5] EQ "02"
            .
            END.
           END.
      END CASE.
      

      FIND LAST mLoan-cond 
		where mloan-cond.contract  = "card-pers" 
		and mloan-cond.cont-code =  bLoan.cont-code  
		and mloan-cond.since LE vOpDate 
      NO-LOCK NO-ERROR.

      IF AVAIL  mLoan-cond THEN    
	vTarrif =  entry(2,mLoan-cond.class-code,"_"). 
      ELSE  vTarrif = "".                 

      CASE vTarrif:
        WHEN "Базовый" THEN
             DO:
              IF substring(bCBnk.Code,4,2) eq "VE" THEN
			        vServicPack  = "198EL1". 
	        ELSE vServicPack  = "198VC1".

	/* #4278 новый сервис-пак для Visa Infinite */
              IF substring(bCBnk.Code,4,2) eq "VI" THEN
			        vServicPack  = "198VI1". 

	     END.
        WHEN "Овер" THEN
             DO:
              IF substring(bCBnk.Code,4,2) eq "VE" THEN
			        vServicPack  = "198EL1". 
	        ELSE vServicPack  = "198VC1".
	     END.
        WHEN "Особый" THEN
             DO:
              IF substring(bCBnk.Code,4,2) eq "VE" THEN
			        vServicPack  = "198EL1". 
	        ELSE vServicPack  = "198VC1".
	     END.
        WHEN "SAFE-BOX" THEN
             DO:
               IF substring(bCBnk.Code,4,2) eq "VE" THEN
			        vServicPack  = "198EL1". 
	        ELSE vServicPack  = "198VC1".
	       END.			       			       		       
	  WHEN "Партнер" THEN
	       DO:
	        IF substring(bCBnk.Code,4,2) eq "VE" THEN
			        vServicPack  = "198EL2".
	        ELSE vServicPack  = "198VC2".
	       END.
	  WHEN "Зарплатный" THEN
	     DO:
	        IF substring(bCBnk.Code,4,2) eq "VE" THEN
			        vServicPack  = "198EL2".
	        ELSE vServicPack  = "198VC2".
	     END.
/** ВРЕМЕННО **/
	  WHEN "Зарплата" THEN
	     DO:
	        IF substring(bCBnk.Code,4,2) eq "VE" THEN
		        vServicPack  = "198EL2".
	        ELSE vServicPack  = "198VC2".
	     END.
	  WHEN "Сотруд" THEN
	     DO:
	        IF substring(bCBnk.Code,4,2) eq "VE" THEN
			        vServicPack  = "198EL2".
	        ELSE vServicPack  = "198VC2".
	     END.
	  WHEN "Корпоратив"  THEN
	       vServicPack  = "198VB1".

     END CASE.  

message 
" Дата = "  vOpDate 
" Тариф = " vTarrif 
" Сервисный пакет" vServicPack 
view-as alert-box.


      ASSIGN
/*-------------------------------------------------- Управление типом файла --*/

/*H11*/  hCard:buffer-field("CntrIType"):buffer-value    = oiCode.Misc[1]
/* 5 */  hCard:buffer-field("CntrMType"):buffer-value    = oiCode.Misc[4]

/*H14*/  hCard:buffer-field("ClntSCheck"):buffer-value   = oiCode.Misc[2]
/* 4 */  hCard:buffer-field("ClntMType"):buffer-value    = (IF oiCode.Misc[3] EQ "1" THEN
                                                               (IF vClntCrt THEN "1"
                                                                            ELSE "0")
                                                            ELSE
                                                               oiCode.Misc[3])
/* 6 */  hCard:buffer-field("CardMType"):buffer-value    = oiCode.Misc[5]

/*---------------------------------------------------------- Данные клиента --*/
/*10*/   hCard:buffer-field("ClntREF"):buffer-value      = "PromIn" + vIdent
/*------------------------------------------------------------ Данные карты --*/
/*39*/   hCard:buffer-field("CardSType"):buffer-value    =  bCard.sec-code 
																														/* vBankCode +
                                                            bCBnk.Misc[1] */

/*40*/   hCard:buffer-field("CardNumber"):buffer-value   =  bCard.doc-num   /* WHEN oiCode.Misc[4] EQ "3" */

/*41*/   hCard:buffer-field("CardAcct"):buffer-value     =  vCAcct
/*42*/   hCard:buffer-field("CardMAcct"):buffer-value    =  vMAcct 

/*51*/   hCard:buffer-field("CardExpire"):buffer-value   =  bCard.end-date  WHEN oiCode.Misc[5] EQ "10" or oiCode.Misc[5] EQ "02"
/*52*/   hCard:buffer-field("CardBName"):buffer-value    =  bCard.user-o[3] WHEN oiCode.Misc[5] EQ "10" or oiCode.Misc[5] EQ "02"
/*53*/   hCard:buffer-field("CardCName"):buffer-value    =  (IF CAN-DO("MIS,MRS,MR",entry(1,bCard.user-o[2]," ")) THEN
																															entry(1,bCard.user-o[2]," ") + "/" +  entry(2,bCard.user-o[2]," ") + "/" +  entry(3,bCard.user-o[2]," ") 
																															ELSE
																															 (IF num-entries(bCard.user-o[2]," ") eq 1 THEN "/" + entry(1,bCard.user-o[2]," ") + "/"
                                                                            ELSE "/" + entry(1,bCard.user-o[2]," ") + "/" + entry(2,bCard.user-o[2]," ")
																															 )
																															) 
																														WHEN oiCode.Misc[5] EQ "10" or oiCode.Misc[5] EQ "02"

/*-------------------------------------------------------- Данные контракта --*/

/* 9*/   hCard:buffer-field("CntrOpen"):buffer-value     =  bCard.Open-Date

/*43*/   hCard:buffer-field("CntrScheme"):buffer-value   =  vCntrScheme

/*44*/   hCard:buffer-field("CntrSPack"):buffer-value    =  vServicPack       WHEN oiCode.Misc[5] EQ "10" or oiCode.Misc[5] EQ "02"

/*45*/   hCard:buffer-field("CntrAScen"):buffer-value    =  vCntrAScen

/*46*/   hCard:buffer-field("CntrCurr"):buffer-value     =  (IF bLoan.Currency EQ ""
                                                                THEN mCurrNat
                                                                ELSE bLoan.Currency)
                                                                              WHEN oiCode.Misc[5] EQ "10" or oiCode.Misc[5] EQ "02"

/*63*/   hCard:buffer-field("CardEvent"):buffer-value    =  (IF bCard.deal-type
                                                                THEN "NCRDF"
                                                                ELSE "")      WHEN oiCode.Misc[5] EQ "10" or oiCode.Misc[5] EQ "02"

/*64*/   hCard:buffer-field("CntrStatus"):buffer-value   =  GetCodeEx("UCSКодБлок",
                                                                      OpInt.par-char[1],
                                                                      "00")   WHEN oiCode.Misc[4] EQ "3" 
      NO-ERROR. {&ON-ERROR}

/*----------------------------------------------- Заполнение данных клиента --*/
      IF oiCode.Misc[4] EQ "5" THEN ASSIGN       /* Клиент не нужен           */
         hCard:buffer-field("ClntSName"):buffer-value    =  CRDGetSName(CRDGet3Name(BUFFER bPers))
      NO-ERROR.
      ELSE                                       /* Клиент нужен              */
         RUN ECARDFillPerson(INPUT  hCard,
                             BUFFER bPers,
                             BUFFER bCard,
                             BUFFER bCBnk,
                             BUFFER bProc) NO-ERROR.
      {&ON-ERROR}

      vFlagSet = YES.
   END.

   IF vFlagSkip THEN DO:
      hCard:buffer-delete().
      hCard:find-first("where __id EQ 0").
      vFlagSet = YES.
   END.

   {doreturn.i vFlagSet}
END PROCEDURE.
/*----------------------------------------------------------------------------*/
/* Заполнение данных карты и контракта для поручений RQ                       */
/*----------------------------------------------------------------------------*/
PROCEDURE EMasterFill-RQ:
   DEFINE INPUT PARAMETER  hCard AS handle NO-UNDO.
   DEFINE PARAMETER BUFFER bPers FOR Person.
   DEFINE PARAMETER BUFFER OpInt FOR Op-Int.
   DEFINE PARAMETER BUFFER bCard FOR Loan.
   DEFINE PARAMETER BUFFER bLoan FOR Loan.
   DEFINE PARAMETER BUFFER bCBnk FOR Code.
   DEFINE PARAMETER BUFFER bProc FOR Code.

   DEFINE BUFFER bCrdBnk   FOR Code.
   DEFINE BUFFER bProcess  FOR Code.
   DEFINE BUFFER bAcct     FOR Loan-Acct.

   DEFINE VAR vFlagSet     AS LOGICAL INIT ? NO-UNDO.
   DEFINE VAR vFlagSkip    AS LOGICAL INIT ? NO-UNDO.
   DEFINE VAR vOpDate      AS DATE           NO-UNDO.

MAIN:
   DO ON ERROR UNDO MAIN, LEAVE MAIN:
      {do-retry.i MAIN}

      ASSIGN
         vOpDate   = hCard:buffer-field("op-date"):buffer-value
      NO-ERROR. {&ON-ERROR}

      RUN XCARDDefineAcct (INPUT  vOpDate,
                           INPUT  "SCS@" + bLoan.currency,
                           BUFFER bLoan,
                           BUFFER bAcct).
      IF NOT AVAILABLE(bAcct) THEN DO:
         vFlagSkip = YES.
         LEAVE MAIN.
      END.

      ASSIGN
         hCard:buffer-field("Urgent"):buffer-value       = NO
/*------------------------------------------------------------ Общие данные --*/
/*08*/   hCard:buffer-field("BrnchOrdr"):buffer-value    = bProc.Val
/*09*/   hCard:buffer-field("BrnchDlvr"):buffer-value    = bProc.Val

/*------------------------------------------------------------ Данные карты --*/

/*37*/   hCard:buffer-field("CardNumber"):buffer-value   =  bCard.doc-num
/*38*/   hCard:buffer-field("CardAcct"):buffer-value     =  bAcct.Acct

/*41*/   hCard:buffer-field("CardExpire"):buffer-value   =  bCard.end-date
/*42*/   hCard:buffer-field("CardBName"):buffer-value    =  bCard.user-o[3]
/*43*/   hCard:buffer-field("CardCName"):buffer-value    =  bCard.user-o[2]

/*36*/   hCard:buffer-field("CardSType"):buffer-value    =  ""

/*-------------------------------------------------------- Данные контракта --*/
/*04*/   hCard:buffer-field("CntrUrgent"):buffer-value   =  (IF bCard.deal-type
                                                                THEN "HIGH"
                                                                ELSE "STD")
/*35*/   hCard:buffer-field("CntrMType"):buffer-value    =  bCBnk.Misc[1]

/*39*/   hCard:buffer-field("CntrSPack"):buffer-value    =  SUBSTRING(bProc.Val,2,3) +
                                                            bCBnk.Code

/*40*/   hCard:buffer-field("CntrCurr"):buffer-value     =  (IF bLoan.Currency EQ ""
                                                                THEN mCurrNat
                                                                ELSE bLoan.Currency)
      NO-ERROR. {&ON-ERROR}

      vFlagSet = YES.
   END.

   IF vFlagSkip THEN DO:
      hCard:buffer-delete().
      hCard:find-first("where __id EQ 0").
      vFlagSet = YES.
   END.

   {doreturn.i vFlagSet}
END PROCEDURE.
/******************************************************************************/
