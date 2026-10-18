import React, { useState } from 'react';
import './App.css';

// SVG Icons (Inline for clean, zero-dependency rendering)
const DashboardIcon = () => (
  <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
    <rect x="3" y="3" width="7" height="9" />
    <rect x="14" y="3" width="7" height="5" />
    <rect x="14" y="12" width="7" height="9" />
    <rect x="3" y="16" width="7" height="5" />
  </svg>
);

const HouseholdsIcon = () => (
  <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
    <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z" />
    <polyline points="9 22 9 12 15 12 15 22" />
  </svg>
);

const WorkersIcon = () => (
  <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
    <circle cx="9" cy="7" r="4" />
    <path d="M23 21v-2a4 4 0 0 0-3-3.87" />
    <path d="M16 3.13a4 4 0 0 1 0 7.75" />
  </svg>
);

const HubIcon = () => (
  <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
    <path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z" />
    <polyline points="3.27 6.96 12 12.01 20.73 6.96" />
    <line x1="12" y1="22.08" x2="12" y2="12" />
  </svg>
);

const IssuesIcon = () => (
  <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
    <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z" />
    <line x1="12" y1="9" x2="12" y2="13" />
    <line x1="12" y1="17" x2="12.01" y2="17" />
  </svg>
);

const MapPinIcon = () => (
  <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
    <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z" />
    <circle cx="12" cy="10" r="3" />
  </svg>
);

const RecycleIcon = () => (
  <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
    <polyline points="7 19 3 15 7 11" />
    <path d="M3 15h11a6 6 0 0 0 0-12H9" />
    <polyline points="17 5 21 9 17 13" />
    <path d="M21 9H10a6 6 0 0 0 0 12h5" />
  </svg>
);

// MOCK DATA FOR THE MVP (in case backend is not running or during local preview)
const MOCK_HOUSEHOLDS = [
  { id: 'h1', phone: '9876543210', address_line: 'G-12, Sector 4, Shalimar Garden', ward_name: 'Ward 12 (Shalimar Garden)', subscription_status: 'active', payment_status_this_month: 'paid', total_stops_done: 28 },
  { id: 'h2', phone: '9988776655', address_line: 'House 43, Ward 15, Kavi Nagar', ward_name: 'Ward 15 (Kavi Nagar)', subscription_status: 'active', payment_status_this_month: 'pending', total_stops_done: 24 },
  { id: 'h3', phone: '9123456789', address_line: 'Pocket B, Flat 202, Raj Nagar', ward_name: 'Ward 15 (Kavi Nagar)', subscription_status: 'active', payment_status_this_month: 'overdue', total_stops_done: 18 },
  { id: 'h4', phone: '9811223344', address_line: 'Shop 5, Main Market, Sector 4', ward_name: 'Ward 12 (Shalimar Garden)', subscription_status: 'active', payment_status_this_month: 'paid', total_stops_done: 30 },
  { id: 'h5', phone: '9555666777', address_line: 'Block C-3, Sanjay Nagar', ward_name: 'Ward 18 (Sanjay Nagar)', subscription_status: 'pending', payment_status_this_month: 'no_record', total_stops_done: 0 },
];

const MOCK_WORKERS = [
  { id: 'w1', name: 'Ramesh Kumar', phone: '8800112233', ward_name: 'Ward 12 (Shalimar Garden)', stops_completed: 184, stops_missed: 6, completion_rate: 96.8, total_earnings: 9200 },
  { id: 'w2', name: 'Sunil Prasad', phone: '8877665544', ward_name: 'Ward 15 (Kavi Nagar)', stops_completed: 165, stops_missed: 12, completion_rate: 93.2, total_earnings: 8250 },
  { id: 'w3', name: 'Amit Singh', phone: '9900887766', ward_name: 'Ward 18 (Sanjay Nagar)', stops_completed: 198, stops_missed: 2, completion_rate: 99.0, total_earnings: 9900 },
];

const MOCK_ISSUES = [
  { id: 'i1', source: 'household', type: 'missed_pickup', description: 'Worker did not arrive today. Separated wet waste is smelling.', status: 'open', raised_at: '2026-07-12T08:30:00Z', raised_by: '9876543210' },
  { id: 'i2', source: 'worker', type: 'unsafe_condition', description: 'Broken glass in bin at Sector 4 Commercial stop. Need thick gloves.', status: 'open', raised_at: '2026-07-11T16:00:00Z', raised_by: 'Ramesh Kumar (8800112233)' },
  { id: 'i3', source: 'household', type: 'billing_question', description: 'Paid cash to worker but payment still showing pending in Requestor App.', status: 'resolved', raised_at: '2026-07-10T11:20:00Z', raised_by: '9988776655' },
];

const MOCK_INTAKES = [
  { id: 'in1', date: '2026-07-11T18:00:00Z', stream: 'wet', weight_kg: 345, ward_name: 'Ward 12 (Shalimar Garden)' },
  { id: 'in2', date: '2026-07-11T18:15:00Z', stream: 'dry', weight_kg: 180, ward_name: 'Ward 12 (Shalimar Garden)' },
  { id: 'in3', date: '2026-07-11T18:30:00Z', stream: 'reject', weight_kg: 45, ward_name: 'Ward 12 (Shalimar Garden)' },
  { id: 'in4', date: '2026-07-11T19:00:00Z', stream: 'wet', weight_kg: 290, ward_name: 'Ward 15 (Kavi Nagar)' },
];

const MOCK_TICKETS = [
  {
    id: 't1',
    ticket_number: 'SW-1042',
    type: 'hotspot_dump',
    description: 'Large illegal dump behind Sector 4 community center. Mixed plastic and organic waste overflowing onto sidewalk.',
    status: 'open',
    latitude: 28.6905,
    longitude: 77.3425,
    landmark: 'Behind Community Hall, Sector 4',
    photo_url: 'https://images.unsplash.com/photo-1530587191325-3db32d826c18?w=500',
    ward_id: 12,
    ward_name: 'Ward 12 (Shalimar Garden)',
    remaining_seconds: 64800, // 18 hrs
    sla_hours: 24,
    waste_category: 'MIXED_PLASTIC',
    estimated_volume_m3: 2.5,
    assigned_worker_name: null,
  },
  {
    id: 't2',
    ticket_number: 'SW-1043',
    type: 'hotspot_dump',
    description: 'Construction debris and sacks dumped near Kavi Nagar Park entrance.',
    status: 'in_progress',
    latitude: 28.6720,
    longitude: 77.4420,
    landmark: 'Kavi Nagar D-Block Park Gate 2',
    photo_url: 'https://images.unsplash.com/photo-1605600659908-0ef719419d41?w=500',
    ward_id: 15,
    ward_name: 'Ward 15 (Kavi Nagar)',
    remaining_seconds: 21600, // 6 hrs
    sla_hours: 24,
    waste_category: 'CONSTRUCTION_MIXED',
    estimated_volume_m3: 4.0,
    assigned_worker_name: 'Ramesh Kumar',
  },
  {
    id: 't3',
    ticket_number: 'SW-1039',
    type: 'hotspot_dump',
    description: 'Dump cleared at Sanjay Nagar Block C.',
    status: 'resolved',
    latitude: 28.6888,
    longitude: 77.3450,
    landmark: 'Lane 3 Corner, Sanjay Nagar',
    photo_url: 'https://images.unsplash.com/photo-1530587191325-3db32d826c18?w=500',
    resolved_photo_url: 'https://images.unsplash.com/photo-1517646287270-a5a9ca602e5c?w=500',
    ward_id: 18,
    ward_name: 'Ward 18 (Sanjay Nagar)',
    remaining_seconds: 0,
    sla_hours: 24,
    waste_category: 'DRY_SCRAP',
    estimated_volume_m3: 1.5,
    assigned_worker_name: 'Sunil Prasad',
  }
];

const MOCK_RECYCLABLES = [
  { id: 'r1', date: '2026-07-12', material: 'PET Plastic', weight_kg: 120, procured_rate: 14, resale_rate: 22, gross_revenue: 2640, net_margin: 960, buyer_name: 'Gupta Scrap Aggregators (Sahibabad)' },
  { id: 'r2', date: '2026-07-12', material: 'Cardboard Bundles', weight_kg: 350, procured_rate: 6, resale_rate: 11.5, gross_revenue: 4025, net_margin: 1925, buyer_name: 'Ghaziabad Paper Mills Recyclers' },
  { id: 'r3', date: '2026-07-11', material: 'HDPE Containers', weight_kg: 75, procured_rate: 15, resale_rate: 26, gross_revenue: 1950, net_margin: 825, buyer_name: 'Rathi Plastics Aggregators' },
  { id: 'r4', date: '2026-07-10', material: 'Scrap Metal', weight_kg: 90, procured_rate: 28, resale_rate: 38, gross_revenue: 3420, net_margin: 900, buyer_name: 'Local Kabadiwala Hub' }
];

export default function App() {
  const [isAuthenticated, setIsAuthenticated] = useState<boolean>(true); // default true for demo preview
  const [authEmail, setAuthEmail] = useState('');
  const [authPassword, setAuthPassword] = useState('');
  const [activeTab, setActiveTab] = useState<'metrics' | 'live-map' | 'recyclables' | 'households' | 'workers' | 'intake' | 'issues'>('metrics');
  
  // Dashboard Metrics State
  const [metrics] = useState({
    households_onboarded: 840,
    households_active: 792,
    segregation_compliance_rate: 88.4,
    fee_collection_rate: 92.1,
    cost_per_household: 42.50,
    revenue_per_tonne_wet: 1200,
    revenue_per_tonne_dry: 4500,
    revenue_per_tonne_reject: -800,
    total_waste_collected_kg: 12450,
  });

  // Directories state
  const [households] = useState(MOCK_HOUSEHOLDS);
  const [workers] = useState(MOCK_WORKERS);
  const [issues, setIssues] = useState(MOCK_ISSUES);
  const [intakes, setIntakes] = useState(MOCK_INTAKES);
  const [tickets, setTickets] = useState(MOCK_TICKETS);
  const [recyclables, setRecyclables] = useState(MOCK_RECYCLABLES);
  
  // Ticket Assignment Modal State
  const [selectedTicketForAssign, setSelectedTicketForAssign] = useState<any>(null);
  const [assignedWorkerId, setAssignedWorkerId] = useState('w1');
  const [triageCategory, setTriageCategory] = useState('MIXED_PLASTIC');

  // Scrap Sale Modal State
  const [showSaleModal, setShowSaleModal] = useState(false);
  const [newSale, setNewSale] = useState({
    material: 'PET Plastic',
    weight_kg: '',
    procured_rate: '',
    resale_rate: '',
    buyer_name: '',
    buyer_contact: ''
  });
  
  // Search & Filters
  const [hhSearch, setHhSearch] = useState('');
  const [hhFilter, setHhFilter] = useState<'all' | 'active' | 'pending'>('all');

  // Intake Logger Modal State
  const [showIntakeModal, setShowIntakeModal] = useState(false);
  const [newIntake, setNewIntake] = useState({
    ward_id: '12',
    stream: 'wet',
    weight_kg: '',
    notes: ''
  });

  // Triage Modal State
  const [selectedIssue, setSelectedIssue] = useState<any>(null);
  const [issueStatus, setIssueStatus] = useState<string>('open');
  const [resolutionNotes, setResolutionNotes] = useState('');

  // Handle Login simulation
  const handleLogin = (e: React.FormEvent) => {
    e.preventDefault();
    if (authEmail && authPassword) {
      setIsAuthenticated(true);
    }
  };

  // Add intake simulation
  const handleAddIntake = (e: React.FormEvent) => {
    e.preventDefault();
    const wardMap: Record<string, string> = {
      '12': 'Ward 12 (Shalimar Garden)',
      '15': 'Ward 15 (Kavi Nagar)',
      '18': 'Ward 18 (Sanjay Nagar)'
    };
    const newItem = {
      id: 'in_' + Date.now(),
      date: new Date().toISOString(),
      stream: newIntake.stream as any,
      weight_kg: Number(newIntake.weight_kg),
      ward_name: wardMap[newIntake.ward_id] || 'Ward 12 (Shalimar Garden)'
    };
    setIntakes([newItem, ...intakes]);
    setShowIntakeModal(false);
    setNewIntake({ ward_id: '12', stream: 'wet', weight_kg: '', notes: '' });
  };

  // Triage update simulation
  const handleUpdateIssue = (e: React.FormEvent) => {
    e.preventDefault();
    setIssues(issues.map(iss => {
      if (iss.id === selectedIssue.id) {
        return { ...iss, status: issueStatus as any, resolution_notes: resolutionNotes };
      }
      return iss;
    }));
    setSelectedIssue(null);
    setResolutionNotes('');
  };

  // Assign hotspot ticket to collector
  const handleAssignTicket = (e: React.FormEvent) => {
    e.preventDefault();
    const worker = workers.find(w => w.id === assignedWorkerId);
    setTickets(tickets.map(t => {
      if (t.id === selectedTicketForAssign.id) {
        return {
          ...t,
          status: 'in_progress',
          assigned_worker_name: worker ? worker.name : 'Ramesh Kumar',
          waste_category: triageCategory
        };
      }
      return t;
    }));
    setSelectedTicketForAssign(null);
  };

  // Add recyclables sale
  const handleAddSale = (e: React.FormEvent) => {
    e.preventDefault();
    const weight = Number(newSale.weight_kg);
    const procRate = Number(newSale.procured_rate) || 0;
    const resRate = Number(newSale.resale_rate);
    const gross = weight * resRate;
    const margin = gross - (weight * procRate);

    const newEntry = {
      id: 'r_' + Date.now(),
      date: new Date().toISOString().split('T')[0],
      material: newSale.material,
      weight_kg: weight,
      procured_rate: procRate,
      resale_rate: resRate,
      gross_revenue: gross,
      net_margin: margin,
      buyer_name: newSale.buyer_name || 'Gupta Scrap Aggregators'
    };

    setRecyclables([newEntry, ...recyclables]);
    setShowSaleModal(false);
    setNewSale({
      material: 'PET Plastic',
      weight_kg: '',
      procured_rate: '',
      resale_rate: '',
      buyer_name: '',
      buyer_contact: ''
    });
  };

  if (!isAuthenticated) {
    return (
      <div className="auth-container">
        <form className="auth-card" onSubmit={handleLogin}>
          <div className="logo-container" style={{ justifyContent: 'center' }}>
            <div className="logo-icon">S</div>
            <div className="logo-text">SWACHHTA</div>
          </div>
          <h2 style={{ textAlign: 'center', margin: '0 0 10px 0' }}>Ops Command Center</h2>
          <p style={{ textAlign: 'center', color: 'var(--text-secondary)', fontSize: '14px', marginTop: '-10px' }}>
            Ward Operations & pilot metrics dashboard.
          </p>
          <div className="form-group">
            <label className="form-label">Email</label>
            <input 
              type="email" 
              className="form-input" 
              placeholder="ops@swachta.co" 
              value={authEmail} 
              onChange={e => setAuthEmail(e.target.value)}
              required
            />
          </div>
          <div className="form-group">
            <label className="form-label">Password</label>
            <input 
              type="password" 
              className="form-input" 
              placeholder="••••••••" 
              value={authPassword} 
              onChange={e => setAuthPassword(e.target.value)}
              required
            />
          </div>
          <button type="submit" className="btn btn-primary" style={{ width: '100%' }}>
            Sign In
          </button>
        </form>
      </div>
    );
  }

  return (
    <div className="dashboard-container">
      {/* Sidebar Panel */}
      <div className="sidebar">
        <div className="logo-container">
          <div className="logo-icon">S</div>
          <div>
            <div className="logo-text">SWACHHTA</div>
            <div className="pilot-badge">GZB Pilot MVP</div>
          </div>
        </div>

        <nav className="nav-menu">
          <button className={`nav-item ${activeTab === 'metrics' ? 'active' : ''}`} onClick={() => setActiveTab('metrics')}>
            <DashboardIcon /> Pilot KPIs
          </button>
          <button className={`nav-item ${activeTab === 'live-map' ? 'active' : ''}`} onClick={() => setActiveTab('live-map')}>
            <MapPinIcon /> Live Hotspot Map & SLAs
          </button>
          <button className={`nav-item ${activeTab === 'recyclables' ? 'active' : ''}`} onClick={() => setActiveTab('recyclables')}>
            <RecycleIcon /> Recyclables (Rev #3)
          </button>
          <button className={`nav-item ${activeTab === 'households' ? 'active' : ''}`} onClick={() => setActiveTab('households')}>
            <HouseholdsIcon /> Households
          </button>
          <button className={`nav-item ${activeTab === 'workers' ? 'active' : ''}`} onClick={() => setActiveTab('workers')}>
            <WorkersIcon /> Field Workers
          </button>
          <button className={`nav-item ${activeTab === 'intake' ? 'active' : ''}`} onClick={() => setActiveTab('intake')}>
            <HubIcon /> Hub Intake
          </button>
          <button className={`nav-item ${activeTab === 'issues' ? 'active' : ''}`} onClick={() => setActiveTab('issues')}>
            <IssuesIcon /> Support Queue
          </button>
        </nav>

        <div className="user-profile-card">
          <div className="user-info">
            <span className="user-name">Shivam Yadav</span>
            <span className="user-role">Ward Ops Director</span>
          </div>
          <button className="logout-btn" onClick={() => setIsAuthenticated(false)}>
            Sign Out
          </button>
        </div>
      </div>

      {/* Main View Content */}
      <div className="main-content">
        
        {/* KPI METRICS TAB */}
        {activeTab === 'metrics' && (
          <div>
            <div className="header-row">
              <h1 className="page-title">Pilot Performance Dashboard</h1>
              <div className="header-actions">
                <button className="btn btn-secondary" onClick={() => window.print()}>Export CSV Report</button>
                <button className="btn btn-primary" onClick={() => setActiveTab('intake')}>Log Stream Intake</button>
              </div>
            </div>

            <div className="metrics-grid">
              <div className="metric-card">
                <span className="metric-title">Active / Onboarded Homes</span>
                <span className="metric-value">{metrics.households_active} <span style={{ fontSize: '16px', color: 'var(--text-secondary)' }}>/ {metrics.households_onboarded}</span></span>
                <div className="metric-trend up">
                  <span>94.2% Activation Rate</span>
                </div>
              </div>

              <div className="metric-card">
                <span className="metric-title">Segregation Compliance</span>
                <span className="metric-value">{metrics.segregation_compliance_rate}%</span>
                <div className="metric-trend up">
                  <span>+2.4% vs last week</span>
                </div>
              </div>

              <div className="metric-card">
                <span className="metric-title">Fee Collection Rate</span>
                <span className="metric-value">{metrics.fee_collection_rate}%</span>
                <div className="metric-trend up">
                  <span>98% target on track</span>
                </div>
              </div>

              <div className="metric-card">
                <span className="metric-title">Total Collected Waste</span>
                <span className="metric-value">{(metrics.total_waste_collected_kg / 1000).toFixed(1)} Tonnes</span>
                <div className="metric-trend">
                  <span style={{ color: 'var(--text-secondary)' }}>Across 3 active streams</span>
                </div>
              </div>
            </div>

            <div className="glass-panel">
              <h2 style={{ marginBottom: '24px' }}>Source-Segregation Quality Breakdown</h2>
              <div style={{ display: 'flex', gap: '32px', flexWrap: 'wrap' }}>
                <div style={{ flex: 1, minWidth: '250px' }}>
                  <h3 style={{ fontSize: '16px', color: 'var(--text-secondary)', marginBottom: '16px' }}>What is the Core Verification Mechanic?</h3>
                  <p style={{ fontSize: '14px', lineHeight: '1.6', color: 'var(--text-secondary)' }}>
                    Every morning, collection workers tag the waste stream from each household. 
                    This ensures we collect high-quality, verified segregated streams (Wet, Dry, Reject) 
                    directly from the door step. Immutability of logs builds downstream buyer trust.
                  </p>
                </div>
                <div style={{ flex: 1, minWidth: '250px', display: 'flex', flexDirection: 'column', gap: '16px' }}>
                  <div>
                    <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '13px', marginBottom: '6px' }}>
                      <span>Clean Segregation (Target Met)</span>
                      <span style={{ color: '#10b981', fontWeight: 600 }}>88.4%</span>
                    </div>
                    <div style={{ width: '100%', height: '8px', background: 'rgba(255,255,255,0.05)', borderRadius: '4px' }}>
                      <div style={{ width: '88.4%', height: '100%', background: '#10b981', borderRadius: '4px' }}></div>
                    </div>
                  </div>
                  <div>
                    <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '13px', marginBottom: '6px' }}>
                      <span>Partially Mixed (Requires Warning)</span>
                      <span style={{ color: '#f59e0b', fontWeight: 600 }}>9.1%</span>
                    </div>
                    <div style={{ width: '100%', height: '8px', background: 'rgba(255,255,255,0.05)', borderRadius: '4px' }}>
                      <div style={{ width: '9.1%', height: '100%', background: '#f59e0b', borderRadius: '4px' }}></div>
                    </div>
                  </div>
                  <div>
                    <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '13px', marginBottom: '6px' }}>
                      <span>Not Segregated (Service Refused / Warning)</span>
                      <span style={{ color: '#ef4444', fontWeight: 600 }}>2.5%</span>
                    </div>
                    <div style={{ width: '100%', height: '8px', background: 'rgba(255,255,255,0.05)', borderRadius: '4px' }}>
                      <div style={{ width: '2.5%', height: '100%', background: '#ef4444', borderRadius: '4px' }}></div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        )}

        {/* HOUSEHOLDS DIRECTORY */}
        {activeTab === 'households' && (
          <div>
            <div className="header-row">
              <h1 className="page-title">Household Directory</h1>
              <div className="header-actions">
                <button className="btn btn-secondary">Upload CSV</button>
              </div>
            </div>

            <div className="glass-panel">
              <div className="search-container">
                <input 
                  type="text" 
                  className="search-input" 
                  placeholder="Search by phone number, address..."
                  value={hhSearch}
                  onChange={e => setHhSearch(e.target.value)}
                />
                <select 
                  className="form-select"
                  style={{ width: '180px' }}
                  value={hhFilter}
                  onChange={e => setHhFilter(e.target.value as any)}
                >
                  <option value="all">All Subscriptions</option>
                  <option value="active">Active</option>
                  <option value="pending">Pending</option>
                </select>
              </div>

              <div className="table-container">
                <table className="custom-table">
                  <thead>
                    <tr>
                      <th>Household ID</th>
                      <th>Phone</th>
                      <th>Address</th>
                      <th>Ward</th>
                      <th>Subscription</th>
                      <th>This Month Payment</th>
                      <th>Stops Done</th>
                    </tr>
                  </thead>
                  <tbody>
                    {households
                      .filter(hh => {
                        const matchesSearch = hh.phone.includes(hhSearch) || hh.address_line.toLowerCase().includes(hhSearch.toLowerCase());
                        const matchesFilter = hhFilter === 'all' || hh.subscription_status === hhFilter;
                        return matchesSearch && matchesFilter;
                      })
                      .map(hh => (
                        <tr key={hh.id}>
                          <td style={{ fontFamily: 'monospace' }}>{hh.id}</td>
                          <td>+91 {hh.phone}</td>
                          <td>{hh.address_line}</td>
                          <td>{hh.ward_name}</td>
                          <td>
                            <span className={`badge ${hh.subscription_status === 'active' ? 'badge-success' : 'badge-warning'}`}>
                              {hh.subscription_status}
                            </span>
                          </td>
                          <td>
                            <span className={`badge ${
                              hh.payment_status_this_month === 'paid' ? 'badge-success' : 
                              hh.payment_status_this_month === 'pending' ? 'badge-warning' : 
                              hh.payment_status_this_month === 'overdue' ? 'badge-danger' : 'badge-info'
                            }`}>
                              {hh.payment_status_this_month}
                            </span>
                          </td>
                          <td>{hh.total_stops_done}</td>
                        </tr>
                      ))}
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        )}

        {/* WORKER DIRECTORY */}
        {activeTab === 'workers' && (
          <div>
            <div className="header-row">
              <h1 className="page-title">Field Collection Workers</h1>
            </div>

            <div className="glass-panel">
              <div className="table-container">
                <table className="custom-table">
                  <thead>
                    <tr>
                      <th>Worker Name</th>
                      <th>Phone</th>
                      <th>Assigned Ward</th>
                      <th>Completed Stops</th>
                      <th>Missed Stops</th>
                      <th>Completion Rate</th>
                      <th>Accrued Earnings (INR)</th>
                    </tr>
                  </thead>
                  <tbody>
                    {workers.map(w => (
                      <tr key={w.id}>
                        <td><strong>{w.name}</strong></td>
                        <td>+91 {w.phone}</td>
                        <td>{w.ward_name}</td>
                        <td>{w.stops_completed}</td>
                        <td>{w.stops_missed}</td>
                        <td>
                          <span className={`badge ${w.completion_rate >= 95 ? 'badge-success' : 'badge-warning'}`}>
                            {w.completion_rate}%
                          </span>
                        </td>
                        <td><strong>₹ {w.total_earnings}</strong></td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        )}

        {/* HUB INTAKE TAB */}
        {activeTab === 'intake' && (
          <div>
            <div className="header-row">
              <h1 className="page-title">Hub Intake Log</h1>
              <div className="header-actions">
                <button className="btn btn-primary" onClick={() => setShowIntakeModal(true)}>Log Intake Entry</button>
              </div>
            </div>

            <div className="glass-panel">
              <h2 style={{ marginBottom: '24px', fontSize: '18px' }}>Recent Intake Records</h2>
              <div className="table-container">
                <table className="custom-table">
                  <thead>
                    <tr>
                      <th>Timestamp</th>
                      <th>Assigned Ward</th>
                      <th>Waste Stream</th>
                      <th>Net Weight (kg)</th>
                    </tr>
                  </thead>
                  <tbody>
                    {intakes.map(int => (
                      <tr key={int.id}>
                        <td>{new Date(int.date).toLocaleString()}</td>
                        <td>{int.ward_name}</td>
                        <td>
                          <span className={`badge ${
                            int.stream === 'wet' ? 'badge-success' : 
                            int.stream === 'dry' ? 'badge-info' : 'badge-warning'
                          }`}>
                            {int.stream}
                          </span>
                        </td>
                        <td><strong>{int.weight_kg} kg</strong></td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        )}

        {/* SUPPORT QUEUE */}
        {activeTab === 'issues' && (
          <div>
            <div className="header-row">
              <h1 className="page-title">Support & Issue Queue</h1>
            </div>

            <div className="glass-panel">
              <div className="table-container">
                <table className="custom-table">
                  <thead>
                    <tr>
                      <th>Raised At</th>
                      <th>Source</th>
                      <th>Issue Type</th>
                      <th>Description</th>
                      <th>Raised By</th>
                      <th>Status</th>
                      <th>Actions</th>
                    </tr>
                  </thead>
                  <tbody>
                    {issues.map(iss => (
                      <tr key={iss.id}>
                        <td>{new Date(iss.raised_at).toLocaleString()}</td>
                        <td>
                          <span className={`badge ${iss.source === 'household' ? 'badge-info' : 'badge-warning'}`}>
                            {iss.source}
                          </span>
                        </td>
                        <td><span style={{ textTransform: 'capitalize' }}>{iss.type.replace('_', ' ')}</span></td>
                        <td>{iss.description}</td>
                        <td>{iss.raised_by}</td>
                        <td>
                          <span className={`badge ${iss.status === 'open' ? 'badge-danger' : 'badge-success'}`}>
                            {iss.status}
                          </span>
                        </td>
                        <td>
                          {iss.status === 'open' && (
                            <button className="btn btn-secondary" style={{ padding: '6px 12px', fontSize: '12px' }} onClick={() => {
                              setSelectedIssue(iss);
                              setIssueStatus(iss.status);
                            }}>
                              Resolve
                            </button>
                          )}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        )}

        {/* LIVE HOTSPOT MAP & SLA DISPATCH TAB */}
        {activeTab === 'live-map' && (
          <div>
            <div className="header-row">
              <div>
                <h1 className="page-title">Live Geotagged Hotspots & SLA Dispatch</h1>
                <p style={{ color: 'var(--text-secondary)', fontSize: '14px', marginTop: '4px' }}>
                  Municipal Grievance Redressal • Ghaziabad Nagar Nigam Pilot (24-Hour SLA Target)
                </p>
              </div>
              <div className="header-actions">
                <button className="btn btn-secondary" onClick={() => window.print()}>Export SLA Audit Log</button>
              </div>
            </div>

            {/* SLA Summary Cards */}
            <div className="metrics-grid">
              <div className="metric-card">
                <span className="metric-title">Active Hotspot Tickets</span>
                <span className="metric-value">{tickets.filter(t => t.status !== 'resolved').length}</span>
                <div className="metric-trend up"><span>Across 3 Pilot Wards</span></div>
              </div>
              <div className="metric-card">
                <span className="metric-title">24h SLA Compliance</span>
                <span className="metric-value">94.8%</span>
                <div className="metric-trend up"><span>+4.2% Municipal SLA gain</span></div>
              </div>
              <div className="metric-card">
                <span className="metric-title">Avg. Resolution Turnaround</span>
                <span className="metric-value">9.4 <span style={{ fontSize: '14px', color: 'var(--text-secondary)' }}>Hours</span></span>
                <div className="metric-trend up"><span>Target: &lt; 24h</span></div>
              </div>
              <div className="metric-card">
                <span className="metric-title">Resolved with Photo Proof</span>
                <span className="metric-value">{tickets.filter(t => t.status === 'resolved').length}</span>
                <div className="metric-trend"><span>100% Geotagged Verified</span></div>
              </div>
            </div>

            {/* Map Visualizer & Ticket Queue */}
            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '20px', marginBottom: '24px' }}>
              {/* Interactive Map Visualizer */}
              <div className="glass-panel" style={{ background: '#0b1914', border: '1px solid rgba(82, 183, 136, 0.2)' }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '16px' }}>
                  <h3 style={{ margin: 0, fontSize: '16px', display: 'flex', alignItems: 'center', gap: '8px' }}>
                    <MapPinIcon /> Ghaziabad Pilot Map Feed
                  </h3>
                  <span className="badge badge-success" style={{ animation: 'pulse 2s infinite' }}>● Live GPS Feed</span>
                </div>
                
                {/* Simulated GIS Canvas */}
                <div style={{
                  height: '320px',
                  borderRadius: '8px',
                  background: 'radial-gradient(circle at center, #1b4332 0%, #081c15 100%)',
                  position: 'relative',
                  overflow: 'hidden',
                  border: '1px solid rgba(255,255,255,0.05)',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center'
                }}>
                  {/* Grid Lines */}
                  <div style={{ position: 'absolute', inset: 0, opacity: 0.15, backgroundImage: 'linear-gradient(#52b788 1px, transparent 1px), linear-gradient(90deg, #52b788 1px, transparent 1px)', backgroundSize: '40px 40px' }} />
                  
                  {/* Ghaziabad Ward Overlay Text */}
                  <div style={{ position: 'absolute', top: '12px', left: '12px', background: 'rgba(0,0,0,0.6)', padding: '6px 12px', borderRadius: '4px', fontSize: '12px', color: '#52b788' }}>
                    📍 Ghaziabad Pilot: Shalimar Garden &bull; Kavi Nagar &bull; Sanjay Nagar
                  </div>

                  {/* Hotspot Pins */}
                  {tickets.map((t, idx) => {
                    const topPos = idx === 0 ? '40%' : idx === 1 ? '65%' : '25%';
                    const leftPos = idx === 0 ? '35%' : idx === 1 ? '70%' : '55%';
                    const pinColor = t.status === 'open' ? '#ff4d4f' : t.status === 'in_progress' ? '#faad14' : '#52b788';
                    return (
                      <div 
                        key={t.id} 
                        style={{
                          position: 'absolute',
                          top: topPos,
                          left: leftPos,
                          transform: 'translate(-50%, -50%)',
                          cursor: 'pointer',
                          textAlign: 'center'
                        }}
                        onClick={() => t.status === 'open' && setSelectedTicketForAssign(t)}
                      >
                        <div style={{
                          width: '28px',
                          height: '28px',
                          borderRadius: '50%',
                          background: pinColor,
                          display: 'flex',
                          alignItems: 'center',
                          justifyContent: 'center',
                          boxShadow: `0 0 15px ${pinColor}`,
                          color: '#fff',
                          fontSize: '12px',
                          fontWeight: 'bold',
                          margin: '0 auto'
                        }}>
                          !
                        </div>
                        <div style={{
                          marginTop: '4px',
                          background: 'rgba(0,0,0,0.8)',
                          padding: '2px 6px',
                          borderRadius: '4px',
                          fontSize: '11px',
                          whiteSpace: 'nowrap'
                        }}>
                          {t.ticket_number} &bull; {t.status === 'open' ? `${Math.round(t.remaining_seconds / 3600)}h left` : t.status}
                        </div>
                      </div>
                    );
                  })}
                </div>
                <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '12px', color: 'var(--text-secondary)', marginTop: '12px' }}>
                  <span>🔴 Open Dump (Urgent SLA)</span>
                  <span>🟡 In-Progress (Assigned)</span>
                  <span>🟢 Resolved (Photo Verified)</span>
                </div>
              </div>

              {/* Live Ticket Dispatch Queue */}
              <div className="glass-panel">
                <h3 style={{ margin: '0 0 16px 0', fontSize: '16px' }}>Incoming Hotspot Dump Reports</h3>
                <div style={{ display: 'flex', flexDirection: 'column', gap: '12px', maxHeight: '360px', overflowY: 'auto' }}>
                  {tickets.map(t => (
                    <div key={t.id} style={{
                      padding: '12px 16px',
                      borderRadius: '8px',
                      background: 'rgba(255,255,255,0.03)',
                      borderLeft: `4px solid ${t.status === 'open' ? '#ff4d4f' : t.status === 'in_progress' ? '#faad14' : '#52b788'}`,
                      display: 'flex',
                      justifyContent: 'space-between',
                      alignItems: 'center'
                    }}>
                      <div style={{ maxWidth: '65%' }}>
                        <div style={{ display: 'flex', alignItems: 'center', gap: '8px', marginBottom: '4px' }}>
                          <span style={{ fontWeight: 'bold', fontSize: '13px' }}>{t.ticket_number}</span>
                          <span className={`badge ${t.status === 'open' ? 'badge-danger' : t.status === 'in_progress' ? 'badge-warning' : 'badge-success'}`}>
                            {t.status.toUpperCase()}
                          </span>
                          <span style={{ fontSize: '11px', color: 'var(--text-secondary)' }}>{t.ward_name}</span>
                        </div>
                        <p style={{ margin: 0, fontSize: '12px', color: 'var(--text-secondary)', overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                          {t.description}
                        </p>
                        <div style={{ fontSize: '11px', color: '#52b788', marginTop: '4px' }}>
                          📍 {t.landmark}
                        </div>
                      </div>
                      <div style={{ textAlign: 'right' }}>
                        {t.status === 'open' ? (
                          <div>
                            <div style={{ fontSize: '12px', color: '#ff4d4f', fontWeight: 'bold', marginBottom: '6px' }}>
                              ⏱ {Math.round(t.remaining_seconds / 3600)}h left
                            </div>
                            <button 
                              className="btn btn-primary" 
                              style={{ padding: '4px 10px', fontSize: '11px' }}
                              onClick={() => setSelectedTicketForAssign(t)}
                            >
                              Assign Collector
                            </button>
                          </div>
                        ) : (
                          <div>
                            <div style={{ fontSize: '11px', color: 'var(--text-secondary)' }}>
                              Assigned to: <strong style={{ color: '#fff' }}>{t.assigned_worker_name || 'Ramesh Kumar'}</strong>
                            </div>
                            {t.resolved_photo_url && (
                              <span style={{ fontSize: '11px', color: '#52b788', display: 'block', marginTop: '4px' }}>
                                ✓ Photo Verified
                              </span>
                            )}
                          </div>
                        )}
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            </div>
          </div>
        )}

        {/* RECYCLABLES RESALE LEDGER (REVENUE STREAM #3) */}
        {activeTab === 'recyclables' && (
          <div>
            <div className="header-row">
              <div>
                <h1 className="page-title">Recyclables Resale Ledger</h1>
                <p style={{ color: 'var(--text-secondary)', fontSize: '14px', marginTop: '4px' }}>
                  Revenue Stream #3 • Aggregated scrap margins from sorted waste streams (B2B Resale)
                </p>
              </div>
              <div className="header-actions">
                <button className="btn btn-primary" onClick={() => setShowSaleModal(true)}>+ Record Scrap Sale</button>
              </div>
            </div>

            {/* Financial Margin Scorecards */}
            <div className="metrics-grid">
              <div className="metric-card">
                <span className="metric-title">Total Diverted Recyclables</span>
                <span className="metric-value">{recyclables.reduce((a, b) => a + b.weight_kg, 0)} <span style={{ fontSize: '16px', color: 'var(--text-secondary)' }}>kg</span></span>
                <div className="metric-trend up"><span>Diverted from Landfill</span></div>
              </div>
              <div className="metric-card">
                <span className="metric-title">Gross Resale Value</span>
                <span className="metric-value">₹{recyclables.reduce((a, b) => a + b.gross_revenue, 0).toLocaleString()}</span>
                <div className="metric-trend up"><span>Direct B2B revenue</span></div>
              </div>
              <div className="metric-card">
                <span className="metric-title">Net Resale Margin</span>
                <span className="metric-value">₹{recyclables.reduce((a, b) => a + b.net_margin, 0).toLocaleString()}</span>
                <div className="metric-trend up"><span>38.4% Average Margin</span></div>
              </div>
              <div className="metric-card">
                <span className="metric-title">Registered Aggregator Buyers</span>
                <span className="metric-value">4 <span style={{ fontSize: '16px', color: 'var(--text-secondary)' }}>Kabadiwalas</span></span>
                <div className="metric-trend"><span>Sahibabad & Kavi Nagar</span></div>
              </div>
            </div>

            {/* Market Resale Rate Reference & Transactions Table */}
            <div className="glass-panel">
              <h2 style={{ marginBottom: '16px' }}>Scrap Resale Transactions Log</h2>
              <div className="table-responsive">
                <table className="data-table">
                  <thead>
                    <tr>
                      <th>Date</th>
                      <th>Material</th>
                      <th>Weight</th>
                      <th>Procured Rate</th>
                      <th>Sold Rate</th>
                      <th>Gross Revenue</th>
                      <th>Net Margin</th>
                      <th>Buyer / Kabadiwala</th>
                    </tr>
                  </thead>
                  <tbody>
                    {recyclables.map(r => (
                      <tr key={r.id}>
                        <td>{r.date}</td>
                        <td><strong>{r.material}</strong></td>
                        <td>{r.weight_kg} kg</td>
                        <td>₹{r.procured_rate}/kg</td>
                        <td style={{ color: '#52b788' }}>₹{r.resale_rate}/kg</td>
                        <td>₹{r.gross_revenue.toLocaleString()}</td>
                        <td><span className="badge badge-success">+₹{r.net_margin.toLocaleString()}</span></td>
                        <td>{r.buyer_name}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        )}

      </div>

      {/* ASSIGN TICKET MODAL */}
      {selectedTicketForAssign && (
        <div className="modal-overlay">
          <div className="modal-content">
            <div className="modal-header">
              <h3 className="modal-title">Assign Hotspot to Field Collector</h3>
              <button className="close-btn" onClick={() => setSelectedTicketForAssign(null)}>&times;</button>
            </div>
            <form onSubmit={handleAssignTicket}>
              <div style={{ marginBottom: '16px', fontSize: '14px' }}>
                <div><strong>Ticket:</strong> {selectedTicketForAssign.ticket_number} (24h SLA)</div>
                <div style={{ color: 'var(--text-secondary)', marginTop: '4px' }}>{selectedTicketForAssign.description}</div>
                <div style={{ color: '#52b788', marginTop: '4px' }}>📍 {selectedTicketForAssign.landmark}</div>
              </div>

              <div className="form-group">
                <label className="form-label">Assign Field Collector</label>
                <select 
                  className="form-select"
                  value={assignedWorkerId}
                  onChange={e => setAssignedWorkerId(e.target.value)}
                >
                  {workers.map(w => (
                    <option key={w.id} value={w.id}>{w.name} &bull; {w.ward_name} ({w.phone})</option>
                  ))}
                </select>
              </div>

              <div className="form-group">
                <label className="form-label">Manual CV Classification Tag</label>
                <select 
                  className="form-select"
                  value={triageCategory}
                  onChange={e => setTriageCategory(e.target.value)}
                >
                  <option value="MIXED_PLASTIC">Mixed Plastic Waste</option>
                  <option value="CONSTRUCTION_MIXED">Construction & Demolition Debris</option>
                  <option value="ORGANIC_OVERFLOW">Organic Food Waste</option>
                  <option value="DRY_SCRAP">Commercial Scrap & Cardboard</option>
                </select>
              </div>

              <div className="form-actions">
                <button type="button" className="btn btn-secondary" onClick={() => setSelectedTicketForAssign(null)}>Cancel</button>
                <button type="submit" className="btn btn-primary">Dispatch to Collector</button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* RECORD SCRAP SALE MODAL */}
      {showSaleModal && (
        <div className="modal-overlay">
          <div className="modal-content">
            <div className="modal-header">
              <h3 className="modal-title">Record Recyclables Scrap Sale</h3>
              <button className="close-btn" onClick={() => setShowSaleModal(false)}>&times;</button>
            </div>
            <form onSubmit={handleAddSale}>
              <div className="form-group">
                <label className="form-label">Material Type</label>
                <select 
                  className="form-select"
                  value={newSale.material}
                  onChange={e => setNewSale({ ...newSale, material: e.target.value })}
                >
                  <option value="PET Plastic">PET Clear Plastic (₹22/kg avg)</option>
                  <option value="HDPE Containers">HDPE Hard Plastic (₹26/kg avg)</option>
                  <option value="Cardboard Bundles">Cardboard / OCC (₹11.5/kg avg)</option>
                  <option value="Scrap Metal">Mixed Scrap Metal (₹38/kg avg)</option>
                  <option value="Glass Bottles">Glass Cullet (₹4.5/kg avg)</option>
                </select>
              </div>

              <div className="form-group">
                <label className="form-label">Total Sold Weight (kg)</label>
                <input 
                  type="number" 
                  className="form-input" 
                  placeholder="e.g. 150"
                  value={newSale.weight_kg}
                  onChange={e => setNewSale({ ...newSale, weight_kg: e.target.value })}
                  required
                />
              </div>

              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '12px' }}>
                <div className="form-group">
                  <label className="form-label">Procured Rate (₹/kg)</label>
                  <input 
                    type="number" 
                    className="form-input" 
                    placeholder="e.g. 14"
                    value={newSale.procured_rate}
                    onChange={e => setNewSale({ ...newSale, procured_rate: e.target.value })}
                  />
                </div>
                <div className="form-group">
                  <label className="form-label">Resale Rate (₹/kg)</label>
                  <input 
                    type="number" 
                    className="form-input" 
                    placeholder="e.g. 22"
                    value={newSale.resale_rate}
                    onChange={e => setNewSale({ ...newSale, resale_rate: e.target.value })}
                    required
                  />
                </div>
              </div>

              <div className="form-group">
                <label className="form-label">Buyer / Kabadiwala Name</label>
                <input 
                  type="text" 
                  className="form-input" 
                  placeholder="e.g. Gupta Scrap Aggregators"
                  value={newSale.buyer_name}
                  onChange={e => setNewSale({ ...newSale, buyer_name: e.target.value })}
                  required
                />
              </div>

              <div className="form-actions">
                <button type="button" className="btn btn-secondary" onClick={() => setShowSaleModal(false)}>Cancel</button>
                <button type="submit" className="btn btn-primary">Log Transaction</button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* INTAKE MODAL */}
      {showIntakeModal && (
        <div className="modal-overlay">
          <div className="modal-content">
            <div className="modal-header">
              <h3 className="modal-title">Log Waste Stream Intake</h3>
              <button className="close-btn" onClick={() => setShowIntakeModal(false)}>&times;</button>
            </div>
            <form onSubmit={handleAddIntake}>
              <div className="form-group">
                <label className="form-label">Ward Hub</label>
                <select 
                  className="form-select"
                  value={newIntake.ward_id}
                  onChange={e => setNewIntake({ ...newIntake, ward_id: e.target.value })}
                >
                  <option value="12">Ward 12 (Shalimar Garden)</option>
                  <option value="15">Ward 15 (Kavi Nagar)</option>
                  <option value="18">Ward 18 (Sanjay Nagar)</option>
                </select>
              </div>

              <div className="form-group">
                <label className="form-label">Waste Category</label>
                <select 
                  className="form-select"
                  value={newIntake.stream}
                  onChange={e => setNewIntake({ ...newIntake, stream: e.target.value })}
                >
                  <option value="wet">Wet Organic Waste</option>
                  <option value="dry">Dry Recyclables</option>
                  <option value="reject">Reject Waste (RDF)</option>
                </select>
              </div>

              <div className="form-group">
                <label className="form-label">Net Weight (kg)</label>
                <input 
                  type="number" 
                  className="form-input"
                  placeholder="e.g. 350"
                  value={newIntake.weight_kg}
                  onChange={e => setNewIntake({ ...newIntake, weight_kg: e.target.value })}
                  required
                />
              </div>

              <div className="form-group">
                <label className="form-label">Notes (Optional)</label>
                <textarea 
                  className="form-textarea" 
                  rows={3} 
                  placeholder="Any comments about sorting quality..."
                  value={newIntake.notes}
                  onChange={e => setNewIntake({ ...newIntake, notes: e.target.value })}
                />
              </div>

              <div className="form-actions">
                <button type="button" className="btn btn-secondary" onClick={() => setShowIntakeModal(false)}>Cancel</button>
                <button type="submit" className="btn btn-primary">Save Log</button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* TRIAGE RESOLUTION MODAL */}
      {selectedIssue && (
        <div className="modal-overlay">
          <div className="modal-content">
            <div className="modal-header">
              <h3 className="modal-title">Resolve Support Request</h3>
              <button className="close-btn" onClick={() => setSelectedIssue(null)}>&times;</button>
            </div>
            <form onSubmit={handleUpdateIssue}>
              <div style={{ marginBottom: '20px', fontSize: '14px', lineHeight: '1.5' }}>
                <strong>Report:</strong> "{selectedIssue.description}"
              </div>
              
              <div className="form-group">
                <label className="form-label">Resolution Status</label>
                <select 
                  className="form-select"
                  value={issueStatus}
                  onChange={e => setIssueStatus(e.target.value)}
                >
                  <option value="open">Open</option>
                  <option value="resolved">Resolved</option>
                </select>
              </div>

              <div className="form-group">
                <label className="form-label">Action Taken / Resolution Note</label>
                <textarea 
                  className="form-textarea" 
                  rows={4}
                  placeholder="Details of how this was sorted out..."
                  value={resolutionNotes}
                  onChange={e => setResolutionNotes(e.target.value)}
                  required
                />
              </div>

              <div className="form-actions">
                <button type="button" className="btn btn-secondary" onClick={() => setSelectedIssue(null)}>Cancel</button>
                <button type="submit" className="btn btn-primary">Update Issue</button>
              </div>
            </form>
          </div>
        </div>
      )}

    </div>
  );
}
