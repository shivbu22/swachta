import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './Login.css';

/* Leaf SVG component */
const LeafSVG = ({ color = '#4CAF50' }) => (
  <svg viewBox="0 0 40 40" fill="none">
    <path d="M20 4C12 8 4 18 6 30C8 34 14 36 20 36C26 36 32 34 34 30C36 18 28 8 20 4Z" fill={color} opacity="0.6"/>
    <path d="M20 8C20 8 20 36 20 36" stroke={color} strokeWidth="1" opacity="0.4"/>
  </svg>
);

export default function Login() {
  const [phone, setPhone] = useState('');
  const navigate = useNavigate();

  const sanitizePhone = (val) => {
    return val.replace(/[^0-9\s]/g, '').slice(0, 12);
  };

  const handleContinue = () => {
    const cleaned = phone.replace(/\s/g, '');
    if (cleaned.length >= 10) {
      navigate('/otp', { state: { phone: cleaned } });
    }
  };

  return (
    <div className="login-page" id="login-screen">
      {/* Floating leaves */}
      <div className="login-leaf login-leaf-1"><LeafSVG color="#66BB6A" /></div>
      <div className="login-leaf login-leaf-2 login-leaf-sm"><LeafSVG color="#81C784" /></div>
      <div className="login-leaf login-leaf-3"><LeafSVG color="#4CAF50" /></div>
      <div className="login-leaf login-leaf-4 login-leaf-sm"><LeafSVG color="#A5D6A7" /></div>
      <div className="login-leaf login-leaf-5"><LeafSVG color="#388E3C" /></div>

      {/* Content */}
      <div className="login-content animate-fade-in-up">
        <h1 className="login-heading">Welcome Back!</h1>
        <p className="login-subtitle">Enter your phone number to continue</p>

        <div className="login-phone-group">
          <label>Phone Number</label>
          <div className="login-phone-field">
            <span className="login-phone-icon">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72c.127.96.361 1.903.7 2.81a2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0 1 22 16.92z"/>
              </svg>
            </span>
            <input
              type="tel"
              placeholder="+91 00000 00000"
              value={phone}
              onChange={(e) => setPhone(sanitizePhone(e.target.value))}
              maxLength={12}
              autoComplete="tel"
              id="input-phone"
            />
          </div>
        </div>

        <p className="login-terms">
          By continuing, you agree to our{' '}
          <a href="#terms">Terms & Privacy Policy</a>
        </p>

        <div className="login-cta">
          <button
            className="btn btn-primary"
            onClick={handleContinue}
            disabled={phone.replace(/\s/g, '').length < 10}
            id="btn-continue"
          >
            Continue
          </button>
        </div>

        <p className="login-link">
          Don't have an account? <a href="#" onClick={(e) => { e.preventDefault(); navigate('/signup'); }}>Sign Up</a>
        </p>
      </div>

      {/* Bottom scenery */}
      <div className="login-scenery">
        <div className="login-scenery-gradient"></div>
        <div className="login-grass"></div>
      </div>
    </div>
  );
}
