xmlCode = "".
FIND FIRST ttReport WHERE ttReport.id = {&id}.
DO i = 1 TO 12:
	xmlCode = xmlCode + CreateExcelCell("Number", "c1", STRING(ttReport.{&type}{&cur}[i])) +
	                    CreateExcelCell("Number", "c1", STRING(ttReport.{&type}{&cur}_RUR[i])) +
	                    CreateExcelCell("Number", "c1", STRING(ttReport.{&type}{&cur}[i] / ttReport.{&type}{&cur}[ (IF i = 1 THEN 13 ELSE i - 1) ] * 100)) +
                      CreateExcelCell("Number", "c1", STRING(ttReport.{&type}{&cur}_RUR[i] / ttReport.{&type}{&cur}_RUR[ (IF i = 1 THEN 13 ELSE i - 1) ] * 100)).
END.
