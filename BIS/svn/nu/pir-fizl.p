/*��ନ��� ���㧪� ����: ���䨧���    �����㤮�⢥७�� ��筮�� 
�����稪:�㢨���� �.�.
����: ��᪮� �.�.
p.s. �㦭� � ⠪�� ���� ��� ����㧪� � excel ��� �����-� ���⭮�� 
02.04.2012
*/

{globals.i}

{tmprecid.def}
{getdate.i}
{intrface.get xclass}  


{setdest.i}

def var cDocum AS CHAR NO-UNDO.

for each tmprecid,
first person where RECID(person) = tmprecid.id NO-LOCK.

cDocum = "".
            FIND LAST cust-ident
               WHERE cust-ident.cust-code-type = person.document-id
               AND cust-ident.cust-cat = "�"
               AND cust-ident.cust-id = person.person-id
            NO-LOCK NO-ERROR.

            IF (AVAIL cust-ident)
            THEN DO:            
                  cDocum = GetXAttrValueEx("cust-ident", cust-ident.cust-code-type + "," + cust-ident.cust-code + ","  + STRING(cust-ident.cust-type-num),"���ࠧ�", "").  
                  cDocum = GetCodeName("�������", cust-ident.cust-code-type) + ": " 
	            	+ cust-ident.cust-code 
        	    	+ ". �뤠�: " + REPLACE(REPLACE(cust-ident.issue, CHR(10), ""), CHR(13), "") + " "
            		+ cDocum + " " + STRING(cust-ident.open-date, "99.99.9999").
            END.


PUT UNFORMATTED person.name-last + " " +  person.first-names + "             " + cDocum SKIP.
end.

{preview.i}

{intrface.del}