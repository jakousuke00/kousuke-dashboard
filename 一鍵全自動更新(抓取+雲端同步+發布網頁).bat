@echo off
chcp 65001 >nul
echo ========================================================
echo 🌟 萬寶投顧 - 全自動更新整合系統
echo 1. 下載最新晚報與報告 PDF
echo 2. 同步備份至 Google 雲端硬碟
echo 3. 重新編譯本地知識庫資料庫
echo 4. 自動發布更新至 GitHub Pages 網頁
echo ========================================================
echo.

echo --------------------------------------------------------
echo 步驟 1/4: 下載最新刊物...
echo --------------------------------------------------------
py crawler_wanbao.py
if %ERRORLEVEL% NEQ 0 (
    echo ⚠️ 下載中斷，請確認網路或登入憑證。
)
echo.

echo --------------------------------------------------------
echo 步驟 2/4: 同步至 Google 雲端硬碟...
echo --------------------------------------------------------
py upload_to_gdrive.py
if %ERRORLEVEL% NEQ 0 (
    echo ⚠️ 雲端硬碟同步遭遇問題，可稍後手動重試。
)
echo.

echo --------------------------------------------------------
echo 步驟 3/4: 編譯知識庫主資料庫...
echo --------------------------------------------------------
py rebuild_master.py
echo.

echo --------------------------------------------------------
echo 步驟 4/4: 同步推送發布至 GitHub 網頁...
echo --------------------------------------------------------
git remote get-url origin >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    git add index.html json_data/ README.md .gitignore
    git commit -m "auto: 定期全自動排程更新 (%date% %time%)" >nul 2>&1
    git push origin main
    if %ERRORLEVEL% EQU 0 (
        echo 🎉 GitHub 網頁同步發布成功！約 1~2 分鐘後生效。
    ) else (
        echo ⚠️ GitHub 推送失敗，請手動執行「一鍵發布至GitHub網頁.bat」查看詳情。
    )
) else (
    echo 💡 尚未關聯 GitHub 遠端倉庫，跳過網頁推送。如需設定請執行「一鍵發布至GitHub網頁.bat」。
)

echo.
echo ========================================================
echo ✅ 全部工作流程已執行完畢！
echo ========================================================
pause
