form
      "                                                                       ÚÄÄÄÄÄÄÄ¿" skip
      "                                                                       ³0401108³" skip
      "Œ…Œˆ€‹œë‰ „…  N " buf_0_op.doc-num Format "x(6)"
                "   " theDate Format "x(20)" "                ÀÄÄÄÄÄÄÄÙ" skip
      "                                     („ â )" skip
&IF {&NFORM} EQ 108 &THEN
      " ‘ã¬¬   ³ " AmtStr[1] Format "x(70)" skip
      "¯à®¯¨áìî³ " AmtStr[2] Format "x(70)" skip
&ENDIF
&IF {&NFORM} EQ 109 &THEN
      " ‘ã¬¬   ³ " ValStr[1] Format "x(70)" skip
      "¯à®¯¨áìî³ " ValStr[2] Format "x(70)" skip
      "ÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" skip
      " ‘ã¬¬   ³ " AmtStr[1] Format "x(70)" skip
      "íª¢¨¢ «.³ " AmtStr[2] Format "x(70)" skip
&ENDIF
      "ÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" skip
&IF {&NFORM} EQ 108 &THEN
      "" PlName[1] Format "x(35)"         "³ ‘ã¬¬  ³ " Rub Format "x(15)" skip      
      "" PlName[2] Format "x(35)"         "³       ³" skip
      "" PlName[3] Format "x(35)"         "³       ³" skip
&ELSE
      "" PlName[1] Format "x(35)"         "³ ‘ã¬¬  ³ " Val Format "x(15)" skip      
      "" PlName[2] Format "x(35)"         "ÃÄÄÄÄÄÄÄ´" skip
      "" PlName[3] Format "x(35)"         "³‘ã¬.íª¢³ " Rub Format "x(15)" skip      
&ENDIF
      "" PlName[4] Format "x(35)"         "ÃÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" skip
      "" PlName[5] Format "x(35)"         "³ ‘ç.N  ³ " PlLAcct Format "x(25)" skip
      "                                    ³       ³" skip
      " « â¥«ìé¨ª                         ³       ³" skip
      "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄ´" skip
      "" PlRKC[1] Format "x(35)"          "³  ˆŠ  ³ " PlMFO Format "x(9)" skip
      "" PlRKC[2] Format "x(35)"          "ÃÄÄÄÄÄÄÄ´" skip
      "                                    ³ ‘ç.N  ³ " PlCAcct Format "x(25)" skip
      "  ­ª ¯« â¥«ìé¨ª                    ³       ³" skip
      "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" skip
      "" PoRKC[1] Format "x(35)"          "³  ˆŠ  ³ " PolMFO Format "x(9)" skip
      "" PoRKC[2] Format "x(35)"          "ÃÄÄÄÄÄÄÄ´" skip
      "                                    ³ ‘ç.N  ³ " PoCAcct Format "x(25)" skip
      "  ­ª ¯®«ãç â¥«ï                    ³       ³" skip
      "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄ´" skip
      "" PoName[1] Format "x(35)"         "³ ‘ç.N  ³ " PoAcct Format "x(25)" skip
      "" PoName[2] Format "x(35)"         "³       ³" skip
      "" PoName[3] Format "x(35)"         "³       ³" skip
      "" PoName[4] Format "x(35)"         "ÃÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄ" skip
      "" PoName[5] Format "x(35)"         "³‚¨¤ ®¯.³ " type-doc Format "x(2)" "     ³‘à®ª ¯« â.³" skip
      "                                    ÃÄÄÄÄÄÄÄ´          ÃÄÄÄÄÄÄÄÄÄÄ´" skip
      "                                    ³ §.¯«.³          ³ç¥à.¯« â.³ " buf_0_op.order-pay Format "x(2)" skip
      "                                    ÃÄÄÄÄÄÄÄ´          ÃÄÄÄÄÄÄÄÄÄÄ´" skip
      " ®«ãç â¥«ì                         ³Š®¤    ³          ³¥§.¯®«¥  ³" skip
      "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄ" skip
      "  §­ ç¥­¨¥ ¯« â¥¦ , ­ ¨¬¥­®¢ ­¨¥ â®¢ à , ¢ë¯®«­¥­­ëå à ¡®â, ®ª § ­­ëå ãá«ã£," skip
      " NN ¨ ¤ âë â®¢ à­ëå ¤®ªã¬¥­â®¢, „‘" skip
      "" Detail[1] Format "x(80)" skip
      "" Detail[2] Format "x(80)" skip
      "" Detail[3] Format "x(80)" skip
      "" Detail[4] Format "x(80)" skip
      "" Detail[5] Format "x(80)" skip
      "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" skip
      "  â¢¥âáâ¢¥­­ë©                                         Š®­âà®«¥à" skip
      "  ¨á¯®«­¨â¥«ì" skip
      " " theUser Format "x(24)" "                            " theKontr Format "x(24)" skip
     with width 88 no-labels frame out-mem.



