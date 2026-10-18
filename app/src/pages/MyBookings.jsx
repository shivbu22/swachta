import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useApp } from '../context/AppContext';
import BottomNav from '../components/BottomNav';
import './MyBookings.css';

const filters = ['All', 'Ongoing', 'Completed', 'Cancelled'];

export default function MyBookings() {
  const [activeFilter, setActiveFilter] = useState('All');
  const navigate = useNavigate();
  const { bookings } = useApp();

  const filtered = activeFilter === 'All'
    ? bookings
    : bookings.filter(b => b.status === activeFilter);

  const getBadgeClass = (status) => {
    switch (status) {
      case 'Completed': return 'badge-completed';
      case 'Cancelled': return 'badge-cancelled';
      case 'Pending': return 'badge-pending';
      default: return 'badge-ongoing';
    }
  };

  return (
    <div className="bookings-page page-with-nav" id="bookings-screen">
      <div className="bookings-header animate-fade-in-down">
        <div className="bookings-header-left">
          <button className="bookings-back" onClick={() => navigate(-1)}>
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="m15 18-6-6 6-6"/></svg>
          </button>
          <div className="bookings-header-text">
            <h1>My Bookings</h1>
            <p>Track your orders</p>
          </div>
        </div>
        <button className="bookings-filter-btn" aria-label="Filter">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><line x1="4" y1="21" x2="4" y2="14"/><line x1="4" y1="10" x2="4" y2="3"/><line x1="12" y1="21" x2="12" y2="12"/><line x1="12" y1="8" x2="12" y2="3"/><line x1="20" y1="21" x2="20" y2="16"/><line x1="20" y1="12" x2="20" y2="3"/></svg>
        </button>
      </div>

      <div className="bookings-chips">
        {filters.map(f => (
          <button key={f} className={`bookings-chip ${activeFilter === f ? 'active' : ''}`} onClick={() => setActiveFilter(f)}>
            {f}
          </button>
        ))}
      </div>

      <div className="bookings-list">
        {filtered.length === 0 ? (
          <div className="bookings-empty animate-fade-in">
            <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="#d1d5db" strokeWidth="1.5"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
            <p>No bookings found</p>
          </div>
        ) : (
          filtered.map((b, i) => (
            <div key={b.id} className={`booking-card animate-fade-in-up delay-${Math.min(i + 1, 6)}`}>
              <div className="booking-card-info">
                <h3>{b.service}</h3>
                <span className="booking-card-price">
                  {b.earned ? '+ ' : ''}₹{Math.abs(b.price).toLocaleString('en-IN')}
                </span>
              </div>
              <div className="booking-card-right">
                <span className={`badge ${getBadgeClass(b.status)}`}>{b.status}</span>
                <div className="booking-card-date">{b.date}</div>
              </div>
            </div>
          ))
        )}
      </div>

      <BottomNav active="bookings" />
    </div>
  );
}
