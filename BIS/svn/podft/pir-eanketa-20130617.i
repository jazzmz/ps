/* ���������� ��६����� cAnketa

DEFINE VARIABLE cAnketa  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iKl      AS INTEGER    NO-UNDO.

iKl EQ 1   - ��
       2   - ��
       3   - ��
       4   -  �
       5   - �� ��
       6   - �� ��
       7   - �� ��
       9   - �� 
       10  - �� �2   
       11  - �� �
*/

CASE iKl:
   WHEN 1 THEN
      cAnketa = "~
                      ������ ������� - ����������� ����|~
 |~
 |~
1.1.  �������, ���, ����⢮: #5#|~
1.2.  ��� ஦�����: #41#|~
1.3.  ���� ஦�����: #42#|~
1.4.  �ࠦ����⢮: #44#|~
1.5.  ���㬥��, 㤮�⮢����騩 ��筮���: #46#|~
1.6.  ���㬥��, ���⢥ত��騩 �ࠢ� �� �ॡ뢠��� (�஦������) � ���ᨩ᪮� �����樨 �����࠭���� �ࠦ������ ��� ��� ��� �ࠦ����⢠: #47#|~
1.7.  ���� ���� ��⥫��⢠ (ॣ����樨): #18#|~
1.8.  ���� ���� �ॡ뢠��� (�஦������): #19#|~
1.9.  ���: #27#|~
1.10. �⭮襭�� � �ᮡ� ��������� ��栬:|~
   �����Ŀ 1. ������� �����࠭��    �����Ŀ 2. ����� �⭮襭�� �|~
   � #48# � �㡫��� ���������      � #49# � �����࠭���� �㡫�筮��|~
   ������� ��殬                      ������� �������⭮�� ����|~
 |~
   �����Ŀ 3. ������� ���������    �����Ŀ 4. ������� ��ᨩ᪨� �㡫���|~
   � #77# � ��殬 �㡫�筮�            � #78# � ��������� ��殬           |~
   ������� ����㭠த���  �࣠����樨 �������|~
 |~
|~
#90#|~

|~

1.11. ����� ���⠪��� ⥫�䮭��: #24#|~
                 䠪� (��. ����): #22#|~
1.12. �஢��� �᪠: #37#|~
1.13. ���᭮����� �業�� �஢�� �᪠: #38#|~
1.14. ��� ������ ��ࢮ�� ������᪮�� ��� (������): #60#|~
1.15. ��� ���������� ������ ������: #61#|~
1.16. ��� ���������� ������ ������: #62#|~
1.17. ����⭨� �����, ����訩 ���#63#|~
1.18. ����⭨� �����, �⢥न�訩 ����⨥ ���#64#|~
1.19. ����⭨� �����, ��������訩 ������ ������ � �����஭��� ����#65#|~
1.20. ������� 㯮�����祭���� ࠡ�⭨�� �����, ��७��襣� ������ ������, ����������� � �����஭��� ����, �� �㬠��� ���⥫�#66#|~
 |".
   WHEN 2 THEN
           cAnketa = "~
                   ������ ������� - ��������������� ���������������|~
      |~
      |~
     2.1.  �������, ���, ����⢮: #2#|~
     2.2.  ��� ஦�����: #40#|~
     2.3.  ���� ஦�����: #42#|~
     2.4.  �ࠦ����⢮: #43#|~
     2.5.  ���㬥��, 㤮�⮢����騩 ��筮���: #45#|~
     2.6.  ���㬥��, ���⢥ত��騩 �ࠢ� �� �ॡ뢠��� (�஦������) � ���ᨩ᪮� �����樨 �����࠭���� �ࠦ������ ��� ��� ��� �ࠦ����⢠: #47#|~
     2.7.  ���� ���� ��⥫��⢠ (ॣ����樨): #17#|~
     2.8.  ���� ���� �ॡ뢠��� (�஦������): #19#|~
     2.9.  ���⮢� ����: #20#|~
     2.10. ���: #26#|~
     2.11. ����� ���⠪��� ⥫�䮭��: #21#|~
                      䠪� (��. ����): #22#|~
     2.12. ���㤠��⢥��� ॣ����樮��� �����: #14#|~
     2.13. ��� ॣ����樨: #15#|~
     2.14. ���� ॣ����樨 (��த, �������): #16#|~
     2.15. �������� � ��業��� �� �ࠢ� �����⢫���� ���⥫쭮��, �������饩 ��業��஢����: #30#|~
     2.16. ������������ �।���� �࣠����権, � ������ ������ ���㦨������ (࠭�� ���㦨�����): #35#|~
     2.17. �������� � ������� ९��樨 ������: #36#|~
     2.18. �஢��� �᪠: #37#|~
     2.19. ���᭮����� �業�� �஢�� �᪠: #38#|~
     2.20. ��� ������ ��ࢮ�� ������᪮�� ��� (������): #60#|~
     2.21. ��� ���������� ������ ������: #61#|~
     2.22. ��� ���������� ������ ������: #62#|~
     2.23. ����⭨� �����, ����訩 ���#63#|~
     2.24. ����⭨� �����, �⢥न�訩 ����⨥ ���#64#|~
     2.25. ����⭨� �����, ��������訩 ������ ������ � �����஭��� ����#65#|~
     2.26. ������� 㯮�����祭���� ࠡ�⭨�� �����, ��७��襣� ������ ������, ����������� � �����஭��� ����, �� �㬠��� ���⥫�#66#|~
    |".
   WHEN 3 THEN
      cAnketa = "~
                     ������ ������� - ������������ ����|~
                   (�� ��饣��� �।�⭮� �࣠����樥�)|~
 |~
 |~
3.1.  ������ ������������: #1#|~
3.2.  ��⪮� ������������: #9#|~
3.3.  ������������ �� �����࠭��� �몥: #11#|~
3.4.  �࣠����樮��� �ࠢ���� �ଠ: #12#|~
3.5.  ���㤠��⢥��� ॣ����樮��� �����: #14#|~
3.6.  ��� ॣ����樨: #15#|~
3.7.  ���� ॣ����樨 (��த, �������), ������������ ॣ�������饣� �࣠��: #16#|~
3.8.  ���� ���� ��宦����� (���㤠��⢥���� ॣ����樨): #17#|~
3.9.  ���⮢� ���� (䠪��᪮�� ���⮭�宦�����): #19#|~
3.10. ����� ���⠪��� ⥫�䮭��: #21#|~
                 䠪� (��. ����): #22#|~
3.11. ��� - ��� १�����: #26#|~
3.12. ��� ��� ��� �����࠭��� �࣠����樨 - ��� ��१�����: #29#|~
3.13. �������� � ��業��� �� �ࠢ� �����⢫���� ���⥫쭮��, �������饩 ��業��஢����: #30#|~
3.14. �������� �� �࣠��� �ਤ��᪮�� ��� (������� � ���ᮭ���� ��⠢ �࣠��� �ࠢ����� �ਤ��᪮�� ���): #31#|~
3.15. �������� � ����稭� ��ॣ����஢������ � ����祭���� ��⠢���� (᪫���筮��) ����⠫� ��� ����稭� ��⠢���� 䮭��, �����⢠:|~
            - ����稭� ��ॣ����஢������ �� (��):#33#|~
            - ����稭� ����祭���� �� (��)        :#33.1#|~

3.16. �������� � ������⢨� ��� ������⢨� �� ᢮��� ����� ��宦����� �ਤ��᪮�� ���, ��� ����ﭭ� �������饣� �࣠�� �ࠢ�����, ����� �࣠�� ��� ���, ����� ����� �ࠢ� ����⢮���� �� ����� �ਤ��᪮�� ��� ��� ����७����: #34#|~
3.17. ������������ �।���� �࣠����権, � ������ ������ ���㦨������ (࠭�� ���㦨�����): #35#|~
3.18. �������� � ������� ९��樨 ������: #36#|~
3.19. �஢��� �᪠: #37#|~
3.20. ���᭮����� �業�� �஢�� �᪠: #38#|~
3.21. ��� ������ ��ࢮ�� ������᪮�� ��� (������): #60#|~
3.22. ��� ���������� ������ ������: #61#|~
3.23. ��� ���������� ������ ������: #62#|~
3.24. ����⭨� �����, ����訩 ���#63#|~
3.25. ����⭨� �����, �⢥न�訩 ����⨥ ���#64#|~
3.26. ����⭨� �����, ��������訩 ������ ������ � �����஭��� ����#65#|~
3.27. ������� 㯮�����祭���� ࠡ�⭨�� �����, ��७��襣� ������ ������, ����������� � �����஭��� ����, �� �㬠��� ���⥫�#66#|~
 |".
   WHEN 4 THEN
      cAnketa = "~
                   ������ ������� - ��������� �����������|~
 |~
 |~
4.1.  ������ ������������: #8#|~
4.2.  ��⪮� ������������: #10#|~
4.3.  ������������ �� �����࠭��� �몥: #11#|~
4.4.  �࣠����樮��� �ࠢ���� �ଠ: #13#|~
4.5.  ���㤠��⢥��� ॣ����樮��� �����: #14#|~
4.6.  ��� ॣ����樨: #15#|~
4.7.  ���� ॣ����樨 (��த, �������), ������������ ॣ�������饣� �࣠��: #16#|~
4.8.  ���� ���� ��宦����� (���㤠��⢥���� ॣ����樨): #17#|~
4.9.  ���⮢� ���� (䠪��᪮�� ���⮭�宦�����): #19#|~
4.10. ����� ���⠪��� ⥫�䮭��: #21#|~
                 䠪� (��. ����): #22#|~
4.11. ��� - ��� १�����: #28#|~
4.12. ��� ��� ��� �����࠭��� �࣠����樨 - ��� ��१�����: #29#|~
4.13. �������� � ��業��� �� �ࠢ� �����⢫���� ���⥫쭮��, �������饩 ��業��஢����: #30#|~
4.14. ������᪨� �����䨪�樮��� ���: (��� १����⮢) #51#|~
4.15. �������� �� �࣠��� �ਤ��᪮�� ��� (������� � ���ᮭ���� ��⠢ �࣠��� �ࠢ����� �ਤ��᪮�� ���): #32#|~
4.16. �������� � ����稭� ��ॣ����஢������ � ����祭���� ��⠢���� (᪫���筮��) ����⠫� ��� ����稭� ��⠢���� 䮭��, �����⢠:|~
            - ����稭� ��ॣ����஢������ �� (��):#33#|~
            - ����稭� ����祭���� �� (��)        :#33.1#|~
4.17. �������� � ������⢨� ��� ������⢨� �� ᢮��� ����� ��宦����� �ਤ��᪮�� ���, ��� ����ﭭ� �������饣� �࣠�� �ࠢ�����, ����� �࣠�� ��� ���, ����� ����� �ࠢ� ����⢮���� �� ����� �ਤ��᪮�� ��� ��� ����७����: #34#|~
4.18. �஢��� �᪠: #37#|~
4.19. ���᭮����� �業�� �஢�� �᪠: #38#|~
4.20. ��� ������ ��ࢮ�� ������᪮�� ��� (������): #60#|~
4.21. ��� ���������� ������ ������: #61#|~
4.22. ��� ���������� ������ ������: #62#|~
4.23. ����⭨� �����, ����訩 ���#63#|~
4.24. ����⭨� �����, �⢥न�訩 ����⨥ ���#64#|~
4.25. ����⭨� �����, ��������訩 ������ ������ � �����஭��� ����#65#|~
4.26. ������� 㯮�����祭���� ࠡ�⭨�� �����, ��७��襣� ������ ������, ����������� � �����஭��� ����, �� �㬠��� ���⥫�#66#|~
 |".
   WHEN 5 THEN
      cAnketa = "~
                ������ ������������������� - ����������� ����|~
 |~
 |~
5.1.  �������� �� �᭮������, ᢨ��⥫������� � ⮬, �� ������ #79# ������� � �룮�� ������� ��� �� �஢������ ������᪨� ����権 � ���� ᤥ��� � ᮮ⢥��⢨� �: #74#|~
�������� � �룮���ਮ���⥫�:|~
5.2.  �������, ���, ����⢮: #5#|~
5.3.  ��� ஦�����: #41#|~
5.4.  ���� ஦�����: #42#|~
5.5.  �ࠦ����⢮: #44#|~
5.6.  ���㬥��, 㤮�⮢����騩 ��筮���: #46#|~
5.7.  ���㬥��, ���⢥ত��騩 �ࠢ� �� �ॡ뢠��� (�஦������) � ���ᨩ᪮� �����樨 �����࠭���� �ࠦ������ ��� ��� ��� �ࠦ����⢠: #47#|~
5.8.  ���� ���� ��⥫��⢠ (ॣ����樨): #18#|~
5.9.  ���� ���� �ॡ뢠��� (�஦������): #19#|~
5.10. ���: #27#|~
5.11. ����� ���⠪��� ⥫�䮭��: #24#|~
                 䠪� (��. ����): #22#|~
5.12. ��� ��ࢨ筮�� ���������� ᢥ�����: #61#|~
5.13. ��� ���������� ᢥ�����: #62#|~
5.14. ����⭨� �����, ��������訩 ������ �룮���ਮ���⥫� � �����஭��� ����#65#|~
5.15. ������� 㯮�����祭���� ࠡ�⭨�� �����, ��७��襣� ������ �룮���ਮ���⥫�, ����������� � �����஭��� ����, �� �㬠��� ���⥫�#66#|~
 |".
   WHEN 6 THEN
      cAnketa = "~
        ������ ������������������� - ��������������� ���������������|~
 |~
 |~
6.1.  �������� �� �᭮������, ᢨ��⥫������� � ⮬, �� ������ #79# ������� � �룮�� ������� ��� �� �஢������ ������᪨� ����権 � ���� ᤥ��� � ᮮ⢥��⢨� �: #74#|~
�������� � �룮���ਮ���⥫�: |~
6.2.  �������, ���, ����⢮: #2#|~
6.3.  ��� ஦�����: #40#|~
6.4.  ���� ஦�����: #42#|~
6.5.  �ࠦ����⢮: #43#|~
6.6.  ���㬥��, 㤮�⮢����騩 ��筮���: #45#|~
6.7.  ���㬥��, ���⢥ত��騩 �ࠢ� �� �ॡ뢠��� (�஦������) � ���ᨩ᪮� �����樨 �����࠭���� �ࠦ������ ��� ��� ��� �ࠦ����⢠: #47#|~
6.8.  ���� ���� ��⥫��⢠ (ॣ����樨): #17#|~
6.9.  ���� ���� �ॡ뢠��� (�஦������): #19#|~
6.10. ���: #26#|~
6.11. ����� ���⠪��� ⥫�䮭��: #21#|~
                 䠪� (��. ����): #22#|~
6.12. �࣠����樮���-�ࠢ���� �ଠ: #12#|~
6.13. ���㤠��⢥��� ॣ����樮��� �����: #14#|~
6.14. ��� ॣ����樨: #15#|~
6.15. ���� ॣ����樨 (��த, �������): #16#|~
6.16. �������� � ��業��� �� �ࠢ� �����⢫���� ���⥫쭮��, �������饩 ��業��஢����: #30#|~
6.17. ���⮢� ����: #20#|~

6.18. ��� ��ࢨ筮�� ���������� ᢥ�����:#61#|~
6.19. ��� ���������� ᢥ�����:#62#|~

6.20. ����⭨� �����, ��������訩 ������ �룮���ਮ���⥫� � �����஭��� ����#65#|~
6.21. ������� 㯮�����祭���� ࠡ�⭨�� �����, ��७��襣� ������ �룮���ਮ���⥫�, ����������� � �����஭��� ����, �� �㬠��� ���⥫�#66#|~
 |".
   WHEN 7 THEN
      cAnketa = "~
                ������ ������������������� - ������������ ����|~
 |~

7.1.  �������� �� �᭮������, ᢨ��⥫������� � ⮬, �� ������ #79# ������� � �룮�� ������� ��� �� �஢������ ������᪨� ����権 � ���� ᤥ��� � ᮮ⢥��⢨� �: #74#|~
�������� � �룮���ਮ���⥫�:|~
7.2.  ������ ������������: #1#|~
7.3.  ��⪮� ������������: #9#|~
7.4.  ������������ �� �����࠭��� �몥: #11#|~
7.5.  �࣠����樮��� �ࠢ���� �ଠ: #12#|~
7.6.  ���㤠��⢥��� ॣ����樮��� �����: #14#|~
7.7.  ��� ॣ����樨: #15#|~
7.8.  ���� ॣ����樨 (��த, �������), ������������ ॣ�������饣� �࣠��:#16#|~
7.9.  ���� ���� ��宦����� (���㤠��⢥���� ॣ����樨): #17#|~
7.10. ���⮢� ���� (䠪��᪮�� ���⮭�宦�����): #19#|~
7.11. ����� ���⠪��� ⥫�䮭��: #21#|~
                 䠪� (��. ����): #22#|~
7.12. ��� - ��� १�����: #26#|~
7.13. ��� ��� ��� �����࠭��� �࣠����樨 - ��� ��१�����: #29#|~
7.14. �������� � ��業��� �� �ࠢ� �����⢫���� ���⥫쭮��, �������饩 ��業��஢����: #30#|~
7.15. �������� �� �࣠��� �ਤ��᪮�� ��� (������� � ���ᮭ���� ��⠢ �࣠��� �ࠢ����� �ਤ��᪮�� ���): #31#|~
7.16. �������� � ����稭� ��ॣ����஢������ � ����祭���� ��⠢���� (᪫���筮��) ����⠫� ��� ����稭� ��⠢���� 䮭��, �����⢠:|~
            - ����稭� ��ॣ����஢������ �� (��):#33#|~
            - ����稭� ����祭���� �� (��)        :#33.1#|~
7.17. �������� � ������⢨� ��� ������⢨� �� ᢮��� ����� ��宦����� �ਤ��᪮�� ���, ��� ����ﭭ� �������饣� �࣠�� �ࠢ�����, ����� �࣠�� ��� ���, ����� ���� �ࠢ� ����⢮���� �� ����� �ਤ��᪮�� ��� ��� ����७����: #34#|~
7.18. ��� ��ࢨ筮�� ���������� ᢥ�����: #61#|~
7.19. ��� ���������� ᢥ�����: #62#|~
7.20. ����⭨� �����, ��������訩 ������ �룮���ਮ���⥫� � �����஭��� ���� #65#|~
7.21. ������� 㯮�����祭���� ࠡ�⭨�� �����, ��७��襣� ������ �룮���ਮ���⥫�, ����������� � �����஭��� ����, �� �㬠��� ���⥫�#66#|~
 |".
   WHEN 8 THEN
      cAnketa = "~
                ������ ������������� ������� (���������� ����)|~
 |~
 |~
8.1. ������������ ������: #70#;|~
     ��� ���: #71# � ����� ���: #72#;|~
8.2. ��⥣��� �।�⠢�⥫�: #73#;|~
8.3. �᭮����� �।�⠢�⥫��⢠: #74#|~
8.4. �ப �।�⠢�⥫��⢠: ��砫� #75# - ����砭�� #76#;|~
 |~
�������� � �।�⠢�⥫�:|~
 |~
8.5.  �������, ���, ����⢮: #5#|~
8.6.  ��� ஦�����: #41#|~
8.7.  ���� ஦�����: #42#|~
8.8.  �ࠦ����⢮: #44#|~
8.9.  ���㬥��, 㤮�⮢����騩 ��筮���: #46#|~
8.10. ���㬥��, ���⢥ত��騩 �ࠢ� �� �ॡ뢠��� (�஦������) � ���ᨩ᪮� �����樨 �����࠭���� �ࠦ������ ��� ��� ��� �ࠦ����⢠: #47#|~
8.11. ���� ���� ��⥫��⢠ (ॣ����樨): #18#|~
8.12. ���� ���� �ॡ뢠��� (�஦������): #19#|~
8.13. ���: #27#|~
8.14. ����� ���⠪��� ⥫�䮭��: #24#|~
                 䠪� (��. ����): #22#|~
8.15. ����⭨� �����, ��������訩 ������ �।�⠢�⥫� ������ � �����஭��� ���� #65#|~
8.16. ��� ���������� ������: #61#|~
8.17. ��� ���������� ������: #62#|~
8.18. ������� 㯮�����祭���� ࠡ�⭨�� �����, ��७��襣� ������ �।�⠢�⥫� ������, ����������� � �����஭��� ����, �� �㬠��� ���⥫�#66#|~
 |".
   WHEN 9 THEN
      cAnketa = "~
                ������ ������������� ������� (����������� ����)|~
 |~
 |~
9.1.  ������������ ������: #70#;|~
      ��� ���: #71# � ����� ���: #72#;|~
9.2.  ��⥣��� �।�⠢�⥫�: #73#;|~
9.3.  �᭮����� �।�⠢�⥫��⢠: #74#|~
9.4.  �ப �।�⠢�⥫��⢠: ��砫� #75# - ����砭�� #76#;|~
 |~
�������� � �।�⠢�⥫�:|~
 |~
9.5.  ������ ������������: #1#|~
9.6.  ��⪮� ������������: #9#|~
9.7.  ������������ �� �����࠭��� �몥: #11#|~
9.8.  �࣠����樮��� �ࠢ���� �ଠ: #12#|~
9.9.  ���㤠��⢥��� ॣ����樮��� �����: #14#|~
9.10. ��� ॣ����樨: #15#|~
9.11. ���� ॣ����樨 (��த, �������), ������������ ॣ�������饣� �࣠��:#16#|~
9.12. ���� ���� ��宦����� (���㤠��⢥���� ॣ����樨): #17#|~
9.13. ���⮢� ���� (䠪��᪮�� ���⮭�宦�����): #19#|~
9.14. ����� ���⠪��� ⥫�䮭��: #21#|~
                 䠪� (��. ����): #22#|~
9.15. ��� - ��� १�����: #26#|~
9.16. ��� ��� ��� �����࠭��� �࣠����樨 - ��� ��१�����: #29#|~
9.17. �������� � ��業��� �� �ࠢ� �����⢫���� ���⥫쭮��, �������饩 ��業��஢����: #30#|~
9.18. �������� �� �࣠��� �ਤ��᪮�� ��� (������� � ���ᮭ���� ��⠢ �࣠��� �ࠢ����� �ਤ��᪮�� ���): #31#|~
9.19. �������� � ����稭� ��ॣ����஢������ � ����祭���� ��⠢���� (᪫���筮��) ����⠫� ��� ����稭� ��⠢���� 䮭��, �����⢠:|~
            - ����稭� ��ॣ����஢������ �� (��):#33#|~
            - ����稭� ����祭���� �� (��)        :#33.1#|~
9.20. ����⭨� �����, ��������訩 ������ �।�⠢�⥫� � �����஭��� ����#65#|~
9.21. ��� ���������� ������: #61#|~
9.22. ��� ���������� ������: #62#|~
9.23. ������� 㯮�����祭���� ࠡ�⭨�� �����, ��७��襣� ������ �����饣� �।�⠢�⥫�, ����������� � �����஭��� ����, �� �㬠��� ���⥫�#66#|~
 |".
   WHEN 10 THEN
      cAnketa = "~
                ������ ������������� ������� (�������������� ���������������)|~
 |~
 |~


10.1. ������������ ������: #70#;|~
     ��� ���: #71# � ����� ���: #72#;|~
10.2. ��⥣��� �।�⠢�⥫�: #73#;|~
10.3. �᭮����� �।�⠢�⥫��⢠: #74#|~
10.4. �ப �।�⠢�⥫��⢠: ��砫� #75# - ����砭�� #76#;|~
 |~
�������� � �।�⠢�⥫�:|~
 |~
10.5.  �������, ���, ����⢮: #2#|~
10.6.  ��� ஦�����: #40#|~
10.7.  ���� ஦�����: #42#|~
10.8.  �ࠦ����⢮: #43#|~
10.9.  ���㬥��, 㤮�⮢����騩 ��筮���: #45#|~
10.10. ���㬥��, ���⢥ত��騩 �ࠢ� �� �ॡ뢠��� (�஦������) � ���ᨩ᪮� �����樨 �����࠭���� �ࠦ������ ��� ��� ��� �ࠦ����⢠: #47#|~
10.11. ���� ���� ��⥫��⢠ (ॣ����樨): #17#|~
10.12. ���� ���� �ॡ뢠��� (�஦������): #19#|~
10.13. ���: #26#|~
10.14. ����� ���⠪��� ⥫�䮭��: #21#|~
                 䠪� (��. ����): #22#|~

10.15. �࣠����樮���-�ࠢ���� �ଠ: #12#|~
10.16. ���㤠��⢥��� ॣ����樮��� �����: #14#|~
10.17. ��� ॣ����樨: #15#|~
10.18. ���� ॣ����樨 (��த, �������), ������������ ॣ�������饣� �࣠��: #16#|~
10.19. �������� � ��業��� �� �ࠢ� �����⢫���� ���⥫쭮��, �������饩 ��業��஢����: #30#|~
10.20. ���⮢� ����: #20#|~
10.21. ����⭨� �����, ��������訩 ������ �।�⠢�⥫� � �����஭��� ���� #65#|~
10.22. ��� ���������� ������: #61#|~
10.23. ��� ���������� ������: #62#|~
10.24. ������� 㯮�����祭���� ࠡ�⭨�� �����, ��७��襣� ������ �����饣� �।�⠢�⥫�, ����������� � �����஭��� ����, �� �㬠��� ���⥫� #66#|~
 |".

   OTHERWISE
      cAnketa = "".
END CASE.

FUNCTION UserFIO RETURNS CHARACTER
   (INPUT cUsr AS CHARACTER).

   FIND FIRST _user
      WHERE (_user._userid = cUsr)
      NO-LOCK NO-ERROR.

   IF AVAIL _user
   THEN
      RETURN "|       �������, ���, ����⢮: " + _user._user-name
           + "|       ���������: " + GetXAttrValue("_user", _user._userid, "���������").
   ELSE
      RETURN "|       �������, ���, ����⢮: " + PrintStringInfo("")
           + "|       ���������: " + PrintStringInfo("").

END.
