import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/colors.dart';
import '../../shared/widgets/shared_widgets.dart';
import 'widgets/sidebar.dart';

// --- Core screens ---
import '../overview/overview_screen.dart';
import '../live_map/live_map_screen.dart';
import '../workers/workers_screen.dart';
import '../warehouses/warehouses_screen.dart';
import '../reports/reports_screen.dart';
import '../system/system_settings_screen.dart';

// --- Operations ---
import '../operations/job_board_screen.dart';
import '../operations/routes_scheduling_screen.dart';
import '../operations/collection_calendar_screen.dart';

// --- People ---
import '../people/worker_profile_screen.dart';
import '../people/attendance_screen.dart';
import '../people/payroll_screen.dart';
import '../people/shift_scheduler_screen.dart';
import '../people/training_screen.dart';
import '../people/performance_screen.dart';

// --- Logistics (Fleet) ---
import '../fleet/logistics_screens.dart';

// --- Citizens ---
import '../citizens/citizens_screens.dart';

// --- Finance ---
import '../finance/finance_screens.dart';

// --- Compliance ---
import '../compliance/compliance_screens.dart';

// --- AI Center ---
import '../ai_center/ai_screens.dart';

// --- System / Communication ---
import '../communication/system_screens.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _selectedKey = 'overview';
  bool _isOnline = true;

  Widget _getScreen() {
    switch (_selectedKey) {
      // Core
      case 'overview': return const OverviewScreen();
      case 'live_map': return const LiveMapScreen();
      case 'workers': return const WorkersScreen();
      case 'warehouses': return const WarehousesScreen();
      case 'reports': return const ReportsScreen();
      case 'settings': return const SystemSettingsScreen();
      // Operations
      case 'job_board': return const JobBoardScreen();
      case 'routes_scheduling': return const RoutesSchedulingScreen();
      case 'collection_calendar': return const CollectionCalendarScreen();
      // People
      case 'worker_profile': return const WorkerProfileScreen();
      case 'attendance': return const AttendanceScreen();
      case 'payroll': return const PayrollScreen();
      case 'shifts': return const ShiftSchedulerScreen();
      case 'training': return const TrainingScreen();
      case 'performance': return const PerformanceScreen();
      // Logistics
      case 'inventory': return const InventoryScreen();
      case 'pricing': return const PricingScreen();
      case 'stock_logs': return const StockLogsScreen();
      case 'fleet': return const FleetDashboardScreen();
      case 'vehicle_tracker': return const VehicleTrackerScreen();
      case 'maintenance': return const MaintenanceScreen();
      case 'fuel': return const FuelScreen();
      case 'trips': return const TripHistoryScreen();
      // Citizens
      case 'complaints': return const ComplaintsScreen();
      case 'pickups': return const PickupRequestsScreen();
      case 'feedback': return const FeedbackScreen();
      case 'zones': return const ServiceZonesScreen();
      case 'announcements': return const AnnouncementsScreen();
      // Finance
      case 'revenue': return const RevenueDashboardScreen();
      case 'expenses': return const ExpenseTrackerScreen();
      case 'invoices': return const InvoiceScreen();
      case 'payments': return const PaymentHistoryScreen();
      case 'budget': return const BudgetPlannerScreen();
      // Compliance
      case 'sbm': return const SbmComplianceScreen();
      case 'cpcb': return const CpcbReportingScreen();
      case 'gst': return const GstTaxScreen();
      case 'audit': return const AuditTrailScreen();
      // AI
      case 'ai_dashboard': return const AiDashboardScreen();
      case 'forecasting': return const ForecastingScreen();
      case 'smart_routing': return const SmartRoutingScreen();
      // System
      case 'notifications': return const NotificationCenterScreen();
      case 'messaging': return const WorkerMessagingScreen();
      case 'activity': return const ActivityLogsScreen();
      case 'roles': return const RolesPermissionsScreen();
      case 'integrations': return const IntegrationsScreen();
      default: return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.construction_rounded, size: 64, color: AppColors.primaryGreen.withValues(alpha: 0.5)),
          const SizedBox(height: 24),
          Text('Module: $_selectedKey', style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        ]),
      );
    }
  }

  String _getTitle() {
    final titles = {
      'overview': 'Overview',
      'live_map': 'Live Map',
      'workers': 'Workers List',
      'warehouses': 'Warehouses',
      'reports': 'Reports & Analytics',
      'settings': 'System Settings',
      'job_board': 'Job Board',
      'routes_scheduling': 'Routes & Scheduling',
      'collection_calendar': 'Collection Calendar',
      'worker_profile': 'Worker Profile',
      'attendance': 'Attendance Tracker',
      'payroll': 'Payroll & Earnings',
      'shifts': 'Shift Scheduler',
      'training': 'Training & Certs',
      'performance': 'Performance Reviews',
      'inventory': 'Inventory Management',
      'pricing': 'Material Pricing',
      'stock_logs': 'Stock In/Out Logs',
      'fleet': 'Fleet Dashboard',
      'vehicle_tracker': 'Vehicle Tracker',
      'maintenance': 'Maintenance Schedule',
      'fuel': 'Fuel Management',
      'trips': 'Trip History',
      'complaints': 'Citizen Complaints',
      'pickups': 'Pickup Requests',
      'feedback': 'Feedback & Ratings',
      'zones': 'Service Zones',
      'announcements': 'Announcements',
      'revenue': 'Revenue Dashboard',
      'expenses': 'Expense Tracker',
      'invoices': 'Invoice Manager',
      'payments': 'Payment History',
      'budget': 'Budget Planner',
      'sbm': 'SBM Compliance',
      'cpcb': 'CPCB Reporting',
      'gst': 'GST & Tax',
      'audit': 'Audit Trail',
      'ai_dashboard': 'AI Dashboard',
      'forecasting': 'Demand Forecasting',
      'smart_routing': 'Smart Routing',
      'notifications': 'Notification Center',
      'messaging': 'Worker Messaging',
      'activity': 'Activity Logs',
      'roles': 'Roles & Permissions',
      'integrations': 'Integrations',
    };
    return titles[_selectedKey] ?? 'Unknown Route';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Row(
        children: [
          Sidebar(
            selectedKey: _selectedKey,
            onItemSelected: (key) => setState(() => _selectedKey = key),
          ),
          Expanded(
            child: Column(
              children: [
                if (!_isOnline) const OfflineBanner(),
                _buildTopBar(),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: KeyedSubtree(
                      key: ValueKey(_selectedKey),
                      child: _getScreen(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: AppColors.darkSurface.withValues(alpha: 0.75),
            border: const Border(bottom: BorderSide(color: AppColors.darkBorder, width: 1)),
          ),
          child: Row(
        children: [
          Flexible(
            child: Text(
              _getTitle(),
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: _isOnline ? AppColors.primaryGreen.withValues(alpha: 0.12) : AppColors.warningAmber.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isOnline ? AppColors.primaryGreen : AppColors.warningAmber,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  _isOnline ? 'Live' : 'Offline',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _isOnline ? AppColors.primaryGreen : AppColors.warningAmber,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Flexible(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 260),
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.darkSurface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.darkBorder),
              ),
              child: TextField(
                style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Search anything...',
                  hintStyle: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted),
                  prefixIcon: const Icon(Icons.search, size: 18, color: AppColors.textMuted),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            onPressed: () => setState(() => _isOnline = !_isOnline),
            icon: Icon(
              _isOnline ? Icons.cloud_done : Icons.cloud_off,
              size: 20,
              color: _isOnline ? AppColors.primaryGreen : AppColors.warningAmber,
            ),
            tooltip: 'Toggle connectivity (demo)',
          ),
          Stack(
            children: [
              IconButton(
                onPressed: () => setState(() => _selectedKey = 'notifications'),
                icon: const Icon(Icons.notifications_outlined, size: 20, color: AppColors.textSecondary),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.errorRed,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.darkSurface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: AppColors.deepForest,
                  child: Text('A', style: GoogleFonts.outfit(
                    color: AppColors.neonGreen, fontSize: 12, fontWeight: FontWeight.w700,
                  )),
                ),
                const SizedBox(width: 8),
                Text('Admin', style: GoogleFonts.inter(
                  fontSize: 13, color: AppColors.textPrimary, fontWeight: FontWeight.w500,
                )),
              ],
            ),
          ),
        ],
      ),
    )));
  }
}
