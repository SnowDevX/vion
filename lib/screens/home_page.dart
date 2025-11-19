import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final double steps = 7848;
    final double goal = 10000;
    final double percent = steps / goal;

    return Scaffold(
      backgroundColor: const Color(0xFF0F1A17),

      bottomNavigationBar: _buildBottomNavBar(),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildConnectionStatus(),
              const SizedBox(height: 40),
              _buildProgressCircle(context, percent, steps),
              const SizedBox(height: 16),
              _buildGoalPercentText(percent),
              const SizedBox(height: 40),
              _buildEnergyPointsSection(),
              const SizedBox(height: 30),
              _buildButtons(),
              const SizedBox(height: 30),
              _buildAchievementBox(percent),
            ],
          ),
        ),
      ),
    );
  }

  //==============================================================
  // 	عناصر الصفحة
  //==============================================================

  // 	مربع الحالة
  Widget _buildConnectionStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Directionality(
        textDirection: TextDirection.rtl,
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
                  const Text(
                    "مُتَّصِل",
                    style: TextStyle(
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

  // دائرة التقدم
  Widget _buildProgressCircle(
    BuildContext context,
    double percent,
    double steps,
  ) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 	الظل الخارجي
        Container(
          width: MediaQuery.of(context).size.width * 0.72,
          height: MediaQuery.of(context).size.width * 0.72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                // تم إصلاح هذا الجزء: تم استبدال withOpacity(0.4) بحساب قيمة الشفافية (102) مباشرةً
                color: const Color.fromARGB(102, 2, 61, 49),
                blurRadius: 23, // مدى انتشار اللمعة
                spreadRadius: 6, // مدى توسّعها
              ),
            ],
          ),
        ),

        // 	الدائرة
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

          // 	محتوى المركز
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
              const Text(
                "خطوات",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 6),
              Text(
                percent >= 1.0 ? " تهانينا! الهدف مكتمل" : "تابع المشي ",
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

  // 	نسبة الإنجاز
  Widget _buildGoalPercentText(double percent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.tealAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "${(percent * 100).toStringAsFixed(0)}% من الهدف",
        style: const TextStyle(
          color: Colors.tealAccent,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // 	نقاط الطاقة
  Widget _buildEnergyPointsSection() {
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
          _buildConversionRate(),
          const SizedBox(height: 16),
          _buildPointsBalance(),
        ],
      ),
    );
  }

  // 	معدل التحويل
  Widget _buildConversionRate() {
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
            "معدل التحويل",
            style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          ),
          const Text(
            "نقطة 1/100 = خطوة",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // 	رصيد النقاط
  Widget _buildPointsBalance() {
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
                "رصيد نقاط الطاقة",
                style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.bolt, color: Colors.tealAccent, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    "156 نقطة ✓",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // الأيقونة
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

  // الأزرار (اشحن الآن / سجل نشاطي)
  Widget _buildButtons() {
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
              child: const Text(
                "اشحن الآن",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
              child: const Text(
                "سجل نشاطي",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // مربع الإنجاز
  Widget _buildAchievementBox(double percent) {
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
              "رائع! لقد قطعت ${(percent * 100).toStringAsFixed(0)}% من هدفك اليومي",
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

  // 	الشريط السفلي
  Widget _buildBottomNavBar() {
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.flash_on), label: 'النشاط'),
          BottomNavigationBarItem(icon: Icon(Icons.public), label: 'المكافآت'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'حسابي'),
        ],
      ),
    );
  }
}
