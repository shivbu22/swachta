import React from 'react';
import { useNavigate } from 'react-router-dom';
import './SubPage.css';

export default function About() {
  const navigate = useNavigate();

  return (
    <div className="page" id="about-screen">
      <div className="sub-header">
        <button className="sub-back" onClick={() => navigate(-1)}>
          <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="m15 18-6-6 6-6"/></svg>
        </button>
        <h1 className="sub-header-title">About</h1>
      </div>

      <div className="sub-content">
        <div className="sub-about-card animate-fade-in-up">
          <div className="sub-about-logo">SWACHTA</div>
          <div className="sub-about-version">Version 1.0.0 (Pilot)</div>
          <p className="sub-about-desc">
            Swachta is India's first on-demand sanitation platform, connecting trained sanitation workers with households and businesses for efficient, eco-friendly waste management.
          </p>
          <p className="sub-about-desc">
            Founded by <strong>Shivam Yadav</strong>, our mission is to make every street cleaner, every community greener, and every piece of waste a step toward a sustainable future.
          </p>
        </div>

        <div className="sub-about-card animate-fade-in-up delay-1">
          <div className="sub-about-links">
            <span className="sub-about-link">🌐  Website</span>
            <span className="sub-about-link">📜  Terms of Service</span>
            <span className="sub-about-link">🔒  Privacy Policy</span>
            <span className="sub-about-link">📋  Open Source Licenses</span>
          </div>
        </div>

        <div style={{ textAlign: 'center', padding: '24px 0' }}>
          <p style={{ font: 'var(--font-caption)', color: 'var(--color-text-muted)', lineHeight: 1.6 }}>
            Made with 💚 in India<br />
            © 2025 Swachta. All rights reserved.
          </p>
        </div>
      </div>
    </div>
  );
}
