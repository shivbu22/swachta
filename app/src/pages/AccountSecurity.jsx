import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './SubPage.css';

export default function AccountSecurity() {
  const navigate = useNavigate();
  const [biometric, setBiometric] = useState(true);
  const [notifications, setNotifications] = useState(true);
  const [twoFactor, setTwoFactor] = useState(false);

  return (
    <div className="page" id="account-security-screen">
      <div className="sub-header">
        <button className="sub-back" onClick={() => navigate(-1)}>
          <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="m15 18-6-6 6-6"/></svg>
        </button>
        <h1 className="sub-header-title">Account & Security</h1>
      </div>

      <div className="sub-content">
        <div className="section-label">AUTHENTICATION</div>

        <div className="sub-security-row animate-fade-in-up">
          <div className="sub-security-icon">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
          </div>
          <div className="sub-security-info">
            <div className="sub-security-label">Biometric Login</div>
            <div className="sub-security-desc">Use fingerprint or face ID</div>
          </div>
          <div className={`toggle ${biometric ? 'active' : ''}`} onClick={() => setBiometric(!biometric)}></div>
        </div>

        <div className="sub-security-row animate-fade-in-up delay-1">
          <div className="sub-security-icon">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
          </div>
          <div className="sub-security-info">
            <div className="sub-security-label">Two-Factor Authentication</div>
            <div className="sub-security-desc">Extra layer of security</div>
          </div>
          <div className={`toggle ${twoFactor ? 'active' : ''}`} onClick={() => setTwoFactor(!twoFactor)}></div>
        </div>

        <div className="section-label" style={{ marginTop: 16 }}>NOTIFICATIONS</div>

        <div className="sub-security-row animate-fade-in-up delay-2">
          <div className="sub-security-icon">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg>
          </div>
          <div className="sub-security-info">
            <div className="sub-security-label">Push Notifications</div>
            <div className="sub-security-desc">Booking updates & offers</div>
          </div>
          <div className={`toggle ${notifications ? 'active' : ''}`} onClick={() => setNotifications(!notifications)}></div>
        </div>

        <div className="section-label" style={{ marginTop: 16 }}>ACCOUNT</div>

        <div className="sub-security-row animate-fade-in-up delay-3" onClick={() => navigate('/profile/delete-account')} style={{ cursor: 'pointer' }}>
          <div className="sub-security-icon" style={{ background: 'rgba(229,72,77,0.08)', color: 'var(--color-error)' }}>
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>
          </div>
          <div className="sub-security-info">
            <div className="sub-security-label" style={{ color: 'var(--color-error)' }}>Delete Account</div>
            <div className="sub-security-desc">Permanently delete your account</div>
          </div>
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#9ca3af" strokeWidth="2"><path d="m9 18 6-6-6-6"/></svg>
        </div>
      </div>
    </div>
  );
}
