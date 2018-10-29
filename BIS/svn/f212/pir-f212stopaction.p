DEFINE VARIABLE oTpl AS TTpl      NO-UNDO.
DEFINE VARIABLE cNum AS CHARACTER NO-UNDO.

DEFINE QUERY qCorpAcct FOR acct.

DEFINE BROWSE choiseAcct QUERY qCorpAcct DISPLAY acct.acct WITH 10 DOWN SEPARATORS.

/*
DEFINE FRAME aaa
             choiseAcct
             WITH OVERLAY
             .
*/
            
{tmprecid.def}

MESSAGE "Введите номер?" UPDATE cNum.

FIND FIRST tmprecid.

 FIND FIRST cust-corp WHERE tmprecid.id = RECID(cust-corp) NO-LOCK.
 
 FIND FIRST cust-ident WHERE cust-ident.Class-Code="p-cust-adr" AND cust-ident.cust-cat="Ю" AND cust-code-type="АдрЮр" AND cust-ident.cust-id=cust-corp.cust-id NO-LOCK.
OPEN QUERY qCorpAcct FOR EACH acct WHERE acct.cust-cat="Ю" AND acct.cust-id=cust-corp.cust-id AND (acct.close-date=? OR acct.close-date>TODAY) NO-LOCK.

DEFINE FRAME aaa
             choiseAcct
           WITH OVERLAY TITLE "Выберите счет" COL 25 ROW 5
           .
ENABLE ALL WITH FRAME aaa.
   
WAIT-FOR DEFAULT-ACTION OF choiseAcct.
       
 oTpl = new TTpl("pir-f212stopaction.tpl").
 oTpl:addAnchorValue("Название",cust-corp.name-short).
 oTpl:addAnchorValue("ТекущаяДата",STRING(TODAY)).
 oTpl:addAnchorValue("Номер",cNum).
 oTpl:addAnchorValue("Адрес",cust-ident.issue).       
 oTpl:addAnchorValue("Счет",acct.acct).

{setdest.i}
      oTpl:show().
      PAGE.
{preview.i}

DELETE OBJECT oTpl.