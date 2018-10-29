/*-----------------------------------------------------------------------------
                ­ª®Άαª ο ¨­β¥£ΰ¨ΰ®Ά ­­ ο α¨αβ¥¬  ‘ªΆ¨β
    Copyright: (C) 1992-2003 ’ " ­ª®Άαª¨¥ ¨­δ®ΰ¬ ζ¨®­­λ¥ α¨αβ¥¬λ"
     Filename: sw-uni.p
      Comment: ΰ®ζ¥¤γΰλ ¤«ο αΆ®¤­¨ª  ―® θ ΅«®­γ
   Parameters:
         Uses: 
      Used by:
      Created: 27/05/2003 Peter
     Modified: 
-----------------------------------------------------------------------------*/
form "~n@(#) sw-uni.pro Peter Peter" with frame sccs-id stream-io width 250.

{parsin.def}

PROCEDURE CreateTempEntry:
  DEFINE INPUT PARAMETER aId AS RECID.
  CREATE tt-en.
  tt-en.rid = aId.
END PROCEDURE.

FUNCTION GetSortValue RETURNS CHAR (INPUT aSortFlds AS CHAR):
  DEFINE VAR t-rez AS CHAR NO-UNDO.
  DEFINE VAR i AS INTEGER NO-UNDO.

  IF aSortFlds = "" THEN
    RETURN STRING(tt-ope.op, "9999999999").

  DO i = 1 TO NUM-ENTRIES(aSortFlds):
    CASE ENTRY(i, aSortFlds):
      WHEN "‘γ¬¬ "   THEN t-rez = t-rez + STRING(tt-ope.amt-rub,  "-999999999999999.99999").
      WHEN "‘γ¬¬ ‚"  THEN t-rez = t-rez + STRING(tt-ope.amt-cur,  "-999999999999999.99999").
      WHEN "‘η„΅"    THEN t-rez = t-rez + STRING(tt-ope.acct-db,  "x(20)").
      WHEN "‘ηΰ"    THEN t-rez = t-rez + STRING(tt-ope.acct-cr,  "x(20)").
      WHEN "‚ «"     THEN t-rez = t-rez + STRING(tt-ope.currency, "x(3)").
      WHEN " α‘¨¬"  THEN t-rez = t-rez + STRING(tt-ope.symbol,   "x(2)").
      WHEN "„®ª®¬"  THEN t-rez = t-rez + STRING(tt-ope.doc-num,  "x(6)").
      WHEN "«"   THEN t-rez = t-rez + STRING(tt-ope.plmfo,    "x(9)").
      WHEN "®"   THEN t-rez = t-rez + STRING(tt-ope.pomfo,    "x(9)").
      WHEN "¥δ"     THEN t-rez = t-rez + STRING(tt-ope.reference, "x(8)").
      WHEN "¥©αªα" THEN t-rez = t-rez + STRING(tt-ope.exp-batch, "xx").
      WHEN "¥©α¬―" THEN t-rez = t-rez + STRING(tt-ope.imp-batch, "xx").
    END.
  END.
  RETURN t-rez.
END FUNCTION.

FUNCTION GetBreakValue RETURNS CHAR (INPUT aBreakFld AS CHAR):
  DEFINE VAR t-rez AS CHAR NO-UNDO.
  DEFINE VAR i AS INTEGER NO-UNDO.

  IF aBreakFld = "" THEN
    RETURN "".

  DO i = 1 TO NUM-ENTRIES(aBreakFld):
    CASE ENTRY(i, aBreakFld):
      WHEN "‘η„΅"      THEN t-rez = t-rez + STRING(tt-ope.acct-db,  "x(20)").
      WHEN "‘ηΰ"      THEN t-rez = t-rez + STRING(tt-ope.acct-cr,  "x(20)").
      WHEN "‘η¥β®«"   THEN t-rez = t-rez + STRING(tt-ope.polacct,  "x(20)").
      WHEN "‘η¥β« β"  THEN t-rez = t-rez + STRING(tt-ope.placct,   "x(20)").
      WHEN "‚ «"       THEN t-rez = t-rez + STRING(tt-ope.currency, "x(3)").
      WHEN " α‘¨¬"    THEN t-rez = t-rez + STRING(tt-ope.symbol,   "x(2)").
      WHEN "«"     THEN t-rez = t-rez + STRING(tt-ope.plmfo,    "x(9)").
      WHEN "®"     THEN t-rez = t-rez + STRING(tt-ope.pomfo,    "x(9)").
      WHEN "¥δ"       THEN t-rez = t-rez + STRING(tt-ope.reference, "x(8)").
      WHEN "¥©αªα"   THEN t-rez = t-rez + STRING(tt-ope.exp-batch, "xx").
      WHEN "¥©α¬―"   THEN t-rez = t-rez + STRING(tt-ope.imp-batch, "xx").
      WHEN "„®ª„ β "   THEN t-rez = t-rez + STRING(year(tt-ope.doc-date), "9999") + STRING(month(tt-ope.doc-date), "99") + STRING(day(tt-ope.doc-date), "99").
      WHEN "„®ª―„ β " THEN t-rez = t-rez + STRING(year(tt-ope.op-date), "9999") + STRING(month(tt-ope.op-date), "99") + STRING(day(tt-ope.op-date), "99").
    END.
  END.
  RETURN t-rez.
END FUNCTION.

&IF DEFINED(ALL_PROC) <> 0 &THEN
PROCEDURE LoadTemplate:
  DEFINE INPUT PARAMETER aTemplate AS CHAR NO-UNDO.
  DEFINE VAR rpt-txt   AS CHAR NO-UNDO.
  DEFINE VAR curr-sect AS CHAR NO-UNDO.
  DEFINE VAR prev-line AS INTEGER NO-UNDO.

  FOR EACH reports WHERE reports.name = aTemplate NO-LOCK:
    IF TRIM(reports.txt) BEGINS "!" THEN NEXT.
    rpt-txt = SUBSTR(reports.txt, 1, INDEX(reports.txt, "//") - 1).
    IF TRIM(rpt-txt) MATCHES "[*]" THEN
      ASSIGN
        curr-sect = TRIM(rpt-txt)
        prev-line = reports.line + 1
      .

    ELSE 
      IF curr-sect <> "" THEN
        CASE curr-sect:
          WHEN "[‘‚‰‘’‚€]" THEN
            CASE ENTRY(1, TRIM(rpt-txt), "="):
              WHEN "‘®ΰβ"       THEN fSortFlds      = TRIM(ENTRY(2, TRIM(rpt-txt), "=")).
              WHEN "‚®§ΰ αβ"    THEN fSortAsc       = TRIM(ENTRY(2, TRIM(rpt-txt), "=")) = "„ ".
              WHEN "€£ΰ®«γΰ"  THEN fAggregate     = TRIM(ENTRY(2, TRIM(rpt-txt), "=")) = "„ ".
              WHEN "€£ΰ¥¦‚ «"  THEN fAggregateSide = TRIM(ENTRY(2, TRIM(rpt-txt), "=")).
              WHEN "ƒΰγ――"      THEN fBreakField    = TRIM(ENTRY(2, TRIM(rpt-txt), "=")).
              WHEN "ƒΰγ――β®£¨" THEN fBreakAccum    = TRIM(ENTRY(2, TRIM(rpt-txt), "=")).
            END.
          WHEN "[”€’›]" THEN DO:
            FIND FIRST tt-fmt WHERE tt-fmt.fld = ENTRY(1, TRIM(rpt-txt), "=") NO-LOCK NO-ERROR.
            IF NOT AVAIL tt-fmt THEN 
              CREATE tt-fmt.
            ASSIGN
              tt-fmt.fld = ENTRY(1, TRIM(rpt-txt), "=")
              tt-fmt.fmt = ENTRY(2, TRIM(rpt-txt), "=")
            .
          END.
          WHEN "[‡€ƒ‹‚]" then do:
            FIND LAST tt-hdr NO-LOCK NO-ERROR.
            IF AVAIL tt-hdr THEN prev-line = tt-hdr.num + 1.
            DO WHILE prev-line < reports.line:
              CREATE tt-hdr.
              ASSIGN
                tt-hdr.num = prev-line
                tt-hdr.txt = ""
                prev-line  = prev-line + 1
              .
            END.
            CREATE tt-hdr.
            ASSIGN
              tt-hdr.num = reports.line
              tt-hdr.txt = rpt-txt
            .
          END.
          WHEN "[’…‹]" THEN DO:
            FIND LAST tt-bd NO-LOCK NO-ERROR.
            IF AVAIL tt-bd THEN prev-line = tt-bd.num + 1.
            DO WHILE prev-line < reports.line:
              CREATE tt-bd.
              ASSIGN
                tt-bd.num = prev-line
                tt-bd.txt = ""
                prev-line = prev-line + 1
              .
            END.
            CREATE tt-bd.
            ASSIGN
              tt-bd.num = reports.line
              tt-bd.txt = rpt-txt
            .
          END.
          WHEN "[„’ƒ]" THEN DO:
            FIND LAST tt-st NO-LOCK NO-ERROR.
            IF AVAIL tt-st THEN prev-line = tt-st.num + 1.
            DO WHILE prev-line < reports.line:
              CREATE tt-st.
              ASSIGN
                tt-st.num = prev-line
                tt-st.txt = ""
                prev-line = prev-line + 1
              .
            END.
            CREATE tt-st.
            ASSIGN
              tt-st.num = reports.line
              tt-st.txt = rpt-txt
            .
          END.
          WHEN "[’ƒ]" THEN DO:
            FIND LAST tt-tt NO-LOCK NO-ERROR.
            IF AVAIL tt-tt THEN prev-line = tt-tt.num + 1.
            DO WHILE prev-line < reports.line:
              CREATE tt-tt.
              ASSIGN
                tt-tt.num = prev-line
                tt-tt.txt = ""
                prev-line = prev-line + 1
              .
            END.
            CREATE tt-tt.
            ASSIGN
              tt-tt.num = reports.line
              tt-tt.txt = rpt-txt
            .
          END.
          WHEN "[„‚€‹]" then do:
            FIND LAST tt-ftr NO-LOCK NO-ERROR.
            IF AVAIL tt-ftr THEN prev-line = tt-ftr.num + 1.
            DO WHILE prev-line < reports.line:
              CREATE tt-ftr.
              ASSIGN
                tt-ftr.num = prev-line
                tt-ftr.txt = ""
                prev-line  = prev-line + 1
              .
            END.
            CREATE tt-ftr.
            ASSIGN
              tt-ftr.num = reports.line
              tt-ftr.txt = rpt-txt
            .
          END.
          WHEN "[…–]" THEN LEAVE.
        END. 
  END.

  {get_set.i " ­ª"}
/*  FIND FIRST flt-attr WHERE flt-attr.attr-initial <> flt-attr.attr-code-value NO-LOCK NO-ERROR.*/
  ASSIGN
    fPeriod = CAPS({term2str DATE(GetFltVal('op-date1')) DATE(GetFltVal('op-date2')) YES})
    fFilter = IF IsFieldChange("*") THEN ('”¨«μβΰ "' + GetEntries(3,GetFltVal("UserConf"),",","?") + '"') ELSE "‚α¥ ¤®ªγ¬¥­βλ"
    fBank   = setting.val
  .

END PROCEDURE.

FUNCTION GetRealBreakValue RETURNS CHAR (INPUT aBreakFld AS CHAR):
  DEFINE VAR t-rez AS CHAR NO-UNDO.
  DEFINE VAR i AS INTEGER NO-UNDO.

  IF aBreakFld = "" THEN
    RETURN "".

  DO i = 1 TO NUM-ENTRIES(aBreakFld):
    CASE ENTRY(i, aBreakFld):
      WHEN "‘η„΅"      THEN t-rez = t-rez + STRING(tt-ope.acct-db,  "x(20)").
      WHEN "‘ηΰ"      THEN t-rez = t-rez + STRING(tt-ope.acct-cr,  "x(20)").
      WHEN "‘η¥β®«"   THEN t-rez = t-rez + STRING(tt-ope.polacct,  "x(20)").
      WHEN "‘η¥β« β"  THEN t-rez = t-rez + STRING(tt-ope.placct,   "x(20)").
      WHEN "‚ «"       THEN t-rez = t-rez + STRING(tt-ope.currency, "x(3)").
      WHEN " α‘¨¬"    THEN t-rez = t-rez + STRING(tt-ope.symbol,   "x(2)").
      WHEN "«"     THEN t-rez = t-rez + STRING(tt-ope.plmfo,    "x(9)").
      WHEN "®"     THEN t-rez = t-rez + STRING(tt-ope.pomfo,    "x(9)").
      WHEN "¥δ"       THEN t-rez = t-rez + STRING(tt-ope.reference,"x(8)").
      WHEN "¥©αªα"   THEN t-rez = t-rez + STRING(tt-ope.exp-batch,"xx").      
      WHEN "¥©α¬―"   THEN t-rez = t-rez + STRING(tt-ope.imp-batch,"xx").
      WHEN "„®ª„ β "   THEN t-rez = t-rez + STRING(tt-ope.doc-date, "99/99/9999").
      WHEN "„®ª―„ β " THEN t-rez = t-rez + STRING(tt-ope.op-date,  "99/99/9999").
    END.
  END.
  RETURN t-rez.
END FUNCTION.

FUNCTION GetFieldFmt RETURNS CHAR (INPUT aName AS CHAR, INPUT aDef AS CHAR):
  FIND FIRST tt-fmt WHERE tt-fmt.fld = aName NO-LOCK NO-ERROR.
  RETURN IF AVAIL tt-fmt THEN tt-fmt.fmt ELSE aDef.
END FUNCTION.

FUNCTION GetExtString RETURNS CHAR (INPUT aTxt AS CHAR):
  DEFINE VAR t-rez AS CHAR NO-UNDO.
  DEFINE VAR i     AS INTEGER NO-UNDO.

  DO i = 1 to NUM-ENTRIES(aTxt, "@"):
    IF i MODULO 2 = 0 THEN DO:
      IF ENTRY(i, aTxt, "@") BEGINS "." THEN DO:
        t-rez = t-rez + STRING(FGetSettingEx(ENTRY(2, ENTRY(i, aTxt, "@"), "."), IF NUM-ENTRIES(ENTRY(i, aTxt, "@"), ".") < 3 THEN ? ELSE ENTRY(3, ENTRY(i, aTxt, "@"), "."), "", NO), GetFieldFmt(ENTRY(i, aTxt, "@"), "x(8)")).
      END.
      ELSE IF ENTRY(i, aTxt, "@") BEGINS "„." THEN DO:
        t-rez = t-rez + STRING(GetXAttrValue("op", string(tt-ope.op), ENTRY(2, ENTRY(i, aTxt, "@"), ".")), GetFieldFmt(ENTRY(i, aTxt, "@"), "x(8)")).
      END.
    END.
    ELSE
      t-rez = t-rez + ENTRY(i, aTxt, "@").
  END.

  RETURN t-rez.
END FUNCTION.

FUNCTION GetWrapString RETURNS CHAR (INPUT aTxt AS CHAR, INPUT fake AS LOGICAL, INPUT aFld AS CHAR, INPUT aValue AS CHAR):
  DEFINE VAR t-rez     AS CHAR NO-UNDO.
  DEFINE VAR t-details AS CHAR EXTENT 9 NO-UNDO.
  DEFINE VAR t-n       AS INTEGER NO-UNDO.

  t-rez = aTxt.

  t-details[1] = aValue.
  t-n = LENGTH(STRING(FILL("-", 2048), GetFieldFmt(aFld, "x(30)"))).
  {wordwrap.i &s=t-details &n=9 &l=t-n}
  DO t-n = 1 TO 9:
    t-rez = REPLACE(t-rez, "@" + aFld + STRING(t-n, "9") + "@", STRING(IF fake THEN " " ELSE t-details[t-n], GetFieldFmt(aFld, "x(30)"))).
  END.

  RETURN t-rez.
END FUNCTION.

FUNCTION GetAcctName RETURNS CHAR (INPUT aAcct AS CHAR):
  def var name as char extent 2 no-undo.
  FIND FIRST acct WHERE acct.acct = aAcct NO-LOCK NO-ERROR.
  {getcust.i &name=name &Offinn={comment}}
  name[1] = trim(name[1] + " " + name[2]).
  RETURN IF AVAIL acct THEN name[1] ELSE "".
END FUNCTION.

FUNCTION GetString RETURNS CHAR (INPUT aTxt AS CHAR, INPUT fake AS LOGICAL):
  DEFINE VAR t-rez     AS CHAR NO-UNDO.
  DEFINE VAR t-details AS CHAR EXTENT 9 NO-UNDO.
  DEFINE VAR t-n       AS INTEGER NO-UNDO.

  t-rez = aTxt.

  IF NOT AVAIL tt-ope THEN 
    FIND FIRST tt-ope NO-LOCK NO-ERROR.
                               
  IF AVAIL tt-ope THEN DO:
    t-rez = REPLACE(t-rez, "@„®ª®¬@",  STRING(tt-ope.doc-num,   GetFieldFmt("„®ª®¬",   "x(6)"))).
    t-rez = REPLACE(t-rez, "@‘η„΅@",    STRING(tt-ope.acct-db,   GetFieldFmt("‘η„΅",     "x(20)"))).
    t-rez = REPLACE(t-rez, "@‘ηΰ@",    STRING(tt-ope.acct-cr,   GetFieldFmt("‘ηΰ",     "x(20)"))).
    t-rez = REPLACE(t-rez, "@«@",   STRING(tt-ope.plmfo,     GetFieldFmt("«",    "x(9)"))).
    t-rez = REPLACE(t-rez, "@«@",   STRING(tt-ope.plinn,     GetFieldFmt("«",    "x(12)"))).
    t-rez = REPLACE(t-rez, "@«@",   STRING(tt-ope.plkpp,     GetFieldFmt("«",    "x(12)"))).
    t-rez = REPLACE(t-rez, "@®@",   STRING(tt-ope.pomfo,     GetFieldFmt("®",    "x(9)"))).
    t-rez = REPLACE(t-rez, "@®@",   STRING(tt-ope.poinn,     GetFieldFmt("®",    "x(12)"))).
    t-rez = REPLACE(t-rez, "@®@",   STRING(tt-ope.pokpp,     GetFieldFmt("®",    "x(12)"))).
    t-rez = REPLACE(t-rez, "@«–@",   STRING(tt-ope.plrkc,     GetFieldFmt("«–",    "x(20)"))).
    t-rez = REPLACE(t-rez, "@®–@",   STRING(tt-ope.porkc,     GetFieldFmt("®–",    "x(20)"))).    
    t-rez = REPLACE(t-rez, "@‚ «@",     STRING(tt-ope.currency,  GetFieldFmt("‚ «",      "x(3)"))).
    t-rez = REPLACE(t-rez, "@‘η¥β®«@", STRING(tt-ope.polacct,   GetFieldFmt("‘η¥β®«",  "x(20)"))).
    t-rez = REPLACE(t-rez, "@‘η¥β« β@",STRING(tt-ope.placct,    GetFieldFmt("‘η¥β« β", "x(20)"))).
    t-rez = REPLACE(t-rez, "@‚¨¤―@",   STRING(tt-ope.doc-type,  GetFieldFmt("‚¨¤―",    "x(3)"))).
    t-rez = REPLACE(t-rez, "@η¥ΰ«@",  STRING(tt-ope.order-pay, GetFieldFmt("η¥ΰ«",   "x(2)"))).
    t-rez = REPLACE(t-rez, "@‘β βγα@",  STRING(tt-ope.op-status, GetFieldFmt("‘β βγα",   "x(3)"))).
    t-rez = REPLACE(t-rez, "@ α‘¨¬@",  STRING(tt-ope.symbol,    GetFieldFmt(" α‘¨¬",   "x(2)"))).

    t-rez = REPLACE(t-rez, "@„®ª„ β @",    STRING(tt-ope.doc-date,   GetFieldFmt("„®ª„ β ",    "99/99/9999"))).
    t-rez = REPLACE(t-rez, "@„®ª―„ β @",  STRING(tt-ope.op-date,    GetFieldFmt("„®ª―„ β ",  "99/99/9999"))).
    t-rez = REPLACE(t-rez, "@„®ª«„ β @",  STRING((if tt-ope.due-date eq ? then tt-ope.op-date else tt-ope.due-date),   GetFieldFmt("„®ª«„ β ",  "99/99/9999"))).
    t-rez = REPLACE(t-rez, "@‘γ¬¬ @",      STRING(tt-ope.amt-rub,    GetFieldFmt("‘γ¬¬ ",  "->>>,>>>,>>>,>>9.99"))).
    t-rez = REPLACE(t-rez, "@‘γ¬¬ ‚@",     STRING(tt-ope.amt-cur,    GetFieldFmt("‘γ¬¬ ‚", "->>>,>>>,>>>,>>9.99"))).
    t-rez = REPLACE(t-rez, "@®«@",        STRING(tt-ope.qty,        GetFieldFmt("®«", ">>>>>9"))).
    t-rez = REPLACE(t-rez, "@¥δ@",        STRING(tt-ope.reference,  GetFieldFmt("¥δ", "x(8)"))).    
    t-rez = REPLACE(t-rez, "@¥©αªα@",    STRING(tt-ope.exp-batch,  GetFieldFmt("¥©αªα", "xx"))).    
    t-rez = REPLACE(t-rez, "@¥©α¬―@",    STRING(tt-ope.imp-batch,  GetFieldFmt("¥©α¬―", "xx"))).    

    t-rez = REPLACE(t-rez, "@ §­@",    STRING(IF fake THEN " " ELSE tt-ope.details,   GetFieldFmt(" §­",     "x(30)"))).
    t-rez = REPLACE(t-rez, "@®«@",     STRING(IF fake THEN " " ELSE tt-ope.pol,       GetFieldFmt("®«",      "x(30)"))).
    t-rez = REPLACE(t-rez, "@« β@",    STRING(IF fake THEN " " ELSE tt-ope.pl,        GetFieldFmt("« β",     "x(30)"))).
    t-rez = REPLACE(t-rez, "@®¬„@",    STRING(CountRecord,      GetFieldFmt("®¬„",     ">>>>>9"))).

    t-rez = GetWrapString(t-rez, fake, " §­", tt-ope.details).
    t-rez = GetWrapString(t-rez, fake, "®«",  tt-ope.pol).
    t-rez = GetWrapString(t-rez, fake, "« β", tt-ope.pl).

    t-rez = GetWrapString(t-rez, fake, "‘ηΰ ¨¬", GetAcctName(tt-ope.acct-cr)).
    t-rez = GetWrapString(t-rez, fake, "‘η„΅ ¨¬", GetAcctName(tt-ope.acct-db)).

    t-rez = RIGHT-TRIM(GetExtString(t-rez)).

  END.

  RETURN t-rez.
END FUNCTION.

FUNCTION GetHeadFootString RETURNS CHAR (INPUT aTxt AS CHAR):
  DEFINE VAR t-rez AS CHAR NO-UNDO.

  t-rez = aTxt.

  t-rez = REPLACE(t-rez, "@UserID@", STRING(USERID("bisquit"), GetFieldFmt("UserID", "x(8)"))).
  IF AVAIL _user THEN
    t-rez = REPLACE(t-rez, "@User@",   STRING(_user._user-name,  GetFieldFmt("User",   "x(30)"))).

  t-rez = REPLACE(t-rez, "@„ β @",     STRING(TODAY,   GetFieldFmt("„ β ",    "99/99/9999"))).
  t-rez = REPLACE(t-rez, "@‚ΰ¥¬ο@",    STRING(TIME,    GetFieldFmt("‚ΰ¥¬ο",   "HH:MM:SS"))).

  t-rez = REPLACE(t-rez, "@‡ @",     STRING(fPeriod, GetFieldFmt("‡ ",     "x(30)"))).
  t-rez = REPLACE(t-rez, "@”¨«μβΰ@", STRING(fFilter, GetFieldFmt("”¨«μβΰ", "x(75)"))).
  t-rez = GetString(t-rez, NO).
  t-rez = GetExtString(t-rez).

  RETURN t-rez.
END FUNCTION.

FUNCTION GetSubTotalString RETURNS CHAR (INPUT aTxt AS CHAR, INPUT aFlds AS CHAR, INPUT aGrp AS CHAR):
  DEFINE VAR t-rez AS CHAR NO-UNDO.
  DEFINE VAR i AS INTEGER NO-UNDO.
  DEFINE VAR SummaStr AS CHAR EXTENT 9 NO-UNDO.
  DEFINE VAR t-n       AS INTEGER NO-UNDO.

  t-rez = aTxt.

  FIND FIRST tt-tot WHERE tt-tot.grp = aGrp NO-LOCK NO-ERROR.
  IF AVAIL tt-tot THEN DO:
    DO i = 1 TO NUM-ENTRIES(aFlds):
      t-rez = REPLACE(t-rez, "@ƒΰ." + TRIM(STRING(i, ">>>>9")) + "@",  STRING(DEC(ENTRY(i, tt-tot.val)), GetFieldFmt("ƒΰ." + ENTRY(i, aFlds), "->>>,>>>,>>>,>>9.99"))).
  
      {strval.i "dec(entry(i, tt-tot.val))" SummaStr[1]}
      SUBSTR(SummaStr[1],1,1) = CAPS(SUBSTR(SummaStr[1],1,1)).
      t-n = LENGTH(STRING(FILL("-", 2048), GetFieldFmt("ƒΰ." + ENTRY(i, aFlds), "x(30)"))).
      {wordwrap.i &s=SummaStr &n=9 &l=t-n}
      DO t-n = 1 TO 9:
        t-rez = REPLACE(t-rez, "@ƒΰ" + STRING(t-n, "9") + "." + TRIM(STRING(i, ">>>>9")) + "@", STRING(SummaStr[t-n], GetFieldFmt("ƒΰ." + ENTRY(i, aFlds), "x(30)"))).
      END.

    END.
    t-rez = REPLACE(t-rez, "@ƒΰ.0@", tt-tot.grpr).
    t-rez = REPLACE(t-rez, "@ƒΰ.@", string(tt-tot.cnt, GetFieldFmt("ƒΰ.", ">>>>>9"))).
  END.
  t-rez = GetHeadFootString(t-rez).

  RETURN t-rez.
END FUNCTION.

FUNCTION GetTotalString RETURNS CHAR (INPUT aTxt AS CHAR, INPUT aFlds AS CHAR, INPUT aGrp AS CHAR, INPUT aCnt AS INTEGER, INPUT aVal AS CHAR):
  DEFINE VAR t-rez AS CHAR NO-UNDO.
  DEFINE VAR i AS INTEGER NO-UNDO.
  DEFINE VAR SummaStr AS CHAR EXTENT 9 NO-UNDO.
  DEFINE VAR t-n       AS INTEGER NO-UNDO.

  t-rez = aTxt.

  FIND FIRST tt-tot WHERE tt-tot.grp = aGrp NO-LOCK NO-ERROR.
  IF AVAIL tt-tot THEN DO:
    DO i = 1 TO NUM-ENTRIES(aFlds):
      t-rez = REPLACE(t-rez, "@ƒΰ." + TRIM(STRING(i, ">>>>9")) + "@",  STRING(DEC(ENTRY(i, tt-tot.val)), GetFieldFmt(ENTRY(i, aFlds), "->>>,>>>,>>>,>>9.99"))).
 
      {strval.i "dec(entry(i, tt-tot.val))" SummaStr[1]}
      SUBSTR(SummaStr[1],1,1) = CAPS(SUBSTR(SummaStr[1],1,1)).
      t-n = LENGTH(STRING(FILL("-", 2048), GetFieldFmt("ƒΰ." + ENTRY(i, aFlds), "x(30)"))).
      {wordwrap.i &s=SummaStr &n=9 &l=t-n}
      DO t-n = 1 TO 9:
        t-rez = REPLACE(t-rez, "@ƒΰ" + STRING(t-n, "9") + "." + TRIM(STRING(i, ">>>>9")) + "@", STRING(SummaStr[t-n], GetFieldFmt("ƒΰ." + ENTRY(i, aFlds), "x(30)"))).
      END.

    END.
    t-rez = REPLACE(t-rez, "@ƒΰ.0@", tt-tot.grpr).
    t-rez = REPLACE(t-rez, "@ƒΰ.@", string(tt-tot.cnt, GetFieldFmt("ƒΰ.", ">>>>>9"))).
  END.

  DO i = 1 TO NUM-ENTRIES(aFlds):
    t-rez = REPLACE(t-rez, "@β." + TRIM(STRING(i, ">>>>9")) + "@",  STRING(DEC(ENTRY(i, aVal)), GetFieldFmt(ENTRY(i, aFlds), "->>>,>>>,>>>,>>9.99"))).
  END.
  t-rez = REPLACE(t-rez, "@β.@", string(aCnt, GetFieldFmt("β.", ">>>>>9"))).

  RETURN t-rez.
END FUNCTION.

FUNCTION GetAccum RETURNS CHAR (INPUT aList AS CHAR, INPUT aVal AS CHAR):
  DEFINE VAR i AS INTEGER NO-UNDO.
  DEFINE VAR c AS CHAR NO-UNDO.
  c = aVal.
  DO i = 1 TO NUM-ENTRIES(aList):
    CASE ENTRY(i, aList):
      WHEN "‘γ¬¬ "  THEN ENTRY(i, c) = STRING(DEC(ENTRY(i, c)) + tt-ope.amt-rub).
      WHEN "‘γ¬¬ ‚" THEN ENTRY(i, c) = STRING(DEC(ENTRY(i, c)) + tt-ope.amt-cur).
    END.
  END.
  RETURN c.
END FUNCTION.

PROCEDURE PrintHeader:
  DEFINE VAR rpt-txt AS CHAR NO-UNDO.
  FOR EACH tt-hdr NO-LOCK:
    rpt-txt = GetHeadFootString(tt-hdr.txt).
    IF rpt-txt = "" THEN PUT UNFORMATTED SKIP(1).
                    ELSE PUT UNFORMATTED rpt-txt SKIP.
  END.
END PROCEDURE.

PROCEDURE PrintBody:
  DEFINE VAR rpt-txt AS CHAR NO-UNDO.
  DEFINE VAR t-txt   AS CHAR NO-UNDO.
  FOR EACH tt-bd NO-LOCK:
    rpt-txt = GetString(tt-bd.txt, NO).
    IF tt-bd.txt BEGINS "---" THEN DO:
      t-txt = GetString(tt-bd.txt, YES).
      IF t-txt = rpt-txt THEN NEXT.
    END.
    IF rpt-txt BEGINS "---" THEN rpt-txt = SUBSTR(rpt-txt, 4).
    IF rpt-txt = "" THEN PUT UNFORMATTED SKIP(1).
                    ELSE PUT UNFORMATTED rpt-txt SKIP.
  END.
END PROCEDURE.

PROCEDURE PrintSubTotal:
  DEFINE INPUT PARAMETER aGrp    AS CHAR NO-UNDO.
  DEFINE INPUT PARAMETER aFields AS CHAR NO-UNDO.
  DEFINE VAR rpt-txt AS CHAR NO-UNDO.
  FOR EACH tt-st NO-LOCK:
    rpt-txt = GetSubTotalString(tt-st.txt, aFields, aGrp).
    IF rpt-txt = "" THEN PUT UNFORMATTED SKIP(1).
                    ELSE PUT UNFORMATTED rpt-txt SKIP.
  END.
END PROCEDURE.

PROCEDURE PrintTotal:
  DEFINE INPUT PARAMETER aFields AS CHAR NO-UNDO.
  DEFINE VAR rpt-txt   AS CHAR NO-UNDO.
  DEFINE VAR total-cnt AS INTEGER NO-UNDO.
  DEFINE VAR total-val AS CHAR NO-UNDO.
  DEFINE VAR i         AS INTEGER NO-UNDO.

  total-val = FILL(",", NUM-ENTRIES(aFields) - 1).
  FOR EACH tt-tot:
    total-cnt = total-cnt + tt-tot.cnt.
    DO i = 1 TO NUM-ENTRIES(aFields):
      ENTRY(i, total-val) = STRING(DEC(ENTRY(i, total-val)) + DEC(ENTRY(i, tt-tot.val))).
    END.
  END.
  
  FOR EACH tt-tt NO-LOCK:
    IF tt-tt.txt BEGINS "+++" THEN
      FOR EACH tt-tot USE-INDEX i-grp NO-LOCK:
        rpt-txt = GetTotalString(SUBSTR(tt-tt.txt, 4), aFields, tt-tot.grp, total-cnt, total-val).
        IF rpt-txt = "" THEN PUT UNFORMATTED SKIP(1).
                        ELSE PUT UNFORMATTED rpt-txt SKIP.
      END.
    ELSE DO:
      rpt-txt = GetTotalString(tt-tt.txt, aFields, ?, total-cnt, total-val).
      IF rpt-txt = "" THEN PUT UNFORMATTED SKIP(1).
                      ELSE PUT UNFORMATTED rpt-txt SKIP.
    END.
  END.
END PROCEDURE.

PROCEDURE PrintFooter:
  DEFINE VAR rpt-txt AS CHAR NO-UNDO.
  FOR EACH tt-ftr NO-LOCK:
    rpt-txt = GetHeadFootString(tt-ftr.txt).
    IF rpt-txt = "" THEN PUT UNFORMATTED SKIP(1).
                    ELSE PUT UNFORMATTED rpt-txt SKIP.
  END.
END PROCEDURE.
&ENDIF
