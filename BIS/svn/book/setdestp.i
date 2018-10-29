/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2004 ТОО "Банковские информационные системы"
     Filename: SETDEST.I
      Comment: (0030225) Добавлена работа в пакетном
               режиме, без выдачи информации на
               экран.
   Parameters:
         Uses:
      Used by:
     Modified: 18.05.2004 18:38 KSV      (0030225) Добавлена работа в пакетном
                                         режиме, без выдачи информации на
                                         экран.
     Modified: 
*/

{&nodef}
def new global shared var usr-printer like printer.printer no-undo.
{comment} */

&if defined(filename) = 0 &then
   &scop filename "_spool.tmp"
&endif

IF {btchmode}  THEN
DO:
   output {&stream} CLOSE.
   OUTPUT
   {&stream}
   TO  
   &IF DEFINED(setdest2) EQ 0 &THEN 
      VALUE ({&filename}) 
   &ELSE
      {ifdef {&filename}}
         {&filename}
      {else} */
        _spool.tmp
      {endif} */
   &ENDIF   
   {&option}
   APPEND
   .
END.
ELSE
DO:
   find first printer where 
              printer.printer   eq usr-printer
          and printer.page-cols ge 0{&cols}
      no-lock no-error.
   
   IF not avail printer then 
     find last printer where printer.printer eq usr-printer no-lock no-error.
     
   if NOT avail printer then do:
      MESSAGE 'Принтер "' usr-printer '" был удален!' view-as alert-box ERROR.
      return.
   end.

   output {&stream} CLOSE.
   OUTPUT
      {&stream}
      TO  
      &IF DEFINED(setdest2) EQ 0 &THEN 
         VALUE ({&filename}) 
      &ELSE
         {ifdef {&filename}}
            {&filename}
         {else} */
           _spool.tmp
         {endif} */
      &ENDIF   
      PAGE-SIZE VALUE ({&custom} 54)
      {&option}
      {&append}
   .
   {justasec}
END.

