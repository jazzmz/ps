{pirsavelog.p}

/*          
    Copyright: (C) ОАО КБ "Пpоминвестрасчет"
     Filename: pir-repafiletr.p
      Comment: Отчет по экспорту ПОРУЧЕНИЙ Application.
		Отчет выводится в конце транзакции e-ucsia по конкретному 
		сеансу экспорта
		Запуск производится в шаблоне транзакции
      Used by:
      Created: 22.04.2011 - Ситов С.А.
*/

{globals.i}                                                                      

DEFINE INPUT  PARAMETER inparam AS char NO-UNDO.

DEF VAR i AS int INIT 0 NO-UNDO.
DEF VAR SeanceID AS INT NO-UNDO.
DEF VAR jourfile AS CHAR NO-UNDO.

DEF BUFFER mop-int FOR op-int.
DEF BUFFER mcard   FOR loan.

DEF BUFFER mPackObject FOR PackObject.
DEF BUFFER mPacket     FOR Packet.    
DEF BUFFER mSeance     FOR Seance.
DEF BUFFER mFileExch  FOR FileExch.

SeanceID = INT(entry(1,inparam,"/")) .
jourfile = "/home/bis/quit41d/imp-exp/protocol/" + entry(2,inparam,"/") .

{get-bankname.i}

{setdest.i &filename=jourfile}


PUT UNFORM SKIP(2).
PUT UNFORM FILL(" ",10)  "ПРИЛОЖЕНИЕ №1"  SKIP.
PUT UNFORM FILL(" ",10)  cBankName SKIP(2).
PUT UNFORM FILL(" ",40)  "ОТЧЕТ ОТПРАВЛЕННЫХ ДАННЫХ ЗА " string(TODAY,"99/99/9999")  " г. "  /*"ФАЙЛ " tmpfile*/ SKIP(2).

PUT UNFORM "| N пп| "
	"   НОМЕР КАРТЫ   | "
	"Г | "
	"                   ДЕРЖАТЕЛЬ                  | "
	"          ОПЕРАЦИИ ПО ПЦ         | "
	"      № ФАЙЛА     |"
SKIP(1).


FOR EACH mop-int WHERE  mop-int.file-name = 'loan'
  AND mop-int.surrogate begins 'card,'
  AND can-do('КартОткрОсн,КартОткрДоп,КартПеревып,КартИзм',mop-int.class-code)
  AND can-do('ФЙЛ,ОШБ,ОТМ',mop-int.op-int-status) 
  AND mop-int.create-date =  TODAY 
  NO-LOCK,
FIRST mcard
WHERE mcard.contract = 'card'
  AND mcard.cont-code = entry(2,mop-int.surrogate)
  NO-LOCK,
FIRST mPackObject
WHERE mPackObject.file-name EQ 'op-int'
  AND mPackObject.Surrogate EQ string(mop-int.op-int-id)
  NO-LOCK,
FIRST mPacket
WHERE mPacket.PacketID EQ mPackObject.PacketID
  AND mPacket.SeanceID EQ SeanceID 
  NO-LOCK,
FIRST mSeance
WHERE mSeance.SeanceID EQ mPacket.SeanceID
  NO-LOCK,
FIRST mFileExch
WHERE mFileExch.SeanceID = mSeance.SeanceID
NO-LOCK:

  i = i + 1 .
  
  FIND FIRST person WHERE person.person-id = mcard.cust-id NO-LOCK NO-ERROR.

  PUT UNFORM	"| " string(i,"999") " | " 
		string(mcard.doc-num,"X(16)")   " | " 
		(if mcard.loan-work = yes then "+"  else " ")  " | "
		string(person.name-last + " " + person.first-name,"X(45)") " | "
		string(mop-int.op-int-status,"X(4)") " " mop-int.create-date " " string(mop-int.create-time,"HH:MM") " " string(mop-int.op-int-code,"X(12)") " | " 
		string(mFileExch.Name,"X(17)") " | "
	/*	mop-int.op-int-id " | " 
		mFileExch.SeanceID
	*/
  SKIP.

END.


PUT UNFORM SKIP(2).
PUT UNFORM " ИТОГО: количество ПК - " i SKIP(2).


  /* Исполнитель */

FIND FIRST code WHERE code.class EQ "PirU11Podpisi"
  AND code.parent EQ "PirU11Podpisi"
  AND code.code = userid("bisquit") NO-LOCK NO-ERROR.

  PUT UNFORM " " code.name SKIP(1).

  PUT UNFORM " " string(TODAY,"99/99/9999") " " string(TIME,"HH:MM:SS") SKIP(2).

{preview.i &filename=jourfile}