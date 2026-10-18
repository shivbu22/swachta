import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/colors.dart';

class WorkerProfileScreen extends StatelessWidget {
  const WorkerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildProfileHeader(),
        const SizedBox(height: 24),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(flex: 2, child: Column(children: [_buildStatsGrid(), const SizedBox(height: 16), _buildRecentActivity()])),
          const SizedBox(width: 16),
          Expanded(child: Column(children: [_buildContactCard(), const SizedBox(height: 16), _buildDocuments(), const SizedBox(height: 16), _buildRiskScore()])),
        ]),
      ]),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
      child: Row(children: [
        CircleAvatar(radius: 40, backgroundColor: AppColors.deepForest, child: Text('RK', style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.neonGreen))),
        const SizedBox(width: 24),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text('Rajesh Kumar', style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const SizedBox(width: 12),
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
              child: Text('ONLINE', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primaryGreen))),
          ]),
          const SizedBox(height: 4),
          Text('Collector • Zone A - Andheri East • Employee ID: EMP-001', style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          Row(children: [
            _tag('⭐ 4.8 Rating'), _tag('📅 Joined Jan 2024'), _tag('🏆 Top Performer'),
          ]),
        ])),
        Column(children: [
          _actionBtn(Icons.message, 'Message', AppColors.primaryGreen),
          const SizedBox(height: 8),
          _actionBtn(Icons.edit, 'Edit Profile', AppColors.infoCyan),
        ]),
      ]),
    );
  }

  Widget _tag(String t) => Container(
    margin: const EdgeInsets.only(right: 8),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: AppColors.darkSurface, borderRadius: BorderRadius.circular(8)),
    child: Text(t, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
  );

  Widget _actionBtn(IconData icon, String label, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withValues(alpha: 0.3))),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 16, color: color), const SizedBox(width: 6),
      Text(label, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: color)),
    ]),
  );

  Widget _buildStatsGrid() {
    final stats = [
      {'label': 'Jobs Completed', 'value': '1,247', 'icon': Icons.check_circle, 'color': AppColors.successGreen},
      {'label': 'Waste Collected', 'value': '8,430 kg', 'icon': Icons.recycling, 'color': AppColors.primaryGreen},
      {'label': 'Attendance Rate', 'value': '96%', 'icon': Icons.calendar_today, 'color': AppColors.infoCyan},
      {'label': 'Earnings (Month)', 'value': '₹28,500', 'icon': Icons.currency_rupee, 'color': AppColors.warningAmber},
      {'label': 'Avg. Response Time', 'value': '4.2 min', 'icon': Icons.timer, 'color': AppColors.statusOnJob},
      {'label': 'Customer Feedback', 'value': '4.8/5.0', 'icon': Icons.star, 'color': AppColors.warningAmber},
    ];
    return Wrap(spacing: 12, runSpacing: 12, children: stats.map((s) {
      final c = s['color'] as Color;
      return Container(width: 200, padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.darkBorder)),
        child: Row(children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: c.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
            child: Icon(s['icon'] as IconData, size: 20, color: c)),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(s['value'] as String, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            Text(s['label'] as String, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary)),
          ]),
        ]));
    }).toList());
  }

  Widget _buildRecentActivity() {
    final acts = [
      {'time': '10 min ago', 'action': 'Completed plastic pickup — 45 kg at Zone A', 'icon': Icons.check_circle, 'color': AppColors.successGreen},
      {'time': '1 hr ago', 'action': 'Started shift at Warehouse Alpha', 'icon': Icons.login, 'color': AppColors.primaryGreen},
      {'time': '2 hrs ago', 'action': 'Received 5-star rating from citizen', 'icon': Icons.star, 'color': AppColors.warningAmber},
      {'time': 'Yesterday', 'action': 'Completed safety training module', 'icon': Icons.school, 'color': AppColors.infoCyan},
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Recent Activity', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const SizedBox(height: 16),
        ...acts.map((a) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Row(children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: (a['color'] as Color).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
            child: Icon(a['icon'] as IconData, size: 16, color: a['color'] as Color)),
          const SizedBox(width: 12),
          Expanded(child: Text(a['action'] as String, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary))),
          Text(a['time'] as String, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
        ]))),
      ]),
    );
  }

  Widget _buildContactCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Contact Info', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const SizedBox(height: 16),
        _contactRow(Icons.phone, '+91 98765 43210'),
        _contactRow(Icons.email, 'rajesh.k@ozohouse.com'),
        _contactRow(Icons.home, 'Andheri East, Mumbai 400069'),
        _contactRow(Icons.badge, 'Aadhaar: XXXX-XXXX-4321'),
      ]),
    );
  }

  Widget _contactRow(IconData icon, String text) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(children: [
      Icon(icon, size: 16, color: AppColors.textMuted), const SizedBox(width: 10),
      Expanded(child: Text(text, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary))),
    ]),
  );

  Widget _buildDocuments() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Documents', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const SizedBox(height: 16),
        _docRow('Aadhaar Card', 'Verified', AppColors.successGreen),
        _docRow('PAN Card', 'Verified', AppColors.successGreen),
        _docRow('Safety Certificate', 'Valid till Dec 2026', AppColors.infoCyan),
        _docRow('Medical Fitness', 'Expires Nov 2026', AppColors.warningAmber),
      ]),
    );
  }

  Widget _docRow(String name, String status, Color color) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(children: [
      Icon(Icons.description, size: 16, color: AppColors.textMuted), const SizedBox(width: 10),
      Expanded(child: Text(name, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary))),
      Text(status, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
    ]),
  );

  Widget _buildRiskScore() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.2))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.shield, size: 20, color: AppColors.primaryGreen),
          const SizedBox(width: 8),
          Text('AI Risk Score', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ]),
        const SizedBox(height: 16),
        Center(child: Stack(alignment: Alignment.center, children: [
          SizedBox(width: 80, height: 80, child: CircularProgressIndicator(value: 0.15, strokeWidth: 8, backgroundColor: AppColors.darkBorder, color: AppColors.primaryGreen)),
          Text('15', style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.primaryGreen)),
        ])),
        const SizedBox(height: 12),
        Center(child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
          child: Text('LOW RISK', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primaryGreen)))),
        const SizedBox(height: 8),
        Text('This worker has excellent attendance and zero complaints.', textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
      ]),
    );
  }
}
