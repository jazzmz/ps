/* ��� "��� ����" ���������� ������������� 2013�.   
   ���������� ��� ������ � ������.                  
   �������� ������                                  
   v1.0 - ����� ���������� ��������� ���� �������,  
  	  ��������� � ���������� ������� ���,       
  	  ���������� � �������� ���������� �������  
  	  ����.                                     
   v1.2 - ������� �������: 
	��c������� ��� (���.)
	���� 1 ��� � ����� 1 ��� (� ������ ������������).


*/

{globals.i}

/* ���������� true, ���� ���� - �������� ���� � false, ���� ������� */
Function IsHoliday returns logical (
				     input fDate as date).
   Def var dFlag as logical init false no-undo.
   Def buffer bHoliday for holiday.

   If (weekday(fDate) modulo 6) eq 1 then
      dFlag = true.
   For first bHoliday where bHoliday.op-date eq fDate no-lock:
      dFlag = NOT dFlag.
   End.
   return dFlag.
End Function.

/* ���������� ��������� �� ���������� ����� ������� ���� */
Function NextWDay Returns date (
		Input fDate as date).
	Do While isholiday(fDate):
		fDate = fDate + 1.
	End.
	Return fDate.
End Function.

/* ���������� ���������� �� ���������� ���� ������� ���� */
Function BeforeWDay Returns date (
		Input fDate as date).
	Do While isholiday(fDate):
		fDate = fDate - 1.
	End.
	Return fDate.
End Function.

Function IncWDay Returns date (
		 Input fDate as date,
			coldays as integer).
Def var i as integer  no-undo.
	Do i = 1 to coldays:
		fDate = fDate + 1.
		Do While (IsHoliday(fDate)):
			fDate = fDate + 1.
		end.
	End.
Return fDate.
End Function.	

Function DecWDay Returns date (
		 Input fDate as date,
		       coldays as integer).
Def var i as integer  no-undo.
	Do i = 1 to coldays:
		fDate = fDate - 1.
		Do While (IsHoliday(fDate)):
			fDate = fDate - 1.
		End.
	End.
Return fDate.
End Function.	

Function LeapYear returns logical (input fDate as date).
	def var dLeap as logical no-undo.
	dLeap = (if truncate(year(fDate) / 4,0) = year(fDate) / 4 then yes else no).
	return dLeap.
end function.

Function BeforeYear returns date (input fDate as date).
	def var dDate as date no-undo.
	if (LeapYear(fDate)) then do:
		if fDate GE date(month(02/29/12),day(02/29/12),year(fDate)) then dDate = fDate - 366.
	end.
        else dDate = fDate - 365.
	return dDate.
end function.

Function NextYear returns date (input fDate as date).
	def var dDate as date no-undo.
	if (LeapYear(fDate)) then do:
		if fDate LE date(month(02/29/12),day(02/29/12),year(fDate)) then dDate = fDate + 366.
	end.
		else dDate = fDate + 365.
	return dDate.
end function.