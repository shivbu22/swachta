import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';

class Sidebar extends StatefulWidget {
  final String selectedKey;
  final Function(String) onItemSelected;

  const Sidebar({
    super.key,
    required this.selectedKey,
    required this.onItemSelected,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  bool _collapsed = false;

  final List<_NavGroup> _groups = [
    _NavGroup(
      title: 'Operations',
      icon: Icons.dashboard_rounded,
      items: [
        _NavItem(key: 'overview', label: 'Overview', icon: Icons.insights_rounded),
        _NavItem(key: 'live_map', label: 'Live Map', icon: Icons.map_rounded, badge: 'LIVE'),
        _NavItem(key: 'job_board', label: 'Job Board', icon: Icons.assignment_rounded),
        _NavItem(key: 'routes_scheduling', label: 'Routes & Scheduling', icon: Icons.route_rounded),
        _NavItem(key: 'collection_calendar', label: 'Collection Calendar', icon: Icons.calendar_month_rounded),
      ],
    ),
    _NavGroup(
      title: 'People',
      icon: Icons.people_rounded,
      items: [
        _NavItem(key: 'workers', label: 'Workers List', icon: Icons.format_list_bulleted_rounded, badge: '847'),
        _NavItem(key: 'worker_profile', label: 'Worker Profile', icon: Icons.person_rounded),
        _NavItem(key: 'attendance', label: 'Attendance Tracker', icon: Icons.fingerprint_rounded),
        _NavItem(key: 'payroll', label: 'Payroll & Earnings', icon: Icons.payments_rounded),
        _NavItem(key: 'shifts', label: 'Shift Scheduler', icon: Icons.schedule_rounded),
        _NavItem(key: 'training', label: 'Training & Certs', icon: Icons.school_rounded),
        _NavItem(key: 'performance', label: 'Performance Reviews', icon: Icons.star_rounded),
      ],
    ),
    _NavGroup(
      title: 'Logistics',
      icon: Icons.warehouse_rounded,
      items: [
        _NavItem(key: 'warehouses', label: 'Warehouses', icon: Icons.store_rounded),
        _NavItem(key: 'inventory', label: 'Inventory Management', icon: Icons.inventory_2_rounded),
        _NavItem(key: 'pricing', label: 'Material Pricing', icon: Icons.price_change_rounded),
        _NavItem(key: 'stock_logs', label: 'Stock In/Out Logs', icon: Icons.history_rounded),
        _NavItem(key: 'fleet', label: 'Fleet Dashboard', icon: Icons.local_shipping_rounded),
        _NavItem(key: 'vehicle_tracker', label: 'Vehicle Tracker', icon: Icons.gps_fixed_rounded),
        _NavItem(key: 'maintenance', label: 'Maintenance Schedule', icon: Icons.build_rounded),
        _NavItem(key: 'fuel', label: 'Fuel Management', icon: Icons.local_gas_station_rounded),
        _NavItem(key: 'trips', label: 'Trip History', icon: Icons.history_toggle_off_rounded),
      ],
    ),
    _NavGroup(
      title: 'Citizens',
      icon: Icons.public_rounded,
      items: [
        _NavItem(key: 'complaints', label: 'Citizen Complaints', icon: Icons.report_problem_rounded),
        _NavItem(key: 'pickups', label: 'Pickup Requests', icon: Icons.restore_from_trash_rounded),
        _NavItem(key: 'feedback', label: 'Feedback & Ratings', icon: Icons.thumb_up_rounded),
        _NavItem(key: 'zones', label: 'Service Zones', icon: Icons.map_outlined),
        _NavItem(key: 'announcements', label: 'Announcements', icon: Icons.campaign_rounded),
      ],
    ),
    _NavGroup(
      title: 'Finance',
      icon: Icons.account_balance_rounded,
      items: [
        _NavItem(key: 'reports', label: 'Reports & Analytics', icon: Icons.analytics_rounded),
        _NavItem(key: 'revenue', label: 'Revenue Dashboard', icon: Icons.show_chart_rounded),
        _NavItem(key: 'expenses', label: 'Expense Tracker', icon: Icons.money_off_rounded),
        _NavItem(key: 'invoices', label: 'Invoice Manager', icon: Icons.receipt_long_rounded),
        _NavItem(key: 'payments', label: 'Payment History', icon: Icons.account_balance_wallet_rounded),
        _NavItem(key: 'budget', label: 'Budget Planner', icon: Icons.pie_chart_rounded),
      ],
    ),
    _NavGroup(
      title: 'Compliance',
      icon: Icons.gavel_rounded,
      items: [
        _NavItem(key: 'sbm', label: 'SBM Compliance', icon: Icons.verified_rounded),
        _NavItem(key: 'cpcb', label: 'CPCB Reporting', icon: Icons.description_rounded),
        _NavItem(key: 'gst', label: 'GST & Tax', icon: Icons.percent_rounded),
        _NavItem(key: 'audit', label: 'Audit Trail', icon: Icons.plagiarism_rounded),
      ],
    ),
    _NavGroup(
      title: 'AI Center',
      icon: Icons.smart_toy_rounded,
      items: [
        _NavItem(key: 'ai_dashboard', label: 'AI Dashboard', icon: Icons.auto_awesome_rounded),
        _NavItem(key: 'forecasting', label: 'Demand Forecasting', icon: Icons.trending_up_rounded),
        _NavItem(key: 'smart_routing', label: 'Smart Routing', icon: Icons.alt_route_rounded),
      ],
    ),
    _NavGroup(
      title: 'System',
      icon: Icons.settings_applications_rounded,
      items: [
        _NavItem(key: 'notifications', label: 'Notification Center', icon: Icons.notifications_active_rounded),
        _NavItem(key: 'messaging', label: 'Worker Messaging', icon: Icons.chat_rounded),
        _NavItem(key: 'activity', label: 'Activity Logs', icon: Icons.list_alt_rounded),
        _NavItem(key: 'roles', label: 'Roles & Permissions', icon: Icons.admin_panel_settings_rounded),
        _NavItem(key: 'integrations', label: 'Integrations', icon: Icons.integration_instructions_rounded),
        _NavItem(key: 'settings', label: 'System Settings', icon: Icons.settings_rounded),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = _collapsed ? Dimensions.sidebarCollapsed : 280.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: width,
      decoration: BoxDecoration(
        color: AppColors.sidebarBg,
        border: const Border(
          right: BorderSide(color: AppColors.darkBorder, width: 1),
        ),
      ),
      child: Column(
        children: [
          _buildLogo(),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              itemCount: _groups.length,
              itemBuilder: (context, index) => _buildNavGroup(_groups[index]),
            ),
          ),
          const Divider(color: AppColors.darkBorder, height: 1),
          _buildAdminProfile(),
          _buildCollapseButton(),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: AppColors.primaryGradient),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryGreen.withValues(alpha: 0.3),
                  blurRadius: 12,
                ),
              ],
            ),
            child: const Icon(Icons.eco, color: Colors.white, size: 22),
          ),
          if (!_collapsed) ...[
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'OZOHOUSE',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: 2,
                    ),
                  ),
                  Text(
                    'Admin Panel v2',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNavGroup(_NavGroup group) {
    if (_collapsed) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: IconButton(
          icon: Icon(group.icon, color: AppColors.textMuted),
          onPressed: () => setState(() => _collapsed = false),
          tooltip: group.title,
        ),
      );
    }

    final hasSelectedItem = group.items.any((item) => item.key == widget.selectedKey);

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        initiallyExpanded: hasSelectedItem,
        tilePadding: const EdgeInsets.symmetric(horizontal: 8),
        leading: Icon(group.icon, size: 20, color: hasSelectedItem ? AppColors.primaryGreen : AppColors.textSecondary),
        title: Text(
          group.title,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: hasSelectedItem ? FontWeight.w700 : FontWeight.w600,
            color: hasSelectedItem ? AppColors.primaryGreen : AppColors.textSecondary,
          ),
        ),
        iconColor: AppColors.primaryGreen,
        collapsedIconColor: AppColors.textMuted,
        children: group.items.map((item) => _buildNavItem(item)).toList(),
      ),
    );
  }

  Widget _buildNavItem(_NavItem item) {
    final isSelected = widget.selectedKey == item.key;

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 8, bottom: 4),
      child: InkWell(
        onTap: () => widget.onItemSelected(item.key),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryGreen.withValues(alpha: 0.12) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isSelected ? Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.2)) : null,
          ),
          child: Row(
            children: [
              Icon(item.icon, size: 16, color: isSelected ? AppColors.primaryGreen : AppColors.textMuted),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  item.label,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? AppColors.primaryGreen : AppColors.textMuted,
                  ),
                ),
              ),
              if (item.badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: item.badge == 'LIVE' ? AppColors.primaryGreen.withValues(alpha: 0.15) : AppColors.glassWhite,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.badge!,
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: item.badge == 'LIVE' ? AppColors.neonGreen : AppColors.textMuted,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminProfile() {
    return Container(
      padding: EdgeInsets.all(_collapsed ? 12 : 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.deepForest,
            child: Text(
              'A',
              style: GoogleFonts.outfit(
                color: AppColors.neonGreen,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
          if (!_collapsed) ...[
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Admin User',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'System Architect',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
              icon: const Icon(Icons.logout, size: 18, color: AppColors.textMuted),
              tooltip: 'Logout',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCollapseButton() {
    return GestureDetector(
      onTap: () => setState(() => _collapsed = !_collapsed),
      child: Container(
        height: 40,
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.darkBorder)),
        ),
        child: Center(
          child: Icon(
            _collapsed ? Icons.chevron_right : Icons.chevron_left,
            color: AppColors.textMuted,
            size: 20,
          ),
        ),
      ),
    );
  }
}

class _NavGroup {
  final String title;
  final IconData icon;
  final List<_NavItem> items;

  const _NavGroup({required this.title, required this.icon, required this.items});
}

class _NavItem {
  final String key;
  final String label;
  final IconData icon;
  final String? badge;

  const _NavItem({required this.key, required this.label, required this.icon, this.badge});
}
