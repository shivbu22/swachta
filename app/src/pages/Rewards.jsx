import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useApp } from '../context/AppContext';
import './SubPage.css';

const historyData = [
  { id: 1, name: 'Daily Garbage Pickup', date: '12 Jun 2025', amount: '+50', icon: '🚛', positive: true },
  { id: 2, name: 'Referral Bonus', date: '10 Jun 2025', amount: '+100', icon: '🤝', positive: true },
  { id: 3, name: 'Tree Planted', date: '8 Jun 2025', amount: '-200', icon: '🌱', positive: false },
  { id: 4, name: 'Scrap Recycled', date: '5 Jun 2025', amount: '+80', icon: '♻️', positive: true },
  { id: 5, name: 'Weekly Streak', date: '1 Jun 2025', amount: '+150', icon: '🔥', positive: true },
];

export default function Rewards() {
  const navigate = useNavigate();
  const { user } = useApp();
  const [copied, setCopied] = useState(false);

  const handleCopy = () => {
    if (navigator.clipboard && user.referralCode) {
      navigator.clipboard.writeText(user.referralCode).catch(() => {});
    }
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  return (
    <div className="page" id="rewards-screen">
      {/* Green header with balance */}
      <div className="rewards-header">
        <div style={{ display: 'flex', alignItems: 'center', gap: 12, marginBottom: 16 }}>
          <button className="sub-back" onClick={() => navigate(-1)} style={{ color: 'white' }}>
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="m15 18-6-6 6-6"/></svg>
          </button>
          <span style={{ fontSize: '1.25rem', fontWeight: 700 }}>Rewards</span>
        </div>
        <div className="rewards-balance">
          <div className="rewards-balance-value">{user.carbonCredits.toLocaleString()}</div>
          <div className="rewards-balance-label">Carbon Credits Available</div>
        </div>
      </div>

      <div className="sub-content">
        {/* Referral card */}
        <div className="rewards-referral-card animate-fade-in-up">
          <h3>Refer & Earn</h3>
          <p>Share your code with friends. You both earn 100 credits!</p>
          <div className="rewards-code">
            <span className="rewards-code-text">{user.referralCode}</span>
            <button className="rewards-code-copy" onClick={handleCopy} aria-label="Copy code">
              {copied ? (
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
              ) : (
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><rect x="9" y="9" width="13" height="13" rx="2" ry="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg>
              )}
            </button>
          </div>
          <button className="btn btn-primary btn-sm" id="btn-share-code">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><circle cx="18" cy="5" r="3"/><circle cx="6" cy="12" r="3"/><circle cx="18" cy="19" r="3"/><line x1="8.59" y1="13.51" x2="15.42" y2="17.49"/><line x1="15.41" y1="6.51" x2="8.59" y2="10.49"/></svg>
            Share with Friends
          </button>
        </div>

        {/* History */}
        <div className="animate-fade-in-up delay-2">
          <h3 className="rewards-history-title">Rewards History</h3>
          {historyData.map((item) => (
            <div key={item.id} className="rewards-history-item">
              <div className="rewards-history-icon">{item.icon}</div>
              <div className="rewards-history-info">
                <div className="rewards-history-name">{item.name}</div>
                <div className="rewards-history-date">{item.date}</div>
              </div>
              <div className={`rewards-history-amount ${!item.positive ? 'negative' : ''}`}>
                {item.amount}
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
