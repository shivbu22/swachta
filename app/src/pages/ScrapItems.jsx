import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useApp } from '../context/AppContext';
import './ServicePage.css';

const defaultMaterials = [
  { id: 1, name: 'Plastic Bottles', confidence: 95, icon: '♻️', color: 'blue' },
  { id: 2, name: 'Cardboard', confidence: 92, icon: '📦', color: 'green' },
  { id: 3, name: 'Aluminum Cans', confidence: 88, icon: '🥫', color: 'blue' },
  { id: 4, name: 'Newspapers', confidence: 85, icon: '📰', color: 'gray' },
  { id: 5, name: 'Electronics', confidence: 78, icon: '💻', color: 'amber' },
];

export default function ScrapItems() {
  const [materials, setMaterials] = useState(defaultMaterials);
  const navigate = useNavigate();
  const { location, addBooking } = useApp();

  const totalValue = 430;

  const removeMaterial = (id) => {
    setMaterials(prev => prev.filter(m => m.id !== id));
  };

  const handleBook = () => {
    addBooking({ service: 'Scrap Material', price: -totalValue, status: 'Pending', type: 'scrap', earned: true });
    navigate('/booking-confirmed');
  };

  return (
    <div className="page" id="scrap-items-screen">
      <div className="service-header">
        <button className="service-back" onClick={() => navigate(-1)} aria-label="Back">
          <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round"><path d="m15 18-6-6 6-6"/></svg>
        </button>
        <h1 className="service-header-title">Scrap Items</h1>
      </div>

      <div className="service-content">
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

        <div className="service-materials animate-fade-in-up delay-1">
          <div className="service-materials-header">
            <div className="service-materials-icon">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/></svg>
            </div>
            <div className="service-materials-info">
              <h3>Detected Materials</h3>
              <p>Review the detected items and remove anything that's incorrect.</p>
            </div>
          </div>

          {materials.map((m) => (
            <div key={m.id} className="material-row">
              <div className={`material-icon ${m.color}`}>{m.icon}</div>
              <div className="material-info">
                <div className="material-name">{m.name}</div>
                <div className="material-confidence">{m.confidence}% confident</div>
              </div>
              <button className="material-delete" onClick={() => removeMaterial(m.id)} aria-label={`Remove ${m.name}`}>
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>
              </button>
            </div>
          ))}

          <div className="service-total">
            <span className="service-total-label">Total Estimated Value</span>
            <span className="service-total-value">₹{totalValue}</span>
          </div>
        </div>

        <div className="service-info-banner animate-fade-in-up delay-2">
          <div className="service-info-icon">ℹ</div>
          <div className="service-info-text">
            <strong>Not seeing something?</strong>
            <span>Add more</span>
          </div>
        </div>
      </div>

      <div className="service-bottom">
        <button className="btn btn-primary" onClick={handleBook} id="btn-book-scrap" style={{ flex: 1 }}>
          Book Service
        </button>
      </div>
    </div>
  );
}
