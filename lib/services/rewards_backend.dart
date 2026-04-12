import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RewardsBackend {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
            return data['totalPoints'] ?? 0;
          }
          return 0;
        });
  }

  //  دالة لاستبدال النقاط
  Future<bool> redeemPoints(int requiredPoints, String rewardTitle) async {
    try {
      String? userId = _auth.currentUser?.uid;
      if (userId == null) return false;

      final userDocRef = _firestore.collection('users').doc(userId);
      
      return await _firestore.runTransaction<bool>((transaction) async {
        final userDoc = await transaction.get(userDocRef);
        
        if (!userDoc.exists) return false;
        
        final currentPoints = userDoc.data()?['totalPoints'] ?? 0;
        
        if (currentPoints < requiredPoints) {
          print(' الرصيد غير كافٍ: $currentPoints < $requiredPoints');
          return false;
        }
        
        final newPoints = currentPoints - requiredPoints;
        
        transaction.update(userDocRef, {
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
        
        print(' تم استبدال $requiredPoints نقطة مقابل $rewardTitle');
        print(' الرصيد الجديد: $newPoints');
        return true;
      });
      
    } catch (e) {
      print(' خطأ في استبدال النقاط: $e');
      return false;
    }
  }

  //  دالة لجلب الرصيد الحالي
  Future<int> getCurrentPoints() async {
    try {
      String? userId = _auth.currentUser?.uid;
      if (userId == null) return 0;

      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) return 0;

      return userDoc.data()?['totalPoints'] ?? 0;
    } catch (e) {
      print(' خطأ في جلب النقاط: $e');
      return 0;
    }
  }
}