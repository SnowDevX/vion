import 'package:flutter/material.dart';
import 'package:grandustionapp/generated/l10n.dart';
import 'package:grandustionapp/services/rewards_backend.dart';

class RewardsPage extends StatefulWidget {
  const RewardsPage({super.key});

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  final RewardsBackend _backend = RewardsBackend();
  
  List<RewardItem> _getRewards(S lang) {
    return [
      RewardItem(
        id: '1',
        name: lang.discount10,
        pointsRequired: 100,
        description: lang.discount10Desc,
      ),
      RewardItem(
        id: '2',
        name: lang.freeShipping,
        pointsRequired: 500,
        description: lang.freeShippingDesc,
      ),
      RewardItem(
        id: '3',
        name: lang.coupon50,
        pointsRequired: 1000,
        description: lang.coupon50Desc,
      ),
    ];
  }

  Future<void> _redeemReward(RewardItem reward, S lang) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF182A25),
        title: Text(
          lang.redeemReward,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        content: Text(
          '${lang.confirmRedeem}"${reward.name}" ${reward.pointsRequired} ${lang.confirmRedeemEnd}',
          style: const TextStyle(color: Colors.white70, fontSize: 16),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              lang.cancel,
              style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF44C37F),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(lang.confirm, style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(color: Color(0xFF44C37F)),
        ),
      );
      
      final success = await _backend.redeemPoints(reward.pointsRequired, reward.name);
      
      Navigator.pop(context);
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ ${lang.redeemSuccess}"${reward.name}"${lang.redeemSuccessEnd}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(' ${lang.redeemFailed}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context)!;
    final isRTL = Localizations.localeOf(context).languageCode == 'ar';
    final rewards = _getRewards(lang);

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFF0F1A17),
        body: SafeArea(
          child: Column(
            children: [
              // ✅ Header مع النقاط
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: const BoxDecoration(
                  color: Color(0xFF0F1A17),
                ),
                child: Column(
                  children: [
                    Text(
                      lang.rewards,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // ✅ StreamBuilder لعرض النقاط بشكل تلقائي
                    StreamBuilder<int>(
                      stream: _backend.getPointsStream(),
                      initialData: 0,
                      builder: (context, snapshot) {
                        final userPoints = snapshot.data ?? 0;
                        
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF44C37F), Color(0xFF3DDC97)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF44C37F).withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.bolt, color: Colors.black, size: 24),
                              const SizedBox(width: 8),
                              Text(
                                '$userPoints',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                lang.points,
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 10),
              
              // ✅ قائمة المكافآت
              Expanded(
                child: StreamBuilder<int>(
                  stream: _backend.getPointsStream(),
                  initialData: 0,
                  builder: (context, snapshot) {
                    final userPoints = snapshot.data ?? 0;
                    
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: rewards.length,
                      itemBuilder: (context, index) {
                        final reward = rewards[index];
                        final canRedeem = userPoints >= reward.pointsRequired;
                        return _buildRewardCard(reward, canRedeem, lang, userPoints);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRewardCard(RewardItem reward, bool canRedeem, S lang, int userPoints) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF182A25), const Color(0xFF1F3A32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: canRedeem ? const Color(0xFF44C37F) : Colors.grey.withOpacity(0.3),
          width: canRedeem ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF44C37F).withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.card_giftcard,
              color: Color(0xFF44C37F),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reward.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  reward.description,
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF44C37F).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.bolt, color: Color(0xFF44C37F), size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${reward.pointsRequired} ${lang.points}',
                        style: TextStyle(
                          color: canRedeem ? const Color(0xFF44C37F) : Colors.grey.shade500,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          //  زر الاستبدال
          ElevatedButton(
            onPressed: canRedeem ? () => _redeemReward(reward, lang) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: canRedeem ? const Color(0xFF44C37F) : Colors.grey.shade700,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: canRedeem ? 2 : 0,
            ),
            child: Text(
              lang.redeem,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: canRedeem ? Colors.black : Colors.grey.shade300,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// نموذج المكافأة
class RewardItem {
  final String id;
  final String name;
  final int pointsRequired;
  final String description;

  RewardItem({
    required this.id,
    required this.name,
    required this.pointsRequired,
    required this.description,
  });
}