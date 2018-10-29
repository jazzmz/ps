/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2002 ТОО "Банковские информационные системы"
     Filename: DETEDIT.P
      Comment: (0009381) Изменение поля "Содержание операции" документа
   Parameters:
         Uses:
      Used by:
      Created: 19.08.2002 13:12 KSV        
     Modified: 22.08.2002 16:09 KSV      (0009381) Изменение поля "Содержание операции" документа
     Modified: 06/08/2004  Om Доработка:
                  1. Поднял в стандарт из версии дойчебанка.
                  2. Подключены триггеры для работы с полем op.details.
     Modified:
*/

DEFINE INPUT PARAMETER pRcd    AS RECID NO-UNDO.   /* Идентификатор документа. */
DEFINE INPUT PARAMETER iVCheck AS LOGICAL NO-UNDO. /* выполнять ли валютный контроль */

{globals.i}             /* Глобальные переменные сессии. */
{intrface.get rights}   /* Библиотека инструментов по работе с правами. */
{intrface.get re}       /* Библиотека регулярных выражений. */
{intrface.get tmess}    /* Библиотека */
{intrface.get xclass}
{intrface.get ps}
{intrface.get strng}

{chkop117.i}

DEF VAR mScreenVal AS CHAR  NO-UNDO. /* Значение с экрана. */
DEF VAR mOldOpDet  AS CHAR  NO-UNDO. /* Значение поля до редактирования. */
DEF VAR mTerrProc  AS CHAR  NO-UNDO.
DEF VAR mOk        AS LOG   NO-UNDO.

/* ***************************  Main Block  *************************** */
MAIN-BLOCK:
DO 
  ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
  ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  
  FIND FIRST op WHERE RECID(op) = pRcd NO-LOCK NO-ERROR.
  IF NOT AVAIL op THEN
  DO:
    MESSAGE "Документ не найден".
    LEAVE MAIN-BLOCK.
  END.

   /* Проверка прав доступа. */
   IF NOT GetPermission (op.class-code, STRING (op.op), "w")
      THEN LEAVE MAIN-BLOCK.
  
  /* Запрет на исправление линкованных документов*/

  /*******************************
   *
   * Проверяем разрешено ли принудительное
   * исправление содержания.
   * Если разрешено, то проверку на связанность
   * не выполняем.
   *
   ********************************
   *
   * Автор : Маслов Д. А. Maslov D. A.
   * Заявка: #810
   * Дата создания: 23.11.11
   *
   ********************************/

 IF NOT CAN-DO(FGetSetting("PirChkOp","PirForceDedit","!*"),op.op-kind) THEN DO:
  {pir-op-ed-1.i}
 END.
  
  /* Наша процедура проверки*/
  RUN pir-chkop.p(pRcd, "status").
  IF pick-value = "no" THEN
    LEAVE MAIN-BLOCK.

  
  FORM
    SPACE "Содержание операции:" SKIP
    op.details VIEW-AS EDITOR SIZE 60 BY 7 SCROLLBAR-VERTICAL NO-LABEL  FORM "x(4096)" 
    WITH FRAME fMain OVERLAY SIDE-LABELS CENTERED ROW 10 TITLE COLOR "bright-white" "[ ДОКУМЕНТ № " + op.doc-num + " ]".

   {opdetail.i fMain}

   ON 'GO':U OF FRAME fMain
   DO:
      /* Полная проверка значения реквизита details */
      RUN CheckFullFieldValue IN h_xclass (
         op.class-code,   /* Код класса. */
         "details",       /* Код реквизита. */
         STRING(op.op),   /* Идентификатор объекта. */
         op.details:SCREEN-VALUE  /* Значение реквизита. */
       ).
      IF RETURN-VALUE NE ""
      THEN DO:
         MESSAGE RETURN-VALUE VIEW-AS ALERT-BOX.
         RETURN NO-APPLY. 
      END.

      IF iVCheck THEN
         /* Проверка на принадлежность документа / проводки к требованиям 117-И. */
         IF ChckOp117I (op.op) THEN DO:
            RUN ChkStr117i (op.details:SCREEN-VALUE).
            IF   RETURN-VALUE = "error" /* Проверка содержания */
            THEN RETURN NO-APPLY.
         END.
      IF     GetXattrEx(op.Class-Code,"LegTerr","data-type") <>  ? 
         AND FGetSetting("ОпОтмыв","TerrCheck",?)    = "ДА"  
         AND FGetSetting("ОпОтмыв","TerrDetails","") = 'Да' THEN DO:
         mTerrProc = GetCode("ОпОтмыв","7001").
         /* В классикаторе ОпОтмыв для кода 7001 есть настройка необходимой длины */
         IF     mTerrProc GT ""
            AND NUM-ENTRIES(mTerrProc,CHR(1)) GT 16  THEN DO:
            mTerrProc = ENTRY(17,mTerrProc,CHR(1)).
            IF NOT SearchPfile(mTerrProc) THEN
               mTerrProc = "".

         END.
         IF NOT {assigned mTerrProc} THEN
            mTerrProc = "lg7001".
         RUN VALUE(mTerrProc + '.p') (op.op, OUTPUT mOk).
      END.
      RETURN.
   END.

   mOldOpDet = op.details. /* Для поиска требуемых ДР. */
  
   TR:
   DO TRANSACTION
   ON ERROR UNDO TR, LEAVE TR
   ON STOP  UNDO TR, LEAVE TR:

      FIND CURRENT op EXCLUSIVE NO-WAIT NO-ERROR.
      IF  NOT AVAIL op
      AND LOCKED op THEN DO:
         RUN wholocks2.p (pRcd,"op","Документ уже редактирует другой пользователь").
         UNDO TR, LEAVE TR.
      END.

      PAUSE 0.
      UPDATE op.details WITH FRAME fMain.
      
      FOR EACH signs WHERE
               signs.file-name   EQ "op-entry"
         AND   signs.code        BEGINS "Details"
         AND   signs.surrogate   BEGINS STRING(op.op) + ","
         AND   signs.xattr-value EQ mOldOpDet
      EXCLUSIVE-LOCK:
         signs.xattr-value =  op.details.
      END.      
   END.
END.
/* *************************  End of Main Block  ********************** */
      
HIDE FRAME fMain.

{intrface.del} /* Выгрузка инструментария. */

RETURN.

PROCEDURE OnEntry_Op.Details:
   DEFINE VARIABLE t-details LIKE op.details NO-UNDO.

   t-details = SELF:SCREEN-VALUE.
   RUN p-detail.p (RECID (op),INPUT-OUTPUT t-details).
   SELF:SCREEN-VALUE = t-details.

END PROCEDURE.
