@echo off
cls

setlocal DisableDelayedExpansion
set "batchPath=%~0"
setlocal EnableDelayedExpansion

:: File to write to
set dummy=%1
set mode=%2
set myfile=%3
set newcontent=%4
set sudo=%5
shift
shift
shift
shift
shift

if '%sudo%' == 'uac' goto checkPrivileges
if '%dummy%' == 'ELEV' goto gotPrivileges

:: Use runas or something alike to elevate priviliges, but
:: first parse parameter for runas
:: Windows cmd.exe is very clumsy to use ;(
set params=%1
:loop
shift
if [%1]==[] goto afterloop
set params=%params% %1
goto loop

:afterloop

:: Use runas or so to elevate rights
echo.
echo ***************************************
echo Calling %sudo% for Privilege Escalation
echo ***************************************
if '%mode%' == 'write' (
    %sudo% %params% "cmd.exe /c type %newcontent% >%myfile%"
    ) else (
    %sudo% %params% "cmd.exe /c type %myfile% >%newcontent%"
    )
goto end

:: Use UAC to elevate rights, idea taken from:
:: http://stackoverflow.com/questions/7044985/how-can-i-auto-elevate-my-batch-file-so-that-it-requests-from-uac-admin-rights
:checkPrivileges
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' (goto gotPrivileges) else (goto getPrivileges)

:getPrivileges
echo.
echo **************************************
echo Invoking UAC for Privilege Escalation 
echo **************************************

set vbs="%temp%\GetPrivileges.vbs"
echo Set UAC = CreateObject^("Shell.Application"^) > %vbs%
echo UAC.ShellExecute "!batchPath!", "ELEV !mode! "!myfile!" "!newcontent!""   , "", "runas", 1 >> %vbs%
%vbs%
:: Delete dynamic VBScript
if exist %vbs% del %vbs%
exit /B 

:gotPrivileges
::setlocal & pushd .
if '%mode%' == 'write' (
    type %newcontent% > %myfile%
) else (
    type %myfile% > %newcontent%
)

if not '%errorlevel%' == 0 echo "An error occured"

:end
