/* ��� ��� ����, ���������� ������������� 2013�.   
   pir-intellipp.p
   ���������������� �������� ���������.
   
   �������� ������:                                  
   v0.9 - ���������, ����� ������������� �������  
  	  ��������� ������. � ����������� ��       
          �������� ������� _bs (��� ������) ���
	  _e (�� �������). � ��������� �����,
	  ��������� ������ ��� ���-�� � ����� 01.
          ������ #2254 
*/

def var input-proc as char no-undo.
def input parameter rid as recid.


/* ������������� ����� uid�, ������������ �� 04101 (�4, �10-1). */

If can-do("04101*",userid('bisquit')) then input-proc = "pirpp-uni_e".
	else input-proc = "pirpp-uni_bs".

If SEARCH(input-proc + ".r") <> ? then run VALUE (input-proc + ".r")(rid).
	else run VALUE(input-proc + ".p")(rid).
