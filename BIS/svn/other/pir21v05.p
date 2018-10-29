{pirsavelog.p}

/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2001 ТОО "Банковские информационные системы"
     Filename: p21v75.p
      Comment: ВАЛЮТНЫЕ КАССОВЫЕ ДОКУМЕНТЫ  для класса i56_1
   Parameters:
         Uses:
      Used by:
      Created: 18.10.2001 Olenka
     Modified: 01/04/2002 Olenka - использован GetXattrValue вместо GetSigns
     Modified: 22/10/2004 ABKO   - Выбор формы отчета (прежн. и с разбивкой по валютам)
     Modified:

*/
Form "~n@(#) p21v75.p Olenka 18/10/2001 ВАЛЮТНЫЕ КАССОВЫЕ ДОКУМЕНТЫ  для класса i56_1"
with frame sccs-id stream-io width 250.

def input param in-data-id like DataBlock.Data-Id no-undo.
def input param vNumPril as char no-undo.

{globals.i}
{norm.i}
{wordwrap.def}
{tmprecid.def}        /** Используем информацию из броузера */

find DataBlock where DataBlock.Data-Id eq in-Data-Id no-lock no-error.
find first DataClass where DataClass.DataClass-id = entry(1,DataBlock.DataClass-id,'@') no-lock.

def var name as char extent 4 format "x(15)" no-undo.
assign 
    name[1] = "1. Приходные документы"
    name[2] = "2. Расходные документы"
    name[3] = "3. Мемориальные документы по приходу"
    name[4] = "4. Мемориальные документы по расходу"
.

def var xresult as dec no-undo.
def var ii as int no-undo.
def var i as int no-undo.
def var str as char extent 6 format "x(15)" no-undo.
def var indeks as char no-undo.


def temp-table t_56 no-undo
    field i as int 
    field curr as char format "xxx"
    field cnt05 as dec format ">>>>>>9"
    field cnt75 as dec format ">>>>>>9"
    field sum05  as dec    format "->>>>,>>>,>>>,>>9.99"
    field sum05_rub as dec format "->>>>,>>>,>>>,>>9.99"
    field sum75 as dec     format "->>>>,>>>,>>>,>>9.99"
index i_curr i curr.                

if datablock.branch-id = "00002" then
DO:
run br-user.p (4).


FOR EACH tmprecid:
FIND FIRST _user WHERE RECID(_user) = tmprecid.id NO-LOCK NO-ERROR.

for each DataLine of DataBlock where
         DataLine.Sym3 > "" and 
	 ENTRY(1, DataLine.Sym1, "_") = _user._userid no-lock:

    if DataLine.Sym2 = "b" and DataLine.Sym4 = "db" then i = 1.
    if DataLine.Sym2 = "b" and DataLine.Sym4 = "cr" then i = 2.
    if DataLine.Sym2 = "o" and DataLine.Sym4 = "db" then i = 3.
    if DataLine.Sym2 = "o" and DataLine.Sym4 = "cr" then i = 4.

    find first t_56 where
               t_56.i = i and
               t_56.curr = DataLine.Sym3 no-error.
    if not avail t_56 then do:
       create t_56.
       assign t_56.i = i
              t_56.curr = DataLine.Sym3 .
    end.
    assign t_56.cnt75 = t_56.cnt75 + DataLine.Val[8]
           t_56.cnt05 = t_56.cnt05 + DataLine.Val[6]
           t_56.sum75 = t_56.sum75 + DataLine.Val[3]
           t_56.sum05 = t_56.sum05 + DataLine.Val[1]
           t_56.sum05_rub = t_56.sum05_rub + DataLine.Val[2]
    .
end.
END.
END.
 ELSE 
DO:
for each DataLine of DataBlock where
         DataLine.Sym3 > "" no-lock:

    if DataLine.Sym2 = "b" and DataLine.Sym4 = "db" then i = 1.
    if DataLine.Sym2 = "b" and DataLine.Sym4 = "cr" then i = 2.
    if DataLine.Sym2 = "o" and DataLine.Sym4 = "db" then i = 3.
    if DataLine.Sym2 = "o" and DataLine.Sym4 = "cr" then i = 4.

    find first t_56 where
               t_56.i = i and
               t_56.curr = DataLine.Sym3 no-error.
    if not avail t_56 then do:
       create t_56.
       assign t_56.i = i
              t_56.curr = DataLine.Sym3 .
    end.
    assign t_56.cnt75 = t_56.cnt75 + DataLine.Val[8]
           t_56.cnt05 = t_56.cnt05 + DataLine.Val[6]
           t_56.sum75 = t_56.sum75 + DataLine.Val[3]
           t_56.sum05 = t_56.sum05 + DataLine.Val[1]
           t_56.sum05_rub = t_56.sum05_rub + DataLine.Val[2]
    .
end.
END.

DEF VAR vForma AS CHAR VIEW-AS RADIO-SET 
                       RADIO-BUTTONS "c Рублевым эвивалентом","o",
                                     "с разбивкой по валютам","n"
                       LABEL "Вид справки" NO-UNDO INIT "n".
DEFINE FRAME fFr
   vForma
   WITH SIDE-LABELS CENTERED OVERLAY
        TITLE COLOR BRIGTH-WHITE "[ Выберете форму печати ]".

ON "RETURN":U OF vForma IN FRAME fFr APPLY "GO":U.

DO ON ENDKEY UNDO, LEAVE:
   UPDATE vForma WITH FRAME fFr.
END.
HIDE FRAME fFr NO-PAUSE.
IF KEYFUNC (LASTKEY) EQ "end-error" THEN
   RETURN.
   
    if datablock.branch-id = "00001" then 
	do : indeks = "12-3".
    end.	
    if datablock.branch-id = "00002" then 
	do : indeks = "12-1-1".
    end.
   
&SCOPED width 108

IF vForma EQ "n" THEN
DO:
   {setdest.i &cols = 82}
   
       
   FOR EACH currency NO-LOCK:
      IF NOT CAN-FIND(FIRST t_56 WHERE t_56.curr EQ currency.currency) THEN
         NEXT.

 if datablock.branch-id = "00002" then
  do:
   put skip
"                                                            ┌───────────────────┐" skip
"                                                            │    ОБСЛУЖИВАНИЕ   │" skip
"                                                            │В ПОСЛЕОПЕРАЦИОННОЕ│" skip
"                                                            │       ВРЕМЯ       │" skip
"                                                            └───────────────────┘" skip. 
 end.

       RUN stdhdr_1.p (output xResult, DataBlock.beg-date,DataBlock.end-date,
                         "80," + vNumPril + ",||Срок хранения 5 лет,
                         к Положению ЦБР № 199-П|от 9 октября 2002г.,
                         |ВАЛЮТНЫЕ_КАССОВЫЕ_ДОКУМЕНТЫ (" + currency.currency + ")||ЗА_&1|Индекс № " + indeks + ",
   
			 no,YES").

      PUT UNFORMATTED SKIP
"┌───────────────┬─────────────────────┬─────────────────────────────────────────┐" SKIP
"│    Кассовые   │  Количество (штук)  │              Сумма (" STRING(TRIM(currency.name-currenc),"X(11)") ")        │" SKIP
"│   документы   ├──────────┬──────────┼────────────────────┬────────────────────┤" SKIP
"│               │  Всего   │В отд.пап.│        Всего       │ В отдельных папках │" SKIP.

      DO ii = 1 TO 4:
      
         IF NOT CAN-FIND(FIRST t_56 WHERE t_56.i EQ ii and t_56.curr = currency.currency) THEN
         DO:
          
            CREATE t_56.
            ASSIGN
               t_56.i    = ii
               t_56.curr = currency.currency
               .
           
         END.

         PUT UNFORMATTED
"├───────────────┼──────────┼──────────┼────────────────────┼────────────────────┤" SKIP.
         str[1] = name[ii].
         {wordwrap.i &s=str &l=15 &n=6}

         PUT UNFORMATTED 
"│" STRING(str[1],"X(15)") "│          │          │                    │                    │" SKIP.
         i = 2.
         DO WHILE str[i] NE ""
              AND i LE 6:  
            PUT UNFORMATTED 
"│" STRING(str[i],"X(15)") "│          │          │                    │                    │" SKIP.
            i = i + 1.
         END.
         FOR EACH t_56 WHERE t_56.i = ii
                         AND t_56.curr EQ currency.currency
             NO-LOCK:
            
            PUT UNFORMATTED
               "│" AT 1 "│" AT 17
               t_56.cnt05 AT 19 "│" AT 28
             /*  t_56.cnt75 AT 30 */ "│" AT 39
               t_56.sum05 format "->>>>,>>>,>>>,>>9.99" AT 40 "│" AT 60
             /*  t_56.sum75 AT 61 */ "│" AT 81 SKIP .
         END.
      END.
      PUT UNFORMATTED
"└───────────────┴──────────┴──────────┴────────────────────┴────────────────────┘" SKIP.

      {sign_kas.i}
/*      {signatur.i &user-only = yes }
 */
      IF PAGE-SIZE NE 0 THEN
         PAGE.
      ELSE
         PUT UNFORMATTED
            SKIP(3)
            FILL("-",40)
         .
   END. /* for each currency */
END.
ELSE DO:
{setdest.i &cols = {&width}}

 if datablock.branch-id = "00002" then
  do:
   put skip
"                                                            ┌───────────────────┐" skip
"                                                            │    ОБСЛУЖИВАНИЕ   │" skip
"                                                            │В ПОСЛЕОПЕРАЦИОННОЕ│" skip
"                                                            │       ВРЕМЯ       │" skip
"                                                            └───────────────────┘" skip. 
 end.


run pirstdhdr_p.p (output xResult, DataBlock.beg-date,DataBlock.end-date,
               "{&width}," + vNumPril + ",в руб.,|Валютные_кассовые_документы|срок_хранения_5_лет||ЗА_&1|Индекс № " + indeks + ",no").

put skip
"┌───────────────┬─────┬─────────────────────┬──────────────────────────────────────────────────────────────┐" skip
"│    Кассовые   │ Вал │  Количество (штук)  │                             Сумма                            │" skip
"│   документы   │     ├──────────┬──────────┼────────────────────┬────────────────────┬────────────────────┤" skip
"│               │     │  Всего   │В отд.пап.│        Всего       │ Рублевый эквивалент│ В отдельных папках │" skip.

do ii = 1 to 4:
   if not can-find(first t_56 where t_56.i = ii) then do:
      create t_56.
      assign t_56.i = ii t_56.curr = "   " .
   end.

   put
"├───────────────┼─────┼──────────┼──────────┼────────────────────┼────────────────────┼────────────────────┤" skip.

   str[1] = name[ii].
   {wordwrap.i &s=str &l=15 &n=6}

   put "│" at 1 str[1] at 2 "│" at 17 "│" at 23 "│" at 34 "│" at 45 "│" at 66 "│" at 87 "│" at 108 skip.
   do i = 2 to 6:
      if str[i] <> "" then 
         put "│" at 1 str[i] at 2 "│" at 17 "│" at 23 "│" at 34 "│" at 45 "│" at 66 "│" at 87 "│" at 108 skip.
      else leave.
   end.
   for each t_56 where t_56.i = ii no-lock break by t_56.curr :
      put "│" at 1 "│" at 17
           t_56.curr  at 19 "│" at 23
           t_56.cnt05 at 25 "│" at 34
          /* t_56.cnt75 at 36 */ "│" at 45
           t_56.sum05 at 46 "│" at 66
           t_56.sum05_rub at 67 "│" at 87
          /* t_56.sum75 at 88 */ "│" at 108 skip .
   end.
end.
put
"└───────────────┴─────┴──────────┴──────────┴────────────────────┴────────────────────┴────────────────────┘" skip.

{sign_kas.i}
/* {signatur.i &user-only = yes }
 */
END.


{preview.i }

