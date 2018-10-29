/*-----------------------------------------------------------------------------
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2001 ТОО "Банковские информационные системы"
     Filename: F401P.P
      Comment: Процедура вывода строки отчета по форме 401 (3-АП)
         Uses:
      Used BY:
      Created: 09/04/2001 yakv
     Modified: 20/04/2001 yakv - Домножение на коэффициент УКБ/ДКБ (для 1П8)
     Modified: 23/04/2001 yakv - расчет технологического раздела 0
     Modified: 25/04/2001 yakv - Деление на 1000 и округление
     Modified: 02/07/2001 yakv - 1.01 Fixed: ошибка округления в графе 3 "Переоценка"
     Modified: 05/01/2004 NIK  - Унификация процедур расчета итогов и подитогов
     
     
    Синтаксис: [f401p( класс|строка|знач1,знач2|i1,i2,...,iN|разд )], где:
               класс      имя класса данных
               строка     код строки формы 401
               значN      перечень значений для отбора
               i1,i2,...  перечень номеров Val[i] для вывода
               разд       разделитель значений
*/

&IF DEFINED(FILE_f401p_p) EQ 0 &THEN

DEF OUTPUT PARAM xResult AS dec         NO-UNDO.
DEF INPUT  PARAM beg     AS DATE        NO-UNDO.
DEF INPUT  PARAM dob     AS DATE        NO-UNDO.
DEF INPUT  PARAM str     AS CHAR        NO-UNDO.

DEF VAR asDataClass LIKE dataclass.dataclass-id     INIT ?          NO-UNDO.
DEF VAR asLineCode  AS CHAR                         INIT ?          NO-UNDO.
DEF VAR nFormPart   AS INT64                          INIT ?          NO-UNDO.
DEF VAR asCntrGroup AS CHAR                         INIT ?          NO-UNDO.
DEF VAR asCountry   AS CHAR                         INIT ?          NO-UNDO.
DEF VAR asValues    AS CHAR                         INIT ""         NO-UNDO.
DEF VAR anDivider   AS INT64                          INIT 1000       NO-UNDO.
DEF VAR i           AS INT64                                          NO-UNDO.
DEF VAR nDataId     LIKE datablock.data-id          INIT ?          NO-UNDO.
DEF VAR nValQty     AS INT64                          INIT 12         NO-UNDO.
DEF VAR nLineVal    AS decimal  EXTENT 12                           NO-UNDO.
DEF VAR nValues     AS decimal  EXTENT 12                           NO-UNDO.
DEF VAR sFormats    AS CHAR     EXTENT 12                           NO-UNDO.
DEF VAR bParse      AS LOGICAL                                      NO-UNDO.
DEF VAR bAccum      AS LOGICAL                                      NO-UNDO.
DEF VAR sDelim      AS CHAR                         INIT "│"        NO-UNDO.
DEF VAR sResult     AS CHAR                         INIT ""         NO-UNDO.
DEF VAR sAttr1      AS CHAR                                         NO-UNDO.
DEF VAR sAttr2      AS CHAR                                         NO-UNDO.
DEF VAR sAttr3      AS CHAR                                         NO-UNDO.
DEF VAR sAttr4      AS CHAR                                         NO-UNDO.
DEF VAR sCapStr     AS CHAR                                         NO-UNDO.
DEF VAR sLineNum    AS CHAR                                         NO-UNDO.
DEF VAR nData1P8    LIKE datablock.data-id          INIT ?          NO-UNDO.
DEF VAR bCapProc    AS LOGICAL                      INIT FALSE      NO-UNDO.
DEF VAR nCapCoef1   AS decimal                      INIT 0          NO-UNDO.
DEF VAR nCapCoef2   AS decimal                      INIT 0          NO-UNDO.
DEF VAR dTimeProc   AS INT64                                          NO-UNDO.
DEF VAR vRepType    AS CHAR                                         NO-UNDO.
DEF VAR mOkr        AS LOGICAL                                      NO-UNDO.

DEF BUFFER tData1P8     FOR dataline.

{globals.i}
{norm.i}
{f401.fun}
{f401calc.pro {&*}}

/*======================================================= НАЧАЛО ВЫПОЛНЕНИЯ ==*/

ASSIGN dTimeProc = time.
ASSIGN
   asDataClass = ENTRY(1, str, "|")
   asLineCode  = ENTRY(2, str, "|")
   asValues    = ENTRY(4, str, "|")
   xResult     = 0
   printres    = NO
   mOkr  =      (FGetSetting("Форма401","УКБ_ДКБ_округл","Нет") EQ "Да")
   mRound = int64(getxattrvalueEx("dataclass",asDataClass,"Param-Calc","1"))
.
ASSIGN sDelim = ENTRY( 5, str, "|" ) NO-ERROR.

anDivider = INT64(FGetSetting("Форма401","Divider","1")).
vRepType  = GetSysConf({&REPORT-LABEL}).

IF vRepType EQ "" OR vRepType EQ ? THEN
   vRepType = ENTRY( 3, str, "|" ).

nFormPart = F401_FormPart(asLineCode).

IF nFormPart >= 0 AND
   nFormPart <= 4 THEN ASSIGN
   asCntrGroup = ENTRY(1, vRepType)
   asCountry   = ENTRY(2, vRepType)
.
&IF DEFINED(s401) &THEN
IF asCountry = "*" THEN
   asCountry = asCntrGroup.
anDivider = 1.
&ELSE
/* Строки <НомерСтроки_ГруппаСтран>, обрабатывваются особым образом */
IF INDEX(asLineCode,"_") GT 0  AND asCountry = "*" THEN
   asCountry = "".
&ENDIF
/*-----------------------------------------------------------------------------
--  Определение data-id
-----------------------------------------------------------------------------*/
RUN sv-get.p (asDataClass, sh-branch-id, beg, dob, OUTPUT nDataId).
IF nDataId EQ ? THEN DO:
   RUN normdbg IN h_debug (0, "Ошибка", "Невозможно рассчитать данные по классу ~"" + asDataClass + "~"!").
   RETURN.
END.

FIND FIRST dataclass WHERE dataclass.dataclass-id EQ asDataClass NO-LOCK.
FIND FIRST datablock WHERE datablock.data-id      EQ nDataId     SHARE-LOCK.

/*-----------------------------------------------------------------------------
--  Инициализация значений и форматов
-----------------------------------------------------------------------------*/
DO i = 1 TO nValQty:
   IF UseValue(i, asValues) THEN
      ASSIGN gValue[i]   = 0
             sFormats[i] = IF num-entries(OutputFormat,".") GE 2 THEN
                           STRING(ENTRY(1,OutputFormat,".") + "." + FILL("9",mRound),"x(" + STRING(LENGTH(OutputFormat)) + ")")
                           ELSE outputformat.
                            
END.


/*------------------------------- Расчет значений для результирующей строки --*/
RUN CalcLine (INPUT nDataID,                     /* идентификатор блока       */
              INPUT asDataClass,                 /* идентификатор класса      */
              INPUT asLineCode,                  /* код формулы (строки)      */
              INPUT asCntrGroup,                 /* группа стран              */
              INPUT asCountry,                   /* страна                    */
              INPUT nValQty,                     /* количество колонок        */
              INPUT anDivider,                   /* делитель                  */
              INPUT asValues).                   /* номера колонок            */

/*------- Корректировка погрешности графы 3 "Переоценка" для разделов 1 и 3 --*/
IF nFormPart = 1 OR
   nFormPart = 3 THEN DO:

   IF UseValue(3, asValues) THEN
      ASSIGN gValue[3] = gValue[5] - gValue[1] - gValue[2] - gValue[4].
END.

/*--------------------------------------------- Вывод результирующей строки --*/
DO i = 1 TO nValQty:
   IF UseValue(i, asValues) THEN do:
/* начало заявка 2047. надюсь все это удалится после доработки 0188574 в 97 патче*/
      DEF VAR oSysClass  AS TSysClass 	NO-UNDO.
      DEF VAR kursUSD 	 AS DEC 	NO-UNDO.
      DEF VAR res 	 AS DEC 	NO-UNDO.
      DEF VAR res2 	 AS DEC 	NO-UNDO.
      DEF VAR res3 	 AS DEC 	NO-UNDO.
      DEF VAR res4 	 AS DEC 	NO-UNDO.
      DEF VAR res5 	 AS DEC 	NO-UNDO.
      DEF VAR res6 	 AS DEC 	NO-UNDO.
      DEF VAR res7 	 AS DEC 	NO-UNDO.
      DEF VAR res8 	 AS DEC 	NO-UNDO.

      if beg-date eq ? or end-date eq ? then do:
		beg-date = datablock.Beg-Date.
                end-date = DataBlock.End-Date.
      end.	

      if asLineCode eq "1А11.1" or asLineCode eq "1А6.1" then do:
              oSysClass = NEW TSysClass().
              res = 0.
              FOR EACH op WHERE op.op-date GE beg-date AND op.op-date LE end-date NO-LOCK,
              	EACH op-entry OF op where can-do("45817*",op-entry.acct-db) and can-do("45708*",op-entry.acct-cr) NO-LOCK:
              		if avail(op-entry) then do:
              			kursUSD = oSysClass:getCBRKurs(840,op-entry.op-date).
				res = res + round((op-entry.amt-rub / kursUSD),2).
              		end.
              end.
              DELETE OBJECT oSysClass.
      end. 
      if asLineCode eq "1А11.2" or asLineCode eq "1А50.1" then do:
              oSysClass = NEW TSysClass().
              res2 = 0.
              FOR EACH op WHERE op.op-date GE beg-date AND op.op-date LE end-date NO-LOCK,
              	EACH op-entry OF op where can-do("45917*",op-entry.acct-db) and can-do("47427*",op-entry.acct-cr) NO-LOCK:
              		if avail(op-entry) then do:
              			kursUSD = oSysClass:getCBRKurs(840,op-entry.op-date).
				res2 = res2 + round((op-entry.amt-rub / kursUSD),2).
              		end.
              end.
              DELETE OBJECT oSysClass.
      end. 

      if asLineCode eq "1А6.1" and i = 2 then
      gValue[i] = gValue[i] + round(res / 1000,3).
      if asLineCode eq "1А11.1" and i = 2 then
      gValue[i] = gValue[i] - round(res / 1000,3).
      if asLineCode eq "1А6.1" and i = 4 then
      gValue[i] = 0 - round(res / 1000,3).
      if asLineCode eq "1А11.1" and i = 4 then
      gValue[i] = round(res / 1000,3).

      if asLineCode eq "1А11.2" and i = 2 then
      gValue[i] = gValue[i] - round(res2 / 1000,3).
      if asLineCode eq "1А50.1" and i = 2 then
      gValue[i] = gValue[i] + round(res2 / 1000,3).
      if asLineCode eq "1А11.2" and i = 4 then
      gValue[i] = round(res2 / 1000,3).
      if asLineCode eq "1А50.1" and i = 4 then
      gValue[i] = 0 - round(res2 / 1000,3).
/* конец заявка 2047. */

/* начало заявка 3282. надюсь все это удалится после доработки 0188574 в 97 патче*/
      if asLineCode eq "1П50.1" or asLineCode eq "1П50.2" then do:
             oSysClass = NEW TSysClass().
             res3 = 0.
             res4 = 0.
             res5 = 0.
             res6 = 0.
             res7 = 0.
             res8 = 0.
/*             FOR EACH op WHERE op.op-date GE beg-date AND op.op-date LE end-date NO-LOCK,
             		EACH op-entry OF op where can-do("47426*,47411*",op-entry.acct-db) and can-do("40807*,40820*,70606*",op-entry.acct-cr) NO-LOCK:
               		if avail(op-entry) then do:
               			find first loan-acct where loan-acct.acct eq op-entry.acct-db no-lock no-error.
               			find first loan of loan-acct no-lock no-error.
               			if avail(loan) then do:
               			    	find first loan-acct of loan where loan-acct.acct-type eq "loan-dps-t" or loan-acct.acct-type eq "Депоз"  no-lock no-error.
               				if avail(loan-acct) then do:
               					if can-do("42.01*,42.02*,42.03*,42.04*,42.05*",loan-acct.acct) then do: /* краткосрочные */
			               			kursUSD = oSysClass:getCBRKurs(840,op-entry.op-date).
							res3 = res3 + round((op-entry.amt-rub / kursUSD),2).
						end.
               					if can-do("42.06*,42.07*,42.08*,42.09*,42.10*,42.11*,42.12*,42.13*,42.14*,42.15*",loan-acct.acct) then do: /* долгосрочные */
			               			kursUSD = oSysClass:getCBRKurs(840,op-entry.op-date).
							res4 = res4 + round((op-entry.amt-rub / kursUSD),2).
						end.        
             				end. 
               			end.			
               		end.
              end.
*/
/*              FOR EACH op WHERE op.op-date GE beg-date AND op.op-date LE end-date NO-LOCK,
             		EACH op-entry OF op where can-do("70606*",op-entry.acct-db) and can-do("47426*,47411*",op-entry.acct-cr) NO-LOCK:
               		if avail(op-entry) then do:
               			find first loan-acct where loan-acct.acct eq op-entry.acct-cr no-lock no-error.
               			find first loan of loan-acct no-lock no-error.
               			if avail(loan) then do:
               			    	find first loan-acct of loan where loan-acct.acct-type eq "loan-dps-t" or loan-acct.acct-type eq "Депоз"  no-lock no-error.
               				if avail(loan-acct) then do:
               					if can-do("42.01*,42.02*,42.03*,42.04*,42.05*",loan-acct.acct) then do: /* краткосрочные */
			               			kursUSD = oSysClass:getCBRKurs(840,op-entry.op-date).
							res5 = res5 + round((op-entry.amt-rub / kursUSD),2).
						end.
               					if can-do("42.06*,42.07*,42.08*,42.09*,42.10*,42.11*,42.12*,42.13*,42.14*,42.15*",loan-acct.acct) then do: /* долгосрочные */
			               			kursUSD = oSysClass:getCBRKurs(840,op-entry.op-date).
							res6 = res6 + round((op-entry.amt-rub / kursUSD),2).
						end.        
             				end. 
               			end.			
               		end.
              end.
*/
              FOR EACH op WHERE op.op-date GE beg-date AND op.op-date LE end-date NO-LOCK,
             		EACH op-entry OF op where can-do("40807*,40820*",op-entry.acct-db) and can-do("47426*,47411*",op-entry.acct-cr) NO-LOCK:
               		if avail(op-entry) then do:
               			find first loan-acct where loan-acct.acct eq op-entry.acct-cr no-lock no-error.
               			find first loan of loan-acct no-lock no-error.
               			if avail(loan) then do:
               			    	find first loan-acct of loan where loan-acct.acct-type eq "loan-dps-t" or loan-acct.acct-type eq "Депоз"  no-lock no-error.
               				if avail(loan-acct) then do:
               					if can-do("!423*,!422*,!421*,42.01*,42.02*,42.03*,42.04*,42.05*",loan-acct.acct) then do: /* краткосрочные */
			               			kursUSD = oSysClass:getCBRKurs(840,op-entry.op-date).
							res7 = res7 + round((op-entry.amt-rub / kursUSD),2).
						end.
               					if can-do("!423*,!422*,!421*,42.06*,42.07*,42.08*,42.09*,42.10*,42.11*,42.12*,42.13*,42.14*,42.15*",loan-acct.acct) then do: /* долгосрочные */
			               			kursUSD = oSysClass:getCBRKurs(840,op-entry.op-date).
							res8 = res8 + round((op-entry.amt-rub / kursUSD),2).
						end.        
             				end. 
               			end.			
               		end.
              end.
              DELETE OBJECT oSysClass.
      end.
      if asLineCode eq "1П50.1" and i = 2 then
      gValue[i] = gValue[i] - round(res3 / 1000,3) + round(res5 / 1000,3).
      if asLineCode eq "1П50.2" and i = 2 then
      gValue[i] = gValue[i] - round(res4 / 1000,3) + round(res6 / 1000,3).
      if asLineCode eq "1П50.1" and i = 3 then
      gValue[i] = gValue[i] + round(res7 / 1000,3).
      if asLineCode eq "1П50.2" and i = 3 then
      gValue[i] = gValue[i] + round(res8 / 1000,3).
      if asLineCode eq "1П50.1" and i = 2 then
      gValue[i] = gValue[i] - round(res7 / 1000,3).
      if asLineCode eq "1П50.2" and i = 2 then
      gValue[i] = gValue[i] - round(res8 / 1000,3).
/* конец заявка 3282. */
      ASSIGN sResult = sResult + string(gValue[i], sFormats[i]) + sDelim.
   end.
END.

ASSIGN printtext = sResult.
ASSIGN xResult   = DEC(sResult) NO-ERROR.

&GLOB FILE_f401p_p YES
&ENDIF
/******************************************************************************/
