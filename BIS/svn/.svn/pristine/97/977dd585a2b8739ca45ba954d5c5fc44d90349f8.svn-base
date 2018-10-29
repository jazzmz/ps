/* ------------------------------------------------------
     File: $RCSfile: rep-avto.p,v $ $Revision: 1.1 $ $Date: 2008-07-21 09:57:10 $
     Copyright: ООО КБ "Пpоминвестрасчет"
     Базируется: OutSource from Kuntashev V.
     Причина: 
     Что делает: Отчет по висящим авторизациям
     Как работает: Работает по Транзакциям ПЦ в статусе АВТ
     Параметры:  
     Место запуска: ПК-Печать-Выходные формы  
     Автор: $Author: Buryagin $ 
     Изменения: $Log: not supported by cvs2svn $
------------------------------------------------------ */

/*
Отчет по висящим авторизациям
Работает по Транзакциям ПЦ в статусе АВТ 
*/
                                                      
{globals.i}                                           
{intrface.get card}
{intrface.get instrum}
{intrface.get xclass}
{sh-defs.i}
                                       

DEF VAR    I     AS INTEGER        NO-UNDO.  /* счетчик */
DEF BUFFER card  FOR loan.                   /* карты*/

DEFINE TEMP-TABLE ttResult
    FIELD system					AS CHARACTER         /* система ПЦ */
    FIELD num-card        LIKE loan.doc-num    /* номер карты */
    FIELD fio             AS CHARACTER         /* ФИО */
    FIELD sum_val_op      AS DECIMAL           /* сумма вал операции */
    FIELD val_op          AS CHARACTER         /* валюта операции  */
    FIELD date_op         AS DATE              /* дата операции */
    FIELD kod_auto        AS CHARACTER         /* код авторизации */
    FIELD sum_val_card    AS DECIMAL           /* сумма в валюте карты */
    FIELD val_card        AS CHARACTER         /* валюта карты */
    .

DEF STREAM mStr.

{setdest2.i &stream="stream mStr" &filename=_spool5.tmp &cols=120}

/* Формирование таблицы с результатами */
FOR EACH pc-trans WHERE pc-trans.pctr-status eq "АВТ"  NO-LOCK,
			FIRST card WHERE card.contract  EQ "card"
                   AND card.doc-num EQ TRIM(pc-trans.num-card) NO-LOCK,
      FIRST person WHERE person.person-id EQ card.cust-id
      NO-LOCK:
 
      CREATE ttResult.                                                                     
      ASSIGN
         ttResult.system        = pc-trans.pl-sys         
         ttResult.num-card      = pc-trans.num-card
         ttResult.fio           = person.name-last + " " + person.first-names
         ttResult.date_op       = pc-trans.cont-date
         ttResult.kod_auto      = pc-trans.auth-code
         .
 
     FIND FIRST pc-trans-amt WHERE pc-trans-amt.pctr-id  EQ pc-trans.pctr-id
                               AND pc-trans-amt.amt-code EQ "СУМТ" no-lock no-error.
      ASSIGN
         ttResult.sum_val_op    = pc-trans-amt.amt-cur        
         ttResult.val_op        = GetISOCode(pc-trans-amt.currency)
         .         
     FIND FIRST pc-trans-amt WHERE pc-trans-amt.pctr-id  EQ pc-trans.pctr-id
                               AND pc-trans-amt.amt-code EQ "СУМСЧ" no-lock no-error.
      ASSIGN
         ttResult.sum_val_card   = pc-trans-amt.amt-cur        
         ttResult.val_card       = GetISOCode(pc-trans-amt.currency)
         .         
END. /* конец формирования таблицы */


/* вывод информации */
FOR EACH ttResult BREAK BY ttResult.system BY ttResult.val_card :

   IF FIRST-OF (ttResult.system) THEN DO:
	 I = 0.
    /*Шапка*/
PUT STREAM mStr UNFORMATTED "Отчет по висящим авторизациям на " STRING(TODAY) " ." SKIP(1)
                            "Платежная система : "   STRING(GetCodeName("ПлатСистемы",ttResult.system)) " ." SKIP(1)
                            "┌────────────────┬──────────────────────────────┬───────────────┬─────┬──────────┬───────────┬───────────────┬─────┐" SKIP
                            "│   Номер карты  │      ФИО   Клиента           │  Сумма в вал  │ Вал │   Дата   │   Код     │  Сумма в вал  │ Вал │" SKIP
                            "│                │                              │    операции   │ опер│ операции │авторизации│     карты     │карты│" SKIP
                            "├────────────────┼──────────────────────────────┼───────────────┼─────┼──────────┼───────────┼───────────────┼─────┤" SKIP.                                                 
  END.                                                                                         



    ACCUMULATE ttResult.sum_val_card  (TOTAL BY ttResult.system BY ttResult.val_card)
    .
    I = I + 1. 

    PUT STREAM mStr UNFORMATTED
        "│" STRING(ttResult.num-card, "x(16)")
        "│" STRING(ttResult.fio, "x(30)")
        "│" STRING(ttResult.sum_val_op, "->>>,>>>,>>9.99")
        "│ " STRING(ttResult.val_op, "x(3)")
        " │" STRING(ttResult.date_op, "99/99/9999")
        "│" STRING(ttResult.kod_auto, "x(11)")
        "│" STRING(ttResult.sum_val_card, "->>>,>>>,>>9.99")
        "│ " STRING(ttResult.val_card, "x(3)") " │"
        SKIP.
      
        /* подитог по валютам карт */
      IF LAST-OF(ttResult.val_card) THEN
      DO:    
   	   PUT STREAM mStr UNFORMATTED
   	   "├────────────────┴──────────────────────────────┴───────────────┴─────┴──────────┴───────────┴───────────────┴─────┤" SKIP
   	   "│ Итого в " + STRING(ttResult.val_card, "x(3)") + " :" STRING(ACCUM TOTAL by ttResult.val_card ttResult.sum_val_card,"->,>>>,>>>,>>9.99") AT 93 "│" AT 116 SKIP.
      
      IF LAST-OF(ttResult.system) THEN
       PUT STREAM mStr UNFORMATTED
         /* итог по ПЦ */
       "├──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤" SKIP
       "│ Итого авторизаций : "  STRING(I ,">>>>9") AT 105  "│" AT 116 SKIP
       "└──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘" SKIP(2).         
       ELSE
       PUT STREAM mStr UNFORMATTED       
       "├────────────────┬──────────────────────────────┬───────────────┬─────┬──────────┬───────────┬───────────────┬─────┤" SKIP.                                               
      END.	
        
END.

{preview2.i &stream="stream mStr" &filename=_spool5.tmp }
