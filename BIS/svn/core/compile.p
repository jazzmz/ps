/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-1997 ТОО "Банковские информационные системы"
     Filename: COMPILE.P
      Comment: Компилятор файлов
   Parameters: маска файлов ("norm*.p"),
               файл со списком файлов (или ? - если есть первый параметр),
               каталог r-ок (или ? - берется из propath),
               вызывать ли preview,
               имя log-файла (или ?)
         Uses: promake.i, bar-beg.i, bar.i, justasec, on-esc
      Used by: promake.p
      Created: 03/07/97 Serge
     Modified: 06/07/97 Serge
     Modified: 11/07/97 Serge баг - компиляция файлов без расширения
     Modified: 14/07/97 Serge параметр файл со списком файлов для компиляции
     Modified: 15/07/97 Serge сделал поиск компилируемых файлов если нет в указанном пути
                              вывод PROPATH в log
        Last change:  SG    3 Dec 97    5:24 pm
    Modified:  25/06/2001 Om  Доработка: добавление текущего пути в
                                         конец переменной PROPATH.
    Modified:  25/06/2001 Om  Ошибка   : Затиралась рамка окна.
    Modified:  31/01/2003 Om  Ошибка   : При компиляции одного файла
                                         не отображались предупреждения.
    Modified:  06/02/2003 Om  Ошибка   : При компиляции одного файла не
                                         формировался XREF файл.
    Modified:  19/05/2003 Om  Ошибка   : При компиляции одного файла
                                         не печатались сообщения.
     Modified: 22.12.2007 13:30 Ariz     Форматирование кода
     Modified: 21.07.2009 14:06 KSV      (0106191) Способ выдачи сообщений об
                                         ошибках сделан совместимым с QBIS
     Modified: 14.09.2011 16:50 KSV      (0153100) Исправлена ошибка с 
                                         компиляцией CLS файлов
     Modified: 07.10.2011 16:50 Stred    (0156664) Добавлена компиляция HTML-файлов
     Modified: 19.07.2012 16:50 Stred    (0175848) Добавлена компиляция W-файлов
     
*/
Form "~n@(#) COMPILE.P 1.0 Serge 03/07/97 Serge 03/07/97 Компилятор файлов"
with frame sccs-id stream-io width 250.

/* Файл для компиляции. Если dir eq ?, то существует файл со списком компиляции. */
DEF INPUT PARAM dir         AS CHAR FORMAT "x(60)" LABEL "Файлы"            NO-UNDO.
DEF INPUT PARAM promake-dir AS CHAR FORMAT "x(60)" LABEL "Список файлов"    NO-UNDO.
DEF INPUT PARAM rdir        AS CHAR FORMAT "x(30)" LABEL "Куда класть R'ки" NO-UNDO.
DEF INPUT PARAM preview     AS LOG  NO-UNDO. /* Отображать ли результаты. */
DEF INPUT PARAM logfile     AS CHAR NO-UNDO.
DEF INPUT PARAM modpropath  AS LOG  NO-UNDO.

{compile.def &NoDef = "Не определять"} /* Определение переменных для компиляции. */
{pick-val.i}  /* Определение переменной pick-value. */
{compile.pro} /* Подключение инструментов компиляции. */
{userfunc.i &cmp_CompileUserFunc = YES}  /* Инструменты для поиска настроечных парметров. */

/* Commented by KSV: Выключаем конвертируемую часть SYSCONF.I с ней 
** не будет компилироваться */
&GLOBAL-DEFINE NO_DISPSYSCONF

DEFINE VAR vPeaksChar      AS CHAR NO-UNDO. /* Упорядоченный список вершин проекта. */
DEFINE VAR vSystemPathChar AS CHAR NO-UNDO. /* Системный путь. */

DEF VAR i        AS INT64  NO-UNDO.
DEF VAR j        AS INT64  NO-UNDO.
DEF VAR num      AS INT64  NO-UNDO. /* Количество обработанных файлов. */
DEF VAR numerr   AS INT64  NO-UNDO.
DEF VAR slash    AS CHAR NO-UNDO.
DEF VAR vFlagErr AS LOG  NO-UNDO. /* Флаг ошибки, для подсчета ошибок.  */
DEF VAR filename AS CHAR FORMAT "x(25)" NO-UNDO.
DEF VAR filedir  AS CHAR FORMAT "x(30)" NO-UNDO.
DEF VAR filemask AS CHAR FORMAT "x(30)" NO-UNDO.
DEF VAR prepath  AS CHAR FORMAT "x(30)" NO-UNDO.
DEF VAR xrefname AS CHAR FORMAT "x(25)" INITIAL ? NO-UNDO.
DEF VAR dbo      AS LOGICAL INITIAL NO NO-UNDO. /* флаг использования ДБО */

DEF STREAM aaa.
DEFINE STREAM bb.

ASSIGN
   slash       =  IF opsys EQ "unix"
                  THEN "/"
                  ELSE "~\"
   /* Каталог для R-ок. */
   rdir        =  
&IF DEFINED(SESSION-REMOTE) &THEN
                  gWS_COMPDIR  
&ELSE
                  ENTRY (1, PROPATH)
&ENDIF
                  WHEN LENGTH (rdir) EQ 0
   /* Формирование имени log файла. */
   logfile     =  
&IF DEFINED(SESSION-REMOTE) &THEN
                     string(right-trim(gWS_COMPDIR,"~/") + "/compile.log")
&ELSE
                  "compile.log"
&ENDIF
                  WHEN logfile EQ ?
   /* Если компилируется файл, то вывод на экран. */
   preview     =  NO
                  WHEN promake-dir EQ ?
   /* Получение принтера, необходимо для печати. */
   usr-printer =  getThisUserXAttrValue ('Принтер')
                  WHEN usr-printer EQ ""
.

/* Формирование полного ProPath. */
IF       modpropath
   AND   LENGTH (shFullPathChar) EQ 0
THEN RUN GetFullProPath (ProPath, OUTPUT shFullPathChar).

/* Не указан файл(список файлов) для компиляции. */
IF promake-dir EQ ? AND
   DIR         EQ ?
THEN RETURN.

/* если установлен WebSpeed, то выставляем флаг ДБО */
IF SEARCH("src/web/method/cgidefs.i") NE ? THEN dbo = YES.

{justasec}

/* Если на вход подан файл со списком файлов для компиляции. */
IF promake-dir NE ?
THEN DO:
&IF DEFINED(SESSION-REMOTE) &THEN
   IF INDEX(promake-dir,"~/") = 0 THEN
      promake-dir = right-trim(gWS_COMPDIR,"~/") + "~/" + promake-dir.
&ENDIF

   /* Перенаправление в поток. */
   {setdest.i
      &filename = "logfile"
      &nodef    = "/*"
      &STREAM="stream bb"
   }
   
   PUT stream bb UNFORMATTED
      "Begin compilation on " TODAY " at " STRING(TIME,"hh:mm:ss") " by " USERID('bisquit') SKIP
      "Files being compiled: " DIR            SKIP
      "File with file list : " promake-dir    SKIP
      "R-files folder      : " rdir           SKIP
      "PROPATH             : " propath        SKIP
      "Log file name       : " logfile        SKIP (1)
   .

   INPUT STREAM aaa FROM VALUE(promake-dir).

   {bar-beg.i aaa}
   REPEAT:
      {on-esc LEAVE}

      IMPORT STREAM aaa filename.

/*** Маслов Д. А. Maslov D. A. Временная мера ***/
      filename = TRIM(filename).

      IF filename EQ "" OR TRIM(filename) BEGINS "#"
      THEN NEXT.

      IF     SUBSTR(filename, LENGTH(filename) - 1, 2) NE ".p"
         AND SUBSTR(filename, LENGTH(filename) - 3, 4) NE ".cls"
         AND SUBSTR(filename, LENGTH(filename) - 4, 5) NE ".html"
         AND SUBSTR(filename, LENGTH(filename) - 1, 2) NE ".w"
      THEN NEXT.

      i = R-INDEX(filename,"/").

      IF i EQ 0
      THEN i = R-INDEX(filename,"~\").

      IF LENGTH (xrefdir) GT 0
      THEN ASSIGN
              xrefname = IF i EQ 0
                         THEN filename
                         ELSE SUBSTR(filename,i + 1)
              xrefname = xrefdir + slash + REPLACE(REPLACE(xrefname,".p",".xref"),".cls",".xref")
           .

      IF     SEARCH(filename)               EQ ?
         AND i                              GT 0
         AND SEARCH(SUBSTR(filename,i + 1)) NE ?
      THEN filename = SEARCH(SUBSTR(filename,i + 1)).

      IF NOT (filename MATCHES "*.p"
           OR filename MATCHES "*.cls"
           OR filename MATCHES "*.html"
           OR filename MATCHES "*.w")
      THEN NEXT.

      IF NOT dbo AND (filename MATCHES "*.html" OR filename MATCHES "*.w") THEN NEXT.

      PUT stream bb UNFORMATTED "Compiling " filename SKIP.

      PUT SCREEN
         ROW SCREEN-LINES + 1
         STRING("Compiling " + filename,"x(70)").

      num  = num + 1.

      /* Компиляция файла. Для CLS файлов компиляция с XREF приводит 
      ** к ошибке 49 */
      IF filename MATCHES "*.html" OR filename MATCHES "*.w"
      THEN DO:
         OUTPUT STREAM bb CLOSE.
         RUN comphtml.pp(filename,rdir,logfile,INPUT-OUTPUT numerr) NO-ERROR.
         OUTPUT STREAM bb TO VALUE(logfile) APPEND.
      END.
      ELSE IF NOT filename MATCHES "*cls"
      THEN
         COMPILE
            VALUE(filename)
            NO-ATTR-SPACE
            SAVE
            INTO VALUE(rdir)
            XREF VALUE(xrefname)
            NO-ERROR
         .
      ELSE
         COMPILE
            VALUE(filename)
            NO-ATTR-SPACE
            SAVE
            INTO VALUE(rdir)
            NO-ERROR
         .


      i = ERROR-STATUS:NUM-MESSAGES.

      IF i GT 0 THEN
      DO:
         vFlagErr = YES.

         DO j = 1 TO i:
            IF     GetKeyWords (ERROR-STATUS:GET-MESSAGE(j)) EQ "error"
               AND vFlagErr
            THEN ASSIGN
                    numerr   = numerr + 1
                    vFlagErr = NO
                 .
            PUT stream bb UNFORMATTED ERROR-STATUS:GET-MESSAGE(j) SKIP.
         END.
      END.
      {bar.i aaa}
   END.

   PUT stream bb
      UNFORMATTED SKIP(1)
      "Finished compilation on " TODAY " at " STRING(TIME,"hh:mm:ss")
      (IF KEYFUNC(LASTKEY) = "end-error" THEN " by user break" ELSE "") SKIP
      "Total time        : " STRING(INT64(ETIME(NO) / 1000),"hh:mm:ss") SKIP
      "Number of files   : " num SKIP
      "Number of errors  : " numerr SKIP
      "Time per procedure: " TRIM(STRING(ETIME(NO) / 1000 / num,">>9.99 s"))
   SKIP.
   OUTPUT stream bb  CLOSE.
   INPUT STREAM aaa CLOSE.
END.

/* Если на вход подан файл для компиляции. */
IF dir NE ?
THEN DO:
   /* Получение наименования файла. */
   filename = dir.

   IF NOT (filename MATCHES "*.p"
        OR filename MATCHES "*.cls"
        OR filename MATCHES "*.html"
        OR filename MATCHES "*.w")
   THEN RETURN "-1".

   IF NOT dbo AND (filename MATCHES "*.html" OR filename MATCHES "*.w") THEN NEXT.

   IF LENGTH (xrefdir) GT 0
   THEN xrefname = xrefdir + slash + ENTRY (1, filename, ".") + ".xref".

   MESSAGE "Компилируется файл " + filename + " в " + rdir.

   /* Компиляция файла. */
   IF filename MATCHES "*.html" OR filename MATCHES "*.w"
   THEN DO:
      OUTPUT STREAM bb CLOSE.
      RUN comphtml.pp(filename,rdir,logfile,INPUT-OUTPUT numerr) NO-ERROR.
      OUTPUT STREAM bb TO VALUE(logfile) APPEND.
   END.
   ELSE 
      COMPILE
         VALUE(filename)
         NO-ATTR-SPACE
         SAVE
         INTO VALUE(rdir)
         XREF VALUE(xrefname)
         NO-ERROR
      .

   IF ERROR-STATUS:NUM-MESSAGES NE 0
   THEN DO:
      RUN ShowErrors.
      IF COMPILER:ERROR
      THEN RETURN "-1".
   END.

   RETURN.
END.

/* Вывод на экран. */
IF preview
THEN DO:
   {preview.i &filename="logfile"}
END.
/* Закрытие выходного потока. */
ELSE OUTPUT CLOSE.

RETURN.

/* Выводит перечень ошибок. */
PROCEDURE ShowErrors.
   DEFINE VAR vErrCountInt  AS INT64  NO-UNDO. /* Счетчик ошибок. */
   DEFINE VAR vErrorMsgChar AS CHAR NO-UNDO. /* Содержание ошибки. */

   /* По всем ошибочкам. */
   DO vErrCountInt = 1 TO ERROR-STATUS:NUM-MESSAGES:
      vErrorMsgChar =   IF vErrorMsgChar EQ ""
                        THEN ERROR-STATUS:GET-MESSAGE (vErrCountInt)
                        ELSE vErrorMsgChar + "~n" + ERROR-STATUS:GET-MESSAGE (vErrCountInt).
   END.

   RUN message.p ( vErrorMsgChar, "WHITE/RED", "error", "", "", NO  ).

   RETURN.
END PROCEDURE.
