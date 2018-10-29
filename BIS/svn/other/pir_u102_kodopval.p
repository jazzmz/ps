/* ========================================================================= */
/** 
    Copyright: ООО ПИР Банк, Управление автоматизации (C) 2013
     Filename: pir_u102_kodopval.p
      Comment: Процедура проставляет доп.реквизит КодОпВал117 по группе документов
		Документы отбирает сотрудник по фильтру
		Задает значение КодОпВал117, а процедура массово проставляет ДР на документах
		с учетом маски заполнения этого доп.реквизита
   Parameters: 
       Launch: БМ - Опер.день - Отмечаем нужные документы, CTRl+G - ПИР: Простановка ДР КодОпВал117 на документах
      Created: Sitov S.A., 2013-10-01
	Basis: # 3781
     Modified: <Кто> <Когда [F7]> (Локальный код для поиска <уникальный_код>) 
               <Описание изменения>                                           
*/
/* ========================================================================= */


{globals.i}
{intrface.get xclass}  
{intrface.get tmess} 
{tmprecid.def}




/* =========================   ОБЪЯВЛЕНИЯ   ================================= */

DEF VAR vAllAmt		AS DEC  NO-UNDO.
DEF VAR vKolOpEntry	AS DEC  NO-UNDO.

DEF VAR vDRValue	AS CHAR NO-UNDO.
DEF VAR vKodOpVal	AS CHAR NO-UNDO.

DEF TEMP-TABLE tt
	FIELD id AS INT64 
.

FOR EACH tmprecid NO-LOCK:
  CREATE tt.
  tt.id = tmprecid.id . 
END.



/* =========================   РЕАЛИЗАЦИЯ   ================================= */

FORM
   vKodOpVal   FORMAT "X(10)"	LABEL  "КодОпВал117"  HELP   "КодОпВал"
WITH FRAME frm01 1 COL OVERLAY CENTERED ROW 10 TITLE "[ ВВЕДИТЕ КодОпВал117 ДЛЯ ВСЕХ ДОКУМЕНТОВ ]".


ON "F1" OF vKodOpVal IN FRAME frm01
DO:
   pick-value = ?. 
   DO TRANSACTION:

      RUN codelay.p("КодОпВал117", "КодОпВал117", "КОДЫ ОПЕРАЦИЙ ВАЛЮТНОГО КОНТРОЛЯ", 4).
   
      IF LAST-EVENT:FUNCTION NE "END-ERROR"  AND  pick-value <> ? THEN 
      DO:
         vKodOpVal:SCREEN-VALUE = pick-value . 

         IF  CAN-FIND(FIRST code WHERE code.class  = "КодОпВал117" AND code.parent = TRIM(pick-value))  AND LENGTH(pick-value) < 5  THEN 
         DO:
            RUN Fill-SysMes ("", "", "-1", "У параметра " + vKodOpVal + " есть подпараметры. Выберите подпараметр." ).
            RETURN NO-APPLY.
         END.

         vKodOpVal = pick-value NO-ERROR.
         vKodOpVal:SCREEN-VALUE = pick-value.

      END.

      RETURN NO-APPLY.
   END.

END.



ON "ENTER" OF FRAME frm01 ANYWHERE 
DO:
    APPLY "TAB" TO SELF. 
END.

ON "GO" OF FRAME frm01 ANYWHERE 
DO:
   ASSIGN
     vKodOpVal 
  .
  IF NOT CAN-FIND(FIRST code WHERE code.class = "КодОпВал117" AND code.parent <> "КодОпВал117"  AND code.code  = vKodOpVal ) THEN
  DO:
     RUN Fill-SysMes ("", "", "-1", "Отсутствует классификатор КодОпВал117 с кодом " + vKodOpVal ).
     APPLY "Entry" TO vKodOpVal  IN FRAME frm01.
     RETURN NO-APPLY.
  END.
END.



DO TRANSACTION
  ON ERROR  UNDO, RETRY 
  ON ENDKEY UNDO, RETURN 
WITH FRAME frm01 :
   PAUSE 0.
   UPDATE 
     vKodOpVal
   .
END.
	

HIDE FRAME frm01 NO-PAUSE.


IF NOT ( KEYFUNC(LASTKEY) = "GO" OR KEYFUNC(LASTKEY) = "RETURN") THEN 
  LEAVE.




/* =========================   РЕАЛИЗАЦИЯ   ================================= */
{setdest.i}

FOR EACH tt,
FIRST op WHERE RECID(op) EQ tt.id 
NO-LOCK:

  vKolOpEntry = 0 .
  vAllAmt = 0 .

  FOR EACH  op-entry OF op  
  NO-LOCK:
	vKolOpEntry = vKolOpEntry + 1 .
	vAllAmt = ( IF op-entry.currency = "" THEN op-entry.amt-rub ELSE op-entry.amt-cur ) + vAllAmt .
  END.

  IF vKolOpEntry > 1 THEN
  DO:
	MESSAGE "Документ №" op.doc-num " многопроводочный. Требуется ручной ввод реквизита!" VIEW-AS ALERT-BOX.
	PUT UNFORM "Документ " op.doc-num FORMAT "X(12)" " многопроводочный. Требуется ручной ввод реквизита!" SKIP.
	NEXT.
  END.

  vDRValue = vKodOpVal + ",," + STRING(vAllAmt) + ",0,," + STRING(vAllAmt) + ",1,1,Д," .


	/* Полная проверка значения реквизита. */
  RUN CheckFullFieldValue IN h_xclass (
     op.class-code,		/* Код класса. */
     "КодОпВал117",		/* Код реквизита. */
     op.op,			/* Идентификатор объекта. */
     vDRValue			/* Значение реквизита. */
  ).
  IF RETURN-VALUE NE "" THEN 
  DO:
	RUN Fill-SysMes ("", "", "-1", RETURN-VALUE + " Выходим из процедуры." ).
	RETURN .
  END.


  UpdateSigns("op", STRING(op.op), "КодОпВал117", vDRValue, ?) NO-ERROR .

  IF ERROR-STATUS:ERROR  THEN
  DO:
	MESSAGE "На документе №" op.doc-num " требуется ручной ввод реквизита!" VIEW-AS ALERT-BOX.
	PUT UNFORM "На документе №" op.doc-num FORMAT "X(12)" " требуется ручной ввод реквизита!" SKIP.
	NEXT.
  END.

END.

{preview.i}

MESSAGE "Процедура закончена." VIEW-AS ALERT-BOX.

{intrface.del}
