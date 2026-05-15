@echo off
echo ========================================
echo  SACCO MFI - Flutter Setup
echo ========================================
echo.

:: Check if Flutter is installed
where flutter >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Flutter is not installed.
    echo.
    echo Please install Flutter SDK:
    echo   1. Download from: https://docs.flutter.dev/get-started/install/windows
    echo   2. Extract to C:\flutter
    echo   3. Add C:\flutter\bin to your PATH
    echo   4. Restart this terminal
    echo.
    pause
    exit /b 1
)

echo [OK] Flutter found
flutter --version
echo.

:: Get dependencies
echo [..] Installing dependencies...
call flutter pub get
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to install dependencies
    pause
    exit /b 1
)
echo [OK] Dependencies installed
echo.

:: Run code generation
echo [..] Running code generation...
dart run build_runner build --delete-conflicting-outputs
if %ERRORLEVEL% NEQ 0 (
    echo [WARN] Code generation had issues (may need manual run)
)
echo [OK] Code generation complete
echo.

:: Run the app
echo [..] Launching app...
flutter run
pause
