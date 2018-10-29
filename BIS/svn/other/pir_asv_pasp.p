{pirsavelog.p}

/* ========================================================================= */
/** 
    Copyright: ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (C) 2011
     Filename: pir_asv_pasp.p
      Comment: Временный отчет об ошибках заполнения поля "код подразделения" в модуле
	       "удостоверение личности". 
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
def var cTmpS as char no-undo.

define temp-table reptt no-undo
	FIELD id    as int  format "999999"
	FIELD unk   as char format "X(6)" 
	FIELD fio   as char format "X(30)" 
	FIELD docum as char format "X(45)" 
	FIELD type  as int
.

define temp-table reppp no-undo
	FIELD id    as int  format "999999"
	FIELD unk   as char format "X(6)" 
	FIELD fio   as char format "X(30)" 
	FIELD docum as char format "X(45)" 
	FIELD type  as int
.



{setdest.i}

FOR EACH person WHERE 
	person.document-id = "Паспорт"
	/*AND person.person-id = 8959 */
NO-LOCK,
FIRST cust-role 
	WHERE cust-role.cust-cat EQ "Ч"
	AND cust-role.cust-id EQ STRING (person-id)
	AND cust-role.Class-Code EQ 'ImaginClient'
NO-LOCK
:

IF GetXAttrValueEx("person",STRING(person.person-id),"country-id2","") = "RUS" THEN
DO:
  IF person.issue = "" OR  person.issue = ? THEN
	 DO:
		CREATE reptt.
		ASSIGN
			reptt.id    =  person.person-id 
			reptt.unk   =  STRING(GetXAttrValueEx("person",STRING(person.person-id),"УНК","") )
			reptt.fio   =  person.name-last + " " + person.first-name
			reptt.docum =  replace(person.issue,chr(10),' ')
			reptt.type  =  1
		.
	 i1 = i1 + 1.
	END.
  IF NUM-ENTRIES(person.issue, ",") = 2 THEN
	IF ENTRY(2,person.issue,",") = "" THEN
	  DO:
		/* " тип 2 Пустое поле после запятой в issue"*/
		CREATE reptt.
		ASSIGN
			reptt.id    =  person.person-id 
			reptt.unk   =  STRING(GetXAttrValueEx("person",STRING(person.person-id),"УНК","") )
			reptt.fio   =  person.name-last + " " + person.first-name
			reptt.docum =  replace(person.issue,chr(10),' ')
			reptt.type  =  2
		.
	 i2 = i2 + 1.
	END.
  IF NUM-ENTRIES(person.issue, ",") < 2 THEN
	  DO:
		/*" тип 3" "Только один элеиент issue"*/
		CREATE reptt.
		ASSIGN
			reptt.id    =  person.person-id 
			reptt.unk   =  STRING(GetXAttrValueEx("person",STRING(person.person-id),"УНК","") )
			reptt.fio   =  person.name-last + " " + person.first-name
			reptt.docum =  replace(person.issue,chr(10),' ')
			reptt.type  =  3
		.
	 i3 = i3 + 1.
	 END.
  IF NUM-ENTRIES(person.issue, ",") > 2 THEN
	  DO:
		/* " тип 4 Больше двух элементов issue"*/
		CREATE reptt.
		ASSIGN
			reptt.id    =  person.person-id 
			reptt.unk   =  STRING(GetXAttrValueEx("person",STRING(person.person-id),"УНК","") )
			reptt.fio   =  person.name-last + " " + person.first-name
			reptt.docum =  replace(person.issue,chr(10),' ')
			reptt.type  =  4
		.
      	 i4 = i4 + 1.
	 END.

END.

END.

		/* ШАПКА */
PUT UNFORM 	" ID кл"      format "999999" " | "
		"  УНК "      format "X(6)"   " | "
		"  ФИО "      format "X(40)"  " | "
		"  Документ " format "X(65)"  " | " 
SKIP.
PUT UNFORM  FILL("-",127)  SKIP.

/*
PUT UNFORM " тип 1 "    SKIP.
FOR EACH reptt WHERE reptt.type = 1  NO-LOCK:
	PUT UNFORM 	reptt.id    format "999999" " | "
			reptt.unk   format "X(6)"   " | "
			reptt.fio   format "X(40)"  " | "
			reptt.docum format "X(65)"  " | " 
	SKIP.
END.
PUT UNFORM  FILL("-",127)  SKIP.



PUT UNFORM " тип 3  "    SKIP.
FOR EACH reptt WHERE reptt.type = 2  NO-LOCK:
	PUT UNFORM 	reptt.id    format "999999" " | "
			reptt.unk   format "X(6)"   " | "
			reptt.fio   format "X(40)"  " | "
			reptt.docum format "X(65)"  " | " 
	SKIP.
END.
PUT UNFORM  FILL("-",127)  SKIP.



PUT UNFORM " тип 4  "    SKIP.
FOR EACH reptt WHERE reptt.type = 3  NO-LOCK:
	PUT UNFORM 	reptt.id    format "999999" " | "
			reptt.unk   format "X(6)"   " | "
			reptt.fio   format "X(40)"  " | "
			reptt.docum format "X(65)"  " | " 
	SKIP.
END.
PUT UNFORM  FILL("-",127)  SKIP.



PUT UNFORM " тип 2  "    SKIP(1).
FOR EACH reptt WHERE reptt.type = 4  NO-LOCK:
	PUT UNFORM 	reptt.id    format "999999" " | "
			reptt.unk   format "X(6)"   " | "
			reptt.fio   format "X(40)"  " | "
			reptt.docum format "X(65)"  " | " 
	SKIP.
END.
PUT UNFORM  FILL("-",127)  SKIP.

*/



FOR EACH reptt 
NO-LOCK:

   FIND LAST cust-ident
     WHERE (cust-ident.cust-cat       EQ "Ч")
     AND (cust-ident.cust-id        EQ INTEGER(reptt.id))
     AND (cust-ident.class-code     EQ "p-cust-ident")
     AND (cust-ident.cust-code-type EQ "Паспорт")
   NO-LOCK NO-ERROR.

   IF NOT (AVAIL cust-ident) THEN 
	DO:
	   FIND LAST cust-ident
	      WHERE (cust-ident.cust-cat       EQ "Ч")
              AND (cust-ident.cust-id        EQ INTEGER(reptt.id))
              AND (cust-ident.class-code     EQ "p-cust-ident")
	   NO-LOCK NO-ERROR.
	END.

  IF (AVAIL cust-ident) THEN 
	DO:
	   cTmpS = cust-ident.cust-code-type + ',' + cust-ident.cust-code + ',' + STRING(cust-ident.cust-type-num).
	   cTmpS = GetXAttrValueEx("cust-ident", cTmpS, "Подразд","").

	   IF cTmpS = "" THEN
		DO:

		CREATE reppp.
		ASSIGN
			reppp.id    =  reptt.id    
			reppp.unk   =  reptt.unk   
			reppp.fio   =  reptt.fio   
			reppp.docum =  reptt.docum 
			reppp.type  =  reptt.type  
		.

		i = i + 1.
		END.
	END.
END.



FOR EACH reppp   NO-LOCK:
	PUT UNFORM 	reppp.id    format "999999" " | "
			reppp.unk   format "X(6)"   " | "
			reppp.fio   format "X(40)"  " | "
			reppp.docum format "X(65)"  " | " 
	SKIP.
END.

PUT UNFORM " " SKIP.
PUT UNFORM "ИТОГО: " i SKIP.

{preview.i}

