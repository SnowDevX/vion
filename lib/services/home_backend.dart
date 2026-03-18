import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grandustionapp/services/firebase_service.dart';

class HomeBackend {
  final FirebaseService _firebaseService = FirebaseService();
  
  int steps = 0;
  int points = 0; 
  int dailyGoal = 10000;
  double todayProgress = 0.0;
  int lastSavedSteps = 0;
  
  late Stream<StepCount> stepCountStream;
  
  // التحقق من بداية يوم جديد
  Future<void> checkAndResetDailySteps() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().split('T')[0];
    
    final lastDate = prefs.getString('last_date') ?? today;
    final lastDateObj = DateTime.parse(lastDate);
    
    if (lastDateObj.day != DateTime.now().day) {
      print(' يوم جديد - إعادة تعيين الخطوات');
      steps = 0;
      points = 0; 
      todayProgress = 0.0;
      
      await prefs.setString('last_date', today);
      await prefs.setInt('last_saved_steps', 0);
      await prefs.setInt('last_points', 0); 
      
      await syncStepsToBackend(0, isReset: true);
    } else {
      lastSavedSteps = prefs.getInt('last_saved_steps') ?? 0;
      steps = lastSavedSteps;
      
      int savedPoints = prefs.getInt('last_points') ?? 0;
      points = savedPoints;
      
      todayProgress = (steps / dailyGoal).clamp(0.0, 1.0);
      
      print(' استرجاع: خطوات=$steps, نقاط=$points');
    }
  }

  // دالة حفظ الخطوات 
  Future<void> saveStepsLocally(int newSteps) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_saved_steps', newSteps);
    
    int newPoints = (newSteps / 100).floor();
    await prefs.setInt('last_points', newPoints);
    
    print(' حفظ: خطوات=$newSteps, نقاط=$newPoints');
  }

  // بدء مستشعر الخطوات
  void startPedometer(Function(int) onStepUpdate) {
    try {
      stepCountStream = Pedometer.stepCountStream;
      stepCountStream.listen((StepCount event) {
        onStepUpdate(event.steps);
      });
    } catch (e) {
      print('مستشعر الخطوات غير متوفر: $e');
    }
  }

  // مزامنة الباك إند مع تحديث Firestore
  Future<void> syncStepsToBackend(int steps, {bool isReset = false}) async {
    try {
      int calculatedPoints = (steps / 100).floor();
      
      if (isReset) {
        await _firebaseService.resetDailySteps();
        points = 0;
        await _firebaseService.updateUserPoints(0); // ✅ تحديث Firestore
      } else {
        final result = await _firebaseService.syncSteps(steps);
        if (result != null && result['success'] == true) {
          if (result['newPoints'] != null && result['newPoints'] > 0) {
            points = result['newPoints'];
          } else {
            points = calculatedPoints;
          }
        } else {
          points = calculatedPoints;
        }
        
        // ✅ تحديث Firestore بالنقاط الجديدة
        await _firebaseService.updateUserPoints(points);
      }
      
      print(' مزامنة: خطوات=$steps, نقاط=$points');
      
    } catch (e) {
      print('خطأ في مزامنة الخطوات: $e');
      points = (steps / 100).floor();
      await _firebaseService.updateUserPoints(points); // ✅ تحديث حتى مع الخطأ
    }
  }

  // جلب إحصائيات المستخدم
  Future<void> loadUserStats() async {
    try {
      final result = await _firebaseService.getUserStats();
      if (result['success'] == true) {
        final data = result['data'];
        
        int backendPoints = data['totalPoints'] ?? 0;
        if (backendPoints > points) {
          points = backendPoints;
        }
        
        dailyGoal = data['dailyGoal'] ?? dailyGoal;
        todayProgress = (steps / dailyGoal).clamp(0.0, 1.0);
      }
    } catch (e) {
      print('خطأ في جلب بيانات المستخدم: $e');
    }
  }

  // تحديث التقدم
  void updateProgress(int newSteps) {
    steps = newSteps;
    points = (steps / 100).floor(); 
    todayProgress = (steps / dailyGoal).clamp(0.0, 1.0);
    
    print(' تحديث: خطوات=$steps, نقاط=$points, تقدم=${todayProgress.toStringAsFixed(2)}');
  }
}