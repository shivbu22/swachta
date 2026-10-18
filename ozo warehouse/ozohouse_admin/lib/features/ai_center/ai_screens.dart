import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/colors.dart';

// ─── AI DASHBOARD ───
class AiDashboardScreen extends StatelessWidget {
  const AiDashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final models = [
      {'name': 'Anomaly Detection', 'type': 'Z-Score', 'accuracy': '94.2%', 'status': 'active', 'icon': Icons.bug_report, 'color': AppColors.errorRed},
      {'name': 'Demand Forecasting', 'type': 'ARIMA', 'accuracy': '89.7%', 'status': 'active', 'icon': Icons.timeline, 'color': AppColors.primaryGreen},
      {'name': 'Route Optimizer', 'type': '2-Opt TSP', 'accuracy': '91.4%', 'status': 'active', 'icon': Icons.route, 'color': AppColors.infoCyan},
      {'name': 'Worker Risk Scoring', 'type': 'Weighted', 'accuracy': '87.3%', 'status': 'active', 'icon': Icons.shield, 'color': AppColors.warningAmber},
      {'name': 'Sentiment Analysis', 'type': 'Lexicon', 'accuracy': '82.1%', 'status': 'training', 'icon': Icons.sentiment_satisfied, 'color': AppColors.chartEwaste},
      {'name': 'Cluster Zoning', 'type': 'K-Means', 'accuracy': '88.6%', 'status': 'active', 'icon': Icons.bubble_chart, 'color': AppColors.successGreen},
    ];
    return Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text('AI Command Center', style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        const SizedBox(width: 12),
        Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: AppColors.neonGreen.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.auto_awesome, size: 14, color: AppColors.neonGreen), const SizedBox(width: 4),
            Text('12 Models Active', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.neonGreen))])),
      ]),
      const SizedBox(height: 16),
      Row(children: [
        _aiStat('Predictions Today', '1,847', Icons.psychology, AppColors.primaryGreen),
        const SizedBox(width: 12), _aiStat('Avg Accuracy', '89.2%', Icons.track_changes, AppColors.infoCyan),
        const SizedBox(width: 12), _aiStat('Cost Savings', '₹42,000', Icons.savings, AppColors.warningAmber),
        const SizedBox(width: 12), _aiStat('Active Alerts', '3', Icons.notification_important, AppColors.errorRed),
      ]),
      const SizedBox(height: 16),
      Expanded(child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 1.6),
        itemCount: models.length,
        itemBuilder: (_, i) {
          final m = models[i];
          final c = m['color'] as Color;
          final active = m['status'] == 'active';
          return Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(
            color: AppColors.darkCard, borderRadius: BorderRadius.circular(16),
            border: Border.all(color: active ? c.withValues(alpha: 0.3) : AppColors.darkBorder),
            boxShadow: active ? [BoxShadow(color: c.withValues(alpha: 0.05), blurRadius: 20)] : null,
          ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: c.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                  child: Icon(m['icon'] as IconData, size: 22, color: c)),
                const Spacer(),
                Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: active ? AppColors.successGreen : AppColors.warningAmber)),
              ]),
              const Spacer(),
              Text(m['name'] as String, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              Text('${m['type']} • Accuracy: ${m['accuracy']}', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
            ]));
        },
      )),
    ]));
  }
  Widget _aiStat(String l, String v, IconData ic, Color c) => Expanded(child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.darkBorder)),
    child: Row(children: [Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: c.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)), child: Icon(ic, size: 20, color: c)), const SizedBox(width: 12),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(v, style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary)), Text(l, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary))])])));
}

// ─── DEMAND FORECASTING ───
class ForecastingScreen extends StatelessWidget {
  const ForecastingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final forecasts = [
      {'material': 'Plastic', 'current': '2,450 kg', 'forecast': '2,820 kg', 'change': '+15.1%', 'confidence': '92%', 'color': AppColors.chartPlastic},
      {'material': 'Metal', 'current': '850 kg', 'forecast': '920 kg', 'change': '+8.2%', 'confidence': '88%', 'color': AppColors.chartMetal},
      {'material': 'Paper', 'current': '1,800 kg', 'forecast': '1,650 kg', 'change': '-8.3%', 'confidence': '85%', 'color': AppColors.chartOrganic},
      {'material': 'E-Waste', 'current': '320 kg', 'forecast': '480 kg', 'change': '+50%', 'confidence': '78%', 'color': AppColors.chartEwaste},
      {'material': 'Glass', 'current': '1,200 kg', 'forecast': '1,180 kg', 'change': '-1.7%', 'confidence': '91%', 'color': AppColors.chartGlass},
    ];
    return Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text('Demand Forecasting', style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        const SizedBox(width: 12),
        Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppColors.infoCyan.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
          child: Text('ARIMA + Exponential Smoothing', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.infoCyan))),
      ]),
      const SizedBox(height: 16),
      Expanded(child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Next Week Predictions', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 20),
          ...forecasts.map((f) {
            final c = f['color'] as Color;
            final up = (f['change'] as String).startsWith('+');
            return Container(margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.darkSurface, borderRadius: BorderRadius.circular(12)),
              child: Row(children: [
                Container(width: 4, height: 40, decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(2))),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(f['material'] as String, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  Text('Current: ${f['current']} → Forecast: ${f['forecast']}', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
                ])),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Row(children: [
                    Icon(up ? Icons.trending_up : Icons.trending_down, size: 16, color: up ? AppColors.successGreen : AppColors.errorRed),
                    const SizedBox(width: 4),
                    Text(f['change'] as String, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: up ? AppColors.successGreen : AppColors.errorRed)),
                  ]),
                  Text('Confidence: ${f['confidence']}', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
                ]),
              ]));
          }),
        ]),
      )),
    ]));
  }
}

// ─── SMART ROUTING ───
class SmartRoutingScreen extends StatelessWidget {
  const SmartRoutingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text('Smart Routing', style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        const SizedBox(width: 12),
        Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppColors.neonGreen.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
          child: Text('2-Opt Algorithm', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.neonGreen))),
      ]),
      const SizedBox(height: 16),
      Row(children: [
        _c('Routes Optimized', '24', Icons.route, AppColors.primaryGreen),
        const SizedBox(width: 12), _c('Fuel Saved', '18.2%', Icons.eco, AppColors.successGreen),
        const SizedBox(width: 12), _c('Time Saved', '2.4 hrs', Icons.timer, AppColors.infoCyan),
        const SizedBox(width: 12), _c('Cost Reduction', '₹12,400', Icons.savings, AppColors.warningAmber),
      ]),
      const SizedBox(height: 16),
      Expanded(child: Row(children: [
        Expanded(flex: 2, child: Container(
          decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
          child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.map_outlined, size: 64, color: AppColors.neonGreen.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text('Optimized Route Visualization', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            Text('AI-calculated routes with 2-Opt TSP solver', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary)),
          ])),
        )),
        const SizedBox(width: 16),
        Expanded(child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Optimization Log', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 16),
            ...['RT-001: Saved 3.2 km (18%)', 'RT-002: Saved 1.8 km (12%)', 'RT-003: Saved 4.1 km (22%)', 'RT-005: Saved 2.5 km (15%)', 'RT-006: Saved 0.8 km (7%)'].map((l) =>
              Padding(padding: const EdgeInsets.only(bottom: 10), child: Row(children: [
                const Icon(Icons.check_circle, size: 16, color: AppColors.primaryGreen), const SizedBox(width: 8),
                Expanded(child: Text(l, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary))),
              ]))),
          ]),
        )),
      ])),
    ]));
  }
  Widget _c(String l, String v, IconData ic, Color c) => Expanded(child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.darkBorder)),
    child: Row(children: [Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: c.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)), child: Icon(ic, size: 20, color: c)), const SizedBox(width: 12),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(v, style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary)), Text(l, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary))])])));
}
