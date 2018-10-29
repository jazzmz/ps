/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2011 ТОО "Банковские информационные системы"
     Filename: pir_inv17.p
      Comment: ОСП -- АКТ инвентаризации расчетов с покупателями, поставщиками и прочими дебиторами и кредиторами
		Версия 1.03 от 15.11.11 правка алгоритма получения полей приложения
		15/11/11 ПИР_ИНВ17_НомераДок -> поле 7. Наименование ...
		16/11/11 справка только по лиц.счета без документов и проводок
		23/11/11 сортировка по последним 8ми символам лицевого счета
		23/11/11 теперь и справка по не нулевым счетам
   Parameters:
         Uses:
      Used by:
      Created: 07.11.2011 SSV
*/
{pirsavelog.p}

{globals.i}

{sh-defs.i}

{tmprecid.def}

{intrface.get strng}
/* {prn-doc.def &with_proc=YES} */

/* {intrface.get seccd}    / * Библиотека для работы с ЦБ. */

{intrface.get tmess}
{parsin.def}
{prn-doc.def &with_proc=YES}

DEFINE VARIABLE summ  AS DECIMAL    NO-UNDO.
DEFINE VARIABLE vDate AS CHARACTER  NO-UNDO.

DEF VAR vBalAcctA AS CHARACTER  NO-UNDO.
DEF VAR vBalAcctP AS CHARACTER  NO-UNDO.

FOR FIRST tmprecid NO-LOCK
  , FIRST acct
      WHERE RecID(acct) = tmprecid.id
	NO-LOCK:

  IF acct.side = "П" THEN DO:
    FIND FIRST code
      WHERE code.class = "Dual-bal-acct"
        AND code.code  = STRING(acct.bal-acct)
      NO-LOCK NO-ERROR.
  END.
  ELSE DO:
    FIND FIRST code
      WHERE code.class = "Dual-bal-acct" 
        AND code.val   = STRING(acct.bal-acct)
      NO-LOCK NO-ERROR.
  END.

  IF AVAIL(code) THEN DO:
    vBalAcctA = code.code.
    vBalAcctP = code.val.
  END.
END.

{get_set.i "ОКПО"}
RUN Insert_TTName ("ОКПО", setting.val).

{get_set2.i "Инвентаризация" "date1"}
RUN Insert_TTName ("date1", setting.val).
def var end-date1 as char.
end-date1 = setting.val.

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
RUN Insert_TTName ("IDateString", term2str(end-date, end-date)).

end-date = date(int(entry(2,end-date1,".")),int(entry(1,end-date1,".")),2000 + int(entry(3,end-date1,"."))).

DEF VAR mCounter AS INT NO-UNDO.
DEF VAR total 	 AS DEC NO-UNDO.
total = 0.
FOR EACH tmprecid NO-LOCK
  , FIRST acct
      WHERE RecID(acct) = tmprecid.id
	AND bal-acct 	= /* 60312 */ INT(vBalAcctP)
      NO-LOCK
      BREAK BY SUBSTR(acct, 14)
      :
      	RUN acct-pos IN h_base (acct.acct,
                            	acct.currency,
                              	end-date - 1,
                              	end-date - 1,
                              	gop-status
                             	).
	IF UPPER(acct.side) = "П"
	  THEN sh-bal = sh-bal * -1.
   	mCounter = mCounter + 1.
	IF sh-bal > 0 THEN DO :
   		RUN Insert_TTName ("d_PP",        STRING(mCounter,">>9")).
   		RUN Insert_TTName ("d_acct_acct", acct.acct).
   		RUN Insert_TTName ("d_acct_name", acct.detail).
   		RUN Insert_TTName ("d_acct_pos",  STRING(sh-bal, "->>>,>>>,>>>,>>9.99")).
		total = total + sh-bal.
	END.
END.
RUN Insert_TTName ("d_it-total", STRING(total, "->>>,>>>,>>>,>>9.99")).

total = 0.
FOR EACH tmprecid NO-LOCK
  , FIRST acct
      WHERE RecID(acct) = tmprecid.id
	AND bal-acct 	= /* 60311 */ INT(vBalAcctA)
      NO-LOCK
      BREAK BY SUBSTR(acct, 14)
      :
      	RUN acct-pos IN h_base (acct.acct,
                            	acct.currency,
                              	end-date - 1,
                              	end-date - 1,
                              	gop-status
                             	).
	IF UPPER(acct.side) = "П"
	  THEN sh-bal = sh-bal * -1.
   	mCounter = mCounter + 1.
	IF sh-bal > 0 THEN DO :
   		RUN Insert_TTName ("c_PP",        STRING(mCounter,">>9")).
   		RUN Insert_TTName ("c_acct_acct", acct.acct).
   		RUN Insert_TTName ("c_acct_name", acct.detail).
   		RUN Insert_TTName ("c_acct_pos",  STRING(sh-bal, "->>>,>>>,>>>,>>9.99")).
		total = total + sh-bal.
	END.
END.
RUN Insert_TTName ("c_it-total", STRING(total, "->>>,>>>,>>>,>>9.99")).

DEF VAR date_start AS DATE NO-UNDO.

/* СПРАВКА К АКТУ */

total = 0.
mCounter = 0.
FOR EACH tmprecid NO-LOCK
  , FIRST acct
      WHERE RecID(acct) = tmprecid.id
      NO-LOCK
/*  , EACH op-entry
      WHERE op-date >= DATE(10/01/10)
	    AND	(    op-entry.acct-db = acct.acct
                  OR op-entry.acct-cr = acct.acct )
	
      NO-LOCK
  , FIRST op OF op-entry
      NO-LOCK
*/
	BREAK BY acct.acct
:
      	RUN acct-pos IN h_base (acct.acct,
                            	acct.currency,
                              	end-date - 1,
                              	end-date - 1,
                              	gop-status
                             	).
  IF UPPER(acct.side) = "П"
    THEN sh-bal = sh-bal * -1.
  IF sh-bal > 0 THEN DO :

   	mCounter = mCounter + 1.
/*	IF FIRST-OF(acct.acct)
	  THEN date_start = op.doc-date.
*/
 	RUN Insert_TTName ("op_pp"	, STRING(mCounter,">>>9")).
   	RUN Insert_TTName ("op_name"	, REPLACE(acct.detail, "\n", "")).

/*   	RUN Insert_TTName ("op_for_what" , ""). 			/ * ВЗЯТЬ ИЗ ДОПРЕКА */
	/* поле 3. За Что = ПИР_ИНВ17_ЗаЧто */
	DEF VAR dr AS CHAR NO-UNDO.
/*        dr = GetXAttrValueEx("op", STRING(op.op), "ПИР_ИНВ17_ЗаЧто", " "). */
        dr = GetXAttrValueEx("acct", acct.acct + "," + acct.currency, "ПИР_ИНВ17_ЗаЧто", "").

   	RUN Insert_TTName ("op_for_what" , dr).

        dr = GetXAttrValueEx("acct", acct.acct + "," + acct.currency, "ПИР_ИНВ17_ДатаНачала", "").
   	RUN Insert_TTName ("date_start"	, dr).

/* было до 15.11.11 >>
...
было до 15.11.11 << ниже приведена замена этого куска */
	RUN acct-pos IN h_base (acct.acct,
                            	acct.currency,
                              	end-date - 1,
                              	end-date - 1,
                              	gop-status
                             	).
   	  RUN Insert_TTName ("amt_debit"	, STRING((IF UPPER(acct.side) <> "П"
							THEN sh-bal
							ELSE 0.00)
							, "->>>,>>>,>>>,>>9.99")).
   	  RUN Insert_TTName ("amt_credit"	, STRING((IF UPPER(acct.side) = "П"
							THEN sh-bal * -1
							ELSE 0.00)
							, "->>>,>>>,>>>,>>9.99")).
/* было до 15.11.11 << конец замененного куска */
	
	/* поле 7. Наименование = ПИР_ИНВ17_Наменование */
/*        dr = GetXAttrValueEx("op", STRING(op.op), "ПИР_ИНВ17_Наменование", REPLACE(op.details, "\n", "")). */
        dr = GetXAttrValueEx("acct", acct.acct + "," + acct.currency, "ПИР_ИНВ17_Наменование", "").
   	RUN Insert_TTName ("op_details"	, dr).	

	/* поле 8. НомераДок = ПИР_ИНВ17_НомераДок */
        dr = GetXAttrValueEx("acct", acct.acct + "," + acct.currency, "ПИР_ИНВ17_НомераДок", "").
   	RUN Insert_TTName ("op_doc_num"	, dr).

/*   	RUN Insert_TTName ("op_date"	, STRING(op.doc-date, "99/99/99")). */
	/* поле 9. ДатаДок = ПИР_ИНВ17_ДатаДок */
        dr = GetXAttrValueEx("acct", acct.acct + "," + acct.currency, "ПИР_ИНВ17_ДатаДок", "").
   	RUN Insert_TTName ("op_date"	, dr).

	total = total + sh-bal.
  END. /* IF sh-bal > 0 THEN DO : */
END.
RUN Insert_TTName ("op_it-total", STRING(total, "->>>,>>>,>>>,>>9.99")).

RUN printvd.p("inv-17r", INPUT TABLE ttnames).

{intrface.del}          /* Выгрузка инструментария. */ 
