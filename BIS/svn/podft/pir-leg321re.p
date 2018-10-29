{pirsavelog.p}

/*
                Банковская интегрированная система БИСквит
    Copyright: (C) 1992-1996 ТОО "Банковские информационные системы"
     Filename: leg321re.p
      Comment: Печать реестра из класса Legal321
               согласно положению 321-П (отмывание доходов)
         Uses:
      Used BY:
      Created: 26/10/2005 Anisimov
       Edited: 12/01/2009 Borisov
*/
/******************************************************************************/
{globals.i}
{repinfo.i}
{norm.i NEW}

{intrface.get xclass}
{intrface.get strng}
{leg207p.def}
{leg161p.fun}

DEFINE INPUT PARAMETER ipDataID  AS INTEGER NO-UNDO.
DEFINE INPUT PARAMETER iParmStr AS CHARACTER NO-UNDO.

/* DEFINE BUFFER bDataLine FOR DataLine. */
DEFINE VAR    hWrite   AS handle     NO-UNDO.

DEFINE VAR mErrCount   AS INTEGER    NO-UNDO.
DEFINE VAR mError      AS INTEGER    NO-UNDO.
DEFINE VAR mNumber     AS INTEGER    NO-UNDO.
DEFINE VAR mCod        AS CHARACTER  NO-UNDO.
DEFINE VAR mSign       AS CHARACTER  NO-UNDO.
DEFINE VAR cTD         AS CHARACTER  NO-UNDO.
DEFINE VAR cA1         AS CHARACTER  NO-UNDO.
DEFINE VAR cA2         AS CHARACTER  NO-UNDO.
DEFINE VAR cA3         AS CHARACTER  NO-UNDO.
DEFINE VAR cA4         AS CHARACTER  NO-UNDO.
DEFINE VAR cA5         AS CHARACTER  NO-UNDO.
DEFINE VAR cA6         AS CHARACTER  NO-UNDO.
DEFINE VAR cDatDoc     AS CHARACTER  NO-UNDO.
DEFINE VAR cDatMigr1   AS CHARACTER  NO-UNDO.
DEFINE VAR cDatMigr2   AS CHARACTER  NO-UNDO.
DEFINE VAR daBeg       AS DATE       NO-UNDO.
DEFINE VAR daEnd       AS DATE       NO-UNDO.
DEFINE VAR daOtp       AS DATE       NO-UNDO.

DEFINE BUFFER Data0 FOR DataLine.
DEFINE BUFFER Data1 FOR DataLine.
DEFINE BUFFER Data2 FOR DataLine.

DEFINE QUERY qData  FOR DataBlock, Data0, Data1.

FUNCTION GetDat0Txt RETURN CHAR    (INPUT ipItem   AS INTEGER) forward.
FUNCTION GetDat1Txt RETURN CHAR    (INPUT ipItem   AS INTEGER) forward.
FUNCTION GetDat2Txt RETURN CHAR    (INPUT ipItem   AS INTEGER) forward.
/*============================================================================*/
{fexp-chk.i &DataID = ipDataID}

mCod  = GetEntries(2, iParmStr,";",?).
mSign = GetEntries(1, iParmStr,";",?).

FIND FIRST setting WHERE setting.code     EQ "Legal207"
                     AND setting.sub-code EQ "НомерПП"
                         SHARE-LOCK NO-ERROR.
IF NOT AVAILABLE(setting) THEN DO:
   MESSAGE "Данные в КФМ экспортируются другим пользователем." SKIP
           "Попробуйте позже."                                 SKIP
           VIEW-AS ALERT-BOX INFORMATION.
   RETURN.
END.
FIND current DataBlock SHARE-LOCK NO-ERROR.
IF NOT AVAILABLE(DataBlock) THEN DO:
   MESSAGE "Блок данных изменяется другим пользователем." SKIP
           "Попробуйте позже."                            SKIP
           VIEW-AS ALERT-BOX INFORMATION.
   RETURN.
END.

/* ----------------------------------------------------- */
beg-date = DataBlock.beg-date.
end-date = DataBlock.end-date.
{getdates.i &TitleLabel = "Interval" &noinit = YES}
daBeg    = beg-date.
daEnd    = end-date.

end-date = end-date + 1.
DO WHILE holiday(end-date):
   end-date = end-date + 1.
END.

{getdate.i  &TitleLabel = "Data otpravki" &noinit = YES}
daOtp = end-date.

{setdest.i &cols=275}
/* ----------------------------------------------------- */

{getbrnch.i &SOATO     = vSoato
            &OKATO     = vOkato
            &REGN      = vRegNum
            &BANKCODE  = vBankCode
            &BRANCH    = Branch.Branch-ID
}

/* читаем бд  */
OPEN QUERY qData PRESELECT
   EACH DataBlock
      WHERE (datablock.DataClass-Id EQ "Legal321")
        AND (DataBlock.beg-date     GE daBeg)
        AND (DataBlock.end-date     LE daEnd)
      NO-LOCK,
   EACH Data0
      WHERE (Data0.Data-ID EQ DataBlock.Data-ID)
        AND (Data0.Sym2    EQ {&MAIN-LINE})
        AND (DATE(ENTRY(3, Data0.Txt, "~n")) EQ daOtp)
      NO-LOCK,
   FIRST Data1
      WHERE (Data1.Data-ID EQ DataBlock.Data-ID)
        AND (Data1.Sym1    EQ Data0.Sym1)
        AND (Data1.Sym2    EQ {&BANK-LINE})
      NO-LOCK.

/* получаем первую запись */
get FIRST qData.
   if mCod = "6001" then
   put unformatted skip "                                                                          Реестр необычных операций, которые переданы в МГТУ Банка России в соответствии с положением ЦБ РФ 321-П " end-date FORMAT "99.99.9999" .
   else  
   do:
   put unformatted skip "                                                                               Реестр операций, подлежащих обязательному контролю в соответствии с положением ЦБ РФ 321-П,".
   put unformatted skip "                                                                                                     которые были переданы в МГТУ Банка России "  end-date FORMAT "99.99.9999" .
   end.
   put unformatted skip "+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+".
   put unformatted skip "| п/п |Номер | Дата отпр. | Дата опер. | Вал |      Сумма в валюте     |      Сумма в рублях     |Код оп|  Дополнительные коды операции    | Дополнительная информация об операции                                                                                           |".
   put unformatted skip "|            | Назначение платежа, основание проведения операции                                                                                                                                                                                                             |".
   put unformatted skip "|            |        Наименование плательщика        |    ИНН     |ТД|ОКПО/Серия|ОГРН/Номер документа| Дата рег.|     Когда и кем выдан документ удостоверяющий личность     |    Данные миграционной карты   | ОКСМ|Адрес регистрации                                      |".
   put unformatted skip "|            |        Наименование получателя         |    ИНН     |ТД|ОКПО/Серия|ОГРН/Номер документа| Дата рег.|     Когда и кем выдан документ удостоверяющий личность     |    Данные миграционной карты   | ОКСМ|Адрес регистрации                                      |".
   put unformatted skip "+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+".
mNumber = 1.


main-loop:
DO TRANSACTION WHILE AVAILABLE(Data0)
   ON ERROR  UNDO main-loop, LEAVE main-loop
   ON ENDKEY UNDO main-loop, LEAVE main-loop:


   FIND FIRST DataLine WHERE recid(DataLine) EQ recid(Data0)
              EXCLUSIVE-LOCK NO-ERROR.

   IF NOT AVAILABLE(DataLine) or not can-do(mCod,string(Data0.Sym3)) /* or end-date ne date(GetEntries(5,Data0.Txt,"~n",{&E-DATE})) */ THEN DO:
      get NEXT qData.
      NEXT main-loop.
   END.

   put unformatted skip "|" mNumber FORMAT ">>>>9" "|"
                             Data0.Val[1]           FORMAT ">>>>>9" "| "
                             DATE(GetEntries( 3,Data0.Txt,"~n",{&E-DATE})) FORMAT "99.99.9999" " | "
                             DATE(GetEntries( 9,Data0.Txt,"~n",{&E-DATE})) FORMAT "99.99.9999" " | "
                             string(GetDat0Txt(10),        "x(3)") " | "
                             string(Data0.Val[3],   "->>>,>>>,>>>,>>>,>>9.99") " | "
                             string(Data0.Val[2],   "->>>,>>>,>>>,>>>,>>9.99") " | "
                             string(Data0.Sym3,           "x(4)")  " | "
                             string(GetDat0Txt( 8)     ,  "x(32)") " | "
                             TRIM(GetDat0Txt(17))  FORMAT "x(127)" " | ".
   put unformatted skip "|            |"
                             string(GetDat0Txt(11), "x(255)") "|".
/*
   put unformatted skip "+--------+".
*/
/* получаем данные о плательщике */
   FIND FIRST Data2 WHERE Data2.Data-ID EQ DataBlock.Data-ID
                      AND Data2.Sym1    EQ Data0.Sym1
                      AND Data2.Sym2    EQ {&SEND-LINE}
                      NO-LOCK NO-ERROR.
/*
   put unformatted skip Data2.Txt.
*/
   cTD = GetDat2Txt(20).
   cA1 = GetDat2Txt(07).
   cA1 = IF (cA1 = "0") THEN "" ELSE (cA1 + ",").
   cA2 = GetDat2Txt(08).
   cA2 = IF (cA2 = "0") THEN "" ELSE (cA2 + ",").
   cA3 = GetDat2Txt(09).
   cA3 = IF (cA3 = "0") THEN "" ELSE (cA3 + ",").
   cA4 = GetDat2Txt(10).
   cA4 = IF (cA4 = "0") THEN "" ELSE cA4.
   cA5 = GetDat2Txt(11).
   cA5 = IF (cA5 = "0") THEN "" ELSE ("-" + cA5).
   cA6 = GetDat2Txt(12).
   cA6 = IF (cA6 = "0") THEN "" ELSE ("-" + cA6).
   cDatDoc   = GetDat2Txt(26).
   cDatDoc   = IF cDatDoc   = "01/01/2099" THEN "" ELSE "," + string(DATE(cDatDoc), "99.99.99").
   cDatMigr1 = GetDat2Txt(32).
   cDatMigr1 = IF cDatMigr1 = "01/01/2099" THEN "" ELSE "," + string(DATE(cDatMigr1), "99.99.99").
   cDatMigr2 = GetDat2Txt(33).
   cDatMigr2 = IF cDatMigr2 = "01/01/2099" THEN "" ELSE "-" + string(DATE(cDatMigr2), "99.99.99").

   put unformatted skip "|            |"
     string(GetDat2Txt( 3), "x(40)") "|"
     string(GetDat2Txt(23), "x(12)") "|"
     string(cTD,             "x(2)") "|"
     string(GetDat2Txt(21), "x(10)") "|"
     string(IF cTD = "0" THEN GetDat2Txt(22) ELSE GetDat2Txt(24), "x(20)") "|"
     DATE(GetDat2Txt(34)) FORMAT "99.99.9999" "|"
     string(GetDat2Txt(25) + cDatDoc, "x(60)") "|"
     string(GetDat2Txt(31) + cDatMigr1 + cDatMigr2, "x(32)") "|"
     string(GetDat2Txt( 5),  "x(5)") "|"
     string(cA1 + cA2 + cA3 + cA4 + cA5 + cA6,      "x(55)") "|".
/*
   put unformatted skip "+--------+".
*/
/* получаем данные о получателе */
   FIND FIRST Data2 WHERE Data2.Data-ID EQ DataBlock.Data-ID
                      AND Data2.Sym1    EQ Data0.Sym1
                      AND Data2.Sym2    EQ {&RECV-LINE}
                      NO-LOCK NO-ERROR.
/*
   put unformatted skip Data2.Txt.
*/
   cTD = GetDat2Txt(20).
   cA1 = GetDat2Txt(07).
   cA1 = IF (cA1 = "0") THEN "" ELSE (cA1 + ",").
   cA2 = GetDat2Txt(08).
   cA2 = IF (cA2 = "0") THEN "" ELSE (cA2 + ",").
   cA3 = GetDat2Txt(09).
   cA3 = IF (cA3 = "0") THEN "" ELSE (cA3 + ",").
   cA4 = GetDat2Txt(10).
   cA4 = IF (cA4 = "0") THEN "" ELSE cA4.
   cA5 = GetDat2Txt(11).
   cA5 = IF (cA5 = "0") THEN "" ELSE ("-" + cA5).
   cA6 = GetDat2Txt(12).
   cA6 = IF (cA6 = "0") THEN "" ELSE ("-" + cA6).
   cDatDoc   = GetDat2Txt(26).
   cDatDoc   = IF cDatDoc   = "01/01/2099" THEN "" ELSE "," + string(DATE(cDatDoc), "99.99.99").
   cDatMigr1 = GetDat2Txt(32).
   cDatMigr1 = IF cDatMigr1 = "01/01/2099" THEN "" ELSE "," + string(DATE(cDatMigr1), "99.99.99").
   cDatMigr2 = GetDat2Txt(33).
   cDatMigr2 = IF cDatMigr2 = "01/01/2099" THEN "" ELSE "-" + string(DATE(cDatMigr2), "99.99.99").

   put unformatted skip "|            |"
     string(GetDat2Txt( 3), "x(40)") "|"
     string(GetDat2Txt(23), "x(12)") "|"
     string(cTD,             "x(2)") "|"
     string(GetDat2Txt(21), "x(10)") "|"
     string(IF cTD = "0" THEN GetDat2Txt(22) ELSE GetDat2Txt(24), "x(20)") "|"
     DATE(GetDat2Txt(34)) FORMAT "99.99.9999" "|"
     string(GetDat2Txt(25) + cDatDoc, "x(60)") "|"
     string(GetDat2Txt(31) + cDatMigr1 + cDatMigr2, "x(32)") "|"
     string(GetDat2Txt( 5),  "x(5)") "|"
     string(cA1 + cA2 + cA3 + cA4 + cA5 + cA6,      "x(55)") "|".

   put unformatted skip "+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+".


   ASSIGN
      mNumber = mNumber + 1
   .

   get NEXT qData.
END.
if mSign eq "Подпись" then
put unformatted skip(2) "Руководитель Банка : ________________ " skip (1).
{signatur.i &user-only = yes}
{preview.i}

RETURN.
/******************************************************************************/
FUNCTION GetDat0Txt RETURN CHAR (INPUT ipItem AS INTEGER):
   RETURN ClearExtSym(GetEntries(ipItem,Data0.Txt,"~n","0")).
END FUNCTION.
/*----------------------------------------------------------------------------*/
FUNCTION GetDat1Txt RETURN CHAR (INPUT ipItem AS INTEGER):
   RETURN ClearExtSym(GetEntries(ipItem,Data1.Txt,"~n","0")).
END FUNCTION.
/*----------------------------------------------------------------------------*/
FUNCTION GetDat2Txt RETURN CHAR (INPUT ipItem AS INTEGER):
IF AVAILABLE(Data2)
   THEN RETURN ClearExtSym(GetEntries(ipItem,Data2.Txt,"~n","0")).
   ELSE RETURN "0".
END FUNCTION.
