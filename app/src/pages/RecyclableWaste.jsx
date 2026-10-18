import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useApp } from '../context/AppContext';
import './ServicePage.css';

const categories = [
  { id: 1, name: 'Plastic', icon: '♻️', color: 'blue' },
  { id: 2, name: 'Glass', icon: '🫙', color: 'green' },
  { id: 3, name: 'Metal', icon: '🥫', color: 'amber' },
  { id: 4, name: 'Paper', icon: '📄', color: 'gray' },
];

export default function RecyclableWaste() {
  const [selected, setSelected] = useState([1, 2]);
  const navigate = useNavigate();
  const { location, addBooking } = useApp();

  const toggleCategory = (id) => {
    setSelected(prev => prev.includes(id) ? prev.filter(i => i !== id) : [...prev, id]);
  };

  const handleBook = () => {
    addBooking({ service: 'Recyclable Waste', price: 99, status: 'Pending', type: 'recyclable' });
    navigate('/booking-confirmed');
  };

  return (
    <div className="page" id="recyclable-waste-screen">
      <div className="service-header">
        <button className="service-back" onClick={() => navigate(-1)} aria-label="Back">
          <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round"><path d="m15 18-6-6 6-6"/></svg>
        </button>
        <h1 className="service-header-title">Recyclable Waste</h1>
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
        </div>

        <div className="service-materials animate-fade-in-up delay-1">
          <div className="service-materials-header">
            <div className="service-materials-icon">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/></svg>
            </div>
            <div className="service-materials-info">
              <h3>Select Categories</h3>
              <p>Choose the types of recyclable waste you have.</p>
            </div>
          </div>

          {categories.map((cat) => (
            <div key={cat.id} className="material-row" onClick={() => toggleCategory(cat.id)} style={{ cursor: 'pointer' }}>
              <div className={`material-icon ${cat.color}`}>{cat.icon}</div>
              <div className="material-info">
                <div className="material-name">{cat.name}</div>
              </div>
              <div style={{ width: 24, height: 24, borderRadius: 6, border: `2px solid ${selected.includes(cat.id) ? '#158263' : '#dce7dc'}`, background: selected.includes(cat.id) ? '#158263' : 'white', display: 'flex', alignItems: 'center', justifyContent: 'center', transition: 'all 0.2s' }}>
                {selected.includes(cat.id) && (
                  <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="white" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
                )}
              </div>
            </div>
          ))}
        </div>

        <div className="service-option animate-fade-in-up delay-2">
          <div className="service-option-info">
            <h3>One-time Pickup</h3>
            <div className="service-option-time">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
              30-45 min
            </div>
          </div>
          <div className="service-option-price">₹99</div>
        </div>
      </div>

      <div className="service-bottom">
        <button className="btn btn-primary" onClick={handleBook} disabled={selected.length === 0} id="btn-book-recyclable" style={{ flex: 1 }}>
          Book Pickup
        </button>
      </div>
    </div>
  );
}
