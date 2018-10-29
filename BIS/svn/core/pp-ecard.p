/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2003 ТОО "Банковские информационные системы"
     Filename: PP-ECARD.P
      Comment: Библиотека процедур экспорта (создание и наполнение Транспортных
               форм) для модуля Пластиковые карты.
   Parameters:
   Procedures:
      Used BY:
      Created: 08.11.2005 NIK
     Modified: 20.12.2005 NIK Уникальная ссылка документа
     Modified: 21.12.2005 NIK Экспорт изменений лимита по всем картам
     Modified: 14.02.2006 NIK 1. Экспорт Issue application MasterCard
                              2. Экспорт BALANCE MasterCard
     Modified: 12.02.2006 NIK 1. Экспорт RQ-Файлов
     Modified: 22.02.2006 NIK Реструктуризация библиотеки на
                              pp-ecard.p - экспорт
                              pp-xcard.p - процедуры общего назначения
                              pp-scard.p - изменение статусов
     Modified: 10.03.2006 NIK Доработка процедуры EMasterFill-IA
     Modified: 13.03.2006 NIK Присвоение ссылки из "номера строки"
     Modified: 14.03.2006 NIK Реструктуризация по Процессингам
                              pp-ecust.p
                              pp-emlim.p
                              pp-emia.p
     Modified: 24.03.2006 NIK Использование "Операций по картам"
     Modified: 26.04.2006 NIK Экспорт Изменений статуса карты
     Modified: 10.07.2006 NIK Экспорт остатков по СКС
     Modified: 26.07.2006 NIK Контроль связанных данных IA
     Modified: 23.08.2006 NIK Контроль ошибок в cust-ident
     Modified: 08.11.2006 NIK 1. Контроль создания/подтверждения cust-ident
                              2. Перенос метода изменения статуса поручений при экспорте
                              3. Перенос метода отмены экспорта
     Modified: 21.11.2006 NIK Диагностика нумерации cust-ident
     Modified: 26.12.2006 MUTA 0072169  Отключен триггер на проверку записи
                               cust-ident при формировании УНКП.
     Modified:
*/
{globals.i}
{form.def}
{g-trans.equ}
{exchange.equ}
{card.equ}

{intrface.get strng}
{intrface.get xclass}

{intrface.get tmess}
{intrface.get pbase}
{intrface.get trans}
{intrface.get refer}

{intrface.get exch}
{intrface.get pack}
{intrface.get rfrnc}

{intrface.get xpos}
{intrface.get xline}
{intrface.get xcard}
{intrface.get cust}
{intrface.get count}     

{ecard.def}

&GLOB NO-BASE-PROC YES
/*----------------------------------------------------------------------------*/
/* Заполнение экземпляра в наборе транспортных форм передачи остатка СКС      */
/*----------------------------------------------------------------------------*/
PROCEDURE ECARDRestCreate:
   DEFINE INPUT  PARAMETER iClass      AS CHARACTER  NO-UNDO.
   DEFINE INPUT  PARAMETER iInstance   AS HANDLE     NO-UNDO.

   DEFINE BUFFER bCode     FOR Code.
   DEFINE BUFFER bAcct     FOR Acct.
   DEFINE BUFFER bLoan     FOR Loan.
   DEFINE BUFFER bCard     FOR Loan.
   DEFINE BUFFER bLoanAcct FOR Loan-Acct.

   DEFINE VAR vFlagSet     AS LOGICAL  INIT ?   NO-UNDO.
   DEFINE VAR vSkip        AS LOGICAL           NO-UNDO.
   DEFINE VAR vFind        AS LOGICAL           NO-UNDO.
   DEFINE VAR hBal         AS handle            NO-UNDO.

   DEFINE VAR vContract    AS CHAR              NO-UNDO.
   DEFINE VAR vContCode    AS CHAR              NO-UNDO.
   DEFINE VAR vAcctType    AS CHAR              NO-UNDO.
   DEFINE VAR vIdent       AS CHAR              NO-UNDO.
   DEFINE VAR vSince       AS DATE              NO-UNDO.
   DEFINE VAR vDate        AS DATE              NO-UNDO.
   DEFINE VAR vFormat      AS CHAR              NO-UNDO.
   DEFINE VAR vProcFill    AS CHAR              NO-UNDO.
   DEFINE VAR vLoanState   AS CHAR  INIT "*"    NO-UNDO.
   DEFINE VAR vCardState   AS CHAR  INIT "*"    NO-UNDO.

MAIN:
   DO ON ERROR UNDO MAIN, RETRY MAIN:
      {do-retry.i MAIN}

      ASSIGN
         hBal        = iInstance:default-buffer-handle
         vContract   = hBal:buffer-field("Contract"):buffer-value
         vContCode   = hBal:buffer-field("Cont-Code"):buffer-value
         vAcctType   = hBal:buffer-field("Acct-Type"):buffer-value
         vSince      = hBal:buffer-field("Since"):buffer-value

         vDate       = hBal:buffer-field("op-date"):buffer-value
         vFormat     = hBal:buffer-field("mail-format"):buffer-value
         vProcFill   = hBal:buffer-field("ProcFill"):buffer-value
         vLoanState  = hBal:buffer-field("loan-status"):buffer-value
         vCardState  = hBal:buffer-field("card-status"):buffer-value
         vFind       = NO
      NO-ERROR.  {&ON-ERROR}

      IF NOT EXCH-MSGBuff(vFormat, BUFFER bCode) THEN
         UNDO MAIN, RETRY MAIN.

      vIdent = GetNullStr(vContract) + ":" +
               GetNullStr(vContCode) + "-" +
               GetNullStr(vAcctType) + "(" +
               GetNullDat(vSince)    + ")".

ONE-ACC:
      FOR FIRST bLoanAcct WHERE
                bLoanAcct.Contract  EQ vContract
            AND bLoanAcct.Cont-Code EQ vContCode
            AND bLoanAcct.Acct-Type EQ vAcctType
            AND bLoanAcct.Since     EQ vSince
                NO-LOCK,
          FIRST bAcct WHERE
                bAcct.Acct       EQ bLoanAcct.Acct
            AND bAcct.Currency   EQ bLoanAcct.Currency
                NO-LOCK,
          FIRST bLoan WHERE
                bLoan.Contract   EQ bLoanAcct.Contract
            AND bLoan.Cont-Code  EQ bLoanAcct.Cont-Code
                NO-LOCK,
          FIRST bCard WHERE
                bCard.Contract         EQ "card"
            AND bCard.Loan-Work        EQ YES
            AND bCard.Parent-Contract  EQ bLoan.Contract
            AND bCard.Parent-Cont-Code EQ bLoan.Cont-Code
                NO-LOCK
          break BY bAcct.Acct:

         IF bCard.Open-Date   GT vDate                OR
            bCard.Close-Date  NE ?                    OR
            bLoan.open-date   GT vDate                OR
            bLoan.close-date  NE ?                    OR
            NOT CAN-DO(vLoanState,bLoan.loan-status)  OR
            NOT CAN-DO(vCardState,bCard.loan-status)  THEN DO:
            vSkip = YES.
            LEAVE ONE-ACC.
         END.
/*
         IF NOT PacketEnableExhange ("acct",
                                     bAcct.Acct + "," + bAcct.Currency,
                                     ENTRY(1,bCode.Description[1]),
                                     "",
                                     0) THEN DO:
            vSkip = YES.
            LEAVE ONE-ACC.
         END.
*/
         IF bAcct.close-date NE ?     THEN DO:
            RUN Fill-SysMes("","ExchCRD68","","%s=" + vIdent                       +
                                              "%s=" + GetNullStr(bAcct.Acct)       +
                                              "%s=" + GetNullDat(bAcct.close-date)).
            vSkip = YES.
            LEAVE ONE-ACC.
         END.

         IF bAcct.open-date  GT vDate THEN DO:
            RUN Fill-SysMes("","ExchCRD69","","%s=" + vIdent                      +
                                              "%s=" + GetNullStr(bAcct.Acct)      +
                                              "%s=" + GetNullDat(bAcct.open-date) +
                                              "%s=" + GetNullDat(vDate)).
            vSkip = YES.
            LEAVE ONE-ACC.
         END.

         IF first-of(bAcct.Acct) THEN DO:
            IF {assigned vProcFill} THEN DO:
               {exch-run.i
                  &Proc = vProcFill
                  &Parm = "hBal, BUFFER bCode, BUFFER bAcct, BUFFER bLoan, BUFFER bCard"
               }
               {&ON-ERROR}
            END.
            vFind = YES.
         END.
      END.

      IF vFind NE YES THEN DO:
         IF vSkip NE YES THEN
            RUN Fill-SysMes("","ExchCRD70","","%s=" + GetNullStr(vIdent)).
         hBal:buffer-delete().
         hBal:find-first("where __ID EQ 0").
      END.

      vFlagSet = YES.
   END.                                          /* MAIN: DO:                 */

   {doreturn.i vFlagSet}
END PROCEDURE.
/*----------------------------------------------------------------------------*/
/* Заполнение экземпляра в наборе транспортных форм изменения лимита          */
/*----------------------------------------------------------------------------*/
PROCEDURE ECARDLimitCreate:
   DEFINE INPUT  PARAMETER iClass      AS CHARACTER  NO-UNDO.
   DEFINE INPUT  PARAMETER iInstance   AS HANDLE     NO-UNDO.

   DEFINE BUFFER bCode  FOR Code.
   DEFINE BUFFER bLoan  FOR Loan.
   DEFINE BUFFER bCard  FOR Loan.
   DEFINE BUFFER bAcct  FOR Acct.
   DEFINE BUFFER bCorr  FOR Acct.

   DEFINE VAR vFlagSet  AS LOGICAL  INIT ?   NO-UNDO.

   DEFINE VAR hLim         AS handle   NO-UNDO.
   DEFINE VAR hLimKeep     AS handle   NO-UNDO.

   DEFINE VAR vQuery       AS CHAR     NO-UNDO.
   DEFINE VAR hQuery       AS handle   NO-UNDO.
   DEFINE VAR vFlagQry     AS LOGICAL  NO-UNDO.

   DEFINE VAR vDirect      AS CHAR     NO-UNDO.
   DEFINE VAR vOp          AS INTEGER  NO-UNDO.
   DEFINE VAR vOpEntry     AS INTEGER  NO-UNDO.

   DEFINE VAR vFirst       AS LOGICAL        NO-UNDO.

   DEFINE VAR vFormat      AS CHAR           NO-UNDO.
   DEFINE VAR vContract    AS CHAR           NO-UNDO.
   DEFINE VAR vProcFill    AS CHAR           NO-UNDO.

MAIN:
   DO ON ERROR UNDO MAIN, RETRY MAIN:
      {do-retry.i MAIN}

      ASSIGN
         hLim      = iInstance:default-buffer-handle
         vOp       = hLim:buffer-field("op"):buffer-value
         vOpEntry  = hLim:buffer-field("op-entry"):buffer-value
         vDirect   = hLim:buffer-field("Direct"):buffer-value
         vFormat   = hLim:buffer-field("mail-format"):buffer-value
         vContract = hLim:buffer-field("Contract"):buffer-value
         vProcFill = hLim:buffer-field("ProcFill"):buffer-value
      NO-ERROR. {&ON-ERROR}

      IF NOT EXCH-MSGBuff(vFormat, BUFFER bCode) THEN
         UNDO MAIN, RETRY MAIN.

      hLim:buffer-delete().                      /* Увы, но так ...           */
      hLim:find-first("where __id EQ 0").
      CREATE BUFFER hLimKeep FOR TABLE hLim.

      FOR FIRST op-entry WHERE
                op-entry.op       EQ vOp
            AND op-entry.op-entry EQ vOpEntry
                NO-LOCK,
          FIRST op OF op-entry
                NO-LOCK,
          FIRST bAcct WHERE
               (vDirect        EQ "INCREASE"
            AND bAcct.acct     EQ op-entry.acct-cr
            AND bAcct.currency EQ op-entry.currency)
            OR (vDirect        EQ "DECREASE"
            AND bAcct.acct     EQ op-entry.acct-db
            AND bAcct.currency EQ op-entry.currency)
                NO-LOCK,
          FIRST bCorr WHERE
               (vDirect        EQ "DECREASE"
            AND bCorr.acct     EQ op-entry.acct-cr
            AND bCorr.currency EQ op-entry.currency)
            OR (vDirect        EQ "INCREASE"
            AND bCorr.acct     EQ op-entry.acct-db
            AND bCorr.currency EQ op-entry.currency)
                NO-LOCK:

         RUN XCARDDefineLoan(INPUT  op.op-date,
                             INPUT  bAcct.acct,
                             INPUT  bAcct.currency,
                             INPUT  vContract,
                             INPUT  "SCS@" + bAcct.currency,
                             BUFFER bLoan).
         IF NOT AVAILABLE(bLoan) THEN DO:
            vFlagSet = YES.
            LEAVE MAIN.
         END.

         FOR EACH bCard WHERE
                  bCard.Contract         EQ "card"
              AND bCard.Loan-Work        EQ YES
              AND bCard.Parent-Contract  EQ bLoan.Contract
              AND bCard.Parent-Cont-Code EQ bLoan.Cont-Code
              AND bCard.Open-Date        LE op.op-date
              AND bCard.Close-Date       EQ ?
                  NO-LOCK:

            RUN InstanceCreate (hLimKeep, hLim).

            ASSIGN
               hLim:buffer-field("op"):buffer-value         = op-entry.op
               hLim:buffer-field("op-entry"):buffer-value   = op-entry.op-entry
               hLim:buffer-field("Surrogate"):buffer-value  = string(op.op) + "," +
                                                              string(op-entry.op-entry)
            NO-ERROR.

            IF {assigned vProcFill} THEN DO:
               {exch-run.i
                  &Proc = vProcFill
                  &Parm = "hLim, BUFFER bCode, BUFFER op-entry, BUFFER bAcct, BUFFER bCorr, BUFFER bCard"
               }
               {&ON-ERROR}
            END.

            LEAVE.
         END.                                    /* FOR EACH bCard WHERE...   */
      END.                                       /* FOR FIRST op-entry WHERE  */

      hLim:find-first("where __id EQ 0").
      vFlagSet = YES.
   END.                                          /* MAIN: DO:                 */

   IF valid-handle(hLimKeep) THEN DELETE object hLimKeep.

   {doreturn.i vFlagSet}
END PROCEDURE.
/*----------------------------------------------------------------------------*/
/* Зполнение экземпляра транспортной формы поручения на открытие карты        */
/*----------------------------------------------------------------------------*/
PROCEDURE ECARDIssueAppCreate:
   DEFINE INPUT  PARAMETER iClass      AS CHARACTER  NO-UNDO.
   DEFINE INPUT  PARAMETER iInstance   AS HANDLE     NO-UNDO.

   DEFINE VAR vFlagSet  AS LOGICAL INIT ?    NO-UNDO.
   DEFINE VAR vFlagFnd  AS LOGICAL INIT NO   NO-UNDO.

   DEFINE BUFFER bCode     FOR Code.
   DEFINE BUFFER bCrdBnk   FOR Code.
   DEFINE BUFFER bProcess  FOR Code.
   DEFINE BUFFER bCard     FOR Loan.
   DEFINE BUFFER bLoan     FOR Loan.
   DEFINE BUFFER bPers     FOR Person.

   DEFINE VAR hCard     AS handle   NO-UNDO.
   DEFINE VAR vOpIntID  AS INTEGER  NO-UNDO.
   DEFINE VAR vProcFill AS CHAR     NO-UNDO.
   DEFINE VAR vFormat   AS CHAR     NO-UNDO.
   DEFINE VAR vOpDate   AS DATE     NO-UNDO.
   DEFINE VAR vLastRef  AS CHAR     NO-UNDO.
   DEFINE VAR vRefVal   AS INTEGER  NO-UNDO.
   DEFINE VAR vLast     AS INTEGER  NO-UNDO.
   DEFINE VAR vError    AS LOGICAL  NO-UNDO.

MAIN:
   DO ON ERROR UNDO MAIN, LEAVE MAIN:
      {do-retry.i MAIN}

      ASSIGN
         hCard     = iInstance:default-buffer-handle
         vOpIntID  = INTEGER(hCard:buffer-field("op-int-id"):string-value)
         vFormat   = hCard:buffer-field("mail-format"):buffer-value
         vProcFill = hCard:buffer-field("ProcFill"):buffer-value
      NO-ERROR. {&ON-ERROR}

      IF NOT EXCH-MSGBuff(vFormat, BUFFER bCode) THEN
         UNDO MAIN, RETRY MAIN.

      RUN ParsFunc-Дата(OUTPUT vOpDate, OUTPUT vError).

      FOR FIRST op-int WHERE
                op-int.op-int-id EQ vOpIntID
                NO-LOCK,
          FIRST bCard WHERE
                bCard.Contract  EQ ENTRY(1,op-int.surrogate)
            AND bCard.Cont-Code EQ ENTRY(2,op-int.surrogate)
                NO-LOCK,
          FIRST bLoan WHERE
                bLoan.Contract  EQ bCard.parent-contract
            AND bLoan.Cont-Code EQ bCard.parent-cont-code
                NO-LOCK,
          FIRST bPers WHERE
                bPers.person-id EQ bCard.cust-id
                NO-LOCK:

         ASSIGN
            vRefVal = INTEGER(ReferenceGetLast(bCode.Misc[{&RKC-BEGIN}],vOpDate))
            vLast   = hCard:buffer-field("__id"):buffer-value
         NO-ERROR.

         ASSIGN
            vLast                                           =  1 WHEN vLast   EQ 0
            vRefVal                                         =  0 WHEN vRefVal EQ ?
            hCard:buffer-field("SendREF"):buffer-value      =  ReferenceFormatValue(bCode.Misc[{&RKC-BEGIN}],
                                                                                    string(vRefVal + vLast))
            hCard:buffer-field("Urgent"):buffer-value       =  bCard.deal-type
         NO-ERROR. {&ON-ERROR}

         IF NOT GetCodeBuff("КартыБанка", bCard.sec-code,   BUFFER bCrdBnk)  THEN
            UNDO MAIN, RETRY MAIN.

         IF NOT GetCodeBuff("Процессинги",bCrdBnk.Misc[2],  BUFFER bProcess) THEN
            UNDO MAIN, RETRY MAIN.

/*--------------------------- Заполнение специфичных для процессинга данных --*/
         IF {assigned vProcFill} THEN DO:
            {exch-run.i
               &Proc = vProcFill
               &Parm = "hCard, BUFFER bPers, BUFFER op-int, BUFFER bCard, BUFFER bLoan, BUFFER bCrdBnk,  BUFFER bProcess"
            }
            {&ON-ERROR}
         END.
         vFlagFnd = YES.
         LEAVE.
      END.                                       /* FOR FIRST bCard WHERE     */

      IF vFlagFnd NE YES THEN DO:
         RUN Fill-SysMes("","ExchCRD71","","%s=" + GetNullInt(vOpIntID)).
         RUN InstanceJunk (hCard, 0).
      END.

      vFlagSet = YES.
   END.

   {doreturn.i vFlagSet}
END PROCEDURE.
/*----------------------------------------------------------------------------*/
/* Заполнение данных клиента                                                  */
/*----------------------------------------------------------------------------*/
PROCEDURE ECARDFillPerson:
   DEFINE INPUT PARAMETER  hCard AS handle NO-UNDO.
   DEFINE PARAMETER BUFFER bPers FOR Person.
   DEFINE PARAMETER BUFFER bCard FOR Loan.
   DEFINE PARAMETER BUFFER bCBnk FOR Code.
   DEFINE PARAMETER BUFFER bProc FOR Code.

   DEFINE VAR vFlagSet  AS LOGICAL INIT ? NO-UNDO.

   DEFINE VAR vOpDate   AS DATE     NO-UNDO.
   DEFINE VAR vSurr     AS CHAR     NO-UNDO.
   DEFINE VAR vType     AS CHAR     NO-UNDO.
   DEFINE VAR vAddress  AS CHAR     NO-UNDO.
   DEFINE VAR v3Name    AS CHAR     NO-UNDO.
   DEFINE VAR vName1    AS CHAR     NO-UNDO.
   DEFINE VAR vName2    AS CHAR     NO-UNDO.
   DEFINE VAR vName3    AS CHAR     NO-UNDO.
   DEFINE VAR vCity     AS CHAR     NO-UNDO.
   DEFINE VAR vIndex    AS CHAR     NO-UNDO.

MAIN:
   DO ON ERROR UNDO MAIN, RETRY MAIN:
      {do-retry.i MAIN}

      ASSIGN
         vOpDate  = hCard:buffer-field("op-date"):buffer-value

         vAddress = bPers.address[1] + " " + bPers.address[2]

         v3Name   = CRDGet3Name (BUFFER bPers)
         vName1   = ENTRY(1,v3Name,chr(1))                   /* фамилия    */
         vName2   = ENTRY(2,v3Name,chr(1))                   /* имя        */
         vName3   = ENTRY(3,v3Name,chr(1))                   /* отчество   */

         vCity    = GetEntries(3,vAddress,",","")
         vIndex   = GetEntries(1,vAddress,",","")

         vSurr    = string(bPers.person-id)

         vType    = GetXAttrValueEx("person",vSurr,"Субъект","ФЛ")
      .

      vType =  "PR" /* GetRefVal("ТипКлиент",vOpDate,bProc.Code + "," + vType) */.

      ASSIGN
         hCard:buffer-field("ClntType"):buffer-value     =  vType
         hCard:buffer-field("ClntLName"):buffer-value    =  vName1         /*Ф*/
         hCard:buffer-field("ClntFName"):buffer-value    =  vName2         /*И*/
         hCard:buffer-field("ClntMName"):buffer-value    =  vName3         /*О*/
         hCard:buffer-field("ClntDName"):buffer-value    =  ""             /*Д*/
         hCard:buffer-field("ClntSName"):buffer-value    =  /* CRDGetSName(v3Name) */ CAPS(vName1) + " " + CAPS(vName2)
         hCard:buffer-field("ClntPswd"):buffer-value     =  if bCard.user-o[1] eq "" then bPers.document else bCard.user-o[1]
         hCard:buffer-field("ClntPassport"):buffer-value =  bPers.document
         hCard:buffer-field("ClntIssue"):buffer-value    =  GetXAttrValue("person",
                                                                          vSurr,
                                                                          "Document4Date_vid")  +
                                                      " " + bPers.issue

         hCard:buffer-field("ClntCountry"):buffer-value  =  CAPS(bPers.Country)
         hCard:buffer-field("ClntCity"):buffer-value     =  vCity
         hCard:buffer-field("ClntPhone"):buffer-value    =  string(bPers.Phone[1],"x(10)") +
                                                            string(bPers.Phone[2],"x(10)") +
                                                            string(bPers.Fax,"x(10)")
         hCard:buffer-field("ClntZIP"):buffer-value      =  "198001"
         hCard:buffer-field("ClntAddress1"):buffer-value =  bPers.Address[1]
         hCard:buffer-field("ClntAddress3"):buffer-value =  GetXAttrValue("person",
                                                                          vSurr,
                                                                          "PlaceOfStay")
         hCard:buffer-field("ClntAddress4"):buffer-value =  vName1                + " "  +
                                                            SUBSTRING(vName2,1,1) + ". " +
                                                            SUBSTRING(vName3,1,1) + ". " +
                                                            bPers.document

         hCard:buffer-field("ClntBDate"):buffer-value    =  bPers.BirthDay
         hCard:buffer-field("ClntBPlace"):buffer-value   =  GetXAttrValue("person",
                                                                          string(bPers.person-id),
                                                                          "BirthPlace")
      NO-ERROR. {&ON-ERROR}

      vFlagSet = YES.
   END.

   {doreturn.i vFlagSet}
END PROCEDURE.
/*----------------------------------------------------------------------------*/
/* Изменение статуса поручения при экспорте                                   */
/* EMASTStatusExport:                                                         */
/*----------------------------------------------------------------------------*/
PROCEDURE ECARDStatusExport:
   DEFINE INPUT PARAMETER iParentID    AS INTEGER  NO-UNDO.

   DEFINE BUFFER op-int FOR op-int.
   DEFINE VAR vFlagSet  AS LOGICAL INIT ? NO-UNDO.

MAIN:
   DO TRANSACTION ON ERROR UNDO MAIN, RETRY MAIN:
      {do-retry.i MAIN}

      FOR EACH Packet WHERE
               Packet.ParentID EQ iParentID
           AND Packet.State    NE {&STATE-ERR}
               NO-LOCK,
         FIRST PackObject WHERE
               PackObject.PacketID  EQ Packet.PacketID
           AND PackObject.File-Name EQ "op-int"
               NO-LOCK,
         FIRST op-int WHERE
               op-int.op-int-id EQ INTEGER(PackObject.Surrogate)
               EXCLUSIVE-LOCK:
         ASSIGN op-int.op-int-status = {&CSTATE-SND} NO-ERROR.
         {&ON-ERROR}
      END.

      vFlagSet = YES.
   END.

   {doreturn.i vFlagSet}
END PROCEDURE.

/*----------------------------------------------------------------------------*/
/* Формирование УНКП                                                          */
/*----------------------------------------------------------------------------*/
FUNCTION CRDGetNextUNKP RETURNS CHARACTER (INPUT iCodeType AS CHARACTER, iDate AS DATE):

   DEFINE VARIABLE vCounter AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE vCntVal  AS INTEGER     NO-UNDO.
   DEFINE VARIABLE vFmt     AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE vProc    AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE vIdent   AS CHARACTER   NO-UNDO.
   
   &IF DEFINED(IS-DEBUG) &THEN
   RUN dbgprint.p ("CRDGetNextUNKP"," iCodeType: " + iCodeType +
                                    " iDate: " + STRING(iDate)).
   &ENDIF
   
   FIND FIRST code WHERE code.class EQ "УНКП" AND 
                         code.code  EQ iCodeType
      NO-LOCK NO-ERROR.
   IF AVAIL code THEN
      ASSIGN
         vCounter = code.val
         vFmt     = code.misc[1]
         vProc    = code.misc[2]
   .
   &IF DEFINED(IS-DEBUG) &THEN
   RUN dbgprint.p ("CRDGetNextUNKP"," vCounter: " + vCounter +
                                    " vFmt: " + vFmt +
                                    " vProc: " + vProc).
   &ENDIF
   
   IF NOT {assigned vCounter} THEN
   DO:
      RUN Fill-SysMes IN h_tmess ("","","0","Не задан счетчик УНКП").
      RETURN ?.
   END.
   ELSE
      vCntVal  = GetCounterCurrentValue (vCounter, iDate).

   &IF DEFINED(IS-DEBUG) &THEN
   RUN dbgprint.p ("CRDGetNextUNKP"," vCntVal: " + STRING(vCntVal)).
   &ENDIF

   IF vCntVal EQ ? THEN
   DO:
      RUN Fill-SysMes IN h_tmess ("","ISrv10","","").
      RETURN ?.
   END.

   IF NOT {assigned vFmt} THEN
      vFmt = FILL ("9",11).

   IF {assigned vProc} THEN
   DO:
      {exch-run.i
         &Proc = vProc
         &Parm = "vCntVal, vFmt, INPUT-OUTPUT vIdent"
      }
      IF ERROR-STATUS:ERROR THEN
         RETURN ?.
   END.
   ELSE
   DO:
      ASSIGN
         vIdent = STRING (vCntVal, vFmt)
      NO-ERROR.
      IF ERROR-STATUS:ERROR THEN
      DO:
         RUN Fill-SysMes IN h_tmess ("","","0",ERROR-STATUS:GET-MESSAGE(1)).
         RETURN ?.
      END.
   END.

   SetCounterValue(vCounter,?,iDate). /* Все в порядке - увеличить счетчик */

   RETURN vIdent.
END FUNCTION.

/*----------------------------------------------------------------------------*/
/* Формирование идентификатора клиента                                        */
/*----------------------------------------------------------------------------*/
FUNCTION CRDGetCustIdent CHAR (INPUT  iCustCat   AS CHAR,
                               INPUT  iCustID    AS INT64,
                               INPUT  iDateBeg   AS DATE,
                               INPUT  iDateEnd   AS DATE,
                               INPUT  iCodeType  AS CHAR,
                               OUTPUT oCreate    AS LOGICAL):

   DEFINE BUFFER bCustIdent FOR cust-ident.
   DEFINE VAR vIdent    AS CHAR     INIT ""  NO-UNDO.
   DEFINE VAR vDateBeg  AS DATE              NO-UNDO.
   DEFINE VAR vDateEnd  AS DATE              NO-UNDO.

   DISABLE TRIGGERS FOR LOAD OF cust-ident. 

MAIN:
   DO ON ERROR UNDO MAIN, RETRY MAIN:
      {do-retry.i MAIN}

      IF iDateBeg = ? THEN iDateBeg = {&BQ-MAX-DATE}.
      IF iDateEnd = ? THEN iDateEnd = {&BQ-MIN-DATE}.

      FOR EACH bCustIdent WHERE
               bCustIdent.cust-cat        EQ iCustCat
           AND bCustIdent.cust-id         EQ iCustID
           AND bCustIdent.cust-code-type  EQ iCodeType
 /*          AND bCustIdent.open-date       LE iDateBeg */
               NO-LOCK:

         vDateEnd = IF bCustIdent.close-date = ?
                       THEN {&BQ-MAX-DATE}
                       ELSE bCustIdent.close-date.
         IF vDateEnd LT iDateEnd THEN NEXT. 

         vIdent  = bCustIdent.cust-code.
         oCreate = NO  /*T (ENTRY(1,bCustIdent.Issue,chr(1)) EQ "Подтвержден") */ .
         LEAVE.
      END.

      &IF DEFINED(IS-DEBUG) &THEN
      RUN dbgprint.p ("CRDGetCustIdent","iCustCat:" + GetNullStr(iCustCat) +
                                        " iCustID:" + GetNullInt(iCustID)  +
                                       " iDateBeg:" + GetNullDat(iDateBeg) +
                                       " iDateEnd:" + GetNullDat(iDateEnd) +
                                      " iCodeType:" + GetNullStr(iCodeType) +
                                         " vIdent:" + GetNullStr(vIdent) +
                                        " oCreate:" + GetNullStr(string(oCreate))).
      &ENDIF

      IF NOT {assigned vIdent} THEN
CRT:
      DO TRANSACTION:
         IF RETRY THEN DO:
            vIdent = ?.
            UNDO MAIN, RETRY MAIN.
         END.

         vIdent = string(iCustID) /* CRDGetNextUNKP(iCodeType, iDateEnd) */ .
         
         &IF DEFINED(IS-DEBUG) &THEN
         RUN dbgprint.p ("CRDGetCustIdent","vIdent: " + STRING (vIdent)).
         &ENDIF
         
         IF vIdent EQ ? THEN
            UNDO CRT, RETRY CRT.

         CREATE bCustIdent.
         ASSIGN bCustIdent.cust-cat       = iCustCat
                bCustIdent.cust-id        = iCustID
                bCustIdent.cust-code-type = iCodeType
                bCustIdent.cust-code      = vIdent
                bCustIdent.open-date      = iDateBeg
                bCustIdent.class-code     = "УНКП"
                bCustIdent.cust-type-num  = 1
                bCustIdent.Issue          = /* "Линкованный" */ ""
                oCreate                   = YES
         NO-ERROR.                      IF ERROR-STATUS:ERROR THEN UNDO CRT, RETRY CRT.
         VALIDATE cust-ident  NO-ERROR. IF ERROR-STATUS:ERROR THEN UNDO CRT, RETRY CRT.
      END.                                       /* IF NOT {assigned vIdent}  */

   END.                                          /* MAIN: DO:                 */

   &IF DEFINED(IS-DEBUG) &THEN
   RUN dbgprint.p ("CRDGetCustIdent","vIdent:" + GetNullStr(vIdent) +
                                   " oCreate:" + string(oCreate)).
   &ENDIF

   RETURN vIdent.
END FUNCTION.
/*----------------------------------------------------------------------------*/
/*                                                                            */
/*----------------------------------------------------------------------------*/
FUNCTION CRDGet3Name CHAR (BUFFER bPers FOR person):
   RETURN   bPers.name-last                        + chr(1) +   /* фамилия    */
            GetEntries(1,bPers.first-names," ","") + chr(1) +   /* имя        */
            GetEntries(2,bPers.first-names," ","").             /* отчество   */
END FUNCTION.
/*----------------------------------------------------------------------------*/
/*                                                                            */
/*----------------------------------------------------------------------------*/
FUNCTION CRDGetSName CHAR (INPUT i3Name   AS CHAR):
   RETURN            ENTRY(1,i3Name,chr(1))      + " "  +
           SUBSTRING(ENTRY(2,i3Name,chr(1)),1,1) + ". " +
           SUBSTRING(ENTRY(3,i3Name,chr(1)),1,1) + ".".
END FUNCTION.
/******************************************************************************/
