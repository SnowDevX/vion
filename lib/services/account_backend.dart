import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountBackend {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  // ✅ دالة لجلب بيانات المستخدم مع النقاط
  Future<Map<String, dynamic>> loadUserData() async {
    try {
      User? user = _auth.currentUser;
      
      if (user == null) {
        return {
          'success': false,
          'error': 'No user logged in',
          'data': _getDefaultUserData(),
        };
      }

      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        var data = userDoc.data() as Map<String, dynamic>;
        
        // ✅ جلب النقاط من جميع الحقول الممكنة
        int points = data['points'] ?? 
                     data['totalPoints'] ?? 
                     data['energyPoints'] ?? 
                     data['rewardPoints'] ?? 
                     0;

        return {
          'success': true,
          'data': {
            'name': data['name'] ?? user.displayName ?? 'زائر',
            'email': data['email'] ?? user.email ?? 'غير مسجل',
            'height': data['height'] ?? 176,
            'weight': data['weight'] ?? 82,
            'dailyStepsGoal': data['dailyStepsGoal'] ?? data['dailyGoal'] ?? 10000,
            'notifications': data['notifications'] ?? true,
            'points': points, // ✅ النقاط هنا
            'photoURL': user.photoURL,
          },
        };
      } else {
        // إنشاء مستخدم جديد إذا لم يكن موجود
        await _createNewUser(user);
        return {
          'success': true,
          'data': _getDefaultUserData(user),
        };
      }
    } catch (e) {
      print('❌ خطأ في تحميل البيانات: $e');
      return {
        'success': false,
        'error': e.toString(),
        'data': _getDefaultUserData(),
      };
    }
  }

  // ✅ دالة لحفظ التعديلات
  Future<Map<String, dynamic>> saveProfileChanges({
    required String name,
    required String email,
    required int height,
    required int weight,
    required int dailyStepsGoal,
    required bool notifications,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        return {'success': false, 'error': 'No user logged in'};
      }

      // تحديث الاسم في Auth إذا تغير
      if (name != user.displayName) {
        await user.updateDisplayName(name);
      }

      // تحديث البيانات في Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'name': name,
        'email': email,
        'height': height,
        'weight': weight,
        'dailyStepsGoal': dailyStepsGoal,
        'dailyGoal': dailyStepsGoal, // للتوافق
        'notifications': notifications,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      return {'success': true, 'message': 'Profile updated successfully'};
    } catch (e) {
      print('❌ خطأ في حفظ البيانات: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  // ✅ دالة لتغيير كلمة المرور
  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user == null || user.email == null) {
        return {'success': false, 'error': 'No user logged in'};
      }

      // إعادة المصادقة
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);

      return {'success': true, 'message': 'Password changed successfully'};
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

  // ✅ دالة تسجيل الخروج
  Future<Map<String, dynamic>> logout() async {
    try {
      await _auth.signOut();
      return {'success': true};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // ✅ دالة مساعدة لإنشاء مستخدم جديد
  Future<void> _createNewUser(User user) async {
    await _firestore.collection('users').doc(user.uid).set({
      'name': user.displayName ?? 'زائر',
      'email': user.email,
      'height': 176,
      'weight': 82,
      'dailyStepsGoal': 10000,
      'dailyGoal': 10000,
      'points': 0,
      'totalPoints': 0,
      'notifications': true,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // ✅ دالة مساعدة للبيانات الافتراضية
  Map<String, dynamic> _getDefaultUserData([User? user]) {
    return {
      'name': user?.displayName ?? 'زائر',
      'email': user?.email ?? 'غير مسجل',
      'height': 176,
      'weight': 82,
      'dailyStepsGoal': 10000,
      'notifications': true,
      'points': 0,
      'photoURL': user?.photoURL,
    };
  }

  // ✅ دالة لجلب النقاط فقط (للتحديث المباشر)
  Stream<int> getPointsStream() {
    String? userId = _auth.currentUser?.uid;
    
    if (userId == null) {
      return Stream.value(0);
    }

    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
          if (snapshot.exists) {
            var data = snapshot.data() as Map<String, dynamic>;
            int points = data['points'] ?? 
                        data['totalPoints'] ?? 
                        data['energyPoints'] ?? 
                        data['rewardPoints'] ?? 
                        0;
            return points;
          }
          return 0;
        });
  }
}