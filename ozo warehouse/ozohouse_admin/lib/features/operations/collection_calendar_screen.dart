import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/colors.dart';

class CollectionCalendarScreen extends StatefulWidget {
  const CollectionCalendarScreen({super.key});
  @override
  State<CollectionCalendarScreen> createState() => _CollectionCalendarScreenState();
}

class _CollectionCalendarScreenState extends State<CollectionCalendarScreen> {
  int _selectedDay = DateTime.now().day;

  final _daysInMonth = 30;
  final _events = {
    3: [{'type': 'pickup', 'label': 'Plastic Drive - Zone A'}],
    7: [{'type': 'hazardous', 'label': 'Hazardous Waste Collection'}],
    10: [{'type': 'pickup', 'label': 'Paper/Cardboard Day'}, {'type': 'event', 'label': 'SBM Audit Due'}],
    14: [{'type': 'pickup', 'label': 'Metal & Glass Pickup'}],
    15: [{'type': 'holiday', 'label': 'Municipal Holiday'}],
    18: [{'type': 'bulk', 'label': 'Bulk Waste Collection'}],
    21: [{'type': 'pickup', 'label': 'E-waste Collection Day'}],
    25: [{'type': 'event', 'label': 'CPCB Report Due'}, {'type': 'pickup', 'label': 'Full City Sweep'}],
    28: [{'type': 'pickup', 'label': 'Organic Waste Special'}],
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text('Collection Calendar', style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const Spacer(),
          _legendChip('Pickup', AppColors.primaryGreen),
          _legendChip('Hazardous', AppColors.errorRed),
          _legendChip('Bulk', AppColors.warningAmber),
          _legendChip('Event', AppColors.infoCyan),
          _legendChip('Holiday', AppColors.statusBreak),
        ]),
        const SizedBox(height: 16),
        Expanded(child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(flex: 3, child: _buildCalendar()),
          const SizedBox(width: 16),
          Expanded(flex: 2, child: _buildDayDetail()),
        ])),
      ]),
    );
  }

  Widget _legendChip(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 4),
        Text(label, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary)),
      ]),
    );
  }

  Widget _buildCalendar() {
    return Container(
      decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
      child: Column(children: [
        Padding(padding: const EdgeInsets.all(20), child: Row(children: [
          IconButton(icon: const Icon(Icons.chevron_left, color: AppColors.textSecondary), onPressed: () {}),
          Text('April 2026', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          IconButton(icon: const Icon(Icons.chevron_right, color: AppColors.textSecondary), onPressed: () {}),
        ])),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Row(
          children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].map((d) =>
            Expanded(child: Center(child: Text(d, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMuted))))).toList(),
        )),
        const SizedBox(height: 8),
        Expanded(child: GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, childAspectRatio: 1.1),
          itemCount: 35,
          itemBuilder: (_, i) {
            final day = i - 1; // offset for start day
            if (day < 1 || day > _daysInMonth) return const SizedBox.shrink();
            final hasEvent = _events.containsKey(day);
            final isSelected = _selectedDay == day;
            final isToday = day == DateTime.now().day;
            return GestureDetector(
              onTap: () => setState(() => _selectedDay = day),
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryGreen.withValues(alpha: 0.15) : isToday ? AppColors.darkSurface : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: isSelected ? Border.all(color: AppColors.primaryGreen) : isToday ? Border.all(color: AppColors.darkBorder) : null,
                ),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('$day', style: GoogleFonts.inter(fontSize: 14, fontWeight: isToday ? FontWeight.w700 : FontWeight.w500, color: isSelected ? AppColors.primaryGreen : AppColors.textPrimary)),
                  if (hasEvent) ...[
                    const SizedBox(height: 2),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: _events[day]!.map((e) {
                      final c = {'pickup': AppColors.primaryGreen, 'hazardous': AppColors.errorRed, 'bulk': AppColors.warningAmber, 'event': AppColors.infoCyan, 'holiday': AppColors.statusBreak};
                      return Container(width: 5, height: 5, margin: const EdgeInsets.symmetric(horizontal: 1), decoration: BoxDecoration(shape: BoxShape.circle, color: c[e['type']] ?? AppColors.textMuted));
                    }).toList()),
                  ],
                ]),
              ),
            );
          },
        )),
      ]),
    );
  }

  Widget _buildDayDetail() {
    final dayEvents = _events[_selectedDay] ?? [];
    return Container(
      decoration: BoxDecoration(color: AppColors.darkCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkBorder)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('April $_selectedDay, 2026', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          Text(dayEvents.isEmpty ? 'No events scheduled' : '${dayEvents.length} event${dayEvents.length > 1 ? 's' : ''} scheduled', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary)),
        ])),
        const Divider(color: AppColors.darkBorder, height: 1),
        Expanded(child: dayEvents.isEmpty
          ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.event_available, size: 48, color: AppColors.textMuted.withValues(alpha: 0.3)),
              const SizedBox(height: 12),
              Text('No events for this day', style: GoogleFonts.inter(fontSize: 14, color: AppColors.textMuted)),
            ]))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: dayEvents.length,
              itemBuilder: (_, i) {
                final e = dayEvents[i];
                final c = {'pickup': AppColors.primaryGreen, 'hazardous': AppColors.errorRed, 'bulk': AppColors.warningAmber, 'event': AppColors.infoCyan, 'holiday': AppColors.statusBreak};
                final ic = {'pickup': Icons.recycling, 'hazardous': Icons.warning, 'bulk': Icons.inventory_2, 'event': Icons.event, 'holiday': Icons.celebration};
                final color = c[e['type']] ?? AppColors.textMuted;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withValues(alpha: 0.2))),
                  child: Row(children: [
                    Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                      child: Icon(ic[e['type']] ?? Icons.event, size: 20, color: color)),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(e['label']!, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      Text('${e['type']![0].toUpperCase()}${e['type']!.substring(1)} • All Day', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
                    ])),
                  ]),
                );
              },
            ),
        ),
      ]),
    );
  }
}
