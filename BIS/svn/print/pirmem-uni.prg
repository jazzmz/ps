
{get_set.i "КорСч"}
bank-cor-acct = setting.val.

/*-----------------------------------------
   Проверка наличия записи главной таблицы,
   на которую указывает Input Param RID
-------------------------------------------*/
Find op Where RecID(op) = RID no-lock no-error.
If Not Avail(op) then do:
  message "Нет записи <op>".
  Return.
end.

/*------------------------------------------------
   Выставить buffers на записи, найденные
   в соответствии с заданными в отчете правилами
------------------------------------------------*/
/* Правило для главной таблицы op */
function BankNameCity return char (buffer b for banks):
  return {banknm.lf b} + (if {bankct.lf b} <> "" then ', ' else '') +
         {bankct.lf b}.
end function.
         
{bank-id.i}

find op where RecID(op) = RID no-lock.
find first op-bank of op no-lock no-error.
find op-entry of op no-lock no-error.

if Ambig(op-entry) then do:
  Bell.
  {message &text="|К документу относится более одной проводки!"
           &alert-box="error"}.
  Return.
end.

/* User and Kontr */
  FIND FIRST _user WHERE _user._userid = op.user-id NO-LOCK.
  theUser   = TRIM(_user._user-name).
  theUserID = TRIM(_user._userid).
  IF ( TRIM(op.user-inspector) NE "" ) AND ( TRIM(op.user-inspector) NE theUserID ) THEN DO:
     FIND FIRST _user WHERE _user._userid = op.user-inspector NO-LOCK.
     theKontr   = TRIM(_user._user-name).
     theKontrID = TRIM(_user._userid).
  END.

/* Find PlName */
/* PIR доработка для 275-ФЗ, если допреквизит заполнен, то его на экран */
IF GetXAttrValue('op',STRING(op.op),'name-send') eq "" THEN
 DO:
  find first acct where acct.acct = op-entry.acct-db no-lock.
  {getcust.i &name=NameCli &inn=InnCli}

  /**
   * ПИР: бурягин
   * уберем ИНН, если нужно
   * acctMask_Without_Inn смотри в pirmem-uni.p
   */
  if can-do(acctMask_Without_Inn, acct.acct) then do:
  	if entry(1, NameCli[1], " ") = "ИНН" THEN DO:
  		if entry(2, NameCli[1], " ") <> "" THEN DO:
  			entry(2, NameCli[1], " ") = "".
  		END.
		entry(1, NameCli[1], " ") = "".
  		NameCli[1] = TRIM(NameCli[1]).
  	end.
  end.
  
  PlLAcct = op-entry.acct-db.
  PlName[1] = NameCli[1] + " " + NameCli[2].
 END.
ELSE
 DO:
 IF GetXAttrValue('op',STRING(op.op),'inn-send') eq "" THEN
  PlName[1] = GetXAttrValue('op',STRING(op.op),'name-send').
 ELSE
  PlName[1] = "ИНН " + GetXAttrValue('op',STRING(op.op),'inn-send') + " " + GetXAttrValue('op',STRING(op.op),'name-send').
 END.
{wordwrap.i &s=PlName &n=5 &l=35}

IF GetXAttrValue('op',STRING(op.op),'acct-send') eq "" THEN
PlLAcct = op-entry.acct-db.
ELSE
PlLAcct =GetXAttrValue('op',STRING(op.op),'acct-send').


/* Find PoName */
find first acct where acct.acct = op-entry.acct-cr no-lock.
{getcust.i &name=NameCli}

  /**
   * ПИР: бурягин
   * уберем ИНН, если нужно
   * acctMask_Without_Inn смотри в pirmem-uni.p
   */
  if can-do(acctMask_Without_Inn, acct.acct) then do:
  	if entry(1, NameCli[1], " ") = "ИНН" THEN DO:
  		if entry(2, NameCli[1], " ") <> "" THEN DO:
  			entry(2, NameCli[1], " ") = "".
  		END.
		entry(1, NameCli[1], " ") = "".
  		NameCli[1] = TRIM(NameCli[1]).
  	end.
  end.

PoAcct = op-entry.acct-cr.
PoName[1] = NameCli[1] + " " + NameCli[2].
{wordwrap.i &s=poName &n=5 &l=35}

/* Выставим buf_0_op на op роли 'Тот самый Op, под который лепится проводка' */
Find buf_0_op Where RecID(buf_0_op) = RecID(op) no-lock.

/*------------------------------------------------
   Вычислить значения специальных полей
   в соответствии с заданными в отчете правилами
------------------------------------------------*/
/* Вычисление значения специального поля AmtStr */
Run x-amtstr.p(op-entry.amt-rub,'',true,true,output amtstr[1], output amtstr[2]).
if trunc(op-entry.amt-rub,0) = op-entry.amt-rub
 then AmtStr[2] = ''.
 else AmtStr[1] = AmtStr[1] + ' ' + AmtStr[2].
{wordwrap.i &s=AmtStr &n=2 &l=60} 
Substr(AmtStr[1],1,1) = Caps(Substr(AmtStr[1],1,1)).

/* Вычисление значения специального поля Detail */
Detail[1] = if op.details <> ? then op.details else "".
{wordwrap.i &s=Detail &n=5 &l=80}

/* Вычисление значения специального поля PlCAcct */
PlCAcct = bank-acct. /* bank-cor-acct <- setting */

/* Вычисление значения специального поля PlMFO */
PlMFO = {out-fmt.i string(int(bank-mfo-9),fill('9',9)) 'xxxxxxxxx' }.

/* Вычисление значения специального поля PlRKC */
{get_set.i "Банк"}
PlRKC[1] = setting.val.

{getbank.i bank1 bank-mfo-9}
if avail bank1 then  PlRKC[1] = BankNameCity(buffer bank1).
               else  PlRKC[1] = "".
{wordwrap.i &s=PlRKC &n=2 &l=35}


/* Вычисление значения специального поля PoCAcct */
PoCAcct = bank-acct.  /* bank-cor-acct <- setting */

/* Вычисление значения специального поля PolMFO */
PolMFO = {out-fmt.i string(int(bank-mfo-9),fill('9',9)) 'xxxxxxxxx' }.

/* Вычисление значения специального поля PoRKC */
/*{get_set.i "Банк"}
PoRKC[1] = setting.val.*/

{getbank.i bank1 bank-mfo-9}
if avail bank1 then PoRKC[1] = BankNameCity(buffer bank1).
               else PoRKC[1] = "".
{wordwrap.i &s=PoRKC &n=2 &l=35}

/* Вычисление значения специального поля Rub */
if trunc(op-entry.amt-rub,0) = op-entry.amt-rub 
  then 
Rub = string(string(op-entry.amt-rub * 100, "-zzzzzzzzzz999"),"x(12)=").
  else 
Rub = string(string(op-entry.amt-rub * 100, "-zzzzzzzzzz999"),"x(12)-x(2)").


/* Вычисление значения специального поля Val */
if trunc(op-entry.amt-cur,0) = op-entry.amt-cur
  then 
Val = string(string(op-entry.amt-cur * 100, "-zzzzzzzzzz999"),"x(12)=").
  else 
Val = string(string(op-entry.amt-cur * 100, "-zzzzzzzzzz999"),"x(12)-x(2)").

/* Вычисление значения специального поля ValStr */
Run x-amtstr.p(op-entry.amt-cur,op-entry.currency,true,true,output valstr[1], output valstr[2]).
if trunc(op-entry.amt-cur,0) = op-entry.amt-cur
 then ValStr[2] = ''.
 else ValStr[1] = ValStr[1] + ' ' + ValStr[2].
{wordwrap.i &s=ValStr &n=2 &l=70} 
Substr(ValStr[1],1,1) = Caps(Substr(ValStr[1],1,1)).


/* Вычисление значения специального поля theDate */
if op.doc-date <> ? then
  theDate = {strdate.i op.doc-date}.
else
  theDate = {strdate.i op.op-date}.

/* Вычисление значения специального поля type-doc */
/* find doc-kind */

find first doc-type where doc-type.doc-type = op.doc-type no-lock no-error.
if avail doc-type then type-doc = doc-type.digital.
                  else type-doc = "".
