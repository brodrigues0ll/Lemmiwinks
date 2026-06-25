# IDM Ativador Automatico PT-BR
# Uso: irm https://raw.githubusercontent.com/brodrigues0ll/Ativador-IDM/main/Ativar-IDM.ps1 | iex

$scriptUrl = "https://raw.githubusercontent.com/brodrigues0ll/Ativador-IDM/main/Ativar-IDM.ps1"
$repoUrl   = "https://raw.githubusercontent.com/brodrigues0ll/Ativador-IDM/main"

# Captura qualquer erro nao tratado e mantem janela aberta
trap {
    Write-Host ""
    Write-Host "ERRO: $_" -ForegroundColor Red
    Read-Host "Pressione Enter para fechar"
    exit 1
}

# Solicitar permissoes de administrador se necessario
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
Write-Host "================================" -ForegroundColor Cyan
Write-Host "   IDM Ativador Automatico" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

New-Item -ItemType Directory -Path $dir -Force | Out-Null

Write-Host "[1/3] Baixando IAS.cmd..." -ForegroundColor Yellow
Invoke-WebRequest -Uri "$repoUrl/IAS.cmd" -OutFile $ias -UseBasicParsing

Write-Host "[2/3] Redefinindo estado anterior do IDM..." -ForegroundColor Yellow
cmd /c "`"$ias`" /res /silent"

Write-Host "[3/3] Ativando IDM..." -ForegroundColor Yellow
cmd /c "`"$ias`" /act /silent"
$code = $LASTEXITCODE

Remove-Item -Path $dir -Recurse -Force -ErrorAction SilentlyContinue

Write-Host ""
if ($code -eq 0) {
    Write-Host "IDM ativado com sucesso!" -ForegroundColor Green
} else {
    Write-Host "Codigo de saida: $code - verifique se o IDM esta instalado." -ForegroundColor Red
}

Write-Host ""
Read-Host "Pressione Enter para fechar"
