CLASS TKross1:
 {set-prop.i &aa="v-db"     &cc="CHAR" &init="?"    &perms="PROTECTED"}
 {set-prop.i &aa="v-cr"     &cc="CHAR" &init="?"    &perms="PROTECTED"}

 {set-prop.i &aa="acct-db"     &cc="CHAR" &init="?"    &perms="PROTECTED"}
 {set-prop.i &aa="acct-cr"     &cc="CHAR" &init="?"    &perms="PROTECTED"}

 {set-prop.i &aa="baseCurr" &cc="CHAR" &init="?"    &perms="PROTECTED"}
 {set-prop.i &aa="typeOper" &cc="CHAR" &init="?"    &perms="PROTECTED"}
 {set-prop.i &aa="sum-db"   &cc="DECIMAL" &init="?" &perms="PROTECTED"}
 {set-prop.i &aa="sum-cr"   &cc="DECIMAL" &init="?" &perms="PROTECTED"}

 {set-prop.i &aa="k-db"   &cc="DECIMAL" &init="?" &perms="PROTECTED"}
 {set-prop.i &aa="k-cr"   &cc="DECIMAL" &init="?" &perms="PROTECTED"}
 {set-prop.i &aa="currDate" &cc="DATE"    &init="?" &perms="PROTECTED"}

  CONSTRUCTOR TKross1(INPUT cAcct-db AS CHAR,INPUT cAcct-cr AS CHAR,INPUT sum-db AS DEC,INPUT sum-cr AS DEC):
    DEF VAR oSysClass AS TSysClass NO-UNDO.
    oSysClass = NEW TSysClass().

        ASSIGN
          THIS-OBJECT:acct-db =  cAcct-db
          THIS-OBJECT:acct-cr =  cAcct-cr
          THIS-OBJECT:v-db     = SUBSTRING(THIS-OBJECT:acct-db,6,3)
          THIS-OBJECT:v-cr     = SUBSTRING(THIS-OBJECT:acct-cr,6,3)
          THIS-OBJECT:sum-db   = sum-db
          THIS-OBJECT:sum-cr   = sum-cr
          THIS-OBJECT:baseCurr = getBaseVal()
          THIS-OBJECT:typeOper = THIS-OBJECT:getTypeOper()
        .
    DELETE OBJECT oSysClass.
  END CONSTRUCTOR.

  /**
   * Метод устанавливает дату операции.
   **/
  METHOD PUBLIC TKross1 setDate(INPUT dDate AS DATE):
   DEF VAR oSysClass AS TSysClass NO-UNDO.
   oSysClass = NEW TSysClass().
   ASSIGN
    THIS-OBJECT:currDate = dDate
    THIS-OBJECT:k-db     = oSysClass:getCBRKurs(INT(v-db),currDate)
    THIS-OBJECT:k-cr     = oSysClass:getCBRKurs(INT(v-cr),currDate)
   .
  DELETE OBJECT oSysClass.
  RETURN THIS-OBJECT.

  END METHOD.

  METHOD PRIVATE CHAR getBaseVal():
        RETURN TSysClass:getSetting2("КодНацВал").       
  END METHOD.

  /**
   * Метод определяет тип операции.
   **/
  METHOD PUBLIC CHAR getTypeOper():
    IF v-db <> baseCurr AND v-cr <> baseCurr THEN RETURN "cross".
    IF v-db =  baseCurr                      THEN RETURN "sell".
    RETURN "buy".
  END METHOD.

  /**
   * Метод расчитывает 
   * курс операции.
   * @return DEC
   **/
  METHOD PUBLIC TKross1 calcCrossByCB():
    RETURN THIS-OBJECT:calcCrossByCB(TRUE).
  END METHOD.

  METHOD PUBLIC TKross1 calcCrossByCB(INPUT shCorrect AS LOG):
    DEF VAR k     AS DEC NO-UNDO.
    DEF VAR oAcct AS TAcct NO-UNDO.

    IF sum-db = ? THEN DO:
       k = k-cr / k-db.
    END. ELSE DO:
       k = k-db / k-cr.
    END.
   
    k = ROUND(k,4).
    IF sum-db = ? THEN DO:
       sum-db = ROUND(sum-cr * k,2).
     IF shCorrect THEN DO:
        oAcct = NEW TAcct(acct-db).

         DO WHILE sum-db * k-db < sum-cr * k-cr:
           IF oAcct:activity = "П" THEN DO:
             sum-db = sum-db + 0.01. 
           END. ELSE DO:
             sum-db = sum-db - 0.01.
           END.
         END.

        DELETE OBJECT oAcct.
     END.
    END. ELSE DO:
       sum-cr = ROUND(sum-db * k,2).        
     IF shCorrect THEN DO:
         DO WHILE sum-db * k-db < sum-cr * k-cr:
           IF oAcct:activity = "П" THEN DO:
             sum-cr = sum-cr - 0.01. 
           END. ELSE DO:
             sum-cr = sum-cr + 0.01.
           END.
         END.
      END.

    END.

    

   RETURN THIS-OBJECT.
  END METHOD.
END CLASS.