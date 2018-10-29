/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2007 ЗАО "Банковские информационные системы"
     Filename: ap-inv.p
      Comment: Инвентаризационная опись по страницам
   Parameters:
         Uses:
      Used by:
      Created: 14/07/2007 BMS
     Modified:            BMS
*/

{globals.i}
{a-defs.i}

{tmprecid.def}

/*для временного хранения recid'ов записей*/
DEF TEMP-TABLE tmprecid-tmp NO-UNDO LIKE tmprecid.

/* Переменные, запрашиваемые у пользователя */
DEF VAR mMol        AS CHAR NO-UNDO. /* Список таб. номеров МОЛ   */
DEF VAR mDocNum     AS CHAR NO-UNDO. /* Введенный номер документа */
DEF VAR mPlace      AS CHAR NO-UNDO. /* Введенное местонахождение */

DEF VAR mAbsen      AS LOG  NO-UNDO
   VIEW-AS RADIO-SET
   RADIO-BUTTONS "Учитывать"   , YES,
                 "Не учитывать", NO.

/* -------------------------------------------------------- */

/* Хэндл процедуры с парсерными функциями УМЦ   */
DEF VAR mH           AS HANDLE  NO-UNDO.
/* Признак необходимости удаления процедур      */
DEF VAR remove-mH    AS LOGICAL NO-UNDO INIT NO.

DEF VAR in-dataclass-id  LIKE DataClass.DataClass-Id NO-UNDO. /*для norm.i*/
DEF VAR in-branch-id     LIKE DataBlock.Branch-id    NO-UNDO. /*для norm.i*/
DEF VAR in-beg-date      LIKE DataBlock.Beg-Date     NO-UNDO. /*для norm.i*/
DEF VAR in-end-date      LIKE DataBlock.End-Date     NO-UNDO. /*для norm.i*/

FORM
   WITH FRAME dateframe2 CENTERED ROW 10 OVERLAY 1 COL SIDE-LABELS COLOR MESSAGES
   TITLE "[ ПАРАМЕТРЫ ДЛЯ ПЕЧАТИ ]".


MAIN:
DO ON ERROR UNDO MAIN, LEAVE MAIN:
   FOR EACH tmprecid:
      CREATE tmprecid-tmp.
      BUFFER-COPY tmprecid TO tmprecid-tmp.
   END.

   {getdate.i
      &DispBeforeDate = "
                         mDocNum
                            FORMAT 'x(6)'
                            LABEL 'Номер документа'
                            HELP  'Введите номер документа'
                        "
      &UpdBeforeDate  = "mDocNum"
      &DispAfterDate  = "
                         mPlace
                            FORMAT 'x(50)'
                            LABEL  'Местонахождение'
                            HELP   'Местонахождение (F1 - выбор из справочника)'
                            VIEW-AS FILL-IN SIZE 20 BY 1
                         mMol
                            FORMAT 'x(50)'
                            HELP  'МОЛ (F1 - выбор из справочника)'
                            LABEL 'МОЛ'
                            VIEW-AS FILL-IN SIZE 20 BY 1

                         '----------------'

                         mAbsen
                            LABEL 'Отсутствие МЦ '
                            HELP  'Учитывать дополнительный реквизит карточки <Отсутствует> ?'
                        "
      &UpdAfterDate   = "mPlace mMol mAbsen"
      &DateLabel      = "Дата документа"
      &DateHelp       = "Введите дату документа"
      &AddLookUp      = "
                         IF     LASTKEY     EQ 301
                            AND FRAME-FIELD EQ 'mPlace'
                         THEN DO TRANS:
                            RUN pclass.p ('Место',
                                          'Место',
                                          'МЕСТО ЭКСПЛУАТАЦИИ',
                                          6).
                            IF     pick-value NE ?
                               AND (LASTKEY = 10 OR LASTKEY = 13)
                            THEN DO:
                               mPlace = GetCodeName('Место', pick-value).
                               DISPLAY mPlace.
                            END.
                         END.
                         ELSE IF     LASTKEY     EQ 301
                                 AND FRAME-FIELD EQ 'mMol' THEN
                         DO TRANS:
                            /* Для коррекной работы поля mMol */
                            ASSIGN mMol.

                            RUN a-emptab.p (?, 4).

                            IF CAN-FIND(FIRST tmprecid) THEN
                            FOR EACH tmprecid NO-LOCK,
                               EACH employee     WHERE
                                    RECID(employee) EQ tmprecid.id
                               NO-LOCK:
                               IF NOT(CAN-DO(mMol, STRING(employee.tab-no))) THEN
                                  mMol = mMol + (IF mMol NE '' THEN ',' ELSE '')
                                       + STRING(employee.tab-no).
                            END.

                            ELSE
                            IF     pick-value        NE ?
                               AND NOT(CAN-DO(mMol, pick-value))
                            THEN
                               mMol =   mMol + (IF mMol NE '' THEN ',' ELSE '')
                                      + pick-value.

                            DISPLAY mMol.

                         END.
                         ELSE
                        "
      &AddPostUpd     = "
                         IF NUM-ENTRIES(mMol) GT 3 THEN
                         DO:
                            MESSAGE 'Нельзя вводить больше трех МОЛ!'
                            VIEW-AS ALERT-BOX.
                            UNDO, RETRY.
                         END.
                        "
      &return         = " LEAVE MAIN "
   }

   {empty tmprecid}
   FOR EACH tmprecid-tmp:
      CREATE tmprecid.
      BUFFER-COPY tmprecid-tmp TO tmprecid.
   END.

   {justasec}

/*----------------------------------------------------------------------------*/
/*  Открыть олаповские дела                                                   */
/*----------------------------------------------------------------------------*/

   mH = SESSION:FIRST-PROCEDURE.
   DO WHILE mH NE ?:
      IF     mH:FILE-NAME    EQ "a-obj.p"
         AND mH:PRIVATE-DATA NE "Slave"   THEN
         LEAVE.
         mH = mH:NEXT-SIBLING.
   END.

   IF VALID-HANDLE(mH) THEN
      RUN Save IN mH.
   ELSE
   DO:
     RUN "a-obj.p" PERSISTENT SET mH ("Slave", "", "").
     remove-mH = YES.
   END.

   RUN SetSysConf IN h_base ("in-dt:doc-num", mDocNum).
   RUN SetSysConf IN h_base ("in-dt:op-date", STRING(end-date,"99/99/9999")).
   RUN SetSysConf IN h_base ("in-dt:place"  , mPlace).
   RUN SetSysConf IN h_base ("in-dt:absen"  , mAbsen).
   RUN SetSysConf IN h_base ("in-dt:molrole", mMol).

   ASSIGN
      in-beg-date = end-date
      in-end-date = end-date
   .

   {norm.i new}
   {norm-beg.i
      &title     = "'ГЕНЕРАЦИЯ ОТЧЕТА' "
      &nodate    = YES
      &is-branch = YES
      &nofil     = YES
   }

   IF work-module EQ "НМА"
   THEN DO:
      {setdest.i
          &stream   = "stream fil"
          &cols     = 122
      }
   END.
   ELSE DO:
      {setdest.i
          &stream   = "stream fil"
          &cols     = 175
      }
   END.

   IF work-module EQ "ОС" THEN
      RUN norm-rpt.p ("" , "pirosinv", in-branch-id, in-beg-date, in-end-date).

   ELSE
   IF work-module EQ "НМА" THEN
      RUN norm-rpt.p ("" , "nmainv", in-branch-id, in-beg-date, in-end-date).

   ELSE
   IF CAN-DO("МБП,СКЛАД", work-module) THEN
      RUN norm-rpt.p ("" , "mbpinv", in-branch-id, in-beg-date, in-end-date).
END.
/*----------------------------------------------------------------------------*/
/*  Закрыть олаповские дела                                                   */
/*----------------------------------------------------------------------------*/
IF     remove-mH
   AND VALID-HANDLE(mH) THEN
   DELETE PROCEDURE (mH).
ELSE
IF     NOT remove-mH
   AND VALID-HANDLE(mH) THEN
   RUN Restore IN mH.

RUN DeleteOldDataProtocol IN h_base ("in-dt:").

{intrface.del}