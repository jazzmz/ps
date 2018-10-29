/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-1999 ТОО "Банковские информационные системы"
     Filename: g_buysel.p
      Comment: Процедура покупки/продажи валюты клиентом при создании (поиска) для него
               карточки клиента и счетов
   Parameters:
         Uses:
      Used by:
      Created: 04/08/99 14:29 Sema from g_crdep3.p и g-comp1.p
     Modified: 20.06.2002 13:33 SEMA     по заявке 0006415 убрано использование функции СчКлИзПроц - теперь она
                                         вызывается только из библиотеки
     Modified: 12.02.2003 16:28 SEMA     по заявке 0013622 Убрана метка транзакции и изменены точки отката транзакции на
                                         корректные
     Modified: 14.04.2003 20:08 DEMA     (0014196) Добавлена процедура расчета и
                                         заполнения доп. реквизитов parssign.p
     Modified: 29.04.2003 15:35 KAVI     форматирование текста
     Modified: 29.04.2003 15:40 KAVI     сделано условие на наличие в проводках
                                         обязательных ДР и обеспечен их ввод.
                                         при отказе ввода этих ДР, ввод проводок
                                         отменяется (поднято из ВТБ)
     Modified: 05.05.2003 13:51 KAVI     Исправлено использование UNDO.
     Modified: 16/07/2003 Om  Ошибка:
                           - Устранено замечание компиляции,
                           - Откатывается не только один документ,
                             а и карточка клиента.
     Modified: 06.08.2003 18:01 DEMA     (0014196) Убран лишний цикл по wop
     Modified: 18.08.2005 12:29 SHIB     
     Modified: 14.09.2006 17:15 Om       <comment>
     Modified: 28/02/2007 kraw (0043996) Формы ввода документов
     Modified: 27/08/2007 kraw (0080060) pers-ed --> formld
     Modified: 23/05/2008 kraw (0049823) вызов процедуры из ДР RunAfterCreate на op-template
*/

&SCOPED-DEFINE BYrole  YES.
&SCOPED-DEFINE Dotacct YES.
&SCOPED-DEFINE DoOp    YES.
&GLOB g-op-cr-prev-op-entry RUN CrConstRecip.

DEFINE INPUT PARAMETER in-op-date LIKE op.op-date.
DEFINE INPUT PARAMETER oprid      AS   RECID.

DEF VAR beg-templ       AS CHAR  INITIAL '0'.
DEF VAR fl              AS INT64.

DEF VAR main-first      AS LOG    NO-UNDO.
DEF VAR num-cr-acct     AS INT64    NO-UNDO.
DEF VAR return-find-str AS CHAR   NO-UNDO.
DEF VAR lst-tmpl-op     AS CHAR   NO-UNDO.
DEF VAR cr_loanh        AS HANDLE NO-UNDO.
DEF VAR int-delay       AS CHAR   NO-UNDO FORMAT 'x(40)'.
DEF VAR nn              AS INT64    NO-UNDO.
DEF VAR no-key          AS CHAR   NO-UNDO.
DEF VAR my-key          AS CHAR   NO-UNDO.
DEF VAR KEY             AS INT64    NO-UNDO.
DEF VAR result          AS INT64    NO-UNDO.
DEF VAR need-valdate    AS LOG    NO-UNDO FORMAT "Дата валютирования/".
DEF VAR fmt             AS CHAR   NO-UNDO.
DEF VAR fler            AS LOG    NO-UNDO.
DEF VAR loan_h          AS HANDLE NO-UNDO.
DEF VAR hProc           AS HANDLE NO-UNDO.
DEF VAR cod-ost         AS CHAR   NO-UNDO.
DEF VAR t-details       AS CHAR   NO-UNDO.
DEF VAR cur-n           LIKE currency.currency     NO-UNDO.
DEF VAR vclass          LIKE class.class-code      NO-UNDO.
DEF VAR vacct-cat       LIKE acct.acct-cat         NO-UNDO.
DEF VAR tcur-db         LIKE op-templ.currency     NO-UNDO.
DEF VAR tcur-cr         LIKE op-templ.currency     NO-UNDO.
DEF VAR noe             LIKE op-entry.op-entry     NO-UNDO.
DEF VAR dval            LIKE op-entry.value-date   NO-UNDO.
DEF VAR vmfo            AS CHARACTER NO-UNDO.
DEF VAR vcorr-acct            AS CHARACTER NO-UNDO.
DEFINE VARIABLE mMethodAfter AS CHARACTER NO-UNDO.

DEF NEW GLOBAL SHARED STREAM err.
DEF NEW SHARED VAR l-summ     AS DEC   NO-UNDO
                                       FORMAT "zzz,zzz,zzz,zz9.99"
                                       LABEL "Сумма".

FIND op-kind WHERE
      RECID(op-kind) EQ oprid NO-LOCK NO-ERROR.
                        /* (0067442) dpsproc.def должен быть объявлен здесь.
                        ** Иначе SHARED переменные принимают неверные знаяения. */
{dpsproc.def}
{g-defs.i}
{crdps.def}
{chkacces.i}
{def-wf.i new}
{defframe.i new}
{globals.i}
{intrface.get tmess}
{intrface.get lnbh}
{intrface.get xclass}
{intrface.get cust}
{intrface.get db2l}
{form.def}

DEF BUFFER xwop   FOR wop.
DEF BUFFER xloan  FOR loan.

ASSIGN
   no-key = FGetSetting("КлючаНет", ?, ?)
   my-key = FGetSetting("Ключ", ?, ?)
.
/* Для парсера в содержании */
{details.def}
{frmfield.fun &DefProcCreateFrmFields = YES}
/* Для парсера в содержании */
cur-n = FGetSetting("КодНацВал", ?, "{&in-NC-Code}").

{plibinit.i
   &TransParsLibs = "g_buylib.p"}

CR_LOAN:
DO TRANSACTION 
ON ENDKEY UNDO CR_LOAN, LEAVE CR_LOAN 
ON ERROR  UNDO CR_LOAN, LEAVE CR_LOAN
WITH FRAME edit-frame:
   {justasec}
   {optr.i &DoBefore=YES}

   RUN formld.p ("person",
                 "0",
                 "YES",
                 {&MOD_ADD},
                4 
                 ) NO-ERROR.

   pick-value = IF     pick-value NE ? 
                   AND NOT ERROR-STATUS :ERROR
                   AND TO-ROWID(ENTRY(1,pick-value,CHR(1))) NE ? THEN
                   STRING(Rowid2Recid("person",TO-ROWID(ENTRY(1,pick-value,CHR(1))))) 
                ELSE ?.

   IF pick-value NE ? THEN
      FIND FIRST person WHERE
           RECID(person) EQ INT64(pick-value) NO-LOCK NO-ERROR.

   IF NOT AVAILABLE person THEN
      UNDO CR_LOAN, LEAVE CR_LOAN.
   ELSE
   DO:
      IF AVAILABLE loan THEN
         loan.cust-id = person.person-id.
      RUN SetSysConf IN h_base("tmp-person-id",STRING(person.person-id)).
      RUN SetSysConf IN h_base("tmp-cust-cat", "Ч").
   END.
   /* Создание счетов */
   RUN g_buyacc.p (in-op-date,RECID(op-kind),RECID(loan),OUTPUT fl,INPUT-OUTPUT
      l-summ) .
   IF fl NE 0 THEN
      UNDO cr_loan, LEAVE cr_loan.
   lst-tmpl-op = "".
   in-templ = GetOpTmplByTmpCl(op-kind.op-kind,'doc-templ',beg-templ) .

   DO WHILE in-templ NE ? :
      {additem.i lst-tmpl-op STRING(in-templ)}
      {additem.i beg-templ   STRING(in-templ)}
      in-templ = GetOpTmplByTmpCl(op-kind.op-kind,'doc-templ',beg-templ) .
   END.

   GEN:
   DO WITH FRAME opreq 
      ON ENDKEY UNDO cr_loan, LEAVE cr_loan
      ON ERROR  UNDO cr_loan, LEAVE cr_loan:
      IF RETRY THEN
         UNDO cr_loan, LEAVE cr_loan.


      {g-currv1.i &OFbase="/*"}

      DebugParser = INT64(GetXattrValueEx('op-kind', op-kind.op-kind, 'DebugParser', '0')).
      ASSIGN
         tcur     = ?
         tacct-db = ?
         tacct-cr = ?
         tamt     = 0
         .

      /********
       * Собираем все шаблоны которые требуют объединения.
       ********
       * Автор    : Маслов Д. А. Maslov D. A.
       * Заявка   : #2409
       * Добавлено: 11.02.13
       ********/
       DEF VAR cCreateMask AS CHAR INIT "" NO-UNDO.
       DEF VAR putInDoc    AS INT          NO-UNDO.
       DEF BUFFER ttWop FOR wop.


       FOR EACH op-template OF op-kind NO-LOCK: 
              putInDoc = INT(GetXAttrValueEx("op-template",op-template.op-kind + "," + STRING(op-template.op-template),"PirLink2","-1")).
              IF (putInDoc < 0) THEN DO:
                   cCreateMask = cCreateMask + STRING(op-template.op-template) + ",".
               END.
       END.
       cCreateMask = TRIM(cCreateMask,",").

       /** Конец вставки по #2409 **/
      
      doc:
      FOR EACH op-template OF op-kind WHERE
            CAN-DO(lst-tmpl-op,STRING(op-template.op-template)) NO-LOCK 
         WITH FRAME opreq  
         ON ENDKEY UNDO cr_loan, LEAVE cr_loan 
         ON ERROR  UNDO cr_loan, LEAVE cr_loan 
         BREAK BY op-template.op-template:
         FIND FIRST signs WHERE
                    signs.FILE-NAME EQ "op-template" 
                AND signs.surrogate EQ op-kind.op-kind + "," + 
                                       STRING(op-templ.op-templ)
                AND signs.CODE      EQ "ДатаВал" NO-LOCK NO-ERROR.
         need-valdate = AVAILABLE signs AND signs.xattr-val EQ "Да".
         remove-amt   = 10.
         send-amt     = 15.
         ASSIGN
            tacct-db = ?
            tacct-cr = ?
            tcur-db  = ""
            tcur-cr  = ""
            .
         CREATE wop.
         wop.currency = GetCurr(op-templ.currency).
         IF wop.currency = ? THEN
         DO:
            {message
               "Не определена валюта в шаблоне проводки N "" + string(op-templ.op-templ) + "" !"}
            UNDO cr_loan, LEAVE cr_loan.
         END.
         ASSIGN
            wop.op-kind  = op-templ.op-kind
            wop.op-templ = op-templ.op-templ
            tcur         = ?
            .

         {g-acctv1.i &vacct=tacct &OFBase="/*" &OFsrch=* &func-def=*}
         {g-acctv1.i &nodef-GetAcct=* &vacct=tacct}

         {asswop.i}
      END.

      FOR EACH wop WHERE:
         RUN parssen.p (RECID(wop),in-op-date,OUTPUT fler).
         IF fler THEN
            UNDO cr_loan, LEAVE cr_loan.
      END.

      PAUSE 0.
      /* создание op op-entry */

      {g-op.cr
         &open-undo="UNDO cr_loan, RETRY cr_loan"
         &open-undo-leave="UNDO cr_loan, LEAVE cr_loan"
         &where=" WHERE CAN-DO(cCreateMask,STRING(wop.op-templ))"
         }

      /********
       * Собираем все шаблоны которые требуют объединения.
       ********
       * Автор    : Маслов Д. А. Maslov D. A.
       * Заявка   : #2409
       * Добавлено: 11.02.13
       ********/

       FOR EACH op-template OF op-kind NO-LOCK: 
              putInDoc = INT(GetXAttrValueEx("op-template",op-template.op-kind + "," + STRING(op-template.op-template),"PirLink2","-1")).

             IF (putInDoc>0) THEN DO:
                   FIND FIRST ttWop WHERE ttWop.op-templ = putInDoc NO-LOCK.
                   IF AVAILABLE(ttWop) THEN DO:
                        FIND FIRST op WHERE RECID(op) = ttWop.op-recid NO-LOCK.

                        FIND FIRST wop WHERE wop.op-templ = op-template.op-template.
                        wop.op = op.op.
                        {pir-g-op-en.cr &no-noe-define=* {&*} &no-simbSide=* &open-undo="UNDO cr_loan, RETRY cr_loan"}
                   END.                  
             END.
        END.
        /*** Конец вставки по #2409 ***/





      FOR EACH wop WHERE
            NOT wop.doc-type BEGINS "(",
         EACH op WHERE
            RECID(op) EQ wop.op-recid,
         EACH op-entry OF op:
         CREATE wentry.
         ASSIGN wentry.entry-recid = RECID(op-entry).
/* PIR доработка по 275 ФЗ заполнение допреков потому что через парсен не х.. не работает */

DEFINE VARIABLE inn AS CHARACTER NO-UNDO.
DEFINE VARIABLE name_pl AS CHARACTER NO-UNDO.
DEFINE VARIABLE acct_pl AS CHARACTER NO-UNDO.
	 /** Найдем счет */
	 FIND FIRST acct WHERE acct.acct = op-entry.acct-db AND acct.cust-cat <> "В" NO-LOCK NO-ERROR.
	 IF AVAIL acct THEN 
	 	 DO:
			 /** Найдем клиента */
			 IF acct.cust-cat = "Ю" THEN DO:
			 	 FIND FIRST cust-corp where cust-corp.cust-id = acct.cust-id NO-LOCK NO-ERROR.
			 	 inn = cust-corp.inn.
			 END.
			 IF acct.cust-cat = "Ч" THEN DO:
			 	 FIND FIRST person WHERE person.person-id = acct.cust-id NO-LOCK NO-ERROR.
			 	 inn = TRIM(REPLACE(person.inn, "0", "")).
			 	 IF inn = "" THEN DO:
			 	 	 name_pl = person.name-last + " " + person.first-names + CHR(10) + "( " +
			 	 	   DelDoubleChars(
			 	 	   (IF person.address[1] = person.address[2] THEN person.address[1] ELSE person.address[1] + "," + person.address[2]),
			 	 	   ",") + " )".
			 	 	 acct_pl = op-entry.acct-db.
         UpdateSigns("op", STRING(op.op),
                     "Name-send", 
                     name_pl, 
                     NO).	
         UpdateSigns("op", STRING(op.op),
                     "acct-send", 
                     acct_pl, 
                     NO).	
			 	 END.
			 END.
	 	 END.
/* Конец PIR */            
      END.

      RUN "op-en(ok.p" (13).

      IF KEYFUNCTION(LASTKEY) EQ "END-ERROR" THEN
         UNDO cr_loan, LEAVE cr_loan.
      FOR EACH wop WHERE
            NOT wop.doc-type BEGINS "(",
         EACH op WHERE
            RECID(op) EQ wop.op-recid:
         {op.upd &undo="undo cr_loan, retry cr_loan"}

         /* Для парсера в содержании */
         {g-crfrmf.i wop op}
         IF LOOKUP("ProcessDetails", THIS-PROCEDURE:INTERNAL-ENTRIES) > 0 THEN
         DO:
            ASSIGN
               t-details = op.details.
            RUN ProcessDetails (IF avail wop THEN RECID(wop) 
                                             ELSE ?, 
                                INPUT-OUTPUT t-details).
            op.details = t-details.
         END.
         
/* PIR begin автонумерация */
{g-docnum.def}

  IF  GetXattrValue("op-template",
                   op.op-kind + "," +
                   string(op.op-template),
                   "ДокНомер") ne "" THEN
       DO:         

	          ASSIGN
              docnum-op   = string (recid (op))
              docnum-tmpl = GetXattrValue("op-template",
                                          op.op-kind + "," +
                                          string(op.op-template),
                                          "ДокНомер")
             docnumtempl = ENTRY(NUM-ENTRIES(docnum-op), docnum-tmpl)                             
           .
           IF {assigned docnum-tmpl} THEN 
           DO:
              op.doc-num = STRING(GetCounterNextValue(docnumtempl, op.op-date)).
           END.
      END. 
      
        
/* PIR end конец */    		
         
         /* Для парсера в содержании */
         FOR FIRST op-templ WHERE
                   op-templ.op-kind  EQ wop.op-kind AND
                   op-templ.op-templ EQ wop.op-templ
         NO-LOCK:
            RUN parssign.p (op.op-date,
                            "op-template",
                            wop.op-kind + "," + STRING(wop.op-templ),
                            op-templ.class-code,
                            "op",
                            STRING(op.op),
                            op.class-code,
                            RECID(wop)).
         END.

         IF GetXAttrValueEx("op-template", 
                            op-template.op-kind + "," + STRING(op-template.op-template), 
                            "show-form", 
                            "Нет") EQ "Да" THEN
         DO:
            RUN RunClassMethod(op.class-code, 
                               "Form", 
                               "", 
                               "", 
                               "", 
                               CHR(1) + ",," + op.class-code + "," + STRING(op.op) + ",{&MOD_EDIT},4").
         END.
 

         /* Проверяем наличие обязательных доп.реквизитов. */
         RUN chsigns.p (op.class-code,
                        ?,
                        ?,
                        YES,
                        OUTPUT result).

         /* Если они есть - запускаем редактирование. */
         IF result GT 0
            THEN RUN "xattr-ed.p" (op.class-code, STRING(op.op),
                                   "ДОКУМЕНТА", YES, 3).

         /* Если ДР требуют редактирования - не даем подтвердить документ. */
         IF LASTKEY NE 10 AND LASTKEY NE 13
            THEN UNDO CR_LOAN, LEAVE CR_LOAN.

         mMethodAfter = GetXAttrValueEx("op-template", op-kind.op-kind + "," + STRING(op-template.op-template), "RunAfterCreate", "").

         IF mMethodAfter NE "" THEN
         DO:

            IF SearchPFile(mMethodAfter) THEN
            DO:
               RUN VALUE(mMethodAfter + ".p") (RECID(op)).

               IF pick-value NE "YES" THEN
                  UNDO CR_LOAN, LEAVE CR_LOAN.
            END.
         END.
      END.
   END. /* GEN */
   {optr.i &DoAfter=YES}
END. /* CR_LOAN */
{g-print1.i}

RUN DeleteOldDataProtocol IN h_base("tmp-person-id").
RUN DeleteOldDataProtocol IN h_base("tmp-cust-cat").
{plibdel.i}
HIDE FRAME opreq NO-PAUSE .
 
IF VALID-HANDLE(loan_h) THEN
   DELETE PROCEDURE(loan_h) .
{intrface.del}          /* Выгрузка инструментария. */ 

PROCEDURE CrConstRecip:
   mRecip-data = GetXAttrValueEx("op-template",
                                 op-kind.op-kind + "," + STRING(op-templ.op-templ),
                                 "const-recip", 
                                 "").
   IF mRecip-data NE "" THEN DO:
      ASSIGN
         op.name-ben = ENTRY(5,mRecip-data,"^")
         op.inn      = ENTRY(3,mRecip-data,"^")
         op.ben-acct = ENTRY(2,mRecip-data,"^")
         vmfo        = ENTRY(1,mRecip-data,"^")
      NO-ERROR.
      {getbank.i "bank1" "vmfo" ""МФО-9""}
      IF     AVAIL bank1    AND 
         NOT bank1.flag-rkc AND 
         LENGTH(vmfo) EQ 9  OR
         LENGTH(vmfo) EQ 8 
      THEN DO:
         FIND FIRST banks-corr
            WHERE banks-corr.bank-corr eq bank1.bank-id
              AND CAN-FIND(bank1 OF banks-corr
                           WHERE bank1.flag-rkc)
         NO-LOCK NO-ERROR.
         IF AVAIL banks-corr THEN
         vcorr-acct = banks-corr.corr-acct.
      END.
      {opbnkcr.i op.op """" ""МФО-9"" vmfo vcorr-acct}
      RELEASE op-bank.
   END.
END PROCEDURE.
