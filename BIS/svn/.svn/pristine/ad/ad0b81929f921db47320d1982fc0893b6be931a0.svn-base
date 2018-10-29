/*********************************
 * Запрет правки документов из РКЦ
 * В теле документа ничего нельзя
 * править.
 **********************************
 *
 * Автор: Маслов Д. А.
 * Заявка: #692
 * Дата создания:
 *********************************/

IF LOGICAL(FGetSetting("PirChkop","DenyEditAuto","TRUE")) THEN DO:
 IF op.user-id EQ "MCI" OR op.user-id EQ "BNK-CL" THEN DO:

	   MESSAGE COLOR WHITE/RED "ОШИБКА! НЕЛЬЗЯ ПРАВИТЬ ОТ ИСПОЛНИТЕЛЯ " + op.user-id + "!!!" 
	   VIEW-AS ALERT-BOX ERROR TITLE "Ошибка документа #692".
	   RETURN NO-APPLY.

 END. /* IF user-id */
END. /* IF FGetSetting */
