import 'package:flutter/material.dart';
import 'package:grandustionapp/generated/l10n.dart';
import 'package:grandustionapp/services/rewards_backend.dart';
import 'package:grandustionapp/services/home_backend.dart';

class RewardsPage extends StatefulWidget {
  const RewardsPage({super.key});

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  final RewardsBackend _backend = RewardsBackend();
  final HomeBackend _homeBackend = HomeBackend();

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF0F1A17),
      appBar: _buildAppBar(context, lang),
      body: _buildBody(context, lang),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, S lang) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        lang.rewards,
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      centerTitle: true,
    );
  }

  Widget _buildBody(BuildContext context, S lang) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildHeader(lang),
          const SizedBox(height: 30),
          _buildPointsBalance(lang),
          const SizedBox(height: 25),
          _buildRewardsList(context, lang),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildHeader(S lang) {
    return Center(
      child: Column(
        children: [
          Text(
            lang.rewardsCenter,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            lang.redeemYourPoints,
            style: const TextStyle(color: Colors.white60, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsBalance(S lang) {
    return StreamBuilder<int>(
      stream: _backend.getPointsStream(),
      builder: (context, snapshot) {
        int points = _homeBackend.points;
        
        if (points == 0) {
          points = snapshot.data ?? 0;
        }

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF2ECC71),
                const Color(0xFF27AE60),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2ECC71).withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.flash_on,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    lang.availableBalance,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '$points ${lang.points}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRewardsList(BuildContext context, S lang) {
    List<RewardItem> rewards = [
      RewardItem(
        title: lang.freeCharging30min,
        description: lang.freeChargingDesc,
        points: 50,
        icon: Icons.ev_station,
      ),
      RewardItem(
        title: lang.discount10Percent,
        description: lang.discountDesc,
        points: 100,
        icon: Icons.percent,
      ),
      RewardItem(
        title: lang.internet1GB,
        description: lang.internetDesc,
        points: 150,
        icon: Icons.wifi,
      ),
      RewardItem(
        title: lang.freeCarWash,
        description: lang.carWashDesc,
        points: 500,
        icon: Icons.local_car_wash,
      ),
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: rewards.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: RewardCard(
            reward: rewards[index],
            backend: _backend,
            lang: lang,
          ),
        );
      },
    );
  }
}

// نموذج البيانات
class RewardItem {
  final String title;
  final String description;
  final int points;
  final IconData icon;

  const RewardItem({
    required this.title,
    required this.description,
    required this.points,
    required this.icon,
  });
}

// كارد المكافأة
class RewardCard extends StatefulWidget {
  final RewardItem reward;
  final RewardsBackend backend;
  final S lang;

  const RewardCard({
    super.key,
    required this.reward,
    required this.backend,
    required this.lang,
  });

  @override
  State<RewardCard> createState() => _RewardCardState();
}

class _RewardCardState extends State<RewardCard> {
  bool _isRedeeming = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF182A25),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.tealAccent.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          _buildRedeemButton(),
          const Spacer(),
          _buildRewardDetails(),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.tealAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              widget.reward.icon,
              color: Colors.tealAccent,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRedeemButton() {
    return _isRedeeming
        ? const SizedBox(
            width: 60,
            height: 35,
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.tealAccent,
                strokeWidth: 2,
              ),
            ),
          )
        : ElevatedButton(
            onPressed: _redeemReward,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.tealAccent,
              foregroundColor: Colors.black,
              minimumSize: const Size(60, 35),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              widget.lang.redeem,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          );
  }

  Widget _buildRewardDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          widget.reward.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          widget.reward.description,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${widget.reward.points} ${widget.lang.points}',
          style: const TextStyle(
            color: Colors.tealAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Future<void> _redeemReward() async {
    int currentPoints = await widget.backend.getCurrentPoints();

    if (currentPoints < widget.reward.points) {
      _showInsufficientPointsDialog();
      return;
    }

    _showConfirmationDialog();
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF182A25),
        title: Text(
          widget.lang.confirmRedeem,
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          widget.lang.redeemConfirmation(widget.reward.points, widget.reward.title),
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              widget.lang.cancel,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _processRedemption();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.tealAccent,
              foregroundColor: Colors.black,
            ),
            child: Text(widget.lang.confirm),
          ),
        ],
      ),
    );
  }

  void _showInsufficientPointsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF182A25),
        title: Text(
          widget.lang.insufficientPoints,
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          widget.lang.needPoints(widget.reward.points),
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.tealAccent,
              foregroundColor: Colors.black,
            ),
            child: Text(widget.lang.ok),
          ),
        ],
      ),
    );
  }

  Future<void> _processRedemption() async {
    setState(() => _isRedeeming = true);

    bool success = await widget.backend.redeemPoints(
      widget.reward.points,
      widget.reward.title,
    );

    if (!mounted) return;

    setState(() => _isRedeeming = false);

    if (success) {
      _showSuccessMessage();
    } else {
      _showErrorMessage();
    }
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.lang.redeemSuccess(widget.reward.title),
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.tealAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showErrorMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.lang.redeemError,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}