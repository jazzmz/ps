{pirsavelog.p}

/** 
 *
 * Выгрузка для программы анализ количества кредитных и дебетовых пластиковых карт с разбивкой по валютам
 * Ермилов В.Н.
 * 31/03/2010 
 *
 **/
 

DEFINE VAR count_rub_d_card AS INT NO-UNDO.
DEFINE VAR count_rub_k_card AS INT NO-UNDO.
DEFINE VAR count_rub_all_card AS INT NO-UNDO.

DEFINE VAR count_val_d_card AS INT NO-UNDO. 
DEFINE VAR count_val_k_card AS INT NO-UNDO.
DEFINE VAR count_val_all_card AS INT NO-UNDO.

DEFINE VAR deb_kart AS INT NO-UNDO.
DEFINE VAR kred_kart AS INT NO-UNDO.

DEFINE BUFFER cloan FOR loan.


{globals.i}

OUTPUT TO VALUE("/home2/bis/quit41d/imp-exp/doc/analiz/DCARD_" + STRING(DAY(TODAY),"99") + STRING(MONTH(TODAY),"99")  + STRING(YEAR(TODAY)) + ".NEW").

ASSIGN count_rub_d_card = 0  count_rub_k_card = 0 count_val_d_card = 0  count_val_k_card = 0 deb_kart = 0  kred_kart = 0 .

FOR EACH cloan WHERE cloan.contract = 'card' 
    AND CAN-DO('АКТ,ЗВЛ,ИЗГ',cloan.loan-status) 
    AND cloan.open-date <= TODAY     
    AND ( cloan.end-date > TODAY OR cloan.end-date = ? )
NO-LOCK
:


    FIND FIRST loan WHERE loan.contract = 'card-pers'
            /*AND CAN-DO('*',loan.loan-status)*/
              AND loan.cont-code = cloan.parent-cont-code  NO-LOCK NO-ERROR .

    if NOT AVAILABLE loan THEN                                                /*Такой чудодейственный костыль сделан из-за того что при объединении условий отбора по loan.contract ловим нереальные торможения.*/
    FIND FIRST loan WHERE loan.contract = 'card-corp' 
            /*AND CAN-DO('*',loan.loan-status)*/
              AND loan.cont-code = cloan.parent-cont-code  NO-LOCK NO-ERROR .

              
    IF NOT AVAIL loan THEN message 'baga! not found dogovor of plcard ' VIEW-AS ALERT-BOX.
    ELSE 
        DO:
        FIND LAST loan-cond WHERE loan-cond.contract = loan.contract AND
          loan-cond.cont-code = loan.cont-code   NO-LOCK NO-ERROR. 
        IF NOT AVAIL loan-cond THEN message ' not found loan-cond ' VIEW-AS ALERT-BOX.
        ELSE
            DO:

            /*PUT UNFORMATTED '| ' cloan.doc-num ' | ' cloan.loan-status ' | ' cloan.user-o[2] FORMAT 'X(15)' ' | '  loan.cont-code ' | '  loan-cond.class-code FORMAT 'X(10)'  ' | '        SKIP. */
      
                IF CAN-DO('RUR_Овер,USD_Овер,EUR_Овер',loan-cond.class-code) THEN
		    DO:
	           /* PUT UNFORMATTED '| ' cloan.doc-num ' | ' cloan.loan-status ' | ' cloan.user-o[2] FORMAT 'X(15)' ' | '  loan.cont-code ' | '  loan-cond.class-code FORMAT 'X(10)'  ' | '        SKIP. */ 
                    IF loan.currency = '' THEN
                        count_rub_k_card = count_rub_k_card + 1 .
                    ELSE 
                        count_val_k_card = count_val_k_card + 1 .
		    END.
                ELSE
                    
                    IF loan.currency = '' THEN
                        count_rub_d_card = count_rub_d_card + 1 .
                    ELSE 
                        count_val_d_card = count_val_d_card + 1 .
                .        
                
                

            END. /*avail of loan-cond*/            
                
        END. /*avail of loan*/
    




END. /*for each card*/



/** 2ой алгоритм определения кредитных карт (вместо условия запускается поиск кредитного договора) **/

/****

FOR EACH cloan WHERE cloan.contract = 'card' 
    AND cloan.parent-contract = 'card-pers'
    AND CAN-DO('АКТ,ЗВЛ,ИЗГ',cloan.loan-status) 
    AND cloan.open-date <= TODAY     
    AND cloan.end-date > TODAY
  AND cloan.doc-num = '4237390003008663'
    NO-LOCK
:


    FIND FIRST loan WHERE CAN-DO('card-pers,card-corp',loan.contract)
              AND CAN-DO('*',loan.loan-status)
              AND loan.cont-code = cloan.parent-cont-code NO-LOCK.
              
    IF NOT AVAIL loan THEN message 'baga! not found dogovor of plcard ' VIEW-AS ALERT-BOX.
    ELSE 
        DO:
        
        FIND FIRST loan-acct WHERE loan-acct.contract = loan.contract 
            AND loan-acct.cont-code = loan.cont-code
            AND loan-acct.acct-type = 'SCS@' + loan.currency
            NO-LOCK
            .
        IF NOT AVAIL loan-acct THEN 
        DO:
            MESSAGE 'Global warning !! No loan-acct SCS ' loan.cont-code  VIEW-AS ALERT-BOX.
        END.    
                                                    
                 
        FOR FIRST kloan-acct  WHERE kloan-acct.acct-type = 'КредРасч'
                    AND kloan-acct.acct = loan-acct.acct
                    AND kloan-acct.contract = 'Кредит'   
        NO-LOCK ,                              
            
        FIRST kloan WHERE kloan.contract = kloan-acct.contract 
                    AND kloan.cont-code = kloan-acct.cont-code
                    AND kloan.class-code = 'l_agr_with_per'
                    AND kloan.cust-cat = loan.cust-cat     
                    AND kloan.cust-id = loan.cust-id         
                    AND (kloan.end-date = ? OR kloan.end-date > TODAY )
        NO-LOCK                 
        :   
                    
            PUT UNFORMATTED '| ' cloan.doc-num ' | ' cloan.loan-status ' | ' cloan.user-o[2] FORMAT 'X(15)' ' | '  loan.cont-code ' | ' /* loan-cond.class-code FORMAT 'X(10)'  ' | ' */  kloan-acct.acct ' | ' kloan.cont-code ' | ' kloan.loan-status ' | ' kloan.open-date ' | ' kloan.end-date ' | ' kloan.close-date   SKIP. 
                                                  
                    IF loan.currency = '' THEN 
                    count_rub_k_card = count_rub_k_card + 1 . 
                    ELSE 
                    count_val_k_card = count_val_k_card + 1
                    .
                    END.   
        . 
                
        END.                
    
END. 


2ой алгоритм расчета ****/




ASSIGN
    count_rub_all_card = count_rub_d_card + count_rub_k_card
    count_val_all_card = count_val_d_card + count_val_k_card
.    



PUT UNFORMATTED ';Название            Дата                  Кол-во руб.       Кол-во вал. '  SKIP.
PUT UNFORMATTED 'Кол-во_карт         ' TODAY '               ' count_rub_all_card ~ '           '  count_val_all_card SKIP.
PUT UNFORMATTED 'Кол-во_карт_Д       ' TODAY '               ' count_rub_d_card ' ~          '  count_val_d_card SKIP.
PUT UNFORMATTED 'Кол-во_карт_К       ' TODAY '               ' count_rub_k_card ' ~           '  count_val_k_card SKIP.


/* PUT UNFORMATTED kred_kart deb_kart SKIP. */

OUTPUT CLOSE.
    
/*{preview.i}*/ 