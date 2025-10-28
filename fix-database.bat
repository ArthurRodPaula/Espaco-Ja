@echo off
echo Corrigindo problemas do banco de dados...

REM Tenta encontrar o PHP no sistema
set PHP_PATH=
for %%i in (php.exe) do set PHP_PATH=%%~$PATH:i

if "%PHP_PATH%"=="" (
    echo PHP nao encontrado no PATH. Tentando caminhos comuns...
    if exist "C:\xampp\php\php.exe" set PHP_PATH=C:\xampp\php\php.exe
    if exist "C:\wamp64\bin\php\php8.2.12\php.exe" set PHP_PATH=C:\wamp64\bin\php\php8.2.12\php.exe
    if exist "C:\laragon\bin\php\php82\php.exe" set PHP_PATH=C:\laragon\bin\php\php82\php.exe
)

if "%PHP_PATH%"=="" (
    echo ERRO: PHP nao encontrado. Instale o PHP ou adicione ao PATH.
    pause
    exit /b 1
)

echo Usando PHP: %PHP_PATH%

REM Executa as migrações
echo Executando migrate:fresh --seed...
"%PHP_PATH%" artisan migrate:fresh --seed

if %ERRORLEVEL% NEQ 0 (
    echo ERRO ao executar migrações. Tentando migrate:reset...
    "%PHP_PATH%" artisan migrate:reset
    "%PHP_PATH%" artisan migrate
    "%PHP_PATH%" artisan db:seed
)

echo Concluido!
pause