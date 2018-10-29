/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-1997 ТОО "Банковские информационные системы"
     Filename: promake.p
      Comment: Интерактивный компилятор файлов
   Parameters:
         Uses: compile.p
      Used by:
      Created: ?        Serge
     Modified: 14/07/97 Serge параметр файл со списком файлов для компиляции
*/

&GLOBAL-DEFINE PFILE "./pfiles.lst"

DEFINE VAR fnames     AS CHAR INIT ?   NO-UNDO.
DEFINE VAR mFlNames   AS CHAR          NO-UNDO. /* Измененный список файлов. */
DEFINE VAR promakedir AS CHAR INIT ?   NO-UNDO.
DEFINE VAR mFlList    AS CHAR          NO-UNDO. /* Измененный файл со списком.*/
DEFINE VAR slash      AS CHAR INIT "/" NO-UNDO.

DEFINE STREAM sInpFileDir. /* Входной поток. */
DEFINE STREAM outf.        /* Выходной поток. */

{globals.i new} /* NEW необходима, т.к. запуск будет осуществляться
                ** не толькот из под Бисквита. */

     /* Загрузка инструментов по работе с библиотеками. */
{face-pp.ld}

RUN CheckHandle IN h_base NO-ERROR.
IF ERROR-STATUS:ERROR
   THEN RUN base-pp.p PERSISTENT SET h_base.

{compile.def}   /* Определение переменных для компиляции. */
{compile.pro}   /* Инструменты для компиляции. */
{pfiles.pro}    /* Инструменты для работы с файлами. */
{promake.i}     /* Инструменты для компиляции. */

IF rdir = ""
   THEN rdir = ENTRY (1, PROPATH).

FORM
   fnames
      FORMAT "x(60)"
      LABEL "Файлы" 
      HELP "Введите маски файлов через пробел или запятую"
   promakedir
      FORMAT "x(60)"
      LABEL "Файл со списком фалов"
      HELP "Имя файла, содержащего список компилируемых файлов или ?"
   rdir
      HELP "Имя каталога, содержащего r-файлы"
   modpropath
      AT 18
      HELP "Добавлять к PROPATH каталог c исходным файлом и подкаталог 'i'?"
WITH
   1 COL
   CENTERED
   1 DOWN
   ROW 8
   OVERLAY
   FRAME inp-dir
   TITLE color bright-white "[ КОМПИЛЯЦИЯ ФАЙЛОВ ]".

ON RETURN OF modpropath IN FRAME inp-dir APPLY "GO" TO SELF.

REPEAT:
   PAUSE 0.
   UPDATE
      fnames
      promakedir
      rdir
      modpropath
   with frame inp-dir.

   IF fnames EQ ""
      THEN fnames = ?.

   IF promakedir EQ ""
      THEN promakedir = ?.

   IF    fnames      EQ ?
      OR promakedir  EQ ?
   THEN RETRY.

   RUN ParsStr (fnames,          /* Строка со списком файлов. */
                promakedir,      /* Файл со списком файлов для компиляции. */
                OUTPUT mFlNames, /* Значение для компиляции. */
                OUTPUT mFlList). /* Значение для компиляции. */

   /* Запуск компиляции. */
   RUN compile.p (
      mFlNames,      /* Файл для компиляции */
      mFlList,       /* Список файлов для компиляции */
      rdir,          /* Куда класть R-ки */
      YES,           /* preview always Yes */
      ?,             /* Путь и наименование LOG файла */
      modpropath).   /* Модифицировать propath. */

END.

HIDE frame inp-dir no-pause.

RETURN.

/* Разбор строки для компиляции. */
PROCEDURE ParsStr:
   DEFINE INPUT  PARAM iFiles  AS CHAR        NO-UNDO. /* Маски иили файлы. */
   DEFINE INPUT  PARAM IPfList AS CHAR        NO-UNDO. /* Список файлов. */
   DEFINE OUTPUT PARAM oFile   AS CHAR INIT ? NO-UNDO. /* Файл для компиляции. */
   DEFINE OUTPUT PARAM oPflist AS CHAR INIT ? NO-UNDO. /* Файл со списком. */
   
   DEFINE VAR vCnt    AS INT64  NO-UNDO. /* Счетчик. */
   DEFINE VAR vMask   AS CHAR NO-UNDO. /* Маска файла. */
   DEFINE VAR vPath   AS CHAR NO-UNDO. /* Пусть для поиска по маске. */
   DEFINE VAR vSchPth AS CHAR NO-UNDO. /* Список путей поиска. */

   /* Указан один файл. */
   IF NUM-ENTRIES (iFiles) EQ 1
      AND NOT FileOrMask (iFiles)
   THEN DO:
      oFile = iFiles.
      RETURN.
   END.

   /* Указана маска файлов. */
   ELSE DO:

      IF iFiles EQ ?
      THEN DO:
         oPflist = IPfList.
         RETURN.
      END.
      ELSE DO:

         /* Удаление файла со списком компиляции. */
         OS-DELETE VALUE ({&PFILE}).
         oPflist = {&PFILE}.

         DO vCnt = 1 TO NUM-ENTRIES (iFiles):

            /* Разбор строки на путь и маску. */
            RUN GetNmPth (
               ENTRY (vCnt, iFiles),   /* Исходная строка. */
               OUTPUT vPath,           /* Путь, в котором лежит указанный файл. */
               OUTPUT vMask).          /* Маска файла / имя файла. */

            /* Сбор фалов по маске. */
            RUN GetFileByMask (
               vPath,         /* Каталог поиска. */
               vMask,         /* Маска файла. */
               YES,           /* Признак поиска файлов в подкаталогах. */
               YES,           /* Указывать полный путь к файлам. */
               OUTPUT vSchPth /* Список каталогов поиска. */
            ).
         END.
      END.
   END.
   
   RETURN.
END PROCEDURE.

