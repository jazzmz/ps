INTERFACE ISysComprasion:
/*
METHOD PUBLIC LOGICAL load2First().                                                                                   /* ����㦠�� ����� �� ��ࢮ� ��⥬� */
METHOD PUBLIC LOGICAL load2Second().                                                                                  /* ����㦠�� ����� �� ��ன ��⥬� */

METHOD PROTECTED VOID inFirstButNotInSec().                                                                    /* ��� �����, ����� ���� � ��ࢮ� ��⥬�, �� ��� �� ��ன  */
METHOD PROTECTED VOID inSecButNotInFirst().                                                              /* ��� �����, ����� ���� �� ��ன ��⥬�, �� ��� � ��ࢮ�  */
METHOD PROTECTED VOID inBoth().                                                                                      /* ��� �����, ����� ���� � ��ࢮ� � ��ன ��⥬�                 */
*/
METHOD PUBLIC LOGICAL exec().                                                                                      /* �ந������ �ࠢ����� ������ � ��⥬�� � �뢮��� १����  */
END INTERFACE.