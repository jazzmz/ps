/**********************************************
 * Выводит на экран информацию, об сроке            *
 * окончания возможности пополнения вклада.     *
 * ********************************************
 * Автор: Маслов Д. А.                                                  *
 * Дата создания: 9:34 16.09.2010                                 *
 * Заявка: #397                                                                *
 **********************************************/
{pir-isdeper.i}
{tmprecid.def}

DEF INPUT PARAM cChoise AS CHARACTER INITIAL "information" NO-UNDO.

DEF VAR oTable AS TTable NO-UNDO.

DEF VAR oTpl AS TTpl NO-UNDO.

DEF VAR dPermitDate AS DATE    NO-UNDO.
DEF VAR dBegDate    AS DATE    NO-UNDO.
DEF VAR dEndDate    AS DATE    NO-UNDO.
DEF VAR lResult     AS LOGICAL NO-UNDO.

oTpl = new TTpl("pir-getdpdate.tpl").
oTable = new TTable(6).

FOR EACH tmprecid NO-LOCK,
   EACH loan WHERE RECID(loan) EQ tmprecid.id NO-LOCK:
        dPermitDate = getPermitDateByNum(loan.contract,loan.class-code,loan.cont-code).
        dBegDate = DATE(GetLoanInfo_ULL(loan.contract,loan.cont-code,"open_date",lResult)).
        dEndDate = getDepozEndDate(loan.contract,loan.class-code,loan.cont-code).
      CASE cChoise:
            WHEN "report" THEN
                    DO:
                            oTable:addRow().
                            oTable:addCell(loan.cont-code).
                            oTable:addCell(dPermitDate).
                            oTable:addCell(dBegDate).
                            IF dEndDate <> ? THEN oTable:addCell(dEndDate). ELSE oTable:addCell("-").                
                            IF dEndDate <> ? THEN oTable:addCell(dEndDate - dPermitDate). ELSE oTable:addCell("-").
                            IF dEndDate <> ? THEN oTable:addCell(dEndDate - dBegDate). ELSE oTable:addCell("-").
                    END.
            OTHERWISE 
                DO:
                            MESSAGE "Пополнять разрешено до: " + STRING(dPermitDate) VIEW-AS ALERT-BOX INFORMATION TITLE "Информация по #397".
                 END.
      END CASE.  
      
END. /* По всем вкладам */

oTpl:addAnchorValue("TABLE1",oTable).

        CASE cChoise:
                WHEN "report" THEN
                        DO:
                                    {setdest.i}                                                                    
                                        oTpl:show().
                                    {preview.i}
                        END.
        END CASE.

DELETE OBJECT oTable.
DELETE OBJECT oTpl.