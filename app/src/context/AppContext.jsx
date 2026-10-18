import React, { createContext, useContext, useState, useEffect } from 'react';

const AppContext = createContext(null);

const DEFAULT_USER = {
  name: 'Shanti Priya',
  email: 'shanti.priya@email.com',
  phone: '+91 98765 43210',
  dob: '',
  gender: 'Female',
  avatar: null,
  referralCode: 'SHANTI2025',
  carbonCredits: 1630,
  impactLevel: 'Sapling',
  impactPoints: 1240,
  treesPlanted: 14,
  wasteRecycled: 124,
  co2Prevented: 42.8,
};

const DEFAULT_ADDRESSES = [
  {
    id: 1,
    type: 'Home',
    isDefault: true,
    name: 'Shanti Priya',
    address: '42 Green Valley, Sector 12',
    city: 'Bengaluru, Karnataka 560034',
  },
  {
    id: 2,
    type: 'Work',
    isDefault: false,
    name: 'Shanti Priya',
    address: 'Eco Tower, 8th Floor, MG Road',
    city: 'Bengaluru, Karnataka 560001',
  },
];

const DEFAULT_BOOKINGS = [
  {
    id: 1,
    service: 'Daily Garbage - Instant',
    price: 99,
    status: 'Completed',
    date: '12 Jun 2025',
    type: 'daily',
  },
  {
    id: 2,
    service: 'Large Dump',
    price: 999,
    status: 'Cancelled',
    date: '12 Jun 2025',
    type: 'large-dump',
  },
  {
    id: 3,
    service: 'Scrap Material',
    price: -1240,
    status: 'Pending',
    date: '12 Jun 2025',
    type: 'scrap',
    earned: true,
  },
];

const DEFAULT_LOCATION = {
  area: 'Sec - 76',
  city: 'Noida',
  full: 'G-2129, Amrapali Silicon City, Sector 76, Noida - 201309',
};

function loadFromStorage(key, defaultValue) {
  try {
    const stored = localStorage.getItem(`swachta_${key}`);
    return stored ? JSON.parse(stored) : defaultValue;
  } catch {
    return defaultValue;
  }
}

function saveToStorage(key, value) {
  try {
    localStorage.setItem(`swachta_${key}`, JSON.stringify(value));
  } catch {
    // silent fail
  }
}

export function AppProvider({ children }) {
  const [user, setUser] = useState(() => loadFromStorage('user', DEFAULT_USER));
  const [addresses, setAddresses] = useState(() => loadFromStorage('addresses', DEFAULT_ADDRESSES));
  const [bookings, setBookings] = useState(() => loadFromStorage('bookings', DEFAULT_BOOKINGS));
  const [location, setLocation] = useState(() => loadFromStorage('location', DEFAULT_LOCATION));
  const [isLoggedIn, setIsLoggedIn] = useState(() => loadFromStorage('isLoggedIn', false));
  const [hasOnboarded, setHasOnboarded] = useState(() => loadFromStorage('hasOnboarded', false));
  const [selectedSlot, setSelectedSlot] = useState('6:00 am - 8:00 am');
  const [selectedPayment, setSelectedPayment] = useState('UPI');
  const [cartService, setCartService] = useState(null);

  useEffect(() => { saveToStorage('user', user); }, [user]);
  useEffect(() => { saveToStorage('addresses', addresses); }, [addresses]);
  useEffect(() => { saveToStorage('bookings', bookings); }, [bookings]);
  useEffect(() => { saveToStorage('location', location); }, [location]);
  useEffect(() => { saveToStorage('isLoggedIn', isLoggedIn); }, [isLoggedIn]);
  useEffect(() => { saveToStorage('hasOnboarded', hasOnboarded); }, [hasOnboarded]);

  const addBooking = (booking) => {
    const newBooking = {
      ...booking,
      id: Date.now(),
      date: new Date().toLocaleDateString('en-IN', { day: '2-digit', month: 'short', year: 'numeric' }),
    };
    setBookings(prev => [newBooking, ...prev]);
    return newBooking;
  };

  const updateUser = (updates) => {
    setUser(prev => ({ ...prev, ...updates }));
  };

  const addAddress = (address) => {
    setAddresses(prev => [...prev, { ...address, id: Date.now() }]);
  };

  const removeAddress = (id) => {
    setAddresses(prev => prev.filter(a => a.id !== id));
  };

  const login = () => {
    setIsLoggedIn(true);
  };

  const logout = () => {
    setIsLoggedIn(false);
  };

  const value = {
    user, updateUser,
    addresses, addAddress, removeAddress,
    bookings, addBooking,
    location, setLocation,
    isLoggedIn, login, logout,
    hasOnboarded, setHasOnboarded,
    selectedSlot, setSelectedSlot,
    selectedPayment, setSelectedPayment,
    cartService, setCartService,
  };

  return <AppContext.Provider value={value}>{children}</AppContext.Provider>;
}

export function useApp() {
  const ctx = useContext(AppContext);
  if (!ctx) throw new Error('useApp must be used within AppProvider');
  return ctx;
}
