/*-----------------------------------------------------------------------------
                ­ª®¢áª ï ¨­â¥£à¨à®¢ ­­ ï á¨áâ¥¬  ˆ‘ª¢¨â
    Copyright: (C) 1992-2001 ’ " ­ª®¢áª¨¥ ¨­ä®à¬ æ¨®­­ë¥ á¨áâ¥¬ë"
     Filename: sword.i
      Comment: ¥ç âì á¢®¤­®£® ¬¥¬®à¨ «ì­®£® ®à¤¥à  (¨á¯®«ì§ã¥âáï ä¨«ìâà).
               ‘®ªà é ¥¬ à áå®¤ ¡ã¬ £¨. ®¤ª«îç ¥âáï ¢ CTRL-G ¢ ¤®ª-â å ¤­ï.
   Parameters:
         Uses: sword.p sword-p.p
      Used by:
      Created: 18/06/2002 kraw
     Modified: 26/12/2002 kraw (0013029) ‚®ááâ ­®¢«¥­® ®â®¡à ¦¥­¨¥ ¯®«ã¯à®¢®¤®ª
     Modified: 16/01/2003 kraw (0011853) ˆâ®£®¢ ï áã¬¬  ¯à®¯¨áìî ¢ ª®­æ¥
     Modified: 27/02/2003 kraw (0013230) ‚®ááâ ­®¢«¥­¨¥ ¢ à¨ ­â  ã§ª®© ¯¥ç â¨
     Modified: 06/01/2003 kraw (0024627) ¡­ã«¥­¨¥ áç¥âç¨ª  ¨â®£®¢®© áã¬¬ë (­¥®¡å®¤¨¬®
             : ¯à¨ ¯¥ç â¨ ­¥áª®«ìª¨å íª§¥¬¯«ïà®¢)
     Modified: 10/02/2004 kraw (0024321) 3 ¯ãáâë¥ áâà®ª¨ ª ª®­æ¥ ®à¤¥à 
     Modified: 
-----------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------*/
{globals.i}
{pp-uni.var}
{pp-uni.prg}
{intrface.get strng}

def var senderName as char no-undo.
def var receiverName as char no-undo.

{flt-val.i}
{strtout3.i &cols=95 &custom="printer.page-lines - "}
def var sDate  as char format "x(29)" no-undo.  /* ¤ â          */
def var sFilt  as char format "x(29)" no-undo.  /* ¨¬ï ä¨«ìâà   */

{tmprecid.def}        /** ˆá¯®«ì§ã¥¬ ¨­ä®à¬ æ¨î ¨§ ¡à®ã§¥à  */

def temp-table totals no-undo /* ¨â®£¨ âãâ */
    field currency like op-entry.currency
    field amt-rub  like op-entry.amt-rub
    field amt-cur  like op-entry.amt-cur
    field i        as   int /* ª®«-¢® ¯à®¢®¤®ª */.
.

def var acct-db as character no-undo.
def var acct-cr as character no-undo.
def var cAmtStr as char no-undo.
def var cDecStr as char no-undo.
def var amtstr1  as char extent 3 no-undo.
def var i-amt-rub like op-entry.amt-rub  init 0  no-undo.
def var i-amt-cur like op-entry.amt-cur  init 0  no-undo.
def var i-cur     like op-entry.currency init ? no-undo.


{get_set.i " ­ª"}
put unformatted  setting.val skip(2). /* ­ §¢ ­¨¥ ¡ ­ª  */

function StrCenter returns char (input asStr as char, input anLen as int).
    def var nSpaces as int  no-undo.
    assign nSpaces = ( anLen - length( asStr ) ) / 2.
    return string( fill( " ", nSpaces ) + asStr, "x(" + string( anLen ) + ")" ).
end.

ASSIGN
   i-amt-rub = 0
   i-amt-cur = 0
.

/* find first flt-attr where flt-attr.attr-initial <> flt-attr.attr-code-value no-lock no-error.*/
assign
    PackagePrint = true
    sDate = string( caps({term2str date(GetFltVal('op-date1')) date(GetFltVal('op-date2')) yes}), "x(30)" )
    sFilt = FStrCenter( IF IsFieldChange("*") then ( '”¨«ìâà "' + GetEntries(3,GetFltVal("UserConf"),",","?") + '"') else "‚á¥ ¤®ªã¬¥­âë", 75 )
.

&IF DEFINED( FILE_sword_i_wide ) NE 0
&THEN
   PUT UNFORMATTED  "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" skip.
   PUT UNFORMATTED  "³        ‘‚„›‰ Œ…Œˆ€‹œ›‰ „…  „Š“Œ…’€Œ „Ÿ ‡€  " + sDate +                  "                                                                                                                                ³"  skip.
   PUT UNFORMATTED  "³        " + sFilt +                                                               "                                                                                                                                    ³"  skip.
   PUT UNFORMATTED  "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´" skip.
   PUT UNFORMATTED  "³à®¢¥áâ¨ ¯® ­¨¦¥ãª § ­­ë¬ áç¥â ¬ á«¥¤ãîé¨¥ § ¯¨á¨:                                                                                                                                                                     ³" skip.
   PUT UNFORMATTED  "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´" skip.
   PUT UNFORMATTED  "³ ” ¬¨«¨ï ˆ¬ï âç¥áâ¢® ®«ãç â¥«ï ³‚ «.³    ‘ã¬¬  ¢ ¢ «îâ¥ ³ ‘ã¬¬  ¢ ­ æ.¢ «.  ³        « â¥«ìé¨ª               ³        „¥¡¥â         ³        Šà¥¤¨â        ³                      §­ ç¥­¨¥                         ³" skip.
   PUT UNFORMATTED  "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´" skip.
&ENDIF



for each tmprecid no-lock,

&if defined( FILE_sword_p ) ne 0 &then

  first op where recid(op) = tmprecid.id no-lock,
   each op-entry of op no-lock break by op-entry.currency by op-entry.amt-rub:

&else

  first op-entry where recid(op-entry) = tmprecid.id no-lock,
   first op of op-entry no-lock break by op-entry.currency by op-entry.amt-rub:

&endif

      assign
       acct-cr =  if (op-entry.acct-cr <> ?) then op-entry.acct-cr else ""
       acct-db =  if (op-entry.acct-db <> ?) then op-entry.acct-db else ""
      .
      accumulate op-entry.amt-rub (total count by op-entry.currency).
      accumulate op-entry.amt-cur (total count by op-entry.currency).
   
&IF DEFINED( FILE_sword_i_wide ) NE 0
&THEN

      {empty Info-Store}
      run Collection-Info.
/*      RUN for-pay("„……’,‹€’…‹œ™ˆŠ,€Š‹,€Šƒ,€Š”ˆ‹",
               "",
               OUTPUT PlName[1],
               OUTPUT PlLAcct,
               OUTPUT PlRKC[1],
               OUTPUT PlCAcct,
               OUTPUT PlMFO).
      senderName = PlName[1].
      RUN for-rec("Š…„ˆ’,‹“—€’…‹œ,€Š‹,€Šƒ,€Š”ˆ‹",
               "",
               OUTPUT PoName[1],
               OUTPUT PoAcct,
               OUTPUT PoRKC[1],
               OUTPUT PoCAcct,
               OUTPUT PoMFO).*/

      FIND FIRST acct WHERE acct.acct EQ acct-db and acct-db ne "" NO-LOCK NO-ERROR.
      IF avail acct then 
      do:  
         PlName[1] = TRIM(acct.Details).
         if PlName[1] eq ? then DO:
            {getcust.i &name=NameCli &OFFinn = "/*" &OFFsigns = "/*"}
            PlName[1] = NameCli[1] + " " + NameCli[2].
         end.
      end.
      FIND FIRST acct WHERE acct.acct EQ acct-cr and acct-cr ne "" NO-LOCK NO-ERROR.
      if avail acct then do:
         PoName[1] = TRIM(acct.Details).
         if PoName[1] eq ? then DO:
            {getcust.i &name=NameCli &OFFinn = "/*" &OFFsigns = "/*"}
            PoName[1] = NameCli[1] + " " + NameCli[2].
         end.
      end.
      RUN DefDetail.
   {wordwrap.i &s = Detail
               &n = 5
               &l = 56
   }
&ELSEIF DEFINED(FILE_sword_i_wide) NE 0
&THEN
   RUN DefDetail.
   {wordwrap.i &s = Detail
               &n = 5
               &l = 50
   }
&ENDIF

 put UNFORMATTED
            "³" + STRING(PoName[1], "x(33)") +
            "³" + string(op-entry.currency, "x(4)") +
            "³" + string(op-entry.amt-cur,  "->>>,>>>,>>>,>>9.99") +
            "³" + string(op-entry.amt-rub, "->>>,>>>,>>>,>>9.99") +

&IF DEFINED( FILE_sword_i_wide ) NE 0
&THEN
            "³" + STRING(PlName[1], "x(33)") +
            "³ " + STRING(acct-db,"x(21)") +
            "³ " + STRING(acct-cr,"x(21)") +
            "³" + STRING(Detail[1],"x(56)") +
&ELSEIF DEFINED(FILE_SWORD_I_NAZN) NE 0
&THEN
            "³" + STRING(Detail[1],"x(50)") +
&ENDIF
            "³" skip.

    if last-of(op-entry.currency) then do:
              create totals.
              assign
               totals.currency = op-entry.currency
               totals.amt-rub = (accum total by op-entry.currency op-entry.amt-rub)
               totals.amt-cur = (accum total by op-entry.currency op-entry.amt-cur)
               totals.i =       (accum count by op-entry.currency op-entry.amt-rub)
             .
    end. /* last-of */
end.

&IF DEFINED( FILE_sword_i_wide ) NE 0
&THEN
   PUT UNFORMATTED "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´" skip.
&ELSEIF DEFINED(FILE_SWORD_I_NAZN) NE 0
&THEN
   PUT UNFORMATTED "ÃÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´" skip.
&ELSE
   PUT UNFORMATTED "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´" skip.
&ENDIF

for each totals:
 put unformatted  "³ ˆâ®£®: " + string(totals.i, ">>>>9") + " ¯à®¢.  " + "             " + string(totals.currency, "xxxx") + " " + string(totals.amt-cur,  "->>>,>>>,>>>,>>9.99") + " " + string(totals.amt-rub,  "->>>,>>>,>>>,>>9.99")  +

&IF DEFINED( FILE_sword_i_wide ) NE 0
&THEN

   FILL(" ", 137) +

&ELSEIF DEFINED(FILE_SWORD_I_NAZN) NE 0
&THEN
   FILL(" ",75) +
&ENDIF

   "³" skip.
   assign
      i-amt-rub = i-amt-rub + totals.amt-rub
      i-amt-cur = i-amt-cur + totals.amt-cur
   .
   if i-cur = ? then i-cur = totals.currency.
   else if i-cur <> totals.currency then i-cur = "".
end.

FOR EACH totals:
   DELETE totals.
END.

&IF DEFINED( FILE_sword_i_wide ) NE 0
&THEN
   PUT UNFORMATTED "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" skip.
&ELSEIF DEFINED(FILE_SWORD_I_NAZN) NE 0
&THEN
   PUT UNFORMATTED "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" skip.
&ELSE
   PUT UNFORMATTED "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" skip.
&ENDIF

if i-cur = "" then
   run x-amtstr.p (i-amt-rub, '', yes, yes,
                output cAmtStr, output cDecStr).
else
   run x-amtstr.p (i-amt-cur, i-cur, yes, yes,
                output cAmtStr, output cDecStr).
AmtStr1 = cAmtStr + ' ' + cDecStr.

&if defined( FILE_sword_i_wide ) &then

{wordwrap.i &s=amtstr1 &n=3 &l=170}

&else

{wordwrap.i &s=amtstr1 &n=3 &l=90}

&endif

put unformatted  " ˆâ®£®: "  amtstr1[1]  skip.
if length(amtstr1[2]) > 0 then
   put unformatted  "        "  amtstr1[2]  skip.
if length(amtstr1[3]) > 0 then
   put unformatted  "        "  amtstr1[3]  skip.

put unformatted skip(1).

put unformatted "à¨«®¦¥­¨ï ­  ____ «¨áâ å." skip(2).
put unformatted "ãå£ «â¥à"+  fill("_", 15) +  fill(" ", 10) + "Š®­âà®«¥à" +  fill("_", 15) skip.
/* {signatur.i} */  /* - ¯®¤¯¨á¨ £« ¢ ¡ãå ¨ ¤¨à¥ªâ®à */
PackagePrint = false.
PUT UNFORMATTED SKIP(3).
{endout3.i}

