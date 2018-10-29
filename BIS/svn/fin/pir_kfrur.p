{pirsavelog.p}
/** 
   ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (с) 2009

   Расчет коэффициента рублевого фондирования.
   Борисов А.В., 30.12.2009
*/

{globals.i}           /* Глобальные определения */
{ulib.i}
/*
{parsin.def}
{intrface.get xclass} /* Функции для работы с метасхемой */
{intrface.get strng}  /* Функции для работы со строками */
*/

/******************************************* Определение переменных и др. */

DEFINE VARIABLE cPAcct    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cPAcctm   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAAcct    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAAcctm   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dPAcct    AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dPAcctm   AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dAAcct    AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dAAcctm   AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dTmp      AS DECIMAL    NO-UNDO.


cPAcct = "!424*,102*,10601*,10602*,30109*,30111*,30122*,30123*,30214*,"
       + "30220*,30222*,30223*,30227*,30230*,30231*,30232*,"
       + "30401*,30403*,30405*,30408*,30601*,30603*,30604*,30606*,"
       + "312*,313*,314*,315*,316*,317*,32901*,40101*,40105*,40106*,40107*,"
       + "40116*,402*,40301*,40302*,40303*,40304*,40305*,40306*,40307*,40312*,40314*,"
       + "404*,405*,406*,407*,408*,409*,41*,42*,43*,440*,"
       + "47401*,47403*,47405*,47407*,47409*,47412*,47414*,47416*,47418*,47419*,"
       + "47422*,520*,521*,522*,523*,524*,60305*,60307*,60311*,60313*,60322*"
       .
cPAcctm = "60311810000000000806,60311810100000000308,60311810100000000311,60311810200000000305,60311810400000000309,"
        + "60311810500000000306,60311810700000000805,60311810800000000310,60311810800000000307,60311810200000000813"
        .
cAAcct = "105*,10605*,109*,20319*,20320*,30302*,30304*,30306*,"
       + "325*,40111*,40311*,60805*,609*,61401*,61403*,"
       + "70606*,70607*,70608*,70609*,70610*,70611*,70612*,"
       + "70706*,70707*,70708*,70709*,70710*,70711*,70712*,70802*"
       .
cAAcctm = "50121*,50221*,50621*,50721*".

/******************************************* Реализация */
{getdate.i}
{setdest.i}

PUT UNFORMATTED "Рассчет коэффициента рублевого фондирования на " STRING(end-date, "99.99.9999") SKIP.

PUT UNFORMATTED SKIP(1) "Пассив + ==========" SKIP.
FOR EACH acct
   WHERE (acct.side EQ "П")
     AND (acct.acct-cat EQ "b")
     AND (acct.currency EQ "")
     AND CAN-DO(cPAcct, acct.acct)
   NO-LOCK:

   PUT SCREEN COL 1 ROW 24 "Обрабатывается " + acct.acct.
   dTmp   = GetAcctPosValue_UAL(acct.acct, "", end-date, NO).
   IF (dTmp NE 0)
   THEN 
      PUT UNFORMATTED acct.acct STRING(Abs(dTmp), "->>>>>>>>>>>>9.99") SKIP.
   dPAcct = dPAcct - dTmp.
END.

PUT UNFORMATTED SKIP(1) "Пассив - ==========" SKIP.
FOR EACH acct
   WHERE CAN-DO(cPAcctm, acct.acct)
     AND (acct.acct-cat EQ "b")
   NO-LOCK:

   PUT SCREEN COL 1 ROW 24 "Обрабатывается " + acct.acct.
   dTmp   = GetAcctPosValue_UAL(acct.acct, "", end-date, NO).
   IF (dTmp NE 0)
   THEN 
      PUT UNFORMATTED acct.acct STRING(Abs(dTmp), "->>>>>>>>>>>>9.99") SKIP.
   dPAcctm = dPAcctm - dTmp.
END.

PUT UNFORMATTED SKIP(1) "Актив + ===========" SKIP.
FOR EACH acct
   WHERE (acct.side EQ "А")
     AND (acct.acct-cat EQ "b")
     AND (acct.currency EQ "")
     AND NOT CAN-DO(cAAcct, acct.acct)
   NO-LOCK:

   PUT SCREEN COL 1 ROW 24 "Обрабатывается " + acct.acct.
   dTmp   = GetAcctPosValue_UAL(acct.acct, "", end-date, NO).
   IF (dTmp NE 0)
   THEN 
      PUT UNFORMATTED acct.acct STRING(Abs(dTmp), "->>>>>>>>>>>>9.99") SKIP.
   dAAcct = dAAcct + dTmp.
END.

PUT UNFORMATTED SKIP(1) "Актив - ===========" SKIP.
FOR EACH acct
   WHERE CAN-DO(cAAcctm, acct.acct)
     AND (acct.acct-cat EQ "b")
     AND (acct.currency EQ "")
   NO-LOCK:

   PUT SCREEN COL 1 ROW 24 "Обрабатывается " + acct.acct.
   dTmp   = GetAcctPosValue_UAL(acct.acct, "", end-date, NO).
   IF (dTmp NE 0)
   THEN 
      PUT UNFORMATTED acct.acct STRING(Abs(dTmp), "->>>>>>>>>>>>9.99") SKIP.
   dAAcctm = dAAcctm + dTmp.
END.


PUT SCREEN COL 1 ROW 24 COLOR NORMAL STRING(" ","X(80)").
PUT UNFORMATTED SKIP(2)
   "   Пассив +    =    " STRING(dPAcct, "->>>>>>>>>>>>9.99") SKIP
   "   Пассив -    =    " STRING(dPAcctm, "->>>>>>>>>>>>9.99") SKIP
   "   Пассив      =    " (STRING(dPAcct - dPAcctm, "->>>>>>>>>>>>9.99")) SKIP
   "   Актив  +    =    " STRING(dAAcct, "->>>>>>>>>>>>9.99") SKIP
   "   Актив  -    =    " STRING(dAAcctm, "->>>>>>>>>>>>9.99") SKIP
   "   Актив       =    " (STRING(dAAcct - dAAcctm, "->>>>>>>>>>>>9.99")) SKIP
   "   Коэффициент =    " STRING((dPAcct - dPAcctm) / (dAAcct - dAAcctm), "->>>>>>>>>>9.9999") SKIP
.

{preview.i}
{intrface.del}
