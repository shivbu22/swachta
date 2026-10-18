import React from 'react';
import { useNavigate } from 'react-router-dom';
import { useApp } from '../context/AppContext';
import './SubPage.css';
import './PaymentMethods.css';

const methods = [
  { id: 'UPI', name: 'UPI', desc: 'Google Pay, PhonePe, etc.', icon: '📱' },
  { id: 'Card', name: 'Credit / Debit Card', desc: 'Visa, Mastercard, Rupay', icon: '💳' },
  { id: 'Wallet', name: 'Wallet', desc: 'Paytm, Amazon Pay', icon: '👛' },
  { id: 'Cash', name: 'Cash on Pickup', desc: 'Pay when worker arrives', icon: '💵' },
];

export default function PaymentMethods() {
  const navigate = useNavigate();
  const { selectedPayment, setSelectedPayment } = useApp();

  return (
    <div className="page payment-page" id="payment-methods-screen">
      <div className="sub-header">
        <button className="sub-back" onClick={() => navigate(-1)}>
          <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="m15 18-6-6 6-6"/></svg>
        </button>
        <h1 className="sub-header-title">Payment Methods</h1>
      </div>

      <div className="sub-content">
        {methods.map((m, i) => (
          <div
            key={m.id}
            className={`sub-payment-card animate-fade-in-up delay-${Math.min(i + 1, 4)}`}
            onClick={() => setSelectedPayment(m.id)}
            style={{ cursor: 'pointer' }}
          >
            <div className="sub-payment-icon">{m.icon}</div>
            <div className="sub-payment-info">
              <div className="sub-payment-name">{m.name}</div>
              <div className="sub-payment-desc">{m.desc}</div>
            </div>
            <div className={`sub-payment-radio ${selectedPayment === m.id ? 'active' : ''}`}></div>
          </div>
        ))}
      </div>
    </div>
  );
}
