import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import BottomNav from '../components/BottomNav';
import './Reels.css';
import './SubPage.css';

const reelsData = [
  {
    id: 1,
    user: 'GreenTeam',
    initials: 'GT',
    caption: 'Community tree planting drive in Noida! Together we planted 50 saplings in just 2 hours 🌳🌱',
    likes: 234,
    comments: 18,
    image: '/images/reels-bg.png',
  },
  {
    id: 2,
    user: 'EcoWarrior',
    initials: 'EW',
    caption: "Amazing transformation! This area was full of garbage last month. Look at it now! ♻️",
    likes: 512,
    comments: 42,
    image: '/images/onboarding-1.png',
  },
];

export default function Reels() {
  const navigate = useNavigate();
  const [currentReel, setCurrentReel] = useState(0);
  const [liked, setLiked] = useState({});

  const reel = reelsData[currentReel];

  const toggleLike = (id) => {
    setLiked(prev => ({ ...prev, [id]: !prev[id] }));
  };

  return (
    <div className="reels-page page-with-nav" id="reels-screen">
      {/* Header */}
      <div className="reels-header">
        <h1 className="reels-header-title">Reels</h1>
        <button className="reels-header-btn" aria-label="Camera">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
            <path d="M14.5 4h-5L7 7H4a2 2 0 0 0-2 2v9a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2h-3l-2.5-3z"/>
            <circle cx="12" cy="13" r="3"/>
          </svg>
        </button>
      </div>

      {/* Reel card */}
      <div className="reels-card" key={reel.id}>
        <img src={reel.image} alt={reel.caption} draggable={false} />
        <div className="reels-overlay"></div>

        {/* Actions */}
        <div className="reels-actions">
          <button className="reels-action-btn" onClick={() => toggleLike(reel.id)}>
            <div className="reels-action-icon">
              <svg width="20" height="20" viewBox="0 0 24 24" fill={liked[reel.id] ? '#E5484D' : 'none'} stroke={liked[reel.id] ? '#E5484D' : 'currentColor'} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
              </svg>
            </div>
            <span className="reels-action-count">{reel.likes + (liked[reel.id] ? 1 : 0)}</span>
          </button>

          <button className="reels-action-btn">
            <div className="reels-action-icon">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>
              </svg>
            </div>
            <span className="reels-action-count">{reel.comments}</span>
          </button>

          <button className="reels-action-btn">
            <div className="reels-action-icon">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <circle cx="18" cy="5" r="3"/><circle cx="6" cy="12" r="3"/><circle cx="18" cy="19" r="3"/>
                <line x1="8.59" y1="13.51" x2="15.42" y2="17.49"/><line x1="15.41" y1="6.51" x2="8.59" y2="10.49"/>
              </svg>
            </div>
            <span className="reels-action-count">Share</span>
          </button>
        </div>

        {/* Content */}
        <div className="reels-content">
          <div className="reels-user">
            <div className="reels-user-avatar">{reel.initials}</div>
            <span className="reels-user-name">@{reel.user}</span>
          </div>
          <p className="reels-caption">{reel.caption}</p>
        </div>
      </div>

      <BottomNav active="reels" />
    </div>
  );
}
