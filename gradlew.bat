@echo off
setlocal

set "SCRIPT_DIR=%~dp0"
set "GRADLE_VERSION=%GRADLE_VERSION:=%"
if "%GRADLE_VERSION%"=="" set "GRADLE_VERSION=8.7"
set "GRADLE_HOME=%SCRIPT_DIR%\.gradle"
set "GRADLE_DIST_DIR=%GRADLE_HOME%\gradle-%GRADLE_VERSION%"
set "GRADLE_BIN=%GRADLE_DIST_DIR%\bin\gradle.bat"

if not exist "%GRADLE_HOME%" mkdir "%GRADLE_HOME%"

where gradle >nul 2>nul
if errorlevel 1 (
  if not exist "%GRADLE_BIN%" (
    echo Downloading Gradle %GRADLE_VERSION%...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://services.gradle.org/distributions/gradle-%GRADLE_VERSION%-bin.zip' -OutFile '%GRADLE_HOME%\gradle-%GRADLE_VERSION%-bin.zip'"
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Expand-Archive -Path '%GRADLE_HOME%\gradle-%GRADLE_VERSION%-bin.zip' -DestinationPath '%GRADLE_HOME%' -Force"
  )
  set "PATH=%GRADLE_DIST_DIR%\bin;%PATH%"
)

gradle %*
