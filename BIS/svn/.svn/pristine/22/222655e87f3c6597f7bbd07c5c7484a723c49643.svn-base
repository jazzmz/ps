{pirsavelog.p}

/** 
 * Žâç¥â ¨á¯®«ì§ã¥âáï ¤«ï ¯à®¢¥àª¨ ª®àà¥ªâ­®áâ¨ à áç¥â  ä.250 à.1 
 * 
 * …à¬¨«®¢ ‚..
 * ??/01/2010 
 */



DEFINE VAR all_amt AS DEC INITIAL 0 NO-UNDO.
DEFINE VAR all_count AS DEC INITIAL 0 NO-UNDO.

{globals.i}
{getdates.i}
{setdest.i}

PUT UNFORMATTED "   à®¢¥àª  ä®à¬ë 250 §  ¯¥à¨®¤ á " beg-date " ¯® " end-date "."  SKIP(2).

PUT UNFORMATTED "’¨¯ ®¯¥à æ¨©   ‘ã¬¬  ®¯¥à æ¨©  Š®«-¢® "   SKIP(1). 

/* ‘Ÿ’ˆ… €‹ */ 
FOR EACH pc-trans WHERE pc-trans.processing = 'UCS' AND pc-trans.proc-date GE beg-date AND pc-trans.proc-date LE end-date and CAN-DO('‘­ïâ¨¥ «*',pc-trans.pctr-code) AND pc-trans.pctr-status = 'Ž' :
   DO:
    FIND FIRST pc-trans-amt WHERE pc-trans-amt.pctr-id = pc-trans.pctr-id AND   pc-trans-amt.amt-code = '€‘—'  NO-LOCK NO-ERROR .
      IF AVAIL  pc-trans-amt THEN
          DO:                          
            FIND FIRST instr-rate where rate-type = '“ç¥â­ë©' and instr-code = pc-trans-amt.currency and since = pc-trans.proc-date NO-ERROR .              
            IF AVAIL instr-rate THEN   
              DO: 
               all_amt=all_amt + pc-trans-amt.amt-cur * instr-rate.rate-instr .
               all_count=all_count + 1.
              END.
            ELSE
              DO:
               all_amt=all_amt + pc-trans-amt.amt-cur  .
               all_count=all_count + 1.      
               
              END. 
          END.                  
    END.
END.
PUT UNFORMATTED '‘­ïâ¨¥ «   ' all_amt FORMAT '->,>>>,>>>,>>9.99' '  '  all_count SKIP. 
ASSIGN all_amt = 0 all_count = 0 . 

/*‚Ž‡‚€’ €‹*/                             
FOR EACH pc-trans WHERE pc-trans.processing = 'UCS' AND pc-trans.proc-date GE beg-date AND ~ pc-trans.proc-date LE end-date and CAN-DO('‚®§¢à â «*',pc-trans.pctr-code)  AND pc-trans.pctr-status = 'Ž' :
   DO:
    FIND FIRST pc-trans-amt WHERE pc-trans-amt.pctr-id = pc-trans.pctr-id AND   pc-trans-amt.amt-code = '€‘—'  NO-LOCK NO-ERROR .
      IF AVAIL  pc-trans-amt THEN
          DO:                          
            FIND FIRST instr-rate where rate-type = '“ç¥â­ë©' and instr-code = pc-trans-amt.currency and since = pc-trans.proc-date NO-ERROR .              
            IF AVAIL instr-rate THEN   
              DO: 
               all_amt=all_amt + pc-trans-amt.amt-cur * instr-rate.rate-instr .
               all_count=all_count + 1.
              END.
            ELSE
              DO:
               all_amt=all_amt + pc-trans-amt.amt-cur  .
               all_count=all_count + 1. 
              END. 
          END.                  
    END.
END.
PUT UNFORMATTED '‚®§¢à â «  ' all_amt FORMAT '->,>>>,>>>,>>9.99' '  '    all_count SKIP. 
ASSIGN all_amt = 0 all_count = 0.

/*Ž¯« â */                             
FOR EACH pc-trans WHERE pc-trans.processing = 'UCS' AND pc-trans.proc-date GE beg-date AND pc-trans.proc-date LE end-date and CAN-DO('Ž¯« â *',pc-trans.pctr-code)  AND pc-trans.pctr-status = 'Ž':
   DO:
    FIND FIRST pc-trans-amt WHERE pc-trans-amt.pctr-id = pc-trans.pctr-id AND   pc-trans-amt.amt-code = '€‘—'  NO-LOCK NO-ERROR .
      IF AVAIL  pc-trans-amt THEN
          DO:                          
            FIND FIRST instr-rate where rate-type = '“ç¥â­ë©' and instr-code = pc-trans-amt.currency and since = pc-trans.proc-date NO-ERROR .              
            IF AVAIL instr-rate THEN   
              DO: 
               all_amt=all_amt + pc-trans-amt.amt-cur * instr-rate.rate-instr .
               all_count=all_count + 1.
              END.
            ELSE
              DO:
               all_amt=all_amt + pc-trans-amt.amt-cur  .
               all_count=all_count + 1. 
              END. 
          END.                  
    END.
END.
PUT UNFORMATTED 'Ž¯« â       ' all_amt FORMAT '->,>>>,>>>,>>9.99' '  '  all_count SKIP. 
ASSIGN all_amt = 0 all_count = 0.

/*‚®§¢à âŽ¯«*/
FOR EACH pc-trans WHERE pc-trans.processing = 'UCS' AND pc-trans.proc-date GE beg-date AND pc-trans.proc-date LE end-date and CAN-DO('‚®§¢à âŽ¯«*',pc-trans.pctr-code)  AND pc-trans.pctr-status = 'Ž' :
   DO:
    FIND FIRST pc-trans-amt WHERE pc-trans-amt.pctr-id = pc-trans.pctr-id AND   pc-trans-amt.amt-code = '€‘—'  NO-LOCK NO-ERROR .
      IF AVAIL  pc-trans-amt THEN
          DO:                          
            FIND FIRST instr-rate where rate-type = '“ç¥â­ë©' and instr-code = pc-trans-amt.currency and since = pc-trans.proc-date NO-ERROR .              
            IF AVAIL instr-rate THEN   
              DO: 
               all_amt=all_amt + pc-trans-amt.amt-cur * instr-rate.rate-instr .
               all_count=all_count + 1.
              END.
            ELSE
              DO:
               all_amt=all_amt + pc-trans-amt.amt-cur  .
               all_count=all_count + 1. 
              END. 
          END.                  
    END.
END.
PUT UNFORMATTED '‚®§¢à âŽ¯«  ' all_amt FORMAT '->,>>>,>>>,>>9.99' '  '  all_count SKIP. 





/* ‘Ÿ’ˆ… ‚ */ 
FOR EACH pc-trans WHERE pc-trans.processing = 'UCS' AND pc-trans.proc-date GE beg-date AND pc-trans.proc-date LE end-date and CAN-DO('‘­ïâ¨¥‚*',pc-trans.pctr-code) AND pc-trans.pctr-status = 'Ž' :
   DO:
    FIND FIRST pc-trans-amt WHERE pc-trans-amt.pctr-id = pc-trans.pctr-id AND   pc-trans-amt.amt-code = '€‘—'  NO-LOCK NO-ERROR .
      IF AVAIL  pc-trans-amt THEN
          DO:                          
            FIND FIRST instr-rate where rate-type = '“ç¥â­ë©' and instr-code = pc-trans-amt.currency and since = pc-trans.proc-date NO-ERROR .              
            IF AVAIL instr-rate THEN   
              DO: 
               all_amt=all_amt + pc-trans-amt.amt-cur * instr-rate.rate-instr .
               all_count=all_count + 1.
              END.
            ELSE
              DO:
               all_amt=all_amt + pc-trans-amt.amt-cur  .
               all_count=all_count + 1.      
               
              END. 
          END.                  
    END.
END.
PUT UNFORMATTED '‘­ïâ¨¥‚   ' all_amt FORMAT '->,>>>,>>>,>>9.99' '  '  all_count SKIP. 
ASSIGN all_amt = 0 all_count = 0 . 

/*‚Ž‡‚€’ ‚*/                             
FOR EACH pc-trans WHERE pc-trans.processing = 'UCS' AND pc-trans.proc-date GE beg-date AND ~ pc-trans.proc-date LE end-date and CAN-DO('‚®§¢à â‚*',pc-trans.pctr-code)  AND pc-trans.pctr-status = 'Ž' :
   DO:
    FIND FIRST pc-trans-amt WHERE pc-trans-amt.pctr-id = pc-trans.pctr-id AND   pc-trans-amt.amt-code = '€‘—'  NO-LOCK NO-ERROR .
      IF AVAIL  pc-trans-amt THEN
          DO:                          
            FIND FIRST instr-rate where rate-type = '“ç¥â­ë©' and instr-code = pc-trans-amt.currency and since = pc-trans.proc-date NO-ERROR .              
            IF AVAIL instr-rate THEN   
              DO: 
               all_amt=all_amt + pc-trans-amt.amt-cur * instr-rate.rate-instr .
               all_count=all_count + 1.
              END.
            ELSE
              DO:
               all_amt=all_amt + pc-trans-amt.amt-cur  .
               all_count=all_count + 1. 
              END. 
          END.                  
    END.
END.
PUT UNFORMATTED '‚®§¢à â‚  ' all_amt FORMAT '->,>>>,>>>,>>9.99' '  '    all_count SKIP. 
ASSIGN all_amt = 0 all_count = 0.









{preview.i}
