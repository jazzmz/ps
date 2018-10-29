FUNCTION PirGetUserName RETURNS CHARACTER (INPUT iUserID AS CHARACTER):   
DEFINE BUFFER bUser FOR _user.   
  FIND FIRST bUser   WHERE bUser._userid EQ iUserID NO-LOCK NO-ERROR.   
      RETURN (IF AVAILABLE bUser 
	THEN              bUser._User-Name           
        ELSE              "®«ì§®¢ â¥«ì ­¥ ­ ©¤¥­").

END FUNCTION.



PROCEDURE CalcTotals PRIVATE.
    DEFINE INPUT PARAMETER iCAcct LIKE tt-header.acct.

    FOR EACH tt-totals-rec
    WHERE
        tt-totals-rec.c-acct = iCAcct
    EXCLUSIVE-LOCK:
        DELETE tt-totals-rec.
    END.

    FOR EACH tt-journal-rec
    WHERE
        tt-journal-rec.c-acct = iCAcct
    BREAK BY tt-journal-rec.symbol:
        ACCUMULATE
            tt-journal-rec.amt     (SUB-TOTAL BY tt-journal-rec.symbol)
            tt-journal-rec.alt-amt (SUB-TOTAL BY tt-journal-rec.symbol)
        .
        IF LAST-OF(tt-journal-rec.symbol) THEN DO:
            CREATE tt-totals-rec.
            ASSIGN
                tt-totals-rec.c-acct  = iCAcct
                tt-totals-rec.amt     = ACCUM SUB-TOTAL BY tt-journal-rec.symbol tt-journal-rec.amt
                tt-totals-rec.symbol  = tt-journal-rec.symbol
                tt-totals-rec.alt-amt = ACCUM SUB-TOTAL BY tt-journal-rec.symbol tt-journal-rec.alt-amt
		
            .
        END.
    END.
END PROCEDURE.





PROCEDURE PirCalcTotals PRIVATE.
    DEFINE INPUT PARAMETER iCAcct LIKE tt-header.acct.

    FOR EACH tt-pirtotals-rec
    WHERE
        tt-pirtotals-rec.c-acct = iCAcct
    EXCLUSIVE-LOCK:
        DELETE tt-pirtotals-rec.
    END.

    FOR EACH tt-journal-rec
    WHERE
        tt-journal-rec.c-acct = iCAcct
    BREAK BY tt-journal-rec.user-insp:
        ACCUMULATE
            tt-journal-rec.amt     (SUB-TOTAL BY tt-journal-rec.user-insp)
            tt-journal-rec.alt-amt (SUB-TOTAL BY tt-journal-rec.user-insp)
        .
        IF LAST-OF(tt-journal-rec.user-insp) THEN DO:
            CREATE tt-pirtotals-rec.
            ASSIGN
                tt-pirtotals-rec.c-acct  = iCAcct
                tt-pirtotals-rec.amt     = ACCUM SUB-TOTAL BY tt-journal-rec.user-insp tt-journal-rec.amt
                tt-pirtotals-rec.user-insp  = tt-journal-rec.user-insp
                tt-pirtotals-rec.alt-amt = IF mKurs THEN
		(ACCUM SUB-TOTAL BY tt-journal-rec.user-insp tt-journal-rec.alt-amt)
		ELSE 0
            .
        END.
    END.
END PROCEDURE.





PROCEDURE CalcOverall PRIVATE.
    DEFINE INPUT PARAMETER iCAcct LIKE tt-header.acct.

    DEFINE OUTPUT PARAMETER oAmt    LIKE tt-totals-rec.amt.
    DEFINE OUTPUT PARAMETER oAltAmt LIKE tt-totals-rec.alt-amt.

    IF NOT CAN-FIND(FIRST tt-totals-rec
                    WHERE
                        tt-totals-rec.c-acct = iCAcct)
    THEN
        RUN CalcTotals(iCAcct).
    FOR EACH tt-totals-rec
    WHERE
        tt-totals-rec.c-acct = iCAcct
    NO-LOCK:
        ACCUMULATE
            tt-totals-rec.amt     (TOTAL)
            tt-totals-rec.alt-amt (TOTAL)
        .
    END.
    ASSIGN
        oAmt    = ACCUM TOTAL tt-totals-rec.amt
        oAltAmt = IF mKurs THEN (ACCUM TOTAL tt-totals-rec.alt-amt) ELSE 0
    .
END PROCEDURE.

FUNCTION Just RETURN CHARACTER (INPUT s AS CHARACTER):
    IF s = ? THEN
        RETURN "".
    RETURN s.
END FUNCTION.

PROCEDURE PutStr PRIVATE.
    DEFINE INPUT PARAMETER iStr AS CHARACTER.

    PUT {&stream} UNFORMATTED Just(iStr).
END PROCEDURE.

PROCEDURE PutStrLn PRIVATE.
    DEFINE INPUT PARAMETER iStr AS CHARACTER.

    RUN PutStr(Just(iStr) + "~n").
END PROCEDURE.

PROCEDURE PrintTableHeader PRIVATE.
    RUN PutStrLn("ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿").
    RUN PutStrLn("³ ü ª áá®¢®£® ³      ®¬¥à  áç¥â®¢       ³ ˜¨äà  ³      ‘ã¬¬       ³ ‘¨¬¢®« ¯® ³   à¨¬¥ç ­¨¥    ³").
    RUN PutStrLn("³  ¤®ªã¬¥­â   ³                          ³ ¤®ªã- ³                 ³  áâ âì¥   ³                 ³").
    RUN PutStrLn("³             ³                          ³ ¬¥­â  ³                 ³  " + STRING(tt-header.type + " ","x(9)") + "³                 ³").
END PROCEDURE.

PROCEDURE PrintTableSeparator PRIVATE.
    RUN PutStrLn("ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´").
END PROCEDURE.

PROCEDURE PrintTableBottom PRIVATE.
    RUN PutStrLn("ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´").
END PROCEDURE.


PROCEDURE PrintPirTableBottom PRIVATE.
    RUN PutStrLn("ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´").
END PROCEDURE.




PROCEDURE PrintTotalsSeparator PRIVATE.
    RUN PutStrLn("³                                                ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´").
END PROCEDURE.

PROCEDURE PrintTotalsBottom PRIVATE.
    RUN PutStrLn("ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ").
END PROCEDURE.

FUNCTION spc RETURN CHARACTER (INPUT n AS INT64):
    IF n < 1 THEN
        RETURN "".
    RETURN FILL(" ", n).
END FUNCTION.

FUNCTION pad RETURN CHARACTER (INPUT s AS CHARACTER):
    RETURN " " + Just(s) + " ".
END FUNCTION.

FUNCTION formatAmt RETURN CHARACTER (INPUT x AS DECIMAL):
    RETURN STRING(STRING(100 * x, "-zzzzzzzzzz999"),
                  IF TRUNCATE(x, 0) = x THEN
                      "  x(12)="
                  ELSE
                      "x(12)-xx").
END FUNCTION.

FUNCTION reprAmt RETURN CHARACTER (INPUT x AS DECIMAL):
    IF x = 0 THEN
        RETURN spc(15).
    RETURN formatAmt(x).
END FUNCTION.

PROCEDURE PrintTableRow PRIVATE.
    DEFINE PARAMETER BUFFER b-tt     FOR tt-journal-rec.
    DEFINE INPUT PARAMETER  iPrintCS AS  LOGICAL.

    DEFINE VARIABLE vAcct     LIKE acct.acct     NO-UNDO.
    DEFINE VARIABLE vCurrency LIKE acct.currency NO-UNDO.

    vAcct = b-tt.acct.
    vCurrency = SUBSTRING(vAcct, 6, 3).
    IF vCurrency = FGetSetting("Š®¤ æ‚ «", ?, "810") THEN
        vCurrency = "".
    {find-act.i &acct = vAcct
                &curr = vCurrency}
    IF AVAILABLE acct THEN
        vAcct = STRING(vAcct, GetAcctFmt(acct.acct-cat)).
    IF NOT AVAIL b-tt THEN
        RETURN.
    
IF NOT mKurs THEN  b-tt.alt-amt = 0.

    RUN PutStr("³" + pad(STRING(b-tt.doc-num , "x(11)"))).
    RUN PutStr("³" + pad(vAcct)).
    RUN PutStr("³" + spc(1) + pad(STRING(b-tt.doc-code, "xx")) + spc(2)).
    RUN PutStr("³" + pad(reprAmt(b-tt.amt))).
    RUN PutStr("³" + spc(4) + pad(STRING(IF iPrintCS THEN b-tt.symbol ELSE "", "xx")) + spc(3)).
    RUN PutStr("³" + pad(reprAmt(b-tt.alt-amt))).
    RUN PutStrLn("³").
END PROCEDURE.

PROCEDURE PrintTotalsRow PRIVATE.
    DEFINE PARAMETER BUFFER b-tt     FOR tt-totals-rec.
    DEFINE INPUT PARAMETER  iText    AS  CHARACTER.
    DEFINE INPUT PARAMETER  iPrintCS AS  LOGICAL.

    IF NOT AVAIL b-tt THEN
        RETURN.
    RUN PrintTotalsRow0(b-tt.amt,
                        IF iPrintCS THEN b-tt.symbol ELSE "",
                        b-tt.alt-amt,
                        iText).
END PROCEDURE.

PROCEDURE PrintPirTotalsRow PRIVATE.
    DEFINE PARAMETER BUFFER b-tt     FOR tt-pirtotals-rec.
    DEFINE INPUT PARAMETER  iText    AS  CHARACTER.
    DEFINE INPUT PARAMETER  iUser-insp LIKE tt-pirtotals-rec.user-insp.

    IF NOT AVAIL b-tt THEN
        RETURN.
      

    RUN PutStr("³" + pad(STRING(iText, "x(16)"))).
    RUN PutStr( STRING(PirGetUserName(iUser-insp),"X(30)") ).    
    RUN PutStr("³" + pad(reprAmt(b-tt.amt)) ).
    RUN PutStr("³           "  ).
    RUN PutStr("³" + pad(reprAmt(b-tt.alt-amt))).
    RUN PutStrLn("³").
END PROCEDURE.




PROCEDURE PrintOverall PRIVATE.
    DEFINE INPUT PARAMETER iAmt    LIKE tt-totals-rec.amt.
    DEFINE INPUT PARAMETER iAltAmt LIKE tt-totals-rec.alt-amt.
    DEFINE INPUT PARAMETER iText   AS   CHARACTER.

    RUN PrintTotalsRow0(iAmt, "", iAltAmt, iText).
END PROCEDURE.

PROCEDURE PrintTotalsRow0 PRIVATE.
    DEFINE INPUT PARAMETER iAmt    LIKE tt-totals-rec.amt.
    DEFINE INPUT PARAMETER iSymbol LIKE tt-totals-rec.symbol.
    DEFINE INPUT PARAMETER iAltAmt LIKE tt-totals-rec.alt-amt.
    DEFINE INPUT PARAMETER iText   AS   CHARACTER.

    RUN PutStr("³" + pad(STRING(iText, "x(46)"))).
    RUN PutStr("³" + pad(reprAmt(iAmt))).
    RUN PutStr("³" + spc(4) + pad(STRING(iSymbol, "xx")) + spc(3)).
    RUN PutStr("³" + pad(reprAmt(iAltAmt))).
    RUN PutStrLn("³").
END PROCEDURE.




/*
PROCEDURE PrintPirTotalsRow0 PRIVATE.
    DEFINE INPUT PARAMETER iAmt    LIKE tt-totals-rec.amt.
    DEFINE INPUT PARAMETER iUser-insp LIKE tt-pirtotals-rec.user-insp.
    DEFINE INPUT PARAMETER iAltAmt LIKE tt-totals-rec.alt-amt.
    DEFINE INPUT PARAMETER iText   AS   CHARACTER.

    RUN PutStr("³" + pad(STRING(iText, "x(46)"))).
    RUN PutStr("³" + pad(reprAmt(iAmt))).
    RUN PutStr("³" + spc(4) + iUser-insp + spc(3) ).
    RUN PutStr("³" + pad(reprAmt(iAltAmt))).
    RUN PutStrLn("³").
END PROCEDURE.
*/




FUNCTION getJournalTypeStr RETURN CHARACTER (INPUT iJournalType AS CHARACTER):
    RETURN "¯® " + iJournalType + "ã".
END FUNCTION.

PROCEDURE PrintReportHeader PRIVATE.
    DEFINE PARAMETER BUFFER b-tt FOR tt-header.

    DEFINE VARIABLE vAuthor AS CHARACTER EXTENT 3 NO-UNDO.

    IF NOT AVAIL b-tt THEN
        RETURN.
    {find-act.i &acct = b-tt.acct
                &curr = b-tt.currency}
    IF NOT AVAIL acct THEN
        RETURN.
    vAuthor[1] = b-tt.author.
    {wordwrap.i &s = vAuthor
                &n = 3
                &l = 72}

/*PIR begin*/    
    IF nightkas THEN
    PUT {&stream} UNFORMATTED
	"                                                  ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿ ~n"
	"                                                  ³   ¡á«ã¦¨¢ ­¨¥    ³ ~n"
	"                                                  ³¢ ¯®á«¥®¯¥à æ¨®­­®¥³ ~n"
	"                                                  ³      ¢à¥¬ï        ³ ~n"
	"                                                  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ ~n"
	"~n"
    SKIP.
/*PIR end*/    


    PUT {&stream} UNFORMATTED
        "                                                           ÚÄÄÄÄÄÄÄÄÄÄÄ¿~n"
        "                                                           ³  " b-tt.form-code FORMAT "x(7)" "  ³~n"
        "                                                           ÀÄÄÄÄÄÄÄÄÄÄÄÙ~n"
        " " vAuthor[1] FORMAT "x(72)" " ~n"
        " " vAuthor[2] FORMAT "x(72)" " ~n"
        " " vAuthor[3] FORMAT "x(72)" " ~n"
        " ‘®áâ ¢¨â¥«ì                                     Š áá®¢ë© ¦ãà­ «~n"
        "                                                   " getJournalTypeStr(b-tt.type) "~n"
        "~n"
        "                                                   " STRING(b-tt.date, "99.99.9999") "~n"
        "                                                  ÄÄÄÄÄÄÄÄÄÄÄÄ~n"
        "                                                      „ â ~n"
    .
    RUN PutStrLn(?).
    RUN PutStrLn(" ‘ç¥â ¯® ãç¥âã ª ááë ü " + STRING(acct.acct, GetAcctFmt(acct.acct-cat))).
    IF b-tt.currency <> "" THEN
        RUN PutStrLn(" Š®¤ ¢ «îâë: " + GetISOCode(b-tt.currency)).
    RUN PutStrLn(?).
END PROCEDURE.

PROCEDURE PrintSignatures PRIVATE.
    {signatur.i}
END PROCEDURE.

FUNCTION getCSType RETURN CHARACTER (INPUT iJournalType AS CHARACTER):
    RETURN CAPS(SUBSTRING(iJournalType, 1, 1)) + SUBSTRING(iJournalType, 2, 3).
END FUNCTION.

FUNCTION concat RETURN CHARACTER (INPUT l AS CHARACTER, INPUT e AS CHARACTER):
    IF {assigned l} THEN
        RETURN l + "," + e.
    RETURN e.
END FUNCTION.

PROCEDURE PrintReport PRIVATE.
    DEFINE PARAMETER BUFFER b-tt        FOR tt-header.
    DEFINE INPUT PARAMETER  iTotalsByCS AS  LOGICAL.

    DEFINE VARIABLE vAmt         LIKE tt-totals-rec.amt     NO-UNDO.
    DEFINE VARIABLE vAltAmt      LIKE tt-totals-rec.alt-amt NO-UNDO.
    DEFINE VARIABLE vTotalsStr   AS   CHARACTER             NO-UNDO.
    DEFINE VARIABLE vCSType      AS   CHARACTER             NO-UNDO.
    DEFINE VARIABLE vValidCSList AS   CHARACTER INITIAL ""  NO-UNDO.

    vCSType = getCSType(b-tt.type).
    FOR EACH tmp-code
    WHERE
        tmp-code.class    =  "Š á‘¨¬¢®«ë" AND
        tmp-code.beg-date <= b-tt.date    AND
        (tmp-code.end-date = ?       OR
         tmp-code.end-date > b-tt.date)   AND
        (NOT {assigned tmp-code.val} OR
         tmp-code.val = vCSType)
    NO-LOCK:
        vValidCSList = concat(vValidCSList, tmp-code.code).
    END.

    IF iTotalsByCS THEN
        RUN CalcTotals(b-tt.acct).
    ELSE
        RUN CalcOverall(b-tt.acct, OUTPUT vAmt, OUTPUT vAltAmt).
    
    
        RUN PirCalcTotals(b-tt.acct).
    
    vTotalsStr = "ˆâ®£® " + getJournalTypeStr(b-tt.type) + ":".
    RUN PrintReportHeader(BUFFER b-tt).
    RUN PrintTableHeader.
    FOR EACH tt-journal-rec
    WHERE
        tt-journal-rec.c-acct = b-tt.acct
    NO-LOCK:
        RUN PrintTableSeparator.
        RUN PrintTableRow(BUFFER tt-journal-rec,
                          CAN-DO(vValidCSList, tt-journal-rec.symbol)).
    END.
    RUN PrintTableBottom.
    
    
/*PIR*/     
        FOR EACH tt-pirtotals-rec
        WHERE
            tt-pirtotals-rec.c-acct = b-tt.acct
        NO-LOCK:
            IF vTotalsStr = "" THEN
                RUN PrintTotalsSeparator.
            ELSE DO:
                RUN PrintPirTotalsRow(BUFFER tt-pirtotals-rec,
                                   vTotalsStr,
                                   tt-pirtotals-rec.user-insp).
                vTotalsStr = "".
                NEXT.
            END.
            RUN PrintPirTotalsRow(BUFFER tt-pirtotals-rec,
                               vTotalsStr,
                               tt-pirtotals-rec.user-insp).
        END.
	
vTotalsStr = "‚á¥£® ".
RUN PrintPirTableBottom.

/*PIR END*/
    
    
    
    
    IF iTotalsByCS THEN DO:
        FOR EACH tt-totals-rec
        WHERE
            tt-totals-rec.c-acct = b-tt.acct
        NO-LOCK:
            IF vTotalsStr = "" THEN
                RUN PrintTotalsSeparator.
            ELSE DO:
                RUN PrintTotalsRow(BUFFER tt-totals-rec,
                                   vTotalsStr,
                                   CAN-DO(vValidCSList, tt-totals-rec.symbol)).
                vTotalsStr = "".
                NEXT.
            END.
            RUN PrintTotalsRow(BUFFER tt-totals-rec,
                               vTotalsStr,
                               CAN-DO(vValidCSList, tt-totals-rec.symbol)).
        END.
    END.
    ELSE
        RUN PrintOverall(vAmt, vAltAmt, vTotalsStr).
    RUN PrintTotalsBottom.
    RUN PrintSignatures.
END PROCEDURE.
