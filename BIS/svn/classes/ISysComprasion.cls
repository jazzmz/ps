INTERFACE ISysComprasion:
/*
METHOD PUBLIC LOGICAL load2First().                                                                                   /* Загружает данные из первой системы */
METHOD PUBLIC LOGICAL load2Second().                                                                                  /* Загружает данные из второй системы */

METHOD PROTECTED VOID inFirstButNotInSec().                                                                    /* Ищет данные, которые есть в первой системе, но нет во второй  */
METHOD PROTECTED VOID inSecButNotInFirst().                                                              /* Ищет данные, которые есть во второй системе, но нет в первой  */
METHOD PROTECTED VOID inBoth().                                                                                      /* Ищет данные, которые есть в первой и второй системе                 */
*/
METHOD PUBLIC LOGICAL exec().                                                                                      /* Производит сравнение данных в системах и выводит результат  */
END INTERFACE.