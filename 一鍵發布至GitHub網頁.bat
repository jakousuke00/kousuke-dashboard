@echo off
chcp 950 >nul
title 發布萬寶網頁至 GitHub
cls
echo ========================================================
echo   發布網頁至 GitHub Pages
echo ========================================================
echo.

echo [1/2] 正在檢查並打包最新網頁與資料庫...
git add index.html json_data/ README.md .gitignore
git commit -m "update dashboard data" >nul 2>&1

echo [2/2] 正在推送到 GitHub...
git push -u origin main

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================================
    echo   [成功] 網頁已成功推送至 GitHub！
    echo   請等待約 1 到 2 分鐘，線上網頁即會自動更新！
    echo ========================================================
) else (
    echo.
    echo [提示] 若第一次推送，請在瀏覽器或彈出視窗中完成 GitHub 登入授權。
)

echo.
pause
