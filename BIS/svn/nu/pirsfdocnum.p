{pirsavelog.p}

/**

	Процедура изменения номера счета фактуры.
	Бурягин Е.П., 12.01.2007 14:42
	
	Запускается из картотеки счетов-фактур
	
	Modified: 17.01.2007 14:58 Buryagin 
						Добавил изменение наименование первой услуги в списке.
	
*/

{globals.i}

{tmprecid.def} /** Объявление использования глобальной временной таблицы выделенных в броузере записей */

DEF VAR new-doc-num AS CHAR LABEL "Новый номер".
DEF VAR new-serv-name AS CHAR LABEL "Ценность/услуга" VIEW-AS EDITOR SIZE 40 BY 5.
DEF BUFFER inLoan FOR loan.

pause 0.

FOR EACH tmprecid NO-LOCK,
		FIRST loan WHERE RECID(loan) = tmprecid.id,
		EACH term-obl OF loan NO-LOCK
	:
		
		/** Найдем доп реквизит "Описание" класса term-obl-sf */


/*		message GetXattrVAlueEx("term-obl",
                                                      term-obl.contract         + ","
                                 + term-obl.cont-code        + ","
                                 + STRING(term-obl.idnt)     + ","
                                 + STRING(term-obl.end-date) + ","
                                 + STRING(term-obl.nn)    ,
                           "Описание",
                           "") VIEW-AS ALERT-BOX.*/


		FIND FIRST signs WHERE 
			code = "Описание" 
			AND 
			file-name = "term-obl"
			AND
			surrogate =  term-obl.contract         + ","
                                 + term-obl.cont-code        + ","
                                 + STRING(term-obl.idnt)     + ","
                                 + STRING(term-obl.end-date) + ","
                                 + STRING(term-obl.nn)

/* BEGINS (loan.contract + "," + loan.cont-code)*/

			NO-ERROR.
		IF AVAIL signs THEN
			new-serv-name = signs.xattr-value.
		ELSE
			DO:
				FIND FIRST asset WHERE asset.cont-type = term-obl.symbol NO-LOCK NO-ERROR.
				IF AVAIL asset THEN 
						new-serv-name = asset.name.
			END.
		
		new-doc-num = loan.doc-num.
			
		/** Выводим форму */
		DISPLAY loan.doc-num SKIP 
						loan.open-date SKIP 
						loan.conf-date SKIP 
						new-doc-num SKIP
						new-serv-name SKIP
						loan.l-int-date LABEL "Плановая дата" SKIP
						term-obl.amt-rub FORMAT "->>,>>>,>>>,>>9.99" LABEL "Стоимость с НДС" skip
					        term-obl.int-amt FORMAT "->>,>>>,>>>,>>9.99" LABEL "Сумма НДС"  skip						
						WITH FRAME doc-num-frame SIDE-LABELS CENTERED OVERLAY.
		
		/** Редактирование значений в форме */
		SET new-doc-num new-serv-name loan.l-int-date WITH FRAME doc-num-frame.
		
		IF GetXAttrValueEx("loan", loan.contract + "," + loan.cont-code, "PIRNoRenum", "Нет") = "Нет" THEN
			DO:
			 	
			 	/** Найдем счета-факутры (принятые), которые созданы в момент списания комиссии по договорам.
			 	    Согласно 914-П их номера и даты должны соответствовать СФ выданным в момент оплаты */
			 	FOR EACH inLoan WHERE 
			 			inLoan.contract = "sf-in" 
			 			AND 
			 			inLoan.conf-date = loan.conf-date
			 			AND
			 			inLoan.doc-num = loan.doc-num
			 		:
			 			inLoan.doc-num = new-doc-num.
			 	END.
			 	loan.doc-num = new-doc-num.

			END.
		
		 
		/** Сохранение Описания услуги в доп.реквизит */
		IF AVAIL signs THEN 
				signs.xattr-value = new-serv-name.
		ELSE
			DO:
				CREATE signs.
				ASSIGN
					signs.code = "Описание"
					signs.file-name = "term-obl"
					signs.surrogate =    term-obl.contract         + ","
                                 + term-obl.cont-code        + ","
                                 + STRING(term-obl.idnt)     + ","
                                 + STRING(term-obl.end-date) + ","
                                 + STRING(term-obl.nn)

/*loan.contract + "," + loan.cont-code + ",1," + STRING(loan.open-date,"99/99/99") + ",1"*/
					signs.xattr-value = new-serv-name.				
			END.
		
END.

HIDE FRAME doc-num-frame.
