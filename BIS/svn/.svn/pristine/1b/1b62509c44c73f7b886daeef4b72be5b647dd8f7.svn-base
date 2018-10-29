/* ========================================================================= */
/** 
    Copyright: ООО ПИР Банк, Управление автоматизации (C) 2013
     Filename: pir_u11rep_w008.p
      Comment: Отчет "Запрос по обновлению анкеты физ.лица" для У11
		Отчет работает только по клиентам, у которых есть действующий договор по ПК
   Parameters: 
       Launch: БМ - Клиенты - Физ.лица - Отмечаем нужных, ctrl+g - ПИРБАНК: (У11) Запрос по обновлению анкеты физ.лица
      Created: Sitov S.A., 06.08.2013
	Basis: #3504
     Modified: 
               
*/
/* ========================================================================= */

MESSAGE  "      Код процедуры  #3504-001       "  VIEW-AS ALERT-BOX TITLE "[ ПИР: ДЛЯ ОБРАЩЕНИЯ К АДМИНИСТРАТОРУ ]". 


{globals.i}
{tmprecid.def}
{wordwrap.def}
{getdate.i}
{ulib.i}


DEF VAR AcctList  AS CHAR  NO-UNDO.
DEF VAR n      AS INT  INIT 0   NO-UNDO.

DEF VAR tmpStr AS CHAR EXTENT 4 NO-UNDO.
DEF VAR s      AS INT  INIT 0   NO-UNDO.




/*** ===================================================================== ***/
/*** ====                                                             ==== ***/
/*** ===================================================================== ***/

/**
 * Возвращает список основных счетов открытых договоров по ПК (для физика)
 **/
FUNCTION GetAcctList RETURNS CHAR(INPUT mClId AS INT,INPUT mDate AS DATE):
  DEF VAR  mAcctList  AS CHAR  INIT "" NO-UNDO.     
  DEF BUFFER loan FOR loan.

  FOR EACH loan 
    WHERE loan.contract EQ 'card-pers' 
    AND   loan.cust-cat EQ 'Ч'
    AND   CAN-DO("card-loan-pers", loan.class-code) 
    AND   loan.cust-id  EQ mClId 
    AND   CAN-DO("ОТКР,ЗАКР",loan.loan-status)
    AND   loan.end-date > mDate
    AND  (loan.close-date = ? OR loan.close-date >= mDate)
    NO-LOCK :

	IF mAcctList = "" THEN 
	  mAcctList = GetLoanAcct_ULL(loan.contract, loan.cont-code, 'SCS@' + loan.currency, mDate, false) .
	ELSE 
	  mAcctList = mAcctList + "," + GetLoanAcct_ULL(loan.contract, loan.cont-code, 'SCS@' + loan.currency, mDate, false).

  END.

  RETURN mAcctList .
END FUNCTION.




/*** ===================================================================== ***/
/*** ====                                                             ==== ***/
/*** ===================================================================== ***/

{setdest.i}

FOR EACH tmprecid,
FIRST person
  WHERE RECID(person) = tmprecid.id
NO-LOCK:


  AcctList =  GetAcctList(person.person-id, end-date) .

  IF  NUM-ENTRIES(AcctList,",") < 1   
	THEN  NEXT .


  PUT UNFORM SKIP(3).

	/*** ФИО Клиента */
  tmpStr[1] = person.name-last + " " + person.first-name .
  {wordwrap.i &s=tmpStr &n=4 &l=37}
  DO s = 1 TO 4 :
    IF tmpStr[s] <> "" THEN  PUT UNFORM  FILL(" ", 42) tmpStr[s]  SKIP.
  END.

	/*** Список основных счетов по ПК */
  DO n = 1 TO NUM-ENTRIES(AcctList,",") :
    IF n = 1 THEN  
	PUT UNFORM  FILL(" ", 42) "Карточный счет № " ENTRY(n,AcctList,",") SKIP.
    ELSE
	PUT UNFORM  FILL(" ", 59)                     ENTRY(n,AcctList,",") SKIP.
  END.


  PUT UNFORM
        " " SKIP(2)
	"      В целях обновления и актуализации данных Вашего юридического досье просим"  SKIP
	"в кратчайшие сроки предоставить в Отдел обслуживания эмиссии Управления пласти-"  SKIP
	"ковых карт ООО ПИР Банк следующие документы:"  SKIP(1)

	"1) Паспорт (для снятия копии)."  SKIP(1)

	"Напоминаем Вам, что согласно п.5.7. Договора банковского счета, предусматриваю-"  SKIP
	"щего совершение операций с использованием расчетных карт  VISA - PIR Bank Вы "    SKIP
	"обязаны незамедлительно предоставлять документы по изменениям данных, указанных"  SKIP
	"в договоре, с момента их возникновения."  SKIP(2)

	"С уважением, "  SKIP
	"Начальник Управления пластиковых карт                              Буянова Н.Г."  SKIP(2)

	"Дата "  end-date FORMAT "99/99/9999"  " г."  SKIP(4)
	"Тел.: +7(495)785-56-97, +7(495)742-05-05 (доб.143,182)"  SKIP(2)
  .

  PAGE.

END.


{preview.i}
	