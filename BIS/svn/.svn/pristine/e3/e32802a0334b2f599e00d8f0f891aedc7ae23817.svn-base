{globals.i}
def var osr as char no-undo.
def var drcoun as char.
def var dr as char no-undo.

define temp-table tmpt  
		field idd as char
		field tk as char
		field loc as char
		field name-shortt as char
.
 
for each cust-corp NO-LOCK:
	for each country NO-LOCK:
                drcoun = getXAttrValueEx("country", country.country-id , "НеРаскрытиеИнф", "").
		if drcoun eq "Да" then do:
		/*ищем в осн. реках*/
		/*message string(cust-corp.country-id). pause.*/
		if cust-corp.country-id = country.country-id then do:
			find first tmpt where tmpt.idd = string(cust-corp.cust-id) no-lock no-error.
			if not avail(tmpt) then do:
				create tmpt.
				tmpt.idd = string(cust-corp.cust-id).		
				tmpt.name-shortt = cust-corp.name-short.
				tmpt.tk = "cust-corp".
				tmpt.loc = "osr=Код страны = " + country.country-id.
			end.		
		end.	
		for each xattr where xattr.Class-Code EQ 'cust-corp' NO-LOCK:
			/*message string(xattr.System) xattr.Xattr-Code. pause.*/
			/*ищем в доп.реках*/
			if string(xattr.System) <> "yes" then do:
				dr = GetXAttrValueEx("cust-corp",string(cust-corp.cust-id),xattr.Xattr-Code,"").
				if dr <> "" then do: 
				/*message string(cust-corp.cust-id) + xattr.Xattr-Code + "=" + dr + string(Country.currency). pause.*/
				if (dr matches "*" + string(Country.country-id) + "*") or
				   (dr matches "*" + string(Country.country-alt-id) + "*") or
				   (dr matches "*" + Country.country-name + "*") or
				   (dr matches "*" + entry(1,Country.country-name,",") + "*") or
				   (dr matches "*" + string(Country.currency) + "*") then do:
					/*message "типа поймал" string(cust-corp.cust-id) + xattr.Xattr-Code + "=" + dr. pause.*/
                                	find first tmpt where tmpt.idd = string(cust-corp.cust-id) no-lock no-error.
					if not avail(tmpt) then do:
						create tmpt.
						tmpt.idd = string(cust-corp.cust-id).		
						tmpt.name-shortt = cust-corp.name-short.
						tmpt.tk = "cust-corp".
						tmpt.loc = "dr=" + string(xattr.Xattr-Code) + "=" + dr.
					end.		
				end.
				end.
			end.
		end.
		end.
	end.
end.

for each person NO-LOCK:
	for each country NO-LOCK:
                drcoun = getXAttrValueEx("country", country.country-id , "НеРаскрытиеИнф", "").
		if drcoun eq "Да" then do:
		if person.country-id = country.country-id then do:
			find first tmpt where tmpt.idd = string(person.person-id) no-lock no-error.
			if not avail(tmpt) then do:
				create tmpt.
				tmpt.idd = string(person.person-id).		
				tmpt.name-shortt = person.name-last.
				tmpt.tk = "person".
				tmpt.loc = "osr".
			end.		
		end.	
		for each xattr where xattr.Class-Code EQ 'person' NO-LOCK:
			if string(xattr.System) <> "yes" then do:
				dr = GetXAttrValueEx("person",string(person.person-id),xattr.Xattr-Code,"").
				if dr <> "" then do: 
				if (dr matches "*" + string(Country.country-id) + "*") or
				   (dr matches "*" + string(Country.country-alt-id) + "*") or
				   (dr matches "*" + Country.country-name + "*") or
				   (dr matches "*" + entry(1,Country.country-name,",") + "*") or
				   (dr matches "*" + string(Country.currency) + "*") then do:
					find first tmpt where tmpt.idd = string(person.person-id) no-lock no-error.
					if not avail(tmpt) then do:
						create tmpt.
						tmpt.idd = string(person.person-id).		
						tmpt.name-shortt = person.name-last.
						tmpt.tk = "person".
						tmpt.loc = "dr=" + string(xattr.Xattr-Code) + "=" + dr.
					end.		
				end.
				end.
			end.
		end.
		end.
	end.
end.

{setdest.i}
find first tmpt NO-LOCK no-error.
if not avail(tmpt) then do:
	put unformatted "ничего не нашел" skip.
end.

for each tmpt NO-LOCK:
	put unformatted tmpt.idd + ";" + tmpt.name-shortt + ";" + tmpt.tk + ";" + tmpt.loc skip.
end.
{preview.i}
