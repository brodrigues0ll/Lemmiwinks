# IDM Ativador Automatico PT-BR
# Uso: irm https://raw.githubusercontent.com/SEU_USUARIO/IDM-Activation-Script-PTBR/main/Ativar-IDM.ps1 | iex

$repoUrl = "https://raw.githubusercontent.com/SEU_USUARIO/IDM-Activation-Script-PTBR/main"

# Solicitar permissoes de administrador se necessario
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
    Write-Host "Solicitando permissoes de administrador..." -ForegroundColor Yellow
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"irm '$repoUrl/Ativar-IDM.ps1' | iex`"" -Verb RunAs -Wait
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

Write-Host "[1/3] Baixando script..." -ForegroundColor Yellow
try {
    Invoke-WebRequest -Uri "$repoUrl/IAS.cmd" -OutFile $ias -UseBasicParsing
} catch {
    Write-Host "Erro ao baixar IAS.cmd: $_" -ForegroundColor Red
    exit 1
}

if (!(Test-Path $ias)) {
    Write-Host "Erro: IAS.cmd nao encontrado apos download." -ForegroundColor Red
    exit 1
}

Write-Host "[2/3] Redefinindo estado anterior do IDM..." -ForegroundColor Yellow
cmd /c "`"$ias`" /res /silent"

Write-Host "[3/3] Ativando IDM..." -ForegroundColor Yellow
cmd /c "`"$ias`" /act /silent"
$exitCode = $LASTEXITCODE

Write-Host ""
if ($exitCode -eq 0) {
    Write-Host "IDM ativado com sucesso!" -ForegroundColor Green
} else {
    Write-Host "Ativacao encerrou com codigo $exitCode - verifique se o IDM esta instalado." -ForegroundColor Red
}
Write-Host ""

Remove-Item -Path $dir -Recurse -Force -ErrorAction SilentlyContinue
