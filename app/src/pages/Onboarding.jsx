import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useApp } from '../context/AppContext';
import './Onboarding.css';

const slides = [
  {
    title: "India's first on-demand sanitation platform!",
    desc: "India's streets deserve better. Swachta brings trained, insured sanitation workers to your door in 15 minutes — tracked live, paid fairly, and accountable for every job they do.",
    image: '/images/onboarding-1.png',
  },
  {
    title: 'Plant Trees & Grow a better tomorrow!',
    desc: "Most apps find you a freelancer. Swachta recruits, trains, uniforms, and manages every worker directly. And every kilo of waste they collect gets recycled — turning cleanliness into a self-funding system.",
    image: '/images/onboarding-2.png',
  },
  {
    title: 'Every piece of trash. Done in a dash.',
    desc: "From daily household waste to bulk commercial clutter, from your doorstep to construction site, schedule any garbage pickup instantly. Real-time tracking & eco-friendly disposal.",
    image: '/images/onboarding-3.png',
  },
];

export default function Onboarding() {
  const [current, setCurrent] = useState(0);
  const navigate = useNavigate();
  const { setHasOnboarded } = useApp();

  const handleNext = () => {
    if (current < slides.length - 1) {
      setCurrent(current + 1);
    } else {
      setHasOnboarded(true);
      navigate('/login', { replace: true });
    }
  };

  const handleSkip = () => {
    setHasOnboarded(true);
    navigate('/login', { replace: true });
  };

  const slide = slides[current];

  return (
    <div className="onboarding-page" id="onboarding-screen">
      {/* Decorative blobs */}
      <div className="onboarding-blob onboarding-blob-1"></div>
      <div className="onboarding-blob onboarding-blob-2"></div>
      <div className="onboarding-blob onboarding-blob-3"></div>

      {/* Photo */}
      <div className="onboarding-visual" key={current}>
        <img
          className="onboarding-photo"
          src={slide.image}
          alt={slide.title}
          draggable={false}
        />
      </div>

      {/* Content */}
      <div className="onboarding-content animate-fade-in-up" key={`c-${current}`}>
        <h1 className="onboarding-title">{slide.title}</h1>
        <p className="onboarding-desc">{slide.desc}</p>
      </div>

      {/* Dots */}
      <div className="onboarding-dots">
        {slides.map((_, i) => (
          <button
            key={i}
            className={`onboarding-dot ${i === current ? 'active' : ''}`}
            onClick={() => setCurrent(i)}
            aria-label={`Go to slide ${i + 1}`}
          />
        ))}
      </div>

      {/* Actions */}
      <div className="onboarding-actions">
        {current < slides.length - 1 ? (
          <>
            <button className="btn onboarding-skip" onClick={handleSkip} id="btn-skip">
              Skip
            </button>
            <button className="btn btn-primary onboarding-next" onClick={handleNext} id="btn-next">
              Next
            </button>
          </>
        ) : (
          <button className="btn btn-primary w-full" onClick={handleNext} id="btn-get-started">
            Get Started
          </button>
        )}
      </div>
    </div>
  );
}
