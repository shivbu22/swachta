class WarehouseModel {
  final String id;
  final String name;
  final String location;
  final double maxCapacityKg;
  final double currentKg;
  final double todayRevenue;
  final String topMaterial;
  final double topMaterialKg;
  final String status;
  final DateTime createdAt;

  WarehouseModel({
    required this.id,
    required this.name,
    this.location = '',
    this.maxCapacityKg = 5000,
    this.currentKg = 0,
    this.todayRevenue = 0,
    this.topMaterial = '',
    this.topMaterialKg = 0,
    this.status = 'operational',
    required this.createdAt,
  });

  double get capacityPercentage =>
      maxCapacityKg > 0 ? (currentKg / maxCapacityKg * 100).clamp(0, 100) : 0;

  factory WarehouseModel.fromJson(Map<String, dynamic> json) {
    return WarehouseModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      maxCapacityKg: (json['max_capacity_kg'] ?? 5000).toDouble(),
      currentKg: (json['current_kg'] ?? 0).toDouble(),
      todayRevenue: (json['today_revenue'] ?? 0).toDouble(),
      topMaterial: json['top_material'] ?? '',
      topMaterialKg: (json['top_material_kg'] ?? 0).toDouble(),
      status: json['status'] ?? 'operational',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'location': location,
    'max_capacity_kg': maxCapacityKg,
    'current_kg': currentKg,
    'today_revenue': todayRevenue,
    'top_material': topMaterial,
    'top_material_kg': topMaterialKg,
    'status': status,
    'created_at': createdAt.toIso8601String(),
  };
}

class JobModel {
  final String id;
  final String workerId;
  final String jobType;
  final String wasteType;
  final double wasteKg;
  final String status;
  final String district;
  final double earnings;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime createdAt;

  JobModel({
    required this.id,
    required this.workerId,
    required this.jobType,
    this.wasteType = '',
    this.wasteKg = 0,
    this.status = 'pending',
    this.district = '',
    this.earnings = 0,
    this.startedAt,
    this.completedAt,
    required this.createdAt,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'] ?? '',
      workerId: json['worker_id'] ?? '',
      jobType: json['job_type'] ?? '',
      wasteType: json['waste_type'] ?? '',
      wasteKg: (json['waste_kg'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
      district: json['district'] ?? '',
      earnings: (json['earnings'] ?? 0).toDouble(),
      startedAt: json['started_at'] != null ? DateTime.parse(json['started_at']) : null,
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at']) : null,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'worker_id': workerId,
    'job_type': jobType,
    'waste_type': wasteType,
    'waste_kg': wasteKg,
    'status': status,
    'district': district,
    'earnings': earnings,
    'started_at': startedAt?.toIso8601String(),
    'completed_at': completedAt?.toIso8601String(),
    'created_at': createdAt.toIso8601String(),
  };
}

class MetricModel {
  final int activeWorkers;
  final int jobsCompleted;
  final double wasteCollectedKg;
  final double revenue;
  final double activeWorkersChange;
  final double jobsChange;
  final double wasteChange;
  final double revenueChange;

  MetricModel({
    this.activeWorkers = 0,
    this.jobsCompleted = 0,
    this.wasteCollectedKg = 0,
    this.revenue = 0,
    this.activeWorkersChange = 0,
    this.jobsChange = 0,
    this.wasteChange = 0,
    this.revenueChange = 0,
  });

  factory MetricModel.fromJson(Map<String, dynamic> json) {
    return MetricModel(
      activeWorkers: json['active_workers'] ?? 0,
      jobsCompleted: json['jobs_completed'] ?? 0,
      wasteCollectedKg: (json['waste_collected_kg'] ?? 0).toDouble(),
      revenue: (json['revenue'] ?? 0).toDouble(),
      activeWorkersChange: (json['active_workers_change'] ?? 0).toDouble(),
      jobsChange: (json['jobs_change'] ?? 0).toDouble(),
      wasteChange: (json['waste_change'] ?? 0).toDouble(),
      revenueChange: (json['revenue_change'] ?? 0).toDouble(),
    );
  }
}

class ActivityItem {
  final String id;
  final String type;
  final String message;
  final String? workerName;
  final DateTime timestamp;

  ActivityItem({
    required this.id,
    required this.type,
    required this.message,
    this.workerName,
    required this.timestamp,
  });
}

class AiInsight {
  final String id;
  final String type;
  final String title;
  final String description;
  final String severity;
  final double? value;
  final DateTime createdAt;

  AiInsight({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    this.severity = 'info',
    this.value,
    required this.createdAt,
  });
}

class WasteDataPoint {
  final String wasteType;
  final double amount;

  WasteDataPoint({required this.wasteType, required this.amount});
}

class RevenueDataPoint {
  final DateTime date;
  final double amount;

  RevenueDataPoint({required this.date, required this.amount});
}

// ─── NEW MODELS FOR EXPANSION ───

class VehicleModel {
  final String id;
  final String registrationNumber;
  final String type; // compactor, trike, truck
  final String status; // active, idle, maintenance
  final double currentFuelPct;
  final double totalDistanceKm;
  final DateTime nextServiceDate;
  
  VehicleModel({
    required this.id,
    required this.registrationNumber,
    required this.type,
    required this.status,
    this.currentFuelPct = 100,
    this.totalDistanceKm = 0,
    required this.nextServiceDate,
  });
}

class ComplaintModel {
  final String id;
  final String citizenName;
  final String category; // missed_pickup, staff, etc
  final String summary;
  final String status; // new, in_progress, resolved
  final String priority; // low, medium, high
  final DateTime createdAt;
  
  ComplaintModel({
    required this.id,
    required this.citizenName,
    required this.category,
    required this.summary,
    required this.status,
    required this.priority,
    required this.createdAt,
  });
}

class InvoiceModel {
  final String id;
  final String clientName;
  final double amount;
  final String status; // paid, pending, overdue
  final DateTime dueDate;
  final String gstNumber;
  
  InvoiceModel({
    required this.id,
    required this.clientName,
    required this.amount,
    required this.status,
    required this.dueDate,
    this.gstNumber = '',
  });
}

class ShiftModel {
  final String id;
  final String title;
  final String startTime;
  final String endTime;
  final int assignedWorkers;
  final int requiredWorkers;
  
  ShiftModel({
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.assignedWorkers,
    required this.requiredWorkers,
  });
}

class AnnouncementModel {
  final String id;
  final String title;
  final String content;
  final String targetAudience; // all, workers, citizens
  final DateTime publishedAt;
  
  AnnouncementModel({
    required this.id,
    required this.title,
    required this.content,
    required this.targetAudience,
    required this.publishedAt,
  });
}

class AttendanceRecord {
  final String id;
  final String workerId;
  final DateTime date;
  final String status; // present, absent, half_day, leave
  final DateTime? checkIn;
  final DateTime? checkOut;
  
  AttendanceRecord({
    required this.id,
    required this.workerId,
    required this.date,
    required this.status,
    this.checkIn,
    this.checkOut,
  });
}

class ExpenseModel {
  final String id;
  final String category;
  final double amount;
  final String description;
  final DateTime date;
  
  ExpenseModel({
    required this.id,
    required this.category,
    required this.amount,
    required this.description,
    required this.date,
  });
}

class AuditLogEntry {
  final String id;
  final String adminId;
  final String adminName;
  final String action;
  final String details;
  final DateTime timestamp;
  
  AuditLogEntry({
    required this.id,
    required this.adminId,
    required this.adminName,
    required this.action,
    required this.details,
    required this.timestamp,
  });
}
