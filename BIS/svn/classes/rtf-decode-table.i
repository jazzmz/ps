/***** 
������� ���� ��� � Lapin O.E. .
�� ��� �������� txt 2 rtf
http://www.dom.bankir.ru/showthread.php?t=22263
********/
DEF VAR ss AS CHAR EXTENT 256 NO-UNDO.
/* Decoding table */
ss[1]  = "".
ss[2]  = "".
ss[3]  = "".
ss[4]  = "".
ss[5]  = "".
ss[6]  = "".
ss[7]  = "".
ss[8]  = "".
ss[9]  = "".
ss[10] = "~\tab".               /* Tab */
ss[11] = "~\par~015~012".       /* New line */
ss[12] = "".
ss[13] = "~\page~\par~015~012". /* Form Feed */
ss[14] = "".
ss[15] = "".
ss[16] = "".
ss[17] = "".
ss[18] = "".
ss[19] = "".
ss[20] = "".
ss[21] = "".
ss[22] = "".
ss[23] = "".
ss[24] = "".
ss[25] = "".
ss[26] = "".
ss[27] = "".
ss[28] = "".
ss[29] = "".
ss[30] = "".
ss[31] = "".
ss[32] = "".  /* End of specials */
ss[33] = " ".
ss[34] = "!".
ss[35] = '"'.
ss[36] = "#".
ss[37] = "$".
ss[38] = "%".
ss[39] = "&".
ss[40] = "'".
ss[41] = "(".
ss[42] = ")".
ss[43] = "*".
ss[44] = "+".
ss[45] = ",".
ss[46] = "-".
ss[47] = ".".
ss[48] = "/".
ss[49] = "0".
ss[50] = "1".
ss[51] = "2".
ss[52] = "3".
ss[53] = "4".
ss[54] = "5".
ss[55] = "6".
ss[56] = "7".
ss[57] = "8".
ss[58] = "9".
ss[59] = ":".
ss[60] = ";".
ss[61] = "<".
ss[62] = "=".
ss[63] = ">".
ss[64] = "?".
ss[65] = "@".
ss[66] = "A".
ss[67] = "B".
ss[68] = "C".
ss[69] = "D".
ss[70] = "E".
ss[71] = "F".
ss[72] = "G".
ss[73] = "H".
ss[74] = "I".
ss[75] = "J".
ss[76] = "K".
ss[77] = "L".
ss[78] = "M".
ss[79] = "N".
ss[80] = "O".
ss[81] = "P".
ss[82] = "Q".
ss[83] = "R".
ss[84] = "S".
ss[85] = "T".
ss[86] = "U".
ss[87] = "V".
ss[88] = "W".
ss[89] = "X".
ss[90] = "Y".
ss[91] = "Z".
ss[92] = "[".
ss[93] = "~\~\".
ss[94] = "]".
ss[95] = "^".
ss[96] = "_".
ss[97] = "`".
ss[98] = "a".
ss[99] = "b".
ss[100] = "c".
ss[101] = "d".
ss[102] = "e".
ss[103] = "f".
ss[104] = "g".
ss[105] = "h".
ss[106] = "i".
ss[107] = "j".
ss[108] = "k".
ss[109] = "l".
ss[110] = "m".
ss[111] = "n".
ss[112] = "o".
ss[113] = "p".
ss[114] = "q".
ss[115] = "r".
ss[116] = "s".
ss[117] = "t".
ss[118] = "u".
ss[119] = "v".
ss[120] = "w".
ss[121] = "x".
ss[122] = "y".
ss[123] = "z".
ss[124] = "~\~{".
ss[125] = "|".
ss[126] = "~\}".
ss[127] = "~~".
ss[128] = "?".

ss[129] = "~\'c0". /* � */
ss[130] = "~\'c1". /* � */
ss[131] = "~\'c2". /* � */
ss[132] = "~\'c3". /* � */
ss[133] = "~\'c4". /* � */
ss[134] = "~\'c5". /* � */
ss[135] = "~\'c6". /* � */
ss[136] = "~\'c7". /* � */
ss[137] = "~\'c8". /* � */
ss[138] = "~\'c9". /* � */
ss[139] = "~\'ca". /* � */
ss[140] = "~\'cb". /* � */
ss[141] = "~\'cc". /* � */
ss[142] = "~\'cd". /* � */
ss[143] = "~\'ce". /* � */
ss[144] = "~\'cf". /* � */
ss[145] = "~\'d0". /* � */
ss[146] = "~\'d1". /* � */
ss[147] = "~\'d2". /* � */
ss[148] = "~\'d3". /* � */
ss[149] = "~\'d4". /* � */
ss[150] = "~\'d5". /* � */
ss[151] = "~\'d6". /* � */
ss[152] = "~\'d7". /* � */
ss[153] = "~\'d8". /* � */
ss[154] = "~\'d9". /* � */
ss[155] = "~\'da". /* � */
ss[156] = "~\'db". /* � */
ss[157] = "~\'dc". /* � */
ss[158] = "~\'dd". /* � */
ss[159] = "~\'de". /* � */
ss[160] = "~\'df". /* � */
ss[161] = "~\'e0". /* � */
ss[162] = "~\'e1". /* � */
ss[163] = "~\'e2". /* � */
ss[164] = "~\'e3". /* � */
ss[165] = "~\'e4". /* � */
ss[166] = "~\'e5". /* � */
ss[167] = "~\'e6". /* � */
ss[168] = "~\'e7". /* � */
ss[169] = "~\'e8". /* � */
ss[170] = "~\'e9". /* � */
ss[171] = "~\'ea". /* � */
ss[172] = "~\'eb". /* � */
ss[173] = "~\'ec". /* � */
ss[174] = "~\'ed". /* � */
ss[175] = "~\'ee". /* � */
ss[176] = "~\'ef". /* � */

ss[177] = "~\u9617?".
ss[178] = "~\u9618?".
ss[179] = "~\u9619?".
ss[180] = "~\u9474?".
ss[181] = "~\u9508?".
ss[182] = "~\u9569?".
ss[183] = "~\u9570?".
ss[184] = "~\u9558?".
ss[185] = "~\u9557?".
ss[186] = "~\u9571?".
ss[187] = "~\u9553?".
ss[188] = "~\u9559?".
ss[189] = "~\u9565?".
ss[190] = "~\u9564?".
ss[191] = "~\u9563?".
ss[192] = "~\u9488?".
ss[193] = "~\u9492?".
ss[194] = "~\u9524?".
ss[195] = "~\u9516?".
ss[196] = "~\u9500?".
ss[197] = "~\u9472?".
ss[198] = "~\u9532?".
ss[199] = "~\u9566?".
ss[200] = "~\u9567?".
ss[201] = "~\u9562?".
ss[202] = "~\u9556?".
ss[203] = "~\u9577?".
ss[204] = "~\u9574?".
ss[205] = "~\u9568?".
ss[206] = "~\u9552?".
ss[207] = "~\u9580?".
ss[208] = "~\u9575?".
ss[209] = "~\u9576?".
ss[210] = "~\u9572?".
ss[211] = "~\u9573?".
ss[212] = "~\u9561?".
ss[213] = "~\u9560?".
ss[214] = "~\u9554?".
ss[215] = "~\u9555?".
ss[216] = "~\u9579?".
ss[217] = "~\u9578?".
ss[218] = "~\u9496?".
ss[219] = "~\u9484?".
ss[220] = "~\u9608?".
ss[221] = "~\u9604?".
ss[222] = "~\u9612?".
ss[223] = "~\u9616?".
ss[224] = "~\u9600?".

ss[225] = "~\'f0". /* � */
ss[226] = "~\'f1". /* � */
ss[227] = "~\'f2". /* � */
ss[228] = "~\'f3". /* � */
ss[229] = "~\'f4". /* � */
ss[230] = "~\'f5". /* � */
ss[231] = "~\'f6". /* � */
ss[232] = "~\'f7". /* � */
ss[233] = "~\'f8". /* � */
ss[234] = "~\'f9". /* � */
ss[235] = "~\'fa". /* � */
ss[236] = "~\'fb". /* � */
ss[237] = "~\'fc". /* � */ 
ss[238] = "~\'fd". /* � */
ss[239] = "~\'fe". /* � */
ss[240] = "~\'ff". /* � */
ss[241] = "~\'a8". /* � */
ss[242] = "~\'b8". /* � */

ss[243] = "~\'aa".
ss[244] = "~\'ba".
ss[245] = "~\'af".
ss[246] = "~\'bf".
ss[247] = "~\'a1".
ss[248] = "~\'a2".
ss[249] = "~\lang1033~\f1~\'b0".
ss[250] = "~\bullet".
ss[251] = "~\'b7".
ss[252] = "~\u8730?".
ss[253] = "~\u8470?".
ss[254] = "~\'a4".
ss[255] = "~\u9642?".
ss[256] = " ".