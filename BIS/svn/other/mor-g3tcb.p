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
    Copyright: (C) 1992-2007 ТОО "Банковские информационные системы"
     Filename: mor-g3tcb.p
      Comment: Отчет, созданный генератором отчетов
      Comment:
   Parameters: Input: RID -  RecID(op)
         Uses: Globals.I ChkAcces.I SetDest.I PreView.I
      Used by:
      Created: 19/01/07 09:02:44
     Modified:
*/
Form "~n@(#) mor-g3tcb.p 1.0 RGen 19/01/07 RGen 19/01/07 [ AutoReport By R-Gen ]"
     with frame sccs-id stream-io width 250.

{globals.i}
{chkacces.i}
/*-------------------- Входные параметры --------------------*/
Define Input Param RID as RecID no-undo.

/*-------------------- Объявление переменных --------------------*/

Define Buffer buf_0_op               For op.

/*--------------- Буфера для полей БД: ---------------*/

/*--------------- Переменные для специальных полей: ---------------*/
Define Variable Amtd             As Character            No-Undo.
Define Variable Amtp             As Character            No-Undo.
Define Variable Amtp1            As Character            No-Undo.
Define Variable bank             As Character            No-Undo.
Define Variable cr               As Character            No-Undo.
Define Variable datap            As Character            No-Undo.
Define Variable db               As Character            No-Undo.
Define Variable DNum             As Character            No-Undo.
Define Variable NameCl           As Character Extent   2 No-Undo.
Define Variable PrinCen          As Character            No-Undo.
Define Variable Q-t              As Character            No-Undo.
Define Variable textc            As Character Extent   4 No-Undo.

/*--------------- Определение форм для циклов ---------------*/

/* Начальные действия */
{wordwrap.def}
{get_set.i "Банк"}
DEFINE VARIABLE dbcr AS CHARACTER. 
define variable summ as decimal NO-UNDO.
bank = setting.val.
find first op where recid(op) = RID no-lock.
find first op-entry of op where op-entry.acct-cat = "o" no-lock no-error.
if not available op-entry then do: 
   message "У документа отсутствует проводка".
   return. 
end.

if op-entry.currency <> ? and op-entry.currency <> "" then
   summ = op-entry.amt-cur.
   else
   summ = op-entry.amt-rub.

Run x-amtstr.p (summ,op-entry.currency,true,true,output Amtp,output Amtp1).
Amtp  = caps(substring(Amtp,1,1)) + substring(Amtp,2,65) .
Amtp= Amtp + ' ' + Amtp1.
if Length(Amtp) > 66 then do:
   Assign
    Amtp1 = Amtp
    Amtp  = SubStr(Amtp,1,R-Index(SubStr(Amtp,1,66),' ') - 1)
    Amtp1 = SubStr(Amtp1,Length(Amtp) + 1).
   end.
   else Amtp1 = ''.

/* {strval.i op-entry.amt-rub Amtp}
if length(Amtp) > 66 then do: 
      Amtp1 = substring(Amtp,67,86).
end.      
Amtp  = caps(substring(Amtp,1,1)) + substring(Amtp,2,65) .
*/
{sum_str.i Amtd op-entry.amt-rub zzzzzzzzzzzzzz9.99 Yes}
Amtd = string (summ, ">>>,>>>,>>>,>>>.99").
assign
/*   Amtd  = string(op-entry.amt-rub)*/
   Q-t   = string(op-entry.qty,  ">>>>>" )
   datap = {term2str op.doc-date op.doc-date} 
   db    = op-entry.acct-db
   cr    = op-entry.acct-cr
   dbcr =  if db begins "99999" then cr else db  .        
find first acct where acct.acct = dbcr   no-lock no-error.
if not available acct then do:
       {message &text      = "| Нет такого счета ! "
                &alert-box = error
                &buttons   = ok
                &beep      = yes  }
       return.
end.

IF cr begins "99999" then 
   do:
      find first acct where acct.acct = db no-lock no-error.
      if avail acct then PrinCen = acct.details.
   end. else 
   do:
      find first acct where acct.acct = cr no-lock no-error.
      if avail acct then PrinCen = acct.details.
   end.

if Op.Name-Ben = "" then do: 
        {getcust.i &name = NameCl} 
        if length(NameCl[1]) < 52 
           then NameCl[1] = substring(NameCl[1] + " " + NameCl[2],1,52).
           else NameCl[1] = substring(NameCl[1],1,52).
end.
ELSE
DO:
/*   NameCl[1] = "ИНН " + Op.inn.*/
   NameCl[1] = (IF NameCl[1] EQ ? OR NameCl[1] EQ "ИНН " THEN "" ELSE NameCl[1]) + " " + Op.Name-Ben.
   NameCl[1] = substring(NameCl[1],1,90) .
   
   /* Бурягин Е.П. 27.11.2007 14:20 добавил код, который вытягивает паспортные данные из д.р.
      "Passport"
   */
   NameCl[1] = trim(NameCl[1]) + " " + GetXAttrValueEx("op", STRING(op.op), "Passport", "").
   /** Перенос по словам */
   {wordwrap.i &s=NameCl &n=2 &l=90}
END.
     FIND last signs WHERE signs.file EQ "op"
                     AND signs.code EQ "НаимЦен"
                     and signs.surr EQ string(op.op)
                     NO-ERROR.
                     
     If avail signs then do:
       textc[1] = trim(signs.xattr-value).
       {wordwrap.i &s=textc &n=4 &l=45}
     end.
     else do:                                        
       textc[1] = Op.Details.
       {wordwrap.i &s=textc &n=4 &l=45}
     end.

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
/* Вычисление значения специального поля Amtd */
/**/

/* Вычисление значения специального поля Amtp */
/* {strval.i op-entry.amt-rub Amtp } */

/* Вычисление значения специального поля Amtp1 */
/**/

/* Вычисление значения специального поля bank */
/*
{get_set.i "Банк"}
bank = setting.val.
find first op-entry of op where op-entry.acct-cat = "b" no-lock no-error.
if not available op-entry then do: 
   message "У документа отсутствует проводка".
   return. 
end.
*/
/* {strval.i op-entry.amt-rub Amtp} */

/* Вычисление значения специального поля cr */
/* cr = op-entry.acct-cr. */

/* Вычисление значения специального поля datap */
/**/

/* Вычисление значения специального поля db */
/* db = op-entry.acct-db. */

/* Вычисление значения специального поля DNum */
DNum = op.doc-num.

/* Вычисление значения специального поля NameCl */
/**/

/* Вычисление значения специального поля PrinCen */
/**/

/* Вычисление значения специального поля Q-t */
/**/

/* Вычисление значения специального поля textc */
/**/

/*-------------------- Формирование отчета --------------------*/
{strtout3.i &cols=102 &option=Paged}

put unformatted "                                                           ┌───────────────────────────┐" skip.
put unformatted "                                                           │Код формы документа по ОКУД│" skip.
put unformatted "                                                           ├───────────────────────────┤" skip.
put unformatted "      " bank Format "x(40)"
                "             │         0402102           │" skip.
put unformatted "      ── наименование учреждения банка ───────             └───────────────────────────┘" skip.
put unformatted "                                                 ┌──────┐" skip.
put unformatted "      МЕМОРИАЛЬНЫЙ ОРДЕР ПО ПРИЕМУ ЦЕННОСТЕЙ   № │" DNum Format "x(6)"
                "│          ────────────────────" skip.
put unformatted "      ┌────────────────────┐                     └──────┘              дата выдачи" skip.
put unformatted "      │" datap Format "x(20)"
                "│" skip.
put unformatted "      └────────────────────┘                                           ДЕБЕТ" skip.
put unformatted "                                                        ┌──────────────────────────────┐" skip.
put unformatted "      ─────────────────────                             │Сч.№ " db Format "x(25)"
                "│" skip.
put unformatted "         дата зачисления                                └──────────────────────────────┘" skip.
put unformatted "      " PrinCen Format "x(60)"
                "     КРЕДИТ" skip.
put unformatted "      ── кому принадлежат ценности ─────────────────────┌──────────────────────────────┐" skip.
put unformatted "                                                        │Сч.№ " cr Format "x(25)"
                "│" skip.
put unformatted "                                                        └──────────────────────────────┘" skip.
put unformatted "      ┌─────────────────────────────────────────────┬──────┬────────────────────────────" skip.
put unformatted "      │   Наименование ценностей                    │Колич.│          СУММА" skip.
put unformatted "      ├─────────────────────────────────────────────┼──────┼────────────────────────────" skip.
put unformatted "      │" textc[1] Format "x(45)"
                "│" Q-t Format "x(6)"
                "│     " Amtd Format "x(18)"
                "" skip.
put unformatted "      ├─────────────────────────────────────────────┼──────┼────────────────────────────" skip.
put unformatted "      │" textc[2] Format "x(45)"
                "│      │" skip.
put unformatted "      ├─────────────────────────────────────────────┼──────┼────────────────────────────" skip.
put unformatted "      │" textc[3] Format "x(45)"
                "│      │" skip.
put unformatted "      ├─────────────────────────────────────────────┼──────┼────────────────────────────" skip.
put unformatted "      │" textc[4] Format "x(45)"
                "│      │" skip.
put unformatted "      └─────────────────────────────────────────────┼──────┼────────────────────────────" skip.
put unformatted "                                       ИТОГО        │" Q-t Format "x(6)"
                "│     " Amtd Format "x(18)"
                "" skip.
put unformatted "                                                    └──────┴────────────────────────────" skip.
put skip(1).
put unformatted "      Сумма прописью " Amtp Format "x(71)"
                "" skip.
put unformatted "      " Amtp1 Format "x(86)"
                "" skip.
put skip(1).
put unformatted "      Означенные ценности внес" skip.
put unformatted "      " NameCl[1] Format "x(90)" skip
                "      " NameCl[2] Format "x(90)"
                "" skip.
put skip(1).
put unformatted " " skip.
put unformatted "      Подписи" skip.
put unformatted " " skip.
put unformatted "                                   ─────────────────────────          ────────────────────────────────" skip.
put skip(1).
put unformatted "      Принял кассир" skip.
put unformatted "                                   ─────────────────────────          ────────────────────────────────" skip.
put skip(1).
put unformatted " " skip.
put skip(31).
put unformatted " " skip.
put skip(1).
put unformatted " " skip.
put unformatted "                                                           ┌───────────────────────────┐" skip.
put unformatted "                                                           │Код формы документа по ОКУД│" skip.
put unformatted "                                                           ├───────────────────────────┤" skip.
put unformatted "      " bank Format "x(40)"
                "             │         0402102           │" skip.
put unformatted "      ── наименование учреждения банка ───────             └───────────────────────────┘" skip.
put unformatted "                                                 ┌──────┐" skip.
put unformatted "      ЯРЛЫК, СОПРОВОЖДАЮЩИЙ ЦЕННОСТЬ           № │" Dnum Format "x(6)"
                "│          ────────────────────" skip.
put unformatted "      ┌────────────────────┐                     └──────┘              дата выдачи" skip.
put unformatted "      │" datap Format "x(20)"
                "│" skip.
put unformatted "      └────────────────────┘                                           ДЕБЕТ" skip.
put unformatted "                                                        ┌──────────────────────────────┐" skip.
put unformatted "      ─────────────────────                             │Сч.№ " db Format "x(25)"
                "│" skip.
put unformatted "         дата зачисления                                └──────────────────────────────┘" skip.
put unformatted "      " PrinCen Format "x(60)"
                "     КРЕДИТ" skip.
put unformatted "      ── кому принадлежат ценности ─────────────────────┌──────────────────────────────┐" skip.
put unformatted "                                                        │Сч.№ " cr Format "x(25)"
                "│" skip.
put unformatted "                                                        └──────────────────────────────┘" skip.
put unformatted "      ┌─────────────────────────────────────────────┬──────┬────────────────────────────" skip.
put unformatted "      │   Наименование ценностей                    │Колич.│          СУММА" skip.
put unformatted "      ├─────────────────────────────────────────────┼──────┼────────────────────────────" skip.
put unformatted "      │" textc[1] Format "x(45)"
                "│" Q-t Format "x(6)"
                "│     " Amtd Format "x(18)"
                "" skip.
put unformatted "      ├─────────────────────────────────────────────┼──────┼────────────────────────────" skip.
put unformatted "      │" textc[2] Format "x(45)"
                "│      │" skip.
put unformatted "      ├─────────────────────────────────────────────┼──────┼────────────────────────────" skip.
put unformatted "      │" textc[3] Format "x(45)"
                "│      │" skip.
put unformatted "      ├─────────────────────────────────────────────┼──────┼────────────────────────────" skip.
put unformatted "      │" textc[4] Format "x(45)"
                "│      │" skip.
put unformatted "      └─────────────────────────────────────────────┼──────┼────────────────────────────" skip.
put unformatted "                                       ИТОГО        │" Q-t Format "x(6)"
                "│     " Amtd Format "x(18)"
                "" skip.
put unformatted "                                                    └──────┴────────────────────────────" skip.
put skip(1).
put unformatted "      Сумма прописью " Amtp Format "x(71)"
                "" skip.
put unformatted "      " Amtp1 Format "x(86)"
                "" skip.
put skip(1).
put unformatted "      Означенные ценности внес" skip.
put unformatted "      " NameCl[1] Format "x(90)" skip
                "      " NameCl[2] Format "x(90)"
                "" skip.
put skip(2).
put unformatted "      Подписи" skip.
put skip(1).
put unformatted "                                   ─────────────────────────          ────────────────────────────────" skip.
put skip(1).
put unformatted "      Принял кассир" skip.
put unformatted "                                   ─────────────────────────          ────────────────────────────────" skip.

/* Конечные действия */
page.


{endout3.i &nofooter=yes}

