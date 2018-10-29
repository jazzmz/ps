/*
               Банковская интегрированная система БИСквит
    Copyright: (C) MCMXCII-MCMXCIX ТОО "Банковские информационные системы"
     Filename: ap-os1l.p
      Comment: Процедура печати по списку карточек
               'Акт о приеме-передаче объекта основных средств' (Формы ОС-1).
               Вызывает шаблон печати.  
               Шаблон вызывает формулы.
               Формулы = вызов процедуры с настр.параметрами 
               Процедура = вызов процедур из библиотеки
               Есть также ap-os1o.p - печать одного документа.
   Parameters: tmprecid со списком recid карточек.
         Uses: globals.i norm.i norm-beg.i norm-clc.p 
      Used by: 
      Created: 10/11/2003 AVAL
*/
{globals.i}
{ap-ostmp.def}
{a-persis.get}

DEF VAR  mShabName        AS   CHAR                   NO-UNDO. /* Наименование шаблона */
DEF VAR  in-dataclass-id  LIKE DataClass.DataClass-Id NO-UNDO.
DEF VAR  in-branch-id     LIKE DataBlock.Branch-id    NO-UNDO.
DEF VAR  in-beg-date      LIKE DataBlock.Beg-Date     NO-UNDO.
DEF VAR  in-end-date      LIKE DataBlock.End-Date     NO-UNDO.
DEF VAR  sLibHandle       AS   HANDLE                 NO-UNDO.
/*---------------------------------------------------------------------------*/
mShabName = "ap-os1p".
{norm.i new}
{norm-beg.i 
   &title     = "'ГЕНЕРАЦИЯ ОТЧЕТА' " 
   &nodate    = YES 
   &is-branch = YES
}
IF NOT VALID-HANDLE(sLibHandle) THEN 
   RUN a-prn.p PERSISTENT SET sLibHandle .
/*----------------------------- main ----------------------------------------*/
IF CAN-FIND(FIRST norm WHERE norm.norm = mShabName) THEN
FOR EACH tmprecid-tmp 
         NO-LOCK,
   FIRST loan WHERE 
         RECID(loan)         EQ tmprecid-tmp.id 
         NO-LOCK,
   FIRST loan-acct WHERE
         loan-acct.contract  EQ loan.contract 
     AND loan-acct.cont-code EQ loan.cont-code
     AND loan-acct.acct-type EQ loan.contract + "-" + "учет"
         NO-LOCK,
   FIRST acct WHERE 
         acct.acct           EQ loan-acct.acct
     AND acct.currency       EQ loan-acct.currency
         NO-LOCK,
   FIRST kau-entry WHERE
         kau-entry.acct      EQ loan-acct.acct
     AND kau-entry.currency  EQ loan-acct.currency
     AND kau-entry.kau       BEGINS (loan.contract + "," + loan.cont-code + ",")
     AND kau-entry.debit     EQ (acct.side EQ "А") 
     AND CAN-DO("laf1,laf7",kau-entry.op-code) 
         NO-LOCK ,
   FIRST op OF kau-entry
         NO-LOCK 
:
   ASSIGN 
      in-beg-date = op.doc-date 
      in-end-date = op.doc-date 
   . 
   RUN SetInRecId IN sLibHandle (RECID(kau-entry)).
   {ap-ostmp.cr}
   RUN norm-clc.p ("" , mShabName, in-branch-id, in-beg-date, in-end-date). 
   {empty tmprecid}
END. 
ELSE
   MESSAGE
   "Не найден шаблон печати документа " mShabName "." SKIP
   VIEW-AS ALERT-BOX ERROR.
/*---------------------------------------------------------------------------*/
IF VALID-HANDLE(sLibHandle) THEN 
   DELETE PROCEDURE (sLibHandle). 
{ap-ostmp.end}
{norm-end.i &nofil = yes}
{preview.i &stream = "STREAM fil " } 
/*---------------------------------------------------------------------------*/

{intrface.del}