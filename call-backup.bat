@ECHO OFF

REM Place in C:\Scripts
REM Executed via Windows Task Scheduler

REM Set variables
SET HEALTHCHECKS=""
SET GITURL=""
SET SCRIPT=""

REM Healthchecks.io Verification
curl %HEALTHCHECKS%

REM Download latest backup script
curl %GITURL% > %SCRIPT%

REM Run latest backup script
%SCRIPT%
