import React, { useState } from 'react';
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
  Alert
} from 'react-native';
import { translations, Language } from './src/i18n';

const { width } = Dimensions.get('window');

// High contrast palette for outdoor visibility, large touch targets
const COLORS = {
  bg: '#121214',
  card: '#1e1e24',
  border: 'rgba(255, 255, 255, 0.08)',
  primary: '#10b981', // green
  text: '#ffffff',
  textSecondary: '#a0aec0',
  danger: '#ef4444', // red
  warning: '#f59e0b', // orange
  info: '#3b82f6', // blue
  lightCard: '#2d2d34',
  darkGreen: '#064e3b'
};

// Initial mock route stops with specialized service types matching Figma spec
const INITIAL_STOPS = [
  { id: 's1', sequence_order: 1, household_address: 'G-12, Sector 4, Shalimar Garden', household_phone: '9876543210', status: 'pending', type: 'garbage' },
  { id: 's2', sequence_order: 2, household_address: 'GVP Point #3, Shalimar Garden Crossing', household_phone: 'Ops Command', status: 'pending', type: 'dump' },
  { id: 's3', sequence_order: 3, household_address: 'Rajendra scrap dealers, Lane 2', household_phone: '9123456789', status: 'pending', type: 'scrap' },
  { id: 's4', sequence_order: 4, household_address: 'Shop 5, Corner Market, Sector 4', household_phone: '9811223344', status: 'pending', type: 'recyclable' },
  { id: 's5', sequence_order: 5, household_address: 'Drainage blockage, Shalimar Road', household_phone: 'Ops Command', status: 'pending', type: 'sewer' },
];

export default function App() {
  const [lang, setLang] = useState<Language>('hi'); // Default Hindi for Ghaziabad pilot
  const [isAuthenticated, setIsAuthenticated] = useState<boolean>(true); // default true for demo preview
  const [currentTab, setCurrentTab] = useState<'route' | 'summary' | 'earnings' | 'safety'>('route');
  
  // Shift management
  const [dutyActive, setDutyActive] = useState<boolean>(true);
  const [jobFeedTab, setJobFeedTab] = useState<'active' | 'available'>('active');
  const [availableJobs, setAvailableJobs] = useState([
    { id: 'aj1', sequence_order: 6, household_address: 'Sewer Clearance - Shalimar Lane 2', household_phone: '9876543210', status: 'pending', type: 'sewer' },
    { id: 'aj2', sequence_order: 7, household_address: 'Commercial Scrap - Kavi Nagar Block B', household_phone: '9988776655', status: 'pending', type: 'scrap' }
  ]);

  // Login credentials
  const [phone, setPhone] = useState('');
  const [pin, setPin] = useState('');

  // Active Route State
  const [stops, setStops] = useState(INITIAL_STOPS);
  const [activeStop, setActiveStop] = useState<any>(null);
  const [arrivedAtStop, setArrivedAtStop] = useState<boolean>(false);
  
  // Verification Form State
  const [activeStream, setActiveStream] = useState<'wet' | 'dry' | 'reject'>('wet');
  const [photoCaptured, setPhotoCaptured] = useState<Record<string, boolean>>({
    wet: false,
    dry: false,
    reject: false
  });
  const [weights, setWeights] = useState<Record<string, string>>({
    wet: '',
    dry: '',
    reject: ''
  });
  const [qualities, setQualities] = useState<Record<string, 'clean' | 'partial' | 'none'>>({
    wet: 'clean',
    dry: 'clean',
    reject: 'clean'
  });

  // Customer OTP Verification State
  const [customerOtp, setCustomerOtp] = useState<string>('');
  const [showOtpScreen, setShowOtpScreen] = useState<boolean>(false);

  // Safety & SOS States
  const [hazardReports, setHazardReports] = useState([
    { id: 'hr1', type: 'Unsafe Waste', desc: 'Broken container with sharp glass on Sector 4 main road.', time: '10:30 AM' }
  ]);
  const [showHazardModal, setShowHazardModal] = useState<boolean>(false);
  const [newHazardType, setNewHazardType] = useState<string>('Unsafe Waste');
  const [newHazardDesc, setNewHazardDesc] = useState<string>('');
  const [sosActive, setSosActive] = useState<boolean>(false);

  // Offline Simulation State
  const [isOffline, setIsOffline] = useState<boolean>(false);
  const [offlineQueue, setOfflineQueue] = useState<any[]>([]);

  const t = (key: keyof typeof translations.en) => {
    return translations[lang][key] || translations['en'][key];
  };

  const toggleLanguage = () => {
    setLang(lang === 'en' ? 'hi' : 'en');
  };

  const handleLogin = () => {
    if (phone && pin) {
      setIsAuthenticated(true);
    } else {
      Alert.alert(t('invalid_credentials'));
    }
  };

  // Simulating photo capture
  const handleCapturePhoto = (stream: 'wet' | 'dry' | 'reject') => {
    setPhotoCaptured(prev => ({ ...prev, [stream]: true }));
    Alert.alert(t('photo_taken'));
  };

  // Confirm Verification Form
  const handleConfirmSaveStop = () => {
    // If sewer clearance, photo is sufficient
    if (activeStop.type === 'sewer') {
      const photoOk = photoCaptured['wet'] || photoCaptured['dry'] || photoCaptured['reject'];
      if (!photoOk) {
        Alert.alert("Error", "Please take a photo of the completed drain clearance");
        return;
      }
    } else {
      // Check if at least one stream has photo and weight
      const completedStreams = Object.keys(weights).filter(
        key => weights[key] && photoCaptured[key]
      );

      if (completedStreams.length === 0) {
        Alert.alert("Error", "Please record photo and weight for at least one waste category");
        return;
      }
    }

    // Require Customer OTP for standard household and commercial scrap/recyclables
    if (!showOtpScreen && (activeStop.type === 'garbage' || activeStop.type === 'scrap' || activeStop.type === 'recyclable')) {
      setShowOtpScreen(true);
      return;
    }

    if (showOtpScreen && customerOtp !== '123456' && customerOtp !== '999999') {
      Alert.alert("Error", "Invalid OTP. Please check the OTP sent to requestor.");
      return;
    }

    const completedStreams = Object.keys(weights).filter(
      key => weights[key] && photoCaptured[key]
    );

    const verificationRecord = {
      stop_id: activeStop.id,
      timestamp: new Date().toISOString(),
      streams: completedStreams.map(stream => ({
        stream,
        weight_kg: Number(weights[stream]),
        segregation_quality: qualities[stream],
        photo: 'https://picsum.photos/400/300'
      }))
    };

    if (isOffline) {
      setOfflineQueue([...offlineQueue, verificationRecord]);
    }

    // Update stop status to done
    setStops(stops.map(s => s.id === activeStop.id ? { ...s, status: 'done' } : s));

    // Reset Form
    setArrivedAtStop(false);
    setActiveStop(null);
    setShowOtpScreen(false);
    setCustomerOtp('');
    setPhotoCaptured({ wet: false, dry: false, reject: false });
    setWeights({ wet: '', dry: '', reject: '' });
    setQualities({ wet: 'clean', dry: 'clean', reject: 'clean' });

    Alert.alert("Saved", isOffline ? t('offline_mode') : "Stop verification synced successfully");
  };

  const handleMarkMissed = (reason: 'not_home' | 'gate_locked' | 'refused') => {
    setStops(stops.map(s => s.id === activeStop.id ? { ...s, status: 'missed' } : s));
    setArrivedAtStop(false);
    setActiveStop(null);
    Alert.alert("Saved", `Stop marked missed: ${t(reason)}`);
  };

  const handleSyncQueue = () => {
    if (offlineQueue.length > 0) {
      Alert.alert("Syncing", t('syncing'), [
        {
          text: "OK",
          onPress: () => {
            setOfflineQueue([]);
            Alert.alert("Success", "All offline records successfully uploaded");
          }
        }
      ]);
    } else {
      Alert.alert("Sync", "No pending offline records to sync");
    }
  };

  // Helper stats
  const completedCount = stops.filter(s => s.status === 'done').length;
  const missedCount = stops.filter(s => s.status === 'missed').length;
  const pendingCount = stops.filter(s => s.status === 'pending').length;

  if (!isAuthenticated) {
    return (
      <SafeAreaView style={styles.container}>
        <StatusBar barStyle="light-content" />
        <View style={styles.loginContainer}>
          <Text style={styles.appTitle}>SWACHHTA</Text>
          <Text style={styles.loginTitle}>{t('login_title')}</Text>

          <View style={styles.formGroup}>
            <Text style={styles.label}>{t('phone_label')}</Text>
            <TextInput 
              style={styles.input}
              placeholder="98765 43210"
              placeholderTextColor={COLORS.textSecondary}
              keyboardType="numeric"
              maxLength={10}
              value={phone}
              onChangeText={setPhone}
            />
          </View>

          <View style={styles.formGroup}>
            <Text style={styles.label}>{t('pin_label')}</Text>
            <TextInput 
              style={styles.input}
              placeholder="••••"
              placeholderTextColor={COLORS.textSecondary}
              keyboardType="numeric"
              maxLength={4}
              secureTextEntry
              value={pin}
              onChangeText={setPin}
            />
          </View>

          <TouchableOpacity style={[styles.button, { marginTop: 20 }]} onPress={handleLogin}>
            <Text style={styles.buttonText}>{t('login_btn')}</Text>
          </TouchableOpacity>

          <TouchableOpacity style={styles.langBtn} onPress={toggleLanguage}>
            <Text style={styles.langBtnText}>{t('lang_toggle')}</Text>
          </TouchableOpacity>
        </View>
      </SafeAreaView>
    );
  }

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar barStyle="light-content" />

      {/* Header bar */}
      <View style={styles.header}>
        <View>
          <Text style={styles.headerTitle}>{t('app_title')}</Text>
          <Text style={styles.workerName}>Ramesh Kumar (GZB)</Text>
        </View>
        <View style={styles.headerControls}>
          <TouchableOpacity style={styles.offlineToggle} onPress={() => setIsOffline(!isOffline)}>
            <View style={[styles.statusDot, { backgroundColor: isOffline ? COLORS.warning : COLORS.primary }]} />
            <Text style={styles.offlineToggleText}>{isOffline ? "Offline" : "Online"}</Text>
          </TouchableOpacity>
          <TouchableOpacity style={styles.headerLang} onPress={toggleLanguage}>
            <Text style={styles.headerLangText}>{lang === 'hi' ? 'EN' : 'हिं'}</Text>
          </TouchableOpacity>
        </View>
      </View>

      {/* Offline sync banner if offline queue has items */}
      {offlineQueue.length > 0 && (
        <TouchableOpacity style={styles.syncBanner} onPress={handleSyncQueue}>
          <Text style={styles.syncBannerText}>
             ⚡ {offlineQueue.length} records saved offline. Tap to Sync now!
          </Text>
        </TouchableOpacity>
      )}

      {/* STOP DETAIL VIEW (If stop active) */}
      {activeStop ? (
        <ScrollView contentContainerStyle={styles.scrollContainer}>
          <View style={styles.activeStopCard}>
            <View style={styles.activeStopHeader}>
              <Text style={styles.activeStopTitle}>Stop #{activeStop.sequence_order}</Text>
              <TouchableOpacity style={styles.closeActiveStop} onPress={() => { setActiveStop(null); setArrivedAtStop(false); }}>
                <Text style={{ color: COLORS.textSecondary, fontSize: 24, fontWeight: '700' }}>&times;</Text>
              </TouchableOpacity>
            </View>
            <Text style={styles.activeStopAddress}>{activeStop.household_address}</Text>
            <Text style={styles.activeStopPhone}>📞 +91 {activeStop.household_phone}</Text>

            {!arrivedAtStop ? (
              <View style={styles.arriveContainer}>
                <TouchableOpacity style={[styles.largeButton, { backgroundColor: COLORS.info }]} onPress={() => setArrivedAtStop(true)}>
                  <Text style={styles.largeButtonText}>📍 {t('arrived')}</Text>
                </TouchableOpacity>
                
                <Text style={[styles.label, { marginTop: 24 }]}>{t('missed_stop')}</Text>
                <View style={styles.missedGrid}>
                  <TouchableOpacity style={styles.missedBtn} onPress={() => handleMarkMissed('not_home')}>
                    <Text style={styles.missedBtnText}>{t('not_home')}</Text>
                  </TouchableOpacity>
                  <TouchableOpacity style={styles.missedBtn} onPress={() => handleMarkMissed('gate_locked')}>
                    <Text style={styles.missedBtnText}>{t('gate_locked')}</Text>
                  </TouchableOpacity>
                  <TouchableOpacity style={styles.missedBtn} onPress={() => handleMarkMissed('refused')}>
                    <Text style={styles.missedBtnText}>{t('refused')}</Text>
                  </TouchableOpacity>
                </View>
              </View>
            ) : showOtpScreen ? (
              // OTP VERIFICATION VIEW
              <View style={styles.verifyForm}>
                <Text style={styles.label}>{t('otp_verification')}</Text>
                <Text style={{ color: COLORS.textSecondary, marginBottom: 12, fontSize: 13 }}>
                  {t('enter_otp')} (+91 {activeStop.household_phone})
                </Text>
                
                <TextInput 
                  style={[styles.weightInput, { letterSpacing: 8, fontSize: 24, textAlign: 'center' }]}
                  placeholder="••••••"
                  placeholderTextColor={COLORS.textSecondary}
                  keyboardType="numeric"
                  maxLength={6}
                  value={customerOtp}
                  onChangeText={setCustomerOtp}
                />
                
                <Text style={{ color: COLORS.textSecondary, fontSize: 11, marginTop: 6, marginBottom: 20 }}>
                  💡 Hint: Enter 123456 or 999999 to verify mock OTP.
                </Text>

                <TouchableOpacity style={styles.largeButton} onPress={handleConfirmSaveStop}>
                  <Text style={styles.largeButtonText}>✓ {t('verify_submit')}</Text>
                </TouchableOpacity>

                <TouchableOpacity 
                  style={{ marginTop: 12, alignItems: 'center' }} 
                  onPress={() => setShowOtpScreen(false)}
                >
                  <Text style={{ color: COLORS.danger, fontWeight: '700' }}>Cancel</Text>
                </TouchableOpacity>
              </View>
            ) : (
              // MAIN VERIFICATION FORM
              <View style={styles.verifyForm}>
                
                {/* 1. Category Specific Flow */}
                {activeStop.type === 'garbage' && (
                  <View>
                    <Text style={styles.label}>{t('select_stream')}</Text>
                    {/* Waste category tabs */}
                    <View style={styles.streamTabs}>
                      {(['wet', 'dry', 'reject'] as const).map(stream => (
                        <TouchableOpacity 
                          key={stream}
                          style={[
                            styles.streamTab, 
                            activeStream === stream && styles.streamTabActive,
                            activeStream === stream && {
                              borderColor: stream === 'wet' ? COLORS.primary : stream === 'dry' ? COLORS.info : COLORS.warning
                            }
                          ]}
                          onPress={() => setActiveStream(stream)}
                        >
                          <Text style={[
                            styles.streamTabText,
                            activeStream === stream && {
                              color: stream === 'wet' ? COLORS.primary : stream === 'dry' ? COLORS.info : COLORS.warning
                            }
                          ]}>
                            {t(`total_${stream}`).replace('Total ', '').replace('कुल ', '')}
                          </Text>
                        </TouchableOpacity>
                      ))}
                    </View>

                    <View style={styles.streamFormBlock}>
                      <TouchableOpacity 
                        style={[styles.photoButton, photoCaptured[activeStream] && styles.photoButtonActive]}
                        onPress={() => handleCapturePhoto(activeStream)}
                      >
                        <Text style={styles.photoButtonText}>
                          {photoCaptured[activeStream] ? "✓ Photo Captured" : "📷 Take Waste Photo"}
                        </Text>
                      </TouchableOpacity>

                      <Text style={[styles.label, { marginTop: 16 }]}>{t('weight_label')}</Text>
                      <TextInput 
                        style={styles.weightInput}
                        placeholder="e.g. 1.5"
                        placeholderTextColor={COLORS.textSecondary}
                        keyboardType="numeric"
                        value={weights[activeStream]}
                        onChangeText={val => setWeights(prev => ({ ...prev, [activeStream]: val }))}
                      />

                      <Text style={[styles.label, { marginTop: 16 }]}>{t('quality_label')}</Text>
                      <View style={styles.qualityContainer}>
                        {[
                          { id: 'clean', label: t('quality_clean'), color: COLORS.primary },
                          { id: 'partial', label: t('quality_partial'), color: COLORS.warning },
                          { id: 'none', label: t('quality_none'), color: COLORS.danger },
                        ].map(opt => (
                          <TouchableOpacity 
                            key={opt.id}
                            style={[
                              styles.qualityOption, 
                              qualities[activeStream] === opt.id && { backgroundColor: opt.color, borderColor: opt.color }
                            ]}
                            onPress={() => setQualities(prev => ({ ...prev, [activeStream]: opt.id as any }))}
                          >
                            <Text style={[
                              styles.qualityOptionText,
                              qualities[activeStream] === opt.id && { color: COLORS.bg }
                            ]}>
                              {opt.label.split(' ')[0]}
                            </Text>
                          </TouchableOpacity>
                        ))}
                      </View>
                    </View>
                  </View>
                )}

                {activeStop.type === 'dump' && (
                  <View style={styles.streamFormBlock}>
                    <Text style={styles.label}>{t('checklist_dump')}</Text>
                    <TouchableOpacity 
                      style={[styles.photoButton, photoCaptured['wet'] && styles.photoButtonActive]}
                      onPress={() => handleCapturePhoto('wet')}
                    >
                      <Text style={styles.photoButtonText}>
                        {photoCaptured['wet'] ? "✓ Before + After Photos Captured" : "📷 Capture Clean-up Photos"}
                      </Text>
                    </TouchableOpacity>

                    <Text style={[styles.label, { marginTop: 16 }]}>{t('weight_label')}</Text>
                    <TextInput 
                      style={styles.weightInput}
                      placeholder="e.g. 45.0"
                      placeholderTextColor={COLORS.textSecondary}
                      keyboardType="numeric"
                      value={weights['wet']}
                      onChangeText={val => setWeights(prev => ({ ...prev, wet: val }))}
                    />
                  </View>
                )}

                {activeStop.type === 'scrap' && (
                  <View style={styles.streamFormBlock}>
                    <Text style={styles.label}>{t('checklist_scrap')}</Text>
                    <TouchableOpacity 
                      style={[styles.photoButton, photoCaptured['dry'] && styles.photoButtonActive]}
                      onPress={() => handleCapturePhoto('dry')}
                    >
                      <Text style={styles.photoButtonText}>
                        {photoCaptured['dry'] ? "✓ Scrap Photo Captured" : "📷 Take Scrap Photo"}
                      </Text>
                    </TouchableOpacity>

                    <Text style={[styles.label, { marginTop: 16 }]}>{t('weight_label')}</Text>
                    <TextInput 
                      style={styles.weightInput}
                      placeholder="e.g. 12.5"
                      placeholderTextColor={COLORS.textSecondary}
                      keyboardType="numeric"
                      value={weights['dry']}
                      onChangeText={val => setWeights(prev => ({ ...prev, dry: val }))}
                    />
                  </View>
                )}

                {activeStop.type === 'recyclable' && (
                  <View style={styles.streamFormBlock}>
                    <Text style={styles.label}>{t('checklist_recyclable')}</Text>
                    <TouchableOpacity 
                      style={[styles.photoButton, photoCaptured['dry'] && styles.photoButtonActive]}
                      onPress={() => handleCapturePhoto('dry')}
                    >
                      <Text style={styles.photoButtonText}>
                        {photoCaptured['dry'] ? "✓ Recyclable Photo Captured" : "📷 Take Recyclables Photo"}
                      </Text>
                    </TouchableOpacity>

                    <Text style={[styles.label, { marginTop: 16 }]}>{t('weight_label')}</Text>
                    <TextInput 
                      style={styles.weightInput}
                      placeholder="e.g. 5.5"
                      placeholderTextColor={COLORS.textSecondary}
                      keyboardType="numeric"
                      value={weights['dry']}
                      onChangeText={val => setWeights(prev => ({ ...prev, dry: val }))}
                    />
                  </View>
                )}

                {activeStop.type === 'sewer' && (
                  <View style={styles.streamFormBlock}>
                    <Text style={styles.label}>{t('checklist_sewer')}</Text>
                    
                    <View style={{ gap: 8, marginVertical: 12 }}>
                      <Text style={{ color: COLORS.text, fontSize: 13 }}>✓ Drain silt cleared / नाली साफ की गई</Text>
                      <Text style={{ color: COLORS.text, fontSize: 13 }}>✓ Disinfectant powder sprayed / पाउडर छिड़का गया</Text>
                      <Text style={{ color: COLORS.text, fontSize: 13 }}>✓ Cover re-fitted / ढक्कन वापस लगाया गया</Text>
                    </View>

                    <TouchableOpacity 
                      style={[styles.photoButton, photoCaptured['wet'] && styles.photoButtonActive]}
                      onPress={() => handleCapturePhoto('wet')}
                    >
                      <Text style={styles.photoButtonText}>
                        {photoCaptured['wet'] ? "✓ Work Proof Photo Captured" : "📷 Take Verification Photo"}
                      </Text>
                    </TouchableOpacity>
                  </View>
                )}

                {/* 2. Live Bonus Calculator Panel */}
                <View style={[styles.summaryCard, { marginTop: 20, backgroundColor: COLORS.lightCard }]}>
                  <Text style={[styles.label, { color: COLORS.bg }]}>{t('bonus_calculator')}</Text>
                  
                  <View style={{ flexDirection: 'row', justifyContent: 'space-between', marginVertical: 4 }}>
                    <Text style={{ color: COLORS.bg, fontSize: 13 }}>{t('base_pay')}:</Text>
                    <Text style={{ color: COLORS.bg, fontWeight: '700', fontSize: 13 }}>
                      ₹{activeStop.type === 'sewer' ? 120 : activeStop.type === 'dump' ? 100 : activeStop.type === 'scrap' ? 40 : 50}
                    </Text>
                  </View>

                  {activeStop.type === 'garbage' && (
                    <View style={{ flexDirection: 'row', justifyContent: 'space-between', marginVertical: 4 }}>
                      <Text style={{ color: COLORS.bg, fontSize: 13 }}>{t('bonus_est')} ({qualities[activeStream]}):</Text>
                      <Text style={{ color: COLORS.bg, fontWeight: '700', fontSize: 13 }}>
                        +₹{qualities[activeStream] === 'clean' ? 20 : qualities[activeStream] === 'partial' ? 5 : 0}
                      </Text>
                    </View>
                  )}

                  {activeStop.type === 'dump' && weights['wet'] && (
                    <View style={{ flexDirection: 'row', justifyContent: 'space-between', marginVertical: 4 }}>
                      <Text style={{ color: COLORS.bg, fontSize: 13 }}>Weight Bonus (+₹2/kg):</Text>
                      <Text style={{ color: COLORS.bg, fontWeight: '700', fontSize: 13 }}>
                        +₹{(Number(weights['wet']) * 2).toFixed(0)}
                      </Text>
                    </View>
                  )}

                  {activeStop.type === 'scrap' && weights['dry'] && (
                    <View style={{ flexDirection: 'row', justifyContent: 'space-between', marginVertical: 4 }}>
                      <Text style={{ color: COLORS.bg, fontSize: 13 }}>Weight Bonus (+₹5/kg):</Text>
                      <Text style={{ color: COLORS.bg, fontWeight: '700', fontSize: 13 }}>
                        +₹{(Number(weights['dry']) * 5).toFixed(0)}
                      </Text>
                    </View>
                  )}

                  {activeStop.type === 'recyclable' && weights['dry'] && (
                    <View style={{ flexDirection: 'row', justifyContent: 'space-between', marginVertical: 4 }}>
                      <Text style={{ color: COLORS.bg, fontSize: 13 }}>Recyclable Bonus (+₹3/kg):</Text>
                      <Text style={{ color: COLORS.bg, fontWeight: '700', fontSize: 13 }}>
                        +₹{(Number(weights['dry']) * 3).toFixed(0)}
                      </Text>
                    </View>
                  )}

                  <View style={{ borderTopWidth: 1, borderTopColor: 'rgba(0,0,0,0.1)', marginTop: 8, paddingTop: 8, flexDirection: 'row', justifyContent: 'space-between' }}>
                    <Text style={{ color: COLORS.bg, fontWeight: '800', fontSize: 15 }}>{t('total_est_earning')}:</Text>
                    <Text style={{ color: COLORS.bg, fontWeight: '900', fontSize: 15 }}>
                      ₹{
                        (activeStop.type === 'sewer' ? 120 :
                         activeStop.type === 'dump' ? 100 + (Number(weights['wet']) || 0) * 2 :
                         activeStop.type === 'scrap' ? 40 + (Number(weights['dry']) || 0) * 5 :
                         activeStop.type === 'recyclable' ? 50 + (Number(weights['dry']) || 0) * 3 :
                         50 + (qualities[activeStream] === 'clean' ? 20 : qualities[activeStream] === 'partial' ? 5 : 0))
                        .toFixed(0)
                      }
                    </Text>
                  </View>
                </View>

                <TouchableOpacity style={[styles.largeButton, { marginTop: 24 }]} onPress={handleConfirmSaveStop}>
                  <Text style={styles.largeButtonText}>✓ {t('confirm_save')}</Text>
                </TouchableOpacity>
              </View>
            )}
          </View>
        </ScrollView>
      ) : (
        <View style={{ flex: 1 }}>
          <ScrollView contentContainerStyle={styles.scrollContainer}>
            
            {/* ROUTE TAB */}
            {currentTab === 'route' && (
              <View style={{ flex: 1 }}>
                
                {/* Shift active / inactive toggle */}
                <View style={{ 
                  flexDirection: 'row', 
                  justifyContent: 'space-between', 
                  alignItems: 'center', 
                  backgroundColor: COLORS.card, 
                  padding: 16, 
                  borderRadius: 14, 
                  marginBottom: 16,
                  borderWidth: 1,
                  borderColor: COLORS.border
                }}>
                  <View>
                    <Text style={{ color: COLORS.text, fontWeight: '800', fontSize: 15 }}>
                      {dutyActive ? t('duty_toggle_on') : t('duty_toggle_off')}
                    </Text>
                    <Text style={{ color: COLORS.textSecondary, fontSize: 12 }}>
                      {dutyActive ? "Receiving route payloads" : "Out of service"}
                    </Text>
                  </View>
                  <TouchableOpacity 
                    style={{ 
                      backgroundColor: dutyActive ? COLORS.primary : COLORS.danger, 
                      paddingHorizontal: 16, 
                      paddingVertical: 8, 
                      borderRadius: 8 
                    }}
                    onPress={() => setDutyActive(!dutyActive)}
                  >
                    <Text style={{ color: COLORS.bg, fontWeight: '800', fontSize: 13 }}>
                      {dutyActive ? 'GO OFFLINE' : 'START SHIFT'}
                    </Text>
                  </TouchableOpacity>
                </View>

                {!dutyActive ? (
                  <View style={{ padding: 40, alignItems: 'center' }}>
                    <Text style={{ color: COLORS.textSecondary, fontSize: 16, textAlign: 'center', marginBottom: 20 }}>
                      🔴 Your shift is currently Inactive. Please click "START SHIFT" above to fetch today's routes.
                    </Text>
                  </View>
                ) : (
                  <View style={{ flex: 1 }}>
                    {/* Active vs Available Subtabs */}
                    <View style={{ flexDirection: 'row', gap: 10, marginBottom: 16 }}>
                      <TouchableOpacity 
                        style={[
                          { flex: 1, paddingVertical: 12, borderRadius: 10, alignItems: 'center', borderWidth: 1, borderColor: COLORS.border }, 
                          jobFeedTab === 'active' ? { backgroundColor: COLORS.primary } : { backgroundColor: COLORS.card }
                        ]}
                        onPress={() => setJobFeedTab('active')}
                      >
                        <Text style={{ color: jobFeedTab === 'active' ? COLORS.bg : COLORS.text, fontWeight: '800', fontSize: 14 }}>
                          {t('active_jobs')} ({stops.length})
                        </Text>
                      </TouchableOpacity>
                      <TouchableOpacity 
                        style={[
                          { flex: 1, paddingVertical: 12, borderRadius: 10, alignItems: 'center', borderWidth: 1, borderColor: COLORS.border }, 
                          jobFeedTab === 'available' ? { backgroundColor: COLORS.primary } : { backgroundColor: COLORS.card }
                        ]}
                        onPress={() => setJobFeedTab('available')}
                      >
                        <Text style={{ color: jobFeedTab === 'available' ? COLORS.bg : COLORS.text, fontWeight: '800', fontSize: 14 }}>
                          {t('available_jobs')} ({availableJobs.length})
                        </Text>
                      </TouchableOpacity>
                    </View>

                    {jobFeedTab === 'active' ? (
                      <View>
                        <View style={styles.routeHeader}>
                          <Text style={styles.sectionTitle}>{t('today_route')}</Text>
                          <Text style={styles.routeStats}>
                            {completedCount} {t('stops_completed').toLowerCase().split(' ')[0]} / {stops.length}
                          </Text>
                        </View>

                        {stops.map(stop => (
                          <TouchableOpacity 
                            key={stop.id} 
                            style={[
                              styles.stopRow,
                              stop.status === 'done' && styles.stopRowDone,
                              stop.status === 'missed' && styles.stopRowMissed,
                            ]}
                            onPress={() => {
                              if (stop.status === 'pending') {
                                setActiveStop(stop);
                              } else {
                                Alert.alert("Already Processed", "This stop has already been recorded.");
                              }
                            }}
                          >
                            <View style={styles.stopSequence}>
                              <Text style={styles.stopSequenceText}>{stop.sequence_order}</Text>
                            </View>
                            <View style={styles.stopInfo}>
                              <View style={{ flexDirection: 'row', alignItems: 'center', gap: 6, marginBottom: 2 }}>
                                <Text style={styles.stopAddress}>{stop.household_address}</Text>
                              </View>
                              <Text style={{ color: COLORS.primary, fontSize: 11, fontWeight: '800', textTransform: 'uppercase' }}>
                                🏷️ {t(`checklist_${stop.type}` as any).replace('Household ', '').replace('Commercial ', '')}
                              </Text>
                              <Text style={styles.stopPhone}>📞 {stop.household_phone}</Text>
                            </View>
                            <View style={[
                              styles.stopStatusBadge,
                              stop.status === 'done' && { backgroundColor: COLORS.primary },
                              stop.status === 'missed' && { backgroundColor: COLORS.danger },
                            ]}>
                              <Text style={styles.stopStatusText}>
                                {stop.status === 'pending' ? '➔' : stop.status === 'done' ? '✓' : '✗'}
                              </Text>
                            </View>
                          </TouchableOpacity>
                        ))}
                      </View>
                    ) : (
                      // AVAILABLE JOBS FEED LIST
                      <View>
                        <Text style={[styles.sectionTitle, { marginBottom: 12 }]}>{t('available_jobs')}</Text>
                        {availableJobs.length === 0 ? (
                          <Text style={{ color: COLORS.textSecondary, textAlign: 'center', padding: 20 }}>No new jobs available in Ward 12.</Text>
                        ) : (
                          availableJobs.map(job => (
                            <View key={job.id} style={[styles.stopRow, { flexDirection: 'column', alignItems: 'flex-start', gap: 10 }]}>
                              <View style={{ width: '100%', flexDirection: 'row', justifyContent: 'space-between' }}>
                                <View style={{ flex: 1 }}>
                                  <Text style={[styles.stopAddress, { fontSize: 16 }]}>{job.household_address}</Text>
                                  <Text style={{ color: COLORS.warning, fontSize: 12, fontWeight: '800', textTransform: 'uppercase', marginTop: 2 }}>
                                    🔧 {t(`checklist_${job.type}` as any)}
                                  </Text>
                                </View>
                                <Text style={{ color: COLORS.primary, fontWeight: '900', fontSize: 16 }}>₹{job.type === 'sewer' ? 120 : 40}</Text>
                              </View>
                              
                              <TouchableOpacity 
                                style={[styles.button, { width: '100%', height: 44, borderRadius: 8 }]}
                                onPress={() => {
                                  setStops([...stops, { ...job, sequence_order: stops.length + 1 }]);
                                  setAvailableJobs(availableJobs.filter(aj => aj.id !== job.id));
                                  Alert.alert("Success", "Job accepted and added to your route");
                                }}
                              >
                                <Text style={styles.buttonText}>{t('accept_job')}</Text>
                              </TouchableOpacity>
                            </View>
                          ))
                        )}
                      </View>
                    )}
                  </View>
                )}
              </View>
            )}

            {/* DAY SUMMARY TAB */}
            {currentTab === 'summary' && (
              <View style={styles.tabContent}>
                <Text style={styles.sectionTitle}>{t('day_summary')}</Text>
                
                <View style={styles.summaryCard}>
                  <Text style={styles.summaryLabel}>Total Stops Done</Text>
                  <Text style={styles.summaryVal}>{completedCount}</Text>

                  <Text style={styles.summaryLabel}>Missed Stops</Text>
                  <Text style={[styles.summaryVal, { color: COLORS.danger }]}>{missedCount}</Text>
                </View>

                <View style={styles.card}>
                  <Text style={styles.cardTitle}>{t('stream_est')}</Text>
                  
                  <View style={styles.summaryRow}>
                    <Text style={styles.summaryRowLabel}>{t('total_wet')}</Text>
                    <Text style={styles.summaryRowVal}>{completedCount * 1.3} kg</Text>
                  </View>

                  <View style={styles.summaryRow}>
                    <Text style={styles.summaryRowLabel}>{t('total_dry')}</Text>
                    <Text style={styles.summaryRowVal}>{completedCount * 0.8} kg</Text>
                  </View>

                  <View style={styles.summaryRow}>
                    <Text style={styles.summaryRowLabel}>{t('total_reject')}</Text>
                    <Text style={styles.summaryRowVal}>{completedCount * 0.15} kg</Text>
                  </View>
                </View>
              </View>
            )}

            {/* SAFETY & SOS TAB */}
            {currentTab === 'safety' && (
              <View style={styles.tabContent}>
                <Text style={styles.sectionTitle}>{t('safety_center')}</Text>

                {/* Big SOS Distress Trigger */}
                <TouchableOpacity 
                  style={[
                    styles.largeButton, 
                    { 
                      height: 120, 
                      backgroundColor: sosActive ? COLORS.bg : COLORS.danger, 
                      borderColor: COLORS.danger, 
                      borderWidth: 2, 
                      marginTop: 15,
                      marginBottom: 20
                    }
                  ]}
                  onPress={() => {
                    setSosActive(!sosActive);
                    Alert.alert(
                      sosActive ? "SOS Cancelled" : "🚨 SOS DISTRESS ALREADY SENT", 
                      sosActive ? "Ops notified that you are safe." : "Mock alert sent to Command Center. Call dispatch: +91 112"
                    );
                  }}
                >
                  <Text style={[styles.largeButtonText, { color: sosActive ? COLORS.danger : COLORS.bg, fontSize: 20, textAlign: 'center' }]}>
                    {sosActive ? "🚨 SOS ACTIVE (Tap to Cancel)" : t('trigger_sos')}
                  </Text>
                </TouchableOpacity>

                {/* Report Hazard button */}
                <View style={styles.card}>
                  <Text style={styles.cardTitle}>{t('report_hazard')}</Text>
                  
                  {showHazardModal ? (
                    <View style={{ gap: 10, marginTop: 10 }}>
                      <Text style={styles.label}>Hazard Type</Text>
                      <TextInput 
                        style={styles.weightInput}
                        value={newHazardType}
                        onChangeText={setNewHazardType}
                        placeholder="e.g. Unsafe Waste / Accident"
                        placeholderTextColor={COLORS.textSecondary}
                      />
                      
                      <Text style={styles.label}>Description</Text>
                      <TextInput 
                        style={[styles.weightInput, { height: 80 }]}
                        value={newHazardDesc}
                        onChangeText={setNewHazardDesc}
                        placeholder="Explain the hazard danger..."
                        placeholderTextColor={COLORS.textSecondary}
                        multiline
                      />

                      <View style={{ flexDirection: 'row', gap: 10, marginTop: 5 }}>
                        <TouchableOpacity 
                          style={[styles.button, { flex: 1, backgroundColor: COLORS.primary }]}
                          onPress={() => {
                            if (!newHazardDesc) return;
                            const newHr = {
                              id: 'hr_' + Date.now(),
                              type: newHazardType,
                              desc: newHazardDesc,
                              time: 'Just now'
                            };
                            setHazardReports([newHr, ...hazardReports]);
                            setNewHazardDesc('');
                            setShowHazardModal(false);
                            Alert.alert("Success", t('hazard_reported'));
                          }}
                        >
                          <Text style={styles.buttonText}>Submit</Text>
                        </TouchableOpacity>
                        <TouchableOpacity 
                          style={[styles.button, { flex: 1, backgroundColor: COLORS.lightCard }]}
                          onPress={() => setShowHazardModal(false)}
                        >
                          <Text style={[styles.buttonText, { color: COLORS.text }]}>Cancel</Text>
                        </TouchableOpacity>
                      </View>
                    </View>
                  ) : (
                    <TouchableOpacity 
                      style={[styles.button, { backgroundColor: COLORS.info, marginTop: 10 }]}
                      onPress={() => setShowHazardModal(true)}
                    >
                      <Text style={styles.buttonText}>+ Report New Hazard</Text>
                    </TouchableOpacity>
                  )}
                </View>

                {/* List active hazards */}
                <View style={styles.card}>
                  <Text style={styles.cardTitle}>Active Ward Hazards</Text>
                  {hazardReports.map(hr => (
                    <View key={hr.id} style={[styles.historyItem, { flexDirection: 'column', alignItems: 'flex-start', paddingVertical: 12 }]}>
                      <View style={{ flexDirection: 'row', justifyContent: 'space-between', width: '100%' }}>
                        <Text style={{ color: COLORS.danger, fontWeight: '800', fontSize: 13 }}>⚠️ {hr.type}</Text>
                        <Text style={{ color: COLORS.textSecondary, fontSize: 11 }}>{hr.time}</Text>
                      </View>
                      <Text style={{ color: COLORS.text, fontSize: 13, marginTop: 4 }}>{hr.desc}</Text>
                    </View>
                  ))}
                </View>
              </View>
            )}

            {/* EARNINGS TAB */}
            {currentTab === 'earnings' && (
              <View style={styles.tabContent}>
                <Text style={styles.sectionTitle}>{t('earnings_title')}</Text>

                <View style={styles.earningsCard}>
                  <Text style={styles.earningsLabel}>{t('today_earnings')}</Text>
                  <Text style={styles.earningsValue}>₹ {completedCount * 50}</Text>
                  <Text style={styles.earningsSub}>₹ 50 per verified stop collection</Text>
                </View>

                <View style={styles.card}>
                  <Text style={styles.cardTitle}>Earnings History</Text>
                  
                  <View style={styles.historyItem}>
                    <Text style={styles.historyDate}>11 July 2026</Text>
                    <Text style={styles.historyAmt}>₹ 250 (5 stops)</Text>
                  </View>

                  <View style={styles.historyItem}>
                    <Text style={styles.historyDate}>10 July 2026</Text>
                    <Text style={styles.historyAmt}>₹ 200 (4 stops)</Text>
                  </View>

                  <View style={styles.historyItem}>
                    <Text style={styles.historyDate}>09 July 2026</Text>
                    <Text style={styles.historyAmt}>₹ 250 (5 stops)</Text>
                  </View>
                </View>
              </View>
            )}

          </ScrollView>

          {/* Bottom Tabs Bar */}
          <View style={styles.tabsBar}>
            <TouchableOpacity style={[styles.tabItem, currentTab === 'route' && styles.tabItemActive]} onPress={() => setCurrentTab('route')}>
              <Text style={[styles.tabItemText, currentTab === 'route' && styles.tabItemTextActive]}>{t('tab_job_feed')}</Text>
            </TouchableOpacity>
            <TouchableOpacity style={[styles.tabItem, currentTab === 'summary' && styles.tabItemActive]} onPress={() => setCurrentTab('summary')}>
              <Text style={[styles.tabItemText, currentTab === 'summary' && styles.tabItemTextActive]}>{t('day_summary')}</Text>
            </TouchableOpacity>
            <TouchableOpacity style={[styles.tabItem, currentTab === 'safety' && styles.tabItemActive]} onPress={() => setCurrentTab('safety')}>
              <Text style={[styles.tabItemText, currentTab === 'safety' && styles.tabItemTextActive]}>{t('tab_safety')}</Text>
            </TouchableOpacity>
            <TouchableOpacity style={[styles.tabItem, currentTab === 'earnings' && styles.tabItemActive]} onPress={() => setCurrentTab('earnings')}>
              <Text style={[styles.tabItemText, currentTab === 'earnings' && styles.tabItemTextActive]}>{t('tab_profile').replace('Profile', 'Earnings').replace('प्रोफ़ाइल', 'कमाई')}</Text>
            </TouchableOpacity>
          </View>
        </View>
      )}

    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: COLORS.bg,
  },
  loginContainer: {
    flex: 1,
    justifyContent: 'center',
    padding: 32,
  },
  appTitle: {
    fontSize: 32,
    fontWeight: '900',
    color: COLORS.primary,
    textAlign: 'center',
    letterSpacing: 3,
    marginBottom: 8,
  },
  loginTitle: {
    fontSize: 20,
    fontWeight: '700',
    color: COLORS.text,
    textAlign: 'center',
    marginBottom: 40,
    textTransform: 'uppercase',
    letterSpacing: 1,
  },
  formGroup: {
    marginBottom: 20,
  },
  label: {
    fontSize: 14,
    fontWeight: '700',
    color: COLORS.textSecondary,
    marginBottom: 8,
    textTransform: 'uppercase',
    letterSpacing: 0.5,
  },
  input: {
    backgroundColor: COLORS.card,
    height: 56,
    borderRadius: 12,
    borderWidth: 1,
    borderColor: COLORS.border,
    paddingHorizontal: 16,
    color: COLORS.text,
    fontSize: 16,
  },
  button: {
    backgroundColor: COLORS.primary,
    height: 56,
    borderRadius: 12,
    alignItems: 'center',
    justifyContent: 'center',
  },
  buttonText: {
    color: COLORS.bg,
    fontSize: 16,
    fontWeight: '700',
    textTransform: 'uppercase',
  },
  langBtn: {
    alignItems: 'center',
    marginTop: 24,
  },
  langBtnText: {
    color: COLORS.primary,
    fontWeight: '600',
    fontSize: 14,
  },

  // MAIN LAYOUT
  header: {
    height: 68,
    backgroundColor: COLORS.card,
    borderBottomWidth: 1,
    borderBottomColor: COLORS.border,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: 20,
  },
  headerTitle: {
    fontSize: 18,
    fontWeight: '900',
    color: COLORS.primary,
    letterSpacing: 0.5,
  },
  workerName: {
    fontSize: 12,
    color: COLORS.textSecondary,
  },
  headerControls: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
  },
  offlineToggle: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: COLORS.lightCard,
    paddingHorizontal: 10,
    paddingVertical: 6,
    borderRadius: 6,
    gap: 6,
  },
  statusDot: {
    width: 8,
    height: 8,
    borderRadius: 4,
  },
  offlineToggleText: {
    color: COLORS.text,
    fontSize: 11,
    fontWeight: '600',
  },
  headerLang: {
    paddingHorizontal: 10,
    paddingVertical: 6,
    backgroundColor: COLORS.lightCard,
    borderRadius: 6,
  },
  headerLangText: {
    color: COLORS.text,
    fontWeight: '600',
    fontSize: 11,
  },
  syncBanner: {
    backgroundColor: COLORS.warning,
    paddingVertical: 10,
    paddingHorizontal: 20,
    alignItems: 'center',
  },
  syncBannerText: {
    color: COLORS.bg,
    fontWeight: '700',
    fontSize: 12,
  },
  scrollContainer: {
    padding: 20,
    paddingBottom: 100,
  },
  sectionTitle: {
    fontSize: 22,
    fontWeight: '800',
    color: COLORS.text,
  },
  routeHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 20,
  },
  routeStats: {
    fontSize: 14,
    color: COLORS.textSecondary,
    fontWeight: '600',
  },

  // ROUTE STOP ROW
  stopRow: {
    backgroundColor: COLORS.card,
    borderRadius: 16,
    padding: 16,
    marginBottom: 12,
    flexDirection: 'row',
    alignItems: 'center',
    borderWidth: 1,
    borderColor: COLORS.border,
  },
  stopRowDone: {
    opacity: 0.6,
  },
  stopRowMissed: {
    opacity: 0.6,
  },
  stopSequence: {
    width: 36,
    height: 36,
    borderRadius: 18,
    backgroundColor: COLORS.lightCard,
    alignItems: 'center',
    justifyContent: 'center',
    marginRight: 16,
  },
  stopSequenceText: {
    color: COLORS.text,
    fontWeight: '700',
    fontSize: 16,
  },
  stopInfo: {
    flex: 1,
  },
  stopAddress: {
    fontSize: 15,
    fontWeight: '600',
    color: COLORS.text,
    marginBottom: 4,
  },
  stopPhone: {
    fontSize: 13,
    color: COLORS.textSecondary,
  },
  stopStatusBadge: {
    width: 28,
    height: 28,
    borderRadius: 14,
    backgroundColor: COLORS.lightCard,
    alignItems: 'center',
    justifyContent: 'center',
  },
  stopStatusText: {
    color: COLORS.text,
    fontWeight: '700',
    fontSize: 12,
  },

  // ACTIVE STOP DETAIL
  activeStopCard: {
    backgroundColor: COLORS.card,
    borderRadius: 20,
    padding: 24,
    borderWidth: 1,
    borderColor: COLORS.border,
  },
  activeStopHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 8,
  },
  activeStopTitle: {
    fontSize: 18,
    fontWeight: '800',
    color: COLORS.primary,
  },
  closeActiveStop: {
    padding: 4,
  },
  activeStopAddress: {
    fontSize: 16,
    color: COLORS.text,
    lineHeight: 22,
    marginBottom: 8,
  },
  activeStopPhone: {
    fontSize: 14,
    color: COLORS.textSecondary,
    marginBottom: 24,
  },
  arriveContainer: {
    alignItems: 'center',
  },
  largeButton: {
    width: '100%',
    height: 60,
    backgroundColor: COLORS.primary,
    borderRadius: 14,
    alignItems: 'center',
    justifyContent: 'center',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.3,
    shadowRadius: 8,
    elevation: 5,
  },
  largeButtonText: {
    color: COLORS.bg,
    fontSize: 18,
    fontWeight: '800',
    textTransform: 'uppercase',
  },
  missedGrid: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    width: '100%',
    marginTop: 8,
    gap: 8,
  },
  missedBtn: {
    flex: 1,
    height: 50,
    backgroundColor: COLORS.lightCard,
    borderRadius: 8,
    alignItems: 'center',
    justifyContent: 'center',
    padding: 8,
  },
  missedBtnText: {
    color: COLORS.danger,
    fontSize: 12,
    fontWeight: '700',
    textAlign: 'center',
  },

  // VERIFICATION FORM
  verifyForm: {
    width: '100%',
  },
  streamTabs: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 16,
    gap: 4,
  },
  streamTab: {
    flex: 1,
    height: 48,
    backgroundColor: COLORS.lightCard,
    borderRadius: 8,
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 2,
    borderColor: 'transparent',
  },
  streamTabActive: {
    backgroundColor: 'rgba(255, 255, 255, 0.02)',
  },
  streamTabText: {
    color: COLORS.textSecondary,
    fontSize: 13,
    fontWeight: '700',
  },
  streamFormBlock: {
    backgroundColor: 'rgba(0,0,0,0.15)',
    borderRadius: 12,
    padding: 16,
  },
  photoButton: {
    height: 50,
    backgroundColor: COLORS.lightCard,
    borderRadius: 8,
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 1,
    borderColor: COLORS.border,
  },
  photoButtonActive: {
    backgroundColor: COLORS.darkGreen,
    borderColor: COLORS.primary,
  },
  photoButtonText: {
    color: COLORS.text,
    fontWeight: '700',
  },
  weightInput: {
    backgroundColor: COLORS.card,
    height: 50,
    borderRadius: 8,
    borderWidth: 1,
    borderColor: COLORS.border,
    paddingHorizontal: 16,
    color: COLORS.text,
    fontSize: 18,
    fontWeight: '700',
  },
  qualityContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    gap: 6,
  },
  qualityOption: {
    flex: 1,
    height: 45,
    backgroundColor: COLORS.lightCard,
    borderRadius: 8,
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 1,
    borderColor: COLORS.border,
  },
  qualityOptionText: {
    color: COLORS.text,
    fontSize: 11,
    fontWeight: '700',
    textAlign: 'center',
  },

  // SUMMARY & EARNINGS TAB STYLES
  tabContent: {
    flex: 1,
  },
  card: {
    backgroundColor: COLORS.card,
    borderRadius: 16,
    padding: 20,
    marginBottom: 16,
    borderWidth: 1,
    borderColor: COLORS.border,
  },
  cardTitle: {
    fontSize: 12,
    fontWeight: '700',
    color: COLORS.textSecondary,
    textTransform: 'uppercase',
    letterSpacing: 0.5,
    marginBottom: 16,
  },
  summaryCard: {
    backgroundColor: COLORS.card,
    borderRadius: 20,
    padding: 24,
    marginBottom: 20,
    alignItems: 'center',
    borderWidth: 1,
    borderColor: COLORS.border,
  },
  summaryLabel: {
    color: COLORS.textSecondary,
    fontSize: 14,
    marginBottom: 4,
  },
  summaryVal: {
    fontSize: 32,
    fontWeight: '900',
    color: COLORS.primary,
    marginBottom: 16,
  },
  summaryRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    paddingVertical: 10,
    borderBottomWidth: 1,
    borderBottomColor: COLORS.border,
  },
  summaryRowLabel: {
    color: COLORS.text,
    fontSize: 14,
  },
  summaryRowVal: {
    color: COLORS.primary,
    fontWeight: '700',
    fontSize: 14,
  },

  // EARNINGS TAB STYLES
  earningsCard: {
    backgroundColor: COLORS.darkGreen,
    borderRadius: 20,
    padding: 24,
    marginBottom: 20,
    alignItems: 'center',
    borderWidth: 1,
    borderColor: COLORS.primary,
  },
  earningsLabel: {
    color: COLORS.primary,
    fontSize: 14,
    fontWeight: '700',
    textTransform: 'uppercase',
  },
  earningsValue: {
    fontSize: 36,
    fontWeight: '900',
    color: '#ffffff',
    marginVertical: 8,
  },
  earningsSub: {
    color: 'rgba(255,255,255,0.7)',
    fontSize: 12,
  },
  historyItem: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    paddingVertical: 12,
    borderBottomWidth: 1,
    borderBottomColor: COLORS.border,
  },
  historyDate: {
    color: COLORS.text,
    fontSize: 14,
  },
  historyAmt: {
    color: COLORS.primary,
    fontWeight: '700',
    fontSize: 14,
  },

  // BOTTOM TABS BAR
  tabsBar: {
    position: 'absolute',
    bottom: 0,
    left: 0,
    right: 0,
    height: 70,
    backgroundColor: COLORS.card,
    borderTopWidth: 1,
    borderTopColor: COLORS.border,
    flexDirection: 'row',
    justifyContent: 'space-around',
    alignItems: 'center',
  },
  tabItem: {
    alignItems: 'center',
    justifyContent: 'center',
    height: '100%',
    paddingHorizontal: 15,
  },
  tabItemActive: {
    borderBottomWidth: 2,
    borderBottomColor: COLORS.primary,
  },
  tabItemText: {
    fontSize: 12,
    color: COLORS.textSecondary,
    fontWeight: '600',
  },
  tabItemTextActive: {
    color: COLORS.primary,
  }
});
