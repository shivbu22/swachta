import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './SignUp.css';

const LeafSVG = ({ color = '#4CAF50' }) => (
  <svg viewBox="0 0 40 40" fill="none">
    <path d="M20 4C12 8 4 18 6 30C8 34 14 36 20 36C26 36 32 34 34 30C36 18 28 8 20 4Z" fill={color} opacity="0.6"/>
  </svg>
);

const sanitize = (val) => val.replace(/<[^>]*>/g, '');

export default function SignUp() {
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [phone, setPhone] = useState('');
  const navigate = useNavigate();

  const isValid = name.trim().length >= 2 && phone.replace(/\s/g, '').length >= 10;

  const handleSendOTP = () => {
    if (isValid) {
      navigate('/otp', { state: { phone: phone.replace(/\s/g, ''), name: sanitize(name), email: sanitize(email) } });
    }
  };

  return (
    <div className="signup-page" id="signup-screen">
      <div className="signup-leaf signup-leaf-1"><LeafSVG color="#66BB6A" /></div>
      <div className="signup-leaf signup-leaf-2"><LeafSVG color="#81C784" /></div>
      <div className="signup-leaf signup-leaf-3"><LeafSVG color="#A5D6A7" /></div>

      <div className="signup-content animate-fade-in-up">
        <h1 className="signup-heading">Create Account</h1>
        <p className="signup-subtitle">Join India's cleanest community</p>

        <div className="signup-form">
          <div className="signup-field">
            <label>Full Name</label>
            <div className="signup-input">
              <span className="input-icon">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
              </span>
              <input type="text" placeholder="Enter your name" value={name} onChange={(e) => setName(sanitize(e.target.value).slice(0, 50))} maxLength={50} id="input-name" />
            </div>
          </div>

          <div className="signup-field">
            <label>Email Address</label>
            <div className="signup-input">
              <span className="input-icon">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><rect x="2" y="4" width="20" height="16" rx="2"/><path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/></svg>
              </span>
              <input type="email" placeholder="your@email.com" value={email} onChange={(e) => setEmail(sanitize(e.target.value).slice(0, 100))} maxLength={100} id="input-email" />
            </div>
          </div>

          <div className="signup-field">
            <label>Phone Number</label>
            <div className="signup-input">
              <span className="input-icon">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72c.127.96.361 1.903.7 2.81a2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0 1 22 16.92z"/></svg>
              </span>
              <input type="tel" placeholder="+91 00000 00000" value={phone} onChange={(e) => setPhone(e.target.value.replace(/[^0-9\s+]/g, '').slice(0, 14))} maxLength={14} id="input-phone-signup" />
            </div>
          </div>
        </div>

        <div className="signup-cta">
          <button className="btn btn-primary" onClick={handleSendOTP} disabled={!isValid} id="btn-send-otp">
            Send OTP
          </button>
        </div>

        <div className="signup-divider">Or continue with</div>

        <div className="signup-social">
          <button className="signup-social-btn" id="btn-google-signup">
            <span className="signup-social-icon">
              <svg viewBox="0 0 24 24" width="20" height="20">
                <path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92a5.06 5.06 0 0 1-2.2 3.32v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.1z" fill="#4285F4"/>
                <path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853"/>
                <path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z" fill="#FBBC05"/>
                <path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335"/>
              </svg>
            </span>
            Continue with Google
          </button>

          <button className="signup-social-btn apple" id="btn-apple-signup">
            <span className="signup-social-icon">
              <svg viewBox="0 0 24 24" width="20" height="20" fill="white">
                <path d="M17.05 20.28c-.98.95-2.05.88-3.08.4-1.09-.5-2.08-.48-3.24 0-1.44.62-2.2.44-3.06-.4C2.79 15.25 3.51 7.59 9.05 7.31c1.35.07 2.29.74 3.08.8 1.18-.24 2.31-.93 3.57-.84 1.51.12 2.65.72 3.4 1.8-3.12 1.87-2.38 5.98.48 7.13-.57 1.5-1.31 2.99-2.54 4.09zM12.03 7.25c-.15-2.23 1.66-4.07 3.74-4.25.29 2.58-2.34 4.5-3.74 4.25z"/>
              </svg>
            </span>
            Continue with Apple
          </button>
        </div>

        <p className="signup-terms">
          By signing in, you agree to our <a href="#tos">Terms of Service</a> and <a href="#privacy">Privacy Policy</a>
        </p>

        <p className="signup-login-link">
          Already have an account? <a href="#" onClick={(e) => { e.preventDefault(); navigate('/login'); }}>Log in</a>
        </p>
      </div>
    </div>
  );
}
