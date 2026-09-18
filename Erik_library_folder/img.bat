@echo off
setlocal

REM ===== LP_XMLConverter path =====
set CONVERTER="C:\Program Files\Graphisoft\Archicad 29\LP_XMLConverter.exe"

REM ===== Input file =====
set INPUT=%~1

if "%INPUT%"=="" (
    echo Drag and drop a GSM or XML file onto this BAT file.
    goto END
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
    echo Converting GSM to XML with images...

    REM Clean existing target XML
    if exist "%DIR%%NAME%.xml" del /f /q "%DIR%%NAME%.xml"
    if exist "%DIR%%NAME%" del /f /q "%DIR%%NAME%"

    pushd "%DIR%"
    %CONVERTER% libpart2xml -img "." "%NAME%.gsm" "%NAME%"
    popd

    if exist "%DIR%%NAME%" (
        echo.
        echo Done.
        echo Output XML: %DIR%%NAME%
    ) else (
        echo.
        echo --------------------------------------------------
        echo Conversion failed! Check the error log above.
        echo --------------------------------------------------
    )
    goto END
)

REM =====================================================
REM XML (or no extension) -> GSM
REM =====================================================
if /I "%EXT%"==".xml" goto XMLMODE
if "%EXT%"=="" goto XMLMODE

goto NOTSUPPORTED

:XMLMODE
echo Converting XML to GSM with embedded images...

pushd "%DIR%"

REM Delete existing GSM before converting
if exist "%NAME%.gsm" del /f /q "%NAME%.gsm"

if /I "%EXT%"==".xml" (
    %CONVERTER% xml2libpart -img "." "%NAME%.xml" "%NAME%.gsm"
)
if "%EXT%"=="" (
    %CONVERTER% xml2libpart -img "." "%NAME%" "%NAME%.gsm"
)

popd

if exist "%DIR%%NAME%.gsm" (
    echo.
    echo Done.
    echo Output: %DIR%%NAME%.gsm
) else (
    echo.
    echo --------------------------------------------------
    echo Conversion failed! No GSM file was created.
    echo Check the error log above.
    echo --------------------------------------------------
)
goto END

:NOTSUPPORTED
echo.
echo Unsupported file type: %EXT%

:END
echo.
echo Press any key to close this window...
pause >nul