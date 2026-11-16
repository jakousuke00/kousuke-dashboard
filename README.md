# 萬寶投顧資料（萬寶晚報 / 日報）自動化抓取專案

本專案實現了從 **萬寶商城 / 萬傳媒（estock.com.tw）** 自動抓取並下載已購買的 **萬寶晚報、日報原始高畫質 PDF**，並支援一鍵同步備份至 **Google 雲端硬碟**。

---

## 📌 核心機制與逆向架構（2026/10 新版 Nuxt 3 架構適配）

1. **突破 Google OAuth 登入防護**：
   * Google 阻擋常規自動化瀏覽器直接輸入帳密。
   * 本專案採用獨立 Chrome Profile（`C:\chrome_dev_profile`）配合 Remote Debugging 端口（`9222`）完成人工授權，之後將憑證保存至 `auth.json`。
2. **認證狀態驗證**：
   * 透過 `GET https://estock.com.tw/member-api/me` 即時驗證登入會員身分。
3. **最新線上閱讀器與高畫質 PDF 合成架構**：
   * 網站改版後移除了舊版 `/mbo/order/get-user-pdf` 接口，改為線上閱讀器：
     * 書架接口：`GET https://estock.com.tw/member-api/my-shelf`（取得會員書架所有刊物 ID、期數與頁數）。
     * 刊物資訊：`GET https://estock.com.tw/reader-api/info?product_id={product_id}`。
     * 各頁高解析圖檔：`GET https://estock.com.tw/reader-api/page?product_id={product_id}&n={page}`。
   * 爬蟲程式依序拉取各頁高畫質頁面，透過 Pillow (PIL) 無損合成多頁向量標準 PDF 並儲存至 `reports/`。
4. **配額與跳過機制**：
   * 為節省頻寬與避免浪費閱讀次數，爬蟲自動檢查本地 `reports/` 資料夾，**已存在的檔案一律跳過，僅下載新發布的報告**。
5. **Google 雲端硬碟自動同步**：
   * 支援將本地新產生的月度晚報/日報無縫上傳至專屬 Google 雲端硬碟目錄。

---

## 📂 專案檔案結構

| 檔案 / 資料夾 | 說明 |
| :--- | :--- |
| `reports/` | 下載完成的 PDF 存放資料夾 |
| `auth.json` | 儲存登入 Cookies 與 Token 的憑證檔案 |
| `crawler_wanbao.py` | 核心爬蟲程式（全自動抓取最新清單並下載 PDF） |
| `run_crawler.bat` | 一鍵執行爬蟲的批次檔（雙擊即可下載） |
| `一鍵下載最新晚報.bat` | 中文名稱的執行批次檔 |
| `upload_to_gdrive.py` | Google 雲端硬碟同步程式（比對並上傳新報告） |
| `一鍵同步雲端硬碟.bat` | 一鍵將報告同步至 Google 雲端硬碟批次檔 |
| `Start_Chrome_Debug.lnk` | 啟動 9222 端口 Chrome 專屬設定檔的 Windows 捷徑（供首次或過期重新登入） |
| `start_chrome_debug.bat` | 9222 端口 Chrome 啟動批次檔 |
| `save_login_session.py` | 將 9222 Chrome 登入狀態重新匯出至 `auth.json` 的工具 |
| `更新登入憑證.bat` | 一鍵更新登入憑證批次檔（連點兩下自動存檔，免打指令） |
| `test_standalone_auth.py` | 驗證 `auth.json` 是否仍處於有效登入態的測試腳本 |

---

## 🚀 日常操作 SOP

### 1. 每日抓取最新晚報（自動化）
只需**連點兩下**專案資料夾內的：
👉 **`一鍵下載最新晚報.bat`**（或 `run_crawler.bat`）

程式會在背景自動完成：
* 讀取 `auth.json` 登入態。
* 進入「我的書架」查詢最新已發布刊物。
* 自動比對本地檔案，僅下載尚未下載的報告並無損封裝為 PDF。

### 2. 同步至 Google 雲端硬碟
下載完成後，只需**連點兩下**專案資料夾內的：
👉 **`一鍵同步雲端硬碟.bat`**
即可自動將新下載的報告備份至 Google 雲端硬碟專屬目錄。

---

### 3. 登入憑證過期時的更新流程（SOP）
*若執行爬蟲提示憑證失效或未登入：*
1. 雙擊 **`Start_Chrome_Debug.lnk`** 開啟 Chrome。
2. 在開啟的視窗中點擊**「使用 Google 登入」**完成驗證。
3. 雙擊 **`更新登入憑證.bat`** 完成更新！之後即可繼續日常抓取。

---

## ☁️ Google 雲端硬碟備份架構

```text
📁 我的雲端硬碟
   └── 📁 萬寶投顧報告  (ID: 1gpC99W66aaQ9Tw6D9lSSUkRkkOmGGG-p)
         └── 📁 萬寶晚報  (ID: 14Wt5Q55bEwPfMzEFUZBOKaXCklTaiiX5)
               ├── 📁 2026年10月  (ID: 1VAolF4jE_wrvq4Avesft_mFNz1YrKaWb)
               │     └── 📄 10月份萬寶晚報、產業報告與IA組合週報 (共 34 份 PDF)
               └── 📁 2026年11月  (ID: 1Du2HYvLA4nTl5l_Bk99y0OlTmZDGQImg)
                     ├── 📄 萬寶產業報告-1101(萬寶晚報贈品).pdf
                     ├── 📄 萬寶產業報告-1102(萬寶晚報贈品).pdf
                     ├── 📄 萬寶晚報-11_02.pdf
                     ├── 📄 萬寶產業報告-1103(萬寶晚報贈品).pdf
                     ├── 📄 萬寶晚報-11_03.pdf
                     ├── 📄 萬寶產業報告-1104(萬寶晚報贈品).pdf
                     ├── 📄 萬寶晚報-11_04.pdf
                     ├── 📄 萬寶產業報告-1105(萬寶晚報贈品).pdf
                     ├── 📄 萬寶晚報-11_05.pdf
                     ├── 📄 萬寶產業報告-1106(萬寶晚報贈品).pdf
                     ├── 📄 萬寶晚報-11_06.pdf
                     ├── 📄 萬寶產業報告-1107(萬寶晚報贈品).pdf
                     ├── 📄 萬寶產業報告-1108(萬寶晚報贈品).pdf
                     ├── 📄 萬寶晚報-11_09.pdf
                     ├── 📄 萬寶產業報告-1110(萬寶晚報贈品).pdf
                     ├── 📄 萬寶晚報-11_10.pdf
                     ├── 📄 萬寶產業報告-1111(萬寶晚報贈品).pdf
                     ├── 📄 萬寶晚報-11_11.pdf
                     ├── 📄 萬寶產業報告-1112(萬寶晚報贈品).pdf
                     ├── 📄 萬寶晚報-11_12.pdf
                     ├── 📄 萬寶產業報告-1113(萬寶晚報贈品).pdf
                     └── 📄 萬寶晚報-11_13.pdf
```
