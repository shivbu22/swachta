import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/constants/colors.dart';
import '../../core/models/models.dart';
import '../../core/services/ai_service.dart';
import '../../core/services/mock_data_service.dart';
import '../../shared/widgets/shared_widgets.dart';
import '../../shared/utils/formatters.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  late List<WasteDataPoint> _wasteData;
  late List<RevenueDataPoint> _revenueData;
  late List<RevenueDataPoint> _predictions;
  String _dateRange = 'This Month';
  String _district = 'All Districts';
  double _efficiencyScore = 87.5;

  @override
  void initState() {
    super.initState();
    _wasteData = MockDataService.generateWasteByType();
    _revenueData = MockDataService.generateRevenueHistory();
    _predictions = AiService.predictRevenue(_revenueData);
    _efficiencyScore = AiService.calculateEfficiency(
      actualCollected: 8456,
      expectedVolume: 9660,
    );
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
                  Text('Reports & Analytics', style: GoogleFonts.outfit(
                    fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
                  )),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.verified, size: 14, color: AppColors.primaryGreen),
                      const SizedBox(width: 4),
                      Text('Swachh Bharat Compliance Ready', style: GoogleFonts.inter(
                        fontSize: 12, color: AppColors.primaryGreen, fontWeight: FontWeight.w500,
                      )),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.file_download, size: 16),
                    label: const Text('CSV'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.picture_as_pdf, size: 16),
                    label: const Text('PDF Report'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Filters
          EcoCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.filter_list, size: 18, color: AppColors.textMuted),
                const SizedBox(width: 12),
                _buildDropdown('Date Range', _dateRange,
                  ['Today', 'This Week', 'This Month', 'Last 3 Months', 'Custom'],
                  (v) => setState(() => _dateRange = v)),
                const SizedBox(width: 12),
                _buildDropdown('District', _district,
                  ['All Districts', 'Zone A - Central', 'Zone B - North', 'Zone C - South', 'Zone D - East', 'Zone E - West'],
                  (v) => setState(() => _district = v)),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: const Text('Apply Filters'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => setState(() {
                    _dateRange = 'This Month';
                    _district = 'All Districts';
                  }),
                  child: Text('Reset', style: GoogleFonts.inter(
                    color: AppColors.textMuted, fontSize: 13,
                  )),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Charts row
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 800) {
                return Column(
                  children: [
                    _buildWasteBarChart(),
                    const SizedBox(height: 16),
                    _buildRevenueLineChart(),
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildWasteBarChart()),
                  const SizedBox(width: 16),
                  Expanded(child: _buildRevenueLineChart()),
                ],
              );
            },
          ),
          const SizedBox(height: 20),

          // Efficiency + AI predictions row
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 800) {
                return Column(
                  children: [
                    _buildEfficiencyGauge(),
                    const SizedBox(height: 16),
                    _buildAiPredictions(),
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildEfficiencyGauge()),
                  const SizedBox(width: 16),
                  Expanded(flex: 2, child: _buildAiPredictions()),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> options, Function(String) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.darkBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: AppColors.darkSurface,
          style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary),
          items: options.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
          onChanged: (v) => onChanged(v!),
        ),
      ),
    );
  }

  Widget _buildWasteBarChart() {
    final maxVal = _wasteData.map((d) => d.amount).reduce((a, b) => a > b ? a : b);
    final colors = [
      AppColors.chartPlastic,
      AppColors.chartMetal,
      AppColors.chartOrganic,
      AppColors.chartEwaste,
      AppColors.chartGlass,
    ];

    return EcoCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Waste Collected by Type', style: GoogleFonts.outfit(
            fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
          )),
          Text(_dateRange, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted)),
          const SizedBox(height: 24),
          SizedBox(
            height: 250,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxVal * 1.2,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => AppColors.darkCard,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${_wasteData[group.x].wasteType}\n${rod.toY.toStringAsFixed(0)} kg',
                        GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w600),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= _wasteData.length) return const SizedBox();
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            _wasteData[value.toInt()].wasteType,
                            style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          AppFormatters.weight(value),
                          style: GoogleFonts.inter(fontSize: 10, color: AppColors.textMuted),
                        );
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxVal / 4,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppColors.darkBorder.withValues(alpha: 0.5),
                    strokeWidth: 0.5,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(_wasteData.length, (i) {
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: _wasteData[i].amount,
                        color: colors[i % colors.length],
                        width: 28,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            colors[i % colors.length].withValues(alpha: 0.6),
                            colors[i % colors.length],
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueLineChart() {
    final allData = [..._revenueData, ..._predictions];
    final maxY = allData.map((d) => d.amount).reduce((a, b) => a > b ? a : b);
    final minY = allData.map((d) => d.amount).reduce((a, b) => a < b ? a : b);

    return EcoCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Revenue Trend', style: GoogleFonts.outfit(
                    fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
                  )),
                  Text('30 days + 7-day AI forecast', style: GoogleFonts.inter(
                    fontSize: 12, color: AppColors.textMuted,
                  )),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.neonGreen.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.auto_awesome, size: 12, color: AppColors.neonGreen),
                    const SizedBox(width: 4),
                    Text('AI Forecast', style: GoogleFonts.inter(
                      fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.neonGreen,
                    )),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                minY: minY * 0.9,
                maxY: maxY * 1.1,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: (maxY - minY) / 4,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppColors.darkBorder.withValues(alpha: 0.5),
                    strokeWidth: 0.5,
                  ),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 7,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= allData.length) return const SizedBox();
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            AppFormatters.dateShort(allData[idx].date),
                            style: GoogleFonts.inter(fontSize: 10, color: AppColors.textMuted),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 55,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          AppFormatters.currency(value),
                          style: GoogleFonts.inter(fontSize: 10, color: AppColors.textMuted),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (_) => AppColors.darkCard,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final isPrediction = spot.x >= _revenueData.length;
                        return LineTooltipItem(
                          '${isPrediction ? "Predicted: " : ""}${AppFormatters.currencyFull(spot.y)}',
                          GoogleFonts.inter(
                            color: isPrediction ? AppColors.neonGreen : AppColors.primaryGreen,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                lineBarsData: [
                  // Actual revenue line
                  LineChartBarData(
                    spots: List.generate(_revenueData.length, (i) =>
                      FlSpot(i.toDouble(), _revenueData[i].amount)),
                    isCurved: true,
                    color: AppColors.primaryGreen,
                    barWidth: 2.5,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.primaryGreen.withValues(alpha: 0.15),
                          AppColors.primaryGreen.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                  // Prediction line (dashed)
                  if (_predictions.isNotEmpty)
                    LineChartBarData(
                      spots: [
                        FlSpot((_revenueData.length - 1).toDouble(), _revenueData.last.amount),
                        ...List.generate(_predictions.length, (i) =>
                          FlSpot((_revenueData.length + i).toDouble(), _predictions[i].amount)),
                      ],
                      isCurved: true,
                      color: AppColors.neonGreen,
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dashArray: [6, 4],
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.neonGreen.withValues(alpha: 0.08),
                            AppColors.neonGreen.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEfficiencyGauge() {
    return EcoCard(
      glow: true,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, size: 18, color: AppColors.neonGreen),
              const SizedBox(width: 8),
              Text('AI Efficiency Score', style: GoogleFonts.outfit(
                fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
              )),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 160,
            width: 160,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 140,
                  height: 140,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: _efficiencyScore / 100),
                    duration: const Duration(milliseconds: 1500),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, _) {
                      return CircularProgressIndicator(
                        value: value,
                        strokeWidth: 12,
                        backgroundColor: AppColors.darkBackground,
                        valueColor: AlwaysStoppedAnimation(
                          _efficiencyScore > 80 ? AppColors.primaryGreen
                              : _efficiencyScore > 60 ? AppColors.warningAmber
                              : AppColors.errorRed,
                        ),
                        strokeCap: StrokeCap.round,
                      );
                    },
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedCounter(
                      value: _efficiencyScore,
                      suffix: '%',
                      decimals: 1,
                      style: GoogleFonts.outfit(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text('Efficiency', style: GoogleFonts.inter(
                      fontSize: 12, color: AppColors.textMuted,
                    )),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _efficiencyScore > 80 ? 'Excellent Performance' : 'Needs Improvement',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _efficiencyScore > 80 ? AppColors.primaryGreen : AppColors.warningAmber,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Based on collection vs. expected volume',
            style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildAiPredictions() {
    return EcoCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('AI Waste Predictions', style: GoogleFonts.outfit(
            fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
          )),
          Text('Next 7-day forecast by district', style: GoogleFonts.inter(
            fontSize: 12, color: AppColors.textMuted,
          )),
          const SizedBox(height: 16),
          _predictionRow('Zone A - Central', 1450, 1520, true),
          _predictionRow('Zone B - North', 980, 890, false),
          _predictionRow('Zone C - South', 1200, 1350, true),
          _predictionRow('Zone D - East', 760, 810, true),
          _predictionRow('Zone E - West', 880, 850, false),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.infoCyan.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.infoCyan.withValues(alpha: 0.15)),
            ),
            child: Row(
              children: [
                const Icon(Icons.lightbulb, size: 16, color: AppColors.infoCyan),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Recommendation: Add 3 extra workers to Zone C next week for increased volume.',
                    style: GoogleFonts.inter(fontSize: 12, color: AppColors.infoCyan, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _predictionRow(String zone, double current, double predicted, bool up) {
    final change = ((predicted - current) / current * 100);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(zone, style: GoogleFonts.inter(
              fontSize: 13, color: AppColors.textPrimary, fontWeight: FontWeight.w500,
            )),
          ),
          Expanded(
            flex: 2,
            child: Text('${current.toStringAsFixed(0)} kg', style: GoogleFonts.inter(
              fontSize: 13, color: AppColors.textSecondary,
            )),
          ),
          const Icon(Icons.arrow_forward, size: 14, color: AppColors.textMuted),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text('${predicted.toStringAsFixed(0)} kg', style: GoogleFonts.inter(
              fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
            )),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: (up ? AppColors.primaryGreen : AppColors.errorRed).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${up ? '+' : ''}${change.toStringAsFixed(1)}%',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: up ? AppColors.primaryGreen : AppColors.errorRed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
