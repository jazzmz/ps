{pirsavelog.p}
/*
File: vtb-uvd.p
Comment: Печать извещений о поступлении средств на транз.валютный счет
         и рубл. расч.счет по операциям внешн.экономичю деятельности.
Programmer: mitr@bis.ru
Date: 5/7/2002

*/
{globals.i}
define input param in-files as char no-undo. /* список имен файлов с текстами шаблонов */

def var  page-width as integer initial 79 .  /* ширина страницы */

&SCOP OFFSET_VAL 480 /* сдвиг от верхнего края страницы */
def stream macro-file.
def var init-str as char no-undo.
def var reset-str as char no-undo.
def buffer xprinter for printer.
DEF VAR macro-prn AS LOG INIT FALSE.
DEF VAR buf-str AS CHARACTER NO-UNDO.

{get_set2.i "Принтер" "PCL" "w/o chek"}

if ((not avail(setting) or (avail(setting) and trim(setting.val) = "")) and
    usr-printer begins "+") or
   (avail(setting) and can-do(setting.val, usr-printer)) then do:

  {0401060.prg}






  assign
    init-str = ""
    reset-str = ""
  . /* assign */

  find first xprinter
    where xprinter.printer = usr-printer and
          xprinter.page-cols <= 80
    no-lock no-error
  . /* find first xprinter */

  if avail(xprinter) then do:

    if xprinter.init-string <> ? and
       trim(xprinter.init-string) <> "" then do:
      init-str = vf_xcode(xprinter.init-string).
    end. /* if xprinter.init-string <> ? and */

    if xprinter.reset-string <> ? and
       trim(xprinter.reset-string) <> "" then do:
      reset-str = vf_xcode(xprinter.reset-string).
    end. /* if xprinter.reset-string <> ? and  */

  end. /* if avail(xprinter) */

  output stream macro-file to "_macro.tmp".
  if init-str <> "" then  do:
    put stream macro-file unformatted
      init-str.
  end.
  macro-prn = true.
end.






if num-entries(in-files) = 3 then do:
  assign page-width = integer(entry(3, in-files)) no-error. 
end.



if num-entries(in-files) < 2 then do:
  message "Во входном параметре необходимо указать 2 шаблона  "
  view-as alert-box.
  return.
end.

{tmprecid.def}        /** Используем информацию из броузера */
def var h as handle no-undo.
run pir-uvdp.p persistent set h . 

{setdest.i  &cols=" + page-width" }
do on error undo, leave:
   for each tmprecid,
      first op where recid(op) = tmprecid.id no-lock :
      find first op-entry of op no-lock no-error.
      if avail op-entry then do:
         run setRecid in h (recid(op)).
         if op-entry.currency eq "" 
         then run vtb-nrof.p (entry(1, in-files), PAGE-WIDTH, macro-prn, INPUT-OUTPUT buf-str).
         else run vtb-nrof.p (entry(2, in-files), page-width, macro-prn, INPUT-OUTPUT buf-str).

         IF macro-prn THEN DO:
            put stream macro-file unformatted buf-str .
            put stream macro-file unformatted CHR(27) + CHR(38) + "l0H" .
         END.

         page.
      end.
   end.
end.
if valid-handle(h) then delete procedure h. 


if macro-prn then do:  
  if reset-str <> "" then do:
    put stream macro-file unformatted
      reset-str.
  end.

  output stream macro-file close.
end.

{preview.i }
