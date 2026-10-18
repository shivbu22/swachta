import React from 'react';
import { useNavigate } from 'react-router-dom';
import { useApp } from '../context/AppContext';
import BottomNav from '../components/BottomNav';
import './Impact.css';

const milestones = [
  { name: 'First Pickup', desc: 'Complete your first garbage pickup', icon: '🚛', done: true, color: 'green' },
  { name: 'Eco Warrior', desc: 'Recycle 50 kg of waste', icon: '♻️', done: true, color: 'green' },
  { name: 'Tree Planter', desc: 'Plant your first tree', icon: '🌱', done: true, color: 'green' },
  { name: 'Community Hero', desc: 'Refer 5 friends', icon: '👥', done: false, color: 'amber' },
  { name: 'Carbon Neutral', desc: 'Offset 100 kg CO₂', icon: '🌍', done: false, color: 'gray' },
];

export default function Impact() {
  const navigate = useNavigate();
  const { user } = useApp();

  const progressPercent = Math.min((user.impactPoints / 2000) * 100, 100);

  return (
    <div className="impact-page page-with-nav" id="impact-screen">
      {/* Header */}
      <div className="impact-header">
        <div className="impact-header-row">
          <h1 className="impact-header-title">My Impact</h1>
          <div className="impact-credits-badge">
            <span>🍃</span>
            <span>{user.carbonCredits.toLocaleString()} Credits</span>
          </div>
        </div>

        <div className="impact-level-section">
          <div className="impact-tree-icon">🌳</div>
          <h2 className="impact-level-name">{user.impactLevel}</h2>
          <p className="impact-level-desc">Growing your green footprint</p>

          <div className="impact-progress">
            <div className="impact-progress-bar">
              <div className="impact-progress-fill" style={{ width: `${progressPercent}%` }}></div>
            </div>
            <div className="impact-progress-labels">
              <span>{user.impactPoints} pts</span>
              <span>2,000 pts</span>
            </div>
          </div>
        </div>
      </div>

      {/* Stats */}
      <div className="impact-stats">
        <div className="impact-stat animate-fade-in-up delay-1">
          <div className="impact-stat-value">{user.treesPlanted}</div>
          <div className="impact-stat-label">Trees Planted</div>
        </div>
        <div className="impact-stat animate-fade-in-up delay-2">
          <div className="impact-stat-value">{user.wasteRecycled} kg</div>
          <div className="impact-stat-label">Recycled</div>
        </div>
        <div className="impact-stat animate-fade-in-up delay-3">
          <div className="impact-stat-value">{user.co2Prevented} kg</div>
          <div className="impact-stat-label">CO₂ Saved</div>
        </div>
      </div>

      {/* Milestones */}
      <div className="impact-milestones">
        <h3 className="impact-milestones-title">Milestones</h3>
        {milestones.map((m, i) => (
          <div key={i} className={`impact-milestone animate-fade-in-up delay-${Math.min(i + 1, 6)}`}>
            <div className={`impact-milestone-icon ${m.color}`}>{m.icon}</div>
            <div className="impact-milestone-info">
              <div className="impact-milestone-name">{m.name}</div>
              <div className="impact-milestone-desc">{m.desc}</div>
            </div>
            <div className={`impact-milestone-check ${m.done ? 'done' : 'pending'}`}>
              {m.done && (
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
              )}
            </div>
          </div>
        ))}
      </div>

      <BottomNav active="impact" />
    </div>
  );
}
