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
     Filename: ob-vznalv.p
      Comment: Отчет, созданный генератором отчетов
      Comment:
   Parameters: Input: RID -  RecID(op)
         Uses: Globals.I ChkAcces.I SetDest.I PreView.I
      Used by:
      Created: 08/11/06 15:50:48
     Modified:
*/
Form "~n@(#) ob-vznalv.p 1.0 RGen 08/11/06 RGen 08/11/06 [ AutoReport By R-Gen ]"
     with frame sccs-id stream-io width 250.

{globals.i}
{chkacces.i}
/*-------------------- Входные параметры --------------------*/
Define Input Param RID as RecID no-undo.

/*-------------------- Объявление переменных --------------------*/

Define Buffer buf_0_op               For op.

/*--------------- Буфера для полей БД: ---------------*/

/*--------------- Переменные для специальных полей: ---------------*/
Define Variable acct-db-t        As Character            No-Undo.
Define Variable BIC              As Character            No-Undo.
Define Variable DateStr          As Character            No-Undo.
Define Variable det              As Character Extent   3 No-Undo.
Define Variable Detal            As Character Extent   6 No-Undo.
Define Variable detl             As Character Extent   6 No-Undo.
Define Variable Name-Bank        As Character            No-Undo.
Define Variable openacct-cr      As Character            No-Undo.
Define Variable PlName           As Character Extent   3 No-Undo.
Define Variable PoName           As Character Extent   2 No-Undo.
Define Variable sAccCr           As Character Extent  10 No-Undo.
Define Variable sAmt1            As Character            No-Undo.
Define Variable sAmt3            As Character            No-Undo.
Define Variable sAmtCr           As Character Extent  10 No-Undo.
Define Variable sKasCr           As Character Extent  10 No-Undo.
Define Variable SumStr           As Character Extent   3 No-Undo.

/*--------------- Определение форм для циклов ---------------*/

/* Начальные действия */
{wordwrap.def}                                                               
{sumstrfm.i}
                                                                               Def Var pn as char extent 2 no-undo. /* Temp 4 PolName */
/*{get-fmt.i &obj=-Acct-Fmt}*/           /* Формат вывода счетов - default */

function AmtPrint returns char (input anAmt as decimal).
    def var sFmt as char init "x(13)" no-undo.
    assign sFmt = sFmt + if( anAmt = trunc(anAmt, 0) ) then "=" else "-x(2)".
    return left-trim( string(string(anAmt * 100, "->>>>>>>>>>>999"), sFmt) ).
end.

def var i    as int     init 1   no-undo.
def var nAmt as decimal init 0.0 no-undo.

find first op where recid( op ) = RID no-lock no-error.
for each op-entry of op no-lock:
    if( i > 10 ) then leave.
    accumulate op-entry.amt-rub (total).
    assign
        sAccCr[i] = if( op-entry.acct-cr = ? ) then ""
                    else op-entry.acct-cr
        sAmtCr[i] = TRIM(AmtStrFormat(op-entry.amt-rub, "-zzzzzzzzzz9=99"))
        sKasCr[i] = op-entry.symbol 
    .
    assign i = i + 1.
end.
assign nAmt = accum total op-entry.amt-rub.
find first op-entry of op no-lock no-error.

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
/* Вычисление значения специального поля acct-db-t */
acct-db-t = op-entry.acct-db.

/* Вычисление значения специального поля BIC */
/*

find first sys-dept no-lock.

find first banks where banks.name = sys-dept.name-bank no-lock no-error.

find first banks-code where

                      banks-code.bank-id = banks.bank-id and

                      banks-code.bank-code-type = 'BIC'

                      no-lock no-error.



BIC = if avail(banks-code) then banks-code.bank-code else "".

*/

find first setting where setting.code = "БанкМФО" no-lock.

BIC = setting.val.

/* Вычисление значения специального поля DateStr */
if op.doc-date <> ? then

  DateStr = {strdate.i op.doc-date}.

else

  DateStr = {strdate.i op.op-date}.

/* Вычисление значения специального поля det */
Det[1] = op.detail.
{wordwrap.i &s=det &n=3 &l=56}

/* Вычисление значения специального поля Detal */
Detal[1] = op.detail.
{wordwrap.i &s=detal &n=5 &l=56}

/* Вычисление значения специального поля detl */
detl[1] = op.detail.
{wordwrap.i &s=detl &n=4 &l=56}

/* Вычисление значения специального поля Name-Bank */
Name-Bank = dept.name-bank.

/* Вычисление значения специального поля openacct-cr */
find first op-entry of op no-lock.

openacct-cr = if op-entry.acct-cr <> ? then op-entry.acct-cr 

              else "".

/* Вычисление значения специального поля PlName */
if op.name-ben <> '' and op.name-ben <> ? then do:

  PlName[1] = op.name-ben.

  {wordwrap.i &s=PlName &n=3 &l=37}

end. else do:

  find first acct where

                  acct.acct = op-entry.acct-cr

                  no-lock.

  if acct.cust-cat = 'В' then do:


     IF FGetSetting('ПлатДок', 'ВыводИНН', 'Да') EQ 'Да' THEN
     DO:
        PlName[1] = 'ИНН ' +  FGetSetting('ИНН', '', '').
     END.

    PlName[1] = PlName[1] + ' ' + FGetSetting('Банк', '', '').

    {wordwrap.i &s=PlName &n=3 &l=37}

  end.

  else do:


     IF FGetSetting('ПлатДок', 'ВыводИНН', 'Да') EQ 'Да' THEN
     DO:
        {getcust2.i op-entry.acct-cr PlName}
     END.
     ELSE
     DO:
        &GLOBAL-DEFINE OFFInn YES
        {getcust2.i op-entry.acct-cr PlName}
        &UNDEFINE OFFInn 
     END.

    PlName[1] = PlName[1] + PlName[2].

    {wordwrap.i &s=PlName &n=3 &l=37}

  end.

end.

/* Вычисление значения специального поля PoName */
find first acct where

                acct.acct = op-entry.acct-cr

                no-lock.

if acct.cust-cat = 'В' then do:


   IF FGetSetting('ПлатДок', 'ВыводИНН', 'Да') EQ 'Да' THEN
   DO:
      Pn[1] = 'ИНН ' +  FGetSetting('ИНН', '', '').
   END.

   PN[1] = PN[1] + ' ' + FGetSetting('Банк', '', '').

end.

else do:

  IF FGetSetting('ПлатДок', 'ВыводИНН', 'Да') EQ 'Да' THEN
  DO:
     {getcust2.i op-entry.acct-cr PN}
  END.
  ELSE
  DO:
     &GLOBAL-DEFINE OFFInn YES
     {getcust2.i op-entry.acct-cr PN}
     &UNDEFINE OFFInn 
  END.

  pn[1] = pn[1] + pn[2].

end.

Assign

  PoName[1] = pn[1]

  PoName[2] = ''

  .

{wordwrap.i &s=PoName &n=2 &l=46}

/* Вычисление значения специального поля sAccCr */
/* см. начальные действия */

/* Вычисление значения специального поля sAmt1 */
ASSIGN sAmt1 = TRIM(AmtStrFormat(nAmt, "->>>>>>>>>>9=99")).
       /*sAmt1 = FILL(CHR(205), 24 - LENGTH(sAmt1)) + sAmt1.*/

/* Вычисление значения специального поля sAmt3 */
assign sAmt3 = TRIM(AmtStrFormat(nAmt, "->>>>>>>>>>9=99")).

/* Вычисление значения специального поля sAmtCr */
/* см. начальные действия */

/* Вычисление значения специального поля sKasCr */
/* см. начальные действия */

/* Вычисление значения специального поля SumStr */
DEFINE VARIABLE mchAmt AS CHARACTER NO-UNDO.
DEFINE VARIABLE mchDec AS CHARACTER NO-UNDO.
RUN x-amtstr.p (nAmt,
                "",
                NO,
                NO,
                OUTPUT mchAmt, OUTPUT mchDec).


SumStr[1] = "Сумма прописью " + TRIM(mchAmt) + " руб. " + TRIM(mchDec) + " коп.".
{wordwrap.i  &s=SumStr &n=3 &l=84 &LEFT_AND_RIGHT=YES}
SumStr[1] = SumStr[1] + FILL(CHR(205), 84 - LENGTH(SumStr[1])).
SumStr[2] = SumStr[2] + FILL(CHR(205), 84 - LENGTH(SumStr[2])).
SumStr[3] = SumStr[3] + FILL(CHR(205), 84 - LENGTH(SumStr[3])).

/*-------------------- Формирование отчета --------------------*/
{strtout3.i &cols=93 &option=Paged}

put unformatted "                                                                 ┌──────────────────┐" skip.
put unformatted "                                                                 │  ВЕЧЕРНЯЯ КАССА  │" skip.
put unformatted "                                                                 └──────────────────┘" skip.
put unformatted "                                        ┌──────────┐                     ┌──────────┐" skip.
put unformatted "                   ОБЪЯВЛЕНИЕ N         │  " buf_0_op.doc-num Format "x(6)"
                "  │                     │  0402001 │" skip.
put unformatted "                   на взнос наличными   └──────────┘                     └──────────┘" skip.
put unformatted "                   " DateStr Format "x(20)"
                "        Для зачисл.┌─────────────────────────┐" skip.
put unformatted " От кого " PlName[1] Format "x(37)"
                "  на счет N │                         │" skip.
put unformatted " " PlName[2] Format "x(45)"
                "            │" openacct-cr Format "x(25)"
                "│" skip.
put unformatted " " PlName[3] Format "x(45)"
                "            │                         │" skip.
put unformatted " ─────────────────────────────────────────────────────────┼─────────────────────────┤" skip.
put unformatted " Банк получателя " Name-Bank Format "x(40)"
                " │" sAmt1 Format "x(24)"
                " │" skip.
put unformatted " ─────────────────────────────────────────────────────────┤                         │" skip.
put unformatted " Получатель " PoName[1] Format "x(46)"
                "│      Сумма цифрами      │" skip.
put unformatted " " PoName[2] Format "x(57)"
                "└─────────────────────────┘" skip.
put skip(1).
put unformatted " " SumStr[1] Format "x(84)"
                "" skip.
put unformatted " " SumStr[2] Format "x(84)"
                "" skip.
put unformatted " " SumStr[3] Format "x(84)"
                "" skip.
put unformatted " ────────────────────────────────────────────────────────────────────────────────────" skip.
put unformatted " Источник взноса  " detl[1] Format "x(56)"
                "" skip.
put unformatted "                  " detl[2] Format "x(56)"
                "" skip.
put unformatted "                  " detl[3] Format "x(56)"
                "" skip.
put unformatted "                  " detl[4] Format "x(56)"
                "" skip.
put unformatted " ────────────────────────────────────────────────────────────────────────────────────" skip.
put unformatted " Подпись вносителя                               Бухгалтер" skip.
put unformatted "                                                 Деньги принял кассир" skip.
put unformatted " " skip.
put unformatted " ───────────────────────────────────────┬──────────┬─────────────────────┬──────────┐" skip.
put unformatted "                   КВИТАНЦИЯ N          │  " buf_0_op.doc-num Format "x(6)"
                "  │                     │  0402001 │" skip.
put unformatted "                                        └──────────┘                     └──────────┘" skip.
put unformatted "                   " DateStr Format "x(20)"
                "        Для зачисл.┌─────────────────────────┐" skip.
put unformatted " От кого " PlName[1] Format "x(37)"
                "  на счет N │                         │" skip.
put unformatted " " PlName[2] Format "x(45)"
                "            │" openacct-cr Format "x(25)"
                "│" skip.
put unformatted " " PlName[3] Format "x(45)"
                "            │                         │" skip.
put unformatted " ─────────────────────────────────────────────────────────┼─────────────────────────┤" skip.
put unformatted " Банк получателя " Name-Bank Format "x(40)"
                " │                         │" skip.
put unformatted " ─────────────────────────────────────────────────────────┤" sAmt1 Format "X(24)"
                " │" skip.
put unformatted " Получатель " PoName[1] Format "x(46)"
                "│                         │" skip.
put unformatted " " PoName[2] Format "x(57)"
                "│      Сумма цифрами      │" skip.
put unformatted " ─────────────────────────────────────────────────────────└─────────────────────────┘" skip.
put unformatted " " SumStr[1] Format "X(84)"
                "" skip.
put unformatted " " SumStr[2] Format "X(84)"
                "" skip.
put unformatted " " SumStr[3] Format "X(84)"
                "" skip.
put unformatted " ────────────────────────────────────────────────────────────────────────────────────" skip.
put unformatted " Источник взноса  " Det[1] Format "x(56)"
                "" skip.
put unformatted "                  " Det[2] Format "x(56)"
                "" skip.
put unformatted "                  " Det[3] Format "x(56)"
                "" skip.
put unformatted " ────────────────────────────────────────────────────────────────────────────────────" skip.
put unformatted " М.П.                 Бухгалтер                  Деньги принял кассир" skip.
put unformatted " " skip.
put unformatted " ───────────────────────────────────────┬──────────┬─────────────────────┬──────────┐" skip.
put unformatted "                   ОРДЕР N              │  " buf_0_op.doc-num Format "x(6)"
                "  │                     │  0402001 │" skip.
put unformatted "                                        └──────────┘                     └──────────┘" skip.
put unformatted "                                                       Д Е Б Е Т              С у м м а" skip.
put unformatted "                   " DateStr Format "x(20)"
                "        ┌─────────────────────────┬──────────────────┐" skip.
put unformatted " От кого " PlName[1] Format "x(37)"
                " │" acct-db-t Format "x(25)"
                "│" sAmt3 Format "x(18)"
                "│" skip.
put unformatted " " PlName[2] Format "x(45)"
                " └─────────────────────────┤                  │" skip.
put unformatted " " PlName[3] Format "x(45)"
                "        К Р Е Д И Т        │      Общая       │" skip.
put unformatted " ────────────────────────────────────┬─────────┬─────────────────────────┼───────────────┬──┤" skip.
put unformatted " Банк получателя                     │" BIC Format "x(9)"
                "│" sAccCr[1] Format "x(25)"
                "│    частные    │КС│" skip.
put unformatted " " Name-Bank Format "x(36)"
                "│   код   │                         ├───────────────┼──┤" skip.
put unformatted " ────────────────────────────────────┴─────────┤                         │" sAmtCr[1] Format "x(15)"
                "│" sKasCr[1] Format "xx"
                "│" skip.
put unformatted " Получатель                                    │                         │" sAmtCr[2] Format "x(15)"
                "│" sKasCr[2] Format "xx"
                "│" skip.
put unformatted " " PoName[1] Format "x(46)"
                "│                         │" sAmtCr[3] Format "x(15)"
                "│" sKasCr[3] Format "xx"
                "│" skip.
put unformatted " " PoName[2] Format "x(46)"
                "│                         │" sAmtCr[4] Format "x(15)"
                "│" sKasCr[4] Format "xx"
                "│" skip.
put unformatted "                                               │                         │" sAmtCr[5] Format "x(15)"
                "│" sKasCr[5] Format "xx"
                "│" skip.
put unformatted "                                               │                         │" sAmtCr[6] Format "x(15)"
                "│" sKasCr[6] Format "xx"
                "│" skip.
put unformatted "                                               │                         │" sAmtCr[7] Format "x(15)"
                "│" sKasCr[7] Format "xx"
                "│" skip.
put unformatted "                                               │                         │" sAmtCr[8] Format "x(15)"
                "│" sKasCr[8] Format "xx"
                "│" skip.
put unformatted "                                               │                         │" sAmtCr[9] Format "x(15)"
                "│" sKasCr[9] Format "xx"
                "│" skip.
put unformatted "                                               │         Счет N          │               │  │" skip.
put unformatted " ──────────────────────────────────────────────┴─────────────────────────┴───────────────┴──┘" skip.
put unformatted " Источник взноса  " Detal[1] Format "x(56)"
                "" skip.
put unformatted "                  " Detal[2] Format "x(56)"
                "" skip.
put unformatted "                  " Detal[3] Format "x(56)"
                "" skip.
put unformatted "                  " Detal[4] Format "x(56)"
                "" skip.
put unformatted " ────────────────────────────────────────────────────────────────────────────────────" skip.
put unformatted " Бухгалтер                   Кассир" skip.

{endout3.i &nofooter=yes}

