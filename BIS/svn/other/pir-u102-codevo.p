/* ========================================================================= */
/** 
    Copyright: ООО ПИР Банк, Управление автоматизации (C) 2013
     Filename: pir-u102-codevo.p
      Comment: Процедура определяет, какой код VO должен стоять
		Критери заданы в настроечных параметрах PirU102codeVO
		Предполагается, что в дальнейшем правила заполнения кода VO будут собираться тут
   Parameters: 
       Launch: запускается с параметрами из парсерных функций, из других процедур
      Created: Sitov S.A., 2013-10-16
	Basis: #3950
     Modified: <Кто> <Когда [F7]> (Локальный код для поиска <уникальный_код>) 
               <Описание изменения>                                           
*/
/* ========================================================================= */


{globals.i}



DEF INPUT  PARAM vAcctDb	AS  CHAR  NO-UNDO.
DEF INPUT  PARAM vAcctCr	AS  CHAR  NO-UNDO.
DEF INPUT  PARAM vVal		AS  CHAR  NO-UNDO.
DEF INPUT  PARAM vSomething	AS  CHAR  NO-UNDO.

DEF OUTPUT PARAM oVOCode	AS  CHAR INIT "" NO-UNDO. 

DEF VAR  cList AS CHAR NO-UNDO.
DEF VAR  I AS INT NO-UNDO.

DEF VAR  np_db		AS  CHAR  NO-UNDO. 
DEF VAR  np_cr		AS  CHAR  NO-UNDO.  
DEF VAR  np_val		AS  CHAR  NO-UNDO.
DEF VAR  np_res		AS  CHAR  NO-UNDO.



FUNCTION GetVoCode RETURNS CHAR (INPUT iParam AS CHAR).

      np_db  =  FGetSetting("PirU102codeVO", iParam + "db" , "").
      np_cr  =  FGetSetting("PirU102codeVO", iParam + "cr" , ""). 
      np_val =  FGetSetting("PirU102codeVO", iParam + "val", ""). 
      np_res =  FGetSetting("PirU102codeVO", iParam + "res", ""). 

      IF  CAN-DO(np_db , vAcctDb )  AND  CAN-DO(np_cr , vAcctCr )  AND  CAN-DO(np_val, vVal )
      THEN
	RETURN np_res.
      ELSE RETURN "".
	
END FUNCTION.


   cList = FGetSetting("PirU102codeVO", "Pir3950List" , "").

   DO i = 1 TO NUM-ENTRIES(cList) :

      IF oVOCode = "" THEN
      DO:
         oVOCode = GetVoCode(ENTRY(i,cList)).  
      END.

   END.

  

