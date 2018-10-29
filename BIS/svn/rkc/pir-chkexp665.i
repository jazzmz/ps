/*********************************************************
 *	                                                *
 * Проверка "НДС по услугам нерезидентов".              *
 * На самом деле более общая проверка:		        *
 * "проверка на отправку одного из пары"		*
 *							*
 ********************************************************
 * Автор: Маслов Д. А.					*
 * Дата создания: 12:00 28.03.2011			*
 * Заявка: #665						*
 *							*			     *
 *********************************************************/

DEF VAR isError AS LOGICAL INITIAL FALSE NO-UNDO.
DEF VAR oTable  AS TTable                NO-UNDO.
DEF BUFFER bufLinkOp FOR op.

oTable = new TTable(7).
oTable:colsWidthList="8,25,8,10,3,25,10".
oTable:colsHeaderList="Номер,Содержание,Свз. номер,Свз. дата,Свз. статус,Свз. содержание,Тип связи".
oTable:setAlign(1,1,"center").
oTable:setAlign(2,1,"center").
oTable:setAlign(3,1,"center").
oTable:setAlign(4,1,"center").
oTable:setAlign(5,1,"center").
oTable:setAlign(6,1,"center").
oTable:setAlign(7,1,"center").

PUT UNFORMATTED " ОШИБКИ СВЯЗАННЫХ ДОКУМЕНТОВ ИНФ. СООБЩ. №665" SKIP.

		/**************************************************
		 *									   *
		 * Функция возвращает TRUE, если,		   *
		 * 1. Документ найден;					   *
		 * 2. Он проведен по балансу или экспорти-  *
		 * рован в РКЦ.						   *
		 * 		   							   *
		 **************************************************/
FUNCTION isOpExport RETURNS LOGICAL(INPUT iOp AS INT64):
	DEF VAR lResult AS LOGICAL.
	lResult = CAN-FIND(op WHERE op.op = iOp AND CAN-DO("ФБП," + CHR(251) + "," + CHR(251) + CHR(251),op-status)).
	RETURN lResult.
END FUNCTION.

FOR EACH TTReestr BY TTReestr.amt-rub:
	/***********************************************
	 * Проверяем есть ли действующая связь
	 * с кодом VALCCL (valcontrollink).
	 ***********************************************/	

	FIND FIRST xlink WHERE xlink.link-code EQ "PirChkPair" NO-LOCK NO-ERROR.
	IF AVAILABLE(xlink) THEN
	 DO:
		
				      FIND FIRST links WHERE links.link-id = xlink.link-id 
										AND (INT64(target-id) = TTReestr.op OR INT64(source-id)=TTReestr.op)
									        AND links.beg-date<=currDate AND (links.end-date>=currDate OR links.end-date=?) NO-LOCK NO-ERROR.

				         IF AVAILABLE(links) THEN
					      DO:

						 IF INT64(links.target-id)   = TTReestr.op THEN IF NOT CAN-FIND(TTReestr WHERE TTReestr.op = INT64(links.source-id)) THEN isError = TRUE.
						 IF INT64(links.source-id) = TTReestr.op THEN IF NOT CAN-FIND(TTReestr WHERE TTReestr.op = INT64(links.target-id))   THEN isError = TRUE.

						 IF isError AND INT64(links.target-id) = TTReestr.op THEN
							DO:
					      			FIND FIRST bufLinkOp WHERE bufLinkOp.op = INT64(links.source-id)  NO-LOCK NO-ERROR.
									       
                                                            IF NOT isOpExport(INT64(links.source-id)) THEN
								DO:
									oTable:addRow().
									oTable:addCell(TTReestr.doc-num).
									oTable:addCell(TTReestr.details).
									oTable:addCell(bufLinkOp.doc-num).
									oTable:addCell(bufLinkOp.op-date).
									oTable:addCell(bufLinkOp.op-status).
									oTable:addCell(bufLinkOp.details).
									oTable:addCell("ВХОДЯЩАЯ").
								END. /* AVAILABLE */
							END.

						 IF isError AND INT64(links.source-id) = TTReestr.op THEN
							DO:

					      			FIND FIRST bufLinkOp WHERE bufLinkOp.op = INT64(links.target-id) NO-LOCK NO-ERROR.

                                                            IF NOT isOpExport(INT64(links.target-id)) THEN
								DO:
									oTable:addRow().
									oTable:addCell(TTReestr.doc-num).
									oTable:addCell(TTReestr.details).
									oTable:addCell(bufLinkOp.doc-num).
									oTable:addCell(bufLinkOp.op-date).
									oTable:addCell(bufLinkOp.op-status).
									oTable:addCell(bufLinkOp.details).
									oTable:addCell("ИСХОДЯЩАЯ").
								END. /* AVAILABLE */
							END.
					END. /* links */
	  END. /* AVAILABLE(xlink) */
   isError = FALSE.
END. /* FOR EACH TTReestr */
IF oTable:height > 1 THEN oTable:show(). ELSE PUT UNFORMATTED  "*** ОШИБОК НЕТ ***" SKIP(2).
DELETE OBJECT oTable.