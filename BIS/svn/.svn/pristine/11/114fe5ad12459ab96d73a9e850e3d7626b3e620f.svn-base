/*
Формирует выгрузку данных для графиков в нужном формате и
конфигурационного файла для построения с помощью gnuplot,
включая создание файла PDF с графиками
Бакланов А.В. 17.09.2013
*/

{globals.i}
{getdates.i}
{wordwrap.def}
{tmprecid.def}

DEF INPUT PARAM in-data-id LIKE DataBlock.Data-Id NO-UNDO.   
         
DEF VAR vFindMask AS CHAR NO-UNDO.
DEF VAR tmpStr AS CHAR NO-UNDO.
DEF VAR tmpStr1 AS CHAR NO-UNDO.
DEF VAR vFuncName AS CHAR NO-UNDO.
DEF VAR vVisib AS CHAR NO-UNDO.
DEF VAR vGraphName AS CHAR NO-UNDO.
DEF VAR vGraphNameL AS CHAR NO-UNDO.
DEF VAR vTitle AS CHAR NO-UNDO.
DEF VAR vTitleAdd AS CHAR NO-UNDO.
DEF VAR i AS INTEGER INIT 1 NO-UNDO.
DEF VAR iCycle AS INTEGER INIT 1 NO-UNDO.
DEF VAR iTemp AS INTEGER INIT 1 NO-UNDO.
DEF VAR vLinesCount AS INTEGER INIT 1 NO-UNDO.
DEF VAR vFileName AS CHAR NO-UNDO.
DEF VAR vFileName1 AS CHAR NO-UNDO.
DEF VAR vFileNamePLT AS CHAR NO-UNDO.
DEF VAR vFileNameBAT AS CHAR NO-UNDO.
DEF VAR iString AS CHAR NO-UNDO.
DEF VAR StringTemp AS CHAR EXTENT 10 NO-UNDO.
DEF VAR ztmp AS CHAR NO-UNDO.
DEF VAR iBegDate AS DATE NO-UNDO.
DEF VAR iEndDate AS DATE NO-UNDO.
DEF BUFFER currDataBLock for DataBlock.
DEF BUFFER forDataBLock for DataBlock.
DEF BUFFER currDataLine for DataLine.

DEF TEMP-TABLE tblout NO-UNDO
   FIELD vDate AS DATE
   FIELD vVal AS CHAR
   INDEX vDate IS PRIMARY vDate.

DEF TEMP-TABLE tempcode NO-UNDO
   FIELD qID AS CHAR
   INDEX qID IS PRIMARY qID.

DEFINE VARIABLE mW AS INTEGER NO-UNDO INITIAL 1
    VIEW-AS RADIO-SET RADIO-BUTTONS " Один график",1,        
                                " Два графика",2,
                                " Четыре графика",4,
                                " Восемь графиков",8
    LABEL "Выберите количество графиков на страницу ".

/*
DEFINE VARIABLE cur AS char NO-UNDO 
    VIEW-AS RADIO-SET RADIO-BUTTONS "рубли","",        
                                "доллары","840",
                                "евро","978"
    LABEL "Выберите валюту ".
*/

   PAUSE 0.
   DO ON ERROR  UNDO, LEAVE
      ON ENDKEY UNDO, LEAVE WITH FRAME wow:
      UPDATE mW GO-ON (RETURN)
         WITH FRAME wow CENTERED OVERLAY ROW 10 SIDE-LABELS TITLE
         COLOR bright-white "[ ВЫБЕРИТЕ ЗНАЧЕНИЕ ]".
   END.
   HIDE FRAME wow NO-PAUSE.
   if lastkey eq 27 then do:
      HIDE FRAME wow.
      return.
   end.     
/*
   PAUSE 0.
   DO ON ERROR  UNDO, LEAVE
      ON ENDKEY UNDO, LEAVE WITH FRAME curframe:
      UPDATE cur GO-ON (RETURN)
         WITH FRAME curframe CENTERED OVERLAY ROW 10 SIDE-LABELS TITLE
         COLOR bright-white "[ ВЫБЕРИТЕ ЗНАЧЕНИЕ ]".
   END.
   HIDE FRAME curframe NO-PAUSE.
   if lastkey eq 27 then do:
      HIDE FRAME curframe.
      return.
   end.     
*/

PROCEDURE makeGraphsAppend: /* Процедура дописывания файла scenary*.plt исходя из количества графиков и названий входных файлов с данными */
DEFINE INPUT PARAMETER gName AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER gFile AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER gIter AS INTEGER NO-UNDO.
OUTPUT TO VALUE("/home2/bis/quit41d/imp-exp/graphs/"+ vFilenamePLT + ".plt") APPEND CONVERT TARGET "UTF-8".
IF gIter = 1 THEN DO:
/*	PUT UNFORMATTED "set title " + CHR(34) + iString + CHR(34) SKIP.*/
		iString = " ".
		vTitle = vTitle + vTitleAdd.	
		StringTemp[1] = replace(vTitle,";",", ").
		{pir-wordwrap.i &s=StringTemp &l=85 &n=10}
		DO iCycle = 1 TO 10:
        		IF StringTemp[iCycle] NE "" THEN DO:
                		IF StringTemp[(iCycle + 1)] NE "" THEN iString = iString + StringTemp[iCycle] + CHR(92) + "n".
                        		ELSE iString = iString + StringTemp[iCycle].
			        END.
			END.
	PUT UNFORMATTED "set title " + CHR(34) + iString + CHR(34) SKIP.
	PUT UNFORMATTED "plot " + CHR(39) + "/home/mover/graph/" + vFilename + ".txt" + CHR(39) + " using 1:" + STRING(gIter + 1) + " with lines lw 2 lt rgb " + CHR(39) + "red" + CHR(39) + " title " + CHR(34) + gName + CHR(34) + "," + CHR(92) SKIP.
	END.
IF gIter = 2 AND gIter < vLinesCount THEN PUT UNFORMATTED " " + CHR(39) + "/home/mover/graph/" + vFilename + ".txt" + CHR(39) + " using 1:" + STRING(gIter + 1) + " with lines lw 2 lt rgb " + CHR(39) + "green" + CHR(39) + " title " + CHR(34) + gName + CHR(34) + "," + CHR(92) SKIP.
IF gIter = 3 AND vLinesCount = 4 THEN PUT UNFORMATTED " " + CHR(39) + "/home/mover/graph/" + vFilename + ".txt" + CHR(39) + " using 1:" + STRING(gIter + 1) + " with lines lw 2 lt rgb " + CHR(39) + "yellow" + CHR(39) + " title " + CHR(34) + gName + CHR(34) + "," + CHR(92) SKIP.
IF gIter = vLinesCount THEN PUT UNFORMATTED " " + CHR(39) + "/home/mover/graph/" + vFilename + ".txt" + CHR(39) + " using 1:" + STRING(gIter + 1) + " with lines lw 2 lt rgb " + CHR(39) + "blue" + CHR(39) + " title " + CHR(34) + gName + CHR(34) + "," SKIP.
OUTPUT CLOSE.
END PROCEDURE.

PROCEDURE makePLTfile: /* Процедура формирования шапки файла scenary*.plt */
DEFINE INPUT PARAMETER tName AS CHAR NO-UNDO.
/*DEFINE INPUT PARAMETER tgName AS CHAR NO-UNDO.*/
DEFINE INPUT PARAMETER nGraph AS INTEGER NO-UNDO.
DEF VAR co AS INTEGER INIT 1 NO-UNDO.
DEF VAR tTitle AS CHAR NO-UNDO.
DEF VAR masht AS INTEGER NO-UNDO.
OUTPUT TO VALUE("/home2/bis/quit41d/imp-exp/graphs/" + vFilenamePLT + ".plt") CONVERT TARGET "UTF-8".
PUT UNFORMATTED "set terminal svg font ""Times-Roman,8"" size 1000,1250" SKIP.
PUT UNFORMATTED "set encoding utf8" SKIP.
PUT UNFORMATTED "set output " + CHR(39) + "/home/mover/graph/" + tName + ".svg" + CHR(39) SKIP.
tTitle = "ПОКАЗАТЕЛИ ЗА ПЕРИОД С " + STRING(iBegDate) + " ПО " + STRING(iEndDate) + " (Валюта пересчета: 810)".
CASE nGraph:
        WHEN 1 THEN PUT UNFORMATTED "set multiplot layout 1,1 title " + CHR(34) + tTitle + CHR(34) SKIP.
        WHEN 2 THEN PUT UNFORMATTED "set multiplot layout 2,1 title " + CHR(34) + tTitle + CHR(34) SKIP.
        WHEN 4 THEN PUT UNFORMATTED "set multiplot layout 2,2 title " + CHR(34) + tTitle + CHR(34) SKIP.
        WHEN 8 THEN PUT UNFORMATTED "set multiplot layout 4,2 title " + CHR(34) + tTitle + CHR(34) SKIP.
        END.
PUT UNFORMATTED "set xdata time" SKIP.
PUT UNFORMATTED "set xtics rotate by 90" SKIP.
PUT UNFORMATTED "set xtics offset 0,-3.5" SKIP.
PUT UNFORMATTED "set ytics" SKIP.
PUT UNFORMATTED "set xrange " + CHR(91) + CHR(34) + STRING(iBegDate) + CHR(34) + ":" + CHR(34) + STRING(iEndDate) + CHR(34) + CHR(93) + "" SKIP.
/*masht = ROUND(((iEndDate - iBegDate) / 84) * 60 * 60 * 60,0).*/
masht = ROUND(((iEndDate - iBegDate) / 77) * 60 * 60 * 60,0).
PUT UNFORMATTED "set xtics " + CHR(34) + STRING(iBegDate) + CHR(34) + "," + STRING(masht) + ", " + CHR(34) + STRING(iEndDate) + CHR(34) SKIP.
PUT UNFORMATTED "set decimalsign locale" SKIP.
PUT UNFORMATTED "set format y ""%'12.0f""" SKIP.
PUT UNFORMATTED "set timefmt " + CHR(34) + CHR(37) + "d" + CHR(47) + CHR(37) + "m" + CHR(47) + CHR(37) + "y" SKIP.
PUT UNFORMATTED "set grid x" SKIP.
PUT UNFORMATTED "set grid y" SKIP.
PUT UNFORMATTED "set lmargin 15" SKIP.
PUT UNFORMATTED "set bmargin 5" SKIP.
PUT UNFORMATTED "set key out horiz" SKIP.
PUT UNFORMATTED "set key center top box" SKIP.
OUTPUT CLOSE.                                                                                                                                                                                   
END PROCEDURE.

procedure getBISdata: /* Заполнение темп-тейбла для вывода результатов по параметру в файл параметр.txt */
DEFINE INPUT PARAMETER tvName AS CHAR NO-UNDO.
FOR EACH forDataBLock WHERE forDataBLock.DataClass-Id EQ currDataBlock.DataClass-Id 
                             and forDataBLock.end-date >= iBegDate
                             and forDataBLock.end-date <= iEndDate
                             and forDataBLock.beg-date = forDataBLock.end-date
                             NO-LOCK,
FIRST currDataLine WHERE currDataLine.Sym1 = tvName AND currDataLine.data-id = forDataBlock.data-id NO-LOCK.
FIND FIRST tblout WHERE tblout.vDate = forDataBlock.end-date NO-ERROR.
IF AVAILABLE tblout THEN ASSIGN tblout.vVal = tblout.vVal + CHR(9) + STRING(currDataLine.Val[1]).
ELSE
  DO:
        CREATE tblout.
        tblout.vDate = forDataBlock.end-date.
        tblout.vVal = STRING(currDataLine.Val[1]).
  END.
ztmp = TRIM(STRING(currDataLine.Val[1],"->>>,>>>,>>>,>>>,>>>,>>>,>>>,>>>,>>9.99")).
END.
END PROCEDURE.

procedure printBISdata: /* Вывод результатов по параметру в файл параметр.txt */
DEFINE INPUT PARAMETER tName AS CHAR NO-UNDO.
OUTPUT TO VALUE("/home2/bis/quit41d/imp-exp/graphs/" + vFilename + ".txt") CONVERT TARGET "UTF-8".
for each tblout:
        PUT UNFORMATTED STRING(tblout.vDate) + CHR(9) + tblout.vVal SKIP.
        END.
PUT UNFORMATTED SKIP.
OUTPUT CLOSE.
END PROCEDURE.

PROCEDURE makeGraphTitle: /* Формирование заголовка каждого из графиков с числами за конечную дату */ 
DEFINE INPUT PARAMETER tco AS INTEGER NO-UNDO.
DEF VAR ztmpStr AS CHAR NO-UNDO.
DEF VAR ztmpStr1 AS CHAR NO-UNDO.
DEF VAR zvGraphName AS CHAR NO-UNDO.
DEF VAR zvGraphNameL AS CHAR NO-UNDO.
DEF VAR zi AS INTEGER NO-UNDO.
    DO zi = 1 TO tco:
          ztmpStr = TRIM(ENTRY(zi,code.description[1],",")).
          ztmpStr1 = TRIM(ENTRY(2,ztmpStr,"=")).
          zvGraphName = zvGraphName + CHR(9) + ENTRY(3,ztmpStr1,";").
          zvGraphNameL = "" + ENTRY(3,ztmpStr1,";").
    END.
vTitle = vTitle + TRIM(zvGraphNameL) + "=" + ztmp + "; ".
END PROCEDURE.

PROCEDURE makeBATfile: /* Формирование батника с командами для виндовых приложений конвертации в pdf */
DEFINE INPUT PARAMETER tcount AS INTEGER NO-UNDO.
vFilename1 = "graph" + STRING(tcount / mW).
vFilenamePLT = "scenary" + STRING(tcount / mW).
vFilenameBAT = "convert" + STRING(tcount / mW).
RUN makePLTfile(vFilename1,mW).
OUTPUT TO VALUE("/home2/bis/quit41d/imp-exp/graphs/convert.bat") APPEND CONVERT TARGET "UTF-8".
PUT UNFORMATTED "call C:"+ CHR(92) + "inkscape" + CHR(92) + "inkscape.exe --without-gui --file=" + vFilename1 + ".svg --export-pdf=" + vFilename1 + ".pdf" SKIP.
OUTPUT CLOSE.

OUTPUT TO VALUE("/home2/bis/quit41d/imp-exp/graphs/script.sh") APPEND CONVERT TARGET "UTF-8".
PUT UNFORMATTED "/usr/local/bin/gnuplot /home/mover/graph/" + vFilenamePLT + ".plt" SKIP.
OUTPUT CLOSE.
END PROCEDURE.

FIND FIRST currDataBlock WHERE currDataBlock.Data-Id EQ in-data-id NO-LOCK NO-ERROR.
iBegDate = beg-date.
iEndDate = end-date.

DO TRANSACTION:
    RUN browseld.p ("code",
                    "class"   + CHR(1) + "parent" + CHR(1) + "RidRest",
                    "PIR-OutToPlot" + CHR(1) + "PIR-OutToPlot" + CHR(1) + "YES",
                    "",
                    1).
    IF KEYFUNCTION(LASTKEY) = "END-ERROR" OR pick-value = ? THEN RETURN.
/*    vFindMask = pick-value.*/
    iTemp = -1.	
    FOR EACH tmprecid,
    FIRST code where RECID(code) = tmprecid.id NO-LOCK:

        CREATE tempcode.
        tempcode.qID = STRING(code.code).
    end.

    for each tempcode NO-LOCK by tempcode.qID:
    FIND first code where code.code = tempcode.qID and code.class EQ 'PIR-OutToPlot' AND code.parent EQ 'PIR-OutToPlot' NO-LOCK.

	    vFilename = code.description[2].
	    vLinesCount = NUM-ENTRIES(code.description[1]).
	    iTemp = iTemp + 1.
	    IF iTemp MODULO mW = 0 THEN RUN makeBATfile(iTemp).
	    DO i = 1 TO vLinesCount:
        	  tmpStr = TRIM(ENTRY(i,code.description[1],",")).
	          tmpStr1 = TRIM(ENTRY(2,tmpStr,"=")).
        	  vFuncName = ENTRY(1,tmpStr1,";").
	          vVisib = ENTRY(2,tmpStr1,";").
		  RUN getBISdata(vFuncName).
	  	  RUN makeGraphTitle(i).
	    END.                                                
/*	    IF SEARCH(ENTRY(1,code.description[3]) + ".r") <> ? THEN RUN VALUE (ENTRY(1,code.description[3]) + ".r")(iEndDate,ENTRY(2,code.description[3]), OUTPUT vTitleAdd).
		ELSE RUN VALUE(ENTRY(1,code.description[3]) + ".p")(iEndDate,ENTRY(2,code.description[3]), OUTPUT vTitleAdd).*/
	    IF SEARCH(ENTRY(1,code.description[3]) + ".p") <> ? THEN RUN VALUE (ENTRY(1,code.description[3]) + ".p")(iEndDate,ENTRY(2,code.description[3]), OUTPUT vTitleAdd).
            DO i = 1 TO vLinesCount:
		  tmpStr = TRIM(ENTRY(i,code.description[1],",")).
	          tmpStr1 = TRIM(ENTRY(2,tmpStr,"=")).
	          vGraphName = vGraphName + CHR(9) + ENTRY(3,tmpStr1,";").
	          vGraphNameL = "" + ENTRY(3,tmpStr1,";").
                  RUN makeGraphsAppend(vGraphNameL,vFilename,i).
		  END.
	    RUN printBISdata(vGraphName).
	    vTitle = " ".
	    vTitleAdd = " ".
	    EMPTY temp-table tblout.
	   /* OS-COMMAND silent VALUE("gnuplot ""scenary.plt"" 2> err.txt").*/
	   /* OS-COMMAND silent VALUE("inkscape --without-gui --file=" + CHR(34) + vFilename1 + CHR(34) + ".svg " + "--export-pdf=" + CHR(34) + vFilename1 + CHR(34) + ".pdf 2> err.txt").*/
	/*    END.*/
    END.
END.
OUTPUT TO VALUE("/home2/bis/quit41d/imp-exp/graphs/convert.bat") APPEND CONVERT TARGET "UTF-8".
PUT UNFORMATTED "md " + STRING(year(iEndDate),'9999') SKIP.
PUT UNFORMATTED "cd " + STRING(year(iEndDate),'9999') SKIP.
PUT UNFORMATTED "md " + STRING(month(iEndDate),'99') SKIP.
PUT UNFORMATTED "pdftk q:" + CHR(92) + "graphs" + CHR(92) + "*.pdf cat output q:" + CHR(92) + "graphs" + CHR(92) + STRING(year(iEndDate),'9999') + CHR(92) + string(month(iEndDate),'99') + CHR(92) + string(day(iEndDate),'99') + ".pdf" SKIP.
PUT UNFORMATTED "cd .." SKIP.
PUT UNFORMATTED "echo y | del *.*" SKIP.
OUTPUT CLOSE.

OS-COMMAND silent VALUE("/home2/bis/quit41d/bin/graph.sh 2> err.txt").
MESSAGE "Файл с графиками выгружен" VIEW-AS ALERT-BOX.