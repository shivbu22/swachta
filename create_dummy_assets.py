import os

# 1x1 transparent pixel PNG base64 decoded bytes
dummy_png = b'\x89PNG\r\n\x1a\n\x00\x00\x00\rIHDR\x00\x00\x00\x01\x00\x00\x00\x01\x08\x06\x00\x00\x00\x1f\x15c4\x00\x00\x00\rIDATx\x9cc`\x00\x00\x00\x02\x00\x01H\xaf\xa4q\x00\x00\x00\x00IEND\xaeB`\x82'

paths = [
    # Worker App Assets
    "apps/worker/assets/icon.png",
    "apps/worker/assets/adaptive-icon.png",
    "apps/worker/assets/splash-icon.png",
    "apps/worker/assets/favicon.png",
    # Requestor App Assets
    "apps/requestor/assets/icon.png",
    "apps/requestor/assets/adaptive-icon.png",
    "apps/requestor/assets/splash-icon.png",
    "apps/requestor/assets/favicon.png",
]

for p in paths:
    full_path = os.path.join("c:\\Users\\ahiva\\Downloads\\Swachta", p)
    os.makedirs(os.path.dirname(full_path), exist_ok=True)
    with open(full_path, "wb") as f:
        f.write(dummy_png)
    print(f"Created dummy asset: {p}")
