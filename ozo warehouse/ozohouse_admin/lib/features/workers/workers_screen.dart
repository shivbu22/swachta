import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/colors.dart';
import '../../core/models/worker_model.dart';
import '../../core/services/mock_data_service.dart';
import '../../shared/widgets/shared_widgets.dart';
import '../../shared/utils/formatters.dart';

class WorkersScreen extends StatefulWidget {
  const WorkersScreen({super.key});

  @override
  State<WorkersScreen> createState() => _WorkersScreenState();
}

class _WorkersScreenState extends State<WorkersScreen> {
  late List<WorkerModel> _workers;
  late List<WorkerModel> _filteredWorkers;
  String _searchQuery = '';
  String _statusFilter = 'all';
  String _roleFilter = 'all';
  String _sortBy = 'name';
  bool _sortAsc = true;
  int _currentPage = 0;
  static const int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _workers = MockDataService.generateWorkers(count: 30);
    _applyFilters();
  }

  void _applyFilters() {
    var list = List<WorkerModel>.from(_workers);

    if (_searchQuery.isNotEmpty) {
      list = list.where((w) => w.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    if (_statusFilter != 'all') {
      list = list.where((w) => w.status == _statusFilter).toList();
    }
    if (_roleFilter != 'all') {
      list = list.where((w) => w.role == _roleFilter).toList();
    }

    list.sort((a, b) {
      int compare;
      switch (_sortBy) {
        case 'earnings':
          compare = a.todayEarnings.compareTo(b.todayEarnings);
          break;
        case 'rating':
          compare = a.rating.compareTo(b.rating);
          break;
        case 'status':
          compare = a.status.compareTo(b.status);
          break;
        default:
          compare = a.name.compareTo(b.name);
      }
      return _sortAsc ? compare : -compare;
    });

    setState(() {
      _filteredWorkers = list;
      _currentPage = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pageWorkers = _filteredWorkers
        .skip(_currentPage * _pageSize)
        .take(_pageSize)
        .toList();
    final totalPages = (_filteredWorkers.length / _pageSize).ceil();

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
                  Text('Workers Management', style: GoogleFonts.outfit(
                    fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
                  )),
                  const SizedBox(height: 4),
                  Text('${_filteredWorkers.length} workers found', style: GoogleFonts.inter(
                    fontSize: 13, color: AppColors.textMuted,
                  )),
                ],
              ),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.file_download, size: 18),
                    label: const Text('Export CSV'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add Worker'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Search & Filters
          EcoCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    onChanged: (v) {
                      _searchQuery = v;
                      _applyFilters();
                    },
                    style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Search workers by name...',
                      prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.textMuted),
                      filled: true,
                      fillColor: AppColors.darkBackground,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _buildFilterChip('Status', _statusFilter, ['all', 'online', 'on_job', 'break', 'offline'],
                    (v) { _statusFilter = v; _applyFilters(); }),
                const SizedBox(width: 8),
                _buildFilterChip('Role', _roleFilter, ['all', 'collector', 'driver', 'sorter'],
                    (v) { _roleFilter = v; _applyFilters(); }),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Table
          EcoCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                // Table header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppColors.darkBorder)),
                  ),
                  child: Row(
                    children: [
                      _buildTableHeader('Worker', 'name', flex: 3),
                      _buildTableHeader('Role', 'role', flex: 2),
                      _buildTableHeader('Status', 'status', flex: 2),
                      _buildTableHeader('Earnings', 'earnings', flex: 2),
                      _buildTableHeader('Rating', 'rating', flex: 2),
                      const SizedBox(width: 100), // Actions column
                    ],
                  ),
                ),
                // Table rows
                ...pageWorkers.map((w) => _buildWorkerRow(w)),
                // Pagination
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: AppColors.darkBorder)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Showing ${_currentPage * _pageSize + 1}-${((_currentPage + 1) * _pageSize).clamp(0, _filteredWorkers.length)} of ${_filteredWorkers.length}',
                        style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: _currentPage > 0 ? () => setState(() => _currentPage--) : null,
                            icon: const Icon(Icons.chevron_left, size: 20),
                            color: AppColors.textSecondary,
                          ),
                          ...List.generate(totalPages.clamp(0, 5), (i) {
                            return GestureDetector(
                              onTap: () => setState(() => _currentPage = i),
                              child: Container(
                                width: 32,
                                height: 32,
                                margin: const EdgeInsets.symmetric(horizontal: 2),
                                decoration: BoxDecoration(
                                  color: i == _currentPage
                                      ? AppColors.primaryGreen
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    '${i + 1}',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: i == _currentPage
                                          ? Colors.white
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                          IconButton(
                            onPressed: _currentPage < totalPages - 1
                                ? () => setState(() => _currentPage++)
                                : null,
                            icon: const Icon(Icons.chevron_right, size: 20),
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(String label, String sortKey, {int flex = 1}) {
    final isActive = _sortBy == sortKey;
    return Expanded(
      flex: flex,
      child: GestureDetector(
        onTap: () {
          if (_sortBy == sortKey) {
            _sortAsc = !_sortAsc;
          } else {
            _sortBy = sortKey;
            _sortAsc = true;
          }
          _applyFilters();
        },
        child: Row(
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isActive ? AppColors.primaryGreen : AppColors.textMuted,
                letterSpacing: 0.5,
              ),
            ),
            if (isActive)
              Icon(
                _sortAsc ? Icons.arrow_upward : Icons.arrow_downward,
                size: 14,
                color: AppColors.primaryGreen,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkerRow(WorkerModel worker) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.darkBorder, width: 0.5)),
      ),
      child: Row(
        children: [
          // Name + Avatar
          Expanded(
            flex: 3,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.deepForest,
                  child: Text(
                    worker.name.substring(0, 1),
                    style: GoogleFonts.outfit(
                      color: AppColors.neonGreen,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(worker.name, style: GoogleFonts.inter(
                      fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
                    )),
                    Text(worker.district, style: GoogleFonts.inter(
                      fontSize: 11, color: AppColors.textMuted,
                    )),
                  ],
                ),
              ],
            ),
          ),
          // Role
          Expanded(flex: 2, child: RoleChip(role: worker.role)),
          // Status
          Expanded(flex: 2, child: StatusBadge(status: worker.status)),
          // Earnings
          Expanded(
            flex: 2,
            child: Text(
              AppFormatters.currency(worker.todayEarnings),
              style: GoogleFonts.inter(
                fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
              ),
            ),
          ),
          // Rating
          Expanded(
            flex: 2,
            child: Row(
              children: List.generate(5, (i) => Icon(
                i < worker.rating.round() ? Icons.star : Icons.star_border,
                size: 16,
                color: i < worker.rating.round() ? AppColors.primaryGreen : AppColors.textMuted,
              )),
            ),
          ),
          // Actions
          SizedBox(
            width: 100,
            child: OutlinedButton(
              onPressed: () => _showWorkerProfile(worker),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                side: const BorderSide(color: AppColors.darkBorder),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('View', style: GoogleFonts.inter(
                fontSize: 12, color: AppColors.textSecondary,
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String current, List<String> options, Function(String) onChanged) {
    return PopupMenuButton<String>(
      onSelected: onChanged,
      offset: const Offset(0, 40),
      color: AppColors.darkSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.darkBorder),
      ),
      itemBuilder: (context) => options.map((opt) => PopupMenuItem(
        value: opt,
        child: Text(
          opt == 'all' ? 'All ${label}s' : opt[0].toUpperCase() + opt.substring(1).replaceAll('_', ' '),
          style: GoogleFonts.inter(
            fontSize: 13,
            color: opt == current ? AppColors.primaryGreen : AppColors.textPrimary,
            fontWeight: opt == current ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      )).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.darkBackground,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: current != 'all' ? AppColors.primaryGreen : AppColors.darkBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              current == 'all' ? label : current[0].toUpperCase() + current.substring(1).replaceAll('_', ' '),
              style: GoogleFonts.inter(
                fontSize: 13,
                color: current != 'all' ? AppColors.primaryGreen : AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down, size: 18,
              color: current != 'all' ? AppColors.primaryGreen : AppColors.textMuted),
          ],
        ),
      ),
    );
  }

  void _showWorkerProfile(WorkerModel worker) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppColors.darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.darkBorder),
        ),
        child: Container(
          width: 480,
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Worker Profile', style: GoogleFonts.outfit(
                    fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
                  )),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: AppColors.textMuted, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 36,
                backgroundColor: AppColors.deepForest,
                child: Text(worker.name.substring(0, 1), style: GoogleFonts.outfit(
                  fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.neonGreen,
                )),
              ),
              const SizedBox(height: 12),
              Text(worker.name, style: GoogleFonts.outfit(
                fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
              )),
              const SizedBox(height: 4),
              RoleChip(role: worker.role),
              const SizedBox(height: 16),
              StatusBadge(status: worker.status),
              const SizedBox(height: 20),
              const Divider(color: AppColors.darkBorder),
              const SizedBox(height: 16),
              _profileRow('District', worker.district),
              _profileRow('Phone', worker.phone),
              _profileRow('Today\'s Earnings', AppFormatters.currency(worker.todayEarnings)),
              _profileRow('Jobs Completed', '${worker.jobsCompleted}'),
              _profileRow('Rating', '${worker.rating.toStringAsFixed(1)} / 5.0'),
              _profileRow('Last Seen', worker.lastSeen != null ? AppFormatters.timeAgo(worker.lastSeen!) : 'N/A'),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.phone, size: 16),
                      label: const Text('Call'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.message, size: 16),
                      label: const Text('Message'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.swap_horiz, size: 16),
                      label: const Text('Reassign'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted)),
          Text(value, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}
