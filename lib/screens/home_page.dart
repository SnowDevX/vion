import 'package:flutter/material.dart';
import 'package:grandustionapp/screens/account_page.dart';
import 'package:grandustionapp/screens/charging_stations_page.dart';  
import 'package:grandustionapp/screens/charge_now_page.dart';        
import 'package:grandustionapp/generated/l10n.dart';
import 'activity_page.dart';
import 'rewards_page.dart';
import 'package:grandustionapp/components/home_components.dart';
import 'package:grandustionapp/services/home_backend.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late PageController _pageController;
  final HomeBackend _backend = HomeBackend();
  bool _isLoading = false;
  
  bool _locationPermissionGranted = false;
  bool _activityPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _requestAllPermissions();
    _initializeApp();
  }

  Future<void> _requestAllPermissions() async {
    try {
      var activityStatus = await Permission.activityRecognition.status;
      if (activityStatus.isDenied) {
        activityStatus = await Permission.activityRecognition.request();
      }
      
      var locationStatus = await Permission.location.status;
      if (locationStatus.isDenied) {
        locationStatus = await Permission.location.request();
      }
      
      setState(() {
        _activityPermissionGranted = activityStatus.isGranted;
        _locationPermissionGranted = locationStatus.isGranted;
      });
      
      print('✅ النشاط البدني: $_activityPermissionGranted');
      print('✅ الموقع: $_locationPermissionGranted');
      
    } catch (e) {
      print('❌ خطأ في طلب الصلاحيات: $e');
    }
  }

  Future<void> _initializeApp() async {
    try {
      setState(() => _isLoading = true);

      await _backend.checkAndResetDailySteps();
      await _backend.loadUserStats();
      _backend.startPedometer(_onStepUpdate);

      setState(() => _isLoading = false);
    } catch (e) {
      print('❌ خطأ في التهيئة: $e');
      setState(() => _isLoading = false);
    }
  }

  void _onStepUpdate(int newSteps) async {
    print('🔥 onStepUpdate: $newSteps');
    
    setState(() {
      _backend.updateProgress(newSteps);
    });
    
    await _backend.saveStepsLocally(newSteps);
    await _backend.syncStepsToBackend(newSteps);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = Localizations.localeOf(context).languageCode == 'ar';
    final lang = S.of(context)!;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFF0F1A17),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: Color(0xFF3DDC97)),
              const SizedBox(height: 20),
              Text(
                lang.loading,
                style: const TextStyle(color: Color(0xFF3DDC97)),
              ),
            ],
          ),
        ),
      );
    }

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFF0F1A17),
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) => setState(() => _currentIndex = index),
          children: [
            _buildHomeContent(),
            const ActivityPage(),
            const RewardsPage(),
            const AccountPage(),
            const ChargingStationsPage(),  
          ],
        ),
        bottomNavigationBar: _buildBottomNavBar(),
      ),
    );
  }

  Widget _buildHomeContent() {
    final lang = S.of(context)!;
    
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const ConnectionStatus(),
            const SizedBox(height: 40),
            
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: Text(
                '${lang.dailyGoal}: ${_backend.dailyGoal} ${lang.steps}',
                style: const TextStyle(
                  color: Color(0xFF3DDC97),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            
            ProgressCircle(
              percent: _backend.todayProgress,
              steps: _backend.steps.toDouble(),
            ),
            const SizedBox(height: 16),
            GoalPercentText(percent: _backend.todayProgress),
            const SizedBox(height: 40),
            
            EnergyPointsSection(points: _backend.todayPoints),
            const SizedBox(height: 30),
            
            ActionButtons(
              onChargeNow: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ChargingPage()),
                );
              },
              onLogActivity: () => _pageController.animateToPage(
                1,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
            ),
            const SizedBox(height: 30),
            
            if (_backend.todayProgress >= 1.0)
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF3DDC97).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF3DDC97), width: 2),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.emoji_events, color: Color(0xFF3DDC97), size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        lang.congratulationsGoalComplete,
                        style: const TextStyle(
                          color: Color(0xFF3DDC97),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            
            AchievementBox(percent: _backend.todayProgress),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    final lang = S.of(context)!;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0F1A17),
        border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF3DDC97),
        unselectedItemColor: Colors.grey,
        elevation: 0,
        currentIndex: _currentIndex,
        onTap: (index) => _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        ),
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: lang.home),
          BottomNavigationBarItem(icon: const Icon(Icons.flash_on), label: lang.activity),
          BottomNavigationBarItem(icon: const Icon(Icons.card_giftcard), label: lang.rewards),
          BottomNavigationBarItem(icon: const Icon(Icons.person), label: lang.myAccount),
          BottomNavigationBarItem(icon: const Icon(Icons.ev_station), label: lang.chargingStations),
        ],
      ),
    );
  }
}