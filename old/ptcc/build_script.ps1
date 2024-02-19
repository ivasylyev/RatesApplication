Param(
    [Alias("br")]
    [string]$buildBranchName
)

function createBuildInfo {
    $date = Get-Date -Format "dd/MM/yyyy HH:mm:ss"
    $buildInfo = New-Object 'System.Collections.Generic.Dictionary[String,String]'
    $buildInfo.Add("BuildBranchName",$buildBranchName)
    $buildInfo.Add("BuildDate",$date)

    $buildInfoJson = ConvertTo-Json -InputObject  @{"BuildInfo"= $buildInfo}

    Write-Output "Write build info: $buildInfoJson"

    $buildInfoFilePathConverter = $path_nkhtk_converter_PublishDir + "appsettings.BuildInfo.json"
    Out-File -FilePath $buildInfoFilePathConverter -InputObject $buildInfoJson

    $buildInfoFilePathUI = $path_nkhtk_ui_PublishDir + "appsettings.BuildInfo.json"
    Out-File -FilePath $buildInfoFilePathUI -InputObject $buildInfoJson

    $buildInfoFilePathData = $path_nkhtk_data_PublishDir + "appsettings.BuildInfo.json"
    Out-File -FilePath $buildInfoFilePathData -InputObject $buildInfoJson
}

#Переменные для путей
$path_nkhtk_converter = $($PSScriptRoot) + '\Sibur.Digital.Svt.Nkhtk.Converter\Sibur.Digital.Svt.Nkhtk.Converter.csproj'
$path_nkhtk_data = $($PSScriptRoot) + '\Sibur.Digital.Svt.Nkhtk.Data\Sibur.Digital.Svt.Nkhtk.Data.csproj'
$path_nkhtk_ui = $($PSScriptRoot) + '\Sibur.Digital.Svt.Nkhtk.UI\Sibur.Digital.Svt.Nkhtk.UI.csproj'
$path_nkhtk_db_scripts = $($PSScriptRoot) + '\Sibur.Digital.Svt.Nkhtk.DB\Scripts\*'
#$path_nkhtk_db_schemes = $($PSScriptRoot) + '\Sibur.Digital.Svt.Nkhtk.DB\Scripts\0001-SVT-412\*' #Временн убрал создание схемы

$path_nkhtk_converter_test = $($PSScriptRoot) + '\Sibur.Digital.Svt.Nkhtk.Converter.Tests\Sibur.Digital.Svt.Nkhtk.Converter.Tests.csproj'
$path_nkhtk_data_test = $($PSScriptRoot) + '\Sibur.Digital.Svt.Nkhtk.Data.Tests\Sibur.Digital.Svt.Nkhtk.Data.Tests.csproj'
$path_nkhtk_infra_test = $($PSScriptRoot) + '\Sibur.Digital.Svt.Infrastructure.Tests\Sibur.Digital.Svt.Infrastructure.Tests.csproj'

$path_nkhtk_converter_PublishDir = $($PSScriptRoot) + '\out\nkhtk-converter\'
$path_nkhtk_data_PublishDir = $($PSScriptRoot) + '\out\nkhtk-data\'
$path_nkhtk_ui_PublishDir = $($PSScriptRoot) + '\out\nkhtk-ui\'

$path_from_out = $($PSScriptRoot) + '\out\*'
$path_from_out_scripts = $($PSScriptRoot) + '\out\scripts\'
$path_from_zip = $($PSScriptRoot) + '\out\release.zip'

# Восстанавливаем зависимости (nuGet-пакеты)
Write-Output "restore NuGet..."
dotnet restore $path_nkhtk_converter
dotnet restore $path_nkhtk_data
dotnet restore $path_nkhtk_ui

#Запускаем тесты
Write-Output "start test for soliution..."
dotnet test $path_nkhtk_converter_test --configuration Release --filter Category=Unit --logger "console;verbosity=detailed" --os win --no-restore
dotnet test $path_nkhtk_data_test      --configuration Release --filter Category=Unit --logger "console;verbosity=detailed" --os win --no-restore
dotnet test $path_nkhtk_infra_test     --configuration Release --filter Category=Unit --logger "console;verbosity=detailed" --os win --no-restore

# Собираем билд
Write-Output "build & publish..."

dotnet publish $path_nkhtk_converter --os win --framework:net6.0 -p:Configuration=Release -p:PublishDir=$path_nkhtk_converter_PublishDir -nologo -v:minimal -target:Publish
dotnet publish $path_nkhtk_data      --os win --framework:net6.0 -p:Configuration=Release -p:PublishDir=$path_nkhtk_data_PublishDir      -nologo -v:minimal -target:Publish
dotnet publish $path_nkhtk_ui        --os win --framework:net6.0 -p:Configuration=Release -p:PublishDir=$path_nkhtk_ui_PublishDir        -nologo -v:minimal -target:Publish

#Записываем информацию по билду
createBuildInfo

# Удаляем шлак
Write-Output "remove garbage..."
Get-ChildItem -Path $path_from_out -Recurse -Include appsettings.json,appsettings.Development.json,*.pdb,*.crt | %{Remove-Item $_ -Confirm:$false -Recurse}

# Собираем скирпты для БД
Write-Output "collect scripts for DB..."

mkdir $path_from_out_scripts
Copy-Item -Path $path_nkhtk_db_scripts -Destination $path_from_out_scripts -Recurse
#Copy-Item -Path $path_nkhtk_db_schemes   -Destination $path_from_out_scripts -Recurse #Временн убрал создание схемы (надо отдельный скрипт сделаать для DRP)

# Пакуем
Write-Output "Packing... "
7z a -tzip $path_from_zip $path_from_out