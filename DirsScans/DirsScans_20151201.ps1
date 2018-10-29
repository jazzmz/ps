  #######################################################
###########################################################
####                                                   ####
#### Script for making scans directories               ####
####                                                   ####
#### Author: Dorkin Dmitry                             ####
####                                                   ####
#### Date: 2015-11-25                                  ####
####                                                   ####
###########################################################
  #######################################################

$tarDir="C:\test\DirsScans\disk_n"
Clear-Host

$user_r="Пользователи домена"
$admu5_1="u5-1"
$admu5_2="u5-2"
$admu10_2="u10-2"

function Main {

Write-Host "Вас приветствует программа создания директорий `nДля того, чтобы прервать программу нажмите Ctrl+C`n"
$choose=$true
do
{
    if (!$choose){
        $choose=$true
        Clear-Host
    }
    Write-Host "Выберите ваше подразделение, введя цифру, соответствующую вашему подразделению"
    Write-Host "и нажав клавишу Enter"
    Write-Host "1. У5-1"
    Write-Host "2. У5-2"
    Write-Host "3. У10-2"
    $case=Read-Host
    if ($case -eq 1){
        do
        {
            Clear-Host
            $choose=$true
            Write-Host "Выберите нужный вариант и нажмите Enter"
            Write-Host "1. Договора вкладов с юридическими лицами"
            Write-Host "2. Договора вкладов с физическими лицами"
            $case=Read-Host
            if ($case -eq 1){
                Write-Host "Введите название юридического лица и нажмите Enter"
                $case=Read-Host
                if ($case) {
                    echo "$case"
                    $flag = Test-Path "$tardir\У5-1\Депозитный отдел\"
                    if (!$flag){
                        mkdir "$tardir\У5-1\Депозитный отдел\Справки"
                        mkdir "$tardir\У5-1\Депозитный отдел\Архив"
                        mkdir "$tardir\У5-1\Депозитный отдел\Прочее"
                        & icacls "$tardir\У5-1\Депозитный отдел\Справки" /grant "PIRBANK\${user_r}:F" /T
                        & icacls "$tardir\У5-1\Депозитный отдел\Архив" /grant "PIRBANK\${user_r}:F" /T
                        & icacls "$tardir\У5-1\Депозитный отдел\Прочее" /grant "PIRBANK\${user_r}:F" /T
                    }
                    $flag = Test-Path "$tardir\У5-1\Депозитный отдел\Договора вкладов с юридическими лицами\$case"
                    if (!$flag){
                        mkdir "$tardir\У5-1\Депозитный отдел\Договора вкладов с юридическими лицами\$case"
                        mkdir "$tardir\У5-1\Депозитный отдел\Договора вкладов с юридическими лицами\$case\Договор"
                        mkdir "$tardir\У5-1\Депозитный отдел\Договора вкладов с юридическими лицами\$case\Доп соглашения"
                        mkdir "$tardir\У5-1\Депозитный отдел\Договора вкладов с юридическими лицами\$case\Доверенности"
                        mkdir "$tardir\У5-1\Депозитный отдел\Договора вкладов с юридическими лицами\$case\Распоряжения"
                        mkdir "$tardir\У5-1\Депозитный отдел\Договора вкладов с юридическими лицами\$case\Сообщения об открытии-закрытии счета"
                        mkdir "$tardir\У5-1\Депозитный отдел\Договора вкладов с юридическими лицами\$case\Учредительные документы"
                        mkdir "$tardir\У5-1\Депозитный отдел\Договора вкладов с юридическими лицами\$case\Справки"
                        mkdir "$tardir\У5-1\Депозитный отдел\Договора вкладов с юридическими лицами\$case\Архив"
                        & icacls "$tardir\У5-1\Депозитный отдел\Договора вкладов с юридическими лицами\$case\*" /grant "PIRBANK\${user_r}:F" /T
                    }
                    else {Write-Host "Такой клиент уже есть!"}
                }
                else {Write-Host "Ничего не введено"}
            }
            elseif ($case -eq 2){
                echo "Введите название физического лица и нажмите Enter"
                $case=Read-Host
                if ($case) {
                    echo "$case"
                    $flag = Test-Path "$tardir\У5-1\Депозитный отдел\Договора вкладов с физическими лицами\$case"
                    if (!$flag){
                        mkdir "$tardir\У5-1\Депозитный отдел\Договора вкладов с физическими лицами\$case"
                        mkdir "$tardir\У5-1\Депозитный отдел\Договора вкладов с физическими лицами\$case\Договор"
                        mkdir "$tardir\У5-1\Депозитный отдел\Договора вкладов с физическими лицами\$case\Доп соглашения"
                        mkdir "$tardir\У5-1\Депозитный отдел\Договора вкладов с физическими лицами\$case\Доверенности"
                        mkdir "$tardir\У5-1\Депозитный отдел\Договора вкладов с физическими лицами\$case\Распоряжения"
                        mkdir "$tardir\У5-1\Депозитный отдел\Договора вкладов с физическими лицами\$case\Сообщения об открытии-закрытии счета"
                        mkdir "$tardir\У5-1\Депозитный отдел\Договора вкладов с физическими лицами\$case \Док-ты по идентификации"
                        & icacls "$tardir\У5-1\Депозитный отдел\Договора вкладов с физическими лицами\$case\*" /grant "PIRBANK\${user_r}:F" /T
                    }
                    else {Write-Host "Такой клиент уже есть!"}
                }
                else {Write-Host "Ничего не введено"}
            }
            else {
               Write-Host "Неверное значение выбора"
               Write-Host "Нажмите Enter для продолжения"
               Read-Host
               $choose=$false
            }
        }
        while (!$choose)
    }
    elseif ($case -eq 2){
        do
        {
            Clear-Host
            $choose=$true
            $flag = Test-Path "$tardir\У5-2\Цессии"
            if ($flag){
                mkdir "$tardir\У5-2\Цессии"
                & icacls "$tardir\У5-2\Цессии" /grant "PIRBANK\${user_r}:F" /T
            }
            Write-Host "Выберите нужный вариант и нажмите Enter"
            Write-Host "1. Физики"
            Write-Host "2. Юрики"
            $case=Read-Host
            if ($case -eq 1){
                #echo "Физики"
                echo "Введите название физика и нажмите Enter"
                $case=Read-Host
                if ($case) {
                    echo "$case"
                    $flag = Test-Path "$tardir\У5-2\ФИЗИКИ\$case"
                    if (!$flag){
                        mkdir "$tardir\У5-2\ФИЗИКИ\$case"
                        mkdir "$tardir\У5-2\ФИЗИКИ\$case\Кредитные договора"
                        mkdir "$tardir\У5-2\ФИЗИКИ\$case\Договора обеспечения"
                        mkdir "$tardir\У5-2\ФИЗИКИ\$case\Распоряжения"
                        mkdir "$tardir\У5-2\ФИЗИКИ\$case\Проф_суждения"
                        mkdir "$tardir\У5-2\ФИЗИКИ\$case\Документы заемщиков"
                        mkdir "$tardir\У5-2\ФИЗИКИ\$case\Документы по обеспечению"
                        & icacls "$tardir\У5-2\ФИЗИКИ\$case\*" /grant "PIRBANK\${user_r}:F" /T
                    }
                    else {Write-Host "Такой клиент уже есть!"}
                }
                else {Write-Host "Ничего не введено"}
            }
            elseif ($case -eq 2){
                #echo "Юрики"
                echo "Введите название юрика и нажмите Enter"
                $case=Read-Host
                if ($case) {
                    echo "$case"
                    $flag = Test-Path "$tardir\У5-2\ЮРИКИ\$case"
                    if (!$flag){
                        mkdir "$tardir\У5-2\ЮРИКИ\$case"
                        mkdir "$tardir\У5-2\ЮРИКИ\$case\Кредитные договора"
                        mkdir "$tardir\У5-2\ЮРИКИ\$case\Договора обеспечения"
                        mkdir "$tardir\У5-2\ЮРИКИ\$case\Распоряжения"
                        mkdir "$tardir\У5-2\ЮРИКИ\$case\Проф_суждения"
                        mkdir "$tardir\У5-2\ЮРИКИ\$case\Документы заемщиков"
                        mkdir "$tardir\У5-2\ЮРИКИ\$case\Документы по обеспечению"
                        & icacls "$tardir\У5-2\ЮРИКИ\$case\*" /grant "PIRBANK\${user_r}:F" /T
                    }
                    else {Write-Host "Такой клиент уже есть!"}
                }
                else {Write-Host "Ничего не введено"}
            }
            else {
               Write-Host "Неверное значение выбора"
               Write-Host "Нажмите Enter для продолжения"
               Read-Host
               $choose=$false
            }
        }
        while (!$choose)
    }
    elseif ($case -eq 3){
        #Write-Host "Валютчики"
        do
        {
            Clear-Host
            $choose=$true
            Write-Host "Выберите нужный вариант и нажмите Enter"
            Write-Host "1. Клиенты"
            Write-Host "2. Банки-Корреспонденты"
            $case=Read-Host
            if ($case -eq 1){
               do {
                    $choose=$true
                    echo "Введите тип клиента и нажмите Enter"
                    echo "1. Юрлица резиденты"
                    echo "2. Физлица резиденты"
                    echo "3. Юрлица нерезиденты"
                    echo "4. Физлица нерезиденты"
                    $case=Read-Host
                    if ($case -eq "1") {
                        echo "Введите название юрлица резидента и нажмите Enter"
                        $nameorg=Read-Host
                        if ($nameorg) {
                            $flag = Test-Path "$tardir\У10-2\Юр.лица–резиденты\$nameorg"
                             if (!$flag){
                                   mkdir "$tardir\У10-2\Юр.лица–резиденты\$nameorg"
                                   }
                                           do
                                             {
                                                 Clear-Host
                                                 $choose=$true
                                                 Write-Host "Выберите нужный вариант и нажмите Enter"
                                                 Write-Host "1. С ПС"
                                                 Write-Host "2. БЕЗ ПС"
                                                 Write-Host "3. Трудовые договоры с нерезидентами"
                                                 $case=Read-Host
                                                 if ($case -eq "1") {
                                                 $flag=Test-Path "$tardir\У10-2\Юр.лица–резиденты\$nameorg\ПС"
                                                     if (!$flag){
                                                        mkdir "$tardir\У10-2\Юр.лица–резиденты\$nameorg\ПС"
                                                     }
                                                     do
                                                     {
                                                        Write-Host "Введите номер ПС"
                                                        $psnum=Read-Host
                                                        if ($psnum){
                                                            $flag=Test-Path "$tardir\У10-2\Юр.лица–резиденты\$nameorg\ПС\$psnum"
                                                            if (!$flag){
                                                            mkdir "$tardir\У10-2\Юр.лица–резиденты\$nameorg\ПС\$psnum"
                                                            mkdir "$tardir\У10-2\Юр.лица–резиденты\$nameorg\ПС\$psnum\Оформление-переоформление-закрытие ПС"
                                                            mkdir "$tardir\У10-2\Юр.лица–резиденты\$nameorg\ПС\$psnum\Платежи"
                                                            mkdir "$tardir\У10-2\Юр.лица–резиденты\$nameorg\ПС\$psnum\ПД"
                                                            mkdir "$tardir\У10-2\Юр.лица–резиденты\$nameorg\ПС\$psnum\Нарушения"
                                                            mkdir "$tardir\У10-2\Юр.лица–резиденты\$nameorg\ПС\$psnum\Письма-запросы"
                                                            mkdir "$tardir\У10-2\Юр.лица–резиденты\$nameorg\ПС\$psnum\ВБК"
                                                            mkdir "$tardir\У10-2\Юр.лица–резиденты\$nameorg\ПС\$psnum\Взаимодействие с У21"
                                                            & icacls "$tardir\У10-2\Юр.лица–резиденты\$nameorg\ПС\$psnum\*" /grant "PIRBANK\${user_r}:F" /T
                                                            }
                                                            else {Write-Host "Такой ПС уже есть"}
                                                     }
                                                        else {Write-Host "Ничего не введено"; $choose=$false}
                                                     }
                                                     while (!$choose)
                                                 }
                                                 elseif ($case -eq "2"){
                                                    do
                                                        {
                                                         Clear-Host
                                                         $choose=$true
                                                         Write-Host "Введите номер контракта и дату в формате `"XXXXX-ГГГГММДД`" (без кавычек) и нажмите Enter"
                                                         $numdate=Read-Host
                                                         if ($numdate){
                                                            mkdir "$tardir\У10-2\Юр.лица–резиденты\$nameorg\Досье без ПС"
                                                            mkdir "$tardir\У10-2\Юр.лица–резиденты\$nameorg\Досье без ПС\$numdate"
                                                            mkdir "$tardir\У10-2\Юр.лица–резиденты\$nameorg\Досье без ПС\$numdate\Контракт-изменение-прекращения действия"
                                                            mkdir "$tardir\У10-2\Юр.лица–резиденты\$nameorg\Досье без ПС\$numdate\Платежи"
                                                            mkdir "$tardir\У10-2\Юр.лица–резиденты\$nameorg\Досье без ПС\$numdate\ПД"
                                                            mkdir "$tardir\У10-2\Юр.лица–резиденты\$nameorg\Досье без ПС\$numdate\Нарушения"
                                                            mkdir "$tardir\У10-2\Юр.лица–резиденты\$nameorg\Досье без ПС\$numdate\Письма-запросы"
                                                            mkdir "$tardir\У10-2\Юр.лица–резиденты\$nameorg\Досье без ПС\$numdate\Взаимодействие с У21"
                                                            & icacls "$tardir\У10-2\Юр.лица–резиденты\$nameorg\Досье без ПС\$numdate\*" /grant "PIRBANK\${user_r}:F" /T
                                                         }
                                                         else {Write-Host "Ничего не введено"; $choose=$false}
                                                         }
                                                    while (!$choose)
                                                 }
                                                 elseif ($case -eq "3"){
                                                    do
                                                        {
                                                         Clear-Host
                                                         $choose=$true
                                                         Write-Host "Введите наименование нерезидента и нажмите Enter"
                                                         $case=Read-Host
                                                         if ($case){
                                                             $flag = Test-Path "$tardir\У10-2\Юр.лица–резиденты\$nameorg\Трудовые договоры с нерезидентами\$case"
                                                             if (!$flag){
                                                                mkdir "$tardir\У10-2\Юр.лица–резиденты\$nameorg\Трудовые договоры с нерезидентами\$case"
                                                                mkdir "$tardir\У10-2\Юр.лица–резиденты\$nameorg\Трудовые договоры с нерезидентами\$case\Договор-изменение-прекращения действия"
                                                                mkdir "$tardir\У10-2\Юр.лица–резиденты\$nameorg\Трудовые договоры с нерезидентами\$case\Платежи"
                                                                & icacls "$tardir\У10-2\Юр.лица–резиденты\$nameorg\Трудовые договоры с нерезидентами\$case\*" /grant "PIRBANK\${user_r}:F" /T
                                                            }
                                                            else {echo "Такой нерезидент уже есть"}
                                                         }
                                                         else {Write-Host "Ничего не введено"; $choose=$false}
                                                         }
                                                    while (!$choose)
                                                 }
                                                 else {Write-Host "Ничего не введено"}
                                            }
                                            while (!$choose) 

                        }
                    else {Write-Host "Ничего не введено"}
                    }
                    elseif ($case -eq "2"){
                        echo "Введите название физлица резидента и нажмите Enter"
                        $case=Read-Host
                        if ($case) {
                            #echo "$case"
                            $flag = Test-Path "$tardir\У10-2\Физ.лица – резиденты\$case"
                            if (!$flag){
                                   mkdir "$tardir\У10-2\Физ.лица – резиденты\$case"
                                   mkdir "$tardir\У10-2\Физ.лица – резиденты\$case\Договоры-инвойсы"
                                   mkdir "$tardir\У10-2\Физ.лица – резиденты\$case\Информация по выгодоприобретателям"
                                   mkdir "$tardir\У10-2\Физ.лица – резиденты\$case\Уведомление об открытии счетов за рубежом"
                                   mkdir "$tardir\У10-2\Физ.лица – резиденты\$case\Подтверждение родственных связей"
                                   & icacls "$tardir\У10-2\Физ.лица – резиденты\$case\*" /grant "PIRBANK\${user_r}:F" /T
                            }
                            echo "Введите номер контракта и дату в формате `"XXXXX-ГГГГММДД`" (без кавычек) и нажмите Enter"
                            $nomdog=Read-Host
                            if ($nomdog) {
                                $flag = Test-Path "$tardir\У10-2\Физ.лица – резиденты\$case\Договоры-инвойсы\$nomdog"
                                if (!$flag){
                                    mkdir "$tardir\У10-2\Физ.лица – резиденты\$case\Договоры-инвойсы\$nomdog"
                                    mkdir "$tardir\У10-2\Физ.лица – резиденты\$case\Договоры-инвойсы\$nomdog\Договор-инвойс"
                                    mkdir "$tardir\У10-2\Физ.лица – резиденты\$case\Договоры-инвойсы\$nomdog\Платежи"
                                    mkdir "$tardir\У10-2\Физ.лица – резиденты\$case\Договоры-инвойсы\$nomdog\Письма-запросы"
                                    mkdir "$tardir\У10-2\Физ.лица – резиденты\$case\Договоры-инвойсы\$nomdog\Взаимодействие с У21"
                                    & icacls "$tardir\У10-2\Физ.лица – резиденты\$case\Договоры-инвойсы\$nomdog\*" /grant "PIRBANK\${user_r}:F" /T
                                }
                                else {echo "Такой контракт уже есть"}
                            }
                            else {Write-Host "Ничего не введено"}
                        }
                    else {Write-Host "Ничего не введено"}
                    }
                    elseif ($case -eq "3"){
                        echo "Введите название юрлица нерезидента и нажмите Enter"
                        $case=Read-Host
                        if ($case) {
                            $flag = Test-Path "$tardir\У10-2\Юр.лица - нерезиденты\$case"
                             if (!$flag){
                                   mkdir "$tardir\У10-2\Юр.лица - нерезиденты\$case"
                            }
                            do {
                                echo "1. Ввести номер контракта"
                                echo "2. Трудовой договор с резидентами/нерезидентами"
                                $choose=Read-Host
                                if ($choose -eq "1")
                                {
                                        $flag = Test-Path "$tardir\У10-2\Юр.лица-нерезиденты\$case\Договоры-инвойсы"
                                        if (!$flag){
                                            mkdir "$tardir\У10-2\Юр.лица-нерезиденты\$case\Договоры-инвойсы"
                                        }
                                        echo "Введите номер контракта и дату в формате `"XXXXX-ГГГГММДД`" (без кавычек) и нажмите Enter"
                                        $nomdog=Read-Host
                                        if ($nomdog) {
                                            $flag = Test-Path "$tardir\У10-2\Юр.лица-нерезиденты\$case\Договоры-инвойсы\$nomdog"
                                            if (!$flag){
                                                mkdir "$tardir\У10-2\Юр.лица-нерезиденты\$case\Договоры-инвойсы\$nomdog"
                                                mkdir "$tardir\У10-2\Юр.лица-нерезиденты\$case\Договоры-инвойсы\$nomdog\Контракт-изменение-прекращения действия"
                                                mkdir "$tardir\У10-2\Юр.лица-нерезиденты\$case\Договоры-инвойсы\$nomdog\Платежи"
                                                mkdir "$tardir\У10-2\Юр.лица-нерезиденты\$case\Договоры-инвойсы\$nomdog\ПД"
                                                mkdir "$tardir\У10-2\Юр.лица-нерезиденты\$case\Договоры-инвойсы\$nomdog\Нарушения"
                                                mkdir "$tardir\У10-2\Юр.лица-нерезиденты\$case\Договоры-инвойсы\$nomdog\Письма-запросы"
                                                mkdir "$tardir\У10-2\Юр.лица-нерезиденты\$case\Договоры-инвойсы\$nomdog\Взаимодействие с У21"
                                                & icacls "$tardir\У10-2\Юр.лица-нерезиденты\$case\Договоры-инвойсы\$nomdog\*" /grant "PIRBANK\${user_r}:F" /T
                                            }
                                            else {Write-Host "Такой договор уже есть"}
                                             
                                        }
                                        else {Write-Host "Ничего не введено"}
                                }
                                elseif ($choose -eq "2")
                                {
                                    $flag = Test-Path "$tardir\У10-2\Юр.лица-нерезиденты\$case\Трудовые договоры с резидентами-нерезидентами"
                                    if (!$flag){
                                        mkdir "$tardir\У10-2\Юр.лица-нерезиденты\$case\Трудовые договоры с резидентами-нерезидентами"
                                    }
                                    echo "Введите наименование резидента/нерезидента"
                                    $resneres=Read-Host
                                    if ($resneres){
                                        $flag = Test-Path "$tardir\У10-2\Юр.лица-нерезиденты\$case\Трудовые договоры с резидентами-нерезидентами\$resneres"
                                        if (!$flag){
                                            mkdir "$tardir\У10-2\Юр.лица-нерезиденты\$case\Трудовые договоры с резидентами-нерезидентами\$resneres"
                                            mkdir "$tardir\У10-2\Юр.лица-нерезиденты\$case\Трудовые договоры с резидентами-нерезидентами\$resneres\Договор-изменение-прекращения действия"
                                            mkdir "$tardir\У10-2\Юр.лица-нерезиденты\$case\Трудовые договоры с резидентами-нерезидентами\$resneres\Платежи"
                                            & icacls "$tardir\У10-2\Юр.лица-нерезиденты\$case\Трудовые договоры с резидентами-нерезидентами\$resneres\*" /grant "PIRBANK\${user_r}:F" /T
                                        }
                                        else {Write-Host "Такой резидент/нерезидент уже есть"}
                                    }
                                    else {Write-Host "Ничего не введено"}
                                }
                                else {$choose=$false}
                            }    
                            while (!$choose)

                        }
                    else {Write-Host "Ничего не введено"}
                    }
                    elseif ($case -eq "4"){
                        echo "Введите название физлица нерезидента и нажмите Enter"
                        $case=Read-Host
                        if ($case) {
                            $flag = Test-Path "$tardir\У10-2\Физ.лица - нерезиденты\$case"
                             if (!$flag){
                                   mkdir "$tardir\У10-2\Физ.лица - нерезиденты\$case"
                                   mkdir "$tardir\У10-2\Физ.лица - нерезиденты\$case\Информация по выгодоприобретателям"
                                   & icacls "$tardir\У10-2\Физ.лица - нерезиденты\$case\*" /grant "PIRBANK\${user_r}:F" /T
                             }
                             echo "Введите номер контракта и дату в формате `"XXXXX-ГГГГММДД`" (без кавычек) и нажмите Enter"
                             $nomdog=Read-Host
                             $flag = Test-Path "$tardir\У10-2\Физ.лица - нерезиденты\$case\$nomdog"
                             if (!$flag){
                                mkdir "$tardir\У10-2\Физ.лица - нерезиденты\$case\$nomdog"
                                & icacls "$tardir\У10-2\Физ.лица - нерезиденты\$case\$nomdog" /grant "PIRBANK\${user_r}:F" /T
                             }
                             else {Write-Host "Такой контракт уже есть"}

                        }
                    else {Write-Host "Ничего не введено"}
                    }
                    else 
                    {
                        Write-Host "Неверное значение выбора"
                        Write-Host "Нажмите Enter для продолжения"
                        Read-Host
                        $choose=$false
                    }
                }
               while (!$choose) 
            }
            elseif ($case -eq 2){
                do {
                    $choose=$true
                    echo "Для всех банков создаем папки?"
                    echo "1. Да, для всех"
                    echo "2. Нет, я выберу банк самостоятельно"
                    $case=Read-Host
                    if ($case -eq "1") {
                         echo "Введите дату в формате ГГГГММДД"
                         $date=Read-Host
                         echo "$date, Верно?"
                         echo "1. Да"
                         echo "2. Нет"
                         $answ=Read-Host
                         if ($answ -eq "1") {
                            $year=$date.Substring(0,4)
                            $month=$date.Substring(4,2)
                            $day=$date.Substring(6,2)
                            echo "$year $month $day"
                            $flag=Test-Path "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\RBI (RAIFFEISEN BANK INTERNATIONAL AG)\USD - 30114-840-8-0000-0000012\$year\$month\$day"
                            if (!$flag){
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\RBI (RAIFFEISEN BANK INTERNATIONAL AG)\USD - 30114-840-8-0000-0000012\$year\$month\$day\Выписки"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\RBI (RAIFFEISEN BANK INTERNATIONAL AG)\USD - 30114-840-8-0000-0000012\$year\$month\$day\Кредитовые авизо"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\RBI (RAIFFEISEN BANK INTERNATIONAL AG)\USD - 30114-840-8-0000-0000012\$year\$month\$day\Дебетовые авизо"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\RBI (RAIFFEISEN BANK INTERNATIONAL AG)\EUR - 30114-978-4-0000-0000012\$year\$month\$day\Выписки"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\RBI (RAIFFEISEN BANK INTERNATIONAL AG)\EUR - 30114-978-4-0000-0000012\$year\$month\$day\Кредитовые авизо"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\RBI (RAIFFEISEN BANK INTERNATIONAL AG)\EUR - 30114-978-4-0000-0000012\$year\$month\$day\Дебетовые авизо"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\RBI (RAIFFEISEN BANK INTERNATIONAL AG)\GBP - 30114-826-4-0000-0000012\$year\$month\$day\Выписки"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\RBI (RAIFFEISEN BANK INTERNATIONAL AG)\GBP - 30114-826-4-0000-0000012\$year\$month\$day\Кредитовые авизо"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\RBI (RAIFFEISEN BANK INTERNATIONAL AG)\GBP - 30114-826-4-0000-0000012\$year\$month\$day\Дебетовые авизо"
                                & icacls "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\RBI (RAIFFEISEN BANK INTERNATIONAL AG)\GBP - 30114-826-4-0000-0000012\$year\$month\$day\*" /grant "PIRBANK\${user_r}:F" /T

                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\VTB (VTB Bank (Deutschland) AG)\EUR - 30114-978-4-0000-0000009\$year\$month\$day\Выписки"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\VTB (VTB Bank (Deutschland) AG)\EUR - 30114-978-4-0000-0000009\$year\$month\$day\Кредитовые авизо"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\VTB (VTB Bank (Deutschland) AG)\EUR - 30114-978-4-0000-0000009\$year\$month\$day\Дебетовые авизо"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\VTB (VTB Bank (Deutschland) AG)\GBP - 30114-826-4-0000-0000009\$year\$month\$day\Выписки"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\VTB (VTB Bank (Deutschland) AG)\GBP - 30114-826-4-0000-0000009\$year\$month\$day\Кредитовые авизо"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\VTB (VTB Bank (Deutschland) AG)\GBP - 30114-826-4-0000-0000009\$year\$month\$day\Дебетовые авизо"
                                & icacls "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\VTB (VTB Bank (Deutschland) AG)\GBP - 30114-826-4-0000-0000009\$year\$month\$day\*" /grant "PIRBANK\${user_r}:F" /T

                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\UNI (АО ЮНИКРЕДИТ БАНК)\USD - 30110-840-0-0000-0000023\$year\$month\$day\Выписки"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\UNI (АО ЮНИКРЕДИТ БАНК)\USD - 30110-840-0-0000-0000023\$year\$month\$day\Кредитовые авизо"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\UNI (АО ЮНИКРЕДИТ БАНК)\USD - 30110-840-0-0000-0000023\$year\$month\$day\Дебетовые авизо"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\UNI (АО ЮНИКРЕДИТ БАНК)\EUR - 30110-978-6-0000-0000023\$year\$month\$day\Выписки"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\UNI (АО ЮНИКРЕДИТ БАНК)\EUR - 30110-978-6-0000-0000023\$year\$month\$day\Кредитовые авизо"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\UNI (АО ЮНИКРЕДИТ БАНК)\EUR - 30110-978-6-0000-0000023\$year\$month\$day\Дебетовые авизо"
                                & icacls "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\UNI (АО ЮНИКРЕДИТ БАНК)\EUR - 30110-978-6-0000-0000023\$year\$month\$day\*" /grant "PIRBANK\${user_r}:F" /T

                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\SBER (ПАО Сбербанк)\USD - 30110-840-8-0000-0000016\$year\$month\$day\Выписки"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\SBER (ПАО Сбербанк)\USD - 30110-840-8-0000-0000016\$year\$month\$day\Кредитовые авизо"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\SBER (ПАО Сбербанк)\USD - 30110-840-8-0000-0000016\$year\$month\$day\Дебетовые авизо"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\SBER (ПАО Сбербанк)\EUR - 30110-978-0-0000-0000021\$year\$month\$day\Дебетовые авизо"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\SBER (ПАО Сбербанк)\EUR - 30110-978-0-0000-0000021\$year\$month\$day\Кредитовые авизо"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\SBER (ПАО Сбербанк)\EUR - 30110-978-0-0000-0000021\$year\$month\$day\Выписки"
                                & icacls "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\SBER (ПАО Сбербанк)\EUR - 30110-978-0-0000-0000021\$year\$month\$day\*" /grant "PIRBANK\${user_r}:F" /T

                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\GAZPROM (БАНК ГПБ (АО))\USD - 30110-840-9-0000-0000026\$year\$month\$day\Выписки"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\GAZPROM (БАНК ГПБ (АО))\USD - 30110-840-9-0000-0000026\$year\$month\$day\Кредитовые авизо"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\GAZPROM (БАНК ГПБ (АО))\USD - 30110-840-9-0000-0000026\$year\$month\$day\Дебетовые авизо"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\GAZPROM (БАНК ГПБ (АО))\EUR - 30110-978-5-0000-0000026\$year\$month\$day\Выписки"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\GAZPROM (БАНК ГПБ (АО))\EUR - 30110-978-5-0000-0000026\$year\$month\$day\Кредитовые авизо"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\GAZPROM (БАНК ГПБ (АО))\EUR - 30110-978-5-0000-0000026\$year\$month\$day\Дебетовые авизо"
                                & icacls "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\GAZPROM (БАНК ГПБ (АО))\EUR - 30110-978-5-0000-0000026\$year\$month\$day\*" /grant "PIRBANK\${user_r}:F" /T

                            }
                            else {Write-Host "В этом дне уже все создано"}
                         }
                    }
                    elseif ($case -eq "2"){
                         echo "Введите дату в формате ГГГГММДД"
                         $date=Read-Host
                         echo "$date, Верно?"
                         echo "1. Да"
                         echo "2. Нет"
                         $answ=Read-Host
                         if ($answ -eq "1") {
                            $year=$date.Substring(0,4)
                            $month=$date.Substring(4,2)
                            $day=$date.Substring(6,2)
                            echo "$year $month $day"
                            echo "Выберите нужный банк"
                            echo "1. RBI (RAIFFEISEN BANK INTERNATIONAL AG)"
                            echo "2. VTB (VTB Bank (Deutschland) AG)"
                            echo "3. UNI (АО ЮНИКРЕДИТ БАНК)"
                            echo "4. SBER (ПАО Сбербанк)"
                            echo "5. GAZPROM (БАНК ГПБ (АО))"
                            $choose=Read-Host
                            if ($choose -eq "1") {
                                $flag=Test-Path "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\RBI (RAIFFEISEN BANK INTERNATIONAL AG)\USD - 30114-840-8-0000-0000012\$year\$month\$day\Выписки"
                                if (!$flag){
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\RBI (RAIFFEISEN BANK INTERNATIONAL AG)\USD - 30114-840-8-0000-0000012\$year\$month\$day\Выписки"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\RBI (RAIFFEISEN BANK INTERNATIONAL AG)\USD - 30114-840-8-0000-0000012\$year\$month\$day\Кредитовые авизо"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\RBI (RAIFFEISEN BANK INTERNATIONAL AG)\USD - 30114-840-8-0000-0000012\$year\$month\$day\Дебетовые авизо"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\RBI (RAIFFEISEN BANK INTERNATIONAL AG)\EUR - 30114-978-4-0000-0000012\$year\$month\$day\Выписки"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\RBI (RAIFFEISEN BANK INTERNATIONAL AG)\EUR - 30114-978-4-0000-0000012\$year\$month\$day\Кредитовые авизо"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\RBI (RAIFFEISEN BANK INTERNATIONAL AG)\EUR - 30114-978-4-0000-0000012\$year\$month\$day\Дебетовые авизо"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\RBI (RAIFFEISEN BANK INTERNATIONAL AG)\GBP - 30114-826-4-0000-0000012\$year\$month\$day\Выписки"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\RBI (RAIFFEISEN BANK INTERNATIONAL AG)\GBP - 30114-826-4-0000-0000012\$year\$month\$day\Кредитовые авизо"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\RBI (RAIFFEISEN BANK INTERNATIONAL AG)\GBP - 30114-826-4-0000-0000012\$year\$month\$day\Дебетовые авизо"
                                & icacls "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\RBI (RAIFFEISEN BANK INTERNATIONAL AG)\GBP - 30114-826-4-0000-0000012\$year\$month\$day\*" /grant "PIRBANK\${user_r}:F" /T
                                }                                
                            }
                            elseif ($choose -eq "2") {
                                $flag=Test-Path "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\VTB (VTB Bank (Deutschland) AG)\EUR - 30114-978-4-0000-0000009\$year\$month\$day\Выписки"
                                if (!$flag){
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\VTB (VTB Bank (Deutschland) AG)\EUR - 30114-978-4-0000-0000009\$year\$month\$day\Выписки"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\VTB (VTB Bank (Deutschland) AG)\EUR - 30114-978-4-0000-0000009\$year\$month\$day\Кредитовые авизо"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\VTB (VTB Bank (Deutschland) AG)\EUR - 30114-978-4-0000-0000009\$year\$month\$day\Дебетовые авизо"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\VTB (VTB Bank (Deutschland) AG)\GBP - 30114-826-4-0000-0000009\$year\$month\$day\Выписки"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\VTB (VTB Bank (Deutschland) AG)\GBP - 30114-826-4-0000-0000009\$year\$month\$day\Кредитовые авизо"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\VTB (VTB Bank (Deutschland) AG)\GBP - 30114-826-4-0000-0000009\$year\$month\$day\Дебетовые авизо"
                                & icacls "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\VTB (VTB Bank (Deutschland) AG)\GBP - 30114-826-4-0000-0000009\$year\$month\$day\*" /grant "PIRBANK\${user_r}:F" /T
                                }                                
                            }
                            elseif ($choose -eq "3") {
                                $flag=Test-Path "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\UNI (АО ЮНИКРЕДИТ БАНК)\USD - 30110-840-0-0000-0000023\$year\$month\$day\Выписки"
                                if (!$flag){
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\UNI (АО ЮНИКРЕДИТ БАНК)\USD - 30110-840-0-0000-0000023\$year\$month\$day\Выписки"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\UNI (АО ЮНИКРЕДИТ БАНК)\USD - 30110-840-0-0000-0000023\$year\$month\$day\Кредитовые авизо"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\UNI (АО ЮНИКРЕДИТ БАНК)\USD - 30110-840-0-0000-0000023\$year\$month\$day\Дебетовые авизо"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\UNI (АО ЮНИКРЕДИТ БАНК)\EUR - 30110-978-6-0000-0000023\$year\$month\$day\Выписки"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\UNI (АО ЮНИКРЕДИТ БАНК)\EUR - 30110-978-6-0000-0000023\$year\$month\$day\Кредитовые авизо"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\UNI (АО ЮНИКРЕДИТ БАНК)\EUR - 30110-978-6-0000-0000023\$year\$month\$day\Дебетовые авизо"
                                & icacls "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\UNI (АО ЮНИКРЕДИТ БАНК)\EUR - 30110-978-6-0000-0000023\$year\$month\$day\*" /grant "PIRBANK\${user_r}:F" /T   
                                }                             
                            }
                            elseif ($choose -eq "4") {
                                $flag=Test-Path "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\SBER (ПАО Сбербанк)\USD - 30110-840-8-0000-0000016\$year\$month\$day\Выписки"
                                if (!$flag){
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\SBER (ПАО Сбербанк)\USD - 30110-840-8-0000-0000016\$year\$month\$day\Выписки"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\SBER (ПАО Сбербанк)\USD - 30110-840-8-0000-0000016\$year\$month\$day\Кредитовые авизо"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\SBER (ПАО Сбербанк)\USD - 30110-840-8-0000-0000016\$year\$month\$day\Дебетовые авизо"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\SBER (ПАО Сбербанк)\EUR - 30110-978-0-0000-0000021\$year\$month\$day\Дебетовые авизо"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\SBER (ПАО Сбербанк)\EUR - 30110-978-0-0000-0000021\$year\$month\$day\Кредитовые авизо"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\SBER (ПАО Сбербанк)\EUR - 30110-978-0-0000-0000021\$year\$month\$day\Выписки"
                                & icacls "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\SBER (ПАО Сбербанк)\EUR - 30110-978-0-0000-0000021\$year\$month\$day\*" /grant "PIRBANK\${user_r}:F" /T
                                }                                
                            }
                            elseif ($choose -eq "5") {
                                $flag=Test-Path "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\GAZPROM (БАНК ГПБ (АО))\USD - 30110-840-9-0000-0000026\$year\$month\$day\Выписки"
                                if (!$flag){
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\GAZPROM (БАНК ГПБ (АО))\USD - 30110-840-9-0000-0000026\$year\$month\$day\Выписки"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\GAZPROM (БАНК ГПБ (АО))\USD - 30110-840-9-0000-0000026\$year\$month\$day\Кредитовые авизо"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\GAZPROM (БАНК ГПБ (АО))\USD - 30110-840-9-0000-0000026\$year\$month\$day\Дебетовые авизо"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\GAZPROM (БАНК ГПБ (АО))\EUR - 30110-978-5-0000-0000026\$year\$month\$day\Выписки"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\GAZPROM (БАНК ГПБ (АО))\EUR - 30110-978-5-0000-0000026\$year\$month\$day\Кредитовые авизо"
                                mkdir "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\GAZPROM (БАНК ГПБ (АО))\EUR - 30110-978-5-0000-0000026\$year\$month\$day\Дебетовые авизо"
                                & icacls "$tardir\У10-2\БАНКИ-КОРРЕСПОНДЕНТЫ\GAZPROM (БАНК ГПБ (АО))\EUR - 30110-978-5-0000-0000026\$year\$month\$day\*" /grant "PIRBANK\${user_r}:F" /T
                                }                                
                            }
                            else{
                                
                            }
                         }
                    }
                    else 
                    {
                        Write-Host "Неверное значение выбора"
                        Write-Host "Нажмите Enter для продолжения"
                        Read-Host
                        $choose=$false
                    }
                }
               while (!$choose)    

            }
            else {
               Write-Host "Неверное значение выбора"
               Write-Host "Нажмите Enter для продолжения"
               Read-Host
               $choose=$false
            }
        }
        while (!$choose)    
    }
    else {
        Write-Host "Неверное значение выбора"
        Write-Host "Нажмите Enter для продолжения"
        Read-Host
        $choose=$false
    }
}
while (!$choose)

}


if (($env:username -ne "$admu5_1") -and ($env:username -ne "$admu5_2") -and ($env:username -ne "$admu10_2"))
{
    #& runas /savecred /user:"PIRBANK\test3" "powershell C:\test\DirsScans\runas.ps1"
    Write-Host "Введите пользователя"
    $user=Read-Host
    & runas /user:"PIRBANK\$user" "powershell C:\test\DirsScans\DirsScans.ps1"
}

else

{
    $date=Get-Date
    echo $date >> "C:\test\DirsScans\log.log"
    Main
}














