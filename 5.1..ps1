
function CopyPathByExtension {
    param(
        [string]$targetFolde , #любой адрес каталога файловой системы
        [string]$myFolder, #удобное место
        [int] $MaxExtcount  # минимальное кол-во расширений
    )

        $ExtCount = ((Get-ChildItem -Path targetFolde -File -Recurse).Extension | Select-Object -Unique).count #получаем число суммы уникальных расширений
        if ($ExtCount -gt $MaxExtcount){
            Write-Host "Folder have $ExtCout extension " -ForegroundColor Green
            Copy-Item -Path $folder -Destination $targetFolde -Recurse 
        }else {
            Write-Host "Folder have $ExtCout extension " -ForegroundColor Red
        }
}

function SortByExt {
    param(
        [string]$myFolder  #откуда берем файлы
    )

    # sort files by extension in descending order
    $files = Get-ChildItem -Path $directory | Sort-Object -Property @{Expression = {[System.IO.Path]::GetExtension($_)}; Descending = $true}
    
    foreach ($file in $files)
    {
        $key = $file.Extension.Replace(".","") #получаем имя расширения, заменяем символ точkи 
        $fileFolder = $directory+$key  #формируем новое название папки по расширению
        if(!(Test-Path -Path $fileFolder )){   #проверяем есть ли такая папка
            New-Item -ItemType Directory -Force -Path $fileFolder  #создаем если нет таковой
        }
        Move-Item -Path $file -Destination $fileFolder  #перемещаем файл
    }
}

function GetFileInfor {
    param(
        [string]$myFolder  #откуда берем файлы
    )

    $files = Get-ChildItem -Path $directory -Recurse
    $files | Group-Object -Property extension -NoElement | Sort-Object -Property Count -Descending
}

######################
function GetSmallFolder {
    param(
        [string]$myFolder  #откуда берем файлы
    )
    $folders = Get-ChildItem $myFolder -Directory -Recurse
    foreach ($folder in $folders){
        $i 
        $files = (Get-ChildItem -Path $folder -File -Recurse).Count
        if ($files -le 3){
            $i++
            Rename-Item -Path $folder -NewName "small_$i"
        }
    }
}



#5.1.1
CopyPathByExtension -MaxExtcount 5 -targetFolde "C:\Temp\" -myFolder "D:\temp"

#5.1.2
SortByExt -myFolder "D:\temp" 

#5.1.3
GetFileInfor -myFolder "D:\temp"   

#5.1.4
GetSmallFolder -myFolder "D:\temp"  