/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2007 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: f155_2_3_print.p
      Comment: ��ଠ 155. ������� 2,3. ���㠫����� ���⭮� ���.
   Parameters:
         Uses:
      Used by:
      Created: 15.01.2008 20:55 TSL
     Modified: 31.01.2008 18:24 TSL      88726
     Modified: 20.02.08 ler 88726 - �.155. ���㧪� � ����� ���� �ଠ� � 01.01.2008.
     Modified: 22.09.08 ler 96575 - �.155. ��ᯮ�� � ��� ��� (01.08.08)
     Modified: 01.12.08 ler 101272 - �.155. ���������� �ଠ� �� F155_08.ARJ � 01.11.2008.
     Modified: 26.04.12 ler 0166365 - �.155. ��ᯮ�� � �ணࠬ�� KLIKO 2742-� 01.01.12
     Modified: 10.05.12 ler 0171679 - �.155.
     Modified: 24.08.12 ler 0177895 - �.155. ��ᯮ�� � �ணࠬ�� KLIKO 2835-� �� 01.08.12 (F155_11.PAK)
     Modified: 23.08.13 ler 0204764 - �.155. ��ᯮ�� � �ணࠬ�� KLIKO 3006-� 01.08.13 F155_16.pak (����� �� 30.07.2013)
*/
/******************************************************************************/
{globals.i}
{norm.i}
{done}
&GLOBAL-DEFINE STREAM STREAM fil

{wordwrap.def}

DEFINE VARIABLE mFirstTime AS LOGICAL     NO-UNDO INIT YES.

/**************************************************************************************/
/* ������� ����                                                                   */
/**************************************************************************************/
PROCEDURE doPrint.
   DEFINE INPUT  PARAMETER iDml    AS HANDLE     NO-UNDO.
   DEFINE INPUT  PARAMETER iDataID AS INT64    NO-UNDO.

   SUBSCRIBE TO "beginReport" IN iDml.
   SUBSCRIBE TO "beginBlock"  IN iDml.
   SUBSCRIBE TO "recordData"  IN iDml.
   SUBSCRIBE TO "endBlock"    IN iDml.
   SUBSCRIBE TO "beginSprav"  IN iDml.
   SUBSCRIBE TO "recordSprav" IN iDml.
   &IF DEFINED(D01-07-12) GT 0 &THEN
      SUBSCRIBE TO "beginSprav2"  IN iDml.
      SUBSCRIBE TO "recordSprav2" IN iDml.
      SUBSCRIBE TO "recordSepSprav2" IN iDml.
      SUBSCRIBE TO "endSprav2" IN iDml.
   &ENDIF
   &IF DEFINED(D01-07-13) GT 0 &THEN
      SUBSCRIBE TO "Sprav3-5"  IN iDml.
   &ENDIF

   RUN doPrint IN iDml.

   RUN endReport.

   UNSUBSCRIBE TO ALL IN iDml.

END PROCEDURE. /* doPrint */
/**************************************************************************************/
/* ��砫� ����. ����� ���������                                                    */
/**************************************************************************************/
PROCEDURE beginReport.
   DEFINE INPUT  PARAMETER iBegDate AS DATE       NO-UNDO.
   DEFINE INPUT  PARAMETER iEndDate AS DATE       NO-UNDO.

   {setdest.i
       &cols = 250
       &nodef = {comment}
       &APPEND = APPEND}

END PROCEDURE. /* beginReport */
/**************************************************************************************/
/* ����� ����������                                                                  */
/**************************************************************************************/
PROCEDURE beginBlock.
   DEFINE INPUT  PARAMETER iPartNum AS INT64     NO-UNDO.

IF GetSysConf("ModeExport") NE "Exp�����" THEN
DO:
   &IF DEFINED(D01-01-12) EQ 0 &THEN
      &IF DEFINED(InstrNNNN-U) GT 0 &THEN
         IF iPartNum EQ 2 THEN
            PUT {&stream} UNFORMATTED
               SKIP(1)
               "                                ������ 2. ���� ᤥ���, �।�ᬠ�ਢ��騥 ���⠢�� ����᭮�� ��⨢� " SKIP(1)
               "                                                                                                                            ���.��." SKIP(1)
               "�����������������������������������������������������������������������������������������������������������������������������������Ŀ" SKIP
               "������ �         ������������ �����㬥��           �     �㬬�     �     �㬬�     ���ॠ��������륳��ॠ��������륳    �����     �" SKIP.
         ELSE
            PUT {&stream} UNFORMATTED
               SKIP(1)
               "                                        ������ 3. ���� ᤥ��� ����� (��ᯮ�⠢���) " SKIP(1)
               "                                                                                                                            ���.��." SKIP(1)
               "�����������������������������������������������������������������������������������������������������������������������������������Ŀ" SKIP
               "������ �        ���� ��ᯮ�⠢���� ᤥ���          �     �㬬�     �     �㬬�     ���ॠ��������륳��ॠ��������륳    �����     �" SKIP.
      &ELSE
         IF iPartNum EQ 2 THEN
            PUT {&stream} UNFORMATTED
               SKIP(1)
               "                                ������ 2. ���� ᤥ���, �।�ᬠ�ਢ��騥 ���⠢�� ����᭮�� ��⨢� " SKIP(1)
               "                                                                                                                            ���.��." SKIP(1)
               "����������������������������������������������������������������������������������������������������������������������������������Ŀ" SKIP
            &IF DEFINED(Instr2055-U) GT 0 &THEN
               "������         ������������ �����㬥��           �     �㬬�     �     �㬬�     ���ॠ��������륳��ॠ��������륳    �����     �" SKIP.
            &ELSE
               "������           �������� �����㬥��             �     �㬬�     �     �㬬�     �     �㬬�     �     �㬬�     �    �����     �" SKIP.
            &ENDIF
         ELSE
            PUT {&stream} UNFORMATTED
               SKIP(1)
               "                                        ������ 3. ���� ᤥ��� ����� (��ᯮ�⠢���) " SKIP(1)
               "                                                                                                                            ���.��." SKIP(1)
               "����������������������������������������������������������������������������������������������������������������������������������Ŀ" SKIP
            &IF DEFINED(Instr2055-U) GT 0 &THEN
               "������        ���� ��ᯮ�⠢���� ᤥ���          �     �㬬�     �     �㬬�     ���ॠ��������륳��ॠ��������륳    �����     �" SKIP.
            &ELSE
               "������        ���� ��ᯮ�⠢���� ᤥ���          �     �㬬�     �     �㬬�     �     �㬬�     �     �㬬�     �    �����     �" SKIP.
            &ENDIF
      &ENDIF
   &ENDIF
END.
ELSE
DO:
   IF iPartNum EQ 2 THEN
      PUT {&stream} UNFORMATTED
         SKIP(1)
         "                                ������ 2. ���� ᤥ���, �।�ᬠ�ਢ��騥 ���⠢�� ����᭮�� ��⨢� " SKIP(1)
         SKIP.
   ELSE
      PUT {&stream} UNFORMATTED
         SKIP(1)
         "                                        ������ 3. ���� ᤥ��� ����� (��ᯮ�⠢���) " SKIP(1)
         SKIP.
END.

IF GetSysConf("ModeExport") NE "Exp�����" THEN
   &IF DEFINED(D01-01-12) GT 0 &THEN
      IF iPartNum EQ 2 THEN
         PUT {&stream} UNFORMATTED
            SKIP(1)
            "                                                        ������ 2. ���� ᤥ���" SKIP(1)
            "                                                                                                                             ���.��." SKIP(1)
            "�����������������������������������������������������������������������������������������������������������������������������������Ŀ" SKIP
            "������ �         ������������ �����㬥��           �     �㬬�     �     �㬬�     ���ॠ��������륳��ॠ��������륳    �����     �" SKIP
            "���ப��                                            �   �ॡ������  �  ��易⥫��� �    ���ᮢ�   �    ���ᮢ�   � �� ��������  �" SKIP
            "�      �                                            �               �               �    ࠧ����    �    ࠧ����    �    ����     �" SKIP
            "�      �                                            �               �               �(������⥫��)�(����⥫��)�               �" SKIP
            "�����������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
            "�  1   �                    2                       �       3       �       4       �       5       �       6       �       7       �" SKIP
            "�����������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP.
      ELSE
         PUT {&stream} UNFORMATTED
            SKIP(1)
            "                                              ������ 3. �ந������ 䨭��ᮢ� �����㬥��� "                                                           SKIP(1)
            "                                                                                                                                             ���.��." SKIP(1)
            "���������������������������������������������������������������������������������������������������������������������������������������������������Ŀ" SKIP
            "������ �         ������������ �����㬥��           �   ��ࠢ�������  �⮨�����     �     �㬬�     �     �㬬�     ���ॠ��������륳��ॠ��������륳" SKIP
            "���ப��                                            �������������������������������Ĵ   �ॡ������  �  ��易⥫��� �    ���ᮢ�   �    ���ᮢ�   �" SKIP
            "�      �                                            �     ��⨢     �     ���ᨢ    �               �               �    ࠧ����    �    ࠧ����    �" SKIP
            "�      �                                            �               �               �               �               �(������⥫��)�(����⥫��)�" SKIP
            "���������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
            "�  1   �                    2                       �       3       �       4       �       5       �       6       �       7       �       8       �" SKIP
            "���������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP.
   &ELSE
      PUT {&stream} UNFORMATTED
      &IF DEFINED(InstrNNNN-U) GT 0 &THEN
         "���ப��                                            �   �ॡ������  �  ��易⥫��� �    ���ᮢ�   �    ���ᮢ�   � �� ��������  �" SKIP
         "�      �                                            �               �               �    ࠧ����    �    ࠧ����    �    ����     �" SKIP
         "�      �                                            �               �               �(������⥫��)�(����⥫��)�               �" SKIP
         "�����������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
         "�  1   �                    2                       �       3       �       4       �       5       �       6       �       7       �" SKIP
         "�����������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
      &ELSEIF DEFINED(Instr2055-U) GT 0 &THEN
         "� �/� �                                            �   �ॡ������  �  ��易⥫��� �    ���ᮢ�   �    ���ᮢ�   � �� ��������  �" SKIP
         "�     �                                            �               �               �    ࠧ����    �    ࠧ����    �    ����     �" SKIP
         "�     �                                            �               �               �(������⥫��)�(����⥫��)�               �" SKIP
      &ELSE
         "� �/� �                                            �   �ॡ������  �  ��易⥫��� � ������⥫��� � ����⥫��� � �� ��������  �" SKIP
         "�     �                                            �               �               �   ��८業��  �   ��८業��  �    ����     �" SKIP
      &ENDIF
         "����������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
         "�  1  �                    2                       �       3       �       4       �       5       �       6       �       7       �" SKIP
         "����������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP.
   &ENDIF
END PROCEDURE. /* beginBlock */
/**************************************************************************************/
/* ����� ����������                                                                  */
/**************************************************************************************/
PROCEDURE beginData.
END PROCEDURE. /* beginBlock */
/**************************************************************************************/
/* ����� ������                                                                      */
/**************************************************************************************/
PROCEDURE recordData.
   DEFINE INPUT  PARAMETER iBuff AS HANDLE      NO-UNDO.
   &IF DEFINED(D01-01-12) GT 0 &THEN
      DEFINE INPUT  PARAMETER iPartNum AS INT64     NO-UNDO.
   &ENDIF

   DEFINE VARIABLE vInstrName AS CHARACTER EXTENT 3 NO-UNDO.

   IF NOT mFirstTime THEN
      PUT {&stream} UNFORMATTED
      &IF DEFINED(D01-01-12) GT 0 &THEN
            "������������������������������������������������������������������������������������������������������������������������������������" + (IF iPartNum EQ 3 THEN "���������������Ĵ" ELSE "�") SKIP.
      &ELSE
         &IF DEFINED(InstrNNNN-U) GT 0 &THEN
            "�����������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP.
         &ELSE
            "����������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP.
         &ENDIF
      &ENDIF
   ELSE
      mFirstTime = NO.

   vInstrName[1] = iBuff:BUFFER-FIELD("InstrName"):BUFFER-VALUE.
IF GetSysConf("ModeExport") NE "Exp�����" THEN DO:
   {wordwrap.i &s=vInstrName &l=44 &n=2 &tail=vInstrName[3]}
   vInstrName[2] = vInstrName[3].   /* <- ��� �⮣� �� ࠡ�⠥� �ਭ㤨⥫�� ��ॢ�� ��ப� */

   PUT {&stream} UNFORMATTED
      "� "
      iBuff:BUFFER-FIELD("StrNum"):BUFFER-VALUE FORMAT "x(3)" &IF DEFINED(InstrNNNN-U) GT 0 &THEN "  �" &ELSE " �" &ENDIF
      vInstrName[1] FORMAT "x(44)" "�" .
   &IF DEFINED(D01-01-12) GT 0 &THEN
   IF iPartNum EQ 3 THEN
      PUT {&stream} UNFORMATTED
         DEC(iBuff:BUFFER-FIELD("SumSsa") :BUFFER-VALUE) FORMAT "->>>>>>>,>>9.99" "�"
         DEC(iBuff:BUFFER-FIELD("SumSsp") :BUFFER-VALUE) FORMAT "->>>>>>>,>>9.99" "�".
   &ENDIF
   PUT {&stream} UNFORMATTED
      DEC(iBuff:BUFFER-FIELD("SumOb")  :BUFFER-VALUE) FORMAT "->>>>>>>,>>9.99" "�"
      DEC(iBuff:BUFFER-FIELD("SumTreb"):BUFFER-VALUE) FORMAT "->>>>>>>,>>9.99" "�"
      DEC(iBuff:BUFFER-FIELD("SumPPer"):BUFFER-VALUE) FORMAT "->>>>>>>,>>9.99" "�"
      DEC(iBuff:BUFFER-FIELD("SumOPer"):BUFFER-VALUE) FORMAT "->>>>>>>,>>9.99" "�" .
   &IF DEFINED(D01-01-12) GT 0 &THEN
      IF iPartNum EQ 2 THEN
         PUT {&stream} UNFORMATTED
            DEC(iBuff:BUFFER-FIELD("SumReserv"):BUFFER-VALUE) FORMAT "->>>>>>>,>>9.99" "�".
         PUT {&stream} UNFORMATTED
            SKIP.
   &ELSE
      &IF DEFINED(Instr2055-U) EQ 0 &THEN
      IF iBuff:BUFFER-FIELD("StrNum"):BUFFER-VALUE BEGINS "2" THEN
         PUT {&stream} UNFORMATTED "       X       �" SKIP.
      ELSE
      &ENDIF
       PUT {&stream} UNFORMATTED
         DEC(iBuff:BUFFER-FIELD("SumReserv"):BUFFER-VALUE) FORMAT "->>>>>>>,>>9.99" "�" SKIP.
   &ENDIF
END.
ELSE  /* -------------------------------------------- Exp����� -------------- */
DO:
   PUT {&stream} UNFORMATTED
      "� " REPLACE(vInstrName[1], "|", "")  "�".
   &IF DEFINED(D01-01-12) GT 0 &THEN
      IF iPartNum EQ 3 THEN
         PUT {&stream} UNFORMATTED
            DEC(iBuff:BUFFER-FIELD("SumSsa") :BUFFER-VALUE) FORMAT "->>>>>>>>>9.99" "�"
            DEC(iBuff:BUFFER-FIELD("SumSsp") :BUFFER-VALUE) FORMAT "->>>>>>>>>9.99" "�".
   &ENDIF

   PUT {&stream} UNFORMATTED
      DEC(iBuff:BUFFER-FIELD("SumOb")  :BUFFER-VALUE) FORMAT "->>>>>>>>>9.99" "�"
      DEC(iBuff:BUFFER-FIELD("SumTreb"):BUFFER-VALUE) FORMAT "->>>>>>>>>9.99" "�"
      DEC(iBuff:BUFFER-FIELD("SumPPer"):BUFFER-VALUE) FORMAT "->>>>>>>>>9.99" "�"
      DEC(iBuff:BUFFER-FIELD("SumOPer"):BUFFER-VALUE) FORMAT "->>>>>>>>>9.99" "�" .
&IF DEFINED(D01-01-12) GT 0 &THEN
   IF iPartNum EQ 2 THEN
      PUT {&stream} UNFORMATTED
         DEC(iBuff:BUFFER-FIELD("SumReserv"):BUFFER-VALUE) FORMAT "->>>>>>>>>9.99" "�".
&ELSEIF DEFINED(Instr2055-U) EQ 0 &THEN
   IF iBuff:BUFFER-FIELD("StrNum"):BUFFER-VALUE BEGINS "2" THEN
      PUT {&stream} UNFORMATTED "       X       �".
   ELSE
&ENDIF

   PUT {&stream} UNFORMATTED
      iBuff:BUFFER-FIELD("StrNum"):BUFFER-VALUE FORMAT "x(3)" " �" SKIP.
END.

IF GetSysConf("ModeExport") NE "Exp�����" THEN
   DO WHILE vInstrName[2] GT "":
      vInstrName[1] = vInstrName[2].
      {wordwrap.i &s=vInstrName &l=44 &n=2 &tail=vInstrName[3]}
      vInstrName[2] = vInstrName[3].   /* <- ��� �⮣� �� ࠡ�⠥� �ਭ㤨⥫�� ��ॢ�� ��ப� */
      PUT {&stream} UNFORMATTED
      &IF DEFINED(D01-01-12) GT 0 &THEN
         "�      �" vInstrName[1] FORMAT "x(44)" "�               �               �               �               �               �" + (IF iPartNum EQ 3 THEN "               �" ELSE "") SKIP.
      &ELSE
         &IF DEFINED(InstrNNNN-U) GT 0 &THEN
         "�      �" vInstrName[1] FORMAT "x(44)" "�               �               �               �               �               �" SKIP.
         &ELSE
         "�     �" vInstrName[1] FORMAT "x(44)" "�               �               �               �               �               �" SKIP.
         &ENDIF
      &ENDIF
   END.

END PROCEDURE.  /* recordData */
/**************************************************************************************/
/* ����� ������.                                                                      */
/**************************************************************************************/
PROCEDURE endData.
END PROCEDURE. /*   */
/**************************************************************************************/
/* ����� �����.                                                                       */
/**************************************************************************************/
PROCEDURE endBlock.
   &IF DEFINED(D01-01-12) GT 0 &THEN
      DEFINE INPUT  PARAMETER iPartNum AS INT64     NO-UNDO.
   &ENDIF

   PUT {&stream} UNFORMATTED
   &IF DEFINED(D01-01-12) GT 0 &THEN
      "������������������������������������������������������������������������������������������������������������������������������������" + (IF iPartNum EQ 3 THEN "�����������������" ELSE "�")SKIP.
   &ELSE
      &IF DEFINED(InstrNNNN-U) GT 0 &THEN
      "�������������������������������������������������������������������������������������������������������������������������������������" SKIP.
      &ELSE
      "������������������������������������������������������������������������������������������������������������������������������������" SKIP.
      &ENDIF
   &ENDIF

   mFirstTime = YES.

END PROCEDURE. /*   */
/**************************************************************************************/
/* ������ ��ࠢ�筮                                                                   */
/**************************************************************************************/
PROCEDURE beginSprav.

   PUT {&stream} UNFORMATTED SKIP(1)
      '                                              ������ "��ࠢ�筮:"' SKIP(1)
   &IF DEFINED(D01-07-12) GT 0 &THEN
      " 1. ������⥫쭠� ��८業�� �� 奤�����騬 ᤥ����, �ਭ��� � 㬥��襭�� १�ࢮ� �� �������� ���� �� ���� ᤥ����," SKIP
      "    ��ࠦ���� � ࠧ���� 2 ����, � ᮮ⢥��⢨� � �ॡ�����ﬨ ����� 5 ��������� ����� ���ᨨ � 283-�:" .
   &ELSE
      &IF DEFINED(Instr2055-U) GT 0 &THEN
      " ������⥫쭠� ��८業�� �� 奤�����騬 ᤥ����, �ਭ��� � 㬥��襭�� १�ࢮ� �� �������� ���� � ᮮ⢥��⢨� " SKIP
      " � �ॡ�����ﬨ ����� 5 ��������� ����� ���ᨨ � 283-�:" SKIP.
      &ELSE
      " ��������� १�� �� �������� ���� ������⥫쭠� ��८業�� �� 奤�����騬 ᤥ����, �����⢫ﭥ��� � ᮮ⢥��⢨� " SKIP
      " � ������ 5 ��������� ����� ���ᨨ � 283-�:" SKIP.
      &ENDIF
   &ENDIF
END PROCEDURE. /*   */

PROCEDURE beginSprav2.

IF GetSysConf("ModeExport") NE "Exp�����" THEN
   PUT {&stream} UNFORMATTED SKIP(1)
      " 2. ���ଠ�� � 業��� �㬠���, �ਭ���� � ���ᯥ祭�� �� ࠧ��饭�� �।�⢠� � ����祭��� �� ������, ᮢ��蠥�� �� �����⭮� �᭮��,                     " SKIP
      "                                                 �ࠢ� �� ����� 㤮�⮢������� �࣠�����ﬨ (��������ﬨ)                                                    " SKIP
      "�������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ŀ" SKIP
      "������ �       ������������ �࣠����樨         �      ���      �        ����p ��業���        �    ������⢮      ��⮨����� 業��� ������� (�ࠢ�������) �  ��ନ஢���� �" SKIP
      "���ப��             (���������)              �  �࣠����樨  �         �࣠����樨          �    業��� �㬠�,   ��㬠�, �ਭ����  ��⮨����� 業��� �㬠�,�     १��      �" SKIP
      "�      �                                        � (���������) �        (���������)         �                    �� ���ᯥ祭�� �� �����祭��� �� ����-   �  �� ��������   �" SKIP
      "�      �                                        �               �                              �                    �ࠧ��饭��      ���, ᮢ��襭�� ��   �     ����      �" SKIP
      "�      �                                        �               �                              �                    �    �।�⢠�    ������⭮� �᭮��      �                 �" SKIP
      "�      �                                        �               �                              �        ��.         �     ���.��.    �        ���.��.       �     ���.��.    �" SKIP
      "�������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
      "�  1   �                    2                   �       3       �              4               �         5          �        6        �           7           �        8        �" SKIP
      "�������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP.
ELSE
   PUT {&stream} UNFORMATTED SKIP(1) " 2. ���ଠ�� � 業��� �㬠���" SKIP.

END PROCEDURE. /*   */

PROCEDURE Sprav3-5.
   DEFINE INPUT  PARAMETER iSumm3   AS DECIMAL     NO-UNDO.
   DEFINE INPUT  PARAMETER iSumm4   AS DECIMAL     NO-UNDO.
   DEFINE INPUT  PARAMETER iSumm5   AS DECIMAL     NO-UNDO.

   IF GetSysConf("ModeExport") NE "Exp�����" THEN
   DO:
      PUT {&stream} UNFORMATTED SKIP(1)
        "3. ���� �㬬� �᫮���� ��易⥫��� �।�⭮�� �ࠪ��, ������     " SKIP
        "   ��㯯�஢���� � ����த�� ����䥫�, ����� ����� ���� ����᫮���" SKIP 
        "   ���㫨஢��� � �� ������ �६��� ��� �।���⥫쭮�� 㢥��������" SKIP
        "   ����ࠣ���, �� �����ᮢ�� �⮨����, " iSumm3 " ���. ��. ".
      
      PUT {&stream} UNFORMATTED SKIP(1)
        "4. ����稭� 䠪��᪨ ��ନ஢������ १�ࢠ �� �������� ���� ��   " SKIP
        "   ��饩 �㬬� �᫮���� ��易⥫��� �।�⭮�� �ࠪ��, ������      " SKIP
        "   ��㯯�஢���� � ����த�� ����䥫�, ����� ����� ���� ����᫮��� " SKIP
        "   ���㫨஢��� � �� ������ �६��� ��� �।���⥫쭮�� 㢥�������� " SKIP
        "   ����ࠣ���, �� �����ᮢ�� �⮨����, " iSumm4 " ���. ��. ".
      
      PUT {&stream} UNFORMATTED SKIP(1)
        "5. ����稭�, �����থ���� �।�⭮�� ��� �� ���� ᤥ���� �       " SKIP
        "   �ந������ 䨭��ᮢ� �����㬥�⠬, �����祭�� �� ��থ��� �     " SKIP
        "   �����থ��� �뭪��, ����⠭��� �� �᭮����� ��⮤���,            " SKIP
        "   �।�ᬮ�७��� �ਫ������� 3 � ������樨 ����� ���ᨨ � 139-�, ��" SKIP
        "   �᪫�祭��� ��������� �㭪� 1, ����㭪� 8.1 �㭪� 8, �㭪⮢    " SKIP
        "   9 - 12 㪠������� �ਫ������, "  iSumm5 " ���. ��. ".
   END.
   ELSE
   DO:
      PUT {&stream} UNFORMATTED SKIP(1) "<NF1554_SP345>".
      PUT {&stream} UNFORMATTED SKIP(1) "� 3 �" iSumm3 "� ".
      PUT {&stream} UNFORMATTED SKIP(1) "� 4 �" iSumm4 "� ".
      PUT {&stream} UNFORMATTED SKIP(1) "� 5 �" iSumm5 "� ".
      PUT {&stream} UNFORMATTED SKIP(1) "".
   END.
END PROCEDURE. /* Sprav3-5 */
/**************************************************************************************/
/* ����� ࠧ���� ��ࠢ�筮                                                           */
/**************************************************************************************/
PROCEDURE recordSprav.
   DEFINE INPUT  PARAMETER iPartNum AS INT64     NO-UNDO.
   DEFINE INPUT  PARAMETER iSumm    AS DECIMAL     NO-UNDO.

IF GetSysConf("ModeExport") NE "Exp�����" THEN
DO:
   IF iPartNum EQ 2 THEN
      PUT {&stream} UNFORMATTED
      &IF DEFINED(D01-07-12) EQ 0 &THEN
         &IF DEFINED(D01-01-12) GT 0 &THEN
         "     1. �� ���� ᤥ����, ��ࠦ���� � ࠧ���� 2:                                       "
         &ELSE
         "     1. �� ���� ᤥ����, �।�ᬠ�ਢ��騬 ���⠢�� ����᭮�� ��⨢�, ��ࠦ���� � ࠧ���� 2: "
         &ENDIF
      &ENDIF
         iSumm FORMAT "->>>>>>>,>>9.99"  " ���.��." SKIP.
   ELSE
      PUT {&stream} UNFORMATTED
      &IF DEFINED(D01-01-12) GT 0 &THEN
         "     2. �� �ந������ 䨭��ᮢ� �����㬥�⠬, ��ࠦ���� � ࠧ���� 3:                   "
      &ELSE
         "     2. �� ���� ����� (��ᯮ�⠢���) ᤥ����, ��ࠦ���� � ࠧ���� 3:                   "
      &ENDIF
         iSumm FORMAT "->>>>>>>,>>9.99" " ���.��." SKIP.
END.
ELSE
DO:                                            /* Exp����� */
   IF iPartNum EQ 2 THEN
      &IF DEFINED(D01-01-12) GT 0 &THEN
         PUT {&stream} UNFORMATTED "�" iSumm FORMAT "->>>>>>>>>9" "�" .
      &ELSE
         PUT {&stream} UNFORMATTED "�" iSumm FORMAT "->>>>>>>>>9" .
      &ENDIF

   ELSE
      PUT {&stream} UNFORMATTED "�" iSumm FORMAT "->>>>>>>>>9" "�" SKIP.
END.

END PROCEDURE.

PROCEDURE recordSprav2.
   DEFINE INPUT  PARAMETER iCol1    AS CHARACTER   NO-UNDO.
   DEFINE INPUT  PARAMETER iCol2    AS CHARACTER   NO-UNDO.
   DEFINE INPUT  PARAMETER iCol3    AS CHARACTER   NO-UNDO.
   DEFINE INPUT  PARAMETER iCol4    AS CHARACTER   NO-UNDO.
   DEFINE INPUT  PARAMETER iCol5    AS DECIMAL     NO-UNDO.
   DEFINE INPUT  PARAMETER iCol6    AS DECIMAL     NO-UNDO.
   DEFINE INPUT  PARAMETER iCol7    AS DECIMAL     NO-UNDO.
   DEFINE INPUT  PARAMETER iCol8    AS DECIMAL     NO-UNDO.

   DEFINE VARIABLE vI AS INTEGER NO-UNDO.
   DEFINE VARIABLE vOrgName AS CHARACTER NO-UNDO EXTENT 10.

   vOrgName[1] = iCol2.

IF GetSysConf("ModeExport") NE "Exp�����" THEN
DO:

   {wordwrap.i &s=vOrgName &l=40 &n=EXTENT(vOrgName)}

   PUT {&stream} UNFORMATTED
      "�" iCol1       FORMAT "x(6)"
      "�" vOrgName[1] FORMAT "x(40)"
      "�" iCol3       FORMAT "x(15)"
      "�" iCol4       FORMAT "x(30)"
      "�" iCol5       FORMAT ">>>>>>>>>>>>>>9.9999"
      "�" iCol6       FORMAT ">>>>>>>>>>>>>9.99"
      "�" iCol7       FORMAT "      >>>>>>>>>>>>>9.99"
      "�" iCol8       FORMAT ">>>>>>>>>>>>>9.99"
      "�" SKIP.

   DO vI = 2 TO EXTENT(vOrgName):
      IF vOrgName[vI] = "" THEN LEAVE.
      PUT {&stream} UNFORMATTED
         "�" SPACE(6)
         "�" vOrgName[vI] FORMAT "x(40)"
         "�" SPACE(15)
         "�" SPACE(30)
         "�" SPACE(20)
         "�" SPACE(17)
         "�" SPACE(23)
         "�" SPACE(17)
         "�" SKIP.
   END.
END.
ELSE  /* -------------------------------------------- Exp����� -------------- */
DO:
   PUT {&stream} UNFORMATTED
      "�" iCol1       FORMAT "x(6)"
      "�" vOrgName[1] /* FORMAT "x(40)" */
      "�" iCol3       FORMAT "x(15)"
      "�" iCol4       FORMAT "x(30)"
      "�" iCol5       FORMAT ">>>>>>>>>>>>>>9.9999"
      "�" iCol6       FORMAT ">>>>>>>>>>>>>9.99"
      "�" iCol7       FORMAT "      >>>>>>>>>>>>>9.99"
      "�" iCol8       FORMAT ">>>>>>>>>>>>>9.99"
      "�" SKIP.

END.

END PROCEDURE.

PROCEDURE recordSepSprav2.
   PUT {&stream} UNFORMATTED
      "�������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ"
   SKIP.
END PROCEDURE.

PROCEDURE endSprav2.
   PUT {&stream} UNFORMATTED
      "���������������������������������������������������������������������������������������������������������������������������������������������������������������������������������" SKIP.
END PROCEDURE. /*   */
/**************************************************************************************/
/* ����� ����                                                                       */
/**************************************************************************************/
PROCEDURE endReport.
IF GetSysConf("ModeExport") NE "Exp�����" AND
   GetSysConf("ModeExport") NE "Exp���"
THEN DO:
   {signatur.i}
   {preview.i}
END.
END PROCEDURE.
/******************************************************************************/
