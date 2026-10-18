import React, { useState, useRef, useEffect, useCallback } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import './OTPVerification.css';

const MAX_ATTEMPTS = 5;
const RESEND_COOLDOWN = 30;

export default function OTPVerification() {
  const [otp, setOtp] = useState(['', '', '', '']);
  const [timer, setTimer] = useState(RESEND_COOLDOWN);
  const [attempts, setAttempts] = useState(0);
  const refs = [useRef(), useRef(), useRef(), useRef()];
  const navigate = useNavigate();
  const location = useLocation();
  const phone = location.state?.phone || '00000 00000';

  // Countdown timer
  useEffect(() => {
    if (timer <= 0) return;
    const interval = setInterval(() => setTimer(t => t - 1), 1000);
    return () => clearInterval(interval);
  }, [timer]);

  const handleChange = useCallback((idx, val) => {
    const digit = val.replace(/[^0-9]/g, '').slice(-1);
    const next = [...otp];
    next[idx] = digit;
    setOtp(next);
    if (digit && idx < 3) {
      refs[idx + 1].current?.focus();
    }
  }, [otp]);

  const handleKeyDown = useCallback((idx, e) => {
    if (e.key === 'Backspace' && !otp[idx] && idx > 0) {
      refs[idx - 1].current?.focus();
    }
  }, [otp]);

  const handleVerify = () => {
    if (attempts >= MAX_ATTEMPTS) return;
    const code = otp.join('');
    if (code.length === 4) {
      setAttempts(a => a + 1);
      // Simulate verification (always succeed for demo)
      navigate('/verified', { replace: true });
    }
  };

  const handleResend = () => {
    if (timer > 0) return;
    setTimer(RESEND_COOLDOWN);
    setOtp(['', '', '', '']);
    refs[0].current?.focus();
  };

  const maskedPhone = phone.length > 5
    ? `+91 ${phone.slice(0, 5)} ${phone.slice(5)}`
    : `+91 ${phone}`;

  const isComplete = otp.every(d => d !== '');

  return (
    <div className="otp-page" id="otp-screen">
      <button className="otp-back" onClick={() => navigate(-1)} aria-label="Go back">
        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
          <path d="m15 18-6-6 6-6"/>
        </svg>
      </button>

      <div className="otp-illustration">
        <svg className="otp-truck-svg" viewBox="0 0 220 160" fill="none">
          <rect x="50" y="55" width="100" height="55" rx="6" fill="#1B382C"/>
          <rect x="55" y="48" width="90" height="15" rx="4" fill="#158263"/>
          <rect x="130" y="68" width="45" height="42" rx="4" fill="#1B382C"/>
          <rect x="138" y="74" width="28" height="20" rx="2" fill="#a7d9c4"/>
          <circle cx="90" cy="115" r="13" fill="#333" stroke="#555" strokeWidth="3"/>
          <circle cx="90" cy="115" r="4" fill="#888"/>
          <circle cx="158" cy="115" r="13" fill="#333" stroke="#555" strokeWidth="3"/>
          <circle cx="158" cy="115" r="4" fill="#888"/>
          <rect x="65" y="36" width="14" height="14" rx="3" fill="#22c55e" opacity="0.8" transform="rotate(-15 65 36)"/>
          <rect x="95" y="30" width="12" height="16" rx="3" fill="#16a34a" opacity="0.7" transform="rotate(10 95 30)"/>
          <rect x="125" y="33" width="10" height="12" rx="3" fill="#4ade80" opacity="0.6" transform="rotate(-8 125 33)"/>
          <ellipse cx="30" cy="65" rx="10" ry="5" fill="#22c55e" opacity="0.4" transform="rotate(-25 30 65)"/>
          <ellipse cx="35" cy="50" rx="8" ry="4" fill="#16a34a" opacity="0.3" transform="rotate(15 35 50)"/>
          <ellipse cx="190" cy="55" rx="9" ry="4.5" fill="#4ade80" opacity="0.3" transform="rotate(-20 190 55)"/>
          <line x1="20" y1="78" x2="40" y2="78" stroke="#158263" strokeWidth="3" strokeLinecap="round" opacity="0.4"/>
          <line x1="25" y1="92" x2="42" y2="92" stroke="#158263" strokeWidth="2" strokeLinecap="round" opacity="0.25"/>
        </svg>
      </div>

      <h1 className="otp-heading">Enter OTP</h1>
      <p className="otp-subtitle">
        We've sent a code to<br />
        <span>{maskedPhone}</span>
      </p>

      <div className="otp-inputs">
        {otp.map((digit, i) => (
          <input
            key={i}
            ref={refs[i]}
            className={`otp-input ${digit ? 'filled' : ''}`}
            type="tel"
            inputMode="numeric"
            maxLength={1}
            value={digit}
            onChange={(e) => handleChange(i, e.target.value)}
            onKeyDown={(e) => handleKeyDown(i, e)}
            autoFocus={i === 0}
            id={`otp-input-${i}`}
          />
        ))}
      </div>

      <div className="otp-verify-btn">
        <button
          className="btn btn-primary"
          onClick={handleVerify}
          disabled={!isComplete || attempts >= MAX_ATTEMPTS}
          id="btn-verify-otp"
        >
          Verify OTP
        </button>
      </div>

      <div className="otp-resend">
        {timer > 0 ? (
          <span className="otp-timer">Resend OTP in {timer}s</span>
        ) : (
          <button className="otp-resend-link" onClick={handleResend}>Resend OTP</button>
        )}
      </div>
    </div>
  );
}
