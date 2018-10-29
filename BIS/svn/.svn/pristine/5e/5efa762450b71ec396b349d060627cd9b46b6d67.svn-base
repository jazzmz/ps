/***************************************************************************************
 * Подстановка свойства			   								*
 *  Формат вызова 												*
 *{set-prop.i <название_свойства> <внутре_переменная> <тип>} 			*
 *																*
 **************************************************************************************/

DEF &IF DEFINED(permv) &THEN {&permv} &ELSE PRIVATE &ENDIF VAR &IF DEFINED(bb)>0 &THEN {&bb} &ELSE vv{&aa} &ENDIF AS {&cc} &IF DEFINED(init) > 0 &THEN INITIAL {&init} &ENDIF.

  DEFINE PUBLIC PROPERTY {&aa} AS {&cc}
     GET:
        RETURN &IF DEFINED(bb)>0 &THEN {&bb} &ELSE vv{&aa} &ENDIF.
     END GET.
     &IF DEFINED(perms) &THEN {&perms} &ENDIF SET (INPUT cProp AS {&cc}):
          &IF DEFINED(bb)>0 &THEN {&bb} &ELSE vv{&aa} &ENDIF=cProp.
      END SET.
