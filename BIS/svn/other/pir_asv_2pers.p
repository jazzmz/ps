{pirsavelog.p}

/* ========================================================================= */
/** 
    Copyright: ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (C) 2011
     Filename: pir_asv_2pers.p
      Comment: Временный отчет по задвоенным клиентам
	       Использовался для исправления реестра вкладчиков
   Parameters: 
       Launch: БМ - Клиенты - Физические лица - Отмечаем любого клиента, Ctrl+G
         Uses:
      Created: Ситов С.А., 06.12.2012
	Basis: без ТЗ (по письму Маршевой, Капитановой)
     Modified: <Кто> <Когда [F7]> (Локальный код для поиска <уникальный_код>) 
               <Описание изменения>                                           
*/
/* ========================================================================= */



{globals.i}
{ulib.i}


def var i as int init 0 no-undo.
def var i1 as int init 0 no-undo.
def var i2 as int init 0 no-undo.
def var i3 as int init 0 no-undo.
def var i4 as int init 0 no-undo.

{setdest.i}

DEFINE BUFFER ttperson FOR person .
DEFINE BUFFER ttcust-role FOR cust-role .


PUT UNFORM  "                     Отчет по задвоенным клиентам " SKIP(1).	

PUT UNFORM      " ID кл | " 
		"     УНК    " " | "
		"ФИО"  FORMAT("X(40)") " | "
		" Дата рожд. " " | " 
		" Дата ухода " " | " 
		" Документ " FORMAT("X(32)") " | " 
SKIP(1).



FOR EACH person 
NO-LOCK,
FIRST cust-role 
	WHERE cust-role.cust-cat EQ "Ч"
	AND cust-role.cust-id EQ STRING (person-id)
	AND cust-role.Class-Code EQ 'ImaginClient'
NO-LOCK
:
  
  FOR EACH ttperson 
	WHERE ttperson.name-last = person.name-last 
   	AND ttperson.person-id <> person.person-id
  NO-LOCK,
  FIRST ttcust-role 
	WHERE ttcust-role.cust-cat EQ "Ч"
	AND ttcust-role.cust-id EQ STRING (person-id)
	AND ttcust-role.Class-Code EQ 'ImaginClient'
  NO-LOCK
  :
 
    IF avail(ttperson) AND ttperson.first-name = person.first-name THEN


	DO:
	i = i + 1 .

	PUT UNFORM      ttperson.person-id  FORMAT("999999") " | "
			STRING(GetXAttrValueEx("person",STRING(ttperson.person-id),"УНК","") ) FORMAT("X(12)") " | "
			STRING(ttperson.name-last + " " + ttperson.first-name) FORMAT("X(40)") " | "
			STRING(ttperson.birthday) FORMAT("X(12)") " | " 
			STRING(ttperson.date-out) FORMAT("X(12)") " | " 
			STRING(ttperson.document-id + ": " + ttperson.document) FORMAT("X(32)") " | " 
/*			GetCodeName("КодДокум", ttperson.document-id) FORMAT("X(32)")
*/	SKIP.	
	END.

/*GetXAttrValueEx("person",STRING(person.person-id),"country-id2","")*/

  END.

END.

/*
PUT UNFORM i SKIP.
*/

{preview.i}
