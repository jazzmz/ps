FORM
"                                                                        ┌───────┐"              SKIP
                                                                        "│0401075│" AT 73        SKIP
                                       TheDate AT 54 FORMAT "x(10)"     "└───────┘" AT 73        SKIP
"    ИЗВЕЩЕНИЕ N"  op.Doc-Num                      "────────────── "  AT 52                     SKIP
"О ПОСТАНОВКЕ В  ОЧЕРЕДЬ                                 Дата"                                  SKIP
"────────────────────────────────────────────────┬──────┬────────────────────────"              SKIP
PlRKC[1] FORMAT "x(48)"                         "│      │" AT 49                                SKIP
PlRKC[2] FORMAT "x(48)"                         "│БИК   │" AT 49 PlMFO FORMAT "x(9)"            SKIP
"Банк плательщика                                │      │"                                      SKIP
"────────────────────────────────────────────────┼──────┤"                                      SKIP
PoRKC[1] FORMAT "x(48)"                         "│      │" AT 49                                SKIP
PoRKC[2] FORMAT "x(48)"                         "│БИК   │" AT 49 PoMFO FORMAT "x(9)"            SKIP
"Банк получателя                                 │      │"                                      SKIP
"────────────────────────────────────────────────┼──────┤"                                      SKIP
PoName[1] FORMAT "x(48)"                        "│      │" AT 49                                SKIP
PoName[2] FORMAT "x(48)"                        "│      │" AT 49                                SKIP
PoName[3] FORMAT "x(48)"                        "│      │" AT 49                                SKIP
PoName[4] FORMAT "x(48)"                        "│Сч.N  │" AT 49 PoAcct FORMAT "x(20)"          SKIP
"Получатель                                      │      │"                                      SKIP
"────────────────────────────────────────────────┼──────┴────────────────────────"              SKIP
"Платежное требование/инкассовое поручение       │         Отметки банка         "              SKIP
"(нужное подчеркнуть)                            │                               "              SKIP
"                                                │                               "              SKIP
"                                                │                               "              SKIP
"N,дата" in-numdate FORMAT "x(20)" AT 10        "│                               " AT 49        SKIP
                                                "│                               " AT 49        SKIP
"на сумму" Rub FORMAT "x(15)"      AT 10        "│                               " AT 49        SKIP
                                                "│                               " AT 49        SKIP
reason[1] FORMAT "x(47)"                        "│                               "              SKIP
reason[2]  PlAcct FORMAT "x(20)" AT 10          "│                               " AT 49        SKIP
"                                                │                               "              SKIP
"                                                │                               "              SKIP
WITH WIDTH     88
     NO-LABELS
     FRAME     out-doc.
