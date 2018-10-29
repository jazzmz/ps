/* ========================================================================= */
/** 
    Copyright: ООО ПИР Банк, Управление автоматизации (C) 2013
     Filename: pir-ordrast-rub.p
      Comment: Распоряжение на досрочное расторжение вкладов в рублях
   Parameters: 
       Launch: ЧВ - Вклады (архив), отмечаем нужный договор вклада, CTRL+G - РУБ. Распоряжение на досрочное расторжение вклада (ОБЩАЯ)
         Uses:
      Created: Sitov S.A., 20.02.2013
	Basis: #1073 
     Modified:  
*/
/* ========================================================================= */



{globals.i}		/** Глобальные определения */
{getdate.i}
{tmprecid.def}		/** Используем информацию из браузера */


/* ========================================================================= */
				/** Объявления */
/* ========================================================================= */

DEF VAR iLoanNum   AS CHAR  NO-UNDO.
DEF VAR iRaspDate  AS DATE  NO-UNDO.
DEF VAR iRatePen   AS DEC   INIT 0.01 LABEL "Процентная ставка досрочного расторжения" NO-UNDO.
DEF VAR iSPODDate  AS DATE  NO-UNDO.
DEF VAR ShowTabl   AS LOGICAL INIT no  NO-UNDO.
DEF VAR ShowRasp   AS LOGICAL INIT yes NO-UNDO.
DEF VAR out_Result AS CHAR    NO-UNDO.



/* ========================================================================= */
				/** Реализация */
/* ========================================================================= */

	/* выбираем договор ЧВ из браузера */
FOR FIRST tmprecid 
NO-LOCK,
FIRST loan WHERE 
      RECID(loan) EQ tmprecid.id 
NO-LOCK: 

  IF NOT AVAIL (loan) THEN
    RETURN.

END.


iLoanNum  = loan.cont-code .  
iRaspDate = end-date .


  /* # 2093 Ввод процентной ставки досрочного расторжения */
DISPLAY iRatePen WITH FRAME fSet OVERLAY CENTERED SIDE-LABELS.
SET iRatePen WITH FRAME fSet.
HIDE FRAME fSet.


iSPODDate =  DATE( FGetSetting('СПОД','ДатаСПОД','') + "/" + string(year(iRaspDate) ) ).


IF loan.currency = "" THEN
  RUN pir-drast-trans.p( iLoanNum, iRaspDate, iRatePen, iSPODDate, ShowTabl , ShowRasp , OUTPUT out_Result )    NO-ERROR.
ELSE 
  RUN pir-drast-trans-v.p( iLoanNum, iRaspDate, iRatePen, iSPODDate, ShowTabl , ShowRasp , OUTPUT out_Result )  NO-ERROR.


