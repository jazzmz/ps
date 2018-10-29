/* ООО "ПИР Банк" Управление автоматизации 2013г.	*/
/* По заявке #3474					*/
/* Заполняем допреки для выгрузки в свифт.		*/
/* Коллеги! Простите за местами быдлокод. Старался 	*/
/* сохранить стилистику родительской p-шки. :)		*/
/* Гончаров А.Е. 01.08.2013				*/

{globals.i}
{intrface.get xclass}

define variable rSwiftTag as character init "20,32,33,50Cor,52,56,57,59Cor,70Cor,71,72" no-undo.
define variable pirSwift as character extent 11 init ["pirSwift20, pirSwift32, pirSwift33, pirSwift50Cor, pirSwift52, pirSwift56, pirSwift57, pirSwift59Cor, pirSwift70Cor, pirSwift71, pirSwift72"] no-undo.

define variable SwiftTag20 	as character init "" format "x(13)" VIEW-AS EDITOR SIZE 13 BY 1 no-undo.
define variable SwiftTag32 	as character init "" no-undo.
define variable SwiftTag33 	as character init "" no-undo.
define variable SwiftTag50Cor 	as character label "Перевододатель" init "" VIEW-AS EDITOR SIZE 35 BY 5 no-undo.
define variable SwiftTag52 	as character label "" init "BPIRRUMMXXX PIR Bank, llc 121099 MOSCOW NOVINSKY BULVAR 3/1 RUSSIAN FEDERATION, MOSCOW" VIEW-AS EDITOR SIZE 30 BY 4 no-undo.
define variable SwiftTag56 	as character label "Банк посредник" init "" view-as editor size 15 by 1 no-undo.
define variable SwiftTag57 	as character label "Банк бенефициара" init "" view-as editor size 15 by 1 no-undo.
define variable SwiftTag59Cor 	as character label "Бенефициар" init "" view-as editor size 25 by 4 no-undo.
define variable SwiftTag70Cor 	as character label "Назначение платежа" init "" view-as editor size 25 by 4 no-undo.
define variable SwiftTag71 	as character format "x(3) "label "" view-as combo-box list-item-pairs "OUR","OUR","BEN","BEN","SHA","SHA" no-undo.
define variable SwiftTag72 	as character label "Дополнительная информация" init "" view-as editor size 25 by 2 no-undo.

define variable iNum 		as integer no-undo.
define variable cCur 		as character no-undo.
define variable cSum 		as character no-undo.
define variable SenderName 	as character no-undo.
define variable SenderInn 	as character no-undo.
define variable SenderAddress 	as character no-undo.
define variable SenderCity 	as character no-undo.
define variable SenderCountry 	as character no-undo.


define variable rFilter		as character init "" no-undo.
define variable Sender_ID	as character init "" no-undo.
define variable Sender_code	as character init "" no-undo.
define variable User_Title	as character init "" no-undo.

case op-entry.currency:
      when "810" THEN cCur = "RUB".
      when "840" THEN cCur = "USD".
      when "978" THEN cCur = "EUR".
      when "826" THEN cCur = "GBP".
end case.

cSum = trim(string (op-entry.amt-cur,">>>>>>>9.99")).
SwiftTag32 = entry(3,STRING(op.op-date,"99/99/99"),"/") + entry(2,STRING(op.op-date,"99/99/99"),"/")  + entry(1,STRING(op.op-date,"99/99/99"),"/") + cCur + trim(string (op-entry.amt-cur,">>>>>9.99")).
SwiftTag33 = cCur + cSum.

find first acct where acct.acct = op-entry.acct-db no-lock no-error.
case acct.cust-cat:
	when "Ч" then do:
		find first person where person.person-id = acct.cust-id no-lock no-error.
		find first country where country.country-id = person.country-id.
		SenderName = "1/" + TranslitIt(person.name-last + " " + person.first-names).
		if length (SenderName) > 34 then SenderName = "1/" + TranslitIt (person.name-last + " " + entry(1, person.first-names, " ")).
		if length (SenderName) > 34 then SenderName = substring (SenderName,1,34).
		SenderName = SenderName + chr(10).
		SenderInn = person.inn.
		if SenderInn ne "" then SenderInn = "1/INN" + SenderInn + chr(10).
		SenderAddress = replace (replace (translitit (trim (Entry (1,person.address[1] + person.address[2]) + " " + Entry(4,person.address[1] + person.address[2]) + " " + Entry(5,person.address[1] + person.address[2]) + " " + Entry(6,person.address[1] + person.address[2]) + " " + Entry(7,person.address[1] + person.address[2]) + " " + Entry(8,person.address[1] + person.address[2]))),","," "), "  "," ").
		SenderCity = translitit(trim(replace(Entry(3,person.address[1] + person.address[2]),"Г",""))).
		if SenderCity = "MOSKVA" then SenderCity = "MOSCOW".
		SenderCountry = "3/" + GetXAttrValue("country",country.country-id,"alfa-2") + "/".
		Sender_ID = acct.cust-cat + "|" + string (person.person-id).
	end.
	when "Ю" then do:
		find first cust-corp where cust-corp.cust-id = acct.cust-id no-lock no-error.
		find first country where country.country-id = cust-corp.country-id.
		SenderName = "1/" + TranslitIt(cust-corp.name-corp) + ", " + chr(10).
		SenderInn = cust-corp.inn.
		if SenderInn ne "" then SenderInn = "1/INN" + SenderInn + chr(10).
		SenderAddress = replace (replace (translitit(trim(Entry(1,cust-corp.addr-of-low[1] + cust-corp.addr-of-low[2]) + " " + Entry(4,cust-corp.addr-of-low[1] + cust-corp.addr-of-low[2]) + " " + Entry(5,cust-corp.addr-of-low[1] + cust-corp.addr-of-low[2]) + " " + Entry(6,cust-corp.addr-of-low[1] + cust-corp.addr-of-low[2]) + " " + Entry(7,cust-corp.addr-of-low[1] + cust-corp.addr-of-low[2]) + " " + Entry(8,cust-corp.addr-of-low[1] + cust-corp.addr-of-low[2]))),","," "), "  "," ") + chr(10).
		SenderCity = TranslitIt(trim(replace(Entry(3,cust-corp.addr-of-low[1] + cust-corp.addr-of-low[2]),"Г",""))).
		SenderCountry = "3/" + GetXAttrValue("country",country.country-id,"alfa-2") + "/".
		Sender_ID = acct.cust-cat + "|" + string (cust-corp.cust-id).
	end.
end case.

/* SwiftTag50Cor = wrapit(string(op-entry.acct-db) + chr(10) + SenderName + SenderInn + SenderAddress + SenderCountry + SenderCity).*/
SwiftTag50Cor = string(op-entry.acct-db) + chr(10) + SenderName + SenderInn + "2/" + SenderAddress + chr(10) + SenderCountry + SenderCity.
SwiftTag52 = wrapit(SwiftTag52).

/*вычленяем референс */
if can-do ("*REF*", op.details) then do:
	SwiftTag20 = substring (op.details, (index (op.details, "REF") + 4)).

end.

define frame fSet2 
	"Референс:" SwiftTag20
	"Код валюты:" cCur
	"Сумма: " cSum skip(1)
	"Перевододатель:      " SwiftTag50Cor help "Нажмите F1 для сохранения шаблона, F5 для загрузки" skip(1)
	"Банк перевододателя: " SwiftTag52 help "Нажмите F1 для сохранения шаблона, F5 для загрузки" SKIP(1) 
	"Банк посредник:      " SwiftTag56 help "Нажмите F1 для сохранения шаблона, F5 для загрузки" skip(1)
	"Банк бенефициара:    " SwiftTag57 help "Нажмите F1 для сохранения шаблона, F5 для загрузки" SKIP(1) 
	"Бенефициар:          " SwiftTag59Cor help "Нажмите F1 для сохранения шаблона, F5 для загрузки" SKIP(1)
	"Назначение платежа   " SwiftTag70Cor help "Нажмите F1 для сохранения шаблона, F5 для загрузки" SKIP(1) 
	"Расходы и комиссии за перевод: " SwiftTag71 help "Нажмите F1 для сохранения шаблона, F5 для загрузки" SKIP(1)
	"Дополнительная информация:" SwiftTag72 help "Нажмите F1 для сохранения шаблона, F5 для загрузки" SKIP(1)
	 with centered no-labels title "Заявление на перевод".

on f5 of frame fSet2 anywhere do:
	do transaction:
	run browseld.p ("code",
		"class" + CHR(1) +
		"parent"  + CHR(1) + "code",
		"Шаблоны SWIFT" + CHR(1) + 
		"Шаблоны SWIFT" + CHR(1) + Sender_ID + "*",
		?, "5") no-error.
	if keyfunc(lastkey) ne "end-error" then 
		do:
			find first code where code.code eq pick-value and code.class eq "Шаблоны SWIFT" and code.parent eq "Шаблоны SWIFT" no-lock no-error.
			if available code then do:
				SwiftTag57 = code.description[1].
				SwiftTag59Cor = code.description[2].
				SwiftTag70Cor = code.description[3].
				display SwiftTag20 cCur cSum SwiftTag50Cor SwiftTag52 SwiftTag56 SwiftTag57 SwiftTag59Cor SwiftTag70Cor SwiftTag71 with frame fSet2.	
			end.
		end.
	end.
end.

on f1 of frame fSet2 anywhere do:
	define frame fSet3 
		"Название: " User_Title help "Введите понятное Вам имя шаблона"
		with centered no-labels title "Сохранение шаблона".
	display User_Title with frame fSet3.
	set User_Title with frame fSet3.
	hide frame fset3.
	find last code where code.class eq "Шаблоны SWIFT" and code.parent eq "Шаблоны SWIFT" no-lock no-error.
	if available code then Sender_Code = Sender_ID + "|" + string (integer (entry (3, code.code, "|")) + 1). 
		else Sender_Code = Sender_ID + "|" + "1".
	create code.
	assign
		code.class = "Шаблоны SWIFT"
		code.parent = "Шаблоны SWIFT"
		code.code = Sender_Code
		code.name = User_Title

		code.description[1]  = INPUT SwiftTag57
 		code.description[2]  = INPUT SwiftTag59Cor
		code.description[3]  = INPUT SwiftTag70Cor.
end.

display SwiftTag20 cCur cSum SwiftTag50Cor SwiftTag52 SwiftTag56 SwiftTag57 SwiftTag59Cor SwiftTag70Cor SwiftTag71 with frame fSet2.
set SwiftTag20 SwiftTag50Cor SwiftTag56 SwiftTag57 SwiftTag59Cor SwiftTag70Cor SwiftTag71  with frame fSet2.

Hide frame fset2.

SwiftTag20 = ":20:IBPMMXXX" + SwiftTag20.
if trim(SwiftTag50Cor) ne "" then SwiftTag50Cor = ":50F:/" + trim(SwiftTag50Cor).
SwiftTag52 = "A=" + SwiftTag52.
/*SwiftTag56 = "A=" + SwiftTag56.
SwiftTag57 = "A=" + SwiftTag57.*/
if SwiftTag59Cor ne "" then SwiftTag59Cor = ":59:/" + SwiftTag59Cor.
if SwiftTag70Cor ne "" then SwiftTag70Cor = ":70:" + SwiftTag70Cor.
SwiftTag71 = ":71:A=" + SwiftTag71.

SwiftTag57 = wrapit(SwiftTag57).
SwiftTag59Cor = translitit(wrapit(SwiftTag59Cor)).
SwiftTag70Cor = translitit(wrapit(SwiftTag70Cor)).

pirSwift[1] = SwiftTag20.
pirSwift[2] = SwiftTag32.
pirSwift[3] = SwiftTag33.
pirSwift[4] = SwiftTag50Cor.
pirSwift[5] = SwiftTag52.
pirSwift[6] = SwiftTag56.
pirSwift[7] = SwiftTag57.
pirSwift[8] = SwiftTag59Cor.
pirSwift[9] = SwiftTag70Cor.
pirSwift[10] = SwiftTag71.
pirSwift[11] = SwiftTag72.

/* Следующие строки для того, чтобы при множественном экспорте не тянулись данные из предыдущего свифта */
SwiftTag56 = "".
SwiftTag57 = "".
SwiftTag59Cor = "".
SwiftTag70Cor = "". 
SwiftTag71 = "".
SwiftTag72 = "".

Do iNum = 1 to num-entries(rSwiftTag):
	updateSigns(rClass, rSurrogate, "pirSwift" + entry(iNum,rSwiftTag), pirSwift[iNum], YES).
end. 
