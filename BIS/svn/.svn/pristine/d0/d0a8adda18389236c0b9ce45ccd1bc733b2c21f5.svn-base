/* Импорт Купонов ценной бумаги. Импорт из Q:\users\...\kupon.txt в Ценная бумага - Купоны.
Импорт из первого и второго столбца через Tab. другие стоблцы пропускаются.
Перед созданием купонов, все имеющиеся на ценной бумаге купоны удаляются. 
Поэтому добавить новые через импорт нельзя, только полностью замена.
Никитина Ю.А. 01.02.2013
*/

{globals.i}
{intrface.get instrum}

DEF VAR oTable AS TTable2 NO-UNDO.
DEFINE VARIABLE msec-code AS CHARACTER NO-UNDO.
DEF VAR oARow    AS TAArray    NO-UNDO.
DEF VAR key1     AS CHAR NO-UNDO.
DEF VAR val1     AS CHAR NO-UNDO.
DEF VAR mFN      AS CHAR NO-UNDO.
DEF VAR mSince       AS DATE    NO-UNDO.
DEF VAR mRate-instr  AS DECIMAL NO-UNDO.

    form
    "Код ценной бумаги :" msec-code no-label skip
     with frame wow CENTERED OVERLAY ROW 10 SIDE-LABELS TITLE
          COLOR bright-white "[ ]".
    pause 0.

    do transaction with frame wow:
	update msec-code editing: readkey.
	        if lastkey eq keycode('F1') AND (frame-field EQ 'msec-code') then do:
       		       RUN browseld.p ('sec-code','','',?,4) NO-ERROR.
       			if lastkey eq 10 then do:
				disp pick-value @ msec-code. 
			end.
	        end.
         	else apply lastkey.
 	end.
    end.

    HIDE FRAME wow NO-PAUSE.
    if lastkey eq 27 then do:
       HIDE FRAME wow.
       return.
    end.  
/*здесь должен лежать файл с купонами*/
mFN = "/home2/bis/quit41d/imp-exp/users/" + LOWER(userid("bisquit")) + "/kupon.txt".

/*удаляем все купоны, которые есть на данной ценной бумаге*/
for each instr-rate where instr-rate.instr-code EQ msec-code 
                               AND instr-rate.rate-type  EQ "Купон" 
                               AND instr-rate.instr-cat  EQ "sec-code" no-lock:
  RUN DelRate ("sec-code","Купон",msec-code,instr-rate.since,YES).
end.

oTable = new TTable2().
/*загружаем в таблицу файл с купонами*/
oTable:LoadFromCSV(mFN,"~t").

oTable:rewind().
/*из таблицы создаем купоны*/
DO WHILE NOT oTable:valid():
  oARow = oTable:next(). 
  {foreach oARow key1 val1}
    if key1 = "1" then do:
      mSince = DATE(val1).
    end.
    if key1 = "2" then do:
      mRate-instr = dec(REPLACE(val1,",",".")).
    end.
  {endforeach oARow} 
  RUN UpdateRate("sec-code","Купон",msec-code,mSince,mRate-instr,1.0 ,YES).	
END.


DELETE OBJECT oTable.
