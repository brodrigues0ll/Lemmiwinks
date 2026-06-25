@echo off
chcp 1252 >nul 2>&1
setlocal EnableExtensions EnableDelayedExpansion
title IDM Script de Ativacao - Iniciar Ativacao

set "IAS=%~dp0IAS.cmd"
set "self=%~f0"

::====================== Obter permissoes de administrador automaticamente ======================
::  Nota: usa aspas simples para encapsular o caminho, evitando erros de sintaxe
::  como "Nao e possivel ter \Internet" quando o diretorio contem (x86) ou
::  outros caracteres especiais.
fltmc >nul 2>&1
if %errorlevel% NEQ 0 goto :elevate
goto :checks

:elevate
echo [Aviso] Solicitando permissoes de administrador, clique em "Sim" na janela que aparecer...
where powershell.exe >nul 2>&1 || goto :noPS
powershell -NoProfile -Command "Start-Process -FilePath '%self%' -Verb RunAs"
exit /b

:noPS
echo [x] PowerShell nao encontrado, nao e possivel elevar automaticamente.
echo     Clique com o botao direito neste arquivo e selecione "Executar como administrador".
pause
exit /b 1

:checks
if not exist "%IAS%" (
    echo [x] IAS.cmd nao encontrado, confirme que este arquivo e IAS.cmd estao na mesma pasta.
    echo     Se obtido de um arquivo compactado, primeiro "Extraia tudo" antes de executar,
    echo     nao abra diretamente dentro do arquivo compactado.
    pause
    exit /b 1
)

::====================== Verificacao de ambiente (autodiagnostico antes da ativacao) ======================
set /a issues=0
set "firstFail="
cls
echo ==========================================
echo   IDM - Verificacao de Ambiente
echo ==========================================
echo:
echo [OK] Permissoes de administrador obtidas
echo [OK] IAS.cmd encontrado

set "_psFound="
where powershell.exe >nul 2>&1 && set "_psFound=1"
if defined _psFound (
    echo [OK] PowerShell disponivel
    for /f "delims=" %%a in ('powershell -NoProfile -Command "$ExecutionContext.SessionState.LanguageMode" 2^>nul') do set "psmode=%%a"
    if defined psmode if /i not "!psmode!"=="FullLanguage" (
        echo [x] Modo de linguagem do PowerShell e !psmode! - pode estar restrito pela politica da organizacao
        set /a issues+=1
        if not defined firstFail set "firstFail=Modo de linguagem do PowerShell restrito, veja README Q6"
    )
) else (
    echo [x] PowerShell nao encontrado no sistema
    set /a issues+=1
    if not defined firstFail set "firstFail=PowerShell nao encontrado, veja README Q6"
)

set "_nullFound="
sc query Null | find /i "RUNNING" >nul 2>&1 && set "_nullFound=1"
if defined _nullFound (
    echo [OK] Servico Null em execucao
) else (
    echo [x] Servico Null nao esta em execucao - pode causar erros no script
    set /a issues+=1
    if not defined firstFail set "firstFail=Servico Null parado, execute sc start Null no CMD admin e tente novamente"
)

set "netok="
ping -4 -n 1 internetdownloadmanager.com >nul 2>&1 && set "netok=ping"
if not defined netok (
    for /f "delims=" %%a in ('powershell -NoProfile -Command "(Test-NetConnection internetdownloadmanager.com -Port 80 -WarningAction SilentlyContinue).TcpTestSucceeded" 2^>nul') do set "netok=%%a"
)
if /i "!netok!"=="True" (
    echo [OK] Conexao com internetdownloadmanager.com disponivel
) else if /i "!netok!"=="ping" (
    echo [OK] Rede alcanca internetdownloadmanager.com
) else (
    echo [x] Nao foi possivel conectar a internetdownloadmanager.com - verifique rede/proxy/VPN; nao afeta ativacao local
    set /a issues+=1
    if not defined firstFail set "firstFail=Nao foi possivel conectar a internetdownloadmanager.com, veja README Perguntas Frequentes Q5"
)

chcp 1252 >nul 2>&1
set "cpok="
chcp | find "1252"  >nul 2>&1 && set "cpok=ok"
if defined cpok (
    echo [OK] Pagina de codigo 1252 ativa - Windows-1252
) else (
    echo [x] Pagina de codigo nao e 1252 - execute chcp 1252 e tente novamente
    set /a issues+=1
    if not defined firstFail set "firstFail=Pagina de codigo nao e 1252, execute chcp 1252 e tente novamente, veja README Q4"
)

set "wmiok="
for /f "delims=" %%a in ('powershell -NoProfile -Command "try{$null=Get-CimInstance Win32_OperatingSystem -ErrorAction Stop;Write-Output 1}catch{Write-Output 0}" 2^>nul') do if "%%a"=="1" set "wmiok=ok"
if not defined wmiok wmic path Win32_OperatingSystem get Caption /value >nul 2>&1 && set "wmiok=ok"
if defined wmiok (
    echo [OK] WMI/CIM disponivel
) else (
    echo [x] WMI/CIM indisponivel - leitura de info do sistema limitada; geralmente nao afeta ativacao
    set /a issues+=1
    if not defined firstFail set "firstFail=WMI/CIM indisponivel, verifique se o servico Windows Management Instrumentation esta ativo"
)

set "idmPath="
for /f "skip=2 tokens=3*" %%a in ('reg query "HKLM\SOFTWARE\Internet Download Manager" /v InstallFolder 2^>nul') do set "idmPath=%%a %%b"
if not defined idmPath (
    for /f "skip=2 tokens=3*" %%a in ('reg query "HKLM\SOFTWARE\WOW6432Node\Internet Download Manager" /v InstallFolder 2^>nul') do set "idmPath=%%a %%b"
)
if not defined idmPath (
    set "IDManPath="
    for /f "tokens=2*" %%a in ('reg query "HKCU\Software\DownloadManager" /v ExePath 2^>nul') do set "IDManPath=%%b"
    if defined IDManPath if exist "!IDManPath!" (
        for %%i in ("!IDManPath!") do set "idmPath=%%~dpi"
        if "!idmPath:~-1!"=="\" set "idmPath=!idmPath:~0,-1!"
    )
)
if not defined idmPath (
    if exist "%ProgramFiles(x86)%\Internet Download Manager\IDMan.exe" set "idmPath=%ProgramFiles(x86)%\Internet Download Manager"
    if not defined idmPath if exist "%ProgramFiles%\Internet Download Manager\IDMan.exe" set "idmPath=%ProgramFiles%\Internet Download Manager"
)
if defined idmPath (
    if exist "!idmPath!\IDMan.exe" (
        echo [OK] Caminho de instalacao do IDM encontrado: !idmPath!
    ) else (
        echo [x] Caminho do IDM no registro e invalido: !idmPath!
        set /a issues+=1
        if not defined firstFail set "firstFail=Caminho do IDM invalido, reinstale o IDM, veja README Q2"
    )
) else (
    echo [x] Caminho de instalacao do IDM nao encontrado no registro
    set /a issues+=1
    if not defined firstFail set "firstFail=IDM nao instalado, instale o IDM primeiro, veja README Q2"
)

set "writeTest=%~dp0.__ias_write_test.tmp"
(echo test)> "!writeTest!" 2>nul
if exist "!writeTest!" (
    del /f /q "!writeTest!" >nul 2>&1
    echo [OK] Diretorio do script com permissao de escrita
) else (
    echo [x] Diretorio do script sem permissao de escrita - mova para fora de Arquivos de Programas
    set /a issues+=1
    if not defined firstFail set "firstFail=Diretorio sem permissao de escrita, mova para fora de Arquivos de Programas e tente novamente"
)

echo:
echo ------------------------------------------
if !issues! GTR 0 (
    echo [ATENCAO] Detectados !issues! problemas que podem afetar a ativacao, o primeiro e:
    echo        !firstFail!
    echo        Para diagnostico detalhado, consulte a secao "Perguntas Frequentes" do README.md.
    echo:
    choice /C SN /N /M "Deseja continuar para o menu de ativacao mesmo assim?  [S]Continuar  [N]Sair "
    if errorlevel 2 goto :abort
    echo:
) else (
    echo [OK] Todas as verificacoes passaram, abrindo menu de ativacao...
    echo:
)

echo [RECOMENDADO] No menu, selecione [2] Ativar (uso imediato, sem conta/periodo de teste);
echo        Se apos ativar o IDM ainda mostrar nao registrado, selecione [1] Congelar.
echo:

::====================== Abrir menu IAS de ativacao ======================
::  Sem parametros = mostra menu ([1]Congelar  [2]Ativar  [3]Redefinir)
::  Usuarios avancados podem usar /act /frz /res para execucao direta
call "%IAS%" %*
set "ret=%errorlevel%"
endlocal & exit /b %ret%

:abort
echo Cancelado.
endlocal & exit /b 1
