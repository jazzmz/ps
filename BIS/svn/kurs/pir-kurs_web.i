Function	Web_Set_Rates returns character
		(input iUBuy  as decimal,
		input iUSell as decimal,
		input iEBuy  as decimal,
		input iESell as decimal).


	define var oTpl as TTpl no-undo.

	oTpl = new TTpl("pir-kurs_web.tpl").
	oTpl:addAnchorValue("Date", string(today,"99.99.99")).
	oTpl:addAnchorValue("Time", string(time,"hh:mm")).
	oTpl:addAnchorValue("USDBuy", string(iUBuy,"99.99")).
	oTpl:addAnchorValue("USDSell", string(iUSell,"99.99")).
	oTpl:addAnchorValue("EURBuy", string(iEBuy,"99.99")).
	oTpl:addAnchorValue("EURSell", string(iESell,"99.99")).
	output to value("curs.xml") convert target "UTF-8".
	oTpl:show().
	delete object oTpl.
	os-command silent value ('scp curs.xml mover@www.pirbank.ru:/usr/local/www/www.pirbank.ru/htdocs/ru/tmp/curs.xml').
	os-command silent value ('rm curs.xml').
End Function.
