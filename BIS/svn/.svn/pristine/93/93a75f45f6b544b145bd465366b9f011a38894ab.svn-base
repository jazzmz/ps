{globals.i}
{norm.i}
{tmprecid.def}

DEFINE INPUT PARAMETER ipDataID  AS INTEGER NO-UNDO.
/*DEFINE INPUT PARAMETER ipIdent   AS INTEGER NO-UNDO.*/
DEFINE var IDOp   AS char NO-UNDO.
DEF VAR oTable 	AS TTable	NO-UNDO.
DEF VAR oTable2	AS TTable	NO-UNDO.
DEF VAR oTable3	AS TTable	NO-UNDO.
DEF VAR oTpl 	AS TTpl 	NO-UNDO.
DEF VAR VO 	AS char 	NO-UNDO.
DEFINE VAR ioTime as char label "Время" init "" NO-UNDO.
DEF VAR NumberS	AS char 	NO-UNDO.
DEF VAR DateS 	AS char 	NO-UNDO.


DEFINE BUFFER DataLinePL FOR DataLine.
DEFINE BUFFER DataLinePo FOR DataLine.
DEFINE BUFFER DataLinePPL FOR DataLine.
DEFINE BUFFER DataLinePPo FOR DataLine.
DEFINE BUFFER code_n FOR code.
DEFINE BUFFER code_p FOR code.

/*message "1" string(ipDataID) string(ipIdent).  pause.*/
FIND FIRST DataBlock WHERE DataBlock.Data-Id = ipDataID  NO-LOCK NO-ERROR.
FOR EACH tmprecid NO-LOCK,FIRST Dataline WHERE RECID(Dataline) = tmprecid.id and Dataline.Sym2 = "Общие данные"  NO-LOCK:
/*FOR EACH Dataline OF DataBlock where Dataline.Sym2 = "Общие данные" NO-LOCK:*/

        oTpl = new TTpl("pir-321soop-sd.tpl").
        oTable = new TTable(3).
        oTable2 = new TTable(4).
        oTable3 = new TTable(2).

	IDOp = Dataline.Sym1.
	VO =  Dataline.Sym3.
	message "Печатаем сообщение номер " DataLine.val[1] " код " VO " от " ENTRY(3, DataLine.Txt, "~n") view-as alert-box.
	NumberS = "№ " + string(DataLine.val[1]). 
	DateS = "от " + ENTRY(3, DataLine.Txt, "~n").

	oTable:addRow().
	oTable:addCell("Сведения о сделке").

	oTable:addRow().
	oTable:addCell("Вид операции (нужное поменить 'Х')").

	oTable:addRow().
	oTable:addCell("- сделка подлежит обязательному контролю").
	if VO ne "6001" then oTable:addCell("x").
	else oTable:addCell("").
	
	oTable:addRow().
	oTable:addCell("- сделка, в отношении которой возникают подозрения, что она осуществляется в целях легализации (отмывания) доходов, полученных преступным путем, или финансирования терроризма").
	if VO eq "6001" then oTable:addCell("x").
	else oTable:addCell("").

	oTable:addRow().
	oTable:addCell("Содержание сделки ").
	oTable:addCell(ENTRY(11, DataLine.Txt, "~n") + if ENTRY(12, DataLine.Txt, "~n") ne "0" then ENTRY(12, DataLine.Txt, "~n") else "").

	oTable:addRow().
	oTable:addCell("Дата сделки").
	oTable:addCell(string(date(ENTRY(9, DataLine.Txt, "~n")),"99/99/9999")).

	oTable:addRow().
	oTable:addCell("Валюта сделки").
	oTable:addCell(ENTRY(10, DataLine.Txt, "~n") + IF ENTRY(10, DataLine.Txt, "~n") EQ "643" THEN "" ELSE " / 643").

	oTable:addRow().
	oTable:addCell("Сумма сделки").
	oTable:addCell(IF ENTRY(10, DataLine.Txt, "~n") EQ "643" THEN TRIM(string(DataLine.Val[2],"->>>,>>>,>>>,>>>,>>9.99"))
			ELSE TRIM(string(DataLine.Val[3],   "->>>,>>>,>>>,>>>,>>9.99")) + " / " + 
				TRIM(string(DataLine.Val[2],   "->>>,>>>,>>>,>>>,>>9.99"))).

	oTable:addRow().
	oTable:addCell("Сведения о лице (лицах), участвующем (участвующих) в сделке").

	FIND FIRST DatalinePL where DatalinePL.Data-ID EQ ipDataID and DatalinePL.Sym2 eq "Плательщик" and DatalinePL.Sym1 eq Dataline.Sym1 
			NO-LOCK no-error.
	if avail DatalinePL then do:	
		oTable:addRow().
		oTable:addCell("Плательщик (лицо, совершающее сделку)").
		oTable:addCell(ENTRY(3, DataLinePL.Txt, "~n")).
	end.
	else do:
		oTable:addRow().
		oTable:addCell("Плательщик (лицо, совершающее сделку)").
		oTable:addCell("").
	end.
	FIND FIRST DatalinePo where DatalinePo.Data-ID EQ ipDataID and DatalinePo.Sym2 eq "Получатель" and DatalinePo.Sym1 eq Dataline.Sym1 
			NO-LOCK no-error.
        if avail DatalinePo then do:	
		oTable:addRow().
		oTable:addCell("Получатель").
		oTable:addCell(ENTRY(3, DataLinePo.Txt, "~n")).
        end.
	else do:
		oTable:addRow().
		oTable:addCell("Получатель").
		oTable:addCell("").
	end.

	oTable:addRow().
	oTable:addCell("Комментарии по сообщению, описание возникших затруднений при квалификации операции как операции, подлежащей обязательному контролю, или причины, по которым операция квалифицируется как подозрительная (пояснения по сути сообщения)").
	oTable:addCell(ENTRY(17, DataLine.Txt, "~n") + if ENTRY(18, DataLine.Txt, "~n") ne "0" then ENTRY(18, DataLine.Txt, "~n") else "").

	DEFINE VARIABLE mW AS char NO-UNDO
	VIEW-AS RADIO-SET RADIO-BUTTONS 
				"У2-2","У2-2",
				"У4","У-4",
				"У5","У-5",
				"У6","У-6",	
				"У7-3","У7-3",	
				"У8","У8",	
				"У9","У9",	
				"У10-1","У10-1",	
				"У10-2","У10-2",	
				"У11","У11",	
				"У12","У12",
				"У14","У14",
				"У15","У15",
				"У16","У16",
				"У17","У17",
				"пусто","-"
    	LABEL " Подразделения ".

   	DO ON ERROR  UNDO, LEAVE
	      ON ENDKEY UNDO, LEAVE WITH FRAME wow:
	      UPDATE mW GO-ON (RETURN)
	         WITH FRAME wow CENTERED OVERLAY ROW 10 SIDE-LABELS TITLE
	         COLOR bright-white "[ Выберите подразделение ]".
	END.
	HIDE FRAME wow NO-PAUSE.
	if lastkey eq 27 then do:
		HIDE FRAME wow.
		return.
	end.     

	oTable:addRow().
	oTable:addCell("Сведения о подразделении, составившем сообщение: " + mW).

	oTable:addRow().
	oTable:addCell("Отметка сотрудника отдела ПОД/ФТ, составившего ОЭС").  


	DEF VAR date_p AS char format "99/99/9999" LABEL "Дата ОЭС" VIEW-AS FILL-IN NO-UNDO.
	DEF VAR time_p AS char format "99:99" LABEL "Время ОЭС" VIEW-AS FILL-IN NO-UNDO.
	SET date_p time_p WITH FRAME frmTmp3 OVERLAY CENTERED.
        HIDE FRAME frmTmp3.

	oTable:addRow().
	oTable:addCell("Дата, время").  
	oTable:addCell(string(date_p,"99/99/9999") + " " + string(time_p,"99:99")).

	find first _user where _user._UserID eq USERID("bisquit") no-lock no-error.
	oTable:addRow().
	oTable:addCell("Должность").  
	oTable:addCell(GetXAttrValueEx("_user", _user._userid, "Должность", "")).

	oTable:addRow().
	oTable:addCell("Ф.И.О. / подпись").  
	oTable:addCell(_user._User-Name + " / ").

	oTable:addRow().
	oTable:addCell("Отметка Ответственного сотрудника о принятом решении").  

	find first code where code.class eq "ОпОтмыв" and code.code eq VO no-lock no-error. 
	if avail code then do:
		if VO eq "6001" and ENTRY(8, DataLine.Txt, "~n") eq "0" and ENTRY(16, DataLine.Txt, "~n") ne "0" then do:
			find first code_n where code_n.class eq "ОпНеобыч" and code_n.code eq ENTRY(16, DataLine.Txt, "~n") no-lock no-error. 
			oTable:addRow().
			oTable:addCell("Принято решение").  
/*			oTable:addCell("Представить сведения в УО о подозрительной операции/сделке в соотв. с п.3 ст.7 Закона 115-ФЗ по коду "
				        + VO + " " + string(code.description[1]) + ", признак кода " +
					ENTRY(16, DataLine.Txt, "~n") + code_n.name).
*/
			oTable:addCell("Представить сведения в УО о подозрительной операции/сделке в соотв. с п.3 ст.7 Закона 115-ФЗ по коду "
				        + VO + ", признак кода " + ENTRY(16, DataLine.Txt, "~n") ).
			oTable:addRow().
			oTable:addCell("Мотивированное обоснование решения о не направлении сведений об операции (сделке) в УО").  
			oTable:addCell("").
		end.
		if VO ne "6001" and VO ne "0" then do:
			if ENTRY(8, DataLine.Txt, "~n") eq "0" and ENTRY(16, DataLine.Txt, "~n") eq "0" then do:
        			oTable:addRow().
        			oTable:addCell("Принято решение").  
        			oTable:addCell("Представить сведения в УО об операции/сделке обязательного контроля в соотв. со ст.6 Закона 115-ФЗ по коду " 
						+ VO).
        			oTable:addRow().
        			oTable:addCell("Мотивированное обоснование решения о не направлении сведений об операции (сделке) в УО").  
        			oTable:addCell("").
			end.
			if ENTRY(8, DataLine.Txt, "~n") ne "0" and ENTRY(8, DataLine.Txt, "~n") ne VO 
					and ENTRY(16, DataLine.Txt, "~n") ne "6001" 
					and ENTRY(16, DataLine.Txt, "~n") eq "0" then do:
        			oTable:addRow().
        			oTable:addCell("Принято решение").  
        			oTable:addCell("Представить сведения в УО об операции/сделке обязательного контроля в соотв. со ст.6 Закона 115-ФЗ по кодам " 
						+ VO + ", " + ENTRY(8, DataLine.Txt, "~n")).
        			oTable:addRow().
        			oTable:addCell("Мотивированное обоснование решения о не направлении сведений об операции (сделке) в УО").  
        			oTable:addCell("").
			end.
			if ENTRY(8, DataLine.Txt, "~n") eq "6001" and ENTRY(16, DataLine.Txt, "~n") ne "0" then do:
        			oTable:addRow().
        			oTable:addCell("Принято решение").  
        			oTable:addCell("Представить сведения в УО об операции/сделке обязательного контроля в соотв. со ст.6 Закона 115-ФЗ по коду " 
						+ VO + 
						". Представить сведения в УО о подозрительной операции/сделке в соотв. с п.3 ст.7 Закона 115-ФЗ по коду 6001, признак кода "
						+ ENTRY(16, DataLine.Txt, "~n")).
        			oTable:addRow().
        			oTable:addCell("Мотивированное обоснование решения о не направлении сведений об операции (сделке) в УО").  
        			oTable:addCell("").
			end.
			if ENTRY(8, DataLine.Txt, "~n") ne "0" and ENTRY(8, DataLine.Txt, "~n") ne VO 
					and ENTRY(16, DataLine.Txt, "~n") ne "0" then do:
        			oTable:addRow().
        			oTable:addCell("Принято решение").  
        			oTable:addCell("Представить сведения в УО об операции/сделке обязательного контроля в соотв. со ст.6 Закона 115-ФЗ по кодам " 
						+ VO + " " + string(code.description[1]) + ", " + ENTRY(8, DataLine.Txt, "~n")).
        			oTable:addRow().
        			oTable:addCell("Мотивированное обоснование решения о не направлении сведений об операции (сделке) в УО").  
        			oTable:addCell("").
			end.
		end.
	end.
/*        if not avail code then do:
		oTable:addRow().
		oTable:addCell("Принято решение").  
		oTable:addCell("Код VO не найден").

		oTable:addRow().
		oTable:addCell("Мотивированное обоснование решения о не направлении сведений об операции (сделке) в УО").  
		oTable:addCell("").
	end.
*/
	if VO eq "0" and ENTRY(8, DataLine.Txt, "~n") eq "0" and ENTRY(16, DataLine.Txt, "~n") eq "0" then do:
		oTable:addRow().
		oTable:addCell("Принято решение").  
		oTable:addCell("Не представлять сведения в УО по данной операции/сделке в соотв. с Законом 115-ФЗ").
		DEF VAR Res_ne_nap AS CHAR LABEL "Мотивиованное решение о не направлении сведений" VIEW-AS EDITOR SIZE 70 BY 10 NO-UNDO. 

		def var Res_ne_nap1 as logical LABEL "1. Не подлежит обязательному контролю в соотв. со ст. 6 Закона № 115-ФЗ." VIEW-AS TOGGLE-BOX.
		def var Res_ne_nap2 as logical LABEL "2. Операция/сделка не является подозрительной в соотв. с п.3 ст. 7" VIEW-AS TOGGLE-BOX.
		def var Res_ne_nap2_1 as char init "      Закона 115-ФЗ." format "x(50)" VIEW-AS TEXT.
		def var Res_ne_nap3 as logical LABEL "3. Сведения об операции/сделке ранее _____ были направлены Банком по " VIEW-AS TOGGLE-BOX.
		def var Res_ne_nap3_1 as char init "      коду ______." format "x(50)" VIEW-AS TEXT.
		def var Res_ne_nap4 as logical LABEL "4. Требуется доп. время для квалификации операции/сделки." VIEW-AS TOGGLE-BOX.
		def var Res_ne_nap5 as logical LABEL "5. Иное. Ручной ввод" VIEW-AS TOGGLE-BOX.
		def var Res_ne_nap_all as char init "" no-undo.

		FORM Res_ne_nap1 
			Res_ne_nap2 
			Res_ne_nap2_1 no-label 
			Res_ne_nap3 
			Res_ne_nap3_1 no-label 
			Res_ne_nap4 skip 
			Res_ne_nap5 
			WITH FRAME frmj1 OVERLAY CENTERED.
			DO ON ERROR  UNDO,LEAVE ON ENDKEY UNDO,LEAVE: UPDATE Res_ne_nap1 Res_ne_nap2 Res_ne_nap2_1 Res_ne_nap3 Res_ne_nap3_1 
			Res_ne_nap4 Res_ne_nap5 GO-ON(ESC) WITH FRAME frmj1.
			if lastkey eq 27 then do: HIDE FRAME frmj1. return. end.  
		end.
		
		if Res_ne_nap5 then do:	
			SET Res_ne_nap WITH FRAME frmj1 OVERLAY CENTERED.	
		end.
		HIDE FRAME frmj1. 
		 
		if Res_ne_nap1 then Res_ne_nap_all = Res_ne_nap_all + "Не подлежит обязательному контролю в соотв. со ст. 6 Закона № 115-ФЗ.".
		if Res_ne_nap2 then Res_ne_nap_all = Res_ne_nap_all + "Операция/сделка не является подозрительной в соотв. с п.3 ст. 7 Закона 115-ФЗ.".
		if Res_ne_nap3 then Res_ne_nap_all = Res_ne_nap_all + "Сведения об операции/сделке ранее _______ были направлены Банком по коду ______.".
		if Res_ne_nap4 then Res_ne_nap_all = Res_ne_nap_all + "Требуется доп. время для квалификации операции/сделки.".
		if Res_ne_nap5 then Res_ne_nap_all = Res_ne_nap_all + Res_ne_nap.
		
		oTable:addRow().
		oTable:addCell("Мотивированное обоснование решения о не направлении сведений об операции (сделке) в УО").  
		oTable:addCell(Res_ne_nap_all).
	end.

	oTable:addRow().
	oTable:addCell("Дата принятия решения").  
	oTable:addCell(string(date(ENTRY(3, DataLine.Txt, "~n")),"99/99/9999")).

	DEFINE VARIABLE Podpis AS char NO-UNDO
	VIEW-AS RADIO-SET RADIO-BUTTONS 
				"Гаман Владимир Васильевич","Гаман Владимир Васильевич",
				"Михалева Светлана Валентиновна","Михалева Светлана Валентиновна",
				"Иное (вручную)","3"
    	LABEL " Подпись ".

   	DO ON ERROR  UNDO, LEAVE
	      ON ENDKEY UNDO, LEAVE WITH FRAME frmPodpis:
	      UPDATE Podpis GO-ON (RETURN)
	         WITH FRAME frmPodpis CENTERED OVERLAY ROW 10 SIDE-LABELS TITLE
	         COLOR bright-white "[ Выберите подпись ответственного сотрудника ]".
	END.

	DEF VAR Podpisr AS CHAR  VIEW-AS EDITOR SIZE 50 BY 2 NO-UNDO. 
	if Podpis eq "3" then do:
		SET Podpisr no-label WITH FRAME frmPodpisr OVERLAY CENTERED.	
		Podpis = Podpisr.
	end.

	if lastkey eq 27 then do:
		HIDE FRAME frmPodpis.
		return.
	end.     
	HIDE FRAME frmPodpisr NO-PAUSE.
	HIDE FRAME frmPodpis NO-PAUSE.
	
	oTable:addRow().
	oTable:addCell("Ф.И.О./Подпись").  
	oTable:addCell(Podpis + " / ").

/*	oTable:addRow().
	oTable:addCell("Решение Руководителя Банка").  
	oTable:addCell("").

	oTable:addRow().
	oTable:addCell("Подпись руководителя Банка").  
	oTable:addCell("").
*/
	if ENTRY(2, DataLine.Txt, "~n") eq "3" or ENTRY(3, DataLine.Txt, "~n") eq "4" then do:
		DEF VAR Zamena AS CHAR LABEL "Комментарий замены записи" VIEW-AS EDITOR SIZE 55 BY 10 NO-UNDO.
		SET Zamena WITH FRAME frmTmp2 OVERLAY CENTERED.
                oTable:addRow().
		oTable:addCell("Возможные замены записи (сообщения), удаление записи - комментарии и основания, номера и даты документов. Заносятся сотрудником подразделения ПОД/ФТ").  
		oTable:addCell(Zamena).
	end.
        if ENTRY(2, DataLine.Txt, "~n") eq "1" then do:
                oTable:addRow().
		oTable:addCell("Возможные замены записи (сообщения), удаление записи - комментарии и основания, номера и даты документов. Заносятся сотрудником подразделения ПОД/ФТ").  
		oTable:addCell("").
        end.

	FIND FIRST DatalinePPL where DatalinePPL.Data-ID EQ ipDataID and DatalinePPL.Sym2 eq "Пред. Плательщика" and DatalinePPL.Sym1 eq Dataline.Sym1 
			NO-LOCK no-error.
	FIND FIRST DatalinePPo where DatalinePPo.Data-ID EQ ipDataID and DatalinePPo.Sym2 eq "Пред. Получателя" and DatalinePPo.Sym1 eq Dataline.Sym1 
			NO-LOCK no-error.
        oTable2:addRow().
	oTable2:addCell("Сведения о представителе плательщика").  
	oTable2:addCell("").  
	oTable2:addCell("Сведения о представителе получателя").  
	oTable2:addCell("").  
        oTable2:addRow().
	oTable2:addCell("Ф.И.О./Наименование организации ").  
	if avail DatalinePPL then oTable2:addCell(if ENTRY(3, DataLinePPL.Txt, "~n") ne "0" then ENTRY(3, DataLinePPL.Txt, "~n") else "-"). 
	else oTable2:addCell("-").
	oTable2:addCell("Ф.И.О./Наименование организации ").  
	if avail DatalinePPo then oTable2:addCell(if ENTRY(3, DataLinePPo.Txt, "~n") ne "0" then ENTRY(3, DataLinePPo.Txt, "~n") else "-"). 
	else oTable2:addCell("-").

        oTable2:addRow().
	oTable2:addCell("ИНН").  
	if avail DatalinePPL then 
		oTable2:addCell(if ENTRY(23, DataLinePPL.Txt, "~n") ne "0" then ENTRY(23, DataLinePPL.Txt, "~n") else "-").
	else oTable2:addCell("-").
	oTable2:addCell("ИНН").  
	if avail DatalinePPo then 
		oTable2:addCell(if ENTRY(23, DataLinePPo.Txt, "~n") ne "0" then ENTRY(23, DataLinePPo.Txt, "~n") else "-").
	else oTable2:addCell("-").

	if avail DatalinePPL then do:
        	def var pasport as char no-undo.
        	find first code_p where code_p.class EQ "КодДокум" and code_p.val eq ENTRY(20, DataLinePPL.Txt, "~n") no-lock no-error.
                pasport = "".
        	if avail code_p  then do:
                	pasport = code_p.name + " " + ENTRY(21, DataLinePPL.Txt, "~n") + " " + ENTRY(24, DataLinePPL.Txt, "~n") + 
        			" " + ENTRY(25, DataLinePPL.Txt, "~n") + " " + ENTRY(26, DataLinePPL.Txt, "~n") + " ". 
        	end.
        	else pasport = "".
	end.
        oTable2:addRow().
	oTable2:addCell("Данные документа, удостоверяющего личность,/ОГРН").  
	if avail DatalinePPL then 
		oTable2:addCell(pasport + if ENTRY(22, DataLinePPL.Txt, "~n") ne "0" then ENTRY(22, DataLinePPL.Txt, "~n") else "-"). 
	else oTable2:addCell("-").

	if avail DatalinePPo then do:
        	find first code_p where code_p.class EQ "КодДокум" and code_p.val eq ENTRY(20, DataLinePPo.Txt, "~n") no-lock no-error.
                pasport = "".
        	if avail code_p then do:
        	        pasport = code_p.name + " " + ENTRY(21, DataLinePPo.Txt, "~n") + " " + ENTRY(24, DataLinePPo.Txt, "~n") + 
        			" " + ENTRY(25, DataLinePPo.Txt, "~n") + " " + ENTRY(26, DataLinePPo.Txt, "~n") + " ".
        	end.
        	else pasport = "".
	end.

	oTable2:addCell("Данные документа, удостоверяющего личность,/ОГРН").  
	if avail DatalinePPo then
		oTable2:addCell(pasport + if ENTRY(22, DataLinePPo.Txt, "~n") ne "0" then ENTRY(22, DataLinePPo.Txt, "~n") else "-"). 
	else oTable2:addCell("-"). 

        def var adres as char no-undo.
	if avail DatalinePPL then do:
        	adres = "".
                if ENTRY(4, DataLinePPL.Txt, "~n") ne "0" then 
        	adres = "Код страны:" + ENTRY(4, DataLinePPL.Txt, "~n") + ",".
                if ENTRY(6, DataLinePPL.Txt, "~n") ne "0" then 
        	adres = adres + " Код субъекта:" + ENTRY(6, DataLinePPL.Txt, "~n") + ",".
                if ENTRY(7, DataLinePPL.Txt, "~n") ne "0" then 
        	adres = adres + " Район (регион):" + ENTRY(7, DataLinePPL.Txt, "~n") + ",".
                if ENTRY(8, DataLinePPL.Txt, "~n") ne "0" then 
        	adres = adres + " Населенный пункт:" + ENTRY(8, DataLinePPL.Txt, "~n") + ",".
                if ENTRY(9, DataLinePPL.Txt, "~n") ne "0" then 
        	adres = adres + " Улица:" + ENTRY(9, DataLinePPL.Txt, "~n") + ",".
                if ENTRY(10, DataLinePPL.Txt, "~n") ne "0" then
        	adres = adres + " Дом:" + ENTRY(10, DataLinePPL.Txt, "~n") + ",".
                if ENTRY(11, DataLinePPL.Txt, "~n") ne "0" then
        	adres = adres + " Корп.:" + ENTRY(11, DataLinePPL.Txt, "~n") + ",".
                if ENTRY(12, DataLinePPL.Txt, "~n") ne "0" then
        	adres = adres + " Кв.:" + ENTRY(12, DataLinePPL.Txt, "~n").
	end.

	oTable2:addRow().
	oTable2:addCell("Адрес регистрации").  
	if avail DatalinePPL then oTable2:addCell(adres). else oTable2:addCell("-").

	if avail DatalinePPo then do:
        	adres = "".
                if ENTRY(4, DataLinePPo.Txt, "~n") ne "0" then 
        	adres = "Код страны:" + ENTRY(4, DataLinePPo.Txt, "~n") + ",".
                if ENTRY(6, DataLinePPo.Txt, "~n") ne "0" then 
        	adres = adres + " Код субъекта:" + ENTRY(6, DataLinePPo.Txt, "~n") + ",".
                if ENTRY(7, DataLinePPo.Txt, "~n") ne "0" then 
        	adres = adres + " Район (регион):" + ENTRY(7, DataLinePPo.Txt, "~n") + ",".
                if ENTRY(8, DataLinePPo.Txt, "~n") ne "0" then 
        	adres = adres + " Населенный пункт:" + ENTRY(8, DataLinePPo.Txt, "~n") + ",".
                if ENTRY(9, DataLinePPo.Txt, "~n") ne "0" then 
        	adres = adres + " Улица:" + ENTRY(9, DataLinePPo.Txt, "~n") + ",".
                if ENTRY(10, DataLinePPo.Txt, "~n") ne "0" then
        	adres = adres + " Дом:" + ENTRY(10, DataLinePPo.Txt, "~n") + ",".
                if ENTRY(11, DataLinePPo.Txt, "~n") ne "0" then
        	adres = adres + " Корп.:" + ENTRY(11, DataLinePPo.Txt, "~n") + ",".
                if ENTRY(12, DataLinePPo.Txt, "~n") ne "0" then
        	adres = adres + " Кв.:" + ENTRY(12, DataLinePPo.Txt, "~n").
        end.

	oTable2:addCell("Адрес регистрации").  
	if avail DatalinePPo then oTable2:addCell(adres). else oTable2:addCell("-"). 

        oTable2:addRow().
	oTable2:addCell("Плательщик - Клиент не клиент на дату операции").  
	oTable2:addCell(if string(DataLine.val[4]) eq "1" then "Клиент банка" else "-").
	oTable2:addCell("Получатель - Клиент не клиент на дату операции").  
	oTable2:addCell(if string(DataLine.val[5]) eq "1" then "Клиент банка" else "-").

        oTable3:addRow().
        oTable3:addCell("СООБЩЕНИЕ в целях исполнения требований Правил Внутреннего контроля в целях противодействия легализации 
        		(отмыванию) доходов, полученных преступным путем").

        oTable3:addRow().
        oTable3:addCell("Сведения о приостановленной операции").

        oTable3:addRow().
        oTable3:addCell("Дата платежного документа").
        oTable3:addCell("").

        oTable3:addRow().
        oTable3:addCell("Номер платежного документа").
        oTable3:addCell("").

        oTable3:addRow().
        oTable3:addCell("Сумма операции").
        oTable3:addCell("").

        oTable3:addRow().
        oTable3:addCell("Валюта проведения операции").
        oTable3:addCell("").

        oTable3:addRow().
        oTable3:addCell("Назначение платежа").
        oTable3:addCell("").

        oTable3:addRow().
        oTable3:addCell("Сведения о плательщике").
        oTable3:addCell("").

        oTable3:addRow().
        oTable3:addCell("ИНН плательщика").
        oTable3:addCell("").

        oTable3:addRow().
        oTable3:addCell("Номер счета плательщика").
        oTable3:addCell("").

        oTable3:addRow().
        oTable3:addCell("Сведения о получателе").
        oTable3:addCell("").

        oTable3:addRow().
        oTable3:addCell("ИНН получателя").
        oTable3:addCell("").

        oTable3:addRow().
        oTable3:addCell("Номер счета получателя").
        oTable3:addCell("").

        oTable3:addRow().
        oTable3:addCell("Сведения о третьем лице: Представителе, либо лице, по поручению которого проводится операция").
        oTable3:addCell("").

        oTable3:addRow().
        oTable3:addCell("сведения о принятых мерах").

        oTable3:addRow().
        oTable3:addCell("Дата приостановления").
        oTable3:addCell("").

        oTable3:addRow().
        oTable3:addCell("Дата направления электронного сообщения в ФСФМ").
        oTable3:addCell("").

        oTable3:addRow().
        oTable3:addCell("имя направленного файла").
        oTable3:addCell("").

        oTable3:addRow().
        oTable3:addCell("Предписания ФСФМ, полученные в ответ на электронное сообщение").
        oTable3:addCell("").

        oTable3:addRow().
        oTable3:addCell("Дата проведения операции").
        oTable3:addCell("").

        oTable3:addRow().
        oTable3:addCell("Примечания").
        oTable3:addCell("").
	
        oTpl:addAnchorValue("NumberS",NumberS).
        oTpl:addAnchorValue("DateS",DateS).
        oTpl:addAnchorValue("TABLE1",oTable).
        oTpl:addAnchorValue("TABLE2",oTable2).

/*      {setdest.i &cols=120 &custom = " IF YES THEN 200 ELSE "}*/
/*	{setdest.i &cols=120 &custom = "printer.page-line -"}*/
        {setdest.i &cols=135 &custom = " 2 * "}
/*        {setdest.i &cols=135}*/
/*	message "1" PAGE-SIZE LINE-COUNTER view-as alert-box.*/
            oTpl:show().
        {preview.i}

        DELETE OBJECT oTable3.
        DELETE OBJECT oTable2.
        DELETE OBJECT oTable.
        DELETE OBJECT oTpl.
end.	
