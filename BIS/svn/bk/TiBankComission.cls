CLASS TiBankComission IMPLEMENTS ISysComprasion:

/*************************************************************
 *													                                                                   *
 * Сверка комиссии Банк-Клиент			                                               *
 * 														                                                           *
 * Алгоритм:                                                                                                *
 * 1. Пользователь из Архива документов по фильтру отбирает     *
 * документы списания комиссии;                                                         *
 * 2.  Переходит в Ctrl + G -> Технологические операции ->             *
 * Сверка комиссии Банк-Клиент;                                                         *
 * 3. Процедура формирует ведомость счетов по ДБ по которым    *
 * есть списание;                                                                                         *
 * 4. Получившаяся ведомость передается в каталог на сервере    *
 * БК (по scp);                                                                                              *
 * 5. Там запускается скрипт контроля клиентов по которым         *
 * списана комиссия.                                                                                  *
 * 6. Результат работы которого отображается на экране БИС        *
 *************************************************************
 * Автор: Маслов Д. А.                                                                              *
 * Дата создания: 10:44 05.05.2010                                                           *
 * Заявка: #223                                                                                            *
 **************************************************************/

DEF VAR httTable    AS HANDLE NO-UNDO.
DEF PUBLIC VAR oTpl AS TTpl   NO-UNDO.

{set-prop.i &aa="firstSource"  &bb="cfirstSource"  &cc="CHARACTER"}       /* Файл в который попадают данные после выгрузки из БИСА   */
{set-prop.i &aa="secSource"   &bb="csecSource"   &cc="CHARACTER"}       /* Файл в котором возвращается результат из БАНК-КЛИЕНТА */
{set-prop.i &aa="secProvider" &bb="csecProvide" &cc="CHARACTER"}       /* ТРАНСПОРТ данных из БИСА до БАНК-КЛИЕНТ                      */

CONSTRUCTOR TiBankComission():
    oTpl = new TTpl("TiBankComission.tpl").
END CONSTRUCTOR.

METHOD PUBLIC LOGICAL load2First():
			/***********************************
             *                                                                 *
			 * Получаем данные из БИС.  		        *
             * Которые затем выгружаем в XML *
             *                                                                 *
             ***********************************/
/*
CREATE TEMP-TABLE httTable.
httTable:ADD-NEW-FIELD("cAcct","CHARACTER",0,"cAcct","").

     FOR EACH tmprecid, 
        FIRST op WHERE tmprecid.id = RECID(op), 
            FIRST op-entry WHERE op-entry.op = op.op:

                     /* По всем отобранным документам */
                    httTable:DEFAULT-BUFFER-HANDLE:BUFFER-CREATE().
                    httTable::cAcct = op-entry.acct-db.

END.
httTable:SAVE-XML("FILE",firstSource,?,?,?,?).

EMPTY TEMP-TABLE httTable.
httTable = ?.
*/
END METHOD.

METHOD PUBLIC LOGICAL load2Second():

                    /********************************************
                     * Данные полученные из БИС,                            *
                     * передаем в Банк-Клиент. Запускаем там       *
                     * обработчик и ожидаем ответа. Полученную  *
                     * информацию помещаем в таблицу.                  *
                     *                                                                                   *
                     *********************************************/
 
    OS-COMMAND SILENT VALUE('scp ' + firstSource + ' mover@ciklop:/tmp/vigr.xml').                              /* Копируем файл выгрузки */
/*    OS-COMMAND SILENT VALUE("rm -f " + firstSource).                                                                               /* Удаляем файл с данными */*/
    OS-COMMAND SILENT 'ssh mover@ciklop "/usr/local/iBank2Bisquit/bin/getXmlCompCom.php"'.         /* Запускаем выгрузку данных из БК */
    OS-COMMAND SILENT VALUE('scp mover@ciklop:/tmp/res.xml ' + secSource).         /* Копируем файл */
    OS-COMMAND SILENT 'ssh mover@ciklop "rm -f /tmp/res.xml"'.                                                               /* Удаляем файл с БК */

    CREATE TEMP-TABLE httTable.                                 /* Создаем временную таблицу с результатом */
    httTable:READ-XML("FILE",secSource,?,?,?,?).       /* Загружаем в нее данные */

/*    OS-COMMAND SILENT 'rm -f /home2/bis/quit41d/imp-exp/bifit/res.xml'.         /* Удаляем файл с БИС*/ */

END METHOD.

METHOD PROTECTED VOID inFirstButNotInSec():
                /**********************************************
                 *                                                                                      *
                 * Выводит всех клиентов которые есть                *
                 * в БК, но с которых НЕ СПИСАНА                       *
                 * комиссия.                                                                   *
                 *                                                                                      *
                 **********************************************/
    DEF VAR hQuery  AS HANDLE NO-UNDO.
    DEF VAR hBuffer AS HANDLE NO-UNDO.

    DEF VAR oTable AS TTable NO-UNDO.
    oTable = new TTable(2).

    CREATE QUERY hQuery.
    hQuery:SET-BUFFERS(httTable:DEFAULT-BUFFER-HANDLE).
    hQuery:QUERY-PREPARE("FOR EACH httTable WHERE lStatus='2'").
    hQuery:QUERY-OPEN(). 
    hQuery:GET-FIRST(NO-LOCK).

   hBuffer=hQuery:GET-BUFFER-HANDLE.
    
    REPEAT WHILE NOT hQuery:QUERY-OFF-END:
            oTable:addRow().
               oTable:addCell(hBuffer::iClientId).
               oTable:addCell(hBuffer::cClientName).
             hQuery:GET-NEXT(NO-LOCK).
    END.

  IF oTable:height GT 0 THEN  oTpl:addAnchorValue("TABLE-",oTable). ELSE oTpl:addAnchorValue("TABLE-","*** ДАННЫХ НЕТ ***").
END METHOD.

METHOD PROTECTED VOID inSecButNotInFirst():

                /**********************************************
                 *                                                                                        *
                 * Выводит всех клиентов которые                           *
                 * заблокированы в БК, но с которых  СПИСАНА  *
                 * комиссия.                                                                     *
                 *                                                                                        *
                 ***********************************************/

    DEF VAR hQuery  AS HANDLE NO-UNDO.
    DEF VAR hBuffer AS HANDLE NO-UNDO.
    DEF VAR oTable  AS TTable NO-UNDO.
    
    oTable = new TTable(2).

    CREATE QUERY hQuery.
    hQuery:SET-BUFFERS(httTable:DEFAULT-BUFFER-HANDLE).
    hQuery:QUERY-PREPARE("FOR EACH httTable WHERE lStatus='1'").
    hQuery:QUERY-OPEN(). 
    hQuery:GET-FIRST(NO-LOCK).

   hBuffer=hQuery:GET-BUFFER-HANDLE.
    
    REPEAT WHILE NOT hQuery:QUERY-OFF-END:
            oTable:addRow().
               oTable:addCell(hBuffer::iClientId).
               oTable:addCell(hBuffer::cClientName).
               hQuery:GET-NEXT(NO-LOCK).
    END.

   IF oTable:height GT 0 THEN oTpl:addAnchorValue("TABLE+",oTable). ELSE oTpl:addAnchorValue("TABLE+","*** ДАННЫХ НЕТ ***").

END METHOD.

METHOD PUBLIC LOGICAL exec():
load2First().
load2Second().

inFirstButNotInSec().

inSecButNotInFirst().

oTpl:show().

END METHOD.

DESTRUCTOR TiBankComission():
    DELETE OBJECT oTpl.
END DESTRUCTOR.

END CLASS.