/** 
    Copyright: ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (C) 2011 
     Filename: pir-inv11.p
      Comment: Акт инвентаризации наличных денежных средств по состоянию на заданную дату
       Launch: ХЗ -> УМЦ -> ОС -> Картотоке -> Браузер карточек ctrl+g (хотя к картам отношения не имеет :) ) -> ИНВ11 Акт инвентаризации расходов будущих периодов
   Parameters: 
         Uses:
      Used by:
      Created: Ситов С.А., 03.11.2011 
<Как_работает> : 
	Задаем период времени.
	Отбираем все счета 61403, у которых дата закрытия не установлена либо больше заданной даты.
	Определяем дату первого прихода по отобраному счету.
	Если приход был, то определяем остаток на дату прихода (колонка 4). Иначе в акт инвентаризации счет не попадет.
	Если полученный остаток больше 0, то определяем остаток на конечную дату заданного периода (колонка 9, 13). Иначе в акт инвентаризации счет не попадет.
	Если  остаток на конечную дату заданного периода больше 0, считаем колонку 8. Иначе в акт инвентаризации счет не попадет.
	Колонка 8 = (Колонка 4) - (Колонка 13)
*/


{globals.i}
{sh-defs.i}
{getdates.i}
{get-bankname.i}

DEF VAR count AS INT INIT 0 NO-UNDO.

DEF VAR Ost_61403_beg AS DEC INIT 0 NO-UNDO.
DEF VAR Ost_61403_end AS DEC INIT 0 NO-UNDO.

DEF VAR DB_ob AS DEC INIT 0 NO-UNDO.
DEF VAR start_date AS DATE NO-UNDO.
DEF VAR count_op AS INT INIT 0 NO-UNDO.

def var act as char  NO-UNDO.

DEFINE  TEMP-TABLE rep-pp NO-UNDO
   FIELD nmbr     AS INT
   FIELD act-name AS CHAR  
   FIELD act-num  AS CHAR  
   FIELD amt4      AS DEC  
   FIELD amt8      AS DEC  
   FIELD amt9      AS DEC  
   FIELD amt13     AS DEC  
   INDEX nmbr act-num    
.


DEF VAR All_amt4    AS DEC INIT 0 NO-UNDO.
DEF VAR All_amt8    AS DEC INIT 0 NO-UNDO.
DEF VAR All_amt9    AS DEC INIT 0 NO-UNDO.
DEF VAR All_amt13   AS DEC INIT 0 NO-UNDO.



{setdest.i}

		/* 61403 */

FOR EACH acct WHERE acct.acct begins "61403" /*"61403810200000000092"*/
     AND (acct.close-date =? OR acct.close-date >= end-date )
NO-LOCK:

     DB_ob = 0 .
     Ost_61403_beg = 0.
     Ost_61403_end = 0.
     start_date = beg-date.
     count_op = 0 .

     FOR EACH op-entry WHERE ( op-entry.op-date >= beg-date AND op-entry.op-date <= end-date)
        AND op-entry.acct-db = acct.acct
     NO-LOCK:
	DB_ob = DB_ob + op-entry.amt-rub.
        count_op = count_op + 1.
        IF count_op = 1 THEN
           start_date = op-entry.op-date . /* дата первой проводки */
     END.

     RUN acct-pos IN h_base (acct.acct, acct.currency,start_date,start_date, chr(251)).
     IF ABS(sh-bal) > 0 THEN
        Ost_61403_beg = ABS(sh-bal).     	

     RUN acct-pos IN h_base (acct.acct, acct.currency,end-date,end-date, chr(251)).
     IF ABS(sh-bal) > 0 THEN
        Ost_61403_end = ABS(sh-bal).     	


     IF     Ost_61403_beg > 0  AND Ost_61403_end > 0  AND DB_ob > 0 THEN
     DO:

	count =  count + 1 .

        CREATE rep-pp.
        ASSIGN
            nmbr =  count     
            act-name = acct.details 
            act-num  = acct.acct
            amt4  = Ost_61403_beg    
            amt8  = Ost_61403_beg - Ost_61403_end    
            amt9  = Ost_61403_end    
            amt13 = Ost_61403_end    
        .

/*
message acct.acct " | " rep-pp.act-num " | " count " | " rep-pp.nmbr  view-as alert-box.
*/

/*	
   PUT UNFORM acct.details format "x(50)" " | " acct.acct " | Ost_beg = " Ost_61403_beg FORMAT "->,>>>,>>9.99" " | Ost_end = " Ost_61403_end FORMAT "->,>>>,>>9.99" " count = " count /* " | DB_ob= " DB_ob */  SKIP.
*/


     END.

END.
                                                                                                                           

PUT UNFORM "                                                                                          Унифицированная форма N ИНВ-11 " SKIP .
PUT UNFORM "                                                           Утверждена Постановлением Госкомстата России от 18.08.98 N 88 " SKIP .
PUT UNFORM "                                                                                                            ┌──────────┐ " SKIP .
PUT UNFORM "                                                                                                            │Код       │ " SKIP .
PUT UNFORM "                                                                                                            ├──────────┤ " SKIP .
PUT UNFORM "                                                                                              Форма по ОКУД │ 0317012  │ " SKIP .
PUT UNFORM "                                                                                                            ├──────────┤ " SKIP .
PUT UNFORM " СВОД ПО " + STRING(cBankName,"x(25)") + "                                                                по ОКПО │ 29287152 │ " SKIP.
PUT UNFORM "                                                                                                            ├──────────┤ " SKIP .
PUT UNFORM STRING(cBankName,"x(25)") + "                                                                                  │ 29287152 │ " SKIP .
PUT UNFORM "                                                                                                            ├──────────┤ " SKIP .
PUT UNFORM "                                                                                           Вид деятельности │          │ " SKIP .
PUT UNFORM "                                                                                                 ┌──────────┼──────────┤ " SKIP .
PUT UNFORM "                                    Основание для         приказ, постановление, распоряжение    │ Номер    │          │ " SKIP .
PUT UNFORM "                                    проведения        ───────────────────────────────────────────┼──────────┼──────────┤ " SKIP .
PUT UNFORM "                                    инвентаризации:               ненужное зачеркнуть            │ Дата     │          │ " SKIP .
PUT UNFORM "                                                                                                 └──────────┼──────────┤ " SKIP .
PUT UNFORM "                                                                                 Дата начала инвентаризации │          │ " SKIP .
PUT UNFORM "                                                                                                            ├──────────┤ " SKIP .
PUT UNFORM "                                                                              Дата окончания инвентаризации │          │ " SKIP .
PUT UNFORM "                                                                                                            ├──────────┤ " SKIP .
PUT UNFORM "                                                                                               Вид операции │          │ " SKIP .
PUT UNFORM "                                                                                                            └──────────┘ " SKIP .
PUT UNFORM "                                                                                                   ┌───────┬───────────┐ " SKIP .
PUT UNFORM "                                                                                                   │Номер  │   Дата    │ " SKIP .
PUT UNFORM "                                                                                                   │док-та │   док-та  │ " SKIP .
PUT UNFORM "                                                                                                   ├───────┼───────────┤ " SKIP .
PUT UNFORM "                                                                                                   │       │" today FORMAT "99/99/9999" " │ " SKIP .
PUT UNFORM "                                                                                                   └───────┴───────────┘ " SKIP .
PUT UNFORM "                                                                АКТ                                                      " SKIP .
PUT UNFORM "                                                                                                                         " SKIP .
PUT UNFORM "                                             инвентаризации расходов будущих периодов" SKIP .
PUT UNFORM "" SKIP .
PUT UNFORM "                 Акт составлен комиссией о том, что поставлено на " end-date FORMAT "99/99/9999" " г. проведена инвентаризация расходов будущих периодов." SKIP .
PUT UNFORM "" SKIP .
PUT UNFORM "При инвентаризации установлено следующее:" SKIP .
PUT UNFORM "┌────┬────────────────────────────────────────────────────┬────────────┬───────────┬───────────┬───────────┬───────────┬──────────────┬───────┬──────────────────────────────┬───────────────┬───────────────────────────────┐ " SKIP .
PUT UNFORM "│Но- │                                                    │ Общая (пер-│           │           │           │  Списано  │Остаток расхо-│Кол-во │    Подлежит списанию на      │Расчетный оста-│  Результаты инвентаризации    │ " SKIP .
PUT UNFORM "│мер │                   Вид расходов                     │вонач) сумма│   Дата    │   Срок    │  Расчетн. │ (погашено)│дов на начало │месяцев│  себестоимость продукции     │ток расходов,  │          руб.коп.             │ " SKIP .
PUT UNFORM "│по  │                                                    │  расходов  │ возникно- │ погашения │  сумма к  │  расходов │инвентариз. по│со дня │          руб.коп.            │подлежащий по- ├───────────────┬───────────────┤ " SKIP .
PUT UNFORM "│по- │                                                    │  будущих   │  вения    │ расходов  │  списанию │ до начала │данным учета  │возник.│                              │гашению в буду-│               │Излишне списано│ " SKIP .
PUT UNFORM "│ряд-├────────────────────────────────────────┬───────────┤  периодов  │ расходов  │(в месяцах)│ расходов  │ инвентар. │              │расхо- ├───────────────┬──────────────┤ щем периоде   │    Подлежит   │   (подлежит   │ " SKIP .
PUT UNFORM "│ку  │              Наименование              │    Код    │  руб.коп.  │           │           │ руб.коп.  │  руб.коп. │  руб.коп.п.  │ дов   │   за месяц    │ с начала года│  руб.коп.     │   досписанию  │восстановлению)│ " SKIP .
PUT UNFORM "│    │                                        │           │            │           │           │           │           │              │       │               │              │               │               │               │ " SKIP .
PUT UNFORM "├────┼────────────────────────────────────────┼───────────┼────────────┼───────────┼───────────┼───────────┼───────────┼──────────────┼───────┼───────────────┼──────────────┼───────────────┼───────────────┼───────────────┤ " SKIP .
PUT UNFORM "│ 1  │                    2                   │     3     │     4      │     5     │     6     │     7     │     8     │       9      │  10   │      11       │       12     │       13      │      14       │       15      │ " SKIP .
PUT UNFORM "├────┼────────────────────────────────────────┼───────────┼────────────┼───────────┼───────────┼───────────┼───────────┼──────────────┼───────┼───────────────┼──────────────┼───────────────┼───────────────┼───────────────┤ " SKIP . /*временное поле с номером счета" SKIP .*/


FOR EACH rep-pp NO-LOCK:

    PUT UNFORM  
        "│"
        rep-pp.nmbr FORMAT "->99" "│" 
        rep-pp.act-name format "x(40)" "│" 
        FILL(" ",11) "│" /*3*/
        rep-pp.amt4 FORMAT "->>>,>>99.99" "│" 
        FILL(" ",11) "│" /*5*/
        FILL(" ",11) "│" /*6*/
        FILL(" ",11) "│" /*7*/        
        rep-pp.amt8 FORMAT "->>>,>>9.99" "│" 
        rep-pp.amt9 FORMAT "->,>>>,>>9.99" " │" 
        FILL(" ",7)  "│" /*10*/
        FILL(" ",15) "│" /*11*/
        FILL(" ",14) "│" /*12*/
        rep-pp.amt13 FORMAT "->>,>>>,>>9.99" " │" 
        FILL(" ",15) "│" /*14*/
        FILL(" ",15) "│" /*15*/
        /* " " rep-pp.act-num " | " */
    SKIP.

/* Подсчитываем суммы */

    All_amt4   = All_amt4  + rep-pp.amt4  .
    All_amt8   = All_amt8  + rep-pp.amt8  .
    All_amt9   = All_amt9  + rep-pp.amt9  .
    All_amt13  = All_amt13 + rep-pp.amt13 .

    PUT UNFORM "├────┼────────────────────────────────────────┼───────────┼────────────┼───────────┼───────────┼───────────┼───────────┼──────────────┼───────┼───────────────┼──────────────┼───────────────┼───────────────┼───────────────┤ " SKIP .

END.


PUT UNFORM "                                              │  ИТОГО    │" All_amt4 FORMAT "->>>,>>99.99" "│     Х     │     Х     │           │" All_amt8 FORMAT "->>>,>>9.99" "│" All_amt9 FORMAT "->,>>>,>>9.99" " │       │               │              │" All_amt13 FORMAT "->>,>>>,>>9.99" " │               │               │ " SKIP .
PUT UNFORM "                                              └───────────┴────────────┴───────────┴───────────┴───────────┴───────────┴──────────────┴───────┴───────────────┴──────────────┴───────────────┴───────────────┴───────────────┘ " SKIP .

PUT UNFORM "      Все подсчеты итогов по строкам, страницам и в целом по акту инвентаризации проверены. " SKIP.                                           
PUT UNFORM "                                                                                                                                               " SKIP .
PUT UNFORM "        Председатель комиссии    ____________________         ____________________         ___________________________________________________ " SKIP .
PUT UNFORM "                                     (должность)                      (подпись)                           (расшифровка подписи)                " SKIP .
PUT UNFORM "                                                                                                                                               " SKIP .
PUT UNFORM "        Члены комиссии           ____________________         ____________________         ___________________________________________________ " SKIP .
PUT UNFORM "                                     (должность)                      (подпись)                           (расшифровка подписи)                " SKIP .
PUT UNFORM "                                                                                                                                               " SKIP .
PUT UNFORM "                                 ____________________         ____________________         ___________________________________________________ " SKIP .
PUT UNFORM "                                     (должность)                      (подпись)                           (расшифровка подписи)                " SKIP .
PUT UNFORM "                                                                                                                                               " SKIP .
PUT UNFORM "                                 ____________________         ____________________         ___________________________________________________ " SKIP .
PUT UNFORM "                                     (должность)                      (подпись)                           (расшифровка подписи)                " SKIP .
PUT UNFORM "                                                                                                                                               " SKIP .
PUT UNFORM "                                                                                                                                               " SKIP .
PUT UNFORM "      Все ценности, поименованные в настоящем акте инвентаризации с № _______ по № ________, комиссией проверены в натуре в моем (нашем)       " SKIP .
PUT UNFORM "                                                                                                                                               " SKIP .
PUT UNFORM "присутствии и внесены в акт, в связи с чем претензий к инвентаризационной комиссии не имею (не имеем).                                                " SKIP .
PUT UNFORM "                                                                                                                                                      " SKIP .
PUT UNFORM "Ценности, перечисленные в акте, находятся на моем (нашем) ответственном хранении.                                                                     " SKIP .
PUT UNFORM "                                                                                                                                                      " SKIP .
PUT UNFORM "                                                                                                                                                      " SKIP .
PUT UNFORM "Материально ответственное(ые) лицо(а):  ____________________         ____________________         ___________________________________________________ " SKIP .
PUT UNFORM "                                            (должность)                   (подпись)                             (расшифровка подписи)                 " SKIP .
PUT UNFORM "                                                                                                                                                      " SKIP .
PUT UNFORM "                                        ____________________         ____________________         ___________________________________________________ " SKIP .
PUT UNFORM "                                            (должность)                   (подпись)                             (расшифровка подписи)                 " SKIP .
PUT UNFORM "                                                                                                                                                      " SKIP .
PUT UNFORM "                                        ____________________         ____________________         ___________________________________________________ " SKIP .
PUT UNFORM "                                            (должность)                    (подпись)                            (расшифровка подписи)                 " SKIP .
PUT UNFORM "                                                                                                                                                      " SKIP .
PUT UNFORM "                                                              ''___'' __________ _____ г.                                                             " SKIP .
PUT UNFORM "                                                                                                                                                      " SKIP .
PUT UNFORM "Указанные в настоящем акте данные и расчеты проверил ____________________         ____________________    ___________________________________________ " SKIP .
PUT UNFORM "                                                          (должность)                  (подпись)                      (расшифровка подписи)           " SKIP .
PUT UNFORM "                                                                                                                                                      " SKIP .
PUT UNFORM "                                                              ''___'' __________ _____ г.                                                             " SKIP .


                                                                                                                          
{preview.i}                                                                                                                
                                                                                                                           
                                                                                                                           
                                                                                                                           