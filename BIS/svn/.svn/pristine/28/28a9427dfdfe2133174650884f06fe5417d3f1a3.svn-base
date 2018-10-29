 
 /*------------------------------------------------------------------------
    File        : TKross
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : dmaslov
    Created     : Wed Jun 27 11:35:46 MSD 2012
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.



CLASS TKross:
    
    {set-prop.i &aa="typeOper"     &cc="CHAR"}
    {set-prop.i &aa="subTypeOper"  &cc="CHAR" perms="PROTECTED"}
    {set-prop.i &aa="acct-db"      &cc="CHAR"}
    {set-prop.i &aa="acct-cr"      &cc="CHAR"}
    {set-prop.i &aa="sum-db"       &cc="DECIMAL"}
    {set-prop.i &aa="sum-cr"       &cc="DECIMAL"}
    {set-prop.i &aa="v-db"         &cc="CHAR"}
    {set-prop.i &aa="v-cr"         &cc="CHAR"}
    {set-prop.i &aa="baseCurr"     &cc="CHAR"}
    {set-prop.i &aa="oKurs"        &cc="TAArray" &perms="PROTECTED"}
    {set-prop.i &aa="sum-val"      &cc="DECIMAL"}
    {set-prop.i &aa="sum-rub"      &cc="DECIMAL"}
    {set-prop.i &aa="mainVal"      &cc="CHAR"}

    {set-prop.i &aa="activeKurs"   &cc="DEC"}           /*** Расчетный курс операции ***/
    {set-prop.i &aa="activeKursCB" &cc="DEC"}           /*** Курс ЦБ ***/
    {set-prop.i &aa="factKurs"     &cc="DEC"}           /*** Фактический курс операции ***/
    {set-prop.i &aa="middleKurs"   &cc="DEC"}           /*** Средневзвешенный курс **/
    {set-prop.i &aa="currDate"     &cc="DATE"}

    {set-prop.i &aa="oLine840"     &cc="TAArray" perms="PRIVATE"}
    {set-prop.i &aa="oLine978"     &cc="TAArray" perms="PRIVATE"}
    {set-prop.i &aa="oLine826"     &cc="TAArray" perms="PRIVATE"}
    {set-prop.i &aa="currPoints"   &cc="TAArray" perms="PRIVATE"}
    
CONSTRUCTOR TKross(INPUT cAcct-Db AS CHAR,INPUT cAcct-Cr AS CHAR,INPUT dSumDb AS DECIMAL,INPUT dSumCr AS DECIMAL):

END CONSTRUCTOR.

CONSTRUCTOR TKross(INPUT hOpEntry AS HANDLE):
   DEF VAR oSysClass AS TSysClass NO-UNDO.
   oSysClass = NEW TSysClass().
 /**
  * Ожиюдаю, что пока здесь
  * не будет Кросс операции.
  **/
  ASSIGN
     acct-db  = hOpEntry::acct-db
     acct-cr  = hOpEntry::acct-cr
     v-db     = SUBSTRING(acct-db,6,3)
     v-cr     = SUBSTRING(acct-cr,6,3)
     baseCurr = TSysClass:getSetting2("КодНацВал")
     sum-val  = hOpEntry::amt-cur
     sum-rub  = hOpEntry::amt-rub
     currDate = hOpEntry::op-date
   .
   DELETE OBJECT oSysClass.
   initParams().
END CONSTRUCTOR.

/**
 * Инициализурует разбивки по суммам
 **/
METHOD PRIVATE VOID initPoints():
  oLine840  = NEW TAArray().
  oLine978  = NEW TAArray().
  oLine826  = NEW TAArray().

  oLine840:setH("0",0.005).
  oLine840:setH("1500000",0.003).
  oLine840:setH("3700000",0.001).
  
  oLine978:setH("0",0.005).
  oLine978:setH("1000000",0.003).
  oLine978:setH("2700000",0.001).

  oLine826:setH("0",0.005).
  oLine826:setH("1000000",0.003).
  oLine826:setH("2700000",0.001).


  
  CASE mainVal:
     WHEN "840" THEN DO:
       currPoints = oLine840.
     END.
     WHEN "978" THEN DO:
       currPoints = oLine978.
     END.
     WHEN "826" THEN DO:
       currPoints = oLine826.
     END.     
  END CASE.
  
END METHOD.
/**
 * Инициализируем параметры
 * операции.
 **/ 
METHOD PROTECTED VOID initParams():
   DEF VAR oSysClass AS TSysClass NO-UNDO.
   oSysClass = NEW TSysClass().
   
   
      typeOper = (IF v-db <> baseCurr THEN "buy" ELSE "sale").
      sum-db   = (IF v-db <> baseCurr THEN sum-val ELSE sum-rub).
      sum-cr   = (IF v-cr <> baseCurr THEN sum-val ELSE sum-rub).

      mainVal  = (IF v-db <> baseCurr THEN v-db ELSE v-cr).

      factKurs = ROUND(sum-rub / sum-val,4).

      initPoints().


      oKurs    = NEW TAArray().
      oKurs:setH("k_840_810",oSysClass:getKursByType("СрзВзшДБ",840,currDate)).
      oKurs:setH("k_978_810",oSysClass:getKursByType("СрзВзшДБ",978,currDate)).
      oKurs:setH("k_826_810",oSysClass:getKursByType("СрзВзшДБ",826,currDate)).

      oKurs:setH("k_810_840",oSysClass:getKursByType("СрзВзшКр",840,currDate)).
      oKurs:setH("k_810_978",oSysClass:getKursByType("СрзВзшКр",978,currDate)).
      oKurs:setH("k_810_826",oSysClass:getKursByType("СрзВзшКр",826,currDate)).

      activeKursCB = DECIMAL(oSysClass:getCBRKurs(INT(mainVal),currDate)).
      middleKurs   = getCurrMiddleKurs().
      activeKurs   = calcActiveKurs().
   DELETE OBJECT oSysClass.
   
END METHOD.

/**
 * Возвращает средневзшенный курс,
 * для валюты операции.
 * @return DECIMAL
 **/
METHOD PROTECTED DECIMAL getCurrMiddleKurs():
    RETURN DECIMAL(oKurs:get("k_" + v-db + "_" + v-cr)).
END METHOD.
/**
 * Рассчитывает курс операции для простого смертного.
 * @return DECIMAL
 **/
METHOD PROTECTED DECIMAL calcActiveKurs():
  DEF VAR dRes      AS DECIMAL   NO-UNDO.
  DEF VAR oSysClass AS TSysClass NO-UNDO.
  DEF VAR k         AS DECIMAL   NO-UNDO.  
  
  DEF VAR operKurs  AS DECIMAL   NO-UNDO.

  k = TSysClass:getTableValue(sum-val,currPoints).
    

 /**
   * В зависимости от типа операции
   * или вычитаем или прибавляем
   * комиссию.
   **/
   dRes = (IF typeOper = "sale" THEN middleKurs * (1 + k) ELSE middleKurs * (1 - k)).
   RETURN (IF (typeOper = "sale" AND dRes < activeKursCB) OR (typeOper = "buy"  AND dRes > activeKursCB) THEN activeKursCB ELSE dRes).
END METHOD.
/**
 * Определяет подтип операции
 **/
METHOD PUBLIC CHAR getSubType():
  RETURN STRING(TSysClass:getTableValue(sum-val,currPoints) * 1000).
END METHOD.
DESTRUCTOR TKross():
  DELETE OBJECT oKurs.
  DELETE OBJECT oLine978.
  DELETE OBJECT oLine840.
  DELETE OBJECT oLine826.
END DESTRUCTOR.

END CLASS.