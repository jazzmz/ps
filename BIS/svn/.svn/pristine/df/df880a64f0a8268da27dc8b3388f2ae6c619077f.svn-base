/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2008 ЗАО "Банковские информационные системы"
     Filename: cashord.p
      Comment: "Кассовый ордер 1433-У"
   Parameters:
         Uses:
      Used by:
      Created: 22.06.2004 10:58 sadm    
     Modified: 22.06.2004 19:35 sadm 
     Modified: 05.08.2004 11:42 sadm 0033333: спрашивать тип ордера, если не автоопределился
     Modified: 11.08.2004 17:46 sadm 0033936: определение назв. удост.личности по классиф.     
     Modified: 30.10.2004 14:47 ligp 0032409: Доработка для печати по документам ВОК.
     Modified: 22.09.2005 kraw (049985) Совместимость с oracle
     Modified: 14.10.2005 kraw (0052810) Ошибка печати нескольких экземпляров
     Modified: 25.01.2012 SSA  Разбивка по кассовым символам, ФЛ/ЮЛ
*/


&GLOBAL-DEFINE LAW_318p YES

&SCOP OFFsigns YES


{globals.i}
{intrface.get xclass}
{intrface.get acct}
{intrface.get cust}
{parsin.def}
{chkacces.i}
{get-bankname.i}


DEFINE VARIABLE mdeDocSum    AS DECIMAL NO-UNDO.
DEFINE VARIABLE mdeNatSum    AS DECIMAL NO-UNDO.
DEFINE VARIABLE mdeSymSumIn  AS DECIMAL EXTENT 6 NO-UNDO.
DEFINE VARIABLE mdeSymSumOut AS DECIMAL
   &IF DEFINED(LAW_318p) <> 0 &THEN
      EXTENT 3
   &ELSE
      EXTENT 3
   &ENDIF
NO-UNDO.
DEFINE VARIABLE mchSymCodIn  AS CHARACTER EXTENT 6 NO-UNDO.
DEFINE VARIABLE mchSymCodOut AS CHARACTER
   &IF DEFINED(LAW_318p) <> 0 &THEN
      EXTENT 6
   &ELSE
      EXTENT 6
   &ENDIF
NO-UNDO.
DEFINE VARIABLE minCount       AS INTEGER    NO-UNDO.
DEFINE VARIABLE mchPayer       AS CHARACT EXTENT 3 INIT "" NO-UNDO.
DEFINE VARIABLE mchReceiver    AS CHARACT
   &IF DEFINED(LAW_318p) <> 0 &THEN
      EXTENT 3
   &ELSE
      EXTENT 3
   &ENDIF
INIT "" NO-UNDO.
DEFINE VARIABLE mchRecBank     AS CHARACTER EXTENT 2 NO-UNDO.
DEFINE VARIABLE AcctCr         LIKE op-entry.acct-cr  NO-UNDO.
DEFINE VARIABLE AcctDb         LIKE op-entry.acct-db  NO-UNDO.
DEFINE VARIABLE AcctDbCur      LIKE op-entry.currency NO-UNDO.
DEFINE VARIABLE AcctCrCur      LIKE op-entry.currency NO-UNDO.
DEFINE VARIABLE AcctKomis      LIKE op-entry.acct-db NO-UNDO.
DEFINE VARIABLE DocCur         LIKE op-entry.currency NO-UNDO.
DEFINE VARIABLE mdtDateDoc     AS DATE       NO-UNDO.
DEFINE VARIABLE mchOrdTypeDb   AS CHARACTER NO-UNDO.
DEFINE VARIABLE mchOrdTypeCr   AS CHARACTER NO-UNDO.
DEFINE VARIABLE mchIdentCard   AS CHARACTER NO-UNDO.
DEFINE VARIABLE CrCustCat      LIKE acct.cust-cat NO-UNDO.
DEFINE VARIABLE CrCustCat1     LIKE acct.cust-cat NO-UNDO.
DEFINE VARIABLE DbCustCat      LIKE acct.cust-cat NO-UNDO.
DEFINE VARIABLE DbCustCat1     LIKE acct.cust-cat NO-UNDO.
DEFINE VARIABLE CrContract     LIKE acct.contract NO-UNDO.
DEFINE VARIABLE mchBankName    AS CHARACTER NO-UNDO.
DEFINE VARIABLE mchBankBIK     AS CHARACTER NO-UNDO.
DEFINE VARIABLE mlgChoise      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE mchBankSity    AS CHARACTER NO-UNDO.
DEFINE VARIABLE mVOKDprID      AS CHARACTER NO-UNDO. /* ИД смены ВОК в документе */
DEFINE VARIABLE mDocument-id   AS CHARACTER NO-UNDO. /* Тип документа */
DEFINE VARIABLE mDocCodName    AS CHARACTER NO-UNDO. /* Код документа */
DEFINE VARIABLE mDetails       AS CHARACTER NO-UNDO.
DEFINE VARIABLE mPersonId      AS INTEGER   NO-UNDO.
DEFINE VARIABLE mIdCustAttr    AS CHARACTER NO-UNDO.
DEFINE VARIABLE mCustTable1    AS CHARACTER NO-UNDO.
DEFINE VARIABLE mINN           AS CHARACTER NO-UNDO.
DEFINE VARIABLE mDbBranchNam   AS CHARACTER NO-UNDO.
DEFINE VARIABLE mCrBranchOKATO AS CHARACTER NO-UNDO.
DEFINE VARIABLE mCrBranchNam   AS CHARACTER NO-UNDO.
DEFINE VARIABLE mTmpStr        AS CHARACTER NO-UNDO.
DEFINE VARIABLE mDocDate       AS CHARACTER NO-UNDO. /* Дата выдачи документа */
DEFINE VARIABLE mDocNum        AS CHARACTER NO-UNDO.
DEFINE VARIABLE mCustDocWho    AS CHARACTER EXTENT 2 NO-UNDO.
DEFINE VARIABLE mKasSchPol     AS CHARACTER NO-UNDO.
DEFINE VARIABLE mInnKas        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE mRecINN        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE mRecKPP        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE mRecOKATO      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE mRecAcct       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE mPayBank       AS CHARACTER EXTENT 2 NO-UNDO.
DEFINE VARIABLE mPayBankBik    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE mchFIO         AS CHARACTER NO-UNDO.
DEFINE VARIABLE mchWorkerBuh   AS CHARACTER NO-UNDO.
DEFINE VARIABLE mchWorkerKont  AS CHARACTER NO-UNDO.
DEFINE VARIABLE mchWorkerKas   AS CHARACTER NO-UNDO.
DEFINE BUFFER komis-op-entry FOR op-entry.
DEFINE BUFFER xhistory       FOR history.


DEFINE VARIABLE sum-amt-cur       LIKE op-entry.amt-cur  NO-UNDO.
DEFINE VARIABLE sum-amt-rub_1     LIKE op-entry.amt-rub  NO-UNDO.
DEFINE VARIABLE sum-amt-rub_2     LIKE op-entry.amt-rub  NO-UNDO.
DEFINE VARIABLE flag-doc-num      LIKE op.doc-num        NO-UNDO.
DEFINE VARIABLE kol-entry         AS INT64 INIT 0        NO-UNDO.
DEFINE VARIABLE fl-sum-symbol     AS LOGICAL             NO-UNDO.
DEFINE VARIABLE first_run         AS LOGICAL INIT YES    NO-UNDO.

DEF VAR fl51        AS LOGICAL INIT no NO-UNDO.
DEF VAR fl54        AS LOGICAL INIT no NO-UNDO.
DEF VAR flrazb5154  AS LOGICAL INIT no NO-UNDO.
def var Sum51 as DEC init 0 no-undo.
def var Sum54 as DEC init 0 no-undo.
def var kk as int init 0 no-undo.


DEFINE BUFFER bufentry FOR op-entry.


        /*  Общие условия для отбора проводок заданы в виде таблицы */
DEFINE TEMP-TABLE t1-rp NO-UNDO
    FIELD type           AS   CHARACTER
    FIELD acctdb         AS   CHARACTER
    FIELD acctcr         AS   CHARACTER
    FIELD val            AS   CHARACTER
.

	/*  Сюда заносятся проводки, попадающие под условия таблицы t1-rp */
DEFINE TEMP-TABLE t2-rp NO-UNDO
    FIELD type           AS   CHARACTER  
    FIELD acctdb         AS   CHARACTER  
    FIELD acctcr         AS   CHARACTER  
    FIELD val            AS   CHARACTER  
    FIELD op             AS   INT64      
    FIELD op-docnum      AS   CHARACTER	 
    FIELD sum-amt-rub    AS   DEC INIT 0 
    FIELD sum-amt-cur    AS   DEC INIT 0 
    FIELD symbol         AS   CHARACTER	 
    FIELD fl-twoentry    AS   LOGICAL	 	/* документ двухпроводочный */
.

	/*  Проводки из таблицы t2-rp сравниваются с условиями для формирования сводных ордеров t3-rp */
DEFINE TEMP-TABLE t3-rp NO-UNDO
    FIELD type           AS   CHARACTER 
    FIELD fl-twoentry    AS   LOGICAL   
    FIELD acctdb         AS   CHARACTER 
    FIELD acctcr         AS   CHARACTER 
    FIELD val            AS   CHARACTER 
    FIELD symbol         AS   CHARACTER 
    FIELD client         AS   CHARACTER 
    FIELD details        AS   CHARACTER 
.


/**********************************************************************/
{getdate.i}



ASSIGN
   mchBankName = cBankName
   mchBankBIK  = FGetSetting("БанкМФО", ?,"")
   mchBankSity = ", " + FGetSetting("БанкГород", ?,"")
   mKasSchPol  = FGetSetting("КасСчПол", "","")
   mInnKas     = FGetSetting("ПлатДок", "ВывИННКас","")
   first_run   = YES    
.


        /*  Наполнение таблицы t1-rp - Общие условия для отбора проводок */

  /* выдача по нашим ПК в разрезе валют */
create t1-rp.
assign 
    t1-rp.type = "03" 
    t1-rp.acctdb = "30233810300001500016"
    t1-rp.acctcr = "20202810200000000001"
    t1-rp.val = ""
.            
create t1-rp.
assign 
    t1-rp.type = "03" 
    t1-rp.acctdb = "30233840600001500016"
    t1-rp.acctcr = "20202840500000000001"
    t1-rp.val = "840"
.            
create t1-rp.
assign 
    t1-rp.type = "03" 
    t1-rp.acctdb = "30233978200001500016"
    t1-rp.acctcr = "20202978100000000001"
    t1-rp.val = "978"
.            

  /* выдача по чужимм ПК в разрезе валют */
create t1-rp.
assign 
    t1-rp.type = "03" 
    t1-rp.acctdb = "30233810400001500013"
    t1-rp.acctcr = "20202810200000000001"
    t1-rp.val = ""
.            
create t1-rp.
assign 
    t1-rp.type = "03" 
    t1-rp.acctdb = "30233840700001500013"
    t1-rp.acctcr = "20202840500000000001"
    t1-rp.val = "840"
.            
create t1-rp.
assign 
    t1-rp.type = "03" 
    t1-rp.acctdb = "30233978300001500013"
    t1-rp.acctcr = "20202978100000000001"
    t1-rp.val = "978"
.            

  /* прием по нашим ПК в разрезе валют */
create t1-rp.
assign 
    t1-rp.type = "04" 
    t1-rp.acctdb = "20202810200000000001"
    t1-rp.acctcr = "47422810600001500015"
    t1-rp.val = ""
.            
create t1-rp.
assign 
    t1-rp.type = "04" 
    t1-rp.acctdb = "20202840500000000001"
    t1-rp.acctcr = "47422840900001500015"
    t1-rp.val = "840"
.            
create t1-rp.
assign 
    t1-rp.type = "04" 
    t1-rp.acctdb = "20202978100000000001"
    t1-rp.acctcr = "47422978500001500015"
    t1-rp.val = "978"
.            



    		    /*  Наполнение таблицы t3-rp - Условия для формирования 
					сводных ордеров */

			/***   ВЫДАЧА НАЛИЧНОСТИ ***/

	  /* Выдача РУБЛЕЙ по нашим ПК для ФЛ с разбивкой по символам: 51,54,51 и 54 */


  /*  51  */
create t3-rp.
assign 
    t3-rp.type = "03" 
    t3-rp.fl-twoentry = no
    t3-rp.acctdb = "30233810300001500016"
    t3-rp.acctcr = "20202810200000000001"
    t3-rp.val = ""
    t3-rp.symbol = "51"
    t3-rp.client = "Выдача по ПОС-терминалу"
    t3-rp.details = "Выдача денежных средств при проведении операций по ПОС-терминалу по картам " + cBankName + " физических лиц"
.            
  /*  54  */
create t3-rp.
assign 
    t3-rp.type = "03" 
    t3-rp.fl-twoentry = no
    t3-rp.acctdb = "30233810300001500016"
    t3-rp.acctcr = "20202810200000000001"
    t3-rp.val = ""
    t3-rp.symbol = "54"
    t3-rp.client = "Выдача по ПОС-терминалу"
    t3-rp.details = "Выдача овердрафта при проведении операций по ПОС-терминалу по картам " + cBankName + " физических лиц"
. 
           
  /*  51 и 54  */
create t3-rp.
assign 
    t3-rp.type = "03" 
    t3-rp.fl-twoentry = yes
    t3-rp.acctdb = "30233810300001500016"
    t3-rp.acctcr = "20202810200000000001"
    t3-rp.val = ""
    t3-rp.symbol = "51,54"
    t3-rp.client = "Выдача по ПОС-терминалу"
    t3-rp.details = "Выдача денежных средств и овердрафта при проведении операций по ПОС-терминалу по картам " + cBankName + " физических лиц"
.            

	  /* Выдача ВАЛЮТЫ по нашим ПК для ФЛ без разбивки */

create t3-rp.
assign 
    t3-rp.type = "03" 
    t3-rp.fl-twoentry = no
    t3-rp.acctdb = "30233840600001500016"
    t3-rp.acctcr = "20202840500000000001"
    t3-rp.val = "840"
    t3-rp.symbol = ""
    t3-rp.client = "Выдача по ПОС-терминалу"
    t3-rp.details = "Выдача денежных средств при проведении операций по ПОС-терминалу по картам " + cBankName 
.            

create t3-rp.
assign 
    t3-rp.type = "03" 
    t3-rp.fl-twoentry = no
    t3-rp.acctdb = "30233978200001500016"
    t3-rp.acctcr = "20202978100000000001"
    t3-rp.val = "978"
    t3-rp.symbol = ""
    t3-rp.client = "Выдача по ПОС-терминалу"
    t3-rp.details = "Выдача денежных средств при проведении операций по ПОС-терминалу по картам " + cBankName
.       

	  /* Выдача РУБЛЕЙ по чужим ПК для ФЛ с разбивкой по символам: 51*/

  /*  51  */
create t3-rp.
assign 
    t3-rp.type = "03" 
    t3-rp.fl-twoentry = no
    t3-rp.acctdb = "30233810400001500013"
    t3-rp.acctcr = "20202810200000000001"
    t3-rp.val = ""
    t3-rp.symbol = "51"
    t3-rp.client = "Выдача по ПОС-терминалу"
    t3-rp.details = "Выдача денежных средств при проведении операций по ПОС-терминалу по картам других банков физических лиц"
.            

	  /* Выдача ВАЛЮТЫ по чужим ПК для ФЛ без разбивки */

create t3-rp.
assign 
    t3-rp.type = "03" 
    t3-rp.fl-twoentry = no
    t3-rp.acctdb = "30233840700001500013"
    t3-rp.acctcr = "20202840500000000001"
    t3-rp.val = "840"
    t3-rp.symbol = ""
    t3-rp.client = "Выдача по ПОС-терминалу"
    t3-rp.details = "Выдача денежных средств при проведении операций по ПОС-терминалу по картам других банков"
.            

create t3-rp.
assign 
    t3-rp.type = "03" 
    t3-rp.fl-twoentry = no
    t3-rp.acctdb = "30233978300001500013"
    t3-rp.acctcr = "20202978100000000001"
    t3-rp.val = "978"
    t3-rp.symbol = ""
    t3-rp.client = "Выдача по ПОС-терминалу"
    t3-rp.details = "Выдача денежных средств при проведении операций по ПОС-терминалу по картам других банков"
.            

	  /* Выдача РУБЛЕЙ по нашим ПК для ЮЛ с разбивкой по символам: 53 */

  /*  53  */
create t3-rp.
assign 
    t3-rp.type = "03" 
    t3-rp.fl-twoentry = no
    t3-rp.acctdb = "30233810300001500016"
    t3-rp.acctcr = "20202810200000000001"
    t3-rp.val = ""
    t3-rp.symbol = "53"
    t3-rp.client = "Выдача по ПОС-терминалу"
    t3-rp.details = "Выдача денежных средств при проведении операций по ПОС-терминалу по картам " + cBankName + " юридических лиц"
.            


			/***   ПРИЕМ НАЛИЧНОСТИ ***/

	  /* Прием РУБЛЕЙ по нашим ПК для ФЛ с разбивкой по символам: 31,14,31 и 14 */

  /*  31  */
create t3-rp.
assign 
    t3-rp.type = "04" 
    t3-rp.fl-twoentry = no
    t3-rp.acctdb = "20202810200000000001"
    t3-rp.acctcr = "47422810600001500015"
    t3-rp.val = ""
    t3-rp.symbol = "31"
    t3-rp.client = "Прием по ПОС-терминалу"
    t3-rp.details = "Прием денежных средств при проведении операций по ПОС-терминалу по картам " + cBankName + " физических лиц"
.            
  /*  14  */
create t3-rp.
assign 
    t3-rp.type = "04" 
    t3-rp.fl-twoentry = no
    t3-rp.acctdb = "20202810200000000001"
    t3-rp.acctcr = "47422810600001500015"
    t3-rp.val = ""
    t3-rp.symbol = "14"
    t3-rp.client = "Прием по ПОС-терминалу"
    t3-rp.details = "Прием денежных средств для погашения задолженности по овердрафту при проведении операций по ПОС-терминалу по картам " + cBankName + " физических лиц"
.            
  /*  31 и 14  */
create t3-rp.
assign 
    t3-rp.type = "04" 
    t3-rp.fl-twoentry = yes
    t3-rp.acctdb = "20202810200000000001"
    t3-rp.acctcr = "47422810600001500015"
    t3-rp.val = ""
    t3-rp.symbol = "31,14"
    t3-rp.client = "Прием по ПОС-терминалу"
    t3-rp.details = "Прием денежных средств для пополнения ПК и погашения задолженности по овердрафту при проведении операций по ПОС-терминалу по картам " + cBankName + " физических лиц"
.            

	  /* Прием ВАЛЮТЫ по нашим ПК для ФЛ без разбивки */

create t3-rp.
assign 
    t3-rp.type = "04" 
    t3-rp.fl-twoentry = no
    t3-rp.acctdb = "20202840500000000001"
    t3-rp.acctcr = "47422840900001500015"
    t3-rp.val = "840"
    t3-rp.symbol = ""
    t3-rp.client = "Прием по ПОС-терминалу"
    t3-rp.details = "Прием денежных средств при проведении операций по ПОС-терминалу по картам " + cBankName
.            

create t3-rp.
assign 
    t3-rp.type = "04" 
    t3-rp.fl-twoentry = no
    t3-rp.acctdb = "20202978100000000001"
    t3-rp.acctcr = "47422978500001500015"
    t3-rp.val = "978"
    t3-rp.symbol = ""
    t3-rp.client = "Прием по ПОС-терминалу"
    t3-rp.details = "Прием денежных средств при проведении операций по ПОС-терминалу по картам " + cBankName
.            

	  /* Прием РУБЛЕЙ по нашим ПК для ЮЛ с разбивкой по символам: 32 */

  /*  32  */
create t3-rp.
assign 
    t3-rp.type = "04" 
    t3-rp.fl-twoentry = no
    t3-rp.acctdb = "20202810200000000001"
    t3-rp.acctcr = "47422810600001500015"
    t3-rp.val = ""
    t3-rp.symbol = "32"
    t3-rp.client = "Прием по ПОС-терминалу"
    t3-rp.details = "Прием денежных средств при проведении операций по ПОС-терминалу по картам " + cBankName + " юридических лиц"
.            


/**********************************************************************/


FOR EACH t1-rp NO-LOCK:


	/*   Отбор всех проводок, отвечающих условиям в таблице t1-rp   */

  FOR EACH op-entry 
  WHERE op-entry.acct-db EQ t1-rp.acctdb
    AND op-entry.acct-cr EQ t1-rp.acctcr
    AND op-entry.op-date EQ end-date
  NO-LOCK:

    FIND FIRST op OF op-entry NO-LOCK NO-ERROR.

      /* проверяем, есть ли ещё проводки в документе */
    kol-entry = 0 .
       
    FOR EACH bufentry 
    WHERE bufentry.op EQ op-entry.op   
      AND bufentry.op-transaction EQ op-entry.op-transaction 
    NO-LOCK:

      kol-entry = kol-entry + 1 .

    END.
 
    IF AVAIL (op) THEN
    DO:
      CREATE t2-rp.
      ASSIGN 
        t2-rp.type         = t1-rp.type 
        t2-rp.acctdb       = t1-rp.acctdb 
        t2-rp.acctcr       = t1-rp.acctcr 
        t2-rp.val          = t1-rp.val 
        t2-rp.op           = op.op
        t2-rp.op-docnum    = op.doc-num
        t2-rp.sum-amt-rub  = op-entry.amt-rub
        t2-rp.sum-amt-cur  = op-entry.amt-cur
        t2-rp.symbol       = op-entry.symbol
        t2-rp.fl-twoentry  = IF kol-entry > 1 THEN yes ELSE no
     .
    END.
    ELSE
      MESSAGE "Проводка " op-entry.op-entry " без документа !!!" VIEW-AS ALERT-BOX.

  END. /*for each op-entry*/

END. /*for each t1-rp*/



/**********************************************************************/
/* Новое веяние по заявке #2754 */
/* Конечно, очень коряво. Но это под конктретный случай. Под другие вроде оставить как раньше :(( */

FOR EACH  t2-rp  WHERE  CAN-DO("51,54",t2-rp.symbol)  AND  t2-rp.val = ""  AND  t2-rp.acctdb = "30233810300001500016"
NO-LOCK:
  IF AVAIL (t2-rp) THEN
  DO:
	IF t2-rp.symbol = "51" THEN 
	  DO:
		fl51 = yes .
		Sum51 = Sum51 + t2-rp.sum-amt-rub .
	  END.
	IF t2-rp.symbol = "54" THEN 
	  DO:
		fl54 = yes .
		Sum54 = Sum54 + t2-rp.sum-amt-rub .
	  END.
  END.
END.

IF  fl51  OR  fl54  THEN  
DO:

  flrazb5154 = yes.

  FOR EACH  t2-rp  WHERE  t2-rp.symbol = "51"  AND  t2-rp.val = ""  AND  t2-rp.acctdb = "30233810300001500016" :
     kk = kk + 1 .
     IF kk = 1 THEN 
	DO:
        t2-rp.sum-amt-rub  = Sum51 .
        t2-rp.fl-twoentry  = (IF  fl51 AND fl54  THEN yes ELSE no ) .
	END.
     ELSE 
	DELETE t2-rp .
  END.

  kk = 0 .
  FOR EACH  t2-rp  WHERE  t2-rp.symbol = "54"  AND  t2-rp.val = ""  AND  t2-rp.acctdb = "30233810300001500016" :
     kk = kk + 1 .
     IF kk = 1 THEN 
	DO:
        t2-rp.sum-amt-rub  = Sum54 .
        t2-rp.fl-twoentry  = (IF  fl51 AND fl54  THEN yes ELSE no ) .
	END.
     ELSE 
	DELETE t2-rp .
  END.

END.

 

/**********************************************************************/


/**********************************************************************/



FOR EACH t3-rp NO-LOCK:

{setdest.i}

  ASSIGN
    sum-amt-cur    = 0
    sum-amt-rub_1  = 0
    sum-amt-rub_2  = 0
    fl-sum-symbol = no
    flag-doc-num = ""

    mdeSymSumIn[1] = 0
    mdeSymSumIn[2] = 0  
    mchSymCodIn[1] = "" 
    mchSymCodIn[2] = "" 
                         
    mdeSymSumOut[1] = 0 
    mdeSymSumOut[2] = 0 
    mchSymCodOut[1] = ""
    mchSymCodOut[2] = ""
  .


  FOR EACH t2-rp
  WHERE t2-rp.acctdb EQ t3-rp.acctdb
    AND t2-rp.acctcr EQ t3-rp.acctcr
    AND t2-rp.val    EQ t3-rp.val
    AND ( 
       ( t2-rp.symbol EQ t3-rp.symbol AND t2-rp.fl-twoentry = no )
         OR
       ( t2-rp.symbol NE t3-rp.symbol AND CAN-DO(t3-rp.symbol,t2-rp.symbol) AND t2-rp.fl-twoentry = yes )
        )
  NO-LOCK:

    IF AVAIL (t2-rp) THEN
      DO:

        fl-sum-symbol = yes .

        IF flag-doc-num = "" THEN
          flag-doc-num = t2-rp.op-docnum .

        IF t2-rp.fl-twoentry = yes THEN
          DO:
            IF t2-rp.symbol = ENTRY(1,t3-rp.symbol) THEN
              sum-amt-rub_1 = sum-amt-rub_1 + t2-rp.sum-amt-rub .
            IF t2-rp.symbol = ENTRY(2,t3-rp.symbol) THEN
              sum-amt-rub_2 = sum-amt-rub_2 + t2-rp.sum-amt-rub .
          END.
        ELSE
          DO:
            sum-amt-rub_1 = sum-amt-rub_1 + t2-rp.sum-amt-rub .
            sum-amt-cur   = sum-amt-cur   + t2-rp.sum-amt-cur .
          END.

      END.

  END. /* end for each t2 */

  IF fl-sum-symbol = yes AND flag-doc-num NE "" THEN
    DO:
        mdtDateDoc = end-date.
        mchPayer = IF t3-rp.type = "04" THEN  t3-rp.client ELSE "".
        mchReceiver = IF t3-rp.type = "03" THEN  t3-rp.client ELSE "".
        mchRecBank[1] = mchBankName.
        acctdb = t3-rp.acctdb .
        acctcr = t3-rp.acctcr .
        mdeDocSum = IF t3-rp.val EQ "" THEN (sum-amt-rub_1 + sum-amt-rub_2) ELSE sum-amt-cur  .
        DocCur = t3-rp.val   .


        mdeSymSumIn[1]  = IF t3-rp.type EQ "04" AND t3-rp.val = ""  THEN  sum-amt-rub_1 ELSE 0  .
	IF sum-amt-rub_2 > 0 THEN mdeSymSumIn[2]  =  IF t3-rp.type EQ "04" AND t3-rp.val = ""  THEN  sum-amt-rub_2 ELSE 0  .
        mdeSymSumOut[1] = IF t3-rp.type EQ "03" AND t3-rp.val = ""  THEN  sum-amt-rub_1 ELSE 0   .
        IF sum-amt-rub_2 > 0 THEN mdeSymSumOut[2] =  IF t3-rp.type EQ "03" AND t3-rp.val = ""  THEN  sum-amt-rub_2 ELSE 0  .
        mdeNatSum = 0 .
        mchSymCodIn[1] =  IF t3-rp.type EQ "04" AND t3-rp.val = ""  THEN  SUBSTR(t3-rp.symbol,1,2) ELSE ""  . 
        IF sum-amt-rub_2 > 0 THEN mchSymCodIn[2]  =  IF t3-rp.type EQ "04" AND t3-rp.val = ""  THEN  ENTRY(2,t3-rp.symbol) ELSE ""  . 
        mchSymCodOut[1] = IF t3-rp.type EQ "03" AND t3-rp.val = ""  THEN  SUBSTR(t3-rp.symbol,1,2) ELSE ""  . 
        IF sum-amt-rub_2 > 0 THEN mchSymCodOut[2] = IF t3-rp.type EQ "03" AND t3-rp.val = ""   THEN  ENTRY(2,t3-rp.symbol) ELSE ""  . 


        mDetails = t3-rp.details .
        mchIdentCard =  "" .
        mDocCodName = "" .
        mCustDocWho[1] = "" .
        mDocDate = "" .
        mDocNum = "".
        mRecInn  = "" .
        mchBankBIK = "" .
        mRecKPP = "" .
        mRecOKATO = "" .
        mRecAcct = "" .
        mPayBank[1] = IF t3-rp.type = "04" THEN mchBankName ELSE "" .
        mPayBankBik = "" .
        AcctKomis = "" .
        mchFIO = "" .
        mchWorkerBuh = "" .
        mchWorkerKont = "" .
        mchWorkerKas = "" .


        IF first_run AND t3-rp.type EQ "03"   THEN
        DO:  
           /* MESSAGE "first run 03!" VIEW-AS ALERT-BOX. */
           {docform.i
           &cashord      = ""расходный""
           &docdate      = mdtDateDoc
           &docnum       = flag-doc-num
           &payer        = mchPayer
           &receiver     = mchReceiver
           &recbank      = mchRecBank
   	   &dbacct       = acctdb
           &cracct       = acctcr
           &docsum       = mdeDocSum
           &doccur       = DocCur
           &symsumin     = mdeSymSumIn
           &symsumout    = mdeSymSumOut
           &natsum       = mdeNatSum
           &symcodin     = mchSymCodIn
           &symcodout    = mchSymCodOut
           &details      = mDetails
           &identcard    = mchIdentCard
           &documentid   = mDocCodName
           &documentnum  = mDocNum
           &documentwho  = mCustDocWho
           &documentdate = mDocDate
           &recinn       = mRecInn
           &recbankbik   = mchBankBIK
           &reckpp       = mRecKPP
           &recokato     = mRecOKATO
           &recacct      = mRecAcct
           &paybank      = mPayBank
           &paybankbik   = mPayBankBik
           &acctkomis    = AcctKomis
           &inc_part_fio = mchFIO
           &worker_buh   = mchWorkerBuh
           &worker_kont  = mchWorkerKont
           &worker_kas   = mchWorkerKas
           }
 	   {preview.i}
         END.
        
        IF first_run AND t3-rp.type EQ "04"  THEN
        DO:
           /* MESSAGE "first run! 04" VIEW-AS ALERT-BOX. */
           {docform.i
           &nodef = YES
           &cashord      = ""приходный""
           &docdate      = mdtDateDoc
           &docnum       = flag-doc-num
   	   &payer        = mchPayer
           &receiver     = mchReceiver
           &recbank      = mchRecBank
           &dbacct       = acctdb
           &cracct       = acctcr
           &docsum       = mdeDocSum
           &doccur       = DocCur
           &symsumin     = mdeSymSumIn
           &symsumout    = mdeSymSumOut
           &natsum       = mdeNatSum
           &symcodin     = mchSymCodIn
           &symcodout    = mchSymCodOut
           &details      = mDetails
           &identcard    = mchIdentCard
           &documentid   = mDocCodName
           &documentnum  = mDocNum
           &documentwho  = mCustDocWho
           &documentdate = mDocDate
           &recinn       = mRecInn
           &recbankbik   = mchBankBIK
           &reckpp       = mRecKPP
           &recokato     = mRecOKATO
           &recacct      = mRecAcct
           &paybank      = mPayBank
           &paybankbik   = mPayBankBik
           &acctkomis    = AcctKomis
           &inc_part_fio = mchFIO
           &worker_buh   = mchWorkerBuh
           &worker_kont  = mchWorkerKont
           &worker_kas   = mchWorkerKas
           }
 	   {preview.i}
         END.
        
        
        IF NOT first_run AND t3-rp.type EQ "03"  THEN
        DO:
           /* MESSAGE "not first run 03!" VIEW-AS ALERT-BOX. */
           {docform.i
   	   &cashord      = ""расходный""
           &nodef        = YES        
           &docdate      = mdtDateDoc
           &docnum       = flag-doc-num
           &payer        = mchPayer
           &receiver     = mchReceiver
           &recbank      = mchRecBank
           &dbacct       = acctdb
           &cracct       = acctcr
           &docsum       = mdeDocSum
           &doccur       = DocCur
           &symsumin     = mdeSymSumIn
           &symsumout    = mdeSymSumOut
           &natsum       = mdeNatSum
           &symcodin     = mchSymCodIn
           &symcodout    = mchSymCodOut
           &details      = mDetails
           &identcard    = mchIdentCard
           &documentid   = mDocCodName
           &documentnum  = mDocNum
           &documentwho  = mCustDocWho
           &documentdate = mDocDate
           &recinn       = mRecInn
           &recbankbik   = mchBankBIK
           &reckpp       = mRecKPP
           &recokato     = mRecOKATO
           &recacct      = mRecAcct
           &paybank      = mPayBank
           &paybankbik   = mPayBankBik
           &acctkomis    = AcctKomis
           &inc_part_fio = mchFIO
           &worker_buh   = mchWorkerBuh
           &worker_kont  = mchWorkerKont
           &worker_kas   = mchWorkerKas
           }
 	   {preview.i}
         END.
        
        IF NOT first_run AND t3-rp.type EQ "04"  THEN
   	DO:
           /* MESSAGE "not first run 04!" VIEW-AS ALERT-BOX. */
           {docform.i
           &cashord      = ""приходный""
           &nodef = YES
           &docdate      = mdtDateDoc
           &docnum       = flag-doc-num
           &payer        = mchPayer
           &receiver     = mchReceiver
           &recbank      = mchRecBank
           &dbacct       = acctdb
           &cracct       = acctcr
           &docsum       = mdeDocSum
           &doccur       = DocCur
           &symsumin     = mdeSymSumIn
           &symsumout    = mdeSymSumOut
           &natsum       = mdeNatSum
           &symcodin     = mchSymCodIn
           &symcodout    = mchSymCodOut
           &details      = mDetails
           &identcard    = mchIdentCard
           &documentid   = mDocCodName
           &documentnum  = mDocNum
           &documentwho  = mCustDocWho
           &documentdate = mDocDate
           &recinn       = mRecInn
           &recbankbik   = mchBankBIK
           &reckpp       = mRecKPP
           &recokato     = mRecOKATO
           &recacct      = mRecAcct
           &paybank      = mPayBank
           &paybankbik   = mPayBankBik
           &acctkomis    = AcctKomis
           &inc_part_fio = mchFIO
           &worker_buh   = mchWorkerBuh
           &worker_kont  = mchWorkerKont
           &worker_kas   = mchWorkerKas
           }
 	   {preview.i}
         END.
        
         first_run = NO .
        
   END. /* end if fl-sum-symbol = yes */

/* {preview.i} */

END. /* end for each t3 */


