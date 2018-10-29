/* ООО "ПИР Банк" Управление автоматизации 2013г.	*/
/* p-шка нужна для инициального копирования             */
/* существующих допреков в новые допреки-клоны.		*/
/* Дальнейшая актуальность клонов поддерживается	*/
/* процедурой pir-cprek, вешаемой на метод chkupd	*/
/* требуемого допрека-отца.                         	*/
/* Сделано для выведения анкет клиентов на отдельные 	*/
/* дополнительные реквизиты				*/
/* Гончаров А.Е. 11.06.2013				*/

{globals.i}
{intrface.get xclass}

for each cust-corp no-lock:
	for each signs where signs.file-name = "cust-corp" and signs.surrogate eq string(cust-corp.cust-id) no-lock:
		if can-find (first xattr where xattr-code eq "pir-e-" + signs.code) then do:
			UpdateSigns ("cust-corp", string(cust-corp.cust-id), "pir-e-" + string(signs.code), string(GetXAttrValue("cust-corp", string(cust-corp.cust-id), string(signs.code))), YES).
		end.
	end.
	for each tmpsigns where tmpsigns.file-name = "cust-corp" and tmpsigns.surrogate eq string(cust-corp.cust-id) no-lock:
		if can-find (first xattr where xattr-code eq "pir-e-" + tmpsigns.code) then do:
			UpdateTempSigns ("cust-corp", string(cust-corp.cust-id), "pir-e-" + string(tmpsigns.code), string(GetTempXAttrValueEx("cust-corp", string(cust-corp.cust-id), string(tmpsigns.code),today,"")), YES).
		end.
	end.
end.

for each person no-lock:
	for each signs where signs.file-name = "person" and signs.surrogate eq string(person.person-id) no-lock:
		if can-find (first xattr where xattr-code eq "pir-e-" + signs.code) then do:
			UpdateSigns ("person", string(person.person-id), "pir-e-" + string(signs.code), string(GetXAttrValue("person", string(person.person-id), string(signs.code))), YES).
		end.
	end.
	for each tmpsigns where tmpsigns.file-name = "person" and tmpsigns.surrogate eq string(person.person-id) no-lock:
		if can-find (first xattr where xattr-code eq "pir-e-" + tmpsigns.code) then do:
			UpdateTempSigns ("person", string(person.person-id), "pir-e-" + string(tmpsigns.code), string(GetTempXAttrValueEx("person", string(person.person-id), string(tmpsigns.code),today,"")), YES).
		end.
	end.
end.

for each banks no-lock:
	for each signs where signs.file-name = "banks" and signs.surrogate eq string(banks.bank-id) no-lock:
		if can-find (first xattr where xattr-code eq "pir-e-" + signs.code) then do:
				UpdateSigns ("banks", string(banks.bank-id), "pir-e-" + string(signs.code), string(GetXAttrValue("banks", string(banks.bank-id), string(signs.code))), YES).
		end.
	end.
	for each tmpsigns where tmpsigns.file-name = "banks" and tmpsigns.surrogate eq string(banks.bank-id) no-lock:
		if can-find (first xattr where xattr-code eq "pir-e-" + tmpsigns.code) then do:
			UpdateTempSigns ("banks", string(banks.bank-id), "pir-e-" + string(tmpsigns.code), string(GetTempXAttrValueEx("banks", string(banks.bank-id), string(tmpsigns.code),today,"")), YES).
		end.
	end.
end. 
