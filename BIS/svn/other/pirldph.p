{bislogin.i new}
DEFINE INPUT PARAMETER in-op-date AS DATE  NO-UNDO.
DEFINE INPUT PARAMETER iOpRID     AS RECID NO-UNDO.

def var tmpstr as char NO-UNDO.
def var card-num as char format "x(20)"  NO-UNDO.
def var phone-num as char format "x(15)"  NO-UNDO.
def var sms-status as char format "x(10)"  NO-UNDO.
def var sms-type as char init "" no-undo.
def var i_ok_read as int init 0 NO-UNDO.
def var i_ok_upd as int init 0  NO-UNDO.
def var i_ok_create as int init 0 NO-UNDO.
def var cnt_all as int init 0 NO-UNDO.
def var crd-cont-code as char no-undo init "" .
def var prim as char init "" no-undo.
def var eml as char init "mzorin@pirbank.ru" no-undo .
def var protfile as char init "/home2/bis/quit41d/imp-exp/protocol/phone-load"  NO-UNDO.

define variable mFilename as char no-undo 
  view-as fill-in size 40 by 1 
  label "Файл" format "X(250)" .

form 
  mFileName Help "Выберите файл (F1 - выбор)"
with frame mFrame 1 COLUMNS SIDE-LABELS OVERLAY CENTERED TITLE "[Загрузка]" .

ON F1 of mFileName in Frame mFrame do:
 run ch-file.p (INPUT-OUTPUT mFileName) .
 Display mFileName with Frame mFrame.
 Return No-Apply.
end.
on end-error of frame mFrame do:
 hide frame mFrame.
end. 

update mFileName with Frame mFrame.
hide frame mFrame.

if search(mFileName) = ? then do: 
 message "Файл для загрузки не выбран" + chr(10) +
         "       или не найден!" .
   leave.
end.         

protfile = protfile + string ( TODAY,"99-99-9999" ) + string(TIME) + ".txt" .

output to value (protfile). 

find last signs where signs.file-name = "_user"
         and signs.code = "e-mail"
         and signs.surrogate = UserId no-lock no-error .
         if avail signs then eml = signs.xattr-value .

/*put unformatted "To: " eml skip.
put unformatted "Content-Type: text/plain; charset = ibm866" skip.
put unformatted "Content-Transfer-Encoding: 8bit" skip.        
put unformatted "Subject: Протокол загрузки данных SMS-Bank" skip skip.    */
put unformatted "Протокол загрузки данных:"  skip.
put unformatted "Дата загрузки: " + string(TODAY, "99/99/9999") skip .
put unformatted "Время загрузки: " + string (Time, "HH:MM:SS") skip .
put unformatted "|Номер карты     | Телефон  |Стс|Тип| Результат " skip .


input from value(mFileName). 

repeat : 
  
  import tmpstr .

  if trim (tmpstr) = "" then next. 

  cnt_all = cnt_all + 1 .

  card-num = entry ( 1 , tmpstr, ";" ) .
  phone-num = entry ( 2, tmpstr, ";" ) .
  sms-status = entry ( 3, tmpstr, ";" ) .
  sms-type = entry (4, tmpstr, ";") .
  
  if card-num = "" or phone-num = "" or sms-status = "" 
   or sms-type = "" then
    do:
    message "Ошибка в строке " + string(cnt_all) view-as alert-box.
    next .
    end.

  i_ok_read = i_ok_read + 1 .
  
  find first loan where loan.contract = "card"
                    and loan.doc-num = card-num no-lock no-error.
  if avail (loan) then
  do:                 
   crd-cont-code = loan.cont-code .        
   run CreateXattr.  
  end.
  if not avail loan then do:
   message "Карта №" + card-num + chr(10) +
          "не найдена в базе Бисквит!" view-as alert-box.
    prim = "ОШИБКА: Карта найдена в базе Бисквит!" .
   end.
 put unformatted "|" card-num "|" phone-num "|" sms-status "|" sms-type "|" prim skip. 
end. 

message "Прочитано всего   : " +  string(cnt_all) + chr(10) +
        "Корректных записей: " +  string(i_ok_read) + chr(10) +
        "Создано записей   : " +  string(i_ok_create) + chr(10) +
        "Обновлено записей: " +  string(i_ok_upd) 
        
         view-as alert-box.

put unformatted "Прочитано всего   : " +  string(cnt_all) + chr(10) +
        "Корректных записей: " +  string(i_ok_read) + chr(10) +
        "Создано записей   : " +  string(i_ok_create) + chr(10) +
        "Обновлено записей: " +  string(i_ok_upd) skip.

output close .
{setdest.i}
{preview.i &filename = protfile  } .

Procedure CreateXattr. /* Проверяет наличие д/р, изменяет или создает д/р */

find tmpsigns where tmpsigns.code = "CliMobPhone" and 
  tmpsigns.file-name = "loan" and 
  tmpsigns.surrogate = "card," + crd-cont-code 
  and tmpsigns.since = TODAY exclusive-lock no-error .
  if avail (tmpsigns) then do: 
    tmpsigns.xattr-value = phone-num .
    prim = "Обновлена иформация" .
    i_ok_upd = i_ok_upd + 1 . 
end.
  
  if not avail(tmpsigns) then do:
  create tmpsigns.
  assign 
   tmpsigns.code = "CliMobPhone" 
   tmpsigns.file-name = "loan" 
   tmpsigns.surrogate = "card," + crd-cont-code 
   tmpsigns.xattr-value = phone-num 
   tmpsigns.since = TODAY .
   i_ok_create = i_ok_create + 1 .
   prim = "Создана" .
  end.
  
 
 find tmpsigns where tmpsigns.code = "CliMobStatus" and
    tmpsigns.file-name = "loan" 
    and tmpsigns.surrogate = "card," + crd-cont-code  
    and tmpsigns.since = TODAY exclusive-lock no-error.

  if avail (tmpsigns) then do:
     tmpsigns.xattr-value = sms-status .
  end.
     
  if not avail tmpsigns then do :
     create tmpsigns.
       assign
       tmpsigns.code = "CliMobStatus"
       tmpsigns.file-name = "loan"
       tmpsigns.surrogate = "card," + crd-cont-code
       tmpsigns.xattr-value = sms-status.
       tmpsigns.since = TODAY .
     end.

 find tmpsigns where tmpsigns.code = "CliMobType" and
     tmpsigns.file-name = "loan"
 and tmpsigns.surrogate = "card," + crd-cont-code
 and tmpsigns.since = TODAY exclusive-lock no-error.
             
 if avail (tmpsigns) then do:
    tmpsigns.xattr-value = sms-type .
  end.
         
 if not avail tmpsigns then do :
  create tmpsigns.
  assign
    tmpsigns.code = "CliMobType"
    tmpsigns.file-name = "loan"
    tmpsigns.surrogate = "card," + crd-cont-code
    tmpsigns.xattr-value = sms-type.
    tmpsigns.since = TODAY .
  end.

end.
