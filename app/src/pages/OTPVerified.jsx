import React from 'react';
import { useNavigate } from 'react-router-dom';
import { useApp } from '../context/AppContext';
import './OTPVerified.css';

export default function OTPVerified() {
  const navigate = useNavigate();
  const { login } = useApp();

  const handleDashboard = () => {
    login();
    navigate('/location', { replace: true });
  };

  const handleProfile = () => {
    login();
    navigate('/profile/personal-details', { replace: true });
  };

  return (
    <div className="verified-page" id="verified-screen">
      <div className="verified-badge">
        <svg className="verified-check" viewBox="0 0 60 60" fill="none">
          <circle cx="30" cy="30" r="28" stroke="#158263" strokeWidth="2.5" fill="rgba(21,130,99,0.06)" />
          <path d="M18 30L26 38L42 22" stroke="#158263" strokeWidth="3.5" strokeLinecap="round" strokeLinejoin="round" fill="none" />
        </svg>
      </div>

      <h1 className="verified-title">Verified!</h1>
      <p className="verified-subtitle">
        Your phone number has been successfully verified
      </p>

      <div className="verified-actions">
        <button className="btn btn-primary" onClick={handleDashboard} id="btn-go-dashboard">
          Proceed to Dashboard
        </button>
        <button className="btn btn-outline" onClick={handleProfile} id="btn-complete-profile">
          Complete Profile
        </button>
      </div>
    </div>
  );
}
