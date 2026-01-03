import 'package:flutter/material.dart';
import 'package:grandustionapp/screens/account_page.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'activity_page.dart';
import 'rewards_page.dart';
import 'package:grandustionapp/generated/l10n.dart'; // استخدم هذا الاستيراد

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final double steps = 7848;
    final double goal = 10000;
    final double percent = steps / goal;
    final lang = S.of(context)!; 
    final isRTL = Localizations.localeOf(context).languageCode == 'ar';

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFF0F1A17),
        bottomNavigationBar: _buildBottomNavBar(context),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildConnectionStatus(lang),
                const SizedBox(height: 40),
                _buildProgressCircle(context, percent, steps, lang),
                const SizedBox(height: 16),
                _buildGoalPercentText(percent, lang),
                const SizedBox(height: 40),
                _buildEnergyPointsSection(lang),
                const SizedBox(height: 30),
                _buildButtons(lang),
                const SizedBox(height: 30),
                _buildAchievementBox(percent, lang),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConnectionStatus(S lang) {
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

  Widget _buildProgressCircle(BuildContext context, double percent, double steps, S lang) {
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

  Widget _buildGoalPercentText(double percent, S lang) {
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

  Widget _buildEnergyPointsSection(S lang) {
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
          _buildPointsBalance(lang),
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

  Widget _buildPointsBalance(S lang) {
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
                    lang.pointsCount,
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

  Widget _buildButtons(S lang) {
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
              onPressed: () {},
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
              onPressed: () {},
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

  Widget _buildAchievementBox(double percent, S lang) {
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
              "${lang.great} ${(percent * 100).toStringAsFixed(0)}% ${lang.ofYourDailyGoal}", // حل بديل
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

//الجزء الخاص بشريط التنقل السفلي
  Widget _buildBottomNavBar(BuildContext context) {
    final lang = S.of(context)!;
    
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0F1A17),
        border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        elevation: 0,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ActivityPage()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RewardsPage()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AccountPage()),
            );
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home), 
            label: lang.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.flash_on), 
            label: lang.activity,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.public), 
            label: lang.rewards,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person), 
            label: lang.myAccount,
          ),
        ],
      ),
    );
  }
}