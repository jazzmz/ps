{globals.i}
{intrface.get xclass}
{intrface.get pirwc}

{pfuncdef
   &LIBDEF        = "YES"
   &NAME          = "PIRWU"
   &LIBNAME       = "�㭪樨 ��� ࠡ��� � WU"
   &DESCRIPTION   = "����ন� �㭪樨 ࠧࠡ�⠭�� � ��� ��� ����"
   }

{pfuncdef
   &NAME          = "�������WU"
   &DESCRIPTION   = "������뢠�� ������� �� WU"
   &PARAMETERS    = "�㬬� ��ॢ���,��࠭� �����⥫�,����� ��ॢ���,���� �� ��ॢ��"
   &RESULT        = "�����"
   &SAMPLE        = "�������WU(100,'USA',840,TRUE)"
   }
  DEF INPUT  PARAM sumTransfer AS DEC     NO-UNDO.
  DEF INPUT  PARAM countryRec  AS CHAR    NO-UNDO.
  DEF INPUT  PARAM valTransfer AS CHAR    NO-UNDO.
  DEF INPUT  PARAM isFast      AS LOG     NO-UNDO.

  DEF OUTPUT PARAM out_Result  AS DEC     NO-UNDO.
  DEF OUTPUT PARAM is-ok       AS INT     NO-UNDO.

  DEF VAR vZoneOfCom AS CHAR NO-UNDO.
  DEF VAR vCom       AS CHAR NO-UNDO.


  vZoneOfCom = getXAttrValue("country",countryRec,"PirWUZone").

  is-ok = 1.

  FIND FIRST code WHERE code.parent = "PirWUComm"
                    AND code.name   = vZoneOfCom
                    AND DEC(ENTRY(1,code.val,"-")) <= sumTransfer AND sumTransfer <= DEC(ENTRY(2,code.val,"-"))
                    AND CAN-DO(code.description[1],valTransfer) NO-LOCK NO-ERROR.



  IF NOT AVAILABLE(code) THEN DO:
    MESSAGE COLOR WHITE/RED "�� ������� ������� ��� ��ॢ��� �� " sumTransfer " " valTransfer
                            " � ���� " vZoneOfCom 
    VIEW-AS ALERT-BOX TITLE "�訡�� ���᪠ �����ᨨ".
    is-ok = -1.
    RETURN.
  END.


    vCom = IF isFast THEN code.description[2] ELSE code.description[3].

    /*************************************
     * �᫨ �� ������ �⠢�� ��� ���� *
     * ��� ������ ����, � ��室��  *
     * � �訡���.                        *
     *************************************/
    IF (vCom = ? OR vCom = "" OR vCom = "?") AND (code.misc[1] = ? OR code.misc[1] = "?")  THEN DO:
       MESSAGE COLOR WHITE/RED "������� ��� ������� ⨯� ��ॢ��� �� ��।�����." VIEW-AS ALERT-BOX TITLE "�訡�� ���᪠ �����ᨨ".   
       is-ok = -1.
      RETURN.
    END.

    IF misc[1] <> ? AND misc[1] <> "?" AND misc[1] <> "" THEN DO:
        out_Result = DYNAMIC-FUNCTION(misc[1]  IN h_pirwc,sumTransfer,countryRec,valTransfer,isFast).
    END. ELSE DO:

        IF SUBSTRING(vCom,LENGTH(vCom)) = "=" THEN DO:
           out_Result = DEC(SUBSTRING(vCom,1,LENGTH(vCom) - 1)).
        END. ELSE DO:
           out_Result = ROUND(sumTransfer * DEC(SUBSTRING(vCom,1,LENGTH(vCom) - 1)) / 100,2).
        END.
    END.

END PROCEDURE.

{pfuncdef
   &NAME          = "�㬬���ॢ����WU"
   &DESCRIPTION   = "������뢠�� �㬬� ��ॢ���� �� WU �� ����"
   &PARAMETERS    = "�����,���"
   &RESULT        = "�����"
   &SAMPLE        = "�㬬���ॢ����WU(810,01/01/2013)"
   }
  DEF INPUT  PARAM vVal AS DEC     NO-UNDO.
  DEF INPUT  PARAM vDate AS Date     NO-UNDO.    

  DEF OUTPUT PARAM out_Result  AS DEC     NO-UNDO.
  DEF OUTPUT PARAM is-ok       AS INT     NO-UNDO.

  DEF BUFFER bufOp      FOR op.
  DEF BUFFER bufOpEntry FOR op-entry.                                                         
 
  DEF VAR vRes AS DEC INIT 0 NO-UNDO.
  DEF VAR vResInVal AS DEC INIT 0 NO-UNDO.

  DEF VAR cVal as Char NO-UNDO.


  if vVal = 810 then cVal = "".
  if vVal = 840 THEN cVal = "".


  FOR EACH bufOp WHERE vDate = bufOp.op-date 
                   AND bufOp.class-code = "opbwu" NO-LOCK,
   FIRST bufOpEntry OF bufOp WHERE bufOpEntry.currency = cVal NO-LOCK:


   IF bufOpEntry.acct-cr BEGINS "302" THEN DO:   /*��ࠢ��*/
     vRes = vRes + bufOpEntry.amt-rub.
     vResInVal = vResInVal + bufOpEntry.amt-cur.
   END.

  END.
  if vVal = 810 then out_Result = vRes.
  if vVal = 840 then out_Result = vResInVal.

END PROCEDURE.


{pfuncdef
   &NAME          = "��蠊������WU"
   &DESCRIPTION   = "������뢠�� ���� ���� �����ᨨ �� WU"
   &PARAMETERS    = "�㬬� ��ॢ���,�㬬� �����ᨨ,��࠭� �����⥫�"
   &RESULT        = "�����"
   &SAMPLE        = "��蠊������WU(100,10,'USA')"
   }
  DEF INPUT  PARAM sumTransfer AS DEC     NO-UNDO.
  DEF INPUT  PARAM comAll      AS DEC     NO-UNDO.
  DEF INPUT  PARAM countryRec  AS CHAR    NO-UNDO.

  DEF OUTPUT PARAM out_Result  AS DEC     NO-UNDO.
  DEF OUTPUT PARAM is-ok       AS INT     NO-UNDO.

  out_Result = ROUND(comAll * 0.16,2).
  is-ok = 1.
END PROCEDURE.


{pfuncdef
   &NAME          = "��ࠬ�����ࠢ��WU"
   &DESCRIPTION   = "����砥� ����� ����室��� ��� ��ࠢ�� ��ॢ���"
   &PARAMETERS    = "���⠢騪 ����� [������,WUPOS]"
   &RESULT        = "����� ���祭�� �१ �������"
   &SAMPLE        = "������쏠ࠬ���돥ॢ���WU('��������')"
   }
  DEF INPUT  PARAM source      AS CHAR    NO-UNDO.
  DEF OUTPUT PARAM out_Result  AS CHAR    NO-UNDO.
  DEF OUTPUT PARAM is-ok       AS INT     NO-UNDO.
  RUN VALUE(TSysClass:whatShouldIRun2("pir-tfrm")) (OUTPUT out_Result).
  is-ok = 1.
END PROCEDURE.

{pfuncdef
   &NAME          = "��ࠬ����뤠�WU"
   &DESCRIPTION   = "����砥� ����� ����室��� ��� �뤠� ��ॢ���"
   &PARAMETERS    = "���⠢騪 ������ [������,WUPOS]"
   &RESULT        = "����� ���祭�� �१ �������"
   &SAMPLE        = "������쏠ࠬ���돥ॢ���WU('��������')"
   }
  DEF INPUT  PARAM source      AS CHAR    NO-UNDO.
  DEF OUTPUT PARAM out_Result  AS CHAR    NO-UNDO.
  DEF OUTPUT PARAM is-ok       AS INT     NO-UNDO.
  RUN VALUE(TSysClass:whatShouldIRun2("pir-tfrm1")) (OUTPUT out_Result).
  is-ok = 1.
END PROCEDURE.

{pfuncdef
   &NAME          = "�।�������"
   &DESCRIPTION   = "�����頥� ���� � ���ன ������� ���㬥��� �� 㪠������ �࠭���樨"
   &PARAMETERS    = "��� �� ���ன �饬 ���㬥���,��� �࠭���樨,�����,[��� �᫨ �� ��諨]"
   &RESULT        = "��� �।��饣� ���㬥��"
   &SAMPLE        = "�।�������(05/31/2013,���_��(),'')"
   }
  DEF INPUT  PARAM currDate    AS DATE        NO-UNDO.
  DEF INPUT  PARAM currTr      AS CHAR        NO-UNDO.
  DEF INPUT  PARAM vCurrency   AS CHAR        NO-UNDO.
  DEF INPUT  PARAM defDate     AS DATE INIT ? NO-UNDO.

  DEF OUTPUT PARAM out_Result  AS DATE    NO-UNDO.
  DEF OUTPUT PARAM is-ok       AS INT     NO-UNDO.


  DEF BUFFER bufOpEntry FOR op-entry.
  DEF BUFFER bufOp      FOR op.

  defDate = (IF defDate = ? THEN DATE(FGetSetting("����_��","","01/01/1900")) ELSE defDate).

  out_Result = defDate.

/*  FOR FIRST bufOpEntry WHERE bufOpEntry.op-date < currDate
                         AND bufOpEntry.currency = vCurrency NO-LOCK, 
   FIRST bufOp OF bufOpEntry WHERE bufOp.op-kind = currTr NO-LOCK:
    out_Result = bufOpEntry.op-date.
  END.*/

   FIND LAST bufOp where bufOp.op-kind = currTr and bufOp.op-date < currDate.

   IF AVAILABLE bufOp THEN out_result = bufOp.op-date.


  is-ok = 1.
END PROCEDURE.

{pfuncdef
   &NAME          = "������ਭ�"
   &DESCRIPTION   = "�����頥� ���ਭ����� ������ �� ��ॢ��� WU � ���� ������� �� �뤠�� ��ॢ��� �१ �������"
   &PARAMETERS    = "��� ��砫� ��ਮ��,��� ����砭�� ��ਮ��,�����"
   &RESULT        = "DECIMAL ���ਭ����� ������"
   &SAMPLE        = "������ਭ�(01/01/2012,03/01/2013,'')"
   }

  DEF INPUT PARAM vDate1       AS DATE    NO-UNDO.
  DEF INPUT PARAM vDate2       AS DATE    NO-UNDO.
  DEF INPUT PARAM vCurrency    AS CHAR    NO-UNDO.

  DEF OUTPUT PARAM out_Result  AS CHAR    NO-UNDO.
  DEF OUTPUT PARAM is-ok       AS INT     NO-UNDO.

  DEF BUFFER bufOp      FOR op.
  DEF BUFFER bufOpEntry FOR op-entry.                                                         
 
  DEF VAR vRes AS DEC INIT 0 NO-UNDO.
  DEF VAR vResInVal AS DEC INIT 0 NO-UNDO.
  DEF VAR vCom AS DEC INIT 0 NO-UNDO.

  FOR EACH bufOp WHERE vDate1 <= bufOp.op-date AND bufOp.op-date < vDate2 
                   AND bufOp.class-code = "opbwu" NO-LOCK,
   FIRST bufOpEntry OF bufOp WHERE bufOpEntry.currency = vCurrency NO-LOCK:


   IF bufOpEntry.acct-cr BEGINS "409" THEN DO:
     vRes = vRes - bufOpEntry.amt-rub.
     vResInVal = vResInVal - bufOpEntry.amt-cur.
     vCom = vCom + DECIMAL(getXAttrValueEx("op",STRING(bufOp.op),"��䊮�","0")).
   END. ELSE DO:
     vRes = vRes + bufOpEntry.amt-rub.
     vResInVal = vResInVal + bufOpEntry.amt-cur.

   END.

  END.

  out_Result = STRING(vRes) + "," + STRING(vCom) + "," + STRING(vResInVal).
  is-ok = 1.

END PROCEDURE.

{pfuncdef
   &NAME          = "��⍥�WU"
   &DESCRIPTION   = "�����頥� ��� �������襭��� ���⮢ �� WU"
   &PARAMETERS    = "��� ������ �� ����,��� � ���ன ᮢ��蠥��� ������"
   &RESULT        = "CHAR ��� �� ���஬� ������ ���� ��������"
   &SAMPLE        = "��⍥�WU('30232810900000001001',01/01/2013)"
   }

  DEF INPUT  PARAM vAcct       AS CHAR    NO-UNDO.
  DEF INPUT  PARAM vCurrDate   AS DATE    NO-UNDO.

  DEF OUTPUT PARAM out_Result  AS CHAR    NO-UNDO.
  DEF OUTPUT PARAM is-ok       AS INT     NO-UNDO.

  DEF BUFFER bufAcct      FOR acct.
  DEF BUFFER bufContrAcct FOR acct.
                                                                
  DEF VAR vAcct1  AS CHAR NO-UNDO.
  DEF VAR vAcct2  AS CHAR NO-UNDO.
  DEF VAR vResult AS CHAR NO-UNDO.

  FIND FIRST bufAcct WHERE bufAcct.acct = vAcct NO-LOCK NO-ERROR.

  IF AVAILABLE(bufAcct) THEN DO:
     IF CAN-FIND(FIRST bufContrAcct WHERE bufContrAcct.contr-acct = bufAcct.acct) THEN DO:

    ASSIGN
     vAcct1 = bufAcct.acct
     vAcct2 = bufAcct.contr-acct
    .

    FIND FIRST op-entry 
    	 WHERE (
    	 		CAN-DO(vAcct1 + "," + vAcct2, op-entry.acct-db)
    	       	OR
    	       	CAN-DO(vAcct1 + "," + vAcct2, op-entry.acct-cr)
    	       ) AND op-entry.op-date = vCurrDate
    	 NO-LOCK NO-ERROR.
   	IF AVAIL op-entry THEN DO:
   		IF CAN-DO(vAcct1, op-entry.acct-db) OR CAN-DO(vAcct1, op-entry.acct-cr) THEN
   			vResult = vAcct1.
   		ELSE 
   			vResult = vAcct2.   		
   	END. ELSE
   		vResult = vAcct1.

     END.
  END.

 is-ok      = 0.
 out_Result = vResult.
END PROCEDURE.


{pfuncdef
   &NAME          = "��⍥�WU2"
   &DESCRIPTION   = "�����頥� ��� �������襭��� ���⮢ �� WU. "
   &PARAMETERS    = "��� ������ �� ����,��� � ���ன ᮢ��蠥��� ������"
   &RESULT        = "CHAR ��� �� ���஬� ������ ���� ��������"
   &SAMPLE        = "��⍥�WU('30232810900000001001',01/01/2013)"
   }

  DEF INPUT  PARAM vAcct       AS CHAR    NO-UNDO.
  DEF INPUT  PARAM vCurrDate   AS DATE    NO-UNDO.

  DEF OUTPUT PARAM out_Result  AS CHAR    NO-UNDO.
  DEF OUTPUT PARAM is-ok       AS INT     NO-UNDO.

  DEF BUFFER bufAcct      FOR acct.
  DEF BUFFER bufContrAcct FOR acct.

  DEF VAR vAcct1  AS CHAR  NO-UNDO.
  DEF VAR vAcct2  AS CHAR  NO-UNDO.

  DEF VAR vOAcct1   AS TAcct NO-UNDO.
  DEF VAR vOAcct2   AS TAcct NO-UNDO.

  DEF VAR vPos1 AS DEC INIT 0 NO-UNDO.
  DEF VAR vPos2 AS DEC INIT 0 NO-UNDO.

  FIND FIRST bufAcct WHERE bufAcct.acct = vAcct NO-LOCK NO-ERROR.

  IF AVAILABLE(bufAcct) THEN DO:


    FIND FIRST bufContrAcct WHERE bufContrAcct.contr-acct = bufAcct.acct NO-LOCK NO-ERROR.


      IF AVAILABLE(bufContrAcct) THEN DO:

        ASSIGN
          vAcct1 = bufAcct.acct
          vAcct2 = bufAcct.contr-acct
        .

           /*****************
            * ���冷� IF �����.
            * ���������, �� ���⮪ ���� ⮫쪮 �� �����
            * �� ��⮢. 
            *****************/
          
           vOAcct1 = NEW TAcct(BUFFER bufAcct:HANDLE).
           vOAcct2 = NEW TAcct(BUFFER bufContrAcct:HANDLE).

            vPos2 = vOAcct2:getLastPos2Date(vCurrDate - 1).
                IF vPos2 > 0 THEN DO:
                    out_Result = vAcct2.
                END.

            vPos1 = vOAcct1:getLastPos2Date(vCurrDate - 1).

                IF vPos1 > 0 OR vPos2 = 0 THEN DO:
                    out_Result = vAcct1.
                END.

             

           DELETE OBJECT vOAcct1.
           DELETE OBJECT vOAcct2.
     END.
  END.

 is-ok      = 0.

END PROCEDURE.


{pfuncdef
 &NAME        = "��XMLWU"
 &DESCRIPTION = "�����頥� ���祭�� ����室����� ���� �� XML"
 &PARAMETERS  = "XML � ��ࠬ��ࠬ� ��ॢ���,���� � ����,[����஢�� �����祭��='ibm866'],[�ਣ����쭠� ����஢��='utf-8']"
 &RESULT      = "CHAR ���祭�� XML ����"
 &SAMPLE      = "��XMLWU('111.xml','/Request','ibm866','UTF-8')"
}

  DEF INPUT PARAM iFileName  AS CHAR  NO-UNDO.
  DEF INPUT PARAM iPath      AS CHAR  NO-UNDO.
  DEF INPUT PARAM iSEncoding AS CHAR  NO-UNDO.
  DEF INPUT PARAM iTEncoding AS CHAR  NO-UNDO.

  DEF OUTPUT PARAM out_Result  AS CHAR    NO-UNDO.
  DEF OUTPUT PARAM is-ok       AS INT     NO-UNDO.


  DEF VAR xDOC       AS HANDLE NO-UNDO.
  DEF VAR xROOT      AS HANDLE NO-UNDO.
  DEF VAR currXRef   AS HANDLE NO-UNDO.

  DEF VAR vLevel     AS INT    NO-UNDO.
  DEF VAR isRefFound AS LOG    NO-UNDO.
  DEF VAR vRefCount  AS INT    NO-UNDO.
  DEF VAR vCurrPoint AS CHAR   NO-UNDO.

  DEF VAR currLevel AS INT NO-UNDO.
  DEF VAR j AS INT NO-UNDO.


  CREATE X-DOCUMENT xDOC.
  CREATE X-NODEREF  xRoot.

  xDOC:LOAD("FILE",iFileName,FALSE).
  xDOC:GET-DOCUMENT-ELEMENT(xRoot).

  vLevel = NUM-ENTRIES(iPath,"/") - 2.


     DO currLevel = 1 TO vLevel:
        vRefCount  = xRoot:NUM-CHILDREN.  
        vCurrPoint = ENTRY(currLevel + 2,iPath,"/").
  
        isRefFound = FALSE.

           DO j = 1 TO vRefCount:
              CREATE X-NODEREF  currXRef.
              xRoot:GET-CHILD(currXRef,j).

                IF currXRef:NAME = vCurrPoint THEN DO:
                   xRoot = currXRef.
                   currXRef = ?.
                   isRefFound = TRUE.
                   LEAVE.
                END.
              DELETE OBJECT currXRef.
           END.  
  
           IF NOT isRefFound THEN LEAVE.
     END.

IF isRefFound THEN DO:
 xRoot:GET-CHILD(xRoot,1).
 out_Result = CODEPAGE-CONVERT(xRoot:NODE-VALUE,IF iTEncoding = ? THEN "ibm866" ELSE iTEncoding,IF iSEncoding = ? THEN "UTF-8" ELSE iSEncoding).
END. ELSE out_Result = "-1".
is-ok = 0.
END PROCEDURE.

{pfuncdef
 &NAME        = "��࠭�23"
 &DESCRIPTION = "�८�ࠧ�� 2� ������� ��� ��࠭� � 3� ������� �� �ࠢ�筨�� ��࠭"
 &PARAMETERS  = "2� ᨬ����� ��� ��࠭�"
 &RESULT      = "CHAR 3� ᨬ����� ��� ��࠭�"
 &SAMPLE      = "��࠭�23('RU')"
}

  DEF INPUT  PARAM iCountryCode AS CHAR    NO-UNDO.
  DEF OUTPUT PARAM out_Result   AS CHAR    NO-UNDO.
  DEF OUTPUT PARAM is-ok        AS INT     NO-UNDO.

  DEF BUFFER country FOR country.
  DEF BUFFER signs   FOR signs.

  is-ok = -1.

  FOR FIRST signs WHERE signs.file-name   = "country"
                      AND signs.code       = "ALFA-2"
                      AND signs.code-value = iCountryCode NO-LOCK,                      
      FIRST country WHERE country.country-id = signs.surrogate NO-LOCK:
     out_Result = country.country-id.
     is-ok = 0.
  END.

END PROCEDURE.

{pfuncdef
 &NAME        = "����⠑�࠭�����WU"
 &DESCRIPTION = "�८�ࠧ�� ��� ��࠭� � ���� ������"
 &PARAMETERS  = "2� ��� 3� ᨬ����� ��� ��࠭�"
 &RESULT      = "CHAR ��� ������"
 &SAMPLE      = "����⠑�࠭�����WU('US')"
}
  DEF INPUT PARAM iCountry AS CHAR NO-UNDO.
  DEF OUTPUT PARAM out_Result   AS CHAR    NO-UNDO.
  DEF OUTPUT PARAM is-ok        AS INT     NO-UNDO.
  is-ok = 1.

  CASE iCountry:
    WHEN "USD" THEN DO:
       out_Result = "840".
    END.
    WHEN "RUR" THEN DO:
       out_Result = "810".
    END.
  END CASE.
END PROCEDURE.


{pfuncdef
 &NAME        = "����숬���WU"
 &DESCRIPTION = "�����頥� ��� 䠩�� �������饣� ����㧪�"
 &PARAMETERS  = "[������� ��४���]"
 &RESULT      = "CHAR ��� 䠩�� ����� � ��⥬"
 &SAMPLE      = "����숬���WU('/home2/bis/quit41d/imp-exp/wu')"
}
  DEF INPUT  PARAM iBaseDir     AS CHAR    NO-UNDO.
  DEF OUTPUT PARAM out_Result   AS CHAR    NO-UNDO.
  DEF OUTPUT PARAM is-ok        AS INT     NO-UNDO.

 DEF VAR vFileName AS CHAR NO-UNDO.
 is-ok = -1.

 INPUT FROM OS-DIR (IF iBaseDir <> ? THEN iBaseDir ELSE "./") NO-ATTR-LIST.
 
  REPEAT:
     IMPORT vFileName.

     IF vFileName MATCHES "*\.xml" THEN DO:

       ASSIGN
         is-ok      = 0
         out_Result = (IF iBaseDir <> ? THEN iBaseDir ELSE "./") + vFileName.
       .
       LEAVE.
     END.

  END.
INPUT CLOSE.

IF is-ok = -1 THEN DO:

    MESSAGE COLOR WHITE/RED "�� ������ 䠩� ������!"  VIEW-AS ALERT-BOX TITLE "������ ������ �����".


END.


END PROCEDURE.

{pfuncdef
 &NAME        = "����쐠���������WU"
 &DESCRIPTION = "�����頥� ࠧ��� 䠩��"
 &PARAMETERS  = "���� � 䠩��"
 &RESULT      = "CHAR ��� 䠩�� ����� � ��⥬"
 &SAMPLE      = "����쐠���������WU('/home2/bis/quit41d/imp-exp/wu/1.xml')"
}

  DEF INPUT  PARAM iFileName    AS CHAR    NO-UNDO.
  DEF OUTPUT PARAM out_Result   AS DEC     NO-UNDO.
  DEF OUTPUT PARAM is-ok        AS INT     NO-UNDO.

FILE-INFO:FILE-NAME = iFileName.
is-ok = 1.
out_Result = FILE-INFO:FILE-SIZE.
END PROCEDURE.
