import React from 'react';
import { useNavigate } from 'react-router-dom';
import { useApp } from '../context/AppContext';
import './SubPage.css';

export default function SavedAddresses() {
  const navigate = useNavigate();
  const { addresses, removeAddress } = useApp();

  return (
    <div className="page" id="saved-addresses-screen">
      <div className="sub-header">
        <button className="sub-back" onClick={() => navigate(-1)}>
          <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="m15 18-6-6 6-6"/></svg>
        </button>
        <h1 className="sub-header-title">Saved Addresses</h1>
      </div>

      <div className="sub-content">
        {addresses.map((addr, i) => (
          <div key={addr.id} className={`sub-address-card animate-fade-in-up delay-${Math.min(i + 1, 4)}`}>
            <div className="sub-address-icon">{addr.type === 'Home' ? '🏠' : '🏢'}</div>
            <div className="sub-address-content">
              <div className="sub-address-type">
                <span>{addr.type}</span>
                {addr.isDefault && <span className="sub-address-default">Default</span>}
              </div>
              <p className="sub-address-text">{addr.address}<br />{addr.city}</p>
            </div>
            <div className="sub-address-actions">
              <button className="sub-address-action" aria-label="Edit">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
              </button>
              <button className="sub-address-action" onClick={() => removeAddress(addr.id)} aria-label="Delete">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>
              </button>
            </div>
          </div>
        ))}

        <button className="btn btn-outline" id="btn-add-address">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
          Add New Address
        </button>
      </div>
    </div>
  );
}
