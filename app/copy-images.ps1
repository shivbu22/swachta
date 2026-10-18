## Copy the generated images to your app

$src = "C:\Users\ahiva\.gemini\antigravity-ide\brain\c97d8c5a-5b33-403e-b605-aaf4de8008ca"
$dst = "d:\Swachta\app\public\images"

Copy-Item "$src\onboarding_workers_1784460219395.png" "$dst\onboarding-1.png" -Force
Copy-Item "$src\onboarding_planting_1784460230797.png" "$dst\onboarding-2.png" -Force
Copy-Item "$src\onboarding_app_1784460240602.png" "$dst\onboarding-3.png" -Force
Copy-Item "$src\service_daily_garbage_1784460263258.png" "$dst\service-daily.png" -Force
Copy-Item "$src\service_scrap_materials_1784460273409.png" "$dst\service-scrap.png" -Force
Copy-Item "$src\service_recyclable_1784460283639.png" "$dst\service-recyclable.png" -Force
Copy-Item "$src\service_large_dump_1784460303804.png" "$dst\service-large-dump.png" -Force
Copy-Item "$src\offer_banner_1784460314847.png" "$dst\offer-banner.png" -Force
Copy-Item "$src\reels_background_1784460324488.png" "$dst\reels-bg.png" -Force

Write-Host "All 9 images copied successfully!" -ForegroundColor Green
