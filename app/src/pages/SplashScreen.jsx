import React, { useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useApp } from '../context/AppContext';
import './SplashScreen.css';

export default function SplashScreen() {
  const navigate = useNavigate();
  const { isLoggedIn, hasOnboarded } = useApp();

  useEffect(() => {
    const timer = setTimeout(() => {
      if (isLoggedIn) {
        navigate('/home', { replace: true });
      } else if (hasOnboarded) {
        navigate('/login', { replace: true });
      } else {
        navigate('/onboarding', { replace: true });
      }
    }, 2500);
    return () => clearTimeout(timer);
  }, [navigate, isLoggedIn, hasOnboarded]);

  return (
    <div className="splash-page" id="splash-screen">
      <div className="splash-content">
        <div className="splash-logo-ring">
          <svg className="splash-truck" viewBox="0 0 200 160" fill="none">
            {/* Truck body */}
            <rect x="60" y="50" width="90" height="55" rx="6" fill="#1B382C" />
            <rect x="65" y="45" width="80" height="15" rx="4" fill="#158263" />
            {/* Truck cabin */}
            <rect x="130" y="65" width="40" height="40" rx="4" fill="#1B382C" />
            <rect x="138" y="72" width="24" height="18" rx="2" fill="#a7d9c4" />
            {/* Wheels */}
            <circle cx="95" cy="110" r="12" fill="#333" stroke="#555" strokeWidth="3" />
            <circle cx="95" cy="110" r="4" fill="#888" />
            <circle cx="155" cy="110" r="12" fill="#333" stroke="#555" strokeWidth="3" />
            <circle cx="155" cy="110" r="4" fill="#888" />
            {/* Garbage pieces */}
            <rect x="75" y="35" width="12" height="12" rx="2" fill="#22c55e" opacity="0.8" transform="rotate(-15 75 35)" />
            <rect x="100" y="30" width="10" height="14" rx="2" fill="#16a34a" opacity="0.7" transform="rotate(10 100 30)" />
            <rect x="120" y="33" width="8" height="10" rx="2" fill="#4ade80" opacity="0.6" transform="rotate(-8 120 33)" />
            {/* Leaves */}
            <ellipse cx="42" cy="55" rx="8" ry="4" fill="#22c55e" opacity="0.5" transform="rotate(-30 42 55)" />
            <ellipse cx="170" cy="50" rx="7" ry="3.5" fill="#16a34a" opacity="0.4" transform="rotate(20 170 50)" />
          </svg>
        </div>
        <h1 className="splash-title">SWACHTA</h1>
        <p className="splash-tagline">Clean streets. Green future.</p>
        <div className="splash-loader">
          <div className="splash-loader-fill"></div>
        </div>
      </div>
    </div>
  );
}
