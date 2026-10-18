"""
Auth utilities: JWT tokens, password/PIN hashing, OTP generation.
Uses hashlib (pbkdf2) instead of passlib to avoid bcrypt version conflicts.
"""
import hashlib
import hmac
import os
import random
import string
from datetime import datetime, timedelta, timezone

from jose import JWTError, jwt

from config import get_settings

settings = get_settings()

# ── Password / PIN hashing via PBKDF2 ────────────────────────────────────────

def hash_password(password: str) -> str:
    """Hash a password with PBKDF2-SHA256 and a random salt."""
    salt = os.urandom(16)
    dk = hashlib.pbkdf2_hmac("sha256", password.encode(), salt, 260_000)
    return salt.hex() + ":" + dk.hex()


def verify_password(plain: str, hashed: str) -> bool:
    """Verify a password against a PBKDF2-SHA256 hash."""
    try:
        salt_hex, dk_hex = hashed.split(":", 1)
        salt = bytes.fromhex(salt_hex)
        dk = hashlib.pbkdf2_hmac("sha256", plain.encode(), salt, 260_000)
        return hmac.compare_digest(dk.hex(), dk_hex)
    except Exception:
        return False


# ── JWT ───────────────────────────────────────────────────────────────────────

def create_access_token(subject: str, role: str, extra: dict | None = None) -> str:
    expire = datetime.now(timezone.utc) + timedelta(minutes=settings.jwt_expire_minutes)
    payload = {
        "sub": subject,
        "role": role,
        "exp": expire,
        **(extra or {}),
    }
    return jwt.encode(payload, settings.jwt_secret, algorithm=settings.jwt_algorithm)


def decode_token(token: str) -> dict:
    return jwt.decode(token, settings.jwt_secret, algorithms=[settings.jwt_algorithm])


# ── OTP ───────────────────────────────────────────────────────────────────────

def generate_otp(length: int = 6) -> str:
    return "".join(random.choices(string.digits, k=length))


async def send_otp(phone: str, otp: str) -> None:
    """
    Send OTP via configured provider.
    In development (mock mode), just print to console.
    """
    if settings.otp_provider == "mock":
        print(f"[OTP MOCK] Phone: {phone} | OTP: {otp}")
        return

    if settings.otp_provider == "twilio":
        from twilio.rest import Client
        client = Client(settings.twilio_account_sid, settings.twilio_auth_token)
        client.messages.create(
            body=f"Swachta OTP: {otp}. Valid for 10 minutes.",
            from_=settings.twilio_from_number,
            to=f"+91{phone}",
        )
