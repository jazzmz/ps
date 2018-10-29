/* ------------------------------------------------------
     File: $RCSfile: rep-comp.p,v $ $Revision: 1.1 $ $Date: 2008-08-18 07:54:51 $
     Copyright: ООО КБ "Пpоминвестрасчет"
     Базируется: 
     Причина: OutSource from Kuntashev V.
     Что делает: Отчет по эквайрингу в разрере клиента
     Как работает: 
     Параметры:  
     Место запуска:  f1 на договоре эквайринга с клиентом
     Автор: $Author: Buryagin $ 
     Изменения: $Log: not supported by cvs2svn $
------------------------------------------------------ */
                                                      
{globals.i}                                           
{intrface.get card}
{intrface.get instrum}
{intrface.get xclass}
{sh-defs.i}
{tmprecid.def}        /** Используем информацию из броузера */

{getdates.i}

{get-bankname.i}

DEF VAR    I         AS INTEGER        NO-UNDO.  /* счетчик    */
DEF BUFFER org       FOR loan.                   /* клиентские */
DEF BUFFER eqip      FOR loan.                   /* устройства */

DEFINE TEMP-TABLE ttResult
    FIELD fil             AS CHARACTER         /* номер файла */
    FIELD nazv_org        AS CHARACTER         /* название организаций */
    FIELD nazv_term       AS CHARACTER         /* название торговой точки */
    FIELD nom_term        AS CHARACTER         /* номер торговой точки */
    FIELD type_term       AS CHARACTER         /* тип торговой точки */
    FIELD system					AS CHARACTER         /* система ПЦ */
    FIELD num-card        LIKE loan.doc-num    /* номер карты */
    FIELD kod_auto        AS CHARACTER         /* код авторизации */
    FIELD date_op         AS DATE              /* дата операции */
    FIELD date_voz        AS DATE              /* дата возмещения */
    FIELD sum_op          AS DECIMAL           /* сумма операции */
    FIELD sum_voz         AS DECIMAL           /* сумма транзакции */
    FIELD kom_op          AS DECIMAL           /* комис операции Банка */
    FIELD kom_pc          AS DECIMAL           /* комис  ПЦ*/
    
    .

DEF STREAM mStr.

{setdest2.i &stream="stream mStr" &filename=_spool5.tmp &cols=120}

/* Формирование таблицы с результатами */
FOR EACH tmprecid NO-LOCK,
    FIRST loan     WHERE RECID(loan) = tmprecid.id 
       NO-LOCK,
       EACH eqip  WHERE eqip.parent-cont-code EQ  loan.cont-code AND
                        eqip.class-code EQ "card-equip"
       NO-LOCK:
    
 /* MESSAGE "1"   eqip.cust-cat eqip.contract eqip.cont-code  loan.parent-cont-code. pause. */
     
     FOR EACH pc-trans WHERE pc-trans.pctr-status ne "АВТ"         AND
                        pc-trans.proc-date GE beg-date             AND 
									      pc-trans.proc-date LE end-date             AND 
									      entry(3,pc-trans.pctr-code,chr(1)) eq "1"  AND
									      TRIM(pc-trans.num-equip) EQ eqip.doc-num
									      
			NO-LOCK:
/*			FIRST eqip WHERE eqip.doc-num EQ TRIM(pc-trans.num-equip) AND
			                 eqip.class-code eq "card-equip"
			NO-LOCK,*/
 
 
      CREATE ttResult.                                                                     
      ASSIGN
         ttResult.fil           = "1"
         ttResult.nazv_term     = eqip.user-o[1]
         ttResult.type_term     = GetCodeName("ТипУстройства",eqip.sec-code)
         ttResult.nom_term      = eqip.doc-num
         ttResult.system        = pc-trans.pl-sys         
         ttResult.num-card      = pc-trans.num-card
         ttResult.date_op       = pc-trans.cont-date
         ttResult.date_voz      = pc-trans.proc-date
         ttResult.kod_auto      = pc-trans.auth-code
         .
     
     IF loan.cust-cat EQ "В" THEN ttResult.nazv_org = trim(cBankName).
     IF loan.cust-cat EQ "Ю" THEN  
     	DO:
     		find first cust-corp where cust-corp.cust-id eq loan.cust-id no-lock no-error.
     		ttResult.nazv_org = cust-corp.name-short.
     	END. 	


   /*   Сумма операции */		
     FIND FIRST pc-trans-amt WHERE pc-trans-amt.pctr-id  EQ pc-trans.pctr-id
                               AND pc-trans-amt.amt-code EQ "СУМСЧ" no-lock no-error.
      IF AVAIL pc-trans-amt then                          
      ASSIGN
         ttResult.sum_op    = pc-trans-amt.amt-cur        
         .         
   
   /*   Сумма комиссии Банка */      
    FIND FIRST pc-trans-amt  WHERE pc-trans-amt.pctr-id      EQ pc-trans.pctr-id AND 
                                   pc-trans-amt.amt-code EQ "КМССЧ" no-lock no-error.
   
    if AVAIL pc-trans-amt then 
    	do:
      ASSIGN
         ttResult.kom_op    = pc-trans-amt.amt-cur 
         ttResult.sum_voz   = ttResult.sum_op +    ttResult.kom_op.    
         .
      END.            
    ELSE
         ttResult.sum_voz   = ttResult.sum_op.    
      

/*   Сумма комиссии ПЦ */      
 
    FIND FIRST pc-trans-amt  WHERE pc-trans-amt.pctr-id      EQ pc-trans.pctr-id AND 
                                   pc-trans-amt.amt-code EQ "КМСК" no-lock no-error.
    if AVAIL pc-trans-amt then 
    	do:                                   
      ASSIGN
         ttResult.kom_pc    = pc-trans-amt.amt-cur        
         .                  
      END.         

  END.

/*
message "2"   org.cust-cat org.contract org.cont-code pc-trans.pl-sys loan.parent-cont-code. pause.   		
*/
END. /* конец формирования таблицы */

/* вывод информации */
 /*Шапка*/
PUT STREAM mStr UNFORMATTED "                                                       СПРАВКА   "  SKIP(1)
                            "                                        за период c " STRING(beg-date) " по " STRING(end-date)  SKIP(1)
                            "      "  ttResult.nazv_org SKIP(2)
                            "                                                                                                                          Комиссии Банка"  SKIP
                            "                                                                                                                        VISA  MASTER  FO" SKIP                           
                            SKIP.


/* поиск комис */
                      FOR EACH tmprecid NO-LOCK,
                               FIRST loan     WHERE RECID(loan) = tmprecid.id NO-LOCK,
                               EACH eqip  WHERE eqip.parent-cont-code EQ  loan.cont-code AND
                                                eqip.class-code EQ "card-equip"
                           NO-LOCK:
                            
                           IF AVAIL eqip THEN
                           DO:
                           PUT STREAM mStr UNFORMATTED 
                            FILL(" ",95) +
                            STRING(GetCodeName("ТипУстройства",eqip.sec-code),"x(25)") +
                            STRING((IF NUM-ENTRIES(eqip.user-o[4],";") > 1 THEN ENTRY(1,eqip.user-o[4],";") ELSE  " ")) + "  "
                            STRING((IF NUM-ENTRIES(eqip.user-o[4],";") > 2 THEN ENTRY(2,eqip.user-o[4],";") ELSE  " ")) + "  " 
                            STRING((IF NUM-ENTRIES(eqip.user-o[4],";") = 3 THEN ENTRY(3,eqip.user-o[4],";") ELSE  " ")) 
                            SKIP.
                           END.                            
                           
                      END.
/* конец поиска комис */
                            
                            
                            
PUT STREAM mStr UNFORMATTED " Валюта                                                                 RUR" SKIP (2)
                            "                                                 ОПЛАТА ТОВАРОВ УСЛУГ                                                                    " SKIP
                            "┌────────────┬──────────────────┬──────────────────────┬───────────┬──────────────┬─────────────────┬─────────────────┬─────────────────┐" SKIP
                            "│    Дата    │  Номер карты     │      Тип карты       │   Код     │ № устройства │     Сумма       │     Сумма       │     Сумма       │" SKIP
                            "│  операции  │                  │                      │авторизации│              │ операции, рубли │ комиссий, рубли │возмещения,рубли │" SKIP
                            "├────────────┼──────────────────┼──────────────────────┼───────────┼──────────────┼─────────────────┼─────────────────┼─────────────────┤" SKIP.                                                 

for EACH ttResult BREAK BY ttResult.fil BY ttResult.date_voz BY ttResult.date_op:


    ACCUMULATE ttResult.sum_op   (TOTAL BY ttResult.fil BY ttResult.date_voz)
               ttResult.kom_op   (TOTAL BY ttResult.fil BY ttResult.date_voz)
               ttResult.sum_voz  (TOTAL BY ttResult.fil BY ttResult.date_voz)
    . 

    PUT STREAM mStr UNFORMATTED
        "│ " STRING(ttResult.date_op, "99/99/9999") + " │ " + STRING(ttResult.num-card, "x(16)") + " │ " + STRING(GetCodeName("ПлатСистемы",ttResult.system),"x(20)") + " │ " + STRING(ttResult.kod_auto, "x(9)") + " │ " + STRING(ttResult.nom_term,"x(12)") + " │ " + STRING(ttResult.sum_op, "->>>,>>>,>>9.99") + " │ " + STRING(ttResult.kom_op, "->>>,>>>,>>9.99")  + " │ " + STRING(ttResult.sum_voz, "->>>,>>>,>>9.99") + " │" SKIP.
      
      IF LAST-OF(ttResult.date_voz) THEN
     do: 
       PUT STREAM mStr UNFORMATTED 
       "├────────────┴──────────────────┴──────────────────────┴───────────┴──────────────┼─────────────────┼─────────────────┼─────────────────┤" SKIP
       "│ Возмещение за  " + STRING(ttResult.date_voz)   " │ " +  STRING(ACCUM TOTAL BY ttResult.date_voz ttResult.sum_op, "->>>,>>>,>>9.99") + " │ " + STRING(ACCUM TOTAL BY ttResult.date_voz ttResult.kom_op, "->>>,>>>,>>9.99")  + " │ " + STRING(ACCUM TOTAL BY ttResult.date_voz ttResult.sum_voz, "->>>,>>>,>>9.99") + " │" AT 82 SKIP.
        IF  LAST-OF(ttResult.date_voz) AND LAST-OF(ttResult.fil) THEN
         PUT STREAM mStr UNFORMATTED 
         "├─────────────────────────────────────────────────────────────────────────────────┼─────────────────┼─────────────────┼─────────────────┤" SKIP.
        ELSE
         PUT STREAM mStr UNFORMATTED      
         "├────────────┬──────────────────┬──────────────────────┬───────────┬──────────────┼─────────────────┼─────────────────┼─────────────────┤" SKIP.         
     END. 
     else
        PUT STREAM mStr UNFORMATTED       
       "├────────────┼──────────────────┼──────────────────────┼───────────┼──────────────┼─────────────────┼─────────────────┼─────────────────┤" SKIP.         

      IF LAST-OF(ttResult.fil) THEN
     do: 
       PUT STREAM mStr UNFORMATTED 
       "│ " AT 1  " ИТОГО: │ " +  STRING(ACCUM TOTAL BY ttResult.fil ttResult.sum_op, "->>>,>>>,>>9.99") + " │ " + STRING(ACCUM TOTAL BY ttResult.fil ttResult.kom_op, "->>>,>>>,>>9.99")  + " │ " + STRING(ACCUM TOTAL BY ttResult.fil ttResult.sum_voz, "->>>,>>>,>>9.99") + " │" AT 75 SKIP
       "└─────────────────────────────────────────────────────────────────────────────────┴─────────────────┴─────────────────┴─────────────────┘" SKIP (2).         
     END.
      
END.


PUT STREAM mStr UNFORMATTED "                                                 ОПЛАТА ТОВАРОВ (AmEx)*                                                                 " SKIP
                            "┌────────────┬──────────────────┬───────────┬──────────────┬─────────────────┐" SKIP
                            "│    Дата    │  Номер карты     │   Код     │ № устройства │     Сумма       │" SKIP
                            "│  операции  │                  │авторизации│              │ операции, рубли │" SKIP
                            "├────────────┴──────────────────┴───────────┼──────────────┼─────────────────┤" SKIP
                            "│                                           │      ИТОГО : │            0.00 │" SKIP
                            "└───────────────────────────────────────────┴──────────────┴─────────────────┘" SKIP
                            " * Возмещение средств с использованием платежных карт AmEx осуществляется в соответствии с договром организации и American Express" SKIP(1)
                            " ────────────────────────────────────────────────────────────────────────────────────" SKIP
                            " ОБОРУДОВАНИЕ " SKIP(1).
                            
                      FOR EACH tmprecid NO-LOCK,
                               FIRST loan     WHERE RECID(loan) = tmprecid.id NO-LOCK,
                               EACH eqip  WHERE eqip.parent-cont-code EQ  loan.cont-code AND
                                                eqip.class-code EQ "card-equip"
                           NO-LOCK:
                            
                           IF AVAIL eqip THEN
                           DO:
                           PUT STREAM mStr UNFORMATTED " " + STRING(eqip.doc-num,"x(15)") + 
                                                             STRING(GetCodeName("ТипУстройства",eqip.sec-code),"x(30)") + 
                                                             STRING(eqip.user-o[1],"x(60)")  SKIP.
                           END.                            
                           
                      END.

PUT STREAM mStr UNFORMATTED " ────────────────────────────────────────────────────────────────────────────────────" SKIP (4)
                            " Заместитель Председателя правления                                                      __________________ " SKIP(2)
                            " Исполнитель                                                                             __________________ " SKIP.
                            

{preview2.i &stream="stream mStr" &filename=_spool5.tmp }
