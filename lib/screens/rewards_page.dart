import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// 🎨 الألوان (مطابقة للصورة)
const Color bgColor = Color(0xFF0F2F2E);
const Color cardColor = Color(0xFF163F3D);
const Color accentColor = Color(0xFF3DDC97);
const Color textLight = Color(0xFFE0F2F1);
const Color textMuted = Color(0xFF9FBFBC);

class RewardsPage extends StatefulWidget {
  const RewardsPage({Key? key}) : super(key: key);

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  final User? user = FirebaseAuth.instance.currentUser;

  /// 🔥 جلب نقاط المستخدم
  Future<int> getUserPoints() async {
    if (user == null) return 0;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    return doc.data()?['points'] ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'مركز المكافآت',
          style: TextStyle(
            color: textLight,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textLight),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'استبدل تفاعلك بمكافآت مميزة',
              style: TextStyle(color: textMuted),
            ),
            const SizedBox(height: 24),

            /// 💎 كرت الرصيد
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'رصيدك المتاح',
                    style: TextStyle(color: textMuted),
                  ),
                  const SizedBox(height: 10),

                  FutureBuilder<int>(
                    future: getUserPoints(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Text(
                          'جاري التحميل...',
                          style: TextStyle(color: textLight),
                        );
                      }

                      return Text(
                        '${snapshot.data} نقطة',
                        style: const TextStyle(
                          color: accentColor,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// 🎁 المكافآت
            _buildRewardCard(
              title: 'شحن مجاني',
              description: '30 دقيقة شحن بدون مقابل',
              points: 50,
            ),

            const SizedBox(height: 16),

            _buildRewardCard(
              title: 'رصيد طاقة إضافي',
              description: '100 نقطة طاقة إضافية',
              points: 200,
            ),
          ],
        ),
      ),
    );
  }

  /// 🧩 كرت المكافأة
  Widget _buildRewardCard({
    required String title,
    required String description,
    required int points,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: textLight,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(color: textMuted),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$points نقطة',
              style: const TextStyle(
                color: accentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}