import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // دالة مزامنة الخطوات
  Future<Map<String, dynamic>?> syncSteps(int steps) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return {'success': false, 'error': 'No user logged in'};

      final userRef = _firestore.collection('users').doc(user.uid);
      final today = DateTime.now().toIso8601String().split('T')[0];

      await userRef.set({
        'totalSteps': steps,
        'lastUpdated': FieldValue.serverTimestamp(),
        'dailySteps.$today': steps,
      }, SetOptions(merge: true));

      final points = (steps / 1000).floor() * 10;

      return {
        'success': true,
        'newPoints': points,
      };
    } catch (e) {
      print('خطأ في مزامنة الخطوات: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  // دالة إعادة تعيين الخطوات
  Future<Map<String, dynamic>> resetDailySteps() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return {'success': false, 'error': 'No user logged in'};
      }

      final userRef = _firestore.collection('users').doc(user.uid);
      final today = DateTime.now().toIso8601String().split('T')[0];

      await userRef.set({
        'dailySteps.$today': 0,
        'lastReset': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      print(' تم إعادة تعيين الخطوات لليوم: $today');
      
      return {
        'success': true,
        'message': 'Daily steps reset successfully',
      };
    } catch (e) {
      print(' خطأ في إعادة تعيين الخطوات: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  // دالة جلب إحصائيات المستخدم
  Future<Map<String, dynamic>> getUserStats() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return {'success': false, 'error': 'No user logged in'};
      }

      final doc = await _firestore.collection('users').doc(user.uid).get();
      
      if (!doc.exists) {
        await _firestore.collection('users').doc(user.uid).set({
          'email': user.email,
          'totalSteps': 0,
          'totalPoints': 0,
          'dailyGoal': 10000,
          'createdAt': FieldValue.serverTimestamp(),
        });
        
        return {
          'success': true,
          'data': {
            'totalSteps': 0,
            'totalPoints': 0,
            'dailyGoal': 10000,
            'todayProgress': 0,
          }
        };
      }

      final data = doc.data()!;
      final today = DateTime.now().toIso8601String().split('T')[0];
      
      int todaySteps = 0;
      if (data['dailySteps'] != null && data['dailySteps'][today] != null) {
        todaySteps = data['dailySteps'][today];
      }

      return {
        'success': true,
        'data': {
          'totalSteps': data['totalSteps'] ?? 0,
          'totalPoints': data['totalPoints'] ?? 0,
          'dailyGoal': data['dailyGoal'] ?? 10000,
          'todayProgress': todaySteps,
        }
      };
    } catch (e) {
      print('خطأ في جلب بيانات المستخدم: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  //  دالة تحديث النقاط في Firestore بناءً على النقاط الجديدة
  Future<void> updateUserPoints(int newPoints) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await _firestore.collection('users').doc(user.uid).set({
        'points': newPoints,
        'totalPoints': newPoints,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      
      print(' تم تحديث النقاط في Firestore: $newPoints');
    } catch (e) {
      print(' خطأ في تحديث النقاط: $e');
    }
  }

  // دالة تحديث النقاط بناءً على النقاط الجديدة المحسوبة من الخطوات
  Future<void> updatePoints(int newPoints) async {
    await updateUserPoints(newPoints);
  }

  // دالة تحديث الهدف اليومي
  Future<void> updateDailyGoal(int newGoal) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await _firestore.collection('users').doc(user.uid).update({
        'dailyGoal': newGoal,
      });
    } catch (e) {
      print('خطأ في تحديث الهدف اليومي: $e');
    }
  }
}