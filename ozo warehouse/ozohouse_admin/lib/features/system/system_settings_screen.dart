import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';
import '../../../shared/widgets/eco_button.dart';

class SystemSettingsScreen extends StatefulWidget {
  const SystemSettingsScreen({super.key});

  @override
  State<SystemSettingsScreen> createState() => _SystemSettingsScreenState();
}

class _SystemSettingsScreenState extends State<SystemSettingsScreen> {
  int _selectedTab = 0;

  final List<String> _tabs = [
    'Financials & Pay',
    'Safety & Kavach',
    'Operations & Shifts',
    'Map & Clusters',
    'Buyers & Supply Chain',
    'Notifications',
    'Staff Accounts',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Master Configuration',
                style: GoogleFonts.outfit(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              EcoButton(
                label: 'Save Changes',
                icon: Icons.save_rounded,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Configuration saved successfully to Supabase.', style: GoogleFonts.inter()),
                      backgroundColor: AppColors.primaryGreen,
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTabMenu(),
                const SizedBox(width: 24),
                Expanded(child: _buildTabContent()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabMenu() {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: _tabs.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedTab == index;
          return InkWell(
            onTap: () => setState(() => _selectedTab = index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryGreen.withValues(alpha: 0.1) : Colors.transparent,
                border: Border(
                  left: BorderSide(
                    color: isSelected ? AppColors.primaryGreen : Colors.transparent,
                    width: 4,
                  ),
                ),
              ),
              child: Text(
                _tabs[index],
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? AppColors.primaryGreen : AppColors.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0: return _buildFinancialsTab();
      case 1: return _buildSafetyTab();
      case 2: return _buildOperationsTab();
      case 3: return _buildMapClustersTab();
      case 4: return _buildBuyersTab();
      case 5: return _buildNotificationsTab();
      case 6: return _buildStaffTab();
      default: return const SizedBox.shrink();
    }
  }

  // 1. FINANCIALS & PAY
  Widget _buildFinancialsTab() {
    return _SettingsPanel(
      title: 'Financials & Pay Master',
      icon: Icons.account_balance_wallet_rounded,
      children: [
        _ConfigSection(
          title: 'Job Base Pay Rates (per assignment)',
          child: Column(
            children: [
              _buildConfigInput('Street Sweeping', '₹', '250'),
              _buildConfigInput('Bulk Waste Pickup', '₹', '400'),
              _buildConfigInput('Hazardous Clearing', '₹', '800'),
              _buildConfigInput('Public Bin Emptying', '₹', '150'),
            ],
          ),
        ),
        _ConfigSection(
          title: 'Material Price Master Table (per KG)',
          desc: 'Drives performance bonuses across the system.',
          child: Column(
            children: [
              _buildConfigInput('Mixed Plastic', '₹/kg', '12.50'),
              _buildConfigInput('Cardboard/Paper', '₹/kg', '8.00'),
              _buildConfigInput('Metal & Cans', '₹/kg', '35.00'),
              _buildConfigInput('E-Waste (General)', '₹/kg', '120.00'),
              _buildConfigInput('Glass Bottles', '₹/kg', '2.50'),
            ],
          ),
        ),
      ],
    );
  }

  // 2. SAFETY & KAVACH
  Widget _buildSafetyTab() {
    return _SettingsPanel(
      title: 'Safety & Kavach Control',
      icon: Icons.health_and_safety_rounded,
      children: [
        _ConfigSection(
          title: 'Kavach Alert Thresholds',
          desc: 'Sensor parameters triggering SOS alerts.',
          child: Column(
            children: [
              _buildConfigInput('Max Heart Rate Anomaly', 'BPM', '140'),
              _buildConfigInput('Fall Detection Sensitivity', 'G-Force', '3.5'),
              _buildConfigInput('Methane (CH4) Threshold', 'ppm', '500'),
              _buildConfigInput('H2S Gas Alert Level', 'ppm', '10'),
            ],
          ),
        ),
        _ConfigSection(
          title: 'SOS Response Protocols',
          child: Column(
            children: [
              _buildSwitchRow('Auto-dispatch nearest supervisor on SOS', true),
              _buildSwitchRow('Notify local authorities (API integration)', false),
              _buildSwitchRow('Trigger warehouse lockdown mode', false),
              _buildConfigInput('Max Response SLA', 'Minutes', '15'),
            ],
          ),
        ),
      ],
    );
  }

  // 3. OPERATIONS & SHIFTS
  Widget _buildOperationsTab() {
    return _SettingsPanel(
      title: 'Operations & Shifts',
      icon: Icons.schedule_rounded,
      children: [
        _ConfigSection(
          title: 'Shift Hours Configuration',
          child: Column(
            children: [
              _buildConfigInput('Morning Shift Start', 'Time', '06:00 AM'),
              _buildConfigInput('Morning Shift End', 'Time', '02:00 PM'),
              _buildConfigInput('Evening Shift Start', 'Time', '02:00 PM'),
              _buildConfigInput('Evening Shift End', 'Time', '10:00 PM'),
              _buildConfigInput('Night Ops (Fleet)', 'Time', '10:00 PM - 06:00 AM'),
            ],
          ),
        ),
        _ConfigSection(
          title: 'Attendance Tolerances',
          child: Column(
            children: [
              _buildConfigInput('Late Mark Grace Period', 'Minutes', '15'),
              _buildConfigInput('Off-route Deviation Limit', 'Meters', '150'),
            ],
          ),
        ),
      ],
    );
  }

  // 4. MAP & CLUSTERS
  Widget _buildMapClustersTab() {
    return _SettingsPanel(
      title: 'Map & Dynamic Clusters',
      icon: Icons.map_rounded,
      children: [
        _ConfigSection(
          title: 'Clustering Engine',
          desc: 'K-Means AI parameters for auto-zoning.',
          child: Column(
            children: [
              _buildConfigInput('Default K (Cluster Count)', 'Zones', '12'),
              _buildConfigInput('Regeneration Interval', 'Hours', '24'),
              _buildSwitchRow('Auto-assign idle workers to hotspots', true),
              _buildSwitchRow('Show live traffic overlay', true),
            ],
          ),
        ),
      ],
    );
  }

  // 5. BUYERS & SUPPLY CHAIN
  Widget _buildBuyersTab() {
    return _SettingsPanel(
      title: 'Approved Recycler Buyers',
      icon: Icons.handshake_rounded,
      children: [
        _ConfigSection(
          title: 'Buyer Directory',
          desc: 'Manage downstream partners and contact details.',
          child: Column(
            children: [
              _buildBuyerCard('EcoPet Plastics Ltd', 'Plastics', '+91 98765 43210', true),
              _buildBuyerCard('Metro Metal Smelters', 'Metal', '+91 91234 56789', true),
              _buildBuyerCard('GreenBoard Papers', 'Paper/Cardboard', '+91 98888 77777', false),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, color: AppColors.primaryGreen, size: 18),
                label: Text('Add New Buyer', style: GoogleFonts.inter(color: AppColors.primaryGreen)),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.primaryGreen)),
              )
            ],
          ),
        ),
      ],
    );
  }

  // 6. NOTIFICATIONS
  Widget _buildNotificationsTab() {
    return _SettingsPanel(
      title: 'Notification Templates',
      icon: Icons.campaign_rounded,
      children: [
        _ConfigSection(
          title: 'SMS & In-App Messages',
          child: Column(
            children: [
              _buildTemplateCard('Shift Reminder', 'Hi {{name}}, your shift starts at {{time}}. Please report to {{zone}}.', 'SMS & In-App'),
              _buildTemplateCard('Bonus Alert', 'Great job! You earned a bonus of ₹{{amount}} for {{material}} collection.', 'In-App Only'),
              _buildTemplateCard('Emergency Alert', 'SOS triggered by {{name}} at {{location}}. Immediate response required!', 'SMS, In-App, Email'),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, color: AppColors.primaryGreen, size: 18),
                label: Text('Create Template', style: GoogleFonts.inter(color: AppColors.primaryGreen)),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.primaryGreen)),
              )
            ],
          ),
        ),
      ],
    );
  }

  // 7. STAFF ACCOUNTS
  Widget _buildStaffTab() {
    return _SettingsPanel(
      title: 'Warehouse & Admin Staff',
      icon: Icons.admin_panel_settings_rounded,
      children: [
        _ConfigSection(
          title: 'Staff Management',
          child: Column(
            children: [
              _buildStaffCard('Amit Sharma', 'Warehouse Manager', 'Alpha Hub', 'Active'),
              _buildStaffCard('Priya Desai', 'Logistics Coordinator', 'Central HQ', 'Active'),
              _buildStaffCard('Ravi Varma', 'Safety Auditor', 'Roaming', 'On Leave'),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, color: AppColors.primaryGreen, size: 18),
                label: Text('Invite Staff Member', style: GoogleFonts.inter(color: AppColors.primaryGreen)),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.primaryGreen)),
              )
            ],
          ),
        ),
      ],
    );
  }

  // --- Helper Widgets ---

  Widget _buildConfigInput(String label, String suffix, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary)),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.glassWhite,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.darkBorder),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: TextEditingController(text: value),
                      style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary),
                      decoration: const InputDecoration(border: InputBorder.none, isDense: true),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      border: Border(left: BorderSide(color: AppColors.darkBorder)),
                    ),
                    child: Text(suffix, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchRow(String label, bool value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary)),
          Switch(
            value: value,
            onChanged: (v) {},
            activeThumbColor: AppColors.primaryGreen,
            activeTrackColor: AppColors.primaryGreen.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildBuyerCard(String name, String type, String phone, bool active) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.2),
            child: const Icon(Icons.business_rounded, color: AppColors.primaryGreen, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                Text('$type • $phone', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Switch(
            value: active,
            onChanged: (v) {},
            activeThumbColor: AppColors.primaryGreen,
            activeTrackColor: AppColors.primaryGreen.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateCard(String title, String template, String channels) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              Text(channels, style: GoogleFonts.inter(fontSize: 12, color: AppColors.primaryGreen)),
            ],
          ),
          const SizedBox(height: 8),
          Text(template, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary, fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }

  Widget _buildStaffCard(String name, String role, String location, String status) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.deepForest,
            child: Text(name[0], style: GoogleFonts.outfit(color: AppColors.neonGreen, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                Text('$role • $location', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: status == 'Active' ? AppColors.primaryGreen.withValues(alpha: 0.1) : AppColors.warningAmber.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(status, style: GoogleFonts.inter(
              fontSize: 12, fontWeight: FontWeight.w600,
              color: status == 'Active' ? AppColors.neonGreen : AppColors.warningAmber,
            )),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.more_vert, color: AppColors.textMuted, size: 20),
        ],
      ),
    );
  }
}

// Layout helper for sections
class _SettingsPanel extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SettingsPanel({required this.title, required this.icon, required this.children});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 24, color: AppColors.primaryGreen),
              const SizedBox(width: 12),
              Text(title, style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }
}

class _ConfigSection extends StatelessWidget {
  final String title;
  final String? desc;
  final Widget child;

  const _ConfigSection({required this.title, this.desc, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          if (desc != null) ...[
            const SizedBox(height: 4),
            Text(desc!, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary)),
          ],
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}
