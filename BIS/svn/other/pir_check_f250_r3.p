{pirsavelog.p}

/** 
 * �� �� �� �11 �� 29.03.2010�.
 * � �裡 � �⪠��� �� �����ᨨ � ������������ ���� ���ਭ����� ����権 �࠭���権 � �.250 �.3 ���ॡ������ ����� ����.
 * 
 * �ନ��� �.�.
 * 02/04/2010 
 */

DEFINE VAR our_card_amount AS DEC  NO-UNDO.
DEFINE VAR our_card_count  AS DEC  NO-UNDO.

DEFINE VAR rus_card_amount AS DEC  NO-UNDO.
DEFINE VAR rus_card_count  AS DEC  NO-UNDO.

DEFINE VAR forr_card_amount AS DEC  NO-UNDO.
DEFINE VAR forr_card_count  AS DEC  NO-UNDO.

DEFINE VAR tr_amount AS DEC NO-UNDO.
DEFINE VAR tr_count  AS DEC NO-UNDO.




/*-------------------- �室�� ��ࠬ���� --------------------*/

/*DEFINE  INPUT  PARAMETER  direction AS LOGICAl NO-UNDO.          ��ࠬ���� */

{globals.i}

MESSAGE "������ �������� ��� ��� ��ࠡ�⪨ ����� ����権" VIEW-AS ALERT-BOX.
{getdates.i}


{setdest.i}

PUT UNFORMATTED "                     ����� �� ����������� ���������� " skip. 
PUT UNFORMATTED "                        � " beg-date " �� " end-date "."  SKIP(2).

PUT UNFORMATTED "| ���  |        ��� �����        |    ���ᨩ᪨� �����      |    ����㭠த�� �����   |"    SKIP.
PUT UNFORMATTED FILL('-',89) SKIP.     
PUT UNFORMATTED "|      | �-�� |     �㬬�         | �-�� |      �㬬�        | �-�� |     �㬬�         |"    SKIP.
PUT UNFORMATTED FILL('-',89) SKIP.  


/* ���� �� VISA */

ASSIGN 
our_card_amount = 0 our_card_count = 0 
rus_card_amount = 0 rus_card_count = 0 
forr_card_amount = 0 forr_card_count = 0 .

FOR EACH pc-trans WHERE pc-trans.processing = 'UCS'
            AND pc-trans.class-code = 'UCSAcq' 
                        AND pc-trans.pl-sys = "VISA"
            AND pc-trans.pctr-status =  "���"

              AND pc-trans.proc-date GE beg-date 
              AND pc-trans.proc-date LE end-date 
               
NO-LOCK                                        
:             

    FIND FIRST pc-trans-amt WHERE pc-trans-amt.pctr-id EQ  pc-trans.pctr-id 
                        AND   pc-trans-amt.amt-code EQ '����' NO-LOCK.
    IF AVAIL pc-trans-amt THEN 
    DO:                                       

/*PUT UNFORMATTED ' | '
        pc-trans.pctr-code FORMAT 'X(6)' " | "
        pc-trans.pl-sys FORMAT 'X(4)' " | "
        pc-trans.num-card FORMAT 'X(22)' " | "
        pc-trans-amt.amt-cur FORMAT "->>>,>>>,>>9.99" " | "
        pc-trans.cont-date " " pc-trans.cont-time " | "
        pc-trans.proc-date " | " .*/ 




            IF pc-trans.pctr-code BEGINS '�����⎯�' THEN 
                    DO:
                    tr_amount = - pc-trans-amt.amt-cur . 
                    tr_count = -1 . 
                    END.
            ELSE
                    DO:
                    tr_amount =  pc-trans-amt.amt-cur  . 
                    tr_count = 1 . 
                    END.
            
            
            FIND FIRST loan where loan.contract = 'card' 
            and loan.doc-num MATCHES pc-trans.num-card NO-LOCK NO-ERROR.
            IF AVAIL loan THEN 
                    DO: 
                            our_card_amount = our_card_amount + tr_amount.  
                             our_card_count = our_card_count + tr_count.
                      /*  MESSAGE "OUR CARD!! "  VIEW-AS ALERT-BOX.    */
                     END.   
            ELSE 
            DO:
                            FIND FIRST code WHERE code.class = "���_������" 
                            AND code = SUBSTRING(pc-trans.num-card,1,6)
                            NO-LOCK NO-ERROR.
                            
                   /*  MESSAGE "begin num-card" SUBSTRING(pc-trans.num-card,1,6) V~ IEW-AS ALERT-BOX.  */
                            
                            IF AVAIL code AND code.name <> 'RUS'
                            THEN
                                DO:                                 
                                  forr_card_amount = forr_card_amount + tr_amount.                                 
        			  forr_card_count = forr_card_count + tr_count.
                                END.
                            ELSE        
                                DO:                                 
                                  rus_card_amount = rus_card_amount + tr_amount.  
                                  rus_card_count = rus_card_count + tr_count.                                                                
                                END.
            
                         
            END.
                     
               
        
    
.





    END.


END.


PUT UNFORMATTED '| VISA | '   
our_card_count FORMAT '>>>9' " | "  our_card_amount FORMAT '->,>>>,>>>,>>9.99' " | "
rus_card_count FORMAT '>>>9' " | "  rus_card_amount FORMAT '->,>>>,>>>,>>9.99' " | "
forr_card_count FORMAT '>>>9' " | " forr_card_amount FORMAT '->,>>>,>>>,>>9.99' " | "    SKIP. 


/* ���� �� MC */

ASSIGN 
our_card_amount = 0 our_card_count = 0 
rus_card_amount = 0 rus_card_count = 0 
forr_card_amount = 0 forr_card_count = 0 .

FOR EACH pc-trans WHERE pc-trans.processing = 'UCS'
              AND pc-trans.class-code = 'UCSAcq' 
              AND pc-trans.pl-sys = 'MC'
              AND pc-trans.pctr-status =  "���"
              AND pc-trans.proc-date GE beg-date 
              AND pc-trans.proc-date LE end-date 


NO-LOCK                                        
:             

    FIND FIRST pc-trans-amt WHERE pc-trans-amt.pctr-id EQ  pc-trans.pctr-id 
                        AND   pc-trans-amt.amt-code EQ '����' NO-LOCK.
    IF AVAIL pc-trans-amt THEN 
    DO:                                       



                /*PUT UNFORMATTED ' | '
        pc-trans.pctr-code FORMAT 'X(6)' " | "
        pc-trans.pl-sys FORMAT 'X(4)' " | "
        pc-trans.num-card FORMAT 'X(22)' " | "
        pc-trans-amt.amt-cur FORMAT "->>>,>>>,>>9.99" " | "
        pc-trans.cont-date " " pc-trans.cont-time " | "
        pc-trans.proc-date " | " .*/


            IF pc-trans.pctr-code BEGINS '�����⎯�' THEN 
                    DO:
                    tr_amount = - pc-trans-amt.amt-cur . 
                    tr_count = -1 . 
                    END.
            ELSE
                    DO:
                    tr_amount =  pc-trans-amt.amt-cur  . 
                    tr_count = 1 . 
                    END.
            
            
            FIND FIRST loan where loan.contract = 'card' 
            and loan.doc-num MATCHES pc-trans.num-card NO-LOCK NO-ERROR.
            IF AVAIL loan THEN 
                    DO: 
                            our_card_amount = our_card_amount + tr_amount.  
                             our_card_count = our_card_count + tr_count.
                      /*  MESSAGE "OUR CARD!! "  VIEW-AS ALERT-BOX.    */
                     END.   
            ELSE 
            DO:
                            FIND FIRST code WHERE code.class = "���_������" 
                            AND code = SUBSTRING(pc-trans.num-card,1,6)
                            NO-LOCK NO-ERROR.
                            
                   /*  MESSAGE "begin num-card" SUBSTRING(pc-trans.num-card,1,6) VIEW-AS A   */
                            
		   
                        IF AVAIL code AND code.name <> 'RUS'
                            THEN
                                DO:                                 
                                  forr_card_amount = forr_card_amount + tr_amount.                                 
        			  forr_card_count = forr_card_count + tr_count.
                                END.
                            ELSE        
                                DO:                                 
                                  rus_card_amount = rus_card_amount + tr_amount.  
                                  rus_card_count = rus_card_count + tr_count.                                                                
                                END.

            
                         
            END.
                     
               
        
    
.





    END.


END.


PUT UNFORMATTED '|  MC  | '   
our_card_count FORMAT '>>>9' " | "  our_card_amount FORMAT '->,>>>,>>>,>>9.99' " | "
rus_card_count FORMAT '>>>9' " | "  rus_card_amount FORMAT '->,>>>,>>>,>>9.99' " | "
forr_card_count FORMAT '>>>9' " | " forr_card_amount FORMAT '->,>>>,>>>,>>9.99' " | "    SKIP. 

/* ���� �� DC */

ASSIGN 
our_card_amount = 0 our_card_count = 0 
rus_card_amount = 0 rus_card_count = 0 
forr_card_amount = 0 forr_card_count = 0 .

FOR EACH pc-trans WHERE pc-trans.processing = 'UCS'
              AND pc-trans.class-code = 'UCSAcq' 
              AND pc-trans.pl-sys = "DC"
              AND pc-trans.pctr-status =  "���"             

              AND pc-trans.proc-date GE beg-date 
              AND pc-trans.proc-date LE end-date 
NO-LOCK                                        
:

    FIND FIRST pc-trans-amt WHERE pc-trans-amt.pctr-id EQ  pc-trans.pctr-id 
                        AND   pc-trans-amt.amt-code EQ '����' NO-LOCK.
    IF AVAIL pc-trans-amt THEN 
    DO:                                       

/*PUT UNFORMATTED ' | '
        pc-trans.pctr-code FORMAT 'X(6)' " | "
        pc-trans.pl-sys FORMAT 'X(4)' " | "
        pc-trans.num-card FORMAT 'X(22)' " | "
        pc-trans-amt.amt-cur FORMAT "->>>,>>>,>>9.99" " | "
        pc-trans.cont-date " " pc-trans.cont-time " | "
        pc-trans.proc-date " | " .*/

            IF pc-trans.pctr-code BEGINS '�����⎯�' THEN 
                    DO:
                    tr_amount = - pc-trans-amt.amt-cur . 
                    tr_count = -1 . 
                    END.
            ELSE
                    DO:
                    tr_amount =  pc-trans-amt.amt-cur  . 
                    tr_count = 1 . 
                    END.
            
            
            FIND FIRST loan where loan.contract = 'card' 
            and loan.doc-num MATCHES pc-trans.num-card NO-LOCK NO-ERROR.
            IF AVAIL loan THEN 
                    DO: 
                            our_card_amount = our_card_amount + tr_amount.  
                             our_card_count = our_card_count + tr_count.
                      /*  MESSAGE "OUR CARD!! "  VIEW-AS ALERT-BOX.    */
                     END.   
            ELSE 
            DO:
                            FIND FIRST code WHERE code.class = "���_������" 
                            AND code = SUBSTRING(pc-trans.num-card,1,6)
                            NO-LOCK NO-ERROR.
                            
                   /*  MESSAGE "begin num-card" SUBSTRING(pc-trans.num-card,1,6) V~ IEW-AS ALERT-BOX.  */


                            IF AVAIL code AND code.name <> 'RUS'
                            THEN
                                DO:                                 
                                  forr_card_amount = forr_card_amount + tr_amount.                                 
        			  forr_card_count = forr_card_count + tr_count.
                                END.
                            ELSE        
                                DO:                                 
                                  rus_card_amount = rus_card_amount + tr_amount.  
                                  rus_card_count = rus_card_count + tr_count.                                                                
                                END.                            

            
                         
            END.
              
    
.

    END.

END.


PUT UNFORMATTED '|  DC  | '   
our_card_count FORMAT '>>>9' " | "  our_card_amount FORMAT '->,>>>,>>>,>>9.99' " | "
rus_card_count FORMAT '>>>9' " | "  rus_card_amount FORMAT '->,>>>,>>>,>>9.99' " | "
forr_card_count FORMAT '>>>9' " | " forr_card_amount FORMAT '->,>>>,>>>,>>9.99' " | "    SKIP. 


{preview.i}
