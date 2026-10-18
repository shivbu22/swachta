#!/usr/bin/env pwsh
# Swachta Image Setup Script
# Run this script to copy generated images to the public/images directory

$artifactDir = "C:\Users\ahiva\.gemini\antigravity-ide\brain\e87b706b-d15d-4e0a-b935-e3b3dd000ab5"
$targetDir = "d:\Swachta\app\public\images"

# Ensure target directory exists
if (!(Test-Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
}

$copies = @(
    @{ src = "onboarding_1_1785832149331.png"; dst = "onboarding-1.png" },
    @{ src = "onboarding_2_1785832160804.png"; dst = "onboarding-2.png" },
    @{ src = "onboarding_3_1785832170962.png"; dst = "onboarding-3.png" },
    @{ src = "service_daily_1785832190895.png"; dst = "service-daily.png" },
    @{ src = "service_scrap_1785832201718.png"; dst = "service-scrap.png" },
    @{ src = "service_recyclable_1785832214610.png"; dst = "service-recyclable.png" },
    @{ src = "service_large_dump_1785832225155.png"; dst = "service-large-dump.png" },
    @{ src = "offer_banner_1785832245243.png"; dst = "offer-banner.png" },
    @{ src = "reels_bg_1785832257205.png"; dst = "reels-bg.png" }
)

foreach ($item in $copies) {
    $srcPath = Join-Path $artifactDir $item.src
    $dstPath = Join-Path $targetDir $item.dst
    if (Test-Path $srcPath) {
        Copy-Item $srcPath $dstPath -Force
        Write-Host "Copied: $($item.dst)" -ForegroundColor Green
    } else {
        Write-Host "MISSING: $($item.src)" -ForegroundColor Red
    }
}

Write-Host "`nAll images setup complete!" -ForegroundColor Cyan
Write-Host "Now run: npm install && npm run dev" -ForegroundColor Yellow
