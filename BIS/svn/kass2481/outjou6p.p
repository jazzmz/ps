{pirsavelog.p}
/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-1996 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: OUTJOU3p.P
      Comment: ���ᮢ� ��ୠ� �� ��室� �� ���㬥�⠬ (祪��) ࠧ����� �� ���ࠧ�������
   Parameters:
         Uses:
      Used by:
      Created: 18/03/2004 Nav
     Modified:

*/
Form "~n@(#) OUTJOUR3.P 1.0 Serge 12/08/96 Serge 12/08/96 comment"
with frame sccs-id stream-io width 250.

{globals.i}
{pick-val.i}
{getdate.i}
{tmprecid.def}        /** �ᯮ��㥬 ���ଠ�� �� ��㧥� */

do on error undo, return on endkey undo, return:
    run acct.p ("b", 3).
    if return-value = "error" or keyfunc(lastkey) = "END-ERROR" then
       undo, return.
    if not can-find(first tmprecid) then do:
       message "�� ��࠭� ���!" view-as alert-box.
       undo, retry.
    end.
end.

{setdest.i &cols=96}

def var JourName as char init "������ �� ���X���" no-undo.

{jourvtb3.i
           &DESK_ACCT   = acct-cr                /* ��� �����                                   */
           &CLNT_ACCT   = acct-db                /* ��� ������                                 */
           &JOUR_NAME   = JourName
}

{preview.i}
/*************************************************************************************************/