{pirsavelog.p}
/*                          
               Банковская интегрированная система БИСквит
    Copyright: (C) MCMXCII-MCMXCIX ТОО "Банковские информационные системы"
     Filename: os-lib.p
      Comment: библиотека функций для шаблона ap-os4a (ОС-4а).
   Parameters: 
         Uses: globals.i intrface.get 
      Used by: ap-os1o.p ap-os2o.p ap-os4o.p 
      Created: 22/07/2003 AVAL

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
   НаимОрг
   ОКПО
   ФункцияДляПримера
   ДатаПрин
   НачСтоим
   НачАморт
   ОстатСтоим
   НомерШасси
   НомерПаспорта
   НомерДвиг
   Масса
   Грузоподъемность
   МассаЗолота
   МассаСеребра
   МассаПлатины
   МассаПрочее
   МассаМет
   СчетУчета
   СчетКоресп
   НачАмортНорма
   НачАмортНаим
   СрокПолезИсп
   МестоНахожд
   ОргИзг
   ЦенаМЦ
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
   Итого
*/
{globals.i}
{intrface.get umc}
{intrface.get date}
{intrface.get xobj}
{intrface.get xclass}

&SCOP MODUL ENTRY(1,kau-entry.kau)
&SCOP CARD  ENTRY(2,kau-entry.kau)
&SCOP MOL   ENTRY(3,kau-entry.kau)
&SCOP OTDL  ENTRY(4,kau-entry.kau)

DEF VAR mNpp     AS INT   NO-UNDO.
DEF VAR mInRecId AS RECID NO-UNDO.

/*---------------------------------------------------------------------------*/
PROCEDURE SetNpp:
   DEF INPUT PARAM iNpp AS INT NO-UNDO.
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
PROCEDURE ОбрезатьСдвинуть:
   DEF INPUT  PARAM iStr AS CHAR NO-UNDO.
   DEF INPUT  PARAM iLen AS CHAR NO-UNDO.
   DEF INPUT  PARAM iLRC AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oStr AS CHAR NO-UNDO.

   IF iLen  NE "" THEN
   DO:      
      IF iLRC EQ "Л" THEN 
         ASSIGN 
            oStr = iStr + FILL(" ",INT(iLen))
            oStr = SUBSTRING(oStr,1,INT(iLen))
         .
      ELSE IF iLRC EQ "П" THEN 
         ASSIGN 
            oStr = FILL(" ",INT(iLen)) + iStr
            oStr = SUBSTRING(oStr,LENGTH(oStr) - INT(iLen) + 1)
         .
   END.
   ELSE 
      oStr = iStr.
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE ДопРекв:
   DEF INPUT  PARAM iFileName  AS CHAR NO-UNDO.
   DEF INPUT  PARAM iSurrogat  AS CHAR NO-UNDO.
   DEF INPUT  PARAM iCode      AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet       AS CHAR NO-UNDO.

   oRet = GetXAttrValueEx( iFileName,
                           iSurrogat,
                           iCode,
                           ""
                         ).

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
PROCEDURE СчетКоресп:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.

   DEF BUFFER op        FOR op.
   DEF BUFFER kau-entry FOR kau-entry.
   DEF BUFFER op-entry FOR op-entry.
   
   
   oRet = "".
   FOR FIRST kau-entry WHERE 
             RECID(kau-entry) EQ mInRecId 
             NO-LOCK,
       FIRST op OF kau-entry
             NO-LOCK
       ,
       FIRST op-entry OF op
             NO-LOCK
       :
       
       oRet = op-entry.acct-cr.
   END.
   IF iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).
END PROCEDURE.
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
   
   oRet = "".
   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
      NO-LOCK 
      :
      
      oRet = {&CARD}.
   END.
   IF iFrm NE "" THEN 
      oRet = STRING(INT(oRet),iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE НомерЗав:
   DEF INPUT  PARAM iFrm       AS  CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet       AS  CHAR NO-UNDO.

   DEF BUFFER       kau-entry  FOR kau-entry.
   
   oRet = "".
   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK 
      :
      
      RUN ДопРекв ( "loan", 
                    {&MODUL} + "," + {&CARD}, 
                    "НомерЗавод", 
                    OUTPUT oRet 
                  ).
   END.
   IF iFrm NE "" THEN 
      oRet = STRING(INT(oRet),iFrm).
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
      
      RUN ДопРекв ( "loan", 
                    {&MODUL} + "," + {&CARD}, 
                    "НомернойЗнак", 
                    OUTPUT oRet 
                  ).
   END.
   IF iFrm NE "" THEN 
      oRet = STRING(INT(oRet),iFrm).
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
   DEF INPUT  PARAM iFrm AS  CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS  CHAR NO-UNDO.

   DEF BUFFER kau-entry  FOR kau-entry.

   oRet = "".
   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK 
      :
      
      RUN ДопРекв ( "loan", 
                    {&MODUL} + "," + {&CARD},
                    "ДатаИзготов", 
                    OUTPUT oRet 
                  ).
      oRet = STRING(YEAR(DATE(oRet))).
   END.

   IF oRet EQ ? THEN 
      oRet = "".
   IF iFrm NE "" THEN 
      oRet = STRING(INT(oRet),iFrm).
   IF INT(oRet) EQ 0 THEN 
         oRet = FILL(" ",LENGTH(oRet)).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE ДатаИзготов:
   DEF INPUT  PARAM iFrm AS  CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS  CHAR NO-UNDO.

   DEF BUFFER kau-entry  FOR kau-entry.

   oRet = "".
   FOR 
      FIRST kau-entry WHERE 
            RECID(kau-entry) EQ mInRecId 
            NO-LOCK
      :
      
      RUN ДопРекв ( "loan", 
                    {&MODUL} + "," + {&CARD},
                    "ДатаИзготов", 
                    OUTPUT oRet 
                  ).
   END.
   IF oRet EQ ? THEN 
      oRet = "".
   IF     oRet NE "" 
      AND iFrm NE "" THEN 
      oRet = STRING(DATE(oRet),iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE ФактСрокЭкспл:
   DEF INPUT  PARAM iFrm AS  CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS  CHAR NO-UNDO.

   DEF BUFFER op         FOR op.
   DEF BUFFER kau-entry  FOR kau-entry.
   DEF VAR    vDD        AS  DATE NO-UNDO. /* дата документа             */
   DEF VAR    vDP        AS  DATE NO-UNDO. /* дата принятия на учет      */
   DEF VAR    vSE        AS  INT  NO-UNDO. /* срок эксплуатации (до нас) */
   DEF VAR    vCD        AS  INT  NO-UNDO. /* количество дней            */

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
      vDP = DATE(oRet).
      
      RUN ДопРекв ( "loan", 
                    {&MODUL} + "," + {&CARD}, 
                    "СрокЭкспл", 
                    OUTPUT oRet 
                  ).
      ASSIGN
      vSE = INT(oRet)
      vDD = op.op-date
      .
   END.
   ASSIGN
   vCD = vSE + IF    vDP EQ 01/01/0001 
                  OR vDP EQ 01/01/9999 THEN 
                  0 
               ELSE 
                  INT(MonInPer(vDP,vDD))
   oRet = STRING(vCD)
   .

   IF oRet EQ ? THEN 
      oRet = "".
   IF     oRet NE "" 
      AND iFrm NE "" THEN 
      oRet = STRING(INT(oRet),iFrm).
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
            NO-LOCK 
      :

      RUN ДопРекв ( "employee", 
                    {&MOL}, 
                    "role", 
                    OUTPUT oRet 
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
                         {&MOL},
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

      oRet = CAPS(asset.name).
   
   END.

   IF iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE НаимОрг:
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
      oRet = branch.name.
   END.

   IF iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE АдресОрг:
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
      oRet = branch.address.
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
      RUN ДопРекв ( "branch", 
                    branch.branch-id, 
                    "ОКПО", 
                    OUTPUT oRet 
                  ).
   END.
   
   IF iFrm NE "" THEN 
      oRet = STRING(INT(oRet),iFrm).
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
            NO-LOCK 
      :
      RUN ДопРекв ( "branch", 
                    branch.branch-id, 
                    "ОКПО", 
                    OUTPUT oRet 
                  ).
   END.
   
   IF iFrm NE "" THEN 
      oRet = STRING(INT(oRet),iFrm).
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
   DEF VAR          vOp       AS  INT   NO-UNDO.

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

   RUN СуммаПров ( "",
                   OUTPUT oRet
                 ).
   vRes[1] = DEC(oRet).

   RUN НачАморт ( "",
                  OUTPUT oRet
                ).
   vRes[2] = DEC(oRet).

   oRet = STRING(vRes[1] - vRes[2]).

   IF oRet EQ ? THEN 
      oRet = "".
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
            NO-LOCK 
      :
      
      RUN ДопРекв ( "loan", 
                    {&MODUL} + "," + {&CARD}, 
                    "НомерШасси", 
                    OUTPUT oRet 
                  ).
   END.

   IF iFrm NE "" THEN 
      oRet = STRING(INT(oRet),iFrm).
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
            NO-LOCK 
      :

      RUN ДопРекв ( "loan", 
                    {&MODUL} + "," + {&CARD}, 
                    "НомерПаспорта", 
                    OUTPUT oRet 
                  ).

   END.

   IF iFrm NE "" THEN 
      oRet = STRING(INT(oRet),iFrm).
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
            NO-LOCK 
      :

      RUN ДопРекв ( "loan", 
                    {&MODUL} + "," + {&CARD}, 
                    "НомерДвиг", 
                    OUTPUT oRet 
                  ).
   
   END.

   IF iFrm NE "" THEN 
      oRet = STRING(INT(oRet),iFrm).
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
            NO-LOCK 
      :

      RUN ДопРекв ( "loan", 
                    {&MODUL} + "," + {&CARD}, 
                    "Масса", 
                    OUTPUT oRet 
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
            NO-LOCK
      :

      RUN ДопРекв ( "loan", 
                    {&MODUL} + "," + {&CARD}, 
                    "Грузоподъемность", 
                    OUTPUT oRet 
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
            NO-LOCK
      :

      RUN ДопРекв ( "asset", 
                    asset.cont-type, 
                    "OKOF", 
                    OUTPUT oRet 
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
            NO-LOCK
      :
      
      RUN ДопРекв ( "asset", 
                    asset.cont-type, 
                    "AmortGr", 
                    OUTPUT oRet 
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
PROCEDURE СчетУчета:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.

   DEF BUFFER op        FOR op.
   DEF BUFFER kau-entry FOR kau-entry.
   DEF BUFFER loan-acct FOR loan-acct.

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
   
      oRet = loan-acct.acct.

   END.
   
   IF iFrm NE "" THEN 
      oRet = STRING(oRet,iFrm).
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
   IF iFrm NE "" THEN 
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
            NO-LOCK :
      
      RUN ДопРекв ( "loan", 
                    {&MODUL} + "," + {&CARD}, 
                    "Место", 
                    OUTPUT oRet 
                  ).
      oRet = GetCodeName("Место", oRet).
      IF oRet EQ ? THEN 
         oRet = "".
   END.
   
   IF iFrm NE "" THEN 
      oRet = STRING(INT(oRet),iFrm).
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
            NO-LOCK 
      :
      
      RUN ДопРекв ( "loan", 
                    {&MODUL} + "," + {&CARD}, 
                    "ИмяИзготов", 
                    OUTPUT oRet 
                  ).
   END.
   
   IF iFrm NE "" THEN 
      oRet = STRING(INT(oRet),iFrm).
END PROCEDURE.
/*---------------------------------------------------------------------------*/
PROCEDURE ЦенаМЦ:
   DEF INPUT  PARAM iFrm AS CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS CHAR NO-UNDO.

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
            NO-LOCK,

      FIRST asset OF loan
            NO-LOCK 
      :
      oRet = STRING(asset.cost).      
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

   IF iFrm NE "" THEN 
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
   DEF VAR          vOp       AS INT NO-UNDO.

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
   DEF VAR          vOp         AS INT NO-UNDO.

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
   DEF VAR    vOp         AS  INT   NO-UNDO.

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
            NO-LOCK 
      :

      RUN ДопРекв ( "branch", 
                    {&OTDL}, 
                    "ОКПО", 
                    OUTPUT oRet 
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
   DEF VAR          vOp       AS INT NO-UNDO.

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

      RUN ДопРекв ( "branch", 
                    {&OTDL}, 
                    "ОКПО", 
                    OUTPUT oRet 
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
   DEF VAR          vOp       AS  INT NO-UNDO.

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
   DEF VAR          vOp         AS  INT NO-UNDO.

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
   DEF VAR          vOp         AS  INT NO-UNDO.

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
                         {&MOL},
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
   DEF VAR          vOp       AS  INT NO-UNDO.

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
                         {&MOL},
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
   DEF VAR          vOp       AS  INT NO-UNDO.

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
      
      RUN ДопРекв ( "employee", 
                    {&MOL}, 
                    "role", 
                    OUTPUT oRet 
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
   DEF VAR          vOp         AS  INT NO-UNDO.

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

      RUN ДопРекв ( "employee", 
                    {&MOL}, 
                    "role", 
                    OUTPUT oRet 
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

   DEF VAR vTmpInt AS INT NO-UNDO.

   RUN ФактСрокЭкспл ( "",
                       OUTPUT oRet
                     ).
   ASSIGN
   vTmpInt = INT(oRet)
   oRet    = STRING( TRUNCATE( vTmpInt / 12 , 0) ) 
             + "," + STRING(vTmpInt - TRUNCATE( vTmpInt / 12 , 0 ) * 12 )
   .

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
/*---------------------------------------------------------------------------*/
PROCEDURE Итого:
   DEF INPUT  PARAM iFrm AS  CHAR NO-UNDO.
   DEF OUTPUT PARAM oRet AS  CHAR NO-UNDO.

   DEF BUFFER       op          FOR op.
   DEF BUFFER       kau-entry   FOR kau-entry.
   DEF VAR          vOp         AS  INT NO-UNDO.
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
