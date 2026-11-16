@echo off
chcp 950 >nul
title 萬寶投顧資料全自動更新
cls
echo ========================================================
echo   萬寶投顧 - 全自動更新整合流程
echo   1. 下載最新報告 PDF
echo   2. 備份至 Google 雲端硬碟
echo   3. 重建主資料庫
echo   4. 推送發布至 GitHub 網頁
echo ========================================================
echo.

echo [步驟 1/4] 下載最新刊物...
py crawler_wanbao.py
echo.

echo [步驟 2/4] 同步至 Google 雲端硬碟...
py upload_to_gdrive.py
echo.

echo [步驟 3/4] 重建主資料庫...
py rebuild_master.py
echo.

echo [步驟 4/4] 發布至 GitHub...
git add index.html json_data/ README.md .gitignore
git commit -m "auto update dashboard data" >nul 2>&1
git push origin main
if %ERRORLEVEL% EQU 0 (
    echo [成功] GitHub 網頁發布完成！
) else (
    echo [提示] 若推送失敗，請手動執行「一鍵發布至GitHub網頁.bat」。
)

echo.
echo ========================================================
echo   所有流程執行完畢！
echo ========================================================
pause
