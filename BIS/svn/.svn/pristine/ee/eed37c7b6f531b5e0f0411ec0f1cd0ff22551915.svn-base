{pirsavelog.p}

/* ---------------------------------------------------------------------
File       : $RCSfile: pir-view.p,v $ $Revision: 1.3 $ $Date: 2007-10-18 07:42:21 $
Copyright  : (C) 2007, КБ ООО "Пpоминвестрасчет"
Function   : Запуск процедуры и просмотр файла протокола 
Created    : 03.05.2007 11:53 lavrinenko
Modified   : $Log: not supported by cvs2svn $
Modified   : Revision 1.2  2007/05/24 06:58:54  lavrinenko
Modified   : ╨║╨╛╤Б╨╝╨╡╤В╨╕╤З╨╡╤Б╨║╨╕╨╡ ╨┤╨╛╤А╨░╨▒╨╛╤В╨║╨╕
Modified   :
---------------------------------------------------------------------- */
DEFINE INPUT PARAMETER ipDataID AS INTEGER NO-UNDO.
DEFINE INPUT PARAMETER ipParams AS CHAR		 NO-UNDO.

DEFINE NEW GLOBAL SHARED VAR usr-printer LIKE printer.printer NO-UNDO.

DEFINE VAR j 				AS INTEGER NO-UNDO.
DEFINE VAR ProcName	AS CHAR    NO-UNDO.
DEFINE VAR LOGName	AS CHAR    NO-UNDO.

ASSIGN 
	ProcName = ENTRY(1,ipParams)
	LogName  = ENTRY(2,ipParams)
.

RUN VALUE(ProcName) (INPUT ipDataID). 

   
FIND FIRST printer WHERE printer.printer EQ usr-printer 
          					 AND printer.page-cols GE 0{&cols}
      								NO-LOCK NO-ERROR.
   
IF NOT AVAIL printer THEN 
   FIND LAST PRINTER WHERE printer.printer EQ usr-printer NO-LOCK NO-ERROR.
     
IF NOT AVAIL printer THEN DO:
  MESSAGE 'Принтер "' usr-printer '" был удален!' VIEW-AS ALERT-BOX ERROR.
  RETURN.
END.

RUN previewi.p (BUFFER printer, LogName, 0, 0).