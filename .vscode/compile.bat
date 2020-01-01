@echo off

SET LAZBUILD=C:\lazarus\lazbuild.exe
SET PROJECT=TouchFileDate.lpi
 

%LAZBUILD% %PROJECT% --verbose 

if %ERRORLEVEL% NEQ 0 GOTO END

echo. 

:END