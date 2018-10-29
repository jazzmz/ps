{pirsavelog.p}

{globals.i}
{intrface.get instrum}
{sh-defs.i}

DEF VAR vStr      AS CHAR NO-UNDO.

/* запрашиваем дату отчета */
{getdate.i}

/* запрашиваем валюту отчета */
{getcur.i}

def var vald as dec no-undo.
def var valk as dec no-undo.
def var valdv as dec no-undo.
def var valkv as dec no-undo.
def var restsum as dec no-undo.
def var restsumfull as dec no-undo.
def var symb as char no-undo.

def var R1         as char no-undo.
def var R2_DepSrUL as char no-undo.
def var R2_DepSrFL as char no-undo.
def var R2_DepDVUL as char no-undo.
def var R2_DepDVFL as char no-undo.
def var R2_RSUL    as char no-undo.
def var R2_CenBum  as char no-undo.
def var R2_MBK     as char no-undo.


DEF VAR vName AS CHAR EXTENT 2 NO-UNDO. /* для формирования имени клиента */

{setdest.i &cols=80}

   R1         = FGetSetting ("ОтчетЛиквидность", "Раздел1", ?).
   R2_DepSrUL = FGetSetting ("ОтчетЛиквидность", "Раздел2ДепСрЮЛ", ?).
   R2_DepSrFL = FGetSetting ("ОтчетЛиквидность", "Раздел2ДепСрФЛ", ?).
   R2_DepDVUL = FGetSetting ("ОтчетЛиквидность", "Раздел2ДепДВЮЛ", ?).
   R2_DepDVFL = FGetSetting ("ОтчетЛиквидность", "Раздел2ДепДВФЛ", ?).
   R2_RSUL    = FGetSetting ("ОтчетЛиквидность", "Раздел2РасчСч", ?).
   R2_CenBum  = FGetSetting ("ОтчетЛиквидность", "Раздел2ЦенБум", ?).
   R2_MBK     = FGetSetting ("ОтчетЛиквидность", "Раздел2МБК", ?).


symb = "-".

   put screen col 1 row 24 
       "Создание первой части отчета за " + STRING(end-date,"99/99/9999") + STRING(" ","X(38)").

   put unformatted "                           ОТЧЕТ ОБ ОСТАТКАХ ЗА " + STRING(end-date,"99/99/9999") SKIP(2).

   FOR EACH bal-acct WHERE CAN-DO(R1,STRING(bal-acct.bal-acct,"99999")) NO-LOCK,
       EACH acct OF bal-acct WHERE open-date LE end-date
                             AND ( ( close-date GE end-date ) OR ( close-date EQ ? ) ) 
                             AND CAN-DO(cur,acct.currency)
           NO-LOCK BREAK BY acct.acct :

       put screen col 77 row 24 "(" + symb + ")" .

   
       {getcust.i &name=vName  &OFFinn="/*"} 

       vName[1] = TRIM(vName[1]) + " " +  TRIM(vName[2]).
       /* полезли за остатками по счету  */
       RUN acct-pos IN h_base (acct.acct,
                              acct.currency,
                              end-date,
                              end-date,
                              CHR(251)).

       restsum = if ( sh-val NE 0 ) then sh-val else sh-bal. 

       restsum = if ( restsum < 0 ) then ( restsum * -1 ) else restsum.

       CASE symb :
          WHEN "\\"  THEN symb = "|".
          WHEN "|"   THEN symb = "/".
          WHEN "/"   THEN symb = "-".
          WHEN "-"   THEN symb = "\\".
       END CASE.
       put screen col 55 row 24 STRING(TRIM(acct.acct),"x(20)").

       IF restsum > 0 THEN
          put unformatted skip acct.acct FORMAT "x(20)" " "
                           vName[1] FORMAT "x(40)" " "
                           restsum FORMAT "->>>,>>>,>>>,>>9.99".
   end.


   put unformatted  SKIP(3).
   restsumfull = 0.
   put screen col 1 row 24 
       "Создание второй части отчета за " + STRING(end-date,"99/99/9999") + STRING(" ","X(38)").

   FOR EACH bal-acct WHERE CAN-DO(R2_DepSrUL,STRING(bal-acct.bal-acct,"99999")) NO-LOCK,
       EACH acct OF bal-acct WHERE open-date LE end-date
                             AND ( ( close-date GE end-date ) OR ( close-date EQ ? ) ) 
                             AND CAN-DO(cur,acct.currency)
           NO-LOCK BREAK BY acct.acct :

       put screen col 77 row 24 "(" + symb + ")" .

       /* полезли за остатками по счету  */
       RUN acct-pos IN h_base (acct.acct,
                              acct.currency,
                              end-date,
                              end-date,
                              CHR(251)).

       restsum = if ( sh-val NE 0 ) then sh-val else sh-bal. 

       restsum = if ( restsum < 0 ) then ( restsum * -1 ) else restsum.

       CASE symb :
          WHEN "\\"  THEN symb = "|".
          WHEN "|"   THEN symb = "/".
          WHEN "/"   THEN symb = "-".
          WHEN "-"   THEN symb = "\\".
       END CASE.
       put screen col 55 row 24 STRING(TRIM(acct.acct),"x(20)").
  
     ACCUMULATE restsum (TOTAL).
   end.

   restsumfull = ACCUM TOTAL restsum.
                                    
   put unformatted skip "Срочные депозиты Ю/Л " 
                         R2_DepSrUL FORMAT "x(40)" " "
                         restsumfull FORMAT "->>>,>>>,>>>,>>9.99".


   restsumfull = 0.
   FOR EACH bal-acct WHERE CAN-DO(R2_DepSrFL,STRING(bal-acct.bal-acct,"99999")) NO-LOCK,
       EACH acct OF bal-acct WHERE open-date LE end-date
                             AND ( ( close-date GE end-date ) OR ( close-date EQ ? ) ) 
                             AND CAN-DO(cur,acct.currency)
           NO-LOCK BREAK BY acct.acct :

       put screen col 77 row 24 "(" + symb + ")" .

       /* полезли за остатками по счету  */
       RUN acct-pos IN h_base (acct.acct,
                              acct.currency,
                              end-date,
                              end-date,
                              CHR(251)).

       restsum = if ( sh-val NE 0 ) then sh-val else sh-bal. 

       restsum = if ( restsum < 0 ) then ( restsum * -1 ) else restsum.

       CASE symb :
          WHEN "\\"  THEN symb = "|".
          WHEN "|"   THEN symb = "/".
          WHEN "/"   THEN symb = "-".
          WHEN "-"   THEN symb = "\\".
       END CASE.
       put screen col 55 row 24 STRING(TRIM(acct.acct),"x(20)").

       ACCUMULATE restsum (TOTAL).
   end.

   restsumfull = ACCUM TOTAL restsum.
                                    
   put unformatted skip "Срочные депозиты Ф/Л " 
                         R2_DepSrFL FORMAT "x(40)" " "
                         restsumfull FORMAT "->>>,>>>,>>>,>>9.99".


   restsumfull = 0.

   FOR EACH bal-acct WHERE CAN-DO(R2_DepDVUL,STRING(bal-acct.bal-acct,"99999")) NO-LOCK,
       EACH acct OF bal-acct WHERE open-date LE end-date
                             AND ( ( close-date GE end-date ) OR ( close-date EQ ? ) ) 
                             AND CAN-DO(cur,acct.currency)
           NO-LOCK BREAK BY acct.acct :

       put screen col 77 row 24 "(" + symb + ")" .

       /* полезли за остатками по счету  */
       RUN acct-pos IN h_base (acct.acct,
                              acct.currency,
                              end-date,
                              end-date,
                              CHR(251)).

       restsum = if ( sh-val NE 0 ) then sh-val else sh-bal. 

       restsum = if ( restsum < 0 ) then ( restsum * -1 ) else restsum.

       CASE symb :
          WHEN "\\"  THEN symb = "|".
          WHEN "|"   THEN symb = "/".
          WHEN "/"   THEN symb = "-".
          WHEN "-"   THEN symb = "\\".
       END CASE.
       put screen col 55 row 24 STRING(TRIM(acct.acct),"x(20)").

       ACCUMULATE restsum (TOTAL).
   end.

   restsumfull = ACCUM TOTAL restsum.
                                    
   put unformatted skip "Депозиты Д/В Ю/Л     " 
                         R2_DepDVUL FORMAT "x(40)" " "
                         restsumfull FORMAT "->>>,>>>,>>>,>>9.99".


   restsumfull = 0.
   FOR EACH bal-acct WHERE CAN-DO(R2_DepDVFL,STRING(bal-acct.bal-acct,"99999")) NO-LOCK,
       EACH acct OF bal-acct WHERE open-date LE end-date
                             AND ( ( close-date GE end-date ) OR ( close-date EQ ? ) ) 
                             AND CAN-DO(cur,acct.currency)
           NO-LOCK BREAK BY acct.acct :

       put screen col 77 row 24 "(" + symb + ")" .

       /* полезли за остатками по счету  */
       RUN acct-pos IN h_base (acct.acct,
                              acct.currency,
                              end-date,
                              end-date,
                              CHR(251)).

       restsum = if ( sh-val NE 0 ) then sh-val else sh-bal. 

       restsum = if ( restsum < 0 ) then ( restsum * -1 ) else restsum.

       CASE symb :
          WHEN "\\"  THEN symb = "|".
          WHEN "|"   THEN symb = "/".
          WHEN "/"   THEN symb = "-".
          WHEN "-"   THEN symb = "\\".
       END CASE.
       put screen col 55 row 24 STRING(TRIM(acct.acct),"x(20)").

       ACCUMULATE restsum (TOTAL).
   end.

   restsumfull = ACCUM TOTAL restsum.
                                    
   put unformatted skip "Депозиты Д/В Ф/Л     " 
                         R2_DepDVFL FORMAT "x(40)" " "
                         restsumfull FORMAT "->>>,>>>,>>>,>>9.99".


   restsumfull = 0.
   FOR EACH bal-acct WHERE CAN-DO(R2_RSUL,STRING(bal-acct.bal-acct,"99999")) NO-LOCK,
       EACH acct OF bal-acct WHERE open-date LE end-date
                             AND ( ( close-date GE end-date ) OR ( close-date EQ ? ) ) 
                             AND CAN-DO(cur,acct.currency)
           NO-LOCK BREAK BY acct.acct :

       put screen col 77 row 24 "(" + symb + ")" .

       /* полезли за остатками по счету  */
       RUN acct-pos IN h_base (acct.acct,
                              acct.currency,
                              end-date,
                              end-date,
                              CHR(251)).

       restsum = if ( sh-val NE 0 ) then sh-val else sh-bal. 

       restsum = if ( restsum < 0 ) then ( restsum * -1 ) else restsum.

       CASE symb :
          WHEN "\\"  THEN symb = "|".
          WHEN "|"   THEN symb = "/".
          WHEN "/"   THEN symb = "-".
          WHEN "-"   THEN symb = "\\".
       END CASE.
       put screen col 55 row 24 STRING(TRIM(acct.acct),"x(20)").

       ACCUMULATE restsum (TOTAL).
   end.

   restsumfull = ACCUM TOTAL restsum.
                                    
   put unformatted skip "Расчетные счета Ю/Л  " 
                         R2_RSUL FORMAT "x(40)" " "
                         restsumfull FORMAT "->>>,>>>,>>>,>>9.99".


   restsumfull = 0.
   FOR EACH bal-acct WHERE CAN-DO(R2_CenBum,STRING(bal-acct.bal-acct,"99999")) NO-LOCK,
       EACH acct OF bal-acct WHERE open-date LE end-date
                             AND ( ( close-date GE end-date ) OR ( close-date EQ ? ) ) 
                             AND CAN-DO(cur,acct.currency)
           NO-LOCK BREAK BY acct.acct :

       put screen col 77 row 24 "(" + symb + ")" .

       /* полезли за остатками по счету  */
       RUN acct-pos IN h_base (acct.acct,
                              acct.currency,
                              end-date,
                              end-date,
                              CHR(251)).

       restsum = if ( sh-val NE 0 ) then sh-val else sh-bal. 

       restsum = if ( restsum < 0 ) then ( restsum * -1 ) else restsum.

       CASE symb :
          WHEN "\\"  THEN symb = "|".
          WHEN "|"   THEN symb = "/".
          WHEN "/"   THEN symb = "-".
          WHEN "-"   THEN symb = "\\".
       END CASE.
       put screen col 55 row 24 STRING(TRIM(acct.acct),"x(20)").

       ACCUMULATE restsum (TOTAL).
   end.

   restsumfull = ACCUM TOTAL restsum.
                                    
   put unformatted skip "Ценные бумаги        " 
                         R2_CenBum FORMAT "x(40)" " "
                         restsumfull FORMAT "->>>,>>>,>>>,>>9.99".


   restsumfull = 0.
   FOR EACH bal-acct WHERE CAN-DO(R2_MBK,STRING(bal-acct.bal-acct,"99999")) NO-LOCK,
       EACH acct OF bal-acct WHERE open-date LE end-date
                             AND ( ( close-date GE end-date ) OR ( close-date EQ ? ) ) 
                             AND CAN-DO(cur,acct.currency)
           NO-LOCK BREAK BY acct.acct :

       put screen col 77 row 24 "(" + symb + ")" .

       /* полезли за остатками по счету  */
       RUN acct-pos IN h_base (acct.acct,
                              acct.currency,
                              end-date,
                              end-date,
                              CHR(251)).

       restsum = if ( sh-val NE 0 ) then sh-val else sh-bal. 

       restsum = if ( restsum < 0 ) then ( restsum * -1 ) else restsum.

       CASE symb :
          WHEN "\\"  THEN symb = "|".
          WHEN "|"   THEN symb = "/".
          WHEN "/"   THEN symb = "-".
          WHEN "-"   THEN symb = "\\".
       END CASE.
       put screen col 55 row 24 STRING(TRIM(acct.acct),"x(20)").

       ACCUMULATE restsum (TOTAL).
   end.

   restsumfull = ACCUM TOTAL restsum.
                                    
   put unformatted skip "МБК                  " 
                         R2_MBK FORMAT "x(40)" " "
                         restsumfull FORMAT "->>>,>>>,>>>,>>9.99".


put screen col 1 row 24 color normal 
       STRING(" ","X(80)").

{signatur.i &user-only=yes}
{preview.i}
