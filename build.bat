@echo off
setlocal enabledelayedexpansion

REM=============================================
REM user config parameters
REM=============================================
set "CMAKE_PATH=C:\cygwin64\bin\cmake.exe"
set "NDK_HOME=C:\Program Files\android-ndk-r27d"
set "PATH=%NDK_HOME%\..\..\cmake\3.22.1\bin;%PATH%"

set "ABI=arm64-v8a"
set "API_LEVEL=21"
set "BUILD_TYPE=Release"
set "PROJECT_DIR=%~dp0"

REM=============================================
REM verify paths
REM=============================================
if not exist "%CMAKE_PATH%" (
        echo ERROR: could not find Cmake , path "%CMAKE_PATH%" not exist.
        exit /b 1
)

if not exist "%NDK_HOME%" (
        echo ERROR: could not find NDK , path "%NDK_HOME%" not exist.
        exit /b 1
)

REM=============================================
REM set toolchain path
REM=============================================
set "TOOLCHAIN=%NDK_HOME%\toolchains\llvm\prebuilt\windows-x86_64"
set "CLANG=%TOOLCHAIN%\bin\clang.exe"

if not exist "%CLANG%" (
        echo ERROR: could not find Clang compiler , "%CLANG%".
        echo Please check tool chain path "%TOOLCHAIN%"
        exit /b 1
)

REM=============================================
REM create build directory
REM=============================================
set "BUILD_DIR=%PROJECT_DIR%build"
if exist %BUILD_DIR% rmdir /s /q "%BUILD_DIR%"
mkdir "%BUILD_DIR%"

REM=============================================
REM Run CMake config
REM=============================================
echo.
echo============================================
echo config CMake build
echo============================================
echo CMake path: %CMAKE_PATH%
echo NDK path: %NDK_HOME%
echo toolchain: %TOOLCHAIN%
echo Clang compiler: %CLANG%
echo ABI: %ABI%
echo API level: %API_LEVEL%
echo============================================
echo.

pushd "%BUILD_DIR%"

"%CMAKE_PATH%" -G "Ninja" ^
        -DCMAKE_MAKE_PROGRAM="ninja.exe" ^
        -DCMAKE_TOOLCHAIN_FILE="%NDK_HOME%\build\cmake\android.toolchain.cmake" ^
        -DANDROID_NDK="%NDK_HOME%" ^
        -DCMAKE_C_COMPILER="%TOOLCHAIN%/bin/clang.exe" ^
        -DCMAKE_CXX_COMPILER="%TOOLCHAIN%/bin/clang++.exe" ^
        -DANDROID_ABI="%ABI%" ^
        -DANDROID_NATIVE_API_LEVEL="%API_LEVEL%" ^
        -DCMAKE_BUILD_TYPE="%BUILD_TYPE%" ^
        "%PROJECT_DIR%"

if %errorlevel% neq 0 (
        echo CMake config fail
        popd
        exit /b 1
)


echo============================================
echo compile project
echo============================================
echo.
echo============================================
echo start compile
echo============================================
echo.

"%CMAKE_PATH%" --build .

if %errorlevel% neq 0 (
        echo compile fail
        popd
        exit /b 1
)

echo.
echo============================================
echo compile success !
echo============================================
echo test program location: %BUID_DIR%\bin\demo_test
echo.

popd

REM=============================================
REM push to device command
REM=============================================
echo push to device command:
echo adb push "%BUILD_DIR%\bin\demo_test" /data/local/tmp/demo_test
echo adb shell "cd /data/local/tmp && chmod +x demo_test && ./demo_test"
echo.

endlocal
