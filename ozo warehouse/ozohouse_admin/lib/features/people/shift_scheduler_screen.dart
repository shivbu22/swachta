import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/colors.dart';

class ShiftSchedulerScreen extends StatelessWidget {
  const ShiftSchedulerScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final shifts = [
      {'name': 'Morning Sweep', 'time': '06:00 - 14:00', 'assigned': 35, 'required': 40, 'status': 'understaffed'},
      {'name': 'Midday Collection', 'time': '10:00 - 18:00', 'assigned': 28, 'required': 25, 'status': 'full'},
      {'name': 'Evening Route', 'time': '14:00 - 22:00', 'assigned': 22, 'required': 30, 'status': 'understaffed'},
      {'name': 'Night Fleet Ops', 'time': '22:00 - 06:00', 'assigned': 12, 'required': 12, 'status': 'full'},
    ];
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Shift Scheduler', style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      const SizedBox(height: 16),
      Expanded(child: Column(children: [
        ...shifts.map((s) {
          final full = s['status'] == 'full';
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Icon(Icons.schedule, size: 20, color: full ? AppColors.primaryGreen : AppColors.warningAmber),
                const SizedBox(width: 10),
                Text(s['name'] as String, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const SizedBox(width: 12),
                Text(s['time'] as String, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary)),
                const Spacer(),
                Text('${s['assigned']}/${s['required']} workers', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: full ? AppColors.primaryGreen : AppColors.warningAmber)),
                const SizedBox(width: 12),
                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: (full ? AppColors.primaryGreen : AppColors.warningAmber).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                  child: Text(full ? 'FULL' : 'UNDERSTAFFED', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: full ? AppColors.primaryGreen : AppColors.warningAmber))),
              ]),
              const SizedBox(height: 12),
              Row(children: days.map((d) => Expanded(child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(color: d == 'Sun' ? AppColors.errorRed.withValues(alpha: 0.08) : AppColors.primaryGreen.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(8)),
                child: Column(children: [
                  Text(d, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: d == 'Sun' ? AppColors.errorRed : AppColors.textSecondary)),
                  const SizedBox(height: 2),
                  Text(d == 'Sun' ? '—' : '✓', style: GoogleFonts.inter(fontSize: 12, color: d == 'Sun' ? AppColors.errorRed : AppColors.primaryGreen)),
                ]),
              ))).toList()),
            ]),
          );
        }),
      ])),
    ]));
  }
}
