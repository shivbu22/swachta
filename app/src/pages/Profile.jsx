import React from 'react';
import { useNavigate } from 'react-router-dom';
import { useApp } from '../context/AppContext';
import BottomNav from '../components/BottomNav';
import './Profile.css';

const menuItems = [
  { label: 'Personal Details', desc: 'Name, email, phone', path: '/profile/personal-details', icon: <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg> },
  { label: 'Saved Addresses', desc: 'Home, work addresses', path: '/profile/saved-addresses', icon: <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg> },
  { label: 'Payment Methods', desc: 'UPI, cards, wallets', path: '/payment', icon: <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><rect x="1" y="4" width="22" height="16" rx="2" ry="2"/><line x1="1" y1="10" x2="23" y2="10"/></svg> },
  { label: 'Rewards', desc: 'Credits & referrals', path: '/profile/rewards', icon: <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><circle cx="12" cy="8" r="7"/><polyline points="8.21 13.89 7 23 12 20 17 23 15.79 13.88"/></svg> },
  { label: 'Support', desc: 'Help & FAQ', path: '/profile/support', icon: <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><circle cx="12" cy="12" r="10"/><path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg> },
  { label: 'About', desc: 'About Swachta', path: '/profile/about', icon: <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="12"/><line x1="12" y1="8" x2="12.01" y2="8"/></svg> },
  { label: 'Account & Security', desc: 'Password, 2FA', path: '/profile/account-security', icon: <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg> },
];

const Chevron = () => (
  <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="m9 18 6-6-6-6"/></svg>
);

export default function Profile() {
  const navigate = useNavigate();
  const { user, logout } = useApp();
  const initials = user.name ? user.name.split(' ').map(n => n[0]).join('').slice(0, 2).toUpperCase() : 'SP';

  const handleLogout = () => {
    logout();
    navigate('/', { replace: true });
  };

  return (
    <div className="profile-page page-with-nav" id="profile-screen">
      <div className="profile-card animate-fade-in">
        <div className="profile-avatar">{initials}</div>
        <h1 className="profile-name">{user.name}</h1>
        <p className="profile-phone">{user.phone}</p>
        <div className="profile-level-badge">
          <span>🌿</span>
          <span>{user.impactLevel} — {user.carbonCredits.toLocaleString()} Credits</span>
        </div>
      </div>

      <div className="profile-menu">
        <div className="profile-menu-section">
          {menuItems.map((item, i) => (
            <div
              key={i}
              className={`profile-menu-item animate-fade-in-up delay-${Math.min(i + 1, 6)}`}
              onClick={() => navigate(item.path)}
              id={`menu-${item.label.toLowerCase().replace(/\s+/g, '-')}`}
            >
              <div className="profile-menu-icon">{item.icon}</div>
              <div className="profile-menu-content">
                <div className="profile-menu-label">{item.label}</div>
                <div className="profile-menu-desc">{item.desc}</div>
              </div>
              <span className="profile-menu-chevron"><Chevron /></span>
            </div>
          ))}
        </div>

        <div className="profile-menu-item" onClick={() => navigate('/profile/delete-account')} id="menu-delete-account">
          <div className="profile-menu-icon red">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>
          </div>
          <div className="profile-menu-content">
            <div className="profile-menu-label red">Delete Account</div>
          </div>
          <span className="profile-menu-chevron"><Chevron /></span>
        </div>
      </div>

      <div className="profile-logout" onClick={handleLogout} id="btn-logout">
        Log Out
      </div>

      <p className="profile-version">Version 1.0.0 (Pilot)</p>

      <BottomNav active="profile" />
    </div>
  );
}
