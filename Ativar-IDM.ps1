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

# --- Etapa 1: Instalar IDM ---
$wingetAvailable = Get-Command winget -ErrorAction SilentlyContinue

if ($wingetAvailable) {
    Write-Host "[1/4] Instalando IDM via winget..." -ForegroundColor Yellow
    winget install --id Tonec.InternetDownloadManager --silent --accept-package-agreements --accept-source-agreements --force
} else {
    Write-Host "[1/4] winget nao encontrado. Baixando instalador direto..." -ForegroundColor Yellow

    $downloadPage = Invoke-WebRequest -Uri "https://www.internetdownloadmanager.com/download.html" -UseBasicParsing
    $idmUrl = [regex]::Match($downloadPage.Content, 'https?://download\.internetdownloadmanager\.com/idman[^"]+\.exe').Value

    if (-not $idmUrl) {
        Write-Host "Nao foi possivel obter a URL do instalador. Verifique sua conexao." -ForegroundColor Red
        Read-Host "Pressione Enter para fechar"
        exit 1
    }

    Write-Host "    Baixando de: $idmUrl" -ForegroundColor Yellow
    $installer = "$dir\idm_setup.exe"
    Invoke-WebRequest -Uri $idmUrl -OutFile $installer -UseBasicParsing

    Write-Host "    Instalando com /skipdlgs..." -ForegroundColor Yellow
    Start-Process -FilePath $installer -ArgumentList "/skipdlgs" -Wait
}

Start-Sleep -Seconds 2
Stop-Process -Name "IDMan" -ErrorAction SilentlyContinue

# --- Etapa 2: Ativar IDM ---
Write-Host "[2/4] Baixando IAS.cmd..." -ForegroundColor Yellow
Invoke-WebRequest -Uri "$repoUrl/IAS.cmd" -OutFile $ias -UseBasicParsing

Write-Host "[3/4] Redefinindo estado anterior..." -ForegroundColor Yellow
cmd /c "`"$ias`" /res /silent"

Write-Host "[4/4] Ativando IDM..." -ForegroundColor Yellow
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
