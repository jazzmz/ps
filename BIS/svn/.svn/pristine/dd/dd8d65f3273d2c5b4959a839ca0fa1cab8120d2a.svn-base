/**
 * Возвращает уникальный номер ПОСа
 * в БИСе.
 * @cName CHAR  название ПОС
 * @iNum  INT   номер ПОСа по классификации
 * БИСа.
 * RETURN CHAR
 **/
FUNCTION getPosId RETURNS CHAR(
                               INPUT cName AS CHAR,
                               INPUT iNum  AS INT
                              ):
  CASE iNum:
    WHEN 3 THEN iNum = 4.
    WHEN 4 THEN iNum = 5.
    WHEN 5 THEN iNum = 3.
    WHEN 6 THEN iNum = 6.
  END CASE.
  RETURN cName + STRING(iNum).
END FUNCTION.

/**
 * Возвращает наименование ПОСа
 * по его ID. Функция обратная к getPosById.
 * @cName CHAR
 * @iNum  INT
 * RETURN CHAR
 **/
FUNCTION getPosNumById RETURNS CHAR(
                                    INPUT cName AS CHAR,
                                    INPUT iNum  AS INT
                                   ):

  CASE iNum:
    WHEN 4 THEN iNum = 3.
    WHEN 5 THEN iNum = 4.
    WHEN 3 THEN iNum = 5.
  END CASE.
  RETURN cName + STRING(iNum).
END FUNCTION.