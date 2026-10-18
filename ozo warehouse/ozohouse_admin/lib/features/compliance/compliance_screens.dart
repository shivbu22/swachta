import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/colors.dart';

// ─── SBM COMPLIANCE ───
class SbmComplianceScreen extends StatelessWidget {
  const SbmComplianceScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final metrics = [
      {'kpi': 'Door-to-Door Collection', 'target': '100%', 'actual': '96%', 'status': 'on_track', 'pct': 0.96},
      {'kpi': 'Source Segregation', 'target': '80%', 'actual': '72%', 'status': 'at_risk', 'pct': 0.72},
      {'kpi': 'Waste Processing', 'target': '100%', 'actual': '88%', 'status': 'on_track', 'pct': 0.88},
      {'kpi': 'Scientific Disposal', 'target': '100%', 'actual': '94%', 'status': 'on_track', 'pct': 0.94},
      {'kpi': 'ODF++ Compliance', 'target': '100%', 'actual': '100%', 'status': 'achieved', 'pct': 1.0},
      {'kpi': 'Zero Waste Ward', 'target': '5 wards', 'actual': '3 wards', 'status': 'at_risk', 'pct': 0.6},
    ];
    return Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text('SBM 2.0 Compliance', style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        const Spacer(),
        Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.verified, size: 16, color: AppColors.primaryGreen), const SizedBox(width: 6),
            Text('Overall: 88%', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primaryGreen))])),
      ]),
      const SizedBox(height: 16),
      Expanded(child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Key Performance Indicators', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 20),
          ...metrics.map((m) {
            final sc = {'on_track': AppColors.primaryGreen, 'at_risk': AppColors.warningAmber, 'achieved': AppColors.successGreen};
            final c = sc[m['status']] ?? AppColors.textMuted;
            return Padding(padding: const EdgeInsets.only(bottom: 20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(m['kpi'] as String, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const Spacer(),
                Text('${m['actual']} / ${m['target']}', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary)),
                const SizedBox(width: 12),
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: c.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                  child: Text((m['status'] as String).replaceAll('_', ' ').toUpperCase(), style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: c))),
              ]),
              const SizedBox(height: 8),
              ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: m['pct'] as double, backgroundColor: AppColors.darkBorder, color: c, minHeight: 8)),
            ]));
          }),
        ]),
      )),
    ]));
  }
}

// ─── CPCB REPORTING ───
class CpcbReportingScreen extends StatelessWidget {
  const CpcbReportingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final reports = [
      {'name': 'Monthly Waste Processing Report', 'period': 'March 2026', 'status': 'submitted', 'due': 'Apr 5'},
      {'name': 'Annual Environmental Compliance', 'period': 'FY 2025-26', 'status': 'in_progress', 'due': 'Apr 30'},
      {'name': 'Hazardous Waste Manifest', 'period': 'Q1 2026', 'status': 'pending', 'due': 'Apr 15'},
      {'name': 'Bio-Medical Waste Report', 'period': 'March 2026', 'status': 'submitted', 'due': 'Apr 5'},
      {'name': 'E-Waste Collection Certificate', 'period': 'Q1 2026', 'status': 'pending', 'due': 'Apr 20'},
    ];
    return Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('CPCB Reporting', style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      const SizedBox(height: 16),
      Expanded(child: ListView.builder(itemCount: reports.length, itemBuilder: (_, i) {
        final r = reports[i];
        final sc = {'submitted': AppColors.successGreen, 'in_progress': AppColors.warningAmber, 'pending': AppColors.errorRed};
        final c = sc[r['status']] ?? AppColors.textMuted;
        return Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
          child: Row(children: [
            Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: c.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
              child: Icon(Icons.description, size: 24, color: c)),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(r['name']!, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              Text('${r['period']} • Due: ${r['due']}', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
            ])),
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: c.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
              child: Text((r['status'] as String).replaceAll('_', ' ').toUpperCase(), style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: c))),
            const SizedBox(width: 8),
            IconButton(icon: const Icon(Icons.download, size: 18, color: AppColors.textMuted), onPressed: () {}),
          ]));
      })),
    ]));
  }
}

// ─── GST & TAX ───
class GstTaxScreen extends StatelessWidget {
  const GstTaxScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('GST & Tax', style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      const SizedBox(height: 16),
      Row(children: [
        _c('GSTIN', '29AAACZ1234A1Z5', Icons.badge, AppColors.infoCyan),
        const SizedBox(width: 12), _c('GST Payable', '₹1,84,200', Icons.currency_rupee, AppColors.warningAmber),
        const SizedBox(width: 12), _c('Input Credit', '₹62,400', Icons.credit_card, AppColors.successGreen),
        const SizedBox(width: 12), _c('Net Tax', '₹1,21,800', Icons.account_balance, AppColors.errorRed),
      ]),
      const SizedBox(height: 16),
      Expanded(child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Filing Status', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          ...['GSTR-1 (Sales) — March 2026', 'GSTR-3B (Summary) — March 2026', 'GSTR-1 (Sales) — April 2026', 'GSTR-3B (Summary) — April 2026'].asMap().entries.map((e) {
            final filed = e.key < 2;
            return Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.darkSurface, borderRadius: BorderRadius.circular(12)),
              child: Row(children: [
                Icon(filed ? Icons.check_circle : Icons.schedule, size: 20, color: filed ? AppColors.successGreen : AppColors.warningAmber),
                const SizedBox(width: 12),
                Expanded(child: Text(e.value, style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary))),
                Text(filed ? 'Filed' : 'Pending', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: filed ? AppColors.successGreen : AppColors.warningAmber)),
              ]));
          }),
        ]),
      )),
    ]));
  }
  Widget _c(String l, String v, IconData ic, Color c) => Expanded(child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.darkBorder)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(ic, size: 20, color: c), const SizedBox(height: 8),
      Text(v, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      Text(l, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
    ])));
}

// ─── AUDIT TRAIL ───
class AuditTrailScreen extends StatelessWidget {
  const AuditTrailScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final logs = List.generate(20, (i) {
      final actions = ['Modified pay rate', 'Added new worker', 'Deleted route', 'Updated zone boundary', 'Changed buyer status', 'Updated shift schedule', 'Modified alert threshold', 'Exported report'];
      final users = ['admin@ozohouse.com', 'supervisor@ozohouse.com'];
      return {'action': actions[i % actions.length], 'user': users[i % 2], 'ip': '192.168.1.${100+i}', 'time': '${i*15+5} min ago', 'level': i%5==0 ? 'critical' : i%3==0 ? 'warning' : 'info'};
    });
    return Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Audit Trail', style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      const SizedBox(height: 16),
      Expanded(child: Container(
        decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
        child: ListView.separated(padding: const EdgeInsets.all(16), itemCount: logs.length, separatorBuilder: (_, __) => const SizedBox(height: 6),
          itemBuilder: (_, i) {
            final l = logs[i];
            final lc = {'critical': AppColors.errorRed, 'warning': AppColors.warningAmber, 'info': AppColors.textMuted};
            final c = lc[l['level']] ?? AppColors.textMuted;
            return Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.darkSurface, borderRadius: BorderRadius.circular(8)),
              child: Row(children: [
                Container(width: 4, height: 30, decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(2))),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(l['action']!, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  Text('${l['user']} • ${l['ip']}', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
                ])),
                Text(l['time']!, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
              ]));
          }),
      )),
    ]));
  }
}
