{pirsavelog.p}

/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2004 ТОО "Банковские информационные системы"
     Filename: rx-117i.p
      Comment: '117-И Печать реестра по проведенным операциям'
   Parameters:
         Uses: 
      Used by:
      Created: kraw (0047036)
      Modified: Бурягин Е.П. 04.04.2007 16:52 (Локальный код: БЕП0000001)
                Изменил формат экспорта в файл. Все значения, являющиеся стоками,
                обрамляются одиночными кавычками. Символ подчеркивания исключается за ненадобностью.
      Modified: Бурягин Е.П. 25.04.2007 15:15 (Локальный код для поиска: БЕП0000002)
      					Немного переделал "наши" файлы. Взял из оригиналов ree-117i.p и ree-117i.i все, что нужно 
      					для обработки Связанных субъектов документа. Заменил вызов pirree-117i.i на 
      					вызов стандартной ree-117i.i дабы в будущем не возникало проблем.
    	Modified: Бурягин Е.П. 15.05.2007 16:45 (Локальный код для поиска: БЕП0000003)
    	          Убрал экспорт полей старше 13-го для физических лиц. Индивидуальные предприниматели 
    	          в нашей базе хранятся с категорией "Ю", поэтому всех "Ч" отрезаем.
    	Modified: Бурягин Е.П. 15.05.2007 16:52 (Локальный код для поиска: БЕП0000004)
    	          Если значение поля tt-117.bname и tt-117.bcode не заполнено, то 
    	          должны экспортироваться данные нашего банка.
    	Modified: Бурягин Е.П. 15.05.2007 17:30 (Локальный код для поиска: БЕП0000005)
    						Если значение поля tt-117.pname1 и tt-117.pname2 и tt-117.pinn пусты, то
    						экспортироваться данные клиента из полей  tt-117.f-nam и tt-117.cinn соответственно.
    	Modified: Бурягин Е.П. 23.05.2007 10:10 (Локальный код для поиска: БЕП0000006)
    						Добавил дополнительную проверку, связанную также с изменениями БЕП0000005. 
    						Проверка предназначена для дополнения информацией о получателе в записи о внутренней операции 
    						(с счета одного нашего клиента на счет другого нашего клиента).
    						Суть проверки заключается в том, что для записи tt-117 в случае не заполнения полей
    						tt-117.pname1, tt-117pname2 и tt-117.pinn, в коде настоящей процедуры снова 
    						из БД выбирается документ (данные для этого хранятся в поле tt-117.tsurr; 
    						формат: [op.op,op-entry.op-entry] = [9999999,9999]) для выяснения факта:
    						одинаковые ли клиенты по у дебетового и кредитового счета. Дело в том, что ree-117i.i 
    						для внутренних операций при заполении записи tt-117 не заполняет указанные выше поля.
    						Если поля не заполнены, то нужно найти корреспондирующий с tt-117.c-acc счет, найти его клиента, и
    						если клиент отличен от клиента счета tt-117.c-acc, то заполнить требуемые поля соответсвующими значениями.
    	Modified: Бурягин Е.П. 24.05.2007 9:49 (Локальный код для поиска: БЕП0000007)
    						Нужно проконтролировать и в случае необходимости исправить ситуацию с заполнением номера паспорта
    						сделки для записей tt-117, для которых ccode <> 643 (Россия) и счет клиента в проводке
    						находится по кредиту. Для таких записей поле r-PSd не должно заполняться.
        Modified: Бурягин Е.П. 20.02.2008 13:19 (Локальный код для поиска: БЕП000008)
                                                Только предположение:
                                                Из-за системного механизма определения наименования клиента физ.лица
                                                согласно 275-ФЗ при экспорте ФИО клиента с "нулевым" ИНН дополняется 
                                                адресом поживания. Будем калечить, чтобы лечить! ))
*/

/** БЕП0000002 Buryagin commented at 25.04.2007 15:15 
DEFINE INPUT PARAM iParam AS CHAR NO-UNDO. 
*/

/** БЕП0000002 Buryagin added at 25.04.2007 15:21 */
{globals.i}
{wordwrap.def}
{bank-id.i}
{op-ident.i}
{intrface.get op}
{intrface.get netw}
{intrface.get olap}
/** БЕП0000002 end */
{get-bankname.i}
/** БЕП0000006: добавил 23.05.2007 12:28 */
{ulib.i}
/** БЕП0000006: end */

{ree-117i.i}


DEFINE VARIABLE mFileNameTmp AS CHARACTER NO-UNDO.
DEFINE VARIABLE mRet         AS CHARACTER NO-UNDO.
DEFINE VARIABLE mFileName    AS CHARACTER NO-UNDO.


DEFINE VARIABLE mBytes       AS INTEGER   NO-UNDO.
DEFINE VARIABLE mIsExist     AS LOGICAL   NO-UNDO.

/** БЕП0000006: добавил 23.05.2007 12:25 */
DEFINE BUFFER bfrOpEntry FOR op-entry.
DEFINE BUFFER bfrOpEntry2 FOR op-entry.
DEFINE BUFFER bfrAcctDB FOR acct.
DEFINE BUFFER bfrAcctCR FOR acct.
DEF VAR corsAcctClient AS CHAR NO-UNDO.
/** БЕП0000006: end */

FORM 
   mFileName   FORMAT "x(300)" VIEW-AS FILL-IN SIZE 30 BY 1 LABEL "Имя файла" HELP "F1 - список" SKIP
WITH FRAME fIs TITLE "Файл результата" CENTERED KEEP-TAB-ORDER OVERLAY ROW 10 SIDE-LABELS.

DEFINE STREAM sCSV.

FUNCTION getTMPFileName RETURNS CHARACTER.
   RETURN STRING(YEAR(TODAY),"9999") 
         + STRING(MONTH(TODAY),"99") 
         + STRING(DAY(TODAY),"99") 
         + "_" + STRING(RANDOM(0,999999),"999999").
END.

/************************/

mFileNameTmp = "/tmp/" + getTMPFileName() + "ree-117i.csv".
mFileName = "./users/" + LOWER(userid("bisquit")) + "/ree117.csv".

OUTPUT STREAM sCSV TO VALUE(mFileNameTmp) CONVERT TARGET "1251".

PUT STREAM sCSV UNFORMATTED STRING(beg-date) + ";" + STRING(end-date) SKIP.

FOR EACH tt-117 
&IF DEFINED(data-client) EQ 0 &THEN
   BREAK BY tt-117.c-cat
         BY tt-117.c-nam
         BY tt-117.c-id
         BY tt-117.c-acc
         BY tt-117.op-dt:
&ELSE
   BREAK BY tt-117.op-dt
         BY tt-117.c-cat
         BY tt-117.c-nam
         BY tt-117.c-id
         BY tt-117.c-acc:
&ENDIF

ASSIGN
   mBname[1]   = tt-117.bname 
   mAdr[1]     = tt-117.adr
   mPName[1]   = tt-117.pname1 + " " + tt-117.pname2
   mCliName[1] = tt-117.f-nam
.
                       
/** БЕП0000008: добавил 20.02.2008 13:26 */
mPName[1] = ENTRY(1, mPName[1], CHR(10)).
/** БЕП0000008: end */

/** БЕП0000004: добавил 15.05.2007 16:55 */
IF mBname[1] = "" AND tt-117.bcode = "" THEN DO:
	mBname[1] = cBankName.
	tt-117.bcode = FGetSetting("БанкМФО", "", "").
END.
/** БЕП0000004: end */





/** БЕП0000005: добавил 15.05.2007 17:36 */
IF mPName[1] = "" AND tt-117.pinn = "" THEN 
DO:

	/** БЕП0000006: добавил 23.05.2007 10:19 */
	/* Снова найдем "подозрительный" документ c учетом полупроводок */
	FIND FIRST bfrOpEntry WHERE 
			bfrOpEntry.op = INT(ENTRY(1,tt-117.tsurr)) 
			AND 
			bfrOpEntry.op-entry = INT(ENTRY(2,tt-117.tsurr))
			NO-LOCK NO-ERROR.
	IF AVAIL bfrOpEntry THEN 
		DO:
		  
			IF bfrOpEntry.acct-db <> ? THEN 
				FIND FIRST bfrAcctDB WHERE bfrAcctDB.acct = bfrOpEntry.acct-db NO-LOCK.
			ELSE DO:
				/** Найдем счет по дебету полупроводки */
				FIND FIRST bfrOpEntry2 WHERE bfrOpEntry2.op = bfrOpEntry.op 
																		 AND bfrOpEntry2.op-entry <> bfrOpEntry.op-entry
																		 AND bfrOpEntry2.acct-db <> ? NO-LOCK NO-ERROR.
				IF AVAIL bfrOpEntry2 THEN 
					FIND FIRST bfrAcctDB WHERE bfrAcctDB.acct = bfrOpEntry2.acct-db NO-LOCK.
			END.
				
			IF bfrOpEntry.acct-cr <> ? THEN 
				FIND FIRST bfrAcctCR WHERE bfrAcctCR.acct = bfrOpEntry.acct-cr NO-LOCK.
			ELSE DO:
				/** Найдем счет по дебету полупроводки */
				FIND FIRST bfrOpEntry2 WHERE bfrOpEntry2.op = bfrOpEntry.op 
																		 AND bfrOpEntry2.op-entry <> bfrOpEntry.op-entry
																		 AND bfrOpEntry2.acct-cr <> ? NO-LOCK NO-ERROR.
				IF AVAIL bfrOpEntry2 THEN 
					FIND FIRST bfrAcctCR WHERE bfrAcctCR.acct = bfrOpEntry2.acct-cr NO-LOCK.
			END.
			
			IF CAN-DO("Ю,Ч", bfrAcctDB.cust-cat) AND CAN-DO("Ю,Ч", bfrAcctCR.cust-cat) AND NOT
				 (bfrAcctDB.cust-cat = bfrAcctCR.cust-cat AND bfrAcctDB.cust-id = bfrAcctCR.cust-id) THEN 
				DO:
				
					/* Если оба счета клиентских, но клиенты не "равны" 
					   найдем корреспондирующий счет и реквизиты его владельца (клиента) */
					IF bfrAcctDB.acct = tt-117.c-acc THEN 
							corsAcctClient = bfrAcctCR.cust-cat + "," + STRING(bfrAcctCR.cust-id).
					ELSE
							corsAcctClient = bfrAcctDB.cust-cat + "," + STRING(bfrAcctDB.cust-id).
					IF ENTRY(1, corsAcctClient) = "Ч" THEN DO:
						FIND FIRST person WHERE person-id = INT(ENTRY(2, corsAcctClient)) NO-LOCK.
						mPName[1] = TRIM(person.name-last + " " + person.first-names).
						tt-117.pinn = person.inn.
					END.
					IF ENTRY(1, corsAcctClient) = "Ю" THEN DO:
						FIND FIRST cust-corp WHERE cust-corp.cust-id = INT(ENTRY(2, corsAcctClient)) NO-LOCK.
						mPName[1] = TRIM(cust-corp.cust-stat + " " + cust-corp.name-corp).
						tt-117.pinn = cust-corp.inn.
					END.
				END.
			ELSE
				DO:
					/** БЕП0000006: end */
					IF CAN-DO("70107*,47405*", bfrAcctCR.acct) OR CAN-DO("47405*", bfrAcctDB.acct) THEN 
						DO:
							mPName[1] = cBankName. 
							tt-117.pinn = FGetSetting("ИНН","",""). 
						END.
					ELSE
						DO:
							mPName[1] = mCliName[1].
							tt-117.pinn = tt-117.cinn. 
						END.
					/** БЕП0000006: добавил 23.05.2007 10:19 */
				END.
				/** БЕП0000006: end */
		END.
END.

/** БЕП0000005: end */



/*  V.N.Ermilov: added extended checking to fix docs with accounts begins on 474*,452*,302 */  

/*   PUT STREAM sCSV UNFORMATTED " :)) "  STRING(tt-117.tsurr,  "X(80)")       "';'" SKIP.  */

IF tt-117.tsurr <> "" THEN
DO:
	FIND FIRST bfrOpEntry WHERE 
			bfrOpEntry.op = INT(ENTRY(1,tt-117.tsurr)) 
			AND 
			bfrOpEntry.op-entry = INT(ENTRY(2,tt-117.tsurr))
			NO-LOCK NO-ERROR.
	IF AVAIL bfrOpEntry THEN 
		DO:
		  
			IF bfrOpEntry.acct-db <> ? THEN 
				FIND FIRST bfrAcctDB WHERE bfrAcctDB.acct = bfrOpEntry.acct-db NO-LOCK.
			ELSE DO:
				/** Найдем счет по дебету полупроводки */
				FIND FIRST bfrOpEntry2 WHERE bfrOpEntry2.op = bfrOpEntry.op 
																		 AND bfrOpEntry2.op-entry <> bfrOpEntry.op-entry
																		 AND bfrOpEntry2.acct-db <> ? NO-LOCK NO-ERROR.
				IF AVAIL bfrOpEntry2 THEN 
					FIND FIRST bfrAcctDB WHERE bfrAcctDB.acct = bfrOpEntry2.acct-db NO-LOCK.
			END.
				
			IF bfrOpEntry.acct-cr <> ? THEN 
				FIND FIRST bfrAcctCR WHERE bfrAcctCR.acct = bfrOpEntry.acct-cr NO-LOCK.
			ELSE DO:
				/** Найдем счет по дебету полупроводки */
				FIND FIRST bfrOpEntry2 WHERE bfrOpEntry2.op = bfrOpEntry.op 
																		 AND bfrOpEntry2.op-entry <> bfrOpEntry.op-entry
																		 AND bfrOpEntry2.acct-cr <> ? NO-LOCK NO-ERROR.
				IF AVAIL bfrOpEntry2 THEN 
					FIND FIRST bfrAcctCR WHERE bfrAcctCR.acct = bfrOpEntry2.acct-cr NO-LOCK.
			END.
		END.



				IF 	STRING(bfrAcctDB.acct) BEGINS "47405" OR STRING(bfrAcctDB.acct) BEGINS "452" OR 
					STRING(bfrAcctDB.acct) BEGINS "47426" OR STRING(bfrAcctDB.acct) BEGINS "45205" OR 
				/*	STRING(bfrAcctDB.acct) BEGINS "30114" OR STRING(bfrAcctDB.acct) BEGINS "30222" OR */
					STRING(bfrAcctCR.acct) BEGINS "47405" OR STRING(bfrAcctCR.acct) BEGINS "4520" OR
					STRING(bfrAcctCR.acct) BEGINS "45812" OR STRING(bfrAcctCR.acct) BEGINS "47423" OR
					STRING(bfrAcctCR.acct) BEGINS "45912" OR STRING(bfrAcctCR.acct) BEGINS "70601"  
				THEN 
						DO:

							/*PUT STREAM sCSV UNFORMATTED " ura "   SKIP.*/
							mPName[1] = cBankName. 
							tt-117.pinn = FGetSetting("ИНН","",""). 
						END.
				ELSE
						DO:
							/*PUT STREAM sCSV UNFORMATTED " opa( "   SKIP.*/
						END.
END.








/** БЕП0000007: добавил 24.05.2007 10:14 */
IF tt-117.ccode <> "643" THEN 
	DO:
		
		/**
		FIND bfrOpEntry WHERE 
			bfrOpEntry.op = INT(ENTRY(1, tt-117.tsurr)) 
			AND 
			bfrOpEntry.op-entry = INT(ENTRY(2, tt-117.tsurr))
			NO-LOCK.
		IF tt-117.c-acc = bfrOpEntry.acct-cr THEN
		*/
		
			tt-117.r-PSd = "".
	END.
/** БЕП0000007: end */



   PUT STREAM sCSV UNFORMATTED "'" 
      STRING(mCliName[1],  "X(80)")       "';'" 
     STRING(tt-117.c-acc, "X(20)")       		"';"
      STRING(tt-117.op-dt, "99/99/9999")  ";"
      STRING(tt-117.napr,  "x(1)")        ";"
      STRING(tt-117.r-KOV, "X(5)")        ";"
      STRING(tt-117.op-cu, "X(3)")        ";"
      STRING(tt-117.op-su, ">>>>>>>>>>>9.99") ";'"
      STRING(mBname[1],    "x(55)")       		"';"
      STRING(tt-117.bcode, "x(12)")       ";"
      STRING(tt-117.r-PSd, "X(22)")       ";"
      STRING(tt-117.r-VCO, "X(3)")        ";"
   .
   IF tt-117.r-SVC GT 0 THEN
      PUT STREAM sCSV UNFORMATTED
         STRING(tt-117.r-SVC, ">>>,>>>,>>>,>>9.99") ";".
   ELSE PUT STREAM sCSV UNFORMATTED FILL(" ",18) ";".
   
   
/** БЕП0000003: изменил 15.05.2007 16:48 
   PUT STREAM sCSV UNFORMATTED
      STRING(tt-117.ccode, "x(3)")  ";'"
      STRING(tt-117.cinn,  "x(12)") "';"
      STRING(tt-117.rdate, "x(10)") ";"    
      STRING(mAdr[1],      "x(80)") ";"
      STRING(tt-117.odate, "x(10)") ";"
      STRING(mPName[1],    "x(80)") ";'"                         
      STRING(tt-117.pinn,  "x(12)") "'" SKIP.
*/

   PUT STREAM sCSV UNFORMATTED
      (IF tt-117.c-cat = "Ч" THEN "" ELSE STRING(tt-117.ccode, "x(3)"))  ";'"
      (IF tt-117.c-cat = "Ч" THEN "" ELSE STRING(tt-117.cinn,  "x(12)")) "';"
      (IF tt-117.c-cat = "Ч" THEN "" ELSE STRING(tt-117.rdate, "x(10)")) ";"    
      (IF tt-117.c-cat = "Ч" THEN "" ELSE STRING(mAdr[1],      "x(80)")) ";"
      (IF tt-117.c-cat = "Ч" THEN "" ELSE STRING(tt-117.odate, "x(10)")) ";"
      (IF tt-117.c-cat = "Ч" THEN "" ELSE STRING(mPName[1],    "x(150)")) ";'"                         
      (IF tt-117.c-cat = "Ч" THEN "" ELSE STRING(tt-117.pinn,  "x(12)")) "'" SKIP.

/** БЕП0000003: end */

END.

OUTPUT STREAM sCSV CLOSE.

PAUSE 0.

RUN IsUserServReady IN h_netw ("", OUTPUT mRet).

ON "GO" OF FRAME fIs DO:
   DEFINE VARIABLE vErr AS LOGICAL NO-UNDO.

   vErr = NO.

   FILE-INFO:FILE-NAME = INPUT mFileName.

   IF FILE-INFO:FILE-TYPE NE ? THEN  DO:
      mIsExist = NO.
      MESSAGE "Файл " INPUT mFileName " существует" SKIP
              "Переписать?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE mIsExist. 
      IF NOT mIsExist THEN RETURN NO-APPLY.
   END.

   OS-COPY VALUE(mFileNameTmp) VALUE(INPUT mFileName).

   IF OS-ERROR NE 0 THEN DO:
      MESSAGE 'Файл "' mFileName '" не сохранен' VIEW-AS ALERT-BOX ERROR. 
      vErr = YES.
   END.
   
   IF vErr THEN
      RETURN NO-APPLY.
END.

ON "F1" OF mFileName IN FRAME fIs DO:
   RUN ch-file2.p("*.csv", "", INPUT-OUTPUT mFileName, YES).
   mFileName:SCREEN-VALUE = mFileName.
END.

PAUSE 0.

UPDATE
   mFileName
WITH FRAME fIs.

HIDE FRAME fIs.
os-delete VALUE(mFileNameTmp).

