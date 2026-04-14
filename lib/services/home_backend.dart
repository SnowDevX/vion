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
  
  // ✅ حساب النقاط من الخطوات (100 خطوة = 1 نقطة)
  int _calculatePoints(int steps) {
    return (steps / 100).floor();
  }
  
  // ✅ الحصول على تاريخ اليوم (تنسيق موحد)
  String get _todayDate {
    final now = DateTime.now();
    final year = now.year;
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
  
  // ✅ جلب تاريخ اليوم (للوصول من الخارج)
  String getTodayDate() {
    return _todayDate;
  }
  
  // ✅ جلب آخر تاريخ من Firestore
  Future<String> getLastDateFromFirestore() async {
    if (_userId == null) return '';
    final userDoc = await _firestore.collection('users').doc(_userId).get();
    if (userDoc.exists) {
      return userDoc.data()?['lastDate'] ?? '';
    }
    return '';
  }
  
  // ✅ توحيد تنسيق التاريخ (لإصلاح البيانات القديمة)
  String _normalizeDate(String date) {
    if (date.isEmpty) return date;
    final parts = date.split('-');
    if (parts.length == 3) {
      final year = parts[0];
      final month = parts[1].padLeft(2, '0');
      final day = parts[2].padLeft(2, '0');
      return '$year-$month-$day';
    }
    return date;
  }
  
  // ✅ دالة لتصحيح lastDate في Firestore (شغلها مرة واحدة)
  Future<void> fixLastDate() async {
    if (_userId == null) return;
    
    final userDocRef = _firestore.collection('users').doc(_userId);
    final userDoc = await userDocRef.get();
    
    if (!userDoc.exists) return;
    
    final today = _todayDate;
    
    print('========== تصحيح lastDate ==========');
    print('📅 اليوم الحقيقي: $today');
    
    await userDocRef.update({
      'lastDate': today,
    });
    
    print('✅ تم تحديث lastDate إلى: $today');
    print('====================================');
  }
  
  // ✅ دالة لإعادة تعيين يدوي (للاختبار)
  Future<void> manualReset() async {
    if (_userId == null) return;
    
    final userDocRef = _firestore.collection('users').doc(_userId);
    
    print('========== إعادة تعيين يدوي ==========');
    
    final userDoc = await userDocRef.get();
    final data = userDoc.data() as Map<String, dynamic>;
    final currentSteps = data['todaySteps'] ?? 0;
    final lastDate = data['lastDate'] ?? '';
    
    if (currentSteps > 0 && lastDate.isNotEmpty) {
      await userDocRef.update({
        'stepsHistory.$lastDate': currentSteps,
        'dailySteps.$lastDate': currentSteps,
      });
      print('✅ تم حفظ $currentSteps خطوة في تاريخ $lastDate');
    }
    
    await userDocRef.update({
      'lastDate': _todayDate,
      'todaySteps': 0,
      'todayPoints': 0,
    });
    
    print('✅ تم إعادة تعيين اليوم إلى: ${_todayDate}');
    print('====================================');
  }
  
  // ✅ إعادة تعيين قسري
  Future<void> forceReset() async {
    if (_userId == null) return;
    
    final userDocRef = _firestore.collection('users').doc(_userId);
    
    await userDocRef.update({
      'lastDate': _todayDate,
      'todaySteps': 0,
      'todayPoints': 0,
    });
    
    steps = 0;
    todayPoints = 0;
    todayProgress = 0.0;
    
    print('✅ تم إعادة تعيين قسري إلى: ${_todayDate}');
  }
  
  // ✅ التحقق من بداية يوم جديد
  Future<void> checkAndResetDailySteps() async {
    if (_userId == null) return;
    
    final String today = _todayDate;
    print('========== التحقق من اليوم الجديد ==========');
    print('📅 تاريخ اليوم: $today');
    
    final userDocRef = _firestore.collection('users').doc(_userId);
    final userDoc = await userDocRef.get();
    
    if (!userDoc.exists) {
      print('👤 مستخدم جديد - إنشاء مستند');
      await _createNewUser();
      steps = 0;
      todayPoints = 0;
      totalPoints = 0;
      todayProgress = 0.0;
      return;
    }
    
    final data = userDoc.data() as Map<String, dynamic>;
    String lastDate = data['lastDate'] ?? '';
    
    if (lastDate.isNotEmpty) {
      lastDate = _normalizeDate(lastDate);
    }
    
    print('📆 آخر تاريخ مسجل: $lastDate');
    print('🔍 هل هما مختلفان؟ ${lastDate != today}');
    
    if (lastDate.isEmpty || lastDate != today) {
      print('✅✅✅ يوم جديد - إعادة تعيين البيانات ✅✅✅');
      
      final yesterdaySteps = data['todaySteps'] ?? 0;
      
      // ✅ حفظ بيانات الأمس فقط (بدون إضافة نقاط إلى totalPoints)
      if (yesterdaySteps > 0 && lastDate.isNotEmpty) {
        await userDocRef.update({
          'stepsHistory.$lastDate': yesterdaySteps,
          'dailySteps.$lastDate': yesterdaySteps,
        });
        print('   ✅ تم حفظ تاريخ $lastDate: $yesterdaySteps خطوة');
      }
      
      // ✅ إعادة تعيين اليوم الحالي فقط (لا نضيف نقاط الأمس إلى totalPoints)
      await userDocRef.update({
        'lastDate': today,
        'todaySteps': 0,
        'todayPoints': 0,
      });
      
      steps = 0;
      todayPoints = 0;
      todayProgress = 0.0;
      
      print('   ✅ تم إعادة تعيين بيانات اليوم الجديد');
      print('   📅 اليوم الجديد: $today');
      
    } else {
      steps = data['todaySteps'] ?? 0;
      todayPoints = data['todayPoints'] ?? 0;
      totalPoints = data['totalPoints'] ?? 0;
      dailyGoal = data['dailyStepsGoal'] ?? 10000;
      todayProgress = (steps / dailyGoal).clamp(0.0, 1.0);
      
      print('📊 نفس اليوم - البيانات الحالية:');
      print('   خطوات اليوم: $steps');
      print('   نقاط اليوم: $todayPoints');
      print('   إجمالي النقاط: $totalPoints');
    }
    
    userHeight = data['height'] ?? 0;
    userWeight = data['weight'] ?? 0;
    
    print('============================================');
  }

  // ✅ إنشاء مستخدم جديد
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
      'dailySteps': {},
      'createdAt': FieldValue.serverTimestamp(),
    });
    print('✅ تم إنشاء مستند جديد للمستخدم: $_userId');
  }

  // ✅ حفظ الخطوات
  Future<void> saveStepsLocally(int newSteps) async {
    if (_userId == null) return;
    
    final newTodayPoints = _calculatePoints(newSteps);
    
    await _firestore.collection('users').doc(_userId).update({
      'todaySteps': newSteps,
      'todayPoints': newTodayPoints,
      'dailySteps.$_todayDate': newSteps,
    });
    
    print('💾 حفظ الخطوات: $newSteps');
    print('   نقاط اليوم: $newTodayPoints');
  }

  // ✅ بدء مستشعر الخطوات
  void startPedometer(Function(int) onStepUpdate) {
    try {
      print('👟 محاولة بدء مستشعر الخطوات...');
      
      stepCountStream = Pedometer.stepCountStream;
      
      stepCountStream.listen(
        (StepCount event) {
          print('👟 مستشعر الخطوات: ${event.steps} خطوة');
          onStepUpdate(event.steps);
        },
        onError: (error) {
          print('❌ خطأ في المستشعر: $error');
        },
      );
      
      print('✅ تم بدء مستشعر الخطوات بنجاح');
      
    } catch (e) {
      print('❌ فشل بدء المستشعر: $e');
      print('⚠️ قد يكون الجهاز لا يدعم عداد الخطوات');
    }
  }

  // ✅ مزامنة الخطوات وتحديث النقاط فوراً
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
          todayPoints = newTodayPoints;
          totalPoints += pointsDifference;
          
          await _firestore.collection('users').doc(_userId).update({
            'todayPoints': todayPoints,
            'totalPoints': totalPoints,
          });
          
          print('💰 نقاط إضافية: +$pointsDifference');
          print('💰 إجمالي النقاط الآن: $totalPoints');
        }
      }
      
      print('🔄 مزامنة: خطوات=$steps, نقاط اليوم=$todayPoints, إجمالي=$totalPoints');
      
    } catch (e) {
      print('❌ خطأ في المزامنة: $e');
    }
  }

  // ✅ جلب إحصائيات المستخدم
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
        
        print('📊 تم تحميل بيانات المستخدم');
        print('   خطوات اليوم: $steps');
        print('   نقاط اليوم: $todayPoints');
        print('   إجمالي النقاط: $totalPoints');
      }
    } catch (e) {
      print('❌ خطأ في جلب البيانات: $e');
    }
  }

  // ✅ تحديث التقدم
  void updateProgress(int newSteps) {
    steps = newSteps;
    todayPoints = _calculatePoints(newSteps);
    todayProgress = (steps / dailyGoal).clamp(0.0, 1.0);
    
    print('📈 تحديث التقدم: خطوات=$steps, تقدم=${(todayProgress * 100).toStringAsFixed(1)}%');
  }
  
  // ✅ دالة لإصلاح التواريخ القديمة
  Future<void> fixDatesInFirestore() async {
    if (_userId == null) return;
    
    print('========== إصلاح التواريخ في Firestore ==========');
    
    final userDocRef = _firestore.collection('users').doc(_userId);
    final userDoc = await userDocRef.get();
    
    if (!userDoc.exists) {
      print('❌ لا يوجد مستند للمستخدم');
      return;
    }
    
    final data = userDoc.data() as Map<String, dynamic>;
    final stepsHistory = data['stepsHistory'] ?? {};
    
    final Map<String, dynamic> newHistory = {};
    
    stepsHistory.forEach((key, value) {
      final newKey = _normalizeDate(key);
      newHistory[newKey] = value;
      if (key != newKey) {
        print('   تم تعديل: $key -> $newKey');
      }
    });
    
    String lastDate = data['lastDate'] ?? '';
    final normalizedLastDate = _normalizeDate(lastDate);
    
    await userDocRef.update({
      'stepsHistory': newHistory,
      'lastDate': normalizedLastDate,
    });
    
    print('✅ تم إصلاح التواريخ في Firestore');
    print('   lastDate: $lastDate -> $normalizedLastDate');
    print('   stepsHistory: تم تحديث ${stepsHistory.length} تاريخ');
    print('============================================');
  }
}