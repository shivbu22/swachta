import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useApp } from '../context/AppContext';
import './SubPage.css';

export default function DeleteAccount() {
  const navigate = useNavigate();
  const { logout } = useApp();
  const [confirmed, setConfirmed] = useState(false);

  const handleDelete = () => {
    if (!confirmed) return;
    // In production: API call to delete account
    logout();
    navigate('/', { replace: true });
  };

  return (
    <div className="page" id="delete-account-screen">
      <div className="sub-header">
        <button className="sub-back" onClick={() => navigate(-1)}>
          <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="m15 18-6-6 6-6"/></svg>
        </button>
        <h1 className="sub-header-title">Delete Account</h1>
      </div>

      <div className="sub-content">
        <div className="sub-delete-warning animate-fade-in-up">
          <h3>⚠️ This action is permanent</h3>
          <p>Deleting your account will:</p>
          <ul>
            <li>Remove all your personal data</li>
            <li>Cancel all pending bookings</li>
            <li>Forfeit all earned carbon credits</li>
            <li>Remove your impact history</li>
            <li>Delete saved addresses and payment methods</li>
          </ul>
        </div>

        <div
          className="sub-delete-checkbox animate-fade-in-up delay-1"
          onClick={() => setConfirmed(!confirmed)}
        >
          <div className={`sub-delete-checkbox-box ${confirmed ? 'checked' : ''}`}>
            {confirmed && (
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="white" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
            )}
          </div>
          <span>I understand that this action cannot be undone and all my data will be permanently deleted.</span>
        </div>

        <button
          className="btn btn-danger"
          onClick={handleDelete}
          disabled={!confirmed}
          id="btn-confirm-delete"
          style={{ marginTop: 8 }}
        >
          Delete My Account
        </button>

        <button className="btn btn-ghost" onClick={() => navigate(-1)} id="btn-cancel-delete" style={{ marginTop: -8 }}>
          Cancel
        </button>
      </div>
    </div>
  );
}
