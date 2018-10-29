
&SCOP OFFSigns
&SCOPED-DEFINE OFFinn

{get_set.i "КорСч"}
bank-cor-acct = setting.val.

{bank-id.i}

/*-----------------------------------------
   Проверка наличия записи главной таблицы,
   на которую указывает Input Param RID
-------------------------------------------*/
Find op Where RecID(op) = RID no-lock no-error.
If Not Avail(op) then do:
  message "Нет записи <op>".
  Return.
end.

/* User and Kontr */
  FIND FIRST _user WHERE _user._userid = op.user-id NO-LOCK.
  theUser   = TRIM(_user._user-name).
  theUserID = TRIM(_user._userid).
  IF ( TRIM(op.user-inspector) NE "" ) AND ( TRIM(op.user-inspector) NE theUserID ) THEN DO:
     FIND FIRST _user WHERE _user._userid = op.user-inspector NO-LOCK.
     theKontr   = TRIM(_user._user-name).
     theKontrID = TRIM(_user._userid).
  END.

/*------------------------------------------------
   Выставить buffers на записи, найденные
   в соответствии с заданными в отчете правилами
------------------------------------------------*/
/* Правило для главной таблицы op */
def buffer wop-entry for op-entry.
def buffer xop-entry for op-entry.

def var amt1 like op-entry.amt-rub NO-UNDO.
def var amt2 like op-entry.amt-rub NO-UNDO.
def var amt3 like op-entry.amt-rub NO-UNDO.
def var amt4 like op-entry.amt-rub NO-UNDO.
def var amt5 like op-entry.amt-rub NO-UNDO.

find first op-entry of op no-lock no-error.
   if avail op-entry and
            op-entry.acct-db ne ? and
            op-entry.acct-cr ne ? then do:
                        
      ASSIGN
        PlLAcct = op-entry.acct-db
        PoAcct = op-entry.acct-cr
      .
                  
      if can-find(first acct where acct.acct = op-entry.acct-db and
                                   acct.currency = "") then do:               

         find first currency where 
                    currency.currency = op-entry.currency no-lock no-error.                        
         ASSIGN   
           amt1 = op-entry.amt-rub
           amt3 = op-entry.amt-cur
           amt4 = op-entry.amt-rub
           val1 = "RUR"
           val3 = currency.i-currency
           val4 = "RUR"
         .
      end.
      else do:
         find first currency where
                    currency.currency = op-entry.currency no-lock no-error.
      
         ASSIGN
           amt1 = op-entry.amt-cur
           amt2 = op-entry.amt-rub
           amt4 = op-entry.amt-rub
           val1 = currency.i-currency
           val2 = "RUR"
           val4 = "RUR"
        .   
      end.   

      find first wop-entry of op
                 where wop-entry.acct-db begins "61406" or
                       wop-entry.acct-db begins "70205" or
                       wop-entry.acct-db begins "93801" or
                       wop-entry.acct-cr begins "61306" or
                       wop-entry.acct-cr begins "96801" or
                       wop-entry.acct-cr begins "70103" no-lock no-error.  
         if avail wop-entry then do:
            if wop-entry.acct-db begins "61406" or
               wop-entry.acct-cr begins "70205" or
               wop-entry.acct-db begins "93801"
               then do:
               acct-cur = wop-entry.acct-db.
               if val1 ne "RUR" then do:
                  amt2 = amt2 - wop-entry.amt-rub.
               end.   
               else do:
                  amt4 = amt4 + wop-entry.amt-rub.
               end.         
            end.
            else do:
               acct-cur = wop-entry.acct-cr.
               if val1 ne "RUR" then do:
                  amt2 = amt2 + wop-entry.amt-rub.
               end.
               else do:
                  amt4 = amt4 - wop-entry.amt-rub.
               end.
            end.            
            amt5 = wop-entry.amt-rub.
            val5 = "RUR".         
         end.           
   end.
   else do:
      find first op-entry of op where 
                 op-entry.acct-cr eq ? and
                 (substr(op-entry.acct-db,1,5) ne "61406" or
                  substr(op-entry.acct-db,1,5) ne "70205" or
                  substr(op-entry.acct-db,1,5) ne "93801") no-lock no-error.
      if avail op-entry then do:     
               
         if can-find(first acct where acct.acct = op-entry.acct-db and
                                   acct.currency = "") then do:               
            ASSIGN
              PlLAcct = op-entry.acct-db
              amt1 = op-entry.amt-rub
              val1 = "RUR"
            .
         end.
         else do:
            find first currency where 
                       currency.currency = op-entry.currency no-lock no-error.                        
            ASSIGN
              PlLAcct = op-entry.acct-db
              amt1 = op-entry.amt-cur
              amt2 = op-entry.amt-rub
              val1 = currency.i-currency
              val2 = "RUR"
            .
        end.
        find first wop-entry of op where 
                   wop-entry.acct-db eq ? and 
                   (substr(wop-entry.acct-cr,1,5) ne "61306" or
                    substr(wop-entry.acct-cr,1,5) ne "70103" or
                    substr(wop-entry.acct-cr,1,5) ne "96801") 
                    no-lock no-error.
        if avail wop-entry then do:
           if can-find(first acct where acct.acct = wop-entry.acct-cr and
                                acct.currency = "") then do:               
              ASSIGN
                PoAcct = wop-entry.acct-cr
                amt3 = wop-entry.amt-rub
                val3 = "RUR"
           .
           end.      
           else do:
              find first currency where 
                   currency.currency = wop-entry.currency no-lock no-error.                        
              ASSIGN
                PoAcct = wop-entry.acct-cr
                amt3 = wop-entry.amt-cur
                amt4 = wop-entry.amt-rub
                val3 = currency.i-currency
                val4 = "RUR"
              .
          end.            
        end.
        find first xop-entry of op
             where xop-entry.acct-db begins "61406" or
                   xop-entry.acct-db begins "70205" or
                   xop-entry.acct-db begins "93801" or
                   xop-entry.acct-cr begins "61306" or
                   xop-entry.acct-cr begins "96801" or
                   xop-entry.acct-cr begins "70103" no-lock no-error.  
           if avail xop-entry then do:
              if xop-entry.acct-db begins "61406" or
                 xop-entry.acct-cr begins "70205" or
                 xop-entry.acct-db begins "93801"
                 then do:
                 acct-cur = xop-entry.acct-db.
              end.
              else do:
                 acct-cur = xop-entry.acct-cr.
              end.
                 amt5 = xop-entry.amt-rub.
                 val5 = "RUR".
          end.
        end.                    
   end.

/* Выставим buf_0_op на op роли 'Главная таблица' */
Find buf_0_op Where RecID(buf_0_op) = RecID(op) no-lock.

/* Вычисление значения специального поля CrName */
{getcust2.i acct-cur CrName}.

/* Вычисление значения специального поля Detail */
Detail[1] = op.details.
{wordwrap.i &s=Detail &n=5 &l=80}

/* Вычисление значения специального поля PlCAcct */
 PlCAcct = bank-acct. /* bank-cor-acct <- setting */

/* Вычисление значения специального поля PlMFO */
 PlMFO = {out-fmt.i string(int(bank-mfo-9),fill('9',9)) 'xxxxxxxxx' }. 

/* Вычисление значения специального поля PlBank */
PlRKC[1] = dept.name-bank.
{wordwrap.i &s=PlRKC &l=35 &n=2}


/* Find PlName */
find first acct where acct.acct = PlLAcct no-lock.
{getcust.i &name=NameCli &INN=INNPl &OFFinn=/*}

PlName[1] = NameCli[1] + " " + NameCli[2].
{wordwrap.i &s=PlName &n=5 &l=35}

/* Find PoName */
find first acct where acct.acct = PoAcct no-lock.
{getcust.i &name=NameCli &INN=INNPo &OFFinn=/*}
PoName[1] = NameCli[1] + " " + NameCli[2].
{wordwrap.i &s=poName &n=5 &l=35}


/* Вычисление значения специального поля PoCAcct */
PoCAcct = bank-acct.  /* bank-cor-acct <- setting */

/* Вычисление значения специального поля PolMFO */
PolMFO = {out-fmt.i string(int(bank-mfo-9),fill('9',9)) 'xxxxxxxxx' }.

/* Вычисление значения специального поля PoBank */
find first setting where setting.code = "Банк" no-lock.
PoRKC[1] = setting.val.
{wordwrap.i &s=PoRKC &n=2 &l=35}

/* Вычисление значения специального поля Summa1 */
IF amt1 ne 0 then do:
   IF TRUNC(amt1, 0) = amt1 THEN
      ASSIGN
        Summa1 = STRING(STRING(amt1 * 100, "-zzzzzzzzzz999"), "x(12)=")
     .
   ELSE
      ASSIGN       
        Summa1 = STRING(STRING(amt1 * 100, "-zzzzzzzzzz999"), "x(12)-x(2)")
      .
END.
ELSE DO:
   ASSIGN
     Summa1 = ""    
   .
END.

/* Вычисление значения специального поля Summa2 */
IF amt2 ne 0 then do:
   IF TRUNC(amt2, 0) = amt2 THEN
      ASSIGN
        Summa2 = STRING(STRING(amt2 * 100, "-zzzzzzzzzz999"), "x(12)=")
     .
   ELSE
      ASSIGN       
        Summa2 = STRING(STRING(amt2 * 100, "-zzzzzzzzzz999"), "x(12)-x(2)")
      .
END.
ELSE DO:
   ASSIGN
     Summa2 = ""    
   .
END.

/* Вычисление значения специального поля Summa3 */
IF amt3 ne 0 then do:
   IF TRUNC(amt3, 0) = amt3 THEN
      ASSIGN
        Summa3 = STRING(STRING(amt3 * 100, "-zzzzzzzzzz999"), "x(12)=")
     .
   ELSE
      ASSIGN       
        Summa3 = STRING(STRING(amt3 * 100, "-zzzzzzzzzz999"), "x(12)-x(2)")
      .
END.
ELSE DO:
   ASSIGN
     Summa3 = ""    
   .
END.

/* Вычисление значения специального поля Summa4 */
IF amt4 ne 0 then do:
   IF TRUNC(amt4, 0) = amt4 THEN
      ASSIGN
        Summa4 = STRING(STRING(amt4 * 100, "-zzzzzzzzzz999"), "x(12)=")
     .
   ELSE
      ASSIGN       
        Summa4 = STRING(STRING(amt4 * 100, "-zzzzzzzzzz999"), "x(12)-x(2)")
      .
END.
ELSE DO:
   ASSIGN
     Summa4 = ""    
   .
END.

/* Вычисление значения специального поля Summa5 */
IF amt5 ne 0 then do:
   IF TRUNC(amt5, 0) = amt5 THEN
      ASSIGN
        Summa5 = STRING(STRING(amt5 * 100, "-zzzzzzzzzz999"), "x(12)=")
     .
   ELSE
      ASSIGN       
        Summa5 = STRING(STRING(amt5 * 100, "-zzzzzzzzzz999"), "x(12)-x(2)")
      .
END.
ELSE DO:
   ASSIGN
     Summa5 = ""    
   .
END.

/* Вычисление значения специального поля AmtStr */
IF Val1 = "RUR" THEN DO:
  RUN x-amtstr.p(amt1,"", TRUE, TRUE, OUTPUT AmtStr[1], OUTPUT AmtStr[2]).
  IF TRUNC(amt1, 0) = amt1 THEN
    ASSIGN
      AmtStr[2] = ''
    .
  ELSE
    ASSIGN
      AmtStr[1] = AmtStr[1] + ' ' + AmtStr[2]
    .
  {wordwrap.i &s=AmtStr &n=2 &l=70}
  SUBSTR(AmtStr[1], 1, 1) = CAPS(SUBSTR(AmtStr[1], 1, 1)).
END.
ELSE DO:  
  RUN x-amtstr.p(amt2,"", TRUE, TRUE, OUTPUT AmtStr[1], OUTPUT AmtStr[2]).
  IF TRUNC(amt2, 0) = amt2 THEN
    ASSIGN
      AmtStr[2] = ''
    .
  ELSE
    ASSIGN
      AmtStr[1] = AmtStr[1] + ' ' + AmtStr[2]
    .
  {wordwrap.i &s=AmtStr &n=2 &l=70}
  SUBSTR(AmtStr[1], 1, 1) = CAPS(SUBSTR(AmtStr[1], 1, 1)).
END.

/* Вычисление значения специального поля theDate */
if op.doc-date <> ? then
  theDate = {strdate.i op.doc-date}.
else
  theDate = {strdate.i op.op-date}.

