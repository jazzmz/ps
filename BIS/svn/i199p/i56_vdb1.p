{pirsavelog.p}

/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2001 ТОО "Банковские информационные системы"
     Filename: pr56_vdb1.p
      Comment: Справка о суммах принятой и выданной денежной наличности
   Parameters:
         Uses:
      Used by:
      Created: 13.06.2004 sadm
     Modified:

*/

{globals.i}
{wordwrap.def}
{norm.i}
{tmprecid.def}        /** Используем информацию из броузера */
{get-bankname.i}
DEFINE INPUT PARAMETER in-data-id LIKE DataBlock.Data-Id NO-UNDO.

DEFINE VARIABLE vNatCurCod AS CHARACTER NO-UNDO.
DEFINE VARIABLE mdeTotSumByDb AS DECIMAL NO-UNDO.
DEFINE VARIABLE mdeTotSumByCt AS DECIMAL NO-UNDO.
DEFINE VARIABLE miTotNumByDb  AS INTEGER NO-UNDO.
DEFINE VARIABLE miTotNumByCt  AS INTEGER NO-UNDO.
DEFINE VARIABLE mchBossCash   AS CHARACTER NO-UNDO.
DEFINE VARIABLE mchBankName   AS CHARACTER EXTENT 3 FORMAT "X(40)" NO-UNDO.
DEFINE VARIABLE i             AS INTEGER NO-UNDO.

def buffer tempDataBlock for DataBlock.
def buffer tempDataLine  for DataLine.
def buffer tempDataClass for DataClass.
def var str_amt as char no-undo.
def var str_dec as char no-undo.
def var str_summa as dec no-undo.
def var str_val as char no-undo.

vNatCurCod = fGetSetting("КодНацВал", ?, "").
find DataBlock where DataBlock.Data-Id eq in-Data-Id no-lock no-error.
find first DataClass where DataClass.DataClass-id = entry(1,DataBlock.DataClass-id,'@') no-lock.

for each tmprecid:
    delete tmprecid.
end.

/* ввести имя пользователя (или нескольких) */
run br-user.p (4).

FIND FIRST branch WHERE branch.branch-id EQ sh-branch-id NO-LOCK NO-ERROR.
IF AVAILABLE branch THEN DO:
/*   mchBankName = branch.name.*/
   mchBankName[1] = cBankNameS.
   mchBossCash = GetXattrValue ("branch", DataBlock.branch-id, "ЗавКас").
END.
ELSE DO:
/*  {get_set.i "БанкС"}
  mchBankName[1] = setting.val.*/
  mchBankName[1] = cBankNameS.
END.
{wordwrap.i &s=mchBankName &n=3 &l=40}

&GLOB width 115

{setdest.i &cols = {&width}}

FOR EACH tmprecid:
   FIND FIRST _user WHERE RECID(_user) = tmprecid.id NO-LOCK NO-ERROR.
   IF AVAILABLE _user AND CAN-FIND(FIRST DataLine OF DataBlock
                                   WHERE ENTRY(1, DataLine.Sym1, "_") = _user._userid
                                     AND DataLine.Sym2 = "b"
                          )
      THEN DO:


 if datablock.branch-id = "00002" then 
 do:
 put skip
          "                                                                                  ┌───────────────────┐" skip
          "                                                                                  │   ОБСЛУЖИВАНИЕ    │" skip
          "                                                                                  │В ПОСЛЕОПЕРАЦИОННОЕ│" skip
          "                                                                                  │       ВРЕМЯ       │" skip
          "                                                                                  └───────────────────┘" skip.
 end.

      i = 1.
      DO WHILE i LE 3 AND mchBankName[i] NE "" :
         PUT UNFORMATTED mchBankName[i] SKIP.
         i = i + 1.
      END.




      PUT UNFORMATTED
          "────────────────────────────────────────" SKIP
          "  (наименование кредитной организации)" SKIP
          SKIP(1)
          "                                                СПРАВКА" SKIP
          "                           о суммах принятой и выданной денежной наличности" SKIP
          "                                            за " {term2str DataBlock.beg-date DataBlock.end-date} FORMAT "x(20)" SKIP
          SKIP(1)
          "   Получено для совершения операций:" SKIP
          "   Суммы валют по наименованиям (кодам)"  SKIP
          .
   	  
find first tempdataclass where tempdataclass.dataclass-id = "i56_3" no-error.
if avail tempdataclass then do:
     for each tempdatablock where tempdatablock.dataclass-id = tempdataclass.dataclass-id 
                        and tempdatablock.Beg-Date = datablock.Beg-Date
                        and tempdatablock.End-Date = datablock.End-Date
			and tempdatablock.branch-id = datablock.branch-id:
        for each tempdataline where tempdatablock.data-Id = tempdataline.data-Id
                        and ENTRY(1, tempdataLine.Sym1, "_") EQ _user._userid
                        .
            find FIRST CURRENCY WHERE currency.currency = tempDataLine.Sym3 no-error.
            if not avail currency then next.
            str_summa = (IF tempDataLine.Sym3 = "" THEN tempdataline.Val[2] ELSE tempdataline.Val[1]).
            str_val = tempDataLine.Sym3.
            RUN x-amtstr.p(str_summa,str_val, TRUE, TRUE, OUTPUT str_amt, OUTPUT  str_dec).
            PUT UNFORMATTED 
            currency.name-currenc + " (" + 
           (IF tempDataLine.Sym3 = "" THEN vNatCurCod ELSE tempDataLine.Sym3) + ")" 
           (IF tempDataLine.Sym3 = "" THEN tempdataline.Val[2] ELSE tempdataline.Val[1])  FORMAT ">>>,>>>,>>9.99"  
           " " + str_amt + " " + str_dec 
           skip
      .
      end.
   end.                     
end.
else do:
   PUT UNFORMATTED
       "                                       ────────────────────────────────────────────────────────────────────────" SKIP
       SKIP(1)
       "   ────────────────────────────────────────────────────────────────────────────────────────────────────────────" SKIP
       SKIP(1)
       "   ────────────────────────────────────────────────────────────────────────────────────────────────────────────" SKIP
       SKIP(1)
       "   ────────────────────────────────────────────────────────────────────────────────────────────────────────────" SKIP
   .
end.
     PUT UNFORMATTED

          "                                           (цифрами и прописью)" SKIP
          SKIP(1)
          "┌───────────────────────────────────┬───────────────────────────────┬───────────────────────────────┬─────────────┐" skip
          "│                                   │            Приход             │            Расход             │             │" skip
          "│Наименование (код)                 ├───────────┬───────────────────┼───────────┬───────────────────┤   Подписи   │" skip
          "│      валюты                       │количество │                   │количество │                   │бухгалтерских│" skip
          "│                                   │документов │ сумма по номиналу │документов │ сумма по номиналу │  работников │" skip
          "│                                   │           │                   │           │                   │             │" skip
          "├───────────────────────────────────┼───────────┼───────────────────┼───────────┼───────────────────┼─────────────┤" skip
      .                             
      

      find first tempdataclass where tempdataclass.dataclass-id = "i56_3" no-error.
      find first  tempdatablock where tempdatablock.dataclass-id = tempdataclass.dataclass-id 
                  and tempdatablock.Beg-Date = datablock.Beg-Date
                  and tempdatablock.End-Date = datablock.End-Date
		  and tempdatablock.branch-id = datablock.branch-id
                  no-error.
      for each tempdataline where tempdatablock.data-Id = tempdataline.data-Id
                 and ENTRY(1, tempdataLine.Sym1, "_") EQ _user._userid
 
                 .
  
            tempdataline.Val[3] = 0.
            tempdataline.Val[4] = 0.
            tempdataline.Val[5] = 0.
            tempdataline.Val[7] = 0.
            tempdataline.Val[6] = 0.
            tempdataline.Val[8] = 0.

      end.
      FOR EACH DataLine OF DataBlock
               WHERE  ENTRY(1, DataLine.Sym1, "_") EQ _user._userid
              AND DataLine.Sym2 EQ "b"
      NO-LOCK BREAK  /* BY ENTRY(2, DataLine.Sym1, "_") */ BY DataLine.Sym3  BY DataLine.Sym4  :
   
         ACCUMULATE
            DataLine.Val[1] (TOTAL BY DataLine.Sym4)
            DataLine.Val[2] (TOTAL BY DataLine.Sym4)
            DataLine.Val[6] (TOTAL BY DataLine.Sym4)
         .
         IF FIRST-OF(DataLine.Sym3) THEN
            ASSIGN mdeTotSumByDb = 0
                   mdeTotSumByCt = 0
                   miTotNumByDb  = 0
                   miTotNumByCt  = 0
            .
         IF LAST-OF(DataLine.Sym4) THEN DO:
            IF DataLine.Sym4 EQ "db" THEN DO:
               mdeTotSumByDb = mdeTotSumByDb + IF DataLine.Sym3 = "" THEN ACCUM TOTAL BY DataLine.Sym4 DataLine.Val[2] ELSE  ACCUM TOTAL BY DataLine.Sym4 DataLine.Val[1].
               miTotNumByDb  = miTotNumByDb + ACCUM TOTAL BY DataLine.Sym4 DataLine.Val[6].
               END.
            ELSE DO:
               mdeTotSumByCt = mdeTotSumByCt + IF DataLine.Sym3 = "" THEN ACCUM TOTAL BY DataLine.Sym4 DataLine.Val[2] ELSE  ACCUM TOTAL BY DataLine.Sym4 DataLine.Val[1].
               miTotNumByCt  = miTotNumByCt + ACCUM TOTAL BY DataLine.Sym4 DataLine.Val[6].
            END.
         END.
         IF LAST-OF(DataLine.Sym3) THEN DO:
            FOR FIRST CURRENCY WHERE currency.currency = DataLine.Sym3 NO-LOCK:
               PUT UNFORMATTED
                   "│" currency.name-currenc + " (" + 
                      (IF DataLine.Sym3 = "" THEN vNatCurCod ELSE DataLine.Sym3) + ")" format "x(35)"
                   "│" miTotNumByDb  FORMAT ">>>>>>>>>>9" 
                   "│" mdeTotSumByDb FORMAT ">>>>,>>>,>>>,>>9.99"
                   "│" miTotNumByCt  FORMAT ">>>>>>>>>>9" 
                   "│" mdeTotSumByCt FORMAT ">>>>,>>>,>>>,>>9.99"
                   "│             │     " /* ENTRY(2, DataLine.Sym1, "_") */  SKIP                           

                   "│" format "x(36)"
                   "│" FORMAT "x(12)" 
                   "│" FORMAT "x(20)"
                   "│" FORMAT "x(12)" 
                   "│" FORMAT "x(20)"
                   "│             │     "  SKIP                           

               .
               find first tempdataclass where tempdataclass.dataclass-id = "i56_3" no-error.
               find first  tempdatablock where tempdatablock.dataclass-id = tempdataclass.dataclass-id 
                        and tempdatablock.Beg-Date = datablock.Beg-Date
                        and tempdatablock.End-Date = datablock.End-Date
			and tempdatablock.branch-id = datablock.branch-id
                        no-error.
               find first tempdataline where tempdatablock.data-Id = tempdataline.data-Id
                        and ENTRY(1, tempdataLine.Sym1, "_") EQ _user._userid
 
                        and tempDataLine.Sym3 = DataLine.Sym3 no-error.
               if not avail tempdataline then next.
               IF tempDataLine.Sym3 = "" 
               THEN do:
                  tempdataline.Val[5] = tempdataline.Val[5] + mdeTotSumByDb.
                  tempdataline.Val[7] = tempdataline.Val[7] + mdeTotSumByCt.
                  tempdataline.Val[4] = tempdataline.Val[2] + tempdataline.Val[5] - tempdataline.Val[7].
               end.
               else do:
                 tempdataline.Val[6] = tempdataline.Val[6] + mdeTotSumByDb.
                 tempdataline.Val[8] = tempdataline.Val[8] + mdeTotSumByCt.
                 tempdataline.Val[3] = tempdataline.Val[1] + tempdataline.Val[6] -  tempdataline.Val[8].
               end.
	             
            END.
         END.
      END.
      PUT UNFORMATTED
         "└───────────────────────────────────┴───────────┴───────────────────┴───────────┴───────────────────┴─────────────┘" SKIP
         SKIP(1)
         "   Остаток на конец дня:"  SKIP
         "   Суммы валют по наименованиям (кодам)" SKIP

.

find first tempdataclass where tempdataclass.dataclass-id = "i56_3".
if avail tempdataclass 
then do:
     for each tempdatablock where tempdatablock.dataclass-id = tempdataclass.dataclass-id 
                        and tempdatablock.Beg-Date = datablock.Beg-Date
                        and tempdatablock.End-Date = datablock.End-Date
			and tempdatablock.branch-id = datablock.branch-id 
                       .
        for each tempdataline where tempdatablock.data-Id = tempdataline.data-Id
                        and ENTRY(1, tempdataLine.Sym1, "_") EQ _user._userid


                        .
            find FIRST CURRENCY WHERE currency.currency = tempDataLine.Sym3 no-error.
            if not avail currency then next.
            str_summa = (IF tempDataLine.Sym3 = "" THEN if tempdataline.Val[4]= 0 then tempdataline.Val[2] else tempdataline.Val[4] 
	                                           ELSE if tempdataline.Val[3] = 0 and tempdataline.Val[6] = 0 and tempdataline.Val[8] = 0 then tempdataline.Val[1] else tempdataline.Val[3]).
            str_val = tempDataLine.Sym3.
            RUN x-amtstr.p(str_summa,str_val, TRUE, TRUE, OUTPUT str_amt, OUTPUT  str_dec).
            PUT UNFORMATTED 
            currency.name-currenc + " (" + 
           (IF tempDataLine.Sym3 = "" THEN vNatCurCod ELSE tempDataLine.Sym3) + ")" 
           (IF tempDataLine.Sym3 = "" THEN if tempdataline.Val[4]= 0 then tempdataline.Val[2] else tempdataline.Val[4] 
             ELSE if tempdataline.Val[3] = 0 and tempdataline.Val[6] = 0 and tempdataline.Val[8] = 0 then tempdataline.Val[1] else tempdataline.Val[3])  FORMAT ">>>,>>>,>>9.99"  
           " " + str_amt
           " " + str_dec  
           skip
      .
      end.
   end.                     
end.

/* если нулевые обороты */
else do:
   PUT UNFORMATTED 

         "                                       ────────────────────────────────────────────────────────────────────────" SKIP
         SKIP(1)
         "   ────────────────────────────────────────────────────────────────────────────────────────────────────────────" SKIP
         SKIP(1)
         "   ────────────────────────────────────────────────────────────────────────────────────────────────────────────" SKIP
         SKIP(1)
         "   ────────────────────────────────────────────────────────────────────────────────────────────────────────────" SKIP
   .
end.

         PUT UNFORMATTED 

         "                                           (цифрами и прописью)" SKIP
         SKIP(1)
         "   Кассовый работник                                  " _user._user-name SKIP
         "                       ─────────────────              ─────────────────────" SKIP
         "                           (подпись)                  (расшифровка подписи)" SKIP
         SKIP(1)
         "   Заведующий кассой                                  " mchBossCash SKIP
         "                       ─────────────────              ─────────────────────" SKIP
         "                           (подпись)                  (расшифровка подписи)" SKIP
      .
      PAGE.
   END.
   ELSE DO:
   
    if datablock.branch-id = "00002" then 
 do:
 put skip
          "                                                                                  ┌───────────────────┐" skip
          "                                                                                  │   ОБСЛУЖИВАНИЕ    │" skip
          "                                                                                  │В ПОСЛЕОПЕРАЦИОННОЕ│" skip
          "                                                                                  │       ВРЕМЯ       │" skip
          "                                                                                  └───────────────────┘" skip.
 end.

      i = 1.
      DO WHILE i LE 3 AND mchBankName[i] NE "" :
         PUT UNFORMATTED mchBankName[i] SKIP.
         i = i + 1.
      END.




      PUT UNFORMATTED
          "────────────────────────────────────────" SKIP
          "  (наименование кредитной организации)" SKIP
          SKIP(1)
          "                                                СПРАВКА" SKIP
          "                           о суммах принятой и выданной денежной наличности" SKIP
          "                                            за " {term2str DataBlock.beg-date DataBlock.end-date} FORMAT "x(20)" SKIP
          SKIP(1)
          "   Получено для совершения операций:" SKIP
          "   Суммы валют по наименованиям (кодам)"  SKIP
          .
   	  
find first tempdataclass where tempdataclass.dataclass-id = "i56_3" no-error.
if avail tempdataclass then do:
     for each tempdatablock where tempdatablock.dataclass-id = tempdataclass.dataclass-id 
                        and tempdatablock.Beg-Date = datablock.Beg-Date
                        and tempdatablock.End-Date = datablock.End-Date
			and tempdatablock.branch-id = datablock.branch-id:
        for each tempdataline where tempdatablock.data-Id = tempdataline.data-Id
                        and ENTRY(1, tempdataLine.Sym1, "_") EQ _user._userid
                        .
            find FIRST CURRENCY WHERE currency.currency = tempDataLine.Sym3 no-error.
            if not avail currency then next.
            str_summa = (IF tempDataLine.Sym3 = "" THEN tempdataline.Val[2] ELSE tempdataline.Val[1]).
            str_val = tempDataLine.Sym3.
            RUN x-amtstr.p(str_summa,str_val, TRUE, TRUE, OUTPUT str_amt, OUTPUT  str_dec).
            PUT UNFORMATTED 
            currency.name-currenc + " (" + 
           (IF tempDataLine.Sym3 = "" THEN vNatCurCod ELSE tempDataLine.Sym3) + ")" 
           (IF tempDataLine.Sym3 = "" THEN tempdataline.Val[2] ELSE tempdataline.Val[1])  FORMAT ">>>,>>>,>>9.99"  
           " " + str_amt + " " + str_dec 
           skip
      .
      end.
   end.                     
end.
else do:
   PUT UNFORMATTED
       "                                       ────────────────────────────────────────────────────────────────────────" SKIP
       SKIP(1)
       "   ────────────────────────────────────────────────────────────────────────────────────────────────────────────" SKIP
       SKIP(1)
       "   ────────────────────────────────────────────────────────────────────────────────────────────────────────────" SKIP
       SKIP(1)
       "   ────────────────────────────────────────────────────────────────────────────────────────────────────────────" SKIP
   .
end.
     PUT UNFORMATTED

          "                                           (цифрами и прописью)" SKIP
          SKIP(1)
          "┌───────────────────────────────────┬───────────────────────────────┬───────────────────────────────┬─────────────┐" skip
          "│                                   │            Приход             │            Расход             │             │" skip
          "│Наименование (код)                 ├───────────┬───────────────────┼───────────┬───────────────────┤   Подписи   │" skip
          "│      валюты                       │количество │                   │количество │                   │бухгалтерских│" skip
          "│                                   │документов │ сумма по номиналу │документов │ сумма по номиналу │  работников │" skip
          "│                                   │           │                   │           │                   │             │" skip
          "├───────────────────────────────────┼───────────┼───────────────────┼───────────┼───────────────────┼─────────────┤" skip
       .
find first tempdataclass where tempdataclass.dataclass-id = "i56_3" no-error.
if avail tempdataclass then do:
     for each tempdatablock where tempdatablock.dataclass-id = tempdataclass.dataclass-id 
                        and tempdatablock.Beg-Date = datablock.Beg-Date
                        and tempdatablock.End-Date = datablock.End-Date
			and tempdatablock.branch-id = datablock.branch-id:
        for each tempdataline where tempdatablock.data-Id = tempdataline.data-Id
                        and ENTRY(1, tempdataLine.Sym1, "_") EQ _user._userid
                        .

            find FIRST CURRENCY WHERE currency.currency = tempDataLine.Sym3 no-error.
            if not avail currency then next.
       

               PUT UNFORMATTED
                   "│" currency.name-currenc + " (" + 
                      (IF tempDataLine.Sym3 = "" THEN vNatCurCod ELSE tempDataLine.Sym3) + ")" format "x(35)"
                   "│" miTotNumByDb  FORMAT ">>>>>>>>>>9" 
                   "│" mdeTotSumByDb FORMAT ">>>>,>>>,>>>,>>9.99"
                   "│" miTotNumByCt  FORMAT ">>>>>>>>>>9" 
                   "│" mdeTotSumByCt FORMAT ">>>>,>>>,>>>,>>9.99"
                   "│             │     " /* ENTRY(2, DataLine.Sym1, "_") */  SKIP                           

                   "│" format "x(36)"
                   "│" FORMAT "x(12)" 
                   "│" FORMAT "x(20)"
                   "│" FORMAT "x(12)" 
                   "│" FORMAT "x(20)"
                   "│             │     "  SKIP                           

               .

      end.
   end.                     
end.

       PUT UNFORMATTED
       
          "└───────────────────────────────────┴───────────┴───────────────────┴───────────┴───────────────────┴─────────────┘" SKIP
         SKIP(1)
         "   Остаток на конец дня:"  SKIP
         "   Суммы валют по наименованиям (кодам)" SKIP

.

find first tempdataclass where tempdataclass.dataclass-id = "i56_3".
if avail tempdataclass 
then do:
     for each tempdatablock where tempdatablock.dataclass-id = tempdataclass.dataclass-id 
                        and tempdatablock.Beg-Date = datablock.Beg-Date
                        and tempdatablock.End-Date = datablock.End-Date
			and tempdatablock.branch-id = datablock.branch-id 
                       .
        for each tempdataline where tempdatablock.data-Id = tempdataline.data-Id
                        and ENTRY(1, tempdataLine.Sym1, "_") EQ _user._userid


                        .
            find FIRST CURRENCY WHERE currency.currency = tempDataLine.Sym3 no-error.
            if not avail currency then next.
            str_summa = (IF tempDataLine.Sym3 = "" THEN if tempdataline.Val[4]= 0 then tempdataline.Val[2] else tempdataline.Val[4] 
	                                           ELSE if tempdataline.Val[3] = 0 and tempdataline.Val[6] = 0 and tempdataline.Val[8] = 0 then tempdataline.Val[1] else tempdataline.Val[3]).
            str_val = tempDataLine.Sym3.
            RUN x-amtstr.p(str_summa,str_val, TRUE, TRUE, OUTPUT str_amt, OUTPUT  str_dec).
            PUT UNFORMATTED 
            currency.name-currenc + " (" + 
           (IF tempDataLine.Sym3 = "" THEN vNatCurCod ELSE tempDataLine.Sym3) + ")" 
           (IF tempDataLine.Sym3 = "" THEN if tempdataline.Val[4]= 0 then tempdataline.Val[2] else tempdataline.Val[4] 
             ELSE if tempdataline.Val[3] = 0 and tempdataline.Val[6] = 0 and tempdataline.Val[8] = 0 then tempdataline.Val[1] else tempdataline.Val[3])  FORMAT ">>>,>>>,>>9.99"  
           " " + str_amt
           " " + str_dec  
           skip
      .
      end.
   end.                     
end.
else do:
   PUT UNFORMATTED 

         "                                       ────────────────────────────────────────────────────────────────────────" SKIP
         SKIP(1)
         "   ────────────────────────────────────────────────────────────────────────────────────────────────────────────" SKIP
         SKIP(1)
         "   ────────────────────────────────────────────────────────────────────────────────────────────────────────────" SKIP
         SKIP(1)
         "   ────────────────────────────────────────────────────────────────────────────────────────────────────────────" SKIP
   .
end.

         PUT UNFORMATTED 

         "                                           (цифрами и прописью)" SKIP
         SKIP(1)
         "   Кассовый работник                                  " _user._user-name SKIP
         "                       ─────────────────              ─────────────────────" SKIP
         "                           (подпись)                  (расшифровка подписи)" SKIP
         SKIP(1)
         "   Заведующий кассой                                  " mchBossCash SKIP
         "                       ─────────────────              ─────────────────────" SKIP
         "                           (подпись)                  (расшифровка подписи)" SKIP
      .
      PAGE.
   END.

END.
{empty tmprecid}
{preview.i }
