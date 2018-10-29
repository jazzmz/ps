/* Надеюсь, это не понадобится */
/* а пока вот такой костыль для аннулирования документов */

{globals.i}

DEF INPUT PARAM vopop AS INT.


FOR FIRST op 
   WHERE op.op = vopop 
   AND   op.op-status EQ 'К'
   AND   CAN-DO('i-ucstr3,i-ucstb3',op.op-kind)
:


  message 
	"Аннулируется документ №" op.doc-num " в опер.дне " op.doc-date SKIP
	" c назначением: " SKIP
	op.details
  view-as alert-box.


  op.op-status = 'А' .

END.