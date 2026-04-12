import 'package:pedometer/pedometer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeBackend {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  int steps = 0;
  int todayPoints = 0;
  int totalPoints = 0;
  int dailyGoal = 10000;
  double todayProgress = 0.0;
  
  int userHeight = 0;
  int userWeight = 0;
  
  late Stream<StepCount> stepCountStream;
  
  String? get _userId => _auth.currentUser?.uid;
  
  //  حساب النقاط من الخطوات (100 خطوة = 1 نقطة)
  int _calculatePoints(int steps) {
    return (steps / 100).floor();
  }
  
  //  الحصول على تاريخ اليوم
  String get _todayDate {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
  
  //  التحقق من بداية يوم جديد
  Future<void> checkAndResetDailySteps() async {
    if (_userId == null) return;
    
    print('========== التحقق من اليوم الجديد ==========');
    print(' تاريخ اليوم: $_todayDate');
    
    final userDocRef = _firestore.collection('users').doc(_userId);
    final userDoc = await userDocRef.get();
    
    if (!userDoc.exists) {
      print(' مستخدم جديد - إنشاء مستند');
      await _createNewUser();
      steps = 0;
      todayPoints = 0;
      totalPoints = 0;
      todayProgress = 0.0;
      return;
    }
    
    final data = userDoc.data() as Map<String, dynamic>;
    final lastDate = data['lastDate'] ?? '';
    
    print(' آخر تاريخ مسجل: $lastDate');
    
    if (lastDate != _todayDate && lastDate.isNotEmpty) {
      print(' يوم جديد - حفظ بيانات الأمس');
      
      final yesterdaySteps = data['todaySteps'] ?? 0;
      
      if (yesterdaySteps > 0) {
        await userDocRef.update({
          'stepsHistory.$lastDate': yesterdaySteps,
        });
        print('  تم حفظ تاريخ $lastDate: $yesterdaySteps خطوة');
      }
      
      await userDocRef.update({
        'lastDate': _todayDate,
        'todaySteps': 0,
        'todayPoints': 0,
      });
      
      steps = 0;
      todayPoints = 0;
      todayProgress = 0.0;
      
      print('  تم إعادة تعيين بيانات اليوم الجديد');
    } else {
      steps = data['todaySteps'] ?? 0;
      todayPoints = data['todayPoints'] ?? 0;
      totalPoints = data['totalPoints'] ?? 0;
      dailyGoal = data['dailyStepsGoal'] ?? 10000;
      todayProgress = (steps / dailyGoal).clamp(0.0, 1.0);
      
      print(' نفس اليوم - خطوات: $steps, نقاط: $todayPoints');
    }
    
    userHeight = data['height'] ?? 0;
    userWeight = data['weight'] ?? 0;
    
    print('============================================');
  }

  //  إنشاء مستخدم جديد
  Future<void> _createNewUser() async {
    if (_userId == null) return;
    
    await _firestore.collection('users').doc(_userId).set({
      'name': _auth.currentUser?.displayName ?? 'زائر',
      'email': _auth.currentUser?.email ?? '',
      'height': 0,
      'weight': 0,
      'dailyStepsGoal': 10000,
      'todaySteps': 0,
      'todayPoints': 0,
      'totalPoints': 0,
      'lastDate': _todayDate,
      'stepsHistory': {},
      'createdAt': FieldValue.serverTimestamp(),
    });
    print(' تم إنشاء مستند جديد للمستخدم: $_userId');
  }

  //  حفظ الخطوات
  Future<void> saveStepsLocally(int newSteps) async {
    if (_userId == null) return;
    
    final newTodayPoints = _calculatePoints(newSteps);
    
    await _firestore.collection('users').doc(_userId).update({
      'todaySteps': newSteps,
      'todayPoints': newTodayPoints,
    });
    
    print(' حفظ الخطوات: $newSteps');
  }

  //  بدء مستشعر الخطوات
  void startPedometer(Function(int) onStepUpdate) {
    try {
      print(' محاولة بدء مستشعر الخطوات...');
      
      stepCountStream = Pedometer.stepCountStream;
      
      stepCountStream.listen(
        (StepCount event) {
          print(' مستشعر الخطوات: ${event.steps} خطوة');
          onStepUpdate(event.steps);
        },
        onError: (error) {
          print(' خطأ في المستشعر: $error');
        },
      );
      
      print(' تم بدء مستشعر الخطوات بنجاح');
      
    } catch (e) {
      print(' فشل بدء المستشعر: $e');
      print(' قد يكون الجهاز لا يدعم عداد الخطوات');
    }
  }

  //  مزامنة الخطوات
  Future<void> syncStepsToBackend(int steps, {bool isReset = false}) async {
    if (_userId == null) return;
    
    try {
      final newTodayPoints = _calculatePoints(steps);
      
      if (isReset) {
        todayPoints = 0;
        await _firestore.collection('users').doc(_userId).update({
          'todayPoints': 0,
        });
      } else {
        final pointsDifference = newTodayPoints - todayPoints;
        
        if (pointsDifference > 0) {
          totalPoints += pointsDifference;
          todayPoints = newTodayPoints;
          
          await _firestore.collection('users').doc(_userId).update({
            'todayPoints': todayPoints,
            'totalPoints': totalPoints,
          });
          
          print(' نقاط إضافية: +$pointsDifference');
          print(' إجمالي النقاط: $totalPoints');
        }
      }
      
      print(' مزامنة: خطوات=$steps');
      
    } catch (e) {
      print(' خطأ في المزامنة: $e');
    }
  }

  //  جلب إحصائيات المستخدم
  Future<void> loadUserStats() async {
    if (_userId == null) return;
    
    try {
      final userDoc = await _firestore.collection('users').doc(_userId).get();
      
      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        
        todayPoints = data['todayPoints'] ?? 0;
        totalPoints = data['totalPoints'] ?? 0;
        dailyGoal = data['dailyStepsGoal'] ?? 10000;
        userHeight = data['height'] ?? 0;
        userWeight = data['weight'] ?? 0;
        steps = data['todaySteps'] ?? 0;
        todayProgress = (steps / dailyGoal).clamp(0.0, 1.0);
        
        print(' تم تحميل بيانات المستخدم');
      }
    } catch (e) {
      print(' خطأ في جلب البيانات: $e');
    }
  }

  //  تحديث التقدم
  void updateProgress(int newSteps) {
    steps = newSteps;
    todayPoints = _calculatePoints(newSteps);
    todayProgress = (steps / dailyGoal).clamp(0.0, 1.0);
    
    print(' تقدم: خطوات=$steps, تقدم=${(todayProgress * 100).toStringAsFixed(1)}%');
  }
}