Param(
    [Parameter(Mandatory)]
    [string]$URL,

	[Parameter(Mandatory)]
    [Alias("u")]
    [string]$user,

	[Parameter(Mandatory)]
    [Alias("p")]
    [string]$password,

    [Parameter(Mandatory)]
    [Alias("br")]
    [string]$branchName,

    [Parameter(Mandatory)]
    [string]$sqlUser,

    [Parameter(Mandatory)]
    [string]$sqlPass
)

[int]$startMs = (Get-Date).Millisecond

$dateTime = Get-Date -Format "dd-MM-yyyy_HH-mm-ss.fff"
$releasesFolder = "C:\releases\sibur.digital.svt.ptcc\"
$arifactName =  $url.Split("/")[-1].Split(".")[0] + "-(" + $branchName.Split("/")[-1] + ")-" + $dateTime
$arifactFullName = $releasesFolder + $arifactName + ".zip"
$serviceNames = @("nkhtk-converter", "nkhtk-ui", "nkhtk-data")
$serviceFolder = "C:\SVT\"
$backupFolder = "D:\backups\"
#Кол-во попыток повторения операции по остановке/запуску Applecation Pools
$retryWebAppPool = 3
#Таймаут ожидания после команд Start-WebAppPool и Stop-WebAppPool, чтоб дать IIS подумать о своем поведении
$timeoutAP = 3
#Таймаут-костыль, чтобы дать Файловой системе осознать себя и отпустить файлы
$timeoutFS = 10

function downloadArifact {

    $pair = "$($user):$($password)"
    $encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))
    $basicAuthValue = "Basic $encodedCreds"
    $headers = @{
        Authorization = $basicAuthValue
    }

    Write-Host "`nStart Download Arifact... `n"

    Invoke-WebRequest -Uri $url -OutFile $arifactFullName -Headers $headers

    Write-Host "`n --- `n"
}

function unzipArifact {

    Write-Host "`nStart unzip arifact...`n"

    New-Item -Path $releasesFolder -Name $arifactName -ItemType "directory"

    7z x $arifactFullName -o"$releasesFolder\$arifactName" -r

    Write-Host "`n --- `n"
}

function stopPools {

    foreach ($poolName in $serviceNames) {

        $tryCount = 1
        $targetStatus = "Stopped"
        $currentStatus = Get-WebAppPoolState -Name $poolName

        while (($currentStatus.Value -ne $targetStatus) -and ($tryCount -ne $retryWebAppPool)) {
            Stop-WebAppPool -Name $poolName
            Start-Sleep -Seconds $timeoutAP
            $currentStatus = Get-WebAppPoolState -Name $poolName
            $tryCount++
        }

        if ($currentStatus.Value -ne $targetStatus) {
            Write-Host "`n$poolName is NOT stopped."
            throw "`nWe have errors, rollout will be stopped."
        } else {
            Write-Host "`n$poolName is stopped."
        }

    }

    #Ждем на всякий случай, чтоб файловая система отпустила все файлы приложений
    Start-Sleep -Seconds $timeoutFS
    Write-Host "`n --- `n"
}

function startPools {

    foreach ($poolName in $serviceNames) {

        $tryCount = 1
        $targetStatus = "Started"
        $currentStatus = Get-WebAppPoolState -Name $poolName

        while (($currentStatus.Value -ne $targetStatus) -and ($tryCount -ne $retryWebAppPool)) {
            Start-WebAppPool -Name $poolName
            Start-Sleep -Seconds $timeoutAP
            $currentStatus = Get-WebAppPoolState -Name $poolName
            $tryCount++
        }

        if ($currentStatus.Value -ne $targetStatus) {
            Write-Host "`n$poolName is NOT started."
            throw "`nWe have errors, rollout will be stopped."
        } else {
            Write-Host "`n$poolName is started."
        }

    }

    Write-Host "`n --- `n"
}

function backupOldFiles {

    Write-Host "`nStart beckup...`n"

    foreach ($folderName in $serviceNames) {

        $path = $serviceFolder + $folderName

        $backupPath = $backupFolder + "nkhtk_" + $dateTime + "\" + $folderName

        Copy-Item -Path $path -Destination $backupPath -Recurse -Force

        Write-Host "$folderName has been backuped"
    }
    Write-Host "`n --- `n"
}

function releaseDeploy {

    Write-Host "`nStart deploy...`n"

    foreach ($folderName in $serviceNames) {

        $releaseFolder = $releasesFolder + $arifactName + "\" + $folderName

        Copy-Item -Path $releaseFolder -Destination $serviceFolder -Recurse -Force

        Write-Host "$folderName has been deployed"
    }

    Write-Host "`n --- `n"
}

function executeDBScrips {

    $schemeName = "nkhtk"
    $scriptFolder = $releasesFolder + $arifactName + "\scripts"
    $sqlServerAddres = "s001itd-0084"

    #Из релиза берем все скрипты и получаем их относительные пути
    $scriptReleaseFileNames = (Get-ChildItem -Path $scriptFolder -Force -Recurse -Filter *.sql).FullName |ForEach-Object {
        $_ = $_.SubString($_.IndexOf('\scripts'))
        $_
    }

    #Запрашиваем из БД все ранее выполнненые скрипты
    $completedScriptNames = (Invoke-Sqlcmd -ServerInstance $sqlServerAddres `
                            -Database 'mdm_integ' `
                            -Query "SELECT [ScriptFullName] FROM [mdm_integ].[SvtSys].[CompletedScriptLog]" `
                            -Username $sqlUser `
                            -Password $sqlPass).ScriptFullName

    #Вычисляем разницу
    $difference = (Compare-Object `
                    -ReferenceObject $scriptReleaseFileNames `
                    -DifferenceObject $completedScriptNames `
                | ? {$_.SideIndicator -eq "<="}).InputObject

    if ($difference.Count -eq 0) {

        Write-Host "`nNothing scripts to execute`n"

    } else {

        Write-Host "`nStart execute scripts`n"
    }

    #Поочередно выполняем все скрипты которые ранее не выполнялись
    #Сортировка выполняется автоматически по позрастанию при формировании массива
    ForEach ($scriptForRelease in $difference) {

        $fullPathToScript = $releasesFolder + $arifactName + $scriptForRelease

        Write-Host  "Run script $scriptForRelease `n"

        Invoke-Sqlcmd -ServerInstance $sqlServerAddres -Database 'mdm_integ' `
                            -InputFile $fullPathToScript `
                            -Username $sqlUser `
                            -Password $sqlPass

        Write-Host  "Completed script $scriptForRelease `n"

        #После каждого скрипта делаем запись в таблицу-лог
        $queryStr = "INSERT INTO [SvtSys].[CompletedScriptLog]
                (
                    [ScriptFullName]
                    ,[SchemeName]
                    ,[СompleteDate]
                )
                VALUES
                (
                     N'$scriptForRelease'
                    ,N'$schemeName'
                    ,GETDATE()
                );"

        Invoke-Sqlcmd -ServerInstance $sqlServerAddres `
                            -Database 'mdm_integ' `
                            -Query $queryStr `
                            -Username $sqlUser `
                            -Password $sqlPass

        Write-Host  "Write info into log abaut script $scriptForRelease `n"
    }

    Write-Host "`n --- `n"

}

function main {
    try {
        Write-Host "`nStart deploy job...`n"

        downloadArifact

        unzipArifact

        stopPools

        backupOldFiles

        releaseDeploy

        executeDBScrips

        startPools
    } catch {
        Write-Host -ForegroundColor Red $_.Exception.Message
        Write-Host -ForegroundColor Red $_.ScriptStackTrace
    } finally {
        [int]$endMs = (Get-Date).Millisecond
        Write-Host "`nDeployment job completed `nExecution time: $($startMs - $endMs) ms...`n"
    }
}

main