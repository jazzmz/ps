{pirsavelog.p}


                   /*******************************************
                    *                                         *
                    *  ГОСПОДА ПРОГРАММИСТЫ И СОЧУВСТВУЮЩИЕ!  *
                    *                                         *
                    *  РЕДАКТИРОВАТЬ ДАННЫЙ ФАЙЛ БЕСПОЛЕЗНО,  *
                    *  Т.К. ОН СОЗДАЕТСЯ ГЕНЕРАТОРОМ ОТЧЕТОВ  *
                    *             АВТОМАТИЧЕСКИ!              *
                    *                                         *
                    *******************************************/

/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2006 ТОО "Банковские информационные системы"
     Filename: memcvtb.p
      Comment: Отчет, созданный генератором отчетов
      Comment:
   Parameters: Input: RID -  RecID(op)
         Uses: Globals.I ChkAcces.I SetDest.I PreView.I
      Used by:
      Created: 23/03/06 11:20:31
     Modified:
*/
Form "~n@(#) memcvtb.p 1.0 RGen 23/03/06 RGen 23/03/06 [ AutoReport By R-Gen ]"
     with frame sccs-id stream-io width 250.

{globals.i}
{chkacces.i}
/*-------------------- Входные параметры --------------------*/
Define Input Param RID as RecID no-undo.

/*-------------------- Объявление переменных --------------------*/

/*--------------- Буфера для полей БД: ---------------*/
Define Buffer buf_0_op               For op. /* Буфер для op, роль 'Главная таблица' */

/*--------------- Переменные для специальных полей: ---------------*/
Define Variable acct-cr          As Character            No-Undo.
Define Variable acct-cur         As Character            No-Undo.
Define Variable acct-db          As Character            No-Undo.
Define Variable banner           As Character            No-Undo.
Define Variable CrName           As Character Extent   2 No-Undo.
Define Variable Det              As Character Extent   6 No-Undo.
Define Variable endtext          As Character            No-Undo.
Define Variable PlBank           As Character Extent   2 No-Undo.
Define Variable PlName           As Character Extent   2 No-Undo.
Define Variable PoBank           As Character Extent   2 No-Undo.
Define Variable PoName           As Character Extent   2 No-Undo.
Define Variable Summa1           As Character            No-Undo.
Define Variable Summa2           As Character            No-Undo.
Define Variable Summa3           As Character            No-Undo.
Define Variable Summa4           As Character            No-Undo.
Define Variable Summa5           As Character            No-Undo.
Define Variable SummaStr         As Character Extent   3 No-Undo.
Define Variable theDate          As Character            No-Undo.
Define Variable val1             As Character            No-Undo.
Define Variable val2             As Character            No-Undo.
Define Variable val3             As Character            No-Undo.
Define Variable val4             As Character            No-Undo.
Define Variable Val5             As Character            No-Undo.

/*--------------- Определение форм для циклов ---------------*/

/* Начальные действия */
{wordwrap.def}

&SCOP OFFSigns
&SCOPED-DEFINE OFFinn

/*-----------------------------------------
   Проверка наличия записи главной таблицы,
   на которую указывает Input Param RID
-------------------------------------------*/
Find op Where RecID(op) = RID no-lock no-error.
If Not Avail(op) then do:
  message "Нет записи <op>".
  Return.
end.

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
        acct-db = op-entry.acct-db
        acct-cr = op-entry.acct-cr
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
              acct-db = op-entry.acct-db
              amt1 = op-entry.amt-rub
              val1 = "RUR"
            .
         end.
         else do:
            find first currency where 
                       currency.currency = op-entry.currency no-lock no-error.                        
            ASSIGN
              acct-db = op-entry.acct-db
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
                acct-cr = wop-entry.acct-cr
                amt3 = wop-entry.amt-rub
                val3 = "RUR"
           .
           end.      
           else do:
              find first currency where 
                   currency.currency = wop-entry.currency no-lock no-error.                        
              ASSIGN
                acct-cr = wop-entry.acct-cr
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

/*------------------------------------------------
   Вычислить значения специальных полей
   в соответствии с заданными в отчете правилами
------------------------------------------------*/
/* Вычисление значения специального поля acct-cr */
/* См. начальные действия */

/* Вычисление значения специального поля acct-cur */
/* См. начальные действия */

/* Вычисление значения специального поля acct-db */
/* См. начальные действия */

/* Вычисление значения специального поля banner */
{get_set.i "Банк"}

banner = setting.val.

/* Вычисление значения специального поля CrName */
{getcust2.i acct-cur CrName}.

/* Вычисление значения специального поля Det */
Det[1] = op.details.
{wordwrap.i &s=Det &n=6 &l=55}

/* Вычисление значения специального поля endtext */
{get_set2.i "Принтер" "PCL" "w/o chek"}

if ((not avail(setting) or (avail(setting) and trim(setting.val) = "")) and
   usr-printer begins "+") or
   (avail(setting) and can-do(setting.val, usr-printer)) then do:
  
   endtext = chr(12).
end.

/* Вычисление значения специального поля PlBank */
PlBank[1] = dept.name-bank.
{wordwrap.i &s=PlBank &l=42 &n=2}

/* Вычисление значения специального поля PlName */
{getcust2.i acct-db PlName}.

/* Вычисление значения специального поля PoBank */
find first setting where setting.code = "Банк" no-lock.
PoBank[1] = setting.val.
{wordwrap.i &s=PoBank &n=2 &l=42}

/* Вычисление значения специального поля PoName */
{getcust2.i acct-cr PoName}.

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

/* Вычисление значения специального поля SummaStr */
IF Val1 = "RUR" THEN DO:
  RUN x-amtstr.p(amt1,"", TRUE, TRUE, OUTPUT SummaStr[1], OUTPUT SummaStr[2]).
  IF TRUNC(amt1, 0) = amt1 THEN
    ASSIGN
      SummaStr[2] = ''
    .
  ELSE
    ASSIGN
      SummaStr[1] = SummaStr[1] + ' ' + SummaStr[2]
    .
  {wordwrap.i &s=SummaStr &n=3 &l=58}
  SUBSTR(SummaStr[1], 1, 1) = CAPS(SUBSTR(SummaStr[1], 1, 1)).
END.
ELSE DO:  
  RUN x-amtstr.p(amt2,"", TRUE, TRUE, OUTPUT SummaStr[1], OUTPUT SummaStr[2]).
  IF TRUNC(amt2, 0) = amt2 THEN
    ASSIGN
      SummaStr[2] = ''
    .
  ELSE
    ASSIGN
      SummaStr[1] = SummaStr[1] + ' ' + SummaStr[2]
    .
  {wordwrap.i &s=SummaStr &n=3 &l=58}
  SUBSTR(SummaStr[1], 1, 1) = CAPS(SUBSTR(SummaStr[1], 1, 1)).
END.

/* Вычисление значения специального поля theDate */
if op.doc-date <> ? then
  theDate = {strdate.i op.doc-date}.
else
  theDate = {strdate.i op.op-date}.

/* Вычисление значения специального поля val1 */
/* */

/* Вычисление значения специального поля val2 */
/* */

/* Вычисление значения специального поля val3 */
/* */

/* Вычисление значения специального поля val4 */
/* */

/* Вычисление значения специального поля Val5 */
/* */

/*-------------------- Формирование отчета --------------------*/
{strtout3.i &cols=84 &option=Paged}

put unformatted "" banner Format "x(60)"
                "" skip.
put skip(1).
put unformatted "                                       ╔════════╗" skip.
put unformatted "                  МЕМОРИАЛЬНЫЙ ОРДЕР N ║ " buf_0_op.doc-num Format "x(6)"
                " ║" skip.
put unformatted "                                       ╚════════╝" skip.
put unformatted "                        " theDate Format "x(20)"
                "" skip.
put unformatted "Плательщик                                        ДЕБЕТ              Сумма" skip.
put unformatted "" PlName[1] Format "x(42)"
                " ╔════════════════════╦══════════════════╗" skip.
put unformatted "" PlName[2] Format "x(42)"
                " ║" acct-db Format "x(20)"
                "║" val1 Format "x(3)"
                "" Summa1 Format "x(15)"
                "║" skip.
put unformatted " Банк плательщика                          ║                    ║                  ║" skip.
put unformatted "" PlBank[1] Format "x(42)"
                " ║                    ║" val2 Format "x(3)"
                "" Summa2 Format "x(15)"
                "║" skip.
put unformatted "" PlBank[2] Format "x(42)"
                " ║                    ║                  ║" skip.
put unformatted "═══════════════════════════════════════════╩сч.N════════════════╣                  ║" skip.
put unformatted "Получатель                                      КРЕДИТ          ║                  ║" skip.
put unformatted "" PoName[1] Format "x(42)"
                " ╔════════════════════╬══════════════════╣" skip.
put unformatted "" PoName[2] Format "x(42)"
                " ║" acct-cr Format "x(20)"
                "║" val3 Format "x(3)"
                "" Summa3 Format "x(15)"
                "║" skip.
put unformatted "Банк получателя                            ║                    ║                  ║" skip.
put unformatted "" PoBank[1] Format "x(42)"
                " ║                    ║" val4 Format "x(3)"
                "" Summa4 Format "x(15)"
                "║" skip.
put unformatted "" PoBank[2] Format "x(42)"
                " ║                    ║                  ║" skip.
put unformatted "═══════════════════════════════════════════╩сч.N════════════════╬══════════════════╣" skip.
put unformatted "                                                                ║                  ║" skip.
put unformatted "                                           ╔════════════════════╣                  ║" skip.
put unformatted "" CrName[1] Format "x(42)"
                " ║" acct-cur Format "x(20)"
                "║" Val5 Format "x(3)"
                "" Summa5 Format "x(15)"
                "║" skip.
put unformatted "" CrName[2] Format "x(42)"
                " ║                    ║                  ║" skip.
put unformatted "═ Сумма прописью ══════════════════════════╩сч.N════════════════╬═════╦════════════╣" skip.
put unformatted "" SummaStr[1] Format "x(58)"
                "      ║Вид  ║            ║" skip.
put unformatted "" SummaStr[2] Format "x(58)"
                "      ║опер.║            ║" skip.
put unformatted "" SummaStr[3] Format "x(58)"
                "      ╠═════╬════════════╣" skip.
put unformatted "                                                                ║Назн ║            ║" skip.
put unformatted "                                                                ║плат.║            ║" skip.
put unformatted "══Назначение платежа ═══════════════════════════════════════════╬═════╬════════════╣" skip.
put unformatted "" Det[1] Format "x(55)"
                "         ║Срок ║            ║" skip.
put unformatted "" Det[2] Format "x(55)"
                "         ║плат.║            ║" skip.
put unformatted "" Det[3] Format "x(55)"
                "         ╠═════╬════════════╣" skip.
put unformatted "" Det[4] Format "x(55)"
                "         ║Очер.║            ║" skip.
put unformatted "" Det[5] Format "x(55)"
                "         ║плат.║            ║" skip.
put unformatted "" Det[6] Format "x(55)"
                "         ╠═════╬════════════╣" skip.
put unformatted "                                                                ║N гр.║            ║" skip.
put unformatted "                                                                ║банка║            ║" skip.
put unformatted "                                                                ╚═════╩════════════╝" skip.
put unformatted "Бухгалтер                       Контролер" skip.
put skip(3).
put unformatted "" endtext Format "x(5)"
                "" skip.

{endout3.i &nofooter=yes}

