import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:grandustionapp/generated/l10n.dart';

// ──────────────────────────────────────────────
// Dummy data models
// ──────────────────────────────────────────────

class _Transaction {
  final IconData icon;
  final Color iconBg;
  final String title;
  final String date;
  final String points;
  final bool isPositive;

  const _Transaction({
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.date,
    required this.points,
    required this.isPositive,
  });
}

// ──────────────────────────────────────────────
// Activity / KPI Page
// ──────────────────────────────────────────────

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  int _selectedTab = 0; // 0 = daily, 1 = weekly, 2 = monthly

  // Dummy chart data per tab
  static const List<List<double>> _chartData = [
    // daily (7 days)
    [9500, 7200, 10500, 8000, 6000, 11000, 12500],
    // weekly (7 weeks)
    [45000, 52000, 38000, 60000, 55000, 47000, 62000],
    // monthly (7 months)
    [180000, 210000, 195000, 220000, 200000, 230000, 250000],
  ];

  List<List<String>> _getChartLabels(S lang) {
    return [
      [
        lang.chartLabelToday,
        lang.chartLabelWednesday,
        lang.chartLabelMonday,
        lang.chartLabelSunday,
        lang.chartLabelSaturday,
        lang.chartLabelFriday,
        lang.chartLabelThursday,
      ],
      [
        lang.chartLabelWeek('1'),
        lang.chartLabelWeek('2'),
        lang.chartLabelWeek('3'),
        lang.chartLabelWeek('4'),
        lang.chartLabelWeek('5'),
        lang.chartLabelWeek('6'),
        lang.chartLabelWeek('7'),
      ],
      [
        lang.chartLabelJanuary,
        lang.chartLabelFebruary,
        lang.chartLabelMarch,
        lang.chartLabelApril,
        lang.chartLabelMay,
        lang.chartLabelJune,
        lang.chartLabelJuly,
      ],
    ];
  }

  List<_Transaction> _getTransactions(S lang) {
    return [
      _Transaction(
        icon: Icons.directions_walk,
        iconBg: const Color(0xFF1B5E20),
        title: lang.txConvertedSteps('5,000'),
        date: '2025-11-08 14:30',
        points: '+50',
        isPositive: true,
      ),
      _Transaction(
        icon: Icons.ev_station,
        iconBg: const Color(0xFF1B5E20),
        title: lang.txChargingStation,
        date: '2025-11-08 12:15',
        points: '-10',
        isPositive: false,
      ),
      _Transaction(
        icon: Icons.directions_walk,
        iconBg: const Color(0xFF1B5E20),
        title: lang.txConvertedSteps('3,500'),
        date: '2025-11-07 18:45',
        points: '+35',
        isPositive: true,
      ),
      _Transaction(
        icon: Icons.card_giftcard,
        iconBg: const Color(0xFF1B5E20),
        title: lang.txRewardRedemption,
        date: '2025-11-07 10:20',
        points: '-25',
        isPositive: false,
      ),
      _Transaction(
        icon: Icons.directions_walk,
        iconBg: const Color(0xFF1B5E20),
        title: lang.txConvertedSteps('7,200'),
        date: '2025-11-06 10:00',
        points: '+72',
        isPositive: true,
      ),
    ];
  }

  // ── colours ──
  static const Color _bg = Color(0xFF0F1A17);
  static const Color _card = Color(0xFF182A25);
  static const Color _accent = Color(0xFF3DDC97);

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final isRTL = Localizations.localeOf(context).languageCode == 'ar';

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: _bg,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(lang),
                const SizedBox(height: 20),
                _buildStatCards(lang),
                const SizedBox(height: 20),
                _buildTabBar(lang),
                const SizedBox(height: 20),
                _buildChart(lang),
                const SizedBox(height: 28),
                _buildTransactionHeader(lang),
                const SizedBox(height: 12),
                _buildTransactionList(lang),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Header ──
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

  // ── 3 Stat Cards ──
  Widget _buildStatCards(S lang) {
    return Row(
      children: [
        _statCard(Icons.trending_up, '234K', lang.totalSteps),
        const SizedBox(width: 10),
        _statCard(Icons.show_chart, '2,340', lang.pointsEarned),
        const SizedBox(width: 10),
        _statCard(Icons.bolt, '156', lang.pointsSpent),
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

  // ── Tab bar (daily / weekly / monthly) ──
  Widget _buildTabBar(S lang) {
    final tabs = [lang.daily, lang.weekly, lang.monthly];
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final selected = _selectedTab == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: selected ? _accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  tabs[i],
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

  // ── Bar Chart ──
  Widget _buildChart(S lang) {
    final data = _chartData[_selectedTab];
    final labels = _getChartLabels(lang)[_selectedTab];
    final maxY = data.reduce((a, b) => a > b ? a : b) * 1.25;

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
                        interval: maxY / 4,
                        getTitlesWidget: (value, _) => Text(
                          _formatNumber(value),
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
                          final idx = value.toInt();
                          if (idx < 0 || idx >= labels.length)
                            return const SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              labels[idx],
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
                  barGroups: List.generate(data.length, (i) {
                    return BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: data[i],
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

  String _formatNumber(double n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(0)}K';
    return n.toStringAsFixed(0);
  }

  // ── Transaction section header ──
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

  // ── Transaction List ──
  Widget _buildTransactionList(S lang) {
    final transactions = _getTransactions(lang);
    return Column(
      children: transactions.map((tx) => _transactionTile(tx, lang)).toList(),
    );
  }

  Widget _transactionTile(_Transaction tx, S lang) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: tx.iconBg,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(tx.icon, color: _accent, size: 22),
          ),
          const SizedBox(width: 12),
          // Title + date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tx.date,
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),
          ),
          // Points badge
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                tx.points,
                style: TextStyle(
                  color: tx.isPositive ? _accent : Colors.redAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                lang.pointUnit,
                style: TextStyle(
                  color: tx.isPositive
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
