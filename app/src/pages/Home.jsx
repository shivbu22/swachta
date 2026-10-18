import React from 'react';
import { useNavigate } from 'react-router-dom';
import { useApp } from '../context/AppContext';
import BottomNav from '../components/BottomNav';
import './Home.css';

const services = [
  { id: 'daily-garbage', name: 'Daily Garbage', image: '/images/service-daily.png', path: '/service/daily-garbage' },
  { id: 'scrap-items', name: 'Scrap Materials', image: '/images/service-scrap.png', path: '/service/scrap-items' },
  { id: 'recyclable', name: 'Recyclable Waste', image: '/images/service-recyclable.png', path: '/service/recyclable-waste' },
  { id: 'large-dump', name: 'Large Dump', image: '/images/service-large-dump.png', path: '/service/large-dump' },
];

export default function Home() {
  const navigate = useNavigate();
  const { user, location } = useApp();

  const initials = user.name ? user.name.split(' ').map(n => n[0]).join('').slice(0, 2).toUpperCase() : 'SP';

  return (
    <div className="home-page page-with-nav" id="home-screen">
      {/* Header */}
      <div className="home-header animate-fade-in-down">
        <div className="home-location" onClick={() => navigate('/location')}>
          <span className="home-location-label">Current Location</span>
          <span className="home-location-value">
            {location.area}, {location.city}
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
              <path d="m6 9 6 6 6-6"/>
            </svg>
          </span>
        </div>
        <div className="home-avatar" onClick={() => navigate('/profile')}>
          {initials}
        </div>
      </div>

      {/* Search */}
      <div className="home-search animate-fade-in-up delay-1">
        <span className="home-search-icon">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
            <circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/>
          </svg>
        </span>
        <input type="text" placeholder="Search services..." readOnly />
        <div className="home-search-camera" onClick={() => navigate('/camera')}>
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
            <path d="M14.5 4h-5L7 7H4a2 2 0 0 0-2 2v9a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2h-3l-2.5-3z"/>
            <circle cx="12" cy="13" r="3"/>
          </svg>
        </div>
      </div>

      {/* Special Offers */}
      <div className="home-section-header" style={{ padding: '0 20px', marginTop: '8px' }}>
        <h2 className="home-section-title">Special Offers</h2>
        <span className="home-section-link">See more</span>
      </div>
      <div className="home-offers animate-fade-in-up delay-2" style={{ marginTop: '12px' }}>
        <div className="home-offer-card">
          <img src="/images/offer-banner.png" alt="Special Offer" />
          <div className="home-offer-overlay">
            <span className="home-offer-title">First Pickup Free!</span>
            <span className="home-offer-desc">Book your first garbage pickup for free. Limited time offer.</span>
          </div>
        </div>
        <div className="home-offer-card">
          <div className="home-offer-overlay" style={{ background: 'linear-gradient(135deg, rgba(21, 130, 99, 0.95) 0%, rgba(27, 56, 44, 0.9) 100%)' }}>
            <span className="home-offer-title">Refer & Earn ₹100</span>
            <span className="home-offer-desc">Invite friends and earn carbon credits on every booking.</span>
          </div>
        </div>
      </div>

      {/* Our Services */}
      <div className="home-section animate-fade-in-up delay-3">
        <div className="home-section-header">
          <h2 className="home-section-title">Our Services</h2>
        </div>
        <div className="home-services-grid">
          {services.map((s) => (
            <div
              key={s.id}
              className="home-service-card"
              onClick={() => navigate(s.path)}
              id={`service-card-${s.id}`}
            >
              <img src={s.image} alt={s.name} loading="lazy" />
              <div className="home-service-label">{s.name}</div>
            </div>
          ))}
        </div>
      </div>

      {/* Plant Now */}
      <div className="home-plant-card animate-fade-in-up delay-4">
        <div className="home-plant-icon">🌱</div>
        <div className="home-plant-content">
          <h3>Planting Made Effortless</h3>
          <p>Plant trees with every pickup. Track your forest growing in real-time.</p>
          <button className="home-plant-btn" onClick={() => navigate('/impact')}>
            Plant Now →
          </button>
        </div>
      </div>

      {/* Refer & Earn */}
      <div className="home-refer-card animate-fade-in-up delay-5">
        <div className="home-refer-content">
          <h3>Refer & Earn</h3>
          <p>Share your code with friends and earn rewards together</p>
          <button className="home-refer-btn" onClick={() => navigate('/profile/rewards')}>
            SEND CODE →
          </button>
        </div>
        <div className="home-refer-illustration">🤝</div>
      </div>

      {/* Brand Footer */}
      <div className="home-brand-footer">
        <p className="home-brand-tagline">
          every piece <strong>RECYCLED</strong>,<br />every future <strong>PROTECTED</strong>
        </p>
        <p className="home-brand-name">SWACHTA</p>
        <p className="home-brand-trust">Trusted by 200k+ Eco-Warriors</p>
      </div>

      <BottomNav active="home" />
    </div>
  );
}
