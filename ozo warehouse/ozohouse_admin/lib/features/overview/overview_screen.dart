import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/colors.dart';
import '../../core/models/models.dart';
import '../../core/services/ai_service.dart';
import '../../core/services/mock_data_service.dart';
import '../../shared/widgets/shared_widgets.dart';
import '../../shared/utils/formatters.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  late MetricModel _metrics;
  late List<ActivityItem> _activities;
  late List<AiInsight> _insights;

  @override
  void initState() {
    super.initState();
    _metrics = MockDataService.generateMetrics();
    _activities = MockDataService.generateActivities();
    _insights = AiService.generateDemoInsights();
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
                  Text('Dashboard Overview', style: GoogleFonts.outfit(
                    fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
                  )),
                  const SizedBox(height: 4),
                  Text('Real-time monitoring • ${DateTime.now().toString().substring(0, 16)}',
                    style: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildHeaderButton(Icons.refresh, 'Refresh', () => setState(() {
                    _metrics = MockDataService.generateMetrics();
                  })),
                  const SizedBox(width: 8),
                  _buildHeaderButton(Icons.notifications_outlined, null, () {}),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 4 Metric Cards
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = (constraints.maxWidth - 48) / 4;
              if (constraints.maxWidth < 800) {
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: _buildMetricCards(constraints.maxWidth < 600
                      ? constraints.maxWidth
                      : (constraints.maxWidth - 16) / 2),
                );
              }
              return Row(
                children: _buildMetricCards(cardWidth)
                    .map((w) => Expanded(child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: w,
                    )))
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 24),

          // Activity Feed + AI Insights
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 800) {
                return Column(
                  children: [
                    _buildActivityFeed(),
                    const SizedBox(height: 16),
                    _buildAiInsightsPanel(),
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: _buildActivityFeed()),
                  const SizedBox(width: 16),
                  Expanded(flex: 2, child: _buildAiInsightsPanel()),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMetricCards(double width) {
    return [
      _MetricCard(
        width: width,
        icon: Icons.people_alt_rounded,
        iconColor: AppColors.neonGreen,
        label: 'Active Workers',
        value: _metrics.activeWorkers.toDouble(),
        prefix: '',
        suffix: '',
        change: _metrics.activeWorkersChange,
        gradientColors: [AppColors.primaryGreen.withValues(alpha: 0.15), AppColors.darkCard],
      ),
      _MetricCard(
        width: width,
        icon: Icons.check_circle_rounded,
        iconColor: AppColors.primaryGreen,
        label: 'Jobs Completed',
        value: _metrics.jobsCompleted.toDouble(),
        prefix: '',
        suffix: '',
        change: _metrics.jobsChange,
        gradientColors: [AppColors.emerald.withValues(alpha: 0.12), AppColors.darkCard],
      ),
      _MetricCard(
        width: width,
        icon: Icons.recycling_rounded,
        iconColor: AppColors.lightLeaf,
        label: 'Waste Collected',
        value: _metrics.wasteCollectedKg,
        prefix: '',
        suffix: ' kg',
        change: _metrics.wasteChange,
        gradientColors: [AppColors.lightLeaf.withValues(alpha: 0.1), AppColors.darkCard],
      ),
      _MetricCard(
        width: width,
        icon: Icons.currency_rupee_rounded,
        iconColor: AppColors.warningAmber,
        label: 'Revenue',
        value: _metrics.revenue,
        prefix: '₹',
        suffix: '',
        change: _metrics.revenueChange,
        gradientColors: [AppColors.warningAmber.withValues(alpha: 0.1), AppColors.darkCard],
      ),
    ];
  }

  Widget _buildHeaderButton(IconData icon, String? label, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: label != null ? 16 : 10, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.darkBorder),
          ),
          child: Row(
            children: [
              Icon(icon, size: 18, color: AppColors.textSecondary),
              if (label != null) ...[
                const SizedBox(width: 6),
                Text(label, style: GoogleFonts.inter(
                  fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w500,
                )),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityFeed() {
    return EcoCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const PulseDot(color: AppColors.primaryGreen, size: 10),
                  const SizedBox(width: 10),
                  Text('Live Activity Feed', style: GoogleFonts.outfit(
                    fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
                  )),
                ],
              ),
              Text('Real-time', style: GoogleFonts.inter(
                fontSize: 11, color: AppColors.neonGreen, fontWeight: FontWeight.w500,
              )),
            ],
          ),
          const SizedBox(height: 16),
          ..._activities.map((a) => _buildActivityRow(a)),
        ],
      ),
    );
  }

  Widget _buildActivityRow(ActivityItem activity) {
    IconData icon;
    Color color;
    switch (activity.type) {
      case 'check_in':
        icon = Icons.login;
        color = AppColors.primaryGreen;
        break;
      case 'job_complete':
        icon = Icons.check_circle;
        color = AppColors.successGreen;
        break;
      case 'delivery':
        icon = Icons.local_shipping;
        color = AppColors.statusOnJob;
        break;
      case 'alert':
        icon = Icons.warning_amber;
        color = AppColors.warningAmber;
        break;
      case 'break':
        icon = Icons.coffee;
        color = AppColors.statusBreak;
        break;
      default:
        icon = Icons.info;
        color = AppColors.textMuted;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary),
                children: [
                  if (activity.workerName != null)
                    TextSpan(
                      text: '${activity.workerName} ',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  TextSpan(text: activity.message),
                ],
              ),
            ),
          ),
          Text(
            AppFormatters.timeAgo(activity.timestamp),
            style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildAiInsightsPanel() {
    return EcoCard(
      glow: true,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryGreen.withValues(alpha: 0.2), AppColors.neonGreen.withValues(alpha: 0.1)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.auto_awesome, size: 18, color: AppColors.neonGreen),
              ),
              const SizedBox(width: 10),
              Text('AI Insights', style: GoogleFonts.outfit(
                fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
              )),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.neonGreen.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('ML', style: GoogleFonts.inter(
                  fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.neonGreen,
                )),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._insights.map((insight) => _buildInsightRow(insight)),
        ],
      ),
    );
  }

  Widget _buildInsightRow(AiInsight insight) {
    Color severityColor;
    IconData severityIcon;
    switch (insight.severity) {
      case 'critical':
        severityColor = AppColors.errorRed;
        severityIcon = Icons.error;
        break;
      case 'warning':
        severityColor = AppColors.warningAmber;
        severityIcon = Icons.warning;
        break;
      default:
        severityColor = AppColors.infoCyan;
        severityIcon = Icons.info;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: severityColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: severityColor.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(severityIcon, size: 16, color: severityColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  insight.title,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: severityColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            insight.description,
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatefulWidget {
  final double width;
  final IconData icon;
  final Color iconColor;
  final String label;
  final double value;
  final String prefix;
  final String suffix;
  final double change;
  final List<Color> gradientColors;

  const _MetricCard({
    required this.width,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.prefix,
    required this.suffix,
    required this.change,
    required this.gradientColors,
  });

  @override
  State<_MetricCard> createState() => _MetricCardState();
}

class _MetricCardState extends State<_MetricCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: widget.width,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: widget.gradientColors,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered
                ? widget.iconColor.withValues(alpha: 0.3)
                : AppColors.darkBorder,
          ),
          boxShadow: _hovered
              ? [BoxShadow(
                  color: widget.iconColor.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                )]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: widget.iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(widget.icon, size: 22, color: widget.iconColor),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (widget.change >= 0 ? AppColors.primaryGreen : AppColors.errorRed)
                        .withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        widget.change >= 0 ? Icons.trending_up : Icons.trending_down,
                        size: 14,
                        color: widget.change >= 0 ? AppColors.primaryGreen : AppColors.errorRed,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.change.toStringAsFixed(1)}%',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: widget.change >= 0 ? AppColors.primaryGreen : AppColors.errorRed,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AnimatedCounter(
              value: widget.value,
              prefix: widget.prefix,
              suffix: widget.suffix,
              style: GoogleFonts.outfit(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.label,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
