import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/colors.dart';

// ─── CITIZEN COMPLAINTS ───
class ComplaintsScreen extends StatelessWidget {
  const ComplaintsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final complaints = [
      {'id': 'CMP-001', 'citizen': 'Ramesh Gupta', 'category': 'Missed Pickup', 'zone': 'Zone A', 'status': 'new', 'priority': 'high', 'time': '2h ago'},
      {'id': 'CMP-002', 'citizen': 'Kavita Sharma', 'category': 'Staff Behavior', 'zone': 'Zone B', 'status': 'in_progress', 'priority': 'medium', 'time': '4h ago'},
      {'id': 'CMP-003', 'citizen': 'Mohan Patel', 'category': 'Overflowing Bin', 'zone': 'Zone C', 'status': 'resolved', 'priority': 'low', 'time': '1d ago'},
      {'id': 'CMP-004', 'citizen': 'Sunita Devi', 'category': 'Missed Pickup', 'zone': 'Zone A', 'status': 'new', 'priority': 'high', 'time': '30m ago'},
      {'id': 'CMP-005', 'citizen': 'Anil Kumar', 'category': 'Noise Complaint', 'zone': 'Zone D', 'status': 'in_progress', 'priority': 'low', 'time': '6h ago'},
      {'id': 'CMP-006', 'citizen': 'Priya Nair', 'category': 'Irregular Schedule', 'zone': 'Zone B', 'status': 'new', 'priority': 'medium', 'time': '1h ago'},
    ];
    return Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Citizen Complaints', style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      const SizedBox(height: 16),
      Row(children: [
        _s('New', '${complaints.where((c) => c['status'] == 'new').length}', AppColors.errorRed),
        const SizedBox(width: 12), _s('In Progress', '${complaints.where((c) => c['status'] == 'in_progress').length}', AppColors.warningAmber),
        const SizedBox(width: 12), _s('Resolved', '${complaints.where((c) => c['status'] == 'resolved').length}', AppColors.successGreen),
        const SizedBox(width: 12), _s('Avg Resolution', '4.2 hrs', AppColors.infoCyan),
      ]),
      const SizedBox(height: 16),
      Expanded(child: Container(
        decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
        child: ListView.separated(padding: const EdgeInsets.all(16), itemCount: complaints.length, separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (_, i) {
            final c = complaints[i];
            final sc = {'new': AppColors.errorRed, 'in_progress': AppColors.warningAmber, 'resolved': AppColors.successGreen};
            final pc = {'high': AppColors.errorRed, 'medium': AppColors.warningAmber, 'low': AppColors.primaryGreen};
            final color = sc[c['status']] ?? AppColors.textMuted;
            return Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.darkSurface, borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withValues(alpha: 0.2))),
              child: Row(children: [
                Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                  child: Icon(Icons.report_problem, size: 20, color: color)),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Text(c['id']!, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
                    const SizedBox(width: 8),
                    Text(c['category']!, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  ]),
                  Text('${c['citizen']} • ${c['zone']} • ${c['time']}', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
                ])),
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), margin: const EdgeInsets.only(right: 8), decoration: BoxDecoration(color: (pc[c['priority']] ?? AppColors.textMuted).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                  child: Text(c['priority']!.toUpperCase(), style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: pc[c['priority']] ?? AppColors.textMuted))),
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                  child: Text((c['status'] as String).replaceAll('_', ' ').toUpperCase(), style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: color))),
              ]));
          },
        ),
      )),
    ]));
  }
  Widget _s(String l, String v, Color c) => Expanded(child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.darkBorder)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(v, style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w700, color: c)), Text(l, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary))])));
}

// ─── PICKUP REQUESTS ───
class PickupRequestsScreen extends StatelessWidget {
  const PickupRequestsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final requests = List.generate(10, (i) => {'id': 'PKP-${4000+i}', 'citizen': 'Citizen ${i+1}', 'type': i%3==0?'Bulk':i%3==1?'E-Waste':'Regular', 'address': 'Block ${String.fromCharCode(65+i)}, Sector ${i+1}', 'status': i<3?'pending':i<7?'assigned':'completed', 'time': '${i+1}h ago'});
    return Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Pickup Requests', style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      const SizedBox(height: 16),
      Expanded(child: Container(
        decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
        child: ListView.separated(padding: const EdgeInsets.all(16), itemCount: requests.length, separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (_, i) {
            final r = requests[i];
            final sc = {'pending': AppColors.warningAmber, 'assigned': AppColors.infoCyan, 'completed': AppColors.successGreen};
            final c = sc[r['status']] ?? AppColors.textMuted;
            return Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.darkSurface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.darkBorder)),
              child: Row(children: [
                Icon(Icons.restore_from_trash, size: 20, color: c), const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('${r['id']} • ${r['type']}', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  Text('${r['citizen']} • ${r['address']}', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
                ])),
                Text(r['time']!, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)), const SizedBox(width: 12),
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: c.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                  child: Text((r['status'] as String).toUpperCase(), style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: c))),
              ]));
          }),
      )),
    ]));
  }
}

// ─── FEEDBACK & RATINGS ───
class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Feedback & Ratings', style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      const SizedBox(height: 16),
      Row(children: [
        _c('NPS Score', '+72', Icons.thumb_up, AppColors.primaryGreen),
        const SizedBox(width: 12), _c('Avg Rating', '4.6 ★', Icons.star, AppColors.warningAmber),
        const SizedBox(width: 12), _c('Total Reviews', '2,847', Icons.reviews, AppColors.infoCyan),
        const SizedBox(width: 12), _c('Sentiment', '85% Positive', Icons.sentiment_satisfied, AppColors.successGreen),
      ]),
      const SizedBox(height: 16),
      Expanded(child: Container(
        decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
        child: ListView.builder(padding: const EdgeInsets.all(16), itemCount: 8, itemBuilder: (_, i) {
          final ratings = [5, 4, 5, 3, 5, 4, 2, 5];
          final msgs = ['Excellent service! Very punctual.', 'Good but could be faster.', 'Best waste management in the city!', 'Missed one pickup this week.', 'Very professional workers.', 'Satisfied with the service overall.', 'Worker was rude. Need improvement.', 'Amazing! Keep up the good work!'];
          final stars = ratings[i];
          final c = stars >= 4 ? AppColors.successGreen : stars >= 3 ? AppColors.warningAmber : AppColors.errorRed;
          return Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.darkSurface, borderRadius: BorderRadius.circular(12)),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              CircleAvatar(radius: 18, backgroundColor: c.withValues(alpha: 0.1), child: Text('$stars', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700, color: c))),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: List.generate(5, (s) => Icon(s < stars ? Icons.star : Icons.star_border, size: 16, color: AppColors.warningAmber))),
                const SizedBox(height: 4),
                Text(msgs[i], style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary)),
                Text('Citizen • Zone ${String.fromCharCode(65+i%5)} • ${i+1}d ago', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
              ])),
            ]));
        }),
      )),
    ]));
  }
  Widget _c(String l, String v, IconData ic, Color c) => Expanded(child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.darkBorder)),
    child: Row(children: [Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: c.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)), child: Icon(ic, size: 20, color: c)), const SizedBox(width: 12),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(v, style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary)), Text(l, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary))])])));
}

// ─── SERVICE ZONES ───
class ServiceZonesScreen extends StatelessWidget {
  const ServiceZonesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final zones = [
      {'name': 'Zone A - Andheri', 'workers': 24, 'area': '12.5 km²', 'population': '85,000', 'efficiency': 92, 'color': AppColors.primaryGreen},
      {'name': 'Zone B - Bandra', 'workers': 18, 'area': '8.2 km²', 'population': '62,000', 'efficiency': 88, 'color': AppColors.statusOnJob},
      {'name': 'Zone C - Dadar', 'workers': 15, 'area': '6.8 km²', 'population': '54,000', 'efficiency': 85, 'color': AppColors.warningAmber},
      {'name': 'Zone D - Juhu', 'workers': 12, 'area': '9.1 km²', 'population': '41,000', 'efficiency': 78, 'color': AppColors.infoCyan},
      {'name': 'Zone E - Malad', 'workers': 20, 'area': '15.3 km²', 'population': '98,000', 'efficiency': 82, 'color': AppColors.chartEwaste},
      {'name': 'Zone F - Goregaon', 'workers': 16, 'area': '11.2 km²', 'population': '72,000', 'efficiency': 90, 'color': AppColors.successGreen},
    ];
    return Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Service Zones', style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      const SizedBox(height: 16),
      Expanded(child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 1.3),
        itemCount: zones.length,
        itemBuilder: (_, i) {
          final z = zones[i];
          final c = z['color'] as Color;
          final eff = z['efficiency'] as int;
          return Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: c.withValues(alpha: 0.3))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(width: 12, height: 12, decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(3))),
                const SizedBox(width: 8),
                Text(z['name'] as String, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              ]),
              const Spacer(),
              _zRow(Icons.people, '${z['workers']} workers'),
              _zRow(Icons.square_foot, z['area'] as String),
              _zRow(Icons.groups, 'Pop: ${z['population']}'),
              const SizedBox(height: 8),
              Row(children: [
                Text('Efficiency: ', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
                Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: eff / 100, backgroundColor: AppColors.darkBorder, color: c, minHeight: 6))),
                const SizedBox(width: 8),
                Text('$eff%', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: c)),
              ]),
            ]));
        },
      )),
    ]));
  }
  Widget _zRow(IconData ic, String t) => Padding(padding: const EdgeInsets.only(bottom: 4), child: Row(children: [Icon(ic, size: 14, color: AppColors.textMuted), const SizedBox(width: 6), Text(t, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary))]));
}

// ─── ANNOUNCEMENTS ───
class AnnouncementsScreen extends StatelessWidget {
  const AnnouncementsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final items = [
      {'title': 'Republic Day Collection Schedule', 'audience': 'All Workers', 'date': 'Apr 6', 'priority': 'high'},
      {'title': 'New PPE Distribution', 'audience': 'Collectors', 'date': 'Apr 5', 'priority': 'medium'},
      {'title': 'Monthly Town Hall - April', 'audience': 'All Staff', 'date': 'Apr 3', 'priority': 'low'},
      {'title': 'Monsoon Preparedness Training', 'audience': 'All Workers', 'date': 'Apr 1', 'priority': 'high'},
      {'title': 'Salary Revision Notice', 'audience': 'All Staff', 'date': 'Mar 28', 'priority': 'high'},
    ];
    return Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Announcements', style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      const SizedBox(height: 16),
      Expanded(child: ListView.builder(itemCount: items.length, itemBuilder: (_, i) {
        final a = items[i];
        final pc = {'high': AppColors.errorRed, 'medium': AppColors.warningAmber, 'low': AppColors.primaryGreen};
        final c = pc[a['priority']] ?? AppColors.textMuted;
        return Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
          child: Row(children: [
            Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: c.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
              child: Icon(Icons.campaign, size: 24, color: c)),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(a['title']!, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              Text('${a['audience']} • ${a['date']}', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
            ])),
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: c.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
              child: Text(a['priority']!.toUpperCase(), style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: c))),
          ]));
      })),
    ]));
  }
}
