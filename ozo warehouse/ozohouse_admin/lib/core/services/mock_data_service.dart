import 'dart:math';

import '../models/worker_model.dart';
import '../models/models.dart';

/// Mock data service that generates realistic demo data.
/// Replace with Supabase calls when credentials are configured.
class MockDataService {
  static final _random = Random(42);

  static final List<String> _indianNames = [
    'Rajesh Kumar', 'Suresh Patil', 'Amit Sharma', 'Deepak Singh',
    'Vikram Joshi', 'Manoj Gupta', 'Ramesh Yadav', 'Sunil Verma',
    'Anil Mishra', 'Prakash Das', 'Sanjay Thakur', 'Ravi Mehta',
    'Kiran Kumari', 'Priya Devi', 'Sunita Bai', 'Lakshmi Naik',
    'Geeta Patel', 'Meena Rathi', 'Anita Chauhan', 'Pooja Tiwari',
    'Mukesh Agarwal', 'Dinesh Pandey', 'Ashok Nair', 'Govind Sahu',
    'Naveen Reddy', 'Santosh Pillai', 'Mahesh Raut', 'Yogesh Deshmukh',
    'Arjun Menon', 'Vishal Hegde',
  ];

  static final List<String> _roles = ['collector', 'driver', 'sorter'];
  static final List<String> _statuses = ['online', 'on_job', 'break', 'offline'];
  static final List<String> _districts = [
    'Zone A - Central', 'Zone B - North', 'Zone C - South',
    'Zone D - East', 'Zone E - West',
  ];
  static final List<String> _jobTypes = ['pickup', 'sorting', 'transport', 'idle'];
  // ignore: unused_field
  static final List<String> _wasteTypes = ['plastic', 'metal', 'organic', 'ewaste', 'glass'];
  static final List<String> _materials = [
    'PET Plastic', 'HDPE Plastic', 'Aluminum', 'Steel',
    'Copper Wire', 'Glass Bottles', 'Cardboard', 'E-Waste',
  ];

  static List<WorkerModel> generateWorkers({int count = 30}) {
    return List.generate(count, (i) {
      final status = _statuses[_random.nextInt(_statuses.length)];
      return WorkerModel(
        id: 'worker_$i',
        name: _indianNames[i % _indianNames.length],
        role: _roles[_random.nextInt(_roles.length)],
        phone: '+91 ${_random.nextInt(90000) + 70000} ${_random.nextInt(90000) + 10000}',
        status: status,
        rating: (3.0 + _random.nextDouble() * 2).clamp(1.0, 5.0),
        district: _districts[_random.nextInt(_districts.length)],
        todayEarnings: (_random.nextDouble() * 800 + 200).roundToDouble(),
        jobsCompleted: _random.nextInt(12) + 1,
        latitude: 19.0760 + (_random.nextDouble() - 0.5) * 0.1,
        longitude: 72.8777 + (_random.nextDouble() - 0.5) * 0.1,
        currentJobType: status == 'on_job'
            ? _jobTypes[_random.nextInt(3)]
            : (status == 'online' ? 'idle' : null),
        lastSeen: DateTime.now().subtract(Duration(minutes: _random.nextInt(120))),
        createdAt: DateTime.now().subtract(Duration(days: _random.nextInt(365))),
      );
    });
  }

  static MetricModel generateMetrics() {
    return MetricModel(
      activeWorkers: 847,
      jobsCompleted: 1234,
      wasteCollectedKg: 8456,
      revenue: 234500,
      activeWorkersChange: 12.5,
      jobsChange: 8.3,
      wasteChange: 15.2,
      revenueChange: 22.1,
    );
  }

  static List<WarehouseModel> generateWarehouses() {
    final warehouseNames = [
      'Alpha Hub — Andheri', 'Beta Station — Bandra',
      'Gamma Depot — Churchgate', 'Delta Center — Dadar',
      'Epsilon Yard — Goregaon', 'Zeta complex — Thane',
    ];

    return List.generate(6, (i) {
      final maxCap = (3000.0 + _random.nextDouble() * 4000).roundToDouble();
      final currentKg = (maxCap * (_random.nextDouble() * 0.6 + 0.3)).roundToDouble();
      return WarehouseModel(
        id: 'wh_$i',
        name: warehouseNames[i],
        location: warehouseNames[i].split(' — ').last,
        maxCapacityKg: maxCap,
        currentKg: currentKg,
        todayRevenue: (_random.nextDouble() * 50000 + 10000).roundToDouble(),
        topMaterial: _materials[_random.nextInt(_materials.length)],
        topMaterialKg: (_random.nextDouble() * 500 + 100).roundToDouble(),
        status: currentKg / maxCap > 0.85 ? 'near_full' : 'operational',
        createdAt: DateTime.now().subtract(Duration(days: _random.nextInt(180))),
      );
    });
  }

  static List<WasteDataPoint> generateWasteByType() {
    return [
      WasteDataPoint(wasteType: 'Plastic', amount: 2840),
      WasteDataPoint(wasteType: 'Metal', amount: 1650),
      WasteDataPoint(wasteType: 'Organic', amount: 1920),
      WasteDataPoint(wasteType: 'E-Waste', amount: 890),
      WasteDataPoint(wasteType: 'Glass', amount: 1156),
    ];
  }

  static List<RevenueDataPoint> generateRevenueHistory({int days = 30}) {
    final base = 180000.0;
    return List.generate(days, (i) {
      return RevenueDataPoint(
        date: DateTime.now().subtract(Duration(days: days - i - 1)),
        amount: base + _random.nextDouble() * 100000 + sin(i * 0.3) * 30000,
      );
    });
  }

  static List<ActivityItem> generateActivities() {
    final now = DateTime.now();
    return [
      ActivityItem(id: '1', type: 'check_in', message: 'checked in at Zone A', workerName: 'Rajesh Kumar', timestamp: now.subtract(const Duration(minutes: 2))),
      ActivityItem(id: '2', type: 'job_complete', message: 'completed plastic pickup — 45 kg', workerName: 'Suresh Patil', timestamp: now.subtract(const Duration(minutes: 5))),
      ActivityItem(id: '3', type: 'delivery', message: 'delivered 320 kg to Alpha Hub', workerName: 'Amit Sharma', timestamp: now.subtract(const Duration(minutes: 8))),
      ActivityItem(id: '4', type: 'alert', message: 'Warehouse Beta at 88% capacity', workerName: null, timestamp: now.subtract(const Duration(minutes: 12))),
      ActivityItem(id: '5', type: 'check_in', message: 'checked in at Zone C', workerName: 'Deepak Singh', timestamp: now.subtract(const Duration(minutes: 15))),
      ActivityItem(id: '6', type: 'job_complete', message: 'completed metal sorting — 28 kg', workerName: 'Kiran Kumari', timestamp: now.subtract(const Duration(minutes: 20))),
      ActivityItem(id: '7', type: 'break', message: 'started break', workerName: 'Vikram Joshi', timestamp: now.subtract(const Duration(minutes: 25))),
      ActivityItem(id: '8', type: 'job_complete', message: 'completed e-waste collection — 12 kg', workerName: 'Priya Devi', timestamp: now.subtract(const Duration(minutes: 30))),
    ];
  }

  // ─── NEW MOCK GENERATORS FOR EXPANSION ───

  static List<VehicleModel> generateVehicles({int count = 15}) {
    final types = ['compactor', 'trike', 'truck'];
    final statuses = ['active', 'active', 'active', 'idle', 'maintenance'];
    return List.generate(count, (i) {
      return VehicleModel(
        id: 'veh_$i',
        registrationNumber: 'MH 02 AB ${1000 + _random.nextInt(9000)}',
        type: types[_random.nextInt(types.length)],
        status: statuses[_random.nextInt(statuses.length)],
        currentFuelPct: (_random.nextDouble() * 80 + 20).roundToDouble(),
        totalDistanceKm: (_random.nextDouble() * 50000 + 5000).roundToDouble(),
        nextServiceDate: DateTime.now().add(Duration(days: _random.nextInt(60) - 10)),
      );
    });
  }

  static List<ComplaintModel> generateComplaints({int count = 20}) {
    final categories = ['missed_pickup', 'staff_behavior', 'overflowing_bin', 'billing'];
    final statuses = ['new', 'in_progress', 'resolved'];
    final priorities = ['low', 'medium', 'high', 'critical'];
    return List.generate(count, (i) {
      return ComplaintModel(
        id: 'cmp_$i',
        citizenName: _indianNames[_random.nextInt(_indianNames.length)],
        category: categories[_random.nextInt(categories.length)],
        summary: 'Issue regarding ${categories[_random.nextInt(categories.length)]} in zone ${_districts[_random.nextInt(_districts.length)]}',
        status: statuses[_random.nextInt(statuses.length)],
        priority: priorities[_random.nextInt(priorities.length)],
        createdAt: DateTime.now().subtract(Duration(hours: _random.nextInt(72))),
      );
    });
  }

  static List<InvoiceModel> generateInvoices({int count = 10}) {
    final statuses = ['paid', 'pending', 'overdue'];
    final clients = ['TechPark Pvt Ltd', 'Seawoods Estate', 'Green View Society', 'City Mall'];
    return List.generate(count, (i) {
      final status = statuses[_random.nextInt(statuses.length)];
      return InvoiceModel(
        id: 'inv_2026_${100 + i}',
        clientName: clients[_random.nextInt(clients.length)],
        amount: (_random.nextDouble() * 20000 + 5000).roundToDouble(),
        status: status,
        dueDate: DateTime.now().add(Duration(days: status == 'overdue' ? -_random.nextInt(15) : _random.nextInt(30))),
        gstNumber: '27AABCU9603R1Z${_random.nextInt(9)}',
      );
    });
  }
}
