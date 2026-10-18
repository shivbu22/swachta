import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/colors.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final workers = List.generate(15, (i) {
      final names = ['Rajesh Kumar','Suresh Patil','Amit Sharma','Deepak Singh','Kiran Kumari','Priya Devi','Vikram Joshi','Anjali More','Rohit Gupta','Sanjay Yadav','Meera Nair','Arun Pillai','Geeta Das','Manoj Tiwari','Pooja Shah'];
      final statuses = ['present','present','present','present','present','late','absent','half_day','present','present','leave','present','present','late','present'];
      return {'name': names[i], 'status': statuses[i], 'checkIn': i < 10 ? '0${6+i%3}:${i%2==0?"00":"15"} AM' : '--:--', 'checkOut': i < 8 ? '0${2+i%3}:${i%2==0?"00":"30"} PM' : '--:--', 'hours': i < 8 ? '${7+i%2}h ${i*5}m' : '--'};
    });
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text('Attendance Tracker', style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const Spacer(),
          Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: AppColors.darkSurface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.darkBorder)),
            child: Row(children: [const Icon(Icons.calendar_today, size: 16, color: AppColors.textMuted), const SizedBox(width: 8), Text('April 9, 2026', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary))])),
        ]),
        const SizedBox(height: 16),
        Row(children: [
          _statCard('Present', '${workers.where((w)=>w['status']=='present').length}', AppColors.successGreen),
          const SizedBox(width: 12), _statCard('Late', '${workers.where((w)=>w['status']=='late').length}', AppColors.warningAmber),
          const SizedBox(width: 12), _statCard('Absent', '${workers.where((w)=>w['status']=='absent').length}', AppColors.errorRed),
          const SizedBox(width: 12), _statCard('On Leave', '${workers.where((w)=>w['status']=='leave').length}', AppColors.infoCyan),
          const SizedBox(width: 12), _statCard('Half Day', '${workers.where((w)=>w['status']=='half_day').length}', AppColors.statusBreak),
        ]),
        const SizedBox(height: 16),
        Expanded(child: Container(
          decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
          child: Column(children: [
            _tableHeader(),
            const Divider(color: AppColors.darkBorder, height: 1),
            Expanded(child: ListView.separated(
              itemCount: workers.length,
              separatorBuilder: (_, __) => const Divider(color: AppColors.darkBorder, height: 1),
              itemBuilder: (_, i) => _tableRow(workers[i], i),
            )),
          ]),
        )),
      ]),
    );
  }

  Widget _statCard(String label, String value, Color color) => Expanded(child: Container(
    padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.darkBorder)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(value, style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w700, color: color)),
      Text(label, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
    ]),
  ));

  Widget _tableHeader() => Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    child: Row(children: [
      _hc('Employee', 2), _hc('Status', 1), _hc('Check In', 1), _hc('Check Out', 1), _hc('Hours', 1), _hc('Actions', 1),
    ]));

  Widget _hc(String t, int f) => Expanded(flex: f, child: Text(t, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMuted)));

  Widget _tableRow(Map<String, dynamic> w, int i) {
    final sc = {'present': AppColors.successGreen, 'late': AppColors.warningAmber, 'absent': AppColors.errorRed, 'leave': AppColors.infoCyan, 'half_day': AppColors.statusBreak};
    final c = sc[w['status']] ?? AppColors.textMuted;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(children: [
        Expanded(flex: 2, child: Row(children: [
          CircleAvatar(radius: 16, backgroundColor: AppColors.deepForest, child: Text((w['name'] as String).split(' ').map((n) => n[0]).take(2).join(), style: GoogleFonts.inter(fontSize: 11, color: AppColors.neonGreen, fontWeight: FontWeight.w700))),
          const SizedBox(width: 10),
          Text(w['name'] as String, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ])),
        Expanded(child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: c.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
          child: Text((w['status'] as String).replaceAll('_',' ').toUpperCase(), textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: c)))),
        Expanded(child: Text(w['checkIn'] as String, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary))),
        Expanded(child: Text(w['checkOut'] as String, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary))),
        Expanded(child: Text(w['hours'] as String, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary))),
        Expanded(child: Row(children: [
          IconButton(icon: const Icon(Icons.edit, size: 16, color: AppColors.textMuted), onPressed: () {}, tooltip: 'Override'),
          IconButton(icon: const Icon(Icons.history, size: 16, color: AppColors.textMuted), onPressed: () {}, tooltip: 'History'),
        ])),
      ]),
    );
  }
}
