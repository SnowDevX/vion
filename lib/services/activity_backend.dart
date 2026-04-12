import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum ActivityTransactionType { steps, reward }

class ActivityTransaction {
  final ActivityTransactionType type;
  final DateTime timestamp;
  final int points;
  final int? steps;
  final String? rewardTitle;

  const ActivityTransaction({
    required this.type,
    required this.timestamp,
    required this.points,
    this.steps,
    this.rewardTitle,
  });
}

class ActivityDashboardData {
  final int totalSteps;
  final int pointsEarned;
  final int pointsSpent;
  final List<double> dailyChart;
  final List<double> weeklyChart;
  final List<double> monthlyChart;
  final List<ActivityTransaction> transactions;

  const ActivityDashboardData({
    required this.totalSteps,
    required this.pointsEarned,
    required this.pointsSpent,
    required this.dailyChart,
    required this.weeklyChart,
    required this.monthlyChart,
    required this.transactions,
  });

  factory ActivityDashboardData.empty() {
    return const ActivityDashboardData(
      totalSteps: 0,
      pointsEarned: 0,
      pointsSpent: 0,
      dailyChart: [0, 0, 0, 0, 0, 0, 0],
      weeklyChart: [0, 0, 0, 0, 0, 0, 0],
      monthlyChart: [0, 0, 0, 0, 0, 0, 0],
      transactions: [],
    );
  }
}

class ActivityBackend {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<ActivityDashboardData> streamDashboard() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value(ActivityDashboardData.empty());
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .map((snapshot) => _mapSnapshot(snapshot.data()));
  }

  ActivityDashboardData _mapSnapshot(Map<String, dynamic>? data) {
    if (data == null) {
      return ActivityDashboardData.empty();
    }

    final dailySteps = _readDailySteps(data['dailySteps']);
    final redeemHistory = _readRedeemHistory(data['redeemHistory']);

    final totalSteps = _readInt(data['totalSteps']) > 0
        ? _readInt(data['totalSteps'])
        : _readInt(data['todaySteps']);
    final totalPoints = _readInt(data['totalPoints']);
    final pointsEarnedField = _readInt(data['pointsEarned']);
    final currentPoints = _readInt(data['points']);
    final todayPoints = _readInt(data['todayPoints']);
    final pointsEarned = totalPoints > 0
        ? totalPoints
        : (pointsEarnedField > 0 ? pointsEarnedField : currentPoints);
    final pointsSpent = redeemHistory.isNotEmpty
        ? redeemHistory.fold<int>(
      0,
      (total, item) => total + _readInt(item['points']),
    )
        : _readInt(data['rewards']);
    final normalizedDailySteps = dailySteps.isNotEmpty
        ? dailySteps
        : _fallbackDailySteps(_readInt(data['todaySteps']));

    return ActivityDashboardData(
      totalSteps: totalSteps,
      pointsEarned: pointsEarned > 0 ? pointsEarned : todayPoints,
      pointsSpent: pointsSpent,
      dailyChart: _buildDailyChart(normalizedDailySteps),
      weeklyChart: _buildWeeklyChart(normalizedDailySteps),
      monthlyChart: _buildMonthlyChart(normalizedDailySteps),
      transactions: _buildTransactions(normalizedDailySteps, redeemHistory),
    );
  }

  Map<String, int> _readDailySteps(dynamic raw) {
    if (raw is! Map) {
      return <String, int>{};
    }

    return raw.map(
      (key, value) => MapEntry(key.toString(), _readInt(value)),
    );
  }

  List<Map<String, dynamic>> _readRedeemHistory(dynamic raw) {
    if (raw is! List) {
      return <Map<String, dynamic>>[];
    }

    return raw
        .whereType<Map>()
        .map(
          (item) => item.map(
            (key, value) => MapEntry(key.toString(), value),
          ),
        )
        .toList();
  }

  Map<String, int> _fallbackDailySteps(int todaySteps) {
    if (todaySteps <= 0) {
      return <String, int>{};
    }

    return <String, int>{_dateKey(DateTime.now()): todaySteps};
  }

  List<double> _buildDailyChart(Map<String, int> dailySteps) {
    final today = DateTime.now();

    return List<double>.generate(7, (index) {
      final date = DateTime(today.year, today.month, today.day)
          .subtract(Duration(days: 6 - index));
      return (dailySteps[_dateKey(date)] ?? 0).toDouble();
    });
  }

  List<double> _buildWeeklyChart(Map<String, int> dailySteps) {
    final currentWeekStart = _weekStart(DateTime.now());
    final buckets = List<double>.filled(7, 0);

    for (final entry in dailySteps.entries) {
      final date = DateTime.tryParse(entry.key);
      if (date == null) {
        continue;
      }

      final diffDays = currentWeekStart.difference(_weekStart(date)).inDays;
      final weekIndex = 6 - (diffDays ~/ 7);
      if (weekIndex >= 0 && weekIndex < 7) {
        buckets[weekIndex] += entry.value.toDouble();
      }
    }

    return buckets;
  }

  List<double> _buildMonthlyChart(Map<String, int> dailySteps) {
    final now = DateTime.now();
    final buckets = List<double>.filled(7, 0);

    for (final entry in dailySteps.entries) {
      final date = DateTime.tryParse(entry.key);
      if (date == null) {
        continue;
      }

      final diffMonths =
          (now.year - date.year) * 12 + (now.month - date.month);
      final monthIndex = 6 - diffMonths;
      if (monthIndex >= 0 && monthIndex < 7) {
        buckets[monthIndex] += entry.value.toDouble();
      }
    }

    return buckets;
  }

  List<ActivityTransaction> _buildTransactions(
    Map<String, int> dailySteps,
    List<Map<String, dynamic>> redeemHistory,
  ) {
    final transactions = <ActivityTransaction>[];

    for (final entry in dailySteps.entries) {
      final date = DateTime.tryParse(entry.key);
      if (date == null || entry.value <= 0) {
        continue;
      }

      transactions.add(
        ActivityTransaction(
          type: ActivityTransactionType.steps,
          timestamp: date,
          points: (entry.value / 1000).floor() * 10,
          steps: entry.value,
        ),
      );
    }

    for (final item in redeemHistory) {
      final date = DateTime.tryParse(item['date']?.toString() ?? '') ??
          DateTime.now();
      transactions.add(
        ActivityTransaction(
          type: ActivityTransactionType.reward,
          timestamp: date,
          points: _readInt(item['points']),
          rewardTitle: item['reward']?.toString(),
        ),
      );
    }

    transactions.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return transactions.take(10).toList();
  }

  DateTime _weekStart(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    return normalized.subtract(Duration(days: normalized.weekday - 1));
  }

  String _dateKey(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  int _readInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is double) {
      return value.round();
    }
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }
}