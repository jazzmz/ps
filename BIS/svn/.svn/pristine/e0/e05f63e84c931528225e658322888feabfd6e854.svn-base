{pirsavelog.p}
/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2004 ТОО "Банковские информационные системы"
     Filename: pirree-113i.p
      Comment: '113-И Печать реестра по проведенным операциям'
   Parameters:
         Uses: √
      Used by:
      Created: 15.06.2004 0031886 ABKO
     Modified: 22/06/2004 kolal   Редактирование поля номера реестра. Заявка 32158.
     Modified: 04.07.2004 abko 0032166 + 0032274 + 0032304 + 0032371 + 0032652 .
     Modified: 15/07/2004 kolal   Использование станд. инструментов для получения 
                                  номера реестра. Заявка 32158.
     Modified: 10.08.2004 abko 0034008 исправлена дата реестра.
*/

{globals.i}
{wordwrap.def}
{tmprecid.def}
{intrface.get xclass}
{intrface.get count}

DEFINE INPUT PARAM iParam AS CHAR NO-UNDO.


DEF VAR time1 AS CHAR FORMAT "x(55)" no-undo.
def var ttime1 as integer NO-UNDO.

DEF VAR time2 AS CHAR FORMAT "x(55)" no-undo.
def var ttime2 as integer NO-UNDO.
def var bit as logical NO-UNDO.

def var ttime as integer NO-UNDO.
def var mas as integer extent 10 no-undo.
def var i as integer NO-UNDO.

DEF VAR pokupka AS CHAR no-undo.
DEF VAR prodaga AS CHAR no-undo.


DEFINE VARIABLE mNumDate AS DATE NO-UNDO.
DEF VAR file-name AS CHAR FORMAT "x(55)" no-undo.

DEFINE NEW GLOBAL SHARED TEMP-TABLE tmp-vvod NO-UNDO
   FIELD id AS RECID
   FIELD tt as integer
   INDEX id id
.

FIND FIRST tmprecid NO-LOCK NO-ERROR.
IF NOT AVAIL tmprecid THEN
DO:
   MESSAGE "Не выбраны документы" VIEW-AS ALERT-BOX.
   RETURN.
END.


{pirree-113i.def}

{tmprecid.def &PREF = "tt-"
              &NGSH = YES
}

DEF TEMP-TABLE tt-itog NO-UNDO
   FIELD vidop AS CHAR
   FIELD val5  AS CHAR
   FIELD val7  AS CHAR
   FIELD val11 AS CHAR
   FIELD sum6  AS DEC
   FIELD sum8  AS DEC
   FIELD sum12 AS DEC
   FIELD sum19 AS DEC
   .
before:
DO TRANSACTION:
   /*********/
ASSIGN
   mNaznSchKas = FGetSetting("НазнСчКас","","")
   mScetKomis = FGetSetting("СчетКомис","","")
   mCodNVal = FGetSetting("КодНацВал","","")
.
mSummKon113 = DEC(FGetSetting("СуммаКон113","","")) NO-ERROR.
IF    ERROR-STATUS:ERROR 
   OR mSummKon113 EQ 0 THEN
   mSummKon113 = 600000.

IF NUM-ENTRIES(iParam,";") >= 1 THEN
   ASSIGN
      mParam[1]   = ENTRY(1,iParam,";")
      mBranchMask = mParam[1]
   .
IF NUM-ENTRIES(iParam,";") >= 2 THEN
   ASSIGN
      mParam[2] = ENTRY(2,iParam,";")
      mUserMask = mParam[2]
   .
IF NUM-ENTRIES(iParam,";")   GT 3
   AND TRIM(ENTRY(4,iParam,";")) EQ "ДА" THEN
   mPrintOpNum = TRUE. 


/* сохраним наши документы */
RUN rid-rest.p (OUTPUT TABLE tt-tmprecid).
{empty tmprecid}

 /** определим № реестра *******/
mRid = INTEGER(GetSysConf("user-proc-id")).

FIND FIRST user-proc WHERE RECID(user-proc) EQ mRid
   NO-LOCK NO-ERROR.

IF AVAILABLE user-proc THEN
   mDocNumCode = GetXAttrValueEx("user-proc",
                                 STRING(user-proc.public-number),
                                 "ДокНомер",
                                 "113-И"). /*113-И*/
ELSE
DO:
   MESSAGE "Неправильно запущена процедура"
      VIEW-AS ALERT-BOX ERROR. 
   RETURN.
END.


CreateCounterIfNotExist(mDocNumCode, "Номер реестра по 113-И", 1).

FIND FIRST tt-tmprecid.
FIND FIRST op WHERE RECID(op) EQ tt-tmprecid.id NO-LOCK NO-ERROR.

mNumDate = TODAY.
IF AVAILABLE op THEN
   mNumDate = op.op-date.
mDocNumEdt = GetCounterCurrentValue(mDocNumCode, mNumDate).
mDocNum = mDocNumEdt.

/* запрос подразделений и пользователей */
PAUSE 0.
   UPDATE 
      mBranchMask
      mUserMask
      mDocNum LABEL "Номер реестра     "
   WITH FRAME enter-cond
      WIDTH 60
      SIDE-LABELS
      CENTERED
      ROW 10
      TITLE "[ Выберете подразделение и пользователя ]"
      OVERLAY
   EDITING:
         READKEY.
         IF    FRAME-FIELD EQ "mBranchMask"
           AND LASTKEY = 301 THEN 
         DO:
            RUN browseld.p ("branch",
                            "parent-id",
                            "*",
                            ?,
                            4).
            if keyfunc(lastkey) NE "end-error" then
            DO:
               ASSIGN
                  mBranchMask = pick-value
                  mBranchMask:SCREEN-VALUE = pick-value.
               RELEASE branch.
            END.
         END.
         ELSE IF    FRAME-FIELD EQ "mUserMask"
                AND LASTKEY = 301 THEN 
         DO:
            RUN browseld.p ("_user", /* Класс объекта. */
                            "_userid",     /* Поля для предустановки. */
                            "*" ,      /* Список значений полей. */
                            ?,      /* Поля для блокировки. */
                            6). /* Строка отображения фрейма. */
            if keyfunc(lastkey) NE "end-error" then
            DO:
               ASSIGN
                  mUserMask = pick-value
                  mUserMask:SCREEN-VALUE = pick-value.
               RELEASE _user.
            END.
         END.
         ELSE IF LASTKEY EQ 27 THEN
         DO:
            /* восстановим recid's на наши документы */
            {empty tmprecid}
            
            FOR EACH tt-tmprecid:
               CREATE tmprecid.
               tmprecid.id = tt-tmprecid.id.
            END.
            HIDE FRAME enter-cond.
            RETURN.
         END.
         ELSE
            APPLY LASTKEY.
   END.
   HIDE FRAME enter-cond.

   /* Запоминаем номер реестра - если он не исправлен */
   IF mDocNumEdt = mDocNum THEN
   DO:
      GetCounterNextValue(mDocNumCode, mNumDate).   
   END.

   /* восстановим recid's на наши документы */
   {empty tmprecid}
   
   FOR EACH tt-tmprecid:
      CREATE tmprecid.
      tmprecid.id = tt-tmprecid.id.
   END.
{get-bankname.i} 
ASSIGN
   mNameBank  = cBankName
   mREGN      = FGetSetting("REGN","","")
   mAdres-pch = FGetSetting("Адрес_пч","","")
.
IF mBranchMask EQ "*" THEN
   mAdres-kass = mAdres-pch.
ELSE
   mAdres-kass = GetXAttrValueEx("branch",
                                 STRING(mBranchMask),
                                 "Адрес_юр",
                                 mAdres-pch).
END. /*before*/

def var in-end-date like op.op-date.
def var prefix as char no-undo.
/* определение значения для файла сохранения */
for first tmprecid no-lock,
    first op where RECID(op) EQ tmprecid.id:
in-end-date = op.op-date.
end.
/* составление данныхдля формирования имени файла mDocNum */
if mBranchMask = "00002" then
do:
prefix = "ree" + "_" + userid + "_" + string(mDocNum) + "_p".
pokupka = "НалПокПос".
prodaga = "НалПрПос".
end.
else
do:
prefix = "ree" + "_" + userid + "_" + string(mDocNum).
pokupka = "НалПок".
prodaga = "НалПр".
end.

/* расчет количества изменений курсов покупки продажи наличной валюты НалПок НалПр */

ttime1 = 1.
ttime2 = 1.
i = 1.
bit = yes.
/* определение проведения первой проводки пользователем*/
for each tmprecid no-lock,
  FIRST op WHERE RECID(op) EQ tmprecid.id no-lock,
  FIRST history where history.file-name eq "op"
       AND history.field-ref EQ STRING(op.op)
       and history.modify eq "w"
       NO-LOCK
  BREAK BY history.modif-time    
  :

    IF AVAIL history and bit = yes THEN 
      do:
         ttime2 = history.modif-time.
         time2 = string(history.modif-time,"HH:MM").
         bit = no.
      end.
    create tmp-vvod.  
    tmp-vvod.id = tmprecid.id.
    tmp-vvod.tt = history.modif-time.
/* message ""  time2 op.doc-num bit tmp-vvod.tt. pause.      */
end.

/* первый реестр должен начаться больше проведение первой проводки */
mas[1] = ttime2.

/* находим сколько раз менялся курс в течении дня */      
for each history where history.file-name eq "instr-rate"
  and entry(4,history.field-ref) eq string(op.op-date)
  and (entry(2,history.field-ref) eq pokupka or
  entry(2,history.field-ref) eq prodaga)
  by history.modif-time.

	if avail history then 
    do: 

     if history.modif-time GT ttime1  and  
        history.modif-time GT ttime2 
     then 
      do:
        ttime1 = history.modif-time.
        time1 = string(history.modif-time,"HH:MM").
/* если проводок не было в этом периоде тогда реестр не создаем */         
         find first tmp-vvod where tmp-vvod.tt GE mas[i]
												     and tmp-vvod.tt LT history.modif-time
                  NO-LOCK NO-ERROR.
             if avail tmp-vvod then
             do:
              i = i + 1.
              mas[i] = ttime1.
   
/* message "Время" string(ttime2,"HH:MM") string(ttime1,"HH:MM") i  string(mas[1],"HH:MM") string(mas[2],"HH:MM") string(mas[3],"HH:MM") string(mas[4],"HH:MM").  pause. */
	           
	           end.
      end.
    end.
end.

/* если курс не  менялся все будет в одном реестре */
     if not avail history and ttime1=1 then 
     do:     
     i = i + 1.
     mas[i] = 99999.
/*   message "test"  i  mas[1] mas[2].  pause.  */
     end.
     
mas [i + 1] = 99999.

/* message "Время"  i  mas[1] mas[2] mas[3].  pause. */

/* конец расчета */

{pirraproc.def}
{pirraproc.i &arch_file_name = ".txt" &prefix=yes}

{setdest.i &cols=242 &filename = arch_file_name}

FOR FIRST tmprecid NO-LOCK,
    FIRST op WHERE RECID(op) EQ tmprecid.id:

   DISP "Наименование уполномоченного банка                                 "
        mNameBank VIEW-AS EDITOR SIZE 50 BY 1 NO-LABEL
        "  (филиала уполномоченного банка)                                  " SKIP
        "Регистрационный номер уполномоченного банка                        "
        mREGN VIEW-AS EDITOR SIZE 35 BY 1 NO-LABEL         SKIP
        "/порядковый номер филиала уполномоченного банка                    " SKIP
        "Адрес уполномоченного банка                                        "
        mAdres-pch VIEW-AS EDITOR SIZE 50 BY 1 NO-LABEL    SKIP
        "(филиала уполномоченного банка)                                    " SKIP
        "Адрес операционной кассы                                           "
        mAdres-kass VIEW-AS EDITOR SIZE 50 BY 1 NO-LABEL   SKIP
        "Дата заполнения Реестра                                            "
        op.op-date  NO-LABEL                              SKIP
        "                                                                   День Месяц Год " SKIP
        "Порядковый номер Реестра в течение рабочего дня операционной кассы "
        STRING(mDocNum) NO-LABEL                           SKIP(1)
   WITH FRAME mA1 SIZE 160 BY 10.
END.

PUT UNFORMATTED 
      SPACE(50) "РЕЕСТР ОПЕРАЦИЙ С НАЛИЧНОЙ ВАЛЮТОЙ И ЧЕКАМИ" SKIP(1).
PUT UNFORMATTED
"╔══════╦══════╦════╦════════╦═════════════════════════════════════════════════╦═════╦══════════════════════════════════╦══════════════════════╦═══╦═════╦════════════════════╦════════════════════╦════════════════════════════════╦════════════╗" SKIP
"║Поряд-║Время ║Код ║  Курс  ║            Наличные денежные средства           ║ Пла-║Принято (выдано) кассовым работни-║     Номер счета      ║До-║Код  ║ Ф.И.О. физического ║ Документ, удостове-║ Адрес места жительства (место  ║В т.ч.сумма ║" SKIP
"║ковый ║совер-║вида║(кросс) ╠════════════════════════╦════════════════════════╣ теж-║ком чеков (в том числе дорожных   ║                      ║ве-║стра-║         лица       ║   ряющий личность  ║ пребывания)                    ║комиссии по ║" SKIP
"║номер ║шения ║опе-║-курс   ║       Принято          ║         Выдано         ║ ная ║чеков), номинальная  стоимость ко-║                      ║рен║ны   ║                    ║                    ║                                ║переводу    ║" SKIP
"║опера-║опера-║ра- ║иност-  ║  кассовым работником   ║  кассовым работником   ║ кар-║торых указана в иностранной валюте║                      ║но-║граж-║                    ║                    ║                                ║без открыт. ║" SKIP
"║ ции  ║ции   ║ции ║ранной  ╠═════╦══════════════════╬═════╦══════════════════╣ та  ╠═════════╦═════╦══════════════════╣                      ║сть║данс-║                    ║                    ║                                ║счета       ║" SKIP
"║      ║      ║    ║валюты  ║ код ║      сумма       ║ код ║      сумма       ║     ║ Коли-   ║ код ║      сумма       ║                      ║   ║тва  ║                    ║                    ║                                ║(код вида   ║" SKIP
"║      ║      ║    ║        ║валю-║                  ║валю-║                  ║     ║ чество  ║валю-║                  ║                      ║   ║физ. ║                    ║                    ║                                ║опер. 55)   ║" SKIP
"║      ║      ║    ║        ║ ты  ║                  ║ ты  ║                  ║     ║  чеков  ║ ты  ║                  ║                      ║   ║лица ║                    ║                    ║                                ║            ║" SKIP
"╠══════╬══════╬════╬════════╬═════╬══════════════════╬═════╬══════════════════╬═════╬═════════╬═════╬══════════════════╬══════════════════════╬═══╬═════╬════════════════════╬════════════════════╬════════════════════════════════╬════════════╣" SKIP
"║  1   ║  2   ║ 3  ║    4   ║  5  ║         6        ║  7  ║         8        ║  9  ║   10    ║ 11  ║       12         ║          13          ║14 ║  15 ║          16        ║         17         ║              18                ║      19    ║" SKIP
.
{justamin}
ASSIGN
   mDocNumEdt = mDocNum
   mDocNum    = 1
.

FOR EACH tmprecid NO-LOCK,

   FIRST op WHERE RECID(op) EQ tmprecid.id
              AND CAN-DO(mUserMask,op.user-id)
         NO-LOCK,
         
   FIRST history WHERE history.file-name EQ "op" 
         AND history.field-ref EQ STRING(op.op)	    
         AND history.modify    EQ "W"
         NO-LOCK,
         
   EACH op-entry OF op NO-LOCK WHERE NOT CAN-DO(mScetKomis,op-entry.acct-cr)
				 AND NOT CAN-DO(mScetKomis,op-entry.acct-db)
   BREAK BY history.modif-time
:

/*           FIND LAST history WHERE history.file-name EQ "op"
                      AND history.field-ref EQ STRING(op.op)
		                  AND history.modify    EQ "C" NO-LOCK NO-ERROR.*/
           IF AVAIL history 
           THEN ttime = history.modif-time.

/*  message "oper" string(ttime,"HH:MM:SS") string(mas[mDocNumEdt],"HH:MM:SS") string(mas[mDocNumEdt + 1], "HH:MM:SS") . pause. */
if ttime GE mas[mDocNumEdt] AND ttime LT mas[mDocNumEdt + 1] then
DO:

   {pirree-113i.sel}
   IF NOT (   CAN-DO(mBranchMask,acct-cr.branch-id)
           OR CAN-DO(mBranchMask,acct-db.branch-id)
           ) THEN NEXT.

/* 
Каждая строка отчета содержит информацию об отдельном документе и (полу)проводках, 
   связанных с ним. Если в документе есть две полупроводки, то анализируются обе. 
   Если их более двух, то анализируются первые проводки, в которых заполнены поля 
   дебет и кредит.
*/
   PUT UNFORMATTED
"╠══════╬══════╬════╬════════╬═════╬══════════════════╬═════╬══════════════════╬═════╬═════════╬═════╬══════════════════╬══════════════════════╬═══╬═════╬════════════════════╬════════════════════╬════════════════════════════════╬════════════╣" SKIP
   .

   ASSIGN
      m5 = ""
      m6 = 0
      m7 = ""
      m8 = 0
      m10 = 0
      m11 = ""
      m12 = 0
      m13 = ""
      m15 = ""
      mFIO[1] = ""
      m17[1] = ""
      mADR[1] = ""
      mDocId = ""
      m19 = 0
   .
   IF(   CAN-DO(mNaznSchKas, acct-db.contract)
      AND NOT CAN-DO("20203*",acct-db.acct)) THEN
   DO:
      IF(acct-db.currency EQ "") THEN 
         ASSIGN m5 = mCodNVal
                m6 = op-entry1.amt-rub
         .
      ELSE
         ASSIGN m5 = acct-db.currency
                m6 = op-entry1.amt-cur
         .
   END.
   IF(    CAN-DO(mNaznSchKas, acct-cr.contract)
      AND NOT CAN-DO("20203*",acct-cr.acct)) THEN 
   DO:
      IF(acct-cr.currency EQ "") THEN 
         ASSIGN m7 = mCodNVal
                m8 = op-entry2.amt-rub
         .
      ELSE
         ASSIGN m7 = acct-cr.currency
                m8 = op-entry2.amt-cur
         .
   END.
   IF (acct-db.acct BEGINS "20203") THEN
   DO:
      m10 = op-entry1.qty.
      IF(acct-db.currency EQ "") THEN 
         ASSIGN m11 = mCodNVal
                m12 = op-entry1.amt-rub
         .
      ELSE
         ASSIGN m11 = acct-db.currency
                m12 = op-entry1.amt-cur
         .
   END.
   IF (acct-cr.acct BEGINS "20203") THEN
   DO:
      m10 = op-entry2.qty.
      IF(acct-cr.currency EQ "") THEN 
         ASSIGN m11 = mCodNVal
                m12 = op-entry2.amt-rub
         .
      ELSE
         ASSIGN m11 = acct-cr.currency
                m12 = op-entry2.amt-cur
         .
   END.

   IF     NOT CAN-DO(mNaznSchKas, acct-cr.contract)
      AND acct-cr.cust-cat EQ "Ч" THEN
      if (acct-cr.acct begins "409") 
      then 
      DO:
      m13 = "". 
      find first op-entry1 where op-entry1.op-transaction eq op-entry.op-transaction
                            and  op-entry1.acct-db eq op-entry.acct-cr
                            and  op-entry1.acct-cr begins "70" no-lock no-error.
      IF avail op-entry1 then m19 = op-entry1.amt-cur.
      END. 
      else
      m13  = acct-cr.acct.
   ELSE IF  NOT CAN-DO(mNaznSchKas, acct-db.contract)
           AND acct-db.cust-cat EQ "Ч" THEN
      if (acct-db.acct begins "409") 
      then 
      DO:
      m13 = "". 
      END.
      else   
      m13 = acct-db.acct.

   IF mVidOpNalV NE "" THEN
    DO:
      IF acct-db.cust-cat EQ "ч" THEN
         FIND FIRST person WHERE person.person-id EQ acct-db.cust-id NO-LOCK NO-ERROR.
      ELSE IF acct-cr.cust-cat EQ "ч" THEN
         FIND FIRST person WHERE person.person-id EQ acct-cr.cust-id NO-LOCK NO-ERROR.
      IF AVAIL person THEN
      DO:
          FIND FIRST country WHERE person.country-id EQ country.country-id NO-LOCK NO-ERROR.
         ASSIGN
            m15 = person.country-id
         .
         RELEASE person.
      END.
      ELSE DO:
         m15 = GetXAttrValueEx("op",
                               STRING(op-entry.op),
                               "country-rec",
                               "").
         IF m15 EQ "" THEN
            m15 = GetXAttrValueEx("op",
                                  STRING(op-entry.op),
                                  "country-send",
                                  "").
      END.
      IF  m15 NE "" THEN
         FIND FIRST country WHERE country.country-id EQ m15 NO-LOCK NO-ERROR.
         IF AVAIL country THEN
         m15 = STRING(country.country-alt-id,"999").
   END.

  /* IF mSummKon113 LE op-entry.amt-rub THEN
   DO: */
      IF acct-db.cust-cat EQ "ч" THEN
         FIND FIRST person WHERE person.person-id EQ acct-db.cust-id NO-LOCK NO-ERROR.
      ELSE IF acct-cr.cust-cat EQ "ч" THEN
         FIND FIRST person WHERE person.person-id EQ acct-cr.cust-id NO-LOCK NO-ERROR.
      IF AVAIL person THEN
      DO:
          FIND FIRST country WHERE person.country-id EQ country.country-id NO-LOCK NO-ERROR.
         ASSIGN
            m15 = person.country-id
            mFIO[1] = if mSummKon113 LE op-entry.amt-rub then person.name-last + " " + person.first-names + " " + STRING(person.birthday,"99.99.9999")
            																						 else person.name-last + " " + person.first-names
            m17[1]  = person.document
            mDocId  = person.document-id
            mADR[1] = person.address[1] + " " + person.address[2]
         .
         RELEASE person.
      END.
  /*    ELSE 
      	DO: */
         IF GetXAttrValueEx("op",STRING(op-entry.op),"country-rec","") NE  "" THEN 
         		m15 = GetXAttrValueEx("op",
                               STRING(op-entry.op),
                               "country-rec",
                               "").
         IF m15 EQ "" THEN
            m15 = GetXAttrValueEx("op",
                                  STRING(op-entry.op),
                                  "country-send",
                                  "").
      /*	END.*/
      mFIO[1] = GetXAttrValueEx("op",
                               STRING(op-entry.op),
                               "ФИО",
                               mFIO[1]).
      mDocId = GetXAttrValueEx("op",
                               STRING(op.op),
                               "document-id",
                                mDocId).
      m17[1] = GetXAttrValueEx("op",
                               STRING(op-entry.op),
                               "Докум",
                               m17[1]).
      mADR[1] = GetXAttrValueEx("op",
                               STRING(op-entry.op),
                               "Адрес",
                               mADR[1]).
      IF  m15 NE "" THEN
         FIND FIRST country WHERE country.country-id EQ m15 NO-LOCK NO-ERROR.
         IF AVAIL country THEN
         m15 = STRING(country.country-alt-id).
 /*  END. */
   msprate    = DECIMAL(GetXAttrValueEx("op",
                                STRING(op-entry.op),
                                "sprate",
                                "0")) NO-ERROR.
   mDover     = GetXAttrValueEx("op",
                                STRING(op-entry.op),
                                "Довер",
                                "Нет").
   mDover = IF mDover NE "Нет"
            THEN "X"
            ELSE " ".
	    
   m9 = IF mVidOpNalV EQ "16" OR mVidOpNalV EQ "17"
           THEN "X"
           ELSE " ".	    

   
/* Условие проставлено выборка по последнему изменению документа history */
 /*  FIND LAST history WHERE history.file-name EQ "op" 
                       AND history.field-ref EQ STRING(op.op)
		*/       /* AND ((string(entry(2,history.field-value)) EQ "ФКС")
		       or (string(entry(4,history.field-value)) EQ "ФКС")
	               or (string(entry(2,history.field-value)) EQ "√")
		       or (string(entry(4,history.field-value)) EQ "√")
		       or (string(entry(2,history.field-value)) EQ "К")
		       or (string(entry(4,history.field-value)) EQ "К")
		       or (string(entry(2,history.field-value)) EQ "В")
		       or (string(entry(4,history.field-value)) EQ "В")) */
		       /* AND history.modify    EQ "W" NO-LOCK NO-ERROR. */
   IF AVAIL history
   THEN mOpTime = STRING(history.modif-time,"HH:MM").
   ELSE mOpTime = "".
   
/*   IF op.user-id = "MARKOVA" then
   do:
     FIND LAST history WHERE history.file-name EQ "op"
                        AND history.field-ref EQ STRING(op.op)
			AND history.modify    EQ "C" NO-LOCK NO-ERROR.
     IF AVAIL history 
     THEN mOpTime = STRING(history.modif-time,"HH:MM").
     ELSE mOpTime = "".
   end.
*/ 
   m17[1] = mDocId + " " + m17[1].

   {wordwrap.i &s=mFIO &l=18 &n=10}
   {wordwrap.i &s=mADR &l=30 &n=10}
   {wordwrap.i &s=m17  &l=18 &n=10}

   IF mPrintOpNum THEN
      PUT UNFORMATTED
"║"   STRING(op.doc-num, "x(6)")
      .
   ELSE
      PUT UNFORMATTED
"║"   STRING(mDocNum, ">>>>>9")
      .
   PUT UNFORMATTED
"║ " STRING(mOpTime, "x(5)")
"║ "   STRING(mVidOpNalV, "x(2)")       " "
   .
IF msprate GT 0 THEN 
   PUT UNFORMATTED
"║ "   STRING(msprate, ">9.9999")    ""
   .
ELSE
   PUT UNFORMATTED
"║        "
   .
   PUT UNFORMATTED
"║ "  STRING(m5, "x(3)")              " "
"║ "  STRING(m6, ">,>>>,>>>,>>9.99")  " "
"║ "  STRING(m7, "x(3)")              " "
"║ "  STRING(m8, ">,>>>,>>>,>>9.99")  " "
"║  " STRING(m9, "x(1)")              "  " 
"║"   STRING(m10, ">>>>,>>9")         " "
"║ "  STRING(m11, "x(3)")             " "
"║ "  STRING(m12, ">,>>>,>>>,>>9.99") " "
"║ "  STRING(m13, "x(20)")            " "
"║ " STRING(mDover, "x(1)")          " " 
"║ " STRING(m15, "x(3)")             " "
"║ "  STRING(mFIO[1], "x(18)")        " "
"║ "  STRING(m17[1], "x(18)")         " "
"║ "  STRING(mADR[1], "x(30)")        " "
"║ "  STRING(m19, ">>>,>>9.99")       " "
"║"   SKIP
   .

   DO mI = 2 to 10:
      IF    mADR[mI] NE "" 
         OR mFIO[mI] NE ""
         OR m17[mI]  NE "" THEN 
   PUT UNFORMATTED
"║      "
"║      "
"║    "
"║        "
"║     "
"║                  "
"║     "
"║                  "
"║     "
"║         "
"║     "
"║                  "
"║                      "
"║   "
"║     "
"║ "   STRING(mFIO[mI], "x(18)") " "
"║ "   STRING(m17[mI], "x(18)")  " "
"║ "   STRING(mADR[mI], "x(30)") " "
"║            "
"║"    SKIP
   .
         ELSE LEAVE.
   END.

/*
1    - номер документа op.doc-num
2	- время ввода документа в систему.
3	- дополнительный реквизит документа "ВидОпНалВ".
4	- значение дополнительного реквизита "sprate".
5	- код получаемой валюты. Код валюты из проводки или полупроводки, в которой счет
       с назначением из настроечного параметра"НазнСчКас" стоит по дебету,
       за исключением счетов 20203*.
6	- сумма получаемой валюты. Сумма в валюте поля 5 из проводки или полупроводки, 
       в которой счет с назначением из настроечного параметра"НазнСчКас" стоит по дебету,
       за исключением счетов 20203*.
7	- код выдаваемой валюты. Код валюты из проводки или полупроводки, в которой счет
       с назначением из настроечного параметра"НазнСчКас" стоит по кредиту,
       за исключением счетов 20203*.
8	- сумма выдаваемой валюты. Сумма в валюте поля 7 из проводки или полупроводки,
       в которой счет с назначением из настроечного параметра"НазнСчКас" стоит по кредиту,
       за исключением счетов 20203*.
9	- поле не заполняется.
10	- количество поле op-entry.qty из проводки у которой счет 20203* стоит по дебету
       или по кредиту.
11	- код валюты из проводки у которой счет 20203* стоит по дебету или по кредиту.
12	- сумма в валюте из поля 11 проводки у которой счет 20203* стоит по дебету или по кредиту.
13	- если счет кассы корреспондирует в документе со счетом, который не является счетом кассы,
       то выводится этот корреспондирующий счет. Если оба счета являются счетами кассы,
       то в поле ничего не выводится.
14	- значение дополнительного реквизита "Довер".
15	- если счет кассы корреспондирует в документе со счетом, клиентом которого является 
       физическое лицо, то это поле person.country-id клиента, связанного со счетом.
       Иначе - значение заполненного дополнительного реквизита "country-rec" или "country-send".
16	- если счет кассы корреспондирует в документе со счетом, клиентом которого является 
       физическое лицо, то это ФИО данного клиента. Иначе значение дополнительного реквизита "ФИО".
17	- если счет кассы корреспондирует в документе со счетом, клиентом которого является
       физическое лицо, то это тип и номер документа данного клиента.
       Иначе значение дополнительного реквизита "Докум".
18	- если счет кассы корреспондирует в документе со счетом, клиентом которого является
       физическое лицо, то это адрес данного клиента.
       Иначе значение дополнительного реквизита "Адрес".
*/

   RUN put-itog(mVidOpNalV).
   RUN put-itog("**").
   UpdateSigns("opb", STRING(op.op), "НомерРеестра", STRING(mDocNumEdt), ?).
   IF mPrintOpNum THEN
      UpdateSigns("opb", STRING(op.op), "НомРеестр", op.doc-num, ?).
   ELSE
      UpdateSigns("opb", STRING(op.op), "НомРеестр", STRING(mDocNum), ?).
   mDocNum = mDocNum + 1.
END.
end.

FOR EACH tt-itog:
   IF tt-itog.vidop EQ "**" THEN NEXT.
   PUT UNFORMATTED
"╠══════╬══════╬════╬════════╬═════╬══════════════════╬═════╬══════════════════╬═════╬═════════╬═════╬══════════════════╬══════════════════════╬═══╬═════╬════════════════════╬════════════════════╬════════════════════════════════╬════════════╣" SKIP
"║ ИТОГИ║      "
"║ "   STRING(tt-itog.vidop, "X(2)") " "
"║        "
"║ "   STRING(tt-itog.val5, "x(3)")             " "
"║ "   STRING(tt-itog.sum6, ">,>>>,>>>,>>9.99") " "
"║ "   STRING(tt-itog.val7, "x(3)")             " "
"║ "   STRING(tt-itog.sum8, ">,>>>,>>>,>>9.99") " "
"║     "
"║         "
"║ "   STRING(tt-itog.val11, "x(3)")            " "
"║ "   STRING(tt-itog.sum12, ">,>>>,>>>,>>9.99") " "
"║ "   FILL(" " ,21)
"║   " 
"║     "
"║ "   FILL(" " ,19)
"║ "   FILL(" " ,19)
"║ "   FILL(" " ,31)
"║ "   STRING(tt-itog.sum19, ">>>,>>9.99") " "
"║"    SKIP
   .
END.
   PUT UNFORMATTED
"╚══════╩══════╩════╩════════╩═════╩══════════════════╩═════╩══════════════════╩═════╩═════════╩═════╩══════════════════╩══════════════════════╩═══╩═════╩════════════════════╩════════════════════╩════════════════════════════════╩════════════╝"
SKIP(1)
.

IF NUM-ENTRIES(iParam,";")   GT 2 
   AND TRIM(ENTRY(3,iParam,";")) EQ "ДА"
   THEN DO:

PUT UNFORMATTED
"            СВОДНЫЕ ИТОГИ" SKIP
"╔══════╦══════╦═════╦════════════╦═════╦══════════════════╦═════╦══════════════════╦═════╦═════════╦═════╦══════════════════╦══════════════════════╦══════╦═══════╦══════════════════════╦════════════════════╦════════════════════════════════╗" SKIP
"║  1   ║  2   ║  3  ║      4     ║  5  ║        6         ║  7  ║       8          ║  9  ║    10   ║ 11  ║        12        ║          13          ║  14  ║   15  ║          16          ║         17         ║              18                ║" SKIP
.
FOR EACH tt-itog WHERE tt-itog.vidop EQ "**":
   PUT UNFORMATTED
"╠══════╬══════╬═════╬════════════╬═════╬══════════════════╬═════╬══════════════════╬═════╬═════════╬═════╬══════════════════╬══════════════════════╬══════╬═══════╬══════════════════════╬════════════════════╬════════════════════════════════╣" SKIP
"║ ИТОГИ║      "
"║ все "
"║            "
"║ "   STRING(tt-itog.val5, "x(3)")             " "
"║ "   STRING(tt-itog.sum6, ">,>>>,>>>,>>9.99") " "
"║ "   STRING(tt-itog.val7, "x(3)")             " "
"║ "   STRING(tt-itog.sum8, ">,>>>,>>>,>>9.99") " "
"║     "
"║         "
"║ "   STRING(tt-itog.val11, "x(3)")            " "
"║ "   STRING(tt-itog.sum12, ">,>>>,>>>,>>9.99") " "
"║ "   FILL(" " ,21)
"║      " 
"║       "
"║ "   FILL(" " ,21)
"║ "   FILL(" " ,19)
"║ "   FILL(" " ,31)
"║"    SKIP
   .
END.
   PUT UNFORMATTED
"╚══════╩══════╩═════╩════════════╩═════╩══════════════════╩═════╩══════════════════╩═════╩═════════╩═════╩══════════════════╩══════════════════════╩══════╩═══════╩══════════════════════╩════════════════════╩════════════════════════════════╝"
SKIP(1)
.
END.
put unformatted "Кассовый работник _________________ _______________" skip.
/* {signatur.i &user-only=yes} */
{preview.i &filename=arch_file_name}
  
PROCEDURE put-itog:

   DEFINE INPUT PARAMETER iVidOpNalV AS CHAR.
   
   FIND FIRST tt-itog WHERE tt-itog.vidop EQ iVidOpNalV
                        AND tt-itog.val5  EQ m5
                        AND tt-itog.val7  EQ m7
                        AND tt-itog.val11 EQ m11 NO-ERROR.
   IF NOT AVAIL tt-itog THEN
   DO:
      CREATE tt-itog.
      ASSIGN
         tt-itog.vidop = iVidOpNalV
         tt-itog.val5  = m5
         tt-itog.val7  = m7
         tt-itog.val11 = m11
      .
   END.
   ASSIGN 
      tt-itog.sum6 = tt-itog.sum6 + m6
      tt-itog.sum8 = tt-itog.sum8 + m8
      tt-itog.sum12 = tt-itog.sum12 + m12
      tt-itog.sum19 = tt-itog.sum19 + m19
   . 
   RELEASE tt-itog.
END PROCEDURE.
  
