CLASS TOpEntry IMPLEMENTS IFinObj:
/**************************************
 *  Класс является представлением сущности "Проводка". 
 * Автор: Маслов Д. А.
 *  Дата создания: 25.04.2009
 * Дата модификации: 30.04.2009
***************************************/

/*** PROTECTED ПОЛЯ КЛАССА ***/

DEF PROTECTED BUFFER bOpEntry FOR op-entry.                        /* Таблица с проводками */

/*** PUBLIC СВОЙСТВА КЛАССА ***/

/* Свойста предоставляют доступ к полям класса */
{set-prop.i &aa="IdOp"       &bb="iidOp"       &cc="INTEGER" &perms="PROTECTED"}
{set-prop.i &aa="numInDoc"   &bb="inumInDoc"   &cc="INTEGER" &perms="PROTECTED"}
{set-prop.i &aa="kassSymbol" &bb="ikassSymbol" &cc="CHARACTER"}

{set-prop.i &aa="rusSum" &bb="drusSum"  &cc="DECIMAL"}
{set-prop.i &aa="inSum"  &bb="dinSum"   &cc="DECIMAL"}

{set-prop.i &aa="acct-db" &bb="cacct-db"   &cc="CHARACTER"}
{set-prop.i &aa="acct-cr" &bb="cacct-cr"   &cc="CHARACTER"}

{set-prop.i &aa="isInit"   &bb="lisInit"   &cc="LOGICAL"}
{set-prop.i &aa="type"     &bb="cType"     &cc="CHARACTER"}
{set-prop.i &aa="techPlat" &bb="cTechPlat" &cc="CHARACTER"}
{set-prop.i &aa="currency" &bb="cCurrency" &cc="CHARACTER"}

/*** АНАЛИТИКА ПРОВОДКИ ***/
{set-prop.i &aa="kau-db" &bb="cKauDB" &cc="CHARACTER"}
{set-prop.i &aa="kau-cr" &bb="cKauCr" &cc="CHARACTER"}


/*** PUBLIC Методы класса ***/

CONSTRUCTOR TOpEntry():
        /**************************************************
         * Пустой конструктор предполагаю использовать,   *
         * для создания новой проводки.                   *
         **************************************************/         
END CONSTRUCTOR.

CONSTRUCTOR TOpEntry(INPUT hOp AS HANDLE):

END CONSTRUCTOR.

CONSTRUCTOR TOpEntry(INPUT iOpId AS INTEGER,INPUT iOpEntry AS INTEGER):
/*
   Инициализируем проводку по номеру документа
   и  ее позиции в документе
*/
 iidOp=iOpId.
 inumInDoc=iOpEntry.

/* Вызываем инциализацию проводки по первичному ключу */

	 FIND FIRST bOpEntry WHERE bOpEntry.op=IdOp AND bOpEntry.op-entry=numInDoc NO-LOCK NO-ERROR.

         IF AVAILABLE(bOpEntry) THEN
             DO:
		fillOpEntry(BUFFER bOpEntry:HANDLE).
                isInit=true.
             END.
END CONSTRUCTOR.


METHOD PUBLIC LOGICAL add2DB():
/*
   Метод производит добавление проводки в таблицу БД.
   Предполгаю реализовать позже.
   Если добавление успешно завершилось, возвращает TRUE в противном случае FALSE.
*/
  RETURN YES.
END METHOD.

METHOD PUBLIC LOGICAL update2DB():
/*
  Метод изменяет существующую проводку.
  В случае успешно изменения возвращает TRUE, в противном случае FALSE.
*/
  RETURN YES.
END METHOD.

/* PRIVATE МЕТОДЫ КЛАССА */

METHOD PROTECTED VOID fillOpEntry(INPUT bOpEntryHandle AS HANDLE):
						/***********************************************
						 *					       *
						 * Заполняем свойства объекта из массива       *
						 *					       *
						  **********************************************/
         ASSIGN
            numInDoc   = bOpEntryHandle::op-entry
            kassSymbol = bOpEntryHandle::symbol
            rusSum     = bOpEntryHandle::amt-rub
            inSum      = bOpEntryHandle::amt-cur
            acct-db    = bOpEntryHandle::acct-db
            acct-cr    = bOpEntryHandle::acct-cr
	    type       = bOpEntryHandle::type
            techPlat   = bOpEntryHandle::type
            currency   = bOpEntryHandle::currency
            kau-db     = bOpEntryHandle::kau-db
            kau-cr     = bOpEntryHandle::kau-cr
        .

END METHOD.

/**
 * Является ли указанная проводка полупроводкой.
 * @return LOG
 **/
METHOD PUBLIC LOG isHalf():
   IF THIS-OBJECT:acct-db = ? OR THIS-OBJECT:acct-cr = ? THEN RETURN TRUE.
   RETURN FALSE.
END METHOD.

/**
 * Является ли указанная проводка конверсией,
 * то есть в счете ДБ или КР валюты не равны.
 * @return LOG
 **/
METHOD PUBLIC LOG hasEqualVal():
  IF SUBSTRING(THIS-OBJECT:acct-db,6,3) = SUBSTRING(THIS-OBJECT:acct-cr,6,3) THEN RETURN TRUE.
  RETURN FALSE.
END METHOD.


/*************************************
 * Возвращает счет по ДБ из проводки *
 * @return TAcct                     *
 *************************************
 **** УБЕЙ ЗА СОБОЙ ОБЪЕКТ!!! ********
 *************************************/

METHOD PUBLIC TAcct getAcctDb():
  RETURN NEW TAcct(THIS-OBJECT:acct-db).
END METHOD.


DESTRUCTOR PUBLIC TOpEntry():
        /**********************************
         * Я тебя породил, я тебя и убью! *
         **********************************/ 
END DESTRUCTOR.
END CLASS.