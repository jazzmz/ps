{bislogin.i new}
def var dd as char init "01" no-undo .
def var mm as char init "01" no-undo .
def var yy as char init "2011" no-undo .
def var path as char init "/home2/bis/quit41d/imp-exp/Arhiv/" no-undo.
def var day_path as char init "" no-undo .
def var day-num as int init 0 no-undo.
def var dt as DATE no-undo .
def var fname as char init "" no-undo .
def var fname-n as char init "" no-undo .

/* Запрашиваем период */
{getdates.i}
if beg-date = ? or end-date  = ? then do:
  message " Неопределенный период !"  view-as alert-box .
  leave .
end. 

output to report.txt .

Put unformatted "     Сформированные выходные формы за период" 
                + chr(10) + Fill(" ",10) + "c " + string( beg-date, "99/99/9999" )
                + " по " + string( end-date, "99/99/9999" ) skip . 
Put unformatted 
 " ________________________________________________________________________" 
  skip .  
               

do dt = beg-date to end-date : 
 find op-date where op-date.op-date = dt no-lock no-error . 
 if not avail op-date then next .

 dd = Substr(string(dt,"99/99/9999"), 1, 2 ) .
 mm = Substr(string(dt,"99/99/9999"), 4, 2 ) .
 yy = Substr(string(dt,"99/99/9999"), 7, 4 ) .
 day_path = path + yy + "/" + mm + "/" + dd + "/" .
 day-num = INT(dt) - INT(DATE(01,01,INT(yy))) .
 
 put unformatted "Информация за " + string(dt, "99-99-9999") skip .
 put unformatted "------------------------- " skip.
 run getdayinfo.
 put unformatted "==================================================" skip .
end.
{setdest.i}
{preview.i &filename = 'report.txt' } .


procedure getDayInfo .

for each code where code.class = "ArhiveForms" no-lock : 

fname = code.val .
fname = replace(fname, "<nnn>", string(day-num, "999") ) .

FILE-INFO:FILE-NAME = day_path + fname .

if FILE-INFO:FILE-MOD-DATE <> ? then
put unformatted
   string(code.name,"x(30)") + "|" +  string(fname,"x(25)") + "|"
   string(File-info:File-mod-date,"99/99/9999") + " " +
   string(file-info:file-mod-time,"HH:MM:SS") skip.
else 
put unformatted
   string(code.name,"x(30)") + "|" +  string(fname,"x(25)") + "|"
   skip.
end.

end.
