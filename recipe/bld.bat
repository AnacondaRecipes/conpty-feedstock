if /I "%ARCH%" == "arm64" (
  set MSVC_PLATFORM=ARM64
) else (
  set MSVC_PLATFORM=x64
)

:: Build ConPTY
msbuild src\winconpty\dll\winconptydll.vcxproj /p:SolutionDir=%SRC_DIR%\ /p:Configuration=Release /p:Platform=%MSVC_PLATFORM% /p:WindowsTargetPlatformVersion=10.0
if errorlevel 1 exit /b 1

:: Build OpenConsole.exe
msbuild src\host\exe\Host.EXE.vcxproj /p:SolutionDir=%SRC_DIR%\ /p:Configuration=Release /p:Platform=%MSVC_PLATFORM% /p:WindowsTargetPlatformVersion=10.0
if errorlevel 1 exit /b 1

:: Install artifacts — output subfolder name always matches %MSVC_PLATFORM%
copy %SRC_DIR%\bin\%MSVC_PLATFORM%\Release\conpty.lib %LIBRARY_LIB%\
if errorlevel 1 exit /b 1

copy %SRC_DIR%\bin\%MSVC_PLATFORM%\Release\conpty.dll %LIBRARY_BIN%\
if errorlevel 1 exit /b 1

:: Copy the optional OpenConsole.exe binary. While the DLL can use conhost.exe fallback (present on modern
:: Windows versions), some depending packages explicitly search for 'OpenConsole.exe' in their build process.
copy %SRC_DIR%\bin\%MSVC_PLATFORM%\Release\OpenConsole.exe %LIBRARY_BIN%\
if errorlevel 1 exit /b 1

:: Headers are part of the Windows SDK (consoleapi.h)