# IDM Instalador + Ativador Automatico PT-BR
# Uso: irm https://raw.githubusercontent.com/brodrigues0ll/Lemmiwinks/main/Ativar-IDM.ps1 | iex

$scriptUrl = "https://raw.githubusercontent.com/brodrigues0ll/Lemmiwinks/main/Ativar-IDM.ps1"
$repoUrl   = "https://raw.githubusercontent.com/brodrigues0ll/Lemmiwinks/main"

trap {
    Write-Host ""
    Write-Host "ERRO: $_" -ForegroundColor Red
    Read-Host "Pressione Enter para fechar"
    exit 1
}

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
    Write-Host "Solicitando permissoes de administrador..." -ForegroundColor Yellow
    $tmp = "$env:TEMP\IDM-Ativador.ps1"
    Invoke-WebRequest -Uri $scriptUrl -OutFile $tmp -UseBasicParsing
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$tmp`"" -Verb RunAs
    exit
}

$dir = "$env:TEMP\IDM-Ativador"
$ias = "$dir\IAS.cmd"

Write-Host ""
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "   IDM Instalador + Ativador Auto" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

New-Item -ItemType Directory -Path $dir -Force | Out-Null

function Install-Winget {
    Write-Host "    Baixando dependencias do winget..." -ForegroundColor Yellow

    # VCLibs
    $vcLibsPath = "$dir\VCLibs.appx"
    Invoke-WebRequest -Uri "https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx" -OutFile $vcLibsPath -UseBasicParsing
    Add-AppxPackage -Path $vcLibsPath -ErrorAction SilentlyContinue

    # UI.Xaml (dependencia do winget)
    $xamlPath = "$dir\xaml.zip"
    $xamlExtract = "$dir\xaml"
    Invoke-WebRequest -Uri "https://www.nuget.org/api/v2/package/Microsoft.UI.Xaml/2.8.6" -OutFile $xamlPath -UseBasicParsing
    Expand-Archive -Path $xamlPath -DestinationPath $xamlExtract -Force
    $xamlAppx = Get-ChildItem "$xamlExtract\tools\AppX\x64\Release\" -Filter "*.appx" | Select-Object -First 1
    if ($xamlAppx) { Add-AppxPackage -Path $xamlAppx.FullName -ErrorAction SilentlyContinue }

    # winget msixbundle
    Write-Host "    Baixando winget..." -ForegroundColor Yellow
    $release = Invoke-RestMethod -Uri "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
    $msixUrl = ($release.assets | Where-Object { $_.name -match "\.msixbundle$" } | Select-Object -First 1).browser_download_url
    $msixPath = "$dir\winget.msixbundle"
    Invoke-WebRequest -Uri $msixUrl -OutFile $msixPath -UseBasicParsing
    Add-AppxPackage -Path $msixPath

    # Atualizar PATH da sessao atual
    $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","Machine") + ";" +
                [System.Environment]::GetEnvironmentVariable("PATH","User")
}

# --- Etapa 1: Garantir winget ---
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "[1/5] winget nao encontrado. Instalando..." -ForegroundColor Yellow
    Install-Winget
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Host "    Falha ao instalar winget. Usando instalador direto como fallback..." -ForegroundColor Yellow
        $useWinget = $false
    } else {
        Write-Host "    winget instalado com sucesso." -ForegroundColor Green
        $useWinget = $true
    }
} else {
    Write-Host "[1/5] winget disponivel." -ForegroundColor Green
    $useWinget = $true
}

# --- Etapa 2: Instalar IDM ---
if ($useWinget) {
    Write-Host "[2/5] Instalando IDM via winget..." -ForegroundColor Yellow
    winget install --id Tonec.InternetDownloadManager --silent --accept-package-agreements --accept-source-agreements --force
} else {
    Write-Host "[2/5] Baixando instalador do IDM..." -ForegroundColor Yellow
    $downloadPage = Invoke-WebRequest -Uri "https://www.internetdownloadmanager.com/download.html" -UseBasicParsing
    $idmUrl = [regex]::Match($downloadPage.Content, 'https?://download\.internetdownloadmanager\.com/idman[^"]+\.exe').Value

    if (-not $idmUrl) {
        Write-Host "Nao foi possivel obter a URL do instalador." -ForegroundColor Red
        Read-Host "Pressione Enter para fechar"
        exit 1
    }

    $installer = "$dir\idm_setup.exe"
    Invoke-WebRequest -Uri $idmUrl -OutFile $installer -UseBasicParsing
    Write-Host "    Instalando com /skipdlgs..." -ForegroundColor Yellow
    Start-Process -FilePath $installer -ArgumentList "/skipdlgs" -Wait
}

Start-Sleep -Seconds 2
Stop-Process -Name "IDMan" -ErrorAction SilentlyContinue

# --- Etapa 3: Ativar IDM ---
Write-Host "[3/5] Baixando IAS.cmd..." -ForegroundColor Yellow
Invoke-WebRequest -Uri "$repoUrl/IAS.cmd" -OutFile $ias -UseBasicParsing

Write-Host "[4/5] Redefinindo estado anterior..." -ForegroundColor Yellow
cmd /c "`"$ias`" /res /silent"

Write-Host "[5/5] Ativando IDM..." -ForegroundColor Yellow
cmd /c "`"$ias`" /act /silent"
$code = $LASTEXITCODE

Remove-Item -Path $dir -Recurse -Force -ErrorAction SilentlyContinue

Write-Host ""
if ($code -eq 0) {
    Write-Host "IDM instalado e ativado com sucesso!" -ForegroundColor Green
} else {
    Write-Host "Ativacao retornou codigo: $code - verifique se o IDM foi instalado corretamente." -ForegroundColor Red
}

Write-Host ""
Read-Host "Pressione Enter para fechar"
