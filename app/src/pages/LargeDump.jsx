import React from 'react';
import { useNavigate } from 'react-router-dom';
import { useApp } from '../context/AppContext';
import './ServicePage.css';

const slots = ['6:00 am - 8:00 am', '10:00 am - 12:00 pm', '2:00 pm - 4:00 pm', '6:00 pm - 8:00 pm'];

export default function LargeDump() {
  const navigate = useNavigate();
  const { location, selectedSlot, setSelectedSlot, addBooking } = useApp();

  const handlePay = () => {
    addBooking({ service: 'Large Dump', price: 499, status: 'Pending', type: 'large-dump' });
    navigate('/booking-confirmed');
  };

  return (
    <div className="page" id="large-dump-screen">
      <div className="service-header">
        <button className="service-back" onClick={() => navigate(-1)} aria-label="Back">
          <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round"><path d="m15 18-6-6 6-6"/></svg>
        </button>
        <h1 className="service-header-title">Large Dump</h1>
        <div className="service-header-price">₹ 499</div>
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

        <div className="service-pickup-row animate-fade-in-up delay-1">
          <div className="service-pickup-info">
            <h3>One-time Pickup</h3>
            <p>
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
              45-60 min
            </p>
          </div>
          <div className="service-pickup-thumb">
            <img src="/images/service-large-dump.png" alt="Large dump" loading="lazy" />
          </div>
        </div>

        <div className="service-slots animate-fade-in-up delay-2">
          <div className="service-slots-header">
            <span className="service-slots-title">Selected Slot</span>
            <div className="service-location-edit">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
            </div>
          </div>
          <div className="service-slots-grid">
            {slots.map((slot) => (
              <div
                key={slot}
                className={`service-slot ${selectedSlot === slot ? 'active' : ''}`}
                onClick={() => setSelectedSlot(slot)}
              >
                {slot}
              </div>
            ))}
          </div>
        </div>
      </div>

      <div className="service-bottom">
        <div className="service-bottom-method">
          <span className="service-bottom-method-label">Change Method ›</span>
          <span className="service-bottom-method-name">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none"><rect width="24" height="24" rx="4" fill="#4285F4" opacity="0.15"/><text x="4" y="16" fontSize="10" fill="#4285F4" fontWeight="bold">G</text></svg>
            Google Pay
          </span>
        </div>
        <button className="service-bottom-pay" onClick={handlePay} id="btn-pay-large-dump">
          Proceed to pay ₹499
        </button>
      </div>
    </div>
  );
}
