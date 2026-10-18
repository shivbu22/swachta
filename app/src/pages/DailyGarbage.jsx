import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useApp } from '../context/AppContext';
import './ServicePage.css';

export default function DailyGarbage() {
  const [tab, setTab] = useState('instant');
  const navigate = useNavigate();
  const { location, addBooking, setCartService } = useApp();

  const handleBook = () => {
    setCartService({ service: 'Daily Garbage - One-time Service', price: 149, type: 'daily' });
    addBooking({ service: 'Daily Garbage - Instant', price: 149, status: 'Completed', type: 'daily' });
    navigate('/booking-confirmed');
  };

  return (
    <div className="page" id="daily-garbage-screen">
      {/* Header */}
      <div className="service-header">
        <button className="service-back" onClick={() => navigate(-1)} aria-label="Back">
          <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round"><path d="m15 18-6-6 6-6"/></svg>
        </button>
        <h1 className="service-header-title">Daily Garbage</h1>
      </div>

      {/* Content */}
      <div className="service-content">
        {/* Location */}
        <div className="service-location-card animate-fade-in-up">
          <div className="service-location-icon">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
          </div>
          <div className="service-location-content">
            <span className="service-location-label">Pickup Location</span>
            <p className="service-location-address">{location.full}</p>
          </div>
          <div className="service-location-edit">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
          </div>
        </div>

        {/* Tabs */}
        <div className="service-tabs animate-fade-in-up delay-1">
          <div className={`service-tab ${tab === 'instant' ? 'active' : ''}`} onClick={() => setTab('instant')}>Instant Service</div>
          <div className={`service-tab ${tab === 'recurring' ? 'active' : ''}`} onClick={() => setTab('recurring')}>Recurring Plans</div>
        </div>

        {/* Option */}
        <div className="service-option animate-fade-in-up delay-2">
          <div className="service-option-info">
            <h3>One-time Service</h3>
            <div className="service-option-time">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
              45-60 min
            </div>
          </div>
          <div className="service-option-price">₹149</div>
        </div>
      </div>

      {/* Bottom CTA */}
      <div className="service-bottom">
        <button className="btn btn-primary" onClick={handleBook} id="btn-book-daily" style={{ flex: 1 }}>
          Book Service
        </button>
      </div>
    </div>
  );
}
