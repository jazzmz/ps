{globals.i}

{intrface.get xclass}   /* Функции работы с метасхемой */
{intrface.get count}

{tmprecid.def}

/*****************************************************
 * Контроллер сохранения платежных                   *
 * документов в файлы формата SVG.                   *
 *  Алгоритм работы:                                 *
 *   1. Выбираем документы подлежащие                *
 * сохранению в архив;                               *
 *   2. По всей tmprecid;                            *
 *   3. Создаем объект типа TPaymentOrder;           *
 *   4. Формируем документы по шаблону pp.svg;       *
 *   5. Выводим итоговый результат в файл            *
 *   по пути cPath с именем ID документа.            *
 *****************************************************
 * Дата создания: .......                            *
 * Автор: Маслов Д. А.                               *
 * Заявка: #381                                      *
 *****************************************************/

/**********
 * Модели *
 **********/
DEF VAR oSysClass     AS TSysClass     NO-UNDO.
DEF VAR oPaymentOrder AS TPaymentOrder NO-UNDO.
DEF VAR oCharacter    AS TCharacter    NO-UNDO.
DEF VAR oTpl1         AS TTpl          NO-UNDO.
DEF VAR oDTInput      AS TDTInput      NO-UNDO.
DEF VAR oSysClass1    AS TSysClass     NO-UNDO.


/**************************
 * Внутренние переменные  *
 * контроллера            *
 **************************/
DEF VAR i AS INTEGER                 NO-UNDO.
DEF VAR amtstr AS CHARACTER EXTENT 2 NO-UNDO.
DEF VAR Rub AS CHARACTER INITIAL ""  NO-UNDO.
DEF VAR archDate AS DATE             NO-UNDO.

DEF VAR oEra     AS TEra    NO-UNDO.
DEF VAR oConfig  AS TAArray NO-UNDO.
DEF VAR currDate AS DATE    NO-UNDO.

DEF VAR iRes AS INT64 NO-UNDO.


oConfig = NEW TAArray().
oEra    = NEW TEra(TRUE).

currDate = gend-date.

/************************
 * Переменные настройки *
 ************************/
DEF VAR cEncoding AS CHARACTER INITIAL "utf-8" NO-UNDO.

DEF BUFFER bop FOR op.


oSysClass = NEW TSysClass().

/******************************
 * Подготавливаем каталог     *
 * для сохранения.            *
 ******************************/

IF gend-date <> ? THEN archDate = gend-date.
		  ELSE
		     DO:
			oDTInput = new TDTInput(3).
			  oDTInput:X = 250.
			  oDTInput:Y = 50.
			  oDTInput:head = "Дата архива".
			  oDTInput:show().
			  archDate = oDTInput:beg-date.
			DELETE OBJECT oDTInput.
		     END.

/**********
 * Проверяем корректность исполнителей *
 **********/

{pir-chk-sin-cnt.i &cr="2"}

oConfig:setH("taxon","fin po bk rez").
oConfig:setH("opdate",oSysClass:DATETIME2STR(currDate,"%Y-%m-%d")).
oConfig:setH("expn",iCurrOut).
oConfig:setH("author",curr-user-id).
oConfig:setH("inspector",curr-user-inspector).
oConfig:setH("fext","svg").




/********************************
 *
 * В связи с переходом на единую
 * систему хранения ДЭВ 
 * файлы складываем "под ноги".
 *
 *********************************
 * Автор: Маслов Д. А.
 * Дата создания: 09.11.11
 *********************************/
/*cPath = cRootPath + oSysClass:DATETIME2STR(archDate,"%Y-%m-%d") + "/md/" + curr-user-inspector.*/
cPath = "./_spool1.tmp".

/****** КОНЕЦ КАТАЛОГ *********/

/********** ДАННЫЕ ДЛЯ ИТОГОВОГО ОТЧЕТА ****************/
{tpl.create}

DEF VAR oTable AS TTable            NO-UNDO.

DEF VAR iCount AS INTEGER INITIAL 0 NO-UNDO.
DEF VAR dSum   AS DECIMAL INITIAL 0 NO-UNDO.

/***********  КОНЕЦ ДАННЫХ ДЛЯ ОТЧЕТА ******************/

/*** ВЫПОЛНЯЕМ ИНИЦИАЛИЗАЦИЮ СЧЕТЧИКА ***/

DEF VAR vLnCountInt AS INTEGER NO-UNDO. /* Счетчик договоров */
DEF VAR vLnTotalInt AS INTEGER NO-UNDO. /* Общее количество договоров */

  {init-bar.i "Обработка документов"}

   FOR EACH tmprecid NO-LOCK:
		ACCUMULATE tmprecid.id (COUNT).
   END.

vLnTotalInt = (ACCUM COUNT tmprecid.id).

/*** КОНЕЦ ИНИЦИАЛИЗАЦИИ СЧЕТЧИКА ***/

                                            
FOR EACH tmprecid,
  FIRST bop WHERE RECID(bop) EQ tmprecid.id NO-LOCK:
 
    

    oTpl1 = new TTpl("pp.svg").

    oTpl1:encoding = cEncoding.
    oTpl1:splitter = "|".

    oPaymentOrder = new TPaymentOrder(BUFFER bOp:HANDLE).
    
    IF CAN-DO("40807*,40820*,42601*",oPaymentOrder:acct-db) OR CAN-DO("40807*,40820*,42601*",oPaymentOrder:acct-cr) THEN DO:
        oConfig:setH("taxon","fin po bk nerez").
    END. ELSE DO:
        oConfig:setH("taxon","fin po bk rez").
    END.

    /***
     * Здесь устанавливаем номер документа.
     * И класс документа.
     ***/    
    oConfig:setH("num",oPaymentOrder:doc-num).
    

    iCount = iCount + 1.
    dSum = dSum + oPaymentOrder:sum.

    oTpl1:addAnchorValue("num",oPaymentOrder:doc-num).
    oTpl1:addAnchorValue("op-ins",oPaymentOrder:DocDate).
    oTpl1:addAnchorValue("op-date",oPaymentOrder:ins-date).
    oTpl1:addAnchorValue("op-type",oPaymentOrder:type).

    oTpl1:addAnchorValue("order-pay",oPaymentOrder:order-pay).
    oTpl1:addAnchorValue("type-op",oPaymentOrder:cb-type).
    oTpl1:addAnchorValue("doc-date",oPaymentOrder:doc-date).
    oTpl1:addAnchorValue("statuspok",oPaymentOrder:statuspok).
    
    /* Заполняем плательщика */
 RUN x-amtstr.p(oPaymentOrder:sum,'',TRUE,TRUE, OUTPUT amtstr[1], OUTPUT amtstr[2]).
 IF TRUNC(oPaymentOrder:sum, 0) = oPaymentOrder:sum THEN
    ASSIGN
      Rub       = STRING(STRING(oPaymentOrder:sum * 100, "-zzzzzzzzzz999"), "x(12)=")
      AmtStr[2] = ''
    .
  ELSE
    ASSIGN
      Rub       = STRING(STRING(oPaymentOrder:sum * 100, "-zzzzzzzzzz999"), "x(12)-x(2)")
      AmtStr[1] = AmtStr[1] + ' ' + AmtStr[2]
    .
  SUBSTR(AmtStr[1], 1, 1) = CAPS(SUBSTR(AmtStr[1], 1, 1)).
  oTpl1:addAnchorValue("sum",Rub).

 oCharacter = new TCharacter(amtstr[1]).
    oCharacter:width = 65.
    oCharacter:align="left".
     DO i = 1 TO 2:
      oTpl1:addAnchorValue("sum-" + STRING(i),oCharacter:getValue(i)).
     END.
     DELETE OBJECT oCharacter.     

    oCharacter = new TCharacter(oPaymentOrder:name-send).
    oCharacter:width = 45.
    oCharacter:align="left".
     DO i = 1 TO 3:
      oTpl1:addAnchorValue("name-short-send" + STRING(i),oCharacter:getValue(i)).
     END.
     DELETE OBJECT oCharacter.     
     
    oTpl1:addAnchorValue("acct-send",oPaymentOrder:acct-send).
    oTpl1:addAnchorValue("inn-send",oPaymentOrder:inn-send).
    oTpl1:addAnchorValue("kpp-send",oPaymentOrder:kpp-send).
    
    /* Заполняем банк плательщика */
    oCharacter = new TCharacter(oPaymentOrder:bank-name-send).
    oCharacter:width = 45.
    oCharacter:align = "left".
    DO i=1 TO 3 :
      oTpl1:addAnchorValue("name-bank-send" + STRING(i),oCharacter:getValue(i)).
    END.
      DELETE OBJECT oCharacter.
      
    oTpl1:addAnchorValue("bic-send",oPaymentOrder:bank-bic-send).
    oTpl1:addAnchorValue("acct-bank-send",oPaymentOrder:bank-acct-send).
   
    /* Заполняем получателя */
    oCharacter = new TCharacter(oPaymentOrder:name-rec).
    oCharacter:width = 45.
    oCharacter:align = "left".
     DO i=1 TO 3 :     
       oTpl1:addAnchorValue("name-short-rec" + STRING(i),oCharacter:getValue(i))
       .
     END.
     DELETE OBJECT oCharacter.
     
    oTpl1:addAnchorValue("acct-rec",oPaymentOrder:acct-rec).
    oTpl1:addAnchorValue("inn-rec",oPaymentOrder:inn-rec).
    oTpl1:addAnchorValue("kpp-rec",oPaymentOrder:kpp-rec).

    /* Заполняем банк получателя */
    oCharacter = new TCharacter(oPaymentOrder:bank-name-rec).
    oCharacter:width = 45.
    oCharacter:align = "left".
     DO i=1 TO 3 :
        oTpl1:addAnchorValue("name-bank-rec" + STRING(i),oCharacter:getValue(i))
   .
    END.
     DELETE OBJECT oCharacter.

    oTpl1:addAnchorValue("bic-rec",oPaymentOrder:bank-bic-rec).
    oTpl1:addAnchorValue("acct-bank-rec",oPaymentOrder:bank-acct-rec).
    
    oCharacter = new TCharacter(oPaymentOrder:details).
    oCharacter:width = 90.
    oCharacter:align = "left".
     DO i=1 TO 3 :
      oTpl1:addAnchorValue("details" + STRING(i),oCharacter:getValue(i)).
     END.
     DELETE OBJECT oCharacter.
     
     /* Налоговые реквизиты */
     oTpl1:addAnchorValue("kbk",oPaymentOrder:kbk).
     oTpl1:addAnchorValue("okato",oPaymentOrder:okato).
     oTpl1:addAnchorValue("datepok",oPaymentOrder:datepok).
     oTpl1:addAnchorValue("nppok",oPaymentOrder:nppok).
     oTpl1:addAnchorValue("ndpok",oPaymentOrder:ndpok).
     oTpl1:addAnchorValue("oppok",oPaymentOrder:oppok).
     oTpl1:addAnchorValue("tppok",oPaymentOrder:tppok).

 
    /******************************************
     * Проверяем возможность записи в каталог .
     ******************************************
     * После перехода на новую систему хранения
     * пишем "под ноги" поэтому делать проверки
     * на возможность записи не нужно.
     *******************************************/

	    OUTPUT TO VALUE(cPath) CONVERT TARGET "utf-8".
	      oTpl1:show().
	    OUTPUT CLOSE.    

        
	   /*{send2arch.i &nomess=1 &arch2=1 &notmprecid=1 &f2a="\"./_spool1.tmp\""}*/
	   
	  /*****
	   * Если документ,
	   * отправлен в архив,
	   * то помечаем его 
	   * как отправленый.
	   *****/
	   iRes = oEra:addCustomDoc(oConfig,"_spool1.tmp"). 

	  IF  iRes > 0 THEN DO:
	      UpdateSignsEx('opb',STRING(oPaymentOrder:surrogate),"PirA2346U",STRING(iCurrOut)).
              UpdateSignsEx('op-entry',STRING(oPaymentOrder:surrogate) + "," + STRING(oPaymentOrder:getOpEntry4Order(1):numInDoc),"PirDEVLink",STRING(iRes)).
	  END.   

  
      DELETE OBJECT oPaymentOrder.
  	  DELETE OBJECT oTpl1.

         {move-bar.i
            vLnCountInt
            vLnTotalInt
          }

           vLnCountInt = vLnCountInt + 1.

END. /* FOR EACH tmprecid */

/*****************************
 * Конец формирования отчета *
 ******************************/

/**********************
 *   Формируем отчет  *
 **********************/


oTable = new TTable(2).

 oTable:addRow().
  oTable:addCell(iCount).
  oTable:addCell(dSum).
oTpl:addAnchorValue("TABLE1",oTable).

{setdest.i}
 {tpl.show}

DELETE OBJECT oTable.
{tpl.delete}


DELETE OBJECT oSysClass.
DELETE OBJECT oConfig.
DELETE OBJECT oEra.
{intrface.del}
RETURN.
