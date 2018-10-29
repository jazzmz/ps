
/*------------------------------------------------------------------------
    File        : pir_f227_1
    Purpose     : 

    Syntax      :

    Description : ╧ЁюЎхфєЁр ЁрёўхЄр ъырёёр

    Author(s)   : dmaslov
    Created     : Tue Jul 10 11:30:07 MSD 2012
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */
{globals.i}
{sv-calc.i}
{intrface.get xclass}
{intrface.get strng}
{intrface.get pir27}




/* ***************************  Main Block  *************************** */


DEF TEMP-TABLE hOpEntry LIKE op-entry.

PROCEDURE CreateLine.
 DEF INPUT PARAM oParam AS TAArray NO-UNDO.

 IF oParam:get('isSkip') <> 'YES' THEN DO:



    CREATE Tdataline.
     ASSIGN
       TdataLine.data-id = in-data-id
       TdataLine.Sym1    = oParam:get("op-date")
       TdataLine.Sym2    = oParam:get("tyo")
       TdataLine.Sym3    = oParam:get("isLnk")
       TdataLine.Sym4    = STRING(oParam:get("op"))
       TdataLine.Val[2]  = (IF oParam:get("count") NE ? THEN DECIMAL(oParam:get("count")) ELSE 1)
       TdataLine.Val[4]  = DECIMAL(oParam:get("amt-rub"))
       TdataLine.Val[5]  = DECIMAL(oParam:get("amt-cur"))
       TdataLine.Val[6]  = DECIMAL(oParam:get("amt-calc"))
       TdataLine.Val[7]  = DECIMAL(oParam:get("amt-fact"))
       TdataLine.Val[8]  = DECIMAL(oParam:get("fprice"))
       TdataLine.Val[9]  = DECIMAL(oParam:get("cprice"))
       TdataLine.Txt     = oParam:toDataLine("~001",FALSE)
     .
 END.
END PROCEDURE.


/**
 * Нашли документ. Проводим
 * его анализ.
 * @param DATE currDate Дата в котором лежит документ.
 * @var CHAR typeOper Вид операции
 * @var LOG  isLnk    Взаимозависимый клиент?
 * @var BUFFER bOp    Буффер с документом.
 **/
FUNCTION onFindDoc RETURNS LOG(INPUT dBegDate AS DATE,INPUT dEndDate AS DATE,INPUT currDate AS DATE,INPUT typeOper AS CHAR,INPUT isLnk AS LOG,INPUT bOp AS HANDLE,INPUT oCodeCalc AS TAArray):
          DEF VAR oParam    AS TAArray NO-UNDO.
          
          oParam = NEW TAArray().
            /** Заполняем общую информацию **/
            oParam:setH("dBegDate",dBegDate).
            oParam:setH("dEndDate",dEndDate).
            oParam:setH('op-date',currDate).
            oParam:setH('op',op.op).
            oParam:setH('tyo',typeOper).
            oParam:setH('isLnk',isLnk).
            oParam:setH('count',"1").
            
            /**
             * В зависимости от типа операции 
             * заполняем дополнительной информацией 
             */
             IF oCodeCalc:get(typeOper) <> ? THEN DO:
               DYNAMIC-FUNCTION(oCodeCalc:get(typeOper) IN h_pir27,currDate,typeOper,isLnk,bOp,oParam).
             END.

            
             RUN CreateLine(oParam).

      DELETE OBJECT oParam NO-ERROR.
      RETURN TRUE.
END FUNCTION.

/**
 * @param DATE currDate Дата по которой производится проверка
 * @result LOG
 **/
FUNCTION onBegDate RETURNS LOG(INPUT currDate AS DATE):

END FUNCTION.
/**
 * Проверка по одному дню закончилась.
 * @param DATE currDate Дата проверка по которой закончилась.
 * @result LOG
 **/
FUNCTION onEndDate RETURNS LOG(INPUT currDate AS DATE):
   DEF VAR key1 AS CHAR NO-UNDO.
   DEF VAR val1 AS CHAR NO-UNDO.
   
   DEF VAR oParam1    AS TAArray    NO-UNDO.
   DEF VAR oper10Info AS TAArray    NO-UNDO.
   DEF VAR dSum       AS DEC INIT 0 NO-UNDO.
   
   DEF BUFFER bOp        FOR op.
   DEF BUFFER bufOpEntry FOR op-entry.
   DEF VAR oClient AS TClient    NO-UNDO.
   DEF VAR oAcct   AS TAcctBal   NO-UNDO.

   DEF VAR cComAcct AS CHAR      NO-UNDO.


   oParam1 = NEW TAArray().
   oper10Info = DYNAMIC-FUNCTION("getOper10Info" IN h_pir27).
   oParam1:setH('isSkip','YES').


   {foreach oper10Info key1 val1}
     dSum = 0.
    IF key1 <> "" THEN DO:       
     CASE ENTRY(2,key1,"-"):
        WHEN "09" THEN DO:

        oParam1:setH('op-date',ENTRY(1,key1,"-")).
        oParam1:setH('tyo',ENTRY(2,key1,"-")).
        oParam1:setH('op',ENTRY(3,key1,"-")).
        oParam1:setH('acct-db',ENTRY(3,key1,"-")).
        oParam1:setH('acct-cr','20202*').
        oParam1:setH('acct',ENTRY(3,key1,"-")).

        oClient = NEW TClient(ENTRY(3,key1,"-")).
         oParam1:setH('isLnk',oClient:isDepended(DATE(ENTRY(1,key1,"-")))).          
         oParam1:setH('name-short',oClient:name-short).
        DELETE OBJECT oClient.
      
        oAcct = NEW TAcctBal(ENTRY(3,key1,"-")).
        cComAcct = oAcct:getAlias40821(DATE(ENTRY(1,key1,"-"))).      

        FOR EACH bufOpEntry WHERE bufOpEntry.op-date EQ DATE(ENTRY(1,key1,"-")) AND bufOpEntry.acct-db EQ cComAcct
                            AND CAN-DO("70601810100001210211",bufOpEntry.acct-cr) NO-LOCK,
           FIRST bOp OF bufOpEntry WHERE CAN-DO("04018com,04012k+q,16017b",bOp.op-kind) NO-LOCK:
            dSum = dSum + bufOpEntry.amt-rub.
        END.

        oParam1:setH('fprice',DEC(dSum)).
        oParam1:setH('cprice',DEC(dSum) / DEC(val1)).
        oParam1:setH('count',DEC(val1)).

        oParam1:setH('isSkip','NO').
        RUN createLine(oParam1).

        DELETE OBJECT oAcct.

        END.

        WHEN "10_1" THEN DO:
        oParam1:setH('op-date',ENTRY(1,key1,"-")).
        oParam1:setH('tyo',ENTRY(2,key1,"-")).
        oParam1:setH('op',ENTRY(3,key1,"-")).
        oParam1:setH('acct-db',ENTRY(3,key1,"-")).
        oParam1:setH('acct-cr','20202*').
        oParam1:setH('acct',ENTRY(3,key1,"-")).

        oClient = NEW TClient(ENTRY(3,key1,"-")).
         oParam1:setH('isLnk',oClient:isDepended(DATE(ENTRY(1,key1,"-")))).          
         oParam1:setH('name-short',oClient:name-short).
        DELETE OBJECT oClient.

        oAcct = NEW TAcctBal(ENTRY(3,key1,"-")).
          cComAcct = oAcct:getAlias40821(DATE(ENTRY(1,key1,"-"))).
        DELETE OBJECT oAcct.

        FOR EACH bufOpEntry WHERE bufOpEntry.op-date EQ DATE(ENTRY(1,key1,"-")) 
                                AND bufOpEntry.acct-db EQ cComAcct
                                AND CAN-DO("70601810100001210211,706018105*1210235",bufOpEntry.acct-cr) NO-LOCK,
                               FIRST bOp OF bufOpEntry WHERE CAN-DO("16014b,16021,161195",bOp.op-kind) NO-LOCK:
                                    dSum = dSum + bufOpEntry.amt-rub.
        END.

        oParam1:setH('fprice',DEC(dSum) / DEC(val1)).
        oParam1:setH('cprice',DEC(dSum) / DEC(val1)).
        oParam1:setH('count',DEC(val1)).

        oParam1:setH('amt-rub',val1).
        oParam1:setH('isSkip','NO').

        RUN createLine(oParam1).
        END.
        WHEN "10_2" THEN DO:

        oParam1:setH('op-date',ENTRY(1,key1,"-")).
        oParam1:setH('tyo',ENTRY(2,key1,"-")).
        oParam1:setH('op',ENTRY(3,key1,"-")).
        oParam1:setH('acct-db',ENTRY(3,key1,"-")).
        oParam1:setH('acct-cr','20202*').
        oParam1:setH('acct',ENTRY(3,key1,"-")).

        oClient = NEW TClient(ENTRY(3,key1,"-")).
         oParam1:setH('isLnk',oClient:isDepended(DATE(ENTRY(1,key1,"-")))).          
         oParam1:setH('name-short',oClient:name-short).
        DELETE OBJECT oClient.

        oAcct = NEW TAcctBal(ENTRY(3,key1,"-")).
          cComAcct = oAcct:getAlias40821(DATE(ENTRY(1,key1,"-"))).
        DELETE OBJECT oAcct.

        FOR EACH bufOpEntry WHERE bufOpEntry.op-date EQ DATE(ENTRY(1,key1,"-")) 
                                AND bufOpEntry.acct-db EQ cComAcct
                                AND CAN-DO("70601810100001210211,706018105*1210235",bufOpEntry.acct-cr) NO-LOCK,
                               FIRST bOp OF bufOpEntry WHERE CAN-DO("16014b,16021,161195-2",bOp.op-kind) NO-LOCK:
                                    dSum = dSum + bufOpEntry.amt-rub.
        END.

        oParam1:setH('amt-rub',ENTRY(2,val1,"-")).
        oParam1:setH('dCom',DEC(dSum)).
        oParam1:setH('fprice',ROUND(DEC(dSum) * 100 / DEC(ENTRY(2,val1,"-")),2)).
        oParam1:setH('cprice',ROUND(DEC(dSum) * 100 / DEC(ENTRY(2,val1,"-")),2)).
        oParam1:setH('count',DEC(ENTRY(1,val1,"-"))).

        oParam1:setH('isSkip','NO').

        RUN createLine(oParam1).

        END.
     END CASE.


    END.
   {endforeach oper10Info}
   
   oper10Info:empty().
   DELETE OBJECT oParam1.
END FUNCTION.

FUNCTION calcBNKCard RETURNS LOG(INPUT dBegDate AS DATE,INPUT dEndDate AS DATE):

/****************************************
 *
 * Отчет по транзакциям пластиковых карт.
 *
 *****************************************
 *
 * Автор : Маслов Д. А. Maslov D. A.
 * Создан: 15.08.12
 * Заявка: #1233
 *
 *****************************************/


DEF VAR oAArray  AS TAArray NO-UNDO.
DEF VAR oParam   AS TAArray NO-UNDO.
DEF VAR dResult  AS DEC     NO-UNDO.
DEF VAR i        AS INT     NO-UNDO.

DEF VAR oClient  AS TClient NO-UNDO.

FOR EACH pc-trans WHERE CAN-DO("TransCard,TransCommis,TransDispute,TransSummary,TransAcquiring,MBCard,OST24Card,PSBCard,UCSCard,KOMPASPlus,OST24Commis,KPCommis,OST24Dispute,OST24Summary,ExpoAcq,UCSAcq,pc-trans",pc-trans.class-code) 
                     AND pc-trans.cont-date >= dBegDate AND pc-trans.cont-date <= dEndDate 
                     AND pc-trans.pctr-code BEGINS 'СнятиеНал' 
                    NO-LOCK:

oAArray = NEW TAArray().
oParam  = NEW TAArray().
oParam:setH("isSkip",YES).
FOR EACH signs WHERE signs.file-name  EQ 'op'
                 AND signs.code       EQ 'ТранзПЦ'
                 AND signs.code-value EQ  STRING(pc-trans.pctr-id) NO-LOCK,
 FIRST op WHERE op.op EQ INT(signs.surrogate) NO-LOCK,
   FIRST op-entry OF op WHERE acct-db BEGINS "4" NO-LOCK:

    oClient = NEW TClient(op-entry.acct-db).
     oParam:setH("name-short",oClient:name-short).
     oParam:setH("acct",op-entry.acct-db).
     oParam:setH("isLnk",oClient:isDepended(pc-trans.cont-date)).
    DELETE OBJECT oClient.
oParam:setH("isSkip",NO).
             
END.

  FOR EACH pc-trans-amt OF pc-trans NO-LOCK:
      oAArray:setH(pc-trans-amt.amt-code,pc-trans-amt.amt-cur).
  END.

dResult = ROUND(DEC(oAArray:get("КМССЧ")) / DEC(oAArray:get("СУМСЧ")),2).

 IF pc-trans.eq_aff = "Наше" THEN DO:
     oParam:setH("tyo","500_1").
 END. ELSE DO:
     oParam:setH("tyo","500_2").
 END.


     oParam:setH("op-date",pc-trans.cont-date).
     oParam:setH("op",pc-trans.pctr-id).
     oParam:setH("acct-db",pc-trans.num-card).
     oParam:setH("acct-cr",pc-trans.num-card).
     oParam:setH("fprice",dResult).
     oParam:setH("cprice",dResult).
     oParam:setH("amt-rub",oAArray:get("СУМСЧ")).
     oParam:setH("dCom",oAArray:get("КМССЧ")).
 RUN CreateLine(oParam).

DELETE OBJECT oAArray.
DELETE OBJECT oParam.
END.

END FUNCTION.

DEF VAR currDate   AS DATE                 NO-UNDO.
DEF VAR currOper   AS CHAR                 NO-UNDO.
DEF VAR dBegDate   AS DATE INIT 01/10/2012 NO-UNDO.
DEF VAR dEndDate   AS DATE INIT 01/10/2012 NO-UNDO.
DEF VAR isLnk      AS LOG  INIT NO         NO-UNDO.
DEF VAR typeOper   AS TAArray              NO-UNDO.
DEF VAR isExclude  AS LOG                  NO-UNDO.
DEF VAR oDoc       AS TDocument            NO-UNDO.

DEF VAR hOp        AS HANDLE               NO-UNDO.

DEF VAR paramList  AS CHAR                 NO-UNDO.
DEF VAR oCodeCalc  AS TAArray              NO-UNDO.


ASSIGN
  dBegDate = DataBlock.Beg-Date
  dEndDate = DataBlock.End-Date
 .
RUN initProc IN h_pir27.

paramList = GetEntries(1,param-calc,"","").

oCodeCalc = NEW TAArray().

   FOR EACH code WHERE code.class EQ "PirOperTypes" 
                                  AND LOGICAL(code.misc[1]) 
                              NO-LOCK:

        IF code.description[3] <> "" AND code.description[3] <> ? THEN DO:
           oCodeCalc:setH(code.code,code.description[3]).
        END. ELSE DO:
          oCodeCalc:setH(code.code,"fillExtInfo" + code.code).
        END.
   END.


/*********
 * Шаг №1.
 * Просчет по документам.
 *********/


DO currDate = dBegDate TO dEndDate:

   onBegDate(currDate).

   FOR EACH op WHERE op.op-date EQ currDate NO-LOCK,
     FIRST signs WHERE signs.file-name EQ "op" 
                   AND signs.surrogate EQ STRING(op.op) 
                   AND signs.code EQ "PirF227Oper" 
                   AND signs.xattr-value <> "":
     isExclude = LOGICAL(getXAttrValueEx("op",STRING(op.op),"PirF227Exc","NO")).

     hOp = BUFFER op:HANDLE.

     currOper  = signs.xattr-value.

             

           IF NOT isExclude THEN DO:
             oDoc = NEW TDocument(hOp,FALSE).
                isLnk = oDoc:isBelongToDepended().
             DELETE OBJECT oDoc.

             onFindDoc(dBegDate,dEndDate,currDate,currOper,isLnk,hOp,oCodeCalc).
           END.

   END.
   onEndDate(currDate). 
END.

DELETE OBJECT oCodeCalc.

/***********
 * Шаг №2.
 * Просчет по транзакциям ПЦ.
 ***********/
/*DISPLAY "Начинаю расчет комиссий ПК".*/
calcBNKCard(dBegDate,dEndDate).

RUN delProc IN h_pir27.
{intrface.del}
RETURN "".