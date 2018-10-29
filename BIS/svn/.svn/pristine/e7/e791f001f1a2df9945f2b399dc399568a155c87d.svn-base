function convstatus returns character (input iStatus as character).
	define variable tStatus as character init "" no-undo.
	case iStatus:
		when "0" then tStatus = "Новый".
		when "1" then tStatus = "Подписан".
		when "2" then tStatus = "Доставлен".
		when "3" then tStatus = "На обработке".
		when "4" then tStatus = "На исполнении".
		when "5" then tStatus = "Исполнен".
		when "6" then tStatus = "Отвергнут".
		when "7" then tStatus = "Удалён".
		when "8" then tStatus = "На согласовании".
		when "9" then tStatus = "На подготовке".
		when "10" then tStatus = "Подготовлен банком".
		otherwise tStatus = iStatus.
	end case.
	return tStatus.
end.

function kbdate returns character (input tdate as date).
	return string(month(tdate),"99") + "." + string(day(tdate),"99") + "." + string(year(tdate),"9999").
end.
