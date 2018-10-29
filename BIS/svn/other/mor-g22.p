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
     Filename: mor-g22.p
      Comment: Отчет, созданный генератором отчетов
      Comment:
   Parameters: Input: RID -  RecID(op)
         Uses: Globals.I ChkAcces.I SetDest.I PreView.I
      Used by:
      Created: 22/07/05 16:26:01
     Modified:
*/
Form "~n@(#) mor-g22.p 1.0 RGen 22/07/05 RGen 22/07/05 [ AutoReport By R-Gen ]"
     with frame sccs-id stream-io width 250.

{globals.i}
{chkacces.i}
/*-------------------- Входные параметры --------------------*/
Define Input Param RID as RecID no-undo.

/*-------------------- Объявление переменных --------------------*/

Define Buffer buf_0_op               For op.

/*--------------- Буфера для полей БД: ---------------*/

/*--------------- Переменные для специальных полей: ---------------*/
Define Variable amt-cur-s        As Character            No-Undo.
Define Variable amt-rub-         As Decimal              No-Undo.
Define Variable Amtp             As Character            No-Undo.
Define Variable Amtp1            As Character            No-Undo.
Define Variable bank             As Character            No-Undo.
Define Variable Cen              As Character Extent   4 No-Undo.
Define Variable cr               As Character            No-Undo.
Define Variable datap            As Character            No-Undo.
Define Variable db               As Character            No-Undo.
Define Variable DNum             As Character            No-Undo.
Define Variable endtext          As Character            No-Undo.
Define Variable NameCl           As Character Extent   2 No-Undo.
Define Variable Osn              As Character Extent   2 No-Undo.
Define Variable Q-t              As Character            No-Undo.
Define Variable textc            As Character Extent  10 No-Undo.
Define Variable user-op          As Character            No-Undo.

/*--------------- Определение форм для циклов ---------------*/

/* Начальные действия */
{wordwrap.def}
{get_set.i "Банк"}
bank = setting.val.
{get_set.i "БанкГород"}
bank = bank + " " + setting.val.
def var amt-     as DEC no-undo.
def var amt-cur- as dec no-undo.
def var passport_ as char no-undo.


find first op where recid(op) = RID no-lock.
find first op-entry of op where op-entry.acct-cat = "o" no-lock no-error.
if not available op-entry then do: 
   message "У документа отсутствует проводка".
   return. 
end.
/*{strval.i op-entry.amt-rub Amtp} 
if length(Amtp) > 66 then do: 
      Amtp1 = substring(Amtp,67,86).
end.*/

if op-entry.currency <> ? and op-entry.currency <> "" 
then do:
   amt-   = op-entry.amt-cur.
   amt-rub- = op-entry.amt-rub.
   amt-cur- = op-entry.amt-cur.
end.
else do:
   amt- = op-entry.amt-rub.
   amt-rub- = op-entry.amt-rub.
   amt-cur- = 0.
end.

find first _user where _user._userid = op.user-id no-error.
if avail _user then user-op = _user._user-name.
Run x-amtstr.p (amt-,op-entry.currency,true,true,output Amtp,output Amtp1).      
if trunc(amt-,0) = amt-                             
  then Amtp1 = ''. 
Amtp  = caps(substring(Amtp,1,1)) + substring(Amtp,2,65) .
Amtp= Amtp + ' ' + Amtp1.                         
if Length(Amtp) > 66 then do:                                         
 Assign  
  Amtp1 = Amtp
  Amtp  = SubStr(Amtp,1,R-Index(SubStr(Amtp,1,66),' ') - 1)
  Amtp1 = SubStr(Amtp1,Length(Amtp) + 1).
 end.                      
 else Amtp1 = ''. 
/*
{sum_str.i amt-cur-s amt-cur- zzzzzzzzzzzz9.99 No}
*/
amt-cur-s = string(amt-cur-, ">,>>>,>>9.99").

/*amt-cur-s = string(amt-cur-, if amt-cur- = 0 then ">>,>>>,>>>" else ">>,>>>,>>>.99").*/
/*
amt-cur-s = TRIM(amt-cur-s).
*/

assign
/*   Amtd  = string(op-entry.amt-rub)*/
   Q-t   = string(op-entry.qty,  ">>>>>" )
   datap = {term2str op.op-date op.op-date} 
   db    = op-entry.acct-db
   cr    = op-entry.acct-cr
.        
  FIND last signs WHERE signs.file EQ "op"
                  AND signs.code   EQ "НаимЦен"
                  and signs.surr   EQ  string(op.op)
                  NO-ERROR.


  if avail signs then do:
      Cen[1] =  trim(signs.xattr-value).
      {wordwrap.i &s=Cen &n=4 &l=45}         
  end.    


  FIND last signs WHERE signs.file EQ "op"
                  AND signs.code   EQ "ОснДок"
                  and signs.surr   EQ  string(op.op)
                  NO-ERROR.

  if avail signs then do:
      Osn[1] =  signs.xattr-value.
      {wordwrap.i &s=Osn &n=2 &l=75}         
  end.    
          
  FIND last signs WHERE signs.file EQ "op"
                  AND signs.code   EQ "Passport"
                  and signs.surr   EQ  string(op.op)
                  NO-ERROR.

  if avail signs then do:
      passport_ =  signs.xattr-value.       
  end.    


if Op.Name-Ben = "" then do:
 
   find first acct where acct.acct = op-entry.acct-cr no-lock no-error.
      {getcust.i &name = NameCl &OFFInn = yes}
      {wordwrap.i &s=NameCl &n=2 &l=52}         
end.
else do: 
     if Op.inn <> "" and op.inn <> ? then NameCl[1] = "ИНН " + Op.inn + " ".
        NameCl[1] =  NameCl[1]  +  Op.Name-Ben + " " + passport_.
       {wordwrap.i &s=NameCl &n=2 &l=52}         
end.


textc[1] = Op.Details.
{wordwrap.i &s=textc &n=4 &l=45}

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
/* Вычисление значения специального поля amt-cur-s */
/**/

/* Вычисление значения специального поля amt-rub- */
/**/

/* Вычисление значения специального поля Amtp */
/* {strval.i op-entry.amt-rub Amtp } */

/* Вычисление значения специального поля Amtp1 */
/**/

/* Вычисление значения специального поля bank */
/*
{get_set.i "Банк"}
bank = setting.val.
{get_set.i "БанкГород"}
bank = bank + " " + setting.val.

find first op-entry of op where op-entry.acct-cat = "b" no-lock no-error.
if not available op-entry then do: 
   message "У документа отсутствует проводка".
   return. 
end.
*/
/* {strval.i op-entry.amt-rub Amtp} */

/* Вычисление значения специального поля Cen */
/**/

/* Вычисление значения специального поля cr */
/* cr = op-entry.acct-db. */

/* Вычисление значения специального поля datap */
/**/

/* Вычисление значения специального поля db */
/* db = op-entry.acct-cr. */

/* Вычисление значения специального поля DNum */
DNum = op.doc-num.

/* Вычисление значения специального поля endtext */
/*
*/

/* Вычисление значения специального поля NameCl */
/*
*/

/* Вычисление значения специального поля Osn */
/**/

/* Вычисление значения специального поля Q-t */
/**/

/* Вычисление значения специального поля textc */
/**/

/* Вычисление значения специального поля user-op */
/**/

/*-------------------- Формирование отчета --------------------*/
{strtout3.i &cols=90 &option=Paged}

put unformatted "                                                                     ┌───────────────────┐" skip.
put unformatted "                                                                     │       0402102     │" skip.
put unformatted "    " Bank Format "x(52)"
                "             └───────────────────┘" skip.
put unformatted "    ── наименование учреждения банка ───────────────────              " datap Format "x(20)"
                "" skip.
put unformatted "                                               ┌──────┐                ──────────────────" skip.
put unformatted "    МЕМОРИАЛЬНыЙ ОРДЕР ПО ПРИЕМУ ЦЕННОСТЕЙ   N │" DNum Format "x(6)"
                "│                    дата выдачи" skip.
put unformatted "                                               └──────┘              ДЕБЕТ" skip.
put unformatted "    ┌────────────────────┐                                ┌──────────────────────────────┐" skip.
put unformatted "    │" datap Format "x(20)"
                "│                                │Сч.N " db Format "x(25)"
                "│" skip.
put unformatted "    └────────────────────┘                                └──────────────────────────────┘" skip.
put unformatted "                                                                     КРЕДИТ" skip.
put unformatted "    ─────────────────────                                 ┌──────────────────────────────┐" skip.
put unformatted "       дата зачисления                                    │Сч.N " cr Format "x(25)"
                "│" skip.
put unformatted "                                                          └──────────────────────────────┘" skip.
put unformatted "    " NameCl[1] Format "X(52)"
                "" skip.
put unformatted "    " NameCl[2] Format "x(52)"
                "" skip.
put unformatted "    ──── кому принадлежат ценности ───────────────────────" skip.
put unformatted "    Описание операции: " textc[1] Format "x(45)"
                "" skip.
put unformatted "                       " textc[2] Format "x(45)"
                "" skip.
put unformatted "                       " textc[3] Format "x(45)"
                "" skip.
put unformatted "                       " textc[4] Format "x(45)"
                "" skip.
put unformatted "    Основание: " Osn[1] Format "  x(75)"
                "" skip.
put unformatted "               " Osn[2] Format "x(75)"
                "" skip.
put unformatted "    ─────────────────────────────────────────────┬──────┬────────────────┬────────────────" skip.
put unformatted "       Наименование ценностей                    │Колич.│ Сумма в ин.вал.│  Сумма в руб." skip.
put unformatted "    ─────────────────────────────────────────────┼──────┼────────────────┼────────────────" skip.
put unformatted "  " cen[1] Format "  x(45)"
                "│" Q-t Format "x(6)"
                "│ " amt-cur-s Format "x(12)"
                "   │ " amt-rub- Format ">>,>>>,>>>.99"
                "" skip.
put unformatted "    ─────────────────────────────────────────────┼──────┼────────────────┼────────────────" skip.
put unformatted "    " cen[2] Format "x(45)"
                "│      │                │" skip.
put unformatted "    ─────────────────────────────────────────────┼──────┼────────────────┼────────────────" skip.
put unformatted "    " cen[3] Format "x(45)"
                "│      │                │" skip.
put unformatted "    ─────────────────────────────────────────────┼──────┼────────────────┼────────────────" skip.
put unformatted "    " cen[4] Format "x(45)"
                "│      │                │" skip.
put unformatted "    ─────────────────────────────────────────────┼──────┼────────────────┼────────────────" skip.
put unformatted "                                    ИТОГО...     │" Q-t Format "x(6)"
                "│ " amt-cur-s Format "x(12)"
                "   │ " amt-rub- Format ">>,>>>,>>>.99"
                "" skip.
put unformatted "                                                 └──────┴────────────────┴────────────────" skip.
put unformatted "    Сумма прописью руб. " Amtp Format "x(66)"
                "" skip.
put unformatted "    " Amtp1 Format "x(86)"
                "" skip.
put unformatted " " skip.
put skip(1).
put unformatted "    Указанную сумму внес _______________  Подпись исполнителя:___________/" user-op Format "x(15)"
                "/" skip.
put unformatted "                             (подпись)" skip.
put unformatted "                                          Подпись контролера:_____________________" skip.
put unformatted " " skip.
put unformatted "                                          Подпись кассира:________________________" skip.
put unformatted " " skip.
put unformatted "    --------------------------------------------------------------------------------------" skip.
put unformatted "    " endtext Format "x(5)"
                "" skip.

{endout3.i &nofooter=yes}

