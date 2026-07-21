@echo off
setlocal

REM ===== LP_XMLConverter path =====
set CONVERTER="C:\Program Files\Graphisoft\Archicad 29\LP_XMLConverter.exe"

REM ===== Input file =====
set INPUT=%~1

if "%INPUT%"=="" (
    echo Drag and drop a GSM or XML file onto this BAT file.
    pause
    exit
)

REM ===== File info =====
set DIR=%~dp1
set NAME=%~n1
set EXT=%~x1

echo.
echo Processing: %INPUT%
echo Extension: %EXT%
echo.

REM =====================================================
REM GSM -> XML
REM =====================================================

if /I "%EXT%"==".gsm" (

    echo Converting GSM to XML...

    REM Delete old XML folder
    if exist "%DIR%%NAME%" rmdir /s /q "%DIR%%NAME%"

    %CONVERTER% libpart2xml "%INPUT%" "%DIR%%NAME%"

    echo.
    echo Done.
    echo Output folder:
    echo %DIR%%NAME%

    exit
)

REM =====================================================
REM XML (or no extension) -> GSM
REM =====================================================

if /I "%EXT%"==".xml" goto XMLMODE
if "%EXT%"=="" goto XMLMODE

goto NOTSUPPORTED

:XMLMODE

echo Converting XML to GSM...

pushd "%DIR%"

REM Delete existing GSM
if exist "%NAME%.gsm" del /f /q "%NAME%.gsm"

REM With extension
if /I "%EXT%"==".xml" (
    %CONVERTER% xml2libpart "%NAME%.xml" "%NAME%.gsm"
)

REM Without extension
if "%EXT%"=="" (
    %CONVERTER% xml2libpart "%NAME%" "%NAME%.gsm"
)

popd

echo.
echo Done.
echo Output:
echo %DIR%%NAME%.gsm

exit

:NOTSUPPORTED
echo Unsupported file type.
exit