/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-1996 ТОО "Банковские информационные системы"
     Filename: F744.P
      Comment: Отчет по кассовым символам . Форма 744
   Parameters:
         Uses:
      Used by:
      Created: 03/10/01 Olenka
     Modified: 02/10/02 Gunk Изменение алгоритма для соответствия ф.201 - 202
     Modified: 29/01/04 Gunk Расчет по отделениям. Учет ЗКС.     
     Modified: 09.07.04 ler 29489 - код формы 0401744 (а не 0409744, формир. в stdhdr)
БМ => Печать => Выходные формы => ОТЧЕТЫ ПО КАССЕ => ФОРМА 744 => Форма 744 (с 01.04.2004) 01/04/2003 - 30/04/2003 
*/
&GLOBAL-DEFINE FIRSTUBS 77

DEFINE VARIABLE mDep AS LOGICAL     NO-UNDO.
mDep = TRUE.
&GLOBAL-DEFINE Instr1881-U-ot YES
&GLOBAL-DEFINE is_modified YES
&GLOBAL-DEFINE f744t  YES

DEFINE INPUT  PARAMETER iPars AS CHARACTER  NO-UNDO.

{globals.i}
{norm.i new} /*для шапки*/
{norm-beg.i &nofil = yes &defs = yes &nodate = yes}
{wordwrap.def}
{intrface.get strng}
{intrface.get tmcod}
/* Переменные */
DEFINE VARIABLE vOp-Status  LIKE gOp-Status                    NO-UNDO.
DEFINE VARIABLE mask_symbol as   char init "*" format "x(100)" no-undo.
DEFINE VARIABLE name_kas    as   char                          no-undo.
DEFINE VARIABLE name        as   char extent 2 format "x(30)" column-label "НАИМЕНОВАНИЕ" no-undo.

DEFINE VARIABLE mSum35      AS   DECIMAL    NO-UNDO.
DEFINE VARIABLE mSum70      AS   DECIMAL    NO-UNDO.

DEFINE VARIABLE mDataClass  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE mRound      AS DECIMAL      NO-UNDO.
&IF DEFINED(is_modified) &THEN
DEFINE VARIABLE mID LIKE DataLine.Data-Id    NO-UNDO.
DEFINE VARIABLE mDepID LIKE DataLine.Data-Id    NO-UNDO.
DEFINE VARIABLE mDepClass-ID LIKE DataClass.DataClass-Id    NO-UNDO.
DEFINE VARIABLE dob AS DATE        NO-UNDO.
DEFINE VARIABLE beg AS DATE        NO-UNDO.
DEFINE VARIABLE branch AS CHARACTER        NO-UNDO.
DEFINE VARIABLE mCr      AS DECIMAL      NO-UNDO.
DEFINE VARIABLE mDb      AS DECIMAL      NO-UNDO.

DEFINE VARIABLE vAcct AS  CHARACTER   NO-UNDO.
DEFINE VARIABLE vCur AS  CHARACTER   NO-UNDO.
DEFINE VARIABLE vUBS AS LOG NO-UNDO FORMAT "1/0".
&ELSE
DEFINE VARIABLE  kd  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE  vp  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE  vTMP2  AS DECIMAL    NO-UNDO.
DEFINE VARIABLE  vFirstWorkDay  AS DATE    NO-UNDO.
DEFINE VARIABLE  vTmpAmt AS DECIMAL     NO-UNDO.
&ENDIF

DEF VAR mRow      AS INT    NO-UNDO. /* Номер строки. */
DEF VAR mStr      AS CHAR   NO-UNDO  /* Для формирования нескольких строк наименования счета. */
                  EXTENT 10.

DEFINE VARIABLE vSym AS CHARACTER   NO-UNDO. /*символ*/
DEFINE VARIABLE vSide AS LOGICAL     NO-UNDO. /*приходность*/

def temp-table tt_Symbol no-undo
    field acct as char
    field currency as char
    field symbol as char
    field stype as int /* баланс/забаланс символ */
    FIELD sSide AS LOG /* Приход/расход */
&IF DEFINED(is_modified) EQ 0 &THEN
    field db as dec
    field cr as dec
&ELSE
field val as DEC
&ENDIF
index tt acct currency symbol
index stype acct stype symbol.

def buffer tt_S for tt_Symbol.

&IF DEFINED(is_modified)  &THEN
   FUNCTION  fRound RETURNS DECIMAL (INPUT X AS DECIMAL):
      IF mRound NE 0 THEN
      RETURN ROUND(X / mRound, 0  ).
      ELSE RETURN X.
   END FUNCTION.
&ELSE
&GLOBAL-DEFINE Extend89 "YES"
&ENDIF
ASSIGN
   mDataClass = GetEntries (1, iPars, ";", "f20x")
   mRound     = &if defined(f744t) EQ 0 &then DEC (GetEntries (2, iPars, ";", "0"))
                &ELSE if GetXAttrValueEx("DataClass",mDataClass,"Округление","") = "" then 1000 else int(GetXAttrValue ("DataClass",mDataClass,"Округление"))
                &ENDIF
.  
/* Класс данных f20x */
FIND FIRST DataClass WHERE DataClass.DataClass-ID EQ mDataClass NO-LOCK NO-ERROR.
IF NOT AVAIL DataClass THEN DO:
   MESSAGE "Неверный параметр процедуры~nНе найден класс данных " mDataClass
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
   RETURN.
END.

/* запрос даты */
{getdates.i}

&GLOBAL-DEFINE end-date end-date
&GLOBAL-DEFINE beg-date beg-date
/* инициализация формул */

&IF DEFINED(is_modified)  &THEN
mDepClass-ID = mDataClass.
IF mDep THEN mDepClass-ID = ENTRY(1, DataClass.Depends).
FIND FIRST DataClass WHERE DataClass.DataClass-ID EQ mDataClass NO-LOCK NO-ERROR.
IF NOT AVAIL DataClass THEN DO:
   MESSAGE "Неверный параметр процедуры~nНе найден класс данных " mDataClass
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
   RETURN.
END.
{f20f#.def &class = mDepClass-ID}
&ELSE
{f20f#.def &class = mDataClass}

&ENDIF
{f20.i
   &nodef      = "/*"
   &BranchCalc = YES
}
{sh-defs.i}
vOp-Status = gOp-Status.
/* Запрос маски символов */
do transaction on error undo, leave on endkey undo, leave with frame aaa:
   update mask_symbol label "Маска кассовых символов" view-as fill-in size 40 by 1
   with frame aaa centered row 10 top-only overlay title color bright-white "[ ВВЕДИТЕ ]" side-label
    editing:
       readkey.
       if (lastkey = 301) and frame-field = "mask_symbol" then do:
          pick-value = "".
          RUN browseld.p ("tmp-code", "class" + CHR(1) + "RetRcp" + CHR(1) + "RetFld" + CHR(1) + "RetType",
                                      "КасСимволы"+ CHR(1) + STRING(mask_symbol:HANDLE) + CHR(1) + "code" + CHR(1) + "Singl", "", 1).
       end.
       else
          apply lastkey.
    end.
end.
if keyfunc(lastkey) = "end-error" or mask_symbol = ? or mask_symbol = "" then return.

{justamin}
&IF DEFINED(is_modified) EQ 0 &THEN
/* Алгоритм из ф.201-202 */
{f20f#.i &calc-entry = f744.i &extraday = "YES"}
&if defined(Extend89) &then
vTMP2 = 0.
vTmpAmt = 0.
vFirstWorkDay = end-date + 1.
DO WHILE   (holiday(vFirstWorkDay)) :  
   vFirstWorkDay = vFirstWorkDay + 1.
END.
/*рабочий ли день*/
/*проверка стоит ли символ 89 в какойнибудь формуле*/
/*если его там нет */

   IF   holiday(end-date)
       AND NOT CAN-DO(vFirstFive,"89")
       AND NOT CAN-DO(vAllZks,"89")
       AND NOT CAN-DO(list_ZKSf,"89")
    THEN                           
   DO:
      {for_form.i
         &nodef = "/*"
         &and=" and b-formula.var-id BEGINS 'ВП' " 
      }
         kd = (SUBSTRING(formula.formula,INDEX(formula.formula, "Кд=") + 3)).
         kd = Substring( kd, 1, Length(kd) - 1 ).
         vp = entry(1,SUBSTRING(formula.formula,INDEX(formula.formula, "ВП=") + 3)," ").
         vp = replace(vp,"В","&1").
         vp = replace(vp,"Кд",string(decimal(kd),">>9.9")).
         {f20f#.i
            &calc-entry = "f744.i "
            &calc2 = "Yes"
            &End-Date = vFirstWorkDay
            &Beg-Date = vFirstWorkDay
            &extraday = "YES"
            {&*}
         }   
         vp = SUBST(vp,string(vTMP2,">>>>>>>>>>>>>9.99")). 
         RUN normpars.p (vp,
                         beg-date,
                         end-date,
                         OUTPUT vTmpAmt).  
       FOR  EACH tt_Symbol WHERE tt_Symbol.Symbol = "89" NO-LOCK:
          DELETE tt_Symbol.
       END.
       create tt_Symbol.
       assign tt_Symbol.acct = ""
              tt_Symbol.currency = ""
              tt_Symbol.symbol = "89"
              tt_symbol.sSide = ?
              tt_Symbol.stype = 1 
              tt_Symbol.cr = tt_Symbol.cr + vTmpAmt. 
              
      END.
   END.
&endif
/* Заполнение символов 35 и 70 */
{f20s#.obr &calc-obr = f744.clo}
/* заполнение tt */
PROCEDURE cr_symbol.
   DEFINE INPUT  PARAMETER Db_Cr AS CHAR NO-UNDO.
   DEFINE INPUT  PARAMETER iSymb AS CHARACTER  NO-UNDO.

   DEFINE VARIABLE vUBS AS LOG NO-UNDO FORMAT "1/0".
   DEFINE VARIABLE vAmt AS DECIMAL    NO-UNDO.
   DEFINE VARIABLE vSide AS LOGICAL     NO-UNDO.
   DEFINE VARIABLE cSide AS CHARACTER   NO-UNDO.

   /* Проверка приходности символа */
   cSide = getTCodeFld("val","КасСимволы",iSymb,End-Date).
   IF NOT CAN-DO("Прих,Расх", cSide)  THEN vSide = ?.
   ELSE vSide = cSide BEGINS "Прих".
   
   {f744b.i {&*}}
   ASSIGN
      vUBS  = vSide EQ ?
      vAmt  = op-entry.amt-rub
   .
   IF vAmt EQ 0 THEN RETURN.
   
   find first tt_Symbol where
              tt_Symbol.acct = acct-b.acct and
              tt_Symbol.currency = acct-b.currency and
              tt_Symbol.symbol = iSymb
              no-error.
   if not avail tt_Symbol then do:
      create tt_Symbol.
      assign tt_Symbol.acct = acct-b.acct
             tt_Symbol.currency = acct-b.currency
             tt_Symbol.symbol = iSymb
             tt_Symbol.stype = int (string (vUBS,"1/0"))
             tt_symbol.sSide = vSide
      .
   end.
   if db_cr = "db" then
      tt_Symbol.db = tt_Symbol.db + vAmt.
   else
      tt_Symbol.cr = tt_Symbol.cr + vAmt.

   find first tt_Symbol where
              tt_Symbol.acct = "" and
              tt_Symbol.currency = "" and
              tt_Symbol.symbol = iSymb
              no-error.
   if not avail tt_Symbol then do:
      create tt_Symbol.
      assign tt_Symbol.acct = ""
             tt_Symbol.currency = ""
             tt_Symbol.symbol = iSymb
             tt_symbol.sSide = vSide
             tt_Symbol.stype = int (string (vUBS,"1/0"))
      .
   end.
   
   if db_cr = "db" then
      tt_Symbol.db = tt_Symbol.db + vAmt.
   else
      tt_Symbol.cr = tt_Symbol.cr + vAmt.

END PROCEDURE.
&ELSE
recalc = true.

RUN sv-get.p (    mDataClass,
                   in-branch-id,
                   beg-date,
                   end-date,
            OUTPUT mID).
FIND FIRST DataBlock WHERE DataBlock.Data-Id = mID NO-LOCK NO-ERROR.
RUN CloseDebug IN h_debug.
mDepID = mID.
IF mDep THEN
DO:
   ASSIGN 
   dob = DataBlock.End-Date
   beg = DataBlock.Beg-Date
   branch = DataBlock.Branch-Id. 
   FIND FIRST DataBlock WHERE DataBlock.DataClass-Id = mDepClass-ID
                         AND  DataBlock.Beg-Date = beg 
                         AND  DataBlock.End-Date = dob 
                         AND  DataBlock.Branch-Id = branch  NO-LOCK NO-ERROR.
   IF NOT AVAIL DataBlock  THEN RETURN.
   mDepID = DataBlock.Data-Id.
end.
for each DataLine WHERE DataLine.Data-Id = mDepID
   AND (DataLine.Sym2 NE "" OR DataLine.Sym3 NE "")
   AND CAN-DO (mask_symbol,DataLine.Sym1) 
   NO-LOCK : 
   vSym = &if defined(Instr1881-U-ot) &then entry(2,DataLine.Sym1) &else DataLine.Sym1 &endif. 
   IF NOT CAN-DO("Прих,Расх", getTCodeFld("val","КасСимволы",vSym ,DataBlock.End-Date)) THEN NEXT.
   ELSE vSide = getTCodeFld("val","КасСимволы",vSym ,DataBlock.End-Date) BEGINS "Прих".
   IF STRING (vSide,"DB/CR") EQ "CR" THEN  /* Заполнение*/
      vAcct = DataLine.Sym3.
   ELSE vAcct = DataLine.Sym2. 
    {find-act.i &acct = vAcct}
   vCur =  acct.currency.
   FIND FIRST tt_Symbol WHERE tt_Symbol.symbol = vSym
       AND tt_Symbol.acct = vAcct
       AND tt_Symbol.currency = vCur   NO-ERROR
   .
      IF NOT AVAIL tt_Symbol THEN
    DO:
       CREATE tt_Symbol.
    ASSIGN tt_Symbol.acct = vAcct
       tt_Symbol.currency = vCur
       tt_Symbol.sSide = vSide
       tt_Symbol.stype = 0
       tt_Symbol.val = 0
       tt_Symbol.symbol = vSym.
    END.
     tt_Symbol.val = tt_Symbol.val + DataLine.Val[1].
    IF NOT mDep THEN /* для f202r итого по всем счетам */
    DO:
      FIND FIRST tt_Symbol WHERE tt_Symbol.acct EQ ""
         AND tt_Symbol.currency EQ ""
         AND tt_Symbol.symbol =  vSym NO-LOCK NO-ERROR.
      IF NOT AVAIL tt_Symbol THEN
      DO:
         CREATE tt_Symbol.
         ASSIGN tt_Symbol.acct = ""
         tt_Symbol.currency = ""
         tt_Symbol.sSide = vSide
         tt_Symbol.stype = 0
         tt_Symbol.val = 0
         tt_Symbol.symbol = vSym.
      END.
      tt_Symbol.val = tt_Symbol.val + IF mRound NE 0 THEN round(DataLine.Val[1] / mRound,0) ELSE DataLine.Val[1].   
    END.
END.

IF  mDep THEN    /* для f202t итого по всем счетам*/
DO:
   for each DataLine WHERE DataLine.Data-Id = mID
      AND CAN-DO (mask_symbol, DataLine.Sym1 ) no-lock:

      vSym =  DataLine.Sym1.     
      IF NOT can-do("Прих,Расх", getTCodeFld("val","КасСимволы",vSym ,DataBlock.End-Date)) THEN NEXT.
      ELSE vSide = getTCodeFld("val","КасСимволы",vSym ,DataBlock.End-Date) BEGINS "Прих".

      CREATE tt_Symbol.
      ASSIGN tt_Symbol.acct = ""
            tt_Symbol.currency = ""
            tt_Symbol.sSide = vSide
            tt_Symbol.stype = 0
            tt_Symbol.val = DataLine.Val[1].
            tt_Symbol.symbol = vSym.
   END.
END.
/* side = ? */
IF  mDep THEN /* для f202t*/
DO:
    FOR  each DataLine WHERE DataLine.Data-Id = mID
                             AND DataLine.Sym1  NE "35"
                             AND DataLine.Sym1  NE "70" 
                             AND CAN-DO (mask_symbol,DataLine.Sym1) NO-LOCK:
         vSym = DataLine.Sym1 .   
         IF can-do("Прих,Расх", getTCodeFld("val","КасСимволы",DataLine.Sym1,DataBlock.End-Date)) THEN NEXT.
         CREATE tt_Symbol.
         ASSIGN tt_Symbol.acct = ""
            tt_Symbol.currency = ""
            tt_Symbol.sSide = ?
            tt_Symbol.stype = 1
            tt_Symbol.val = DataLine.Val[1].
            tt_Symbol.symbol =  vSym.

  END.
 END.
 ELSE /* для f202r*/
 DO:
    FOR each DataLine WHERE DataLine.Data-Id = mID
                             AND &if defined(Instr1881-U-ot) &then entry(2,DataLine.Sym1) &else DataLine.Sym1 &endif  NE "35"
                             AND &if defined(Instr1881-U-ot) &then entry(2,DataLine.Sym1) &else DataLine.Sym1 &endif  NE "70" 
                             AND CAN-DO (mask_symbol,DataLine.Sym1) NO-LOCK:
       
       vSym = &if defined(Instr1881-U-ot) &then entry(2,DataLine.Sym1) &else DataLine.Sym1 &endif.   
       FIND FIRST tt_Symbol WHERE tt_Symbol.acct = ""
                            AND tt_Symbol.currency = ""
                            AND tt_Symbol.symbol =  vSym NO-ERROR. /* искать тк нужна сумма*/
       IF can-do("Прих,Расх", getTCodeFld("val","КасСимволы",vSym,DataBlock.End-Date)) THEN NEXT.
       IF NOT AVAIL tt_Symbol THEN
       DO:
          CREATE tt_Symbol.
          ASSIGN tt_Symbol.acct = ""
                 tt_Symbol.currency = ""
                 tt_Symbol.sSide = ?
                 tt_Symbol.stype = 1
                 tt_Symbol.val = 0.
                 tt_Symbol.symbol =  vSym.
       END.
       tt_Symbol.val = tt_Symbol.val + IF mRound NE 0 THEN ROUND (DataLine.Val[1] / mRound, 0) ELSE DataLine.Val[1].
    END. 
 END.

 FOR EACH  DataLine WHERE DataLine.Data-Id = mID
                      AND CAN-DO("*35", DataLine.Sym1)
       NO-LOCK:
    mSum35 = mSum35 + DataLine.Val[1].
 END.
 FOR EACH  DataLine WHERE DataLine.Data-Id = mID
                      AND CAN-DO("*70", DataLine.Sym1)
       NO-LOCK:
    mSum70 = mSum70 + DataLine.Val[1].
 END.

&ENDIF
/* вывод протокола */
RUN CloseDebug IN h_debug.

/* вывод данных */
{setdest.i &stream="stream fil " &cols = 78}

def var xResult as dec no-undo.
run stdhdr.p (output xResult, beg-date, end-date, "78,0401744," 
          + (IF mRound LE 1 THEN "Руб." ELSE "Тыс.руб.") 
          + ",ОТЧЕТ_О_КАССОВЫХ_ОБОРОТАХ_УЧРЕЖДЕНИЙ_БАНКА_РОССИИ|И_КРЕДИТНЫХ_ОРГАНИЗАЦИЙ|за_&1").

put stream fil unformatted skip(1)
    space(15) "Маска кассовых символов: " mask_symbol  skip(1)
.
&IF DEFINED(is_modified) EQ 0 &THEN
{f744.kor}

for each tt_Symbol where tt_Symbol.acct > "" and
         can-do(mask_symbol,tt_symbol.symbol) no-lock,
&ELSE
mCr = 0.
mDb = 0.                           
for each tt_Symbol where tt_Symbol.acct > ""
                     and can-do(mask_symbol,tt_symbol.symbol)  no-lock,
&ENDIF
   first acct where
         acct.acct = tt_Symbol.acct and
         acct.currency = tt_Symbol.currency no-lock
    break by tt_Symbol.acct by tt_Symbol.stype by tt_Symbol.symbol:

    IF tt_Symbol.stype = 0 THEN
    DO: 
       if first-of(tt_Symbol.acct) then do:
          {getcust.i &name=name &Offinn="/*"}
          
          mStr[1] = " " + acct.acct + " - " + name[1] + " " + name[2].
          {wordwrap.i
               &s = mStr
               &n = 10
               &l = 70
            }
          put stream fil unformatted skip(1).
          DO mRow = 1 TO 10:
             IF mStr[mRow] NE "" THEN put stream fil UNFORMATTED mStr[mRow] skip (1).
          END.
          put stream fil UNFORMATTED
             "┌──────┬───────────────────────┬───────────────────────┐" skip
             "│Символ│        Приход         │        Расход         │" skip
             "├──────┼───────────────────────┼───────────────────────┤" skip
          .
       end.
&IF DEFINED(is_modified) EQ 0 &THEN

       ACCUMULATE
          tt_symbol.db (TOTAL BY tt_Symbol.sType)
          tt_symbol.cr (TOTAL BY tt_Symbol.sType)
       .
       /* Пропускаем пустые символы */
       IF tt_symbol.db NE 0 OR tt_symbol.cr NE 0 THEN
       DO:
&ENDIF
          put stream fil unformatted skip "│" tt_symbol.symbol format "  xx  " "│".
           
&IF DEFINED(is_modified) EQ 0 &THEN
          IF tt_symbol.db NE 0 
            THEN put stream fil UNFORMATTED STRING (tt_symbol.db,"->>>,>>>,>>>,>>>,>>9.99") "│".
            else put stream fil unformatted fill(" ",23) "│".
          IF tt_symbol.cr NE 0 
            THEN put stream fil UNFORMATTED STRING (tt_symbol.cr,"->>>,>>>,>>>,>>>,>>9.99") "│".
            else put stream fil unformatted fill(" ",23) "│".
       END.

       if last-of (tt_symbol.sType) then do:
          put stream fil unformatted skip
             "├──────┼───────────────────────┼───────────────────────┤" skip
             "│Итого │" STRING (accum total by tt_Symbol.sType tt_symbol.db,"->>>,>>>,>>>,>>>,>>9.99") "│"
                        STRING (accum total by tt_Symbol.sType tt_symbol.cr,"->>>,>>>,>>>,>>>,>>9.99") "│" skip
             "└──────┴───────────────────────┴───────────────────────┘" skip
          .
       end.
    END.
&ELSE
       IF STRING (tt_symbol.sSide,"DB/CR") EQ "DB"
       THEN DO:
          put stream fil UNFORMATTED STRING (tt_symbol.val,"->>>,>>>,>>>,>>>,>>9.99") "│".
          mDb = mDb + tt_symbol.val.
       END.
       else put stream fil unformatted fill(" ",23) "│".
       IF STRING (tt_symbol.sSide,"DB/CR") EQ "CR" 
       THEN DO:
          put stream fil UNFORMATTED STRING (tt_symbol.val,"->>>,>>>,>>>,>>>,>>9.99") "│".
          mCr = mCr + tt_symbol.val.
       END.
       else put stream fil unformatted fill(" ",23) "│".
END.
if last-of (tt_symbol.sType) then do:
put stream fil unformatted skip
"├──────┼───────────────────────┼───────────────────────┤" skip
"│Итого │" STRING (mDb,"->>>,>>>,>>>,>>>,>>9.99") "│"
STRING (mCr,"->>>,>>>,>>>,>>>,>>9.99") "│" skip
"└──────┴───────────────────────┴───────────────────────┘" skip
   .
mCr = 0.
mDb = 0.
end.
end.
&ENDIF       
    /* Итоговые таблички */
&IF DEFINED(is_modified) EQ 0 &THEN
    if last(tt_symbol.acct) then do:
&ENDIF
       PUT STREAM fil UNFORMATTED
          skip(1) " Итого по всем счетам:"
          SKIP.
       FOR EACH tt_S WHERE
                tt_S.acct = "" 
            AND CAN-DO(mask_symbol,tt_s.symbol) 
       no-lock break by tt_s.sType 
                     by tt_s.Symbol:

         if first-of(tt_S.stype) then do:
            if tt_S.stype = 1 then
               PUT STREAM fil UNFORMATTED SKIP
                  "┌──────┬───────────────────────┐" skip
                  "│Символ│        Сумма          │" skip
                  "├──────┼───────────────────────┤" SKIP
               .
            ELSE
               put stream fil unformatted skip (1)
                  "┌──────┬───────────────────────┬───────────────────────┐" skip
                  "│Символ│        Приход         │        Расход         │" skip
                  "├──────┼───────────────────────┼───────────────────────┤" SKIP
               .
         end.
&IF DEFINED(is_modified) EQ 0 &THEN
         accum tt_s.db (total by tt_s.sType)
               tt_s.cr (total by tt_s.sType)
         .
         
         IF tt_s.db NE 0 OR tt_s.cr NE 0 THEN
         DO:
            put stream fil unformatted skip "│"
                tt_s.symbol format "  xx  " "│".
   
            IF tt_s.sType EQ 0 THEN
            DO:
                if tt_s.db <> 0 then
                   put stream fil unformatted
                      fRound (tt_s.db) "│".
                else put stream fil unformatted fill(" ",23) "│".
                if tt_s.cr <> 0 then
                   put stream fil unformatted
                      fRound (tt_s.cr) "│".
                else  put stream fil unformatted fill(" ",23) "│".
            END.
&ELSE

            put stream fil unformatted skip "│"
                tt_s.symbol format "  xx  " "│".
     
            IF tt_s.sType EQ 0 THEN
            DO: 
                if STRING(tt_S.sSide,"DB/CR") EQ "DB" then
                DO:
                   mDb = mDb + tt_S.val.
                   put stream fil unformatted
                      &if defined(f744t) &then string(tt_s.val,"->>,>>>,>>>,>>>,>>>,>>9")
                      &Else                    string(tt_s.val,"->>>,>>>,>>>,>>>,>>9.99") 
                      &endif "│".
                END.
                else put stream fil unformatted fill(" ",23) "│".
                if STRING (tt_S.sSide,"DB/CR") EQ "CR" then
                DO:
                   mCr = mCr + tt_S.val.
                    put stream fil unformatted
                     &if defined(f744t) &then string(tt_s.val,"->>,>>>,>>>,>>>,>>>,>>9") 
                     &else                   string(tt_s.val,"->>>,>>>,>>>,>>>,>>9.99")
                     &endif "│".
                END.
                else  put stream fil unformatted fill(" ",23) "│".
            END.
&ENDIF
            ELSE
            DO:
&IF DEFINED(is_modified) EQ 0 &THEN

               if (tt_s.db + tt_s.cr) <> 0 then
                   put stream fil unformatted
                      fRound (tt_s.db + tt_s.cr) "│".
            END.
&ELSE
                 put stream fil unformatted
                 &if defined(f744t) &then String(tt_s.val,"->>,>>>,>>>,>>>,>>>,>>9") 
                 &Else                    String(tt_s.val,"->>>,>>>,>>>,>>>,>>9.99") 
                 &endif "│".
                   mDb = mDb + tt_s.val.
&ENDIF
            END.
         if last-of (tt_s.stype) then do:
            IF tt_s.sType EQ 1 THEN
                put stream fil unformatted skip
                   "├──────┼───────────────────────┤" skip
                   "│Итого │" &IF DEFINED(is_modified) EQ 0 &THEN fRound((accum total by tt_S.sType tt_s.db) +
                                     (accum total by tt_S.sType tt_s.cr))
               &ELSE &if defined(f744t) &then string(mDb,"->>,>>>,>>>,>>>,>>>,>>9") 
                     &ELSE                    string(mDb,"->>>,>>>,>>>,>>>,>>9.99") 
                     &ENDIF 
               &ENDIF "│" skip
                   "└──────┴───────────────────────┘" skip
                .
            ELSE
               put stream fil unformatted skip
                  "├──────┼───────────────────────┼───────────────────────┤" skip
                  "│Итого │" &IF DEFINED(is_modified) EQ 0 &THEN fRound (accum total by tt_S.sType tt_s.db) "│"
                             fRound (accum total by tt_S.sType tt_s.cr)
                  &ELSE &if defined(f744t) &then
                  string(mDb,"->>,>>>,>>>,>>>,>>>,>>9") "│" string(mCr,"->>,>>>,>>>,>>>,>>>,>>9") 
                  &ELSE  string(mDb,"->>>,>>>,>>>,>>>,>>9.99") "│" string(mCr,"->>>,>>>,>>>,>>>,>>9.99")
                  &endif 
                  &ENDIF "│" skip
                  "└──────┴───────────────────────┴───────────────────────┘" SKIP (1).
           &IF DEFINED(is_modified) &THEN
           mCr = 0.
            mDb = 0.
            &else
           end.
       end.
       &endif
    end.
end.

&IF DEFINED(is_modified)  &THEN
PUT STREAM fil UNFORMATTED
   SKIP(1) "┌──────┬───────────────────────┐"
   skip    "│Символ│        Сумма          │"
   skip    "├──────┼───────────────────────┤"
   skip    "│  35  │" &if defined(f744t) &then string((mSum35),"->>,>>>,>>>,>>>,>>>,>>9") &else string((mSum35),"->>>,>>>,>>>,>>>,>>9.99") &endif "│"
   SKIP    "│  70  │" &if defined(f744t) &then string((mSum70),"->>,>>>,>>>,>>>,>>>,>>9") &else string((mSum70),"->>>,>>>,>>>,>>>,>>9.99") &endif "│"
   SKIP    "└──────┴───────────────────────┘"
   SKIP.
&else
PUT STREAM fil UNFORMATTED
   SKIP(1) "┌──────┬───────────────────────┐"
   skip    "│Символ│        Сумма          │"
   skip    "├──────┼───────────────────────┤"
   skip    "│  35  │" fRound (mSum35) "│"
   SKIP    "│  70  │" fRound (mSum70) "│"
   SKIP    "└──────┴───────────────────────┘"
   SKIP.
&endif
/* {signatur.i &stream="stream fil " }*/

/*  */ 
def var ruk as char.
def var buh as char.

find _user where _user._userid eq userid('bisquit') no-lock no-error.

put STREAM fil unformatted
 "" skip(2)
 "Зам.Председателя Правления                 " FGetSetting("f20x","ruk","") format "x(20)" skip (1)
 "Главный бухгалтер                          " FGetSetting("f20x","buh","") format "x(20)" skip (1)
 "     М.П." skip (2)
 "Исполнитель                                " _user._user-name skip (1).

{preview.i &stream="stream fil "}
{norm-end.i &nofil = yes}
{intrface.del}
RETURN "".
