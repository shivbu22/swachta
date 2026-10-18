import React from 'react';
import { useNavigate } from 'react-router-dom';
import { useApp } from '../context/AppContext';
import './SubPage.css';

export default function PersonalDetails() {
  const navigate = useNavigate();
  const { user, updateUser } = useApp();

  const sanitize = (val) => val.replace(/<[^>]*>/g, '').slice(0, 100);

  return (
    <div className="page" id="personal-details-screen">
      <div className="sub-header">
        <button className="sub-back" onClick={() => navigate(-1)}>
          <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="m15 18-6-6 6-6"/></svg>
        </button>
        <h1 className="sub-header-title">Personal Details</h1>
      </div>

      <div className="sub-content animate-fade-in-up">
        <div className="sub-field">
          <label>Full Name</label>
          <input className="sub-input" type="text" value={user.name} onChange={(e) => updateUser({ name: sanitize(e.target.value) })} maxLength={50} />
        </div>
        <div className="sub-field">
          <label>Email Address</label>
          <input className="sub-input" type="email" value={user.email} onChange={(e) => updateUser({ email: sanitize(e.target.value) })} maxLength={100} />
        </div>
        <div className="sub-field">
          <label>Phone Number</label>
          <input className="sub-input" type="tel" value={user.phone} readOnly style={{ opacity: 0.6 }} />
        </div>
        <div className="sub-field">
          <label>Date of Birth</label>
          <input className="sub-input" type="date" value={user.dob} onChange={(e) => updateUser({ dob: e.target.value })} />
        </div>
        <div className="sub-field">
          <label>Gender</label>
          <select className="sub-input" value={user.gender} onChange={(e) => updateUser({ gender: e.target.value })}>
            <option>Female</option>
            <option>Male</option>
            <option>Non-binary</option>
            <option>Prefer not to say</option>
          </select>
        </div>

        <button className="btn btn-primary" style={{ marginTop: 8 }} id="btn-save-details">
          Save Changes
        </button>
      </div>
    </div>
  );
}
