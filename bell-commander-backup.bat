@ECHO OFF

REM Set variables
SET DOW=%date:~0,3%
SET MONTH=%date:~4,2%
SET DAY=%date:~7,2%
SET YEAR=%date:~10,4%
SET ISODATE=%date:~10,4%-%date:~4,2%-%date:~7,2%
SET RCLONE="C:\Program Files\rclone\rclone.exe"
SET LATESTBACKUP="C:\Program Files (x86)\BellCommander"

REM Daily backup operation
%RCLONE% delete GDrive:/Latest
%RCLONE% copy %LATESTBACKUP% GDrive:/Latest

REM Weekly backup operation
IF %DOW%==Sun (goto WEEKLY) ELSE (goto MONTHLY)
:WEEKLY
%RCLONE% copy %LATESTBACKUP% GDrive:/Weekly/%date:~10,4%-%date:~4,2%-%date:~7,2%

REM Monthly backup operation
:MONTHLY
IF %DAY%==01 (goto NEXT) ELSE (goto END)
:NEXT
%RCLONE% copy %LATESTBACKUP% GDrive:/Monthly/%date:~10,4%-%date:~4,2%-%date:~7,2%
%RCLONE% delete GDrive:/Weekly

:END
