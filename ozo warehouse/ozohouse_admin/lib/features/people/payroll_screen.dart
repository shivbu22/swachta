import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/colors.dart';

class PayrollScreen extends StatelessWidget {
  const PayrollScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final workers = List.generate(12, (i) {
      final names = ['Rajesh Kumar','Suresh Patil','Amit Sharma','Deepak Singh','Kiran Kumari','Priya Devi','Vikram Joshi','Anjali More','Rohit Gupta','Sanjay Yadav','Meera Nair','Arun Pillai'];
      return {'name': names[i], 'role': i%3==0?'Collector':i%3==1?'Driver':'Sorter', 'base': (15000+i*1000), 'bonus': (2000+i*300), 'deductions': (500+i*100), 'status': i<8?'paid':'pending'};
    });
    return Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text('Payroll & Earnings', style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        const Spacer(),
        Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), decoration: BoxDecoration(color: AppColors.darkSurface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.darkBorder)),
          child: Text('April 2026', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary))),
      ]),
      const SizedBox(height: 16),
      Row(children: [
        _card('Total Payroll', '₹3,84,600', Icons.account_balance_wallet, AppColors.primaryGreen),
        const SizedBox(width: 12), _card('Bonuses Paid', '₹42,000', Icons.stars, AppColors.warningAmber),
        const SizedBox(width: 12), _card('Deductions', '₹12,300', Icons.money_off, AppColors.errorRed),
        const SizedBox(width: 12), _card('Pending', '4 workers', Icons.hourglass_empty, AppColors.infoCyan),
      ]),
      const SizedBox(height: 16),
      Expanded(child: Container(
        decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
        child: Column(children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14), child: Row(children: [
            _hc('Employee', 2), _hc('Role', 1), _hc('Base Pay', 1), _hc('Bonus', 1), _hc('Deductions', 1), _hc('Net Pay', 1), _hc('Status', 1),
          ])),
          const Divider(color: AppColors.darkBorder, height: 1),
          Expanded(child: ListView.separated(
            itemCount: workers.length,
            separatorBuilder: (_, __) => const Divider(color: AppColors.darkBorder, height: 1),
            itemBuilder: (_, i) {
              final w = workers[i];
              final net = (w['base'] as int) + (w['bonus'] as int) - (w['deductions'] as int);
              final paid = w['status'] == 'paid';
              return Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14), child: Row(children: [
                Expanded(flex: 2, child: Text(w['name'] as String, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
                Expanded(child: Text(w['role'] as String, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary))),
                Expanded(child: Text('₹${w['base']}', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary))),
                Expanded(child: Text('+₹${w['bonus']}', style: GoogleFonts.inter(fontSize: 13, color: AppColors.successGreen))),
                Expanded(child: Text('-₹${w['deductions']}', style: GoogleFonts.inter(fontSize: 13, color: AppColors.errorRed))),
                Expanded(child: Text('₹$net', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary))),
                Expanded(child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: (paid ? AppColors.successGreen : AppColors.warningAmber).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                  child: Text(paid ? 'PAID' : 'PENDING', textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: paid ? AppColors.successGreen : AppColors.warningAmber)))),
              ]));
            },
          )),
        ]),
      )),
    ]));
  }

  Widget _card(String label, String value, IconData icon, Color color) => Expanded(child: Container(
    padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.darkBorder)),
    child: Row(children: [
      Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, size: 20, color: color)),
      const SizedBox(width: 12),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(value, style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        Text(label, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
      ]),
    ]),
  ));

  Widget _hc(String t, int f) => Expanded(flex: f, child: Text(t, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMuted)));
}
