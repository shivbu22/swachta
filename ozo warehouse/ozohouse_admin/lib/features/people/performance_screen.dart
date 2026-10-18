import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/colors.dart';

class PerformanceScreen extends StatelessWidget {
  const PerformanceScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final workers = [
      {'name': 'Rajesh Kumar', 'score': 92, 'jobs': 156, 'rating': 4.8, 'attendance': 96, 'trend': 'up'},
      {'name': 'Suresh Patil', 'score': 88, 'jobs': 142, 'rating': 4.6, 'attendance': 94, 'trend': 'up'},
      {'name': 'Kiran Kumari', 'score': 85, 'jobs': 138, 'rating': 4.7, 'attendance': 92, 'trend': 'stable'},
      {'name': 'Amit Sharma', 'score': 78, 'jobs': 125, 'rating': 4.3, 'attendance': 88, 'trend': 'down'},
      {'name': 'Deepak Singh', 'score': 75, 'jobs': 118, 'rating': 4.1, 'attendance': 85, 'trend': 'down'},
      {'name': 'Priya Devi', 'score': 90, 'jobs': 148, 'rating': 4.9, 'attendance': 97, 'trend': 'up'},
      {'name': 'Vikram Joshi', 'score': 72, 'jobs': 110, 'rating': 3.8, 'attendance': 80, 'trend': 'down'},
      {'name': 'Anjali More', 'score': 82, 'jobs': 130, 'rating': 4.4, 'attendance': 90, 'trend': 'stable'},
    ];
    return Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text('Performance Reviews', style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        const Spacer(),
        Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.auto_awesome, size: 14, color: AppColors.neonGreen), const SizedBox(width: 4), Text('AI Scored', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.neonGreen))])),
      ]),
      const SizedBox(height: 16),
      Expanded(child: Container(
        decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
        child: Column(children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14), child: Row(children: [
            _hc('#', 0), _hc('Employee', 2), _hc('AI Score', 1), _hc('Jobs Done', 1), _hc('Rating', 1), _hc('Attendance', 1), _hc('Trend', 1),
          ])),
          const Divider(color: AppColors.darkBorder, height: 1),
          Expanded(child: ListView.separated(
            itemCount: workers.length,
            separatorBuilder: (_, __) => const Divider(color: AppColors.darkBorder, height: 1),
            itemBuilder: (_, i) {
              final w = workers[i];
              final score = w['score'] as int;
              final sc = score >= 85 ? AppColors.successGreen : score >= 70 ? AppColors.warningAmber : AppColors.errorRed;
              final tc = {'up': AppColors.successGreen, 'stable': AppColors.warningAmber, 'down': AppColors.errorRed};
              final ti = {'up': Icons.trending_up, 'stable': Icons.trending_flat, 'down': Icons.trending_down};
              return Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14), child: Row(children: [
                SizedBox(width: 30, child: Text('${i+1}', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: i < 3 ? AppColors.warningAmber : AppColors.textMuted))),
                Expanded(flex: 2, child: Row(children: [
                  CircleAvatar(radius: 16, backgroundColor: AppColors.deepForest, child: Text((w['name'] as String).split(' ').map((n) => n[0]).take(2).join(), style: GoogleFonts.inter(fontSize: 11, color: AppColors.neonGreen, fontWeight: FontWeight.w700))),
                  const SizedBox(width: 10),
                  Text(w['name'] as String, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                ])),
                Expanded(child: Row(children: [
                  Container(width: 36, height: 36, decoration: BoxDecoration(shape: BoxShape.circle, color: sc.withValues(alpha: 0.12)),
                    child: Center(child: Text('$score', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w700, color: sc)))),
                ])),
                Expanded(child: Text('${w['jobs']}', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary))),
                Expanded(child: Row(children: [const Icon(Icons.star, size: 14, color: AppColors.warningAmber), const SizedBox(width: 4), Text('${w['rating']}', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary))])),
                Expanded(child: Text('${w['attendance']}%', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary))),
                Expanded(child: Icon(ti[w['trend']] ?? Icons.trending_flat, size: 20, color: tc[w['trend']] ?? AppColors.textMuted)),
              ]));
            },
          )),
        ]),
      )),
    ]));
  }

  Widget _hc(String t, int f) => f == 0 ? SizedBox(width: 30, child: Text(t, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMuted))) : Expanded(flex: f, child: Text(t, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMuted)));
}
