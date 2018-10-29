/* ��� "��� ����" ��ࠢ����� ��⮬�⨧�樨 2013�. 	        */  
/* ����� ������. �⤥�쭮 ��� �� �� ��ਮ�  03/06/13-16/06/13 */
/* ��⮢ �.�. 11.07.2013				        */

{globals.i}           /* �������� ��।������ */
{tmprecid.def}        /* �ᯮ��㥬 ���ଠ�� �� ��㧥� */
{wordwrap.def}        /* �㤥� �ᯮ�짮���� ��७�� �� ᫮��� */
{parsin.def}
{intrface.get xclass} /* �㭪樨 ��� ࠡ��� � ����奬�� */
{intrface.get strng}  /* �㭪樨 ��� ࠡ��� � ��ப��� */
{intrface.get tmess}

{pir-eanketa-20130603.def}
{pir_anketa.fun}


define input parameter iParam as character no-undo.


/******************************************* ��������� */
/* NEW - params:
   1 = "�,�,�,��,�"
   2 = cUser
   3 = cKladr              */

/** ������ �室���� ��ࠬ��� */
cKl     = ENTRY(1, iParam). /* "�,�,�,��,�" */
cUser   = ENTRY(2, iParam). /*  */
cKladr  = ENTRY(3, iParam). /*  */
bIsBOS  = NUM-ENTRIES(iParam) > 3. /* ����� ��� ��� ������ ��� */

find first tmprecid
   no-error.

case cKl:
	when "�" then do:
		find first person
		   WHERE (RECID(person) EQ tmprecid.id)
		   no-error.
		cKlNum = STRING(person.person-id).
		cKl    = "��".
		iKl    = 1.
	end.

	when "�" then do:
		find first cust-corp
		   WHERE (RECID(cust-corp) EQ tmprecid.id)
		   no-error.
		cOPF   = cust-corp.cust-stat.
		cKl    = if CAN-DO("��,�����,�������,������,���", cOPF) then "��" ELSE "��".
		iKl    = if (cKl EQ "��") then 2 ELSE 3.
		cOPF   = GetCodeName("����।�",GetCodeVal("����।�", cOPF)).
		cKlNum = STRING(cust-corp.cust-id).
	end.

	when "�" then do:
		find first banks
		   WHERE (RECID(banks) EQ tmprecid.id)
		   no-error.
		cKlNum = STRING(banks.bank-id).
		iKl    = 4.
	end.

	when "��" then do:
		cVp     = "��".
		find first cust-role
		   WHERE (RECID(cust-role) EQ tmprecid.id)
		   no-error.
		if NOT (cust-role.class-code BEGINS "�룮���ਮ���⥫�") then RETURN.
		cKlNum = cust-role.cust-id.
		find first cust-corp
		   WHERE (cust-corp.cust-id EQ INT(cust-role.surrogate))
		   NO-LOCK no-error.
		case cust-role.file-name:
			when "cust-corp" then do:
				cPredWho_Name		= cust-corp.name-short.
				cPredWho_INN		= cust-corp.inn.
				cPredWho_MainAcct	= KlientMainAcct(cust-role.file-name, INT(cust-role.surrogate), cust-corp.cust-stat).
			end.
			when "person" then do:
				find first person
				   WHERE (person.person-id EQ INT(cust-role.surrogate))
				   NO-LOCK no-error.
				cTmpS  = person.inn.
				cPredWho_Name	= person.first-names + " " + person.name-last.
				cPredWho_INN        = (if ((cTmpS EQ "000000000000") OR (cTmpS = "0")) then "" ELSE cTmpS).
				cPredWho_MainAcct   = KlientMainAcct(cust-role.file-name, INT(cust-role.surrogate), "").
			end.
		END case.
		cKlNum = cust-role.cust-id.
		if (cust-role.cust-cat EQ "�") then do:
			find first person
			   WHERE (person.person-id EQ integer(cKlNum))
			   no-error.
			cKl    = "��".
			iKl    = 5.
		end.
		ELSE do:
			find first cust-corp
			   WHERE (cust-corp.cust-id EQ integer(cKlNum))
			   no-error.
			cOPF   = cust-corp.cust-stat.
			cKl    = if CAN-DO("��,�����,�������,������", cOPF) then "��" ELSE "��".
			iKl    = if (cKl EQ "��") then 6 ELSE 7.
			cOPF   = GetCodeName("����।�",GetCodeVal("����।�", cOPF)).
		end.
	end.	

	when "�" then do:
		find first cust-role
		   WHERE (RECID(cust-role) EQ tmprecid.id)
		   no-error.

		case cust-role.file-name:
			when "cust-corp" then do:
				find first cust-corp
				   WHERE (cust-corp.cust-id EQ INT(cust-role.surrogate))
				   NO-LOCK no-error.
				cPredWho_Name		= cust-corp.name-short.
				cPredWho_INN		= cust-corp.inn.
				cPredWho_MainAcct	= KlientMainAcct(cust-role.file-name, INT(cust-role.surrogate), cust-corp.cust-stat).
		end.
		when "person" then do:
			find first person
			   WHERE (person.person-id EQ INT(cust-role.surrogate))
			   NO-LOCK no-error.
			cTmpS  = person.inn.
		        cPredWho_Name	= person.first-names + " " + person.name-last.
		        cPredWho_INN        = (if ((cTmpS EQ "000000000000") OR (cTmpS = "0")) then "" ELSE cTmpS).
			cPredWho_MainAcct   = KlientMainAcct(cust-role.file-name, INT(cust-role.surrogate), "").
		end.
		when "banks" then do:
			find first banks
			   WHERE (banks.bank-id EQ INT(cust-role.surrogate))
			   NO-LOCK no-error.
			find first cust-ident
			   WHERE cust-ident.cust-cat  	= "�"
			   AND cust-ident.cust-id  	= banks.bank-id
			   AND cust-ident.cust-code-type = "���"
			   NO-LOCK no-error.
			cPredWho_Name     = (if AVAIL banks then GetXAttrValue("banks", STRING(banks.bank-id), "pirShortName") ELSE ""). /* banks.short-name */
			cPredWho_INN      = (if AVAIL cust-ident then cust-ident.cust-code ELSE ""). /* banks.inn */
			cPredWho_MainAcct = KlientMainAcct(cust-role.file-name, INT(cust-role.surrogate), "").
		end.
		END case.
		cKlNum = cust-role.cust-id.
		if (cust-role.cust-cat EQ "�") then do:
			find first person
			   WHERE (person.person-id EQ integer(cKlNum))
			   no-error.
			cKl    = "��".
			iKl    = 8.
		end.
		ELSE do:
			find first cust-corp
			   WHERE (cust-corp.cust-id EQ integer(cKlNum))
			   no-error.
			cOPF   = cust-corp.cust-stat.
			cKl    = if CAN-DO("��,�����,�������,������", cOPF) then "��" ELSE "��".
			iKl    = if (cKl EQ "��") then 10 ELSE 9.
			cOPF   = GetCodeName("����।�",GetCodeVal("����।�", cOPF)).
		end.
	end.
END case.

cKlType = KlType(cKl). 
cKlTabl = KlTabl(cKl).
cKlPole = cKlPoleL[iKl].

{pir-eanketa-20130603.i}

if (iKl LT 5)
then do:
   daFirstOp = ?.
   RUN FirstKlAcct(cKl, integer(cKlNum), OUTPUT cFstAcct, OUTPUT daFirstOp, OUTPUT daFirstCl, OUTPUT cUsrFirst).

   if (cFstAcct EQ "") then do:
	run Fill-SysMes IN h_tmess ("","",3,"�� ���뢠���� ������᪨� ���.\n ��ᯥ���� ������ ��� ������ ����?|��,���").
	if pick-value="1" then bIsBOS = true.
   end.
   ELSE do:
      if (daFirstCl NE ?)
      then do:
	run Fill-SysMes IN h_tmess ("","",3,"�� ������᪨� ��� �������.\n ��ᯥ���� ������ ��� ������ ����?|��,���").
	if pick-value="1" then bIsBOS = true.
      end.

      cTmpS = SUBSTRING(cFstAcct, 6, 3).
      cTmpS = if (cTmpS EQ "810") then "" ELSE cTmpS.
      cUser = GetXAttrValue("acct", cFstAcct + "," + cTmpS, "�����⢑�").
/*
      ELSE do:
         if (NUM-ENTRIES(cUser, ";") GT 1)
         then do:
            if (cKl EQ "�")
            then do:
               if (SUBSTRING(cFstAcct, 1, 3) EQ "301")
               then cUser = ENTRY(1, cUser, ";").
               ELSE cUser = ENTRY(2, cUser, ";").
            end.
            ELSE do:
               cUserFIO = "".
               DO iI = 1 TO NUM-ENTRIES(cUser, ";"):
                  find first _user
                     WHERE (_user._userid = ENTRY(iI, cUser, ";"))
                     NO-LOCK no-error.
                  cUserFIO = cUserFIO + "," + (if AVAIL _user then _user._user-name ELSE "-").
               end.

               cUserFIO = TRIM(cUserFIO, ",").
               pick-value = "1".
               run messmenu.p(9, "����㤭��, �⢥न�訩 ����⨥ ���:", "", cUserFIO).

               if (pick-value EQ "0")
               then RETURN.

               cUser = ENTRY(integer(pick-value), cUser, ";").
            end.
         end.
      end.
*/
   end.
end.

RUN GetLastAnketaDate( /* cVp + */ cKl, integer(cKlNum), OUTPUT daLast, OUTPUT cUsrLast).
/******************************************* ��᢮���� ���祭�� ��६���� � ��. */

DO iPI = 1 TO NUM-ENTRIES(cKlPole):

   cP = ENTRY(iPI, cKlPole).

   case cP:
      when "1" then do:
         cTmpS  = GetTempXAttrValueEx(cKlTabl, cKlNum, "pir-e-FullName", end-date, "").
         cKlP   = PrintStringInfo(
                  if (cTmpS EQ "") then (cOPF + " " + cust-corp.name-corp) ELSE cTmpS).
      end.
      when "2" then do:
         cKlP   = PrintStringInfo(
                  cust-corp.name-corp).
      end.
/*
      when "3" then do:
         cKlP   = PrintStringInfo(
                  if (NUM-ENTRIES(cust-corp.name-corp, " ") > 1) then ENTRY(2, cust-corp.name-corp, " ") ELSE "").
      end.
      when "4" then do:
         cKlP   = PrintStringInfo(
                  if (NUM-ENTRIES(cust-corp.name-corp, " ") > 2) then ENTRY(3, cust-corp.name-corp, " ") ELSE "").
      end.
*/
      when "5" then do:
         cKlP   = PrintStringInfo(
                  person.name-last + " " + person.first-names).
      end.
/*
      when "6" then do:
         cKlP   = PrintStringInfo(
                  ENTRY(1, person.first-names, " ")).
      end.
      when "7" then do:
         cKlP   = PrintStringInfo(
                  if (NUM-ENTRIES(person.first-names, " ") > 1) then ENTRY(2, person.first-names, " ") ELSE "").
      end.
*/
      when "8" then do:
         cTmpS  = GetTempXAttrValueEx(cKlTabl, cKlNum, "pir-e-FullName", end-date, "").
         cKlP   = PrintStringInfo(
                    if {assigned cTmpS} then cTmpS ELSE banks.name).
      end.
      when "9" then do:
         cKlP   = PrintStringInfo(
                  cust-corp.name-short).
      end.
      when "10" then do:
         cTmpS  = GetTempXAttrValueEx(cKlTabl, cKlNum, "pir-e-pirShortName", end-date, "").
         cKlP   = PrintStringInfo(
                  if {assigned cTmpS} then cTmpS ELSE banks.short-name).
      end.
      when "11" then do:
         cKlP   = PrintStringInfo(
                  GetTempXAttrValueEx(cKlTabl, cKlNum, "pir-e-engl-name", end-date, "")).
      end.
      when "12" then do:
         cKlP   = PrintStringInfo(
                  cOPF).
      end.
      when "13" then do:
         cKlP   = PrintStringInfo(
                  GetCodeName("����।�", GetTempXAttrValueEx(cKlTabl, cKlNum, "pir-e-bank-stat", end-date, ""))).
      end.
      when "14" then do:
         cKlP   = PrintStringInfo(
                  GetXAttrValue(cKlTabl, cKlNum, "����")).
      end.
      when "15" then do:
         cKlP   = PrintDateInfo(
                  date(GetTempXAttrValueEx(cKlTabl, cKlNum, "pir-e-RegDate", end-date, ""))).
      end.
      when "16" then do:
         cKlP   = PrintStringInfo(
                  GetTempXAttrValueEx(cKlTabl, cKlNum, "pir-e-RegPlace", end-date, "")).
      end.
      when "17" then do:
         FIND LAST cust-ident
            WHERE (cust-ident.cust-cat       EQ cKlType)
              AND (cust-ident.cust-id        EQ integer(cKlNum))
              AND (cust-ident.cust-code-type EQ "�����")
              AND (cust-ident.class-code     EQ "p-cust-adr")
	      AND (cust-ident.open-date     LE end-date)
              AND ( (cust-ident.close-date     EQ ?) OR (cust-ident.close-date > end-date))
            no-error.
         if (AVAIL cust-ident)
         then do:
            cKlP = GetXAttrValue("cust-ident", cust-ident.cust-code-type + ',' 
                   + cust-ident.cust-code + ',' + STRING(cust-ident.cust-type-num), "country-id") + ","
                 + GetXAttrValue("cust-ident", cust-ident.cust-code-type + ',' 
                   + cust-ident.cust-code + ',' + STRING(cust-ident.cust-type-num), "���������").
            cKlP = PrintStringInfo(
                   if (cKladr = "KLADR") then Kladr(cKlP, cust-ident.issue)
                                         ELSE (RegGNI(cKlP) + cust-ident.issue)).
         end.
         ELSE cKlP = PrintStringInfo(?).
      end.
      when "18" then do:

         FIND LAST cust-ident
            WHERE (cust-ident.cust-cat       EQ cKlType)
              AND (cust-ident.cust-id        EQ integer(cKlNum))
              AND (cust-ident.cust-code-type EQ "����ய")
	      AND (cust-ident.open-date     LE end-date)
              AND (cust-ident.class-code     EQ "p-cust-adr")
              AND ( (cust-ident.close-date     EQ ?) OR (cust-ident.close-date > end-date))
            no-error.

         if (AVAIL cust-ident)
         then do:
            cKlP = GetXAttrValue("cust-ident", cust-ident.cust-code-type + ',' 
                   + cust-ident.cust-code + ',' + STRING(cust-ident.cust-type-num), "country-id") + ","
                 + GetXAttrValue("cust-ident", cust-ident.cust-code-type + ',' 
                   + cust-ident.cust-code + ',' + STRING(cust-ident.cust-type-num), "���������").
            cKlP = PrintStringInfo(
                   if (cKladr = "KLADR") then Kladr(cKlP, cust-ident.issue)
                                         ELSE (RegGNI(cKlP) + cust-ident.issue)).
         end.
         ELSE cKlP = PrintStringInfo(?).
      end.
      when "19" then do:
         FIND LAST cust-ident
            WHERE (cust-ident.cust-cat       EQ cKlType)
              AND (cust-ident.cust-id        EQ integer(cKlNum))
              AND (cust-ident.cust-code-type EQ "�������")
	      AND (cust-ident.open-date     LE end-date)
              AND (cust-ident.class-code     EQ "p-cust-adr")
              AND ( (cust-ident.close-date     EQ ?) OR (cust-ident.close-date > end-date))
            no-error.
         if (AVAIL cust-ident)
         then do:
            cKlP = GetXAttrValue("cust-ident", cust-ident.cust-code-type + ',' 
                   + cust-ident.cust-code + ',' + STRING(cust-ident.cust-type-num), "country-id") + ","
                 + GetXAttrValue("cust-ident", cust-ident.cust-code-type + ',' 
                   + cust-ident.cust-code + ',' + STRING(cust-ident.cust-type-num), "���������").
            cKlP = PrintStringInfo(
                   if (cKladr = "KLADR") then Kladr(cKlP, cust-ident.issue)
                                         ELSE (RegGNI(cKlP) + cust-ident.issue)).
         end.
         ELSE cKlP = PrintStringInfo(?).
      end.
      when "20" then do:
         find first cust-ident
            WHERE (cust-ident.cust-cat       EQ cKlType)
              AND (cust-ident.cust-id        EQ integer(cKlNum))
              AND (cust-ident.cust-code-type EQ "�������")
	      AND (cust-ident.open-date     LE end-date)
              AND (cust-ident.class-code     EQ "p-cust-adr")
              AND (cust-ident.close-date     EQ ?)
            no-error.
         if (AVAIL cust-ident)
         then do:
            cKlP = GetXAttrValue("cust-ident", cust-ident.cust-code-type + ',' 
                   + cust-ident.cust-code + ',' + STRING(cust-ident.cust-type-num), "country-id") + ","
                 + GetXAttrValue("cust-ident", cust-ident.cust-code-type + ',' 
                   + cust-ident.cust-code + ',' + STRING(cust-ident.cust-type-num), "���������").
            cKlP = PrintStringInfo(
                   if (cKladr = "KLADR") then Kladr(cKlP, cust-ident.issue)
                                         ELSE (RegGNI(cKlP) + cust-ident.issue)).
         end.
         ELSE cKlP = PrintStringInfo(?).
      end.
      when "21" then do:
         cKlP   = PrintStringInfo(
                  GetTempXAttrValueEx(cKlTabl, cKlNum, "pir-e-tel", end-date, "")).
      end.
      when "22" then do: /* �� ������ ����� i-誨, ���� � ��� #23 � #25, �.�. �㡫������� */
	vFax = GetTempXAttrValueEx(cKlTabl, cKlNum, "pir-e-fax", end-date, "").
	vEmail = GetTempXAttrValueEx(cKlTabl, cKlNum, "pir-e-email", end-date, "").
	if vFax = "" and vEmail = "" then cKlp = "(���������)".
	if vFax NE "" and vEmail NE "" then cKlp = vFax + ", " + vEmail.
	if vFax = "" and vEmail NE "" then cKlp = vEmail.
	if vFax NE "" and vEmail EQ "" then cKlp = vFax.
	PrintStringInfo(cKlp).
      end.
      when "24" then do:
         cKlP   = PrintStringInfo(
                  TRIM(TRIM(person.phone[1], ",") + " " + TRIM(person.phone[2], ","), ",")).
      end.
      when "26" then do:
         cKlP   = PrintStringInfo(
                  cust-corp.inn).
      end.
      when "27" then do:
         cTmpS  = person.inn.
         cKlP   = PrintStringInfo(
                  if ((cTmpS EQ "000000000000") OR (cTmpS = "0")) then "" ELSE cTmpS).
      end.
      when "28" then do:
         find first cust-ident
            WHERE (cust-ident.cust-cat       EQ cKlType)
              AND (cust-ident.cust-id        EQ integer(cKlNum))
              AND (cust-ident.cust-code-type EQ "���")
            NO-LOCK no-error.
         cKlP   = PrintStringInfo(
                  if (AVAIL cust-ident) then cust-ident.cust-code ELSE "").
      end.
      when "29" then do:
         cKlP   = PrintStringInfo(
		GetTempXAttrValueEx(cKlTabl, cKlNum, "pir-e-���", end-date, "")).
      end.
      when "30" then do:
         cTmpS  = "".
         FOR EACH cust-ident
            WHERE (cust-ident.cust-cat   EQ cKlType)
              AND (cust-ident.cust-id    EQ integer(cKlNum))
              AND (cust-ident.class-code EQ "cust-lic")
              AND (   (cust-ident.close-date =  ?)
                   OR (cust-ident.close-date >= gend-date))
            NO-LOCK:

            cTmpS = cTmpS
                  + "|      ��� ��業���㥬�� ���⥫쭮��: "
                  + PrintStringInfo(if (cKlType EQ "�")
                    then GetCodeName("�����愥��", cust-ident.cust-code-type)
                    ELSE GetCodeName("����������", cust-ident.cust-code-type))
                  + "|      �����: "
                  + PrintStringInfo(cust-ident.cust-code)
                  + "|      ��� �뤠� ��業���: "
                  + PrintDateInfo(cust-ident.open-date)
                  + "|      ��� �뤠��: "
                  + PrintStringInfo(cust-ident.issue)
                  + "|      �ப ����⢨� ��: "
                  + PrintDateInfo(cust-ident.close-date).
         end.
         cKlP   = PrintStringInfo(cTmpS).
      end.
      when "31" then do:
         cTmpS  = GetTempXAttrValueEx(cKlTabl, cKlNum, "pir-e-�ᯮ���࣠�", end-date, "").
         cTmpS2 = GetTempXAttrValueEx(cKlTabl, cKlNum, "pir-e-��鑮�࠭��", end-date, "").
         if ((cTmpS + cTmpS2) EQ "")
         then do:
            cTmpS  = GetTempXAttrValueEx(cKlTabl, cKlNum, "pir-e-���⠢��", end-date, "").
            cTmpS2 = GetTempXAttrValueEx(cKlTabl, cKlNum, "pir-e-���⠢���", end-date, "").
            cKlP   = GetTempXAttrValueEx(cKlTabl, cKlNum, "pir-e-������", end-date, "").
            cKlP   = cKlP
                   + (if (cKlP NE "") AND (cTmpS  NE "") AND (cTmpS  NE "���") then ";" ELSE "")
                   + if ((cTmpS  EQ "") OR (cTmpS  EQ "���"))
                     then "" ELSE ("|      ����� ��४�஢: " + cTmpS).
            cKlP   = cKlP
                   + (if (cKlP NE "") AND (cTmpS  NE "") AND (cTmpS  NE "���") then ";" ELSE "")
                   + if ((cTmpS2 EQ "") OR (cTmpS2 EQ "���"))
                     then "" ELSE ("|      " + cTmpS2).
            cKlP   = PrintStringInfo(cKlP).
         end.
         ELSE do:
            cKlP   = if ((cTmpS  EQ "") OR (cTmpS  EQ "���"))
                     then "" ELSE cTmpS.
            cTmpS  = GetTempXAttrValueEx(cKlTabl, cKlNum, "pir-e-���⠢��", end-date, "").
            cKlP   = cKlP
                   + (if (cKlP NE "") AND (cTmpS  NE "") AND (cTmpS  NE "���") then ";" ELSE "")
                   + if ((cTmpS  EQ "") OR (cTmpS  EQ "���"))
                     then "" ELSE ("|      ����� ��४�஢: " + cTmpS).
            cTmpS  = GetTempXAttrValueEx(cKlTabl, cKlNum, "pir-e-���⠢���", end-date, "").
            cKlP   = cKlP
                   + (if (cKlP NE "") AND (cTmpS  NE "") AND (cTmpS  NE "���") then ";" ELSE "")
                   + if ((cTmpS  EQ "") OR (cTmpS  EQ "���"))
                     then "" ELSE ("|      " + cTmpS).
            cKlP   = cKlP
                   + (if (cKlP NE "") AND (cTmpS2 NE "") AND (cTmpS2 NE "���") then ";" ELSE "")
                   + if ((cTmpS2 EQ "") OR (cTmpS2 EQ "���"))
                     then "" ELSE ("|      " + cTmpS2 + "|").
            cKlP   = PrintStringInfo(cKlP).
         end.
      end.
      when "32" then do:
         cKlP   = PrintStringInfo(
                  GetTempXAttrValueEx(cKlTabl, cKlNum, "pir-e-������", end-date, "")).
      end.
      when "33" then do:
         cTmpS  = ENTRY(1, GetTempXAttrValueEx(cKlTabl, cKlNum, "pir-e-��⠢���", end-date, ""),"/").
	 cKlP   = PrintStringInfo(cTmpS).
			
      end.
      when "33.1" then do:
		if can-do ("*/*", GetTempXAttrValueEx(cKlTabl, cKlNum, "pir-e-��⠢���", end-date, "")) then
                	cTmpS  = ENTRY(2, GetTempXAttrValueEx(cKlTabl, cKlNum, "pir-e-��⠢���", end-date, ""),"/").
		else cTmpS = "".
		cKlP   = PrintStringInfo(cTmpS).	
      end.
      when "34" then do:
         cKlP   = PrintStringInfo(
                  GetTempXAttrValueEx(cKlTabl, cKlNum, "pir-e-�����࣓�ࠢ", end-date, "")).
      end.
      when "35" then do:
         cKlP   = PrintStringInfo(
                  GetTempXAttrValueEx(cKlTabl, cKlNum, "pir-e-pirOtherBanks", end-date, "")).
      end.
      when "36" then do:
         cKlP   = PrintStringInfo(
                  GetTempXAttrValueEx(cKlTabl, cKlNum, "pir-e-pirBusImage", end-date, "")).
      end.
      when "37" then do: /* 1.12 */
         cTmpS  = if bIsBOS then "������" ELSE GetTempXAttrValueEx(cKlTabl, cKlNum, "pir-e-��᪎��", end-date, "").
         cKlP   = PrintStringInfo(cTmpS).
      end.
      when "38" then do: /* 1.13 */
	if bIsBOS 
	  then cTmpS2 = "������᪨� ����樨 ������ �� ��뢠�� �����७�� � �� �易�� � ��������樥� (��뢠����) ��室��, ����祭��� ����㯭� ��⥬, ��� 䨭���஢����� ���ਧ��".
	ELSE do:
          cTmpS2 = GetTempXAttrValueEx(cKlTabl, cKlNum, "pir-e-�業����᪠", end-date, "").
          if (cTmpS2 EQ "")
          then
            cTmpS2 = GetCode("Pir�業����᪠", cTmpS).
	end.
        cKlP   = PrintStringInfo(cTmpS2).
      end.
      when "39" then do: /* �� �ᯮ������. ������ 74 */
         cKlP   = PrintStringInfo(
                  GetTempXAttrValueEx(cKlTabl, cKlNum, "pir-e-�����룄����", end-date, "")).

      end.
      when "40" then do:
         cKlP   = PrintDateInfo(
                  date(GetTempXAttrValueEx(cKlTabl, cKlNum, "pir-e-BirthDay", end-date, ""))).
      end.
      when "41" then do:
         cKlP   = PrintDateInfo(
                  person.birthday).
      end.
      when "42" then do:
         cKlP   = PrintStringInfo(
                  GetTempXAttrValueEx(cKlTabl, cKlNum, "pir-e-BirthPlace", end-date, "")).
      end.
      when "43" then do:
         find first country 
            WHERE (country.country-id EQ cust-corp.country-id)
            NO-LOCK no-error.
         cKlP   = PrintStringInfo(
                  if (AVAIL country) then country.country-name ELSE ?).
      end.
      when "44" then do:
         cTmpS = GetTempXAttrValueEx(cKlTabl, cKlNum, "pir-e-country-id2", end-date, "").
         find first country
            WHERE (country.country-id EQ cTmpS)
            NO-LOCK no-error.
         cKlP   = PrintStringInfo(
                  if (AVAIL country) then country.country-name ELSE ?).
      end.
      when "45" then do:
         cKlP   = PrintStringInfo(
                  GetCodeName("�������", GetTempXAttrValueEx(cKlTabl, cKlNum, "pir-e-document-id", end-date, ""))
                + ", N " + GetTempXAttrValueEx(cKlTabl, cKlNum, "pir-e-document", end-date, "")
                + ", �뤠� " + STRING(date(GetTempXAttrValueEx(cKlTabl, cKlNum, "pir-e-Document4Date_vid", end-date, "")), "99.99.9999")
                + ", " + GetTempXAttrValueEx(cKlTabl, cKlNum, "pir-e-issue", end-date, "")).
      end.
      when "46" then do:
         FIND LAST cust-ident
            WHERE /* (cust-ident.close-date EQ ? OR cust-ident.close-date >= 01/01/2001)
              AND */ (cust-ident.class-code     EQ "p-cust-ident")
              AND (cust-ident.cust-cat       EQ cKlType)
              AND (cust-ident.cust-id        EQ integer(cKlNum))
	      AND (cust-ident.open-date     LE end-date)
              AND CAN-DO(v_cust-code-type, cust-ident.cust-code-type)
            NO-LOCK USE-INDEX open-date no-error.
         if NOT (AVAIL cust-ident)
         then do:
            FIND LAST cust-ident
               WHERE /* (cust-ident.close-date EQ ? OR cust-ident.close-date >= 01/01/2001)
                 AND */ (cust-ident.class-code     EQ "p-cust-ident")
                 AND (cust-ident.cust-cat       EQ cKlType)
                 AND (cust-ident.cust-id        EQ integer(cKlNum))
	      AND (cust-ident.open-date     LE end-date)
               NO-LOCK USE-INDEX open-date no-error.
         end.

         if (AVAIL cust-ident)
         then do:
            cTmpS = cust-ident.cust-code-type + ','
                  + cust-ident.cust-code      + ','
                  + STRING(cust-ident.cust-type-num).
            cTmpS = GetXAttrValue("cust-ident", cTmpS, "���ࠧ�").
            cKlP  = PrintStringInfo(
                    GetCodeName("�������", cust-ident.cust-code-type)
                  + ", N " + cust-ident.cust-code
                  + ", �뤠� " + STRING(cust-ident.open-date, "99.99.9999")
                  + ", " + cust-ident.issue
                  + (if (cTmpS EQ "") then "" ELSE (", �/� " + cTmpS))).
         end.
         ELSE cKlP = PrintStringInfo(?).
      end.
      when "47" then do:
         cTmpS  = GetTempXAttrValueEx(cKlTabl, cKlNum, "pir-e-��������", end-date, "").
         cTmpS2 = GetTempXAttrValueEx(cKlTabl, cKlNum, "pir-e-VisaNum", end-date, "").

         if ((cTmpS + cTmpS2) EQ "")
         then cKlP = " " + PrintStringInfo("").
         ELSE do:
            cKlP   = ". ����� ����樮���� �����: " + cTmpS
                   + "|      ����� ���㬥��, ���⢥ত��饣� �ࠢ� �� �ॡ뢠��� (�஦������) � ��|      ����: "
                   + PrintStringInfo(ENTRY(1, cTmpS2, " "))
                   + "|      ����� ���㬥��: "
                   + if (NUM-ENTRIES(cTmpS2, " ") > 1) then ENTRY(2, cTmpS2, " ") ELSE "".

            cTmpS  = GetTempXAttrValueEx(cKlTabl, cKlNum, "pir-e-country-id2", end-date, "").
            find first country
               WHERE (country.country-id EQ cTmpS)
               NO-LOCK no-error.

            cKlP   = cKlP
                   + "|      �ࠦ����⢮: "
                   + PrintStringInfo(if (AVAIL country) then country.country-name ELSE "")
                   + "|      ���� �����: "
                   + PrintStringInfo(GetTempXAttrValueEx(cKlTabl, cKlNum, "pir-e-�������삨���", end-date, ""))
                   + "|      �ப �ॡ뢠��� � "
                   + PrintDateInfo(date(GetTempXAttrValueEx(cKlTabl, cKlNum, "pir-e-�����ॡ뢑", end-date, "")))
                   + " �� "
                   + PrintDateInfo(date(GetTempXAttrValueEx(cKlTabl, cKlNum, "pir-e-�����ॡ뢏�", end-date, "")))
                   + "|      �ப ����⢨� �ࠢ� �ॡ뢠��� � "
                   + PrintDateInfo(date(GetTempXAttrValueEx(cKlTabl, cKlNum, "pir-e-�����ࠢ�ॡ�", end-date, "")))
                   + " �� "
                   + PrintDateInfo(date(GetTempXAttrValueEx(cKlTabl, cKlNum, "pir-e-�����ࠢ�ॡ��", end-date, ""))).
         end.
      end.

      when "48" then do:
         cTmp48  = GetTempXAttrValueEx(cKlTabl, cKlNum, "�����_����", end-date, "").
           if (cTmp48 NE "") AND (TRIM(CAPS(cTmp48)) NE "���" AND LENGTH(cTmp48)>ChCount) then do:
		cklP = "� �".
              end.
	    ELSE 
		cklP = "���".
                /*         cKlP   = if (cTmp48 NE "") then "� �" ELSE "���". */
     end.
      when "49" then do:
         cTmp49_1 = GetTempXAttrValueEx(cKlTabl, cKlNum, "�⭎���_����", end-date, "").
         cTmp49_2 = GetTempXAttrValueEx(cKlTabl, cKlNum, "�⥯�����_����", end-date, "").
           if (cTmp49_1 NE "") AND (TRIM(CAPS(cTmp49_1)) NE "���" AND LENGTH(cTmp49_1)>ChCount) AND (cTmp49_2 NE "") AND (TRIM(CAPS(cTmp49_2)) NE "���" AND LENGTH(cTmp49_2)>ChCount)then do:
		cklP = "� �".
              end.
	    ELSE 
		cklP = "���".
     end.



      when "51" then do:
         find first banks-code
            WHERE (banks-code.bank-id        EQ banks.bank-id)
              AND (banks-code.bank-code-type EQ "���-9")
            NO-LOCK no-error.
         cKlP   = PrintStringInfo(
                  if (AVAIL banks-code) then banks-code.bank-code ELSE "").
      end.

      when "60" then do:	/* 1.14 */
         cKlP   = IF bIsBOS
		    then "��� ������ ���"
		    else PrintStringInfo(IF (daFirstOp NE ?) THEN STRING(daFirstOp, "99.99.9999") ELSE "��� ������ ���").
      end.

      when "61" then do:        /* 1.15 !!! */
         cKlP = PrintDateInfo(
                if (cKlType EQ "�") then cust-corp.date-in ELSE (
                if (cKlType EQ "�") then person.date-in
                                    ELSE banks.date-in)).
      end.

      when "62" then do:	/* 1.16 */
         cKlP   = if bIsBOS then "01.01.2099" ELSE PrintDateInfo(daLast).
      end.
      when "63" then do:	/* 1.17 */
         if (daFirstOp NE ?) AND NOT bIsBOS
         then
            cKlP   = UserFIO(cUsrFirst).
         ELSE
            cKlP   = UserFIO("").
      end.
      when "64" then do:	/* 1.18 */
         if (daFirstOp NE ?) AND NOT bIsBOS
         then
            cKlP   = UserFIO(cUser).
         ELSE
            cKlP   = UserFIO("").
      end.
      when "65" then do:	/* 1.19 */
/*         if bIsBOS
           then do:
	    RUN GetLastHistoryDateSince("��", person.person-id, person.date-in, OUTPUT oLastDate, OUTPUT oUser).
/* message oLastDate oUser view-as alert-box. */
	     cKlP   = UserFIO(oUser).
	   end.
           ELSE*/ cKlP   = UserFIO(cUsrLast).
      end.
      when "66" then do:        /* 1.20 */
         cKlP   = UserFIO(USERID).
      end.
      when "70" then do:
/* >> �뫮
         cKlP   = PrintStringInfo(ENTRY(1, cPredWho)).
   << �뫮 */
/* >> �⠫� */
         cKlP   = cPredWho_Name.
/* << �⠫� */
      end.
      when "71" then do:
/* >> �뫮
         cKlP   = PrintStringInfo(ENTRY(2, cPredWho)).
   << �뫮 */
/* >> �⠫� */
         cKlP   = cPredWho_INN.
/* << �⠫� */
      end.
      when "72" then do:
/* >> �뫮
         cKlP   = PrintStringInfo(ENTRY(3, cPredWho)).
   << �뫮 */
/* >> �⠫� */
         cKlP   = cPredWho_MainAcct.
/* << �⠫� */
      end.
      when "73" then do:
         find first class
            WHERE (class.class-code EQ cust-role.class-code)
            NO-LOCK no-error.
         cKlP   = class.name.
      end.
      when "74" then do:
         cKlP   = PrintStringInfo(
                  GetXAttrValue("cust-role", STRING(cust-role.cust-role-id), "PIRosnovanie")).
      end.
      when "75" then do:
         cKlP   = PrintDateInfo(cust-role.open-date).
      end.
      when "76" then do:
         cKlP   = PrintDateInfo(cust-role.close-date).
      end.
      when "77" then do:
         cTmp77 = GetTempXAttrValueEx(cKlTabl, cKlNum, "�����_���", end-date, "").
           if (cTmp77 NE "") AND (TRIM(CAPS(cTmp77)) NE "���" AND LENGTH(cTmp77)>ChCount) then do:
		cklP = "� �".
              end.
	    ELSE 
		cklP = "���".
     end.
      when "78" then do:
          cTmp78 = GetTempXAttrValueEx(cKlTabl, cKlNum, "�����_����", end-date, "").
           if (cTmp78 NE "") AND (TRIM(CAPS(cTmp78)) NE "���" AND LENGTH(cTmp78)>ChCount) then do:		
		cklP = "� �".
              end.
	    ELSE 
		cklP = "���".
     end.

     when "79" then do:

         cKlP   = cPredWho_Name.

     end.

      when "90" then do:
       cKlP  = "". 
           if (cTmp48 NE "") AND (TRIM(CAPS(cTmp48)) NE "���" AND LENGTH(cTmp48)>ChCount) then do:
               if (NUM-ENTRIES (cTmp48, ";") NE 3) AND (TRIM(CAPS(cTmp48)) NE "���") then do:
                   MESSAGE "�訡�� � ���. ४����� �����_����!" VIEW-AS ALERT-BOX.
		   Return.
               end.
            cKlP  = cKlP 
                         + "| "
			 + "|  1. ������� �����࠭�� �㡫��� ��������� ��殬: "
                         + "|�) �࣠������: "
                         + PrintStringInfo(ENTRY(1, cTmp48, ";"))
                         + "|�) ���������� ���������: "
                         + PrintStringInfo(ENTRY(2, cTmp48, ";")) 
                         + "|�) ������������ ���㤠��⢠: "
                         + PrintStringInfo(ENTRY(3, cTmp48, ";"))
                         + "| ". 
         end.
           if (cTmp49_1 NE "") AND (TRIM(CAPS(cTmp49_1)) NE "���" AND LENGTH(cTmp49_1)>ChCount) AND (cTmp49_2 NE "") AND (TRIM(CAPS(cTmp49_2)) NE "���" AND LENGTH(cTmp49_2)>ChCount)then do:
               if (NUM-ENTRIES (cTmp49_1, ";") NE 3) then do:
                   MESSAGE "�訡�� ���������� ���. ४����� �⭎���_����!" VIEW-AS ALERT-BOX.
		   Return.
               end.
            cKlP  = cKlP 
			 + "|  2. ����� �⭮襭�� � �����࠭���� �㡫�筮�� �������⭮�� ����: "
                         + "|�) �࣠������: "
                         + PrintStringInfo(ENTRY(1, cTmp49_1, ";"))
                         + "|�) ���������� ���������: "
                         + PrintStringInfo(ENTRY(2, cTmp49_1, ";")) 
                         + "|�) ������������ ���㤠��⢠: "
                         + PrintStringInfo(ENTRY(3, cTmp49_1, ";")).
               if (NUM-ENTRIES (cTmp49_2, ";") NE 2) then do:
                   MESSAGE "�訡�� ���������� ���. ४����� �⥯�����_����!" VIEW-AS ALERT-BOX.
		   Return.
               end.
                         cKlP  = cKlP 
                         + "|�) �⥯��� த�⢠ ��� ���� �⭮襭��: "
                         + PrintStringInfo(ENTRY(1, cTmp49_2, ";"))
                         + "|�) �������, ��� � (�� ����稨) ����⢮ �������⭮�� ���: "
                         + PrintStringInfo(ENTRY(2, cTmp49_2, ";"))
                         + "| ". 
        end. /* 49 */

          if (cTmp77 NE "") AND (TRIM(CAPS(cTmp77)) NE "���" AND LENGTH(cTmp77)>ChCount) then do:
               if (NUM-ENTRIES (cTmp77, ";") NE 2) then do:
                   MESSAGE "�訡�� ���������� ���. ४����� �����_���!" NUM-ENTRIES (cTmp77, ";")  VIEW-AS ALERT-BOX.
		   Return.
               end.
            cKlP  = cKlP 
			 + "|  3. ������� ��������� ��殬 �㡫�筮� ����㭠த��� �࣠����樨: "
                         + "|�) �࣠������: "
                         + PrintStringInfo(ENTRY(1, cTmp77, ";"))
                         + "|�) ���������� ���������: "
                         + PrintStringInfo(ENTRY(2, cTmp77, ";")) 
                         + "| ". 
      end. /* 77 */

          if (cTmp78 NE "") AND (TRIM(CAPS(cTmp78)) NE "���" AND LENGTH(cTmp78)>ChCount) then do:
               if (NUM-ENTRIES (cTmp78, ";") NE 2) then do:
                   MESSAGE "�訡�� ���������� ���. ४����� �����_����!" VIEW-AS ALERT-BOX.
		   Return.
               end.
            cKlP  = cKlP 
			 + "|  4. �������: ��ᨩ᪨� �㡫��� ��������� ��殬: "
                         + "|�) �࣠������: "
                         + PrintStringInfo(ENTRY(1, cTmp78, ";"))
                         + "|�) ���������� ���������: "
                         + PrintStringInfo(ENTRY(2, cTmp78, ";")) 
                         + "|�) ������������ ���㤠��⢠: ���ᨩ᪠� �������"
                         + "| ". 
      end. /* 78 */
     end. /* when 90  */

   END case.

/*  MESSAGE cP cKlP
   VIEW-AS ALERT-BOX QUESTION BUTTONS OK. */


   cAnketa = REPLACE(cAnketa, "#" + cP + "#", cKlP).

end.

/******************************************* ���� ������ ***********************/
{setdest.i}
DO WHILE (LENGTH(cAnketa) GT 0):

   if (INDEX(SUBSTRING(cAnketa, 1, iLineW + 1), "|") NE 0)
   then
      ASSIGN
         cPrLine = SUBSTRING(cAnketa, 1, INDEX(cAnketa, "|") - 1)
         cAnketa = SUBSTRING(cAnketa, INDEX(cAnketa, "|") + 1)
      .
   ELSE
      ASSIGN
         iwwI    = MAX(R-INDEX(SUBSTRING(cAnketa, 1, iLineW + 1), " "),
                       R-INDEX(SUBSTRING(cAnketa, 1, iLineW    ), ","))
         iwwI    = (if (iwwI GT 0) then iwwI ELSE iLineW)
         cPrLine = SUBSTRING(cAnketa, 1, iwwI)
         cAnketa = "      " + SUBSTRING(cAnketa, iwwI + 1)
      .
   if (LENGTH(cPrLine) GT iLineW)
   then cPrLine = SUBSTRING(cPrLine, 1, iLineW).

   PUT UNFORMATTED cPrLine SKIP.
end.

{preview.i}
{intrface.del}
