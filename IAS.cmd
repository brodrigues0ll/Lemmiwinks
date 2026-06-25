@set iasver=1.3.7
@setlocal DisableDelayedExpansion
@echo off

::  Forcando pagina de codigo para 1252 (Windows-1252)
chcp 1252 >nul 2>&1


::============================================================================
::
::   IDM Script de Ativacao (IAS) - Versao PT-BR
::
::   Repositorio: https://github.com/SEU_USUARIO/IDM-Activation-Script-PTBR
::   Problemas:   https://github.com/SEU_USUARIO/IDM-Activation-Script-PTBR/issues
::   Licenca    : GPL-3.0 (veja o arquivo LICENSE na raiz do repositorio)
::
::   ----- Navegacao do codigo (para manutencao futura) -----
::   Linhas 01-040  : Metainformacoes, definicao da pagina de codigo, switches padrao
::   Linhas 040-110 : Configuracao do PATH, reentrada Sysnative / SysArm32, analise de parametros (/act /frz /res /silent /log)
::   Linhas 110-150 : Validacao do modo silencioso, deteccao do servico Null, inicializacao do log
::   Linhas 150-400 : Deteccao de ambiente (permissoes de admin, caminho de instalacao do IDM, chaves de registro CLSID, conectividade de rede)
::   Linhas 400-600 : Menu principal (Congelar / Ativar / Redefinir / Baixar / Ajuda), distribuicao interativa
::   Linhas 600-870 : Fluxo principal de ativacao e congelamento, backup do registro, injecao de informacoes de registro aleatorias
::   Linhas 870-1017: Fluxo de reducao, tratamento de erros, finalizacao do log, codigo de saida
::
::============================================================================



::  To activate, run the script with "/act" parameter or change 0 to 1 in below line
set _activate=0

::  To Freeze the 30 days trial period, run the script with "/frz" parameter or change 0 to 1 in below line
set _freeze=0

::  To reset the activation and trial, run the script with "/res" parameter or change 0 to 1 in below line
set _reset=0

::  If value is changed in above lines or parameter is used then script will run in unattended mode

::========================================================================================================================================

::  Set Path variable, it helps if it is misconfigured in the system

set "PATH=%SystemRoot%\System32;%SystemRoot%\System32\wbem;%SystemRoot%\System32\WindowsPowerShell\v1.0\"
if exist "%SystemRoot%\Sysnative\reg.exe" (
set "PATH=%SystemRoot%\Sysnative;%SystemRoot%\Sysnative\wbem;%SystemRoot%\Sysnative\WindowsPowerShell\v1.0\;%PATH%"
)

:: Re-launch the script with x64 process if it was initiated by x86 process on x64 bit Windows
:: or with ARM64 process if it was initiated by x86/ARM32 process on ARM64 Windows

set "_cmdf=%~f0"
for %%# in (%*) do (
if /i "%%#"=="r1" set r1=1
if /i "%%#"=="r2" set r2=1
)

if exist %SystemRoot%\Sysnative\cmd.exe if not defined r1 (
setlocal EnableDelayedExpansion
start %SystemRoot%\Sysnative\cmd.exe /c ""!_cmdf!" %* r1"
exit /b
)

:: Re-launch the script with ARM32 process if it was initiated by x64 process on ARM64 Windows

if exist %SystemRoot%\SysArm32\cmd.exe if %PROCESSOR_ARCHITECTURE%==AMD64 if not defined r2 (
setlocal EnableDelayedExpansion
start %SystemRoot%\SysArm32\cmd.exe /c ""!_cmdf!" %* r2"
exit /b
)

::========================================================================================================================================

set "blank="
set "mas=ht%blank%tps%blank%://github.com/SEU_USUARIO/IDM-Activation-Script-PTBR"

set _args=
set _elev=
set _silent=0
set _log=0
set _log_enabled=0
set _unattended=0
set "log_file="
set "exit_code=0"

set _args=%*
if defined _args set _args=%_args:"=%
if defined _args (
for %%A in (%_args%) do (
if /i "%%A"=="-el"  set _elev=1
if /i "%%A"=="/res" set _reset=1
if /i "%%A"=="/frz" set _freeze=1
if /i "%%A"=="/act" set _activate=1
if /i "%%A"=="/silent" set _silent=1
if /i "%%A"=="/quiet" set _silent=1
if /i "%%A"=="/log" set _log=1
)
)

for %%A in (%_activate% %_freeze% %_reset%) do (if "%%A"=="1" set _unattended=1)
if %_silent%==1 set _unattended=1
if %_silent%==1 set _log=1

set "log_dir=%SystemRoot%\Temp"
if %_log%==1 (
if not exist "%log_dir%" md "%log_dir%"
set "_logstamp=%date%_%time%"
set "_logstamp=%_logstamp::=%"
set "_logstamp=%_logstamp: =0%"
set "_logstamp=%_logstamp:.=%"
set "_logstamp=%_logstamp:,=%"
set "_logstamp=%_logstamp:/=%"
set "_logstamp=%_logstamp:\=%"
set "log_file=%log_dir%\IAS-%_logstamp%.log"
set _log_enabled=1
call :log "IAS %iasver% iniciado, parametros: %_args%"
call :log "Arquivo de log: %log_file%"
if %_silent%==0 echo Arquivo de log: %log_file%
)

if %_silent%==1 if %_activate%==0 if %_freeze%==0 if %_reset%==0 (
call :set_exit 2 "Modo silencioso sem parametro de acao, saindo"
goto done2
)

::  Check if Null service is working, it's important for the batch script

sc query Null | find /i "RUNNING"
if %errorlevel% NEQ 0 (
call :log "Aviso: Servico Null nao esta em execucao, pode causar erros no script"
echo:
echo Servico Null nao esta em execucao, o script pode apresentar erros...
echo:
echo:
echo Ajuda - %mas%
echo:
echo:
if %_silent%==1 (ping 127.0.0.1 -n 2 >nul) else ping 127.0.0.1 -n 10
)
cls
chcp 1252 >nul 2>&1

::  Check LF line ending

pushd "%~dp0"
>nul findstr /v "$" "%~nx0" && (
echo:
echo Erro: O script contem terminacoes de linha LF ou falta linha vazia no final.
echo:
call :set_exit 2 "Erro: Detectadas terminacoes de linha LF ou falta linha vazia no final"
if %_silent%==1 (ping 127.0.0.1 -n 2 >nul) else ping 127.0.0.1 -n 6 >nul
popd
exit /b %exit_code%
)
popd

::========================================================================================================================================

cls
chcp 1252 >nul 2>&1
color 07
title  IDM Script de Ativacao %iasver%

::========================================================================================================================================

set "nul1=1>nul"
set "nul2=2>nul"
set "nul6=2^>nul"
set "nul=>nul 2>&1"

set psc=powershell.exe
set winbuild=1
for /f "tokens=6 delims=[]. " %%G in ('ver') do set winbuild=%%G

set _NCS=1
if %winbuild% LSS 10586 set _NCS=0
if %winbuild% GEQ 10586 reg query "HKCU\Console" /v ForceV2 %nul2% | find /i "0x0" %nul1% && (set _NCS=0)

if %_NCS% EQU 1 (
for /F %%a in ('echo prompt $E ^| cmd') do set "esc=%%a"
set     "Red="41;97m""
set    "Gray="100;97m""
set   "Green="42;97m""
set    "Blue="44;97m""
set  "_White="40;37m""
set  "_Green="40;92m""
set "_Yellow="40;93m""
) else (
set     "Red="Red" "white""
set    "Gray="Darkgray" "white""
set   "Green="DarkGreen" "white""
set    "Blue="Blue" "white""
set  "_White="Black" "Gray""
set  "_Green="Black" "Green""
set "_Yellow="Black" "Yellow""
)

set "nceline=echo: &echo ==== ERRO ==== &echo:"
set "eline=echo: &call :_color %Red% "==== ERRO ====" &echo:"
set "line=___________________________________________________________________________________________________"
set "_buf={$W=$Host.UI.RawUI.WindowSize;$B=$Host.UI.RawUI.BufferSize;$W.Height=34;$B.Height=300;$Host.UI.RawUI.WindowSize=$W;$Host.UI.RawUI.BufferSize=$B;}"

::========================================================================================================================================

if %winbuild% LSS 7600 (
%nceline%
echo Versao do sistema operacional nao suportada detectada [%winbuild%].
echo Este script suporta Windows 7/8/8.1/10/11 e versoes posteriores.
call :set_exit 2 "Versao do sistema operacional nao suportada [%winbuild%]"
goto done2
)

for %%# in (powershell.exe) do @if "%%~$PATH:#"=="" (
%nceline%
echo powershell.exe nao encontrado no sistema.
call :set_exit 2 "powershell.exe nao encontrado no sistema"
goto done2
)

::========================================================================================================================================

::  Fix for the special characters limitation in path name

set "_work=%~dp0"
if "%_work:~-1%"=="\" set "_work=%_work:~0,-1%"

set "_batf=%~f0"
set "_batp=%_batf:'=''%"

set _PSarg="""%~f0""" -el %_args%
set _PSarg=%_PSarg:'=''%

set "_appdata=%appdata%"
set "_ttemp=%userprofile%\AppData\Local\Temp"

setlocal EnableDelayedExpansion

::========================================================================================================================================

echo "!_batf!" | find /i "!_ttemp!" %nul1% && (
if /i not "!_work!"=="!_ttemp!" (
%eline%
echo O script esta sendo executado a partir de uma pasta temporaria.
echo Voce pode estar executando o script a partir de um visualizador de arquivos compactados.
echo:
echo Extraia o arquivo compactado e execute o script a partir da pasta extraida.
call :set_exit 2 "Script sendo executado a partir de pasta temporaria, bloqueado"
goto done2
)
)

::========================================================================================================================================

::  Check PowerShell

REM :PowerShellTest: $ExecutionContext.SessionState.LanguageMode :PowerShellTest:

%psc% "$f=[io.file]::ReadAllText('!_batp!') -split ':PowerShellTest:\s*';iex ($f[1])" | find /i "FullLanguage" %nul1% || (
%eline%
%psc% $ExecutionContext.SessionState.LanguageMode
echo:
echo O PowerShell nao esta funcionando corretamente, processo bloqueado...
echo Sua organizacao pode ter desabilitado o PowerShell para prevenir estas situacoes.
echo:
echo Acesse a pagina de ajuda: %mas%
call :set_exit 2 "Execucao do PowerShell bloqueada"
goto done2
)

::========================================================================================================================================

::  Elevate script as admin and pass arguments and preventing loop

%nul1% fltmc || (
if not defined _elev %psc% "start cmd.exe -arg '/c \"!_PSarg!\"' -verb runas" && exit /b
%eline%
echo Este script requer permissoes de administrador.
echo Clique com o botao direito neste script e selecione "Executar como administrador".
call :set_exit 2 "Permissoes de administrador ausentes"
goto done2
)

::========================================================================================================================================

::  Disable QuickEdit and launch from conhost.exe to avoid Terminal app

set quedit=
set terminal=

if %_unattended%==1 (
set quedit=1
set terminal=1
)

for %%# in (%_args%) do (if /i "%%#"=="-qedit" set quedit=1)

if %winbuild% LSS 10586 (
reg query HKCU\Console /v QuickEdit %nul2% | find /i "0x0" %nul1% && set quedit=1
)

if %winbuild% GEQ 17763 (
set "launchcmd=start conhost.exe %psc%"
) else (
set "launchcmd=%psc%"
)

set "d1=$t=[AppDomain]::CurrentDomain.DefineDynamicAssembly(4, 1).DefineDynamicModule(2, $False).DefineType(0);"
set "d2=$t.DefinePInvokeMethod('GetStdHandle', 'kernel32.dll', 22, 1, [IntPtr], @([Int32]), 1, 3).SetImplementationFlags(128);"
set "d3=$t.DefinePInvokeMethod('SetConsoleMode', 'kernel32.dll', 22, 1, [Boolean], @([IntPtr], [Int32]), 1, 3).SetImplementationFlags(128);"
set "d4=$k=$t.CreateType(); $b=$k::SetConsoleMode($k::GetStdHandle(-10), 0x0080);"

if defined quedit goto :skipQE
%launchcmd% "%d1% %d2% %d3% %d4% & cmd.exe '/c' '!_PSarg! -qedit'" &exit /b
:skipQE

::========================================================================================================================================

::  Check for updates

set old=
if not %_unattended%==1 (
echo ________________________________________________
echo Versao atual: %iasver% - versao local do repositorio
echo Para verificar atualizacoes, acesse a pagina do projeto: %mas%
echo ________________________________________________
echo:
)

::========================================================================================================================================

cls
chcp 1252 >nul 2>&1
title  IDM Script de Ativacao %iasver%

echo:
echo Inicializando...

::  Check WMI

%psc% "Get-WmiObject -Class Win32_ComputerSystem | Select-Object -Property CreationClassName" %nul2% | find /i "computersystem" %nul1% || (
%eline%
%psc% "Get-WmiObject -Class Win32_ComputerSystem | Select-Object -Property CreationClassName"
echo:
echo WMI nao esta funcionando corretamente, processo bloqueado...
echo:
echo Acesse a pagina de ajuda: %mas%
call :set_exit 2 "Consulta WMI falhou"
goto done2
)

::  Check user account SID

set _sid=
for /f "delims=" %%a in ('%psc% "([System.Security.Principal.NTAccount](Get-WmiObject -Class Win32_ComputerSystem).UserName).Translate([System.Security.Principal.SecurityIdentifier]).Value" %nul6%') do (set _sid=%%a)

reg query HKU\%_sid%\Software %nul% || (
for /f "delims=" %%a in ('%psc% "$explorerProc = Get-Process -Name explorer | Where-Object {$_.SessionId -eq (Get-Process -Id $pid).SessionId} | Select-Object -First 1; $sid = (gwmi -Query ('Select * From Win32_Process Where ProcessID=' + $explorerProc.Id)).GetOwnerSid().Sid; $sid" %nul6%') do (set _sid=%%a)
)

reg query HKU\%_sid%\Software %nul% || (
%eline%
echo:
echo [%_sid%]
echo SID da conta de usuario nao encontrado, processo bloqueado...
echo:
echo Acesse a pagina de ajuda: %mas%
call :set_exit 2 "Nao foi possivel obter o SID do usuario atual"
goto done2
)

::========================================================================================================================================

::  Check if the current user SID is syncing with the HKCU entries

%nul% reg delete HKCU\IAS_TEST /f
%nul% reg delete HKU\%_sid%\IAS_TEST /f

set HKCUsync=$null
%nul% reg add HKCU\IAS_TEST
%nul% reg query HKU\%_sid%\IAS_TEST && (
set HKCUsync=1
)

%nul% reg delete HKCU\IAS_TEST /f
%nul% reg delete HKU\%_sid%\IAS_TEST /f

::  Below code also works for ARM64 Windows 10 (including x64 bit emulation)

for /f "skip=2 tokens=2*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v PROCESSOR_ARCHITECTURE') do set arch=%%b
if /i not "%arch%"=="x86" set arch=x64

if "%arch%"=="x86" (
set "CLSID=HKCU\Software\Classes\CLSID"
set "CLSID2=HKU\%_sid%\Software\Classes\CLSID"
set "HKLM=HKLM\Software\Internet Download Manager"
) else (
set "CLSID=HKCU\Software\Classes\Wow6432Node\CLSID"
set "CLSID2=HKU\%_sid%\Software\Classes\Wow6432Node\CLSID"
set "HKLM=HKLM\SOFTWARE\Wow6432Node\Internet Download Manager"
)

for /f "tokens=2*" %%a in ('reg query "HKU\%_sid%\Software\DownloadManager" /v ExePath %nul6%') do call set "IDMan=%%b"

if not exist "%IDMan%" (
if %arch%==x64 set "IDMan=%ProgramFiles(x86)%\Internet Download Manager\IDMan.exe"
if %arch%==x86 set "IDMan=%ProgramFiles%\Internet Download Manager\IDMan.exe"
)

if not exist %SystemRoot%\Temp md %SystemRoot%\Temp
set "idmcheck=tasklist /fi "imagename eq idman.exe" | findstr /i "idman.exe" %nul1%"

::  Check CLSID registry access

%nul% reg add %CLSID2%\IAS_TEST
%nul% reg query %CLSID2%\IAS_TEST || (
%eline%
echo Nao foi possivel gravar em %CLSID2%
echo:
echo Acesse a pagina de ajuda: %mas%
call :set_exit 2 "Nao foi possivel gravar em %CLSID2%"
goto done2
)

%nul% reg delete %CLSID2%\IAS_TEST /f

::========================================================================================================================================

if %_reset%==1 goto :_reset
if %_activate%==1 (set frz=0&goto :_activate)
if %_freeze%==1 (set frz=1&goto :_activate)

:MainMenu

cls
chcp 1252 >nul 2>&1
title  IDM Script de Ativacao %iasver%
if not defined terminal mode 75, 28

echo:
echo:
echo:
echo:
echo:
echo:                Este script suporta a versao mais recente do IDM.
echo:            ___________________________________________________
echo:
echo:               [1] Ativar (Congelar)
echo:               [2] Ativar
echo:               [3] Redefinir Ativacao/Periodo de Teste
echo:               _____________________________________________
echo:
echo:               [4] Baixar IDM
echo:               [5] Ajuda
echo:               [0] Sair
echo:            ___________________________________________________
echo:
call :_color2 %_White% "             " %_Green% "Digite sua opcao no teclado [1,2,3,4,5,0]"
choice /C:123450 /N
set _erl=%errorlevel%

if %_erl%==6 exit /b
if %_erl%==5 start %mas% & goto MainMenu
if %_erl%==4 start https://www.internetdownloadmanager.com/download.html & goto MainMenu
if %_erl%==3 goto _reset
if %_erl%==2 (set frz=0&goto :_activate)
if %_erl%==1 (set frz=1&goto :_activate)
goto :MainMenu

::========================================================================================================================================

:_reset

call :log "Iniciando fluxo de reducao"
cls
chcp 1252 >nul 2>&1
if not %HKCUsync%==1 (
if not defined terminal mode 153, 35
) else (
if not defined terminal mode 113, 35
)
if not defined terminal %psc% "&%_buf%" %nul%

echo:
%idmcheck% && taskkill /f /im idman.exe

set _time=
for /f %%a in ('%psc% "(Get-Date).ToString('yyyyMMdd-HHmmssfff')"') do set _time=%%a

echo:
echo Fazendo backup do registro CLSID em %SystemRoot%\Temp

reg export %CLSID% "%SystemRoot%\Temp\_Backup_HKCU_CLSID_%_time%.reg"
if not %HKCUsync%==1 reg export %CLSID2% "%SystemRoot%\Temp\_Backup_HKU-%_sid%_CLSID_%_time%.reg"
call :log "Backup do registro salvo: _Backup_HKCU_CLSID_%_time%.reg"
if not %HKCUsync%==1 call :log "Backup do registro salvo: _Backup_HKU-%_sid%_CLSID_%_time%.reg"

call :delete_queue
%psc% "$sid = '%_sid%'; $HKCUsync = %HKCUsync%; $lockKey = $null; $deleteKey = 1; $f=[io.file]::ReadAllText('!_batp!') -split ':regscan\:.*';iex ($f[1])"

call :add_key

echo:
echo %line%
echo:
call :_color %Green% "Funcao de reducao do IDM concluida."

goto done

:delete_queue

echo:
echo Excluindo chaves de registro do IDM...
echo:
call :log "Iniciando exclusao das chaves de registro do IDM"

for %%# in (
""HKCU\Software\DownloadManager" "/v" "FName""
""HKCU\Software\DownloadManager" "/v" "LName""
""HKCU\Software\DownloadManager" "/v" "Email""
""HKCU\Software\DownloadManager" "/v" "Serial""
""HKCU\Software\DownloadManager" "/v" "scansk""
""HKCU\Software\DownloadManager" "/v" "tvfrdt""
""HKCU\Software\DownloadManager" "/v" "radxcnt""
""HKCU\Software\DownloadManager" "/v" "LstCheck""
""HKCU\Software\DownloadManager" "/v" "ptrk_scdt""
""HKCU\Software\DownloadManager" "/v" "LastCheckQU""
"%HKLM%"
) do for /f "tokens=* delims=" %%A in ("%%~#") do (
set "reg="%%~A"" &reg query !reg! %nul% && call :del
)

if not %HKCUsync%==1 for %%# in (
""HKU\%_sid%\Software\DownloadManager" "/v" "FName""
""HKU\%_sid%\Software\DownloadManager" "/v" "LName""
""HKU\%_sid%\Software\DownloadManager" "/v" "Email""
""HKU\%_sid%\Software\DownloadManager" "/v" "Serial""
""HKU\%_sid%\Software\DownloadManager" "/v" "scansk""
""HKU\%_sid%\Software\DownloadManager" "/v" "tvfrdt""
""HKU\%_sid%\Software\DownloadManager" "/v" "radxcnt""
""HKU\%_sid%\Software\DownloadManager" "/v" "LstCheck""
""HKU\%_sid%\Software\DownloadManager" "/v" "ptrk_scdt""
""HKU\%_sid%\Software\DownloadManager" "/v" "LastCheckQU""
) do for /f "tokens=* delims=" %%A in ("%%~#") do (
set "reg="%%~A"" &reg query !reg! %nul% && call :del
)

exit /b

:del

reg delete %reg% /f %nul%

if "%errorlevel%"=="0" (
set "reg=%reg:"=%"
echo Excluido - !reg!
call :log "Excluido - !reg!"
) else (
set "reg=%reg:"=%"
call :_color2 %Red% "Falhou - !reg!"
call :set_exit 1 "Exclusao falhou - !reg!"
)

exit /b

::========================================================================================================================================

:_activate

if %frz%==1 (call :log "Iniciando fluxo de congelamento do periodo de teste") else (call :log "Iniciando fluxo de ativacao")
cls
chcp 1252 >nul 2>&1
if not %HKCUsync%==1 (
if not defined terminal mode 153, 35
) else (
if not defined terminal mode 113, 35
)
if not defined terminal %psc% "&%_buf%" %nul%

if %frz%==0 if %_unattended%==0 (
echo:
echo %line%
echo:
echo      Aviso: Em certas configuracoes, o IDM pode exibir alerta de numero de serie falso.
echo:
call :_color2 %_White% "     " %_Green% "Por favor, use a opcao de Ativacao por Congelamento."
echo %line%
echo:
choice /C:19 /N /M ">    [1] Voltar [9] Continuar : "
if !errorlevel!==1 goto :MainMenu
cls
chcp 1252 >nul 2>&1
)

echo:
if not exist "%IDMan%" (
call :_color %Red% "IDM [Internet Download Manager] nao esta instalado."
echo Voce pode baixa-lo em: https://www.internetdownloadmanager.com/download.html
call :set_exit 1 "Instalacao do IDM nao detectada"
goto done
)

:: Internet check with internetdownloadmanager.com ping and port 80 test

set _int=
for /f "delims=[] tokens=2" %%# in ('ping -n 1 internetdownloadmanager.com') do (if not [%%#]==[] set _int=1)

if not defined _int (
%psc% "$t = New-Object Net.Sockets.TcpClient;try{$t.Connect("""internetdownloadmanager.com""", 80)}catch{};$t.Connected" | findstr /i "true" %nul1% || (
call :_color %Red% "Nao foi possivel conectar a internetdownloadmanager.com, processo bloqueado..."
call :set_exit 1 "Nao foi possivel conectar a internetdownloadmanager.com"
goto done
)
call :_color %Gray% "Teste de ping para internetdownloadmanager.com falhou"
echo:
)

for /f "skip=2 tokens=2*" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName 2^>nul') do set "regwinos=%%b"
for /f "skip=2 tokens=2*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v PROCESSOR_ARCHITECTURE') do set "regarch=%%b"
for /f "tokens=6-7 delims=[]. " %%i in ('ver') do if "%%j"=="" (set fullbuild=%%i) else (set fullbuild=%%i.%%j)
for /f "tokens=2*" %%a in ('reg query "HKU\%_sid%\Software\DownloadManager" /v idmvers %nul6%') do set "IDMver=%%b"

echo Informacoes detectadas - [%regwinos% ^| %fullbuild% ^| %regarch% ^| IDM: %IDMver%]
call :log "Informacoes detectadas - [%regwinos% | %fullbuild% | %regarch% | IDM: %IDMver%]"

%idmcheck% && (echo: & taskkill /f /im idman.exe)

set _time=
for /f %%a in ('%psc% "(Get-Date).ToString('yyyyMMdd-HHmmssfff')"') do set _time=%%a

echo:
echo Fazendo backup do registro CLSID em %SystemRoot%\Temp

reg export %CLSID% "%SystemRoot%\Temp\_Backup_HKCU_CLSID_%_time%.reg"
if not %HKCUsync%==1 reg export %CLSID2% "%SystemRoot%\Temp\_Backup_HKU-%_sid%_CLSID_%_time%.reg"

call :delete_queue
call :add_key

%psc% "$sid = '%_sid%'; $HKCUsync = %HKCUsync%; $lockKey = 1; $deleteKey = $null; $toggle = 1; $f=[io.file]::ReadAllText('!_batp!') -split ':regscan\:.*';iex ($f[1])"

if %frz%==0 call :register_IDM

call :download_files
if not defined _fileexist (
%eline%
echo Erro: Nao foi possivel baixar arquivo via IDM.
echo:
echo Ajuda: %mas%
call :set_exit 1 "Teste de download do IDM falhou"
goto :done
)

%psc% "$sid = '%_sid%'; $HKCUsync = %HKCUsync%; $lockKey = 1; $deleteKey = $null; $f=[io.file]::ReadAllText('!_batp!') -split ':regscan\:.*';iex ($f[1])"

echo:
echo %line%
echo:
if %frz%==0 (
call :_color %Green% "Funcao de ativacao do IDM concluida."
echo:
call :_color %Gray% "Se voce encontrar falso positivo de numero de serie, use a opcao de Ativacao por Congelamento."
) else (
call :_color %Green% "O periodo de teste de 30 dias do IDM foi congelado com sucesso."
echo:
call :_color %Gray% "Se o IDM exibir popup de registro, reinstale o IDM."
)

::========================================================================================================================================

:done

echo %line%
echo:
echo:
call :log "Fluxo concluido, codigo de saida %exit_code%"
if %_unattended%==1 (
if %_silent%==1 exit /b %exit_code%
timeout /t 2 & exit /b %exit_code%
)

if defined terminal (
call :_color %_Yellow% "Pressione 0 para voltar..."
choice /c 0 /n
) else (
call :_color %_Yellow% "Pressione qualquer tecla para voltar..."
pause %nul1%
)
goto MainMenu

:done2

call :log "Fluxo concluido, codigo de saida %exit_code%"
if %_unattended%==1 (
if %_silent%==1 exit /b %exit_code%
timeout /t 2 & exit /b %exit_code%
)

if defined terminal (
echo Pressione 0 para sair...
choice /c 0 /n
) else (
	echo Pressione qualquer tecla para sair...
	pause %nul1%
	)
	exit /b %exit_code%

::========================================================================================================================================

:_rcont

reg add %reg% %nul%
call :add
exit /b

:register_IDM

echo:
echo Aplicando informacoes de registro...
echo:

set /a fname = %random% %% 9999 + 1000
set /a lname = %random% %% 9999 + 1000
set email=%fname%.%lname%@tonec.com

for /f "delims=" %%a in ('%psc% "$key = -join ((Get-Random -Count  20 -InputObject ([char[]]('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'))));$key = ($key.Substring(0,  5) + '-' + $key.Substring(5,  5) + '-' + $key.Substring(10,  5) + '-' + $key.Substring(15,  5) + $key.Substring(20));Write-Output $key" %nul6%') do (set key=%%a)

set "reg=HKCU\SOFTWARE\DownloadManager /v FName /t REG_SZ /d "%fname%"" & call :_rcont
set "reg=HKCU\SOFTWARE\DownloadManager /v LName /t REG_SZ /d "%lname%"" & call :_rcont
set "reg=HKCU\SOFTWARE\DownloadManager /v Email /t REG_SZ /d "%email%"" & call :_rcont
set "reg=HKCU\SOFTWARE\DownloadManager /v Serial /t REG_SZ /d "%key%"" & call :_rcont

if not %HKCUsync%==1 (
set "reg=HKU\%_sid%\SOFTWARE\DownloadManager /v FName /t REG_SZ /d "%fname%"" & call :_rcont
set "reg=HKU\%_sid%\SOFTWARE\DownloadManager /v LName /t REG_SZ /d "%lname%"" & call :_rcont
set "reg=HKU\%_sid%\SOFTWARE\DownloadManager /v Email /t REG_SZ /d "%email%"" & call :_rcont
set "reg=HKU\%_sid%\SOFTWARE\DownloadManager /v Serial /t REG_SZ /d "%key%"" & call :_rcont
)
exit /b

:download_files

echo:
echo Baixando arquivos de teste e bloqueando chaves de registro...
echo:
call :log "Iniciando download dos arquivos de teste"

set "file=%SystemRoot%\Temp\temp.png"
set _fileexist=

set link=https://www.internetdownloadmanager.com/images/idm_box_min.png
call :download
set link=https://www.internetdownloadmanager.com/register/IDMlib/images/idman_logos.png
call :download
set link=https://www.internetdownloadmanager.com/pictures/idm_about.png
call :download

echo:
timeout /t 3 %nul1%
%idmcheck% && taskkill /f /im idman.exe
if exist "%file%" del /f /q "%file%"
if defined _fileexist (call :log "Download dos arquivos de teste bem-sucedido") else (call :log "Download dos arquivos de teste falhou")
exit /b

:download

set /a attempt=0
set "current_link=%link%"
if exist "%file%" del /f /q "%file%"
start "" /B "%IDMan%" /n /d "%link%" /p "%SystemRoot%\Temp" /f temp.png

:check_file

timeout /t 1 %nul1%
set /a attempt+=1
if exist "%file%" (set _fileexist=1&call :log "Download bem-sucedido: %current_link%"&exit /b)
if %attempt% GEQ 20 (call :log "Download falhou: %current_link%"&exit /b)
goto :Check_file

::========================================================================================================================================

:add_key

echo:
echo Adicionando chaves de registro...
echo:
call :log "Iniciando adicao das chaves de registro"

set "reg="%HKLM%" /v "AdvIntDriverEnabled2""

reg add %reg% /t REG_DWORD /d "1" /f %nul%

:add

if "%errorlevel%"=="0" (
set "reg=%reg:"=%"
echo Adicionado - !reg!
call :log "Adicionado - !reg!"
) else (
set "reg=%reg:"=%"
call :_color2 %Red% "Falhou - !reg!"
call :set_exit 1 "Adicao falhou - !reg!"
)
exit /b

::========================================================================================================================================

:regscan:
$finalValues = @()

$arch = (Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment').PROCESSOR_ARCHITECTURE
if ($arch -eq "x86") {
  $regPaths = @("HKCU:\Software\Classes\CLSID", "Registry::HKEY_USERS\$sid\Software\Classes\CLSID")
} else {
  $regPaths = @("HKCU:\Software\Classes\WOW6432Node\CLSID", "Registry::HKEY_USERS\$sid\Software\Classes\Wow6432Node\CLSID")
}

foreach ($regPath in $regPaths) {
    if (($regPath -match "HKEY_USERS") -and ($HKCUsync -ne $null)) {
        continue
    }

	Write-Host
	Write-Host "Verificando chaves de registro IDM CLSID em $regPath"
	Write-Host

    $subKeys = Get-ChildItem -Path $regPath -ErrorAction SilentlyContinue -ErrorVariable lockedKeys | Where-Object { $_.PSChildName -match '^\{[A-F0-9]{8}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{12}\}$' }

    foreach ($lockedKey in $lockedKeys) {
        $leafValue = Split-Path -Path $lockedKey.TargetObject -Leaf
        $finalValues += $leafValue
        Write-Output "$leafValue - Ignorado por estar bloqueado"
    }

    if ($subKeys -eq $null) {
	continue
	}

	$subKeysToExclude = "LocalServer32", "InProcServer32", "InProcHandler32"

    $filteredKeys = $subKeys | Where-Object { !($_.GetSubKeyNames() | Where-Object { $subKeysToExclude -contains $_ }) }

    foreach ($key in $filteredKeys) {
        $fullPath = $key.PSPath
        $keyValues = Get-ItemProperty -Path $fullPath -ErrorAction SilentlyContinue
        $defaultValue = $keyValues.PSObject.Properties | Where-Object { $_.Name -eq '(default)' } | Select-Object -ExpandProperty Value

        if (($defaultValue -match "^\d+$") -and ($key.SubKeyCount -eq 0)) {
            $finalValues += $($key.PSChildName)
            Write-Output "$($key.PSChildName) - Numero encontrado no valor padrao (somente numeros)"
            continue
        }
        if (($defaultValue -match "\+|=") -and ($key.SubKeyCount -eq 0)) {
            $finalValues += $($key.PSChildName)
            Write-Output "$($key.PSChildName) - + ou = encontrado no valor padrao (somente numeros)"
            continue
        }
        $versionValue = Get-ItemProperty -Path "$fullPath\Version" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty '(default)' -ErrorAction SilentlyContinue
        if (($versionValue -match "^\d+$") -and ($key.SubKeyCount -eq 1)) {
            $finalValues += $($key.PSChildName)
            Write-Output "$($key.PSChildName) - Numero encontrado em \Version (uma subchave)"
            continue
        }
        $keyValues.PSObject.Properties | ForEach-Object {
            if ($_.Name -match "MData|Model|scansk|Therad") {
                $finalValues += $($key.PSChildName)
                Write-Output "$($key.PSChildName) - MData Model scansk Therad encontrado"
                continue
            }
        }
        if (($key.ValueCount -eq 0) -and ($key.SubKeyCount -eq 0)) {
            $finalValues += $($key.PSChildName)
            Write-Output "$($key.PSChildName) - Completamente vazio"
            continue
        }
    }
}

$finalValues = @($finalValues | Select-Object -Unique)

if ($finalValues -ne $null) {
    Write-Host
    if ($lockKey -ne $null) {
        Write-Host "Bloqueando chaves de registro IDM CLSID..."
    }
    if ($deleteKey -ne $null) {
        Write-Host "Excluindo chaves de registro IDM CLSID..."
    }
    Write-Host
} else {
    Write-Host "Chaves de registro IDM CLSID nao encontradas"
	Exit
}

if (($finalValues.Count -gt 20) -and ($toggle -ne $null)) {
	$lockKey = $null
	$deleteKey = 1
    Write-Host "Mais de 20 chaves IDM encontradas, excluindo em vez de bloquear..."
	Write-Host
}

function Take-Permissions {
    param($rootKey, $regKey)
    $AssemblyBuilder = [AppDomain]::CurrentDomain.DefineDynamicAssembly(4, 1)
    $ModuleBuilder = $AssemblyBuilder.DefineDynamicModule(2, $False)
    $TypeBuilder = $ModuleBuilder.DefineType(0)

    $TypeBuilder.DefinePInvokeMethod('RtlAdjustPrivilege', 'ntdll.dll', 'Public, Static', 1, [int], @([int], [bool], [bool], [bool].MakeByRefType()), 1, 3) | Out-Null
    9,17,18 | ForEach-Object { $TypeBuilder.CreateType()::RtlAdjustPrivilege($_, $true, $false, [ref]$false) | Out-Null }

    $SID = New-Object System.Security.Principal.SecurityIdentifier('S-1-5-32-544')
    $IDN = ($SID.Translate([System.Security.Principal.NTAccount])).Value
    $Admin = New-Object System.Security.Principal.NTAccount($IDN)

    $everyone = New-Object System.Security.Principal.SecurityIdentifier('S-1-1-0')
    $none = New-Object System.Security.Principal.SecurityIdentifier('S-1-0-0')

    $key = [Microsoft.Win32.Registry]::$rootKey.OpenSubKey($regkey, 'ReadWriteSubTree', 'TakeOwnership')

    $acl = New-Object System.Security.AccessControl.RegistrySecurity
    $acl.SetOwner($Admin)
    $key.SetAccessControl($acl)

    $key = $key.OpenSubKey('', 'ReadWriteSubTree', 'ChangePermissions')
    $rule = New-Object System.Security.AccessControl.RegistryAccessRule($everyone, 'FullControl', 'ContainerInherit', 'None', 'Allow')
    $acl.ResetAccessRule($rule)
    $key.SetAccessControl($acl)

    if ($lockKey -ne $null) {
        $acl = New-Object System.Security.AccessControl.RegistrySecurity
        $acl.SetOwner($none)
        $key.SetAccessControl($acl)

        $key = $key.OpenSubKey('', 'ReadWriteSubTree', 'ChangePermissions')
        $rule = New-Object System.Security.AccessControl.RegistryAccessRule($everyone, 'FullControl', 'Deny')
        $acl.ResetAccessRule($rule)
        $key.SetAccessControl($acl)
    }
}

foreach ($regPath in $regPaths) {
    if (($regPath -match "HKEY_USERS") -and ($HKCUsync -ne $null)) {
        continue
    }
    foreach ($finalValue in $finalValues) {
        $fullPath = Join-Path -Path $regPath -ChildPath $finalValue
        if ($fullPath -match 'HKCU:') {
            $rootKey = 'CurrentUser'
        } else {
            $rootKey = 'Users'
        }

        $position = $fullPath.IndexOf("\")
        $regKey = $fullPath.Substring($position + 1)

        if ($lockKey -ne $null) {
            if (-not (Test-Path -Path $fullPath -ErrorAction SilentlyContinue)) { New-Item -Path $fullPath -Force -ErrorAction SilentlyContinue | Out-Null }
            Take-Permissions $rootKey $regKey
            try {
                Remove-Item -Path $fullPath -Force -Recurse -ErrorAction Stop
                Write-Host -back 'DarkRed' -fore 'white' "Falhou - $fullPath"
            }
            catch {
                Write-Host "Bloqueado - $fullPath"
            }
        }

        if ($deleteKey -ne $null) {
            if (Test-Path -Path $fullPath) {
                Remove-Item -Path $fullPath -Force -Recurse -ErrorAction SilentlyContinue
                if (Test-Path -Path $fullPath) {
                    Take-Permissions $rootKey $regKey
                    try {
                        Remove-Item -Path $fullPath -Force -Recurse -ErrorAction Stop
                        Write-Host "Excluido - $fullPath"
                    }
                    catch {
                        Write-Host -back 'DarkRed' -fore 'white' "Falhou - $fullPath"
                    }
                }
                else {
                    Write-Host "Excluido - $fullPath"
                }
            }
        }
    }
}
:regscan:

::========================================================================================================================================

:set_exit
if "%~1"=="" exit /b
if "%exit_code%"=="0" set "exit_code=%~1"
if not "%~2"=="" call :log %~2
exit /b

:log
if not "%_log_enabled%"=="1" exit /b
set "_log_now=%date% %time%"
>>"%log_file%" echo [%_log_now%] %*
exit /b

::========================================================================================================================================

:_color

if %_NCS% EQU 1 (
echo %esc%[%~1%~2%esc%[0m
) else (
echo %~3
)
exit /b

:_color2

if %_NCS% EQU 1 (
echo %esc%[%~1%~2%esc%[%~3%~4%esc%[0m
) else (
echo %~3%~6
)
exit /b

::========================================================================================================================================
:: Leave empty line below

