import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:battery_plus/battery_plus.dart';

class ChargingBackend {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Battery _battery = Battery();
  
  Stream<BatteryState>? _batteryStateStream;
  StreamSubscription<BatteryState>? _batterySubscription;

  String? get _userId => _auth.currentUser?.uid;

  //  جلب النقاط الحالية
  Future<int> getCurrentPoints() async {
    try {
      if (_userId == null) return 0;
      final doc = await _firestore.collection('users').doc(_userId).get();
      if (doc.exists) {
        return doc['totalPoints'] ?? 0;
      }
      return 0;
    } catch (e) {
      print(' خطأ في جلب النقاط: $e');
      return 0;
    }
  }

  //  جلب شحن البطارية الحالي (0-100)
  Future<int> getCurrentBatteryLevel() async {
    try {
      return await _battery.batteryLevel;
    } catch (e) {
      print(' خطأ في جلب شحن البطارية: $e');
      return 0;
    }
  }

  //  مراقبة حالة الشحن
  Stream<BatteryState> get batteryState => _battery.onBatteryStateChanged;

  //  خصم النقاط بعد الشحن
  Future<bool> deductPoints(int pointsToDeduct) async {
    try {
      if (_userId == null) return false;
      
      final docRef = _firestore.collection('users').doc(_userId);
      final doc = await docRef.get();
      
      if (!doc.exists) return false;
      
      final currentPoints = doc['totalPoints'] ?? 0;
      
      if (currentPoints < pointsToDeduct) {
        print(' الرصيد غير كافٍ: $currentPoints < $pointsToDeduct');
        return false;
      }
      
      final newPoints = currentPoints - pointsToDeduct;
      
      await docRef.update({
        'totalPoints': newPoints,
        'lastCharge': FieldValue.serverTimestamp(),
        'chargeHistory': FieldValue.arrayUnion([
          {
            'points': pointsToDeduct,
            'date': DateTime.now().toIso8601String(),
          }
        ]),
      });
      
      print(' تم خصم $pointsToDeduct نقطة. الرصيد المتبقي: $newPoints');
      return true;
      
    } catch (e) {
      print(' خطأ في خصم النقاط: $e');
      return false;
    }
  }

  @override
  void dispose() {
    _batterySubscription?.cancel();
  }
}