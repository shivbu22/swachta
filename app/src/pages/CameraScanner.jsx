import React from 'react';
import { useNavigate } from 'react-router-dom';
import './CameraScanner.css';

export default function CameraScanner() {
  const navigate = useNavigate();

  const handleCapture = () => {
    // Simulate AI analysis then navigate to scrap items
    navigate('/service/scrap-items');
  };

  return (
    <div className="camera-page" id="camera-screen">
      {/* Background */}
      <div className="camera-bg">
        <img src="/images/service-large-dump.png" alt="" aria-hidden="true" />
      </div>

      <div className="camera-overlay">
        {/* Top controls */}
        <div className="camera-top">
          <button className="camera-top-btn" onClick={() => navigate(-1)} aria-label="Close">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
          </button>
          <button className="camera-top-btn" aria-label="Flash">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/></svg>
          </button>
        </div>

        {/* Prompt */}
        <div className="camera-prompt">
          <div className="camera-prompt-card">
            <div className="camera-prompt-icon">
              <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round">
                <path d="M14.5 4h-5L7 7H4a2 2 0 0 0-2 2v9a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2h-3l-2.5-3z"/>
                <circle cx="12" cy="13" r="3"/>
              </svg>
            </div>
            <h2 className="camera-prompt-title">Click Image of Your Garbage</h2>
            <p className="camera-prompt-desc">We'll analyze it to determine the right vehicle for pickup</p>
          </div>
        </div>

        {/* Info banner */}
        <div className="camera-info">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" style={{ flexShrink: 0 }}><circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="12"/><line x1="12" y1="8" x2="12.01" y2="8"/></svg>
          Make sure the garbage is clearly visible in the frame for accurate detection
        </div>

        {/* Bottom controls */}
        <div className="camera-bottom">
          <button className="camera-gallery-btn" aria-label="Gallery">
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><rect x="3" y="3" width="18" height="18" rx="2" ry="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/></svg>
          </button>
          <button className="camera-shutter" onClick={handleCapture} id="btn-capture" aria-label="Capture"></button>
          <div style={{ width: 44 }}></div>
        </div>
      </div>
    </div>
  );
}
