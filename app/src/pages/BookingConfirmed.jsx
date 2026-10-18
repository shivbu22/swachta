import React from 'react';
import { useNavigate } from 'react-router-dom';
import './BookingConfirmed.css';

export default function BookingConfirmed() {
  const navigate = useNavigate();

  return (
    <div className="confirmed-page" id="booking-confirmed-screen">
      <div className="confirmed-badge">
        <svg className="confirmed-check" viewBox="0 0 60 60" fill="none">
          <circle cx="30" cy="30" r="28" fill="rgba(21,130,99,0.1)" stroke="#158263" strokeWidth="2"/>
          <path d="M18 30L26 38L42 22" stroke="#158263" strokeWidth="3.5" strokeLinecap="round" strokeLinejoin="round" fill="none"/>
        </svg>
      </div>

      <h1 className="confirmed-title animate-fade-in-up">Booking Confirmed!</h1>
      <p className="confirmed-subtitle animate-fade-in-up delay-1">
        Your waste collection service has been successfully booked
      </p>

      <div className="confirmed-details animate-fade-in-up delay-2">
        <h3>Booking Details</h3>

        <div className="confirmed-detail-row">
          <div className="confirmed-detail-icon">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
          </div>
          <div>
            <div className="confirmed-detail-label">Service</div>
            <div className="confirmed-detail-value">Daily Garbage - One-time Service</div>
          </div>
        </div>

        <div className="confirmed-detail-row">
          <div className="confirmed-detail-icon">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
          </div>
          <div>
            <div className="confirmed-detail-label">Date & Time</div>
            <div className="confirmed-detail-value">May 31, 2026 • 6:00 AM - 8:00 AM</div>
          </div>
        </div>

        <div className="confirmed-detail-row">
          <div className="confirmed-detail-icon">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
          </div>
          <div>
            <div className="confirmed-detail-label">Location</div>
            <div className="confirmed-detail-value">Sec - 76, Noida</div>
          </div>
        </div>

        <div className="confirmed-detail-row">
          <div className="confirmed-detail-icon">₹</div>
          <div>
            <div className="confirmed-detail-label">Amount Paid</div>
            <div className="confirmed-detail-value">₹149</div>
          </div>
        </div>
      </div>

      <div className="confirmed-actions">
        <button className="btn btn-outline" id="btn-download-receipt">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
          Download Receipt
        </button>
        <button className="confirmed-home-link" onClick={() => navigate('/home', { replace: true })} id="btn-go-home">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/></svg>
          Go to Home
        </button>
      </div>
    </div>
  );
}
