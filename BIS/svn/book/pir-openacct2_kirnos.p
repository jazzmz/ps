
/********************************
 * Ведомость открытых лицевых счетов.
 ********************************
 * Автор: Маслов Д. А.
 * Дата создания: 
 * Заявка: #934
 *********************************/


{globals.i}
 
{acc-file.i &file=acct}
{chkacces.i}
{op-flt.i new}
{intrface.get count}
{pir-c2346u.i}
 
 
{tpl.create}

 DEF INPUT PARAM cParam    AS CHAR  NO-UNDO.  
 DEF VAR i                 AS INT64 INIT 0                        NO-UNDO.
 DEF VAR mAcct             AS CHAR  INIT "10*,2*,3*,4*,5*,6*,70*" NO-UNDO.
 DEF VAR mSewMode          AS CHAR                                NO-UNDO.
 DEF VAR currDate          AS DATE                                NO-UNDO.

 DEF VAR oTable            AS TTable2                             NO-UNDO.
 DEF VAR oAcct             AS TAcct                               NO-UNDO.
 DEF VAR bookInfo          AS TAArray                             NO-UNDO.
 DEF VAR oConfig           AS TAArray                             NO-UNDO.
 DEF VAR oEra              AS TEra                                NO-UNDO.
 DEF VAR inspector         AS CHAR                                NO-UNDO.
 
 oTable = NEW TTable2(11).
 oEra = NEW TEra(TRUE).

 inspector = cParam.
 

RUN messmenu.p(
       10,
       "[Типы счетов]",
       "",
       "Все," +
       "Юридические," +
       "Физические," +
       "Внутрибанковские"
).
CASE INTEGER(pick-value):
   WHEN 1 THEN mSewMode = "".
   WHEN 2 THEN mSewMode = "Ю".
   WHEN 3 THEN mSewMode = "Ч".
   WHEN 4 THEN mSewMode = "В".
   OTHERWISE RETURN.
END CASE.
{getdate.i}

currDate = end-date.

oConfig = new TAArray().
  oConfig:setH("taxon","fin ved closeacct").
  oConfig:setH("num",iCurrOut).
  oConfig:setH("opdate",TEra:getDate(currDate)).
  oConfig:setH("expn",iCurrOut).
  oConfig:setH("author",USERID("bisquit")).
  oConfig:setH("inspector",inspector).
  oConfig:setH("fext","txt").
  
 
 
 FOR EACH bal-acct WHERE CAN-DO(mAcct, STRING(bal-acct.bal-acct)) NO-LOCK,
   EACH acct OF bal-acct WHERE acct.cust-cat BEGINS mSewMode
                           AND open-date EQ currDate
                           AND acct.user-id BEGINS access
                           AND acct.acct-cat EQ "b"
                           AND CAN-DO(list-id,acct.user-id)
                           NO-LOCK
   BREAK BY bal-acct.bal-acct 
         BY acct.currency 
         BY SUBSTRING(acct.acct,10,11):
  
  i = i + 1.  
  
  oAcct = new TAcct(BUFFER acct:HANDLE).  
  bookInfo = oAcct:getBookInfo().
    
    oTable:addRow().
    oTable:addCell(i).
    oTable:addCell(oAcct:open-date).
	/* #4275 синхронизация полей с Книгой */
    IF oAcct:getXAttr("ДогОткрЛС") = "01/01/1900,00" THEN oTable:addCell("").
	ELSE oTable:addCell(oAcct:getXAttr("ДогОткрЛС")).
    oTable:addCell(bookInfo:get("name")).
    oTable:addCell(oAcct:acct).
    oTable:addCell(oAcct:getXAttr("ЦельСч")).
    oTable:addCell(bookInfo:get("period")).
    oTable:addCell(bookInfo:get("gniopen")).
    oTable:addCell("" /*oAcct:close-date*/ ).
    oTable:addCell(bookInfo:get("gniclose")).
    oTable:addCell(bookInfo:get("details")).
   
   DELETE OBJECT bookInfo.   
   DELETE OBJECT oAcct.

END. /* По всем счетам */ 
oTpl:addAnchorValue("TABLE",oTable).
oTpl:addAnchorValue("DATE",currDate).
{tpl.show}

oEra:askAndSave(oConfig,"_spool.tmp").

DELETE OBJECT oEra.
DELETE OBJECT oConfig.


DELETE OBJECT oTable.
DELETE OBJECT oTpl.            
 
