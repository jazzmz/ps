{pirsavelog.p}

{globals.i}
{intrface.get instrum}
{sh-defs.i}
{getdate.i}

def var num as integer NO-UNDO.

{setdest.i &cols=130}
num=0.

   PUT UNFORMATTED "                   ▌БГ╔Б ╞╝ ╒Кё╝╓╝╞Ю╗╝║Ю╔Б═Б╔╚О╛ ╜═ " end-date SKIP SKIP.
   PUT UNFORMATTED  "здддддбддддддддддддддддддддддбддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©" SKIP.
   PUT UNFORMATTED  "Ё  Э  Ё         ▒Г╔Б         Ё                ┌Кё╝╓╝╞Ю╗╝║Ю╔Б═Б╔╚Л, ╔ё╝ ═╓Ю╔А                           Ё" SKIP.
   PUT UNFORMATTED  "цдддддеддддддддддддддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢" SKIP.
   for each cust-role where cust-role.Class-Code = "┌Кё╝╓╝╞Ю╗╝║Ю╔Б═Б╔╚Л" and
        cust-role.file-name = "acct" and
        ((cust-role.close-date GE end-date) OR (cust-role.close-date = ?))
        NO-LOCK BY cust-role.surrogate:
     num = num + 1.
     PUT UNFORMATTED "Ё " + string(num,"999")" Ё " + substring(cust-role.surrogate,1,20) + " Ё " + string(trim(cust-role.cust-name),"x(70)") + "  Ё" skip.
     PUT UNFORMATTED "Ё     Ё                      Ё" +  string(cust-role.address,"x(70)") + "   Ё" skip.
     PUT UNFORMATTED "цдддддеддддддддддддддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢" SKIP.

   end.
   PUT UNFORMATTED "цдддддаддддддддддддддддддддддаддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢" SKIP.
   PUT UNFORMATTED "Ё ┌▒┘┐▌:" + string(num,"999") + "                                                                                            Ё" skip.
   PUT UNFORMATTED "юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды" SKIP.



{preview.i}
