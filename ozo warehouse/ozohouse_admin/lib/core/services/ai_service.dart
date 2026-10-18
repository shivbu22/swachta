import 'dart:math';
import '../models/models.dart';

/// Advanced AI/ML Service — Pure Dart algorithms for offline-first analytics.
/// Implements: Z-score anomaly detection, linear regression, K-means clustering,
/// exponential smoothing, sentiment classification, risk scoring, demand forecasting.
class AiService {
  static final _rng = Random(42);

  // ─── ANOMALY DETECTION (Z-Score) ───
  static List<String> detectAnomalies(List<double> values, {double threshold = 2.0}) {
    if (values.length < 3) return [];
    final mean = values.reduce((a, b) => a + b) / values.length;
    final variance = values.map((v) => pow(v - mean, 2)).reduce((a, b) => a + b) / values.length;
    final stdDev = sqrt(variance);
    if (stdDev == 0) return [];
    final anomalies = <String>[];
    for (int i = 0; i < values.length; i++) {
      final z = (values[i] - mean).abs() / stdDev;
      if (z > threshold) {
        anomalies.add('Index $i: value=${values[i].toStringAsFixed(1)}, z-score=${z.toStringAsFixed(2)}');
      }
    }
    return anomalies;
  }

  // ─── LINEAR REGRESSION (Revenue Prediction) ───
  static List<RevenueDataPoint> predictRevenue(List<RevenueDataPoint> history, {int days = 7}) {
    if (history.length < 5) return [];
    final n = history.length;
    double sumX = 0, sumY = 0, sumXY = 0, sumXX = 0;
    for (int i = 0; i < n; i++) {
      sumX += i;
      sumY += history[i].amount;
      sumXY += i * history[i].amount;
      sumXX += i * i;
    }
    final slope = (n * sumXY - sumX * sumY) / (n * sumXX - sumX * sumX);
    final intercept = (sumY - slope * sumX) / n;
    return List.generate(days, (i) {
      final x = n + i;
      return RevenueDataPoint(
        date: history.last.date.add(Duration(days: i + 1)),
        amount: max(0.0, intercept + slope * x + (_rng.nextDouble() - 0.5) * 5000),
      );
    });
  }

  // ─── PERFORMANCE SCORING (Weighted Composite) ───
  static double calculatePerformanceScore({
    required double completionRate,
    required double avgRating,
    required double attendanceRate,
    double punctualityRate = 0.9,
    double complaintRate = 0.05,
  }) {
    return (completionRate * 25 +
        (avgRating / 5.0) * 100 * 25 +
        attendanceRate * 100 * 20 +
        punctualityRate * 100 * 15 +
        (1 - complaintRate) * 100 * 15)
        .clamp(0, 100);
  }

  // ─── CAPACITY PREDICTION (Linear Extrapolation) ───
  static int? predictDaysToFull({
    required double currentKg,
    required double maxCapacityKg,
    required double dailyFillRate,
  }) {
    if (dailyFillRate <= 0 || currentKg >= maxCapacityKg) return null;
    return ((maxCapacityKg - currentKg) / dailyFillRate).ceil();
  }

  // ─── EFFICIENCY SCORING ───
  static double calculateEfficiency({
    required double actualCollected,
    required double expectedVolume,
  }) {
    if (expectedVolume <= 0) return 0;
    return ((actualCollected / expectedVolume) * 100).clamp(0, 100);
  }

  // ─── SMART ROUTING (Nearest Neighbor TSP) ───
  static List<int> suggestRoute(List<List<double>> coordinates) {
    if (coordinates.isEmpty) return [];
    final n = coordinates.length;
    final visited = List.filled(n, false);
    final route = <int>[0];
    visited[0] = true;
    for (int step = 1; step < n; step++) {
      final current = route.last;
      double minDist = double.infinity;
      int nearest = -1;
      for (int j = 0; j < n; j++) {
        if (visited[j]) continue;
        final dist = _haversine(
          coordinates[current][0], coordinates[current][1],
          coordinates[j][0], coordinates[j][1],
        );
        if (dist < minDist) {
          minDist = dist;
          nearest = j;
        }
      }
      if (nearest != -1) {
        visited[nearest] = true;
        route.add(nearest);
      }
    }
    return route;
  }

  static double _haversine(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371.0;
    final dLat = _toRad(lat2 - lat1);
    final dLon = _toRad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRad(lat1)) * cos(_toRad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    return R * 2 * atan2(sqrt(a), sqrt(1 - a));
  }

  static double _toRad(double deg) => deg * pi / 180;

  // ═══════════════════════════════════════════════════════════
  //  NEW AI/ML ALGORITHMS
  // ═══════════════════════════════════════════════════════════

  // ─── EXPONENTIAL SMOOTHING (Holt-Winters style forecast) ───
  static List<double> exponentialSmoothing(List<double> data, {double alpha = 0.3, double beta = 0.1, int forecast = 7}) {
    if (data.length < 3) return List.filled(forecast, data.isEmpty ? 0 : data.last);
    double level = data[0];
    double trend = data[1] - data[0];
    final smoothed = <double>[];
    for (final value in data) {
      final prevLevel = level;
      level = alpha * value + (1 - alpha) * (level + trend);
      trend = beta * (level - prevLevel) + (1 - beta) * trend;
      smoothed.add(level + trend);
    }
    final predictions = <double>[];
    for (int i = 1; i <= forecast; i++) {
      predictions.add(max(0.0, level + trend * i));
    }
    return predictions;
  }

  // ─── K-MEANS CLUSTERING (Zone optimization) ───
  static List<int> kMeansCluster(List<List<double>> points, int k, {int maxIter = 100}) {
    if (points.isEmpty || k <= 0) return [];
    final n = points.length;
    final dim = points[0].length;
    k = min(k, n);

    // Initialize centroids from first k points
    final centroids = List.generate(k, (i) => List<double>.from(points[i % n]));
    var labels = List.filled(n, 0);

    for (int iter = 0; iter < maxIter; iter++) {
      // Assign labels
      final newLabels = List.generate(n, (i) {
        double minDist = double.infinity;
        int best = 0;
        for (int c = 0; c < k; c++) {
          double dist = 0;
          for (int d = 0; d < dim; d++) {
            dist += pow(points[i][d] - centroids[c][d], 2);
          }
          if (dist < minDist) {
            minDist = dist;
            best = c;
          }
        }
        return best;
      });

      // Check convergence
      bool converged = true;
      for (int i = 0; i < n; i++) {
        if (newLabels[i] != labels[i]) {
          converged = true;
          break;
        }
      }
      labels = newLabels;

      // Update centroids
      for (int c = 0; c < k; c++) {
        final members = <int>[];
        for (int i = 0; i < n; i++) {
          if (labels[i] == c) members.add(i);
        }
        if (members.isEmpty) continue;
        for (int d = 0; d < dim; d++) {
          centroids[c][d] = members.map((i) => points[i][d]).reduce((a, b) => a + b) / members.length;
        }
      }

      if (converged && iter > 0) break;
    }
    return labels;
  }

  // ─── SENTIMENT ANALYSIS (Rule-based NLP) ───
  static SentimentResult analyzeSentiment(String text) {
    final lower = text.toLowerCase();

    const positiveWords = [
      'good', 'great', 'excellent', 'happy', 'satisfied', 'clean', 'prompt',
      'quick', 'efficient', 'helpful', 'nice', 'best', 'amazing', 'wonderful',
      'perfect', 'timely', 'professional', 'thank', 'appreciate', 'reliable',
      'acha', 'bahut', 'sahi', 'dhanyavaad', 'sundar', 'saaf',
    ];
    const negativeWords = [
      'bad', 'terrible', 'horrible', 'dirty', 'late', 'slow', 'rude',
      'complaint', 'garbage', 'stink', 'missed', 'never', 'worst', 'awful',
      'delay', 'ignored', 'waste', 'useless', 'pathetic', 'disgusting',
      'kharab', 'ganda', 'bura', 'galat', 'dheela',
    ];

    int posCount = 0, negCount = 0;
    for (final w in positiveWords) {
      if (lower.contains(w)) posCount++;
    }
    for (final w in negativeWords) {
      if (lower.contains(w)) negCount++;
    }

    final total = posCount + negCount;
    if (total == 0) return SentimentResult(score: 0.5, label: 'neutral', confidence: 0.3);

    final score = posCount / total;
    String label;
    if (score > 0.65) {
      label = 'positive';
    } else if (score < 0.35) {
      label = 'negative';
    } else {
      label = 'neutral';
    }
    return SentimentResult(score: score, label: label, confidence: min(0.95, total * 0.15));
  }

  // ─── WORKER RISK SCORING (Classification) ───
  static WorkerRiskScore calculateWorkerRisk({
    required double attendanceRate,
    required double avgRating,
    required int complaintCount,
    required int lateCount,
    required int totalDays,
  }) {
    double riskScore = 0;

    // Attendance risk (weight: 30%)
    if (attendanceRate < 0.7) {
      riskScore += 30;
    } else if (attendanceRate < 0.85) {
      riskScore += 15;
    }

    // Rating risk (weight: 25%)
    if (avgRating < 2.5) {
      riskScore += 25;
    } else if (avgRating < 3.5) {
      riskScore += 12;
    }

    // Complaint risk (weight: 25%)
    final complaintRate = totalDays > 0 ? complaintCount / totalDays : 0;
    if (complaintRate > 0.1) {
      riskScore += 25;
    } else if (complaintRate > 0.05) {
      riskScore += 12;
    }

    // Punctuality risk (weight: 20%)
    final lateRate = totalDays > 0 ? lateCount / totalDays : 0;
    if (lateRate > 0.2) {
      riskScore += 20;
    } else if (lateRate > 0.1) {
      riskScore += 10;
    }

    String category;
    if (riskScore >= 60) {
      category = 'high';
    } else if (riskScore >= 30) {
      category = 'medium';
    } else {
      category = 'low';
    }

    return WorkerRiskScore(score: riskScore, category: category);
  }

  // ─── DEMAND FORECASTING (ARIMA-style) ───
  static List<ForecastPoint> forecastDemand(List<double> historicalData, {int horizon = 30}) {
    if (historicalData.length < 7) {
      return List.generate(horizon, (i) => ForecastPoint(
        day: i + 1,
        predicted: historicalData.isEmpty ? 0 : historicalData.last,
        lowerBound: 0,
        upperBound: historicalData.isEmpty ? 0 : historicalData.last * 1.5,
      ));
    }

    // Calculate trend via linear regression
    final n = historicalData.length;
    double sumX = 0, sumY = 0, sumXY = 0, sumXX = 0;
    for (int i = 0; i < n; i++) {
      sumX += i;
      sumY += historicalData[i];
      sumXY += i * historicalData[i];
      sumXX += i * i;
    }
    final slope = (n * sumXY - sumX * sumY) / (n * sumXX - sumX * sumX);
    final intercept = (sumY - slope * sumX) / n;

    // Calculate seasonality (7-day cycle)
    final seasonal = List.filled(7, 0.0);
    final counts = List.filled(7, 0);
    for (int i = 0; i < n; i++) {
      final detrended = historicalData[i] - (intercept + slope * i);
      seasonal[i % 7] += detrended;
      counts[i % 7]++;
    }
    for (int i = 0; i < 7; i++) {
      if (counts[i] > 0) seasonal[i] /= counts[i];
    }

    // Calculate residual stddev for confidence intervals
    double residualSum = 0;
    for (int i = 0; i < n; i++) {
      final predicted = intercept + slope * i + seasonal[i % 7];
      residualSum += pow(historicalData[i] - predicted, 2);
    }
    final stdErr = sqrt(residualSum / n);

    return List.generate(horizon, (i) {
      final x = n + i;
      final predicted = max(0.0, intercept + slope * x + seasonal[x % 7]);
      return ForecastPoint(
        day: i + 1,
        predicted: predicted,
        lowerBound: max(0.0, predicted - 1.96 * stdErr),
        upperBound: predicted + 1.96 * stdErr,
      );
    });
  }

  // ─── ROUTE OPTIMIZATION (2-opt improvement) ───
  static RouteOptimizationResult optimizeRoute(List<List<double>> coords) {
    if (coords.length < 3) {
      return RouteOptimizationResult(
        optimizedOrder: List.generate(coords.length, (i) => i),
        distanceSaved: 0,
        originalDistance: 0,
        optimizedDistance: 0,
      );
    }

    // Get initial route via nearest neighbor
    final initial = suggestRoute(coords);
    final originalDist = _calculateTotalDistance(coords, initial);

    // 2-opt improvement
    var bestRoute = List<int>.from(initial);
    var bestDist = originalDist;
    bool improved = true;

    while (improved) {
      improved = false;
      for (int i = 1; i < bestRoute.length - 1; i++) {
        for (int j = i + 1; j < bestRoute.length; j++) {
          final newRoute = List<int>.from(bestRoute);
          // Reverse the segment between i and j
          final segment = newRoute.sublist(i, j + 1).reversed.toList();
          newRoute.replaceRange(i, j + 1, segment);
          final newDist = _calculateTotalDistance(coords, newRoute);
          if (newDist < bestDist - 0.001) {
            bestRoute = newRoute;
            bestDist = newDist;
            improved = true;
          }
        }
      }
    }

    return RouteOptimizationResult(
      optimizedOrder: bestRoute,
      distanceSaved: originalDist - bestDist,
      originalDistance: originalDist,
      optimizedDistance: bestDist,
    );
  }

  static double _calculateTotalDistance(List<List<double>> coords, List<int> order) {
    double total = 0;
    for (int i = 0; i < order.length - 1; i++) {
      total += _haversine(
        coords[order[i]][0], coords[order[i]][1],
        coords[order[i + 1]][0], coords[order[i + 1]][1],
      );
    }
    return total;
  }

  // ─── BUDGET VARIANCE ANALYSIS ───
  static BudgetAnalysis analyzeBudget({
    required double budgeted,
    required double actual,
    required String category,
  }) {
    final variance = actual - budgeted;
    final variancePct = budgeted > 0 ? (variance / budgeted * 100) : 0.0;
    String status;
    if (variancePct.abs() < 5) {
      status = 'on_track';
    } else if (variance > 0) {
      status = 'over_budget';
    } else {
      status = 'under_budget';
    }
    return BudgetAnalysis(
      category: category,
      budgeted: budgeted,
      actual: actual,
      variance: variance,
      variancePercent: variancePct,
      status: status,
    );
  }

  // ─── NPS (Net Promoter Score) CALCULATOR ───
  static NpsResult calculateNPS(List<int> ratings) {
    if (ratings.isEmpty) return NpsResult(score: 0, promoters: 0, passives: 0, detractors: 0);
    int promoters = 0, passives = 0, detractors = 0;
    for (final r in ratings) {
      if (r >= 9) {
        promoters++;
      } else if (r >= 7) {
        passives++;
      } else {
        detractors++;
      }
    }
    final total = ratings.length;
    final nps = ((promoters - detractors) / total * 100).round();
    return NpsResult(score: nps, promoters: promoters, passives: passives, detractors: detractors);
  }

  // ─── DEMO DATA GENERATORS ───
  static List<AiInsight> generateDemoInsights() {
    return [
      AiInsight(
        id: '1',
        type: 'anomaly',
        title: 'Anomaly Detected',
        description: 'Unusual spike in Zone A plastic collection (+45%). Pattern matches festival season data from 2024.',
        severity: 'warning',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      AiInsight(
        id: '2',
        type: 'prediction',
        title: 'Route Optimization',
        description: 'Applying 2-opt routing on current fleet tasks can save an estimated 12% fuel today.',
        severity: 'info',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      AiInsight(
        id: '3',
        type: 'alert',
        title: 'Capacity Alert',
        description: 'Warehouse B will reach max capacity in 48 hours based on current incoming volume.',
        severity: 'critical',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      AiInsight(
        id: '4',
        type: 'trend',
        title: 'Collection Trend',
        description: 'E-waste collection is up 15% this week. Consider assigning more specialized workers to Sector 4.',
        severity: 'info',
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      ),
    ];
  }
}

// ─── AI RESULT MODELS ───
class SentimentResult {
  final double score;
  final String label;
  final double confidence;
  SentimentResult({required this.score, required this.label, required this.confidence});
}

class WorkerRiskScore {
  final double score;
  final String category;
  WorkerRiskScore({required this.score, required this.category});
}

class ForecastPoint {
  final int day;
  final double predicted;
  final double lowerBound;
  final double upperBound;
  ForecastPoint({required this.day, required this.predicted, required this.lowerBound, required this.upperBound});
}

class RouteOptimizationResult {
  final List<int> optimizedOrder;
  final double distanceSaved;
  final double originalDistance;
  final double optimizedDistance;
  RouteOptimizationResult({required this.optimizedOrder, required this.distanceSaved, required this.originalDistance, required this.optimizedDistance});
}

class BudgetAnalysis {
  final String category;
  final double budgeted;
  final double actual;
  final double variance;
  final double variancePercent;
  final String status;
  BudgetAnalysis({required this.category, required this.budgeted, required this.actual, required this.variance, required this.variancePercent, required this.status});
}

class NpsResult {
  final int score;
  final int promoters;
  final int passives;
  final int detractors;
  NpsResult({required this.score, required this.promoters, required this.passives, required this.detractors});
}
