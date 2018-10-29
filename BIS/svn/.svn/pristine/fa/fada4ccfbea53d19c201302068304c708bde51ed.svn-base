/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2002 ТОО "Банковские информационные системы"
     Filename: pirsavelog.p
      Comment: Сохранение имени пользователя , времени запуска и процедуры в лог файле
   Parameters: pName - имя запускаемого файла
         Uses:
      Used by:
      Created: 18/10/2007 anisimov 
*/

/*{globals.i}

DEFINE STREAM log-out-file.

FIND _user WHERE _user._userid EQ userid("bisquit") NO-LOCK NO-ERROR.

OUTPUT STREAM log-out-file TO "/home2/bis/quit41d/pir.log/run.log" APPEND.
PUT STREAM log-out-file UNFORMATTED string(today,"99.99.9999")  " " string(time,"HH:MM:SS") " " STRING(_user._userid,"XXXXXXXX") " " THIS-PROCEDURE:FILE-NAME SKIP.
OUTPUT STREAM log-out-file CLOSE.
*/