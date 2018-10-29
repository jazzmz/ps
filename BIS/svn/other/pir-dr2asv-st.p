/*
Застартовывает процедуру pir-dr2asv.p
*/


DEF INPUT  PARAM  iCode	AS  CHAR  NO-UNDO.

DEF VAR  vAcctMask	AS  CHAR  INIT ""  NO-UNDO.
DEF VAR  vUserMask	AS  CHAR  INIT ""  NO-UNDO.
DEF VAR  vRuleFill	AS  CHAR  INIT ""  NO-UNDO.
DEF VAR  vMailList	AS  CHAR  INIT ""  NO-UNDO.
DEF VAR  vFlChange	AS  LOGICAL  INIT no  NO-UNDO. /* no - режим отчета, yes - режим простановки реквизитов */
DEF VAR  vCount		AS  INT64  INIT 0  NO-UNDO.


DEF BUFFER bfcode FOR code .


  /*** Пустой параметр - это ошибка */
IF TRIM(iCode) = "" THEN RETURN .


  /*** Выполняем правила по классификатору  PirDRReestr */
FIND FIRST  bfcode
  WHERE bfcode.class  EQ 'PirDRReestr'
  AND   bfcode.parent EQ 'PirDRReestr'
  AND   bfcode.code   EQ iCode  
NO-LOCK NO-ERROR .

IF  NOT AVAILABLE bfcode  THEN  RETURN.

ASSIGN 
  vAcctMask = bfcode.val 
  vUserMask = ENTRY(2, bfcode.name, ";")
  vRuleFill = ENTRY(1, bfcode.name, ";") 
  vMailList = bfcode.description[1]
.


  /*** При запуcке руками допустимо наличие пустого значения только vMailList. 
     Кроме того,  если правило 0 - то процедура не запустится */
IF  vAcctMask = "" OR vUserMask = "" OR vRuleFill = "" OR vRuleFill = "0" 
THEN  RETURN. 


  /*** Запускаем процедуру простановки реквизитов в режиме ОТЧЕТА */
vFlChange = no .
RUN pir-dr2asv.p( vAcctMask, vUserMask, vRuleFill, vMailList, vFlChange , OUTPUT vCount) .


IF vCount > 0 THEN
DO:
    /*** Исполнитель получил отчет.
         Далее он принимает решение проставлять реквизиты или нет */ 
  MESSAGE "Произвести простановки реквизитов ?" 
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE mChange AS LOG.

  IF mChange THEN
  DO:
    vFlChange = yes .
    RUN pir-dr2asv.p( vAcctMask, vUserMask, vRuleFill, vMailList, vFlChange , OUTPUT vCount) .
    MESSAGE "Реквизиты проставлены."  VIEW-AS ALERT-BOX .
  END.
  ELSE 
    MESSAGE " По решению пользователя реквизиты не проставились." VIEW-AS ALERT-BOX.
END.
