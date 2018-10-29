/* Сбор файлов по подкаталогам. */
PROCEDURE GetFileByMask.

   def input  param ipSrcChar  as char no-undo. /* Каталог */
   def input  param ipMaskChar as char no-undo. /* Маска файла. */
   def input  param ipSubLog   as log  no-undo. /* Искать по под директориям. */
   def input  param ipFulPath  as log  no-undo. /* Указывать полный путь. */
   def output param opPathChar as char no-undo. /* Путь сбора файлов. */

   def var vDirChar   as char no-undo. /* Элемент потока */
   def var vCountInt  as INT64  no-undo. /* Счетчик */
   def var vFileChar  as char no-undo. /* Наименование файла. */

   /* Формирование pfiles.lst */
   run ReadPFiles ("." + slash()).

   ASSIGN
      /* Корректировка маски, т.к. символ "."
      ** воспринимается как любой символ. */
      ipMaskChar  = replace (ipMaskChar, ".", "~~.")
      p-count     = 0
      opPathChar  = ""
   .

   DO vCountInt = 1 TO NUM-ENTRIES(ipSrcChar):
      /* Поиск подкаталогов. */
      IF ipSubLog THEN 
         RUN dir.p (ENTRY(vCountInt,ipSrcChar), ipSubLog, INPUT-OUTPUT opPathChar).
      /* Формирование итогового пути для поиска. */
         {additem.i opPathChar ENTRY(vCountInt,ipSrcChar)}
   END.

   do vCountInt = 1 to num-entries (opPathChar):

      input stream sInpFileDir from os-dir(entry(vCountInt, opPathChar)).

      repeat:
         import stream sInpFileDir unformatted vDirChar.

         if entry (3, vDirChar, " ") eq "F"
         then do:

            vFileChar = trim(entry(1, vDirChar, " "), """").

            if can-do (ipMaskChar, vFileChar)
            then do:

               /* Формирование списка файлов. */
               IF ipFulPath
                  THEN vFileChar = entry(vCountInt, opPathChar) +
                                   slash () + vFileChar.

               run AddPFile (vFileChar).

            end.
         end.
      end.
   end.

   /* Формирвоание pfiles.lst */
   run WritePFiles ("." + slash()).

   return.

END PROCEDURE.
