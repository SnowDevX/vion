import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountBackend {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;
  
  // UID الحصول على معرف المستخدم
  String? get _userId => _auth.currentUser?.uid;

  //  التحقق مما إذا كان المستخدم جديداً
  Future<bool> isNewUser() async {
    try {
      if (_userId == null) return true;
      
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(_userId)
          .get();
      
      if (userDoc.exists && userDoc.data() != null) {
        var data = userDoc.data() as Map<String, dynamic>;
        
        // إذا كان عنده طول ووزن وهدف، فهو ليس جديداً
        bool hasHeight = data['height'] != null && data['height']! > 0;
        bool hasWeight = data['weight'] != null && data['weight']! > 0;
        bool hasGoal = data['dailyStepsGoal'] != null && data['dailyStepsGoal']! > 0;
        
        return !(hasHeight && hasWeight && hasGoal);
      }
      
      return true;
    } catch (e) {
      print(' خطأ في التحقق من المستخدم الجديد: $e');
      return true;
    }
  }

  //    المستخدم أكمل إعداد الهدف
  Future<void> markGoalAsCompleted() async {
    print(' المستخدم أكمل إعداد الهدف');
  }

  //  جلب بيانات المستخدم من Firestore
  Future<Map<String, dynamic>> loadUserData() async {
    try {
      if (_userId == null) {
        return {
          'success': false,
          'error': 'لا يوجد مستخدم مسجل',
          'data': _getDefaultUserData(),
        };
      }

      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(_userId)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        var data = userDoc.data() as Map<String, dynamic>;
        
        return {
          'success': true,
          'data': {
            'name': data['name'] ?? 'زائر',
            'email': data['email'] ?? 'غير مسجل',
            'height': data['height'] ?? 0,
            'weight': data['weight'] ?? 0,
            'dailyStepsGoal': data['dailyStepsGoal'] ?? 10000,
            'notifications': data['notifications'] ?? true,
            'points': data['totalPoints'] ?? 0,
            'photoURL': null,
          },
        };
      } else {
        // مستخدم جديد 
        await _createNewUser();
        return {
          'success': true,
          'data': _getDefaultUserData(),
        };
      }
    } catch (e) {
      print(' خطأ في تحميل البيانات: $e');
      return {
        'success': false,
        'error': e.toString(),
        'data': _getDefaultUserData(),
      };
    }
  }

  //  حفظ التعديلات في Firestore
  Future<Map<String, dynamic>> saveProfileChanges({
    required String name,
    required String email,
    required int height,
    required int weight,
    required int dailyStepsGoal,
    required bool notifications,
  }) async {
    try {
      if (_userId == null) {
        return {'success': false, 'error': 'لا يوجد مستخدم مسجل'};
      }

      await _firestore.collection('users').doc(_userId).set({
        'name': name.isNotEmpty ? name : 'زائر',
        'email': email.isNotEmpty ? email : 'غير مسجل',
        'height': height,
        'weight': weight,
        'dailyStepsGoal': dailyStepsGoal,
        'dailyGoal': dailyStepsGoal,
        'notifications': notifications,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      return {'success': true, 'message': 'تم حفظ التغييرات بنجاح'};
    } catch (e) {
      print(' خطأ في حفظ البيانات: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  //  إنشاء مستخدم جديد في Firestore
  Future<void> _createNewUser() async {
    if (_userId == null) return;
    
    final today = DateTime.now().toIso8601String().split('T')[0];
    
    await _firestore.collection('users').doc(_userId).set({
      'name': 'زائر',
      'email': _auth.currentUser?.email ?? 'غير مسجل',
      'height': 0,
      'weight': 0,
      'dailyStepsGoal': 0,
      'dailyGoal': 0,
      'todaySteps': 0,
      'todayPoints': 0,
      'totalPoints': 0,
      'lastDate': today,
      'notifications': true,
      'createdAt': FieldValue.serverTimestamp(),
    });
    print(' تم إنشاء مستند جديد للمستخدم: $_userId');
  }

  //  بيانات افتراضية
  Map<String, dynamic> _getDefaultUserData() {
    return {
      'name': 'زائر',
      'email': 'غير مسجل',
      'height': 0,
      'weight': 0,
      'dailyStepsGoal': 10000,
      'notifications': true,
      'points': 0,
      'photoURL': null,
    };
  }

  //  تغيير كلمة المرور
  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user == null || user.email == null) {
        return {'success': false, 'error': 'لا يوجد مستخدم مسجل'};
      }

      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);

      return {'success': true, 'message': 'تم تغيير كلمة المرور بنجاح'};
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'فشل تغيير كلمة المرور';
      if (e.code == 'wrong-password') {
        errorMessage = 'كلمة المرور الحالية غير صحيحة';
      } else if (e.code == 'weak-password') {
        errorMessage = 'كلمة المرور الجديدة ضعيفة';
      }
      return {'success': false, 'error': errorMessage};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  //  تسجيل الخروج
  Future<Map<String, dynamic>> logout() async {
    try {
      await _auth.signOut();
      print(' تم تسجيل الخروج بنجاح');
      return {'success': true};
    } catch (e) {
      print(' خطأ في تسجيل الخروج: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  //  Stream للنقاط
  Stream<int> getPointsStream() {
    if (_userId == null) {
      return Stream.value(0);
    }

    return _firestore
        .collection('users')
        .doc(_userId)
        .snapshots()
        .map((snapshot) {
          if (snapshot.exists) {
            var data = snapshot.data() as Map<String, dynamic>;
            return data['totalPoints'] ?? 0;
          }
          return 0;
        });
  }
}