   {capsif.i}
   def var doubl-chr as char no-undo.

   if doubl-v1 then doubl-chr = trim(ts.name-vip) + " - “€’:".
               else doubl-chr = string(" ","x(3)") + trim(ts.name-vip) + ":".
    form
         "ณ"
         stmt.doc-num
         stmt.doc-type form "x(3)"
         stmt.symbol form "x(2)"
         stmt.bank-code form "x(9)"
         stmt.corr-acct form "x(25)"
         stmt.ben-acct form "x(25)"
         sacctcur
         sh-db format "->>,>>>,>>>,>>>,>>9.99"
         sh-cr format "->>,>>>,>>>,>>>,>>9.99" "ณ"
       header
    "ีออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ" skip
    "ณ" doubl-chr format "x(37)" long-acct format "x(25)" "  €" dob form "99/99/99"                                                   cur-page-str to 150 "ณ" at 152 skip
    "ณ"                                                                                                                                                    "ณ" at 152 skip
    "ณ  จฌฅญฎข ญจฅ ขซ คฅซ์ๆ  แ็ฅโ  : " capsif(name[1] + " " + name[2]) format "x(111)"                                                                    "ณ" at 152 skip
    "ณ" capsif(name[3] + " " + name[4]) format "x(111)"                                                                                                    "ณ" at 152 skip
    "ณ  จฌฅญฎข ญจฅ ใ็เฅฆคฅญจ๏ ก ญช : "      name-bank  format "x(91)"                                                                                     "ณ" at 152 skip
    "ณ"                                                                                                                                                    "ณ" at 152 skip
    "ณ เฅค. ข๋ฏจแช  ง :" prevop space(55) "‘ ซ์คฎ ญ  ญ ็ ซฎ คญ๏:" prev-db format "x(22)" prev-cr  format "x(22)"                                          "ณ" skip
    "รฤฤฤฤฤฤฤฤยฤฤฤยฤฤยฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤด" skip
    "ณ ฎฌฅเ  ณฎคณ‘ณ   ฎค   ณ     ฎเเฅแฏฎญคฅญโแชจฉ   ณ           ‘็ฅโ          ณ         จๆฅขฎฉ         ณ             กฎเฎโ๋ ข ญ ๆ. ข ซ๎โฅ            ณ" skip
    "ณ คฎชใฌ. ณคฎชณ  ณ  ก ญช   ณ       แ็ฅโ    ก ญช      ณ      ชฎเเฅแฏฎญคฅญโ      ณ           แ็ฅโ          ณ         ฅกฅโ        ณ         เฅคจโ        ณ" skip
    "รฤฤฤฤฤฤฤฤมฤฤฤมฤฤมฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤด" skip
    with no-label no-underline.
