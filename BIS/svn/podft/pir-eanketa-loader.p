/* ��� "��� ����" ��ࠢ����� ��⮬�⨧�樨 2013�.	*/
/* �����稪 ������ ������ #3124			*/
/* ������ ࠡ���:                                       */
/* ����ਬ �����䨪��� pir-eanketa � �� ��������     */
/* ��� ����� ���㠫��� ��楤��� ����஥��� ������.   */
/* � ����⢥ �室���� ��ࠬ��� �ॡ��: �, �, �, �� - */
/* ��-� ���� �� �⮣�, ᮮ⢥��⢥���, ��蠥��� ��    */
/* 䨧���, �ਪ�, �।�⠢�⥫� ��� �룮���ந����⥫�*/
/* ����஢ �.�. 13.06.2013				*/

{globals.i} 
{getdate.i}

def var rProc as char no-undo.
def var Parms as char no-undo init "06000LPP;02000KEG;LOBYREVA;04000KIY,KLADR".
def input parameter iParam as char no-undo.

find last code where code.class eq 'pir-eanketa' and date(entry(1,code.val)) le end-date no-lock no-error.
if available(code) then do:
	rProc = code.code.
	Parms = iParam + "," + Parms.
	if search(rProc + ".r") <> ? then
		run value (rProc + ".r")(Parms).
	else
		if search(rProc + ".p") <> ? then run value(rProc + ".p")(Parms).
		else message "��楤�� " rProc "�� �������!" view-as alert-box.

end.
else message "������ �ଠ ������ �� ������� ��" end-date "!" view-as alert-box.


