import React, { useState, useEffect, useRef } from 'react';
import { 
  StyleSheet, 
  Text, 
  View, 
  TextInput, 
  TouchableOpacity, 
  ScrollView, 
  SafeAreaView, 
  StatusBar,
  Dimensions,
  Alert,
  Animated,
  Easing
} from 'react-native';
import { TOKENS } from './src/theme/tokens';

const { width, height } = Dimensions.get('window');

// Blinkit-Inspired Vibrant Palette
const BLINKIT = {
  green: '#0c831f',        // Blinkit Signature Emerald
  darkGreen: '#034710',
  lightGreen: '#f0fdf4',
  mintBg: '#f7fff7',
  yellow: '#ffc200',       // Blinkit Accent Yellow
  gold: '#d97706',
  white: '#ffffff',
  textMain: '#1e293b',
  textMuted: '#64748b',
  cardBorder: '#e2e8f0',
  red: '#ef4444',
  blue: '#3b82f6',
  surfaceLight: '#f8fafc',
};

export default function App() {
  // Navigation & Tabs
  const [currentTab, setCurrentTab] = useState<'quick' | 'impact' | 'reels' | 'orders' | 'profile'>('quick');
  
  // Interactive Modals / Overlays
  const [activeModal, setActiveModal] = useState<
    'none' | 'ai_scanner' | 'scrap_cart' | 'checkout' | 'order_tracking' | 'scratch_card' | 'address_selector' | 'confirmed'
  >('none');
  
  // Search Bar Auto-Rotating Placeholder
  const searchPlaceholders = [
    'Search "scrap rates today"',
    'Search "plastic bottle pickup"',
    'Search "cardboard boxes resale"',
    'Search "heavy construction debris"'
  ];
  const [placeholderIndex, setPlaceholderIndex] = useState(0);

  useEffect(() => {
    const interval = setInterval(() => {
      setPlaceholderIndex((prev) => (prev + 1) % searchPlaceholders.length);
    }, 3000);
    return () => clearInterval(interval);
  }, []);

  // Cart & Scrap Items (Blinkit-style Interactive Cart)
  const [cartItems, setCartItems] = useState<{ [key: string]: number }>({});
  
  const scrapCatalog = [
    { id: 'c1', name: 'Plastic Bottles (PET)', rate: '₹24/kg', unitPrice: 24, icon: '🧴', tag: 'High Demand', estKg: 5 },
    { id: 'c2', name: 'Cardboard & Cartons', rate: '₹11/kg', unitPrice: 11, icon: '📦', tag: '2x CC', estKg: 10 },
    { id: 'c3', name: 'Old Newspapers (Raddi)', rate: '₹14/kg', unitPrice: 14, icon: '📰', tag: 'Popular', estKg: 8 },
    { id: 'c4', name: 'Aluminum & Tin Cans', rate: '₹110/kg', unitPrice: 110, icon: '🥫', tag: 'Top Value', estKg: 2 },
    { id: 'c5', name: 'E-Waste & Electronics', rate: '₹45/item', unitPrice: 45, icon: '🔌', tag: 'Instant Cash', estKg: 1 },
    { id: 'c6', name: 'Glass Bottles', rate: '₹5/kg', unitPrice: 5, icon: '🍾', tag: 'Eco Star', estKg: 6 },
  ];

  const handleAddToCart = (id: string) => {
    setCartItems((prev) => ({
      ...prev,
      [id]: (prev[id] || 0) + 1,
    }));
  };

  const handleRemoveFromCart = (id: string) => {
    setCartItems((prev) => {
      const current = prev[id] || 0;
      if (current <= 1) {
        const copy = { ...prev };
        delete copy[id];
        return copy;
      }
      return { ...prev, [id]: current - 1 };
    });
  };

  const totalCartCount = Object.values(cartItems).reduce((a, b) => a + b, 0);
  const totalCartValue = Object.entries(cartItems).reduce((sum, [id, qty]) => {
    const item = scrapCatalog.find((x) => x.id === id);
    return sum + (item ? item.unitPrice * (item.estKg || 1) * qty : 0);
  }, 0);

  // Quick Services
  const quickServices = [
    { id: 'daily', name: 'Daily Garbage', time: '15 MINS', price: '₹149', icon: '🗑️', desc: 'Doorstep segregation collection', badge: '⚡ INSTANT' },
    { id: 'scrap', name: 'Scrap & Raddi', time: 'TODAY', price: 'Get Cash', icon: '📦', desc: 'AI Camera scan & instant weighing', badge: '💰 CASHBACK' },
    { id: 'recyclable', name: 'Dry Recyclables', time: '30 MINS', price: '₹99', icon: '♻️', desc: 'PET, Cardboard, E-waste', badge: '🌱 +50 CC' },
    { id: 'bulk', name: 'Big Dump / Debris', time: '60 MINS', price: '₹499', icon: '🚛', desc: 'Heavy vehicle for construction/bulk', badge: '🚛 3.0 m³' },
  ];

  // Address
  const [selectedAddress, setSelectedAddress] = useState('Flat G-2129, Silicon City, Sec-76, Noida');
  const [selectedSlot, setSelectedSlot] = useState('⚡ Right Now (15 mins)');

  // Gamification: Scratch Card & Carbon Credits
  const [carbonCredits, setCarbonCredits] = useState(1630);
  const [walletCash, setWalletCash] = useState(457.50);
  const [isScratched, setIsScratched] = useState(false);
  const [scratchReward] = useState({ cc: 150, inr: 375 });
  const [ccToConvert, setCcToConvert] = useState('');

  // AI Scanner Laser Animation
  const laserAnim = useRef(new Animated.Value(0)).current;

  useEffect(() => {
    if (activeModal === 'ai_scanner') {
      Animated.loop(
        Animated.sequence([
          Animated.timing(laserAnim, {
            toValue: 1,
            duration: 1800,
            easing: Easing.inOut(Easing.quad),
            useNativeDriver: true,
          }),
          Animated.timing(laserAnim, {
            toValue: 0,
            duration: 1800,
            easing: Easing.inOut(Easing.quad),
            useNativeDriver: true,
          }),
        ])
      ).start();
    }
  }, [activeModal]);

  const laserTranslateY = laserAnim.interpolate({
    inputRange: [0, 1],
    outputRange: [0, width - 80],
  });

  // Convert CC to cash
  const handleCashoutCC = () => {
    const val = parseInt(ccToConvert, 10);
    if (!val || val <= 0 || val > carbonCredits) {
      Alert.alert('Invalid Amount', `Please enter a valid amount up to ${carbonCredits} CC`);
      return;
    }
    const earnedINR = val * 2.5;
    setCarbonCredits((prev) => prev - val);
    setWalletCash((prev) => prev + earnedINR);
    setCcToConvert('');
    Alert.alert('Blinkit-Speed Cashout! ⚡', `₹${earnedINR.toFixed(2)} transferred instantly to your Swachta Wallet!`);
  };

  return (
    <SafeAreaView style={styles.safeArea}>
      <StatusBar barStyle="dark-content" backgroundColor="#ffffff" />

      {/* ══════════════════════════════════════════════════════════════════════════ */}
      {/* ── 1. BLINKIT-STYLE DYNAMIC TOP HEADER                                  */}
      {/* ══════════════════════════════════════════════════════════════════════════ */}
      <View style={styles.blinkitHeader}>
        <View style={styles.headerTopRow}>
          <View style={styles.headerLocationCol}>
            <View style={styles.lightningBadgeRow}>
              <View style={styles.pulseDot} />
              <Text style={styles.lightningText}>PICKUP IN 15 MINS</Text>
            </View>
            <TouchableOpacity 
              style={styles.addressDropdownRow}
              onPress={() => setActiveModal('address_selector')}
            >
              <Text style={styles.addressTitleText} numberOfLines={1}>
                {selectedAddress}
              </Text>
              <Text style={styles.addressChevron}>▾</Text>
            </TouchableOpacity>
          </View>

          <TouchableOpacity 
            style={styles.profileAvatarCircle}
            onPress={() => setCurrentTab('profile')}
          >
            <Text style={{ fontSize: 18 }}>👤</Text>
          </TouchableOpacity>
        </View>

        {/* Dynamic Rotating Search Bar */}
        <TouchableOpacity 
          style={styles.searchBar} 
          activeOpacity={0.9}
          onPress={() => setActiveModal('ai_scanner')}
        >
          <Text style={styles.searchIcon}>🔍</Text>
          <Text style={styles.searchPlaceholderText}>
            {searchPlaceholders[placeholderIndex]}
          </Text>
          <View style={styles.aiScanSearchBtn}>
            <Text style={{ fontSize: 13, marginRight: 4 }}>📷</Text>
            <Text style={styles.aiScanBtnLabel}>AI Scan</Text>
          </View>
        </TouchableOpacity>
      </View>

      {/* ══════════════════════════════════════════════════════════════════════════ */}
      {/* ── 2. MAIN APP SCROLLABLE TABS CONTENT                                   */}
      {/* ══════════════════════════════════════════════════════════════════════════ */}
      <ScrollView contentContainerStyle={styles.mainScroll} showsVerticalScrollIndicator={false}>
        
        {/* ═══════════════════ TAB 1: QUICK PICK (HOME) ═══════════════════ */}
        {currentTab === 'quick' && (
          <View style={styles.tabPadding}>
            
            {/* Urgent Live Tracker Hero (If Active Order Exists) */}
            <TouchableOpacity 
              style={styles.liveOrderHeroCard}
              activeOpacity={0.9}
              onPress={() => setActiveModal('order_tracking')}
            >
              <View style={styles.liveOrderTopRow}>
                <View style={styles.liveOrderPill}>
                  <Text style={styles.liveOrderPillText}>● DRIVER ON THE WAY</Text>
                </View>
                <Text style={styles.liveOrderEta}>Arriving in 12 mins</Text>
              </View>

              <View style={styles.liveOrderDetailsRow}>
                <View style={styles.truckIconCircle}>
                  <Text style={{ fontSize: 24 }}>⚡🚛</Text>
                </View>
                <View style={{ flex: 1, marginLeft: 12 }}>
                  <Text style={styles.driverName}>Ramesh Kumar is assigned</Text>
                  <Text style={styles.driverSub}>Electric Tipper (UP-14-EA-9021) • 1.2 km away</Text>
                </View>
                <Text style={styles.viewLiveChevron}>Track &rsaquo;</Text>
              </View>
            </TouchableOpacity>

            {/* AI Camera Scrap Scanner Feature Banner */}
            <TouchableOpacity 
              style={styles.aiScanHeroBanner}
              activeOpacity={0.9}
              onPress={() => setActiveModal('ai_scanner')}
            >
              <View style={{ flex: 1 }}>
                <View style={styles.aiScannerTagPill}>
                  <Text style={styles.aiScannerTagText}>✨ SMART AI VALUATION</Text>
                </View>
                <Text style={styles.aiScannerHeroTitle}>Snap a photo of your scrap</Text>
                <Text style={styles.aiScannerHeroSub}>Instant material detection + market valuation in 2 seconds.</Text>
                <View style={styles.aiScanCtaRow}>
                  <Text style={styles.aiScanCtaText}>Launch AI Camera &rarr;</Text>
                </View>
              </View>
              <View style={styles.aiScannerHeroVisual}>
                <Text style={{ fontSize: 44 }}>📸</Text>
              </View>
            </TouchableOpacity>

            {/* Quick Services 4-Category Grid */}
            <Text style={styles.sectionHeading}>Instant Services</Text>
            <View style={styles.quickServicesGrid}>
              {quickServices.map((svc) => (
                <TouchableOpacity 
                  key={svc.id}
                  style={styles.quickServiceCard}
                  activeOpacity={0.85}
                  onPress={() => {
                    if (svc.id === 'scrap') {
                      setActiveModal('ai_scanner');
                    } else {
                      setActiveModal('checkout');
                    }
                  }}
                >
                  <View style={styles.quickServiceBadge}>
                    <Text style={styles.quickServiceBadgeText}>{svc.badge}</Text>
                  </View>
                  <View style={styles.quickServiceIconBox}>
                    <Text style={{ fontSize: 32 }}>{svc.icon}</Text>
                  </View>
                  <Text style={styles.quickServiceName}>{svc.name}</Text>
                  <Text style={styles.quickServiceDesc}>{svc.desc}</Text>
                  <View style={styles.quickServiceBottomRow}>
                    <Text style={styles.quickServicePrice}>{svc.price}</Text>
                    <View style={styles.quickBookArrow}>
                      <Text style={{ color: '#ffffff', fontWeight: 'bold', fontSize: 12 }}>➔</Text>
                    </View>
                  </View>
                </TouchableOpacity>
              ))}
            </View>

            {/* Live Scrap Rates Catalog (Blinkit-style Interactive Items with ADD buttons) */}
            <View style={styles.sectionHeaderRow}>
              <Text style={styles.sectionHeading}>Sell Scrap by Weight</Text>
              <TouchableOpacity onPress={() => setActiveModal('ai_scanner')}>
                <Text style={styles.viewRateCardLink}>Scan with AI &rsaquo;</Text>
              </TouchableOpacity>
            </View>

            <View style={styles.scrapCatalogGrid}>
              {scrapCatalog.map((item) => {
                const count = cartItems[item.id] || 0;
                return (
                  <View key={item.id} style={styles.scrapItemCard}>
                    <View style={styles.itemTagBadge}>
                      <Text style={styles.itemTagBadgeText}>{item.tag}</Text>
                    </View>
                    <Text style={styles.scrapItemEmoji}>{item.icon}</Text>
                    <Text style={styles.scrapItemTitle} numberOfLines={1}>{item.name}</Text>
                    <Text style={styles.scrapItemRate}>{item.rate}</Text>
                    <Text style={styles.scrapItemEst}>~{item.estKg}kg avg household</Text>

                    {/* Interactive Add / Plus-Minus Button */}
                    {count === 0 ? (
                      <TouchableOpacity 
                        style={styles.addBtn}
                        onPress={() => handleAddToCart(item.id)}
                      >
                        <Text style={styles.addBtnText}>ADD +</Text>
                      </TouchableOpacity>
                    ) : (
                      <View style={styles.qtyCounterRow}>
                        <TouchableOpacity 
                          style={styles.qtyBtn} 
                          onPress={() => handleRemoveFromCart(item.id)}
                        >
                          <Text style={styles.qtyBtnText}>-</Text>
                        </TouchableOpacity>
                        <Text style={styles.qtyCountText}>{count}</Text>
                        <TouchableOpacity 
                          style={styles.qtyBtn} 
                          onPress={() => handleAddToCart(item.id)}
                        >
                          <Text style={styles.qtyBtnText}>+</Text>
                        </TouchableOpacity>
                      </View>
                    )}
                  </View>
                );
              })}
            </View>

            {/* Mystery Scratch Card Promotion Banner */}
            <TouchableOpacity 
              style={styles.scratchPromoCard}
              activeOpacity={0.9}
              onPress={() => setActiveModal('scratch_card')}
            >
              <View style={styles.scratchPromoIcon}>
                <Text style={{ fontSize: 32 }}>🎁</Text>
              </View>
              <View style={{ flex: 1, marginLeft: 12 }}>
                <Text style={styles.scratchPromoTitle}>You have 1 Mystery Scratch Card!</Text>
                <Text style={styles.scratchPromoSub}>Tap to scratch & reveal up to ₹500 in Carbon Credits.</Text>
              </View>
              <View style={styles.scratchActionBtn}>
                <Text style={styles.scratchActionBtnText}>Scratch</Text>
              </View>
            </TouchableOpacity>

          </View>
        )}

        {/* ═══════════════════ TAB 2: ECO IMPACT ═══════════════════ */}
        {currentTab === 'impact' && (
          <View style={styles.tabPadding}>
            {/* Gamified Level Card */}
            <View style={styles.impactHeroCard}>
              <View style={styles.impactHeroHeader}>
                <View>
                  <Text style={styles.heroTierSub}>CURRENT STATUS</Text>
                  <Text style={styles.heroTierTitle}>Sapling Tier 🌿</Text>
                </View>
                <View style={styles.topRankPill}>
                  <Text style={styles.topRankText}>🏆 Top 8% Noida</Text>
                </View>
              </View>

              {/* Animated Progress Bar */}
              <View style={styles.levelProgressTrack}>
                <View style={[styles.levelProgressFill, { width: '75%' }]} />
              </View>
              <View style={styles.levelProgressLabels}>
                <Text style={styles.levelLabelText}>1630 / 2100 CC to Tree Tier</Text>
                <Text style={styles.levelLabelText}>470 CC to go</Text>
              </View>
            </View>

            {/* 3 Real-World Impact Counters */}
            <View style={styles.countersRow}>
              <View style={styles.counterBox}>
                <Text style={{ fontSize: 24 }}>🌱</Text>
                <Text style={styles.counterNum}>14.5 kg</Text>
                <Text style={styles.counterLabel}>Waste Diverted</Text>
              </View>
              <View style={styles.counterBox}>
                <Text style={{ fontSize: 24 }}>☁️</Text>
                <Text style={styles.counterNum}>8.2 kg</Text>
                <Text style={styles.counterLabel}>CO₂ Prevented</Text>
              </View>
              <View style={styles.counterBox}>
                <Text style={{ fontSize: 24 }}>🌳</Text>
                <Text style={styles.counterNum}>3</Text>
                <Text style={styles.counterLabel}>Trees Planted</Text>
              </View>
            </View>

            {/* Instant CC to Cashout Tool */}
            <View style={styles.cashoutCard}>
              <Text style={styles.cashoutTitle}>⚡ Instant Wallet Cashout</Text>
              <Text style={styles.cashoutRate}>1 Carbon Credit = ₹2.50 INR (Real Cash)</Text>

              <View style={styles.cashoutInputRow}>
                <TextInput 
                  style={styles.cashoutInput}
                  placeholder="Enter CC amount (e.g. 100)"
                  placeholderTextColor={BLINKIT.textMuted}
                  keyboardType="numeric"
                  value={ccToConvert}
                  onChangeText={setCcToConvert}
                />
                <TouchableOpacity style={styles.cashoutBtn} onPress={handleCashoutCC}>
                  <Text style={styles.cashoutBtnText}>Cashout</Text>
                </TouchableOpacity>
              </View>

              <View style={styles.walletBalanceSummary}>
                <Text style={styles.walletBalText}>Available: {carbonCredits} CC</Text>
                <Text style={styles.walletBalText}>Wallet: ₹{walletCash.toFixed(2)}</Text>
              </View>
            </View>
          </View>
        )}

        {/* ═══════════════════ TAB 3: REELS ═══════════════════ */}
        {currentTab === 'reels' && (
          <View style={styles.tabPadding}>
            <Text style={styles.sectionHeading}>Eco Shorts & Quick Guides</Text>
            {[
              { title: 'Mastering Dry Waste Segregation in 60s', views: '2.4k views', duration: '0:45', author: 'Swachta Academy' },
              { title: 'How Ghaziabad diverts 15 Tonnes Daily', views: '4.8k views', duration: '1:12', author: 'GNN Spotlight' },
              { title: 'Make Nutrient-Rich Kitchen Compost', views: '1.9k views', duration: '0:58', author: 'Green Citizen Club' },
            ].map((reel, idx) => (
              <View key={idx} style={styles.reelCard}>
                <View style={styles.reelThumbnailPlaceholder}>
                  <Text style={{ fontSize: 36 }}>▶️</Text>
                  <View style={styles.reelDurationBadge}>
                    <Text style={styles.reelDurationText}>{reel.duration}</Text>
                  </View>
                </View>
                <View style={styles.reelInfoRow}>
                  <Text style={styles.reelTitle}>{reel.title}</Text>
                  <Text style={styles.reelMeta}>{reel.author} • {reel.views}</Text>
                </View>
              </View>
            ))}
          </View>
        )}

        {/* ═══════════════════ TAB 4: ORDERS ═══════════════════ */}
        {currentTab === 'orders' && (
          <View style={styles.tabPadding}>
            <Text style={styles.sectionHeading}>Active & Past Bookings</Text>
            
            {/* Live Active Order */}
            <TouchableOpacity 
              style={styles.liveOrderHeroCard}
              onPress={() => setActiveModal('order_tracking')}
            >
              <View style={styles.liveOrderTopRow}>
                <View style={styles.liveOrderPill}>
                  <Text style={styles.liveOrderPillText}>● IN-TRANSIT</Text>
                </View>
                <Text style={styles.liveOrderEta}>ETA: 10:30 AM (12 mins)</Text>
              </View>
              <Text style={styles.ongoingServiceTitle}>Large Dump Bulk Clearance</Text>
              <Text style={styles.ongoingMeta}>Ticket #SW-8821 • Collector: Ramesh Kumar</Text>
              
              <View style={styles.orderActionsRow}>
                <TouchableOpacity 
                  style={styles.callDriverBtn}
                  onPress={() => Alert.alert('Call Collector', 'Calling Ramesh Kumar (+91 8800112233)...')}
                >
                  <Text style={styles.callDriverBtnText}>📞 Call Collector</Text>
                </TouchableOpacity>
                <TouchableOpacity 
                  style={styles.trackDetailsBtn}
                  onPress={() => setActiveModal('order_tracking')}
                >
                  <Text style={styles.trackDetailsBtnText}>Live Map ➔</Text>
                </TouchableOpacity>
              </View>
            </TouchableOpacity>

            <Text style={[styles.sectionHeading, { marginTop: 20 }]}>Completed Orders</Text>
            {[
              { id: 'SW-7740', service: 'Daily Garbage Pickup', date: 'Yesterday • 7:15 AM', amount: '₹149', rating: 'Clean ⭐⭐⭐⭐⭐' },
              { id: 'SW-6512', service: 'Scrap Resale (PET + Paper)', date: '24 May 2026', amount: '+₹430 (Cash Received)', rating: 'Verified ⭐⭐⭐⭐⭐' },
            ].map((order) => (
              <View key={order.id} style={styles.pastOrderCard}>
                <View style={styles.pastOrderTopRow}>
                  <Text style={styles.pastOrderService}>{order.service}</Text>
                  <Text style={styles.pastOrderAmount}>{order.amount}</Text>
                </View>
                <Text style={styles.pastOrderMeta}>#{order.id} • {order.date}</Text>
                <Text style={styles.pastOrderRating}>{order.rating}</Text>
              </View>
            ))}
          </View>
        )}

        {/* ═══════════════════ TAB 5: PROFILE ═══════════════════ */}
        {currentTab === 'profile' && (
          <View style={styles.tabPadding}>
            <View style={styles.profileCard}>
              <View style={styles.profileAvatarBox}>
                <Text style={{ fontSize: 32 }}>👤</Text>
              </View>
              <View style={{ flex: 1, marginLeft: 14 }}>
                <Text style={styles.profileName}>Shivam Yadav</Text>
                <Text style={styles.profilePhone}>+91 9876543210</Text>
                <Text style={styles.profileTier}>Sapling Tier Eco-Warrior 🌿</Text>
              </View>
            </View>

            <View style={styles.menuBox}>
              {[
                { title: '📍 Saved Addresses', sub: selectedAddress, action: () => setActiveModal('address_selector') },
                { title: '🎁 Refer & Earn (SHANTI2025)', sub: '3 Invited • 2 Joined (+50 CC Earned)', action: () => Alert.alert('Referral', 'Code SHANTI2025 copied!') },
                { title: '🛡️ Account & 2FA Security', sub: 'SMS OTP verification active', action: () => Alert.alert('Security', '2FA Active') },
                { title: '❓ 24/7 Sanitation Helpline', sub: '1800-SWACHTA / WhatsApp Support', action: () => Alert.alert('Support', 'Contact: help@swachta.co') },
              ].map((item, idx) => (
                <TouchableOpacity key={idx} style={styles.menuRow} onPress={item.action}>
                  <View style={{ flex: 1 }}>
                    <Text style={styles.menuRowTitle}>{item.title}</Text>
                    <Text style={styles.menuRowSub}>{item.sub}</Text>
                  </View>
                  <Text style={styles.menuChevron}>&rsaquo;</Text>
                </TouchableOpacity>
              ))}
            </View>
          </View>
        )}

      </ScrollView>

      {/* ══════════════════════════════════════════════════════════════════════════ */}
      {/* ── 3. BLINKIT-STYLE FLOATING BOTTOM CART BAR (Appears when items added)  */}
      {/* ══════════════════════════════════════════════════════════════════════════ */}
      {totalCartCount > 0 && activeModal === 'none' && (
        <View style={styles.floatingCartContainer}>
          <TouchableOpacity 
            style={styles.floatingCartPill}
            activeOpacity={0.9}
            onPress={() => setActiveModal('scrap_cart')}
          >
            <View style={styles.floatingCartLeft}>
              <View style={styles.cartCountBadge}>
                <Text style={styles.cartCountText}>{totalCartCount}</Text>
              </View>
              <View style={{ marginLeft: 10 }}>
                <Text style={styles.floatingCartPrice}>₹{totalCartValue} Estimated</Text>
                <Text style={styles.floatingCartSub}>Instant Weighing & Cash</Text>
              </View>
            </View>

            <View style={styles.floatingCartRight}>
              <Text style={styles.floatingCartCtaText}>Book Pickup ➔</Text>
            </View>
          </TouchableOpacity>
        </View>
      )}

      {/* ══════════════════════════════════════════════════════════════════════════ */}
      {/* ── 4. 5-TAB BOTTOM NAVIGATION BAR                                         */}
      {/* ══════════════════════════════════════════════════════════════════════════ */}
      <View style={styles.bottomNav}>
        <TouchableOpacity style={styles.navItem} onPress={() => setCurrentTab('quick')}>
          <Text style={[styles.navIcon, currentTab === 'quick' && styles.navIconActive]}>⚡</Text>
          <Text style={[styles.navLabel, currentTab === 'quick' && styles.navLabelActive]}>Quick</Text>
        </TouchableOpacity>

        <TouchableOpacity style={styles.navItem} onPress={() => setCurrentTab('impact')}>
          <Text style={[styles.navIcon, currentTab === 'impact' && styles.navIconActive]}>🌱</Text>
          <Text style={[styles.navLabel, currentTab === 'impact' && styles.navLabelActive]}>Impact</Text>
        </TouchableOpacity>

        <TouchableOpacity style={styles.navItem} onPress={() => setCurrentTab('reels')}>
          <Text style={[styles.navIcon, currentTab === 'reels' && styles.navIconActive]}>🎥</Text>
          <Text style={[styles.navLabel, currentTab === 'reels' && styles.navLabelActive]}>Reels</Text>
        </TouchableOpacity>

        <TouchableOpacity style={styles.navItem} onPress={() => setCurrentTab('orders')}>
          <Text style={[styles.navIcon, currentTab === 'orders' && styles.navIconActive]}>📦</Text>
          <Text style={[styles.navLabel, currentTab === 'orders' && styles.navLabelActive]}>Orders</Text>
        </TouchableOpacity>

        <TouchableOpacity style={styles.navItem} onPress={() => setCurrentTab('profile')}>
          <Text style={[styles.navIcon, currentTab === 'profile' && styles.navIconActive]}>👤</Text>
          <Text style={[styles.navLabel, currentTab === 'profile' && styles.navLabelActive]}>Account</Text>
        </TouchableOpacity>
      </View>

      {/* ══════════════════════════════════════════════════════════════════════════ */}
      {/* ── MODAL 1: AI CAMERA SCANNER WITH ANIMATED LASER HUD                    */}
      {/* ══════════════════════════════════════════════════════════════════════════ */}
      {activeModal === 'ai_scanner' && (
        <View style={styles.fullModalBlack}>
          <View style={styles.cameraHeaderRow}>
            <TouchableOpacity onPress={() => setActiveModal('none')}>
              <Text style={styles.cameraCloseBtn}>✕</Text>
            </TouchableOpacity>
            <View style={styles.cameraAiPill}>
              <Text style={styles.cameraAiPillText}>✨ AI LIVE SCANNER</Text>
            </View>
            <Text style={{ fontSize: 20 }}>⚡</Text>
          </View>

          {/* Viewfinder Target Box with Animated Laser Line */}
          <View style={styles.viewfinderBox}>
            <View style={styles.viewfinderFrame}>
              <Animated.View 
                style={[
                  styles.laserScanLine, 
                  { transform: [{ translateY: laserTranslateY }] }
                ]} 
              />
              
              {/* Bounding Box Simulation Tags */}
              <View style={styles.detectedBoxTag1}>
                <Text style={styles.detectedBoxTagText}>📦 Cardboard (95%)</Text>
              </View>
              <View style={styles.detectedBoxTag2}>
                <Text style={styles.detectedBoxTagText}>🧴 PET Bottles (92%)</Text>
              </View>
            </View>
            <Text style={styles.viewfinderPrompt}>Point camera at scrap or garbage heap</Text>
          </View>

          {/* Real-time Detection Summary Sheet */}
          <View style={styles.cameraBottomCard}>
            <View style={styles.detectionResultHeader}>
              <Text style={styles.detectedTitle}>Detected: 2 Categories</Text>
              <Text style={styles.detectedEstVal}>Est: ₹430</Text>
            </View>

            <TouchableOpacity 
              style={styles.cameraSnapBtn}
              onPress={() => {
                handleAddToCart('c1');
                handleAddToCart('c2');
                setActiveModal('scrap_cart');
              }}
            >
              <Text style={styles.cameraSnapBtnText}>Accept Valuation & Book Pickup ➔</Text>
            </TouchableOpacity>
          </View>
        </View>
      )}

      {/* ══════════════════════════════════════════════════════════════════════════ */}
      {/* ── MODAL 2: SCRAP CART & CHECKOUT SHEET                                   */}
      {/* ══════════════════════════════════════════════════════════════════════════ */}
      {activeModal === 'scrap_cart' && (
        <View style={styles.fullModalOverlay}>
          <ScrollView contentContainerStyle={styles.cartModalScroll}>
            <View style={styles.modalHeaderRow}>
              <TouchableOpacity onPress={() => setActiveModal('none')}>
                <Text style={styles.modalBackArrow}>←</Text>
              </TouchableOpacity>
              <Text style={styles.modalTitle}>Your Scrap Pickup</Text>
              <View style={{ width: 24 }} />
            </View>

            {/* Address Banner */}
            <View style={styles.cartAddressCard}>
              <Text style={{ fontSize: 18, marginRight: 10 }}>📍</Text>
              <View style={{ flex: 1 }}>
                <Text style={styles.cartAddressTitle}>Pickup Address</Text>
                <Text style={styles.cartAddressSub}>{selectedAddress}</Text>
              </View>
              <TouchableOpacity onPress={() => setActiveModal('address_selector')}>
                <Text style={styles.changeAddressLink}>Change</Text>
              </TouchableOpacity>
            </View>

            {/* Time Slot Picker */}
            <Text style={styles.cartSectionTitle}>Choose Arrival Window</Text>
            <View style={styles.slotGrid}>
              {['⚡ Right Now (15 mins)', '6:00 - 8:00 AM', '10:00 - 12:00 PM', '2:00 - 4:00 PM'].map((slot) => (
                <TouchableOpacity
                  key={slot}
                  style={[styles.cartSlotPill, selectedSlot === slot && styles.cartSlotPillActive]}
                  onPress={() => setSelectedSlot(slot)}
                >
                  <Text style={[styles.cartSlotText, selectedSlot === slot && styles.cartSlotTextActive]}>{slot}</Text>
                </TouchableOpacity>
              ))}
            </View>

            {/* Itemized List */}
            <Text style={[styles.cartSectionTitle, { marginTop: 16 }]}>Added Scrap Items</Text>
            {Object.entries(cartItems).map(([id, qty]) => {
              const item = scrapCatalog.find((x) => x.id === id);
              if (!item) return null;
              return (
                <View key={id} style={styles.cartItemRow}>
                  <Text style={{ fontSize: 24, marginRight: 10 }}>{item.icon}</Text>
                  <View style={{ flex: 1 }}>
                    <Text style={styles.cartItemName}>{item.name}</Text>
                    <Text style={styles.cartItemSub}>{item.rate} • ~{item.estKg * qty}kg total</Text>
                  </View>
                  <Text style={styles.cartItemPrice}>+₹{item.unitPrice * item.estKg * qty}</Text>
                </View>
              );
            })}

            {/* Payment Summary */}
            <View style={styles.billSummaryBox}>
              <View style={styles.billRow}>
                <Text style={styles.billLabel}>Estimated Scrap Value to Receive</Text>
                <Text style={styles.billValGreen}>+₹{totalCartValue}</Text>
              </View>
              <View style={styles.billRow}>
                <Text style={styles.billLabel}>Electric Pickup & Digital Weighing</Text>
                <Text style={styles.billVal}>FREE</Text>
              </View>
              <View style={[styles.billRow, styles.billRowTotal]}>
                <Text style={styles.billTotalLabel}>Net Payout to You (Cash/UPI)</Text>
                <Text style={styles.billTotalVal}>₹{totalCartValue}</Text>
              </View>
            </View>

            <TouchableOpacity 
              style={styles.confirmBookingBtn}
              onPress={() => {
                setCartItems({});
                setActiveModal('confirmed');
              }}
            >
              <Text style={styles.confirmBookingBtnText}>Confirm 15-Min Pickup ➔</Text>
            </TouchableOpacity>
          </ScrollView>
        </View>
      )}

      {/* ══════════════════════════════════════════════════════════════════════════ */}
      {/* ── MODAL 3: LIVE DRIVER TRACKING MAP SHEET                               */}
      {/* ══════════════════════════════════════════════════════════════════════════ */}
      {activeModal === 'order_tracking' && (
        <View style={styles.fullModalOverlay}>
          <ScrollView contentContainerStyle={styles.cartModalScroll}>
            <View style={styles.modalHeaderRow}>
              <TouchableOpacity onPress={() => setActiveModal('none')}>
                <Text style={styles.modalBackArrow}>←</Text>
              </TouchableOpacity>
              <Text style={styles.modalTitle}>Live Order Tracking</Text>
              <View style={{ width: 24 }} />
            </View>

            {/* Simulated Live Route Map Box */}
            <View style={styles.mapSimulationBox}>
              <View style={styles.mapRouteOverlay}>
                <Text style={{ fontSize: 36 }}>🗺️</Text>
                <View style={styles.liveTruckMarker}>
                  <Text style={{ fontSize: 20 }}>🚛</Text>
                </View>
                <View style={styles.destinationMarker}>
                  <Text style={{ fontSize: 20 }}>🏠</Text>
                </View>
              </View>
              <View style={styles.liveEtaPill}>
                <Text style={styles.liveEtaPillText}>⚡ Arriving in 12 mins (1.2 km away)</Text>
              </View>
            </View>

            {/* Driver Profile Card */}
            <View style={styles.driverProfileCard}>
              <View style={styles.driverAvatar}>
                <Text style={{ fontSize: 28 }}>👨‍🌾</Text>
              </View>
              <View style={{ flex: 1, marginLeft: 12 }}>
                <Text style={styles.driverCardName}>Ramesh Kumar</Text>
                <Text style={styles.driverCardRating}>⭐ 4.9 (1,240 pickups completed)</Text>
                <Text style={styles.driverVehicleNo}>Electric Tipper: UP-14-EA-9021</Text>
              </View>
              <TouchableOpacity 
                style={styles.driverCallBtn}
                onPress={() => Alert.alert('Call Collector', 'Dialing +91 8800112233')}
              >
                <Text style={{ fontSize: 18 }}>📞</Text>
              </TouchableOpacity>
            </View>

            {/* Order Progress Stepper */}
            <View style={styles.stepperCard}>
              {[
                { step: 'Order Placed', time: '10:14 AM', done: true },
                { step: 'Driver Assigned (Ramesh Kumar)', time: '10:16 AM', done: true },
                { step: 'On the Way (1.2 km away)', time: 'Now', done: true },
                { step: 'Doorstep Digital Weighing & Payment', time: 'Est. 10:30 AM', done: false },
              ].map((st, i) => (
                <View key={i} style={styles.stepRow}>
                  <View style={[styles.stepCircle, st.done ? styles.stepCircleDone : styles.stepCirclePending]}>
                    <Text style={{ color: '#ffffff', fontSize: 10, fontWeight: 'bold' }}>
                      {st.done ? '✓' : `${i+1}`}
                    </Text>
                  </View>
                  <View style={{ flex: 1, marginLeft: 12 }}>
                    <Text style={[styles.stepTitle, st.done && styles.stepTitleDone]}>{st.step}</Text>
                    <Text style={styles.stepTime}>{st.time}</Text>
                  </View>
                </View>
              ))}
            </View>

            <TouchableOpacity 
              style={styles.doneModalBtn}
              onPress={() => setActiveModal('none')}
            >
              <Text style={styles.doneModalBtnText}>Back to Home</Text>
            </TouchableOpacity>
          </ScrollView>
        </View>
      )}

      {/* ══════════════════════════════════════════════════════════════════════════ */}
      {/* ── MODAL 4: INTERACTIVE MYSTERY SCRATCH CARD                              */}
      {/* ══════════════════════════════════════════════════════════════════════════ */}
      {activeModal === 'scratch_card' && (
        <View style={styles.scratchModalOverlay}>
          <View style={styles.scratchCardSheet}>
            <TouchableOpacity style={styles.closeScratchBtn} onPress={() => setActiveModal('none')}>
              <Text style={{ fontSize: 20, color: '#ffffff' }}>✕</Text>
            </TouchableOpacity>

            <Text style={styles.scratchModalHeading}>Eco-Reward Scratch Card 🎁</Text>
            <Text style={styles.scratchModalSub}>Tap the card to scratch and reveal your bonus!</Text>

            <TouchableOpacity 
              style={styles.scratchSurfaceCard}
              activeOpacity={0.9}
              onPress={() => {
                if (!isScratched) {
                  setIsScratched(true);
                  setCarbonCredits((prev) => prev + scratchReward.cc);
                  setWalletCash((prev) => prev + scratchReward.inr);
                }
              }}
            >
              {!isScratched ? (
                <View style={styles.unscratchedCover}>
                  <Text style={{ fontSize: 56 }}>✨</Text>
                  <Text style={styles.tapToScratchText}>TAP TO REVEAL</Text>
                  <Text style={styles.tapToScratchSub}>Guaranteed Carbon Credits</Text>
                </View>
              ) : (
                <View style={styles.scratchedRewardContent}>
                  <Text style={{ fontSize: 44 }}>🎉</Text>
                  <Text style={styles.rewardBigAmount}>+150 Carbon Credits</Text>
                  <Text style={styles.rewardCashEquiv}>= ₹375.00 Real Wallet Cash</Text>
                  <View style={styles.claimedPill}>
                    <Text style={styles.claimedPillText}>ADDED TO YOUR WALLET ✓</Text>
                  </View>
                </View>
              )}
            </TouchableOpacity>

            {isScratched && (
              <TouchableOpacity 
                style={styles.claimDoneBtn}
                onPress={() => setActiveModal('none')}
              >
                <Text style={styles.claimDoneBtnText}>Awesome! Go to Wallet</Text>
              </TouchableOpacity>
            )}
          </View>
        </View>
      )}

      {/* ══════════════════════════════════════════════════════════════════════════ */}
      {/* ── MODAL 5: BOOKING CONFIRMED SUCCESS                                     */}
      {/* ══════════════════════════════════════════════════════════════════════════ */}
      {activeModal === 'confirmed' && (
        <View style={styles.fullModalOverlay}>
          <View style={styles.confirmedBox}>
            <View style={styles.confirmedCircle}>
              <Text style={{ fontSize: 48 }}>⚡✓</Text>
            </View>
            <Text style={styles.confirmedTitle}>Pickup Scheduled!</Text>
            <Text style={styles.confirmedSub}>
              Ramesh Kumar will arrive at your doorstep in ~15 minutes with digital scale and electric vehicle.
            </Text>

            <TouchableOpacity 
              style={styles.trackConfirmedBtn}
              onPress={() => setActiveModal('order_tracking')}
            >
              <Text style={styles.trackConfirmedBtnText}>Track Collector Live ➔</Text>
            </TouchableOpacity>

            <TouchableOpacity 
              style={styles.backHomeBtn}
              onPress={() => setActiveModal('none')}
            >
              <Text style={styles.backHomeBtnText}>Go to Home</Text>
            </TouchableOpacity>
          </View>
        </View>
      )}

      {/* ══════════════════════════════════════════════════════════════════════════ */}
      {/* ── MODAL 6: ADDRESS SELECTOR                                              */}
      {/* ══════════════════════════════════════════════════════════════════════════ */}
      {activeModal === 'address_selector' && (
        <View style={styles.fullModalOverlay}>
          <View style={styles.addressSheet}>
            <Text style={styles.sheetTitle}>Select Pickup Address</Text>
            {[
              'Flat G-2129, Silicon City, Sec-76, Noida',
              'Plot 42, Shalimar Garden Main, Ghaziabad',
              'Sector 10, Kavi Nagar Commercial, Ghaziabad'
            ].map((addr, idx) => (
              <TouchableOpacity 
                key={idx}
                style={[styles.addressOptionRow, selectedAddress === addr && styles.addressOptionSelected]}
                onPress={() => {
                  setSelectedAddress(addr);
                  setActiveModal('none');
                }}
              >
                <Text style={{ fontSize: 18, marginRight: 10 }}>📍</Text>
                <Text style={styles.addressOptionText}>{addr}</Text>
              </TouchableOpacity>
            ))}
          </View>
        </View>
      )}

    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safeArea: {
    flex: 1,
    backgroundColor: '#ffffff',
  },
  
  // ─── BLINKIT HEADER ───
  blinkitHeader: {
    backgroundColor: '#ffffff',
    paddingHorizontal: 16,
    paddingTop: 8,
    paddingBottom: 12,
    borderBottomWidth: 1,
    borderBottomColor: '#f1f5f9',
  },
  headerTopRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    marginBottom: 10,
  },
  headerLocationCol: {
    flex: 1,
  },
  lightningBadgeRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 2,
  },
  pulseDot: {
    width: 7,
    height: 7,
    borderRadius: 3.5,
    backgroundColor: BLINKIT.green,
    marginRight: 6,
  },
  lightningText: {
    fontSize: 11,
    fontWeight: '900',
    color: BLINKIT.green,
    letterSpacing: 0.5,
  },
  addressDropdownRow: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  addressTitleText: {
    fontSize: 14,
    fontWeight: '800',
    color: BLINKIT.textMain,
    maxWidth: '85%',
  },
  addressChevron: {
    fontSize: 14,
    color: BLINKIT.textMuted,
    marginLeft: 4,
  },
  profileAvatarCircle: {
    width: 38,
    height: 38,
    borderRadius: 19,
    backgroundColor: BLINKIT.lightGreen,
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 1,
    borderColor: '#bbf7d0',
  },
  searchBar: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#f8fafc',
    borderRadius: 14,
    paddingHorizontal: 12,
    height: 46,
    borderWidth: 1,
    borderColor: '#e2e8f0',
  },
  searchIcon: {
    fontSize: 15,
    marginRight: 8,
  },
  searchPlaceholderText: {
    flex: 1,
    fontSize: 13,
    color: BLINKIT.textMuted,
    fontWeight: '500',
  },
  aiScanSearchBtn: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: BLINKIT.green,
    paddingHorizontal: 10,
    paddingVertical: 5,
    borderRadius: 10,
  },
  aiScanBtnLabel: {
    color: '#ffffff',
    fontSize: 11,
    fontWeight: '800',
  },

  // ─── MAIN SCROLL ───
  mainScroll: {
    paddingBottom: 110,
  },
  tabPadding: {
    padding: 16,
  },

  // Live Order Hero Card
  liveOrderHeroCard: {
    backgroundColor: '#0f172a',
    borderRadius: 18,
    padding: 14,
    marginBottom: 16,
  },
  liveOrderTopRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 10,
  },
  liveOrderPill: {
    backgroundColor: 'rgba(34, 197, 94, 0.2)',
    paddingHorizontal: 8,
    paddingVertical: 3,
    borderRadius: 999,
  },
  liveOrderPillText: {
    color: '#4ade80',
    fontSize: 10,
    fontWeight: '900',
  },
  liveOrderEta: {
    color: BLINKIT.yellow,
    fontSize: 12,
    fontWeight: '800',
  },
  liveOrderDetailsRow: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  truckIconCircle: {
    width: 44,
    height: 44,
    borderRadius: 22,
    backgroundColor: 'rgba(255, 255, 255, 0.1)',
    alignItems: 'center',
    justifyContent: 'center',
  },
  driverName: {
    color: '#ffffff',
    fontSize: 14,
    fontWeight: '800',
  },
  driverSub: {
    color: '#94a3b8',
    fontSize: 11,
    marginTop: 2,
  },
  viewLiveChevron: {
    color: '#ffffff',
    fontSize: 16,
    fontWeight: 'bold',
  },

  // AI Scanner Banner
  aiScanHeroBanner: {
    backgroundColor: '#064e3b',
    borderRadius: 20,
    padding: 18,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    marginBottom: 20,
  },
  aiScannerTagPill: {
    backgroundColor: 'rgba(255, 255, 255, 0.2)',
    paddingHorizontal: 8,
    paddingVertical: 3,
    borderRadius: 999,
    alignSelf: 'flex-start',
    marginBottom: 6,
  },
  aiScannerTagText: {
    color: '#a7f3d0',
    fontSize: 9,
    fontWeight: '900',
    letterSpacing: 0.5,
  },
  aiScannerHeroTitle: {
    color: '#ffffff',
    fontSize: 17,
    fontWeight: '900',
    marginBottom: 4,
  },
  aiScannerHeroSub: {
    color: 'rgba(255, 255, 255, 0.8)',
    fontSize: 11,
    lineHeight: 15,
    marginBottom: 10,
  },
  aiScanCtaRow: {
    alignSelf: 'flex-start',
  },
  aiScanCtaText: {
    color: '#6ee7b7',
    fontSize: 12,
    fontWeight: '800',
  },
  aiScannerHeroVisual: {
    width: 60,
    alignItems: 'center',
    justifyContent: 'center',
  },

  // Quick Services Grid
  sectionHeading: {
    fontSize: 17,
    fontWeight: '800',
    color: BLINKIT.textMain,
    marginBottom: 12,
  },
  sectionHeaderRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginTop: 16,
    marginBottom: 12,
  },
  viewRateCardLink: {
    fontSize: 12,
    fontWeight: '800',
    color: BLINKIT.green,
  },
  quickServicesGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 10,
    marginBottom: 8,
  },
  quickServiceCard: {
    width: '48%',
    backgroundColor: '#ffffff',
    borderRadius: 18,
    padding: 12,
    borderWidth: 1,
    borderColor: '#e2e8f0',
    position: 'relative',
  },
  quickServiceBadge: {
    position: 'absolute',
    top: 8,
    right: 8,
    backgroundColor: '#dcfce7',
    paddingHorizontal: 6,
    paddingVertical: 2,
    borderRadius: 6,
  },
  quickServiceBadgeText: {
    color: BLINKIT.green,
    fontSize: 9,
    fontWeight: '900',
  },
  quickServiceIconBox: {
    width: 48,
    height: 48,
    borderRadius: 24,
    backgroundColor: BLINKIT.lightGreen,
    alignItems: 'center',
    justifyContent: 'center',
    marginBottom: 8,
  },
  quickServiceName: {
    fontSize: 14,
    fontWeight: '800',
    color: BLINKIT.textMain,
  },
  quickServiceDesc: {
    fontSize: 11,
    color: BLINKIT.textMuted,
    marginTop: 2,
    height: 28,
  },
  quickServiceBottomRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginTop: 8,
    paddingTop: 8,
    borderTopWidth: 1,
    borderTopColor: '#f1f5f9',
  },
  quickServicePrice: {
    fontSize: 13,
    fontWeight: '900',
    color: BLINKIT.green,
  },
  quickBookArrow: {
    width: 22,
    height: 22,
    borderRadius: 11,
    backgroundColor: BLINKIT.green,
    alignItems: 'center',
    justifyContent: 'center',
  },

  // Scrap Catalog Grid
  scrapCatalogGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 10,
    marginBottom: 20,
  },
  scrapItemCard: {
    width: '48%',
    backgroundColor: '#ffffff',
    borderRadius: 16,
    padding: 12,
    borderWidth: 1,
    borderColor: '#e2e8f0',
    position: 'relative',
    alignItems: 'center',
  },
  itemTagBadge: {
    position: 'absolute',
    top: 8,
    left: 8,
    backgroundColor: '#fef3c7',
    paddingHorizontal: 6,
    paddingVertical: 2,
    borderRadius: 6,
  },
  itemTagBadgeText: {
    color: '#b45309',
    fontSize: 9,
    fontWeight: '800',
  },
  scrapItemEmoji: {
    fontSize: 36,
    marginTop: 14,
    marginBottom: 6,
  },
  scrapItemTitle: {
    fontSize: 13,
    fontWeight: '800',
    color: BLINKIT.textMain,
    textAlign: 'center',
  },
  scrapItemRate: {
    fontSize: 14,
    fontWeight: '900',
    color: BLINKIT.green,
    marginTop: 2,
  },
  scrapItemEst: {
    fontSize: 10,
    color: BLINKIT.textMuted,
    marginTop: 2,
    marginBottom: 8,
  },
  addBtn: {
    backgroundColor: '#ffffff',
    borderWidth: 1.5,
    borderColor: BLINKIT.green,
    paddingVertical: 6,
    paddingHorizontal: 20,
    borderRadius: 10,
    marginTop: 2,
  },
  addBtnText: {
    color: BLINKIT.green,
    fontSize: 12,
    fontWeight: '900',
  },
  qtyCounterRow: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: BLINKIT.green,
    borderRadius: 10,
    paddingVertical: 3,
    paddingHorizontal: 8,
    marginTop: 2,
  },
  qtyBtn: {
    paddingHorizontal: 6,
  },
  qtyBtnText: {
    color: '#ffffff',
    fontSize: 14,
    fontWeight: 'bold',
  },
  qtyCountText: {
    color: '#ffffff',
    fontSize: 12,
    fontWeight: '900',
    paddingHorizontal: 6,
  },

  // Scratch Promo Card
  scratchPromoCard: {
    backgroundColor: '#fef9c3',
    borderRadius: 18,
    padding: 14,
    flexDirection: 'row',
    alignItems: 'center',
    borderWidth: 1.5,
    borderColor: '#fde047',
  },
  scratchPromoIcon: {
    width: 44,
    height: 44,
    borderRadius: 22,
    backgroundColor: '#fef08a',
    alignItems: 'center',
    justifyContent: 'center',
  },
  scratchPromoTitle: {
    fontSize: 13,
    fontWeight: '800',
    color: '#854d0e',
  },
  scratchPromoSub: {
    fontSize: 11,
    color: '#a16207',
    marginTop: 2,
  },
  scratchActionBtn: {
    backgroundColor: '#854d0e',
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 8,
  },
  scratchActionBtnText: {
    color: '#ffffff',
    fontSize: 11,
    fontWeight: '800',
  },

  // ─── TAB 2: IMPACT ───
  impactHeroCard: {
    backgroundColor: '#064e3b',
    borderRadius: 20,
    padding: 18,
    marginBottom: 16,
  },
  impactHeroHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 12,
  },
  heroTierSub: {
    color: '#a7f3d0',
    fontSize: 10,
    fontWeight: '900',
    letterSpacing: 1,
  },
  heroTierTitle: {
    color: '#ffffff',
    fontSize: 22,
    fontWeight: '900',
    marginTop: 2,
  },
  topRankPill: {
    backgroundColor: 'rgba(255, 255, 255, 0.2)',
    paddingHorizontal: 10,
    paddingVertical: 4,
    borderRadius: 999,
  },
  topRankText: {
    color: '#ffffff',
    fontSize: 11,
    fontWeight: '800',
  },
  levelProgressTrack: {
    height: 8,
    backgroundColor: 'rgba(0, 0, 0, 0.3)',
    borderRadius: 4,
    overflow: 'hidden',
    marginBottom: 6,
  },
  levelProgressFill: {
    height: '100%',
    backgroundColor: '#34d399',
  },
  levelProgressLabels: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  levelLabelText: {
    color: 'rgba(255, 255, 255, 0.8)',
    fontSize: 11,
  },
  countersRow: {
    flexDirection: 'row',
    gap: 8,
    marginBottom: 16,
  },
  counterBox: {
    flex: 1,
    backgroundColor: '#ffffff',
    borderRadius: 16,
    padding: 12,
    alignItems: 'center',
    borderWidth: 1,
    borderColor: '#e2e8f0',
  },
  counterNum: {
    fontSize: 16,
    fontWeight: '900',
    color: BLINKIT.textMain,
    marginTop: 4,
  },
  counterLabel: {
    fontSize: 10,
    color: BLINKIT.textMuted,
    marginTop: 2,
  },
  cashoutCard: {
    backgroundColor: '#ffffff',
    borderRadius: 18,
    padding: 16,
    borderWidth: 1,
    borderColor: '#e2e8f0',
  },
  cashoutTitle: {
    fontSize: 15,
    fontWeight: '800',
    color: BLINKIT.textMain,
  },
  cashoutRate: {
    fontSize: 12,
    color: BLINKIT.green,
    fontWeight: '700',
    marginTop: 2,
    marginBottom: 12,
  },
  cashoutInputRow: {
    flexDirection: 'row',
    gap: 8,
    marginBottom: 12,
  },
  cashoutInput: {
    flex: 1,
    backgroundColor: '#f8fafc',
    borderRadius: 12,
    paddingHorizontal: 12,
    height: 46,
    borderWidth: 1,
    borderColor: '#cbd5e1',
    fontSize: 14,
    fontWeight: '700',
  },
  cashoutBtn: {
    backgroundColor: BLINKIT.green,
    paddingHorizontal: 18,
    borderRadius: 12,
    alignItems: 'center',
    justifyContent: 'center',
  },
  cashoutBtnText: {
    color: '#ffffff',
    fontSize: 13,
    fontWeight: '800',
  },
  walletBalanceSummary: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    paddingTop: 8,
    borderTopWidth: 1,
    borderTopColor: '#f1f5f9',
  },
  walletBalText: {
    fontSize: 12,
    fontWeight: '800',
    color: BLINKIT.textMain,
  },

  // ─── TAB 3: REELS ───
  reelCard: {
    backgroundColor: '#ffffff',
    borderRadius: 18,
    overflow: 'hidden',
    marginBottom: 14,
    borderWidth: 1,
    borderColor: '#e2e8f0',
  },
  reelThumbnailPlaceholder: {
    height: 160,
    backgroundColor: '#0f172a',
    alignItems: 'center',
    justifyContent: 'center',
    position: 'relative',
  },
  reelDurationBadge: {
    position: 'absolute',
    bottom: 8,
    right: 8,
    backgroundColor: 'rgba(0,0,0,0.7)',
    paddingHorizontal: 6,
    paddingVertical: 2,
    borderRadius: 4,
  },
  reelDurationText: {
    color: '#ffffff',
    fontSize: 10,
    fontWeight: 'bold',
  },
  reelInfoRow: {
    padding: 12,
  },
  reelTitle: {
    fontSize: 14,
    fontWeight: '800',
    color: BLINKIT.textMain,
  },
  reelMeta: {
    fontSize: 11,
    color: BLINKIT.textMuted,
    marginTop: 4,
  },

  // ─── TAB 4: ORDERS ───
  ongoingServiceTitle: {
    fontSize: 15,
    fontWeight: '800',
    color: '#ffffff',
    marginTop: 8,
  },
  ongoingMeta: {
    fontSize: 12,
    color: '#94a3b8',
    marginTop: 2,
    marginBottom: 12,
  },
  orderActionsRow: {
    flexDirection: 'row',
    gap: 8,
  },
  callDriverBtn: {
    flex: 1,
    backgroundColor: 'rgba(255, 255, 255, 0.15)',
    paddingVertical: 8,
    borderRadius: 10,
    alignItems: 'center',
  },
  callDriverBtnText: {
    color: '#ffffff',
    fontSize: 12,
    fontWeight: '700',
  },
  trackDetailsBtn: {
    flex: 1,
    backgroundColor: BLINKIT.green,
    paddingVertical: 8,
    borderRadius: 10,
    alignItems: 'center',
  },
  trackDetailsBtnText: {
    color: '#ffffff',
    fontSize: 12,
    fontWeight: '800',
  },
  pastOrderCard: {
    backgroundColor: '#ffffff',
    borderRadius: 14,
    padding: 14,
    marginBottom: 10,
    borderWidth: 1,
    borderColor: '#e2e8f0',
  },
  pastOrderTopRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  pastOrderService: {
    fontSize: 14,
    fontWeight: '800',
    color: BLINKIT.textMain,
  },
  pastOrderAmount: {
    fontSize: 13,
    fontWeight: '900',
    color: BLINKIT.green,
  },
  pastOrderMeta: {
    fontSize: 11,
    color: BLINKIT.textMuted,
    marginTop: 4,
  },
  pastOrderRating: {
    fontSize: 11,
    fontWeight: '700',
    color: BLINKIT.green,
    marginTop: 4,
  },

  // ─── TAB 5: PROFILE ───
  profileCard: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#ffffff',
    borderRadius: 18,
    padding: 16,
    borderWidth: 1,
    borderColor: '#e2e8f0',
    marginBottom: 16,
  },
  profileAvatarBox: {
    width: 54,
    height: 54,
    borderRadius: 27,
    backgroundColor: BLINKIT.lightGreen,
    alignItems: 'center',
    justifyContent: 'center',
  },
  profileName: {
    fontSize: 16,
    fontWeight: '900',
    color: BLINKIT.textMain,
  },
  profilePhone: {
    fontSize: 12,
    color: BLINKIT.textMuted,
    marginTop: 2,
  },
  profileTier: {
    fontSize: 11,
    color: BLINKIT.green,
    fontWeight: '800',
    marginTop: 4,
  },
  menuBox: {
    backgroundColor: '#ffffff',
    borderRadius: 18,
    paddingVertical: 6,
    borderWidth: 1,
    borderColor: '#e2e8f0',
  },
  menuRow: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: 14,
    paddingHorizontal: 16,
    borderBottomWidth: 1,
    borderBottomColor: '#f1f5f9',
  },
  menuRowTitle: {
    fontSize: 13,
    fontWeight: '800',
    color: BLINKIT.textMain,
  },
  menuRowSub: {
    fontSize: 11,
    color: BLINKIT.textMuted,
    marginTop: 2,
  },
  menuChevron: {
    fontSize: 18,
    color: BLINKIT.textMuted,
  },

  // ─── FLOATING CART BAR (BLINKIT PILL) ───
  floatingCartContainer: {
    position: 'absolute',
    bottom: 80,
    left: 16,
    right: 16,
  },
  floatingCartPill: {
    backgroundColor: BLINKIT.green,
    borderRadius: 16,
    paddingVertical: 12,
    paddingHorizontal: 16,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    elevation: 8,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.3,
    shadowRadius: 6,
  },
  floatingCartLeft: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  cartCountBadge: {
    backgroundColor: '#ffffff',
    paddingHorizontal: 8,
    paddingVertical: 3,
    borderRadius: 8,
  },
  cartCountText: {
    color: BLINKIT.green,
    fontSize: 12,
    fontWeight: '900',
  },
  floatingCartPrice: {
    color: '#ffffff',
    fontSize: 14,
    fontWeight: '900',
  },
  floatingCartSub: {
    color: '#dcfce7',
    fontSize: 10,
    fontWeight: '600',
  },
  floatingCartRight: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  floatingCartCtaText: {
    color: '#ffffff',
    fontSize: 14,
    fontWeight: '900',
  },

  // ─── BOTTOM NAV ───
  bottomNav: {
    position: 'absolute',
    bottom: 0,
    left: 0,
    right: 0,
    height: 70,
    backgroundColor: '#ffffff',
    borderTopWidth: 1,
    borderTopColor: '#f1f5f9',
    flexDirection: 'row',
    justifyContent: 'space-around',
    alignItems: 'center',
    elevation: 6,
  },
  navItem: {
    alignItems: 'center',
    justifyContent: 'center',
  },
  navIcon: {
    fontSize: 20,
    color: BLINKIT.textMuted,
  },
  navIconActive: {
    transform: [{ scale: 1.15 }],
  },
  navLabel: {
    fontSize: 11,
    fontWeight: '600',
    color: BLINKIT.textMuted,
    marginTop: 2,
  },
  navLabelActive: {
    color: BLINKIT.green,
    fontWeight: '900',
  },

  // ─── FULL MODALS & SHEETS ───
  fullModalBlack: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    backgroundColor: '#000000',
    justifyContent: 'space-between',
  },
  cameraHeaderRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingTop: 40,
    paddingHorizontal: 20,
  },
  cameraCloseBtn: {
    color: '#ffffff',
    fontSize: 24,
    fontWeight: 'bold',
  },
  cameraAiPill: {
    backgroundColor: 'rgba(34, 197, 94, 0.3)',
    paddingHorizontal: 12,
    paddingVertical: 4,
    borderRadius: 999,
    borderWidth: 1,
    borderColor: '#4ade80',
  },
  cameraAiPillText: {
    color: '#4ade80',
    fontSize: 11,
    fontWeight: '900',
  },
  viewfinderBox: {
    alignItems: 'center',
    justifyContent: 'center',
    paddingHorizontal: 20,
  },
  viewfinderFrame: {
    width: width - 80,
    height: width - 80,
    borderWidth: 2,
    borderColor: BLINKIT.green,
    borderRadius: 24,
    borderStyle: 'dashed',
    position: 'relative',
    overflow: 'hidden',
  },
  laserScanLine: {
    height: 3,
    backgroundColor: '#4ade80',
    width: '100%',
    shadowColor: '#4ade80',
    shadowOpacity: 1,
    shadowRadius: 8,
    elevation: 6,
  },
  detectedBoxTag1: {
    position: 'absolute',
    top: 40,
    left: 30,
    backgroundColor: 'rgba(12, 131, 31, 0.85)',
    paddingHorizontal: 8,
    paddingVertical: 3,
    borderRadius: 6,
  },
  detectedBoxTag2: {
    position: 'absolute',
    bottom: 50,
    right: 30,
    backgroundColor: 'rgba(59, 130, 246, 0.85)',
    paddingHorizontal: 8,
    paddingVertical: 3,
    borderRadius: 6,
  },
  detectedBoxTagText: {
    color: '#ffffff',
    fontSize: 11,
    fontWeight: '800',
  },
  viewfinderPrompt: {
    color: '#ffffff',
    fontSize: 13,
    marginTop: 16,
    fontWeight: '600',
  },
  cameraBottomCard: {
    backgroundColor: '#1e293b',
    borderTopLeftRadius: 24,
    borderTopRightRadius: 24,
    padding: 20,
    paddingBottom: 30,
  },
  detectionResultHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 14,
  },
  detectedTitle: {
    color: '#ffffff',
    fontSize: 15,
    fontWeight: '800',
  },
  detectedEstVal: {
    color: '#4ade80',
    fontSize: 18,
    fontWeight: '900',
  },
  cameraSnapBtn: {
    backgroundColor: BLINKIT.green,
    paddingVertical: 15,
    borderRadius: 14,
    alignItems: 'center',
  },
  cameraSnapBtnText: {
    color: '#ffffff',
    fontSize: 14,
    fontWeight: '900',
  },

  // Modal Sheet Overlays
  fullModalOverlay: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    backgroundColor: '#ffffff',
  },
  cartModalScroll: {
    padding: 20,
    paddingBottom: 40,
  },
  modalHeaderRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    marginBottom: 16,
  },
  modalBackArrow: {
    fontSize: 24,
    fontWeight: 'bold',
    color: BLINKIT.textMain,
  },
  modalTitle: {
    fontSize: 18,
    fontWeight: '900',
    color: BLINKIT.textMain,
  },
  cartAddressCard: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#f8fafc',
    borderRadius: 14,
    padding: 12,
    borderWidth: 1,
    borderColor: '#e2e8f0',
    marginBottom: 16,
  },
  cartAddressTitle: {
    fontSize: 12,
    fontWeight: '800',
    color: BLINKIT.textMain,
  },
  cartAddressSub: {
    fontSize: 11,
    color: BLINKIT.textMuted,
    marginTop: 2,
  },
  changeAddressLink: {
    fontSize: 12,
    fontWeight: '800',
    color: BLINKIT.green,
  },
  cartSectionTitle: {
    fontSize: 14,
    fontWeight: '800',
    color: BLINKIT.textMain,
    marginBottom: 8,
  },
  slotGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 8,
    marginBottom: 10,
  },
  cartSlotPill: {
    width: '48%',
    paddingVertical: 10,
    borderRadius: 10,
    borderWidth: 1.5,
    borderColor: '#e2e8f0',
    alignItems: 'center',
    backgroundColor: '#ffffff',
  },
  cartSlotPillActive: {
    borderColor: BLINKIT.green,
    backgroundColor: BLINKIT.lightGreen,
  },
  cartSlotText: {
    fontSize: 11,
    fontWeight: '700',
    color: BLINKIT.textMain,
  },
  cartSlotTextActive: {
    color: BLINKIT.green,
    fontWeight: '900',
  },
  cartItemRow: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#ffffff',
    paddingVertical: 10,
    borderBottomWidth: 1,
    borderBottomColor: '#f1f5f9',
  },
  cartItemName: {
    fontSize: 13,
    fontWeight: '800',
    color: BLINKIT.textMain,
  },
  cartItemSub: {
    fontSize: 11,
    color: BLINKIT.textMuted,
    marginTop: 2,
  },
  cartItemPrice: {
    fontSize: 13,
    fontWeight: '900',
    color: BLINKIT.green,
  },
  billSummaryBox: {
    backgroundColor: '#f8fafc',
    borderRadius: 14,
    padding: 14,
    marginTop: 16,
    borderWidth: 1,
    borderColor: '#e2e8f0',
  },
  billRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 6,
  },
  billRowTotal: {
    marginTop: 6,
    paddingTop: 8,
    borderTopWidth: 1,
    borderTopColor: '#e2e8f0',
  },
  billLabel: {
    fontSize: 12,
    color: BLINKIT.textMuted,
  },
  billVal: {
    fontSize: 12,
    fontWeight: '700',
    color: BLINKIT.textMain,
  },
  billValGreen: {
    fontSize: 12,
    fontWeight: '800',
    color: BLINKIT.green,
  },
  billTotalLabel: {
    fontSize: 13,
    fontWeight: '900',
    color: BLINKIT.textMain,
  },
  billTotalVal: {
    fontSize: 16,
    fontWeight: '900',
    color: BLINKIT.green,
  },
  confirmBookingBtn: {
    backgroundColor: BLINKIT.green,
    paddingVertical: 16,
    borderRadius: 14,
    alignItems: 'center',
    marginTop: 20,
  },
  confirmBookingBtnText: {
    color: '#ffffff',
    fontSize: 15,
    fontWeight: '900',
  },

  // Map Simulation Tracking
  mapSimulationBox: {
    height: 180,
    backgroundColor: '#e2e8f0',
    borderRadius: 18,
    position: 'relative',
    overflow: 'hidden',
    alignItems: 'center',
    justifyContent: 'center',
    marginBottom: 16,
  },
  mapRouteOverlay: {
    alignItems: 'center',
    justifyContent: 'center',
  },
  liveTruckMarker: {
    position: 'absolute',
    top: -20,
    left: -40,
    backgroundColor: '#ffffff',
    padding: 4,
    borderRadius: 999,
    elevation: 4,
  },
  destinationMarker: {
    position: 'absolute',
    bottom: -20,
    right: -40,
    backgroundColor: '#ffffff',
    padding: 4,
    borderRadius: 999,
    elevation: 4,
  },
  liveEtaPill: {
    position: 'absolute',
    bottom: 10,
    backgroundColor: BLINKIT.green,
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 999,
  },
  liveEtaPillText: {
    color: '#ffffff',
    fontSize: 11,
    fontWeight: '900',
  },
  driverProfileCard: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#f8fafc',
    borderRadius: 16,
    padding: 14,
    borderWidth: 1,
    borderColor: '#e2e8f0',
    marginBottom: 16,
  },
  driverAvatar: {
    width: 48,
    height: 48,
    borderRadius: 24,
    backgroundColor: BLINKIT.lightGreen,
    alignItems: 'center',
    justifyContent: 'center',
  },
  driverCardName: {
    fontSize: 14,
    fontWeight: '900',
    color: BLINKIT.textMain,
  },
  driverCardRating: {
    fontSize: 11,
    color: BLINKIT.green,
    fontWeight: '700',
    marginTop: 2,
  },
  driverVehicleNo: {
    fontSize: 11,
    color: BLINKIT.textMuted,
    marginTop: 2,
  },
  driverCallBtn: {
    width: 40,
    height: 40,
    borderRadius: 20,
    backgroundColor: '#ffffff',
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 1,
    borderColor: '#e2e8f0',
  },
  stepperCard: {
    backgroundColor: '#ffffff',
    borderRadius: 16,
    padding: 16,
    borderWidth: 1,
    borderColor: '#e2e8f0',
    marginBottom: 16,
  },
  stepRow: {
    flexDirection: 'row',
    alignItems: 'flex-start',
    marginBottom: 16,
  },
  stepCircle: {
    width: 22,
    height: 22,
    borderRadius: 11,
    alignItems: 'center',
    justifyContent: 'center',
    marginTop: 2,
  },
  stepCircleDone: {
    backgroundColor: BLINKIT.green,
  },
  stepCirclePending: {
    backgroundColor: '#cbd5e1',
  },
  stepTitle: {
    fontSize: 13,
    fontWeight: '700',
    color: BLINKIT.textMuted,
  },
  stepTitleDone: {
    color: BLINKIT.textMain,
    fontWeight: '900',
  },
  stepTime: {
    fontSize: 10,
    color: BLINKIT.textMuted,
    marginTop: 2,
  },
  doneModalBtn: {
    backgroundColor: '#f1f5f9',
    paddingVertical: 14,
    borderRadius: 14,
    alignItems: 'center',
  },
  doneModalBtnText: {
    color: BLINKIT.textMain,
    fontSize: 14,
    fontWeight: '800',
  },

  // Scratch Modal
  scratchModalOverlay: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    backgroundColor: 'rgba(0, 0, 0, 0.75)',
    justifyContent: 'center',
    alignItems: 'center',
    padding: 24,
  },
  scratchCardSheet: {
    width: '100%',
    backgroundColor: '#0f172a',
    borderRadius: 24,
    padding: 24,
    alignItems: 'center',
    position: 'relative',
  },
  closeScratchBtn: {
    position: 'absolute',
    top: 16,
    right: 16,
  },
  scratchModalHeading: {
    fontSize: 20,
    fontWeight: '900',
    color: '#ffffff',
    marginBottom: 6,
  },
  scratchModalSub: {
    fontSize: 12,
    color: '#94a3b8',
    textAlign: 'center',
    marginBottom: 20,
  },
  scratchSurfaceCard: {
    width: '100%',
    height: 180,
    borderRadius: 18,
    overflow: 'hidden',
    borderWidth: 2,
    borderColor: '#f59e0b',
  },
  unscratchedCover: {
    flex: 1,
    backgroundColor: '#b45309',
    alignItems: 'center',
    justifyContent: 'center',
  },
  tapToScratchText: {
    color: '#fef08a',
    fontSize: 16,
    fontWeight: '900',
    marginTop: 8,
  },
  tapToScratchSub: {
    color: '#fde68a',
    fontSize: 11,
    marginTop: 2,
  },
  scratchedRewardContent: {
    flex: 1,
    backgroundColor: '#ffffff',
    alignItems: 'center',
    justifyContent: 'center',
    padding: 16,
  },
  rewardBigAmount: {
    fontSize: 20,
    fontWeight: '900',
    color: BLINKIT.green,
    marginTop: 4,
  },
  rewardCashEquiv: {
    fontSize: 13,
    color: BLINKIT.textMain,
    fontWeight: '700',
    marginTop: 2,
  },
  claimedPill: {
    backgroundColor: '#dcfce7',
    paddingHorizontal: 10,
    paddingVertical: 4,
    borderRadius: 999,
    marginTop: 8,
  },
  claimedPillText: {
    color: BLINKIT.green,
    fontSize: 10,
    fontWeight: '900',
  },
  claimDoneBtn: {
    backgroundColor: BLINKIT.green,
    width: '100%',
    paddingVertical: 14,
    borderRadius: 14,
    alignItems: 'center',
    marginTop: 16,
  },
  claimDoneBtnText: {
    color: '#ffffff',
    fontSize: 14,
    fontWeight: '900',
  },

  // Confirmed Box
  confirmedBox: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    padding: 24,
  },
  confirmedCircle: {
    width: 100,
    height: 100,
    borderRadius: 50,
    backgroundColor: BLINKIT.lightGreen,
    alignItems: 'center',
    justifyContent: 'center',
    marginBottom: 20,
    borderWidth: 2,
    borderColor: '#86efac',
  },
  confirmedTitle: {
    fontSize: 24,
    fontWeight: '900',
    color: BLINKIT.textMain,
    marginBottom: 8,
  },
  confirmedSub: {
    fontSize: 13,
    color: BLINKIT.textMuted,
    textAlign: 'center',
    lineHeight: 18,
    marginBottom: 24,
    paddingHorizontal: 20,
  },
  trackConfirmedBtn: {
    backgroundColor: BLINKIT.green,
    width: '100%',
    paddingVertical: 16,
    borderRadius: 14,
    alignItems: 'center',
    marginBottom: 10,
  },
  trackConfirmedBtnText: {
    color: '#ffffff',
    fontSize: 15,
    fontWeight: '900',
  },
  backHomeBtn: {
    paddingVertical: 12,
  },
  backHomeBtnText: {
    color: BLINKIT.textMuted,
    fontSize: 13,
    fontWeight: '700',
  },

  // Address Sheet
  addressSheet: {
    position: 'absolute',
    bottom: 0,
    left: 0,
    right: 0,
    backgroundColor: '#ffffff',
    borderTopLeftRadius: 24,
    borderTopRightRadius: 24,
    padding: 20,
    paddingBottom: 34,
  },
  sheetTitle: {
    fontSize: 16,
    fontWeight: '900',
    color: BLINKIT.textMain,
    marginBottom: 16,
  },
  addressOptionRow: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: 14,
    borderBottomWidth: 1,
    borderBottomColor: '#f1f5f9',
  },
  addressOptionSelected: {
    backgroundColor: BLINKIT.lightGreen,
    borderRadius: 10,
    paddingHorizontal: 8,
  },
  addressOptionText: {
    fontSize: 13,
    fontWeight: '700',
    color: BLINKIT.textMain,
    flex: 1,
  },
});
