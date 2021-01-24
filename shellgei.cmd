@echo off

rem カレントディレクトリをスクリプトの場所に変更
cd /d %~dp0

rem ターミナルをUTF-8表示にセット
chcp 65001 > nul

rem 引数が空の場合プロンプト表示n
rem そうでない場合引数のコマンドを実行
if "%*" == "" (
	goto prompt
) else (
	call :request %*
)

exit /b

:prompt
rem カレントディレクトリを変数に代入
for /f "usebackq" %%A in (`cd`) do set pwd=%%A
set /p input=%username%@%computername%:%pwd%$ 
if "%input%" == "exit" (
	exit /b
) else if not "%input%" == "" (
	call :request %input%
)
goto prompt

rem function
:request
set query=%TEMP%\shellgei-temp-query.json
set result=%TEMP%\shellgei-temp-result.json
set args=%*
set escaped=%args:"=\"%
echo {"code":"%escaped%", "images":[]}>%query%
curl -s -o %result% -X POST -H "Content-Type:application/json" -d @%query% https://websh.jiro4989.com/api/shellgei
jq -r .stdout %result%
jq -r .stderr %result%
exit /b