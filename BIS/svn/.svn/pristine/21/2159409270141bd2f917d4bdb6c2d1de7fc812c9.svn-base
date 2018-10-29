/*                          
               Банковская интегрированная система БИСквит
    Copyright: (C) MCMXCII-MCMXCIX ТОО "Банковские информационные системы"
     Filename: os-lib.p
      Comment: библиотека функций для шаблона ap-os4a (ОС-4а).
   Parameters: 
         Uses: globals.i intrface.get 
      Used by: ap-os1o.p ap-os2o.p ap-os4o.p 
      Created: 22/07/2003 AVAL
		02/11/11 версия ПИР банка - поправлена процедура ДопРекв чтобы она работала в ОС

   Список процедур и функций :

   ОбрезатьСдвинуть
   ДопРекв
   НастрПарам
   ДатаСост
   НомерДок
   ПодпРук
   ДолжРук
   КАУ
   ДатаСпис
   НомерИнв
   НомерЗав
   СтруктПодр
   СтруктПодрК
   ДатаВводаЭкспл
   ДатаВводаЭкспл2
   ГодВыпуска
   ДатаИзготов
   ФактСрокЭксплЛет
   ФактСрокЭкспл
   ДолжМол
   ФиоМол
   ТабНомер
   НаимМЦ
   АдресОрг
   НаимОрг
   ТелОрг
   БанкРеквОрг
   ОКПО
   ДатаПрин
   НомерПрин
   НачСтоим
   НачАморт
   ОстатСтоим
   НомерШасси
   НомерПаспорта
   НомерДвиг
   Масса
   Марка
   ЕдИзмер
   Грузоподъемность
   МассаЗолота
   МассаСеребра
   МассаПлатины
   МассаПрочее
   МассаМет
   Колич
   КоличБ
   СчетУчета
   СчетУчета2
   НачАмортНорма
   НачАмортНаим
   СрокПолезИсп
   МестоНахожд
   ОргИзг
   ОргПостав
   ЦенаМЦ
   Сумма
   СуммаПослПровСчУч
   СдатчСтруктПодр
   ПолучСтруктПодр
   ОКПОПолуч
   ОКПОСдатч
   СдатчТабНомер
   ПолучТабНомер
   ПолучФИО
   СдатчФИО
   СдатчДолж
   ПолучДолж
   Npp
   ДокНомI
   ДатаI
   Итого
   Объект
   ДляВыводаПров
   СуммПров
*/
{globals.i}
{intrface.get umc}
{intrface.get date}
{intrface.get xobj}
{intrface.get xclass}
{intrface.get strng}
{intrface.get db2l}
{tmprecid.def}

&SCOP MODUL ENTRY(1,kau-entry.kau)
&SCOP CARD  ENTRY(2,kau-entry.kau)
&SCOP MOL   ENTRY(3,kau-entry.kau)
&SCOP OTDL  ENTRY(4,kau-entry.kau)

DEF VAR mNpp      AS INT64   NO-UNDO.
DEF VAR mInRecId  AS RECID NO-UNDO.
DEF VAR mInRecIdL AS RECID NO-UNDO.

PUBLISH "GetHdlProc"(THIS-PROCEDURE).

/*---------------------------------------------------------------------------*/
PROCEDURE SetNpp:
   DEF INPUT PARAM iNpp AS INT64 NO-UNDO.
   mNpp = iNpp.
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE GetInRecId:
   DEF OUTPUT PARAM oRecId AS RECID NO-UNDO.
   oRecId = mInRecId.
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE SetInRecId:
   DEF INPUT PARAM iRecId AS RECID NO-UNDO.
   mInRecId = iRecId.
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE SetInRecIdL:
   DEF INPUT PARAM iRecId AS RECID NO-UNDO.
   mInRecIdL = iRecId.
   mInRecId  = ?.
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE ОбрезатьСдвинуть:
   DEF INPUT  PARAM iStr AS CHAR NO-UNDO.
   DEF INPUT  PARAM iLen AS CHAR NO-UNDO.
   DEF INPUT  PARAM iLRC AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oStr AS CHAR NO-UNDO.

   IF iLen  NE "" THEN
   DO:      
      IF iLRC EQ "Л" THEN 
         ASSIGN 
            oStr = iStr + FILL(" ",INT64(iLen))
            oStr = SUBSTRING(oStr,1,INT64(iLen))
         .
      ELSE IF iLRC EQ "П" THEN 
         ASSIGN 
            oStr = FILL(" ",INT64(iLen)) + iStr
            oStr = SUBSTRING(oStr,LENGTH(oStr) - INT64(iLen) + 1)
         .
   END.
   ELSE 
      oStr = iStr.
END PROCEDURE.
/*---------------------------------------------------------------------------
 версия ПИР, которая работает и с установленным mInRecIdL (идентификатором loan)  */
PROCEDURE ДопРекв:
   DEF INPUT  PARAM iFrm AS  CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS  CHAR NO-UNDO.

   DEF VAR          vType AS CHAR NO-UNDO. /* тип данных                      */
   DEF VAR          vFmt  AS CHAR NO-UNDO. /* расчитываемый формат            */
   DEF VAR          vFrm  AS CHAR NO-UNDO. /* формат указанный в шаблоне      */
   DEF VAR          vDec  AS DEC  NO-UNDO. /* DECIMAL(oRet)                   */
   DEF VAR          vDate AS DATE NO-UNDO. /* DATE(oRet)                      */
   DEF VAR          vLen  AS INT64  NO-UNDO. /* длина строки                    */
   vLen = 5.

   IF NUM-ENTRIES (iFrm, "@") EQ 2 THEN
      ASSIGN
         vFrm = GetEntries(2, iFrm, "@", "")
         iFrm = GetEntries(1, iFrm, "@", "")
      .
   DEFINE VARIABLE vDataType AS CHARACTER NO-UNDO.

   DEF BUFFER kau-entry  FOR kau-entry.
   DEF BUFFER xattr      FOR xattr.

   oRet = "".
   MAIN:
   DO ON ERROR   UNDO MAIN, LEAVE MAIN
      ON END-KEY UNDO MAIN, LEAVE MAIN
   :

      FIND FIRST kau-entry WHERE 
           RECID(kau-entry)   EQ mInRecId 
         NO-LOCK NO-ERROR.
      IF NOT AVAILABLE kau-entry THEN
      DO:
         FIND FIRST loan WHERE 
              RECID(loan)   EQ mInRecIdL
            NO-LOCK NO-ERROR.
         IF NOT AVAILABLE loan THEN
            LEAVE MAIN.
      END.
      oRet = GetXAttrValue("loan", 
                           (IF AVAILABLE kau-entry
                            THEN {&MODUL} + "," + {&CARD}
                            ELSE loan.contrac + "," + loan.cont-code),
                           iFrm
                          ).
         vType = GetXAttrEx     (loan.class-code,
                                 iFrm,
                                 "Data-Type"
                                ).

      FOR FIRST xattr
          WHERE xattr.class-code EQ loan.class-code
            AND xattr.xattr-code EQ iFrm
         NO-LOCK
      :
         vDataType = xattr.data-type.
      END.
  END. /* MAIN: */
/* MESSAGE
  "mInRecId = " mInRecId
  "mInRecIdL = " mInRecIdL
  avail kau-entry
  loan.contract + "," + loan.cont-code "|"
                                 iFrm
 "oRet = " oRet VIEW-AS ALERT-BOX.
*/
   IF oRet EQ ? THEN 
      oRet = "".

   /* формат в шаблоне не указан */
      IF      vFrm EQ ""
         AND (UPPER(vType) BEGINS "DEC" OR UPPER(vType) BEGINS "INT") THEN DO:
         vLen = IF LENGTH(oRet) GT 4
                THEN LENGTH(oRet)
                ELSE 5.
	END.
	ELSE vLen = LENGTH(oRet).

      IF    UPPER(vType) BEGINS "DEC"
         OR UPPER(vType) BEGINS "INT"
      THEN DO:
         vDec = DECIMAL(oRet) NO-ERROR.

         IF NOT ERROR-STATUS:ERROR
         THEN DO:
/* message "vType = " vType "vFmt = " vFmt "vFrm = " vFrm " vLen = " vLen view-as alert-box. */
            ASSIGN
               vFmt = IF vDec LT 0
                      THEN "-"
                      ELSE ""
/*               vFmt = vFmt + FILL(">", vLen - LENGTH(vFmt) - 4) + "9.99". */
                 vFmt = vFmt + ">>>>9.99".

            IF     UPPER(vType) BEGINS "I"
               AND vDec  EQ     ROUND(vDec, 0)
            THEN
               vFmt = REPLACE(vFmt, "9.99", ">>>9").

            IF     UPPER(vType)  BEGINS "D" OR UPPER(vType) BEGINS "I"
               AND vFrm   NE     "" THEN
               oRet = STRING(vDec, vFrm) NO-ERROR.
            ELSE
               oRet = STRING(vDec, vFmt) NO-ERROR.
         END.
      END.

      ELSE
      IF UPPER(vType) BEGINS "DATE"
      THEN DO:
         vDate = DATE(oRet) NO-ERROR.

         IF NOT ERROR-STATUS:ERROR
         THEN DO:
            oRet = STRING(vDate, vFrm) NO-ERROR.
         END.
      END.

      ELSE
      IF UPPER(vType) BEGINS "CHAR" THEN
         oRet = STRING(oRet, vFrm) NO-ERROR.
   /* END. */

END PROCEDURE.
/*---------------------------------------------------------------------------
 версия БИС, которая работает только с установленным mInRecId (идентификатором kau-entry)  */
PROCEDURE ДопРекв1:
   DEF INPUT  PARAM iFrm  AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet  AS CHAR NO-UNDO.
   DEF VAR          vType AS CHAR NO-UNDO. /* тип данных                      */
   DEF VAR          vFmt  AS CHAR NO-UNDO. /* расчитываемый формат            */
   DEF VAR          vFrm  AS CHAR NO-UNDO. /* формат указанный в шаблоне      */
   DEF VAR          vDec  AS DEC  NO-UNDO. /* DECIMAL(oRet)                   */
   DEF VAR          vDate AS DATE NO-UNDO. /* DATE(oRet)                      */
   DEF VAR          vLen  AS INT64  NO-UNDO. /* длина строки                    */

   IF NUM-ENTRIES (iFrm, "@") EQ 2 THEN
      ASSIGN
         vFrm = GetEntries(2, iFrm, "@", "")
         iFrm = GetEntries(1, iFrm, "@", "")
      .

   IF mInRecId NE ? THEN
   FOR
      FIRST kau-entry     WHERE
            RECID(kau-entry) EQ mInRecId
      NO-LOCK, 
      FIRST loan          WHERE
            loan.contract    EQ {&MODUL}
        AND loan.cont-code   EQ {&CARD}
      NO-LOCK,
      FIRST asset OF loan
      NO-LOCK:

      ASSIGN
         oRet = GetXAttrValueEx ("loan",
                                 loan.contract + ","
                               + loan.cont-code,
                                 iFrm,
                                 "?"
                                )
         vType = GetXAttrEx     (loan.class-code,
                                 iFrm,
                                 "Data-Type"
                                ).

      IF oRet EQ "?" THEN
         ASSIGN
            oRet  = GetXAttrValueEx("asset",
                                    GetSurrogateBuffer("asset",
                                                       (BUFFER asset:HANDLE)
                                                      ),
                                    iFrm,
                                    "?"
                                   )
            vType = GetXAttrEx     ("asset",
                                    iFrm,
                                    "Data-Type"
                                   ).

      IF oRet EQ "?" THEN
         oRet = "".

   /* формат в шаблоне не указан */
      IF      vFrm EQ ""
         AND (vType BEGINS "DEC" OR vType BEGINS "INT") THEN
         vLen = IF LENGTH(oRet) GT 4
                THEN LENGTH(oRet)
                ELSE 5.

      IF    vType BEGINS "DEC"
         OR vType BEGINS "INT"
      THEN DO:
         vDec = DECIMAL(oRet) NO-ERROR.

         IF NOT ERROR-STATUS:ERROR
         THEN DO:
            ASSIGN
               vFmt = IF vDec LT 0
                      THEN "-"
                      ELSE ""
/*               vFmt = vFmt + FILL(">", vLen - LENGTH(vFmt) - 4) + "9.99" */
               vFmt = vFmt + "9999999999.99"
            .

            IF     vType BEGINS "I"
               AND vDec  EQ     ROUND(vDec, 0)
            THEN
               vFmt = REPLACE(vFmt, "9.99", ">>>9").

            IF     vType  BEGINS "D"
               AND vFrm   NE     "" THEN
               oRet = STRING(vDec, vFrm) NO-ERROR.
            ELSE
               oRet = STRING(vDec, vFmt) NO-ERROR.
         END.
      END.

      ELSE
      IF vType BEGINS "DATE"
      THEN DO:
         vDate = DATE(oRet) NO-ERROR.

         IF NOT ERROR-STATUS:ERROR
         THEN DO:
            oRet = STRING(vDate, vFrm) NO-ERROR.
         END.
      END.

      ELSE
      IF vType BEGINS "CHAR" THEN
         oRet = STRING(oRet, vFrm) NO-ERROR.
   END.
END PROCEDURE.

/*---------------------------------------------------------------------------*/
PROCEDURE НастрПарам:
   DEF INPUT  PARAM iCode    AS CHAR NO-UNDO.
   DEF INPUT  PARAM iSubCode AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet     AS CHAR NO-UNDO.

   oRet = FGetSetting( iCode,
                       iSubCode,
                       ""
                     ).

END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE ДатаДок:
   DEF INPUT  PARAM iFrm  AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet  AS CHAR NO-UNDO.
   
   DEF BUFFER op        FOR op.
   DEF BUFFER kau-entry FOR kau-entry.

   oRet = "".
   IF mInRecId NE ? THEN
   FOR FIRST kau-entry WHERE 
             RECID(kau-entry) EQ mInRecId 
             NO-LOCK,
       FIRST op OF kau-entry 
             NO-LOCK
       :
       oRet = STRING(op.doc-date).
   END.
   IF mInRecId NE ? AND
      iFrm NE "" THEN
      oRet = STRING(date(oRet),iFrm).
END PROCEDURE.

PROCEDURE ДатаВыб:
   DEF INPUT  PARAM iFrm  AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet  AS CHAR NO-UNDO.
   
   DEF VAR vTmpDate AS DATE NO-UNDO.
   DEF VAR vTmpSum  AS DEC  NO-UNDO.

   DEF BUFFER op        FOR op.
   DEF BUFFER loan      FOR loan.
   DEF BUFFER kau-entry FOR kau-entry.

   oRet = "".
   IF mInRecId NE ? THEN
   FOR FIRST kau-entry WHERE 
             RECID(kau-entry) EQ mInRecId 
             NO-LOCK,
       FIRST loan WHERE loan.contract  EQ {&MODUL} AND
                        loan.cont-code EQ {&CARD}
             NO-LOCK
       :
       RUN GetLoanDate IN h_umc ({&MODUL},
                                 {&CARD},
                                 "-учет",
                                 "Out",
                                 OUTPUT vTmpDate,
                                 OUTPUT vTmpSum
                                ).
       oRet = STRING(vTmpDate,"99.99.9999").
       IF oRet = "01.01.0001" THEN
          oRet = STRING(loan.close-date, "99.99.9999").
   END.
   IF oRet EQ ? THEN
      oRet = "".
   IF mInRecId NE ? AND
      iFrm NE "" AND
      oRet NE "" THEN
      oRet = STRING(date(oRet),iFrm).
END PROCEDURE.

/*---------------------------------------------------------------------------*/
PROCEDURE IДок:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.
   oRet = GetSysConf ("in-dt:doc-num").
   IF iFrm NE "" THEN
      oRet = STRING(oRet,iFrm).

END PROCEDURE.

/*---------------------------------------------------------------------------*/
PROCEDURE IДата:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.
   oRet = GetSysConf ("in-dt:op-date").
   IF iFrm NE "" THEN
      oRet = STRING(DATE(oRet),iFrm).
END PROCEDURE.

/*---------------------------------------------------------------------------*/

PROCEDURE IПодр:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.
   oRet =  GetObjName("branch", GetSysConf ("in-dt:branch"), yes).
   IF iFrm NE "" THEN
      oRet = STRING(oRet,iFrm).
END PROCEDURE.

/*---------------------------------------------------------------------------*/
PROCEDURE IМол:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.
   oRet =  GetSysConf ("in-dt:mol").
   IF iFrm NE "" THEN
      oRet = STRING(INT64(oRet),iFrm).
END PROCEDURE.

/*---------------------------------------------------------------------------*/
PROCEDURE IФИО:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.
   oRet =  GetObjName("employee", shFilial + "," + GetSysConf ("in-dt:mol"), NO).
   IF iFrm NE "" THEN
      oRet = STRING(oRet,iFrm).
END PROCEDURE.

/*---------------------------------------------------------------------------*/
PROCEDURE IМЕСТО:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.

   oRet = GetSysConf ("in-dt:place").

   IF iFrm NE "" THEN
      oRet = STRING(oRet,iFrm).

END PROCEDURE.

/*---------------------------------------------------------------------------*/
PROCEDURE Объект:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.

   CASE work-module:
      WHEN "ОС" THEN
         oRet = "Объект основных средств".
      WHEN "МБП" THEN 
         oRet = "Объект материальных запасов".
      WHEN "НМА" THEN 
         oRet = "Объект нематериальных активов".
      WHEN "СКЛАД" THEN
         oRet = "Объект складского учета".
   END CASE.
   IF iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE НомерДок:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.

   DEF BUFFER op        FOR op.
   DEF BUFFER kau-entry FOR kau-entry.
   
   oRet = "".
   FOR FIRST kau-entry WHERE 
             RECID(kau-entry) EQ mInRecId 
             NO-LOCK,
       FIRST op OF kau-entry
             NO-LOCK
       :
       oRet = op.doc-num.
   END.
   IF iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
FUNCTION _Должн&ПодпРук RETURNS CHAR (iDbCr AS LOGICAL,iTitName AS CHAR):
   DEF BUFFER branch     FOR branch.
   DEF BUFFER kau-entry  FOR kau-entry.
   DEF BUFFER xkau-entry FOR kau-entry.
   DEF BUFFER op         FOR op.
   DEF BUFFER loan-acct  FOR loan-acct.

   FOR 
      FIRST kau-entry  WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK ,
      LAST  loan-acct WHERE 
            loan-acct.contract  = {&MODUL}
        AND loan-acct.cont-code = {&CARD}
        AND loan-acct.acct-type = {&MODUL} + "-учет" 
        AND loan-acct.since    <= kau-entry.op-date 
            NO-LOCK,

      FIRST op OF kau-entry NO-LOCK,
      FIRST xkau-entry  OF op WHERE 
            xkau-entry.acct  EQ loan-acct.acct AND
            xkau-entry.curr  EQ loan-acct.curr AND
            xkau-entry.debit EQ iDbCr          AND
            xkau-entry.kau   BEGINS {&MODUL} + "," + {&CARD} + ","
            NO-LOCK
      :
      CASE iTitName:
         WHEN "Должность" OR WHEN "Подпись" THEN
            FIND FIRST branch WHERE 
                       branch.branch-id EQ {&OTDL}
               NO-LOCK NO-ERROR.
         WHEN "НаимОрг" OR WHEN "АдресОрг" THEN
             FOR FIRST 
                  {cont2ora.i
                     &iWordFld   = "parent-id"
                     &iElement   = "'TOP'"
                     &iTable     = "branch"
                     &iTableName = "branch"
                     &iIndex     = "branch-id"
                     &iDELIM     = ";"
                  } 
            NO-LOCK:
               LEAVE.
            END.
      END CASE.

      IF AVAIL branch THEN
         RETURN (     IF iTitName EQ "Должность" THEN branch.mgr-title
                 ELSE IF iTitName EQ "Подпись"   THEN branch.mgr-name
                 ELSE IF iTitName EQ "АдресОрг"  THEN branch.address
                 ELSE IF iTitName EQ "НаимОрг"   THEN branch.name
                 ELSE ""
                ).

   END.
   RETURN "".

END FUNCTION.
/*---------------------------------------------------------------------------*/
PROCEDURE ПодпРук:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.

   DEF BUFFER branch    FOR branch.
   DEF BUFFER kau-entry FOR kau-entry.

   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK ,

      FIRST branch WHERE 
            branch.branch-id EQ {&OTDL} 
            NO-LOCK
      :

      oRet = branch.mgr-name.

   END.
   IF iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).

END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE ПодпРукСд:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.
   
   oRet = _Должн&ПодпРук(NO,"Подпись").
   IF iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).

END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE ПодпРукПол:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.
   
   oRet = _Должн&ПодпРук(YES,"Подпись").
   IF iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).

END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE ДолжРук:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.
   
   DEF BUFFER branch    FOR branch.
   DEF BUFFER kau-entry FOR kau-entry.

   FOR 
      FIRST kau-entry  WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK ,
      
      FIRST branch WHERE 
            branch.branch-id EQ {&OTDL} 
            NO-LOCK
      :

      oRet = branch.mgr-title.

   END.
   IF iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).

END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE ДолжРукСд:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.
   
   oRet = _Должн&ПодпРук(NO,"Должность").
   IF iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).

END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE ДолжРукПол:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.
   
   oRet = _Должн&ПодпРук(YES,"Должность").
   IF iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).

END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE КАУ:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.
   
   DEF BUFFER kau-entry  FOR kau-entry.

   oRet = "".
   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
      NO-LOCK 
      :
      
      oRet = kau-entry.kau.
   END.
   IF iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE НомерИнв:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.

   DEF BUFFER kau-entry FOR kau-entry.
   DEF BUFFER loan FOR loan.
   
   oRet = "".
   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
      NO-LOCK
      :
      
      oRet = DelFilFromLoan({&CARD}).
   END.
   IF iFrm NE "" THEN 
      oRet = STRING(INT64(oRet),iFrm).
END PROCEDURE.

PROCEDURE НомерИнвППер:
   DEF INPUT  PARAM iFrm AS  CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS  CHAR NO-UNDO.

   DEF BUFFER       op          FOR op.
   DEF BUFFER       kau-entry   FOR kau-entry.
   DEF VAR          vOp         AS  INT64 NO-UNDO.
   DEF VAR          vItogo      AS  CHAR NO-UNDO.

   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK 
      :
      vOp = kau-entry.op.
   END.   
      
   vItogo = "".
   FOR 
      FIRST op WHERE 
            op.op EQ vOp 
            NO-LOCK ,
      
      EACH  kau-entry OF op WHERE 
            kau-entry.debit EQ yes AND
            kau-entry.kau-id BEGINS "УМЦ-учет"
            NO-LOCK,
      FIRST loan WHERE loan.contract  EQ entry(1,kau-entry.kau) AND
                       loan.cont-code EQ entry(2,kau-entry.kau) NO-LOCK
      : 
      {additem.i vItogo "loan.doc-ref"}
   END.

   oRet = vItogo.
   IF iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).

END PROCEDURE.

/*---------------------------------------------------------------------------*/
PROCEDURE НомерЗав:
   DEF INPUT  PARAM iFrm       AS  CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet       AS  CHAR NO-UNDO.

   DEF BUFFER       kau-entry  FOR kau-entry.
   DEF BUFFER       loan       FOR loan.
   
   oRet = "".
   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK:
    
      FIND FIRST loan WHERE 
                 loan.contract  EQ {&MODUL}
             AND loan.cont-code EQ {&CARD}
         NO-LOCK NO-ERROR.

      oRet = GetXattrValueEx("loan", 
                             {&MODUL} + "," + {&CARD}, 
                             "НомерЗавод",
                             ""
                            ).
   END.
   IF iFrm NE "" THEN 
      oRet = STRING(INT64(oRet),iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE НомерРег:
   DEF INPUT  PARAM iFrm       AS  CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet       AS  CHAR NO-UNDO.

   DEF BUFFER       kau-entry  FOR kau-entry.
   
   oRet = "".
   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK 
      :
      
      oRet = GetXAttrValue ("loan", 
                            {&MODUL} + "," + {&CARD}, 
                            "НомернойЗнак"
                           ).
   END.
   IF iFrm NE "" THEN 
      oRet = STRING(INT64(oRet),iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE СтруктПодр:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.

   oRet = "".
   RUN НастрПарам ( "КодФил", 
                    "", 
                    OUTPUT oRet
                  ).
   oRet = GetObjName( "branch",
                      oRet,
                      YES
                    ).
   IF iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
/* СтруктПодрК берёт код подразделения из субаналитики по счету учета 
   инвентарной карточки и выдаёт наименование подразделения */
PROCEDURE СтруктПодрК:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.

   DEF BUFFER   kau-entry FOR     kau-entry.
   DEF VAR      mOpDate   AS DATE NO-UNDO. /* Для хранения kau-entry.op-date */

      FIND FIRST kau-entry WHERE 
                 RECID(kau-entry) EQ mInRecId 
                 NO-LOCK 
                 NO-ERROR. 
      
      mOpDate = kau-entry.op-date NO-ERROR.

      IF {&OTDL} NE "" THEN
          oRet = GetObjName( "branch",
                             {&OTDL},
                             YES
                           ).
      ELSE 
          FOR
            LAST  loan-acct WHERE
                  loan-acct.contract  EQ {&MODUL} 
              AND loan-acct.cont-code EQ {&CARD}
              AND loan-acct.acct-type EQ {&MODUL} + "-" + "учет"
              AND loan-acct.since     <= mOpDate
                  NO-LOCK,
            FIRST acct WHERE 
                  acct.acct           EQ loan-acct.acct
              AND acct.currency       EQ loan-acct.currency
                  NO-LOCK,
            FIRST kau-entry WHERE
                  kau-entry.acct      EQ     loan-acct.acct
              AND kau-entry.currency  EQ     loan-acct.currency
              AND kau-entry.kau       BEGINS ({&MODUL} + "," + {&CARD} + ",")
              AND kau-entry.debit     EQ     (acct.side EQ "А") 
                  NO-LOCK
          :  
            oRet = GetObjName( "branch",
                               ENTRY(4, kau-entry.kau, ","),
                               YES
                             ).
          END.

   IF iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).

END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE ДатаВводаЭкспл:
   DEF INPUT  PARAM iFrm      AS  CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet      AS  CHAR NO-UNDO.

   DEF BUFFER       kau-entry FOR kau-entry.
   DEF VAR          vDate     AS  DATE NO-UNDO.

   oRet = "".
   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK
      :
      
      ASSIGN 
         vDate = GetInDate (  {&MODUL}, 
                              {&CARD},
                              "Б" 
                           )
         oRet = STRING(MONTH(vDate)) + "," + STRING(YEAR(vDate))
      .
   
   END.
   IF oRet EQ ? THEN 
      oRet = "".
   IF iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE ДатаВводаЭкспл2:
   DEF INPUT  PARAM iFrm      AS  CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet      AS  CHAR NO-UNDO.

   DEF BUFFER       kau-entry FOR kau-entry.

   oRet = "".
   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK
      :
      IF GetSysConf("ap-os1a") EQ "Выбытие" OR
         GetSysConf("ap-os1a") EQ "" THEN
         oRet  = STRING(GetInDate (  {&MODUL}, 
                                     {&CARD},
                                     "Б" 
                                  )
                       ).
   END.
   IF oRet EQ ? THEN 
      oRet = "".
   IF     oRet NE ""
      AND iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE ГодВыпуска:
   DEFINE  INPUT PARAMETER iFrm AS CHARACTER NO-UNDO.
   DEFINE OUTPUT PARAMETER oRet AS CHARACTER NO-UNDO.

   DEFINE VARIABLE vDataType AS CHARACTER NO-UNDO.

   DEFINE BUFFER kau-entry FOR kau-entry.
   DEFINE BUFFER xattr     FOR xattr.

   oRet = "".
   MAIN:
   DO ON ERROR   UNDO MAIN, LEAVE MAIN
      ON END-KEY UNDO MAIN, LEAVE MAIN
   :
      FIND FIRST kau-entry WHERE 
           RECID(kau-entry)   EQ mInRecId 
         NO-LOCK NO-ERROR.
      IF NOT AVAILABLE kau-entry THEN
      DO:
         FIND FIRST loan WHERE 
              RECID(loan)   EQ mInRecIdL
            NO-LOCK NO-ERROR.
         IF NOT AVAILABLE loan THEN
            LEAVE MAIN.
      END.
      oRet = GetXAttrValue("loan", 
                           (IF AVAILABLE kau-entry
                            THEN {&MODUL} + "," + {&CARD}
                            ELSE loan.contrac + "," + loan.cont-code),
                           "ДатаИзготов"
                          ).
      FOR FIRST xattr
          WHERE xattr.class-code EQ "ОС"
            AND xattr.xattr-code EQ "ДатаИзготов"
         NO-LOCK
      :
         vDataType = xattr.data-type.
      END.
      IF vDataType EQ "date" THEN
         oRet = STRING(YEAR(DATE(oRet))) NO-ERROR.
      ELSE
         oRet = STRING(INT64(oRet)) NO-ERROR.
      IF oRet EQ ? THEN 
         oRet = "".
      IF iFrm NE "" THEN 
         oRet = STRING(INT64(oRet), iFrm).
      IF INT64(oRet) EQ 0 THEN 
         oRet = FILL(" ", LENGTH(oRet)).
   END.
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE ДатаИзготов:
   DEF INPUT  PARAM iFrm AS  CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS  CHAR NO-UNDO.

   DEFINE VARIABLE vDataType AS CHARACTER NO-UNDO.

   DEF BUFFER kau-entry  FOR kau-entry.
   DEF BUFFER xattr      FOR xattr.

   oRet = "".
   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK
      :
      
      oRet = GetXAttrValue ("loan", 
                            {&MODUL} + "," + {&CARD},
                            "ДатаИзготов"
                           ).
      FOR FIRST xattr
          WHERE xattr.class-code EQ "ОС"
            AND xattr.xattr-code EQ "ДатаИзготов"
         NO-LOCK
      :
         vDataType = xattr.data-type.
      END.
   END.
   IF oRet EQ ? THEN 
      oRet = "".
   IF     oRet NE "" 
      AND iFrm NE "" THEN
   DO:
      IF vDataType EQ "date" THEN
         oRet = STRING(DATE(oRet), iFrm) NO-ERROR.
      ELSE
         oRet = STRING(INT64(oRet), iFrm) NO-ERROR.
   END.
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE ФактСрокЭкспл:
   DEF INPUT  PARAM iFrm AS  CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS  CHAR NO-UNDO.

   DEF BUFFER op         FOR op.
   DEF BUFFER kau-entry  FOR kau-entry.
   DEF VAR    vDD        AS  DATE NO-UNDO. /* дата документа             */
   DEF VAR    vDP        AS  DATE NO-UNDO. /* дата принятия на учет      */
   DEF VAR    vSE        AS  INT64  NO-UNDO. /* срок эксплуатации (до нас) */
   DEF VAR    vCD        AS  INT64  NO-UNDO. /* количество дней            */

   oRet = "".
   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK ,

      FIRST op OF kau-entry
            NO-LOCK 
      :
      
      RUN ДатаВводаЭкспл2 ( "",
                            OUTPUT oRet
                          ).

      ASSIGN
         vDP  = DATE(oRet)      
         oRet = GetXAttrValue ("loan", 
                               {&MODUL} + "," + {&CARD}, 
                               "СрокЭкспл"
                              )
         vSE  = INT64(oRet)
         vDD  = op.op-date
      .
   END.

   ASSIGN
   vCD = vSE + IF    vDP EQ 01/01/0001 
                  OR vDP EQ 01/01/9999 THEN 
                  0 
               ELSE 
                  INT64(MonInPer(vDP,vDD))
   oRet = STRING(vCD)
   .

   IF oRet EQ ? THEN 
      oRet = "".
   IF     oRet NE "" 
      AND iFrm NE "" THEN 
      oRet = STRING(INT64(oRet),iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE ДолжМол:
   DEF INPUT  PARAM iFrm      AS  CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet      AS  CHAR NO-UNDO.

   DEF BUFFER       kau-entry FOR kau-entry.

   oRet = "".
   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
      NO-LOCK:

      oRet = GetXAttrValue ("employee",
                            shFilial + "," + {&MOL},
                            "role"
                           ).

   END.

   IF iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE ФиоМол:
   DEF INPUT  PARAM iFrm      AS  CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet      AS  CHAR NO-UNDO.

   DEF BUFFER       kau-entry FOR kau-entry.

   oRet = "".
   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK 
      :

      oRet = GetObjName( "employee",
                         shFilial + "," + {&MOL},
                         YES
                       ).
   END.

   IF iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE ТабНомер:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.

   DEF BUFFER       kau-entry FOR kau-entry.

   oRet = "".
   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK 
      :

      oRet = {&MOL}.
   
   END.

   IF iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE НаимМЦ:    
   DEF INPUT  PARAM iFrm      AS  CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet      AS  CHAR NO-UNDO.

   DEF BUFFER       kau-entry FOR kau-entry.
   DEF BUFFER       loan      FOR loan.
   DEF BUFFER       asset     FOR asset.

   oRet = "".
   IF mInRecId EQ ? THEN
   FOR 
      FIRST loan WHERE 
            RECID(loan) EQ mInRecIdL
            NO-LOCK ,
      FIRST asset OF loan
            NO-LOCK 
      :

      oRet = asset.name.
   
   END.

   ELSE
   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId
            NO-LOCK ,
      
      FIRST loan WHERE 
            loan.contract  EQ {&MODUL}
        AND loan.cont-code EQ {&CARD}
            NO-LOCK ,
      
      FIRST asset OF loan
            NO-LOCK 
      :

      oRet = asset.name.
   
   END.

   IF iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE НомерЗавод:    
   DEF INPUT  PARAM iFrm      AS  CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet      AS  CHAR NO-UNDO.

   DEF BUFFER       kau-entry FOR kau-entry.
   DEF BUFFER       loan      FOR loan.
   DEF BUFFER       asset     FOR asset.

   oRet = "".
   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK ,
      
      FIRST loan WHERE 
            loan.contract  EQ {&MODUL}
        AND loan.cont-code EQ {&CARD}
            NO-LOCK ,
      
      FIRST asset OF loan
            NO-LOCK 
      :

      oRet = GetXattrValueEx("loan", 
                              loan.contract + "," + loan.cont-code,
                              "НомерЗавод",
                              asset.cont-type).
   END.

   IF iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE НаимОрг:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.

   DEF BUFFER       branch    FOR branch.

   oRet = "".
   FOR FIRST 
        {cont2ora.i
           &iWordFld   = "parent-id"
           &iElement   = "'TOP'"
           &iTable     = "branch"
           &iTableName = "branch"
           &iIndex     = "branch-id"
           &iDELIM     = ";"
        } 
   NO-LOCK:
      oRet = branch.name.
   END.

   IF iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE НаимОргПол:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.

   oRet = _Должн&ПодпРук(YES,"НаимОрг").

   IF iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE НаимОргСд:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.

   oRet = _Должн&ПодпРук(NO,"НаимОрг").

   IF iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE АдресОрг:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.

   DEF BUFFER       branch    FOR branch.

   oRet = "".
   FOR FIRST 
        {cont2ora.i
           &iWordFld   = "parent-id"
           &iElement   = "'TOP'"
           &iTable     = "branch"
           &iTableName = "branch"
           &iIndex     = "branch-id"
           &iDELIM     = ";"
        } 
   NO-LOCK:
      oRet = branch.address.
   END.

   IF iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE АдресОргПол:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.

   oRet = _Должн&ПодпРук(YES,"АдресОрг").

   IF iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE АдресОргСд:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.

   oRet = _Должн&ПодпРук(NO,"АдресОрг").

   IF iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE ТелОрг:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.

   DEF BUFFER       branch    FOR branch.

   DEF VAR  vFax AS CHAR NO-UNDO.

   oRet = "".
   FOR FIRST 
        {cont2ora.i
           &iWordFld   = "parent-id"
           &iElement   = "'TOP'"
           &iTable     = "branch"
           &iTableName = "branch"
           &iIndex     = "branch-id"
           &iDELIM     = ";"
        } 
   NO-LOCK:
      ASSIGN
         oRet = GetXAttrValue ("branch",
                               branch.branch-id,
                               "Телефон"
                              )
         vFax = GetXAttrValue ("branch",
                               branch.branch-id,
                               "Факс"
                              )
      .

      {additem2.i oRet vFax ", "}
      ASSIGN oRet = TRIM(oRet)
             oRet = TRIM(oRet,",")
      .
   END.
   
   IF iFrm NE "" THEN
      oRet = STRING(oRet,iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE БанкРеквОрг:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.

   DEF BUFFER       branch    FOR branch.

   DEF VAR  vCorrAc AS CHAR NO-UNDO.

   oRet = "".
   FOR FIRST 
        {cont2ora.i
           &iWordFld   = "parent-id"
           &iElement   = "'TOP'"
           &iTable     = "branch"
           &iTableName = "branch"
           &iIndex     = "branch-id"
           &iDELIM     = ";"
        } 
   NO-LOCK:

      ASSIGN
         oRet    = GetXAttrValue ("branch",
                                  branch.branch-id,
                                  "БанкМФО"
                                 )
         vCorrAc = GetXAttrValue ("branch",
                                  branch.branch-id,
                                  "КорСч"
                                 )
      .

      {additem2.i oRet vCorrAc ", "}
      ASSIGN oRet = TRIM(oRet)
             oRet = TRIM(oRet,",")
      .

   END.
   
   IF iFrm NE "" THEN
      oRet = STRING(oRet,iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE ОКПО:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.

   DEF BUFFER       branch    FOR branch.

   FOR FIRST 
            {cont2ora.i
               &iWordFld   = "parent-id"
               &iElement   = "'TOP'"
               &iTable     = "branch"
               &iTableName = "branch"
               &iIndex     = "branch-id"
               &iDELIM     = ";"
            } 
   NO-LOCK:
      oRet = GetXAttrValue ( "branch",
                             branch.branch-id,
                             "ОКПО"
                           ).
   END.
   
   IF iFrm NE "" THEN 
      oRet = STRING(INT64(oRet),iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE ОКПОСтрукПодр:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.

   DEF BUFFER       branch    FOR branch.

   RUN НастрПарам ( "КодФил", 
                    "", 
                    OUTPUT oRet
                  ).
   FOR 
      FIRST branch WHERE 
            branch.branch-id EQ oRet
            NO-LOCK:
      oRet = GetXAttrValue ("branch",
                            branch.branch-id,
                            "ОКПО"
                           ).
   END.
   
   IF iFrm NE "" THEN 
      oRet = STRING(INT64(oRet),iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE ДатаПрин:
   DEF INPUT  PARAM iFrm      AS  CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet      AS  CHAR NO-UNDO.

   DEF BUFFER       kau-entry FOR kau-entry.
   DEF VAR          vDate     AS  DATE NO-UNDO.
   DEF VAR          vTmpSum   AS  DEC NO-UNDO.

   oRet = "".
   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK 
      :
      /* Первая дебетовая проводка на счет капиталовложений */
      RUN GetLoanDate IN h_umc ( {&MODUL}, 
                                 {&CARD}, 
                                 "-учет", 
                                 "In",
                                 OUTPUT vDate,
                                 OUTPUT vTmpSum
                               ).
      oRet = IF    vDate EQ 01/01/9999 
                OR vDate EQ 01/01/0001 THEN 
                ""
             ELSE 
                STRING(vDate)
      .
   END.

   IF oRet EQ ? THEN 
      oRet = "".
   IF     oRet NE "" 
      AND iFrm NE "" THEN 
      oRet = STRING(DATE(oRet),iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE НомерПрин:
   DEF INPUT  PARAM iFrm      AS  CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet      AS  CHAR NO-UNDO.

   DEF BUFFER       kau-entry  FOR kau-entry.
   DEF BUFFER       xkau-entry FOR kau-entry.

   DEF VAR          vDate     AS  DATE NO-UNDO.
   DEF VAR          vTmpSum   AS  DEC  NO-UNDO.

   oRet = "".
   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK 
      :
      /* Первая дебетовая проводка на счет капиталовложений */
       
      RUN GetLoanDate IN h_umc ( {&MODUL}, 
                                 {&CARD}, 
                                 "-учет", 
                                 "In",
                                 OUTPUT vDate,
                                 OUTPUT vTmpSum
                               ).
      FIND FIRST xkau-entry WHERE
                 xkau-entry.op-date  = vDate
             AND xkau-entry.kau BEGINS {&MODUL} + "," + {&CARD}
             AND xkau-entry.debit    = YES
             AND xkau-entry.kau-id   = "УМЦ-учет"
         NO-LOCK NO-ERROR.

      IF AVAILABLE kau-entry THEN
      DO:
         FIND FIRST op OF kau-entry NO-LOCK NO-ERROR.
         IF AVAILABLE op THEN
            oRet = op.doc-num.
      END.
   END.

   IF     oRet NE "" 
      AND iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE НачСтоим:
   DEF INPUT  PARAM iFrm      AS  CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet      AS  CHAR NO-UNDO.

   DEF BUFFER       kau-entry FOR kau-entry.
   DEF VAR          vDate     AS  DATE NO-UNDO.
   DEF VAR          vTmpSum   AS  DEC  NO-UNDO.

   oRet = "".
   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK ,
      FIRST op OF kau-entry
            NO-LOCK
      :
      
      RUN GetLoanDate IN h_umc ( {&MODUL},
                                 {&CARD},
                                 "-учет",
                                 "In",
                                 OUTPUT vDate,
                                 OUTPUT vTmpSum
                               ).
      oRet = STRING( GetLoan-Pos ( {&MODUL},
                                   {&CARD},
                                   "учет",
                                   vDate
                                 )
                   )
      .
   END.

   IF oRet EQ ? THEN 
      oRet = "".
   IF iFrm NE "" THEN 
      oRet = STRING(DEC(oRet),iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE НачАморт:
   DEF INPUT  PARAM iFrm      AS  CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet      AS  CHAR NO-UNDO.

   DEF VAR          vSum      AS  DEC   NO-UNDO.
   DEF VAR          vCont     AS  CHAR  NO-UNDO.
   DEF VAR          vContCode AS  CHAR  NO-UNDO.
   DEF VAR          vOp       AS  INT64   NO-UNDO.

   DEF BUFFER       op        FOR op.
   DEF BUFFER       xop       FOR op.
   DEF BUFFER       kau-entry FOR kau-entry.
   DEF BUFFER       loan-acct FOR loan-acct.

   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK
      :
      ASSIGN
      vCont     = {&MODUL}
      vContCode = {&CARD}
      vOp       = kau-entry.op
      .
   END.   
      
   FIND FIRST xop WHERE xop.op EQ vOp NO-LOCK NO-ERROR.

   
   vSum = 0.
   IF AVAIL xop THEN
   FOR 
      EACH  op WHERE 
            op.op-trans EQ xop.op-trans
            NO-LOCK , 

      LAST  loan-acct WHERE 
            loan-acct.contract  = vCont     
        AND loan-acct.cont-code = vContCode
        AND loan-acct.acct-type = vCont + "-амор" 
        AND loan-acct.since    <= op.op-date 
            NO-LOCK,

       EACH kau-entry OF op WHERE 
            kau-entry.acct     EQ loan-acct.acct 
        AND kau-entry.currency EQ loan-acct.currency 
            NO-LOCK
      :

      vSum = vSum + (IF kau-entry.debit THEN 
                        kau-entry.amt-rub 
                     ELSE 
                        (- kau-entry.amt-rub)
                    ).
   END.

   oRet = STRING(vSum).
   IF GetSysConf("ap-os1a") EQ "Ввод" THEN
      oRet = "".

   IF oRet EQ ? THEN 
      oRet = "".
   IF iFrm NE "" THEN 
      oRet = STRING(DEC(oRet),iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE ОстатСтоим:
   DEF INPUT  PARAM iFrm      AS  CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet      AS  CHAR NO-UNDO.

   DEF VAR          vRes      AS  DEC  EXTENT 4 NO-UNDO.
   DEF VAR vTmp AS  CHAR NO-UNDO.

   oRet = "".
   vTmp = GetSysConf("ap-os1a").
   RUN SetSysConf IN h_base ("ap-os1a", "").
   RUN СуммаПров ( "",
                   OUTPUT oRet
                 ).
   vRes[1] = DEC(oRet).

   RUN НачАморт ( "",
                  OUTPUT oRet
                ).
   RUN SetSysConf IN h_base ("ap-os1a", vTmp).
   vRes[2] = DEC(oRet).

   oRet = STRING(vRes[1] - vRes[2]).

   
   
   
   IF GetSysConf("ap-os1a") EQ "Ввод" THEN
      oRet = "".

   IF oRet EQ ? THEN 
      oRet = "".
   IF iFrm NE "" AND
      GetSysConf("ap-os1a") NE "Ввод" THEN 
      oRet = STRING(DEC(oRet),iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE ВосстСтоим:
   DEF INPUT  PARAM iFrm      AS  CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet      AS  CHAR NO-UNDO.

   DEF VAR          vRes      AS  DEC  EXTENT 4 NO-UNDO.
   DEF VAR          mRecId    AS  CHAR          NO-UNDO INITIAL "". /*RecId документа*/
   DEF VAR          vDate     AS  DATE          NO-UNDO.

   vDate = DATE(GetSysConf("ap-os15:op-date")) NO-ERROR.

   IF NUM-ENTRIES(pick-value) > 1 THEN
   DO:
        mRecId = ENTRY(2,pick-value,",").
        pick-value = ENTRY(1,pick-value,",").

   END.

   IF mRecId NE "" THEN
       IF gend-date NE ? THEN
            vDate = DATE(INT64(gend-date) + 1) NO-ERROR.
       ELSE
       DO:
            FIND FIRST op WHERE RECID(op) EQ INT64(mRecId)
                          NO-LOCK
                          NO-ERROR.
            IF AVAILABLE op THEN
                vDate = op.op-date + 1.
            ELSE
                vDate = TODAY + 1.
        .
       END.
       IF vDate EQ ? THEN
          vDate = TODAY.

   IF mInRecId NE ? THEN
   FOR FIRST kau-entry WHERE 
             RECID(kau-entry) EQ mInRecId 
             NO-LOCK
       :
   
      oRet = STRING(GetLoan-Pos ({&MODUL},
                                 {&CARD},
                                 "учет",
                                 vDate
                                )
                   ).
   END.
   ELSE IF AVAILABLE op THEN
   FOR LAST kau-entry
         OF op
   NO-LOCK
   :
      oRet = STRING(GetLoan-Pos({&MODUL},
                                {&CARD},
                                "учет",
                                vDate)).
   END.

   IF (NUM-ENTRIES(pick-value) EQ 1) AND (mRecId NE "") THEN
        pick-value = pick-value + "," + mRecId.

   IF iFrm NE "" THEN 
      oRet = STRING(DEC(oRet),iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE НомерШасси:
   DEF INPUT  PARAM iFrm      AS  CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet      AS  CHAR NO-UNDO.

   DEF BUFFER       kau-entry FOR kau-entry.
   
   oRet = "".
   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK:
      oRet = GetXAttrValue ("loan",
                            {&MODUL} + "," + {&CARD},
                            "НомерШасси"
                           ).
   END.

   IF iFrm NE "" THEN 
      oRet = STRING(INT64(oRet),iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE НомерПаспорта:
   DEF INPUT  PARAM iFrm      AS  CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet      AS  CHAR NO-UNDO.

   DEF BUFFER       kau-entry FOR kau-entry.
   
   oRet = "".
   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK:
      oRet = GetXAttrValue ("loan",
                            {&MODUL} + "," + {&CARD},
                            "НомерПаспорта"
                           ).
   END.

   IF iFrm NE "" THEN 
      oRet = STRING(INT64(oRet),iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE НомерДвиг:
   DEF INPUT  PARAM iFrm      AS  CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet      AS  CHAR NO-UNDO.

   DEF BUFFER       kau-entry FOR kau-entry.
   
   oRet = "".
   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK:
      oRet = GetXAttrValue ("loan",
                            {&MODUL} + "," + {&CARD},
                            "НомерДвиг"
                           ).   
   END.

   IF iFrm NE "" THEN 
      oRet = STRING(INT64(oRet),iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE Масса:
   DEF INPUT  PARAM iFrm      AS  CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet      AS  CHAR NO-UNDO.

   DEF BUFFER       kau-entry FOR kau-entry.
   
   oRet = "".
   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK:
      oRet = GetXAttrValue ("loan",
                            {&MODUL} + "," + {&CARD},
                            "Масса"
                           ).
   END.

   IF iFrm NE "" THEN 
      oRet = STRING(DEC(oRet),iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE Грузоподъемность:
   DEF INPUT  PARAM iFrm       AS  CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet       AS  CHAR NO-UNDO.

   DEF BUFFER       kau-entry  FOR kau-entry.
   
   oRet = "".
   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK:
      oRet = GetXAttrValue ("loan",
                            {&MODUL} + "," + {&CARD},
                            "Грузоподъемность"
                           ).
   END.

   IF iFrm NE "" THEN 
      oRet = STRING(DEC(oRet),iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE ОКОФ:
   DEF INPUT  PARAM iFrm       AS  CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet       AS  CHAR NO-UNDO.

   DEF BUFFER       kau-entry  FOR kau-entry.
   DEF BUFFER       loan       FOR loan.
   DEF BUFFER       asset      FOR asset.
   
   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK ,

      FIRST loan WHERE 
            loan.contract  EQ {&MODUL}
        AND loan.cont-code EQ {&CARD}
            NO-LOCK,

      FIRST asset OF loan
            NO-LOCK:
      oRet = GetXAttrValue ("asset", 
                            GetSurrogateBuffer("asset",(BUFFER asset:HANDLE)),
                            "OKOF"
                           ).
   END.

   IF iFrm NE "" THEN 
      oRet = STRING(DEC(oRet),iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE НомерАмортГр:
   DEF INPUT  PARAM iFrm       AS  CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet       AS  CHAR NO-UNDO.

   DEF BUFFER       kau-entry  FOR kau-entry.
   DEF BUFFER       loan       FOR loan.
   DEF BUFFER       asset      FOR asset.
   
   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK ,
      
      FIRST loan WHERE 
            loan.contract  EQ {&MODUL}
        AND loan.cont-code EQ {&CARD}
            NO-LOCK,

      FIRST asset OF loan
            NO-LOCK:      
      oRet = GetXAttrValue ("asset",
                            GetSurrogateBuffer("asset",(BUFFER asset:HANDLE)),
                            "AmortGr"
                           ).
   END.

   IF iFrm NE "" THEN 
      oRet = STRING(DEC(oRet),iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE МассаЗолота:
   DEF INPUT  PARAM iFrm      AS  CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet      AS  CHAR NO-UNDO.

   RUN МассаМет( "Золото", 
                 iFrm, 
                 OUTPUT oRet
               ).

END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE МассаСеребра:
   DEF INPUT  PARAM iFrm      AS  CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet      AS  CHAR NO-UNDO.

   RUN МассаМет( "Серебро", 
                 iFrm, 
                 OUTPUT oRet
               ).

END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE МассаПлатины:
   DEF INPUT  PARAM iFrm      AS  CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet      AS  CHAR NO-UNDO.

   RUN МассаМет( "Платина", 
                 iFrm, 
                 OUTPUT oRet
               ).

END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE МассаПрочее:
   DEF INPUT  PARAM iFrm      AS  CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet      AS  CHAR NO-UNDO.

   RUN МассаМет( "Прочее", 
                 iFrm, 
                 OUTPUT oRet
               ).

END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE МассаМет:
   DEF INPUT  PARAM iNameMet  AS  CHAR NO-UNDO.
   DEF INPUT  PARAM iFrm      AS  CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet      AS  CHAR NO-UNDO.

   DEF BUFFER       kau-entry FOR kau-entry.
   DEF BUFFER       loan      FOR loan.
   DEF BUFFER       asset     FOR asset.
   
   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK ,
      
      FIRST loan WHERE 
            loan.contract  EQ {&MODUL}
        AND loan.cont-code EQ {&CARD} 
            NO-LOCK ,
      
      FIRST asset OF loan
            NO-LOCK :

      CASE iNameMet :
         WHEN "Золото"  THEN oRet = STRING(asset.precious-1).
         WHEN "Серебро" THEN oRet = STRING(asset.precious-2).
         WHEN "Платина" THEN oRet = STRING(asset.precious-3).
         WHEN "Прочее"  THEN oRet = STRING(asset.precious-4).
         OTHERWISE           oRet = "".
      END CASE.
   END.
   IF iFrm NE "" THEN 
      oRet = STRING(DEC(oRet),iFrm).
END PROCEDURE.

/*---------------------------------------------------------------------------*/
PROCEDURE КоличБ:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.

   DEF BUFFER op        FOR op.
   DEF BUFFER kau-entry  FOR kau-entry.
   DEF BUFFER xkau-entry FOR kau-entry.
   DEF BUFFER loan-acct FOR loan-acct.

   DEF VAR vQty AS INT64 NO-UNDO.

   oRet = "".
   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK ,
      
      FIRST op OF kau-entry NO-LOCK,
      LAST  loan-acct WHERE 
            loan-acct.contract  = {&MODUL}
        AND loan-acct.cont-code = {&CARD}
        AND loan-acct.acct-type = {&MODUL} + "-учет" 
        AND loan-acct.since    <= op.op-date 
            NO-LOCK,
      FIRST xkau-entry WHERE
            xkau-entry.kau    EQ kau-entry.kau
        AND xkau-entry.kau-id EQ kau-entry.kau-id
        AND xkau-entry.acct   EQ loan-acct.acct
        AND xkau-entry.curr   EQ loan-acct.curr
        AND xkau-entry.debit  EQ YES
            NO-LOCK
      :

      vQty = xkau-entry.qty.

   END.
   
   IF iFrm NE "" AND
      vQty NE 0 THEN 
      oRet = STRING(vQty,iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE Колич:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.

   DEF BUFFER op        FOR op.
   DEF BUFFER kau-entry FOR kau-entry.
   DEF BUFFER loan-acct FOR loan-acct.

   DEF VAR vQty AS INT64 NO-UNDO.

   oRet = "".
   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK
      :

      vQty = kau-entry.qty.

   END.
   
   IF iFrm NE "" AND
      vQty NE 0 THEN 
      oRet = STRING(vQty,iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE Сумма:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.

   DEF BUFFER op        FOR op.
   DEF BUFFER kau-entry FOR kau-entry.
   DEF BUFFER loan-acct FOR loan-acct.

   DEF VAR vSumma AS DEC NO-UNDO.

   oRet = "".
   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK,
      FIRST loan WHERE 
            loan.contract  EQ {&MODUL}
        AND loan.cont-code EQ {&CARD}
            NO-LOCK,
      FIRST asset OF loan
            NO-LOCK 
      :

      vSumma = kau-entry.qty * 
               GetCostUMC(loan.contract + CHR(6) + loan.cont-code,
                          kau-entry.op-date,
                          "",
                          ""
                         ).

   END.
   
   IF iFrm NE "" AND
      vSumma NE 0 THEN 
      oRet = STRING(vSumma,iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE СчетУчета:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.

   DEF BUFFER op        FOR op.
   DEF BUFFER kau-entry FOR kau-entry.
   DEF BUFFER loan-acct FOR loan-acct.

   oRet = "".
   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK ,
      
      FIRST op OF kau-entry 
            NO-LOCK,
      
      LAST  loan-acct WHERE 
            loan-acct.contract  = {&MODUL}
        AND loan-acct.cont-code = {&CARD}
        AND loan-acct.acct-type = {&MODUL} + "-учет" 
        AND loan-acct.since    <= op.op-date 
            NO-LOCK 
      :
   
      oRet = DelFilFromAcct(loan-acct.acct).

   END.
   
   IF iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE СчетУчета2:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.

   DEF BUFFER op        FOR op.
   DEF BUFFER kau-entry FOR kau-entry.
   DEF BUFFER loan-acct FOR loan-acct.

   DEF VAR vBalAcct AS INT64  NO-UNDO.
   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK,
      LAST  loan-acct WHERE 
            loan-acct.contract  = {&MODUL}
        AND loan-acct.cont-code = {&CARD}
        AND loan-acct.acct-type = {&MODUL} + "-учет" 
        AND loan-acct.since    <= kau-entry.op-date 
            NO-LOCK,
      FIRST acct OF loan-acct
            NO-LOCK
      :
   
      vBalAcct = acct.bal-acct.

   END.
   
   IF iFrm NE "" THEN 
      oRet = STRING(vBalAcct,iFrm).
   ELSE oRet = STRING(vBalAcct).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE НачАмортНорма:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.
   
   DEF VAR    vSum      AS  DEC NO-UNDO.
   DEF BUFFER op        FOR op.
   DEF BUFFER kau-entry FOR kau-entry.

   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK ,

      FIRST op OF kau-entry 
            NO-LOCK 
      :

      vSum = GetAmortNorm({&MODUL},
                          {&CARD},
                          op.op-date,
                          "Б"
                         ).
   END.
   IF GetSysConf("ap-os1a") EQ "Выбытие" THEN
      oRet = "".
   IF iFrm NE "" AND
      GetSysConf("ap-os1a") NE "Выбытие" THEN 
      oRet = STRING(vSum,iFrm).

END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE НачАмортНаим:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.
   
   DEF VAR    vSum      AS  DEC NO-UNDO.
   DEF BUFFER kau-entry FOR kau-entry.
   
   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK 
      :

      oRet = GetXAttrValueEx( "loan",
                              {&MODUL} + "," + {&CARD},
                              "МетНачАморт",
                              "Линейный"
                            ).
   END.
   IF GetSysConf("ap-os1a") EQ "Выбытие" THEN
      oRet = "".
   IF iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).

END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE СрокПолезИсп:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.

   DEF VAR    vTmpDec   AS  DEC NO-UNDO.
   DEF BUFFER op        FOR op.
   DEF BUFFER kau-entry FOR kau-entry.
   DEF BUFFER loan      FOR loan.

   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK ,
      
      FIRST op OF kau-entry
            NO-LOCK ,
      
      FIRST loan WHERE 
            loan.contract  EQ {&MODUL}
        AND loan.cont-code EQ {&CARD} 
            NO-LOCK 
      :

      vTmpDec = GetSrokAmor( RECID(loan),
                             "СПИБ",
                             op.op-date
                           ).
   END.
   IF vTmpDec EQ ? THEN 
      vTmpDec = 0.

   IF iFrm NE "" THEN 
      oRet = STRING(vTmpDec,iFrm).
   ELSE 
      oRet = STRING(vTmpDec).
   IF GetSysConf("ap-os1a") EQ "Выбытие" THEN
      oRet = "".

END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE МестоНахожд:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.

   DEF BUFFER       kau-entry FOR kau-entry.
   DEF BUFFER       loan      FOR loan.

   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK ,
      
      FIRST loan WHERE 
            loan.contract  EQ {&MODUL}
        AND loan.cont-code EQ {&CARD}
            NO-LOCK:      
      ASSIGN
         oRet = GetXAttrValue ("loan",
                               {&MODUL} + "," + {&CARD},
                               "Место"
                              )
         oRet = GetCodeName("Место", oRet)
      .

      IF oRet EQ ? THEN 
         oRet = "".
   END.
   
   IF iFrm NE "" THEN 
      oRet = STRING(INT64(oRet),iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE ОргИзг:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.

   DEF BUFFER       kau-entry FOR kau-entry.
   DEF BUFFER       loan      FOR loan.

   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK ,
      
      FIRST loan WHERE 
            loan.contract  EQ {&MODUL}
        AND loan.cont-code EQ {&CARD}
            NO-LOCK:      
      oRet = GetXAttrValue ("loan",
                            {&MODUL} + "," + {&CARD},
                            "ИмяИзготов"
                           ).
   END.
   
   IF iFrm NE "" THEN 
      oRet = STRING(INT64(oRet),iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE ОргПостав:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.

   DEF BUFFER       kau-entry FOR kau-entry.
   DEF BUFFER       loan      FOR loan.

   oRet = "".
   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK ,
      
      FIRST loan WHERE 
            loan.contract  EQ {&MODUL}
        AND loan.cont-code EQ {&CARD}
            NO-LOCK 
      :
      
      ASSIGN
         oRet = GetCodeName("Поставщики",
                            GetXattrValueEx("loan", 
                                            {&MODUL} + "," + {&CARD}, 
                                            "Поставщик",
                                            ?
                                           )
                           )
         oRet = IF oRet EQ ? THEN "" ELSE oRet
         .

      IF oRet EQ "" THEN
         oRet = GetXAttrValue ("loan",
                               {&MODUL} + "," + {&CARD},
                               "Поставщик"
                              ).
   END.
   
   IF iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE ЕдИзмер:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.

   DEF BUFFER       kau-entry FOR kau-entry.
   DEF BUFFER       loan      FOR loan.

   DEF VAR vSort AS CHAR NO-UNDO.

   oRet = "".
   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK ,
      
      FIRST loan WHERE 
            loan.contract  EQ {&MODUL}
        AND loan.cont-code EQ {&CARD}
            NO-LOCK,
      FIRST asset OF loan
            NO-LOCK
      :
      
         oRet = asset.unit.
      .
   END.
   
   IF iFrm NE "" THEN 
      oRet = STRING(INT64(oRet),iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE Марка:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.

   DEF BUFFER       kau-entry FOR kau-entry.
   DEF BUFFER       loan      FOR loan.

   DEF VAR vSort AS CHAR NO-UNDO.

   oRet = "".
   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK ,
      
      FIRST loan WHERE 
            loan.contract  EQ {&MODUL}
        AND loan.cont-code EQ {&CARD}
            NO-LOCK:      
      ASSIGN
         oRet  = GetXAttrValue ("loan",
                                {&MODUL} + "," + {&CARD},
                                "Марка"
                              )
         vSort = GetXAttrValue ("loan",
                                {&MODUL} + "," + {&CARD},
                                "Сорт"
                               )
      .

      {additem2.i oRet vSort ", "}
      ASSIGN oRet = TRIM(oRet)
             oRet = TRIM(oRet,",")
      .
   END.
   
   IF iFrm NE "" THEN 
      oRet = STRING(INT64(oRet),iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE ЦенаМЦ:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.

   DEF BUFFER       kau-entry FOR kau-entry.
   DEF BUFFER       loan      FOR loan.
   DEF BUFFER       asset     FOR asset.

   IF mInRecId EQ ? THEN
   FOR 
      FIRST loan WHERE 
            RECID(loan) EQ mInRecIdL
            NO-LOCK,
      FIRST asset OF loan
            NO-LOCK 
      :
      oRet = STRING(GetCostUMC(loan.contract + CHR(6) + loan.cont-code,
                               gend-date,
                               "",
                               ""
                               )
                   ).      
   END.
   ELSE
   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK ,
      
      FIRST loan WHERE 
            loan.contract  EQ {&MODUL}
        AND loan.cont-code EQ {&CARD}
            NO-LOCK,

      FIRST asset OF loan
            NO-LOCK 
      :
      oRet = STRING(GetCostUMC(loan.contract + CHR(6) + loan.cont-code,
                               kau-entry.op-date,
                               "",
                               ""
                               )
                   ).      
   END.
   
   IF iFrm NE "" THEN 
      oRet = STRING(DEC(oRet),iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE СуммаПров:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.

   DEF BUFFER       kau-entry FOR kau-entry.
   
   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId
            NO-LOCK
      :
      oRet = STRING(kau-entry.amt-rub).
   END.   

   IF GetSysConf("ap-os1a") EQ "Выбытие" THEN
      oRet = "".
   IF iFrm NE "" AND
      GetSysConf("ap-os1a") NE "Выбытие" THEN 
      oRet = STRING(DEC(oRet),iFrm) NO-ERROR.

END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE СуммаПослПровСчУч:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.

   DEF BUFFER       op        FOR op.
   DEF BUFFER       kau-entry FOR kau-entry.
   DEF VAR          vTmpSum   AS  DECIMAL NO-UNDO.

   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK ,
      
      FIRST op OF kau-entry
            NO-LOCK 
      :
      
      vTmpSum = GetLoan-Pos( {&MODUL},
                             {&CARD},
                             "учет",
                             op.op-date
                           ).
      oRet = STRING(vTmpSum).
   END.
   
   IF iFrm NE "" THEN 
      oRet = STRING(DEC(oRet),iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE СдатчСтруктПодр:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.

   DEF BUFFER       op        FOR op.
   DEF BUFFER       kau-entry FOR kau-entry.
   DEF BUFFER       acct      FOR acct.
   DEF VAR          vOp       AS INT64 NO-UNDO.

   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK 
      :
      vOp = kau-entry.op.
   END.   

   FOR 
      EACH  op WHERE 
            op.op EQ vOp
            NO-LOCK ,
      
      EACH  kau-entry OF op 
            NO-LOCK ,
      
      FIRST acct OF kau-entry WHERE 
            acct.side EQ STRING(kau-entry.debit,"П/А")
            NO-LOCK 
      :

      oRet = GetObjName( "branch",
                         {&OTDL},
                         YES
                       ).
      LEAVE.
   END.
   IF iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE ПолучСтруктПодр:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.

   DEF BUFFER       op          FOR op.
   DEF BUFFER       kau-entry   FOR kau-entry.
   DEF BUFFER       acct        FOR acct.
   DEF VAR          vOp         AS INT64 NO-UNDO.

   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK 
      :
      vOp = kau-entry.op.
   END.   
      
   FOR 
      FIRST op WHERE 
            op.op EQ vOp
            NO-LOCK ,
      
      EACH  kau-entry OF op 
            NO-LOCK,
      
      FIRST acct OF kau-entry WHERE 
            acct.side EQ STRING(kau-entry.debit,"А/П")
            NO-LOCK
      :
      oRet = GetObjName( "branch",
                         {&OTDL},
                         YES
                       ).
      LEAVE.
   END.
   
   IF iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE ОКПОПолуч:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.

   DEF BUFFER op          FOR op.
   DEF BUFFER kau-entry   FOR kau-entry.
   DEF BUFFER acct        FOR acct.
   DEF VAR    vOp         AS  INT64   NO-UNDO.

   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId NO-LOCK 
      :
      vOp = kau-entry.op.
   END.   
      
   FOR 
      FIRST op WHERE 
            op.op EQ vOp
            NO-LOCK ,
      
      EACH  kau-entry OF op 
            NO-LOCK ,
      
      FIRST acct OF kau-entry WHERE 
            acct.side EQ STRING(kau-entry.debit,"А/П")
            NO-LOCK:
      oRet = GetXAttrValue ("branch",
                            {&OTDL},
                            "ОКПО"
                           ).
      LEAVE.
   END.
   
   IF iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE ОКПОСдатч:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.

   DEF BUFFER       op        FOR op.
   DEF BUFFER       kau-entry FOR kau-entry.
   DEF BUFFER       acct      FOR acct.
   DEF VAR          vOp       AS INT64 NO-UNDO.

   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK 
      :
      vOp = kau-entry.op.
   END.   
      
   FOR 
      FIRST op WHERE 
            op.op EQ vOp
            NO-LOCK ,
      
      EACH  kau-entry OF op 
            NO-LOCK ,
      
      FIRST acct OF kau-entry WHERE 
            acct.side EQ STRING(kau-entry.debit,"П/А")
            NO-LOCK 
      :

      oRet = GetXAttrValue ("branch",
                            {&OTDL},
                            "ОКПО"
                           ).
      LEAVE.
   END.
   
   IF iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE СдатчТабНомер:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.

   DEF BUFFER       op        FOR op.
   DEF BUFFER       kau-entry FOR kau-entry.
   DEF BUFFER       acct      FOR acct.
   DEF VAR          vOp       AS  INT64 NO-UNDO.

   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK 
      :
      vOp = kau-entry.op.
   END.   
      
   FOR 
      FIRST op WHERE 
            op.op EQ vOp 
            NO-LOCK ,
      
      EACH  kau-entry OF op 
            NO-LOCK ,
      
      FIRST acct OF kau-entry WHERE 
            acct.side EQ STRING(kau-entry.debit,"П/А")
            NO-LOCK 
      :
      oRet = {&MOL}.            
      LEAVE.
   END.
   
   IF iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE ПолучТабНомер:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.

   DEF BUFFER       op          FOR op.
   DEF BUFFER       kau-entry   FOR kau-entry.
   DEF BUFFER       acct        FOR acct.
   DEF VAR          vOp         AS  INT64 NO-UNDO.

   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK 
      :
      vOp = kau-entry.op.
   END.   
      
   FOR 
      FIRST op WHERE 
            op.op EQ vOp
            NO-LOCK ,
      
      EACH  kau-entry OF op 
            NO-LOCK,
      
      FIRST acct OF kau-entry WHERE 
            acct.side EQ STRING(kau-entry.debit,"А/П")
            NO-LOCK 
      :

      oRet = {&MOL}.      
      
      LEAVE.
   END.
   
   IF iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE ПолучФИО:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.

   DEF BUFFER       op          FOR op.
   DEF BUFFER       kau-entry   FOR kau-entry.
   DEF BUFFER       acct        FOR acct.
   DEF VAR          vOp         AS  INT64 NO-UNDO.

   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK 
      :
      vOp = kau-entry.op.
   END.   
      
   FOR 
      FIRST op WHERE 
            op.op EQ vOp
            NO-LOCK ,
      
      EACH  kau-entry OF op 
            NO-LOCK,
      
      FIRST acct OF kau-entry WHERE 
            acct.side EQ STRING(kau-entry.debit,"А/П")
            NO-LOCK
      :
      oRet = GetObjName( "employee",
                         shFilial + "," + {&MOL},
                         YES
                       ).
      LEAVE.
   END.
   
   IF iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE СдатчФИО:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.

   DEF BUFFER       op        FOR op.
   DEF BUFFER       kau-entry FOR kau-entry.
   DEF BUFFER       acct      FOR acct.
   DEF VAR          vOp       AS  INT64 NO-UNDO.

   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK 
      :
      vOp = kau-entry.op.
   END.   
      
   FOR 
      FIRST op WHERE 
            op.op EQ vOp
            NO-LOCK ,
      
      EACH  kau-entry OF op 
            NO-LOCK ,
      
      FIRST acct OF kau-entry WHERE 
            acct.side EQ STRING(kau-entry.debit,"П/А")
            NO-LOCK 
      :
      oRet = GetObjName( "employee",
                         shFilial + "," + {&MOL},
                         YES
                       ).
      LEAVE.
   END.
   
   IF iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE СдатчДолж:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.

   DEF BUFFER       op        FOR op.
   DEF BUFFER       kau-entry FOR kau-entry.
   DEF BUFFER       acct      FOR acct.
   DEF VAR          vOp       AS  INT64 NO-UNDO.

   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK 
      :
      vOp = kau-entry.op.
   END.   
      
   FOR 
      FIRST op WHERE 
            op.op EQ vOp 
            NO-LOCK ,
      
      EACH  kau-entry OF op 
            NO-LOCK,
      
      FIRST acct OF kau-entry WHERE 
            acct.side EQ STRING(kau-entry.debit,"П/А")
            NO-LOCK 
      :
      
      oRet = GetXAttrValue ("employee",
                            shFilial + "," + {&MOL},
                            "role"
                           ).
      LEAVE.
   END.
   
   IF iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE ПолучДолж:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.

   DEF BUFFER       op          FOR op.
   DEF BUFFER       kau-entry   FOR kau-entry.
   DEF BUFFER       acct        FOR acct.
   DEF VAR          vOp         AS  INT64 NO-UNDO.

   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK 
      :
      vOp = kau-entry.op.
   END.   
      
   FOR 
      FIRST op WHERE 
            op.op EQ vOp 
            NO-LOCK ,
      
      EACH  kau-entry OF op 
            NO-LOCK,
      
      FIRST acct OF kau-entry WHERE 
            acct.side EQ STRING(kau-entry.debit,"А/П")
            NO-LOCK 
      : 

      oRet = GetXAttrValue ("employee",
                            shFilial + "," + {&MOL},
                            "role"
                           ).
      LEAVE.
   END.
   
   IF iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE ФактСрокЭксплЛет:
   DEF INPUT  PARAM iFrm AS  CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS  CHAR NO-UNDO.

   DEF VAR vTmpInt AS INT64 NO-UNDO.

   RUN ФактСрокЭкспл ( "",
                       OUTPUT oRet
                     ).
   ASSIGN
      vTmpInt = INT64(oRet)
      oRet    = STRING( TRUNCATE( vTmpInt / 12 , 0) ) 
                + "," + STRING(vTmpInt - TRUNCATE( vTmpInt / 12 , 0 ) * 12 )
   .

   IF GetSysConf("ap-os1a") EQ "Ввод" THEN
      oRet = "".
   IF iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).

END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE Npp:
   DEF INPUT  PARAM iFrm AS  CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS  CHAR NO-UNDO.

   mNpp = mNpp + 1.

   oRet = STRING(mNpp).
   IF iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).

END PROCEDURE.

PROCEDURE ДокНомI:
   DEF INPUT  PARAM iFrm AS  CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS  CHAR NO-UNDO.

   oRet = GetSysConf("ap-os15:doc-num").
   IF iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).
END PROCEDURE.

PROCEDURE ПериодС:
   DEF INPUT  PARAM iFrm AS  CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS  CHAR NO-UNDO.

   oRet = GetEntries(1,pick-value,"-","").
   IF iFrm NE "" THEN 
      oRet = STRING(DATE(oRet),iFrm).
END PROCEDURE.
PROCEDURE ПериодПо:
   DEF INPUT  PARAM iFrm AS  CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS  CHAR NO-UNDO.

   oRet = GetEntries(2,pick-value,"-","").
   IF iFrm NE "" THEN 
      oRet = STRING(DATE(oRet),iFrm).
END PROCEDURE.

PROCEDURE ДатаI:
   DEF INPUT  PARAM iFrm AS  CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS  CHAR NO-UNDO.

   oRet = GetSysConf("ap-os15:op-date").
   DATE(GetSysConf("ap-os15:op-date")) NO-ERROR.

   IF iFrm NE "" AND
      ERROR-STATUS:ERROR EQ NO THEN 
      oRet = STRING(DATE(oRet),iFrm).
END PROCEDURE.

/*---------------------------------------------------------------------------*/
PROCEDURE Итого:
   DEF INPUT  PARAM iFrm AS  CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS  CHAR NO-UNDO.

   DEF BUFFER       op          FOR op.
   DEF BUFFER       kau-entry   FOR kau-entry.
   DEF VAR          vOp         AS  INT64 NO-UNDO.
   DEF VAR          vItogo      AS  DEC NO-UNDO.

   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK 
      :
      vOp = kau-entry.op.
   END.   
      
   vItogo = 0.
   FOR 
      FIRST op WHERE 
            op.op EQ vOp 
            NO-LOCK ,
      
      EACH  kau-entry OF op WHERE 
            kau-entry.debit EQ yes
            NO-LOCK 
      : 
      vItogo = vItogo + kau-entry.amt-rub.
   END.

   oRet = STRING(vItogo).
   IF iFrm NE "" THEN 
      oRet = STRING(DEC(oRet),iFrm).

END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE ИтогоУ:
   DEF INPUT  PARAM iFrm AS  CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS  CHAR NO-UNDO.

   DEF BUFFER       op          FOR op.
   DEF BUFFER       kau-entry   FOR kau-entry.
   DEF VAR          vOp         AS  INT64 NO-UNDO.
   DEF VAR          vItogo      AS  DEC NO-UNDO.

   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK 
      :
      vOp = kau-entry.op.
   END.   
      
   vItogo = 0.
   FOR 
      FIRST op WHERE 
            op.op EQ vOp 
            NO-LOCK ,
      
      EACH  kau-entry OF op WHERE 
            kau-entry.debit  EQ     yes        AND
            kau-entry.kau-id BEGINS "УМЦ-учет"
            NO-LOCK 
      : 
      vItogo = vItogo + kau-entry.amt-rub.
   END.

   oRet = STRING(vItogo).
   IF iFrm NE "" THEN 
      oRet = STRING(DEC(oRet),iFrm).

END PROCEDURE.
/*---------------------------------------------------------------------------*/

PROCEDURE ДатаОкончРек:
   DEF INPUT  PARAM iFrm      AS  CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet      AS  CHAR NO-UNDO.

   DEF BUFFER       kau-entry FOR kau-entry.

   oRet = "".
   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK
      :
      oRet = GetXattrValue("loan", 
                           {&MODUL} + "," + {&CARD}, 
                           "ПериодКонс"
                          ).
      IF oRet NE "" THEN   
         oRet = TRIM(GetEntries(2,GetEntries(NUM-ENTRIES(oRet),oRet,",",""),"-","")).
   END.
   IF oRet EQ ? THEN 
      oRet = "".
   IF GetSysConf("ap-os1a") EQ "Ввод"  THEN
      oRet = "".
   IF     oRet NE ""
      AND iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).
END PROCEDURE.

/*---------------------------------------------------------------------------*/
PROCEDURE ДляВыводаПров:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.

   DEF BUFFER   kau-entry       FOR kau-entry.
   DEF BUFFER   kau-entry-tmp   FOR kau-entry.
   DEF VAR      mRecId   AS CHAR NO-UNDO INITIAL "".

   IF NUM-ENTRIES(pick-value) > 1 THEN
   DO:
       mRecId = ENTRY(2,pick-value,",").
       pick-value = ENTRY(1,pick-value,",").
   END.
 
   FIND FIRST kau-entry WHERE 
              RECID(kau-entry) EQ mInRecId 
              NO-LOCK NO-ERROR. 

   IF mRecId EQ "" THEN
   DO:
      {empty tmprecid}

      FOR LAST loan-acct     WHERE loan-acct.contract  EQ {&MODUL}
                             AND   loan-acct.cont-code EQ {&CARD}
                             AND   loan-acct.acct-type EQ {&MODUL} + "-учет"
                             AND   loan-acct.since     <= DATE(ENTRY(2,pick-value,"-"))
                             NO-LOCK,

          EACH kau-entry-tmp WHERE kau-entry.acct        EQ     loan-acct.acct
                             AND   kau-entry.currency    EQ     loan-acct.currency 
                             AND   kau-entry-tmp.kau     BEGINS ({&MODUL} + "," + {&CARD} + ",")
                             AND   kau-entry-tmp.debit   EQ     YES
                             AND   kau-entry-tmp.op-date >=     DATE(ENTRY(1,pick-value,"-"))
                             AND   kau-entry-tmp.op-date <=     DATE(ENTRY(2,pick-value,"-"))
                             NO-LOCK
          :
              CREATE tmprecid.
              tmprecid.id = RECID(kau-entry-tmp).
      END.
   END.
   ELSE
   DO:
      {empty tmprecid}

      IF AVAILABLE kau-entry THEN
         FOR FIRST op             WHERE    RECID(op) EQ INT64(mRecId)
                                  NO-LOCK,

             FIRST kau-entry-tmp  WHERE    kau-entry-tmp.kau     BEGINS ({&MODUL} + "," + {&CARD} + ",")
                                  AND      kau-entry-tmp.debit   EQ     YES
                                  AND      kau-entry-tmp.op      EQ     op.op
                                  AND      kau-entry-tmp.op-date EQ     op.op-date
                                  NO-LOCK
         :
            CREATE tmprecid.
            tmprecid.id = RECID(kau-entry-tmp).
         END.
      ELSE
         FOR FIRST op
             WHERE RECID(op) EQ INT64(mRecId)
         NO-LOCK
            , LAST kau-entry-tmp
                OF op
         NO-LOCK
         :
            CREATE tmprecid.
            tmprecid.id = RECID(kau-entry-tmp).
         END.
   END.

   IF (NUM-ENTRIES(pick-value) EQ 1) AND (mRecId NE "") THEN
        pick-value = pick-value + "," + mRecId.

   oRet = "".
END PROCEDURE.

/*---------------------------------------------------------------------------*/
PROCEDURE СуммПров:
   DEFINE  INPUT PARAMETER iFrm AS CHARACTER NO-UNDO.
   DEFINE OUTPUT PARAMETER oRet AS CHARACTER NO-UNDO.

   DEFINE VARIABLE vSum AS DECIMAL NO-UNDO INITIAL 0.00. /* Сумма */

   DEFINE BUFFER kau-entry-tmp FOR kau-entry.

   FOR EACH tmprecid
   NO-LOCK
    , FIRST kau-entry-tmp
      WHERE RECID(kau-entry-tmp) EQ tmprecid.id
   NO-LOCK
   :
      vSum = vSum + kau-entry-tmp.amt-rub.
   END.

   IF iFrm NE "" THEN 
      oRet = STRING(vSum, iFrm).
   ELSE
      oRet = STRING(vSum).
END PROCEDURE.

/*---------------------------------------------------------------------------*/
PROCEDURE ДокОсн:
   DEF INPUT  PARAM iFrm AS  CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS  CHAR NO-UNDO.

   DEF BUFFER       kau-entry   FOR kau-entry.

   FOR FIRST kau-entry WHERE RECID(kau-entry) EQ mInRecId
   NO-LOCK:
      oRet = GetXAttrValue ("op",
                           STRING(kau-entry.op),
                           "ДокОсн").
   END.   

   IF iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).
   ELSE
      oRet = STRING(oRet).
END PROCEDURE.

/*---------------------------------------------------------------------------*/
PROCEDURE НомерОС:
   DEF INPUT  PARAM iFrm AS  CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS  CHAR NO-UNDO.

   DEF BUFFER       kau-entry   FOR kau-entry.

   FOR FIRST kau-entry WHERE RECID(kau-entry) EQ mInRecId
   NO-LOCK:
      oRet = GetXAttrValue ("op",
                           STRING(kau-entry.op),
                           "НомерОС").
   END.   

   IF iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).
   ELSE
      oRet = STRING(oRet).
END PROCEDURE.

/*---------------------------------------------------------------------------*/
PROCEDURE ДатаОС:
   DEF INPUT  PARAM iFrm AS  CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS  CHAR NO-UNDO.

   DEF BUFFER       kau-entry   FOR kau-entry.

   FOR FIRST kau-entry WHERE RECID(kau-entry) EQ mInRecId
   NO-LOCK:
      oRet = GetXAttrValue ("op",
                           STRING(kau-entry.op),
                           "ДатаОС").
   END.   

   IF iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).
   ELSE
      oRet = STRING(oRet).
END PROCEDURE.
