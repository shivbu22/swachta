import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/colors.dart';
import '../../core/models/worker_model.dart';
import '../../core/services/mock_data_service.dart';
import '../../shared/widgets/shared_widgets.dart';

class LiveMapScreen extends StatefulWidget {
  const LiveMapScreen({super.key});

  @override
  State<LiveMapScreen> createState() => _LiveMapScreenState();
}

class _LiveMapScreenState extends State<LiveMapScreen> with TickerProviderStateMixin {
  late List<WorkerModel> _workers;
  WorkerModel? _selectedWorker;
  String _jobFilter = 'all';
  late AnimationController _dotAnimController;

  @override
  void initState() {
    super.initState();
    _workers = MockDataService.generateWorkers(count: 20)
      .where((w) => w.status != 'offline')
      .toList();
    _dotAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _dotAnimController.dispose();
    super.dispose();
  }

  Color _getJobColor(String? jobType) {
    switch (jobType) {
      case 'pickup': return AppColors.jobPickup;
      case 'sorting': return AppColors.jobSorting;
      case 'transport': return AppColors.jobTransport;
      case 'idle': return AppColors.jobIdle;
      default: return AppColors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredWorkers = _jobFilter == 'all'
        ? _workers
        : _workers.where((w) => w.currentJobType == _jobFilter).toList();

    return Stack(
      children: [
        // Map placeholder (dark themed)
        Container(
          decoration: const BoxDecoration(
            color: AppColors.darkBackground,
          ),
          child: Stack(
            children: [
              // Simulated dark map grid
              CustomPaint(
                size: Size.infinite,
                painter: _MapGridPainter(),
              ),
              // Worker dots
              ...filteredWorkers.map((w) => _buildWorkerDot(w)),
              // Center text
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.darkCard.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.darkBorder),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.map, size: 32, color: AppColors.primaryGreen),
                      const SizedBox(height: 8),
                      Text('Interactive Map View', style: GoogleFonts.outfit(
                        fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
                      )),
                      const SizedBox(height: 4),
                      Text('Add Google Maps API key to enable', style: GoogleFonts.inter(
                        fontSize: 12, color: AppColors.textMuted,
                      )),
                      const SizedBox(height: 4),
                      Text('${filteredWorkers.length} workers shown below', style: GoogleFonts.inter(
                        fontSize: 11, color: AppColors.neonGreen,
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Top filter bar
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: EcoCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                const Icon(Icons.filter_list, size: 18, color: AppColors.textMuted),
                const SizedBox(width: 8),
                _buildMapFilter('All', 'all'),
                _buildMapFilter('Pickup', 'pickup'),
                _buildMapFilter('Sorting', 'sorting'),
                _buildMapFilter('Transport', 'transport'),
                _buildMapFilter('Idle', 'idle'),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const PulseDot(color: AppColors.neonGreen, size: 8),
                      const SizedBox(width: 6),
                      Text('${filteredWorkers.length} Online', style: GoogleFonts.inter(
                        fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.neonGreen,
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Legend
        Positioned(
          bottom: 16,
          left: 16,
          child: EcoCard(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('LEGEND', style: GoogleFonts.inter(
                  fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textMuted, letterSpacing: 1,
                )),
                const SizedBox(height: 8),
                _buildLegendItem(AppColors.jobPickup, 'Pickup'),
                _buildLegendItem(AppColors.jobSorting, 'Sorting'),
                _buildLegendItem(AppColors.jobTransport, 'Transport'),
                _buildLegendItem(AppColors.jobIdle, 'Idle'),
              ],
            ),
          ),
        ),

        // Selected worker panel
        if (_selectedWorker != null)
          Positioned(
            top: 80,
            right: 16,
            child: _buildWorkerInfoPanel(_selectedWorker!),
          ),
      ],
    );
  }

  Widget _buildWorkerDot(WorkerModel worker) {
    // Distribute dots across the screen based on lat/lng
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final normalizedLat = ((worker.latitude ?? 19.076) - 19.03) / 0.1;
    final normalizedLng = ((worker.longitude ?? 72.877) - 72.83) / 0.1;
    final x = (normalizedLng * (screenWidth * 0.6) + screenWidth * 0.15).clamp(50.0, screenWidth - 80);
    final y = (normalizedLat * (screenHeight * 0.5) + screenHeight * 0.15).clamp(80.0, screenHeight - 80);

    return Positioned(
      left: x,
      top: y,
      child: GestureDetector(
        onTap: () => setState(() => _selectedWorker = worker),
        child: AnimatedBuilder(
          animation: _dotAnimController,
          builder: (context, child) {
            final color = _getJobColor(worker.currentJobType);
            return Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.2),
              ),
              child: Center(
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.4 + _dotAnimController.value * 0.3),
                        blurRadius: 6 + _dotAnimController.value * 4,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMapFilter(String label, String value) {
    final isActive = _jobFilter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: GestureDetector(
        onTap: () => setState(() => _jobFilter = value),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryGreen.withValues(alpha: 0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isActive ? AppColors.primaryGreen : AppColors.darkBorder,
            ),
          ),
          child: Text(label, style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isActive ? AppColors.primaryGreen : AppColors.textSecondary,
          )),
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 6),
          Text(label, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildWorkerInfoPanel(WorkerModel worker) {
    return EcoCard(
      glow: true,
      padding: const EdgeInsets.all(20),
      width: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Worker Info', style: GoogleFonts.outfit(
                fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
              )),
              GestureDetector(
                onTap: () => setState(() => _selectedWorker = null),
                child: const Icon(Icons.close, size: 18, color: AppColors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.deepForest,
                child: Text(worker.name.substring(0, 1), style: GoogleFonts.outfit(
                  color: AppColors.neonGreen, fontWeight: FontWeight.w700, fontSize: 18,
                )),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(worker.name, style: GoogleFonts.inter(
                      fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
                    )),
                    RoleChip(role: worker.role),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          StatusBadge(status: worker.status),
          const SizedBox(height: 12),
          _infoRow('Current Job', worker.currentJobType ?? 'None'),
          _infoRow('District', worker.district),
          _infoRow('Today Earnings', '₹${worker.todayEarnings.toStringAsFixed(0)}'),
          _infoRow('Jobs Done', '${worker.jobsCompleted}'),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              child: const Text('Track Route'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted)),
          Text(value, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.darkBorder.withValues(alpha: 0.3)
      ..strokeWidth = 0.5;

    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
