{pirsavelog.p}

/*
* Печать акта передачи ценностей по ключам от ИБС
* Бурягин Е.П., 13.06.2006 16:44
*/

{globals.i}

/** Кассиры */
DEF INPUT PARAM iParam AS CHAR.

/* Максимальное кол-во ключей в ключнице */
DEF VAR max_keys_count AS INTEGER.
DEF VAR tmpStr AS CHAR.
max_keys_count = INT(FGetSetting("Safe", "SafeKeysCount", "")).

/** Дата документа */
DEF VAR repDate AS DATE.
{getdate.i}
repDate = end-date.

/** Массивы, хранящие информацию по ключам, для каждой категории */
DEF VAR keys_c1 AS CHAR EXTENT 1025.
DEF VAR keys_c2 AS CHAR EXTENT 1025.
DEF VAR keys_c3 AS CHAR EXTENT 1025.

/** Кол-во заполненной информации по ячейкам каждой категории */
DEF VAR index_c1 AS INTEGER INITIAL 0.
DEF VAR index_c2 AS INTEGER INITIAL 0.
DEF VAR index_c3 AS INTEGER INITIAL 0.
DEF VAR count AS INTEGER.
DEF VAR countStr AS CHAR EXTENT 2.
DEF VAR outFIO AS CHAR.
DEF VAR inFIO AS CHAR.

FIND FIRST _user WHERE _user._userid = userid no-lock no-error.
IF AVAIL _user then
	outFIO = _user._user-name.
else
	outFIO = "-".


DEF VAR i AS INTEGER.

/** Перебираем все ячейки со статусом "Пусто" */
FOR EACH code WHERE 
		SUBSTRING(code,2,1) = "-"
		AND
		val = ""
		NO-LOCK
		:
		CASE ENTRY(1,code,"-") :
			WHEN "1" THEN	DO:
					index_c1 = index_c1 + 1.
					keys_c1[index_c1] = ENTRY(2,code,"-").
				END.
			WHEN "2" THEN DO:
					index_c2 = index_c2 + 1.
					keys_c2[index_c2] = ENTRY(2,code,"-").
				END.
			WHEN "3" THEN DO:
					index_c3 = index_c3 + 1.
					keys_c3[index_c3] = ENTRY(2,code,"-").
				END.
		END /* CASE */ .
END /* EACH code */ .


/** Выводим собранную информацию на печать */
{setdest.i}

PUT UNFORMATTED "                                  А К Т" SKIP
                "                             ПЕРЕДАЧИ ЦЕННОСТЕЙ" SKIP(1)
                "                                 " STRING(repDate,"99/99/9999") SKIP(2)
                "   Мы, нижеподписавшиеся, кассиры операционной кассы составили настоящий акт в" SKIP
                "том, что:" SKIP(1)
                "кассир " outFIO " передал(а), а" SKIP(1)
                "кассир " iParam " принял(а) следующие ценности:" SKIP(1)
                "ключи от индивидуальных банковских сейфов по категориям:" SKIP
								"┌─────────────────────┬─────────────────────┬─────────────────────┐" SKIP
                "│ Ячейки 72х10х450    │ Ячейки 100х10х450   │ Ячейки 250х10х450   │" SKIP
                "├─────┬───────────────┼─────┬───────────────┼─────┬───────────────┤" SKIP
                "│№п/п │№ ключа        │№п/п │№ ключа        │№п/п │№ ключа        │" SKIP
                "├─────┼───────────────┼─────┼───────────────┼─────┼───────────────┤" SKIP.
                
DO i = 1 TO max_keys_count :
		PUT UNFORMATTED 
			"│" IF keys_c1[i] = "" THEN "     " ELSE STRING(i,">>>>>") 
			"│" keys_c1[i] FORMAT "X(15)"
			"│" IF keys_c2[i] = "" THEN "     " ELSE STRING(i + index_c1,">>>>>") 
			"│" keys_c2[i] FORMAT "X(15)"
			"│" IF keys_c3[i] = "" THEN "     " ELSE STRING(i + index_c1 + index_c2, ">>>>>") 
			"│" keys_c3[i] FORMAT "X(15)" 
			"│" SKIP.
END.

PUT UNFORMATTED "├─────┼───────────────┼─────┼───────────────┼─────┼───────────────┤" SKIP
                "│Итого│" index_c1 FORMAT ">>>>>>>>>>>>>>9" 
                "│Итого│" index_c2 FORMAT ">>>>>>>>>>>>>>9" 
                "│Итого│" index_c3 FORMAT ">>>>>>>>>>>>>>9" 
                "│" SKIP
                "└─────┴───────────────┴─────┴───────────────┴─────┴───────────────┘" SKIP.


count = index_c3 + index_c2 + index_c1.
Run x-amtstr.p(count, "", false, true, output countStr[1], output countStr[2]).
PUT UNFORMATTED " Всего: " count " (" TRIM(countStr[1]) ") ключ(а,ей)" SKIP(2)
                "Ценности принял ________________               Ценности сдал _________________" SKIP
                "                   (подпись)                                     (подпись)    " SKIP(2)
                "Дата передачи                                  Дата приема" SKIP.


{preview.i}