import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RewardsBackend {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ✅ دالة لجلب رصيد النقاط المباشر
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
            // ✅ نحاول ناخذ النقاط من عدة حقول محتملة
            int points = data['points'] ?? 
                        data['totalPoints'] ?? 
                        data['rewardPoints'] ?? 
                        0;
            return points;
          }
          return 0;
        });
  }

  // ✅ دالة لاستبدال النقاط
  Future<bool> redeemPoints(int requiredPoints, String rewardTitle) async {
    try {
      String? userId = _auth.currentUser?.uid;
      if (userId == null) return false;

      // نجيب الرصيد الحالي
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userId)
          .get();

      if (!userDoc.exists) return false;

      var data = userDoc.data() as Map<String, dynamic>;
      int currentPoints = data['points'] ?? 
                         data['totalPoints'] ?? 
                         data['rewardPoints'] ?? 
                         0;

      // نتحقق إذا الرصيد يكفي
      if (currentPoints < requiredPoints) {
        return false;
      }

      // نخصم النقاط
      int newPoints = currentPoints - requiredPoints;

      // نحدث في قاعدة البيانات
      await _firestore.collection('users').doc(userId).update({
        'points': newPoints,
        'totalPoints': newPoints,
        'lastRedeem': FieldValue.serverTimestamp(),
        'redeemHistory': FieldValue.arrayUnion([
          {
            'reward': rewardTitle,
            'points': requiredPoints,
            'date': DateTime.now().toIso8601String(),
          }
        ]),
      });

      print('✅ تم استبدال $requiredPoints نقطة مقابل $rewardTitle');
      return true;

    } catch (e) {
      print('❌ خطأ في استبدال النقاط: $e');
      return false;
    }
  }

  // ✅ دالة للتأكد من الرصيد
  Future<int> getCurrentPoints() async {
    try {
      String? userId = _auth.currentUser?.uid;
      if (userId == null) return 0;

      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userId)
          .get();

      if (!userDoc.exists) return 0;

      var data = userDoc.data() as Map<String, dynamic>;
      return data['points'] ?? 
             data['totalPoints'] ?? 
             data['rewardPoints'] ?? 
             0;

    } catch (e) {
      print('❌ خطأ في جلب النقاط: $e');
      return 0;
    }
  }
}