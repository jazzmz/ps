/* ------------------------------------------------------
     File: $RCSfile: rep-ekv.p,v $ $Revision: 1.1 $ $Date: 2008-08-27 10:58:15 $
     Copyright: ООО КБ "Пpоминвестрасчет"
     Базируется: outsource from Kuntashev V
     Причина: 
     Что делает: Отчет по эквайрингу. 
     Как работает: 
     Параметры: 
     Место запуска:  
     Автор: $Author: Buryagin $ 
     Изменения: $Log: not supported by cvs2svn $
------------------------------------------------------ */
/* 

Отчет по экварингу своим устроиствам.

*/
                                                      
{globals.i}                                           
{intrface.get card}
{intrface.get instrum}
{intrface.get xclass}
{sh-defs.i}
{get-bankname.i}                                       
{getdate.i}                                       

DEF VAR    I         AS INTEGER        NO-UNDO.  /* счетчик    */
DEF BUFFER org       FOR loan.                   /* клиентские */
DEF BUFFER eqip      for loan.                   /* устройства */

/*
DEF VAR kol_VISA_ps_op     as int NO-UNDO.
DEF VAR sum_VISA_ps_op     as DEC NO-UNDO.
DEF VAR sum_VISA_ps_kom_b  as DEC NO-UNDO.
DEF VAR sum_VISA_ps_kom_pc as DEC NO-UNDO.


DEF VAR kol_MC_ps_op     as int NO-UNDO.
DEF VAR sum_MC_ps_op     as DEC NO-UNDO.
DEF VAR sum_MC_ps_kom_b  as DEC NO-UNDO.
DEF VAR sum_MC_ps_kom_pc as DEC NO-UNDO.


DEF VAR system            as char NO-UNDO.
*/

DEFINE TEMP-TABLE ttResult
    FIELD file            AS CHARACTER         /* файл */
    FIELD nazv_org        AS CHARACTER         /* название организаций */
    FIELD nazv_term       AS CHARACTER         /* название торговой точки */
    FIELD nom_term        AS CHARACTER         /* номер торговой точки */
    FIELD system					AS CHARACTER         /* система ПЦ */
    FIELD num-card        LIKE loan.doc-num    /* номер карты */
    FIELD kod_auto        AS CHARACTER         /* код авторизации */
    FIELD date_op         AS DATE              /* дата совершения операции */
    FIELD sum_op          AS DECIMAL           /* сумма операции */
    FIELD kom_op          AS DECIMAL           /* комис операции Банка */
    FIELD kom_pc          AS DECIMAL           /* комис  ПЦ*/
    .

DEFINE TEMP-TABLE ttResFile
    FIELD system					AS CHARACTER         /* система ПЦ */
    FIELD kol_ps_op       AS INTEGER         /* кол-во */
    FIELD sum_ps_op       AS DECIMAL         /* сумма операции */
    FIELD sum_ps_kom_b    AS DECIMAL         /* сумма ком банка */
    FIELD sum_ps_kom_pc   AS DECIMAL         /* сумма ком процессинга */
    .


DEF STREAM mStr.

{setdest2.i &stream="stream mStr" &filename=_spool5.tmp &cols=120}

/* Формирование таблицы с результатами */
FOR EACH pc-trans WHERE pc-trans.pctr-status ne "АВТ"  and
									      pc-trans.proc-date eq end-date and
									     entry(3,pc-trans.pctr-code,chr(1)) eq "1" 
			NO-LOCK,
			FIRST eqip WHERE eqip.doc-num EQ TRIM(pc-trans.num-equip) AND
			                 eqip.class-code eq "card-equip"
			NO-LOCK,
      FIRST org  WHERE org.cont-code  EQ eqip.parent-cont-code AND
      								 org.contract   EQ "card-acq"	          AND
                       org.class-code EQ "card-loan-acqbank" 
      NO-LOCK: 
 
      CREATE ttResult.                                                                     
      ASSIGN
         ttResult.file          = "1"
         ttResult.nazv_term     = eqip.user-o[1]
         ttResult.nom_term      = eqip.doc-num
         ttResult.system        = pc-trans.pl-sys         
         ttResult.num-card      = pc-trans.num-card
         ttResult.date_op       = pc-trans.cont-date
         ttResult.kod_auto      = pc-trans.auth-code
         .
     
     if org.cust-cat eq "В" then ttResult.nazv_org = trim(cBankName).
     if org.cust-cat eq "Ю" then 
     	do:
     		find first cust-corp where cust-corp.cust-id eq org.cust-id no-lock no-error.
     		ttResult.nazv_org = cust-corp.name-short.
     	end. 	


   /*   Сумма операции */		
     FIND FIRST pc-trans-amt WHERE pc-trans-amt.pctr-id  EQ pc-trans.pctr-id
                               AND pc-trans-amt.amt-code EQ "СУМСЧ" no-lock no-error.
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
         .
      END.            

/*   Сумма комиссии ПЦ */      
 
    FIND FIRST pc-trans-amt  WHERE pc-trans-amt.pctr-id      EQ pc-trans.pctr-id AND 
                                   pc-trans-amt.amt-code EQ "КМСК" no-lock no-error.
    if AVAIL pc-trans-amt then 
    	do:                                   
      ASSIGN
         ttResult.kom_pc    = pc-trans-amt.amt-cur        
         .                  
      END.         


/* подсчет итогов */

  Find first ttResFile where ttResFile.system = pc-trans.pl-sys no-lock no-error.
  
  	if AVAIL ttResFile then
  		ASSIGN
  		 ttResFile.kol_ps_op      = ttResFile.kol_ps_op + 1
	     ttResFile.sum_ps_op      = ttResFile.sum_ps_op + ttResult.sum_op
	     ttResFile.sum_ps_kom_b   = ttResFile.sum_ps_kom_b  + ttResult.kom_op
	     ttResFile.sum_ps_kom_pc  = ttResFile.sum_ps_kom_pc + ttResult.kom_pc
	    .
	   else
	   	do:
	   	CREATE ttResFile.
	   	ASSIGN
	   	 ttResFile.system         = pc-trans.pl-sys
  		 ttResFile.kol_ps_op      = 1
	     ttResFile.sum_ps_op      = ttResult.sum_op
	     ttResFile.sum_ps_kom_b   = ttResult.kom_op
	     ttResFile.sum_ps_kom_pc  = ttResult.kom_pc
	    .
	   	END.
/*
if pc-trans.pctr-id = 1504 then
	do:
message "2"   org.cust-cat org.contract org.cont-code pc-trans.pl-sys ttResFile.sum_ps_op. pause.   		
end.
*/	   	 

END. /* конец формирования таблицы */


/* вывод информации */

PUT STREAM mStr UNFORMATTED "Отчет по экварингу на " STRING(end-date) "." SKIP(1)
														"┌─────────────────────────────────────────────────────────────┐" skip.

for EACH ttResult BREAK BY ttResult.file BY ttResult.nazv_org BY ttResult.nom_term BY ttResult.system BY ttResult.date_op:

   IF FIRST-OF (ttResult.nazv_org) THEN 
   do:
	 I = 0.
    /*Шапка*/
PUT STREAM mStr UNFORMATTED "│                " STRING(ttResult.nazv_org,"x(45)")   "│" skip
                            "├─────────────────────────────────────────────────────────────┤" skip.
   END.
   
   	  if FIRST-OF (ttResult.system) THEN 
	 do: 	
PUT STREAM mStr UNFORMATTED "│        " STRING(ttResult.nazv_term,"x(20)")  "    терминал "  STRING(ttResult.nom_term,"x(20)")  "│" skip
                            "├─────────────────────────────────────────────────────────────┤" skip.
   END.                        
	  
	  if FIRST-OF (ttResult.nom_term) THEN 
	 do: 	
PUT STREAM mStr UNFORMATTED "│Платежная система : "   STRING(GetCodeName("ПлатСистемы",ttResult.system),"x(40)")  " │"SKIP
                            "├────────────┬──────────────────┬───────────┬─────────────────┤" SKIP
                            "│    Дата    │  Номер карты     │   Код     │     Сумма       │" SKIP
                            "│  операции  │                  │авторизации│ операции, рубли │" SKIP
                            "├────────────┼──────────────────┼───────────┼─────────────────┤" SKIP.                                                 
   END.                                                                                         



    ACCUMULATE ttResult.sum_op  (TOTAL BY ttResult.file BY ttResult.nazv_org BY ttResult.nom_term BY ttResult.system)
               ttResult.kom_op  (TOTAL BY ttResult.file BY ttResult.nazv_org BY ttResult.nom_term BY ttResult.system)
               ttResult.kom_pc  (TOTAL BY ttResult.file BY ttResult.nazv_org BY ttResult.nom_term BY ttResult.system)
               
    					 ttResult.sum_op  (COUNT BY ttResult.file BY ttResult.nazv_org BY ttResult.nom_term BY ttResult.system)
    					 ttResult.kom_op  (COUNT BY ttResult.file BY ttResult.nazv_org BY ttResult.nom_term BY ttResult.system)
    					 ttResult.kom_pc  (COUNT BY ttResult.file BY ttResult.nazv_org BY ttResult.nom_term BY ttResult.system)
    
    . 

    PUT STREAM mStr UNFORMATTED
        "│ " STRING(ttResult.date_op, "99/99/9999") + " │ " + STRING(ttResult.num-card, "x(16)") + " │ " + STRING(ttResult.kod_auto, "x(9)") + " │ " + STRING(ttResult.sum_op, "->>>,>>>,>>9.99") + " │"
        
        SKIP.
      
      IF LAST-OF(ttResult.system) THEN
     do: 
       PUT STREAM mStr UNFORMATTED 
         /* итог по ПЦ */ 
       "├────────────┴──────────────────┴───────────┴─────────────────┤" SKIP
       "│ Итого по платежной системе "  STRING(GetCodeName("ПлатСистемы",ttResult.system),"x(29)") STRING(ACCUM COUNT BY ttResult.system ttResult.sum_op,">>9")  " │" SKIP
       "│ Сумма операций : " STRING(ACCUM TOTAL BY ttResult.system ttResult.sum_op,"->,>>>,>>>,>>9.99") "│" AT 63 skip
       "│ Комиссия Банка : " STRING(ACCUM TOTAL BY ttResult.system ttResult.kom_op,"->,>>>,>>>,>>9.99") "│" AT 63 skip
       "│ Комиссия ПЦ    : " STRING(ACCUM TOTAL BY ttResult.system ttResult.kom_pc,"->,>>>,>>>,>>9.99") "│" AT 63 skip
       "├─────────────────────────────────────────────────────────────┤" SKIP.         


      IF LAST-OF(ttResult.nom_term) THEN
       PUT STREAM mStr UNFORMATTED 
         /* итог по терминалу */ 
       "│ Итого по терминалу "  STRING(ttResult.nom_term,"x(37)") STRING(ACCUM COUNT BY ttResult.nom_term ttResult.sum_op,">>9") " │" SKIP
       "│ Сумма операций : " STRING(ACCUM TOTAL BY ttResult.nom_term ttResult.sum_op,"->,>>>,>>>,>>9.99") "│" AT 63 skip
       "│ Комиссия Банка : " STRING(ACCUM TOTAL BY ttResult.nom_term ttResult.kom_op,"->,>>>,>>>,>>9.99") "│" AT 63 skip
       "│ Комиссия ПЦ    : " STRING(ACCUM TOTAL BY ttResult.nom_term ttResult.kom_pc,"->,>>>,>>>,>>9.99") "│" AT 63 skip
       "├─────────────────────────────────────────────────────────────┤" SKIP.         

      IF LAST-OF(ttResult.nazv_org) THEN
       PUT STREAM mStr UNFORMATTED 
         /* итог по  организации */ 
       "│ Итого по организации "  STRING(ttResult.nazv_org,"x(35)")  STRING(ACCUM COUNT BY ttResult.nazv_org ttResult.sum_op,">>9") " │" SKIP
       "│ Сумма операций : " STRING(ACCUM TOTAL BY ttResult.nazv_org ttResult.sum_op,"->,>>>,>>>,>>9.99") "│" AT 63 skip
       "│ Комиссия Банка : " STRING(ACCUM TOTAL BY ttResult.nazv_org ttResult.kom_op,"->,>>>,>>>,>>9.99") "│" AT 63 skip
       "│ Комиссия ПЦ    : " STRING(ACCUM TOTAL BY ttResult.nazv_org ttResult.kom_pc,"->,>>>,>>>,>>9.99") "│" AT 63 skip
       "├─────────────────────────────────────────────────────────────┤" SKIP.  
     END.
   
     else
       PUT STREAM mStr UNFORMATTED       
       "├────────────┼──────────────────┼───────────┼─────────────────┤" SKIP.         

      IF LAST-OF (ttResult.file)  THEN
      do:	
       PUT STREAM mStr UNFORMATTED 
         /* итог по  файлу */ 
       "│ Итого по файлу                                              │" SKIP
       "│ Количество операций                                         │" SKIP.
      	for each ttResFile break by ttResFile.system:
           PUT STREAM mStr UNFORMATTED 
           "│ в т.ч. по " STRING(GetCodeName("ПлатСистемы",ttResFile.system),"x(29)") STRING(ttResFile.kol_ps_op,">>9") AT 59 "│" AT 63 skip.
        END.
       
       PUT STREAM mStr UNFORMATTED 
       "│ Сумма операций                                              │" SKIP.
        	for each ttResFile break by ttResFile.system:
            PUT STREAM mStr UNFORMATTED 
            "│ в т.ч. по " STRING(GetCodeName("ПлатСистемы",ttResFile.system),"x(29)") STRING(ttResFile.sum_ps_op,"->,>>>,>>>,>>9.99") AT 45 "│" AT 63 skip.
          END.
       

       PUT STREAM mStr UNFORMATTED 
       "│ Комиссия Банка                                              │" SKIP.
        	for each ttResFile break by ttResFile.system:
            PUT STREAM mStr UNFORMATTED 
            "│ в т.ч. по " STRING(GetCodeName("ПлатСистемы",ttResFile.system),"x(29)") STRING(ttResFile.sum_ps_kom_b,"->,>>>,>>>,>>9.99") AT 45 "│" AT 63 skip.
          END.

       PUT STREAM mStr UNFORMATTED 
       "│ Комиссия ПЦ                                                 │" SKIP.
        	for each ttResFile break by ttResFile.system:
            PUT STREAM mStr UNFORMATTED 
            "│ в т.ч. по " STRING(GetCodeName("ПлатСистемы",ttResFile.system),"x(29)") STRING(ttResFile.sum_ps_kom_pc,"->,>>>,>>>,>>9.99") AT 45 "│" AT 63 skip.
          END.

  
       PUT STREAM mStr UNFORMATTED       
       "└─────────────────────────────────────────────────────────────┘" SKIP.         
       
       end.
      
END.

{preview2.i &stream="stream mStr" &filename=_spool5.tmp }
