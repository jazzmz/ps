/**************************************************************
 *                                                            *        
 *                                                            *
 * ��楤�� �ନ��� �஢����� ��������� �� ���� ��⥬ *     
 *                                                            *
 *                                                            *
 *                                                            *
 **************************************************************
 *                                                            *
 * ����: ��᪮� �.�.                                        *
 * ��� ᮧ�����: 18.01.2011                                  *
 * ��� �602                                                *
 *                                                            *
 **************************************************************/

using Progress.Lang.*.
{globals.i}

/**********************************************************
 * �㭪�� �����頥� ᯨ᮪ ����� ��⮢ �१ �������.
 * ��ଠ� ᯨ᪠: <���1>,<���� ��� ��� 1>,<���2>,<���� ��� ��� 2>,...
 ***********************************************************
 *
 * ����  : ��᫮� �. �.
 * ���   : 01.04.13
 * ��� : #2729
 **/
FUNCTION getPairsAcctList RETURNS CHAR():

 DEF VAR cRes AS CHAR INIT "" NO-UNDO.
 DEF BUFFER code FOR code.
 

      FOR EACH code WHERE code.class  EQ "Dual-bal-acct"
	              AND code.parent EQ "Dual-bal-acct" NO-LOCK:
           cRes = cRes + code.code + "," + code.val + ",".
      END.

 cRes = TRIM(cRes,",").

 RETURN cRes.

END FUNCTION.

/**********************************
 * �㭪�� �뤥��� �����ᮢ��    *
 * ���� �� ���.                *
 **********************************
 * ���� : ��᫮� �. �.
 * ���  : 01.04.13
 * ���: #2729
 **********************************/
FUNCTION getBalPart RETURNS CHAR(INPUT cAcct AS CHAR):
   RETURN SUBSTRING(cAcct,1,5).
END FUNCTION.

{getdate.i &datelabel="��砫� ���� �:"}

DEF VAR cPar      AS CHAR           NO-UNDO.
DEF VAR bProblems AS LOG INIT FALSE NO-UNDO.
DEF VAR oTable1   AS TTable2        NO-UNDO.

DEF VAR oTpl        AS TTpl       NO-UNDO.
DEF VAR vLnCountInt AS INT        NO-UNDO. /* ���稪 ��⮢ */
DEF VAR vLnTotalInt AS INT        NO-UNDO. /* ��饥 ������⢮ ��⮢*/
DEF VAR iCount      AS INT INIT 0 NO-UNDO.
DEF VAR TEMPSTR     AS CHAR       NO-UNDO.

DEF BUFFER bAcct FOR Acct.

cPar = getPairsAcctList().



DEF TEMP-TABLE tAcct NO-UNDO
		     FIELD tacct LIKE acct.acct.

oTable1 = new TTable2(4).
oTpl = new TTpl("pir-dualacct.tpl").


{init-bar.i "��ࠡ�⪠ ��⮢"}

FOR EACH acct WHERE LOOKUP(STRING(acct.bal-acct),cPar) > 0 and ((acct.close-date > end-date) OR (acct.close-date = ?)) NO-LOCK:
    vLnTotalInt = vLnTotalInt + 1.
end.

FOR EACH acct where LOOKUP(STRING(acct.bal-acct),cPar) > 0 and ((acct.close-date > end-date) OR (acct.close-date = ?)) NO-LOCK:

         /* ������ ��ப� - �������� ࠡ��� ����� */
         {move-bar.i
            vLnCountInt
            vLnTotalInt
          }
    
    if LOOKUP(getBalPart(acct.contr-acct),cPar) > 0 then 
       do:
         if CAN-FIND(bacct where bacct.acct = acct.contr-acct 
                             and ((bacct.contr-acct <> acct.acct) 
                                  OR (acct.close-date<>bacct.close-date) OR bacct.contr-acct = ?) NO-LOCK) 
                    then bProblems = TRUE.
      end.
    else 
      do:
       if acct.close-date = ? then   
       bProblems = TRUE. 
      end.
   if bProblems then 
       do:
  
        if NOT CAN-FIND(tAcct where (tacct.tacct = acct.acct) NO-LOCK) then 
        do:
        CREATE tacct.
        ASSIGN
              tacct = acct.acct.
          iCount = iCount + 1.
          oTable1:addRow().
          oTable1:AddCell(iCount).
          oTable1:addCell(acct.acct).

          IF LOOKUP(getBalPart(acct.contr-acct),cPar) = 0 THEN oTable1:addCell("�� �������� ���� ���"). ELSE oTable1:addCell(acct.contr-acct).
          FIND FIRST _user WHERE _user._userid EQ acct.user-id NO-LOCK NO-ERROR.
          if AVAILABLE(_user) THEN oTable1:addCell(_user._user-name).
                              else oTable1:addCell(" ").


          bProblems = FALSE.
         end.
       end.

   vLnCountInt = vLnCountInt + 1.


end.
oTpl:AddAnchorValue("Table1",oTable1).
{setdest.i}
  oTpl:show().
{preview.i}

DELETE OBJECT oTable1.
DELETE OBJECT oTpl.