{pirsavelog.p}


                   /*******************************************
                    *                                         *
                    *  ГОСПОДА ПРОГРАММИСТы И СОЧУВСТВУЮЩИЕ!  *
                    *                                         *
                    *  РЕДАКТИРОВАТЬ ДАННыЙ ФАЙЛ БЕСПОЛЕЗНО,  *
                    *  Т.К. ОН СОЗДАЕТСЯ ГЕНЕРАТОРОМ ОТЧЕТОВ  *
                    *             АВТОМАТИЧЕСКИ!              *
                    *                                         *
                    *******************************************/

/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2005 ТОО "Банковские информационные системы"
     Filename: memirk.p
      Comment: Отчет, созданный генератором отчетов
      Comment:
   Parameters: Input: RID -  RecID(op)
         Uses: Globals.I ChkAcces.I SetDest.I PreView.I
      Used by:
      Created: 22/07/05 19:00:10
     Modified:
*/
Form "~n@(#) memirk.p 1.0 RGen 22/07/05 RGen 22/07/05 [ AutoReport By R-Gen ]"
     with frame sccs-id stream-io width 250.

{globals.i}
{chkacces.i}
/*-------------------- Входные параметры --------------------*/
Define Input Param RID as RecID no-undo.

/*-------------------- Объявление переменных --------------------*/

Define Buffer buf_0_op               For op.

/*--------------- Буфера для полей БД: ---------------*/

/*--------------- Переменные для специальных полей: ---------------*/
Define Variable Address          As Character            No-Undo.
Define Variable AmtAll           As Decimal              No-Undo.
Define Variable amtr             As Decimal              No-Undo.
Define Variable amtv             As Decimal              No-Undo.
Define Variable bn               As Character            No-Undo.
Define Variable cr               As Character            No-Undo.
Define Variable DateDoc          As Character            No-Undo.
Define Variable db               As Character            No-Undo.
Define Variable det              As Character Extent   6 No-Undo.
Define Variable GrKol            As Integer              No-Undo.
Define Variable ispol            As Character            No-Undo.
Define Variable Ndoc             As Character            No-Undo.

/*--------------- Определение форм для циклов ---------------*/
/* Форма для цикла "cycle" */
Form
  "│" at 1 db format "x(20)" at 2 "│" at 22 cr format "x(20)" at 23 "│" at 43 amtv format "->>>>>>>>9.99" at 44 "│" at 57 amtr format "->>>>>>>>9.99" at 58 "│" at 71 det[1] format "x(50)" at 72 "│" at 122 skip
  "│                    │                    │             │             │" at 1 det[2] format "x(50)" at 72 "│" at 122 skip
  "│                    │                    │             │             │" at 1 det[3] format "x(50)" at 72 "│" at 122 skip
  "│                    │                    │             │             │" at 1 det[4] format "x(50)" at 72 "│" at 122 skip
  "│                    │                    │             │             │" at 1 det[5] format "x(50)" at 72 "│" at 122 skip
  "│                    │                    │             │             │" at 1 det[6] format "x(50)" at 72 "│" at 122 skip
Header
  "┌────────────────────┬────────────────────┬───────────────────────────┬──────────────────────────────────────────────────┐" at 1 skip
  "│       ДЕБЕТ        │       КРЕДИТ       │           СУММА           │                                                  │" at 1 skip
  "│                    │                    │   Инвалюты       Рублей   │                                                  │" at 1 skip
  "├────────────────────┼────────────────────┼─────────────┬─────────────┼──────────────────────────────────────────────────┤" at 1 skip
with frame frm_-1 down no-labels no-underline no-box width 122.

Form
  "├────────────────────┴────────────────────┴─────────────┴─────────────┴──────────────────────────────────────────────────┤" at 1 skip
  "│       СТРОК:" at 1 GrKol format ">>>>>9" at 16 "                       ИТОГО:" at 22 AmtAll format "->>>>>>>>9.99" at 58 "                                                   │" at 71 skip
  "└────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘" at 1 skip
with frame frm_1 down no-labels no-underline no-box width 122.
Def Var FH_memirk-1 as integer init 10 no-undo. /* frm_1: мин. строк до перехода на новую страницу */


/* Начальные действия */
{wordwrap.def}

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
/* Т.к. не задано правило для выборки записей из главной таблицы,
   просто выставим его buffer на input RecID                    */
find buf_0_op where RecID(buf_0_op) = RecID(op) no-lock.

/*------------------------------------------------
   Вычислить значения специальных полей
   в соответствии с заданными в отчете правилами
------------------------------------------------*/
/* Вычисление значения специального поля Address */
{get_set.i "Адрес_Юр"}
Address = setting.val.

/* Вычисление значения специального поля AmtAll */
/* В цикле */

/* Вычисление значения специального поля amtr */
/* в цикле */

/* Вычисление значения специального поля amtv */
/*  */

/* Вычисление значения специального поля bn */
{get_set.i "БАНК"}
bn = setting.val.

/* Вычисление значения специального поля cr */
/* в цикле */

/* Вычисление значения специального поля DateDoc */
if op.doc-date <> ? then
  if op.doc-date = op.ins-date then
     DateDoc = {strdate.i op.doc-date}.
  else
     DateDoc = {strdate.i op.ins-date}.
else
  DateDoc = {strdate.i op.op-date}.

/* Вычисление значения специального поля db */
/* в цикле */

/* Вычисление значения специального поля det */
det[1] = op.details.
{wordwrap.i &s = det &n=6 &l=50}

/* в цикле */

/* Вычисление значения специального поля GrKol */
/* в циклике */

/* Вычисление значения специального поля ispol */
find first _user where _user._userid = user no-lock no-error.
 ispol = _user._user-name.

/* Вычисление значения специального поля Ndoc */
NDoc = op.doc-num.

/*-------------------- Формирование отчета --------------------*/
{strtout3.i &cols=122 &option=Paged}

put unformatted "" bn Format "x(40)"
                "                                            ┌──────────┐               ┌─────────" skip.
put unformatted "" Address Format "x(40)"
                "                                            │ Форма 7а │               │  Лист 1 │" skip.
put unformatted "                                                                                    └──────────┘               └─────────┘" skip.
put unformatted "                                           МЕМОРИАЛЬНыЙ ОРДЕР " Ndoc Format "x(9)"
                "" skip.
put skip(1).
put unformatted "                                            " DateDoc Format "x(30)"
                "" skip.

/* Начало цикла "cycle" */
do:
  def buffer xop-entry for op-entry.
  def var fl as log init true.
  
  def var amtd like op-entry.amt-cur.
  def var amtc like op-entry.amt-cur.
  
  AmtAll = 0.
  GrKol  = 0.
  
  for each op-entry of op no-lock:
  
  if fl and op-entry.acct-cr = ? then do:
     fl = false.
     next.
  end.
  
  GrKol = GrKol + 1.
  
  if op-entry.acct-db = ? then do:
     cr = op-entry.acct-cr.      
     if op-entry.acct-cr begins "61306" then do:
        find first xop-entry of op where xop-entry.acct-db = ? no-lock no-error.
        if avail xop-entry then do:
           db   = xop-entry.acct-cr.
           amtr = op-entry.amt-rub.
           amtd = 0.
           amtc = 0.
        end.
     end.      
     else do:
        find first xop-entry of op where xop-entry.acct-cr = ? no-lock no-error.
        if avail xop-entry then do:      
           db = xop-entry.acct-db.   
           if op-entry.currency ne "" and xop-entry.currency  ne "" then do:
              amtr = xop-entry.amt-rub.
              amtd = xop-entry.amt-cur.
              amtc = op-entry.amt-cur.    
           end.   
           else do:
              if op-entry.currency ne "" and xop-entry.currency eq "" then do:
                 amtr = op-entry.amt-rub.
                 amtd = 0.
                 amtc = op-entry.amt-cur.
              end.
              if op-entry.currency eq "" and xop-entry.currency ne "" then do:
                 amtr = xop-entry.amt-rub.
                 amtd = xop-entry.amt-cur.
                 amtc = 0.
              end.   
           end.
        end.        
     end.   
  end.
  else do:
     if op-entry.acct-cr = ? then do:
        db = op-entry.acct-db.   
        if op-entry.acct-db begins "61406" then do:
           find first xop-entry of op where 
                      xop-entry.acct-cr = ? no-lock no-error.
           if avail xop-entry then do:
              cr   = xop-entry.acct-db.
              amtr = op-entry.amt-rub.
              amtd = 0.
              amtc = 0.
           end.
        end.   
        else do:   
           find first xop-entry of op 
                where xop-entry.acct-db = ? no-lock no-error.
           if avail xop-entry then do:
              cr = xop-entry.acct-cr.                            
              if op-entry.currency ne "" and xop-entry.currency ne "" then do:
                 amtr = op-entry.amt-rub. 
                 amtd = op-entry.amt-cur.
                 amtc = xop-entry.amt-cur.
              end.
              else do:
                 if op-entry.currency ne "" 
                                  and xop-entry.currency eq "" then do:
                    amtr = op-entry.amt-rub.
                    amtd = op-entry.amt-cur.
                    amtc = 0.
                 end.
                 if op-entry.currency eq "" 
                                  and xop-entry.currency ne "" then do:
                    amtr = xop-entry.amt-rub.               
                    amtd = 0.
                    amtc = xop-entry.amt-cur.
                 end.   
              end.
           end.
        end.   
     end.            
     else do:
        db = op-entry.acct-db.
        cr = op-entry.acct-cr.   
        if op-entry.currency = "" then do:
           amtr = op-entry.amt-rub.
           amtd = 0.
           amtc = 0.
        end.
        else do: 
           find first acct where acct.acct = op-entry.acct-db no-lock no-error.
           if avail acct and acct.currency ne "" then do:         
              amtr = op-entry.amt-rub.
              amtd = op-entry.amt-cur.
              amtv = op-entry.amt-cur.
              amtc = 0.
           end.
           find first acct where 
                      acct.acct = op-entry.acct-cr no-lock no-error.
           if avail acct and acct.currency ne "" then do:
              amtr = op-entry.amt-rub.
              amtd = 0.
              amtc = op-entry.amt-cur.
              amtv = op-entry.amt-cur.     
           end.         
        end.   
  
        if can-find(first acct where acct.acct begins op-entry.acct-db
                                 and acct.currency ne "") and
           can-find(first acct where acct.acct begins op-entry.acct-cr
                                 and acct.currency ne "") then do:
                                 
           amtr = op-entry.amt-rub.
           amtd = op-entry.amt-cur.
           amtc = op-entry.amt-cur.  
           amtv = op-entry.amt-cur.            
        end.
     end.
  end.         
  
  AmtAll = AmtAll + Amtr.

  Disp
    db
    cr
    amtv
    amtr
    det
    det
    det
    det
    det
    det
  with frame frm_-1.
  if Line-Count + FH_memirk-1 >= Page-Size and Page-Size <> 0 then do:
    Disp
      GrKol
      AmtAll
    with frame frm_1.
    Page.
  end.
  else
    Down with frame frm_-1.
  end.
end.
if Line-Count > 1 or Page-Size = 0 then do:
  Disp
    GrKol
    AmtAll
  with frame frm_1.
end.
/* Конец цикла "cycle" */

put skip(2).
put unformatted "Приложение на         листах" skip.
put unformatted "              ───────" skip.
put skip(1).
put unformatted " " skip.
put skip(1).
put unformatted "Контролер               Исполнитель " ispol Format "x(30)"
                "" skip.
put skip(3).
put unformatted " " skip.

{endout3.i &nofooter=yes}

