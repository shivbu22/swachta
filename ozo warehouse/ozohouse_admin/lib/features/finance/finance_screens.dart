import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/colors.dart';

// ─── REVENUE DASHBOARD ───
class RevenueDashboardScreen extends StatelessWidget {
  const RevenueDashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Revenue Dashboard', style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      const SizedBox(height: 16),
      Row(children: [
        _c('Revenue (MTD)', '₹12,84,500', Icons.trending_up, AppColors.primaryGreen, '+18%'),
        const SizedBox(width: 12), _c('Expenses', '₹4,62,000', Icons.trending_down, AppColors.errorRed, '-5%'),
        const SizedBox(width: 12), _c('Net Profit', '₹8,22,500', Icons.account_balance, AppColors.successGreen, '+24%'),
        const SizedBox(width: 12), _c('Collection Revenue', '₹6,45,000', Icons.recycling, AppColors.warningAmber, '+12%'),
      ]),
      const SizedBox(height: 16),
      Expanded(child: Row(children: [
        Expanded(flex: 2, child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Revenue Breakdown', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 16),
            _revRow('Plastic Sales', '₹3,20,000', 0.35, AppColors.chartPlastic),
            _revRow('Metal & E-Waste', '₹2,15,000', 0.24, AppColors.chartMetal),
            _revRow('Paper/Cardboard', '₹1,85,000', 0.20, AppColors.chartOrganic),
            _revRow('Service Contracts', '₹1,20,000', 0.13, AppColors.infoCyan),
            _revRow('Government Subsidies', '₹44,500', 0.05, AppColors.successGreen),
            _revRow('Other', '₹0', 0.03, AppColors.textMuted),
          ]),
        )),
        const SizedBox(width: 16),
        Expanded(child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Top Zones by Revenue', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 16),
            ...['Zone A - ₹3,82,000', 'Zone B - ₹2,95,000', 'Zone E - ₹2,44,000', 'Zone C - ₹1,85,000', 'Zone D - ₹1,78,500'].asMap().entries.map((e) =>
              Padding(padding: const EdgeInsets.only(bottom: 12), child: Row(children: [
                Container(width: 28, height: 28, decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primaryGreen.withValues(alpha: 0.12)),
                  child: Center(child: Text('${e.key+1}', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primaryGreen)))),
                const SizedBox(width: 12),
                Text(e.value, style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary)),
              ]))),
          ]),
        )),
      ])),
    ]));
  }
  Widget _c(String l, String v, IconData ic, Color c, String chg) => Expanded(child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.darkBorder)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: c.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)), child: Icon(ic, size: 18, color: c)), const Spacer(),
        Text(chg, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: chg.startsWith('+') ? AppColors.successGreen : AppColors.errorRed))]),
      const SizedBox(height: 8),
      Text(v, style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      Text(l, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
    ])));
  static Widget _revRow(String l, String v, double p, Color c) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(children: [Text(l, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary)), const Spacer(), Text(v, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: c))]),
    const SizedBox(height: 4),
    ClipRRect(borderRadius: BorderRadius.circular(3), child: LinearProgressIndicator(value: p, backgroundColor: AppColors.darkBorder, color: c, minHeight: 6)),
  ]));
}

// ─── EXPENSE TRACKER ───
class ExpenseTrackerScreen extends StatelessWidget {
  const ExpenseTrackerScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final expenses = [
      {'category': 'Worker Salaries', 'amount': '₹2,84,000', 'pct': 0.42, 'icon': Icons.people, 'color': AppColors.primaryGreen},
      {'category': 'Fuel & Transport', 'amount': '₹68,000', 'pct': 0.15, 'icon': Icons.local_gas_station, 'color': AppColors.warningAmber},
      {'category': 'Vehicle Maintenance', 'amount': '₹32,000', 'pct': 0.07, 'icon': Icons.build, 'color': AppColors.errorRed},
      {'category': 'Warehouse Rent', 'amount': '₹45,000', 'pct': 0.10, 'icon': Icons.warehouse, 'color': AppColors.infoCyan},
      {'category': 'PPE & Equipment', 'amount': '₹18,000', 'pct': 0.04, 'icon': Icons.health_and_safety, 'color': AppColors.chartEwaste},
      {'category': 'Admin & Office', 'amount': '₹15,000', 'pct': 0.03, 'icon': Icons.computer, 'color': AppColors.textSecondary},
    ];
    return Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Expense Tracker', style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      const SizedBox(height: 16),
      Expanded(child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 1.5),
        itemCount: expenses.length,
        itemBuilder: (_, i) {
          final e = expenses[i];
          final c = e['color'] as Color;
          return Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: c.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)), child: Icon(e['icon'] as IconData, size: 22, color: c)), const Spacer(),
                Text('${((e['pct'] as double)*100).toInt()}%', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w700, color: c))]),
              const Spacer(),
              Text(e['category'] as String, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              Text(e['amount'] as String, style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: e['pct'] as double, backgroundColor: AppColors.darkBorder, color: c, minHeight: 6)),
            ]));
        },
      )),
    ]));
  }
}

// ─── INVOICE MANAGER ───
class InvoiceScreen extends StatelessWidget {
  const InvoiceScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final invoices = List.generate(12, (i) => {'id': 'INV-${5000+i}', 'buyer': i%3==0?'GreenRecycle Pvt.':i%3==1?'MetalWorks Inc.':'EcoPlast Ltd.', 'amount': '₹${(i+1)*12000}', 'date': 'Apr ${i+1}', 'status': i%4==0?'paid':i%4==1?'pending':i%4==2?'overdue':'draft'});
    return Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Invoice Manager', style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      const SizedBox(height: 16),
      Expanded(child: Container(
        decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
        child: Column(children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14), child: Row(children: [
            _h('Invoice #', 1), _h('Buyer', 2), _h('Amount', 1), _h('Date', 1), _h('Status', 1), _h('Actions', 1),
          ])),
          const Divider(color: AppColors.darkBorder, height: 1),
          Expanded(child: ListView.separated(itemCount: invoices.length, separatorBuilder: (_, __) => const Divider(color: AppColors.darkBorder, height: 1),
            itemBuilder: (_, i) {
              final inv = invoices[i];
              final sc = {'paid': AppColors.successGreen, 'pending': AppColors.warningAmber, 'overdue': AppColors.errorRed, 'draft': AppColors.textMuted};
              final c = sc[inv['status']] ?? AppColors.textMuted;
              return Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14), child: Row(children: [
                Expanded(child: Text(inv['id']!, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.infoCyan))),
                Expanded(flex: 2, child: Text(inv['buyer']!, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary))),
                Expanded(child: Text(inv['amount']!, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
                Expanded(child: Text(inv['date']!, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary))),
                Expanded(child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: c.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                  child: Text(inv['status']!.toUpperCase(), textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: c)))),
                Expanded(child: Row(children: [
                  IconButton(icon: const Icon(Icons.visibility, size: 16, color: AppColors.textMuted), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.download, size: 16, color: AppColors.primaryGreen), onPressed: () {}),
                ])),
              ]));
            },
          )),
        ]),
      )),
    ]));
  }
  Widget _h(String t, int f) => Expanded(flex: f, child: Text(t, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMuted)));
}

// ─── PAYMENT HISTORY ───
class PaymentHistoryScreen extends StatelessWidget {
  const PaymentHistoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final payments = List.generate(15, (i) => {'id': 'PAY-${6000+i}', 'type': i%2==0?'Received':'Sent', 'from': i%2==0?'GreenRecycle':'Payroll', 'amount': '₹${(i+1)*8000}', 'method': i%3==0?'UPI':i%3==1?'NEFT':'Bank Transfer', 'date': 'Apr ${9-i%9}'});
    return Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Payment History', style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      const SizedBox(height: 16),
      Expanded(child: Container(
        decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
        child: ListView.separated(padding: const EdgeInsets.all(16), itemCount: payments.length, separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (_, i) {
            final p = payments[i];
            final isIn = p['type'] == 'Received';
            final c = isIn ? AppColors.successGreen : AppColors.errorRed;
            return Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.darkSurface, borderRadius: BorderRadius.circular(10)),
              child: Row(children: [
                Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: c.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                  child: Icon(isIn ? Icons.arrow_downward : Icons.arrow_upward, size: 18, color: c)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('${p['id']} • ${p['from']}', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  Text('${p['method']} • ${p['date']}', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
                ])),
                Text('${isIn ? "+" : "-"}${p['amount']}', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: c)),
              ]));
          },
        ),
      )),
    ]));
  }
}

// ─── BUDGET PLANNER ───
class BudgetPlannerScreen extends StatelessWidget {
  const BudgetPlannerScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final categories = [
      {'name': 'Salaries', 'budgeted': 300000, 'spent': 284000, 'color': AppColors.primaryGreen},
      {'name': 'Fuel', 'budgeted': 80000, 'spent': 68000, 'color': AppColors.warningAmber},
      {'name': 'Maintenance', 'budgeted': 50000, 'spent': 52000, 'color': AppColors.errorRed},
      {'name': 'Equipment', 'budgeted': 30000, 'spent': 18000, 'color': AppColors.infoCyan},
      {'name': 'Office', 'budgeted': 20000, 'spent': 15000, 'color': AppColors.chartEwaste},
    ];
    return Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Text('Budget Planner', style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary)), const Spacer(), Text('April 2026', style: GoogleFonts.inter(fontSize: 14, color: AppColors.textMuted))]),
      const SizedBox(height: 16),
      Row(children: [
        _bCard('Total Budget', '₹4,80,000', AppColors.infoCyan),
        const SizedBox(width: 12), _bCard('Total Spent', '₹4,37,000', AppColors.warningAmber),
        const SizedBox(width: 12), _bCard('Remaining', '₹43,000', AppColors.primaryGreen),
        const SizedBox(width: 12), _bCard('Budget Usage', '91%', AppColors.errorRed),
      ]),
      const SizedBox(height: 16),
      Expanded(child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Category Breakdown', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          ...categories.map((cat) {
            final budgeted = cat['budgeted'] as int;
            final spent = cat['spent'] as int;
            final pct = spent / budgeted;
            final over = pct > 1;
            final c = cat['color'] as Color;
            return Padding(padding: const EdgeInsets.only(bottom: 16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(cat['name'] as String, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const Spacer(),
                Text('₹$spent / ₹$budgeted', style: GoogleFonts.inter(fontSize: 13, color: over ? AppColors.errorRed : AppColors.textSecondary)),
                if (over) ...[const SizedBox(width: 8), const Icon(Icons.warning, size: 14, color: AppColors.errorRed)],
              ]),
              const SizedBox(height: 6),
              ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: pct.clamp(0, 1).toDouble(), backgroundColor: AppColors.darkBorder, color: over ? AppColors.errorRed : c, minHeight: 8)),
            ]));
          }),
        ]),
      )),
    ]));
  }
  Widget _bCard(String l, String v, Color c) => Expanded(child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.darkBorder)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(v, style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w700, color: c)), Text(l, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary))])));
}
