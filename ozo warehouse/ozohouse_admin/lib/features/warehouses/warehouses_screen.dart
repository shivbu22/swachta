import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/colors.dart';
import '../../core/models/models.dart';
import '../../core/services/ai_service.dart';
import '../../core/services/mock_data_service.dart';
import '../../shared/widgets/shared_widgets.dart';
import '../../shared/utils/formatters.dart';

class WarehousesScreen extends StatefulWidget {
  const WarehousesScreen({super.key});

  @override
  State<WarehousesScreen> createState() => _WarehousesScreenState();
}

class _WarehousesScreenState extends State<WarehousesScreen> {
  late List<WarehouseModel> _warehouses;

  @override
  void initState() {
    super.initState();
    _warehouses = MockDataService.generateWarehouses();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Warehouse Operations', style: GoogleFonts.outfit(
                    fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
                  )),
                  const SizedBox(height: 4),
                  Text('${_warehouses.length} warehouses active', style: GoogleFonts.inter(
                    fontSize: 13, color: AppColors.textMuted,
                  )),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Warehouse'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Summary row
          Row(
            children: [
              _buildSummaryPill(Icons.warehouse, 'Total Capacity',
                AppFormatters.weight(_warehouses.fold(0.0, (s, w) => s + w.maxCapacityKg))),
              const SizedBox(width: 12),
              _buildSummaryPill(Icons.inventory, 'Currently Stored',
                AppFormatters.weight(_warehouses.fold(0.0, (s, w) => s + w.currentKg))),
              const SizedBox(width: 12),
              _buildSummaryPill(Icons.currency_rupee, 'Today\'s Revenue',
                AppFormatters.currency(_warehouses.fold(0.0, (s, w) => s + w.todayRevenue))),
            ],
          ),
          const SizedBox(height: 24),

          // Warehouse cards grid
          LayoutBuilder(
            builder: (context, constraints) {
              final cols = constraints.maxWidth > 1000 ? 3 : constraints.maxWidth > 600 ? 2 : 1;
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: _warehouses.map((wh) => SizedBox(
                  width: (constraints.maxWidth - (cols - 1) * 16) / cols,
                  child: _buildWarehouseCard(wh),
                )).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryPill(IconData icon, String label, String value) {
    return Expanded(
      child: EcoCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: AppColors.primaryGreen),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
                const SizedBox(height: 2),
                Text(value, style: GoogleFonts.outfit(
                  fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWarehouseCard(WarehouseModel wh) {
    final pct = wh.capacityPercentage;
    final capacityColor = pct > 85 ? AppColors.errorRed
        : pct > 65 ? AppColors.warningAmber
        : AppColors.primaryGreen;

    final daysToFull = AiService.predictDaysToFull(
      currentKg: wh.currentKg,
      maxCapacityKg: wh.maxCapacityKg,
      dailyFillRate: wh.currentKg / 30,
    );

    return EcoCard(
      glow: pct > 85,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: capacityColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.warehouse, size: 20, color: capacityColor),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(wh.name.split(' — ').first, style: GoogleFonts.outfit(
                            fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
                          )),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 12, color: AppColors.textMuted),
                              const SizedBox(width: 2),
                              Text(wh.location, style: GoogleFonts.inter(
                                fontSize: 11, color: AppColors.textMuted,
                              )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              StatusBadge(status: wh.status),
            ],
          ),
          const SizedBox(height: 20),

          // Capacity bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Capacity', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted)),
              Text('${pct.toStringAsFixed(0)}%', style: GoogleFonts.inter(
                fontSize: 12, fontWeight: FontWeight.w700, color: capacityColor,
              )),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: pct / 100),
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) {
                return LinearProgressIndicator(
                  value: value,
                  minHeight: 10,
                  backgroundColor: AppColors.darkBackground,
                  valueColor: AlwaysStoppedAnimation(capacityColor),
                );
              },
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${AppFormatters.weight(wh.currentKg)} / ${AppFormatters.weight(wh.maxCapacityKg)}',
            style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted),
          ),
          const SizedBox(height: 16),

          // Stats row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Today's Revenue", style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(AppFormatters.currency(wh.todayRevenue), style: GoogleFonts.outfit(
                          fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
                        )),
                        const SizedBox(width: 4),
                        const Icon(Icons.trending_up, size: 14, color: AppColors.primaryGreen),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Top Material', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
                    const SizedBox(height: 4),
                    Text(wh.topMaterial, style: GoogleFonts.inter(
                      fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
                    )),
                    Text(AppFormatters.weight(wh.topMaterialKg), style: GoogleFonts.inter(
                      fontSize: 11, color: AppColors.textSecondary,
                    )),
                  ],
                ),
              ),
            ],
          ),

          // AI prediction
          if (daysToFull != null) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (daysToFull <= 3 ? AppColors.errorRed : AppColors.infoCyan).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: (daysToFull <= 3 ? AppColors.errorRed : AppColors.infoCyan).withValues(alpha: 0.15),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.auto_awesome,
                    size: 14,
                    color: daysToFull <= 3 ? AppColors.errorRed : AppColors.infoCyan,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'AI: ~$daysToFull days to full capacity',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: daysToFull <= 3 ? AppColors.errorRed : AppColors.infoCyan,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.darkBorder),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text('View Details', style: GoogleFonts.inter(
                fontSize: 12, color: AppColors.textSecondary,
              )),
            ),
          ),
        ],
      ),
    );
  }
}
