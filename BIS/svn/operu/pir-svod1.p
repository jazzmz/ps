DEFINE VARIABLE oIBankBisCompr AS TIBankBisCompr NO-UNDO.
DEFINE VARIABLE oDateInput     AS TDTInput 	 NO-UNDO.
DEFINE VARIABLE oTpl 	       AS TTpl		 NO-UNDO.
DEFINE VARIABLE cProtName      AS Char		 NO-UNDO.

oDateInput = new TDTInput(2).
oDateInput:head = "Интервал сверки?".
oDateInput:x = 200.
oDateInput:y = 70.
oDateInput:show().

 IF oDateInput:isSet THEN
    DO:
      /* Если была установлена дата */
      
      oIBankBisCompr=new TIBankBisCompr().
      oIBankBisCompr:firstProvider="/home/bis/bin/getxmlibank.bash".
      oIBankBisCompr:firstSource="/home2/bis/quit41d/imp-exp/bifit/svod.xml".   
   
      oIBankBisCompr:date-beg=oDateInput:beg-datetime.              
      oIBankBisCompr:date-end=oDateInput:end-datetime.
      
      oIBankBisCompr:exec().

      oTpl = new TTpl("pir-svod1.tpl").
      oTpl:addAnchorValue("Table1",oIBankBisCompr:TableInIBank).
      oTpl:addAnchorValue("Table2",oIBankBisCompr:TableInBIS).
      oTpl:addAnchorValue("ItogoInIBank",oIBankBisCompr:ItogoInIBank).
      oTpl:addAnchorValue("KolvoInIBank",oIBankBisCompr:KolvoInIBank).
      oTpl:addAnchorValue("ItogoInBIS",oIBankBisCompr:ItogoInBIS).       
      oTpl:addAnchorValue("KolvoInBIS",oIBankBisCompr:KolvoInBIS).   
 
      {setdest.i}
      oTpl:show().
      {preview.i}                                                            
      cProtName = "/home2/bis/quit41d/imp-exp/protocol/ibankbiscompr" + String(oIBankBisCompr:date-beg,"99-99-9999") + String(oIBankBisCompr:date-end,"99-99-9999") + ".txt".
      OUTPUT TO VALUE(cProtName).
      oTpl:show().
      OUTPUT CLOSE.
      DELETE OBJECT oTpl.
      DELETE OBJECT oIBankBisCompr.
     
    END.

DELETE OBJECT oDateInput.      
