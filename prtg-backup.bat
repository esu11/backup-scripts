@ECHO OFF

REM Set variables
SET DOW=%date:~0,3%
SET MONTH=%date:~4,2%
SET DAY=%date:~7,2%
SET YEAR=%date:~10,4%
SET ISODATE=%YEAR%-%MONTH%-%DAY%
SET RCLONE="C:\Program Files\rclone\rclone.exe"
FOR /F "delims=|" %%I IN ('DIR "C:\ProgramData\Paessler\PRTG Network Monitor\Configuration Auto-Backups" /B /O:D') DO SET LATESTBACKUP="C:\ProgramData\Paessler\PRTG Network Monitor\Configuration Auto-Backups\%%I"

REM Daily backup operation
%RCLONE% delete GDrive:/Latest
%RCLONE% copy %LATESTBACKUP% GDrive:/Latest

REM Weekly backup operation
IF %DOW%==Sun (goto WEEKLY) ELSE (goto MONTHLY)
:WEEKLY
%RCLONE% copy %LATESTBACKUP% GDrive:/Weekly

REM Monthly backup operation
:MONTHLY
IF %DAY%==01 (goto NEXT) ELSE (goto END)
:NEXT
%RCLONE% copy %LATESTBACKUP% GDrive:/Monthly
%RCLONE% delete GDrive:/Weekly

:END
