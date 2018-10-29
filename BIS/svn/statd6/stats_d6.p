{pirsavelog.p}

/*
	КБ ПPОМИНВЕСТРАСЧЕТ
	СТАТИСТИКИ Д6: Обороты по счетам клиентов департамента (Ч,Ю).

	Используется ДР Статистика на счете. Если в значении этого ДР есть "Д6" 
	счет попадает в обработку.
	Для настройки прописать в передаваемых параметрах порядок следования 
	валют в отчете и перечислить список просматриваемых счетов 2-го порядка в формате:

	Признак=У16;ПорядокВалют=810,840,978;БалСчета=42301,40702 

	27/07/06
	[vk]
	
*/

{globals.i}
{sh-defs.i}
/* {intrface.get instrum}
{intrface.get xclass}
*/


def input parameter inline as char no-undo.
/* параметры пример:
Признак=У16;ПорядокВалют=810,840,978;БалСчета=42301,40702 
*/

def var i as integer no-undo.
def var j as integer no-undo.
def var tentry as char no-undo.
def var pcur as char no-undo.
def var bline as char no-undo.
def var cur as char no-undo.
def var name as char no-undo.
def var acr as decimal no-undo.
def var adb as decimal no-undo.
def var aos as decimal no-undo.
def var kod as char no-undo.

def var bal-val as decimal no-undo.
def var bal-rub as decimal no-undo.


/* разбор строки параметров */
do i = 1 to num-entries(inline,";").
 tentry = entry(i,inline,";").
 case entry(1,tentry,"="):
    when "ПорядокВалют" then pcur = entry(2,tentry,"=").
    when "БалСчета"     then bline = entry(2,tentry,"=").
    when "Признак"      then kod = entry(2,tentry,"=").
 end.
end.
if pcur = "" or bline = "" then do: 
	message "Ошибка в передаваемых параметрах!!!" view-as alert-box.
	return.
end.

{getdates.i}
{setdest.i}


{get-bankname.i}

Put unformatted "                                                                                 " + cBankName skip.
Put unformatted "                                                                                            ДЕПАРТАМЕНТ 6" skip (2).
Put unformatted "            ОБОРОТЫ ПО СЧЕТАМ КЛИЕНТОВ ДЕПАРТАМЕНТА С " beg-date " ПО " end-date "." skip(2).
Put unformatted "┌───────────────────────────────────────┬──────────────────────┬────────────────────┬────────────────────┬────────────────────┐" skip.
Put unformatted "│                                       │                      │                    │                    │                    │" skip.
Put unformatted "│              КЛИЕНТ                   │          СЧЕТ        │     ОБОРОТ ДБ      │      ОБОРОТ КР     │       ОСТАТОК      │" skip.
Put unformatted "│                                       │                      │ ПРИВЕДЕННЫЙ К РУБ. │ ПРИВЕДЕННЫЙ К РУБ. │ ПРИВЕДЕННЫЙ К РУБ. │" skip.

/* отбираем счета */
tentry = "".
do j = 1 to num-entries(pcur).
 cur = entry (j,pcur).
 Put unformatted "├───────────────────────────────────────┴──────────────────────┴────────────────────┴────────────────────┴────────────────────┤" skip.
 put unformatted "│ ВАЛЮТА " cur "                                                                                                                  │" skip.
 Put unformatted "├───────────────────────────────────────┬──────────────────────┬────────────────────┬────────────────────┬────────────────────┤" skip.

 if cur = "810" then cur = "".
  do i = 1 to num-entries(bline).
   for each acct where acct.bal-acct = integer(entry(i, bline)) and acct.currency = cur by acct.acct:
     tentry = GetXAttrValue("acct",trim(acct.acct) + "," + trim(acct.currency),"Статистика").

     if lookup (kod,tentry) > 0 then do:

       /* ищем клиента */
       if acct.cust-cat = "Ч" then do:
         find first person where person.person-id = acct.cust-id no-lock no-error.
         name = person.name-last + " " + person.first-names. 
       end.
       if acct.cust-cat = "Ю" then do:
         find first cust-corp where cust-corp.cust-id = acct.cust-id no-lock no-error.
         name = cust-corp.cust-stat + " " + cust-corp.name-corp. 
       end.
       /* acct-pos */
       run acct-pos in h_base (acct.acct, acct.currency, beg-date, end-date, "√").
       /* остатки */	
       Bal-rub = abs(sh-bal).
       /* обороты */
       put unformatted  "│ " string(name,"x(37)") " │ "
                        string(acct.acct,"x(20)") " │ "
			string(abs(sh-db),">>>,>>>,>>>,>>9.99") " │ "
			string(abs(sh-cr),">>>,>>>,>>>,>>9.99") " │ " 
			string(abs(bal-rub),">>>,>>>,>>>,>>9.99") " │"skip.
       /* итоги */
       adb = adb + abs(sh-db).
       acr = acr + abs(sh-cr).
       aos = aos + abs(bal-rub).

     end.
     tentry = "".
   end.
  end.
end.
Put unformatted "├───────────────────────────────────────┴──────────────────────┼────────────────────┼────────────────────┼────────────────────┤" skip.
Put unformatted "│                       ИТОГО ЗА ПЕРИОД С " beg-date " ПО " end-date ":│ "
	string(adb,">>>,>>>,>>>,>>9.99") " │ "
	string(acr,">>>,>>>,>>>,>>9.99") " │ " 
	string(aos,">>>,>>>,>>>,>>9.99") " │"skip.
		 
Put unformatted "└──────────────────────────────────────────────────────────────┴────────────────────┴────────────────────┴────────────────────┘" skip.

{preview.i}

