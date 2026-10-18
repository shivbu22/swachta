import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/colors.dart';

class JobBoardScreen extends StatefulWidget {
  const JobBoardScreen({super.key});
  @override
  State<JobBoardScreen> createState() => _JobBoardScreenState();
}

class _JobBoardScreenState extends State<JobBoardScreen> {
  String _filter = 'all';

  final _jobs = List.generate(20, (i) {
    final types = ['pickup', 'sorting', 'transport', 'hazardous', 'sweeping'];
    final statuses = ['pending', 'in_progress', 'completed', 'cancelled'];
    final zones = ['Zone A - Andheri', 'Zone B - Bandra', 'Zone C - Dadar', 'Zone D - Juhu', 'Zone E - Malad'];
    final workers = ['Rajesh K.', 'Suresh P.', 'Amit S.', 'Deepak S.', 'Kiran K.', 'Priya D.', 'Vikram J.', null];
    return {
      'id': 'JOB-${1000 + i}',
      'type': types[i % types.length],
      'status': statuses[i % statuses.length],
      'zone': zones[i % zones.length],
      'worker': workers[i % workers.length],
      'weight': '${(i + 1) * 12} kg',
      'priority': i % 5 == 0 ? 'high' : i % 3 == 0 ? 'medium' : 'low',
      'time': '${6 + (i % 12)}:${i % 2 == 0 ? "00" : "30"} AM',
    };
  });

  @override
  Widget build(BuildContext context) {
    final filtered = _filter == 'all' ? _jobs : _jobs.where((j) => j['status'] == _filter).toList();
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Job Board', style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              const Spacer(),
              _chip('All', 'all'), _chip('Pending', 'pending'), _chip('In Progress', 'in_progress'), _chip('Completed', 'completed'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _statCard('Total Jobs', '${_jobs.length}', Icons.assignment_rounded, AppColors.primaryGreen),
              const SizedBox(width: 12),
              _statCard('Pending', '${_jobs.where((j) => j['status'] == 'pending').length}', Icons.hourglass_empty, AppColors.warningAmber),
              const SizedBox(width: 12),
              _statCard('In Progress', '${_jobs.where((j) => j['status'] == 'in_progress').length}', Icons.play_circle, AppColors.statusOnJob),
              const SizedBox(width: 12),
              _statCard('Completed', '${_jobs.where((j) => j['status'] == 'completed').length}', Icons.check_circle, AppColors.successGreen),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
              child: Column(
                children: [
                  _header(),
                  const Divider(color: AppColors.darkBorder, height: 1),
                  Expanded(child: ListView.separated(
                    padding: const EdgeInsets.all(0),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const Divider(color: AppColors.darkBorder, height: 1),
                    itemBuilder: (_, i) => _row(filtered[i]),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, String value) {
    final sel = _filter == value;
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: GestureDetector(
        onTap: () => setState(() => _filter = value),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: sel ? AppColors.primaryGreen.withValues(alpha: 0.15) : AppColors.darkSurface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: sel ? AppColors.primaryGreen : AppColors.darkBorder),
          ),
          child: Text(label, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: sel ? AppColors.primaryGreen : AppColors.textSecondary)),
        ),
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.darkBorder)),
        child: Row(children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 20, color: color)),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(value, style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            Text(label, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
          ]),
        ]),
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(children: [
        _hCol('Job ID', 1), _hCol('Type', 1), _hCol('Zone', 2), _hCol('Worker', 1), _hCol('Weight', 1), _hCol('Priority', 1), _hCol('Status', 1), _hCol('Actions', 1),
      ]),
    );
  }

  Widget _hCol(String t, int flex) => Expanded(flex: flex, child: Text(t, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMuted)));

  Widget _row(Map<String, dynamic> j) {
    final sc = {'pending': AppColors.warningAmber, 'in_progress': AppColors.statusOnJob, 'completed': AppColors.successGreen, 'cancelled': AppColors.errorRed};
    final pc = {'high': AppColors.errorRed, 'medium': AppColors.warningAmber, 'low': AppColors.primaryGreen};
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(children: [
        Expanded(child: Text(j['id'], style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
        Expanded(child: _typeBadge(j['type'])),
        Expanded(flex: 2, child: Text(j['zone'], style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary))),
        Expanded(child: Text(j['worker'] ?? 'Unassigned', style: GoogleFonts.inter(fontSize: 13, color: j['worker'] != null ? AppColors.textPrimary : AppColors.errorRed))),
        Expanded(child: Text(j['weight'], style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary))),
        Expanded(child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: (pc[j['priority']] ?? AppColors.textMuted).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
          child: Text(j['priority'].toString().toUpperCase(), textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: pc[j['priority']] ?? AppColors.textMuted)),
        )),
        Expanded(child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: (sc[j['status']] ?? AppColors.textMuted).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
          child: Text(j['status'].toString().replaceAll('_', ' ').toUpperCase(), textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: sc[j['status']] ?? AppColors.textMuted)),
        )),
        Expanded(child: Row(children: [
          IconButton(icon: const Icon(Icons.visibility, size: 18, color: AppColors.primaryGreen), onPressed: () {}, tooltip: 'View'),
          IconButton(icon: const Icon(Icons.edit, size: 18, color: AppColors.textMuted), onPressed: () {}, tooltip: 'Edit'),
        ])),
      ]),
    );
  }

  Widget _typeBadge(String type) {
    final colors = {'pickup': AppColors.primaryGreen, 'sorting': AppColors.statusOnJob, 'transport': AppColors.warningAmber, 'hazardous': AppColors.errorRed, 'sweeping': AppColors.infoCyan};
    final icons = {'pickup': Icons.recycling, 'sorting': Icons.sort, 'transport': Icons.local_shipping, 'hazardous': Icons.warning, 'sweeping': Icons.cleaning_services};
    final c = colors[type] ?? AppColors.textMuted;
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icons[type] ?? Icons.work, size: 14, color: c), const SizedBox(width: 4),
      Text(type[0].toUpperCase() + type.substring(1), style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: c)),
    ]);
  }
}
