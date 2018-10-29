{pirsavelog.p}

/* ========================================================================= */
/** 
    Copyright: ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (C) 2011
     Filename: pir_u5rep_t001.p
      Comment: Временный отчет, прежде всего для исправления ошибок 
		при выгрузке реестра вкладчиков для ASV
   Parameters: 
       Launch: ЧВ - Печать - ПИР: Некорректное заведения реквизитов клиента
         Uses:
      Created: Ситов С.А., 01.06.2012
	Basis: #1006
     Modified: <Кто> <Когда [F7]> (Локальный код для поиска <уникальный_код>) 
               <Описание изменения>                                           
*/
/* ========================================================================= */



{globals.i}
{ulib.i}
{getdate.i}


DEF VAR KlntFIO            AS CHAR NO-UNDO.
DEF VAR PersCountry-id     AS CHAR NO-UNDO.
DEF VAR PersDRCountry-id2  AS CHAR NO-UNDO.
DEF VAR PersDRKodReg       AS CHAR NO-UNDO.
DEF VAR AdrFactCountr      AS CHAR NO-UNDO.
DEF VAR AdrFactKodReg      AS CHAR NO-UNDO.
DEF VAR AdrPropCountr      AS CHAR NO-UNDO.
DEF VAR AdrPropKodReg      AS CHAR NO-UNDO.


def var i as int init 0 no-undo.
DEF VAR iOpenAcct AS LOGICAL NO-UNDO.

define temp-table reptt no-undo
	FIELD KlntFIO           as char
	FIELD PersCountry-id    as char 
	FIELD PersDRCountry-id2 as char 
	FIELD PersDRKodReg      as char 
	FIELD AdrPropCountr     as char 
	FIELD AdrPropKodReg     as char 
	FIELD AdrFactCountr     as char 
	FIELD AdrFactKodReg     as char 
	FIELD iOpenAcct         as logical 
.

{setdest.i}

FOR EACH person WHERE 
	person.country-id <> "RUS"
	AND (person.date-out EQ ? OR person.date-out >= beg-date)
	/* AND person.person-id = 10690 */
NO-LOCK,
FIRST cust-role 
	WHERE cust-role.cust-cat EQ "Ч"
	AND cust-role.cust-id EQ STRING (person-id)
	AND cust-role.Class-Code EQ 'ImaginClient'
NO-LOCK
:

   FIND FIRST acct WHERE acct.cust-id = person.person-id 
		AND acct.cust-cat = "Ч"
		AND acct.close-date = ? 
   NO-LOCK NO-ERROR.

   IF AVAIL acct THEN
        DO:
	   iOpenAcct = yes .
           i = i + 1 .
        END.	   
   ELSE 
	   iOpenAcct = no  .
 	  
		
   KlntFIO  = person.name-last + " " + person.first-name .
   PersCountry-id  = person.country-id .
   PersDRCountry-id2 = GetXAttrValueEx("person",STRING(person.person-id),"country-id2","") .
   PersDRKodReg = GetXAttrValueEx("person",STRING(person.person-id),"КодРег","") .
   AdrFactCountr = "" .
   AdrFactKodReg = "" .
   AdrPropCountr = "" .
   AdrPropKodReg = "" .

   FIND LAST cust-ident WHERE 
		(cust-ident.close-date EQ ? OR cust-ident.close-date >= end-date)
		AND cust-ident.class-code EQ 'p-cust-adr'
		AND cust-ident.cust-cat EQ 'Ч' 
		AND cust-ident.cust-code-type EQ 'АдрФакт'
		AND cust-ident.cust-id EQ person.person-id
   NO-LOCK NO-ERROR.

   IF AVAIL cust-ident THEN
	DO:
	   AdrFactKodReg = GetXAttrValueEx("cust-ident",STRING("АдрФакт," + cust-ident.cust-code + "," + STRING(cust-ident.cust-type-num)),"КодРег","") .
	   AdrFactCountr = GetXAttrValueEx("cust-ident",STRING("АдрФакт," + cust-ident.cust-code + "," + STRING(cust-ident.cust-type-num)),"country-id","") .
	END.
 

   FIND LAST cust-ident WHERE 
		(cust-ident.close-date EQ ? OR cust-ident.close-date >= end-date)
		AND cust-ident.class-code EQ 'p-cust-adr'
		AND cust-ident.cust-cat EQ 'Ч' 
		AND cust-ident.cust-code-type EQ 'АдрПроп'
		AND cust-ident.cust-id EQ person.person-id
   NO-LOCK NO-ERROR.

   IF AVAIL cust-ident THEN
	DO:
	   AdrPropKodReg = GetXAttrValueEx("cust-ident",STRING("АдрПроп," + cust-ident.cust-code + "," + STRING(cust-ident.cust-type-num)),"КодРег","") .
	   AdrPropCountr = GetXAttrValueEx("cust-ident",STRING("АдрПроп," + cust-ident.cust-code + "," + STRING(cust-ident.cust-type-num)),"country-id","") .
	END.

   CREATE reptt.
   ASSIGN
	reptt.KlntFIO           =  KlntFIO          
	reptt.PersCountry-id    =  PersCountry-id   
	reptt.PersDRCountry-id2 =  PersDRCountry-id2
	reptt.PersDRKodReg      =  PersDRKodReg     
	reptt.AdrFactKodReg     =  AdrFactKodReg    
	reptt.AdrFactCountr     =  AdrFactCountr   
	reptt.AdrPropKodReg     =  AdrPropKodReg    
	reptt.AdrPropCountr     =  AdrPropCountr 
	reptt.iOpenAcct         =  iOpenAcct
   .


END.



    PUT UNFORM 	
         "      ОТЧЕТ Некорректное заведения реквизитов клиента на " end-date
    SKIP(1).

    PUT UNFORM 	
	"ФИО"           format "X(25)"  " | "
	"Карточка"      format "X(10)"   " | "
	"ДР на клиенте" format "X(10)"   " | " 
	"ДР КодРег (клт)"    format "X(10)"  " | " 
	"АдрПроп"     format "X(10)"  " | "     
	"АдрПропКодРег"     format "X(10)"  " | "     
	"АдрФакт"     format "X(10)"  " | "     
	"АдрФактКодРег"     format "X(10)"  " | "     
    SKIP(1).



FOR EACH reptt WHERE reptt.iOpenAcct = yes NO-LOCK:

  IF ( reptt.PersCountry-id <> ? OR reptt.PersCountry-id <> "0" OR reptt.PersCountry-id <> "00000"  )
        OR 
     ( reptt.PersDRCountry-id2 <> ? OR reptt.PersDRCountry-id2 <> "0" OR reptt.PersDRCountry-id2 <> "00000"  )
        OR 
     ( reptt.PersDRKodReg <> ? OR reptt.PersDRKodReg <> "0" OR reptt.PersDRKodReg <> "00000"  )
        OR 
     ( reptt.AdrFactKodReg <> ? OR reptt.AdrFactKodReg <> "0" OR reptt.AdrFactKodReg <> "00000"  )
        OR 
     ( reptt.AdrPropKodReg <> ? OR reptt.AdrPropKodReg <> "0" OR reptt.AdrPropKodReg <> "00000"  )
  THEN

    PUT UNFORM 	
	reptt.KlntFIO           format "X(25)"  " | "
	reptt.PersCountry-id    format "X(10)"   " | "
	reptt.PersDRCountry-id2 format "X(10)"   " | " 
	reptt.PersDRKodReg      format "X(10)"  " | " 
	reptt.AdrPropCountr     format "X(10)"  " | " 
	reptt.AdrPropKodReg     format "X(10)"  " | "     
	reptt.AdrFactCountr     format "X(10)"  " | "     
	reptt.AdrFactKodReg     format "X(10)"  " | " 
    SKIP.

END.

PUT UNFORM " " SKIP.
PUT UNFORM "ИТОГО: " i SKIP.

{preview.i}

