@echo off
chcp 65001 >nul
echo ========================================================
echo 🌐 萬寶投顧知識庫 - 一鍵同步發布至 GitHub Pages 網頁
echo ========================================================
echo.

git status >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ❌ 尚未建立 Git 儲存庫，請先依照教學完成初始設定。
    pause
    exit /b
)

git remote get-url origin >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ⚠️ 尚未設定 GitHub 遠端倉庫網址！
    echo.
    echo 請貼上您的 GitHub 倉庫網址（例如：https://github.com/您的帳號/wanbao-dashboard.git）：
    set /p REPO_URL="👉 請輸入網址: "
    if "%REPO_URL%"=="" (
        echo ❌ 未輸入網址，操作已取消。
        pause
        exit /b
    )
    git remote add origin %REPO_URL%
    echo ✅ 已成功關聯 GitHub 遠端倉庫！
    echo.
)

echo 📦 正在封裝最新網頁與資料庫檔案...
git add index.html json_data/ README.md .gitignore
git commit -m "update: 萬寶投顧知識庫定期更新 (%date% %time%)" >nul 2>&1

echo 🚀 正在推送更新至 GitHub (main 分支)...
git push -u origin main

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================================
    echo 🎉 發布成功！
    echo GitHub 伺服器正在進行自動編譯，約 1~2 分鐘後即可開啟網頁瀏覽最新資料！
    echo ========================================================
) else (
    echo.
    echo ❌ 推送失敗！可能的原因：
    echo 1. 尚未登入 GitHub 或 Token 憑證無寫入權限
    echo 2. 網路連線問題
    echo 請參考終端機上方之錯誤訊息，或參照逐步教學重新設定。
)

echo.
pause
