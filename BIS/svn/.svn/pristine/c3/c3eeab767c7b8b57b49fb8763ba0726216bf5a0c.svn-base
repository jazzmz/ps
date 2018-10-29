{pirsavelog.p}

/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2004 ТОО "Банковские информационные системы"
     Filename: ap-m17.p
      Comment: Карточка учета материалов
   Parameters:
         Uses:
      Used by:
      Created: 25.12.1998 Peter
     Modified: 13.09.2004 fedm
*/

{globals.i}

{intrface.get xclass}
{intrface.get db2l}
{intrface.get xobj}

{a-defs.i}
{wordwrap.def}
{ap-func.i}
{repinfo.i}

DEF INPUT PARAMETER rid       AS RECID    NO-UNDO.
/* Код шаблона КАУ для отражения движения */
DEF INPUT PARAMETER iKau-Id   AS CHAR     NO-UNDO.
/* Движение в сумме (C), количестве(К) или количестве + сумме (К,С) */
DEF INPUT PARAMETER iQty      AS CHAR     NO-UNDO.
/* Показывать итоги?  */
DEF INPUT PARAMETER iTotal    AS LOGICAL  NO-UNDO.

DEF VAR okpo      AS CHAR     NO-UNDO.
/* Суммы  */
DEF VAR mSum      AS DECIMAL  NO-UNDO EXTENT 3.
/* Кол-ва */
DEF VAR mQty      AS DECIMAL  NO-UNDO EXTENT 3.
/* Счётчик */
DEF VAR mCnt      AS INT      NO-UNDO.
/* Наименование поставщика */
DEF VAR mSupplier AS CHAR     NO-UNDO EXTENT 4.
/* Формат вывода суммы */
&GLOBAL-DEFINE SumFmt '->>>>>>>>9.99'
/* Формат вывода количества */
DEF VAR mQtyFmt  AS CHAR      NO-UNDO INITIAL {&SumFmt}.

/* Дата по которую считать */
DEF VAR in-dob1    LIKE op.op-date NO-UNDO.
DEF VAR schet      AS CHAR     NO-UNDO.
DEF VAR CostNew    AS DEC  NO-UNDO.

IF iQty = "К,С" THEN
   mQtyFmt = '->>>9.99'.
   
in-dob1 = today.
MESSAGE "Введите дату :" UPDATE in-dob1.

/* Заголовок движения */
DEF VAR mTitle    AS CHAR     NO-UNDO EXTENT 10 INITIAL
[
"┌────────┬─────────────────┬──────────────────────────────────────────────────────────────┬─────────────────┬─────────────┬─────────────┬─────────────┬───────────────┐",
"│  Дата  │       Номер     │От кого получено или кому отпущено                            │ Учетная единица │    Приход   │    Расход   │   Остаток   │ Подпись, дата │",
"│ записи ├─────────┬───────┤                                                              │выпуска продукции│             │             │             │               │",
"│        │документа│  по   │                                                              │  (работ, услуг) │             │             │             │               │",
"│        │         │порядку│                                                              │                 │             │             │             │               │",
"├────────┼─────────┼───────┼──────────────────────────────────────────────────────────────┼─────────────────┼─────────────┼─────────────┼─────────────┼───────────────┤",
"│   1    │    2    │   3   │                4                                             │        5        │      6      │      7      │      8      │       9       │",
"├────────┼─────────┼───────┼──────────────────────────────────────────────────────────────┼─────────────────┼─────────────┼─────────────┼─────────────┼───────────────┤",
"│        │         │       │ И Т О Г О :                                                  │                 │>            │             │             │               │",
"└────────┴─────────┴───────┴──────────────────────────────────────────────────────────────┴─────────────────┴─────────────┴─────────────┴─────────────┴───────────────┘"
].
IF iQty = "К,С" THEN
   ASSIGN
      OVERLAY(mTitle[ 1], 64) = "┬─────────────────┬──────────────────────┬──────────────────────┬──────────────────────┬───────────────┐"
      OVERLAY(mTitle[ 2], 64) = "│ Учетная единица │       Приход         │        Расход        │       Остаток        │ Подпись, дата │"
      OVERLAY(mTitle[ 3], 64) = "│выпуска продукции│                      │                      │                      │               │"
      OVERLAY(mTitle[ 4], 64) = "│   (работ, услуг)├────────┬─────────────┼────────┬─────────────┼────────┬─────────────┤               │"
      OVERLAY(mTitle[ 5], 64) = "│                 │ Кол-во │    Сумма    │ Кол-во │    Сумма    │ Кол-во │    Сумма    │               │"
      OVERLAY(mTitle[ 6], 64) = "┼─────────────────┼────────┼─────────────┼────────┼─────────────┼────────┼─────────────┼───────────────┤"
      OVERLAY(mTitle[ 7], 64) = "│         5       │    6   │      7      │    8   │      9      │   10   │      11     │      12       │"
      OVERLAY(mTitle[ 8], 64) = "┼─────────────────┼────────┼─────────────┼────────┼─────────────┼────────┼─────────────┼───────────────┤"
      OVERLAY(mTitle[ 9], 64) = "│                 │>       │             │        │             │        │             │               │"
      OVERLAY(mTitle[10], 64) = "┴─────────────────┴────────┴─────────────┴────────┴─────────────┴────────┴─────────────┴───────────────┘".

/* Возвращает "От кого получено или кому отпущено" */
FUNCTION GetMOLName RETURNS CHAR:
   /* Таб.№ сотрудника */
   DEF VAR vTabNo     AS INT   NO-UNDO.
   /* ФИО сотрудника */
   DEF VAR vFIO       AS CHAR  NO-UNDO.
   /* От кого получено или кому отпущено */
   DEF VAR vName      AS CHAR  NO-UNDO.
   /* Ширина колонки */
   DEF VAR vWidth     AS INT   NO-UNDO.

   /* Кусок кода для конвертации таб№ в ФИО */
   &SCOPED-DEFINE TabN2FIO                          ~
      vTabNo = INT(vName) NO-ERROR.                 ~
      IF NOT ERROR-STATUS:ERROR AND vTabNo > 0 THEN ~
      DO:                                           ~
         vFIO = GetObjName("employee", shFilial + "," + vName, YES). ~
         IF vFIO <> "" AND vFIO <> ? THEN           ~
            vName = vFIO.                           ~
      END.

   DEF BUFFER op FOR op.

   /* Для субпроводок без количества не заполняем */
   IF tt-kau-entry.qty <> 0 THEN
   DO:
      FOR FIRST op OF tt-kau-entry
         NO-LOCK:

         vName = GetXAttrValueEx ("op",
                                  STRING(op.op),
                                  "hand-over",
                                  ""
                                 ).
         /* Если в качестве сдающего ценности указан таб.№ сотрудника,
         ** то получаем его ФИО
         */
         {&TabN2FIO}

         IF vName = "" THEN
         DO:
            vName = GetXAttrValueEx ("op",
                                     STRING(op.op),
                                     "receipt",
                                     ""
                                    ).
            /* Если в качестве получателя указан таб.№ сотрудника,
            ** то получаем его ФИО
            */
            {&TabN2FIO}
         END.
      END.

      IF vName = "" THEN
         vName = GetObjName("employee",
                            shFilial + "," + ENTRY(3, tt-kau-entry.kau),
                            YES
                           ).
   END.

   ASSIGN
      vWidth = (IF iQty = "К,С" THEN 35 ELSE 62)
      vName  = (IF LENGTH(vName) < vWidth
                THEN vName + FILL(" ", vWidth - LENGTH(vName))
                ELSE SUBSTR(vName, 1, vWidth)
               ).
   /* Дополняем кодом подразделения */
   IF tt-kau-entry.qty <> 0 THEN
      OVERLAY(vName, vWidth - 8) = ENTRY(4, tt-kau-entry.kau).

   RETURN vName.

END FUNCTION.

RUN InitPrc (OUTPUT pick-value,
             OUTPUT mSupplier[1]
            ).

{wordwrap.i
   &s = mSupplier
   &n = EXTENT(mSupplier)
   &l = 18
}

{getbrnch.i &branch-id=pick-value &OKPO=okpo}

{strtout3.i &cols=168}

FIND FIRST loan  WHERE RECID(loan) = rid NO-LOCK.
FIND FIRST asset WHERE asset.cont-type = loan.cont-type NO-LOCK.
FIND LAST loan-acct of loan where loan-acct.acct-type = "СКЛАД-учет" 
                               and loan-acct.since LE in-dob1 NO-LOCK.

schet = loan-acct.acct.
CostNew = GetCostUMC(loan.contract + CHR(6) + loan.cont-code,
                     in-dob1,
		     "",
		     ""
		     ).

PUT UNFORMATTED
  SPACE(75) 'Карточка N-' loan.cont-code ' учета материалов'                            SKIP
  SPACE(136)                                          '                 ┌────────────┐' SKIP
  SPACE(136)                                          '                 │    Коды    │' SKIP
  SPACE(136)                                          '                 ├────────────┤' SKIP
  SPACE(136)                                          '   Форма по ОКУД │   0315008  │' SKIP
  SPACE(136)                                          '                 ├────────────┤' SKIP
             'Организация ' name-bank format 'x(124)' '         по ОКПО │' okpo FORMAT 'x(8)'  '    │' SKIP
  SPACE(136)                                          '                 ├───┬───┬────┤' SKIP
  SPACE(136)                                          'Дата составления │ ' STRING(DAY  (in-dob1), '>9')   '│ '
                                                                            STRING(MONTH(in-dob1), '>9')   '│'
                                                                            STRING(YEAR (in-dob1), '9999') '│' SKIP
  SPACE(136)                                          '                 └───┴───┴────┘' SKIP
             'Структурное подразделение ' GetDocParamFmt('Филиал', ?) SKIP(1)
  '┌──────────────┬────────┬─────┬──────────────┬───────┬──────┬───────┬──────┬────────────────┬─────────────────┬───────────────────┬───────┬────────┬──────────────────┐' SKIP
  '│ Структурное  │  Вид   │Склад│Место хранения│ Марка │ Сорт │Профиль│Размер│ Номенклатурный │Единица измерения│   Цена, руб.коп.  │ Норма │  Срок  │     Поставщик    │' SKIP
  '│подразделение │деятель-│     ├───────┬──────┤       │      │       │      │     номер      ├────┬────────────┤                   │запаса │годности│                  │' SKIP
  '│              │ ности  │     │стеллаж│ячейка│       │      │       │      │                │код │наименование│                   │       │        │                  │' SKIP
  '├──────────────┼────────┼─────┼───────┼──────┼───────┼──────┼───────┼──────┼────────────────┼────┼────────────┼───────────────────┼───────┼────────┼──────────────────┤' SKIP
  '│' GetDocParamFmt('КодФил', 'x(14)')
  '│' SPACE(8)
  '│' pick-value   FORMAT 'x(5)'
  '│' GetAssetParamFmt('Стеллаж', 'x(7)')
  '│' GetAssetParamFmt('Ячейка', 'x(6)')
  '│' GetAssetParamFmt('Марка', 'x(7)')
  '│' GetAssetParamFmt('Сорт', 'x(6)')
  '│' GetAssetParamFmt('Профиль', 'x(7)')
  '│' GetAssetParamFmt('Размер', 'x(6)')
  '│' GetAssetParamFmt('Номенклатура', 'x(16)')
  '│' GetAssetParamFmt('Единица', 'x(4)')
  '│' GetAssetParamFmt('ЕдиницаНаим', 'x(12)')
/*  '│' GetAssetParamFmt('Цена','>>>>,>>>,>>>,>>9.99')*/
  '│' string(CostNew,'>>>>,>>>,>>>,>>9.99')
  '│' GetAssetParamFmt('НормаЗапаса', 'x(7)')
  '│' GetAssetParamFmt('СрокИсп', 'x(8)')
  '│' mSupplier[1] FORMAT 'x(18)'
  '│'
SKIP.

DO mCnt = 2 TO EXTENT(mSupplier):
   IF TRIM(mSupplier[mCnt]) = "" THEN
      LEAVE.

   PUT UNFORMATTED
      '│              │        │     │       │      │       │      │       │      │                │    │            │                   │       │        │'
      mSupplier[mCnt] FORMAT 'x(18)'
      '│'
   SKIP.
END.

PUT UNFORMATTED
   '└──────────────┴────────┴─────┴───────┴──────┴───────┴──────┴───────┴──────┴────────────────┴────┴────────────┴───────────────────┴───────┴────────┴──────────────────┘'
SKIP(1).

/* Вывод информации о драг.материалах */
RUN PutGold.

/* Таблица движения по карточке */
PUT UNFORMATTED
   mTitle[1] SKIP
   mTitle[2] SKIP
   mTitle[3] SKIP
   mTitle[4] SKIP
   mTitle[5] SKIP
   mTitle[6] SKIP
   mTitle[7] SKIP
   mTitle[8] SKIP.

FOR
   EACH  tt-kau-entry WHERE
         tt-kau-entry.kau-id   = iKau-Id
     AND tt-kau-entry.kau BEGINS loan.contract + "," + loan.cont-code + ","
     AND ENTRY(4, tt-kau-entry.kau) = pick-value
     AND tt-kau-entry.op-date LE in-dob1
      NO-LOCK
/*тут была запятая после NO-LOCK
   FIRST op OF tt-kau-entry
      NO-LOCK */

   BREAK BY tt-kau-entry.op-date
         BY tt-kau-entry.op
         BY tt-kau-entry.op-entry:
   FIND FIRST op OF tt-kau-entry NO-LOCK NO-ERROR. 
    
   ACCUMULATE tt-kau-entry.op-date (SUB-COUNT BY tt-kau-entry.op-date).

   PUT UNFORMATTED
      '│' tt-kau-entry.op-date       FORMAT '99/99/99'
      '│' (IF AVAILABLE op
           THEN op.doc-num
           ELSE "НР"
          )                          FORMAT 'x(9)'
      '│' ACCUM SUB-COUNT BY tt-kau-entry.op-date tt-kau-entry.op-date
                                     FORMAT '>>>>>>9'
      '│' GetMOLName()
      '│                 '.

   IF tt-kau-entry.debit THEN /* Приход */
      ASSIGN
         mQty [1] = tt-kau-entry.qty
         mSum [1] = tt-kau-entry.amt-rub
         mQty [2] = 0
         mSum [2] = 0.        /* Расход */
   ELSE
      ASSIGN
         mQty [1] = 0
         mSum [1] = 0
         mQty [2] = tt-kau-entry.qty
         mSum [2] = tt-kau-entry.amt-rub.

   ASSIGN                     /* Остаток */
      mQty [3] = mQty [3] + mQty [1] - mQty [2]
      mSum [3] = mSum [3] + mSum [1] - mSum [2].

   /* Вывод оборотов и остатка в сумме и/или количестве */
   RUN PutSumm.

   /* Накапливаем итоги по оборотам */
   IF iTotal THEN
      ACCUMULATE
         mQty [1] (TOTAL)
         mSum [1] (TOTAL)
         mQty [2] (TOTAL)
         mSum [2] (TOTAL).
END.

/* Строка итогов */
IF iTotal THEN
DO:
   PUT UNFORMATTED
      mTitle[8] SKIP
      SUBSTR(mTitle[9], 1, INDEX(mTitle[9], "│>") - 1).

   ASSIGN
      mQty [1] = (ACCUM TOTAL mQty [1])
      mSum [1] = (ACCUM TOTAL mSum [1])
      mQty [2] = (ACCUM TOTAL mQty [2])
      mSum [2] = (ACCUM TOTAL mSum [2]).

   /* Вывод итогов оборотов и последнего остатка в сумме и/или количестве */
   RUN PutSumm.
END.

FIND _user WHERE _user._userid = USERID('bisquit') NO-LOCK.
PUT UNFORMATTED
  mTitle[10] SKIP(1)
  '  Карточку заполнил    ' GetXattrValue("_user", USERID('bisquit'), "Должность")
                                           _user._User-Name AT 70 SKIP
  '                      _____________________  _____________________  ________________________________________' SKIP
  '                          должность                 подпись               расшифровка подписи' SKIP(1)
  '     "___"___________ 20   г.'
SKIP.

{endout3.i}

/* 1. Установка/запрос кода подразделения
   2. Получение наименования поставщика
*/
PROCEDURE InitPrc:
   /* Выбранный склад */
   DEF OUTPUT PARAMETER oBranch-Id  AS CHAR  NO-UNDO.
   /* Поставщик */
   DEF OUTPUT PARAMETER oSupplier   AS CHAR  NO-UNDO.

   DEF BUFFER loan       FOR loan.
   DEF BUFFER kau-entry  FOR kau-entry.
   DEF BUFFER op         FOR op.

   FOR
      FIRST loan      WHERE
            RECID(loan) = rid
         NO-LOCK,

      EACH  kau-entry WHERE
            kau-entry.kau-id   = iKau-Id
        AND kau-entry.kau BEGINS loan.contract + "," + loan.cont-code + ","
         NO-LOCK:

      IF NUM-ENTRIES(kau-entry.kau) >= 4  AND
         NOT CAN-DO(oBranch-Id, ENTRY(4,kau-entry.kau)) THEN
         {additem.i oBranch-Id ENTRY(4,kau-entry.kau) }

      IF oSupplier = "" THEN
      FOR FIRST op OF kau-entry
         NO-LOCK:
         oSupplier = GetXAttrValueEx ("op",
                                      STRING(op.op),
                                      "where-buy",
                                      ""
                                     ).
      END.
   END.

   IF oSupplier = "" THEN
      oSupplier = GetXAttrValueEx ("loan",
                                   loan.contract + "," + loan.cont-code,
                                   "Поставщик",
                                   ""
                                  ).
   /* Если в качестве получателя указан код из классификатора "Поставщики",
   ** то получаем по коду наименование поставщика.
   */
   IF oSupplier <> "" AND
      AvailCode("Поставщики", oSupplier) THEN
      oSupplier = GetCodeName("Поставщики", oSupplier).

   IF NUM-ENTRIES(oBranch-Id) > 1 THEN
   DO TRANSACTION:
      RUN browseld.p
         ("branch",                   /* Класс объекта. */
          "title"          + CHR(1) + /* Поля для предустановки. */
          "branch-id"      + CHR(1) + /* Поля для предустановки. */
          "LineStruct",
          "ВЫБЕРИТЕ СКЛАД" + CHR(1) +
          oBranch-Id       + CHR(1) +
          "yes",                      /* Список значений полей. */
          "branch-id",
          4                           /* Строка отображения фрейма. */
         ).

      oBranch-Id = (IF pick-value = ? OR pick-value = ""
                    THEN ?
                    ELSE pick-value
                   ).
   END.

   RETURN.

END PROCEDURE.

/* Вывод оборотов и остатка в сумме и/или количестве */
PROCEDURE PutSumm:
   /* Приход */
   IF CAN-DO(iQty, "К") THEN
      PUT UNFORMATTED '│'
         IF mQty [1] = 0
         THEN FILL(' ', LENGTH(mQtyFmt))
         ELSE STRING(mQty [1], mQtyFmt)
      .
   IF CAN-DO(iQty, "С") THEN
      PUT UNFORMATTED '│'
         IF mSum [1] = 0
         THEN FILL(' ', LENGTH({&SumFmt}))
         ELSE STRING(mSum [1], {&SumFmt})
      .

   /* Расход */
   IF CAN-DO(iQty, "К") THEN
      PUT UNFORMATTED '│'
         IF mQty [2] = 0
         THEN FILL(' ', LENGTH(mQtyFmt))
         ELSE STRING(mQty [2], mQtyFmt)
      .
   IF CAN-DO(iQty, "С") THEN
      PUT UNFORMATTED '│'
         IF mSum [2] = 0
         THEN FILL(' ', LENGTH({&SumFmt}))
         ELSE STRING(mSum [2], {&SumFmt})
      .

   /* Остаток */
   IF CAN-DO(iQty, "К") THEN
      PUT UNFORMATTED '│'
         STRING(mQty [3],  mQtyFmt).

   IF CAN-DO(iQty, "С") THEN
      PUT UNFORMATTED '│'
         STRING(mSum [3], {&SumFmt}).

   PUT UNFORMATTED
      "│               │"
   SKIP.

   RETURN.

END PROCEDURE.

/* Вывод информации о драг.материалах */
PROCEDURE PutGold:
   &SCOPED-DEFINE AT_SKIP AT 77 SKIP
   /* Заголовок */
   DEF VAR vTitle    AS CHAR     NO-UNDO EXTENT 11 INITIAL
   ["┌─────────────────────────────────────────────────────────────────────────────────────────┐",
    "│                          Драгоценный материал (металл, камень)                          │",
    "├──────────────┬─────┬────────────────┬─────────────────┬──────────┬──────────┬───────────┤",
    "│ наименование │ вид │ номенклатурный │единица измерения│количество│   номер  │           │",
    "│              │     │     номер      ├────┬────────────┤  (масса) │ паспорта │           │",
    "│              │     │                │код │наименование│          │          │           │",
    "├──────────────┼─────┼────────────────┼────┼────────────┼──────────┼──────────┼───────────┤",
    "│      1       │  2  │       3        │ 4  │     5      │    6     │    7     │     8     │",
    "├──────────────┼─────┼────────────────┼────┼────────────┼──────────┼──────────┼───────────┤",
    "│[НаимДМ      ]│     │                │    │            │[МассаДМ ]│          │           │",
    "└──────────────┴─────┴────────────────┴────┴────────────┴──────────┴──────────┴───────────┘"
   ].

   /* Строка отчета */
   DEF VAR vStr      AS CHAR     NO-UNDO.
   /* Счётчик */
   DEF VAR vCnt      AS INT      NO-UNDO.

   PUT UNFORMATTED
    "Наименование материала:"                   vTitle[1] {&AT_SKIP}
    CAPS(GetAssetParamFmt("Наименование", "x(76)")) vTitle[2] {&AT_SKIP}
                                                vTitle[3] {&AT_SKIP}
    "Счет учета:"                               vTitle[4] {&AT_SKIP}
    schet                                       vTitle[5] {&AT_SKIP}
                                                vTitle[6] {&AT_SKIP}
                                                vTitle[7] {&AT_SKIP}
                                                vTitle[8] {&AT_SKIP}
                                                vTitle[9] {&AT_SKIP}.
   DO vCnt = 1 TO 4:
      vStr = GetValue ((BUFFER asset:HANDLE),
                       "precious-" + STRING(vCnt)
                      ).

      IF vStr <> "0" THEN
      DO:
         ASSIGN
            vStr = REPLACE(vTitle[10],
                           "[МассаДМ ]",
                           STRING(vStr, "xxxxxxxxxx")
                          )
            vStr = REPLACE(vStr,
                           "[НаимДМ      ]",
                           STRING(GetXAttrEx("asset",
                                             "precious-" + STRING(vCnt),
                                             "xattr-label"
                                            ),
                                  "xxxxxxxxxxxxxx"
                                 )
                          ).
         PUT UNFORMATTED
            vStr {&AT_SKIP}.
      END.
   END.

   PUT UNFORMATTED
      vTitle[11] {&AT_SKIP}(1).

   RETURN.

END PROCEDURE.