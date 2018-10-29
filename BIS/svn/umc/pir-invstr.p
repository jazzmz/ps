{pirsavelog.p}

/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2000 ТОО "Банковские информационные системы"
     Filename: invstr.p
      Comment: Инвентарная опись с итогами по странице.
               Подключается в CTRL-G в браузер по картотеке
   Parameters:
         Uses:
      Used by:
      Created: shin 15/07/02
     Modified:
*/

{globals.i}
DEFINE INPUT PARAMETER iParmStr AS CHARACTER NO-undo.

{intrface.get umc}
{tmprecid.def}        /** Используем информацию из броузера */

{get-bankname.i}

{justasec}

DEF VAR a-disc          AS DEC  NO-UNDO {&SF} COLUMN-LABEL "БАЛ.СТОИМОСТЬ".
DEF VAR a-qty           AS DEC  NO-UNDO {&QLF}.
def var ttemp as dec NO-UNDO.
def var kolvo as dec NO-UNDO.
def var cAcct as char NO-UNDO.
def var asset-cost as dec NO-UNDO.

DEF VAR Sliteral        AS CHAR NO-UNDO.  /* Run amtstr needed */
DEF VAR S2literal       AS CHAR NO-UNDO.
DEF VAR Digital         AS DEC  NO-UNDO.
DEF VAR Absent2         AS LOG  NO-UNDO.
DEF VAR PageWidth       AS INT  NO-UNDO INITIAL 175.
DEF VAR okpo            AS CHAR NO-UNDO.
DEF VAR oAcct AS TAcct.
DEF VAR counter         AS INT  NO-UNDO.
DEF VAR absent          AS LOG  NO-UNDO.

DEF VAR TotalFCost      AS DEC  NO-UNDO.
DEF VAR TotalFQuantity  AS DEC  NO-UNDO.
DEF VAR TotalBCost      AS DEC  NO-UNDO.
DEF VAR TotalBQuantity  AS DEC  NO-UNDO.
DEF VAR TotalCounter    AS DEC  NO-UNDO.
DEF VAR GTotalFCost     AS DEC  NO-UNDO.
DEF VAR GTotalFQuantity AS DEC  NO-UNDO.
DEF VAR GTotalBCost     AS DEC  NO-UNDO.
DEF VAR GTotalBQuantity AS DEC  NO-UNDO.
DEF VAR GTotalCounter   AS DEC  NO-UNDO.

DEF VAR rasp            AS CHAR Format "x(8)" NO-UNDO.
DEF VAR date1           AS CHAR Format "x(8)"  NO-UNDO.
DEF VAR date2           AS CHAR Format "x(8)"  NO-UNDO.
DEF VAR daterasp        AS CHAR Format "x(8)"  NO-UNDO.
DEF VAR secAcct 	AS CHAR FORMAT "x(5)"  NO-UNDO.

DEF VAR day             AS date NO-undo.

DEF VAR dol1            AS CHAR NO-UNDO.
DEF VAR dol2            AS CHAR NO-UNDO.
DEF VAR dol3            AS CHAR NO-UNDO.
DEF VAR dol4            AS CHAR NO-UNDO.
DEF VAR dol5            AS CHAR NO-UNDO.
DEF VAR dol6            AS CHAR NO-UNDO.
DEF VAR dol7            AS CHAR NO-UNDO.
DEF VAR fam1            AS CHAR NO-UNDO.
DEF VAR fam2            AS CHAR NO-UNDO.
DEF VAR fam3            AS CHAR NO-UNDO.
DEF VAR fam4            AS CHAR NO-UNDO.
DEF VAR fam5            AS CHAR NO-UNDO.
DEF VAR fam6            AS CHAR NO-UNDO.
DEF VAR fam7            AS CHAR NO-UNDO.

DEF VAR vidcen          AS CHAR NO-UNDO.
DEF VAR vidcen2         AS CHAR NO-UNDO.


DEF FRAME fSet 
   "Номер приказа о инвентаризации:" rasp SKIP(1) 
   "Дата документа:" daterasp SKIP(1)
   "Дата начала инвентаризации:" date1 SKIP(1)
   "Дата окончания инвентаризации:"  date2 SKIP(1)
   "Счет 2 порядка по внебалансу:" secAcct SKIP
   WITH CENTERED NO-LABELS TITLE "Введите данные".

DEFINE TEMP-TABLE x-rated NO-UNDO
  field   number          as int
  field   acct            like acct.acct
  field   AssetName       like asset.name
  field   cont-tp         like asset.cont-type
  field   InventoryNumber as char form "x(18)"
  field   passNumber      as char form "x(15)"
  field   ascost          as dec format "zzzzzzzzz9.99"
  field   aunit           as char format "x(5)"
  field   FQuantity       as dec form "-zzz,zzz,zzz,zz9.99"
  field   FCost           as dec form "-zzz,zzz,zzz,zz9.99"
  field   BQuantity       as dec form "-zzz,zzz,zzz,zz9.99"
  field   BCost           as dec form "-zzz,zzz,zzz,zz9.99"
  field   als             as int
  field   Npage           as int
index pi InventoryNumber.
.



{get_set.i "ОКПО"}
okpo = setting.val.

   /* Названия месяцев */
   DEF VAR vMonthNam    AS CHAR    NO-UNDO EXTENT 12 INIT
                 [ "  января" , "  февраля", "  марта"    ,
                   "  апреля" , "  мая"    , "  июня"    ,
                   "  июля"   , "  августа" , "  сентября",
                   "  октября", "  ноября" , "  декабря"
                 ].
                 
                                        .
IF iParmstr = "ОС" then do: vidcen = "ОСНОВНЫХ СРЕДСТВ". vidcen2 = "основных средств". end.
IF iParmstr = "НЕМАТ" then do: vidcen = "НЕМАТЕРИАЛЬНЫЕ АКТИВЫ". vidcen2 = "нематериальных активов". end.
IF iParmstr = "ЭКСП" then  do: vidcen = "МАТЕРИАЛЬНЫЕ ЦЕННОСТИ В ЭКСПЛУАТАЦИИ". vidcen2 = "материальных ценностей в эксплуатации". end.
IF iParmstr = "СКЛАД" then do: vidcen = "МАТЕРИАЛЬНЫЕ ЦЕННОСТИ НА СКЛАДЕ". vidcen2 = "материальных ценностей на складе". end.
IF iParmstr = "МЦА" then do: vidcen = "МАТЕРИАЛЬНЫЕ ЦЕННОСТИ В АРЕНДЕ". vidcen2 = "материальных ценностей в аренде". end.
IF iParmstr = "" then vidcen = "".

rasp = FGetSetting("Инвентаризация","rasp",?).
date1 = FGetSetting("Инвентаризация","date1",?).
date2 = FGetSetting("Инвентаризация","date2",?).
daterasp = FGetSetting("Инвентаризация","daterasp",?).

DISPLAY rasp daterasp date1 date2 secAcct WITH FRAME fSet.

SET rasp daterasp date1 date2 secAcct WITH FRAME fSet.

HIDE FRAME fSet.

dol1 = FGetSetting("Инвентаризация","dol1",?).
dol2 = FGetSetting("Инвентаризация","dol2",?).
dol3 = FGetSetting("Инвентаризация","dol3",?).
dol4 = FGetSetting("Инвентаризация","dol4",?).
dol5 = FGetSetting("Инвентаризация","dol5",?).
dol6 = FGetSetting("Инвентаризация","dol6",?).
dol7 = FGetSetting("Инвентаризация","dol7",?).

fam1 = FGetSetting("Инвентаризация","fam1",?).
fam2 = FGetSetting("Инвентаризация","fam2",?).
fam3 = FGetSetting("Инвентаризация","fam3",?).
fam4 = FGetSetting("Инвентаризация","fam4",?).
fam5 = FGetSetting("Инвентаризация","fam5",?).
fam6 = FGetSetting("Инвентаризация","fam6",?).
fam7 = FGetSetting("Инвентаризация","fam7",?).

day = date(date1).
{get_set.i "Банк"}

{setdest.i &cols=" + PageWidth "}

Put Unformatted
  fill(" ", 58) + "                               Унифицированная форма N " "ИНВ-3" skip
  fill(" ", 58) + "Утверждена Постановлением Госкомстата России от 18.08.98 N 88" skip
  String(setting.val, "x(120)") skip

"                                                                                                              ┌────────┐" skip
"                                                                                                              │Код     │" skip
"                                                                                                              ├────────┤" skip
"                                                                                                Форма по ОКУД │0317004 │" skip
"                                                                                                              ├────────┤" skip
"                                                                                                      по ОКПО │" okpo "│" skip
"                                                                                                              ├────────┤" skip
"                                                                                                              │        │" skip
"                                                                                                              ├────────┤" skip
"                                                                                             Вид деятельности │        │" skip
"                                                                                                   ┌──────────┼────────┤" skip
"                                     Основание для                      приказ                     │ Номер    │"rasp format 'x(8)'"│" skip
"                                     проведения        ────────────────────────────────────────────┼──────────┼────────┤" skip
"                                     инвентаризации:                                               │ Дата     │"daterasp format 'x(8)'"│" skip
"                                                                                                   └──────────┼────────┤" skip
"                                                                                   Дата начала инвентаризации │"date1 format 'x(8)'"│" skip
"                                                                                                              ├────────┤" skip
"                                                                                Дата окончания инвентаризации │"date2 format 'x(8)'"│" skip
"                                                                                                              ├────────┤" skip
"                                                                                                 Вид операции │        │" skip
"                                                                                                              └────────┘" skip
"                                                                                                     ┌───────┬─────────┐" skip
"                                                                                                     │Номер  │  Дата   │" skip
"                                                                                                     │док-та │  док-та │" skip
"                                                                                                     ├───────┼─────────┤" skip
"                                                                                                     │       │         │" skip
"                                                                                                     └───────┴─────────┘" skip

  fill(" ", 14) "ИНВЕНТАРИЗАЦИОННАЯ ОПИСЬ ТОВАРНО-МАТЕРИАЛЬНЫХ ЦЕННОСТЕЙ"  skip(1)
  fill(" ", 34) vidcen skip
  "                                                     вид товарно-материальных ценнностей                              " skip
"находящиеся ________________" + cBankName + "_____________________________________________________________________"  skip
  "                         в собственности организации, полученные для переработки                                      " skip(1)
  fill(" ", 32) "РАСПИСКА" skip.

    put unformatted
    "К началу проведения инвентаризации все расходные и приходные документы на товарно-материальные ценности сданы в   " skip
    "бухгалтерию,  и все товарно-материальные ценности, поступившие на мою (нашу) ответственность, оприходованы,       " skip
    "а выбывшие списаны в расход." skip
    "Лицо(а), ответственное(ые) за сохранность " vidcen2 ":"  skip (1).

  put unformatted
  "Начальник Д1       ___________  Беляева И.В." skip
  "   должность       подпись    расшифровка подписи       " skip(1)
  "Управляющий делами   ________________  Чечулин М.М." skip
  "   должность       подпись    расшифровка подписи       " skip(1)
  "Заведующий складом   ________________  Захарина Т.А." skip
  "   должность       подпись    расшифровка подписи       " skip(1)
  "Произведено снятие фактических остатков ценностей по состоянию на " skip
  " " day(day) "" vMonthNam[month(day)] " " year(day) "г." skip
.
page.
  Put Unformatted  skip(1)
    "┌────┬────────────────────┬──────────────────────────────────────────────────────────┬──────────┬─────────────┬─────────────────────────────────┬───────────────────────────┬───────────────────────────┐" skip
    "│Но- │    Счет, субсчет   │             Товарно-материальные  ценности               │ Единица  │    Цена     │             Номер               │     Фактическое наличие   │         По данным         │" skip
    "│мер │                    │                                                          │измерения │    руб.     │                                 │                           │    бухгалтерского учета   │" skip
    "│по  │                    │                                                          │          │    коп.     │                                 │                           │                           │" skip
    "│по- │                    │                                                          │          │             │                                 │                           │                           │" skip
    "│ряд-│                    ├─────────────────────────────────────┬────────────────────┼────┬─────┤             ├──────────────────┬──────────────┼─────┬─────────────────────┼─────┬─────────────────────┤" skip
    "│ку  │                    │            Наименование             │ код (номенклатурный│код │наим.│             │  Инвентарный     │   Паспорт    │ Кол.│  Сумма, руб. коп.   │ Кол.│ Сумма, руб. коп.    │" skip
    "│    │                    │                                     │       номер)       │    │     │             │                  │              │     │                     │     │                     │" skip
    "├────┼────────────────────┼─────────────────────────────────────┼────────────────────┼────┼─────┼─────────────┼──────────────────┼──────────────┼─────┼─────────────────────┼─────┼─────────────────────┤" skip
    "│ 1  │         2          │                  3                  │          4         │ 5  │  6  │      7      │        8         │       9      │ 10  │         11          │ 12  │        13           │" skip
    "├────┼────────────────────┼─────────────────────────────────────┼────────────────────┼────┼─────┼─────────────┼──────────────────┼──────────────┼─────┼─────────────────────┼─────┼─────────────────────┤" skip.

FOR
   EACH  tmprecid,

   FIRST loan WHERE
         RECID(loan) = tmprecid.id
      NO-LOCK,

   FIRST asset OF loan
      NO-LOCK

   BY loan.cont-code:

/*   Absent = NO.*/

 /*  message asset.name asset.cost VIEW-AS ALERT-BOX.*/

   RUN GetLoanPos IN h_umc (loan.contract,
                            loan.cont-code,
                            "-учет",
                            gend-date,
                            OUTPUT a-disc,
                            OUTPUT a-qty
                           ).
if GetXattrValue("loan",loan.contract + "," + loan.cont-code,"АрендаКолво") <> "" OR GetXattrValue("loan",loan.contract + "," + loan.cont-code,"АрендаКолво") <> ? then 
DO:
   
   IF NOT CAN-FIND(FIRST x-rated WHERE
                         x-rated.Inventorynumber = loan.cont-code
                  ) THEN
   DO:

         if secAcct = "91502" then
         cAcct = GetXattrValue("loan",loan.contract + "," + loan.cont-code,"СчетВнебаланс2").      
         else
         cAcct = GetXattrValue("loan",loan.contract + "," + loan.cont-code,"СчетВнебаланс").
         
         if cAcct = ? or cAcct = "" then DO:
             MESSAGE "Не заполнен доп.рек СчетВнабаланс для ценности:" loan.cont-code VIEW-AS ALERT-BOX.
             NEXT.
             end.

       oAcct = new TAcct(cAcct).

       ttemp = oAcct:GetLastPos2Date(DATE(date2)).
       kolvo = DEC(GetXattrValue("loan",loan.contract + "," + loan.cont-code,"АрендаКолво")).
       if secAcct = "91502" then asset-cost = oAcct:GetLastPos2Date(DATE(date2)).
       else
       asset-cost = asset.cost.

       DELETE OBJECT oAcct.       
      CREATE X-Rated.
      ASSIGN
         Counter         = Counter + 1
         Number          = Counter
         passnumber      = GetXattrValue("loan",
                                         loan.contract + "," + loan.cont-code,
                                         "НомерПаспорта"
                                        )
         Assetname       = if INDEX(asset.name,",")<>0 then TRIM(ENTRY(2,asset.name)) else asset.name
         aunit           = asset.unit
         cont-tp         = asset.cont-type
         Inventorynumber = loan.cont-code
         ascost          = if asset-cost <> 0 then asset-cost else ROUND(ttemp / kolvo,2)
         Fquantity       = kolvo
         Fcost           = ttemp
         Bquantity       = kolvo
         Bcost           = ttemp
         als             = 0
      NO-ERROR.


         x-rated.acct = cAcct.
/*      END.*/
   END.
END.
/*end.*/
else
DO:
   IF a-disc = 0 THEN
      NEXT.

   IF NOT CAN-FIND(FIRST x-rated WHERE
                         x-rated.Inventorynumber = loan.cont-code
                  ) THEN
   DO:
      CREATE X-Rated.

      ASSIGN
         Counter         = Counter + 1
         Number          = Counter
         passnumber      = GetXattrValue("loan",
                                         loan.contract + "," + loan.cont-code,
                                         "НомерПаспорта"
                                        )
         Assetname       = asset.name
         aunit           = asset.unit
         cont-tp         = asset.cont-type
         Inventorynumber = loan.cont-code
         ascost          = asset.cost
         Fquantity       = IF Absent THEN 0 ELSE a-qty
         Fcost           = IF Absent THEN 0 ELSE a-disc
         Bquantity       = a-qty
         Bcost           = a-disc
         als             = 0
      NO-ERROR.

      FOR LAST loan-acct WHERE
               loan-acct.contract  = loan.contract
           AND loan-acct.cont-code = loan.cont-code
           AND loan-acct.acct-type = loan.contract + "-учет"
           AND loan-acct.since    <= gend-date
         NO-LOCK:
         x-rated.acct = loan-acct.acct.
      END.
   END.
END.
END.

For Each X-Rated Break By x-rated.Number By als:
   Assign
     TotalFQuantity          = TotalFQuantity  + Fquantity
     TotalFCost              = TotalFCost      + Fcost
     TotalBQuantity          = TotalBQuantity  + Bquantity
     TotalBCost              = TotalBCost      + Bcost
     TotalCounter            = TotalCounter    + 1
     GTotalFQuantity         = GTotalFQuantity + Fquantity
     GTotalFCost             = GTotalFCost     + Fcost
     GTotalBQuantity         = GTotalBQuantity + Bquantity
     GTotalBCost             = GTotalBCost     + Bcost
     GTotalCounter           = GTotalCounter   + 1
   .

   if line-counter = 1 then do:
    put unformatted
    "┌────┬────────────────────┬─────────────────────────────────────┬────────────────────┬────┬─────┬─────────────┬──────────────────┬──────────────┬─────┬─────────────────────┬─────┬─────────────────────┐" skip
    "│ 1  │          2         │                  3                  │          4         │ 5  │  6  │      7      │        8         │       9      │ 10  │         11          │ 12  │        13           │" skip
    "├────┼────────────────────┼─────────────────────────────────────┼────────────────────┼────┼─────┼─────────────┼──────────────────┼──────────────┼─────┼─────────────────────┼─────┼─────────────────────┤" skip.

   end.
     Put Unformatted
        "│"  string(number, "zzz9")
        "│"  string(X-Rated.acct, "x(20)")
        "│"  string(x-rated.assetname, "x(37)")
        "│"  string(x-rated.cont-tp, "x(20)")
        "│    │" string(x-rated.aunit, "x(5)")    "│"
             string(x-rated.ascost, "zzzzzzzzz9.99")
        "│"  String(X-rated.InventoryNumber, "x(18)")
        "│"  string(X-rated.passNumber, "x(14)")
        "│"  string(X-rated.FQuantity, "zzzz9")
        "│" string(X-rated.FCost, "-zzzzz,zzz,zzz,zz9.99")
        "│" string(X-rated.BQuantity, "zzzz9")
        "│" string(X-rated.BCost, "-zzzzz,zzz,zzz,zz9.99")
        "│"  skip.
   IF LINE-COUNTER + 17 > PAGE-SIZE or last(als) Then do:
    put unformatted
    "├────┴────────────────────┴─────────────────────────────────────┴────────────────────┴────┴─────┴─────────────┴──────────────────┴──────────────┼─────┼─────────────────────┼─────┼─────────────────────┤" skip
           "│"  + fill(" ", 136) "Итого :"  +  "│" +
           string((TotalFQuantity), "zzzz9") + "│" +
           string((TotalFCost), "-zzzzz,zzz,zzz,zz9.99") + "│" +
           string((TotalBQuantity), "zzzz9") + "│" +
           string((TotalBCost), "-zzzzz,zzz,zzz,zz9.99") + "│" skip
    "└───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┴─────┴─────────────────────┴─────┴─────────────────────┘" skip
           "Итого по странице: "  skip
           "а) количество порядковых номеров: ".
           Digital = (TotalCounter).
           Run amtstr.p (Digital, No, Output Sliteral, Output S2Literal).
           Put Unformatted Sliteral Skip

           "б) общее количество единиц фактически: ".
           Digital = (TotalFquantity).
           Run amtstr.p (Digital, No, Output Sliteral, Output S2Literal).
           Put Unformatted Sliteral  Skip

           "в) на сумму фактически: ".
           Digital = (TotalFcost).
           Run amtstr.p (Digital, Yes, Output Sliteral, Output S2Literal).
           Put Unformatted Sliteral + " " + S2Literal " коп. " Skip
        fill(" ", 100)       "Председатель комиссии: " dol1 format 'x(50)' " ___________ " fam1 format 'x(20)' skip
        fill(" ", 100)       "Члены комиссии:        " dol2 format 'x(50)' " ___________ " fam2 format 'x(20)' skip
        fill(" ", 100)       "                       " dol3 format 'x(50)' " ___________ " fam3 format 'x(20)' skip
        fill(" ", 100)       "                       " dol4 format 'x(50)' " ___________ " fam4 format 'x(20)' skip
        fill(" ", 100)       "                       " dol5 format 'x(50)' " ___________ " fam5 format 'x(20)' skip
        fill(" ", 100)       "                       " dol6 format 'x(50)' " ___________ " fam6 format 'x(20)' skip
      /*fill(" ", 100)       "                       " dol7 format 'x(50)' " ___________ " fam7 format 'x(20)' skip*/

           .
           
       assign
         TotalFCost              = 0
         TotalFQuantity          = 0
         TotalBCost              = 0
         TotalBQuantity          = 0
         TotalCounter            = 0
       no-error.
       page.
   end.
   if last(als) then do:
           page.
           Put unformatted
           "Итого по описи: "  skip
           "а) количество порядковых номеров: ".
           Digital = (GTotalCounter).
           Run amtstr.p (Digital, No, Output Sliteral, Output S2Literal).
           Put Unformatted Sliteral Skip.

             Put unformatted
               "б) общее количество единиц фактически: ".
             Digital = (GTotalFQuantity).
             Run amtstr.p (Digital, No, Output Sliteral, Output S2Literal).
             Put Unformatted Sliteral  Skip.

           put unformatted
             "в)"  " на сумму фактически: ".
           Digital = (GTotalFCost).
           Run amtstr.p (Digital, Yes, Output Sliteral, Output S2Literal).
           Put Unformatted Sliteral + " " + S2Literal "коп." Skip(1)
           "Все цены, подсчеты итогов по строкам, страницам и в целом по " skip
           "инвентаризационной описи товарно-материальных ценностей проверены." skip (1)
               "Председатель комиссии : " dol1 format 'x(50)' " ___________ " fam1 format 'x(20)' skip
               "                                  должность                подпись   расшифровка подписи" skip(1)
               "Члены комиссии:         " dol2 format 'x(50)' " ___________ " fam2 format 'x(20)' skip
               "                                  должность                подпись   расшифровка подписи" skip(1)
               "                        " dol3 format 'x(50)' " ___________ " fam3 format 'x(20)'skip
               "                                  должность                подпись   расшифровка подписи" skip(1)
               "                        " dol4 format 'x(50)' " ___________ " fam4 format 'x(20)'skip
               "                                  должность                подпись   расшифровка подписи" skip(1)
               "                        " dol5 format 'x(50)' " ___________ " fam5 format 'x(20)'skip
               "                                  должность                подпись   расшифровка подписи" skip(1)
               "                        " dol6 format 'x(50)' " ___________ " fam6 format 'x(20)'skip
               "                                  должность                подпись   расшифровка подписи" skip(1)
           /*  "                        " dol7 format 'x(50)' " ___________ " fam7 format 'x(20)'skip
               "                                  должность                подпись   расшифровка подписи" skip(1)
           */    
               
               .


           put unformatted
               "    Все товарно-материальные ценности, поименованные в настоящей " skip
               "инвентаризационной описи   с N 1  по  N " GTotalCounter " , комиссией" skip
               "проверены в натуре в моем (нашем) присутствии и внесены в опись, в связи " skip
               "с чем, претензий к инвентаризационной комиссии не имею (не имеем). " skip
               "Основные средства, перечисленные в описи, находятся на моем (нашем)" skip
               "ответственном хранении." skip(1)
               "Лицо(а), ответственное(ые) за сохранность " vidcen2 ":" skip(1).
                
           put unformatted
               "Начальник Д1         ________________  Беляева И.В." skip
               "     должность       подпись    расшифровка подписи       " skip(1)
               "Управляющий делами   ________________  Чечулин М.М."  skip
               "     должность        подпись     расшифровка подписи" skip(2)
               "Заведующий складом   ________________  Захарина Т.А." skip
               "     должность        подпись     расшифровка подписи" skip(2)
               "          ___ / _____________ / ______ г." skip(1)
               "Указанные в настоящей описи данные и расчеты проверил" skip(2)
               "                      ___________ _______ __________________________________" skip
               "                      должность   подпись         расшифровка подписи" skip(1)
               "          ___/ ______________ /____ г." skip
           .
   end.
end.

{intrface.del}

{preview.i}