/** 
 *	Групповая печать Инкассовых поручений.
 *	Разработана для использования процедурой pirgprint.p
 *
 *	Входящие параметры: таблица tmprecid, хранящая RECID
 *
 *  Бурягин Е.П., 2010
 *
 */
 
{globals.i}
{intrface.get xclass}

DEF INPUT PARAM iParam AS CHAR.

{tmprecid.def}

def stream macro-file.
def var AskDocCount  as logical init no no-undo.

{get_set2.i "Принтер" "PCL" "w/o chek"}
run SetPrintSysconf in h_base ("print", ?).      /* обнуление глобальных параметров печати      */
output stream macro-file to "_macro.tmp" .
assign
   FirstPrint   = no
   PackagePrint = no
   AskDocCount  = no
.

{strtout3.i &cols=128 &norepeat = yes &NOAsk=*/ &NODefs="/*" &NO_QUANT_COPIES=YES}

PackagePrint = true.

FOR EACH tmprecid NO-LOCK:
	output stream macro-file close.
	RUN VALUE("in-uni_1.p")(INPUT tmprecid.id).
END.

PackagePrint = false.
{endout3.i &norepeat = yes}
