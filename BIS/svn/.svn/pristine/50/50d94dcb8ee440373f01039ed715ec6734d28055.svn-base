/* define variable namepr as char FORMAT "x(22)" NO-UNDO.
DEF VAR theBank   AS CHAR FORMAT "x(22)" NO-UNDO.
DEF VAR theCity   AS CHAR FORMAT "x(22)" NO-UNDO.
*/

{get-bankname.i}

theBank = cBankNameSPlat.
theBank = FILL(" ", INT((22 - LENGTH(theBank)) / 2)) + theBank.

theCity = FGetSetting("│═╜╙┐╝Ю╝╓",?,"").
theCity = FILL(" ", INT((22 - LENGTH(theCity)) / 2)) + theCity.

FIND first _user WHERE _user._userid = userid("bisquit") NO-LOCK NO-ERROR.
namepr = _user._user-Name.
namepr = FILL(" ", INT((22 - LENGTH(namepr)) / 2)) + namepr.

form

&IF DEFINED(in-el) NE 0 &THEN 
/* ╓╚О М╚╔╙БЮ╝╜╜╝ё╝ */
{{&in-el} &in-frame=YES}
&ENDIF
                                                                               "зддддддддд©" at 75  skip
                                                                               "Ё" at 75 NumberForm format "x(7)" "Ё"     skip
                                                                               "юддддддддды" AT 75 skip
                                                                                                                 "здд©" AT 75
     NameOrder Format "x(21)" op.doc-num Format "x(6)" theDate Format "x(10)" AT 34 PayType Format "x(16)" AT 51 "Ё" AT 75 SPACE(0) mPokST FORMAT "x(2)" SPACE(0) "Ё"
     "                              дддддддддддддддд    ддддддддддддддддд"                                       "юдды" AT 75
     "                                    └═Б═             ┌╗╓ ╞╚═Б╔╕═ "             SKIP
     "▒Ц╛╛═    Ё" AmtStr[1] Format "x(71)"  skip
     "╞Ю╝╞╗АЛН Ё" AmtStr[2] Format "x(71)"  skip
     "         Ё" AmtStr[3] Format "x(71)"  skip
     "дддддддддадддддддддддддбдддддддддддддддддддддддбддддддбдддддддддддддддддддддддддддддд" skip
     "┬██" PlINN FORMAT "x(18)" "Ё┼▐▐" plKPP FORMAT "x(18)"    "Ё      Ё" skip
     "дддддддддддддддддддддддаддддддддддддддддддддддд╢▒Ц╛╛═ Ё" Rub Format "x(15)" "" skip
        PlName[1] Format "x(46)"                    "Ё      Ё" skip
        PlName[2] Format "x(46)"                    "цддддддедддддддддддддддддддддддддддддд" skip
        PlName[3] Format "x(46)"                    "Ё▒Г.N  Ё" PlLAcct Format "x(25)" "" skip
     "▐╚═Б╔╚ЛИ╗╙                                     Ё      Ё" skip
     "дддддддддддддддддддддддддддддддддддддддддддддддедддддд╢" skip
        PlRKC[1] Format "x(46)"                     "Ё│┬┼   Ё" PlMFO Format "x(25)" "" skip
        PlRKC[2] Format "x(46)"                     "цдддддд╢" skip
     "                                               Ё      Ё" skip
     "│═╜╙ ╞╚═Б╔╚ЛИ╗╙═                               Ё▒Г.N  Ё" PlCAcct Format "x(25)" "" skip
     "дддддддддддддддддддддддддддддддддддддддддддддддеддддддедддддддддддддддддддддддддддддд" skip
        PoRKC[1] Format "x(46)"                     "Ё│┬┼   Ё" PoMFO Format "x(25)" "" skip
        PoRKC[2] Format "x(46)"                     "цдддддд╢" skip
     "                                               Ё      Ё" skip
     "│═╜╙ ╞╝╚ЦГ═Б╔╚О                                Ё▒Г.N  Ё" PoCAcct Format "x(25)" "" skip
     "дддддддддддддддддддддддбдддддддддддддддддддддддедддддд╢" skip
     "┬██" PoINN FORMAT "x(18)" "Ё┼▐▐" poKPP FORMAT "x(18)"    "Ё      Ё" skip
     "дддддддддддддддддддддддаддддддддддддддддддддддд╢      Ё"                               SKIP
      PoName[1] Format "x(46)"                      "Ё▒Г.N  Ё" PoAcct Format "x(25)" "" skip
      PoName[2] Format "x(46)"                      "цддддддеддддддддбдддддддддбддддддддддд" skip
      PoName[3] Format "x(46)"                      "Ё┌╗╓ ╝╞Ё" op.doc-type Format "x(2)" "Ё▌Г╔Ю.╞╚═БЁ " AT 64 SPACE(0) op.order-pay Format "x(2)" "" skip
     "                                               Ё█═╖.╞╚Ё        цддддддддд╢"            SKIP
     "▐╝╚ЦГ═Б╔╚Л                                     Ё┼╝╓   Ё        Ё░╔╖.╞╝╚╔ Ё" skip
     "ддддддддддбддддддддддддбдддддддддддбдддддддддддеддддддеддддддддадддддддддаддддддддддд" skip
     "N Г. ╞╚═Б.Ё≤╗ДЮ ╞╚ ╓╝╙.ЁN ╞╚ ╓╝╙.  Ё└═Б═ ╞╚.╓╝╙Ё▒Ц╛╛═ Ё                              " SKIP
      numPartPayment AT 1  FORMAT ">>9"  "Ё" AT 11
      codePayDoc     AT 12 FORMAT "x(2)" "Ё" AT 24
      numPayDoc      AT 25 FORMAT "x(6)" "Ё" AT 36
      DatePayDoc     AT 37 FORMAT "99.99.9999" "Ё╝АБ.╞╚Ё" AT 48
      sum-balance-str  FORMAT "x(20)" AT 58                                                  SKIP
     "ддддддддддаддддддддддддадддддддддддаддддддддддд╢      Ё"                               SKIP
     "▒╝╓╔Ю╕═╜╗╔ ╝╞╔Ю═Ф╗╗: " DestPay Format "x(24)" "Ё      Ё"                               SKIP
     "ддддддддддддддддддддбдддддддддддддбддддбдддддддаддддбдадддддддддддддбддддддддддбддддд" SKIP
/*    1234567890123456789 | 12345678901 | 12 | 1234567890 |123456789012345|1234567890| 12 |*/
     mKBK FORMAT "x(20)Ё" mOKATO FORMAT "x(11)" "Ё" mPokOp FORMAT "x(2)" "Ё"  mPokNP FORMAT "x(10)"  "Ё" SPACE(0) mPokND FORMAT "x(15)" SPACE(0) "Ё" SPACE(0) mPokDD FORMAT "x(10)" SPACE(0) "Ё" SPACE(0) mPokTP FORMAT "x(2)"
     "ддддддддддддддддддддадддддддддддддаддддаддддддддддддадбдддддддддддддаддддддддддаддддд"
     "█═╖╜═Г╔╜╗╔ ╞╚═Б╔╕═  "                                "Ё" at 55 "здддддддддддддддддддддддд©" skip
     DetailPay[1] FORMAT "x(50)"                           "Ё" at 55 "Ё        ▐░┬█÷▓▌         Ё" SKIP
     DetailPay[2] FORMAT "x(50)"                           "Ё" at 55 "Ё" theBank "Ё" SKIP
     DetailPay[3] FORMAT "x(50)"                           "Ё" at 55 "Ё" theCity "Ё"SKIP
     DetailPay[4] FORMAT "x(50)"                           "Ё" at 55 "Ё     " op.op-date "ё.     Ё" SKIP
     DetailPay[5] FORMAT "x(50)"                           "Ё" at 55 "Ё" namepr format "x(22)" "Ё" SKIP
     DetailPay[6] FORMAT "x(50)"                           "Ё" at 55 "юдддддддддддддддддддддддды" skip
                                                           "Ё" AT 55 SKIP
                                                           "Ё     ▌Б╛╔Б╙╗ ║═╜╙═" AT 55 SKIP 
                                                           "Ё" AT 55 SKIP
     with width 88 no-labels frame out-doc.
