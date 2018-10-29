/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2011 ТОО "Банковские информационные системы"
     Filename: pir_inv16.p
      Comment: ОСП -- ИНВЕНТАРИЗАЦИОННАЯ ОПИСЬ
   Parameters:
         Uses:
      Used by:
      Created: 07.11.2011 SSV
*/
{globals.i}
/* {tmprecid.def} */
{intrface.get seccd}    /* Библиотека для работы с ЦБ. */

{intrface.get tmess}
{parsin.def}
{prn-doc.def &with_proc=YES}

DEFINE VARIABLE summ  AS DECIMAL    NO-UNDO.
DEFINE VARIABLE vDate AS CHARACTER  NO-UNDO.

{get_set.i "ОКПО"}
RUN Insert_TTName ("ОКПО", setting.val).

{get_set2.i "Инвентаризация" "date1"}
RUN Insert_TTName ("date1", setting.val).

{get_set2.i "Инвентаризация" "date2"}
RUN Insert_TTName ("date2", setting.val).

{get_set2.i "Инвентаризация" "daterasp"}
RUN Insert_TTName ("daterasp", setting.val).

{get_set2.i "Инвентаризация" "rasp"}
RUN Insert_TTName ("rasp", setting.val).

{get_set2.i "Инвентаризация" "dol1"}
RUN Insert_TTName ("dol1", setting.val).
{get_set2.i "Инвентаризация" "fam1"}
RUN Insert_TTName ("fam1", setting.val).

{get_set2.i "Инвентаризация" "dol2"}
RUN Insert_TTName ("dol2", setting.val).
{get_set2.i "Инвентаризация" "fam2"}
RUN Insert_TTName ("fam2", setting.val).

{get_set2.i "Инвентаризация" "dol3"}
RUN Insert_TTName ("dol3", setting.val).
{get_set2.i "Инвентаризация" "fam3"}
RUN Insert_TTName ("fam3", setting.val).

{get_set2.i "Инвентаризация" "dol4"}
RUN Insert_TTName ("dol4", setting.val).
{get_set2.i "Инвентаризация" "fam4"}
RUN Insert_TTName ("fam4", setting.val).

{get_set2.i "Инвентаризация" "dol5"}
RUN Insert_TTName ("dol5", setting.val).
{get_set2.i "Инвентаризация" "fam5"}
RUN Insert_TTName ("fam5", setting.val).

{get_set2.i "Инвентаризация" "dol6" /* }
RUN Insert_TTName ("dol6", setting.val).
{get_set2.i "Инвентаризация" "fam6" /* }
RUN Insert_TTName ("fam6", setting.val).

{get_set2.i "Комис_ОС" "dol1"}
RUN Insert_TTName ("mdol1", setting.val).
{get_set2.i "Комис_ОС" "fam1"}
RUN Insert_TTName ("mfam1", setting.val).

{get_set2.i "Инвентаризация" "dol5"}
RUN Insert_TTName ("mdol2", setting.val).
{get_set2.i "Инвентаризация" "fam5"}
RUN Insert_TTName ("mfam2", setting.val).

{get_set2.i "Инвентаризация" "dol4"}
RUN Insert_TTName ("mdol3", setting.val).
{get_set2.i "Инвентаризация" "fam4"}
RUN Insert_TTName ("mfam3", setting.val).

{get_set.i "Банк"}
RUN Insert_TTName ("StructPodr", setting.val).

/* >> ввод данных для расчета из ap-inv.p */

/* Переменные, запрашиваемые у пользователя */
DEF VAR mMol        AS CHAR NO-UNDO. /* Список таб. номеров МОЛ   */
DEF VAR mDocNum     AS CHAR NO-UNDO. /* Введенный номер документа */
DEF VAR mPlace      AS CHAR NO-UNDO. /* Введенное местонахождение */

DEF VAR mAbsen      AS LOG  NO-UNDO
   VIEW-AS RADIO-SET
   RADIO-BUTTONS "Учитывать"   , YES,
                 "Не учитывать", NO.

FORM
   WITH FRAME dateframe2 CENTERED ROW 10 OVERLAY 1 COL SIDE-LABELS COLOR MESSAGES
   TITLE "[ ПАРАМЕТРЫ ДЛЯ ПЕЧАТИ ]".


MAIN:
DO ON ERROR UNDO MAIN, LEAVE MAIN:
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
/*                               mPlace = GetCodeName('Место', pick-value). */
                               DISPLAY mPlace.
                            END.
                         END.
                         ELSE IF     LASTKEY     EQ 301
                                 AND FRAME-FIELD EQ 'mMol' THEN
                         DO TRANS:
                            /* Для коррекной работы поля mMol */
                            ASSIGN mMol.

                            RUN a-emptab.p (?, 4).
/*
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
*/
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
END. /* DO ON ERROR UNDO MAIN, LEAVE MAIN: */
/* << ввод данных для расчета из ap-inv.p */

RUN Insert_TTName ("IDoc", mDocNum).
RUN Insert_TTName ("IDate", STRING(end-date, "99/99/9999")).

DEF VAR mCounter AS INT NO-UNDO.
DEF VAR total 	 AS DEC NO-UNDO.
DEF VAR it-summ  AS DEC NO-UNDO.
DEF VAR it-total AS DEC NO-UNDO.
FOR EACH sec-code
	NO-LOCK 
:
    summ = 0.
    FOR EACH acct WHERE 
             acct.acct-cat EQ "d" 
         and acct.currency EQ sec-code.sec-code 
         and acct.side EQ "П" 
         AND acct.filial-id EQ shFilial NO-LOCK,
       LAST acct-qty OF acct NO-LOCK:
     summ = summ - acct-qty.qty.
    END.
    vDate = STRING (sec-code.issue-date).
  IF Summ <> 0.0 THEN DO:
   	mCounter = mCounter + 1.
   	RUN Insert_TTName ("PP",         	STRING(mCounter,">>9") + " ").
   	RUN Insert_TTName ("sec-code_NAME", 	SUBSTRING(REPLACE(sec-code.NAME, "~n", " "), 1, 54)).
   	RUN Insert_TTName ("sec-code_sec-code", STRING(SUBSTRING(sec-code.sec-code, 1, 4), "x(4)")).
	DEF VAR price AS INT NO-UNDO INIT 1.
   	RUN Insert_TTName ("price", 		STRING(price, ">>>>9")).
   	RUN Insert_TTName ("summ", 		STRING(summ,  ">>>>>>>>9.999999")).
	total = price * summ.
   	RUN Insert_TTName ("total", 		STRING(total, ">>>>>>>>9.999999")).
	it-summ  = it-summ  + summ.
	it-total = it-total + total.

  END. /* IF Summ <> 0.0 THEN DO: */
END.
RUN Insert_TTName ("it-summ",  STRING(it-summ , ">>>>>>>>9.999999")).
RUN Insert_TTName ("it-total", STRING(it-total, ">>>>>>>>9.999999")).

RUN printvd.p("inv-16r", INPUT TABLE ttnames).

{intrface.del}          /* Выгрузка инструментария. */ 

