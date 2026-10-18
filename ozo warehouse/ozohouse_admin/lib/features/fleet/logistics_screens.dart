import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/colors.dart';

// ─── INVENTORY MANAGEMENT ───
class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final items = [
      {'material': 'Mixed Plastic', 'stock': 2450.0, 'capacity': 5000.0, 'unit': 'kg', 'color': AppColors.chartPlastic, 'icon': Icons.shopping_bag},
      {'material': 'Cardboard/Paper', 'stock': 1800.0, 'capacity': 3000.0, 'unit': 'kg', 'color': AppColors.chartOrganic, 'icon': Icons.article},
      {'material': 'Metal & Cans', 'stock': 850.0, 'capacity': 2000.0, 'unit': 'kg', 'color': AppColors.chartMetal, 'icon': Icons.iron},
      {'material': 'E-Waste', 'stock': 320.0, 'capacity': 500.0, 'unit': 'kg', 'color': AppColors.chartEwaste, 'icon': Icons.electrical_services},
      {'material': 'Glass', 'stock': 1200.0, 'capacity': 2500.0, 'unit': 'kg', 'color': AppColors.chartGlass, 'icon': Icons.wine_bar},
      {'material': 'Organic Waste', 'stock': 3800.0, 'capacity': 4000.0, 'unit': 'kg', 'color': AppColors.warningAmber, 'icon': Icons.compost},
    ];
    return Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Inventory Management', style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      const SizedBox(height: 16),
      Expanded(child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 1.4),
        itemCount: items.length,
        itemBuilder: (_, i) {
          final it = items[i];
          final pct = (it['stock'] as double) / (it['capacity'] as double);
          final c = it['color'] as Color;
          final critical = pct > 0.85;
          return Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: critical ? AppColors.errorRed.withValues(alpha: 0.4) : AppColors.darkBorder)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: c.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                  child: Icon(it['icon'] as IconData, size: 22, color: c)),
                const Spacer(),
                if (critical) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: AppColors.errorRed.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.warning, size: 12, color: AppColors.errorRed), const SizedBox(width: 4), Text('NEAR FULL', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.errorRed))])),
              ]),
              const Spacer(),
              Text(it['material'] as String, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              Text('${(it['stock'] as double).toStringAsFixed(0)} / ${(it['capacity'] as double).toStringAsFixed(0)} ${it['unit']}', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(height: 12),
              ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: pct, backgroundColor: AppColors.darkBorder, color: critical ? AppColors.errorRed : c, minHeight: 8)),
              const SizedBox(height: 4),
              Text('${(pct*100).toInt()}% capacity used', style: GoogleFonts.inter(fontSize: 11, color: critical ? AppColors.errorRed : AppColors.textMuted)),
            ]));
        },
      )),
    ]));
  }
}

// ─── MATERIAL PRICING ───
class PricingScreen extends StatelessWidget {
  const PricingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final prices = [
      {'material': 'PET Plastic', 'buy': 8.0, 'sell': 14.5, 'change': 2.3, 'volume': '1,240 kg'},
      {'material': 'HDPE Plastic', 'buy': 6.5, 'sell': 12.0, 'change': -1.2, 'volume': '860 kg'},
      {'material': 'Cardboard', 'buy': 4.0, 'sell': 9.0, 'change': 0.5, 'volume': '2,100 kg'},
      {'material': 'Newspaper', 'buy': 5.0, 'sell': 10.0, 'change': 1.0, 'volume': '980 kg'},
      {'material': 'Aluminum Cans', 'buy': 28.0, 'sell': 42.0, 'change': 3.5, 'volume': '320 kg'},
      {'material': 'Copper Wire', 'buy': 180.0, 'sell': 280.0, 'change': -5.0, 'volume': '45 kg'},
      {'material': 'E-Waste (Mixed)', 'buy': 80.0, 'sell': 150.0, 'change': 10.0, 'volume': '120 kg'},
      {'material': 'Glass Bottles', 'buy': 1.5, 'sell': 3.0, 'change': 0.0, 'volume': '1,800 kg'},
    ];
    return Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text('Material Pricing', style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        const Spacer(),
        Text('Last updated: 2 hours ago', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted)),
      ]),
      const SizedBox(height: 16),
      Expanded(child: Container(
        decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
        child: Column(children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14), child: Row(children: [
            _h('Material', 2), _h('Buy Rate (₹/kg)', 1), _h('Sell Rate (₹/kg)', 1), _h('Margin', 1), _h('7D Change', 1), _h('Volume', 1),
          ])),
          const Divider(color: AppColors.darkBorder, height: 1),
          Expanded(child: ListView.separated(itemCount: prices.length, separatorBuilder: (_, __) => const Divider(color: AppColors.darkBorder, height: 1),
            itemBuilder: (_, i) {
              final p = prices[i];
              final margin = (p['sell'] as double) - (p['buy'] as double);
              final change = p['change'] as double;
              return Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14), child: Row(children: [
                Expanded(flex: 2, child: Text(p['material'] as String, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
                Expanded(child: Text('₹${(p['buy'] as double).toStringAsFixed(1)}', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary))),
                Expanded(child: Text('₹${(p['sell'] as double).toStringAsFixed(1)}', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primaryGreen))),
                Expanded(child: Text('₹${margin.toStringAsFixed(1)}', style: GoogleFonts.inter(fontSize: 13, color: AppColors.successGreen))),
                Expanded(child: Row(children: [
                  Icon(change > 0 ? Icons.trending_up : change < 0 ? Icons.trending_down : Icons.trending_flat, size: 16, color: change > 0 ? AppColors.successGreen : change < 0 ? AppColors.errorRed : AppColors.textMuted),
                  const SizedBox(width: 4),
                  Text('${change > 0 ? '+' : ''}${change.toStringAsFixed(1)}%', style: GoogleFonts.inter(fontSize: 12, color: change > 0 ? AppColors.successGreen : change < 0 ? AppColors.errorRed : AppColors.textMuted)),
                ])),
                Expanded(child: Text(p['volume'] as String, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary))),
              ]));
            },
          )),
        ]),
      )),
    ]));
  }
  Widget _h(String t, int f) => Expanded(flex: f, child: Text(t, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMuted)));
}

// ─── STOCK LOGS ───
class StockLogsScreen extends StatelessWidget {
  const StockLogsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final logs = List.generate(20, (i) {
      final types = ['IN', 'OUT', 'IN', 'IN', 'OUT'];
      final materials = ['Plastic', 'Metal', 'Paper', 'E-Waste', 'Glass'];
      final warehouses = ['Alpha Hub', 'Beta Center', 'Central Depot'];
      return {
        'id': 'STK-${2000+i}', 'type': types[i%5], 'material': materials[i%5],
        'qty': '${(i+1)*25} kg', 'warehouse': warehouses[i%3],
        'by': i%2==0 ? 'Rajesh K.' : 'Amit S.', 'time': '${i+1}h ago',
      };
    });
    return Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Stock In/Out Logs', style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      const SizedBox(height: 16),
      Expanded(child: Container(
        decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
        child: Column(children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14), child: Row(children: [
            _h('Log ID', 1), _h('Type', 1), _h('Material', 1), _h('Quantity', 1), _h('Warehouse', 1), _h('Logged By', 1), _h('Time', 1),
          ])),
          const Divider(color: AppColors.darkBorder, height: 1),
          Expanded(child: ListView.separated(itemCount: logs.length, separatorBuilder: (_, __) => const Divider(color: AppColors.darkBorder, height: 1),
            itemBuilder: (_, i) {
              final l = logs[i];
              final isIn = l['type'] == 'IN';
              return Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), child: Row(children: [
                Expanded(child: Text(l['id']!, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary))),
                Expanded(child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: (isIn ? AppColors.successGreen : AppColors.warningAmber).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                  child: Text(l['type']!, textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: isIn ? AppColors.successGreen : AppColors.warningAmber)))),
                Expanded(child: Text(l['material']!, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary))),
                Expanded(child: Text(l['qty']!, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
                Expanded(child: Text(l['warehouse']!, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary))),
                Expanded(child: Text(l['by']!, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary))),
                Expanded(child: Text(l['time']!, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted))),
              ]));
            },
          )),
        ]),
      )),
    ]));
  }
  Widget _h(String t, int f) => Expanded(flex: f, child: Text(t, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMuted)));
}

// ─── FLEET DASHBOARD ───
class FleetDashboardScreen extends StatelessWidget {
  const FleetDashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final vehicles = [
      {'reg': 'MH 02 AB 1234', 'type': 'Compactor', 'driver': 'Rajesh K.', 'status': 'active', 'fuel': 0.72, 'km': '12,450'},
      {'reg': 'MH 02 CD 5678', 'type': 'Trike', 'driver': 'Suresh P.', 'status': 'active', 'fuel': 0.45, 'km': '8,200'},
      {'reg': 'MH 02 EF 9012', 'type': 'Truck', 'driver': 'Amit S.', 'status': 'idle', 'fuel': 0.88, 'km': '22,100'},
      {'reg': 'MH 02 GH 3456', 'type': 'Compactor', 'driver': null, 'status': 'maintenance', 'fuel': 0.15, 'km': '35,600'},
      {'reg': 'MH 02 IJ 7890', 'type': 'Trike', 'driver': 'Kiran K.', 'status': 'active', 'fuel': 0.60, 'km': '5,800'},
      {'reg': 'MH 02 KL 1122', 'type': 'Truck', 'driver': 'Deepak S.', 'status': 'active', 'fuel': 0.33, 'km': '18,900'},
    ];
    return Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Fleet Dashboard', style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      const SizedBox(height: 16),
      Row(children: [
        _fCard('Total Vehicles', '${vehicles.length}', Icons.directions_car, AppColors.primaryGreen),
        const SizedBox(width: 12), _fCard('Active', '${vehicles.where((v) => v['status'] == 'active').length}', Icons.play_circle, AppColors.successGreen),
        const SizedBox(width: 12), _fCard('Idle', '${vehicles.where((v) => v['status'] == 'idle').length}', Icons.pause_circle, AppColors.warningAmber),
        const SizedBox(width: 12), _fCard('Maintenance', '${vehicles.where((v) => v['status'] == 'maintenance').length}', Icons.build, AppColors.errorRed),
      ]),
      const SizedBox(height: 16),
      Expanded(child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 1.5),
        itemCount: vehicles.length,
        itemBuilder: (_, i) {
          final v = vehicles[i];
          final sc = {'active': AppColors.successGreen, 'idle': AppColors.warningAmber, 'maintenance': AppColors.errorRed};
          final c = sc[v['status']] ?? AppColors.textMuted;
          final fuel = v['fuel'] as double;
          return Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Icon(v['type'] == 'Trike' ? Icons.electric_bike : Icons.local_shipping, size: 22, color: c),
                const SizedBox(width: 10),
                Text(v['reg'] as String, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                const Spacer(),
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: c.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                  child: Text((v['status'] as String).toUpperCase(), style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: c))),
              ]),
              const Spacer(),
              Text(v['type'] as String, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary)),
              Text(v['driver'] != null ? 'Driver: ${v['driver']}' : 'No driver assigned', style: GoogleFonts.inter(fontSize: 12, color: v['driver'] != null ? AppColors.textSecondary : AppColors.errorRed)),
              const SizedBox(height: 8),
              Row(children: [
                const Icon(Icons.local_gas_station, size: 14, color: AppColors.textMuted), const SizedBox(width: 4),
                Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(3), child: LinearProgressIndicator(value: fuel, backgroundColor: AppColors.darkBorder, color: fuel < 0.2 ? AppColors.errorRed : fuel < 0.4 ? AppColors.warningAmber : AppColors.primaryGreen, minHeight: 5))),
                const SizedBox(width: 8),
                Text('${(fuel * 100).toInt()}%', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
              ]),
              const SizedBox(height: 4),
              Text('${v['km']} km total', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
            ]));
        },
      )),
    ]));
  }
  Widget _fCard(String l, String v, IconData ic, Color c) => Expanded(child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.darkBorder)),
    child: Row(children: [Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: c.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)), child: Icon(ic, size: 20, color: c)), const SizedBox(width: 12),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(v, style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary)), Text(l, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary))])])));
}

// ─── VEHICLE TRACKER ───
class VehicleTrackerScreen extends StatelessWidget {
  const VehicleTrackerScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Vehicle Tracker', style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      const SizedBox(height: 16),
      Expanded(child: Row(children: [
        Expanded(flex: 3, child: Container(
          decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
          child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.map, size: 64, color: AppColors.primaryGreen.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text('Live GPS Map', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            Text('Fleet positions update in real-time via Supabase', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary)),
          ])),
        )),
        const SizedBox(width: 16),
        Expanded(flex: 1, child: Container(
          decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(padding: const EdgeInsets.all(16), child: Text('Active Vehicles', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
            const Divider(color: AppColors.darkBorder, height: 1),
            Expanded(child: ListView.builder(itemCount: 5, itemBuilder: (_, i) {
              final regs = ['MH 02 AB 1234', 'MH 02 CD 5678', 'MH 02 EF 9012', 'MH 02 GH 3456', 'MH 02 IJ 7890'];
              return ListTile(dense: true, leading: Icon(Icons.gps_fixed, size: 18, color: AppColors.primaryGreen),
                title: Text(regs[i], style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary)),
                subtitle: Text('Speed: ${20+i*5} km/h', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
                trailing: Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primaryGreen)));
            })),
          ]),
        )),
      ])),
    ]));
  }
}

// ─── MAINTENANCE SCHEDULE ───
class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final items = [
      {'vehicle': 'MH 02 AB 1234', 'type': 'Oil Change', 'due': 'Apr 12', 'status': 'upcoming', 'priority': 'low'},
      {'vehicle': 'MH 02 CD 5678', 'type': 'Brake Inspection', 'due': 'Apr 10', 'status': 'overdue', 'priority': 'high'},
      {'vehicle': 'MH 02 EF 9012', 'type': 'Tire Replacement', 'due': 'Apr 15', 'status': 'upcoming', 'priority': 'medium'},
      {'vehicle': 'MH 02 GH 3456', 'type': 'Engine Service', 'due': 'In Progress', 'status': 'in_progress', 'priority': 'high'},
      {'vehicle': 'MH 02 IJ 7890', 'type': 'Battery Check', 'due': 'Apr 20', 'status': 'upcoming', 'priority': 'low'},
    ];
    return Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Maintenance Schedule', style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      const SizedBox(height: 16),
      Expanded(child: Container(
        decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
        child: ListView.separated(padding: const EdgeInsets.all(16), itemCount: items.length, separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, i) {
            final m = items[i];
            final sc = {'upcoming': AppColors.infoCyan, 'overdue': AppColors.errorRed, 'in_progress': AppColors.warningAmber};
            final c = sc[m['status']] ?? AppColors.textMuted;
            return Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.darkSurface, borderRadius: BorderRadius.circular(12), border: Border.all(color: c.withValues(alpha: 0.2))),
              child: Row(children: [
                Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: c.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                  child: Icon(Icons.build, size: 20, color: c)),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('${m['type']} — ${m['vehicle']}', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  Text('Due: ${m['due']} • Priority: ${m['priority']}', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
                ])),
                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: c.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                  child: Text((m['status'] as String).replaceAll('_', ' ').toUpperCase(), style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: c))),
              ]));
          },
        ),
      )),
    ]));
  }
}

// ─── FUEL MANAGEMENT ───
class FuelScreen extends StatelessWidget {
  const FuelScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final logs = List.generate(10, (i) => {'vehicle': 'MH 02 ${String.fromCharCode(65+i*2)}${String.fromCharCode(66+i*2)} ${1234+i*1111}', 'liters': '${20+i*5}L', 'cost': '₹${(20+i*5)*95}', 'station': i%2==0?'HP Andheri':'BPCL Bandra', 'date': 'Apr ${i+1}', 'mileage': '${8+i%3} km/L'});
    return Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Fuel Management', style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      const SizedBox(height: 16),
      Row(children: [
        _c('Total Fuel Cost', '₹48,200', Icons.local_gas_station, AppColors.warningAmber),
        const SizedBox(width: 12), _c('Avg Mileage', '9.2 km/L', Icons.speed, AppColors.primaryGreen),
        const SizedBox(width: 12), _c('This Month', '520 L', Icons.water_drop, AppColors.infoCyan),
      ]),
      const SizedBox(height: 16),
      Expanded(child: Container(
        decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
        child: Column(children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14), child: Row(children: [_h('Vehicle', 2), _h('Liters', 1), _h('Cost', 1), _h('Station', 1), _h('Mileage', 1), _h('Date', 1)])),
          const Divider(color: AppColors.darkBorder, height: 1),
          Expanded(child: ListView.separated(itemCount: logs.length, separatorBuilder: (_, __) => const Divider(color: AppColors.darkBorder, height: 1),
            itemBuilder: (_, i) {
              final l = logs[i];
              return Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), child: Row(children: [
                Expanded(flex: 2, child: Text(l['vehicle']!, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
                Expanded(child: Text(l['liters']!, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary))),
                Expanded(child: Text(l['cost']!, style: GoogleFonts.inter(fontSize: 13, color: AppColors.warningAmber))),
                Expanded(child: Text(l['station']!, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary))),
                Expanded(child: Text(l['mileage']!, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary))),
                Expanded(child: Text(l['date']!, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted))),
              ]));
            },
          )),
        ]),
      )),
    ]));
  }
  Widget _c(String l, String v, IconData ic, Color c) => Expanded(child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.darkBorder)),
    child: Row(children: [Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: c.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)), child: Icon(ic, size: 20, color: c)), const SizedBox(width: 12),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(v, style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary)), Text(l, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary))])])));
  Widget _h(String t, int f) => Expanded(flex: f, child: Text(t, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMuted)));
}

// ─── TRIP HISTORY ───
class TripHistoryScreen extends StatelessWidget {
  const TripHistoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final trips = List.generate(15, (i) => {'id': 'TRP-${3000+i}', 'vehicle': 'MH 02 AB ${1234+i*100}', 'from': i%2==0 ? 'Warehouse Alpha' : 'Central Depot', 'to': i%3==0 ? 'Zone A' : i%3==1 ? 'Zone B' : 'Zone C', 'dist': '${5+i*2} km', 'duration': '${25+i*5} min', 'date': 'Apr ${9-i%7}', 'waste': '${(i+1)*30} kg'});
    return Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Trip History', style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      const SizedBox(height: 16),
      Expanded(child: Container(
        decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
        child: Column(children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14), child: Row(children: [_h('Trip ID', 1), _h('Vehicle', 1), _h('From', 1), _h('To', 1), _h('Distance', 1), _h('Duration', 1), _h('Waste', 1)])),
          const Divider(color: AppColors.darkBorder, height: 1),
          Expanded(child: ListView.separated(itemCount: trips.length, separatorBuilder: (_, __) => const Divider(color: AppColors.darkBorder, height: 1),
            itemBuilder: (_, i) {
              final t = trips[i];
              return Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), child: Row(children: [
                Expanded(child: Text(t['id']!, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.infoCyan))),
                Expanded(child: Text(t['vehicle']!, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary))),
                Expanded(child: Text(t['from']!, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary))),
                Expanded(child: Text(t['to']!, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary))),
                Expanded(child: Text(t['dist']!, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary))),
                Expanded(child: Text(t['duration']!, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary))),
                Expanded(child: Text(t['waste']!, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primaryGreen))),
              ]));
            },
          )),
        ]),
      )),
    ]));
  }
  Widget _h(String t, int f) => Expanded(flex: f, child: Text(t, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMuted)));
}
