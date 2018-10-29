/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2002 ТОО "Банковские информационные системы"
     Filename: pfiles.lst
      Comment: функции для работы с файлом перекомпиляции
   Parameters:
         Uses:
      Used by:
      Created: 19.02.2002 serge
     Modified: 01.11.2008 20:20 KSV      (0100636) QBIS. Инициализация bqxref
     Modified: <date> <who> <comment>
*/

def var bqxref as char no-undo.
bqxref = os-getenv("BQ") + slash + "bisquit.xref".

&IF DEFINED(SESSION-REMOTE) &THEN
bqxref = OS-GETENV("BQ_XREF_FILE").
&ENDIF

def var p-count as INT64 no-undo.
def var p-allcount as INT64 no-undo.

def temp-table p-files no-undo
   field fname as char
   index fname is unique fname
.
def stream fxref.

procedure AddPFile.
   def input param in-fname as char no-undo.

   find p-files where p-files.fname = in-fname no-error.
   if not avail p-files then do:
      create p-files.
      p-files.fname = in-fname.
      p-count = p-count + 1.
   end.
end procedure.

procedure ReadPFiles.
   def input param pdir as char no-undo.
   def var srcfile as char no-undo.

   for each p-files: delete p-files. end.
   if search(pdir + "pfiles.lst") = ? then return.

   input from pfiles.lst.
   repeat:
       import srcfile.
       run AddPFile(srcfile).
   end.
   input close.
end procedure.

procedure CreatePFiles.
   def input param fnames as char no-undo.
   def input param ip-method as char no-undo.

   def var srcfile as char no-undo.
   def var dstfile as char no-undo.
   def var method as char no-undo.
   def var j as INT64 no-undo.

   p-count = 0.
   do j = 1 to num-entries(fnames):
      if substr(entry(j,fnames),length(entry(j,fnames)) - 1) eq ".p" then
         run AddPFile(entry(j,fnames)).
   end.
   input stream fxref from value(search(bqxref)).
   {bar-beg.i fxref}
   repeat:
      import stream fxref srcfile dstfile method.
      {bar.i fxref}
      if lookup(dstfile, fnames) > 0 AND CAN-DO(ip-method, method) then
         run AddPFile(srcfile).
   end.
   input stream fxref close.
   status default.
end procedure.

procedure WritePFiles.
   def input param pdir as char no-undo.

   output stream outf to value(pdir + "pfiles.lst").
   p-allcount = 0.
   for each p-files:
      /*** Маслов Д. А. Maslov D. A. Временно ***/
      put stream outf unformatted p-files.fname skip.
      p-allcount = p-allcount + 1.
   end.
   output stream outf close.
end procedure.
