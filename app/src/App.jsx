import React from 'react';
import { Routes, Route, Navigate } from 'react-router-dom';

/* Pages */
import SplashScreen from './pages/SplashScreen';
import Onboarding from './pages/Onboarding';
import Login from './pages/Login';
import SignUp from './pages/SignUp';
import OTPVerification from './pages/OTPVerification';
import OTPVerified from './pages/OTPVerified';
import LocationAccess from './pages/LocationAccess';
import Home from './pages/Home';
import DailyGarbage from './pages/DailyGarbage';
import LargeDump from './pages/LargeDump';
import RecyclableWaste from './pages/RecyclableWaste';
import ScrapItems from './pages/ScrapItems';
import PaymentMethods from './pages/PaymentMethods';
import BookingConfirmed from './pages/BookingConfirmed';
import MyBookings from './pages/MyBookings';
import Impact from './pages/Impact';
import Reels from './pages/Reels';
import Profile from './pages/Profile';
import PersonalDetails from './pages/PersonalDetails';
import SavedAddresses from './pages/SavedAddresses';
import Rewards from './pages/Rewards';
import Support from './pages/Support';
import About from './pages/About';
import AccountSecurity from './pages/AccountSecurity';
import DeleteAccount from './pages/DeleteAccount';
import CameraScanner from './pages/CameraScanner';

export default function App() {
  return (
    <Routes>
      {/* Splash & Onboarding */}
      <Route path="/" element={<SplashScreen />} />
      <Route path="/onboarding" element={<Onboarding />} />

      {/* Auth */}
      <Route path="/login" element={<Login />} />
      <Route path="/signup" element={<SignUp />} />
      <Route path="/otp" element={<OTPVerification />} />
      <Route path="/verified" element={<OTPVerified />} />

      {/* Location */}
      <Route path="/location" element={<LocationAccess />} />

      {/* Main App */}
      <Route path="/home" element={<Home />} />
      <Route path="/bookings" element={<MyBookings />} />
      <Route path="/impact" element={<Impact />} />
      <Route path="/reels" element={<Reels />} />

      {/* Service Booking */}
      <Route path="/service/daily-garbage" element={<DailyGarbage />} />
      <Route path="/service/large-dump" element={<LargeDump />} />
      <Route path="/service/recyclable-waste" element={<RecyclableWaste />} />
      <Route path="/service/scrap-items" element={<ScrapItems />} />

      {/* Payment & Confirmation */}
      <Route path="/payment" element={<PaymentMethods />} />
      <Route path="/booking-confirmed" element={<BookingConfirmed />} />
      <Route path="/camera" element={<CameraScanner />} />

      {/* Profile & Settings */}
      <Route path="/profile" element={<Profile />} />
      <Route path="/profile/personal-details" element={<PersonalDetails />} />
      <Route path="/profile/saved-addresses" element={<SavedAddresses />} />
      <Route path="/profile/rewards" element={<Rewards />} />
      <Route path="/profile/support" element={<Support />} />
      <Route path="/profile/about" element={<About />} />
      <Route path="/profile/account-security" element={<AccountSecurity />} />
      <Route path="/profile/delete-account" element={<DeleteAccount />} />

      {/* Fallback */}
      <Route path="*" element={<Navigate to="/" replace />} />
    </Routes>
  );
}
