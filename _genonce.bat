@ECHO OFF
SET publisher_jar=org.hl7.fhir.publisher.jar
SET input_cache_path=%CD%\input-cache

ECHO Checking internet connection...
PING tx.fhir.org -4 -n 1 -w 1000 | FINDSTR TTL && GOTO isonline
wget –O icon.png http://tx.fhir.org/favicon.png && del icon.png && GOTO isonline
ECHO Could not get wget to work or Terminology server is down
ECHO Make sure PING is working or wget is installed - http://gnuwin32.sourceforge.net/packages/wget.htm
ECHO

:loop
choice /t 10 /c yna /cs /d y /n /m "Try to run online anyway? (Yes, No, or Abort)"

if errorlevel 3 goto :loop
if errorlevel 2 goto :no
if errorlevel 1 goto :yes

:yes
ECHO Running with default terminology server
SET txoption=
GOTO :isonline

:no
SET txoption=-tx n/a
GOTO :igpublish


:isonline

:igpublish

SET JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8

IF EXIST "%input_cache_path%\%publisher_jar%" (
	JAVA -jar "%input_cache_path%\%publisher_jar%" -ig ig.ini %txoption% %*
) ELSE If exist "..\%publisher_jar%" (
	JAVA -jar "..\%publisher_jar%" -ig ig.ini %txoption% %*
) ELSE (
	ECHO IG Publisher NOT FOUND in input-cache or parent folder.  Please run _updatePublisher.  Aborting...
)

PAUSE
