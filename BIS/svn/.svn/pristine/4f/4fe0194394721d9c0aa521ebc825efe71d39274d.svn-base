/*попытка сделать "универсальную" процедуру для выгрузки в архив.*/
{globals.i}
{getdate.i}
{intrface.get count}

DEF INPUT PARAMETER iParam AS CHAR NO-UNDO.

DEF VAR iProcedure AS CHAR NO-UNDO.    /*имя процедуры для печати*/
DEF VAR ifileFromProc AS CHAR NO-UNDO. /*имя файла сохраняемого их превью*/ 
DEF VAR taxon AS CHAR NO-UNDO.         /* Вид документа в электронном архиве */

iProcedure    = ENTRY(1,iParam).
ifileFromProc = ENTRY(2,iParam).
taxon         = ENTRY(3,iParam).

DEF VAR oConfig as TAArray.
DEF VAR oEra as TEra.



/*подготавливаем окружение для выгрузку в ЕАрхив*/

{pirraproc.def}
{pir-c2346u.i}


  RUN VALUE(TSysClass:whatShouldIRun2(iProcedure)).

oConfig = new TAArray().
oConfig:setH("taxon",taxon).
oConfig:setH("opdate",TEra:getDate(end-date)).
oConfig:setH("num",iCurrOut).
oConfig:setH("expn",iCurrOut).
oConfig:setH("author",USERID("bisquit")).
oConfig:setH("inspector",USERID("bisquit")).
oConfig:setH("fext","txt").
oEra = new TEra(TRUE).
 oEra:askAndSave(oConfig,ifileFromProc).
DELETE OBJECT oEra.
DELETE OBJECT oConfig.
