{pirsavelog.p}

/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2004 ТОО "Банковские информационные системы"
     Filename: rx-117i.p
      Comment: '117-И Печать реестра по проведенным операциям'
   Parameters:
         Uses: 
      Used by:
      Created: kraw (0047036)
      Modified: Бурягин Е.П. 15.05.2007 16:45 (Локальный код для поиска: БЕП0000003)
                Убрал экспорт полей старше 13-го для физических лиц. Индивидуальные предприниматели 
                в нашей базе хранятся с категорией "Ю", поэтому всех "Ч" отрезаем.
      Modified: Бурягин Е.П. 15.05.2007 16:52 (Локальный код для поиска: БЕП0000004)
                Если значение поля tt-117.bname и tt-117.bcode не заполнено, то 
                должны экспортироваться данные нашего банка.
      Modified: Бурягин Е.П. 15.05.2007 17:30 (Локальный код для поиска: БЕП0000005)
                Если значение поля tt-117.pname1 и tt-117.pname2 и tt-117.pinn пусты, то
                экспортироваться данные клиента из полей  tt-117.f-nam и tt-117.cinn соответственно.
      Modified: Бурягин Е.П. 23.05.2007 10:10 (Локальный код для поиска: БЕП0000006)
                Добавил дополнительную проверку, связанную также с изменениями БЕП0000005. 
                Проверка предназначена для дополнения информацией о получателе в записи о внутренней операции 
                (с счета одного нашего клиента на счет другого нашего клиента).
                Суть проверки заключается в том, что для записи tt-117 в случае не заполнения полей
                tt-117.pname1, tt-117pname2 и tt-117.pinn, в коде настоящей процедуры снова 
                из БД выбирается документ (данные для этого хранятся в поле tt-117.tsurr; 
                формат: [op.op,op-entry.op-entry] = [9999999,9999]) для выяснения факта:
                одинаковые ли клиенты по у дебетового и кредитового счета. Дело в том, что ree-117i.i 
                для внутренних операций при заполении записи tt-117 не заполняет указанные выше поля.
                Если поля не заполнены, то нужно найти корреспондирующий с tt-117.c-acc счет, найти его клиента, и
                если клиент отличен от клиента счета tt-117.c-acc, то заполнить требуемые поля соответсвующими значениями.
      Modified: Бурягин Е.П. 24.05.2007 9:49 (Локальный код для поиска: БЕП0000007)
                Нужно проконтролировать и в случае необходимости исправить ситуацию с заполнением номера паспорта
                сделки для записей tt-117, для которых ccode <> 643 (Россия) и счет клиента в проводке
                находится по кредиту. Для таких записей поле r-PSd не должно заполняться.
      Modified: Бурягин Е.П. 20.02.2008 13:19 (Локальный код для поиска: БЕП000008)
                Только предположение: Из-за системного механизма определения наименования клиента физ.лица
                согласно 275-ФЗ при экспорте ФИО клиента с "нулевым" ИНН дополняется 
                адресом поживания. Будем калечить, чтобы лечить! ))
      Modified: Борисов А.В. 01.03.2011
                Переделал выгрузку в формате XL. Добавил стб."Код страны банка"
*/

{globals.i}
{wordwrap.def}
{bank-id.i}
{op-ident.i}
{intrface.get op}
{intrface.get netw}
{intrface.get olap}
{ulib.i}
{ree-117i.i}
{get-bankname.i}
DEFINE VARIABLE mIsExist       AS LOGICAL   NO-UNDO.
DEFINE VARIABLE corsAcctClient AS CHARACTER NO-UNDO.
DEFINE VARIABLE iBankCountry   AS INTEGER   NO-UNDO.
DEFINE VARIABLE iTmp           AS INTEGER   NO-UNDO.
def var dr as char no-undo. /* заявка #1995 */

DEFINE BUFFER bfrOpEntry       FOR op-entry.
DEFINE BUFFER bfrOpEntry2      FOR op-entry.
DEFINE BUFFER bfrAcctDB        FOR acct.
DEFINE BUFFER bfrAcctCR        FOR acct.

DEFINE VARIABLE cXL            AS CHARACTER NO-UNDO.

{pir_exf_exl.i}

cXL = STRING(YEAR(end-date)) + STRING(MONTH(end-date), "99") + STRING(DAY(end-date), "99").
cXL = "/home2/bis/quit41d/imp-exp/users/" + LC(UserID("bisquit")) + "/ree117.xls".
REPEAT:
   {getfile.i &filename = cXL &mode = create}
   LEAVE.
END.

/******************************************* Реализация */
PUT UNFORMATTED XLHead("ul", "CCDCCCNCCCCNCCCCCCCI", "200,150,72,14,42,28,100,214,103,100,28,100,28,92,38,150,72,214,92,28").

cXL = XLCell("Наименование клиента")
    + XLCell("Номер счета")
    + XLCell("Дата оп.")
    + XLCell("Напр")
    + XLCell("Код вила вал.оп.")
    + XLCell("Вал.оп.")
    + XLCell("Сумма")
    + XLCell("Наименование банка")
    + XLCell("БИК")
    + XLCell("Паспорт сделки")
    + XLCell("Вал.кон.")
    + XLCell("Сумма в вал.кон")
    + XLCell("")
    + XLCell("")
    + XLCell("")
    + XLCell("")
    + XLCell("")
    + XLCell("")
    + XLCell("")
    + XLCell("Код страны банка")
    + XLCell("Номер и дата договора") /* заявка #1995 */
    .
PUT UNFORMATTED XLRow(0) cXL XLRowEnd().


FOR EACH tt-117 
&IF DEFINED(data-client) EQ 0 &THEN
   BREAK BY tt-117.c-cat
         BY tt-117.c-nam
         BY tt-117.c-id
         BY tt-117.c-acc
         BY tt-117.op-dt:
&ELSE
   BREAK BY tt-117.op-dt
         BY tt-117.c-cat
         BY tt-117.c-nam
         BY tt-117.c-id
         BY tt-117.c-acc:
&ENDIF

   ASSIGN
      mBname[1]    = tt-117.bname
      mAdr[1]      = tt-117.adr
      mPName[1]    = tt-117.pname1 + " " + tt-117.pname2
      mCliName[1]  = tt-117.f-nam
      iBankCountry = ?
   .

   /** БЕП0000008: добавил 20.02.2008 13:26 */
   mPName[1] = ENTRY(1, mPName[1], CHR(10)).
   /** БЕП0000008: end */

   IF (tt-117.bcode NE "")
   THEN DO:
      iTmp = INTEGER(tt-117.bcode) NO-ERROR.
      IF     (LENGTH(tt-117.bcode) EQ 9)
         AND (NOT ERROR-STATUS:ERROR)
      THEN
         FIND FIRST banks-code
            WHERE (banks-code.bank-code-type EQ "МФО-9")
              AND (banks-code.bank-code      EQ tt-117.bcode)
            NO-LOCK NO-ERROR.
      ELSE
         FIND FIRST banks-code
            WHERE (banks-code.bank-code-type EQ "BIC")
              AND (banks-code.bank-code      EQ tt-117.bcode)
            NO-LOCK NO-ERROR.

      IF (AVAIL banks-code)
      THEN DO:
         FIND FIRST banks
            WHERE (banks.bank-id EQ banks-code.bank-id)
            NO-LOCK NO-ERROR.

         IF (AVAIL banks)
         THEN DO:
            FIND FIRST country
               WHERE (country.country-id EQ banks.country-id)
               NO-LOCK NO-ERROR.

            IF (AVAIL country)
            THEN iBankCountry = country.country-alt-id.
         END.
      END.
   END.

   /** БЕП0000004: добавил 15.05.2007 16:55 */
   IF     (mBname[1]    EQ "")
      AND (tt-117.bcode EQ "")
   THEN DO:
      mBname[1]    = cBankName.
      tt-117.bcode = FGetSetting("БанкМФО", "", "").
      iBankCountry = 643.
   END.
   /** БЕП0000004: end */

   /** БЕП0000005: добавил 15.05.2007 17:36 */
   IF     (mPName[1]   EQ "")
      AND (tt-117.pinn EQ "")
   THEN DO:
      /** БЕП0000006: добавил 23.05.2007 10:19 */
      /* Снова найдем "подозрительный" документ c учетом полупроводок */
      FIND FIRST bfrOpEntry
         WHERE (bfrOpEntry.op       EQ INT(ENTRY(1,tt-117.tsurr)))
           AND (bfrOpEntry.op-entry EQ INT(ENTRY(2,tt-117.tsurr)))
      NO-LOCK NO-ERROR.
      IF AVAIL bfrOpEntry
      THEN DO:


         IF (bfrOpEntry.acct-db NE ?)
         THEN 
            FIND FIRST bfrAcctDB
               WHERE (bfrAcctDB.acct EQ bfrOpEntry.acct-db)
            NO-LOCK.
         ELSE DO:
            /** Найдем счет по дебету полупроводки */
            FIND FIRST bfrOpEntry2
               WHERE (bfrOpEntry2.op       EQ bfrOpEntry.op)
                 AND (bfrOpEntry2.op-entry NE bfrOpEntry.op-entry)
                 AND (bfrOpEntry2.acct-db  NE ?)
            NO-LOCK NO-ERROR.
            IF AVAIL bfrOpEntry2
            THEN 
               FIND FIRST bfrAcctDB
                  WHERE (bfrAcctDB.acct EQ bfrOpEntry2.acct-db)
               NO-LOCK.
         END.

         IF (bfrOpEntry.acct-cr NE ?)
         THEN
            FIND FIRST bfrAcctCR
               WHERE (bfrAcctCR.acct EQ bfrOpEntry.acct-cr)
            NO-LOCK.
         ELSE DO:
            /** Найдем счет по дебету полупроводки */
            FIND FIRST bfrOpEntry2
               WHERE (bfrOpEntry2.op       EQ bfrOpEntry.op)
                 AND (bfrOpEntry2.op-entry NE bfrOpEntry.op-entry)
                 AND (bfrOpEntry2.acct-cr  NE ?)
            NO-LOCK NO-ERROR.
            IF AVAIL bfrOpEntry2
            THEN 
               FIND FIRST bfrAcctCR
                  WHERE (bfrAcctCR.acct EQ bfrOpEntry2.acct-cr)
               NO-LOCK.
         END.

         IF     CAN-DO("Ю,Ч", bfrAcctDB.cust-cat)
            AND CAN-DO("Ю,Ч", bfrAcctCR.cust-cat)
            AND NOT ((bfrAcctDB.cust-cat EQ bfrAcctCR.cust-cat)
                 AND (bfrAcctDB.cust-id  EQ bfrAcctCR.cust-id))
         THEN DO:
            /* Если оба счета клиентских, но клиенты не "равны" 
               найдем корреспондирующий счет и реквизиты его владельца (клиента) */
            IF bfrAcctDB.acct = tt-117.c-acc
            THEN 
               corsAcctClient = bfrAcctCR.cust-cat + "," + STRING(bfrAcctCR.cust-id).
            ELSE
               corsAcctClient = bfrAcctDB.cust-cat + "," + STRING(bfrAcctDB.cust-id).
               IF ENTRY(1, corsAcctClient) = "Ч"
               THEN DO:
                  FIND FIRST person
                     WHERE (person-id EQ INT(ENTRY(2, corsAcctClient)))
                  NO-LOCK.
                  mPName[1] = TRIM(person.name-last + " " + person.first-names).
                  tt-117.pinn = person.inn.
               END.
               IF ENTRY(1, corsAcctClient) = "Ю"
               THEN DO:
                  FIND FIRST cust-corp
                     WHERE (cust-corp.cust-id EQ INT(ENTRY(2, corsAcctClient)))
                  NO-LOCK.
                  mPName[1]   = TRIM(cust-corp.cust-stat + " " + cust-corp.name-corp).
                  tt-117.pinn = cust-corp.inn.
               END.
            END.
         ELSE DO:
            /** БЕП0000006: end */
            IF    CAN-DO("70107*,47405*", bfrAcctCR.acct)
               OR CAN-DO("47405*,42505*", bfrAcctDB.acct)
            THEN DO:
               mPName[1]   = cBankName. 
               tt-117.pinn = FGetSetting("ИНН","",""). 
            END.
            ELSE DO:
               mPName[1]   = mCliName[1].
               tt-117.pinn = tt-117.cinn. 
            END.
            /** БЕП0000006: добавил 23.05.2007 10:19 */
         END.
         /** БЕП0000006: end */
      END.
   END.
   /** БЕП0000005: end */

   /*  V.N.Ermilov: added extended checking to fix docs with accounts begins on 474*,452*,302 */  

   IF (tt-117.tsurr NE "")
   THEN DO:
      FIND FIRST bfrOpEntry
         WHERE (bfrOpEntry.op       EQ INT(ENTRY(1,tt-117.tsurr)))
           AND (bfrOpEntry.op-entry EQ INT(ENTRY(2,tt-117.tsurr)))
      NO-LOCK NO-ERROR.

      IF AVAIL bfrOpEntry
      THEN DO:


         IF bfrOpEntry.acct-db <> ?
         THEN 
            FIND FIRST bfrAcctDB
               WHERE (bfrAcctDB.acct EQ bfrOpEntry.acct-db)
            NO-LOCK.
         ELSE DO:
            /** Найдем счет по дебету полупроводки */
            FIND FIRST bfrOpEntry2
               WHERE (bfrOpEntry2.op       EQ bfrOpEntry.op)
                 AND (bfrOpEntry2.op-entry NE bfrOpEntry.op-entry)
                 AND (bfrOpEntry2.acct-db  NE ?)
            NO-LOCK NO-ERROR.

            IF AVAIL bfrOpEntry2
            THEN 
               FIND FIRST bfrAcctDB
                  WHERE (bfrAcctDB.acct EQ bfrOpEntry2.acct-db)
               NO-LOCK.
         END.

         IF (bfrOpEntry.acct-cr NE ?)
         THEN
            FIND FIRST bfrAcctCR
               WHERE (bfrAcctCR.acct EQ bfrOpEntry.acct-cr)
            NO-LOCK.
         ELSE DO:
            /** Найдем счет по дебету полупроводки */
            FIND FIRST bfrOpEntry2
               WHERE (bfrOpEntry2.op       EQ bfrOpEntry.op)
                 AND (bfrOpEntry2.op-entry NE bfrOpEntry.op-entry)
                 AND (bfrOpEntry2.acct-cr  NE ?)
            NO-LOCK NO-ERROR.

            IF AVAIL bfrOpEntry2
            THEN
               FIND FIRST bfrAcctCR
                  WHERE (bfrAcctCR.acct EQ bfrOpEntry2.acct-cr)
               NO-LOCK.
         END.
      END.

      IF    (bfrAcctDB.acct BEGINS "47405")
         OR (bfrAcctDB.acct BEGINS "452")
         OR (bfrAcctDB.acct BEGINS "453")
         OR (bfrAcctDB.acct BEGINS "47426")
         OR (bfrAcctDB.acct BEGINS "45205")
         OR (bfrAcctDB.acct BEGINS "52")
      /* OR (bfrAcctDB.acct BEGINS "30114")
         OR (bfrAcctDB.acct BEGINS "30222") */
         OR (bfrAcctCR.acct BEGINS "47405")
         OR (bfrAcctCR.acct BEGINS "4520")
         OR (bfrAcctCR.acct BEGINS "453")
         OR (bfrAcctCR.acct BEGINS "45812")
         OR (bfrAcctCR.acct BEGINS "47423")
         OR (bfrAcctCR.acct BEGINS "45912")
         OR (bfrAcctCR.acct BEGINS "70601")
      THEN DO:
         mPName[1]   = cBankName. 
         tt-117.pinn = FGetSetting("ИНН" ,"",""). 
      END.
   END.

   /** БЕП0000007: добавил 24.05.2007 10:14 */
   IF tt-117.ccode <> "643"
   THEN DO:
      /**
      FIND bfrOpEntry
         WHERE bfrOpEntry.op = INT(ENTRY(1, tt-117.tsurr)) 
           AND bfrOpEntry.op-entry = INT(ENTRY(2, tt-117.tsurr))
      NO-LOCK.
      IF tt-117.c-acc = bfrOpEntry.acct-cr
      THEN
      */
      tt-117.r-PSd = "".
   END.
   /** БЕП0000007: end */



/* Дополинтельно выводим если счет вклада */

if can-do("42505*,42506*",bfrOpEntry.acct-cr) 
then
do:

   cXL = XLCell(mCliName[1])
       + XLCell(bfrOpEntry.acct-cr)
       + XLDateCell(tt-117.op-dt)
       + XLCell("2")
       + XLCell(tt-117.r-KOV)
       + XLCell(tt-117.op-cu)
       + XLNumCell(tt-117.op-su)
       + XLCell(mBname[1])
       + XLCell(tt-117.bcode)
       + XLCell(tt-117.r-PSd)
       + XLCell(tt-117.r-VCO)
       .

   IF tt-117.r-SVC GT 0
   THEN cXL = cXL + XLNumCell(tt-117.r-SVC).
   ELSE cXL = cXL + XLEmptyCell().

   IF (tt-117.c-cat NE "Ч")
   THEN
      cXL = cXL
          + XLCell(tt-117.ccode)
          + XLCell(tt-117.cinn)
          + XLCell(tt-117.rdate)
          + XLCell(mAdr[1])
          + XLCell(tt-117.odate)
          + XLCell(mPName[1])
          + XLCell(tt-117.pinn)
          .
   ELSE
      cXL = cXL
          + XLEmptyCells(7)
          .


      cXL = cXL
       + XLNumCell(iBankCountry)
       .
   PUT UNFORMATTED XLRow(0) cXL XLRowEnd().



end.
if can-do("42505*,42506*",bfrOpEntry.acct-db) 
then
do:
   cXL = XLCell(mCliName[1])
       + XLCell(bfrOpEntry.acct-db)
       + XLDateCell(tt-117.op-dt)
       + XLCell("1")
       + XLCell(tt-117.r-KOV)
       + XLCell(tt-117.op-cu)
       + XLNumCell(tt-117.op-su)
       + XLCell(mBname[1])
       + XLCell(tt-117.bcode)
       + XLCell(tt-117.r-PSd)
       + XLCell(tt-117.r-VCO)
       .

   IF tt-117.r-SVC GT 0
   THEN cXL = cXL + XLNumCell(tt-117.r-SVC).
   ELSE cXL = cXL + XLEmptyCell().

   IF (tt-117.c-cat NE "Ч")
   THEN
      cXL = cXL
          + XLCell(tt-117.ccode)
          + XLCell(tt-117.cinn)
          + XLCell(tt-117.rdate)
          + XLCell(mAdr[1])
          + XLCell(tt-117.odate)
          + XLCell(mPName[1])
          + XLCell(tt-117.pinn)
          .
   ELSE
      cXL = cXL
          + XLEmptyCells(7)
          .


      cXL = cXL
       + XLNumCell(iBankCountry)
       .
   PUT UNFORMATTED XLRow(0) cXL XLRowEnd().


end.

/* конец доп.вывода */

dr = GetXAttrValueEX("op", STRING(bfrOpEntry.op), "НомДог",""). /*добавила Дата договора и Номер договора из ДР НомДог. заявка #1995*/

   cXL = XLCell(mCliName[1])
       + XLCell(tt-117.c-acc)
       + XLDateCell(tt-117.op-dt)
       + XLCell(tt-117.napr)
       + XLCell(tt-117.r-KOV)
       + XLCell(tt-117.op-cu)
       + XLNumCell(tt-117.op-su)
       + XLCell(mBname[1])
       + XLCell(tt-117.bcode)
       + XLCell(tt-117.r-PSd)
       + XLCell(tt-117.r-VCO)
       .

/*
   PUT STREAM sCSV UNFORMATTED "'" 
      STRING(mCliName[1],  "X(80)")       "';'"
      STRING(tt-117.c-acc, "X(20)")           "';"
      STRING(tt-117.op-dt, "99/99/9999")  ";"
      STRING(tt-117.napr,  "x(1)")        ";"
      STRING(tt-117.r-KOV, "X(5)")        ";"
      STRING(tt-117.op-cu, "X(3)")        ";"
      STRING(tt-117.op-su, ">>>>>>>>>>>9.99") ";'"
      STRING(mBname[1],    "x(55)")             "';"
      STRING(tt-117.bcode, "x(12)")       ";"
      STRING(tt-117.r-PSd, "X(22)")       ";"
      STRING(tt-117.r-VCO, "X(3)")        ";"
   .
*/
   IF tt-117.r-SVC GT 0
   THEN cXL = cXL + XLNumCell(tt-117.r-SVC).
   ELSE cXL = cXL + XLEmptyCell().
/*
   THEN PUT STREAM sCSV UNFORMATTED
            STRING(tt-117.r-SVC, ">>>,>>>,>>>,>>9.99") ";".
   ELSE PUT STREAM sCSV UNFORMATTED FILL(" ",18) ";".
*/
   IF (tt-117.c-cat NE "Ч")
   THEN
      cXL = cXL
          + XLCell(tt-117.ccode)
          + XLCell(tt-117.cinn)
          + XLCell(tt-117.rdate)
          + XLCell(mAdr[1])
          + XLCell(tt-117.odate)
          + XLCell(mPName[1])
          + XLCell(tt-117.pinn)
          .
   ELSE
      cXL = cXL
          + XLEmptyCells(7)
          .
/*
   PUT STREAM sCSV UNFORMATTED
      (IF tt-117.c-cat = "Ч" THEN "" ELSE STRING(tt-117.ccode, "x(3)"))  ";'"
      (IF tt-117.c-cat = "Ч" THEN "" ELSE STRING(tt-117.cinn,  "x(12)")) "';"
      (IF tt-117.c-cat = "Ч" THEN "" ELSE STRING(tt-117.rdate, "x(10)")) ";"
      (IF tt-117.c-cat = "Ч" THEN "" ELSE STRING(mAdr[1],      "x(80)")) ";"
      (IF tt-117.c-cat = "Ч" THEN "" ELSE STRING(tt-117.odate, "x(10)")) ";"
      (IF tt-117.c-cat = "Ч" THEN "" ELSE STRING(mPName[1],    "x(150)")) ";'"
      (IF tt-117.c-cat = "Ч" THEN "" ELSE STRING(tt-117.pinn,  "x(12)")) "'" SKIP.
*/
   cXL = cXL
       + XLNumCell(iBankCountry)
       + XLCell(dr)     /* заявка #1995 */
       .
   PUT UNFORMATTED XLRow(0) cXL XLRowEnd().

END.

PUT UNFORMATTED XLEnd().
{intrface.del}
