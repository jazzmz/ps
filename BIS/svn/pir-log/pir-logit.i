/* 17.01.2013 ��� ����	*/
/* �������� �.�.	*/
/* � /home2/bis/quit41d/pir.log/ ������ ���� ����-���.p.log */

{globals.i}

define stream log-file.
define variable fname as character no-undo.

fname = "/home2/bis/quit41d/pir.log/" + this-procedure:file-name + ".log".
output stream log-file to value (fname) append.
put stream log-file unformatted string(today,"99.99.9999")  " " string(time,"hh:mm:ss") " " userid("bisquit") skip.
output stream log-file close.

