{pirsavelog.p}

/* ------------------------------------------------------
File          : $RCSfile: pir-vcode.p,v $ $Revision: 1.2 $ $Date: 2007-10-18 07:42:21 $
Copyright     : ООО КБ "Пpоминвестрасчет"
Причина       : Необходимость "корректного" просмотра д/р имеющих связанный классификатор, но имеющих отсуствующее значение в классификаторе
Назначение    : Просмотр значений д/р
Параметры     : Класс, Название реквизита, значение реквизита
Место запуска : метод look на реквизите
Автор         : $Author: anisimov $ 
Изменения     : $Log: not supported by cvs2svn $
Изменения     : Revision 1.1  2007/09/12 05:48:48  lavrinenko
Изменения     : универсальный метод для просмотра значений допреквизитов
Изменения     :
***
* В связке с pir-brcode.p
------------------------------------------------------ */
{globals.i}
{form.def}              /* Константы пользовательского интерфейса*/
{intrface.get xclass}

DEFINE INPUT PARAMETER iClass  AS CHARACTER NO-UNDO.   /* Класс объекта                      */
DEFINE INPUT PARAMETER iXAttr  AS CHARACTER NO-UNDO.  /* Реквизит класса                    */
DEFINE INPUT PARAMETER iValue  AS CHARACTER NO-UNDO.  /* Текущее занечение экзепляра класса */

DEFINE VARIABLE        iCount  AS INTEGER   NO-UNDO.

DEFINE BUFFER buf-xattr FOR xattr.

RUN GetXattr(iClass,iXAttr,BUFFER buf-xattr).

DO iCount = 1 TO NUM-ENTRIES(iValue) :
	 RUN CheckDomain (BUFFER buf-xattr, ENTRY(iCount,iValue)). 

   IF RETURN-VALUE NE "" THEN DO:
		   M1:
		   DO ON ERROR UNDO M1, LEAVE M1
		   ON END-KEY UNDO M1, LEAVE M1: 
		      
		      DISPLAY iValue NO-LABEL VIEW-AS EDITOR SIZE 60 BY 10
		          WITH OVERLAY FRAME sss1 SIDE-LABELS 1 COL
		          CENTERED ROW 5 TITLE COLOR bright-white "[ " + buf-xattr.name + " ]".
		      ENABLE iValue WITH FRAME sss1.
		      ON f8 OF FRAME sss1 ANYWHERE DO:
		          RETURN NO-APPLY.
		      END.
		      iValue:read-only in frame sss1 = yes.
		      iValue:pfcolor = 0.
		      WAIT-FOR GO OF FRAME sss1 FOCUS iValue.
		   END.
		   HIDE FRAME sss1.
		   LEAVE.
   END. ELSE 
         IF NUM-ENTRIES(buf-xattr.domain-code,".") GT 1 THEN
			      RUN formld.p(ENTRY(1,buf-xattr.domain-code,"."),
			                   ENTRY(iCount,iValue),
			                   "",
			                   {&MOD_VIEW},
			                   5).
			   ELSE
      			RUN shifr.p (buf-xattr.domain-code,ENTRY(iCount,iValue),5).
END.  /* DO iCount = 1 TO */                 
