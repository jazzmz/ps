{pirsavelog.p}

/* 
                Распоряжение по резервам 232-П
                Бурягин Е.П. 10.01.2006 10:19
                
                Условимся, что броузере выбраны только "правильные" документы, т.е. те,
                которые должны отображаться в настоящем распоряжении.
*/

/* Подключяем глобалные настройки*/
{globals.i}

/* Библиотека функций для работы со счетами */
{ulib.i}
{get-bankname.i}


{intrface.get instrum}
{intrface.get count}
{tmprecid.def}


{getdate.i}

/* Вывод в preview */


/** ОПРЕДЕЛЕНИЯ **/

DEF INPUT PARAM inParam AS CHAR.
/* Счет резерва: определим и сохраним его в этой переменной */
DEF VAR acct_rsrv AS CHAR NO-UNDO.
/* Внебалансовый счет, который попадает в первый столбец */
DEF VAR acct_main_no  AS CHAR NO-UNDO.
DEF VAR acct_main_cur AS CHAR NO-UNDO.
/* Позиция по счету */
DEF VAR acct_main_pos AS DECIMAL NO-UNDO.
DEF VAR acct_main_pos_rur AS DECIMAL NO-UNDO.
DEF VAR acct_rsrv_calc_pos AS DECIMAL NO-UNDO.
DEF VAR acct_rsrv_real_pos AS DECIMAL NO-UNDO.

/* Сумма операции */
DEF VAR amt_create AS DECIMAL NO-UNDO.
DEF VAR amt_delete AS DECIMAL NO-UNDO.

DEF VAR client_name AS CHAR NO-UNDO.
DEF VAR loaninf AS CHAR NO-UNDO.
DEF VAR grrisk AS CHARACTER NO-UNDO.

DEF VAR prrisk AS CHARACTER NO-UNDO.
DEF VAR prrisk2 AS DECIMAL NO-UNDO.

/* Итоговые значения */
DEF VAR total_pos_rur AS DECIMAL NO-UNDO.
DEF VAR total_pos_usd AS DECIMAL NO-UNDO.
DEF VAR total_pos_eur AS DECIMAL NO-UNDO.
DEF VAR total_calc_rsrv AS DECIMAL NO-UNDO.
DEF VAR total_real_rsrv AS DECIMAL NO-UNDO.
DEF VAR total_create_rsrv AS DECIMAL NO-UNDO.
DEF VAR total_delete_rsrv AS DECIMAL NO-UNDO.
/* Вывод ошибок на экран */
DEF VAR traceOn AS LOGICAL INITIAL false NO-UNDO.
/* Временная для работы */
DEF VAR tmpStr AS CHAR NO-UNDO.
/* Должности и подписи */
DEF VAR PIRbos AS CHAR NO-UNDO.
DEF VAR PIRbosFIO AS CHAR NO-UNDO.
DEF VAR userPost AS CHAR NO-UNDO.
DEF VAR PIRtarget AS CHAR NO-UNDO.
DEF VAR PIRispl AS CHAR NO-UNDO.

def var ofunc as tfunc.

DEF VAR oTable AS TTable    NO-UNDO.
DEF VAR oAcct   AS TAcct    NO-UNDO.

DEF VAR total_pos_in_rur AS DECIMAL INITIAL 0 NO-UNDO.
DEF VAR oTpl AS TTpl NO-UNDO.

&IF DEFINED(arch2)<>0 &THEN
{pir-out2arch.i}
curr-user-inspector = FGetSetting("PirEArch","RepInspCredit",?). /* #3718 */
&ENDIF

/*{tpl.create}*/

oTpl = new TTpl("pir_rsrv232.tpl").

oTable = new TTable(12).

oTable:decFormat = "->>>,>>>,>>9.99".
/*
oTable:breakonRows = 34.
oTable:lastpageRows = 3.
*/

ofunc = new tfunc().
DEF BUFFER bfrLoanAcct1 FOR loan-acct.

/** Проверка входящего параметра */
IF NUM-ENTRIES(inParam) < 2 THEN DO:
  MESSAGE "Недостаточное кол-во параметров. Должно быть <норм_документ>,<код_руководителя_из_PIRBoss>,<в_департамент>,<исполнитель>" 
          VIEW-AS ALERT-BOX.
  RETURN.
END.

PIRbos = ENTRY(1,FGetSetting("PIRboss",ENTRY(2, inParam),"")).
PIRbosFIO = ENTRY(2,FGetSetting("PIRboss",ENTRY(2, inParam),"")).


/*18/06/09 Ermilov V.N. */
ASSIGN PIRtarget = "" PIRispl = "" .


IF NUM-ENTRIES(inParam) = 4 THEN 
DO:
        PIRtarget = ENTRY(3, inParam).
        PIRispl = ENTRY(4, inParam).
END.

/* Дата распоряжения */
DEF VAR DATE-rasp AS DATE.
{tmprecid.def}

/** РЕАЛИЗАЦИЯ **/

/* Из первой операции найдем дату отчета */
DATE-rasp = gend-date.
  
  oTpl:addAnchorValue("PIRtarget",PIRtarget).
  oTpl:addAnchorValue("BANK",cBankName).
  oTpl:addAnchorValue("date-rasp",STRING(DATE-rasp,"99/99/9999")).


/* Для всех документов, выбранных в брoузере выполняем... */
FOR EACH tmprecid 
         NO-LOCK,
   FIRST op WHERE 
         RECID(op) EQ tmprecid.id 
         NO-LOCK, 
   FIRST op-entry OF op
         NO-LOCK
: 
        
        ASSIGN amt_create = 0 amt_delete = 0.
        /* Найдем счет резерва в проводке. Он либо по дебету, либо по кредиту и начинается с 4 
           попутно сохраним значение суммы проводки в соответствующую переменную 
        */
        IF op-entry.acct-db BEGINS "4" THEN         ASSIGN acct_rsrv = op-entry.acct-db  amt_delete = amt-rub.
        IF op-entry.acct-cr BEGINS "4" THEN 	    ASSIGN acct_rsrv = op-entry.acct-cr  amt_create = amt-rub.

        /* Если все-таки ни по дебету, ни по кредиту счет, начинающийся на 4 не найден, 
           выдаем сообщение и выходим из процедуры */

        IF acct_rsrv = "" THEN 
                DO:
                        MESSAGE "В проводке документа " + op.doc-num + " нет счета резерва, начинающегося на 4!" VIEW-AS ALERT-BOX.
                        RETURN.
                END.
        /* Согласно реализации резервирования 232-П в БИСКВИТЕ, данный счет должен быть привязан 
                 к внебалансовому счету через дополнительную связь с кодом 80. Проверим существование данной связи */
        FIND FIRST links WHERE
                links.link-id = 80
                AND
                ENTRY(1, links.target-id) = acct_rsrv
                NO-LOCK NO-ERROR.

        IF AVAIL links THEN 
                /* Если связь существует, то сохраним номер и валюту внебалансового счета */
                DO:
                        acct_main_no = ENTRY(1,links.source-id).
                        acct_main_cur = ENTRY(2,links.source-id).
                        IF acct_main_cur = "" THEN acct_main_cur = "810".
                END.
        ELSE
                /* Иначе 
                   пытаемся найти "базовый" счет через договор или 
                   выдаем сообщение об ошибке и завершаем работу процедуры */
                DO:
                        
                        FIND FIRST bfrLoanAcct1 WHERE 
                                bfrLoanAcct1.acct = acct_rsrv
                                AND
                                bfrLoanAcct1.contract = "Кредит"
                        NO-LOCK NO-ERROR.

                        IF AVAIL bfrLoanAcct1 THEN DO:
                                /** Если счет привязан к договору, то нужно проанализировать его роль.
                                    Таблица соотвествия ролей счета резерва и "базового"
                                    
                                    КредРезПр ....... КредПр%,КредПр%В
                                    КредРезП  ....... КредТ,КредТВ 
                                */
                                
                                IF bfrLoanAcct1.acct-type = "КредРезПр" THEN DO:
                                        acct_main_no = GetLoanAcct_ULL(bfrLoanAcct1.contract,
                                                                       bfrLoanAcct1.cont-code,
                                                                       "КредПр%",
                                                                       op.op-date,
                                                                       false).
                                END.                                        
                                IF bfrLoanAcct1.acct-type = "КредРезП" THEN DO:

                                	
                                        acct_main_no = GetLoanAcct_ULL(bfrLoanAcct1.contract,
                                                                       bfrLoanAcct1.cont-code,
                                                                       "КредТ",
                                                                       op.op-date,
                                                                       false).

                                END.                                        
                                acct_main_cur = SUBSTR(acct_main_no, 6, 3).

                        END. ELSE DO:

                                MESSAGE "Счет резерва " + acct_rsrv + " не привязан НИ через доп.связь, НИ через договор к 'базовому' счету!" VIEW-AS ALERT-BOX.
                                RETURN.

                        END.

                END.
        

         /*****************************************************
          * Находим остаток по счету базы начисления 	      *
          * резерва в рублях.				      *
          *****************************************************
          * Дата создания:				      *
          * Автор:   Маслов Д. А.          		      *
          * Заявка: #784				      *
          *****************************************************/
         
	 oAcct = new TAcct(acct_main_no).
	         acct_main_pos        =  oAcct:getLastPos2Date(op.op-date,"Ф").
              if acct_main_cur <> "810" THEN  acct_main_pos_rur = CurToCur ("УЧЕТНЫЙ", acct_main_cur, "", op.op-date, acct_main_pos).
              else   acct_main_pos_rur = acct_main_pos.

              
/*		 acct_main_pos_rur     =  oAcct:getLastPos2Date(op.op-date,"Ф",810).*/

	 DELETE OBJECT oAcct.
	 
        
         /* Найдем расчетный резерв. На самом деле, на момент выполнения процедуры это фактически уже 
            сформированный резерв
         */
         acct_rsrv_calc_pos = ABS(GetAcctPosValue_UAL(acct_rsrv, "810", op.op-DATE, traceOn)).
         
         /* Найдем сформированный резерв. Поскольку распоряжение формируется по факту, т.е. по проводкам, то
                   сумма сформированного резерва = остаток на счете резерва +- сумма проводки 
         */
         acct_rsrv_real_pos = acct_rsrv_calc_pos - amt_create + amt_delete.
         
         /* Накапливаем итоговые суммы */
         IF acct_main_cur = "810" THEN
           total_pos_rur = total_pos_rur + acct_main_pos.
         IF acct_main_cur = "840" THEN
           total_pos_usd = total_pos_usd + acct_main_pos.
         /* Может скоро понадобится  */
         IF acct_main_cur = "978" THEN
           total_pos_eur = total_pos_eur + acct_main_pos.

         ASSIGN  
           total_calc_rsrv = total_calc_rsrv + acct_rsrv_calc_pos
           total_real_rsrv = total_real_rsrv + acct_rsrv_real_pos
           total_create_rsrv = total_create_rsrv + amt_create
           total_delete_rsrv = total_delete_rsrv + amt_delete.
         
         /* Найдем название клиента */
         client_name = GetAcctClientName_UAL(acct_rsrv, traceOn).
         
         /* Найдем информацию о договоре */
         FIND FIRST loan-acct WHERE
                         loan-acct.acct = acct_rsrv
                         AND
                         CAN-DO("Кредит,АХД", loan-acct.contract) 
                         NO-LOCK NO-ERROR.
         IF AVAIL loan-acct THEN
           DO:
             FIND FIRST loan WHERE
               loan.contract = loan-acct.contract
               AND
               loan.cont-code = loan-acct.cont-code
               NO-LOCK NO-ERROR.
             IF AVAIL loan THEN
               DO:
                        IF client_name = "" THEN 
                          client_name = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_name", false).
                        loaninf = (IF loan.contract = "АХД" THEN loan.doc-num ELSE loan.cont-code) + " от ". 


                                   FIND FIRST signs WHERE  
                                                                        signs.code = "ДатаСогл"
                                                                        AND 
                                                                        signs.file-name = "loan"
                                                                        AND 
                                                                        signs.surrogate = "Кредит," + loan.cont-code
                                                                        NO-LOCK NO-ERROR.
                                         IF AVAIL signs THEN
                                           DO:
                                                         loaninf = loaninf + signs.code-value.
                                                 END.
                                         ELSE
                                                  DO:
                                                   loaninf = loaninf + STRING(loan.open-DATE,"99/99/9999").
                                                 END.
               END.
           END.
   ELSE 
                  loaninf = "не определен".

        

/*          grrisk = GetLoanInfo_ULL(loan.contract,loan.cont-code,"gr_riska",false).
          prrisk = GetLoanInfo_ULL(loan.contract,loan.cont-code,"risk",false).*/
          grrisk = "".
          grrisk = ofunc:getKRez(loan.cont-code,op-entry.op-date).

if acct_main_pos_rur < 0 then acct_main_pos_rur = 0.

total_pos_in_rur = total_pos_in_rur + acct_main_pos_rur.

oTable:addRow().
oTable:addCell(acct_main_no + " " + client_name + " " + loaninf).
oTable:addCell(acct_main_pos).
oTable:addCell(acct_main_cur).
oTable:addCell(acct_main_pos_rur).
oTable:addCell(Entry(2,grrisk)).
oTable:addCell(Entry(1,grrisk)).
oTable:addCell(acct_rsrv_calc_pos).
oTable:addCell(acct_rsrv_real_pos).
oTable:addCell(amt_create).
oTable:addCell(amt_delete).

oTable:addCell(op-entry.acct-db).
oTable:addCell(op-entry.acct-cr).

END.


/* Итого */
oTable:addRow().
oTable:addCell("ИТОГО:").
oTable:addCell(total_pos_rur).
oTable:addCell("810").
oTable:addCell(total_pos_in_rur).
oTable:addCell("").
oTable:addCell("").
oTable:addCell(total_calc_rsrv).
oTable:addCell(total_real_rsrv).
oTable:addCell(total_create_rsrv).
oTable:addCell(total_delete_rsrv).
oTable:addCell("").
oTable:addCell("").

oTable:addRow().
oTable:addCell("").
oTable:addCell(total_pos_usd).
oTable:addCell("840").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").

oTable:addRow().
oTable:addCell("").
oTable:addCell(total_pos_eur).
oTable:addCell("978").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").

oTable:setAlign(1,oTable:height - 2,"center").


/* Подписи в подвале */


IF PIRispl = "" 
THEN DO:

        FIND FIRST _user WHERE _user._userid EQ userid NO-LOCK NO-ERROR.
        IF AVAIL _user THEN DO:
                userPost = GetXAttrValueEx("_user", _user._userid, "Должность", "").	        
		oTpl:addAnchorValue("USER_POST",userPost).
	        oTpl:addAnchorValue("USER_NAME",_user._user-name).
        END.
        ELSE
	        oTpl:addAnchorValue("USER_POST","Исполнитель:").
END.
ELSE         IF PIRispl <> '0' THEN do:
	        oTpl:addAnchorValue("USER_POST","Исполнитель:").
	        oTpl:addAnchorValue("USER_NAME",_user._user-name).
		end.

oTpl:addAnchorValue("Table1",oTable).
oTpl:addAnchorValue("date-rasp",DATE-rasp).

{setdest.i &cols=275 &custom = " IF YES THEN 0 ELSE "}
oTpl:show().
{preview.i}

{send2arch.i}

{tpl.delete}

{intrface.del}