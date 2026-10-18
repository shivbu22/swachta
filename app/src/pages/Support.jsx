import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './SubPage.css';

const faqs = [
  { q: 'How do I schedule a pickup?', a: 'Go to the Home screen, select a service category, choose your time slot, and confirm your booking. Our worker will arrive at your location within the selected timeframe.' },
  { q: 'What items can be recycled?', a: 'We accept plastic, glass, metal, paper, cardboard, and electronics. Use the Camera Scanner for AI-powered identification of your waste materials.' },
  { q: 'How are carbon credits calculated?', a: 'Credits are earned based on the weight and type of waste you recycle. Each kilogram of waste properly recycled earns you credits proportional to its environmental impact.' },
  { q: 'Can I cancel a booking?', a: 'Yes, you can cancel up to 30 minutes before the scheduled pickup time from the My Bookings page. No charges apply for timely cancellations.' },
  { q: 'How does Refer & Earn work?', a: 'Share your unique referral code with friends. When they complete their first booking, you both receive 100 carbon credits. There is no limit on referrals.' },
];

export default function Support() {
  const navigate = useNavigate();
  const [openIdx, setOpenIdx] = useState(null);

  const toggleFAQ = (idx) => setOpenIdx(openIdx === idx ? null : idx);

  return (
    <div className="page" id="support-screen">
      <div className="sub-header">
        <button className="sub-back" onClick={() => navigate(-1)}>
          <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="m15 18-6-6 6-6"/></svg>
        </button>
        <h1 className="sub-header-title">Support</h1>
      </div>

      <div className="sub-content">
        {/* Contact options */}
        <div className="sub-payment-card animate-fade-in-up" style={{ cursor: 'pointer' }}>
          <div className="sub-payment-icon">💬</div>
          <div className="sub-payment-info">
            <div className="sub-payment-name">Chat with us</div>
            <div className="sub-payment-desc">Get instant support</div>
          </div>
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#9ca3af" strokeWidth="2"><path d="m9 18 6-6-6-6"/></svg>
        </div>

        <div className="sub-payment-card animate-fade-in-up delay-1" style={{ cursor: 'pointer' }}>
          <div className="sub-payment-icon">📧</div>
          <div className="sub-payment-info">
            <div className="sub-payment-name">Email Support</div>
            <div className="sub-payment-desc">support@swachta.in</div>
          </div>
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#9ca3af" strokeWidth="2"><path d="m9 18 6-6-6-6"/></svg>
        </div>

        {/* FAQs */}
        <h3 style={{ font: 'var(--font-h3)', color: 'var(--color-text)', marginTop: 8 }}>Frequently Asked Questions</h3>

        {faqs.map((faq, i) => (
          <div
            key={i}
            className={`sub-faq-item animate-fade-in-up delay-${Math.min(i + 2, 6)}`}
            onClick={() => toggleFAQ(i)}
          >
            <div className="sub-faq-question">
              <span>{faq.q}</span>
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" style={{ transform: openIdx === i ? 'rotate(180deg)' : 'none', transition: 'transform 0.3s', flexShrink: 0, marginLeft: 8 }}>
                <path d="m6 9 6 6 6-6"/>
              </svg>
            </div>
            {openIdx === i && <p className="sub-faq-answer">{faq.a}</p>}
          </div>
        ))}
      </div>
    </div>
  );
}
