function TranslitIt returns character (input iString as character).
	define variable rus as character INIT " ,¡,¢,£,¤,¥,ñ,¦,§,¨,©,ª,«,¬,­,®,¯,à,á,â,ã,ä,å,æ,ç,è,é,ê,ë,ì,í,î,ï" no-undo.
	define variable translit as character INIT "A,B,V,G,D,E,E,ZH,Z,I,Y,K,L,M,N,O,P,R,S,T,U,F,H,TS,CH,SH,SCH,',Y,',E,YU,YA" no-undo.
	define variable iTrans as integer no-undo.
	do iTrans = 1 to 33:
		iString = replace (caps(iString),entry(iTrans,rus),entry(iTrans,translit)).
	end.
	return iString.
end function.

function WrapIt returns character (input iString as character).
	define variable StringTemp as character extent 10 no-undo.
	define variable iCycle as integer no-undo.
	StringTemp[1] = iString.
	iString = "".
	{wordwrap.i &s=StringTemp &l=35 &n=10}
	do iCycle = 1 to 10:
		if StringTemp[iCycle] ne "" then do:
			if StringTemp[(iCycle + 1)] ne "" then
				iString = iString + StringTemp[iCycle] + chr(10).
			else
				iString = iString + StringTemp[iCycle].
		end.
	end.
	return iString.
end function.
