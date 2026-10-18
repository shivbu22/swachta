import React from 'react';
import { useNavigate } from 'react-router-dom';
import { useApp } from '../context/AppContext';
import './LocationAccess.css';

export default function LocationAccess() {
  const navigate = useNavigate();
  const { setLocation } = useApp();

  const handleDetect = () => {
    // Simulate location detection
    setLocation({ area: 'Sec - 76', city: 'Noida', full: 'G-2129, Amrapali Silicon City, Sector 76, Noida - 201309' });
    navigate('/home', { replace: true });
  };

  const handleManual = () => {
    setLocation({ area: 'Sec - 76', city: 'Noida', full: 'G-2129, Amrapali Silicon City, Sector 76, Noida - 201309' });
    navigate('/home', { replace: true });
  };

  return (
    <div className="location-page" id="location-screen">
      <div className="location-icon-wrap">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
          <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/>
          <circle cx="12" cy="10" r="3"/>
        </svg>
      </div>

      <h1 className="location-title">Enable Location Access</h1>
      <p className="location-desc">
        We need your location to provide the best waste collection service in your area
      </p>

      <div className="location-actions">
        <button className="btn btn-primary" onClick={handleDetect} id="btn-detect-location">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
            <polygon points="3 11 22 2 13 21 11 13 3 11"/>
          </svg>
          Detect My Location
        </button>

        <div className="location-divider">or</div>

        <button className="btn btn-outline" onClick={handleManual} id="btn-manual-location">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
            <circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/>
          </svg>
          Enter Location Manually
        </button>
      </div>
    </div>
  );
}
