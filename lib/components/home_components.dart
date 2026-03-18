import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:grandustionapp/generated/l10n.dart';


class ConnectionStatus extends StatelessWidget {
  const ConnectionStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context)!;
    final isRTL = Localizations.localeOf(context).languageCode == 'ar';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Directionality(
        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF1A2522),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.tealAccent, width: 1),
              ),
              child: Row(
                children: [
                  Text(
                    lang.connected,
                    style: const TextStyle(
                      color: Colors.tealAccent,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(Icons.wifi, color: Colors.tealAccent[400], size: 18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================
// 🔷 دائرة التقدم
// =============================================
class ProgressCircle extends StatelessWidget {
  final double percent;
  final double steps;

  const ProgressCircle({
    super.key,
    required this.percent,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context)!;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.72,
          height: MediaQuery.of(context).size.width * 0.72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(102, 2, 61, 49),
                blurRadius: 23,
                spreadRadius: 6,
              ),
            ],
          ),
        ),
        CircularPercentIndicator(
          radius: MediaQuery.of(context).size.width * 0.35,
          lineWidth: 16,
          percent: percent.clamp(0.0, 1.0),
          circularStrokeCap: CircularStrokeCap.round,
          backgroundColor: Colors.grey.withOpacity(0.25),
          linearGradient: const LinearGradient(
            colors: [Color(0xFF00FF73), Color(0xFF01FDCB), Color(0xFF01ECF0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          center: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                steps.toStringAsFixed(0),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black54,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                lang.steps,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 6),
              Text(
                percent >= 1.0 ? lang.congratulationsGoalComplete : lang.keepWalking,
                style: const TextStyle(
                  color: Colors.tealAccent,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// =============================================
// 🔷 نسبة الهدف
// =============================================
class GoalPercentText extends StatelessWidget {
  final double percent;

  const GoalPercentText({super.key, required this.percent});

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.tealAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "${(percent * 100).toStringAsFixed(0)}% ${lang.ofGoal}",
        style: const TextStyle(
          color: Colors.tealAccent,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// =============================================
// 🔷 قسم نقاط الطاقة
// =============================================
class EnergyPointsSection extends StatelessWidget {
  final int points;

  const EnergyPointsSection({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context)!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF182A25),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildConversionRate(lang),
          const SizedBox(height: 16),
          _buildPointsBalance(lang, points),
        ],
      ),
    );
  }

  Widget _buildConversionRate(S lang) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF182A25),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            lang.conversionRate,
            style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          ),
          Text(
            lang.conversionFormula,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsBalance(S lang, int points) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 34, 59, 52),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.tealAccent.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lang.energyPointsBalance,
                style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.bolt, color: Colors.tealAccent, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '$points نقطة',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.tealAccent.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              color: Colors.tealAccent,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================
// 🔷 أزرار الإجراءات
// =============================================
class ActionButtons extends StatelessWidget {
  final VoidCallback onChargeNow;
  final VoidCallback onLogActivity;

  const ActionButtons({
    super.key,
    required this.onChargeNow,
    required this.onLogActivity,
  });

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 8),
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.tealAccent,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
              ),
              onPressed: onChargeNow,
              child: Text(
                lang.chargeNow,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 8),
            height: 50,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF64FFDA),
                side: const BorderSide(color: Color(0xFF64FFDA)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: onLogActivity,
              child: Text(
                lang.logActivity,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================
// 🔷 صندوق الإنجاز
// =============================================
class AchievementBox extends StatelessWidget {
  final double percent;

  const AchievementBox({super.key, required this.percent});

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.tealAccent.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.emoji_events, color: Colors.tealAccent, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "${lang.great} ${(percent * 100).toStringAsFixed(0)}% ${lang.ofYourDailyGoal}",
              style: const TextStyle(
                color: Colors.tealAccent,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}