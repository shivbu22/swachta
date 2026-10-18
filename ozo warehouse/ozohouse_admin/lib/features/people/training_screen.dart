import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/colors.dart';

class TrainingScreen extends StatelessWidget {
  const TrainingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final modules = [
      {'title': 'Hazardous Waste Handling', 'type': 'Certification', 'duration': '4 hours', 'enrolled': 45, 'completed': 38, 'icon': Icons.warning_amber},
      {'title': 'PPE Safety Protocol', 'type': 'Mandatory', 'duration': '2 hours', 'enrolled': 120, 'completed': 112, 'icon': Icons.health_and_safety},
      {'title': 'Vehicle Operation Training', 'type': 'Certification', 'duration': '8 hours', 'enrolled': 30, 'completed': 22, 'icon': Icons.local_shipping},
      {'title': 'First Aid Basics', 'type': 'Mandatory', 'duration': '3 hours', 'enrolled': 120, 'completed': 95, 'icon': Icons.medical_services},
      {'title': 'Customer Interaction', 'type': 'Optional', 'duration': '1.5 hours', 'enrolled': 60, 'completed': 48, 'icon': Icons.people},
      {'title': 'Waste Segregation Techniques', 'type': 'Mandatory', 'duration': '2 hours', 'enrolled': 120, 'completed': 105, 'icon': Icons.recycling},
    ];
    return Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Training & Certifications', style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      const SizedBox(height: 16),
      Expanded(child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 1.6),
        itemCount: modules.length,
        itemBuilder: (_, i) {
          final m = modules[i];
          final pct = (m['completed'] as int) / (m['enrolled'] as int);
          final color = m['type'] == 'Mandatory' ? AppColors.errorRed : m['type'] == 'Certification' ? AppColors.warningAmber : AppColors.infoCyan;
          return Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                  child: Icon(m['icon'] as IconData, size: 22, color: AppColors.primaryGreen)),
                const Spacer(),
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                  child: Text(m['type'] as String, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: color))),
              ]),
              const Spacer(),
              Text(m['title'] as String, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              Text('${m['duration']} • ${m['enrolled']} enrolled', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: pct, backgroundColor: AppColors.darkBorder, color: AppColors.primaryGreen, minHeight: 6))),
                const SizedBox(width: 8),
                Text('${(pct*100).toInt()}%', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryGreen)),
              ]),
            ]));
        },
      )),
    ]));
  }
}
