/*
               Банковская интегрированная система БИСквит
    Copyright: (C) KB "PIR" Borisov A.V.
     Filename: pir321#2.p
      Comment: Процедура пострасчета (метод AfterCalc2) класса Legal321. 
      Created: 14.10.2010 
*/
/******************************************************************************/
{sv-calc.i} /* DEFINE INPUT PARAM in-data-id LIKE DataBlock.data-id NO-UNDO. */
{leg321p.def}
{intrface.get xclass} /* Функции для работы с метасхемой */

DEFINE BUFFER bDL1  FOR DataLine.
DEFINE BUFFER bDL2  FOR DataLine.
DEFINE VARIABLE lDa AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cNm AS CHARACTER NO-UNDO.

FOR EACH bDL1 OF DataBlock
   WHERE (bDL1.Sym2 EQ {&MAIN-LINE}) /* Общие данные */
   EXCLUSIVE-LOCK:

   bDL1.Txt = bDL1.Txt + "~n" + "СОЗД".    /* STATUS 23 */ 
END.

FOR EACH bDL1 OF DataBlock
   WHERE (bDL1.Sym2   EQ {&MAIN-LINE})
     AND (bDL1.Val[1] EQ 0)
   NO-LOCK,
   EACH bDL2 OF DataBlock
      WHERE ((bDL2.Sym2 EQ {&SEND-LINE})
          OR (bDL2.Sym2 EQ {&SPRX-LINE})
          OR (bDL2.Sym2 EQ {&RPRX-LINE})
          OR (bDL2.Sym2 EQ {&RECV-LINE})
          OR (bDL2.Sym2 EQ {&ORDR-LINE}))
        AND (bDL2.Sym1 EQ bDL1.Sym1)
      EXCLUSIVE-LOCK:

   IF (bDL2.Sym3 NE "")
   THEN DO:

      lDa = YES.
      cNm = TRIM(ENTRY(3, bDL2.Txt, "~n")).

      CASE ENTRY(1, bDL2.Sym3):
         WHEN "Ю" THEN DO:

            FIND FIRST cust-corp
               WHERE (cust-corp.cust-id EQ INTEGER(ENTRY(2, bDL2.Sym3)))
               NO-LOCK NO-ERROR.

            IF (AVAIL cust-corp)
            THEN IF (cNm NE cust-corp.name-short)
                AND (cNm NE (cust-corp.cust-stat + " " + cust-corp.name-corp))
                AND (cNm NE (GetCodeName("КодПредп",GetCodeVal("КодПредп", cust-corp.cust-stat))
                             + " " + cust-corp.name-corp))
            THEN DO:

               MESSAGE "Исправлять имя клиента в док.N " + bDL1.Sym4 + " ?" SKIP
                  STRING("В документе: " + cNm, "x(60)") SKIP
                  STRING("В Бисквите:  " + cust-corp.name-short, "x(61)")
                  VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
                  TITLE "Подтвердите замену" UPDATE lDa.
               IF lDa
               THEN ENTRY(3, bDL2.Txt, "~n") = cust-corp.name-short.
            END.
         END.
         WHEN "Ч" THEN DO:

            FIND FIRST person
               WHERE (person.person-id EQ INTEGER(ENTRY(2, bDL2.Sym3)))
               NO-LOCK NO-ERROR.

            IF (AVAIL person)
            THEN IF ((person.name-last + " " + person.first-names) NE cNm)
            THEN DO:

               MESSAGE "Исправлять имя клиента в док.N " + bDL1.Sym4 + " ?" SKIP
                  STRING("В документе: " + cNm, "x(60)") SKIP
                  STRING("В Бисквите:  " + person.name-last + " " + person.first-names, "x(61)")
                  VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
                  TITLE "Подтвердите замену" UPDATE lDa.
               IF lDa
               THEN ENTRY(3, bDL2.Txt, "~n") = person.name-last + " " + person.first-names.
            END.
         END.
         WHEN "Б" THEN DO:

            FIND FIRST banks
               WHERE (banks.bank-id EQ INTEGER(ENTRY(2, bDL2.Sym3)))
               NO-LOCK NO-ERROR.

            IF (AVAIL banks)
            THEN IF (banks.name NE cNm)
            THEN DO:

               MESSAGE "Исправлять имя клиента в док.N " + bDL1.Sym4 + " ?" SKIP
                  STRING("В документе: " + cNm, "x(60)") SKIP
                  STRING("В Бисквите:  " + banks.name, "x(61)")
                  VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
                  TITLE "Подтвердите замену" UPDATE lDa.
               IF lDa
               THEN ENTRY(3, bDL2.Txt, "~n") = banks.name.
            END.
         END.
      END CASE.
   END.
END.
/******************************************************************************/
