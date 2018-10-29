/*
               KSV Editor
    Copyright: (C) 2000-2006 Serguey Klimoff (bulklodd)
     Filename: Q:\BQ\4.1D\WORK\VVV\SFPR_NEW.P
      Comment: <comment>
   Parameters:
         Uses:
      Used by:
      Created: 21.01.2012 19:21 VVV     
     Modified: 21.01.2012 19:21 VVV      <comment>
*/

{tmprecid.def}

{globals.i}
{intrface.get date}
{intrface.get axd}
{intrface.get asset}
{intrface.get xclass}
{intrface.get strng }
{intrface.get cdrep}
{intrface.get db2l}
{intrface.get cust}
{getcli.pro}
{branch.pro}    /* Интсрументы для работы с подразделениями */
{wordwrap.def}
{get-bankname.i}
DEF VAR oShortName AS CHAR EXTENT 3 NO-UNDO.

DEFINE STREAM sfact.
{setdest.i &cols=120 &STREAM="stream sfact" &filename="'_spool_sf.tmp'"}

DEF VAR mI AS INT64 NO-UNDO. /* счетчик */
DEF VAR mJ AS INT64 NO-UNDO.
DEF VAR mPage AS INT64 NO-UNDO.
DEF VAR mLeng AS INT64 NO-UNDO INIT 225.
DEF VAR mLengBody AS INT64 NO-UNDO INIT 0.
DEF VAR mLs AS INT64 NO-UNDO INIT 0.
DEF VAR i AS INT64 NO-UNDO INIT 0.

DEF VAR mSignName1 AS CHAR NO-UNDO.
DEF VAR mSignName2 AS CHAR NO-UNDO.
DEF VAR mSignName3 AS CHAR NO-UNDO.
DEF VAR mSignStr1 AS CHAR NO-UNDO.
DEF VAR mSignStr2 AS CHAR NO-UNDO.
DEF VAR mSignStr3 AS CHAR NO-UNDO.

DEF BUFFER bfrAsset FOR asset. /** Для поиска кода услуги */

DEF VAR oOut AS LOGICAL NO-UNDO.
DEF VAR oIn AS LOGICAL NO-UNDO.
DEF VAR oSort AS INT NO-UNDO.
DEF VAR onquart AS INT NO-UNDO.
DEF VAR oyear AS INT NO-UNDO.
DEF VAR oBegDate AS DATE NO-UNDO.
DEF VAR oEndDate AS DATE NO-UNDO.
DEFINE VARIABLE vCustName AS CHARACTER  NO-UNDO.
DEFINE VARIABLE vINN AS CHARACTER  NO-UNDO.
DEFINE VARIABLE vKPP AS CHARACTER  NO-UNDO.
DEFINE VARIABLE vAddr AS CHARACTER  NO-UNDO.
DEFINE VARIABLE vType AS CHARACTER  NO-UNDO.
DEFINE VARIABLE vCode AS CHARACTER  NO-UNDO.
DEFINE VARIABLE vAcct AS CHARACTER  NO-UNDO.


DEFINE VAR mSFNum         AS CHAR NO-UNDO. /*номер счёта-фактуры*/
DEFINE VAR mSFDate        AS DATE NO-UNDO. /*дата сф*/
DEFINE VAR mSFFixInfo     AS CHAR NO-UNDO. /*информация по исправлениям*/
DEFINE VAR mSFFixDate     AS DATE NO-UNDO. /*дата исправления*/
DEFINE VAR mSFFixNum      AS CHAR NO-UNDO. /*номер исправления*/
DEFINE VAR mSFTovar       AS LOG  NO-UNDO. /*ДР Товар*/
DEFINE VAR mSFSeller      AS CHAR NO-UNDO. /*продавец*/
DEFINE VAR mSFSellerAddr  AS CHAR NO-UNDO. /*продавец Адрес сф*/
DEFINE VAR mSFSellerINN   AS CHAR NO-UNDO. /*продавец INN сф*/
DEFINE VAR mSFSellerKPP   AS CHAR NO-UNDO. /*продавец KPP сф*/
DEFINE VAR mSFCurrInfo    AS CHAR NO-UNDO. /*код и наименование валюты сф*/
DEFINE VAR mSFCurrLine    AS CHAR NO-UNDO. /*прочерк под реквизитами сф*/
DEFINE VAR mSFCurrName    AS CHAR NO-UNDO. /*наименование сф*/

DEFINE VAR mIsEmptyKol       AS LOG  NO-UNDO. /*ДР не печатать количество*/

DEFINE VAR mSFBuyer       AS CHAR NO-UNDO. /*покупатель */
DEFINE VAR mSFBuyerAddr   AS CHAR NO-UNDO. /*покупатель Адрес сф*/
DEFINE VAR mSFBuyerINN    AS CHAR NO-UNDO. /*покупатель INN сф*/
DEFINE VAR mSFBuyerKPP    AS CHAR NO-UNDO. /*покупатель KPP сф*/

DEFINE VAR mSFOtprav      AS CHAR NO-UNDO. /*Грузоотправ сф*/
DEFINE VAR mSFOtpravAddr  AS CHAR NO-UNDO. /*Адрес Грузоотправ сф*/
DEFINE VAR mSFPoluch      AS CHAR NO-UNDO. /*Грузополучатель сф*/
DEFINE VAR mSFPoluchAddr  AS CHAR NO-UNDO. /*Адрес Грузополучателя сф*/


   def var surr-sf as char no-undo.
   def var surr as char no-undo.
   def var ispr as char no-undo.
   def buffer t1 for term-obl.
   def buffer t2 for term-obl.
   def var amt1 as dec no-undo.
   def var nds1 as dec no-undo.
   def var amt2 as dec no-undo.
   def var nds2 as dec no-undo.
   def var tot1 as dec no-undo.
   def var tot2 as dec no-undo.

   def temp-table sf no-undo like loan
       field nn as int
       index nn nn.


def var cliInn AS CHARACTER NO-UNDO.
def var cliKpp AS CHARACTER NO-UNDO.

PROCEDURE GETINNKPP.

cliInn = "".
cliKpp = "".
cliInn = GetXattrValueEx("loan",surr-sf,"CustINN","").
cliKpp = GetXattrValueEx("loan",surr-sf,"CustKpp","").




if CliInn = "" or CliInn = ? then 
do:
   RUN SFAttribsNames(INPUT sf.contract,
                      INPUT sf.cont-code,

                      OUTPUT mSFSeller,
                      OUTPUT mSFSellerAddr,
                      OUTPUT mSFSellerINN,
                      OUTPUT mSFSellerKPP,

                      OUTPUT mSFBuyer,    
                      OUTPUT mSFBuyerAddr,
                      OUTPUT mSFBuyerINN,
                      OUTPUT mSFBuyerKPP,
                      
                      OUTPUT mSFOtprav,    
                      OUTPUT mSFOtpravAddr,
                      OUTPUT mSFPoluch,
                      OUTPUT mSFPoluchAddr).

if sf.contract = "sf-out" then DO:

cliInn = mSFBuyerINN.
cliKpp = mSFBuyerKpp.
end.
else
do:
cliInn = mSFSellerINN.
cliKpp = mSFSellerKpp.
end.
if TRIM(REPLACE(cliInn,"0","")) = "" then cliInn = "".
if TRIM(REPLACE(cliKpp,"0","")) = "" then cliKpp = "".
end.

END PROCEDURE.


RUN sf-param.p(
    OUTPUT oOut,
    OUTPUT oIn,
    OUTPUT oSort, 
    OUTPUT onquart,
    OUTPUT oyear, 
    OUTPUT oBegDate,
    OUTPUT oEndDate). 
IF LASTKEY = 10 THEN
DO:

PUT STREAM sfact UNFORMATTED
    PADL("Приложение N 3",mLeng) SKIP
    PADL("к постановлению Правительства",mLeng) SKIP
    PADL("Российской Федерации",mLeng) SKIP
    PADL("от 26.12.2011 № 1137",mLeng) 
    SKIP.
PUT STREAM sfact UNFORMATTED
    PADL("ЖУРНАЛ УЧЕТА ПОЛУЧЕННЫХ И ",87) SKIP
    SPACE(40) "ВЫСТАВЛЕННЫХ СЧЕТОВ-ФАКТУР, ПРИМЕНЯЕМЫХ ПРИ РАСЧЕТАХ ПО НАЛОГУ НА ДОБАВЛЕННУЮ СТОИМОСТЬ " SKIP (2).
PUT STREAM sfact UNFORMATTED SPACE(mLengBody) "НАИМЕНОВАНИЕ НАЛОГОПЛАТЕЛЬЩИКА " cBankName SKIP.
PUT STREAM sfact UNFORMATTED SPACE(mLengBody) "                               " FILL("-",40) SKIP.
PUT STREAM sfact UNFORMATTED SPACE(mLengBody) "ИНН/КПП НАЛОГОПЛАТЕЛЬЩИКА      " FGetSetting("ИНН",?,?) "/" FGetSetting("БАНККПП",?,?) SKIP.
PUT STREAM sfact UNFORMATTED SPACE(mLengBody) "                               " FILL("-",40) SKIP (2).
IF onquart >= 1 THEN
DO:
   def var mList as char init "1,4,7,10" no-undo.
   oBegDate = DATE(INT(entry(onquart,mList)),1,oYear).
   if onquart = 4 then 
      oEndDate = DATE(12,31,oYear).
   else
      oEndDate = DATE(INT(entry(onquart + 1,mList)),1,oYear) - 1.
   PUT STREAM sfact UNFORMATTED PADL("За " + STRING(onquart) + " квартал " + STRING(oyear) + " года",100) SKIP(2).
END.
ELSE
   PUT STREAM sfact UNFORMATTED PADL("За период с " + STRING(oBegDate) + " по " + STRING(oEndDate),100) SKIP(2).
IF oOut THEN
DO:
   PUT STREAM sfact UNFORMATTED PADL("ЧАСТЬ 1. ВЫСТАВЛЕННЫЕ СЧЕТА-ФАКТУРЫ",100) SKIP(2).
   PUT STREAM sfact UNFORMATTED
      /* шапка таблицы */
      SPACE(mLengBody) "┌─────┬───────────┬───────┬────────┬───────┬─────────────┬──────────────┬──────────────┬───────────┬───────────┬────────────────────────┬─────────────┬─────────┬───────────────┬────────────┬──────────────────────────┬─────────────────────────┐" SKIP
      SPACE(mLengBody) "│ №   │   Дата    │  Код  │  Код   │Номер  │     Дата    │     Номер    │     Дата     │   Номер   │   Дата    │      Наименование      │   ИНН/КПП   │  Наиме- │   Стоимость   │   В том    │ Разница стоимости        │ Разница  НДС по         │" SKIP
      SPACE(mLengBody) "│ п/п │выставления│способа│  вида  │счета- │ составления │корректировоч-│ составления  │исправления│исправления│       покупателя       │   покупа-   │ нование │товаров (работ,│   числе,   │ с учетом НДС по          │ корректировочному       │" SKIP
      SPACE(mLengBody) "│     │           │выстав-│операции│фактуры│счета-фактуры│ ного счета-  │корректировоч-│           │           │                        │    теля     │  и код  │     услуг)    │ сумма НДС  │ корректировочному        │ счету-фактуре           │" SKIP
      SPACE(mLengBody) "│     │           │ ления │        │       │             │    фактуры   │ ного счета-  │           │           │                        │             │ валюты  │ имущественных │ по счету-  │ счету-фактуре            │                         │" SKIP
      SPACE(mLengBody) "│     │           │       │        │       │             │              │   фактуры    │           │           │                        │             │         │прав по счету- │  фактуре   ├─────────────┬────────────┼────────────┬────────────┤" SKIP
      SPACE(mLengBody) "│     │           │       │        │       │             │              │              │           │           │                        │             │         │    фактуре    │            │             │            │            │            │" SKIP
      SPACE(mLengBody) "│     │           │       │        │       │             │              │              │           │           │                        │             │         │     всего     │            │ уменьшение  │ увеличение │ уменьшение │ увеличение │" SKIP
      SPACE(mLengBody) "├─────┼───────────┼───────┼────────┼───────┼─────────────┼──────────────┼──────────────┼───────────┼───────────┼────────────────────────┼─────────────┼─────────┼───────────────┼────────────┼─────────────┼────────────┼────────────┼────────────┤" SKIP
      SPACE(mLengBody) "│  1  │     2     │   3   │   4    │   5   │      6      │       7      │       8      │     9     │    10     │           11           │      12     │    13   │   14          │   15       │   16        │  17        │    18      │  19        │" SKIP
   .

   def temp-table tmp no-undo like sf.
   create tmp.
   i = 1.
   case oSort:
      when 1 or when 4 then
      do:
         FOR EACH loan WHERE loan.contract  EQ "sf-out"
                         AND loan.filial-id EQ shFilial
                         AND loan.open-date GE oBegDate 
                         AND loan.open-date LE oEndDate NO-LOCK BY loan.open-date:
             CREATE sf.
             BUFFER-COPY loan TO sf.
             sf.nn = i.
             i = i + 1.
         END.
      end.
      when 2 then
      do:
         FOR EACH loan WHERE loan.contract  EQ "sf-out"
                         AND loan.filial-id EQ shFilial
                         AND loan.open-date GE oBegDate 
                         AND loan.open-date LE oEndDate NO-LOCK BY loan.conf-date:
             CREATE sf.
             BUFFER-COPY loan TO sf.
             sf.nn = i.
             i = i + 1.
         END.
      end.
      when 3 then
      do:
         FOR EACH loan WHERE loan.contract  EQ "sf-out"
                         AND loan.filial-id EQ shFilial
                         AND loan.open-date GE oBegDate 
                         AND loan.open-date LE oEndDate NO-LOCK BY loan.doc-num:
             CREATE sf.
             BUFFER-COPY loan TO sf.
             sf.nn = i.
             i = i + 1.
         END.
      end.
   end case.
   for each sf:
      surr-sf = sf.contract + "," + sf.cont-code.
      surr = sf.contract + "," + sf.cont-code.
      ispr = GetXattrValue("loan",surr,"Исправ").
      find first loan where loan.contract = entry(1,ispr) and loan.cont-code = entry(2,ispr) no-lock no-error.
      if avail loan then
      do:
         buffer-copy loan to tmp.
         tmp.nn = sf.nn.
         surr = ispr.
      end.
      else
         buffer-copy sf to tmp.
      oShortNamE[1] = GetCliName(sf.cust-cat,string(sf.cust-id),
                    OUTPUT vAddr,
                    OUTPUT vINN,
                    OUTPUT vKPP,
                    INPUT-OUTPUT vType,
                    OUTPUT vCode,
                    OUTPUT vAcct).
      for each t1 where t1.contract = sf.contract and t1.cont-code = sf.cont-code no-lock:
          accumulate t1.amt-rub (total).
          accumulate t1.int-amt (total).
      end.
      amt1 = (accum total t1.amt-rub).
      nds1 = (accum total t1.int-amt).
      for each t2 of loan no-lock:
          accumulate t2.amt-rub (total).
          accumulate t2.int-amt (total).
      end.
      amt2 = (accum total t2.amt-rub).
      nds2 = (accum total t2.int-amt).
       
      tot1 = amt1 - amt2.
      tot2 = nds1 - nds2.



/*
message 
sf.doc-num skip
amt1 nds1 skip
amt2 nds2 skip
tot1 tot2 skip
view-as alert-box.
*/

/*sf.comment =*/

   find first term-obl WHERE 
            term-obl.contract  = sf.contract
        AND term-obl.cont-code = sf.cont-code
   NO-LOCK NO-ERROR.
      
/* Здесь находим услугу по которой выставлена счет-фактура, в доп реквизите PirKodVidOp, должен быть записан код услуги. */

      FIND FIRST bfrAsset WHERE
      			 bfrAsset.cont-type EQ term-obl.symbol
      			 AND
      			 bfrAsset.filial-id EQ sf.filial-id
      			 NO-LOCK NO-ERROR.
/*message bfrAsset.cont-type VIEW-AS ALERT-BOX.*/
      if available (bfrAsset) then 
do:


sf.comment = GetXattrValueEx("asset",bfrAsset.filial-id + "," + bfrAsset.cont-type,"PirKodVidOp","").
end.
{wordwrap.i &s=oShortName &l=24 &n=3}

RUN GETINNKPP.
      PUT STREAM sfact UNFORMATTED SPACE(mLengBody) 
                       "├─────┼───────────┼───────┼────────┼───────┼─────────────┼──────────────┼──────────────┼───────────┼───────────┼────────────────────────┼─────────────┼─────────┼───────────────┼────────────┼─────────────┼────────────┼────────────┼────────────┤" SKIP.
/*                         1       2          3       4          5          6            7               8             9              10                11                      12              13              14          15           16            17           18          20 */
/* первая строка, т.к. могут быть переносы - добавим ещё один кусоччччеееееееег */
      PUT STREAM sfact UNFORMATTED SPACE(mLengBody) 
"│" + STRING(string(tmp.nn,">>>>9"),"x(5)") +
"│" + STRING(string(sf.conf-date,"99/99/9999"),"x(11)") +                                                                                                                                       
"│" + (if GetXattrValueEx("loan",surr-sf,"КодСпособ","") <> "" and GetXattrValueEx("loan",surr-sf,"КодСпособ","") <> ? then STRING(GetXattrValueEx("loan",surr-sf,"КодСпособ",""),"x(7)") else "   1   " ) +
"│" + STRING(sf.comment,"x(8)") +
"│" + STRING(tmp.doc-num,"x(7)") +
"│" + STRING(string(tmp.open-date,"99/99/9999"),"x(13)") +
"│" + STRING(if avail loan then sf.doc-num else "","x(14)") +
"│" + STRING(if avail loan then string(sf.open-date,"99/99/9999") else "","x(14)") +
"│" + STRING(if avail loan then string(entry(1,GetXattrValueEx("loan",surr-sf,"НомДатКорр",""))) else "","x(11)") +
"│" + STRING(if avail loan then string(date(entry(2,GetXattrValueEx("loan",surr-sf,"НомДатКорр",""))),"99/99/9999") else "","x(11)") +
"│" + STRING(oShortName[1],"x(24)") +
"│" + STRING(cliInn + "/","x(13)") +
"│" + STRING(if sf.currency = "" then "643,рубль" else sf.currency,"x(9)") +
"│" + STRING(amt1,">>>>,>>>,>>9.99") +
"│" + STRING(if nds1 = 0 then "Без НДС" else STRING(nds1,">>>>>>>>9.99"),"x(12)") +
"│" + STRING(if avail loan and tot1 < 0 then STRING(abs(tot1),">>>>>>>>9.99") else "","x(13)") +
"│" + STRING(if avail loan and tot1 > 0 then STRING(abs(tot1),">>>>>>>>9.99") else "","x(12)") +
"│" + STRING(if avail loan and tot2 < 0 then STRING(abs(tot2),">>>>>>>>9.99") else "","x(12)") +
"│" + STRING(if avail loan and tot2 > 0 then STRING(abs(tot2),">>>>>>>>9.99") else "","x(12)") +
"│" SKIP.
/*конец вывода первой строки*/
/* выводим вторую строку если это необходимо, для этого проверяем                    */
if (oShortName[2] <> "") or (cliKpp <> "") then 
do:
      PUT STREAM sfact UNFORMATTED SPACE(mLengBody) 
"│" + STRING(" ","x(5)") +
"│" + STRING(" ","x(11)") +
"│" + (STRING(" ","x(7)")) +
"│" + STRING(" ","x(8)") +
"│" + STRING(" ","x(7)") +
"│" + STRING(" ","x(13)") +
"│" + STRING(" ","x(14)") +
"│" + STRING(" ","x(14)") +
"│" + STRING(" ","x(11)") +
"│" + STRING(" ","x(11)") +
"│" + STRING(oShortName[2],"x(24)") +
"│" + STRING(cliKpp,"x(13)") +
"│" + STRING(" ","x(9)") +
"│" + STRING(" ","x(15)") +
"│" + STRING(" ","x(12)") +
"│" + STRING(" ","x(13)") +
"│" + STRING(" ","x(12)") +
"│" + STRING(" ","x(12)") +
"│" + STRING(" ","x(12)") +
"│" SKIP.
end.
/* выводим вторую строку если это необходимо, для этого проверяем                    */
if (oShortName[3] <> "") then 
do:
      PUT STREAM sfact UNFORMATTED SPACE(mLengBody) 
"│" + STRING(" ","x(5)") +
"│" + STRING(" ","x(11)") +
"│" + (STRING(" ","x(7)")) +
"│" + STRING(" ","x(8)") +
"│" + STRING(" ","x(7)") +
"│" + STRING(" ","x(13)") +
"│" + STRING(" ","x(14)") +
"│" + STRING(" ","x(14)") +
"│" + STRING(" ","x(11)") +
"│" + STRING(" ","x(11)") +
"│" + STRING(oShortName[3],"x(24)") +
"│" + STRING(" ","x(13)") +
"│" + STRING(" ","x(9)") +
"│" + STRING(" ","x(15)") +
"│" + STRING(" ","x(12)") +
"│" + STRING(" ","x(13)") +
"│" + STRING(" ","x(12)") +
"│" + STRING(" ","x(12)") +
"│" + STRING(" ","x(12)") +
"│" SKIP.
end.


   END.

   PUT STREAM sfact UNFORMATTED
      SPACE(mLengBody) "└─────┴───────────┴───────┴────────┴───────┴─────────────┴──────────────┴──────────────┴───────────┴───────────┴────────────────────────┴─────────────┴─────────┴───────────────┴────────────┴─────────────┴────────────┴────────────┴────────────┘" SKIP(2).

END.
IF oIn THEN
DO:
   PUT STREAM sfact UNFORMATTED PADL("ЧАСТЬ 2. ПОЛУЧЕННЫЕ СЧЕТА-ФАКТУРЫ",100) SKIP(2).
   PUT STREAM sfact UNFORMATTED
      /* шапка таблицы */
      SPACE(mLengBody) "┌────┬────────────┬─────────────┬──────────┬────────────────┬─────────────┬─────────────────┬──────────────┬────────────┬────────────┬────────────────────────┬───────────────────────┬──────┬───────────────┬────────────┬──────────────────────────┬─────────────────────────┐" SKIP
      SPACE(mLengBody) "│№   │  Дата      │  Код        │  Код     │ Номер          │Дата         │  Номер          │Дата          │ Номер      │ Дата       │Наименование            │ИНН/КПП                │ Код  │   Стоимость   │В том       │ Разница стоимости        │ Разница  НДС по         │" SKIP
      SPACE(mLengBody) "│п/п │ выставления│  способа    │  вида    │ счета-         │составления  │  корректировоч- │составления   │ исправления│ исправления│продавца                │продавца               │валюты│товаров (работ,│числе,      │ с учетом НДС по          │ корректировочному       │" SKIP
      SPACE(mLengBody) "│    │            │  выставления│  операции│ фактуры        │счета-фактуры│  ного счета-    │корректировоч-│            │            │                        │                       │      │     услуг,    │сумма НДС   │ корректировочному        │ счету-фактуре           │" SKIP
      SPACE(mLengBody) "│    │            │             │          │                │             │  фактуры        │ного счета-   │            │            │                        │                       │      │ имущественных │по счету-   │ счету-фактуре            │                         │" SKIP
      SPACE(mLengBody) "│    │            │             │          │                │             │                 │фактуры       │            │            │                        │                       │      │     прав      │фактуре     ├─────────────┬────────────┼────────────┬────────────┤" SKIP
      SPACE(mLengBody) "│    │            │             │          │                │             │                 │              │            │            │                        │                       │      │по счет-фактуре│            │             │            │            │            │" SKIP
      SPACE(mLengBody) "│    │            │             │          │                │             │                 │              │            │            │                        │                       │      │     всего     │            │ уменьшение  │ увеличение │ уменьшение │ увеличение │" SKIP
      SPACE(mLengBody) "├────┼────────────┼─────────────┼──────────┼────────────────┼─────────────┼─────────────────┼──────────────┼────────────┼────────────┼────────────────────────┼───────────────────────┼──────┼───────────────┼────────────┼─────────────┼────────────┼────────────┼────────────┤" SKIP
      SPACE(mLengBody) "│ 1  │     2      │      3      │    4     │    5           │     6       │       7         │     8        │     9      │     10     │     11                 │   12                  │  13  │      14       │   15       │   16        │  17        │    18      │  19        │" SKIP
   .
   for each sf: delete sf. end.
   i = 1.
   case oSort:
      when 1 or when 4 then
      do:
         FOR EACH loan WHERE loan.contract  EQ "sf-in"
                         AND loan.filial-id EQ shFilial
                         AND loan.open-date GE oBegDate 
                         AND loan.open-date LE oEndDate NO-LOCK BY loan.open-date:
             CREATE sf.
             BUFFER-COPY loan TO sf.
             sf.nn = i.
             i = i + 1.
         END.
      end.
      when 2 then
      do:
         FOR EACH loan WHERE loan.contract  EQ "sf-in"
                         AND loan.filial-id EQ shFilial
                         AND loan.open-date GE oBegDate 
                         AND loan.open-date LE oEndDate NO-LOCK BY loan.conf-date:
             CREATE sf.
             BUFFER-COPY loan TO sf.
             sf.nn = i.
             i = i + 1.
         END.
      end.
      when 3 then
      do:
         FOR EACH loan WHERE loan.contract  EQ "sf-in"
                         AND loan.filial-id EQ shFilial
                         AND loan.open-date GE oBegDate 
                         AND loan.open-date LE oEndDate NO-LOCK BY loan.doc-num:
             CREATE sf.
             BUFFER-COPY loan TO sf.
             sf.nn = i.
             i = i + 1.
         END.
      end.
   end case.
   .
   for each sf:
      surr-sf = sf.contract + "," + sf.cont-code.
      surr = sf.contract + "," + sf.cont-code.
      ispr = GetXattrValue("loan",surr,"Исправ").
      find first loan where loan.contract = entry(1,ispr) and loan.cont-code = entry(2,ispr) no-lock no-error.
      if avail loan then
      do:
         buffer-copy loan to tmp.
         tmp.nn = sf.nn.
         surr = ispr.
      end.
      else
         buffer-copy sf to tmp.
      oShortNamE[1] = GetCliName(sf.cust-cat,string(sf.cust-id),
                    OUTPUT vAddr,
                    OUTPUT vINN,
                    OUTPUT vKPP,
                    INPUT-OUTPUT vType,
                    OUTPUT vCode,
                    OUTPUT vAcct).
      for each t1 where t1.contract = sf.contract and t1.cont-code = sf.cont-code no-lock:
          accumulate t1.amt-rub (total).
          accumulate t1.int-amt (total).
      end.
      amt1 = (accum total t1.amt-rub).
      nds1 = (accum total t1.int-amt).
      for each t2 of loan no-lock:
          accumulate t2.amt-rub (total).
          accumulate t2.int-amt (total).
      end.
      amt2 = (accum total t2.amt-rub).
      nds2 = (accum total t2.int-amt).
       
      tot1 = amt1 - amt2.
      tot2 = nds1 - nds2.

/*
message 
sf.doc-num skip
amt1 nds1 skip
amt2 nds2 skip
tot1 tot2 skip
view-as alert-box.
*/

RUN GETINNKPP.
      PUT STREAM sfact UNFORMATTED SPACE(mLengBody) 
                       "├────┼────────────┼─────────────┼──────────┼────────────────┼─────────────┼─────────────────┼──────────────┼────────────┼────────────┼────────────────────────┼───────────────────────┼──────┼───────────────┼────────────┼─────────────┼────────────┼────────────┼────────────┤" SKIP.
      PUT STREAM sfact UNFORMATTED SPACE(mLengBody) 
"│" + STRING(string(tmp.nn,"999"),"x(4)") +
"│" + STRING(string(sf.conf-date,"99/99/9999"),"x(12)") +
"│" + STRING(GetXattrValueEx("loan",surr-sf,"КодСпособ",""),"x(13)") +
"│" + STRING(sf.comment,"x(10)") +
"│" + STRING(tmp.doc-num,"x(16)") +
"│" + STRING(string(tmp.open-date,"99/99/9999"),"x(13)") +
"│" + STRING(if avail loan then sf.doc-num else "","x(17)") +
"│" + STRING(if avail loan then string(sf.open-date,"99/99/9999") else "","x(14)") +
"│" + STRING(if avail loan then string(entry(1,GetXattrValueEx("loan",surr-sf,"НомДатКорр",""))) else "","x(12)") +
"│" + STRING(if avail loan then string(date(entry(2,GetXattrValueEx("loan",surr-sf,"НомДатКорр",""))),"99/99/9999") else "","x(12)") +
"│" + STRING(oShortName[1],"x(24)") +
"│" + STRING(GetXattrValueEx("loan",surr-sf,"CustINN","") + "/" + GetXattrValueEx("loan",surr-sf,"CustKpp",""),"x(23)") +
"│" + STRING(if sf.currency = "" then "643" else sf.currency,"x(6)") +
"│" + STRING(amt1,">>>>,>>>,>>9.99") +
"│" + STRING(if nds1 = 0 then "Без НДС" else STRING(nds1,">>>>>>>>9.99"),"x(12)") +
"│" + STRING(if avail loan and tot1 < 0 then STRING(abs(tot1),">>>>>>>>9.99") else "","x(13)") +
"│" + STRING(if avail loan and tot1 > 0 then STRING(abs(tot1),">>>>>>>>9.99") else "","x(12)") +
"│" + STRING(if avail loan and tot2 < 0 then STRING(abs(tot2),">>>>>>>>9.99") else "","x(12)") +
"│" + STRING(if avail loan and tot2 > 0 then STRING(abs(tot2),">>>>>>>>9.99") else "","x(12)") +
"│" SKIP.

   END.

   PUT STREAM sfact UNFORMATTED
      SPACE(mLengBody) "└────┴────────────┴─────────────┴──────────┴────────────────┴─────────────┴─────────────────┴──────────────┴────────────┴────────────┴────────────────────────┴───────────────────────┴──────┴───────────────┴────────────┴─────────────┴────────────┴────────────┴────────────┘" SKIP(2).
END.
PUT STREAM sfact UNFORMATTED SKIP

SPACE(mLengBody)        " Руководитель организации       _____________________   Шлогина Елена Гаврииловна " SKIP
SPACE(mLengBody)        " или иное уполномоченное лицо        (подпись)                 (ф.и.о.)           " SKIP(2).


PUT STREAM sfact UNFORMATTED  
SPACE(mLengBody)        " Индивидуальный предприниматель _____________________ _______________________ " SKIP    
SPACE(mLengBody)        "                                     (подпись)                 (ф.и.о.)           " SKIP(1)
SPACE(mLengBody)        "Реквизиты свидетельства о государственной регистрации индивидуального предпринимателя   ________________________________________________________ " SKIP.



{preview.i &STREAM="STREAM sfact" &FILENAME = "'_spool_sf.tmp'"}

END.
{intrface.del}
