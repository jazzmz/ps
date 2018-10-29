{pirsavelog.p}

/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2005 ТОО "Банковские информационные системы"
     Filename: a-rashna.p
      Comment: Расходная накладная (вместо требования для ВТБ)
               Для печати из документа вида 1016.
   Parameters:
         Uses:
      Used by:
      Created: 18.01.2005 fedm
     Modified:
*/

{globals.i}

{intrface.get xobj}
{intrface.get strng}
{a-defs.i}
{ap-func.i}

&IF DEFINED(tmprecid) &THEN
   {ap-ms.i &ap-m-header='"[Требование на отпуск со склада]"'}
&ELSE
   DEF INPUT PARAMETER rid AS RECID NO-UNDO.
&ENDIF

&SCOPED-DEFINE cols 112

DEF VAR RepTempl AS CHAR NO-UNDO  FORMAT "x({&cols})"  EXTENT 9 INITIAL
[
"┌───┬────────────────────────────────┬─────┬───────┬──────────────┬──────────────┬──────────────┬──────────────┐",
"│ N │     Наименование ценностей     │Един.│ Кол-во│     Цена     │     Сумма    │     Сумма    │     Сумма    │",
"│п/п│                                │измер│       │              │    без НДС   │      НДС     │              │",
"│   │                                │     │       │              │              │              │              │",
"├───┼────────────────────────────────┼─────┼───────┼──────────────┼──────────────┼──────────────┼──────────────┤",
"│  N│name                            │ unt │    qty│          cost│       sum-nds│           nds│           sum│",
"├───┼────────────────────────────────┼─────┼───────┼──────────────┼──────────────┼──────────────┼──────────────┤",
"│   │    ИТОГО                       │     │    qty│              │       sum-nds│           nds│           sum│",
"└───┴────────────────────────────────┴─────┴───────┴──────────────┴──────────────┴──────────────┴──────────────┘"
].

{ap-rep.i
   {&*}
   &debit       = NO
   &ReceiptFull = YES
}

{intrface.del}

PROCEDURE PutHeader:
   /* Доп.реквизиты документа */
   DEF VAR vTrust      AS CHAR  NO-UNDO EXTENT 2.

   vTrust[2] = GetXAttrValueEx("op",
                               STRING(op.op),
                               "trust",
                               "____________," + FILL("_", 71)
                              ).

   IF NUM-ENTRIES(vTrust[2]) >= 2 THEN
      ASSIGN
         vTrust[1] = ENTRY(1, vTrust[2])
         vTrust[2] = ENTRY(2, vTrust[2]).

   /* МОЛ */
   DEF VAR vTab-no     AS CHAR  NO-UNDO.
   /* ФИО */
   DEF VAR vFIO        AS CHAR  format "x(30)".

   FOR FIRST tt-kau-entry OF op WHERE
             tt-kau-entry.debit = NO
      NO-LOCK:
      ASSIGN
            vTab-no = GetAssetParamFmt("Мол", "")
            vFIO    = GetObjName("employee",shFilial + "," + vTab-no, YES).
   END.


   PUT UNFORMATTED
      dept.name-bank                                                               SKIP
      FILL("─", MAX(36, LENGTH(dept.name-bank)))                                   SKIP
      "(наименование кредитной организации)"                                       SKIP(2)

      "                             РАСХОДНАЯ НАКЛАДНАЯ № " op.doc-num
                                                     " от " Date2StrR(op.op-date)  SKIP(2)
      "на отпуск материальных ценностей"                                           SKIP
/*      "по требованию № " vTrust[1] " от " vTrust[2]*/
   SKIP(1) .

   PUT UNFORMATTED
      "от: " vFIO                                                                  SKIP
      "    " FILL("─", MAX(65, LENGTH(vFIO)))                                      SKIP
      "    " "(фамилия, имя, отчество должностного лица, отпускающего ценности)"
   SKIP(1).

   vFIO = ReceiptName(NO).
   PUT UNFORMATTED
      " к: " vFIO                                                                SKIP
      "    " FILL("─", MAX(52, LENGTH(vFIO)))                                      SKIP
      "    " "(фамилия, имя, отчество лица, принимающего ценности)"                SKIP(1)

      "следующие материальные ценности"
   SKIP(1).

END PROCEDURE.

PROCEDURE PutFooter:
   /* Сумма прописью */
   DEF VAR vSumSpell   AS CHAR     NO-UNDO EXTENT 4.
   DEF VAR vFIO        AS CHAR  NO-UNDO.
   DEF VAR vTab-no     AS CHAR  NO-UNDO.
   DEF VAR pFIO        AS CHAR  NO-UNDO.
   

     FOR FIRST tt-kau-entry OF op WHERE
             tt-kau-entry.debit = NO
      NO-LOCK:
      ASSIGN
           vTab-no = GetAssetParamFmt("Мол", "")
           vFIO    = GetObjName("employee",shFilial + "," + vTab-no, YES).
     END.
     pFIO = ReceiptName(NO).
     
   {strval.i
      mSumTot
      vSumSpell[1]
   }

   vSumSpell[1] = "Списано ценностей на сумму " + vSumSpell[1].

   {wordwrap.def}

   {wordwrap.i
      &s = vSumSpell
      &n = 4
      &l = {&cols}
   }

   PUT UNFORMATTED
      vSumSpell[1] SKIP
      vSumSpell[2] SKIP
      vSumSpell[3] SKIP
      vSumSpell[4] SKIP(3)
      " Сдал _______________ " vFIO "                                    Принял ______________ " pFIO format "x(30)"
   SKIP.

END PROCEDURE.
