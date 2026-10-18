import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/colors.dart';

class RoutesSchedulingScreen extends StatelessWidget {
  const RoutesSchedulingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Routes & Scheduling', style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        const SizedBox(height: 16),
        Expanded(child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(flex: 3, child: _RoutesList()),
          const SizedBox(width: 16),
          Expanded(flex: 2, child: _SchedulePanel()),
        ])),
      ]),
    );
  }
}

class _RoutesList extends StatelessWidget {
  final _routes = const [
    {'id': 'RT-001', 'name': 'Andheri East Loop', 'stops': 14, 'distance': '12.3 km', 'driver': 'Rajesh Kumar', 'vehicle': 'MH 02 AB 1234', 'status': 'active', 'progress': 0.65},
    {'id': 'RT-002', 'name': 'Bandra West Circuit', 'stops': 18, 'distance': '15.7 km', 'driver': 'Suresh Patil', 'vehicle': 'MH 02 CD 5678', 'status': 'active', 'progress': 0.3},
    {'id': 'RT-003', 'name': 'Dadar Central', 'stops': 11, 'distance': '8.2 km', 'driver': 'Amit Sharma', 'vehicle': 'MH 02 EF 9012', 'status': 'completed', 'progress': 1.0},
    {'id': 'RT-004', 'name': 'Juhu Beach Corridor', 'stops': 9, 'distance': '6.5 km', 'driver': null, 'vehicle': null, 'status': 'scheduled', 'progress': 0.0},
    {'id': 'RT-005', 'name': 'Malad Industrial', 'stops': 22, 'distance': '19.1 km', 'driver': 'Deepak Singh', 'vehicle': 'MH 02 GH 3456', 'status': 'active', 'progress': 0.45},
    {'id': 'RT-006', 'name': 'Goregaon Link', 'stops': 16, 'distance': '11.8 km', 'driver': 'Kiran Kumari', 'vehicle': 'MH 02 IJ 7890', 'status': 'delayed', 'progress': 0.2},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
      child: Column(children: [
        Padding(padding: const EdgeInsets.all(20), child: Row(children: [
          Text('Active Routes', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const Spacer(),
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
            child: Text('${_routes.where((r) => r['status'] == 'active').length} Active', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryGreen))),
        ])),
        const Divider(color: AppColors.darkBorder, height: 1),
        Expanded(child: ListView.separated(
          padding: const EdgeInsets.all(0),
          itemCount: _routes.length,
          separatorBuilder: (_, __) => const Divider(color: AppColors.darkBorder, height: 1),
          itemBuilder: (_, i) {
            final r = _routes[i];
            final sc = {'active': AppColors.primaryGreen, 'completed': AppColors.successGreen, 'scheduled': AppColors.infoCyan, 'delayed': AppColors.errorRed};
            final c = sc[r['status']] ?? AppColors.textMuted;
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: c.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                    child: Icon(Icons.route, size: 18, color: c)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(r['name'] as String, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    Text('${r['id']} • ${r['stops']} stops • ${r['distance']}', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
                  ])),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: c.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                    child: Text((r['status'] as String).toUpperCase(), style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: c))),
                ]),
                if (r['driver'] != null) ...[
                  const SizedBox(height: 10),
                  Row(children: [
                    const SizedBox(width: 42),
                    Icon(Icons.person, size: 14, color: AppColors.textMuted), const SizedBox(width: 4),
                    Text(r['driver'] as String, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
                    const SizedBox(width: 16),
                    Icon(Icons.local_shipping, size: 14, color: AppColors.textMuted), const SizedBox(width: 4),
                    Text(r['vehicle'] as String, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
                  ]),
                ],
                const SizedBox(height: 10),
                Row(children: [
                  const SizedBox(width: 42),
                  Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(value: (r['progress'] as double), backgroundColor: AppColors.darkBorder, color: c, minHeight: 6))),
                  const SizedBox(width: 8),
                  Text('${((r['progress'] as double) * 100).toInt()}%', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: c)),
                ]),
              ]),
            );
          },
        )),
      ]),
    );
  }
}

class _SchedulePanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final slots = [
      {'time': '06:00 AM', 'route': 'Andheri East Loop', 'type': 'Morning Sweep'},
      {'time': '07:30 AM', 'route': 'Bandra West Circuit', 'type': 'Residential Pickup'},
      {'time': '09:00 AM', 'route': 'Dadar Central', 'type': 'Commercial Pickup'},
      {'time': '10:30 AM', 'route': 'Malad Industrial', 'type': 'Industrial Waste'},
      {'time': '12:00 PM', 'route': 'Juhu Beach Corridor', 'type': 'Beach Cleanup'},
      {'time': '02:00 PM', 'route': 'Goregaon Link', 'type': 'Afternoon Route'},
      {'time': '04:00 PM', 'route': 'Andheri East Loop', 'type': 'Evening Sweep'},
      {'time': '06:00 PM', 'route': 'Bandra West Circuit', 'type': 'Night Pickup'},
    ];
    return Container(
      decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
      child: Column(children: [
        Padding(padding: const EdgeInsets.all(20), child: Row(children: [
          Text("Today's Schedule", style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ])),
        const Divider(color: AppColors.darkBorder, height: 1),
        Expanded(child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: slots.length,
          itemBuilder: (_, i) {
            final s = slots[i];
            final done = i < 3;
            return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Column(children: [
                Container(width: 12, height: 12, decoration: BoxDecoration(shape: BoxShape.circle, color: done ? AppColors.primaryGreen : AppColors.darkBorder, border: Border.all(color: done ? AppColors.primaryGreen : AppColors.textMuted, width: 2))),
                if (i < slots.length - 1) Container(width: 2, height: 50, color: AppColors.darkBorder),
              ]),
              const SizedBox(width: 12),
              Expanded(child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: done ? AppColors.primaryGreen.withValues(alpha: 0.06) : AppColors.darkSurface, borderRadius: BorderRadius.circular(10), border: Border.all(color: done ? AppColors.primaryGreen.withValues(alpha: 0.2) : AppColors.darkBorder)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Text(s['time']!, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: done ? AppColors.primaryGreen : AppColors.textPrimary)),
                    const Spacer(),
                    if (done) const Icon(Icons.check_circle, size: 16, color: AppColors.primaryGreen),
                  ]),
                  const SizedBox(height: 4),
                  Text(s['route']!, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  Text(s['type']!, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
                ]),
              )),
            ]);
          },
        )),
      ]),
    );
  }
}
