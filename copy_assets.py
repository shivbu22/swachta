import shutil
import os

src_icon = r"C:\Users\ahiva\.gemini\antigravity\brain\5bbba0cb-da6c-4dba-8ef4-e95284a4542a\swachta_icon_1783822374679.png"
src_splash = r"C:\Users\ahiva\.gemini\antigravity\brain\5bbba0cb-da6c-4dba-8ef4-e95284a4542a\swachta_splash_1783822385689.png"

destinations = [
    # Worker assets
    ("apps/worker/assets/icon.png", src_icon),
    ("apps/worker/assets/adaptive-icon.png", src_icon),
    ("apps/worker/assets/splash-icon.png", src_splash),
    ("apps/worker/assets/favicon.png", src_icon),
    # Requestor assets
    ("apps/requestor/assets/icon.png", src_icon),
    ("apps/requestor/assets/adaptive-icon.png", src_icon),
    ("apps/requestor/assets/splash-icon.png", src_splash),
    ("apps/requestor/assets/favicon.png", src_icon),
]

for relative_dest, src in destinations:
    dest_path = os.path.join(r"c:\Users\ahiva\Downloads\Swachta", relative_dest)
    os.makedirs(os.path.dirname(dest_path), exist_ok=True)
    shutil.copy2(src, dest_path)
    print(f"Copied to {relative_dest}")
