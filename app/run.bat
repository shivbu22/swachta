@echo off
title Swachta App Setup & Run
echo.
echo ==========================================
echo   SWACHTA APP - Setup ^& Run
echo ==========================================
echo.

cd /d "d:\Swachta\app"

echo [1/3] Copying images...
copy /Y "C:\Users\ahiva\.gemini\antigravity-ide\brain\c97d8c5a-5b33-403e-b605-aaf4de8008ca\onboarding_workers_1784460219395.png" "d:\Swachta\app\public\images\onboarding-1.png" >nul
copy /Y "C:\Users\ahiva\.gemini\antigravity-ide\brain\c97d8c5a-5b33-403e-b605-aaf4de8008ca\onboarding_planting_1784460230797.png" "d:\Swachta\app\public\images\onboarding-2.png" >nul
copy /Y "C:\Users\ahiva\.gemini\antigravity-ide\brain\c97d8c5a-5b33-403e-b605-aaf4de8008ca\onboarding_app_1784460240602.png" "d:\Swachta\app\public\images\onboarding-3.png" >nul
copy /Y "C:\Users\ahiva\.gemini\antigravity-ide\brain\c97d8c5a-5b33-403e-b605-aaf4de8008ca\service_daily_garbage_1784460263258.png" "d:\Swachta\app\public\images\service-daily.png" >nul
copy /Y "C:\Users\ahiva\.gemini\antigravity-ide\brain\c97d8c5a-5b33-403e-b605-aaf4de8008ca\service_scrap_materials_1784460273409.png" "d:\Swachta\app\public\images\service-scrap.png" >nul
copy /Y "C:\Users\ahiva\.gemini\antigravity-ide\brain\c97d8c5a-5b33-403e-b605-aaf4de8008ca\service_recyclable_1784460283639.png" "d:\Swachta\app\public\images\service-recyclable.png" >nul
copy /Y "C:\Users\ahiva\.gemini\antigravity-ide\brain\c97d8c5a-5b33-403e-b605-aaf4de8008ca\service_large_dump_1784460303804.png" "d:\Swachta\app\public\images\service-large-dump.png" >nul
copy /Y "C:\Users\ahiva\.gemini\antigravity-ide\brain\c97d8c5a-5b33-403e-b605-aaf4de8008ca\offer_banner_1784460314847.png" "d:\Swachta\app\public\images\offer-banner.png" >nul
copy /Y "C:\Users\ahiva\.gemini\antigravity-ide\brain\c97d8c5a-5b33-403e-b605-aaf4de8008ca\reels_background_1784460324488.png" "d:\Swachta\app\public\images\reels-bg.png" >nul
echo    Done! 9 images copied.
echo.

echo [2/3] Installing dependencies...
call npm install
echo.

echo [3/3] Starting dev server...
echo.
echo ==========================================
echo   App will open at http://localhost:3000
echo   Press Ctrl+C to stop
echo ==========================================
echo.
call npm run dev

pause
