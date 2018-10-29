/*
   Формирование ведомости.
   Параметры:

   Modified: 30/10/2001 NIK Выравнивание кода, исключение find signs...
                            Неверная 8 колонка
     Modified: 27.01.2004 kraw (0022373)
     Modified: 04.04.2005 kraw (0042443) Очередное изменение алгоритма формирования номера и даты договора
     Modified: 19.08.2005 anisimov  - подгонка под требования отдела по открытию счетов
*/

ppnum = 0.

PUT UNFORMATTED SKIP(4)
"                    КНИГА РЕГИСТРАЦИИ ЛИЦЕВЫХ СЧЕТОВ" SKIP(1)
"                              " + CAPS({term2str beg-date end-date} )
SKIP(2)
.

FOR EACH bal-acct where CAN-DO(mAcct, string(bal-acct.bal-acct)) NO-LOCK,
   EACH acct OF bal-acct WHERE acct.cust-cat BEGINS mSewMode
                           and (open-date GE beg-date
                           AND open-date LE end-date)
                           OR  (close-date GE beg-date
                           AND close-date LE end-date)
                           AND acct.user-id BEGINS access
                           AND acct.acct-cat EQ "b"
                           AND CAN-DO(list-id,acct.user-id)
                           AND acct.cust-cat BEGINS mSewMode  /* юр,физ,банк,все */
        NO-LOCK
   BREAK BY bal-acct.bal-acct 
         BY acct.currency 
         BY SUBSTRING(acct.acct,10,11) WITH FRAME fr{1}:

   mCustCat2 = GetXAttrValueEx("bal-acct",STRING(acct.bal-acct),"ПрКл","Внутренний").
   ppnum = ppnum + 1.

   IF acct.details NE ?
   THEN 
      name[1] = acct.details.
   ELSE
   DO:

      {getcust.i &name="in-name" &OFFinn = "/*" &OFFsigns = "/*"}         
      ASSIGN
         name[1] = in-name[1] + " " + in-name[2]
         in-name[2] = ""
      .
   END.

   FORM
      ppnum	   AT 2  FORMAT ">>>>9"      COLUMN-LABEL "! ! !  1  "	/* номер пп */
      acct.open-date     FORMAT "99/99/9999" COLUMN-LABEL "    2     "	/* дата открытия */
      col1[1]            FORMAT "x(30)"      COLUMN-LABEL "              3              " /* номер и дата договора */
      name[1]            FORMAT "x(30)"      COLUMN-LABEL "              4              " /* наименование клиента  */
      acct.acct                              COLUMN-LABEL "            5            " /* номер счета */
      col5               FORMAT "x(15)"      COLUMN-LABEL "       6       "                    /* тип счета */
      col2[1]            FORMAT "x(25)"      COLUMN-LABEL "            7            " /* порядок выдачи выписок */
      col3                                   COLUMN-LABEL "         8        " /* дата сообщения в ГНИ */
      acct.close-date    FORMAT "99/99/9999" COLUMN-LABEL "     9    "  	/* дата закрытия */
      col4[1]                                COLUMN-LABEL "          10         " /* примечание */
      WITH NO-BOX WIDTH 200.

   /* если задан вывод заголовка отчета для каждого бал.счета на новой странице */
   IF mBalAcNewPage AND FIRST-OF(bal-acct.bal-acct) THEN
      PAGE.

   IF    mBalAcNewPage     AND FIRST-OF(bal-acct.bal-acct)
      OR NOT mBalAcNewPage AND FIRST(bal-acct.bal-acct) THEN

      PUT UNFORMATTED
"┌─────┬──────────┬──────────────────────────────┬──────────────────────────────┬─────────────────────────┬───────────────┬─────────────────────────┬──────────────────┬──────────┬────────────────────┐" SKIP
"│     │   Дата   │    Номер и дата договора     │                              │                         │               │                         │Дата сообщения    │   Дата   │                    │" SKIP
"│Номер│ открытия │      об открытии счета       │     Наименование клиентов    │   Номер лицевого счета  │  Назначение   │ Порядок и периодичность │налоговым органам │ закрытия │     Примечание     │" SKIP
"│  NN │  счета   │                              │                              │                         │    счета      │     выдачи выписок      │об открытии счета │  счета   │                    │" SKIP
"│     │          │                              │                              │                         │               │                         │                  │          │                    │" SKIP
"└─────┴──────────┴──────────────────────────────┴──────────────────────────────┴─────────────────────────┴───────────────┴─────────────────────────┴──────────────────┴──────────┴────────────────────┘" SKIP
   .

   acct-surr = acct.acct + "," + acct.currency.

   col1[1] = GetXAttrValueEx("acct",acct-surr,"ДогОткрЛС","").
   col5 = GetXAttrValueEx("acct",acct-surr,"ЦельСч","").

   IF col1[1] EQ "" THEN

      FOR EACH loan-acct OF acct WHERE (   loan-acct.contract EQ "Кредит"
                                        OR loan-acct.contract EQ "Депоз"
                                        OR loan-acct.contract EQ "dps")
                                   AND CAN-DO(mRuleAcct, loan-acct.acct-type)
                                   AND loan-acct.since LE end-date
         NO-LOCK,
         FIRST loan OF loan-acct NO-LOCK BY loan-acct.since DESCENDING:
         col1[1] = STRING(loan.open-date,"99/99/9999") + " N " + loan-acct.cont-code.
         LEAVE.
      END. 

   col2[1] = GetXAttrValue("acct",acct-surr,"ПорВыдВыпис").

   IF col2[1] NE "" THEN
   DO:
      FIND FIRST code WHERE code.parent EQ "ПорВыдВыпис"
                        AND code.code   EQ col2[1] NO-LOCK
      NO-ERROR.
      col2[1] = IF AVAILABLE code THEN code.val ELSE "не требуется".
      RELEASE code.
   END. 
   col3 = GetXAttrValue("acct",acct-surr,"ДатаСообщЛС").

   IF col3 = "" THEN col3 = "не требуется".
   col4[1] = GetXAttrValue("acct",acct-surr,"ПримЛС").

   /* разбиваем длинные наименования на несколько строк */
   {wordwrap.i &s=name &l=30 &n=10}
   {wordwrap.i &s=col1 &l=30 &n=10}
   {wordwrap.i &s=col2 &l=25 &n=10}
   {wordwrap.i &s=col4 &l=20 &n=10}

   DISPLAY
      ppnum
      acct.open-date
      col1[1]
      acct.acct
      col5
      col2[1]
      col3
      acct.close-date WHEN acct.close-date NE ? AND acct.close-date LE end-date
      col4[1]
      name[1].

   DO i = 2 TO 10:
       IF name[i] <> "" 
          OR col1[i] <> "" 
          OR col2[i] <> "" 
          OR col4[i] <> "" 
          THEN DO:

          DOWN.
          DISPLAY 
             col1[i] @ col1[1]
             col2[i] @ col2[1]
             col4[i] @ col4[1]
             name[i] @ name[1].

       END.
       ELSE LEAVE. 
   END. 
END.

put unformatted SKIP ( 3 ).        
put unformatted STRING ( dept.cfo-title,"x(40)" ) + dept.cfo-name SKIP ( 1 ).
put unformatted "                              М.П." SKIP ( 1 ).

PAGE.
