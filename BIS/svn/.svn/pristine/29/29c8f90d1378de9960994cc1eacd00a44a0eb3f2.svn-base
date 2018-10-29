{pirsavelog.p}
/**             ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (с) 2007
                Формирование списка операций кредитных договоров для ф.808 справочно.
                Борисов А.В., 28.08.2009
*/
/*
  добавил позицию по счету вместо Суммы в валюте, по ТЗ Титовой С.В. + добавил возможность выбора полей для вывода
  Красков А.С.
  16.11.2010.
*/
{globals.i}           /** Глобальные определения */
{pick-val.i}
{chkacces.i}
{intrface.get xclass} /** Функции для работы с метасхемой */
{intrface.get strng}  /** Функции для работы со строками */
{intrface.get date}   /** Функции для работы с датами */
{intrface.get instrum}

{sh-defs.i}
{ulib.i}

/* Определение переменных для вывода формы */
DEF VAR vDate AS Char  No-Undo.
DEF VAR vDoc-num AS Char  No-Undo.
DEF VAR vKod-Banka AS Char  No-Undo.
DEF VAR vKorrAcct AS Char  No-Undo.
DEF VAR vName-Bank AS Char  No-Undo.
DEF VAR vNameKontr AS Char  No-Undo.
DEF VAR vINNKontr AS Char  No-Undo.
DEF VAR vAcct AS Char  No-Undo.
DEF VAR vDb AS Char  No-Undo.
DEF VAR vCr AS Char  No-Undo.
DEF VAR vPos AS Char  No-Undo.
DEF VAR vOst AS Char  No-Undo.
DEF VAR vDetails AS Char  No-Undo.

DEF VAR T1 AS INTEGER  No-Undo.
DEF VAR T2 AS INTEGER  No-Undo.
DEF VAR TempVar AS Decimal  No-Undo.
DEF VAR dPrevDate AS Date  No-Undo.
DEF VAR firstone AS Logical INITIAL TRUE  No-Undo.

/* здесь добавляем форму для выбора данных которые надо выводить*/
ASSIGN
 vDate = "+"
 vDoc-num = "+"
 vKod-Banka = "+"
 vKorrAcct = "+"
 vName-Bank = "+"
 vNameKontr = "+"
 vINNKontr = "+"
 vAcct = "+"
 vDb = "+"
 vCr = "+"
 vPos = "+"
 vOst = "+"
 vDetails = "+".


FORM
   vDate
      FORMAT "x(1)" 
      LABEL  "Дата операции"  
      HELP   "Дата операции"

   vDoc-num
      FORMAT "x(1)" 
      LABEL  "Номер документа"  
      HELP   "Номер документа"

   vKod-Banka
      FORMAT "x(1)" 
      LABEL  "Код банка"  
      HELP   "Код банка"

   vKorrAcct
      FORMAT "x(1)" 
      LABEL  "Корр.счет"  
      HELP   "Корр.счет"

   vName-Bank
      FORMAT "x(1)"  
      LABEL  "Название банка"  
      HELP   "Название банка"

   vNameKontr
      FORMAT "x(1)" 
      LABEL  "Название контрагента"  
      HELP   "Название контрагента"

   vINNKontr
      FORMAT "x(1)" 
      LABEL  "ИНН контрагента"  
      HELP   "ИНН контрагента"

   vAcct
      FORMAT "x(1)" 
      LABEL  "Счет"  
      HELP   "Счет"

   vDb
      FORMAT "x(1)" 
      LABEL  "Дебет"  
      HELP   "Дебет"

   vCr
      FORMAT "x(1)" 
      LABEL  "Кредит"  
      HELP   "Кредит"

   vPos
      FORMAT "x(1)" 
      LABEL  "Позиция по счету"  
      HELP   "Позиция по счету"

   vOst
      FORMAT "x(1)" 
      LABEL  "Остаток в конце дня"  
      HELP   "Остаток в конце дня"

    vDetails
      FORMAT "x(1)" 
      LABEL  "Содержание операции"  
      HELP   "Содержание операции"

WITH FRAME frParam 1 COL OVERLAY CENTERED ROW 10 TITLE "[ Выберете данные для вывода ]".

PAUSE 0.

UPDATE
 vDate
 vDoc-num
 vKod-Banka
 vKorrAcct
 vName-Bank
 vNameKontr
 vINNKontr
 vAcct
 vDb
 vCr
 vPos
 vOst
 vDetails
WITH FRAME frParam.

HIDE FRAME frParam NO-PAUSE.




{pir_exf_exl.i}
{getdates.i}

DEFINE VAR oTDoc AS TDocument  No-Undo.

DEFINE VAR oTAcct AS TAcct  No-Undo.

DEFINE VARIABLE oClient AS TClient  No-Undo.


{exp-path.i &exp-filename = "'segment.xls'"}
/******************************************* Определение переменных и др. */
DEF VAR cXL       AS CHAR     NO-UNDO.
DEF VAR cKl       AS CHAR     NO-UNDO.
DEF VAR cINN      AS CHAR     NO-UNDO.

/******************************************* Реализация */
{tmprecid.def}          /* Таблица отметок. */

PUT UNFORMATTED XLHead("Klient", "DCCCCCCCNNNC", "71,83,70,150,200,200,110,150,110,110,110,200").

T1 = Time. 

FOR EACH tmprecid NO-LOCK,
   FIRST acct
      WHERE recid(acct) = tmprecid.id
      NO-LOCK:

   RUN acct-pos IN h_base(acct.acct, acct.currency, beg-date, beg-date, cXL).
   oClient = new TClient(acct.acct).

   cXL = XLRow(0)
       + XLCell("Выписка по счету " + acct.acct + " за период с "
                + STRING(beg-date, "99.99.9999") + " по " + STRING(end-date, "99.99.9999"))
       + XLRowEnd() + XLRow(0)
       + XLCell(oClient:name-short
                + " (ИНН: " + oClient:getInnByDate(end-date) + " )")
       + XLEmptyCells(6)
       + XLCell("Входящий остаток на счете:") + XLEmptyCell()
       + XLNumCell(ABS(sh-in-bal))
       + XLRowEnd()
       .
   DELETE OBJECT oClient.

   PUT UNFORMATTED XLRow(2) XLRowEnd() cXL.
   cXL = "".
   IF vDate = "+" THEN cXL = cXL + XLCell("Дата").
   IF vDoc-num = "+" THEN cXL = cXL + XLCell("N документа").
   IF vKod-Banka = "+" THEN cXL = cXL + XLCell("Код банка").
   IF vKorrAcct = "+" THEN cXL = cXL + XLCell("Корр.счет").
   IF vName-Bank = "+" THEN cXL = cXL + XLCell("Название банка").
   IF vNameKontr = "+" THEN cXL = cXL + XLCell("Название контрагента").
   IF vINNKontr = "+" THEN cXL = cXL + XLCell("ИНН контрагента").
   IF vAcct = "+" THEN cXL = cXL + XLCell("Счет контрагента").
   IF vDb = "+" THEN cXL = cXL + XLCell("ДБ").
   IF vCr = "+" THEN cXL = cXL + XLCell("КР").
   IF vPos = "+" THEN cXL = cXL + XLCell("Остаток на счете").
   IF vDetails = "+" THEN cXL = cXL + XLCell("Содержание операции").

   /*cXL = XLCell("Дата")
       + XLCell("N документа")
       + XLCell("Код банка")
       + XLCell("Корр.счет")
       + XLCell("Название банка")
       + XLCell("Название контрагента")
       + XLCell("ИНН контрагента")
       + XLCell("Счет контрагента")
       + XLCell("ДБ")
       + XLCell("КР")
       + XLCell("Остаток на счете")
       + XLCell("Содержание операции")
       .*/
   PUT UNFORMATTED XLRow(2) cXL XLRowEnd() .
   dprevDate = beg-date.
  
   FOR EACH op
      WHERE (op.op-date >= beg-date)
        AND (op.op-date <= end-date)
        AND NOT (op.doc-num BEGINS "П")
      NO-LOCK,
      EACH op-entry OF op
         WHERE (op-entry.acct-db EQ acct.acct)
            OR (op-entry.acct-cr EQ acct.acct)
      NO-LOCK
      BREAK BY op-entry.op-date BY op-entry.op-entry:

/* здесь добавляем подитог по дням. */
    if vOst = "+" THEN DO:
      IF op-entry.op-date <> dprevdate and firstone <> true
        THEN DO:
           cXl = "".
           oTAcct = new TAcct(acct.acct).
           tempVar = oTAcct:getLastPos2Date(dprevdate,"",810).

           IF vDate = "+" THEN cXL = cXL + XLDateCell(dprevdate).
           IF vDoc-num = "+" THEN cXL = cXL + XLCell(" ").
           IF vKod-Banka = "+" THEN cXL = cXL + XLCell(" ").
           IF vKorrAcct = "+" THEN cXL = cXL + XLCell(" ").
           IF vName-Bank = "+" THEN cXL = cXL + XLCell(" ").
           IF vNameKontr = "+" THEN cXL = cXL + XLCell(" ").
           IF vINNKontr = "+" THEN cXL = cXL + XLCell(" ").
           IF vAcct = "+" THEN cXL = cXL + XLCell(" ").
           IF vDb = "+" THEN cXL = cXL + XLCell(" ").
           IF vCr = "+" THEN cXL = cXL + XLCell(" ").
           IF vPos = "+" THEN cXL = cXL + XLCell(" ") + XLCell(" ") + XLCell("Остаток в конце дня:") + XLNumCell(tempvar).
           IF vDetails = "+" THEN cXL = cXL + XLCell(" ").
           PUT UNFORMATTED XLRow(0) cXL XLRowEnd()
           cXl = "".
        END.

      firstone = false.
     END.


/* здесь добавляется дата и номер документа*/
   
        cXL = "".
        IF vDate = "+" THEN  cXL = cXL + XLDateCell(op-entry.op-date).
        IF vDoc-num = "+" THEN cXL = cXL + XLCell(op.doc-num).

/*      cXL = XLDateCell(op-entry.op-date)
          + XLCell(op.doc-num). */

      FIND FIRST op-bank
         WHERE (op-bank.op EQ op.op)
           AND (op-bank.op-bank-type   EQ "")
           AND (op-bank.bank-code-type EQ "МФО-9")
         NO-LOCK NO-ERROR.
/* здесь добавляется название банка, код банка, корр.счет, название банка, название контрагента, инн контрагента, счет контрагента*/

      IF AVAILABLE(op-bank)
      THEN DO:
         FIND FIRST banks-code OF op-bank
            NO-ERROR.
         FIND FIRST banks OF banks-code
            NO-ERROR.
     /*    cXL = "".*/
         IF vKod-Banka = "+" THEN cXL = cXL + XLCell(op-bank.bank-code).
         IF vKorrAcct = "+" THEN cXL = cXL + XLCell(op-bank.corr-acct).
         IF vName-Bank = "+" THEN cXL = cXL + XLCell(banks.name).
         IF vNameKontr = "+" THEN cXL = cXL + XLCell(op.name-ben).
         IF vINNKontr = "+" THEN cXL = cXL + XLCell(op.inn).
         IF vAcct = "+" THEN cXL = cXL + XLCell(op.ben-acct).
      END.
      ELSE DO:
         IF vKod-Banka = "+" THEN cXL = cXL + XLCell(" ").
         IF vKorrAcct = "+" THEN cXL = cXL + XLCell(" ").
         IF vName-Bank = "+" THEN cXL = cXL + XLCell(" ").

         IF (op-entry.acct-db EQ acct.acct)
         THEN DO:
            cKl = GetAcctClientName_UAL(op-entry.acct-cr, false).
            IF (cKl NE "")
            THEN DO:
               cINN = GetXAttrValue("op", STRING(op.op), "inn-rec").
               IF (cINN = "")
               THEN cINN = GetClientInfo_ULL(GetAcctClientID_ULL(op-entry.acct-cr, FALSE), "inn", FALSE).
            END.
            ELSE cINN = "".

               IF vNameKontr = "+" THEN cXL = cXL + XLCell(cKl).
               IF vINNKontr = "+" THEN cXL = cXL + XLCell(cINN).
               IF vAcct = "+" THEN cXL = cXL + XLCell(op-entry.acct-cr).

         END.
         ELSE DO:
            cKl = GetAcctClientName_UAL(op-entry.acct-db, false).
            IF (cKl NE "")
            THEN DO:
               cINN = GetXAttrValue("op", STRING(op.op), "inn-send").
               IF (cINN = "")
               THEN cINN = GetClientInfo_ULL(GetAcctClientID_ULL(op-entry.acct-db, FALSE), "inn", FALSE).
            END.
            ELSE cINN = "".
               IF vNameKontr = "+" THEN cXL = cXL + XLCell(cKl).
               IF vINNKontr = "+" THEN cXL = cXL + XLCell(cINN).
               IF vAcct = "+" THEN cXL = cXL + XLCell(op-entry.acct-db).
         END.
      END.
/* здесь добавляем дебет и кредит          */
      IF (op-entry.acct-db EQ acct.acct)
      THEN DO:
         IF vDb = "+" THEN cXL = cXL + XLNumCell(op-entry.amt-rub).
         IF vCr = "+" THEN cXL = cXL + XLEmptyCell().
      END.
      ELSE DO: 
         IF vDb = "+" THEN cXL = cXL + XLEmptyCell().
         IF vCr = "+" THEN cXL = cXL + XLNumCell(op-entry.amt-rub).
      END.
   /* здесь добавляется позиция по счету */

      IF vPos = "+" 
      THEN DO:
         oTDoc = new TDocument(op-entry.op).
         if acct.currency <>? or acct.currency <>"810" then 
         do:
            TempVar = oTDoc:getpos(acct.acct).
            TempVar = oTDoc:AcctPosInRub.
         END. 
       
         ELSE TempVar = oTdoc:getpos(acct.acct).
         IF (TempVar NE ?)
         THEN cXL = cXL + XLNumCell(TempVar).
         ELSE cXL = cXL + XLEmptyCell().
         delete object oTDoc.                 
      END.

/*   */

/* здесь добавляется содержание операции */
      IF vDetails = "+" THEN cXL = cXL + XLCell(op.details) + XLCell("  ").

      IF FIRST-OF(op-entry.op-date)
      THEN PUT UNFORMATTED XLRow(1) cXL XLRowEnd().
      ELSE PUT UNFORMATTED XLRow(0) cXL XLRowEnd().
      cXL = "".

      dprevdate = op-entry.op-date.


   END.

           cXl = "".
           oTAcct = new TAcct(acct.acct).
           tempVar = oTAcct:getLastPos2Date(dprevdate,"",810).

           IF vDate = "+" THEN cXL = cXL + XLDateCell(dprevdate).
           IF vDoc-num = "+" THEN cXL = cXL + XLCell(" ").
           IF vKod-Banka = "+" THEN cXL = cXL + XLCell(" ").
           IF vKorrAcct = "+" THEN cXL = cXL + XLCell(" ").
           IF vName-Bank = "+" THEN cXL = cXL + XLCell(" ").
           IF vNameKontr = "+" THEN cXL = cXL + XLCell(" ").
           IF vINNKontr = "+" THEN cXL = cXL + XLCell(" ").
           IF vAcct = "+" THEN cXL = cXL + XLCell(" ").
           IF vDb = "+" THEN cXL = cXL + XLCell(" ").
           IF vCr = "+" THEN cXL = cXL + XLCell(" ").
           IF vPos = "+" THEN cXL = cXL + XLCell(" ") + XLCell(" ") + XLCell("Остаток в конце дня:") + XLNumCell(tempvar).
           IF vDetails = "+" THEN cXL = cXL + XLCell(" ").
           PUT UNFORMATTED XLRow(0) cXL XLRowEnd().



/* здесь добавляется итого */
   RUN acct-pos IN h_base(acct.acct, acct.currency, beg-date, end-date, cXL).
   cXL = XLRow(2).
   IF vDate = "+" THEN cXL = cXL + XLCell("Итого :").
   IF vDoc-num = "+" THEN cXL = cXL + XLCell(" ").
   IF vKod-Banka = "+" THEN cXL = cXL + XLCell(" ").
   IF vKorrAcct = "+" THEN cXL = cXL + XLCell(" ").
   IF vName-Bank = "+" THEN cXL = cXL + XLCell(" ").
   IF vNameKontr = "+" THEN cXL = cXL + XLCell(" ").
   IF vINNKontr = "+" THEN cXL = cXL + XLCell(" ").
   IF vAcct = "+" THEN cXL = cXL + XLCell("Обороты: ").
   IF vDb = "+" THEN cXL = cXL + XLNumCell(sh-db).
   IF vCr = "+" THEN cXL = cXL + XLNumCell(sh-cr).
   IF vPos = "+" THEN cXL = cXL + XLCell(" ").
   IF vDetails = "+" THEN cXL = cXL + XLCell(" ").

   cXL = cXL + XLRowEnd() + XLRow(0).

   IF vDate = "+" THEN cXL = cXL + XLCell(" ").
   IF vDoc-num = "+" THEN cXL = cXL + XLCell(" ").
   IF vKod-Banka = "+" THEN cXL = cXL + XLCell(" ").
   IF vKorrAcct = "+" THEN cXL = cXL + XLCell(" ").
   IF vName-Bank = "+" THEN cXL = cXL + XLCell(" ").
   IF vNameKontr = "+" THEN cXL = cXL + XLCell(" ").
   IF vINNKontr = "+" THEN cXL = cXL + XLCell(" ").
   IF vAcct = "+" THEN cXL = cXL + XLCell("Остаток на счете: ").
   IF vDb = "+" THEN cXL = cXL + XLCell(" ").
   IF vCr = "+" THEN cXL = cXL + XLNumCell(ABS(sh-bal)).

   cXL = cXL + XLRowEnd().
   PUT UNFORMATTED cXL.



END.



T2 = Time.

PUT UNFORMATTED XLEnd().

/*MESSAGE T2 - T1 VIEW-AS ALERT-BOX.*/

{intrface.del}
