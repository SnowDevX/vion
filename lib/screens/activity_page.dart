import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:grandustionapp/generated/l10n.dart';
import 'package:grandustionapp/services/activity_backend.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  final ActivityBackend _backend = ActivityBackend();
  int _selectedTab = 0;

  static const Color _bg = Color(0xFF0F1A17);
  static const Color _card = Color(0xFF182A25);
  static const Color _accent = Color(0xFF3DDC97);

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final isRTL = Localizations.localeOf(context).languageCode == 'ar';

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: StreamBuilder<ActivityDashboardData>(
        stream: _backend.streamDashboard(),
        builder: (context, snapshot) {
          final data = snapshot.data ?? ActivityDashboardData.empty();

          return Scaffold(
            backgroundColor: _bg,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(lang),
                    const SizedBox(height: 20),
                    _buildStatCards(lang, data),
                    const SizedBox(height: 20),
                    _buildTabBar(lang),
                    const SizedBox(height: 20),
                    _buildChart(lang, data),
                    const SizedBox(height: 28),
                    _buildTransactionHeader(lang),
                    const SizedBox(height: 12),
                    _buildTransactionList(lang, data),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<List<String>> _getChartLabels(S lang) {
    final now = DateTime.now();

    return [
      List<String>.generate(7, (index) {
        final date = now.subtract(Duration(days: 6 - index));
        return '${date.day}/${date.month}';
      }),
      [
        lang.chartLabelWeek('1'),
        lang.chartLabelWeek('2'),
        lang.chartLabelWeek('3'),
        lang.chartLabelWeek('4'),
        lang.chartLabelWeek('5'),
        lang.chartLabelWeek('6'),
        lang.chartLabelWeek('7'),
      ],
      List<String>.generate(7, (index) {
        final month = DateTime(now.year, now.month - (6 - index));
        return '${month.month}/${month.year % 100}';
      }),
    ];
  }

  List<double> _selectedChart(ActivityDashboardData data) {
    switch (_selectedTab) {
      case 1:
        return data.weeklyChart;
      case 2:
        return data.monthlyChart;
      default:
        return data.dailyChart;
    }
  }

  String _formatStat(int value) {
    if (value >= 1000) {
      final compact = value / 1000;
      return compact >= 100
          ? '${compact.toStringAsFixed(0)}K'
          : '${compact.toStringAsFixed(1)}K';
    }
    return value.toString();
  }

  String _formatAxisNumber(double number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(0)}K';
    }
    return number.toStringAsFixed(0);
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '${date.year}-$month-$day $hour:$minute';
  }

  String _transactionTitle(ActivityTransaction tx, S lang) {
    if (tx.type == ActivityTransactionType.steps) {
      return lang.txConvertedSteps((tx.steps ?? 0).toString());
    }

    if ((tx.rewardTitle ?? '').isNotEmpty) {
      return tx.rewardTitle!;
    }

    return lang.txRewardRedemption;
  }

  IconData _transactionIcon(ActivityTransaction tx) {
    switch (tx.type) {
      case ActivityTransactionType.steps:
        return Icons.directions_walk;
      case ActivityTransactionType.reward:
        return Icons.card_giftcard;
    }
  }

  bool _isPositive(ActivityTransaction tx) {
    return tx.type == ActivityTransactionType.steps;
  }

  Widget _buildHeader(S lang) {
    return Column(
      children: [
        Text(
          lang.activityLogTitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          lang.activityLogSubtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white60, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildStatCards(S lang, ActivityDashboardData data) {
    return Row(
      children: [
        _statCard(Icons.trending_up, _formatStat(data.totalSteps), lang.totalSteps),
        const SizedBox(width: 10),
        _statCard(Icons.show_chart, _formatStat(data.pointsEarned), lang.pointsEarned),
        const SizedBox(width: 10),
        _statCard(Icons.bolt, _formatStat(data.pointsSpent), lang.pointsSpent),
      ],
    );
  }

  Widget _statCard(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: _accent, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white54, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar(S lang) {
    final tabs = [lang.daily, lang.weekly, lang.monthly];
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final selected = _selectedTab == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: selected ? _accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  tabs[index],
                  style: TextStyle(
                    color: selected ? Colors.black : Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildChart(S lang, ActivityDashboardData dashboard) {
    final data = _selectedChart(dashboard);
    final labels = _getChartLabels(lang)[_selectedTab];
    final maxValue = data.reduce((a, b) => a > b ? a : b);
    final double maxY = maxValue <= 0 ? 10.0 : maxValue * 1.25;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bar_chart, color: Colors.white70, size: 18),
              const SizedBox(width: 6),
              Text(
                lang.activityProgress,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 220,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: BarChart(
                BarChartData(
                  maxY: maxY,
                  barTouchData: BarTouchData(enabled: false),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: maxY / 4,
                    getDrawingHorizontalLine: (_) =>
                        FlLine(color: Colors.white12, strokeWidth: 1),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 42,
                        interval: (maxY / 4).toDouble(),
                        getTitlesWidget: (value, _) => Text(
                          _formatAxisNumber(value),
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          final index = value.toInt();
                          if (index < 0 || index >= labels.length) {
                            return const SizedBox.shrink();
                          }

                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              labels[index],
                              style: const TextStyle(
                                color: Colors.white38,
                                fontSize: 9,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: List.generate(data.length, (index) {
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: data[index],
                          width: 22,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(6),
                          ),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF3DDC97), Color(0xFF2ECC71)],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionHeader(S lang) {
    return Row(
      children: [
        const Icon(Icons.receipt_long, color: Colors.white70, size: 18),
        const SizedBox(width: 6),
        Text(
          lang.transactionLog,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionList(S lang, ActivityDashboardData data) {
    if (data.transactions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          lang.activityLogSubtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white54),
        ),
      );
    }

    return Column(
      children: data.transactions.map((tx) => _transactionTile(tx, lang)).toList(),
    );
  }

  Widget _transactionTile(ActivityTransaction tx, S lang) {
    final isPositive = _isPositive(tx);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF1B5E20),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(_transactionIcon(tx), color: _accent, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _transactionTitle(tx, lang),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(tx.timestamp),
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isPositive ? '+' : '-'}${tx.points}',
                style: TextStyle(
                  color: isPositive ? _accent : Colors.redAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                lang.pointUnit,
                style: TextStyle(
                  color: isPositive
                      ? _accent.withOpacity(0.7)
                      : Colors.redAccent.withOpacity(0.7),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}